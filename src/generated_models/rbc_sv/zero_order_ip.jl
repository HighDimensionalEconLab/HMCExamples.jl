function Γ!(ˍ₋out, ˍ₋arg1; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[1] = ˍ₋arg1[5]
                    ˍ₋out[4] = ˍ₋arg1[9]
                    nothing
                end
        end
    end
end

function Ω!(ˍ₋out, ˍ₋arg1; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[1] = ˍ₋arg1[6]
                    ˍ₋out[2] = ˍ₋arg1[6]
                    nothing
                end
        end
    end
end

function H̄!(ˍ₋out, ˍ₋arg1, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[1] = (+)((/)(1, ˍ₋arg1[1]), (/)((*)((*)(-1, ˍ₋arg2[2]), (+)((+)(1, (*)(-1, ˍ₋arg2[4])), (*)((*)(ˍ₋arg2[1], (^)(ˍ₋arg1[5], (+)(-1, ˍ₋arg2[1]))), (exp)(ˍ₋arg1[3])))), ˍ₋arg1[1]))
                    ˍ₋out[2] = (+)((+)((+)(ˍ₋arg1[1], ˍ₋arg1[5]), (*)(-1, ˍ₋arg1[2])), (*)((*)(-1, ˍ₋arg1[5]), (+)(1, (*)(-1, ˍ₋arg2[4]))))
                    ˍ₋out[3] = (+)(ˍ₋arg1[2], (*)((*)(-1, (^)(ˍ₋arg1[5], ˍ₋arg2[1])), (exp)(ˍ₋arg1[3])))
                    ˍ₋out[4] = (+)((+)(ˍ₋arg1[3], (*)((*)(-1, ˍ₋arg1[6]), ˍ₋arg2[3])), (*)((*)(-1, ˍ₋arg1[8]), (exp)(ˍ₋arg1[7])))
                    ˍ₋out[5] = (+)((+)(ˍ₋arg1[7], (*)((*)(-1, ˍ₋arg1[7]), ˍ₋arg2[7])), (*)((*)(-1, ˍ₋arg2[8]), (+)(1, (*)(-1, ˍ₋arg2[7]))))
                    ˍ₋out[6] = ˍ₋arg1[8]
                    ˍ₋out[7] = (+)(ˍ₋arg1[6], (*)(-1, ˍ₋arg1[3]))
                    ˍ₋out[8] = (+)((+)(ˍ₋arg1[4], (*)(-1, ˍ₋arg1[5])), (*)(ˍ₋arg1[5], (+)(1, (*)(-1, ˍ₋arg2[4]))))
                    nothing
                end
        end
    end
end

function H̄_w!(ˍ₋out, ˍ₋arg1, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[1] = (+)((/)(-1, (^)(ˍ₋arg1[1], 2)), (/)((*)(ˍ₋arg2[2], (+)((+)(1, (*)(-1, ˍ₋arg2[4])), (*)((*)(ˍ₋arg2[1], (^)(ˍ₋arg1[5], (+)(-1, ˍ₋arg2[1]))), (exp)(ˍ₋arg1[3])))), (^)(ˍ₋arg1[1], 2)))
                    ˍ₋out[2] = 1
                    ˍ₋out[10] = -1
                    ˍ₋out[11] = 1
                    ˍ₋out[17] = (/)((*)((*)((*)((*)(-1, ˍ₋arg2[1]), ˍ₋arg2[2]), (^)(ˍ₋arg1[5], (+)(-1, ˍ₋arg2[1]))), (exp)(ˍ₋arg1[3])), ˍ₋arg1[1])
                    ˍ₋out[19] = (*)((*)(-1, (^)(ˍ₋arg1[5], ˍ₋arg2[1])), (exp)(ˍ₋arg1[3]))
                    ˍ₋out[20] = 1
                    ˍ₋out[23] = -1
                    ˍ₋out[32] = 1
                    ˍ₋out[33] = (/)((*)((*)((*)((*)((*)(-1, ˍ₋arg2[1]), ˍ₋arg2[2]), (^)(ˍ₋arg1[5], (+)(-2, ˍ₋arg2[1]))), (+)(-1, ˍ₋arg2[1])), (exp)(ˍ₋arg1[3])), ˍ₋arg1[1])
                    ˍ₋out[34] = ˍ₋arg2[4]
                    ˍ₋out[35] = (*)((*)((*)(-1, ˍ₋arg2[1]), (^)(ˍ₋arg1[5], (+)(-1, ˍ₋arg2[1]))), (exp)(ˍ₋arg1[3]))
                    ˍ₋out[40] = (*)(-1, ˍ₋arg2[4])
                    ˍ₋out[44] = (*)(-1, ˍ₋arg2[3])
                    ˍ₋out[47] = 1
                    ˍ₋out[52] = (*)((*)(-1, ˍ₋arg1[8]), (exp)(ˍ₋arg1[7]))
                    ˍ₋out[53] = (+)(1, (*)(-1, ˍ₋arg2[7]))
                    ˍ₋out[60] = (*)(-1, (exp)(ˍ₋arg1[7]))
                    ˍ₋out[62] = 1
                    nothing
                end
        end
    end
end

ȳ_iv! = nothing

x̄_iv! = nothing

function ȳ!(ˍ₋out, ˍ₋arg1; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[1] = (+)((^)((/)((+)((+)(-1, ˍ₋arg1[4]), (/)(1, ˍ₋arg1[2])), ˍ₋arg1[1]), (/)(ˍ₋arg1[1], (+)(-1, ˍ₋arg1[1]))), (*)((*)(-1, ˍ₋arg1[4]), (^)((/)((+)((+)(-1, ˍ₋arg1[4]), (/)(1, ˍ₋arg1[2])), ˍ₋arg1[1]), (/)(1, (+)(-1, ˍ₋arg1[1])))))
                    ˍ₋out[2] = (^)((/)((+)((+)(-1, ˍ₋arg1[4]), (/)(1, ˍ₋arg1[2])), ˍ₋arg1[1]), (/)(ˍ₋arg1[1], (+)(-1, ˍ₋arg1[1])))
                    ˍ₋out[4] = (*)(ˍ₋arg1[4], (^)((/)((+)((+)(-1, ˍ₋arg1[4]), (/)(1, ˍ₋arg1[2])), ˍ₋arg1[1]), (/)(1, (+)(-1, ˍ₋arg1[1]))))
                    nothing
                end
        end
    end
end

function x̄!(ˍ₋out, ˍ₋arg1; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[1] = (^)((/)((+)((+)(-1, ˍ₋arg1[4]), (/)(1, ˍ₋arg1[2])), ˍ₋arg1[1]), (/)(1, (+)(-1, ˍ₋arg1[1])))
                    ˍ₋out[3] = ˍ₋arg1[8]
                    nothing
                end
        end
    end
end

function ȳ_p!(ˍ₋out, ::Val{:α}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[1] = (/)((+)((+)((+)((+)((+)((+)((+)((+)((+)((+)((+)((+)((+)((*)(ˍ₋arg2[1], (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)(1, (+)(-1, ˍ₋arg2[1])))), (*)((*)(-1.0, ˍ₋arg2[4]), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)((+)(2, (*)(-1, ˍ₋arg2[1])), (+)(-1, ˍ₋arg2[1]))))), (*)((*)(ˍ₋arg2[1], ˍ₋arg2[4]), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)((+)(2, (*)(-1, ˍ₋arg2[1])), (+)(-1, ˍ₋arg2[1]))))), (*)((*)(-1.0, (^)(ˍ₋arg2[1], 2)), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)(1, (+)(-1, ˍ₋arg2[1]))))), (*)((*)(ˍ₋arg2[2], ˍ₋arg2[4]), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)((+)(2, (*)(-1, ˍ₋arg2[1])), (+)(-1, ˍ₋arg2[1]))))), (*)((*)(ˍ₋arg2[2], (^)(ˍ₋arg2[1], 2)), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)(1, (+)(-1, ˍ₋arg2[1]))))), (*)((*)((*)(-1.0, ˍ₋arg2[1]), ˍ₋arg2[2]), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)(1, (+)(-1, ˍ₋arg2[1]))))), (*)((*)((*)(-1.0, ˍ₋arg2[2]), (^)(ˍ₋arg2[4], 2)), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)((+)(2, (*)(-1, ˍ₋arg2[1])), (+)(-1, ˍ₋arg2[1]))))), (*)((*)((*)(ˍ₋arg2[1], ˍ₋arg2[2]), ˍ₋arg2[4]), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)(1, (+)(-1, ˍ₋arg2[1]))))), (*)((*)((*)(ˍ₋arg2[1], ˍ₋arg2[2]), (^)(ˍ₋arg2[4], 2)), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)((+)(2, (*)(-1, ˍ₋arg2[1])), (+)(-1, ˍ₋arg2[1]))))), (*)((*)((*)((*)(-1.0, ˍ₋arg2[2]), ˍ₋arg2[4]), (^)(ˍ₋arg2[1], 2)), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)(1, (+)(-1, ˍ₋arg2[1]))))), (*)((*)((*)((*)(-1.0, ˍ₋arg2[1]), ˍ₋arg2[2]), ˍ₋arg2[4]), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)((+)(2, (*)(-1, ˍ₋arg2[1])), (+)(-1, ˍ₋arg2[1]))))), (*)((*)((*)((*)(-1.0, ˍ₋arg2[2]), (^)(ˍ₋arg2[1], 2)), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)(ˍ₋arg2[1], (+)(-1, ˍ₋arg2[1])))), (log)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2]))))), (*)((*)((*)((*)(ˍ₋arg2[2], ˍ₋arg2[4]), (^)(ˍ₋arg2[1], 2)), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)(1, (+)(-1, ˍ₋arg2[1])))), (log)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2]))))), (*)((*)(ˍ₋arg2[2], (^)(ˍ₋arg2[1], 2)), (^)((+)(-1, ˍ₋arg2[1]), 2)))
                    ˍ₋out[2] = (/)((+)((+)((+)((+)((+)((+)((^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)(1, (+)(-1, ˍ₋arg2[1]))), (*)((*)(-1.0, ˍ₋arg2[1]), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)(1, (+)(-1, ˍ₋arg2[1]))))), (*)((*)(-1.0, ˍ₋arg2[2]), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)(1, (+)(-1, ˍ₋arg2[1]))))), (*)((*)(ˍ₋arg2[1], ˍ₋arg2[2]), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)(1, (+)(-1, ˍ₋arg2[1]))))), (*)((*)(ˍ₋arg2[2], ˍ₋arg2[4]), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)(1, (+)(-1, ˍ₋arg2[1]))))), (*)((*)((*)((*)(-1.0, ˍ₋arg2[1]), ˍ₋arg2[2]), ˍ₋arg2[4]), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)(1, (+)(-1, ˍ₋arg2[1]))))), (*)((*)((*)((*)(-1.0, ˍ₋arg2[1]), ˍ₋arg2[2]), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)(ˍ₋arg2[1], (+)(-1, ˍ₋arg2[1])))), (log)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2]))))), (*)((*)(ˍ₋arg2[1], ˍ₋arg2[2]), (^)((+)(-1, ˍ₋arg2[1]), 2)))
                    ˍ₋out[4] = (/)((*)(ˍ₋arg2[4], (+)((+)((+)((+)((+)((+)((^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)((+)(2, (*)(-1, ˍ₋arg2[1])), (+)(-1, ˍ₋arg2[1]))), (*)((*)(-1.0, ˍ₋arg2[1]), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)((+)(2, (*)(-1, ˍ₋arg2[1])), (+)(-1, ˍ₋arg2[1]))))), (*)((*)(-1.0, ˍ₋arg2[2]), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)((+)(2, (*)(-1, ˍ₋arg2[1])), (+)(-1, ˍ₋arg2[1]))))), (*)((*)(ˍ₋arg2[1], ˍ₋arg2[2]), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)((+)(2, (*)(-1, ˍ₋arg2[1])), (+)(-1, ˍ₋arg2[1]))))), (*)((*)(ˍ₋arg2[2], ˍ₋arg2[4]), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)((+)(2, (*)(-1, ˍ₋arg2[1])), (+)(-1, ˍ₋arg2[1]))))), (*)((*)((*)((*)(-1.0, ˍ₋arg2[1]), ˍ₋arg2[2]), ˍ₋arg2[4]), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)((+)(2, (*)(-1, ˍ₋arg2[1])), (+)(-1, ˍ₋arg2[1]))))), (*)((*)((*)((*)(-1.0, ˍ₋arg2[2]), (^)(ˍ₋arg2[1], 2)), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)(1, (+)(-1, ˍ₋arg2[1])))), (log)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])))))), (*)((*)(ˍ₋arg2[2], (^)(ˍ₋arg2[1], 2)), (^)((+)(-1, ˍ₋arg2[1]), 2)))
                    nothing
                end
        end
    end
