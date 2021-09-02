using DifferentiableStateSpaceModels, ModelingToolkit, HMCExamples
overwrite_model_cache = true
model_cache_location = joinpath(pkgdir(HMCExamples),"src/generated_models")

include(joinpath(pkgdir(HMCExamples),"deps/rbc.jl"))

# Save off the rbc_observables_benchmark example
H, mod_vals, _ = rbc()
model_name = "rbc"
@info "RBC parameters" mod_vals.p mod_vals.p_f
save_first_order_module(H; model_name = "$(model_name)_1", model_cache_location, overwrite_model_cache, mod_vals...)
save_second_order_module(H; model_name = "$(model_name)_2", model_cache_location, overwrite_model_cache, mod_vals...)

include(joinpath(pkgdir(HMCExamples),"deps/FVGQ20.jl"))

# The FVGQ20 is in this repo
H, mod_vals, _ = FVGQ20() # in this repo,
model_name = "FVGQ20"
@info "FVGQ20 parameters" mod_vals.p mod_vals.p_f
save_first_order_module(H; model_name = "$(model_name)_1", model_cache_location, overwrite_model_cache, mod_vals...)
save_second_order_module(H; model_name = "$(model_name)_2", model_cache_location, overwrite_model_cache, mod_vals...)