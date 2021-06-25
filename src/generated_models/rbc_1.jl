module rbc_1
using SparseArrays, LinearAlgebra, DifferentiableStateSpaceModels, LaTeXStrings, ModelingToolkit
const n_y = 2
const n_x = 2
const n = 4
const n_p = 3
const n_ϵ = 1
const n_z = 2
const functions_type() = DenseFunctions()
const η = reshape([0; -1], 2, 1)
const Q = [1.0 0.0 0.0 0.0; 0.0 0.0 1.0 0.0]
const Γ! = (var"##MTIIPVar#370", var"##MTKArg#366", var"##MTKArg#367", var"##MTKArg#368")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#366"[1], var"##MTKArg#366"[2], var"##MTKArg#366"[3], var"##MTKArg#367"[1], var"##MTKArg#367"[2], var"##MTKArg#367"[3])
                    var"##MTIIPVar#370"[1] = σ
                end
            end
        nothing
    end
const Γ_p! = (var"##MTIIPVar#377", var"##MTKArg#373", var"##MTKArg#374", var"##MTKArg#375")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#373"[1], var"##MTKArg#373"[2], var"##MTKArg#373"[3], var"##MTKArg#374"[1], var"##MTKArg#374"[2], var"##MTKArg#374"[3])
                end
            end
        nothing
    end
const Ω! = (var"##MTIIPVar#384", var"##MTKArg#380", var"##MTKArg#381", var"##MTKArg#382")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#380"[1], var"##MTKArg#380"[2], var"##MTKArg#380"[3], var"##MTKArg#381"[1], var"##MTKArg#381"[2], var"##MTKArg#381"[3])
                    var"##MTIIPVar#384"[1] = Ω_1
                    var"##MTIIPVar#384"[2] = Ω_1
                end
            end
        nothing
    end
const Ω_p! = (var"##MTIIPVar#391", var"##MTKArg#387", var"##MTKArg#388", var"##MTKArg#389")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#387"[1], var"##MTKArg#387"[2], var"##MTKArg#387"[3], var"##MTKArg#388"[1], var"##MTKArg#388"[2], var"##MTKArg#388"[3])
                end
            end
        nothing
    end
