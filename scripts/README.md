# Replication Procedure

This process describes the entire replication process for linux, WSL (Windows Subsystem for Linux), or on Windows with Git Bash.  While most individual runs are fast, the paper has a large number of robustness checks and the full execution could take up to a week if done serially.
## Setup Environment
Install conda and if using linux then install the Linux packages yourself directly, or else use the following script to do it automatically on Linux or Windows WSL:
```bash
bash scripts/setup_linux_environment.sh
```

You will need to setup Julia and compile required packages.  On all platofrms, you should be able to do this by running the following script (staying at the top level of the repo):

```bash
bash scripts/setup_julia_environment.sh
```

That process will do a package compilation and take 10-20 minutes depending on your operating system.

## Create a Sysimage

While not strictly required, it is highly recommended to create a sysimage to speed up the sampling process. Execute the following in a commandline within the main directory

```bash
julia --threads auto -e 'using Pkg; Pkg.add(\"PackageCompiler\")'
julia --project --threads auto ./deps/create_sysimage.jl
```

That process will take at least 20 minutes to fully compile.

## Simulate data (Optional)

The files are already generated in the `/data` directory.  To regenerate the simulated data you can run

```bash
julia --sysimage JuliaSysimage.dll --project deps/generate_simulated_data_rbc.jl
julia --sysimage JuliaSysimage.dll --project deps/generate_simulated_data_rbc_sv.jl
julia --sysimage JuliaSysimage.dll --project deps/generate_simulated_data_rbc_frequentist.jl
julia --sysimage JuliaSysimage.dll --project deps/generate_simulated_data_sgu.jl
```

where you can replace the `.dll` with `.so` on linux or macos.

If you change the pseudo-true values in that file, you can also change the initial conditions for the samplers in the `data/init_params` directory.  However, while useful for clean comparisons to dynare performance, they are not especially important in general.

## Run Samplers

**WARNING**: This will take up to a day to run.

To run the primary experiments, execute:

```bash
bash scripts/run_samplers/baseline_experiments.sh
```

The other scripts are left separate to make running them in parallel easier.  These run thousands of examples and may take **3-4 days to run** in parallel, depending on your computer.  However, you can edit the shell scripts to run these in parallel with little effort.

```bash
bash scripts/run_samplers/rbc_1_joint_frequentist.sh
bash scripts/run_samplers/rbc_1_kalman_frequentist.sh
bash scripts/run_samplers/rbc_2_joint_frequentist.sh
bash scripts/run_samplers/rbc_1_joint_robustness.sh
bash scripts/run_samplers/rbc_1_kalman_robustness.sh
bash scripts/run_samplers/rbc_2_joint_robustness.sh
```
A few notes:
  - 
  - This uses the  `scripts/utilities.sh` file has some BASH functions to enable easy execution of the samplers with various permutations on the arguments.
  - To only execute a subset of the runs, you can comment out lines in the `baseline_experiments.sh` file.
  - If you want to change the location of the data or the output, you can edit the `$RESULTS_PATH` and `$DATA_PATH` variables in the `baseline_experiments.sh` file.

## Dynare 

