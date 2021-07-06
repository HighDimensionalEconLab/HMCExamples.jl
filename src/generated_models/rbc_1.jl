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
const Γ! = (var"##MTIIPVar#368", var"##MTKArg#364", var"##MTKArg#365", var"##MTKArg#366")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#364"[1], var"##MTKArg#364"[2], var"##MTKArg#364"[3], var"##MTKArg#365"[1], var"##MTKArg#365"[2], var"##MTKArg#365"[3])
                    var"##MTIIPVar#368"[1] = σ
                end
            end
        nothing
    end
const Γ_p! = (var"##MTIIPVar#375", var"##MTKArg#371", var"##MTKArg#372", var"##MTKArg#373")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#371"[1], var"##MTKArg#371"[2], var"##MTKArg#371"[3], var"##MTKArg#372"[1], var"##MTKArg#372"[2], var"##MTKArg#372"[3])
                end
            end
        nothing
    end
const Ω! = (var"##MTIIPVar#382", var"##MTKArg#378", var"##MTKArg#379", var"##MTKArg#380")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#378"[1], var"##MTKArg#378"[2], var"##MTKArg#378"[3], var"##MTKArg#379"[1], var"##MTKArg#379"[2], var"##MTKArg#379"[3])
                    var"##MTIIPVar#382"[1] = Ω_1
                    var"##MTIIPVar#382"[2] = Ω_1
                end
            end
        nothing
    end
const Ω_p! = (var"##MTIIPVar#389", var"##MTKArg#385", var"##MTKArg#386", var"##MTKArg#387")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#385"[1], var"##MTKArg#385"[2], var"##MTKArg#385"[3], var"##MTKArg#386"[1], var"##MTKArg#386"[2], var"##MTKArg#386"[3])
                end
            end
        nothing
    end
