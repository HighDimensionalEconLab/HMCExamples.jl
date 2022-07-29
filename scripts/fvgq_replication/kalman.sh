echo "**RUNNING SCRIPT**"
julia --project -e "using Pkg; Pkg.instantiate()"
julia --project --threads auto -O1 bin/fit_FVGQ_1_kalman.jl --results_path ./.results/FVGQ_1_kalman --overwrite_results true --num_samples 7000 --sampling_heartbeat 100 --seed 0 --init_params_file data/FVGQ_1_kalman_burnin_ergodic.csv

echo "**FINISHED**"
sudo shutdown -h now
