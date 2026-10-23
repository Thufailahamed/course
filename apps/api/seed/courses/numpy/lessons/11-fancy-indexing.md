Slices pick *regular* patterns: a range, every other element, the last ten. Masks pick elements that *match a condition*. But sometimes you know exactly **which positions** you want: rows 3, 17 and 42; the top-5 scores you just found; the color for each of 10,000 class labels. That's **fancy indexing**: indexing with an *array of integers*.

You'll also meet `np.where`, NumPy's vectorized "if this, then that". Together they replace a huge category of loops, and they're the core of lookup tables, sampling and label encoding in every ML codebase.

## Indexing with a list of positions

Pass a list (or array) of integers and NumPy returns the elements at those positions, **in the order you asked**. Repeats are allowed.

```python run
import numpy as np

letters = np.array(["a", "b", "c", "d", "e", "f"])

print(letters[[0, 3, 5]])        # pick positions
print(letters[[5, 4, 3]])        # any order you like
print(letters[[1, 1, 1, 0]])     # repeats are fine
print(letters[[-1, 0]])          # negative indices too
```

The result always has the **shape of the index array**. Index with a 2-D array of positions and you get a 2-D result:

```python run
values = np.array([10, 20, 30, 40, 50])
idx = np.array([[0, 1],
                [3, 4]])
values[idx]
```

```python predict id=predict-fancy title="What does this print?"
a = np.array([7, 3, 9, 1])
print(a[[2, 2, 0]] + a[[1, 3, 3]])
--- options
* [12 10  8]
[ 9  9  7]
[16  4 10]
[3 5 3]
--- explain
`a[[2, 2, 0]]` is `[9, 9, 7]` and `a[[1, 3, 3]]` is `[3, 1, 1]`. Adding them element-wise gives `[12, 10, 8]`. NumPy pads `8` with an extra space so every value has the width of the widest one (`12`).
```

## Rows and columns of a 2-D array

In 2-D, a list in the first position selects **rows**; a list after `:` selects **columns**.

```python run
scores = np.array([[88, 92, 79],
                   [65, 70, 81],
                   [95, 89, 91],
                   [72, 68, 77]])   # 4 students x 3 exams

print("students 0 and 2:\n", scores[[0, 2]])
print("exams 2 and 0, every student:\n", scores[:, [2, 0]])
```

### Pairs of index arrays select *points*, not a grid

Here's the part that surprises everyone. When you pass index arrays for **two axes**, NumPy pairs them up element by element: `m[[r0, r1], [c0, c1]]` gives you `m[r0, c0]` and `m[r1, c1]`, **just two values**, not a 2x2 block.

```python run
m = np.arange(1, 17).reshape(4, 4)
print(m)
print("points (0,1) and (3,2):", m[[0, 3], [1, 2]])
print("the diagonal:          ", m[[0, 1, 2, 3], [0, 1, 2, 3]])
```

When you want the full **sub-grid** of the chosen rows × chosen columns, wrap them with `np.ix_`:

```python run
m = np.arange(1, 17).reshape(4, 4)
rows, cols = [0, 3], [1, 2]

print(m[np.ix_(rows, cols)])     # rows 0 and 3, crossed with columns 1 and 2
```

> **Tip:** Think of `m[rows, cols]` as "zip the two lists into coordinates", and `m[np.ix_(rows, cols)]` as "every combination of these rows and these columns".

