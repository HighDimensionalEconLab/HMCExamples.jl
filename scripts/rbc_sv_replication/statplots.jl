using HDF5, MCMCChains, MCMCChainsStorage, CSV, DataFrames, StatsPlots, Measures, Dates
using HMCExamples, DifferentiableStateSpaceModels, DifferenceEquations, Random, Distributions, RecursiveArrayTools


Random.seed!(0) # fix a seed for reproducibility

function generate_plots()
    println("generating plots")
    include_vars = ["α", "β_draw", "ρ"]
    pseudotrues = [0.3 0.2 0.9]
    chain_joint_1 = h5open(".experiments/rbc_sv/rbc_sv_2_joint/chain.h5", "r") do f
        read(f, Chains)
    end

    println("  deserialization complete")
    
    # trace plots
    trace_plot = traceplot(chain_joint_1[include_vars], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm, right_margin = 10mm)
    hline!(trace_plot, pseudotrues, linestyle = :dash, color = :black, label = "", size = (600, 1000))
    savefig(trace_plot, ".figures/traceplots_rbc_sv_2_joint_1.png")

    # density
    density_plot = density(chain_joint_1[include_vars], left_margin = 20mm, top_margin = 5mm, bottom_margin = 10mm, label = "NUTS, joint")
    vline!(density_plot, pseudotrues, linestyle = :dash, color = :black, label = "", legend = :outertopright, size = (600, 1000))
    savefig(density_plot, ".figures/densityplots_rbc_sv.png")

    for (batch, chain) in [("2_joint", chain_joint_1)]
        # time series plots

        m = PerturbationModel(HMCExamples.rbc_sv)
        p_f = nothing
        T = 200

        symbol_to_int(s) = parse(Int, replace(string(s), "ϵ_draw["=>"", "]"=>""))
        ϵ_chain = sort(chain[:, [Symbol("ϵ_draw[$a]") for a in 1:2:401], 1], lt = (x,y) -> symbol_to_int(x) < symbol_to_int(y))
        ϵ_stats = describe(ϵ_chain)
        ϵ_data = hcat(get_params(ϵ_chain[:, :, 1]).ϵ_draw...)
        ϵ_mean = ϵ_stats[1][:, 2]
        ϵ_std = ϵ_stats[1][:, 3]

        vol_chain = sort(chain[:, [Symbol("ϵ_draw[$a]") for a in 2:2:402], 1], lt = (x,y) -> symbol_to_int(x) < symbol_to_int(y))
        vol_stats = describe(vol_chain) 
        vol_data = hcat(get_params(vol_chain[:, :, 1]).ϵ_draw...)                
        vol_mean = vol_stats[1][:, 2]
        vol_std = vol_stats[1][:, 3]
        
        p_data = get_params(chain[include_vars])
        num_samples = size(chain)[1]
        save_zlag = zeros(num_samples, T+1)
        save_ν = zeros(num_samples, T+1)

        for i in 1:num_samples
            p_d = (; α=p_data.α[i], β=1 / (p_data.β_draw[i] / 100 + 1), ρ=p_data.ρ[i], δ=0.025, σ=0.01, Ω_1=0.01, ρ_σ=0.5, μ_σ=1.0, σ_σ=0.1)
            mod_perturb = generate_perturbation(m, p_d, p_f, Val(2))
            x0 = rand(MvNormal(mod_perturb.x_ergodic_var))
            prob = QuadraticStateSpaceProblem(mod_perturb, x0, (0, T), noise=vcat(ϵ_data[i:i, 2:end], vol_data[i:i, 2:end]), observables_noise = nothing)
            sol = solve(prob, DirectIteration())
            u_vec = VectorOfArray(sol.u)
            save_zlag[i, :] = u_vec[2, :]
            save_ν[i, :] = u_vec[3, :]
        end
        
        # Import the true values
        shock_true = Matrix(DataFrame(CSV.File("data/rbc_sv_$(batch)_shocks.csv")))'
        latent_true = Matrix(DataFrame(CSV.File("data/rbc_sv_$(batch)_latents.csv")))'

        # Plot and save
        ϵ_plot = plot(ϵ_mean[2:end], ribbon=2 * ϵ_std[2:end], label="Posterior mean")
        ϵ_plot = plot!(shock_true[1, :], label="True values")
        savefig(ϵ_plot, ".figures/epsilons_rbc_sv_$(batch).png")

        vol_plot = plot(vol_mean[2:end], ribbon=2 * vol_std[2:end], label="Posterior mean")
        vol_plot = plot!(shock_true[2, :], label="True values")
        savefig(vol_plot, ".figures/volshocks_rbc_sv_$(batch).png")

        zlag_plot = plot(vec(mean(save_zlag, dims = 1)), ribbon=2 * vec(std(save_zlag, dims = 1)), label="Posterior mean")
        zlag_plot = plot!(latent_true[1, :], label="True values")
        savefig(zlag_plot, ".figures/zlag_rbc_sv_$(batch).png")

        ν_plot = plot(vec(mean(save_ν, dims = 1)), ribbon=2 * vec(std(save_ν, dims = 1)), label="Posterior mean")
        ν_plot = plot!(latent_true[2, :], label="True values")
        savefig(ν_plot, ".figures/nu_rbc_sv_$(batch).png")
    end
    
    println("  plots complete")
end

generate_plots()
