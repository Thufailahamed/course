A single train-and-test split gives one number, and that number depends on which rows happened to land in the test set. Split again with a different seed and the score moves. **Cross-validation** fixes this by splitting many times, so every row is tested exactly once, and reporting the average. It is the standard way to compare models honestly, and it is also the place where a subtle mistake can quietly inflate every score.

## Three sets, three jobs

- The **training** set is where the model learns its weights.
- The **validation** set is where you compare models and choose settings, such as depth or learning rate.
- The **test** set is touched once, at the very end, to report the result.

Using the test set to choose settings turns it into a second validation set, and the final number becomes optimistic.

## K-fold cross-validation

Shuffle the rows and cut them into $k$ folds of nearly equal size. Each fold takes a turn as the validation set while the other $k - 1$ folds train the model.

```python run
import numpy as np

n, k = 10, 5
order = np.random.default_rng(0).permutation(n)
folds = np.array_split(order, k)
for i, fold in enumerate(folds):
    train = np.setdiff1d(np.arange(n), fold)
    print(f"fold {i}: validation rows {sorted(fold.tolist())}, training rows {len(train)}")
```

Every row appears in exactly one validation fold, and every model is trained on the rest. Five folds of 10 rows means five models, each validated on two rows and trained on eight.

## Averaging the folds

```python run
rng = np.random.default_rng(1)
x = rng.uniform(0, 10, 100)
y = 3 + 2 * x + rng.normal(0, 3, 100)

scores = []
for fold in np.array_split(rng.permutation(100), 5):
    train = np.setdiff1d(np.arange(100), fold)
    A = np.column_stack([np.ones(len(train)), x[train]])
    w, *_ = np.linalg.lstsq(A, y[train], rcond=None)
    pred = w[0] + w[1] * x[fold]
    scores.append(np.mean(np.abs(y[fold] - pred)))
print("error per fold:", np.round(scores, 2))
print("cross-validated mean absolute error:", round(np.mean(scores), 2))
```

The five errors vary from fold to fold. Their average is a more reliable estimate than any one of them, and their spread tells you how stable the estimate is.

## Leakage in cross-validation

> **Pitfall:** any step that learns from data, such as a scaler, an imputer or a feature selector, must be fitted inside each training fold, not on the full dataset before splitting. Otherwise the validation rows influence the training, and the scores are too good to be true.

Cutting 100 rows into five folds gives equal parts, and each validation part is a fifth of the data.

```python run
fold_sizes = [len(f) for f in np.array_split(np.arange(100), 5)]
print("validation rows per fold:", fold_sizes, "| total:", sum(fold_sizes))
```

## Time-ordered data

When rows have a time order, a random split lets the model train on the future and test on the past. For time series, split by time: train on earlier rows and validate on later ones.

```python run
months = np.arange(12)
train_months, test_months = months[:9], months[9:]
print("train on months", train_months.tolist(), "and test on", test_months.tolist())
```

> **In the wild:** scikit-learn's `KFold(n_splits=5, shuffle=True)` and `cross_val_score` implement these ideas, and `TimeSeriesSplit` respects time order.

```python
# Static: run this on your own machine with scikit-learn installed
from sklearn.model_selection import cross_val_score, KFold
from sklearn.linear_model import LinearRegression

scores = cross_val_score(LinearRegression(), x.reshape(-1, 1), y,
                         cv=KFold(n_splits=5, shuffle=True, random_state=0),
                         scoring="neg_mean_absolute_error")
print(-scores.mean())
```

## Challenge: k-fold indices

