# DSSM HMC Examples

## Installation
Do an
Then
`julia --project -e "using Pkg; Pkg.instantiate()"`

## CLI Usage
To use with default options
```bash
julia --project --threads auto fit_rbc_1_kalman.jl
```
(although the `--threads auto` may or may not be useful in this example.)

Or with options
```bash
julia --project --threads auto fit_rbc_1_kalman.jl --num_samples 1000
```
To run tensorboard, ensure tensorboard is installed (e.g. with  `pip install -r requirements.txt` ) and
```bash
tensorboard --logdir tensorboard_logs
```

## Package Compilation
Given the slow startup speed, it can be helpful to compile a custom sysimage.  This would be used by both vscode and the commandline.  To do this, execute the following in a commandline
```bash
julia --threads auto -e 'using Pkg; Pkg.add(\"PackageCompiler\")'
julia --threads auto ./deps/create_sysimage.jl
```
Then when you use vscode it will load the custom sysimage as long as you have the `Julia: Use custom sysimage` option enabled (which it should be default?)

On the commandline you will need to manually provide it.  For example, 
```bash
julia --project --sysimage JuliaSysimage.dll --threads auto fit_rbc_1_kalman.jl --num_samples 1000
```
