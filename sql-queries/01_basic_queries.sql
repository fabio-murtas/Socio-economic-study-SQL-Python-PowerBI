-- Data trimming and cleaning
-- We could also check for NULL values and Replace incorrect characters like '-' but that is beyond the scope of this project.

-- for energy table
CREATE TABLE "Energy_standard" AS
SELECT 
  LOWER(TRIM(Code)) AS code,                -- lowercase and get rid of ghost spaces
  LOWER(TRIM(Country)) AS country,
  CAST(TRIM(Year) AS INTEGER) AS year,      -- Assign data type
  ROUND(CAST(TRIM(Per_capita_energy_consumption) AS REAL), 2) AS per_capita_energy_consumption  -- Round to 2 decimals
FROM "energy_data";

-- for gdp table
CREATE TABLE "GDP_standard" AS
SELECT 
  LOWER(TRIM(code)) AS code,
  LOWER(TRIM(country)) AS country,
  CAST(TRIM(year) AS INTEGER) AS year,
  ROUND(CAST(TRIM(gdp_per_capita) AS REAL), 2) AS gdp_per_capita,
  LOWER(TRIM(world_region_according_to_owid)) AS world_region
FROM "gdp_data";

-- for population table
CREATE TABLE "Population_standard" AS
SELECT 
  LOWER(TRIM(Code)) AS code,
  LOWER(TRIM(Country)) AS country,
  CAST(TRIM(Year) AS INTEGER) AS year,
  CAST(TRIM(Population) AS INTEGER) AS population
FROM "population_data";

-- for real wages table
CREATE TABLE "Real_wages_standard" AS
SELECT 
  TRIM(ccode) AS code,
  LOWER(TRIM(country_name)) AS country,
  CAST(TRIM(year) AS INTEGER) AS year,
  ROUND(CAST(TRIM(value) AS REAL), 2) AS daily_true_wage
FROM "realwages_data";
