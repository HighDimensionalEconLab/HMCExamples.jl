function H!(ˍ₋out, ˍ₋arg1, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4, ˍ₋arg5, ˍ₋arg6, ˍ₋arg7; )
    let c_p = @inbounds(ˍ₋arg1[1]), q_p = @inbounds(ˍ₋arg1[2]), i_p = @inbounds(ˍ₋arg1[3]), c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), c_ss = @inbounds(ˍ₋arg3[1]), q_ss = @inbounds(ˍ₋arg3[2]), i_ss = @inbounds(ˍ₋arg3[3]), k_p = @inbounds(ˍ₋arg4[1]), z_p = @inbounds(ˍ₋arg4[2]), k = @inbounds(ˍ₋arg5[1]), z = @inbounds(ˍ₋arg5[2]), k_ss = @inbounds(ˍ₋arg6[1]), z_ss = @inbounds(ˍ₋arg6[2]), α = @inbounds(ˍ₋arg7[1]), β = @inbounds(ˍ₋arg7[2]), ρ = @inbounds(ˍ₋arg7[3]), δ = @inbounds(ˍ₋arg7[4]), σ = @inbounds(ˍ₋arg7[5]), Ω_1 = @inbounds(ˍ₋arg7[6])
        @inbounds begin
                ˍ₋out[1] = (+)((/)(1, c), (/)((*)(-1, β, (+)(1, (*)(-1, δ), (*)(α, (^)(k_p, (+)(-1, α)), (exp)(z_p)))), c_p))
                ˍ₋out[2] = (+)(c, k_p, (*)(-1, q), (*)(-1, k, (+)(1, (*)(-1, δ))))
                ˍ₋out[3] = (+)(q, (*)(-1, (^)(k, α), (exp)(z)))
                ˍ₋out[4] = (+)(z_p, (*)(-1, z, ρ))
                ˍ₋out[5] = (+)(i, (*)(-1, k_p), (*)(k, (+)(1, (*)(-1, δ))))
                nothing
            end
    end
end

function H_yp!(ˍ₋out, ˍ₋arg1, ˍ₋arg2, ˍ₋arg3; )
    let c = @inbounds(ˍ₋arg1[1]), q = @inbounds(ˍ₋arg1[2]), i = @inbounds(ˍ₋arg1[3]), k = @inbounds(ˍ₋arg2[1]), z = @inbounds(ˍ₋arg2[2]), α = @inbounds(ˍ₋arg3[1]), β = @inbounds(ˍ₋arg3[2]), ρ = @inbounds(ˍ₋arg3[3]), δ = @inbounds(ˍ₋arg3[4]), σ = @inbounds(ˍ₋arg3[5]), Ω_1 = @inbounds(ˍ₋arg3[6])
        @inbounds begin
                ˍ₋out[1] = (*)(-1, (/)((*)(-1, β, (+)(1, (*)(-1, δ), (*)(α, (^)(k, (+)(-1, α)), (exp)(z)))), (^)(c, 2)))
                nothing
            end
    end
end

function H_y!(ˍ₋out, ˍ₋arg1, ˍ₋arg2, ˍ₋arg3; )
    let c = @inbounds(ˍ₋arg1[1]), q = @inbounds(ˍ₋arg1[2]), i = @inbounds(ˍ₋arg1[3]), k = @inbounds(ˍ₋arg2[1]), z = @inbounds(ˍ₋arg2[2]), α = @inbounds(ˍ₋arg3[1]), β = @inbounds(ˍ₋arg3[2]), ρ = @inbounds(ˍ₋arg3[3]), δ = @inbounds(ˍ₋arg3[4]), σ = @inbounds(ˍ₋arg3[5]), Ω_1 = @inbounds(ˍ₋arg3[6])
        @inbounds begin
                ˍ₋out[1] = (*)(-1, (/)(1, (^)(c, 2)))
                ˍ₋out[2] = 1
                ˍ₋out[7] = -1
                ˍ₋out[8] = 1
                ˍ₋out[15] = 1
                nothing
            end
    end
