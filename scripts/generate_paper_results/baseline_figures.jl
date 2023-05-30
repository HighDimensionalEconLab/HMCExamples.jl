# To execute this in VSCode/etc. ensure you do `] activate scripts` to use the appropriate manifest
using MCMCChains, CSV, DataFrames, StatsPlots, Serialization, Measures, JSON
using HMCExamples, DynamicPPL

function generate_density_plots(run, include_vars, pseudotrues; show_pseudo_true = true, suffix="", plotargs...)
    chain = deserialize(".replication_results/$(run)/chain.jls")

    # density
    density_plot = density(chain[include_vars]; left_margin = 15mm, bottom_margin = 10mm, top_margin = 5mm, plotargs...)
    if show_pseudo_true
        vline!(density_plot, pseudotrues; linestyle = :dash, color = :black, label = "", legend = false, size = (600, 1000))
    end    
    savefig(density_plot, ".paper_results/$(run)$(suffix)_densityplots.png")
    return density_plot
end

function generate_traceplots(run, include_vars, pseudotrues; show_pseudo_true = true, suffix="", plotargs...)
    chain = deserialize(".replication_results/$(run)/chain.jls")

    # trace plots
    trace_plot = traceplot(chain[include_vars]; left_margin = 15mm, bottom_margin = 10mm, top_margin = 5mm, label=false, plotargs...)
    if show_pseudo_true
        hline!(trace_plot, pseudotrues; linestyle = :dash, color = :black, label = "", size = (600, 1000))
    end
    savefig(trace_plot, ".paper_results/$(run)$(suffix)_traceplots.png")
    return trace_plot
end


function generate_scatter_plots(run, plotargs...)
    chain = deserialize(".replication_results/$(run)/chain.jls")

    s1 = chain[:, :α, 1]
    s2 = chain[:, :β_draw, 1]
    s3 = chain[:, :ρ, 1]
    p1 = scatter(s1, s2, xlabel = "α", ylabel = "β_draw", legend=false, left_margin = 15mm, bottom_margin = 10mm)
    p2 = scatter(s2, s3, xlabel = "β_draw", ylabel = "ρ", legend=false, left_margin = 15mm, bottom_margin = 10mm)
    p3 = scatter(s1, s3, xlabel = "α", ylabel = "ρ", legend=false, left_margin = 15mm, bottom_margin = 10mm)
    s_plot = plot(p1, p2, p3; layout=(1, 3), size=(1500, 500), left_margin = 15mm, bottom_margin = 10mm, plotargs...)
    savefig(s_plot, ".paper_results/$(run)_scatter.png")
    return p1, p2, p3
end

function generate_epsilon_plots(run, labels, shocks_path; plot_args...)
    num_ϵ = length(labels)
    chain = deserialize(".replication_results/$(run)/chain.jls")
    params = JSON.parsefile(".replication_results/$(run)/result.json")
    T = params["T"]
    
    # # epsilons
    symbol_to_int(s) = parse(Int, replace(string(s), "ϵ_draw["=>"", "]"=>""))
    
    ϵ_chain = sort(chain[:, [Symbol("ϵ_draw[$a]") for a in 1: num_ϵ*(T+1)], 1], lt = (x,y) -> symbol_to_int(x) < symbol_to_int(y))
    ϵ_stats = describe(ϵ_chain)
    ϵ_mean = reshape(ϵ_stats[1][:, 2], num_ϵ, T+1)'
    ϵ_std = reshape(ϵ_stats[1][:, 3], num_ϵ, T+1)'
    ϵ_true = Matrix(DataFrame(CSV.File(shocks_path)))

    # TODO: do we usually want to combine these plots?  If so we could return them all or rearrange
    ϵ_plots = []
    for i in 1:num_ϵ
        # Plot and save both series
        ϵ_plot = plot(ϵ_mean[2:end,i], ribbon=2 * ϵ_std[2:end,i], label="Posterior mean", title=labels[i])
        ϵ_1_plot = plot!(ϵ_true[:,i], label="True values")
        push!(ϵ_plots, ϵ_plot)        
    end
    ϵ_plot = plot(ϵ_plots...; plot_args...)
    savefig(ϵ_plot, ".paper_results/$(run)_epsilons.png")
    return ϵ_plots
