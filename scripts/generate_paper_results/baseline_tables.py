import json
import pandas as pd
def process_data(n):
    if "." in str(n):
        number = str(n)[:6]
        num_decimal = len(number.split(".")[1])
        res = f"${str(round(n, num_decimal)).ljust(6, '0')}$"
        if res.startswith("$0.000"):
            return "$"+str(round(n*10000, 2))+" \cdot 10^{-4}$"
        return res
    return f"${n}$"

def generate_sumstats_table(run, caption, parameters, pseudotrue, footnote, label = None):

    # default use the run name as the label
    if label is None:
        label = run

    # load the values from the result.json and convert to displayable values
    with open(f".replication_results/{run}/result.json", encoding="utf8") as f:
        params = json.load(f)
    T = params["T"]
    num_samples = params["num_samples"]
    adapts_burnin_prop = params["adapts_burnin_prop"]
    time_elapsed = params["time_elapsed"]
    if isinstance(time_elapsed, list):  # if multiple chains then it gives the time for all chains.
        num_chains = len(time_elapsed)
        time_elapsed = max(time_elapsed)
    else:
        num_chains = 1

    target_acceptance_rate = params.get("target_acceptance_rate", 0)
    target_acceptance_percent = int(round(target_acceptance_rate * 100))
    total_samples = round(num_samples * (1 + adapts_burnin_prop))
    discarded_samples = round(num_samples * adapts_burnin_prop)   

    num_columns = 9
    table_base = pd.read_csv(f".replication_results/{run}/sumstats.csv").drop(columns = "Parameter").drop(columns = "Num_error")
    table_base.insert(0, "Parameters", parameters)
    table_base.insert(1, "Pseudotrue", pseudotrue)
    table_base.insert(6, "ESS\%", 100 * table_base.loc[:, "ESS"] / num_samples)
    table_base.insert(8, "Time", [time_elapsed] * len(parameters))

    formatted_caption = caption.format(time_elapsed=time_elapsed, target_acceptance_percent=target_acceptance_percent, total_samples=total_samples, discarded_samples=discarded_samples, num_chains = num_chains, T=T)
    with open(f".paper_results/sumstats_{run}.tex", "w", encoding="utf8") as f:
        f.write("\n".join([
            r"\begin{table}[h]",
            rf"\caption{{{formatted_caption}}}",
            rf"\label{{tab:sumstats_{label}}}",
            r"\centering",
            r"\scriptsize",
            ""
        ]))
        
        latex_string = (
            table_base.style.format({col: (lambda s: f"${s}$") if col in ["Parameters", "Pseudotrue"] else (lambda s: f"${int(round(s))}$") if col == "Time" else process_data for col in table_base.columns})
            .hide(axis='index')  # hide index before writing to latex
            .to_latex(hrules=True)
        )
        
        f.write(latex_string)
        
        f.write("\n".join(["\n",
            footnote.format(time_elapsed=time_elapsed, target_acceptance_percent=target_acceptance_percent, total_samples=total_samples, discarded_samples=discarded_samples, num_chains = num_chains, T=T), # uses values loaded from the json and calculated above
            r"\normalsize",
            r"\end{table}"
        ]))


# Parameters and pseudotrue values
rbc_parameters = [r"\alpha", r"\beta_{draw}", r"\rho"]
rbc_pseudotrue = ["0.3", "0.2", "0.9"]
sgu_parameters = [r"\alpha", r"\gamma", r"\psi", r"\beta_{draw}", r"\rho", r"\rho_u", r"\rho_v"]
sgu_pseudotrue = ["0.32", "2.0", "7.42 \cdot 10^{-4}", "4", "0.42", "0.2", "0.4"]

# Footnote and caption templates.
# Note: use raw strings to apply `.format` and can reference: time_elapsed, target_acceptance_percent, total_samples, discarded_samples, num_chains, T.  Use {{ }} to escape the brackets otherwise used for formatting.
julia_footnote = r"{{\raggedright Notes: We draw {total_samples:,} samples in total and discard the first {discarded_samples:,} samples. The sampling time is measured in seconds and excludes \texttt{{Julia}} compilation time. The acceptance rate is automatically tuned to {target_acceptance_percent}\%.\par}}"
kalman_dynare_footnote = r"{{\raggedright Notes: We draw {total_samples:,} samples in total and discard the first {discarded_samples:,} samples. The sampling time is measured in seconds and excludes model file generation and compilation.\par}}"
julia_multichain_footnote = r"{{\raggedright Notes: We draw using {num_chains} chains each with {total_samples:,} samples in total and discard the first {discarded_samples:,} samples. The sampling time is the execution time until the last chain is complete, measured in seconds and excludes \texttt{{Julia}} compilation time. The acceptance rate is automatically tuned to {target_acceptance_percent}\%.\par}}"

