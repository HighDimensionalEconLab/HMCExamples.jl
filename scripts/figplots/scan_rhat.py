import os
import pandas as pd
total = 0
counter = 0
for folder in os.listdir(f".experiments/robustness_julia"):
    for file in os.listdir(f".experiments/robustness_julia/{folder}"):
        if "robustness" in file:
            stats = pd.read_csv(f".experiments/robustness_julia/{folder}/{file}/sumstats.csv")
            print(file)
            total += sum(stats.loc[:, "Rhat"])
            counter += 3
            print(stats.loc[:, "Rhat"])
            print()
print("avg Rhat is", total/counter)
print("done")
