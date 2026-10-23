Every layer of a neural network starts with a matrix multiplication. Every image filter, every camera projection and every 3D rotation in a game is one too. A matrix is more than a table of numbers: it is a **function that moves vectors**. Feed it a vector and it returns a new vector, usually rotated, stretched or squashed.

By the end of this lesson you will read a matrix as a transformation, predict what it does to a shape by looking at its columns, build rotations and shears, and use the determinant to measure how much a transformation changes area.

## A matrix acts on a vector

Multiply a matrix by a vector with `@`. Each output entry is the dot product of one row of the matrix with the vector.

```python run
import numpy as np

A = np.array([[2.0, 0.0],
              [0.0, 0.5]])
x = np.array([3.0, 4.0])

print("A @ x =", A @ x)
```

This matrix stretches the x-axis by 2 and squashes the y-axis by half. The point $(3, 4)$ becomes $(6, 2)$.

> **Pitfall:** the vector must match the matrix's column count. A $2 \times 2$ matrix acts on vectors of length 2, and the result also has length 2. A $3 \times 2$ matrix takes length-2 inputs and returns length-3 outputs.

## The columns tell you where the axes go

Here is the most useful fact about a matrix. The standard basis vectors are $e_1 = (1, 0)$ and $e_2 = (0, 1)$. Multiplying by them picks out the **columns** of the matrix. So the columns are exactly where the basis vectors land.

```python run
A = np.array([[1.0, 2.0],
              [3.0, 4.0]])
e1 = np.array([1.0, 0.0])
e2 = np.array([0.0, 1.0])

print("A @ e1 =", A @ e1, "  <- the first column of A")
print("A @ e2 =", A @ e2, "  <- the second column of A")
```

Once you know where the two axes go, you know where every point goes, because any point is a combination of $e_1$ and $e_2$.

## Rotations, stretches and shears

Some transformations have famous shapes. A **rotation** by angle $\theta$ counterclockwise is

$$
R(\theta) = \begin{bmatrix} \cos\theta & -\sin\theta \\ \sin\theta & \cos\theta \end{bmatrix}
$$

The plot below applies a shear to the unit square. A shear slides each horizontal slice sideways while keeping its height, which turns the square into a parallelogram.

```python run
import matplotlib.pyplot as plt

corners = np.array([[0.0, 1.0, 1.0, 0.0, 0.0],
                    [0.0, 0.0, 1.0, 1.0, 0.0]])   # the unit square, one column per corner
shear = np.array([[1.0, 0.6],
                  [0.0, 1.0]])

fig, ax = plt.subplots()
ax.fill(*corners, alpha=0.3, label="before")
ax.fill(*(shear @ corners), alpha=0.6, label="after the shear")
ax.set_aspect("equal"); ax.grid(alpha=0.3); ax.legend()
plt.show()
```

Notice what happened: the corners moved, but the bottom edge stayed where it was. The matrix moved every point, yet left the horizontal axis fixed. Now build a rotation and check where it sends the first axis.

```python run
def rotation(theta):
    c, s = np.cos(theta), np.sin(theta)
    return np.array([[c, -s],
                     [s, c]])

R = rotation(np.pi / 2)      # a quarter turn
print(np.round(R, 3))
print("rotate (1, 0) by 90 degrees:", np.round(R @ np.array([1.0, 0.0]), 3))
```

## Determinant: how much area a matrix changes

The **determinant** of a $2 \times 2$ matrix tells you the factor by which the transformation scales areas. A determinant of 6 means areas grow sixfold. A determinant of 0 means the matrix squashes the plane onto a line, so information is lost and the transformation can't be undone.

```python run
print("stretch by 2 and 3:", np.linalg.det(np.array([[2.0, 0.0], [0.0, 3.0]])))
print("shear:              ", np.linalg.det(shear))
print("flatten onto x-axis:", np.linalg.det(np.array([[1.0, 0.0], [0.0, 0.0]])))
```

A negative determinant means the transformation flips orientation, like a mirror. Rotations keep area exactly, so their determinant is always 1.

## Shapes: any size can be transformed

A matrix with $m$ rows and $n$ columns maps vectors of length $n$ to vectors of length $m$. Neural networks use this constantly: a layer with 4 inputs and 3 outputs is a $3 \times 4$ weight matrix.

```python run
W = np.ones((3, 4))              # a layer: 4 inputs -> 3 outputs
x = np.array([1.0, 2.0, 3.0, 4.0])

print("input length:", x.shape[0], "-> output length:", (W @ x).shape[0])
W @ x
```

## Challenges

