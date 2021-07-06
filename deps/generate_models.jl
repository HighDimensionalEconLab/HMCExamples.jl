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