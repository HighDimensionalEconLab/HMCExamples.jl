#!/bin/bash

# Run at the top level HMCExamples directory, not within the `/scripts` or `/scripts/run_samplers` directories
source ./scripts/utilities.sh # includes print_header, run_sampler, etc.

# General variables for arguments and paths used in the run_sampler utility function defined in utilities.sh
RESULTS_PATH=".replication_results"
DATA_PATH="data"
BASELINE_SEED="1"
NUM_SAMPLES="10" # "6500"

# Define variables for start and max seed, and values of T
START_SEED=1
NUM_SEEDS=100
T_VALUES=(50 100 200)

# Loop over values of SEED and T
for ((SEED=$START_SEED; SEED<=$NUM_SEEDS+$START_SEED-1; SEED++)); do
  for T in "${T_VALUES[@]}"; do
    # Execute the run_sampler function with the current values of SEED and T
    run_sampler $SEED $NUM_SAMPLES "fit_rbc_2_joint.jl" "${RESULTS_PATH}/rbc_2_joint_frequentist_${SEED}_${T}" "${DATA_PATH}/rbc_frequentist/rbc_2_seed_${SEED}_${T}.csv" "${DATA_PATH}/rbc_2_joint_burnin_ergodic_${T}.csv" 
  done
done