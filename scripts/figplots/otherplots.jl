using HDF5, MCMCChains, MCMCChainsStorage, CSV, DataFrames, StatsPlots, Measures, MAT

function generate_plots(batch)
    println("generating plots for ", batch)
    chain = h5open(".experiments/benchmarks_julia/rbc_$(batch)_timed/chain.h5", "r") do f
        read(f, Chains)
    end
    println("  deserialization complete")

    # scatter (Figure 5)
    s1 = chain[:, :α, 1]
    s2 = chain[:, :β_draw, 1]
    s3 = chain[:, :ρ, 1]
    p1 = scatter(s1, s2, xlabel = "α", ylabel = "β_draw", legend=false, left_margin = 15mm, bottom_margin = 10mm)
    p2 = scatter(s2, s3, xlabel = "β_draw", ylabel = "ρ", legend=false, left_margin = 15mm, bottom_margin = 10mm)
    p3 = scatter(s1, s3, xlabel = "α", ylabel = "ρ", legend=false, left_margin = 15mm, bottom_margin = 10mm)
    s_plot = plot(p1, p2, p3, layout=(1, 3), size=(1500, 500), left_margin = 15mm, bottom_margin = 10mm)
    savefig(s_plot, ".figures/scatter_rbc_$(batch).png")

    if batch != "1_kalman"
        # epsilons (Figure 6)
        symbol_to_int(s) = parse(Int, replace(string(s), "ϵ_draw["=>"", "]"=>""))
        ϵ_chain = sort(chain[:, [Symbol("ϵ_draw[$a]") for a in 1:201], 1], lt = (x,y) -> symbol_to_int(x) < symbol_to_int(y))
        tmp = describe(ϵ_chain)
        ϵ_mean = tmp[1][:, 2]
        ϵ_std = tmp[1][:, 3]

        # Import the true shock values
        ϵ_true = vec(Matrix(DataFrame(CSV.File("data/rbc_$(batch)_shocks.csv"))))

        # Plot and save
        ϵ_plot = plot(ϵ_mean[2:end], ribbon=2 * ϵ_std[2:end], label="Posterior mean")
        ϵ_plot = plot!(ϵ_true, label="True values")
        savefig(ϵ_plot, ".figures/epsilons_rbc_$(batch).png")
    end
    println("  plots complete")
end

function dynare_comparison()
    chain_julia_small = h5open(".experiments/benchmarks_julia/rbc_2_joint_timed/chain.h5", "r") do f
        read(f, Chains)
    end
    chain_julia_big = h5open(".experiments/benchmarks_julia/rbc_2_joint_timed_10000/chain.h5", "r") do f
        read(f, Chains)
    end
    mat2 = matread(".experiments/benchmarks_dynare/dynare_chains_timed/chain_2nd_order.mat")
    data2 = [mat2["x2"] mat2["logpo2"]]
    chain_dynare = Chains(data2, ["α", "β_draw", "ρ", "lp"])
    println(chain_dynare[["β_draw",]])
    density_plot = density(chain_julia_small[["β_draw",]], left_margin = 15mm, top_margin = 5mm, label="NUTS, joint, 4000")
    density_plot = density!(chain_dynare[["β_draw",]], left_margin = 15mm, label="RWMH, particle, 10000")
    density_plot = density!(chain_julia_big[["β_draw",]], left_margin = 15mm, label="NUTS, joint, 10000", linestyle = :dash, color = :black)
    savefig(density_plot, ".figures/beta_density.png")
end

generate_plots("1_kalman")
generate_plots("1_joint")
generate_plots("2_joint")
dynare_comparison()
