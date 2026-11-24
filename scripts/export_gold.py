
from pathlib import Path
import duckdb

DB_PATH = "gamehub.duckdb"
OUTPUT_DIR = Path("data/exports")

GOLD_TABLES = [
    "dim_customers",
    "fct_tickets",
    "mart_support_kpis",
    "mart_support_by_channel",
    "mart_support_by_issue_category",
    "mart_support_by_priority",
    "mart_agent_performance",
    "mart_agent_monthly_performance"
]

def main():
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    con = duckdb.connect(DB_PATH, read_only=True)

    try:
        for table in GOLD_TABLES:
            output_file = OUTPUT_DIR / f"{table}.parquet"

            con.execute(
                f"COPY (SELECT * FROM main.{table}) "
                f"TO '{output_file.as_posix()}' "
                f"(FORMAT PARQUET)"
            )

            print(f"Exported: {output_file}")
    finally:
        con.close()


if __name__ == "__main__":
    main()
