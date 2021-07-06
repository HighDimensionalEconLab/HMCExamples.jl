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
const Γ! = (var"##MTIIPVar#557", var"##MTKArg#553", var"##MTKArg#554", var"##MTKArg#555")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#553"[1], var"##MTKArg#553"[2], var"##MTKArg#553"[3], var"##MTKArg#554"[1], var"##MTKArg#554"[2], var"##MTKArg#554"[3])
                    var"##MTIIPVar#557"[1] = σ
                end
            end
        nothing
    end
const Γ_p! = (var"##MTIIPVar#564", var"##MTKArg#560", var"##MTKArg#561", var"##MTKArg#562")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#560"[1], var"##MTKArg#560"[2], var"##MTKArg#560"[3], var"##MTKArg#561"[1], var"##MTKArg#561"[2], var"##MTKArg#561"[3])
                end
            end
        nothing
    end
const Ω! = (var"##MTIIPVar#571", var"##MTKArg#567", var"##MTKArg#568", var"##MTKArg#569")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#567"[1], var"##MTKArg#567"[2], var"##MTKArg#567"[3], var"##MTKArg#568"[1], var"##MTKArg#568"[2], var"##MTKArg#568"[3])
                    var"##MTIIPVar#571"[1] = Ω_1
                    var"##MTIIPVar#571"[2] = Ω_1
                end
            end
        nothing
    end
const Ω_p! = (var"##MTIIPVar#578", var"##MTKArg#574", var"##MTKArg#575", var"##MTKArg#576")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#574"[1], var"##MTKArg#574"[2], var"##MTKArg#574"[3], var"##MTKArg#575"[1], var"##MTKArg#575"[2], var"##MTKArg#575"[3])
                end
            end
        nothing
    end
