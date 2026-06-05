-- =====================================================
-- CREATE A SUMMARY TABLE BY MERGING FOUR SOURCE DATASETS
-- This combines Population, GDP, Wages, and Energy data into
-- a single wide table using LEFT JOINs on Country and Year
-- =====================================================

CREATE TABLE SUMMARY_TABLE AS 

WITH 
-- ----------------------------------------------------
-- POPULATION (ANCHOR TABLE)
-- This is the primary dataset that defines every row.
-- We keep all Population records even if other tables lack data.
-- ----------------------------------------------------
pop AS (
    SELECT year, country, population FROM "Population_standard"
),

-- ----------------------------------------------------
-- GDP CAPITA METRICS
-- Contains GDP per capita and world region data.
-- Note: Some countries may have missing GDP for certain years.
-- ----------------------------------------------------
gdp AS (
    SELECT year, country, world_region, gdp_per_capita FROM "GDP_standard"
),

-- ----------------------------------------------------
-- REAL WAGES METRICS
-- Contains daily true wage data.
-- Note: Some countries may have missing wages for certain years.
-- ----------------------------------------------------
wag AS (
    SELECT year, country, daily_true_wage FROM "Real_wages_standard"
),

-- ----------------------------------------------------
-- ENERGY CONSUMPTION METRICS
-- Contains per capita energy consumption data.
-- Note: Some countries may have missing energy data for certain years.
-- ----------------------------------------------------
en AS (
    SELECT year, country, per_capita_energy_consumption FROM "Energy_standard"
)

-- =====================================================
-- MAIN MERGE LOGIC
-- =====================================================
SELECT 
    -- --- POPULATION METRICS (ANCHOR COLUMNS) ---
    pop.year AS year,                          -- Year identifier from anchor table
    pop.country AS country,                    -- Country name from anchor table
    pop.population AS population,              -- Population count from anchor table
    
    -- --- GDP CAPITA METRICS ---
    gdp.world_region AS world_region,          -- World region (NULL if missing)
    gdp.gdp_per_capita AS gdp_per_capita,      -- GDP per capita (NULL if missing)
    
    -- --- REAL WAGES METRICS ---
    wag.daily_true_wage AS daily_true_wage,    -- Daily wages (NULL if missing)
    
    -- --- ENERGY CONSUMPTION METRICS ---
    en.per_capita_energy_consumption AS per_capita_energy_consumption  -- Energy use (NULL if missing)

-- =====================================================
-- LEFT JOIN LOGIC
-- =====================================================
-- FROM pop: Start with every row in Population table.
-- LEFT JOIN gdp: Include GDP data only if country+year matches, else NULL.
-- LEFT JOIN wag: Include Wages data only if country+year matches, else NULL.
-- LEFT JOIN en:   Include Energy data only if country+year matches, else NULL.
FROM pop

LEFT JOIN gdp 
    ON pop.country = gdp.country AND pop.year = gdp.year

LEFT JOIN wag 
    ON pop.country = wag.country AND pop.year = wag.year

LEFT JOIN en 
    ON pop.country = en.country AND pop.year = en.year;