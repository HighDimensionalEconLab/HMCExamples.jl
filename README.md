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
julia --threads auto --project ./deps/create_sysimage.jl
```

Grab coffee.  This will take at least 10 minutes to run.

After: when you use vscode it will load the custom sysimage as long as you have the `Julia: Use custom sysimage` option enabled (which it should be default?)

On the commandline you will need to manually provide it.  For example, 
```bash
julia --project --sysimage JuliaSysimage.dll --threads auto -O1 bin/fit_rbc_1_kalman.jl --results_path ./results/main_rbc_1_kalman --overwrite_results true --num_samples 100
```
<!--## Grid
On grid.ai commandline:
```bash
grid run --instance_type t2.xlarge --framework julia --cpus 3 --name rbc-test bin/fit_rbc_1_kalman.jl --num_samples 100
```
To see the logs during execution (which could be 10ish minutes to build the container) do `grid logs rbc-test`.

To download the results when complete `grid artifacts rbc-test`
-->