# NOTE: These have hardcoded number of particles, which should be updated if the mod file is changed.
rbc_particle_dynare_footnote = r"{{\raggedright Notes: We draw {total_samples:,} samples in total and discard the first {discarded_samples:,} samples.  We use 20,000 particles. The sampling time is measured in seconds and excludes model file generation and compilation.\par}}"
sgu_particle_dynare_footnote = r"{{\raggedright Notes: We draw {total_samples:,} samples in total and discard the first {discarded_samples:,} samples.  We use 60,000 particles. The sampling time is measured in seconds and excludes model file generation and compilation.\par}}"

# RBC examples
generate_sumstats_table("rbc_1_kalman_200", "NUTS with Marginal Likelihood, RBC Model, First-order", rbc_parameters, rbc_pseudotrue, footnote = julia_footnote)
generate_sumstats_table("rbc_1_joint_200", "NUTS with Joint Likelihood, RBC Model, First-order", rbc_parameters, rbc_pseudotrue, footnote = julia_footnote)
generate_sumstats_table("rbc_2_joint_200", "NUTS with Joint Likelihood, RBC Model, Second-order", rbc_parameters, rbc_pseudotrue, footnote = julia_footnote)
generate_sumstats_table("rbc_2_joint_200_long", "NUTS with Joint Likelihood, RBC Model, Second-order", rbc_parameters, rbc_pseudotrue, footnote = julia_footnote)
generate_sumstats_table("rbc_1_200_dynare", "RWMH with Marginal Likelihood, RBC Model, First-order", rbc_parameters, rbc_pseudotrue, footnote = kalman_dynare_footnote)
generate_sumstats_table("rbc_2_200_dynare", "RWMH with Marginal Likelihood on Particle Filter, RBC Model, Second-order",  rbc_parameters, rbc_pseudotrue, footnote = rbc_particle_dynare_footnote)

# The T=500 cases change the caption
generate_sumstats_table("rbc_1_kalman_500", "NUTS with Marginal Likelihood, RBC Model, First-order, T = {T}", rbc_parameters, rbc_pseudotrue, footnote = julia_footnote)
generate_sumstats_table("rbc_1_joint_500", "NUTS with Joint Likelihood, RBC Model, First-order, T = {T}", rbc_parameters, rbc_pseudotrue, footnote = julia_footnote)
generate_sumstats_table("rbc_2_joint_500", "NUTS with Joint Likelihood, RBC Model, Second-order, T = {T}", rbc_parameters, rbc_pseudotrue, footnote = julia_footnote)
generate_sumstats_table("rbc_2_joint_500_long", "NUTS with Joint Likelihood, RBC Model, Second-order, T = {T}", rbc_parameters, rbc_pseudotrue, footnote = julia_footnote)

# RBC SV examples
generate_sumstats_table("rbc_sv_2_joint_200", "NUTS with Joint Likelihood, RBC Model with Stochastic Volatility, Second-order", rbc_parameters, rbc_pseudotrue, footnote = julia_multichain_footnote)

# SGU examples
generate_sumstats_table("sgu_1_kalman_200", "NUTS with Marginal Likelihood, SGU Model, First-order", sgu_parameters, sgu_pseudotrue, footnote = julia_footnote)
generate_sumstats_table("sgu_1_joint_200", "NUTS with Joint Likelihood, SGU Model, First-order", sgu_parameters, sgu_pseudotrue, footnote = julia_footnote)
generate_sumstats_table("sgu_2_joint_200", "NUTS with Joint Likelihood, SGU Model, Second-order", sgu_parameters, sgu_pseudotrue, footnote = julia_footnote)
generate_sumstats_table("sgu_1_200_dynare", "RWMH with Marginal Likelihood, SGU Model, First-order", sgu_parameters, sgu_pseudotrue, footnote = kalman_dynare_footnote)
generate_sumstats_table("sgu_2_200_dynare", "RWMH with Marginal Likelihood on Particle Filter, SGU Model, Second-order",  sgu_parameters, sgu_pseudotrue, footnote = sgu_particle_dynare_footnote)
