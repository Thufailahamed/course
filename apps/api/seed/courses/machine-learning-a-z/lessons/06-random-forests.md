A single decision tree is unstable: change a few training rows and the tree can change its top split entirely. A **random forest** fixes that by growing many trees, each on a different random sample of the data and with a random subset of features, and then letting them vote. Averaging many unstable models gives a stable one, and this trick is called **bagging**, short for bootstrap aggregating.

## Bootstrap samples

A bootstrap sample draws $n$ rows *with replacement* from the $n$ training rows. Some rows appear several times, and about a third do not appear at all. Those left-out rows are called out-of-bag, and they give each tree a built-in test set.

```python run
import numpy as np

rng = np.random.default_rng(0)
n = 1000
sample = rng.integers(0, n, n)                  # draw n row numbers with replacement
share_used = len(np.unique(sample)) / n
print("share of distinct rows in one bootstrap sample:", round(share_used, 3))
print("theory: 1 − (1 − 1/n)ⁿ ≈ 0.632 for large n")
```

## Many simple trees, one vote

To keep the example short, each tree here is a *stump*: a single yes-or-no split on one randomly chosen feature. Each stump learns from its own bootstrap sample, and the forest takes the majority vote.

```python run
def fit_stump(x, y):
    best = None
    for t in np.unique(x)[:-1]:
        left, right = y[x <= t], y[x > t]
        lab_l = int(round(left.mean())) if left.size else 0
        lab_r = int(round(right.mean())) if right.size else 0
        acc = np.mean(np.where(x <= t, lab_l, lab_r) == y)
        if best is None or acc > best[0]:
            best = (acc, t, lab_l, lab_r)
    return best[1:]

def stump_predict(stump, x):
    t, lab_l, lab_r = stump
    return np.where(x <= t, lab_l, lab_r)

rng = np.random.default_rng(1)
n = 300
X = rng.normal(0, 1, (n, 4))
y = ((X[:, 0] + X[:, 1] ** 2 - 0.5 * X[:, 2] + rng.normal(0, 0.4, n)) > 0.5).astype(int)

def forest_fit(X, y, n_trees, rng):
    trees = []
    for _ in range(n_trees):
        rows = rng.integers(0, len(y), len(y))
        feature = rng.integers(0, X.shape[1])
        stump = fit_stump(X[rows, feature], y[rows])
        trees.append((feature, stump))
    return trees

def forest_predict(trees, X):
    votes = np.array([stump_predict(s, X[:, f]) for f, s in trees])
    return (votes.mean(axis=0) > 0.5).astype(int)

trees = forest_fit(X, y, 25, rng)
print("one stump's accuracy:", round(np.mean(stump_predict(trees[0][1], X[:, trees[0][0]]) == y), 3))
print("forest accuracy:", round(np.mean(forest_predict(trees, X) == y), 3))
```

A single stump is nearly useless on its own. Twenty-five of them, each seeing a different slice of the data, combine into a much better classifier. Real forests use full trees, not stumps, but the principle is identical.

## Why the vote is stable

```python run
single_scores = []
for seed in range(10):
    r = np.random.default_rng(seed)
    rows = r.integers(0, n, n)                       # each seed sees a different bootstrap sample
    stump = fit_stump(X[rows, 0], y[rows])
    single_scores.append(np.mean(stump_predict(stump, X[:, 0]) == y))
print("single-stump accuracy across 10 bootstrap samples, spread:", round(np.std(single_scores), 4))
```

A single model is fixed by its data, so resampling the data changes it. The forest's average over many resamples changes far less, and that is the stability you are buying.

## Out-of-bag evaluation

Each tree never saw about a third of the rows. Scoring each row only with the trees that skipped it gives an honest estimate without a separate test set.

```python run
rng = np.random.default_rng(2)
counts = np.zeros(n)
totals = np.zeros(n)
for _ in range(25):
    rows = rng.integers(0, n, n)
    out = np.setdiff1d(np.arange(n), rows)
    feature = rng.integers(0, X.shape[1])
    stump = fit_stump(X[rows, feature], y[rows])
    totals[out] += stump_predict(stump, X[out, feature])
    counts[out] += 1
seen = counts > 0
oob_pred = (totals[seen] / counts[seen] > 0.5).astype(int)
print("out-of-bag accuracy:", round(np.mean(oob_pred == y[seen]), 3))
```

> **In the wild:** scikit-learn's `RandomForestClassifier(n_estimators=300, oob_score=True)` does all of this, and its `oob_score_` attribute is the out-of-bag estimate.

