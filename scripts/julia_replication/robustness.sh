for alpha in 0.25 0.3 0.35 0.4 0.45
    do for beta_draw in 0.1 0.175 0.25 0.325 0.4
        do for rho in 0.3 0.4625 0.625 0.7875 0.95
            do echo "EXECUTING KALMAN WITH alpha $alpha beta_draw $beta_draw rho $rho"
            ~/julia-1.7.1/bin/julia --project --sysimage JuliaSysimage.so --threads auto -O1 bin/fit_rbc_1_kalman.jl --results_path ./.results/robustness_rbc_1_kalman_${alpha//./_}${beta_draw//./_}${rho//./_} --overwrite_results true --num_samples 4000 --alpha $alpha --beta $beta_draw --rho $rho --init_params_file data/rbc_1_kalman_burnin_dynare.csv
            echo "1 JOINT"
            ~/julia-1.7.1/bin/julia --project --sysimage JuliaSysimage.so --threads auto -O1 bin/fit_rbc_1_joint.jl --results_path ./.results/robustness_rbc_1_joint_${alpha//./_}${beta_draw//./_}${rho//./_} --overwrite_results true --num_samples 1000 --alpha $alpha --beta $beta_draw --rho $rho --init_params_file data/rbc_1_joint_burnin_ergodic.csv
            echo "2 JOINT"
            ~/julia-1.7.1/bin/julia --project --sysimage JuliaSysimage.so --threads auto -O1 bin/fit_rbc_2_joint.jl --results_path ./.results/robustness_rbc_2_joint_${alpha//./_}${beta_draw//./_}${rho//./_} --overwrite_results true --num_samples 2500 --alpha $alpha --beta $beta_draw --rho $rho --init_params_file data/rbc_2_joint_burnin_ergodic.csv
            echo "DONE"
        done
    done
done
echo "FINISHED"
sudo shutdown -h now
