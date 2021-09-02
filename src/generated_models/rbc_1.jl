module rbc_1
using SparseArrays, LinearAlgebra, DifferentiableStateSpaceModels, LaTeXStrings, ModelingToolkit
const n_y = 3
const n_x = 2
const n = 5
const n_p = 3
const n_ϵ = 1
const n_z = 2
const functions_type() = DenseFunctions()
const η = reshape([0; -1], 2, 1)
const Q = [1.0 0.0 0.0 0.0 0.0; 0.0 0.0 1.0 0.0 0.0]
const Γ! = (var"##MTIIPVar#366", var"##MTKArg#362", var"##MTKArg#363", var"##MTKArg#364")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#362"[1], var"##MTKArg#362"[2], var"##MTKArg#362"[3], var"##MTKArg#363"[1], var"##MTKArg#363"[2], var"##MTKArg#363"[3])
                    var"##MTIIPVar#366"[1] = σ
                end
            end
        nothing
    end
const Γ_p! = (var"##MTIIPVar#373", var"##MTKArg#369", var"##MTKArg#370", var"##MTKArg#371")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#369"[1], var"##MTKArg#369"[2], var"##MTKArg#369"[3], var"##MTKArg#370"[1], var"##MTKArg#370"[2], var"##MTKArg#370"[3])
                end
            end
        nothing
    end
const Ω! = (var"##MTIIPVar#380", var"##MTKArg#376", var"##MTKArg#377", var"##MTKArg#378")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#376"[1], var"##MTKArg#376"[2], var"##MTKArg#376"[3], var"##MTKArg#377"[1], var"##MTKArg#377"[2], var"##MTKArg#377"[3])
                    var"##MTIIPVar#380"[1] = Ω_1
                    var"##MTIIPVar#380"[2] = Ω_1
                end
            end
        nothing
    end
const Ω_p! = (var"##MTIIPVar#387", var"##MTKArg#383", var"##MTKArg#384", var"##MTKArg#385")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#383"[1], var"##MTKArg#383"[2], var"##MTKArg#383"[3], var"##MTKArg#384"[1], var"##MTKArg#384"[2], var"##MTKArg#384"[3])
                end
            end
        nothing
    end
