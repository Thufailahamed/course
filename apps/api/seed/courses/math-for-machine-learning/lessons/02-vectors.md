Picture a house listing. It has a size in square feet, a number of bedrooms and a year built. Write those three numbers in order and you have a **vector**: `[1850, 3, 1998]`. Every row of a machine-learning dataset is one such vector, and every model is a function that takes vectors in and gives numbers out. So the first skill to build is simply knowing what a vector is, how to add and scale one, and how to see it.

By the end of this lesson you will be able to create vectors in NumPy, read their shapes, draw them as arrows, and build any point in a plane out of two simple directions.

## A vector is a list of numbers with a shape

A vector with three numbers is a one-dimensional NumPy array. Its **shape** is `(3,)`, meaning a single axis of length three.

```python run
import numpy as np

house = np.array([1850.0, 3.0, 1998.0])
print("values:", house)
print("shape:", house.shape, "| dimensions:", house.ndim)
print("number of features:", house.size)
```

> **Tip:** use floats (`1850.0`, not `1850`) for physical measurements. Integer arrays are a common source of bugs later, and you will meet one in a debug challenge below.

## Vectors as arrows

Geometrically, a two-number vector such as `(3, 1)` is an **arrow** from the origin to the point `(3, 1)`. Adding two vectors means placing the tail of one at the tip of the other. The plot below draws that rule.

```python run
import matplotlib.pyplot as plt

u = np.array([3.0, 1.0])
v = np.array([1.0, 2.0])

fig, ax = plt.subplots()
ax.quiver(0, 0, u[0], u[1], angles="xy", scale_units="xy", scale=1, color="tab:blue", label="u")
ax.quiver(0, 0, v[0], v[1], angles="xy", scale_units="xy", scale=1, color="tab:orange", label="v")
ax.quiver(u[0], u[1], v[0], v[1], angles="xy", scale_units="xy", scale=1, color="tab:orange", alpha=0.4)
ax.quiver(0, 0, (u + v)[0], (u + v)[1], angles="xy", scale_units="xy", scale=1, color="tab:green", label="u + v")
ax.set_xlim(-0.5, 5); ax.set_ylim(-0.5, 4); ax.set_aspect("equal")
ax.grid(alpha=0.3); ax.legend(); ax.set_title("Adding vectors: tail to tip")
plt.show()
```

The faded orange arrow is `v` starting from the tip of `u`. It lands exactly on the green arrow, `u + v`.

## Adding and scaling

Addition and scalar multiplication work **element by element**. There is no special rule to memorize; the arithmetic is the geometry.

```python run
print("u + v   =", u + v)
print("2 * u   =", 2 * u)
print("-v      =", -v)
print("u - v   =", u - v)
```

Multiplying by 2 doubles the arrow's length and keeps its direction. Multiplying by -1 flips it.

## Linear combinations: the core idea

A **linear combination** of vectors is a weighted sum: $a\,u + b\,v$, where $a$ and $b$ are numbers. Changing the weights moves you around the plane. Every point you can reach by mixing two directions is a linear combination of them.

```python run
for a, b in [(1, 0), (0, 1), (2, -1), (0.5, 0.5)]:
    point = a * u + b * v
    print(f"a = {a:>4}, b = {b:>4}  ->  {point}")
```

This idea runs through all of machine learning. A neuron computes a weighted sum of its inputs, and a linear model predicts with a weighted sum of its features. The weights are what training adjusts.

> **In the wild:** NumPy's `np.dot` and the `@` operator, which you'll meet in the next lesson, are simply efficient ways of computing these weighted sums.

## A dataset is a stack of vectors

In practice you rarely handle one vector. You handle a **matrix** whose rows are vectors, one row per sample. Here are three houses with three features each.

```python run
houses = np.array([
    [1850.0, 3.0, 1998.0],
    [1200.0, 2.0, 1975.0],
    [2400.0, 4.0, 2015.0],
])
print("dataset shape (samples, features):", houses.shape)
print("first house:", houses[0])
print("last house's bedrooms:", houses[-1, 1])
```

> **Pitfall:** the features are on very different scales. Square feet are in the thousands and bedrooms in single digits. Many algorithms behave badly when one feature dominates by size alone, and you will fix that with standardization later in the course.

