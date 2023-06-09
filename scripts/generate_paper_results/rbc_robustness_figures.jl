using StatsPlots
using MCMCChains, Serialization
using Dates
using JSON
using Statistics
using DataFrames
using Measures
using CSV
using LaTeXStrings

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
print("Executing RBC robustness figures\n")
rbc_file_indices = Dict("α" => 1, "β_draw"=> 2, "ρ"=> 3 )
rbc_pseudotrue = Dict("α" => 0.3, "β_draw"=> 0.2004008, "ρ"=> 0.9)
main_path = ".replication_results/robustness"
dynare_main_path = ".replication_results/dynare_robustness"
show_pseudotrue = true
xrange_1 = (0, 3)
xrange_2 = (0, 8) # second order should be longer

# Load up the alpha plots
yrange=(0.28, 0.32)
yrange_2=(0.28, 0.32)
var = "α"
file_index = rbc_file_indices[var]
pseudotrue = rbc_pseudotrue[var]
xlabel = "" # "Compute time (min)" # add to have on every graph

rbc_1_kalman_plot_α = add_trajectories(main_path, "rbc_1_kalman_robustness_", rbc_file_indices[var]; pseudotrue, show_pseudotrue, xrange = xrange_1, label=false, legend=false, alpha=0.5, xlabel, ylabel="", t_range = xrange_1, left_margin = 15mm, yrange)
rbc_1_joint_plot_α = add_trajectories(main_path, "rbc_1_joint_robustness_", file_index; pseudotrue, show_pseudotrue, xrange = xrange_1, label=false, legend=false, alpha=0.5, xlabel, ylabel="", t_range = xrange_1, left_margin = 15mm, yrange)
rbc_1_dynare_plot_α = add_trajectories(dynare_main_path, "rbc_1_robustness_", rbc_file_indices[var]; pseudotrue, show_pseudotrue, xrange = xrange_1, label=false, legend=false, alpha=0.5, xlabel, ylabel="", t_range = xrange_1, left_margin = 15mm, yrange)

rbc_2_joint_plot_α = add_trajectories(main_path, "rbc_2_joint_robustness_", file_index; pseudotrue, show_pseudotrue, xrange = xrange_2, label=false, legend=false, alpha=0.5, xlabel, ylabel="", t_range = xrange_2, left_margin = 15mm, yrange = yrange_2)
rbc_2_dynare_plot_α = add_trajectories(dynare_main_path, "rbc_2_robustness_", rbc_file_indices[var]; pseudotrue, show_pseudotrue, xrange = xrange_2, label=false, legend=false, alpha=0.5, xlabel, ylabel="", t_range = xrange_2, left_margin = 15mm, yrange = yrange_2)


# Load up the beta plots
yrange=(0.1, 0.4)
yrange_2=(0.1, 0.4)
var = "β_draw"
file_index = rbc_file_indices[var]
pseudotrue = rbc_pseudotrue[var]
rbc_1_kalman_plot_β = add_trajectories(main_path, "rbc_1_kalman_robustness_", file_index; pseudotrue, show_pseudotrue, xrange = xrange_1, label=false, legend=false, alpha=0.5, xlabel, ylabel="", t_range = xrange_1, left_margin = 15mm, yrange)
rbc_1_joint_plot_β = add_trajectories(main_path, "rbc_1_joint_robustness_", file_index; pseudotrue, show_pseudotrue, xrange = xrange_1, label=false, legend=false, alpha=0.5, xlabel, ylabel="", t_range = xrange_1, left_margin = 15mm, yrange)
rbc_1_dynare_plot_β  = add_trajectories(dynare_main_path, "rbc_1_robustness_", rbc_file_indices[var]; pseudotrue, show_pseudotrue, xrange = xrange_1, label=false, legend=false, alpha=0.5, xlabel, ylabel="", t_range = xrange_1, left_margin = 15mm, yrange)

rbc_2_joint_plot_β = add_trajectories(main_path, "rbc_2_joint_robustness_", file_index; pseudotrue, show_pseudotrue, xrange = xrange_2, label=false, legend=false, alpha=0.5, xlabel, ylabel="", t_range = xrange_2, left_margin = 15mm, yrange = yrange_2)
rbc_2_dynare_plot_β  = add_trajectories(dynare_main_path, "rbc_2_robustness_", rbc_file_indices[var]; pseudotrue, show_pseudotrue, xrange = xrange_2, label=false, legend=false, alpha=0.5, xlabel, ylabel="", t_range = xrange_2, left_margin = 15mm, yrange = yrange_2)

