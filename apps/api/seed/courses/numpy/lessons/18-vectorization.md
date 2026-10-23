You now know all the ingredients: ufuncs, broadcasting, masks and aggregations. This lesson is about the **skill** that combines them: looking at a Python loop and rewriting it as a handful of whole-array operations. That's what "vectorized code" means, and it's the single biggest difference between NumPy code that crawls and NumPy code that flies.

You'll learn a repeatable recipe for translating loops, measure the speedups yourself, and work through the classics every data scientist writes eventually: conditional logic with `np.where`, moving averages, a numerically stable softmax and one-hot encoding. You'll also learn when *not* to bother, because some loops are perfectly fine.

## How big is the difference?

Let's measure it. Both versions compute the sum of squares of 50,000 numbers.

```python run
import numpy as np
import time

x = np.random.default_rng(0).random(50_000)

t0 = time.perf_counter()
total = 0.0
for value in x:
    total += value * value
loop_s = time.perf_counter() - t0

t0 = time.perf_counter()
total_vec = np.sum(x * x)
vec_s = time.perf_counter() - t0

print(f"loop:       {loop_s * 1000:8.2f} ms  -> {total:.4f}")
print(f"vectorized: {vec_s * 1000:8.2f} ms  -> {total_vec:.4f}")
print(f"speedup:    {loop_s / vec_s:8.0f}x")
```

The exact numbers depend on your machine (and Python here runs inside your browser), but the gap is almost always **dozens to hundreds of times**. The loop pays Python's interpreter overhead for each of the 50,000 elements; the vectorized version makes a couple of calls and loops in C.

> **Tip:** `time.perf_counter()` is the right clock for measuring short durations. For serious benchmarks, repeat the measurement several times and take the best. The first run often includes one-off warm-up costs.

## The translation recipe

Almost every numeric loop can be translated with four moves:

| In the loop you see… | Replace it with… |
|---|---|
| arithmetic on one element (`x[i] * 2 + 1`) | the same arithmetic on the whole array (`x * 2 + 1`) |
| `if` / `else` choosing a value | `np.where(condition, a, b)` or a boolean mask |
| an accumulator (`total += …`, `best = max(best, …)`) | a reduction (`.sum()`, `.max()`, `.argmax()`) |
| a running value (`running += x[i]; out.append(running)`) | a cumulative op (`.cumsum()`, `np.maximum.accumulate`) |
| a nested loop over pairs | broadcasting (`a[:, None] - b`) |

Let's apply it. Here's a shipping-cost calculator written the "Python way":

```python run
weights = np.array([0.4, 2.5, 7.0, 1.2, 12.5, 4.8])   # kg

def shipping_loop(weights):
    costs = []
    for w in weights:
        if w <= 1:
            costs.append(4.99)              # flat rate for small parcels
        else:
            costs.append(4.99 + 1.5 * (w - 1))
    return np.array(costs)

def shipping_vec(weights):
    return np.where(weights <= 1, 4.99, 4.99 + 1.5 * (weights - 1))

print(shipping_loop(weights))
print(shipping_vec(weights))
print("same?", np.allclose(shipping_loop(weights), shipping_vec(weights)))
```

`np.where(cond, a, b)` is the vectorized `if/else`: wherever `cond` is `True` it picks from `a`, otherwise from `b`. All three arguments broadcast, so `a` and `b` can be scalars or arrays.

> **Pitfall:** `np.where` evaluates **both** branches for every element and then picks. If a branch could fail (like dividing by zero or taking `log(0)`), it still runs and still warns. In that case, use the `where=` argument from the ufuncs lesson instead.

```python predict id=predict-where title="What does np.where return?"
temps = np.array([12, 25, 31, 18])
print(np.where(temps > 20, "warm", "cool"))
--- options
['cool' 'warm']
* ['cool' 'warm' 'warm' 'cool']
[1 2]
[False  True  True False]
--- explain
With three arguments, `np.where` returns an array the same shape as the condition, choosing `"warm"` where it's `True` and `"cool"` where it's `False`. (With only one argument, `np.where(temps > 20)` would instead return the **indices** of the `True` values: `(array([1, 2]),)`.)
```

