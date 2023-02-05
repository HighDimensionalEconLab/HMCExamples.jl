import pandas as pd

num_samples_1st_order = 5000

def process(n):
    if "." in str(n):
        number = str(n)[:6]
        num_decimal = len(number.split(".")[1])
        res = f"${str(round(n, num_decimal)).ljust(6, '0')}$"
        if res.startswith("$0.000"):
            return "$"+str(round(n*10000, 2))+" \cdot 10^{-4}$"
        return res
    return f"${n}$"

joint_1 = pd.read_csv(".experiments/rbc_volatility/rbc_volatility_1_joint/sumstats.csv").drop(columns = "Parameter").drop(columns = "Num_error")
joint_1.insert(0, "Parameters", [r"\alpha", r"\beta"])
joint_1.insert(1, "Pseudotrue", ["0.5", "0.95"])
joint_1.insert(6, "ESS\%", 100 * joint_1.loc[:, "ESS"] / num_samples_1st_order) # num_samples
joint_1.insert(8, "Time", joint_1.loc[:, "ESS"] / joint_1.loc[:, "ESSpersec"])

num = 9
with open(".tables/sumstats_rbc_volatility_1_joint.tex", "w") as f:
    f.write(r"""\begin{table}[h]
\caption{NUTS with Joint Likelihood, RBC Model with Stochastic Volatility, First-order}
\label{tab:rbc_volatility_NUTS_joint_1}
\centering
\scriptsize
""")
    joint_1.to_latex(buf = f, index = False, escape = False, column_format = "c" * num, header = ["Parameters", "Pseudotrue", "Post. Mean", "Post. Std.", "ESS", "R-hat", "ESS\%", "ESS/second", "Time"], formatters = [lambda s: f"${s}$"]*2 + [process for i in range(num - 3)] + [lambda s: f"${int(round(s))}$"])
    f.write(r"""
{\raggedright Notes: We draw NUM,SAMPLES samples in total and discard the first DISCARD,SAMPLES samples. The sampling time is
measured in seconds and the acceptance rate is automatically tuned to 65\%. \par}
\normalsize
\end{table}""")
