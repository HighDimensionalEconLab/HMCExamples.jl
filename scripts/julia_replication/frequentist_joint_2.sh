# instantiate project
echo "***** Instantiating Data *****"
mkdir .data
~/julia-1.7.1/bin/julia --project --sysimage JuliaSysimage.so scripts/julia_replication/generate_fake_data_ergodic_frequentist.jl

# execute estimation scripts
for i in `seq 5`
    do for j in `seq 10`
        do echo "EXECUTING fit_rbc_2_joint.jl WITH seed $((10 * (i - 1) + j)) T = 50"
        ~/julia-1.7.1/bin/julia --project --sysimage JuliaSysimage.so --threads auto -O1 bin/fit_rbc_2_joint.jl --results_path ./.results/frequentist_rbc_2_joint_$((10 * (i - 1) + j))_50 --overwrite_results true --num_samples 5000 --seed $((10 * (i - 1) + j)) --data_path .data/rbc_2_$((10 * (i - 1) + j))_50.csv --init_params_file data/rbc_2_joint_burnin_ergodic_50.csv &
    done
    wait
done

for i in `seq 5`
    do for j in `seq 10`
        do echo "EXECUTING fit_rbc_2_joint.jl WITH seed $((10 * (i - 1) + j)) T = 100"
        ~/julia-1.7.1/bin/julia --project --sysimage JuliaSysimage.so --threads auto -O1 bin/fit_rbc_2_joint.jl --results_path ./.results/frequentist_rbc_2_joint_$((10 * (i - 1) + j))_100 --overwrite_results true --num_samples 5000 --seed $((10 * (i - 1) + j)) --data_path .data/rbc_2_$((10 * (i - 1) + j))_100.csv --init_params_file data/rbc_2_joint_burnin_ergodic_100.csv &
    done
    wait
done

for i in `seq 5`
    do for j in `seq 10`
        do echo "EXECUTING fit_rbc_2_joint.jl WITH seed $((10 * (i - 1) + j)) T = 200"
        ~/julia-1.7.1/bin/julia --project --sysimage JuliaSysimage.so --threads auto -O1 bin/fit_rbc_2_joint.jl --results_path ./.results/frequentist_rbc_2_joint_$((10 * (i - 1) + j))_200 --overwrite_results true --num_samples 5000 --seed $((10 * (i - 1) + j)) --data_path .data/rbc_2_$((10 * (i - 1) + j))_200.csv --init_params_file data/rbc_2_joint_burnin_ergodic.csv &
    done
    wait
done

echo "FINISHED"
sudo shutdown -h now
