A model that predicts well but cannot say why is hard to trust, hard to debug and hard to act on. Customers, regulators and colleagues will ask what drives the prediction. Interpretability methods answer that question at two levels: which features matter overall, and why one particular prediction came out the way it did.

This lesson builds the most widely useful global method, **permutation importance**, from scratch, and explains how the local method SHAP works and where to use it.

## The idea: break a feature and see what happens

If a feature matters, shuffling its values should make predictions worse. Shuffling keeps the feature's distribution but breaks its link to the target. The increase in error measures how much the model relied on it.

```python run
import numpy as np

rng = np.random.default_rng(0)
n = 400
X = rng.normal(0, 1, (n, 3))                 # income, age, noise
y = 3.0 * X[:, 0] + 0.5 * X[:, 1] + rng.normal(0, 0.5, n)

w, *_ = np.linalg.lstsq(np.column_stack([np.ones(n), X]), y, rcond=None)
def predict(M):
    return np.column_stack([np.ones(len(M)), M]) @ w

base_error = np.mean((predict(X) - y) ** 2)
print("baseline error:", round(base_error, 3))
for j, name in enumerate(["income", "age", "noise"]):
    shuffled = X.copy()
    shuffled[:, j] = rng.permutation(shuffled[:, j])
    error = np.mean((predict(shuffled) - y) ** 2)
    print(f"{name:>6}: error rises by {error - base_error:.3f} when shuffled")
```

Income matters most, age a little, and the noise column not at all. The ranking is what matters, and it is trustworthy only if you average over several shuffles, since one shuffle is noisy.

## Averaging over shuffles

```python run
def permutation_importance(predict_fn, X, y, j, repeats=10, seed=0):
    rng_p = np.random.default_rng(seed)
    base = np.mean((predict_fn(X) - y) ** 2)
    increases = []
    for _ in range(repeats):
        Xp = X.copy()
        Xp[:, j] = rng_p.permutation(Xp[:, j])
        increases.append(np.mean((predict_fn(Xp) - y) ** 2) - base)
    return float(np.mean(increases))

for j, name in enumerate(["income", "age", "noise"]):
    print(f"{name:>6}: average increase {permutation_importance(predict, X, y, j):.3f}")
```

Averaging the absolute contribution of each feature over all flats gives a summary of its typical influence on one prediction.

```python run
typical = np.mean(np.abs((X - X.mean(axis=0)) * w[1:]), axis=0)
for name, value in zip(["income", "age", "noise"], typical):
    print(f"{name:>6}: average absolute contribution {value:.2f}")
```

## Caution about correlated features

> **Pitfall:** when two features carry the same information, shuffling one lets the model lean on the other, so both look less important than they are. Group correlated features, or check the correlation matrix before reading the ranking.

## Local explanations and SHAP

Permutation importance answers "what matters overall". A local method answers "why this prediction". **SHAP** values split a single prediction into one contribution per feature, adding up to the difference from the average prediction. For a linear model, the contribution of a feature is simply its weight times its deviation from the average.

```python run
row = X[0]
avg = X.mean(axis=0)
contributions = w[1:] * (row - avg)
print("prediction for this row:", round(float(predict(row[None, :])[0]), 2))
print("average prediction:", round(float(predict(avg[None, :])[0]), 2))
print("contribution of each feature:", contributions.round(2))
print("sum of contributions + average = prediction:",
      round(float(predict(avg[None, :])[0] + contributions.sum()), 2))
```

The contributions add up exactly, so the explanation is complete. For non-linear models, SHAP computes the same kind of split with more work, but the promise is the same.

> **In the wild:** the `shap` library computes SHAP values for tree ensembles and neural networks, and `permutation_importance` in scikit-learn implements the global method.

```python
# Static: run this on your own machine with scikit-learn and shap installed
import shap
from sklearn.ensemble import RandomForestRegressor

forest = RandomForestRegressor(n_estimators=100, random_state=0).fit(X, y)
explainer = shap.TreeExplainer(forest)
print(explainer.shap_values(X[:1]))
```

## Challenge: one feature's importance

