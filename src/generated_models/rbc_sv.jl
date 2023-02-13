module rbc_sv
using LinearAlgebra, SymbolicUtils, LaTeXStrings
const max_order = 2
const n_y = 3
const n_x = 4
const n_p = 9
const n_ϵ = 2
const n_z = 2
const η = [0.0 0.0; 0.0 0.0; 0.0 -1.0; -1.0 0.0]
const Q = [1.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 1.0 0.0 0.0 0.0]
const has_Ω = true
# Display definitions
const x_symbols = [:k, :zlag, :ν, :ζ]
const y_symbols = [:c, :q, :z]
const u_symbols = [:c, :q, :z, :k, :zlag, :ν, :ζ]
const p_symbols = [:α, :β, :ρ, :δ, :σ, :Ω_1, :ρ_σ, :μ_σ, :σ_σ]
const H_latex = L"\begin{equation}
\left[
\begin{array}{c}
\frac{ - \beta \left( 1 - \delta + \left( k\left( 1 + t \right) \right)^{-1 + \alpha} \alpha e^{z\left( 1 + t \right)} \right)}{c\left( 1 + t \right)} + \frac{1}{c\left( t \right)} \\
 - q\left( t \right) - \left( 1 - \delta \right) k\left( t \right) + c\left( t \right) + k\left( 1 + t \right) \\
 - \left( k\left( t \right) \right)^{\alpha} e^{z\left( t \right)} + q\left( t \right) \\
 - \rho \mathrm{zlag}\left( t \right) - \zeta\left( t \right) e^{\nu\left( t \right)} + z\left( t \right) \\
 - \mu_{\sigma} \left( 1 - \rho_{\sigma} \right) - \rho_{\sigma} \nu\left( t \right) + \nu\left( 1 + t \right) \\
\zeta\left( 1 + t \right) \\
 - z\left( t \right) + \mathrm{zlag}\left( 1 + t \right) \\
\end{array}
\right]
\end{equation}
"
const steady_states_latex = L"\begin{align}
k\left( \infty \right) =& \left( \frac{-1 + \delta + \frac{1}{\beta}}{\alpha} \right)^{\frac{1}{-1 + \alpha}} \\
\mathrm{zlag}\left( \infty \right) =& 0 \\
\nu\left( \infty \right) =& \mu_{\sigma} \\
\zeta\left( \infty \right) =& 0 \\
c\left( \infty \right) =& \left( \frac{-1 + \delta + \frac{1}{\beta}}{\alpha} \right)^{\frac{\alpha}{-1 + \alpha}} - \left( \frac{-1 + \delta + \frac{1}{\beta}}{\alpha} \right)^{\frac{1}{-1 + \alpha}} \delta \\
q\left( \infty \right) =& \left( \frac{-1 + \delta + \frac{1}{\beta}}{\alpha} \right)^{\frac{\alpha}{-1 + \alpha}} \\
z\left( \infty \right) =& 0
\end{align}
"
const steady_states_iv_latex = L"$$"
# Function definitions
include("rbc_sv/zero_order_ip.jl")
include("rbc_sv/first_order_ip.jl")
include("rbc_sv/second_order_ip.jl")
end
