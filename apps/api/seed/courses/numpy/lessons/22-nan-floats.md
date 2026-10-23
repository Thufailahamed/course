Real data is messy. Sensors drop out, survey answers are left blank, and a division somewhere quietly produces infinity. NumPy represents these gaps with special floating-point values, **NaN** ("not a number") and **inf**. They behave in ways that surprise almost everyone the first time.

In this lesson you'll learn to detect, summarise and repair missing values, and you'll meet the floating-point traps behind a whole category of "but the numbers look equal!" bugs. By the end you'll write numeric code that survives contact with real-world data.

## Meet NaN and infinity

`np.nan` and `np.inf` are ordinary `float64` values with special meanings. Infinity comes from overflow or division by zero. NaN comes from undefined operations like `0 / 0` or `inf - inf`, and it's also the conventional marker for "missing".

```python run
import numpy as np

print("nan:", np.nan, type(np.nan).__name__)
print("inf:", np.inf, "  -inf:", -np.inf)
print("inf + 1   =", np.inf + 1)
print("inf - inf =", np.inf - np.inf)
print("0 * inf   =", 0 * np.inf)
np.array([1.0, np.nan, np.inf, -np.inf])
```

The key property of NaN: **it poisons everything it touches.** Any arithmetic involving NaN produces NaN, and so does any summary that includes one.

```python run
readings = np.array([21.5, 22.0, np.nan, 23.1, 22.4])

print("sum: ", readings.sum())
print("mean:", readings.mean())
print("max: ", readings.max())
```

One missing reading wiped out every statistic. That's deliberate: NumPy refuses to pretend it knows a value it doesn't. Your job is to decide what "missing" should mean.

## NaN is not equal to itself

This is the single most surprising rule in floating point, and it's mandated by the IEEE 754 standard. NaN compares as *unequal to everything, including itself.*

```python run
x = np.nan
print("x == x:      ", x == x)
print("x != x:      ", x != x)
print("np.isnan(x): ", np.isnan(x))

values = np.array([1.0, np.nan, 3.0])
print("values == np.nan:", values == np.nan)
print("np.isnan(values):", np.isnan(values))
```

So `values == np.nan` can **never** find missing values. It's always all `False`. Always use the dedicated tests:

| Function | True where the value is… |
|---|---|
| `np.isnan(a)` | NaN |
| `np.isinf(a)` | `+inf` or `-inf` |
| `np.isfinite(a)` | a normal number (not NaN, not ±inf) |
| `np.isposinf(a)` / `np.isneginf(a)` | `+inf` / `-inf` specifically |

> **Pitfall:** `if value == np.nan:` is a classic silent bug. It never triggers, so your "missing value" branch is dead code. Linters flag it; reviewers miss it.

```python predict id=predict-nan-count title="How many matches?"
data = np.array([np.nan, 2.0, np.nan, 4.0])
print((data == np.nan).sum(), np.isnan(data).sum())
--- options
2 2
* 0 2
0 0
2 0
--- explain
`data == np.nan` is `False` everywhere because NaN never equals anything, so its sum is `0`. `np.isnan` correctly finds the **2** missing values. Summing a boolean array counts the `True`s.
```

## NaN-aware statistics

NumPy ships a family of functions that **skip** NaN instead of propagating it. Same names, with a `nan` prefix:

```python run
readings = np.array([21.5, 22.0, np.nan, 23.1, 22.4])

print("nanmean:", np.nanmean(readings))
print("nansum: ", np.nansum(readings))
print("nanmax: ", np.nanmax(readings))
print("nanstd: ", round(np.nanstd(readings), 4))
print("valid count:", np.count_nonzero(~np.isnan(readings)))
```

They also take `axis`, which is perfect for tables where each column has its own gaps:

```python run
# rows = days, columns = three weather stations
table = np.array([
    [14.2, np.nan, 15.1],
    [13.8, 12.9,   np.nan],
    [np.nan, 13.4, 15.6],
    [14.9, 13.1,   15.0],
])
print("per-station mean:", np.nanmean(table, axis=0).round(2))
print("per-day max:     ", np.nanmax(table, axis=1))
```

> **Under the hood:** `np.nanmean(a)` is equivalent to `a[~np.isnan(a)].mean()` for a 1-D array, but it handles `axis` for you and never materialises the filtered copy row by row.

