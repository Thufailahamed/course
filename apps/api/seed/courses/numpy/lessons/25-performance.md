Why is `a.T` instant on a gigabyte array, while `a.T.copy()` takes a second? Why does `ravel()` sometimes return a view and sometimes a copy? Why can a "rolling window" over a million points cost zero extra memory? It all comes down to one idea: **an array is a flat block of bytes plus a little metadata saying how to walk it.**

This lesson opens the hood. You'll learn to read `strides` and `flags`, understand C and Fortran order, build zero-copy windows with `sliding_window_view`, cut memory with in-place operations and smaller dtypes, and measure speed properly. This is the knowledge that turns "it works" into "it works on the real dataset".

> **A note on numbers:** this lesson uses explicit `dtype=np.int64` / `np.float64` so that every byte count is the same on every machine. (In this browser runtime the *default* integer is 32-bit, which would halve some numbers.)

## An array is a buffer plus metadata

Every ndarray has a contiguous **data buffer** and a few attributes that interpret it:

- `dtype`: how to read each element (here 8-byte integers),
- `shape`: the logical dimensions,
- `strides`: **how many bytes to jump** to move one step along each axis.

```python run
a = np.arange(12, dtype=np.int64).reshape(3, 4)
print(a)
print("shape:   ", a.shape)
print("itemsize:", a.itemsize, "bytes")
print("nbytes:  ", a.nbytes, "bytes")
print("strides: ", a.strides)
```

`strides == (32, 8)` means: to move down one **row**, skip 32 bytes (4 elements × 8 bytes); to move right one **column**, skip 8 bytes. The byte offset of element `a[i, j]` is therefore:

$$\text{offset}(i, j) = i \cdot \text{strides}[0] + j \cdot \text{strides}[1]$$

```python run
i, j = 2, 1
offset = i * a.strides[0] + j * a.strides[1]
flat = a.ravel()                         # the buffer, viewed as 1-D
print("offset:", offset, "bytes = element", offset // a.itemsize, "of the buffer")
print("a[2, 1] =", a[i, j], "   buffer element:", flat[offset // a.itemsize])
```

> **Under the hood:** NumPy indexing is never a search. It's one multiply-add per axis on the strides, which is why `a[i, j]` costs the same on a 10-element array and a 10-billion-element one.

```python exercise id=byte-offset title="Compute a byte offset from strides"
def byte_offset(arr, index):
    """Return the byte offset of arr[index] from the start of arr's data.

    `index` is a tuple with one non-negative integer per axis.
    Use only arr.strides; don't touch the data.
    """
    # TODO
    ...

result = byte_offset(np.zeros((4, 5, 6), dtype=np.float64), (1, 2, 3))
--- solution
def byte_offset(arr, index):
    """Return the byte offset of arr[index] from the start of arr's data."""
    return sum(i * s for i, s in zip(index, arr.strides))

result = byte_offset(np.zeros((4, 5, 6), dtype=np.float64), (1, 2, 3))
--- test
_z = np.zeros((4, 5, 6), dtype=np.float64)
_r = byte_offset(_z, (1, 2, 3))
assert _r is not None, "`byte_offset` returned None. Did you forget `return`?"
assert _r == 1 * 240 + 2 * 48 + 3 * 8, f"For a (4, 5, 6) float64 array, strides are {_z.strides}, so index (1, 2, 3) is at {1*240 + 2*48 + 3*8} bytes; you returned {_r}."
assert byte_offset(_z, (0, 0, 0)) == 0, "Index (0, 0, 0) should be at offset 0."
_t = np.arange(20, dtype=np.int64).reshape(4, 5).T
assert byte_offset(_t, (3, 1)) == 3 * 8 + 1 * 40, f"Your function fails on a transposed array (strides {_t.strides}). Use arr.strides rather than assuming row-major order."
_s = np.arange(100, dtype=np.int32)[::3]
assert byte_offset(_s, (4,)) == 4 * 12, f"Your function fails on a strided slice (strides {_s.strides}). Don't compute strides from the shape yourself."
--- hint
Each axis contributes `index_along_that_axis * stride_of_that_axis`. Add them up.
--- hint
`zip(index, arr.strides)` pairs each index with its stride; `sum(i * s for i, s in ...)` finishes the job.
```

