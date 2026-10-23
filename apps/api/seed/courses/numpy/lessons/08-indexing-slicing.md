Almost every line of real NumPy code reaches *into* an array: the last 30 days of prices, the first three channels of an image, every other row of a dataset. Indexing and slicing are how you say "this part, please". Once you're fluent, you'll replace whole loops with a single bracket expression.

In this lesson you'll learn to pick out single elements, ranges, strided samples and sub-grids from arrays of any dimension, and you'll learn the one rule that trips up nearly everyone: **an integer index removes a dimension; a slice keeps it.**

## Indexing in one dimension

A 1-D array is indexed exactly like a Python list. Positions start at `0`, and **negative indices count from the end**: `-1` is the last element, `-2` the one before it.

```python run
import numpy as np

prices = np.array([101.5, 102.0, 99.8, 103.2, 104.9, 104.1, 106.3])

print("first:", prices[0])
print("third:", prices[2])
print("last:", prices[-1])
print("second to last:", prices[-2])
```

Indexing past the end raises an `IndexError`. Valid indices for an array of length `n` run from `0` to `n - 1`, or from `-n` to `-1`.

```python run error
prices[7]
```

## Slicing: `start:stop:step`

A **slice** selects a range. `a[start:stop]` includes `start` but **excludes** `stop`, so `a[2:5]` gives you exactly `5 - 2 = 3` elements. Any part can be omitted:

| Slice | Meaning |
|---|---|
| `a[:3]` | the first 3 elements |
| `a[3:]` | everything from index 3 on |
| `a[-3:]` | the last 3 elements |
| `a[::2]` | every second element |
| `a[1::2]` | every second element, starting at index 1 |
| `a[::-1]` | the whole array, reversed |

```python run
days = np.arange(10)          # 0, 1, ..., 9

print("first three:   ", days[:3])
print("index 2 to 5:  ", days[2:5])
print("last three:    ", days[-3:])
print("evens:         ", days[::2])
print("odds:          ", days[1::2])
print("reversed:      ", days[::-1])
```

> **Tip:** The half-open convention makes sizes easy: `a[:k]` and `a[k:]` split an array into two pieces with no overlap and nothing missing. That's exactly what you want for train/test splits.

```python predict id=predict-slice title="What does this print?"
a = np.arange(10, 20)
print(a[2:8:3])
--- options
[12 15 18]
* [12 15]
[13 16]
[12 14 16]
--- explain
`np.arange(10, 20)` is `[10, 11, ..., 19]`. Start at index 2 (value `12`), step by 3 to index 5 (value `15`). The next index would be 8, but `stop` is **excluded**, so the slice ends there.
```

```python exercise id=slice-week title="Slice a week of readings"
# 14 days of step counts, oldest first
steps = np.array([4200, 8100, 7600, 10200, 6300, 12000, 9800,
                  5100, 7700, 11300, 8800, 6900, 13100, 9400])

# TODO: use slicing (no loops, no np.array([...]) by hand)
first_week = ...      # the first 7 days
last_three = ...      # the final 3 days
every_other = ...     # days 0, 2, 4, ... (every second day)
newest_first = ...    # all 14 days, most recent first
--- solution
steps = np.array([4200, 8100, 7600, 10200, 6300, 12000, 9800,
                  5100, 7700, 11300, 8800, 6900, 13100, 9400])

first_week = steps[:7]
last_three = steps[-3:]
every_other = steps[::2]
newest_first = steps[::-1]
--- test
for name, val in [("first_week", first_week), ("last_three", last_three), ("every_other", every_other), ("newest_first", newest_first)]:
    assert val is not ..., f"Replace the `...` after `{name} =` with a slice of `steps`."
    assert isinstance(val, np.ndarray), f"`{name}` should be a NumPy array (a slice of `steps`), not {type(val).__name__}."
assert first_week.shape == (7,), f"`first_week` should hold 7 days but has shape {first_week.shape}."
assert np.array_equal(first_week, steps[:7]), "`first_week` should be the first 7 values of `steps`."
assert last_three.shape == (3,), f"`last_three` should hold 3 days but has shape {last_three.shape}."
assert np.array_equal(last_three, [6900, 13100, 9400]), "`last_three` should be the final 3 values, in their original order. Negative start indices help here."
assert np.array_equal(every_other, steps[0::2]), "`every_other` should start at day 0 and take every second day."
assert np.array_equal(newest_first, steps[::-1]), "`newest_first` should contain all 14 values in reverse order."
--- hint
A slice is `start:stop:step`, and any part can be left out.
--- hint
Negative indices count from the end, so `-3` is "three from the end". A negative step walks backwards.
--- hint
You'll need `[:7]`, a slice starting at `-3`, a step of `2`, and a step of `-1`.
```