const H! = (var"##MTIIPVar#402", var"##MTKArg#392", var"##MTKArg#393", var"##MTKArg#394", var"##MTKArg#395", var"##MTKArg#396", var"##MTKArg#397", var"##MTKArg#398", var"##MTKArg#399", var"##MTKArg#400")->begin
        @inbounds begin
                let (c_p, q_p, i_p, c, q, i, c_ss, q_ss, i_ss, k_p, z_p, k, z, k_ss, z_ss, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#392"[1], var"##MTKArg#392"[2], var"##MTKArg#392"[3], var"##MTKArg#393"[1], var"##MTKArg#393"[2], var"##MTKArg#393"[3], var"##MTKArg#394"[1], var"##MTKArg#394"[2], var"##MTKArg#394"[3], var"##MTKArg#395"[1], var"##MTKArg#395"[2], var"##MTKArg#396"[1], var"##MTKArg#396"[2], var"##MTKArg#397"[1], var"##MTKArg#397"[2], var"##MTKArg#398"[1], var"##MTKArg#398"[2], var"##MTKArg#398"[3], var"##MTKArg#399"[1], var"##MTKArg#399"[2], var"##MTKArg#399"[3])
                    var"##MTIIPVar#402"[1] = (-)((/)(1, c), (*)((/)(β, c_p), (+)((*)((*)(α, (exp)(z_p)), (^)(k_p, (-)(α, 1))), (-)(1, δ))))
                    var"##MTIIPVar#402"[2] = (-)((-)((+)(c, k_p), (*)((-)(1, δ), k)), q)
                    var"##MTIIPVar#402"[3] = (-)(q, (*)((exp)(z), (^)(k, α)))
                    var"##MTIIPVar#402"[4] = (-)(z_p, (*)(ρ, z))
                    var"##MTIIPVar#402"[5] = (-)(i, (-)(k_p, (*)((-)(1, δ), k)))
                end
            end
        nothing
    end
const H_yp! = (var"##MTIIPVar#411", var"##MTKArg#405", var"##MTKArg#406", var"##MTKArg#407", var"##MTKArg#408", var"##MTKArg#409")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#405"[1], var"##MTKArg#405"[2], var"##MTKArg#405"[3], var"##MTKArg#406"[1], var"##MTKArg#406"[2], var"##MTKArg#407"[1], var"##MTKArg#407"[2], var"##MTKArg#407"[3], var"##MTKArg#408"[1], var"##MTKArg#408"[2], var"##MTKArg#408"[3])
                    var"##MTIIPVar#411"[1] = (*)((+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 2), β)
                end
            end
        nothing
    end
const H_y! = (var"##MTIIPVar#420", var"##MTKArg#414", var"##MTKArg#415", var"##MTKArg#416", var"##MTKArg#417", var"##MTKArg#418")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#414"[1], var"##MTKArg#414"[2], var"##MTKArg#414"[3], var"##MTKArg#415"[1], var"##MTKArg#415"[2], var"##MTKArg#416"[1], var"##MTKArg#416"[2], var"##MTKArg#416"[3], var"##MTKArg#417"[1], var"##MTKArg#417"[2], var"##MTKArg#417"[3])
                    var"##MTIIPVar#420"[1] = (*)(-1, (^)((inv)(c), 2))
                    var"##MTIIPVar#420"[2] = 1
                    var"##MTIIPVar#420"[7] = -1
                    var"##MTIIPVar#420"[8] = 1
                    var"##MTIIPVar#420"[15] = 1
                end
            end
        nothing
    end
const H_xp! = (var"##MTIIPVar#429", var"##MTKArg#423", var"##MTKArg#424", var"##MTKArg#425", var"##MTKArg#426", var"##MTKArg#427")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#423"[1], var"##MTKArg#423"[2], var"##MTKArg#423"[3], var"##MTKArg#424"[1], var"##MTKArg#424"[2], var"##MTKArg#425"[1], var"##MTKArg#425"[2], var"##MTKArg#425"[3], var"##MTKArg#426"[1], var"##MTKArg#426"[2], var"##MTKArg#426"[3])
                    var"##MTIIPVar#429"[1] = (*)((*)((*)((*)(-1, (exp)(z)), (^)((inv)(c), 1)), α), (*)((*)(β, (^)(k, (+)(-2, α))), (+)(-1, α)))
                    var"##MTIIPVar#429"[2] = 1
                    var"##MTIIPVar#429"[5] = -1
                    var"##MTIIPVar#429"[6] = (*)((*)((*)((*)(-1, (exp)(z)), (^)((inv)(c), 1)), α), (*)(β, (^)(k, (+)(-1, α))))
                    var"##MTIIPVar#429"[9] = 1
                end
            end
        nothing
    end
const H_x! = (var"##MTIIPVar#438", var"##MTKArg#432", var"##MTKArg#433", var"##MTKArg#434", var"##MTKArg#435", var"##MTKArg#436")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#432"[1], var"##MTKArg#432"[2], var"##MTKArg#432"[3], var"##MTKArg#433"[1], var"##MTKArg#433"[2], var"##MTKArg#434"[1], var"##MTKArg#434"[2], var"##MTKArg#434"[3], var"##MTKArg#435"[1], var"##MTKArg#435"[2], var"##MTKArg#435"[3])
                    var"##MTIIPVar#438"[2] = (*)(-1, (+)(1, (*)(-1, δ)))
                    var"##MTIIPVar#438"[3] = (*)(-1, (exp)(z), α, (^)(k, (+)(-1, α)))
                    var"##MTIIPVar#438"[5] = (+)(1, (*)(-1, δ))
                    var"##MTIIPVar#438"[8] = (*)(-1, (exp)(z), (^)(k, α))
                    var"##MTIIPVar#438"[9] = (*)(-1, ρ)
                end
            end
        nothing
    end
const H_yp_p! = (var"##MTIIPVar#447", var"##MTKArg#441", var"##MTKArg#442", var"##MTKArg#443", var"##MTKArg#444", var"##MTKArg#445")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#441"[1], var"##MTKArg#441"[2], var"##MTKArg#441"[3], var"##MTKArg#442"[1], var"##MTKArg#442"[2], var"##MTKArg#443"[1], var"##MTKArg#443"[2], var"##MTKArg#443"[3], var"##MTKArg#444"[1], var"##MTKArg#444"[2], var"##MTKArg#444"[3])
                    (var"##MTIIPVar#447"[1])[1] = (*)((^)((inv)(c), 2), β, (+)((*)((exp)(z), (^)(k, (+)(-1, α))), (*)((log)(k), (exp)(z), α, (^)(k, (+)(-1, α)))))
                    (var"##MTIIPVar#447"[2])[1] = (*)((+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 2))
                end
            end
        nothing
    end
const H_y_p! = (var"##MTIIPVar#456", var"##MTKArg#450", var"##MTKArg#451", var"##MTKArg#452", var"##MTKArg#453", var"##MTKArg#454")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#450"[1], var"##MTKArg#450"[2], var"##MTKArg#450"[3], var"##MTKArg#451"[1], var"##MTKArg#451"[2], var"##MTKArg#452"[1], var"##MTKArg#452"[2], var"##MTKArg#452"[3], var"##MTKArg#453"[1], var"##MTKArg#453"[2], var"##MTKArg#453"[3])
                end
            end
        nothing
    end
const H_xp_p! = (var"##MTIIPVar#465", var"##MTKArg#459", var"##MTKArg#460", var"##MTKArg#461", var"##MTKArg#462", var"##MTKArg#463")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#459"[1], var"##MTKArg#459"[2], var"##MTKArg#459"[3], var"##MTKArg#460"[1], var"##MTKArg#460"[2], var"##MTKArg#461"[1], var"##MTKArg#461"[2], var"##MTKArg#461"[3], var"##MTKArg#462"[1], var"##MTKArg#462"[2], var"##MTKArg#462"[3])
                    (var"##MTIIPVar#465"[1])[1] = (+)((*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-2, α))), (*)(-1, (exp)(z), (^)((inv)(c), 1), β, (^)(k, (+)(-2, α)), (+)(-1, α)), (*)(-1, (log)(k), (exp)(z), (^)((inv)(c), 1), α, (+)(-1, α), β, (^)(k, (+)(-2, α))))
                    (var"##MTIIPVar#465"[1])[6] = (+)((*)(-1, (exp)(z), (^)((inv)(c), 1), β, (^)(k, (+)(-1, α))), (*)(-1, (log)(k), (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-1, α))))
                    (var"##MTIIPVar#465"[2])[1] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#465"[2])[6] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (^)(k, (+)(-1, α)))
                end
            end
        nothing
    end