```python exercise id=station-averages title="Average each station, ignoring gaps"
# Each column is a sensor; NaN marks a missed reading.
temps = np.array([
    [20.1, 19.8, np.nan, 21.0],
    [20.4, np.nan, 18.9, 21.3],
    [np.nan, 19.5, 19.1, 20.8],
    [20.0, 19.9, 19.4, np.nan],
])

# TODO 1: `station_mean`: the mean of each column, ignoring NaN (shape (4,))
station_mean = ...

# TODO 2: `missing_per_station`: how many NaNs each column has (shape (4,), integers)
missing_per_station = ...
--- solution
temps = np.array([
    [20.1, 19.8, np.nan, 21.0],
    [20.4, np.nan, 18.9, 21.3],
    [np.nan, 19.5, 19.1, 20.8],
    [20.0, 19.9, 19.4, np.nan],
])

station_mean = np.nanmean(temps, axis=0)
missing_per_station = np.isnan(temps).sum(axis=0)
--- test
assert station_mean is not ..., "Replace the `...` after `station_mean =` with your code."
assert missing_per_station is not ..., "Replace the `...` after `missing_per_station =` with your code."
station_mean = np.asarray(station_mean)
assert station_mean.shape == (4,), f"`station_mean` should have one value per column, shape (4,), but has shape {station_mean.shape}. Check your axis."
assert not np.isnan(station_mean).any(), "`station_mean` still contains NaN. Use a NaN-aware function so missing readings are skipped."
expected = np.array([np.mean([20.1, 20.4, 20.0]), np.mean([19.8, 19.5, 19.9]), np.mean([18.9, 19.1, 19.4]), np.mean([21.0, 21.3, 20.8])])
assert np.allclose(station_mean, expected), f"`station_mean` should be {expected.round(3)} but is {station_mean.round(3)}."
missing_per_station = np.asarray(missing_per_station)
assert missing_per_station.shape == (4,), f"`missing_per_station` should have shape (4,) but has {missing_per_station.shape}."
assert np.array_equal(missing_per_station, [1, 1, 1, 1]), f"Each column has exactly one NaN, but you got {missing_per_station}."
--- hint
There's a `nan`-prefixed version of `mean`. Columns run along `axis=0`.
--- hint
To count NaNs, build a boolean mask with `np.isnan(temps)` and sum it down the columns.
```

## Repairing missing data

Skipping NaN is one strategy. Often you need a complete array, for example to feed a model. Common repairs:

```python run
signal = np.array([3.0, np.nan, 4.5, np.nan, np.nan, 6.0])

# 1. Drop missing values
print("dropped: ", signal[~np.isnan(signal)])

# 2. Fill with a constant (or the mean of the valid values)
print("filled 0:", np.nan_to_num(signal, nan=0.0))
print("mean fill:", np.where(np.isnan(signal), np.nanmean(signal), signal))

# 3. Linear interpolation from the neighbouring valid points
idx = np.arange(signal.size)
ok = ~np.isnan(signal)
print("interp:  ", np.interp(idx, idx[ok], signal[ok]))
```

`np.nan_to_num` can also replace infinities (`posinf=`, `neginf=`), and `np.where(mask, replacement, original)` is the general-purpose "fix these positions" tool.

> **In the wild:** pandas' `fillna`, `dropna` and `interpolate` are thin, friendly wrappers around exactly these NumPy operations, and pandas uses NaN as its missing marker for float columns.

