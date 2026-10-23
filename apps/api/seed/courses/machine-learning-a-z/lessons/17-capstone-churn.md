This is the capstone. You will build a customer churn model from raw data to a defensible result, using every idea in the course: a clear target and metric, honest splits, leak-free preprocessing, a model you can explain, a threshold chosen for the business, and an honest test score.

The business question is: **which customers are likely to cancel in the next month, and how many should the retention team call?** The team can call about 100 customers a week, and a wrongly called customer costs a small amount of goodwill, so precision matters as much as recall.

The data are generated in the page and are messy, as real data are.

## Build the dataset

```python run
import numpy as np

def make_churn(n=1200, seed=21):
    rng = np.random.default_rng(seed)
    tenure = rng.integers(1, 61, n).astype(float)                # months as a customer
    spend = rng.gamma(4.0, 12.0, n)                               # monthly spend, euros
    calls = rng.poisson(1.2, n).astype(float)                     # support calls last month
    contract = rng.integers(0, 2, n).astype(float)                # 1 = yearly contract
    age = rng.uniform(18, 80, n)
    score = -0.05 * tenure - 0.01 * spend + 0.6 * calls - 1.2 * contract - 0.01 * age + 1.0
    churn = (rng.random(n) < 1 / (1 + np.exp(-score))).astype(float)
    X = np.column_stack([tenure, spend, calls, contract, age])
    X[rng.random(n) < 0.04, 1] = np.nan                            # 4% of spend values were lost
    return X, churn

X, y = make_churn()
names = ["tenure", "spend", "calls", "yearly contract", "age"]
print("customers:", len(y), "| churn rate:", round(y.mean(), 3))
print("missing spend values:", int(np.isnan(X[:, 1]).sum()))
```

The churn rate is the first thing to report, because a model that predicts "no churn" for everyone already has that accuracy.

## Split first

```python run
order = np.random.default_rng(0).permutation(len(y))
n_test, n_val = int(0.2 * len(y)), int(0.2 * len(y))
test_idx = order[:n_test]
val_idx = order[n_test:n_test + n_val]
train_idx = order[n_test + n_val:]
print("train:", len(train_idx), "| validation:", len(val_idx), "| test:", len(test_idx))
```

The test set is set aside now and used once, at the very end.

## Preprocess with training statistics only

```python run
def fit_preprocessor(X_train):
    median = np.nanmedian(X_train, axis=0)
    filled = np.where(np.isnan(X_train), median, X_train)
    mean, std = filled.mean(axis=0), filled.std(axis=0)
    return {"median": median, "mean": mean, "std": std}

def apply_preprocessor(prep, X):
    filled = np.where(np.isnan(X), prep["median"], X)
    return (filled - prep["mean"]) / prep["std"]

prep = fit_preprocessor(X[train_idx])
A_train = apply_preprocessor(prep, X[train_idx])
A_val = apply_preprocessor(prep, X[val_idx])
A_test = apply_preprocessor(prep, X[test_idx])
print("train mean after preprocessing:", A_train.mean(axis=0).round(3))
```

Every number the preprocessing needs, including the median and the scale, comes from the training rows, and it is then applied unchanged to the validation and test rows.

## Train a logistic model

```python run
def fit_logistic(A, y, steps=800, lr=0.3):
    Z = np.column_stack([np.ones(len(A)), A])
    w = np.zeros(Z.shape[1])
    for _ in range(steps):
        p = 1 / (1 + np.exp(-(Z @ w)))
        w -= lr * (Z.T @ (p - y)) / len(y)
    return w

def score(w, A):
    Z = np.column_stack([np.ones(len(A)), A])
    return 1 / (1 + np.exp(-(Z @ w)))

w = fit_logistic(A_train, y[train_idx])
print("weights (intercept first):", w.round(2))
print("features that raise churn risk:", [n for n, wt in zip(names, w[1:]) if wt > 0])
```

