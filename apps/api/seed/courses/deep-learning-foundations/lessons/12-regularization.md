A network with enough parameters can memorize its training set perfectly and still fail on new data. This is **overfitting**, and it is the central practical problem of machine learning. The tools against it are called **regularization**: anything that makes the model prefer simpler explanations. In this lesson you will see overfitting happen, then fix it with a penalty on the weights, with dropout and with early stopping.

## See overfitting happen

Here is a noisy sine wave. We fit polynomials of increasing degree to 12 training points, then measure the error on 30 fresh points the model never saw.

```python run
rng = np.random.default_rng(0)
x_train = np.sort(rng.uniform(0, 1, 12))
y_train = np.sin(2 * np.pi * x_train) + rng.normal(0, 0.2, 12)
x_val = np.linspace(0, 1, 30)
y_val = np.sin(2 * np.pi * x_val) + rng.normal(0, 0.2, 30)

for degree in [1, 3, 9]:
    coefs = np.polyfit(x_train, y_train, degree)
    train_mse = np.mean((np.polyval(coefs, x_train) - y_train) ** 2)
    val_mse = np.mean((np.polyval(coefs, x_val) - y_val) ** 2)
    print(f"degree {degree}: train {train_mse:.4f}   validation {val_mse:.4f}")
```

The degree-9 polynomial has nearly zero training error, but its validation error is much worse than the simpler models. It has memorized the noise. A large gap between training and validation error is the signature of overfitting.

> **Pitfall:** never judge a model by its training error. Hold out a validation set, and keep a separate test set for the final number.

## Penalize large weights: L2 regularization

One way to discourage memorization is to make large weights expensive. **L2 regularization** (also called weight decay) adds $\lambda \lVert w \rVert^2$ to the loss. Its gradient is $2\lambda w$, so every update also shrinks the weights towards zero.

For linear regression there is a closed-form solution, the **ridge regression** estimate:

$$
w = (X^{\top} X + \lambda I)^{-1} X^{\top} y
$$

```python run
def ridge_fit(X, y, lam):
    d = X.shape[1]
    return np.linalg.solve(X.T @ X + lam * np.eye(d), X.T @ y)

# Polynomial features of the same sine data, degree 9
def features(x, degree=9):
    return np.column_stack([x ** k for k in range(degree + 1)])

Xtr = features(x_train)
Xva = features(x_val)
for lam in [0.0, 1e-6, 1e-3]:
    w = ridge_fit(Xtr, y_train, lam)
    val_mse = np.mean((Xva @ w - y_val) ** 2)
    print(f"lambda {lam:<8} validation {val_mse:.4f}   largest |weight| {np.abs(w).max():.1f}")
```

Increasing $\lambda$ shrinks the largest weight and usually improves validation error. Too much and the model underfits, so $\lambda$ is a hyperparameter you tune on the validation set.

## Dropout: train an ensemble of thinned networks

**Dropout** randomly zeroes a fraction of the activations on each training step. The network cannot rely on any single unit, so it learns redundant, robust features.

The standard version is **inverted dropout**. Each kept activation is divided by the keep probability $p$ during training, so its expected value is unchanged. At test time nothing is dropped and nothing is rescaled.

```python run
A = np.ones((4, 6))
p_keep = 0.5
mask = rng.random(A.shape) < p_keep
A_dropped = A * mask / p_keep
print("mask:")
print(mask.astype(int))
print("expected value of each unit after dropout:", round(A_dropped.mean(), 3), "(about 1)")
```

Run the cell a few times. Each mask is different, but the average stays close to one. That is what the rescaling buys you.

## Early stopping: stop before the damage

Training loss falls forever, but validation loss usually bottoms out and then rises. **Early stopping** watches the validation loss and keeps the model from its best epoch, once it has stopped improving for a set number of epochs, the **patience**.

```python run
val_losses = [0.9, 0.6, 0.45, 0.38, 0.35, 0.34, 0.36, 0.39, 0.41, 0.44]
best = int(np.argmin(val_losses))
print("best epoch:", best, "with validation loss", val_losses[best])
print("epochs wasted after the best one:", len(val_losses) - 1 - best)
```

## Challenge: ridge regression

```python exercise id=ridge-fit title="Ridge regression in closed form"
# TODO: `ridge_fit(X, y, lam)` returns the weights w = (XᵀX + lam·I)⁻¹ Xᵀy as a 1-D array.
def ridge_fit(X, y, lam):
    ...
--- solution
def ridge_fit(X, y, lam):
    d = X.shape[1]
    return np.linalg.solve(X.T @ X + lam * np.eye(d), X.T @ y)
--- test
rng_t = np.random.default_rng(4)
X_t = rng_t.normal(size=(30, 3))
true_w = np.array([1.0, -2.0, 0.5])
y_t = X_t @ true_w + rng_t.normal(0, 0.01, 30)
w0 = ridge_fit(X_t, y_t, 0.0)
assert w0 is not None, "Replace the `...` in `ridge_fit` with code that returns the weights."
assert np.shape(w0) == (3,), f"The weights should have shape (3,), but they have {np.shape(w0)}."
assert np.allclose(w0, true_w, atol=0.05), f"With lam = 0 the fit should recover about [1, -2, 0.5], but you returned {w0}."
w_big = ridge_fit(X_t, y_t, 1000.0)
assert np.linalg.norm(w_big) < np.linalg.norm(w0) / 10, "A large lam should shrink the weights strongly towards zero."
--- hint
Build the matrix `X.T @ X + lam * np.eye(d)`, then solve the linear system against `X.T @ y`. `np.linalg.solve` is more accurate than computing an inverse.
--- hint
`return np.linalg.solve(X.T @ X + lam * np.eye(X.shape[1]), X.T @ y)`.
```

