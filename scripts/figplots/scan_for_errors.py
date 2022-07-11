import os
import pandas as pd

verbose = False

# frequentist
for batch in ["1_joint", "1_kalman", "2_joint"]:
    i = 0
    for file in os.listdir(f".experiments/frequentist_julia/{batch}"):
        if "frequentist" in file:
            i += 1
            stats = pd.read_csv(f".experiments/frequentist_julia/{batch}/{file}/sumstats.csv")
            if verbose:
                print(file, max(stats.loc[:, "Num_error"]))
            if max(stats.loc[:, "Num_error"]) != 0:
                print(file, "has nonzero maximum Num_error:", max(stats.loc[:, "Num_error"]))
    print(i, "runs detected in", batch, "frequentist")
                
# statplots
i = 0
for file in os.listdir(f".experiments/statplots_julia"):
    if "f124" in file:
        i += 1
        stats = pd.read_csv(f".experiments/statplots_julia/{file}/sumstats.csv")
        if verbose:
            print(file, max(stats.loc[:, "Num_error"]))
        if max(stats.loc[:, "Num_error"]) != 0:
            print(file, "has nonzero maximum Num_error:", max(stats.loc[:, "Num_error"]))
print(i, "runs detected in statplots")

# sumstats
i = 0
for file in os.listdir(f".experiments/benchmarks_julia"):
    i += 1
    stats = pd.read_csv(f".experiments/benchmarks_julia/{file}/sumstats.csv")
    if verbose:
        print(file, max(stats.loc[:, "Num_error"]))
    if max(stats.loc[:, "Num_error"]) != 0:
        print(file, "has nonzero maximum Num_error:", max(stats.loc[:, "Num_error"]))
print(i, "runs detected in sumstats")

# robustness
for folder in os.listdir(f".experiments/robustness_julia"):
    i = 0
    for file in os.listdir(f".experiments/robustness_julia/{folder}"):
        if "robustness" in file:
            stats = pd.read_csv(f".experiments/robustness_julia/{folder}/{file}/sumstats.csv")
            if verbose:
                print(file, max(stats.loc[:, "Num_error"]))
            if max(stats.loc[:, "Num_error"]) != 0:
                print(file, "has nonzero maximum Num_error:", max(stats.loc[:, "Num_error"]))
            i += 1
    print(i, "runs detected in", folder, "robustness")

print("done")
