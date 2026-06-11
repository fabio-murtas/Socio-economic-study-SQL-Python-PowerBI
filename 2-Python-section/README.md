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
| `year != 2001` | Confirmed data-entry anomaly (Italy daily true wage is showing an absurd value of 0.06, clearly an issue) |
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

Simply click on the [jupyter notebook](../2-Python-section/data-analysis-oneblock.ipynb) file in this section

---

### Statistcs discussion

### Italy — r = 0.897, ρ = 0.875, R² = 0.805

This is an exceptionally strong result by any standard in social science, where r values above 0.7 are already considered strong. Italy's Pearson and Spearman coefficients are close to each other — 0.897 vs 0.875 — which is statistically meaningful. When Pearson and Spearman agree this closely, it tells you the relationship is not only strong but **well-behaved**: it is approximately linear, it is not being inflated by a handful of extreme values, and it holds across the full rank order of the data, not just in the middle of the distribution.

The **R² of 0.805** deserves particular attention. It means that approximately **80% of the variation in Italian real wages over this period can be statistically accounted for by variation in per-capita energy consumption**. In a complex social system with hundreds of potential drivers — monetary policy, trade cycles, demographic shifts, government spending — one variable explaining 80% of another is a remarkable degree of association. It does not prove causation, but it proves that these two things moved together so consistently that separating them statistically is almost impossible.

The OLS intercept of **-108.24** is also worth noting. It means that at zero energy consumption, the model predicts wages to be negative — which is economically nonsensical, but statistically it tells you the relationship only holds above a certain energy threshold. Italy's economy needed to reach a minimum level of industrial energy use before wages began responding. Below that level, the linear model breaks down. This is consistent with what economists call a **development threshold effect**.

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

### The first thing that jumps out is the split

Two countries return highly significant correlations with p-values that round to zero — **Italy** and **Finland**. Two countries return non-significant results with p-values well above any conventional threshold — the **US** and **UK**. This is not a gradual spectrum. It is a clean binary, and that binary is itself the finding. Something structurally different is happening between these two pairs, and the statistics are telling you to look for it.

---

### Finland — r = 0.806, ρ = 0.893, R² = 0.649

Finland presents the most intellectually interesting result in the dataset, and the reason is the inversion: **Spearman exceeds Pearson**. In Italy they were nearly equal. Here, ρ = 0.893 is meaningfully higher than r = 0.806. This gap is a diagnostic signal.

When Spearman substantially exceeds Pearson, it indicates that the relationship is **monotonic but non-linear** — the two variables consistently move in the same direction, but not at a constant rate. In Finland's case this makes structural sense. The Finnish economy has periods of rapid energy expansion where wages responded slowly, and periods where wages caught up in steps. The rank ordering is preserved — more energy always eventually means more wages — but the proportionality is not constant throughout.

The R² of 0.649 is lower than Italy's 0.805, but this is not simply a weaker relationship. It is partly a consequence of the non-linearity: Pearson's R² measures how well a straight line fits the data, and if the true relationship is curved, R² will underestimate the actual degree of association. The Spearman coefficient, which does not assume linearity, is actually *higher* for Finland than for Italy. Taken together, the two statistics suggest Finland's energy-wage relationship is **stronger in direction but more complex in form** than Italy's.

The OLS **slope of 2.41** versus Italy's **6.01** is striking. Finland requires more than twice as much energy input per unit of wage gain compared to Italy. This reflects the nature of Finland's dominant industries — paper, pulp, heavy manufacturing, and cold-climate infrastructure — which are energy-intensive by necessity. The economy consumes energy heavily as a structural baseline before that energy translates into worker compensation. Italy's manufacturing base was comparatively more labour-intensive relative to its energy use, hence the steeper wage response per energy unit.

---

### United States — r = 0.299, ρ = 0.114, p = 0.091 / 0.526

These are near-zero results, and the gap between Pearson and Spearman is as diagnostically important as the gap was for Finland — but in the opposite direction.

Pearson r = 0.299 is weak but at least approaches marginal significance at p = 0.091. Spearman ρ = 0.114 is essentially zero and wildly non-significant at p = 0.526. When Pearson exceeds Spearman by this margin, it typically means that what little linear signal exists is being **driven by a small number of influential data points** — likely the earlier years in the dataset when the US wage-energy relationship still retained some of its postwar character — while the rank-order relationship across the full dataset is essentially random noise.

