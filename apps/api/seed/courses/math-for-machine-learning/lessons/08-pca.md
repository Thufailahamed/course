Imagine a dataset with fifty features: sensor readings, pixel values, survey answers. Most of its variation usually lives in a handful of directions, because many features move together. **Principal component analysis** (PCA) finds those directions. It rotates the data onto new axes, ordered by how much variation each one captures, so you can keep the first few and drop the rest with the least loss. It is the standard first step for visualizing high-dimensional data, compressing it and cleaning it before a model.

By the end of this lesson you will center data, compute a covariance matrix, find principal components with an eigendecomposition and with the SVD, and explain how much variance each component keeps.

## Start with centered data

PCA looks for directions of variation, so it measures everything relative to the average. The first step is to **center** the data: subtract each column's mean, so every feature has mean zero.

```python run
import numpy as np

rng = np.random.default_rng(42)
t = rng.normal(0, 1, 300)
# Two correlated features: the second moves with the first, plus some noise
X = np.column_stack([t * 2.0 + 10, t * 1.0 + rng.normal(0, 0.3, 300) + 5])

Xc = X - X.mean(axis=0)
print("column means before:", X.mean(axis=0).round(2))
print("column means after centering are zero:", np.abs(Xc.mean(axis=0)).max() < 1e-12)
```

## The covariance matrix

The **covariance matrix** $C$ collects how every pair of features varies together. For centered data $X_c$ with $n$ rows,

$$
C = \frac{X_c^\top X_c}{n - 1}
$$

The diagonal holds each feature's variance, and the off-diagonal entries hold the covariances. $C$ is symmetric, so `eigh` applies.

```python run
n = len(X)
C = Xc.T @ Xc / (n - 1)
print(C.round(2))
print("matches np.cov:", np.allclose(C, np.cov(X, rowvar=False)))
```

## Principal components are eigenvectors of the covariance

The eigenvector with the largest eigenvalue points along the direction of greatest variance. That is the **first principal component**. Its eigenvalue is the variance of the data projected onto it. Let's plot the data with that direction drawn on top.

```python run
import matplotlib.pyplot as plt

vals, vecs = np.linalg.eigh(C)       # eigh sorts ascending, so the last one is the largest
top = vecs[:, -1]

fig, ax = plt.subplots()
ax.scatter(Xc[:, 0], Xc[:, 1], s=8, alpha=0.5)
ax.arrow(0, 0, *(top * 2 * np.sqrt(vals[-1])), color="tab:red", width=0.05, length_includes_head=True)
ax.set_aspect("equal"); ax.grid(alpha=0.3)
ax.set_title("Centered data and its first principal direction")
plt.show()
```

The red arrow follows the long axis of the cloud. Once you know the direction, the data can be projected onto it to give one coordinate per sample.

```python run
explained = vals[::-1] / vals.sum()
print("explained variance ratio, largest first:", explained.round(3))

Z = Xc @ top                          # coordinates along the first component
print("variance of the projection:", round(Z.var(ddof=1), 3), "| top eigenvalue:", round(vals[-1], 3))
```

The projection's variance matches the top eigenvalue exactly, and the ratio tells you what fraction of the total variation one coordinate keeps. Here one number captures almost all of it.

## The same answer from the SVD

In practice PCA is computed with the SVD of the centered data, which avoids forming the covariance matrix. The right singular vectors (rows of `Vt`) are the principal components, and the singular values give the variances: $\lambda_i = \sigma_i^2 / (n - 1)$.

```python run
U, S, Vt = np.linalg.svd(Xc, full_matrices=False)
print("SVD variances:", np.round(S**2 / (n - 1), 3))
print("top component matches (up to sign):", np.isclose(abs(Vt[0] @ top), 1.0))
```

> **Pitfall:** eigenvectors and singular vectors are only defined up to a sign. Flipping a component's sign gives an equally valid PCA. Compare directions with `abs(...)`, and never test against a specific sign.

> **In the wild:** scikit-learn's `PCA` uses exactly this route: centering, then an SVD of the data matrix.

## Challenges

```python exercise id=center title="Center each column"
# TODO: `center(X)` should subtract each column's mean from that column.
def center(X):
    ...
--- solution
def center(X):
    X = np.asarray(X, dtype=float)
    return X - X.mean(axis=0)
--- test
rng = np.random.default_rng(9)
M = rng.normal(loc=[5.0, -3.0, 0.5], scale=[1.0, 2.0, 3.0], size=(40, 3))
result = center(M)
assert result is not None, "Replace the `...` in `center` with code that returns the centered matrix."
assert np.shape(result) == (40, 3), "Centering should keep the shape of the matrix."
assert np.allclose(result.mean(axis=0), 0.0), "Every column of the result should have mean zero."
assert np.allclose(result, M - M.mean(axis=0)), "Each column should have its own mean subtracted."
--- hint
Each column's mean comes from `X.mean(axis=0)`. Subtracting a vector of length d from a matrix with d columns broadcasts it across every row.
--- hint
`return X - X.mean(axis=0)`.
```