## More than two choices: np.select

For multi-way branching (`if / elif / elif / else`), nesting `np.where` gets ugly fast. `np.select` takes a list of conditions and a matching list of choices; the **first** true condition wins.

```python run
scores = np.array([95, 82, 67, 74, 58, 88])

conditions = [scores >= 90, scores >= 80, scores >= 70, scores >= 60]
choices = ["A", "B", "C", "D"]
grades = np.select(conditions, choices, default="F")
grades
```

```python exercise id=vectorize-tax title="Vectorize the tax calculator"
def tax_loop(incomes):
    """Reference implementation: progressive tax, one person at a time."""
    out = []
    for income in incomes:
        if income <= 10_000:
            tax = 0.0
        elif income <= 40_000:
            tax = (income - 10_000) * 0.20
        else:
            tax = 30_000 * 0.20 + (income - 40_000) * 0.40
        out.append(tax)
    return np.array(out)

# TODO: implement tax_vec(incomes) so it returns exactly what tax_loop returns,
# for an ARRAY of incomes, without any Python loop (no for, no list comprehension).
# np.select or nested np.where both work.
def tax_vec(incomes):
    incomes = np.asarray(incomes, dtype=float)
    ...

print(tax_vec(np.array([8_000, 25_000, 40_000, 100_000])))
--- solution
def tax_loop(incomes):
    out = []
    for income in incomes:
        if income <= 10_000:
            tax = 0.0
        elif income <= 40_000:
            tax = (income - 10_000) * 0.20
        else:
            tax = 30_000 * 0.20 + (income - 40_000) * 0.40
        out.append(tax)
    return np.array(out)

def tax_vec(incomes):
    incomes = np.asarray(incomes, dtype=float)
    return np.select(
        [incomes <= 10_000, incomes <= 40_000],
        [0.0, (incomes - 10_000) * 0.20],
        default=30_000 * 0.20 + (incomes - 40_000) * 0.40,
    )

print(tax_vec(np.array([8_000, 25_000, 40_000, 100_000])))
--- test
import inspect
probe = np.array([0, 9_999, 10_000, 10_001, 25_000, 40_000, 40_001, 123_456.0])
res = tax_vec(probe)
assert res is not None, "`tax_vec` returned None. Don't forget the `return` statement."
res = np.asarray(res, dtype=float)
assert res.shape == probe.shape, f"`tax_vec` should return one tax per income (shape {probe.shape}), but returned shape {res.shape}."
assert np.allclose(res, tax_loop(probe)), f"For incomes {probe.tolist()} the taxes should be {tax_loop(probe).tolist()}, but tax_vec returned {res.tolist()}."
rng = np.random.default_rng(7)
fresh = rng.uniform(0, 200_000, 500)
assert np.allclose(tax_vec(fresh), tax_loop(fresh)), "tax_vec matches on the example incomes but not on random ones. Check each bracket's formula."
src = inspect.getsource(tax_vec)
assert " for " not in src and "\tfor " not in src and "while" not in src, "`tax_vec` still contains a loop. Express the brackets with np.select or np.where instead."
--- hint
Translate each branch into an array expression: the condition becomes a boolean array, and each `tax = ...` becomes a whole-array formula.
--- hint
`np.select([incomes <= 10_000, incomes <= 40_000], [0.0, (incomes - 10_000) * 0.20], default=...)`. Conditions are checked in order, so the second one only applies to incomes above 10,000.
```

