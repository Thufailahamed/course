You've spent this course learning NumPy one tool at a time: indexing, broadcasting, reductions along an axis, boolean masks. In this project they come together. You'll build **k-means clustering**, one of the most widely used algorithms in machine learning, from scratch in about twenty lines of NumPy.

k-means takes a cloud of unlabelled points and discovers groups in it. It powers customer segmentation, image color compression, document grouping and the "vector quantization" inside modern speech and image models. scikit-learn's `KMeans` does exactly what you're about to write, plus a few speed tricks.

> **How this project works:** each stage is a challenge that builds one piece of the algorithm. Challenges run in their own namespace, so each one restates the helpers it needs from earlier stages. At the end you'll assemble everything into a complete `kmeans` function and watch it find the clusters.

```python setup
rng = np.random.default_rng(42)
true_centers = np.array([[0.0, 0.0], [5.0, 5.0], [0.0, 6.0]])
X = np.vstack([c + rng.normal(scale=0.8, size=(60, 2)) for c in true_centers])
```

## Meet the data

The lesson setup created `X`: 180 points in 2-D, secretly drawn around three centers. k-means won't get the centers. It has to find them.

```python run
import matplotlib.pyplot as plt

print("X shape:", X.shape)
print("first 3 points:\n", X[:3].round(2))

plt.scatter(X[:, 0], X[:, 1], s=14, color="0.35")
plt.title("180 unlabelled points")
plt.axis("equal")
plt.show()
```

To your eye there are obviously three groups. The goal is to make the computer see them too.

## The algorithm in one sentence

Pick $k$ centroids, then repeat two steps until nothing changes: **assign** every point to its nearest centroid, then **move** every centroid to the mean of its points.

Each round lowers the *inertia*, the total squared distance from points to their centroids:

$$
J = \sum_{i=1}^{n} \lVert x_i - \mu_{c_i} \rVert^2
$$

Here $x_i$ is a point, $c_i$ is the cluster it's assigned to, and $\mu_{c_i}$ is that cluster's centroid. The assign step picks the best $c_i$ for fixed centroids; the move step picks the best $\mu$ for fixed assignments. Neither step can increase $J$, so the algorithm always converges.

## Stage 1: choose starting centroids

The simplest good initialization is to pick $k$ **distinct** data points at random. `rng.choice` can sample indices without replacement:

```python run
demo_rng = np.random.default_rng(0)
idx = demo_rng.choice(10, size=4, replace=False)
print("4 distinct indices out of 10:", idx)
print("as rows of X:\n", X[idx].round(2))
```

```python exercise id=init-centroids title="Pick k random starting centroids"
def init_centroids(X, k, seed=0):
    """Return k distinct rows of X, chosen at random, as a (k, d) array."""
    rng = np.random.default_rng(seed)
    # TODO: pick k distinct row indices with rng.choice, then index X with them
    idx = ...
    return ...

centroids = init_centroids(X, 3, seed=0)
print(centroids)
--- solution
def init_centroids(X, k, seed=0):
    """Return k distinct rows of X, chosen at random, as a (k, d) array."""
    rng = np.random.default_rng(seed)
    idx = rng.choice(len(X), size=k, replace=False)
    return X[idx]

centroids = init_centroids(X, 3, seed=0)
print(centroids)
--- test
C = init_centroids(X, 3, seed=0)
assert C is not ..., "init_centroids returns `...`. Replace the placeholders with your code."
assert isinstance(C, np.ndarray), f"init_centroids should return a NumPy array, not {type(C).__name__}."
assert C.shape == (3, 2), f"With k=3 on 2-D data the result should have shape (3, 2), but it has {C.shape}."
fresh = np.arange(40.0).reshape(20, 2)
C5 = init_centroids(fresh, 5, seed=1)
assert C5.shape == (5, 2), f"init_centroids(fresh, 5) should have shape (5, 2), got {C5.shape}. Are you using `k`?"
rows = {tuple(r) for r in fresh}
assert all(tuple(r) in rows for r in C5), "Every centroid should be an actual row of X."
assert len({tuple(r) for r in C5}) == 5, "The k starting centroids must be distinct rows. Sample without replacement."
assert np.array_equal(init_centroids(fresh, 5, seed=1), C5), "The same seed should always give the same centroids. Build the generator from `seed`."
assert not np.array_equal(init_centroids(fresh, 5, seed=2), C5), "Different seeds should usually give different centroids. Are you ignoring `seed`?"
--- hint
You need `k` distinct integers between `0` and `len(X) - 1`. Then use them as a fancy index into `X`.
--- hint
`rng.choice(n, size=k, replace=False)` returns `k` distinct indices from `range(n)`, and `X[idx]` picks those rows.
```

