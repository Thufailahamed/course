Once your data is in a DataFrame, pandas can draw the common charts in one line each, and it chooses sensible defaults. Those one-liners are fast, but a plot is only as useful as the summary behind it. This lesson shows how to plot straight from a DataFrame, how to group before plotting, and how to pick the chart that answers the question you actually have.

```python run
import io
import pandas as pd
import matplotlib.pyplot as plt

CSV = """date,city,product,units,price
2026-01-03,Lyon,Tea,4,6.50
2026-01-03,Paris,Coffee,2,9.00
2026-01-04,Lyon,Coffee,1,9.00
2026-01-05,Nice,Tea,6,6.50
2026-01-06,Paris,Tea,5,6.50
2026-01-07,Nice,Coffee,3,9.50
2026-01-08,Lyon,Tea,2,6.50
2026-01-09,Paris,Coffee,4,9.50
2026-01-10,Nice,Tea,7,6.50
2026-01-11,Lyon,Coffee,3,9.00
"""
sales = pd.read_csv(io.StringIO(CSV), parse_dates=["date"])
sales["revenue"] = sales["units"] * sales["price"]
print("loaded", len(sales), "orders")
```

## Plot a summary, not raw rows

The usual pipeline is to summarize first, then plot the summary. The chart shows one bar per city, which a reader can compare at a glance.

```python run
city_revenue = sales.groupby("city")["revenue"].sum().sort_values(ascending=False)

fig, ax = plt.subplots(figsize=(5, 3))
city_revenue.plot(kind="bar", ax=ax, color="#4c78a8")
ax.set_ylabel("revenue (€)")
ax.set_title("Revenue by city")
ax.tick_params(axis="x", rotation=0)
plt.tight_layout()
plt.show()
```

## Trends over time

Resample to a regular period first, then draw a line. Plotting every raw order against time would be a cloud of points that hides the trend.

```python run
daily = sales.set_index("date")["revenue"].resample("D").sum()

fig, ax = plt.subplots(figsize=(6, 3))
daily.plot(ax=ax, marker="o")
ax.set_ylabel("revenue (€)")
ax.set_title("Daily revenue")
ax.grid(alpha=0.3)
plt.show()
```

## Compare product mixes with a stacked bar

```python run
mix = sales.pivot_table(index="city", columns="product", values="units", aggfunc="sum", fill_value=0)
fig, ax = plt.subplots(figsize=(5, 3))
mix.plot(kind="bar", stacked=True, ax=ax)
ax.set_ylabel("units")
ax.set_title("Units by city and product")
ax.tick_params(axis="x", rotation=0)
plt.tight_layout()
plt.show()
```

A stacked bar shows totals and parts together, but comparing the parts across bars is hard. If the question is about the parts, use grouped bars or small multiples instead.

## Boxplots for spread across groups

```python run
fig, ax = plt.subplots(figsize=(5, 3))
sales.boxplot(column="units", by="city", ax=ax)
ax.set_title("Units per order, by city")
ax.set_xlabel("")
ax.set_ylabel("units")
plt.suptitle("")
plt.tight_layout()
plt.show()
```

A boxplot shows the median, the middle half of the values, and the extremes. It is the right chart when you want to compare distributions, not only averages.

## Challenge: a summary table for plotting

```python exercise id=plot-summary title="Prepare the data for a chart"
import pandas as pd

# TODO: `plot_summary(df)` takes a table with columns city and revenue. Return a DataFrame with one row
# per city, sorted by revenue from highest to lowest, and two columns: "revenue" (the total) and
# "share" (that total as a fraction of the grand total, rounded to 3 decimals).
def plot_summary(df):
    ...
--- solution
import pandas as pd

def plot_summary(df):
    totals = df.groupby("city")["revenue"].sum().sort_values(ascending=False)
    share = (totals / totals.sum()).round(3)
    return pd.DataFrame({"revenue": totals, "share": share})
--- test
import pandas as pd
df = pd.DataFrame({"city": ["Lyon", "Paris", "Lyon", "Nice"], "revenue": [10.0, 25.0, 20.0, 40.0]})
result = plot_summary(df)
assert result is not None, "Replace the `...` in `plot_summary` with code that returns the summary table."
assert result.index.tolist() == ["Nice", "Lyon", "Paris"], f"Nice (40), Lyon (30) and Paris (25) should be listed from highest to lowest revenue, but the order is {result.index.tolist()}."
assert result.loc["Nice", "revenue"] == 40.0 and result.loc["Lyon", "revenue"] == 30.0, "The revenue column should hold each city's total."
assert abs(result.loc["Nice", "share"] - 0.421) < 1e-9, "The grand total is 95, so Nice's share is 40 / 95, rounded to 0.421."
assert list(result.columns) == ["revenue", "share"], "The table should have exactly the revenue and share columns."
--- hint
Group by city and sum the revenue, then sort from highest to lowest.
--- hint
Divide each total by the sum of all the totals to get the share, then round it.
--- hint
`totals = df.groupby("city")["revenue"].sum().sort_values(ascending=False)`, then build the table with `pd.DataFrame({"revenue": totals, "share": (totals / totals.sum()).round(3)})`.
```

