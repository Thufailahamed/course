Linear regression is the "hello world" of machine learning, and it's far more than a warm-up. The training loop you'll write here is the same one that trains every neural network: **predict, measure the error, compute the gradient, step downhill, repeat**. PyTorch automates the gradient part; everything else is exactly this.

In this project you'll implement it all in NumPy: predictions, the mean squared error, its gradient (derived by hand), batch gradient descent, feature scaling and mini-batches. At the end you'll check your answer against NumPy's exact least-squares solver and recover the hidden "true" weights from noisy data.

> **How this project works:** each stage is a challenge that builds one piece. Challenges run in their own namespace, so later stages restate the helpers they need. The run cells between stages explore what you just built.

```python setup
rng = np.random.default_rng(0)
n = 200
# Three features on wildly different scales, like real tabular data
X = rng.normal(size=(n, 3)) * np.array([1.0, 10.0, 0.1]) + np.array([0.0, 50.0, 1.0])
true_w = np.array([2.0, -0.5, 30.0])
true_b = 4.0
y = X @ true_w + true_b + rng.normal(scale=0.5, size=n)
```

## The data

The setup created `X`, a `(200, 3)` matrix with one row per example and one column per feature, and targets `y`, generated from hidden weights plus a little noise. Our job is to recover the weights from `X` and `y` alone.

```python run
print("X:", X.shape, "  y:", y.shape)
print("first rows of X:\n", X[:3].round(2))
print("column means:", X.mean(axis=0).round(2))
print("column stds: ", X.std(axis=0).round(2))
```

Look at those scales: the second feature sits around 50 and swings by 10, while the third barely moves around 1. Keep that in mind. It will bite us in Stage 4.

## Stage 1: the model

A linear model predicts each target as a weighted sum of the features plus a bias:

$$
\hat{y}_i = w_1 x_{i1} + w_2 x_{i2} + w_3 x_{i3} + b \quad\Longleftrightarrow\quad \hat{y} = Xw + b
$$

The matrix form on the right does all 200 predictions at once: `X @ w` is a matrix–vector product of shape `(200, 3) @ (3,)`, and the scalar `b` broadcasts across the result.

```python predict id=predict-xw-shape title="What shape are the predictions?"
X = np.ones((200, 3))
w = np.array([2.0, -0.5, 30.0])
print((X @ w + 4.0).shape)
--- options
* (200,)
(200, 1)
(3,)
(200, 3)
--- explain
`(200, 3) @ (3,)` contracts the shared dimension of length 3 and leaves one number per row: a 1-D array of shape `(200,)`. Adding the scalar bias doesn't change the shape.
```

```python exercise id=make-predictions title="Implement the model"
def predict(X, w, b):
    """Return the model's prediction for every row of X, shape (n,)."""
    # TODO: one matrix-vector product, plus the bias
    return ...

y_hat = predict(X, np.zeros(3), 0.0)
print(y_hat)
--- solution
def predict(X, w, b):
    """Return the model's prediction for every row of X, shape (n,)."""
    return X @ w + b

y_hat = predict(X, np.zeros(3), 0.0)
print(y_hat)
--- test
rng_t = np.random.default_rng(3)
Xt = rng_t.normal(size=(7, 4))
wt = rng_t.normal(size=4)
out = predict(Xt, wt, 1.5)
assert out is not ..., "predict returns `...`. Replace the placeholder with your code."
out = np.asarray(out)
assert out.shape == (7,), f"For 7 examples predict should return shape (7,), got {out.shape}."
assert np.allclose(out, Xt @ wt + 1.5), "Some predictions are wrong. Each one should be the row dotted with w, plus b."
assert np.allclose(predict(Xt, wt, 0.0) + 2.0, predict(Xt, wt, 2.0)), "Changing b should shift every prediction by the same amount."
--- hint
`@` is NumPy's matrix-multiplication operator. What shape do you get from `X @ w`?
--- hint
`X @ w + b` is the entire model.
```

## Stage 2: how wrong are we?

To learn, the model needs a single number that measures its error. The standard choice for regression is the **mean squared error**:

$$
L(w, b) = \frac{1}{n} \sum_{i=1}^{n} \left(\hat{y}_i - y_i\right)^2
$$

