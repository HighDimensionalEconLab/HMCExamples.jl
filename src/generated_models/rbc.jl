module rbc
using LinearAlgebra, SymbolicUtils, LaTeXStrings
const max_order = 2
const n_y = 3
const n_x = 2
const n_p = 6
const n_ϵ = 1
const n_z = 2
const η = reshape([0; -1], 2, 1)
const Q = [1.0 0.0 0.0 0.0 0.0; 0.0 0.0 1.0 0.0 0.0]
const has_Ω = true
# Display definitions
const x_symbols = [:k, :z]
const y_symbols = [:c, :q, :i]
const u_symbols = [:c, :q, :i, :k, :z]
const p_symbols = [:α, :β, :ρ, :δ, :σ, :Ω_1]
const H_latex = L"\begin{equation}
\left[
\begin{array}{c}
\frac{ - \beta \left( 1 - \delta + \left( k\left( 1 + t \right) \right)^{-1 + \alpha} \alpha e^{z\left( 1 + t \right)} \right)}{c\left( 1 + t \right)} + \frac{1}{c\left( t \right)} \\
 - q\left( t \right) - \left( 1 - \delta \right) k\left( t \right) + c\left( t \right) + k\left( 1 + t \right) \\
 - \left( k\left( t \right) \right)^{\alpha} e^{z\left( t \right)} + q\left( t \right) \\
 - \rho z\left( t \right) + z\left( 1 + t \right) \\
 - k\left( 1 + t \right) + \left( 1 - \delta \right) k\left( t \right) + i\left( t \right) \\
\end{array}
\right]
\end{equation}
"
const steady_states_latex = L"\begin{align}
k\left( \infty \right) =& \left( \frac{-1 + \delta + \frac{1}{\beta}}{\alpha} \right)^{\frac{1}{-1 + \alpha}} \\
z\left( \infty \right) =& 0 \\
c\left( \infty \right) =& \left( \frac{-1 + \delta + \frac{1}{\beta}}{\alpha} \right)^{\frac{\alpha}{-1 + \alpha}} - \left( \frac{-1 + \delta + \frac{1}{\beta}}{\alpha} \right)^{\frac{1}{-1 + \alpha}} \delta \\
q\left( \infty \right) =& \left( \frac{-1 + \delta + \frac{1}{\beta}}{\alpha} \right)^{\frac{\alpha}{-1 + \alpha}} \\
i\left( \infty \right) =& \left( \frac{-1 + \delta + \frac{1}{\beta}}{\alpha} \right)^{\frac{1}{-1 + \alpha}} \delta
\end{align}
"
const steady_states_iv_latex = L"\begin{align}
k\left( \infty \right) =& \left( \frac{-1 + \delta + \frac{1}{\beta}}{\alpha} \right)^{\frac{1}{-1 + \alpha}} \\
z\left( \infty \right) =& 0 \\
c\left( \infty \right) =& \left( \frac{-1 + \delta + \frac{1}{\beta}}{\alpha} \right)^{\frac{\alpha}{-1 + \alpha}} - \left( \frac{-1 + \delta + \frac{1}{\beta}}{\alpha} \right)^{\frac{1}{-1 + \alpha}} \delta \\
q\left( \infty \right) =& \left( \frac{-1 + \delta + \frac{1}{\beta}}{\alpha} \right)^{\frac{\alpha}{-1 + \alpha}} \\
i\left( \infty \right) =& \left( \frac{-1 + \delta + \frac{1}{\beta}}{\alpha} \right)^{\frac{1}{-1 + \alpha}} \delta
\end{align}
"
# Function definitions
include("rbc/zero_order_ip.jl")
include("rbc/first_order_ip.jl")
include("rbc/second_order_ip.jl")
end
