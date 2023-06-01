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

table_notes = r"{{\raggedright Notes: All these statistics are generated from {num_seeds} estimation replications for each T with total {runs_dropped:.0f} dropped due to numerical errors. We draw {total_samples} samples in total and discard the first {discarded_samples} samples.\par}}"

# kalman table
kalman_50 = pd.read_csv(".replication_results/frequentist/freqstats_rbc_1_kalman_50.csv")
num_seeds, num_samples, adapts_burnin_prop, runs_dropped = kalman_50.iloc[0][["num_seeds", "num_samples", "adapts_burnin_prop", "runs_dropped"]]
total_samples = round(num_samples * (1 + adapts_burnin_prop))
discarded_samples = round(num_samples * adapts_burnin_prop)   
kalman_50.drop(columns = ["Parameter", "num_seeds", "num_samples", "adapts_burnin_prop", "runs_dropped"], inplace = True)
kalman_50.insert(0, "Parameters", [r"\alpha", r"\beta_{draw}", r"\rho"])
kalman_50.insert(0, "T", ["T = 50", "", ""])
kalman_100 = pd.read_csv(".replication_results/frequentist/freqstats_rbc_1_kalman_100.csv").drop(columns = ["Parameter", "num_seeds", "num_samples", "adapts_burnin_prop"])
runs_dropped += kalman_100.iloc[0]["runs_dropped"]
kalman_100.drop(columns = ["runs_dropped"], inplace = True)
kalman_100.insert(0, "Parameters", [r"\alpha", r"\beta_{draw}", r"\rho"])
kalman_100.insert(0, "T", ["T = 100", "", ""])
kalman_200 = pd.read_csv(".replication_results/frequentist/freqstats_rbc_1_kalman_200.csv").drop(columns = ["Parameter", "num_seeds", "num_samples", "adapts_burnin_prop"])
runs_dropped += kalman_200.iloc[0]["runs_dropped"]
kalman_200.drop(columns = ["runs_dropped"], inplace = True)
kalman_200.insert(0, "Parameters", [r"\alpha", r"\beta_{draw}", r"\rho"])
kalman_200.insert(0, "T", ["T = 200", "", ""])
kalman = pd.concat([kalman_50, kalman_100, kalman_200])
kalman_list = kalman.to_latex(index = False, escape = False, column_format = "c" * 6, header = ["", "Parameters", "Mean Bias", "MSE", "Cov. Prob. 80\%", "Cov. Prob. 90\%"], formatters = [lambda s: [s, f"${s}$"][s != ""]] * 2 + [process] * 2 + [pcthandle] * 2).split("\n")
kalman_list.insert(10, r'\midrule')
kalman_list.insert(7, r'\midrule')
kalman = "\n".join(kalman_list)
with open(".paper_results/freqstats_rbc_1_kalman.tex", "w") as f:
    f.write(r"""\begin{table}[h]
\caption{Frequentist Statistics -- Kalman}
\label{tab:freqstats_kalman}
\centering
""")
    f.write(kalman)
    f.write(table_notes.format(num_seeds = num_seeds, runs_dropped = runs_dropped, total_samples = total_samples, discarded_samples = discarded_samples))    
    f.write(r"""
\end{table}""")