The weights have the signs of the rule behind the data: calls and spend-related effects push risk one way, while tenure and yearly contracts push it down.

## Measure on validation data

```python run
def metrics_at(scores, labels, threshold):
    flagged = scores >= threshold
    tp = np.sum(flagged & (labels == 1))
    fp = np.sum(flagged & (labels == 0))
    fn = np.sum(~flagged & (labels == 1))
    precision = tp / (tp + fp) if tp + fp else 0.0
    recall = tp / (tp + fn) if tp + fn else 0.0
    return precision, recall

val_scores = score(w, A_val)
val_labels = y[val_idx]
p, r = metrics_at(val_scores, val_labels, 0.5)
print("at threshold 0.5: precision", round(p, 3), "| recall", round(r, 3))
```

The default threshold of 0.5 is a convention, not a decision. The retention team has a call budget, so the threshold should be chosen for the business.

## Choose the threshold for the budget

```python run
for t in [0.3, 0.4, 0.5, 0.6]:
    flagged = int((val_scores >= t).sum())
    p, r = metrics_at(val_scores, val_labels, t)
    print(f"threshold {t}: flags {flagged:>3} customers, precision {p:.2f}, recall {r:.2f}")
```

Choose the threshold where the number of flagged customers fits the call budget and the precision is acceptable. Those two numbers are the business trade-off, and only the team can judge which mix is worth paying for.

## Explain the model

```python run
rng_e = np.random.default_rng(3)
base = np.mean((score(w, A_val) - val_labels) ** 2)
for j, name in enumerate(names):
    shuffled = A_val.copy()
    shuffled[:, j] = rng_e.permutation(shuffled[:, j])
    drop = np.mean((score(w, shuffled) - val_labels) ** 2) - base
    print(f"{name:>16}: error rises by {drop:.4f} when shuffled")
```

## Report once, on the test set

```python run
A_final = A_test
test_scores = score(w, A_final)
test_labels = y[test_idx]
p, r = metrics_at(test_scores, test_labels, 0.4)
print(f"test set at threshold 0.4: precision {p:.2f}, recall {r:.2f}")
print("limits: one synthetic dataset, a simple linear model, and a threshold chosen on validation data")
```

The test score is the one number you report, and you report it once.

## Challenge: AUC from pairs

```python exercise id=auc-pairs title="AUC from pairs"
import numpy as np

# TODO: `auc(scores, labels)` returns the fraction of (positive, negative) pairs in which the positive has the higher
# score, counting a tie as one half. Labels are 0 or 1 and both classes are present.
def auc(scores, labels):
    ...
--- solution
import numpy as np

def auc(scores, labels):
    scores = np.asarray(scores, dtype=float)
    labels = np.asarray(labels)
    pos, neg = scores[labels == 1], scores[labels == 0]
    wins = (pos[:, None] > neg[None, :]).sum() + 0.5 * (pos[:, None] == neg[None, :]).sum()
    return float(wins / (len(pos) * len(neg)))
--- test
import numpy as np
result = auc([0.9, 0.8, 0.4, 0.7, 0.3, 0.2, 0.1], [1, 1, 1, 0, 0, 0, 0])
assert result is not None, "Replace the `...` in `auc` with code that returns the AUC."
assert np.isclose(result, 11 / 12), f"Eleven of the twelve positive-negative pairs are ordered correctly, so the AUC is 11/12, but you returned {result!r}."
assert np.isclose(auc([0.1, 0.9], [0, 1]), 1.0), "A perfect ranking has AUC 1."
assert np.isclose(auc([0.9, 0.1], [0, 1]), 0.0), "A reversed ranking has AUC 0."
assert np.isclose(auc([0.5, 0.5], [0, 1]), 0.5), "A tie counts as one half."
--- hint
Split the scores into the positives and the negatives. Compare every pair with a broadcast, count the wins, and count ties as half.
--- hint
`pos[:, None] > neg[None, :]` gives a grid of all pairs. Sum it, add half the ties, and divide by the number of pairs.
```

