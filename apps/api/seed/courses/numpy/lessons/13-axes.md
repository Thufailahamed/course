Three numbers can be a lot of different things. `[1, 2, 3]` might be a flat list of values, a **row** in a table, a **column** in a table, or a **batch** containing a single sample. The numbers are identical; only the *axes* differ. And when you combine arrays, or hand one to a library like scikit-learn or PyTorch, those axes decide whether your code works, crashes, or, worst of all, silently computes the wrong thing.

This lesson gives you precise control over axes: adding them with `np.newaxis` and `expand_dims`, removing them with `squeeze`, and reordering them with `transpose`, `swapaxes` and `moveaxis`.

## Rows, columns and plain 1-D arrays

A 1-D array has one axis. It's neither a row nor a column, just a sequence. To make it a row or a column, you give it a second axis of length 1:

```python run
import numpy as np

v = np.array([1, 2, 3])
row = v.reshape(1, 3)
col = v.reshape(3, 1)

print("v   shape:", v.shape)
print("row shape:", row.shape)
print(row)
print("col shape:", col.shape)
print(col)
```

| Shape | Name | Looks like |
|---|---|---|
| `(3,)` | 1-D array | `[1 2 3]` |
| `(1, 3)` | row vector | `[[1 2 3]]` |
| `(3, 1)` | column vector | `[[1] [2] [3]]` |

## Adding an axis with `np.newaxis`

Reshape works, but you have to spell out every dimension. The idiomatic way to add a length-1 axis is to index with **`np.newaxis`**, which is simply an alias for `None`, at the position where the new axis should go:

```python run
v = np.array([1, 2, 3])

print(v[np.newaxis, :].shape)   # new axis in front -> row    (1, 3)
print(v[:, np.newaxis].shape)   # new axis at the end -> column (3, 1)
print(v[:, None].shape)         # None means exactly the same thing
print(v[None, :, None].shape)   # as many as you like          (1, 3, 1)
```

Read `v[:, np.newaxis]` as "keep the existing axis (`:`), then add a new one". It's a **view**: no data is copied.

Why does this matter? Because column vectors let you combine arrays in two directions at once. Multiplying a `(3, 1)` column by a `(4,)` row stretches both into a `(3, 4)` table. This is **broadcasting**, and it gets its own lesson soon. For now, just see what an extra axis can do:

```python run
quantities = np.array([1, 2, 5])            # 3 order sizes
unit_prices = np.array([9.5, 12.0, 3.25, 7.0])  # 4 products

totals = quantities[:, np.newaxis] * unit_prices
print("shape:", totals.shape)
print(totals)
```

Row *i*, column *j* holds `quantities[i] * unit_prices[j]`: a complete price table in one line.

```python exercise id=price-table title="Build a discount table"
prices = np.array([20.0, 35.0, 50.0, 80.0])   # 4 products
discounts = np.array([0.0, 0.1, 0.25])        # 3 discount levels

# 1. `price_col`: `prices` as a COLUMN vector, shape (4, 1).
# 2. `table`: the discounted price of every product at every level,
#    shape (4, 3), where table[i, j] = prices[i] * (1 - discounts[j]).
price_col = ...
table = ...
--- solution
prices = np.array([20.0, 35.0, 50.0, 80.0])
discounts = np.array([0.0, 0.1, 0.25])

price_col = prices[:, np.newaxis]
table = price_col * (1 - discounts)
--- test
assert price_col is not ..., "Replace the `...` after `price_col =`."
assert np.shape(price_col) == (4, 1), f"`price_col` should be a column vector with shape (4, 1), but it has shape {np.shape(price_col)}."
assert table is not ..., "Replace the `...` after `table =`."
assert np.shape(table) == (4, 3), f"`table` should have one row per product and one column per discount: (4, 3). Yours is {np.shape(table)}."
expected = prices[:, None] * (1 - discounts)
assert np.allclose(table[:, 0], prices), "Column 0 (no discount) should equal the original prices."
assert np.allclose(table, expected), "Check the formula: price × (1 − discount). For example table[3, 2] should be 60.0."
--- hint
`prices[:, np.newaxis]` turns the 4 prices into a column.
--- hint
Multiply the column by `(1 - discounts)`, a 1-D array of 3 factors. NumPy stretches the result into a 4 × 3 table.
```

## `np.expand_dims`: the named version

`np.expand_dims(a, axis)` does the same thing as `np.newaxis`, but you say *which position* the new axis should take. That's often clearer in functions, especially with negative axes:

```python run
image = np.zeros((28, 28))        # one grayscale image

print(np.expand_dims(image, axis=0).shape)    # (1, 28, 28)   batch of one
print(np.expand_dims(image, axis=-1).shape)   # (28, 28, 1)   add a channel axis
print(np.expand_dims(image, axis=(0, -1)).shape)  # (1, 28, 28, 1) both at once
```

> **In the wild:** deep-learning models almost always expect a **batch** axis first. Passing a single image of shape `(28, 28)` to a model that wants `(batch, height, width, channels)` is the classic "expected 4 dimensions, got 2" error. `expand_dims` is the fix.

