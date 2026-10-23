Now the pieces come together. You have a forward pass, a loss, and the backward formulas for a dense layer. In this lesson you will train a **multi-layer perceptron** (MLP), a network with a hidden layer, on a problem that a single neuron cannot solve. You will watch the loss fall, see the decision boundary bend around the data, and then rebuild the key steps yourself.

## A problem a line cannot solve

The "two moons" dataset is two interleaved crescents. No straight line separates them, so a single neuron from lesson 2 will fail. A hidden layer of non-linear units can bend the boundary into the right shape.

```python run
import matplotlib.pyplot as plt

def make_moons(n=200, noise=0.15, seed=0):
    rng = np.random.default_rng(seed)
    t = np.linspace(0, np.pi, n // 2)
    upper = np.column_stack([np.cos(t), np.sin(t)])
    lower = np.column_stack([1 - np.cos(t), 0.5 - np.sin(t)])
    X = np.vstack([upper, lower]) + rng.normal(0, noise, size=(n, 2))
    y = np.concatenate([np.zeros(n // 2), np.ones(n // 2)])
    return X, y

X, y = make_moons()
y2 = y.reshape(-1, 1)            # one column of labels, shape (n, 1)

fig, ax = plt.subplots(figsize=(4.5, 4))
ax.scatter(X[y == 0, 0], X[y == 0, 1], label="class 0")
ax.scatter(X[y == 1, 0], X[y == 1, 1], label="class 1")
ax.legend(); ax.grid(alpha=0.3)
plt.show()
```

## The network

The model has 2 inputs, 16 hidden units with `tanh`, and one output unit with a sigmoid that gives a probability. Its parameters live in a dictionary so the code stays readable.

```python run
def init_params(rng, n_in=2, n_hidden=16):
    return {
        "W1": rng.normal(0, 0.5, size=(n_in, n_hidden)),
        "b1": np.zeros(n_hidden),
        "W2": rng.normal(0, 0.5, size=(n_hidden, 1)),
        "b2": np.zeros(1),
    }

def forward(X, p):
    Z1 = X @ p["W1"] + p["b1"]
    A1 = np.tanh(Z1)
    Z2 = A1 @ p["W2"] + p["b2"]
    P = 1 / (1 + np.exp(-Z2))
    return A1, P

def bce(P, Y):
    P = np.clip(P, 1e-12, 1 - 1e-12)
    return -np.mean(Y * np.log(P) + (1 - Y) * np.log(1 - P))

params = init_params(np.random.default_rng(1))
for name, value in params.items():
    print(name, value.shape)

A1, P = forward(X, params)
print("initial loss:", round(bce(P, y2), 4), "(about log 2 = 0.6931 for untrained output)")
```

Look at the initial loss. A network that has learned nothing outputs probabilities near one half, and the binary cross-entropy is near $\log 2$. Training has to move it well below that.

## Backpropagation, step by step

For a sigmoid output with binary cross-entropy, the gradient with respect to the output pre-activation has a famously simple form: $dZ_2 = (P - Y)/n$. The hidden layer then passes that gradient back through $W_2$ and the tanh derivative $1 - A_1^2$. Each step is one of the formulas from lesson 9.

```python run
def backward(X, Y, p, A1, P):
    n = X.shape[0]
    dZ2 = (P - Y) / n
    dW2 = A1.T @ dZ2
    db2 = dZ2.sum(axis=0)
    dA1 = dZ2 @ p["W2"].T
    dZ1 = dA1 * (1 - A1 ** 2)
    dW1 = X.T @ dZ1
    db1 = dZ1.sum(axis=0)
    return {"W1": dW1, "b1": db1, "W2": dW2, "b2": db2}

grads = backward(X, y2, params, A1, P)
for name in grads:
    print("grad", name, grads[name].shape, "matches parameter", params[name].shape)
```

## Train it

```python run
rng = np.random.default_rng(1)
params = init_params(rng)
lr = 0.5
losses = []
for epoch in range(1200):
    A1, P = forward(X, params)
    losses.append(bce(P, y2))
    grads = backward(X, y2, params, A1, P)
    for name in params:
        params[name] = params[name] - lr * grads[name]

A1, P = forward(X, params)
accuracy = np.mean((P > 0.5) == y2)
print("loss after 1200 epochs:", round(losses[-1], 4))
print("training accuracy:", round(float(accuracy), 3))
```

A training run is this loop: forward, loss, backward, update. Every deep network you will ever train is this loop with more layers, more data and a fancier update rule.

## See the boundary

```python run
gx, gy = np.meshgrid(np.linspace(-2, 3, 200), np.linspace(-1.5, 2, 200))
grid = np.column_stack([gx.ravel(), gy.ravel()])
_, Pgrid = forward(grid, params)
fig, ax = plt.subplots(figsize=(5, 4))
ax.contourf(gx, gy, Pgrid.reshape(gx.shape), levels=[0, 0.5, 1], alpha=0.25)
ax.scatter(X[y == 0, 0], X[y == 0, 1], s=12, label="class 0")
ax.scatter(X[y == 1, 0], X[y == 1, 1], s=12, label="class 1")
ax.legend(); ax.grid(alpha=0.3)
plt.show()
```

The boundary now curves around the crescents. A single neuron could never draw this.

## Challenge: the output gradient

