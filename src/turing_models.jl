function Beta_tr(mu, sd)
    a = ((1 - mu) / sd ^ 2 - 1 / mu) * mu ^ 2 
    b = a * (1 / mu - 1)
    return a, b
end

function Gamma_tr(mu, sd)
    b = sd ^ 2 / mu
    a = mu / b
    return a, b
end

function InvGamma_tr(mu, sd)
    a = mu ^ 2 / sd ^ 2 + 2
    b = mu * (a - 1)
    return a, b
end

    
@model function rbc_kalman(z, m, p_f, α_prior, β_prior, ρ_prior, cache, settings)
    α ~ truncated(Normal(α_prior[1], α_prior[2]), α_prior[3], α_prior[4])
    β_draw ~ Gamma(β_prior[1], β_prior[2])
    ρ ~ Beta(ρ_prior[1], ρ_prior[2])
    β = 1 / (β_draw / 100 + 1)
    p = [α, β, ρ]
    (settings.print_level > 0) && @show p
    sol = generate_perturbation(m, p; p_f, cache, settings)
    if !(sol.retcode == :Success)
        Turing.@addlogprob! -Inf
        return
    end
    Turing.@addlogprob! solve(sol, sol.x_ergodic, (0, length(z)); observables = z).logpdf
end


@model function rbc_joint(z, m, p_f, α_prior, β_prior, ρ_prior, cache, settings, x0 = zeros(m.n_x))
    α ~ truncated(Normal(α_prior[1], α_prior[2]), α_prior[3], α_prior[4])
    β_draw ~ Gamma(β_prior[1], β_prior[2])
    ρ ~ Beta(ρ_prior[1], ρ_prior[2])
    β = 1 / (β_draw / 100 + 1)
    p = [α, β, ρ]
    (settings.print_level > 0) && @show p
    T = length(z)
    ϵ_draw ~ MvNormal(m.n_ϵ * T, 1.0)
    ϵ = map(i -> ϵ_draw[((i - 1) * m.n_ϵ + 1):(i * m.n_ϵ)], 1:T)
    sol = generate_perturbation(m, p; p_f, cache, settings)
    if !(sol.retcode == :Success)
        Turing.@addlogprob! -Inf
        return
    end
    Turing.@addlogprob! solve(sol, x0, (0, T); noise = ϵ, observables = z).logpdf
end



@model function rbc_second(z, m, p_f, α_prior, β_prior, ρ_prior, cache, settings, x0 = zeros(m.n_x))
    α ~ truncated(Normal(α_prior[1], α_prior[2]), α_prior[3], α_prior[4])
    β_draw ~ Gamma(β_prior[1], β_prior[2])
    ρ ~ Beta(ρ_prior[1], ρ_prior[2])
    β = 1 / (β_draw / 100 + 1)
    p = [α, β, ρ]
    (settings.print_level > 0) && @show p

    T = length(z)
    ϵ_draw ~ MvNormal(m.n_ϵ * T, 1.0)
    ϵ = map(i -> ϵ_draw[((i - 1) * m.n_ϵ + 1):(i * m.n_ϵ)], 1:T)
    sol = generate_perturbation(m, p; p_f, cache, settings)
    if !(sol.retcode == :Success)
        Turing.@addlogprob! -Inf
        return
    end
    Turing.@addlogprob! solve(sol, x0, (0, T); noise = ϵ, observables = z).logpdf

end


