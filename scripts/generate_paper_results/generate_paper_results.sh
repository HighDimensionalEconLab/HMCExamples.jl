#!/bin/bash

# assumes that all scripts in run_dynare_samplers and run_samplers have executed
# Data prep
julia --project=scripts scripts/generate_paper_results/convert_frequentist_output.jl
julia --project=scripts scripts/generate_paper_results/convert_dynare_output.jl

# Figures
julia --project=scripts scripts/generate_paper_results/baseline_figures.jl
julia --project=scripts scripts/generate_paper_results/rbc_robustness_figures.jl

# Tables
python scripts/generate_paper_results/baseline_tables.py
python scripts/generate_paper_results/rbc_frequentist_tables.py
