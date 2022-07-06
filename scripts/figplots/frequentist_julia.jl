using HDF5, MCMCChains, MCMCChainsStorage, CSV, DataFrames, Statistics

function calculate_num_error_prop(chain)
    num_error = get(chain, :numerical_error)
    return 100 * sum(num_error.numerical_error.data) / length(num_error.numerical_error.data)
end

function generate_frequentist_diagnostics(batch, param_sim, include_vars, num_simulations, data_length)
    drop_errors = true

    num_skipped = 0
    num_vars = length(include_vars) #Number of variables included
    param_names=Array{Symbol,1}(undef,num_vars)
    valid_chains = []
    for i in 1:num_simulations
        println("simulation ", i, " of batch ", batch, " length ", data_length)
        chain = h5open(".experiments/frequentist_julia/$batch/frequentist_rbc_$(batch)_$(i)_$data_length/chain.h5", "r") do f
            read(f, Chains)
        end
        println(calculate_num_error_prop(chain))
        if calculate_num_error_prop(chain) > 0.0 && drop_errors == true
            println("SKIPPING, errored")
            num_skipped += 1
        else
            push!(valid_chains, chain)
        end
    end

    post_stats = zeros(num_simulations - num_skipped, 7, num_vars) #mean, sd, p5, p10, p50, p90, p95
    for (i, chain) in enumerate(valid_chains)
        sum_stats = describe(chain[include_vars])
        param_names[:] = sum_stats[1][:,1]
        post_stats[i, 1, :] = sum_stats[1][:,2]
        post_stats[i, 2, :] = sum_stats[1][:,3]
        values = chain[include_vars].value
        for j in 1:num_vars
            post_stats[i, 3:end, j] = quantile(values[:,j], [0.05, 0.1, 0.5, 0.9, 0.95])
        end
    end
    bias_param=zeros(num_vars)
    mse_param=zeros(num_vars)
    cov80_param=zeros(num_vars) #coverage of the 80% interval
    cov90_param=zeros(num_vars) #coverage of the 90% interval
    for j in 1:num_vars
        bias_param[j] = mean(post_stats[:,1,j] .- param_sim[param_names[j]])
        mse_param[j] = mean((post_stats[:,1,j] .- param_sim[param_names[j]]).^2)
        cov80_param[j] = mean((post_stats[:, 4, j] .<= param_sim[param_names[j]]).*(post_stats[:, 6, j] .>= param_sim[param_names[j]]))
        cov90_param[j] = mean((post_stats[:, 3, j] .<= param_sim[param_names[j]]).*(post_stats[:, 7, j] .>= param_sim[param_names[j]]))
    end
    if drop_errors
        pathname = ".results/freqstats_rbc_$(batch)_$(data_length)_drop57.csv"
    else
        pathname = ".results/freqstats_rbc_$(batch)_$(data_length).csv"
    end
    CSV.write(pathname, DataFrame(Parameter=param_names, Bias = bias_param, MSE = mse_param, Interval_80 = cov80_param, Interval_90 = cov90_param))
    return num_skipped
end 

function runall()
    mapping = Dict(:α => 0.3, :β_draw => 0.2, :ρ => 0.9)
    total_skipped = 0
    for T in ["50", "100", "200"]
        s1 = generate_frequentist_diagnostics("1_kalman", mapping, ["α", "β_draw", "ρ"], 100, T)
        s2 = generate_frequentist_diagnostics("1_joint", mapping, ["α", "β_draw", "ρ"], 100, T)
        s3 = generate_frequentist_diagnostics("2_joint", mapping, ["α", "β_draw", "ρ"], 50, T)
        println(s1, " ", s2, " ", s3, " T = ", T)
        total_skipped += s1 + s2 + s3
    end
    println("total ", total_skipped, " dropped entries")
end

runall()