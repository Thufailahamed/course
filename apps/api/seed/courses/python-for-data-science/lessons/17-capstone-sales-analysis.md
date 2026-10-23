This is the capstone. You will analyze a sales dataset from start to finish, the way you would for a real business question: load it, check it, clean it, answer questions with grouped summaries and time series, show the results in charts, and write down what you can and cannot conclude.

The question is this: **how is revenue changing, which products and cities matter most, and where are returns a problem?**

The dataset is generated in the page, and like real exports it is messy: inconsistent city spellings, missing prices and duplicate rows. Nothing has been prepared for you.

## Load and inspect

```python run
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

def make_sales(seed=11, n=360):
    rng = np.random.default_rng(seed)
    dates = pd.Timestamp("2026-01-01") + pd.to_timedelta(rng.integers(0, 181, n), unit="D")
    city = rng.choice(["Lyon", "Paris", "Nice", "Lille"], n, p=[0.3, 0.35, 0.2, 0.15])
    product = rng.choice(["Tea", "Coffee", "Cocoa"], n, p=[0.4, 0.4, 0.2])
    base = pd.Series(product).map({"Tea": 6.5, "Coffee": 9.0, "Cocoa": 7.5}).to_numpy()
    unit_price = (base * rng.uniform(0.95, 1.10, n)).round(2)
    units = rng.poisson(3, n) + 1
    returned = rng.random(n) < np.where(city == "Nice", 0.15, 0.05)
    df = pd.DataFrame({
        "order_id": np.arange(1, n + 1), "date": dates, "city": city, "product": product,
        "units": units, "unit_price": unit_price, "returned": returned,
    })
    messy = rng.random(n) < 0.05
    df.loc[messy, "city"] = " " + df.loc[messy, "city"].str.upper() + " "
    df.loc[rng.random(n) < 0.04, "unit_price"] = np.nan
    return pd.concat([df, df.iloc[:3]], ignore_index=True)   # three exact duplicate rows

raw = make_sales()
print("rows:", len(raw), "| missing prices:", int(raw["unit_price"].isna().sum()))
print("distinct city spellings:", raw["city"].nunique())
raw.head()
```

Three things need attention before any calculation: the city names have stray spaces and capitals, some prices are missing, and some rows are duplicated.

## Clean

```python run
def clean(df):
    out = df.copy()
    out["city"] = out["city"].str.strip().str.title()
    out = out.drop_duplicates()
    out = out.dropna(subset=["unit_price"])
    return out.reset_index(drop=True)

sales = clean(raw)
print("rows before:", len(raw), "| after:", len(sales))
print("cities:", sorted(sales["city"].unique()))
```

Dropping the missing prices removes about four per cent of orders. That is a decision, and it biases revenue downward if the missing prices are not random. A careful analyst reports it, and may check whether the dropped orders differ from the rest.

## Revenue over time

```python run
sales["revenue"] = sales["units"] * sales["unit_price"]
monthly = sales.set_index("date")["revenue"].resample("ME").sum()
growth = (monthly.pct_change() * 100).round(1)
print(pd.DataFrame({"revenue": monthly.round(0), "growth %": growth}))
```

The first month has no growth figure, because there is no earlier month to compare with. Read the growth column as a trend, not as a precise forecast.

## Products and cities

```python run
by_product = sales.groupby("product").agg(
    orders=("order_id", "size"),
    revenue=("revenue", "sum"),
    avg_units=("units", "mean"),
).sort_values("revenue", ascending=False)
print(by_product.round(1))

by_city = sales.groupby("city").agg(
    orders=("order_id", "size"),
    revenue=("revenue", "sum"),
    return_rate=("returned", "mean"),
).sort_values("return_rate", ascending=False)
print(by_city.round(3))
```

`returned` is a yes-or-no column, so its mean is the share of orders returned.

## Show the results

