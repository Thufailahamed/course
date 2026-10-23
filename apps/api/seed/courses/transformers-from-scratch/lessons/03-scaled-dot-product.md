The attention formula that powers every transformer fits on one line. Its ingredients are a query for each token, a key for each token and a value for each token, all produced from the token's representation by learned matrices. Its one subtle detail is the scaling factor, and understanding why it is there is the difference between a model that trains and one that stalls.

## The formula

$$
\operatorname{Attention}(Q, K, V) = \operatorname{softmax}\!\left(\frac{Q K^{\top}}{\sqrt{d_k}}\right) V
$$

Read it from the inside out. $QK^{\top}$ scores every query against every key. Dividing by $\sqrt{d_k}$ keeps the scores at a useful scale. The softmax turns each row into weights, and multiplying by $V$ mixes the values with those weights.

```python run
import numpy as np

def scaled_scores(Q, K):
    return Q @ K.T / np.sqrt(Q.shape[-1])

def attention(Q, K, V):
    scores = scaled_scores(Q, K)
    e = np.exp(scores - scores.max(axis=-1, keepdims=True))
    weights = e / e.sum(axis=-1, keepdims=True)
    return weights @ V, weights

rng = np.random.default_rng(0)
Q, K, V = rng.normal(size=(3, 4)), rng.normal(size=(5, 4)), rng.normal(size=(5, 2))
out, w = attention(Q, K, V)
print("output shape:", out.shape, "| weight shape:", w.shape)
print("each query's weights sum to:", np.round(w.sum(axis=1), 6))
```

Three queries and five keys give a 3 × 5 weight matrix, and the output has one row per query.

Softmax has a useful invariance: adding the same number to every score changes nothing. That is why the stable form subtracts the row maximum.

```python run
def softmax_rows(s):
    e = np.exp(s - s.max(axis=-1, keepdims=True))
    return e / e.sum(axis=-1, keepdims=True)

scores_demo = np.array([[2.0, 0.5, -1.0]])
print("weights:            ", np.round(softmax_rows(scores_demo), 4))
print("after adding 5:     ", np.round(softmax_rows(scores_demo + 5), 4))
print("weights are positive:", bool(np.all(softmax_rows(scores_demo) > 0)))
```

## Why scale by the square root of the dimension

If each query and key entry has variance one, a dot product over $d$ entries has variance $d$. Large scores push softmax into a corner where one weight is almost one and all gradients are almost zero. The scaling keeps the variance at one.

```python run
for d in [8, 64, 512]:
    q = rng.normal(size=(5000, d))
    k = rng.normal(size=(5000, d))
    raw = np.sum(q * k, axis=1)
    print(f"d = {d:>3}: std of raw scores {raw.std():7.2f}, scaled {(raw / np.sqrt(d)).std():.2f}")
```

> **Pitfall:** the scale is the square root of the key dimension, not the dimension itself. Dividing by $d$ shrinks the scores too much and the attention becomes almost uniform.

> **In the wild:** every multi-head attention layer in GPT-style models uses this formula, with the scale applied per head.

Attention weights come from the same Q and K, so each query places weight on itself often when it resembles its own key. The diagonal of the score matrix shows this.

```python run
rng_self = np.random.default_rng(7)
X_self = rng_self.normal(size=(4, 8))
self_scores = X_self @ X_self.T / np.sqrt(8)
print("self-scores on the diagonal:", np.round(np.diag(self_scores), 2))
print("largest score in each row is on the diagonal:", bool(np.all(np.argmax(self_scores, axis=1) == np.arange(4))))
```

## Challenge: scaled scores

```python exercise id=scaled-scores title="Scaled dot-product scores"
import numpy as np

# TODO: `scaled_scores(Q, K)` returns Q Kᵀ divided by the square root of the number of columns of Q.
def scaled_scores(Q, K):
    ...
--- solution
import numpy as np

def scaled_scores(Q, K):
    return np.asarray(Q, dtype=float) @ np.asarray(K, dtype=float).T / np.sqrt(np.asarray(Q).shape[-1])
--- test
import numpy as np
result = scaled_scores([[1.0, 2.0]], [[3.0, 4.0], [1.0, 0.0]])
assert result is not None, "Replace the `...` in `scaled_scores` with code that returns the scores."
assert result.shape == (1, 2), f"One query against two keys gives shape (1, 2), but you returned {result.shape}."
assert np.allclose(result, [[11 / np.sqrt(2), 1 / np.sqrt(2)]]), f"The raw scores are 3 + 8 = 11 and 1 + 0 = 1, divided by sqrt(2), but you returned {result}."
--- hint
Multiply Q by the transpose of K, then divide by `np.sqrt` of the query dimension.
--- hint
`Q @ K.T / np.sqrt(Q.shape[-1])`.
```