@model function FVGQ20_kalman(z, m, p_f, params, cache, settings)
    # Priors
    β_draw ~ Gamma(params.β[1], params.β[2])
    β = 1 / (β_draw / 100 + 1)
    h ~ Beta(params.h[1], params.h[2])
    ϑ = 1.0
    κ ~ truncated(Normal(params.κ[1], params.κ[2]), params.κ[3], params.κ[4])
    α ~ truncated(Normal(params.α[1], params.α[2]), params.α[3], params.α[4])
    θp ~ Beta(params.θp[1], params.θp[2])
    χ ~ Beta(params.χ[1], params.χ[2])
    γR ~ Beta(params.γR[1], params.γR[2])
    γy ~ truncated(Normal(params.γy[1], params.γy[2]), params.γy[3], params.γy[4])
    γΠ ~ truncated(Normal(params.γΠ[1], params.γΠ[2]), params.γΠ[3], params.γΠ[4])
    Πbar_draw ~ Gamma(params.Πbar[1], params.Πbar[2])
    Πbar = Πbar_draw / 100 + 1
    ρd ~ Beta(params.ρd[1], params.ρd[2])
    ρφ ~ Beta(params.ρφ[1], params.ρφ[2])
    ρg ~ Beta(params.ρg[1], params.ρg[2])
    g_bar ~ Beta(params.g_bar[1], params.g_bar[2])
    σ_A ~ InverseGamma(params.σ_A[1], params.σ_A[2])
    σ_d ~ InverseGamma(params.σ_d[1], params.σ_d[2])
    σ_φ ~ InverseGamma(params.σ_φ[1], params.σ_φ[2])
    σ_μ ~ InverseGamma(params.σ_μ[1], params.σ_μ[2])
    σ_m ~ InverseGamma(params.σ_m[1], params.σ_m[2])
    σ_g ~ InverseGamma(params.σ_g[1], params.σ_g[2])
    Λμ ~ Gamma(params.Λμ[1], params.Λμ[2])
    ΛA ~ Gamma(params.ΛA[1], params.ΛA[2])
    # Likelihood
    θ = [β, h, ϑ, κ, α, θp, χ, γR, γy, γΠ, Πbar, ρd, ρφ, ρg, g_bar, σ_A, σ_d, σ_φ, σ_μ, σ_m, σ_g, Λμ, ΛA]
    (settings.print_level > 0) && @show θ
    #sol = generate_perturbation(m, θ; p_f, cache, settings)
    sol = generate_perturbation(m, θ; p_f, settings)  # NOT REUSING CACHE AS A TEST
    if !(sol.retcode == :Success)
        Turing.@addlogprob! -Inf
    else
        z_trend = params.Hx * sol.x + params.Hy * sol.y
        z_detrended = map(i -> z[i] - z_trend, eachindex(z))
        Turing.@addlogprob! solve(sol, sol.x_ergodic, (0, length(z_detrended)); observables = z_detrended).logpdf
    end
end

# Joint likelihood
@model function FVGQ20_joint(z, m, p_f, params, cache, settings, x0 = zeros(m.n_x))
    T = length(z)
    # Priors
    β_draw ~ Gamma(params.β[1], params.β[2])
    β = 1 / (β_draw / 100 + 1)
    h ~ Beta(params.h[1], params.h[2])
    ϑ = 1.0
    κ ~ truncated(Normal(params.κ[1], params.κ[2]), params.κ[3], params.κ[4])
    α ~ truncated(Normal(params.α[1], params.α[2]), params.α[3], params.α[4])
    θp ~ Beta(params.θp[1], params.θp[2])
    χ ~ Beta(params.χ[1], params.χ[2])
    γR ~ Beta(params.γR[1], params.γR[2])
    γy ~ truncated(Normal(params.γy[1], params.γy[2]), params.γy[3], params.γy[4])
    γΠ ~ truncated(Normal(params.γΠ[1], params.γΠ[2]), params.γΠ[3], params.γΠ[4])
    Πbar_draw ~ Gamma(params.Πbar[1], params.Πbar[2])
    Πbar = Πbar_draw / 100 + 1
    ρd ~ Beta(params.ρd[1], params.ρd[2])
    ρφ ~ Beta(params.ρφ[1], params.ρφ[2])
    ρg ~ Beta(params.ρg[1], params.ρg[2])
    g_bar ~ Beta(params.g_bar[1], params.g_bar[2])
    σ_A ~ InverseGamma(params.σ_A[1], params.σ_A[2])
    σ_d ~ InverseGamma(params.σ_d[1], params.σ_d[2])
    σ_φ ~ InverseGamma(params.σ_φ[1], params.σ_φ[2])
    σ_μ ~ InverseGamma(params.σ_μ[1], params.σ_μ[2])
    σ_m ~ InverseGamma(params.σ_m[1], params.σ_m[2])
    σ_g ~ InverseGamma(params.σ_g[1], params.σ_g[2])
    Λμ ~ Gamma(params.Λμ[1], params.Λμ[2])
    ΛA ~ Gamma(params.ΛA[1], params.ΛA[2])
    ϵ_draw ~ MvNormal(m.n_ϵ * T, 1.0)
    ϵ = map(i -> ϵ_draw[((i-1)*m.n_ϵ+1):(i*m.n_ϵ)], 1:T)
    # Likelihood
    θ = [
        β,
        h,
        ϑ,
        κ,
        α,
        θp,
        χ,
        γR,
        γy,
        γΠ,
        Πbar,
        ρd,
        ρφ,
        ρg,
        g_bar,
        σ_A,
        σ_d,
        σ_φ,
        σ_μ,
        σ_m,
        σ_g,
        Λμ,
        ΛA,
    ]
    (settings.print_level > 0) && @show θ
    sol = generate_perturbation(m, θ; p_f, cache, settings)
    if !(sol.retcode == :Success)
        Turing.@addlogprob! -Inf
        return
    end
    z_trend = params.Hx * sol.x + params.Hy * sol.y
    z_detrended = map(i -> z[i] - z_trend, eachindex(z))
    Turing.@addlogprob! solve(sol, x0, (0, T); noise = ϵ, observables = z_detrended).logpdf
end
