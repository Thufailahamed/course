Here's a question that trips up almost everyone: what should happen when you add an array of shape `(3, 4)` to one of shape `(4,)`? Or multiply `(5, 1)` by `(1, 3)`? In plain Python, combining a list of 12 numbers with a list of 4 makes no sense. In NumPy it's routine, and the rule that makes it work is called **broadcasting**.

Broadcasting is how NumPy *stretches* smaller arrays to match bigger ones, **without copying any data**. It lets you center a dataset in one line, build a multiplication table without loops, and compute every pairwise distance between thousands of points. It's also the source of the single most common NumPy error message. By the end of this lesson you'll be able to predict the shape of any broadcast in your head, and you'll know how to fix it when it fails.

## You already use it: scalars

The simplest broadcast is an array combined with a single number. The scalar is "stretched" to the shape of the array.

```python run
import numpy as np

prices = np.array([19.99, 5.49, 102.00, 7.25])
print("with 20% tax:", prices * 1.2)
print("minus $5:    ", prices - 5)
print("shape of prices:", prices.shape, "| shape of a scalar:", np.shape(5))
```

Conceptually, NumPy treats `5` as if it were `[5, 5, 5, 5]`. In reality it never builds that array. It reuses the same number for every element, which is why broadcasting is both fast and memory-free.

## Stretching a row across a matrix

Now something bigger. A shop chain has 3 stores selling 4 products. `units[i, j]` is how many of product `j` store `i` sold, and `price[j]` is the price of product `j`.

```python run
units = np.array([[10,  2, 0, 5],     # store 0
                  [ 3,  8, 1, 0],     # store 1
                  [ 7,  0, 4, 9]])    # store 2
price = np.array([2.50, 4.00, 10.00, 1.25])   # one price per product (column)

revenue = units * price
print("units:", units.shape, " price:", price.shape, " ->", revenue.shape)
revenue
```

`price` has shape `(4,)`, so NumPy lines it up with the **last** axis of `units` (the 4 columns) and reuses it for every row. Each column gets multiplied by its own price. You didn't write a loop, and no `(3, 4)` copy of `price` was created.

## The two rules

Broadcasting follows a short, mechanical procedure. To combine two arrays:

1. **Align the shapes from the right.** If one array has fewer dimensions, pretend it has extra size-1 dimensions on the **left**.
2. **Compare each pair of dimensions.** They're compatible if they are **equal**, or if **one of them is 1**. A size-1 dimension is stretched to match the other. The result takes the larger size in each position.

If any pair is incompatible (different sizes, neither is 1), NumPy raises an error.

```
units  (3, 4)        units  (3, 4)        a  (3, 1)         a  (3, 4)
price     (4,)       col    (3, 1)        b     (4,)        b     (3,)
       ───────              ───────             ───────            ───────
result (3, 4) ✓      result (3, 4) ✓      result (3, 4) ✓   4 vs 3 ✗ error
```

You can ask NumPy to apply the rules for you with `np.broadcast_shapes`, without creating any arrays:

```python run
print(np.broadcast_shapes((3, 4), (4,)))        # row across matrix
print(np.broadcast_shapes((3, 1), (4,)))        # column x row -> table
print(np.broadcast_shapes((5, 1, 3), (4, 1)))   # works in any number of dims
print(np.broadcast_shapes((8, 1, 6, 1), (7, 1, 5)))
```

Work through the last one with the rules: align `(8, 1, 6, 1)` and `(7, 1, 5)` from the right → `(8, 1, 6, 1)` vs `(1, 7, 1, 5)` → `(8, 7, 6, 5)`.

```python predict id=predict-table-shape title="Column meets row"
col = np.ones((3, 1))
row = np.ones(4)
print((col + row).shape)
--- options
(3, 1)
(4,)
* (3, 4)
Error: shapes don't match
--- explain
Align from the right: `(3, 1)` vs `(4,)` becomes `(3, 1)` vs `(1, 4)`. In each position one of the sizes is 1, so both get stretched: the column is copied across 4 columns and the row is copied down 3 rows. The result is a full `(3, 4)` table.
```

```python predict id=predict-incompatible title="Will this broadcast?"
grades = np.zeros((2, 3))     # 2 students x 3 subjects
curve = np.zeros(2)           # one curve per student
try:
    print((grades + curve).shape)
except ValueError:
    print("ValueError")
--- options
(2, 3)
* ValueError
(2, 2)
(3, 2)
--- explain
Align from the right: `(2, 3)` vs `(2,)` compares **3 with 2**. They aren't equal and neither is 1, so NumPy raises. NumPy never guesses which axis you meant; it only ever pads on the **left**.
```

