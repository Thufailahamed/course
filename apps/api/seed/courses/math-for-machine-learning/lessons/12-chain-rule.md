A neural network is a long chain of simple functions: a multiplication, an addition, a squashing, and then another round. To train it, you need the gradient of the final loss with respect to every weight in the chain. The **chain rule** provides it. It says that the derivative of a composition is the product of the derivatives along the chain, and **backpropagation** is nothing more than applying the chain rule efficiently, from the output back to the input.

By the end of this lesson you will apply the chain rule to composite functions, run a forward and backward pass by hand for a single neuron, verify it numerically, and see why gradients can vanish through deep stacks of sigmoids.

## Functions inside functions

If $h(x) = f(g(x))$, the chain rule says

$$
h'(x) = f'(g(x)) \cdot g'(x)
$$

Take $h(x) = \sin(x^2)$. The inside is $g(x) = x^2$ and the outside is $\sin$. The derivative is $\cos(x^2)$ times the inner derivative $2x$.

```python run
import numpy as np

def h(x):
    return np.sin(x ** 2)

def dh(x):
    return np.cos(x ** 2) * 2 * x

x = 1.2
numeric = (h(x + 1e-6) - h(x - 1e-6)) / 2e-6
print(f"formula: {dh(x):.6f}   numerical: {numeric:.6f}")
```

The two numbers agree. Every nested function you meet in ML is handled the same way: differentiate the outside, keep the inside, and multiply by the derivative of the inside.

## A neuron, step by step

A single artificial neuron takes an input $x$, multiplies it by a weight $w$, adds a bias $b$, squashes the result with a sigmoid, and compares the output with a target $t$ using a squared error. Written as a chain:

$$
z = wx + b, \qquad a = \sigma(z), \qquad L = (a - t)^2
$$

Training needs $\partial L / \partial w$. The **forward pass** computes each intermediate value from left to right. The **backward pass** multiplies the local derivatives from right to left.

```python run
x, w, b, t = 2.0, 0.5, -0.25, 1.0

# Forward pass: compute each intermediate value
z = w * x + b
a = 1 / (1 + np.exp(-z))
L = (a - t) ** 2

# Backward pass: multiply the local derivatives from the output back
dL_da = 2 * (a - t)          # derivative of the squared error
da_dz = a * (1 - a)          # derivative of the sigmoid
dz_dw = x                    # derivative of wx + b with respect to w
dL_dw = dL_da * da_dz * dz_dw

print(f"loss L = {L:.4f}")
print(f"dL/dw  = {dL_dw:.4f}")
```

Each factor is a local derivative that depends only on its own step. The backward pass reuses the values from the forward pass, which is why backpropagation is so efficient.

Let's check the result with a finite difference, which needs no derivative rules at all:

```python run
def loss(w_):
    z_ = w_ * x + b
    return (1 / (1 + np.exp(-z_)) - t) ** 2

eps = 1e-6
numeric = (loss(w + eps) - loss(w - eps)) / (2 * eps)
print("numerical dL/dw:", round(numeric, 6))
print("backprop dL/dw: ", round(dL_dw, 6))
```

They match. Backpropagation gives exactly the same answer as the slow numerical method, but in one backward sweep instead of one evaluation per weight.

## Why deep networks need care

The sigmoid's derivative is at most 0.25, reached at $z = 0$. Backpropagation multiplies one such factor per layer, so the gradient shrinks rapidly as the network gets deeper. This is the **vanishing gradient** problem, and it is one reason modern networks use other activation functions.

```python run
def dsig(z):
    s = 1 / (1 + np.exp(-z))
    return s * (1 - s)

print("largest sigmoid derivative:", round(dsig(0.0), 2))
print(f"best case through 10 sigmoid layers: {0.25 ** 10:.2e}")
```

Even in the best case, ten sigmoid layers scale the gradient down by almost a million. That is why the next lesson's ideas matter.

> **In the wild:** frameworks such as PyTorch record the forward pass and run this backward sweep automatically; it is called *autograd*. Understanding the chain rule tells you what it is actually computing.

## Challenges

