using StatsPlots
using MCMCChains, Serialization
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

for (oldfoldername, run) in [("dynare_chains_1", "rbc_1"), ("dynare_chains_2", "rbc_2")]
    chains_arr = []
    chains_arr_durations = []
    for alpha in ["1", "2", "3", "4"]
        for beta_draw in ["1", "2", "3", "4"]
            for rho in ["2", "3", "4", "5"]
                chain = deserialize(".replication_results/dynare_robustness/$(run)_robustness_$(alpha)$(beta_draw)$(rho)/chain.jls")
                push!(chains_arr, chain)
                # TODO: load runtimes properly
                results = JSON.parsefile(".replication_results/dynare_robustness/$(run)_robustness_$(alpha)$(beta_draw)$(rho)/result.json")
                push!(chains_arr_durations, results["time_elapsed"])
            end
        end
    end
    println("  deserialization complete")
    
    durations = chains_arr_durations
    max_time = quantile(durations, [0.75])[1]
    adj_durations = durations ./ max_time

    fancy_time = round(Second(floor(max_time)), Minute)
    p = []
    p1 = []
    for _ in include_vars
        push!(p, plot())
        push!(p1, plot())
    end

    # may want to use Threads.@threads in front of the for expression if multithreaded machine available
    for ((i, c), (j, variable)) in collect(product(collect(enumerate(chains_arr)), collect(enumerate(include_vars))))
        println(i, " ", variable)
        d = range(0, adj_durations[i], length=size(c, 1))
        cummean!(p[j], d, c[:,variable,1].data; fancy_time=fancy_time)
        plot!(p1[j], d, c[:,variable,1].data, 
            alpha=0.3, legend=false, xlim=(0,1.1),
            ylim = var_ylim[variable],
            xticks = (range(0, 1, length=4), ["0 minutes", "", "", "$fancy_time"]),
            xlabel = "Compute time", left_margin = 15mm)
        hline!(p[j], [pseudotrues[variable]], linestyle = :dash, color = :black)
        hline!(p1[j], [pseudotrues[variable]], linestyle = :dash, color = :black)
    end

    for (k, var) in collect(enumerate(include_vars))
        savefig(p[k], ".paper_results/cummean_$(mapping[var])_$(oldfoldername).png")
        savefig(p1[k], ".paper_results/trace_$(mapping[var])_$(oldfoldername).png")
    end
end
