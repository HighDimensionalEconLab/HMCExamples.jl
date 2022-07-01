# Replication Procedure (Standalone Ubuntu Linux or Ubuntu on Windows)

You may wish to use `tmux` to leave a terminal running unattended.\
If `tmux` is not already installed, do a `sudo apt update` followed by `sudo apt install tmux`.\
Create a new session using `tmux new-session -s ubuntu` and retrieve it using `tmux attach-session -t ubuntu`.

To use the following instructions, first clone the repo via `git clone https://github.com/HighDimensionalEconLab/HMCExamples.jl`.

## Dynare 

1. `bash HMCExamples.jl/scripts/dynare/dynare_bootup.sh`
2. `sudo docker run -it --rm --shm-size=512M mathworks/matlab:r2022a -shell`

From inside the Docker instance:
1. `sudo apt update`
2. `sudo apt install git`
3. `git clone https://github.com/HighDimensionalEconLab/HMCExamples.jl`
4. `cd HMCExamples.jl/scripts/dynare`
5. `bash install_dynare.sh`
6. `matlab` and then type in your license credentials.
7. Run whichever `.m` file from inside the `dynare` folder you wish to run:
  - `robustness_rbc_1.m`
  - `robustness_rbc_2.m`
  - `table_rbc_1.m`
  - `table_rbc_2.m` 

For convenience, you may wish to push/pull folders in/out of the docker container (e.g. the dynare folder to avoid recompilation). An example:
`sudo docker cp dynare-5.1 63d13510863a:/home/matlab/Documents/MATLAB/HMCExamples.jl/scripts/dynare/dynare-5.1`\
where `63d13510863a` comes from `sudo docker ps`.

Note that if using a pre-existing dynare folder, you will still need to run the following lines from `install_dynare.sh`:
- `sudo apt install wget xz-utils build-essential gfortran liboctave-dev libboost-graph-dev libgsl-dev libmatio-dev libslicot-dev libslicot-pic libsuitesparse-dev flex libfl-dev bison autoconf automake texlive texlive-publishers texlive-latex-extra texlive-fonts-extra texlive-latex-recommended texlive-science texlive-plain-generic lmodern python3-sphinx tex-gyre latexmk libjs-mathjax doxygen x13as`
- `mkdir dynare_chains_1 dynare_chains_2 dynare_chains_timed`

## Julia

1. `bash HMCExamples.jl/scripts/julia_replication/install_julia.sh`
2. `cd HMCExamples.jl`
3. Run whichever shellscript from inside the `julia_replication` folder you wish to run:
  - `f124_plots.sh`
  - `frequentist_kalman.sh`
  - `frequentist_joint_1.sh`
  - `frequentist_joint_2.sh`
  - `tables.sh`
  - `robustness.sh`
