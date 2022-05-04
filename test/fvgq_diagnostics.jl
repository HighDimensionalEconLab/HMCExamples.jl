using HMCExamples, Turing, CSV, DataFrames, DifferentiableStateSpaceModels, Random
using HMCExamples: FVGQ20_kalman, parse_commandline_FVGQ_1_kalman, Gamma_tr, InvGamma_tr, Beta_tr
d_dict = HMCExamples.parse_commandline_FVGQ_1_kalman(ARGS)
d = (; d_dict...) # Turn the dict into a named tuple

# Copied fom estimate_FVGQ_1_kalman(d)
Turing.setadbackend(:zygote)

# load data relative to the current path
data_path = joinpath(pkgdir(HMCExamples), d.data_path)
z = collect(Matrix(DataFrame(CSV.File(data_path)))')

# Create the perturbation and the turing models
const m = PerturbationModel(HMCExamples.FVGQ20)
p_d = (β=d.beta, h=d.h, κ=d.kappa, χ=d.chi, γR=d.gamma_R, γΠ=d.gamma_Pi, Πbar=d.Pi_bar, ρd=d.rho_d, ρφ=d.rho_psi, ρg=d.rho_g, g_bar=d.g_bar, σ_A=d.sigma_A, σ_d=d.sigma_d, σ_φ=d.sigma_psi, σ_μ=d.sigma_mu, σ_m=d.sigma_m, σ_g=d.sigma_g, Λμ=d.Lambda_mu, ΛA=d.Lambda_A)
p_f = (ϑ=1.0, δ=d.delta, ε=d.epsilon, ϕ=d.phi, γ2=d.gamma2, Ω_ii=d.Omega_ii, α=d.alpha, γy=d.gamma_y, θp=d.theta_p)
c = SolverCache(m, Val(1), p_d)
#create H prior
Hx = zeros(6, m.n_x)
Hy = zeros(6, m.n_y)
Hy[1, 19] = 1 # Π
Hy[2, 20] = 1 # R
Hy[3, 18] = 1 # dw, trend is μz
Hy[4, 18] = 1 # dy, trend is μz
Hy[6, 24] = 1 # μ-1
params = (β=Gamma_tr(d.beta_prior[1], d.beta_prior[2]),
    h=Beta_tr(d.h_prior[1], d.h_prior[2]),
    κ=(d.kappa_prior[1], d.kappa_prior[2], d.kappa_prior[3], d.kappa_prior[4]),
    γΠ=(d.gamma_Pi_prior[1], d.gamma_Pi_prior[2], d.gamma_Pi_prior[3], d.gamma_Pi_prior[4]),
    χ=Beta_tr(d.chi_prior[1], d.chi_prior[2]),
    γR=Beta_tr(d.gamma_R_prior[1], d.gamma_R_prior[2]),
    Πbar=Gamma_tr(d.Pi_bar_prior[1], d.Pi_bar_prior[2]),
    ρd=Beta_tr(d.rho_d_prior[1], d.rho_d_prior[2]),
    ρφ=Beta_tr(d.rho_psi_prior[1], d.rho_psi_prior[2]),
    ρg=Beta_tr(d.rho_g_prior[1], d.rho_g_prior[2]),
    g_bar=Beta_tr(d.g_bar_prior[1], d.g_bar_prior[2]),
    σ_A=InvGamma_tr(d.sigma_A_prior[1], d.sigma_A_prior[2]),
    σ_d=InvGamma_tr(d.sigma_d_prior[1], d.sigma_d_prior[2]),
    σ_φ=InvGamma_tr(d.sigma_psi_prior[1], d.sigma_psi_prior[2]),
    σ_μ=InvGamma_tr(d.sigma_mu_prior[1], d.sigma_mu_prior[2]),
    σ_m=InvGamma_tr(d.sigma_m_prior[1], d.sigma_m_prior[2]),
    σ_g=InvGamma_tr(d.sigma_g_prior[1], d.sigma_g_prior[2]),
    Λμ=Gamma_tr(d.Lambda_mu_prior[1], d.Lambda_mu_prior[2]),
    ΛA=Gamma_tr(d.Lambda_A_prior[1], d.Lambda_A_prior[2]),
    Hx=Hx,
    Hy=Hy)

settings = PerturbationSolverSettings(; print_level=d.print_level, ϵ_BK=d.epsilon_BK, d.tol_cholesky, d.check_posdef_cholesky, d.perturb_covariance)
turing_model = FVGQ20_kalman(z, m, p_f, params, c, settings)

# Sampler
num_samples = 20
num_adapts = convert(Int64, floor(num_samples * d.adapts_burnin_prop))

Random.seed!(d.seed)
init_params = [p_d...]
sampler = NUTS(num_adapts, d.target_acceptance_rate; max_depth=d.max_depth)
chain = sample(turing_model, sampler, num_samples; init_params, d.progress, save_state=true)