## Challenge: attention output and weights

```python exercise id=attention-full title="Full scaled dot-product attention"
import numpy as np

# TODO: `attention(Q, K, V)` returns a tuple (output, weights). weights is the softmax over each row of the scaled scores,
# and output is weights @ V. Use the numerically stable form.
def attention(Q, K, V):
    ...
--- solution
import numpy as np

def attention(Q, K, V):
    Q = np.asarray(Q, dtype=float)
    K = np.asarray(K, dtype=float)
    V = np.asarray(V, dtype=float)
    scores = Q @ K.T / np.sqrt(Q.shape[-1])
    e = np.exp(scores - scores.max(axis=-1, keepdims=True))
    weights = e / e.sum(axis=-1, keepdims=True)
    return weights @ V, weights
--- test
import numpy as np
Q = np.array([[1.0, 0.0]])
K = np.array([[1.0, 0.0], [0.0, 1.0]])
V = np.array([[10.0], [20.0]])
result = attention(Q, K, V)
assert result is not None, "Replace the `...` in `attention` with code that returns (output, weights)."
out, w = result
s = np.array([1.0, 0.0]) / np.sqrt(2)
expected_w = np.exp(s) / np.exp(s).sum()
assert np.allclose(w, [expected_w]), f"The weights should be the softmax of the scaled scores {s}, but you returned {w}."
assert np.allclose(out, [[expected_w @ [10.0, 20.0]]]), "The output should be the weights times the values."
assert np.allclose(w.sum(axis=1), 1.0), "Each row of the weights sums to one."
--- hint
Reuse the scaled scores, apply the stable softmax along the last axis, and multiply the weights by V.
--- hint
`return weights @ V, weights` once `weights` has been computed.
```

## Debug the scale

This scaling divides by the dimension instead of its square root, so the scores are squashed too far and the weights become nearly uniform.

```python debug id=scale-dimension title="Scale by the square root"
import numpy as np

Q = np.array([[1.0, 2.0]])
K = np.array([[3.0, 4.0], [1.0, 0.0]])
scores = Q @ K.T / Q.shape[-1]          # bug: divides by d instead of sqrt(d)
print("scores:", scores)
--- solution
import numpy as np

Q = np.array([[1.0, 2.0]])
K = np.array([[3.0, 4.0], [1.0, 0.0]])
scores = Q @ K.T / np.sqrt(Q.shape[-1])
print("scores:", scores)
--- test
assert np.allclose(scores, [[11 / np.sqrt(2), 1 / np.sqrt(2)]]), f"With d = 2 the scores should be divided by sqrt(2), giving {[[11 / np.sqrt(2), 1 / np.sqrt(2)]]}, but they are {scores}."
--- hint
The scale is the square root of the key dimension, as in the formula.
--- hint
Use `np.sqrt(Q.shape[-1])`.
```

## Predict the variance

```python predict id=predict-variance title="By how much does the raw score's spread grow when d grows from 4 to 16?"
import numpy as np
print(np.sqrt(16) / np.sqrt(4))
--- options
* 2.0
4.0
16.0
1.0
--- explain
The variance of a dot product grows linearly with d, so its standard deviation grows like the square root of d. Going from 4 to 16 multiplies the spread by sqrt(16 / 4) = 2.
```

## Recap

- Attention is softmax of the scaled scores, applied to the values.
- Dividing by the square root of the key dimension keeps the variance of the scores at one.
- Each row of the weights is a distribution over the keys, summing to one.
- The same formula runs once per head in a transformer, which is the subject of the next lesson.

**Up next:** multi-head attention, which runs several attentions in parallel on different views of the data.
