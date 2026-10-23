Sooner or later, your arrays have to leave memory. You save a trained model's weights, load a dataset someone exported as CSV, or read a log with a few missing fields. NumPy has fast tools for all of this, plus **structured arrays**, which let one array hold records with named fields of different types, like rows in a table.

In this lesson you'll save and load NumPy's binary formats, parse messy text files, and build and query structured arrays. You'll also learn where NumPy's I/O ends and pandas should take over.

> **About files in this course:** your code runs in the browser, so files written here live in a temporary in-memory filesystem that disappears when you leave. The examples use `io.BytesIO` and `io.StringIO`, in-memory "files" that behave exactly like real ones. In a normal script you'd just pass a filename like `"weights.npy"` instead.

```python setup
import io

SALES_CSV = """day,units,price
1,12,9.99
2,7,10.49
3,15,9.49
4,9,10.99
5,20,8.99
"""

SENSOR_CSV = """# station log, exported 2024-05-01
time,temp,humidity
0,21.4,40
1,,42
2,22.1,
3,22.8,45
"""
```

## `.npy`: NumPy's native format

`np.save` writes one array to the **`.npy`** format, a tiny header (dtype, shape, memory order) followed by the raw bytes. `np.load` reads it back **exactly**: same dtype, same shape, no rounding, and very fast.

```python run
weights = np.random.default_rng(0).normal(size=(3, 4)).astype(np.float32)

buf = io.BytesIO()            # stands in for open("weights.npy", "wb")
np.save(buf, weights)
print("bytes written:", buf.tell(), " (48 data bytes + header)")

buf.seek(0)                   # rewind before reading
restored = np.load(buf)
print(restored.dtype, restored.shape, "identical:", np.array_equal(weights, restored))
```

> **Pitfall:** after writing to an in-memory buffer, its position is at the end. Forgetting `buf.seek(0)` before `np.load` gives an `EOFError` or a "file is empty" error. Real files don't need this, because you reopen them.

## `.npz`: many arrays in one file

`np.savez(file, name=array, ...)` bundles several arrays into one `.npz` archive (a zip of `.npy` files). `np.savez_compressed` does the same with compression. Loading gives a lazy, dictionary-like object:

```python run
rng = np.random.default_rng(1)
W = rng.normal(size=(4, 2))
b = np.zeros(2)
epoch = np.array(17)

buf = io.BytesIO()
np.savez(buf, W=W, b=b, epoch=epoch)
buf.seek(0)

ckpt = np.load(buf)
print("arrays in file:", list(ckpt.keys()))
print("W shape:", ckpt["W"].shape, " epoch:", int(ckpt["epoch"]))
```

This is a perfectly good way to checkpoint a small model or cache an expensive preprocessing step.

> **Tip:** text vs. binary matters. A float64 written as text takes ~25 characters; in `.npy` it takes exactly 8 bytes and loads with zero parsing. Use binary formats for anything you'll reload with NumPy, and text when humans or other tools need to read it.

```python exercise id=checkpoint-roundtrip title="Save and restore a checkpoint"
rng = np.random.default_rng(42)
W = rng.normal(size=(5, 3)).astype(np.float32)
b = np.full(3, 0.1, dtype=np.float32)

# TODO 1: save BOTH arrays into the in-memory file `ckpt`
#         under the names "W" and "b" (one archive, one call).
ckpt = io.BytesIO()
...

# TODO 2: rewind `ckpt`, load it, and put the restored arrays in W2 and b2.
W2 = ...
b2 = ...
--- solution
rng = np.random.default_rng(42)
W = rng.normal(size=(5, 3)).astype(np.float32)
b = np.full(3, 0.1, dtype=np.float32)

ckpt = io.BytesIO()
np.savez(ckpt, W=W, b=b)

ckpt.seek(0)
data = np.load(ckpt)
W2 = data["W"]
b2 = data["b"]
--- test
assert W2 is not ... and b2 is not ..., "Replace the `...` after `W2 =` and `b2 =` with the arrays loaded from `ckpt`."
assert isinstance(ckpt, io.BytesIO) and ckpt.getbuffer().nbytes > 0, "Nothing was written to `ckpt`. Use np.savez(ckpt, W=W, b=b)."
ckpt.seek(0)
try:
    _z = np.load(ckpt)
    _names = sorted(_z.keys())
except Exception as _e:
    raise AssertionError(f"`ckpt` doesn't contain an .npz archive ({type(_e).__name__}). Save both arrays in one np.savez call.")
assert _names == ["W", "b"], f"The archive should contain arrays named 'W' and 'b', but has {_names}. Pass them as keyword arguments."
_W = np.random.default_rng(42).normal(size=(5, 3)).astype(np.float32)
assert isinstance(W2, np.ndarray) and W2.dtype == np.float32, f"`W2` should be the float32 array loaded back from the file, got {type(W2).__name__} {getattr(W2, 'dtype', '')}."
assert np.array_equal(W2, _W) and np.array_equal(b2, np.full(3, 0.1, dtype=np.float32)), "The restored arrays don't match the originals."
assert W2 is not W and b2 is not b, "`W2` and `b2` should come from `np.load(ckpt)`, not be the original variables."
--- hint
`np.savez(file, W=W, b=b)` stores each keyword argument as a named array.
--- hint
Call `ckpt.seek(0)`, then `data = np.load(ckpt)`, then index it like a dict: `data["W"]`.
```

