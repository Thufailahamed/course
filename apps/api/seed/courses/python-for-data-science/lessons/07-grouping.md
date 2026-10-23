# Grouping and aggregation

Most analytical questions are not about one row. They are about **groups**: revenue by region, average order value by plan, signups by week, churn by cohort. pandas answers them with one idea — split the table into groups, apply a calculation to each, then combine the results.

That is `groupby`. Once it clicks, a whole category of spreadsheet pivot-table work becomes a single expression you can read, test and reuse.

## Split, apply, combine

```python run
import pandas as pd

sales = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E", "F", "G", "H"],
    "region": ["North", "South", "North", "East", "South", "North", "East", "South"],
    "rep": ["Ana", "Ben", "Ana", "Cara", "Ben", "Ana", "Cara", "Ben"],
    "month": ["Jan", "Jan", "Feb", "Jan", "Feb", "Feb", "Feb", "Jan"],
    "revenue": [120.0, 80.0, 200.0, 50.0, 160.0, 90.0, 70.0, 110.0],
})

by_region = sales.groupby("region")["revenue"].sum().sort_values(ascending=False)
by_region
```

Read `sales.groupby("region")["revenue"].sum()` from the inside out: split rows by region, take the revenue column, sum each group, combine into a Series indexed by region. The group key becomes the index.

## Several metrics at once

Named aggregation gives each output column an explicit name. This is the version to use in real analysis: the result is self-documenting and the columns are stable.

```python run
summary = (
    sales.groupby("region")
    .agg(
        total_revenue=("revenue", "sum"),
        avg_order=("revenue", "mean"),
        orders=("order_id", "count"),
    )
    .sort_values("total_revenue", ascending=False)
)

summary
```

`.agg` accepts a list of functions too, but named aggregation avoids MultiIndex columns and makes downstream code much easier. `count` counts non-null values; `size` counts rows, including nulls. Know which one your question needs.

> **Tip:** `groupby` sorts the keys by default. If order matters for a chart, sort explicitly by the metric you care about rather than relying on alphabetical order.

## Group by more than one key

```python run
by_month = sales.groupby(["region", "month"])["revenue"].sum()
print(by_month)

by_month_unstacked = by_month.unstack(fill_value=0)
by_month_unstacked
```

The result of a multi-key groupby has a **MultiIndex**. `unstack` moves the last level into columns, turning a long Series into a small table. That is the beginning of reshaping, which gets its own lesson.

## Keep the row count: `transform`

`agg` returns one row per group. `transform` returns one value per **original row**, which is what you need for a share-of-total column.

```python run
sales["region_total"] = sales.groupby("region")["revenue"].transform("sum")
sales["share"] = (sales["revenue"] / sales["region_total"]).round(3)

sales.sort_values(["region", "share"], ascending=[True, False])
```

`transform("sum")` broadcasts each region's total back to every row in that region. The division is then ordinary element-wise arithmetic. This pattern powers cohort shares, within-group rankings and normalisation.

> **Pitfall:** A groupby with a column that has missing values will silently drop those rows from `sum`/`mean` (not from `size`). Check `sales["region"].isna().sum()` before you trust a total.

## Your turn: the regional scorecard

Build `summary` with one row per region, sorted by `total_revenue` from highest to lowest, and these columns:

- `total_revenue`: sum of revenue
- `orders`: number of orders
- `avg_order`: mean revenue

```python exercise id=region-summary title="Build the regional scorecard"
import pandas as pd

sales = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E", "F", "G", "H"],
    "region": ["North", "South", "North", "East", "South", "North", "East", "South"],
    "revenue": [120.0, 80.0, 200.0, 50.0, 160.0, 90.0, 70.0, 110.0],
})

# TODO: group by region, aggregate, and sort by total revenue.
summary = ...
--- solution
import pandas as pd

sales = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E", "F", "G", "H"],
    "region": ["North", "South", "North", "East", "South", "North", "East", "South"],
    "revenue": [120.0, 80.0, 200.0, 50.0, 160.0, 90.0, 70.0, 110.0],
})

summary = (
    sales.groupby("region")
    .agg(
        total_revenue=("revenue", "sum"),
        orders=("order_id", "count"),
        avg_order=("revenue", "mean"),
    )
    .sort_values("total_revenue", ascending=False)
)
--- test
assert summary is not ..., "Replace the `...` after `summary =`."
assert list(summary.columns) == ["total_revenue", "orders", "avg_order"], f"Columns should be total_revenue, orders, avg_order, but are {list(summary.columns)}."
assert summary.index.tolist() == ["North", "South", "East"], f"Sort by total revenue descending; index should be North, South, East, but is {summary.index.tolist()}."
assert summary.loc["North", "total_revenue"] == 410.0, f"North revenue should be 410.0, but is {summary.loc['North', 'total_revenue']!r}."
assert summary.loc["South", "orders"] == 3, f"South should have 3 orders, but has {summary.loc['South', 'orders']!r}."
assert abs(summary.loc["East", "avg_order"] - 60.0) < 1e-9, "East's average order should be 60.0."
--- hint
Start with `sales.groupby("region")`, then use `.agg(...)` with named tuples such as `total_revenue=("revenue", "sum")`.
--- hint
Sort after aggregating: `.sort_values("total_revenue", ascending=False)`.
```

