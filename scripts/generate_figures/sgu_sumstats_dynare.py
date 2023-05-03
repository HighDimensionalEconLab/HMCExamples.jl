import pandas as pd

num_samples_1st_order = 1350000 - 135000
runtime_1st_order = 1973
num_samples_2nd_order = 100000 - 10000
runtime_2nd_order = 37556

def process(n):
    if "." in str(n):
        number = str(n)[:6]
        num_decimal = len(number.split(".")[1])
        res = f"${str(round(n, num_decimal)).ljust(6, '0')}$"
        if res.startswith("$0.000"):
            return "${"+str(round(n*10000, 2))+"^{_{\cdot 10^{-4}}}}$"
        return res
    return f"${n}$"

dynare_1st_order = pd.read_csv(".results/dynare_1st_order/sumstats.csv").drop(columns = "Parameter")
dynare_1st_order.insert(0, "Parameters", [r"\alpha", r"\gamma", r"\psi", r"\beta_{draw}", r"\rho", r"\rho_u", r"\rho_v"])
dynare_1st_order.insert(1, "Pseudotrue", ["0.32", "2.0", "{7.42^{_{\cdot 10^{-4}}}}", "4", "0.42", "0.2", "0.4"])
dynare_1st_order.insert(6, "ESS\%", dynare_1st_order.loc[:, "ESS"] / num_samples_1st_order) # num_samples
dynare_1st_order.insert(8, "Time", [runtime_1st_order] * 7) # runtime rounded to nearest second
num = 9
with open(".tables/sumstats_sgu_1_dynare.tex", "w") as f:
    f.write(r"""\begin{table}[h]
\caption{RWMH with Marginal Likelihood, SGU Model, First-order}
\label{tab:sgu_RWMH_kalman}
\centering
\scriptsize
""")
    dynare_1st_order.to_latex(buf = f, index = False, escape = False, column_format = "c" * num, header = ["Parameters", "Pseudotrue", "Post. Mean", "Post. Std.", "ESS", "R-hat", "ESS\%", "ESS/second", "Time"], formatters = [lambda s: f"${s}$"]*2 + [process for i in range(num - 2)])
    f.write(r"""
{\raggedright Notes: We draw 1,350,000 samples in total and discard the first 135,000 samples. The sampling time is measured in seconds and excludes model file generation and compilation. \par}
\normalsize
\end{table}""")

dynare_2nd_order = pd.read_csv(".results/dynare_2nd_order/sumstats.csv").drop(columns = "Parameter")
dynare_2nd_order.insert(0, "Parameters", [r"\alpha", r"\gamma", r"\psi", r"\beta_{draw}", r"\rho", r"\rho_u", r"\rho_v"])
dynare_2nd_order.insert(1, "Pseudotrue", ["0.32", "2.0", "{7.42^{_{\cdot 10^{-4}}}}", "4", "0.42", "0.2", "0.4"])
dynare_2nd_order.insert(6, "ESS\%", dynare_2nd_order.loc[:, "ESS"] / num_samples_2nd_order) # num_samples
dynare_2nd_order.insert(8, "Time", [runtime_2nd_order] * 7) # runtime rounded to nearest second
num = 9
with open(".tables/sumstats_sgu_2_dynare.tex", "w") as f2:
    f2.write(r"""\begin{table}[h]
\caption{RWMH with Marginal Likelihood on Particle Filter, SGU Model, Second-order}
\label{tab:sgu_RWMH_particle}
\centering
\scriptsize
""")
    dynare_2nd_order.to_latex(buf = f2, index = False, escape = False, column_format = "c" * num, header = ["Parameters", "Pseudotrue", "Post. Mean", "Post. Std.", "ESS", "R-hat", "ESS\%", "ESS/second", "Time"], formatters = [lambda s: f"${s}$"]*2 + [process for i in range(num - 2)])
    f2.write(r"""
{\raggedright Notes: We draw 100,000 samples in total and discard the first 10,000 samples. We use 60,000 particles. The sampling time is measured in seconds and excludes model file generation and compilation. \par}
\normalsize
\end{table}""")
