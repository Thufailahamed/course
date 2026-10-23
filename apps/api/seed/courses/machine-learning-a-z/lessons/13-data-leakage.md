Data leakage is information that reaches the model during training, which will not be available when it makes real predictions. It is the most dangerous mistake in applied machine learning, because it produces excellent scores. The model looks brilliant in the notebook, then fails in production, and nothing in the code raised an error.

There are two common forms. **Preprocessing leakage** happens when a step that learns from data, such as a scaler or an imputer, sees the validation or test rows. **Target leakage** happens when a feature contains information from the future or from the answer itself.

## Target leakage: a feature that knows the answer

Imagine predicting which customers will cancel. A column called `cancellation_fee_waived` is filled in only after a customer cancels. It predicts the target perfectly, and it is useless on the day you need to decide whom to call.

```python run
import numpy as np

rng = np.random.default_rng(0)
n = 400
churn = rng.integers(0, 2, n)
honest = rng.normal(0, 1, n) + 0.3 * churn           # a weak, real signal
leaky = churn + rng.normal(0, 0.05, n)                # written after the outcome is known

def accuracy_of_threshold(feature, labels):
    best = 0
    for t in np.unique(feature):
        best = max(best, np.mean((feature >= t) == labels))
    return best

print("honest feature, best threshold accuracy:", round(accuracy_of_threshold(honest, churn), 3))
print("leaky feature, best threshold accuracy:", round(accuracy_of_threshold(leaky, churn), 3))
```

A near-perfect score from one column is a red flag, not good news. Ask when each column is known, and drop any that are only known after the outcome.

## Preprocessing leakage: the scaler that saw the test set

The effect is smaller but just as wrong. If the scaler's mean and standard deviation include the test rows, the test rows have influenced the transformation of the training rows.

```python run
rng = np.random.default_rng(1)
train = rng.normal(10, 2, 80)
test = rng.normal(14, 2, 20)                  # the future has drifted upward

honest_mu, honest_sd = train.mean(), train.std()
leaky_mu, leaky_sd = np.concatenate([train, test]).mean(), np.concatenate([train, test]).std()
print("honest scaling of test: mean", round(((test - honest_mu) / honest_sd).mean(), 3))
print("leaky scaling of test:  mean", round(((test - leaky_mu) / leaky_sd).mean(), 3))
```

The honest version shows the drift: the test values sit above the training average, as they should. The leaky version hides it by pulling the scale towards the test values.

Before trusting a feature, check how strongly it tracks the target. A correlation near one with the outcome deserves a question about when the column was written.

```python run
rng = np.random.default_rng(2)
target = rng.integers(0, 2, 100).astype(float)
table = {
    "plain feature": rng.normal(size=100),
    "suspicious feature": target + rng.normal(0, 0.1, 100),
    "another plain feature": rng.normal(size=100),
}
for name, col in table.items():
    print(f"{name:>22}: correlation with target {np.corrcoef(col, target)[0, 1]:+.2f}")
```

## The rule

Every step that learns a number from data must learn it from the training rows only, and then apply that number to everything else. That includes scalers, imputers, encoders, feature selectors and target statistics.

```python run
def scale_with_train(train_part, other_part):
    mu, sd = train_part.mean(axis=0), train_part.std(axis=0)
    return (train_part - mu) / sd, (other_part - mu) / sd

a, b = scale_with_train(train.reshape(-1, 1), test.reshape(-1, 1))
print("test values after honest scaling, mean:", round(b.mean(), 3))
```

> **Pitfall:** calling `fit_transform` on the whole dataset before splitting is the classic version of this mistake. Split first, then fit on the training part, then transform the rest.

> **In the wild:** scikit-learn's `Pipeline` fits each step inside cross-validation folds, which makes this mistake hard to commit. Its `cross_val_score` applies the whole pipeline correctly to every fold.

```python
# Static: run this on your own machine with scikit-learn installed
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression

model = make_pipeline(StandardScaler(), LogisticRegression())
print(model)
```

## Challenge: scale with training statistics

