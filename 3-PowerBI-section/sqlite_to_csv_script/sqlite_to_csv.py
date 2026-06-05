from pathlib import Path
import sqlite3
import pandas as pd


db_folder = Path(__file__).parent

for db_file in db_folder.glob("*.db"):

    print(f"\nProcessing {db_file.name}")

    conn = sqlite3.connect(db_file)

    tables = pd.read_sql(
        "SELECT name FROM sqlite_master WHERE type='table';",
        conn
    )

    # Create a folder for this database's CSVs
    output_dir = Path(db_file.stem)
    output_dir.mkdir(exist_ok=True)

    for table in tables['name']:
        df = pd.read_sql(f'SELECT * FROM "{table}"', conn)

        csv_file = output_dir / f"{table}.csv"
        df.to_csv(csv_file, index=False)

        print(f"Exported {csv_file}")

    conn.close()