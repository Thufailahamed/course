pandas stores each column as a NumPy array, so the same ideas work in both. An array lets you write "multiply every price by the tax rate" in one expression, and it runs the loop for you in fast compiled code. Once you think in whole columns, a great deal of analysis becomes a short line of code.

## Vectorized arithmetic

```python run
import numpy as np

units = np.array([3, 7, 2, 5])
price = np.array([9.5, 8.0, 9.5, 12.0])

revenue = units * price              # one multiplication per row, no loop
print("revenue:", revenue)
print("total:", revenue.sum())
```

Both arrays have four elements, and the multiplication pairs them up position by position. That is the vectorized way of thinking: describe the calculation for the whole column.

## Boolean masks: select by condition

Comparing an array with a value gives a **boolean mask**, an array of `True` and `False`. Using the mask to index the array keeps only the `True` positions.

```python run
mask = revenue > 30
print("mask:", mask)
print("rows with revenue above 30:", revenue[mask])
print("how many:", mask.sum())
```

`True` counts as 1, so `mask.sum()` counts the matches. This is how analysts answer "how many orders were large?" without writing a loop.

## Combining conditions: `&` and `|`

To combine two masks, use `&` for "and" and `|` for "or". Each condition needs its own parentheses, because `&` binds tighter than comparisons.

```python run
units_ok = units >= 3
price_ok = price < 10
both = (units_ok) & (price_ok)
print("both conditions:", both)
print("either condition:", (units_ok) | (price_ok))
```

> **Pitfall:** `and` and `or` do not work on arrays. They raise an error for arrays with more than one element, which is a good thing, because it stops a silent mistake.

## `np.where`: choose a value per row

`np.where(condition, if_true, if_false)` builds a new array, taking a value from one of two options for each position.

```python run
discount = np.where(price > 9, 0.10, 0.0)
final_price = price * (1 - discount)
print("discount per row:", discount)
print("final prices:", np.round(final_price, 2))
```

## Aggregations and axes

Functions such as `sum`, `mean` and `max` reduce an array. On a two-dimensional table, the `axis` argument chooses the direction: `axis=0` works down the rows (one answer per column), and `axis=1` works across each row.

```python run
table = np.array([
    [3, 9.5],
    [7, 8.0],
    [2, 9.5],
])
print("per column totals:", table.sum(axis=0))
print("per row totals:", table.sum(axis=1))
```

## Challenge: a tiered discount

```python exercise id=tiered-discount title="Apply a discount above a threshold"
import numpy as np

# TODO: `apply_discount(prices, threshold, rate)` returns a new array in which every price strictly above
# `threshold` is reduced by `rate` (for example 0.1 for ten percent). Other prices stay the same.
def apply_discount(prices, threshold, rate):
    ...
--- solution
import numpy as np

def apply_discount(prices, threshold, rate):
    prices = np.asarray(prices, dtype=float)
    return np.where(prices > threshold, prices * (1 - rate), prices)
--- test
import numpy as np
result = apply_discount(np.array([5.0, 10.0, 20.0]), 9.0, 0.5)
assert result is not None, "Replace the `...` in `apply_discount` with code that returns the new prices."
assert np.allclose(result, [5.0, 5.0, 10.0]), f"Only prices above 9 should drop by half: expected [5, 5, 10], but you returned {result}."
assert np.allclose(apply_discount([9.0], 9.0, 0.5), [9.0]), "A price equal to the threshold is not above it, so it stays the same."
assert np.allclose(apply_discount([100.0, 1.0], 50.0, 0.1), [90.0, 1.0]), "The function should work for any threshold and rate."
--- hint
Build a mask with `prices > threshold`, then use `np.where` to choose between the discounted price and the original.
--- hint
`return np.where(prices > threshold, prices * (1 - rate), prices)`.
```

## Challenge: the share above a threshold

```python exercise id=share-above title="Share of values above a threshold"
import numpy as np

# TODO: `share_above(values, threshold)` returns the fraction of values that are strictly greater than
# `threshold`, as a float between 0 and 1. Use a boolean mask.
def share_above(values, threshold):
    ...
--- solution
import numpy as np

def share_above(values, threshold):
    values = np.asarray(values, dtype=float)
    return float((values > threshold).mean())
--- test
import numpy as np
result = share_above(np.array([1.0, 5.0, 7.0, 9.0]), 4.0)
assert result is not None, "Replace the `...` in `share_above` with code that returns the fraction."
assert np.isclose(result, 0.75), f"Three of four values are above 4, so the share is 0.75, but you returned {result!r}."
assert np.isclose(share_above([3.0, 3.0], 3.0), 0.0), "Values equal to the threshold are not strictly above it."
assert np.isclose(share_above([10.0], 1.0), 1.0), "A single value above the threshold gives a share of 1."
--- hint
`values > threshold` is a boolean mask. Its mean is the fraction of True values.
--- hint
`return float((values > threshold).mean())`.
```

## Debug the mask operator

This code is meant to keep rows that are both large and cheap, but it raises an error.

```python debug id=mask-operator title="Combine masks correctly"
import numpy as np

units = np.array([3, 7, 2, 5])
price = np.array([9.5, 8.0, 9.5, 12.0])
both = (units >= 3) and (price < 10)     # bug: `and` cannot combine arrays
print(units[both])
--- solution
import numpy as np

units = np.array([3, 7, 2, 5])
price = np.array([9.5, 8.0, 9.5, 12.0])
both = (units >= 3) & (price < 10)
print(units[both])
--- test
assert list(both) == [True, True, False, False], f"The mask should be [True, True, False, False], but it is {both}. Combine array conditions with `&`."
--- hint
Python's `and` works on single values. For element-by-element logic on arrays, use `&`.
--- hint
Replace `and` with `&`, and keep the parentheses around each comparison.
```

## Predict the output

```python predict id=predict-mask title="How many values pass?"
import numpy as np
a = np.array([1, 4, 6, 8])
print((a > 3).sum())
--- options
* 3
2
4
1
--- explain
Only 1 fails the test `a > 3`. The other three values, 4, 6 and 8, are greater than 3, so the sum of the mask is 3.
```

## Recap

- Arithmetic on arrays applies to every position at once.
- A boolean mask selects rows, and `mask.sum()` counts them.
- Combine masks with `&` and `|`, and wrap each condition in parentheses.
- `np.where` chooses one of two values per position, and `axis` picks the direction of an aggregation.

**Up next:** missing values. Real data always has gaps, and how you treat them changes every answer.
