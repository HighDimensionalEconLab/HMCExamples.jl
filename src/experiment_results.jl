function calculate_experiment_results(chain, logger, include_vars)
    logdir = logger.logdir

    trace_plot = plot(chain[include_vars], seriestype=:traceplot)
    savefig(trace_plot, joinpath(logdir, "traceplots.png"))

    # density
    density_plot = density(chain[include_vars])
    savefig(density_plot, joinpath(logdir, "densityplots.png"))

    # Likelihood
    likelihood_plot = plot(chain[:lp])
    savefig(likelihood_plot, joinpath(logdir, "likelihoodplots.png"))

    # Numerical errors
    if :numerical_error in keys(chain)
        num_error = get(chain, :numerical_error)
        prop = 100 * sum(num_error.numerical_error.data) / length(num_error.numerical_error.data)
        numerror_plot = plot(chain[:numerical_error])
        savefig(numerror_plot, joinpath(logdir, "numerrorplots.png"))
    else
        prop = missing
    end

    # summary statistics
    sum_stats = describe(chain[include_vars])
    param_names = sum_stats[1][:,1]
    param_mean = sum_stats[1][:,2]
    param_sd = sum_stats[1][:,3]
    param_ess = sum_stats[1][:,6]
    param_rhat = sum_stats[1][:,7]

    CSV.write(
        joinpath(logdir, "sumstats.csv"),
        DataFrame(
            Parameter=param_names,
            Mean=param_mean,
            sd=param_sd,
            ess=param_ess,
            rhat=param_rhat,
            Num_error= ismissing(prop) ? missing : prop * ones(length(include_vars))
        )
    )

    # Save the preconditioner if one is available
    if :samplerstate in keys(chain.info)
        state = chain.info.samplerstate

        # Check if there's a Hamiltonian in the state
        if :hamiltonian in propertynames(state)
            h = state.hamiltonian

            # Get the metric
            mass = h.metric.M⁻¹
            mass_shape = size(mass)

            # If it's diagonal, make it dense
            m = if length(mass_shape) == 1
                diagm(mass)
            else
                mass
            end

            # Write it to disk
            writedlm(joinpath(logdir,"preconditioner.csv"), m, ',')
        end
    end

    # cumulative averages
    for var in include_vars
        values = chain[var]
        cum_average = MCMCChains.cummean(values)
        writedlm(
            joinpath(logdir, "cumaverage_$(var).csv"),
            cum_average,
            ','
        )
    end

    # Cumulative mean plots
    cummean_plot = meanplot(chain[include_vars])
    savefig(cummean_plot, joinpath(logdir, "cummean.png"))

    # Log the ESS/sec and rhat.  Nice to show as summary results from tensorboard
    for (i, name) = enumerate(param_names)
        TensorBoardLogger.log_value(
            logger,
            "$(name)_ess_per_sec",
            param_ess[i],
        )
        TensorBoardLogger.log_value(
            logger,
            "$(name)_rhat",
            param_rhat[i],
        )
    end

end