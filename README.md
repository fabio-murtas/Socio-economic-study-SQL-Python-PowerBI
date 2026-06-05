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

### A very important note on "daily true wage" data

[This is the clio-infra dataset](https://dataverse.nl/dataset.xhtml?persistentId=doi:10.34894/UFVNXT#) you can further investigate the methodology used for sampling but I'm providing an extract of the paper below.
[Downloaded from](https://www.clio-infra.eu/data/LabourersRealWage_Broad.xlsx)
Text Citation: Zwart, Pim de, Bas van Leeuwen, and Jieli van Leeuwen-Li (2015). [Labourers Real Wage.](http://hdl.handle.net/10622/QK8VRF), accessed via the Clio Infra website.

The wage and price series shown in this chapter are taken from three sources: (A) a variety of studies on historical real wages that appeared in academic journals and books; (B) the British Colonial Blue Books (circa 1840-1912); and (C) the October Enquiries of the International Labour Organisation (1924-2008). These data were then converted into subsistence ratios, which indicate how many times the daily wage of a male unskilled construction labourer can buy the daily subsistence basket. This methodology has the advantage of providing an absolute yardstick to compare welfare across countries and time periods and, hence, is conceptually close (but not identical) to purchasing power parities. Finally, in order to fill gaps in the data, interpolations were made (D) on the basis of real wages indices from the (older) literature.

Basically the wages column gives us a measure of daily purchasing power per capita, which is a very interesting approach to investigate social and economic trends.

---

## Who built this?

I'm Fabio, a biologist transitioning into data analysis. This project was built to demonstrate practical skills across the full data pipeline — from raw file handling and database design to statistical reasoning and business intelligence — using real-world public data and open-source tools.

→ [Start with Part 1 — SQL](1-SQL-section/README.md)

---

> 🚧 **Work in Progress** — The Python and Power BI sections are actively being developed.
