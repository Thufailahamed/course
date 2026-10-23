Two modern changes appear in nearly every recent transformer. **RMSNorm** is a simpler normalization that drops the mean subtraction of layer normalization, and it works as well in practice while being cheaper. **Rotary position embeddings** (RoPE) encode position by rotating the query and key vectors, so the attention score between two tokens depends on their relative distance, which generalizes better to longer sequences than fixed position tables.

## RMSNorm

Layer normalization subtracts the mean and divides by the standard deviation. RMSNorm divides by the root mean square alone, and applies a learned gain:

$$
\operatorname{RMSNorm}(x) = \frac{x}{\sqrt{\frac{1}{d}\sum_i x_i^2 + \epsilon}} \odot g
$$

```python run
import numpy as np

def rmsnorm(x, g, eps=1e-6):
    rms = np.sqrt(np.mean(x ** 2, axis=-1, keepdims=True) + eps)
    return x / rms * g

x = np.array([[3.0, 4.0]])
print("RMSNorm of [3, 4]:", np.round(rmsnorm(x, np.ones(2)), 4))
print("root mean square of the output:", np.round(np.sqrt(np.mean(rmsnorm(x, np.ones(2)) ** 2)), 4))
```

The output's root mean square is one, which is the only property RMSNorm enforces. It keeps the scale stable without re-centering the features.

## Rotary positions

RoPE rotates each pair of features by an angle that grows with the position. Each pair uses its own frequency, so the rotations form a range of timescales.

$$
\text{pair } i:\quad \begin{pmatrix} x_{2i} \\ x_{2i+1} \end{pmatrix} \mapsto \begin{pmatrix} \cos\theta_i & -\sin\theta_i \\ \sin\theta_i & \cos\theta_i \end{pmatrix}\begin{pmatrix} x_{2i} \\ x_{2i+1} \end{pmatrix}, \qquad \theta_i = \text{pos} \cdot \text{base}^{-2i/d}
$$

```python run
def rope(x, pos, base=10000.0):
    d = x.shape[-1]
    out = np.empty_like(x, dtype=float)
    for i in range(d // 2):
        theta = pos * base ** (-2 * i / d)
        c, s = np.cos(theta), np.sin(theta)
        a, b = x[2 * i], x[2 * i + 1]
        out[2 * i], out[2 * i + 1] = a * c - b * s, a * s + b * c
    return out

v = np.array([1.0, 0.0, 0.5, 0.5])
print("position 0 leaves the vector unchanged:", np.allclose(rope(v, 0), v))
print("rotation preserves length:", np.isclose(np.linalg.norm(rope(v, 7)), np.linalg.norm(v)))
```

## Relative position

The key property of RoPE is that the dot product between a rotated query and a rotated key depends only on how far apart their positions are.

```python run
q, k = np.array([1.0, 0.5]), np.array([0.3, 1.0])
score_a = rope(q, 5) @ rope(k, 2)              # positions 5 and 2: distance 3
score_b = rope(q, 10) @ rope(k, 7)             # positions 10 and 7: distance 3
print("same distance, same score:", np.isclose(score_a, score_b))
```

Two tokens three positions apart score the same wherever they sit in the sequence, which is exactly the behaviour attention needs.

> **In the wild:** LLaMA-style and many other recent models use RMSNorm and RoPE together, usually with the rotation applied to the queries and keys inside each attention head.

LayerNorm removes the mean of each token, while RMSNorm keeps it. A constant offset survives RMSNorm and disappears under LayerNorm.

```python run
def layer_norm(x, eps=1e-5):
    return (x - x.mean(axis=-1, keepdims=True)) / np.sqrt(x.var(axis=-1, keepdims=True) + eps)

shifted = np.array([[5.0, 5.0, 5.0, 6.0]])
print("LayerNorm output:", np.round(layer_norm(shifted), 3))
print("RMSNorm output:  ", np.round(rmsnorm(shifted, np.ones(4)), 3))
```

## Challenge: RMSNorm

