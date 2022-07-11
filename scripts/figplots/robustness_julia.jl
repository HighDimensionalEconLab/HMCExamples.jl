using StatsPlots
using HDF5, MCMCChains, MCMCChainsStorage
using Dates
using JSON
using Statistics
using Base.Iterators
using Measures

function cummean!(p, xs, array::Vector; title = "", fancy_time = -1)
    M = zeros(length(array))
    S = zeros(Union{Float64, Missing}, length(array))

    for i in 1:length(array)
        M[i] = mean(skipmissing(array[1:i]))
        S[i] = std(skipmissing(array[1:i]))
    end

    return plot!(p, xs, M, label=false, legend=false, title=title, alpha=0.5, xlim=(0,1.1),
                xticks = (range(0, 1, length=4), ["0 minutes", "", "", "$fancy_time"]),
                xlabel = "Compute time", left_margin = 15mm)
end

include_vars = ["α", "β_draw", "ρ"]

var_ylim = Dict(
    "α" => (0.2, 0.45), 
    "β_draw" => (0,1), 
    "ρ" => (0,1)
)

mapping = Dict("α"=>"alpha", "β_draw"=>"beta_draw", "ρ"=>"rho")
pseudotrues = Dict("α"=>0.3, "β_draw"=>0.2, "ρ"=>0.9)

for (oldfoldername, batch) in [("kalman", "1_kalman"), ("1st-joint", "1_joint"), ("2nd-joint", "2_joint")]
    println("generating plots")
    chains_arr = []
    chains_arr_durations = []
    for (package, alpha) in [("first", "0_25"), ("second", "0_3"), ("third", "0_35"), ("fourth", "0_4")]
        for beta_draw in ["0_1", "0_175", "0_25", "0_325"]
            for rho in ["0_4625", "0_625", "0_7875", "0_95"]
                chain = h5open(".experiments/robustness_julia/$(package)/robustness_rbc_$(batch)_$(alpha)$(beta_draw)$(rho)/chain.h5", "r") do f
                    read(f, Chains)
                end
                push!(chains_arr, chain)
                results = JSON.parsefile(".experiments/robustness_julia/$(package)/robustness_rbc_$(batch)_$(alpha)$(beta_draw)$(rho)/result.json")
                push!(chains_arr_durations, results["time_elapsed"])
            end
        end
    end
    println("  deserialization complete")

    durations = chains_arr_durations ./ 4
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
    for ((i, c), (j, variable)) in collect(product(collect(enumerate(chains_arr)), collect(enumerate(include_vars))))
        println(i, " ", variable)
        d = range(0, adj_durations[i], length=size(c, 1))
        # plot!(p, d, c.value.data[:,1,1], alpha=0.15, legend=false, title=folder)
        cummean!(p[j], d, c[:,variable,1].data; fancy_time=fancy_time)
        plot!(p1[j], d, c[:,variable,1].data, 
            alpha=0.3, legend=false, xlim=(0,1.1),
            ylim = var_ylim[variable],
            xticks = (range(0, adj_durations[i], length=4), ["0 minutes", "", "", "$fancy_time"]),
            xlabel = "Compute time", left_margin = 15mm)
        hline!(p[j], [pseudotrues[variable]], linestyle = :dash, color = :black)
        hline!(p1[j], [pseudotrues[variable]], linestyle = :dash, color = :black)
    end

    for (k, var) in collect(enumerate(include_vars))
        savefig(p[k], ".figures/cummean_$(mapping[var])_$(oldfoldername).png")
        savefig(p1[k], ".figures/trace_$(mapping[var])_$(oldfoldername).png")
    end

    # display(durations ./ max_time)
end