## When it fails: reading the error

Here's the error you'll see most in your NumPy career. Run it and read it carefully:

```python run error
scores = np.ones((3, 4))           # 3 students x 4 exams
bonus = np.array([1.0, 2.0, 0.5])  # one bonus per student
scores + bonus
```

`operands could not be broadcast together with shapes (3,4) (3,)` tells you exactly what happened. Aligning from the right puts `bonus`'s 3 against the **4 exams**, not the 3 students. 4 vs. 3: incompatible.

The bonus is *per student*, meaning per **row**, so it needs to run down axis 0. We need shape `(3, 1)`: a **column vector**.

## Column vectors: [:, None]

There are three common ways to turn a 1-D array of shape `(n,)` into a column of shape `(n, 1)`. They're all equivalent:

```python run
bonus = np.array([1.0, 2.0, 0.5])

print(bonus[:, None].shape)         # index with None: insert a new axis
print(bonus[:, np.newaxis].shape)   # np.newaxis is literally None
print(bonus.reshape(-1, 1).shape)   # reshape to "as many rows as needed, 1 column"

scores = np.ones((3, 4))
scores + bonus[:, None]
```

Now `(3, 4)` vs `(3, 1)` aligns the 3 with the 3 students, and the bonus is stretched across all 4 exams. Read `bonus[:, None]` as "keep all the existing data along the first axis, and add a new axis of length 1 after it".

> **Tip:** when you think "one value per **row**", you want shape `(n, 1)`. When you think "one value per **column**", shape `(m,)` (or `(1, m)`) already works.

## Outer operations: tables without loops

Combine a column with a row and you get every combination: an "outer" operation. This is one of the most useful patterns in NumPy.

```python run
base_price = np.array([10.0, 25.0, 40.0])        # 3 products
discount = np.array([0.0, 0.1, 0.25, 0.5])       # 4 discount levels

# rows = products, columns = discounts
table = base_price[:, None] * (1 - discount)
print(table.shape)
table
```

```python exercise id=times-table title="Build a times table"
# TODO: build `table`, a (9, 9) array where table[i, j] == (i + 1) * (j + 1),
# i.e. the classic times table from 1x1 up to 9x9.
# Use broadcasting: no loops, and no np.outer.
n = np.arange(1, 10)

table = ...
--- solution
n = np.arange(1, 10)

table = n[:, None] * n
--- test
assert table is not ..., "Replace the `...` after `table =` with your code."
assert isinstance(table, np.ndarray), "`table` should be a NumPy array."
assert table.shape == (9, 9), f"`table` should have shape (9, 9) but has {table.shape}. Turn one copy of `n` into a column with n[:, None]."
expected = np.arange(1, 10).reshape(9, 1) * np.arange(1, 10).reshape(1, 9)
assert np.array_equal(table, expected), f"table[i, j] should equal (i + 1) * (j + 1). For example table[2, 3] should be 12, but it is {table[2, 3]}."
--- hint
You need one copy of `n` running down the rows (shape `(9, 1)`) and one running across the columns (shape `(9,)`).
--- hint
`n[:, None]` is a column. Multiply it by `n`.
```

## The silent trap: (n,) vs (n, 1)

The broadcasting error is annoying, but at least it's loud. The **real** danger is when shapes happen to be compatible in the wrong way. Then you get no error, just wrong numbers.

The classic case is a **square** matrix. Suppose you want to subtract each **row's** mean from that row. `X.mean(axis=1)` computes one mean per row; you'll study the `axis` argument in depth next lesson.

```python run
X = np.array([[1.0, 2.0, 3.0],
              [10.0, 20.0, 30.0],
              [100.0, 200.0, 300.0]])

row_means = X.mean(axis=1)          # shape (3,): [2, 20, 200]
wrong = X - row_means               # (3,3) - (3,): aligned with COLUMNS!
right = X - row_means[:, None]      # (3,3) - (3,1): aligned with ROWS

print("row means:", row_means)
print("wrong (no error!):\n", wrong)
print("right:\n", right)
```

Because the matrix is 3×3, `(3,)` lines up with the columns perfectly well, so NumPy has no reason to complain. It subtracts 2 from column 0, 20 from column 1 and 200 from column 2. With a non-square matrix the same bug would have raised an error. Square matrices hide it.

> **Pitfall:** whenever you combine a 1-D array with a 2-D one, ask yourself "is this per row or per column?" If it's per row, you need `[:, None]`. Testing your code on a **non-square** example is a cheap way to surface these bugs.

