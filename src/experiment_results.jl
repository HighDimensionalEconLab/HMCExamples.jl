function print_info(d, num_adapts)
    discard_text = (d.discard_initial == -1) ? "" : " discarding the first $(d.discard_initial)"
    init_params_text = d.init_params_file == "" ? "" : " using $(d.init_params_file) as initial condition"
    seed_text = (d.seed == -1) ? "" : " with seed = $(d.seed)"
    @info "Generating $(d.num_samples) samples with $(num_adapts) adapts across $(d.num_chains) chains$(discard_text)$(init_params_text)$(seed_text)"
end

function prepare_output_directory(d, include_vars)
    if isdir(d.results_path) && !d.overwrite_results
        error("Directory $(d.results_path) already exists, and overwrite_results = false")
    end

    # delete directory if it exists. No failure if directory doesn't exist.
    @info "Saving results to $(d.results_path) and removing contents if non-empty"
    try
        rm(d.results_path, force=true, recursive=true)
    catch (e)
        @info "Could not remove $(d.results_path), continuing"
    end
    mkpath(d.results_path)


    function callback(rng, model, sampler, sample, state, i; kwargs...)
        if (d.sampling_heartbeat > 0)
            if i % d.sampling_heartbeat == 0
                println("Drawing sample $i")
            end
        end
        return
    end

    return d.results_path, callback
end

function calculate_num_error_prop(chain)
    num_error = get(chain, :numerical_error)
    return 100 * sum(num_error.numerical_error.data) / length(num_error.numerical_error.data)
end

# Save depends on the type of mass matrix
maybe_save_metric(filename, mass::AbstractArray) = writedlm(filename, mass, ',')
maybe_save_metric(filename, mass) = nothing # otherwise don't do anything

function calculate_experiment_results(d, z, chain, logdir, callback, include_vars)

    # Add information to the `d` from the data
    has_num_error = (:numerical_error in keys(chain))

    # Store the chain
    if d.save_jls
        @info "Storing Chain at $(joinpath(logdir, "chain.jls"))"
        serialize(joinpath(logdir, "chain.jls"), chain) # Basic Julia serialization.  Not portable beetween versions/machines
    end

    last_draw = chain.value[end, :, 1][chain.name_map.parameters] |> Array
    writedlm(joinpath(logdir, "last_draw.csv"), last_draw, ',')

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
            Parameter=param_names,
            Mean=param_mean,
            StdDev=param_sd,
            ESS=param_ess,
            Rhat=param_rhat,
            ESSpersec=param_esspersec,
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


    # Make a succinct results JSON including all parameters
    results = JSON.json(d)
    results["T"] = size(z, 2) - 1 # store size of observables - 1

    for (i, pname) in enumerate(param_names)
        results["$(pname)_mean"] = param_mean[i]
        results["$(pname)_std"] = param_sd[i]
        results["$(pname)_ess"] = param_ess[i]
        results["$(pname)_rhat"] = param_rhat[i]
        results["$(pname)_esspersec"] = param_esspersec[i]
    end

    # Add time difference if there is such information
    if :start_time in keys(chain.info)
        results["time_elapsed"] = chain.info.stop_time - chain.info.start_time
    end

    result_path = joinpath(logdir, "result.json")
    @info "Storing results at $result_path"
    open(result_path, "w") do io
        JSON.print(io, results)
    end
end