```python debug id=and-vs-amp title="The working-age filter crashes"
ages = np.array([12, 19, 35, 64, 70, 41, 17])
salaries = np.array([0, 18_000, 52_000, 61_000, 0, 75_000, 4_000])

# Working age is 18 to 64 inclusive. Count workers and their average salary.
working = (ages >= 18) and (ages <= 64)

print("working-age people:", working.sum())
print("average salary:", salaries[working].mean())
--- solution
ages = np.array([12, 19, 35, 64, 70, 41, 17])
salaries = np.array([0, 18_000, 52_000, 61_000, 0, 75_000, 4_000])

working = (ages >= 18) & (ages <= 64)

print("working-age people:", working.sum())
print("average salary:", salaries[working].mean())
--- test
working = np.asarray(working)
assert working.dtype == bool and working.shape == ages.shape, f"`working` should be a boolean array with one entry per person, got dtype {working.dtype} and shape {working.shape}."
assert working.tolist() == [False, True, True, True, False, True, False], f"`working` marks the wrong people: {working.tolist()}. Ages 18 to 64 inclusive count."
assert "51500" in _stdout.replace(",", ""), "Print the average salary of the working-age people (it should be 51500.0)."
--- hint
Run it and read the error. Python's `and` needs a single True/False, but each comparison produces a whole array.
--- hint
Use the element-wise operator `&` instead of `and`, and keep the parentheses around each comparison.
```

## Running computations: the moving average

A **moving average** smooths noisy data by averaging each window of `k` consecutive values. The loop version re-adds `k` numbers for every window. There's a beautiful vectorized trick using `cumsum`: the sum of any window is the difference of two cumulative sums.

$$
\text{window sum}(i, i+k) = C_{i+k} - C_i, \quad \text{where } C = [0, x_0, x_0 + x_1, \dots]
$$

```python run
x = np.array([3.0, 5.0, 4.0, 8.0, 6.0, 9.0, 7.0, 10.0])
k = 3

# Loop version
loop_ma = np.array([x[i:i + k].mean() for i in range(len(x) - k + 1)])

# Vectorized: one cumsum, one subtraction, one division
c = np.concatenate([[0.0], np.cumsum(x)])
vec_ma = (c[k:] - c[:-k]) / k

print("loop:      ", loop_ma.round(3))
print("vectorized:", vec_ma.round(3))
```

Each window costs one subtraction no matter how big `k` is. With a window of 1,000 points, that's 1,000 times less work than re-summing.

```python exercise id=moving-average title="Smooth a noisy signal"
# TODO: implement moving_average(x, k) returning the mean of every window of k
# consecutive values (so the result has len(x) - k + 1 values).
# Use the cumsum trick: no Python loops.
def moving_average(x, k):
    x = np.asarray(x, dtype=float)
    ...

print(moving_average([1, 2, 3, 4, 5, 6], 2))   # expect [1.5 2.5 3.5 4.5 5.5]
--- solution
def moving_average(x, k):
    x = np.asarray(x, dtype=float)
    c = np.concatenate([[0.0], np.cumsum(x)])
    return (c[k:] - c[:-k]) / k

print(moving_average([1, 2, 3, 4, 5, 6], 2))
--- test
import inspect
out = moving_average([1, 2, 3, 4, 5, 6], 2)
assert out is not None, "`moving_average` returned None. Did you forget `return`?"
out = np.asarray(out, dtype=float)
assert out.shape == (5,), f"6 values with k=2 give 5 windows, so the result should have shape (5,), but has {out.shape}."
assert np.allclose(out, [1.5, 2.5, 3.5, 4.5, 5.5]), f"moving_average([1..6], 2) should be [1.5 2.5 3.5 4.5 5.5], got {out}."
sig = np.random.default_rng(3).normal(size=200)
for k in (1, 5, 17):
    ref = np.convolve(sig, np.ones(k) / k, mode="valid")
    got = np.asarray(moving_average(sig, k), dtype=float)
    assert got.shape == ref.shape and np.allclose(got, ref), f"With k={k} on a 200-point signal, the result should have {ref.size} values matching each window's mean."
src = inspect.getsource(moving_average)
assert " for " not in src and "while" not in src, "`moving_average` still contains a loop. Use the cumsum trick instead."
--- hint
Build `c` = a 0 followed by `np.cumsum(x)`. Then the sum of the window starting at `i` is `c[i + k] - c[i]`.
--- hint
`c[k:]` lines up every window's end with `c[:-k]`, every window's start. Subtract them and divide by `k`.
```

## Softmax: vectorized and numerically stable

Softmax turns a vector of scores into probabilities. It's used at the end of almost every classification network:

