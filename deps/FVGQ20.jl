

# NOTE: this model file is run from `/deps/generate_models.jl` or in the build phase.

# Model as in https://www.sas.upenn.edu/~jesusfv/ARE_Estimation.pdf

function FVGQ20()
    # Parameter values
    # δ = 0.025
    # ε = 10
    # ϕ = 0
    # γ2 = 0.001

    # Estimated parameters, taken from FV(2010), Table 3, p. 38, median estimate parameters
    # β = 0.998
    # h = 0.97
    # ϑ = 1.17
    # κ = 9.51
    # α = 0.21

    # θp = 0.82
    # χ = 0.63
    # γR = 0.77
    # γy = 0.19

    # γΠ = 1.29
    # Πbar = 1.01
    # ρd  = 0.12
    # ρφ = 0.93
    # σ_A = -3.97
    # σ_d = -1.51

    # σ_φ = -2.36
    # σ_μ = -5.43
    # σ_m = -5.85
    # Λμ = 3.4e-3
    # ΛA = 2.8e-3

    # 7 variable relabelings
    # 7 observations
    # 38 equations

    # 28 parameters. 23 of them to estimate, 5 parameters as constants
    @parameters δ ε ϕ γ2 β h ϑ κ α θp χ γR γy γΠ Πbar ρd ρφ ρg g_bar σ_A σ_d σ_φ σ_μ σ_m σ_g Λμ ΛA Ω_ii
    # States, 14
    @variables c_m x_m Π_m w_m R_m yd_m vp_m k d φ μ_I μ_A mshock g
    # Controls, 24
    @variables c x Π w R yd vp Πstar u q λ μ_z r l mc g1 g2 ob_μz ob_Π ob_R ob_dw ob_dy ob_l ob_μ
    # Markovize everything
    @make_markov c_m x_m Π_m w_m R_m yd_m vp_m k d φ μ_I μ_A mshock g c x Π w R yd vp Πstar u q λ μ_z r l mc g1 g2 ob_μz ob_Π ob_R ob_dw ob_dy ob_l ob_μ

    # Precompute some parameters, and steady state values
    ΛYd = (ΛA + α * Λμ) / (1 - α)
    Λx = exp(ΛYd)
    μ_z_val = exp(ΛYd)
    μ_I_val = exp(Λμ)
    γ1 = μ_z_val * μ_I_val / β - (1 - δ)
    Rbar = Πbar * μ_z_val / β
    Πstar_val = ((1 - θp * Πbar^(-(1 - ε) * (1 - χ))) / (1 - θp))^(1 / (1 - ε))
    vp_val = (1 - θp) / (1 - θp * Πbar^((1 - χ) * ε)) * Πstar_val^(-ε)
    mc_val = (1 - β * θp * Πbar^((1 - χ) * ε)) / (1 - β * θp * Πbar^(-(1 - ε) * (1 - χ))) * (ε - 1) / ε * Πstar_val
    w_val = (1 - α) * (mc_val * (α / γ1)^α)^(1 / (1 - α))
    k_val = α / (1 - α) * w_val / γ1 * μ_z_val * μ_I_val
    yd_val = (exp(ΛA) / μ_z_val * k_val^α - ϕ) / vp_val
    x_val = (μ_z_val * μ_I_val - (1 - δ)) / (μ_z_val * μ_I_val) * k_val
    c_val = (1 - g_bar) * yd_val - x_val
    λ_val = (1 - h * β / μ_z_val) / (1 - h / μ_z_val) / c_val
    ψ = w_val * λ_val
    g1_val = λ_val * yd_val / (1 - β * θp * Πbar^(-(1 - ε) * (1 - χ))) * (ε - 1) / ε * Πstar_val
    g2_val = λ_val * yd_val / (1 - β * θp * Πbar^(-(1 - ε) * (1 - χ))) * Πstar_val

    x_sym = [c_m, x_m, Π_m, w_m, R_m, yd_m, vp_m, k, d, φ, μ_I, μ_A, mshock, g]
    y_sym = [c, x, Π, w, R, yd, vp, Πstar, u, q, λ, μ_z, r, l, mc, g1, g2, ob_μz, ob_Π, ob_R, ob_dw, ob_dy, ob_l, ob_μ]
    p = [β, h, ϑ, κ, χ, γR, γΠ, Πbar, ρd, ρφ, ρg, g_bar, σ_A, σ_d, σ_φ, σ_μ, σ_m, σ_g, Λμ, ΛA]
    p_f = [δ, ε, ϕ, γ2, Ω_ii, α, θp, γy]

    H = [
         # Household Problem
         d * (c - h * c_m * μ_z^(-1))^(-1) - h * β * d_p * (c_p * μ_z_p - h * c)^(-1) - λ,
         ψ * φ * l^ϑ - w * λ, λ - β * λ_p * μ_z_p^(-1) * R / Π_p, γ1 + γ2 * (u - 1) - r,
         q -
         β * λ_p / λ / μ_z_p / μ_I_p *
         ((1 - δ) * q_p + r_p * u_p - (γ1 * (u_p - 1) + γ2 / 2 * (u_p - 1)^2)),
         q *
         (1 - (κ / 2 * (x / x_m * μ_z - Λx)^2) - (κ * (x / x_m * μ_z - Λx) * x / x_m * μ_z)) +
         β * q_p * λ_p / λ / μ_z_p * κ * (x_p / x * μ_z_p - Λx) * (x_p / x * μ_z_p)^2 - 1,

         # Firm Problem
         λ * mc * yd + β * θp * (Π^χ / Π_p)^(-ε) * g1_p - g1,
         λ * Πstar * yd + β * θp * (Π^χ / Π_p)^(1 - ε) * Πstar / Πstar_p * g2_p - g2,
         ε * g1 - (ε - 1) * g2, u * k / l - α / (1 - α) * w / r * μ_z * μ_I,
         (1 / (1 - α))^(1 - α) * (1 / α)^α * w^(1 - α) * r^α - mc,

         # Price Evolution
         θp * (Π_m^χ / Π)^(1 - ε) + (1 - θp) * Πstar^(1 - ε) - 1,

         # Taylor Rule
         R / Rbar -
         (R_m / Rbar)^γR *
         ((Π / Πbar)^γΠ * ((yd / yd_m * μ_z) / exp(ΛYd))^γy)^(1 - γR) *
         mshock,

         # Market Clear
         c + x + g + μ_z^(-1) * μ_I^(-1) * (γ1 * (u - 1) + γ2 / 2 * (u - 1)^2) * k - yd,
         (μ_A / μ_z * (u * k)^α * l^(1 - α) - ϕ) / vp - yd,
         θp * (Π_m^χ / Π)^(-ε) * vp_m + (1 - θp) * Πstar^(-ε) - vp,
         k_p * μ_z * μ_I - (1 - δ) * k -
         μ_z * μ_I * (1 - κ / 2 * (x / x_m * μ_z - Λx)^2) * x,

         # Variable Mapping
         c - c_m_p, x - x_m_p, Π - Π_m_p, w - w_m_p, R - R_m_p, yd - yd_m_p, vp - vp_m_p,

         # Shock Evolution
         μ_z - μ_A^(1 / (1 - α)) * μ_I^(α / (1 - α)), log(d_p) - ρd * log(d),
         log(φ_p) - ρφ * log(φ), log(μ_I_p) - Λμ, log(μ_A_p) - ΛA, log(mshock_p) - 0,
         log(g_p) - ρg * log(g) - (1 - ρg) * log(g_bar * yd_val),

         # Observation equations Π, R, dw, dy, l, μ_I(-1)
         ob_μz - log(μ_z), ob_Π - log(Π), ob_R - log(R), ob_dw - (log(w) - log(w_m)),
         ob_dy - (log(yd) - log(yd_m)), ob_l - log(l), ob_μ - log(μ_I)]

    x̄ = [c_m_ss ~ c_val, x_m_ss ~ x_val, Π_m_ss ~ Πbar, w_m_ss ~ w_val, R_m_ss ~ Rbar,
          yd_m_ss ~ yd_val, vp_m_ss ~ vp_val, k_ss ~ k_val, d_ss ~ 1.0, φ_ss ~ 1.0,
          μ_I_ss ~ exp(Λμ), μ_A_ss ~ exp(ΛA), mshock_ss ~ 1.0, g_ss ~ g_bar * yd_val]
    ȳ = [c_ss ~ c_val, x_ss ~ x_val, Π_ss ~ Πbar, w_ss ~ w_val, R_ss ~ Rbar,
          yd_ss ~ yd_val, vp_ss ~ vp_val, Πstar_ss ~ Πstar_val, u_ss ~ 1.0, q_ss ~ 1.0,
          λ_ss ~ λ_val, μ_z_ss ~ exp(ΛYd), r_ss ~ γ1, l_ss ~ 1.0, mc_ss ~ mc_val,
          g1_ss ~ g1_val, g2_ss ~ g2_val, ob_μz_ss ~ ΛYd, ob_Π_ss ~ log(Πbar),
          ob_R_ss ~ log(Rbar), ob_dw_ss ~ 0.0, ob_dy_ss ~ 0.0, ob_l_ss ~ 0.0, ob_μ_ss ~ Λμ]

    # x̄_iv = deepcopy(x̄)
    # ȳ_iv = deepcopy(ȳ)

    n_ϵ = 6
    n_x = length(x_sym)
    n_y = length(y_sym)
    n_z = 6
    Γ = zeros(typeof(σ_d), n_ϵ, n_ϵ) # Make sure it is not a float64 matrix
    Γ[1, 1] = σ_d
    Γ[2, 2] = σ_φ
    Γ[3, 3] = σ_μ
    Γ[4, 4] = σ_A
    Γ[5, 5] = σ_m
    Γ[6, 6] = σ_g
    η_mat = zeros(n_x, n_ϵ)
    # The 9-14 states are: d φ μ_I μ_A mshock g
    η_mat[9, 1] = 1
    η_mat[10, 2] = 1
    η_mat[11, 3] = 1
    η_mat[12, 4] = 1
    η_mat[13, 5] = 1
    η_mat[14, 6] = 1
    # Define Q
    Q = zeros(n_z, n_x + n_y)
    Q[:, (n_y - 5):n_y] = [1.0 0.0 0.0 0.0 0.0 0.0; 0.0 1.0 0.0 0.0 0.0 0.0; 0.0 0.0 1.0 0.0 0.0 0.0; 0.0 0.0 0.0 1.0 0.0 0.0; 0.0 0.0 0.0 0.0 1.0 0.0; 0.0 0.0 0.0 0.0 0.0 1.0]
    # Define Ω
    Ω = fill(Ω_ii, n_z)

    return H,
           (x = x_sym, y = y_sym, x̄ = x̄, ȳ = ȳ, Γ = Γ, η = η_mat, p = p, p_f = p_f,
            x̄_iv = nothing, ȳ_iv = nothing, Q = Q, Ω = Ω), "FVGQ20"

end
