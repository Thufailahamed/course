Once you know what each variable looks like, the next questions are about pairs: do units and revenue move together, does one city sell at higher prices, and are some values so extreme that they change every average? This lesson covers correlation as a summary of a relationship, the outliers that can make it lie, and the simple rules that flag suspicious values.

```python run
import numpy as np
import pandas as pd

rng = np.random.default_rng(7)
n = 200
ads = rng.uniform(0, 50, n)
sales = 40 + 2.5 * ads + rng.normal(0, 12, n)
frame = pd.DataFrame({"ads": ads, "sales": sales, "returns": rng.poisson(2, n)})
frame.corr().round(2)
```

## Correlation: how well a line describes a pair

The correlation coefficient runs from -1 to 1. Near 1 means the two variables rise together, near -1 means one falls as the other rises, and near 0 means no linear relationship. Here, advertising and sales are strongly related, while returns are unrelated to both.

```python run
print("ads vs sales:", round(frame["ads"].corr(frame["sales"]), 3))
print("ads vs returns:", round(frame["ads"].corr(frame["returns"]), 3))
```

> **Pitfall:** correlation measures a straight-line relationship only, and it is badly distorted by a single extreme point. Always look at a scatter plot before you trust a coefficient.

## A correlation an outlier made

```python run
x = np.arange(1, 11, dtype=float)
y = x * 0.5 + np.array([0.2, -0.3, 0.1, 0.0, -0.2, 0.3, -0.1, 0.2, 0.0, -0.2])
with_outlier = np.append(x, 40.0), np.append(y, 2.0)
print("without the outlier:", round(np.corrcoef(x, y)[0, 1], 3))
print("with one extreme point:", round(np.corrcoef(with_outlier[0], with_outlier[1])[0, 1], 3))
```

The first line is a clean, strong relationship. Adding one strange point at x = 40 changes the picture, even though the other ten points are unchanged. Outliers can create a relationship, hide one, or flip its sign.

## Flag outliers with the IQR rule

The **interquartile range** (IQR) is the distance between the first and third quartiles, the middle half of the data. A common rule marks any value more than 1.5 IQRs beyond the quartiles as a potential outlier.

```python run
q1, q3 = frame["sales"].quantile([0.25, 0.75])
iqr = q3 - q1
low, high = q1 - 1.5 * iqr, q3 + 1.5 * iqr
flags = (frame["sales"] < low) | (frame["sales"] > high)
print("bounds:", round(low, 1), "to", round(high, 1))
print("flagged:", int(flags.sum()), "of", len(frame))
```

A flag is a question, not a verdict. Before you remove a value, find out why it is extreme. A very large order from a wholesale customer is real and often the most important row in the data.

## Skewed data and the log scale

Money, counts and durations are often skewed, with a long tail. A logarithm pulls the tail in, so typical values and extreme values can both be seen.

```python run
orders = rng.lognormal(mean=3.0, sigma=0.8, size=500)
print("mean:", round(orders.mean(), 1), "| median:", round(np.median(orders), 1))
print("log-mean:", round(np.log(orders).mean(), 2), "| exp of log-mean:", round(np.exp(np.log(orders).mean()), 1))
```

When the mean sits well above the median, a few large values drive it. Report the median alongside the mean for skewed variables.

## Challenge: flag outliers

```python exercise id=iqr-outliers title="Flag outliers with the IQR rule"
import pandas as pd

# TODO: `iqr_outliers(values)` takes a pandas Series of numbers and returns a boolean Series of the same
# length that is True where a value is below Q1 − 1.5·IQR or above Q3 + 1.5·IQR, where IQR = Q3 − Q1.
def iqr_outliers(values):
    ...
--- solution
import pandas as pd

def iqr_outliers(values):
    q1 = values.quantile(0.25)
    q3 = values.quantile(0.75)
    iqr = q3 - q1
    return (values < q1 - 1.5 * iqr) | (values > q3 + 1.5 * iqr)
--- test
import pandas as pd
values = pd.Series([10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 60.0])
result = iqr_outliers(values)
assert result is not None, "Replace the `...` in `iqr_outliers` with code that returns the flags."
assert isinstance(result, pd.Series) and len(result) == len(values), "Return one flag per value, as a Series of the same length."
assert result.tolist() == [False, False, False, False, False, False, True], f"Only 60 should be flagged, but you returned {result.tolist()}."
assert not iqr_outliers(pd.Series([1.0, 2.0, 3.0])).any(), "Evenly spaced values have no outliers under this rule."
--- hint
Compute the quartiles with `values.quantile(0.25)` and `values.quantile(0.75)`, then the fences from the IQR. Compare each value with both fences.
--- hint
`return (values < q1 - 1.5 * iqr) | (values > q3 + 1.5 * iqr)`.
```

