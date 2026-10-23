In practice, the features you give a model usually matter more than the algorithm you choose. A linear model cannot see that the relationship between income and loan risk is curved, but a log-transformed income can make it straight. A decision tree cannot use the text "Lyon" directly, but a column of 0s and 1s can. Feature engineering is the craft of turning raw data into inputs a model can use well.

This lesson covers the four moves that handle most real tables: scaling numbers, encoding categories, filling gaps, and reshaping skewed values. Each one has a rule about what data it may learn from, and that rule is the subject of the next lesson.

## Scale numbers to a common footing

Standardization subtracts the mean and divides by the standard deviation, so each feature has mean 0 and standard deviation 1. It matters for any method that compares distances or uses gradients: nearest neighbours, logistic regression, neural networks.

```python run
import numpy as np

rng = np.random.default_rng(0)
income = rng.normal(40000, 8000, 6)        # euros
age = rng.normal(40, 10, 6)                # years
X = np.column_stack([income, age])

mean, std = X.mean(axis=0), X.std(axis=0)
Z = (X - mean) / std
print("means after scaling:", Z.mean(axis=0).round(6))
print("standard deviations after scaling:", Z.std(axis=0).round(6))
```

## Encode categories as columns

A category such as "city" has no order, so the number 2 for Paris is not "twice" the number 1 for Lyon. **One-hot encoding** gives each category its own 0/1 column instead.

```python run
cities = np.array(["Lyon", "Paris", "Lyon", "Nice"])
levels = ["Lyon", "Paris", "Nice"]
one_hot = np.array([[c == level for level in levels] for c in cities], dtype=float)
print(one_hot)
```

Each row has exactly one 1, in the column of its city. Keep the category order fixed, so the same city always lands in the same column, including in new data.

## Fill the gaps deliberately

```python run
income_gaps = np.array([42000.0, np.nan, 38000.0, np.nan, 51000.0])
median = np.nanmedian(income_gaps)
filled = np.where(np.isnan(income_gaps), median, income_gaps)
print("median used:", median)
print("filled:", filled)
```

A **missing indicator** can carry information of its own. If people with missing income default more often, add a 0/1 column saying the value was missing, so the model can learn from the gap itself.

## Transform skewed values

Incomes, prices and counts often have a long right tail. A logarithm pulls the tail in, which helps linear models and stabilizes distances.

```python run
prices = np.array([12.0, 15.0, 18.0, 25.0, 40.0, 900.0])
print("raw spread (std):", round(prices.std(), 1))
print("log spread (std):", round(np.log(prices).std(), 3))
```

> **Pitfall:** `log(0)` is minus infinity, so use `log1p(x)`, which computes $\log(1 + x)$, when values can be zero.

> **In the wild:** scikit-learn's `StandardScaler`, `OneHotEncoder` and `SimpleImputer` implement these steps, and `ColumnTransformer` applies a different one to each column.

```python
# Static: run this on your own machine with scikit-learn installed
from sklearn.preprocessing import StandardScaler, OneHotEncoder

scaled = StandardScaler().fit_transform(X)
encoded = OneHotEncoder().fit_transform(cities.reshape(-1, 1)).toarray()
print(scaled.shape, encoded.shape)
```

## Challenge: standardize with given statistics

```python exercise id=standardize title="Standardize with given statistics"
import numpy as np

# TODO: `standardize(X, mean, std)` returns (X − mean) / std, applied to each column of the 2-D array X.
def standardize(X, mean, std):
    ...
--- solution
import numpy as np

def standardize(X, mean, std):
    return (np.asarray(X, dtype=float) - np.asarray(mean, dtype=float)) / np.asarray(std, dtype=float)
--- test
import numpy as np
X_t = np.array([[1.0, 10.0], [3.0, 30.0]])
result = standardize(X_t, [2.0, 20.0], [1.0, 10.0])
assert result is not None, "Replace the `...` in `standardize` with code that returns the scaled array."
assert np.allclose(result, [[-1.0, -1.0], [1.0, 1.0]]), f"Each column is shifted by its mean and divided by its std, giving [[-1, -1], [1, 1]], but you returned {result}."
assert np.allclose(standardize(np.array([[5.0]]), [5.0], [2.0]), [[0.0]]), "A value equal to the mean becomes 0."
--- hint
Broadcasting handles the columns: `(X - mean) / std` works when `mean` and `std` have one entry per column.
--- hint
`return (np.asarray(X, dtype=float) - mean) / std`.
```

