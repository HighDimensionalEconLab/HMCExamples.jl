using HMCExamples, DifferenceEquations, DifferentiableStateSpaceModels, Turing, Zygote
using DifferentiableStateSpaceModels: order_vector_by_symbols

m = PerturbationModel(HMCExamples.sgu)

p_f = (; γ = 2.0, ω = 1.455, σe = 0.0129, δ = 0.1, ψ = 0.000742,
              ϕ = 0.028, r_w = 0.04, d_bar = 0.7442, ρ_u = 0.2,
              σu = 0.003, ρ_v = 0.4, σv = 0.1, Ω_1 = 0.00316)
p_d = (; ρ = 0.42, α = 0.32, β = 1.0 / (1.0 + 0.04))

c = SolverCache(m, Val(1), p_d)
sol = generate_perturbation(m, p_d, p_f; cache = c)
ϵ0 = [1.0, 1.0, 1.0]
T = 40
val = irf(sol, ϵ0, T)

println(val.z)

# using RecursiveArrayTools
# plot(VectorOfArray(val.z)')
# this does not work here because HMCExamples needs to reference the branch but Plots is not in the manifest

# H-checking code:

p_d_symbols = collect(Symbol.(keys(p_d)))
p = order_vector_by_symbols(merge(p_d, p_f), m.mod.m.p_symbols)
w = [sol.y; sol.x] # get a vector for the proposed steadystate
H = Vector{Float64}(undef, length(w)) # allocate it, but leave undef to make sure we can see if it goes to 0 or not
m.mod.m.H̄!(H, w, p)  # evaluate in place
@show H