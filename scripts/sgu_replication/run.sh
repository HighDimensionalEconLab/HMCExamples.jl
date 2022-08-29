echo "**PRECOMPILING**"
julia --project -e "using Pkg; Pkg.instantiate()"
#julia --threads auto -e 'using Pkg; Pkg.add("PackageCompiler")'
#julia --project --threads auto -O1 ./deps/create_sysimage.jl

echo "**RUNNING SCRIPT**"

julia --project --threads auto -O1 bin/fit_sgu_1_kalman.jl --results_path ./.results/sgu_1_kalman_small_noise --overwrite_results true --data_path data/sgu_1_draw_low.csv --Omega_1 0.00316 --num_samples 5000 --seed 0 --init_params_file data/sgu_1_kalman_burnin.csv

julia --project --threads auto -O1 bin/fit_sgu_1_joint.jl --results_path ./.results/sgu_1_joint_high_noise --overwrite_results true --data_path data/sgu_1_fixed_high.csv --Omega_1 0.0316 --num_samples 5000 --seed 0 --init_params_file data/sgu_1_joint_burnin.csv

julia --project --threads auto -O1 bin/fit_sgu_2_joint.jl --results_path ./.results/sgu_2_joint_high_noise --overwrite_results true --data_path data/sgu_2_fixed_high.csv --Omega_1 0.0316 --num_samples 5000 --seed 0 --init_params_file data/sgu_2_joint_burnin.csv

echo "**FINISHED**"
sudo shutdown -h now
