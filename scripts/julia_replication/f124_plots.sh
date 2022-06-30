# instantiate project
echo "***** Instantiating Project *****"
julia --project -e "using Pkg; Pkg.instantiate()"

# execute estimation scripts: 10 runs of 5000 samples each
do for seed in `seq 10`
    do echo "EXECUTING fit_rbc_1_kalman.jl WITH seed $seed"
    ~/julia-1.7.1/bin/julia --project --sysimage JuliaSysimage.so --threads auto -O1 bin/fit_rbc_1_kalman.jl --results_path ./.results/f124_rbc_1_kalman_${seed} --overwrite_results true --num_samples 5000 --seed $seed --init_params_file data/rbc_1_kalman_burnin_dynare &
done
wait

do for seed in `seq 10`
    do echo "EXECUTING fit_rbc_1_joint.jl WITH seed $seed"
    ~/julia-1.7.1/bin/julia --project --sysimage JuliaSysimage.so --threads auto -O1 bin/fit_rbc_1_joint.jl --results_path ./.results/f124_rbc_1_joint_${seed} --overwrite_results true --num_samples 5000 --seed $seed --init_params_file data/rbc_1_joint_burnin_ergodic &
done
wait

do for seed in `seq 10`
    do echo "EXECUTING fit_rbc_2_joint.jl WITH seed $seed"
    ~/julia-1.7.1/bin/julia --project --sysimage JuliaSysimage.so --threads auto -O1 bin/fit_rbc_2_joint.jl --results_path ./.results/f124_rbc_2_joint_${seed} --overwrite_results true --num_samples 5000 --seed $seed --init_params_file data/rbc_2_joint_burnin_ergodic &
done
wait

echo "FINISHED"
sudo shutdown -h now