const H! = (var"##MTIIPVar#591", var"##MTKArg#581", var"##MTKArg#582", var"##MTKArg#583", var"##MTKArg#584", var"##MTKArg#585", var"##MTKArg#586", var"##MTKArg#587", var"##MTKArg#588", var"##MTKArg#589")->begin
        @inbounds begin
                let (c_p, q_p, i_p, c, q, i, c_ss, q_ss, i_ss, k_p, z_p, k, z, k_ss, z_ss, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#581"[1], var"##MTKArg#581"[2], var"##MTKArg#581"[3], var"##MTKArg#582"[1], var"##MTKArg#582"[2], var"##MTKArg#582"[3], var"##MTKArg#583"[1], var"##MTKArg#583"[2], var"##MTKArg#583"[3], var"##MTKArg#584"[1], var"##MTKArg#584"[2], var"##MTKArg#585"[1], var"##MTKArg#585"[2], var"##MTKArg#586"[1], var"##MTKArg#586"[2], var"##MTKArg#587"[1], var"##MTKArg#587"[2], var"##MTKArg#587"[3], var"##MTKArg#588"[1], var"##MTKArg#588"[2], var"##MTKArg#588"[3])
                    var"##MTIIPVar#591"[1] = (-)((/)(1, c), (*)((/)(β, c_p), (+)((*)((*)(α, (exp)(z_p)), (^)(k_p, (-)(α, 1))), (-)(1, δ))))
                    var"##MTIIPVar#591"[2] = (-)((-)((+)(c, k_p), (*)((-)(1, δ), k)), q)
                    var"##MTIIPVar#591"[3] = (-)(q, (*)((exp)(z), (^)(k, α)))
                    var"##MTIIPVar#591"[4] = (-)(z_p, (*)(ρ, z))
                    var"##MTIIPVar#591"[5] = (-)(i, (-)(k_p, (*)((-)(1, δ), k)))
                end
            end
        nothing
    end
const H_yp! = (var"##MTIIPVar#600", var"##MTKArg#594", var"##MTKArg#595", var"##MTKArg#596", var"##MTKArg#597", var"##MTKArg#598")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#594"[1], var"##MTKArg#594"[2], var"##MTKArg#594"[3], var"##MTKArg#595"[1], var"##MTKArg#595"[2], var"##MTKArg#596"[1], var"##MTKArg#596"[2], var"##MTKArg#596"[3], var"##MTKArg#597"[1], var"##MTKArg#597"[2], var"##MTKArg#597"[3])
                    var"##MTIIPVar#600"[1] = (*)((+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 2), β)
                end
            end
        nothing
    end
const H_y! = (var"##MTIIPVar#609", var"##MTKArg#603", var"##MTKArg#604", var"##MTKArg#605", var"##MTKArg#606", var"##MTKArg#607")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#603"[1], var"##MTKArg#603"[2], var"##MTKArg#603"[3], var"##MTKArg#604"[1], var"##MTKArg#604"[2], var"##MTKArg#605"[1], var"##MTKArg#605"[2], var"##MTKArg#605"[3], var"##MTKArg#606"[1], var"##MTKArg#606"[2], var"##MTKArg#606"[3])
                    var"##MTIIPVar#609"[1] = (*)(-1, (^)((inv)(c), 2))
                    var"##MTIIPVar#609"[2] = 1
                    var"##MTIIPVar#609"[7] = -1
                    var"##MTIIPVar#609"[8] = 1
                    var"##MTIIPVar#609"[15] = 1
                end
            end
        nothing
    end
const H_xp! = (var"##MTIIPVar#618", var"##MTKArg#612", var"##MTKArg#613", var"##MTKArg#614", var"##MTKArg#615", var"##MTKArg#616")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#612"[1], var"##MTKArg#612"[2], var"##MTKArg#612"[3], var"##MTKArg#613"[1], var"##MTKArg#613"[2], var"##MTKArg#614"[1], var"##MTKArg#614"[2], var"##MTKArg#614"[3], var"##MTKArg#615"[1], var"##MTKArg#615"[2], var"##MTKArg#615"[3])
                    var"##MTIIPVar#618"[1] = (*)((*)((*)((*)(-1, (exp)(z)), (^)((inv)(c), 1)), α), (*)((*)(β, (^)(k, (+)(-2, α))), (+)(-1, α)))
                    var"##MTIIPVar#618"[2] = 1
                    var"##MTIIPVar#618"[5] = -1
                    var"##MTIIPVar#618"[6] = (*)((*)((*)((*)(-1, (exp)(z)), (^)((inv)(c), 1)), α), (*)(β, (^)(k, (+)(-1, α))))
                    var"##MTIIPVar#618"[9] = 1
                end
            end
        nothing
    end
const H_x! = (var"##MTIIPVar#627", var"##MTKArg#621", var"##MTKArg#622", var"##MTKArg#623", var"##MTKArg#624", var"##MTKArg#625")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#621"[1], var"##MTKArg#621"[2], var"##MTKArg#621"[3], var"##MTKArg#622"[1], var"##MTKArg#622"[2], var"##MTKArg#623"[1], var"##MTKArg#623"[2], var"##MTKArg#623"[3], var"##MTKArg#624"[1], var"##MTKArg#624"[2], var"##MTKArg#624"[3])
                    var"##MTIIPVar#627"[2] = (*)(-1, (+)(1, (*)(-1, δ)))
                    var"##MTIIPVar#627"[3] = (*)(-1, (exp)(z), α, (^)(k, (+)(-1, α)))
                    var"##MTIIPVar#627"[5] = (+)(1, (*)(-1, δ))
                    var"##MTIIPVar#627"[8] = (*)(-1, (exp)(z), (^)(k, α))
                    var"##MTIIPVar#627"[9] = (*)(-1, ρ)
                end
            end
        nothing
    end
const H_yp_p! = (var"##MTIIPVar#636", var"##MTKArg#630", var"##MTKArg#631", var"##MTKArg#632", var"##MTKArg#633", var"##MTKArg#634")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#630"[1], var"##MTKArg#630"[2], var"##MTKArg#630"[3], var"##MTKArg#631"[1], var"##MTKArg#631"[2], var"##MTKArg#632"[1], var"##MTKArg#632"[2], var"##MTKArg#632"[3], var"##MTKArg#633"[1], var"##MTKArg#633"[2], var"##MTKArg#633"[3])
                    (var"##MTIIPVar#636"[1])[1] = (*)((^)((inv)(c), 2), β, (+)((*)((exp)(z), (^)(k, (+)(-1, α))), (*)((log)(k), (exp)(z), α, (^)(k, (+)(-1, α)))))
                    (var"##MTIIPVar#636"[2])[1] = (*)((+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 2))
                end
            end
        nothing
    end
const H_y_p! = (var"##MTIIPVar#645", var"##MTKArg#639", var"##MTKArg#640", var"##MTKArg#641", var"##MTKArg#642", var"##MTKArg#643")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#639"[1], var"##MTKArg#639"[2], var"##MTKArg#639"[3], var"##MTKArg#640"[1], var"##MTKArg#640"[2], var"##MTKArg#641"[1], var"##MTKArg#641"[2], var"##MTKArg#641"[3], var"##MTKArg#642"[1], var"##MTKArg#642"[2], var"##MTKArg#642"[3])
                end
            end
        nothing
    end
const H_xp_p! = (var"##MTIIPVar#654", var"##MTKArg#648", var"##MTKArg#649", var"##MTKArg#650", var"##MTKArg#651", var"##MTKArg#652")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#648"[1], var"##MTKArg#648"[2], var"##MTKArg#648"[3], var"##MTKArg#649"[1], var"##MTKArg#649"[2], var"##MTKArg#650"[1], var"##MTKArg#650"[2], var"##MTKArg#650"[3], var"##MTKArg#651"[1], var"##MTKArg#651"[2], var"##MTKArg#651"[3])
                    (var"##MTIIPVar#654"[1])[1] = (+)((*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-2, α))), (*)(-1, (exp)(z), (^)((inv)(c), 1), β, (^)(k, (+)(-2, α)), (+)(-1, α)), (*)(-1, (log)(k), (exp)(z), (^)((inv)(c), 1), α, (+)(-1, α), β, (^)(k, (+)(-2, α))))
                    (var"##MTIIPVar#654"[1])[6] = (+)((*)(-1, (exp)(z), (^)((inv)(c), 1), β, (^)(k, (+)(-1, α))), (*)(-1, (log)(k), (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-1, α))))
                    (var"##MTIIPVar#654"[2])[1] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#654"[2])[6] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (^)(k, (+)(-1, α)))
                end
            end
        nothing
    end
