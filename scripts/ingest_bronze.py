
import duckdb
from pathlib import Path
import hashlib

con = duckdb.connect("gamehub.duckdb")

con.execute("CREATE SCHEMA IF NOT EXISTS bronze")

con.execute("""
    CREATE TABLE IF NOT EXISTS bronze.ingestion_log (
        source_file VARCHAR,
        file_hash VARCHAR,
        ingested_at TIMESTAMP,
        row_count INTEGER
    )
""")


def calculate_file_hash(file_path):
    with open(file_path, "rb") as file:
        return hashlib.sha256(file.read()).hexdigest()


csv_files = sorted(Path("data/raw").glob("*.csv"))

for file in csv_files:
    table_name = file.stem
    file_hash = calculate_file_hash(file)

    # Check whether this file version was already loaded
    already_loaded = con.execute(
        """
        SELECT COUNT(*)
        FROM bronze.ingestion_log
        WHERE source_file = ? AND file_hash = ?
        """,
        [file.name, file_hash]
    ).fetchone()[0]

    if already_loaded > 0:
        print(f"SKIPPED {file.name}: already ingested")
        continue

    try:
        con.execute("BEGIN TRANSACTION")

        # Create the Bronze table if it does not exist
        con.execute(f"""
            CREATE TABLE IF NOT EXISTS bronze.{table_name} AS
            SELECT
                *,
                ? AS source_file,
                ? AS file_hash,
                CURRENT_TIMESTAMP AS ingested_at
            FROM read_csv_auto(?)
            WHERE FALSE
        """, [file.name, file_hash, str(file)])

        # Append the new file snapshot
        con.execute(f"""
            INSERT INTO bronze.{table_name}
            SELECT
                *,
                ? AS source_file,
                ? AS file_hash,
                CURRENT_TIMESTAMP AS ingested_at
            FROM read_csv_auto(?)
        """, [file.name, file_hash, str(file)])

        # Count rows belonging to this file version
        row_count = con.execute(
            f"""
            SELECT COUNT(*)
            FROM bronze.{table_name}
            WHERE source_file = ? AND file_hash = ?
            """,
            [file.name, file_hash]
        ).fetchone()[0]

        # Record successful ingestion
        con.execute("""
            INSERT INTO bronze.ingestion_log
            VALUES (?, ?, CURRENT_TIMESTAMP, ?)
        """, [file.name, file_hash, row_count])

        con.execute("COMMIT")

        print(f"LOADED {file.name}: {row_count} rows")

    except Exception:
        con.execute("ROLLBACK")
        print(f"FAILED {file.name}: transaction rolled back")
        raise

con.close()

print("Bronze ingestion completed!")