To setup:
1. Install a recent version of Matlab (these were tested on Matlab 2021a)
2. Install dynare from https://www.dynare.org/download/.  These were tested with dynare 5.4
3. Configure dynare in your matlab path (e.g., https://www.dynare.org/resources/quick_start/#configuring-matlab-for-dynare-on-windows on Windows)

Then, from the main folder do
```bash
bash scripts/run_dynare_samplers/baseline_experiments.sh
```

Then, you can run the following (in separate terminals if you wish, as the results aren't timed like the previous example).  This may take 1-2 days
```bash
cd scripts/run_dynare_samplers
matlab -nosplash -nodesktop -r "run('rbc_1_robustness.m');exit;"
matlab -nosplash -nodesktop -r "run('rbc_2_robustness.m');exit;"
```

Finally, with all of the dynare results complete you can run

```bash
julia --project scripts/run_dynare_samplers/convert_dynare_output.jl
```

## TODO BELOW
## Producing summary tables and plots

On Ubuntu, Python or Python3 should be installed by default. If not, do `sudo apt update` followed by `sudo apt install python3` and `sudo apt install python3-pip`. If the command is present as `python3`, replace all instances of `python` in the text below with `python3`.\
Following this, run `cd HMCExamples.jl` followed by `pip install -r scripts/figplots/requirements.txt`.

Next, you will need to instantiate the Julia project associated with the scripts, which is separate from the main project file. Run `julia --project=scripts -e "using Pkg; Pkg.instantiate()"`.

In addition, you will need to have all experiments copied with the proper filepaths into a folder called `.experiments` in the `HMCExamples.jl` directory. If adding experiments manually, check the corresponding plot/table script for the filepaths being used.

Run `mkdir .tables .results .figures` to prevent filepath errors when running the scripts.

The following options are available:

### Dynare RBC
- Dynare Log Parser
  - Use this to read the Dynare logs if you saved it to a file earlier.
  - `python scripts/figplots/parse_dynare_log.py`

- Summary Statistics
  - First, pull the Matlab chain files into Julia by running `julia --project=scripts scripts/figplots/dynare_to_julia.jl`.
  - Next, parse the results into tables using `python scripts/figplots/sumstats_dynare.py`.

- Robustness Plots
  - `julia --project=scripts --threads auto scripts/figplots/robustness_dynare.jl`
  - Ideally, this command should be run on a machine with as many threads as possible due to the slow execution time of StatsPlots.
  
### Dynare SGU
- Summary Statistics
  - First, pull the Matlab chain files into Julia by running `julia --project=scripts scripts/sgu_replication/dynare_to_julia.jl`.
  - Next, parse the results into tables using `python scripts/sgu_replication/sumstats_dynare.py`.
- Plots are available under the Julia SGU section.

### Julia RBC
- Numerical Error Presence Validation
  - `python scripts/figplots/scan_for_errors.py`
  
- Robustness Rhat Analysis/Validation
  - `python scripts/figplots/scan_rhat.py`

- Summary Statistics
  - `python scripts/figplots/sumstats_julia.py`

- Summary Plots
  - `julia --project=scripts scripts/figplots/statplots_julia.jl`

- Platform Cross-Comparison, Scatterplot, Inferred Shocks
  - `julia --project=scripts scripts/figplots/otherplots.jl`

- Robustness Plots
  - `julia --project=scripts scripts/figplots/robustness_julia.jl`

- Frequentist Statistics
  - First, run `julia --project=scripts scripts/figplots/frequentist_julia.jl`.
  - After, run `python scripts/figplots/frequentist_julia.py`.

### Julia FVGQ
- Summary Statistics
  - `python scripts/fvgq_replication/sumstats.py`
  
- Summary Plots
  - `julia --project=scripts scripts/fvgq_replication/statplots.jl`

### Julia SGU
- Summary Statistics
  - `python scripts/sgu_replication/sumstats_julia.py`
  
- Summary Plots
  - `julia --project=scripts scripts/sgu_replication/statplots.jl`

### Julia RBC with Student's T Shocks
- Summary Statistics
  - `python scripts/rbc_student_t_replication/sumstats_julia.py`
  
- Summary Plots
  - `julia --project=scripts scripts/rbc_student_t_replication/statplots.jl`

### Julia RBC with Stochastic Volatility, 1st Order
- Summary Statistics
  - `python scripts/rbc_volatility_replication/sumstats_julia.py`
  
- Summary Plots
  - `julia --project=scripts scripts/rbc_volatility_replication/statplots.jl`

### Julia RBC with Stochastic Volatility, 2nd Order, SGU Form
- Summary Statistics
  - `python scripts/rbc_sv_replication/sumstats_julia.py`
  
- Summary Plots
  - `julia --project=scripts scripts/rbc_sv_replication/statplots.jl`
