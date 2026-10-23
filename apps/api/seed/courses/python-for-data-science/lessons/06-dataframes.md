# DataFrames 101

A NumPy array is a grid of values. A pandas **DataFrame** is a grid of values *with names*: named columns, a row index, and a dtype per column. That sounds like a small difference. In practice it is the difference between remembering that column 3 is price and writing `orders["unit_price"]`.

In this lesson you'll create a DataFrame, inspect it before touching it, select rows and columns, derive new columns, parse dates and handle missing values. These are the moves you will repeat in every analysis.

## A table with names

```python run
import pandas as pd

orders = pd.DataFrame({
    "order_id": ["A-100", "A-101", "A-102", "A-103", "A-104", "A-105"],
    "city": ["Lisbon", " Porto ", "Lisbon", "Madrid", "porto", "Madrid"],
    "units": [2, 1, 4, 3, 2, 5],
    "unit_price": [19.99, 5.50, 12.00, 8.25, 4.25, 2.00],
    "status": ["delivered", "delivered", "cancelled", "delivered", "pending", "delivered"],
    "ordered_at": ["2026-01-03", "2026-01-04", "2026-01-09", "2026-02-01", "2026-02-02", "2026-02-08"],
})

orders
```

A DataFrame has an **index** on the left (0–5 here) and a **column index** across the top. The index is a label, not data — but it can carry meaning, and it participates in alignment when you combine tables.

## Inspect before you analyze

```python run
print("shape:", orders.shape)
print("\ndtypes:")
print(orders.dtypes)
print("\nfirst three rows:")
print(orders.head(3))
```

`shape` is `(rows, columns)`. `dtypes` tells you whether `units` is a number or text. `head()` shows the first rows without dumping the whole table. For a new dataset, also run `orders.info()` and `orders.describe()`: the first reports non-null counts and memory, the second summarizes numeric columns.

> **Tip:** Do not skip this step. A numeric-looking column stored as `object` will break arithmetic later, and a date stored as text cannot be filtered by month.

## Select rows and columns

`[]` with a column name returns a Series. `.loc` selects by **label**; `.iloc` selects by **position**. The distinction matters once your index is not 0, 1, 2…

```python run
print(orders["city"].head())
print("\nlabel selection:")
print(orders.loc[1, ["order_id", "city", "units"]])
print("\nposition selection:")
print(orders.iloc[:3, :3])
```

`.loc[1, ["order_id", "city", "units"]]` means "row with index label 1, these columns". `.iloc[0:3, 0:3]` means "the first three rows and the first three columns". Mixing them up is a classic source of wrong-row bugs.

## Filter rows

A boolean Series selects the rows where it is true. Combine conditions with `&` and `|`, and wrap each comparison in parentheses.

```python run
delivered = orders[(orders["status"] == "delivered") & (orders["units"] >= 2)]
delivered = delivered.sort_values("units", ascending=False)
delivered
```

`orders["units"] >= 2` is a Series of booleans, one per row. The outer `orders[...]` keeps the rows whose value is `True`. The result keeps the original index labels; that is normal and useful for tracing rows back.

## Derive columns

New columns are assigned like dictionary keys. String columns have a `.str` accessor; dates need `pd.to_datetime` before `.dt` works.

```python run
orders["revenue"] = orders["units"] * orders["unit_price"]
orders["city"] = orders["city"].str.strip().str.title()
orders["ordered_at"] = pd.to_datetime(orders["ordered_at"])
orders["month"] = orders["ordered_at"].dt.to_period("M")

orders.sort_values("revenue", ascending=False).head()
```

Every operation is vectorized: the multiplication happens across the whole column at once. `dt.to_period("M")` produces a month label such as `2026-01`, which is ideal for grouping later.

## Missing values are information

```python run
messy = pd.DataFrame({
    "order_id": ["B-1", "B-2", "B-3"],
    "quantity": [2, None, 4],
    "unit_price": [10.0, 5.0, 2.5],
})

print(messy.isna())
print("\nrows with any missing value:")
print(messy[messy.isna().any(axis=1)])

messy["quantity"] = messy["quantity"].fillna(0).astype(int)
messy["revenue"] = messy["quantity"] * messy["unit_price"]
messy
```