## Transpose is free: it just swaps strides

Transposing doesn't move a single byte. It returns a **view** with the shape and strides reversed:

```python run
a = np.arange(12, dtype=np.int64).reshape(3, 4)
t = a.T
print("a strides:", a.strides, "  t strides:", t.strides)
print("same memory?", np.shares_memory(a, t))
print("a C-contiguous:", a.flags["C_CONTIGUOUS"], " F-contiguous:", a.flags["F_CONTIGUOUS"])
print("t C-contiguous:", t.flags["C_CONTIGUOUS"], " F-contiguous:", t.flags["F_CONTIGUOUS"])
```

The same buffer can be read in two natural orders:

| Order | Last index changes fastest? | Typical source |
|---|---|---|
| **C** (row-major) | yes, rows are contiguous | NumPy's default, C, PyTorch |
| **F** (column-major) | no, columns are contiguous | Fortran, MATLAB, R, LAPACK |

`a.T` of a C-ordered array is exactly an F-ordered array. `np.asfortranarray(a)` and `np.ascontiguousarray(a)` convert between them, copying only if needed.

```python predict id=predict-transpose-strides title="What are the strides?"
grid = np.zeros((4, 5), dtype=np.float64)
print(grid.T.strides)
--- options
(40, 8)
* (8, 40)
(8, 32)
(32, 8)
--- explain
`grid` is C-ordered with strides `(5 × 8, 8) = (40, 8)`. Transposing just reverses the strides, giving `(8, 40)`. No data moves.
```

## When views become copies

Slicing with a step, transposing and many reshapes produce views with unusual strides. They're still views, but they're **not contiguous**. Operations that need a flat, contiguous buffer then have to copy:

```python run
a = np.arange(12, dtype=np.int64).reshape(3, 4)

every_other = a[:, ::2]
print("a[:, ::2] strides:", every_other.strides, " contiguous:", every_other.flags["C_CONTIGUOUS"])

print("a.ravel() shares memory:  ", np.shares_memory(a, a.ravel()))     # contiguous → view
print("a.T.ravel() shares memory:", np.shares_memory(a, a.T.ravel()))   # C-order walk of F data → copy

c = np.ascontiguousarray(every_other)
print("after ascontiguousarray:", c.strides, c.flags["C_CONTIGUOUS"])
```

`ravel()` returns a view when it can and silently copies when it can't. That's convenient, but dangerous if you write to the result and expect the original to change.

> **In the wild:** libraries that call C code (BLAS, image codecs, some PyTorch ops) often require contiguous input and quietly call `ascontiguousarray` for you. If you see unexplained memory spikes, a hidden copy of a transposed or strided array is a prime suspect. PyTorch even has a method for it: `tensor.contiguous()`.

```python debug id=ravel-clamp title="The clamp didn't stick"
# Clamp every value above 5 down to 0, in place.
data = np.arange(12, dtype=np.float64).reshape(3, 4)
grid = data.T                     # (4, 3) view of the same data

flat = grid.ravel()
flat[flat > 5] = 0

print("max after clamp:", grid.max())   # should be 5.0
--- solution
# Clamp every value above 5 down to 0, in place.
data = np.arange(12, dtype=np.float64).reshape(3, 4)
grid = data.T                     # (4, 3) view of the same data

grid[grid > 5] = 0

print("max after clamp:", grid.max())   # should be 5.0
--- test
assert grid.max() == 5.0, f"`grid` still contains values above 5 (max is {grid.max()}). The writes didn't reach `grid`."
assert data.max() == 5.0, "`data` should be clamped too, since `grid` is a view of it."
assert (grid == 0).sum() == 7, f"Exactly 7 values (6 through 11) should become 0, plus the original 0, so 7 zeros in total. Got {(grid == 0).sum()}."
assert np.shares_memory(grid, data), "Keep `grid` as a view of `data`, and modify it in place."
--- hint
Debug it and compare `flat` with `grid` after the assignment. Does `np.shares_memory(grid, flat)` hold?
--- hint
`grid` is a transposed (F-ordered) view, so `ravel()` had to make a **copy**, and you modified the copy. Apply the boolean mask to `grid` directly.
```

