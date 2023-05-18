using MCMCChains, CSV, DataFrames, StatsPlots, Serialization, Measures
using HMCExamples, DynamicPPL

function generate_trace_plots(run, chain, include_vars, pseudotrues, marker)
    println("generating trace plots for $(run) $(marker)")
    trace_plot = traceplot(chain[include_vars], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm, right_margin = 10mm)
    hline!(trace_plot, pseudotrues, linestyle = :dash, color = :black, label = "", size = (600, 1000))
    savefig(trace_plot, ".paper_results/traceplots_$(run)_$(marker).png")
end

function generate_density_plots_1(chain_marginal, chain_joint_1, chain_dynare_1, include_vars, pseudotrues, marker)
    println("generating density plots for $(marker)")
    density_plot = density(chain_marginal[include_vars], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm, label = "NUTS, kalman")
    density!(density_plot, chain_joint_1[include_vars], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm, label = "NUTS, joint")
    density!(density_plot, chain_dynare_1[include_vars], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm, label = "RWMH, kalman")
    vline!(density_plot, pseudotrues, linestyle = :dash, color = :black, label = "", legend = :outertopright, size = (600, 1000))
    savefig(density_plot, ".paper_results/densityplots_sgu_1_$(marker).png")
end

function generate_density_plots_2(chain_joint_2, chain_dynare_2, include_vars, pseudotrues, marker)
    println("generating density plots for $(marker)")
    density_plot = density(chain_joint_2[include_vars], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm, label = "NUTS, joint")
    density!(density_plot, chain_dynare_2[include_vars], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm, label = "RWMH, particle")
    vline!(density_plot, pseudotrues, linestyle = :dash, color = :black, label = "", legend = :outertopright, size = (600, 1000))
    savefig(density_plot, ".paper_results/densityplots_sgu_2_$(marker).png")
end

function generate_epsilon_plots(run, chain, shocks)
    println("generating epsilon plots for ", run)
    params = JSON.parsefile(".replication_results/$(run)/result.json")
    T = params["T"]
    
    symbol_to_int(s) = parse(Int, replace(string(s), "ϵ_draw["=>"", "]"=>""))
    symbollist = reshape([Symbol("ϵ_draw[$a]") for a in 1:T*3], 3, T)
    labels = ["σ_e", "σ_u", "σ_v"]
    plots = []

    # Import the true shock values
    ϵ_true = Matrix(DataFrame(CSV.File("data/$(shocks).csv")))

    for i in 1:3
        ϵ_chain = sort(chain[:, symbollist[i, :], 1], lt = (x,y) -> symbol_to_int(x) < symbol_to_int(y))
        tmp = describe(ϵ_chain)
        ϵ_mean = tmp[1][:, 2]
        ϵ_std = tmp[1][:, 3]
        
        # Plot and save
        ϵ_plot = plot(ϵ_mean[2:end], ribbon=2 * ϵ_std[2:end], title = labels[i])
        ϵ_plot = plot!(ϵ_true[:, i], label="True values")
        push!(plots, ϵ_plot)
    end
    # TODO: does the layout still need to be 6x1?
    ϵ_plot = plot(plots[1], plots[2], plots[3], layout = (6, 1), size = (1600, 900), left_margin = 10mm, bottom_margin = 5mm, legend = false)
    savefig(ϵ_plot, ".paper_results/epsilons_$(run).png")
end

include_vars_1 = ["α", "β_draw", "γ"]
pseudotrues_1 = [0.32 4 2.0]
include_vars_2 = ["ρ", "ρ_u", "ρ_v", "ψ"]
pseudotrues_2 = [0.42 0.2 0.4 0.000742]

include_vars_dynare = ["α", "β_draw", "γ", "ρ", "ρ_u", "ρ_v", "ψ"]
order_dynare = (x, y)->findfirst(i->i==string(x), include_vars_dynare) < findfirst(i->i==string(y), include_vars_dynare)

julia_runs = [
    "sgu_1_kalman_200",
    "sgu_1_joint_200",
    "sgu_2_joint_200",
]

dynare_runs = [
    "sgu_1_200_dynare",
    "sgu_2_200_dynare",
]

chain_map = Dict()

for run in julia_runs
    chain_map[run] = deserialize(".replication_results/$(run)/chain.jls")
end

for run in dynare_runs
    chain_map[run] = sort(deserialize(".replication_results/$(run)/chain.jls"), lt = order_dynare)
end

for run in vcat(julia_runs, dynare_runs)
    generate_trace_plots(run, chain_map[run], include_vars_1, pseudotrues_1, "pt1")
    generate_trace_plots(run, chain_map[run], include_vars_2, pseudotrues_2, "pt2")
end

generate_density_plots_1(chain_map["sgu_1_kalman_200"], chain_map["sgu_1_joint_200"], chain_map["sgu_1_200_dynare"], include_vars_1, pseudotrues_1, "pt1")
generate_density_plots_1(chain_map["sgu_1_kalman_200"], chain_map["sgu_1_joint_200"], chain_map["sgu_1_200_dynare"], include_vars_2, pseudotrues_2, "pt2")
generate_density_plots_2(chain_map["sgu_2_joint_200"], chain_map["sgu_2_200_dynare"], include_vars_1, pseudotrues_1, "pt1")
generate_density_plots_2(chain_map["sgu_2_joint_200"], chain_map["sgu_2_200_dynare"], include_vars_2, pseudotrues_2, "pt2")

generate_epsilon_plots("sgu_1_joint_200", chain_map["sgu_1_joint_200"], "sgu_1_joint_shocks_200")
generate_epsilon_plots("sgu_2_joint_200", chain_map["sgu_2_joint_200"], "sgu_2_joint_shocks_200")
