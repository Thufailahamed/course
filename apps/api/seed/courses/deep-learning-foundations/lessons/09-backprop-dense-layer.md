The autograd engine works on single numbers. Real networks work on matrices, and processing one example at a time would be far too slow. The good news is that the backward pass of a dense layer is only three matrix products, and each one has a clear meaning. In this lesson you will derive them, implement them, and check them against numerical gradients, so you can trust the code you run to train a network.

## The shapes tell you the answer

For a dense layer $Z = X W + b$, with inputs $X$ of shape $(n, d)$, weights $W$ of shape $(d, h)$ and bias $b$ of shape $(h,)$, suppose the loss gives you the gradient of the loss with respect to the output, $\partial L / \partial Z$, of shape $(n, h)$. Call it $dZ$.

Then the three gradients must have the same shapes as the things they are gradients of:

$$
dW = X^{\top} dZ \quad (d, h), \qquad
db = \sum_{i=1}^{n} dZ_i \quad (h,), \qquad
dX = dZ \, W^{\top} \quad (n, d)
$$

Shapes alone can pin down the transposes. If you get a shape wrong, the matrix product will fail or give the wrong shape, and that is your first clue.

## Derive the weight gradient

Take one weight $W_{jk}$. It affects output $Z_{ik}$ by multiplying the input $X_{ij}$. Summing over the batch gives $\partial L / \partial W_{jk} = \sum_i X_{ij} \, dZ_{ik}$, which is exactly the $(j, k)$ entry of $X^{\top} dZ$.

```python run
import numpy as np

rng = np.random.default_rng(0)
n, d, h = 4, 3, 2
X = rng.normal(size=(n, d))
W = rng.normal(size=(d, h))
b = np.zeros(h)
G = rng.normal(size=(n, h))        # a fixed "upstream" gradient, to test against

def loss(W):
    Z = X @ W + b
    return np.sum(Z * G)           # a simple scalar whose gradient w.r.t. Z is G

dW = X.T @ G                       # the formula
h_step = 1e-6
numeric = np.zeros_like(W)
for j in range(d):
    for k in range(h):
        E = np.zeros_like(W); E[j, k] = h_step
        numeric[j, k] = (loss(W + E) - loss(W - E)) / (2 * h_step)
print("max difference:", np.max(np.abs(dW - numeric)))
```

A difference near $10^{-9}$ means the formula is right. This is the check you will reuse for every layer you write.

## Derive the bias and input gradients

The bias is added to every row, so its gradient sums over the batch. The input gradient passes the output gradient back through the transposed weights:

```python run
db = G.sum(axis=0)
dX = G @ W.T
print("db shape:", db.shape, "(one per output)")
print("dX shape:", dX.shape, "(same as X)")
```

> **Pitfall:** `db` must sum over the batch, not keep it. A bias gradient with shape `(n, h)` is a bug that often still runs, because broadcasting quietly accepts it.

## A full layer with ReLU

A hidden layer adds an activation, $A = \operatorname{relu}(Z)$. Its backward pass multiplies the incoming gradient by the ReLU derivative from lesson 3: pass the gradient through where $Z > 0$, and block it elsewhere.

```python run
def relu(z):
    return np.maximum(0, z)

X = rng.normal(size=(5, 3))
W1 = rng.normal(size=(3, 4)) * 0.5
b1 = np.zeros(4)

Z1 = X @ W1 + b1
A1 = relu(Z1)
dA1 = rng.normal(size=A1.shape)          # pretend this came from the next layer
dZ1 = dA1 * (Z1 > 0)                     # the ReLU backward rule
dW1 = X.T @ dZ1
db1 = dZ1.sum(axis=0)
print("dW1:", dW1.shape, "| db1:", db1.shape)
print("gradient blocked by ReLU in", np.sum(Z1 <= 0), "of", Z1.size, "entries")
```

## Check the whole layer

```python run
def layer_loss(W1_try):
    return np.sum(relu(X @ W1_try + b1) * dA1)

eps = 1e-6
num = np.zeros_like(W1)
for j in range(W1.shape[0]):
    for k in range(W1.shape[1]):
        E = np.zeros_like(W1); E[j, k] = eps
        num[j, k] = (layer_loss(W1 + E) - layer_loss(W1 - E)) / (2 * eps)
print("max difference for dW1:", np.max(np.abs(dW1 - num)))
```

Every gradient in the layer is now verified. A gradient check is the standard way to find a broken backward pass, and it takes a few lines.

## Challenge: the dense backward pass

