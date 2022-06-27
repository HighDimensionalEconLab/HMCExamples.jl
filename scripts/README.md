# Replication procedure

You may wish to use `tmux` to leave a terminal running unattended.\
If `tmux` is not already installed, do a `sudo apt update` followed by `sudo apt install tmux`.\
Create a new session using `tmux new-session -s ubuntu` and retrieve it using `tmux attach-session -t ubuntu`.


## Dynare 

1. `bash scripts/dynare/dynare_bootup.sh`
2. `sudo docker run -it --rm --shm-size=512M mathworks/matlab:r2022a -shell`

From inside the Docker instance:
1. `sudo apt update`
2. `sudo apt install git`
3. `git clone https://github.com/HighDimensionalEconLab/HMCExamples.jl`
4. `cd HMCExamples.jl/scripts/dynare`
5. `bash install_dynare.sh`
6. `matlab` and then type in your license credentials
7. Run whichever `.m` files you wish to run
