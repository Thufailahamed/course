Suppose you rotate a shape and then stretch it. That is two transformations in a row, and the result is one transformation too. The matrix for "do this, then that" is the **product** of the two matrices. Matrix multiplication looks like a strange recipe of rows and columns at first, but it is simply function composition, and it is the workhorse of machine learning: a whole batch of data passes through a neural network as one big matrix product.

By the end of this lesson you will multiply matrices by hand and in code, know why the order matters, use transposes, and write a linear model over a whole dataset in a single line.

## Composition: one transformation after another

Let $S$ stretch the x-axis by 2 and let $R$ rotate by 90 degrees. Applying $S$ first and then $R$ to a vector $x$ gives $R(Sx)$. Matrix multiplication packs that chain into one matrix, $RS$, so that $RS\,x = R(Sx)$.

```python run
import numpy as np

S = np.array([[2.0, 0.0],
              [0.0, 1.0]])      # stretch x by 2
R = np.array([[0.0, -1.0],
              [1.0, 0.0]])      # rotate 90 degrees counterclockwise

x = np.array([1.0, 1.0])
print("stretch, then rotate:", R @ (S @ x))
print("one combined matrix: ", (R @ S) @ x)
```

Both lines print the same vector. The product $RS$ does the whole job in one step, which is why engineers multiply matrices ahead of time when a transformation is applied many times.

## The rule: rows times columns

Entry $(i, j)$ of the product $C = AB$ is the dot product of row $i$ of $A$ with column $j$ of $B$:

$$
C_{ij} = \sum_{k} A_{ik} B_{kj}
$$

The inner sizes must match. An $m \times n$ matrix times an $n \times p$ matrix gives an $m \times p$ matrix.

```python run
A = np.array([[1.0, 2.0, 0.0],
              [0.0, 1.0, 3.0]])     # 2 x 3
B = np.array([[1.0, 0.0],
              [2.0, 1.0],
              [0.0, 4.0]])          # 3 x 2

C = A @ B
print("shapes:", A.shape, "@", B.shape, "->", C.shape)
print(C)
```

Check one entry yourself: row 1 of $A$ is $(1, 2, 0)$ and column 1 of $B$ is $(1, 2, 0)$, so $C_{11} = 1 + 4 + 0 = 5$.

Here is the same computation written as three nested loops. It is slow, but it shows exactly what `@` is doing.

```python run
def matmul_loops(A, B):
    m, n = A.shape
    p = B.shape[1]
    C = np.zeros((m, p))
    for i in range(m):
        for j in range(p):
            C[i, j] = sum(A[i, k] * B[k, j] for k in range(n))
    return C

print("loops agree with @:", np.allclose(matmul_loops(A, B), A @ B))
```

## Order matters

Matrix multiplication is **not commutative**: $AB$ and $BA$ are generally different. Rotating and then stretching is not the same as stretching and then rotating.

```python run
P = np.array([[0.0, -1.0],
              [1.0, 0.0]])          # rotate 90 degrees
S = np.array([[2.0, 0.0],
              [0.0, 1.0]])          # stretch x by 2

print("P @ S =\n", P @ S)
print("S @ P =\n", S @ P)
print("equal?", np.array_equal(P @ S, S @ P))
```

> **Pitfall:** when you read `W @ x` in a formula, the matrix always acts on the right. The rightmost transformation is applied first.

## The transpose: flipping rows and columns

The **transpose** $A^\top$ swaps rows and columns. It shows up constantly, and it obeys a useful rule: $(AB)^\top = B^\top A^\top$. The order reverses.

```python run
X = np.array([[1.0, 2.0, 3.0],
              [4.0, 5.0, 6.0]])
print("X shape:", X.shape, "| X.T shape:", X.T.shape)
print("(AB)^T equals B^T A^T:", np.allclose((A @ B).T, B.T @ A.T))
```

## Machine learning in one product

Take a dataset with $n$ samples and $d$ features, stored as an $n \times d$ matrix $X$. A linear model with weights $w$ (a vector of length $d$) predicts for **every sample at once**:

$$
\hat{y} = X w
$$

A layer of a neural network with $h$ hidden units is the same idea with a weight matrix $W$ of shape $d \times h$: the whole batch flows through as $XW$.

```python run
rng = np.random.default_rng(0)
X = rng.integers(0, 4, size=(5, 3)).astype(float)    # 5 samples, 3 features
W = rng.integers(-1, 2, size=(3, 2)).astype(float)   # 3 features -> 2 hidden units

H = X @ W
print("X:", X.shape, " W:", W.shape, " H:", H.shape)
H
```

One line of code processed five samples through a two-unit layer. A GPU does exactly this, in parallel, on matrices with millions of entries.

## Challenges

