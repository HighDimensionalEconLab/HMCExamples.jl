#sgu.jl
#Code to implement extended version of Schmitt-Grohe and Uribe (2003, JIE) Model 2
#Shamelessly copied from Dynare .mod file of Cesa-Bianchi (2012)
#https://sites.google.com/site/ambropo/dynarecodes
#and from Dynare .mod file of Pfeifer (2019)
#https://github.com/JohannesPfeifer/DSGE_mod/tree/master/SGU_2003
#Rewritten from Dynare to Schmitt-Grohe and Uribe timing conventions
#following http://www.columbia.edu/~mu2166/closing/edeir_model.m

function sgu()
    ∞ = Inf
    # Parameters
    @variables γ, ω, ρ, σe, δ, ψ, α, ϕ, β, r_w, d_bar, ρ_u, σu, ρ_v, σv
    # x and y
    @variables t::Integer, d(..), c(..), h(..), GDP(..), i(..), k(..), a(..), λ(..), tb(..),
               ca(..), riskpremium(..), r(..), kfu(..), ζ(..), μ(..)
    @variables Ω_1
    x = [a, ζ, μ, k, r]
    y = [d, c, h, GDP, i, kfu, λ, tb, ca, riskpremium]
    p = [γ, ω, ρ, σe, δ, ψ, α, ϕ, β, r_w, d_bar, ρ_u, σu, ρ_v, σv, Ω_1]
    
    # Model equations
    H = [d(t+1) - (1 + exp(r(t))) * d(t) + exp(GDP(t)) - exp(c(t)) - exp(i(t)) -
         (ϕ / 2) * (exp(k(t+1)) - exp(k(t)))^2, #Debt evolution
         exp(GDP(t)) - exp(a(t)) * (exp(k(t))^α) * (exp(h(t))^(1 - α)), #Production function
         exp(k(t + 1)) - exp(i(t)) - (1 - δ) * exp(k(t)), #Capital evolution
         exp(λ(t)) - β * exp(μ(t)) * (1 + exp(r(t))) * exp(λ(t + 1)), #Euler equation
         (exp(c(t)) - ((exp(h(t))^ω) / ω))^(-γ) - exp(λ(t)), #Marginal utility
         ((exp(c(t)) - ((exp(h(t))^ω) / ω))^(-γ)) * (exp(h(t))^(ω - 1)) -
         exp(λ(t)) * (1 - α) * exp(GDP(t)) / exp(h(t)), #Labor FOC
         exp(λ(t)) * (1 + ϕ * (exp(k(t + 1)) - exp(k(t)))) -
         β *
         exp(μ(t)) * exp(λ(t + 1)) *
         (α * exp(GDP(t + 1)) / exp(k(t + 1)) + 1 - δ + ϕ * (exp(kfu(t + 1)) - exp(k(t + 1)))), #Investment FOC
         a(t + 1) - ρ * a(t), #TFP evolution
         exp(r(t)) - r_w - riskpremium(t), #Interest rate
         riskpremium(t) - ψ * (exp(d(t) - d_bar) - 1) - ζ(t), #Risk premium
         tb(t) - 1 +
         ((exp(c(t)) + exp(i(t)) + (ϕ / 2) * (exp(k(t + 1)) - exp(k(t)))^2) / exp(GDP(t))), #Trade Balance
         ca(t) - (1 / -exp(GDP(t))) * (d(t) - d(t + 1)), #Current Account
         kfu(t) - k(t + 1), #auxiliary future variable
         ζ(t + 1) - ρ_u * ζ(t), #Risk premium shock
         μ(t + 1) - ρ_v * μ(t)] #Demand shock
    
    #Define representations for steady state

    hstar = ((1 - α) * (α / (r_w + δ))^(α / (1 - α)))^(1 / (ω - 1))
    kstar = hstar / (((r_w + δ) / α)^(1 / (1 - α)))
    istar = δ * kstar
    GDPstar = (kstar^α) * (hstar^(1 - α))
    cstar = GDPstar - istar - r_w * d_bar
    tbstar = GDPstar - cstar - istar
    λstar = (cstar - ((hstar^ω) / ω))^(-γ)
    
    #Steady state values
    
    steady_states = [a(∞) ~ 0, kfu(∞) ~ log(kstar),
                     d(∞) ~ d_bar, c(∞) ~ log(cstar), h(∞) ~ log(hstar),
                     GDP(∞) ~ log(GDPstar), i(∞) ~ log(istar), k(∞) ~ log(kstar),
                     λ(∞) ~ log(λstar), tb(∞) ~ tbstar, ca(∞) ~ 0, riskpremium(∞) ~ 0,
                     r(∞) ~ log((1 - β) / β),
                     ζ(∞) ~ 0,
                     μ(∞) ~ 0]

    n_ϵ = 3
    n_x = length(x)
    n_y = length(y)
    Γ = zeros(Num, n_ϵ, n_ϵ) # make sure it is not a float64 matrix
    Γ[1, 1] = σe
    Γ[2, 2] = σu
    Γ[3, 3] = σv
    η = zeros(n_x, n_ϵ) # η is n_x * n_ϵ matrix
    η[1, 1] = 1 # e
    η[2, 2] = 1 # u
    η[3, 3] = 1 # v

    n_z = 3 # number of observables
	Q = zeros(n_z, n_x + n_y) # the order is [y, x]
    Q[1, 4] = 1.0 # y i.e. GDP
    Q[2, 9] = 1.0 # ca
    Q[3, 15] = 1.0 # r

    Ω = [Ω_1, Ω_1, Ω_1]

    return H, (; t, x, y, p, steady_states, Γ, η, Ω, Q), "sgu"
end