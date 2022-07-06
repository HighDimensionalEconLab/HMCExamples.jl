using StatsPlots
using MCMCChains
using Dates
using Statistics
using Base.Threads, Base.Iterators
using Measures

function cummean!(p, xs, array::Vector; title = "", fancy_time = -1)
    M = zeros(length(array))
    S = zeros(Union{Float64, Missing}, length(array))

    for i in 1:length(array)
        M[i] = mean(skipmissing(array[1:i]))
        S[i] = std(skipmissing(array[1:i]))
    end

    return plot!(p, xs, M, label=false, title=title, alpha=0.5, xlim=(0,1.1),
                xticks = (range(0, 1, length=4), ["0 minutes", "", "", "$fancy_time"]),
                xlabel = "Compute time")
end

include_vars = ["α", "β_draw", "ρ"]

var_ylim = Dict(
    "α" => (0.2, 0.45), 
    "β_draw" => (0,1), 
    "ρ" => (0,1)
)

mapping = Dict("α"=>"alpha", "β_draw"=>"beta_draw", "ρ"=>"rho")

for (oldfoldername, batch) in [("kalman", "1_kalman"), ("1st-joint", "1_joint"), ("2nd-joint", "2_joint")]
    folder = ".experiments/robustness_julia"
    files = readdir(folder)
    println("generating plots")
    chains_arr = []
    for file in files
        if occursin(batch, file)
            chain = h5open(".experiments/robustness_julia/$(file)/chain.h5", "r") do f
                read(f, Chains)
            end
            push!(chains_arr, chain)
        end
    end
    println("  deserialization complete")

    durations = [(chain.info.stop_time - chain.info.start_time) for chain in chains_arr] ./ 2

    pct90 = quantile(durations, [0.75])[1]

    # inds = durations .<= pct90
    # chains_arr = chains_arr[inds]
    # durations = durations[inds]

    # max_time = maximum(durations)
    max_time = pct90
    adj_durations = durations ./ max_time

    fancy_time = round(Second(floor(max_time)), Minute)
    p = []
    p1 = []
    for _ in include_vars
        push!(p, plot())
        push!(p1, plot())
    end
    @threads for ((i, c), (j, variable)) in collect(product(collect(enumerate(chains_arr)), collect(enumerate(include_vars))))
        d = range(0, adj_durations[i], length=size(c, 1))
        # plot!(p, d, c.value.data[:,1,1], alpha=0.15, legend=false, title=folder)
        cummean!(p[j], d, c[:,variable,1].data; fancy_time=fancy_time)
        plot!(p1[j], d, c[:,variable,1].data, 
            alpha=0.3, legend=false, xlim=(0,1.1),
            ylim = var_ylim[variable],
            xticks = (range(0, adj_durations[i], length=4), ["0 minutes", "", "", "$fancy_time"]),
            xlabel = "Compute time")
        savefig(p[j], ".figures/cummean_$(mapping[variable])_$(oldfoldername).png")
        savefig(p1[j], ".figures/trace_$(mapping[variable])_$(oldfoldername).png")
    end


    # display(durations ./ max_time)
end