```python exercise id=fill-column-means title="Impute with column means"
# Rows are patients, columns are lab measurements. Fill each NaN
# with the mean of the *valid* values in its own column.
labs = np.array([
    [5.1, 140.0, np.nan],
    [4.8, np.nan, 0.9],
    [np.nan, 138.0, 1.1],
    [5.5, 142.0, 1.0],
])

# TODO: build `filled`, a copy of `labs` with no NaN left.
# Don't modify `labs` itself.
filled = ...
--- solution
labs = np.array([
    [5.1, 140.0, np.nan],
    [4.8, np.nan, 0.9],
    [np.nan, 138.0, 1.1],
    [5.5, 142.0, 1.0],
])

col_means = np.nanmean(labs, axis=0)
filled = np.where(np.isnan(labs), col_means, labs)
--- test
assert filled is not ..., "Replace the `...` after `filled =` with your code."
filled = np.asarray(filled, dtype=float)
assert filled.shape == (4, 3), f"`filled` should keep the shape (4, 3) but has {filled.shape}."
assert not np.isnan(filled).any(), "`filled` still contains NaN values."
assert np.isnan(labs).sum() == 3, "Don't modify `labs` in place. Build a new array (np.where returns one)."
means = np.array([np.mean([5.1, 4.8, 5.5]), np.mean([140.0, 138.0, 142.0]), np.mean([0.9, 1.1, 1.0])])
expected = np.where(np.isnan(labs), means, labs)
assert np.allclose(filled[~np.isnan(labs)], labs[~np.isnan(labs)]), "Valid (non-NaN) values must stay exactly as they were."
assert np.allclose(filled, expected), f"Each NaN should become its column's mean {means.round(3)}. Got:\n{filled.round(3)}"
--- hint
First compute one mean per column with `np.nanmean(labs, axis=0)`. That gives shape `(3,)`.
--- hint
`np.where(np.isnan(labs), col_means, labs)` broadcasts the `(3,)` means across every row: NaN positions take the mean, everything else keeps its value.
```

## Division by zero: silent infinities

Plain Python raises `ZeroDivisionError`. NumPy arrays follow the IEEE floating-point rules instead: `x / 0` is `±inf`, `0 / 0` is `nan`, and the computation **keeps going**.

```python run
num = np.array([1.0, -2.0, 0.0, 4.0])
den = np.array([2.0, 0.0, 0.0, 8.0])

ratio = num / den
print("ratio:", ratio)
print("finite?", np.isfinite(ratio))
print("sqrt(-1):", np.sqrt(np.array([-1.0])))
print("float32 overflow:", np.float32(3e38) * np.float32(10))
```

No error and no message: `inf` and `nan` just flow quietly into whatever comes next. That's why careful numeric code **checks its own results** with `np.isfinite` rather than hoping something would have complained.

> **On your desktop:** regular NumPy also prints a `RuntimeWarning: divide by zero encountered…` for the cell above. In this browser runtime the warning never appears, because WebAssembly has no floating-point exception flags. Either way, a warning scrolling past in a log is easy to miss. On desktop, `with np.errstate(divide="ignore", invalid="ignore"):` silences expected warnings for one block, and `np.errstate(divide="raise")` turns them into exceptions. Avoid `np.seterr(all="ignore")` at module level, because it hides real bugs everywhere.

The robust pattern: decide what a bad division *should* produce, then either repair the result or never compute it.

```python run
num = np.array([1.0, -2.0, 0.0, 4.0])
den = np.array([2.0, 0.0, 0.0, 8.0])

# Repair afterwards: replace anything non-finite
ratio = num / den
print("repaired: ", np.where(np.isfinite(ratio), ratio, 0.0))

# Or avoid the bad division entirely: only divide where den != 0
print("out/where:", np.divide(num, den, out=np.zeros_like(num), where=den != 0))
```

The `where=` argument tells the ufunc which positions to compute, and `out=` supplies the values for the positions it skips.

> **Pitfall:** always pass `out=` together with `where=`. Without it, the skipped slots contain whatever happened to be in memory.

## Comparing floats: never use `==`

Most decimal fractions can't be represented exactly in binary. `0.1` is really `0.1000000000000000055511…`. Errors are tiny but real, and they break exact equality:

```python run
print("0.1 + 0.2 == 0.3:", 0.1 + 0.2 == 0.3)
print("0.1 + 0.2 =", repr(0.1 + 0.2))

a = np.array([0.1 + 0.2, 1 / 3 * 3, np.sqrt(2) ** 2])
b = np.array([0.3, 1.0, 2.0])
print("a == b:          ", a == b)
print("np.isclose(a, b):", np.isclose(a, b))
print("np.allclose(a, b):", np.allclose(a, b))
```

`np.isclose(a, b)` is true when $|a - b| \le \text{atol} + \text{rtol} \cdot |b|$, with defaults `rtol=1e-05` and `atol=1e-08`.

- **rtol** (relative) scales with the magnitude, which is good for large numbers.
- **atol** (absolute) is a floor for values near zero, where relative error is meaningless.

