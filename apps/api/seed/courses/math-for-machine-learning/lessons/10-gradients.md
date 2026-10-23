A model with a thousand weights has a thousand derivatives, one for each weight. Collecting them into a single vector gives the **gradient**. The gradient points in the direction in which the loss increases fastest, so the opposite direction is the one that decreases it. That single vector is what every optimizer in deep learning computes at every step.

By the end of this lesson you will compute partial derivatives, read a gradient on a contour plot, write a numerical gradient for any function of many variables, and verify the direction of steepest descent with code.

## Partial derivatives: change one thing at a time

For a function of two variables, $f(x, y) = x^2 + 3xy$, the **partial derivative** with respect to $x$ treats $y$ as a constant. You differentiate as if $y$ were a number, and do the same for $y$ separately.

$$
\frac{\partial f}{\partial x} = 2x + 3y, \qquad \frac{\partial f}{\partial y} = 3x
$$

```python run
import numpy as np

def f(x, y):
    return x ** 2 + 3 * x * y

x0, y0, h = 1.0, 2.0, 1e-5
df_dx = (f(x0 + h, y0) - f(x0 - h, y0)) / (2 * h)
df_dy = (f(x0, y0 + h) - f(x0, y0 - h)) / (2 * h)
print(f"∂f/∂x ≈ {df_dx:.4f}   (formula: 2x + 3y = {2 * x0 + 3 * y0})")
print(f"∂f/∂y ≈ {df_dy:.4f}   (formula: 3x = {3 * x0})")
```

Each partial derivative is an ordinary one-dimensional derivative, with everything else held still.

## The gradient collects them all

The **gradient** $\nabla f$ is the vector of all partial derivatives. At the point $(1, 2)$ it is $(8, 3)$.

$$
\nabla f(x, y) = \begin{bmatrix} \partial f / \partial x \\ \partial f / \partial y \end{bmatrix} = \begin{bmatrix} 2x + 3y \\ 3x \end{bmatrix}
$$

A picture makes the idea concrete. The bowl $f = x^2 + y^2$ has circular contours. The arrows below are gradients, and each one points uphill, perpendicular to the contour it sits on.

```python run
import matplotlib.pyplot as plt

xs, ys = np.meshgrid(np.linspace(-3, 3, 200), np.linspace(-3, 3, 200))
Z = xs ** 2 + ys ** 2

g = np.linspace(-2, 2, 9)
gx, gy = np.meshgrid(g, g)

fig, ax = plt.subplots()
ax.contour(xs, ys, Z, levels=10, cmap="viridis")
ax.quiver(gx, gy, 2 * gx, 2 * gy, color="tab:red")
ax.set_aspect("equal")
ax.set_title("Gradient of x² + y²: red arrows point uphill")
plt.show()
```

> **Key fact:** the gradient is perpendicular to the contour lines. Moving along a contour doesn't change the value, so the fastest change must be across it.

## A numerical gradient for any function

For a function of many variables, you can approximate every partial derivative with a central difference, one coordinate at a time. This works for any function you can evaluate, which makes it an excellent check on hand-derived gradients.

```python run
def numerical_gradient(f, x, h=1e-5):
    x = np.asarray(x, dtype=float)
    grad = np.zeros_like(x)
    for i in range(x.size):
        step = np.zeros_like(x)
        step[i] = h
        grad[i] = (f(x + step) - f(x - step)) / (2 * h)
    return grad

bowl = lambda p: p[0] ** 2 + 3 * p[0] * p[1]
p = np.array([1.0, 2.0])
print(numerical_gradient(bowl, p).round(4))
```

The result, `[8, 3]`, matches the formulas above.

## Stepping along the gradient

The gradient points uphill. Step a little along it and the function increases; step against it and the function decreases. Gradient descent is nothing more than repeating the second move.

```python run
g = numerical_gradient(bowl, p)
print("f at p:               ", bowl(p))
print("f after stepping uphill:  ", round(bowl(p + 0.1 * g), 3))
print("f after stepping downhill:", round(bowl(p - 0.1 * g), 3))
```

Going uphill raised the value from 7 to about 15.7, and going downhill lowered it to about 1.1. The gradient told us which way was which.

## Challenges

