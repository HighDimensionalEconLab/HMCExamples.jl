# see tutorial https://turinglang.github.io/TuringCallbacks.jl/dev/

module HMCExamples

using Turing, TuringCallbacks, TensorBoardLogger, ArgParse, StatsPlots, CSV, DataFrames

include("generated_models/rbc_1.jl")
include("estimate_rbc_1.jl")

end #module