```python exercise id=rmsnorm-fn title="Root-mean-square normalization"
import numpy as np

# TODO: `rms_norm(x, g)` returns x divided by the root mean square of each row (with eps = 1e-6 added inside the root),
# multiplied elementwise by the gain vector g.
def rms_norm(x, g):
    ...
--- solution
import numpy as np

def rms_norm(x, g):
    x = np.asarray(x, dtype=float)
    rms = np.sqrt(np.mean(x ** 2, axis=-1, keepdims=True) + 1e-6)
    return x / rms * np.asarray(g, dtype=float)
--- test
import numpy as np
result = rms_norm(np.array([[3.0, 4.0]]), np.array([1.0, 2.0]))
assert result is not None, "Replace the `...` in `rms_norm` with code that returns the normalized rows."
rms = np.sqrt((9 + 16) / 2)
assert np.allclose(result, [[3.0 / rms, 2 * 4.0 / rms]], atol=1e-5), f"The root mean square of [3, 4] is {rms:.4f}, so the output should be [3/rms, 2·4/rms], but you returned {result}."
assert np.allclose(rms_norm(np.array([[1.0, 1.0]]), np.ones(2)), [[1.0, 1.0]], atol=1e-5), "A row with unit root mean square is unchanged by the normalization."
--- hint
Compute the mean of the squares per row, add eps, take the square root, divide, then multiply by the gain.
--- hint
`x / np.sqrt(np.mean(x ** 2, axis=-1, keepdims=True) + 1e-6) * g`.
```

## Challenge: rotate a pair

```python exercise id=rotate-pair title="Rotate a feature pair"
import numpy as np

# TODO: `rotate_pair(a, b, theta)` returns the pair (a·cos θ − b·sin θ, a·sin θ + b·cos θ), the rotation of (a, b) by θ.
def rotate_pair(a, b, theta):
    ...
--- solution
import numpy as np

def rotate_pair(a, b, theta):
    c, s = np.cos(theta), np.sin(theta)
    return a * c - b * s, a * s + b * c
--- test
import numpy as np
x, y = rotate_pair(1.0, 0.0, np.pi / 2)
assert x is not None and y is not None, "Replace the `...` in `rotate_pair` with code that returns the pair."
assert abs(x) < 1e-9 and abs(y - 1.0) < 1e-9, f"Rotating (1, 0) by 90 degrees gives (0, 1), but you returned ({x}, {y})."
x2, y2 = rotate_pair(3.0, 4.0, 0.7)
assert abs(np.hypot(x2, y2) - 5.0) < 1e-9, "A rotation must preserve the length of the pair."
--- hint
This is the standard 2-D rotation matrix applied to the column vector (a, b).
--- hint
Compute `c = cos θ` and `s = sin θ`, then return `a*c - b*s` and `a*s + b*c`.
```

## Debug the rotation direction

This rotation is meant to turn the pair counter-clockwise, but it uses the wrong sign on the sine terms, so it rotates clockwise.

```python debug id=rotation-sign title="Rotate counter-clockwise"
import numpy as np

a, b, theta = 1.0, 0.0, np.pi / 2
c, s = np.cos(theta), np.sin(theta)
x, y = a * c + b * s, -a * s + b * c       # bug: the sign of the sine terms is reversed
print("rotated:", round(x, 3), round(y, 3))
--- solution
import numpy as np

a, b, theta = 1.0, 0.0, np.pi / 2
c, s = np.cos(theta), np.sin(theta)
x, y = a * c - b * s, a * s + b * c
print("rotated:", round(x, 3), round(y, 3))
--- test
assert abs(x) < 1e-9 and abs(y - 1.0) < 1e-9, f"Rotating (1, 0) counter-clockwise by 90 degrees gives (0, 1), but the code gives ({x:.3f}, {y:.3f}). Use the standard rotation matrix."
--- hint
The standard rotation takes (a, b) to (a cos θ − b sin θ, a sin θ + b cos θ).
--- hint
Put the minus sign on the `b·sin θ` term in the first output.
```

## Predict the relative score

```python predict id=predict-rope title="Do two pairs of positions with the same distance give the same score under RoPE?"
print("yes")
--- options
* yes
no
only at position zero
only for long sequences
--- explain
RoPE makes the query-key dot product depend only on the relative distance between positions, so equal distances give equal scores.

```