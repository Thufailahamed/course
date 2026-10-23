A neural network learns by making its loss a little smaller on every step. The rule that decides *which way* to move each weight is **gradient descent**, and it is the same rule whether the network has one neuron or a billion. In this lesson you will train a single neuron by hand, with the gradient written out, and watch the loss fall.

## The idea: walk downhill

For a loss $L(w)$, the gradient $\frac{dL}{dw}$ points uphill. To reduce the loss, step the opposite way, by an amount set by the **learning rate** $\eta$:

$$
w \leftarrow w - \eta \,\frac{dL}{dw}
$$

A small learning rate takes safe, slow steps. A large one takes big steps and may overshoot the bottom of the valley.

```python run
import matplotlib.pyplot as plt

def L(w):
    return (w - 3.0) ** 2          # a simple bowl with its minimum at w = 3

w, lr = 0.0, 0.1
history = [w]
for _ in range(25):
    grad = 2 * (w - 3.0)           # dL/dw, worked out by hand
    w = w - lr * grad
    history.append(w)

print("final w:", round(w, 4), "| loss:", round(L(w), 6))
fig, ax = plt.subplots(figsize=(5, 3))
ws = np.linspace(-1, 7, 200)
ax.plot(ws, L(ws), color="grey"); ax.plot(history, L(np.array(history)), "o-", color="C1")
ax.set_xlabel("w"); ax.set_ylabel("loss"); ax.grid(alpha=0.3)
plt.show()
```

The orange path slides down the bowl and settles at $w = 3$. Each step is proportional to the slope, so the steps shrink as the bottom gets near.

## Check the gradient numerically

Before you trust a hand-written gradient, compare it with a finite-difference estimate. If they agree, the formula is right. This is a habit you should keep for the rest of the course.

```python run
def numerical_grad(f, w, h=1e-6):
    return (f(w + h) - f(w - h)) / (2 * h)

w0 = 0.5
print("analytic:", 2 * (w0 - 3.0))
print("numerical:", round(numerical_grad(L, w0), 6))
```

> **Pitfall:** gradient checks are slow, so use them to verify your code and turn them off for training. A correct gradient that you never checked is still a bet.

## Train a neuron on data

Now the real thing. The data follow $y = 2x + 1$ with a little noise. A linear neuron has a weight $w$ and bias $b$, and the mean squared error is the loss. Its gradients are:

$$
\frac{\partial L}{\partial w} = \frac{2}{n} \sum_i (\hat{y}_i - y_i)\, x_i, \qquad
\frac{\partial L}{\partial b} = \frac{2}{n} \sum_i (\hat{y}_i - y_i)
$$

```python run
rng = np.random.default_rng(0)
X = rng.uniform(-1, 1, size=(100, 1))
y = 2.0 * X[:, 0] + 1.0 + rng.normal(0, 0.1, size=100)

def predict(X, w, b):
    return X @ w + b

def grads(X, y, w, b):
    residual = predict(X, w, b) - y
    n = len(y)
    dw = 2 / n * (X.T @ residual)
    db = 2 / n * residual.sum()
    return dw, db

w = np.zeros(1)
b = 0.0
lr = 0.5
for step in range(200):
    dw, db = grads(X, y, w, b)
    w = w - lr * dw
    b = b - lr * db

print("learned w:", np.round(w, 3), "(true 2.0)")
print("learned b:", round(b, 3), "(true 1.0)")
```

After 200 steps the neuron has found the line. Nothing in the loop knows the answer; the gradient alone pointed it there.

## Watch the loss fall

```python run
w = np.zeros(1)
b = 0.0
losses = []
for step in range(100):
    pred = predict(X, w, b)
    losses.append(np.mean((pred - y) ** 2))
    dw, db = grads(X, y, w, b)
    w = w - lr * dw
    b = b - lr * db

print("loss at step 0:", round(losses[0], 4))
print("loss at step 99:", round(losses[-1], 4))
```

Try `lr = 0.05` and `lr = 1.5` in the cell above. The small rate learns slowly, and the large one can diverge: the weights grow larger and larger, and the loss explodes. Choosing the learning rate is the first hyperparameter decision you will make in practice.

## Challenge: the gradients of the loss

