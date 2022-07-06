import os
import pandas as pd

# frequentist
for batch in ["1_joint", "1_kalman", "2_joint"]:
    for file in os.listdir(f".experiments/frequentist_julia/{batch}"):
        if "frequentist" in file:
            stats = pd.read_csv(f".experiments/frequentist_julia/{batch}/{file}/sumstats.csv")
            if max(stats.loc[:, "Num_error"]) != 0:
                print(file, "has nonzero maximum Num_error:", max(stats.loc[:, "Num_error"]))