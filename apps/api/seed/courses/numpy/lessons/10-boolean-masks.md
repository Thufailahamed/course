"Which customers spent more than $100?" "How many sensor readings are out of range?" "Replace every negative value with zero." Questions like these are the bread and butter of data work, and in NumPy they all have the same answer: a **boolean mask**.

A mask is an array of `True`/`False` values, one per element, that marks the elements you care about. You can then use it to **filter**, **count**, **test**, or **overwrite**, all without writing a single loop. By the end of this lesson you'll do in one line what used to take five.

## Comparisons produce masks

Compare an array with a value and you don't get a single `True` or `False`. You get an **array** of them, one per element. Its dtype is `bool`.

```python run
import numpy as np

temps = np.array([22.5, 31.0, 28.4, 35.2, 19.8, 30.1, 33.7])
hot = temps > 30

print("temps:", temps)
print("hot:  ", hot)
print("dtype:", hot.dtype, " shape:", hot.shape)
```

Every comparison operator works this way: `>`, `>=`, `<`, `<=`, `==` and `!=`. You can compare against another array of the same shape too, element by element.

## Filtering with `a[mask]`

Put a mask inside the brackets and NumPy keeps only the elements where the mask is `True`:

```python run
temps = np.array([22.5, 31.0, 28.4, 35.2, 19.8, 30.1, 33.7])

print("hot days:     ", temps[temps > 30])
print("mild days:    ", temps[temps <= 30])
print("not exactly 30.1:", temps[temps != 30.1])
```

Read `temps[temps > 30]` as "temps, *where* temps is greater than 30". The result is a new 1-D array, a **copy** (remember the last lesson), containing just the matches, in their original order.

## Counting, fractions, `any` and `all`

Because `True` counts as `1` and `False` as `0`, summary statistics on a mask answer counting questions directly:

```python run
temps = np.array([22.5, 31.0, 28.4, 35.2, 19.8, 30.1, 33.7])
hot = temps > 30

print("how many hot days:", hot.sum())
print("fraction hot:     ", round(hot.mean(), 3))
print("any above 35?     ", (temps > 35).any())
print("all above 15?     ", (temps > 15).all())
```

| Question | Expression |
|---|---|
| How many match? | `mask.sum()` or `np.count_nonzero(mask)` |
| What fraction match? | `mask.mean()` |
| Does at least one match? | `mask.any()` |
| Do they all match? | `mask.all()` |

```python exercise id=heatwave-stats title="Heatwave report"
temps = np.array([24.1, 29.8, 31.2, 33.5, 30.0, 27.6, 34.9, 36.1, 28.3, 31.7])

# TODO (no loops):
hot_temps = ...      # the temperatures strictly above 30, as an array
n_hot = ...          # how many days were strictly above 30
frac_hot = ...       # the fraction of days strictly above 30 (between 0 and 1)
any_extreme = ...    # True if any day reached 36 or more
--- solution
temps = np.array([24.1, 29.8, 31.2, 33.5, 30.0, 27.6, 34.9, 36.1, 28.3, 31.7])

hot_temps = temps[temps > 30]
n_hot = (temps > 30).sum()
frac_hot = (temps > 30).mean()
any_extreme = (temps >= 36).any()
--- test
for n in ["hot_temps", "n_hot", "frac_hot", "any_extreme"]:
    assert globals()[n] is not ..., f"Replace the `...` after `{n} =` with your code."
assert isinstance(hot_temps, np.ndarray), "`hot_temps` should be an array, filtered from `temps` with a mask."
assert np.allclose(hot_temps, [31.2, 33.5, 34.9, 36.1, 31.7]), f"`hot_temps` should be the values strictly above 30, in order. Note that 30.0 itself is not above 30. Got {hot_temps}."
assert n_hot == 5, f"`n_hot` should count the hot days, but is {n_hot!r}. Did you sum the temperatures instead of the mask?"
assert np.isclose(frac_hot, 0.5), f"`frac_hot` should be a fraction between 0 and 1, but is {frac_hot!r}."
assert bool(any_extreme) is True, "`any_extreme` should be True: one day reached 36.1."
assert isinstance(any_extreme, (bool, np.bool_)), "`any_extreme` should be a single True/False value."
--- hint
Build the mask once: `temps > 30`. Then filter with it, sum it, and average it.
--- hint
`.any()` turns a whole mask into a single True/False: "is at least one element True?"
```

