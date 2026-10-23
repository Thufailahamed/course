You rarely type arrays out by hand. Real NumPy code starts with a **blank canvas**: a matrix of zeros to accumulate results into, a vector of ones to use as weights, an identity matrix for linear algebra, an array of `NaN`s that marks "no data yet". NumPy's *factory functions* build these instantly, at any size, with exactly the dtype you ask for.

By the end of this lesson you'll be able to allocate any array you need in one line, and you'll know the two classic traps: passing a shape the wrong way and accidentally inheriting an integer dtype.

## `zeros` and `ones`: the workhorses

`np.zeros(shape)` and `np.ones(shape)` build arrays filled with 0 and 1. The **shape** is a single argument: an integer for 1-D, or a **tuple** for anything with more dimensions.

```python run
import numpy as np

print(np.zeros(5))
print()
print(np.ones((2, 4)))
```

Notice the dots: `0.` and `1.`. Factory functions default to **`float64`**, because most numerical work (averages, weights, probabilities) needs fractions. Ask for something else with `dtype=`:

```python run
counts = np.zeros(4, dtype=int)
flags = np.ones((2, 3), dtype=bool)

print(counts, counts.dtype)
print(flags)
```

> **Tip:** `dtype=int` gives you the platform's default integer: `int64` on most desktops, and `int32` in this browser runtime, because WebAssembly is a 32-bit platform. When the exact width matters, say so explicitly with `dtype=np.int64`.

### The shape-tuple trap

This is one of the most common first-week NumPy errors. Can you spot what's wrong before you run it?

```python run error
grid = np.zeros(3, 4)
```

`np.zeros` takes the shape as **one** argument. Here `3` was read as the shape and `4` as the *second* parameter, `dtype`. NumPy has no idea what data type "4" is, hence the cryptic message. The fix is a pair of parentheses: `np.zeros((3, 4))`.

> **Pitfall:** `np.zeros(3, 4)` fails, but `np.random.rand(3, 4)` works. Some older functions take the dimensions as separate arguments. Modern NumPy consistently uses a shape tuple, so make that your habit.

```python predict id=predict-default-dtype title="What dtype does np.zeros give you?"
a = np.zeros((2, 3))
print(a.dtype)
--- options
int64
* float64
int32
bool
--- explain
Unless you pass `dtype=`, `np.zeros`, `np.ones` and `np.empty` all produce **`float64`**, the double-precision floating point type that NumPy uses by default for numerical work.
```

```python exercise id=scoreboard title="Set up a scoreboard"
# A tournament has 4 players who each play 3 rounds.
# Create `board`: one row per player, one column per round,
# every score starting at 0, stored as integers.
board = ...
--- solution
board = np.zeros((4, 3), dtype=int)
--- test
assert board is not ..., "Replace the `...` with a call to a NumPy factory function."
assert isinstance(board, np.ndarray), f"`board` should be a NumPy array, not {type(board).__name__}."
assert board.shape == (4, 3), f"`board` should have shape (4, 3), one row per player and one column per round, but it has shape {board.shape}."
assert np.issubdtype(board.dtype, np.integer), f"Scores should be stored as integers, but `board` has dtype {board.dtype}. Pass `dtype=int`."
assert (board == 0).all(), "Every score should start at 0."
--- hint
You need a 2-D array of zeros. Remember the shape goes in as a single tuple: `(rows, columns)`.
--- hint
`np.zeros((rows, cols), dtype=...)`. Which dtype stores whole numbers?
```

## `full`: any constant you like

When the starting value isn't 0 or 1, use `np.full(shape, fill_value)`. A very common pattern is filling with **`np.nan`** ("not a number") to mean *missing*. Then any value you never fill in stands out instead of silently pretending to be a real 0.

```python run
print(np.full((2, 3), 7.5))
print()

# Hourly sensor readings, none received yet
readings = np.full(6, np.nan)
readings[2] = 21.4
readings
```

`np.full` infers the dtype from the fill value: `7.5` gives floats, `True` gives booleans, and `np.nan` is a float, so it gives `float64`. As always, you can override it with `dtype=`.

