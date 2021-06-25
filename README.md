# DSSM HMC Examples


## Installation
Do an
Then
`julia --project -e "using Pkg; Pkg.instantiate()"`

## CLI Usage
To use with default options
```bash
julia --project --threads auto fit_rbc.jl
```
(although the `--threads auto` may or may not be useful in this example.)

Or with options
```bash
julia --project --threads auto fit.jl --num_samples 1000
```
To run tensorboard, ensure tensorboard is installed (e.g. with  `pip install -r requirements.txt` ) and
```bash
tensorboard --logdir tensorboard_logs
```