Squaring makes every error positive and punishes big misses much more than small ones.

```python exercise id=mse-loss title="Implement the mean squared error"
def mse(y_pred, y):
    """Return the mean squared error between predictions and targets, as one number."""
    # TODO: average the squared differences
    return ...

print(mse(np.array([1.0, 2.0, 3.0]), np.array([1.0, 2.0, 5.0])))
--- solution
def mse(y_pred, y):
    """Return the mean squared error between predictions and targets, as one number."""
    return np.mean((y_pred - y) ** 2)

print(mse(np.array([1.0, 2.0, 3.0]), np.array([1.0, 2.0, 5.0])))
--- test
r = mse(np.array([1.0, 2.0, 3.0]), np.array([1.0, 2.0, 5.0]))
assert r is not ..., "mse returns `...`. Replace the placeholder with your code."
assert np.ndim(r) == 0, f"mse should return a single number, but got shape {np.shape(r)}. Did you forget to average?"
assert np.isclose(r, 4 / 3), f"mse([1, 2, 3], [1, 2, 5]) should be 4/3 (one error of 2, squared, averaged over 3), got {r}."
rng_t = np.random.default_rng(5)
a, b = rng_t.normal(size=50), rng_t.normal(size=50)
assert np.isclose(mse(a, b), ((a - b) ** 2).sum() / 50), "mse is wrong on random data. Square first, then take the mean."
assert np.isclose(mse(a, a), 0.0), "The error of perfect predictions should be 0."
--- hint
Compute the differences, square them with `** 2`, then reduce with a mean.
--- hint
`np.mean((y_pred - y) ** 2)`. Note that the mean is taken *after* squaring.
```

With weights of zero, every prediction is just `b = 0`, so the loss is huge. A lucky guess does better, and the true weights do best of all:

```python run
def loss(w, b):
    return np.mean((X @ w + b - y) ** 2)

print("all zeros:  ", round(loss(np.zeros(3), 0.0), 2))
print("rough guess:", round(loss(np.array([1.0, -0.4, 25.0]), 0.0), 2))
print("true params:", round(loss(true_w, true_b), 3), " (just the noise, about 0.5² = 0.25)")
```

## Stage 3: which way is downhill?

Gradient descent improves the weights by stepping **against the gradient**, the direction in which the loss increases fastest. Differentiating $L$ with the chain rule gives two compact formulas. Write $e = \hat{y} - y$ for the vector of errors:

$$
\frac{\partial L}{\partial w} = \frac{2}{n} X^\top e \qquad\qquad \frac{\partial L}{\partial b} = \frac{2}{n} \sum_{i=1}^{n} e_i
$$

Read the first one as: each feature's gradient is the correlation between that feature and the errors. `X.T @ e` has shape `(3, 200) @ (200,)`, which gives `(3,)`: one number per weight, exactly the shape of `w`.

How can you be sure a gradient formula is right? Compare it with a **numerical** estimate: nudge a parameter by a tiny $\varepsilon$ in each direction and measure the slope. Here's the idea on a one-variable function whose derivative you know:

```python run
f = lambda w: (w - 3.0) ** 2         # derivative: 2 (w - 3)
w0, eps = 5.0, 1e-6

numerical = (f(w0 + eps) - f(w0 - eps)) / (2 * eps)
print("numerical slope:", round(numerical, 6))
print("exact slope:    ", 2 * (w0 - 3.0))
```

Professionals call this a **gradient check**, and it's exactly how the hidden tests verify your next function.

