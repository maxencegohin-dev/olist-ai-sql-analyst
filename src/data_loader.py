"""Load the Olist CSV files from data/raw/ into a local SQLite database (olist.db)."""
import glob
import os
import sqlite3

import pandas as pd

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RAW_DIR = os.path.join(ROOT_DIR, "data", "raw")
DB_PATH = os.path.join(ROOT_DIR, "olist.db")


def load_csv_to_sqlite():
    csv_files = sorted(glob.glob(os.path.join(RAW_DIR, "*.csv")))
    if not csv_files:
        raise SystemExit(f"No CSV file found in {RAW_DIR}. Download the Olist dataset from Kaggle first.")

    print(f"Loading {len(csv_files)} files into {DB_PATH}...")
    with sqlite3.connect(DB_PATH) as conn:
        for f in csv_files:
            # olist_customers_dataset.csv -> customers
            table_name = os.path.basename(f).replace("olist_", "").replace("_dataset.csv", "").replace(".csv", "")
            df = pd.read_csv(f)
            df.to_sql(table_name, conn, if_exists="replace", index=False)
            print(f"  {table_name}: {len(df):,} rows")

    print("Database ready.")


if __name__ == "__main__":
    load_csv_to_sqlite()
