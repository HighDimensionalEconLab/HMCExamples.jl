using HMCExamples, DifferentiableStateSpaceModels, DifferenceEquations, CSV, DataFrames, Random, RecursiveArrayTools, LinearAlgebra
using Turing

Random.seed!(0) # fix a seed for reproducibility

m = PerturbationModel(HMCExamples.rbc_sv)
p_d = (; α=0.3, β=0.998, ρ=0.9, δ=0.025, σ=0.01, Ω_1=0.01, ρ_σ=0.5, μ_σ=1.0, σ_σ=0.1)
p_f = nothing
T = 200

mod_perturb = generate_perturbation(m, p_d, p_f, Val(2))
x0 = rand(MvNormal(mod_perturb.x_ergodic_var))
prob = QuadraticStateSpaceProblem(mod_perturb, x0, (0, T))
sol = solve(prob, DirectIteration())
z_vec = VectorOfArray(sol.z)
W_vec = sol.W
CSV.write(joinpath(pkgdir(HMCExamples), "data/rbc_sv_2.csv"), DataFrame(c_obs=z_vec[1, :], i_obs=z_vec[2, :]))
CSV.write(joinpath(pkgdir(HMCExamples), "data/rbc_sv_2_joint_shocks.csv"), DataFrame(epsilon=W_vec[1, :], volshocks = W_vec[2, :]))