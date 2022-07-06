import numpy as np
n_alpha = 5
n_beta = 5
n_rho = 5
alpha_list = np.linspace(0.25, 0.45, n_alpha)
beta_list = np.linspace(0.1, 0.4, n_beta)
rho_list = np.linspace(0.3, 0.95, n_rho)
with open(".experiments/benchmarks_dynare/dynare_log") as f:
    with open(".results/parsed_log", "w") as f2:
        for line in f:
            if len(line) >= 5 and line[1] == "_" and line[3] == "_":
                f2.write(f"alpha = {round(alpha_list[int(line[0]) - 1], 4)}, beta_draw = {round(beta_list[int(line[2]) - 1], 4)}, rho = {round(rho_list[int(line[4]) - 1], 4)}\n")
            if line.startswith("RW Metropolis-Hastings"):
                f2.write(line.replace("", "").split("RW Metropolis-Hastings (1/1) ")[-1])
                f2.write("\n")
