Every NumPy workflow starts the same way: you turn some data into an array, then ask it questions. *How big are you? How many dimensions? What type are your numbers?* Professionals check these constantly. Most NumPy bugs are shape or dtype surprises that a quick look at `.shape` would have caught.

In this lesson you'll create 1-D, 2-D and 3-D arrays from Python lists, and learn the handful of attributes that describe every array. By the end you'll read `ndarray · shape (2, 3) · float64` the way a doctor reads a pulse.

## From lists to arrays

`np.array` takes a list, or a list of lists, and builds an array from it:

```python run
import numpy as np

prices = np.array([4.99, 2.50, 7.25])
prices
```

A **list of lists** becomes a 2-D array. Each inner list is a **row**:

```python run
grid = np.array([
    [1, 2, 3],
    [4, 5, 6],
])
grid
```

Go one level deeper and you get 3-D: here, 2 "pages", each with 2 rows and 3 columns. Think of a stack of spreadsheets, or a short video of tiny grayscale frames.

```python run
cube = np.array([
    [[1, 2, 3], [4, 5, 6]],
    [[7, 8, 9], [10, 11, 12]],
])
print(cube)
print("shape:", cube.shape)
```

## The vital statistics of an array

Every array carries a few attributes that describe it completely:

| Attribute | Meaning | For `grid` above |
|---|---|---|
| `.shape` | Size along each dimension, as a tuple | `(2, 3)` |
| `.ndim` | Number of dimensions (*axes*) | `2` |
| `.size` | Total number of elements | `6` |
| `.dtype` | The single type shared by every element | an integer type |
| `.itemsize` | Bytes per element | depends on dtype |
| `.nbytes` | Total bytes of data (`size × itemsize`) | depends on dtype |

```python run
readings = np.array([
    [20.1, 20.4, 21.0, 21.7],
    [19.8, 19.9, 20.2, 20.6],
    [22.3, 22.9, 23.1, 23.8],
])

print("shape:   ", readings.shape)
print("ndim:    ", readings.ndim)
print("size:    ", readings.size)
print("dtype:   ", readings.dtype)
print("itemsize:", readings.itemsize, "bytes")
print("nbytes:  ", readings.nbytes, "bytes")
```

Read the shape **from the outside in**: `(3, 4)` means 3 rows, each with 4 columns. For 3-D arrays, `(pages, rows, columns)`.

> **Tip:** that's exactly what the small label above a displayed value tells you. `ndarray · shape (3, 4) · float64` is the type, the shape and the dtype at a glance. Get in the habit of glancing at it after every run.

```python predict id=predict-vital-stats title="What does this print?"
m = np.array([[1, 2, 3], [4, 5, 6]])
print(m.shape, m.ndim, m.size)
--- options
(3, 2) 2 6
* (2, 3) 2 6
(2, 3) 6 2
(2, 3) 2 3
--- explain
Two inner lists means **2 rows**, each with **3 columns**, so the shape is `(2, 3)`. There are two dimensions (`ndim` is 2) and 2 × 3 = **6** elements in total.
```

`len()` works on arrays too, but it only counts the **first** dimension, the number of rows:

```python run
print("len(readings) =", len(readings))
print("readings.shape[0] =", readings.shape[0])
print("readings.size =", readings.size)
```

> **Pitfall:** `len(a)` is *not* the number of elements for a 2-D array. Use `a.size` for the total and `a.shape[1]` for the number of columns.

```python exercise id=sales-table title="Build a sales table"
# Quarterly sales (in $1000s) for three stores:
#   Downtown:  120, 135, 150, 170
#   Airport:    90,  95, 110, 105
#   Suburbs:    60,  80,  75,  95
#
# 1. Build a 2-D array `sales` with one ROW per store (in the order above)
#    and one COLUMN per quarter.
# 2. Use attributes (not hard-coded numbers) to set:
#    n_stores   = number of rows
#    n_quarters = number of columns
sales = ...
n_stores = ...
n_quarters = ...
--- solution
sales = np.array([
    [120, 135, 150, 170],
    [90, 95, 110, 105],
    [60, 80, 75, 95],
])
n_stores = sales.shape[0]
n_quarters = sales.shape[1]
--- test
assert sales is not ..., "Replace the `...` after `sales =` with a nested list wrapped in `np.array(...)`."
assert isinstance(sales, np.ndarray), f"`sales` should be a NumPy array, but it is a {type(sales).__name__}."
assert sales.ndim == 2, f"`sales` should be 2-D (rows and columns) but has {sales.ndim} dimension(s)."
assert sales.shape == (3, 4), f"`sales` should have shape (3, 4): 3 stores × 4 quarters. Yours is {sales.shape}."
assert np.array_equal(sales[0], [120, 135, 150, 170]), "The first row should be the Downtown store's four quarters."
assert np.array_equal(sales, [[120, 135, 150, 170], [90, 95, 110, 105], [60, 80, 75, 95]]), "Some values don't match the data in the comment. Check each row."
assert n_stores == 3 and n_quarters == 4, f"Expected n_stores=3 and n_quarters=4, got {n_stores} and {n_quarters}."
--- hint
Each store becomes one inner list, and the outer list holds the three stores: `np.array([[...], [...], [...]])`.
--- hint
`sales.shape` is a tuple `(rows, columns)`. Index into it with `[0]` and `[1]`.
```