## Challenge: inverted dropout

```python exercise id=inverted-dropout title="Inverted dropout"
# TODO: `inverted_dropout(A, p_keep, rng)` randomly keeps each entry of A with probability p_keep,
# zeroes the rest, and divides the kept entries by p_keep. Use `rng.random(A.shape) < p_keep` for the mask.
def inverted_dropout(A, p_keep, rng):
    ...
--- solution
def inverted_dropout(A, p_keep, rng):
    mask = rng.random(A.shape) < p_keep
    return A * mask / p_keep
--- test
A_t = np.full((400, 50), 2.0)
out = inverted_dropout(A_t, 0.5, np.random.default_rng(0))
assert out is not None, "Replace the `...` in `inverted_dropout` with code that returns the dropped activations."
assert out.shape == A_t.shape, "The output should have the same shape as the input."
assert np.all((out == 0) | np.isclose(out, 4.0)), "Kept entries should be A / p_keep = 4.0, and dropped entries should be 0."
assert abs(out.mean() - 2.0) < 0.05, f"The mean should stay near 2.0 after dropout, but it is {out.mean():.3f}. Divide the kept values by p_keep."
same = inverted_dropout(A_t, 1.0, np.random.default_rng(1))
assert np.allclose(same, A_t), "With p_keep = 1.0 nothing should be dropped, and the output should equal the input."
--- hint
Build a boolean mask with `rng.random(A.shape) < p_keep`, multiply `A` by it, then divide by `p_keep`.
--- hint
`mask = rng.random(A.shape) < p_keep` and `return A * mask / p_keep`.
```

## Challenge: when to stop

```python exercise id=stop-epoch title="Early stopping"
# TODO: `stop_epoch(val_losses, patience)` returns the epoch index of the best (lowest) validation loss
# seen before training stops. Training stops once the loss has failed to improve for `patience` epochs in a row.
def stop_epoch(val_losses, patience):
    ...
--- solution
def stop_epoch(val_losses, patience):
    best, best_epoch = float("inf"), 0
    for epoch, loss in enumerate(val_losses):
        if loss < best:
            best, best_epoch = loss, epoch
        elif epoch - best_epoch >= patience:
            return best_epoch
    return best_epoch
--- test
assert stop_epoch([5.0, 4.0, 3.0, 3.5, 3.6, 3.7, 3.8], 2) is not None, "Replace the `...` in `stop_epoch` with code that returns an epoch index."
assert stop_epoch([5.0, 4.0, 3.0, 3.5, 3.6, 3.7, 3.8], 2) == 2, "The best loss is at epoch 2. Training stops at epoch 4, after two epochs without improvement, so the answer is 2."
assert stop_epoch([1.0, 2.0, 3.0], 5) == 0, "If the loss never improves, the best epoch is the first one."
assert stop_epoch([3.0, 2.0, 2.5, 1.0, 1.5, 1.2, 1.1, 1.3], 3) == 3, "Here the loss keeps finding new lows until epoch 3, which is the answer."
--- hint
Track the best loss and its epoch as you go. Each epoch that does not improve on the best adds one to the count since the best.
--- hint
When `epoch - best_epoch` reaches `patience`, return `best_epoch` straight away.
```

## Debug the missing rescale

```python debug id=dropout-scale title="Keep the expected activation"
rng_d = np.random.default_rng(0)
A = np.ones(1000)
p_keep = 0.8
mask = rng_d.random(A.shape) < p_keep
out = A * mask          # the kept units are not rescaled
print("mean after dropout:", round(out.mean(), 3), "(should be about 1)")
--- solution
rng_d = np.random.default_rng(0)
A = np.ones(1000)
p_keep = 0.8
mask = rng_d.random(A.shape) < p_keep
out = A * mask / p_keep
print("mean after dropout:", round(out.mean(), 3), "(should be about 1)")
--- test
assert abs(out.mean() - 1.0) < 0.05, f"With keep probability 0.8 the mean after dropout should be about 1, but it is {out.mean():.3f}. Divide the kept units by p_keep."
--- hint
Dropout removes 20% of the units, so the total signal is 20% smaller. Restoring the expected value means scaling the survivors up.
--- hint
`out = A * mask / p_keep`.
```

## Predict the penalty

```python predict id=predict-l2 title="What is the L2 penalty?"
w = np.array([3.0, 4.0])
lam = 0.1
print(lam * np.sum(w ** 2))
--- options
* 2.5
0.5
5.0
25.0
--- explain
The squared norm is 3² + 4² = 25, and the penalty is λ times that: 0.1 × 25 = 2.5. The penalty grows with the square of every weight, so a few very large weights cost far more than many small ones.
```

## Recap

- Overfitting means the model has learned the noise. Compare training and validation error to spot it.
- L2 regularization penalizes large weights, and its gradient shrinks every weight a little on each update.
- Inverted dropout zeroes random units during training and rescales the rest, so the expected activation is unchanged.
- Early stopping keeps the model from the epoch with the best validation loss, and ignores the epochs after it.

**Up next:** initialization and normalization. How you set the starting weights decides whether the signal survives a deep network at all.
