Linear algebra is the engine room of scientific computing. Fitting a model, balancing a chemical equation, computing a portfolio, compressing an image, running PageRank: under the surface, each one solves a system of equations or decomposes a matrix. NumPy's `np.linalg` module gives you industrial-strength versions of all of these, backed by the same LAPACK routines that power MATLAB, R and Julia.

In this lesson you'll solve systems of equations the right way, measure vectors and matrices with norms, take matrices apart with eigen- and singular-value decompositions, and fit models with least squares. Along the way you'll learn the most important habit in numerical linear algebra: **never trust `==` on floats, and almost never call `inv`.**

```python setup
rng_data = np.random.default_rng(2024)
x_data = np.linspace(0, 10, 30)
y_data = 2.5 * x_data + 1.0 + rng_data.normal(scale=1.5, size=30)
```

## Systems of linear equations

Here is a small system:

$$
\begin{aligned}
2x + \phantom{3}y &= 5 \\
x + 3y &= 10
\end{aligned}
$$

In matrix form it's $A\mathbf{x} = \mathbf{b}$: the coefficients go into $A$, the right-hand side into $\mathbf{b}$, and the unknowns into $\mathbf{x}$. `np.linalg.solve(A, b)` finds $\mathbf{x}$.

```python run
import numpy as np

A = np.array([[2.0, 1.0],
              [1.0, 3.0]])
b = np.array([5.0, 10.0])

x = np.linalg.solve(A, b)
print("solution x:", x)
print("check A @ x:", A @ x)
```

The solution is $x = 1, y = 3$. Always check a solution by plugging it back in: `A @ x` should reproduce `b`.

> **Tip:** each **row** of `A` is one equation and each **column** belongs to one unknown. If you have $m$ equations in $n$ unknowns, `A` has shape `(m, n)`.

## Why not just invert?

From algebra class you know $\mathbf{x} = A^{-1}\mathbf{b}$, and `np.linalg.inv` exists. So why not use it? Two reasons:

1. **Speed:** computing the full inverse does roughly three times the work of solving directly, and you usually only need $A^{-1}\mathbf{b}$, not $A^{-1}$ itself.
2. **Accuracy:** inverting amplifies rounding errors. On a badly conditioned matrix, the difference is dramatic.

The Hilbert matrix, $H_{ij} = \frac{1}{i + j + 1}$, is a famously ill-conditioned matrix. We know the true answer, a vector of ones, so we can measure each method's error:

```python run
n = 10
i = np.arange(n)
H = 1.0 / (i[:, None] + i[None, :] + 1)   # broadcasting builds the matrix
x_true = np.ones(n)
b = H @ x_true

err_solve = np.abs(np.linalg.solve(H, b) - x_true).max()
err_inv = np.abs(np.linalg.inv(H) @ b - x_true).max()
print(f"max error with solve: {err_solve:.1e}")
print(f"max error with inv:   {err_inv:.1e}")
print(f"condition number:     {np.linalg.cond(H):.1e}")
```

The **condition number** measures how much a matrix can amplify errors in the input. A rule of thumb: you lose about $\log_{10}(\text{cond})$ digits of precision. Float64 has about 16 digits, so a condition number around $10^{13}$ leaves only a few trustworthy ones. Well-behaved matrices have condition numbers close to 1.

| Task | Use | Avoid |
|---|---|---|
| Solve $A\mathbf{x}=\mathbf{b}$ | `np.linalg.solve(A, b)` | `np.linalg.inv(A) @ b` |
| Many right-hand sides | `np.linalg.solve(A, B)`, with `B` holding one column per system | inverting once and reusing it |
| Over-determined (more equations than unknowns) | `np.linalg.lstsq(A, b)` | `solve` (needs a square matrix) |
| Check a result | `np.allclose(A @ x, b)` | `(A @ x == b).all()` |

## Challenge: what does each pastry cost?

