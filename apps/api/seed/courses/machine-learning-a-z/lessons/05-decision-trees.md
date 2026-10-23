A decision tree learns a sequence of yes-or-no questions. "Is the tenure under 12 months? If yes, is the monthly spend above 40?" Trees are easy to read, need no feature scaling, and can capture interactions between features that a straight line cannot. Their weakness is that they memorize unless you constrain them, and the constraints are where most of the skill lies.

## Impurity: how mixed is a group?

A split is good when it separates the classes. **Gini impurity** measures how mixed a group is: 0 for a group of one class, and larger when the classes are evenly mixed.

$$
\text{gini} = 1 - \sum_k p_k^2
$$

where $p_k$ is the share of class $k$ in the group.

```python run
import numpy as np

def gini(labels):
    labels = np.asarray(labels)
    if labels.size == 0:
        return 0.0
    _, counts = np.unique(labels, return_counts=True)
    p = counts / labels.size
    return float(1 - np.sum(p ** 2))

print("pure group:", gini([1, 1, 1, 1]))
print("half and half:", gini([0, 0, 1, 1]))
print("mostly one class:", round(gini([0, 0, 0, 1]), 3))
```

## The best split on one feature

A tree tries every threshold on a feature, splits the rows into "at or below" and "above", and keeps the threshold where the weighted impurity of the two sides is lowest. Try it by hand first.

```python run
x = np.array([1.0, 2.0, 3.0, 10.0, 11.0, 12.0])
y = np.array([0, 0, 0, 1, 1, 1])

for t in [2.5, 6.5, 10.5]:
    left, right = y[x <= t], y[x > t]
    score = (len(left) * gini(left) + len(right) * gini(right)) / len(y)
    print(f"threshold {t:>4}: weighted impurity {score:.3f}")
```

The threshold 6.5 separates the classes perfectly, so its weighted impurity is zero. Trees search exactly this way, for every feature, at every node.

## Grow a small tree

Apply the search recursively: split, then split each side again, until the groups are pure or a depth limit is reached. The depth limit is the simplest way to stop the tree memorizing.

```python run
def grow(x, y, depth):
    if depth == 0 or len(np.unique(y)) == 1:
        return {"leaf": int(np.bincount(y).argmax())}
    t = np.median(x)
    left, right = x <= t, x > t
    if not left.any() or not right.any():
        return {"leaf": int(np.bincount(y).argmax())}
    return {"threshold": float(t),
            "left": grow(x[left], y[left], depth - 1),
            "right": grow(x[right], y[right], depth - 1)}

def predict_one(tree, value):
    while "leaf" not in tree:
        tree = tree["left"] if value <= tree["threshold"] else tree["right"]
    return tree["leaf"]

tree = grow(x, y, depth=2)
print(tree)
print("prediction for 8.0:", predict_one(tree, 8.0))
```

This version splits at the median, which is a simple rule rather than the best threshold. The challenge below uses the real search.

## Overfitting: the tree that learns noise

Trees keep splitting until every training row is classified correctly, so a deep tree memorizes noise. A shallow tree generalizes better.

```python run
rng = np.random.default_rng(5)
xs = rng.uniform(0, 10, 60)
ys = ((xs > 5) ^ (rng.random(60) < 0.15)).astype(int)     # a clean rule with 15% label noise
for depth in [1, 6]:
    tree = grow(xs, ys, depth)
    train_acc = np.mean([predict_one(tree, v) == t for v, t in zip(xs, ys)])
    print(f"depth {depth}: training accuracy {train_acc:.2f}")
```

The deeper tree fits the training data more closely, but that fit includes the noise. Judge depth on held-out data, not on training accuracy.

> **In the wild:** scikit-learn's `DecisionTreeClassifier(max_depth=3)` grows the same kind of tree, and `sklearn.tree.plot_tree` draws it.

```python
# Static: run this on your own machine with scikit-learn installed
from sklearn.tree import DecisionTreeClassifier

model = DecisionTreeClassifier(max_depth=3).fit(xs.reshape(-1, 1), ys)
print(model.score(xs.reshape(-1, 1), ys))
```

## Challenge: the Gini impurity

```python exercise id=gini-impurity title="Gini impurity of a group"
import numpy as np

# TODO: `gini(labels)` returns 1 − Σ p_k² for the labels, where p_k is the share of each class. An empty group
# has impurity 0.
def gini(labels):
    ...
--- solution
import numpy as np

def gini(labels):
    labels = np.asarray(labels)
    if labels.size == 0:
        return 0.0
    _, counts = np.unique(labels, return_counts=True)
    p = counts / labels.size
    return float(1 - np.sum(p ** 2))
--- test
result = gini([0, 0, 1, 1])
assert result is not None, "Replace the `...` in `gini` with code that returns the impurity."
assert abs(result - 0.5) < 1e-9, f"Two classes split evenly give 1 − (0.5² + 0.5²) = 0.5, but you returned {result!r}."
assert abs(gini([1, 1, 1])) < 1e-9, "A pure group has impurity 0."
assert abs(gini([0, 0, 0, 1]) - 0.375) < 1e-9, "With shares 3/4 and 1/4 the impurity is 1 − (9/16 + 1/16) = 0.375."
assert gini([]) == 0.0, "An empty group has impurity 0."
--- hint
Count how often each class appears, turn the counts into shares, square them, sum them, and subtract from 1.
--- hint
`_, counts = np.unique(labels, return_counts=True)`, `p = counts / labels.size`, `return float(1 - np.sum(p ** 2))`.
```

