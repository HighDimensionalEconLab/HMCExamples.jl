#!/bin/bash

# Run at the top level HMCExamples directory, not within the `/scripts` or `/scripts/run_samplers` directories
source ./scripts/utilities.sh # includes print_header, run_sampler, etc.

# General variables for arguments and paths used in the run_sampler utility function defined in utilities.sh
RESULTS_PATH=".replication_results"
DATA_PATH="data"
BASELINE_SEED="1"
RBC_1_KALMAN_SAMPLES="10" # "6500"

# Define arrays for the values of ALPHA, BETA_DRAW, and RHO
ALPHA_VALUES=(0.25 0.3 0.35 0.4)
BETA_DRAW_VALUES=(0.1 0.175 0.25 0.325)
RHO_VALUES=(0.4625 0.625 0.7875 0.95)

# Loop over the values of ALPHA, BETA_DRAW, and RHO
for ALPHA in "${ALPHA_VALUES[@]}"; do
  for BETA_DRAW in "${BETA_DRAW_VALUES[@]}"; do
    for RHO in "${RHO_VALUES[@]}"; do
      # Execute the run_sampler function with the current values of ALPHA, BETA_DRAW, and RHO
      run_sampler $BASELINE_SEED $RBC_1_KALMAN_SAMPLES "fit_rbc_1_kalman.jl" "${RESULTS_PATH}/rbc_1_kalman_robustness_${ALPHA//./_}_${BETA_DRAW//./_}_${RHO//./_}" "" "${DATA_PATH}/rbc_1_kalman_burnin_dynare.csv" "" "--override_init_params [${ALPHA},${BETA_DRAW},${RHO}]"
    done
  done
done
