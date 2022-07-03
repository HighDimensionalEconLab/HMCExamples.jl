function calculate_num_error_prop(chain)
    num_error = get(chain, :numerical_error)
    return 100 * sum(num_error.numerical_error.data) / length(num_error.numerical_error.data)
end

# Save depends on the type of mass matrix
maybe_save_metric(filename, mass::AbstractArray) = writedlm(filename, mass, ',')
maybe_save_metric(filename, mass) = nothing # otherwise don't do anything

function calculate_experiment_results_dynare(chain, logdir, include_vars)
    rm(logdir, force=true, recursive=true)
    mkpath(logdir)
    # Store parameters in log directory
    has_num_error = (:numerical_error in keys(chain))
    last_draw = chain.value[end, :, 1][chain.name_map.parameters] |> Array
    writedlm(joinpath(logdir, "last_draw.csv"), last_draw, ',')

    # summary statistics
    sum_stats = describe(chain[include_vars])
    param_names = sum_stats[1][:, 1]
    param_mean = sum_stats[1][:, 2]
    param_sd = sum_stats[1][:, 3]
    param_ess = sum_stats[1][:, 6]
    param_rhat = sum_stats[1][:, 7]
    #param_esspersec = sum_stats[1][:, 8]
    
    CSV.write(
        joinpath(logdir, "sumstats.csv"),
        DataFrame(
            Parameter=param_names,
            Mean=param_mean,
            StdDev=param_sd,
            ESS=param_ess,
            Rhat=param_rhat,
            #ESSpersec=param_esspersec,
            Num_error=has_num_error ? calculate_num_error_prop(chain) * ones(length(include_vars)) : missing # TODO: verify the "ones" logic here?
        )
    )
    # Save the preconditioner if one is available
    if :samplerstate in keys(chain.info)
        state = chain.info.samplerstate

        # Check if there's a Hamiltonian in the state
        if :hamiltonian in propertynames(state)
            maybe_save_metric(joinpath(logdir, "preconditioner.csv"), state.hamiltonian.metric.M⁻¹)
        end

        # cumulative averages
        for (i, var) in enumerate(include_vars)
            values = chain[var]
            cum_average = MCMCChains.cummean(values)
            writedlm(
                joinpath(logdir, "cumaverage_$(i).csv"),
                cum_average,
                ','
            )
        end
    end
end