end

function H_xp!(ˍ₋out, ˍ₋arg1, ˍ₋arg2, ˍ₋arg3; )
    let c = @inbounds(ˍ₋arg1[1]), q = @inbounds(ˍ₋arg1[2]), i = @inbounds(ˍ₋arg1[3]), k = @inbounds(ˍ₋arg2[1]), z = @inbounds(ˍ₋arg2[2]), α = @inbounds(ˍ₋arg3[1]), β = @inbounds(ˍ₋arg3[2]), ρ = @inbounds(ˍ₋arg3[3]), δ = @inbounds(ˍ₋arg3[4]), σ = @inbounds(ˍ₋arg3[5]), Ω_1 = @inbounds(ˍ₋arg3[6])
        @inbounds begin
                ˍ₋out[1] = (/)((*)(-1, α, β, (^)(k, (+)(-2, α)), (+)(-1, α), (exp)(z)), c)
                ˍ₋out[2] = 1
                ˍ₋out[5] = -1
                ˍ₋out[6] = (/)((*)(-1, α, β, (^)(k, (+)(-1, α)), (exp)(z)), c)
                ˍ₋out[9] = 1
                nothing
            end
    end
end

function H_x!(ˍ₋out, ˍ₋arg1, ˍ₋arg2, ˍ₋arg3; )
    let c = @inbounds(ˍ₋arg1[1]), q = @inbounds(ˍ₋arg1[2]), i = @inbounds(ˍ₋arg1[3]), k = @inbounds(ˍ₋arg2[1]), z = @inbounds(ˍ₋arg2[2]), α = @inbounds(ˍ₋arg3[1]), β = @inbounds(ˍ₋arg3[2]), ρ = @inbounds(ˍ₋arg3[3]), δ = @inbounds(ˍ₋arg3[4]), σ = @inbounds(ˍ₋arg3[5]), Ω_1 = @inbounds(ˍ₋arg3[6])
        @inbounds begin
                ˍ₋out[2] = (+)(-1, δ)
                ˍ₋out[3] = (*)(-1, α, (^)(k, (+)(-1, α)), (exp)(z))
                ˍ₋out[5] = (+)(1, (*)(-1, δ))
                ˍ₋out[8] = (*)(-1, (^)(k, α), (exp)(z))
                ˍ₋out[9] = (*)(-1, ρ)
                nothing
            end
    end
end

