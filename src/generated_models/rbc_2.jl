module rbc_2
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
const Γ! = (var"##MTIIPVar#555", var"##MTKArg#551", var"##MTKArg#552", var"##MTKArg#553")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#551"[1], var"##MTKArg#551"[2], var"##MTKArg#551"[3], var"##MTKArg#552"[1], var"##MTKArg#552"[2], var"##MTKArg#552"[3])
                    var"##MTIIPVar#555"[1] = σ
                end
            end
        nothing
    end
const Γ_p! = (var"##MTIIPVar#562", var"##MTKArg#558", var"##MTKArg#559", var"##MTKArg#560")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#558"[1], var"##MTKArg#558"[2], var"##MTKArg#558"[3], var"##MTKArg#559"[1], var"##MTKArg#559"[2], var"##MTKArg#559"[3])
                end
            end
        nothing
    end
const Ω! = (var"##MTIIPVar#569", var"##MTKArg#565", var"##MTKArg#566", var"##MTKArg#567")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#565"[1], var"##MTKArg#565"[2], var"##MTKArg#565"[3], var"##MTKArg#566"[1], var"##MTKArg#566"[2], var"##MTKArg#566"[3])
                    var"##MTIIPVar#569"[1] = Ω_1
                    var"##MTIIPVar#569"[2] = Ω_1
                end
            end
        nothing
    end
const Ω_p! = (var"##MTIIPVar#576", var"##MTKArg#572", var"##MTKArg#573", var"##MTKArg#574")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#572"[1], var"##MTKArg#572"[2], var"##MTKArg#572"[3], var"##MTKArg#573"[1], var"##MTKArg#573"[2], var"##MTKArg#573"[3])
                end
            end
        nothing
    end
