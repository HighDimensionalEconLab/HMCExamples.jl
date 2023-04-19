using DifferentiableStateSpaceModels, HMCExamples, Symbolics
overwrite_model_cache = true
model_cache_location = joinpath(pkgdir(HMCExamples),"src/generated_models")

include(joinpath(pkgdir(HMCExamples),"additional_examples/FVGQ20/FVGQ20.jl"))
# The FVGQ20 is in this repo
H, mod_vals, _ = FVGQ20() # in this repo,
model_name = "FVGQ20"
@info "FVGQ20 parameters" mod_vals.p 
make_perturbation_model(H; model_name = "FVGQ20", model_cache_location, overwrite_model_cache, mod_vals...)
