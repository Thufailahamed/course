The **forward pass** is the prediction step of a neural network: data flows from the inputs through each layer to the output. It is nothing more than a sequence of matrix products and activations, and once you can write it, you can read any architecture you meet, from a small classifier to a large language model.

In this lesson you will build a dense layer, stack two of them into a network, and push a whole batch through at once. Almost every bug in this stage is a shape bug, so you will learn to track shapes on every line.

## A dense layer is one matrix product

A **dense** (fully connected) layer takes $d$ inputs and produces $h$ outputs. Each output is a weighted sum of all the inputs, so the layer has a weight matrix $W$ of shape $(d, h)$ and a bias vector $b$ of shape $(h,)$. For a batch of $n$ examples stored as rows of $X$:

$$
Z = X W + b, \qquad X \in \mathbb{R}^{n \times d},\; W \in \mathbb{R}^{d \times h},\; Z \in \mathbb{R}^{n \times h}
$$

```python run
n, d, h = 5, 3, 4          # 5 examples, 3 input features, 4 outputs
rng = np.random.default_rng(0)
X = rng.normal(size=(n, d))
W = rng.normal(size=(d, h))
b = np.zeros(h)

Z = X @ W + b
print("X:", X.shape, "  W:", W.shape, "  b:", b.shape, "  Z:", Z.shape)
```

Read the shapes out loud: the inner dimensions match ($d$ and $d$) and the outer dimensions give the result ($n$ by $h$). This rule never changes, however big the network.

Shape errors are the first thing to check when a network misbehaves. Here is a deliberately wrong attempt to apply `W` to a single example, which fails in a useful way:

```python run error
x_single = X[0]                 # shape (3,)
W_wrong = rng.normal(size=(4, 3))
Z_wrong = W_wrong @ X           # the matrix is on the wrong side
print(Z_wrong.shape)
```

## Two layers and a non-linearity

A network is layers in sequence. A hidden layer applies a non-linear activation, here ReLU from the last lesson, and then the next layer reads its output.

```python run
def relu(z):
    return np.maximum(0, z)

W1 = rng.normal(size=(3, 8)) * 0.5
b1 = np.zeros(8)
W2 = rng.normal(size=(8, 2)) * 0.5
b2 = np.zeros(2)

H = relu(X @ W1 + b1)      # hidden layer: (5, 8)
Y = H @ W2 + b2            # output layer: (5, 2)
print("hidden:", H.shape, "| output:", Y.shape)
print("first example's output:", np.round(Y[0], 3))
```

Every row of `Y` is the network's answer for one example. Nothing in this cell is special to two layers: add another line, and you have a deeper network.

## Batching is faster and more honest

You could loop over the examples, but NumPy is built for the matrix form. The loop and the batch compute the same numbers, and the batch is much faster. Check it:

```python run
loop_out = np.stack([relu(x @ W1 + b1) @ W2 + b2 for x in X])
batch_out = relu(X @ W1 + b1) @ W2 + b2
print("loop and batch agree:", np.allclose(loop_out, batch_out))
```

> **Under the hood:** GPUs and CPUs get their speed from large matrix products. Every framework you will use, including PyTorch, expresses the forward pass as these batched products for exactly this reason.

## Challenge: a dense layer

```python exercise id=dense-layer title="Write a dense layer"
# TODO: `dense(X, W, b)` should return X @ W + b for a batch X of shape (n, d).
def dense(X, W, b):
    ...
--- solution
def dense(X, W, b):
    return X @ W + b
--- test
X_test = np.array([[1.0, 2.0], [0.0, -1.0], [3.0, 0.5]])
W_test = np.array([[1.0, 0.0, -1.0], [0.5, 2.0, 1.0]])
b_test = np.array([0.1, 0.2, 0.3])
result = dense(X_test, W_test, b_test)
assert result is not None, "Replace the `...` in `dense` with code that returns the layer output."
assert result.shape == (3, 3), f"X has 3 rows and W has 3 columns, so the output should be (3, 3), but it has shape {result.shape}."
expected = X_test @ W_test + b_test
assert np.allclose(result, expected), "The output should be X @ W + b, with the bias added to every row."
X_other = np.ones((4, 2))
assert np.allclose(dense(X_other, W_test, np.zeros(3)), X_other @ W_test), "Check that the bias is optional when it is zero, and that the function works for any batch size."
--- hint
Use the matrix product `X @ W`, then add the bias. The bias has one entry per output, so it is broadcast to every row.
--- hint
`return X @ W + b`.
```

## Challenge: a two-layer forward pass

