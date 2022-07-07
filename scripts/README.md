# Replication Procedure (Standalone Ubuntu Linux or Ubuntu on Windows)

You may wish to use `tmux` to leave a terminal running unattended.\
If `tmux` is not already installed, do a `sudo apt update` followed by `sudo apt install tmux`.\
Create a new session using `tmux new-session -s ubuntu` and retrieve it using `tmux attach-session -t ubuntu`.

To use the following instructions, first clone the repo via `git clone https://github.com/HighDimensionalEconLab/HMCExamples.jl`.

## Dynare 

1. `bash HMCExamples.jl/scripts/dynare_replication/dynare_bootup.sh`
2. `sudo docker run -it --rm --shm-size=512M mathworks/matlab:r2022a -shell`

From inside the Docker instance:
1. `sudo apt update`
2. `sudo apt install -y git`
3. `git clone https://github.com/HighDimensionalEconLab/HMCExamples.jl`
4. `cd HMCExamples.jl/scripts/dynare_replication`
5. `bash install_dynare.sh`
6. `matlab` and then type in your license credentials.
7. Run whichever `.m` file from inside the `dynare_replication` folder you wish to run:
  - `robustness_rbc_1.m`
  - `robustness_rbc_2.m`
  - `table_rbc_1.m`
  - `table_rbc_2.m` 
  
You may wish to log the Dynare output to inspect the acceptance rates over the course of a run. To do this, type `script` before starting Matlab, which will log all outputs to a file. This file can be parsed using a script in the `figplots` folder; see the summary tables section below.

For convenience, you may wish to push/pull folders in/out of the docker container (e.g. the dynare-5.1 folder to avoid recompilation). An example:
`sudo docker cp dynare-5.1 63d13510863a:/home/matlab/Documents/MATLAB/HMCExamples.jl/scripts/dynare_replication/dynare-5.1`\
where `63d13510863a` comes from `sudo docker ps`. You will likely also want to do this to save the Dynare results folders at the end.

Note that if using a pre-existing dynare folder, you will still need to run the following lines from `install_dynare.sh`:
- `sudo apt install wget xz-utils build-essential gfortran liboctave-dev libboost-graph-dev libgsl-dev libmatio-dev libslicot-dev libslicot-pic libsuitesparse-dev flex libfl-dev bison autoconf automake texlive texlive-publishers texlive-latex-extra texlive-fonts-extra texlive-latex-recommended texlive-science texlive-plain-generic lmodern python3-sphinx tex-gyre latexmk libjs-mathjax doxygen x13as`
- `mkdir dynare_chains_1 dynare_chains_2 dynare_chains_timed`

## Julia

Note that if installing Julia on the command line, you will need to call it as `~/julia-1.7.1/bin/julia --project <scriptname>` i.e. specifying the full path of the Julia executable.

1. `bash HMCExamples.jl/scripts/julia_replication/install_julia.sh`
2. `cd HMCExamples.jl`
3. Run whichever shellscript from inside the `julia_replication` folder you wish to run:
  - `scripts/julia_replication/f124_plots.sh`
  - `scripts/julia_replication/frequentist_kalman.sh`
  - `scripts/julia_replication/frequentist_joint_1.sh`
  - `scripts/julia_replication/frequentist_joint_2.sh`
  - `scripts/julia_replication/tables.sh`
  - `scripts/julia_replication/robustness.sh`

## Uploading results to an AWS S3 bucket

1. Follow the [install instructions](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) for AWS CLI.
2. `aws configure`
3. Access the `~/.aws/credentials` file and ensure the profile (the `[name]` at the top), key ID, key and region are correct.
4. Upload folders through e.g. `aws s3 cp s3://the_store_path_name/experiments ./experiments --recursive --profile the_profile_name`.

## Producing summary tables and plots

On Ubuntu, Python or Python3 should be installed by default. If not, do `sudo apt update` followed by `sudo apt install python3` and `sudo apt install python3-pip`. If the command is present as `python3`, replace all instances of `python` in the text below with `python3`.\
Following this, run `cd HMCExamples.jl` followed by `pip install -r scripts/figplots/requirements.txt`.

Next, you will need to instantiate the Julia project associated with the scripts, which is separate from the main project file. Run `julia --project=scripts -e "using Pkg; Pkg.instantiate()"`.

In addition, you will need to have all experiments copied with the proper filepaths into a folder called `.experiments` in the `HMCExamples.jl` directory. If adding experiments manually, check the corresponding plot/table script for the filepaths being used.

Run `mkdir .tables .results .figures` to prevent filepath errors when running the scripts.

The following options are available:

### Dynare
- Dynare Log Parser
  - Use this to read the Dynare logs if you saved it to a file earlier.
  - `python scripts/figplots/parse_dynare_log.py`

- Summary Statistics
  - First, pull the Matlab chain files into Julia by running `julia --project=scripts scripts/figplots/dynare_to_julia.jl`.
  - Next, parse the results into tables using `python scripts/figplots/sumstats_dynare.py`.

- Robustness Plots
  - `julia --project=scripts --threads auto scripts/figplots/robustness_dynare.jl`
  - Ideally, this command should be run on a machine with as many threads as possible due to the slow execution time of StatsPlots.

### Julia
- Numerical Error Presence Validation
  - `python scripts/figplots/scan_for_errors.py`

- Summary Statistics
  - `julia --project=scripts scripts/figplots/sumstats_julia.py`

- Summary Plots
  - `julia --project=scripts scripts/figplots/statplots_julia.jl`

- Platform Cross-Comparison, Scatterplot, Inferred Shocks
  - `julia --project=scripts scripts/figplots/otherplots.jl`

- Robustness Plots
  - `julia --project=scripts --threads auto scripts/figplots/robustness_julia.jl`
  - Ideally, this command should be run on a machine with as many threads as possible due to the slow execution time of StatsPlots.

- Frequentist Statistics
  - First, run `julia --project=scripts scripts/figplots/frequentist_julia.jl`.
  - After, run `julia --project=scripts scripts/figplots/frequentist_julia.py`.
