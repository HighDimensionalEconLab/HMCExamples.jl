#!/bin/bash

# Run at the top level HMCExamples directory, not within the `/scripts` or `/scripts/run_samplers` directories
source ./scripts/utilities.sh # includes print_header, run_sampler, etc.

# General variables for arguments and paths used in the run_sampler utility function defined in utilities.sh
RESULTS_PATH=".replication_results"
DATA_PATH="data"
BASELINE_SEED="1"

# length of samples in the RBC cases roughly chosen to align runtime with Dynare code
RBC_KALMAN_SAMPLES="6500"
RBC_JOINT_1_SAMPLES="4000"
RBC_JOINT_2_SAMPLES="4000"
RBC_JOINT_2_SAMPLES_LONG="10" # "10000"
RBC_KALMAN_LONG_SAMPLES="13000"
RBC_JOINT_1_LONG_SAMPLES="10000"
RBC_JOINT_2_LONG_SAMPLES="10000"
RBC_CHAINS_LONG="4"

RBC_SV_JOINT_2_SAMPLES="10" # "50000"
RBC_SV_JOINT_2_CHAINS="2" # "4"
RBC_MULTIPLE_CHAINS="2" # "10" number of chains for density plots, etc.
RBC_SAMPLES="10" # "5000" # baseline
SGU_SAMPLES="10" # "5000" # baseline

# # RBC examples
# run_sampler $BASELINE_SEED $RBC_KALMAN_SAMPLES "fit_rbc_1_kalman.jl" "${RESULTS_PATH}/rbc_1_kalman" "" "${DATA_PATH}/rbc_1_kalman_burnin_dynare.csv"
run_sampler $BASELINE_SEED $RBC_JOINT_1_SAMPLES "fit_rbc_1_joint.jl" "${RESULTS_PATH}/rbc_1_joint" "" "${DATA_PATH}/rbc_1_joint_burnin_ergodic.csv"
run_sampler $BASELINE_SEED $RBC_JOINT_2_SAMPLES "fit_rbc_2_joint.jl" "${RESULTS_PATH}/rbc_2_joint" "" "${DATA_PATH}/rbc_2_joint_burnin_ergodic.csv"
# run_sampler $BASELINE_SEED $RBC_JOINT_2_SAMPLES_LONG "fit_rbc_2_joint.jl" "${RESULTS_PATH}/rbc_2_joint_long" "" "${DATA_PATH}/rbc_2_joint_burnin_ergodic.csv"

