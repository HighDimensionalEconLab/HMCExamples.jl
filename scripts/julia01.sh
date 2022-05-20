#!/usr/bin/env bash

# adapted from https://github.com/robert-s-lee/grid-julia/blob/main/run.sh
# pull script from params and truncate param list accordingly

echo "Using MKL"

echo "Arguments"
echo "$@"

script=$2
shift
shift

echo "Arguments"
echo "$@"

echo julia --project --threads auto -O1 $script $@    
julia  --project --threads auto -O1 $script $@ 
