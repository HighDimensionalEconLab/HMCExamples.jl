using FVGQ20Estimation, DifferentiableStateSpaceModels, Serialization, StatsPlots
using DelimitedFiles
using LinearAlgebra


#TODO!!!!!!!!!!!!!!!!!!!!!!!! USE THE LOGGING DIRECTORIES INSTEAD.
# GET RID OF THE NAME STUFF.

function save_experiment_results(name, chain, directory_path=joinpath(pkgdir(FVGQ20Estimation), "figures/results"))
    #  uses the `name` as a prefix for all output.  So lets say we
    # for example, lest save we have a chainsummary thing, then it would write to
    # "joinpath(directory_path, "$(name)_chainsummary.csv"  or whatever.
    serialize(joinpath(pkgdir(FVGQ20Estimation), "figures/results/$name.jls"), chain)
end

function calculate_experiment_results(name, include_vars, directory_path=joinpath(pkgdir(FVGQ20Estimation), "figures/results"))
    chain = deserialize(joinpath(directory_path, "$name.jls"))
    # display("$prop% of chain with numerical error")
    # display(summarize(chain[include_vars]))

    # trace plots
    # include_vars = ["α", "β", "ρ", "δ"]
    trace_plot = plot(chain[include_vars], seriestype=:traceplot)
    savefig(trace_plot, joinpath(pkgdir(FVGQ20Estimation), "figures/results/traceplots_$name.png"))

    # density
    density_plot = density(chain[include_vars])
    savefig(density_plot, joinpath(pkgdir(FVGQ20Estimation), "figures/results/densityplots_$name.png"))

    # Likelihood
    likelihood_plot = plot(chain[:lp])
    savefig(likelihood_plot, joinpath(pkgdir(FVGQ20Estimation), "figures/results/likelihoodplots_$name.png"))

    # Numerical errors
    if :numerical_error in keys(chain)
        num_error = get(chain, :numerical_error)
        prop = 100 * sum(num_error.numerical_error.data) / length(num_error.numerical_error.data)
        numerror_plot = plot(chain[:numerical_error])
        savefig(numerror_plot, joinpath(pkgdir(FVGQ20Estimation), "figures/results/numerrorplots_$name.png"))
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
        joinpath(pkgdir(FVGQ20Estimation), "figures/results/sumstats_$name.csv"),
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
            writedlm("figures/results/preconditioner_$name.csv", m, ',')
        end
    end

    # cumulative averages
    for var in include_vars
        values = chain[var]
        cum_average = MCMCChains.cummean(values)
        writedlm(
            joinpath(pkgdir(FVGQ20Estimation), "figures/results/cumaverage_$(name)_$(var).csv"),
            cum_average,
            ','
        )
    end

    # Cumulative mean plots
    cummean_plot = meanplot(chain[include_vars])
    savefig(cummean_plot, joinpath(pkgdir(FVGQ20Estimation), "figures/results/cummean_$name.png"))
end