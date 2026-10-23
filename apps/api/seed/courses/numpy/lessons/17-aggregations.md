Data analysis is mostly about **summarizing**: total revenue, average score, the busiest hour, the best-performing region. In NumPy these summaries are called **aggregations** (or *reductions*), because they reduce many numbers to fewer numbers.

The functions themselves are easy: `sum`, `mean`, `max`. The hard part, and the one that separates confident NumPy users from everyone else, is the **`axis` argument**. Get it right and you can summarize a 3-D dataset in one line. Get it wrong and you'll silently average the wrong thing. This lesson gives you a mental model for `axis` that never fails.

## The core aggregations

On a 1-D array, every aggregation collapses all the values into a single result.

```python run
import numpy as np

steps = np.array([8_200, 10_450, 6_300, 12_900, 9_100, 4_800, 11_250])   # one week

print("total:  ", steps.sum())
print("mean:   ", steps.mean().round(1))
print("std:    ", steps.std().round(1))
print("min/max:", steps.min(), steps.max())
print("argmax: ", steps.argmax(), "(the position of the max: day 3)")
print("product of [1..5]:", np.arange(1, 6).prod())
```

Each one exists both as a method (`steps.sum()`) and as a function (`np.sum(steps)`). They're identical, so use whichever reads better. Note the difference between `max` (the largest **value**) and `argmax` (**where** it is). The `arg` functions return indices, which you can use to look up other information:

```python run
days = np.array(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"])
print("Most active day:", days[steps.argmax()])
print("Laziest day:    ", days[steps.argmin()])
```

## The axis argument: "the axis you collapse"

Now a 2-D dataset: weekly sales for 4 weeks (rows) across 3 regions (columns).

```python run
sales = np.array([[120,  95, 210],    # week 0
                  [135, 110, 190],    # week 1
                  [150,  90, 230],    # week 2
                  [160, 105, 250]])   # week 3
#                 North  South  West

print("shape:", sales.shape)
print("sum()        ->", sales.sum(), "(everything)")
print("sum(axis=0)  ->", sales.sum(axis=0), "(one total per REGION)")
print("sum(axis=1)  ->", sales.sum(axis=1), "(one total per WEEK)")
```

Here's the mental model: **`axis` is the dimension that disappears.**

- `sales` has shape `(4, 3)`: axis 0 has length 4 (weeks), axis 1 has length 3 (regions).
- `sum(axis=0)` collapses axis 0, the weeks. The weeks get added together, leaving shape `(3,)`: one number per region.
- `sum(axis=1)` collapses axis 1, the regions, leaving shape `(4,)`: one number per week.

To predict the result's shape, take the input shape and **delete** the axis you pass. `(4, 3)` with `axis=0` → `(3,)`. With `axis=1` → `(4,)`.

> **Tip:** say it out loud as "sum **over** the weeks" (axis 0) or "sum **over** the regions" (axis 1). You name the thing that gets used up, not the thing that's left.

This works in any number of dimensions:

```python run
# 7 days x 24 hours x 3 sensors of temperature readings
rng = np.random.default_rng(42)
temps = rng.normal(20, 3, size=(7, 24, 3))

print("per day & sensor (avg over hours):", temps.mean(axis=1).shape)
print("per hour & sensor (avg over days):", temps.mean(axis=0).shape)
print("per sensor (avg over days AND hours):", temps.mean(axis=(0, 1)).round(2))
print("negative axes count from the end:", temps.mean(axis=-1).shape)
```

Pass a **tuple** of axes to collapse several at once, as in `axis=(0, 1)` above. `axis=-1` always means "the last axis", which is handy when you don't want to count dimensions.

```python predict id=predict-axis-shape title="Which dimension disappears?"
data = np.ones((2, 3, 4))
print(data.sum(axis=1).shape)
--- options
(3,)
(2, 3)
* (2, 4)
(3, 4)
--- explain
Delete the axis you pass. Start from `(2, 3, 4)` and remove axis 1 (the `3`), which leaves `(2, 4)`. Each of those 8 numbers is a sum of 3 values.
```

