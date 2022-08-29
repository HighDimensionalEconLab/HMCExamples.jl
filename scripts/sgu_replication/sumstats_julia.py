import pandas as pd

num_samples_kalman = 5000
num_samples_1st_order = 5000
num_samples_2nd_order = 5000

def process(n):
    if "." in str(n):
        number = str(n)[:6]
        num_decimal = len(number.split(".")[1])
        return f"${str(round(n, num_decimal)).ljust(6, '0')}$"
    return f"${n}$"

kalman = pd.read_csv(".experiments/sgu/sgu_1_kalman/sumstats.csv").drop(columns = "Parameter").drop(columns = "Num_error")
kalman.insert(0, "Parameters", [r"\alpha", r"\gamma", r"\psi", r"100\left(1/\beta-1\right)", r"\rho", r"\rho_u", r"\rho_v"])

joint_1 = pd.read_csv(".experiments/sgu/sgu_1_joint/sumstats.csv").drop(columns = "Parameter").drop(columns = "Num_error")
joint_2 = pd.read_csv(".experiments/sgu/sgu_2_joint/sumstats.csv").drop(columns = "Parameter").drop(columns = "Num_error")
kalman.insert(5, "Rhat_joint_2", joint_2.loc[:, "Rhat"])
kalman.insert(5, "Rhat_joint_1", joint_1.loc[:, "Rhat"])
kalman.insert(4, "ESS_joint_2", joint_2.loc[:, "ESS"])
kalman.insert(4, "ESS_joint_1", joint_1.loc[:, "ESS"])
kalman.insert(3, "StdDev_joint_2", joint_2.loc[:, "StdDev"])
kalman.insert(3, "StdDev_joint_1", joint_1.loc[:, "StdDev"])
kalman.insert(2, "Mean_joint_2", joint_2.loc[:, "Mean"])
kalman.insert(2, "Mean_joint_1", joint_1.loc[:, "Mean"])

kalman_runtime = int(round((kalman.loc[:, "ESS"] / kalman.loc[:, "ESSpersec"])[0]))
joint_1_runtime = int(round((joint_1.loc[:, "ESS"] / joint_1.loc[:, "ESSpersec"])[0]))
joint_2_runtime = int(round((joint_2.loc[:, "ESS"] / joint_2.loc[:, "ESSpersec"])[0]))

runtime_text = "The marginal likelihood takes {0:,} seconds to run, the 1st-order joint takes {1:,} seconds, and the 2nd-order joint takes {2:,} seconds.".format(kalman_runtime, joint_1_runtime, joint_2_runtime)

kalman = kalman.drop(columns = "ESSpersec")

num = 13
with open(".tables/sumstats_sgu.tex", "w") as f:
    f.write(r"""\begin{table}[h]
\caption{Estimation, SGU model}
\label{tab:sgu_result}
\centering
\scriptsize
""")
    res = kalman.to_latex(index = False, escape = False, column_format = "c" * num, header = ["Parameters", "Mean Kalman", "Mean Joint 1", "Mean Joint 2", "Std. Kalman", "Std. Joint 1", "Std. Joint 2", "ESS Kalman", "ESS Joint 1", "ESS Joint 2", "R-hat Kalman", "R-hat Joint 1", "R-hat Joint 2"], formatters = [lambda s: f"${s}$"] + [process for i in range(num - 1)]).split("\n")
    res[0] = r"\begin{tabular}{c|p{0.75cm}p{0.75cm}p{0.75cm}|p{0.75cm}p{0.75cm}p{0.75cm}|p{0.75cm}p{0.75cm}p{0.75cm}|p{0.75cm}p{0.75cm}p{0.75cm}}"
    res[2] = r"\textbf{Parameters} & \multicolumn{3}{|c|}{\textbf{Mean}} &  \multicolumn{3}{|c|}{\textbf{Std.}} &  \multicolumn{3}{c}{\textbf{ESS}} & \multicolumn{3}{|c}{\textbf{R-hat}}\\"
    res.insert(3, r"& Kalman & Joint 1st & Joint 2nd & Kalman & Joint 1st & Joint 2nd & Kalman & Joint 1st & Joint 2nd & Kalman & Joint 1st & Joint 2nd \\")
    f.write("\n".join(res) + "\n")                
    f.write(r"""
{\raggedright Notes: We draw 6,500 samples in total and discard the first 1,500 samples for each estimation. RUNTIME\par}
\normalsize
\end{table}""".replace("RUNTIME", runtime_text))
