#!/bin/bash

# Run at the top level HMCExamples directory, not within the `/scripts` or `/scripts/run_samplers` directories
source ./scripts/utilities.sh # includes print_header, run_sampler, etc.

# General variables for arguments and paths used in the run_sampler utility function defined in utilities.sh
RESULTS_PATH=".replication_results"
DATA_PATH="data"
INIT_PARAMS_PATH="data/init_params"
BASELINE_SEED="1"

# length of samples in the RBC cases roughly chosen to align runtime with Dynare code
RBC_1_KALMAN_SAMPLES="6500"
RBC_1_JOINT_SAMPLES="4000"
RBC_2_JOINT_SAMPLES="4000"
RBC_2_JOINT_SAMPLES_LONG="10000"

RBC_MULTIPLE_CHAINS_SAMPLES="5000" # baseline
RBC_MULTIPLE_CHAINS="10" # number of chains for density plots, etc.

SGU_SAMPLES="5000"

RBC_SV_2_JOINT_SAMPLES="50000"
RBC_SV_2_JOINT_CHAINS="4"

start_time=$(date +%s)

# # RBC examples
run_sampler $BASELINE_SEED $RBC_1_KALMAN_SAMPLES "fit_rbc_1_kalman.jl" "${RESULTS_PATH}/rbc_1_kalman_200" "${DATA_PATH}/rbc_1_200.csv" "${INIT_PARAMS_PATH}/rbc_1_kalman_init_params_200.csv"
run_sampler $BASELINE_SEED $RBC_1_JOINT_SAMPLES "fit_rbc_1_joint.jl" "${RESULTS_PATH}/rbc_1_joint_200" "${DATA_PATH}/rbc_1_200.csv" "${INIT_PARAMS_PATH}/rbc_1_joint_init_params_200.csv"
run_sampler $BASELINE_SEED $RBC_2_JOINT_SAMPLES "fit_rbc_2_joint.jl" "${RESULTS_PATH}/rbc_2_joint_200" "${DATA_PATH}/rbc_2_200.csv" "${INIT_PARAMS_PATH}/rbc_2_joint_init_params_200.csv"
run_sampler $BASELINE_SEED $RBC_2_JOINT_SAMPLES_LONG "fit_rbc_2_joint.jl" "${RESULTS_PATH}/rbc_2_joint_200_long" "${DATA_PATH}/rbc_2_200.csv" "${INIT_PARAMS_PATH}/rbc_2_joint_init_params_200.csv"

# RBC with bigger T
run_sampler $BASELINE_SEED $RBC_1_KALMAN_SAMPLES "fit_rbc_1_kalman.jl" "${RESULTS_PATH}/rbc_1_kalman_500" "${DATA_PATH}/rbc_1_500.csv" "${INIT_PARAMS_PATH}/rbc_1_kalman_init_params_500.csv"
run_sampler $BASELINE_SEED $RBC_1_JOINT_SAMPLES "fit_rbc_1_joint.jl" "${RESULTS_PATH}/rbc_1_joint_500" "${DATA_PATH}/rbc_1_500.csv" "${INIT_PARAMS_PATH}/rbc_1_joint_init_params_500.csv"
run_sampler $BASELINE_SEED $RBC_2_JOINT_SAMPLES "fit_rbc_2_joint.jl" "${RESULTS_PATH}/rbc_2_joint_500" "${DATA_PATH}/rbc_2_500.csv" "${INIT_PARAMS_PATH}/rbc_2_joint_init_params_500.csv"
run_sampler $BASELINE_SEED $RBC_2_JOINT_SAMPLES_LONG "fit_rbc_2_joint.jl" "${RESULTS_PATH}/rbc_2_joint_500_long" "${DATA_PATH}/rbc_2_500.csv" "${INIT_PARAMS_PATH}/rbc_2_joint_init_params_500.csv"


# # RBC with Multiple Chains for the density plots
run_sampler $BASELINE_SEED $RBC_MULTIPLE_CHAINS_SAMPLES "fit_rbc_1_kalman.jl" "${RESULTS_PATH}/rbc_1_kalman_200_chains" "${DATA_PATH}/rbc_1_200.csv" "${INIT_PARAMS_PATH}/rbc_1_kalman_init_params_200.csv" $RBC_MULTIPLE_CHAINS
run_sampler $BASELINE_SEED $RBC_MULTIPLE_CHAINS_SAMPLES "fit_rbc_1_joint.jl" "${RESULTS_PATH}/rbc_1_joint_200_chains" "${DATA_PATH}/rbc_1_200.csv" "${INIT_PARAMS_PATH}/rbc_1_joint_init_params_200.csv" $RBC_MULTIPLE_CHAINS
run_sampler $BASELINE_SEED $RBC_MULTIPLE_CHAINS_SAMPLES "fit_rbc_2_joint.jl" "${RESULTS_PATH}/rbc_2_joint_200_chains" "${DATA_PATH}/rbc_2_200.csv" "${INIT_PARAMS_PATH}/rbc_2_joint_init_params_200.csv" $RBC_MULTIPLE_CHAINS

# SGU examples
run_sampler $BASELINE_SEED $SGU_SAMPLES "fit_sgu_1_kalman.jl" "${RESULTS_PATH}/sgu_1_kalman_200" "${DATA_PATH}/sgu_1_200.csv" "${INIT_PARAMS_PATH}/sgu_1_kalman_init_params_200.csv"
run_sampler $BASELINE_SEED $SGU_SAMPLES "fit_sgu_1_joint.jl" "${RESULTS_PATH}/sgu_1_joint_200" "${DATA_PATH}/sgu_1_200.csv" "${INIT_PARAMS_PATH}/sgu_1_joint_init_params_200.csv"
run_sampler $BASELINE_SEED $SGU_SAMPLES "fit_sgu_2_joint.jl" "${RESULTS_PATH}/sgu_2_joint_200" "${DATA_PATH}/sgu_2_200.csv" "${INIT_PARAMS_PATH}/sgu_2_joint_init_params_200.csv"

# # RBC Stochastic Volatility examples
run_sampler $BASELINE_SEED $RBC_SV_2_JOINT_SAMPLES "fit_rbc_sv_2_joint.jl" "${RESULTS_PATH}/rbc_sv_2_joint_200" "${DATA_PATH}/rbc_sv_2_200.csv" "${INIT_PARAMS_PATH}/rbc_sv_2_joint_init_params_200.csv" $RBC_SV_2_JOINT_CHAINS

# display elapsed time
end_time=$(date +%s)
elapsed=$(( end_time - start_time ))
eval "echo Elapsed time: $(date -ud "@$elapsed" +'$((%s/3600/24)) days %H hr %M min %S sec')"