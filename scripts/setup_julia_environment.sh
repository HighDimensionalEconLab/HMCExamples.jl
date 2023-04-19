#!/bin/bash

# # Before execution, can use  Do a standard linux setup, following something like the following:
# source setup_linux_environment.sh

# Execute at the top level HMCExamples directory, not within the `/scripts`

source ./scripts/utilities.sh # includes print_header, etc.

# Install julia with juliaup
sudo curl -fsSL https://install.julialang.org | sh -s -- --yes

source ~/.bashrc  # I think required to reload after Juila installation for paths to be correct

# Optionally: to make this maximally replicable you can set the julia version here:
juliaup add 1.8.5
juliaup default 1.8.5

# Instantiate the packages for the main run project/manifest
print_header "Instantiating Packages in the global and project specfic environments"
julia --threads auto -e 'using Pkg; Pkg.add("PackageCompiler")'
julia --project --threads auto -e "using Pkg; Pkg.instantiate()"

print_header "Running package compiler (might take > 10 minutes)"
julia --project --threads auto ./deps/create_sysimage.jl


print_header "Instantiating packages for the table/figure generation"
julia --threads auto -e 'using Pkg; Pkg.activate("scripts/generate_figures"); Pkg.instantiate()'

# installing the pip python files for plotting,
# optional: create and activate a new conda environment
# conda create -n HMCExamples python
# conda activate HMCExamples

pip install -r scripts/generate_figures/requirements.txt
