using MCMCChains, MCMCChainsStorage, CSV, DataFrames, StatsPlots, Serialization, Measures
using HMCExamples, DynamicPPL

function generate_stats_plots(run, include_vars, pseudotrues)
    println("generating stats plots for ", run)
    chain = deserialize(".replication_results/$(run)/chain.jls")
    println("  deserialization complete")

    # trace plots
    trace_plot = traceplot(chain[include_vars], left_margin = 15mm, bottom_margin = 10mm, top_margin = 5mm)
    hline!(trace_plot, pseudotrues, linestyle = :dash, color = :black, label = "", size = (600, 1000))
    savefig(trace_plot, ".paper_results/traceplots_$(run).png")

    # density
    density_plot = density(chain[include_vars], left_margin = 15mm, bottom_margin = 10mm, top_margin = 5mm)
    vline!(density_plot, pseudotrues, linestyle = :dash, color = :black, label = "", legend = :outertopright, size = (600, 1000))
    savefig(density_plot, ".paper_results/densityplots_$(run).png")
end

function generate_epsilon_plots(run)
    println("generating epsilon plots for ", run)
    chain = deserialize(".replication_results/$(run)/chain.jls")
    println("  deserialization complete")
    
    # epsilons
    symbol_to_int(s) = parse(Int, replace(string(s), "ϵ_draw["=>"", "]"=>""))

    # WARNING: T is hardcoded

    ϵ_chain = sort(chain[:, [Symbol("ϵ_draw[$a]") for a in 1:201], 1], lt = (x,y) -> symbol_to_int(x) < symbol_to_int(y))
    tmp = describe(ϵ_chain)
    ϵ_mean = tmp[1][:, 2]
    ϵ_std = tmp[1][:, 3]

    # Import the true shock values
    ϵ_true = Matrix(DataFrame(CSV.File("data/$(run)_shocks.csv")))'

    # Plot and save
    ϵ_plot = plot(ϵ_mean[2:end], ribbon=2 * ϵ_std[2:end], label="Posterior mean")
    ϵ_plot = plot!(ϵ_true[1, :], label="True values")
    savefig(ϵ_plot, ".figures/epsilons_$(run).png")

    vol_chain = sort(chain[:, [Symbol("ϵ_draw[$a]") for a in 202:402], 1], lt = (x,y) -> symbol_to_int(x) < symbol_to_int(y))
    tmp = describe(vol_chain)
    vol_mean = tmp[1][:, 2]
    vol_std = tmp[1][:, 3]

    # Plot and save
    vol_plot = plot(vol_mean[2:end], ribbon=2 * vol_std[2:end], label="Posterior mean")
    vol_plot = plot!(ϵ_true[2, :], label="True values")
    savefig(vol_plot, ".figures/volshocks_rbc_sv_$(batch).png")
end

generate_stats_plots("rbc_sv_2_joint_200", ["α", "β_draw", "ρ"], [0.3 0.2 0.9])

generate_epsilon_plots("rbc_sv_2_joint_200")
