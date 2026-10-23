Python lists are wonderful. They hold anything, grow on demand, and you've used them since your first week of Python. So why does every data library, from pandas and scikit-learn to PyTorch and JAX, build on a different container?

Because lists are built for **flexibility**, and numerical work needs **speed and math**. By the end of this lesson you'll understand what a NumPy array really is, why it's often 50× faster than a list, and when a plain list is still the right tool.

## Lists don't do math

Start with something that looks like it should work. Two lists of numbers, added together:

```python run
a = [1, 2, 3]
b = [10, 20, 30]

print("a + b =", a + b)
print("a * 3 =", a * 3)
```

That's not arithmetic. To a list, `+` means **concatenate** and `* 3` means **repeat three times**. Lists are general-purpose sequences: they have no idea their contents are numbers.

To add element by element with lists, you need a loop (or a comprehension):

```python run
a = [1, 2, 3]
b = [10, 20, 30]

sums = [x + y for x, y in zip(a, b)]
scaled = [x * 3 for x in a]
print("sums:  ", sums)
print("scaled:", scaled)
```

It works, but you'll write that pattern thousands of times, and as you'll see shortly, it's slow.

## Arrays do math, element by element

A NumPy array looks like a list but behaves like a mathematical vector. Operators apply **to every element**:

```python run
import numpy as np

a = np.array([1, 2, 3])
b = np.array([10, 20, 30])

print("a + b  =", a + b)
print("a * 3  =", a * 3)
print("a ** 2 =", a ** 2)
print("b / a  =", b / a)
```

No loops, no comprehensions. This style, operating on whole arrays at once, is called **vectorization**, and it's the single most important idea in this course.

Notice the printed form too: arrays print with **spaces, not commas**: `[11 22 33]`, not `[11, 22, 33]`. That's how you can tell an array from a list at a glance.

```python predict id=predict-array-times-two title="What does this print?"
a = np.array([1, 2, 3])
print(a * 2)
--- options
[2, 4, 6]
* [2 4 6]
[1 2 3 1 2 3]
[1, 2, 3, 1, 2, 3]
--- explain
Arrays multiply **element-wise**, so every element is doubled. And arrays print without commas: `[2 4 6]`. The list version, `[1, 2, 3] * 2`, would repeat the list instead: `[1, 2, 3, 1, 2, 3]`.
```

```python exercise id=price-with-tax title="Add sales tax to every price"
prices = [19.99, 5.49, 120.00, 42.50]

# 1. Convert `prices` into a NumPy array called `prices_arr`.
# 2. Compute `with_tax`: every price increased by 20% (multiply by 1.2).
#    No loops or comprehensions. Let NumPy do the work.
prices_arr = ...
with_tax = ...
--- solution
prices = [19.99, 5.49, 120.00, 42.50]

prices_arr = np.array(prices)
with_tax = prices_arr * 1.2
--- test
assert prices_arr is not ..., "Replace the `...` after `prices_arr =` with your code."
assert isinstance(prices_arr, np.ndarray), f"`prices_arr` should be a NumPy array, but it is a {type(prices_arr).__name__}. Try `np.array(prices)`."
assert with_tax is not ..., "Replace the `...` after `with_tax =` with your code."
assert isinstance(with_tax, np.ndarray), f"`with_tax` should be a NumPy array, but it is a {type(with_tax).__name__}."
assert with_tax.shape == (4,), f"`with_tax` should hold 4 prices, but its shape is {with_tax.shape}."
assert np.allclose(with_tax, [23.988, 6.588, 144.0, 51.0]), "Each price should be multiplied by 1.2. Check your numbers."
--- hint
First turn the list into an array with `np.array(...)`. Once you have an array, arithmetic applies to every element.
--- hint
`prices_arr * 1.2` multiplies each element by 1.2.
```

## Why arrays are fast

Let's measure. We'll sum the squares of 200,000 numbers, once with a Python loop and once with NumPy:

```python run
import time

n = 200_000
numbers = list(range(n))
arr = np.arange(n, dtype=np.float64)

start = time.perf_counter()
total = 0
for x in numbers:
    total += x * x
loop_ms = (time.perf_counter() - start) * 1000

start = time.perf_counter()
total_np = (arr * arr).sum()
numpy_ms = (time.perf_counter() - start) * 1000

print(f"Python loop: {loop_ms:7.2f} ms")
print(f"NumPy:       {numpy_ms:7.2f} ms")
print(f"Speed-up:    {loop_ms / numpy_ms:.0f}x")
```

