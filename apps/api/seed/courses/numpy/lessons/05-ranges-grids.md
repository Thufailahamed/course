Plotting a function, sampling a signal, sweeping a learning rate, evaluating a loss surface: they all start with a **sequence of evenly spaced numbers**. NumPy gives you two tools for this, and choosing the right one is the difference between code that works and code that's subtly off by one point.

In this lesson you'll learn when to reach for `arange` versus `linspace`, how to space values logarithmically, and how `meshgrid` turns two 1-D ranges into a 2-D grid so you can evaluate functions of two variables in a single expression.

## `arange`: like `range`, but an array

`np.arange(start, stop, step)` works exactly like Python's built-in `range`, but returns an array and also accepts floats.

```python run
import numpy as np

print(np.arange(5))           # 0 .. 4
print(np.arange(2, 10))       # 2 .. 9
print(np.arange(2, 10, 3))    # 2, 5, 8
print(np.arange(10, 0, -2))   # counting down
```

The interval is **half-open**: `start` is included and `stop` is **not**. `np.arange(2, 10)` stops at 9. That's the same convention as `range` and slicing, so `len(np.arange(n)) == n` always holds.

```python predict id=predict-arange-len title="How many elements?"
a = np.arange(0, 10, 3)
print(len(a))
--- options
3
* 4
10
9
--- explain
The values are `0, 3, 6, 9`. `9` is still below the stop value `10`, so it is included, giving **4** elements. The next step, `12`, would pass the stop.
```

```python exercise id=evens-and-countdown title="Two sequences with arange"
# 1. `evens`: every even number from 0 up to AND INCLUDING 20
# 2. `countdown`: 10, 9, 8, ... down to 1
evens = ...
countdown = ...
--- solution
evens = np.arange(0, 21, 2)
countdown = np.arange(10, 0, -1)
--- test
assert evens is not ..., "Replace the `...` after `evens =` with your code."
assert countdown is not ..., "Replace the `...` after `countdown =` with your code."
assert isinstance(evens, np.ndarray) and isinstance(countdown, np.ndarray), "Both results should be NumPy arrays. Use `np.arange`."
assert evens.tolist() == list(range(0, 21, 2)), f"`evens` should be 0, 2, ..., 20 (11 values) but is {evens.tolist()}. Is 20 included?" if len(evens) != 10 else "`evens` is missing 20: `stop` is exclusive, so it must be larger than 20."
assert countdown.tolist() == list(range(10, 0, -1)), f"`countdown` should be 10, 9, ..., 1 but is {countdown.tolist()}."
--- hint
`stop` is exclusive. To include 20, the stop value has to be a bit larger than 20.
--- hint
To count down, use a negative step: `np.arange(start, stop, -1)`. Again, `stop` itself is not included.
```

### The float-step trap

`arange` with a **float** step looks innocent, but the number of elements is computed as `ceil((stop - start) / step)`, and floating-point arithmetic is never exact:

```python run
print(np.arange(1, 1.3, 0.1))   # 1.3 sneaks in!
print(np.arange(1, 1.4, 0.1))
print((1.3 - 1) / 0.1)          # slightly more than 3
```

`(1.3 - 1) / 0.1` is `3.0000000000000004`, so `ceil` gives **4** elements, and `1.3` appears even though `stop` is supposedly excluded. Whether the endpoint shows up depends on tiny rounding errors.

> **Rule of thumb:** use `arange` for **integers**. For floats, use `linspace` and specify *how many* points you want instead of the step size.

## `linspace`: say how many points you want

`np.linspace(start, stop, num)` returns exactly `num` evenly spaced values, and by default **includes both endpoints**.

```python run
print(np.linspace(0, 1, 5))
print(np.linspace(0, 1, 5, endpoint=False))   # like arange: stop excluded

values, step = np.linspace(0, 10, 4, retstep=True)
print(values, "step =", step)
```

The `retstep=True` option also returns the spacing NumPy chose, which is handy when you need it for numerical integration or plotting.

```python predict id=predict-linspace title="What does this print?"
print(np.linspace(0, 1, 5))
--- options
[0.  0.2 0.4 0.6 0.8]
* [0.   0.25 0.5  0.75 1.  ]
[0.   0.25 0.5  0.75]
[0 1 2 3 4]
--- explain
Five points from 0 to 1 **inclusive** means four equal gaps of `0.25`. NumPy pads the printed numbers so the columns line up, which is why you see `0.` followed by spaces.
```

Here's `linspace` doing what it's best at: sampling a smooth curve. Plotting libraries draw a curve by connecting sampled points, so a couple of hundred `linspace` points give a smooth line. Try changing `200` to `8` and watch the curve turn into a jagged polygon.

```python run
import matplotlib.pyplot as plt

x = np.linspace(0, 2 * np.pi, 200)
plt.plot(x, np.sin(x), label="sin(x)")
plt.plot(x, np.cos(x), label="cos(x)", linestyle="--")
plt.axhline(0, color="gray", linewidth=0.6)
plt.legend()
plt.title("200 points from linspace")
plt.show()
```

