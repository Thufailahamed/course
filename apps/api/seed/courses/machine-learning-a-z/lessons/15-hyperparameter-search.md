Most models have settings you choose rather than learn: the depth of a tree, the learning rate of boosting, the strength of a penalty. These are **hyperparameters**, and choosing them well can change a model's quality more than switching algorithms. The method is simple to state: try candidate settings, score each one on held-out data with cross-validation, and keep the best. The discipline lies in never letting the test set take part.

This lesson tunes the strength of a ridge penalty, the regularized version of linear regression, using the cross-validation you built in lesson 9.

## Ridge regression

Ridge regression adds a penalty $\lambda \lVert w \rVert^2$ to the squared error. It keeps the weights small, which trades a little bias for much less variance. The solution is still in closed form:

$$
w = (X^{\top} X + \lambda I)^{-1} X^{\top} y
$$

```python run
import numpy as np

rng = np.random.default_rng(0)
n, d = 60, 12
X = rng.normal(0, 1, (n, d))
true_w = np.zeros(d)
true_w[:3] = [2.0, -1.0, 0.5]                 # only three features matter
y = X @ true_w + rng.normal(0, 1.0, n)

def ridge(X, y, lam):
    return np.linalg.solve(X.T @ X + lam * np.eye(X.shape[1]), X.T @ y)

for lam in [0.0, 1.0, 20.0]:
    w = ridge(X, y, lam)
    print(f"λ = {lam:>4}: largest |weight| {np.abs(w).max():.2f}, weights on the 9 noise features: {np.abs(w[3:]).sum():.2f}")
```

A larger penalty shrinks the weights, including the ones on the irrelevant features. Too much shrinkage underfits, so the best penalty is somewhere in the middle.

## Grid search with cross-validation

A grid search tries every value in a list, scores each with k-fold cross-validation, and records the average error.

```python run
def cv_error(X, y, lam, k=5, seed=0):
    order = np.random.default_rng(seed).permutation(len(y))
    errors = []
    for fold in np.array_split(order, k):
        train = np.setdiff1d(np.arange(len(y)), fold)
        w = ridge(X[train], y[train], lam)
        errors.append(np.mean((X[fold] @ w - y[fold]) ** 2))
    return np.mean(errors)

grid = [0.01, 0.1, 1.0, 5.0, 20.0, 100.0]
results = {lam: cv_error(X, y, lam) for lam in grid}
for lam, err in results.items():
    print(f"λ = {lam:>6}: cross-validated error {err:.3f}")
best = min(results, key=results.get)
print("best λ:", best)
```

The grid's error curve has a minimum. Notice that the score is averaged over folds, so one unlucky split cannot pick the winner.

The penalty also changes the size of the weights. This table shows the total weight magnitude as λ grows.

```python run
for lam in [0.1, 1.0, 10.0, 100.0]:
    w = ridge(X, y, lam)
    print(f"λ = {lam:>6}: sum of |weights| {np.abs(w).sum():6.2f}")
```

## Random search

A grid grows fast with more hyperparameters. Sampling candidates at random often finds good settings with fewer trials, because only a few hyperparameters usually matter.

```python run
rng_s = np.random.default_rng(5)
sampled = 10 ** rng_s.uniform(-2, 2, 8)        # eight values, log-uniform between 0.01 and 100
scores = {round(float(lam), 3): cv_error(X, y, lam) for lam in sampled}
print("sampled λ values:", sorted(scores))
print("best sampled λ:", min(scores, key=scores.get))
```

Sample on a logarithmic scale for penalties and learning rates, because the difference between 0.01 and 0.1 matters as much as the difference between 10 and 100.

> **Pitfall:** the search must never see the test set. Tune with cross-validation on the training data, then evaluate the chosen setting once on the test set.

> **In the wild:** scikit-learn's `GridSearchCV` and `RandomizedSearchCV` wrap this procedure, and `Pipeline` keeps the preprocessing inside each fold.

```python
# Static: run this on your own machine with scikit-learn installed
from sklearn.linear_model import Ridge
from sklearn.model_selection import GridSearchCV

search = GridSearchCV(Ridge(), {"alpha": [0.01, 0.1, 1.0, 10.0, 100.0]}, cv=5)
search.fit(X, y)
print(search.best_params_)
```

## Challenge: ridge weights

