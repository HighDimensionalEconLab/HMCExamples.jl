#!/bin/bash

# Run at the top level HMCExamples directory, not within the `/scripts` or `/scripts/run_samplers` directories
source ./scripts/utilities.sh # includes print_header, run_sampler, etc.

# General variables for arguments and paths used in the run_sampler utility function defined in utilities.sh
JULIA_ARGS="--sysimage JuliaSysimage.so --threads auto -O1"
BASELINE_SAMPLING_HEARTBEAT="1000"
RESULTS_PATH="./.replication_results"
DATA_PATH="data"
BASELINE_SEED="1"

#############################
# length of samples in these cases roughly chosen to align runtime with Dynare code
RBC_KALMAN_TIMED_SAMPLES="10" # "6500"
RBC_JOINT_1_TIMED_SAMPLES="10" # "4000"
RBC_JOINT_2_TIMED_SAMPLES="10" # "4000"
RBC_JOINT_2_TIMED_SAMPLES_LONG="10" # "10000"
RBC_SV_JOINT_2_SAMPLES="10" # "50000"
RBC_SV_JOINT_2_CHAINS="2" # "4"

BASELINE_SGU_SAMPLES="10" # "5000"

# RBC examples
run_sampler $BASELINE_SEED $RBC_KALMAN_TIMED_SAMPLES "fit_rbc_1_kalman.jl" "${RESULTS_PATH}/rbc_1_kalman_timed"
run_sampler $BASELINE_SEED $RBC_JOINT_1_TIMED_SAMPLES "fit_rbc_1_joint.jl" "${RESULTS_PATH}/rbc_1_joint_timed"
run_sampler $BASELINE_SEED $RBC_JOINT_2_TIMED_SAMPLES "fit_rbc_2_joint.jl" "${RESULTS_PATH}/rbc_2_joint_timed"
run_sampler $BASELINE_SEED $RBC_JOINT_2_TIMED_SAMPLES_LONG "fit_rbc_2_joint.jl" "${RESULTS_PATH}/rbc_2_joint_timed_long"


# SGU examples
run_sampler $BASELINE_SEED $BASELINE_SGU_SAMPLES "fit_sgu_1_kalman.jl" "${RESULTS_PATH}/sgu_1_kalman"
run_sampler $BASELINE_SEED $BASELINE_SGU_SAMPLES "fit_sgu_1_joint.jl" "${RESULTS_PATH}/sgu_1_joint"
run_sampler $BASELINE_SEED $BASELINE_SGU_SAMPLES "fit_sgu_2_joint.jl" "${RESULTS_PATH}/sgu_2_joint"

# RBC Stochastic Volatility examples
run_sampler $BASELINE_SEED $RBC_SV_JOINT_2_SAMPLES "fit_rbc_sv_2_joint.jl" "${RESULTS_PATH}/rbc_sv_2_joint" "${DATA_PATH}/rbc_sv_2.csv" "${DATA_PATH}/rbc_sv_2_joint_burnin.csv" $RBC_SV_JOINT_2_CHAINS

print_header "Baseline experiments complete"