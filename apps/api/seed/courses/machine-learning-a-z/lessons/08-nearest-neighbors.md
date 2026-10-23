The simplest classifier in this course has no training step at all. To predict a new point, find the $k$ training points closest to it and take a vote. This is the **k-nearest-neighbours** method, and it is a perfect place to learn the importance of distance and feature scale, because the whole method depends on them.

## Distance

The usual distance is Euclidean: the straight-line distance between two points, the square root of the sum of squared differences in each feature.

$$
d(a, b) = \sqrt{\sum_j (a_j - b_j)^2}
$$

```python run
import numpy as np

a = np.array([0.0, 0.0])
b = np.array([3.0, 4.0])
print("distance:", np.sqrt(np.sum((a - b) ** 2)))
print("same thing with np.linalg.norm:", np.linalg.norm(a - b))
```

## Classify by vote

```python run
rng = np.random.default_rng(0)
n = 80
cluster0 = rng.normal([0, 0], 0.8, (n // 2, 2))
cluster1 = rng.normal([2.5, 2.5], 0.8, (n // 2, 2))
X = np.vstack([cluster0, cluster1])
y = np.array([0] * (n // 2) + [1] * (n // 2))

def knn_predict_one(X, y, point, k):
    dist = np.linalg.norm(X - point, axis=1)
    nearest = y[np.argsort(dist)[:k]]
    return int(np.bincount(nearest).argmax())

for point in [np.array([0.2, -0.1]), np.array([2.0, 2.4]), np.array([1.2, 1.2])]:
    print(point, "→", knn_predict_one(X, y, point, k=5))
```

The point in the middle, at (1.2, 1.2), is close to both groups, and its label depends on which group is slightly nearer. It is a good illustration of why a boundary can be irregular.

## The choice of k

A small $k$ follows every local bump, while a large $k$ smooths the boundary. Neither extreme is right, and the best value is found on validation data.

```python run
test_points = rng.uniform(-1, 3.5, (200, 2))
truth = (test_points[:, 0] + test_points[:, 1] > 2.5).astype(int)
for k in [1, 5, 25]:
    pred = np.array([knn_predict_one(X, y, p, k) for p in test_points])
    print(f"k = {k:>2}: accuracy against the true rule {np.mean(pred == truth):.3f}")
```

## Scale matters

Distance treats every feature as equally important, so a feature measured in large units dominates. Standardizing each feature first puts them on the same footing.

```python run
income = rng.normal(40000, 8000, 60)          # in euros
age = rng.normal(40, 10, 60)                  # in years
point_a = np.array([40000.0, 30.0])
point_b = np.array([41000.0, 46.0])
print("raw distance between the two people:", round(np.linalg.norm(point_a - point_b), 1))
print("in raw units, the age difference of 16 years is invisible next to income")
```

> **Pitfall:** always scale features before a distance-based method. Fit the scaler on the training data only, as you will learn in the leakage lesson.

> **In the wild:** scikit-learn's `KNeighborsClassifier(n_neighbors=5)` does this for you, and a `Pipeline` with a `StandardScaler` in front of it applies the scaling correctly.

```python
# Static: run this on your own machine with scikit-learn installed
from sklearn.neighbors import KNeighborsClassifier

model = KNeighborsClassifier(n_neighbors=5).fit(X, y)
print(model.predict([[0.2, -0.1], [2.0, 2.4]]))
```

## Challenge: Euclidean distance

```python exercise id=euclidean title="Euclidean distance"
import numpy as np

# TODO: `euclidean(a, b)` returns the straight-line distance between two equal-length vectors.
def euclidean(a, b):
    ...
--- solution
import numpy as np

def euclidean(a, b):
    return float(np.sqrt(np.sum((np.asarray(a, dtype=float) - np.asarray(b, dtype=float)) ** 2)))
--- test
import numpy as np
result = euclidean([0.0, 0.0], [3.0, 4.0])
assert result is not None, "Replace the `...` in `euclidean` with code that returns the distance."
assert np.isclose(result, 5.0), f"The distance from the origin to (3, 4) is 5, but you returned {result!r}."
assert np.isclose(euclidean([1.0, 2.0, 3.0], [1.0, 2.0, 3.0]), 0.0), "The distance from a point to itself is 0."
assert np.isclose(euclidean([1.0], [-2.0]), 3.0), "In one dimension the distance is the absolute difference."
--- hint
Subtract the vectors, square each entry, add them, and take the square root.
--- hint
`np.sqrt(np.sum((a - b) ** 2))`.
```

