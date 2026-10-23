A two-neuron network already has a gradient that is annoying to write by hand. Ten layers make it hopeless. What saves you is a simple idea: write the computation as a **graph** of small operations, and apply the chain rule one node at a time, from the output back to the inputs. That procedure is **backpropagation**, and every deep-learning framework uses it.

In this lesson you will draw a computational graph, run the forward pass and the backward pass on paper and in code, and see why gradients from different paths add up.

## Every operation is a node

Take $f = (a \cdot b + c)^2$. Break it into the small steps a computer actually performs:

$$
e = a \cdot b, \qquad d = e + c, \qquad f = d^2
$$

Each line is one node. The forward pass computes the values from left to right. The backward pass asks, for each node, how much the output changes when that node changes.

```python run
a, b, c = 2.0, -3.0, 10.0

# forward pass: compute and remember every intermediate value
e = a * b
d = e + c
f = d ** 2
print("e =", e, "| d =", d, "| f =", f)
```

Save the intermediate values. Backpropagation needs them, and a framework stores exactly these values for you.

## The chain rule, one link at a time

The chain rule says that the derivative of a composition is the product of the local derivatives along the path:

$$
\frac{\partial f}{\partial a} = \frac{\partial f}{\partial d} \cdot \frac{\partial d}{\partial e} \cdot \frac{\partial e}{\partial a}
$$

Each local derivative is easy: $\partial f/\partial d = 2d$, $\partial d/\partial e = 1$ and $\partial e/\partial a = b$. Multiply them, starting from the output.

```python run
# backward pass: start at the output with df/df = 1 and walk back
df = 1.0
dd = df * 2 * d          # local derivative of d**2 is 2d
de = dd * 1.0            # local derivative of e + c with respect to e is 1
dc = dd * 1.0            # and with respect to c is also 1
da = de * b              # local derivative of a * b with respect to a is b
db = de * a              # and with respect to b is a

print("df/da =", da, "| df/db =", db, "| df/dc =", dc)
```

Each node sends one number backwards: the gradient of the output with respect to that node. A node only needs its own local derivative and the gradient arriving from above.

## Check it numerically

```python run
def f_of(a, b, c):
    return (a * b + c) ** 2

h = 1e-6
num_da = (f_of(a + h, b, c) - f_of(a - h, b, c)) / (2 * h)
num_dc = (f_of(a, b, c + h) - f_of(a, b, c - h)) / (2 * h)
print("numerical df/da:", round(num_da, 4), "| analytic:", da)
print("numerical df/dc:", round(num_dc, 4), "| analytic:", dc)
```

The backward pass and the finite-difference check agree. That agreement is the foundation of everything you will build in the next lessons.

## When one value feeds two paths

If a variable is used twice, its gradient is the **sum** of the gradients from each use. Consider $g = x^2 + 3x$. The value $x$ appears in two places, so its gradient collects both contributions.

```python run
x = 4.0
sq = x * x               # first use of x
lin = 3 * x              # second use of x
g = sq + lin

dg_dsq = 1.0
dg_dlin = 1.0
dx = dg_dsq * (2 * x) + dg_dlin * 3     # both paths add to x's gradient
print("dg/dx =", dx, "| numerical:", round((((x + 1e-6) ** 2 + 3 * (x + 1e-6)) - (x * x + 3 * x)) / 1e-6, 4))
```

> **Pitfall:** when a value is used more than once, backprop must add its gradients, not replace them. Forgetting this is one of the most common bugs when people write their own autograd, and you will meet it in lesson 8.

## Challenge: the gradients of a small graph