function Ψ!(ˍ₋out, ˍ₋arg1, ˍ₋arg2, ˍ₋arg3; )
    let c = @inbounds(ˍ₋arg1[1]), q = @inbounds(ˍ₋arg1[2]), i = @inbounds(ˍ₋arg1[3]), k = @inbounds(ˍ₋arg2[1]), z = @inbounds(ˍ₋arg2[2]), α = @inbounds(ˍ₋arg3[1]), β = @inbounds(ˍ₋arg3[2]), ρ = @inbounds(ˍ₋arg3[3]), δ = @inbounds(ˍ₋arg3[4]), σ = @inbounds(ˍ₋arg3[5]), Ω_1 = @inbounds(ˍ₋arg3[6])
        @inbounds begin
                nothing
            end
        begin
            @inbounds begin
                    (ˍ₋out[1])[1] = (*)(2, c, (/)((*)(-1, β, (+)(1, (*)(-1, δ), (*)(α, (^)(k, (+)(-1, α)), (exp)(z)))), (^)(c, 4)))
                    (ˍ₋out[1])[7] = (/)((*)(α, β, (^)(k, (+)(-2, α)), (+)(-1, α), (exp)(z)), (^)(c, 2))
                    (ˍ₋out[1])[8] = (/)((*)(α, β, (^)(k, (+)(-1, α)), (exp)(z)), (^)(c, 2))
                    (ˍ₋out[1])[34] = (*)(2, c, (/)(1, (^)(c, 4)))
                    (ˍ₋out[1])[61] = (/)((*)(α, β, (^)(k, (+)(-2, α)), (+)(-1, α), (exp)(z)), (^)(c, 2))
                    (ˍ₋out[1])[67] = (/)((*)(-1, α, β, (^)(k, (+)(-3, α)), (+)(-1, α), (+)(-2, α), (exp)(z)), c)
                    (ˍ₋out[1])[68] = (/)((*)(-1, α, β, (^)(k, (+)(-2, α)), (+)(-1, α), (exp)(z)), c)
                    (ˍ₋out[1])[71] = (/)((*)(α, β, (^)(k, (+)(-1, α)), (exp)(z)), (^)(c, 2))
                    (ˍ₋out[1])[77] = (/)((*)(-1, α, β, (^)(k, (+)(-2, α)), (+)(-1, α), (exp)(z)), c)
                    (ˍ₋out[1])[78] = (/)((*)(-1, α, β, (^)(k, (+)(-1, α)), (exp)(z)), c)
                    nothing
                end
        end
        begin
            @inbounds begin
                    nothing
                end
        end
        begin
            @inbounds begin
                    (ˍ₋out[3])[89] = (*)(-1, α, (^)(k, (+)(-2, α)), (+)(-1, α), (exp)(z))
                    (ˍ₋out[3])[90] = (*)(-1, α, (^)(k, (+)(-1, α)), (exp)(z))
                    (ˍ₋out[3])[99] = (*)(-1, α, (^)(k, (+)(-1, α)), (exp)(z))
                    (ˍ₋out[3])[100] = (*)(-1, (^)(k, α), (exp)(z))
                    nothing
                end
        end
        begin
            @inbounds begin
                    nothing
                end
        end
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function H_yp_p!(ˍ₋out, ::Val{:α}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                ˍ₋out[1] = (/)((*)(β, (+)((*)((^)(k, (+)(-1, α)), (exp)(z)), (*)(α, (^)(k, (+)(-1, α)), (log)(k), (exp)(z)))), (^)(c, 2))
                nothing
            end
    end
end

function H_yp_p!(ˍ₋out, ::Val{:ρ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                nothing
            end
    end
end

function H_yp_p!(ˍ₋out, ::Val{:σ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                nothing
            end
    end
end

function H_yp_p!(ˍ₋out, ::Val{:Ω_1}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                nothing
            end
    end
end

function H_yp_p!(ˍ₋out, ::Val{:δ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                ˍ₋out[1] = (/)((*)(-1, β), (^)(c, 2))
                nothing
            end
    end
end

function H_yp_p!(ˍ₋out, ::Val{:β}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                ˍ₋out[1] = (/)((+)(1, (*)(-1, δ), (*)(α, (^)(k, (+)(-1, α)), (exp)(z))), (^)(c, 2))
                nothing
            end
    end
end

function H_y_p!(ˍ₋out, ::Val{:α}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                nothing
            end
    end
end

function H_y_p!(ˍ₋out, ::Val{:ρ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                nothing
            end
    end
end

function H_y_p!(ˍ₋out, ::Val{:σ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                nothing
            end
    end
end

function H_y_p!(ˍ₋out, ::Val{:Ω_1}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                nothing
            end
    end
end

function H_y_p!(ˍ₋out, ::Val{:δ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                nothing
            end
    end
end

function H_y_p!(ˍ₋out, ::Val{:β}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                nothing
            end
    end
end

function H_xp_p!(ˍ₋out, ::Val{:α}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                ˍ₋out[1] = (/)((+)((*)(-1, α, β, (^)(k, (+)(-2, α)), (exp)(z)), (*)(-1, β, (^)(k, (+)(-2, α)), (+)(-1, α), (exp)(z)), (*)(-1, α, β, (^)(k, (+)(-2, α)), (+)(-1, α), (log)(k), (exp)(z))), c)
                ˍ₋out[6] = (/)((+)((*)(-1, β, (^)(k, (+)(-1, α)), (exp)(z)), (*)(-1, α, β, (^)(k, (+)(-1, α)), (log)(k), (exp)(z))), c)
                nothing
            end
    end
end

function H_xp_p!(ˍ₋out, ::Val{:ρ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                nothing
            end
    end
end

function H_xp_p!(ˍ₋out, ::Val{:σ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                nothing
            end
    end
end

function H_xp_p!(ˍ₋out, ::Val{:Ω_1}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                nothing
            end
    end
end

function H_xp_p!(ˍ₋out, ::Val{:δ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                nothing
            end
    end
end

function H_xp_p!(ˍ₋out, ::Val{:β}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                ˍ₋out[1] = (/)((*)(-1, α, (^)(k, (+)(-2, α)), (+)(-1, α), (exp)(z)), c)
                ˍ₋out[6] = (/)((*)(-1, α, (^)(k, (+)(-1, α)), (exp)(z)), c)
                nothing
            end
    end
end

function H_x_p!(ˍ₋out, ::Val{:α}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                ˍ₋out[3] = (+)((*)(-1, (^)(k, (+)(-1, α)), (exp)(z)), (*)(-1, α, (^)(k, (+)(-1, α)), (log)(k), (exp)(z)))
                ˍ₋out[8] = (*)(-1, (^)(k, α), (log)(k), (exp)(z))
                nothing
            end
    end
end

function H_x_p!(ˍ₋out, ::Val{:ρ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                ˍ₋out[9] = -1
                nothing
            end
    end
end

function H_x_p!(ˍ₋out, ::Val{:σ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                nothing
            end
    end
end

function H_x_p!(ˍ₋out, ::Val{:Ω_1}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                nothing
            end
    end
end

function H_x_p!(ˍ₋out, ::Val{:δ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                ˍ₋out[2] = 1
                ˍ₋out[5] = -1
                nothing
            end
    end
end

function H_x_p!(ˍ₋out, ::Val{:β}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                nothing
            end
    end
end

function H_p!(ˍ₋out, ::Val{:α}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                ˍ₋out[1] = (/)((*)(-1, β, (+)((*)((^)(k, (+)(-1, α)), (exp)(z)), (*)(α, (^)(k, (+)(-1, α)), (log)(k), (exp)(z)))), c)
                ˍ₋out[3] = (*)(-1, (^)(k, α), (log)(k), (exp)(z))
                nothing
            end
    end
end

function H_p!(ˍ₋out, ::Val{:ρ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                ˍ₋out[4] = (*)(-1, z)
                nothing
            end
    end
end

function H_p!(ˍ₋out, ::Val{:σ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                nothing
            end
    end
end

function H_p!(ˍ₋out, ::Val{:Ω_1}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                nothing
            end
    end
end

function H_p!(ˍ₋out, ::Val{:δ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                ˍ₋out[1] = (/)(β, c)
                ˍ₋out[2] = k
                ˍ₋out[5] = (*)(-1, k)
                nothing
            end
    end
end

function H_p!(ˍ₋out, ::Val{:β}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    let c = @inbounds(ˍ₋arg2[1]), q = @inbounds(ˍ₋arg2[2]), i = @inbounds(ˍ₋arg2[3]), k = @inbounds(ˍ₋arg3[1]), z = @inbounds(ˍ₋arg3[2]), α = @inbounds(ˍ₋arg4[1]), β = @inbounds(ˍ₋arg4[2]), ρ = @inbounds(ˍ₋arg4[3]), δ = @inbounds(ˍ₋arg4[4]), σ = @inbounds(ˍ₋arg4[5]), Ω_1 = @inbounds(ˍ₋arg4[6])
        @inbounds begin
                ˍ₋out[1] = (/)((+)(-1, δ, (*)(-1, α, (^)(k, (+)(-1, α)), (exp)(z))), c)
                nothing
            end
    end
end