The **R² of 0.089** means energy consumption explains less than **9% of wage variation**. The remaining 91% is determined by other factors entirely. The OLS slope of 1.644, while positive, is statistically meaningless given the non-significant p-value — the model has no predictive power. The positive intercept of 38.09 is the only case in the dataset where the intercept is positive and substantial, which means the model is essentially saying wages exist **independently** of energy consumption at a baseline level. In economic terms: US wages are set by other mechanisms entirely.

The question this raises — and which the statistics cannot answer — is *why*. What changed in the US that severed a relationship that was presumably present during the postwar industrial era? The statistics identify the break. They do not explain it. That explanation will need to come from somewhere else.

---

### United Kingdom — r = 0.231, ρ = 0.232, p = 0.189 / 0.186

The UK results are in some ways the cleanest null finding in the dataset. Unlike the US where Pearson and Spearman diverged, here they are nearly identical: 0.231 vs 0.232. This means the absence of relationship is **consistent across both linear and rank-order tests**. There are no hidden outliers inflating one measure. There is simply no signal, detected the same way by both methods.

The **R² of 0.053** — just 5.3% — is the lowest in the dataset. Energy consumption is essentially orthogonal to wages in the UK over this period. They share almost no statistical variance.

The OLS slope of **6.74** is paradoxically the highest in the entire dataset — higher than Italy's 6.01 — yet it is the most meaningless number in the results. A high slope in a non-significant regression with R² = 0.053 is a mathematical artefact: the line is steep because it is being fitted to data with no real linear structure, so small changes in the noise produce large swings in the slope estimate. The negative intercept of -202.83 compounds this — the most extreme in the dataset — reflecting a poorly constrained model, not a real economic threshold.

What makes the UK null result particularly notable is that it holds even though the UK and Italy are similar in population, geographic scale, and European context. They were both postwar industrial economies that rebuilt through the 1950s and 60s. The fact that Italy returns **r = 0.897** and the UK returns **r = 0.231** for the same variable pair, over an overlapping time period, is one of the sharpest comparative findings in the entire analysis. Something happened in one country that did not happen in the other, restructuring the statistical relationship between energy consumption and worker compensation completely.

The UK's energy profile is inseparable from the political turmoil of the 1970s–1980s. While this analysis focuses on the data rather than policy history, the timing of energy consumption shifts maps directly onto pivotal political events. Energy consumption reached its absolute peak around 1973, coinciding with the oil crisis and the three-day working week. A sharp decline followed, partially recovering before collapsing again circa 1984, marking the miners' strike and subsequent pit closures. From that point onward, energy consumption entered a sustained secular decline—a pattern that reflects the structural deindustrialization of the British economy.

Wage data presents a temporal gap between the 1960s–70s observations and the 1990s–2000s figures. This gap reflects both data availability constraints in the source dataset and a genuine structural rupture in UK labour markets: the transition from the pre-Thatcher industrial economy to the post-Thatcher service-oriented one. Treating these as continuous time series obscures the fact that they represent analytically distinct systems.

---

### Key Takeaway

Taken together, these four results suggest that the energy-wage relationship is not a universal feature of industrial economies. It appears to be a **contingent historical outcome** — present when certain institutional conditions hold, absent when those conditions are altered. Italy and Finland retained those conditions through the period studied. The US and UK did not.

Results shows that US r = 0.299 (non-significant) and the UK shows r = 0.231 (non-significant) is statistically robust. However, the interpretation deserves a deeper observation.
Energy Efficiency: Post-industrial economies use energy more efficiently per unit of output. The UK's energy consumption fell 12-15% in the 1980s-90s despite GDP growth (deindustrialization + efficiency).
Offshoring: Manufacturing-heavy economies like Italy and Finland still captured industrial energy in their borders. The US and UK outsourced production to China. Their energy is "hidden" in imports.
Sector Mix: Italy's strong manufacturing = more direct energy. UK/US financial services = less direct energy per unit output. This confounds the wage relationship.

> **Next:** [Part 3 — Power BI Dashboard](../3-PowerBI-section/README.md)