end


function dynare_rbc_comparison(julia_small_run, julia_big_run, dynare_run, pseudotrues;show_pseudo_true, order=2, plotargs...) # order only used for filenames, doesn't check runs
    chain_julia_small = deserialize(".replication_results/$(julia_small_run)/chain.jls")    
    params_julia_small = JSON.parsefile(".replication_results/$(julia_small_run)/result.json")
    chain_julia_big = deserialize(".replication_results/$(julia_big_run)/chain.jls")    
    params_julia_big = JSON.parsefile(".replication_results/$(julia_big_run)/result.json")
    chain_dynare = deserialize(".replication_results/$(dynare_run)/chain.jls")    
    params_dynare = JSON.parsefile(".replication_results/$(dynare_run)/result.json")    


    density_plot = density(chain_julia_small[["α",]]; left_margin = 15mm, top_margin = 5mm, label="NUTS, joint, $(params_julia_small["num_samples"])", legend=true, plotargs...)
    density_plot = density!(chain_dynare[["α",]]; left_margin = 15mm, top_margin = 5mm, label="RWMH, particle, $(params_dynare["num_samples"])", legend=true)
    density_plot = density!(chain_julia_big[["α",]]; left_margin = 15mm, top_margin = 5mm, label="NUTS, joint, $(params_julia_big["num_samples"])", linestyle = :dash, color = :black, legend=true)
    if show_pseudo_true
        vline!(density_plot, [pseudotrues[1]], linestyle = :dash, color = :black, label = "Pseudotrue")
    end
    savefig(density_plot, ".paper_results/rbc_$(order)_comparison_alpha_density.png")    


    density_plot = density(chain_julia_small[["β_draw",]]; left_margin = 15mm, top_margin = 5mm, label="NUTS, joint, $(params_julia_small["num_samples"])", legend=true, plotargs...)
    density_plot = density!(chain_dynare[["β_draw",]]; left_margin = 15mm, top_margin = 5mm, label="RWMH, particle, $(params_dynare["num_samples"])", legend=true)
    density_plot = density!(chain_julia_big[["β_draw",]]; left_margin = 15mm, top_margin = 5mm, label="NUTS, joint, $(params_julia_big["num_samples"])", linestyle = :dash, color = :black, legend=true)
    if show_pseudo_true
        vline!(density_plot, [pseudotrues[2]], linestyle = :dash, color = :black, label = "Pseudotrue")
    end
    savefig(density_plot, ".paper_results/rbc_$(order)_comparison_beta_density.png")


    density_plot = density(chain_julia_small[["ρ",]], left_margin = 15mm, top_margin = 5mm, label="NUTS, joint, $(params_julia_small["num_samples"])", legend=true)
    density_plot = density!(chain_dynare[["ρ",]], left_margin = 15mm, top_margin = 5mm, label="RWMH, particle, $(params_dynare["num_samples"])", legend=true)
    density_plot = density!(chain_julia_big[["ρ",]], left_margin = 15mm, top_margin = 5mm, label="NUTS, joint, $(params_julia_big["num_samples"])", linestyle = :dash, color = :black, legend=true)
    if show_pseudo_true
        vline!(density_plot, [pseudotrues[3]], linestyle = :dash, color = :black, label = "Pseudotrue")
    end
    savefig(density_plot, ".paper_results/rbc_$(order)_comparison_rho_density.png")        