$$
\text{softmax}(z)_i = \frac{e^{z_i}}{\sum_j e^{z_j}}
$$

Vectorized, it's two lines. There's a catch, though: `np.exp` overflows to `inf` for inputs above about 709, and `inf / inf` is `nan`. The standard fix exploits the fact that softmax doesn't change if you subtract the same constant from every score, so you subtract the **maximum** first.

```python run
def softmax(z):
    z = np.asarray(z, dtype=float)
    e = np.exp(z - z.max(axis=-1, keepdims=True))   # largest exponent becomes e^0 = 1
    return e / e.sum(axis=-1, keepdims=True)

print(softmax([2.0, 1.0, 0.1]).round(3))
print(softmax([1000.0, 999.0, 998.1]).round(3))   # same differences -> same answer

# Works on a whole batch at once: one row per example
batch = np.array([[2.0, 1.0, 0.1],
                  [0.0, 0.0, 0.0]])
softmax(batch).round(3)
```

Thanks to `axis=-1` and `keepdims=True`, the same function handles a single vector or a batch of thousands of rows.

```python debug id=softmax-overflow title="Softmax returns nan"
def softmax(z):
    z = np.asarray(z, dtype=float)
    e = np.exp(z)
    return e / e.sum()

logits = np.array([800.0, 805.0, 790.0])   # large raw scores from a model
probs = softmax(logits)
print("probabilities:", probs)
print("sum:", probs.sum())
--- solution
def softmax(z):
    z = np.asarray(z, dtype=float)
    e = np.exp(z - z.max())
    return e / e.sum()

logits = np.array([800.0, 805.0, 790.0])
probs = softmax(logits)
print("probabilities:", probs)
print("sum:", probs.sum())
--- test
with np.errstate(all="ignore"):
    p = np.asarray(softmax(np.array([800.0, 805.0, 790.0])), dtype=float)
    small = np.asarray(softmax(np.array([1.0, 2.0, 3.0])), dtype=float)
assert not np.isnan(p).any(), f"softmax still produces nan for large inputs: {p}. np.exp(800) overflows to inf."
assert np.isclose(p.sum(), 1.0), f"The probabilities should sum to 1, but they sum to {p.sum()}."
ref = np.exp(np.array([-5.0, 0.0, -15.0])) / np.exp(np.array([-5.0, 0.0, -15.0])).sum()
assert np.allclose(p, ref, atol=1e-9), f"Expected about [0.0067, 0.9933, 0.0000003], got {p}."
assert np.allclose(small, np.exp([1.0, 2.0, 3.0]) / np.exp([1.0, 2.0, 3.0]).sum()), "Your fix changed the result for ordinary inputs. Softmax must still give the same probabilities."
--- hint
Run it: `np.exp(800)` is too big for a float64 and becomes `inf`. What can you subtract from every score without changing the softmax result?
--- hint
Subtract the largest score first: `np.exp(z - z.max())`. The biggest exponent becomes `e^0 = 1`, so nothing overflows.
```

## One-hot encoding

Machine-learning models usually need categories as **one-hot** vectors: class `2` out of 4 becomes `[0, 0, 1, 0]`. With broadcasting, you compare every label against every possible class at once.

```python run
labels = np.array([2, 0, 3, 1, 2])
n_classes = 4

# Compare a column of labels against a row of class ids -> (5, 4) boolean table
one_hot = (labels[:, None] == np.arange(n_classes)).astype(int)
print(one_hot)

# Equivalent trick: pick rows of the identity matrix
print(np.array_equal(one_hot, np.eye(n_classes, dtype=int)[labels]))
```

