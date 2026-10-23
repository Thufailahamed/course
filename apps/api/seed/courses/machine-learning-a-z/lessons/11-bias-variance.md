Every model makes two kinds of error. **Bias** is the error from a model that is too simple to capture the real pattern: a straight line through a curve. **Variance** is the error from a model that is so flexible it fits the noise in its training data, and changes a lot when that data changes. The skill is finding the complexity that balances the two, and the best tool for seeing it is a plot of training and validation error against model complexity.

## A curve and its noise

```python run
import numpy as np
import matplotlib.pyplot as plt

rng = np.random.default_rng(3)
x_train = np.sort(rng.uniform(0, 1, 20))
y_train = np.sin(2 * np.pi * x_train) + rng.normal(0, 0.25, 20)
x_val = np.sort(rng.uniform(0, 1, 200))
y_val = np.sin(2 * np.pi * x_val) + rng.normal(0, 0.25, 200)

def poly_matrix(x, degree):
    return np.column_stack([x ** k for k in range(degree + 1)])

def fit_and_score(degree):
    w, *_ = np.linalg.lstsq(poly_matrix(x_train, degree), y_train, rcond=None)
    train_err = np.mean((poly_matrix(x_train, degree) @ w - y_train) ** 2)
    val_err = np.mean((poly_matrix(x_val, degree) @ w - y_val) ** 2)
    return train_err, val_err

degrees = range(1, 13)
errors = [fit_and_score(d) for d in degrees]
for d, (tr, va) in zip(degrees, errors):
    print(f"degree {d:>2}: training {tr:.4f}   validation {va:.4f}")
```

Read the table from top to bottom. Training error only goes down as the model gets more flexible. Validation error falls at first, then climbs as the model starts fitting noise. The lowest validation error marks the sweet spot.

```python run
fig, ax = plt.subplots(figsize=(5.5, 3.5))
ax.plot(list(degrees), [e[0] for e in errors], "o-", label="training")
ax.plot(list(degrees), [e[1] for e in errors], "o-", label="validation")
ax.set_yscale("log")
ax.set_xlabel("model complexity (polynomial degree)")
ax.set_ylabel("mean squared error")
ax.legend(); ax.grid(alpha=0.3)
plt.show()
```

## Underfitting and overfitting

- **High bias (underfitting):** both errors are high and close together. The model cannot express the pattern, so more data will not help much. Add features or flexibility.
- **High variance (overfitting):** training error is low, validation error is high, and the gap is wide. More data often helps, and so does regularization.

A quick look at what the curves mean in practice: the prediction each polynomial makes at x = 0.5, where the true value is sin(π) = 0.

```python run
for d in [1, 3, 12]:
    w, *_ = np.linalg.lstsq(poly_matrix(x_train, d), y_train, rcond=None)
    print(f"degree {d:>2}: prediction at x = 0.5 is {float((poly_matrix(np.array([0.5]), d) @ w)[0]):+.3f}")
```

Low-degree models give a stable but biased answer, and the flexible degree-12 model moves far from the truth. Both behaviours appear in the curves above.

## Learning curves

A learning curve shows error against the amount of training data. It tells you whether getting more data is worth the effort.

```python run
sizes = [5, 10, 20]
for m in sizes:
    x_m, y_m = x_train[:m], y_train[:m]
    w, *_ = np.linalg.lstsq(poly_matrix(x_m, 4), y_m, rcond=None)
    val = np.mean((poly_matrix(x_val, 4) @ w - y_val) ** 2)
    print(f"{m:>2} training examples: validation error {val:.4f}")
```

If the validation error keeps falling as data grows, the model is data-limited. If it has flattened while the training error stays low, more data will not help, and a different model is needed.

> **In the wild:** scikit-learn's `learning_curve` and `validation_curve` compute these curves, and `GridSearchCV` finds the complexity that minimizes validation error.

```python
# Static: run this on your own machine with scikit-learn installed
from sklearn.model_selection import validation_curve
from sklearn.preprocessing import PolynomialFeatures
from sklearn.linear_model import LinearRegression
from sklearn.pipeline import make_pipeline

model = make_pipeline(PolynomialFeatures(), LinearRegression())
train_scores, val_scores = validation_curve(
    model, x_train.reshape(-1, 1), y_train,
    param_name="polynomialfeatures__degree", param_range=[1, 4, 8],
    scoring="neg_mean_squared_error", cv=5)
print(-val_scores.mean(axis=1))
```

## Challenge: polynomial features

```python exercise id=poly-features title="Build polynomial features"
import numpy as np

# TODO: `poly_features(x, degree)` returns a 2-D array with one row per value of x and columns x⁰, x¹, …, x^degree.
def poly_features(x, degree):
    ...
--- solution
import numpy as np

def poly_features(x, degree):
    x = np.asarray(x, dtype=float)
    return np.column_stack([x ** k for k in range(degree + 1)])
--- test
import numpy as np
result = poly_features([2.0, 3.0], 2)
assert result is not None, "Replace the `...` in `poly_features` with code that returns the matrix."
assert result.shape == (2, 3), f"Two values with degree 2 should give shape (2, 3), but you returned {result.shape}."
assert np.allclose(result, [[1.0, 2.0, 4.0], [1.0, 3.0, 9.0]]), f"The rows should be [1, x, x²], giving [1, 2, 4] and [1, 3, 9], but you returned {result}."
assert np.allclose(poly_features([5.0], 0), [[1.0]]), "Degree zero is just the column of ones."
--- hint
Stack one column per power, starting from the power zero column of ones, with `np.column_stack`.
--- hint
`np.column_stack([x ** k for k in range(degree + 1)])`.
```

