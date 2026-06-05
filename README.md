# Socio-Economic Study — A Data Pipeline Project

*From raw data to interactive dashboard, across four decades and six countries.*

---

## What is this project?

This is a end-to-end data analysis project built around a single question:

> **How have energy consumption, real wages, and economic growth evolved together — and what happens when they stop moving in the same direction?**

To answer it, data was collected from four independent public sources, merged into a unified database, statistically analysed, and finally presented as an interactive dashboard. The full pipeline spans three tools, three methodologies, and several decades of socio-economic history.

---

## The Dataset

Four indicators. Multiple countries. Roughly six decades of data.

| Indicator | Source |
|-----------|--------|
| GDP per capita | [World Bank](https://www.worldbank.org/) |
| Per-capita energy consumption | [Our World in Data](https://ourworldindata.org/) |
| Population | [Our World in Data](https://ourworldindata.org/) |
| Daily real wages | [Clio Infra](https://clio-infra.eu/) |

---

## The Pipeline

The project is structured in three sequential sections. Each one builds directly on the work of the previous.

```
  RAW DATA                 ANALYSIS                PRESENTATION
  ────────                 ────────                ────────────
  CSV / XLSX          →    Python +           →    Power BI
  4 sources                scipy / matplotlib      Interactive Dashboard
       ↓
  SQL / SQLite
  Data engineering
  Window functions
```

| Section | Focus | Tools |
|---------|-------|-------|
| [Part 1 — SQL](1-SQL-section/README.md) | Data ingestion, cleaning, and aggregation | Python, SQLite, pandas |
| [Part 2 — Python](2-Python-section/README.md) | Statistical analysis and visualisation | pandas, NumPy, SciPy, Matplotlib |
| [Part 3 — Power BI](3-PowerBI-section/README.md) | Interactive dashboard and findings | Power BI Desktop, DAX |

---

## A Note on Narrative

Each section is self-contained and documented in detail, but they are designed to be read in order. A finding introduced in SQL is explored statistically in Python and given context in Power BI. The same countries, the same metrics, the same questions — looked at through three increasingly powerful lenses.

---

## Who built this?

I'm Fabio, a biologist transitioning into data analysis. This project was built to demonstrate practical skills across the full data pipeline — from raw file handling and database design to statistical reasoning and business intelligence — using real-world public data and open-source tools.

→ [Start with Part 1 — SQL](1-SQL-section/README.md)

---

> 🚧 **Work in Progress** — The Python and Power BI sections are actively being developed.