```python debug id=center-rows title="Rows that won't center"
# Each row is one user's ratings of 3 movies. We want to remove each user's
# personal bias: subtract each user's average rating from their own ratings,
# so every row ends up averaging 0.
ratings = np.array([[5.0, 4.0, 3.0],
                    [2.0, 1.0, 3.0],
                    [4.0, 4.0, 1.0]])

user_avg = ratings.mean(axis=1)
centered = ratings - user_avg

print("row averages after centering:", centered.mean(axis=1).round(3))
--- solution
ratings = np.array([[5.0, 4.0, 3.0],
                    [2.0, 1.0, 3.0],
                    [4.0, 4.0, 1.0]])

user_avg = ratings.mean(axis=1)
centered = ratings - user_avg[:, None]

print("row averages after centering:", centered.mean(axis=1).round(3))
--- test
assert centered.shape == (3, 3), f"`centered` should keep the shape (3, 3), but has {centered.shape}."
assert np.allclose(centered.mean(axis=1), 0), f"Each row of `centered` should average 0, but the row averages are {centered.mean(axis=1).round(3)}. Is each user's average being subtracted from the right row?"
assert np.allclose(centered, ratings - ratings.mean(axis=1, keepdims=True)), "Subtract each user's own average from every rating in that user's row."
--- hint
Run it. The row averages are not 0, and there's no error. The shapes are `(3, 3)` and `(3,)`: which axis does the `(3,)` get lined up with?
--- hint
`user_avg` holds one value per **row**, so it needs shape `(3, 1)` to broadcast down the rows. Try `user_avg[:, None]`.
```

## Standardizing columns: the data-science classic

In machine learning you almost always **standardize** features before training: subtract each column's mean and divide by each column's standard deviation, so every feature has mean 0 and std 1. With broadcasting it's a single line, because "per column" statistics have shape `(n_features,)` and line up with the last axis automatically.

```python run
rng = np.random.default_rng(0)
# 6 houses x 3 features: size (m²), bedrooms, age (years)
X = np.column_stack([rng.normal(120, 30, 6), rng.integers(1, 6, 6), rng.normal(25, 10, 6)])

mu = X.mean(axis=0)       # shape (3,): one mean per column
sigma = X.std(axis=0)     # shape (3,): one std per column
Z = (X - mu) / sigma      # (6,3) with (3,): aligned with columns

print("means:", Z.mean(axis=0).round(6))
print("stds: ", Z.std(axis=0).round(6))
```

```python exercise id=min-max-scale title="Min-max scale every feature"
# Each row is a patient; columns are heart rate, temperature, and age.
X = np.array([[72.0, 36.6, 34.0],
              [88.0, 38.1, 61.0],
              [64.0, 36.9, 19.0],
              [95.0, 37.4, 45.0]])

# TODO: min-max scale each COLUMN so its smallest value becomes 0 and its
# largest becomes 1:   (x - column_min) / (column_max - column_min)
# Use broadcasting; X.min(axis=0) gives one minimum per column.
scaled = ...
--- solution
X = np.array([[72.0, 36.6, 34.0],
              [88.0, 38.1, 61.0],
              [64.0, 36.9, 19.0],
              [95.0, 37.4, 45.0]])

col_min = X.min(axis=0)
col_max = X.max(axis=0)
scaled = (X - col_min) / (col_max - col_min)
--- test
assert scaled is not ..., "Replace the `...` after `scaled =` with your code."
assert isinstance(scaled, np.ndarray), "`scaled` should be a NumPy array."
assert scaled.shape == X.shape, f"`scaled` should have the same shape as X {X.shape}, but has {scaled.shape}."
assert np.allclose(scaled.min(axis=0), 0), f"Every column's minimum should become 0, but the column minimums are {scaled.min(axis=0).round(3)}. Are you scaling per column (axis=0)?"
assert np.allclose(scaled.max(axis=0), 1), f"Every column's maximum should become 1, but the column maximums are {scaled.max(axis=0).round(3)}."
expected = (X - X.min(axis=0)) / (X.max(axis=0) - X.min(axis=0))
assert np.allclose(scaled, expected), "The relative spacing within each column should be preserved: use (x - min) / (max - min)."
--- hint
Compute `X.min(axis=0)` and `X.max(axis=0)`. Each has shape `(3,)`, one value per column, which already lines up with the last axis of `X`.
--- hint
`scaled = (X - col_min) / (col_max - col_min)`, with both statistics computed using `axis=0`.
```