## Two dimensions: rows first, then columns

A 2-D array is a grid. You index it with **one index per axis, separated by a comma**: `grid[row, col]`. Axis 0 runs down the rows, axis 1 runs across the columns.

```python run
grid = np.arange(1, 13).reshape(3, 4)
print(grid)
print()
print("row 1, col 2:", grid[1, 2])
print("bottom-right:", grid[-1, -1])
```

You may also see `grid[1][2]`. It gives the same answer, but it works in two steps: `grid[1]` builds the whole row first, then `[2]` indexes into it. `grid[1, 2]` is a single, faster operation, and with slices the two forms can mean completely different things, as you'll see in a moment. **Always use the comma form.**

### Rows, columns and sub-grids

Put a slice in any position. A bare `:` means "everything along this axis".

```python run
grid = np.arange(1, 13).reshape(3, 4)

print("row 0:        ", grid[0, :])     # same as grid[0]
print("column 2:     ", grid[:, 2])
print("top-left 2x2:\n", grid[:2, :2])
print("every other column:\n", grid[:, ::2])
```

> **Pitfall:** `grid[:, 2]` is column 2, but `grid[:][2]` is **row 2**. `grid[:]` is the whole grid, and the second `[2]` then picks a row. This is the classic reason to avoid chained brackets.

```python predict id=predict-chained title="Chained brackets vs. a comma"
grid = np.arange(1, 13).reshape(3, 4)
print(grid[:][1], grid[:, 1])
--- options
[2 6 10] [2 6 10]
* [5 6 7 8] [ 2  6 10]
[5 6 7 8] [5 6 7 8]
[ 2  6 10] [5 6 7 8]
--- explain
`grid[:]` is just the whole grid, so `grid[:][1]` selects **row** 1: `[5 6 7 8]`. The comma form `grid[:, 1]` means "every row, column 1": `[ 2  6 10]`. NumPy pads `2` and `6` so every value has the same width as `10`.
```

## Integer index vs. slice: the dimension rule

Here's the rule that explains most surprises in NumPy indexing:

- An **integer** index *selects one position* and **removes** that axis.
- A **slice** *selects a range* (even a range of length 1) and **keeps** the axis.

```python run
grid = np.arange(1, 13).reshape(3, 4)

row_int = grid[1]       # integer -> axis removed
row_slice = grid[1:2]   # slice   -> axis kept

print(row_int, "shape:", row_int.shape)
print(row_slice, "shape:", row_slice.shape)
print("column as 1-D:", grid[:, 0].shape, " column as 2-D:", grid[:, 0:1].shape)
```

Both contain the same numbers, but `(4,)` and `(1, 4)` behave differently in arithmetic and matrix multiplication. When a function expects a 2-D input, such as a single sample for a scikit-learn model, the slice form keeps your data the right shape.

> **In the wild:** `model.predict(X[0])` often errors with "Expected 2D array, got 1D array". `model.predict(X[0:1])` passes a batch of one sample, with shape `(1, n_features)`, and just works.

