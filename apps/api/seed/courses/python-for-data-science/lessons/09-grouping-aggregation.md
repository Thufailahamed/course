Most business questions are "per something" questions: revenue per city, average basket per customer, returns per product. In pandas the pattern is always the same, and it has three steps: split the rows into groups, apply a calculation to each group, and combine the results. This lesson shows that pattern in its common forms: simple totals, named aggregations, and transformations that keep every row.

```python run
import io
import pandas as pd

CSV = """date,city,product,units,price
2026-01-03,Lyon,Tea,4,6.50
2026-01-03,Paris,Coffee,2,9.00
2026-01-04,Lyon,Coffee,1,9.00
2026-01-05,Nice,Tea,6,6.50
2026-01-06,Paris,Tea,5,6.50
2026-02-01,Nice,Coffee,3,9.50
2026-02-02,Lyon,Tea,2,6.50
2026-02-02,Paris,Coffee,4,9.50
"""
sales = pd.read_csv(io.StringIO(CSV), parse_dates=["date"])
sales["revenue"] = sales["units"] * sales["price"]
print("loaded", len(sales), "orders")
```

## Split, apply, combine

```python run
by_city = sales.groupby("city")["revenue"].sum()
print(by_city)
```

`groupby("city")` splits the rows by city, `["revenue"]` picks the column, and `sum()` applies to each group. The result is indexed by city.

## Several statistics at once

Named aggregation gives each output column a clear name and its own calculation.

```python run
summary = sales.groupby("city").agg(
    orders=("units", "size"),
    units=("units", "sum"),
    revenue=("revenue", "sum"),
    avg_price=("price", "mean"),
)
print(summary.sort_values("revenue", ascending=False))
```

`size` counts rows in each group, which is different from `count`. `count` skips missing values, so it can be smaller than `size`.

## Groups with several keys

```python run
by_city_product = sales.groupby(["city", "product"])["units"].sum()
print(by_city_product)
```

`unstack` turns the inner key into columns, which is the table you would show in a report:

```python run
by_city_product.unstack(fill_value=0)
```

## Transform: keep every row

`transform` computes a group result and broadcasts it back to each row. It is how you compare a row with its group, such as its share of the city total.

```python run
sales["city_revenue"] = sales.groupby("city")["revenue"].transform("sum")
sales["share_of_city"] = (sales["revenue"] / sales["city_revenue"]).round(3)
print(sales[["city", "product", "revenue", "share_of_city"]])
```

Every row keeps its identity, and the new column has the same length as the table.

> **Pitfall:** `sum` and `mean` treat missing values differently from what you might expect. A group where every unit is missing gives 0 for `sum` and NaN for `mean`. Check the count of values behind every average.

## Challenge: revenue by city

```python exercise id=revenue-by-city title="Revenue per city, largest first"
import pandas as pd

# TODO: `revenue_by_city(df)` takes a table with columns city, units and price. Revenue is units × price for
# each row. Return a Series of total revenue per city, named "revenue", indexed by city, largest first.
def revenue_by_city(df):
    ...
--- solution
import pandas as pd

def revenue_by_city(df):
    revenue = df["units"] * df["price"]
    totals = revenue.groupby(df["city"]).sum()
    return totals.sort_values(ascending=False).rename("revenue")
--- test
import pandas as pd
df = pd.DataFrame({"city": ["Lyon", "Paris", "Lyon", "Nice"], "units": [2, 1, 3, 4], "price": [10.0, 40.0, 10.0, 5.0]})
result = revenue_by_city(df)
assert result is not None, "Replace the `...` in `revenue_by_city` with code that returns the Series."
assert isinstance(result, pd.Series), "The result should be a Series."
assert result.index.tolist() == ["Lyon", "Paris", "Nice"], f"Lyon (50), Paris (40) and Nice (20) should be listed largest first, but the order is {result.index.tolist()}. Lyon is 2×10 + 3×10 = 50."
assert result["Lyon"] == 50.0, f"Lyon's revenue should be 2×10 + 3×10 = 50, but it is {result['Lyon']}."
assert result.name == "revenue", "Name the Series 'revenue'."
--- hint
Compute the revenue column first, then group it by the city column and sum each group. The sorted order comes last.
--- hint
`revenue.groupby(df["city"]).sum()`, then `sort_values(ascending=False)`, then `rename("revenue")`.
```

## Challenge: average price by product

```python exercise id=avg-price-product title="Average price per product"
import pandas as pd

# TODO: `average_price_by_product(df)` takes a table with "product" and "price" columns. Return a Series of the
# mean price per product, indexed by product name in alphabetical order.
def average_price_by_product(df):
    ...
--- solution
import pandas as pd

def average_price_by_product(df):
    return df.groupby("product")["price"].mean().sort_index()
--- test
import pandas as pd
df = pd.DataFrame({"product": ["Tea", "Coffee", "Tea", "Cocoa"], "price": [6.0, 9.0, 8.0, 7.0]})
result = average_price_by_product(df)
assert result is not None, "Replace the `...` in `average_price_by_product` with code that returns the Series."
assert list(result.index) == ["Cocoa", "Coffee", "Tea"], f"The products should be in alphabetical order, but you returned {list(result.index)}."
assert abs(result["Tea"] - 7.0) < 1e-9, "The two Tea prices are 6 and 8, so the mean is 7."
assert abs(result["Coffee"] - 9.0) < 1e-9, "Coffee has one price, 9."
--- hint
Group by product, take the mean of price, then sort the index alphabetically.
--- hint
`df.groupby("product")["price"].mean().sort_index()`.
```

## Debug the wrong aggregate

This code is meant to report total units per city, but it computes something else.

```python debug id=mean-not-sum title="Total units, not average units"
import io
import pandas as pd

df = pd.read_csv(io.StringIO("city,units\nLyon,4\nLyon,3\nParis,2\n"))
totals = df.groupby("city")["units"].mean()     # bug: this is the average per order
print(totals)
--- solution
import io
import pandas as pd

df = pd.read_csv(io.StringIO("city,units\nLyon,4\nLyon,3\nParis,2\n"))
totals = df.groupby("city")["units"].sum()
print(totals)
--- test
assert totals["Lyon"] == 7, f"Lyon sold 4 + 3 = 7 units, but totals says {totals['Lyon']}. Use sum, not mean, for a total."
assert totals["Paris"] == 2, "Paris sold 2 units."
--- hint
The question asks for a total. An average answers a different question.
--- hint
Replace `mean()` with `sum()`.
```

## Predict the group sizes

```python predict id=predict-groups title="How many rows are in group A?"
import pandas as pd
df = pd.DataFrame({"g": ["A", "B", "A", "A"], "v": [1, 2, None, 4]})
print(df.groupby("g")["v"].size()["A"])
--- options
* 3
2
4
1
--- explain
`size` counts every row in the group, including the one whose value is missing. Group A has three rows, so the answer is 3. `count` would give 2, because it skips the missing value.
```

## Recap

- Group, apply, combine: `groupby(...)` followed by an aggregation.
- Use named aggregation for several statistics with clear names.
- `transform` keeps every row and broadcasts the group result back.
- Check which aggregate you asked for. Totals and averages answer different questions.

**Up next:** joining and reshaping. Real analysis almost always combines more than one table.