```python exercise id=gradients title="Compute the gradients"
def gradients(X, y, w, b):
    """Return (grad_w, grad_b): the gradient of the MSE with respect to w and b."""
    n = len(X)
    error = ...   # TODO: predictions minus targets, shape (n,)
    grad_w = ...  # TODO: (2 / n) * X transposed times the error, shape (d,)
    grad_b = ...  # TODO: (2 / n) * the sum of the errors, a single number
    return grad_w, grad_b

print(gradients(X, y, np.zeros(3), 0.0))
--- solution
def gradients(X, y, w, b):
    """Return (grad_w, grad_b): the gradient of the MSE with respect to w and b."""
    n = len(X)
    error = X @ w + b - y
    grad_w = 2 / n * X.T @ error
    grad_b = 2 / n * error.sum()
    return grad_w, grad_b

print(gradients(X, y, np.zeros(3), 0.0))
--- test
rng_t = np.random.default_rng(11)
Xt = rng_t.normal(size=(30, 3))
yt = rng_t.normal(size=30)
wt = rng_t.normal(size=3)
bt = 0.7
out = gradients(Xt, yt, wt, bt)
assert isinstance(out, tuple) and len(out) == 2, "gradients should return a tuple (grad_w, grad_b)."
gw, gb = out
assert gw is not ... and gb is not ..., "gradients still returns a `...` placeholder. Fill in all three TODOs."
gw = np.asarray(gw)
assert gw.shape == (3,), f"grad_w should have one entry per feature, shape (3,), got {gw.shape}."
assert np.ndim(gb) == 0, f"grad_b should be a single number, got shape {np.shape(gb)}."
def _loss(w, b):
    return np.mean((Xt @ w + b - yt) ** 2)
eps = 1e-6
num_w = np.array([(_loss(wt + eps * e, bt) - _loss(wt - eps * e, bt)) / (2 * eps) for e in np.eye(3)])
num_b = (_loss(wt, bt + eps) - _loss(wt, bt - eps)) / (2 * eps)
assert np.allclose(gw, num_w, atol=1e-4), "grad_w doesn't match the numerical gradient check. Check the sign of the error, the 2/n factor and the transpose."
assert np.isclose(gb, num_b, atol=1e-4), "grad_b doesn't match the numerical gradient check. It should be 2/n times the sum of the errors."
--- hint
Start with `error = X @ w + b - y`. The order matters: predictions *minus* targets.
--- hint
`X.T @ error` sums each feature times the error over all examples. Scale it by `2 / n`. For the bias, sum the errors instead.
```

## A classic shape bug

Real datasets often load the target as a **column**, shape `(n, 1)`, instead of a flat `(n,)` vector. That one innocent difference triggers broadcasting in a way that silently wrecks training:

```python predict id=predict-column-broadcast title="Column minus row"
y_col = np.zeros((200, 1))
y_hat = np.zeros(200)
print((y_hat - y_col).shape)
--- options
(200,)
(200, 1)
* (200, 200)
(1, 200)
--- explain
`(200,)` is treated as `(1, 200)` and broadcast against `(200, 1)`, producing a full `(200, 200)` table of every prediction minus every target. No error is raised; the numbers are just meaningless.
```

```python debug id=column-vector-bug title="Training crashes with a broadcasting error"
rng_d = np.random.default_rng(1)
Xd = rng_d.normal(size=(50, 2))
yd = (Xd @ np.array([3.0, -1.0]) + 2.0).reshape(-1, 1)   # targets loaded as a column

w = np.zeros(2)
b = 0.0
for step in range(200):
    error = Xd @ w + b - yd
    grad_w = 2 / len(Xd) * Xd.T @ error
    grad_b = 2 / len(Xd) * error.sum()
    w = w - 0.1 * grad_w
    b = b - 0.1 * grad_b

print("w shape:", np.shape(w))
print("w:", w)
print("b:", b)
--- solution
rng_d = np.random.default_rng(1)
Xd = rng_d.normal(size=(50, 2))
yd = Xd @ np.array([3.0, -1.0]) + 2.0   # keep the targets as a flat (n,) vector

w = np.zeros(2)
b = 0.0
for step in range(200):
    error = Xd @ w + b - yd
    grad_w = 2 / len(Xd) * Xd.T @ error
    grad_b = 2 / len(Xd) * error.sum()
    w = w - 0.1 * grad_w
    b = b - 0.1 * grad_b

print("w shape:", np.shape(w))
print("w:", w)
print("b:", b)
--- test
assert np.shape(w) == (2,), f"w should have shape (2,), one weight per feature, but it has shape {np.shape(w)}."
assert np.ndim(b) == 0, "b should be a single number."
assert np.allclose(w, [3.0, -1.0], atol=1e-2), f"Training should recover w = [3, -1], but got {np.round(w, 3).tolist()}."
assert np.isclose(b, 2.0, atol=1e-2), f"Training should recover b = 2, but got {b}."
--- hint
Run it. The error says the update tried to combine `w` (shape `(2,)`) with a gradient of shape `(2, 50)`, but the gradient should have the same shape as `w`. Use **Debug** and check the shape of `error` on the very first iteration.
--- hint
`Xd @ w` has shape `(50,)` but `yd` has shape `(50, 1)`, so their difference broadcasts to `(50, 50)`. Make the targets a flat vector, for example by dropping the `.reshape(-1, 1)` or calling `.ravel()`.
```