## How NumPy chooses a dtype

When you don't specify a dtype, NumPy picks the simplest type that can hold **all** your values:

```python run
print(np.array([1, 2, 3]).dtype)            # whole numbers  -> integer
print(np.array([1, 2.0, 3]).dtype)          # any float       -> float64
print(np.array([True, False, True]).dtype)  # booleans        -> bool
print(np.array([1 + 2j, 3]).dtype)          # any complex     -> complex128
```

The integer line may say `int64` or `int32`. NumPy's default integer matches the platform. This in-browser Python is a 32-bit platform, so it uses `int32`; most laptops and servers use `int64`. Floats are always `float64` by default.

You can also choose the dtype yourself with `dtype=`. Smaller types use less memory, which matters for big data like images:

```python run
for dt in [np.float64, np.float32, np.int16, np.uint8]:
    a = np.array([1, 2, 3, 4], dtype=dt)
    print(f"{str(a.dtype):8}  itemsize={a.itemsize}  nbytes={a.nbytes}")
```

`uint8` means *unsigned 8-bit integer*: values from 0 to 255 in a single byte. It's exactly what image pixels use.

```python exercise id=compact-dtype title="Shrink a dataset"
levels = [12, 250, 7, 99, 180, 3, 64]   # sensor levels, always between 0 and 255

# 1. `wide`: an array of `levels` with dtype np.int64
# 2. `compact`: an array of `levels` with dtype np.uint8
# 3. `saved`: how many bytes `compact` saves compared to `wide` (use .nbytes)
wide = ...
compact = ...
saved = ...
--- solution
levels = [12, 250, 7, 99, 180, 3, 64]

wide = np.array(levels, dtype=np.int64)
compact = np.array(levels, dtype=np.uint8)
saved = wide.nbytes - compact.nbytes
--- test
assert wide is not ... and compact is not ..., "Replace the `...` placeholders for `wide` and `compact`."
assert isinstance(wide, np.ndarray) and isinstance(compact, np.ndarray), "`wide` and `compact` should both be NumPy arrays."
assert wide.dtype == np.int64, f"`wide` should have dtype int64, but it is {wide.dtype}. Pass dtype=np.int64."
assert compact.dtype == np.uint8, f"`compact` should have dtype uint8, but it is {compact.dtype}. Pass dtype=np.uint8."
assert np.array_equal(wide, levels) and np.array_equal(compact, levels), "Both arrays should contain the same seven levels."
assert saved is not ..., "Replace the `...` after `saved =`."
assert saved == 49, f"`saved` should be wide.nbytes - compact.nbytes. You have {saved!r}."
--- hint
`np.array(levels, dtype=np.uint8)` builds an array with a specific dtype.
--- hint
`int64` takes 8 bytes per element and `uint8` takes 1. Subtract the two `.nbytes` values.
```

## Arrays must be rectangular

Because an array is one regular block of memory, every row must have the **same length**. A ragged list can't become a normal array:

```python run error
ragged = np.array([
    [1, 2, 3],
    [4, 5],
])
```

The message, *"inhomogeneous shape after 1 dimensions"*, means "row lengths don't match". Fix the data (pad the short row, or drop it), or keep ragged data in a Python list.

> **Under the hood:** you *can* force it with `dtype=object`, but then each element is a pointer to a Python object again. You get none of NumPy's speed. It's an escape hatch, not a solution.

## Back to Python: `tolist()` and scalars

Sometimes you need plain Python data again, for JSON, a web API, or a library that expects lists. `.tolist()` converts the whole array, turning every element into a native Python number:

```python run
a = np.array([[1.5, 2.5], [3.5, 4.5]])
as_list = a.tolist()

print(as_list)
print("type of a[0, 0]:      ", type(a[0, 0]))
print("type of as_list[0][0]:", type(as_list[0][0]))
```

Indexing a single element gives you a **NumPy scalar** (like `np.float64`), which behaves like a number but keeps its dtype. `.item()` converts one element to a plain Python number.

An array can even have **zero** dimensions: a single value with shape `()`. You'll occasionally get one from reductions or from wrapping a lone number:

```python run
zero_d = np.array(3.14)
print("ndim:", zero_d.ndim, " shape:", zero_d.shape, " size:", zero_d.size)
print("as a Python float:", zero_d.item())
np.array([10, 20, 30]).sum()
```

