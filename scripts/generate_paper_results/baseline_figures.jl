# To execute this in VSCode/etc. ensure you do `] activate scripts` to use the appropriate manifest
using MCMCChains, CSV, DataFrames, StatsPlots, Serialization, Measures, JSON, LaTeXStrings
using HMCExamples, DynamicPPL

function generate_density_plots(run, include_vars, pseudotrues; show_pseudo_true = true, suffix="", plotargs...)
    chain = deserialize(".replication_results/$(run)/chain.jls")

    # density
    density_plot = density(chain[include_vars]; plotargs...)
    if show_pseudo_true
        vline!(density_plot, pseudotrues; linestyle = :dash, color = :black, label = "", legend = false)
    end    
    # savefig(density_plot, ".paper_results/$(run)$(suffix)_densityplots.png")
    return density_plot
end

function generate_traceplots(run, include_vars, pseudotrues; show_pseudo_true = true, suffix="", plotargs...)
    chain = deserialize(".replication_results/$(run)/chain.jls")

    # trace plots
    trace_plot = traceplot(chain[include_vars];label=false, plotargs...)
    if show_pseudo_true
        hline!(trace_plot, pseudotrues; linestyle = :dash, color = :black, label = "")
    end
    # savefig(trace_plot, ".paper_results/$(run)$(suffix)_traceplots.png")
    return trace_plot
end


function generate_scatter_plots(run, plotargs...)
    chain = deserialize(".replication_results/$(run)/chain.jls")

    α_data = chain[:, :α, 1]
    β_draw_data = chain[:, :β_draw, 1]
    ρ_data = chain[:, :ρ, 1]
    p1 = scatter(α_data, β_draw_data, xlabel = L"\alpha", ylabel = L"\beta_{draw}", legend=false, left_margin = 15mm, bottom_margin = 10mm)
    p2 = scatter(β_draw_data, ρ_data, xlabel = L"\beta_{draw}", ylabel = L"\rho", legend=false, left_margin = 15mm, bottom_margin = 10mm)
    p3 = scatter(ρ_data, α_data, xlabel = L"\rho",ylabel = L"\alpha", legend=false, left_margin = 15mm, bottom_margin = 10mm)
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
    return ϵ_plot
end


function dynare_rbc_comparison(julia_small_run, julia_big_run, dynare_run, pseudotrues, titles;show_pseudo_true, order=2, plotargs...) # order only used for filenames, doesn't check runs
    chain_julia_small = deserialize(".replication_results/$(julia_small_run)/chain.jls")    
    params_julia_small = JSON.parsefile(".replication_results/$(julia_small_run)/result.json")
    chain_julia_big = deserialize(".replication_results/$(julia_big_run)/chain.jls")    
    params_julia_big = JSON.parsefile(".replication_results/$(julia_big_run)/result.json")
    chain_dynare = deserialize(".replication_results/$(dynare_run)/chain.jls")    
    params_dynare = JSON.parsefile(".replication_results/$(dynare_run)/result.json")    


    density_plot_alpha = density(chain_julia_small[["α",]]; label="NUTS, joint, $(params_julia_small["num_samples"])", legend=true, title = titles[1], plotargs...)
    density_plot_alpha = density!(chain_julia_big[["α",]]; label="NUTS, joint, $(params_julia_big["num_samples"])", legend=true)
    density_plot = density!(chain_dynare[["α",]]; label="RWMH, particle, $(params_dynare["num_samples"])", legend=true)
    if show_pseudo_true
        vline!(density_plot_alpha, [pseudotrues[1]], linestyle = :dash, color = :black, label = "Pseudotrue")
    end

    density_plot_beta = density(chain_julia_small[["β_draw",]]; label="NUTS, joint, $(params_julia_small["num_samples"])", legend=true, title = titles[2], plotargs...)
    density_plot_beta = density!(chain_julia_big[["β_draw",]]; label="NUTS, joint, $(params_julia_big["num_samples"])",  legend=true)
    density_plot_beta = density!(chain_dynare[["β_draw",]]; label="RWMH, particle, $(params_dynare["num_samples"])", legend=true)
    if show_pseudo_true
        vline!(density_plot_beta, [pseudotrues[2]], linestyle = :dash, color = :black, label = "Pseudotrue")
    end

    density_plot_rho = density(chain_julia_small[["ρ",]], label="NUTS, joint, $(params_julia_small["num_samples"])", title = titles[3], legend=true)
    density_plot_rho = density!(chain_julia_big[["ρ",]], label="NUTS, joint, $(params_julia_big["num_samples"])", legend=true)
    density_plot_rho = density!(chain_dynare[["ρ",]], label="RWMH, particle, $(params_dynare["num_samples"])", legend=true)
    if show_pseudo_true
        vline!(density_plot_rho, [pseudotrues[3]], linestyle = :dash, color = :black, label = "Pseudotrue")
    end
    # savefig(density_plot, ".paper_results/rbc_$(order)_comparison_rho_density.png")   
    title!(density_plot_alpha, title[1])
    title!(density_plot_beta, title[2])
    title!(density_plot_rho, title[3])
    # ylabel!(density_plot_alpha, "Sample Value")
    ylabel!(density_plot_beta, "")
    ylabel!(density_plot_rho, "")
     
    return density_plot_alpha, density_plot_beta, density_plot_rho
