module HMCExamples
using Base: String
using ArgParse, CSV, DataFrames, DifferenceEquations, DelimitedFiles, DifferentiableStateSpaceModels, JSON, LinearAlgebra, Logging, Random, Serialization, Turing, Zygote
using AdvancedHMC: DiagEuclideanMetric, UnitEuclideanMetric, DenseEuclideanMetric # for preconditioning
using Turing: NUTS
using Turing: @addlogprob!
import ArgParse.parse_item
using PrecompileTools

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

@setup_workload begin
    @compile_workload begin
        HMCExamples.parse_commandline_rbc_1_kalman(ARGS)
        HMCExamples.parse_commandline_rbc_1_joint(ARGS)
        HMCExamples.parse_commandline_rbc_2_joint(ARGS)
        HMCExamples.parse_commandline_rbc_sv_2_joint(ARGS)
        
        HMCExamples.parse_commandline_sgu_1_kalman(ARGS)
        HMCExamples.parse_commandline_sgu_1_joint(ARGS)
        HMCExamples.parse_commandline_sgu_2_joint(ARGS)
        # Turing doesn't seem to support this
        # let 
        #     HMCExamples.main_rbc_1_kalman(["--num_samples", "10", "--max_depth", "2", "--results_path", "./.results/rbc_1_kalman_test", "--overwrite_results", "true"])        
        # end
    end
end

end # module