## Stage 2: every distance at once

The assign step needs the distance from **every point to every centroid**: an `(n, k)` table. A double loop would work, but it's slow and un-NumPy-like. Broadcasting does it in one expression:

- `X[:, None, :]` has shape `(n, 1, d)`: each point on its own "row".
- `C[None, :, :]` has shape `(1, k, d)`: all centroids along a new middle axis.
- Their difference broadcasts to `(n, k, d)`: every point minus every centroid.

Square, then sum over the last axis `d` to get squared Euclidean distances. Here it is on a tiny example you can check by hand:

```python run
P = np.array([[0.0, 0.0], [3.0, 4.0]])      # 2 points
Q = np.array([[0.0, 0.0], [3.0, 0.0], [0.0, 4.0]])  # 3 centroids

diff = P[:, None, :] - Q[None, :, :]
print("diff shape:", diff.shape)
(diff ** 2).sum(axis=2)
```

Row 1 says the point `(3, 4)` is at squared distance 25 from the origin, 16 from `(3, 0)` and 9 from `(0, 4)`. That's exactly $3^2+4^2$, $4^2$ and $3^2$.

```python predict id=predict-diff-shape title="What shape is the broadcast difference?"
X = np.zeros((180, 2))
C = np.zeros((3, 2))
diff = X[:, None, :] - C[None, :, :]
print(diff.shape)
--- options
(180, 2)
* (180, 3, 2)
(3, 180, 2)
(180, 3)
--- explain
`(180, 1, 2)` and `(1, 3, 2)` broadcast axis by axis: `180` vs `1` gives `180`, `1` vs `3` gives `3`, and `2` vs `2` gives `2`. The squared distances only become `(180, 3)` after you **sum over the last axis**.
```

```python exercise id=squared-distances title="Compute all point-to-centroid distances"
def squared_distances(X, C):
    """Return an (n, k) array: the squared distance from each point to each centroid."""
    # TODO: broadcast X to (n, 1, d) and C to (1, k, d), subtract, square, sum over d
    diff = ...
    return ...

D = squared_distances(X, X[:3])
print(D)
--- solution
def squared_distances(X, C):
    """Return an (n, k) array: the squared distance from each point to each centroid."""
    diff = X[:, None, :] - C[None, :, :]
    return (diff ** 2).sum(axis=2)

D = squared_distances(X, X[:3])
print(D)
--- test
rng_t = np.random.default_rng(7)
P = rng_t.normal(size=(9, 3))
Q = rng_t.normal(size=(4, 3))
D = squared_distances(P, Q)
assert D is not ..., "squared_distances returns `...`. Replace the placeholders with your code."
assert isinstance(D, np.ndarray), f"squared_distances should return a NumPy array, not {type(D).__name__}."
assert D.shape == (9, 4), f"For 9 points and 4 centroids the result should be (9, 4), not {D.shape}. Which axis are you summing over?"
expected = np.array([[((p - q) ** 2).sum() for q in Q] for p in P])
assert np.allclose(D, expected), "The shape is right but some distances are wrong. Square the differences before summing, and sum over the last axis."
self_d = squared_distances(X, X[:3])
assert np.allclose(self_d[[0, 1, 2], [0, 1, 2]], 0), "A point's distance to itself should be 0."
--- hint
Insert new axes with `None`: `X[:, None, :]` and `C[None, :, :]`. Subtracting them broadcasts to `(n, k, d)`.
--- hint
After subtracting, square with `** 2` and reduce the coordinate axis with `.sum(axis=2)` (or `axis=-1`).
```

