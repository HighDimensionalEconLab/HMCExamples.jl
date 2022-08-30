# Save depends on the type of mass matrix
maybe_save_metric(filename, mass::AbstractArray) = writedlm(filename, mass, ',')
maybe_save_metric(filename, mass) = nothing # otherwise don't do anything

function calculate_experiment_results_dynare(chain, logdir, include_vars, runtime)
    rm(logdir, force=true, recursive=true)
    mkpath(logdir)
    # Store parameters in log directory
    last_draw = chain.value[end, :, 1][chain.name_map.parameters] |> Array
    writedlm(joinpath(logdir, "last_draw.csv"), last_draw, ',')

    # summary statistics
    sum_stats = describe(chain[include_vars])
    param_names = sum_stats[1][:, 1]
    param_mean = sum_stats[1][:, 2]
    param_sd = sum_stats[1][:, 3]
    param_ess = sum_stats[1][:, 6]
    param_rhat = sum_stats[1][:, 7]
    param_esspersec = param_ess / runtime
    CSV.write(
        joinpath(logdir, "sumstats.csv"),
        DataFrame(
            Parameter=param_names,
            Mean=param_mean,
            StdDev=param_sd,
            ESS=param_ess,
            Rhat=param_rhat,
            ESSpersec=param_esspersec,
        )
    )
end