end

function ȳ_p!(ˍ₋out, ::Val{:ρ}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function ȳ_p!(ˍ₋out, ::Val{:σ_σ}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function ȳ_p!(ˍ₋out, ::Val{:σ}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function ȳ_p!(ˍ₋out, ::Val{:Ω_1}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function ȳ_p!(ˍ₋out, ::Val{:δ}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[1] = (/)((+)((+)((*)((*)(2.0, ˍ₋arg2[1]), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)(1, (+)(-1, ˍ₋arg2[1])))), (*)((*)(-1.0, ˍ₋arg2[4]), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)((+)(2, (*)(-1, ˍ₋arg2[1])), (+)(-1, ˍ₋arg2[1]))))), (*)((*)(-1.0, (^)(ˍ₋arg2[1], 2)), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)(1, (+)(-1, ˍ₋arg2[1]))))), (*)(ˍ₋arg2[1], (+)(-1, ˍ₋arg2[1])))
                    ˍ₋out[2] = (/)((^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)(1, (+)(-1, ˍ₋arg2[1]))), (+)(-1, ˍ₋arg2[1]))
                    ˍ₋out[4] = (/)((+)((+)((*)(ˍ₋arg2[4], (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)((+)(2, (*)(-1, ˍ₋arg2[1])), (+)(-1, ˍ₋arg2[1])))), (*)((^)(ˍ₋arg2[1], 2), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)(1, (+)(-1, ˍ₋arg2[1]))))), (*)((*)(-1, ˍ₋arg2[1]), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)(1, (+)(-1, ˍ₋arg2[1]))))), (*)(ˍ₋arg2[1], (+)(-1, ˍ₋arg2[1])))
                    nothing
                end
        end
    end
