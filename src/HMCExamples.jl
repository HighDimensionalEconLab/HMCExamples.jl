module HMCExamples
using Base: String
using Turing, TuringCallbacks, TensorBoardLogger, ArgParse, CSV, DataFrames, JSON, LinearAlgebra, DifferentiableStateSpaceModels, Random, DelimitedFiles, Logging
import ArgParse.parse_item

# auto-generated code from /deps/generate_models.jl
include("generated_models/rbc_1.jl")
include("generated_models/rbc_2.jl")
include("generated_models/FVGQ20_1.jl")
include("generated_models/FVGQ20_2.jl")

# Utilities
include("utilities.jl")
include("experiment_results.jl")

# Specific Models and CLI drivers
include("turing_models.jl")
include("estimate_rbc_1_kalman.jl")
include("estimate_rbc_1_joint.jl")
include("estimate_rbc_2_joint.jl")
include("estimate_FVGQ_1_kalman.jl")
include("estimate_FVGQ_1_joint.jl")
include("estimate_FVGQ_2_joint.jl")

end #module