const H_x_p! = (var"##MTIIPVar#663", var"##MTKArg#657", var"##MTKArg#658", var"##MTKArg#659", var"##MTKArg#660", var"##MTKArg#661")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#657"[1], var"##MTKArg#657"[2], var"##MTKArg#657"[3], var"##MTKArg#658"[1], var"##MTKArg#658"[2], var"##MTKArg#659"[1], var"##MTKArg#659"[2], var"##MTKArg#659"[3], var"##MTKArg#660"[1], var"##MTKArg#660"[2], var"##MTKArg#660"[3])
                    (var"##MTIIPVar#663"[1])[3] = (+)((*)(-1, (exp)(z), (^)(k, (+)(-1, α))), (*)(-1, (log)(k), (exp)(z), α, (^)(k, (+)(-1, α))))
                    (var"##MTIIPVar#663"[1])[8] = (*)(-1, (log)(k), (exp)(z), (^)(k, α))
                    (var"##MTIIPVar#663"[3])[9] = -1
                end
            end
        nothing
    end
const H_p! = (var"##MTIIPVar#672", var"##MTKArg#666", var"##MTKArg#667", var"##MTKArg#668", var"##MTKArg#669", var"##MTKArg#670")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#666"[1], var"##MTKArg#666"[2], var"##MTKArg#666"[3], var"##MTKArg#667"[1], var"##MTKArg#667"[2], var"##MTKArg#668"[1], var"##MTKArg#668"[2], var"##MTKArg#668"[3], var"##MTKArg#669"[1], var"##MTKArg#669"[2], var"##MTKArg#669"[3])
                    var"##MTIIPVar#672"[1] = (*)(-1, (^)((inv)(c), 1), β, (+)((*)((exp)(z), (^)(k, (+)(-1, α))), (*)((log)(k), (exp)(z), α, (^)(k, (+)(-1, α)))))
                    var"##MTIIPVar#672"[3] = (*)(-1, (log)(k), (exp)(z), (^)(k, α))
                    var"##MTIIPVar#672"[6] = (*)(-1, (+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 1))
                    var"##MTIIPVar#672"[14] = (*)(-1, z)
                end
            end
        nothing
    end
const Ψ! = (var"##MTIIPVar#681", var"##MTKArg#675", var"##MTKArg#676", var"##MTKArg#677", var"##MTKArg#678", var"##MTKArg#679")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#675"[1], var"##MTKArg#675"[2], var"##MTKArg#675"[3], var"##MTKArg#676"[1], var"##MTKArg#676"[2], var"##MTKArg#677"[1], var"##MTKArg#677"[2], var"##MTKArg#677"[3], var"##MTKArg#678"[1], var"##MTKArg#678"[2], var"##MTKArg#678"[3])
                    (var"##MTIIPVar#681"[1])[1] = (*)(-2, (+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 3), β)
                    (var"##MTIIPVar#681"[1])[7] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#681"[1])[8] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-1, α)))
                    (var"##MTIIPVar#681"[1])[34] = (*)(2, (^)((inv)(c), 3))
                    (var"##MTIIPVar#681"[1])[61] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#681"[1])[67] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (+)(-1, α), β, (^)(k, (+)(-3, α)), (+)(-2, α))
                    (var"##MTIIPVar#681"[1])[68] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#681"[1])[71] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-1, α)))
                    (var"##MTIIPVar#681"[1])[77] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#681"[1])[78] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-1, α)))
                    (var"##MTIIPVar#681"[3])[89] = (*)(-1, (exp)(z), α, (^)(k, (+)(-2, α)), (+)(-1, α))
                    (var"##MTIIPVar#681"[3])[90] = (*)(-1, (exp)(z), α, (^)(k, (+)(-1, α)))
                    (var"##MTIIPVar#681"[3])[99] = (*)(-1, (exp)(z), α, (^)(k, (+)(-1, α)))
                    (var"##MTIIPVar#681"[3])[100] = (*)(-1, (exp)(z), (^)(k, α))
                end
            end
        nothing
    end
