Almost every number a machine-learning model produces is a **dot product** at heart. A linear regression prediction, a neural-network layer, a recommendation score, the similarity between two sentence embeddings: each one comes down to multiplying matching entries and adding them up. GPUs exist largely to do this one operation very, very fast.

In this lesson you'll learn the three tools NumPy gives you for it: the `@` operator, `np.dot`, and the Swiss-army knife `np.einsum`. You'll also learn the shape rule that makes matrix multiplication predictable instead of mysterious. By the end you'll write the forward pass of a neural-network layer in a single line.

## The dot product

The dot product of two vectors of the same length multiplies them element by element and sums the result:

$$
\mathbf{a} \cdot \mathbf{b} = \sum_{i=1}^{n} a_i b_i = a_1 b_1 + a_2 b_2 + \dots + a_n b_n
$$

A concrete example: a shopping basket. `prices` holds the price of each item and `quantities` how many you bought. The total bill is their dot product.

```python run
import numpy as np

prices = np.array([2.50, 0.99, 4.25, 1.75])
quantities = np.array([2, 6, 1, 3])

by_hand = (prices * quantities).sum()   # multiply, then add up
with_dot = np.dot(prices, quantities)
with_at = prices @ quantities           # the matrix-multiplication operator

print("by hand: ", by_hand)
print("np.dot:  ", with_dot)
print("@:       ", with_at)
```

All three agree. `prices * quantities` alone is **not** a dot product; it's the element-wise product, an array of the same length. The dot product is that array *summed*, so it's a single number.

> **Under the hood:** geometrically, $\mathbf{a} \cdot \mathbf{b} = \lVert\mathbf{a}\rVert \, \lVert\mathbf{b}\rVert \cos\theta$, where $\theta$ is the angle between the vectors. Large and positive means "pointing the same way", zero means perpendicular, and negative means pointing apart. We'll use this for similarity search later in the lesson.

```python predict id=predict-self-dot title="What does this print?"
a = np.array([1, 2, 3])
print(a @ a)
--- options
[1 4 9]
* 14
6
[[1 2 3]]
--- explain
`a @ a` is the dot product of `a` with itself: $1\cdot1 + 2\cdot2 + 3\cdot3 = 14$. The element-wise product `a * a` would give `[1 4 9]`. A vector dotted with itself is its **squared length**.
```

## `*` versus `@`

This is the single most important distinction in this lesson:

| Operator | Name | What it does | Shapes |
|---|---|---|---|
| `A * B` | element-wise product | multiplies matching entries | must broadcast |
| `A @ B` | matrix product | rows of `A` dotted with columns of `B` | inner dimensions must match |

On matrices the difference is dramatic:

```python run
A = np.array([[1, 2],
              [3, 4]])
B = np.array([[10, 20],
              [30, 40]])

print("A * B (element-wise):")
print(A * B)
print()
print("A @ B (matrix product):")
print(A @ B)
```

Look at the top-left entry of `A @ B`: it's row 0 of `A` dotted with column 0 of `B`, so $1\cdot10 + 2\cdot30 = 70$. Every entry of a matrix product is one dot product:

$$
(AB)_{ij} = \sum_k A_{ik} B_{kj}
$$

> **Pitfall:** because `A * B` happily runs whenever the shapes broadcast, typing `*` when you meant `@` usually produces **no error**, just wrong numbers. When results look wrong in linear-algebra code, check this first.

## The shape rule

Matrix multiplication has one rule that you should be able to recite in your sleep:

$$
(n, \mathbf{k}) \;@\; (\mathbf{k}, m) \;\longrightarrow\; (n, m)
$$

The **inner** dimensions must match, and they disappear; the **outer** dimensions survive. A matrix times a vector follows the same rule, with the vector acting as a `(k,)` shape:

```python run
X = np.arange(12).reshape(4, 3)   # 4 samples, 3 features
w = np.array([0.5, -1.0, 2.0])    # one weight per feature

print("X shape:", X.shape, " w shape:", w.shape)
print("X @ w  ->", (X @ w).shape)  # (4, 3) @ (3,) -> (4,): one number per sample
X @ w
```

When the inner dimensions don't match, NumPy tells you exactly which ones disagree:

```python run error
W = np.ones((4, 2))
X @ W    # (4, 3) @ (4, 2): inner dims are 3 and 4
```

Reading that error message is a skill: `size 4 is different from 3` names the two inner dimensions. Usually the fix is to transpose one operand (`X.T`) or to rethink which axis means what.

