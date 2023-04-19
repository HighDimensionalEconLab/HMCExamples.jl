import pandas as pd

num_samples_kalman = 5000
num_samples_1st_order = 5000
num_samples_2nd_order = 5000

def process(n):
    if "." in str(n):
        number = str(n)[:6]
        num_decimal = len(number.split(".")[1])
        res = f"${str(round(n, num_decimal)).ljust(6, '0')}$"
        if res.startswith("$0.000"):
            return "$"+str(round(n*10000, 2))+" \cdot 10^{-4}$"
        return res
    return f"${n}$"

kalman = pd.read_csv(".experiments/sgu/sgu_1_kalman/sumstats.csv").drop(columns = "Parameter").drop(columns = "Num_error")
kalman.insert(0, "Parameters", [r"\alpha", r"\gamma", r"\psi", r"\beta_{draw}", r"\rho", r"\rho_u", r"\rho_v"])
kalman.insert(1, "Pseudotrue", ["0.32", "2.0", "7.42 \cdot 10^{-4}", "4", "0.42", "0.2", "0.4"])
kalman.insert(6, "ESS\%", 100 * kalman.loc[:, "ESS"] / num_samples_kalman) # num_samples
kalman.insert(8, "Time", kalman.loc[:, "ESS"] / kalman.loc[:, "ESSpersec"])
num = 9
with open(".tables/sumstats_sgu_1_kalman.tex", "w") as f:
    f.write(r"""\begin{table}[h]
\caption{NUTS with Marginal Likelihood, SGU Model, First-order}
\label{tab:sgu_NUTS_kalman}
\centering
\scriptsize
""")
    kalman.to_latex(buf = f, index = False, escape = False, column_format = "c" * num, header = ["Parameters", "Pseudotrue", "Post. Mean", "Post. Std.", "ESS", "R-hat", "ESS\%", "ESS/second", "Time"], formatters = [lambda s: f"${s}$"]*2 + [process for i in range(num - 3)] + [lambda s: f"${int(round(s))}$"])
    f.write(r"""
{\raggedright Notes: We draw 6,500 samples in total and discard the first 1,500 samples. The sampling time is
measured in seconds and the acceptance rate is automatically tuned to 65\%. \par}
\normalsize
\end{table}""")



joint_1 = pd.read_csv(".experiments/sgu/sgu_1_joint/sumstats.csv").drop(columns = "Parameter").drop(columns = "Num_error")
joint_1.insert(0, "Parameters", [r"\alpha", r"\gamma", r"\psi", r"\beta_{draw}", r"\rho", r"\rho_u", r"\rho_v"])
joint_1.insert(1, "Pseudotrue", ["0.32", "2.0", "{7.42^{_{\cdot 10^{-4}}}}", "4", "0.42", "0.2", "0.4"])
joint_1.insert(6, "ESS\%", 100 * joint_1.loc[:, "ESS"] / num_samples_1st_order) # num_samples
joint_1.insert(8, "Time", joint_1.loc[:, "ESS"] / joint_1.loc[:, "ESSpersec"])

num = 9
with open(".tables/sumstats_sgu_1_joint.tex", "w") as f:
    f.write(r"""\begin{table}[h]
\caption{NUTS with Joint Likelihood, SGU Model, First-order}
\label{tab:sgu_NUTS_joint_1}
\centering
\scriptsize
""")
    joint_1.to_latex(buf = f, index = False, escape = False, column_format = "c" * num, header = ["Parameters", "Pseudotrue", "Post. Mean", "Post. Std.", "ESS", "R-hat", "ESS\%", "ESS/second", "Time"], formatters = [lambda s: f"${s}$"]*2 + [process for i in range(num - 3)] + [lambda s: f"${int(round(s))}$"])
    f.write(r"""
{\raggedright Notes: We draw 6,500 samples in total and discard the first 1,500 samples. The sampling time is
measured in seconds and the acceptance rate is automatically tuned to 90\%. \par}
\normalsize
\end{table}""")

joint_2 = pd.read_csv(".experiments/sgu/sgu_2_joint/sumstats.csv").drop(columns = "Parameter").drop(columns = "Num_error")
joint_2.insert(0, "Parameters", [r"\alpha", r"\gamma", r"\psi", r"\beta_{draw}", r"\rho", r"\rho_u", r"\rho_v"])
joint_2.insert(1, "Pseudotrue", ["0.32", "2.0", "{7.42^{_{\cdot 10^{-4}}}}", "4", "0.42", "0.2", "0.4"])
joint_2.insert(6, "ESS\%", 100 * joint_2.loc[:, "ESS"] / num_samples_2nd_order) # num_samples
joint_2.insert(8, "Time", joint_2.loc[:, "ESS"] / joint_2.loc[:, "ESSpersec"])

num = 9
with open(".tables/sumstats_sgu_2_joint.tex", "w") as f:
    f.write(r"""\begin{table}[h]
\caption{NUTS with Joint Likelihood, SGU Model, Second-order}
\label{tab:sgu_NUTS_joint_2}
\centering
\scriptsize
""")
    joint_2.to_latex(buf = f, index = False, escape = False, column_format = "c" * num, header = ["Parameters", "Pseudotrue", "Post. Mean", "Post. Std.", "ESS", "R-hat", "ESS\%", "ESS/second", "Time"], formatters = [lambda s: f"${s}$"]*2 + [process for i in range(num - 3)] + [lambda s: f"${int(round(s))}$"])
    f.write(r"""
{\raggedright Notes: We draw 6,500 samples in total and discard the first 1,500 samples. The sampling time is
measured in seconds and the acceptance rate is automatically tuned to 65\%. \par}
\normalsize
\end{table}""")