```python exercise id=missing-day title="Mark a week of missing data"
# Build `week`: a 7 x 24 array (days x hours) of temperature readings
# where every entry starts as missing (NaN).
# Then record one real reading: day 0, hour 9 was 18.5 degrees.
week = ...
--- solution
week = np.full((7, 24), np.nan)
week[0, 9] = 18.5
--- test
assert week is not ..., "Replace the `...` with an array built by `np.full`."
assert isinstance(week, np.ndarray), f"`week` should be a NumPy array, not {type(week).__name__}."
assert week.shape == (7, 24), f"`week` should have shape (7, 24), days by hours, but it has shape {week.shape}."
assert np.issubdtype(week.dtype, np.floating), f"`week` needs a float dtype to hold NaN, but it has {week.dtype}."
assert week[0, 9] == 18.5, f"The reading at day 0, hour 9 should be 18.5, but it is {week[0, 9]}."
assert np.isnan(week).sum() == 7 * 24 - 1, f"Every other entry should still be NaN; found {np.isnan(week).sum()} NaNs instead of {7 * 24 - 1}."
--- hint
`np.full(shape, value)` fills an array with any value. NumPy's missing-value marker is `np.nan`.
--- hint
After creating the array, assign to a single element with `week[day, hour] = value`.
```

## `empty`: fast, but full of garbage

`np.empty(shape)` allocates memory **without initializing it**. It's marginally faster than `zeros` because it skips writing anything, but the array contains whatever bytes were lying around in memory:

```python run
junk = np.empty(5)
print("Whatever was in memory:", junk)

# Only safe when you overwrite every element before reading:
squares = np.empty(5)
for i in range(5):
    squares[i] = i ** 2
squares
```

The values in `junk` might look like zeros, tiny numbers like `6.9e-310`, or leftovers from a previous calculation, and they can change from run to run.

> **Pitfall:** Never use `np.empty` for accumulators (`total += ...`) or anything you might only partly fill. Bugs caused by garbage values are maddening because they appear and disappear at random. When in doubt, use `np.zeros`; the speed difference almost never matters.

## Identity and diagonal matrices

Linear algebra constantly needs the **identity matrix**, which has ones on the main diagonal and zeros elsewhere. Multiplying by it leaves a vector unchanged, the matrix equivalent of multiplying by 1.

```python run
print(np.eye(3))
print()
print(np.eye(4, k=1))   # shift the diagonal up by one
print()
print(np.eye(2, 3))     # eye also does rectangular matrices
```

`np.identity(n)` is the same as `np.eye(n)` but always square, with no `k` option. Then there's `np.diag`, which works **in both directions**:

```python run
D = np.diag([2.0, 4.0, 6.0])     # 1-D in → 2-D diagonal matrix out
print(D)
print()

M = np.array([[1, 2, 3],
              [4, 5, 6],
              [7, 8, 9]])
print("Diagonal of M:", np.diag(M))   # 2-D in → 1-D diagonal out
```

> **In the wild:** `np.eye(num_classes)[labels]` is a classic one-liner for one-hot encoding class labels in machine learning. You'll see why it works in the fancy-indexing lesson.

```python predict id=predict-eye-sum title="How many ones?"
a = np.eye(3, k=-1)
print(a.sum())
--- options
3.0
* 2.0
1.0
0.0
--- explain
`k=-1` moves the diagonal **one step below** the main diagonal. In a 3×3 matrix that diagonal only has two positions, `[1, 0]` and `[2, 1]`, so the array holds two ones. The sum is a float (`2.0`) because `eye` returns `float64`.
```

```python exercise id=build-matrices title="Build three special matrices"
# 1. `I`: the 3 x 3 identity matrix
# 2. `D`: a diagonal matrix with 2, 4, 6 on its diagonal
# 3. `S`: a 4 x 4 "shift" matrix with ones just ABOVE the main diagonal
I = ...
D = ...
S = ...
--- solution
I = np.eye(3)
D = np.diag([2, 4, 6])
S = np.eye(4, k=1)
--- test
for name, value in [("I", I), ("D", D), ("S", S)]:
    assert value is not ..., f"Replace the `...` after `{name} =` with your code."
    assert isinstance(value, np.ndarray), f"`{name}` should be a NumPy array, not {type(value).__name__}."
assert I.shape == (3, 3) and np.array_equal(I, np.identity(3)), "`I` should be the 3 x 3 identity: ones on the diagonal, zeros elsewhere."
assert D.shape == (3, 3), f"`D` should be 3 x 3 but has shape {D.shape}. Pass the diagonal values as a 1-D list."
assert np.array_equal(np.diag(D), [2, 4, 6]), f"`D` should have 2, 4, 6 on its diagonal, but it has {np.diag(D)}."
assert np.count_nonzero(D) == 3, "`D` should be zero everywhere off the diagonal."
assert S.shape == (4, 4), f"`S` should be 4 x 4 but has shape {S.shape}."
assert S.sum() == 3 and all(S[i, i + 1] == 1 for i in range(3)), "`S` needs ones on the diagonal just above the main one, at positions (0,1), (1,2), (2,3). Check the sign of `k`."
--- hint
All three can be built with `np.eye` and `np.diag`. Look back at the examples above.
--- hint
`np.diag` turns a list into a diagonal matrix. For `S`, `np.eye` takes a `k=` argument: positive `k` moves the diagonal up.
```

