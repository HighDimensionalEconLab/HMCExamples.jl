function rbc_sv()
	∞ = Inf
    @variables α, β, ρ, δ, σ, ρ_σ, μ_σ, σ_σ
    @variables t::Integer, k(..), z(..), zlag(..),  c(..), q(..), i(..),  ν(..), ζ(..)
    @variables Ω_1
    x = [k, zlag, ν, ζ]
    y = [c, q, z, i]
    p = [α, β, ρ, δ, σ, Ω_1, ρ_σ, μ_σ, σ_σ]

    H = [1 / c(t) - (β / c(t + 1)) * (α * exp(z(t + 1)) * k(t + 1)^(α - 1) + (1 - δ)),
    c(t) + k(t + 1) - (1 - δ) * k(t) - q(t),
    q(t) - exp(z(t)) * k(t)^α,
    z(t) - ρ * zlag(t) - exp(ν(t)) * ζ(t),
    ν(t + 1) - ρ_σ * ν(t) - (1 - ρ_σ) * μ_σ,
    ζ(t+1),
    zlag(t+1) - z(t),
    i(t) - (k(t + 1) - (1 - δ) * k(t))]

    steady_states = [k(∞) ~ (((1 / β) - 1 + δ) / α)^(1 / (α - 1)),
                zlag(∞) ~ 0,
                ν(∞) ~ μ_σ,
                ζ(∞) ~ 0,
                c(∞) ~ (((1 / β) - 1 + δ) / α)^(α / (α - 1)) -
                        δ * (((1 / β) - 1 + δ) / α)^(1 / (α - 1)),
                q(∞) ~ (((1 / β) - 1 + δ) / α)^(α / (α - 1)),
                z(∞) ~ 0,
                i(∞) ~ δ * (((1 / β) - 1 + δ) / α)^(1 / (α - 1))]

    n_x = length(x)
    n_y = length(y)
    Γ = [σ 0;
        0 σ_σ]
    η = [0 0;
        0 0;
        0 -1.0;
        -1.0 0] # η is n_x * n_ϵ matrix
    
    n_z = 2 # number of observables
	Q = zeros(n_z, n_x + n_y) # the order is [y, x]
	Q[1, 1] = 1.0 # c
	Q[2, 4] = 1.0 # i

	Ω = [Ω_1, Ω_1]
	
	return H, (; t, x, y, p, steady_states, Γ, η, Ω, Q), "rbc_sv"
end
    