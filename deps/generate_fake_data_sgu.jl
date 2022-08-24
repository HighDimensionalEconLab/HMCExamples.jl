using HMCExamples, DifferentiableStateSpaceModels, DifferenceEquations, CSV, DataFrames, Random, RecursiveArrayTools, Distributions

Random.seed!(0) # fix a seed for reproducibility

m = PerturbationModel(HMCExamples.sgu)
p_d = (; γ = 2.0, ω = 1.455, ρ = 0.42, σe = 0.0129, δ = 0.1, ψ = 0.000742, α = 0.32,
       ϕ = 0.028, β = 1.0 / (1.0 + 0.04), r_w = 0.04, d_bar = 0.7442, ρ_u = 0.2,
       σu = 0.003, ρ_v = 0.4, σv = 0.1, Ω_1 = 0.00316)
p_f = nothing
T = 200

settings = PerturbationSolverSettings(; print_level=1, perturb_covariance = 1e-12)
mod_perturb = generate_perturbation(m, p_d, p_f;settings)
x0 = rand(MvNormal(mod_perturb.x_ergodic_var))
prob = LinearStateSpaceProblem(mod_perturb, x0, (0, T))
sol = solve(prob, DirectIteration())
z_vec = VectorOfArray(sol.z)
CSV.write(joinpath(pkgdir(HMCExamples), "data/sgu_1.csv"), DataFrame(y_obs=z_vec[1, :], ca_obs=z_vec[2, :], r_obs=z_vec[3, :]))
CSV.write(joinpath(pkgdir(HMCExamples), "data/sgu_1_joint_shocks.csv"), DataFrame(epsilon_e=vec(sol.W[1, :]), epsilon_u=vec(sol.W[2, :]), epsilon_v=vec(sol.W[3, :])))

mod_perturb_2 = generate_perturbation(m, p_d, p_f, Val(2);settings)
x0_2 = rand(MvNormal(mod_perturb_2.x_ergodic_var))
prob_2 = QuadraticStateSpaceProblem(mod_perturb_2, x0_2, (0, T))
sol_2 = solve(prob_2, DirectIteration())
z_vec_2 = VectorOfArray(sol_2.z)
CSV.write(joinpath(pkgdir(HMCExamples), "data/sgu_2.csv"), DataFrame(y_obs=z_vec_2[1, :], ca_obs=z_vec_2[2, :], r_obs=z_vec_2[3, :]))
CSV.write(joinpath(pkgdir(HMCExamples), "data/sgu_2_joint_shocks.csv"), DataFrame(epsilon_e=vec(sol_2.W[1, :]), epsilon_u=vec(sol_2.W[2, :]), epsilon_v=vec(sol_2.W[3, :])))