end

function dynare_sgu_comparison_1(kalman_run, joint_run, dynare_run, include_vars, pseudotrues, titles;show_pseudo_true, lw=2, plotargs...)
    chain_kalman = deserialize(".replication_results/$(kalman_run)/chain.jls")    
    params_kalman = JSON.parsefile(".replication_results/$(kalman_run)/result.json")    
    chain_joint = deserialize(".replication_results/$(joint_run)/chain.jls")    
    params_joint = JSON.parsefile(".replication_results/$(joint_run)/result.json")        
    chain_dynare = deserialize(".replication_results/$(dynare_run)/chain.jls")    
    params_dynare = JSON.parsefile(".replication_results/$(dynare_run)/result.json")  


    density_plots = []
    for i in eachindex(include_vars)
        var = include_vars[i]
        density_plot = density(chain_kalman[[var,]]; left_margin = 15mm, top_margin = 5mm, label="",  legend=false,lw)

        density_plot = density!(chain_joint[[var,]]; left_margin = 15mm, top_margin = 5mm, label="", legend=false,lw)
        
        density_plot = density!(chain_dynare[[var,]]; left_margin = 15mm, top_margin = 5mm, label="", legend=false,lw)
        if show_pseudo_true
            vline!(density_plot, [pseudotrues[i]], linestyle = :dash, color = :black, label = "")
        end
        push!(density_plots, density_plot)
    end
    for i in eachindex(density_plots)
        title!(density_plots[i], titles[i])
        ylabel!(density_plots[i], "")
        xlabel!(density_plots[i], "")
    end    
    push!(density_plots, plot((1:3)', framestyle = :none, legend=true,  label=["NUTS, kalman," "NUTS, joint" "RWMH, kalman"]))

    plt =  plot(density_plots...;plotargs...)
    return plt
end

function dynare_sgu_comparison_2(joint_run, dynare_run, include_vars, pseudotrues, titles;show_pseudo_true, lw=2, plotargs...)
    chain_joint = deserialize(".replication_results/$(joint_run)/chain.jls")    
    params_joint = JSON.parsefile(".replication_results/$(joint_run)/result.json")        
    chain_dynare = deserialize(".replication_results/$(dynare_run)/chain.jls")    
    params_dynare = JSON.parsefile(".replication_results/$(dynare_run)/result.json")  


    density_plots = []
    for i in eachindex(include_vars)
        var = include_vars[i]
        density_plot = density(chain_joint[[var,]]; left_margin = 15mm, top_margin = 5mm, label="", legend=false,lw)
        
        density_plot = density!(chain_dynare[[var,]]; left_margin = 15mm, top_margin = 5mm, label="", legend=false,lw)
        if show_pseudo_true
            vline!(density_plot, [pseudotrues[i]], linestyle = :dash, label = "")
        end
        push!(density_plots, density_plot)
    end
    for i in eachindex(density_plots)
        title!(density_plots[i], titles[i])
        ylabel!(density_plots[i], "")
        xlabel!(density_plots[i], "")
    end
    push!(density_plots, plot((1:2)', framestyle = :none, legend=true, label=["NUTS, joint" "RWMH, particle filter"]))

    plt =  plot(density_plots...;plotargs...)
    return plt
end

# RBC experiments
rbc_params =  ["α", "β_draw", "ρ"]
title = [L"\alpha" L"\beta_{draw}" L"\rho"]
rbc_pseudotrue = [0.3 0.2 0.9]
show_pseudo_true = false
rbc_1_kalman_200_chains_density = generate_density_plots("rbc_1_kalman_200_chains",rbc_params, rbc_pseudotrue;show_pseudo_true, title)
rbc_1_joint_200_chains_density = generate_density_plots("rbc_1_joint_200_chains", rbc_params, rbc_pseudotrue;show_pseudo_true, title)
rbc_2_joint_200_chains_density = generate_density_plots("rbc_2_joint_200_chains", rbc_params, rbc_pseudotrue;show_pseudo_true, title)
rbc_1_200_dynare_density = generate_density_plots("rbc_1_200_dynare",rbc_params, rbc_pseudotrue;show_pseudo_true, title)
rbc_2_200_dynare_density = generate_density_plots("rbc_2_200_dynare",rbc_params, rbc_pseudotrue;show_pseudo_true, title)

rbc_1_kalman_200_chains_traceplots = generate_traceplots("rbc_1_kalman_200_chains",rbc_params, rbc_pseudotrue;show_pseudo_true, title)
rbc_1_joint_200_chains_traceplots = generate_traceplots("rbc_1_joint_200_chains", rbc_params, rbc_pseudotrue;show_pseudo_true, title)
rbc_2_joint_200_chains_traceplots = generate_traceplots("rbc_2_joint_200_chains", rbc_params, rbc_pseudotrue;show_pseudo_true, title)
rbc_1_200_dynare_traceplots = generate_traceplots("rbc_1_200_dynare",rbc_params, rbc_pseudotrue;show_pseudo_true, title) 
rbc_2_200_dynare_traceplots = generate_traceplots("rbc_2_200_dynare",rbc_params, rbc_pseudotrue;show_pseudo_true, title)

# Figures for chains with different experiments
plt = plot(rbc_1_kalman_200_chains_traceplots, rbc_1_kalman_200_chains_density; layout=(1,2), size = (800, 800))
savefig(plt, ".paper_results/rbc_1_kalman_200_density_traceplots.png")

plt = plot(rbc_1_joint_200_chains_traceplots, rbc_1_joint_200_chains_density; layout=(1,2), size = (800, 800))
savefig(plt, ".paper_results/rbc_1_joint_200_density_traceplots.png")

plt = plot(rbc_2_joint_200_chains_traceplots, rbc_2_joint_200_chains_density; layout=(1,2), size = (800, 800))
savefig(plt, ".paper_results/rbc_2_joint_200_density_traceplots.png")


# 2nd RBC dynare comparison
show_pseudo_true = false
density_plot_alpha, density_plot_beta, density_plot_rho = dynare_rbc_comparison("rbc_2_joint_200", "rbc_2_joint_200_long", "rbc_2_200_dynare", rbc_pseudotrue, title;show_pseudo_true, left_margin = 7mm, top_margin = 5mm)
plt = plot(density_plot_alpha, density_plot_beta, density_plot_rho; layout=(1,3), size = (1200, 300), legend=:bottomright, lw=2, ylabel=["Sample Value" "" ""])
savefig(plt, ".paper_results/rbc_2_dynare_comparison.png")

# Scatterplots
generate_scatter_plots("rbc_1_kalman_200")
generate_scatter_plots("rbc_1_joint_200")
generate_scatter_plots("rbc_2_joint_200_long")

# Use empty if you don't want the shock titled
rbc_shock_names = [""]
generate_epsilon_plots("rbc_1_joint_200", rbc_shock_names, "data/rbc_1_joint_shocks_200.csv";xlabel="t")
generate_epsilon_plots("rbc_2_joint_200_long", rbc_shock_names, "data/rbc_2_joint_shocks_200.csv";xlabel="t")

# RBC Stochastic volatility
#generate_density_plots("rbc_sv_2_joint_200",rbc_params, rbc_pseudotrue;show_pseudo_true, title)
#generate_traceplots("rbc_sv_2_joint_200",rbc_params, rbc_pseudotrue;show_pseudo_true, title)
generate_epsilon_plots("rbc_sv_2_joint_200", ["TFP Shock", "Volatility Shock"], "data/rbc_sv_2_joint_shocks_200.csv"; layout=(1, 2), size=(800,300))

# SGU traceplots are being skipped for now
# suffix_1 = "_set_1"
# sgu_include_vars_1 = ["α", "β_draw", "γ"]
# sgu_vars_1_titles = [L"\alpha", L"\beta_{draw}", L"\gamma"]
# sgu_pseudotrues_1 = [0.32 4 2.0]
# suffix_2 = "_set_2"
# sgu_include_vars_2 = ["ρ", "ρ_u", "ρ_v", "ψ"]
# sgu_vars_2_titles = [L"\rho", L"\rho_u", L"\rho_v", L"\psi"]
# sgu_pseudotrues_2 = [0.42 0.2 0.4 0.000742]

# generate_traceplots("sgu_1_kalman_200", sgu_include_vars_1, sgu_pseudotrues_1;show_pseudo_true, suffix = suffix_1)
# generate_traceplots("sgu_1_joint_200", sgu_include_vars_1, sgu_pseudotrues_1;show_pseudo_true, suffix = suffix_1)
# generate_traceplots("sgu_2_joint_200", sgu_include_vars_1, sgu_pseudotrues_1;show_pseudo_true, suffix = suffix_1)
# generate_traceplots("sgu_1_200_dynare", sgu_include_vars_1, sgu_pseudotrues_1;show_pseudo_true, suffix = suffix_1)
# generate_traceplots("sgu_2_200_dynare", sgu_include_vars_1, sgu_pseudotrues_1;show_pseudo_true, suffix = suffix_1)

# generate_traceplots("sgu_1_kalman_200", sgu_include_vars_2, sgu_pseudotrues_2;show_pseudo_true, suffix = suffix_2)
# generate_traceplots("sgu_1_joint_200", sgu_include_vars_2, sgu_pseudotrues_2;show_pseudo_true, suffix = suffix_2)
# generate_traceplots("sgu_2_joint_200", sgu_include_vars_2, sgu_pseudotrues_2;show_pseudo_true, suffix = suffix_2)
# generate_traceplots("sgu_1_200_dynare", sgu_include_vars_2, sgu_pseudotrues_2;show_pseudo_true, suffix = suffix_2)
# generate_traceplots("sgu_2_200_dynare", sgu_include_vars_2, sgu_pseudotrues_2;show_pseudo_true, suffix = suffix_2)


sgu_shock_names = [L"\epsilon_e", L"\epsilon_u", L"\epsilon_v"]
generate_epsilon_plots("sgu_1_joint_200", sgu_shock_names, "data/sgu_1_joint_shocks_200.csv"; layout=(3, 1), size=(350,500))
generate_epsilon_plots("sgu_2_joint_200", sgu_shock_names, "data/sgu_2_joint_shocks_200.csv"; layout=(3, 1), size=(350,500))


show_pseudo_true = false
sgu_include_vars = ["α", "β_draw", "γ","ρ", "ρ_u", "ρ_v", "ψ"]
sgu_vars_titles = [L"\alpha", L"\beta_{draw}", L"\gamma", L"\rho", L"\rho_u", L"\rho_v", L"\psi"]
sgu_pseudotrues = [0.32 4 2.0 0.42 0.2 0.4 0.000742]

plt = dynare_sgu_comparison_1("sgu_1_kalman_200", "sgu_1_joint_200", "sgu_1_200_dynare", sgu_include_vars, sgu_pseudotrues, sgu_vars_titles;show_pseudo_true, layout=(4,2), size = (750, 800), legend=:topleft, left_margin = 1mm, rightmargin=3mm)
ylabel!(plt[1], "Sample Value")
ylabel!(plt[3], "Sample Value")
ylabel!(plt[5], "Sample Value")
ylabel!(plt[7], "Sample Value")
savefig(plt, ".paper_results/sgu_1_comparison.png")

plt = dynare_sgu_comparison_2("sgu_2_joint_200", "sgu_2_200_dynare", sgu_include_vars, sgu_pseudotrues, sgu_vars_titles;show_pseudo_true, layout=(4,2), size = (750, 800), legend=:topleft, left_margin = 1mm, rightmargin=3mm)
ylabel!(plt[1], "Sample Value")
ylabel!(plt[3], "Sample Value")
ylabel!(plt[5], "Sample Value")
ylabel!(plt[7], "Sample Value")
savefig(plt, ".paper_results/sgu_2_comparison.png")

# # Traceplots combined.  Left out of paper for now
# rbc_1_trace_kalman  = generate_traceplots("rbc_1_kalman_200",rbc_params, rbc_pseudotrue;show_pseudo_true, title)
# rbc_1_trace_joint = generate_traceplots("rbc_1_joint_200",rbc_params, rbc_pseudotrue;show_pseudo_true, title)
# rbc_1_trace_dynare = generate_traceplots("rbc_1_200_dynare",rbc_params, rbc_pseudotrue;show_pseudo_true, title)
# rbc_2_trace_joint = generate_traceplots("rbc_2_joint_200",rbc_params, rbc_pseudotrue;show_pseudo_true, title)
# rbc_2_trace_dynare = generate_traceplots("rbc_2_200_dynare",rbc_params, rbc_pseudotrue;show_pseudo_true, title)

# function get_subplots(plt) # hardcoded to 3, removes lables before combining
#     p_1 = plot(plt[1])
#     title!(p_1, "")
#     ylabel!(p_1, "")
#     xlabel!(p_1, "")
#     p_2 = plot(plt[2])
#     title!(p_2, "")
#     ylabel!(p_2, "")
#     xlabel!(p_2, "")
#     p_3 = plot(plt[3])
#     title!(p_3, "")
#     ylabel!(p_3, "")
#     xlabel!(p_3, "")
#     p_1, p_2, p_3
# end

# rbc_1_trace_kalman_α, rbc_1_trace_kalman_β, rbc_1_trace_kalman_ρ = get_subplots(rbc_1_trace_kalman)
# rbc_1_trace_joint_α, rbc_1_trace_joint_β, rbc_1_trace_joint_ρ = get_subplots(rbc_1_trace_joint)
# rbc_1_trace_dynare_α, rbc_1_trace_dynare_β, rbc_1_trace_dynare_ρ = get_subplots(rbc_1_trace_dynare)
# rbc_2_trace_joint_α, rbc_2_trace_joint_β, rbc_2_trace_joint_ρ = get_subplots(rbc_2_trace_joint)
# rbc_2_trace_dynare_α, rbc_2_trace_dynare_β, rbc_2_trace_dynare_ρ = get_subplots(rbc_2_trace_dynare)

# #1st order one
# kalman_1_title = "NUTS with Kalman Filter"
# joint_1_title = "NUTS with Joint Likelihood"
# joint_2_title = "NUTS with Joint Likelihood"
# dynare_1_title = "RWMH with Kalman Filter"
# dynare_2_title = "RWMH with Particle Filter"
# xlabel_time = "Step"
# ylabel!(rbc_1_trace_kalman_α, "α")
# ylabel!(rbc_1_trace_kalman_β, "β_draw")
# ylabel!(rbc_1_trace_kalman_ρ, "ρ")
# title!(rbc_1_trace_kalman_α, kalman_1_title)
# title!(rbc_1_trace_joint_α, joint_1_title)
# title!(rbc_1_trace_dynare_α, dynare_1_title)
# xlabel!(rbc_1_trace_kalman_ρ, xlabel_time)
# xlabel!(rbc_1_trace_joint_ρ, xlabel_time)
# xlabel!(rbc_1_trace_dynare_ρ, xlabel_time)
# plt = plot(rbc_1_trace_kalman_α, rbc_1_trace_joint_α, rbc_1_trace_dynare_α,
# rbc_1_trace_kalman_β, rbc_1_trace_joint_β, rbc_2_trace_joint_β,
# rbc_1_trace_kalman_ρ, rbc_1_trace_joint_ρ, rbc_1_trace_dynare_ρ; layout=(3,3), size=(1200, 900))
# savefig(plt, ".paper_results/rbc_1_traceplots.png")

# ylabel!(rbc_2_trace_joint_α, "α")
# ylabel!(rbc_2_trace_joint_β, "β_draw")
# ylabel!(rbc_2_trace_joint_ρ, "ρ")
# title!(rbc_2_trace_joint_α, joint_2_title)
# title!(rbc_2_trace_dynare_α, dynare_2_title)
# xlabel!(rbc_2_trace_joint_ρ, xlabel_time)
# xlabel!(rbc_2_trace_dynare_ρ, xlabel_time)
# plt = plot(rbc_2_trace_joint_α, rbc_2_trace_dynare_α,
#             rbc_2_trace_joint_β, rbc_2_trace_dynare_β,
#             rbc_2_trace_joint_ρ, rbc_2_trace_dynare_ρ; layout=(3,2), size=(750, 900))
# savefig(plt, ".paper_results/rbc_2_traceplots.png")

