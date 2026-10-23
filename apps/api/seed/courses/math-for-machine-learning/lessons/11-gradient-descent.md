Almost every model you will meet learns the same way. It starts with a guess, measures the gradient of its error, takes a small step against that gradient, and repeats. That loop is **gradient descent**. It is simple enough to write in five lines and powerful enough to train models with billions of weights, and the only real design decision is how big each step should be.

By the end of this lesson you will run gradient descent on a function, see how the learning rate controls convergence and divergence, fit a line to noisy data using gradients, and derive the gradient of the mean squared error.

## The update rule

Given a loss $f$ and its gradient $\nabla f$, one step of gradient descent is

$$
x \leftarrow x - \eta\, \nabla f(x)
$$

where $\eta$ (eta) is the **learning rate**. Let's watch it work on $f(x) = (x - 3)^2$, whose minimum is at $x = 3$. Its derivative is $f'(x) = 2(x - 3)$.

```python run
import numpy as np

def grad_f(x):
    return 2 * (x - 3)

x = 0.0
lr = 0.1
for step in range(1, 6):
    x = x - lr * grad_f(x)
    print(f"step {step}: x = {x:.4f}")
```

Each step moves $x$ closer to 3, and the steps get smaller as the gradient shrinks near the minimum.

## The learning rate decides everything

The same update can crawl, converge quickly, or explode, depending on $\eta$. Try four values for twenty steps each.

```python run
for lr in [0.01, 0.1, 0.5, 1.1]:
    x = 0.0
    for _ in range(20):
        x = x - lr * grad_f(x)
    print(f"lr = {lr:<5} after 20 steps: x = {x:.4g}")
```

- **Too small** (0.01): correct direction, but after 20 steps you are still far from 3.
- **Just right** (0.1 to 0.5): the error shrinks steadily. At 0.5 the first step lands exactly on the minimum.
- **Too large** (1.1): every step overshoots by more than it gained, so $x$ swings further from 3 each time.

For this quadratic, the error shrinks by the factor $|1 - 2\eta|$ each step. Convergence requires $|1 - 2\eta| < 1$, which means $\eta < 1$.

> **Tip:** when training goes wrong, check the learning rate first. A loss that grows or jumps around almost always means the step is too large.

## Fitting a line by gradient descent

Now a real learning problem. The data follow $y = 2x + 1$ plus noise. We model it as $\hat{y} = wx + b$ and minimize the **mean squared error** $L = \frac{1}{n}\sum (\hat{y}_i - y_i)^2$. Its gradients are

$$
\frac{\partial L}{\partial w} = \frac{2}{n}\sum_i (\hat{y}_i - y_i)\,x_i, \qquad \frac{\partial L}{\partial b} = \frac{2}{n}\sum_i (\hat{y}_i - y_i)
$$

```python run
import matplotlib.pyplot as plt

rng = np.random.default_rng(0)
x = rng.uniform(0, 1, 100)
y = 2 * x + 1 + rng.normal(0, 0.1, 100)

w, b, lr = 0.0, 0.0, 0.5
losses = []
for _ in range(500):
    err = (w * x + b) - y
    losses.append(np.mean(err ** 2))
    w -= lr * 2 * np.mean(err * x)
    b -= lr * 2 * np.mean(err)

print(f"learned w = {w:.3f}, b = {b:.3f}   (true values: 2 and 1)")

fig, ax = plt.subplots()
ax.plot(losses)
ax.set_yscale("log"); ax.set_xlabel("step"); ax.set_ylabel("mean squared error")
ax.grid(alpha=0.3)
plt.show()
```

The loss curve falls steeply and then flattens as the line settles. The learned parameters land close to the true values, 2 and 1, despite the noise, because the noise averages out over 100 points.

> **In the wild:** this exact loop, a gradient of a loss computed over a batch of data followed by a step, is what PyTorch and TensorFlow run during training. They just compute the gradients automatically (see the next lesson) and in parallel.

## Gradient descent on a matrix problem

In vector form, with a matrix $X$ whose rows are samples, the MSE gradient becomes $\frac{2}{n} X^\top (Xw - y)$. One matrix product gives the gradient for every weight at once.

```python run
X = np.column_stack([x, np.ones_like(x)])   # a column of ones gives the bias
w_vec = np.zeros(2)
for _ in range(500):
    w_vec -= 0.5 * (2 / len(y)) * X.T @ (X @ w_vec - y)
print("vector form (w, b):", w_vec.round(3))
```

This gives the same answer as the loop above, written as linear algebra.

## Challenges

