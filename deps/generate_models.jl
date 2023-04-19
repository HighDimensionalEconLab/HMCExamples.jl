using DifferentiableStateSpaceModels, HMCExamples, Symbolics
overwrite_model_cache = true
model_cache_location = joinpath(pkgdir(HMCExamples),"src/generated_models")

include(joinpath(pkgdir(HMCExamples),"deps/rbc.jl"))
# Save off the rbc_observables_benchmark example
H, mod_vals, _ = rbc()
model_name = "rbc"
@info "RBC parameters" mod_vals.p
make_perturbation_model(H; model_name = "rbc", model_cache_location, overwrite_model_cache, mod_vals...)


include(joinpath(pkgdir(HMCExamples),"deps/sgu.jl"))
# sgu model
H, mod_vals, _ = sgu()
model_name = "sgu"
@info "SGU parameters" mod_vals.p
make_perturbation_model(H; model_name = "sgu", model_cache_location, overwrite_model_cache, mod_vals...)

include(joinpath(pkgdir(HMCExamples),"deps/rbc_sv.jl"))
# rbc model with nonlinear TFP shocks
H, mod_vals, _ = rbc_sv()
@info "RBC nonlinear TFP shocks" mod_vals.p
make_perturbation_model(H; model_name = "rbc_sv", model_cache_location, overwrite_model_cache, mod_vals...)