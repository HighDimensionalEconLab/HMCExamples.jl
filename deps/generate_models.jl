using DifferentiableStateSpaceModels, HMCExamples, Symbolics
overwrite_model_cache = true
model_cache_location = joinpath(pkgdir(HMCExamples),"src/generated_models")

# include(joinpath(pkgdir(HMCExamples),"deps/rbc.jl"))
# # Save off the rbc_observables_benchmark example
# H, mod_vals, _ = rbc()
# model_name = "rbc"
# @info "RBC parameters" mod_vals.p
# make_perturbation_model(H; model_name = "rbc", model_cache_location, overwrite_model_cache, mod_vals...)

# include(joinpath(pkgdir(HMCExamples),"deps/FVGQ20.jl"))
# # The FVGQ20 is in this repo
# H, mod_vals, _ = FVGQ20() # in this repo,
# model_name = "FVGQ20"
# @info "FVGQ20 parameters" mod_vals.p 
# make_perturbation_model(H; model_name = "FVGQ20", model_cache_location, overwrite_model_cache, mod_vals...)

include(joinpath(pkgdir(HMCExamples),"deps/sgu.jl"))
# sgu model
H, mod_vals, _ = sgu()
model_name = "sgu"
@info "SGU parameters" mod_vals.p
make_perturbation_model(H; model_name = "sgu", model_cache_location, overwrite_model_cache, mod_vals...)

# include(joinpath(pkgdir(HMCExamples),"deps/rbc_student_t.jl"))
# rbc model with student's t shocks
# H, mod_vals, _ = rbc_student_t()
# model_name = "rbc_student_t"
# @info "RBC w. Student's T parameters" mod_vals.p
# make_perturbation_model(H; model_name = "rbc_student_t", model_cache_location, overwrite_model_cache, mod_vals...)
