Linear regression is the first model worth learning, because it is simple enough to understand completely and it appears inside many larger methods. It predicts the target as a weighted sum of the features plus an intercept. Training means choosing the weights that make the squared errors as small as possible, and for linear regression that choice has an exact solution.

## The model

For one flat with features $x_1, \dots, x_d$, the prediction is

$$
\hat y = w_0 + w_1 x_1 + \dots + w_d x_d
$$

The intercept $w_0$ is the price of an imaginary flat with all features zero. It is learned like the other weights, and the usual trick is to add a column of ones to the features so that the intercept becomes just another weight.

```python run
import numpy as np

def add_intercept_column(X):
    return np.column_stack([np.ones(len(X)), X])

X_demo = np.array([[50.0, 2.0], [80.0, 5.0]])
print(add_intercept_column(X_demo))
```

## Fit by least squares

The best weights minimize the sum of squared errors. NumPy's `lstsq` solves that problem directly, with no iteration needed.

```python run
rng = np.random.default_rng(42)
n = 200
size = rng.uniform(35, 140, n)
floor = rng.integers(0, 12, n).astype(float)
age = rng.uniform(0, 60, n)
price = 2.8 * size + 3.0 * floor - 0.9 * age + 40 + rng.normal(0, 15, n)
X = np.column_stack([size, floor, age])

A = add_intercept_column(X)
weights, *_ = np.linalg.lstsq(A, price, rcond=None)
print("intercept:", round(weights[0], 2))
print("size, floor, age:", weights[1:].round(2))
print("true values were 40, 2.8, 3.0 and -0.9")
```

The recovered weights are close to the values used to generate the prices. With noise in the data, you should not expect exact recovery, only a close estimate.

## Measure the fit

$R^2$ measures the share of the target's variation the model explains. A value of 1 is a perfect fit, and 0 means the model does no better than predicting the mean.

```python run
predicted = A @ weights
ss_res = np.sum((price - predicted) ** 2)
ss_tot = np.sum((price - price.mean()) ** 2)
print("R²:", round(1 - ss_res / ss_tot, 3))
print("mean absolute error:", round(np.mean(np.abs(price - predicted)), 2))
```

Compare this with the baseline from the last lesson. The model should be far better than guessing the average price.

## Look at the residuals

A residual is the gap between a prediction and the truth. If the model is right, residuals show no pattern when you plot them against the predictions.

```python run
import matplotlib.pyplot as plt

fig, ax = plt.subplots(figsize=(5, 3.5))
ax.scatter(predicted, price - predicted, alpha=0.6)
ax.axhline(0, color="black", linewidth=1)
ax.set_xlabel("predicted price (thousand €)")
ax.set_ylabel("residual (thousand €)")
ax.set_title("Residuals should scatter randomly around zero")
ax.grid(alpha=0.3)
plt.show()
```

A curve or a funnel in this plot means the model is missing structure, such as a non-linear effect or errors that grow with the price.

> **In the wild:** scikit-learn does the same job with `LinearRegression().fit(X, y)`. Its `coef_` and `intercept_` are these weights, and its `score` method returns $R^2$.

```python
# Static: run this on your own machine with scikit-learn installed
from sklearn.linear_model import LinearRegression

model = LinearRegression().fit(X, price)
print(model.intercept_, model.coef_)
print(model.score(X, price))
```

## Challenge: add the intercept column

```python exercise id=add-intercept title="Add a column of ones"
import numpy as np

# TODO: `with_intercept(X)` takes a 2-D array of features and returns a new array with a column of ones
# added as the first column. The original array must not change.
def with_intercept(X):
    ...
--- solution
import numpy as np

def with_intercept(X):
    X = np.asarray(X, dtype=float)
    return np.column_stack([np.ones(len(X)), X])
--- test
import numpy as np
X_t = np.array([[2.0, 3.0], [4.0, 5.0]])
result = with_intercept(X_t)
assert result is not None, "Replace the `...` in `with_intercept` with code that returns the augmented array."
assert result.shape == (2, 3), f"Two rows with two features should give shape (2, 3), but you returned {result.shape}."
assert np.allclose(result[:, 0], 1.0), "The first column should be all ones."
assert np.allclose(result[:, 1:], X_t), "The original features should follow in the remaining columns."
assert np.allclose(X_t, [[2.0, 3.0], [4.0, 5.0]]), "The input array must not be changed."
--- hint
`np.column_stack` joins arrays column by column. A column of ones has the same length as the rows, and `np.ones(len(X))` makes one.
--- hint
`return np.column_stack([np.ones(len(X)), X])`.
```

## Challenge: fit the weights

