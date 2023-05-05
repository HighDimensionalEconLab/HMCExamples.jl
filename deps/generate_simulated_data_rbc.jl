using HMCExamples, DifferentiableStateSpaceModels, DifferenceEquations, CSV, DataFrames, Random, RecursiveArrayTools, Distributions

T_values = [200, 500]
p_d = (; α=0.3, β=0.998, ρ=0.9, δ=0.025, σ=0.01, Ω_1=0.00316)
p_f = nothing

# Calculate perturbation
m = PerturbationModel(HMCExamples.rbc)
mod_perturb = generate_perturbation(m, p_d, p_f)
mod_perturb_2 = generate_perturbation(m, p_d, p_f, Val(2))

# Simulate data
for T in T_values
    Random.seed!(0) # fix a seed for reproducibility
    
    x0 = zeros(m.n_x)
    prob = LinearStateSpaceProblem(mod_perturb, x0, (0, T))
    sol = solve(prob, DirectIteration())
    z_vec = VectorOfArray(sol.z)
    W_vec = vec(sol.W)
    CSV.write(joinpath(pkgdir(HMCExamples), "data/rbc_1_$(T).csv"), DataFrame(c_obs=z_vec[1, :], i_obs=z_vec[2, :]))
    CSV.write(joinpath(pkgdir(HMCExamples), "data/rbc_1_joint_shocks_$(T).csv"), DataFrame(epsilon=W_vec))

    x0_2 = zeros(m.n_x)
    prob_2 = QuadraticStateSpaceProblem(mod_perturb_2, x0_2, (0, T))
    sol_2 = solve(prob_2, DirectIteration())
    z_vec_2 = VectorOfArray(sol_2.z)
    W_vec_2 = vec(sol_2.W)
    CSV.write(joinpath(pkgdir(HMCExamples), "data/rbc_2_$(T).csv"), DataFrame(c_obs=z_vec_2[1, :], i_obs=z_vec_2[2, :]))
    CSV.write(joinpath(pkgdir(HMCExamples), "data/rbc_2_joint_shocks_$(T).csv"), DataFrame(epsilon=W_vec_2))
end