## Challenges

```python exercise id=midpoint title="Find the midpoint"
# TODO: `midpoint(p, q)` should return the point halfway between points p and q.
def midpoint(p, q):
    ...
--- solution
def midpoint(p, q):
    return (np.asarray(p) + np.asarray(q)) / 2
--- test
result = midpoint(np.array([1.0, 7.0]), np.array([5.0, 3.0]))
assert result is not None, "Replace the `...` in `midpoint` with code that returns the midpoint."
assert np.allclose(result, [3.0, 5.0]), f"The midpoint of (1, 7) and (5, 3) is (3, 5), but midpoint returned {result!r}."
result = midpoint(np.array([-2.0, 4.0, 1.0]), np.array([6.0, 0.0, 9.0]))
assert np.allclose(result, [2.0, 2.0, 5.0]), "The midpoint must work for points in any dimension."
--- hint
The midpoint is the average of the two points, coordinate by coordinate.
--- hint
Add the points, then divide by 2: `(p + q) / 2`.
```

```python exercise id=basis-point title="Build a point from two directions"
e1 = np.array([2.0, 0.0])
e2 = np.array([1.0, 3.0])

# TODO: `point_from_basis(alpha, beta)` should return alpha * e1 + beta * e2.
def point_from_basis(alpha, beta):
    ...
--- solution
e1 = np.array([2.0, 0.0])
e2 = np.array([1.0, 3.0])

def point_from_basis(alpha, beta):
    return alpha * e1 + beta * e2
--- test
result = point_from_basis(1, 0)
assert result is not None, "Replace the `...` in `point_from_basis` with code that returns the point."
assert np.allclose(result, [2.0, 0.0]), f"point_from_basis(1, 0) should be e1 = (2, 0), but it returned {result!r}."
assert np.allclose(point_from_basis(0, 1), [1.0, 3.0]), "point_from_basis(0, 1) should be e2 = (1, 3)."
assert np.allclose(point_from_basis(2, -1), [3.0, -3.0]), "point_from_basis(2, -1) should be 2 * e1 - e2 = (3, -3)."
--- hint
A linear combination multiplies each direction by its weight and adds the results: `alpha * e1 + beta * e2`.
--- hint
NumPy broadcasts a scalar across an array, so `alpha * e1` scales every element of `e1`.
```

```python debug int-truncation id=int-scale title="Scaling a velocity"
# Scale the velocity by one half, then add a small downward push.
velocity = np.array([4, 10, -6])
velocity *= 0.5
velocity += np.array([0.0, -1.5, 0.0])
print(velocity)
--- solution
# Scale the velocity by one half, then add a small downward push.
velocity = np.array([4.0, 10.0, -6.0])
velocity *= 0.5
velocity += np.array([0.0, -1.5, 0.0])
print(velocity)
--- test
assert velocity.dtype.kind == "f", f"`velocity` should hold decimal numbers, but its dtype is {velocity.dtype}."
assert np.allclose(velocity, [2.0, 3.5, -3.0]), f"After halving and pushing down, velocity should be [2, 3.5, -3], but it is {velocity!r}."
--- hint
Run the cell. The error message names the problem: NumPy won't store 0.5 in an array of integers.
--- hint
Give the array decimal numbers, for example `4.0` instead of `4`, so that its dtype is `float64`.
```

```python predict id=predict-add title="What does this print?"
a = np.array([1, 2])
b = np.array([10, 20])
print(a + 2 * b)
--- options
[11 22]
* [21 42]
[ 2  4 20 40]
[12 24]
--- explain
`2 * b` is `[20, 40]`, and adding `a` element by element gives `[1 + 20, 2 + 40] = [21, 42]`. The factor 2 scales `b` before the addition, so `a + b` (which would print `[11 22]`) is a different calculation.
```

## Recap

- A vector is an array with a shape. Here, `(3,)` means three numbers in one row.
- Vectors add and scale element by element, which is also how they move as arrows.
- A linear combination $a\,u + b\,v$ reaches every point in the plane spanned by $u$ and $v$.
- A dataset is a matrix: one row per sample, one column per feature.
- Keep numbers as floats when the values are measurements.

**Up next:** the dot product, the operation that turns two vectors into one number and measures their length, their angle and their similarity.