```python exercise id=kfold-indices title="Split rows into k folds"
import numpy as np

# TODO: `kfold_indices(n, k, seed)` returns a list of k (train_idx, val_idx) pairs. Shuffle the numbers 0 to n-1
# with np.random.default_rng(seed), cut them into k nearly equal validation folds with np.array_split, and for
# each fold the training indices are all the rows that are not in that fold.
def kfold_indices(n, k, seed):
    ...
--- solution
import numpy as np

def kfold_indices(n, k, seed):
    order = np.random.default_rng(seed).permutation(n)
    folds = np.array_split(order, k)
    pairs = []
    for fold in folds:
        train = np.setdiff1d(np.arange(n), fold)
        pairs.append((train, fold))
    return pairs
--- test
import numpy as np
result = kfold_indices(10, 5, 0)
assert result is not None, "Replace the `...` in `kfold_indices` with code that returns the list of pairs."
assert len(result) == 5, "Five folds should give five (train, validation) pairs."
all_val = np.concatenate([val for _, val in result])
assert sorted(all_val.tolist()) == list(range(10)), "Every row should be a validation row exactly once."
for train, val in result:
    assert len(val) == 2, "Ten rows in five folds means two validation rows per fold."
    assert set(train) & set(val) == set(), "Training and validation rows must not overlap."
    assert len(train) == 8, "Each training part should hold the other eight rows."
--- hint
Use `np.array_split(order, k)` to cut the shuffled numbers into folds. The training part of a fold is everything outside it, which `np.setdiff1d` finds.
--- hint
Loop over the folds and append `(np.setdiff1d(np.arange(n), fold), fold)` to a list.
```

## Challenge: a cross-validated baseline

```python exercise id=cv-baseline title="Cross-validated error of the mean guess"
import numpy as np

# TODO: `cv_baseline_mae(y, k, seed)` uses k-fold cross-validation with the splits from `kfold_indices` (the
# folds are the shuffled rows cut into k parts, as in the lesson). For each fold, predict the mean of the
# training values for every validation value, and record the mean absolute error. Return the average over folds.
def cv_baseline_mae(y, k, seed):
    ...
--- solution
import numpy as np

def cv_baseline_mae(y, k, seed):
    y = np.asarray(y, dtype=float)
    order = np.random.default_rng(seed).permutation(len(y))
    errors = []
    for fold in np.array_split(order, k):
        train = np.setdiff1d(np.arange(len(y)), fold)
        guess = y[train].mean()
        errors.append(np.mean(np.abs(y[fold] - guess)))
    return float(np.mean(errors))
--- test
import numpy as np
y_t = np.array([1.0, 2.0, 3.0, 4.0, 5.0, 6.0])
result = cv_baseline_mae(y_t, 3, 0)
assert result is not None, "Replace the `...` in `cv_baseline_mae` with code that returns the average error."
assert np.isfinite(result) and result > 0, f"The cross-validated error should be a positive number, but you returned {result!r}."
assert np.isclose(cv_baseline_mae(np.full(9, 4.0), 3, 1), 0.0), "If every value is the same, the mean guess is perfect in every fold."
--- hint
Use the same shuffled folds as `kfold_indices`: `np.array_split(order, k)`. In each fold, compare the validation values with the training mean.
--- hint
Average the per-fold mean absolute errors at the end.
```

## Debug the leaky folds

This cross-validation loop is meant to hold out each fold, but it accidentally trains on the validation rows too.

```python debug id=train-includes-val title="Train only on the other folds"
import numpy as np

y = np.arange(10, dtype=float)
order = np.random.default_rng(0).permutation(10)
fold = np.array_split(order, 5)[0]
train = np.arange(10)                    # bug: the training rows include the validation rows
print("training rows:", len(train), "validation rows:", len(fold))
--- solution
import numpy as np

y = np.arange(10, dtype=float)
order = np.random.default_rng(0).permutation(10)
fold = np.array_split(order, 5)[0]
train = np.setdiff1d(np.arange(10), fold)
print("training rows:", len(train), "validation rows:", len(fold))
--- test
assert set(train) & set(fold) == set(), "The validation rows must not be used for training. Exclude the fold from the training rows."
assert len(train) == 8, "Two validation rows out of ten leave eight training rows."
--- hint
Training rows are everything except the validation fold.
--- hint
`train = np.setdiff1d(np.arange(10), fold)`.
```

## Predict the training size

```python predict id=predict-fold title="How many training rows are in each fold?"
n = 100
k = 5
print(n - n // k)
--- options
* 80
20
100
95
--- explain
Each fold holds 20 validation rows, so the training part holds the other 80. Across all five folds, every row is in the training part four times and in the validation part once.
```

## Recap

- Keep three sets: training to learn, validation to choose, test to report once.
- K-fold cross-validation gives every row one turn in validation, and the average is more reliable than one split.
- Fit every data-dependent step inside the training folds, to avoid leakage.
- For time-ordered data, split by time, never at random.

**Up next:** metrics. The number you report must match the question you care about.