```python exercise id=rotation-matrix title="Build a rotation matrix"
# TODO: `rotation_matrix(theta)` should return the 2 x 2 matrix that rotates
# points counterclockwise by theta radians.
def rotation_matrix(theta):
    ...
--- solution
def rotation_matrix(theta):
    c, s = np.cos(theta), np.sin(theta)
    return np.array([[c, -s], [s, c]])
--- test
result = rotation_matrix(0.3)
assert result is not None, "Replace the `...` in `rotation_matrix` with code that returns a matrix."
assert np.shape(result) == (2, 2), f"A rotation matrix is 2 x 2, but yours has shape {np.shape(result)}."
assert np.allclose(rotation_matrix(np.pi / 2) @ np.array([1.0, 0.0]), [0.0, 1.0]), "Rotating (1, 0) by 90 degrees counterclockwise should give (0, 1)."
assert np.allclose(rotation_matrix(np.pi) @ np.array([2.0, 1.0]), [-2.0, -1.0]), "A half-turn should flip both coordinates."
assert np.allclose(result.T @ result, np.eye(2)), "A rotation keeps lengths, so its transpose times itself should be the identity matrix."
--- hint
Look at the rotation formula above. Each column is where one basis vector lands: (1, 0) goes to (cos θ, sin θ).
--- hint
Use `np.cos` and `np.sin`, and put `-sin` in the top-right corner.
```

```python exercise id=shear-matrix title="Build a horizontal shear"
# TODO: `shear(k)` should return the 2 x 2 matrix that slides each point horizontally
# by k times its height: (x, y) -> (x + k * y, y).
def shear(k):
    ...
--- solution
def shear(k):
    return np.array([[1.0, k],
                     [0.0, 1.0]])
--- test
result = shear(0.5)
assert result is not None, "Replace the `...` in `shear` with code that returns a matrix."
assert np.allclose(shear(0.5) @ np.array([2.0, 4.0]), [4.0, 4.0]), "shear(0.5) should map (2, 4) to (4, 4), since 2 + 0.5 * 4 = 4."
assert np.allclose(shear(-1.0) @ np.array([1.0, 3.0]), [-2.0, 3.0]), "shear(-1) should map (1, 3) to (-2, 3)."
assert np.allclose(shear(2.0) @ np.array([5.0, 0.0]), [5.0, 0.0]), "Points on the x-axis (height 0) should not move."
--- hint
The top row of the matrix does the horizontal change. Which entry multiplies the height `y`?
--- hint
The matrix is `[[1, k], [0, 1]]`. The `k` sits in the top-right corner.
```

```python debug transpose-points id=rotate-points title="Rotate every point"
theta = np.pi / 2
R = np.array([[np.cos(theta), -np.sin(theta)],
              [np.sin(theta), np.cos(theta)]])

# Each row is one point (x, y). Rotate both points.
points = np.array([[1.0, 0.0],
                   [0.0, 1.0]])
rotated = R @ points
print(np.round(rotated, 3))
--- solution
theta = np.pi / 2
R = np.array([[np.cos(theta), -np.sin(theta)],
              [np.sin(theta), np.cos(theta)]])

# Each row is one point (x, y). Rotate both points.
points = np.array([[1.0, 0.0],
                   [0.0, 1.0]])
rotated = points @ R.T
print(np.round(rotated, 3))
--- test
expected = np.array([[0.0, 1.0],
                     [-1.0, 0.0]])
assert np.allclose(rotated, expected, atol=1e-9), f"The point (1, 0) should land on (0, 1) and (0, 1) on (-1, 0). Your rotated points are {np.round(rotated, 3).tolist()}."
--- hint
Look at where the point (1, 0) lands. A quarter turn should send it straight up to (0, 1). Does the printed first row say that?
--- hint
The points are stored as rows, but a matrix transforms column vectors. Transform each row with `points @ R.T`.
```

```python predict id=predict-matvec title="Apply a diagonal matrix"
A = np.array([[1, 0],
              [0, 2]])
print(A @ np.array([3, 5]))
--- options
[3 5]
* [ 3 10]
[ 3  0]
[ 1 10]
--- explain
Row one gives `1*3 + 0*5 = 3`, and row two gives `0*3 + 2*5 = 10`. The matrix keeps the first coordinate and doubles the second.
```

```python predict id=predict-det title="The determinant of a 2 x 2 matrix"
print(round(np.linalg.det(np.array([[1.0, 2.0], [3.0, 4.0]])), 6))
--- options
2.0
* -2.0
10.0
-10.0
--- explain
For a $2 \times 2$ matrix $\begin{bmatrix} a & b \\ c & d \end{bmatrix}$ the determinant is $ad - bc = 1 \cdot 4 - 2 \cdot 3 = -2$. The negative sign tells you this matrix flips orientation.
```

## Recap

- A matrix transforms vectors. Multiply with `@`, one row dotted with the vector at a time.
- The columns of a matrix show where the basis vectors $e_1$ and $e_2$ land.
- Rotations, stretches and shears are matrices with recognizable patterns.
- The determinant is the area scaling factor; zero means information was lost.
- An $m \times n$ matrix maps length-$n$ vectors to length-$m$ vectors. Neural-network layers are exactly this.

**Up next:** matrix multiplication itself. Chaining transformations is just multiplying their matrices, and it's the operation behind every layer of a network.