```python exercise id=bakery-prices title="Recover prices from three days of sales"
# A bakery sells croissants, muffins and scones. You only know the daily totals:
#   Monday:    3 croissants + 2 muffins + 4 scones = $19.50
#   Tuesday:   1 croissant  + 5 muffins + 2 scones = $20.50
#   Wednesday: 4 croissants + 1 muffin  + 3 scones = $17.50

# TODO: build the coefficient matrix (one row per day, one column per pastry)
A = ...
# TODO: build the vector of daily totals
b = ...
# TODO: solve for [croissant, muffin, scone] prices
prices = ...
print(prices)
--- solution
A = np.array([[3, 2, 4],
              [1, 5, 2],
              [4, 1, 3]], dtype=float)
b = np.array([19.5, 20.5, 17.5])
prices = np.linalg.solve(A, b)
print(prices)
--- test
assert A is not ..., "Replace the `...` after `A =` with the coefficient matrix."
assert b is not ..., "Replace the `...` after `b =` with the daily totals."
assert prices is not ..., "Replace the `...` after `prices =` with your solution."
A = np.asarray(A); b = np.asarray(b); prices = np.asarray(prices)
assert A.shape == (3, 3), f"`A` should be 3x3 (3 days × 3 pastries), but has shape {A.shape}."
assert b.shape == (3,), f"`b` should hold the 3 daily totals, but has shape {b.shape}."
assert np.allclose(A @ np.array([2.5, 3.0, 1.5]), b), "`A` and `b` don't describe the bakery's sales. Each row should be one day: the number of croissants, muffins and scones sold."
assert prices.shape == (3,), f"`prices` should hold 3 prices, but has shape {prices.shape}."
assert np.allclose(prices, [2.5, 3.0, 1.5]), f"`prices` should solve A @ prices = b, but A @ prices = {np.round(A @ prices, 3)}."
--- hint
Row 0 of `A` is Monday: `[3, 2, 4]`. `b` is `[19.5, 20.5, 17.5]`.
--- hint
`np.linalg.solve(A, b)` returns the unknowns in column order: croissant, muffin, scone.
```

## Singular matrices: when there's no unique answer

If one equation is just a multiple of another, the system has infinitely many solutions (or none), and the matrix is **singular**. Its determinant is zero, its rank is less than its size, and `solve` has no meaningful answer to give:

```python run
S = np.array([[1.0, 2.0],
              [2.0, 4.0]])   # row 2 = 2 × row 1

print("determinant:", np.linalg.det(S))
print("rank:       ", np.linalg.matrix_rank(S), "of", S.shape[0])
```

```python run
b_s = np.array([3.0, 6.0])

if np.linalg.matrix_rank(S) < S.shape[0]:
    print("S is singular: there is no unique solution.")
    # lstsq still works: it returns the smallest solution that fits best
    sol, *_ = np.linalg.lstsq(S, b_s, rcond=None)
    print("minimum-norm solution:", np.round(sol, 3))
    print("it fits:", np.allclose(S @ sol, b_s))
```

> **Pitfall:** never call `solve` on a matrix you haven't checked. Depending on the LAPACK build, a singular matrix either raises `LinAlgError` or silently returns `inf`/`nan` or huge, meaningless numbers. Check `matrix_rank` (or `cond`) first, and fall back to `lstsq` when the system is singular.

The **rank** is the number of truly independent rows (or columns). It's a far more reliable singularity test than checking `det == 0`, because determinants of nearly singular matrices are tiny but rarely exactly zero in floating point.

> **Pitfall:** a determinant's size says little about how invertible a matrix is. `0.1 * np.eye(10)` has determinant $10^{-10}$ yet is perfectly well-conditioned (cond = 1). Use `matrix_rank` or `cond`, not `det`.

```python predict id=predict-rank title="What does this print?"
M = np.array([[1, 2, 3],
              [2, 4, 6],
              [1, 0, 1]])
print(np.linalg.matrix_rank(M))
--- options
3
* 2
1
0
--- explain
Row 2 is exactly twice row 1, so it adds no new information. Row 3 is independent of row 1, so there are **2** independent rows. The matrix is singular, because rank 2 is less than size 3.
```

## Norms: how big is a vector?

A **norm** measures the size of a vector. The most common is the Euclidean (L2) norm $\lVert\mathbf{v}\rVert_2 = \sqrt{\sum v_i^2}$, the straight-line length. Others are useful too:

| `ord` | Name | Formula | Used for |
|---|---|---|---|
| `2` (default) | Euclidean / L2 | $\sqrt{\sum v_i^2}$ | distances, weight decay |
| `1` | Manhattan / L1 | $\sum \lvert v_i\rvert$ | sparsity (lasso), city-block distance |
| `np.inf` | max norm | $\max \lvert v_i\rvert$ | worst-case error |

