using CSV, DataFrames, DelimitedFiles, JSON, MCMCChains
using MAT

include("calculate_experiment_results_dynare.jl")

mat = matread("dynare_chains_timed_4/chain_2nd_order.mat")
data = [mat["x2"] mat["logpo2"]]
println(mat["rt"])
c = Chains(data, ["α", "β_draw", "ρ", "lp"])
calculate_experiment_results_dynare(c, "dynare_2nd_order_new", ["α", "β_draw", "ρ"])
