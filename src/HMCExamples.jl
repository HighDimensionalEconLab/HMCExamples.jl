module HMCExamples
using Base: String
using Turing, TuringCallbacks, TensorBoardLogger, ArgParse, CSV, DataFrames, 
    JSON, LinearAlgebra, DifferentiableStateSpaceModels, Random, DelimitedFiles, 
    Logging, JLSO, Serialization
import ArgParse.parse_item

# auto-generated code from /deps/generate_models.jl
include("generated_models/rbc/first_order_ip.jl")
include("generated_models/rbc/second_order_ip.jl")
include("generated_models/FVGQ20/first_order_ip.jl")
include("generated_models/FVGQ20/second_order_ip.jl")

# # Utilities
# include("utilities.jl")
# include("experiment_results.jl")

# # Specific Models and CLI drivers
# include("turing_models.jl")
# include("estimate_rbc_1_kalman.jl")
# include("estimate_rbc_1_joint.jl")
# include("estimate_rbc_2_joint.jl")
# include("estimate_FVGQ_1_kalman.jl")
# include("estimate_FVGQ_1_joint.jl")
# include("estimate_FVGQ_2_joint.jl")

end #module