## Text files: `savetxt` and `loadtxt`

For CSV and other plain-text tables, `np.loadtxt` parses numbers into an array. Its most useful parameters:

| Parameter | Purpose |
|---|---|
| `delimiter=","` | column separator (default: any whitespace) |
| `skiprows=1` | skip header lines |
| `usecols=(1, 2)` | read only some columns |
| `dtype=int` | parse as a specific type |
| `unpack=True` | return columns as separate arrays |
| `comments="#"` | ignore lines/text after this marker (the default) |

```python run
sales = np.loadtxt(io.StringIO(SALES_CSV), delimiter=",", skiprows=1)
print(sales.shape, sales.dtype)
print(sales)

units, price = np.loadtxt(io.StringIO(SALES_CSV), delimiter=",", skiprows=1, usecols=(1, 2), unpack=True)
print("total revenue:", round((units * price).sum(), 2))
```

`np.savetxt` goes the other way. `fmt` controls the number format and `header` adds a first line (prefixed with `# ` unless you pass `comments=""`):

```python run
table = np.column_stack([np.arange(1, 4), np.array([0.25, 0.5, 0.75])])

out = io.StringIO()
np.savetxt(out, table, delimiter=",", fmt=["%d", "%.2f"], header="id,ratio", comments="")
print(out.getvalue())
```

```python predict id=predict-roundtrip-dtype title="Which dtypes come back?"
a = np.array([1, 2, 3], dtype=np.int16)

binary = io.BytesIO(); np.save(binary, a); binary.seek(0)
text = io.StringIO(); np.savetxt(text, a); text.seek(0)

print(np.load(binary).dtype, np.loadtxt(text).dtype)
--- options
int16 int16
int64 float64
* int16 float64
float64 float64
--- explain
`.npy` stores the dtype in its header, so `int16` survives exactly. Text has no type information, and `np.loadtxt` parses numbers as `float64` unless you pass `dtype=`. This is one more reason to prefer binary formats for NumPy-to-NumPy storage.
```

```python exercise id=parse-sales title="Analyse a sales export"
# SALES_CSV (defined in the lesson setup) has a header row and
# three columns: day, units, price.

# TODO 1: `units`: the units column as an integer array (shape (5,))
units = ...

# TODO 2: `best_day`: the day number (from the day column) with the
#         highest revenue (units * price), as a Python int
best_day = ...
--- solution
data = np.loadtxt(io.StringIO(SALES_CSV), delimiter=",", skiprows=1)
day, units, price = data.T
units = units.astype(int)
revenue = units * price
best_day = int(day[np.argmax(revenue)])
--- test
assert units is not ..., "Replace the `...` after `units =` with your code."
assert best_day is not ..., "Replace the `...` after `best_day =` with your code."
units = np.asarray(units)
assert units.shape == (5,), f"`units` should be one column with 5 values, but has shape {units.shape}. Did you skip the header and select column 1?"
assert np.issubdtype(units.dtype, np.integer), f"`units` should be integers, but has dtype {units.dtype}. Use dtype=int or .astype(int)."
assert units.tolist() == [12, 7, 15, 9, 20], f"`units` should be [12, 7, 15, 9, 20], got {units.tolist()}."
assert isinstance(best_day, (int, np.integer)), f"`best_day` should be an integer day number, got {type(best_day).__name__} {best_day!r}."
assert int(best_day) == 5, f"Revenue is units × price; the best day is not {best_day}. Use np.argmax on the revenue and look up that row's day."
--- hint
`np.loadtxt(io.StringIO(SALES_CSV), delimiter=",", skiprows=1)` gives a (5, 3) float array. Its columns are day, units and price.
--- hint
`np.argmax(revenue)` returns the *row index* of the maximum. Use it to index the day column, then wrap the result in `int(...)`.
```