```python exercise id=grid-select title="Carve up a sales table"
# Rows = 4 stores, columns = 6 months (Jan..Jun)
sales = np.array([[12, 15, 14, 18, 21, 25],
                  [ 8,  9, 11, 10, 13, 12],
                  [20, 22, 19, 24, 26, 30],
                  [ 5,  7,  6,  9,  8, 11]])

# TODO: use a single indexing expression for each
store2 = ...        # every month for store 2 (third row), as a 1-D array
march = ...         # every store's March figures (column 2), as a 1-D array
q2 = ...            # all stores, months Apr..Jun (last 3 columns), 2-D
top_left = ...      # first 2 stores x first 2 months, shape (2, 2)
store0_2d = ...     # store 0's row, but KEEP it 2-D: shape (1, 6)
--- solution
sales = np.array([[12, 15, 14, 18, 21, 25],
                  [ 8,  9, 11, 10, 13, 12],
                  [20, 22, 19, 24, 26, 30],
                  [ 5,  7,  6,  9,  8, 11]])

store2 = sales[2]
march = sales[:, 2]
q2 = sales[:, 3:]
top_left = sales[:2, :2]
store0_2d = sales[0:1]
--- test
names = ["store2", "march", "q2", "top_left", "store0_2d"]
for n in names:
    assert globals()[n] is not ..., f"Replace the `...` after `{n} =` with an indexing expression on `sales`."
    assert isinstance(globals()[n], np.ndarray), f"`{n}` should be a NumPy array taken from `sales`."
assert store2.shape == (6,), f"`store2` should be 1-D with 6 months, but has shape {store2.shape}. An integer index drops the row axis."
assert np.array_equal(store2, [20, 22, 19, 24, 26, 30]), "`store2` should be the third row (index 2)."
assert march.shape == (4,), f"`march` should have one value per store, shape (4,), but has {march.shape}."
assert np.array_equal(march, [14, 11, 19, 6]), "`march` should be column index 2 (Jan is 0). Did you select a row by accident?"
assert q2.shape == (4, 3), f"`q2` should be shape (4, 3), but is {q2.shape}."
assert np.array_equal(q2, sales[:, -3:]), "`q2` should contain the last 3 months for every store."
assert top_left.shape == (2, 2) and np.array_equal(top_left, [[12, 15], [8, 9]]), f"`top_left` should be the first 2 rows and first 2 columns; you have shape {top_left.shape}."
assert store0_2d.shape == (1, 6), f"`store0_2d` should keep both axes, shape (1, 6), but has {store0_2d.shape}. Use a slice instead of an integer."
assert np.array_equal(store0_2d[0], sales[0]), "`store0_2d` should contain store 0's figures."
--- hint
Use the comma form: `sales[rows, columns]`. A bare `:` means "all of this axis".
--- hint
An integer index drops an axis; a slice like `0:1` keeps it, even though it only selects one row.
--- hint
Columns come second: March is `sales[:, 2]`, and the last three months are `sales[:, 3:]` (or `-3:`).
```

## Higher dimensions and the ellipsis

The same rules extend to any number of axes: one index per axis, separated by commas, with **missing trailing axes treated as `:`**. A batch of RGB images, for example, is often shaped `(images, height, width, channels)`.

```python run
images = np.arange(2 * 4 * 4 * 3).reshape(2, 4, 4, 3)   # 2 tiny 4x4 RGB images

print("one image:      ", images[0].shape)          # trailing axes default to ':'
print("its red channel:", images[0, :, :, 0].shape)
print("all red channels:", images[..., 0].shape)    # '...' fills in every ':' needed
print("2x2 crop of all:", images[:, :2, :2].shape)
```

`...` (the **ellipsis**) stands for "as many `:` as needed". `images[..., 0]` means "the last axis at position 0, everything else untouched", and it works whether the array is 3-D or 7-D.

## Assigning to slices

Indexing works on the left of `=` too. Assigning a single value **broadcasts** it to the whole selection; assigning an array requires matching shapes.

```python run
board = np.zeros((5, 5), dtype=int)

board[0, :] = 1          # top row
board[:, -1] = 2         # right column
board[2, 1:4] = [7, 8, 9]
board[3:, :2] = 5        # bottom-left block
print(board)
```

This writes **into the original array**. That's powerful, and it's also the start of the next lesson's story about views and copies.

```python exercise id=frame-border title="Draw a frame"
# TODO: write a function that returns an n x n integer array of zeros
# with a border of 1s around the edge, using slice assignment (no loops).
def framed(n):
    out = np.zeros((n, n), dtype=int)
    # your slice assignments here
    ...
    return out

print(framed(5))
--- solution
def framed(n):
    out = np.zeros((n, n), dtype=int)
    out[0, :] = 1
    out[-1, :] = 1
    out[:, 0] = 1
    out[:, -1] = 1
    return out

print(framed(5))
--- test
r = framed(5)
assert isinstance(r, np.ndarray) and r.shape == (5, 5), f"`framed(5)` should return a 5x5 array, got {getattr(r, 'shape', type(r).__name__)}."
expected = np.ones((5, 5), dtype=int); expected[1:-1, 1:-1] = 0
assert r[0].tolist() == [1] * 5, "The top row should be all 1s."
assert r[-1].tolist() == [1] * 5, "The bottom row should be all 1s."
assert r[:, 0].tolist() == [1] * 5 and r[:, -1].tolist() == [1] * 5, "The left and right columns should be all 1s."
assert np.array_equal(r, expected), "The inside of the frame should stay 0."
r8 = framed(8)
e8 = np.ones((8, 8), dtype=int); e8[1:-1, 1:-1] = 0
assert np.array_equal(r8, e8), "Your function should work for any size, e.g. `framed(8)`. Use negative indices rather than hard-coded positions."
--- hint
Four assignments do it: the first row, the last row, the first column, the last column.
--- hint
`out[0, :] = 1` sets the top row. Use `-1` for "last", so it works for any `n`.
```

