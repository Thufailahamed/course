Every time you write `a + b` or `np.sqrt(a)` on arrays, NumPy is calling a **universal function**, or *ufunc*. A ufunc is a function that works element by element, runs in compiled C, and knows how to handle arrays of any shape. They are the engine behind almost every line of fast NumPy code.

This lesson is about learning that engine well. You'll learn which operators map to which ufuncs, the rounding and clipping functions you'll use daily, the difference between `np.max` and `np.maximum` (a classic interview question), and the extra powers every ufunc has: `out=`, `where=`, `.reduce`, `.accumulate` and `.outer`.

## Operators are ufuncs in disguise

Arithmetic on arrays is **element-wise**: the operation is applied to each pair of matching elements. Each operator is shorthand for a named ufunc.

```python run
import numpy as np

a = np.array([1, 2, 3, 4])
b = np.array([10, 20, 30, 40])

print("a + b  ->", a + b, " same as np.add:", np.add(a, b))
print("a * b  ->", a * b, " same as np.multiply:", np.multiply(a, b))
print("b - a  ->", b - a, " same as np.subtract:", np.subtract(b, a))
print("a ** 2 ->", a ** 2, " same as np.power:", np.power(a, 2))
np.add
```

That last line shows the ufunc object itself. It's a real object with attributes and methods, which you'll use later in this lesson.

| Operator | ufunc | Operator | ufunc |
|---|---|---|---|
| `+` | `np.add` | `//` | `np.floor_divide` |
| `-` | `np.subtract` | `%` | `np.mod` |
| `*` | `np.multiply` | `**` | `np.power` |
| `/` | `np.divide` | `-a` | `np.negative` |
| `>` `<` `==` | `np.greater`, `np.less`, `np.equal` | `abs(a)` | `np.abs` |

> **Under the hood:** a Python loop calls `+` once per element, paying interpreter overhead every time. A ufunc makes one call and loops in C over raw memory. That's where the 10–100× speedups come from.

## The math toolbox

NumPy mirrors the `math` module, but every function works on whole arrays at once.

```python run
x = np.array([0.0, 1.0, 4.0, 9.0])
print("sqrt:", np.sqrt(x))
print("exp: ", np.exp([0.0, 1.0, 2.0]).round(3))
print("log: ", np.log([1.0, np.e, np.e ** 2]))      # natural log
print("log10:", np.log10([1, 10, 1000]))

angles = np.array([0, np.pi / 2, np.pi])
print("sin: ", np.sin(angles).round(6))
print("abs: ", np.abs(np.array([-3, 0, 2.5])))
```

> **Pitfall:** `math.sqrt(array)` fails with a `TypeError`. The `math` module only understands single numbers. Always use the `np.` version on arrays.

Some inputs are outside a function's domain. Instead of crashing, NumPy returns `nan` (not a number) or `-inf`:

```python run
print(np.log(np.array([1.0, 0.0, -1.0])))
print(np.sqrt(np.array([4.0, -4.0])))
print(np.array([1.0, -1.0]) / 0)
```

On desktop NumPy each of these lines also prints a `RuntimeWarning` such as *divide by zero encountered in log*. The browser build of NumPy can't detect floating-point exceptions, so here the results appear silently. Either way, a stray `nan` or `inf` is your signal that something went outside the valid range. You'll meet NaN properly in a later lesson.

## Rounding: round, floor, ceil and trunc

Four functions, four different rules. Mixing them up is a common source of off-by-one bugs.

```python run
v = np.array([-2.5, -1.7, -0.2, 0.2, 1.5, 2.5, 2.7])

print("round:", np.round(v))   # nearest; ties go to the EVEN number
print("floor:", np.floor(v))   # always down (toward -infinity)
print("ceil: ", np.ceil(v))    # always up (toward +infinity)
print("trunc:", np.trunc(v))   # toward zero (drop the decimals)
print("round to 1 dp:", np.round(np.array([3.14159, 2.71828]), 1))
```

Look at `round`: `1.5 → 2` but `2.5 → 2`. NumPy (like Python) uses **banker's rounding**: exact halves go to the nearest even number, which avoids a systematic upward bias when you round millions of values. Also note that all four return **floats**; use `.astype(int)` if you need integers.

