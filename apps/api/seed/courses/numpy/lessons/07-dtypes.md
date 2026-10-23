Every NumPy array stores **one type of number**, packed tightly in memory. That single choice, the array's **dtype**, decides how much memory it uses, how precise its arithmetic is, which values it can hold, and what happens when a result doesn't fit. Most of the time NumPy picks sensible defaults, but the bugs dtypes cause are among the nastiest you'll meet: pixel values that wrap from 255 back to 4, file sizes that turn negative, fractions that silently become zero.

This lesson gives you a working mental model of dtypes: the main families, how to convert between them safely, NumPy's promotion rules for mixed arithmetic, and the overflow and precision traps that catch professionals.

## The dtype families

```python run
import numpy as np

for dt in [np.bool_, np.int8, np.int16, np.int32, np.int64, np.uint8,
           np.float16, np.float32, np.float64, np.complex128]:
    d = np.dtype(dt)
    print(f"{d.name:>10}  {d.itemsize:>2} bytes   kind={d.kind}")
```

| Kind | dtypes | Holds |
|---|---|---|
| `b` boolean | `bool` | `True` / `False` (1 byte each) |
| `i` signed integer | `int8`, `int16`, `int32`, `int64` | Whole numbers, negative or positive |
| `u` unsigned integer | `uint8` … `uint64` | Whole numbers ≥ 0; `uint8` is the classic pixel type |
| `f` floating point | `float16`, `float32`, `float64` | Real numbers with limited precision |
| `c` complex | `complex64`, `complex128` | Numbers with a real and an imaginary part |

The number in the name is the size in **bits**. `int8` uses 8 bits, so it can only represent $2^8 = 256$ different values.

```python run
print(np.iinfo(np.int8))
print(np.iinfo(np.uint8))
print("int32 range:", np.iinfo(np.int32).min, "to", np.iinfo(np.int32).max)
print("int64 max:  ", np.iinfo(np.int64).max)
```

`np.iinfo` reports the limits of integer types, and `np.finfo` does the same for floats.

## The default integer depends on your platform

When you write `np.array([1, 2, 3])` without a dtype, NumPy uses the platform's **default integer**. Run this:

```python run
a = np.array([1, 2, 3])
print("default int here:", a.dtype)
print("np.intp (the index type):", np.dtype(np.intp))
print("bytes per element:", a.itemsize)
```

In this browser the answer is **`int32`**. Python here runs on WebAssembly, a 32-bit platform. On a typical 64-bit Linux or macOS desktop, the same code prints `int64`. Windows used `int32` before NumPy 2.0 and `int64` since.

This isn't a curiosity; it changes results. With 32-bit integers, values above about 2.1 billion **wrap around**:

```python run
big = np.arange(100_000)
print("dtype:", big.dtype)
print("sum:", big.sum())
print("correct sum:", sum(range(100_000)))
```

In this browser the sum is wrong: it overflowed `int32` and wrapped around to `704982704`. On a 64-bit desktop it would happen to be right, which is exactly why this kind of bug survives testing on your laptop and then fails on another machine.

> **Rule:** when the size of an integer matters, **say it explicitly**: `np.arange(100_000, dtype=np.int64)`, or `big.sum(dtype=np.int64)`. Never assume the default is 64 bits.

## Choosing a dtype saves memory

The same million numbers take very different amounts of memory:

```python run
n = 1_000_000
for dt in [np.float64, np.float32, np.float16, np.uint8]:
    arr = np.zeros(n, dtype=dt)
    print(f"{np.dtype(dt).name:>8}: {arr.nbytes / 1e6:5.1f} MB")
```

Deep-learning frameworks train in `float32` (or even 16-bit types) for exactly this reason: half the memory and twice the throughput, at a precision cost that neural networks tolerate well. Images are stored as `uint8` because a pixel channel only needs 0 to 255.