## Challenge: the best threshold

```python exercise id=best-threshold title="The best split on one feature"
import numpy as np

def gini(labels):
    labels = np.asarray(labels)
    if labels.size == 0:
        return 0.0
    _, counts = np.unique(labels, return_counts=True)
    p = counts / labels.size
    return float(1 - np.sum(p ** 2))

# TODO: `best_threshold(x, y)` returns the threshold that minimizes the weighted Gini impurity of the two
# sides. Try the midpoint between each pair of neighbouring distinct values of x. Rows with x <= t go left.
# If several thresholds tie, return the smallest.
def best_threshold(x, y):
    ...
--- solution
import numpy as np

def gini(labels):
    labels = np.asarray(labels)
    if labels.size == 0:
        return 0.0
    _, counts = np.unique(labels, return_counts=True)
    p = counts / labels.size
    return float(1 - np.sum(p ** 2))

def best_threshold(x, y):
    x = np.asarray(x, dtype=float)
    y = np.asarray(y)
    values = np.unique(x)
    best_t, best_score = None, np.inf
    for lo, hi in zip(values[:-1], values[1:]):
        t = (lo + hi) / 2
        left, right = y[x <= t], y[x > t]
        score = (len(left) * gini(left) + len(right) * gini(right)) / len(y)
        if score < best_score:
            best_t, best_score = t, score
    return best_t
--- test
x_t = np.array([1.0, 2.0, 3.0, 10.0, 11.0, 12.0])
y_t = np.array([0, 0, 0, 1, 1, 1])
result = best_threshold(x_t, y_t)
assert result is not None, "Replace the `...` in `best_threshold` with code that returns the threshold."
assert np.isclose(result, 6.5), f"The classes separate perfectly between 3 and 10, so the threshold should be their midpoint 6.5, but you returned {result!r}."
x2 = np.array([5.0, 1.0, 4.0, 2.0])
y2 = np.array([1, 0, 1, 0])
assert np.isclose(best_threshold(x2, y2), 3.0), "Values up to 2 are class 0 and from 4 are class 1, so the best split is at 3."
--- hint
Sort out the distinct values with `np.unique`, then loop over neighbouring pairs. The midpoint of a pair is `(lo + hi) / 2`.
--- hint
For each midpoint compute the weighted impurity of `y[x <= t]` and `y[x > t]`, and remember the smallest.
```

## Debug the impurity formula

This Gini function is meant to measure impurity, but it always returns zero, so every split looks equally good.

```python debug id=gini-formula title="Square the shares"
import numpy as np

labels = np.array([0, 0, 1, 1])
_, counts = np.unique(labels, return_counts=True)
p = counts / labels.size
impurity = 1 - np.sum(p)            # bug: the shares must be squared
print("impurity:", impurity)
--- solution
import numpy as np

labels = np.array([0, 0, 1, 1])
_, counts = np.unique(labels, return_counts=True)
p = counts / labels.size
impurity = 1 - np.sum(p ** 2)
print("impurity:", impurity)
--- test
assert abs(impurity - 0.5) < 1e-9, f"The Gini impurity of an even split is 0.5, but this gives {impurity}. The formula is 1 − Σ p², with the shares squared."
--- hint
The shares always add up to one, so `1 - sum(p)` is always zero.
--- hint
Square each share before summing: `1 - np.sum(p ** 2)`.
```

## Predict the impurity

```python predict id=predict-gini title="What is the Gini impurity of [0, 1]?"
import numpy as np
labels = np.array([0, 1])
_, counts = np.unique(labels, return_counts=True)
p = counts / labels.size
print(round(float(1 - np.sum(p ** 2)), 2))
--- options
* 0.5
0.0
1.0
0.25
--- explain
Each class has share one half, so the impurity is 1 − (0.25 + 0.25) = 0.5. An even split is as impure as a two-class group can be.
```

## Recap

- A tree splits on the threshold that most reduces impurity, and repeats on each side.
- Gini impurity is $1 - \sum p_k^2$: zero for a pure group, and largest for an even mix.
- Limit depth, or the tree memorizes noise. Judge depth on held-out data.
- Trees need no scaling and are easy to explain, but they are unstable on their own.

**Up next:** random forests. Combining many trees fixes the instability.