```python predict id=predict-matmul-shape title="What shape does this produce?"
A = np.ones((2, 3))
B = np.ones((3, 4))
print((A @ B).shape)
--- options
(3, 3)
* (2, 4)
(4, 2)
(2, 3, 4)
--- explain
Apply the rule: $(2, \mathbf{3}) @ (\mathbf{3}, 4) \to (2, 4)$. The matching inner 3s vanish and the outer dimensions survive.
```

### `np.dot` versus `@`

For 1-D and 2-D arrays, `np.dot(A, B)` and `A @ B` give identical results. Prefer `@`: it reads like math, and it has the sensible behavior for stacks of matrices that you'll see next. `np.dot` treats 3-D arrays in a surprising way that is rarely what you want.

## Challenge: weighted course grades

```python exercise id=weighted-grade title="Compute every student's final grade"
# Rows are students; columns are: homework, midterm, final exam (out of 100)
scores = np.array([
    [92, 78, 85],
    [65, 88, 72],
    [80, 91, 94],
    [55, 60, 70],
    [99, 95, 89],
])
# Homework counts 20%, the midterm 30%, the final exam 50%
weights = np.array([0.2, 0.3, 0.5])

# TODO: one final grade per student, shape (5,), using a matrix product
grades = ...

# TODO: the index (row number) of the student with the highest grade
top_student = ...
--- solution
scores = np.array([
    [92, 78, 85],
    [65, 88, 72],
    [80, 91, 94],
    [55, 60, 70],
    [99, 95, 89],
])
weights = np.array([0.2, 0.3, 0.5])

grades = scores @ weights
top_student = grades.argmax()
--- test
assert grades is not ..., "Replace the `...` after `grades =` with your code."
assert isinstance(grades, np.ndarray), "`grades` should be a NumPy array."
assert grades.shape == (5,), f"`grades` should have one value per student, shape (5,), but has shape {grades.shape}. Check the order of the operands."
_expected = np.array([84.3, 75.4, 90.3, 64.0, 92.8])
assert np.allclose(grades, _expected), f"`grades` should be the weighted sum of each row. Got {np.round(grades, 2)}."
assert top_student is not ..., "Replace the `...` after `top_student =` with your code."
assert int(top_student) == 4, f"`top_student` should be the row index of the best grade, but it is {top_student!r}."
--- hint
Each final grade is `0.2*homework + 0.3*midterm + 0.5*final`, which is the dot product of a row with `weights`. A matrix product does that for every row at once.
--- hint
Shapes: `(5, 3) @ (3,)` gives `(5,)`. For the second part, remember `argmax` from the aggregations lesson.
```

## Stacks of matrices: batched `@`

In deep learning you rarely multiply just one matrix. You multiply a **batch** of them: one per image, per sentence or per attention head. `@` treats every dimension except the last two as a batch dimension, and those batch dimensions even **broadcast**:

```python run
rng = np.random.default_rng(0)

A = rng.normal(size=(8, 2, 3))   # 8 matrices, each 2x3
B = rng.normal(size=(8, 3, 5))   # 8 matrices, each 3x5
W = rng.normal(size=(3, 5))      # a single 3x5 matrix

print("batch @ batch :", (A @ B).shape)   # pairs them up: 8 products
print("batch @ single:", (A @ W).shape)   # W broadcasts across the batch

# Check one slice by hand
print("slice 3 matches:", np.allclose((A @ B)[3], A[3] @ B[3]))
```

The shape rule still applies to the last two axes, `(2, 3) @ (3, 5) → (2, 5)`, and the leading `8` comes along for the ride.

## Outer products

The dot product collapses two vectors into one number. The **outer product** does the opposite: it expands them into a matrix of every pairwise product, $(\mathbf{a}\mathbf{b}^\top)_{ij} = a_i b_j$.

```python run
a = np.array([1, 2, 3])
b = np.array([10, 20])

print(np.outer(a, b))
print()
# Same thing with broadcasting: a column (3, 1) times a row (1, 2)
print(a[:, None] * b[None, :])
```

A multiplication table is an outer product, and so is a matrix built from "every user times every item" scores.

## `np.einsum`: say exactly what you mean

Einstein summation describes an operation by **labelling the axes** of each input. Repeated labels are multiplied; labels missing from the output are summed. The string `"ij,jk->ik"` reads as: "the first input has axes *i, j*, the second has *j, k*; multiply along the shared *j*, sum it away, and return *i, k*." That's exactly matrix multiplication.