end
function dynare_sgu_comparison_1(kalman_run, joint_run, dynare_run, include_vars, pseudotrues;show_pseudo_true, suffix="", plotargs...)
    chain_kalman = deserialize(".replication_results/$(kalman_run)/chain.jls")    
    params_kalman = JSON.parsefile(".replication_results/$(kalman_run)/result.json")    
    chain_joint = deserialize(".replication_results/$(joint_run)/chain.jls")    
    params_joint = JSON.parsefile(".replication_results/$(joint_run)/result.json")        
    chain_dynare = deserialize(".replication_results/$(dynare_run)/chain.jls")    
    params_dynare = JSON.parsefile(".replication_results/$(dynare_run)/result.json")  


    density_plots = []
    for i in eachindex(include_vars)
        var = include_vars[i]
        density_plot = density(chain_kalman[[var,]]; left_margin = 15mm, top_margin = 5mm, label="NUTS, kalman, $(params_kalman["num_samples"])", legend=true)

        density_plot = density!(chain_joint[[var,]]; left_margin = 15mm, top_margin = 5mm, label="NUTS, joint, $(params_joint["num_samples"])", legend=true)
        
        density_plot = density!(chain_dynare[[var,]]; left_margin = 15mm, top_margin = 5mm, label="RWMH, Kalman, $(params_dynare["num_samples"])", linestyle = :dash, color = :black, legend=true)
        if show_pseudo_true
            vline!(density_plot, [pseudotrues[i]], linestyle = :dash, color = :black, label = "Pseudotrue")
        end
        push!(density_plots, density_plot)
    end        
    plt =  plot(density_plots...;plotargs...)
    savefig(plt, ".paper_results/sgu_1_comparison$(suffix).png")
    return plt
end

# RBC experiments
rbc_params =  ["α", "β_draw", "ρ"]
rbc_pseudotrue = [0.3 0.2 0.9]
show_pseudo_true = false
generate_density_plots("rbc_1_kalman_200_chains",rbc_params, rbc_pseudotrue;show_pseudo_true)
generate_density_plots("rbc_1_joint_200_chains", rbc_params, rbc_pseudotrue;show_pseudo_true)
generate_density_plots("rbc_2_joint_200_chains", rbc_params, rbc_pseudotrue;show_pseudo_true)
generate_density_plots("rbc_1_200_dynare",rbc_params, rbc_pseudotrue;show_pseudo_true)
generate_density_plots("rbc_2_200_dynare",rbc_params, rbc_pseudotrue;show_pseudo_true)

generate_traceplots("rbc_1_kalman_200_chains",rbc_params, rbc_pseudotrue;show_pseudo_true)
generate_traceplots("rbc_1_joint_200_chains", rbc_params, rbc_pseudotrue;show_pseudo_true)
generate_traceplots("rbc_2_joint_200_chains", rbc_params, rbc_pseudotrue;show_pseudo_true)
generate_traceplots("rbc_1_200_dynare",rbc_params, rbc_pseudotrue;show_pseudo_true) 
generate_traceplots("rbc_2_200_dynare",rbc_params, rbc_pseudotrue;show_pseudo_true)

generate_scatter_plots("rbc_1_kalman_200")
generate_scatter_plots("rbc_1_joint_200")
generate_scatter_plots("rbc_2_joint_200_long")

# Use empty if you don't want the shock titled
rbc_shock_names = [""]
generate_epsilon_plots("rbc_1_joint_200", rbc_shock_names, "data/rbc_1_joint_shocks_200.csv")
generate_epsilon_plots("rbc_2_joint_200_long", rbc_shock_names, "data/rbc_2_joint_shocks_200.csv")
generate_epsilon_plots("rbc_2_joint_200_long", rbc_shock_names, "data/rbc_2_joint_shocks_200.csv")

# RBC dynare comparison
dynare_rbc_comparison("rbc_2_joint_200", "rbc_2_joint_200_long", "rbc_2_200_dynare", rbc_pseudotrue;show_pseudo_true)