```python run
v = np.array([3.0, -4.0, 0.0])
print("L2:  ", np.linalg.norm(v))
print("L1:  ", np.linalg.norm(v, ord=1))
print("max: ", np.linalg.norm(v, ord=np.inf))

M = np.array([[1.0, 2.0], [3.0, 4.0]])
print("Frobenius norm of M:", np.linalg.norm(M))   # sqrt of the sum of all squared entries
```

With `axis=`, `norm` computes one norm per row or column. This is how you measure many vectors at once:

```python run
points = np.array([[3.0, 4.0],
                   [1.0, 0.0],
                   [5.0, 12.0]])
print(np.linalg.norm(points, axis=1))   # length of each row
```

```python predict id=predict-norm title="What does this print?"
print(np.linalg.norm([6, 8]))
--- options
14.0
* 10.0
100.0
48.0
--- explain
The L2 norm is $\sqrt{6^2 + 8^2} = \sqrt{100} = 10$. NumPy returns a float, so it prints `10.0`.
```

```python exercise id=normalize-rows title="Scale every row to unit length"
def normalize_rows(X):
    """Return a copy of X where every row has L2 norm 1 (same direction)."""
    # TODO: divide each row by its own length
    ...

X = np.array([[3.0, 4.0],
              [0.0, 2.0],
              [1.0, 1.0]])
print(normalize_rows(X))
--- solution
def normalize_rows(X):
    """Return a copy of X where every row has L2 norm 1 (same direction)."""
    return X / np.linalg.norm(X, axis=1, keepdims=True)

X = np.array([[3.0, 4.0],
              [0.0, 2.0],
              [1.0, 1.0]])
print(normalize_rows(X))
--- test
_X = np.array([[3.0, 4.0], [0.0, 2.0], [1.0, 1.0]])
_out = normalize_rows(_X.copy())
assert _out is not None, "`normalize_rows` returned None. Did you forget `return`?"
_out = np.asarray(_out)
assert _out.shape == _X.shape, f"The output should keep the input's shape {_X.shape}, but has shape {_out.shape}."
assert np.allclose(_out[0], [0.6, 0.8]), f"Row [3, 4] has length 5, so it should become [0.6, 0.8], not {np.round(_out[0], 3)}. Are you dividing each row by its own length?"
_rng = np.random.default_rng(5)
_R = _rng.normal(size=(6, 4)) * _rng.uniform(1, 10, size=(6, 1))
_n = np.asarray(normalize_rows(_R.copy()))
assert np.allclose(np.linalg.norm(_n, axis=1), 1.0), "Every row of the result should have length 1."
assert np.allclose(_n * np.linalg.norm(_R, axis=1, keepdims=True), _R), "Rows should keep their direction; only their length should change."
--- hint
`np.linalg.norm(X, axis=1)` gives one length per row, shape `(n,)`. Dividing an `(n, d)` array by an `(n,)` array doesn't broadcast the way you want.
--- hint
Pass `keepdims=True` so the lengths have shape `(n, 1)` and divide each row correctly.
```

## Debug challenge: the "failed" verification

An engineer solved a system and added a sanity check. The check reports that the solution is wrong, but the solution looks perfect when printed. Find out why, and make the check trustworthy.

```python debug id=float-verify title="The solution looks right, but the check says it's wrong"
A = np.array([[0.1, 0.2, 0.3],
              [0.4, 0.5, 0.7],
              [0.7, 0.8, 1.0]])
b = np.array([1.4, 3.5, 5.3])

x = np.linalg.inv(A) @ b
ok = (A @ x == b).all()

print("x =", x)
print("verified:", ok)
--- solution
A = np.array([[0.1, 0.2, 0.3],
              [0.4, 0.5, 0.7],
              [0.7, 0.8, 1.0]])
b = np.array([1.4, 3.5, 5.3])

x = np.linalg.solve(A, b)
ok = np.allclose(A @ x, b)

print("x =", x)
print("verified:", ok)
--- test
assert np.allclose(x, [1.0, 2.0, 3.0]), f"`x` should solve the system, giving [1, 2, 3], but it is {x}."
assert bool(ok) is True, "`ok` is still False. Print `A @ x - b` and look at the size of the differences. How should floats be compared?"
--- hint
Print `A @ x - b`. The differences are around $10^{-15}$. Real, but meaningless.
--- hint
Compare floats with a tolerance: `np.allclose(A @ x, b)`. While you're there, replace `inv(A) @ b` with `np.linalg.solve(A, b)`.
```

## Eigenvalues: directions a matrix only stretches

