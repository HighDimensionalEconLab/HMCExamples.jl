# Entry for script
function main_rbc_2_joint(args=ARGS)
    d = parse_commandline_rbc_2_joint(args)
    return estimate_rbc_2_joint((; d...)) # to named tuple
end

function estimate_rbc_2_joint(d)
    # Or move these into main package when loading?
    Turing.setadbackend(:zygote)
    HMCExamples.set_BLAS_threads()
    use_tensorboard = true # could add toggle later

    # load data relative to the current path
    data_path = joinpath(pkgdir(HMCExamples), d.data_path)
    df = Matrix(DataFrame(CSV.File(data_path)))
    z = [df[i, :] for i in 1:size(df, 1)]
    ϵ0 = Matrix(DataFrame(CSV.File(joinpath(pkgdir(HMCExamples), "data/epsilons_burnin_rbc_2.csv");header=false)))
    # Create the perturbation and the turing models
    m = SecondOrderPerturbationModel(rbc_2)
    turing_model = rbc_second(
        z, m, d.p_f, d.alpha_prior, d.beta_prior, d.rho_prior, allocate_cache(m)
    )

    # Sampler
    name = "rbc-second-joint-s$(d.num_samples)-seed$(d.seed)"
    include_vars = ["α", "β_draw", "ρ"]  # variables to log
    callback = TensorBoardCallback(d.results_path; name, include=include_vars)
    num_adapts = convert(Int64, floor(d.num_samples * d.adapts_burnin_prop))

    Random.seed!(d.seed)
    @info "Generating $(d.num_samples) samples with $(num_adapts) adapts"
    alg = NUTS(num_adapts, d.target_acceptance_rate)

    chain = sample(
        turing_model,
        NUTS(num_adapts, d.target_acceptance_rate; d.max_depth),
        d.num_samples;
        init_params=[d.p; ϵ0],
        progress=true,
        save_state=true,
        callback,
    )

    

    # Calculate and save results into the logdir
    calculate_experiment_results(chain, callback.logger, include_vars, d.full_results)
    
    # Store parameters in log directory
    parameter_save_path = joinpath(callback.logger.logdir, "parameters.json")

    @info "Storing Parameters at $(parameter_save_path) "
    open(parameter_save_path, "w") do f
        write(f, JSON.json(d))
    end
end

function parse_commandline_rbc_2_joint(args)
    s = ArgParseSettings(; fromfile_prefix_chars=['@'])

    # See the appropriate _defaults.txt file for the default vvalues.
    @add_arg_table! s begin
        "--data_path"
        help = "relative path to data from the root of the package"
        arg_type = String
        "--p"
        help = "Initialization of parameters"
        arg_type = Vector{Float64}
        "--p_f"
        help = "Value of fixed parameters"
        arg_type = Vector{Float64}
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
        "--full_results"
        arg_type = Bool
        help = "Save the complete set of figures and results for the chain"
    end

    args_with_default = vcat("@$(pkgdir(HMCExamples))/src/rbc_2_joint_defaults.txt", args)
    return parse_args(args_with_default, s; as_symbols=true)
end
