Real data arrives in pieces: one file per month, one array per sensor, one batch at a time from a data loader. And before you train a model, you cut a dataset into training, validation and test pieces. Joining and splitting arrays is everyday NumPy work, and the functions involved differ in one crucial way: **do they join along an existing axis, or create a new one?**

By the end of this lesson you'll pick the right tool among `concatenate`, `stack`, `vstack`, `hstack` and `column_stack` without guessing, split arrays cleanly, and recognize the shape errors these functions throw.

## `concatenate`: join along an existing axis

`np.concatenate` takes a **list** of arrays and glues them end to end along one axis. For 1-D arrays there's only one axis, so the result is simply longer:

```python run
import numpy as np

week1 = np.array([5, 8, 6])
week2 = np.array([7, 9])
week3 = np.array([4, 6, 8, 3])

np.concatenate([week1, week2, week3])
```

With 2-D arrays you choose the axis. `axis=0` (the default) stacks **more rows** underneath; `axis=1` adds **more columns** to the right:

```python run
a = np.array([[1, 2, 3],
              [4, 5, 6]])
b = np.array([[7, 8, 9],
              [10, 11, 12]])

print("axis=0 ->", np.concatenate([a, b], axis=0).shape)
print(np.concatenate([a, b], axis=0))
print()
print("axis=1 ->", np.concatenate([a, b], axis=1).shape)
print(np.concatenate([a, b], axis=1))
```

The rule: every array must have the **same number of dimensions**, and the **same size on every axis except the one you join along**. Adding rows of a different width fails:

```python run error
table = np.zeros((2, 3))
wide_rows = np.ones((2, 4))

np.concatenate([table, wide_rows], axis=0)
```

The message tells you exactly what went wrong: along dimension 1 (columns), one array has size 3 and the other has size 4. Joining along `axis=1` would work here, because then only the row counts must match.

```python predict id=predict-concatenate title="What does this print?"
a = np.zeros((2, 3))
b = np.ones((4, 3))
print(np.concatenate([a, b]).shape)
--- options
(6, 6)
* (6, 3)
(2, 7)
(2, 3)
--- explain
The default is `axis=0`, so the rows add up: 2 + 4 = **6** rows. The other axis (3 columns) must match, and it does, so it stays `3`: `(6, 3)`.
```

## `stack`: join along a new axis

`np.stack` works differently: all inputs must have **exactly the same shape**, and the result gains a **new** axis that indexes which input each slice came from.

```python run
red = np.full((2, 2), 255)
green = np.full((2, 2), 128)
blue = np.zeros((2, 2), dtype=int)

print("stack axis=0: ", np.stack([red, green, blue]).shape)           # (3, 2, 2) channels first
print("stack axis=-1:", np.stack([red, green, blue], axis=-1).shape)  # (2, 2, 3) channels last
print("concatenate:  ", np.concatenate([red, green, blue]).shape)    # (6, 2): no new axis
```

Use **concatenate** to make an axis *longer*. Use **stack** to make *more axes*: turning a list of same-shaped samples into a batch, or separate channels into one image.

```python predict id=predict-stack title="What does this print?"
x = np.zeros(3)
y = np.ones(3)
print(np.stack([x, y], axis=1).shape)
--- options
(2, 3)
* (3, 2)
(6,)
(3, 1, 2)
--- explain
Stacking two arrays of shape `(3,)` creates a new axis of size **2**. With `axis=1` the new axis goes *second*, giving `(3, 2)`: each row pairs `x[i]` with `y[i]`. With the default `axis=0` it would be `(2, 3)`.
```

```python debug id=stack-instead-of-concat-bug title="Two days of readings, one long series"
# Hourly readings from two consecutive days.
day1 = np.linspace(10, 20, 24)
day2 = np.linspace(20, 12, 24)

# We want ONE continuous series of 48 hourly readings.
series = np.stack([day1, day2])
print("shape:", series.shape)
print("hour 30:", series[30])
--- solution
day1 = np.linspace(10, 20, 24)
day2 = np.linspace(20, 12, 24)

series = np.concatenate([day1, day2])
print("shape:", series.shape)
print("hour 30:", series[30])
--- test
assert series.shape == (48,), f"`series` should be one 1-D series of 48 readings, but its shape is {series.shape}."
assert np.array_equal(series[:24], day1) and np.array_equal(series[24:], day2), "The series should be day1's readings followed by day2's."
--- hint
Look at the printed shape. Did joining the days make the series *longer*, or did it add a new axis?
--- hint
`np.stack` creates a new axis, giving `(2, 24)`. To extend the existing axis, use `np.concatenate`.
```