end

function ȳ_p!(ˍ₋out, ::Val{:μ_σ}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function ȳ_p!(ˍ₋out, ::Val{:β}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[1] = (/)((+)((*)(ˍ₋arg2[4], (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)((+)(2, (*)(-1, ˍ₋arg2[1])), (+)(-1, ˍ₋arg2[1])))), (*)((*)(-1.0, ˍ₋arg2[1]), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)(1, (+)(-1, ˍ₋arg2[1]))))), (*)((*)(ˍ₋arg2[1], (+)(-1, ˍ₋arg2[1])), (^)(ˍ₋arg2[2], 2)))
                    ˍ₋out[2] = (/)((*)(-1, (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)(1, (+)(-1, ˍ₋arg2[1])))), (*)((+)(-1, ˍ₋arg2[1]), (^)(ˍ₋arg2[2], 2)))
                    ˍ₋out[4] = (/)((*)((*)(-1, ˍ₋arg2[4]), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)((+)(2, (*)(-1, ˍ₋arg2[1])), (+)(-1, ˍ₋arg2[1])))), (*)((*)(ˍ₋arg2[1], (+)(-1, ˍ₋arg2[1])), (^)(ˍ₋arg2[2], 2)))
                    nothing
                end
        end
    end
end

function ȳ_p!(ˍ₋out, ::Val{:ρ_σ}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function x̄_p!(ˍ₋out, ::Val{:α}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[1] = (/)((+)((+)((+)((+)((+)((+)((^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)((+)(2, (*)(-1, ˍ₋arg2[1])), (+)(-1, ˍ₋arg2[1]))), (*)((*)(-1.0, ˍ₋arg2[1]), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)((+)(2, (*)(-1, ˍ₋arg2[1])), (+)(-1, ˍ₋arg2[1]))))), (*)((*)(-1.0, ˍ₋arg2[2]), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)((+)(2, (*)(-1, ˍ₋arg2[1])), (+)(-1, ˍ₋arg2[1]))))), (*)((*)(ˍ₋arg2[1], ˍ₋arg2[2]), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)((+)(2, (*)(-1, ˍ₋arg2[1])), (+)(-1, ˍ₋arg2[1]))))), (*)((*)(ˍ₋arg2[2], ˍ₋arg2[4]), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)((+)(2, (*)(-1, ˍ₋arg2[1])), (+)(-1, ˍ₋arg2[1]))))), (*)((*)((*)((*)(-1.0, ˍ₋arg2[1]), ˍ₋arg2[2]), ˍ₋arg2[4]), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)((+)(2, (*)(-1, ˍ₋arg2[1])), (+)(-1, ˍ₋arg2[1]))))), (*)((*)((*)((*)(-1.0, ˍ₋arg2[2]), (^)(ˍ₋arg2[1], 2)), (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)(1, (+)(-1, ˍ₋arg2[1])))), (log)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2]))))), (*)((*)(ˍ₋arg2[2], (^)(ˍ₋arg2[1], 2)), (^)((+)(-1, ˍ₋arg2[1]), 2)))
                    nothing
                end
        end
    end