```python exercise id=perm-importance title="Permutation importance of one feature"
import numpy as np

# TODO: `permutation_drop(predict_fn, X, y, j, seed)` shuffles column j of X once (with np.random.default_rng(seed)),
# and returns the increase in mean squared error from the shuffled version compared with the original X.
def permutation_drop(predict_fn, X, y, j, seed):
    ...
--- solution
import numpy as np

def permutation_drop(predict_fn, X, y, j, seed):
    X = np.asarray(X, dtype=float)
    base = np.mean((predict_fn(X) - y) ** 2)
    Xp = X.copy()
    Xp[:, j] = np.random.default_rng(seed).permutation(Xp[:, j])
    return float(np.mean((predict_fn(Xp) - y) ** 2) - base)
--- test
import numpy as np
X_t = np.array([[0.0, 1.0], [1.0, 0.0], [2.0, 3.0], [3.0, 2.0]])
y_t = 2.0 * X_t[:, 0]
predict_t = lambda M: 2.0 * M[:, 0]
result = permutation_drop(predict_t, X_t, y_t, 0, 0)
assert result is not None, "Replace the `...` in `permutation_drop` with code that returns the increase."
assert result > 0, f"Column 0 drives the predictions exactly, so shuffling it must raise the error, but you returned {result!r}."
assert np.isclose(permutation_drop(predict_t, X_t, y_t, 1, 0), 0.0), "Column 1 is ignored by the model, so shuffling it changes nothing."
--- hint
Compute the baseline error first. Copy X, replace column j with a shuffled version, and compare the two mean squared errors.
--- hint
`Xp[:, j] = np.random.default_rng(seed).permutation(Xp[:, j])`, then return the difference of the two errors.
```

## Challenge: rank features

```python exercise id=rank-features title="Rank features by importance"
import numpy as np

# TODO: `rank_features(names, importances)` returns the feature names sorted from most to least important.
# Ties keep the original order of the names.
def rank_features(names, importances):
    ...
--- solution
import numpy as np

def rank_features(names, importances):
    order = np.argsort(-np.asarray(importances, dtype=float), kind="stable")
    return [names[i] for i in order]
--- test
result = rank_features(["age", "income", "noise"], [0.1, 2.0, 0.0])
assert result is not None, "Replace the `...` in `rank_features` with code that returns the ranked names."
assert result == ["income", "age", "noise"], f"Income (2.0) is most important, then age (0.1), then noise (0.0), but you returned {result}."
assert rank_features(["a", "b"], [1.0, 1.0]) == ["a", "b"], "On a tie the original order should be kept."
--- hint
Sort the indices by decreasing importance with `np.argsort` on the negated values, then map them back to names.
--- hint
`order = np.argsort(-np.asarray(importances), kind="stable")`, then `[names[i] for i in order]`.
```

## Debug the shuffle

This importance check is meant to shuffle the feature, but it copies the column unchanged, so every feature looks useless.

```python debug id=shuffle-real title="Shuffle the column for real"
import numpy as np

X = np.array([[0.0, 1.0], [1.0, 0.0], [2.0, 3.0], [3.0, 2.0]])
y = 2.0 * X[:, 0]
predict = lambda M: 2.0 * M[:, 0]
Xp = X.copy()
Xp[:, 0] = X[:, 0]                       # bug: the column is copied unchanged, not shuffled
increase = np.mean((predict(Xp) - y) ** 2) - np.mean((predict(X) - y) ** 2)
print("increase:", increase)
--- solution
import numpy as np

X = np.array([[0.0, 1.0], [1.0, 0.0], [2.0, 3.0], [3.0, 2.0]])
y = 2.0 * X[:, 0]
predict = lambda M: 2.0 * M[:, 0]
Xp = X.copy()
Xp[:, 0] = np.random.default_rng(0).permutation(X[:, 0])
increase = np.mean((predict(Xp) - y) ** 2) - np.mean((predict(X) - y) ** 2)
print("increase:", increase)
--- test
assert increase > 0, f"Shuffling the column that drives the model must raise the error, but the increase is {increase}. Permute the column, rather than copying it."
--- hint
An unchanged column can never change the error. The shuffle must reorder the values.
--- hint
`np.random.default_rng(0).permutation(X[:, 0])`.
```

## Predict the contribution

```python predict id=predict-shap title="What does the contribution sum to?"
import numpy as np
prediction = 7.0
average = 5.0
contributions = np.array([1.5, 0.5])
print(average + contributions.sum())
--- options
* 7.0
5.0
2.0
8.0
--- explain
The contributions sum to 2.0, and adding the average of 5.0 gives 7.0, which matches the prediction. This additivity is what makes SHAP explanations complete.
```

## Recap

- Permutation importance measures how much the error rises when a feature is shuffled. Average over several shuffles.
- Correlated features can share credit, so check correlations before reading the ranking.
- SHAP splits one prediction into per-feature contributions that add up exactly to the difference from average.
- Explanations support decisions only when the model itself is sound.

**Up next:** the capstone, which puts the whole course into one churn model.