## Messy text: `np.genfromtxt`

`loadtxt` is strict: an empty field is an error. Real exports have gaps. `np.genfromtxt` handles missing values, filling them with `nan` by default (or with `filling_values=` of your choice):

```python run error
np.loadtxt(io.StringIO(SENSOR_CSV), delimiter=",", skiprows=2)
```

```python run
log = np.genfromtxt(io.StringIO(SENSOR_CSV), delimiter=",", skip_header=2)
print(log)
print("mean temp:", np.nanmean(log[:, 1]).round(2), " mean humidity:", np.nanmean(log[:, 2]).round(2))
```

With `names=True`, `genfromtxt` reads the header row and returns a **structured array** whose columns you access by name:

```python run
log = np.genfromtxt(io.StringIO(SENSOR_CSV), delimiter=",", names=True, skip_header=1)
print("fields:", log.dtype.names)
print("temp column:", log["temp"])
```

(The `# station log…` line is skipped by `skip_header=1`, and the next line becomes the field names.)

## Structured arrays: records with named fields

A regular array holds one dtype. A **structured dtype** describes a *record*: a fixed set of named fields, each with its own type. It's NumPy's answer to a table row or a C struct.

```python run
player_t = np.dtype([("name", "U12"), ("age", "i4"), ("score", "f8")])

players = np.array([
    ("Ada", 36, 91.5),
    ("Grace", 29, 88.0),
    ("Linus", 41, 79.25),
    ("Margaret", 33, 95.0),
], dtype=player_t)

print(players.dtype)
print("one record:", players[0])
print("one field: ", players["score"])
print("bytes per record:", players.itemsize)
```

`"U12"` is a Unicode string of up to 12 characters, `"i4"` a 4-byte integer and `"f8"` an 8-byte float. Fields behave like ordinary arrays, so boolean masks, aggregations and sorting all work:

```python run
seniors = players[players["age"] > 30]
print("over 30:", seniors["name"])
print("their mean score:", seniors["score"].mean())

ranked = np.sort(players, order="score")[::-1]     # highest score first
print("leaderboard:", ranked["name"])
```

`np.sort(..., order="field")` sorts whole records by one (or several) fields. `np.argsort(players["score"])` gives the same ordering as indices.

> **In the wild:** structured arrays are how NumPy reads binary file formats with fixed-size records, and how `pandas.DataFrame.to_records()` hands data back to NumPy. They're compact and fast, but limited: no easy column insertion, no grouping, and awkward missing values.

```python exercise id=build-records title="Build and query a structured array"
orders = [
    ("A-100", 3, 19.99),
    ("A-101", 1, 249.00),
    ("A-102", 12, 4.50),
    ("A-103", 2, 89.90),
]

# TODO 1: `order_t`: a structured dtype with fields
#         "id" (string, up to 8 chars), "qty" (int32), "price" (float64)
order_t = ...

# TODO 2: `table`: a structured array of `orders` using `order_t`
table = ...

# TODO 3: `big_ids`: the ids of orders whose total (qty * price) exceeds 100,
#         as a NumPy array of strings, in their original order
big_ids = ...
--- solution
orders = [
    ("A-100", 3, 19.99),
    ("A-101", 1, 249.00),
    ("A-102", 12, 4.50),
    ("A-103", 2, 89.90),
]

order_t = np.dtype([("id", "U8"), ("qty", "i4"), ("price", "f8")])
table = np.array(orders, dtype=order_t)
big_ids = table["id"][table["qty"] * table["price"] > 100]
--- test
assert order_t is not ... and table is not ... and big_ids is not ..., "Replace every `...` with your code."
order_t = np.dtype(order_t)
assert order_t.names == ("id", "qty", "price"), f"The dtype should have fields ('id', 'qty', 'price') in that order, but has {order_t.names}."
assert order_t["qty"] == np.dtype("int32"), f"'qty' should be int32 ('i4'), but is {order_t['qty']}."
assert order_t["price"] == np.dtype("float64"), f"'price' should be float64 ('f8'), but is {order_t['price']}."
assert order_t["id"].kind == "U" and order_t["id"].itemsize // 4 >= 5, f"'id' should be a Unicode string field like 'U8', but is {order_t['id']}."
assert isinstance(table, np.ndarray) and table.dtype == order_t and table.shape == (4,), f"`table` should be a structured array of 4 records with dtype order_t, got shape {getattr(table, 'shape', None)}."
assert table["id"].tolist() == ["A-100", "A-101", "A-102", "A-103"], "The ids in `table` were truncated or are wrong. Is the string field long enough?"
assert list(np.asarray(big_ids)) == ["A-101", "A-103"], f"Orders over 100 are A-101 (249.00) and A-103 (179.80); got {list(np.asarray(big_ids))}. Note A-102 is 12 × 4.50 = 54."
--- hint
A structured dtype is a list of `(name, type)` pairs: `np.dtype([("id", "U8"), ...])`.
--- hint
Compute totals from two fields, `table["qty"] * table["price"]`, then use that boolean mask to index `table["id"]`.
```