Run it a few times: the exact numbers vary, but NumPy wins by a wide margin. (Here `np.arange(n)` just means "the numbers 0 to n-1 as an array". You'll meet it properly in a later lesson.)

Where does that speed come from? It's all about how the data is stored.

> **Under the hood:** a Python list is an array of *pointers*. Each element is a separate Python object living somewhere else in memory, with its own type tag and reference count. To add two elements, the interpreter must follow both pointers, check both types, find the right `+`, and allocate a brand-new object for the result.
>
> A NumPy array is a single **contiguous block of raw numbers**, all of the **same type**. Adding two arrays runs one tight loop in compiled C over that block, with no type checks per element and no objects created. Modern CPUs love this layout: it fits caches well and can process several numbers per instruction.

Two properties make all of that possible:

| | Python list | NumPy array |
|---|---|---|
| Element types | Anything, mixed | **One** type for all elements (the *dtype*) |
| Storage | Pointers to scattered objects | One contiguous block of raw values |
| `+` and `*` | Concatenate / repeat | Element-wise math |
| Size | Grows with `.append` | Fixed when created |
| Speed on numbers | Interpreter loop | Compiled loop over raw memory |

## Arrays are compact, too

All those separate Python objects cost memory. Let's compare 1,000 floats:

```python run
import sys

values = [float(i) for i in range(1000)]
arr = np.array(values)

list_bytes = sys.getsizeof(values) + sum(sys.getsizeof(v) for v in values)
print(f"list : {list_bytes:,} bytes")
print(f"array: {arr.nbytes:,} bytes of data")
print(f"The list uses about {list_bytes / arr.nbytes:.1f}x more memory")
```

Each float in the array takes exactly 8 bytes. In a list, each float is a full Python object (24 bytes) *plus* an 8-byte pointer to it. With millions of values, that difference decides whether your data fits in memory at all.

## One array, one type

Because an array stores raw values of a single type, NumPy must pick **one** type that fits everything you give it. Watch what happens with mixed inputs:

```python run
ints = np.array([1, 2, 3])
mixed = np.array([1, 2.5, 3])
words = np.array([1, "two", 3.0])

print(ints, "->", ints.dtype)
print(mixed, "->", mixed.dtype)
print(words, "->", words.dtype)
```

- A single float makes the whole array `float64`: the integers are converted to `1.0` and `3.0`.
- A string makes everything a string (`<U32` means "Unicode string, up to 32 characters"). Your numbers are now text, and math on them will fail.

> **Pitfall:** the integer type you see may be `int64` *or* `int32`. NumPy uses your platform's native integer size, and this in-browser Python uses 32-bit integers, while most desktop Pythons use 64-bit. Floats are `float64` everywhere. You'll learn to control dtypes precisely in a later lesson.

```python debug id=list-math-bug title="Adding up two sensors"
# Two sensors measured the same 4 moments. We want the element-wise total,
# e.g. the first total should be 1.5 + 0.5 = 2.0
sensor_a = [1.5, 2.0, 2.5, 3.0]
sensor_b = [0.5, 0.5, 1.0, 1.0]

total = sensor_a + sensor_b
print("total:", total)
--- solution
sensor_a = np.array([1.5, 2.0, 2.5, 3.0])
sensor_b = np.array([0.5, 0.5, 1.0, 1.0])

total = sensor_a + sensor_b
print("total:", total)
--- test
assert len(total) == 4, f"`total` should have 4 values (one per moment), but it has {len(total)}. Did the two lists get glued together?"
assert np.allclose(total, [2.0, 2.5, 3.5, 4.0]), "Each value of `total` should be sensor_a + sensor_b at that moment."
assert isinstance(total, np.ndarray), "Make `total` a NumPy array by working with arrays instead of lists."
--- hint
Run the code and count how many values `total` has. Is that what "element-wise total" means?
--- hint
With lists, `+` concatenates. Convert the readings to NumPy arrays first, and `+` will add element by element.
```

```python exercise id=celsius-to-fahrenheit title="Convert a week of temperatures"
celsius = [12.0, 15.5, 18.0, 21.5, 19.0, 16.5, 14.0]

# Convert every temperature to Fahrenheit using  F = C * 9/5 + 32
# Store the result as a NumPy array in `fahrenheit`. One line, no loop.
fahrenheit = ...
--- solution
celsius = [12.0, 15.5, 18.0, 21.5, 19.0, 16.5, 14.0]

fahrenheit = np.array(celsius) * 9 / 5 + 32
--- test
assert fahrenheit is not ..., "Replace the `...` with your conversion."
assert isinstance(fahrenheit, np.ndarray), f"`fahrenheit` should be a NumPy array, but it is a {type(fahrenheit).__name__}."
assert fahrenheit.shape == (7,), f"There are 7 temperatures, but `fahrenheit` has shape {fahrenheit.shape}."
expected = np.array(celsius) * 9 / 5 + 32
assert np.allclose(fahrenheit, expected), f"The first value should be {expected[0]:.1f}°F (12°C). Check the formula: C * 9/5 + 32."
--- hint
Convert the list with `np.array(celsius)`, then write the formula exactly as you would for a single number.
--- hint
`np.array(celsius) * 9 / 5 + 32` applies the formula to all seven values at once.
```

## When lists are still the right tool

NumPy arrays are not a replacement for lists everywhere. Lists are better when:

- **You're building a collection one item at a time.** Lists append in constant time. An array has a fixed size, so `np.append` copies the *entire* array every call.
- **The data is ragged or mixed:** rows of different lengths, records that combine names, numbers and dates.
- **The collection is small and you aren't doing math on it.** A list of five file names doesn't need NumPy.

The idiomatic pattern is: **collect in a list, convert once, then compute with arrays.**

```python run
import time

n = 5_000

start = time.perf_counter()
grown = np.array([])
for i in range(n):
    grown = np.append(grown, i * 0.5)   # copies the whole array every time!
append_ms = (time.perf_counter() - start) * 1000

start = time.perf_counter()
items = []
for i in range(n):
    items.append(i * 0.5)               # cheap
collected = np.array(items)             # convert once
list_ms = (time.perf_counter() - start) * 1000

print(f"np.append in a loop: {append_ms:6.1f} ms")
print(f"list, then convert:  {list_ms:6.1f} ms")
print("same result:", np.array_equal(grown, collected))
```

> **In the wild:** this is exactly why pandas tells you not to grow a DataFrame row by row. Each append copies everything. Build a list of rows (or dicts) and construct the DataFrame once.

```python debug id=append-in-loop-bug title="Where did my results go?"
readings = [3, 1, 4, 1, 5, 9, 2, 6]

# Goal: `squares` should hold the square of every reading.
squares = np.array([])
for r in readings:
    np.append(squares, r ** 2)

print("squares:", squares)
--- solution
readings = [3, 1, 4, 1, 5, 9, 2, 6]

squares = np.array(readings) ** 2

print("squares:", squares)
--- test
assert isinstance(squares, np.ndarray), "`squares` should be a NumPy array."
assert squares.size == 8, f"`squares` should hold 8 values, one per reading, but it holds {squares.size}."
assert np.allclose(squares, [9, 1, 16, 1, 25, 81, 4, 36]), "Each value should be the square of the matching reading."
--- hint
Run it with **Debug** and watch `squares` as the loop runs. Does it ever change?
--- hint
`np.append` doesn't modify the array in place. It *returns a new array*, and here that return value is thrown away.
--- hint
You don't need a loop at all: convert `readings` to an array and square the whole thing with `** 2`.
```

## Recap

- Lists treat `+` as concatenation and `*` as repetition; arrays do **element-wise math**.
- An array is one contiguous block of values that all share **one dtype**, which is why vectorized code runs in compiled C and is dramatically faster.
- Arrays are compact: 8 bytes per float instead of more than 30 for a Python float in a list.
- Mixed inputs are converted to a single common type. A stray string turns everything into text.
- Use lists to *collect* data and arrays to *compute* on it; never grow an array with `np.append` in a loop.

**Up next:** creating your first arrays, and reading their `shape`, `dtype` and other vital statistics.
