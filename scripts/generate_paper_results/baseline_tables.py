import json
import pandas as pd

def process(n):
    if "." in str(n):
        number = str(n)[:6]
        num_decimal = len(number.split(".")[1])
        res = f"${str(round(n, num_decimal)).ljust(6, '0')}$"
        if res.startswith("$0.000"):
            return "$"+str(round(n*10000, 2))+" \cdot 10^{-4}$"
        return res
    return f"${n}$"

def generate_table(run, caption, label, parameters, pseudotrue, estimation_type = "julia"):
    if estimation_type == "dynare_kalman":
        total_samples = 0
        removed_samples = 0
        runtime = 0
        special_footnote_entry = r"The sampling time is measured in seconds and excludes model file generation and compilation. \par}"
    elif estimation_type == "dynare_particle":
        total_samples = 0
        removed_samples = 0
        runtime = 0
        special_footnote_entry = r"We use 60,000 particles. The sampling time is measured in seconds and excludes model file generation and compilation. \par}"
    else:
        with open(f".replication_results/{run}/result.json", encoding="utf8") as f:
            params = json.load(f)
        num_samples = params["num_samples"]
        adapts = params["adapts_burnin_prop"]
        raw_num_samples = (1 + adapts) * num_samples
        
        total_samples = raw_num_samples
        removed_samples = raw_num_samples - num_samples
        target_acceptance_rate = params["target_acceptance_rate"]
        runtime = params["time_elapsed"]
        special_footnote_entry = rf"The sampling time is measured in seconds and excludes \texttt{{Julia}} compilation time. The acceptance rate is automatically tuned to {int(round(target_acceptance_rate * 100))}\%.\par}}"
    
    num_columns = 9

    table_base = pd.read_csv(f".replication_results/{run}/sumstats.csv").drop(columns = "Parameter").drop(columns = "Num_error")
    table_base.insert(0, "Parameters", parameters)
    table_base.insert(1, "Pseudotrue", pseudotrue)
    table_base.insert(6, "ESS\%", 100 * table_base.loc[:, "ESS"] / num_samples)
    table_base.insert(8, "Time", [runtime] * len(parameters))

    with open(f".paper_results/sumstats_{run}.tex", "w", encoding="utf8") as f:
        f.write("\n".join([
            r"\begin{table}[h]",
            rf"\caption{caption}",
            rf"\label{{tab:{label}}}",
            r"\centering",
            r"\scriptsize",
            ""
        ]))
        table_base.to_latex(buf = f, index = False, escape = False, column_format = "c" * num_columns, header = ["Parameters", "Pseudotrue", "Post. Mean", "Post. Std.", "ESS", "R-hat", "ESS\%", "ESS/second", "Time"], formatters = [lambda s: f"${s}$"]*2 + [process for _ in range(num_columns - 3)] + [lambda s: f"${int(round(s))}$"])
        f.write("\n".join([
            rf"{{\raggedright Notes: We draw {total_samples:,} samples in total and discard the first {removed_samples:,} samples. ",
            special_footnote_entry,
            r"\normalsize",
            r"\end{table}"
        ]))

rbc_parameters = [r"\alpha", r"\beta_{draw}", r"\rho"]
rbc_pseudotrue = ["0.3", "0.2", "0.9"]

generate_table("rbc_1_kalman_200", "NUTS with Marginal Likelihood, RBC Model, First-order", "rbc_NUTS_kalman", rbc_parameters, rbc_pseudotrue)
generate_table("rbc_1_joint_200", "NUTS with Joint Likelihood, RBC Model, First-order", "rbc_NUTS_joint_1", rbc_parameters, rbc_pseudotrue)
generate_table("rbc_2_joint_200_long", "NUTS with Joint Likelihood, RBC Model, Second-order", "rbc_NUTS_joint_2", rbc_parameters, rbc_pseudotrue)

generate_table("rbc_1_200_dynare", "RWMH with Marginal Likelihood, RBC Model, First-order", "rbc_RWMH_kalman", rbc_parameters, rbc_pseudotrue, estimation_type = "dynare_kalman")
generate_table("rbc_2_200_dynare", "RWMH with Marginal Likelihood on Particle Filter, RBC Model, Second-order", "rbc_RWMH_particle", rbc_parameters, rbc_pseudotrue, estimation_type = "dynare_particle")

generate_table("rbc_sv_2_joint_200", "NUTS with Joint Likelihood, RBC Model with Stochastic Volatility, Second-order", "rbc_sv_NUTS_joint_2", rbc_parameters, rbc_pseudotrue)

sgu_parameters = [r"\alpha", r"\gamma", r"\psi", r"\beta_{draw}", r"\rho", r"\rho_u", r"\rho_v"]
sgu_pseudotrue = ["0.32", "2.0", "7.42 \cdot 10^{-4}", "4", "0.42", "0.2", "0.4"]

generate_table("sgu_1_kalman_200", "NUTS with Marginal Likelihood, SGU Model, First-order", "sgu_NUTS_kalman", sgu_parameters, sgu_pseudotrue)
generate_table("rbc_1_joint_200", "NUTS with Joint Likelihood, SGU Model, First-order", "sgu_NUTS_joint_1", sgu_parameters, sgu_pseudotrue)
generate_table("rbc_2_joint_200_long", "NUTS with Joint Likelihood, SGU Model, Second-order", "sgu_NUTS_joint_2", sgu_parameters, sgu_pseudotrue)

generate_table("sgu_1_200_dynare", "RWMH with Marginal Likelihood, SGU Model, First-order", "sgu_RWMH_kalman", sgu_parameters, sgu_pseudotrue, estimation_type = "dynare_kalman")
generate_table("sgu_2_200_dynare", "RWMH with Marginal Likelihood on Particle Filter, SGU Model, Second-order", "sgu_RWMH_particle", sgu_parameters, sgu_pseudotrue, estimation_type = "dynare_particle")