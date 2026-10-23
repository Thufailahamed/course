Gradient descent takes a step in the direction of the steepest slope. That sounds sensible, but on a badly scaled problem the steepest direction is not the direction towards the minimum. The result is a zigzag that crawls. **Optimizers** are update rules that fix this by remembering past gradients, and they are the reason modern networks train at all.

In this lesson you will watch plain gradient descent struggle, add momentum, and then implement Adam, the optimizer most deep-learning models use today.

## A valley that trips up plain gradient descent

The function below is steep in one direction and gentle in the other. Its gradient points mostly across the valley rather than along it.

```python run
import matplotlib.pyplot as plt

def f(w):
    return 0.5 * (10 * w[0] ** 2 + w[1] ** 2)

def grad_f(w):
    return np.array([10 * w[0], w[1]])

def run_sgd(w0, lr, steps):
    w = w0.copy()
    path = [w.copy()]
    for _ in range(steps):
        w = w - lr * grad_f(w)
        path.append(w.copy())
    return np.array(path)

path = run_sgd(np.array([1.0, 1.0]), lr=0.09, steps=60)
print("after 60 steps of plain gradient descent:", np.round(path[-1], 4))
print("loss:", round(f(path[-1]), 6))

xs, ys = np.meshgrid(np.linspace(-1.2, 1.2, 150), np.linspace(-1.2, 1.2, 150))
fig, ax = plt.subplots(figsize=(4.5, 4))
ax.contour(xs, ys, 0.5 * (10 * xs ** 2 + ys ** 2), levels=15, cmap="Greys")
ax.plot(path[:, 0], path[:, 1], "o-", ms=3, color="C1")
ax.set_aspect("equal"); plt.show()
```

The path bounces side to side before it creeps down the long axis. The step size is limited by the steep direction, so the gentle direction takes forever.

## Momentum: remember where you have been

**Momentum** keeps a running velocity $v$, a decaying sum of past gradients. Directions that keep agreeing build up speed, and directions that flip back and forth cancel out.

$$
v \leftarrow \beta v + \nabla L, \qquad w \leftarrow w - \eta\, v
$$

```python run
def run_momentum(w0, lr, beta, steps):
    w = w0.copy()
    v = np.zeros_like(w)
    path = [w.copy()]
    for _ in range(steps):
        v = beta * v + grad_f(w)
        w = w - lr * v
        path.append(w.copy())
    return np.array(path)

mpath = run_momentum(np.array([1.0, 1.0]), lr=0.05, beta=0.9, steps=60)
print("after 60 steps with momentum:", np.round(mpath[-1], 4))
print("loss:", round(f(mpath[-1]), 6))
```

With the same number of steps, momentum ends much closer to the minimum. It is the same idea as a ball rolling downhill and gathering speed.

## Adaptive step sizes: Adam

Adam combines momentum with a per-parameter step size. It tracks a running average of the gradient, $m$, and of its square, $v$, and divides the step by the typical gradient size. Parameters with large gradients take smaller steps, and parameters with small gradients take bigger ones.

Because $m$ and $v$ start at zero, they are biased towards zero early on. Adam corrects this with the factors $1/(1 - \beta_1^t)$ and $1/(1 - \beta_2^t)$:

$$
m \leftarrow \beta_1 m + (1 - \beta_1)\,g, \qquad v \leftarrow \beta_2 v + (1 - \beta_2)\,g^2
$$

$$
\hat m = \frac{m}{1 - \beta_1^t}, \qquad \hat v = \frac{v}{1 - \beta_2^t}, \qquad w \leftarrow w - \eta\,\frac{\hat m}{\sqrt{\hat v} + \epsilon}
$$