> **In the wild:** this exact bug is a rite of passage in PyTorch too, where `nn.MSELoss` will warn that "target size is different to input size" and then broadcast anyway. When a loss looks strangely stuck, print the shapes of predictions and targets first.

## Stage 4: why scale matters

Let's run gradient descent on the raw features. A learning rate of `0.01` sounds modest:

```python run
def train(X, y, lr, epochs):
    w, b = np.zeros(X.shape[1]), 0.0
    for _ in range(epochs):
        error = X @ w + b - y
        w = w - lr * 2 / len(X) * X.T @ error
        b = b - lr * 2 / len(X) * error.sum()
    return w, b, np.mean((X @ w + b - y) ** 2)

for lr, epochs in [(0.01, 20), (1e-4, 500)]:
    w, b, final = train(X, y, lr, epochs)
    print(f"lr={lr:<6} epochs={epochs:<4} loss={final:.4g}  w={np.round(w, 2)}")
```

With `lr=0.01` the loss explodes to `inf` or `nan`. With a tiny `lr=1e-4` it's stable, but after 500 epochs it's nowhere near the answer. The second feature (values around 50) has a gradient thousands of times steeper than the third (values around 1), and a single learning rate can't suit both: it's too big for one and too small for the other.

The fix is **standardization**: shift and scale every column to mean 0 and standard deviation 1,

$$
x'_{ij} = \frac{x_{ij} - \mu_j}{\sigma_j}
$$

so every feature lives on the same scale and one learning rate works for all of them.

```python exercise id=standardize title="Standardize the features"
def standardize(X):
    """Scale every column to mean 0 and std 1. Return (X_scaled, mean, std)."""
    mean = ...       # TODO: one mean per column, shape (d,)
    std = ...        # TODO: one standard deviation per column, shape (d,)
    X_scaled = ...   # TODO: broadcasting does the rest
    return X_scaled, mean, std

Xs, mu, sigma = standardize(X)
print("mean:", mu)
print("std: ", sigma)
--- solution
def standardize(X):
    """Scale every column to mean 0 and std 1. Return (X_scaled, mean, std)."""
    mean = X.mean(axis=0)
    std = X.std(axis=0)
    X_scaled = (X - mean) / std
    return X_scaled, mean, std

Xs, mu, sigma = standardize(X)
print("mean:", mu)
print("std: ", sigma)
--- test
rng_t = np.random.default_rng(9)
A = rng_t.normal(loc=[5.0, -20.0, 100.0], scale=[2.0, 0.1, 30.0], size=(80, 3))
out = standardize(A)
assert isinstance(out, tuple) and len(out) == 3, "standardize should return a tuple (X_scaled, mean, std)."
Xs_t, mu_t, sd_t = out
assert Xs_t is not ... and mu_t is not ... and sd_t is not ..., "standardize still returns a `...` placeholder. Fill in all three TODOs."
assert np.shape(mu_t) == (3,) and np.shape(sd_t) == (3,), f"mean and std should hold one value per column, shape (3,), got {np.shape(mu_t)} and {np.shape(sd_t)}. Which axis did you reduce over?"
assert np.shape(Xs_t) == (80, 3), f"X_scaled should keep the shape of X, (80, 3), got {np.shape(Xs_t)}."
assert np.allclose(Xs_t.mean(axis=0), 0.0, atol=1e-9), "Every column of X_scaled should have mean 0."
assert np.allclose(Xs_t.std(axis=0), 1.0), "Every column of X_scaled should have standard deviation 1."
assert np.allclose(Xs_t * sd_t + mu_t, A), "You should be able to undo the scaling: X_scaled * std + mean should equal X."
--- hint
Reduce **down the rows** so you get one statistic per column: `axis=0`.
--- hint
`mean = X.mean(axis=0)`, `std = X.std(axis=0)`, then `(X - mean) / std`. The `(3,)` statistics broadcast across all rows.
```

