using HMCExamples, DifferentiableStateSpaceModels, DifferenceEquations, CSV, DataFrames, Random, RecursiveArrayTools
using Turing

Random.seed!(0) # fix a seed for reproducibility

m = PerturbationModel(HMCExamples.rbc)
p_d = (; α=0.3, β=0.998, ρ=0.9, δ=0.025, σ=0.01, Ω_1=0.00316)
p_f = nothing
T = 200

mod_perturb = generate_perturbation(m, p_d, p_f)
x0 = rand(MvNormal(mod_perturb.x_ergodic_var))
prob = LinearStateSpaceProblem(mod_perturb, x0, (0, T))
sol = solve(prob, DirectIteration())
z_vec = VectorOfArray(sol.z)
W_vec = vec(sol.W)
CSV.write(joinpath(pkgdir(HMCExamples), "data/rbc_1.csv"), DataFrame(c_obs=z_vec[1, :], i_obs=z_vec[2, :]))
CSV.write(joinpath(pkgdir(HMCExamples), "data/rbc_1_joint_shocks.csv"), DataFrame(epsilon=W_vec))

mod_perturb_2 = generate_perturbation(m, p_d, p_f, Val(2))
x0_2 = rand(MvNormal(mod_perturb_2.x_ergodic_var))
prob_2 = QuadraticStateSpaceProblem(mod_perturb_2, x0_2, (0, T))
sol_2 = solve(prob_2, DirectIteration())
z_vec_2 = VectorOfArray(sol_2.z)
W_vec_2 = vec(sol_2.W)
CSV.write(joinpath(pkgdir(HMCExamples), "data/rbc_2.csv"), DataFrame(c_obs=z_vec_2[1, :], i_obs=z_vec_2[2, :]))
CSV.write(joinpath(pkgdir(HMCExamples), "data/rbc_2_joint_shocks.csv"), DataFrame(epsilon=W_vec_2))
