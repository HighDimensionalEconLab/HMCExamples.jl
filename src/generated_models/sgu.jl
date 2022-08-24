module sgu
using LinearAlgebra, SymbolicUtils, LaTeXStrings
const max_order = 1
const n_y = 8
const n_x = 7
const n_p = 16
const n_ϵ = 3
const n_z = 3
const η = [0.0 0.0 0.0; 0.0 0.0 0.0; 0.0 0.0 0.0; 0.0 0.0 0.0; 1.0 0.0 0.0; 0.0 1.0 0.0; 0.0 0.0 1.0]
const Q = [0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0]
const has_Ω = true
# Display definitions
const x_symbols = [:d, :k, :r, :riskpremium, :a, :ζ, :μ]
const y_symbols = [:c, :h, :GDP, :i, :kfu, :λ, :tb, :ca]
const u_symbols = [:c, :h, :GDP, :i, :kfu, :λ, :tb, :ca, :d, :k, :r, :riskpremium, :a, :ζ, :μ]
const p_symbols = [:γ, :ω, :ρ, :σe, :δ, :ψ, :α, :ϕ, :β, :r_w, :d_bar, :ρ_u, :σu, :ρ_v, :σv, :Ω_1]
const H_latex = L"\begin{equation}
\left[
\begin{array}{c}
 - e^{c\left( t \right)} - e^{i\left( t \right)} - \frac{1}{2} \left(  - e^{k\left( t \right)} + e^{k\left( 1 + t \right)} \right)^{2} \phi - \left( 1 + e^{r\left( t \right)} \right) d\left( t \right) + d\left( 1 + t \right) + e^{\mathrm{GDP}\left( t \right)} \\
 - \left( e^{k\left( t \right)} \right)^{\alpha} \left( e^{h\left( t \right)} \right)^{1 - \alpha} e^{a\left( t \right)} + e^{\mathrm{GDP}\left( t \right)} \\
 - e^{i\left( t \right)} - \left( 1 - \delta \right) e^{k\left( t \right)} + e^{k\left( 1 + t \right)} \\
 - \beta \left( 1 + e^{r\left( 1 + t \right)} \right) e^{\mu\left( t \right)} e^{\lambda\left( 1 + t \right)} + e^{\lambda\left( t \right)} \\
\left( \frac{ - \left( e^{h\left( t \right)} \right)^{\omega}}{\omega} + e^{c\left( t \right)} \right)^{ - \gamma} - e^{\lambda\left( t \right)} \\
\left( e^{h\left( t \right)} \right)^{-1 + \omega} \left( \frac{ - \left( e^{h\left( t \right)} \right)^{\omega}}{\omega} + e^{c\left( t \right)} \right)^{ - \gamma} + \frac{ - \left( 1 - \alpha \right) e^{\mathrm{GDP}\left( t \right)} e^{\lambda\left( t \right)}}{e^{h\left( t \right)}} \\
\left( 1 + \phi \left(  - e^{k\left( t \right)} + e^{k\left( 1 + t \right)} \right) \right) e^{\lambda\left( t \right)} - \beta \left( 1 - \delta + \phi \left(  - e^{k\left( 1 + t \right)} + e^{\mathrm{kfu}\left( 1 + t \right)} \right) + \frac{\alpha e^{\mathrm{GDP}\left( 1 + t \right)}}{e^{k\left( 1 + t \right)}} \right) e^{\mu\left( t \right)} e^{\lambda\left( 1 + t \right)} \\
 - r_{w} - \mathrm{riskpremium}\left( 1 + t \right) + e^{r\left( 1 + t \right)} \\
 - \zeta\left( t \right) - \psi \left( -1 + e^{ - d_{bar} + d\left( 1 + t \right)} \right) + \mathrm{riskpremium}\left( 1 + t \right) \\
-1 + \frac{\frac{1}{2} \left(  - e^{k\left( t \right)} + e^{k\left( 1 + t \right)} \right)^{2} \phi + e^{c\left( t \right)} + e^{i\left( t \right)}}{e^{\mathrm{GDP}\left( t \right)}} + \mathrm{tb}\left( t \right) \\
\frac{ - d\left( 1 + t \right) + d\left( t \right)}{e^{\mathrm{GDP}\left( t \right)}} + \mathrm{ca}\left( t \right) \\
 - k\left( 1 + t \right) + \mathrm{kfu}\left( t \right) \\
 - \rho a\left( t \right) + a\left( 1 + t \right) \\
 - \rho_{u} \zeta\left( t \right) + \zeta\left( 1 + t \right) \\
 - \rho_{v} \mu\left( t \right) + \mu\left( 1 + t \right) \\
\end{array}
\right]
\end{equation}
"
const steady_states_latex = L"$$"
const steady_states_iv_latex = L"\begin{align}
a\left( \infty \right) =& 0 \\
\mathrm{kfu}\left( \infty \right) =& \log\left( \frac{\left( \left( \frac{\alpha}{r_{w} + \delta} \right)^{\frac{\alpha}{1 - \alpha}} \left( 1 - \alpha \right) \right)^{\frac{1}{-1 + \omega}}}{\left( \frac{r_{w} + \delta}{\alpha} \right)^{\frac{1}{1 - \alpha}}} \right) \\
d\left( \infty \right) =& d_{bar} \\
c\left( \infty \right) =& \log\left( \left( \frac{\left( \left( \frac{\alpha}{r_{w} + \delta} \right)^{\frac{\alpha}{1 - \alpha}} \left( 1 - \alpha \right) \right)^{\frac{1}{-1 + \omega}}}{\left( \frac{r_{w} + \delta}{\alpha} \right)^{\frac{1}{1 - \alpha}}} \right)^{\alpha} \left( \left( \frac{\alpha}{r_{w} + \delta} \right)^{\frac{\alpha}{1 - \alpha}} \left( 1 - \alpha \right) \right)^{\frac{1 - \alpha}{-1 + \omega}} + \frac{ - \left( \left( \frac{\alpha}{r_{w} + \delta} \right)^{\frac{\alpha}{1 - \alpha}} \left( 1 - \alpha \right) \right)^{\frac{1}{-1 + \omega}} \delta}{\left( \frac{r_{w} + \delta}{\alpha} \right)^{\frac{1}{1 - \alpha}}} - d_{bar} r_{w} \right) \\
h\left( \infty \right) =& \log\left( \left( \left( \frac{\alpha}{r_{w} + \delta} \right)^{\frac{\alpha}{1 - \alpha}} \left( 1 - \alpha \right) \right)^{\frac{1}{-1 + \omega}} \right) \\
\mathrm{GDP}\left( \infty \right) =& \log\left( \left( \frac{\left( \left( \frac{\alpha}{r_{w} + \delta} \right)^{\frac{\alpha}{1 - \alpha}} \left( 1 - \alpha \right) \right)^{\frac{1}{-1 + \omega}}}{\left( \frac{r_{w} + \delta}{\alpha} \right)^{\frac{1}{1 - \alpha}}} \right)^{\alpha} \left( \left( \frac{\alpha}{r_{w} + \delta} \right)^{\frac{\alpha}{1 - \alpha}} \left( 1 - \alpha \right) \right)^{\frac{1 - \alpha}{-1 + \omega}} \right) \\
i\left( \infty \right) =& \log\left( \frac{\left( \left( \frac{\alpha}{r_{w} + \delta} \right)^{\frac{\alpha}{1 - \alpha}} \left( 1 - \alpha \right) \right)^{\frac{1}{-1 + \omega}} \delta}{\left( \frac{r_{w} + \delta}{\alpha} \right)^{\frac{1}{1 - \alpha}}} \right) \\
k\left( \infty \right) =& \log\left( \frac{\left( \left( \frac{\alpha}{r_{w} + \delta} \right)^{\frac{\alpha}{1 - \alpha}} \left( 1 - \alpha \right) \right)^{\frac{1}{-1 + \omega}}}{\left( \frac{r_{w} + \delta}{\alpha} \right)^{\frac{1}{1 - \alpha}}} \right) \\
\lambda\left( \infty \right) =& \log\left( \left( \left( \frac{\left( \left( \frac{\alpha}{r_{w} + \delta} \right)^{\frac{\alpha}{1 - \alpha}} \left( 1 - \alpha \right) \right)^{\frac{1}{-1 + \omega}}}{\left( \frac{r_{w} + \delta}{\alpha} \right)^{\frac{1}{1 - \alpha}}} \right)^{\alpha} \left( \left( \frac{\alpha}{r_{w} + \delta} \right)^{\frac{\alpha}{1 - \alpha}} \left( 1 - \alpha \right) \right)^{\frac{1 - \alpha}{-1 + \omega}} + \frac{ - \left( \left( \frac{\alpha}{r_{w} + \delta} \right)^{\frac{\alpha}{1 - \alpha}} \left( 1 - \alpha \right) \right)^{\frac{\omega}{-1 + \omega}}}{\omega} + \frac{ - \left( \left( \frac{\alpha}{r_{w} + \delta} \right)^{\frac{\alpha}{1 - \alpha}} \left( 1 - \alpha \right) \right)^{\frac{1}{-1 + \omega}} \delta}{\left( \frac{r_{w} + \delta}{\alpha} \right)^{\frac{1}{1 - \alpha}}} - d_{bar} r_{w} \right)^{ - \gamma} \right) \\
\mathrm{tb}\left( \infty \right) =& d_{bar} r_{w} \\
\mathrm{ca}\left( \infty \right) =& 0 \\
\mathrm{riskpremium}\left( \infty \right) =& 0 \\
r\left( \infty \right) =& \log\left( \frac{1 - \beta}{\beta} \right) \\
\zeta\left( \infty \right) =& 0 \\
\mu\left( \infty \right) =& 0
\end{align}
"
# Function definitions
include("sgu/zero_order_ip.jl")
include("sgu/first_order_ip.jl")
end
