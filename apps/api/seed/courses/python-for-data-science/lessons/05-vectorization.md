# Vectorization in practice

The first time you see NumPy code, it can look like magic: no loop, one line, and suddenly every row is transformed. It isn't magic. It's **vectorization** — expressing an operation on whole arrays so the loop moves into compiled code.

This lesson is about the practical payoff: fewer places to make an off-by-one error, clearer intent, and code that scales from ten rows to ten million. You'll replace loop bodies with array expressions, use `np.where` for branching, and use `np.select` when there are more than two outcomes.

## The same calculation, two ways

```python run
import numpy as np

prices = np.array([19.99, 5.49, 102.00, 7.25])

taxed_loop = np.empty_like(prices)
for i, price in enumerate(prices):
    taxed_loop[i] = price * 1.2

taxed = prices * 1.2

print("same answer:", np.allclose(taxed_loop, taxed))
print(taxed.round(2))
```

The loop version has an index, a preallocated output, and a place to get the order wrong. The vectorized version says what it means: *multiply every price by 1.2*. On four values the speed difference is irrelevant; on a million rows it is not.

> **Under the hood:** Python loops execute one bytecode instruction at a time. A NumPy ufunc dispatches to a tight C loop over contiguous memory. The algorithm is the same; the interpreter overhead is gone.

## Functions that work element by element

NumPy's **universal functions** (ufuncs) apply to every element and return a new array. `np.clip` is especially useful for cleaning implausible values without writing a conditional.

```python run
ages = np.array([12, 17, 24, 68, 81])

print("clipped to 18–65:", np.clip(ages, 18, 65))
print("square roots:", np.sqrt(np.array([1.0, 4.0, 9.0, 16.0])))
print("safe log:", np.log1p(np.array([0.0, 1.0, 9.0])))
```

`np.log1p(x)` computes `log(1 + x)` more accurately than `np.log(1 + x)` for tiny `x`. The names are worth knowing: `np.exp`, `np.log`, `np.sqrt`, `np.abs`, `np.round`, `np.clip`.

## Branching without a loop: `np.where`

`np.where(condition, value_if_true, value_if_false)` works element by element. The condition is an array; both result branches can be arrays too.

```python run
spend = np.array([10.0, 250.0, 80.0, 400.0, 30.0])

segment = np.where(spend >= 200, "high", "standard")
print(segment)

# A numeric version: keep 90% for high spenders, 100% for everyone else.
paid = np.where(spend >= 200, spend * 0.9, spend)
print(paid)
```

The condition and both branches must be broadcast-compatible. Here a scalar and an array combine cleanly.

## More than two outcomes: `np.select`

Nested `np.where` calls get unreadable quickly. `np.select` takes a list of conditions and a list of choices, evaluated in order, with a `default` for everything else.

```python run
scores = np.array([45, 62, 78, 91, 88])

grade = np.select(
    [scores >= 90, scores >= 80, scores >= 70],
    ["A", "B", "C"],
    default="F",
)
print(grade)
```

Order matters: the first matching condition wins. A score of 91 matches both `>= 90` and `>= 80`, and correctly becomes an A.

## Missing values are not zero

```python run
values = np.array([12.0, np.nan, 8.0, np.nan, 3.25])

print("is missing:", np.isnan(values))
print("mean ignoring missing:", np.nanmean(values))
print("filled with 0:", np.nan_to_num(values, nan=0.0))
```

`np.nan` is a float meaning "not a number"; it is not equal to itself, so `values == np.nan` never works. Use `np.isnan` to detect it and the `nan`-aware aggregations (`np.nanmean`, `np.nansum`, `np.nanmax`) when a missing value should be skipped rather than treated as zero.

> **Pitfall:** `np.nan_to_num` turns missing values into a real number. That is the right choice only when zero is a defensible substitute. For an average order value, filling a missing order with 0 changes the answer; leaving it out may be correct.

## Your turn: tax by price band

Apply 25% tax to prices above 100 and 15% to everything else. Build `final_prices` with one vectorized expression. Do not use a Python loop.

```python exercise id=vectorized-tax title="Tax by price band"
import numpy as np

prices = np.array([45.0, 120.0, 80.0, 250.0])

# TODO: 25% tax above 100, 15% otherwise.
final_prices = ...
--- solution
import numpy as np

prices = np.array([45.0, 120.0, 80.0, 250.0])

final_prices = np.where(prices > 100, prices * 1.25, prices * 1.15)
--- test
assert final_prices is not ..., "Replace the `...` after `final_prices =`."
assert final_prices.shape == (4,), f"`final_prices` should have shape (4,), but has {final_prices.shape}."
expected = np.array([51.75, 150.0, 92.0, 312.5])
assert np.allclose(final_prices, expected), f"Expected {expected}, but got {final_prices}."
assert np.allclose(final_prices[prices > 100], prices[prices > 100] * 1.25), "Prices above 100 need 25% tax."
assert np.allclose(final_prices[prices <= 100], prices[prices <= 100] * 1.15), "Prices at or below 100 need 15% tax."
--- hint
`np.where(condition, a, b)` chooses element by element. Use `prices > 100` as the condition.
--- hint
The two branches are `prices * 1.25` and `prices * 1.15`.
```