## Combining conditions: `&`, `|` and `~`

To combine masks, use the **element-wise** logical operators:

| Operator | Meaning |
|---|---|
| `a & b` | and: both true |
| `a \| b` | or: at least one true |
| `~a` | not: flip every value |

**Always wrap each comparison in parentheses.** In Python, `&` and `|` bind *more tightly* than `>` and `<`, so `x > 1 & x < 5` is parsed as `x > (1 & x) < 5`. That's not what you meant, and it usually crashes.

```python run
prices = np.array([4.99, 12.50, 18.00, 25.00, 9.75, 15.25])

mid_range = (prices >= 10) & (prices <= 20)
outside = ~mid_range
cheap_or_premium = (prices < 5) | (prices > 20)

print("10–20:            ", prices[mid_range])
print("outside 10–20:    ", prices[outside])
print("cheap or premium: ", prices[cheap_or_premium])
```

### Why not `and` and `or`?

Python's `and`/`or`/`not` need a single `True` or `False`. NumPy refuses to guess whether a whole array counts as true, so it raises this famous error:

```python run error
prices = np.array([4.99, 12.50, 18.00, 25.00])
mask = (prices > 10) and (prices < 20)
```

> **Pitfall:** "The truth value of an array with more than one element is ambiguous" almost always means you used `and`, `or`, `not` or an `if` on an array. Use `&`, `|`, `~`, or reduce the mask with `.any()` / `.all()` first.

```python predict id=predict-count title="Count the matches"
a = np.array([3, 8, 1, 9, 4, 7])
print(((a > 2) & (a < 8)).sum())
--- options
2
* 3
4
22
--- explain
`(a > 2)` is `[T, T, F, T, T, T]` and `(a < 8)` is `[T, F, T, F, T, T]`. Combining them with `&` leaves `[T, F, F, F, T, T]`, which marks `3`, `4` and `7`. Summing a mask counts the `True` values: **3**. (The sum of the matching *values* would be 14.)
```

```python exercise id=order-bands title="Segment the orders"
orders = np.array([12.0, 45.5, 89.9, 20.0, 150.0, 50.0, 7.25, 64.0, 33.3, 210.0])

# TODO: use masks combined with & | ~
medium = ...        # orders from 20 up to 50, INCLUDING both 20 and 50
not_medium = ...    # every order NOT in `medium`, original order
small_or_huge = ... # orders under 10 OR over 200
--- solution
orders = np.array([12.0, 45.5, 89.9, 20.0, 150.0, 50.0, 7.25, 64.0, 33.3, 210.0])

is_medium = (orders >= 20) & (orders <= 50)
medium = orders[is_medium]
not_medium = orders[~is_medium]
small_or_huge = orders[(orders < 10) | (orders > 200)]
--- test
for n in ["medium", "not_medium", "small_or_huge"]:
    assert globals()[n] is not ..., f"Replace the `...` after `{n} =` with your code."
    assert isinstance(globals()[n], np.ndarray), f"`{n}` should be an array of order values (filter `orders` with a mask)."
assert np.allclose(medium, [45.5, 20.0, 50.0, 33.3]), f"`medium` should include 20 and 50 themselves (use >= and <=). Got {medium}."
assert np.allclose(not_medium, [12.0, 89.9, 150.0, 7.25, 64.0, 210.0]), f"`not_medium` should be everything else, in the original order. Got {not_medium}."
assert np.allclose(small_or_huge, [7.25, 210.0]), f"`small_or_huge` should combine two conditions with `|`. Got {small_or_huge}."
assert len(medium) + len(not_medium) == len(orders), "`medium` and `not_medium` together should cover every order exactly once."
--- hint
Wrap each comparison in parentheses, then join them: `(orders >= 20) & (orders <= 50)`.
--- hint
Save that mask in a variable, then use `~mask` to flip it for `not_medium`.
```

