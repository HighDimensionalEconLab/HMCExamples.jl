# This file calculates the frequentist diagnostics for the RBC model from a number of seeds
using MCMCChains, Serialization, CSV, DataFrames, Statistics, HMCExamples, JSON

function calculate_num_error_prop(chain)
    num_error = get(chain, :numerical_error)
    return 100 * sum(num_error.numerical_error.data) / length(num_error.numerical_error.data)
end

function generate_frequentist_diagnostics(batch, param_sim, include_vars, num_simulations, data_length)
    num_skipped = 0
    num_vars = length(include_vars) #Number of variables included
    param_names=Array{Symbol,1}(undef,num_vars)
    valid_chains = []
    for i in 1:num_simulations
        chain = deserialize(".replication_results/frequentist/$(batch)_frequentist_seed_$(i)_$(data_length)/chain.jls")
        if calculate_num_error_prop(chain) > 0.0
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


    #Load the results file to see the number of samples, etc.
    result_file = JSON.parsefile(".replication_results/frequentist/$(batch)_frequentist_seed_1_$(data_length)/result.json")

    pathname = ".replication_results/frequentist/freqstats_$(batch)_$(data_length).csv"
    CSV.write(pathname, DataFrame(Parameter=param_names, Bias = bias_param, MSE = mse_param, Interval_80 = cov80_param, Interval_90 = cov90_param,
    runs_dropped = num_skipped,
    num_seeds = num_simulations,
    num_samples = result_file["num_samples"],
    adapts_burnin_prop = result_file["adapts_burnin_prop"],))
end 

# Calculate for every T and experiment type
pseudotrues = Dict(:α => 0.3, :β_draw => 0.2004008, :ρ => 0.9)
num_seeds = 100
include_vars = ["α", "β_draw", "ρ"]
generate_frequentist_diagnostics("rbc_1_kalman", pseudotrues, include_vars, num_seeds, "50")
generate_frequentist_diagnostics("rbc_1_joint", pseudotrues, include_vars, num_seeds, "50")
generate_frequentist_diagnostics("rbc_2_joint", pseudotrues, include_vars, num_seeds, "50")

generate_frequentist_diagnostics("rbc_1_kalman", pseudotrues, include_vars, num_seeds, "100")
generate_frequentist_diagnostics("rbc_1_joint", pseudotrues, include_vars, num_seeds, "100")
generate_frequentist_diagnostics("rbc_2_joint", pseudotrues, include_vars, num_seeds, "100")

generate_frequentist_diagnostics("rbc_1_kalman", pseudotrues, include_vars, num_seeds, "200")
generate_frequentist_diagnostics("rbc_1_joint", pseudotrues, include_vars, num_seeds, "200")
generate_frequentist_diagnostics("rbc_2_joint", pseudotrues, include_vars, num_seeds, "200")
