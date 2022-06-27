# Replication procedure

## Dynare 

1. `bash scripts/dynare/dynare_bootup.sh`
2. `sudo docker run -it --rm --shm-size=512M mathworks/matlab:r2022a -shell`

From inside the Docker instance:
1. `git clone https://github.com/HighDimensionalEconLab/HMCExamples.jl`
2. `cd HMCExamples.jl/scripts/dynare`
3. `bash install_dynare.sh`