```python exercise id=city-distances title="Distances between chosen cities"
cities = np.array(["Lisbon", "Madrid", "Paris", "Berlin", "Rome"])
# km between every pair of cities (symmetric)
dist = np.array([[   0,  503, 1453, 2311, 1861],
                 [ 503,    0, 1053, 1869, 1365],
                 [1453, 1053,    0,  878, 1106],
                 [2311, 1869,  878,    0, 1181],
                 [1861, 1365, 1106, 1181,    0]])

trip = [2, 3, 4]   # Paris, Berlin, Rome

# TODO (no loops):
trip_names = ...   # the names of the trip cities, in trip order
sub = ...          # 3x3 distances between the trip cities only
legs = ...         # 1-D: Paris→Berlin and Berlin→Rome distances, i.e. dist[2,3] and dist[3,4]
--- solution
cities = np.array(["Lisbon", "Madrid", "Paris", "Berlin", "Rome"])
dist = np.array([[   0,  503, 1453, 2311, 1861],
                 [ 503,    0, 1053, 1869, 1365],
                 [1453, 1053,    0,  878, 1106],
                 [2311, 1869,  878,    0, 1181],
                 [1861, 1365, 1106, 1181,    0]])

trip = [2, 3, 4]

trip_names = cities[trip]
sub = dist[np.ix_(trip, trip)]
legs = dist[trip[:-1], trip[1:]]
--- test
for n in ["trip_names", "sub", "legs"]:
    assert globals()[n] is not ..., f"Replace the `...` after `{n} =` with an indexing expression."
assert list(trip_names) == ["Paris", "Berlin", "Rome"], f"`trip_names` should be the names at the trip positions. Got {list(trip_names)}."
assert isinstance(sub, np.ndarray) and sub.shape == (3, 3), f"`sub` should be a 3x3 block, but has shape {getattr(sub, 'shape', None)}. Pairing two lists gives points; you need every combination."
assert np.array_equal(sub, [[0, 878, 1106], [878, 0, 1181], [1106, 1181, 0]]), "`sub` should contain the distances among Paris, Berlin and Rome only."
assert np.array_equal(np.asarray(legs), [878, 1181]), f"`legs` should be [878, 1181]: two point lookups, (2,3) and (3,4). Got {np.asarray(legs)}."
--- hint
`cities[trip]` picks names. For the 3x3 block you want rows *crossed with* columns. Which helper builds that?
--- hint
`dist[np.ix_(trip, trip)]` gives the block. For `legs`, pair row indices `[2, 3]` with column indices `[3, 4]`.
```

## Fancy indexing makes copies, but assignment works

Like boolean masks, fancy indexing **gathers** values into new memory, so the result is a copy. Assigning *through* a fancy index in a single expression does write into the original:

```python run
stock = np.array([5, 0, 12, 0, 3])
picked = stock[[1, 3]]
picked[:] = 99                 # modifies the copy only
print("after editing copy:", stock)

stock[[1, 3]] = 20             # direct assignment writes through
print("after assignment:  ", stock)
```

> **Pitfall:** With **repeated** indices, `a[idx] += 1` adds only **once** per unique position: it reads all values, adds 1, then writes them back, and later writes overwrite earlier ones. To accumulate, use `np.add.at(a, idx, 1)`, or `np.bincount` for counting.

## Lookup tables: the ML superpower

Fancy indexing turns any array into a **lookup table**. If `palette` holds one row per class, then `palette[labels]` gives the row for *every* label at once, whatever shape `labels` has.

```python run
palette = np.array([[230,  57,  70],    # class 0: red
                    [ 69, 123, 157],    # class 1: blue
                    [ 42, 157, 143]])   # class 2: green
names = np.array(["cat", "dog", "bird"])

labels = np.array([2, 0, 0, 1, 2, 1])   # e.g. model predictions
print(names[labels])
print(palette[labels].shape)            # one RGB color per label
```

This is how segmentation masks get colored, how token ids become embeddings (`embedding_matrix[token_ids]`), and how predicted class indices become human-readable names.

```python exercise id=label-lookup title="Decode model predictions"
class_names = np.array(["negative", "neutral", "positive"])
class_weights = np.array([1.5, 1.0, 0.8])     # one weight per class

predictions = np.array([2, 2, 0, 1, 2, 0, 1, 2])

# TODO (no loops, no if-statements):
predicted_names = ...   # the class name for each prediction
sample_weights = ...    # the weight for each prediction
total_weight = ...      # the sum of sample_weights
--- solution
class_names = np.array(["negative", "neutral", "positive"])
class_weights = np.array([1.5, 1.0, 0.8])

predictions = np.array([2, 2, 0, 1, 2, 0, 1, 2])

predicted_names = class_names[predictions]
sample_weights = class_weights[predictions]
total_weight = sample_weights.sum()
--- test
for n in ["predicted_names", "sample_weights", "total_weight"]:
    assert globals()[n] is not ..., f"Replace the `...` after `{n} =` with your code."
assert isinstance(predicted_names, np.ndarray) and predicted_names.shape == (8,), "`predicted_names` should have one name per prediction (8 total). Index `class_names` with the predictions array."
assert list(predicted_names) == ["positive", "positive", "negative", "neutral", "positive", "negative", "neutral", "positive"], f"`predicted_names` don't match the predictions. Got {list(predicted_names)}."
assert np.allclose(sample_weights, [0.8, 0.8, 1.5, 1.0, 0.8, 1.5, 1.0, 0.8]), f"`sample_weights` should be the class weight for each prediction. Got {sample_weights}."
assert np.isclose(total_weight, 8.2), f"`total_weight` should be the sum of the sample weights (8.2), got {total_weight!r}."
--- hint
The predictions are class *indices*, so they can index any array that has one entry per class.
--- hint
`class_names[predictions]` decodes all 8 at once. Do the same with `class_weights`.
```