## The convenience functions: `vstack`, `hstack`, `column_stack`

These shortcuts mostly wrap `concatenate`, with special handling for 1-D inputs, which is exactly where they're most useful:

| Function | 2-D inputs | 1-D inputs of length n |
|---|---|---|
| `np.vstack` | concatenate rows (`axis=0`) | treats each as a **row** → `(k, n)` |
| `np.hstack` | concatenate columns (`axis=1`) | concatenates end to end → `(k·n,)` |
| `np.column_stack` | concatenate columns | treats each as a **column** → `(n, k)` |

```python run
heights = np.array([1.62, 1.75, 1.80])
weights = np.array([58.0, 72.5, 80.1])

print("vstack:\n", np.vstack([heights, weights]))
print("hstack:\n", np.hstack([heights, weights]))
print("column_stack:\n", np.column_stack([heights, weights]))
```

> **In the wild:** scikit-learn expects a feature matrix `X` of shape `(n_samples, n_features)`: one **row per sample**, one **column per feature**. If you have each feature as its own 1-D array, `np.column_stack` builds `X` in one call.

```python exercise id=feature-matrix title="Build a feature matrix"
# Five patients, three measurements each, stored as separate 1-D arrays.
age = np.array([34, 51, 29, 62, 45])
bmi = np.array([22.1, 27.4, 24.8, 30.2, 26.0])
heart_rate = np.array([68, 74, 80, 71, 66])

# Build `X` with one ROW per patient and one COLUMN per feature,
# in the order age, bmi, heart_rate. Shape (5, 3).
X = ...
--- solution
age = np.array([34, 51, 29, 62, 45])
bmi = np.array([22.1, 27.4, 24.8, 30.2, 26.0])
heart_rate = np.array([68, 74, 80, 71, 66])

X = np.column_stack([age, bmi, heart_rate])
--- test
assert X is not ..., "Replace the `...` with your code."
assert isinstance(X, np.ndarray), "`X` should be a NumPy array."
assert X.shape != (3, 5), "That's one row per *feature*. Models expect one row per *patient*: shape (5, 3)."
assert X.shape == (5, 3), f"`X` should have shape (5, 3), but it has {X.shape}."
assert np.allclose(X[:, 1], bmi), "Column 1 should be `bmi`. Check the order of the features."
assert np.allclose(X[3], [62, 30.2, 71]), "Row 3 should hold patient 3's age, BMI and heart rate."
--- hint
Each 1-D array should become a **column**. One of the functions in the table does exactly that.
--- hint
`np.column_stack([age, bmi, heart_rate])`, or equivalently `np.stack([...], axis=1)`.
```

Notice that `X` comes out as `float64`: one float column forces the whole array to float, because an array has a single dtype.

```python exercise id=bias-column title="Add a bias column"
# A design matrix for linear regression: 4 samples, 2 features.
X = np.array([[2.0, 3.0],
              [1.0, 5.0],
              [4.0, 1.0],
              [3.0, 2.0]])

# Linear models often prepend a column of ones (the "bias" or intercept term).
# Create `X_b` of shape (4, 3) whose FIRST column is all ones,
# followed by the two original columns. It must work for any number of rows.
X_b = ...
--- solution
X = np.array([[2.0, 3.0],
              [1.0, 5.0],
              [4.0, 1.0],
              [3.0, 2.0]])

X_b = np.hstack([np.ones((X.shape[0], 1)), X])
--- test
assert X_b is not ..., "Replace the `...` with your code."
assert isinstance(X_b, np.ndarray), "`X_b` should be a NumPy array."
assert X_b.shape == (4, 3), f"`X_b` should have shape (4, 3), but it has {X_b.shape}."
assert np.all(X_b[:, 0] == 1), "The first column of `X_b` should be all ones."
assert np.array_equal(X_b[:, 1:], X), "Columns 1 and 2 of `X_b` should be the original features, unchanged."
--- hint
Build a column of ones with shape `(number_of_rows, 1)` using `np.ones`. `X.shape[0]` gives the number of rows.
--- hint
Join it to the left of `X` along the columns: `np.hstack([ones_column, X])` or `np.concatenate([...], axis=1)`.
```

