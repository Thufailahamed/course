Most questions about a table are selections: "the Lyon orders", "the three largest sales", "the price column for March". pandas has a small set of tools for selecting, and knowing which one to use is most of the skill. This lesson covers label-based and position-based selection, boolean filters, and assigning values safely.

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
print("loaded", sales.shape[0], "orders")
```

## Columns: one name or several

A single name in square brackets returns a column as a **Series**. A list of names returns a DataFrame with those columns.

```python run
print(type(sales["units"]).__name__)
sales[["city", "units"]].head(3)
```

Double brackets, `sales[["city", "units"]]`, is a list of column names. It is the most common mistake for beginners.

## Rows by condition: boolean filters

A comparison on a column gives a mask, and indexing with the mask keeps the matching rows. You met this with NumPy arrays; it works the same way here.

```python run
lyon = sales[sales["city"] == "Lyon"]
print(lyon)
```

Combine conditions with `&` (and) and `|` (or), and wrap each one in parentheses:

```python run
big_tea = sales[(sales["product"] == "Tea") & (sales["units"] >= 4)]
print(big_tea[["date", "city", "units"]])
```

## Position and label: `loc` and `iloc`

`iloc` selects by position, with integers, the way Python lists work. `loc` selects by label, which here means the row index and column names.

```python run
print(sales.iloc[0])                       # the first row, by position
print(sales.loc[2, ["city", "price"]])     # row with index label 2, two columns
```

Use `loc` with a mask to select rows and columns together:

```python run
sales.loc[sales["units"] >= 4, ["city", "units"]]
```

## Assign safely

To change values in some rows, use one `loc` call that names the rows and the column. Assigning through a selected copy, such as `sales[mask]["units"] = 0`, can silently change nothing.

```python run
sales.loc[sales["city"] == "Nice", "price"] = sales.loc[sales["city"] == "Nice", "price"] * 1.05
print(sales.loc[sales["city"] == "Nice", ["city", "price"]])
```

## Sorting and the largest rows

```python run
top = sales.sort_values("units", ascending=False).head(3)
print(top[["city", "product", "units"]])
```

`nlargest` does the same job in one step when you only need the top few: `sales.nlargest(3, "units")`.

## Challenge: large orders, ranked

```python exercise id=large-orders title="Rows above a threshold, ranked"
import pandas as pd

# TODO: `large_orders(df, min_units)` returns the rows where `units` is at least `min_units`,
# sorted by `price` from highest to lowest. Keep all the columns, and give the rows a fresh 0-based index.
def large_orders(df, min_units):
    ...
--- solution
import pandas as pd

def large_orders(df, min_units):
    big = df[df["units"] >= min_units]
    return big.sort_values("price", ascending=False).reset_index(drop=True)
--- test
import pandas as pd
df = pd.DataFrame({"city": ["A", "B", "C", "D"], "units": [5, 2, 8, 5], "price": [3.0, 9.0, 4.0, 7.0]})
result = large_orders(df, 5)
assert result is not None, "Replace the `...` in `large_orders` with code that returns the filtered table."
assert list(result["city"]) == ["D", "C", "A"], f"Units at least 5 are A, C and D. Sorted by price, highest first, that is D (7), C (4), A (3), but you returned {list(result['city'])}."
assert list(result.index) == [0, 1, 2], "Reset the index so the rows are numbered 0, 1, 2."
assert list(large_orders(df, 9)["city"]) == [], "If nothing qualifies, return an empty table."
--- hint
Filter first with a boolean mask, then sort with `sort_values("price", ascending=False)`, then restart the index with `reset_index(drop=True)`.
--- hint
`big = df[df["units"] >= min_units]`, then `big.sort_values("price", ascending=False).reset_index(drop=True)`.
```

## Challenge: one city's rows

```python exercise id=city-rows title="Select one city's rows"
import pandas as pd

# TODO: `city_rows(df, city)` returns the rows where the city column equals `city`, keeping only the columns
# "city" and "units". Reset the index so the rows are numbered from 0.
def city_rows(df, city):
    ...
--- solution
import pandas as pd

def city_rows(df, city):
    rows = df[df["city"] == city]
    return rows[["city", "units"]].reset_index(drop=True)
--- test
import pandas as pd
df = pd.DataFrame({"city": ["Lyon", "Paris", "Lyon"], "units": [4, 2, 1], "price": [6.5, 9.0, 6.5]})
result = city_rows(df, "Lyon")
assert result is not None, "Replace the `...` in `city_rows` with code that returns the selected rows."
assert list(result.columns) == ["city", "units"], f"Keep only the city and units columns, but you returned {list(result.columns)}."
assert result["units"].tolist() == [4, 1], "Lyon has two rows, with units 4 and 1."
assert list(result.index) == [0, 1], "Reset the index to 0, 1."
assert len(city_rows(df, "Nice")) == 0, "A city with no rows should give an empty table."
--- hint
Filter with a mask, then select the two columns with a list of names, then `reset_index(drop=True)`.
--- hint
`rows = df[df["city"] == city]` and `return rows[["city", "units"]].reset_index(drop=True)`.
```

## Debug the column selection

This code is meant to show the city and units columns, but it raises an error.

```python debug id=double-brackets title="Select several columns"
import io
import pandas as pd

sales = pd.read_csv(io.StringIO("city,units,price\nLyon,4,6.5\nParis,2,9.0\n"))
view = sales["city", "units"]                 # bug: a tuple is not a list of columns
print(view)
--- solution
import io
import pandas as pd

sales = pd.read_csv(io.StringIO("city,units,price\nLyon,4,6.5\nParis,2,9.0\n"))
view = sales[["city", "units"]]
print(view)
--- test
assert list(view.columns) == ["city", "units"], f"The view should have the city and units columns, but it has {list(view.columns)}. Pass a list of names inside the brackets."
--- hint
Inside `[]`, a list of names needs its own square brackets.
--- hint
`sales[["city", "units"]]`.
```

## Predict the rows

```python predict id=predict-filter title="How many rows match?"
import pandas as pd
df = pd.DataFrame({"units": [1, 4, 6, 4]})
print(len(df[df["units"] >= 4]))
--- options
* 3
2
4
1
--- explain
Three values are at least 4: the two 4s and the 6. The condition is inclusive because of `>=`, so both 4s count.
```

## Recap

- One column name returns a Series; a list of names returns a DataFrame.
- Filter rows with a boolean mask, combining conditions with `&` and `|` inside parentheses.
- Use `loc` for labels and conditions together, and `iloc` for positions.
- Assign with a single `loc` call so the change lands in the original table.

**Up next:** cleaning data. Filtering only works if the values you filter on are correct, and real exports rarely are.