```python exercise id=scale-with-train title="Scale both sets with the training statistics"
import numpy as np

# TODO: `scale_with_train(X_train, X_test)` returns (Xtr_scaled, Xte_scaled). Compute each column's mean and standard
# deviation from X_train only, then scale both arrays with those numbers.
def scale_with_train(X_train, X_test):
    ...
--- solution
import numpy as np

def scale_with_train(X_train, X_test):
    X_train = np.asarray(X_train, dtype=float)
    X_test = np.asarray(X_test, dtype=float)
    mu = X_train.mean(axis=0)
    sd = X_train.std(axis=0)
    return (X_train - mu) / sd, (X_test - mu) / sd
--- test
import numpy as np
result = scale_with_train(np.array([[0.0], [2.0]]), np.array([[4.0]]))
assert result is not None, "Replace the `...` in `scale_with_train` with code that returns the two scaled arrays."
tr, te = result
assert np.allclose(tr, [[-1.0], [1.0]]), f"The training values 0 and 2 have mean 1 and std 1, so they become -1 and 1, but you returned {tr.ravel()}."
assert np.allclose(te, [[3.0]]), f"The test value 4 should use the training statistics and become (4 − 1) / 1 = 3, but you returned {te.ravel()}."
--- hint
Compute `mu` and `sd` from `X_train` alone, then apply those same two arrays to `X_test`.
--- hint
`mu = X_train.mean(axis=0)`, `sd = X_train.std(axis=0)`, then return both scaled arrays.
```

## Challenge: find leaky columns

```python exercise id=leaky-columns title="Flag suspiciously strong columns"
import numpy as np

# TODO: `leaky_columns(X, y, threshold)` returns the indices (as a list) of the columns of X whose absolute
# Pearson correlation with y is greater than `threshold`. A constant column has correlation 0.
def leaky_columns(X, y, threshold):
    ...
--- solution
import numpy as np

def leaky_columns(X, y, threshold):
    X = np.asarray(X, dtype=float)
    y = np.asarray(y, dtype=float)
    flagged = []
    for j in range(X.shape[1]):
        col = X[:, j]
        if col.std() == 0 or y.std() == 0:
            continue
        r = np.corrcoef(col, y)[0, 1]
        if abs(r) > threshold:
            flagged.append(j)
    return flagged
--- test
import numpy as np
rng_t = np.random.default_rng(4)
y_t = rng_t.integers(0, 2, 200).astype(float)
X_t = np.column_stack([rng_t.normal(size=200), y_t + rng_t.normal(0, 0.01, 200), np.ones(200)])
result = leaky_columns(X_t, y_t, 0.9)
assert result is not None, "Replace the `...` in `leaky_columns` with code that returns the list of indices."
assert result == [1], f"Only column 1 tracks the target closely, so the answer is [1], but you returned {result}."
assert leaky_columns(X_t, y_t, 1.1) == [], "No correlation can exceed 1, so a threshold above 1 flags nothing."
--- hint
Loop over the columns. For each one, take `np.corrcoef(col, y)[0, 1]` and compare its absolute value with the threshold.
--- hint
Skip constant columns first, since their correlation is undefined.
```

## Debug the fit order

This preprocessing step is meant to scale the training data using training statistics only, but it fits the scaler on the full table first.

```python debug id=fit-before-split title="Fit the scaler on training rows only"
import numpy as np

X_all = np.array([[1.0], [2.0], [3.0], [10.0]])
X_train, X_test = X_all[:3], X_all[3:]
mu = X_all.mean(axis=0)               # bug: the statistics include the test row
sd = X_all.std(axis=0)
print("scaled test value:", ((X_test - mu) / sd).ravel())
--- solution
import numpy as np

X_all = np.array([[1.0], [2.0], [3.0], [10.0]])
X_train, X_test = X_all[:3], X_all[3:]
mu = X_train.mean(axis=0)
sd = X_train.std(axis=0)
print("scaled test value:", ((X_test - mu) / sd).ravel())
--- test
assert np.isclose(mu[0], 2.0), f"The mean should come from the training rows (1, 2, 3), which is 2, but it is {mu[0]}. The test row must not influence the scaler."
assert np.isclose(sd[0], np.std([1.0, 2.0, 3.0])), "The standard deviation should also come from the training rows only."
--- hint
Which rows should the scaler be allowed to see? Only the training rows.
--- hint
Compute `mu` and `sd` from `X_train`, not `X_all`.
```

## Predict the leak

```python predict id=predict-leak title="Which mean is honest?"
import numpy as np
train = np.array([1.0, 2.0, 3.0])
test = np.array([10.0])
print(train.mean(), np.concatenate([train, test]).mean())
--- options
* 2.0 4.0
4.0 2.0
2.0 2.0
10.0 10.0
--- explain
The honest mean comes from the training rows alone: 2.0. Including the test value 10 moves the mean to 4.0, which is the leak. The first printed value is the honest one.
```

## Recap

- Target leakage: drop features that are only known after the outcome, or that are the outcome in disguise.
- Preprocessing leakage: fit every scaler, imputer and encoder on training rows only.
- Split first, fit on the training part, then transform everything else with those numbers.
- A suspiciously perfect score is a sign of leakage until proven otherwise.

**Up next:** pipelines, which make the correct order of steps automatic.
