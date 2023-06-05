# DSSM HMC Examples

This package provides the compete replication for [__"Differentiable State-Space Models and Hamiltonian Monte Carlo Estimation"__](https://www.jesseperla.com/publication/diff-state-space/diff-state-space.pdf) by David Childers, Jesus Fernandez-Villaverde, Jesse Perla, Christopher Rackauckas, and Peifan Wu.

The algorithms are mostly implemented in:
1. [DifferentiableStateSpaceModels.jl](https://github.com/HighDimensionalEconLab/DifferentiableStateSpaceModels.jl) for the differentiable perturbation method solver
2. [DifferenceEquations.jl](https://github.com/SciML/DifferenceEquations.jl/) for the differentiable solver for the Kalman filter, simulations of state space models, and likelihoods.

## Installation
With Julia 1.9 and this repository cloned to your local machine, execute `julia --project -e "using Pkg; Pkg.instantiate()"`

## CLI Usage
To use with default options, and specifying a directory
```bash
julia --project bin/fit_rbc_1_kalman.jl --results_path ./.results/rbc_1_kalman --overwrite_results true --num_samples 100
julia --project bin/fit_rbc_1_joint.jl --results_path ./.results/rbc_1_joint --overwrite_results true --num_samples 100
```
(although the `--threads auto` may or may not be useful in this example.)

Or with options such as multiple chains
```bash
julia --project --threads auto bin/fit_rbc_1_kalman.jl --results_path ./.results/rbc_1_kalman --overwrite_results true --num_samples 1000 --num_chains 8
```

## Some Features
A few features for sampling and output:
- `--target_acceptance_rate 0.65` set the target acceptance for NUTS
- `--max_depth 5` set the max_depth for NUTS
- `--init_params_file data/my_file.csv` uses that file as the initial condition for sampling

In all cases, for long-burnins you can find the final draw of the chain as the `last_draw.csv` file, which can be used with the `init_params_file` argument after moving/renaming
## Package Compilation
**Warning** PackageCompiler.jl can be finicky and may not be always functional.  If the process below stalls and doesn't complete after 30ish minutes, you might be between working versions.

Given the slow startup speed, it can be helpful to compile a custom sysimage.  This would be used by both vscode and the commandline.  To do this, execute the following in a commandline
```bash
julia --threads auto -e 'using Pkg; Pkg.add(\"PackageCompiler\")'
julia --project --threads auto ./deps/create_sysimage.jl
```

Grab coffee.  This will take at least 15-30 minutes to run.  It will help startup latency (maybe 2-3 minutes less to start sampling), but not as much as you would hope.  Zygote.jl is not amenable to caching compilation when used with Turing.

After: when you use vscode it will also load this custom sysimage as long as you have the `Julia: Use custom sysimage` option enabled.

On the commandline you will need to provide the image manually.  For example, 
```bash
julia --project --sysimage JuliaSysimage.dll --threads auto bin/fit_rbc_1_kalman.jl --results_path ./.results/rbc_1_kalman --overwrite_results true --num_samples 1000
```

## Paper Replication
To replicate all of the results in the paper, see the [README.md](scripts/README.md) in the scripts directory.