## Stage 3: assign each point to its nearest centroid

With the `(n, k)` distance table, the nearest centroid for each point is the **column** with the smallest value in that point's **row**. That's `argmin` along `axis=1`:

```python run
D = np.array([[4.0, 1.0, 9.0],
              [0.5, 5.0, 2.0],
              [7.0, 6.0, 3.0]])
print("nearest centroid per point:", D.argmin(axis=1))
print("smallest distance per point:", D.min(axis=1))
```

```python predict id=predict-argmin title="Which labels come out?"
D = np.array([[4, 1, 9],
              [0, 5, 2]])
print(D.argmin(axis=0))
--- options
[1 0]
* [1 0 1]
[0 1 0]
[1 0 2]
--- explain
`axis=0` reduces **down the rows**, so you get one answer per **column**: the row index of each column's minimum. That's the wrong question for k-means, where you want one label per point (row), so you'd use `axis=1`.
```

```python exercise id=assign-labels title="Assign points to their nearest centroid"
def squared_distances(X, C):  # from Stage 2
    return ((X[:, None, :] - C[None, :, :]) ** 2).sum(axis=2)

def assign(X, C):
    """Return an (n,) integer array: the index of the nearest centroid for each point."""
    D = squared_distances(X, C)
    # TODO: for every row of D, find the column with the smallest distance
    return ...

labels = assign(X, X[:3])
print(labels)
--- solution
def squared_distances(X, C):  # from Stage 2
    return ((X[:, None, :] - C[None, :, :]) ** 2).sum(axis=2)

def assign(X, C):
    """Return an (n,) integer array: the index of the nearest centroid for each point."""
    D = squared_distances(X, C)
    return D.argmin(axis=1)

labels = assign(X, X[:3])
print(labels)
--- test
C = np.array([[0.0, 0.0], [10.0, 10.0]])
P = np.array([[1.0, 1.0], [9.0, 8.0], [-2.0, 0.5], [6.0, 6.0]])
labels = assign(P, C)
assert labels is not ..., "assign returns `...`. Replace the placeholder with your code."
labels = np.asarray(labels)
assert labels.shape == (4,), f"assign should return one label per point, shape (4,), not {labels.shape}. Which axis did you reduce?"
assert np.issubdtype(labels.dtype, np.integer), f"Labels should be integer centroid indices, not {labels.dtype}. Did you use min instead of argmin?"
assert labels.tolist() == [0, 1, 0, 1], f"Expected labels [0, 1, 0, 1] for the test points but got {labels.tolist()}."
C3 = np.array([[0.0, 0.0], [5.0, 5.0], [0.0, 6.0]])
assert np.array_equal(assign(X, C3), squared_distances(X, C3).argmin(axis=1)), "assign gives different labels than the nearest centroid on the lesson data."
--- hint
You want the *position* of the minimum, not the minimum value itself.
--- hint
`D.argmin(axis=1)` returns, for each row, the column index of its smallest entry.
```

## Stage 4: move the centroids

Each centroid moves to the **mean of the points assigned to it**. A boolean mask selects one cluster's points, and `.mean(axis=0)` averages them coordinate by coordinate:

```python run
labels = np.array([0, 1, 0, 1, 1])
pts = np.array([[0.0, 0.0], [10.0, 0.0], [2.0, 2.0], [12.0, 2.0], [11.0, 4.0]])

cluster_1 = pts[labels == 1]
print("points in cluster 1:\n", cluster_1)
print("their centroid:", cluster_1.mean(axis=0))
```

