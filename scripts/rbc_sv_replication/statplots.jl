using HDF5, MCMCChains, MCMCChainsStorage, CSV, DataFrames, StatsPlots, Measures, Dates

function generate_plots()
    println("generating plots")
    include_vars = ["α", "β"]
    pseudotrues = [0.5 0.95]
    chain_joint_1 = h5open(".experiments/rbc_sv/rbc_sv_2_joint/chain.h5", "r") do f
        read(f, Chains)
    end

    println("  deserialization complete")
    
    # trace plots
    trace_plot = traceplot(chain_joint_1[include_vars], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm, right_margin = 10mm)
    hline!(trace_plot, pseudotrues, linestyle = :dash, color = :black, label = "", size = (600, 1000))
    savefig(trace_plot, ".figures/traceplots_rbc_sv_2_joint_1.png")

    # density
    density_plot = density(chain_joint_1[include_vars], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm, label = "NUTS, joint")
    vline!(density_plot, pseudotrues, linestyle = :dash, color = :black, label = "", legend = :outertopright, size = (600, 1000))
    savefig(density_plot, ".figures/densityplots_rbc_sv.png")
    
    for (batch, chain) in [("2_joint", chain_joint_1)]
        # epsilons
        symbol_to_int(s) = parse(Int, replace(string(s), "ϵ_draw["=>"", "]"=>""))
        ϵ_chain = sort(chain[:, [Symbol("ϵ_draw[$a]") for a in 1:201], 1], lt = (x,y) -> symbol_to_int(x) < symbol_to_int(y))
        tmp = describe(ϵ_chain)
        ϵ_mean = tmp[1][:, 2]
        ϵ_std = tmp[1][:, 3]

        # Import the true shock values
        ϵ_true = Matrix(DataFrame(CSV.File("data/rbc_sv_$(batch)_shocks.csv")))'

        # Plot and save
        ϵ_plot = plot(ϵ_mean[2:end], ribbon=2 * ϵ_std[2:end], label="Posterior mean")
        ϵ_plot = plot!(ϵ_true[1, :], label="True values")
        savefig(ϵ_plot, ".figures/epsilons_rbc_sv_$(batch).png")

        ϵ_chain = sort(chain[:, [Symbol("ϵ_draw[$a]") for a in 202:402], 1], lt = (x,y) -> symbol_to_int(x) < symbol_to_int(y))
        tmp = describe(ϵ_chain)
        ϵ_mean = tmp[1][:, 2]
        ϵ_std = tmp[1][:, 3]

        # Plot and save
        ϵ_plot = plot(ϵ_mean[2:end], ribbon=2 * ϵ_std[2:end], label="Posterior mean")
        ϵ_plot = plot!(ϵ_true[2, :], label="True values")
        savefig(ϵ_plot, ".figures/volshocks_rbc_sv_$(batch).png")
    end
    
    println("  plots complete")
end

generate_plots()