```python exercise id=output-grad title="The output gradient for sigmoid and cross-entropy"
# TODO: `output_grad(P, Y)` returns dZ2 = (P - Y) / n, where n is the number of examples.
def output_grad(P, Y):
    ...
--- solution
def output_grad(P, Y):
    return (P - Y) / P.shape[0]
--- test
P_t = np.array([[0.8], [0.2], [0.5], [0.9]])
Y_t = np.array([[1.0], [0.0], [1.0], [1.0]])
result = output_grad(P_t, Y_t)
assert result is not None, "Replace the `...` in `output_grad` with code that returns dZ2."
assert result.shape == (4, 1), f"dZ2 should have shape (4, 1), but it has {result.shape}."
assert np.allclose(result, np.array([[-0.05], [0.05], [-0.125], [-0.025]])), f"With n = 4 the gradient should be (P - Y) / 4 = [-0.05, 0.05, -0.125, -0.025], but you returned {result.ravel()}."
--- hint
The gradient is the prediction minus the label, divided by the number of examples: `(P - Y) / n`.
--- hint
`n = P.shape[0]`, then `return (P - Y) / n`.
```

## Challenge: the hidden-layer gradient

```python exercise id=hidden-grad title="Pass the gradient through the hidden layer"
# TODO: `hidden_grad(dZ2, W2, A1)` returns dZ1 = (dZ2 @ W2ᵀ) * (1 - A1²), the gradient with respect
# to the hidden layer's pre-activation. Here A1 = tanh(Z1), so 1 - A1² is the tanh derivative.
def hidden_grad(dZ2, W2, A1):
    ...
--- solution
def hidden_grad(dZ2, W2, A1):
    return (dZ2 @ W2.T) * (1 - A1 ** 2)
--- test
dZ2_t = np.array([[0.5], [-1.0]])
W2_t = np.array([[2.0], [0.0], [-1.0]])
A1_t = np.array([[0.0, 0.5, 1.0], [0.6, -0.8, 0.0]])
result = hidden_grad(dZ2_t, W2_t, A1_t)
assert result is not None, "Replace the `...` in `hidden_grad` with code that returns dZ1."
assert result.shape == (2, 3), f"dZ1 should have the shape of the hidden layer, (2, 3), but it has {result.shape}."
expected = (dZ2_t @ W2_t.T) * (1 - A1_t ** 2)
assert np.allclose(result, expected), f"Expected {expected}, but you returned {result}. Multiply by the tanh derivative 1 - A1²."
--- hint
First pass the gradient back through the weights: `dZ2 @ W2.T`. Then multiply elementwise by the tanh derivative, computed from `A1`.
--- hint
`return (dZ2 @ W2.T) * (1 - A1 ** 2)`. The `*` is elementwise, not a matrix product.
```

## Challenge: accuracy

```python exercise id=accuracy title="Classification accuracy"
# TODO: `accuracy(P, Y)` returns the fraction of examples whose predicted class is correct.
# Predict class 1 when P > 0.5. P and Y both have shape (n, 1).
def accuracy(P, Y):
    ...
--- solution
def accuracy(P, Y):
    return float(np.mean((P > 0.5) == Y))
--- test
P_t = np.array([[0.9], [0.4], [0.7], [0.1]])
Y_t = np.array([[1.0], [1.0], [0.0], [0.0]])
result = accuracy(P_t, Y_t)
assert result is not None, "Replace the `...` in `accuracy` with code that returns a fraction."
assert np.isclose(result, 0.5), f"Two of four predictions are correct, so the accuracy is 0.5, but you returned {result!r}."
assert np.isclose(accuracy(np.array([[0.6], [0.2]]), np.array([[1.0], [0.0]])), 1.0), "Both predictions are correct, so the accuracy should be 1.0."
--- hint
Compare the thresholded predictions `P > 0.5` with the labels, then take the mean of the comparison.
--- hint
`return float(np.mean((P > 0.5) == Y))`.
```

## Debug the sign of the gradient

```python debug id=output-sign title="Which way is downhill?"
P = np.array([[0.8], [0.2]])
Y = np.array([[1.0], [0.0]])
n = P.shape[0]
dZ2 = (Y - P) / n            # the gradient is for the loss, so which way is it?
print("dZ2:", dZ2.ravel())
--- solution
P = np.array([[0.8], [0.2]])
Y = np.array([[1.0], [0.0]])
n = P.shape[0]
dZ2 = (P - Y) / n
print("dZ2:", dZ2.ravel())
--- test
assert np.allclose(dZ2, np.array([[-0.1], [0.1]])), f"With P = [0.8, 0.2] and Y = [1, 0], dZ2 should be [-0.1, 0.1], but it is {dZ2.ravel()}. The gradient is prediction minus label."
--- hint
Compare the order of subtraction with the gradient formula `(P - Y) / n`. Which one matches a loss that is too high when P is too high?
--- hint
Subtract the label from the prediction: `(P - Y) / n`.
```

## Predict the first update

```python predict id=predict-first-step title="Which way does the weight move?"
dZ2 = np.array([[-0.1], [0.1]])
A1 = np.array([[0.5], [-0.5]])
dW2 = A1.T @ dZ2
print(dW2.round(2))
--- options
* [[-0.1]]
[[0.1]]
[[0.0]]
[[0.5]]
--- explain
The product is 0.5 × (-0.1) + (-0.5) × 0.1 = -0.05 - 0.05 = -0.1. The gradient is negative, so the update lr × dW2 subtracts a negative number and the weight increases. That is the correct direction for this example's loss.
```

## Recap

- A multi-layer network learns a curved boundary that one neuron cannot draw.
- Training is the loop: forward pass, loss, backward pass, parameter update.
- With a sigmoid output and cross-entropy, the output gradient is simply $(P - Y)/n$.
- The hidden gradient is the output gradient passed back through the weights and multiplied by the activation's derivative.

**Up next:** optimizers. Plain gradient descent is slow on badly scaled problems, and momentum and Adam fix that.