# RBC Stochastic volatility
generate_density_plots("rbc_sv_2_joint_200",rbc_params, rbc_pseudotrue;show_pseudo_true)
generate_traceplots("rbc_sv_2_joint_200",rbc_params, rbc_pseudotrue;show_pseudo_true)
generate_epsilon_plots("rbc_sv_2_joint_200", ["TFP Shock", "Volatility Shock"], "data/rbc_sv_2_joint_shocks_200.csv"; layout=(2, 1))

# SGU traceplots in two sets
suffix_1 = "_set_1"
sgu_include_vars_1 = ["α", "β_draw", "γ"]
sgu_pseudotrues_1 = [0.32 4 2.0]
suffix_2 = "_set_2"
sgu_include_vars_2 = ["ρ", "ρ_u", "ρ_v", "ψ"]
sgu_pseudotrues_2 = [0.42 0.2 0.4 0.000742]

generate_traceplots("sgu_1_kalman_200", sgu_include_vars_1, sgu_pseudotrues_1;show_pseudo_true, suffix = suffix_1)
generate_traceplots("sgu_1_joint_200", sgu_include_vars_1, sgu_pseudotrues_1;show_pseudo_true, suffix = suffix_1)
generate_traceplots("sgu_2_joint_200", sgu_include_vars_1, sgu_pseudotrues_1;show_pseudo_true, suffix = suffix_1)
generate_traceplots("sgu_1_200_dynare", sgu_include_vars_1, sgu_pseudotrues_1;show_pseudo_true, suffix = suffix_1)
generate_traceplots("sgu_2_200_dynare", sgu_include_vars_1, sgu_pseudotrues_1;show_pseudo_true, suffix = suffix_1)

generate_traceplots("sgu_1_kalman_200", sgu_include_vars_2, sgu_pseudotrues_2;show_pseudo_true, suffix = suffix_2)
generate_traceplots("sgu_1_joint_200", sgu_include_vars_2, sgu_pseudotrues_2;show_pseudo_true, suffix = suffix_2)
generate_traceplots("sgu_2_joint_200", sgu_include_vars_2, sgu_pseudotrues_2;show_pseudo_true, suffix = suffix_2)
generate_traceplots("sgu_1_200_dynare", sgu_include_vars_2, sgu_pseudotrues_2;show_pseudo_true, suffix = suffix_2)
generate_traceplots("sgu_2_200_dynare", sgu_include_vars_2, sgu_pseudotrues_2;show_pseudo_true, suffix = suffix_2)


sgu_shock_names = ["epsilon_e", "epsilon_u", "epsilon_v"]
generate_epsilon_plots("sgu_1_joint_200", sgu_shock_names, "data/sgu_1_joint_shocks_200.csv"; layout=(3, 1))
generate_epsilon_plots("sgu_2_joint_200", sgu_shock_names, "data/sgu_2_joint_shocks_200.csv"; layout=(3, 1))


show_pseudo_true = true # useful to see who is right?
out = dynare_sgu_comparison_1("sgu_1_kalman_200", "sgu_1_joint_200", "sgu_1_200_dynare", sgu_include_vars_1, sgu_pseudotrues_1;show_pseudo_true, suffix = suffix_1, layout=(3,1), size = (600, 1000))
dynare_sgu_comparison_1("sgu_1_kalman_200", "sgu_1_joint_200", "sgu_1_200_dynare", sgu_include_vars_2, sgu_pseudotrues_2;show_pseudo_true, suffix = suffix_2, layout=(2,2), size = (1000,600))


# Traceplots combined
rbc_1_trace_kalman  = generate_traceplots("rbc_1_kalman_200",rbc_params, rbc_pseudotrue;show_pseudo_true)
rbc_1_trace_joint = generate_traceplots("rbc_1_joint_200",rbc_params, rbc_pseudotrue;show_pseudo_true)
rbc_1_trace_dynare = generate_traceplots("rbc_1_200_dynare",rbc_params, rbc_pseudotrue;show_pseudo_true)
rbc_2_trace_joint = generate_traceplots("rbc_2_joint_200",rbc_params, rbc_pseudotrue;show_pseudo_true)
rbc_2_trace_dynare = generate_traceplots("rbc_2_200_dynare",rbc_params, rbc_pseudotrue;show_pseudo_true)