## Challenge: a fitted curve's error

```python exercise id=poly-val-error title="Validation error of a polynomial fit"
import numpy as np

# TODO: `poly_val_error(x_train, y_train, x_val, y_val, degree)` fits a least-squares polynomial of the given degree
# to the training data (with columns x⁰ to x^degree), then returns the mean squared error on the validation data.
def poly_val_error(x_train, y_train, x_val, y_val, degree):
    ...
--- solution
import numpy as np

def poly_val_error(x_train, y_train, x_val, y_val, degree):
    A = np.column_stack([np.asarray(x_train, dtype=float) ** k for k in range(degree + 1)])
    w, *_ = np.linalg.lstsq(A, np.asarray(y_train, dtype=float), rcond=None)
    B = np.column_stack([np.asarray(x_val, dtype=float) ** k for k in range(degree + 1)])
    return float(np.mean((B @ w - np.asarray(y_val, dtype=float)) ** 2))
--- test
import numpy as np
x_tr = np.array([0.0, 1.0, 2.0, 3.0])
y_tr = 1.0 + 2.0 * x_tr
x_va = np.array([4.0, 5.0])
y_va = 1.0 + 2.0 * x_va
result = poly_val_error(x_tr, y_tr, x_va, y_va, 1)
assert result is not None, "Replace the `...` in `poly_val_error` with code that returns the error."
assert np.isclose(result, 0.0, atol=1e-9), f"The data follow a line exactly, so a degree-1 fit has zero validation error, but you returned {result!r}."
assert poly_val_error(x_tr, y_tr, x_va, y_va, 0) > 1.0, "A constant cannot follow a rising line, so a degree-0 fit should have a large error."
--- hint
Build the training matrix with the same powers as `poly_features`, solve with `np.linalg.lstsq`, then build the validation matrix and compare its predictions with `y_val`.
--- hint
Keep the fitted weights `w` and apply them to the validation matrix before taking the squared differences.
```

## Debug the evaluation data

This code is meant to report validation error, but it measures the fit on the training data instead.

```python debug id=eval-on-train title="Measure on the validation data"
import numpy as np

x_tr = np.array([0.0, 1.0, 2.0, 3.0])
y_tr = np.array([0.0, 1.0, 2.5, 3.0])
x_va = np.array([4.0, 5.0])
y_va = np.array([4.5, 5.5])
A = np.column_stack([np.ones(4), x_tr])
w, *_ = np.linalg.lstsq(A, y_tr, rcond=None)
pred_train = np.column_stack([np.ones(4), x_tr]) @ w
val_error = np.mean((pred_train - y_tr) ** 2)       # bug: this is the training error
print("validation error:", round(val_error, 4))
--- solution
import numpy as np

x_tr = np.array([0.0, 1.0, 2.0, 3.0])
y_tr = np.array([0.0, 1.0, 2.5, 3.0])
x_va = np.array([4.0, 5.0])
y_va = np.array([4.5, 5.5])
A = np.column_stack([np.ones(4), x_tr])
w, *_ = np.linalg.lstsq(A, y_tr, rcond=None)
pred_val = np.column_stack([np.ones(2), x_va]) @ w
val_error = np.mean((pred_val - y_va) ** 2)
print("validation error:", round(val_error, 4))
--- test
assert np.isclose(val_error, np.mean((np.column_stack([np.ones(2), x_va]) @ w - y_va) ** 2)), "The validation error must compare predictions on the validation inputs with the validation targets."
--- hint
The error must use the validation inputs `x_va` and targets `y_va`, not the training ones.
--- hint
Build the matrix from `x_va` and compare its predictions with `y_va`.
```

## Predict the trend

```python predict id=predict-bv title="What is the training error of the most flexible fit?"
import numpy as np
x = np.array([0.0, 1.0, 2.0])
y = np.array([1.0, 0.0, 1.0])
A = np.column_stack([x ** k for k in range(3)])     # degree 2: three columns, three points
w, *_ = np.linalg.lstsq(A, y, rcond=None)
print(round(float(np.mean((A @ w - y) ** 2)), 6))
--- options
* 0.0
0.5
1.0
0.333333
--- explain
A degree-2 polynomial has three free weights, and three points determine a unique parabola through them. The parabola passes through all three points, so the training error is zero. A more flexible model can always fit the training points at least as well, which is why training error alone cannot choose the complexity.
```

## Recap

- Bias comes from a model too simple for the pattern. Variance comes from a model that fits noise.
- Plot training and validation error against complexity, and choose the lowest validation point.
- Learning curves show whether more data would help.
- Judge complexity on validation data, never on training error.

**Up next:** feature engineering, the step that often matters more than the choice of model.
