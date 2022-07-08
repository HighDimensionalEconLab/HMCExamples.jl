import os
import pandas as pd

verbose = False

# frequentist
for batch in ["1_joint", "1_kalman", "2_joint"]:
    for file in os.listdir(f".experiments/frequentist_julia/{batch}"):
        if "frequentist" in file:
            stats = pd.read_csv(f".experiments/frequentist_julia/{batch}/{file}/sumstats.csv")
            if verbose:
                print(file, max(stats.loc[:, "Num_error"]))
            if max(stats.loc[:, "Num_error"]) != 0:
                print(file, "has nonzero maximum Num_error:", max(stats.loc[:, "Num_error"]))
                
# statplots
for file in os.listdir(f".experiments/statplots_julia"):
    if "f124" in file:
        stats = pd.read_csv(f".experiments/statplots_julia/{file}/sumstats.csv")
        if verbose:
            print(file, max(stats.loc[:, "Num_error"]))
        if max(stats.loc[:, "Num_error"]) != 0:
            print(file, "has nonzero maximum Num_error:", max(stats.loc[:, "Num_error"]))

# sumstats
for file in os.listdir(f".experiments/benchmarks_julia"):
    stats = pd.read_csv(f".experiments/benchmarks_julia/{file}/sumstats.csv")
    if verbose:
        print(file, max(stats.loc[:, "Num_error"]))
    if max(stats.loc[:, "Num_error"]) != 0:
        print(file, "has nonzero maximum Num_error:", max(stats.loc[:, "Num_error"]))

# robustness
for folder in os.listdir(f".experiments/robustness_julia"):
    for file in os.listdir(f".experiments/robustness_julia/{folder}"):
        if "robustness" in file:
            stats = pd.read_csv(f".experiments/robustness_julia/{folder}/{file}/sumstats.csv")
            if verbose:
                print(file, max(stats.loc[:, "Num_error"]))
            if max(stats.loc[:, "Num_error"]) != 0:
                print(file, "has nonzero maximum Num_error:", max(stats.loc[:, "Num_error"]))

print("done")