```python exercise id=pca-from-svd title="Principal component analysis with the SVD"
# TODO: `pca(X, k)` should return (Z, components):
#   components: the top k principal directions as rows, sorted by variance, shape (k, d)
#   Z: the centered data projected onto those directions, shape (n, k)
def pca(X, k):
    ...
--- solution
def pca(X, k):
    X = np.asarray(X, dtype=float)
    Xc = X - X.mean(axis=0)
    _, _, Vt = np.linalg.svd(Xc, full_matrices=False)
    components = Vt[:k]
    return Xc @ components.T, components
--- test
rng = np.random.default_rng(7)
base = rng.normal(size=(200, 1))
X = np.hstack([3 * base, base + rng.normal(0, 0.2, (200, 1)), rng.normal(0, 0.5, (200, 2))])
out = pca(X, 2)
assert out is not None, "Replace the `...` in `pca` with code that returns (Z, components)."
Z, components = out
assert np.shape(Z) == (200, 2), f"Z should have shape (200, 2), but it has {np.shape(Z)}."
assert np.shape(components) == (2, 4), f"components should have shape (2, 4), but it has {np.shape(components)}."
assert np.allclose(components @ components.T, np.eye(2)), "The principal directions should be unit length and perpendicular to each other."
eig = np.sort(np.linalg.eigvalsh(np.cov(X, rowvar=False)))[::-1][:2]
assert np.allclose(Z.var(axis=0, ddof=1), eig, rtol=1e-6), "The variance of each column of Z should match the top two eigenvalues of the covariance matrix, largest first."
--- hint
Center `X`, take the SVD with `full_matrices=False`, and keep the first `k` rows of `Vt` as the components.
--- hint
The projection is `Xc @ components.T`. Use the centered data, not the original `X`.
```

```python debug uncentered-cov id=uncentered-cov title="Covariance that ignores the mean"
rng = np.random.default_rng(3)
X = rng.normal(loc=[5.0, -2.0], scale=[2.0, 0.5], size=(500, 2))

# Covariance matrix of the two features
n = X.shape[0]
cov = X.T @ X / (n - 1)
print(np.round(cov, 2))
print("matches np.cov:", np.allclose(cov, np.cov(X, rowvar=False)))
--- solution
rng = np.random.default_rng(3)
X = rng.normal(loc=[5.0, -2.0], scale=[2.0, 0.5], size=(500, 2))

# Covariance matrix of the two features
n = X.shape[0]
Xc = X - X.mean(axis=0)
cov = Xc.T @ Xc / (n - 1)
print(np.round(cov, 2))
print("matches np.cov:", np.allclose(cov, np.cov(X, rowvar=False)))
--- test
assert np.allclose(cov, np.cov(X, rowvar=False)), f"cov should match np.cov, but the first row is {np.round(cov[0], 2).tolist()} and np.cov gives {np.round(np.cov(X, rowvar=False)[0], 2).tolist()}."
--- hint
Compare the diagonal: the variance of the first feature should be near 4, because its standard deviation is 2. The formula you wrote adds in the mean, which is about 5, and inflates it.
--- hint
Center the data first: subtract the column means, then use the same formula on the centered matrix.
```

```python predict id=predict-full-correlation title="One direction is enough"
t = np.linspace(-1, 1, 50)
X = np.column_stack([t, 2 * t])          # the second feature is exactly twice the first
Xc = X - X.mean(axis=0)
vals = np.linalg.eigvalsh(Xc.T @ Xc)
print(round(vals.max() / vals.sum(), 3))
--- options
0.5
* 1.0
0.8
0.25
--- explain
Every sample lies on the line `y = 2x`, so a single component captures all of the variation. The second eigenvalue is zero (up to rounding), so the top component explains everything.
```

```python predict id=predict-var title="Variance of centered data"
x = np.array([1.0, 2.0, 3.0, 4.0])
print(round(np.var(x - x.mean()), 2))
--- options
0.5
* 1.25
1.0
2.5
--- explain
The mean is 2.5 and the centered values are -1.5, -0.5, 0.5, 1.5. Their squares average to `(2.25 + 0.25 + 0.25 + 2.25) / 4 = 1.25`. NumPy's `np.var` divides by n by default, which is what this calculation does.
```

## Recap

- PCA centers the data, then finds the directions of greatest variance.
- The covariance matrix is $C = X_c^\top X_c / (n-1)$. Its eigenvectors are the principal components, and its eigenvalues are their variances.
- The SVD of the centered data gives the same components more directly, and is what libraries use.
- Components are defined only up to sign. Compare them with `abs(...)`.
- Keeping the top $k$ components keeps the most variance any $k$ directions can.

**Up next:** calculus. PCA tells you which directions matter. Calculus tells a model how to move, which is how it learns.
