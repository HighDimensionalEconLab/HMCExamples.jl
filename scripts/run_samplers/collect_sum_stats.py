# Utility to loop through the folder, collect sumstats, etc.
# Convert this to a PDF with pandoc: pandoc --pdf-engine=xelatex ./.replication_results/sumstats.md -o ./.replication_results/sumstats.pdf
import os
import json
import pandas as pd

def convert_to_text_equiv(col):
    if isinstance(col, str):
        col = col.replace("α", "alpha")
        col = col.replace("β", "beta")
        col = col.replace("ρ", "rho")
    return col

def csv_to_markdown_table(csv_file):
    df = pd.read_csv(csv_file)
    df = df.round(5)  # Round values to 5 significant digits
    df = df.applymap(convert_to_text_equiv)  # Convert Greek letters to text equivalents
    col_map = {"alpha": "alpha", "beta": "beta", "rho": "rho"}  # Map text equivalents to text equivalents
    df = df.rename(columns=col_map)
    return df.to_markdown(index=False)

def calculate_T(dirname):
    if "500" in dirname:
        return 500
    else:
        return 200

def main():    
    results_md = ""
    results_location = "./.replication_results"

    for root, dirs, files in os.walk(results_location):
        if "sumstats.csv" in files and "parameters.json" in files:
            # Get directory name
            dirname = os.path.basename(root)

            # Calculate T
            T = calculate_T(dirname)

            # Load parameters.json and extract num_samples
            with open(os.path.join(root, "parameters.json"), "r", encoding="utf-8") as f:
                parameters = json.load(f)
                num_samples = parameters.get("num_samples", "N/A")

            # Create header
            header = f"## {dirname} with {num_samples} samples and T = {T}\n"
            results_md += header

            # Convert sumstats.csv to markdown table
            sumstats_md_table = csv_to_markdown_table(os.path.join(root, "sumstats.csv"))
            results_md += sumstats_md_table + "\n\n"

    # Save results.md
    with open(os.path.join(results_location,"sumstats.md"), "w", encoding="utf-8") as f:
        f.write(results_md)

if __name__ == "__main__":
    main()
