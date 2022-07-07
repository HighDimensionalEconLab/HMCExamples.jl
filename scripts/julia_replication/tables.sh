# Table 2: NUTS with Marginal Likelihood, RBC Model, First-order
# sampling time excludes compilation time
# length of samples chosen to align runtime with Dynare code

echo "***** Executing Table 2 *****"
~/julia-1.7.1/bin/julia --project --sysimage JuliaSysimage.so --threads auto -O1 bin/fit_rbc_1_kalman.jl --results_path ./.results/rbc_1_kalman_timed --overwrite_results true --num_samples 6500 --seed 1 --init_params_file data/rbc_1_kalman_burnin_dynare.csv

# Table 3: NUTS with Joint Likelihood, RBC Model, First-order
# sampling time excludes compilation time
echo "***** Executing Table 3 *****"
~/julia-1.7.1/bin/julia --project --sysimage JuliaSysimage.so --threads auto -O1 bin/fit_rbc_1_joint.jl --results_path ./.results/rbc_1_joint_timed --overwrite_results true --num_samples 4000 --seed 1 --init_params_file data/rbc_1_joint_burnin_ergodic.csv

# Table 6: NUTS with Joint Likelihood, RBC Model, Second-order
# sampling time excludes compilation time
# length of samples chosen to align runtime with Dynare code
echo "***** Executing Table 6 *****"
~/julia-1.7.1/bin/julia --project --sysimage JuliaSysimage.so --threads auto -O1 bin/fit_rbc_2_joint.jl --results_path ./.results/rbc_2_joint_timed --overwrite_results true --num_samples 4000 --seed 1 --init_params_file data/rbc_2_joint_burnin_ergodic.csv

echo "***** Executing Figure 3 *****"
~/julia-1.7.1/bin/julia --project --sysimage JuliaSysimage.so --threads auto -O1 bin/fit_rbc_2_joint.jl --results_path ./.results/rbc_2_joint_timed_10000 --overwrite_results true --num_samples 10000 --seed 1 --init_params_file data/rbc_2_joint_burnin_ergodic.csv

echo "DONE"
sudo shutdown -h now
