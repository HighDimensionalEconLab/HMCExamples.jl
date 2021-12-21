module HMCExamples
using Base: String
using ArgParse, CSV, DataFrames, DifferenceEquations, DelimitedFiles, DifferentiableStateSpaceModels, JLSO, JSON, LinearAlgebra, Logging, Random, Serialization, Turing, TuringCallbacks, TensorBoardLogger, Zygote 
using Turing: @addlogprob!
import ArgParse.parse_item
export Beta_tr, Gamma_tr, InvGamma_tr

# auto-generated code from /deps/generate_models.jl
include("generated_models/rbc.jl")
include("generated_models/FVGQ20.jl")

# # Utilities
include("utilities.jl")
include("experiment_results.jl")

# # Specific Models and CLI drivers
include("turing_models.jl")
include("estimate_rbc_1_kalman.jl")
include("estimate_rbc_1_joint.jl")
include("estimate_rbc_2_joint.jl")
include("estimate_FVGQ_1_kalman.jl")
include("estimate_FVGQ_1_joint.jl")
include("estimate_FVGQ_2_joint.jl")

end # module