```python run
M = np.arange(9).reshape(3, 3)
v = np.array([1, 0, 2])

print("sum of all :", np.einsum("ij->", M), "=", M.sum())
print("trace      :", np.einsum("ii->", M), "=", np.trace(M))
print("transpose  :\n", np.einsum("ij->ji", M))
print("mat @ vec  :", np.einsum("ij,j->i", M, v), "=", M @ v)
print("dot        :", np.einsum("i,i->", v, v), "=", v @ v)
print("outer      :\n", np.einsum("i,j->ij", v, v))
```

Once you can read the labels, einsum turns complicated tensor contractions into one readable line. Here's a batched matrix product with an explicit batch axis `b`:

```python run
A = rng.normal(size=(8, 2, 3))
B = rng.normal(size=(8, 3, 5))

C = np.einsum("bij,bjk->bik", A, B)
print(C.shape, np.allclose(C, A @ B))
```

> **In the wild:** attention in a Transformer is often written as `np.einsum("bhqd,bhkd->bhqk", Q, K)` (batch, heads, queries, keys, head dimension). That's the same idea with more labels.

| einsum | Equivalent |
|---|---|
| `"i,i->"` | `a @ b` (dot product) |
| `"i,j->ij"` | `np.outer(a, b)` |
| `"ij->ji"` | `M.T` |
| `"ii->"` | `np.trace(M)` |
| `"ij,jk->ik"` | `A @ B` |
| `"ij,ij->i"` | `(A * B).sum(axis=1)` (row-wise dots) |

## Challenge: row-by-row dot products

```python exercise id=rowwise-dots title="Dot each row with its partner"
rng = np.random.default_rng(42)
queries = rng.normal(size=(6, 4))   # 6 query vectors
keys = rng.normal(size=(6, 4))      # 6 key vectors, paired by row

# TODO: scores[i] should be the dot product of queries[i] with keys[i]
# Result shape: (6,). Try np.einsum, but any correct approach works.
scores = ...
--- solution
rng = np.random.default_rng(42)
queries = rng.normal(size=(6, 4))
keys = rng.normal(size=(6, 4))

scores = np.einsum("ij,ij->i", queries, keys)
--- test
assert scores is not ..., "Replace the `...` after `scores =` with your code."
scores = np.asarray(scores)
_expected = (queries * keys).sum(axis=1)
assert scores.shape == (6,), f"`scores` should have one value per row, shape (6,), but has shape {scores.shape}. Note that `queries @ keys.T` computes *every* pair (6x6), not just matching rows."
assert np.allclose(scores, _expected), "`scores[i]` should be the dot product of `queries[i]` with `keys[i]`."
--- hint
You want the *diagonal* of the full pairwise product, but computing all 36 dot products only to keep 6 is wasteful.
--- hint
Multiply element-wise, then sum along the feature axis, or use einsum: both inputs are labelled `ij`, and you keep only `i`.
```

## Cosine similarity

Remember $\mathbf{a}\cdot\mathbf{b} = \lVert\mathbf{a}\rVert\lVert\mathbf{b}\rVert\cos\theta$? Rearranging gives **cosine similarity**, the standard way to compare embeddings in search engines and recommendation systems:

$$
\cos\theta = \frac{\mathbf{a}\cdot\mathbf{b}}{\lVert\mathbf{a}\rVert\,\lVert\mathbf{b}\rVert}
$$

It ranges from $-1$ (opposite) through $0$ (unrelated) to $1$ (same direction), and it ignores length: a vector and its double are perfectly similar.

```python run
v = np.array([1.0, 2.0, 2.0])
print("length of v:", np.sqrt(v @ v))   # 3.0; np.linalg.norm(v) does the same
print("v vs 2v    :", (v @ (2 * v)) / (np.sqrt(v @ v) * np.sqrt((2 * v) @ (2 * v))))
```