## `np.where`: vectorized if/else

`np.where(condition, x, y)` builds a new array choosing, element by element, from `x` where the condition is true and from `y` where it's false. `x` and `y` can be arrays or single values.

```python run
hours = np.array([38, 45, 40, 52, 30])
rate = 20.0

label = np.where(hours > 40, "overtime", "regular")
pay = np.where(hours > 40, 40 * rate + (hours - 40) * rate * 1.5, hours * rate)

print(label)
print(pay)
```

Unlike assigning through a mask, `np.where` **doesn't modify anything**. It returns a fresh array, which makes it ideal inside functions.

### Finding positions: `np.where(cond)`, `np.nonzero`, `np.argwhere`

With only a condition, `np.where(cond)` returns **where** it's true: a *tuple* of index arrays, one per axis (the same as `np.nonzero`). `np.argwhere` gives the same information as one `(row, col)` pair per match.

```python run
grid = np.array([[0, 7, 0],
                 [3, 0, 9]])

rows, cols = np.where(grid > 0)
print("rows:", rows, " cols:", cols)
print("values:", grid[rows, cols])
print("as coordinates:\n", np.argwhere(grid > 0))
```

```python predict id=predict-where title="What does np.where return?"
a = np.array([4, -2, 7, -5])
print(np.where(a < 0, 0, a))
--- options
[0 1 0 1]
[-2 -5]
* [4 0 7 0]
(array([1, 3]),)
--- explain
The three-argument form picks from `0` where `a < 0` and from `a` everywhere else, so negatives become 0. The one-argument form, `np.where(a < 0)`, would return positions instead: `(array([1, 3]),)`.
```

```python exercise id=where-discount title="Tiered discounts"
cart = np.array([15.0, 120.0, 49.99, 75.0, 250.0, 8.5])

# TODO (no loops):
# Items priced 100 or more get 20% off; everything else gets 5% off.
final = ...          # final price of each item, as an array
discounted = ...     # the POSITIONS (indices) of items priced 100 or more, as a 1-D array
--- solution
cart = np.array([15.0, 120.0, 49.99, 75.0, 250.0, 8.5])

final = np.where(cart >= 100, cart * 0.8, cart * 0.95)
discounted = np.where(cart >= 100)[0]
--- test
assert final is not ..., "Replace the `...` after `final =` with your code."
assert discounted is not ..., "Replace the `...` after `discounted =` with your code."
assert isinstance(final, np.ndarray) and final.shape == cart.shape, f"`final` should have one price per item, shape {cart.shape}."
assert np.allclose(final, [14.25, 96.0, 47.4905, 71.25, 200.0, 8.075]), f"`final` should apply 20% off for items >= 100 and 5% off for the rest. Got {final}."
d = np.asarray(discounted)
assert d.ndim == 1, f"`discounted` should be a 1-D array of indices. `np.where(cond)` returns a tuple, so take its first element. Got {discounted!r}."
assert d.tolist() == [1, 4], f"`discounted` should be the indices [1, 4], got {d.tolist()}."
--- hint
`np.where(cart >= 100, <price if true>, <price if false>)` does the whole cart at once.
--- hint
`np.where(condition)` with one argument returns a *tuple* like `(array([...]),)`. Grab element `[0]` for a 1-D array (or use `np.nonzero`).
```

## `np.take` and `np.put`