## Challenge: choose a threshold

```python exercise id=choose-threshold title="Threshold for a precision target"
import numpy as np

# TODO: `choose_threshold(scores, labels, min_precision)` looks at every distinct score as a candidate threshold t,
# flagging rows with score >= t. Among the thresholds whose precision is at least `min_precision`, return the one with
# the highest recall. If several have that recall, return the highest threshold. If none qualify, return None.
def choose_threshold(scores, labels, min_precision):
    ...
--- solution
import numpy as np

def choose_threshold(scores, labels, min_precision):
    scores = np.asarray(scores, dtype=float)
    labels = np.asarray(labels)
    best_t, best_recall = None, -1.0
    for t in np.unique(scores):
        flagged = scores >= t
        tp = np.sum(flagged & (labels == 1))
        fp = np.sum(flagged & (labels == 0))
        fn = np.sum(~flagged & (labels == 1))
        precision = tp / (tp + fp) if tp + fp else 0.0
        recall = tp / (tp + fn) if tp + fn else 0.0
        if precision >= min_precision and (recall > best_recall or (recall == best_recall and t > best_t)):
            best_t, best_recall = t, recall
    return None if best_t is None else float(best_t)
--- test
scores = [0.9, 0.8, 0.7, 0.6, 0.2]
labels = [1, 1, 0, 1, 0]
result = choose_threshold(scores, labels, 0.6)
assert result is not None, "Replace the `...` in `choose_threshold` with code that returns the threshold."
assert np.isclose(result, 0.6), f"Thresholds 0.6 and 0.2 both reach recall 1 with precision at least 0.6, and the higher one is 0.6, but you returned {result!r}."
assert np.isclose(choose_threshold(scores, labels, 0.9), 0.8), "With precision at least 0.9 the best recall is 2/3, at threshold 0.8."
assert choose_threshold(scores, labels, 1.1) is None, "If no threshold reaches the precision target, return None."
--- hint
Loop over `np.unique(scores)`. For each candidate compute precision and recall as in the metrics lesson, and keep the best qualifying one.
--- hint
Compare the recall first, and break ties by keeping the higher threshold.
```

## Debug the training rows

This capstone step is meant to train on the training rows only, but it fits the model on every row.

```python debug id=train-only-fit title="Train on the training rows only"
import numpy as np

rng_d = np.random.default_rng(1)
A = rng_d.normal(size=(20, 2))
y = (A[:, 0] > 0).astype(float)
train_idx = np.arange(12)
rows_used = len(A)                       # bug: the fit should use only the training rows
print("rows used for fitting:", rows_used)
--- solution
import numpy as np

rng_d = np.random.default_rng(1)
A = rng_d.normal(size=(20, 2))
y = (A[:, 0] > 0).astype(float)
train_idx = np.arange(12)
rows_used = len(train_idx)
print("rows used for fitting:", rows_used)
--- test
assert rows_used == len(train_idx), f"The model should be fitted on the {len(train_idx)} training rows only, but it uses {rows_used}. Validation and test rows must not influence the weights."
--- hint
Which index array defines the training rows?
--- hint
Count the rows of the training index, `len(train_idx)`, not of the whole table.
```

## Predict the threshold count

```python predict id=predict-flags title="How many customers are flagged at threshold 0.5?"
import numpy as np
scores = np.array([0.2, 0.5, 0.7, 0.9])
print(int((scores >= 0.5).sum()))
--- options
* 3
2
4
1
--- explain
The threshold is inclusive, so a score exactly equal to 0.5 is flagged too. Three of the four scores are at or above 0.5.
```

## Recap

- Report the base churn rate first, and measure against it.
- Split once for the test set, then split the rest into training and validation.
- Fit every preprocessing step and the model on training rows only, and apply them unchanged elsewhere.
- Choose the threshold for the business budget, explain the model, and report the test score once.

**Congratulations.** You have built a complete machine-learning project. The final assessment checks the whole course.
