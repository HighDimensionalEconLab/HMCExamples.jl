module HMCExamples
using Base: String
using Turing, TuringCallbacks, TensorBoardLogger, ArgParse, StatsPlots, CSV, DataFrames, JSON, LinearAlgebra, DifferentiableStateSpaceModels, Random
import ArgParse.parse_item

# auto-generated from /deps/generate_models.jl
include("generated_models/rbc_1.jl")
include("generated_models/rbc_2.jl")


# Code
include("utilities.jl")
include("turing_models.jl")
include("estimate_rbc_1_kalman.jl")

end #module