## `*_like`: match an existing array

Often you want a new array with **the same shape and dtype** as one you already have. Instead of writing `np.zeros(data.shape, dtype=data.dtype)`, use the `_like` family: `zeros_like`, `ones_like`, `full_like` and `empty_like`.

```python run
pixels = np.array([[12, 200, 37],
                   [90, 255, 0]], dtype=np.uint8)

mask = np.zeros_like(pixels)
print(mask.shape, mask.dtype)

halfway = np.full_like(pixels, 127)
print(halfway)
```

Copying the dtype is exactly what you want most of the time, and exactly what bites you the rest of the time. If the original array holds integers, the new one does too, and any fractions you store in it are **silently truncated**:

```python run
counts = np.array([3, 1, 4])
fractions = np.zeros_like(counts)
fractions[0] = 0.75          # stored into an integer array!
print(fractions)

print(np.zeros_like(counts, dtype=float))   # override the dtype when you need to
```

```python debug id=probabilities-zero title="All the probabilities are zero"
# Convert word counts into probabilities that sum to 1.
counts = np.array([30, 50, 20])

probs = np.zeros_like(counts)
for i in range(len(counts)):
    probs[i] = counts[i] / counts.sum()

print("probabilities:", probs)
print("sum:", probs.sum())
--- solution
counts = np.array([30, 50, 20])

probs = np.zeros_like(counts, dtype=float)
for i in range(len(counts)):
    probs[i] = counts[i] / counts.sum()

print("probabilities:", probs)
print("sum:", probs.sum())
--- test
assert isinstance(probs, np.ndarray), "`probs` should still be a NumPy array."
assert np.issubdtype(probs.dtype, np.floating), f"`probs` has dtype {probs.dtype}, so every fraction gets truncated to 0. It needs a floating-point dtype."
assert probs.shape == (3,), f"`probs` should have shape (3,) but has {probs.shape}."
assert np.allclose(probs, [0.3, 0.5, 0.2]), f"`probs` should be [0.3, 0.5, 0.2] but is {probs}."
assert np.isclose(probs.sum(), 1.0), "The probabilities should sum to 1."
--- hint
Run it and look at the output. Then ask: what dtype does `np.zeros_like(counts)` produce, given what `counts` contains?
--- hint
`zeros_like` copies the dtype of its input. Each `0.3` stored into an integer array becomes `0`. Override the dtype with `dtype=float`.
```

> **Under the hood:** this loop is deliberately slow and un-NumPy-like. The vectorized version is simply `probs = counts / counts.sum()`. Division of integer arrays always produces floats, so the bug can't even happen. You'll learn to write code like that in the vectorization section.

## Cheat sheet

| You want… | Use |
|---|---|
| All zeros / ones | `np.zeros(shape)`, `np.ones(shape)` |
| Any constant (often `np.nan`) | `np.full(shape, value)` |
| Uninitialized memory you will fully overwrite | `np.empty(shape)` |
| Identity / shifted diagonal | `np.eye(n, k=...)`, `np.identity(n)` |
| Diagonal matrix ↔ diagonal vector | `np.diag(v)`, `np.diag(M)` |
| Same shape & dtype as `x` | `np.zeros_like(x)`, `np.full_like(x, v)`, … |

## Recap

- Shapes are passed as **one argument**: an int, or a tuple like `(3, 4)`. `np.zeros(3, 4)` is an error.
- Factories default to `float64`; use `dtype=` to choose integers, booleans or anything else.
- `np.full(shape, np.nan)` is the idiomatic way to start with "missing" values.
- `np.empty` is uninitialized garbage. Only use it when you overwrite every element.
- `np.eye` and `np.diag` build identity and diagonal matrices; `np.diag` also extracts diagonals.
- `*_like` functions copy shape **and dtype**, so watch out for integer truncation.

**Up next:** sequences and grids with `arange`, `linspace` and `meshgrid`, plus why `arange` with float steps can surprise you.
