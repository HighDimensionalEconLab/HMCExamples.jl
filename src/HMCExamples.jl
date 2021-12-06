module HMCExamples
using Base: String
using ArgParse, CSV, DataFrames, DelimitedFiles, DifferentiableStateSpaceModels, JLSO, JSON, LinearAlgebra, Logging, Random, Serialization, Turing, TuringCallbacks, TensorBoardLogger, Zygote 
import ArgParse.parse_item

# auto-generated code from /deps/generate_models.jl
include("generated_models/rbc.jl")
include("generated_models/FVGQ20.jl")

# # Utilities
include("utilities.jl")
include("experiment_results.jl")

# # Specific Models and CLI drivers
include("turing_models.jl")
# include("estimate_rbc_1_kalman.jl")
include("estimate_rbc_1_joint.jl")
# include("estimate_rbc_2_joint.jl")
# include("estimate_FVGQ_1_kalman.jl")
# include("estimate_FVGQ_1_joint.jl")
# include("estimate_FVGQ_2_joint.jl")

end #module
