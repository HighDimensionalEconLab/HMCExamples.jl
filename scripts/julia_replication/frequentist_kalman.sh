# instantiate project
echo "***** Instantiating Project *****"
julia --project -e "using Pkg; Pkg.instantiate()"

# execute estimation scripts
do for i in `seq 10`
    do for j in `seq 10`
        do echo "EXECUTING fit_rbc_1_kalman.jl WITH seed $((10 * (i - 1) + j)) T = 50"
        ~/julia-1.7.1/bin/julia --project --sysimage JuliaSysimage.so --threads auto -O1 bin/fit_rbc_1_kalman.jl --results_path ./.results/frequentist_rbc_1_kalman_$((10 * (i - 1) + j)) --overwrite_results true --num_samples 5000 --seed $((10 * (i - 1) + j)) --data_path .data/rbc_1_$((10 * (i - 1) + j))_50.csv --init_params_file data/rbc_1_kalman_burnin_dynare &
    done
    wait
done

do for i in `seq 10`
    do for j in `seq 10`
        do echo "EXECUTING fit_rbc_1_kalman.jl WITH seed $((10 * (i - 1) + j)) T = 100"
        # generate observables here
        ~/julia-1.7.1/bin/julia --project --sysimage JuliaSysimage.so --threads auto -O1 bin/fit_rbc_1_kalman.jl --results_path ./.results/frequentist_rbc_1_kalman_$((10 * (i - 1) + j)) --overwrite_results true --num_samples 5000 --seed $((10 * (i - 1) + j)) --data_path .data/rbc_1_$((10 * (i - 1) + j))_100.csv --init_params_file data/rbc_1_kalman_burnin_dynare &
    done
    wait
done

do for i in `seq 10`
    do for j in `seq 10`
        do echo "EXECUTING fit_rbc_1_kalman.jl WITH seed $((10 * (i - 1) + j)) T = 200"
        # generate observables here
        ~/julia-1.7.1/bin/julia --project --sysimage JuliaSysimage.so --threads auto -O1 bin/fit_rbc_1_kalman.jl --results_path ./.results/frequentist_rbc_1_kalman_$((10 * (i - 1) + j)) --overwrite_results true --num_samples 5000 --seed $((10 * (i - 1) + j)) --data_path .data/rbc_1_$((10 * (i - 1) + j))_200.csv --init_params_file data/rbc_1_kalman_burnin_dynare &
    done
    wait
done

echo "FINISHED"
sudo shutdown -h now