const H_x_p! = (var"##MTIIPVar#474", var"##MTKArg#468", var"##MTKArg#469", var"##MTKArg#470", var"##MTKArg#471", var"##MTKArg#472")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#468"[1], var"##MTKArg#468"[2], var"##MTKArg#468"[3], var"##MTKArg#469"[1], var"##MTKArg#469"[2], var"##MTKArg#470"[1], var"##MTKArg#470"[2], var"##MTKArg#470"[3], var"##MTKArg#471"[1], var"##MTKArg#471"[2], var"##MTKArg#471"[3])
                    (var"##MTIIPVar#474"[1])[3] = (+)((*)(-1, (exp)(z), (^)(k, (+)(-1, α))), (*)(-1, (log)(k), (exp)(z), α, (^)(k, (+)(-1, α))))
                    (var"##MTIIPVar#474"[1])[8] = (*)(-1, (log)(k), (exp)(z), (^)(k, α))
                    (var"##MTIIPVar#474"[3])[9] = -1
                end
            end
        nothing
    end
const H_p! = (var"##MTIIPVar#483", var"##MTKArg#477", var"##MTKArg#478", var"##MTKArg#479", var"##MTKArg#480", var"##MTKArg#481")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#477"[1], var"##MTKArg#477"[2], var"##MTKArg#477"[3], var"##MTKArg#478"[1], var"##MTKArg#478"[2], var"##MTKArg#479"[1], var"##MTKArg#479"[2], var"##MTKArg#479"[3], var"##MTKArg#480"[1], var"##MTKArg#480"[2], var"##MTKArg#480"[3])
                    var"##MTIIPVar#483"[1] = (*)(-1, (^)((inv)(c), 1), β, (+)((*)((exp)(z), (^)(k, (+)(-1, α))), (*)((log)(k), (exp)(z), α, (^)(k, (+)(-1, α)))))
                    var"##MTIIPVar#483"[3] = (*)(-1, (log)(k), (exp)(z), (^)(k, α))
                    var"##MTIIPVar#483"[6] = (*)(-1, (+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 1))
                    var"##MTIIPVar#483"[14] = (*)(-1, z)
                end
            end
        nothing
    end
