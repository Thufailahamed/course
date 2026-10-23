Training a model means asking one question over and over: if I nudge this weight a little, how much does the error change? The answer to that question is a **derivative**. It measures sensitivity, the rate at which an output responds to an input. Every learning algorithm in this course, from gradient descent to backpropagation, is built on that single idea.

By the end of this lesson you will estimate derivatives numerically, understand why central differences are more accurate, check the derivative of the sigmoid function that appears in every classifier, and write a numerical derivative from scratch.

## The slope of a curve

The derivative $f'(x)$ is the slope of the tangent line at $x$. You can estimate it by drawing a secant line through $(x, f(x))$ and a nearby point $(x + h, f(x+h))$, then letting $h$ shrink.

$$
f'(x) \approx \frac{f(x + h) - f(x)}{h}
$$

```python run
import numpy as np

def f(x):
    return x ** 2

x0 = 3.0      # the exact derivative of x**2 at 3 is 2 * 3 = 6
for h in [1.0, 0.1, 0.01, 0.0001]:
    slope = (f(x0 + h) - f(x0)) / h
    print(f"h = {h:<8} slope ≈ {slope:.4f}")
```

As $h$ shrinks, the estimate approaches 6. You can watch the secant line turn into the tangent.

## Central differences are much more accurate

Looking forward from $x$ introduces an error that is proportional to $h$. Looking symmetrically, one step to each side, cancels the leading error and gives an error proportional to $h^2$. That is far more accurate for the same step size.

$$
f'(x) \approx \frac{f(x + h) - f(x - h)}{2h}
$$

```python run
def central_slope(f, x, h=1e-5):
    return (f(x + h) - f(x - h)) / (2 * h)

print(f"central difference: {central_slope(f, 3.0):.6f}")
print(f"forward difference: {(f(3.0 + 1e-5) - f(3.0)) / 1e-5:.6f}")
```

> **Pitfall:** the step size has a sweet spot. Too large and the approximation is crude; too small and floating-point rounding dominates. A step around $10^{-5}$ is a safe default for central differences on ordinary functions.

## The rules you already know

For most functions you will meet, you don't need to estimate the derivative at all. A few rules cover most cases:

- **Power rule:** $\dfrac{d}{dx} x^n = n\,x^{n-1}$
- **Sum rule:** $(f + g)' = f' + g'$
- **Constant multiple:** $(c\,f)' = c\,f'$

The most important derivative in machine learning is the **sigmoid**, which squashes any number into a probability between 0 and 1. Its derivative has a beautifully simple form that you will use again and again.

$$
\sigma(z) = \frac{1}{1 + e^{-z}}, \qquad \sigma'(z) = \sigma(z)\,\bigl(1 - \sigma(z)\bigr)
$$

```python run
def sigmoid(z):
    return 1 / (1 + np.exp(-z))

z = 0.5
analytic = sigmoid(z) * (1 - sigmoid(z))
numeric = central_slope(sigmoid, z)
print(f"formula: {analytic:.6f}   numerical: {numeric:.6f}")
```

Both numbers agree. The formula is faster and exact; the numerical version is a check you can use on any function, including ones you can't differentiate by hand.

## The tangent line is the best linear approximation

Near $x$, the function looks like its tangent line:

$$
f(x + \delta) \approx f(x) + f'(x)\,\delta
$$

That's why derivatives are useful for learning: they tell you how a small change in an input changes the output, and an optimizer can use that to choose a good step.

```python run
import matplotlib.pyplot as plt

xs = np.linspace(0, 4, 200)
x0 = 2.0
tangent = f(x0) + central_slope(f, x0) * (xs - x0)

fig, ax = plt.subplots()
ax.plot(xs, f(xs), label="f(x) = x²")
ax.plot(xs, tangent, "--", label="tangent at x = 2")
ax.scatter([x0], [f(x0)], color="black", zorder=3)
ax.set_ylim(-1, 12); ax.grid(alpha=0.3); ax.legend()
plt.show()
```

## Derivatives as sensitivity in a loss

Suppose a model with one weight $w$ has the loss $L(w) = (2w - 3)^2$. The derivative tells you which way to move $w$ to reduce the loss, and how fast it will fall.

```python run
def loss(w):
    return (2 * w - 3) ** 2

w = 1.0
print("loss now:", loss(w), "| slope:", round(central_slope(loss, w), 4))
print("loss after a small step to w = 1.01:", round(loss(w + 0.01), 4))
```

The slope is negative, so increasing $w$ lowers the loss. The sign and size of the derivative are exactly the information an optimizer needs.

