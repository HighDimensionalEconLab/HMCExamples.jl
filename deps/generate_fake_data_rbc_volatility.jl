using HMCExamples, DifferentiableStateSpaceModels, DifferenceEquations, CSV, DataFrames, Random, RecursiveArrayTools, LinearAlgebra
using Turing

Random.seed!(0) # fix a seed for reproducibility
m = PerturbationModel(HMCExamples.rbc_simple)
p_d = (; α=0.5, β=0.95, ρ=0.2, δ=0.02, σ=0.01, Ω_1=0.01)
p_f = nothing
T = 200

ρ_σ = 0.5  # Persistence of log volatility
μ_σ = 1.  # Mean of (prescaling) volatility
σ_σ = 0.1  # Volatility of volatility

mod_perturb = generate_perturbation(m, p_d, p_f)
x0 = rand(MvNormal(mod_perturb.x_ergodic_var))
noise = Matrix(rand(MvNormal(mod_perturb.n_ϵ, 1.0), T))
volshocks = Matrix(rand(MvNormal(T, 1.0))')
obsshocks = reshape(rand(MvNormal(T*mod_perturb.n_z, p_d[:Ω_1])), mod_perturb.n_z, T)

# Extract solution matrices
A = mod_perturb.A
B = mod_perturb.B
C = mod_perturb.C
D = mod_perturb.D

# Initialize
u = [zero(x0) for _ in 1:T]
u[1] .= x0
vol = [zeros(1) for _ in 1:T]
vol[1] = [μ_σ]  # Start at mean: could make random but won't for now

# Allocate sequence
z = [zeros(size(C, 1)) for _ in 1:T] 
mul!(z[1], C, u[1])  # update the first of z
for t in 2:T
    mul!(u[t], A, u[t - 1])  # sets u[t] = A * u[t - 1]
    mul!(vol[t], ρ_σ, vol[t-1])
    vol[t] .+= (1 - ρ_σ) * μ_σ
    mul!(vol[t], σ_σ, view(volshocks, :, t - 1), 1, 1)  # adds σ_σ * volshocks[t-1] to vol[t]
    mul!(u[t], exp(vol[t][]) .* B, view(noise, :, t - 1), 1, 1)
    mul!(z[t], C, u[t]) 
end
for t in 1:T  # Add observation noise
    z[t] .+= view(obsshocks, :, t)
end

z_vec = VectorOfArray(z)
W_vec = vec(noise)
vol_vec = VectorOfArray(vol)
CSV.write(joinpath(pkgdir(HMCExamples), "data/rbc_volatility_1.csv"), DataFrame(c_obs=z_vec[1, :], k_obs=z_vec[2, :]))
CSV.write(joinpath(pkgdir(HMCExamples), "data/rbc_volatility_1_joint_shocks.csv"), DataFrame(epsilon=W_vec))
CSV.write(joinpath(pkgdir(HMCExamples), "data/rbc_volatility_1_joint_volshocks.csv"), DataFrame(epsilon=vol_vec[1, :]))