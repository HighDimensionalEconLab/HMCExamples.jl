echo "**PRECOMPILING**"
julia --project -e "using Pkg; Pkg.instantiate()"
#julia --threads auto -e 'using Pkg; Pkg.add("PackageCompiler")'
#julia --project --threads auto -O1 ./deps/create_sysimage.jl

echo "**RUNNING SCRIPT**"

julia --project --threads auto -O1 bin/fit_rbc_sv_2_joint.jl --results_path ./.results/rbc_sv_2_joint --overwrite_results true --num_samples 50000 --num_chains 4 --seed 0 --sampling_heartbeat 1000

echo "**FINISHED**"
sudo shutdown -h now
