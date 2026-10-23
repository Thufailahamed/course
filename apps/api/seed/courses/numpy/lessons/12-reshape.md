Data rarely arrives in the shape you need. A sensor streams one long list of readings; an image comes off the network as a flat buffer of bytes; a model wants its input as `(batch, features)`. Reshaping is how you get from the shape you **have** to the shape you **need**, usually without copying a single byte.

In this lesson you'll master `reshape` (including the handy `-1`), learn how NumPy decides which element goes where, and see why `ravel`, `flatten` and `.T` behave differently in ways that cause real bugs.

## Same data, new shape

`reshape` gives you a new **view** of the same numbers, arranged into a different shape. The elements keep their order: NumPy simply re-reads them into rows of a new length.

```python run
import numpy as np

a = np.arange(12)
print("original:", a)
print()
print("reshape(3, 4):")
print(a.reshape(3, 4))
print()
print("reshape(2, 6):")
print(a.reshape(2, 6))
```

You can go to any number of dimensions, as long as the **total number of elements stays the same**. Here 2 × 3 × 2 = 12:

```python run
a.reshape(2, 3, 2)
```

Ask for a shape that holds a different number of elements and NumPy refuses:

```python run error
np.arange(12).reshape(5, 3)
```

> **Tip:** before reshaping, multiply the new dimensions in your head and compare with `.size`. 5 × 3 = 15 ≠ 12.

## Let NumPy do the math with `-1`

Often you know every dimension except one. Pass `-1` for that one and NumPy works it out from the size:

```python run
readings = np.arange(24)

print(readings.reshape(4, -1).shape)    # 4 rows -> 6 columns
print(readings.reshape(-1, 8).shape)    # 8 columns -> 3 rows
print(readings.reshape(-1).shape)       # flatten to 1-D
print(readings.reshape(2, -1, 3).shape) # 2 x ? x 3 -> ? = 4
```

You can use `-1` only **once** per reshape, and the remaining dimensions must divide the size evenly.

```python predict id=predict-minus-one title="What shape does this print?"
a = np.arange(24)
print(a.reshape(2, -1, 4).shape)
--- options
(2, 12, 4)
* (2, 3, 4)
(2, -1, 4)
(2, 4, 3)
--- explain
24 elements split as 2 × ? × 4 means ? = 24 / (2 × 4) = **3**. The `-1` is replaced by the computed size, and the other dimensions stay where you put them: `(2, 3, 4)`.
```

```python exercise id=hourly-by-day title="Reshape a stream of hourly readings"
# 72 hourly temperature readings: three days, back to back.
stream = np.round(15 + 8 * np.sin(np.arange(72) * 2 * np.pi / 24), 1)

# 1. `by_day`: reshape `stream` so each ROW is one day of 24 hours.
#    Use -1 so it would still work for any number of whole days.
# 2. `day3`: the readings of the third day (a 1-D array of 24 values).
by_day = ...
day3 = ...
--- solution
stream = np.round(15 + 8 * np.sin(np.arange(72) * 2 * np.pi / 24), 1)

by_day = stream.reshape(-1, 24)
day3 = by_day[2]
--- test
assert by_day is not ..., "Replace the `...` after `by_day =`."
assert isinstance(by_day, np.ndarray), "`by_day` should be a NumPy array."
assert by_day.shape == (3, 24), f"`by_day` should have one row per day: shape (3, 24). Yours is {by_day.shape}."
assert np.array_equal(by_day[1], stream[24:48]), "Row 1 should hold hours 24–47 of the stream (the second day)."
assert day3 is not ..., "Replace the `...` after `day3 =`."
assert np.shape(day3) == (24,), f"`day3` should be a 1-D array of 24 readings, but its shape is {np.shape(day3)}."
assert np.array_equal(day3, stream[48:]), "`day3` should be the last 24 readings, the third day (row index 2)."
--- hint
Each row should have 24 values; let NumPy compute the number of rows: `stream.reshape(-1, 24)`.
--- hint
Rows are numbered from 0, so the third day is row `2`.
```

## Which element goes where? Memory order

When NumPy reshapes, it reads the elements in order and fills the new shape **row by row**: the last axis changes fastest. This is called **C order** (after the C language), and it's the default.

You can also ask for **Fortran order** (`order="F"`), which fills **column by column**: the first axis changes fastest.

```python run
a = np.arange(1, 7)

print("C order (row by row):")
print(a.reshape(2, 3, order="C"))
print()
print("F order (column by column):")
print(a.reshape(2, 3, order="F"))
```

Think of it as reading a book: C order reads across each line, then moves down; F order reads down each column, then moves right.

> **In the wild:** MATLAB, Fortran, R and many scientific file formats store matrices column by column. When you load raw numbers from those tools, `order="F"` puts them back where they belong.