## Challenge: the top entries for a chart

```python exercise id=top-for-chart title="Keep the largest entries for a chart"
import pandas as pd

# TODO: `top_for_chart(series, n)` returns the `n` largest values of a Series, sorted from largest to smallest.
# If the Series has fewer than `n` values, return all of them.
def top_for_chart(series, n):
    ...
--- solution
import pandas as pd

def top_for_chart(series, n):
    return series.sort_values(ascending=False).head(n)
--- test
import pandas as pd
s = pd.Series({"Tea": 3.0, "Coffee": 9.0, "Cocoa": 5.0, "Water": 1.0})
result = top_for_chart(s, 2)
assert result is not None, "Replace the `...` in `top_for_chart` with code that returns the Series."
assert list(result.index) == ["Coffee", "Cocoa"], f"The two largest are Coffee (9) and Cocoa (5), but you returned {list(result.index)}."
assert len(top_for_chart(s, 10)) == 4, "Asking for more than exist should return all of them."
--- hint
Sort in descending order, then take the first n with `head`.
--- hint
`series.sort_values(ascending=False).head(n)`.
```

## Debug the chart input

This code builds a bar chart of revenue per city, but the bars are the wrong height.

```python debug id=plot-units title="Plot revenue, not units"
import io
import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv(io.StringIO("city,units,price\nLyon,4,6.5\nParis,2,9.0\nLyon,1,6.5\n"))
df["revenue"] = df["units"] * df["price"]
totals = df.groupby("city")["units"].sum()     # bug: this sums units, not revenue
fig, ax = plt.subplots(figsize=(4, 3))
totals.plot(kind="bar", ax=ax)
plt.close(fig)
print(totals)
--- solution
import io
import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv(io.StringIO("city,units,price\nLyon,4,6.5\nParis,2,9.0\nLyon,1,6.5\n"))
df["revenue"] = df["units"] * df["price"]
totals = df.groupby("city")["revenue"].sum()
fig, ax = plt.subplots(figsize=(4, 3))
totals.plot(kind="bar", ax=ax)
plt.close(fig)
print(totals)
--- test
assert abs(totals["Lyon"] - 32.5) < 1e-9, f"Lyon's revenue is 4 × 6.5 + 1 × 6.5 = 32.5, but totals says {totals['Lyon']}. Sum the revenue column."
assert abs(totals["Paris"] - 18.0) < 1e-9, "Paris's revenue is 2 × 9 = 18."
--- hint
The chart title and axis say revenue, so the data must be revenue. Check which column the sum is taken from.
--- hint
Group the `revenue` column, not `units`.
```

## Predict the bar count

```python predict id=predict-bars title="How many bars does the chart have?"
import pandas as pd
df = pd.DataFrame({"city": ["Lyon", "Paris", "Lyon", "Nice", "Nice"], "revenue": [1, 2, 3, 4, 5]})
print(len(df.groupby("city")["revenue"].sum()))
--- options
* 3
5
2
4
--- explain
Grouping collapses rows into one result per distinct city. There are three cities, so the bar chart has three bars, not one per row.
```

## Recap

- Summarize first, then plot. A chart of one bar per group is easier to read than a cloud of raw rows.
- Use lines for trends over time after resampling, bars for comparison, stacked bars for totals with parts, and boxplots for spread.
- Check the column you plot: the title and the data must describe the same quantity.
- Keep one question per chart.

**Up next:** charts that tell the truth. Plots can mislead as easily as they clarify.