## Assigning through a mask

Masks work on the left of `=` too, and this time you're writing **into the original array**. It's the cleanest way to fix bad values:

```python run
signal = np.array([0.4, -0.2, 1.3, 7.5, 0.9, -3.1, 1.1])

signal[signal < 0] = 0        # negative readings are sensor glitches
signal[signal > 2] = 2        # cap spikes at 2
print(signal)
```

You can also assign an array, as long as it has one value per `True`:

```python run
grades = np.array([55, 72, 48, 90, 61])
failing = grades < 60

grades[failing] = grades[failing] + 5    # a curve, for failing grades only
print(grades)
```

```python exercise id=clip-outliers title="Clean a sensor signal"
signal = np.array([12.0, -4.0, 55.0, 101.5, 87.0, -0.5, 230.0, 64.0])

# TODO: modify `signal` IN PLACE using mask assignment:
#   - negative values become 0
#   - values above 100 become 100
# Then set `n_fixed` to how many values you changed in total.
n_fixed = ...
--- solution
signal = np.array([12.0, -4.0, 55.0, 101.5, 87.0, -0.5, 230.0, 64.0])

low = signal < 0
high = signal > 100
n_fixed = low.sum() + high.sum()
signal[low] = 0
signal[high] = 100
--- test
assert n_fixed is not ..., "Replace the `...` after `n_fixed =` with your count."
assert np.allclose(signal, [12.0, 0.0, 55.0, 100.0, 87.0, 0.0, 100.0, 64.0]), f"`signal` should have negatives set to 0 and values above 100 set to 100. Got {signal}."
assert n_fixed == 4, f"`n_fixed` should be 4 (2 negatives + 2 above 100), but is {n_fixed!r}. Count before you overwrite, or the masks will change!"
--- hint
`signal[signal < 0] = 0` fixes the negatives in one line. Do the same for the high values.
--- hint
Count the matches **before** you overwrite them: after the fix, nothing is negative any more.
```

## Membership with `np.isin`

To ask "is each element one of these values?", use `np.isin(a, values)`. It's much cleaner than chaining `==` with `|`:

```python run
product_ids = np.array([101, 204, 305, 101, 412, 204, 999])
on_sale = [101, 412]

mask = np.isin(product_ids, on_sale)
print(mask)
print("sale items sold:", mask.sum())
print("everything else:", product_ids[~mask])
```

## Masks on 2-D arrays: selecting rows

On a 2-D array, `grid[grid > 5]` returns the matching values flattened to 1-D, because the matches don't form a rectangle. Far more common in practice is building a mask from **one column** and using it to select **whole rows**:

```python run
# Columns: age, income (k$), region code
people = np.array([[23, 41, 1],
                   [35, 78, 2],
                   [47, 95, 1],
                   [29, 52, 3],
                   [61, 60, 2]])

over_30 = people[:, 0] > 30           # one True/False per ROW
print("mask:", over_30)
print(people[over_30])                # whole rows where age > 30
print("matching values only:", people[people > 50])
```

This is exactly how a pandas filter like `df[df["age"] > 30]` works under the hood.

