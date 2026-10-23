Exploratory data analysis, or EDA, is the stage where you get to know a dataset before you trust anything it says. Good analysts follow a rough routine: state the question, check the structure, check the gaps, look at each variable on its own, look at how variables relate, and write down what you found and what you doubt. The routine matters more than any single method, because it is what keeps you from answering the wrong question with confident-looking numbers.

## Start with a question

Write the question down before you touch the data. "Which product should we promote?" is vague. "Which product has the highest revenue per order, after returns, in the last quarter?" tells you which columns and which rows matter, and it stops you from wandering.

## Check the structure

The first look at a dataset answers: how many rows, which columns, what types, and what one row represents.

```python run
import numpy as np
import pandas as pd

rng = np.random.default_rng(3)
n = 300
orders = pd.DataFrame({
    "order_id": np.arange(1, n + 1),
    "customer": rng.integers(1, 80, n),
    "city": rng.choice(["Lyon", "Paris", "Nice", "Lille"], n, p=[0.3, 0.35, 0.2, 0.15]),
    "product": rng.choice(["Tea", "Coffee", "Cocoa"], n, p=[0.4, 0.4, 0.2]),
    "units": rng.poisson(3, n) + 1,
    "price": rng.uniform(5, 12, n).round(2),
})
orders.loc[rng.random(n) < 0.05, "price"] = np.nan      # some prices were never recorded
orders.loc[rng.random(n) < 0.02, "units"] = 0           # zero-unit orders look suspicious

print("rows:", len(orders), "| columns:", orders.shape[1])
print("one row is one order:", orders["order_id"].is_unique)
orders.head()
```

Asking "is `order_id` unique?" is a real check. If an identifier repeats, every count built on it is suspect.

## Check the gaps

```python run
missing = orders.isna().sum()
print(missing[missing > 0])
print("share of rows with any gap:", round(orders.isna().any(axis=1).mean(), 3))
```

Missing values are information. If prices are missing mostly in one city, that is a finding about the data collection, not only a cleaning chore.

## Look at each variable

For numbers, look at the range and the shape. For categories, look at how many values there are and how they are spread.

```python run
print(orders["units"].describe().round(2))
print(orders["product"].value_counts(normalize=True).round(3))
```

Sanity-check the minimum and maximum. A zero-unit order might be a legitimate return, or a data entry error, and you need to find out which before you use it.

## Test the question on a slice

Before computing the final answer, compute it for one group to see if the logic works and whether the numbers are sensible.

```python run
paris = orders[orders["city"] == "Paris"]
print("Paris orders:", len(paris), "| units:", paris["units"].sum())
```

## Write down what you found

A notebook is a record. Keep a short note for each finding: what you saw, how you checked it, and what you still doubt.

> **Pitfall:** the most dangerous EDA mistake is to stop after the first clean-looking summary. A table with no visible problems can still hide duplicates, a broken join, or a column that means something else than its name.

## Challenge: a missing-value report

```python exercise id=missing-report title="Report the columns with gaps"
import pandas as pd

# TODO: `missing_report(df)` returns a Series with the number of missing values in each column that has at
# least one, sorted from most to fewest. Columns with no missing values are left out.
def missing_report(df):
    ...
--- solution
import pandas as pd

def missing_report(df):
    counts = df.isna().sum()
    counts = counts[counts > 0]
    return counts.sort_values(ascending=False)
--- test
import numpy as np
import pandas as pd
df = pd.DataFrame({"a": [1, None, 3], "b": [None, None, 2], "c": [1, 2, 3]})
result = missing_report(df)
assert result is not None, "Replace the `...` in `missing_report` with code that returns the Series."
assert list(result.index) == ["b", "a"], f"Column b has two gaps and a has one, so the order should be b then a. You returned {list(result.index)}."
assert list(result.values) == [2, 1], "The counts should be 2 for b and 1 for a."
assert "c" not in result.index, "Columns with no gaps should not appear in the report."
--- hint
`df.isna().sum()` counts the missing values in each column. Keep only the counts above zero, then sort.
--- hint
`counts = df.isna().sum(); counts = counts[counts > 0]; return counts.sort_values(ascending=False)`.
```

## Challenge: profile one variable

```python exercise id=value-profile title="Profile a numeric variable"
import pandas as pd

# TODO: `value_profile(series)` returns a dictionary with the keys "observed" (the number of values that are not
# missing), "median", "min" and "max" for a numeric Series. Ignore missing values in every statistic.
def value_profile(series):
    ...
--- solution
import pandas as pd

def value_profile(series):
    observed = series.dropna()
    return {"observed": int(observed.count()), "median": float(observed.median()),
            "min": float(observed.min()), "max": float(observed.max())}
--- test
import numpy as np
import pandas as pd
result = value_profile(pd.Series([4.0, np.nan, 1.0, 7.0]))
assert result is not None, "Replace the `...` in `value_profile` with code that returns the dictionary."
assert result["observed"] == 3, "Three values are observed, because one is missing."
assert result["median"] == 4.0, f"The median of 1, 4 and 7 is 4, but you returned {result['median']}."
assert result["min"] == 1.0 and result["max"] == 7.0, "The minimum is 1 and the maximum is 7."
--- hint
Drop the missing values first, so every statistic uses only the observed values.
--- hint
`observed = series.dropna()`, then count, median, min and max on `observed`.
```

## Debug the count of customers

This code is meant to count distinct customers, but it counts orders.

```python debug id=distinct-customers title="Count customers, not rows"
import pandas as pd

orders = pd.DataFrame({"customer": [1, 1, 2, 3, 3, 3], "units": [2, 1, 4, 1, 1, 2]})
customers = len(orders["customer"])           # bug: this is the number of rows
print("distinct customers:", customers)
--- solution
import pandas as pd

orders = pd.DataFrame({"customer": [1, 1, 2, 3, 3, 3], "units": [2, 1, 4, 1, 1, 2]})
customers = orders["customer"].nunique()
print("distinct customers:", customers)
--- test
assert customers == 3, f"There are three distinct customers (1, 2 and 3), but the code reports {customers}. Count unique values, not rows."
--- hint
`len` counts every row, including repeat orders from the same customer.
--- hint
Use `nunique()`, which counts distinct values in a column.
```

## Predict the answer

```python predict id=predict-eda title="How many missing prices are there?"
import pandas as pd
df = pd.DataFrame({"price": [1.0, None, None, 4.0, None]})
print(df["price"].isna().sum())
--- options
* 3
2
4
5
--- explain
There are five rows, and three of them have no price. `isna` marks the missing entries, and `sum` counts the marks.
```

## Recap

- Start with a question, so you know which columns and rows matter.
- Check the structure: row count, uniqueness of identifiers, and types.
- Look at gaps, and each variable on its own, including its extremes.
- Test the logic on a slice, and write down what you found and what you doubt.

**Up next:** relationships between variables, and the outliers that can distort every average.
