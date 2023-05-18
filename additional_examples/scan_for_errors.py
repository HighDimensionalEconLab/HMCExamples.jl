import os
import pandas as pd

verbose = False

# frequentist
i = 0
for file in os.listdir(f".replication_results/frequentist"):
    i += 1
    stats = pd.read_csv(f".replication_results/frequentist/{file}/sumstats.csv")
    if verbose:
        print(file, max(stats.loc[:, "Num_error"]))
    if max(stats.loc[:, "Num_error"]) != 0:
        print(file, "has nonzero maximum Num_error:", max(stats.loc[:, "Num_error"]))
print(i, "runs detected in frequentist")
      
# robustness
i = 0
for file in os.listdir(f".replication_results/robustness"):
    i += 1
    stats = pd.read_csv(f".replication_results/robustness/{file}/sumstats.csv")
    if verbose:
        print(file, max(stats.loc[:, "Num_error"]))
    if max(stats.loc[:, "Num_error"]) != 0:
        print(file, "has nonzero maximum Num_error:", max(stats.loc[:, "Num_error"]))
print(i, "runs detected in robustness")

# general
i = 0
for file in os.listdir(f".replication_results"):
    if "_" in file and "dynare" not in file:
        i += 1
        stats = pd.read_csv(f".replication_results/{file}/sumstats.csv")
        if verbose:
            print(file, max(stats.loc[:, "Num_error"]))
        if max(stats.loc[:, "Num_error"]) != 0:
            print(file, "has nonzero maximum Num_error:", max(stats.loc[:, "Num_error"]))
print(i, "general runs detected")

print("done")