```python debug id=leaderboard-order title="The leaderboard is alphabetical"
scores = np.array([
    ("zoe", 88.5), ("adam", 92.0), ("mia", 79.0), ("liam", 95.5),
], dtype=[("player", "U10"), ("points", "f8")])

# Top 3 players by points, best first
leaderboard = np.sort(scores)[:3]
top3 = leaderboard["player"]
print("Top 3:", top3)
--- solution
scores = np.array([
    ("zoe", 88.5), ("adam", 92.0), ("mia", 79.0), ("liam", 95.5),
], dtype=[("player", "U10"), ("points", "f8")])

# Top 3 players by points, best first
leaderboard = np.sort(scores, order="points")[::-1][:3]
top3 = leaderboard["player"]
print("Top 3:", top3)
--- test
assert list(top3) == ["liam", "adam", "zoe"], f"The top 3 by points should be ['liam', 'adam', 'zoe'], but you got {list(top3)}."
assert "liam" in _stdout, "Keep the print so you can see the leaderboard."
--- hint
Run it. Which field is `np.sort` sorting by when you don't tell it?
--- hint
Without `order=`, structured arrays sort by the *first* field (the name). Pass `order="points"`, then reverse with `[::-1]` so the highest score comes first, then take 3.
```

## When to reach for pandas

NumPy's I/O is perfect for **numeric arrays**: model weights, images, simulation outputs, matrices. For **tabular data** with mixed types, string columns, dates, many missing values or grouping, switch to pandas: `pd.read_csv` is far more forgiving and featureful than `genfromtxt`, and a DataFrame is a far better structured array.

| Job | Best tool |
|---|---|
| Save/load arrays for later NumPy use | `np.save` / `np.load` (`.npy`) |
| Several arrays, e.g. a checkpoint | `np.savez` / `np.savez_compressed` |
| Simple numeric CSV | `np.loadtxt` / `np.savetxt` |
| CSV with gaps, few columns | `np.genfromtxt` |
| Real-world tables (types, dates, joins, groupby) | `pandas.read_csv` → DataFrame |
| Huge arrays that don't fit in memory | `np.load(..., mmap_mode="r")`, or formats like HDF5 / Zarr |

> **Under the hood:** `np.load(path, mmap_mode="r")` memory-maps a `.npy` file. The OS loads only the slices you actually touch, so you can index into a 50 GB array on a laptop.

## Recap

- `np.save`/`np.load` use the `.npy` format, which is exact, fast and dtype-preserving. `np.savez` bundles named arrays.
- With in-memory buffers, remember `seek(0)` before reading back.
- `np.loadtxt`/`np.savetxt` handle clean numeric text (`delimiter`, `skiprows`, `usecols`, `unpack`, `fmt`).
- `np.genfromtxt` tolerates missing fields (→ `nan`) and can read headers with `names=True`.
- Structured dtypes give named, mixed-type fields. Use `np.sort(..., order="field")` and boolean masks on fields.
- Use pandas for heavy tabular work and memory mapping for arrays bigger than RAM.

**Up next:** what an array really is in memory (strides, contiguity and layout) and how that knowledge makes your code faster.