```python run
big = 1_000_000.0
print("isclose(1e6, 1e6 + 1):", np.isclose(big, big + 1))   # relative diff 1e-6 < rtol
print("isclose(1e-9, 2e-9):  ", np.isclose(1e-9, 2e-9))     # both below atol
print("…with atol=0:         ", np.isclose(1e-9, 2e-9, atol=0))
print("NaN vs NaN:           ", np.isclose(np.nan, np.nan), np.isclose(np.nan, np.nan, equal_nan=True))
```

> **Pitfall:** the default `atol=1e-08` means *every* pair of numbers smaller than about `1e-8` is "close", so `1e-9` and `2e-9` compare equal even though one is twice the other. When you work with tiny quantities (probabilities, gradients), set `atol` deliberately.

```python debug id=converged-check title="The optimizer never converges"
# Gradient descent on f(x) = (x - 0.3)**2 ; it should stop near x = 0.3
x = 0.0
learning_rate = 0.1
steps = 0

while steps < 500:
    x = x - learning_rate * 2 * (x - 0.3)
    steps += 1
    if x == 0.3:          # stop once we've reached the minimum
        break

converged = steps < 500
print(f"x = {x!r} after {steps} steps, converged={converged}")
--- solution
# Gradient descent on f(x) = (x - 0.3)**2 ; it should stop near x = 0.3
x = 0.0
learning_rate = 0.1
steps = 0

while steps < 500:
    x = x - learning_rate * 2 * (x - 0.3)
    steps += 1
    if np.isclose(x, 0.3):          # stop once we've reached the minimum
        break

converged = steps < 500
print(f"x = {x!r} after {steps} steps, converged={converged}")
--- test
assert converged, f"The loop still ran all {steps} steps. The stopping condition never fired."
assert abs(x - 0.3) < 1e-4, f"`x` should end very close to 0.3 but is {x!r}."
assert steps < 120, f"It took {steps} steps. Use a tolerance-based comparison so it stops as soon as x is close to 0.3."
--- hint
Run it: `x` gets *extremely* close to 0.3. Why does the `if` never fire?
--- hint
Floating-point results almost never land exactly on a decimal like 0.3. Compare with a tolerance (`np.isclose`) instead of `==`.
```

## Catastrophic cancellation and summation

Subtracting two nearly-equal numbers wipes out most of their significant digits. This is **catastrophic cancellation**. A float64 carries about 16 significant digits; if two numbers agree in the first 12, their difference has only about 4 left.

```python run
# Variance via the "textbook shortcut"  E[x²] - E[x]²  vs the stable two-pass formula
data = 1e9 + np.array([4.0, 7.0, 13.0, 16.0])   # true variance = 22.5

shortcut = np.mean(data**2) - np.mean(data) ** 2
two_pass = np.mean((data - data.mean()) ** 2)
print("shortcut:", shortcut)
print("two-pass:", two_pass)
print("np.var:  ", np.var(data))
```

The shortcut subtracts two numbers around `1e18` and returns a **negative variance**, which is mathematically impossible. `np.var` centres the data first, so it gets the right answer. Precision also matters when adding many numbers:

```python run
values = np.full(1_000_000, 0.1, dtype=np.float32)

print("float32 naive loop-style:", np.cumsum(values)[-1])
print("float32 np.sum (pairwise):", values.sum())
print("float64 np.sum:          ", values.astype(np.float64).sum())
```

`np.cumsum` accumulates strictly left-to-right, so rounding errors pile up. `np.sum` uses **pairwise summation**, which is far more accurate, and switching to float64 helps even more. (The float64 total is not exactly 100000 because `0.1` itself was rounded when stored as float32.)

> **Tip:** if a result depends on subtracting nearly-equal quantities, rearrange the math, for instance by subtracting the mean first. Library functions like `np.var`, `np.std`, `np.logaddexp` and `np.log1p` exist precisely to avoid these traps.

## Integer arrays can't hold NaN

NaN is a *float* concept. There's no integer bit pattern for "missing", so integer arrays can't store it:

```python run error
counts = np.array([3, 5, 2, 8])
print(counts.dtype)
counts[1] = np.nan
```

