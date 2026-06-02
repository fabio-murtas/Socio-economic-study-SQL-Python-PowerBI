"""
Module: gen_sql_db.py
Description: Script to load socio-economic indicators from CSV/Excel sources
             into a SQLite database. Data sources are Worldbank, OWID and clioinfra as showed in file names.
Author: [Fabio Murtas]
Dependencies: pandas, sqlite3, os, pathlib
"""

import pandas as pd
import sqlite3 as sql3
import os
from pathlib import Path

# Use environment variable 'HOME' first, then fallback to system home directory.
# This ensures the script works on different user profiles without hardcoding paths.
home = os.environ['HOME'] or Path.home()

# Define absolute file paths using Path objects for cross-platform compatibility
gdp_capita = Path(home) / 'Projects' / 'Portfolio' / 'Socio-Economic study' / '_data' / 'gdp-per-capita-worldbank' / 'gdp-per-capita-worldbank.csv'
energy_capita = Path(home) / 'Projects' / 'Portfolio' / 'Socio-Economic study' / '_data' / 'per-capita-energy-use-owid' / 'per-capita-energy-use.csv'
population = Path(home) / 'Projects' / 'Portfolio' / 'Socio-Economic study' / '_data' / 'population-by-country-owid' / 'population.csv'
realwages = Path(home) / 'Projects' / 'Portfolio' / 'Socio-Economic study' / '_data' / 'LabourersRealWage_Broad-clioinfra.xlsx'
db_file = Path(home) / 'Projects' / 'Portfolio' / 'Socio-Economic study' / 'SQL' / 'databases' / 'social-data-gen.db'

# Initialize the connection to database variable before use
conn = None

try:

    print("Reading data...")

    # Read data into memory
    df_gdp = pd.read_csv(gdp_capita)
    df_energy = pd.read_csv(energy_capita)
    df_population = pd.read_csv(population)
    df_realwages = pd.read_excel(realwages)

    print("Connecting to database...")

    # Create a connection to a local SQLite file (.db)
    # This will create the file if it doesn't exist.
    conn = sql3.connect(db_file)

    print("Inserting data...")

    # Save GDP data to SQL table named 'gdp_data'. 
    # We pass the DataFrame 'df_gpd' and the connection object 'conn'.
    df_gdp.to_sql(
        'gdp_data',         # Table name inside SQLite
        conn,               # The active database connection
        index=False,        # CRITICAL: Do not write Pandas row index (0, 1, 2...) to DB. 
        if_exists='replace' # If table exists, drop it first then insert. Good for scripts where we want a fresh state each run.
    )
    df_energy.to_sql(
        'energy_data',
        conn,
        index=False,
        if_exists='replace'
    )
    df_population.to_sql(
        'population_data',
        conn,
        index=False,
        if_exists='replace'
    )

    # --- EXCEL HANDLING (Handling Multi-Sheet Files) ---
    # Open the Excel file using Pandas to read available sheets.
    # This is better than pd.read_excel inside a loop because it gives us a workbook object that we can inspect first for structure.

    workbook = pd.ExcelFile(realwages)

    # Loop through each sheet in the Excel file (e.g., "Sheet1", "Real Wages")
    for i, sheet_name in enumerate(workbook.sheet_names):
        print(f"Processing Sheet {i+1}: {sheet_name}")
        
        # Read the specific sheet into a temporary dataframe
        df_sheet = pd.read_excel(realwages, sheet_name=sheet_name)
        
        # Sanitize the table name for SQLite (remove special chars)
        clean_name = (
            sheet_name 
            .lower() 
            .replace(" ", "_") 
            .replace("-", "_")
            .strip("_")  # Remove leading/trailing underscores created by replacement
        )

        # Import the current 'df_sheet' data into SQL using the clean name
        df_sheet.to_sql(clean_name, conn, index=False, if_exists='replace') 


    print(f"Successfully imported records into SQLite database.")

# Catch any errors during execution and print them for debugging
except Exception as e:
    print(f"Error: {e}")
# Always close the connection, even if an error occurred above.
# This ensures the system resources are freed properly.
finally:
    if conn is not None:
        conn.close()