const H! = (var"##MTIIPVar#400", var"##MTKArg#390", var"##MTKArg#391", var"##MTKArg#392", var"##MTKArg#393", var"##MTKArg#394", var"##MTKArg#395", var"##MTKArg#396", var"##MTKArg#397", var"##MTKArg#398")->begin
        @inbounds begin
                let (c_p, q_p, i_p, c, q, i, c_ss, q_ss, i_ss, k_p, z_p, k, z, k_ss, z_ss, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#390"[1], var"##MTKArg#390"[2], var"##MTKArg#390"[3], var"##MTKArg#391"[1], var"##MTKArg#391"[2], var"##MTKArg#391"[3], var"##MTKArg#392"[1], var"##MTKArg#392"[2], var"##MTKArg#392"[3], var"##MTKArg#393"[1], var"##MTKArg#393"[2], var"##MTKArg#394"[1], var"##MTKArg#394"[2], var"##MTKArg#395"[1], var"##MTKArg#395"[2], var"##MTKArg#396"[1], var"##MTKArg#396"[2], var"##MTKArg#396"[3], var"##MTKArg#397"[1], var"##MTKArg#397"[2], var"##MTKArg#397"[3])
                    var"##MTIIPVar#400"[1] = (-)((/)(1, c), (*)((/)(β, c_p), (+)((*)((*)(α, (exp)(z_p)), (^)(k_p, (-)(α, 1))), (-)(1, δ))))
                    var"##MTIIPVar#400"[2] = (-)((-)((+)(c, k_p), (*)((-)(1, δ), k)), q)
                    var"##MTIIPVar#400"[3] = (-)(q, (*)((exp)(z), (^)(k, α)))
                    var"##MTIIPVar#400"[4] = (-)(z_p, (*)(ρ, z))
                    var"##MTIIPVar#400"[5] = (-)(i, (-)(k_p, (*)((-)(1, δ), k)))
                end
            end
        nothing
    end
const H_yp! = (var"##MTIIPVar#409", var"##MTKArg#403", var"##MTKArg#404", var"##MTKArg#405", var"##MTKArg#406", var"##MTKArg#407")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#403"[1], var"##MTKArg#403"[2], var"##MTKArg#403"[3], var"##MTKArg#404"[1], var"##MTKArg#404"[2], var"##MTKArg#405"[1], var"##MTKArg#405"[2], var"##MTKArg#405"[3], var"##MTKArg#406"[1], var"##MTKArg#406"[2], var"##MTKArg#406"[3])
                    var"##MTIIPVar#409"[1] = (*)((+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 2), β)
                end
            end
        nothing
    end
const H_y! = (var"##MTIIPVar#418", var"##MTKArg#412", var"##MTKArg#413", var"##MTKArg#414", var"##MTKArg#415", var"##MTKArg#416")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#412"[1], var"##MTKArg#412"[2], var"##MTKArg#412"[3], var"##MTKArg#413"[1], var"##MTKArg#413"[2], var"##MTKArg#414"[1], var"##MTKArg#414"[2], var"##MTKArg#414"[3], var"##MTKArg#415"[1], var"##MTKArg#415"[2], var"##MTKArg#415"[3])
                    var"##MTIIPVar#418"[1] = (*)(-1, (^)((inv)(c), 2))
                    var"##MTIIPVar#418"[2] = 1
                    var"##MTIIPVar#418"[7] = -1
                    var"##MTIIPVar#418"[8] = 1
                    var"##MTIIPVar#418"[15] = 1
                end
            end
        nothing
    end
const H_xp! = (var"##MTIIPVar#427", var"##MTKArg#421", var"##MTKArg#422", var"##MTKArg#423", var"##MTKArg#424", var"##MTKArg#425")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#421"[1], var"##MTKArg#421"[2], var"##MTKArg#421"[3], var"##MTKArg#422"[1], var"##MTKArg#422"[2], var"##MTKArg#423"[1], var"##MTKArg#423"[2], var"##MTKArg#423"[3], var"##MTKArg#424"[1], var"##MTKArg#424"[2], var"##MTKArg#424"[3])
                    var"##MTIIPVar#427"[1] = (*)((*)((*)((*)(-1, (exp)(z)), (^)((inv)(c), 1)), α), (*)((*)(β, (^)(k, (+)(-2, α))), (+)(-1, α)))
                    var"##MTIIPVar#427"[2] = 1
                    var"##MTIIPVar#427"[5] = -1
                    var"##MTIIPVar#427"[6] = (*)((*)((*)((*)(-1, (exp)(z)), (^)((inv)(c), 1)), α), (*)(β, (^)(k, (+)(-1, α))))
                    var"##MTIIPVar#427"[9] = 1
                end
            end
        nothing
    end
const H_x! = (var"##MTIIPVar#436", var"##MTKArg#430", var"##MTKArg#431", var"##MTKArg#432", var"##MTKArg#433", var"##MTKArg#434")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#430"[1], var"##MTKArg#430"[2], var"##MTKArg#430"[3], var"##MTKArg#431"[1], var"##MTKArg#431"[2], var"##MTKArg#432"[1], var"##MTKArg#432"[2], var"##MTKArg#432"[3], var"##MTKArg#433"[1], var"##MTKArg#433"[2], var"##MTKArg#433"[3])
                    var"##MTIIPVar#436"[2] = (*)(-1, (+)(1, (*)(-1, δ)))
                    var"##MTIIPVar#436"[3] = (*)(-1, (exp)(z), α, (^)(k, (+)(-1, α)))
                    var"##MTIIPVar#436"[5] = (+)(1, (*)(-1, δ))
                    var"##MTIIPVar#436"[8] = (*)(-1, (exp)(z), (^)(k, α))
                    var"##MTIIPVar#436"[9] = (*)(-1, ρ)
                end
            end
        nothing
    end
const H_yp_p! = (var"##MTIIPVar#445", var"##MTKArg#439", var"##MTKArg#440", var"##MTKArg#441", var"##MTKArg#442", var"##MTKArg#443")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#439"[1], var"##MTKArg#439"[2], var"##MTKArg#439"[3], var"##MTKArg#440"[1], var"##MTKArg#440"[2], var"##MTKArg#441"[1], var"##MTKArg#441"[2], var"##MTKArg#441"[3], var"##MTKArg#442"[1], var"##MTKArg#442"[2], var"##MTKArg#442"[3])
                    (var"##MTIIPVar#445"[1])[1] = (*)((^)((inv)(c), 2), β, (+)((*)((exp)(z), (^)(k, (+)(-1, α))), (*)((log)(k), (exp)(z), α, (^)(k, (+)(-1, α)))))
                    (var"##MTIIPVar#445"[2])[1] = (*)((+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 2))
                end
            end
        nothing
    end
const H_y_p! = (var"##MTIIPVar#454", var"##MTKArg#448", var"##MTKArg#449", var"##MTKArg#450", var"##MTKArg#451", var"##MTKArg#452")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#448"[1], var"##MTKArg#448"[2], var"##MTKArg#448"[3], var"##MTKArg#449"[1], var"##MTKArg#449"[2], var"##MTKArg#450"[1], var"##MTKArg#450"[2], var"##MTKArg#450"[3], var"##MTKArg#451"[1], var"##MTKArg#451"[2], var"##MTKArg#451"[3])
                end
            end
        nothing
    end
const H_xp_p! = (var"##MTIIPVar#463", var"##MTKArg#457", var"##MTKArg#458", var"##MTKArg#459", var"##MTKArg#460", var"##MTKArg#461")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#457"[1], var"##MTKArg#457"[2], var"##MTKArg#457"[3], var"##MTKArg#458"[1], var"##MTKArg#458"[2], var"##MTKArg#459"[1], var"##MTKArg#459"[2], var"##MTKArg#459"[3], var"##MTKArg#460"[1], var"##MTKArg#460"[2], var"##MTKArg#460"[3])
                    (var"##MTIIPVar#463"[1])[1] = (+)((*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-2, α))), (*)(-1, (exp)(z), (^)((inv)(c), 1), β, (^)(k, (+)(-2, α)), (+)(-1, α)), (*)(-1, (log)(k), (exp)(z), (^)((inv)(c), 1), α, (+)(-1, α), β, (^)(k, (+)(-2, α))))
                    (var"##MTIIPVar#463"[1])[6] = (+)((*)(-1, (exp)(z), (^)((inv)(c), 1), β, (^)(k, (+)(-1, α))), (*)(-1, (log)(k), (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-1, α))))
                    (var"##MTIIPVar#463"[2])[1] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#463"[2])[6] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (^)(k, (+)(-1, α)))
                end
            end
        nothing
    end
