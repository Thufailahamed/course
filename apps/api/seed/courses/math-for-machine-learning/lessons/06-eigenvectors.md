Most vectors change direction when a matrix acts on them. A few special vectors don't: the matrix only stretches or shrinks them. Those are the **eigenvectors**, and the stretch factors are the **eigenvalues**. They are the natural axes of a transformation. Google's original PageRank was an eigenvector computation. The stability of a training run depends on eigenvalues. And the most important tool for finding structure in data, principal component analysis, is an eigenvalue problem in disguise.

By the end of this lesson you will find eigenpairs with NumPy, check them by hand, understand why symmetric matrices are special, and compute a dominant eigenvector by repeated multiplication.

## Special directions

An eigenvector $v$ of a matrix $A$ satisfies

$$
A v = \lambda v
$$

Multiplying by $A$ changes only the length of $v$, by the factor $\lambda$. Let's test that on a simple matrix.

```python run
import numpy as np

A = np.array([[2.0, 1.0],
              [1.0, 2.0]])

for v in [np.array([1.0, 1.0]), np.array([1.0, -1.0]), np.array([1.0, 0.0])]:
    print("v =", v, "-> A v =", A @ v)
```

For $v = (1, 1)$, the result $(3, 3)$ is $3v$, so $(1, 1)$ is an eigenvector with eigenvalue 3. For $(1, -1)$, the result is $(1, -1)$ itself, an eigenvalue of 1. The vector $(1, 0)$ is not special: its image $(2, 1)$ points in a new direction.

## Let NumPy find them

`np.linalg.eig` returns all eigenvalues, and the matching eigenvectors as **columns** of a matrix.

```python run
eigenvalues, eigenvectors = np.linalg.eig(A)
print("eigenvalues:", eigenvalues)
print("eigenvectors (one per column):")
print(eigenvectors)

first = eigenvectors[:, 0]
print("A v = lambda v for the first pair?", np.allclose(A @ first, eigenvalues[0] * first))
```

> **Pitfall:** eigenvectors are stored in **columns**, so the first eigenvector is `eigenvectors[:, 0]`, not `eigenvectors[0]`. You will meet this mistake in a debug challenge.

## Symmetric matrices are the well-behaved case

A matrix equal to its own transpose, $A = A^\top$, is called **symmetric**. Symmetric matrices always have real eigenvalues and perpendicular eigenvectors. Use `np.linalg.eigh` for them: it is faster, more accurate and returns the eigenvalues sorted in ascending order.

```python run
S = np.array([[4.0, 2.0],
              [2.0, 4.0]])
values, vectors = np.linalg.eigh(S)
print("eigenvalues (ascending):", values)
print("eigenvectors:", vectors.round(3))
print("perpendicular?", np.isclose(vectors[:, 0] @ vectors[:, 1], 0.0))
```

Covariance matrices, which describe how features vary together, are always symmetric. That is why PCA works so cleanly.

## Eigenvectors are the axes of a transformation

Here is the picture. Apply $A$ to every point on the unit circle and you get an ellipse. The eigenvectors of $A$ point along the ellipse's axes, and the eigenvalues give how far it stretches along each axis.

```python run
import matplotlib.pyplot as plt

theta = np.linspace(0, 2 * np.pi, 200)
circle = np.vstack([np.cos(theta), np.sin(theta)])
ellipse = A @ circle
vals, vecs = np.linalg.eigh(A)

fig, ax = plt.subplots()
ax.plot(*circle, color="gray", alpha=0.6, label="unit circle")
ax.plot(*ellipse, color="tab:blue", label="after A")
for lam, v in zip(vals, vecs.T):
    ax.arrow(0, 0, *(v * lam), color="tab:red", width=0.03, length_includes_head=True)
ax.set_aspect("equal"); ax.grid(alpha=0.3); ax.legend()
ax.set_title("Red arrows: eigenvectors, scaled by their eigenvalues")
plt.show()
```

The red arrows lie exactly along the long and short axes of the blue ellipse. That is what an eigenvector is: an axis the transformation doesn't rotate.

## Power iteration: finding the dominant direction

Start with any vector and keep multiplying by $A$, normalizing each time. The vector gradually turns toward the eigenvector with the **largest** eigenvalue (in absolute value). This is called power iteration, and it scales to matrices far too large for a full decomposition.

```python run
def power_iteration(A, steps=50):
    v = np.array([1.0, 0.0])
    for _ in range(steps):
        v = A @ v
        v = v / np.linalg.norm(v)
    eigenvalue = v @ A @ v        # the Rayleigh quotient estimates lambda
    return v, eigenvalue

v, lam = power_iteration(A)
print("dominant direction:", np.round(v, 3), "| eigenvalue estimate:", round(lam, 3))
```

Each multiplication pushes the vector toward the direction the matrix stretches most. After 50 steps it points along $(1, 1)$ and the estimate is 3, matching the eigenvalue we found earlier.

> **In the wild:** PageRank, recommendation systems and spectral clustering all rely on the dominant eigenvector, found by iterations much like this one.

## Challenges