```python exercise id=column-major-import title="Import a column-major matrix"
# A MATLAB export stored this 3x4 matrix COLUMN BY COLUMN:
#   [[ 1,  2,  3,  4],
#    [ 5,  6,  7,  8],
#    [ 9, 10, 11, 12]]
raw = np.array([1, 5, 9, 2, 6, 10, 3, 7, 11, 4, 8, 12])

# Rebuild the matrix as `m`, shape (3, 4), with a single reshape call.
m = ...
--- solution
raw = np.array([1, 5, 9, 2, 6, 10, 3, 7, 11, 4, 8, 12])

m = raw.reshape(3, 4, order="F")
--- test
assert m is not ..., "Replace the `...` with a reshape of `raw`."
assert isinstance(m, np.ndarray), "`m` should be a NumPy array."
assert m.shape == (3, 4), f"`m` should have shape (3, 4), but it has {m.shape}."
expected = np.arange(1, 13).reshape(3, 4)
assert not np.array_equal(m, raw.reshape(3, 4)), "That's the default C (row-by-row) order, which scrambles this data. The raw values were stored column by column."
assert np.array_equal(m, expected), "The first row should read 1, 2, 3, 4. Check the `order` you used."
--- hint
The default reshape fills row by row. This data was written column by column.
--- hint
`reshape` takes an `order=` argument: `"C"` for row by row, `"F"` for column by column.
```

## Reshape returns a view, not a copy

A reshaped array usually **shares memory** with the original. No data is copied: NumPy just records a new shape for the same buffer. That makes reshape essentially free, but it also means a change through one name is visible through the other:

```python run
a = np.zeros(6)
grid = a.reshape(2, 3)

grid[0, 0] = 99
print("grid:\n", grid)
print("a:", a)
print("share memory?", np.shares_memory(a, grid))
```

```python predict id=predict-reshape-view title="What does this print?"
a = np.zeros(4)
r = a.reshape(2, 2)
r[1, 1] = 5
print(a[3])
--- options
0.0
* 5.0
5
IndexError
--- explain
`r` is a **view** of `a`'s memory. `r[1, 1]` is the 4th element in row-major order, which is `a[3]`. Writing through the view changes `a`, and since `a` is float64 it prints `5.0`.
```

> **Under the hood:** reshape can return a view only when the new shape can be described as a fixed step through the existing memory. For a freshly created array that's always true. For some already-transposed or sliced arrays it isn't, and NumPy quietly makes a copy. You'll dig into *strides*, the mechanism behind this, in the performance lesson.

## Flattening: `ravel` vs `flatten`

Both turn any array into 1-D. The difference is exactly the view/copy question:

| | Returns | Memory |
|---|---|---|
| `a.ravel()` | a **view** whenever possible | shares memory, fast |
| `a.flatten()` | **always a new copy** | independent, safe to modify |
| `a.reshape(-1)` | same as `ravel` | view when possible |

```python run
grid = np.arange(6).reshape(2, 3)

r = grid.ravel()
f = grid.flatten()

r[0] = -1     # writes through to grid
f[1] = -2     # does not
print(grid)
print("ravel shares memory:  ", np.shares_memory(grid, r))
print("flatten shares memory:", np.shares_memory(grid, f))
```

Rule of thumb: use `ravel()` (or `reshape(-1)`) when you only **read** the flat data; use `flatten()` when you're going to **modify** it and the original must stay intact.

```python debug id=ravel-mutation-bug title="The image changed behind my back"
image = np.array([[10.0, 20.0],
                  [30.0, 40.0]])

# Make a normalized 1-D version for a histogram (values 0..1).
# `image` itself must keep its original pixel values!
pixels = image.ravel()
pixels /= pixels.max()

print("pixels:", pixels)
print("image: ", image.tolist())
--- solution
image = np.array([[10.0, 20.0],
                  [30.0, 40.0]])

pixels = image.flatten()
pixels /= pixels.max()

print("pixels:", pixels)
print("image: ", image.tolist())
--- test
assert np.array_equal(image, [[10.0, 20.0], [30.0, 40.0]]), f"`image` was modified. It should still be [[10, 20], [30, 40]], but it is {image.tolist()}."
assert np.allclose(pixels, [0.25, 0.5, 0.75, 1.0]), "`pixels` should be the flattened image divided by its maximum."
assert not np.shares_memory(image, pixels), "`pixels` still shares memory with `image`."
--- hint
Run it and compare `image` before and after. Which line connects `pixels` to `image`'s memory?
--- hint
`ravel()` returns a view, and `/=` modifies in place, through the view. You need a flattening method that always copies.
```

## `reshape` is not transpose