```python predict id=predict-floor title="Floor of negative numbers"
print(np.floor(np.array([-1.5, 1.5])))
--- options
[-1.  1.]
* [-2.  1.]
[-1.  2.]
[-2.  2.]
--- explain
`floor` always rounds **down**, toward negative infinity. Down from `-1.5` is `-2`, and down from `1.5` is `1`. If you wanted "chop off the decimals" behavior, that's `np.trunc`, which gives `[-1.  1.]`.
```

## clip, and maximum vs. max

`np.clip(a, lo, hi)` limits every value to the range `[lo, hi]`. It's perfect for capping outliers, keeping probabilities inside `[0, 1]`, or keeping pixel values in `0..255`.

```python run
readings = np.array([-5, 12, 47, 103, 88, 250])
print("clipped to 0..100:", np.clip(readings, 0, 100))

# Two functions with confusingly similar names:
a = np.array([3, 9, 1, 7])
b = np.array([5, 2, 8, 6])
print("np.max(a)        ->", np.max(a))            # ONE number: the largest in a
print("np.maximum(a, b) ->", np.maximum(a, b))     # element-wise: larger of each pair
print("np.maximum(a, 5) ->", np.maximum(a, 5))     # floor every value at 5
```

- `np.max(a)` is an **aggregation**: it collapses an array to its single largest value.
- `np.maximum(a, b)` is a **ufunc**: it compares two arrays element by element and returns an array of the same shape.

`np.maximum(x, 0)` is exactly the **ReLU** activation used in neural networks.

```python exercise id=relu-and-clip title="Activations from ufuncs"
z = np.array([-2.0, -0.5, 0.0, 1.5, 3.0, 8.0])

# TODO 1: `relu` should be z with every negative value replaced by 0.
#         (Use a ufunc: no loops, no if-statements.)
relu = ...

# TODO 2: `capped` should be z limited to the range [-1, 1].
capped = ...
--- solution
z = np.array([-2.0, -0.5, 0.0, 1.5, 3.0, 8.0])

relu = np.maximum(z, 0)
capped = np.clip(z, -1, 1)
--- test
assert relu is not ..., "Replace the `...` after `relu =` with your code."
assert capped is not ..., "Replace the `...` after `capped =` with your code."
assert isinstance(relu, np.ndarray), "`relu` should be a NumPy array with one value per element of `z`."
assert relu.shape == z.shape, f"`relu` should have the same shape as `z` {z.shape}, but has {relu.shape}. Did you use np.max instead of np.maximum?"
assert np.allclose(relu, [0, 0, 0, 1.5, 3, 8]), f"`relu` should keep positives and turn negatives into 0, but it is {relu}."
assert isinstance(capped, np.ndarray) and capped.shape == z.shape, "`capped` should be an array with the same shape as `z`."
assert np.allclose(capped, [-1, -0.5, 0, 1, 1, 1]), f"`capped` should limit every value to [-1, 1], but it is {capped}."
--- hint
You need an *element-wise* "larger of two values" for `relu`, and a "limit to a range" function for `capped`.
--- hint
`np.maximum(z, 0)` compares every element with 0. For the range, look at `np.clip(array, low, high)`.
```

## Division: true, floor and modulo

`/` always produces floats ("true division"). `//` rounds down to the nearest integer ("floor division"), and `%` gives the remainder. Together they convert seconds to minutes, flat indices to row/column, and much more.

```python run
seconds = np.array([59, 60, 125, 3600])
print("minutes (float):", seconds / 60)
print("whole minutes:  ", seconds // 60)
print("leftover secs:  ", seconds % 60)

# Flat position -> (row, col) in a grid that is 4 columns wide
idx = np.arange(10)
print("rows:", idx // 4)
print("cols:", idx % 4)
```

> **Pitfall:** `//` floors toward negative infinity, so `-7 // 2` is `-4`, not `-3`. That matters when your data can be negative.

