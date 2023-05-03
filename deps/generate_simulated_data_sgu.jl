using HMCExamples, DifferentiableStateSpaceModels, DifferenceEquations, CSV, DataFrames, Random, RecursiveArrayTools, Distributions

Random.seed!(0) # fix a seed for reproducibility

m = PerturbationModel(HMCExamples.sgu)
p_d = (; γ = 2.0, ω = 1.455, ρ = 0.42, σe = 0.0129, δ = 0.1, ψ = 0.000742, α = 0.32,
       ϕ = 0.028, β = 1.0 / (1.0 + 0.04), r_w = 0.04, d_bar = 0.7442, ρ_u = 0.2,
       σu = 0.003, ρ_v = 0.4, σv = 0.1, Ω_1 = 0.00316)
p_f_low = (;Ω_1 = 0.00316)
p_f_high = (;Ω_1 = 0.0316) # this version matches the noise for the Dynare 2nd order model.

T = 200
m = PerturbationModel(HMCExamples.sgu)
verify_steady_state(m, p_d, p_f_high) # check closed form for steady_states


function save_linear_data(m, p_d, p_f; postfix, draw_x0)
       settings = PerturbationSolverSettings(; print_level=1, perturb_covariance = 1e-12)
       mod_perturb = generate_perturbation(m, p_d, p_f;settings)

       # draw or just set to zero
       x0 = draw_x0 ? rand(MvNormal(mod_perturb.x_ergodic_var)) : zeros(m.n_x)

       prob = LinearStateSpaceProblem(mod_perturb, x0, (0, T))
       sol = solve(prob, DirectIteration())
       z_vec = VectorOfArray(sol.z)
       CSV.write(joinpath(pkgdir(HMCExamples), "data/sgu_1_$(postfix).csv"), DataFrame(y_obs=z_vec[1, :], ca_obs=z_vec[2, :], r_obs=z_vec[3, :]))
       CSV.write(joinpath(pkgdir(HMCExamples), "data/sgu_1_$(postfix)_shocks.csv"), DataFrame(epsilon_e=vec(sol.W[1, :]), epsilon_u=vec(sol.W[2, :]), epsilon_v=vec(sol.W[3, :])))
end 

# Save for Kalman for dynare comparision, random initial condition from parameters, low noise
save_linear_data(m, p_d, p_f_low; postfix = "draw_low", draw_x0 = true)
save_linear_data(m, p_d, p_f_low; postfix = "fixed_low", draw_x0 = false)
save_linear_data(m, p_d, p_f_high; postfix = "draw_high", draw_x0 = true)
save_linear_data(m, p_d, p_f_high; postfix = "fixed_high", draw_x0 = false)


# Always set to zeros for 2nd order
function save_quadratic_data(m, p_d, p_f; postfix, draw_x0)
       settings = PerturbationSolverSettings(; print_level=1, perturb_covariance = 1e-12)
       mod_perturb = generate_perturbation(m, p_d, p_f, Val(2);settings)

       # draw or just set to zero
       x0 = draw_x0 ? rand(MvNormal(mod_perturb.x_ergodic_var)) : zeros(m.n_x)

       prob = QuadraticStateSpaceProblem(mod_perturb, x0, (0, T))
       sol = solve(prob, DirectIteration())
       z_vec = VectorOfArray(sol.z)
       CSV.write(joinpath(pkgdir(HMCExamples), "data/sgu_2_$(postfix).csv"), DataFrame(y_obs=z_vec[1, :], ca_obs=z_vec[2, :], r_obs=z_vec[3, :]))
       CSV.write(joinpath(pkgdir(HMCExamples), "data/sgu_2_$(postfix)_shocks.csv"), DataFrame(epsilon_e=vec(sol.W[1, :]), epsilon_u=vec(sol.W[2, :]), epsilon_v=vec(sol.W[3, :])))
end 

save_quadratic_data(m, p_d, p_f_high; postfix = "fixed_high", draw_x0 = false)
save_quadratic_data(m, p_d, p_f_low; postfix = "fixed_low", draw_x0 = false)