```python exercise id=linear-gradient title="Gradients of the squared-error loss"
# TODO: `mse_grads(X, y, w, b)` returns the pair (dw, db) of gradients of the mean squared error
# for the linear model pred = X @ w + b. dw has the same shape as w.
def mse_grads(X, y, w, b):
    ...
--- solution
def mse_grads(X, y, w, b):
    residual = X @ w + b - y
    n = len(y)
    dw = 2 / n * (X.T @ residual)
    db = 2 / n * residual.sum()
    return dw, db
--- test
X_t = np.array([[1.0], [2.0], [3.0]])
y_t = np.array([2.0, 4.0, 7.0])
result = mse_grads(X_t, y_t, np.array([0.5]), 0.0)
assert result is not None, "Replace the `...` in `mse_grads` with code that returns (dw, db)."
dw, db = result
assert np.shape(dw) == (1,), f"dw should have the same shape as w, which is (1,), but it has {np.shape(dw)}."
assert np.allclose(dw, [-16.0]), f"For this data dw should be -16.0, but you returned {dw}."
assert np.isclose(db, -20 / 3), f"For this data db should be -20/3 ≈ -6.667, but you returned {db}."
X_r = np.random.default_rng(1).normal(size=(20, 2))
y_r = np.random.default_rng(2).normal(size=20)
w_r, b_r = np.array([0.3, -0.2]), 0.1
eps = 1e-6
num_dw = np.array([(np.mean((X_r @ (w_r + eps * e) + b_r - y_r) ** 2) - np.mean((X_r @ (w_r - eps * e) + b_r - y_r) ** 2)) / (2 * eps) for e in np.eye(2)])
assert np.allclose(mse_grads(X_r, y_r, w_r, b_r)[0], num_dw, atol=1e-5), "dw does not match a numerical gradient check. Check the factor 2/n and the transpose."
--- hint
The residual is `X @ w + b - y`. The weight gradient multiplies the transposed inputs by the residual, and the bias gradient sums the residual.
--- hint
`dw = 2 / n * (X.T @ residual)` and `db = 2 / n * residual.sum()`, where `n = len(y)`.
```

## Challenge: take one step

```python exercise id=gd-step title="One gradient descent step"
# TODO: `gradient_step(w, b, dw, db, lr)` returns the updated parameters (w_new, b_new).
def gradient_step(w, b, dw, db, lr):
    ...
--- solution
def gradient_step(w, b, dw, db, lr):
    return w - lr * dw, b - lr * db
--- test
result = gradient_step(np.array([1.0, -1.0]), 0.5, np.array([2.0, 0.0]), 1.0, 0.1)
assert result is not None, "Replace the `...` in `gradient_step` with code that returns the new parameters."
w_new, b_new = result
assert np.allclose(w_new, [0.8, -1.0]), f"w should move against its gradient to [0.8, -1.0], but you returned {w_new}."
assert np.isclose(b_new, 0.4), f"b should move against its gradient to 0.4, but you returned {b_new}."
w2, b2 = gradient_step(np.zeros(3), 2.0, np.array([-1.0, 0.0, 1.0]), -3.0, 0.5)
assert np.allclose(w2, [0.5, 0.0, -0.5]) and np.isclose(b2, 3.5), "Subtract the learning rate times the gradient. A negative gradient should increase the parameter."
--- hint
Each parameter moves by `- lr * gradient`. Do this for `w` and for `b` separately.
--- hint
`return w - lr * dw, b - lr * db`.
```

## Debug the sign

```python debug id=sign-update title="Move downhill, not uphill"
w = np.array([0.0])
b = 0.0
dw = np.array([2.0])    # the gradient says the loss rises as w grows
db = 1.0
lr = 0.1

w = w + lr * dw         # which direction is this?
b = b - lr * db
print("w:", w, "b:", b)
--- solution
w = np.array([0.0])
b = 0.0
dw = np.array([2.0])    # the gradient says the loss rises as w grows
db = 1.0
lr = 0.1

w = w - lr * dw         # move against the gradient
b = b - lr * db
print("w:", w, "b:", b)
--- test
assert np.allclose(w, [-0.2]), f"w should move against its gradient, to [-0.2], but it is {w}. Gradient descent subtracts the step."
assert np.isclose(b, -0.1), f"b should be -0.1, but it is {b}."
--- hint
The gradient points uphill, and you want to go downhill. Compare the sign in the `w` line with the sign in the `b` line.
--- hint
Make the `w` line match the `b` line: `w = w - lr * dw`.
```

## Predict the update

```python predict id=predict-update title="Which way does w move?"
w = 1.0
dw = -4.0            # the loss decreases as w grows
lr = 0.25
w = w - lr * dw
print(w)
--- options
* 2.0
0.0
-2.0
1.0
--- explain
The gradient is negative, so the loss falls as w increases. The update subtracts lr × dw = 0.25 × (-4) = -1, which means w becomes 1 - (-1) = 2. The step is in the direction that lowers the loss.
```

## Recap

- Gradient descent moves each parameter by $-\eta \times$ its gradient, which is the direction that lowers the loss.
- The learning rate sets the step size. Too small is slow, too large can diverge.
- Check hand-written gradients with a numerical estimate before you trust them.
- For a linear neuron with squared error, the gradients are a residual multiplied by the inputs, and the bias gradient is the residual's sum.

**Up next:** computational graphs. A network has many layers, and you need a way to apply the chain rule to all of them without writing each gradient by hand.
