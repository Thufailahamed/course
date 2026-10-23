Eigenvectors only make sense for square matrices, and even then they can be awkward: some matrices have complex eigenvalues, and some cannot be diagonalized at all. The **singular value decomposition** (SVD) has no such problems. Every matrix, of any shape, can be written as a rotation, a stretch along perpendicular axes, and another rotation. This is the most useful factorization in applied linear algebra. It powers image compression, denoising, recommender systems, latent semantic analysis and PCA.

By the end of this lesson you will decompose a matrix with NumPy, rebuild it from its pieces, approximate it with fewer components, and measure how much information each component carries.

## Any matrix: rotate, stretch, rotate

The SVD writes a matrix $A$ as

$$
A = U \Sigma V^\top
$$

where $U$ and $V$ have orthonormal columns (they are rotations or reflections), and $\Sigma$ is diagonal with non-negative entries $\sigma_1 \ge \sigma_2 \ge \cdots$, the **singular values**. In NumPy, `np.linalg.svd` returns $U$, the singular values as a vector, and $V^\top$ (called `Vt`).

```python run
import numpy as np

A = np.array([[2.0, 1.0],
              [0.0, 1.5]])

U, S, Vt = np.linalg.svd(A)
print("singular values:", S.round(3))
print("U:"); print(U.round(3))
print("Vt:"); print(Vt.round(3))

rebuilt = U @ np.diag(S) @ Vt
print("U @ diag(S) @ Vt equals A?", np.allclose(rebuilt, A))
```

The singular values tell you how strongly $A$ stretches space in its most important directions. Sorted from largest to smallest, the first one captures the most.

## Non-square matrices work too

Eigenvectors can't handle a $5 \times 3$ data matrix. The SVD can. With `full_matrices=False` you get the compact version, where $\Sigma$ has only as many singular values as the smaller dimension.

```python run
rng = np.random.default_rng(0)
X = rng.normal(size=(5, 3))      # 5 samples, 3 features

U, S, Vt = np.linalg.svd(X, full_matrices=False)
print("U:", U.shape, "| S:", S.shape, "| Vt:", Vt.shape)
print("rebuilt correctly?", np.allclose(U @ np.diag(S) @ Vt, X))
```

## Singular values measure energy

Squared singular values add up to the total squared size of the matrix (the Frobenius norm). So $\sigma_i^2 / \sum_j \sigma_j^2$ is the fraction of the matrix's "energy" that the $i$-th component carries.

```python run
energy = S**2 / np.sum(S**2)
print("share of energy per component:", np.round(energy, 3))
print("cumulative:                   ", np.round(np.cumsum(energy), 3))
```

> **Tip:** the number of nonzero singular values is the **rank** of the matrix: how many independent directions it really uses.

## Low-rank approximation: keep the big stretches

Suppose your data is a simple signal plus noise. The signal has low rank, so most of its information sits in a few singular values. Keeping only the top $k$ components throws away the noise and keeps the signal. This is the idea behind image compression and denoising.

```python run
rng = np.random.default_rng(0)
signal = rng.normal(size=(20, 2)) @ rng.normal(size=(2, 10))    # true rank 2
noisy = signal + 0.1 * rng.normal(size=(20, 10))

U, S, Vt = np.linalg.svd(noisy, full_matrices=False)
for k in [1, 2, 3, 10]:
    approx = (U[:, :k] * S[:k]) @ Vt[:k]
    print(f"{k:>2} components: error against the true signal = {np.linalg.norm(signal - approx):.3f}")
```

The error drops sharply up to rank 2, the true rank of the signal, and then barely improves. Keeping more components than that mostly adds noise back in. The Eckart–Young theorem says this truncated SVD is the **best** rank-$k$ approximation possible, in the least-squares sense.

## Charts of the singular values

A plot of the singular values, often called a scree plot, shows where the signal ends and the noise begins. The "elbow" marks the number of components worth keeping.

```python run
import matplotlib.pyplot as plt

fig, ax = plt.subplots()
ax.plot(range(1, len(S) + 1), S, "o-", label="singular values of the noisy matrix")
ax.axvline(2, color="tab:red", ls="--", label="true rank = 2")
ax.set_xlabel("component"); ax.set_ylabel("singular value")
ax.grid(alpha=0.3); ax.legend()
plt.show()
```

## Challenges