const Ψ! = (var"##MTIIPVar#492", var"##MTKArg#486", var"##MTKArg#487", var"##MTKArg#488", var"##MTKArg#489", var"##MTKArg#490")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#486"[1], var"##MTKArg#486"[2], var"##MTKArg#486"[3], var"##MTKArg#487"[1], var"##MTKArg#487"[2], var"##MTKArg#488"[1], var"##MTKArg#488"[2], var"##MTKArg#488"[3], var"##MTKArg#489"[1], var"##MTKArg#489"[2], var"##MTKArg#489"[3])
                    (var"##MTIIPVar#492"[1])[1] = (*)(-2, (+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 3), β)
                    (var"##MTIIPVar#492"[1])[7] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#492"[1])[8] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-1, α)))
                    (var"##MTIIPVar#492"[1])[34] = (*)(2, (^)((inv)(c), 3))
                    (var"##MTIIPVar#492"[1])[61] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#492"[1])[67] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (+)(-1, α), β, (^)(k, (+)(-3, α)), (+)(-2, α))
                    (var"##MTIIPVar#492"[1])[68] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#492"[1])[71] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-1, α)))
                    (var"##MTIIPVar#492"[1])[77] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#492"[1])[78] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-1, α)))
                    (var"##MTIIPVar#492"[3])[89] = (*)(-1, (exp)(z), α, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#492"[3])[90] = (*)(-1, (exp)(z), α, (^)(k, (+)(-1, α)))
                    (var"##MTIIPVar#492"[3])[99] = (*)(-1, (exp)(z), α, (^)(k, (+)(-1, α)))
                    (var"##MTIIPVar#492"[3])[100] = (*)(-1, (exp)(z), (^)(k, α))
                end
            end
        nothing
    end
const H̄! = (var"##MTIIPVar#500", var"##MTKArg#495", var"##MTKArg#496", var"##MTKArg#497", var"##MTKArg#498")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#495"[1], var"##MTKArg#495"[2], var"##MTKArg#495"[3], var"##MTKArg#495"[4], var"##MTKArg#495"[5], var"##MTKArg#496"[1], var"##MTKArg#496"[2], var"##MTKArg#496"[3], var"##MTKArg#497"[1], var"##MTKArg#497"[2], var"##MTKArg#497"[3])
                    var"##MTIIPVar#500"[1] = (+)((^)((inv)(c), 1), (*)(-1, (+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 1), β))
                    var"##MTIIPVar#500"[2] = (+)(c, k, (*)(-1, (+)(q, (*)(k, (+)(1, (*)(-1, δ))))))
                    var"##MTIIPVar#500"[3] = (+)((*)(-1, (exp)(z), (^)(k, α)), q)
                    var"##MTIIPVar#500"[4] = (+)((*)(-1, z, ρ), z)
                    var"##MTIIPVar#500"[5] = (+)(i, (*)(-1, (+)((*)(-1, k, (+)(1, (*)(-1, δ))), k)))
                end
            end
        nothing
    end
const H̄_w! = (var"##MTIIPVar#508", var"##MTKArg#503", var"##MTKArg#504", var"##MTKArg#505", var"##MTKArg#506")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#503"[1], var"##MTKArg#503"[2], var"##MTKArg#503"[3], var"##MTKArg#503"[4], var"##MTKArg#503"[5], var"##MTKArg#504"[1], var"##MTKArg#504"[2], var"##MTKArg#504"[3], var"##MTKArg#505"[1], var"##MTKArg#505"[2], var"##MTKArg#505"[3])
                    var"##MTIIPVar#508"[1] = (+)((*)(-1, (^)((inv)(c), 2)), (*)((+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 2), β))
                    var"##MTIIPVar#508"[2] = 1
                    var"##MTIIPVar#508"[7] = -1
                    var"##MTIIPVar#508"[8] = 1
                    var"##MTIIPVar#508"[15] = 1
                    var"##MTIIPVar#508"[16] = (*)((*)((*)((*)(-1, (exp)(z)), (^)((inv)(c), 1)), α), (*)((*)(β, (^)(k, (+)(-2, α))), (+)(-1, α)))
                    var"##MTIIPVar#508"[17] = (+)(1, (*)(-1, (+)(1, (*)(-1, δ))))
                    var"##MTIIPVar#508"[18] = (*)(-1, (exp)(z), α, (^)(k, (+)(-1, α)))
                    var"##MTIIPVar#508"[20] = (*)(-1, (+)(1, (*)(-1, (+)(1, (*)(-1, δ)))))
                    var"##MTIIPVar#508"[21] = (*)((*)((*)((*)(-1, (exp)(z)), (^)((inv)(c), 1)), α), (*)(β, (^)(k, (+)(-1, α))))
                    var"##MTIIPVar#508"[23] = (*)(-1, (exp)(z), (^)(k, α))
                    var"##MTIIPVar#508"[24] = (+)(1, (*)(-1, ρ))
                end
            end
        nothing
    end
const ȳ_iv! = (var"##MTIIPVar#515", var"##MTKArg#511", var"##MTKArg#512", var"##MTKArg#513")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#511"[1], var"##MTKArg#511"[2], var"##MTKArg#511"[3], var"##MTKArg#512"[1], var"##MTKArg#512"[2], var"##MTKArg#512"[3])
                    var"##MTIIPVar#515"[1] = (-)((^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(α, (-)(α, 1))), (*)(δ, (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1)))))
                    var"##MTIIPVar#515"[2] = (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(α, (-)(α, 1)))
                    var"##MTIIPVar#515"[3] = (*)(δ, (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1))))
                end
            end
        nothing
    end
