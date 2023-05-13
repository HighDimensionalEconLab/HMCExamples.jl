using MCMCChains, MCMCChainsStorage, CSV, DataFrames, StatsPlots, Serialization, Measures, MAT
using HMCExamples, DynamicPPL

function generate_stats_plots(run, include_vars)
    println("generating stats plots for ", run)
    chain = deserialize(".replication_results/$(run)/chain.jls")
    println("  deserialization complete")

    # trace plots (Figures 1, 2, 4)
    trace_plot = traceplot(chain[include_vars], left_margin = 15mm, bottom_margin = 10mm, top_margin = 5mm)
    savefig(trace_plot, ".paper_results/traceplots_$(run)_multichain.png")

    # density (Figures 1, 2, 4)
    density_plot = density(chain[include_vars], left_margin = 15mm, bottom_margin = 10mm, top_margin = 5mm)
    savefig(density_plot, ".paper_results/densityplots_$(run)_multichain.png")
end

function generate_scatter_plots(run)
    println("generating scatter plots for ", run)
    chain = deserialize(".replication_results/$(run)/chain.jls")
    println("  deserialization complete")

    # scatter (Figure 5)
    s1 = chain[:, :α, 1]
    s2 = chain[:, :β_draw, 1]
    s3 = chain[:, :ρ, 1]
    p1 = scatter(s1, s2, xlabel = "α", ylabel = "β_draw", legend=false, left_margin = 15mm, bottom_margin = 10mm)
    p2 = scatter(s2, s3, xlabel = "β_draw", ylabel = "ρ", legend=false, left_margin = 15mm, bottom_margin = 10mm)
    p3 = scatter(s1, s3, xlabel = "α", ylabel = "ρ", legend=false, left_margin = 15mm, bottom_margin = 10mm)
    s_plot = plot(p1, p2, p3, layout=(1, 3), size=(1500, 500), left_margin = 15mm, bottom_margin = 10mm)
    savefig(s_plot, ".figures/scatter_$(run).png")
end

function generate_epsilon_plots(run)
    println("generating epsilon plots for ", run)
    chain = deserialize(".replication_results/$(run)/chain.jls")
    println("  deserialization complete")
    
    # epsilons (Figure 6)
    symbol_to_int(s) = parse(Int, replace(string(s), "ϵ_draw["=>"", "]"=>""))
    
    # WARNING: T is hardcoded
    
    ϵ_chain = sort(chain[:, [Symbol("ϵ_draw[$a]") for a in 1:201], 1], lt = (x,y) -> symbol_to_int(x) < symbol_to_int(y))
    tmp = describe(ϵ_chain)
    ϵ_mean = tmp[1][:, 2]
    ϵ_std = tmp[1][:, 3]

    # Import the true shock values
    ϵ_true = vec(Matrix(DataFrame(CSV.File("data/$(batch)_shocks.csv"))))

    # Plot and save
    ϵ_plot = plot(ϵ_mean[2:end], ribbon=2 * ϵ_std[2:end], label="Posterior mean")
    ϵ_plot = plot!(ϵ_true, label="True values")
    savefig(ϵ_plot, ".figures/epsilons_$(run).png")
end

function dynare_comparison(julia_small_run, julia_big_run, dynare_run)
    println("generating dynare comparison plots")
    chain_julia_small = deserialize(".replication_results/$(julia_small_run)/chain.jls")
    chain_julia_big = deserialize(".replication_results/$(julia_big_run)/chain.jls")
    mat2 = matread(".replication_results/$(dynare_run)/chain.mat")
    data2 = [mat2["x2"] mat2["logpo2"]]
    chain_dynare = Chains(data2, ["α", "β_draw", "ρ", "lp"])
    println("  deserialization complete")

    # TODO: swap magic numbers for num_samples
    density_plot = density(chain_julia_small[["β_draw",]], left_margin = 15mm, top_margin = 5mm, label="NUTS, joint, 4000", legend=true)
    density_plot = density!(chain_dynare[["β_draw",]], left_margin = 15mm, top_margin = 5mm, label="RWMH, particle, 9000", legend=true)
    density_plot = density!(chain_julia_big[["β_draw",]], left_margin = 15mm, top_margin = 5mm, label="NUTS, joint, 10000", linestyle = :dash, color = :black, legend=true)
    savefig(density_plot, ".figures/beta_density.png")
end

generate_stats_plots("rbc_1_kalman_200_chains", ["α", "β_draw", "ρ"])
generate_stats_plots("rbc_1_joint_200_chains", ["α", "β_draw", "ρ"])
generate_stats_plots("rbc_2_joint_200_chains", ["α", "β_draw", "ρ"])

generate_scatter_plots("rbc_1_kalman_200")
generate_scatter_plots("rbc_1_joint_200")
generate_scatter_plots("rbc_2_joint_200_long")

generate_epsilon_plots("rbc_1_joint_200")
generate_epsilon_plots("rbc_2_joint_200_long")

dynare_comparison("rbc_2_joint_200", "rbc_2_joint_200_long", "rbc_2_200_dynare")