```python exercise id=graph-grads title="Backprop through a small graph"
# TODO: `grads(a, b, c)` returns the tuple (df/da, df/db, df/dc) for f = (a * b + c) ** 2.
# Use the chain rule: the local derivatives are 2d for the square, 1 for the addition,
# b for the multiplication with respect to a, and a for the multiplication with respect to b.
def grads(a, b, c):
    ...
--- solution
def grads(a, b, c):
    e = a * b
    d = e + c
    df_dd = 2 * d
    return df_dd * b, df_dd * a, df_dd
--- test
result = grads(2.0, -3.0, 10.0)
assert result is not None, "Replace the `...` in `grads` with code that returns the three gradients."
da, db, dc = result
assert np.isclose(da, -24.0) and np.isclose(db, 16.0) and np.isclose(dc, 8.0), f"For a=2, b=-3, c=10 the gradients are (-24, 16, 8), but you returned {result}."
r2 = grads(1.0, 1.0, 0.0)
assert np.allclose(r2, (2.0, 2.0, 2.0)), f"For a=1, b=1, c=0 the gradients are (2, 2, 2), but you returned {r2}."
--- hint
Compute `d = a * b + c` first. The output's gradient with respect to `d` is `2 * d`.
--- hint
Multiply that by `b` for `a`, by `a` for `b`, and by `1` for `c`.
```

## Challenge: a value used on two paths

```python exercise id=shared-gradient title="Add the gradients from both paths"
# TODO: `shared_grad(x)` returns dg/dx for g = x² + 3x. The value x is used on two paths,
# so its gradient is the sum of the two contributions.
def shared_grad(x):
    ...
--- solution
def shared_grad(x):
    return 2 * x + 3
--- test
result = shared_grad(4.0)
assert result is not None, "Replace the `...` in `shared_grad` with code that returns the gradient."
assert np.isclose(result, 11.0), f"For g = x² + 3x at x = 4 the gradient is 2x + 3 = 11, but you returned {result!r}."
assert np.isclose(shared_grad(-1.0), 1.0), "The gradient at x = -1 should be 1. Add the path through x² and the path through 3x."
--- hint
Differentiate each path separately: the x² path gives 2x, and the 3x path gives 3. Then add them.
--- hint
`return 2 * x + 3`.
```

## Debug the missing upstream gradient

```python debug id=upstream-gradient title="Multiply by the gradient from above"
# Local derivative of the square is 2d. Backprop must include the gradient that arrived from above.
a, b, c = 2.0, -3.0, 10.0
e = a * b
d = e + c
f = d ** 2
upstream = 0.5          # pretend a later layer already told us df/df = 0.5 ... not 1
df_dd = 2 * d           # local derivative only
da = df_dd * b
print("df/da seen by the optimizer:", da)
--- solution
a, b, c = 2.0, -3.0, 10.0
e = a * b
d = e + c
f = d ** 2
upstream = 0.5
df_dd = upstream * 2 * d
da = df_dd * b
print("df/da seen by the optimizer:", da)
--- test
assert np.isclose(da, -12.0), f"With an upstream gradient of 0.5, df/da should be -12.0, but you have {da}. Multiply the local derivative by the upstream gradient."
assert np.isclose(f, 16.0), "The forward value f should still be 16."
--- hint
The chain rule multiplies every local derivative by the gradient that arrives from the node above, which here is `upstream`.
--- hint
`df_dd = upstream * 2 * d`.
```

## Predict the gradient

```python predict id=predict-chain title="What is df/dx?"
x = 3.0
f = (2 * x) ** 2          # f = (2x)²
df_dx = 2 * (2 * x) * 2   # chain rule: outer derivative, then inner derivative
print(df_dx)
--- options
* 24.0
12.0
36.0
6.0
--- explain
f = 4x², so df/dx = 8x. At x = 3 that is 24. The chain rule gets there as 2 × (2x) × 2 = 8x, outer derivative times inner derivative.
```

## Recap

- A computation is a graph of small operations. The forward pass computes values; the backward pass computes gradients.
- The chain rule multiplies local derivatives along each path, starting from the output.
- A value used on several paths receives the sum of the gradients along all of them.
- Always verify a backward pass against a numerical estimate, and remember that gradients must include what arrives from above.

**Up next:** you will build a tiny automatic-differentiation engine. The computer will build the graph and run the backward pass for you, exactly as a framework does.
