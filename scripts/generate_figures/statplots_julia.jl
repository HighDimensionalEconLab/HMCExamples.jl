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
    println("  plots complete")
end

generate_plots("1_kalman", ["α", "β_draw", "ρ"])
generate_plots("1_joint", ["α", "β_draw", "ρ"])
generate_plots("2_joint", ["α", "β_draw", "ρ"])