The last line displays `np.int32(60)` or `np.int64(60)`. That's how NumPy 2 shows a scalar's repr, with its dtype attached. `print()` shows just `60`.

```python predict id=predict-zero-d title="What does this print?"
x = np.array(7.5)
print(x.ndim, x.shape)
--- options
1 (1,)
* 0 ()
0 (1,)
1 ()
--- explain
`np.array(7.5)` wraps a single number without any list around it, so there are **no axes at all**. `ndim` is `0` and the shape is the empty tuple `()`. Compare `np.array([7.5])`, which is 1-D with shape `(1,)`.
```

```python exercise id=describe-array title="Write an array inspector"
# Write a function `describe(arr)` that returns a one-line summary string like:
#   "2-D array, shape (3, 4), 12 elements of float64"
# using the array's attributes. It must work for ANY array you pass in.
def describe(arr):
    ...

print(describe(np.array([[1.0, 2.0], [3.0, 4.0]])))
--- solution
def describe(arr):
    return f"{arr.ndim}-D array, shape {arr.shape}, {arr.size} elements of {arr.dtype}"

print(describe(np.array([[1.0, 2.0], [3.0, 4.0]])))
--- test
r = describe(np.zeros((3, 4)))
assert r is not None, "`describe` returned None. Did you forget `return`?"
assert isinstance(r, str), f"`describe` should return a string, but it returned {type(r).__name__}."
assert r == "2-D array, shape (3, 4), 12 elements of float64", f"For a float64 array of shape (3, 4) expected '2-D array, shape (3, 4), 12 elements of float64' but got {r!r}."
r2 = describe(np.ones((2, 2, 5), dtype=np.float32))
assert r2 == "3-D array, shape (2, 2, 5), 20 elements of float32", f"Your function should work for any array. For shape (2, 2, 5) float32 it returned {r2!r}."
r3 = describe(np.array([True, False]))
assert r3 == "1-D array, shape (2,), 2 elements of bool", f"For a 1-D bool array it returned {r3!r}."
--- hint
An f-string can drop attributes right into the text: `f"{arr.ndim}-D array, ..."`.
--- hint
You need four attributes: `ndim`, `shape`, `size` and `dtype`. Printing a tuple or a dtype inside an f-string gives exactly the format shown.
```

## Two classic beginner bugs

```python debug id=nested-brackets-bug title="A 2×3 array that won't build"
# We want a 2-D array with 2 rows and 3 columns.
matrix = np.array([1, 2, 3], [4, 5, 6])
print(matrix.shape)
--- solution
matrix = np.array([[1, 2, 3], [4, 5, 6]])
print(matrix.shape)
--- test
assert isinstance(matrix, np.ndarray), "`matrix` should be a NumPy array."
assert matrix.shape == (2, 3), f"`matrix` should have shape (2, 3), but it has {matrix.shape}."
assert np.array_equal(matrix, [[1, 2, 3], [4, 5, 6]]), "The rows should be [1, 2, 3] and [4, 5, 6]."
--- hint
The confusing "Field elements" error happens because NumPy is trying to read `[4, 5, 6]` as a *dtype* description. The second argument of `np.array` is `dtype`. Why did your second row end up there?
--- hint
`np.array` takes **one** data argument. Both rows must be inside a single outer list: `np.array([[...], [...]])`.
```

```python debug id=string-numbers-bug title="Numbers that came in as text"
# Values read from a CSV file arrive as strings.
raw = ["3.5", "4.0", "2.5", "5.0"]

values = np.array(raw)
average = values.mean()
print("average:", average)
--- solution
raw = ["3.5", "4.0", "2.5", "5.0"]

values = np.array(raw, dtype=float)
average = values.mean()
print("average:", average)
--- test
assert np.issubdtype(values.dtype, np.floating), f"`values` should hold numbers (a float dtype), but its dtype is {values.dtype}."
assert np.isclose(average, 3.75), f"`average` should be 3.75, got {average!r}."
--- hint
Check `values.dtype` (the Variables panel or the Debug button will show it). What does `<U3` mean?
--- hint
The array holds **text**, and you can't take the mean of text. Ask NumPy to convert while building the array: `np.array(raw, dtype=float)`.
```

## Recap

- `np.array(list)` makes a 1-D array; nested lists make 2-D and 3-D arrays, with each inner list as a row.
- `.shape`, `.ndim`, `.size`, `.dtype`, `.itemsize` and `.nbytes` describe any array. Check them constantly.
- `len(a)` counts only the first axis; `a.size` counts every element.
- NumPy infers the simplest dtype that fits everything; set `dtype=` to control it. The default integer is platform-dependent (`int32` here).
- Arrays must be rectangular; ragged data stays in lists.
- `.tolist()` and `.item()` convert back to plain Python; a 0-d array has shape `()`.

**Up next:** you rarely type arrays out by hand. Meet the factory functions (`zeros`, `ones`, `full`, `eye`) that build arrays of any shape instantly.