const H_x_p! = (var"##MTIIPVar#472", var"##MTKArg#466", var"##MTKArg#467", var"##MTKArg#468", var"##MTKArg#469", var"##MTKArg#470")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#466"[1], var"##MTKArg#466"[2], var"##MTKArg#466"[3], var"##MTKArg#467"[1], var"##MTKArg#467"[2], var"##MTKArg#468"[1], var"##MTKArg#468"[2], var"##MTKArg#468"[3], var"##MTKArg#469"[1], var"##MTKArg#469"[2], var"##MTKArg#469"[3])
                    (var"##MTIIPVar#472"[1])[3] = (+)((*)(-1, (exp)(z), (^)(k, (+)(-1, α))), (*)(-1, (log)(k), (exp)(z), α, (^)(k, (+)(-1, α))))
                    (var"##MTIIPVar#472"[1])[8] = (*)(-1, (log)(k), (exp)(z), (^)(k, α))
                    (var"##MTIIPVar#472"[3])[9] = -1
                end
            end
        nothing
    end
const H_p! = (var"##MTIIPVar#481", var"##MTKArg#475", var"##MTKArg#476", var"##MTKArg#477", var"##MTKArg#478", var"##MTKArg#479")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#475"[1], var"##MTKArg#475"[2], var"##MTKArg#475"[3], var"##MTKArg#476"[1], var"##MTKArg#476"[2], var"##MTKArg#477"[1], var"##MTKArg#477"[2], var"##MTKArg#477"[3], var"##MTKArg#478"[1], var"##MTKArg#478"[2], var"##MTKArg#478"[3])
                    var"##MTIIPVar#481"[1] = (*)(-1, (^)((inv)(c), 1), β, (+)((*)((exp)(z), (^)(k, (+)(-1, α))), (*)((log)(k), (exp)(z), α, (^)(k, (+)(-1, α)))))
                    var"##MTIIPVar#481"[3] = (*)(-1, (log)(k), (exp)(z), (^)(k, α))
                    var"##MTIIPVar#481"[6] = (*)(-1, (+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 1))
                    var"##MTIIPVar#481"[14] = (*)(-1, z)
                end
            end
        nothing
    end
