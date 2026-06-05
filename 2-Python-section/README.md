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
*Correlation does not establish causation; both variables may be influenced by broader economic development, technological progress, and structural changes in the economy. (As we will see in the next section)*

---

### More country investigated

| Country | Pearson r | R² | Pearson p | Spearman ρ | Spearman p | OLS Slope | OLS Intercept | OLS p |
|---|---|---|---|---|---|---|---|---|
| Italy | 0.8971 | 0.8048 | < 0.001 ✅ | 0.8749 | < 0.001 ✅ | 6.0106 | -108.2360 | < 0.001 ✅ |
| United States | 0.2988 | 0.0893 | 0.0912 ❌ | 0.1143 | 0.5265 ❌ | 1.6444 | 38.0934 | 0.0912 ❌ |
| Finland | 0.8055 | 0.6488 | < 0.001 ✅ | 0.8927 | < 0.001 ✅ | 2.4139 | -66.3218 | < 0.001 ✅ |
| United Kingdom | 0.2310 | 0.0533 | 0.1888 ❌ | 0.2324 | 0.1859 ❌ | 6.7365 | -202.8288 | 0.1888 ❌ |

> ✅ Significant at α = 0.05 — ❌ Not significant at α = 0.05

---

### Analysis & Discussion

The results reveal a striking divide between the four countries, splitting cleanly into two groups: those where wages and energy consumption are strongly and significantly coupled (**Italy** and **Finland**), and those where the relationship has effectively broken down (**United States** and **United Kingdom**).

---

**Italy** presents the strongest and most consistent signal in the dataset. A Pearson correlation of *r = 0.897* indicates a near-linear positive relationship between per-capita energy consumption and daily real wages, with *R² = 0.805* meaning that approximately **80% of the variation in wages is associated with variation in energy consumption**. Both Pearson and Spearman coefficients are in close agreement *(ρ = 0.875)*, which confirms the relationship is stable and not driven by outliers or non-linearity. The OLS slope of *6.01* tells us that each unit increase in per-capita energy consumption was associated with a 6-unit increase in daily real wages over this period. This is consistent with Italy's postwar economic trajectory — a manufacturing and export-driven economy where industrial energy use and worker prosperity moved in lockstep through the *miracolo economico* and its aftermath.

---

**Finland** also shows a strong and statistically significant coupling, though with some notable differences from Italy. The Pearson coefficient *(r = 0.806, R² = 0.649)* is slightly lower, but the Spearman rank correlation is actually the highest in the dataset *(ρ = 0.893)* — higher even than Italy's. This divergence between Pearson and Spearman is informative: it suggests the relationship in Finland is **strongly monotonic but not perfectly linear**, meaning wages and energy consumption moved consistently in the same direction without following a strict proportional ratio throughout. The OLS slope of *2.41* is notably lower than Italy's, indicating a shallower wage response per unit of energy — consistent with Finland's energy-intensive industrial base (paper, pulp, heavy manufacturing) which requires large energy inputs relative to the wage gains they generate.

---

**The United States** is the most analytically interesting case precisely because of how weak the results are. A Pearson *r = 0.299* and Spearman *ρ = 0.114* — the latter barely above zero — with p-values of *0.091* and *0.526* respectively mean there is **no statistically meaningful relationship** between energy consumption and wages in this dataset. The *R² of 0.089* indicates that energy consumption explains less than 9% of wage variation. This is not a data quality issue — it is a historically grounded finding. The US economy underwent a fundamental structural shift from the 1970s onward: energy consumption remained high (the economy stayed large and industrially active), but wages stagnated in real terms due to declining union density, the offshoring of manufacturing, and the growing share of returns flowing to capital rather than labour. Energy and wages decoupled because the mechanisms that once linked them — collective bargaining, shared industrial productivity gains — were progressively dismantled.

---

**The United Kingdom** mirrors the United States in statistical terms, with equally weak and non-significant results *(r = 0.231, R² = 0.053, p = 0.189)*. Despite having the highest OLS slope in the dataset *(6.74)*, this value carries no statistical weight given the non-significant p-value — the slope is an artefact of a poorly fitting model, not a meaningful signal. The UK's deindustrialisation from the 1980s onward — earlier and more abrupt than most Western European peers — severed the link between industrial energy use and worker wages. By the time the UK economy recovered in the 1990s, growth was concentrated in financial services and London's knowledge economy, sectors where the energy-wage relationship that characterised the industrial era simply does not apply.

---

### Key Takeaway

The contrast between these four countries is not random. It maps precisely onto their economic histories. **Countries that retained a manufacturing and industrial core through the late 20th century (Italy, Finland) show strong energy-wage coupling. Countries that deindustrialised and financialised earlier (US, UK) show no meaningful relationship at all.** The statistics are not just numbers — they are the quantitative signature of four distinct paths through the postwar economic era.

> **Next:** [Part 3 — Power BI Dashboard](../3-PowerBI-section/README.md)
