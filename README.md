# DSSM HMC Examples

## Installation
Do an
Then
`julia --project -e "using Pkg; Pkg.instantiate()"`

## CLI Usage
To use with default options, and specifying a directory
```bash
julia --project --threads auto -O1 bin/fit_rbc_1_kalman.jl --results_path ./results/main_rbc_1_kalman --overwrite_results true --num_samples 100
julia --project --threads auto -O1 bin/fit_rbc_1_joint.jl --results_path ./results/main_rbc_1_joint --overwrite_results true --num_samples 100
```
(although the `--threads auto` may or may not be useful in this example.)

Or with options such as multiple chains
```bash
julia --project --threads auto -O1 bin/fit_rbc_1_kalman.jl --results_path ./results/main_rbc_1_kalman --overwrite_results true --num_samples 1000 --num_chains 8
```
## Package Compilation
Given the slow startup speed, it can be helpful to compile a custom sysimage.  This would be used by both vscode and the commandline.  To do this, execute the following in a commandline
```bash
julia --threads auto -e 'using Pkg; Pkg.add(\"PackageCompiler\")'
julia --project --threads auto -O1 ./deps/create_sysimage.jl
```

Grab coffee.  This will take at least 10 minutes to run.

After: when you use vscode it will load the custom sysimage as long as you have the `Julia: Use custom sysimage` option enabled (which it should be default?)

On the commandline you will need to manually provide it.  For example, 
```bash
julia --project --sysimage JuliaSysimage.dll --threads auto -O1 bin/fit_rbc_1_kalman.jl --results_path ./results/main_rbc_1_kalman --overwrite_results true --num_samples 1000
```
## Grid
On grid.ai commandline:
```bash
grid run --name rbc-test --config scripts/default_compute.yml bin/fit_rbc_1_kalman.jl --results_path ./results/main_rbc_1_kalman --overwrite_results true --num_samples 100
```
To see the logs during execution (which could be 10ish minutes to build the container) do `grid logs rbc-test`.

To download the results when complete `grid artifacts rbc-test`

# Analyzing the Chain
To load a file into a chain with some path,
```julia
using Serialization, HMCExamples
chain = open(deserialize, joinpath(pkgdir(HMCExamples), "results/main_FVGQ_2_joint/chain.jls"))
```

To extract the entire chain for some parameters
```
vals = get(chain, [:h,:κ])
```

And to get all of the values in an array for the last draw in the chain and then save into a file,
```julia
last_draw = chain.value[end,:,1][chain.name_map.parameters] |> Array
writedlm(joinpath(pkgdir(HMCExamples), "data/FVGQ_2_burnin_draw.csv"), last_draw, ',')
```
Then you could edit the `init_param` in the samplers to use that as an initial condition in the `estimate_` files.  For example,
```julia
init_param = readdlm(joinpath(pkgdir(HMCExamples), "data/FVGQ_2_burnin_draw.csv"), ',', Float64, '\n')[:,1]
```