`np.take(a, idx)` is the function form of `a[idx]`, and `np.put(a, idx, values)` is the function form of `a[idx] = values` (on the *flattened* array). They're handy when you want to choose the axis programmatically: `np.take(m, idx, axis=1)` selects columns.

```python run
m = np.arange(12).reshape(3, 4)
print(np.take(m, [0, 2], axis=1))     # same as m[:, [0, 2]]

flat = np.zeros(6, dtype=int)
np.put(flat, [1, 4], [7, 9])
print(flat)
```

## Debug challenge: points instead of a block

```python debug id=points-not-block title="The sub-matrix has the wrong shape"
# Correlation between 5 features. Extract the block for features 0, 2 and 4.
corr = np.array([[1.0, 0.2, 0.7, 0.1, 0.4],
                 [0.2, 1.0, 0.3, 0.8, 0.5],
                 [0.7, 0.3, 1.0, 0.2, 0.6],
                 [0.1, 0.8, 0.2, 1.0, 0.3],
                 [0.4, 0.5, 0.6, 0.3, 1.0]])

keep = [0, 2, 4]
block = corr[keep, keep]
print("block shape:", block.shape)
print(block)
--- solution
corr = np.array([[1.0, 0.2, 0.7, 0.1, 0.4],
                 [0.2, 1.0, 0.3, 0.8, 0.5],
                 [0.7, 0.3, 1.0, 0.2, 0.6],
                 [0.1, 0.8, 0.2, 1.0, 0.3],
                 [0.4, 0.5, 0.6, 0.3, 1.0]])

keep = [0, 2, 4]
block = corr[np.ix_(keep, keep)]
print("block shape:", block.shape)
print(block)
--- test
assert block.shape == (3, 3), f"`block` should be 3x3, but has shape {block.shape}. Two index lists are paired into points, not crossed into a grid."
assert np.allclose(block, [[1.0, 0.7, 0.4], [0.7, 1.0, 0.6], [0.4, 0.6, 1.0]]), "`block` should hold the correlations among features 0, 2 and 4."
--- hint
Run it: the "block" is just `[1. 1. 1.]`, the diagonal. Why only 3 values?
--- hint
`corr[keep, keep]` zips the lists into the points (0,0), (2,2), (4,4). You need every row × column combination.
```

## Debug challenge: a histogram that undercounts

```python debug id=undercount-labels title="Every class count is 0 or 1"
# Count how many times each class (0, 1 or 2) appears.
labels = np.array([0, 2, 1, 2, 2, 0, 1, 2, 0, 2])

counts = np.zeros(3, dtype=int)
counts[labels] += 1
print("counts:", counts, " total:", counts.sum(), "of", len(labels))
--- solution
labels = np.array([0, 2, 1, 2, 2, 0, 1, 2, 0, 2])

counts = np.zeros(3, dtype=int)
np.add.at(counts, labels, 1)
print("counts:", counts, " total:", counts.sum(), "of", len(labels))
--- test
assert np.array_equal(counts, [3, 2, 5]), f"`counts` should be [3, 2, 5], got {counts}. Repeated indices only get incremented once with `+=`."
assert counts.sum() == len(labels), "The counts should add up to the number of labels."
--- hint
Run it: the counts add up to 3, not 10. What happens when the same index appears several times in `counts[labels] += 1`?
--- hint
`+=` with fancy indexing reads, adds and writes once per unique position. `np.add.at(counts, labels, 1)` accumulates properly (and `np.bincount(labels)` also works).
```

## Recap

- **Fancy indexing** uses integer arrays: `a[[3, 0, 3]]` picks positions in any order, with repeats, and the result has the index array's shape.
- In 2-D, `m[rows]` and `m[:, cols]` select rows and columns. `m[r, c]` **pairs** indices into points, and `m[np.ix_(r, c)]` takes the **grid**.
- Fancy indexing returns **copies**; assign in one expression. Use `np.add.at` when indices repeat.
- `table[labels]` turns any per-class array into a per-sample lookup.
- `np.where(cond, x, y)` is a vectorized if/else; `np.where(cond)`, `np.nonzero` and `np.argwhere` find positions.

**Up next:** reshaping, giving the same data a new shape, and understanding the memory order that makes it possible.
