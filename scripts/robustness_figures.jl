using StatsPlots
using MCMCChains, Serialization
using Dates
using JSON
using Statistics
using Base.Iterators
using Measures

function add_trajectories(base_path, dir_prefix, cumaverage_index; pseudotrue, show_pseudotrue, t_range, plot_args...)
    plt = plot()
    all_dirs = readdir(base_path)
    dirs = filter(d -> startswith(d, dir_prefix), all_dirs)

    for dir in dirs
        full_dir = joinpath(base_path, dir)
        cumaverage_file = joinpath(full_dir, "cumaverage_$(cumaverage_index).csv")
        result_file = joinpath(full_dir, "result.json")

        # load the CSV file
        sampling_data = CSV.File(cumaverage_file; header=false) |> DataFrame |> Matrix |> vec

        # load the JSON file and get the time_elapsed field
        time_elapsed = open(result_file, "r") do io
            json_text = read(io, String)
            data = JSON.parse(json_text)
            data["time_elapsed"]
        end

        t = range(0.0, time_elapsed; length=length(sampling_data)) / 60 # in minutes
        t_min = t_range[1]
        t_max = t_range[2]

        # find indices where t is between t_min and t_max
        indices = findall(x -> t_min <= x <= t_max, t)

        # select only those elements of t and sampling_data
        t = t[indices]
        sampling_data = sampling_data[indices]

        # plot the data
        plot!(plt, t, sampling_data; plot_args...)

        if show_pseudotrue
            hline!(plt, [pseudotrue], label="pseudotrue", color=:black, linestyle=:dash)
        end
    end

    return plt
end

rbc_file_indices = Dict("α" => 1, "β_draw"=> 2, "ρ"=> 3 )
rbc_pseudotrue = Dict("α" => 0.3, "β_draw"=> 0.2, "ρ"=> 0.9)
main_path = ".replication_results/robustness"
dynare_main_path = ".replication_results/dynare_robustness"
show_pseudotrue = true

# Load up the alpha plots
xrange = (0, 3)
yrange=(0.28, 0.32)
var = "α"
file_index = rbc_file_indices[var]
pseudotrue = rbc_pseudotrue[var]

rbc_1_kalman_plot_α = add_trajectories(path, "rbc_1_kalman_robustness_", rbc_file_indices[var]; pseudotrue, show_pseudotrue, xrange, label=false, legend=false, alpha=0.5, xlabel="Compute time (min)", ylabel=var, t_range = xrange, left_margin = 15mm, yrange)
rbc_1_joint_plot_α = add_trajectories(path, "rbc_1_joint_robustness_", file_index; pseudotrue, show_pseudotrue, xrange, label=false, legend=false, alpha=0.5, xlabel="Compute time (min)", ylabel=var, t_range = xrange, left_margin = 15mm, yrange)
rbc_2_joint_plot_α = add_trajectories(path, "rbc_2_joint_robustness_", file_index; pseudotrue, show_pseudotrue, xrange, label=false, legend=false, alpha=0.5, xlabel="Compute time (min)", ylabel=var, t_range = xrange, left_margin = 15mm, yrange)
rbc_1_dynare_plot_α = add_trajectories(dynare_main_path, "rbc_1_robustness_", rbc_file_indices[var]; pseudotrue, show_pseudotrue, xrange, label=false, legend=false, alpha=0.5, xlabel="Compute time (min)", ylabel=var, t_range = xrange, left_margin = 15mm, yrange)
rbc_2_dynare_plot_α = add_trajectories(dynare_main_path, "rbc_2_robustness_", rbc_file_indices[var]; pseudotrue, show_pseudotrue, xrange, label=false, legend=false, alpha=0.5, xlabel="Compute time (min)", ylabel=var, t_range = xrange, left_margin = 15mm, yrange)


# Load up the beta plots
xrange = (0, 3)
yrange=(0.1, 0.4)
var = "β_draw"
file_index = rbc_file_indices[var]
pseudotrue = rbc_pseudotrue[var]
rbc_1_joint_plot_β = add_trajectories(path, "rbc_1_joint_robustness_", file_index; pseudotrue, show_pseudotrue, xrange, label=false, legend=false, alpha=0.5, xlabel="Compute time (min)", ylabel=var, t_range = xrange, left_margin = 15mm, yrange)
rbc_1_kalman_plot_β = add_trajectories(path, "rbc_1_kalman_robustness_", file_index; pseudotrue, show_pseudotrue, xrange, label=false, legend=false, alpha=0.5, xlabel="Compute time (min)", ylabel=var, t_range = xrange, left_margin = 15mm, yrange)
rbc_2_joint_plot_β = add_trajectories(path, "rbc_2_joint_robustness_", file_index; pseudotrue, show_pseudotrue, xrange, label=false, legend=false, alpha=0.5, xlabel="Compute time (min)", ylabel=var, t_range = xrange, left_margin = 15mm, yrange)
rbc_1_dynare_plot_β  = add_trajectories(dynare_main_path, "rbc_1_robustness_", rbc_file_indices[var]; pseudotrue, show_pseudotrue, xrange, label=false, legend=false, alpha=0.5, xlabel="Compute time (min)", ylabel=var, t_range = xrange, left_margin = 15mm, yrange)
rbc_2_dynare_plot_β  = add_trajectories(dynare_main_path, "rbc_2_robustness_", rbc_file_indices[var]; pseudotrue, show_pseudotrue, xrange, label=false, legend=false, alpha=0.5, xlabel="Compute time (min)", ylabel=var, t_range = xrange, left_margin = 15mm, yrange)

# Load up the rho plots
xrange = (0, 3)
yrange=(0.8, 1.0)
var = "ρ"
file_index = rbc_file_indices[var]
pseudotrue = rbc_pseudotrue[var]
rbc_1_kalman_plot_ρ = add_trajectories(path, "rbc_1_kalman_robustness_", file_index; pseudotrue, show_pseudotrue, xrange, label=false, legend=false, alpha=0.5, xlabel="Compute time (min)", ylabel=var, t_range = xrange, left_margin = 15mm, yrange)
rbc_1_joint_plot_ρ = add_trajectories(path, "rbc_1_joint_robustness_", file_index; pseudotrue, show_pseudotrue, xrange, label=false, legend=false, alpha=0.5, xlabel="Compute time (min)", ylabel=var, t_range = xrange, left_margin = 15mm, yrange)
rbc_2_joint_plot_ρ = add_trajectories(path, "rbc_2_joint_robustness_", file_index; pseudotrue, show_pseudotrue, xrange, label=false, legend=false, alpha=0.5, xlabel="Compute time (min)", ylabel=var, t_range = xrange, left_margin = 15mm, yrange)
rbc_1_dynare_plot_ρ  = add_trajectories(dynare_main_path, "rbc_1_robustness_", rbc_file_indices[var]; pseudotrue, show_pseudotrue, xrange, label=false, legend=false, alpha=0.5, xlabel="Compute time (min)", ylabel=var, t_range = xrange, left_margin = 15mm, yrange)
rbc_2_dynare_plot_ρ  = add_trajectories(dynare_main_path, "rbc_2_robustness_", rbc_file_indices[var]; pseudotrue, show_pseudotrue, xrange, label=false, legend=false, alpha=0.5, xlabel="Compute time (min)", ylabel=var, t_range = xrange, left_margin = 15mm, yrange)



