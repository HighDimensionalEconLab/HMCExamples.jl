import pandas as pd

def process(n):
    # if abs(number) is less than 0.0001: apply scientific notation with two decimal places
    if abs(float(n)) < 0.0001:
        return "${:.2e}".format(float(n)).replace("e", r"\times10^{").replace("-0", "-") + "}$"
    # otherwise, apply a simple rounding
    number = str(n)[:6]
    num_decimal = len(number.split(".")[1])
    return f"${str(round(n, num_decimal)).ljust(6, '0')}$"

def pcthandle(n):
    return f"${int(round(float(n) * 100))}\%$"

# kalman table
kalman_50 = pd.read_csv(".results/freqstats_rbc_1_kalman_50.csv").drop(columns = "Parameter")
kalman_50.insert(0, "Parameters", [r"\alpha", r"100\left(\beta^{-1}-1\right)", r"\rho"])
kalman_50.insert(0, "T", ["T = 50", "", ""])
kalman_100 = pd.read_csv(".results/freqstats_rbc_1_kalman_100.csv").drop(columns = "Parameter")
kalman_100.insert(0, "Parameters", [r"\alpha", r"100\left(\beta^{-1}-1\right)", r"\rho"])
kalman_100.insert(0, "T", ["T = 100", "", ""])
kalman_200 = pd.read_csv(".results/freqstats_rbc_1_kalman_200.csv").drop(columns = "Parameter")
kalman_200.insert(0, "Parameters", [r"\alpha", r"100\left(\beta^{-1}-1\right)", r"\rho"])
kalman_200.insert(0, "T", ["T = 200", "", ""])
kalman = pd.concat([kalman_50, kalman_100, kalman_200])
kalman_list = kalman.to_latex(index = False, escape = False, column_format = "c" * 6, header = ["", "Parameters", "Mean Bias", "MSE", "Cov. Prob. 80\%", "Cov. Prob. 90\%"], formatters = [lambda s: [s, f"${s}$"][s != ""]] * 2 + [process] * 2 + [pcthandle] * 2).split("\n")
kalman_list.insert(10, r'\midrule')
kalman_list.insert(7, r'\midrule')
kalman = "\n".join(kalman_list)
with open(".tables/freqstats_rbc_1_kalman.tex", "w") as f:
    f.write(r"""\begin{table}[h]
\caption{Frequentist Statistics -- Kalman}
\label{tab:freqstats_kalman}
\centering

""")
    f.write(kalman)
    f.write(r"""
{\raggedright Notes: All these statistics are generated from 100 estimation replications. We draw 5500 samples in total and discard the first 500 samples. \par}
\end{table}""")


# joint 1 table
joint_1_50 = pd.read_csv(".results/freqstats_rbc_1_joint_50.csv").drop(columns = "Parameter")
joint_1_50.insert(0, "Parameters", [r"\alpha", r"100\left(\beta^{-1}-1\right)", r"\rho"])
joint_1_50.insert(0, "T", ["T = 50", "", ""])
joint_1_100 = pd.read_csv(".results/freqstats_rbc_1_joint_100.csv").drop(columns = "Parameter")
joint_1_100.insert(0, "Parameters", [r"\alpha", r"100\left(\beta^{-1}-1\right)", r"\rho"])
joint_1_100.insert(0, "T", ["T = 100", "", ""])
joint_1_200 = pd.read_csv(".results/freqstats_rbc_1_joint_200.csv").drop(columns = "Parameter")
joint_1_200.insert(0, "Parameters", [r"\alpha", r"100\left(\beta^{-1}-1\right)", r"\rho"])
joint_1_200.insert(0, "T", ["T = 200", "", ""])
joint_1 = pd.concat([joint_1_50, joint_1_100, joint_1_200])
joint_1_list = joint_1.to_latex(index = False, escape = False, column_format = "c" * 6, header = ["", "Parameters", "Mean Bias", "MSE", "Cov. Prob. 80\%", "Cov. Prob. 90\%"], formatters = [lambda s: [s, f"${s}$"][s != ""]] * 2 + [process] * 2 + [pcthandle] * 2).split("\n")
joint_1_list.insert(10, r'\midrule')
joint_1_list.insert(7, r'\midrule')
joint_1 = "\n".join(joint_1_list)
with open(".tables/freqstats_rbc_1_joint.tex", "w") as f:
    f.write(r"""\begin{table}[h]
\caption{Frequentist Statistics -- 1st-order Joint}
\label{tab:freqstats_joint_1}
\centering

""")
    f.write(joint_1)
    f.write(r"""
{\raggedright Notes: All these statistics are generated from 100 estimation replications. We draw 5500 samples in total and discard the first 500 samples. \par}
\end{table}""")


