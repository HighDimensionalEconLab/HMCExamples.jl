using HMCExamples
using StatsPlots
using MCMCChains
using Serialization
using Dates
using Statistics

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

titles = Dict(
    "1st-joint" => "NUTS, First-order joint",
    "2nd-joint" => "NUTS, Second-order joint",
    "kalman" => "NUTS, First-order Kalman",
    "dynare_chains_1" => "Dynare, first-order joint",
    "dynare_chains_2" => "Dynare, second-order joint",
)

dynare_times = Dict(
    "dynare_chains_1" => Minute(2),
    "dynare_chains_2" => Minute(8)
)

for folder in [("joint-1", "main_rbc_1_joint"), ("joint-2", "main_rbc_2_joint"), ("kalman", "main_rbc_1_kalman")]
    name, scriptname = folder
    println("generating plots")
    chains_arr = []
    for i in 0:9
        chain = deserialize("results/rbc-$name-plots/rbc-$name-plots-exp$i/results/$scriptname/chain.jls")
        push!(chains_arr, chain)
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

    for variable in include_vars
        @info "" variable max_time folder

        p = plot()
        p1 = plot()
        for i in 1:length(chains_arr)
            c = chains_arr[i]
            d = range(0, adj_durations[i], length=size(c, 1))
            # plot!(p, d, c.value.data[:,1,1], alpha=0.15, legend=false, title=folder)
            cummean!(p, d, c[:,variable,1].data; fancy_time=fancy_time)
            plot!(p1, d, c[:,variable,1].data, 
                alpha=0.3, legend=false, xlim=(0,1.1),
                ylim = var_ylim[variable],
                xticks = (range(0, adj_durations[i], length=4), ["0 minutes", "", "", "$fancy_time"]),
                xlabel = "Compute time")
        end
        savefig(p, "figures/cummean_$(variable)_$name.png")
        savefig(p1, "figures/trace_$(variable)_$name.png")
    end


    # display(durations ./ max_time)
end

#using MAT

dynare_folders = [
    
]

# file = matread("8kparticles50kmh_draws_nonlinear_84-07.mat")

# data = [file["Thetasim"]' file["logposterior"]]
# chain = Chains(data)

# plot(data, colordim = :parameter)
# ~

for folder in dynare_folders
    files = readdir(folder, join=true)

    fancy_time = dynare_times[basename(folder)]

    for variable in include_vars
        p = plot()
        p1 = plot()

        for file in files
            mat = matread(file)
            data = [mat["x2"] mat["logpo2"]]
            c = Chains(data, ["α", "β_draw", "ρ", "lp"])
            d = range(0, 1, length=size(c, 1))

            cummean!(p, d, c[:,variable,1].data; fancy_time=fancy_time)
            plot!(p1, d, c[:,variable,1].data,
                alpha=0.3, legend=false, xlim=(0,1.1),
                ylim = var_ylim[variable],
                xticks = (range(0, 1, length=4), ["0 minutes", "", "", "$fancy_time"]),
                xlabel = "Compute time")
        end
        
        xlabel!(p, "Compute time")

        savefig(
            p,
            "figures/results/robustness-plots/cummean_$(variable)_$(basename(folder)).png"
        )
        savefig(
            p1,
            "figures/results/robustness-plots/trace_$(variable)_$(basename(folder)).png"
        )
    end
end