```python run
fig, axes = plt.subplots(1, 2, figsize=(9, 3.5))
axes[0].plot(monthly.index, monthly.values, marker="o")
axes[0].set_title("Monthly revenue")
axes[0].set_ylabel("euros")
axes[0].tick_params(axis="x", rotation=30)

axes[1].bar(by_city.index, by_city["return_rate"] * 100, color="#e45756")
axes[1].set_title("Return rate by city")
axes[1].set_ylabel("% of orders")
axes[1].set_ylim(0, max(10, by_city["return_rate"].max() * 110))
plt.tight_layout()
plt.show()
```

## Write the findings

A finding is a claim plus the evidence behind it. Compute the numbers in code, then state them.

```python run
top_product = by_product.index[0]
top_share = by_product["revenue"].iloc[0] / by_product["revenue"].sum()
worst_city = by_city.index[0]
print(f"1. {top_product} brings in {top_share:.0%} of revenue.")
print(f"2. {worst_city} has the highest return rate: {by_city.loc[worst_city, 'return_rate']:.1%}.")
print(f"3. Based on {len(sales)} orders over {sales['date'].dt.to_period('M').nunique()} months.")
print("Limits: missing prices were dropped, and six months is a short history.")
```

Notice what the findings do not claim. A return rate difference between cities is an observation, not proof of the cause, and six months of data cannot show seasonality.

## Challenge: clean the sales table

```python exercise id=clean-sales title="Clean a raw sales table"
import pandas as pd

# TODO: `clean_sales(df)` returns a cleaned copy of a sales table. Strip spaces from the city and use title case,
# remove exact duplicate rows, drop rows whose unit_price is missing, and keep the original order with a
# fresh 0-based index.
def clean_sales(df):
    ...
--- solution
import pandas as pd

def clean_sales(df):
    out = df.copy()
    out["city"] = out["city"].str.strip().str.title()
    out = out.drop_duplicates()
    out = out.dropna(subset=["unit_price"])
    return out.reset_index(drop=True)
--- test
import pandas as pd
raw = pd.DataFrame({
    "city": [" lyon ", "PARIS", " lyon ", "nice"],
    "unit_price": [5.0, None, 5.0, 8.0],
    "units": [2, 1, 2, 3],
})
result = clean_sales(raw)
assert result is not None, "Replace the `...` in `clean_sales` with code that returns the cleaned table."
assert list(result["city"]) == ["Lyon", "Nice"], f"After cleaning the rows should be Lyon and Nice, but you returned {list(result['city'])}. Strip spaces, use title case, remove the duplicate Lyon row and the row with no price."
assert list(result.index) == [0, 1], "Use a fresh 0-based index."
assert "unit_price" in result.columns and result["unit_price"].notna().all(), "No missing prices should remain."
--- hint
Do the steps in order: clean the city text, drop the duplicate rows, drop rows with no price, then reset the index.
--- hint
`out = df.copy(); out["city"] = out["city"].str.strip().str.title(); out = out.drop_duplicates().dropna(subset=["unit_price"]); return out.reset_index(drop=True)`.
```

## Challenge: monthly revenue

```python exercise id=monthly-revenue title="Revenue per month"
import pandas as pd

# TODO: `monthly_revenue(df)` takes a table with a datetime column "date", "units" and "unit_price". Compute the
# revenue of each order (units × unit_price), and return a Series of total revenue per calendar month, indexed by
# month end ("ME"). Months with no orders are included with 0.
def monthly_revenue(df):
    ...
--- solution
import pandas as pd

def monthly_revenue(df):
    revenue = df["units"] * df["unit_price"]
    return revenue.groupby(df["date"]).sum().resample("ME").sum()
--- test
import pandas as pd
df = pd.DataFrame({
    "date": pd.to_datetime(["2026-02-03", "2026-01-05", "2026-01-20"]),
    "units": [2, 2, 1],
    "unit_price": [10.0, 10.0, 5.0],
})
result = monthly_revenue(df)
assert result is not None, "Replace the `...` in `monthly_revenue` with code that returns the monthly Series."
assert list(result.values) == [25.0, 20.0], f"January is 20 + 5 = 25 and February is 20, but you returned {list(result.values)}. Order the months in time."
assert len(result) == 2, "There should be one row per month."
assert result.index[0].month == 1 and result.index[1].month == 2, "The first entry should be January and the second February."
--- hint
Compute the revenue column first. Then sum it per date, and resample by calendar month with `resample("ME")`.
--- hint
`revenue = df["units"] * df["unit_price"]`, then group it by the dates with `revenue.groupby(df["date"]).sum()`. A Series indexed by datetime can then be resampled with `.resample("ME").sum()`.
```

