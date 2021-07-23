module HMCExamples
using Base: String
using StatsPlots
using Turing, TuringCallbacks, TensorBoardLogger, ArgParse, CSV, DataFrames, JSON, LinearAlgebra, DifferentiableStateSpaceModels, Random, DelimitedFiles
import ArgParse.parse_item

# auto-generated from /deps/generate_models.jl
include("generated_models/rbc_1.jl")
include("generated_models/rbc_2.jl")


# Code
include("utilities.jl")
include("turing_models.jl")
include("experiment_results.jl")
include("estimate_rbc_1_kalman.jl")

end #module