# RBC with bigger T a few different ways
# run_sampler $BASELINE_SEED $RBC_KALMAN_SAMPLES "fit_rbc_1_kalman.jl" "${RESULTS_PATH}/rbc_1_kalman_500" "${DATA_PATH}/rbc_1_500.csv" "${DATA_PATH}/rbc_1_kalman_burnin_dynare.csv"
run_sampler $BASELINE_SEED $RBC_JOINT_1_SAMPLES "fit_rbc_1_joint.jl" "${RESULTS_PATH}/rbc_1_joint_500" "${DATA_PATH}/rbc_1_500.csv" "${DATA_PATH}/rbc_1_joint_burnin_500.csv"
run_sampler $BASELINE_SEED $RBC_JOINT_2_SAMPLES "fit_rbc_2_joint.jl" "${RESULTS_PATH}/rbc_2_joint_500" "${DATA_PATH}/rbc_2_500.csv" "${DATA_PATH}/rbc_2_joint_burnin_500.csv"
# run_sampler $BASELINE_SEED $RBC_KALMAN_LONG_SAMPLES "fit_rbc_1_kalman.jl" "${RESULTS_PATH}/rbc_1_kalman_500_long" "${DATA_PATH}/rbc_1_500.csv" "${DATA_PATH}/rbc_1_kalman_burnin_dynare.csv"
# run_sampler $BASELINE_SEED $RBC_JOINT_1_LONG_SAMPLES "fit_rbc_1_joint.jl" "${RESULTS_PATH}/rbc_1_joint_500_long" "${DATA_PATH}/rbc_1_500.csv" "${DATA_PATH}/rbc_1_joint_burnin_500.csv"
# run_sampler $BASELINE_SEED $RBC_JOINT_2_LONG_SAMPLES "fit_rbc_2_joint.jl" "${RESULTS_PATH}/rbc_2_joint_500_long" "${DATA_PATH}/rbc_2_500.csv" "${DATA_PATH}/rbc_2_joint_burnin_500.csv"
# run_sampler $BASELINE_SEED $RBC_KALMAN_SAMPLES "fit_rbc_1_kalman.jl" "${RESULTS_PATH}/rbc_1_kalman_500_multichains" "${DATA_PATH}/rbc_1_500.csv" "${DATA_PATH}/rbc_1_kalman_burnin_dynare.csv" $RBC_CHAINS_LONG
# run_sampler $BASELINE_SEED $RBC_JOINT_1_SAMPLES "fit_rbc_1_joint.jl" "${RESULTS_PATH}/rbc_1_joint_500_multichains" "${DATA_PATH}/rbc_1_500.csv" "${DATA_PATH}/rbc_1_joint_burnin_500.csv" $RBC_CHAINS_LONG
# run_sampler $BASELINE_SEED $RBC_JOINT_2_SAMPLES "fit_rbc_2_joint.jl" "${RESULTS_PATH}/rbc_2_joint_500_multichains" "${DATA_PATH}/rbc_2_500.csv" "${DATA_PATH}/rbc_2_joint_burnin_500.csv" $RBC_CHAINS_LONG

# # RBC with Multiple Chains for the density plots
# run_sampler $BASELINE_SEED $RBC_SAMPLES "fit_rbc_1_kalman.jl" "${RESULTS_PATH}/rbc_1_kalman_multiple_chains" "" "${DATA_PATH}/rbc_1_kalman_burnin_dynare.csv" $RBC_MULTIPLE_CHAINS
# run_sampler $BASELINE_SEED $RBC_SAMPLES "fit_rbc_1_joint.jl" "${RESULTS_PATH}/rbc_1_joint_multiple_chains" "" "${DATA_PATH}/rbc_1_joint_burnin_ergodic.csv" $RBC_MULTIPLE_CHAINS
# run_sampler $BASELINE_SEED $RBC_SAMPLES "fit_rbc_2_joint.jl" "${RESULTS_PATH}/rbc_2_joint_multiple_chains" "" "${DATA_PATH}/rbc_2_joint_burnin_ergodic.csv" $RBC_MULTIPLE_CHAINS

# # SGU examples
# run_sampler $BASELINE_SEED $SGU_SAMPLES "fit_sgu_1_kalman.jl" "${RESULTS_PATH}/sgu_1_kalman" "" "${DATA_PATH}/sgu_1_kalman_burnin.csv"
# run_sampler $BASELINE_SEED $SGU_SAMPLES "fit_sgu_1_joint.jl" "${RESULTS_PATH}/sgu_1_joint" "" "${DATA_PATH}/sgu_1_joint_burnin.csv"
# run_sampler $BASELINE_SEED $SGU_SAMPLES "fit_sgu_2_joint.jl" "${RESULTS_PATH}/sgu_2_joint" "" "${DATA_PATH}/sgu_2_joint_burnin.csv"

# # RBC Stochastic Volatility examples
# run_sampler $BASELINE_SEED $RBC_SV_JOINT_2_SAMPLES "fit_rbc_sv_2_joint.jl" "${RESULTS_PATH}/rbc_sv_2_joint" "${DATA_PATH}/rbc_sv_2.csv" "${DATA_PATH}/rbc_sv_2_joint_burnin.csv" $RBC_SV_JOINT_2_CHAINS

print_header "Baseline experiments complete"