```python exercise id=cosine-similarity title="Write a cosine similarity function"
def cosine_similarity(a, b):
    """Return the cosine similarity between 1-D arrays a and b, as a float."""
    # TODO: dot product divided by the product of the two lengths
    ...

# Try it: these two "movie taste" vectors point in similar directions
alice = np.array([5.0, 1.0, 0.0, 4.0])
bob = np.array([4.0, 0.0, 1.0, 5.0])
print(cosine_similarity(alice, bob))
--- solution
def cosine_similarity(a, b):
    """Return the cosine similarity between 1-D arrays a and b, as a float."""
    return float(a @ b / (np.sqrt(a @ a) * np.sqrt(b @ b)))

alice = np.array([5.0, 1.0, 0.0, 4.0])
bob = np.array([4.0, 0.0, 1.0, 5.0])
print(cosine_similarity(alice, bob))
--- test
_r = cosine_similarity(np.array([1.0, 0.0]), np.array([1.0, 0.0]))
assert _r is not None, "`cosine_similarity` returned None. Did you forget `return`?"
assert np.isclose(_r, 1.0), f"Identical vectors should have similarity 1.0, got {_r!r}."
assert np.isclose(cosine_similarity(np.array([1.0, 0.0]), np.array([0.0, 3.0])), 0.0), "Perpendicular vectors should have similarity 0.0."
assert np.isclose(cosine_similarity(np.array([1.0, 2.0]), np.array([-2.0, -4.0])), -1.0), "Opposite vectors should have similarity -1.0."
assert np.isclose(cosine_similarity(np.array([3.0, 4.0]), np.array([6.0, 8.0])), 1.0), "Length shouldn't matter: a vector and its double have similarity 1.0. Are you dividing by both lengths?"
_rng = np.random.default_rng(7)
for _ in range(5):
    _a, _b = _rng.normal(size=10), _rng.normal(size=10)
    _want = _a @ _b / (np.linalg.norm(_a) * np.linalg.norm(_b))
    assert np.isclose(cosine_similarity(_a, _b), _want), "Your function gives the wrong answer on random vectors."
--- hint
You need three dot products: `a @ b`, `a @ a` and `b @ b`. The length of a vector is the square root of its dot product with itself.
--- hint
`return (a @ b) / (np.sqrt(a @ a) * np.sqrt(b @ b))`, then wrap it in `float(...)`.
```

## Debug challenge: rotating points

A 2-D rotation by angle $\theta$ is the matrix $R = \begin{pmatrix}\cos\theta & -\sin\theta\\ \sin\theta & \cos\theta\end{pmatrix}$. To rotate a point $\mathbf{p}$ you compute $R\mathbf{p}$. With points stored as **rows** of an `(n, 2)` array, rotating all of them at once is `points @ R.T`.

The code below is supposed to rotate two points by 90° counter-clockwise: $(1, 0) \to (0, 1)$ and $(0, 2) \to (-2, 0)$. It runs without any error, but the answer is wrong.

```python debug id=rotate-points title="The rotation runs, but the points end up in the wrong place"
theta = np.pi / 2   # 90 degrees
R = np.array([[np.cos(theta), -np.sin(theta)],
              [np.sin(theta),  np.cos(theta)]])

points = np.array([[1.0, 0.0],
                   [0.0, 2.0]])   # one point per row

rotated = points * R
print(np.round(rotated, 3))
--- solution
theta = np.pi / 2   # 90 degrees
R = np.array([[np.cos(theta), -np.sin(theta)],
              [np.sin(theta),  np.cos(theta)]])

points = np.array([[1.0, 0.0],
                   [0.0, 2.0]])   # one point per row

rotated = points @ R.T
print(np.round(rotated, 3))
--- test
assert rotated.shape == (2, 2), f"`rotated` should still hold 2 points of 2 coordinates, shape (2, 2), but has {rotated.shape}."
assert np.allclose(rotated[0], [0.0, 1.0]), f"(1, 0) rotated 90° should land on (0, 1), but landed on {np.round(rotated[0], 3)}."
assert np.allclose(rotated[1], [-2.0, 0.0]), f"(0, 2) rotated 90° should land on (-2, 0), but landed on {np.round(rotated[1], 3)}."
--- hint
`points` and `R` happen to both be 2×2, so `*` broadcasts silently. Is element-wise multiplication what a rotation needs?
--- hint
Rotating one point is `R @ p`. With points stacked as rows, transpose: `(R @ points.T).T`, which equals `points @ R.T`.
```

## A neural-network layer in one line

A dense ("fully connected") layer takes a batch of inputs `X` of shape `(batch, in_features)`, a weight matrix `W` of shape `(in_features, out_features)` and a bias `b` of shape `(out_features,)`, and computes

$$
Y = \mathrm{ReLU}(XW + \mathbf{b}), \qquad \mathrm{ReLU}(z) = \max(0, z)
$$

That's a matrix product, a broadcast addition of the bias to every row, and an element-wise maximum. Everything you've learned so far is in that one line.