```python exercise id=shrink-memory title="Halve the memory of a dataset"
rng = np.random.default_rng(0)
measurements = rng.normal(size=100_000)   # float64 by default

# 1. Create `compact`: the same values stored as 32-bit floats.
# 2. Compute `saved_bytes`: how many bytes the conversion saves.
compact = ...
saved_bytes = ...
--- solution
rng = np.random.default_rng(0)
measurements = rng.normal(size=100_000)

compact = measurements.astype(np.float32)
saved_bytes = measurements.nbytes - compact.nbytes
--- test
assert compact is not ..., "Replace the `...` after `compact =` with your code."
assert saved_bytes is not ..., "Replace the `...` after `saved_bytes =` with your code."
assert isinstance(compact, np.ndarray), f"`compact` should be a NumPy array, not {type(compact).__name__}."
assert compact.dtype == np.float32, f"`compact` should have dtype float32, but it has {compact.dtype}."
assert compact.shape == measurements.shape, f"`compact` should keep all {measurements.size} values, but it has shape {compact.shape}."
assert np.allclose(compact, measurements, rtol=1e-6, atol=1e-6), "`compact` should hold the same values as `measurements`, just at lower precision."
assert saved_bytes == 400_000, f"Converting 100,000 values from 8-byte to 4-byte floats saves 400,000 bytes, but `saved_bytes` is {saved_bytes}. Try the `.nbytes` attribute."
--- hint
Arrays have an `.astype(dtype)` method that returns a converted copy.
--- hint
Every array has `.nbytes`, its total size in bytes. Subtract the new size from the old one.
```

## Converting with `astype`

`arr.astype(new_dtype)` returns a **new** array converted to another dtype. Converting floats to integers **truncates toward zero**; it does not round:

```python run
values = np.array([2.9, -2.9, 0.5, 7.5])

print("astype(int32):  ", values.astype(np.int32))
print("round, then int:", np.round(values).astype(np.int32))
```

Notice that `np.round(0.5)` is `0` and `np.round(7.5)` is `8`. NumPy uses **round half to even** ("banker's rounding"), which avoids a systematic upward bias when you round lots of halves.

```python predict id=predict-astype title="What does this print?"
a = np.array([1.9, -1.9])
print(a.astype(np.int32))
--- options
[ 2 -2]
* [ 1 -1]
[ 1 -2]
[ 2 -1]
--- explain
`astype` to an integer type **truncates toward zero**: it chops off the fractional part. `1.9 → 1` and `-1.9 → -1`. To round instead, call `np.round` first.
```

```python exercise id=round-prices title="Round prices to whole dollars"
prices = np.array([1.99, 2.5, 3.49, -0.6, 7.5, 12.01])

# Create `dollars`: each price rounded to the NEAREST whole number,
# stored with an integer dtype.
dollars = ...
--- solution
prices = np.array([1.99, 2.5, 3.49, -0.6, 7.5, 12.01])

dollars = np.round(prices).astype(np.int64)
--- test
assert dollars is not ..., "Replace the `...` with your code."
assert isinstance(dollars, np.ndarray), f"`dollars` should be a NumPy array, not {type(dollars).__name__}."
assert np.issubdtype(dollars.dtype, np.integer), f"`dollars` should have an integer dtype, but it has {dollars.dtype}. Convert with `.astype(...)`."
assert dollars.shape == prices.shape, f"`dollars` should have one entry per price, shape {prices.shape}, but has {dollars.shape}."
truncated = prices.astype(np.int64)
assert not (np.array_equal(dollars, truncated)), "These values were truncated, not rounded: 1.99 became 1. `astype` chops toward zero, so round first."
assert np.array_equal(dollars, np.round(prices)), f"`dollars` should be the prices rounded to the nearest integer, {np.round(prices).astype(int).tolist()}, but it is {dollars.tolist()}."
--- hint
`astype(int)` on its own truncates (1.99 → 1). You need to round *before* converting.
--- hint
`np.round(prices)` rounds but keeps the float dtype. Chain `.astype(...)` onto the result.
```

