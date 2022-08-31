using HDF5, MCMCChains, MCMCChainsStorage, CSV, DataFrames, StatsPlots, Measures, Dates, MAT

function generate_plots()
    println("generating plots")
    include_vars = ["α", "β_draw", "γ", "ρ", "ρ_u", "ρ_v", "ψ"]
    pseudotrues = [0.32 4 2.0 0.42 0.2 0.4 0.000742]
    chain_marginal = h5open(".experiments/sgu/sgu_1_kalman/chain.h5", "r") do f
        read(f, Chains)
    end
    chain_joint_1 = h5open(".experiments/sgu/sgu_1_joint/chain.h5", "r") do f
        read(f, Chains)
    end
    chain_joint_2 = h5open(".experiments/sgu/sgu_2_joint/chain.h5", "r") do f
        read(f, Chains)
    end

    include_vars_dynare = ["α", "β_draw", "γ", "ρ", "ρ_u", "ρ_v", "ψ", "lp"]
    order_dynare = (x, y)->findfirst(i->i==string(x), include_vars_dynare) < findfirst(i->i==string(y), include_vars_dynare)

    mat1 = matread(".experiments/sgu/chain_1st_order.mat")
    data1 = [mat1["x2"] mat1["logpo2"]]
    chain_dynare_1 = sort(Chains(data1, ["α", "γ", "ψ", "β_draw", "ρ", "ρ_u", "ρ_v", "lp"]), lt = order_dynare)

    mat2 = matread(".experiments/sgu/chain_2nd_order.mat")
    data2 = [mat2["x2"] mat2["logpo2"]]
    chain_dynare_2 = sort(Chains(data2, ["α", "γ", "ψ", "β_draw", "ρ", "ρ_u", "ρ_v", "lp"]), lt = order_dynare)
    println("  deserialization complete")

    # trace plots
    trace_plot = traceplot(chain_marginal[include_vars], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm, label = "Marginal")
    traceplot!(trace_plot, chain_joint_1[include_vars], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm, label = "1st-Order Joint")
    traceplot!(trace_plot, chain_joint_2[include_vars], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm, label = "2nd-Order Joint", legend = true)
    hline!(trace_plot, pseudotrues, linestyle = :dash, color = :black, label = "")
    savefig(trace_plot, ".figures/plot_sgu.png")
    trace_plot_1 = traceplot(chain_dynare_1[include_vars], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm)
    hline!(trace_plot_1, pseudotrues, linestyle = :dash, color = :black, label = "")
    savefig(trace_plot_1, ".figures/plot_sgu_1_dynare.png")
    trace_plot_2 = traceplot(chain_dynare_2[include_vars], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm)
    hline!(trace_plot_2, pseudotrues, linestyle = :dash, color = :black, label = "")
    savefig(trace_plot_2, ".figures/plot_sgu_2_dynare.png")

    # density
    density_plot = density(chain_marginal[include_vars], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm, label = "NUTS K")
    density!(density_plot, chain_joint_1[include_vars], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm, label = "NUTS 1")
    density!(density_plot, chain_joint_2[include_vars], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm, label = "NUTS 2")
    density!(density_plot, chain_dynare_1[include_vars], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm, label = "RWMH 1")
    density!(density_plot, chain_dynare_2[include_vars], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm, label = "RWMH 2", legend = :outertopright)
    vline!(density_plot, pseudotrues, linestyle = :dash, color = :black, label = "")
    savefig(density_plot, ".figures/densityplots_sgu.png")

    for (batch, shocks, chain) in [("1_joint", "data/sgu_1_fixed_high_shocks.csv", chain_joint_1), ("2_joint", "data/sgu_2_fixed_high_shocks.csv", chain_joint_2)]
        # epsilons
        symbol_to_int(s) = parse(Int, replace(string(s), "ϵ_draw["=>"", "]"=>""))
        symbollist = reshape([Symbol("ϵ_draw[$a]") for a in 1:600], 3, 200)
        labels = ["σ_e", "σ_u", "σ_v"]
        plots = []

        # Import the true shock values
        ϵ_true = Matrix(DataFrame(CSV.File(shocks)))

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
        ϵ_plot = plot(plots[1], plots[2], plots[3], layout = (6, 1), size = (1600, 900), left_margin = 10mm, bottom_margin = 5mm, legend = false)
        savefig(ϵ_plot, ".figures/epsilons_sgu_$(batch).png")
    end

    println("  plots complete")
end

generate_plots()