```python exercise id=two-layer title="Forward pass through two layers"
# TODO: `forward(X, W1, b1, W2, b2)` should apply a dense layer, then ReLU, then a second dense layer.
# It returns the output array of shape (n, k).
def forward(X, W1, b1, W2, b2):
    ...
--- solution
def forward(X, W1, b1, W2, b2):
    H = np.maximum(0, X @ W1 + b1)
    return H @ W2 + b2
--- test
X_test = np.array([[1.0, -1.0], [2.0, 0.5]])
W1_test = np.array([[1.0, -2.0, 0.0], [1.0, 1.0, 0.5]])
b1_test = np.zeros(3)
W2_test = np.array([[1.0], [-1.0], [2.0]])
b2_test = np.array([0.5])
result = forward(X_test, W1_test, b1_test, W2_test, b2_test)
assert result is not None, "Replace the `...` in `forward` with code that returns the network output."
assert result.shape == (2, 1), f"The output should have shape (2, 1) for 2 examples and 1 output, but it has {result.shape}."
hidden = np.maximum(0, X_test @ W1_test + b1_test)
assert np.allclose(result, hidden @ W2_test + b2_test), "The output should be the second layer applied to the ReLU of the first layer."
rng_t = np.random.default_rng(3)
X3 = rng_t.normal(size=(6, 2))
W1_3 = rng_t.normal(size=(2, 5)); W2_3 = rng_t.normal(size=(5, 3))
out3 = forward(X3, W1_3, np.zeros(5), W2_3, np.zeros(3))
assert out3.shape == (6, 3), f"For 6 examples and 3 outputs the shape should be (6, 3), but it is {out3.shape}."
--- hint
Compute the hidden layer first: `H = ` the ReLU of `X @ W1 + b1`. Then apply the second layer to `H`.
--- hint
`H = np.maximum(0, X @ W1 + b1)`, then `return H @ W2 + b2`.
```

## Debug a broadcasting bug

NumPy's **broadcasting** rules quietly stretch arrays to fit each other. That is convenient, and it is also a classic source of silent bugs. The code below runs without an error, but the result is wrong.

```python debug id=broadcast-bias title="The bias is on the wrong axis"
X = np.array([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])     # 3 examples
W = np.array([[0.1, 0.2, 0.3], [0.4, 0.5, 0.6]])        # 2 inputs, 3 outputs
b = np.array([1.0, 2.0, 3.0])                           # one bias per output

Z = X @ W
Z_bad = Z + b.reshape(-1, 1)      # the bias is added along the wrong axis
print("shape:", Z_bad.shape)
print(Z_bad)
--- solution
X = np.array([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])     # 3 examples
W = np.array([[0.1, 0.2, 0.3], [0.4, 0.5, 0.6]])        # 2 inputs, 3 outputs
b = np.array([1.0, 2.0, 3.0])                           # one bias per output

Z = X @ W
Z_bad = Z + b
print("shape:", Z_bad.shape)
print(Z_bad)
--- test
assert Z_bad.shape == (3, 3), f"The output should keep shape (3, 3), but it has {Z_bad.shape}."
expected = X @ W + b
assert np.allclose(Z_bad, expected), "Each output column should get its own bias. The bias must be broadcast across the rows, not down the columns."
--- hint
Compare the shape of `b.reshape(-1, 1)` with the shape of `Z`. A column of biases adds one value per row, which is not what you want here.
--- hint
A bias of shape `(3,)` already broadcasts across the rows of `Z`. You do not need to reshape it.
```

## Predict the shape

```python predict id=predict-broadcast title="What shape does broadcasting give?"
a = np.ones((3, 1))
b = np.arange(4)
print((a + b).shape)
--- options
* (3, 4)
(4,)
(3,)
(3, 1)
--- explain
A column of shape (3, 1) and a row of shape (4,) broadcast to (3, 4). Each of the three rows of `a` is paired with all four entries of `b`. This is a useful trick, and an easy source of bugs when you wanted something else.
```

## Pitfall: check the shape before the values

> **Pitfall:** when a network produces a surprising loss, print the shape of every intermediate array first. Most "numerical" problems are shape problems in disguise, and broadcasting will hide them if you do not look.

## Recap

- A dense layer computes $XW + b$ for a batch, and the shapes must satisfy $(n, d) \cdot (d, h)$.
- A network is layers in sequence: linear, then non-linear, then linear again.
- Batch the computation with matrix products. Looping over examples gives the same numbers, only much slower.
- Broadcasting stretches arrays silently. Check shapes at every step, and be suspicious when something runs without an error.

**Up next:** loss functions. You will measure how wrong the output is, and the loss you choose changes what the network learns.