An **eigenvector** $\mathbf{v}$ of a square matrix $A$ is a direction that $A$ doesn't rotate, only stretches, by a factor $\lambda$ called the **eigenvalue**:

$$
A\mathbf{v} = \lambda\mathbf{v}
$$

For **symmetric** matrices, like covariance matrices, distance matrices and graph Laplacians, always use `np.linalg.eigh`. It's faster, it returns real eigenvalues sorted in ascending order, and its eigenvectors are orthonormal. The general `np.linalg.eig` can return complex numbers and makes no ordering promises.

```python run
rng = np.random.default_rng(0)
data = rng.normal(size=(200, 2)) @ np.array([[3.0, 0.0], [1.2, 0.5]])
C = np.cov(data, rowvar=False)          # 2x2 symmetric covariance matrix

eigenvalues, eigenvectors = np.linalg.eigh(C)
print("eigenvalues :", np.round(eigenvalues, 3))
print("eigenvectors (columns):\n", np.round(eigenvectors, 3))

v = eigenvectors[:, -1]                 # the column for the largest eigenvalue
print("A v == λ v ?", np.allclose(C @ v, eigenvalues[-1] * v))
```

The eigenvector with the largest eigenvalue is the direction in which the data varies most. That's exactly the first **principal component** in PCA.

> **Pitfall:** eigenvectors are the **columns** of the returned matrix, not the rows. `eigenvectors[:, i]` pairs with `eigenvalues[i]`.

## SVD: the decomposition behind compression

The **singular value decomposition** factors *any* matrix, square or not, into three pieces:

$$
M = U \, \Sigma \, V^\top
$$

$U$ and $V$ have orthonormal columns, and $\Sigma$ is diagonal with **singular values** $\sigma_1 \ge \sigma_2 \ge \dots \ge 0$. Each singular value measures how much one "layer" of the matrix matters. Keeping only the largest $k$ gives the **best possible rank-$k$ approximation** (the Eckart–Young theorem). That's the idea behind image compression, recommender systems and latent semantic analysis.

```python run
rng = np.random.default_rng(1)
# A 6x5 matrix that's secretly rank 2, plus a little noise
M = rng.normal(size=(6, 2)) @ rng.normal(size=(2, 5)) + 0.01 * rng.normal(size=(6, 5))

U, S, Vt = np.linalg.svd(M, full_matrices=False)
print("shapes:", U.shape, S.shape, Vt.shape)
print("singular values:", np.round(S, 3))
print("rebuilds M:", np.allclose(U @ np.diag(S) @ Vt, M))
```

Two large singular values and three tiny ones reveal the hidden rank-2 structure. The tiny ones are the noise.

```python exercise id=low-rank title="Build the best rank-k approximation"
def rank_k_approx(M, k):
    """Return the best rank-k approximation of M, using the SVD."""
    U, S, Vt = np.linalg.svd(M, full_matrices=False)
    # TODO: keep only the first k singular values/vectors and multiply back together
    ...

rng = np.random.default_rng(1)
M = rng.normal(size=(6, 2)) @ rng.normal(size=(2, 5)) + 0.01 * rng.normal(size=(6, 5))
approx = rank_k_approx(M, 2)
if approx is not None:
    print("rank:", np.linalg.matrix_rank(approx))
    print("max error:", np.abs(approx - M).max())
--- solution
def rank_k_approx(M, k):
    """Return the best rank-k approximation of M, using the SVD."""
    U, S, Vt = np.linalg.svd(M, full_matrices=False)
    return U[:, :k] @ np.diag(S[:k]) @ Vt[:k, :]

rng = np.random.default_rng(1)
M = rng.normal(size=(6, 2)) @ rng.normal(size=(2, 5)) + 0.01 * rng.normal(size=(6, 5))
approx = rank_k_approx(M, 2)
if approx is not None:
    print("rank:", np.linalg.matrix_rank(approx))
    print("max error:", np.abs(approx - M).max())
--- test
_rng = np.random.default_rng(99)
_M = _rng.normal(size=(8, 6))
_A = rank_k_approx(_M.copy(), 3)
assert _A is not None, "`rank_k_approx` returned None. Did you forget `return`?"
_A = np.asarray(_A)
assert _A.shape == _M.shape, f"The approximation should have the same shape as M, {_M.shape}, but has {_A.shape}."
assert np.linalg.matrix_rank(_A) == 3, f"`rank_k_approx(M, 3)` should have rank 3, but has rank {np.linalg.matrix_rank(_A)}."
_S = np.linalg.svd(_M, compute_uv=False)
_err = np.linalg.norm(_M - _A)
assert np.isclose(_err, np.sqrt((_S[3:] ** 2).sum())), "That's a rank-3 matrix, but not the *best* one. Keep the **largest** singular values: the first k."
assert np.allclose(rank_k_approx(_M, 6), _M), "With k equal to the full rank, you should get M back exactly."
--- hint
Slice each factor: the first `k` columns of `U`, the first `k` values of `S`, and the first `k` **rows** of `Vt`.
--- hint
`U[:, :k] @ np.diag(S[:k]) @ Vt[:k, :]`. Equivalently, `(U[:, :k] * S[:k]) @ Vt[:k]` uses broadcasting instead of building a diagonal matrix.
```