```python exercise id=region-report title="The regional sales report"
sales = np.array([[120,  95, 210],
                  [135, 110, 190],
                  [150,  90, 230],
                  [160, 105, 250]])   # rows = weeks 0-3, columns = North, South, West
regions = np.array(["North", "South", "West"])

# TODO 1: `region_totals` = total sales for each region over all 4 weeks (shape (3,)).
region_totals = ...

# TODO 2: `weekly_avg` = average sales per region for each week (shape (4,)).
weekly_avg = ...

# TODO 3: `top_region_each_week` = the NAME of the best-selling region in each week
#         (an array of 4 strings). Use argmax and index into `regions`.
top_region_each_week = ...
--- solution
sales = np.array([[120,  95, 210],
                  [135, 110, 190],
                  [150,  90, 230],
                  [160, 105, 250]])
regions = np.array(["North", "South", "West"])

region_totals = sales.sum(axis=0)
weekly_avg = sales.mean(axis=1)
top_region_each_week = regions[sales.argmax(axis=1)]
--- test
assert region_totals is not ..., "Replace the `...` after `region_totals =` with your code."
assert weekly_avg is not ..., "Replace the `...` after `weekly_avg =` with your code."
assert top_region_each_week is not ..., "Replace the `...` after `top_region_each_week =` with your code."
region_totals = np.asarray(region_totals)
assert region_totals.shape == (3,), f"`region_totals` should have one value per region (shape (3,)), but has shape {region_totals.shape}. Which axis holds the weeks?"
assert np.array_equal(region_totals, [565, 400, 880]), f"`region_totals` should be [565, 400, 880], got {region_totals}."
weekly_avg = np.asarray(weekly_avg)
assert weekly_avg.shape == (4,), f"`weekly_avg` should have one value per week (shape (4,)), but has shape {weekly_avg.shape}."
assert np.allclose(weekly_avg, sales.mean(axis=1)), f"`weekly_avg` should be the mean across the 3 regions for each week, got {weekly_avg}."
top = np.asarray(top_region_each_week)
assert top.shape == (4,), f"`top_region_each_week` should have one name per week (shape (4,)), but has shape {top.shape}."
assert top.dtype.kind == "U", "`top_region_each_week` should contain region names (strings), not indices. Use the indices from argmax to index `regions`."
assert top.tolist() == ["West"] * 4, f"Expected the best region in each week, got {top.tolist()}."
--- hint
Weeks are axis 0 and regions are axis 1. To get one number *per region*, collapse the weeks.
--- hint
`sales.sum(axis=0)`, `sales.mean(axis=1)`, and `regions[sales.argmax(axis=1)]`. argmax returns positions, and indexing `regions` with them turns positions into names.
```

## argmax on a 2-D array

Without an `axis`, `argmax` treats the array as if it were flattened into 1-D, and returns a single **flat** index. To turn it back into a `(row, col)` position, use `np.unravel_index`:

```python run
flat_idx = sales.argmax()
print("flat index:", flat_idx)
row, col = np.unravel_index(flat_idx, sales.shape)
print(f"best single cell: week {row}, region {col} -> {sales[row, col]}")
print("best week per region:", sales.argmax(axis=0))
```

## keepdims: aggregate, then broadcast back

Often you aggregate only to **combine the result with the original data**: dividing by a row total, subtracting a column mean, comparing to a row maximum. That's broadcasting, and as you saw last lesson, per-row results need shape `(n, 1)`.

`keepdims=True` keeps the collapsed axis as a size-1 dimension, so the result broadcasts straight back against the original:

```python run
print(sales.max(axis=1).shape)                  # (4,)
print(sales.max(axis=1, keepdims=True).shape)   # (4, 1)

# How far below its week's best region is each region?
gap = sales.max(axis=1, keepdims=True) - sales
gap
```

