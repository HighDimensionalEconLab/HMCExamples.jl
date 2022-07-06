import pandas as pd

num_samples_kalman = 6500
num_samples_1st_order = 4000
num_samples_2nd_order = 4000

def process(n):
    if "." in str(n):
        number = str(n)[:6]
        num_decimal = len(number.split(".")[1])
        return f"${str(round(n, num_decimal)).rjust(6)}$"
    return f"${n}$"

kalman = pd.read_csv(".experiments/benchmarks_julia/rbc_1_kalman_timed/sumstats.csv").drop(columns = "Parameter").drop(columns = "Num_error")
kalman.insert(0, "Parameters", [r"\alpha", r"100\left(\beta^{-1}-1\right)", r"\rho"])
kalman.insert(1, "Pseudotrue", [0.3, 0.2, 0.9])
kalman.insert(6, "ESS\%", kalman.loc[:, "ESS"] / num_samples_kalman) # num_samples
kalman.insert(8, "Time", kalman.loc[:, "ESS"] / kalman.loc[:, "ESSpersec"])
num = 9
with open(".tables/sumstats_rbc_1_kalman.tex", "w") as f:
    f.write(r"""\begin{table}[h]
\caption{NUTS with Marginal Likelihood, RBC Model, First-order}
\label{tab:rbc_NUTS_kalman}
\centering
\scriptsize
""")
    kalman.to_latex(buf = f, index = False, escape = False, column_format = "c" * num, header = ["Parameters", "Pseudotrue", "Post. Mean", "Post. Std.", "ESS", "R-hat", "ESS\%", "ESS/second", "Time"], formatters = [lambda s: f"${s}$"] + [process for i in range(num - 2)] + [lambda s: f"${int(round(s))}$"])
    f.write(r"""
{\raggedright Notes: We draw 7,150 samples in total and discard the first 650 samples. The sampling time is
measured in seconds and excludes \texttt{Julia} compilation time. The length of the samples is chosen
such that the total sampling time is close to the Dynare counterpart. \par}
\normalsize
\end{table}""")



joint_1 = pd.read_csv(".experiments/benchmarks_julia/rbc_1_joint_timed/sumstats.csv").drop(columns = "Parameter").drop(columns = "Num_error")
joint_1.insert(0, "Parameters", [r"\alpha", r"100\left(\beta^{-1}-1\right)", r"\rho"])
joint_1.insert(1, "Pseudotrue", [0.3, 0.2, 0.9])
joint_1.insert(6, "ESS\%", joint_1.loc[:, "ESS"] / num_samples_1st_order) # num_samples
joint_1.insert(8, "Time", joint_1.loc[:, "ESS"] / joint_1.loc[:, "ESSpersec"])

num = 9
with open(".tables/sumstats_rbc_1_joint.tex", "w") as f:
    f.write(r"""\begin{table}[h]
\caption{NUTS with Joint Likelihood, RBC Model, First-order}
\label{tab:rbc_NUTS_joint_1}
\centering
\scriptsize
""")
    joint_1.to_latex(buf = f, index = False, escape = False, column_format = "c" * num, header = ["Parameters", "Pseudotrue", "Post. Mean", "Post. Std.", "ESS", "R-hat", "ESS\%", "ESS/second", "Time"], formatters = [lambda s: f"${s}$"] + [process for i in range(num - 2)] + [lambda s: f"${int(round(s))}$"])
    f.write(r"""
{\raggedright Notes: We draw 4,400 samples in total and discard the first 400 samples. The sampling time is
measured in seconds and excludes \texttt{Julia} compilation time. \par}
\normalsize
\end{table}""")

joint_2 = pd.read_csv(".experiments/benchmarks_julia/rbc_2_joint_timed/sumstats.csv").drop(columns = "Parameter").drop(columns = "Num_error")
joint_2.insert(0, "Parameters", [r"\alpha", r"100\left(\beta^{-1}-1\right)", r"\rho"])
joint_2.insert(1, "Pseudotrue", [0.3, 0.2, 0.9])
joint_2.insert(6, "ESS\%", joint_2.loc[:, "ESS"] / num_samples_2nd_order) # num_samples
joint_2.insert(8, "Time", joint_2.loc[:, "ESS"] / joint_2.loc[:, "ESSpersec"])

num = 9
with open(".tables/sumstats_rbc_2_joint.tex", "w") as f:
    f.write(r"""\begin{table}[h]
\caption{NUTS with Joint Likelihood, RBC Model, Second-order}
\label{tab:rbc_NUTS_joint_2}
\centering
\scriptsize
""")
    joint_2.to_latex(buf = f, index = False, escape = False, column_format = "c" * num, header = ["Parameters", "Pseudotrue", "Post. Mean", "Post. Std.", "ESS", "R-hat", "ESS\%", "ESS/second", "Time"], formatters = [lambda s: f"${s}$"] + [process for i in range(num - 2)] + [lambda s: f"${int(round(s))}$"])
    f.write(r"""
{\raggedright Notes: We draw 5,500 samples in total and discard the first 500 samples. The sampling time is
measured in seconds and excludes \texttt{Julia} compilation time. The length of the samples is chosen
such that the total sampling time is close to the Dynare counterpart. \par}
\normalsize
\end{table}""")
