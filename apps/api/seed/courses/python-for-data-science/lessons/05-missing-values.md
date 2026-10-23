Real data has gaps. A sensor drops a reading, a survey question is skipped, a sale is recorded without a price. In Python, a missing number is usually `NaN`, short for "not a number". `NaN` behaves in ways that surprise people, and most wrong averages in analysis come from forgetting that. This lesson shows what `NaN` does and how to handle it deliberately.

## NaN spreads through arithmetic

Any arithmetic that touches `NaN` gives `NaN`. A single gap poisons a sum. And `NaN` is never equal to anything, not even itself.

```python run
import numpy as np

readings = np.array([21.5, np.nan, 23.0, 22.5])
print("sum:", readings.sum())
print("nan == nan:", np.nan == np.nan)
print("which are missing:", np.isnan(readings))
```

Test for missing values with `np.isnan` (or `isna` in pandas), never with `==`.

## Ignore gaps on purpose

The NumPy functions with a `nan` prefix skip missing values. Use them when a gap should be ignored, and be clear in your report that you did so.

```python run
print("plain mean:", readings.mean())
print("mean ignoring gaps:", np.nanmean(readings))
print("count of real values:", np.count_nonzero(~np.isnan(readings)))
```

The plain mean is `NaN`, which tells you there is a gap. The `nanmean` answer is only an honest summary if three of four readings are a fair sample. Always report how many values went into the answer.

## Why the count matters

```python run
sparse = np.array([np.nan, np.nan, 40.0])
print("nanmean of sparse data:", np.nanmean(sparse))
print("values used:", np.count_nonzero(~np.isnan(sparse)), "of", sparse.size)
```

One real value out of three gives a number that looks precise, but it rests on very little evidence. A good analysis states the sample size next to every average.

## Replace gaps with a rule

Sometimes you need a complete array. You can fill gaps with a value that has a justification, such as the median of the observed readings, and say so.

```python run
filled = np.where(np.isnan(readings), np.nanmedian(readings), readings)
print("filled:", filled)
```

> **Pitfall:** filling gaps with zero is almost always wrong. Zero is a real value, and it pulls averages down. Fill with the median, the mean, or the previous value, and record which one you used.

## Challenge: a mean that admits its gaps

```python exercise id=safe-mean title="Mean of the observed values"
import numpy as np

# TODO: `safe_mean(values)` returns the mean of the values that are not NaN. If every value is NaN,
# or the array is empty, return NaN instead of raising an error or warning.
def safe_mean(values):
    ...
--- solution
import numpy as np

def safe_mean(values):
    values = np.asarray(values, dtype=float)
    observed = values[~np.isnan(values)]
    if observed.size == 0:
        return np.nan
    return observed.mean()
--- test
import numpy as np
result = safe_mean([2.0, np.nan, 4.0])
assert result is not None, "Replace the `...` in `safe_mean` with code that returns the mean."
assert np.isclose(result, 3.0), f"The observed values are 2 and 4, whose mean is 3, but you returned {result!r}."
assert np.isnan(safe_mean([np.nan, np.nan])), "If every value is missing, the answer should be NaN."
assert np.isnan(safe_mean([])), "An empty input has no mean, so the answer should be NaN."
assert np.isclose(safe_mean([7.0]), 7.0), "A single observed value is its own mean."
--- hint
Keep only the values where `np.isnan(values)` is False, then average those.
--- hint
`observed = values[~np.isnan(values)]`, and return `np.nan` when `observed` is empty.
```

## Challenge: fill gaps with the median

```python exercise id=fill-median title="Fill gaps with the median of the observed values"
import numpy as np

# TODO: `fill_with_median(values)` returns a new array in which each NaN is replaced by the median of the
# observed (non-NaN) values. If every value is NaN, return a copy of the input unchanged.
def fill_with_median(values):
    ...
--- solution
import numpy as np

def fill_with_median(values):
    values = np.asarray(values, dtype=float)
    if np.all(np.isnan(values)):
        return values.copy()
    return np.where(np.isnan(values), np.nanmedian(values), values)
--- test
import numpy as np
result = fill_with_median([1.0, np.nan, 3.0, 10.0])
assert result is not None, "Replace the `...` in `fill_with_median` with code that returns the filled array."
assert np.allclose(result, [1.0, 3.0, 3.0, 10.0]), f"The observed values are 1, 3 and 10 with median 3, so the gap should become 3. You returned {result}."
assert np.isnan(fill_with_median([np.nan, np.nan])).all(), "If nothing is observed there is no median, so the values stay missing."
assert np.allclose(fill_with_median([2.0, 4.0]), [2.0, 4.0]), "An array without gaps should come back unchanged."
--- hint
`np.nanmedian` gives the median of the observed values. Use `np.where(np.isnan(values), median, values)` to choose between them.
--- hint
Handle the all-missing case first, because the median of nothing is not a number you can use.
```

## Debug the comparison

This code is supposed to count missing readings, but it always reports zero.

```python debug id=nan-compare title="Find missing values correctly"
import numpy as np

readings = np.array([21.5, np.nan, 23.0, np.nan])
missing = np.count_nonzero(readings == np.nan)     # bug: NaN is never equal to anything
print("missing:", missing)
--- solution
import numpy as np

readings = np.array([21.5, np.nan, 23.0, np.nan])
missing = np.count_nonzero(np.isnan(readings))
print("missing:", missing)
--- test
assert missing == 2, f"There are two missing readings, but the code reports {missing}. Test for missing values with np.isnan."
--- hint
`x == np.nan` is always False, so nothing matches. NumPy has a function built for this test.
--- hint
Use `np.isnan(readings)` instead of `readings == np.nan`.
```

## Predict the average

```python predict id=predict-nanmean title="What does nanmean return?"
import numpy as np
print(np.nanmean(np.array([1.0, np.nan, 3.0, np.nan])))
--- options
* 2.0
1.0
nan
4.0
--- explain
`nanmean` ignores the two missing values and averages the observed 1 and 3, which gives 2.0. The plain `mean` would have returned nan.
```

## Recap

- `NaN` poisons arithmetic and is never equal to anything. Test for it with `np.isnan`.
- Use the `nan` functions such as `nanmean` when a gap should be ignored, and report how many values were used.
- Filling gaps is a decision. Use a justified value, never zero by default.
- Missing values are information too: a pattern of gaps can reveal a problem in the data collection.

**Up next:** pandas. A DataFrame puts named columns, mixed types and missing values into one table, and this is where most of your analysis will happen.
