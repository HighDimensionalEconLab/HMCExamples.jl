function H!(ˍ₋out, ˍ₋arg1, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4, ˍ₋arg5, ˍ₋arg6, ˍ₋arg7; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[1] = (/)((+)((+)((+)(ˍ₋arg1[1], (*)((*)(-1, ˍ₋arg2[1]), ˍ₋arg7[2])), (*)((*)(ˍ₋arg2[1], ˍ₋arg7[2]), ˍ₋arg7[4])), (*)((*)((*)((*)((*)(-1, ˍ₋arg2[1]), ˍ₋arg7[1]), ˍ₋arg7[2]), (^)(ˍ₋arg4[1], (+)(-1, ˍ₋arg7[1]))), (exp)(ˍ₋arg4[2]))), (*)(ˍ₋arg2[1], ˍ₋arg1[1]))
                    ˍ₋out[2] = (+)((+)((+)(ˍ₋arg2[1], ˍ₋arg4[1]), (*)(-1, ˍ₋arg2[2])), (*)((*)(-1, ˍ₋arg5[1]), (+)(1, (*)(-1, ˍ₋arg7[4]))))
                    ˍ₋out[3] = (+)(ˍ₋arg2[2], (*)((*)(-1, (^)(ˍ₋arg5[1], ˍ₋arg7[1])), (exp)(ˍ₋arg5[2])))
                    ˍ₋out[4] = (+)(ˍ₋arg4[2], (*)((*)(-1, ˍ₋arg5[2]), ˍ₋arg7[3]))
                    nothing
                end
        end
    end
end

function H_yp!(ˍ₋out, ˍ₋arg1, ˍ₋arg2, ˍ₋arg3; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[1] = (/)((*)(ˍ₋arg3[2], (+)((+)(1, (*)(-1, ˍ₋arg3[4])), (*)((*)(ˍ₋arg3[1], (^)(ˍ₋arg2[1], (+)(-1, ˍ₋arg3[1]))), (exp)(ˍ₋arg2[2])))), (^)(ˍ₋arg1[1], 2))
                    nothing
                end
        end
    end
end

function H_y!(ˍ₋out, ˍ₋arg1, ˍ₋arg2, ˍ₋arg3; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[1] = (*)(-1, (/)(1, (^)(ˍ₋arg1[1], 2)))
                    ˍ₋out[2] = 1
                    ˍ₋out[6] = -1
                    ˍ₋out[7] = 1
                    nothing
                end
        end
    end
end

function H_xp!(ˍ₋out, ˍ₋arg1, ˍ₋arg2, ˍ₋arg3; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[1] = (/)((*)((*)((*)((*)(ˍ₋arg3[1], ˍ₋arg3[2]), (^)(ˍ₋arg2[1], (+)(-2, ˍ₋arg3[1]))), (+)(1, (*)(-1, ˍ₋arg3[1]))), (exp)(ˍ₋arg2[2])), ˍ₋arg1[1])
                    ˍ₋out[2] = 1
                    ˍ₋out[5] = (/)((*)((*)((*)((*)(-1, ˍ₋arg3[1]), ˍ₋arg3[2]), (^)(ˍ₋arg2[1], (+)(-1, ˍ₋arg3[1]))), (exp)(ˍ₋arg2[2])), ˍ₋arg1[1])
                    ˍ₋out[8] = 1
                    nothing
                end
        end
    end
end

function H_x!(ˍ₋out, ˍ₋arg1, ˍ₋arg2, ˍ₋arg3; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[2] = (+)(-1, ˍ₋arg3[4])
                    ˍ₋out[3] = (*)((*)((*)(-1, ˍ₋arg3[1]), (^)(ˍ₋arg2[1], (+)(-1, ˍ₋arg3[1]))), (exp)(ˍ₋arg2[2]))
                    ˍ₋out[7] = (*)((*)(-1, (^)(ˍ₋arg2[1], ˍ₋arg3[1])), (exp)(ˍ₋arg2[2]))
                    ˍ₋out[8] = (*)(-1, ˍ₋arg3[3])
                    nothing
                end
        end
    end
end

function Ψ!(ˍ₋out, ˍ₋arg1, ˍ₋arg2, ˍ₋arg3; )
    begin
        begin
            @inbounds begin
                    nothing
                end
            begin
                @inbounds begin
                        (ˍ₋out[1])[1] = (/)((*)(ˍ₋arg3[2], (+)((+)(-2, (*)(2, ˍ₋arg3[4])), (*)((*)((*)(-2, ˍ₋arg3[1]), (^)(ˍ₋arg2[1], (+)(-1, ˍ₋arg3[1]))), (exp)(ˍ₋arg2[2])))), (^)(ˍ₋arg1[1], 3))
                        (ˍ₋out[1])[5] = (/)((*)((*)((*)((*)(ˍ₋arg3[1], ˍ₋arg3[2]), (^)(ˍ₋arg2[1], (+)(-2, ˍ₋arg3[1]))), (+)(-1, ˍ₋arg3[1])), (exp)(ˍ₋arg2[2])), (^)(ˍ₋arg1[1], 2))
                        (ˍ₋out[1])[6] = (/)((*)((*)((*)(ˍ₋arg3[1], ˍ₋arg3[2]), (^)(ˍ₋arg2[1], (+)(-1, ˍ₋arg3[1]))), (exp)(ˍ₋arg2[2])), (^)(ˍ₋arg1[1], 2))
                        (ˍ₋out[1])[19] = (*)((*)(2, ˍ₋arg1[1]), (/)(1, (^)(ˍ₋arg1[1], 4)))
                        (ˍ₋out[1])[33] = (/)((*)((*)((*)((*)(ˍ₋arg3[1], ˍ₋arg3[2]), (^)(ˍ₋arg2[1], (+)(-2, ˍ₋arg3[1]))), (+)(-1, ˍ₋arg3[1])), (exp)(ˍ₋arg2[2])), (^)(ˍ₋arg1[1], 2))
                        (ˍ₋out[1])[37] = (/)((*)((*)((*)((*)((*)(ˍ₋arg3[1], ˍ₋arg3[2]), (^)(ˍ₋arg2[1], (+)(-3, ˍ₋arg3[1]))), (+)(1, (*)(-1, ˍ₋arg3[1]))), (+)(-2, ˍ₋arg3[1])), (exp)(ˍ₋arg2[2])), ˍ₋arg1[1])
                        (ˍ₋out[1])[38] = (/)((*)((*)((*)((*)(ˍ₋arg3[1], ˍ₋arg3[2]), (^)(ˍ₋arg2[1], (+)(-2, ˍ₋arg3[1]))), (+)(1, (*)(-1, ˍ₋arg3[1]))), (exp)(ˍ₋arg2[2])), ˍ₋arg1[1])
                        (ˍ₋out[1])[41] = (/)((*)((*)((*)(ˍ₋arg3[1], ˍ₋arg3[2]), (^)(ˍ₋arg2[1], (+)(-1, ˍ₋arg3[1]))), (exp)(ˍ₋arg2[2])), (^)(ˍ₋arg1[1], 2))
                        (ˍ₋out[1])[45] = (/)((*)((*)((*)((*)(ˍ₋arg3[1], ˍ₋arg3[2]), (^)(ˍ₋arg2[1], (+)(-2, ˍ₋arg3[1]))), (+)(1, (*)(-1, ˍ₋arg3[1]))), (exp)(ˍ₋arg2[2])), ˍ₋arg1[1])
                        (ˍ₋out[1])[46] = (/)((*)((*)((*)((*)(-1, ˍ₋arg3[1]), ˍ₋arg3[2]), (^)(ˍ₋arg2[1], (+)(-1, ˍ₋arg3[1]))), (exp)(ˍ₋arg2[2])), ˍ₋arg1[1])
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
                        (ˍ₋out[3])[55] = (*)((*)((*)((*)(-1, ˍ₋arg3[1]), (^)(ˍ₋arg2[1], (+)(-2, ˍ₋arg3[1]))), (+)(-1, ˍ₋arg3[1])), (exp)(ˍ₋arg2[2]))
                        (ˍ₋out[3])[56] = (*)((*)((*)(-1, ˍ₋arg3[1]), (^)(ˍ₋arg2[1], (+)(-1, ˍ₋arg3[1]))), (exp)(ˍ₋arg2[2]))
                        (ˍ₋out[3])[63] = (*)((*)((*)(-1, ˍ₋arg3[1]), (^)(ˍ₋arg2[1], (+)(-1, ˍ₋arg3[1]))), (exp)(ˍ₋arg2[2]))
                        (ˍ₋out[3])[64] = (*)((*)(-1, (^)(ˍ₋arg2[1], ˍ₋arg3[1])), (exp)(ˍ₋arg2[2]))
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
end

function H_yp_p!(ˍ₋out, ::Val{:α}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[1] = (/)((*)(ˍ₋arg4[2], (+)((*)((^)(ˍ₋arg3[1], (+)(-1, ˍ₋arg4[1])), (exp)(ˍ₋arg3[2])), (*)((*)((*)(ˍ₋arg4[1], (^)(ˍ₋arg3[1], (+)(-1, ˍ₋arg4[1]))), (log)(ˍ₋arg3[1])), (exp)(ˍ₋arg3[2])))), (^)(ˍ₋arg2[1], 2))
                    nothing
                end
        end
    end
end

function H_yp_p!(ˍ₋out, ::Val{:ρ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function H_yp_p!(ˍ₋out, ::Val{:σ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function H_yp_p!(ˍ₋out, ::Val{:Ω_1}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function H_yp_p!(ˍ₋out, ::Val{:δ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[1] = (/)((*)(-1, ˍ₋arg4[2]), (^)(ˍ₋arg2[1], 2))
                    nothing
                end
        end
    end
end

function H_yp_p!(ˍ₋out, ::Val{:β}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[1] = (/)((+)((+)(1, (*)(-1, ˍ₋arg4[4])), (*)((*)(ˍ₋arg4[1], (^)(ˍ₋arg3[1], (+)(-1, ˍ₋arg4[1]))), (exp)(ˍ₋arg3[2]))), (^)(ˍ₋arg2[1], 2))
                    nothing
                end
        end
    end
end

function H_y_p!(ˍ₋out, ::Val{:α}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function H_y_p!(ˍ₋out, ::Val{:ρ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function H_y_p!(ˍ₋out, ::Val{:σ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function H_y_p!(ˍ₋out, ::Val{:Ω_1}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function H_y_p!(ˍ₋out, ::Val{:δ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function H_y_p!(ˍ₋out, ::Val{:β}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function H_xp_p!(ˍ₋out, ::Val{:α}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[1] = (/)((+)((+)((+)((*)((*)(ˍ₋arg4[2], (^)(ˍ₋arg3[1], (+)(-2, ˍ₋arg4[1]))), (exp)(ˍ₋arg3[2])), (*)((*)((*)((*)(-2, ˍ₋arg4[1]), ˍ₋arg4[2]), (^)(ˍ₋arg3[1], (+)(-2, ˍ₋arg4[1]))), (exp)(ˍ₋arg3[2]))), (*)((*)((*)((*)(ˍ₋arg4[1], ˍ₋arg4[2]), (^)(ˍ₋arg3[1], (+)(-2, ˍ₋arg4[1]))), (log)(ˍ₋arg3[1])), (exp)(ˍ₋arg3[2]))), (*)((*)((*)((*)((*)(-1, ˍ₋arg4[2]), (^)(ˍ₋arg3[1], (+)(-2, ˍ₋arg4[1]))), (^)(ˍ₋arg4[1], 2)), (log)(ˍ₋arg3[1])), (exp)(ˍ₋arg3[2]))), ˍ₋arg2[1])
                    ˍ₋out[5] = (/)((+)((*)((*)((*)(-1, ˍ₋arg4[2]), (^)(ˍ₋arg3[1], (+)(-1, ˍ₋arg4[1]))), (exp)(ˍ₋arg3[2])), (*)((*)((*)((*)((*)(-1, ˍ₋arg4[1]), ˍ₋arg4[2]), (^)(ˍ₋arg3[1], (+)(-1, ˍ₋arg4[1]))), (log)(ˍ₋arg3[1])), (exp)(ˍ₋arg3[2]))), ˍ₋arg2[1])
                    nothing
                end
        end
    end
end

function H_xp_p!(ˍ₋out, ::Val{:ρ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function H_xp_p!(ˍ₋out, ::Val{:σ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function H_xp_p!(ˍ₋out, ::Val{:Ω_1}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function H_xp_p!(ˍ₋out, ::Val{:δ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function H_xp_p!(ˍ₋out, ::Val{:β}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[1] = (/)((*)((*)((*)(ˍ₋arg4[1], (^)(ˍ₋arg3[1], (+)(-2, ˍ₋arg4[1]))), (+)(1, (*)(-1, ˍ₋arg4[1]))), (exp)(ˍ₋arg3[2])), ˍ₋arg2[1])
                    ˍ₋out[5] = (/)((*)((*)((*)(-1, ˍ₋arg4[1]), (^)(ˍ₋arg3[1], (+)(-1, ˍ₋arg4[1]))), (exp)(ˍ₋arg3[2])), ˍ₋arg2[1])
                    nothing
                end
        end
    end
end

function H_x_p!(ˍ₋out, ::Val{:α}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[3] = (+)((*)((*)(-1, (^)(ˍ₋arg3[1], (+)(-1, ˍ₋arg4[1]))), (exp)(ˍ₋arg3[2])), (*)((*)((*)((*)(-1, ˍ₋arg4[1]), (^)(ˍ₋arg3[1], (+)(-1, ˍ₋arg4[1]))), (log)(ˍ₋arg3[1])), (exp)(ˍ₋arg3[2])))
                    ˍ₋out[7] = (*)((*)((*)(-1, (^)(ˍ₋arg3[1], ˍ₋arg4[1])), (log)(ˍ₋arg3[1])), (exp)(ˍ₋arg3[2]))
                    nothing
                end
        end
    end
end

function H_x_p!(ˍ₋out, ::Val{:ρ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[8] = -1
                    nothing
                end
        end
    end
end

function H_x_p!(ˍ₋out, ::Val{:σ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function H_x_p!(ˍ₋out, ::Val{:Ω_1}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function H_x_p!(ˍ₋out, ::Val{:δ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[2] = 1
                    nothing
                end
        end
    end
end

function H_x_p!(ˍ₋out, ::Val{:β}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function H_p!(ˍ₋out, ::Val{:α}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[1] = (/)((*)(ˍ₋arg4[2], (+)((*)((*)(-1, (^)(ˍ₋arg3[1], (+)(-1, ˍ₋arg4[1]))), (exp)(ˍ₋arg3[2])), (*)((*)((*)((*)(-1, ˍ₋arg4[1]), (^)(ˍ₋arg3[1], (+)(-1, ˍ₋arg4[1]))), (log)(ˍ₋arg3[1])), (exp)(ˍ₋arg3[2])))), ˍ₋arg2[1])
                    ˍ₋out[3] = (*)((*)((*)(-1, (^)(ˍ₋arg3[1], ˍ₋arg4[1])), (log)(ˍ₋arg3[1])), (exp)(ˍ₋arg3[2]))
                    nothing
                end
        end
    end
end

function H_p!(ˍ₋out, ::Val{:ρ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[4] = (*)(-1, ˍ₋arg3[2])
                    nothing
                end
        end
    end
end

function H_p!(ˍ₋out, ::Val{:σ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function H_p!(ˍ₋out, ::Val{:Ω_1}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function H_p!(ˍ₋out, ::Val{:δ}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[1] = (/)(ˍ₋arg4[2], ˍ₋arg2[1])
                    ˍ₋out[2] = ˍ₋arg3[1]
                    nothing
                end
        end
    end
end

function H_p!(ˍ₋out, ::Val{:β}, ˍ₋arg2, ˍ₋arg3, ˍ₋arg4; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[1] = (/)((+)((+)(-1, ˍ₋arg4[4]), (*)((*)((*)(-1, ˍ₋arg4[1]), (^)(ˍ₋arg3[1], (+)(-1, ˍ₋arg4[1]))), (exp)(ˍ₋arg3[2]))), ˍ₋arg2[1])
                    nothing
                end
        end
    end
end