## Challenge: return rate by city

```python exercise id=return-rate title="Return rate per city"
import pandas as pd

# TODO: `return_rate_by_city(df)` takes a table with columns "city" and "returned" (True or False). Return a
# Series of the share of orders returned in each city, indexed by city, highest rate first.
def return_rate_by_city(df):
    ...
--- solution
import pandas as pd

def return_rate_by_city(df):
    rates = df.groupby("city")["returned"].mean()
    return rates.sort_values(ascending=False)
--- test
import pandas as pd
df = pd.DataFrame({
    "city": ["Lyon", "Lyon", "Paris", "Paris", "Paris", "Nice"],
    "returned": [True, False, False, False, False, True],
})
result = return_rate_by_city(df)
assert result is not None, "Replace the `...` in `return_rate_by_city` with code that returns the rates."
assert list(result.index) == ["Nice", "Lyon", "Paris"], f"Nice is 100%, Lyon 50% and Paris 0%, so the order should be Nice, Lyon, Paris. You returned {list(result.index)}."
assert abs(result["Lyon"] - 0.5) < 1e-9, "Lyon has one return in two orders, so its rate is 0.5."
assert abs(result["Paris"]) < 1e-9, "Paris has no returns."
--- hint
The mean of a True/False column is the share of True values, so `mean()` gives the rate directly.
--- hint
`rates = df.groupby("city")["returned"].mean(); return rates.sort_values(ascending=False)`.
```

## Debug the ranking

This code is meant to report the two highest-revenue products, but it returns the two lowest.

```python debug id=top-products title="Rank the highest revenue first"
import pandas as pd

revenue = pd.Series({"Tea": 1200.0, "Coffee": 2600.0, "Cocoa": 900.0}).sort_index()
top = revenue.sort_values().head(2)            # bug: ascending order puts the smallest first
print(top)
--- solution
import pandas as pd

revenue = pd.Series({"Tea": 1200.0, "Coffee": 2600.0, "Cocoa": 900.0}).sort_index()
top = revenue.sort_values(ascending=False).head(2)
print(top)
--- test
assert list(top.index) == ["Coffee", "Tea"], f"The two highest revenues are Coffee (2600) and Tea (1200), but top shows {list(top.index)}. Sort in descending order."
--- hint
`sort_values()` sorts in ascending order by default.
--- hint
Pass `ascending=False` before taking the first two rows.
```

## Predict the growth

```python predict id=predict-growth title="What is the growth from 100 to 150?"
import pandas as pd
s = pd.Series([100.0, 150.0])
print(round(s.pct_change().iloc[1] * 100, 1))
--- options
* 50.0
150.0
33.3
100.0
--- explain
`pct_change` computes (150 - 100) / 100 = 0.5, which is 50 per cent when multiplied by 100. The first value has no previous value, so it is missing, and the second value is the one that shows the change.
```

## Recap

- Start with a question and check the data before any calculation.
- Clean deliberately, and report every decision that removes or changes data.
- Answer with grouped summaries and time series, then show the answer in a chart with clear labels.
- Write findings as claims with evidence, and state their limits.

**Up next:** the final assessment, which checks the whole course.