## Challenge: one-hot encode

```python exercise id=one-hot-encode title="One-hot encode a category column"
import numpy as np

# TODO: `one_hot_encode(values, levels)` returns a 2-D array with one row per value and one column per level,
# in the order given by `levels`. Each row has a 1 in the column of its value and 0 elsewhere.
def one_hot_encode(values, levels):
    ...
--- solution
import numpy as np

def one_hot_encode(values, levels):
    index = {level: j for j, level in enumerate(levels)}
    out = np.zeros((len(values), len(levels)))
    for i, v in enumerate(values):
        out[i, index[v]] = 1.0
    return out
--- test
import numpy as np
result = one_hot_encode(["b", "a", "b"], ["a", "b", "c"])
assert result is not None, "Replace the `...` in `one_hot_encode` with code that returns the matrix."
assert result.shape == (3, 3), f"Three values and three levels should give shape (3, 3), but you returned {result.shape}."
assert np.array_equal(result, [[0, 1, 0], [1, 0, 0], [0, 1, 0]]), f"Each row should have a 1 in its level's column. You returned {result.tolist()}."
assert result.sum(axis=1).tolist() == [1.0, 1.0, 1.0], "Each row must have exactly one 1."
--- hint
Map each level to its column number with a dictionary, then set the matching entry in each row to 1.
--- hint
`index = {level: j for j, level in enumerate(levels)}`, then `out[i, index[v]] = 1.0` in a loop.
```

## Debug the imputation

This gap filler is meant to replace missing incomes with the median, but it fills them with zero, which drags every average down.

```python debug id=impute-zero title="Fill with the median, not zero"
import numpy as np

income = np.array([40000.0, np.nan, 50000.0, 60000.0])
filled = np.where(np.isnan(income), 0.0, income)       # bug: zero is not a plausible income
print("filled:", filled)
--- solution
import numpy as np

income = np.array([40000.0, np.nan, 50000.0, 60000.0])
filled = np.where(np.isnan(income), np.nanmedian(income), income)
print("filled:", filled)
--- test
assert np.isclose(filled[1], 50000.0), f"The gap should be filled with the median of the observed incomes, 50000, but it became {filled[1]}. Zero is not a plausible income."
--- hint
Which summary of the observed incomes describes a typical value without being pulled by extremes?
--- hint
Use `np.nanmedian(income)` as the fill value.
```

## Predict the encoded shape

```python predict id=predict-onehot title="What shape is the encoded matrix?"
import numpy as np
cities = np.array(["Lyon", "Paris", "Lyon", "Nice", "Brest"])
levels = ["Lyon", "Paris", "Nice"]
encoded = np.array([[c == level for level in levels] for c in cities], dtype=float)
print(encoded.shape)
--- options
* (5, 3)
(3, 5)
(5, 1)
(5, 5)
--- explain
There is one row per city value, five in all, and one column per level, three in all. Brest is not a listed level, so its row is all zeros, which is the usual way unseen categories are handled.
```

## Recap

- Standardize numeric features so distances and gradients behave. Use statistics from training data only.
- One-hot encode categories with a fixed order, so the same level always lands in the same column.
- Fill gaps with a justified value such as the median, and consider a missing indicator.
- Log-transform skewed values, and use `log1p` when zeros are possible.

**Up next:** data leakage, the mistake that can make a model look perfect.