Now the learning rate has a predictable effect. Watch the loss curves for four rates on the standardized features:

```python run
import matplotlib.pyplot as plt

Xs = (X - X.mean(axis=0)) / X.std(axis=0)

for lr in [0.01, 0.1, 0.5, 1.05]:
    w, b, losses = np.zeros(3), 0.0, []
    for _ in range(60):
        error = Xs @ w + b - y
        losses.append(np.mean(error ** 2))
        w = w - lr * 2 / len(Xs) * Xs.T @ error
        b = b - lr * 2 / len(Xs) * error.sum()
    plt.semilogy(losses, label=f"lr = {lr}")
    print(f"lr={lr:<5} final loss {losses[-1]:.4g}")

plt.xlabel("epoch")
plt.ylabel("MSE (log scale)")
plt.legend()
plt.title("Too small crawls, too big diverges")
plt.show()
```

`0.01` crawls, `0.1` and `0.5` converge quickly, and `1.05` overshoots further on every step until it diverges. Finding the largest learning rate that still converges is the first thing you tune in any training run.

## Stage 5: the full training loop

Time to assemble everything into a reusable `fit` function. It takes standardized features, runs batch gradient descent, and returns the learned parameters together with the loss history.

```python exercise id=fit-gd title="Train with batch gradient descent"
def fit(X, y, lr=0.1, epochs=500):
    """Batch gradient descent for linear regression. Return (w, b, losses)."""
    n, d = X.shape
    w = np.zeros(d)
    b = 0.0
    losses = []
    for epoch in range(epochs):
        # TODO 1: compute the error vector (predictions minus targets)
        # TODO 2: append the current MSE to `losses`
        # TODO 3: compute grad_w and grad_b
        # TODO 4: step downhill: w = w - lr * grad_w, and the same for b
        ...
    return w, b, np.array(losses)

Xs = (X - X.mean(axis=0)) / X.std(axis=0)
w, b, losses = fit(Xs, y)
print("w:", w, " b:", b)
print("epochs recorded:", len(losses))
--- solution
def fit(X, y, lr=0.1, epochs=500):
    """Batch gradient descent for linear regression. Return (w, b, losses)."""
    n, d = X.shape
    w = np.zeros(d)
    b = 0.0
    losses = []
    for epoch in range(epochs):
        error = X @ w + b - y
        losses.append(np.mean(error ** 2))
        grad_w = 2 / n * X.T @ error
        grad_b = 2 / n * error.sum()
        w = w - lr * grad_w
        b = b - lr * grad_b
    return w, b, np.array(losses)

Xs = (X - X.mean(axis=0)) / X.std(axis=0)
w, b, losses = fit(Xs, y)
print("w:", w, " b:", b)
print("epochs recorded:", len(losses))
--- test
rng_t = np.random.default_rng(5)
Xt = rng_t.normal(size=(150, 4))
wt = np.array([1.5, -2.0, 0.5, 3.0])
yt = Xt @ wt - 1.0 + rng_t.normal(scale=0.1, size=150)
out = fit(Xt, yt, lr=0.1, epochs=300)
assert isinstance(out, tuple) and len(out) == 3, "fit should return a tuple (w, b, losses)."
w_t, b_t, losses_t = out
losses_t = np.asarray(losses_t)
assert losses_t.shape == (300,), f"losses should hold one value per epoch, shape (300,), got {losses_t.shape}."
assert np.shape(w_t) == (4,), f"w should have one weight per feature, shape (4,), got {np.shape(w_t)}."
assert losses_t[-1] < losses_t[0], "The loss went up during training. Check the sign of your update: step *against* the gradient."
assert np.all(np.diff(losses_t) <= 1e-9), "With lr=0.1 on standardized data the loss should never increase. Are you computing the loss and gradients from the same, current w and b?"
A = np.column_stack([Xt, np.ones(150)])
best = np.linalg.lstsq(A, yt, rcond=None)[0]
assert np.allclose(w_t, best[:4], atol=1e-2), f"After 300 epochs w should match the least-squares solution {np.round(best[:4], 3).tolist()}, but got {np.round(w_t, 3).tolist()}."
assert np.isclose(b_t, best[4], atol=1e-2), f"After 300 epochs b should be close to {best[4]:.3f}, but got {b_t:.3f}."
--- hint
Inside the loop, reuse your Stage 3 code: `error = X @ w + b - y`, then `losses.append(np.mean(error ** 2))`.
--- hint
The gradients are `2 / n * X.T @ error` and `2 / n * error.sum()`. Then update with `w = w - lr * grad_w` and `b = b - lr * grad_b`.
```