```python exercise id=filter-rows title="Find the target customers"
# Columns: customer_id, age, region, spend
customers = np.array([[1, 25, 2, 120],
                      [2, 41, 5, 340],
                      [3, 33, 1,  80],
                      [4, 52, 2, 510],
                      [5, 29, 5, 260],
                      [6, 38, 3, 150],
                      [7, 45, 2,  95]])

# TODO: select the full ROWS of customers who are aged 30 or older
# AND live in region 2 or 5. Then collect their ids.
targets = ...       # 2-D array of matching rows (all 4 columns)
target_ids = ...    # 1-D array of their customer_id values
--- solution
customers = np.array([[1, 25, 2, 120],
                      [2, 41, 5, 340],
                      [3, 33, 1,  80],
                      [4, 52, 2, 510],
                      [5, 29, 5, 260],
                      [6, 38, 3, 150],
                      [7, 45, 2,  95]])

mask = (customers[:, 1] >= 30) & np.isin(customers[:, 2], [2, 5])
targets = customers[mask]
target_ids = targets[:, 0]
--- test
assert targets is not ..., "Replace the `...` after `targets =` with a row selection."
assert target_ids is not ..., "Replace the `...` after `target_ids =` with your code."
assert isinstance(targets, np.ndarray) and targets.ndim == 2, f"`targets` should be 2-D: whole rows of `customers`. Got {getattr(targets, 'shape', type(targets).__name__)}. Build the mask from columns, then index rows."
assert targets.shape[1] == 4, f"`targets` should keep all 4 columns, but has shape {targets.shape}."
assert np.array_equal(np.asarray(target_ids), [2, 4, 7]), f"`target_ids` should be the ids of customers aged >= 30 in region 2 or 5. Got {np.asarray(target_ids)}."
assert np.array_equal(targets, customers[[1, 3, 6]]), "`targets` should contain the full rows for those customers."
--- hint
Age is column 1 and region is column 2. Slice a column with `customers[:, 1]` to get one value per row.
--- hint
Combine `(customers[:, 1] >= 30)` with `np.isin(customers[:, 2], [2, 5])` using `&`, then index rows with the result.
```

## Debug challenge: the precedence trap

```python debug id=precedence-trap title="Selecting the mid-priced items crashes"
prices = np.array([3.5, 12.0, 18.75, 22.0, 9.99, 15.5])

mid = prices[prices >= 10 & prices <= 20]
print("mid-priced:", mid)
--- solution
prices = np.array([3.5, 12.0, 18.75, 22.0, 9.99, 15.5])

mid = prices[(prices >= 10) & (prices <= 20)]
print("mid-priced:", mid)
--- test
assert np.allclose(mid, [12.0, 18.75, 15.5]), f"`mid` should be the prices from 10 to 20, got {mid}."
--- hint
Run it and read the error. Python evaluates `&` *before* the comparisons, so what is `10 & prices`?
--- hint
Wrap each comparison in its own parentheses so they're evaluated first.
```

## Debug challenge: counting the wrong thing

```python debug id=count-not-sum title="Pass rate over 100%?"
scores = np.array([78, 45, 92, 60, 38, 85, 71, 55])

n_passed = scores[scores >= 60].sum()
pass_rate = n_passed / len(scores)
print("passed:", n_passed)
print(f"pass rate: {pass_rate:.0%}")
--- solution
scores = np.array([78, 45, 92, 60, 38, 85, 71, 55])

n_passed = (scores >= 60).sum()
pass_rate = n_passed / len(scores)
print("passed:", n_passed)
print(f"pass rate: {pass_rate:.0%}")
--- test
assert n_passed == 5, f"`n_passed` should be the number of students who passed (5), but it is {n_passed}. Are you adding up scores?"
assert np.isclose(pass_rate, 0.625), f"`pass_rate` should be 5/8 = 0.625, got {pass_rate}."
--- hint
Run it: a pass rate of 4600% is a big clue. What exactly is being summed?
--- hint
`scores[mask].sum()` adds the matching *scores*. To count matches, sum the *mask* itself.
```

## Recap

- Comparisons on arrays return **boolean masks**, one `True`/`False` per element.
- `a[mask]` filters (and returns a copy). `a[mask] = value` writes into the original.
- `mask.sum()` counts, `mask.mean()` gives a fraction, `.any()` / `.all()` reduce to one answer.
- Combine with `&`, `|`, `~`, and **always parenthesize** each comparison. Never use `and`/`or` on arrays.
- `np.isin(a, values)` tests membership; a mask built from one column selects whole rows.

**Up next:** fancy indexing, selecting elements by *position* with arrays of indices, and `np.where` for "if this, then that" across an entire array.