```python run
rng = np.random.default_rng(1)
X = rng.normal(size=(4, 3))    # 4 samples, 3 features each
W = rng.normal(size=(3, 2))    # 3 inputs -> 2 outputs
b = np.array([0.1, -0.2])

Z = X @ W + b                  # (4, 3) @ (3, 2) -> (4, 2), then + (2,) broadcasts
Y = np.maximum(Z, 0)           # ReLU
print("Z shape:", Z.shape)
print(np.round(Y, 3))
```

```python exercise id=dense-layer title="Implement a two-layer network's forward pass"
def dense(X, W, b):
    """One dense layer with ReLU: max(0, X @ W + b)."""
    # TODO
    ...

def mlp(X, W1, b1, W2, b2):
    """Two layers: a ReLU hidden layer, then a linear output layer (no ReLU)."""
    # TODO: feed X through dense(...), then multiply by W2 and add b2
    ...

rng = np.random.default_rng(3)
X = rng.normal(size=(5, 4))
W1, b1 = rng.normal(size=(4, 8)), np.zeros(8)
W2, b2 = rng.normal(size=(8, 1)), np.array([0.5])
print(np.shape(mlp(X, W1, b1, W2, b2)))   # should be (5, 1)
--- solution
def dense(X, W, b):
    """One dense layer with ReLU: max(0, X @ W + b)."""
    return np.maximum(X @ W + b, 0)

def mlp(X, W1, b1, W2, b2):
    """Two layers: a ReLU hidden layer, then a linear output layer (no ReLU)."""
    return dense(X, W1, b1) @ W2 + b2

rng = np.random.default_rng(3)
X = rng.normal(size=(5, 4))
W1, b1 = rng.normal(size=(4, 8)), np.zeros(8)
W2, b2 = rng.normal(size=(8, 1)), np.array([0.5])
print(np.shape(mlp(X, W1, b1, W2, b2)))
--- test
_rng = np.random.default_rng(11)
_X = _rng.normal(size=(7, 3))
_W = _rng.normal(size=(3, 4))
_b = _rng.normal(size=4)
_d = dense(_X, _W, _b)
assert _d is not None, "`dense` returned None. Did you forget `return`?"
_d = np.asarray(_d)
assert _d.shape == (7, 4), f"`dense` on a (7, 3) batch with a (3, 4) weight matrix should return shape (7, 4), got {_d.shape}."
assert (_d >= 0).all(), "`dense` should apply ReLU, so no output can be negative."
assert np.allclose(_d, np.maximum(_X @ _W + _b, 0)), "`dense` should compute max(0, X @ W + b). Is the bias added before the ReLU?"
_W2 = _rng.normal(size=(4, 2))
_b2 = np.array([-5.0, 5.0])
_m = mlp(_X, _W, _b, _W2, _b2)
assert _m is not None, "`mlp` returned None. Did you forget `return`?"
_m = np.asarray(_m)
assert _m.shape == (7, 2), f"`mlp` should return shape (7, 2) here, got {_m.shape}."
_want = np.maximum(_X @ _W + _b, 0) @ _W2 + _b2
assert np.allclose(_m, _want), "`mlp` gives the wrong numbers. The output layer is linear: no ReLU after `@ W2 + b2`."
--- hint
`np.maximum(a, 0)` is ReLU: it compares element-wise and keeps the larger value. Don't confuse it with `np.max`, which reduces an array to one number.
--- hint
`mlp` is `dense(X, W1, b1) @ W2 + b2`. Remember to `return` from both functions.
```

## Recap

- The dot product multiplies matching entries and sums them: $\mathbf{a}\cdot\mathbf{b} = \sum_i a_i b_i$. It's the core operation of linear models and neural networks.
- `*` is element-wise; `@` is matrix multiplication. Mixing them up often fails **silently**.
- The shape rule: $(n, k) @ (k, m) \to (n, m)$. Inner dimensions must match and disappear.
- `@` treats leading axes as a **batch**, and they broadcast. Prefer `@` over `np.dot`.
- `np.einsum` labels axes: repeated labels multiply, and labels missing from the output are summed.
- Cosine similarity, $\frac{\mathbf{a}\cdot\mathbf{b}}{\lVert\mathbf{a}\rVert\lVert\mathbf{b}\rVert}$, compares directions regardless of length.

**Up next:** `np.linalg`, for solving systems of equations, decompositions, and why you should almost never call `inv`.
