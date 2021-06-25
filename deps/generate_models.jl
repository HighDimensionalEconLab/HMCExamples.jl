# This file generates the model files for inclusion in the src/generated_models
# Re-run when models are added or changed.

using DifferentiableStateSpaceModels, ModelingToolkit, HMCExamples#, HMCExamples
overwrite_model_cache = true
model_cache_location = joinpath(pkgdir(HMCExamples),"src/generated_models")

# Save off the rbc_observables_benchmark example
H, mod_vals, _ = Examples.rbc_observables_benchmark()
model_name = "rbc"
mod_vals_rbc = merge(mod_vals, (p_f = mod_vals.p_f[2:end], p = [mod_vals.p ; mod_vals.p_f[1]]))
@info "RBC parameters" mod_vals_rbc.p mod_vals_rbc.p_f
save_first_order_module(H; model_name = "$(model_name)_1", model_cache_location, overwrite_model_cache, mod_vals_rbc...)