```python exercise id=batch-of-one title="Prepare a single image for a model"
rng = np.random.default_rng(7)
digit = rng.random((28, 28))      # one 28x28 grayscale image

# The model expects input shaped (batch, height, width, channels).
# Create `model_input` with shape (1, 28, 28, 1) from `digit`, without copying data
# by hand. Use np.expand_dims or np.newaxis.
model_input = ...
--- solution
rng = np.random.default_rng(7)
digit = rng.random((28, 28))

model_input = np.expand_dims(digit, axis=(0, -1))
--- test
assert model_input is not ..., "Replace the `...` with your code."
assert isinstance(model_input, np.ndarray), "`model_input` should be a NumPy array."
assert model_input.shape == (1, 28, 28, 1), f"`model_input` should have shape (1, 28, 28, 1), but it has {model_input.shape}."
assert np.array_equal(model_input[0, :, :, 0], digit), "The image data should be unchanged. Only add axes; don't reshape or reorder the pixels."
--- hint
You need two new axes: one at the front (batch) and one at the end (channels).
--- hint
`np.expand_dims(digit, axis=(0, -1))` adds both at once, or index with `digit[np.newaxis, :, :, np.newaxis]`.
```

## Removing axes with `squeeze`

`squeeze` does the opposite: it **removes axes of length 1**. Without arguments it removes all of them; with `axis=` it removes only the one you name.

```python run
x = np.zeros((1, 3, 1, 4))

print("squeeze():       ", x.squeeze().shape)
print("squeeze(axis=0): ", x.squeeze(axis=0).shape)
print("squeeze(axis=2): ", x.squeeze(axis=2).shape)
```

You can only squeeze an axis whose length is 1. Anything else is an error, because it would throw data away:

```python run error
np.zeros((1, 3)).squeeze(axis=1)
```

```python predict id=predict-squeeze title="What does this print?"
x = np.zeros((1, 3, 1, 2))
print(x.squeeze().shape)
--- options
(1, 3, 1, 2)
* (3, 2)
(3, 1, 2)
(6,)
--- explain
`squeeze()` with no axis removes **every** axis of length 1, here the first and the third, leaving `(3, 2)`. It never merges or reorders axes, so it can't produce `(6,)`.
```

> **Pitfall:** a bare `squeeze()` is dangerous when a dimension *happens* to be 1. A batch with one sample loses its batch axis too. In library code, prefer `squeeze(axis=...)` so only the axis you mean disappears.

```python debug id=squeeze-batch-bug title="It works until the batch has one sample"
def scores_1d(model_output):
    """model_output has shape (batch, 1). Return a 1-D array of shape (batch,)."""
    scores = model_output.squeeze()
    print("got", len(scores), "scores")
    return scores

scores_1d(np.array([[0.9], [0.2], [0.7]]))   # fine: batch of 3
scores_1d(np.array([[0.4]]))                 # batch of 1
--- solution
def scores_1d(model_output):
    """model_output has shape (batch, 1). Return a 1-D array of shape (batch,)."""
    scores = model_output.squeeze(axis=1)
    print("got", len(scores), "scores")
    return scores

scores_1d(np.array([[0.9], [0.2], [0.7]]))
scores_1d(np.array([[0.4]]))
--- test
r3 = scores_1d(np.array([[0.9], [0.2], [0.7]]))
assert np.shape(r3) == (3,), f"For a batch of 3, expected shape (3,), got {np.shape(r3)}."
r1 = scores_1d(np.array([[0.4]]))
assert np.shape(r1) == (1,), f"For a batch of 1, expected shape (1,), but got {np.shape(r1)}. The batch axis was squeezed away."
assert np.allclose(r1, [0.4]), "The single score should be 0.4."
--- hint
Run it. The batch of 3 works; the batch of 1 crashes. What shape does `squeeze()` produce for an array of shape `(1, 1)`?
--- hint
`squeeze()` removed **both** length-1 axes, including the batch axis. Only remove the feature axis: `squeeze(axis=1)` (or `model_output[:, 0]`).
```

## Reordering axes: `transpose`

For a 2-D array, `.T` swaps rows and columns. In general, `.T` **reverses the order of all axes**, and `transpose(*axes)` lets you choose any order. Each number says which old axis goes in that position:

```python run
a = np.zeros((2, 3, 4))

print(".T:                 ", a.T.shape)                    # reversed
print("transpose(1, 0, 2): ", a.transpose(1, 0, 2).shape)  # swap first two
print("transpose(0, 2, 1): ", a.transpose(0, 2, 1).shape)  # swap last two
```

Read `transpose(1, 0, 2)` as: *new axis 0 is old axis 1, new axis 1 is old axis 0, new axis 2 is old axis 2.*

```python predict id=predict-transpose title="What does this print?"
a = np.zeros((5, 6, 7))
print(a.transpose(2, 0, 1).shape)
--- options
(6, 7, 5)
* (7, 5, 6)
(7, 6, 5)
(5, 7, 6)
--- explain
New position 0 takes old axis **2** (size 7), position 1 takes old axis **0** (size 5), and position 2 takes old axis **1** (size 6): `(7, 5, 6)`.
```

