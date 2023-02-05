# Entry for script
function main_rbc_volatility_1_joint(args=ARGS)
    d = parse_commandline_rbc_volatility_1_joint(args)
    return estimate_rbc_volatility_1_joint((; d...)) # to named tuple
end

function estimate_rbc_volatility_1_joint(d)
    # Or move these into main package when loading?
    Turing.setadbackend(:zygote)

    # load data relative to the current path
    data_path = joinpath(pkgdir(HMCExamples), d.data_path)
    z = collect(Matrix(DataFrame(CSV.File(data_path)))')
    # Create the perturbation and the turing models
    m = PerturbationModel(HMCExamples.rbc_simple)
    p_f = (ρ=d.rho, δ=d.delta, σ=d.sigma, Ω_1=d.Omega_1)
    c = SolverCache(m, Val(1), [:α, :β])

    settings = PerturbationSolverSettings(; print_level=d.print_level, ϵ_BK=d.epsilon_BK, d.tol_cholesky, d.calculate_ergodic_distribution, d.perturb_covariance)
    turing_model = rbc_volatility_joint_1(
        z, m, p_f, d.alpha_prior, d.beta_prior, d,ρ_σ_prior, d.μ_σ_prior, d.σ_σ_prior, c, settings
    )

    # Sampler
    include_vars = ["α", "β"]  # variables to log
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

@model function rbc_volatility_joint_1(z, m, p_f, α_prior, β_prior, ρ_σ_prior, μ_σ_prior, σ_σ_prior, cache, settings)
    α ~ Uniform(α_prior[1], α_prior[2])
    β ~ Uniform(β_prior[1], β_prior[2])
    ρ_σ ~ Beta(ρ_σ_prior[1], ρ_σ_prior[2])
    μ_σ ~ Normal(μ_σ_prior[1], μ_σ_prior[2])
    σ_σ ~ Uniform(σ_σ_prior[1], σ_σ_prior[2])
    p_d = (; α, β)

    T = size(z, 2)
    ϵ_draw ~ MvNormal(m.n_ϵ * T, 1.0)
    ϵ = reshape(ϵ_draw, m.n_ϵ, T)
    vs_draw ~ MvNormal(T, 1.0)
    volshocks = reshape(vs_draw, 1, T)  
    sol = generate_perturbation(m, p_d, p_f, Val(1); cache, settings)
    x0 ~ MvNormal(sol.x_ergodic_var) # draw the initial condition

    if !(sol.retcode == :Success)
        @addlogprob! -Inf
        return
    end
    @addlogprob! (sol.A, sol.B, sol.C, sol.D, x0, p_f[:Ω_1], μ_σ, ρ_σ, σ_σ, z, ϵ, volshocks)
end

function rbc_volatility_likelihood(A, B, C, D, x0, Ω_1, μ_σ, ρ_σ, σ_σ, observables, noise, volshocks)
    # Likelihood evaluation function using `Zygote.Buffer()` to create internal arrays that don't interfere with gradients.
    T = size(observables,2)
    u = Zygote.Buffer([zero(x0) for _ in 1:T])  # Fix type: Array of vector of vectors?
    vol = Zygote.Buffer([zeros(1) for _ in 1:T])  # Fix type: Array of vector of vectors?
    u[1] = x0 
    vol[1] = [μ_σ]  # Start at mean: could make random but won't for now
    for t in 2:T
        vol[t] = ρ_σ * vol[t-1] .+ (1 - ρ_σ) * μ_σ .+ σ_σ * volshocks[t - 1]
        u[t] = A * u[t - 1] .+ exp.(vol[t]) .* (B * noise[t - 1])[:]
    end
    loglik = sum([logpdf(MvNormal(Diagonal(Ω_1 * ones(size(C, 1)))), observables[t] .- C * u[t]) for t in 1:T])
    return loglik
end

function parse_commandline_rbc_volatility_1_joint(args)
    s = ArgParseSettings(; fromfile_prefix_chars=['@'])

    # See the appropriate _defaults.txt file for the default values.
    @add_arg_table! s begin
        "--data_path"
        help = "relative path to data from the root of the package"
        arg_type = String
        "--rho"
        help = "Value of fixed parameters"
        arg_type = Float64
        "--delta"
        help = "Value of fixed parameters"
        arg_type = Float64
        "--sigma"
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
        "--rho_sigma_prior"
        help = "Parameters for the prior"
        arg_type = Vector{Float64}
        "--mu_sigma_prior"
        help = "Parameters for the prior"
        arg_type = Vector{Float64}
        "--sigma_sigma_prior"
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

    args_with_default = vcat("@$(pkgdir(HMCExamples))/src/rbc_volatility_1_joint_defaults.txt", args)
    return parse_args(args_with_default, s; as_symbols=true)
end