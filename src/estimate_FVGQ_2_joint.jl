# Entry for script
function main_FVGQ_2_joint(args=ARGS)
    d = parse_commandline_FVGQ_2_joint(args)
    return estimate_FVGQ_2_joint((; d...)) # to named tuple
end

function estimate_FVGQ_2_joint(d)
    # Or move these into main package when loading?
    Turing.setadbackend(:zygote)

    # load data relative to the current path
    data_path = joinpath(pkgdir(HMCExamples), d.data_path)
    z = collect(Matrix(DataFrame(CSV.File(data_path)))')

    # Create the perturbation and the turing models
    m = PerturbationModel(HMCExamples.FVGQ20)
    p_f = (ϑ=1.0, δ=d.delta, ε=d.epsilon, ϕ=d.phi, γ2=d.gamma2, Ω_ii=d.Omega_ii, α=d.alpha, γy=d.gamma_y, θp=d.theta_p)
    c = SolverCache(m, Val(2), [:β, :h, :κ, :χ, :γR, :γΠ, :Πbar, :ρd, :ρφ, :ρg, :g_bar, :σ_A, :σ_d, :σ_φ, :σ_μ, :σ_m, :σ_g, :Λμ, :ΛA])
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
    # Second-order is using pruned system. We should set x0 to be a vector of 2 * m.n_x elements.
    settings = PerturbationSolverSettings(; print_level=d.print_level, ϵ_BK=d.epsilon_BK, d.tol_cholesky, d.calculate_ergodic_distribution, d.perturb_covariance)
    turing_model = FVGQ20_joint_2(z, m, p_f, params, c, settings)

    # Sampler
    include_vars = ["β_draw", "h", "κ", "χ", "γR", "γΠ", "Πbar_draw", "ρd", "ρφ", "ρg", "g_bar", "σ_A", "σ_d", "σ_φ", "σ_μ", "σ_m", "σ_g", "Λμ", "ΛA"]  # variables to log
    logdir, callback = prepare_output_directory(d.use_tensorboard, d, include_vars)
    num_adapts = convert(Int64, floor(d.num_samples * d.adapts_burnin_prop))

    (d.seed == -1) || Random.seed!(d.seed)
    print_info(d, num_adapts)

    sampler = NUTS(num_adapts, d.target_acceptance_rate; max_depth=d.max_depth)

    # Not typesafe, but hopefully that isn't important here.
    init_params = (d.init_params_file == "") ? nothing : readdlm(joinpath(pkgdir(HMCExamples), d.init_params_file), ',', Float64, '\n')[:, 1]

    chain = (d.num_chains == 1) ? sample(turing_model, sampler, d.num_samples; d.progress,save_state=true, d.discard_initial, callback,
                                init_params) :
                                sample(turing_model, sampler, MCMCThreads(), d.num_samples, d.num_chains; d.progress, save_state=true, d.discard_initial, callback,
                                init_params = isnothing(init_params) ? nothing : [init_params for _ in 1:d.num_chains])
    calculate_experiment_results(d, chain, logdir, callback, include_vars)
end

@model function FVGQ20_joint_2(z, m, p_f, params, cache, settings)
    T = size(z, 2)
    # Priors
    β_draw ~ Gamma(params.β[1], params.β[2])
    β = 1 / (β_draw / 100 + 1)
    h ~ Beta(params.h[1], params.h[2])
    κ ~ truncated(Normal(params.κ[1], params.κ[2]), params.κ[3], params.κ[4])
    χ ~ Beta(params.χ[1], params.χ[2])
    γR ~ Beta(params.γR[1], params.γR[2])
    γΠ ~ truncated(Normal(params.γΠ[1], params.γΠ[2]), params.γΠ[3], params.γΠ[4])
    Πbar_draw ~ Gamma(params.Πbar[1], params.Πbar[2])
    Πbar = Πbar_draw / 100 + 1
    ρd ~ Beta(params.ρd[1], params.ρd[2])
    ρφ ~ Beta(params.ρφ[1], params.ρφ[2])
    ρg ~ Beta(params.ρg[1], params.ρg[2])
    g_bar ~ Beta(params.g_bar[1], params.g_bar[2])
    σ_A ~ InverseGamma(params.σ_A[1], params.σ_A[2])
    σ_d ~ InverseGamma(params.σ_d[1], params.σ_d[2])
    σ_φ ~ InverseGamma(params.σ_φ[1], params.σ_φ[2])
    σ_μ ~ InverseGamma(params.σ_μ[1], params.σ_μ[2])
    σ_m ~ InverseGamma(params.σ_m[1], params.σ_m[2])
    σ_g ~ InverseGamma(params.σ_g[1], params.σ_g[2])
    Λμ ~ Gamma(params.Λμ[1], params.Λμ[2])
    ΛA ~ Gamma(params.ΛA[1], params.ΛA[2])
    ϵ_draw ~ MvNormal(m.n_ϵ * T, 1.0)
    ϵ = reshape(ϵ_draw, m.n_ϵ, T)
    # Likelihood
    θ = (; β, h, κ, χ, γR, γΠ, Πbar, ρd, ρφ, ρg, g_bar, σ_A, σ_d, σ_φ, σ_μ, σ_m, σ_g, Λμ, ΛA)
    (settings.print_level > 1) && @show θ
    sol = generate_perturbation(m, θ, p_f, Val(2); cache, settings)
    (settings.print_level > 1) && println("Perturbation generated")
    if !(sol.retcode == :Success)
        (settings.print_level > 0) && println("Perturbation failed $(sol.retcode)")
        @addlogprob! -Inf

    else
        z_trend = params.Hx * sol.x + params.Hy * sol.y
        z_detrended = z .- z_trend
        # Simulate and get the likelihood.
        x0 = zeros(m.n_x) # the initial condition
        problem = QuadraticStateSpaceProblem(sol, x0, (0, T), observables=z_detrended, noise=ϵ)
        @addlogprob! solve(problem, DirectIteration()).logpdf
    end
    return
end

function parse_commandline_FVGQ_2_joint(args)
    s = ArgParseSettings(; fromfile_prefix_chars=['@'])

    # See the appropriate _defaults.txt file for the default values.
    @add_arg_table! s begin
        "--data_path"
        help = "relative path to data from the root of the package"
        arg_type = String
        "--delta"
        help = "Value of fixed parameters"
        arg_type = Float64
        "--epsilon"
        help = "Value of fixed parameters"
        arg_type = Float64
        "--phi"
        help = "Value of fixed parameters"
        arg_type = Float64
        "--gamma2"
        help = "Value of fixed parameters"
        arg_type = Float64
        "--Omega_ii"
        help = "Value of fixed parameters"
        arg_type = Float64
        "--alpha"
        help = "Value of fixed parameters"
        arg_type = Float64
        "--gamma_y"
        help = "Value of fixed parameters"
        arg_type = Float64
        "--theta_p"
        help = "Value of fixed parameters"
        arg_type = Float64

        "--kappa_prior"
        help = "Value of fixed parameters"
        arg_type = Vector{Float64}
        "--gamma_Pi_prior"
        help = "Value of fixed parameters"
        arg_type = Vector{Float64}

        "--beta_prior"
        help = "Parameters for the prior"
        arg_type = Vector{Float64}
        "--h_prior"
        help = "Parameters for the prior"
        arg_type = Vector{Float64}
        "--chi_prior"
        help = "Parameters for the prior"
        arg_type = Vector{Float64}
        "--gamma_R_prior"
        help = "Parameters for the prior"
        arg_type = Vector{Float64}
        "--Pi_bar_prior"
        help = "Parameters for the prior"
        arg_type = Vector{Float64}
        "--rho_d_prior"
        help = "Parameters for the prior"
        arg_type = Vector{Float64}
        "--rho_psi_prior"
        help = "Parameters for the prior"
        arg_type = Vector{Float64}
        "--rho_g_prior"
        help = "Parameters for the prior"
        arg_type = Vector{Float64}
        "--g_bar_prior"
        help = "Parameters for the prior"
        arg_type = Vector{Float64}

        "--sigma_A_prior"
        help = "Parameters for the prior"
        arg_type = Vector{Float64}
        "--sigma_d_prior"
        help = "Parameters for the prior"
        arg_type = Vector{Float64}
        "--sigma_psi_prior"
        help = "Parameters for the prior"
        arg_type = Vector{Float64}
        "--sigma_mu_prior"
        help = "Parameters for the prior"
        arg_type = Vector{Float64}
        "--sigma_m_prior"
        help = "Parameters for the prior"
        arg_type = Vector{Float64}
        "--sigma_g_prior"
        help = "Parameters for the prior"
        arg_type = Vector{Float64}

        "--Lambda_mu_prior"
        help = "Parameters for the prior"
        arg_type = Vector{Float64}
        "--Lambda_A_prior"
        help = "Parameters for the prior"
        arg_type = Vector{Float64}


        help = "Parameters for the prior"
        arg_type = Vector{Float64}
        "--num_samples"
        help = "samples to draw in chain"
        arg_type = Int64
        "--num_chains"
        help = "number of chains to sample"
        arg_type = Int64
        "--adapts_burnin_prop"
        help = "Proportion of Adaptations burned in"
        arg_type = Float64
        "--target_acceptance_rate"
        help = "Target acceptance rate for dual averaging for NUTS"
        arg_type = Float64
        "--max_depth"
        help = "Maximum depth for NUTS"
        arg_type = Int64
        "--seed"
        help = "Random number seed"
        arg_type = Int64
        "--results_path"
        arg_type = String
        help = "Location to store results and logs"
        "--overwrite_results"
        arg_type = Bool
        help = "Overwrite results at results_path"
        "--print_level"
        arg_type = Int64
        help = "Print level for output during sampling"
        "--epsilon_BK"
        arg_type = Float64
        help = "Threshold for Checking Blanchard-Khan condition"
        "--tol_cholesky"
        arg_type = Float64
        help = "Tolerance for checking explosiveness of the norm of the covariance matrix"
        "--perturb_covariance"
        arg_type = Float64
        help = "Perturb diagonal of the covariance matrix before taking cholesky. Defaults to machine epsilon"
        "--calculate_ergodic_distribution"
        arg_type = Bool
        help = "Calculate the covariance matrix of the ergodic distribution"
        "--use_tensorboard"
        arg_type = Bool
        help = "Log to tensorboard"
        "--progress"
        arg_type = Bool
        help = "Show progress"
        "--save_jls"
        arg_type = Bool
        help = "Save the jls serialization (not portable)"
        "--save_hd5"
        arg_type = Bool
        help = "Save the hd5 serialization"
        "--init_params_file"
        arg_type = String
        help = "Use file for initializing the chain. Ignores other initial conditions"
        "--discard_initial"
        arg_type = Int64
        help = "Number of draws to discard for warmup"
        "--sampling_heartbeat"
        arg_type = Int64
        help = "Display draws at this frequency.  No output if it is 0"

    end

    args_with_default = vcat("@$(pkgdir(HMCExamples))/src/FVGQ_2_joint_defaults.txt", args)
    return parse_args(args_with_default, s; as_symbols=true)

end