```python debug id=append-row-bug title="Adding one more row"
table = np.array([[1, 2, 3, 4],
                  [5, 6, 7, 8],
                  [9, 10, 11, 12]])
new_row = np.array([13, 14, 15, 16])

# Append `new_row` as a 4th row of the table.
table = np.concatenate([table, new_row])
print(table)
--- solution
table = np.array([[1, 2, 3, 4],
                  [5, 6, 7, 8],
                  [9, 10, 11, 12]])
new_row = np.array([13, 14, 15, 16])

table = np.concatenate([table, new_row[np.newaxis, :]])
print(table)
--- test
assert table.shape == (4, 4), f"`table` should have 4 rows of 4 values, shape (4, 4), but it is {table.shape}."
assert np.array_equal(table[-1], [13, 14, 15, 16]), "The last row should be `new_row`."
assert np.array_equal(table[:3], [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]]), "The original three rows should be unchanged."
--- hint
Read the error: the arrays have a different *number of dimensions*. What are `table.ndim` and `new_row.ndim`?
--- hint
`concatenate` needs both arrays to be 2-D. Turn `new_row` into a `(1, 4)` row with `new_row[np.newaxis, :]`, or use `np.vstack([table, new_row])`, which does that for you.
```

## Splitting arrays apart

`np.split` is the inverse of `concatenate`. Give it either a **number of equal sections** or a list of **indices to cut at**:

```python run
a = np.arange(12)

print("3 equal parts:", np.split(a, 3))
print("cut at 2 and 7:", np.split(a, [2, 7]))
```

Equal sections must divide the length exactly; `np.array_split` relaxes that, making the first pieces one element longer when needed:

```python run
a = np.arange(10)
print([p.tolist() for p in np.array_split(a, 3)])
```

For 2-D arrays, `axis=` picks the direction, and `vsplit` / `hsplit` are shortcuts for splitting rows and columns:

```python run
grid = np.arange(16).reshape(4, 4)

top, bottom = np.vsplit(grid, 2)       # split rows
left, right = np.hsplit(grid, [1])     # cut after column 0
print("top:\n", top)
print("left column shape:", left.shape, " right shape:", right.shape)
```

> **Tip:** the pieces returned by `split` are **views** into the original array, so splitting is cheap even for large data.

```python exercise id=train-val-test title="Split a dataset 70 / 15 / 15"
rng = np.random.default_rng(0)
data = rng.normal(size=(200, 4))    # 200 samples (rows), 4 features

# Split the ROWS of `data`, in order, into:
#   train: the first 70% of rows
#   val:   the next 15%
#   test:  the final 15%
# Compute the cut points from len(data); don't hard-code 140 and 170.
train, val, test = ..., ..., ...
--- solution
rng = np.random.default_rng(0)
data = rng.normal(size=(200, 4))

n = len(data)
train, val, test = np.split(data, [int(n * 0.70), int(n * 0.85)])
--- test
assert train is not ... and val is not ... and test is not ..., "Replace the three `...` placeholders."
assert all(isinstance(p, np.ndarray) for p in (train, val, test)), "`train`, `val` and `test` should be NumPy arrays."
assert train.shape == (140, 4), f"`train` should have 140 rows and 4 columns, but has shape {train.shape}."
assert val.shape == (30, 4), f"`val` should have 30 rows, but has shape {val.shape}."
assert test.shape == (30, 4), f"`test` should have 30 rows, but has shape {test.shape}."
assert np.array_equal(np.concatenate([train, val, test]), data), "Together, the three pieces should be exactly `data`, in the original order."
--- hint
`np.split(data, [i, j])` returns three pieces: rows `[:i]`, `[i:j]` and `[j:]`.
--- hint
The cut points are 70% and 85% of the number of rows: `int(len(data) * 0.70)` and `int(len(data) * 0.85)`.
```

## Repeating: `tile` and `repeat`

Two more ways to build bigger arrays from smaller ones. `np.repeat` repeats **each element**; `np.tile` repeats the **whole array**:

```python run
a = np.array([1, 2, 3])

print("repeat:", np.repeat(a, 2))        # each element twice
print("tile:  ", np.tile(a, 2))          # whole array twice
print("tile 2-D:\n", np.tile(a, (2, 2))) # 2 copies down, 2 across
```

> **Under the hood:** `tile` and `repeat` really allocate the bigger array. When you only need repetition to *combine* arrays, broadcasting (coming up soon) does the same job without copying anything.

## Recap

- `np.concatenate` joins along an **existing** axis; all other axis sizes must match.
- `np.stack` joins same-shaped arrays along a **new** axis, turning a list of samples into a batch.
- `vstack` / `hstack` / `column_stack` are shortcuts; `column_stack` turns 1-D features into the columns of a feature matrix.
- "Different number of dimensions" errors usually mean a 1-D array needs `np.newaxis` before joining.
- `np.split` (exact), `np.array_split` (uneven), `vsplit` and `hsplit` cut arrays into views.
- `repeat` duplicates elements; `tile` duplicates the whole array.

**Up next:** vectorized computation begins: universal functions and element-wise math.