```python exercise id=fit-linear title="Fit linear regression by least squares"
import numpy as np

# TODO: `fit_linear(X, y)` returns the weight vector w that minimizes the sum of squared errors of
# X_with_intercept @ w against y. The first weight is the intercept. Use np.linalg.lstsq.
def fit_linear(X, y):
    ...
--- solution
import numpy as np

def fit_linear(X, y):
    A = np.column_stack([np.ones(len(X)), np.asarray(X, dtype=float)])
    w, *_ = np.linalg.lstsq(A, np.asarray(y, dtype=float), rcond=None)
    return w
--- test
import numpy as np
X_t = np.array([[1.0], [2.0], [3.0], [4.0]])
y_t = 2.0 + 3.0 * X_t[:, 0]
w = fit_linear(X_t, y_t)
assert w is not None, "Replace the `...` in `fit_linear` with code that returns the weights."
assert w.shape == (2,), f"There is one feature plus an intercept, so there should be 2 weights, but you returned shape {w.shape}."
assert np.allclose(w, [2.0, 3.0]), f"The data follow y = 2 + 3x exactly, so the weights should be [2, 3], but you returned {w}."
rng_t = np.random.default_rng(1)
X2 = rng_t.normal(size=(50, 2))
y2 = -1.0 + 0.5 * X2[:, 0] + 4.0 * X2[:, 1]
assert np.allclose(fit_linear(X2, y2), [-1.0, 0.5, 4.0]), "Noise-free data from two features should be recovered exactly."
--- hint
Build the augmented matrix with the intercept column, then call `np.linalg.lstsq(A, y, rcond=None)`. Its first return value is the weight vector.
--- hint
`A = np.column_stack([np.ones(len(X)), X])`, then `w, *_ = np.linalg.lstsq(A, y, rcond=None)` and return `w`.
```

## Challenge: R squared

```python exercise id=r-squared title="R squared"
import numpy as np

# TODO: `r_squared(y, y_hat)` returns 1 − (sum of squared residuals) / (sum of squared deviations of y from its mean).
def r_squared(y, y_hat):
    ...
--- solution
import numpy as np

def r_squared(y, y_hat):
    y = np.asarray(y, dtype=float)
    y_hat = np.asarray(y_hat, dtype=float)
    return float(1 - np.sum((y - y_hat) ** 2) / np.sum((y - y.mean()) ** 2))
--- test
import numpy as np
assert np.isclose(r_squared([1.0, 2.0, 3.0], [1.0, 2.0, 3.0]), 1.0), "Perfect predictions give R² of 1."
assert np.isclose(r_squared([1.0, 2.0, 3.0], [2.0, 2.0, 2.0]), 0.0), "Always predicting the mean gives R² of 0."
result = r_squared([1.0, 2.0, 4.0], [1.0, 2.0, 3.0])
assert result is not None, "Replace the `...` in `r_squared` with code that returns the value."
assert np.isclose(result, 11 / 14), f"The residual sum of squares is 1 and the total sum of squares is 14/3, so R² is 1 − 3/14 = 11/14 ≈ 0.786. You returned {result!r}."
--- hint
Compute the two sums of squares separately: one for the residuals, `y - y_hat`, and one for the deviations from the mean of `y`.
--- hint
`1 - np.sum((y - y_hat) ** 2) / np.sum((y - y.mean()) ** 2)`.
```

## Debug the missing intercept

This model is meant to learn an intercept, but it forces the line through the origin, so every prediction is too low.

```python debug id=no-intercept title="Include the intercept"
import numpy as np

X = np.array([[1.0], [2.0], [3.0], [4.0]])
y = np.array([5.0, 7.0, 9.0, 11.0])          # y = 3 + 2x
w, *_ = np.linalg.lstsq(X, y, rcond=None)     # bug: no column of ones, so there is no intercept
print("weights:", w)
--- solution
import numpy as np

X = np.array([[1.0], [2.0], [3.0], [4.0]])
y = np.array([5.0, 7.0, 9.0, 11.0])
A = np.column_stack([np.ones(len(X)), X])
w, *_ = np.linalg.lstsq(A, y, rcond=None)
print("weights:", w)
--- test
assert w.shape == (2,), f"The model needs an intercept and a slope, so it should have 2 weights, but it has {w.shape[0]}. Add a column of ones."
assert np.allclose(w, [3.0, 2.0]), f"The data follow y = 3 + 2x, so the weights should be [3, 2], but you have {w}."
--- hint
Without a column of ones, the fit can only pass through the origin.
--- hint
Stack a column of ones in front of `X` before calling `lstsq`.
```

## Predict the fit

```python predict id=predict-r2 title="What is R² when predictions are perfect?"
import numpy as np
y = np.array([2.0, 4.0, 6.0])
print(1 - np.sum((y - y) ** 2) / np.sum((y - y.mean()) ** 2))
--- options
* 1.0
0.0
-1.0
2.0
--- explain
With perfect predictions the residual sum of squares is zero, so R² is 1 minus zero, which is exactly 1.
```

## Recap

- Linear regression predicts a weighted sum of the features plus an intercept, and the intercept is a column of ones.
- Least squares finds the best weights in one step with `lstsq`.
- $R^2$ compares the model with predicting the mean. Residuals show what the model still misses.
- scikit-learn's `LinearRegression` computes the same weights.

**Up next:** logistic regression, the same idea adapted for yes-or-no decisions.
