
function prepare_output_directory(use_tensorboard, d, include_vars)
    #name = "$(d.num_samples)-seed$(d.seed)" # or something along those lines.

    #callback = nothing ? use_tensorboard == false: TensorBoardCallback(d.results_path; name, include=include_vars) # later support tensorboard callbacks
    #If using tensorboard callback, the `logdir` will need to be the `.logdir` AFTER the samppler.  It will not be the `--results_path` directly

    # If the d.results_dir is a valid directory and does not exist, then create it
    # If the d.results_dir is a valid directory and not empty then check if we want to overwrite.
    # otherwise fail

    logdir = d.results_path

    if isdir(logdir) && d.overwrite_path # not a path
        return logdir, callback
    else
    end


    callback = nothing
    return logdir, callback
end

function calculate_num_error_prop(chain)
    num_error = get(chain, :numerical_error)
    return 100 * sum(num_error.numerical_error.data) / length(num_error.numerical_error.data)
end


function log_summary_statistics!(callback::Nothing, param_names, param_ess, param_rhat)
    return nothing
    # noop if nothing, later add in suppport for tensorbard callbacks
    # for (i, name) = enumerate(param_names)
    #     TensorBoardLogger.log_value(
    #         callback.logger,
    #         "$(name)_ess_per_sec",
    #         param_ess[i],
    #     )
    #     TensorBoardLogger.log_value(
    #         callback.logger,
    #         "$(name)_rhat",
    #         param_rhat[i],
    #     )
end


#function calculate_experiment_results(@nospecialize(chain), @nospecialize(logger), include_vars)
function calculate_experiment_results(chain, logdir, callback, include_vars)
    has_num_error = (:numerical_error in keys(chain))

    # Store the chain in several formats.
    # NOTE: For now, we save in JLS to start with. We comment out the next two lines for now.
    # JLSO.save(joinpath(logdir, "chain.jlso"), :chain => chain) # As JLSO, most robust
    # CSV.write(joinpath(logdir, "chain.csv"), DataFrame(chain)) # As CSV, in case everything else fails
    serialize(joinpath(logdir, "chain.jls"), chain)            # Fast but flimsy, no version control

    # summary statistics
    sum_stats = describe(chain[include_vars])
    param_names = sum_stats[1][:, 1]
    param_mean = sum_stats[1][:, 2]
    param_sd = sum_stats[1][:, 3]
    param_ess = sum_stats[1][:, 6]
    param_rhat = sum_stats[1][:, 7]
    param_esspersec = sum_stats[1][:, 8]

    CSV.write(
        joinpath(logdir, "sumstats.csv"),
        DataFrame(
            Parameter = param_names,
            Mean = param_mean,
            StdDev = param_sd,
            ESS = param_ess,
            Rhat = param_rhat,
            ESSpersec = param_esspersec,
            Num_error = has_num_error ? calculate_num_error_prop(chain) * ones(length(include_vars)) : missing # TODO: verify the "ones" logic here?
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
            writedlm(joinpath(logdir, "preconditioner.csv"), m, ',')
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
    end

    # Log the ESS/sec and rhat.  Nice to show as summary results from tensorboard
    # a noop if callback = nothing
    log_summary_statistics!(callback, param_names, param_ess, param_rhat)

    # Make a succinct results JSON
    parameters = JSON.parsefile(joinpath(logdir, "parameters.json"))

    for (i, pname) in enumerate(param_names)
        parameters["$(pname)_mean"] = param_mean[i]
        parameters["$(pname)_std"] = param_sd[i]
        parameters["$(pname)_ess"] = param_ess[i]
        parameters["$(pname)_rhat"] = param_rhat[i]
        parameters["$(pname)_esspersec"] = param_esspersec[i]
    end

    # Add time difference if there is such information
    if :start_time in keys(chain.info)
        parameters["time_elapsed"] = chain.info.stop_time - chain.info.start_time
    end

    result_path = joinpath(logdir, "result.json")
    @info "Storing results at $result_path"
    open(result_path, "w") do io
        JSON.print(io, parameters)
    end
end