```python exercise id=loop-matmul title="Matrix multiplication by loops"
# TODO: `loop_matmul(A, B)` multiplies A (m x n) by B (n x p) using three nested loops.
# Don't use @ or np.dot.
def loop_matmul(A, B):
    ...
--- solution
def loop_matmul(A, B):
    m, n = A.shape
    p = B.shape[1]
    C = np.zeros((m, p))
    for i in range(m):
        for j in range(p):
            for k in range(n):
                C[i, j] += A[i, k] * B[k, j]
    return C
--- test
rng = np.random.default_rng(1)
A = rng.normal(size=(3, 4))
B = rng.normal(size=(4, 2))
result = loop_matmul(A, B)
assert result is not None, "Replace the `...` in `loop_matmul` with code that returns the product."
assert np.shape(result) == (3, 2), f"The product of a 3 x 4 and a 4 x 2 matrix is 3 x 2, but yours has shape {np.shape(result)}."
assert np.allclose(result, A @ B), "Each entry C[i, j] should be the dot product of row i of A with column j of B."
A2 = rng.normal(size=(2, 5))
B2 = rng.normal(size=(5, 5))
assert np.allclose(loop_matmul(A2, B2), A2 @ B2), "Your function should work for any compatible shapes, not only the example above."
--- hint
Start with `C = np.zeros((m, p))`, then fill each entry `C[i, j]` with a sum over `k`.
--- hint
Inside the innermost loop, add `A[i, k] * B[k, j]` to `C[i, j]`. Three loops: i, j and k.
```

```python exercise id=scale-then-rotate title="Compose two transformations"
# TODO: `scale_then_rotate()` returns the single 2 x 2 matrix that first stretches the
# x-axis by 2 and then rotates 90 degrees counterclockwise.
def scale_then_rotate():
    ...
--- solution
def scale_then_rotate():
    S = np.array([[2.0, 0.0], [0.0, 1.0]])
    R = np.array([[0.0, -1.0], [1.0, 0.0]])
    return R @ S
--- test
M = scale_then_rotate()
assert M is not None, "Replace the `...` in `scale_then_rotate` with code that returns a matrix."
assert np.allclose(M @ np.array([1.0, 0.0]), [0.0, 2.0]), "(1, 0) is first stretched to (2, 0), then rotated to (0, 2)."
assert np.allclose(M @ np.array([0.0, 1.0]), [-1.0, 0.0]), "(0, 1) is unchanged by the stretch, then rotated to (-1, 0)."
assert np.allclose(M @ np.array([1.0, 1.0]), [-1.0, 2.0]), "Check (1, 1) as well: stretch to (2, 1), then rotate to (-1, 2)."
--- hint
Put the rightmost transformation first: the stretch is applied before the rotation, so the rotation matrix goes on the left.
--- hint
`R @ S`, where S is the stretch and R is the rotation.
```

```python debug elementwise-bug id=elementwise-bug title="Scores that look plausible but are wrong"
# X has one row per sample and one column per feature.
# W has one row per feature and one column per output.
X = np.array([[1.0, 2.0],
              [3.0, 4.0]])
W = np.array([[0.5, 1.0],
              [1.0, 0.0]])

scores = X * W
print(scores)
--- solution
# X has one row per sample and one column per feature.
# W has one row per feature and one column per output.
X = np.array([[1.0, 2.0],
              [3.0, 4.0]])
W = np.array([[0.5, 1.0],
              [1.0, 0.0]])

scores = X @ W
print(scores)
--- test
expected = np.array([[2.5, 1.0],
                     [5.5, 3.0]])
assert np.allclose(scores, expected), f"scores should be the matrix product X @ W, which is {expected.tolist()}, but it is {np.round(scores, 3).tolist()}."
--- hint
Check the first entry by hand: row 1 of X is (1, 2) and column 1 of W is (0.5, 1.0). What is their dot product?
--- hint
`*` multiplies matching positions one by one. Matrix multiplication, which combines rows and columns, is `@`.
```

```python predict id=predict-matmul title="Multiply two matrices"
P = np.array([[1, 2],
              [3, 4]])
Q = np.array([[0, 1],
              [1, 0]])
print((P @ Q).tolist())
--- options
[[1, 2], [3, 4]]
* [[2, 1], [4, 3]]
[[0, 1], [1, 0]]
[[3, 2], [1, 4]]
--- explain
Column 1 of Q is (0, 1), so entry (0, 0) is `1*0 + 2*1 = 2`. Column 2 is (1, 0), so entry (0, 1) is `1*1 + 2*0 = 1`. Multiplying by this Q swaps the columns of P.
```

```python predict id=predict-order title="Does order matter?"
A = np.array([[1, 1],
              [0, 1]])
B = np.array([[1, 0],
              [1, 1]])
print(np.array_equal(A @ B, B @ A))
--- options
True
* False
It depends on the shapes
--- explain
`A @ B` is `[[2, 1], [1, 1]]`, while `B @ A` is `[[1, 1], [1, 2]]`. Matrix multiplication is not commutative, so the order of transformations matters.
```

## Recap

- Multiplying matrices composes transformations. $RS\,x$ means "apply $S$, then $R$".
- Entry $(i, j)$ of $AB$ is row $i$ of $A$ dotted with column $j$ of $B$. Inner dimensions must match.
- $AB \neq BA$ in general. The rightmost matrix acts first.
- $(AB)^\top = B^\top A^\top$.
- A whole dataset passes through a linear model or a neural-network layer as one matrix product, $Xw$ or $XW$.

**Up next:** eigenvectors, the special directions that a matrix only stretches, never rotates. They reveal the structure hidden inside a matrix.