## Debug challenge: the off-by-one split

```python debug id=split-off-by-one title="The test set is one row short"
# 10 samples, 3 features each. We want the first 8 rows for training
# and the remaining 2 rows for testing — every row used exactly once.
data = np.arange(30).reshape(10, 3)

train = data[:8]
test = data[9:]

print("train rows:", len(train), " test rows:", len(test))
--- solution
data = np.arange(30).reshape(10, 3)

train = data[:8]
test = data[8:]

print("train rows:", len(train), " test rows:", len(test))
--- test
assert train.shape == (8, 3), f"`train` should be the first 8 rows, shape (8, 3), but has {train.shape}."
assert test.shape == (2, 3), f"`test` should have 2 rows, but has {test.shape[0]}. Is a row being skipped?"
assert np.array_equal(np.concatenate([train, test]), data), "Together, `train` and `test` should contain every row of `data` exactly once, in order."
--- hint
Run it: 8 + 1 = 9, so one row disappeared. Which index belongs to neither piece?
--- hint
`data[:8]` stops *before* index 8. Where should the test slice start so that row 8 isn't lost?
```

## Debug challenge: the wrong axis

```python debug id=column-not-row title="Average temperature per sensor"
# Rows are hours (6), columns are sensors (3).
readings = np.array([[20.1, 18.4, 22.0],
                     [20.5, 18.9, 22.4],
                     [21.0, 19.3, 22.9],
                     [21.4, 19.8, 23.1],
                     [21.9, 20.0, 23.6],
                     [22.3, 20.4, 24.0]])

# Average of sensor 1 (the middle column) across all hours
sensor1 = readings[1]
sensor1_mean = sensor1.mean()
print("sensor 1 values:", sensor1)
print("sensor 1 mean:", round(sensor1_mean, 2))
--- solution
readings = np.array([[20.1, 18.4, 22.0],
                     [20.5, 18.9, 22.4],
                     [21.0, 19.3, 22.9],
                     [21.4, 19.8, 23.1],
                     [21.9, 20.0, 23.6],
                     [22.3, 20.4, 24.0]])

sensor1 = readings[:, 1]
sensor1_mean = sensor1.mean()
print("sensor 1 values:", sensor1)
print("sensor 1 mean:", round(sensor1_mean, 2))
--- test
assert sensor1.shape == (6,), f"`sensor1` should have one value per hour (6 values), but has shape {sensor1.shape}. Look at which axis you indexed."
assert np.allclose(sensor1, [18.4, 18.9, 19.3, 19.8, 20.0, 20.4]), "`sensor1` should be the middle column of `readings`."
assert np.isclose(sensor1_mean, 19.4666666), f"`sensor1_mean` should be about 19.47, got {sensor1_mean}."
--- hint
Run it and look at `sensor 1 values`: you get 3 numbers, but there are 6 hours.
--- hint
`readings[1]` is **row** 1, which is one hour. A column needs a `:` for the rows first.
```

## Recap

- 1-D: `a[i]`, negative indices from the end, and `a[start:stop:step]` with `stop` **excluded**. `a[::-1]` reverses.
- N-D: one index per axis, separated by commas: `a[row, col]`. Prefer this over `a[row][col]`.
- `:` means "this whole axis", and `...` fills in as many `:` as needed.
- **Integer index removes an axis; a slice keeps it.** `a[1]` is `(4,)`, `a[1:2]` is `(1, 4)`.
- You can assign to any selection, and a scalar on the right is spread across all of it.

**Up next:** slices don't copy your data; they're *windows* into it. That's fast, and it's also NumPy's number-one source of bugs.