Like reshape, transposing is free: it returns a **view** with the axes relabeled, and no data moves.

## `swapaxes` and `moveaxis`

Writing out a full permutation is error-prone for arrays with many axes. Two helpers cover the common cases:

- `np.swapaxes(a, i, j)` swaps two axes and leaves the rest alone.
- `np.moveaxis(a, source, destination)` moves one axis to a new position and shifts the others along.

The most famous use is converting image batches between the two conventions used by deep-learning libraries:

```python run
batch = np.zeros((8, 32, 32, 3))   # (N, H, W, C)  channels-last: TensorFlow, PIL, matplotlib

nchw_a = batch.transpose(0, 3, 1, 2)      # explicit permutation
nchw_b = np.moveaxis(batch, -1, 1)        # "move channels to position 1"
swapped = np.swapaxes(batch, 1, 2)        # swap height and width

print("transpose:", nchw_a.shape)
print("moveaxis: ", nchw_b.shape)
print("swapaxes: ", swapped.shape)
```

> **In the wild:** PyTorch wants images as `(N, C, H, W)` (channels first). TensorFlow, PIL and matplotlib use `(N, H, W, C)` (channels last). `np.moveaxis(batch, -1, 1)` and back with `np.moveaxis(batch, 1, -1)` is a line you'll write many times.

```python exercise id=channels-first title="Convert a batch for PyTorch"
rng = np.random.default_rng(42)
batch = rng.random((16, 24, 24, 3))   # (N, H, W, C)

# Create `chw`: the same batch in (N, C, H, W) order.
# Every value must stay attached to the same image, row, column and channel.
chw = ...
--- solution
rng = np.random.default_rng(42)
batch = rng.random((16, 24, 24, 3))

chw = np.moveaxis(batch, -1, 1)
--- test
assert chw is not ..., "Replace the `...` with your code."
assert isinstance(chw, np.ndarray), "`chw` should be a NumPy array."
assert chw.shape == (16, 3, 24, 24), f"`chw` should have shape (16, 3, 24, 24), but it has {chw.shape}."
assert np.array_equal(chw[5, 2], batch[5, :, :, 2]), "The channel-2 plane of image 5 doesn't match. Did you reshape instead of reordering axes?"
assert np.array_equal(chw[0, :, 3, 7], batch[0, 3, 7, :]), "The pixel at row 3, column 7 of image 0 should keep its 3 channel values."
--- hint
Reshape would scramble the pixels. You need to *reorder* axes: move the last axis (channels) to position 1.
--- hint
`np.moveaxis(batch, -1, 1)` or `batch.transpose(0, 3, 1, 2)`.
```

```python debug id=row-weights-bug title="Weight each row"
# Each ROW of `matrix` belongs to one sensor; scale row i by weights[i].
matrix = np.array([[1.0, 2.0, 3.0, 4.0],
                   [1.0, 1.0, 1.0, 1.0],
                   [2.0, 0.0, 2.0, 0.0]])
weights = np.array([10.0, 0.5, 3.0])

scaled = matrix * weights[np.newaxis, :]
print(scaled)
--- solution
matrix = np.array([[1.0, 2.0, 3.0, 4.0],
                   [1.0, 1.0, 1.0, 1.0],
                   [2.0, 0.0, 2.0, 0.0]])
weights = np.array([10.0, 0.5, 3.0])

scaled = matrix * weights[:, np.newaxis]
print(scaled)
--- test
assert np.shape(scaled) == (3, 4), f"`scaled` should keep the matrix's shape (3, 4), got {np.shape(scaled)}."
assert np.allclose(scaled[0], [10, 20, 30, 40]), "Row 0 should be multiplied by 10."
assert np.allclose(scaled[1], [0.5, 0.5, 0.5, 0.5]), "Row 1 should be multiplied by 0.5."
assert np.allclose(scaled[2], [6, 0, 6, 0]), "Row 2 should be multiplied by 3."
--- hint
Read the error: the shapes are `(3, 4)` and `(1, 3)`. Should `weights` be a row or a column here?
--- hint
One weight per **row** means the weights must run down a column: shape `(3, 1)`. Put the new axis *after* the existing one.
```

## Recap

- A 1-D array `(n,)` is neither a row `(1, n)` nor a column `(n, 1)`; adding a length-1 axis makes it one.
- `a[np.newaxis, :]`, `a[:, None]` and `np.expand_dims(a, axis)` add axes as free views.
- `squeeze()` removes length-1 axes. Pass `axis=` so a batch of one doesn't lose its batch axis.
- `.T` reverses all axes; `transpose(order)` picks any order; `swapaxes` and `moveaxis` handle common moves.
- Channels-last `(N, H, W, C)` ↔ channels-first `(N, C, H, W)` is a `moveaxis`, never a `reshape`.

**Up next:** joining arrays with `concatenate` and `stack`, and splitting them apart again.
