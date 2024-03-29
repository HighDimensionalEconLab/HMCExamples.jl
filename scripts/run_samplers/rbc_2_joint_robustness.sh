#!/bin/bash

# Run at the top level HMCExamples directory, not within the `/scripts` or `/scripts/run_samplers` directories
source ./scripts/utilities.sh # includes print_header, run_sampler, etc.

# General variables for arguments and paths used in the run_sampler utility function defined in utilities.sh
export OPENBLAS_NUM_THREADS=1 # removes parallel openblas so these can be executed in parallel more easily
RESULTS_PATH=".replication_results/robustness"
DATA_PATH="data"
INIT_PARAMS_PATH="data/init_params"
BASELINE_SEED="1"
NUM_SAMPLES="4000"

# Define arrays for the values of ALPHA, BETA_DRAW, and RHO
ALPHA_VALUES=(0.25 0.3 0.35 0.4)
BETA_DRAW_VALUES=(0.1 0.175 0.25 0.325)
RHO_VALUES=(0.4625 0.625 0.7875 0.95)

start_time=$(date +%s)
# Loop over the values of ALPHA, BETA_DRAW, and RHO
for ALPHA in "${ALPHA_VALUES[@]}"; do
  for BETA_DRAW in "${BETA_DRAW_VALUES[@]}"; do
    for RHO in "${RHO_VALUES[@]}"; do
      # Execute the run_sampler function with the current values of ALPHA, BETA_DRAW, and RHO
      run_sampler $BASELINE_SEED $NUM_SAMPLES "fit_rbc_2_joint.jl" "${RESULTS_PATH}/rbc_2_joint_robustness_${ALPHA//./_}_${BETA_DRAW//./_}_${RHO//./_}" "${DATA_PATH}/rbc_2_200.csv" "${INIT_PARAMS_PATH}/rbc_2_joint_init_params_200.csv" "" "--override_init_params [${ALPHA},${BETA_DRAW},${RHO}]"
    done
  done
done

# display elapsed time
end_time=$(date +%s)
elapsed=$(( end_time - start_time ))
eval "echo Elapsed time: $(date -ud "@$elapsed" +'$((%s/3600/24)) days %H hr %M min %S sec')"
