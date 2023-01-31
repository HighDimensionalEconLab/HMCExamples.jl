# DSSM HMC Examples

## Installation
Do `julia --project -e "using Pkg; Pkg.instantiate()"`

## CLI Usage
To use with default options, and specifying a directory
```bash
julia --project --threads auto -O1 bin/fit_rbc_1_kalman.jl --results_path ./.results/rbc_1_kalman --overwrite_results true --num_samples 100
julia --project --threads auto -O1 bin/fit_rbc_1_joint.jl --results_path ./.results/rbc_1_joint --overwrite_results true --num_samples 100
```
(although the `--threads auto` may or may not be useful in this example.)

Or with options such as multiple chains
```bash
julia --project --threads auto -O1 bin/fit_rbc_1_kalman.jl --results_path ./.results/rbc_1_kalman --overwrite_results true --num_samples 1000 --num_chains 8
```

## Some Features
A few features for sampling and output:
- `--target_acceptance_rate 0.65` set the target acceptance for NUTS
- `--max_depth 5` set the max_depth for NUTS
- `--discard_initial 100` etc. discards draws as a warmup
- `--save_jls true`  save the entire chain as an (unportable) JLS file.  Default is true
- `--save_hd5 true` saves as a portable HDF5 file format.  Default is false
- `--init_params_file data/my_file.csv` uses that file as the initial condition for sampling

In all cases, for long-burnins you can find the final draw of the chain as the `last_draw.csv` file, which can be used with the `init_params_file` argument after moving/renaming
## Package Compilation
Given the slow startup speed, it can be helpful to compile a custom sysimage.  This would be used by both vscode and the commandline.  To do this, execute the following in a commandline
```bash
julia --threads auto -e 'using Pkg; Pkg.add(\"PackageCompiler\")'
julia --project --threads auto -O1 ./deps/create_sysimage.jl
```

Grab coffee.  This will take at least 15-30 minutes to run.  It will help startup latency (maybe 2-3 minutes less to start sampling), but not as much as you would hope.  Zygote.jl is not amenable to caching compilation.

After: when you use vscode it will also load this custom sysimage as long as you have the `Julia: Use custom sysimage` option enabled.

On the commandline you will need to manually provide it manually.  For example, 
```bash
julia --project --sysimage JuliaSysimage.dll --threads auto -O1 bin/fit_rbc_1_kalman.jl --results_path ./.results/rbc_1_kalman --overwrite_results true --num_samples 1000
```
## Grid
On grid.ai commandline:
```bash
grid run --name rbc-test --config scripts/default_compute.yml bin/fit_rbc_1_kalman.jl --results_path ./.results/rbc_1_kalman --overwrite_results true --num_samples 100
```
To see the logs during execution (which could be 10ish minutes to build the container) do `grid logs rbc-test`.

To download the results when complete `grid artifacts rbc-test`

# Analyzing the Chain
## Loading files

To load a file into a chain with some path which saved with baseline serialization
```julia
using Serialization, HMCExamples, DelimitedFiles, MCMCChains
chain = open(deserialize, joinpath(pkgdir(HMCExamples), ".results/rbc_1_joint/chain.jls"))
```

To load the generated HDF5 file, which should be portable between OS and over time
```julia
using HDF5, HMCExamples, MCMCChains, MCMCChainsStorage
chain = h5open(joinpath(pkgdir(HMCExamples), ".results/rbc_1_joint/chain.h5"), "r") do f
  read(f, Chains)
end
```

## Accessing Chains
To extract the entire chain for some parameters
```
vals = get(chain, [:α,:β_draw])
```

Or to get a slice of all parameters for the last draw in the chain
```julia
last_draw = chain.value[end,:,1][chain.name_map.parameters] |> Array
```

**NOTE** The h5 format may reorder the chain's variables, so you can't count on using them being in the same order.