```python debug id=centroid-mean-bug title="The centroids collapse onto the diagonal"
X_small = np.array([[0.0, 0.0], [2.0, 0.0], [10.0, 4.0], [12.0, 6.0]])
labels = np.array([0, 0, 1, 1])
k = 2

centroids = np.zeros((k, 2))
for j in range(k):
    centroids[j] = X_small[labels == j].mean()

print(centroids)
--- solution
X_small = np.array([[0.0, 0.0], [2.0, 0.0], [10.0, 4.0], [12.0, 6.0]])
labels = np.array([0, 0, 1, 1])
k = 2

centroids = np.zeros((k, 2))
for j in range(k):
    centroids[j] = X_small[labels == j].mean(axis=0)

print(centroids)
--- test
assert centroids.shape == (2, 2), f"centroids should still have shape (2, 2), got {centroids.shape}."
assert not np.allclose(centroids[:, 0], centroids[:, 1]), "Both coordinates of each centroid are still identical. Each coordinate needs its own mean."
assert np.allclose(centroids, [[1.0, 0.0], [11.0, 5.0]]), f"Each centroid should be the coordinate-wise mean of its points. Got {centroids.tolist()}."
--- hint
Run it and look at the output: both numbers in each row are the same. What is `.mean()` averaging over when you don't tell it an axis?
--- hint
Without an `axis`, `.mean()` flattens the array and returns a single number, which then broadcasts into both coordinates. Average each column separately instead.
```

Real data has one more wrinkle: a centroid can end up with **no points at all**, especially with a bad initialization. The mean of an empty array is `nan` (with a warning), and a `nan` centroid poisons every later step. The standard fix is to leave an empty cluster's centroid where it was.

```python exercise id=update-centroids title="Update centroids, safely"
def update_centroids(X, labels, old_centroids):
    """Return a (k, d) array whose row j is the mean of the points labelled j.

    If cluster j has no points, keep old_centroids[j] instead.
    """
    k = len(old_centroids)
    new = old_centroids.copy()
    # TODO: for each cluster j, select its points with a mask and, if any, store their mean in new[j]
    ...
    return new
--- solution
def update_centroids(X, labels, old_centroids):
    """Return a (k, d) array whose row j is the mean of the points labelled j.

    If cluster j has no points, keep old_centroids[j] instead.
    """
    k = len(old_centroids)
    new = old_centroids.copy()
    for j in range(k):
        members = X[labels == j]
        if len(members) > 0:
            new[j] = members.mean(axis=0)
    return new
--- test
P = np.array([[0.0, 0.0], [2.0, 2.0], [10.0, 0.0], [12.0, 2.0]])
old = np.array([[1.0, 1.0], [5.0, 5.0], [100.0, 100.0]])
lab = np.array([0, 0, 1, 1])
new = update_centroids(P, lab, old)
assert isinstance(new, np.ndarray), f"update_centroids should return a NumPy array, not {type(new).__name__}."
assert new.shape == (3, 2), f"The result should have one row per centroid, shape (3, 2), got {new.shape}."
assert not np.isnan(new).any(), "The result contains NaN. That happens when you average an empty cluster; skip clusters with no points."
assert np.allclose(new[1], [11.0, 1.0]), f"Row 1 should be the mean of the points labelled 1, but it is {new[1].tolist()}."
assert np.allclose(new[0], [1.0, 1.0]), f"Row 0 should be the mean of the points labelled 0, but it is {new[0].tolist()}."
assert np.allclose(new[2], [100.0, 100.0]), "Cluster 2 has no points, so it should keep its old centroid."
assert np.allclose(old, [[1.0, 1.0], [5.0, 5.0], [100.0, 100.0]]), "old_centroids was modified. Write into the copy, `new`, instead."
--- hint
Loop `for j in range(k):` and build a mask with `labels == j` to select that cluster's points.
--- hint
`members = X[labels == j]`. Only when `len(members) > 0`, set `new[j] = members.mean(axis=0)`.
```

## Stage 5: put it all together

Now assemble the full algorithm. The helpers from Stages 2 and 4 are provided; you write the loop.

**Stopping rule:** if the new centroids are (almost) identical to the old ones, assignments can't change any more, so stop early. `np.allclose(new_centroids, centroids)` is the right test; never compare floats with `==`.