const x̄_iv! = (var"##MTIIPVar#522", var"##MTKArg#518", var"##MTKArg#519", var"##MTKArg#520")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#518"[1], var"##MTKArg#518"[2], var"##MTKArg#518"[3], var"##MTKArg#519"[1], var"##MTKArg#519"[2], var"##MTKArg#519"[3])
                    var"##MTIIPVar#522"[1] = (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1)))
                end
            end
        nothing
    end
const ȳ! = (var"##MTIIPVar#529", var"##MTKArg#525", var"##MTKArg#526", var"##MTKArg#527")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#525"[1], var"##MTKArg#525"[2], var"##MTKArg#525"[3], var"##MTKArg#526"[1], var"##MTKArg#526"[2], var"##MTKArg#526"[3])
                    var"##MTIIPVar#529"[1] = (-)((^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(α, (-)(α, 1))), (*)(δ, (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1)))))
                    var"##MTIIPVar#529"[2] = (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(α, (-)(α, 1)))
                    var"##MTIIPVar#529"[3] = (*)(δ, (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1))))
                end
            end
        nothing
    end
const x̄! = (var"##MTIIPVar#536", var"##MTKArg#532", var"##MTKArg#533", var"##MTKArg#534")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#532"[1], var"##MTKArg#532"[2], var"##MTKArg#532"[3], var"##MTKArg#533"[1], var"##MTKArg#533"[2], var"##MTKArg#533"[3])
                    var"##MTIIPVar#536"[1] = (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1)))
                end
            end
        nothing
    end
