module HMCExamples
using Base: String
using ArgParse, CSV, DataFrames, DifferenceEquations, DelimitedFiles, DifferentiableStateSpaceModels, JSON, LinearAlgebra, Logging, Random, Serialization, Turing, Zygote
using AdvancedHMC: DiagEuclideanMetric, UnitEuclideanMetric, DenseEuclideanMetric # for preconditioning
using Turing: NUTS
using MCMCChainsStorage
using HDF5
using Turing: @addlogprob!
import ArgParse.parse_item

# auto-generated code from /deps/generate_models.jl
include("generated_models/rbc.jl")
include("generated_models/rbc_sv.jl")
include("generated_models/sgu.jl")

# # Utilities
include("utilities.jl")
include("experiment_results.jl")

# # Specific Models and CLI drivers
include("estimate_rbc_1_kalman.jl")
include("estimate_rbc_1_joint.jl")
include("estimate_rbc_2_joint.jl")
include("estimate_rbc_sv_2_joint.jl")
include("estimate_sgu_1_kalman.jl")
include("estimate_sgu_1_joint.jl")
include("estimate_sgu_2_joint.jl")

end # module