## Zero-copy windows with `sliding_window_view`

Because strides are just numbers, you can create views that *revisit* the same bytes. `np.lib.stride_tricks.sliding_window_view` builds every window of a series as a 2-D view, with **no copying at all**:

```python run
from numpy.lib.stride_tricks import sliding_window_view

prices = np.array([10.0, 11.0, 12.5, 12.0, 13.5, 14.0, 13.0, 15.5])
windows = sliding_window_view(prices, 3)

print("windows shape:", windows.shape, " strides:", windows.strides)
print(windows)
print("3-day rolling mean:", windows.mean(axis=1).round(2))
print("shares memory with prices:", np.shares_memory(windows, prices))
```

Both strides are 8 bytes: one step to the next window *and* one step within a window move by a single element. Six windows of three, built from eight numbers, and not a byte copied.

```python predict id=predict-window-shape title="Shape of the windows"
x = np.arange(10, dtype=np.int64)
w = np.lib.stride_tricks.sliding_window_view(x, 4)
print(w.shape, w.strides)
--- options
(10, 4) (8, 8)
* (7, 4) (8, 8)
(7, 4) (32, 8)
(6, 4) (8, 8)
--- explain
A window of 4 fits `10 - 4 + 1 = 7` times. Consecutive windows start one element (8 bytes) apart, and elements within a window are also 8 bytes apart, so the strides are `(8, 8)`.
```

It works in 2-D too: `sliding_window_view(img, (3, 3))` gives shape `(H-2, W-2, 3, 3)`, every 3×3 patch of an image. A blur is then `patches.mean(axis=(2, 3))`.

> **Pitfall:** windows overlap in memory, so **never write** to a sliding-window view; one write changes several windows at once. NumPy marks these views read-only to protect you.

```python exercise id=rolling-stats title="Rolling mean and max"
from numpy.lib.stride_tricks import sliding_window_view

def rolling(x, w):
    """Return (means, maxes) over every window of length w in the 1-D array x.

    Both results have length len(x) - w + 1. Use sliding_window_view (no Python loops).
    """
    # TODO
    ...

result = rolling(np.array([3.0, 1.0, 4.0, 1.0, 5.0, 9.0, 2.0]), 3)
--- solution
from numpy.lib.stride_tricks import sliding_window_view

def rolling(x, w):
    """Return (means, maxes) over every window of length w in the 1-D array x."""
    windows = sliding_window_view(x, w)
    return windows.mean(axis=1), windows.max(axis=1)

result = rolling(np.array([3.0, 1.0, 4.0, 1.0, 5.0, 9.0, 2.0]), 3)
--- test
_out = rolling(np.array([3.0, 1.0, 4.0, 1.0, 5.0, 9.0, 2.0]), 3)
assert _out is not None, "`rolling` returned None. It should return a pair (means, maxes)."
assert len(_out) == 2, "`rolling` should return two arrays: (means, maxes)."
_m, _x = np.asarray(_out[0]), np.asarray(_out[1])
assert _m.shape == (5,), f"With 7 values and w=3 there are 5 windows, but `means` has shape {_m.shape}. Reduce along the window axis (axis=1)."
assert np.allclose(_m, [8/3, 2.0, 10/3, 5.0, 16/3]), f"The rolling means are wrong: {_m.round(3)}."
assert np.array_equal(_x, [4.0, 4.0, 5.0, 9.0, 9.0]), f"The rolling maxes are wrong: {_x}."
_rng = np.random.default_rng(3)
_y = _rng.normal(size=50)
_m2, _x2 = rolling(_y, 7)
assert np.allclose(_m2, np.convolve(_y, np.ones(7) / 7, mode="valid")), "`rolling` gives wrong means for other inputs. Avoid hard-coding the window length."
assert np.allclose(_x2, [_y[i:i + 7].max() for i in range(44)]), "`rolling` gives wrong maxes for other inputs."
--- hint
`sliding_window_view(x, w)` has shape `(len(x) - w + 1, w)`: one row per window.
--- hint
Reduce each row: `.mean(axis=1)` and `.max(axis=1)`, then `return` both as a tuple.
```