## Least squares: fitting a line

With more equations than unknowns, as with 30 noisy measurements and only 2 parameters, there's usually no exact solution. **Least squares** finds the parameters that minimize the total squared error, $\lVert A\mathbf{x} - \mathbf{b}\rVert^2$.

To fit $y = m x + c$, build a **design matrix** with one column per parameter: a column of `x` values for the slope, and a column of **ones** for the intercept.

```python run
print("x_data shape:", x_data.shape, " first values:", np.round(x_data[:3], 2))

design = np.column_stack([x_data, np.ones_like(x_data)])   # shape (30, 2)
print("design matrix (first rows):\n", np.round(design[:3], 2))

coef, residuals, rank, sing_vals = np.linalg.lstsq(design, y_data, rcond=None)
print("slope, intercept:", np.round(coef, 3))
```

The data was generated from $y = 2.5x + 1$ plus noise, and least squares recovers parameters very close to that.

```python run
import matplotlib.pyplot as plt

slope, intercept = coef
plt.scatter(x_data, y_data, s=18, label="data")
plt.plot(x_data, slope * x_data + intercept, color="crimson", label=f"fit: y = {slope:.2f}x + {intercept:.2f}")
plt.legend()
plt.show()
```

```python debug id=missing-intercept title="The fitted line is forced through the origin"
# Fit y = m*x + c to the lesson's data (x_data, y_data)
design = x_data[:, None]           # shape (30, 1)

coef, *_ = np.linalg.lstsq(design, y_data, rcond=None)
slope = coef[0]
intercept = 0.0

print(f"y = {slope:.3f} x + {intercept:.3f}")
--- solution
design = np.column_stack([x_data, np.ones_like(x_data)])

coef, *_ = np.linalg.lstsq(design, y_data, rcond=None)
slope, intercept = coef

print(f"y = {slope:.3f} x + {intercept:.3f}")
--- test
_d = np.column_stack([x_data, np.ones_like(x_data)])
_want, *_ = np.linalg.lstsq(_d, y_data, rcond=None)
assert np.isclose(intercept, _want[1]), f"`intercept` should be fitted from the data (about {_want[1]:.2f}), but it is {float(intercept):.3f}. Where does the intercept come from in the design matrix?"
assert np.isclose(slope, _want[0]), f"`slope` should be about {_want[0]:.3f}, but it is {float(slope):.3f}. Without an intercept, the slope gets distorted to compensate."
--- hint
Each column of the design matrix corresponds to one parameter. How many parameters does $y = mx + c$ have, and how many columns does `design` have?
--- hint
Add a column of ones: `np.column_stack([x_data, np.ones_like(x_data)])`. Then `lstsq` returns both the slope and the intercept.
```

> **In the wild:** `sklearn.linear_model.LinearRegression` does exactly this (with `fit_intercept=True` adding the column of ones for you), and `np.polyfit(x, y, 1)` is a convenient shortcut for polynomials.

## Recap

- Solve $A\mathbf{x}=\mathbf{b}$ with `np.linalg.solve`, not `inv(A) @ b`. It's faster and more accurate.
- Verify with `np.allclose(A @ x, b)`; never compare floats with `==`.
- The **condition number** tells you how many digits you can trust. Use `matrix_rank` and `cond`, not `det`, to detect near-singular matrices.
- `np.linalg.norm` measures length (L2, L1, max), and `axis=` computes one norm per row.
- For symmetric matrices use `eigh`; eigenvectors are the **columns**.
- The SVD $M = U\Sigma V^\top$ gives the best low-rank approximations, and `lstsq` fits over-determined systems. Don't forget the column of ones.

**Up next:** sorting, searching and statistics: ranking, top-k, binning and summarizing data.
