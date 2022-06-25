using HMCExamples, DifferentiableStateSpaceModels, DifferenceEquations, CSV, DataFrames, Random, RecursiveArrayTools
using Turing

Random.seed!(0) # fix a seed for reproducibility

m = PerturbationModel(HMCExamples.rbc)
m_2 = PerturbationModel(HMCExamples.rbc)
p_d = (; α=0.3, β=0.998, ρ=0.9, δ=0.025, σ=0.01, Ω_1=0.00316)
p_f = nothing
T = 200

mod_perturb = generate_perturbation(m, p_d, p_f)
x0 = [0.0, 0.0]
println("first-order running...")
prob = LinearStateSpaceProblem(mod_perturb, x0, (0, T))
sol = solve(prob, DirectIteration())
z_vec = VectorOfArray(sol.z)
CSV.write(joinpath(pkgdir(HMCExamples), "data/rbc_1_fixed.csv"), DataFrame(c_obs=z_vec[1, :], i_obs=z_vec[2, :]))

mod_perturb_2 = generate_perturbation(m_2, p_d, p_f, Val(2))
println("second-order running...")
x0_2 = [0.0, 0.0]
prob_2 = QuadraticStateSpaceProblem(mod_perturb_2, x0_2, (0, T))
sol_2 = solve(prob_2, DirectIteration())
z_vec_2 = VectorOfArray(sol_2.z)
CSV.write(joinpath(pkgdir(HMCExamples), "data/rbc_2_fixed.csv"), DataFrame(c_obs=z_vec_2[1, :], i_obs=z_vec_2[2, :]))