```python exercise id=ridge-weights title="Ridge regression weights"
import numpy as np

# TODO: `ridge_weights(X, y, lam)` returns the ridge regression weights w = (XᵀX + λI)⁻¹ Xᵀy as a 1-D array.
def ridge_weights(X, y, lam):
    ...
--- solution
import numpy as np

def ridge_weights(X, y, lam):
    X = np.asarray(X, dtype=float)
    return np.linalg.solve(X.T @ X + lam * np.eye(X.shape[1]), X.T @ np.asarray(y, dtype=float))
--- test
import numpy as np
X_t = np.array([[1.0, 0.0], [0.0, 1.0], [1.0, 1.0]])
y_t = np.array([1.0, 2.0, 3.0])
result = ridge_weights(X_t, y_t, 0.0)
assert result is not None, "Replace the `...` in `ridge_weights` with code that returns the weights."
assert np.allclose(result, [1.0, 2.0]), f"With no penalty this is ordinary least squares, which gives [1, 2] here, but you returned {result}."
shrunk = ridge_weights(X_t, y_t, 10.0)
assert np.linalg.norm(shrunk) < np.linalg.norm(result), "A larger penalty must make the weights smaller."
--- hint
Build `X.T @ X + lam * np.eye(d)`, then solve the linear system against `X.T @ y` with `np.linalg.solve`.
--- hint
`np.linalg.solve(X.T @ X + lam * np.eye(X.shape[1]), X.T @ y)`.
```

## Challenge: pick the best penalty

```python exercise id=best-lambda title="Choose the penalty with the lowest error"
import numpy as np

# TODO: `best_lambda(lams, errors)` returns the value in `lams` whose matching error in `errors` is smallest.
# If several are tied, return the smallest λ.
def best_lambda(lams, errors):
    ...
--- solution
import numpy as np

def best_lambda(lams, errors):
    lams = np.asarray(lams, dtype=float)
    errors = np.asarray(errors, dtype=float)
    best = np.flatnonzero(errors == errors.min())
    return float(lams[best].min())
--- test
result = best_lambda([0.1, 1.0, 10.0], [0.5, 0.2, 0.9])
assert result is not None, "Replace the `...` in `best_lambda` with code that returns the best penalty."
assert result == 1.0, f"The lowest error, 0.2, belongs to λ = 1.0, but you returned {result!r}."
assert best_lambda([3.0, 1.0, 2.0], [0.4, 0.4, 0.9]) == 1.0, "On a tie, return the smallest λ."
--- hint
Find the position of the smallest error with `np.argmin`, then read the λ at that position.
--- hint
`return lams[np.argmin(errors)]`. For the tie rule, use the smallest λ among the tied positions.
```

## Debug the direction of the search

This search is meant to pick the penalty with the lowest error, but it picks the highest.

```python debug id=argmax-error title="Pick the lowest error"
import numpy as np

lams = np.array([0.1, 1.0, 10.0])
errors = np.array([0.5, 0.2, 0.9])
best = lams[np.argmax(errors)]           # bug: argmax finds the largest error
print("best λ:", best)
--- solution
import numpy as np

lams = np.array([0.1, 1.0, 10.0])
errors = np.array([0.5, 0.2, 0.9])
best = lams[np.argmin(errors)]
print("best λ:", best)
--- test
assert best == 1.0, f"Lower error is better, so the best λ is 1.0, but the code picks {best}. Use argmin, not argmax."
--- hint
An error is a cost to minimize. Which function finds the smallest value?
--- hint
Replace `np.argmax` with `np.argmin`.
```

## Predict the number of fits

```python predict id=predict-fits title="How many models does this search train?"
lams = [0.01, 0.1, 1.0, 10.0]
folds = 5
print(len(lams) * folds)
--- options
* 20
4
5
9
--- explain
Each penalty is evaluated on each of the five folds, which trains one model per fold. Four penalties times five folds is 20 models, all trained before the best setting is chosen.
```

## Recap

- Hyperparameters are chosen, not learned, and they often matter more than the algorithm.
- Grid search tries every candidate; random search samples candidates, often on a log scale.
- Score every candidate with cross-validation on training data, and keep the test set out of the search.
- A penalty that is too small overfits and one that is too large underfits. The best value sits between.

**Up next:** explaining predictions, so that the model's reasoning can be checked and communicated.