```python
# Static: run this on your own machine with scikit-learn installed
from sklearn.ensemble import RandomForestClassifier

forest = RandomForestClassifier(n_estimators=300, oob_score=True, random_state=0).fit(X, y)
print(forest.oob_score_)
```

## Challenge: bootstrap indices

```python exercise id=bootstrap-indices title="Draw a bootstrap sample"
import numpy as np

# TODO: `bootstrap_indices(n, seed)` returns an array of n row numbers drawn uniformly at random
# with replacement from 0 to n-1, using np.random.default_rng(seed).
def bootstrap_indices(n, seed):
    ...
--- solution
import numpy as np

def bootstrap_indices(n, seed):
    return np.random.default_rng(seed).integers(0, n, n)
--- test
import numpy as np
result = bootstrap_indices(1000, 0)
assert result is not None, "Replace the `...` in `bootstrap_indices` with code that returns the indices."
assert result.shape == (1000,), "A bootstrap sample has the same length as the data."
assert result.min() >= 0 and result.max() <= 999, "Indices must be valid row numbers."
assert 0.55 < len(np.unique(result)) / 1000 < 0.7, "About 63% of rows should appear at least once in a bootstrap sample."
assert np.array_equal(bootstrap_indices(1000, 0), result), "The same seed must give the same sample."
--- hint
`rng.integers(low, high, size)` draws random integers, and sampling with replacement is what makes a bootstrap sample.
--- hint
`return np.random.default_rng(seed).integers(0, n, n)`.
```

## Challenge: majority vote

```python exercise id=majority-vote title="Majority vote across trees"
import numpy as np

# TODO: `majority_vote(votes)` takes a 2-D array of 0/1 votes with one row per tree and one column per sample.
# Return a 1-D array with 1 for each sample where strictly more than half of the trees voted 1, and 0 otherwise.
def majority_vote(votes):
    ...
--- solution
import numpy as np

def majority_vote(votes):
    votes = np.asarray(votes)
    return (votes.sum(axis=0) * 2 > votes.shape[0]).astype(int)
--- test
import numpy as np
votes = np.array([[1, 0, 1], [1, 0, 0], [0, 0, 1], [1, 1, 1]])
result = majority_vote(votes)
assert result is not None, "Replace the `...` in `majority_vote` with code that returns the labels."
assert list(result) == [1, 0, 1], f"Sample 1 has 3 of 4 votes for 1, sample 2 has 0, sample 3 has 3. Expected [1, 0, 1], but you returned {list(result)}."
tie = np.array([[1], [0]])
assert list(majority_vote(tie)) == [0], "A tie is not a strict majority, so the answer is 0."
--- hint
Sum the votes for each sample. Compare the sum with half the number of trees, without dividing, to avoid rounding issues.
--- hint
`votes.sum(axis=0) * 2 > votes.shape[0]`, then convert to integers.
```

## Debug the bootstrap

This sampler is meant to draw a bootstrap sample, but it returns a permutation, so every row appears exactly once.

```python debug id=sample-with-replacement title="Sample with replacement"
import numpy as np

rng = np.random.default_rng(0)
n = 10
sample = rng.permutation(n)          # bug: a permutation never repeats a row
print("distinct rows:", len(np.unique(sample)))
--- solution
import numpy as np

rng = np.random.default_rng(0)
n = 10
sample = rng.integers(0, n, n)
print("distinct rows:", len(np.unique(sample)))
--- test
assert len(sample) == n, "A bootstrap sample has n draws."
assert len(np.unique(sample)) < n, "A bootstrap sample draws with replacement, so some rows repeat and fewer than n distinct rows appear. Use integers, not a permutation."
--- hint
A permutation is a shuffle: each row appears once. Bootstrapping needs draws that can repeat.
--- hint
Use `rng.integers(0, n, n)`.
```

## Predict the share

```python predict id=predict-bootstrap title="What share of rows appear in a bootstrap sample of 1000?"
print(round(1 - (1 - 1 / 1000) ** 1000, 2))
--- options
* 0.63
0.5
0.37
1.0
--- explain
Each row is missed by one draw with probability (1 − 1/n), and missed by all n draws with probability (1 − 1/n)ⁿ, which is about 0.368. So about 63% of rows appear at least once, and about a third are out of bag.
```

## Recap

- A bootstrap sample draws rows with replacement, so about 63% of distinct rows appear in each one.
- A forest averages many models trained on different samples, which makes the prediction stable.
- Rows left out of each sample give an honest out-of-bag score.
- scikit-learn's `RandomForestClassifier` does the same, with full trees.

**Up next:** gradient boosting, which builds trees in sequence, each correcting the last.