## Challenge: k-nearest-neighbour prediction

```python exercise id=knn-predict title="Predict by majority among the nearest neighbours"
import numpy as np

# TODO: `knn_predict(X_train, y_train, point, k)` returns the most common label among the k training rows nearest
# to `point` (Euclidean distance). Labels are non-negative integers. A tie goes to the smaller label.
def knn_predict(X_train, y_train, point, k):
    ...
--- solution
import numpy as np

def knn_predict(X_train, y_train, point, k):
    X_train = np.asarray(X_train, dtype=float)
    y_train = np.asarray(y_train)
    dist = np.linalg.norm(X_train - np.asarray(point, dtype=float), axis=1)
    nearest = y_train[np.argsort(dist, kind="stable")[:k]]
    return int(np.bincount(nearest).argmax())
--- test
import numpy as np
X_t = np.array([[0.0], [1.0], [2.0], [10.0]])
y_t = np.array([0, 0, 1, 1])
result = knn_predict(X_t, y_t, np.array([1.2]), 3)
assert result is not None, "Replace the `...` in `knn_predict` with code that returns the label."
assert result == 0, "The three nearest points to 1.2 are 1, 0 and 2, with labels 0, 0 and 1, so the answer is 0."
assert knn_predict(X_t, y_t, np.array([9.0]), 1) == 1, "The nearest point to 9 is 10, labelled 1."
assert knn_predict(X_t, y_t, np.array([5.0]), 2) == 0, "The two nearest to 5 are 2 (label 1) and 1 (label 0), a tie that goes to the smaller label 0."
--- hint
Compute the distance from `point` to every training row, sort the row indices by distance, and take the first k labels.
--- hint
`np.argsort(dist)[:k]` gives the nearest rows. `np.bincount(labels).argmax()` picks the most common label.
```

## Debug the direction of the sort

This nearest-neighbour function is meant to pick the closest points, but it picks the farthest.

```python debug id=knn-sort title="Pick the nearest, not the farthest"
import numpy as np

X = np.array([[0.0], [1.0], [5.0], [9.0]])
y = np.array([0, 0, 1, 1])
point = np.array([0.5])
dist = np.linalg.norm(X - point, axis=1)
nearest = y[np.argsort(-dist)[:2]]        # bug: sorting by negative distance reverses the order
print("neighbour labels:", nearest)
--- solution
import numpy as np

X = np.array([[0.0], [1.0], [5.0], [9.0]])
y = np.array([0, 0, 1, 1])
point = np.array([0.5])
dist = np.linalg.norm(X - point, axis=1)
nearest = y[np.argsort(dist)[:2]]
print("neighbour labels:", nearest)
--- test
assert list(nearest) == [0, 0], f"The two nearest points to 0.5 are 0 and 1, both labelled 0, but the code gives {list(nearest)}. Sort by distance in ascending order."
--- hint
Smaller distances mean closer points. The default sort is ascending, so you do not need a minus sign.
--- hint
Use `np.argsort(dist)` without the negative.
```

## Predict the distance

```python predict id=predict-dist title="What is the distance between (1, 1) and (4, 5)?"
import numpy as np
print(np.linalg.norm(np.array([1.0, 1.0]) - np.array([4.0, 5.0])))
--- options
* 5.0
3.0
4.0
7.0
--- explain
The differences are 3 and 4, and the square root of 3² + 4² = 25 is 5. This is the familiar 3-4-5 right triangle.
```

## Recap

- k-nearest-neighbours predicts by a vote among the k closest training points, with no training step.
- Small k follows local detail, large k smooths. Choose k on validation data.
- Distances depend on scale, so standardize features, with the scaler fitted on training data only.
- scikit-learn's `KNeighborsClassifier` implements the method with fast search structures.

**Up next:** evaluation. Every method so far has been judged on training data, and that is not enough.