const H! = (var"##MTIIPVar#589", var"##MTKArg#579", var"##MTKArg#580", var"##MTKArg#581", var"##MTKArg#582", var"##MTKArg#583", var"##MTKArg#584", var"##MTKArg#585", var"##MTKArg#586", var"##MTKArg#587")->begin
        @inbounds begin
                let (c_p, q_p, i_p, c, q, i, c_ss, q_ss, i_ss, k_p, z_p, k, z, k_ss, z_ss, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#579"[1], var"##MTKArg#579"[2], var"##MTKArg#579"[3], var"##MTKArg#580"[1], var"##MTKArg#580"[2], var"##MTKArg#580"[3], var"##MTKArg#581"[1], var"##MTKArg#581"[2], var"##MTKArg#581"[3], var"##MTKArg#582"[1], var"##MTKArg#582"[2], var"##MTKArg#583"[1], var"##MTKArg#583"[2], var"##MTKArg#584"[1], var"##MTKArg#584"[2], var"##MTKArg#585"[1], var"##MTKArg#585"[2], var"##MTKArg#585"[3], var"##MTKArg#586"[1], var"##MTKArg#586"[2], var"##MTKArg#586"[3])
                    var"##MTIIPVar#589"[1] = (-)((/)(1, c), (*)((/)(β, c_p), (+)((*)((*)(α, (exp)(z_p)), (^)(k_p, (-)(α, 1))), (-)(1, δ))))
                    var"##MTIIPVar#589"[2] = (-)((-)((+)(c, k_p), (*)((-)(1, δ), k)), q)
                    var"##MTIIPVar#589"[3] = (-)(q, (*)((exp)(z), (^)(k, α)))
                    var"##MTIIPVar#589"[4] = (-)(z_p, (*)(ρ, z))
                    var"##MTIIPVar#589"[5] = (-)(i, (-)(k_p, (*)((-)(1, δ), k)))
                end
            end
        nothing
    end
const H_yp! = (var"##MTIIPVar#598", var"##MTKArg#592", var"##MTKArg#593", var"##MTKArg#594", var"##MTKArg#595", var"##MTKArg#596")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#592"[1], var"##MTKArg#592"[2], var"##MTKArg#592"[3], var"##MTKArg#593"[1], var"##MTKArg#593"[2], var"##MTKArg#594"[1], var"##MTKArg#594"[2], var"##MTKArg#594"[3], var"##MTKArg#595"[1], var"##MTKArg#595"[2], var"##MTKArg#595"[3])
                    var"##MTIIPVar#598"[1] = (*)((+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 2), β)
                end
            end
        nothing
    end
const H_y! = (var"##MTIIPVar#607", var"##MTKArg#601", var"##MTKArg#602", var"##MTKArg#603", var"##MTKArg#604", var"##MTKArg#605")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#601"[1], var"##MTKArg#601"[2], var"##MTKArg#601"[3], var"##MTKArg#602"[1], var"##MTKArg#602"[2], var"##MTKArg#603"[1], var"##MTKArg#603"[2], var"##MTKArg#603"[3], var"##MTKArg#604"[1], var"##MTKArg#604"[2], var"##MTKArg#604"[3])
                    var"##MTIIPVar#607"[1] = (*)(-1, (^)((inv)(c), 2))
                    var"##MTIIPVar#607"[2] = 1
                    var"##MTIIPVar#607"[7] = -1
                    var"##MTIIPVar#607"[8] = 1
                    var"##MTIIPVar#607"[15] = 1
                end
            end
        nothing
    end
const H_xp! = (var"##MTIIPVar#616", var"##MTKArg#610", var"##MTKArg#611", var"##MTKArg#612", var"##MTKArg#613", var"##MTKArg#614")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#610"[1], var"##MTKArg#610"[2], var"##MTKArg#610"[3], var"##MTKArg#611"[1], var"##MTKArg#611"[2], var"##MTKArg#612"[1], var"##MTKArg#612"[2], var"##MTKArg#612"[3], var"##MTKArg#613"[1], var"##MTKArg#613"[2], var"##MTKArg#613"[3])
                    var"##MTIIPVar#616"[1] = (*)((*)((*)((*)(-1, (exp)(z)), (^)((inv)(c), 1)), α), (*)((*)(β, (^)(k, (+)(-2, α))), (+)(-1, α)))
                    var"##MTIIPVar#616"[2] = 1
                    var"##MTIIPVar#616"[5] = -1
                    var"##MTIIPVar#616"[6] = (*)((*)((*)((*)(-1, (exp)(z)), (^)((inv)(c), 1)), α), (*)(β, (^)(k, (+)(-1, α))))
                    var"##MTIIPVar#616"[9] = 1
                end
            end
        nothing
    end
const H_x! = (var"##MTIIPVar#625", var"##MTKArg#619", var"##MTKArg#620", var"##MTKArg#621", var"##MTKArg#622", var"##MTKArg#623")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#619"[1], var"##MTKArg#619"[2], var"##MTKArg#619"[3], var"##MTKArg#620"[1], var"##MTKArg#620"[2], var"##MTKArg#621"[1], var"##MTKArg#621"[2], var"##MTKArg#621"[3], var"##MTKArg#622"[1], var"##MTKArg#622"[2], var"##MTKArg#622"[3])
                    var"##MTIIPVar#625"[2] = (*)(-1, (+)(1, (*)(-1, δ)))
                    var"##MTIIPVar#625"[3] = (*)(-1, (exp)(z), α, (^)(k, (+)(-1, α)))
                    var"##MTIIPVar#625"[5] = (+)(1, (*)(-1, δ))
                    var"##MTIIPVar#625"[8] = (*)(-1, (exp)(z), (^)(k, α))
                    var"##MTIIPVar#625"[9] = (*)(-1, ρ)
                end
            end
        nothing
    end
const H_yp_p! = (var"##MTIIPVar#634", var"##MTKArg#628", var"##MTKArg#629", var"##MTKArg#630", var"##MTKArg#631", var"##MTKArg#632")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#628"[1], var"##MTKArg#628"[2], var"##MTKArg#628"[3], var"##MTKArg#629"[1], var"##MTKArg#629"[2], var"##MTKArg#630"[1], var"##MTKArg#630"[2], var"##MTKArg#630"[3], var"##MTKArg#631"[1], var"##MTKArg#631"[2], var"##MTKArg#631"[3])
                    (var"##MTIIPVar#634"[1])[1] = (*)((^)((inv)(c), 2), β, (+)((*)((exp)(z), (^)(k, (+)(-1, α))), (*)((log)(k), (exp)(z), α, (^)(k, (+)(-1, α)))))
                    (var"##MTIIPVar#634"[2])[1] = (*)((+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 2))
                end
            end
        nothing
    end
const H_y_p! = (var"##MTIIPVar#643", var"##MTKArg#637", var"##MTKArg#638", var"##MTKArg#639", var"##MTKArg#640", var"##MTKArg#641")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#637"[1], var"##MTKArg#637"[2], var"##MTKArg#637"[3], var"##MTKArg#638"[1], var"##MTKArg#638"[2], var"##MTKArg#639"[1], var"##MTKArg#639"[2], var"##MTKArg#639"[3], var"##MTKArg#640"[1], var"##MTKArg#640"[2], var"##MTKArg#640"[3])
                end
            end
        nothing
    end
const H_xp_p! = (var"##MTIIPVar#652", var"##MTKArg#646", var"##MTKArg#647", var"##MTKArg#648", var"##MTKArg#649", var"##MTKArg#650")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#646"[1], var"##MTKArg#646"[2], var"##MTKArg#646"[3], var"##MTKArg#647"[1], var"##MTKArg#647"[2], var"##MTKArg#648"[1], var"##MTKArg#648"[2], var"##MTKArg#648"[3], var"##MTKArg#649"[1], var"##MTKArg#649"[2], var"##MTKArg#649"[3])
                    (var"##MTIIPVar#652"[1])[1] = (+)((*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-2, α))), (*)(-1, (exp)(z), (^)((inv)(c), 1), β, (^)(k, (+)(-2, α)), (+)(-1, α)), (*)(-1, (log)(k), (exp)(z), (^)((inv)(c), 1), α, (+)(-1, α), β, (^)(k, (+)(-2, α))))
                    (var"##MTIIPVar#652"[1])[6] = (+)((*)(-1, (exp)(z), (^)((inv)(c), 1), β, (^)(k, (+)(-1, α))), (*)(-1, (log)(k), (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-1, α))))
                    (var"##MTIIPVar#652"[2])[1] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#652"[2])[6] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (^)(k, (+)(-1, α)))
                end
            end
        nothing
    end