```python exercise id=gradient-formula title="The gradient by hand"
# TODO: `gradient(p)` should return the gradient of f(x, y) = x**2 + 3*x*y
# at the point p = [x, y], as a NumPy array [df/dx, df/dy].
def gradient(p):
    ...
--- solution
def gradient(p):
    x, y = p
    return np.array([2 * x + 3 * y, 3 * x], dtype=float)
--- test
result = gradient(np.array([1.0, 2.0]))
assert result is not None, "Replace the `...` in `gradient` with code that returns the gradient."
assert np.allclose(result, [8.0, 3.0]), f"The gradient at (1, 2) should be [8, 3], but you returned {result!r}."
assert np.allclose(gradient(np.array([-1.0, 0.5])), [-0.5, -3.0]), "The gradient at (-1, 0.5) should be [-0.5, -3]."
--- hint
Write down both partial derivatives first: 2x + 3y for x and 3x for y.
--- hint
`np.array([2 * x + 3 * y, 3 * x])`, after unpacking `x, y = p`.
```

```python exercise id=numerical-gradient title="Numerical gradient in three dimensions"
# TODO: `numerical_gradient(f, p, h=1e-5)` should approximate the gradient of f at the
# point p, using central differences along each coordinate.
def numerical_gradient(f, p, h=1e-5):
    ...
--- solution
def numerical_gradient(f, p, h=1e-5):
    p = np.asarray(p, dtype=float)
    grad = np.zeros_like(p)
    for i in range(p.size):
        step = np.zeros_like(p)
        step[i] = h
        grad[i] = (f(p + step) - f(p - step)) / (2 * h)
    return grad
--- test
f3 = lambda q: q[0] * q[1] + np.sin(q[2])
result = numerical_gradient(f3, np.array([1.0, 2.0, 0.0]))
assert result is not None, "Replace the `...` in `numerical_gradient` with code that returns the gradient."
assert np.allclose(result, [2.0, 1.0, 1.0], atol=1e-4), f"At (1, 2, 0) the gradient of q0*q1 + sin(q2) is [2, 1, 1], but you returned {np.round(result, 4).tolist()}."
assert np.allclose(numerical_gradient(f3, np.array([3.0, -1.0, np.pi / 2])), [-1.0, 3.0, 0.0], atol=1e-4), "At (3, -1, pi/2) the gradient is [-1, 3, 0]."
--- hint
Loop over the coordinates. For coordinate i, build a step vector that is zero except h at position i, then apply the central difference from the 1-D case.
--- hint
Inside the loop: `step = np.zeros_like(p); step[i] = h`, then `grad[i] = (f(p + step) - f(p - step)) / (2 * h)`.
```

```python debug int-gradient id=int-gradient title="A gradient that explodes"
def numerical_gradient(f, x, h=1e-6):
    grad = np.zeros(len(x))
    for i in range(len(x)):
        x_plus = x.copy()
        x_plus[i] += h
        x_minus = x.copy()
        x_minus[i] -= h
        grad[i] = (f(x_plus) - f(x_minus)) / (2 * h)
    return grad

def loss(w):
    return np.sum((w - 3.0) ** 2)

weights = np.array([1, 2])
print(numerical_gradient(loss, weights))
--- solution
def numerical_gradient(f, x, h=1e-6):
    grad = np.zeros(len(x))
    for i in range(len(x)):
        x_plus = x.copy()
        x_plus[i] += h
        x_minus = x.copy()
        x_minus[i] -= h
        grad[i] = (f(x_plus) - f(x_minus)) / (2 * h)
    return grad

def loss(w):
    return np.sum((w - 3.0) ** 2)

weights = np.array([1.0, 2.0])
print(numerical_gradient(loss, weights))
--- test
result = numerical_gradient(loss, weights)
assert np.allclose(result, [-4.0, -2.0], atol=1e-3), f"The gradient of sum((w - 3)²) at the weights (1, 2) is [-4, -2], but numerical_gradient returned {np.round(result, 3).tolist()}."
--- hint
Look at the size of the printed numbers. A gradient of this function should be around -4 and -2, not in the millions.
--- hint
Integer arrays cannot store the tiny step `h`: `x_plus[i] += 1e-6` silently keeps only the whole part. Use decimal numbers, for example `np.array([1.0, 2.0])`.
```

```python predict id=predict-grad title="Which way is uphill?"
x, y = 2.0, 3.0
print(np.array([y, x]))
--- options
* [3. 2.]
[2. 3.]
[6. 6.]
[1. 1.]
--- explain
For `f(x, y) = x * y`, the partial derivative with respect to x is `y = 3`, and with respect to y it is `x = 2`. The gradient is `[3, 2]`, so moving toward larger x and y raises the function.
```

## Recap

- A partial derivative differentiates with respect to one variable, holding the others fixed.
- The gradient collects all partial derivatives into one vector that points in the direction of fastest increase.
- The gradient is perpendicular to the contour lines of the function.
- A numerical gradient uses central differences along each coordinate, which makes it a reliable check on derived formulas.
- Use floating-point arrays for anything you perturb by tiny steps.

**Up next:** gradient descent. Repeatedly stepping against the gradient is how a model learns.