## Fewer temporaries: in-place ops and `out=`

An expression like `a * 2 + 1` allocates a **temporary** array for `a * 2`, then *another* for the `+ 1`. On large arrays, allocating and filling that memory can cost more than the arithmetic itself. In-place operators and the `out=` argument reuse existing buffers:

```python run
import time

def best_ms(fn, repeat=5):
    """Best of several runs, in milliseconds. A single timing is noisy."""
    times = []
    for _ in range(repeat):
        t0 = time.perf_counter()
        fn()
        times.append(time.perf_counter() - t0)
    return min(times) * 1000

a = np.random.default_rng(0).normal(size=1_000_000)
buf = np.empty_like(a)

def with_temporaries():
    return a * 2.0 + 1.0

def in_place():
    np.multiply(a, 2.0, out=buf)    # write into an existing buffer
    np.add(buf, 1.0, out=buf)       # in-place add: no new array
    return buf

print(f"a * 2 + 1      : {best_ms(with_temporaries):.2f} ms")
print(f"out= / in-place: {best_ms(in_place):.2f} ms")
print("same result:", np.allclose(with_temporaries(), in_place()))
```

The exact numbers depend on your machine (and the browser), but the in-place version never allocates. That matters even more for **peak memory**: with temporaries, a 4 GB array briefly needs 12 GB.

> **Pitfall:** an in-place result must fit the array's dtype. `ints *= 0.5` raises an error, because NumPy won't silently write floats into an integer buffer. Convert first, or write to a new array.

```python run error
counts = np.array([10, 20, 30], dtype=np.int64)
counts *= 0.5
```

## Choosing dtypes to save memory

The simplest performance win is often a smaller dtype. Halving the bytes per element halves memory *and* the bandwidth every operation consumes:

```python run
n = 1_000_000
for dt in [np.float64, np.float32, np.int64, np.int16, np.uint8]:
    print(f"{np.dtype(dt).name:>8}: {np.zeros(n, dtype=dt).nbytes / 1e6:5.1f} MB")
```

| Data | Good dtype | Why |
|---|---|---|
| Pixel values 0–255 | `uint8` | 8× smaller than float64 |
| ML features and weights | `float32` | GPU-native, plenty of precision |
| Small categories / labels | `int8` / `int16` | if the value range fits |
| Money, long sums, statistics | `float64` | precision matters more than size |

The trade-offs are the ones you met earlier: smaller integers **overflow** sooner, and float32 keeps only about 7 significant digits.

```python exercise id=shrink-dataset title="Put a dataset on a diet"
rng = np.random.default_rng(7)
pixels = rng.integers(0, 256, size=(200, 200), dtype=np.int64)          # values 0..255
features = rng.normal(size=(5000, 32))                                    # float64

# TODO 1: `pixels_small`: the same values stored as uint8
pixels_small = ...

# TODO 2: `features_small`: the features stored as float32
features_small = ...

# TODO 3: `saved_mb`: total megabytes saved (bytes / 1e6) by both conversions
saved_mb = ...
--- solution
rng = np.random.default_rng(7)
pixels = rng.integers(0, 256, size=(200, 200), dtype=np.int64)
features = rng.normal(size=(5000, 32))

pixels_small = pixels.astype(np.uint8)
features_small = features.astype(np.float32)
saved_mb = (pixels.nbytes - pixels_small.nbytes + features.nbytes - features_small.nbytes) / 1e6
--- test
assert pixels_small is not ... and features_small is not ... and saved_mb is not ..., "Replace every `...` with your code."
assert isinstance(pixels_small, np.ndarray) and pixels_small.dtype == np.uint8, f"`pixels_small` should have dtype uint8, got {getattr(pixels_small, 'dtype', type(pixels_small).__name__)}."
assert np.array_equal(pixels_small, pixels), "`pixels_small` should hold exactly the same values as `pixels`."
assert isinstance(features_small, np.ndarray) and features_small.dtype == np.float32, f"`features_small` should have dtype float32, got {getattr(features_small, 'dtype', type(features_small).__name__)}."
assert features_small.shape == (5000, 32) and np.allclose(features_small, features, atol=1e-6), "`features_small` should contain the same values (to float32 precision)."
_expected = (200 * 200 * 7 + 5000 * 32 * 4) / 1e6
assert np.isclose(saved_mb, _expected), f"You should save {_expected:.2f} MB in total, but `saved_mb` is {saved_mb!r}. Compare .nbytes before and after for both arrays."
--- hint
`.astype(np.uint8)` and `.astype(np.float32)` create the smaller copies.
--- hint
Every array has `.nbytes`. Saved bytes = (old − new) for pixels plus (old − new) for features; divide by `1e6`.
```