const H_x_p! = (var"##MTIIPVar#661", var"##MTKArg#655", var"##MTKArg#656", var"##MTKArg#657", var"##MTKArg#658", var"##MTKArg#659")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#655"[1], var"##MTKArg#655"[2], var"##MTKArg#655"[3], var"##MTKArg#656"[1], var"##MTKArg#656"[2], var"##MTKArg#657"[1], var"##MTKArg#657"[2], var"##MTKArg#657"[3], var"##MTKArg#658"[1], var"##MTKArg#658"[2], var"##MTKArg#658"[3])
                    (var"##MTIIPVar#661"[1])[3] = (+)((*)(-1, (exp)(z), (^)(k, (+)(-1, α))), (*)(-1, (log)(k), (exp)(z), α, (^)(k, (+)(-1, α))))
                    (var"##MTIIPVar#661"[1])[8] = (*)(-1, (log)(k), (exp)(z), (^)(k, α))
                    (var"##MTIIPVar#661"[3])[9] = -1
                end
            end
        nothing
    end
const H_p! = (var"##MTIIPVar#670", var"##MTKArg#664", var"##MTKArg#665", var"##MTKArg#666", var"##MTKArg#667", var"##MTKArg#668")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#664"[1], var"##MTKArg#664"[2], var"##MTKArg#664"[3], var"##MTKArg#665"[1], var"##MTKArg#665"[2], var"##MTKArg#666"[1], var"##MTKArg#666"[2], var"##MTKArg#666"[3], var"##MTKArg#667"[1], var"##MTKArg#667"[2], var"##MTKArg#667"[3])
                    var"##MTIIPVar#670"[1] = (*)(-1, (^)((inv)(c), 1), β, (+)((*)((exp)(z), (^)(k, (+)(-1, α))), (*)((log)(k), (exp)(z), α, (^)(k, (+)(-1, α)))))
                    var"##MTIIPVar#670"[3] = (*)(-1, (log)(k), (exp)(z), (^)(k, α))
                    var"##MTIIPVar#670"[6] = (*)(-1, (+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 1))
                    var"##MTIIPVar#670"[14] = (*)(-1, z)
                end
            end
        nothing
    end
