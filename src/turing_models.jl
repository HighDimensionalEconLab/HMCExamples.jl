
    @model function rbc_kalman(z, m, p_f, α_prior, β_prior, ρ_prior, cache)
        α ~ truncated(Normal(α_prior[1], α_prior[2]), α_prior[3], α_prior[4])
        β_draw ~ Gamma(β_prior[1], β_prior[2])
        ρ ~ Beta(ρ_prior[1], ρ_prior[2])
        β = 1 / (β_draw / 100 + 1)
        p = [α, β, ρ]
        sol = generate_perturbation(m, p; p_f, cache)
        if !(sol.retcode == :Success)
            Turing.@addlogprob! -Inf
            return
        end
        Turing.@addlogprob! solve(sol, sol.x_ergodic, (0, length(z)); observables = z).logpdf
    end
    

    @model function rbc_joint(z, m, p_f, α_prior, β_prior, ρ_prior, cache, x0 = zeros(m.n_x))
        α ~ truncated(Normal(α_prior[1], α_prior[2]), α_prior[3], α_prior[4])
        β_draw ~ Gamma(β_prior[1], β_prior[2])
        ρ ~ Beta(ρ_prior[1], ρ_prior[2])
        β = 1 / (β_draw / 100 + 1)
        p = [α, β, ρ]
        T = length(z)
        ϵ_draw ~ MvNormal(m.n_ϵ * T, 1.0)
        ϵ = map(i -> ϵ_draw[((i - 1) * m.n_ϵ + 1):(i * m.n_ϵ)], 1:T)
        sol = generate_perturbation(m, p; p_f, cache)
        if !(sol.retcode == :Success)
            Turing.@addlogprob! -Inf
            return
        end
        Turing.@addlogprob! solve(sol, x0, (0, T); noise = ϵ, observables = z).logpdf
    end
    