const H! = (var"##MTIIPVar#404", var"##MTKArg#394", var"##MTKArg#395", var"##MTKArg#396", var"##MTKArg#397", var"##MTKArg#398", var"##MTKArg#399", var"##MTKArg#400", var"##MTKArg#401", var"##MTKArg#402")->begin
        @inbounds begin
                let (c_p, q_p, c, q, c_ss, q_ss, k_p, z_p, k, z, k_ss, z_ss, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#394"[1], var"##MTKArg#394"[2], var"##MTKArg#395"[1], var"##MTKArg#395"[2], var"##MTKArg#396"[1], var"##MTKArg#396"[2], var"##MTKArg#397"[1], var"##MTKArg#397"[2], var"##MTKArg#398"[1], var"##MTKArg#398"[2], var"##MTKArg#399"[1], var"##MTKArg#399"[2], var"##MTKArg#400"[1], var"##MTKArg#400"[2], var"##MTKArg#400"[3], var"##MTKArg#401"[1], var"##MTKArg#401"[2], var"##MTKArg#401"[3])
                    var"##MTIIPVar#404"[1] = (-)((/)(1, c), (*)((/)(β, c_p), (+)((*)((*)(α, (exp)(z_p)), (^)(k_p, (-)(α, 1))), (-)(1, δ))))
                    var"##MTIIPVar#404"[2] = (-)((-)((+)(c, k_p), (*)((-)(1, δ), k)), q)
                    var"##MTIIPVar#404"[3] = (-)(q, (*)((exp)(z), (^)(k, α)))
                    var"##MTIIPVar#404"[4] = (-)(z_p, (*)(ρ, z))
                end
            end
        nothing
    end
const H_yp! = (var"##MTIIPVar#413", var"##MTKArg#407", var"##MTKArg#408", var"##MTKArg#409", var"##MTKArg#410", var"##MTKArg#411")->begin
        @inbounds begin
                let (c, q, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#407"[1], var"##MTKArg#407"[2], var"##MTKArg#408"[1], var"##MTKArg#408"[2], var"##MTKArg#409"[1], var"##MTKArg#409"[2], var"##MTKArg#409"[3], var"##MTKArg#410"[1], var"##MTKArg#410"[2], var"##MTKArg#410"[3])
                    var"##MTIIPVar#413"[1] = (*)((+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 2), β)
                end
            end
        nothing
    end
const H_y! = (var"##MTIIPVar#422", var"##MTKArg#416", var"##MTKArg#417", var"##MTKArg#418", var"##MTKArg#419", var"##MTKArg#420")->begin
        @inbounds begin
                let (c, q, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#416"[1], var"##MTKArg#416"[2], var"##MTKArg#417"[1], var"##MTKArg#417"[2], var"##MTKArg#418"[1], var"##MTKArg#418"[2], var"##MTKArg#418"[3], var"##MTKArg#419"[1], var"##MTKArg#419"[2], var"##MTKArg#419"[3])
                    var"##MTIIPVar#422"[1] = (*)(-1, (^)((inv)(c), 2))
                    var"##MTIIPVar#422"[2] = 1
                    var"##MTIIPVar#422"[6] = -1
                    var"##MTIIPVar#422"[7] = 1
                end
            end
        nothing
    end
const H_xp! = (var"##MTIIPVar#431", var"##MTKArg#425", var"##MTKArg#426", var"##MTKArg#427", var"##MTKArg#428", var"##MTKArg#429")->begin
        @inbounds begin
                let (c, q, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#425"[1], var"##MTKArg#425"[2], var"##MTKArg#426"[1], var"##MTKArg#426"[2], var"##MTKArg#427"[1], var"##MTKArg#427"[2], var"##MTKArg#427"[3], var"##MTKArg#428"[1], var"##MTKArg#428"[2], var"##MTKArg#428"[3])
                    var"##MTIIPVar#431"[1] = (*)((*)((*)((*)(-1, (exp)(z)), (^)((inv)(c), 1)), α), (*)((*)(β, (^)(k, (+)(-2, α))), (+)(-1, α)))
                    var"##MTIIPVar#431"[2] = 1
                    var"##MTIIPVar#431"[5] = (*)((*)((*)((*)(-1, (exp)(z)), (^)((inv)(c), 1)), α), (*)(β, (^)(k, (+)(-1, α))))
                    var"##MTIIPVar#431"[8] = 1
                end
            end
        nothing
    end
const H_x! = (var"##MTIIPVar#440", var"##MTKArg#434", var"##MTKArg#435", var"##MTKArg#436", var"##MTKArg#437", var"##MTKArg#438")->begin
        @inbounds begin
                let (c, q, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#434"[1], var"##MTKArg#434"[2], var"##MTKArg#435"[1], var"##MTKArg#435"[2], var"##MTKArg#436"[1], var"##MTKArg#436"[2], var"##MTKArg#436"[3], var"##MTKArg#437"[1], var"##MTKArg#437"[2], var"##MTKArg#437"[3])
                    var"##MTIIPVar#440"[2] = (*)(-1, (+)(1, (*)(-1, δ)))
                    var"##MTIIPVar#440"[3] = (*)(-1, (exp)(z), α, (^)(k, (+)(-1, α)))
                    var"##MTIIPVar#440"[7] = (*)(-1, (exp)(z), (^)(k, α))
                    var"##MTIIPVar#440"[8] = (*)(-1, ρ)
                end
            end
        nothing
    end
const H_yp_p! = (var"##MTIIPVar#449", var"##MTKArg#443", var"##MTKArg#444", var"##MTKArg#445", var"##MTKArg#446", var"##MTKArg#447")->begin
        @inbounds begin
                let (c, q, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#443"[1], var"##MTKArg#443"[2], var"##MTKArg#444"[1], var"##MTKArg#444"[2], var"##MTKArg#445"[1], var"##MTKArg#445"[2], var"##MTKArg#445"[3], var"##MTKArg#446"[1], var"##MTKArg#446"[2], var"##MTKArg#446"[3])
                    (var"##MTIIPVar#449"[1])[1] = (*)((^)((inv)(c), 2), β, (+)((*)((exp)(z), (^)(k, (+)(-1, α))), (*)((log)(k), (exp)(z), α, (^)(k, (+)(-1, α)))))
                    (var"##MTIIPVar#449"[2])[1] = (*)((+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 2))
                end
            end
        nothing
    end
const H_y_p! = (var"##MTIIPVar#458", var"##MTKArg#452", var"##MTKArg#453", var"##MTKArg#454", var"##MTKArg#455", var"##MTKArg#456")->begin
        @inbounds begin
                let (c, q, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#452"[1], var"##MTKArg#452"[2], var"##MTKArg#453"[1], var"##MTKArg#453"[2], var"##MTKArg#454"[1], var"##MTKArg#454"[2], var"##MTKArg#454"[3], var"##MTKArg#455"[1], var"##MTKArg#455"[2], var"##MTKArg#455"[3])
                end
            end
        nothing
    end
const H_xp_p! = (var"##MTIIPVar#467", var"##MTKArg#461", var"##MTKArg#462", var"##MTKArg#463", var"##MTKArg#464", var"##MTKArg#465")->begin
        @inbounds begin
                let (c, q, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#461"[1], var"##MTKArg#461"[2], var"##MTKArg#462"[1], var"##MTKArg#462"[2], var"##MTKArg#463"[1], var"##MTKArg#463"[2], var"##MTKArg#463"[3], var"##MTKArg#464"[1], var"##MTKArg#464"[2], var"##MTKArg#464"[3])
                    (var"##MTIIPVar#467"[1])[1] = (+)((*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-2, α))), (*)(-1, (exp)(z), (^)((inv)(c), 1), β, (^)(k, (+)(-2, α)), (+)(-1, α)), (*)(-1, (log)(k), (exp)(z), (^)((inv)(c), 1), α, (+)(-1, α), β, (^)(k, (+)(-2, α))))
                    (var"##MTIIPVar#467"[1])[5] = (+)((*)(-1, (exp)(z), (^)((inv)(c), 1), β, (^)(k, (+)(-1, α))), (*)(-1, (log)(k), (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-1, α))))
                    (var"##MTIIPVar#467"[2])[1] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#467"[2])[5] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (^)(k, (+)(-1, α)))
                end
            end
        nothing
    end
const H_x_p! = (var"##MTIIPVar#476", var"##MTKArg#470", var"##MTKArg#471", var"##MTKArg#472", var"##MTKArg#473", var"##MTKArg#474")->begin
        @inbounds begin
                let (c, q, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#470"[1], var"##MTKArg#470"[2], var"##MTKArg#471"[1], var"##MTKArg#471"[2], var"##MTKArg#472"[1], var"##MTKArg#472"[2], var"##MTKArg#472"[3], var"##MTKArg#473"[1], var"##MTKArg#473"[2], var"##MTKArg#473"[3])
                    (var"##MTIIPVar#476"[1])[3] = (+)((*)(-1, (exp)(z), (^)(k, (+)(-1, α))), (*)(-1, (log)(k), (exp)(z), α, (^)(k, (+)(-1, α))))
                    (var"##MTIIPVar#476"[1])[7] = (*)(-1, (log)(k), (exp)(z), (^)(k, α))
                    (var"##MTIIPVar#476"[3])[8] = -1
                end
            end
        nothing
    end
const H_p! = (var"##MTIIPVar#485", var"##MTKArg#479", var"##MTKArg#480", var"##MTKArg#481", var"##MTKArg#482", var"##MTKArg#483")->begin
        @inbounds begin
                let (c, q, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#479"[1], var"##MTKArg#479"[2], var"##MTKArg#480"[1], var"##MTKArg#480"[2], var"##MTKArg#481"[1], var"##MTKArg#481"[2], var"##MTKArg#481"[3], var"##MTKArg#482"[1], var"##MTKArg#482"[2], var"##MTKArg#482"[3])
                    var"##MTIIPVar#485"[1] = (*)(-1, (^)((inv)(c), 1), β, (+)((*)((exp)(z), (^)(k, (+)(-1, α))), (*)((log)(k), (exp)(z), α, (^)(k, (+)(-1, α)))))
                    var"##MTIIPVar#485"[3] = (*)(-1, (log)(k), (exp)(z), (^)(k, α))
                    var"##MTIIPVar#485"[5] = (*)(-1, (+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 1))
                    var"##MTIIPVar#485"[12] = (*)(-1, z)
                end
            end
        nothing
    end
const Ψ! = (var"##MTIIPVar#494", var"##MTKArg#488", var"##MTKArg#489", var"##MTKArg#490", var"##MTKArg#491", var"##MTKArg#492")->begin
        @inbounds begin
                let (c, q, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#488"[1], var"##MTKArg#488"[2], var"##MTKArg#489"[1], var"##MTKArg#489"[2], var"##MTKArg#490"[1], var"##MTKArg#490"[2], var"##MTKArg#490"[3], var"##MTKArg#491"[1], var"##MTKArg#491"[2], var"##MTKArg#491"[3])
                    (var"##MTIIPVar#494"[1])[1] = (*)(-2, (+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 3), β)
                    (var"##MTIIPVar#494"[1])[5] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#494"[1])[6] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-1, α)))
                    (var"##MTIIPVar#494"[1])[19] = (*)(2, (^)((inv)(c), 3))
                    (var"##MTIIPVar#494"[1])[33] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#494"[1])[37] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (+)(-1, α), β, (^)(k, (+)(-3, α)), (+)(-2, α))
                    (var"##MTIIPVar#494"[1])[38] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#494"[1])[41] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-1, α)))
                    (var"##MTIIPVar#494"[1])[45] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#494"[1])[46] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-1, α)))
                    (var"##MTIIPVar#494"[3])[55] = (*)(-1, (exp)(z), α, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#494"[3])[56] = (*)(-1, (exp)(z), α, (^)(k, (+)(-1, α)))
                    (var"##MTIIPVar#494"[3])[63] = (*)(-1, (exp)(z), α, (^)(k, (+)(-1, α)))
                    (var"##MTIIPVar#494"[3])[64] = (*)(-1, (exp)(z), (^)(k, α))
                end
            end
        nothing
    end
const H̄! = (var"##MTIIPVar#502", var"##MTKArg#497", var"##MTKArg#498", var"##MTKArg#499", var"##MTKArg#500")->begin
        @inbounds begin
                let (c, q, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#497"[1], var"##MTKArg#497"[2], var"##MTKArg#497"[3], var"##MTKArg#497"[4], var"##MTKArg#498"[1], var"##MTKArg#498"[2], var"##MTKArg#498"[3], var"##MTKArg#499"[1], var"##MTKArg#499"[2], var"##MTKArg#499"[3])
                    var"##MTIIPVar#502"[1] = (+)((^)((inv)(c), 1), (*)(-1, (+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 1), β))
                    var"##MTIIPVar#502"[2] = (+)(c, k, (*)(-1, (+)(q, (*)(k, (+)(1, (*)(-1, δ))))))
                    var"##MTIIPVar#502"[3] = (+)((*)(-1, (exp)(z), (^)(k, α)), q)
                    var"##MTIIPVar#502"[4] = (+)((*)(-1, z, ρ), z)
                end
            end
        nothing
    end
const H̄_w! = (var"##MTIIPVar#510", var"##MTKArg#505", var"##MTKArg#506", var"##MTKArg#507", var"##MTKArg#508")->begin
        @inbounds begin
                let (c, q, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#505"[1], var"##MTKArg#505"[2], var"##MTKArg#505"[3], var"##MTKArg#505"[4], var"##MTKArg#506"[1], var"##MTKArg#506"[2], var"##MTKArg#506"[3], var"##MTKArg#507"[1], var"##MTKArg#507"[2], var"##MTKArg#507"[3])
                    var"##MTIIPVar#510"[1] = (+)((*)(-1, (^)((inv)(c), 2)), (*)((+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 2), β))
                    var"##MTIIPVar#510"[2] = 1
                    var"##MTIIPVar#510"[6] = -1
                    var"##MTIIPVar#510"[7] = 1
                    var"##MTIIPVar#510"[9] = (*)((*)((*)((*)(-1, (exp)(z)), (^)((inv)(c), 1)), α), (*)((*)(β, (^)(k, (+)(-2, α))), (+)(-1, α)))
                    var"##MTIIPVar#510"[10] = (+)(1, (*)(-1, (+)(1, (*)(-1, δ))))
                    var"##MTIIPVar#510"[11] = (*)(-1, (exp)(z), α, (^)(k, (+)(-1, α)))
                    var"##MTIIPVar#510"[13] = (*)((*)((*)((*)(-1, (exp)(z)), (^)((inv)(c), 1)), α), (*)(β, (^)(k, (+)(-1, α))))
                    var"##MTIIPVar#510"[15] = (*)(-1, (exp)(z), (^)(k, α))
                    var"##MTIIPVar#510"[16] = (+)(1, (*)(-1, ρ))
                end
            end
        nothing
    end
const ȳ_iv! = (var"##MTIIPVar#517", var"##MTKArg#513", var"##MTKArg#514", var"##MTKArg#515")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#513"[1], var"##MTKArg#513"[2], var"##MTKArg#513"[3], var"##MTKArg#514"[1], var"##MTKArg#514"[2], var"##MTKArg#514"[3])
                    var"##MTIIPVar#517"[1] = (-)((^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(α, (-)(α, 1))), (*)(δ, (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1)))))
                    var"##MTIIPVar#517"[2] = (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(α, (-)(α, 1)))
                end
            end
        nothing
    end
const x̄_iv! = (var"##MTIIPVar#524", var"##MTKArg#520", var"##MTKArg#521", var"##MTKArg#522")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#520"[1], var"##MTKArg#520"[2], var"##MTKArg#520"[3], var"##MTKArg#521"[1], var"##MTKArg#521"[2], var"##MTKArg#521"[3])
                    var"##MTIIPVar#524"[1] = (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1)))
                end
            end
        nothing
    end
const ȳ! = (var"##MTIIPVar#531", var"##MTKArg#527", var"##MTKArg#528", var"##MTKArg#529")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#527"[1], var"##MTKArg#527"[2], var"##MTKArg#527"[3], var"##MTKArg#528"[1], var"##MTKArg#528"[2], var"##MTKArg#528"[3])
                    var"##MTIIPVar#531"[1] = (-)((^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(α, (-)(α, 1))), (*)(δ, (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1)))))
                    var"##MTIIPVar#531"[2] = (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(α, (-)(α, 1)))
                end
            end
        nothing
    end
const x̄! = (var"##MTIIPVar#538", var"##MTKArg#534", var"##MTKArg#535", var"##MTKArg#536")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#534"[1], var"##MTKArg#534"[2], var"##MTKArg#534"[3], var"##MTKArg#535"[1], var"##MTKArg#535"[2], var"##MTKArg#535"[3])
                    var"##MTIIPVar#538"[1] = (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1)))
                end
            end
        nothing
    end
const ȳ_p! = (var"##MTIIPVar#545", var"##MTKArg#541", var"##MTKArg#542", var"##MTKArg#543")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#541"[1], var"##MTKArg#541"[2], var"##MTKArg#541"[3], var"##MTKArg#542"[1], var"##MTKArg#542"[2], var"##MTKArg#542"[3])
                    var"##MTIIPVar#545"[1] = (+)((*)(-1, δ, (+)((*)(-1, (log)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1))), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (^)((inv)((+)(-1, α)), 1)), (^)((inv)((+)(-1, α)), 2)), (*)((*)((*)((*)(-1, (+)(-1, (^)((inv)(β), 1), δ)), (^)((inv)(α), 2)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1)))), (*)((log)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1))), (+)((^)((inv)((+)(-1, α)), 1), (*)(-1, α, (^)((inv)((+)(-1, α)), 2))), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (*)(α, (^)((inv)((+)(-1, α)), 1)))), (*)((*)((*)((*)(-1, (+)(-1, (^)((inv)(β), 1), δ)), (^)((inv)(α), 1)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (*)(α, (^)((inv)((+)(-1, α)), 1))))), (^)((inv)((+)(-1, α)), 1)))
                    var"##MTIIPVar#545"[2] = (+)((*)((log)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1))), (+)((^)((inv)((+)(-1, α)), 1), (*)(-1, α, (^)((inv)((+)(-1, α)), 2))), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (*)(α, (^)((inv)((+)(-1, α)), 1)))), (*)((*)((*)((*)(-1, (+)(-1, (^)((inv)(β), 1), δ)), (^)((inv)(α), 1)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (*)(α, (^)((inv)((+)(-1, α)), 1))))), (^)((inv)((+)(-1, α)), 1)))
                    var"##MTIIPVar#545"[3] = (+)((*)(-1, (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (*)(α, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1), (^)((inv)(β), 2)), (*)((*)((*)((*)((^)((inv)(α), 1), δ), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1)), (^)((inv)(β), 2)))
                    var"##MTIIPVar#545"[4] = (*)(-1, (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (*)(α, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1), (^)((inv)(β), 2))
                end
            end
        nothing
    end
const x̄_p! = (var"##MTIIPVar#552", var"##MTKArg#548", var"##MTKArg#549", var"##MTKArg#550")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#548"[1], var"##MTKArg#548"[2], var"##MTKArg#548"[3], var"##MTKArg#549"[1], var"##MTKArg#549"[2], var"##MTKArg#549"[3])
                    var"##MTIIPVar#552"[1] = (+)((*)(-1, (log)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1))), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (^)((inv)((+)(-1, α)), 1)), (^)((inv)((+)(-1, α)), 2)), (*)((*)((*)((*)(-1, (+)(-1, (^)((inv)(β), 1), δ)), (^)((inv)(α), 2)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1)))
                    var"##MTIIPVar#552"[3] = (*)((*)((*)((*)(-1, (^)((inv)(α), 1)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1)), (^)((inv)(β), 2))
                end
            end
        nothing
    end
const steady_state! = nothing
const allocate_solver_cache = m->begin
        #= C:\Users\jesse\.julia\packages\DifferentiableStateSpaceModels\yB5ce\src\mtk_constructor.jl:142 =#
        FirstOrderSolverCache(m)
    end
const select_p_ss_hash = LinearAlgebra.UniformScaling{Bool}(true)
const select_p_f_ss_hash = LinearAlgebra.UniformScaling{Bool}(true)
const select_p_perturbation_hash = LinearAlgebra.UniformScaling{Bool}(true)
const select_p_f_perturbation_hash = LinearAlgebra.UniformScaling{Bool}(true)
end