```python exercise id=gaussian-derivative title="Derivative of a Gaussian bump"
# TODO: `dgauss(x)` should return the derivative of f(x) = exp(-x**2),
# using the chain rule. It should work for arrays too.
def dgauss(x):
    ...
--- solution
def dgauss(x):
    return -2 * x * np.exp(-x ** 2)
--- test
def gauss(t):
    return np.exp(-t ** 2)

result = dgauss(np.array([0.0, 0.5, -1.3]))
assert result is not None, "Replace the `...` in `dgauss` with code that returns the derivative."
for x0 in [0.0, 0.5, -1.3]:
    h = 1e-6
    numeric = (gauss(x0 + h) - gauss(x0 - h)) / (2 * h)
    assert np.isclose(dgauss(np.array([x0]))[0], numeric, atol=1e-5), f"The derivative at x = {x0} should be about {numeric:.5f}."
--- hint
The outside function is exp, whose derivative is exp itself. The inside is `-x**2`, whose derivative is `-2x`.
--- hint
Multiply the outer derivative `exp(-x**2)` by the inner derivative `-2x`.
```

```python exercise id=neuron-gradient title="Gradient of a single sigmoid neuron"
# TODO: `grad_w(x, w, t)` should return dL/dw for the loss L = (sigmoid(w * x) - t) ** 2,
# where sigmoid(z) = 1 / (1 + exp(-z)). Use the chain rule.
def grad_w(x, w, t):
    ...
--- solution
def grad_w(x, w, t):
    s = 1 / (1 + np.exp(-w * x))
    return 2 * (s - t) * s * (1 - s) * x
--- test
def neuron_loss(x, w, t):
    return (1 / (1 + np.exp(-w * x)) - t) ** 2

result = grad_w(1.5, 0.4, 1.0)
assert result is not None, "Replace the `...` in `grad_w` with code that returns the gradient."
for x0, w0, t0 in [(1.5, 0.4, 1.0), (-2.0, 1.0, 0.0), (0.7, -0.3, 1.0)]:
    h = 1e-6
    numeric = (neuron_loss(x0, w0 + h, t0) - neuron_loss(x0, w0 - h, t0)) / (2 * h)
    got = grad_w(x0, w0, t0)
    assert np.isclose(got, numeric, atol=1e-5), f"At x={x0}, w={w0}, t={t0} the gradient should be about {numeric:.5f}, but grad_w returned {got:.5f}."
--- hint
Three chained steps: the squared error gives `2 * (s - t)`, the sigmoid gives `s * (1 - s)`, and the inside `w * x` gives `x`.
--- hint
`2 * (s - t) * s * (1 - s) * x`, where `s` is the sigmoid of `w * x`.
```

```python debug missing-inner id=missing-inner title="Forgot the inside"
def dh(x):
    # h(x) = sin(x ** 2), so h'(x) = cos(x ** 2) * 2x
    return np.cos(x ** 2)

x = 1.2
print("derivative at 1.2:", round(dh(x), 4))
--- solution
def dh(x):
    # h(x) = sin(x ** 2), so h'(x) = cos(x ** 2) * 2x
    return np.cos(x ** 2) * 2 * x

x = 1.2
print("derivative at 1.2:", round(dh(x), 4))
--- test
def h(t):
    return np.sin(t ** 2)

for x0 in [0.3, 1.2, -0.7]:
    numeric = (h(x0 + 1e-6) - h(x0 - 1e-6)) / 2e-6
    assert np.isclose(dh(x0), numeric, atol=1e-4), f"The derivative at {x0} should be {numeric:.4f}, but dh returned {dh(x0):.4f}."
--- hint
Apply the chain rule. The outside is sin, and the inside is x²: which factor is missing from the answer?
--- hint
The inner derivative of x² is `2x`. Multiply the cosine by it.
```

```python predict id=predict-chain title="Chain rule in action"
x = 0
print(2 * (3 * x + 1) * 3)
--- options
1
* 6
9
0
--- explain
For `y = (3x + 1)²` the chain rule gives `dy/dx = 2(3x + 1) · 3`. At x = 0 this is `2 · 1 · 3 = 6`. The outer derivative 2(3x + 1) and the inner derivative 3 multiply together.
```

## Recap

- The chain rule: the derivative of $f(g(x))$ is $f'(g(x))\,g'(x)$.
- A forward pass computes values through a network; a backward pass multiplies local derivatives from the output back to the weights.
- Backpropagation gives the same gradients as finite differences, but in a single backward sweep.
- The sigmoid's derivative is at most 0.25, so gradients can vanish through deep stacks.

**Up next:** probability. Models rarely know anything for certain, so they reason about uncertainty, and the next four lessons build the tools to do that.