## Challenge: a correlation from scratch

```python exercise id=pearson title="Correlation from scratch"
import numpy as np

# TODO: `pearson(x, y)` returns the Pearson correlation coefficient of two equal-length arrays, using
# the formula: covariance divided by the product of the two standard deviations. Use the mean-centered values.
def pearson(x, y):
    ...
--- solution
import numpy as np

def pearson(x, y):
    x = np.asarray(x, dtype=float)
    y = np.asarray(y, dtype=float)
    xc = x - x.mean()
    yc = y - y.mean()
    return float((xc * yc).sum() / np.sqrt((xc ** 2).sum() * (yc ** 2).sum()))
--- test
import numpy as np
result = pearson([1.0, 2.0, 3.0], [2.0, 4.0, 6.0])
assert result is not None, "Replace the `...` in `pearson` with code that returns the coefficient."
assert np.isclose(result, 1.0), f"y is exactly 2x, so the correlation is 1, but you returned {result!r}."
assert np.isclose(pearson([1.0, 2.0, 3.0], [6.0, 4.0, 2.0]), -1.0), "A perfectly decreasing line has correlation -1."
assert np.isclose(pearson([1.0, 2.0, 3.0], [1.0, 3.0, 2.0]), 0.5), "Check the formula on this example: the answer is 0.5."
--- hint
Subtract each array's mean. The numerator is the sum of the products of the centered values, and the denominator is the square root of the product of the two sums of squares.
--- hint
`num = (xc * yc).sum()` and `den = np.sqrt((xc ** 2).sum() * (yc ** 2).sum())`, then return `num / den`.
```

## Debug the fence

This code is meant to flag the same outlier, but it misses it because one fence has the wrong sign.

```python debug id=fence-sign title="Flag values above the upper fence"
import pandas as pd

values = pd.Series([10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 60.0])
q1, q3 = values.quantile(0.25), values.quantile(0.75)
iqr = q3 - q1
upper = q3 - 1.5 * iqr           # bug: the upper fence must be above Q3
flags = values > upper
print(flags.tolist())
--- solution
import pandas as pd

values = pd.Series([10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 60.0])
q1, q3 = values.quantile(0.25), values.quantile(0.75)
iqr = q3 - q1
upper = q3 + 1.5 * iqr
flags = values > upper
print(flags.tolist())
--- test
assert upper > q3, f"The upper fence should sit above the third quartile ({q3}), but it is {upper}."
assert flags.tolist() == [False, False, False, False, False, False, True], f"Only 60 should be flagged, but the flags are {flags.tolist()}."
--- hint
The upper fence is Q3 plus 1.5 times the IQR, so it is larger than Q3, not smaller.
--- hint
Change the minus sign to a plus sign.
```

## Predict the correlation

```python predict id=predict-corr title="What is the correlation of a variable with itself?"
import pandas as pd
s = pd.Series([3.0, 1.0, 4.0, 1.0, 5.0])
print(round(s.corr(s), 1))
--- options
* 1.0
0.0
-1.0
0.5
--- explain
A variable is perfectly correlated with itself, so the coefficient is exactly 1. This is a useful sanity check when you build a correlation table.
```

## Recap

- Correlation summarizes a straight-line relationship and is distorted by outliers. Plot the pair before trusting the number.
- The IQR rule flags values beyond 1.5 IQRs from the quartiles. A flag is a question to investigate, not a reason to delete.
- For skewed data, report the median alongside the mean, and consider a log scale.
- Never remove an extreme value without understanding it first.

**Up next:** a complete capstone analysis of a sales dataset, using every step in this course.
