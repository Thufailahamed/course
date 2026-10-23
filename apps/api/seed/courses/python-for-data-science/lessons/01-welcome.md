Welcome to **Python for Data Science**. Almost every data question you will ever answer follows the same path: load a table, check that it means what you think it means, clean it, reshape it, look at it, and then say something true about it. This course walks that path with you, one step at a time, using the tools the profession uses: Python, NumPy, pandas and matplotlib.

You will not just read about these tools. Every example is a live cell, and every challenge is a function you write and test. By the end you will have analyzed a messy sales dataset from start to finish.

> **How to use this lesson:** read a little, run a little. Edit a value in a cell and run it again to see what changes.

## Run your first cell

Click **Run** on the cell below, or click inside it and press **Shift + Enter**.

```python run
import pandas as pd

sales = pd.DataFrame({
    "city": ["Lyon", "Paris", "Lyon", "Nice"],
    "units": [3, 7, 2, 5],
    "price": [9.5, 8.0, 9.5, 12.0],
})
print(sales)
```

The first run can take a few seconds, because the browser downloads pandas the first time you import it. Later cells reuse it.

## Cells share memory, like a notebook

Variables you create in one cell are available in the cells below it, once you have run the earlier cell.

```python run
sales["revenue"] = sales["units"] * sales["price"]
sales
```

The last line of a cell is shown automatically, so ending with a table is a quick way to look at it. **Run all** executes every cell in order, and **Restart** clears memory.

## Errors are information

Analysts meet errors all day. Here is one on purpose:

```python run error
sales["discount"]
```

Read the message: pandas says the column does not exist. The error card explains the problem in plain language. Most of the time, the fix is to look at the data you actually have, which is the habit this course is built around.

## Predict before you run

Experienced analysts predict a result before running it. Read the code, choose an answer, then run it.

```python predict id=predict-filter title="How many rows survive the filter?"
import pandas as pd
df = pd.DataFrame({"price": [5, 12, 20, 9]})
print(len(df[df["price"] > 9]))
--- options
* 2
3
4
1
--- explain
Only 12 and 20 are strictly greater than 9. The 9 is excluded because `>` is a strict comparison. The filter keeps two rows, so `len` returns 2.
```

## Your first challenge

A **challenge** asks you to write a function. The course runs it against hidden tests on new data, so it has to be correct in general, not only for the example. Press **Check** to test your code, and use the hints if you get stuck.

```python exercise id=total-revenue title="Total revenue"
import pandas as pd

# TODO: `total_revenue(df)` should return the sum of the `units * price` for every row, as one number.
def total_revenue(df):
    ...
--- solution
import pandas as pd

def total_revenue(df):
    return (df["units"] * df["price"]).sum()
--- test
import pandas as pd
sample = pd.DataFrame({"units": [2, 1], "price": [3.0, 10.0]})
result = total_revenue(sample)
assert result is not None, "Replace the `...` in `total_revenue` with code that returns the total."
assert abs(result - 16.0) < 1e-9, f"2 × 3 + 1 × 10 = 16, but you returned {result!r}."
other = pd.DataFrame({"units": [4, 0, 5], "price": [2.5, 99.0, 1.0]})
assert abs(total_revenue(other) - 15.0) < 1e-9, "Rows with zero units add nothing. Check that you multiply column by column."
--- hint
Multiply the two columns elementwise: `df["units"] * df["price"]`. Then add up the result with `.sum()`.
--- hint
`return (df["units"] * df["price"]).sum()`.
```

## Debug a silent mistake

A **debug challenge** starts with code that runs but does the wrong thing. Here, a discount is meant to apply to expensive items only, but the assignment goes to a copy and changes nothing.

```python debug id=chained-assign title="Make the discount stick"
import pandas as pd

df = pd.DataFrame({"item": ["pen", "lamp", "desk"], "price": [2.0, 40.0, 150.0]})
df[df["price"] > 30]["price"] = df["price"] * 0.9      # does this change df?
print(df)
--- solution
import pandas as pd

df = pd.DataFrame({"item": ["pen", "lamp", "desk"], "price": [2.0, 40.0, 150.0]})
df.loc[df["price"] > 30, "price"] = df["price"] * 0.9
print(df)
--- test
expected = [2.0, 36.0, 135.0]
assert list(df["price"].round(6)) == expected, f"Prices should be {expected} after a 10% discount on items over 30, but they are {list(df['price'].round(6))}. Use one `.loc` call that selects rows and the column together."
--- hint
Chained indexing, `df[mask]["price"] = ...`, can assign to a temporary copy. A single `.loc[rows, column]` assignment updates the original DataFrame.
--- hint
`df.loc[df["price"] > 30, "price"] = df["price"] * 0.9`, but note the right side is the full column; `.loc` assigns it only to the selected rows.
```

## Recap

- A pandas DataFrame is a table whose columns are series. Operations on columns are vectorized.
- The last line of a cell is shown automatically, so end with a table to look at it.
- Read error messages: they usually name the column or line at fault.
- Write functions that take data and return answers, then test them on fresh data.

**Up next:** Python's core data containers, and the comprehensions that turn one table of records into another.
