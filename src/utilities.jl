
function ArgParse.parse_item(::Type{Vector{Float64}}, x::AbstractString)
    return parse.(Float64, split(strip(x, [' ','\"',']','[']), ','))
end