```python exercise id=row-scaling title="Scale each student's scores"
# Rows = 4 students, columns = 5 quizzes (scores out of 20).
scores = np.array([[12, 15,  9, 18, 14],
                   [20, 19, 17, 20, 18],
                   [ 5,  8, 11,  7,  9],
                   [14, 14, 16, 12, 19]])

# TODO: `relative` = each score divided by that STUDENT'S best score, so every
# student's best quiz becomes 1.0. Use .max(..., keepdims=True) and broadcasting.
relative = ...
--- solution
scores = np.array([[12, 15,  9, 18, 14],
                   [20, 19, 17, 20, 18],
                   [ 5,  8, 11,  7,  9],
                   [14, 14, 16, 12, 19]])

relative = scores / scores.max(axis=1, keepdims=True)
--- test
assert relative is not ..., "Replace the `...` after `relative =` with your code."
assert isinstance(relative, np.ndarray), "`relative` should be a NumPy array."
assert relative.shape == (4, 5), f"`relative` should keep the shape (4, 5), but has {relative.shape}."
assert np.allclose(relative.max(axis=1), 1.0), f"Each student's best score should become 1.0, but the row maximums are {relative.max(axis=1).round(3)}. Are you dividing by each ROW's max?"
assert np.allclose(relative, scores / scores.max(axis=1)[:, None]), "Divide every score by its own student's (row's) maximum."
--- hint
The maximum *per student* means collapsing the quizzes, which is axis 1.
--- hint
`scores.max(axis=1, keepdims=True)` has shape `(4, 1)`, which broadcasts across the 5 quizzes.
```

```python debug id=student-averages title="One average per student, please"
# 5 students (rows) x 3 exams (columns)
scores = np.array([[78, 85, 90],
                   [62, 70, 58],
                   [95, 98, 92],
                   [88, 79, 84],
                   [70, 65, 80]])
names = ["Ana", "Ben", "Cleo", "Dev", "Eli"]

student_avg = scores.mean(axis=0)

for name, avg in zip(names, student_avg):
    print(f"{name}: {avg:.1f}")
--- solution
scores = np.array([[78, 85, 90],
                   [62, 70, 58],
                   [95, 98, 92],
                   [88, 79, 84],
                   [70, 65, 80]])
names = ["Ana", "Ben", "Cleo", "Dev", "Eli"]

student_avg = scores.mean(axis=1)

for name, avg in zip(names, student_avg):
    print(f"{name}: {avg:.1f}")
--- test
student_avg = np.asarray(student_avg)
assert student_avg.shape == (5,), f"There are 5 students, so `student_avg` should have 5 values, but it has shape {student_avg.shape}. Which axis did you collapse?"
assert np.allclose(student_avg, [84.333333, 63.333333, 95.0, 83.666667, 71.666667]), f"Each value should be one student's mean over the 3 exams, got {student_avg.round(2)}."
assert "Eli" in _stdout, "Every student, including Eli, should be printed."
--- hint
Run it. Only 3 names are printed, and `zip` quietly stopped early. How many averages did you compute, and why 3?
--- hint
`axis=0` collapses the *students* (rows), giving one value per exam. To average each student's exams, collapse axis 1.
```

## Running totals: cumsum and cumprod

Sometimes you want every intermediate result, not just the final total. `cumsum` gives a running sum and `cumprod` a running product. Both accept `axis` too.

```python run
deposits = np.array([100, 50, 0, 200, 75])
print("balance after each deposit:", deposits.cumsum())

# Daily returns of an investment: +2%, -1%, +3%, ...
returns = np.array([0.02, -0.01, 0.03, -0.02, 0.01])
growth = (1 + returns).cumprod()
print("value of $1 over time:", growth.round(4))
print(f"total return: {growth[-1] - 1:.2%}")
```

`cumprod` is the right tool for **compounding**: returns multiply, they don't add. Summing the returns (+3%) gives a slightly wrong answer compared with the true compounded return.