## keepdims: broadcasting-friendly statistics

You saw that per-row statistics need `[:, None]` before you can broadcast them back. Reductions can do that for you: pass `keepdims=True` and the reduced axis is kept with length 1.

```python run
counts = np.array([[3, 1, 6],
                   [0, 4, 4],
                   [5, 5, 0],
                   [2, 2, 6]])

print(counts.sum(axis=1).shape)                  # (4,)   can't divide (4,3) by this
print(counts.sum(axis=1, keepdims=True).shape)   # (4, 1) broadcasts down the rows

shares = counts / counts.sum(axis=1, keepdims=True)
print(shares.round(2))
print("each row sums to:", shares.sum(axis=1))
```

```python debug id=row-proportions title="Turn counts into row percentages"
# Website visits: rows = 4 days, columns = 3 traffic sources.
visits = np.array([[120,  30, 50],
                   [ 80,  60, 60],
                   [200, 100, 100],
                   [ 50,  25, 25]])

# Goal: percentage of each day's traffic coming from each source.
pct = visits / visits.sum(axis=1) * 100
print(pct.round(1))
--- solution
visits = np.array([[120,  30, 50],
                   [ 80,  60, 60],
                   [200, 100, 100],
                   [ 50,  25, 25]])

pct = visits / visits.sum(axis=1, keepdims=True) * 100
print(pct.round(1))
--- test
assert pct.shape == (4, 3), f"`pct` should have shape (4, 3), one percentage per day and source, but has {pct.shape}."
assert np.allclose(pct.sum(axis=1), 100), f"Each day's percentages should add up to 100, but they add up to {pct.sum(axis=1).round(1)}."
assert np.allclose(pct[0], [60, 15, 25]), f"Day 0 should be [60, 15, 25] percent, got {pct[0].round(1)}."
--- hint
Run it and read the error message. Which two shapes are being combined?
--- hint
`visits.sum(axis=1)` has shape `(4,)`, which gets aligned with the 3 columns. Keep the summed axis with `keepdims=True` (or add `[:, None]`) so it has shape `(4, 1)`.
```

## Pairwise distances: broadcasting in 3-D

Here's where broadcasting really shines. Given `n` points in 2-D, compute the distance between **every pair**. With loops, that's a double `for` over `n²` pairs. With broadcasting, it's three lines.

The trick: turn the `(n, 2)` array of points into two views, one of shape `(n, 1, 2)` and one of shape `(1, n, 2)`. Subtracting them broadcasts to `(n, n, 2)`, every point minus every other point.

```python run
points = np.array([[0.0, 0.0],
                   [3.0, 4.0],
                   [6.0, 8.0],
                   [0.0, 5.0]])

diff = points[:, None, :] - points[None, :, :]   # (4,1,2) - (1,4,2) -> (4,4,2)
dist = np.sqrt((diff ** 2).sum(axis=-1))          # sum over the x/y axis -> (4,4)

print("diff shape:", diff.shape)
print(dist.round(2))
```