```python exercise id=sample-wave title="Sample one full sine wave"
# Create `t`: exactly 50 evenly spaced time points from 0 to 2π, INCLUDING 2π.
# Then compute `wave`: the sine of every time point.
t = ...
wave = ...
--- solution
t = np.linspace(0, 2 * np.pi, 50)
wave = np.sin(t)
--- test
assert t is not ..., "Replace the `...` after `t =` with your code."
assert wave is not ..., "Replace the `...` after `wave =` with your code."
assert isinstance(t, np.ndarray), f"`t` should be a NumPy array, not {type(t).__name__}."
assert t.shape == (50,), f"`t` should contain exactly 50 points but has shape {t.shape}."
assert np.isclose(t[0], 0), f"`t` should start at 0, not {t[0]}."
assert np.isclose(t[-1], 2 * np.pi), f"`t` should end exactly at 2π ({2 * np.pi:.5f}) but ends at {t[-1]:.5f}. Is the endpoint included?"
assert np.allclose(np.diff(t), np.diff(t)[0]), "The points in `t` should be evenly spaced."
assert isinstance(wave, np.ndarray) and wave.shape == (50,), "`wave` should be an array with one value per time point."
assert np.allclose(wave, np.sin(t)), "`wave` should be the sine of each value in `t`. Use `np.sin`."
--- hint
When you know *how many* points you need and want both ends included, `linspace` is the right tool.
--- hint
`np.pi` is π. NumPy's `np.sin` works on a whole array at once.
```

## Logarithmic spacing: `logspace` and `geomspace`

Some quantities span many orders of magnitude: learning rates, frequencies, regularization strengths. Spacing them evenly on a linear scale wastes almost every point on the high end. Use **logarithmic** spacing instead, where each value is a constant *multiple* of the previous one.

```python run
print(np.logspace(0, 3, 4))          # 10**0 .. 10**3
print(np.geomspace(1, 1000, 4))      # same, but give the endpoints directly
print(np.geomspace(1e-4, 1e-1, 4))   # a learning-rate sweep
```

`np.logspace(a, b, n)` takes **exponents** (base 10 by default), while `np.geomspace(start, stop, n)` takes the actual endpoint values. Most people find `geomspace` easier to read.

> **In the wild:** hyperparameter searches in scikit-learn often use `np.logspace(-4, 4, 20)` to try regularization strengths `C` from 0.0001 to 10,000.

```python exercise id=frequency-ladder title="Build a log-spaced frequency ladder"
# An audio test needs 5 frequencies from 10 Hz to 100,000 Hz,
# each 10 times the previous one: 10, 100, 1000, 10000, 100000.
# Build `freqs` WITHOUT typing the values out by hand.
freqs = ...
--- solution
freqs = np.geomspace(10, 100_000, 5)
--- test
assert freqs is not ..., "Replace the `...` with a call to `np.geomspace` or `np.logspace`."
assert isinstance(freqs, np.ndarray), f"`freqs` should be a NumPy array, not {type(freqs).__name__}."
assert freqs.shape == (5,), f"`freqs` should have 5 values but has shape {freqs.shape}."
assert np.allclose(freqs, [10, 100, 1_000, 10_000, 100_000]), f"`freqs` should be 10, 100, ..., 100000 but is {freqs}. If you used logspace, remember it takes exponents."
--- hint
You want each value to be a constant multiple of the previous one: geometric spacing.
--- hint
`np.geomspace(start, stop, num)` takes the real endpoints. `np.logspace(1, 5, 5)` takes the exponents of 10.
```

## `meshgrid`: from two axes to a full grid

To evaluate a function of **two** variables, like $z = x^2 + y^2$, you need every combination of `x` and `y`. `np.meshgrid` takes two 1-D arrays and returns two 2-D arrays, one holding the x-coordinate of every grid point and one holding the y-coordinate.

```python run
x = np.array([0, 1, 2])
y = np.array([10, 20])

X, Y = np.meshgrid(x, y)
print("X =\n", X)
print("Y =\n", Y)
print("shapes:", X.shape, Y.shape)
```

Read it point by point: the grid point in row `i`, column `j` has coordinates `(X[i, j], Y[i, j])`. With the default `indexing="xy"`, **rows follow `y` and columns follow `x`**, so the shape is `(len(y), len(x))`. That's the convention plotting libraries expect, like an image where x runs left to right.

Once you have `X` and `Y`, any formula becomes a single vectorized expression. Here is the "bowl" $z = x^2 + y^2$ evaluated on a 5 × 5 grid, with no loops:

```python run
x = np.linspace(-2, 2, 5)
y = np.linspace(-2, 2, 5)
X, Y = np.meshgrid(x, y)

Z = X ** 2 + Y ** 2
print(Z)
```

The center of the grid is 0 and the corners are 8: the bowl's shape, written out as numbers. With a finer grid and a more interesting function, you can hand the same `X`, `Y` and `Z` to matplotlib and see the surface as a contour map. Every 2-D heatmap and loss-landscape plot you've seen is built exactly this way:

