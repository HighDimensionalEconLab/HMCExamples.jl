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
    p_d = (; α, β, ρ)
    (settings.print_level > 0) && @show p_d
    sol = generate_perturbation(m, p_d, p_f, Val(1); cache)
    (settings.print_level > 1) && println("Perturbation generated")

    if !(sol.retcode == :Success)
        (settings.print_level > 0) && println("Perturbation failed with retcode $(sol.retcode)")
        @addlogprob! -Inf
    else
        (settings.print_level > 1) && println("Calculating likelihood")
    
        # Simulate and get the likelihood.
        T = length(z)
        problem = LinearStateSpaceProblem(
            sol.A,
            sol.B,
            sol.C,
            sol.x_ergodic,
            (0,T),
            noise=sol.Q,
            obs_noise=sol.D,
            observables = z
        )

        simulation = solve(
            problem, 
            KalmanFilter(); 
            vectype=Zygote.Buffer
        )

        @addlogprob! simulation.likelihood
    end

    return
end

@model function rbc_joint(z, m, p_f, α_prior, β_prior, ρ_prior, cache::DifferentiableStateSpaceModels.AbstractSolverCache{Order}, settings, x0 = zeros(m.n_x)) where {Order}
    α ~ truncated(Normal(α_prior[1], α_prior[2]), α_prior[3], α_prior[4])
    β_draw ~ Gamma(β_prior[1], β_prior[2])
    ρ ~ Beta(ρ_prior[1], ρ_prior[2])
    β = 1 / (β_draw / 100 + 1)
    p_d = (; α, β, ρ)
    (settings.print_level > 0) && @show p_d
    T = length(z)
    ϵ_draw ~ MvNormal(m.n_ϵ * T, 1.0)
    ϵ = map(i -> ϵ_draw[((i - 1) * m.n_ϵ + 1):(i * m.n_ϵ)], 1:T)
    sol = generate_perturbation(m, p_d, p_f, Val(Order); cache)
    (settings.print_level > 1) && println("Perturbation generated")

    if !(sol.retcode == :Success)
        (settings.print_level > 0) && println("Perturbation failed with retcode $(sol.retcode)")
        @addlogprob! -Inf
    else
       (settings.print_level > 1) && println("Calculating likelihood")

        # Simulate and get the likelihood.
        problem = StateSpaceProblem(
            DifferentiableStateSpaceModels.dssm_evolution,
            DifferentiableStateSpaceModels.dssm_volatility,
            DifferentiableStateSpaceModels.dssm_observation,
            x0,
            (0,T),
            sol,
            noise=DefinedNoise(ϵ),
            obs_noise=sol.D,
            observables = z
        )

        simulation = solve(
            problem, 
            ConditionalGaussian(); 
            vectype=Zygote.Buffer
        )

        @addlogprob! simulation.likelihood
    end
   
    return
end

@model function rbc_second(z, m, p_f, α_prior, β_prior, ρ_prior, cache, settings, x0 = zeros(m.n_x))
    α ~ truncated(Normal(α_prior[1], α_prior[2]), α_prior[3], α_prior[4])
    β_draw ~ Gamma(β_prior[1], β_prior[2])
    ρ ~ Beta(ρ_prior[1], ρ_prior[2])
    β = 1 / (β_draw / 100 + 1)
    p_d = (; α, β, ρ)
    (settings.print_level > 0) && @show p_d
    T = length(z)
    ϵ_draw ~ MvNormal(m.n_ϵ * T, 1.0)
    ϵ = map(i -> ϵ_draw[((i - 1) * m.n_ϵ + 1):(i * m.n_ϵ)], 1:T)
    sol = generate_perturbation(m, p_d, p_f, Val(Order); cache)
    (settings.print_level > 1) && println("Perturbation generated")

    if !(sol.retcode == :Success)
        (settings.print_level > 0) && println("Perturbation failed with retcode $(sol.retcode)")
        @addlogprob! -Inf
    else
        (settings.print_level > 1) && println("Calculating likelihood")

        # Simulate and get the likelihood.
        problem = StateSpaceProblem(
            DifferentiableStateSpaceModels.dssm_evolution,
            DifferentiableStateSpaceModels.dssm_volatility,
            DifferentiableStateSpaceModels.dssm_observation,
            x0,
            (0,T),
            sol,
            noise=DefinedNoise(ϵ),
            obs_noise=sol.D,
            observables = z
        )

        simulation = solve(
            problem, 
            ConditionalGaussian(); 
            vectype=Zygote.Buffer
        )

        @addlogprob! simulation.likelihood
    end
    return
end