# joint 1 table
joint_1_50 = pd.read_csv(".replication_results/frequentist/freqstats_rbc_1_joint_50.csv")
num_seeds, num_samples, adapts_burnin_prop, runs_dropped = joint_1_50.iloc[0][["num_seeds", "num_samples", "adapts_burnin_prop", "runs_dropped"]]
total_samples = round(num_samples * (1 + adapts_burnin_prop))
discarded_samples = round(num_samples * adapts_burnin_prop)   
joint_1_50.drop(columns = ["Parameter", "num_seeds", "num_samples", "adapts_burnin_prop", "runs_dropped"], inplace = True)
joint_1_50.insert(0, "Parameters", [r"\alpha", r"\beta_{draw}", r"\rho"])
joint_1_50.insert(0, "T", ["T = 50", "", ""])
joint_1_100 = pd.read_csv(".replication_results/frequentist/freqstats_rbc_1_joint_100.csv").drop(columns = ["Parameter", "num_seeds", "num_samples", "adapts_burnin_prop"])
runs_dropped += joint_1_100.iloc[0]["runs_dropped"]
joint_1_100.drop(columns = ["runs_dropped"], inplace = True)
joint_1_100.insert(0, "Parameters", [r"\alpha", r"\beta_{draw}", r"\rho"])
joint_1_100.insert(0, "T", ["T = 100", "", ""])
joint_1_200 = pd.read_csv(".replication_results/frequentist/freqstats_rbc_1_joint_200.csv").drop(columns = ["Parameter", "num_seeds", "num_samples", "adapts_burnin_prop"])
runs_dropped += joint_1_200.iloc[0]["runs_dropped"]
joint_1_200.drop(columns = ["runs_dropped"], inplace = True)
joint_1_200.insert(0, "Parameters", [r"\alpha", r"\beta_{draw}", r"\rho"])
joint_1_200.insert(0, "T", ["T = 200", "", ""])
joint_1 = pd.concat([joint_1_50, joint_1_100, joint_1_200])
joint_1_list = joint_1.to_latex(index = False, escape = False, column_format = "c" * 6, header = ["", "Parameters", "Mean Bias", "MSE", "Cov. Prob. 80\%", "Cov. Prob. 90\%"], formatters = [lambda s: [s, f"${s}$"][s != ""]] * 2 + [process] * 2 + [pcthandle] * 2).split("\n")
joint_1_list.insert(10, r'\midrule')
joint_1_list.insert(7, r'\midrule')
joint_1 = "\n".join(joint_1_list)
with open(".paper_results/freqstats_rbc_1_joint.tex", "w") as f:
    f.write(r"""\begin{table}[h]
\caption{Frequentist Statistics -- First-order Joint}
\label{tab:freqstats_joint_1}
\centering
""")
    f.write(joint_1)
    f.write(table_notes.format(num_seeds = num_seeds, runs_dropped = runs_dropped, total_samples = total_samples, discarded_samples = discarded_samples))    
    f.write(r"""
\end{table}""")


# joint 2 table
joint_2_50 = pd.read_csv(".replication_results/frequentist/freqstats_rbc_2_joint_50.csv")
num_seeds, num_samples, adapts_burnin_prop, runs_dropped = joint_2_50.iloc[0][["num_seeds", "num_samples", "adapts_burnin_prop", "runs_dropped"]]
total_samples = round(num_samples * (1 + adapts_burnin_prop))
discarded_samples = round(num_samples * adapts_burnin_prop)   
joint_2_50.drop(columns = ["Parameter", "num_seeds", "num_samples", "adapts_burnin_prop", "runs_dropped"], inplace = True)
joint_2_50.insert(0, "Parameters", [r"\alpha", r"\beta_{draw}", r"\rho"])
joint_2_50.insert(0, "T", ["T = 50", "", ""])
joint_2_100 = pd.read_csv(".replication_results/frequentist/freqstats_rbc_2_joint_100.csv").drop(columns = ["Parameter", "num_seeds", "num_samples", "adapts_burnin_prop"])
runs_dropped += joint_2_100.iloc[0]["runs_dropped"]
joint_2_100.drop(columns = ["runs_dropped"], inplace = True)
joint_2_100.insert(0, "Parameters", [r"\alpha", r"\beta_{draw}", r"\rho"])
joint_2_100.insert(0, "T", ["T = 100", "", ""])
joint_2_200 = pd.read_csv(".replication_results/frequentist/freqstats_rbc_2_joint_200.csv").drop(columns = ["Parameter", "num_seeds", "num_samples", "adapts_burnin_prop"])
runs_dropped += joint_2_200.iloc[0]["runs_dropped"]
joint_2_200.drop(columns = ["runs_dropped"], inplace = True)
joint_2_200.insert(0, "Parameters", [r"\alpha", r"\beta_{draw}", r"\rho"])
joint_2_200.insert(0, "T", ["T = 200", "", ""])
joint_2 = pd.concat([joint_2_50, joint_2_100, joint_2_200])
joint_2_list = joint_2.to_latex(index = False, escape = False, column_format = "c" * 6, header = ["", "Parameters", "Mean Bias", "MSE", "Cov. Prob. 80\%", "Cov. Prob. 90\%"], formatters = [lambda s: [s, f"${s}$"][s != ""]] * 2 + [process] * 2 + [pcthandle] * 2).split("\n")
joint_2_list.insert(10, r'\midrule')
joint_2_list.insert(7, r'\midrule')
joint_2 = "\n".join(joint_2_list)
with open(".paper_results/freqstats_rbc_2_joint.tex", "w") as f:
    f.write(r"""\begin{table}
\caption{Frequentist Statistics -- Second-order Joint}
\label{tab:freqstats_joint_2}
\centering
""")
    f.write(joint_2)
    f.write(table_notes.format(num_seeds = num_seeds, runs_dropped = runs_dropped, total_samples = total_samples, discarded_samples = discarded_samples))    
    f.write(r"""
\end{table}""")