const Ψ_p! = (var"##MTIIPVar#690", var"##MTKArg#684", var"##MTKArg#685", var"##MTKArg#686", var"##MTKArg#687", var"##MTKArg#688")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#684"[1], var"##MTKArg#684"[2], var"##MTKArg#684"[3], var"##MTKArg#685"[1], var"##MTKArg#685"[2], var"##MTKArg#686"[1], var"##MTKArg#686"[2], var"##MTKArg#686"[3], var"##MTKArg#687"[1], var"##MTKArg#687"[2], var"##MTKArg#687"[3])
                    ((var"##MTIIPVar#690"[1])[1])[1] = (*)(-2, (^)((inv)(c), 3), β, (+)((*)((exp)(z), (^)(k, (+)(-1, α))), (*)((log)(k), (exp)(z), α, (^)(k, (+)(-1, α)))))
                    ((var"##MTIIPVar#690"[1])[1])[7] = (+)((*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-2, α))), (*)((exp)(z), (^)((inv)(c), 2), β, (^)(k, (+)(-2, α)), (+)(-1, α)), (*)((log)(k), (exp)(z), (^)((inv)(c), 2), α, (+)(-1, α), β, (^)(k, (+)(-2, α))))
                    ((var"##MTIIPVar#690"[1])[1])[8] = (+)((*)((exp)(z), (^)((inv)(c), 2), β, (^)(k, (+)(-1, α))), (*)((log)(k), (exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-1, α))))
                    ((var"##MTIIPVar#690"[1])[1])[61] = (+)((*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-2, α))), (*)((exp)(z), (^)((inv)(c), 2), β, (^)(k, (+)(-2, α)), (+)(-1, α)), (*)((log)(k), (exp)(z), (^)((inv)(c), 2), α, (+)(-1, α), β, (^)(k, (+)(-2, α))))
                    ((var"##MTIIPVar#690"[1])[1])[67] = (+)((*)(-1, (exp)(z), (^)((inv)(c), 1), α, (+)(-1, α), β, (^)(k, (+)(-3, α))), (*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-3, α)), (+)(-2, α)), (*)(-1, (exp)(z), (^)((inv)(c), 1), (+)(-1, α), β, (^)(k, (+)(-3, α)), (+)(-2, α)), (*)(-1, (log)(k), (exp)(z), (^)((inv)(c), 1), α, (+)(-1, α), (+)(-2, α), β, (^)(k, (+)(-3, α))))
                    ((var"##MTIIPVar#690"[1])[1])[68] = (+)((*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-2, α))), (*)(-1, (exp)(z), (^)((inv)(c), 1), β, (^)(k, (+)(-2, α)), (+)(-1, α)), (*)(-1, (log)(k), (exp)(z), (^)((inv)(c), 1), α, (+)(-1, α), β, (^)(k, (+)(-2, α))))
                    ((var"##MTIIPVar#690"[1])[1])[71] = (+)((*)((exp)(z), (^)((inv)(c), 2), β, (^)(k, (+)(-1, α))), (*)((log)(k), (exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-1, α))))
                    ((var"##MTIIPVar#690"[1])[1])[77] = (+)((*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-2, α))), (*)(-1, (exp)(z), (^)((inv)(c), 1), β, (^)(k, (+)(-2, α)), (+)(-1, α)), (*)(-1, (log)(k), (exp)(z), (^)((inv)(c), 1), α, (+)(-1, α), β, (^)(k, (+)(-2, α))))
                    ((var"##MTIIPVar#690"[1])[1])[78] = (+)((*)(-1, (exp)(z), (^)((inv)(c), 1), β, (^)(k, (+)(-1, α))), (*)(-1, (log)(k), (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-1, α))))
                    ((var"##MTIIPVar#690"[1])[3])[89] = (+)((*)(-1, (exp)(z), α, (^)(k, (+)(-2, α))), (*)(-1, (exp)(z), (^)(k, (+)(-2, α)), (+)(-1, α)), (*)(-1, (log)(k), (exp)(z), α, (^)(k, (+)(-2, α)), (+)(-1, α)))
                    ((var"##MTIIPVar#690"[1])[3])[90] = (+)((*)(-1, (exp)(z), (^)(k, (+)(-1, α))), (*)(-1, (log)(k), (exp)(z), α, (^)(k, (+)(-1, α))))
                    ((var"##MTIIPVar#690"[1])[3])[99] = (+)((*)(-1, (exp)(z), (^)(k, (+)(-1, α))), (*)(-1, (log)(k), (exp)(z), α, (^)(k, (+)(-1, α))))
                    ((var"##MTIIPVar#690"[1])[3])[100] = (*)(-1, (log)(k), (exp)(z), (^)(k, α))
                    ((var"##MTIIPVar#690"[2])[1])[1] = (*)(-2, (+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 3))
                    ((var"##MTIIPVar#690"[2])[1])[7] = (*)((exp)(z), (^)((inv)(c), 2), α, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#690"[2])[1])[8] = (*)((exp)(z), (^)((inv)(c), 2), α, (^)(k, (+)(-1, α)))
                    ((var"##MTIIPVar#690"[2])[1])[61] = (*)((exp)(z), (^)((inv)(c), 2), α, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#690"[2])[1])[67] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (^)(k, (+)(-3, α)), (+)(-1, α), (+)(-2, α))
                    ((var"##MTIIPVar#690"[2])[1])[68] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#690"[2])[1])[71] = (*)((exp)(z), (^)((inv)(c), 2), α, (^)(k, (+)(-1, α)))
                    ((var"##MTIIPVar#690"[2])[1])[77] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#690"[2])[1])[78] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (^)(k, (+)(-1, α)))
                end
            end
        nothing
    end
const Ψ_yp! = (var"##MTIIPVar#699", var"##MTKArg#693", var"##MTKArg#694", var"##MTKArg#695", var"##MTKArg#696", var"##MTKArg#697")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#693"[1], var"##MTKArg#693"[2], var"##MTKArg#693"[3], var"##MTKArg#694"[1], var"##MTKArg#694"[2], var"##MTKArg#695"[1], var"##MTKArg#695"[2], var"##MTKArg#695"[3], var"##MTKArg#696"[1], var"##MTKArg#696"[2], var"##MTKArg#696"[3])
                    ((var"##MTIIPVar#699"[1])[1])[1] = (*)(6, (+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 4), β)
                    ((var"##MTIIPVar#699"[1])[1])[7] = (*)(-2, (exp)(z), (^)((inv)(c), 3), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#699"[1])[1])[8] = (*)(-2, (exp)(z), (^)((inv)(c), 3), α, β, (^)(k, (+)(-1, α)))
                    ((var"##MTIIPVar#699"[1])[1])[61] = (*)(-2, (exp)(z), (^)((inv)(c), 3), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#699"[1])[1])[67] = (*)((exp)(z), (^)((inv)(c), 2), α, (+)(-1, α), β, (^)(k, (+)(-3, α)), (+)(-2, α))
                    ((var"##MTIIPVar#699"[1])[1])[68] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#699"[1])[1])[71] = (*)(-2, (exp)(z), (^)((inv)(c), 3), α, β, (^)(k, (+)(-1, α)))
                    ((var"##MTIIPVar#699"[1])[1])[77] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#699"[1])[1])[78] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-1, α)))
                end
            end
        nothing
    end
const Ψ_y! = (var"##MTIIPVar#708", var"##MTKArg#702", var"##MTKArg#703", var"##MTKArg#704", var"##MTKArg#705", var"##MTKArg#706")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#702"[1], var"##MTKArg#702"[2], var"##MTKArg#702"[3], var"##MTKArg#703"[1], var"##MTKArg#703"[2], var"##MTKArg#704"[1], var"##MTKArg#704"[2], var"##MTKArg#704"[3], var"##MTKArg#705"[1], var"##MTKArg#705"[2], var"##MTKArg#705"[3])
                    ((var"##MTIIPVar#708"[1])[1])[34] = (*)(-6, (^)((inv)(c), 4))
                end
            end
        nothing
    end
const Ψ_xp! = (var"##MTIIPVar#717", var"##MTKArg#711", var"##MTKArg#712", var"##MTKArg#713", var"##MTKArg#714", var"##MTKArg#715")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#711"[1], var"##MTKArg#711"[2], var"##MTKArg#711"[3], var"##MTKArg#712"[1], var"##MTKArg#712"[2], var"##MTKArg#713"[1], var"##MTKArg#713"[2], var"##MTKArg#713"[3], var"##MTKArg#714"[1], var"##MTKArg#714"[2], var"##MTKArg#714"[3])
                    ((var"##MTIIPVar#717"[1])[1])[1] = (*)(-2, (exp)(z), (^)((inv)(c), 3), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#717"[1])[1])[7] = (*)((exp)(z), (^)((inv)(c), 2), α, (+)(-1, α), β, (^)(k, (+)(-3, α)), (+)(-2, α))
                    ((var"##MTIIPVar#717"[1])[1])[8] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#717"[1])[1])[61] = (*)((exp)(z), (^)((inv)(c), 2), α, (+)(-1, α), β, (^)(k, (+)(-3, α)), (+)(-2, α))
                    ((var"##MTIIPVar#717"[1])[1])[67] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (+)(-1, α), (+)(-2, α), β, (^)(k, (+)(-4, α)), (+)(-3, α))
                    ((var"##MTIIPVar#717"[1])[1])[68] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (+)(-1, α), β, (^)(k, (+)(-3, α)), (+)(-2, α))
                    ((var"##MTIIPVar#717"[1])[1])[71] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#717"[1])[1])[77] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (+)(-1, α), β, (^)(k, (+)(-3, α)), (+)(-2, α))
                    ((var"##MTIIPVar#717"[1])[1])[78] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#717"[2])[1])[1] = (*)(-2, (exp)(z), (^)((inv)(c), 3), α, β, (^)(k, (+)(-1, α)))
                    ((var"##MTIIPVar#717"[2])[1])[7] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#717"[2])[1])[8] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-1, α)))
                    ((var"##MTIIPVar#717"[2])[1])[61] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#717"[2])[1])[67] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, (+)(-1, α), β, (^)(k, (+)(-3, α)), (+)(-2, α))
                    ((var"##MTIIPVar#717"[2])[1])[68] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#717"[2])[1])[71] = (*)((exp)(z), (^)((inv)(c), 2), α, β, (^)(k, (+)(-1, α)))
                    ((var"##MTIIPVar#717"[2])[1])[77] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#717"[2])[1])[78] = (*)(-1, (exp)(z), (^)((inv)(c), 1), α, β, (^)(k, (+)(-1, α)))
                end
            end
        nothing
    end
const Ψ_x! = (var"##MTIIPVar#726", var"##MTKArg#720", var"##MTKArg#721", var"##MTKArg#722", var"##MTKArg#723", var"##MTKArg#724")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#720"[1], var"##MTKArg#720"[2], var"##MTKArg#720"[3], var"##MTKArg#721"[1], var"##MTKArg#721"[2], var"##MTKArg#722"[1], var"##MTKArg#722"[2], var"##MTKArg#722"[3], var"##MTKArg#723"[1], var"##MTKArg#723"[2], var"##MTKArg#723"[3])
                    ((var"##MTIIPVar#726"[1])[3])[89] = (*)(-1, (exp)(z), α, (^)(k, (+)(-3, α)), (+)(-1, α), (+)(-2, α))
                    ((var"##MTIIPVar#726"[1])[3])[90] = (*)(-1, (exp)(z), α, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#726"[1])[3])[99] = (*)(-1, (exp)(z), α, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#726"[1])[3])[100] = (*)(-1, (exp)(z), α, (^)(k, (+)(-1, α)))
                    ((var"##MTIIPVar#726"[2])[3])[89] = (*)(-1, (exp)(z), α, (^)(k, (+)(-2, α)), (+)(-1, α))
                    ((var"##MTIIPVar#726"[2])[3])[90] = (*)(-1, (exp)(z), α, (^)(k, (+)(-1, α)))
                    ((var"##MTIIPVar#726"[2])[3])[99] = (*)(-1, (exp)(z), α, (^)(k, (+)(-1, α)))
                    ((var"##MTIIPVar#726"[2])[3])[100] = (*)(-1, (exp)(z), (^)(k, α))
                end
            end
        nothing
    end
const H̄! = (var"##MTIIPVar#734", var"##MTKArg#729", var"##MTKArg#730", var"##MTKArg#731", var"##MTKArg#732")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#729"[1], var"##MTKArg#729"[2], var"##MTKArg#729"[3], var"##MTKArg#729"[4], var"##MTKArg#729"[5], var"##MTKArg#730"[1], var"##MTKArg#730"[2], var"##MTKArg#730"[3], var"##MTKArg#731"[1], var"##MTKArg#731"[2], var"##MTKArg#731"[3])
                    var"##MTIIPVar#734"[1] = (+)((^)((inv)(c), 1), (*)(-1, (+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 1), β))
                    var"##MTIIPVar#734"[2] = (+)(c, k, (*)(-1, (+)(q, (*)(k, (+)(1, (*)(-1, δ))))))
                    var"##MTIIPVar#734"[3] = (+)((*)(-1, (exp)(z), (^)(k, α)), q)
                    var"##MTIIPVar#734"[4] = (+)((*)(-1, z, ρ), z)
                    var"##MTIIPVar#734"[5] = (+)(i, (*)(-1, (+)((*)(-1, k, (+)(1, (*)(-1, δ))), k)))
                end
            end
        nothing
    end
const H̄_w! = (var"##MTIIPVar#742", var"##MTKArg#737", var"##MTKArg#738", var"##MTKArg#739", var"##MTKArg#740")->begin
        @inbounds begin
                let (c, q, i, k, z, α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#737"[1], var"##MTKArg#737"[2], var"##MTKArg#737"[3], var"##MTKArg#737"[4], var"##MTKArg#737"[5], var"##MTKArg#738"[1], var"##MTKArg#738"[2], var"##MTKArg#738"[3], var"##MTKArg#739"[1], var"##MTKArg#739"[2], var"##MTKArg#739"[3])
                    var"##MTIIPVar#742"[1] = (+)((*)(-1, (^)((inv)(c), 2)), (*)((+)(1, (*)(-1, δ), (*)((exp)(z), α, (^)(k, (+)(-1, α)))), (^)((inv)(c), 2), β))
                    var"##MTIIPVar#742"[2] = 1
                    var"##MTIIPVar#742"[7] = -1
                    var"##MTIIPVar#742"[8] = 1
                    var"##MTIIPVar#742"[15] = 1
                    var"##MTIIPVar#742"[16] = (*)((*)((*)((*)(-1, (exp)(z)), (^)((inv)(c), 1)), α), (*)((*)(β, (^)(k, (+)(-2, α))), (+)(-1, α)))
                    var"##MTIIPVar#742"[17] = (+)(1, (*)(-1, (+)(1, (*)(-1, δ))))
                    var"##MTIIPVar#742"[18] = (*)(-1, (exp)(z), α, (^)(k, (+)(-1, α)))
                    var"##MTIIPVar#742"[20] = (*)(-1, (+)(1, (*)(-1, (+)(1, (*)(-1, δ)))))
                    var"##MTIIPVar#742"[21] = (*)((*)((*)((*)(-1, (exp)(z)), (^)((inv)(c), 1)), α), (*)(β, (^)(k, (+)(-1, α))))
                    var"##MTIIPVar#742"[23] = (*)(-1, (exp)(z), (^)(k, α))
                    var"##MTIIPVar#742"[24] = (+)(1, (*)(-1, ρ))
                end
            end
        nothing
    end
const ȳ_iv! = (var"##MTIIPVar#749", var"##MTKArg#745", var"##MTKArg#746", var"##MTKArg#747")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#745"[1], var"##MTKArg#745"[2], var"##MTKArg#745"[3], var"##MTKArg#746"[1], var"##MTKArg#746"[2], var"##MTKArg#746"[3])
                    var"##MTIIPVar#749"[1] = (-)((^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(α, (-)(α, 1))), (*)(δ, (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1)))))
                    var"##MTIIPVar#749"[2] = (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(α, (-)(α, 1)))
                    var"##MTIIPVar#749"[3] = (*)(δ, (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1))))
                end
            end
        nothing
    end
const x̄_iv! = (var"##MTIIPVar#756", var"##MTKArg#752", var"##MTKArg#753", var"##MTKArg#754")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#752"[1], var"##MTKArg#752"[2], var"##MTKArg#752"[3], var"##MTKArg#753"[1], var"##MTKArg#753"[2], var"##MTKArg#753"[3])
                    var"##MTIIPVar#756"[1] = (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1)))
                end
            end
        nothing
    end