Here's one of the most common shape bugs in real code. Transposing with `.T` (which you'll study properly in the next lesson) **swaps rows and columns**: row *i* becomes column *i*. Reshaping to the swapped shape does **not** do that. It just re-reads the same elements in order:

```python run
scores = np.array([[90, 80, 70],
                   [60, 50, 40]])   # 2 students x 3 subjects

print("scores.T  (correct: 3 subjects x 2 students):")
print(scores.T)
print()
print("scores.reshape(3, 2)  (same shape, scrambled data):")
print(scores.reshape(3, 2))
```

Both results have shape `(3, 2)`, so shape checks won't save you. Only the values reveal the bug.

```python debug id=reshape-vs-transpose-bug title="Subjects got mixed up"
# Rows are students, columns are subjects (math, physics, chemistry).
grades = np.array([[95, 82, 74],
                   [61, 88, 90],
                   [78, 70, 85],
                   [84, 93, 66]])

# We need one ROW PER SUBJECT (each row = all 4 students' grades for that subject).
by_subject = grades.reshape(3, 4)
math = by_subject[0]
print("math grades:", math)
--- solution
grades = np.array([[95, 82, 74],
                   [61, 88, 90],
                   [78, 70, 85],
                   [84, 93, 66]])

by_subject = grades.T
math = by_subject[0]
print("math grades:", math)
--- test
assert by_subject.shape == (3, 4), f"`by_subject` should have shape (3, 4), but it has {by_subject.shape}."
assert np.array_equal(math, [95, 61, 78, 84]), f"Math grades should be the first column of `grades`: [95, 61, 78, 84]. You have {np.asarray(math).tolist()}."
assert np.array_equal(by_subject, np.array([[95, 82, 74], [61, 88, 90], [78, 70, 85], [84, 93, 66]]).T), "Every row of `by_subject` should be one column of `grades`."
--- hint
Compare `math` with the first *column* of `grades`. Which numbers ended up in the first row?
--- hint
`reshape(3, 4)` re-reads elements row by row; it doesn't move columns into rows. Swapping axes is a transpose: `.T`.
```

## `np.resize`: when sizes don't match on purpose

`reshape` insists on the same number of elements. `np.resize` doesn't: it **repeats** the data to fill a larger shape, or truncates it for a smaller one. It's occasionally handy for tiling a pattern, but it's rarely what you want for real data. A reshape mistake that "works" with `resize` is still a mistake.

```python run
pattern = np.array([1, 2, 3])
print(np.resize(pattern, (3, 4)))
print(np.resize(pattern, 2))
```

```python exercise id=batch-samples title="Prepare mini-batches for a model"
# 40 samples, each with 3 features, arrive as one flat array of 120 numbers:
# sample 0 is flat[0:3], sample 1 is flat[3:6], and so on.
flat = np.linspace(0, 1, 120)

# 1. `X`: one row per sample, one column per feature (use -1 for the rows).
# 2. `batches`: `X` split into mini-batches of 8 samples each,
#    shape (number_of_batches, 8, 3). Use -1 again.
X = ...
batches = ...
--- solution
flat = np.linspace(0, 1, 120)

X = flat.reshape(-1, 3)
batches = X.reshape(-1, 8, 3)
--- test
assert X is not ... and batches is not ..., "Replace both `...` placeholders."
assert isinstance(X, np.ndarray) and isinstance(batches, np.ndarray), "`X` and `batches` should be NumPy arrays."
assert X.shape == (40, 3), f"`X` should have shape (40, 3): 40 samples × 3 features. Yours is {X.shape}."
assert np.array_equal(X[1], flat[3:6]), "Each row of `X` should be one sample: X[1] should equal flat[3:6]."
assert batches.shape == (5, 8, 3), f"`batches` should have shape (5, 8, 3): 5 batches of 8 samples × 3 features. Yours is {batches.shape}."
assert np.array_equal(batches[1, 0], X[8]), "The first sample of batch 1 should be sample 8 (X[8])."
--- hint
Each row of `X` has 3 values, so `flat.reshape(-1, 3)`.
--- hint
For `batches`, the last two dimensions are fixed: `(?, 8, 3)`. Let `-1` compute the number of batches.
```

## Recap

- `reshape` rearranges the same elements into a new shape; the total size must not change.
- Use `-1` (once) to let NumPy infer one dimension from the size.
- Reshape fills **row by row** (C order) by default; `order="F"` fills column by column for data from MATLAB/Fortran.
- Reshaped arrays and `ravel()` are usually **views** sharing memory; `flatten()` always copies.
- `reshape` to the swapped shape is **not** a transpose. Use `.T` to turn rows into columns.
- `np.resize` repeats or truncates data to fit; it's rarely what you want.

**Up next:** adding, removing and swapping axes with `np.newaxis`, `squeeze`, `transpose` and `moveaxis`.
