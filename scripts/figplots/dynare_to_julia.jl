using CSV, DataFrames, DelimitedFiles, JSON, MCMCChains
using MAT

include("calculate_experiment_results_dynare.jl")

mat1 = matread(".experiments/benchmarks_dynare/dynare_chains_timed/chain_1st_order.mat")
data1 = [mat1["x2"] mat1["logpo2"]]
println("1st order runtime (s): ", mat1["rt"])
c1 = Chains(data1, ["α", "β_draw", "ρ", "lp"])
println(" samples: ", length(keys(c1[:,"α",1])))
calculate_experiment_results_dynare(c1, ".results/dynare_1st_order", ["α", "β_draw", "ρ"], mat1["rt"])

mat2 = matread(".experiments/benchmarks_dynare/dynare_chains_timed/chain_2nd_order.mat")
data2 = [mat2["x2"] mat2["logpo2"]]
println("2nd order runtime (s): ", mat2["rt"])
c2 = Chains(data2, ["α", "β_draw", "ρ", "lp"])
println(" samples: ", length(keys(c2[:,"α",1])))
calculate_experiment_results_dynare(c2, ".results/dynare_2nd_order", ["α", "β_draw", "ρ"], mat2["rt"])