const ȳ! = (var"##MTIIPVar#763", var"##MTKArg#759", var"##MTKArg#760", var"##MTKArg#761")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#759"[1], var"##MTKArg#759"[2], var"##MTKArg#759"[3], var"##MTKArg#760"[1], var"##MTKArg#760"[2], var"##MTKArg#760"[3])
                    var"##MTIIPVar#763"[1] = (-)((^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(α, (-)(α, 1))), (*)(δ, (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1)))))
                    var"##MTIIPVar#763"[2] = (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(α, (-)(α, 1)))
                    var"##MTIIPVar#763"[3] = (*)(δ, (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1))))
                end
            end
        nothing
    end
const x̄! = (var"##MTIIPVar#770", var"##MTKArg#766", var"##MTKArg#767", var"##MTKArg#768")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#766"[1], var"##MTKArg#766"[2], var"##MTKArg#766"[3], var"##MTKArg#767"[1], var"##MTKArg#767"[2], var"##MTKArg#767"[3])
                    var"##MTIIPVar#770"[1] = (^)((/)((+)((-)((/)(1, β), 1), δ), α), (/)(1, (-)(α, 1)))
                end
            end
        nothing
    end
const ȳ_p! = (var"##MTIIPVar#777", var"##MTKArg#773", var"##MTKArg#774", var"##MTKArg#775")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#773"[1], var"##MTKArg#773"[2], var"##MTKArg#773"[3], var"##MTKArg#774"[1], var"##MTKArg#774"[2], var"##MTKArg#774"[3])
                    var"##MTIIPVar#777"[1] = (+)((*)(-1, δ, (+)((*)(-1, (log)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1))), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (^)((inv)((+)(-1, α)), 1)), (^)((inv)((+)(-1, α)), 2)), (*)((*)((*)((*)(-1, (+)(-1, (^)((inv)(β), 1), δ)), (^)((inv)(α), 2)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1)))), (*)((log)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1))), (+)((^)((inv)((+)(-1, α)), 1), (*)(-1, α, (^)((inv)((+)(-1, α)), 2))), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (*)(α, (^)((inv)((+)(-1, α)), 1)))), (*)((*)((*)((*)(-1, (+)(-1, (^)((inv)(β), 1), δ)), (^)((inv)(α), 1)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (*)(α, (^)((inv)((+)(-1, α)), 1))))), (^)((inv)((+)(-1, α)), 1)))
                    var"##MTIIPVar#777"[2] = (+)((*)((log)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1))), (+)((^)((inv)((+)(-1, α)), 1), (*)(-1, α, (^)((inv)((+)(-1, α)), 2))), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (*)(α, (^)((inv)((+)(-1, α)), 1)))), (*)((*)((*)((*)(-1, (+)(-1, (^)((inv)(β), 1), δ)), (^)((inv)(α), 1)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (*)(α, (^)((inv)((+)(-1, α)), 1))))), (^)((inv)((+)(-1, α)), 1)))
                    var"##MTIIPVar#777"[3] = (*)(δ, (+)((*)(-1, (log)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1))), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (^)((inv)((+)(-1, α)), 1)), (^)((inv)((+)(-1, α)), 2)), (*)((*)((*)((*)(-1, (+)(-1, (^)((inv)(β), 1), δ)), (^)((inv)(α), 2)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1))))
                    var"##MTIIPVar#777"[4] = (+)((*)(-1, (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (*)(α, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1), (^)((inv)(β), 2)), (*)((*)((*)((*)((^)((inv)(α), 1), δ), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1)), (^)((inv)(β), 2)))
                    var"##MTIIPVar#777"[5] = (*)(-1, (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (*)(α, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1), (^)((inv)(β), 2))
                    var"##MTIIPVar#777"[6] = (*)((*)((*)((*)(-1, (^)((inv)(α), 1)), δ), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (*)((^)((inv)((+)(-1, α)), 1), (^)((inv)(β), 2)))
                end
            end
        nothing
    end
const x̄_p! = (var"##MTIIPVar#784", var"##MTKArg#780", var"##MTKArg#781", var"##MTKArg#782")->begin
        @inbounds begin
                let (α, β, ρ, δ, σ, Ω_1) = (var"##MTKArg#780"[1], var"##MTKArg#780"[2], var"##MTKArg#780"[3], var"##MTKArg#781"[1], var"##MTKArg#781"[2], var"##MTKArg#781"[3])
                    var"##MTIIPVar#784"[1] = (+)((*)(-1, (log)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1))), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (^)((inv)((+)(-1, α)), 1)), (^)((inv)((+)(-1, α)), 2)), (*)((*)((*)((*)(-1, (+)(-1, (^)((inv)(β), 1), δ)), (^)((inv)(α), 2)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1)))
                    var"##MTIIPVar#784"[3] = (*)((*)((*)((*)(-1, (^)((inv)(α), 1)), (^)((*)((+)(-1, (^)((inv)(β), 1), δ), (^)((inv)(α), 1)), (+)(-1, (^)((inv)((+)(-1, α)), 1)))), (^)((inv)((+)(-1, α)), 1)), (^)((inv)(β), 2))
                end
            end
        nothing
    end
const steady_state! = nothing
const allocate_solver_cache = m->begin
        #= C:\Google Drive\Projects\HMCDSGE\src\mtk_constructor.jl:512 =#
        SecondOrderSolverCache(m)
    end
const select_p_ss_hash = LinearAlgebra.UniformScaling{Bool}(true)
const select_p_f_ss_hash = LinearAlgebra.UniformScaling{Bool}(true)
const select_p_perturbation_hash = LinearAlgebra.UniformScaling{Bool}(true)
const select_p_f_perturbation_hash = LinearAlgebra.UniformScaling{Bool}(true)
end
