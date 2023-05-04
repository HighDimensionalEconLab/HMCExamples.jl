
function ArgParse.parse_item(::Type{Vector{Float64}}, x::AbstractString)
    return (length(x) > 0) ? parse.(Float64, split(strip(x, [' ', '\"', ']', '[']), ',')) : Vector{Float64}()
end

function Beta_tr(mu, sd)
    a = ((1 - mu) / sd^2 - 1 / mu) * mu^2
    b = a * (1 / mu - 1)
    return a, b
end

function Gamma_tr(mu, sd)
    b = sd^2 / mu
    a = mu / b
    return a, b
end

function InvGamma_tr(mu, sd)
    a = mu^2 / sd^2 + 2
    b = mu * (a - 1)
    return a, b
end