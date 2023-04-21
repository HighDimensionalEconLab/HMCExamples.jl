using HMCExamples, DifferentiableStateSpaceModels, DifferenceEquations, CSV, DataFrames, Random, RecursiveArrayTools, Distributions

function simulate_rbc_frequentist_data()
    data_path = joinpath(pkgdir(HMCExamples), "data/rbc_frequentist")
    num_seeds = 100
    T_values = [50, 100, 200]
    p_d = (; α=0.3, β=0.998, ρ=0.9, δ=0.025, σ=0.01, Ω_1=0.00316)
    p_f = nothing

    @info "Saving results to $(data_path) and removing contents if non-empty"
    rm(data_path, force=true, recursive=true)
    mkpath(data_path)

    # Calculate perturbation
    m = PerturbationModel(HMCExamples.rbc)
    m_2 = PerturbationModel(HMCExamples.rbc)
    mod_perturb = generate_perturbation(m, p_d, p_f)
    mod_perturb_2 = generate_perturbation(m_2, p_d, p_f, Val(2))

    # Simulate data
    for T in T_values
        for counter in 1:num_seeds
            Random.seed!(counter) # fix a seed for reproducibility

            x0 = rand(MvNormal(mod_perturb.x_ergodic_var))
            prob = LinearStateSpaceProblem(mod_perturb, x0, (0, T))
            sol = solve(prob, DirectIteration())
            z_vec = VectorOfArray(sol.z)
            CSV.write(joinpath(data_path, "rbc_1_seed_$(counter)_$(T).csv"), DataFrame(c_obs=z_vec[1, :], i_obs=z_vec[2, :]))

            x0_2 = rand(MvNormal(mod_perturb_2.x_ergodic_var))
            prob_2 = QuadraticStateSpaceProblem(mod_perturb_2, x0_2, (0, T))
            sol_2 = solve(prob_2, DirectIteration())
            z_vec_2 = VectorOfArray(sol_2.z)
            CSV.write(joinpath(data_path, "rbc_2_seed_$(counter)_$(T).csv"), DataFrame(c_obs=z_vec_2[1, :], i_obs=z_vec_2[2, :]))
        end
    end
end
simulate_rbc_frequentist_data()