## Integer overflow: when numbers wrap around

Integers have a fixed number of bits. When a result is too large, NumPy array arithmetic doesn't raise an error. It **wraps around**, like a car odometer rolling over:

```python run
pixels = np.array([250, 251, 252], dtype=np.uint8)
print("uint8 250..252 + 10:", pixels + 10)     # 260 wraps to 4

small = np.array([127], dtype=np.int8)
print("int8 127 + 1:", small + 1)              # wraps to -128
```

The arithmetic is done modulo $2^8 = 256$: `260 mod 256 = 4`. This is fast and predictable, which is why hardware works this way, but it means a bug produces *plausible-looking wrong numbers* instead of an error.

NumPy does catch one case: a Python integer that can't fit into the array's dtype **at all**.

```python run error
pixels = np.array([200], dtype=np.uint8)
pixels + 300
```

```python predict id=predict-overflow title="What does this print?"
x = np.array([250], dtype=np.uint8)
print(x + 10)
--- options
[260]
* [4]
[255]
OverflowError
--- explain
`10` fits in a `uint8`, so it adopts the array's dtype and the addition runs in 8-bit arithmetic. `260` doesn't fit, so it wraps modulo 256 to **4**. NumPy doesn't clip at 255 or raise; that's your job.
```

```python debug id=brighten-image title="Bright pixels turn dark"
# Brighten a tiny grayscale image by 100 levels.
# Pixel values must stay within 0-255; anything brighter should become 255.
image = np.array([[ 10, 120, 200],
                  [ 90, 160, 250]], dtype=np.uint8)

brighter = image + 100
print(brighter)
--- solution
# Brighten a tiny grayscale image by 100 levels.
# Pixel values must stay within 0-255; anything brighter should become 255.
image = np.array([[ 10, 120, 200],
                  [ 90, 160, 250]], dtype=np.uint8)

brighter = np.clip(image.astype(np.int16) + 100, 0, 255).astype(np.uint8)
print(brighter)
--- test
expected = np.array([[110, 220, 255], [190, 255, 255]], dtype=np.uint8)
assert isinstance(brighter, np.ndarray), "`brighter` should be a NumPy array."
assert brighter.shape == image.shape, f"`brighter` should keep the image shape {image.shape}, but has {brighter.shape}."
assert brighter.dtype == np.uint8, f"Images must stay uint8, but `brighter` has dtype {brighter.dtype}. Convert back with `.astype(np.uint8)`."
assert brighter[0, 2] != 44, "The pixel at 200 still becomes 44: 300 wrapped around modulo 256. Do the math in a wider dtype first."
assert np.array_equal(brighter, expected), f"Expected\n{expected}\nbut got\n{brighter}\nBright pixels should saturate at 255."
--- hint
Run it and compare `image` with `brighter`. What happened to 200 and 250?
--- hint
Convert to a wider integer type (like `np.int16`) *before* adding, so 300 can exist. Then cap the values with `np.clip(x, 0, 255)` and convert back to `np.uint8`.
```