const ȳ_p! = (var"##MTIIPVar#543", var"##MTKArg#539", var"##MTKArg#540", var"##MTKArg#541")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#539"[1], var"##MTKArg#539"[2], var"##MTKArg#539"[3], var"##MTKArg#540"[1], var"##MTKArg#540"[2], var"##MTKArg#540"[3])
                    var"##MTIIPVar#543"[1] = (+)((*)(-1, δ, (+)((*)(-1, (log)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1))), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (^)((inv)((+)(-1, α)), 1)), (^)((inv)((+)(-1, α)), 2)), (*)((*)((*)((*)(-1, (+)(-1, (^)((inv)(β), 1), δ)), (^)((inv)(α), 2)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1)))), (*)((log)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1))), (+)((^)((inv)((+)(-1, α)), 1), (*)(-1, α, (^)((inv)((+)(-1, α)), 2))), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (*)(α, (^)((inv)((+)(-1, α)), 1)))), (*)((*)((*)((*)(-1, (+)(-1, (^)((inv)(β), 1), δ)), (^)((inv)(α), 1)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (*)(α, (^)((inv)((+)(-1, α)), 1))))), (^)((inv)((+)(-1, α)), 1)))
                    var"##MTIIPVar#543"[2] = (+)((*)((log)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1))), (+)((^)((inv)((+)(-1, α)), 1), (*)(-1, α, (^)((inv)((+)(-1, α)), 2))), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (*)(α, (^)((inv)((+)(-1, α)), 1)))), (*)((*)((*)((*)(-1, (+)(-1, (^)((inv)(β), 1), δ)), (^)((inv)(α), 1)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (*)(α, (^)((inv)((+)(-1, α)), 1))))), (^)((inv)((+)(-1, α)), 1)))
                    var"##MTIIPVar#543"[3] = (*)(δ, (+)((*)(-1, (log)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1))), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (^)((inv)((+)(-1, α)), 1)), (^)((inv)((+)(-1, α)), 2)), (*)((*)((*)((*)(-1, (+)(-1, (^)((inv)(β), 1), δ)), (^)((inv)(α), 2)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1))))
                    var"##MTIIPVar#543"[4] = (+)((*)(-1, (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (*)(α, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1), (^)((inv)(β), 2)), (*)((*)((*)((*)((^)((inv)(α), 1), δ), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1)), (^)((inv)(β), 2)))
                    var"##MTIIPVar#543"[5] = (*)(-1, (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (*)(α, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1), (^)((inv)(β), 2))
                    var"##MTIIPVar#543"[6] = (*)((*)((*)((*)(-1, (^)((inv)(α), 1)), δ), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (*)((^)((inv)((+)(-1, α)), 1), (^)((inv)(β), 2)))
                end
            end
        nothing
    end
const x̄_p! = (var"##MTIIPVar#550", var"##MTKArg#546", var"##MTKArg#547", var"##MTKArg#548")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#546"[1], var"##MTKArg#546"[2], var"##MTKArg#546"[3], var"##MTKArg#547"[1], var"##MTKArg#547"[2], var"##MTKArg#547"[3])
                    var"##MTIIPVar#550"[1] = (+)((*)(-1, (log)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1))), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (^)((inv)((+)(-1, α)), 1)), (^)((inv)((+)(-1, α)), 2)), (*)((*)((*)((*)(-1, (+)(-1, (^)((inv)(β), 1), δ)), (^)((inv)(α), 2)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1)))
                    var"##MTIIPVar#550"[3] = (*)((*)((*)((*)(-1, (^)((inv)(α), 1)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1)), (^)((inv)(β), 2))
                end
            end
        nothing
    end
const steady_state! = nothing
const allocate_solver_cache = m->begin
        #= C:\Google Drive\Projects\HMCDSGE\src\mtk_constructor.jl:142 =#
        FirstOrderSolverCache(m)
    end
const select_p_ss_hash = LinearAlgebra.UniformScaling{Bool}(true)
const select_p_f_ss_hash = LinearAlgebra.UniformScaling{Bool}(true)
const select_p_perturbation_hash = LinearAlgebra.UniformScaling{Bool}(true)
const select_p_f_perturbation_hash = LinearAlgebra.UniformScaling{Bool}(true)
end
