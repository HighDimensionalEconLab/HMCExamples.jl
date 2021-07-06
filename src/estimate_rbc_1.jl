function simulate_and_estimate_rbc_1(d;
    num_samples,
    num_adapts,
    target_acceptance_rate,
    s_prior_alpha,
    s_prior_theta,
    kwargs...,
)
    @model function demo(x; s_prior_alpha, s_prior_theta)
        s ~ InverseGamma(s_prior_alpha, s_prior_theta)
        m ~ Normal(0, √s)
        for i in eachindex(x)
            x[i] ~ Normal(m, √s)
        end
    end

    xs = randn(100) .+ 1
    model = demo(xs; s_prior_alpha, s_prior_theta)

    # Sampling
    println("Generating $num_samples samples")
    callback = TensorBoardCallback("tensorboard_logs/run")
    alg = NUTS(num_adapts, target_acceptance_rate)
    chain = sample(model, alg, num_samples; callback)

    println("Generating trace plot")
    trace_plot = plot(chain, seriestype=:traceplot)
    savefig(trace_plot,  joinpath(callback.logger.logdir, "traceplots.png"))


    println("Summarizing the chain")
    sum_stats = describe(chain)
    param_names = sum_stats[1][:,1]
    param_mean = sum_stats[1][:,2]
    param_sd = sum_stats[1][:,3]
    param_ess = sum_stats[1][:,6]
    param_rhat = sum_stats[1][:,7]
    param_ess_per_sec = sum_stats[1][:, 8]

    CSV.write(
        joinpath(callback.logger.logdir, "summary.csv"),
        DataFrame(
            parameter=param_names, 
            mean=param_mean, 
            sd=param_sd, 
            ess=param_ess, 
            rhat=param_rhat, 
            ess_per_sec= param_ess_per_sec
        )
    )

    # Log the ESS/sec and rhat.  Nice to show as summary results from tensorboard
    for (i, name) = enumerate(param_names)
        TensorBoardLogger.log_value(
            callback.logger,
            "$(name)_ess_per_sec",
            param_ess_per_sec[i],
        )
        TensorBoardLogger.log_value(
            callback.logger,
            "$(name)_rhat",
            param_rhat[i],
        )
    end

    # Store parameters in log directory
    println("Storing Parameters")    
    open(joinpath(callback.logger.logdir, "parameters.json"), "w") do f
        write(f, JSON.json(d))
     end
     return
end

# Entry for script
function rbc_1_main()

    s = ArgParseSettings()

    @add_arg_table! s begin
        "--num_samples"
            help = "samples to draw in chain"
            arg_type = Int64
            default = 10_000
        "--adapts_burnin_prop"
            help = "Proportion of Adaptations burned in"
            arg_type = Float64
            default = 0.1
        "--num_adapts"  # REMOVE
            help = "Number of Adaptations"
            arg_type = Int64
            default = 100         
        "--target_acceptance_rate"
            help = "Target acceptance rate for dual averaging."
            arg_type = Float64
            default = 0.65
        "--s_prior_alpha"
            help = "alpha in InverseGamma prior for s"
            arg_type = Float64
            default = 2.0
        "--s_prior_theta"
            help = "theta in InverseGamma prior for s"
            arg_type = Float64
            default = 3.0
    end

    d =  parse_args(s;as_symbols=true)    

    # Simulate
    simulate_and_estimate_rbc_1(d; d...) #passing in dictionary just to save in logdir

end