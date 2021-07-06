function rbc()
    @parameters α β ρ δ σ Ω_1
    @variables k z c q i
    @make_markov k z c q i
    x = [k, z]
    y = [c, q, i]
    p = [α, β, ρ]
    p_f = [δ, σ, Ω_1]

    H = [1 / c - (β / c_p) * (α * exp(z_p) * k_p^(α - 1) + (1 - δ)),
         c + k_p - (1 - δ) * k - q,
         q - exp(z) * k^α,
         z_p - ρ * z,
         i - (k_p - (1 - δ) * k)]

    x̄ = [k_ss ~ (((1 / β) - 1 + δ) / α)^(1 / (α - 1)), z_ss ~ 0]
    ȳ = [c_ss ~ (((1 / β) - 1 + δ) / α)^(α / (α - 1)) -
                δ * (((1 / β) - 1 + δ) / α)^(1 / (α - 1)),
         q_ss ~ (((1 / β) - 1 + δ) / α)^(α / (α - 1)),
         i_ss ~ δ * (((1 / β) - 1 + δ) / α)^(1 / (α - 1))]

    x̄_iv = [z_ss ~ 0, k_ss ~ (((1 / β) - 1 + δ) / α)^(1 / (α - 1))]
    ȳ_iv = [q_ss ~ (((1 / β) - 1 + δ) / α)^(α / (α - 1)),
            c_ss ~ (((1 / β) - 1 + δ) / α)^(α / (α - 1)) -
                    δ * (((1 / β) - 1 + δ) / α)^(1 / (α - 1)),
            i_ss ~ δ * (((1 / β) - 1 + δ) / α)^(1 / (α - 1))]

    n_ϵ = 1
    n_z = 2
    n_x = length(x)
    n_y = length(y)
    n_p = length(p)
    Γ = reshape([σ], n_ϵ, n_ϵ)
    η = reshape([0; -1], n_x, n_ϵ) # η is n_x * n_ϵ matrix

    Q = zeros(n_z, n_y + n_x) # The order is [y, x]
    Q[1, 1] = 1.0 # c 
    Q[2, 3] = 1.0 # i

    Ω = [Ω_1, Ω_1]

    return H, (; x, y, x̄, ȳ, Γ, η, p_f, p, x̄_iv, ȳ_iv, Ω, Q), "rbc"
end
