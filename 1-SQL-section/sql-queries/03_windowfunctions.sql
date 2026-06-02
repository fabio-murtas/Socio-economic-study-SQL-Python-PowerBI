SELECT  
    year,
    per_capita_energy_consumption,
    gdp_per_capita,
    -- 3-year rolling average (sliding window)
    ROUND(
        AVG(per_capita_energy_consumption) OVER (ORDER BY year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),
        2
    ) AS rolling_energy_3yr_avg_consumption,
    -- Year-over-Year change percentage
    CASE 
        WHEN LAG(per_capita_energy_consumption) OVER (ORDER BY year) IS NULL THEN NULL
        ELSE ROUND(
            (per_capita_energy_consumption - LAG(per_capita_energy_consumption) OVER (ORDER BY year)) /
            (NULLIF(LAG(per_capita_energy_consumption) OVER (ORDER BY year), 0)) * 100,
            2
        )
    END AS yoy_energy_change_pct,
    -- Cumulative total decline from first year
    ROUND(
        per_capita_energy_consumption - 
        FIRST_VALUE(per_capita_energy_consumption) OVER (ORDER BY year),
        2
    ) AS cumulative_change_from_baseline,
    -- Running average consumption up to current year
    ROUND(
        AVG(per_capita_energy_consumption) OVER (ORDER BY year ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),
        2
    ) AS running_avg_consumption
FROM SUMMARY_TABLE 
WHERE country = 'italy' AND year >= 1999 
ORDER BY year;