```python exercise id=gradient-descent title="Gradient descent on a function"
# TODO: `gradient_descent(grad, x0, lr, steps)` should start at x0, repeat the update
# x = x - lr * grad(x) for `steps` steps, and return the final x.
def gradient_descent(grad, x0, lr, steps):
    ...
--- solution
def gradient_descent(grad, x0, lr, steps):
    x = x0
    for _ in range(steps):
        x = x - lr * grad(x)
    return x
--- test
result = gradient_descent(lambda x: 2 * (x - 3), 0.0, 0.1, 100)
assert result is not None, "Replace the `...` in `gradient_descent` with code that returns the final value."
assert np.isclose(result, 3.0, atol=1e-6), f"Descent on (x - 3)² should approach 3, but it returned {result!r}."
assert np.isclose(gradient_descent(lambda x: 2 * x, -5.0, 0.25, 50), 0.0, atol=1e-6), "Descent on x² from -5 should approach 0."
--- hint
Use a `for` loop that runs `steps` times, and update `x` inside it with `x = x - lr * grad(x)`.
--- hint
`grad` is a function you call, like `grad(x)`. Return `x` after the loop.
```

```python exercise id=mse-gradient title="The gradient of the mean squared error"
# TODO: `mse_gradient(X, y, w)` should return the gradient of the mean squared error
# (2 / n) * X.T @ (X @ w - y) for the linear model X @ w.
def mse_gradient(X, y, w):
    ...
--- solution
def mse_gradient(X, y, w):
    n = len(y)
    return (2 / n) * X.T @ (X @ w - y)
--- test
X = np.array([[1.0, 1.0], [1.0, 2.0], [1.0, 3.0]])
y = np.array([1.0, 2.0, 3.0])
result = mse_gradient(X, y, np.zeros(2))
assert result is not None, "Replace the `...` in `mse_gradient` with code that returns the gradient."
assert np.allclose(result, [-4.0, -28 / 3]), f"At w = (0, 0) the gradient should be [-4, -9.33], but you returned {np.round(result, 3).tolist()}."
assert np.allclose(mse_gradient(X, y, np.array([1.0, 1.0])), [2.0, 4.0]), "At w = (1, 1) the gradient should be [2, 4]."
--- hint
Compute the residual first: `X @ w - y`. Then multiply its transpose by `X` and scale by `2 / n`.
--- hint
`(2 / len(y)) * X.T @ (X @ w - y)`. Remember the transpose of X on the left.
```

```python exercise id=train-linear title="Train a linear model with gradient descent"
# TODO: `train_linear(X, y, lr=0.5, steps=3000)` should start from w = zeros and run
# gradient descent on the mean squared error, returning the learned weight vector w.
def train_linear(X, y, lr=0.5, steps=3000):
    ...
--- solution
def train_linear(X, y, lr=0.5, steps=3000):
    w = np.zeros(X.shape[1])
    n = len(y)
    for _ in range(steps):
        w -= lr * (2 / n) * X.T @ (X @ w - y)
    return w
--- test
x = np.linspace(0, 1, 20)
X = np.column_stack([x, np.ones_like(x)])
y = 3 * x + 2
result = train_linear(X, y)
assert result is not None, "Replace the `...` in `train_linear` with code that returns the weights."
assert np.shape(result) == (2,), f"The weight vector should have length 2 (slope and intercept), but it has shape {np.shape(result)}."
assert np.allclose(result, [3.0, 2.0], atol=1e-3), f"The data follow y = 3x + 2, so the weights should be about [3, 2], but train_linear returned {np.round(result, 4).tolist()}."
--- hint
Initialize `w = np.zeros(X.shape[1])`, then repeat the update `w -= lr * gradient` many times, where the gradient is the MSE gradient from the previous challenge.
--- hint
Inside the loop: `w -= lr * (2 / n) * X.T @ (X @ w - y)`.
```

```python debug sign-flip id=gd-sign title="Climbing instead of descending"
def grad_loss(w):
    return 2 * (w - 3)   # the gradient of (w - 3) ** 2

w = 0.0
lr = 0.1
for step in range(50):
    w = w + lr * grad_loss(w)   # step to lower the loss
print("final w:", round(w, 3))
--- solution
def grad_loss(w):
    return 2 * (w - 3)   # the gradient of (w - 3) ** 2

w = 0.0
lr = 0.1
for step in range(50):
    w = w - lr * grad_loss(w)   # step to lower the loss
print("final w:", round(w, 3))
--- test
assert np.isclose(w, 3.0, atol=1e-3), f"Gradient descent should move w to the minimum at 3, but w is {w!r}."
--- hint
Look at the printed value. It is far from 3 and getting further away, which is the signature of stepping uphill.
--- hint
Gradient descent subtracts the gradient: `w = w - lr * grad_loss(w)`.
```

```python predict id=predict-gd title="One step of descent"
x = 1.0
x = x - 0.5 * (2 * x)
print(x)
--- options
* 0.0
1.0
2.0
-1.0
--- explain
The gradient of x² at x = 1 is 2. One step with learning rate 0.5 moves x by `0.5 * 2 = 1` in the downhill direction, from 1 to 0.
```

## Recap

- Gradient descent repeats $x \leftarrow x - \eta\,\nabla f(x)$.
- The learning rate controls progress: too small is slow, too large diverges.
- For a linear model with mean squared error, the gradient is $\frac{2}{n}X^\top(Xw - y)$, which NumPy computes in one line.
- Training a model is running this loop until the loss stops falling.

**Up next:** the chain rule. Real models are long chains of simple functions, and the chain rule is how their gradients are computed.
