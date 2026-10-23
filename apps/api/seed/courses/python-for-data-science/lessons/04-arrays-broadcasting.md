# Arrays and broadcasting

A pandas column is built on a NumPy array, and a DataFrame is a collection of them. If you can picture an array's **shape** and predict what happens when two shapes meet, pandas becomes much less mysterious — and a whole class of silent bugs disappears.

This lesson uses a small shop: three stores, four products, a price per product. You'll index the grid, reduce it along each axis, and multiply every store by every price without writing a single loop.

## An array has a shape

```python run
import numpy as np

# rows = stores, columns = products
units = np.array([
    [10, 2, 0, 5],
    [3, 8, 1, 0],
    [7, 0, 4, 9],
])

print(units)
print("shape:", units.shape, "| ndim:", units.ndim, "| dtype:", units.dtype)
print("stores:", units.shape[0], "| products:", units.shape[1])
```

`shape` is a tuple, one number per axis. A 2-D array has rows then columns. `dtype` is the type shared by every element; here they are all integers, so NumPy chose a compact integer type.

> **Under the hood:** NumPy stores the values in one contiguous block plus a small amount of metadata (shape, strides, dtype). That is why operations over a million numbers can be fast: the loop happens in compiled code, not Python.

## Index and slice

Square brackets take one index per axis. A colon means "all of this axis". Negative indices count from the end.

```python run
print("store 0, product 2:", units[0, 2])
print("all stores, product 1:", units[:, 1])
print("store 1, all products:", units[1, :])
print("last row, last two products:", units[-1, -2:])
```

Boolean masks select by condition instead of position:

```python run
mask = units >= 5
print(mask)
print("values >= 5:", units[mask])
print("how many:", mask.sum())
```

`units >= 5` produces an array of `True`/`False` with the same shape. Using it as an index returns only the matching values, flattened into one dimension.

## Reduce along an axis

An aggregation removes an axis. `axis=1` collapses the columns and leaves one value per **row**; `axis=0` collapses the rows and leaves one value per **column**. The phrase to remember is *the axis you reduce disappears*.

```python run
print("units per store:", units.sum(axis=1))
print("units per product:", units.sum(axis=0))
print("mean units per product:", units.mean(axis=0).round(2))
```

The result of `units.sum(axis=1)` has shape `(3,)`: one total for each of the three stores. `axis=0` gives shape `(4,)`: one total for each product. If you are ever unsure, check the shape of the result.

## Broadcasting: different shapes, one operation

A price array with one value per product has shape `(4,)`. NumPy lines it up with the **last** axis of `units`, which is also length 4, and reuses the price for every store.

```python run
prices = np.array([2.50, 4.00, 10.00, 1.25])
revenue = units * prices

print("units:", units.shape, "| prices:", prices.shape, "-> revenue:", revenue.shape)
print(revenue)
```

No loop, no copied price matrix in your source. NumPy conceptually stretches `prices` down the rows. The rule is mechanical: align shapes from the right; dimensions are compatible when they are equal or one of them is 1.

A column vector is how you broadcast **per row**. `units.sum(axis=1)` has shape `(3,)`, but to divide each row by its own total you need shape `(3, 1)`.

```python run
row_totals = units.sum(axis=1, keepdims=True)
share = units / row_totals

print("row totals:", row_totals.shape)
print(share.round(2))
print("each row sums to:", share.sum(axis=1))
```

`keepdims=True` preserves the reduced axis as length 1, which is exactly the shape broadcasting needs. Without it, `(3, 4) / (3,)` raises because the lengths do not line up — but in a square matrix such as `(3, 3) / (3,)` the same mistake would silently divide across the wrong axis.

> **Pitfall:** A square matrix hides the `(n,)` vs `(n, 1)` bug. Always test a non-square example. If the shapes are compatible by accident, NumPy will happily return wrong numbers.

## Your turn: standardize exam scores

Standardizing means subtracting each **exam's** mean and dividing by that exam's standard deviation. Do it per column, so every exam ends with mean 0 and standard deviation 1.

```python exercise id=normalize-exams title="Standardize each exam"
import numpy as np

# rows = students, columns = exams
scores = np.array([
    [72.0, 85.0, 91.0],
    [88.0, 79.0, 94.0],
    [95.0, 92.0, 89.0],
    [61.0, 70.0, 78.0],
])

# TODO: compute one mean and std per exam (axis=0), then standardize.
exam_means = ...
exam_stds = ...
z = ...
--- solution
import numpy as np

scores = np.array([
    [72.0, 85.0, 91.0],
    [88.0, 79.0, 94.0],
    [95.0, 92.0, 89.0],
    [61.0, 70.0, 78.0],
])

exam_means = scores.mean(axis=0)
exam_stds = scores.std(axis=0)
z = (scores - exam_means) / exam_stds
--- test
assert exam_means is not ..., "Replace the `...` after `exam_means =`."
assert exam_means.shape == (3,), f"`exam_means` should have one value per exam, shape (3,), but has {exam_means.shape}."
assert np.allclose(exam_means, scores.mean(axis=0)), "Compute the mean down each column (axis=0), not across each student."
assert np.allclose(exam_stds, scores.std(axis=0)), "Compute the standard deviation down each column (axis=0)."
assert z.shape == scores.shape, f"`z` should keep the shape of `scores` (4, 3), but has {z.shape}."
assert np.allclose(z.mean(axis=0), 0), f"Each standardized exam should have mean 0, but the means are {z.mean(axis=0).round(3)}."
assert np.allclose(z.std(axis=0), 1), "Each standardized exam should have standard deviation 1."
--- hint
`axis=0` reduces the student axis and leaves one value per exam.
--- hint
Subtract `exam_means` from `scores`, then divide by `exam_stds`. Shapes `(4, 3) - (3,)` align on the last axis, which is exactly what you want here.
```