## Mini-batches: how big models actually train

Batch gradient descent touches **every** example before each step. With millions of rows that's too slow, so real training uses **mini-batches**: shuffle the data each epoch, then take a step on each small chunk. Each step is noisier but far cheaper, and the noise even helps escape bad regions in deep networks.

```python run
Xs = (X - X.mean(axis=0)) / X.std(axis=0)
rng_mb = np.random.default_rng(0)
w, b, batch = np.zeros(3), 0.0, 32

for epoch in range(30):
    order = rng_mb.permutation(len(Xs))          # a fresh shuffle every epoch
    for start in range(0, len(Xs), batch):
        idx = order[start:start + batch]
        error = Xs[idx] @ w + b - y[idx]
        w = w - 0.05 * 2 / len(idx) * Xs[idx].T @ error
        b = b - 0.05 * 2 / len(idx) * error.sum()

print("steps taken:", 30 * int(np.ceil(len(Xs) / batch)))
print("mini-batch w:", w.round(3), " b:", round(b, 3))
print("final loss:  ", round(np.mean((Xs @ w + b - y) ** 2), 4))
```

> **Under the hood:** this inner loop is exactly what `torch.utils.data.DataLoader(shuffle=True, batch_size=32)` plus an optimizer step does. Only the gradient computation is automated.

## The payoff: recover the hidden weights

Two last questions. Did gradient descent find the *best possible* answer? And what do the weights mean in the original units?

For linear regression we can check exactly, because the optimum has a closed form: least squares. `np.linalg.lstsq` solves it directly once we append a column of ones for the bias. To compare with gradient descent, undo the standardization: if $x' = (x - \mu)/\sigma$, then $w = w' / \sigma$ and $b = b' - \sum_j \mu_j w'_j / \sigma_j$.

```python run
mu, sigma = X.mean(axis=0), X.std(axis=0)
Xs = (X - mu) / sigma

w_s, b_s = np.zeros(3), 0.0
for _ in range(500):
    error = Xs @ w_s + b_s - y
    w_s, b_s = w_s - 0.1 * 2 / n * Xs.T @ error, b_s - 0.1 * 2 / n * error.sum()

w_gd = w_s / sigma
b_gd = b_s - (mu / sigma) @ w_s

A = np.column_stack([X, np.ones(n)])
exact = np.linalg.lstsq(A, y, rcond=None)[0]

print("true:           w =", true_w, "    b =", true_b)
print("gradient desc.: w =", w_gd.round(3), " b =", round(b_gd, 3))
print("least squares:  w =", exact[:3].round(3), " b =", round(exact[3], 3))
```

Gradient descent matches the exact least-squares solution, and both land within the noise of the true parameters: `w ≈ [2, -0.5, 30]` and `b ≈ 4`. You've recovered the hidden law behind the data.

> **Tip:** for linear regression specifically, prefer `np.linalg.lstsq`. It's exact and needs no learning rate. Gradient descent earns its keep when there's no closed form, which is the case for logistic regression, neural networks and almost every other model.

## Recap

- A linear model is `X @ w + b`; matrix form makes all predictions at once.
- MSE measures error; its gradients are $\frac{2}{n}X^\top e$ and $\frac{2}{n}\sum e$, and a numerical gradient check verifies them.
- Keep targets as `(n,)` vectors: `(n,)` minus `(n, 1)` silently broadcasts to `(n, n)`.
- Standardize features so a single learning rate suits every weight, then tune the rate: too small crawls, too large diverges.
- Mini-batches trade exact gradients for cheap, frequent steps. That's how every large model trains.

**Up next:** the final project, where you simulate whole worlds with vectorized NumPy: Conway's Game of Life and Monte Carlo experiments.