# Load up the rho plots
yrange=(0.87, 0.93)
yrange_2=(0.82, 0.98)
var = "ρ"
file_index = rbc_file_indices[var]
pseudotrue = rbc_pseudotrue[var]
rbc_1_kalman_plot_ρ = add_trajectories(main_path, "rbc_1_kalman_robustness_", file_index; pseudotrue, show_pseudotrue, xrange = xrange_1, label=false, legend=false, alpha=0.5, xlabel, ylabel="", t_range = xrange_1, left_margin = 15mm, yrange)
rbc_1_joint_plot_ρ = add_trajectories(main_path, "rbc_1_joint_robustness_", file_index; pseudotrue, show_pseudotrue, xrange = xrange_1, label=false, legend=false, alpha=0.5, xlabel, ylabel="", t_range = xrange_1, left_margin = 15mm, yrange)
rbc_1_dynare_plot_ρ  = add_trajectories(dynare_main_path, "rbc_1_robustness_", rbc_file_indices[var]; pseudotrue, show_pseudotrue, xrange = xrange_1, label=false, legend=false, alpha=0.5, xlabel, ylabel="", t_range = xrange_1, left_margin = 15mm, yrange)

rbc_2_joint_plot_ρ = add_trajectories(main_path, "rbc_2_joint_robustness_", file_index; pseudotrue, show_pseudotrue, xrange = xrange_2, label=false, legend=false, alpha=0.5, xlabel, ylabel="", t_range = xrange_2, left_margin = 15mm, yrange=yrange_2)
rbc_2_dynare_plot_ρ  = add_trajectories(dynare_main_path, "rbc_2_robustness_", rbc_file_indices[var]; pseudotrue, show_pseudotrue, xrange = xrange_2, label=false, legend=false, alpha=0.5, xlabel, ylabel="", t_range = xrange_2, left_margin = 15mm, yrange=yrange_2)


# Combine into plots and save
# Add labels/titles before combining into figures
kalman_1_title = "NUTS, Marginal"
joint_1_title = "NUTS, Joint"
joint_2_title = "NUTS, Joint"
dynare_1_title = "RWMH, Marginal"
dynare_2_title = "RWMH, Particle Filter"
xlabel_time = "Compute time (min)"

ylabel!(rbc_1_kalman_plot_α, L"\alpha")
ylabel!(rbc_1_kalman_plot_β, L"\beta_{draw}")
ylabel!(rbc_1_kalman_plot_ρ, L"\rho")
title!(rbc_1_kalman_plot_α, kalman_1_title)
title!(rbc_1_joint_plot_α, joint_1_title)
title!(rbc_1_dynare_plot_α, dynare_1_title)
xlabel!(rbc_1_kalman_plot_ρ, xlabel_time)
xlabel!(rbc_1_joint_plot_ρ, xlabel_time)
xlabel!(rbc_1_dynare_plot_ρ, xlabel_time)
# very slow plot building, probably just due to the quantity of data.  Downgrading to png directly might help
plt = plot(rbc_1_kalman_plot_α, rbc_1_joint_plot_α, rbc_1_dynare_plot_α,
            rbc_1_kalman_plot_β, rbc_1_joint_plot_β, rbc_1_dynare_plot_β,
            rbc_1_kalman_plot_ρ, rbc_1_joint_plot_ρ, rbc_1_dynare_plot_ρ; layout=(3,3), size=(900, 900))
savefig(plt, ".paper_results/rbc_1_robustness_cumaverage.png")


# Second order
ylabel!(rbc_2_joint_plot_α,  L"\alpha")
ylabel!(rbc_2_joint_plot_β, L"\beta_{draw}")
ylabel!(rbc_2_joint_plot_ρ, L"\rho")
title!(rbc_2_joint_plot_α, joint_2_title)
title!(rbc_2_dynare_plot_α, dynare_2_title)
xlabel!(rbc_2_joint_plot_ρ, xlabel_time)
xlabel!(rbc_2_dynare_plot_ρ, xlabel_time)
plt = plot(rbc_2_joint_plot_α, rbc_2_dynare_plot_α,
            rbc_2_joint_plot_β, rbc_2_dynare_plot_β,
            rbc_2_joint_plot_ρ, rbc_2_dynare_plot_ρ; layout=(3,2), size=(750, 900))
savefig(plt, ".paper_results/rbc_2_robustness_cumaverage.png")