function get_subplots(plt) # hardcoded to 3, removes lables before combining
    p_1 = plot(plt[1])
    title!(p_1, "")
    ylabel!(p_1, "")
    xlabel!(p_1, "")
    p_2 = plot(plt[2])
    title!(p_2, "")
    ylabel!(p_2, "")
    xlabel!(p_2, "")
    p_3 = plot(plt[3])
    title!(p_3, "")
    ylabel!(p_3, "")
    xlabel!(p_3, "")
    p_1, p_2, p_3
end

rbc_1_trace_kalman_α, rbc_1_trace_kalman_β, rbc_1_trace_kalman_ρ = get_subplots(rbc_1_trace_kalman)
rbc_1_trace_joint_α, rbc_1_trace_joint_β, rbc_1_trace_joint_ρ = get_subplots(rbc_1_trace_joint)
rbc_1_trace_dynare_α, rbc_1_trace_dynare_β, rbc_1_trace_dynare_ρ = get_subplots(rbc_1_trace_dynare)
rbc_2_trace_joint_α, rbc_2_trace_joint_β, rbc_2_trace_joint_ρ = get_subplots(rbc_2_trace_joint)
rbc_2_trace_dynare_α, rbc_2_trace_dynare_β, rbc_2_trace_dynare_ρ = get_subplots(rbc_2_trace_dynare)

#1st order one
kalman_1_title = "NUTS with Kalman Filter"
joint_1_title = "NUTS with Joint Likelihood"
joint_2_title = "NUTS with Joint Likelihood"
dynare_1_title = "RWMH with Kalman Filter"
dynare_2_title = "RWMH with Particle Filter"
xlabel_time = "Step"
ylabel!(rbc_1_trace_kalman_α, "α")
ylabel!(rbc_1_trace_kalman_β, "β_draw")
ylabel!(rbc_1_trace_kalman_ρ, "ρ")
title!(rbc_1_trace_kalman_α, kalman_1_title)
title!(rbc_1_trace_joint_α, joint_1_title)
title!(rbc_1_trace_dynare_α, dynare_1_title)
xlabel!(rbc_1_trace_kalman_ρ, xlabel_time)
xlabel!(rbc_1_trace_joint_ρ, xlabel_time)
xlabel!(rbc_1_trace_dynare_ρ, xlabel_time)
plt = plot(rbc_1_trace_kalman_α, rbc_1_trace_joint_α, rbc_1_trace_dynare_α,
rbc_1_trace_kalman_β, rbc_1_trace_joint_β, rbc_2_trace_joint_β,
rbc_1_trace_kalman_ρ, rbc_1_trace_joint_ρ, rbc_1_trace_dynare_ρ; layout=(3,3), size=(1200, 900))
savefig(plt, ".paper_results/rbc_1_traceplots.png")

ylabel!(rbc_2_trace_joint_α, "α")
ylabel!(rbc_2_trace_joint_β, "β_draw")
ylabel!(rbc_2_trace_joint_ρ, "ρ")
title!(rbc_2_trace_joint_α, joint_2_title)
title!(rbc_2_trace_dynare_α, dynare_2_title)
xlabel!(rbc_2_trace_joint_ρ, xlabel_time)
xlabel!(rbc_2_trace_dynare_ρ, xlabel_time)
plt = plot(rbc_2_trace_joint_α, rbc_2_trace_dynare_α,
            rbc_2_trace_joint_β, rbc_2_trace_dynare_β,
            rbc_2_trace_joint_ρ, rbc_2_trace_dynare_ρ; layout=(3,2), size=(750, 900))
savefig(plt, ".paper_results/rbc_2_traceplots.png")