## Your turn: clip implausible ages

A survey collected ages, but two entries are outside the adult range. Use `np.clip` to cap every value at 18 on the low end and 65 on the high end, without changing the valid ages.

```python exercise id=clip-ages title="Clip implausible ages"
import numpy as np

ages = np.array([12, 17, 24, 68, 81])

# TODO: clip to the range 18–65.
cleaned = ...
--- solution
import numpy as np

ages = np.array([12, 17, 24, 68, 81])

cleaned = np.clip(ages, 18, 65)
--- test
assert cleaned is not ..., "Replace the `...` after `cleaned =`."
assert cleaned.tolist() == [18, 18, 24, 65, 65], f"Expected [18, 18, 24, 65, 65], but got {cleaned.tolist()}."
assert ages.tolist() == [12, 17, 24, 68, 81], "Do not modify the original `ages` array."
--- hint
`np.clip(array, lower, upper)` returns a new array with every value bounded.
--- hint
The lower bound is 18 and the upper bound is 65. Assign `np.clip(ages, 18, 65)` to `cleaned`.
```

## Your turn: three customer tiers

Use `np.select` to label each spend value:
- `"high"` for 400 or more
- `"medium"` for 200 or more
- `"low"` for 100 or more
- `"basic"` otherwise

```python exercise id=segment-spend title="Label spend tiers"
import numpy as np

spend = np.array([80.0, 220.0, 500.0, 45.0, 150.0])

# TODO: build `tier` with np.select.
tier = ...
--- solution
import numpy as np

spend = np.array([80.0, 220.0, 500.0, 45.0, 150.0])

tier = np.select(
    [spend >= 400, spend >= 200, spend >= 100],
    ["high", "medium", "low"],
    default="basic",
)
--- test
assert tier is not ..., "Replace the `...` after `tier =`."
assert list(tier) == ["basic", "medium", "high", "basic", "low"], f"Got {list(tier)}. Check the thresholds and the order of the conditions."
assert len(tier) == len(spend), "The result should have one label per spend value."
--- hint
`np.select` takes a list of conditions, a list of matching choices, and a `default=`.
--- hint
Order the thresholds from highest to lowest: `spend >= 400`, then `>= 200`, then `>= 100`.
```

## The ambiguous array

This looks reasonable, but Python can't reduce an entire array to a single true/false value. Run it, read the error, then fix the mask. The goal is to select prices strictly between 20 and 100.

```python debug id=array-and-mask title="and does not mean element-wise"
import numpy as np

prices = np.array([12.0, 45.0, 80.0, 120.0])

mask = prices > 20 and prices < 100
selected = prices[mask]

print(selected)
--- solution
import numpy as np

prices = np.array([12.0, 45.0, 80.0, 120.0])

mask = (prices > 20) & (prices < 100)
selected = prices[mask]

print(selected)
--- test
assert mask.dtype == bool, f"`mask` should be a boolean array, but has dtype {mask.dtype}."
assert np.array_equal(mask, [False, True, True, False]), f"`mask` should be [False, True, True, False], but is {mask}."
assert np.array_equal(selected, [45.0, 80.0]), f"`selected` should be [45.0, 80.0], but is {selected}."
--- hint
Python's `and` wants one truth value. NumPy needs element-wise boolean operators: `&` for and, `|` for or, `~` for not.
--- hint
Parenthesise each comparison: `(prices > 20) & (prices < 100)`. Without parentheses, operator precedence bites.
```

## Predict the conditional

```python predict id=predict-np-where title="Choose element by element"
import numpy as np

print(np.where(np.array([1, 5, 3]) > 2, 10, 0))
--- options
[10 10 10]
* [ 0 10 10]
[ 0 10 0]
Error: the condition is ambiguous
--- explain
Compare each element: `1 > 2` is false, `5 > 2` is true, `3 > 2` is true. The result is `[0, 10, 10]`. `np.where` evaluates the condition element by element; it does not reduce the array.
```

## Recap

- Vectorization replaces a Python loop with a whole-array expression, making intent clearer and execution faster.
- Ufuncs (`np.clip`, `np.sqrt`, `np.log1p`) operate element by element.
- `np.where` handles two branches; `np.select` handles ordered, multi-way choices.
- Use `np.isnan` and `np.nanmean` for missing values; `== np.nan` never detects them.
- Use `&`, `|` and `~` with parentheses for array logic; `and`/`or` require one truth value.

**Up next:** you'll put the arrays into labelled tables and meet the object that will carry most of your analysis: the pandas DataFrame.