## Your turn: share of the region

Add a column `share` holding each order's fraction of its **region's** revenue, rounded to 3 decimals. Do not compute the totals by hand; let `transform` broadcast them.

```python exercise id=share-of-total title="Share of the region"
import pandas as pd

sales = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E"],
    "region": ["North", "South", "North", "South", "North"],
    "revenue": [120.0, 80.0, 200.0, 160.0, 90.0],
})

# TODO: add a `share` column; keep all five rows.
share = ...
--- solution
import pandas as pd

sales = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E"],
    "region": ["North", "South", "North", "South", "North"],
    "revenue": [120.0, 80.0, 200.0, 160.0, 90.0],
})

share = (sales["revenue"] / sales.groupby("region")["revenue"].transform("sum")).round(3)
--- test
assert share is not ..., "Replace the `...` after `share =`."
assert len(share) == len(sales), f"`share` should have one value per row ({len(sales)}), but has {len(share)}. Use transform, not agg."
assert share.round(3).tolist() == [0.293, 0.333, 0.488, 0.667, 0.220], f"Shares should be [0.293, 0.333, 0.488, 0.667, 0.220], but are {share.round(3).tolist()}."
assert abs(share.iloc[0] - 120 / 410) < 1e-3, "The first North order is 120 out of 410."
--- hint
`transform("sum")` returns a value for every row, unlike `sum()` which collapses each group to one value.
--- hint
Use `sales.groupby("region")["revenue"].transform("sum")` as the denominator, then divide the revenue column and round.
```

## The metric that answered a different question

This code runs, but it reports the average order value by region when the brief asked for **total revenue**. Fix the aggregation. The grouping and output shape are already right.

```python debug id=groupby-metric title="Mean instead of total"
import pandas as pd

sales = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E"],
    "region": ["North", "South", "North", "South", "North"],
    "revenue": [120.0, 80.0, 200.0, 160.0, 90.0],
})

result = sales.groupby("region")["revenue"].mean()
print(result)
--- solution
import pandas as pd

sales = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E"],
    "region": ["North", "South", "North", "South", "North"],
    "revenue": [120.0, 80.0, 200.0, 160.0, 90.0],
})

result = sales.groupby("region")["revenue"].sum()
print(result)
--- test
assert result.loc["North"] == 410.0, f"North total revenue should be 410.0, but is {result.loc['North']!r}."
assert result.loc["South"] == 240.0, f"South total revenue should be 240.0, but is {result.loc['South']!r}."
assert len(result) == 2, "Return one value per region, not one value per row."
--- hint
Run it. North returns 136.67, which is the average of 120, 200 and 90. The brief asked for the total.
--- hint
Replace `.mean()` with `.sum()`.
```

## Predict the group sizes

```python predict id=predict-group-size title="Sizes by team"
import pandas as pd

df = pd.DataFrame({
    "team": ["beta", "alpha", "beta", "alpha", "beta"],
    "points": [10, 20, 30, 40, 50],
})

print(df.groupby("team").size().tolist())
--- options
[3, 2]
* [2, 3]
[10, 30, 50]
[20, 40]
--- explain
`groupby` sorts the group keys alphabetically by default: alpha has 2 rows, beta has 3. `.size()` counts rows. If you wanted points per team, you would select the `points` column and use `.sum()`.
```

## Recap

- `groupby` splits rows, applies an aggregation, and combines one result per group.
- Named `.agg(total=("column", "sum"))` produces stable, readable columns.
- Multiple keys create a MultiIndex; `unstack` turns the last level into columns.
- `transform` returns one value per original row, perfect for shares and normalisation.
- Choose the metric deliberately: sum, mean, count and size answer different questions.

**Up next:** you'll combine multiple tables and reshape between long and wide layouts — the two operations that turn separate exports into one analysis-ready dataset.