```python debug id=negative-file-sizes title="File sizes turned negative"
# File sizes in kilobytes, stored compactly as 32-bit integers.
sizes_kb = np.array([3_500_000, 1_200_000, 4_800_000, 950_000], dtype=np.int32)

sizes_bytes = sizes_kb * 1024
total_bytes = sizes_bytes.sum()

print("bytes per file:", sizes_bytes)
print("total:", total_bytes)
--- solution
# File sizes in kilobytes, stored compactly as 32-bit integers.
sizes_kb = np.array([3_500_000, 1_200_000, 4_800_000, 950_000], dtype=np.int32)

sizes_bytes = sizes_kb.astype(np.int64) * 1024
total_bytes = sizes_bytes.sum()

print("bytes per file:", sizes_bytes)
print("total:", total_bytes)
--- test
true_bytes = [3_500_000 * 1024, 1_200_000 * 1024, 4_800_000 * 1024, 950_000 * 1024]
assert isinstance(sizes_bytes, np.ndarray), "`sizes_bytes` should be a NumPy array."
assert (sizes_bytes > 0).all(), f"Some sizes are negative: {sizes_bytes.tolist()}. The multiplication overflowed int32 (max ≈ 2.1 billion)."
assert sizes_bytes.tolist() == true_bytes, f"`sizes_bytes` should be {true_bytes} but is {sizes_bytes.tolist()}."
assert int(total_bytes) == sum(true_bytes), f"`total_bytes` should be {sum(true_bytes):,} but is {int(total_bytes):,}."
--- hint
Run the cell. A 3.5 GB file can't have a negative size. Compare the true size, 3,500,000 × 1024, with `np.iinfo(np.int32).max`.
--- hint
Multiplying two int32 values produces an int32 result, which overflows. Convert to `np.int64` **before** multiplying.
```

## Promotion: what dtype do mixed operations produce?

When you combine different dtypes, NumPy **promotes** them to a type that can represent both:

```python run
print("int8  + int16  ->", np.result_type(np.int8, np.int16))
print("int32 + float32 ->", np.result_type(np.int32, np.float32))
print("uint8 + float  ->", (np.array([1], dtype=np.uint8) + 1.5).dtype)
print("bool  + int8   ->", np.result_type(np.bool_, np.int8))
```

`int32 + float32` becomes `float64` because `float32` can't represent every `int32` exactly. NumPy picks the smallest type that's safe for both.

Python numbers are a special case. Since NumPy 2, plain Python `int`s and `float`s are **"weak"**: they adapt to the array's dtype instead of forcing an upgrade. NumPy *scalars* are not weak:

```python run
x = np.array([1.0, 2.0], dtype=np.float32)

print("float32 array * 2.5            ->", (x * 2.5).dtype)              # Python float: stays float32
print("float32 array * np.float64(2.5) ->", (x * np.float64(2.5)).dtype)  # NumPy scalar: promotes
```

> **Under the hood:** this behavior is defined by NumPy's NEP 50, introduced in NumPy 2.0. Older versions sometimes peeked at the *value* of a Python number to choose the result type, which made results data-dependent. If you maintain older code, this is a common source of tiny differences after upgrading.

```python exercise id=smallest-dtype title="Pick the smallest dtype that fits"
# Store these item counts using the SMALLEST UNSIGNED integer dtype
# that can hold all of them exactly.
values = [0, 255, 256, 40_000]

counts = ...
--- solution
values = [0, 255, 256, 40_000]

counts = np.array(values, dtype=np.uint16)
--- test
assert counts is not ..., "Replace the `...` with a NumPy array built from `values`."
assert isinstance(counts, np.ndarray), f"`counts` should be a NumPy array, not {type(counts).__name__}."
assert counts.dtype.kind == "u", f"Counts are never negative, so use an UNSIGNED dtype (uint...). `counts` has {counts.dtype}."
assert counts.tolist() == values, f"`counts` should hold exactly {values}, but holds {counts.tolist()}. Did a value overflow?"
assert counts.dtype == np.uint16, f"{counts.dtype} works, but it isn't the smallest unsigned type that fits 40,000. Compare the max of each with `np.iinfo`."
--- hint
List the unsigned types from smallest to largest and check each one's maximum with `np.iinfo(np.uint8).max`, `np.iinfo(np.uint16).max`, and so on.
--- hint
`uint8` stops at 255, so 256 doesn't fit. Pass your choice with `np.array(values, dtype=...)`.
```

## Floating-point precision

Floats store numbers in binary with a fixed number of significant digits, so most decimals, like `0.1`, can't be represented exactly:

