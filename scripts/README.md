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

**WARNING**: This will do some very long runs and likely take hours or days to complete if you run these serially.

To run the samplers, you can execute:

```bash
bash scripts/run_samplers/baseline_experiments.sh
```

A few notes:
  - 
  - This uses the  `scripts/utilities.sh` file has some BASH functions to enable easy execution of the samplers with various permutations on the arguments.
  - To only execute a subset of the runs, you can comment out lines in the `baseline_experiments.sh` file.
  - If you want to change the location of the data or the output, you can edit the `$RESULTS_PATH` and `$DATA_PATH` variables in the `baseline_experiments.sh` file.


The other scripts in the `scripts/run_samplers` folder are slower because they do a large number of variations for frequentist comparisons and checks on robustness of convergence.  You may want to run them in parallel as some may take days to run.


## Dynare 

1. `bash HMCExamples.jl/scripts/dynare_replication/dynare_bootup.sh`
2. `sudo docker run -it --rm --shm-size=512M mathworks/matlab:r2022a -shell`

From inside the Docker instance:
1. `sudo apt update`
2. `sudo apt install -y git nano`
3. `git clone https://github.com/HighDimensionalEconLab/HMCExamples.jl`
4. `cd HMCExamples.jl/scripts/dynare_replication`
5. `bash install_dynare.sh`
6. `matlab` and then type in your license credentials.
7. Run whichever `.m` file from inside the `dynare_replication` folder you wish to run:
  - `robustness_rbc_1.m`
  - `robustness_rbc_2.m`
  - `table_rbc_1.m`
  - `table_rbc_2.m` 
  - `table_sgu.m` (you will need to edit this and the `SU03ext.mod` file while inside the container to select an order level; you can use e.g. `nano SU03ext.mod` to edit files, then `ctrl+x` followed by `y` followed by `enter` to save and close them)
  
You may wish to log the Dynare output to inspect the acceptance rates over the course of a run. To do this, type `script` before starting Matlab, which will log all outputs to a file. This file can be parsed using a script in the `figplots` folder; see the summary tables section below.

For convenience, you may wish to push/pull folders in/out of the docker container. An example:
`sudo docker cp 63d13510863a:/home/matlab/Documents/MATLAB/HMCExamples.jl/scripts/dynare_replication/dynare_chains_timed dynare_chains_timed`\
where `63d13510863a` comes from `sudo docker ps`. You will likely want to do this to save the Dynare results folders at the end.

If you need to shut the machine down, run `sudo docker commit <ID> dynaredocker` where `<ID>` is replaced with the ID from `sudo docker ps`. You can then re-activate the docker container using `sudo docker run -it --rm --shm-size=512M dynaredocker -shell` later on. This is more efficient than restarting and moving the dynare-5.1 folder in/out.

To move the image to another machine, run `sudo docker save <ID> > <ID>.tar` where again the `<ID>` comes from `sudo docker ps.`. The image can then be loaded elsewhere by copying the `.tar` file and opening it with `sudo docker load < <ID>.tar`.

## Julia

Note that if installing Julia on the command line, you will need to call it as `~/julia-1.7.1/bin/julia --project <scriptname>` i.e. specifying the full path of the Julia executable.

1. `tmux new-session -s ubuntu` (do `tmux attach-session -t ubuntu` if it responds with session already exists)
2. `bash HMCExamples.jl/scripts/julia_replication/install_julia.sh`
3. `exit`
4. `tmux new-session -s ubuntu`
5. `cd HMCExamples.jl`
6. `script`
7. Run whichever shellscript from inside the `julia_replication` folder you wish to run:
  - `scripts/julia_replication/f124_plots.sh`
  - `scripts/julia_replication/frequentist_kalman.sh`
  - `scripts/julia_replication/frequentist_joint_1.sh`
  - `scripts/julia_replication/frequentist_joint_2.sh`
  - `scripts/julia_replication/tables.sh`
  - `scripts/julia_replication/robustness.sh`

Note that the call to `script` generates a logfile called `typescript` in the `HMCExamples.jl` folder which you can use to query script errors in the event of an unexpected shutdown, or if the terminal overflows.

## FVGQ Julia

1. `tmux new-session -s ubuntu` (do `tmux attach-session -t ubuntu` if it responds with session already exists)
2. `bash HMCExamples.jl/scripts/fvgq_replication/install_julia.sh`
3. `exit`
4. `tmux new-session -s ubuntu`
5. `cd HMCExamples.jl`
6. `script`
7. Run whichever shellscript from inside the `fvgq_replication` folder you wish to run:
  - `scripts/fvgq_replication/kalman.sh`
  - `scripts/fvgq_replication/1_joint.sh`
  - `scripts/fvgq_replication/2_joint.sh`
  
## SGU Julia

1. `tmux new-session -s ubuntu` (do `tmux attach-session -t ubuntu` if it responds with session already exists)
2. `bash HMCExamples.jl/scripts/sgu_replication/install_julia.sh`
3. `exit`
4. `tmux new-session -s ubuntu`
5. `cd HMCExamples.jl`
6. `script`
7. `bash scripts/sgu_replication/run.sh`

## RBC SV Julia

1. `tmux new-session -s ubuntu` (do `tmux attach-session -t ubuntu` if it responds with session already exists)
2. `bash HMCExamples.jl/scripts/rbc_sv_replication/install_julia.sh`
3. `exit`
4. `tmux new-session -s ubuntu`
5. `cd HMCExamples.jl`
6. `script`
7. `bash scripts/rbc_sv_replication/run.sh`

## Uploading results to an AWS S3 bucket

1. `sudo apt install unzip`
2. Follow the [install instructions](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) for AWS CLI.
3. `aws configure`
4. Access the `~/.aws/credentials` file and ensure the profile (the `[name]` at the top), key ID, key and region are correct.
5. Upload folders through e.g. `aws s3 cp s3://the_store_path_name/experiments ./experiments --recursive --profile the_profile_name`.

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