const Ψ! = (var"##MTIIPVar#679", var"##MTKArg#673", var"##MTKArg#674", var"##MTKArg#675", var"##MTKArg#676", var"##MTKArg#677")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#673"[1], var"##MTKArg#673"[2], var"##MTKArg#673"[3], var"##MTKArg#674"[1], var"##MTKArg#674"[2], var"##MTKArg#675"[1], var"##MTKArg#675"[2], var"##MTKArg#675"[3], var"##MTKArg#676"[1], var"##MTKArg#676"[2], var"##MTKArg#676"[3])
                    (var"##MTIIPVar#679"[1])[1] = (*)(-2, (+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 3), β)
                    (var"##MTIIPVar#679"[1])[7] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#679"[1])[8] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-1, α)))
                    (var"##MTIIPVar#679"[1])[34] = (*)(2, (^)((inv)(c), 3))
                    (var"##MTIIPVar#679"[1])[61] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#679"[1])[67] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (+)(-1, α), β, (^)(k, (+)(-3, α)), (+)(-2, α))
                    (var"##MTIIPVar#679"[1])[68] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#679"[1])[71] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-1, α)))
                    (var"##MTIIPVar#679"[1])[77] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#679"[1])[78] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-1, α)))
                    (var"##MTIIPVar#679"[3])[89] = (*)(-1, (exp)(z), α, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#679"[3])[90] = (*)(-1, (exp)(z), α, (^)(k, (+)(-1, α)))
                    (var"##MTIIPVar#679"[3])[99] = (*)(-1, (exp)(z), α, (^)(k, (+)(-1, α)))
                    (var"##MTIIPVar#679"[3])[100] = (*)(-1, (exp)(z), (^)(k, α))
                end
            end
        nothing
    end
const Ψ_p! = (var"##MTIIPVar#688", var"##MTKArg#682", var"##MTKArg#683", var"##MTKArg#684", var"##MTKArg#685", var"##MTKArg#686")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#682"[1], var"##MTKArg#682"[2], var"##MTKArg#682"[3], var"##MTKArg#683"[1], var"##MTKArg#683"[2], var"##MTKArg#684"[1], var"##MTKArg#684"[2], var"##MTKArg#684"[3], var"##MTKArg#685"[1], var"##MTKArg#685"[2], var"##MTKArg#685"[3])
                    ((var"##MTIIPVar#688"[1])[1])[1] = (*)(-2, (^)((inv)(c), 3), β, (+)((*)((exp)(z), (^)(k, (+)(-1, α))), (*)((log)(k), (exp)(z), α, (^)(k, (+)(-1, α)))))
                    ((var"##MTIIPVar#688"[1])[1])[7] = (+)((*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-2, α))), (*)((exp)(z), (^)((inv)(c), 2), β, (^)(k, (+)(-2, α)), (+)(-1, α)), (*)((log)(k), (exp)(z), (^)((inv)(c), 2), α, (+)(-1, α), β, (^)(k, (+)(-2, α))))
                    ((var"##MTIIPVar#688"[1])[1])[8] = (+)((*)((exp)(z), (^)((inv)(c), 2), β, (^)(k, (+)(-1, α))), (*)((log)(k), (exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-1, α))))
                    ((var"##MTIIPVar#688"[1])[1])[61] = (+)((*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-2, α))), (*)((exp)(z), (^)((inv)(c), 2), β, (^)(k, (+)(-2, α)), (+)(-1, α)), (*)((log)(k), (exp)(z), (^)((inv)(c), 2), α, (+)(-1, α), β, (^)(k, (+)(-2, α))))
                    ((var"##MTIIPVar#688"[1])[1])[67] = (+)((*)(-1, (exp)(z), (^)((inv)(c), 1), α, (+)(-1, α), β, (^)(k, (+)(-3, α))), (*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-3, α)), (+)(-2, α)), (*)(-1, (exp)(z), (^)((inv)(c), 1), (+)(-1, α), β, (^)(k, (+)(-3, α)), (+)(-2, α)), (*)(-1, (log)(k), (exp)(z), (^)((inv)(c), 1), α, (+)(-1, α), (+)(-2, α), β, (^)(k, (+)(-3, α))))
                    ((var"##MTIIPVar#688"[1])[1])[68] = (+)((*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-2, α))), (*)(-1, (exp)(z), (^)((inv)(c), 1), β, (^)(k, (+)(-2, α)), (+)(-1, α)), (*)(-1, (log)(k), (exp)(z), (^)((inv)(c), 1), α, (+)(-1, α), β, (^)(k, (+)(-2, α))))
                    ((var"##MTIIPVar#688"[1])[1])[71] = (+)((*)((exp)(z), (^)((inv)(c), 2), β, (^)(k, (+)(-1, α))), (*)((log)(k), (exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-1, α))))
                    ((var"##MTIIPVar#688"[1])[1])[77] = (+)((*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-2, α))), (*)(-1, (exp)(z), (^)((inv)(c), 1), β, (^)(k, (+)(-2, α)), (+)(-1, α)), (*)(-1, (log)(k), (exp)(z), (^)((inv)(c), 1), α, (+)(-1, α), β, (^)(k, (+)(-2, α))))
                    ((var"##MTIIPVar#688"[1])[1])[78] = (+)((*)(-1, (exp)(z), (^)((inv)(c), 1), β, (^)(k, (+)(-1, α))), (*)(-1, (log)(k), (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-1, α))))
                    ((var"##MTIIPVar#688"[1])[3])[89] = (+)((*)(-1, (exp)(z), α, (^)(k, (+)(-2, α))), (*)(-1, (exp)(z), (^)(k, (+)(-2, α)), (+)(-1, α)), (*)(-1, (log)(k), (exp)(z), α, (^)(k, (+)(-2, α)), (+)(-1, α)))
                    ((var"##MTIIPVar#688"[1])[3])[90] = (+)((*)(-1, (exp)(z), (^)(k, (+)(-1, α))), (*)(-1, (log)(k), (exp)(z), α, (^)(k, (+)(-1, α))))
                    ((var"##MTIIPVar#688"[1])[3])[99] = (+)((*)(-1, (exp)(z), (^)(k, (+)(-1, α))), (*)(-1, (log)(k), (exp)(z), α, (^)(k, (+)(-1, α))))
                    ((var"##MTIIPVar#688"[1])[3])[100] = (*)(-1, (log)(k), (exp)(z), (^)(k, α))
                    ((var"##MTIIPVar#688"[2])[1])[1] = (*)(-2, (+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 3))
                    ((var"##MTIIPVar#688"[2])[1])[7] = (*)((exp)(z), (^)((inv)(c), 2), α, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#688"[2])[1])[8] = (*)((exp)(z), (^)((inv)(c), 2), α, (^)(k, (+)(-1, α)))
                    ((var"##MTIIPVar#688"[2])[1])[61] = (*)((exp)(z), (^)((inv)(c), 2), α, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#688"[2])[1])[67] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (^)(k, (+)(-3, α)), (+)(-1, α), (+)(-2, α))
                    ((var"##MTIIPVar#688"[2])[1])[68] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#688"[2])[1])[71] = (*)((exp)(z), (^)((inv)(c), 2), α, (^)(k, (+)(-1, α)))
                    ((var"##MTIIPVar#688"[2])[1])[77] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#688"[2])[1])[78] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (^)(k, (+)(-1, α)))
                end
            end
        nothing
    end
const Ψ_yp! = (var"##MTIIPVar#697", var"##MTKArg#691", var"##MTKArg#692", var"##MTKArg#693", var"##MTKArg#694", var"##MTKArg#695")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#691"[1], var"##MTKArg#691"[2], var"##MTKArg#691"[3], var"##MTKArg#692"[1], var"##MTKArg#692"[2], var"##MTKArg#693"[1], var"##MTKArg#693"[2], var"##MTKArg#693"[3], var"##MTKArg#694"[1], var"##MTKArg#694"[2], var"##MTKArg#694"[3])
                    ((var"##MTIIPVar#697"[1])[1])[1] = (*)(6, (+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 4), β)
                    ((var"##MTIIPVar#697"[1])[1])[7] = (*)(-2, (exp)(z), (^)((inv)(c), 3), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#697"[1])[1])[8] = (*)(-2, (exp)(z), (^)((inv)(c), 3), α, β, (^)(k, (+)(-1, α)))
                    ((var"##MTIIPVar#697"[1])[1])[61] = (*)(-2, (exp)(z), (^)((inv)(c), 3), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#697"[1])[1])[67] = (*)((exp)(z), (^)((inv)(c), 2), α, (+)(-1, α), β, (^)(k, (+)(-3, α)), (+)(-2, α))
                    ((var"##MTIIPVar#697"[1])[1])[68] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#697"[1])[1])[71] = (*)(-2, (exp)(z), (^)((inv)(c), 3), α, β, (^)(k, (+)(-1, α)))
                    ((var"##MTIIPVar#697"[1])[1])[77] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#697"[1])[1])[78] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-1, α)))
                end
            end
        nothing
    end
const Ψ_y! = (var"##MTIIPVar#706", var"##MTKArg#700", var"##MTKArg#701", var"##MTKArg#702", var"##MTKArg#703", var"##MTKArg#704")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#700"[1], var"##MTKArg#700"[2], var"##MTKArg#700"[3], var"##MTKArg#701"[1], var"##MTKArg#701"[2], var"##MTKArg#702"[1], var"##MTKArg#702"[2], var"##MTKArg#702"[3], var"##MTKArg#703"[1], var"##MTKArg#703"[2], var"##MTKArg#703"[3])
                    ((var"##MTIIPVar#706"[1])[1])[34] = (*)(-6, (^)((inv)(c), 4))
                end
            end
        nothing
    end
const Ψ_xp! = (var"##MTIIPVar#715", var"##MTKArg#709", var"##MTKArg#710", var"##MTKArg#711", var"##MTKArg#712", var"##MTKArg#713")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#709"[1], var"##MTKArg#709"[2], var"##MTKArg#709"[3], var"##MTKArg#710"[1], var"##MTKArg#710"[2], var"##MTKArg#711"[1], var"##MTKArg#711"[2], var"##MTKArg#711"[3], var"##MTKArg#712"[1], var"##MTKArg#712"[2], var"##MTKArg#712"[3])
                    ((var"##MTIIPVar#715"[1])[1])[1] = (*)(-2, (exp)(z), (^)((inv)(c), 3), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#715"[1])[1])[7] = (*)((exp)(z), (^)((inv)(c), 2), α, (+)(-1, α), β, (^)(k, (+)(-3, α)), (+)(-2, α))
                    ((var"##MTIIPVar#715"[1])[1])[8] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#715"[1])[1])[61] = (*)((exp)(z), (^)((inv)(c), 2), α, (+)(-1, α), β, (^)(k, (+)(-3, α)), (+)(-2, α))
                    ((var"##MTIIPVar#715"[1])[1])[67] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (+)(-1, α), (+)(-2, α), β, (^)(k, (+)(-4, α)), (+)(-3, α))
                    ((var"##MTIIPVar#715"[1])[1])[68] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (+)(-1, α), β, (^)(k, (+)(-3, α)), (+)(-2, α))
                    ((var"##MTIIPVar#715"[1])[1])[71] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#715"[1])[1])[77] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (+)(-1, α), β, (^)(k, (+)(-3, α)), (+)(-2, α))
                    ((var"##MTIIPVar#715"[1])[1])[78] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#715"[2])[1])[1] = (*)(-2, (exp)(z), (^)((inv)(c), 3), α, β, (^)(k, (+)(-1, α)))
                    ((var"##MTIIPVar#715"[2])[1])[7] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#715"[2])[1])[8] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-1, α)))
                    ((var"##MTIIPVar#715"[2])[1])[61] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#715"[2])[1])[67] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (+)(-1, α), β, (^)(k, (+)(-3, α)), (+)(-2, α))
                    ((var"##MTIIPVar#715"[2])[1])[68] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#715"[2])[1])[71] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-1, α)))
                    ((var"##MTIIPVar#715"[2])[1])[77] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#715"[2])[1])[78] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-1, α)))
                end
            end
        nothing
    end
const Ψ_x! = (var"##MTIIPVar#724", var"##MTKArg#718", var"##MTKArg#719", var"##MTKArg#720", var"##MTKArg#721", var"##MTKArg#722")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#718"[1], var"##MTKArg#718"[2], var"##MTKArg#718"[3], var"##MTKArg#719"[1], var"##MTKArg#719"[2], var"##MTKArg#720"[1], var"##MTKArg#720"[2], var"##MTKArg#720"[3], var"##MTKArg#721"[1], var"##MTKArg#721"[2], var"##MTKArg#721"[3])
                    ((var"##MTIIPVar#724"[1])[3])[89] = (*)(-1, (exp)(z), α, (^)(k, (+)(-3, α)), (+)(-1, α), (+)(-2, α))
                    ((var"##MTIIPVar#724"[1])[3])[90] = (*)(-1, (exp)(z), α, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#724"[1])[3])[99] = (*)(-1, (exp)(z), α, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#724"[1])[3])[100] = (*)(-1, (exp)(z), α, (^)(k, (+)(-1, α)))
                    ((var"##MTIIPVar#724"[2])[3])[89] = (*)(-1, (exp)(z), α, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#724"[2])[3])[90] = (*)(-1, (exp)(z), α, (^)(k, (+)(-1, α)))
                    ((var"##MTIIPVar#724"[2])[3])[99] = (*)(-1, (exp)(z), α, (^)(k, (+)(-1, α)))
                    ((var"##MTIIPVar#724"[2])[3])[100] = (*)(-1, (exp)(z), (^)(k, α))
                end
            end
        nothing
    end
const H̄! = (var"##MTIIPVar#732", var"##MTKArg#727", var"##MTKArg#728", var"##MTKArg#729", var"##MTKArg#730")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#727"[1], var"##MTKArg#727"[2], var"##MTKArg#727"[3], var"##MTKArg#727"[4], var"##MTKArg#727"[5], var"##MTKArg#728"[1], var"##MTKArg#728"[2], var"##MTKArg#728"[3], var"##MTKArg#729"[1], var"##MTKArg#729"[2], var"##MTKArg#729"[3])
                    var"##MTIIPVar#732"[1] = (+)((^)((inv)(c), 1), (*)(-1, (+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 1), β))
                    var"##MTIIPVar#732"[2] = (+)(c, k, (*)(-1, (+)(q, (*)(k, (+)(1, (*)(-1, δ))))))
                    var"##MTIIPVar#732"[3] = (+)((*)(-1, (exp)(z), (^)(k, α)), q)
                    var"##MTIIPVar#732"[4] = (+)((*)(-1, z, ρ), z)
                    var"##MTIIPVar#732"[5] = (+)(i, (*)(-1, (+)((*)(-1, k, (+)(1, (*)(-1, δ))), k)))
                end
            end
        nothing
    end
const H̄_w! = (var"##MTIIPVar#740", var"##MTKArg#735", var"##MTKArg#736", var"##MTKArg#737", var"##MTKArg#738")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#735"[1], var"##MTKArg#735"[2], var"##MTKArg#735"[3], var"##MTKArg#735"[4], var"##MTKArg#735"[5], var"##MTKArg#736"[1], var"##MTKArg#736"[2], var"##MTKArg#736"[3], var"##MTKArg#737"[1], var"##MTKArg#737"[2], var"##MTKArg#737"[3])
                    var"##MTIIPVar#740"[1] = (+)((*)(-1, (^)((inv)(c), 2)), (*)((+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 2), β))
                    var"##MTIIPVar#740"[2] = 1
                    var"##MTIIPVar#740"[7] = -1
                    var"##MTIIPVar#740"[8] = 1
                    var"##MTIIPVar#740"[15] = 1
                    var"##MTIIPVar#740"[16] = (*)((*)((*)((*)(-1, (exp)(z)), (^)((inv)(c), 1)), α), (*)((*)(β, (^)(k, (+)(-2, α))), (+)(-1, α)))
                    var"##MTIIPVar#740"[17] = (+)(1, (*)(-1, (+)(1, (*)(-1, δ))))
                    var"##MTIIPVar#740"[18] = (*)(-1, (exp)(z), α, (^)(k, (+)(-1, α)))
                    var"##MTIIPVar#740"[20] = (*)(-1, (+)(1, (*)(-1, (+)(1, (*)(-1, δ)))))
                    var"##MTIIPVar#740"[21] = (*)((*)((*)((*)(-1, (exp)(z)), (^)((inv)(c), 1)), α), (*)(β, (^)(k, (+)(-1, α))))
                    var"##MTIIPVar#740"[23] = (*)(-1, (exp)(z), (^)(k, α))
                    var"##MTIIPVar#740"[24] = (+)(1, (*)(-1, ρ))
                end
            end
        nothing
    end
const ȳ_iv! = (var"##MTIIPVar#747", var"##MTKArg#743", var"##MTKArg#744", var"##MTKArg#745")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#743"[1], var"##MTKArg#743"[2], var"##MTKArg#743"[3], var"##MTKArg#744"[1], var"##MTKArg#744"[2], var"##MTKArg#744"[3])
                    var"##MTIIPVar#747"[1] = (-)((^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(α, (-)(α, 1))), (*)(δ, (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1)))))
                    var"##MTIIPVar#747"[2] = (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(α, (-)(α, 1)))
                    var"##MTIIPVar#747"[3] = (*)(δ, (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1))))
                end
            end
        nothing
    end
const x̄_iv! = (var"##MTIIPVar#754", var"##MTKArg#750", var"##MTKArg#751", var"##MTKArg#752")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#750"[1], var"##MTKArg#750"[2], var"##MTKArg#750"[3], var"##MTKArg#751"[1], var"##MTKArg#751"[2], var"##MTKArg#751"[3])
                    var"##MTIIPVar#754"[1] = (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1)))
                end
            end
        nothing
    end