const Ψ! = (var"##MTIIPVar#490", var"##MTKArg#484", var"##MTKArg#485", var"##MTKArg#486", var"##MTKArg#487", var"##MTKArg#488")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#484"[1], var"##MTKArg#484"[2], var"##MTKArg#484"[3], var"##MTKArg#485"[1], var"##MTKArg#485"[2], var"##MTKArg#486"[1], var"##MTKArg#486"[2], var"##MTKArg#486"[3], var"##MTKArg#487"[1], var"##MTKArg#487"[2], var"##MTKArg#487"[3])
                    (var"##MTIIPVar#490"[1])[1] = (*)(-2, (+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 3), β)
                    (var"##MTIIPVar#490"[1])[7] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#490"[1])[8] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-1, α)))
                    (var"##MTIIPVar#490"[1])[34] = (*)(2, (^)((inv)(c), 3))
                    (var"##MTIIPVar#490"[1])[61] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#490"[1])[67] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (+)(-1, α), β, (^)(k, (+)(-3, α)), (+)(-2, α))
                    (var"##MTIIPVar#490"[1])[68] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#490"[1])[71] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-1, α)))
                    (var"##MTIIPVar#490"[1])[77] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#490"[1])[78] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-1, α)))
                    (var"##MTIIPVar#490"[3])[89] = (*)(-1, (exp)(z), α, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#490"[3])[90] = (*)(-1, (exp)(z), α, (^)(k, (+)(-1, α)))
                    (var"##MTIIPVar#490"[3])[99] = (*)(-1, (exp)(z), α, (^)(k, (+)(-1, α)))
                    (var"##MTIIPVar#490"[3])[100] = (*)(-1, (exp)(z), (^)(k, α))
                end
            end
        nothing
    end
const H̄! = (var"##MTIIPVar#498", var"##MTKArg#493", var"##MTKArg#494", var"##MTKArg#495", var"##MTKArg#496")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#493"[1], var"##MTKArg#493"[2], var"##MTKArg#493"[3], var"##MTKArg#493"[4], var"##MTKArg#493"[5], var"##MTKArg#494"[1], var"##MTKArg#494"[2], var"##MTKArg#494"[3], var"##MTKArg#495"[1], var"##MTKArg#495"[2], var"##MTKArg#495"[3])
                    var"##MTIIPVar#498"[1] = (+)((^)((inv)(c), 1), (*)(-1, (+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 1), β))
                    var"##MTIIPVar#498"[2] = (+)(c, k, (*)(-1, (+)(q, (*)(k, (+)(1, (*)(-1, δ))))))
                    var"##MTIIPVar#498"[3] = (+)((*)(-1, (exp)(z), (^)(k, α)), q)
                    var"##MTIIPVar#498"[4] = (+)((*)(-1, z, ρ), z)
                    var"##MTIIPVar#498"[5] = (+)(i, (*)(-1, (+)((*)(-1, k, (+)(1, (*)(-1, δ))), k)))
                end
            end
        nothing
    end
const H̄_w! = (var"##MTIIPVar#506", var"##MTKArg#501", var"##MTKArg#502", var"##MTKArg#503", var"##MTKArg#504")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#501"[1], var"##MTKArg#501"[2], var"##MTKArg#501"[3], var"##MTKArg#501"[4], var"##MTKArg#501"[5], var"##MTKArg#502"[1], var"##MTKArg#502"[2], var"##MTKArg#502"[3], var"##MTKArg#503"[1], var"##MTKArg#503"[2], var"##MTKArg#503"[3])
                    var"##MTIIPVar#506"[1] = (+)((*)(-1, (^)((inv)(c), 2)), (*)((+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 2), β))
                    var"##MTIIPVar#506"[2] = 1
                    var"##MTIIPVar#506"[7] = -1
                    var"##MTIIPVar#506"[8] = 1
                    var"##MTIIPVar#506"[15] = 1
                    var"##MTIIPVar#506"[16] = (*)((*)((*)((*)(-1, (exp)(z)), (^)((inv)(c), 1)), α), (*)((*)(β, (^)(k, (+)(-2, α))), (+)(-1, α)))
                    var"##MTIIPVar#506"[17] = (+)(1, (*)(-1, (+)(1, (*)(-1, δ))))
                    var"##MTIIPVar#506"[18] = (*)(-1, (exp)(z), α, (^)(k, (+)(-1, α)))
                    var"##MTIIPVar#506"[20] = (*)(-1, (+)(1, (*)(-1, (+)(1, (*)(-1, δ)))))
                    var"##MTIIPVar#506"[21] = (*)((*)((*)((*)(-1, (exp)(z)), (^)((inv)(c), 1)), α), (*)(β, (^)(k, (+)(-1, α))))
                    var"##MTIIPVar#506"[23] = (*)(-1, (exp)(z), (^)(k, α))
                    var"##MTIIPVar#506"[24] = (+)(1, (*)(-1, ρ))
                end
            end
        nothing
    end
const ȳ_iv! = (var"##MTIIPVar#513", var"##MTKArg#509", var"##MTKArg#510", var"##MTKArg#511")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#509"[1], var"##MTKArg#509"[2], var"##MTKArg#509"[3], var"##MTKArg#510"[1], var"##MTKArg#510"[2], var"##MTKArg#510"[3])
                    var"##MTIIPVar#513"[1] = (-)((^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(α, (-)(α, 1))), (*)(δ, (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1)))))
                    var"##MTIIPVar#513"[2] = (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(α, (-)(α, 1)))
                    var"##MTIIPVar#513"[3] = (*)(δ, (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1))))
                end
            end
        nothing
    end
