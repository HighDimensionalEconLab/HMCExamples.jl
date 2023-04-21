#!/bin/bash

# ChatGPT4 generated
print_header() {
  local header_text="$1"
  local print_separator="${2:-true}"
  local separator=""

  if [ "$print_separator" = "true" ]; then
    separator=$(printf "%-${#header_text}s" "=")
    separator=${separator// /=}
  fi

  # Set text color to bold green
  tput bold
  tput setaf 2

  if [ "$print_separator" = "true" ]; then
    echo -e "${separator}\n${header_text}\n${separator}"
  else
    echo -e "${header_text}"
  fi

  # Reset text attributes
  tput sgr0
}


# ChatGPT generated utility to run sampler for a particular script/etc.  Modify defaults above as required, or at the call site
JULIA_ARGS="--threads auto"
BASELINE_SAMPLING_HEARTBEAT="1000"

# Detect the operating system and check for the corresponding sysimage file
os_name=$(uname)
if [[ "$os_name" == "Linux" ]] && [ -e "JuliaSysimage.so" ]; then
  JULIA_ARGS="--sysimage JuliaSysimage.so $JULIA_ARGS"
elif [[ "$os_name" == "MINGW"* ]] && [ -e "JuliaSysimage.dll" ]; then
  JULIA_ARGS="--sysimage JuliaSysimage.dll $JULIA_ARGS"
fi

run_sampler() {
  local seed="$1"
  local num_samples="$2"
  local script_name="$3"
  local results_name="$4"
  local data_name="${5:-}" # optional
  local init_params_name="${6:-}" # optional
  local num_chains="${7:-}"  # default to 1 chain, optional argument
  local additional_script_args="${8:-}"  # additional Julia script arguments, optional

  print_header "Running $script_name with $num_samples samples and seed = $seed"

  local data_args=""
  if [ -n "$data_name" ]; then
    data_args="--data_path $data_name"
  fi

  local init_params_args=""
  if [ -n "$init_params_name" ]; then
    init_params_args="--init_params_file $init_params_name"
  fi

  local chains_and_heartbeat_args=""
  if [ -n "$num_chains" ]; then
    chains_and_heartbeat_args="--num_chains $num_chains --sampling_heartbeat $BASELINE_SAMPLING_HEARTBEAT"
  fi

  julia --project $JULIA_ARGS bin/$script_name --results_path $results_name --overwrite_results true $data_args --num_samples $num_samples $chains_and_heartbeat_args --seed $seed $init_params_args $additional_script_args
}

