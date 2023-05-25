using MCMCChains, CSV, DataFrames, StatsPlots, Serialization, Measures, JSON
using HMCExamples, DynamicPPL

function generate_stats_plots(run, include_vars)
    chain = deserialize(".replication_results/$(run)/chain.jls")

    # trace plots
    trace_plot = traceplot(chain[include_vars], left_margin = 15mm, bottom_margin = 10mm, top_margin = 5mm)
    savefig(trace_plot, ".paper_results/$(run)_traceplots.png")

    # density
    density_plot = density(chain[include_vars], left_margin = 15mm, bottom_margin = 10mm, top_margin = 5mm)
    savefig(density_plot, ".paper_results/$(run)_densityplots.png")
end

function generate_scatter_plots(run)
    chain = deserialize(".replication_results/$(run)/chain.jls")

    s1 = chain[:, :α, 1]
    s2 = chain[:, :β_draw, 1]
    s3 = chain[:, :ρ, 1]
    p1 = scatter(s1, s2, xlabel = "α", ylabel = "β_draw", legend=false, left_margin = 15mm, bottom_margin = 10mm)
    p2 = scatter(s2, s3, xlabel = "β_draw", ylabel = "ρ", legend=false, left_margin = 15mm, bottom_margin = 10mm)
    p3 = scatter(s1, s3, xlabel = "α", ylabel = "ρ", legend=false, left_margin = 15mm, bottom_margin = 10mm)
    s_plot = plot(p1, p2, p3, layout=(1, 3), size=(1500, 500), left_margin = 15mm, bottom_margin = 10mm)
    savefig(s_plot, ".paper_results/$(run)_scatter.png")
end

# RBC because this is assuming a univariate shock
function generate_rbc_epsilon_plots(run, shocks_path)
    chain = deserialize(".replication_results/$(run)/chain.jls")
    params = JSON.parsefile(".replication_results/$(run)/result.json")
    T = params["T"]
    
    # epsilons
    symbol_to_int(s) = parse(Int, replace(string(s), "ϵ_draw["=>"", "]"=>""))
    
    ϵ_chain = sort(chain[:, [Symbol("ϵ_draw[$a]") for a in 1:T+1], 1], lt = (x,y) -> symbol_to_int(x) < symbol_to_int(y))
    ϵ_stats = describe(ϵ_chain)
    ϵ_mean = ϵ_stats[1][:, 2]
    ϵ_std = ϵ_stats[1][:, 3]

    # Import the true shock values
    ϵ_true = vec(Matrix(DataFrame(CSV.File(shocks_path))))

    # Plot and save
    ϵ_plot = plot(ϵ_mean[2:end], ribbon=2 * ϵ_std[2:end], label="Posterior mean")
    ϵ_plot = plot!(ϵ_true, label="True values")
    savefig(ϵ_plot, ".paper_results/$(run)_epsilons.png")
end

function generate_sv_epsilon_plots(run, shocks_path)
    chain = deserialize(".replication_results/$(run)/chain.jls")
    params = JSON.parsefile(".replication_results/$(run)/result.json")
    T = params["T"]
    num_ϵ = 2
    
    # # epsilons
    symbol_to_int(s) = parse(Int, replace(string(s), "ϵ_draw["=>"", "]"=>""))
    
    ϵ_chain = sort(chain[:, [Symbol("ϵ_draw[$a]") for a in 1: num_ϵ*(T+1)], 1], lt = (x,y) -> symbol_to_int(x) < symbol_to_int(y))
    ϵ_stats = describe(ϵ_chain)
    ϵ_mean = reshape(ϵ_stats[1][:, 2], num_ϵ, T+1)'
    ϵ_std = reshape(ϵ_stats[1][:, 3], num_ϵ, T+1)'
    # # Import the true shock values
    ϵ_true = Matrix(DataFrame(CSV.File(shocks_path)))

    # Plot and save both series
    ϵ_1_plot = plot(ϵ_mean[2:end,1], ribbon=2 * ϵ_std[2:end,1], label="Posterior mean")
    ϵ_1_plot = plot!(ϵ_true[:,1], label="True values")
    savefig(ϵ_1_plot, ".paper_results/$(run)_epsilons.png")
    ϵ_2_plot = plot(ϵ_mean[2:end,2], ribbon=2 * ϵ_std[2:end,2], label="Posterior mean")
    ϵ_2_plot = plot!(ϵ_true[:,2], label="True values")
    savefig(ϵ_2_plot, ".paper_results/$(run)_volshocks.png")
