#!/bin/bash

# Run at the top level HMCExamples directory, not within the `/scripts` or `/scripts/run_samplers` directories
source ./scripts/utilities.sh # includes print_header, run_sampler, etc.

# General variables for arguments and paths used in the run_sampler utility function defined in utilities.sh
export OPENBLAS_NUM_THREADS=1 # removes parallel openblas so these can be executed in parallel more easily
RESULTS_PATH=".replication_results/frequentist"
DATA_PATH="data"
INIT_PARAMS_PATH="data/init_params"
BASELINE_SEED="1"
NUM_SAMPLES="5000"

# Define variables for start and max seed, and values of T
START_SEED=1
NUM_SEEDS=100
T_VALUES=(50 100 200)

# Loop over values of SEED and T
start_time=$(date +%s)
for ((SEED=$START_SEED; SEED<=$NUM_SEEDS+$START_SEED-1; SEED++)); do
  for T in "${T_VALUES[@]}"; do
    # Execute the run_sampler function with the current values of SEED and T
    run_sampler $SEED $NUM_SAMPLES "fit_rbc_1_joint.jl" "${RESULTS_PATH}/rbc_1_joint_frequentist_seed_${SEED}_${T}" "${DATA_PATH}/rbc_frequentist/rbc_1_seed_${SEED}_${T}.csv" "${INIT_PARAMS_PATH}/rbc_1_joint_init_params_${T}.csv" 
  done
done

# display elapsed time
end_time=$(date +%s)
elapsed=$(( end_time - start_time ))
eval "echo Elapsed time: $(date -ud "@$elapsed" +'$((%s/3600/24)) days %H hr %M min %S sec')"