```python debug id=average-rating title="The ratings average is always a whole number"
# A product has received this many 1..5 star ratings.
star_counts = np.array([4, 1, 7, 20, 31])          # counts for 1, 2, 3, 4, 5 stars
stars = np.arange(1, 6)

total_stars = (stars * star_counts).sum()
num_ratings = star_counts.sum()
average = total_stars // num_ratings

print(f"Average rating: {average} from {num_ratings} ratings")
--- solution
star_counts = np.array([4, 1, 7, 20, 31])
stars = np.arange(1, 6)

total_stars = (stars * star_counts).sum()
num_ratings = star_counts.sum()
average = total_stars / num_ratings

print(f"Average rating: {average} from {num_ratings} ratings")
--- test
assert np.isclose(average, 262 / 63), f"`average` should be the exact mean rating (about 4.16), but it is {average!r}. Is part of the answer being thrown away?"
assert num_ratings == 63, "Don't change how `num_ratings` is computed."
--- hint
Run it. Is 4 really the average of mostly 4s and 5s? Something is discarding the fractional part.
--- hint
`//` is *floor* division. Which operator keeps the decimals?
```

## Comparisons produce boolean arrays

Comparison operators are ufuncs too. They return arrays of `True`/`False`, which you can count, combine and use as masks.

```python run
temps = np.array([12, 25, 31, 18, 29, 35])
hot = temps > 28
print("hot days:   ", hot)
print("how many:   ", hot.sum())           # True counts as 1
print("fraction:   ", hot.mean())
print("mild (18-28):", (temps >= 18) & (temps <= 28))
```

Because `True` is 1 and `False` is 0, `.sum()` counts matches and `.mean()` gives the fraction. Combine conditions with `&` (and), `|` (or) and `~` (not), and **always wrap each comparison in parentheses**, because `&` binds more tightly than `>`.

## Superpowers: out= and where=

Every ufunc accepts two extra arguments:

- `out=` writes the result into an existing array instead of allocating a new one. That's useful for large arrays and tight loops.
- `where=` applies the operation only where a boolean mask is `True`. Elsewhere, `out` keeps its old values.

```python run
values = np.array([4.0, 0.0, 9.0, 0.0, 16.0])
counts = np.array([2.0, 0.0, 3.0, 0.0, 4.0])

# Safe division: only divide where counts != 0, use 0.0 elsewhere.
result = np.zeros_like(values)
np.divide(values, counts, out=result, where=counts != 0)
print("safe ratio:", result)

# In-place: square roots written back into the same array
buf = np.array([1.0, 4.0, 9.0])
np.sqrt(buf, out=buf)
buf
```

> **Pitfall:** always pass an initialized `out=` array when you use `where=`. Positions where the mask is `False` are **not written**, so without `out` they would contain uninitialized garbage.

```python exercise id=safe-per-capita title="Safe per-capita rates"
cases = np.array([120.0, 0.0, 45.0, 300.0, 18.0])
population = np.array([10_000.0, 0.0, 1_500.0, 0.0, 2_000.0])   # 0 = missing data

# TODO: compute `rate` = cases / population * 1000 (cases per 1,000 people),
# but wherever population is 0 the rate must be 0.0, and no division-by-zero
# should happen. Use np.divide with out= and where=.
rate = ...
--- solution
cases = np.array([120.0, 0.0, 45.0, 300.0, 18.0])
population = np.array([10_000.0, 0.0, 1_500.0, 0.0, 2_000.0])

rate = np.zeros_like(cases)
np.divide(cases, population, out=rate, where=population != 0)
rate *= 1000
--- test
assert rate is not ..., "Replace the `...` after `rate =` with your code."
assert isinstance(rate, np.ndarray), "`rate` should be a NumPy array."
assert rate.shape == cases.shape, f"`rate` should have one value per region {cases.shape}, but has shape {rate.shape}."
assert not np.isnan(rate).any() and not np.isinf(rate).any(), f"`rate` contains nan or inf: {rate}. Where population is 0, the rate should be exactly 0.0."
assert np.allclose(rate, [12.0, 0.0, 30.0, 0.0, 9.0]), f"Expected cases per 1,000 people, got {rate}."
--- hint
Start with `rate = np.zeros_like(cases)` so the "skipped" positions already hold 0.0.
--- hint
`np.divide(cases, population, out=rate, where=population != 0)` fills only the valid positions. Then scale by 1000.
```

## Ufunc methods: reduce, accumulate, outer

Because ufuncs are objects, they come with methods that turn a simple two-input operation into something much more powerful.

```python run
a = np.array([1, 2, 3, 4, 5])

print("add.reduce:       ", np.add.reduce(a))          # 1+2+3+4+5 = sum
print("multiply.reduce:  ", np.multiply.reduce(a))     # 1*2*3*4*5 = product
print("add.accumulate:   ", np.add.accumulate(a))      # running sum = cumsum
print("maximum.accumulate:", np.maximum.accumulate(np.array([3, 1, 4, 1, 5, 9, 2])))