```python run
print(0.1 + 0.2)
print(0.1 + 0.2 == 0.3)
print(np.isclose(0.1 + 0.2, 0.3))

print("float64 eps:", np.finfo(np.float64).eps)   # ~16 significant digits
print("float32 eps:", np.finfo(np.float32).eps)   # ~7 significant digits
print("float16 can't count past 2048 by ones:", np.float16(2048) + np.float16(1))
```

`eps` (machine epsilon) is the gap between 1.0 and the next representable number. A `float16` has so few bits that once you reach 2048, adding 1 changes nothing at all.

> **Rule:** never compare floats with `==`. Use `np.isclose(a, b)` for scalars and `np.allclose(a, b)` for whole arrays; both allow a small tolerance.

```python debug id=books-dont-balance title="The books never balance"
payments = np.array([0.1, 0.2])
expected_total = 0.3

total = payments.sum()
if total == expected_total:
    status = "balanced"
else:
    status = "MISMATCH"

print(f"total = {total!r} -> {status}")
--- solution
payments = np.array([0.1, 0.2])
expected_total = 0.3

total = payments.sum()
if np.isclose(total, expected_total):
    status = "balanced"
else:
    status = "MISMATCH"

print(f"total = {total!r} -> {status}")
--- test
assert status == "balanced", f"0.1 + 0.2 should count as matching 0.3, but `status` is {status!r}. Exact `==` on floats fails because of tiny rounding errors."
assert np.isclose(total, 0.3), "`total` should still be the sum of the payments."
--- hint
Look at the printed `total`. It's not *exactly* 0.3.
--- hint
Replace the exact comparison with a tolerant one: `np.isclose(total, expected_total)`.
```

> **In the wild:** for money, professionals avoid floats entirely and store **integer cents** (`int64`). Integers are exact; floats are approximations.

## Booleans and complex numbers

Booleans behave like 0 and 1 in arithmetic, which makes counting easy. Complex numbers unlock square roots of negatives and are everywhere in signal processing:

```python run
passed = np.array([True, False, True, True])
print("number passed:", passed.sum(), "| share:", passed.mean())

z = np.array([3 + 4j, -1 + 0j])
print("dtype:", z.dtype, "| magnitudes:", np.abs(z))
print("sqrt of -4 as complex:", np.sqrt(np.array([-4 + 0j])))
print("sqrt of -4 as float:  ", np.sqrt(np.array([-4.0])))
```

The square root of a negative `float64` is `nan`. On a desktop NumPy also prints a `RuntimeWarning: invalid value encountered`, but this browser runtime can't detect floating-point errors, so the `nan` appears silently. Either way, the dtype decides the answer: to get `2j` you need a complex input.

## Safe casting

`astype` will convert anything you ask for, even if it loses information. To guard against that, pass `casting="safe"`, or ask first with `np.can_cast`:

```python run
print("int16 -> int32 safe?  ", np.can_cast(np.int16, np.int32))
print("float64 -> int32 safe?", np.can_cast(np.float64, np.int32))
print("int64 -> int8 safe?   ", np.can_cast(np.int64, np.int8))
```

```python run error
np.array([1.5, 2.7]).astype(np.int32, casting="safe")
```

## Recap

- An array's **dtype** fixes its memory per element, its precision and its range. Check it with `.dtype`, `np.iinfo` and `np.finfo`.
- The default integer is **platform-dependent**: `int32` in this browser, usually `int64` on desktops. Pass `dtype=` when size matters.
- `astype` creates a converted copy; float → int **truncates**, so `np.round` first.
- Integer arithmetic **wraps around** silently on overflow. Widen first (`astype(np.int64)`, `int16` for pixels) and `np.clip` when you need saturation.
- Mixed operations promote to a safe common type; Python scalars are "weak" and adopt the array's dtype.
- Floats are approximations: compare with `np.isclose` / `np.allclose`, never `==`.

**Up next:** indexing and slicing in N dimensions, the core skill of selecting exactly the data you want.