```python exercise id=kmeans-full title="Write the complete k-means algorithm"
def squared_distances(X, C):  # Stage 2
    return ((X[:, None, :] - C[None, :, :]) ** 2).sum(axis=2)

def update_centroids(X, labels, old_centroids):  # Stage 4
    new = old_centroids.copy()
    for j in range(len(old_centroids)):
        members = X[labels == j]
        if len(members) > 0:
            new[j] = members.mean(axis=0)
    return new

def kmeans(X, k, seed=0, max_iter=100):
    """Cluster X into k groups. Return (centroids, labels, inertia)."""
    rng = np.random.default_rng(seed)
    centroids = X[rng.choice(len(X), size=k, replace=False)]
    for _ in range(max_iter):
        # TODO 1: assign every point to its nearest centroid
        labels = ...
        # TODO 2: move each centroid to the mean of its points
        new_centroids = ...
        # TODO 3: stop (break) when the centroids no longer move
        ...
        centroids = new_centroids
    # TODO 4: inertia = sum of squared distances from each point to its own centroid
    inertia = ...
    return centroids, labels, inertia

C, labels, inertia = kmeans(X, 3)
print("centroids:\n", C)
print("inertia:", inertia)
--- solution
def squared_distances(X, C):  # Stage 2
    return ((X[:, None, :] - C[None, :, :]) ** 2).sum(axis=2)

def update_centroids(X, labels, old_centroids):  # Stage 4
    new = old_centroids.copy()
    for j in range(len(old_centroids)):
        members = X[labels == j]
        if len(members) > 0:
            new[j] = members.mean(axis=0)
    return new

def kmeans(X, k, seed=0, max_iter=100):
    """Cluster X into k groups. Return (centroids, labels, inertia)."""
    rng = np.random.default_rng(seed)
    centroids = X[rng.choice(len(X), size=k, replace=False)]
    for _ in range(max_iter):
        labels = squared_distances(X, centroids).argmin(axis=1)
        new_centroids = update_centroids(X, labels, centroids)
        if np.allclose(new_centroids, centroids):
            break
        centroids = new_centroids
    inertia = squared_distances(X, centroids).min(axis=1).sum()
    return centroids, labels, inertia

C, labels, inertia = kmeans(X, 3)
print("centroids:\n", C)
print("inertia:", inertia)
--- test
rng_t = np.random.default_rng(123)
centers = np.array([[0.0, 0.0], [8.0, 0.0], [4.0, 7.0], [-6.0, 6.0]])
P = np.vstack([c + rng_t.normal(scale=0.6, size=(40, 2)) for c in centers])
out = kmeans(P, 4, seed=3)
assert isinstance(out, tuple) and len(out) == 3, "kmeans should return a tuple: (centroids, labels, inertia)."
C, lab, inertia = out
assert C is not ... and lab is not ... and inertia is not ..., "kmeans still returns a `...` placeholder. Fill in every TODO."
C = np.asarray(C)
lab = np.asarray(lab)
assert C.shape == (4, 2), f"With k=4 the centroids should have shape (4, 2), got {C.shape}."
assert lab.shape == (160,), f"labels should hold one entry per point, shape (160,), got {lab.shape}."
D = ((P[:, None, :] - C[None, :, :]) ** 2).sum(axis=2)
assert np.array_equal(lab, D.argmin(axis=1)), "At convergence every label should point to its nearest centroid. Are the labels from the final assignment step?"
for j in range(4):
    if np.any(lab == j):
        assert np.allclose(C[j], P[lab == j].mean(axis=0), atol=1e-6), "At convergence each centroid should equal the mean of its points. Did the loop stop before converging?"
assert np.ndim(inertia) == 0, "inertia should be a single number."
assert np.isclose(float(inertia), D.min(axis=1).sum()), "inertia should be the sum of squared distances from each point to its assigned centroid."
C2, _, _ = kmeans(P, 4, seed=3)
assert np.allclose(C, C2), "Running kmeans twice with the same seed should give the same centroids."
--- hint
TODO 1 is Stage 3 in one line: `squared_distances(X, centroids).argmin(axis=1)`. TODO 2 is a call to `update_centroids`.
--- hint
For TODO 3: `if np.allclose(new_centroids, centroids): break`.
--- hint
For TODO 4: take the distance table for the final centroids, keep each row's smallest entry with `.min(axis=1)`, and add them all up.
```

