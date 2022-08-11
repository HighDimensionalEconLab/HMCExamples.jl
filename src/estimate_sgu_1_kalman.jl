# Entry for script
function main_sgu_1_kalman(args=ARGS)
    d = parse_commandline_sgu_1_kalman(args)
    return estimate_sgu_1_kalman((; d...)) # to named tuple
end

function estimate_sgu_1_kalman(d)
    # Or move these into main package when loading?
    Turing.setadbackend(:zygote)

    # load data relative to the current path
    data_path = joinpath(pkgdir(HMCExamples), d.data_path)
    z = collect(Matrix(DataFrame(CSV.File(data_path)))')
    # Create the perturbation and the turing models
    m = PerturbationModel(HMCExamples.sgu)
    p_f = (γ=d.gamma, ω=d.omega, σe=d.sigmae, δ=d.delta, ψ=d.psi,
           ϕ=d.phi, r_w =d.r_w, d_bar=d.d_bar, ρ_u=d.rho_u,
           σu=d.sigmau, ρ_v=d.rho_v, σv=d.sigmav, Ω_1=d.Omega_1)
    c = SolverCache(m, Val(1), [:α, :β, :ρ])

    settings = PerturbationSolverSettings(; print_level=d.print_level, ϵ_BK=d.epsilon_BK, d.tol_cholesky, d.calculate_ergodic_distribution, d.perturb_covariance)
    turing_model = sgu_kalman(z, m, p_f, d.alpha_prior, d.beta_prior, d.rho_prior, c, settings)

    # Sampler
    include_vars = ["α", "β_draw", "ρ"]  # variables to log
    logdir, callback = prepare_output_directory(d.use_tensorboard, d, include_vars)
    num_adapts = convert(Int64, floor(d.num_samples * d.adapts_burnin_prop))

    (d.seed == -1) || Random.seed!(d.seed)
    print_info(d, num_adapts)
    metricT = DiagEuclideanMetric #  DiagEuclideanMetric, UnitEuclideanMetric, DenseEuclideanMetric
    sampler = NUTS(num_adapts, d.target_acceptance_rate; max_depth=d.max_depth, metricT)

    # 4 cases just to be careful with type-stability
    if (d.num_chains == 1) && (d.init_params_file == "")
        chain = sample(turing_model, sampler, d.num_samples; d.progress, save_state=true, d.discard_initial, callback)
        calculate_experiment_results(d, chain, logdir, callback, include_vars)
    elseif (d.num_chains == 1) && (d.init_params_file != "")
        init_params = readdlm(joinpath(pkgdir(HMCExamples), d.init_params_file), ',', Float64, '\n')[:, 1]
        chain = sample(turing_model, sampler, d.num_samples; d.progress, save_state=true, d.discard_initial, callback, init_params)
        calculate_experiment_results(d, chain, logdir, callback, include_vars)
    elseif (d.num_chains > 1) && (d.init_params_file == "")
        chain = sample(turing_model, sampler, MCMCThreads(), d.num_samples, d.num_chains; d.progress, save_state=true, d.discard_initial, callback)
        calculate_experiment_results(d, chain, logdir, callback, include_vars)
    elseif (d.num_chains > 1) && (d.init_params_file != "")
        init_params = readdlm(joinpath(pkgdir(HMCExamples), d.init_params_file), ',', Float64, '\n')[:, 1]
        chain = sample(turing_model, sampler, MCMCThreads(), d.num_samples, d.num_chains; d.progress, save_state=true, d.discard_initial, callback, init_params=[init_params for _ in 1:d.num_chains])
        calculate_experiment_results(d, chain, logdir, callback, include_vars)
    end
end

@model function sgu_kalman(z, m, p_f, α_prior, β_prior, ρ_prior, cache, settings)
    α ~ Normal(α_prior[1], α_prior[2])
    β_draw ~ Gamma(β_prior[1], β_prior[2])
    ρ ~ Beta(ρ_prior[1], ρ_prior[2])
    β = 1 / (β_draw / 100 + 1)
    p_d = (; α, β, ρ)
    (settings.print_level > 1) && @show p_d
    T = size(z, 2)
    sol = generate_perturbation(m, p_d, p_f, Val(1); cache, settings)
    (settings.print_level > 1) && println("Perturbation generated")

    if !(sol.retcode == :Success)
        (settings.print_level > 0) && println("Perturbation failed $(sol.retcode)")
        @addlogprob! -Inf
    else
        (settings.print_level > 1) && println("Calculating likelihood")
        # Simulate and get the likelihood.
        problem = LinearStateSpaceProblem(sol, zeros(size(sol.A, 1)), (0, T), observables=z)
        @addlogprob! solve(problem, KalmanFilter()).logpdf
    end
    return
end

function parse_commandline_sgu_1_kalman(args)
    s = ArgParseSettings(; fromfile_prefix_chars=['@'])

    # See the appropriate _defaults.txt file for the default values.
    @add_arg_table! s begin
        "--data_path"
        help = "relative path to data from the root of the package"
        arg_type = String
        "--gamma"
        help = "Value of fixed parameters"
        arg_type = Float64
        "--omega"
        help = "Value of fixed parameters"
        arg_type = Float64
        "--sigmae"
        help = "Value of fixed parameters"
        arg_type = Float64
        "--delta"
        help = "Value of fixed parameters"
        arg_type = Float64
        "--psi"
        help = "Value of fixed parameters"
        arg_type = Float64
        "--phi"
        help = "Value of fixed parameters"
        arg_type = Float64
        "--r_w"
        help = "Value of fixed parameters"
        arg_type = Float64
        "--d_bar"
        help = "Value of fixed parameters"
        arg_type = Float64
        "--rho_u"
        help = "Value of fixed parameters"
        arg_type = Float64
        "--sigmau"
        help = "Value of fixed parameters"
        arg_type = Float64
        "--rho_v"
        help = "Value of fixed parameters"
        arg_type = Float64
        "--sigmav"
        help = "Value of fixed parameters"
        arg_type = Float64
        "--Omega_1"
        help = "Value of fixed parameters"
        arg_type = Float64
        "--alpha_prior"
        help = "Parameters for the prior"
        arg_type = Vector{Float64}
        "--beta_prior"
        help = "Parameters for the prior"
        arg_type = Vector{Float64}
        "--rho_prior"
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

    args_with_default = vcat("@$(pkgdir(HMCExamples))/src/sgu_1_kalman_defaults.txt", args)
    return parse_args(args_with_default, s; as_symbols=true)
end