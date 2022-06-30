echo -e "\e[44;1m-- 1: install Julia --\e[0m"
wget https://julialang-s3.julialang.org/bin/linux/x64/1.7/julia-1.7.1-linux-x86_64.tar.gz
tar zxvf julia-1.7.1-linux-x86_64.tar.gz

cd HMCExamples.jl

echo -e "\e[44;1m-- 5: generate sysimage --\e[0m"
sudo apt install g++
~/julia-1.7.1/bin/julia --threads auto -e 'using Pkg; Pkg.add("PackageCompiler")'
~/julia-1.7.1/bin/julia --project -e "using Pkg; Pkg.instantiate()"
~/julia-1.7.1/bin/julia --project --threads auto -O1 ./deps/create_sysimage.jl

echo -e "\e[44;1m-- complete --\e[0m"