```python run
import matplotlib.pyplot as plt

x = np.linspace(-2, 2, 120)
y = np.linspace(-2, 2, 120)
X, Y = np.meshgrid(x, y)
Z = np.sin(X ** 2 + Y ** 2) * np.exp(-(X ** 2 + Y ** 2) / 3)

plt.contourf(X, Y, Z, levels=20, cmap="viridis")
plt.colorbar(label="z")
plt.gca().set_aspect("equal")
plt.title("z = sin(x² + y²) · exp(−(x² + y²) / 3)")
plt.show()
```

### `xy` versus `ij` indexing

Matrix-style code often wants the *first* index to follow the *first* input instead. Pass `indexing="ij"` and the shape flips to `(len(x), len(y))`:

```python run
x = np.array([0, 1, 2])
y = np.array([10, 20])

Xi, Yi = np.meshgrid(x, y, indexing="ij")
print("xy shape:", np.meshgrid(x, y)[0].shape)
print("ij shape:", Xi.shape)
print(Xi)
```

> **Pitfall:** mixing up `xy` and `ij` doesn't raise an error when `x` and `y` have the same length. You silently get a **transposed** result. Use different lengths while developing so a shape mismatch exposes the mistake.

```python exercise id=multiplication-table title="Evaluate a function on a grid"
x = np.linspace(0, 1, 3)    # 3 x-values
y = np.linspace(0, 2, 5)    # 5 y-values

# Use np.meshgrid (default "xy" indexing) to compute `Z`, where
# Z[i, j] = x[j] * y[i]  for every combination, without any loops.
Z = ...
--- solution
x = np.linspace(0, 1, 3)
y = np.linspace(0, 2, 5)

X, Y = np.meshgrid(x, y)
Z = X * Y
--- test
assert Z is not ..., "Replace the `...` with an expression built from `np.meshgrid`."
assert isinstance(Z, np.ndarray), f"`Z` should be a NumPy array, not {type(Z).__name__}."
assert Z.shape == (5, 3), f"`Z` should have shape (5, 3), rows following y and columns following x, but it has {Z.shape}." + (" That's the transpose; did you use indexing='ij' or swap x and y?" if Z.shape == (3, 5) else "")
assert np.allclose(Z, np.outer(y, x)), "`Z[i, j]` should equal `x[j] * y[i]`. Build X and Y with meshgrid, then multiply them."
--- hint
`X, Y = np.meshgrid(x, y)` gives you two arrays with the same shape as the grid.
--- hint
Once you have `X` and `Y`, the whole function is just `X * Y`.
```

```python debug id=histogram-edges title="The last bin is missing"
# We want 10 equal-width histogram bins covering [0, 1].
# 10 bins need 11 edges: 0.0, 0.1, ..., 1.0
edges = np.arange(0, 1.0, 0.1)

print("number of edges:", len(edges))
print("last edge:", edges[-1])
--- solution
# We want 10 equal-width histogram bins covering [0, 1].
# 10 bins need 11 edges: 0.0, 0.1, ..., 1.0
edges = np.linspace(0, 1, 11)

print("number of edges:", len(edges))
print("last edge:", edges[-1])
--- test
assert isinstance(edges, np.ndarray), "`edges` should be a NumPy array."
assert len(edges) == 11, f"10 bins need 11 edges, but `edges` has {len(edges)}."
assert edges[0] == 0 and edges[-1] == 1.0, f"The edges should run from exactly 0.0 to exactly 1.0, but the last one is {edges[-1]!r}."
assert np.allclose(edges, np.arange(11) / 10), "The edges should be evenly spaced: 0.0, 0.1, ..., 1.0."
--- hint
Run it. How many edges came out, and what is the last one? Remember what `arange` does with `stop`.
--- hint
Patching the stop to something like `1.05` happens to work, but it's fragile. What you know is *how many* edges you need, and that both ends must be included. Which function takes exactly that?
```

## Choosing the right tool

| Situation | Use |
|---|---|
| Integer sequence, indices, counters | `np.arange(start, stop, step)` |
| *N* float points between two values, endpoints included | `np.linspace(start, stop, N)` |
| Values spanning orders of magnitude | `np.geomspace(start, stop, N)` or `np.logspace(a, b, N)` |
| Every (x, y) combination for a 2-D function | `X, Y = np.meshgrid(x, y)` |

## Recap

- `arange` is half-open, like `range`: `stop` is excluded. It's ideal for integers.
- With float steps, `arange`'s length depends on rounding error, so prefer `linspace`.
- `linspace(a, b, n)` gives exactly `n` points with both ends included; `endpoint=False` and `retstep=True` tweak it.
- `geomspace` and `logspace` space values multiplicatively, which is perfect for hyperparameter sweeps.
- `meshgrid(x, y)` returns coordinate grids of shape `(len(y), len(x))`; `indexing="ij"` flips that.
- Once you have `X` and `Y`, any formula `f(X, Y)` is evaluated over the whole grid at once.

**Up next:** random numbers done right with `np.random.default_rng`, seeding, sampling and simulation.