```python run
def run_adam(w0, lr, steps, b1=0.9, b2=0.999, eps=1e-8):
    w = w0.copy()
    m = np.zeros_like(w)
    v = np.zeros_like(w)
    for t in range(1, steps + 1):
        g = grad_f(w)
        m = b1 * m + (1 - b1) * g
        v = b2 * v + (1 - b2) * g ** 2
        m_hat = m / (1 - b1 ** t)
        v_hat = v / (1 - b2 ** t)
        w = w - lr * m_hat / (np.sqrt(v_hat) + eps)
    return w

aw = run_adam(np.array([1.0, 1.0]), lr=0.05, steps=60)
print("after 60 steps of Adam:", np.round(aw, 4))
print("loss:", round(f(aw), 6))
```

> **Under the hood:** the bias correction matters most in the first few steps, when $m$ and $v$ are still close to zero. Without it, Adam's first steps are tiny and the optimizer warms up slowly.

## Compare them

```python run
print("plain SGD :", round(f(path[-1]), 6))
print("momentum  :", round(f(mpath[-1]), 6))
print("Adam      :", round(f(aw), 6))
```

No single optimizer wins on every problem. Adam is a strong default, and momentum with a well-chosen learning rate is still widely used, especially for image models.

## Challenge: a momentum step

```python exercise id=momentum-step title="One momentum step"
# TODO: `momentum_step(w, v, grad, lr, beta)` returns (w_new, v_new).
# First update the velocity: v_new = beta * v + grad. Then move: w_new = w - lr * v_new.
def momentum_step(w, v, grad, lr, beta):
    ...
--- solution
def momentum_step(w, v, grad, lr, beta):
    v_new = beta * v + grad
    return w - lr * v_new, v_new
--- test
w = np.array([1.0, 2.0])
v = np.array([0.5, 0.0])
g = np.array([1.0, -2.0])
result = momentum_step(w, v, g, 0.1, 0.9)
assert result is not None, "Replace the `...` in `momentum_step` with code that returns (w_new, v_new)."
w_new, v_new = result
assert np.allclose(v_new, [1.45, -2.0]), f"The new velocity should be 0.9 × [0.5, 0] + [1, -2] = [1.45, -2.0], but you returned {v_new}."
assert np.allclose(w_new, [0.855, 2.2]), f"The new position should be [0.855, 2.2], but you returned {w_new}. Move with the new velocity."
assert np.allclose(w, [1.0, 2.0]), "Do not change the input arrays in place."
--- hint
Compute the new velocity first, using the old velocity and the gradient. Then use the new velocity to move `w`.
--- hint
`v_new = beta * v + grad` and `return w - lr * v_new, v_new`.
```

## Challenge: an Adam step

```python exercise id=adam-step title="One Adam step with bias correction"
# TODO: `adam_step(w, m, v, g, t, lr, b1, b2, eps)` performs one Adam update at step t (starting from 1)
# and returns (w_new, m_new, v_new). Use the bias correction from the lesson.
def adam_step(w, m, v, g, t, lr, b1, b2, eps):
    ...
--- solution
def adam_step(w, m, v, g, t, lr, b1, b2, eps):
    m_new = b1 * m + (1 - b1) * g
    v_new = b2 * v + (1 - b2) * g ** 2
    m_hat = m_new / (1 - b1 ** t)
    v_hat = v_new / (1 - b2 ** t)
    return w - lr * m_hat / (np.sqrt(v_hat) + eps), m_new, v_new
--- test
w0 = np.array([1.0])
result = adam_step(w0, np.zeros(1), np.zeros(1), np.array([0.5]), 1, 0.1, 0.9, 0.999, 1e-8)
assert result is not None, "Replace the `...` in `adam_step` with code that returns (w_new, m_new, v_new)."
w_new, m_new, v_new = result
assert np.allclose(m_new, [0.05]), f"After one step m should be (1 - 0.9) × 0.5 = 0.05, but it is {m_new}."
assert np.allclose(v_new, [0.00025]), f"After one step v should be (1 - 0.999) × 0.5² = 0.00025, but it is {v_new}."
assert np.allclose(w_new, [0.9], atol=1e-6), f"The first Adam step with lr = 0.1 should move w to 0.9, but it moved to {w_new}. Check the bias correction."
w2, m2, v2 = adam_step(np.array([0.0]), np.array([0.0]), np.array([0.0]), np.array([-4.0]), 1, 0.01, 0.9, 0.999, 1e-8)
assert np.allclose(w2, [0.01], atol=1e-6), "The first Adam step moves each parameter by about lr, whatever the gradient's size. Check the sign and the scale."
--- hint
Update `m` and `v` with the decay formulas first, then divide each by its bias correction, `1 - b1 ** t` and `1 - b2 ** t`.
--- hint
The step is `lr * m_hat / (sqrt(v_hat) + eps)`, and you subtract it from `w`.
```