```python exercise id=one-hot-decode title="Encode and decode classes"
labels = np.array([1, 4, 0, 4, 2, 3])
n_classes = 5

# TODO 1: `encoded` = one-hot encoding of `labels` as an INTEGER array of shape (6, 5).
encoded = ...

# TODO 2: `decoded` = turn `encoded` back into the original labels (shape (6,)).
#         Each row has a single 1: find its position.
decoded = ...
--- solution
labels = np.array([1, 4, 0, 4, 2, 3])
n_classes = 5

encoded = (labels[:, None] == np.arange(n_classes)).astype(int)
decoded = encoded.argmax(axis=1)
--- test
assert encoded is not ..., "Replace the `...` after `encoded =` with your code."
assert decoded is not ..., "Replace the `...` after `decoded =` with your code."
encoded = np.asarray(encoded)
assert encoded.shape == (6, 5), f"`encoded` should have one row per label and one column per class (shape (6, 5)), but has {encoded.shape}."
assert encoded.dtype.kind in "iu", f"`encoded` should hold integers (0 and 1), but has dtype {encoded.dtype}. Try .astype(int)."
assert np.array_equal(encoded, np.eye(5, dtype=int)[[1, 4, 0, 4, 2, 3]]), "Each row of `encoded` should have a single 1, in the column given by its label."
decoded = np.asarray(decoded)
assert decoded.shape == (6,), f"`decoded` should have one label per row (shape (6,)), but has {decoded.shape}. Did you use axis=1?"
assert np.array_equal(decoded, labels), f"`decoded` should give back {labels.tolist()}, got {decoded.tolist()}."
--- hint
For encoding, compare `labels[:, None]` (a column) with `np.arange(n_classes)` (a row) and convert the boolean table to integers.
--- hint
To decode, find where the 1 is in each row: `encoded.argmax(axis=1)`.
```

## np.vectorize is not vectorization

NumPy ships a function called `np.vectorize` that wraps a scalar Python function so it accepts arrays. It's convenient, but the name is misleading: **it's still a Python loop under the hood**.

```python run
def clamp_score(s):
    return 0 if s < 0 else (100 if s > 100 else s)

scores = np.random.default_rng(1).normal(50, 40, 50_000)
clamp_v = np.vectorize(clamp_score)

t0 = time.perf_counter(); a = clamp_v(scores); t_vec = time.perf_counter() - t0
t0 = time.perf_counter(); b = np.clip(scores, 0, 100); t_clip = time.perf_counter() - t0

print(f"np.vectorize: {t_vec * 1000:7.1f} ms")
print(f"np.clip:      {t_clip * 1000:7.1f} ms")
print("same result?", np.allclose(a, b))
```

Use `np.vectorize` for convenience on small data, or to apply a genuinely complicated function you can't express with array operations. Don't expect it to be fast.

## When loops are fine

Vectorization isn't a religion. Keep the loop when:

- **Each step depends on the previous result** in a way no cumulative function covers, like a simulation where tomorrow's state is a nonlinear function of today's. Loop over *time*, but vectorize *within* each step.
- **The data is tiny.** A loop over 10 items costs microseconds; clarity wins.
- **The vectorized version needs a gigantic temporary array.** Broadcasting a `(100_000, 100_000)` distance matrix would need 80 GB. Process it in chunks inside a loop.

```python run
# A loop over TIME with vectorized work inside: 1,000 random walkers, 50 steps
rng = np.random.default_rng(0)
positions = np.zeros(1_000)
for step in range(50):                       # loop over time is fine...
    positions += rng.choice([-1, 1], size=1_000)   # ...each step updates all walkers at once
print("mean position:", positions.mean().round(2), "| spread:", positions.std().round(2))
```

> **In the wild:** this "loop over time, vectorize over the batch" pattern is exactly how neural networks are trained: a Python loop over training steps, with every step processing a whole batch of examples as arrays.

## Recap

- Vectorized code replaces per-element Python work with whole-array operations, often for a **10–100×+** speedup.
- Recipe: element arithmetic → array arithmetic; `if/else` → `np.where` / `np.select`; accumulators → reductions; running values → `cumsum` and friends; nested pair loops → broadcasting.
- Combine conditions with `&`, `|` and `~`, never `and`/`or`.
- The cumsum trick computes any moving window in constant time per window.
- Stable softmax subtracts the max first; one-hot is `labels[:, None] == np.arange(k)`.
- `np.vectorize` is a convenience loop, not a speedup. Loops over time or chunks are fine.

**Up next:** linear algebra. Dot products, the `@` operator and `einsum`, the language of machine learning.
