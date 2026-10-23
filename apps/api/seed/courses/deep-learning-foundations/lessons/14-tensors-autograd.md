Everything you built by hand in the last section now has a professional home. **PyTorch** is the framework most research and production deep learning is written in, and its core is two ideas you already know: a **tensor**, which is an array that can live on a GPU, and **autograd**, which is the autograd engine from lesson 8 running at industrial scale.

In this lesson you will learn the PyTorch versions of the operations you wrote in NumPy, how `requires_grad` and `backward()` replace your hand-written gradients, and why gradients must be cleared between steps. The PyTorch code below is for you to run on your own machine, because the browser runtime does not include PyTorch. Every idea also has a runnable NumPy cell, so you can check the behavior right here.

> **Running the PyTorch code:** `pip install torch` gives you everything in this lesson. The code is static here, so it will not run in the page.

## Tensors are NumPy arrays with extras

A PyTorch tensor has a shape, a data type and, optionally, a device such as a GPU. The operations look almost the same.

| NumPy | PyTorch | Meaning |
|---|---|---|
| `np.array(...)` | `torch.tensor(...)` | create an array from data |
| `x.shape` | `x.shape` | the size of each dimension |
| `x @ w` | `x @ w` | matrix product |
| `x.T` | `x.T` | transpose |
| `x.reshape(...)` | `x.reshape(...)` or `x.view(...)` | change the shape |
| `np.maximum(0, x)` | `torch.clamp(x, min=0)` or `torch.relu(x)` | ReLU |
| `x.sum(axis=0)` | `x.sum(dim=0)` | sum over a dimension |
| `x.astype(float)` | `x.float()` | change the data type |

The biggest practical difference is the default precision. NumPy uses 64-bit floats. PyTorch uses 32-bit floats by default, which is faster and uses less memory, and which is usually enough for training.

```python
import torch

x = torch.tensor([[1.0, 2.0], [3.0, 4.0]])   # float32 by default
print(x.dtype, x.shape)                       # torch.float32 torch.Size([2, 2])

w = torch.ones(2, 1)
print((x @ w).shape)                          # torch.Size([2, 1])
```

The table is easy to check with arrays you can run here:

```python run
x64 = np.array([[1.0, 2.0], [3.0, 4.0]])
x32 = x64.astype(np.float32)
print("dtypes:", x64.dtype, x32.dtype)
print("reshape to (4,):", x64.reshape(4))
print("transpose, flattened:", x64.T.ravel())
```

```python run
# A batch of 2 greyscale images, each 3 × 3 pixels
images = np.arange(2 * 3 * 3, dtype=float).reshape(2, 3, 3)
flat = images.reshape(images.shape[0], -1)     # one row per image, as a dense layer expects
print("images:", images.shape, "-> flat:", flat.shape)
```

```python run
# Broadcasting in a batch: one bias added to every row
bias = np.array([10.0, 20.0])
print(x64 + bias)
```

## Autograd: `requires_grad` and `backward()`

Set `requires_grad=True` on the tensors you want gradients for. PyTorch then records every operation on them, just like your `Value` class, and `backward()` fills in each tensor's `.grad`.

```python
import torch

x = torch.tensor([[1.0, 2.0], [3.0, 4.0]])
w = torch.ones(2, 1, requires_grad=True)

y = (x @ w).sum()          # a scalar
y.backward()               # compute dy/dw by walking the recorded graph

print(w.grad)              # tensor([[4.], [6.]]), the column sums of x
```

The NumPy version of the same calculation is one line. Here is the check, runnable in the page:

```python run
x = np.array([[1.0, 2.0], [3.0, 4.0]])
w = np.ones((2, 1))

y = (x @ w).sum()
grad_w = x.sum(axis=0).reshape(2, 1)   # the gradient of y with respect to w
print("y =", y)
print("dy/dw =", grad_w.ravel())
```

Each entry of `w` multiplies one column of `x`, and every row contributes to the sum, so its gradient is the sum of that column. Autograd finds the same answer without you deriving it.

## Stop recording when you do not need gradients

Recording the graph costs time and memory. Two tools turn it off when you do not need it:

- `torch.no_grad()` is a context manager that disables recording inside a block. Use it for evaluation and predictions.
- `x.detach()` returns a tensor that shares the data but is cut out of the graph.

```python
with torch.no_grad():
    predictions = model(X_val)     # no graph is built, so this is faster and lighter
```

> **Pitfall:** a tensor that you do not want to update still needs `requires_grad=False`, which is the default for data. Accidentally tracking gradients through your inputs or labels wastes memory and can confuse debugging.

## Gradients accumulate

Calling `backward()` adds into `.grad` rather than replacing it. This is the accumulation rule from lesson 8, and it is why every training loop clears the gradients before the backward pass.

```python run
# Two batches, one shared weight vector: gradients from both add up, as in PyTorch.
X1 = np.array([[1.0, 0.0], [0.0, 1.0]])
X2 = np.array([[2.0, 1.0]])
y1 = np.array([1.0, 2.0])
y2 = np.array([3.0])
w = np.array([0.5, -0.5])

def grad_sum_loss(X, y, w):
    # gradient of the sum of squared errors, 2 Xᵀ(Xw - y), with no averaging
    return 2 * X.T @ (X @ w - y)

g_total = grad_sum_loss(X1, y1, w) + grad_sum_loss(X2, y2, w)
print("accumulated gradient:", g_total)
```

