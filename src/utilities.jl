
function set_BLAS_threads()
    # See https://github.com/JuliaLang/julia/issues/33409, no fix even in 2021
    if (BLAS.vendor() == :openblas64)
        blas_num_threads = min(4, Int64(round(Sys.CPU_THREADS / 2)))  # even lower?
        BLAS.set_num_threads(blas_num_threads)
    end
end

function ArgParse.parse_item(::Type{Vector{Float64}}, x::AbstractString)
    return parse.(Float64, split(strip(x, [' ','\"',']','[']), ','))
end