# joint 2 table
joint_2_50 = pd.read_csv(".results/freqstats_rbc_2_joint_50.csv").drop(columns = "Parameter")
joint_2_50.insert(0, "Parameters", [r"\alpha", r"100\left(\beta^{-1}-1\right)", r"\rho"])
joint_2_50.insert(0, "T", ["T = 50", "", ""])
joint_2_100 = pd.read_csv(".results/freqstats_rbc_2_joint_100.csv").drop(columns = "Parameter")
joint_2_100.insert(0, "Parameters", [r"\alpha", r"100\left(\beta^{-1}-1\right)", r"\rho"])
joint_2_100.insert(0, "T", ["T = 100", "", ""])
joint_2_200 = pd.read_csv(".results/freqstats_rbc_2_joint_200.csv").drop(columns = "Parameter")
joint_2_200.insert(0, "Parameters", [r"\alpha", r"100\left(\beta^{-1}-1\right)", r"\rho"])
joint_2_200.insert(0, "T", ["T = 200", "", ""])
joint_2 = pd.concat([joint_2_50, joint_2_100, joint_2_200])
joint_2_list = joint_2.to_latex(index = False, escape = False, column_format = "c" * 6, header = ["", "Parameters", "Mean Bias", "MSE", "Cov. Prob. 80\%", "Cov. Prob. 90\%"], formatters = [lambda s: [s, f"${s}$"][s != ""]] * 2 + [process] * 2 + [pcthandle] * 2).split("\n")
joint_2_list.insert(10, r'\midrule')
joint_2_list.insert(7, r'\midrule')
joint_2 = "\n".join(joint_2_list)
with open(".tables/freqstats_rbc_2_joint.tex", "w") as f:
    f.write(r"""\begin{table}
\caption{Frequentist Statistics -- 2nd-order Joint}
\label{tab:freqstats_joint_2}
\centering

""")
    f.write(joint_2)
    f.write(r"""
{\raggedright Notes: All these statistics are generated from 50 estimation replications. We draw 5500 samples in total and discard the first 500 samples. \par}
\end{table}""")


# drop-57 results


# kalman table
kalman_50 = pd.read_csv(".results/freqstats_rbc_1_kalman_50_drop57.csv").drop(columns = "Parameter")
kalman_50.insert(0, "Parameters", [r"\alpha", r"100\left(\beta^{-1}-1\right)", r"\rho"])
kalman_50.insert(0, "T", ["T = 50", "", ""])
kalman_100 = pd.read_csv(".results/freqstats_rbc_1_kalman_100_drop57.csv").drop(columns = "Parameter")
kalman_100.insert(0, "Parameters", [r"\alpha", r"100\left(\beta^{-1}-1\right)", r"\rho"])
kalman_100.insert(0, "T", ["T = 100", "", ""])
kalman_200 = pd.read_csv(".results/freqstats_rbc_1_kalman_200_drop57.csv").drop(columns = "Parameter")
kalman_200.insert(0, "Parameters", [r"\alpha", r"100\left(\beta^{-1}-1\right)", r"\rho"])
kalman_200.insert(0, "T", ["T = 200", "", ""])
kalman = pd.concat([kalman_50, kalman_100, kalman_200])
kalman_list = kalman.to_latex(index = False, escape = False, column_format = "c" * 6, header = ["", "Parameters", "Mean Bias", "MSE", "Cov. Prob. 80\%", "Cov. Prob. 90\%"], formatters = [lambda s: [s, f"${s}$"][s != ""]] * 2 + [process] * 2 + [pcthandle] * 2).split("\n")
kalman_list.insert(10, r'\midrule')
kalman_list.insert(7, r'\midrule')
kalman = "\n".join(kalman_list)
with open(".tables/freqstats_rbc_1_kalman_drop57.tex", "w") as f:
    f.write(r"""\begin{table}[h]
\caption{Frequentist Statistics -- Kalman}
\label{tab:freqstats_kalman}
\centering

""")
    f.write(kalman)
    f.write(r"""
{\raggedright Notes: All these statistics are generated from 100 estimation replications, minus a cumulative 7 with numerical errors. We draw 5500 samples in total and discard the first 500 samples. \par}
\end{table}""")


