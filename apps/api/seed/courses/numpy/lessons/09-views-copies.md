Here's a bug that has cost data scientists entire afternoons. You take the first few rows of a dataset, normalize them for a quick experiment… and later discover your *original* dataset changed too. No error, no warning, just quietly wrong numbers flowing into everything downstream.

The cause is one of NumPy's best features: **slicing doesn't copy data.** A slice is a *view*, a new window onto the same memory. In this lesson you'll learn exactly which operations create views and which create copies, how to check, and how to write code that never surprises you.

## A slice is a window, not a copy

Watch what happens to `prices` when we change `first_three`:

```python run
import numpy as np

prices = np.array([10.0, 20.0, 30.0, 40.0, 50.0])
first_three = prices[:3]

first_three[0] = 999.0
print("first_three:", first_three)
print("prices:     ", prices)        # changed too!
```

`first_three` never had its own numbers. It's a little header saying "start at the beginning of `prices`' memory and show 3 elements". Write through it, and you write into `prices`.

```text
prices        →  [ 999 | 20 | 30 | 40 | 50 ]   one block of memory
first_three   →  [ 999 | 20 | 30 ]             same memory, shorter window
```

### Why NumPy works this way

Views make slicing **instant and free**, no matter how big the array is. Taking a slice of the 4-million-element array below doesn't copy 32 MB of data; it just creates a tiny new header. That's why NumPy can chew through huge datasets, and it's also how libraries like pandas and PyTorch avoid copying your data behind your back.

```python run
import time

big = np.zeros(4_000_000)

t = time.perf_counter(); window = big[1000:3_000_000]; t_view = time.perf_counter() - t
t = time.perf_counter(); copied = big[1000:3_000_000].copy(); t_copy = time.perf_counter() - t

print(f"view: {t_view * 1e6:8.1f} µs   (no data moved)")
print(f"copy: {t_copy * 1e6:8.1f} µs   ({copied.nbytes / 1e6:.0f} MB moved)")
```

## How to tell: `.base` and `np.shares_memory`

Two tools tell you whether arrays share data:

- `b.base` is the array that `b` borrows its memory from, or `None` if `b` owns its data.
- `np.shares_memory(a, b)` answers directly: do these two arrays overlap in memory?

```python run
a = np.arange(10)
s = a[2:6]
c = a[2:6].copy()

print("s.base is a:        ", s.base is a)
print("c.base:             ", c.base)
print("shares_memory(a, s):", np.shares_memory(a, s))
print("shares_memory(a, c):", np.shares_memory(a, c))
```

> **Tip:** When you're unsure, don't guess. `np.shares_memory(original, result)` takes one line and settles it.

## `.copy()`: when you want your own data

If you're going to modify a piece of an array and you need the original untouched, take an explicit copy:

```python run
scores = np.array([72, 85, 90, 64, 88])

top = scores[1:4].copy()   # independent
top[:] = 0
print("top:   ", top)
print("scores:", scores)   # unchanged
```

```python exercise id=independent-crop title="Crop without damaging the original"
image = np.arange(1, 26).reshape(5, 5)   # a tiny 5x5 "image"

# TODO: make `crop` the 3x3 centre of `image` (rows 1-3, columns 1-3)
# as an INDEPENDENT array, then blank it out by setting all of crop to 0.
# `image` must stay exactly as it was.
crop = ...

print(crop)
print(image)
--- solution
image = np.arange(1, 26).reshape(5, 5)

crop = image[1:4, 1:4].copy()
crop[:] = 0

print(crop)
print(image)
--- test
assert crop is not ..., "Replace the `...` after `crop =` with a slice of `image`."
assert isinstance(crop, np.ndarray), "`crop` should be a NumPy array."
assert crop.shape == (3, 3), f"`crop` should be the 3x3 centre, but has shape {crop.shape}. Rows 1-3 are the slice `1:4`."
assert np.array_equal(image, np.arange(1, 26).reshape(5, 5)), "`image` was modified! Your crop is still a view into it. Make it independent first."
assert not np.shares_memory(crop, image), "`crop` still shares memory with `image`."
assert np.all(crop == 0), "After cropping, set every value of `crop` to 0."
--- hint
A plain slice is a view, so writing to it writes into `image`. What method gives an array its own memory?
--- hint
Slice the centre with `image[1:4, 1:4]`, call `.copy()` on it, then set `crop[:] = 0`.
```

## Views vs. copies: the cheat sheet

The rule of thumb: **if NumPy can describe the result as a regular pattern of steps through the same memory, you get a view. Otherwise you get a copy.**