```python debug id=scale-in-place title="The memory-saving rescale crashes"
# Convert raw sensor counts to volts IN PLACE to avoid a second big array.
# 1 count = 0.004 volts.
raw = np.array([120, 455, 1023, 87, 640], dtype=np.int64)

volts = raw
volts *= 0.004
print("volts:", volts)
--- solution
# Convert raw sensor counts to volts IN PLACE to avoid a second big array.
# 1 count = 0.004 volts.
raw = np.array([120, 455, 1023, 87, 640], dtype=np.int64)

volts = raw.astype(np.float64)
volts *= 0.004
print("volts:", volts)
--- test
assert isinstance(volts, np.ndarray) and np.issubdtype(volts.dtype, np.floating), f"`volts` should be a floating-point array, but has dtype {getattr(volts, 'dtype', None)}."
assert np.allclose(volts, [0.48, 1.82, 4.092, 0.348, 2.56]), f"`volts` has the wrong values: {volts}."
assert raw.dtype == np.int64 and raw.tolist() == [120, 455, 1023, 87, 640], "Keep `raw` as the original integer counts."
--- hint
Run it and read the error: NumPy refuses to store float results into an integer buffer.
--- hint
An integer array can never hold 0.48. Make one float copy (`raw.astype(np.float64)`), then scale that copy in place. That's still just one extra array.
```

## Measuring performance properly

Some rules for timing code so the numbers mean something:

1. **Use `time.perf_counter()`**, a high-resolution clock meant for intervals.
2. **Repeat and take the minimum.** Noise from other processes only ever makes runs slower, so the best run is the most honest. (In Jupyter, `%timeit` does this for you.)
3. **Time realistic sizes.** At 100 elements Python overhead dominates; at 10 million, memory bandwidth does.
4. **Check the answers match** before celebrating a speedup.

```python run
import time

def best_ms(fn, repeat=5):
    times = []
    for _ in range(repeat):
        t0 = time.perf_counter()
        fn()
        times.append(time.perf_counter() - t0)
    return min(times) * 1000

m = np.random.default_rng(1).normal(size=(1000, 1000))
mt = m.T                                       # F-ordered view

print(f"sum of C-ordered array  : {best_ms(lambda: m.sum()):.2f} ms")
print(f"sum of transposed view  : {best_ms(lambda: mt.sum()):.2f} ms")
print(f"make it contiguous (copy): {best_ms(lambda: np.ascontiguousarray(mt)):.2f} ms")
```

Summing barely cares about layout (for full reductions NumPy walks memory in whichever order is fastest), but forcing a contiguous copy of the transposed view costs real time and 8 MB of memory. The lesson: **copies are the expensive part.** Know when you're making one.

## Recap

- An ndarray is a flat buffer plus `dtype`, `shape` and `strides`: bytes to skip per axis.
- Transpose, slicing and many reshapes only change strides, so they're free **views**; `np.shares_memory` and `.flags` tell you what you have.
- C order makes rows contiguous and F order makes columns contiguous. `ravel()` and C code may silently copy non-contiguous data.
- `sliding_window_view` builds overlapping windows with zero copies. Read from them, never write.
- In-place operators and `out=` avoid temporaries; smaller dtypes cut memory and bandwidth.
- Time with `perf_counter`, repeat, take the best, and verify results.

**Up next:** the capstone projects, starting with k-means clustering built from scratch.