## Watch it work

Here's a compact reference implementation that also records the centroids after every iteration, so you can watch them travel. Compare it with yours.

```python run
import matplotlib.pyplot as plt

def kmeans_history(X, k, seed=0, max_iter=100):
    rng = np.random.default_rng(seed)
    C = X[rng.choice(len(X), size=k, replace=False)]
    history = [C]
    for _ in range(max_iter):
        labels = ((X[:, None] - C[None]) ** 2).sum(-1).argmin(1)
        new = np.array([X[labels == j].mean(0) if np.any(labels == j) else C[j] for j in range(k)])
        history.append(new)
        if np.allclose(new, C):
            break
        C = new
    return C, labels, np.array(history)

C, labels, hist = kmeans_history(X, 3, seed=5)
plt.scatter(X[:, 0], X[:, 1], c=labels, s=14, cmap="viridis", alpha=0.7)
for j in range(3):
    plt.plot(hist[:, j, 0], hist[:, j, 1], "k.--", lw=1)
plt.scatter(C[:, 0], C[:, 1], marker="X", s=180, c="crimson", edgecolor="white", zorder=3)
plt.title(f"k-means converged in {len(hist) - 1} iterations")
plt.axis("equal")
plt.show()
print("found centers:\n", C[np.argsort(C[:, 0] + C[:, 1])].round(2))
```

The dashed lines trace each centroid's journey from its random start to the center of its cluster. Compare the found centers with `true_centers` from the setup: `[0, 0]`, `[0, 6]` and `[5, 5]`.

> **Pitfall:** k-means only finds a *local* optimum. An unlucky start can put two centroids in the same blob. In practice you run it several times with different seeds and keep the result with the lowest inertia. scikit-learn does this for you (`n_init`), and it also uses a smarter start called **k-means++**.

## How many clusters?

k-means needs you to choose $k$. A classic heuristic is the **elbow method**: plot the best inertia for each $k$ and look for the point where adding clusters stops helping much.

```python run
import matplotlib.pyplot as plt

ks = range(1, 8)
best = []
for k in ks:
    runs = [kmeans_history(X, k, seed=s)[0] for s in range(5)]
    inertias = [((X[:, None] - C[None]) ** 2).sum(-1).min(1).sum() for C in runs]
    best.append(min(inertias))

plt.plot(list(ks), best, "o-")
plt.xlabel("k")
plt.ylabel("inertia (best of 5 seeds)")
plt.title("The elbow is at k = 3")
plt.show()
print(np.round(best, 1))
```

Inertia always falls as $k$ grows (with $k = n$ it would be 0), but the drop flattens sharply after $k = 3$. That bend is the elbow.

> **In the wild:** the broadcasting distance trick you wrote in Stage 2 is everywhere: nearest-neighbor search, attention scores in transformers, and the vector quantizers inside audio codecs all compute "every item against every item" tables the same way. For very large `n`, libraries expand $\lVert x - \mu \rVert^2 = \lVert x \rVert^2 - 2\,x\cdot\mu + \lVert \mu \rVert^2$ so the middle term becomes a single matrix multiply and the `(n, k, d)` array is never built.

## Recap

- k-means alternates two steps, **assign** and **move**, and each one lowers the inertia $J$.
- Broadcasting `(n, 1, d)` against `(1, k, d)` builds every point-to-centroid distance without a Python loop.
- `argmin(axis=1)` turns a distance table into labels; boolean masks plus `.mean(axis=0)` turn labels into centroids.
- Guard against empty clusters, compare floats with `np.allclose`, and restart with several seeds.
- The elbow plot is a quick, practical way to choose $k$.

**Up next:** another core ML algorithm, linear regression, trained with gradient descent.
