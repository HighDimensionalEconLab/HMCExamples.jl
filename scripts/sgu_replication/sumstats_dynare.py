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

base = pd.read_csv(".results/dynare_1st_order/sumstats.csv").drop(columns = "Parameter").drop(columns = "ESSpersec")
base.insert(0, "Parameters", [r"\alpha", r"\gamma", r"\psi", r"100{\left(\frac{1}{\beta}{-1}\right)}", r"\rho", r"\rho_u", r"\rho_v"])
base_2 = pd.read_csv(".results/dynare_2nd_order/sumstats.csv").drop(columns = "Parameter").drop(columns = "ESSpersec")
base.insert(5, "Rhat_2", base_2.loc[:, "Rhat"])
base.insert(4, "ESS_2", base_2.loc[:, "ESS"])
base.insert(3, "StdDev_2", base_2.loc[:, "StdDev"])
base.insert(2, "Mean_2", base_2.loc[:, "Mean"])
base.insert(1, "Pseudotrue", [0.32, 2.0, "{7.42^{_{\cdot 10^{-4}}}}", 4, 0.42, 0.2, 0.4])

runtime_text = "The 1st-order takes {0:,} seconds to run and the 2nd-order with particle filter, using 60,000 particles, takes {1:,} seconds.".format(runtime_1st_order, runtime_2nd_order)

num = 10
with open(".tables/sumstats_sgu_dynare.tex", "w") as f:
    f.write(r"""\begin{table}[h]
\caption{Estimation, SGU model, RWMH with Marginal Likelihood}
\label{tab:sgu_dynare_result}
\centering
\scriptsize
""")
    res = base.to_latex(index = False, escape = False, column_format = "c" * num, header = ["Param.", "P.true", "Mean 1", "Mean 2", "Std. 1", "Std.  2", "ESS 1", "ESS 2", "R-hat 1", "R-hat 2"], formatters = [lambda s: f"${s}$"]*2 + [process for i in range(num - 2)]).split("\n")
    res[0] = r"\begin{tabular}{c|c|cc|cc|cc|cc}"
    res[2] = r"\textbf{Param.} & \textbf{Ps.true} & \multicolumn{2}{c|}{\textbf{Mean}} &  \multicolumn{2}{c|}{\textbf{Std.}} &  \multicolumn{2}{c|}{\textbf{ESS}} & \multicolumn{2}{c}{\textbf{R-hat}}\\"
    res.insert(3, r"& & 1st-order & 2nd-order & 1st-order & 2nd-order & 1st-order & 2nd-order & 1st-order & 2nd-order \\")
    f.write("\n".join(res) + "\n")                
    f.write(r"""
{\raggedright Notes: We draw 1,350,000 samples in total and discard the first 135,000 samples for the 1st-order marginal likelihood whereas we draw 100,000 samples in total and discard the first 10,000 for the 2nd-order marginal likelihood on particle filter. RUNTIME\par}
\normalsize
\end{table}""".replace("RUNTIME", runtime_text))
