using HMCExamples, DifferenceEquations, DifferentiableStateSpaceModels, Plots
using DifferentiableStateSpaceModels: order_vector_by_symbols

m = PerturbationModel(HMCExamples.sgu)

p_f = (; γ = 2.0, ω = 1.455, σe = 0.0129, δ = 0.1, ψ = 0.000742,
              ϕ = 0.028, r_w = 0.04, d_bar = 0.7442, ρ_u = 0.2,
              σu = 0.003, ρ_v = 0.4, σv = 0.1, Ω_1 = 0.00316)
p_d = (; ρ = 0.42, α = 0.32, β = 1.0 / (1.0 + 0.04))

c = SolverCache(m, Val(1), p_d)
sol = generate_perturbation(m, p_d, p_f; cache = c)
T = 40
ϵ01 = [1.0, 0.0, 0.0]
ϵ02 = [0.0, 1.0, 0.0]
ϵ03 = [0.0, 0.0, 1.0]
val1 = irf(sol, ϵ01, T) #e
val2 = irf(sol, ϵ02, T) #u
val3 = irf(sol, ϵ03, T) #v

println(val1.z)
println(val2.z)
println(val3.z)

 using RecursiveArrayTools
 plot(VectorOfArray(val1.z)') #e
 plot(VectorOfArray(val2.z)') #u
 plot(VectorOfArray(val3.z)') #v
# this does not work here because HMCExamples needs to reference the branch but Plots is not in the manifest

# H-checking code:

p_d_symbols = collect(Symbol.(keys(p_d)))
p = order_vector_by_symbols(merge(p_d, p_f), m.mod.m.p_symbols)
w = [sol.y; sol.x] # get a vector for the proposed steadystate
H = Vector{Float64}(undef, length(w)) # allocate it, but leave undef to make sure we can see if it goes to 0 or not
m.mod.m.H̄!(H, w, p)  # evaluate in place
@show H