const x̄_iv! = (var"##MTIIPVar#520", var"##MTKArg#516", var"##MTKArg#517", var"##MTKArg#518")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#516"[1], var"##MTKArg#516"[2], var"##MTKArg#516"[3], var"##MTKArg#517"[1], var"##MTKArg#517"[2], var"##MTKArg#517"[3])
                    var"##MTIIPVar#520"[1] = (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1)))
                end
            end
        nothing
    end
const ȳ! = (var"##MTIIPVar#527", var"##MTKArg#523", var"##MTKArg#524", var"##MTKArg#525")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#523"[1], var"##MTKArg#523"[2], var"##MTKArg#523"[3], var"##MTKArg#524"[1], var"##MTKArg#524"[2], var"##MTKArg#524"[3])
                    var"##MTIIPVar#527"[1] = (-)((^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(α, (-)(α, 1))), (*)(δ, (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1)))))
                    var"##MTIIPVar#527"[2] = (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(α, (-)(α, 1)))
                    var"##MTIIPVar#527"[3] = (*)(δ, (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1))))
                end
            end
        nothing
    end
const x̄! = (var"##MTIIPVar#534", var"##MTKArg#530", var"##MTKArg#531", var"##MTKArg#532")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#530"[1], var"##MTKArg#530"[2], var"##MTKArg#530"[3], var"##MTKArg#531"[1], var"##MTKArg#531"[2], var"##MTKArg#531"[3])
                    var"##MTIIPVar#534"[1] = (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1)))
                end
            end
        nothing
    end