```python run
counts = np.array([3, 5, 2, 8])
as_float = counts.astype(float)      # promote first
as_float[1] = np.nan
print(as_float, as_float.dtype)

# A NaN can also sneak in through ordinary math: int / int is float
print(np.array([1, 2]) / np.array([0, 2]))
```

> **In the wild:** this is why a pandas integer column silently becomes `float64` the moment a value goes missing (unless you opt into pandas' nullable `Int64` type).

```python debug id=missing-sentinel title="Missing values counted as real data"
# A survey stored "no answer" as -1. Compute the average rating (1-5)
# over people who actually answered, and how many skipped.
raw = np.array([4, -1, 5, 3, -1, 2, 5, -1])

ratings = raw.copy()
ratings[ratings == -1] = 0        # mark missing

answered = ratings.size
average = ratings.mean()
print(f"{answered} answers, average {average:.2f}")
--- solution
# A survey stored "no answer" as -1. Compute the average rating (1-5)
# over people who actually answered, and how many skipped.
raw = np.array([4, -1, 5, 3, -1, 2, 5, -1])

ratings = raw.astype(float)
ratings[ratings == -1] = np.nan   # mark missing

answered = np.count_nonzero(~np.isnan(ratings))
average = np.nanmean(ratings)
print(f"{answered} answers, average {average:.2f}")
--- test
assert answered == 5, f"Five people answered, but `answered` is {answered}."
assert np.isclose(average, 3.8), f"The average of the real answers (4, 5, 3, 2, 5) is 3.8, but `average` is {average}."
assert "3.80" in _stdout, "Keep the print so the result is shown."
--- hint
Replacing "missing" with `0` makes it look like a real (terrible) rating. What value means "missing" in NumPy?
--- hint
You can't put NaN into an integer array. Convert with `.astype(float)` first, then use NaN-aware functions for the count and the mean.
```

```python exercise id=safe-growth title="Safe percentage change"
# Week-over-week revenue. Some weeks had zero revenue (store closed).
previous = np.array([200.0, 0.0, 150.0, 0.0, 80.0])
current = np.array([220.0, 50.0, 120.0, 0.0, 100.0])

# TODO: `growth` = (current - previous) / previous, as a percentage (* 100).
# Wherever `previous` is 0, the growth is undefined: put NaN there
# (no inf allowed in the result).
growth = ...
--- solution
previous = np.array([200.0, 0.0, 150.0, 0.0, 80.0])
current = np.array([220.0, 50.0, 120.0, 0.0, 100.0])

growth = np.divide(current - previous, previous, out=np.full_like(previous, np.nan), where=previous != 0) * 100
--- test
assert growth is not ..., "Replace the `...` after `growth =` with your code."
growth = np.asarray(growth, dtype=float)
assert growth.shape == (5,), f"`growth` should have shape (5,) but has {growth.shape}."
assert np.array_equal(np.isnan(growth), previous == 0), f"NaN should appear exactly where `previous` is 0. Got {growth}."
assert np.allclose(growth[previous != 0], [10.0, -20.0, 25.0]), f"Growth for the valid weeks should be [10, -20, 25] percent, got {growth[previous != 0]}."
assert not np.isinf(growth).any(), "`growth` contains infinity. Replace those positions with NaN."
--- hint
Dividing by zero silently produces `inf` (or `nan` for 0/0). Those positions need to end up as NaN.
--- hint
Either divide and then set `growth[previous == 0] = np.nan`, or never divide there: `np.divide(..., out=np.full_like(previous, np.nan), where=previous != 0)`.
```

## Recap

- `np.nan` marks missing or undefined values, and it propagates through every calculation.
- NaN is never equal to anything, even itself. Detect it with `np.isnan`, `np.isinf` and `np.isfinite`, never `==`.
- `np.nanmean`, `np.nansum`, `np.nanmax` and friends skip NaN, and they support `axis`.
- Repair gaps with boolean masks, `np.where`, `np.nan_to_num` or `np.interp`.
- Division by zero silently gives `inf`/`nan`. Check results with `np.isfinite`, or divide only where it's safe with `where=` and `out=`.
- Compare floats with `np.isclose`/`np.allclose` and think about `rtol` and `atol`. Beware cancellation, and prefer float64 for long sums.

**Up next:** images are just arrays. You'll crop, flip, recolor and blur pictures using nothing but NumPy.
