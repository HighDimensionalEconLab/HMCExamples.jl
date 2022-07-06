using HDF5, MCMCChains, MCMCChainsStorage, CSV, DataFrames, StatsPlots, Measures

function generate_plots(batch, include_vars)
    println("generating plots for ", batch)
    chains = []
    for i in 1:10
        chain = h5open(".experiments/statplots_julia/f124_rbc_$(batch)_$(i)/chain.h5", "r") do f
            read(f, Chains)
        end
        push!(chains, chain)
    end
    println("  deserialization complete")

    # trace plots (Figures 1, 2, 4)
    trace_plot = traceplot(chains[1][include_vars], left_margin = 15mm, bottom_margin = 10mm, top_margin = 5mm)
    for i in 2:10
        trace_plot = traceplot!(chains[i][include_vars], left_margin = 15mm, bottom_margin = 10mm, top_margin = 5mm)
    end
    savefig(trace_plot, ".figures/traceplots_rbc_$(batch)_seed0_multichain.png")

    # density (Figures 1, 2, 4)
    density_plot = density(chains[1][include_vars], left_margin = 15mm, top_margin = 5mm)
    for i in 2:10
        density_plot = density!(chains[i][include_vars], left_margin = 15mm, bottom_margin = 10mm, top_margin = 5mm)
    end
    savefig(density_plot, ".figures/densityplots_rbc_$(batch)_seed0_multichain.png")

    # scatter (Figure 5)
    s1 = chains[1][:, :α, 1]
    s2 = chains[1][:, :β_draw, 1]
    s3 = chains[1][:, :ρ, 1]
    p1 = scatter(s1, s2, xlabel = "α", ylabel = "β_draw", legend=false, left_margin = 15mm, bottom_margin = 10mm)
    p2 = scatter(s2, s3, xlabel = "β_draw", ylabel = "ρ", legend=false, left_margin = 15mm, bottom_margin = 10mm)
    p3 = scatter(s1, s3, xlabel = "α", ylabel = "ρ", legend=false, left_margin = 15mm, bottom_margin = 10mm)
    s_plot = plot(p1, p2, p3, layout=(1, 3), size=(1500, 500), left_margin = 15mm, bottom_margin = 10mm)
    savefig(s_plot, ".figures/scatter_rbc_$(batch).png")

    # epsilons (Figure 6)
    ϵ_chain = chains[1][:, namesingroup(chains[1], :ϵ_draw), 1]
    tmp = describe(ϵ_chain)
    ϵ_mean = tmp[1][:, 2]
    ϵ_std = tmp[1][:, 3]

    # Import the true shock values
    ϵ_true = vec(Matrix(DataFrame(CSV.File("fake_shocks.csv"))))

    # Plot and save
    ϵ_plot = plot(ϵ_mean[2:end], ribbon=2 * ϵ_std[2:end], label="Posterior mean", left_margin = 15mm, bottom_margin = 10mm)
    ϵ_plot = plot!(ϵ_true, label="True values", left_margin = 10mm, bottom_margin = 15mm)
    savefig(ϵ_plot, ".figures/epsilons_rbc_$(batch).png")
    println("  plots complete")
end

generate_plots("1_kalman", ["α", "β_draw", "ρ"])
generate_plots("1_joint", ["α", "β_draw", "ρ"])
generate_plots("2_joint", ["α", "β_draw", "ρ"])