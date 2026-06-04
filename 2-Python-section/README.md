# Part 2 — Python Analysis

> This is **Part 2** of a three-part data project.
> | [Part 1 — SQL](../1-SQL-section/README.md) | **Part 2 — Python** | [Part 3 — Power BI](../3-PowerBI-section/README.md) |

---

## Overview

In Part 1 we built and cleaned a SQLite database containing several socio-economic indicators covering countries worldwide across multiple decades.

This section picks up directly from that database. Using **Python**, we load the `SUMMARY_TABLE` within the *02-social-study-joins.db* file produced in Part 1 and focus on Italy as a case study, investigating the relationship between real wages and energy consumption over four decades (1965–2008). The analysis moves through a structured pipeline: data loading, cleaning, descriptive statistics, visualisation, correlation analysis, and linear regression.

---

## Analysis Pipeline

```
SQLite Database (Part 1)
        │
        ▼
1. Connect to database        sqlite3
2. Query & clean data         pandas
3. Descriptive statistics     pandas / numpy
4. Time-series visualisation  matplotlib
5. Correlation analysis       scipy.stats  (Pearson + Spearman)
6. Linear regression          scipy.stats  (OLS)
```

---

## Dependencies

```bash
# Arch Linux
pacman -S python-numpy python-pandas python-matplotlib python-scipy

# or via pip
pip install numpy pandas matplotlib scipy --break-system-packages
```

> `sqlite3` is built into Python — no extra package needed.

---

## Data Loading & Cleaning

Data is queried directly from the SQLite database generated in Part 1 — no raw CSV files are re-read at this stage. This ensures the Python section is a true continuation of the pipeline rather than a standalone exercise.

**Query filters applied:**

| Filter | Reason |
|--------|---------|
| `country = 'italy'` | Case study focus |
| `year >= 1965` | Pre-1965 data is sparse and incomplete |
| `year != 2001` | Confirmed data-entry anomaly in source |
| `daily_true_wage IS NOT NULL` | Drops incomplete records |

**Normalisation applied:**

Raw database values use inconsistent scales that would distort a shared chart. Two columns are rescaled before analysis:

| Column | Operation | New Unit |
|--------|-----------|----------|
| `population` | ÷ 1,000,000 | Millions |
| `per_capita_energy_consumption` | ÷ 1,000 | Thousands |

`daily_true_wage` is left in its original inflation-adjusted units.

---

## Visualisation

The three metrics are plotted on a shared time axis using a **dual Y-axis** chart:

- **Population** — logarithmic scale to prevent exponential growth from compressing the other two series
- **Real daily wage** — linear scale
- **Per-capita energy consumption** — linear scale

> 📊 *Chart output is rendered inline in the Jupyter Notebook — see `italy-analysis.ipynb`*

---

## Statistical Analysis

### Pearson Correlation
Tests the **linear** relationship between real wages and energy consumption. Assumes approximate normality in both variables.

```
r       — strength of linear association  (-1 to +1)
R²      — proportion of shared variance explained
p-value — significance at α = 0.05
```

### Spearman Rank Correlation
Complements Pearson by capturing **monotonic** (not strictly linear) relationships. More robust to outliers and non-normal distributions.

```
ρ       — rank-order association  (-1 to +1)
p-value — significance at α = 0.05
```

### OLS Linear Regression
Models `daily_true_wage` as a linear function of `per_capita_energy_consumption`.

```
Slope     — wage change per 1-unit increase in energy consumption
Intercept — baseline wage when energy consumption is zero
R²        — proportion of wage variance explained by energy
p-value   — significance of the regression at α = 0.05
```

---

## Files

```
2-Python-section/
├── 02-social-study-joins.db            # sqlite3 database
├── data-analysis-oneblock.ipynb          # Jupyter Notebook (recommended entry point)
├── data-analysis-ipynb-friendly.py   # Source script (notebook-compatible structure)
└── README.md                     # This file
```

> The `.py` file is structured with clearly marked cell boundaries (`# ── Cell N`) so it can be converted directly to a Jupyter Notebook or run as a standalone script.

---

## How to Run

```bash
# 1. Make sure the database from Part 1 is accessible
#    Default expected path: 02-social-study-joins.db (project root)

# 2. Launch JupyterLab from the project root
cd path/to/project
jupyter lab

# 3. Open italy-analysis.ipynb and run all cells
#    Kernel → Restart & Run All
```

---

## Results discussion

**Pearson correlation analysis** revealed a very strong positive relationship between per-capita energy consumption and daily real wages *(r = 0.897, p < 0.001)*. The coefficient of determination *(R² = 0.805)* indicates that approximately 80% of wage variation is associated with changes in energy consumption. **Spearman rank correlation** produced a similar result *(ρ = 0.875, p < 0.001)*, confirming that the relationship remains strong even when evaluated using ranked data. The similarity between Pearson and Spearman coefficients suggests a stable and approximately linear association between the two variables.

**Linear regression analysis** revealed a strong positive relationship between per-capita energy consumption and daily real wages in Italy between 1965 and 2008. The model produced a correlation coefficient of *R = 0.897* and an *R² of 0.805*, indicating that approximately 80% of wage variation is associated with changes in energy consumption. The relationship was highly statistically significant *(p < 0.001)*, suggesting that periods of higher energy consumption were strongly associated with higher real wages.

*Over the period 1965–2008 in Italy, increases in per-capita energy consumption were strongly associated with increases in real wages. This finding is consistent with economic theories linking greater energy availability to higher productivity, industrial output, and living standards.*
*Correlation does not establish causation; both variables may be influenced by broader economic development, technological progress, and structural changes in the economy.*

> **Next:** [Part 3 — Power BI Dashboard](../3-PowerBI-section/README.md)