```python exercise id=compound-growth title="Track a portfolio"
start_value = 10_000.0
monthly_returns = np.array([0.04, -0.02, 0.015, 0.03, -0.05, 0.02])

# TODO 1: `values` = portfolio value at the END of each month (shape (6,)),
#         compounding the returns from start_value. Use cumprod.
values = ...

# TODO 2: `best_month` = index of the month with the highest end-of-month value.
best_month = ...
--- solution
start_value = 10_000.0
monthly_returns = np.array([0.04, -0.02, 0.015, 0.03, -0.05, 0.02])

values = start_value * (1 + monthly_returns).cumprod()
best_month = values.argmax()
--- test
assert values is not ..., "Replace the `...` after `values =` with your code."
assert best_month is not ..., "Replace the `...` after `best_month =` with your code."
values = np.asarray(values, dtype=float)
assert values.shape == (6,), f"`values` should have one value per month (shape (6,)), but has shape {values.shape}."
expected = 10_000.0 * np.cumprod(1 + np.array([0.04, -0.02, 0.015, 0.03, -0.05, 0.02]))
assert not np.allclose(values, 10_000.0 + 10_000.0 * np.cumsum(monthly_returns)), "It looks like you added the returns. Returns compound: multiply the growth factors (1 + r) instead."
assert np.allclose(values, expected), f"After month 0 the value should be {expected[0]:.2f}; your values are {values.round(2)}."
assert int(best_month) == 3, f"`best_month` should be the index of the highest value, got {best_month!r}."
--- hint
A +4% month multiplies the value by 1.04. Build the growth factors with `1 + monthly_returns`.
--- hint
`start_value * (1 + monthly_returns).cumprod()` gives the value after each month. Then `argmax`.
```

## Differences: np.diff

`np.diff` does the opposite of `cumsum`: it computes the change between **consecutive** elements, so the result is one element shorter.

```python run
balance = np.array([100, 150, 150, 350, 425])
print("changes:", np.diff(balance))                  # 4 values from 5
print("back to deposits:", np.diff(balance, prepend=0))
print("second difference:", np.diff(balance, n=2))   # change of the change
```

`prepend=0` pads the front so the output has the same length as the input. Combining `cumsum` and `diff` lets you move between "totals" and "increments" at will.

```python debug id=pct-change title="Day-over-day percent change"
prices = np.array([50.0, 52.0, 49.4, 51.87, 54.46])

# Percent change from each day to the next: (today - yesterday) / yesterday * 100
pct = np.diff(prices) / prices * 100
print(pct.round(2))
--- solution
prices = np.array([50.0, 52.0, 49.4, 51.87, 54.46])

pct = np.diff(prices) / prices[:-1] * 100
print(pct.round(2))
--- test
pct = np.asarray(pct)
assert pct.shape == (4,), f"5 prices give 4 day-over-day changes, so `pct` should have shape (4,), but has {pct.shape}."
assert np.allclose(pct, [4.0, -5.0, 5.0, 4.99325236]), f"The first change should be +4% (50 -> 52), got {pct.round(2)}. Are you dividing by *yesterday's* price?"
--- hint
Run it and read the error: `np.diff(prices)` has 4 elements but `prices` has 5.
--- hint
Each change should be divided by the price it started from, which is every price except the last: `prices[:-1]`.
```

## Standard deviation and ddof

There are two formulas for standard deviation. The *population* std divides by $n$; the *sample* std divides by $n - 1$, which corrects the bias when your data is a sample from a bigger population:

$$
\sigma = \sqrt{\frac{1}{n - \text{ddof}} \sum_i (x_i - \bar{x})^2}
$$

NumPy defaults to `ddof=0` (population). pandas and most statistics textbooks default to `ddof=1`. Mixing them up is a classic reason why "my NumPy and pandas numbers don't match".

```python run
x = np.array([4.0, 8.0, 6.0, 5.0, 7.0])
print("np.std (ddof=0):", x.std().round(4))
print("sample  (ddof=1):", x.std(ddof=1).round(4))
print("var with ddof=1:", x.var(ddof=1))
```

> **In the wild:** `df.std()` in pandas uses `ddof=1`. If you need NumPy to agree with it, pass `ddof=1` explicitly. scikit-learn's `StandardScaler` uses `ddof=0`.

## Recap

- Aggregations (`sum`, `mean`, `std`, `min`, `max`, `prod`) collapse values; `argmin`/`argmax` return **positions**.
- **`axis` is the dimension that disappears.** Delete it from the shape to predict the result. Use a tuple to collapse several; `-1` means the last axis.
- Without `axis`, `argmax` returns a flat index; `np.unravel_index` converts it back to coordinates.
- `keepdims=True` keeps a size-1 axis so the result broadcasts back against the original.
- `cumsum`/`cumprod` keep running results (use `cumprod` for compounding); `np.diff` gives consecutive changes.
- `std` uses `ddof=0` by default; pandas uses `ddof=1`.

**Up next:** putting it all together. You'll turn slow Python loops into fast vectorized NumPy code, step by step.
