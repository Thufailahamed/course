A language model predicts the next token, so it must not see the tokens it is trying to predict. Two additions make that possible and let the model know where each token sits: a **causal mask** that hides the future, and **positional encodings** that tell the model the order of tokens, which attention alone cannot see.

## The causal mask

Before the softmax, set every score for a future position to minus infinity. The softmax then gives those positions zero weight, so each token attends only to itself and what came before.

```python run
import numpy as np

scores = np.arange(9, dtype=float).reshape(3, 3)
mask = np.triu(np.ones((3, 3), dtype=bool), k=1)     # True above the diagonal, the future
masked = np.where(mask, -np.inf, scores)
e = np.exp(masked - masked.max(axis=1, keepdims=True))
weights = e / e.sum(axis=1, keepdims=True)
print(np.round(weights, 3))
```

The first row has a single weight of one: the first token can only see itself. The last row spreads its weight over all three tokens.

## Sinusoidal positions

A transformer needs a unique signal for each position. The original design adds a fixed pattern of sines and cosines at different frequencies, so each position has its own mixture, and nearby positions have similar patterns.

$$
PE_{(pos, 2i)} = \sin\!\left(\frac{pos}{10000^{2i/d}}\right), \qquad PE_{(pos, 2i+1)} = \cos\!\left(\frac{pos}{10000^{2i/d}}\right)
$$

```python run
def sinusoidal_positions(n_pos, d):
    pos = np.arange(n_pos)[:, None]
    i = np.arange(d // 2)[None, :]
    angles = pos / 10000 ** (2 * i / d)
    out = np.zeros((n_pos, d))
    out[:, 0::2] = np.sin(angles)
    out[:, 1::2] = np.cos(angles)
    return out

PE = sinusoidal_positions(6, 8)
print(np.round(PE[:3], 2))
```

The first position is always [0, 1, 0, 1, ...] and the pattern changes smoothly from one position to the next.

## Why order matters

```python run
words = ["dog", "bites", "man"]
swapped = ["man", "bites", "dog"]
print("same words:", sorted(words) == sorted(swapped), "| same order:", words == swapped)
```

Adding the positional pattern to the token embeddings gives attention the order information it was missing.

> **Pitfall:** the mask must be applied before the softmax, as minus infinity in the scores. Applying it to the weights afterwards leaves rows that no longer sum to one.

> **In the wild:** modern models replaced sinusoidal positions with learned or rotary encodings, covered in the final section, but the job is the same: tell the model where each token is.

Nearby positions get similar encodings, which lets the model reason about distance. Inner products between positions show it.

```python run
PE_long = sinusoidal_positions(20, 16)
similarity = PE_long @ PE_long.T
print("similarity of position 0 with positions 1, 2, 10:", np.round(similarity[0, [1, 2, 10]], 2))
```

## Challenge: masked softmax

```python exercise id=masked-softmax title="Softmax with a causal mask"
import numpy as np

# TODO: `causal_softmax(scores)` takes an (n, n) score matrix and returns the row-wise softmax in which every entry
# above the diagonal (where the key is in the future) is treated as minus infinity, so its weight is zero.
def causal_softmax(scores):
    ...
--- solution
import numpy as np

def causal_softmax(scores):
    scores = np.asarray(scores, dtype=float)
    n = scores.shape[0]
    mask = np.triu(np.ones((n, n), dtype=bool), k=1)
    masked = np.where(mask, -np.inf, scores)
    e = np.exp(masked - masked.max(axis=1, keepdims=True))
    return e / e.sum(axis=1, keepdims=True)
--- test
import numpy as np
result = causal_softmax(np.zeros((3, 3)))
assert result is not None, "Replace the `...` in `causal_softmax` with code that returns the weights."
assert np.allclose(result[0], [1.0, 0.0, 0.0]), "The first token may see only itself, so its row is [1, 0, 0]."
assert np.allclose(result[2], [1 / 3, 1 / 3, 1 / 3]), "The last token sees all three tokens equally when all scores are zero."
assert np.allclose(np.triu(result, k=1), 0.0), "No weight may fall on a future position."
--- hint
Build the mask with `np.triu(..., k=1)`, replace the masked scores with `-np.inf`, then apply the usual row-wise softmax.
--- hint
`masked = np.where(mask, -np.inf, scores)` before exponentiating.
```

## Challenge: sinusoidal positions

```python exercise id=sin-positions title="Sinusoidal position encodings"
import numpy as np

# TODO: `sinusoidal_positions(n_pos, d)` returns an (n_pos, d) array with entries sin(pos / 10000^(2i/d)) in the even
# columns and cos(pos / 10000^(2i/d)) in the odd columns, where i is the pair index.
def sinusoidal_positions(n_pos, d):
    ...
--- solution
import numpy as np

def sinusoidal_positions(n_pos, d):
    pos = np.arange(n_pos)[:, None]
    i = np.arange(d // 2)[None, :]
    angles = pos / 10000 ** (2 * i / d)
    out = np.zeros((n_pos, d))
    out[:, 0::2] = np.sin(angles)
    out[:, 1::2] = np.cos(angles)
    return out
--- test
import numpy as np
PE = sinusoidal_positions(4, 4)
assert PE is not None, "Replace the `...` in `sinusoidal_positions` with code that returns the encodings."
assert PE.shape == (4, 4), "There is one row per position and one column per feature."
assert np.allclose(PE[0], [0.0, 1.0, 0.0, 1.0]), "Position zero has sine 0 and cosine 1 in every pair."
assert np.allclose(PE[1, 0], np.sin(1.0)), "The first pair at position 1 has angle 1 / 10000^0 = 1."
--- hint
Use the pair index `i` from `np.arange(d // 2)` to compute the angle, then fill the even columns with sines and the odd columns with cosines.
--- hint
`out[:, 0::2] = np.sin(angles)` and `out[:, 1::2] = np.cos(angles)`.
```

## Debug the sine and cosine

This encoding is meant to put sines in the even columns and cosines in the odd columns, but they are swapped, so position zero comes out as [1, 0, 1, 0].

```python debug id=swapped-trig title="Sines in even columns"
import numpy as np

pos = np.arange(4)[:, None]
angles = pos / 10000 ** (2 * np.arange(2)[None, :] / 4)
out = np.zeros((4, 4))
out[:, 0::2] = np.cos(angles)            # bug: the even columns should hold sines
out[:, 1::2] = np.sin(angles)
print("position 0:", out[0])
--- solution
import numpy as np

pos = np.arange(4)[:, None]
angles = pos / 10000 ** (2 * np.arange(2)[None, :] / 4)
out = np.zeros((4, 4))
out[:, 0::2] = np.sin(angles)
out[:, 1::2] = np.cos(angles)
print("position 0:", out[0])
--- test
assert np.allclose(out[0], [0.0, 1.0, 0.0, 1.0]), f"Position zero should be [0, 1, 0, 1], but it is {out[0]}. Even columns hold sines and odd columns hold cosines."
--- hint
At position zero every sine is zero and every cosine is one.
--- hint
Swap the two assignments so the sines go in the even columns.
```

## Predict the mask

```python predict id=predict-causal title="How many entries of a 3 × 3 causal mask are True?"
import numpy as np
mask = np.tril(np.ones((3, 3), dtype=bool))
print(int(mask.sum()))
--- options
* 6
3
9
4
--- explain
The allowed positions form the lower triangle, including the diagonal. Row one has one allowed position, row two has two and row three has three, so the total is 1 + 2 + 3 = 6.

```