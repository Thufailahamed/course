A **DataFrame** is a table: rows are observations, columns are named variables, and each column holds one type of value. It is the central object of pandas, and most of your analysis will begin with loading one and asking what it contains. This lesson shows how to load data, how to look at it before you trust it, and how to summarize it.

The examples use a small sales export, stored as text so the page needs no files. Reading from `io.StringIO` is the same as reading a real CSV file.

## Load a table

```python run
import io
import pandas as pd

CSV = """date,city,product,units,price
2026-01-03,Lyon,Tea,4,6.50
2026-01-03,Paris,Coffee,2,9.00
2026-01-04,Lyon,Coffee,1,9.00
2026-01-05,Nice,Tea,,6.50
2026-01-06,Paris,Tea,5,6.50
2026-02-01,Nice,Coffee,3,9.50
2026-02-02,Lyon,Tea,2,6.50
2026-02-02,Paris,Coffee,4,9.50
"""

sales = pd.read_csv(io.StringIO(CSV))
sales
```

`read_csv` read the header row for the column names and guessed a type for each column. Notice that the empty units cell on 5 January became a missing value, shown as `NaN`.

## Look before you trust

Three methods answer most first questions about a new table: what it looks like, what types it has, and whether anything is missing.

```python run
print(sales.shape)
sales.head(3)
```

```python run
sales.info()
```

`info` lists every column with its type and how many values are not missing. A column with fewer non-null values than rows has gaps, and you now know which.

## Summaries

`describe` gives count, mean, spread and quartiles for every numeric column in one table.

```python run
sales.describe()
```

Read it critically. The count of `units` is smaller than the number of rows because of the missing value, and `describe` quietly skips it. An average of a column always tells you how many values it used.

## Single columns and simple statistics

```python run
print("units total:", sales["units"].sum())
print("average price:", round(sales["price"].mean(), 2))
print("distinct products:", sales["product"].nunique())
print("most common city:", sales["city"].value_counts().index[0])
```

`value_counts` is the quick way to see how often each category appears, and it is the first thing to check on any text column.

## Create and check a new column

You can derive new columns from existing ones. Each new column is a vectorized calculation, the same idea you saw with NumPy arrays.

```python run
sales["revenue"] = sales["units"] * sales["price"]
print(sales[["city", "units", "price", "revenue"]])
```

Notice that the missing units produced a missing revenue. pandas propagates gaps through calculations rather than inventing values, which is the honest behavior.

## Challenge: load orders from text

```python exercise id=load-orders title="Load a CSV with parsed dates"
import io
import pandas as pd

# TODO: `load_orders(text)` takes CSV text with a "date" column and returns a DataFrame. The "date"
# column must be parsed as datetimes (not plain text). All other columns keep the types pandas gives them.
def load_orders(text):
    ...
--- solution
import io
import pandas as pd

def load_orders(text):
    return pd.read_csv(io.StringIO(text), parse_dates=["date"])
--- test
import io
import pandas as pd
text = "date,amount\n2026-03-01,10\n2026-03-02,20\n"
result = load_orders(text)
assert result is not None, "Replace the `...` in `load_orders` with code that returns the DataFrame."
assert isinstance(result, pd.DataFrame), "load_orders should return a DataFrame."
assert pd.api.types.is_datetime64_any_dtype(result["date"]), "The date column should be parsed as datetimes. Use parse_dates=['date'] in read_csv."
assert result["amount"].sum() == 30, "The amounts should be read as numbers and sum to 30."
assert len(result) == 2, "There are two rows of data."
--- hint
`pd.read_csv` accepts a `parse_dates` argument, a list of column names to convert to dates. Wrap the text in `io.StringIO`.
--- hint
`return pd.read_csv(io.StringIO(text), parse_dates=["date"])`.
```

## Challenge: profile a table

```python exercise id=column-profile title="Profile a DataFrame"
import pandas as pd

# TODO: `column_profile(df)` returns a dictionary with three keys: "rows" (the number of rows), "columns"
# (the list of column names, in order) and "missing" (the total number of missing cells in the whole table).
def column_profile(df):
    ...
--- solution
import pandas as pd

def column_profile(df):
    return {"rows": len(df), "columns": list(df.columns), "missing": int(df.isna().sum().sum())}
--- test
import numpy as np
import pandas as pd
df = pd.DataFrame({"a": [1, np.nan, 3], "b": ["x", None, "z"]})
result = column_profile(df)
assert result is not None, "Replace the `...` in `column_profile` with code that returns the dictionary."
assert result["rows"] == 3, "The table has three rows."
assert result["columns"] == ["a", "b"], f"The column names should be a and b, in order, but you returned {result['columns']}."
assert result["missing"] == 2, "There are two missing cells: one in a and one in b."
--- hint
`len(df)` gives the number of rows, and `list(df.columns)` the names. For the missing total, `df.isna().sum()` gives one count per column, and summing that gives the total.
--- hint
`int(df.isna().sum().sum())` counts all missing cells.
```

## Debug the header

This code is meant to read the file and find the `units` column, but it fails.

```python debug id=header-row title="Use the header row"
import io
import pandas as pd

CSV = "date,city,units\n2026-01-03,Lyon,4\n2026-01-04,Paris,2\n"
df = pd.read_csv(io.StringIO(CSV), header=None)     # bug: this treats the header as data
print(df["units"].sum())
--- solution
import io
import pandas as pd

CSV = "date,city,units\n2026-01-03,Lyon,4\n2026-01-04,Paris,2\n"
df = pd.read_csv(io.StringIO(CSV))
print(df["units"].sum())
--- test
assert "units" in df.columns, f"The columns should be named from the header row, but they are {list(df.columns)}. Remove header=None."
assert df["units"].sum() == 6, "The units should sum to 6."
--- hint
`header=None` tells pandas there is no header row, so the names become numbers and the first line is treated as data.
--- hint
Remove the `header=None` argument. The default reads the first row as column names.
```

## Predict the shape

```python predict id=predict-shape title="What is the shape of the table?"
import io
import pandas as pd
df = pd.read_csv(io.StringIO("a,b\n1,2\n3,4\n5,6\n"))
print(df.shape)
--- options
* (3, 2)
(2, 3)
(4, 2)
(3, 3)
--- explain
The header gives two columns, and the three data rows give three rows. The header is not counted as a row, so the shape is (3, 2) for rows and columns in that order.
```

## Recap

- `read_csv` turns text or a file into a DataFrame, and `parse_dates` converts date columns.
- Look before you trust: `head`, `info`, `describe` and `value_counts` answer the first questions.
- Missing values are visible in `info`, and pandas carries them through calculations.
- Create new columns with vectorized expressions over existing ones.

**Up next:** selecting and filtering rows and columns, which is how you ask a table specific questions.
