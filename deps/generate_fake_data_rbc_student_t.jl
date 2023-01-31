using HMCExamples, DifferentiableStateSpaceModels, DifferenceEquations, CSV, DataFrames, Random, RecursiveArrayTools
using Turing

Random.seed!(0) # fix a seed for reproducibility

m = PerturbationModel(HMCExamples.rbc_student_t)
p_d = (; α=0.5, β=0.95, ρ=0.2, δ=0.02, σ=0.01, Ω_1=0.01)
p_f = nothing
T = 200

mod_perturb = generate_perturbation(m, p_d, p_f)
dof = 4
shockdist = TDist(dof)
x_iv = mod_perturb.x_ergodic_var * rand(shockdist,mod_perturb.n_x)
noiseshocks = rand(shockdist, T)
noise = Matrix(noiseshocks')
prob = LinearStateSpaceProblem(mod_perturb, x_iv, (0, T); noise)
sol = solve(prob, DirectIteration())
z_vec = VectorOfArray(sol.z)
W_vec = vec(sol.W)
CSV.write(joinpath(pkgdir(HMCExamples), "data/rbc_student_t_1.csv"), DataFrame(c_obs=z_vec[1, :], k_obs=z_vec[2, :]))
CSV.write(joinpath(pkgdir(HMCExamples), "data/rbc_student_t_1_joint_shocks.csv"), DataFrame(epsilon=W_vec))