const ȳ_p! = (var"##MTIIPVar#541", var"##MTKArg#537", var"##MTKArg#538", var"##MTKArg#539")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#537"[1], var"##MTKArg#537"[2], var"##MTKArg#537"[3], var"##MTKArg#538"[1], var"##MTKArg#538"[2], var"##MTKArg#538"[3])
                    var"##MTIIPVar#541"[1] = (+)((*)(-1, δ, (+)((*)(-1, (log)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1))), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (^)((inv)((+)(-1, α)), 1)), (^)((inv)((+)(-1, α)), 2)), (*)((*)((*)((*)(-1, (+)(-1, (^)((inv)(β), 1), δ)), (^)((inv)(α), 2)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1)))), (*)((log)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1))), (+)((^)((inv)((+)(-1, α)), 1), (*)(-1, α, (^)((inv)((+)(-1, α)), 2))), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (*)(α, (^)((inv)((+)(-1, α)), 1)))), (*)((*)((*)((*)(-1, (+)(-1, (^)((inv)(β), 1), δ)), (^)((inv)(α), 1)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (*)(α, (^)((inv)((+)(-1, α)), 1))))), (^)((inv)((+)(-1, α)), 1)))
                    var"##MTIIPVar#541"[2] = (+)((*)((log)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1))), (+)((^)((inv)((+)(-1, α)), 1), (*)(-1, α, (^)((inv)((+)(-1, α)), 2))), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (*)(α, (^)((inv)((+)(-1, α)), 1)))), (*)((*)((*)((*)(-1, (+)(-1, (^)((inv)(β), 1), δ)), (^)((inv)(α), 1)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (*)(α, (^)((inv)((+)(-1, α)), 1))))), (^)((inv)((+)(-1, α)), 1)))
                    var"##MTIIPVar#541"[3] = (*)(δ, (+)((*)(-1, (log)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1))), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (^)((inv)((+)(-1, α)), 1)), (^)((inv)((+)(-1, α)), 2)), (*)((*)((*)((*)(-1, (+)(-1, (^)((inv)(β), 1), δ)), (^)((inv)(α), 2)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1))))
                    var"##MTIIPVar#541"[4] = (+)((*)(-1, (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (*)(α, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1), (^)((inv)(β), 2)), (*)((*)((*)((*)((^)((inv)(α), 1), δ), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1)), (^)((inv)(β), 2)))
                    var"##MTIIPVar#541"[5] = (*)(-1, (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (*)(α, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1), (^)((inv)(β), 2))
                    var"##MTIIPVar#541"[6] = (*)((*)((*)((*)(-1, (^)((inv)(α), 1)), δ), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (*)((^)((inv)((+)(-1, α)), 1), (^)((inv)(β), 2)))
                end
            end
        nothing
    end
const x̄_p! = (var"##MTIIPVar#548", var"##MTKArg#544", var"##MTKArg#545", var"##MTKArg#546")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#544"[1], var"##MTKArg#544"[2], var"##MTKArg#544"[3], var"##MTKArg#545"[1], var"##MTKArg#545"[2], var"##MTKArg#545"[3])
                    var"##MTIIPVar#548"[1] = (+)((*)(-1, (log)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1))), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (^)((inv)((+)(-1, α)), 1)), (^)((inv)((+)(-1, α)), 2)), (*)((*)((*)((*)(-1, (+)(-1, (^)((inv)(β), 1), δ)), (^)((inv)(α), 2)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1)))
                    var"##MTIIPVar#548"[3] = (*)((*)((*)((*)(-1, (^)((inv)(α), 1)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1)), (^)((inv)(β), 2))
                end
            end
        nothing
    end
const steady_state! = nothing
const allocate_solver_cache = m->begin
        #= /home/cameron/.julia/dev/DifferentiableStateSpaceModels/src/mtk_constructor.jl:144 =#
        FirstOrderSolverCache(m)
    end
const select_p_ss_hash = LinearAlgebra.UniformScaling{Bool}(true)
const select_p_f_ss_hash = LinearAlgebra.UniformScaling{Bool}(true)
const select_p_perturbation_hash = LinearAlgebra.UniformScaling{Bool}(true)
const select_p_f_perturbation_hash = LinearAlgebra.UniformScaling{Bool}(true)
end