end

function x̄_p!(ˍ₋out, ::Val{:ρ}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function x̄_p!(ˍ₋out, ::Val{:σ_σ}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function x̄_p!(ˍ₋out, ::Val{:σ}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function x̄_p!(ˍ₋out, ::Val{:Ω_1}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function x̄_p!(ˍ₋out, ::Val{:δ}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[1] = (/)((^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)((+)(2, (*)(-1, ˍ₋arg2[1])), (+)(-1, ˍ₋arg2[1]))), (*)(ˍ₋arg2[1], (+)(-1, ˍ₋arg2[1])))
                    nothing
                end
        end
    end
end

function x̄_p!(ˍ₋out, ::Val{:μ_σ}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[3] = 1
                    nothing
                end
        end
    end
end

function x̄_p!(ˍ₋out, ::Val{:β}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[1] = (/)((*)(-1, (^)((/)((+)((+)(1, (*)(-1, ˍ₋arg2[2])), (*)(ˍ₋arg2[2], ˍ₋arg2[4])), (*)(ˍ₋arg2[1], ˍ₋arg2[2])), (/)((+)(2, (*)(-1, ˍ₋arg2[1])), (+)(-1, ˍ₋arg2[1])))), (*)((*)(ˍ₋arg2[1], (+)(-1, ˍ₋arg2[1])), (^)(ˍ₋arg2[2], 2)))
                    nothing
                end
        end
    end
end

function x̄_p!(ˍ₋out, ::Val{:ρ_σ}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

const steady_state! = nothing

function Γ_p!(ˍ₋out, ::Val{:α}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function Γ_p!(ˍ₋out, ::Val{:ρ}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function Γ_p!(ˍ₋out, ::Val{:σ_σ}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[4] = 1
                    nothing
                end
        end
    end
end

function Γ_p!(ˍ₋out, ::Val{:σ}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[1] = 1
                    nothing
                end
        end
    end
end

function Γ_p!(ˍ₋out, ::Val{:Ω_1}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function Γ_p!(ˍ₋out, ::Val{:δ}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function Γ_p!(ˍ₋out, ::Val{:μ_σ}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function Γ_p!(ˍ₋out, ::Val{:β}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function Γ_p!(ˍ₋out, ::Val{:ρ_σ}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function Ω_p!(ˍ₋out, ::Val{:α}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function Ω_p!(ˍ₋out, ::Val{:ρ}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function Ω_p!(ˍ₋out, ::Val{:σ_σ}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function Ω_p!(ˍ₋out, ::Val{:σ}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function Ω_p!(ˍ₋out, ::Val{:Ω_1}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    ˍ₋out[1] = 1
                    ˍ₋out[2] = 1
                    nothing
                end
        end
    end
end

function Ω_p!(ˍ₋out, ::Val{:δ}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function Ω_p!(ˍ₋out, ::Val{:μ_σ}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function Ω_p!(ˍ₋out, ::Val{:β}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

function Ω_p!(ˍ₋out, ::Val{:ρ_σ}, ˍ₋arg2; )
    begin
        begin
            @inbounds begin
                    nothing
                end
        end
    end
end

