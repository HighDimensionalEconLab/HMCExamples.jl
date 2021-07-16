# Entry for script
function main_rbc_1_kalman(args = ARGS)
    d = parse_commandline_rbc_1_kalman(args)
    estimate_rbc_1_kalman((;d...)) # to named tuple
end


function estimate_rbc_1_kalman(d)
    # Or move these into main package when loading?
    Turing.setadbackend(:zygote)
    HMCExamples.set_BLAS_threads()
    use_tensorboard = true # could add toggle later


    # load data relative to the current path
    data_path = joinpath(pkgdir(HMCExamples), d.data_path)
    df = Matrix(DataFrame(CSV.File(data_path)))
    z = [df[i, :] for i in 1:size(df, 1)]

    
    # Create the perturbation and the turing models
    m = FirstOrderPerturbationModel(rbc_1)
    turing_model = rbc_kalman(z, m, d.p_f, d.alpha_prior, d.beta_prior, d.rho_prior, allocate_cache(m))

    # Sampling
    num_adapts = convert(Int64, floor(d.num_samples * d.adapts_burnin_prop))
    @info "Generating $(d.num_samples) samples with $(num_adapts) adapts"
    callback = TensorBoardCallback("tensorboard_logs/run")
    alg = NUTS(num_adapts, d.target_acceptance_rate)
    include_vars = ["α","β_draw","ρ"]  # variables to log
    comment = "rbc-kalman-s$(d.num_samples)-seed$(d.seed)"
    callback = make_turing_callback(m; comment, use_tensorboard, include = include_vars)  # all 


    Random.seed!(d.seed)
    chain = sample(
        turing_model,
        NUTS(num_adapts, d.target_acceptance_rate; d.max_depth),
        d.num_samples;
        init_params = d.p,
        progress = true,
        save_state = true,
        callback
    )


    # CODE TO SAVE STUFF!
    
# name = "rbc_1_kalman_seed$seed_rbc_1"
# save_experiment_results(name, chain)
# calculate_experiment_results(name, include_vars)


    # chain = sample(model, alg, d.num_samples; callback)

    # println("Generating trace plot")
    # trace_plot = plot(chain, seriestype=:traceplot)
    # savefig(trace_plot,  joinpath(callback.logger.logdir, "traceplots.png"))


    # println("Summarizing the chain")
    # sum_stats = describe(chain)
    # param_names = sum_stats[1][:,1]
    # param_mean = sum_stats[1][:,2]
    # param_sd = sum_stats[1][:,3]
    # param_ess = sum_stats[1][:,6]
    # param_rhat = sum_stats[1][:,7]
    # param_ess_per_sec = sum_stats[1][:, 8]

    # CSV.write(
    #     joinpath(callback.logger.logdir, "summary.csv"),
    #     DataFrame(
    #         parameter=param_names, 
    #         mean=param_mean, 
    #         sd=param_sd, 
    #         ess=param_ess, 
    #         rhat=param_rhat, 
    #         ess_per_sec= param_ess_per_sec
    #     )
    # )

    # # Log the ESS/sec and rhat.  Nice to show as summary results from tensorboard
    # for (i, name) = enumerate(param_names)
    #     TensorBoardLogger.log_value(
    #         callback.logger,
    #         "$(name)_ess_per_sec",
    #         param_ess_per_sec[i],
    #     )
    #     TensorBoardLogger.log_value(
    #         callback.logger,
    #         "$(name)_rhat",
    #         param_rhat[i],
    #     )
    # end

    # Store parameters in log directory
    parameter_save_path = joinpath(pkgdir(HMCExamples), "test.json")
    #parameter_save_path = joinpath(callback.logger.logdir, "parameters.json")

    @info "Storing Parameters at $(parameter_save_path) "
    open(parameter_save_path, "w") do f
        write(f, JSON.json(d))
     end
end

function parse_commandline_rbc_1_kalman(args)

    s = ArgParseSettings(fromfile_prefix_chars=['@'])

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
    end

    args_with_default = vcat("@$(pkgdir(HMCExamples))/src/rbc_1_kalman_defaults.txt", args)
    return  parse_args(args_with_default, s;as_symbols=true) 
end