```python exercise id=is-eigenpair title="Check an eigenpair"
# TODO: `is_eigenpair(A, v, lam)` should return True when v is an eigenvector of A
# with eigenvalue lam, and False otherwise.
def is_eigenpair(A, v, lam):
    ...
--- solution
def is_eigenpair(A, v, lam):
    return bool(np.allclose(A @ v, lam * v))
--- test
A = np.array([[2.0, 1.0],
              [1.0, 2.0]])
result = is_eigenpair(A, np.array([1.0, 1.0]), 3.0)
assert result is not None, "Replace the `...` in `is_eigenpair` with code that returns True or False."
assert bool(result) is True, "(1, 1) is an eigenvector of A with eigenvalue 3."
assert bool(is_eigenpair(A, np.array([1.0, 1.0]), 2.0)) is False, "(1, 1) has eigenvalue 3, not 2."
assert bool(is_eigenpair(A, np.array([1.0, 0.0]), 2.0)) is False, "(1, 0) is not an eigenvector of A."
assert bool(is_eigenpair(np.diag([5.0, 2.0]), np.array([0.0, 4.0]), 2.0)) is True, "Check a diagonal matrix as well: (0, 4) should be an eigenvector with eigenvalue 2."
--- hint
An eigenpair satisfies `A v = lam v`. Compute both sides and compare them with `np.allclose`.
--- hint
`return bool(np.allclose(A @ v, lam * v))`.
```

```python exercise id=dominant-eigenvalue title="Estimate the largest eigenvalue"
# TODO: `dominant_eigenvalue(A, steps=100)` should run power iteration starting from
# v = (1, 0) and return the estimated largest eigenvalue of the symmetric matrix A.
def dominant_eigenvalue(A, steps=100):
    ...
--- solution
def dominant_eigenvalue(A, steps=100):
    v = np.array([1.0, 0.0])
    for _ in range(steps):
        v = A @ v
        v = v / np.linalg.norm(v)
    return v @ A @ v
--- test
est = dominant_eigenvalue(np.array([[3.0, 1.0],
                                    [1.0, 3.0]]))
assert est is not None, "Replace the `...` in `dominant_eigenvalue` with code that returns an eigenvalue."
assert np.isclose(est, 4.0, atol=1e-6), f"The largest eigenvalue of [[3, 1], [1, 3]] is 4, but your estimate is {est!r}."
assert np.isclose(dominant_eigenvalue(np.diag([5.0, 1.0])), 5.0, atol=1e-6), "The largest eigenvalue of diag(5, 1) is 5."
assert np.isclose(dominant_eigenvalue(np.array([[2.0, 3.0], [3.0, 2.0]])), 5.0, atol=1e-6), "Check a third matrix: the largest eigenvalue of [[2, 3], [3, 2]] is 5."
--- hint
Repeat `v = A @ v` and then divide `v` by its length, exactly as in the power iteration example above.
--- hint
After the loop, `v @ A @ v` is the eigenvalue estimate.
```

```python debug eigvec-row id=eigvec-row title="Wrong eigenvector"
A = np.array([[4.0, 1.0],
              [2.0, 3.0]])
eigenvalues, eigenvectors = np.linalg.eig(A)

# The eigenvector for the largest eigenvalue
largest = np.argmax(eigenvalues)
v = eigenvectors[largest]

print("v =", v)
print("A @ v =", A @ v, "| 5 * v =", eigenvalues[largest] * v)
--- solution
A = np.array([[4.0, 1.0],
              [2.0, 3.0]])
eigenvalues, eigenvectors = np.linalg.eig(A)

# The eigenvector for the largest eigenvalue
largest = np.argmax(eigenvalues)
v = eigenvectors[:, largest]

print("v =", v)
print("A @ v =", A @ v, "| 5 * v =", eigenvalues[largest] * v)
--- test
assert np.allclose(A @ v, 5.0 * v), f"v should be an eigenvector of A with eigenvalue 5, but A @ v = {np.round(A @ v, 3).tolist()}."
--- hint
Look at the shape of `eigenvectors`. Its eigenvectors are stored as columns, so `eigenvectors[largest]` takes a row.
--- hint
Select a column, with `eigenvectors[:, largest]`.
```

```python predict id=predict-eig title="Eigenvalues of a diagonal matrix"
D = np.diag([5.0, 2.0])
print(np.sort(np.linalg.eigvals(D)))
--- options
[5. 2.]
* [2. 5.]
[10.  4.]
[1. 1.]
--- explain
A diagonal matrix stretches each axis by its diagonal entry, so its eigenvalues are simply 5 and 2 (the eigenvectors are the axes themselves). `np.sort` puts them in ascending order.
```

```python predict id=predict-eigcheck title="Is it an eigenvector?"
A = np.array([[2.0, 1.0],
              [1.0, 2.0]])
v = np.array([1.0, 1.0])
print(np.allclose(A @ v, 3 * v))
--- options
* True
False
It depends on the size of v
--- explain
`A @ v` is `(3, 3)`, which equals `3 * v`. So `(1, 1)` is an eigenvector with eigenvalue 3.
```

## Recap

- An eigenvector satisfies $Av = \lambda v$: the matrix only stretches it, by $\lambda$.
- `np.linalg.eig` returns eigenvalues and eigenvectors, the latter as columns.
- Symmetric matrices have real eigenvalues and perpendicular eigenvectors. Use `np.linalg.eigh`.
- Eigenvectors are the axes of the ellipse that a matrix makes out of a circle.
- Power iteration finds the dominant eigenvector by repeated multiplication and normalization.

**Up next:** the singular value decomposition. It generalizes eigenvectors to any matrix, square or not, and it is the engine behind compression and PCA.