`fillna(0)` is a decision, not a default. For a missing quantity, zero may mean "nothing shipped"; for a missing price, zero would silently erase revenue. Sometimes `dropna()` is the honest choice. Decide with the business meaning in mind.

> **Pitfall:** `astype(int)` on a column with `NaN` raises. Fill or drop the missing values first. And `int` is not always right: a count can be integer; a price should stay float.

## Your turn: clean the order export

The export has padded city names, quantities stored as text, a missing quantity and dates stored as text. Produce `clean` with:

- `city` stripped and title-cased
- `quantity` as an integer, with missing values filled as 0
- `revenue = quantity * unit_price`
- `ordered_at` parsed as a datetime
- `month` as a `Period` such as `2026-01`

```python exercise id=clean-orders title="Clean the order export"
import pandas as pd

raw = pd.DataFrame({
    "order_id": ["A-1", "A-2", "A-3", "A-4"],
    "city": [" lisbon ", "PORTO", "Lisbon", " porto "],
    "quantity": ["2", "1", None, "3"],
    "unit_price": [19.99, 5.50, 12.00, 4.25],
    "ordered_at": ["2026-01-03", "2026-01-04", "2026-02-01", "2026-02-02"],
    "status": ["delivered", "cancelled", "delivered", "delivered"],
})

clean = raw.copy()

# TODO: transform the columns in `clean`.
clean["city"] = ...
clean["quantity"] = ...
clean["revenue"] = ...
clean["ordered_at"] = ...
clean["month"] = ...
--- solution
import pandas as pd

raw = pd.DataFrame({
    "order_id": ["A-1", "A-2", "A-3", "A-4"],
    "city": [" lisbon ", "PORTO", "Lisbon", " porto "],
    "quantity": ["2", "1", None, "3"],
    "unit_price": [19.99, 5.50, 12.00, 4.25],
    "ordered_at": ["2026-01-03", "2026-01-04", "2026-02-01", "2026-02-02"],
    "status": ["delivered", "cancelled", "delivered", "delivered"],
})

clean = raw.copy()
clean["city"] = clean["city"].str.strip().str.title()
clean["quantity"] = clean["quantity"].fillna(0).astype(int)
clean["revenue"] = clean["quantity"] * clean["unit_price"]
clean["ordered_at"] = pd.to_datetime(clean["ordered_at"])
clean["month"] = clean["ordered_at"].dt.to_period("M")
--- test
assert clean["city"].tolist() == ["Lisbon", "Porto", "Lisbon", "Porto"], f"City values should be cleaned, but are {clean['city'].tolist()}."
assert pd.api.types.is_integer_dtype(clean["quantity"]), f"`quantity` should be an integer column, but has dtype {clean['quantity'].dtype}. Convert the text and fill the missing value."
assert clean["quantity"].tolist() == [2, 1, 0, 3], f"`quantity` should be [2, 1, 0, 3], but is {clean['quantity'].tolist()}."
assert clean["revenue"].round(2).tolist() == [39.98, 5.50, 0.0, 12.75], f"Revenue should be [39.98, 5.5, 0.0, 12.75], but is {clean['revenue'].round(2).tolist()}."
assert str(clean["month"].iloc[0]) == "2026-01" and str(clean["month"].iloc[2]) == "2026-02", "`month` should be a Period column such as 2026-01."
assert clean.shape == (4, 8), f"`clean` should have 4 rows and 8 columns, but has shape {clean.shape}."
--- hint
String methods live on `.str`: `clean["city"].str.strip().str.title()`.
--- hint
For `quantity`, fill first, then convert: `clean["quantity"].fillna(0).astype(int)`. For the date, use `pd.to_datetime`, then `.dt.to_period("M")`.
```

## Your turn: the top delivered orders

Filter to delivered orders with revenue at least 50, sort by revenue from highest to lowest, and keep the first two rows in `result`.

