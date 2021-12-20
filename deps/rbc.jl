function rbc()
	∞ = Inf
	@variables α, β, ρ, δ, σ
	@variables t::Integer, k(..), z(..), c(..), q(..), i(..)
	@variables Ω_1
	x = [k, z]
	y = [c, q, i]
	p = [α, β, ρ, δ, σ, Ω_1]

	H = [1 / c(t) - (β / c(t + 1)) * (α * exp(z(t + 1)) * k(t + 1)^(α - 1) + (1 - δ)),
	c(t) + k(t + 1) - (1 - δ) * k(t) - q(t),
	q(t) - exp(z(t)) * k(t)^α,
	z(t + 1) - ρ * z(t),
	i(t) - (k(t + 1) - (1 - δ) * k(t))]

	steady_states = [k(∞) ~ (((1 / β) - 1 + δ) / α)^(1 / (α - 1)), z(∞) ~ 0,
				c(∞) ~ (((1 / β) - 1 + δ) / α)^(α / (α - 1)) -
						δ * (((1 / β) - 1 + δ) / α)^(1 / (α - 1)),
				q(∞) ~ (((1 / β) - 1 + δ) / α)^(α / (α - 1)),
				i(∞) ~ δ * (((1 / β) - 1 + δ) / α)^(1 / (α - 1))]

	steady_states_iv = [k(∞) ~ (((1 / β) - 1 + δ) / α)^(1 / (α - 1)), z(∞) ~ 0,
				c(∞) ~ (((1 / β) - 1 + δ) / α)^(α / (α - 1)) -
						δ * (((1 / β) - 1 + δ) / α)^(1 / (α - 1)),
				q(∞) ~ (((1 / β) - 1 + δ) / α)^(α / (α - 1)),
				i(∞) ~ δ * (((1 / β) - 1 + δ) / α)^(1 / (α - 1))]

	n_ϵ = 1
	n_x = length(x)
	n_y = length(y)
	n_p = length(p)
	Γ = reshape([σ], n_ϵ, n_ϵ)
	η = reshape([0; -1], n_x, n_ϵ) # η is n_x * n_ϵ matrix

	n_z = 2 # number of observables
	Q = zeros(n_z, n_x + n_y) # the order is [y, x]
	Q[1, 1] = 1.0 # c
	Q[2, 3] = 1.0 # i

	Ω = [Ω_1, Ω_1]
	
	return H, (; t, x, y, p, steady_states, steady_states_iv, Γ, η, Ω, Q), "rbc"
end
    