| Operation | Result | Why |
|---|---|---|
| `a[2:8]`, `a[::2]`, `a[:, 1]` | **view** | regular strides through the same memory |
| `a.reshape(...)` | view (usually) | same data, new shape |
| `a.T`, `a.transpose()` | **view** | same data, axes swapped |
| `a.ravel()` | view if possible | copies only when it must |
| `a[[0, 2, 4]]` (fancy indexing) | **copy** | arbitrary positions can't be one stride pattern |
| `a[a > 0]` (boolean mask) | **copy** | same reason |
| `a + 1`, `a * b`, `np.sqrt(a)` | **copy** | new values, new memory |
| `a.flatten()`, `a.copy()`, `np.array(a)` | **copy** | always, by design |

```python run
a = np.arange(12).reshape(3, 4)

for label, b in [("a[1:, ::2]", a[1:, ::2]), ("a.T", a.T), ("a.reshape(4, 3)", a.reshape(4, 3)),
                 ("a[[0, 2]]", a[[0, 2]]), ("a[a > 5]", a[a > 5]), ("a * 2", a * 2)]:
    print(f"{label:18} shares memory: {np.shares_memory(a, b)}")
```

```python predict id=predict-mask-copy title="Does the original change?"
a = np.array([1, 2, 3, 4, 5])
big = a[a > 2]
big[0] = 100
print(a)
--- options
[  1   2 100   4   5]
* [1 2 3 4 5]
[100   2   3   4   5]
[100 4 5]
--- explain
Boolean indexing picks arbitrary positions, so NumPy has to gather them into **new memory**. `big` is a copy, and changing it leaves `a` alone. (Assigning *through* a mask, as in `a[a > 2] = 100`, is different: that writes into `a` directly.)
```

```python exercise id=view-or-copy title="View or copy?"
a = np.arange(10)

# TODO: for each expression, write True if the result is a VIEW of `a`
# (shares its memory) or False if it's a COPY. Predict first, then
# verify with np.shares_memory if you like.
answers = {
    "a[3:7]":            ...,
    "a[[1, 3, 5]]":      ...,
    "a.reshape(2, 5)":   ...,
    "a[a % 2 == 0]":     ...,
    "a[::-1]":           ...,
    "a * 1":             ...,
}
--- solution
a = np.arange(10)

answers = {
    "a[3:7]":            True,
    "a[[1, 3, 5]]":      False,
    "a.reshape(2, 5)":   True,
    "a[a % 2 == 0]":     False,
    "a[::-1]":           True,
    "a * 1":             False,
}
--- test
assert isinstance(answers, dict), "`answers` should stay a dictionary."
truth = {"a[3:7]": True, "a[[1, 3, 5]]": False, "a.reshape(2, 5)": True, "a[a % 2 == 0]": False, "a[::-1]": True, "a * 1": False}
missing = [k for k in truth if answers.get(k) is ...]
assert not missing, f"Fill in True or False for: {', '.join(missing)}"
for k, v in answers.items():
    assert isinstance(v, (bool, np.bool_)), f"The answer for `{k}` should be True or False, not {v!r}."
wrong = [k for k in truth if bool(answers.get(k)) != truth[k]]
assert not wrong, f"{len(wrong)} answer(s) are off. Recheck: {', '.join(wrong)}. Try `np.shares_memory(a, <expression>)`."
--- hint
Slices (including negative steps), reshapes and transposes describe a regular walk through the same memory.
--- hint
Fancy indexing (a list of positions), boolean masks and arithmetic always produce new arrays.
```

## Functions that mutate their arguments

Views get more dangerous when they cross a function boundary. NumPy arrays are passed **by reference**, and in-place operators like `-=`, `*=` and `[:] =` write into the caller's array.

```python run
def center_in_place(x):
    x -= x.mean()       # modifies the caller's array!
    return x

def center(x):
    return x - x.mean() # builds a new array; the input is untouched

data = np.array([2.0, 4.0, 6.0])
print("center:         ", center(data), " data:", data)
print("center_in_place:", center_in_place(data), " data:", data)
```

`x -= m` and `x = x - m` look almost identical, but the first **writes into existing memory** while the second creates a new array and rebinds the name `x`. In-place operations save memory, which matters for huge arrays, so use them deliberately and document it. Never use them by accident in a function that "returns" a result.

> **In the wild:** pandas' famous `SettingWithCopyWarning` exists precisely because of this view/copy ambiguity. Knowing the NumPy rules makes that warning make sense.

## Debug challenge: the function that ate the dataset

