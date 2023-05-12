using CSV, DataFrames, DelimitedFiles, JSON, MCMCChains, Serialization

function convert_dynare_output(logdir, vars; save_jls = false, save_last_draw = false)
    @info "Converting $logdir to julia output"
    x2 = readdlm(joinpath(logdir, "x2.csv"), ',')
    logpo2 = readdlm(joinpath(logdir, "logpo2.csv"), ',')
    runtime = readdlm(joinpath(logdir, "rt.csv"), ',')[1]
    chain = Chains(x2, vars; evidence = logpo2)
    if save_jls
        serialize(joinpath(logdir, "chain.jls"), chain) # Basic Julia serialization.  Not portable beetween versions/machines
    end

    if save_last_draw
        last_draw = chain.value[end, :, 1][chain.name_map.parameters] |> Array
        writedlm(joinpath(logdir, "last_draw.csv"), last_draw, ',')
    end

    # Generate the sumstats
    sum_stats = describe(chain[vars])
    param_names = sum_stats[1][:, 1]
    param_mean = sum_stats[1][:, 2]
    param_sd = sum_stats[1][:, 3]
    param_ess = sum_stats[1][:, 6]
    param_rhat = sum_stats[1][:, 7]
    param_esspersec = param_ess / runtime
    Num_error = zero(param_mean) # not meaningful, but makes the csv consistent

    # Saves the sumstats consistent with julia results
    CSV.write(
        joinpath(logdir, "sumstats.csv"),
        DataFrame(
            Parameter=param_names,
            Mean=param_mean,
            StdDev=param_sd,
            ESS=param_ess,
            Rhat=param_rhat,
            ESSpersec=param_esspersec,
            Num_error=Num_error
        )
    )    
    return nothing
end

results_path = ".replication_results"
rbc_vars = ["α", "β_draw", "ρ"]
sgu_vars = ["α", "γ", "ψ", "β_draw", "ρ", "ρ_u", "ρ_v"]


# Convert over the main ones
save_jls = true
save_last_draw = false
convert_dynare_output(joinpath(results_path, "rbc_1_200_dynare"), rbc_vars; save_jls, save_last_draw)
convert_dynare_output(joinpath(results_path, "rbc_2_200_dynare"), rbc_vars; save_jls, save_last_draw)
convert_dynare_output(joinpath(results_path, "sgu_1_200_dynare"), sgu_vars; save_jls, save_last_draw)
convert_dynare_output(joinpath(results_path, "sgu_2_200_dynare"), sgu_vars; save_jls, save_last_draw)

# Loop over all of the dynare robustness results
subdirectories = filter(isdir, readdir(joinpath(results_path, "dynare_robustness"), join=true))
save_jls = true # do we need this for robustness plots?
for subdir in subdirectories
    convert_dynare_output(subdir, rbc_vars; save_jls)
end
