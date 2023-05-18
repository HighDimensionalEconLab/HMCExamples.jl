using MCMCChains, CSV, DataFrames, StatsPlots, Serialization, Measures
using HMCExamples, DynamicPPL

function generate_stats_plots(run, chain, include_vars, pseudotrues)
    println("generating stats plots for ", run)

    # trace plots
    trace_plot = traceplot(chain[include_vars], left_margin = 15mm, bottom_margin = 10mm, top_margin = 5mm)
    hline!(trace_plot, pseudotrues, linestyle = :dash, color = :black, label = "", size = (600, 1000))
    savefig(trace_plot, ".paper_results/traceplots_$(run).png")

    # density
    density_plot = density(chain[include_vars], left_margin = 15mm, bottom_margin = 10mm, top_margin = 5mm)
    vline!(density_plot, pseudotrues, linestyle = :dash, color = :black, label = "", legend = :outertopright, size = (600, 1000))
    savefig(density_plot, ".paper_results/densityplots_$(run).png")
end

function generate_epsilon_plots(run, chain, shocks)
    println("generating epsilon plots for ", run)
    params = JSON.parsefile(".replication_results/$(run)/result.json")
    T = params["T"]
    
    # epsilons
    symbol_to_int(s) = parse(Int, replace(string(s), "ϵ_draw["=>"", "]"=>""))
    symbollist = reshape([Symbol("ϵ_draw[$a]") for a in 1:T*2], 2, T)

    # Import the true shock values
    ϵ_true = Matrix(DataFrame(CSV.File("data/$(shocks).csv")))

    # Plot and save
    ϵ_chain = sort(chain[:, symbollist[1, :], 1], lt = (x,y) -> symbol_to_int(x) < symbol_to_int(y))
    tmp = describe(ϵ_chain)
    ϵ_mean = tmp[1][:, 2]
    ϵ_std = tmp[1][:, 3]
    ϵ_plot = plot(ϵ_mean[2:end], ribbon=2 * ϵ_std[2:end], label="Posterior mean")
    ϵ_plot = plot!(ϵ_true[:, 1], label="True values")
    savefig(ϵ_plot, ".paper_results/epsilons_$(run).png")

    vol_chain = sort(chain[:, symbollist[2, :], 1], lt = (x,y) -> symbol_to_int(x) < symbol_to_int(y))
    tmp = describe(vol_chain)
    vol_mean = tmp[1][:, 2]
    vol_std = tmp[1][:, 3]

    # Plot and save
    vol_plot = plot(vol_mean[2:end], ribbon=2 * vol_std[2:end], label="Posterior mean")
    vol_plot = plot!(ϵ_true[:, 2], label="True values")
    savefig(vol_plot, ".paper_results/volshocks_rbc_sv_$(run).png")
end

chain = deserialize(".replication_results/rbc_sv_2_joint_200/chain.jls")

generate_stats_plots("rbc_sv_2_joint_200", chain, ["α", "β_draw", "ρ"], [0.3 0.2 0.9])

generate_epsilon_plots("rbc_sv_2_joint_200", chain, "rbc_sv_2_joint_shocks_200")