# outer: apply the op to EVERY pair -> a 2-D table
print(np.multiply.outer(np.arange(1, 4), np.arange(1, 6)))
```

- `ufunc.reduce` folds an array down to one value. `np.add.reduce` is what `np.sum` does.
- `ufunc.accumulate` keeps every intermediate result. `np.maximum.accumulate` gives a "running maximum", the highest value seen so far, which is great for tracking peaks or drawdowns in a price series.
- `ufunc.outer(x, y)` builds the full table of `op(x[i], y[j])`. The multiplication table above has shape `(3, 5)`.

```python predict id=predict-accumulate title="Running maximum"
print(np.maximum.accumulate(np.array([2, 5, 3, 8, 1])))
--- options
[2 7 10 18 19]
* [2 5 5 8 8]
[8 8 8 8 8]
[2 5 3 8 1]
--- explain
`accumulate` keeps every partial result: max(2)=2, max(2,5)=5, max(5,3)=5, max(5,8)=8, max(8,1)=8. It's a running maximum. (`[2 7 10 18 19]` would be `np.add.accumulate`, the running sum.)
```

```python exercise id=record-highs title="Days that set a new record"
# Daily closing price of a stock
price = np.array([100, 102, 101, 105, 104, 108, 108, 107, 112])

# TODO 1: `running_high` = the highest price seen up to and including each day.
running_high = ...

# TODO 2: `drawdown` = how far each day's price is below its running high
#         (0 on days at the high, positive otherwise).
drawdown = ...
--- solution
price = np.array([100, 102, 101, 105, 104, 108, 108, 107, 112])

running_high = np.maximum.accumulate(price)
drawdown = running_high - price
--- test
assert running_high is not ..., "Replace the `...` after `running_high =` with your code."
assert drawdown is not ..., "Replace the `...` after `drawdown =` with your code."
assert isinstance(running_high, np.ndarray) and running_high.shape == price.shape, "`running_high` should be an array with one value per day."
assert np.array_equal(running_high, [100, 102, 102, 105, 105, 108, 108, 108, 112]), f"`running_high` should never decrease and should track the best price so far, but it is {running_high}."
assert isinstance(drawdown, np.ndarray) and drawdown.shape == price.shape, "`drawdown` should be an array with one value per day."
assert np.array_equal(drawdown, [0, 0, 1, 0, 1, 0, 0, 1, 0]), f"`drawdown` should be running_high - price, but it is {drawdown}."
--- hint
You want a *running* version of "maximum". Which ufunc method keeps every intermediate result?
--- hint
`np.maximum.accumulate(price)` gives the running high. The drawdown is a simple element-wise subtraction.
```

```python debug id=power-overflow title="Squares that go negative"
# Squared distances in meters for a sensor network
distances = np.array([1_000, 30_000, 50_000, 70_000], dtype=np.int32)

squared = distances ** 2
print("squared distances:", squared)
print("all positive?", (squared > 0).all())
--- solution
distances = np.array([1_000, 30_000, 50_000, 70_000], dtype=np.int32)

squared = distances.astype(np.int64) ** 2
print("squared distances:", squared)
print("all positive?", (squared > 0).all())
--- test
assert (np.asarray(squared) > 0).all(), f"Some squares are not positive: {squared}. The int32 type can only hold values up to about 2.1 billion."
assert np.array_equal(np.asarray(squared, dtype=np.float64), np.array([1e6, 9e8, 2.5e9, 4.9e9])), f"Expected the true squares [1e6, 9e8, 2.5e9, 4.9e9], got {squared}."
--- hint
Run it. A distance squared can't be negative. What is the largest number an `int32` can hold?
--- hint
`np.iinfo(np.int32).max` is about 2.1 billion, and 50,000² is 2.5 billion. Convert to a wider type (`np.int64` or `float`) *before* squaring.
```

Integer ufuncs wrap around silently on overflow instead of raising an error. That's the price of C speed, and you saw it in detail in the dtypes lesson.

## Recap

- Operators like `+`, `*`, `>` and `**` are ufuncs: element-wise, compiled and fast.
- `np.round` uses banker's rounding; `floor`, `ceil` and `trunc` each round in a fixed direction and all return floats.
- `np.max` collapses an array; `np.maximum` compares two arrays element by element. `np.clip` limits values to a range.
- `/` gives floats, `//` floors, `%` is the remainder. Watch out for `//` when you wanted an average.
- `out=` reuses memory and `where=` masks the operation. Together they give safe division.
- `.reduce`, `.accumulate` and `.outer` turn any binary ufunc into sums, running totals and lookup tables.

**Up next:** broadcasting, the rule that decides what happens when you combine arrays of *different* shapes.