```python exercise id=top-orders title="Find the top delivered orders"
import pandas as pd

orders = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E"],
    "status": ["delivered", "delivered", "cancelled", "delivered", "delivered"],
    "revenue": [80.0, 20.0, 100.0, 60.0, 50.0],
})

# TODO: filter, sort, and take the top two.
result = ...
--- solution
import pandas as pd

orders = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E"],
    "status": ["delivered", "delivered", "cancelled", "delivered", "delivered"],
    "revenue": [80.0, 20.0, 100.0, 60.0, 50.0],
})

result = (
    orders[(orders["status"] == "delivered") & (orders["revenue"] >= 50)]
    .sort_values("revenue", ascending=False)
    .head(2)
)
--- test
assert result is not ..., "Replace the `...` after `result =`."
assert result.shape[0] == 2, f"`result` should have 2 rows, but has {result.shape[0]}. Did you sort before taking the top two?"
assert result["order_id"].tolist() == ["A", "D"], f"The top two delivered orders should be A and D, but got {result['order_id'].tolist()}."
assert result["revenue"].tolist() == [80.0, 60.0], f"Revenue should be [80.0, 60.0], but is {result['revenue'].tolist()}."
--- hint
Build the boolean mask first: status is delivered **and** revenue is at least 50. Use `&` with parentheses.
--- hint
Chain `.sort_values("revenue", ascending=False)` and `.head(2)` after filtering.
```

## The column that is secretly text

This table looks numeric, but the quantity column holds strings. The multiplication fails before the lesson can print. Fix the type at the boundary, then verify the revenue.

```python debug id=string-revenue title="Numbers stored as text"
import pandas as pd

orders = pd.DataFrame({
    "order_id": ["B-1", "B-2", "B-3"],
    "quantity": ["2", "3", "1"],
    "unit_price": [10.0, 5.0, 20.0],
})

orders["revenue"] = orders["quantity"] * orders["unit_price"]
print(orders)
--- solution
import pandas as pd

orders = pd.DataFrame({
    "order_id": ["B-1", "B-2", "B-3"],
    "quantity": ["2", "3", "1"],
    "unit_price": [10.0, 5.0, 20.0],
})

orders["quantity"] = orders["quantity"].astype(int)
orders["revenue"] = orders["quantity"] * orders["unit_price"]
print(orders)
--- test
assert pd.api.types.is_integer_dtype(orders["quantity"]), f"`quantity` should be an integer column, but has dtype {orders['quantity'].dtype}."
assert orders["quantity"].tolist() == [2, 3, 1], "The numeric values should stay 2, 3 and 1."
assert orders["revenue"].tolist() == [20.0, 15.0, 20.0], f"Revenue should be [20.0, 15.0, 20.0], but is {orders['revenue'].tolist()}."
--- hint
Read the error. Is pandas multiplying numbers, or trying to repeat a string?
--- hint
Convert the column before multiplying: `orders["quantity"] = orders["quantity"].astype(int)`.
```

## Predict the filter

```python predict id=predict-row-count title="How many Lisbon rows?"
import pandas as pd

df = pd.DataFrame({
    "city": ["Lisbon", "Porto", "Lisbon"],
    "units": [2, 3, 4],
})

print(df[df["city"] == "Lisbon"].shape[0])
--- options
1
* 2
3
4
--- explain
The boolean mask is `[True, False, True]`, so two rows survive. `.shape[0]` then reads the number of rows in the filtered frame.
```

## Recap

- A DataFrame has named columns, an index and a dtype per column. Inspect `shape`, `dtypes`, `head()` and `info()` before analysis.
- Use `[]` for columns, `.loc` for labels, `.iloc` for positions, and boolean masks for filtering.
- Derive columns with vectorized arithmetic; use `.str` for text and `pd.to_datetime` + `.dt` for dates.
- Missing values are a decision: fill them only when the substitute is meaningful.
- Convert text to numbers before arithmetic. A dtype bug is not a formatting problem.

**Up next:** you'll stop looking at individual rows and start answering questions about groups: revenue by region, average order by plan, share of total by month.
