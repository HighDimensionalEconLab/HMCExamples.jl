using HDF5, MCMCChains, MCMCChainsStorage, CSV, DataFrames, StatsPlots, Measures, Dates

function generate_plots(batch, include_vars)
    println("generating plots for ", batch)
    chain = h5open(".experiments/sgu/sgu_$(batch)/chain.h5", "r") do f
        read(f, Chains)
    end
    println("  deserialization complete")

    # trace plots (Figures 1, 2, 4)
    trace_plot = traceplot(chain[include_vars], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm)
    savefig(trace_plot, ".figures/plot_sgu_$(batch).png")

    # density (Figures 1, 2, 4)
    density_plot = density(chain[include_vars], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm)
    savefig(density_plot, ".figures/densityplots_sgu_$(batch).png")

    if batch != "1_kalman"
        # epsilons (Figure 6)
        symbol_to_int(s) = parse(Int, replace(string(s), "ϵ_draw["=>"", "]"=>""))
        symbollist = reshape([Symbol("ϵ_draw[$a]") for a in 1:600], 3, 200)
        labels = ["σ_e", "σ_u", "σ_v"]
        plots = []

        # Import the true shock values
        ϵ_true = Matrix(DataFrame(CSV.File("data/rbc_$(batch)_shocks.csv")))

        for i in 1:3
            ϵ_chain = sort(chain[:, symbollist[i, :], 1], lt = (x,y) -> symbol_to_int(x) < symbol_to_int(y))
            tmp = describe(ϵ_chain)
            ϵ_mean = tmp[1][:, 2]
            ϵ_std = tmp[1][:, 3]
            
            # Plot and save
            ϵ_plot = plot(ϵ_mean[2:end], ribbon=2 * ϵ_std[2:end], title = labels[i])
            # may need to double-check the dimensions here
            ϵ_plot = plot!(ϵ_true[i, :], label="True values")
            push!(plots, ϵ_plot)
        end
        ϵ_plot = plot(plots[1], plots[2], plots[3], layout = (6, 1), size = (1600, 900), left_margin = 10mm, bottom_margin = 5mm, legend = false)
        savefig(ϵ_plot, ".figures/epsilons_sgu_$(batch).png")
    end

    println("  plots complete")
end

generate_plots("1_kalman", ["α", "γ", "ψ", "β_draw", "ρ", "ρ_u", "ρ_v"])
generate_plots("1_joint", ["α", "γ", "ψ", "β_draw", "ρ", "ρ_u", "ρ_v"])
generate_plots("2_joint", ["α", "γ", "ψ", "β_draw", "ρ", "ρ_u", "ρ_v"])