## Your turn: a price table

You have three base prices and four discount rates. Build a `(3, 4)` table where row `i`, column `j` is base price `i` after discount `j`. Use broadcasting, not loops.

```python exercise id=discount-table title="Every price at every discount"
import numpy as np

base = np.array([[10.0], [25.0], [40.0]])   # 3 products, one price each
discounts = np.array([0.0, 0.1, 0.25, 0.5])  # 4 discount rates

# TODO: use broadcasting to build a (3, 4) table.
price_table = ...
--- solution
import numpy as np

base = np.array([[10.0], [25.0], [40.0]])
discounts = np.array([0.0, 0.1, 0.25, 0.5])

price_table = base * (1 - discounts)
--- test
assert price_table is not ..., "Replace the `...` after `price_table =`."
assert price_table.shape == (3, 4), f"`price_table` should have shape (3, 4), but has {price_table.shape}."
expected = np.array([
    [10.0, 9.0, 7.5, 5.0],
    [25.0, 22.5, 18.75, 12.5],
    [40.0, 36.0, 30.0, 20.0],
])
assert np.allclose(price_table, expected), "Each row should be one product at all four discounts. Check the broadcasting direction."
--- hint
`base` has shape `(3, 1)` and `discounts` has shape `(4,)`. Align them from the right to get `(3, 4)`.
--- hint
Compute the fraction paid first: `1 - discounts` has shape `(4,)`. Multiply the column of prices by that row of fractions.
```

## The bug that hides in a square

Each row is one user's ratings of three movies. We want to subtract each user's own average from their ratings, so every row ends up averaging zero.

```python debug id=center-rows title="Rows that won't center"
import numpy as np

ratings = np.array([
    [5.0, 4.0, 3.0],
    [2.0, 1.0, 3.0],
    [4.0, 4.0, 1.0],
])

user_avg = ratings.mean(axis=1)
centered = ratings - user_avg

print("row sums:", centered.sum(axis=1).round(2))
--- solution
import numpy as np

ratings = np.array([
    [5.0, 4.0, 3.0],
    [2.0, 1.0, 3.0],
    [4.0, 4.0, 1.0],
])

user_avg = ratings.mean(axis=1)
centered = ratings - user_avg[:, None]

print("row sums:", centered.sum(axis=1).round(2))
--- test
assert centered.shape == (3, 3), f"`centered` should keep the shape (3, 3), but has {centered.shape}."
assert np.allclose(centered.mean(axis=1), 0), f"Each row should average 0, but the row averages are {centered.mean(axis=1).round(3)}. Are you subtracting each user's average from their own row?"
assert np.allclose(centered, ratings - ratings.mean(axis=1, keepdims=True)), "Subtract each user's mean from every rating in that user's row."
--- hint
Run it. There is no error, but the rows do not sum to zero. What shape is `user_avg`?
--- hint
`user_avg` is `(3,)`; broadcasting aligns it with the columns. Make it a column with `user_avg[:, None]` (or use `keepdims=True` when computing it).
```

## Predict the broadcast

```python predict id=predict-broadcast-shape title="Column meets row"
import numpy as np

print((np.ones((3, 1)) + np.ones(4)).shape)
--- options
(3, 1)
(4,)
* (3, 4)
Error: shapes don't match
--- explain
Align from the right: `(3, 1)` becomes a column and `(4,)` a row. Since each pair has a 1, both stretch, producing a full `(3, 4)` table.
```

## Predict the reduction

```python predict id=predict-axis-sum title="Which axis disappears?"
import numpy as np

print(np.arange(6).reshape(2, 3).sum(axis=0))
--- options
[0 1 2]
* [3 5 7]
[3 12]
15
--- explain
The array is `[[0, 1, 2], [3, 4, 5]]`. `axis=0` collapses the rows, adding down each column: `[0+3, 1+4, 2+5]` = `[3, 5, 7]`. The result has shape `(3,)`.
```

## Recap

- `shape` is one number per axis; `axis=0` reduces rows and `axis=1` reduces columns.
- Boolean masks select by condition and return a flat array of matches.
- Broadcasting aligns shapes from the right; dimensions are compatible when equal or one is 1.
- `keepdims=True` and `[:, None]` turn a reduced axis back into a column for per-row arithmetic.
- Square shapes can hide a wrong-axis broadcast. Test a non-square case.

**Up next:** you'll turn these array moves into fast, readable transformations and replace the last loops in your data pipeline.
