# Entry for script
function main_rbc_1_joint(args=ARGS)
    d = parse_commandline_rbc_1_joint(args)
    return estimate_rbc_1_joint((; d...)) # to named tuple
end

function estimate_rbc_1_joint(d)
    # Or move these into main package when loading?
    Turing.setadbackend(:zygote)
    HMCExamples.set_BLAS_threads()
    use_tensorboard = true # could add toggle later

    # load data relative to the current path
    data_path = joinpath(pkgdir(HMCExamples), d.data_path)
    df = Matrix(DataFrame(CSV.File(data_path)))
    z = [df[i, :] for i in 1:size(df, 1)]
    ϵ0 = Matrix(DataFrame(CSV.File(joinpath(pkgdir(HMCExamples), "data/epsilons_burnin_rbc_1.csv");header=false)))
    # Create the perturbation and the turing models
    m = PerturbationModel(HMCExamples.rbc)
    p_d = (α = d.alpha, β = d.beta, ρ = d.rho)
    p_f = (δ = d.delta, σ = d.sigma, Ω_1 = d.Omega_1)
    c = SolverCache(m, Val(1), p_d)
    turing_model = rbc_joint(z, m, p_f, d.alpha_prior, d.beta_prior, d.rho_prior, c, PerturbationSolverSettings(; print_level = d.print_level))
    
    # Sampler
    name = "rbc-joint-s$(d.num_samples)-seed$(d.seed)"
    include_vars = ["α", "β_draw", "ρ"]  # variables to log
    callback = TensorBoardCallback(d.results_path; name, include=include_vars)
    num_adapts = convert(Int64, floor(d.num_samples * d.adapts_burnin_prop))

    Random.seed!(d.seed)
    @info "Generating $(d.num_samples) samples with $(num_adapts) adapts across $(d.num_chains) chains"

    chain = sample(
        turing_model, 
        # NUTS(num_adapts, d.target_acceptance_rate; max_depth = d.max_depth),
        MH(),
        d.num_samples;
        init_params=[p_d..., ϵ0],
        progress=true,
        save_state=true,
        callback,
    )

    # Store parameters in log directory
    parameter_save_path = joinpath(callback.logger.logdir, "parameters.json")

    @info "Storing Parameters at $(parameter_save_path) "
    open(parameter_save_path, "w") do f
        write(f, JSON.json(d))
    end

    # Calculate and save results into the logdir
    calculate_experiment_results(chain, callback.logger, include_vars)
end

function parse_commandline_rbc_1_joint(args)
    s = ArgParseSettings(; fromfile_prefix_chars=['@'])

    # See the appropriate _defaults.txt file for the default vvalues.
    @add_arg_table! s begin
        "--data_path"
        help = "relative path to data from the root of the package"
        arg_type = String
        "--alpha"
        help = "Initialization of parameters"
        arg_type = Float64
        "--beta"
        help = "Initialization of parameters"
        arg_type = Float64
        "--rho"
        help = "Initialization of parameters"
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
        "--print_level"
        arg_type = Int64
        help = "Print level for output during sampling"
        "--epsilon_BK"
        arg_type = Float64
        help = "Threshold for Checking Blanchard-Khan condition"        
        "--use_solution_cache"
        arg_type = Bool
        help = "Use solution cache in perturbation solutions"

    end

    args_with_default = vcat("@$(pkgdir(HMCExamples))/src/rbc_1_joint_defaults.txt", args)
    return parse_args(args_with_default, s; as_symbols=true)
end