Read `dist[i, j]` as "distance from point `i` to point `j`". The diagonal is 0 (every point is 0 away from itself), and the matrix is symmetric. This exact pattern powers k-nearest neighbors, clustering (you'll use it in the k-means project), and attention in Transformers.

```python exercise id=nearest-store title="Find each customer's nearest store"
customers = np.array([[1.0, 1.0],
                      [9.0, 8.0],
                      [4.0, 6.0],
                      [8.0, 1.0],
                      [0.0, 9.0]])          # 5 customers (x, y)
stores = np.array([[0.0, 0.0],
                   [10.0, 10.0],
                   [5.0, 5.0]])             # 3 stores (x, y)

# TODO 1: `dist` must be a (5, 3) array where dist[i, j] is the straight-line
#         distance from customer i to store j. Use broadcasting, no loops.
dist = ...

# TODO 2: `nearest` = for each customer, the index (0, 1 or 2) of the closest store.
#         Hint: np.argmin(..., axis=1) returns the position of the smallest value in each row.
nearest = ...
--- solution
customers = np.array([[1.0, 1.0],
                      [9.0, 8.0],
                      [4.0, 6.0],
                      [8.0, 1.0],
                      [0.0, 9.0]])
stores = np.array([[0.0, 0.0],
                   [10.0, 10.0],
                   [5.0, 5.0]])

diff = customers[:, None, :] - stores[None, :, :]
dist = np.sqrt((diff ** 2).sum(axis=-1))
nearest = np.argmin(dist, axis=1)
--- test
assert dist is not ..., "Replace the `...` after `dist =` with your code."
assert nearest is not ..., "Replace the `...` after `nearest =` with your code."
assert isinstance(dist, np.ndarray), "`dist` should be a NumPy array."
assert dist.shape == (5, 3), f"`dist` should have shape (5, 3), one row per customer and one column per store, but has {dist.shape}. Try customers[:, None, :] - stores[None, :, :]."
expected = np.sqrt(((customers[:, None, :] - stores[None, :, :]) ** 2).sum(axis=-1))
assert np.allclose(dist, expected), f"dist[i, j] should be the Euclidean distance. For customer 0 and store 2 that's {expected[0, 2]:.3f}, but you have {dist[0, 2]:.3f}."
nearest = np.asarray(nearest)
assert nearest.shape == (5,), f"`nearest` should have one store index per customer (shape (5,)), but has shape {nearest.shape}. Did you use axis=1?"
assert np.array_equal(nearest, [0, 1, 2, 2, 2]), f"`nearest` should be [0, 1, 2, 2, 2], but is {nearest}."
--- hint
Give `customers` a store axis and `stores` a customer axis: `customers[:, None, :]` has shape `(5, 1, 2)` and `stores[None, :, :]` has shape `(1, 3, 2)`.
--- hint
Subtract them to get shape `(5, 3, 2)`, square, sum over the last axis (`axis=-1`) and take `np.sqrt`. Then `np.argmin(dist, axis=1)`.
```

```python debug id=distance-shape title="A distance matrix with the wrong shape"
# Distances between every pair of 4 sensors on a line (positions in km).
positions = np.array([0.0, 2.5, 7.0, 10.0])

pairwise = np.abs(positions - positions)
print("shape:", pairwise.shape)
print(pairwise)
--- solution
positions = np.array([0.0, 2.5, 7.0, 10.0])

pairwise = np.abs(positions[:, None] - positions)
print("shape:", pairwise.shape)
print(pairwise)
--- test
assert pairwise.shape == (4, 4), f"`pairwise` should be a (4, 4) matrix, one entry per pair of sensors, but has shape {pairwise.shape}."
assert np.allclose(pairwise, np.abs(positions.reshape(-1, 1) - positions.reshape(1, -1))), "pairwise[i, j] should be |positions[i] - positions[j]|."
assert pairwise[0, 3] == 10.0, f"Sensors 0 and 3 are 10 km apart, but pairwise[0, 3] is {pairwise[0, 3]}."
--- hint
Run it. Subtracting an array from itself element by element always gives zeros. You want *every* position against *every other* position.
--- hint
Make one side a column: `positions[:, None] - positions` broadcasts `(4, 1)` against `(4,)` into a `(4, 4)` table.
```

## Under the hood: stretching without copying

How can NumPy stretch an array without copying it? With **strides**. A stride is how many bytes to jump to reach the next element along an axis. A broadcast dimension simply gets a stride of **0**: stepping along it keeps reading the same memory.

`np.broadcast_to` makes this visible:

```python run
row = np.array([1, 2, 3], dtype=np.int64)
big = np.broadcast_to(row, (1000, 3))

print("shape:", big.shape)
print("strides (bytes):", big.strides)     # (0, 8): moving down a row moves 0 bytes!
print("shares memory with row?", np.shares_memory(big, row))
print("writeable?", big.flags.writeable)
big[:2]
```

The "1000 × 3" array costs exactly as much memory as the original 3 numbers. It's also **read-only**: since every row is the same memory, writing to one would change them all. Call `.copy()` if you need an independent, writable array.

> **In the wild:** PyTorch and JAX use exactly the same broadcasting rules, so everything in this lesson transfers directly to deep learning code. In pandas, `df - df.mean()` broadcasts per column by aligning labels instead of positions.

## Recap

- Broadcasting combines arrays of different shapes by **stretching size-1 (or missing) dimensions**, with no copying.
- Rules: **align shapes from the right**; each pair of dimensions must be **equal or include a 1**.
- One value **per row** means shape `(n, 1)`: use `[:, None]`, `reshape(-1, 1)` or `keepdims=True`.
- Square matrices can hide bugs: `(n,)` silently lines up with the **columns**. Test on non-square data.
- Column ⊗ row gives an outer table. `a[:, None, :] - b[None, :, :]` gives every pairwise difference.
- Use `np.broadcast_shapes` to check shapes, and read "could not be broadcast" errors right to left.

**Up next:** aggregations and the `axis` argument, so you'll know exactly which way `sum`, `mean` and `argmax` collapse your data.
