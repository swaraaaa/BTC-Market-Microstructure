# BTC Market Microstructure — Volatility, Liquidity & Market Resilience

**Market Microstructure · Realized Volatility · Liquidity Analysis · High-Frequency Data · R**

> FE-570 Final Project — MS Financial Engineering, Stevens Institute of Technology 

> Author: Swara Dave 

---

## 📌 Overview

This project analyzes intraday volatility, liquidity, and market resilience in cryptocurrency markets using tick-level BTC/USD trading data from BitMex. The study investigates how market participants respond to volatility through liquidity measures and how large trades impact prices during volatile periods.

**Key questions addressed:**
1. How can realized volatility be estimated from high-frequency tick data?
2. How do liquidity spreads behave during high vs. normal volatility periods?
3. What is the price impact of large trades (>40,000 units) on market resilience?

---

## 📊 Key Results

### Volatility Estimates
| Method | Annualized Volatility |
|---|---|
| 5-Minute Realized Volatility | 30.76% |
| Roll Model Volatility | 28.97% |

### Liquidity Spread Analysis
| Spread Measure | Mean (USD) | Std Dev | Annualized |
|---|---|---|---|
| Quoted Spread | 0.569 | 0.816 | 9.029 |
| Effective Spread | 0.406 | 0.572 | 6.438 |
| Roll Spread | 0.0000227 | 0.0000848 | 0.00036 |

**Key finding:** Quoted spread significantly exceeds effective spread, indicating traders often execute at prices better than displayed quotes — evidence of hidden liquidity and strong price discovery in BTC markets.

---

## 🗂️ Data

- **Source:** BitMex trading API (Python)
- **Asset:** BTC/USD (XBTUSD)
- **Period:** April 17, 2017 — full 24-hour trading day
- **Granularity:** Tick-level (millisecond timestamps)
- **Size:** 14,618 observations
- **Fields:** timestamp, trade price, bid price, ask price, volume, trade side

---

## ⚙️ Methodology

### 1. Volatility Estimation
**Realized Volatility (Signature Plot)**
- Computed realized variance RV(q) = (1/q) Σ(P_{t+q} - P_t)² for lags q = 1 to 500
- 5-minute realized volatility: 26.13% → annualized to **30.76%**
- Signature plot shows volatility decreasing as lag increases — confirming microstructure noise at small lags

**Roll Model Volatility**
- Estimates true bid-ask spread from serial covariance of price changes
- σ²u = γ0 + 2γ1 → annualized to **28.97%**
- Close agreement between both methods confirms robustness

### 2. Liquidity Analysis
Three spread metrics computed:
- **Quoted Spread** = Ask - Bid (posted liquidity cost)
- **Effective Spread** = 2 × D_t × (Price - Midpoint) (actual execution cost)
- **Roll Spread** = 2 × √(-Cov) (true cost after removing microstructure noise)

Spreads analyzed separately during **high volatility** vs **normal** periods using rolling 20-trade window.

### 3. Large Trade Impact Analysis
- Large trades defined as volume > 40,000 units
- **Immediate Price Impact:** mostly contained between -0.1% and 0.2% — good market resilience
- **Cumulative Price Impact (10-tick window):** wider dispersion (-0.4% to 0.2%) with slight downward trend
- Increasing dispersion in latter half of sample suggests decreasing resilience over the trading day

---

## 📁 Repository Structure

```
BTC-Market-Microstructure/
├── analysis.R       # Volatility estimation, liquidity analysis, large trade impact
└── README.md
```

---

## 🚀 How to Run

1. Clone the repo
2. Install required R packages:
```r
install.packages(c("xts", "highfrequency", "data.table", "dplyr", "ggplot2", "zoo", "tidyr"))
```
3. Obtain BTC/USD tick data from BitMex's historical data API:
   - Documentation: https://www.bitmex.com/app/apiOverview
   - Or use the `bitmex` Python package to pull tick-level data for April 17, 2017
   - Save the file as `Final_Dataset.csv` in the working directory
4. Run `analysis.R`

---

## 👤 Author

**Swara Dave** — MS Financial Engineering, Stevens Institute of Technology
[![LinkedIn](https://img.shields.io/badge/LinkedIn-swara--dave-blue?style=flat&logo=linkedin)](https://linkedin.com/in/swara-dave) [![GitHub](https://img.shields.io/badge/GitHub-swaraaaa-black?style=flat&logo=github)](https://github.com/swaraaaa)