```python exercise id=dense-backward title="Backward pass of a dense layer"
# TODO: `dense_backward(X, W, dZ)` returns the tuple (dX, dW, db) for the layer Z = X @ W + b.
# dX has the shape of X, dW the shape of W, and db has one entry per output.
def dense_backward(X, W, dZ):
    ...
--- solution
def dense_backward(X, W, dZ):
    dX = dZ @ W.T
    dW = X.T @ dZ
    db = dZ.sum(axis=0)
    return dX, dW, db
--- test
rng_t = np.random.default_rng(7)
X_t = rng_t.normal(size=(4, 3))
W_t = rng_t.normal(size=(3, 2))
dZ_t = rng_t.normal(size=(4, 2))
result = dense_backward(X_t, W_t, dZ_t)
assert result is not None, "Replace the `...` in `dense_backward` with code that returns (dX, dW, db)."
dX, dW, db = result
assert dX.shape == X_t.shape, f"dX should have the shape of X, {X_t.shape}, but it has {dX.shape}."
assert dW.shape == W_t.shape, f"dW should have the shape of W, {W_t.shape}, but it has {dW.shape}."
assert db.shape == (2,), f"db should have one entry per output, shape (2,), but it has {db.shape}. Sum over the batch."
assert np.allclose(dW, X_t.T @ dZ_t), "dW should be Xᵀ dZ."
assert np.allclose(dX, dZ_t @ W_t.T), "dX should be dZ Wᵀ."
assert np.allclose(db, dZ_t.sum(axis=0)), "db should be the sum of dZ over the batch."
--- hint
Write the three formulas from the lesson: `dX = dZ @ W.T`, `dW = X.T @ dZ`, and `db = dZ.sum(axis=0)`.
--- hint
Transposes are the only tricky part. The input gradient transposes `W`, and the weight gradient transposes `X`.
```

## Challenge: the ReLU backward pass

```python exercise id=relu-backward title="Backward pass of ReLU"
# TODO: `relu_backward(dA, Z)` returns the gradient with respect to Z: dA where Z > 0, and 0 elsewhere.
def relu_backward(dA, Z):
    ...
--- solution
def relu_backward(dA, Z):
    return dA * (Z > 0)
--- test
dA_t = np.array([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]])
Z_t = np.array([[-1.0, 0.5, 0.0], [2.0, -3.0, 1.0]])
result = relu_backward(dA_t, Z_t)
assert result is not None, "Replace the `...` in `relu_backward` with code that returns dZ."
assert np.allclose(result, [[0.0, 2.0, 0.0], [4.0, 0.0, 6.0]]), f"Only entries with Z > 0 should pass the gradient through. You returned {result}."
assert result.shape == dA_t.shape, "The gradient should keep the shape of dA."
--- hint
Multiply `dA` by a boolean mask made from `Z > 0`. NumPy multiplies booleans as 0 and 1.
--- hint
`return dA * (Z > 0)`. At exactly zero the gradient is blocked, which matches the derivative used in lesson 3.
```

## Debug the weight gradient

```python debug id=transpose-dw title="Transpose the right matrix"
rng_d = np.random.default_rng(2)
X = rng_d.normal(size=(6, 3))       # 6 examples, 3 inputs
dZ = rng_d.normal(size=(6, 2))      # 6 examples, 2 outputs
W = rng_d.normal(size=(3, 2))       # the weights have shape (3, 2)

dW = dZ.T @ X                        # the weight gradient must match W's shape
print("dW shape:", dW.shape, "| W shape:", W.shape)
--- solution
rng_d = np.random.default_rng(2)
X = rng_d.normal(size=(6, 3))       # 6 examples, 3 inputs
dZ = rng_d.normal(size=(6, 2))      # 6 examples, 2 outputs
W = rng_d.normal(size=(3, 2))       # the weights have shape (3, 2)

dW = X.T @ dZ                        # the weight gradient must match W's shape
print("dW shape:", dW.shape, "| W shape:", W.shape)
--- test
assert dW.shape == W.shape, f"dW must have the same shape as W, {W.shape}, but it has {dW.shape}."
assert np.allclose(dW, X.T @ dZ), "dW should be Xᵀ dZ, the sum over the batch of the input times the output gradient."
--- hint
Work out the shape of each product. `X.T @ dZ` is `(3, 6) @ (6, 2)`, which gives `(3, 2)`, the shape of W.
--- hint
Which matrix needs transposing so that the batch dimension is summed over? In `dZ.T @ X`, the batch is not the one being summed.
```

## Predict the shape

```python predict id=predict-dw title="What shape is the weight gradient?"
X = np.ones((10, 4))     # 10 examples, 4 inputs
dZ = np.ones((10, 3))    # 10 examples, 3 outputs
print((X.T @ dZ).shape)
--- options
* (4, 3)
(10, 3)
(3, 4)
(10, 4)
--- explain
Xᵀ has shape (4, 10) and dZ has shape (10, 3), so the product is (4, 3). That is the shape of the weight matrix of a layer with 4 inputs and 3 outputs, so the shapes line up.
```

## Recap

- For $Z = XW + b$, the gradients are $dW = X^{\top} dZ$, $db = \sum dZ$, and $dX = dZ\, W^{\top}$.
- Each gradient has the shape of the thing it differentiates. Use shapes to catch mistakes early.
- The ReLU backward pass multiplies by a mask: gradients pass through only where the input was positive.
- Verify every layer with a numerical gradient check before you use it to train.

**Up next:** the first checkpoint quiz, and then you will train a full multi-layer network with these pieces.
