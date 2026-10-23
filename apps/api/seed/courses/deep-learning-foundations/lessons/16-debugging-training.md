Most of the time a network trains, and sometimes it does not. The loss goes to `nan`, it stops moving, or validation accuracy sits at chance while training accuracy looks fine. These failures are frustrating because the code runs without an error. In this lesson you will learn a systematic way to find the cause: check the numbers, reproduce the problem on a tiny case, and change one thing at a time.

## Symptom one: the loss becomes NaN

`nan` (not a number) spreads. Once one value is `nan`, every operation that touches it returns `nan`. The usual sources are a logarithm of zero, a division by zero, and numbers that overflow to infinity.

```python run
import numpy as np

with np.errstate(divide="ignore", invalid="ignore", over="ignore"):
    print("log(0) =", np.log(0.0))
    print("1 / 0 =", 1.0 / np.array([0.0]))
    print("exp(1000) =", np.exp(1000.0))
    print("inf - inf =", np.inf - np.inf)
```

Check for non-finite values at the points where they appear, not only at the end. A `nan` in the loss is usually created one step earlier, in a gradient or an activation.

```python run
def any_nonfinite(arrays):
    return any(not np.all(np.isfinite(a)) for a in arrays)

healthy = [np.array([0.1, -2.0]), np.array([[3.0]])]
broken = [np.array([0.1, np.nan]), np.array([[3.0]])]
print("healthy:", any_nonfinite(healthy), "| broken:", any_nonfinite(broken))
```

## Symptom two: exploding updates

When the learning rate is too large for the curvature of the loss, each step overshoots the valley and lands further away. The parameters grow geometrically, and soon the loss is infinite.

```python run
def run_gd(lr, steps=30, w0=10.0):
    w = w0
    for _ in range(steps):
        w = w - lr * w           # gradient of f(w) = w²/2 is w
    return w

for lr in [0.1, 0.9, 1.5, 2.5]:
    print(f"lr {lr:<4} -> w after 30 steps: {run_gd(lr):.3e}")
```

A learning-rate sweep like this is the fastest diagnosis. If the loss falls for small rates and explodes for large ones, the rate is the problem.

## Symptom three: the model cannot learn at all

Before you blame the data or the architecture, run the **overfit-one-batch test**. Take eight examples and train on them alone. A correct network with a correct loss must drive the loss close to zero. If it cannot memorize eight points, something in the code is broken.

```python run
rng = np.random.default_rng(0)
X = rng.normal(size=(8, 2))
Y = (X[:, :1] > 0).astype(float)          # an easy labelling to memorize

W1 = rng.normal(0, 0.5, (2, 16)); b1 = np.zeros(16)
W2 = rng.normal(0, 0.5, (16, 1)); b2 = np.zeros(1)
lr = 0.5
for step in range(600):
    A1 = np.tanh(X @ W1 + b1)
    P = 1 / (1 + np.exp(-(A1 @ W2 + b2)))
    dZ2 = (P - Y) / len(X)
    dZ1 = (dZ2 @ W2.T) * (1 - A1 ** 2)
    W2 -= lr * (A1.T @ dZ2); b2 -= lr * dZ2.sum(0)
    W1 -= lr * (X.T @ dZ1); b1 -= lr * dZ1.sum(0)

P = 1 / (1 + np.exp(-(np.tanh(X @ W1 + b1) @ W2 + b2)))
loss = -np.mean(Y * np.log(P) + (1 - Y) * np.log(1 - P))
print("loss after overfitting one batch:", round(float(loss), 4))
print("predictions match labels:", bool(np.all((P > 0.5) == Y)))
```

If this test passes, your model and loss are wired correctly, and you can move on to the data. If it fails, the bug is in the code, and it is much easier to find on eight examples than on a million.

> **Pitfall:** skipping the overfit-one-batch test is the most expensive habit in deep learning. Hours go into tuning a model that was never able to learn.

## Gradient norms tell you what is happening

The **gradient norm** is a single number that summarizes how big the update is. Watching it helps you spot vanishing gradients (it shrinks towards zero) and explosions (it grows without limit). A common remedy for explosions is **gradient clipping**: if the norm is above a threshold, scale every gradient down so the norm equals the threshold.

```python run
def grad_norm(grads):
    return np.sqrt(sum(np.sum(g ** 2) for g in grads.values()))

grads = {"W": np.array([[3.0, 0.0]]), "b": np.array([4.0])}
print("gradient norm:", grad_norm(grads))
```

## Learning-rate sensitivity in practice

```python run
losses = {}
for lr in [0.01, 0.1, 0.5, 1.2]:
    w = 10.0
    for _ in range(40):
        w = w - lr * w
    losses[lr] = w ** 2 / 2
for lr, loss in losses.items():
    status = "converged" if loss < 1e-3 else "not converged"
    print(f"lr {lr:<5} final loss {loss:.3e}  {status}")
```

For this function each step multiplies $w$ by $1 - \eta$. Small rates are safe but slow, a rate of exactly one reaches zero in a single step, and any rate above two makes $|1 - \eta| > 1$, so the iterates diverge. Real networks are more complicated, but the same shape holds: the best rate sits below the edge of stability.

## Challenge: the gradient norm

