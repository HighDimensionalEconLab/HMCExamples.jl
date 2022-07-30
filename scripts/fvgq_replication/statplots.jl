using HDF5, MCMCChains, MCMCChainsStorage, CSV, DataFrames, StatsPlots, Measures

function generate_plots(batch, include_vars)
    println("generating plots for ", batch)
    chain = h5open(".experiments/FVGQ_fixed_x0/FVGQ_$(batch)/chain.h5", "r") do f
        read(f, Chains)
    end
    println("  deserialization complete")

    # trace plots (Figures 1, 2, 4)
    trace_plot = traceplot(chain[include_vars[1:6]], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm)
    savefig(trace_plot, ".figures/plot_1_FVGQ_$(batch).png")
    trace_plot2 = traceplot(chain[include_vars[7:12]], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm)
    savefig(trace_plot2, ".figures/plot_2_FVGQ_$(batch).png")
    trace_plot3 = traceplot(chain[include_vars[13:end]], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm)
    savefig(trace_plot3, ".figures/plot_3_FVGQ_$(batch).png")

    # density (Figures 1, 2, 4)
    density_plot = density(chain[include_vars[1:6]], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm)
    savefig(density_plot, ".figures/densityplots_1_FVGQ_$(batch).png")
    density_plot2 = density(chain[include_vars[7:12]], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm)
    savefig(density_plot2, ".figures/densityplots_2_FVGQ_$(batch).png")
    density_plot3 = density(chain[include_vars[13:end]], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm)
    savefig(density_plot3, ".figures/densityplots_3_FVGQ_$(batch).png")

    """
    if batch != "1_kalman"
        # epsilons (Figure 6)
        symbol_to_int(s) = parse(Int, replace(string(s), "ϵ_draw["=>"", "]"=>""))
        symbollist = reshape([Symbol("ϵ_draw[]") for a in 1:1392], 6, 232)
        labels = ["d: Preference", "φ: Labor Supply", "μ: Capital Price", "A: TFP", "m: Monetary", "g: Government Spending"]
        plots = []
        for i in 1:6
            ϵ_chain = sort(chain[:, symbollist[i, :], 1], lt = (x,y) -> symbol_to_int(x) < symbol_to_int(y))
            tmp = describe(ϵ_chain)
            ϵ_mean = tmp[1][:, 2]
            ϵ_std = tmp[1][:, 3]
            push!(plots, plot(ϵ_mean[2:end], ribbon=2 * ϵ_std[2:end], title = labels[i]))
        end
        ϵ_plot = plot(plots[1], plots[2], plots[3], plots[4], plots[5], plots[6], layout = (6, 1), size = (1600, 900), left_margin = 10mm, legend = false)
        savefig(ϵ_plot, ".figures/epsilons_FVGQ_$(batch).png")
    end
    """

    println("  plots complete")
end

    

generate_plots("1_kalman", ["β_draw", "h", "κ", "χ", "γR", "γΠ", "Πbar_draw", "ρd", "ρφ", "ρg", "g_bar", "σ_A", "σ_d", "σ_φ", "σ_μ", "σ_m", "σ_g", "Λμ", "ΛA"])
generate_plots("1_joint", ["β_draw", "h", "κ", "χ", "γR", "γΠ", "Πbar_draw", "ρd", "ρφ", "ρg", "g_bar", "σ_A", "σ_d", "σ_φ", "σ_μ", "σ_m", "σ_g", "Λμ", "ΛA"])
generate_plots("2_joint", ["β_draw", "h", "κ", "χ", "γR", "γΠ", "Πbar_draw", "ρd", "ρφ", "ρg", "g_bar", "σ_A", "σ_d", "σ_φ", "σ_μ", "σ_m", "σ_g", "Λμ", "ΛA"])