@model function FVGQ20_kalman(z, m, p_f, params, cache, settings)
    # Priors
    β_draw ~ Gamma(params.β[1], params.β[2])
    β = 1 / (β_draw / 100 + 1)
    h ~ Beta(params.h[1], params.h[2])
    κ ~ truncated(Normal(params.κ[1], params.κ[2]), params.κ[3], params.κ[4])
    χ ~ Beta(params.χ[1], params.χ[2])
    γR ~ Beta(params.γR[1], params.γR[2])
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
    θ = (; β, h, κ, χ, γR, γΠ, Πbar, ρd, ρφ, ρg, g_bar, σ_A, σ_d, σ_φ, σ_μ, σ_m, σ_g, Λμ, ΛA)
    (settings.print_level > 0) && @show θ
    sol = generate_perturbation(m, θ, p_f, Val(1); cache)
    (settings.print_level > 1) && println("Perturbation generated")
    if !(sol.retcode == :Success)
        (settings.print_level > 0) && println("Perturbation failed with retcode $(sol.retcode)")        
        @addlogprob! -Inf
    else
        z_trend = params.Hx * sol.x + params.Hy * sol.y
        z_detrended = map(i -> z[i] - z_trend, eachindex(z))
        (settings.print_level > 1) && println("Calculating likelihood")

        # Simulate and get the likelihood.
        T = length(z)
        problem = LinearStateSpaceProblem(
            sol.A,
            sol.B,
            sol.C,
            sol.x_ergodic,
            (0,T),
            noise=sol.Q,
            obs_noise=sol.D,
            observables = z_detrended
        )

        simulation = solve(
            problem, 
            KalmanFilter(); 
            vectype=Zygote.Buffer
        )
		
		@addlogprob! simulation.likelihood
    end
end

@model function FVGQ20_joint(z, m, p_f, params, cache, settings, x0 = zeros(m.n_x))
    T = length(z)
    # Priors
    β_draw ~ Gamma(params.β[1], params.β[2])
    β = 1 / (β_draw / 100 + 1)
    h ~ Beta(params.h[1], params.h[2])
    κ ~ truncated(Normal(params.κ[1], params.κ[2]), params.κ[3], params.κ[4])
    χ ~ Beta(params.χ[1], params.χ[2])
    γR ~ Beta(params.γR[1], params.γR[2])
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
    θ = (; β, h, κ, χ, γR, γΠ, Πbar, ρd, ρφ, ρg, g_bar, σ_A, σ_d, σ_φ, σ_μ, σ_m, σ_g, Λμ, ΛA)
    (settings.print_level > 0) && @show θ
    sol = generate_perturbation(m, θ, p_f, Val(1); cache)
    if !(sol.retcode == :Success)
        @addlogprob! -Inf
    else
        z_trend = params.Hx * sol.x + params.Hy * sol.y
        z_detrended = map(i -> z[i] - z_trend, eachindex(z))

        # Simulate and get the likelihood.
        problem = StateSpaceProblem(
            DifferentiableStateSpaceModels.dssm_evolution,
            DifferentiableStateSpaceModels.dssm_volatility,
            DifferentiableStateSpaceModels.dssm_observation,
            x0,
            (0,T),
            sol,
            noise=DefinedNoise(ϵ),
            obs_noise=sol.D,
            observables = z_detrended
        )

        simulation = solve(
            problem, 
            ConditionalGaussian(); 
            vectype=Zygote.Buffer
        )

        @addlogprob! simulation.likelihood
      end
      return
end

@model function FVGQ20_joint(z, m, p_f, params, cache::DifferentiableStateSpaceModels.AbstractSolverCache{Order}, settings, x0 = zeros(m.n_x)) where {Order}
    T = length(z)
    # Priors
    β_draw ~ Gamma(params.β[1], params.β[2])
    β = 1 / (β_draw / 100 + 1)
    h ~ Beta(params.h[1], params.h[2])
    κ ~ truncated(Normal(params.κ[1], params.κ[2]), params.κ[3], params.κ[4])
    χ ~ Beta(params.χ[1], params.χ[2])
    γR ~ Beta(params.γR[1], params.γR[2])
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
    θ = (; β, h, κ, χ, γR, γΠ, Πbar, ρd, ρφ, ρg, g_bar, σ_A, σ_d, σ_φ, σ_μ, σ_m, σ_g, Λμ, ΛA)
    (settings.print_level > 0) && @show θ
    sol = generate_perturbation(m, θ, p_f, Val(Order); cache)
    (settings.print_level > 1) && println("Perturbation generated")
    if !(sol.retcode == :Success)
        (settings.print_level > 0) && println("Perturbation failed with retcode $(sol.retcode)")
        @addlogprob! -Inf
    else
        z_trend = params.Hx * sol.x + params.Hy * sol.y
        z_detrended = map(i -> z[i] - z_trend, eachindex(z))

        # Simulate and get the likelihood.
        problem = StateSpaceProblem(
            DifferentiableStateSpaceModels.dssm_evolution,
            DifferentiableStateSpaceModels.dssm_volatility,
            DifferentiableStateSpaceModels.dssm_observation,
            x0,
            (0,T),
            sol,
            noise=DefinedNoise(ϵ),
            obs_noise=sol.D,
            observables = z_detrended
        )

        simulation = solve(
            problem, 
            ConditionalGaussian(); 
            vectype=Zygote.Buffer
        )

        @addlogprob! simulation.likelihood
    end
  
    return
end