```python exercise id=grad-norm title="The global gradient norm"
# TODO: `global_norm(grads)` takes a dict of gradient arrays and returns one number: the square root
# of the sum of squares of every entry in every array.
def global_norm(grads):
    ...
--- solution
def global_norm(grads):
    return np.sqrt(sum(np.sum(g ** 2) for g in grads.values()))
--- test
result = global_norm({"a": np.array([3.0, 0.0]), "b": np.array([[0.0, 4.0]])})
assert result is not None, "Replace the `...` in `global_norm` with code that returns the norm."
assert np.isclose(result, 5.0), f"The entries 3, 0, 0 and 4 give sqrt(9 + 16) = 5, but you returned {result!r}."
assert np.isclose(global_norm({"w": np.array([1.0, 1.0, 1.0, 1.0])}), 2.0), "Four entries of 1 give a norm of 2."
--- hint
Square every entry of every array, add all the squares together, then take the square root.
--- hint
`np.sqrt(sum(np.sum(g ** 2) for g in grads.values()))`.
```

## Challenge: clip the gradients

```python exercise id=clip-gradients title="Clip large gradients"
# TODO: `clip_gradients(grads, max_norm)` returns a new dict. If the global norm is larger than max_norm,
# scale every gradient by max_norm / norm so the norm becomes max_norm. Otherwise return the same values.
def clip_gradients(grads, max_norm):
    ...
--- solution
def clip_gradients(grads, max_norm):
    norm = np.sqrt(sum(np.sum(g ** 2) for g in grads.values()))
    scale = min(1.0, max_norm / norm) if norm > 0 else 1.0
    return {k: g * scale for k, g in grads.items()}
--- test
grads = {"a": np.array([3.0, 0.0]), "b": np.array([[0.0, 4.0]])}
result = clip_gradients(grads, 1.0)
assert result is not None, "Replace the `...` in `clip_gradients` with code that returns the clipped gradients."
assert np.allclose(result["a"], [0.6, 0.0]) and np.allclose(result["b"], [[0.0, 0.8]]), f"The norm is 5, so every gradient should be scaled by 1/5. You returned {result}."
small = clip_gradients({"w": np.array([0.1, 0.2])}, 1.0)
assert np.allclose(small["w"], [0.1, 0.2]), "A gradient whose norm is already below max_norm should be left alone."
assert np.allclose(grads["a"], [3.0, 0.0]), "Return a new dict. Do not change the input gradients in place."
--- hint
Compute the norm the same way as the global norm. The scale factor is `max_norm / norm`, but only when the norm is above `max_norm`.
--- hint
`scale = min(1.0, max_norm / norm)`, then return `{k: g * scale for k, g in grads.items()}`.
```

## Challenge: detect non-finite values

```python exercise id=nonfinite-check title="Find values that are not finite"
# TODO: `has_nonfinite(arrays)` returns True if any entry of any array is nan or infinite, otherwise False.
def has_nonfinite(arrays):
    ...
--- solution
def has_nonfinite(arrays):
    return any(not np.all(np.isfinite(a)) for a in arrays)
--- test
ok = has_nonfinite([np.array([1.0, 2.0]), np.array([[0.5]])])
assert ok is not None, "Replace the `...` in `has_nonfinite` with code that returns True or False."
assert ok is False, "Finite arrays should return False."
assert has_nonfinite([np.array([1.0, np.nan])]) is True, "A nan should be reported."
assert has_nonfinite([np.array([np.inf])]) is True, "Infinity should be reported too."
assert has_nonfinite([]) is False, "An empty list has no bad values."
--- hint
`np.isfinite(a)` gives a boolean array that is False for nan and infinity. Check whether all of it is True.
--- hint
`return any(not np.all(np.isfinite(a)) for a in arrays)`.
```

## Debug the learning rate

This loop is meant to shrink a weight to zero within 50 steps, but the learning rate makes it diverge.

```python debug id=exploding-lr title="Choose a rate that converges"
w = 10.0
lr = 2.5                  # the gradient of w²/2 is w, and this rate overshoots every step
for _ in range(50):
    w = w - lr * w
print("final |w|:", abs(w))
--- solution
w = 10.0
lr = 0.5                  # small enough that each step lands closer to zero
for _ in range(50):
    w = w - lr * w
print("final |w|:", abs(w))
--- test
assert abs(w) < 1e-3, f"After 50 steps |w| should be close to zero, but it is {abs(w):.3g}. Each step multiplies w by (1 - lr), so the rate must keep |1 - lr| below 1."
assert lr < 2.0, "A learning rate of 2 or more never converges on this function."
--- hint
Each step multiplies `w` by `1 - lr`. For the magnitude to shrink, `|1 - lr|` must be less than 1.
--- hint
A rate between 0 and 2 converges. Try a value in the middle, such as 0.5.
```

## Predict the check

```python predict id=predict-finite title="Which values are finite?"
import numpy as np
print(np.isfinite(np.array([1.0, np.inf, np.nan])).tolist())
--- options
* [True, False, False]
[True, True, False]
[False, False, False]
[True, False, True]
--- explain
`np.isfinite` is True only for ordinary numbers. The first value is finite, while infinity and nan are not. That is exactly the test you want before trusting a loss or a gradient.
```

## Recap

- A `nan` loss is created by an earlier operation. Check for non-finite values where they first appear.
- An exploding loss usually means the learning rate is too large for the curvature. A sweep over rates shows where training breaks.
- The overfit-one-batch test checks that the model and loss can learn at all, and it is the fastest way to find a wiring bug.
- Track the gradient norm, and clip it when it explodes.

**Up next:** convolutions, the operation behind image models, which you will build from first principles.