## Challenges

```python exercise id=numerical-derivative title="Write a numerical derivative"
# TODO: `numerical_derivative(f, x, h=1e-5)` should return the central-difference
# estimate of f'(x).
def numerical_derivative(f, x, h=1e-5):
    ...
--- solution
def numerical_derivative(f, x, h=1e-5):
    return (f(x + h) - f(x - h)) / (2 * h)
--- test
result = numerical_derivative(np.sin, 0.0)
assert result is not None, "Replace the `...` in `numerical_derivative` with code that returns the slope."
assert np.isclose(result, 1.0, atol=1e-4), f"The derivative of sin at 0 is cos(0) = 1, but you returned {result!r}."
assert np.isclose(numerical_derivative(lambda t: t ** 3, 2.0), 12.0, atol=1e-4), "The derivative of x³ at x = 2 is 12."
assert np.isclose(numerical_derivative(np.exp, 1.0), np.e, atol=1e-4), "The derivative of eˣ is itself, so at x = 1 it should be e."
--- hint
Central difference: evaluate `f` a step to the right and a step to the left, subtract, and divide by the full width `2 * h`.
--- hint
`return (f(x + h) - f(x - h)) / (2 * h)`.
```

```python exercise id=dsigmoid title="The derivative of the sigmoid"
# TODO: `dsigmoid(z)` should return the derivative of the sigmoid at z,
# using the formula sigma(z) * (1 - sigma(z)). The sigmoid is 1 / (1 + exp(-z)).
def dsigmoid(z):
    ...
--- solution
def dsigmoid(z):
    s = 1 / (1 + np.exp(-z))
    return s * (1 - s)
--- test
result = dsigmoid(0.0)
assert result is not None, "Replace the `...` in `dsigmoid` with code that returns the derivative."
assert np.isclose(result, 0.25), f"The sigmoid's derivative at 0 is 0.25, but you returned {result!r}."
for z in [-2.0, 1.5, 3.0]:
    s = 1 / (1 + np.exp(-z))
    assert np.isclose(dsigmoid(z), s * (1 - s)), f"dsigmoid({z}) should be sigma({z}) * (1 - sigma({z})) = {s * (1 - s):.6f}."
--- hint
Write `s = 1 / (1 + np.exp(-z))` first, then return `s * (1 - s)`.
--- hint
The sigmoid's derivative peaks at z = 0 with value 0.25, which is a useful check.
```

```python debug central-denominator id=central-bug title="Twice as steep"
def central_slope(f, x, h=1e-5):
    # Central difference: (f(x + h) - f(x - h)) / (2h)
    return (f(x + h) - f(x - h)) / h

print("slope of x**3 at x = 2:", round(central_slope(lambda t: t ** 3, 2.0), 3))
--- solution
def central_slope(f, x, h=1e-5):
    # Central difference: (f(x + h) - f(x - h)) / (2h)
    return (f(x + h) - f(x - h)) / (2 * h)

print("slope of x**3 at x = 2:", round(central_slope(lambda t: t ** 3, 2.0), 3))
--- test
assert np.isclose(central_slope(lambda t: t ** 3, 2.0), 12.0, atol=1e-4), f"The slope of x³ at 2 is 12, but central_slope returned {central_slope(lambda t: t ** 3, 2.0)!r}."
assert np.isclose(central_slope(np.sin, 0.0), 1.0, atol=1e-4), "The slope of sin at 0 is 1."
--- hint
Compare the printed value with the true slope: the derivative of x³ at 2 is 3 × 2² = 12. The result is exactly double that.
--- hint
The denominator must be the full distance between the two points, which is `2 * h`, not `h`.
```

```python predict id=predict-slope title="Estimate the slope"
f = lambda x: x * x
print(round((f(1 + 1e-6) - f(1)) / 1e-6, 3))
--- options
* 2.0
1.0
2.000001
4.0
--- explain
The slope of x² at x = 1 is 2x = 2. The tiny step changes the answer only in the sixth decimal place, and rounding to three places hides that.
```

## Recap

- The derivative is the slope of the tangent line, and the rate at which an output responds to an input.
- A numerical derivative uses a small step $h$. Central differences are accurate to order $h^2$.
- The sigmoid has the derivative $\sigma(z)(1 - \sigma(z))$, which you will use in every classifier.
- Near $x$, a function looks like its tangent line, so the derivative tells an optimizer which way to move.

**Up next:** functions of many variables, where a single derivative becomes a gradient vector that points uphill in every direction at once.