If you forgot to clear the gradients, the second batch would be added on top of the first one from the previous step. The model would move in the direction of old data. Lesson 15 shows the loop that avoids this.

## Challenge: accumulate gradients correctly

Gradient accumulation is also how you train with batches too large for memory. Each batch contributes a sum, and the total must be divided by the total number of examples to get the mean gradient, not by the number of batches.

```python exercise id=accumulated-grad title="Accumulate a gradient across batches"
# TODO: `accumulated_grad(batches, w)` takes a list of (X_b, y_b) pairs, which can have different
# sizes. Compute the gradient of the mean squared error over ALL the examples together.
# For one batch, the sum of squared errors has gradient 2 * X_bᵀ (X_b w - y_b).
def accumulated_grad(batches, w):
    ...
--- solution
def accumulated_grad(batches, w):
    total = np.zeros_like(w)
    n = 0
    for X_b, y_b in batches:
        total = total + 2 * X_b.T @ (X_b @ w - y_b)
        n += len(y_b)
    return total / n
--- test
rng_t = np.random.default_rng(0)
X_all = rng_t.normal(size=(10, 3))
y_all = rng_t.normal(size=10)
w_t = np.array([0.2, -0.4, 0.1])
full = 2 * X_all.T @ (X_all @ w_t - y_all) / len(y_all)
batches = [(X_all[:4], y_all[:4]), (X_all[4:7], y_all[4:7]), (X_all[7:], y_all[7:])]
result = accumulated_grad(batches, w_t)
assert result is not None, "Replace the `...` in `accumulated_grad` with code that returns the mean gradient."
assert np.shape(result) == (3,), f"The gradient should have the shape of w, (3,), but it has {np.shape(result)}."
assert np.allclose(result, full), f"Accumulating over batches of different sizes should match the full-batch mean gradient. Expected {full}, got {result}. Divide by the total number of examples, not the number of batches."
--- hint
Start with a zero gradient the size of `w`. For each batch add `2 * X_bᵀ (X_b w - y_b)`, and count the examples as you go.
--- hint
Divide the accumulated sum by the total count of examples at the end, `total / n`.
```

## Challenge: flatten a batch of images

Convolutional networks keep images as 2-D grids, but a plain dense layer needs one row of features per example. Converting between the two is a shape operation you will do constantly.

```python exercise id=flatten-batch title="Flatten a batch of images"
# TODO: `flatten_batch(images)` takes an array of shape (n, height, width) and returns an array of
# shape (n, height * width), one row of pixels per image. Do not change the values.
def flatten_batch(images):
    ...
--- solution
def flatten_batch(images):
    return images.reshape(images.shape[0], -1)
--- test
imgs = np.arange(2 * 4 * 5, dtype=float).reshape(2, 4, 5)
result = flatten_batch(imgs)
assert result is not None, "Replace the `...` in `flatten_batch` with code that returns the flattened batch."
assert result.shape == (2, 20), f"Two 4 × 5 images should flatten to shape (2, 20), but you returned {result.shape}."
assert np.array_equal(result[1], imgs[1].ravel()), "Each row should hold the pixels of one image, in order."
assert flatten_batch(np.zeros((7, 3, 3))).shape == (7, 9), "Check that it works for any batch size and image size."
--- hint
Keep the first dimension (the batch) and merge the other two. NumPy's `-1` means "whatever size is left".
--- hint
`return images.reshape(images.shape[0], -1)`.
```

## Predict the gradient

```python predict id=predict-accumulate title="What does the accumulated gradient equal?"
import numpy as np
g1 = np.array([1.0, 2.0])
g2 = np.array([1.0, 2.0])
print(g1 + g2)
--- options
* [2. 4.]
[1. 2.]
[0. 0.]
[1. 4.]
--- explain
PyTorch adds each backward pass into .grad, and NumPy's addition does the same here. Two identical gradients of [1, 2] give [2, 4]. If you forget to clear the gradient between training steps, this doubling happens on every step.
```

## Debug the chain rule

```python debug id=inner-derivative title="Include the inner derivative"
import numpy as np
# The loss depends on w through h = x · w, so backprop must multiply by dh/dw as well.
w = np.array([2.0])
x = np.array([3.0])
h = x * w
loss = h ** 2
grad_w = 2 * h          # the gradient of the loss with respect to h, but not yet w
print("gradient seen by the optimizer:", grad_w)
--- solution
import numpy as np
w = np.array([2.0])
x = np.array([3.0])
h = x * w
loss = h ** 2
grad_w = 2 * h * x      # outer derivative 2h, times the inner derivative dh/dw = x
print("gradient seen by the optimizer:", grad_w)
--- test
assert np.allclose(grad_w, [36.0]), f"loss = (x w)² with x = 3 and w = 2 has gradient 2 · (x w) · x = 36, but the optimizer sees {grad_w}. Multiply by the inner derivative dh/dw = x."
--- hint
The chain rule has two factors here: the outer derivative of the square, which is `2h`, and the inner derivative of `h` with respect to `w`, which is `x`.
--- hint
`grad_w = 2 * h * x`.
```

## Recap

- A PyTorch tensor behaves like a NumPy array, with float32 by default and optional GPU placement.
- `requires_grad=True` records a graph, and `loss.backward()` fills `.grad` for every tensor that needs one.
- Gradients accumulate, so clear them before every backward pass.
- Use `torch.no_grad()` for evaluation, and when you only need values, not gradients.

**Up next:** the training loop in PyTorch, with models, data loaders and optimizers, and a NumPy version that runs here.