# joint 1 table
joint_1_50 = pd.read_csv(".results/freqstats_rbc_1_joint_50_drop57.csv").drop(columns = "Parameter")
joint_1_50.insert(0, "Parameters", [r"\alpha", r"100\left(\beta^{-1}-1\right)", r"\rho"])
joint_1_50.insert(0, "T", ["T = 50", "", ""])
joint_1_100 = pd.read_csv(".results/freqstats_rbc_1_joint_100_drop57.csv").drop(columns = "Parameter")
joint_1_100.insert(0, "Parameters", [r"\alpha", r"100\left(\beta^{-1}-1\right)", r"\rho"])
joint_1_100.insert(0, "T", ["T = 100", "", ""])
joint_1_200 = pd.read_csv(".results/freqstats_rbc_1_joint_200_drop57.csv").drop(columns = "Parameter")
joint_1_200.insert(0, "Parameters", [r"\alpha", r"100\left(\beta^{-1}-1\right)", r"\rho"])
joint_1_200.insert(0, "T", ["T = 200", "", ""])
joint_1 = pd.concat([joint_1_50, joint_1_100, joint_1_200])
joint_1_list = joint_1.to_latex(index = False, escape = False, column_format = "c" * 6, header = ["", "Parameters", "Mean Bias", "MSE", "Cov. Prob. 80\%", "Cov. Prob. 90\%"], formatters = [lambda s: [s, f"${s}$"][s != ""]] * 2 + [process] * 2 + [pcthandle] * 2).split("\n")
joint_1_list.insert(10, r'\midrule')
joint_1_list.insert(7, r'\midrule')
joint_1 = "\n".join(joint_1_list)
with open(".tables/freqstats_rbc_1_joint_drop57.tex", "w") as f:
    f.write(r"""\begin{table}[h]
\caption{Frequentist Statistics -- 1st-order Joint}
\label{tab:freqstats_joint_1}
\centering

""")
    f.write(joint_1)
    f.write(r"""
{\raggedright Notes: All these statistics are generated from 100 estimation replications, minus a cumulative 37 with numerical errors. We draw 5500 samples in total and discard the first 500 samples. \par}
\end{table}""")


# joint 2 table
joint_2_50 = pd.read_csv(".results/freqstats_rbc_2_joint_50_drop57.csv").drop(columns = "Parameter")
joint_2_50.insert(0, "Parameters", [r"\alpha", r"100\left(\beta^{-1}-1\right)", r"\rho"])
joint_2_50.insert(0, "T", ["T = 50", "", ""])
joint_2_100 = pd.read_csv(".results/freqstats_rbc_2_joint_100_drop57.csv").drop(columns = "Parameter")
joint_2_100.insert(0, "Parameters", [r"\alpha", r"100\left(\beta^{-1}-1\right)", r"\rho"])
joint_2_100.insert(0, "T", ["T = 100", "", ""])
joint_2_200 = pd.read_csv(".results/freqstats_rbc_2_joint_200_drop57.csv").drop(columns = "Parameter")
joint_2_200.insert(0, "Parameters", [r"\alpha", r"100\left(\beta^{-1}-1\right)", r"\rho"])
joint_2_200.insert(0, "T", ["T = 200", "", ""])
joint_2 = pd.concat([joint_2_50, joint_2_100, joint_2_200])
joint_2_list = joint_2.to_latex(index = False, escape = False, column_format = "c" * 6, header = ["", "Parameters", "Mean Bias", "MSE", "Cov. Prob. 80\%", "Cov. Prob. 90\%"], formatters = [lambda s: [s, f"${s}$"][s != ""]] * 2 + [process] * 2 + [pcthandle] * 2).split("\n")
joint_2_list.insert(10, r'\midrule')
joint_2_list.insert(7, r'\midrule')
joint_2 = "\n".join(joint_2_list)
with open(".tables/freqstats_rbc_2_joint_drop57.tex", "w") as f:
    f.write(r"""\begin{table}
\caption{Frequentist Statistics -- 2nd-order Joint}
\label{tab:freqstats_joint_2}
\centering

""")
    f.write(joint_2)
    f.write(r"""
{\raggedright Notes: All these statistics are generated from 50 estimation replications, minus a cumulative 13 with numerical errors. We draw 5500 samples in total and discard the first 500 samples. \par}
\end{table}""")
