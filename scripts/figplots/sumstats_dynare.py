import pandas as pd

num_samples_1st_order = 110000 - 11000
runtime_1st_order = 315
num_samples_2nd_order = 10000 - 1000
runtime_2nd_order = 13127

def process(n):
    if "." in str(n):
        number = str(n)[:6]
        num_decimal = len(number.split(".")[1])
        return f"${str(round(n, num_decimal)).rjust(6)}$"
    return f"${n}$"

dynare_1st_order = pd.read_csv(".results/dynare_1st_order/sumstats.csv").drop(columns = "Parameter")
dynare_1st_order.insert(0, "Parameters", [r"\alpha", r"\beta_{draw}", r"\rho"])
dynare_1st_order.insert(1, "Pseudotrue", [0.3, 0.2, 0.9])
dynare_1st_order.insert(6, "ESS\%", 100 * dynare_1st_order.loc[:, "ESS"] / num_samples_1st_order) # num_samples
dynare_1st_order.insert(8, "Time", [runtime_1st_order] * 3) # runtime rounded to nearest second
num = 9
with open(".tables/sumstats_rbc_1_dynare.tex", "w") as f:
    f.write(r"""\begin{table}[h]
\caption{RWMH with Marginal Likelihood, RBC Model, First-order}
\label{tab:rbc_RWMH_kalman}
\centering
\scriptsize
""")
    dynare_1st_order.to_latex(buf = f, index = False, escape = False, column_format = "c" * num, header = ["Parameters", "Pseudotrue", "Post. Mean", "Post. Std.", "ESS", "R-hat", "ESS\%", "ESS/second", "Time"], formatters = [lambda s: f"${s}$"] + [process for i in range(num - 1)])
    f.write(r"""
{\raggedright Notes: We draw 110,000 samples in total and discard the first 11000 samples. The sampling time is measured in seconds and excludes model file generation and compilation. \par}
\normalsize
\end{table}""")

dynare_2nd_order = pd.read_csv(".results/dynare_2nd_order/sumstats.csv").drop(columns = "Parameter")
dynare_2nd_order.insert(0, "Parameters", [r"\alpha", r"\beta_{draw}", r"\rho"])
dynare_2nd_order.insert(1, "Pseudotrue", [0.3, 0.2, 0.9])
dynare_2nd_order.insert(6, "ESS\%", 100 * dynare_2nd_order.loc[:, "ESS"] / num_samples_2nd_order) # num_samples
dynare_2nd_order.insert(8, "Time", [runtime_2nd_order] * 3) # runtime rounded to nearest second
num = 9
with open(".tables/sumstats_rbc_2_dynare.tex", "w") as f2:
    f2.write(r"""\begin{table}[h]
\caption{RWMH with Marginal Likelihood on Particle Filter, RBC Model, Second-order}
\label{tab:rbc_RWMH_particle}
\centering
\scriptsize
""")
    dynare_2nd_order.to_latex(buf = f2, index = False, escape = False, column_format = "c" * num, header = ["Parameters", "Pseudotrue", "Post. Mean", "Post. Std.", "ESS", "R-hat", "ESS\%", "ESS/second", "Time"], formatters = [lambda s: f"${s}$"] + [process for i in range(num - 1)])
    f2.write(r"""
{\raggedright Notes: We draw 10,000 samples in total and discard the first 1000 samples. The sampling time is measured in seconds and excludes model file generation and compilation. \par}
\normalsize
\end{table}""")