end


function dynare_comparison(julia_small_run, julia_big_run, dynare_run)
    chain_julia_small = deserialize(".replication_results/$(julia_small_run)/chain.jls")    
    params_julia_small = JSON.parsefile(".replication_results/$(julia_small_run)/result.json")
    chain_julia_big = deserialize(".replication_results/$(julia_big_run)/chain.jls")    
    params_julia_big = JSON.parsefile(".replication_results/$(julia_big_run)/result.json")
    chain_dynare = deserialize(".replication_results/$(dynare_run)/chain.jls")    
    params_dynare = JSON.parsefile(".replication_results/$(dynare_run)/result.json")    

    density_plot = density(chain_julia_small[["β_draw",]], left_margin = 15mm, top_margin = 5mm, label="NUTS, joint, $(params_julia_small["num_samples"])", legend=true)
    density_plot = density!(chain_dynare[["β_draw",]], left_margin = 15mm, top_margin = 5mm, label="RWMH, particle, $(params_dynare["num_samples"])", legend=true)
    density_plot = density!(chain_julia_big[["β_draw",]], left_margin = 15mm, top_margin = 5mm, label="NUTS, joint, $(params_julia_big["num_samples"])", linestyle = :dash, color = :black, legend=true)
    savefig(density_plot, ".paper_results/rbc_comparison_beta_density.png")

    density_plot = density(chain_julia_small[["α",]], left_margin = 15mm, top_margin = 5mm, label="NUTS, joint, $(params_julia_small["num_samples"])", legend=true)
    density_plot = density!(chain_dynare[["α",]], left_margin = 15mm, top_margin = 5mm, label="RWMH, particle, $(params_dynare["num_samples"])", legend=true)
    density_plot = density!(chain_julia_big[["α",]], left_margin = 15mm, top_margin = 5mm, label="NUTS, joint, $(params_julia_big["num_samples"])", linestyle = :dash, color = :black, legend=true)
    savefig(density_plot, ".paper_results/rbc_comparison_alpha_density.png")    

    density_plot = density(chain_julia_small[["ρ",]], left_margin = 15mm, top_margin = 5mm, label="NUTS, joint, $(params_julia_small["num_samples"])", legend=true)
    density_plot = density!(chain_dynare[["ρ",]], left_margin = 15mm, top_margin = 5mm, label="RWMH, particle, $(params_dynare["num_samples"])", legend=true)
    density_plot = density!(chain_julia_big[["ρ",]], left_margin = 15mm, top_margin = 5mm, label="NUTS, joint, $(params_julia_big["num_samples"])", linestyle = :dash, color = :black, legend=true)
    savefig(density_plot, ".paper_results/rbc_comparison_rho_density.png")        
end

# density and trace plots
rbc_params =  ["α", "β_draw", "ρ"]
generate_stats_plots("rbc_1_kalman_200_chains",rbc_params)
generate_stats_plots("rbc_1_joint_200_chains", rbc_params)
generate_stats_plots("rbc_2_joint_200_chains", rbc_params)
generate_stats_plots("rbc_1_200_dynare",rbc_params) # Not included in the main paper, but can't generating anyways for comparison
generate_stats_plots("rbc_2_200_dynare",rbc_params) # Not included in the main paper, but can't generating anyways for comparison

# scatter plots
generate_scatter_plots("rbc_1_kalman_200")
generate_scatter_plots("rbc_1_joint_200")
generate_scatter_plots("rbc_2_joint_200_long")

# epsilon plots
generate_rbc_epsilon_plots("rbc_1_joint_200", "data/rbc_1_joint_shocks_200.csv")
generate_rbc_epsilon_plots("rbc_2_joint_200_long", "data/rbc_2_joint_shocks_200.csv")
generate_rbc_epsilon_plots("rbc_2_joint_200_long", "data/rbc_2_joint_shocks_200.csv")
generate_sv_epsilon_plots("rbc_sv_2_joint_200", "data/rbc_sv_2_joint_shocks_200.csv")

# dynare comparison for beta
dynare_comparison("rbc_2_joint_200", "rbc_2_joint_200_long", "rbc_2_200_dynare")