```python exercise id=rank-k title="Best rank-k approximation"
# TODO: `rank_k_approximation(A, k)` should return the best rank-k approximation of A,
# built from the top k singular values and vectors.
def rank_k_approximation(A, k):
    ...
--- solution
def rank_k_approximation(A, k):
    U, S, Vt = np.linalg.svd(A, full_matrices=False)
    return (U[:, :k] * S[:k]) @ Vt[:k]
--- test
rng = np.random.default_rng(4)
M = rng.normal(size=(6, 4))
approx = rank_k_approximation(M, 2)
assert approx is not None, "Replace the `...` in `rank_k_approximation` with code that returns a matrix."
assert np.shape(approx) == (6, 4), f"The approximation should have the same shape as A, (6, 4), but it has {np.shape(approx)}."
assert np.linalg.matrix_rank(approx) == 2, "The approximation should have rank exactly 2."
S = np.linalg.svd(M, compute_uv=False)
error = np.linalg.norm(M - approx, "fro")
assert np.isclose(error, np.sqrt(np.sum(S[2:] ** 2)), atol=1e-8), "The error should equal the energy of the discarded singular values."
--- hint
Compute the SVD with `np.linalg.svd(A, full_matrices=False)`, keep the first `k` columns of `U` and entries of `S`, and the first `k` rows of `Vt`.
--- hint
`(U[:, :k] * S[:k]) @ Vt[:k]` builds the approximation in one line.
```

```python exercise id=energy-kept title="How much energy survives?"
# TODO: `energy_kept(S, k)` should return the fraction of the total squared singular value
# energy that is kept by the first k singular values.
def energy_kept(S, k):
    ...
--- solution
def energy_kept(S, k):
    S = np.asarray(S, dtype=float)
    return np.sum(S[:k] ** 2) / np.sum(S ** 2)
--- test
result = energy_kept(np.array([3.0, 2.0, 1.0]), 1)
assert result is not None, "Replace the `...` in `energy_kept` with code that returns a fraction."
assert np.isclose(result, 9 / 14), f"With S = [3, 2, 1], keeping 1 value keeps 9/14 of the energy, but you returned {result!r}."
assert np.isclose(energy_kept(np.array([3.0, 2.0, 1.0]), 2), 13 / 14), "Keeping 2 values keeps 13/14 of the energy."
assert np.isclose(energy_kept(np.array([5.0, 0.5]), 2), 1.0), "Keeping every value keeps all of the energy."
--- hint
The total energy is the sum of the squared singular values. The kept energy is the same sum over the first `k` values only.
--- hint
Square the values with `S ** 2`, then divide the sum of the first k by the sum of all of them.
```

```python debug svd-rebuild id=svd-rebuild title="Rebuild the matrix from its pieces"
A = np.array([[4.0, 0.0, 2.0],
              [1.0, 3.0, 0.0]])
U, S, Vt = np.linalg.svd(A, full_matrices=False)

# Rebuild A from its three pieces
V = Vt.T
rebuilt = U @ np.diag(S) @ V
print(np.round(rebuilt, 3))
--- solution
A = np.array([[4.0, 0.0, 2.0],
              [1.0, 3.0, 0.0]])
U, S, Vt = np.linalg.svd(A, full_matrices=False)

# Rebuild A from its three pieces
rebuilt = U @ np.diag(S) @ Vt
print(np.round(rebuilt, 3))
--- test
assert np.allclose(rebuilt, A), f"The rebuilt matrix should equal A, but it is {np.round(rebuilt, 3).tolist()}."
--- hint
Check the shapes: `U` is 2 x 2, `diag(S)` is 2 x 2 and `V` is 3 x 2. The multiplication cannot go through.
--- hint
`np.linalg.svd` already returns the transposed right factor as `Vt`, so no extra transpose is needed.
```

```python predict id=predict-rank title="How many dimensions survive?"
M = np.array([[1.0, 2.0],
              [2.0, 4.0],
              [3.0, 6.0]])
print(np.linalg.matrix_rank(M))
--- options
2
* 1
3
0
--- explain
The second column is exactly twice the first, so all rows lie on one line through the origin. The matrix carries only one independent direction of information, which shows up as a single nonzero singular value.
```

```python predict id=predict-svd-shape title="Shapes from a compact SVD"
X = np.zeros((5, 3))
U, S, Vt = np.linalg.svd(X, full_matrices=False)
print(S.shape, U.shape)
--- options
(5,) (5, 5)
* (3,) (5, 3)
(3,) (3, 3)
(5, 3) (3,)
--- explain
With `full_matrices=False`, there are as many singular values as the smaller dimension (3), and `U` has the same shape as `X`: 5 rows and 3 orthonormal columns.
```

## Recap

- Every matrix factors as $A = U\Sigma V^\top$, with singular values sorted from largest to smallest.
- `np.linalg.svd(A, full_matrices=False)` returns the compact form, and `Vt` is already transposed.
- Squared singular values measure energy. The number of nonzero ones is the rank.
- Keeping the top $k$ components gives the best rank-$k$ approximation, which removes noise and compresses data.

**Up next:** principal component analysis, which applies the SVD to a dataset to find the directions along which the data varies most.