```python debug id=normalize-mutates title="Scaling corrupts the raw data"
raw = np.array([[ 50.0, 1.2],
                [ 80.0, 3.4],
                [ 65.0, 2.1],
                [ 95.0, 4.8]])

def min_max_scale(x):
    """Return a scaled copy of x, with each column mapped to [0, 1]."""
    x -= x.min(axis=0)
    x /= x.max(axis=0)
    return x

scaled = min_max_scale(raw)
print("scaled:\n", scaled)
print("raw (should be unchanged):\n", raw)
--- solution
raw = np.array([[ 50.0, 1.2],
                [ 80.0, 3.4],
                [ 65.0, 2.1],
                [ 95.0, 4.8]])

def min_max_scale(x):
    """Return a scaled copy of x, with each column mapped to [0, 1]."""
    x = x - x.min(axis=0)
    x = x / x.max(axis=0)
    return x

scaled = min_max_scale(raw)
print("scaled:\n", scaled)
print("raw (should be unchanged):\n", raw)
--- test
original = np.array([[50.0, 1.2], [80.0, 3.4], [65.0, 2.1], [95.0, 4.8]])
assert np.allclose(raw, original), "`raw` was modified by `min_max_scale`. The function should leave its input alone."
assert not np.shares_memory(scaled, raw), "`scaled` shares memory with `raw`, so it's still operating in place."
assert np.allclose(scaled.min(axis=0), 0) and np.allclose(scaled.max(axis=0), 1), "Each column of `scaled` should run from 0 to 1."
probe = np.array([[1.0, 10.0], [3.0, 30.0]])
probe_before = probe.copy()
out = min_max_scale(probe)
assert np.allclose(probe, probe_before), "`min_max_scale` still modifies whatever array you pass in."
assert np.allclose(out, [[0, 0], [1, 1]]), "`min_max_scale` should map each column to [0, 1]."
--- hint
Run it and compare `raw` before and after. The scaling is correct, but the docstring promises a *copy*.
--- hint
`x -= ...` and `x /= ...` write into the caller's array. What's the non-in-place way to write the same arithmetic?
```

## Debug challenge: every snapshot is the same

This one is the "list of views" bug. It shows up in simulations, training loops, and anywhere you save the state of something as it changes.

```python debug id=snapshot-history title="The history only remembers the last step"
# A particle moves by `velocity` each step; we record its position history.
position = np.array([0.0, 0.0])
velocity = np.array([1.0, 0.5])

history = []
for step in range(4):
    history.append(position)
    position += velocity

for i, p in enumerate(history):
    print(f"step {i}: {p}")
--- solution
position = np.array([0.0, 0.0])
velocity = np.array([1.0, 0.5])

history = []
for step in range(4):
    history.append(position.copy())
    position += velocity

for i, p in enumerate(history):
    print(f"step {i}: {p}")
--- test
assert len(history) == 4, f"`history` should have 4 snapshots, has {len(history)}."
expected = [[0.0, 0.0], [1.0, 0.5], [2.0, 1.0], [3.0, 1.5]]
got = [np.asarray(p).tolist() for p in history]
assert len({tuple(p) for p in got}) > 1, "Every snapshot in `history` is identical. They are all the same array object."
assert got == expected, f"`history` should be {expected}, but is {got}."
assert np.allclose(position, [4.0,2.0]), "`position` should end at [4.0, 2.0] after 4 steps."
--- hint
Use **Debug** and watch `history` as the loop runs. Do the earlier entries change when `position` changes?
--- hint
`history.append(position)` stores *the same array object* every time, and `+=` updates it in place. Store a snapshot instead.
```

## Debug challenge: the update that never happens

```python debug id=chained-fancy title="Restocking does nothing"
# Columns: [item_id, quantity]. Restock items in rows 0 and 3 to quantity 50.
inventory = np.array([[101,  3],
                      [102, 40],
                      [103, 17],
                      [104,  0]])

rows_to_restock = [0, 3]
inventory[rows_to_restock][:, 1] = 50

print(inventory)
--- solution
inventory = np.array([[101,  3],
                      [102, 40],
                      [103, 17],
                      [104,  0]])

rows_to_restock = [0, 3]
inventory[rows_to_restock, 1] = 50

print(inventory)
--- test
assert inventory.shape == (4, 2), "`inventory` should still be a 4x2 array."
assert inventory[0, 1] == 50 and inventory[3, 1] == 50, f"Rows 0 and 3 should have quantity 50, but they are {inventory[0, 1]} and {inventory[3, 1]}."
assert inventory[1, 1] == 40 and inventory[2, 1] == 17, "Rows 1 and 2 should be left alone."
assert inventory[:, 0].tolist() == [101, 102, 103, 104], "Item ids in column 0 must not change."
--- hint
Run it: nothing changed, and no error. `inventory[rows_to_restock]` uses a list of rows. Is that a view or a copy?
--- hint
Chained indexing assigns into a temporary copy that's immediately thrown away. Do the whole selection in **one** indexing expression: rows, then column.
```

## Recap

- **Slices, reshapes and transposes are views**: they share memory with the original, so writing through them changes it.
- **Fancy indexing, boolean masks and arithmetic make copies.**
- Check with `np.shares_memory(a, b)` or `b.base`. Use `.copy()` when you need independent data.
- In-place operators (`+=`, `-=`, `[:] =`) modify existing memory, including your caller's arrays.
- Store snapshots with `.copy()`, and never assign through chained fancy indexing. Do it in one bracket expression.

**Up next:** boolean masks, the most expressive way to ask "which elements match?" and then filter, count or fix them.