const ȳ! = (var"##MTIIPVar#761", var"##MTKArg#757", var"##MTKArg#758", var"##MTKArg#759")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#757"[1], var"##MTKArg#757"[2], var"##MTKArg#757"[3], var"##MTKArg#758"[1], var"##MTKArg#758"[2], var"##MTKArg#758"[3])
                    var"##MTIIPVar#761"[1] = (-)((^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(α, (-)(α, 1))), (*)(δ, (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1)))))
                    var"##MTIIPVar#761"[2] = (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(α, (-)(α, 1)))
                    var"##MTIIPVar#761"[3] = (*)(δ, (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1))))
                end
            end
        nothing
    end
const x̄! = (var"##MTIIPVar#768", var"##MTKArg#764", var"##MTKArg#765", var"##MTKArg#766")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#764"[1], var"##MTKArg#764"[2], var"##MTKArg#764"[3], var"##MTKArg#765"[1], var"##MTKArg#765"[2], var"##MTKArg#765"[3])
                    var"##MTIIPVar#768"[1] = (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1)))
                end
            end
        nothing
    end
const ȳ_p! = (var"##MTIIPVar#775", var"##MTKArg#771", var"##MTKArg#772", var"##MTKArg#773")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#771"[1], var"##MTKArg#771"[2], var"##MTKArg#771"[3], var"##MTKArg#772"[1], var"##MTKArg#772"[2], var"##MTKArg#772"[3])
                    var"##MTIIPVar#775"[1] = (+)((*)(-1, δ, (+)((*)(-1, (log)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1))), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (^)((inv)((+)(-1, α)), 1)), (^)((inv)((+)(-1, α)), 2)), (*)((*)((*)((*)(-1, (+)(-1, (^)((inv)(β), 1), δ)), (^)((inv)(α), 2)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1)))), (*)((log)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1))), (+)((^)((inv)((+)(-1, α)), 1), (*)(-1, α, (^)((inv)((+)(-1, α)), 2))), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (*)(α, (^)((inv)((+)(-1, α)), 1)))), (*)((*)((*)((*)(-1, (+)(-1, (^)((inv)(β), 1), δ)), (^)((inv)(α), 1)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (*)(α, (^)((inv)((+)(-1, α)), 1))))), (^)((inv)((+)(-1, α)), 1)))
                    var"##MTIIPVar#775"[2] = (+)((*)((log)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1))), (+)((^)((inv)((+)(-1, α)), 1), (*)(-1, α, (^)((inv)((+)(-1, α)), 2))), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (*)(α, (^)((inv)((+)(-1, α)), 1)))), (*)((*)((*)((*)(-1, (+)(-1, (^)((inv)(β), 1), δ)), (^)((inv)(α), 1)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (*)(α, (^)((inv)((+)(-1, α)), 1))))), (^)((inv)((+)(-1, α)), 1)))
                    var"##MTIIPVar#775"[3] = (*)(δ, (+)((*)(-1, (log)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1))), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (^)((inv)((+)(-1, α)), 1)), (^)((inv)((+)(-1, α)), 2)), (*)((*)((*)((*)(-1, (+)(-1, (^)((inv)(β), 1), δ)), (^)((inv)(α), 2)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1))))
                    var"##MTIIPVar#775"[4] = (+)((*)(-1, (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (*)(α, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1), (^)((inv)(β), 2)), (*)((*)((*)((*)((^)((inv)(α), 1), δ), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1)), (^)((inv)(β), 2)))
                    var"##MTIIPVar#775"[5] = (*)(-1, (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (*)(α, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1), (^)((inv)(β), 2))
                    var"##MTIIPVar#775"[6] = (*)((*)((*)((*)(-1, (^)((inv)(α), 1)), δ), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (*)((^)((inv)((+)(-1, α)), 1), (^)((inv)(β), 2)))
                end
            end
        nothing
    end
const x̄_p! = (var"##MTIIPVar#782", var"##MTKArg#778", var"##MTKArg#779", var"##MTKArg#780")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#778"[1], var"##MTKArg#778"[2], var"##MTKArg#778"[3], var"##MTKArg#779"[1], var"##MTKArg#779"[2], var"##MTKArg#779"[3])
                    var"##MTIIPVar#782"[1] = (+)((*)(-1, (log)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1))), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (^)((inv)((+)(-1, α)), 1)), (^)((inv)((+)(-1, α)), 2)), (*)((*)((*)((*)(-1, (+)(-1, (^)((inv)(β), 1), δ)), (^)((inv)(α), 2)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1)))
                    var"##MTIIPVar#782"[3] = (*)((*)((*)((*)(-1, (^)((inv)(α), 1)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1)), (^)((inv)(β), 2))
                end
            end
        nothing
    end
const steady_state! = nothing
const allocate_solver_cache = m->begin
        #= /home/cameron/.julia/dev/DifferentiableStateSpaceModels/src/mtk_constructor.jl:680 =#
        SecondOrderSolverCache(m)
    end
const select_p_ss_hash = LinearAlgebra.UniformScaling{Bool}(true)
const select_p_f_ss_hash = LinearAlgebra.UniformScaling{Bool}(true)
const select_p_perturbation_hash = LinearAlgebra.UniformScaling{Bool}(true)
const select_p_f_perturbation_hash = LinearAlgebra.UniformScaling{Bool}(true)
end