## Debug the missing bias correction

```python debug id=adam-bias title="Correct the early steps"
def adam_update(w, m, v, g, t, lr=0.1, b1=0.9, b2=0.999, eps=1e-8):
    m = b1 * m + (1 - b1) * g
    v = b2 * v + (1 - b2) * g ** 2
    m_hat = m          # bias correction is missing here
    v_hat = v
    return w - lr * m_hat / (np.sqrt(v_hat) + eps), m, v

w, m, v = adam_update(np.array([1.0]), np.zeros(1), np.zeros(1), np.array([0.5]), t=1)
print("w after the first step:", np.round(w, 4), "(expected 0.9)")
--- solution
def adam_update(w, m, v, g, t, lr=0.1, b1=0.9, b2=0.999, eps=1e-8):
    m = b1 * m + (1 - b1) * g
    v = b2 * v + (1 - b2) * g ** 2
    m_hat = m / (1 - b1 ** t)
    v_hat = v / (1 - b2 ** t)
    return w - lr * m_hat / (np.sqrt(v_hat) + eps), m, v

w, m, v = adam_update(np.array([1.0]), np.zeros(1), np.zeros(1), np.array([0.5]), t=1)
print("w after the first step:", np.round(w, 4), "(expected 0.9)")
--- test
w_t, _, _ = adam_update(np.array([1.0]), np.zeros(1), np.zeros(1), np.array([0.5]), t=1)
assert np.allclose(w_t, [0.9], atol=1e-6), f"The first step should move w to 0.9, but it moved to {w_t}. Apply both bias corrections."
w_t2, _, _ = adam_update(np.array([0.0]), np.zeros(1), np.zeros(1), np.array([-2.0]), t=1)
assert np.allclose(w_t2, [0.1], atol=1e-6), f"With lr = 0.1 the first step on a gradient of -2 should move w to 0.1, but it moved to {w_t2}."
--- hint
Without correction, `m` is only 10% of the gradient after one step, which is why the step is too small.
--- hint
Divide `m` by `1 - b1 ** t` and `v` by `1 - b2 ** t` before using them.
```

## Predict the first Adam step

```python predict id=predict-adam title="How big is the first Adam step?"
import numpy as np
g = np.array([100.0])
m = 0.1 * g
v = 0.001 * g ** 2
step = 0.1 * (m / (1 - 0.9)) / (np.sqrt(v / (1 - 0.999)) + 1e-8)
print(np.round(step, 3))
--- options
* [0.1]
[10.0]
[0.001]
[100.0]
--- explain
Adam's first step is about the learning rate, whatever the gradient's size. The bias-corrected m equals g and the bias-corrected sqrt(v) equals |g|, so the ratio is about 1 and the step is lr × 1 = 0.1. This scale-invariance is why Adam is so forgiving of badly scaled gradients.
```

## Recap

- Plain gradient descent zigzags when curvature differs across directions, because one learning rate has to suit the steepest one.
- Momentum accumulates a decaying sum of gradients, so consistent directions speed up and oscillations cancel.
- Adam keeps running averages of the gradient and its square, and corrects both for their zero start.
- The first Adam step is roughly the learning rate in size, whatever the gradient's scale.

**Up next:** regularization. A network that trains well can still memorize its training data, and you will learn how to stop it.
