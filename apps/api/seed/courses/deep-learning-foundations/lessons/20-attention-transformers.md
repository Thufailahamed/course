A recurrent network has to squeeze everything it has read into one hidden state, and distant words fade on the way. **Attention** takes a different approach. Each position looks back at every other position directly and decides how much to use from each. That single idea, repeated in layers, is the core of the **Transformer**, the architecture behind modern language models.

In this lesson you will build scaled dot-product attention from its formula, see what the weights mean, and learn how a causal mask stops a model from peeking at the future.

## The query-key-value idea

Attention works with three matrices, each with one row per position:

- **Queries** $Q$: what each position is looking for.
- **Keys** $K$: what each position offers to be matched against.
- **Values** $V$: the content each position passes along when it is chosen.

Each query is compared with every key by a dot product. A high score means a good match. The scores are turned into weights with softmax, and the output for each position is the weighted average of the values.

$$
\operatorname{Attention}(Q, K, V) = \operatorname{softmax}\!\left(\frac{Q K^{\top}}{\sqrt{d}}\right) V
$$

```python run
import numpy as np

def softmax(Z, axis=-1):
    e = np.exp(Z - Z.max(axis=axis, keepdims=True))
    return e / e.sum(axis=axis, keepdims=True)

rng = np.random.default_rng(0)
n, d = 4, 8                              # 4 tokens, each a vector of size 8
Q = rng.normal(size=(n, d))
K = rng.normal(size=(n, d))
V = rng.normal(size=(n, d))

scores = Q @ K.T / np.sqrt(d)            # (4, 4): every query against every key
weights = softmax(scores, axis=-1)
out = weights @ V                        # (4, 8): a weighted mix of values per position

print("scores:", scores.shape, "| weights:", weights.shape, "| output:", out.shape)
print("each row of weights sums to:", np.round(weights.sum(axis=1), 6))
```

Every row of the weight matrix is a probability distribution over the positions. Row $i$ says how much position $i$ attends to each other position.

Here is attention doing its job on a tiny example. One query points in the direction of the third key, so most of the weight lands there, and the output is pulled towards that key's value.

```python run
q = np.array([[0.0, 3.0]])
keys = np.array([[1.0, 0.0], [0.0, 1.0], [0.0, 3.0], [-1.0, 0.0]])
values = np.array([[10.0], [20.0], [30.0], [40.0]])

w_demo = softmax(q @ keys.T / np.sqrt(2), axis=-1)
print("weights over the four keys:", np.round(w_demo, 3))
print("attention output:", np.round(w_demo @ values, 2))
```

The output is close to 30, the value of the matching key, and not a plain average of all four. Attention is a learned, content-based lookup.

## Why divide by the square root of d

Dot products grow with the dimension. If the entries of $Q$ and $K$ have variance one, a dot product over $d$ entries has variance $d$. Large scores push softmax towards a one-hot answer, where the gradients are almost zero. Dividing by $\sqrt{d}$ keeps the scores at a useful scale.

```python run
for d_check in [8, 64, 512]:
    q = rng.normal(size=(2000, d_check))
    k = rng.normal(size=(2000, d_check))
    raw = np.sum(q * k, axis=1)
    print(f"d = {d_check:>3}: std of raw scores {raw.std():6.2f}   scaled {(raw / np.sqrt(d_check)).std():.2f}")
```

The raw scores grow like $\sqrt{d}$, and the scaled ones stay near one, whatever the dimension.

## Causal masks: no peeking at the future

A language model predicts the next word, so a position must not see words after it. A **causal mask** sets the scores for future positions to a very negative value before the softmax. Their weights become zero, and the model attends only to the past.

```python run
mask = np.tril(np.ones((n, n), dtype=bool))      # True where attention is allowed
masked_scores = np.where(mask, scores, -1e9)
causal_weights = softmax(masked_scores, axis=-1)
print(np.round(causal_weights, 3))
```

The upper triangle is zero: the first token attends only to itself, the second to the first two, and so on. This is how GPT-style models are trained in parallel, with every next-word prediction in one pass.

> **In the wild:** Transformers stack many attention layers, each with several "heads" that learn different relationships, and each followed by a feed-forward network. The formula above is the core of every head.

## Challenge: scaled dot-product attention

```python exercise id=attention title="Scaled dot-product attention"
# TODO: `attention(Q, K, V)` returns a tuple (out, weights). weights = softmax(Q Kᵀ / sqrt(d)) over the
# keys, with one row per query, where d is the number of columns of Q. out = weights @ V.
def attention(Q, K, V):
    ...
--- solution
def attention(Q, K, V):
    d = Q.shape[-1]
    scores = Q @ K.T / np.sqrt(d)
    e = np.exp(scores - scores.max(axis=-1, keepdims=True))
    weights = e / e.sum(axis=-1, keepdims=True)
    return weights @ V, weights
--- test
rng_t = np.random.default_rng(5)
Qt = rng_t.normal(size=(3, 4))
Kt = rng_t.normal(size=(5, 4))
Vt = rng_t.normal(size=(5, 2))
result = attention(Qt, Kt, Vt)
assert result is not None, "Replace the `...` in `attention` with code that returns (out, weights)."
out, w = result
assert out.shape == (3, 2), f"With 3 queries and values of size 2 the output should be (3, 2), but it is {out.shape}."
assert w.shape == (3, 5), f"The weights should have one row per query and one column per key, (3, 5), but they have shape {w.shape}."
assert np.allclose(w.sum(axis=1), 1.0), "Each row of weights must sum to 1."
s = Qt @ Kt.T / np.sqrt(4)
ref = np.exp(s) / np.exp(s).sum(axis=1, keepdims=True)
assert np.allclose(w, ref), "Check the scaling: divide the scores by sqrt(d), where d is the query size, not the number of keys."
assert np.allclose(out, ref @ Vt), "The output should be the weights times the values."
--- hint
Compute `Q @ K.T`, divide by `np.sqrt(d)`, then apply a softmax across each row (`axis=-1`). The output is the weights times `V`.
--- hint
`scores = Q @ K.T / np.sqrt(d)`; then `weights` is `exp(scores)` normalized along the last axis, and the output is `weights @ V`.
```

## Challenge: a causal mask

```python exercise id=causal-mask title="Build a causal mask"
# TODO: `causal_mask(n)` returns an (n, n) boolean array that is True where position i may attend to position j,
# which is when j <= i. Use the lower triangle, including the diagonal.
def causal_mask(n):
    ...
--- solution
def causal_mask(n):
    return np.tril(np.ones((n, n), dtype=bool))
--- test
m = causal_mask(3)
assert m is not None, "Replace the `...` in `causal_mask` with code that returns the mask."
assert m.dtype == bool and m.shape == (3, 3), f"The mask should be a boolean (3, 3) array, but it is {m.dtype} with shape {m.shape}."
expected = np.array([[True, False, False], [True, True, False], [True, True, True]])
assert np.array_equal(m, expected), f"Position 0 may see only itself, and position 2 may see everything before it. You returned {m.astype(int).tolist()}."
assert causal_mask(1).tolist() == [[True]], "A single position may attend to itself."
--- hint
`np.tril` keeps the lower triangle of an array. Build an array of ones with the right shape, and keep its lower triangle.
--- hint
`np.tril(np.ones((n, n), dtype=bool))`.
```

## Debug the attention axis

This version normalizes the scores down each column instead of across each row, so every query's weights fail to sum to one.

```python debug id=attention-axis title="Normalize each query's weights"
rng_d = np.random.default_rng(3)
Q = rng_d.normal(size=(3, 4))
K = rng_d.normal(size=(5, 4))
scores = Q @ K.T / np.sqrt(4)
e = np.exp(scores - scores.max(axis=1, keepdims=True))
weights = e / e.sum(axis=0, keepdims=True)              # bug: normalizes across queries
print("row sums:", np.round(weights.sum(axis=1), 3))
--- solution
rng_d = np.random.default_rng(3)
Q = rng_d.normal(size=(3, 4))
K = rng_d.normal(size=(5, 4))
scores = Q @ K.T / np.sqrt(4)
e = np.exp(scores - scores.max(axis=1, keepdims=True))
weights = e / e.sum(axis=1, keepdims=True)
print("row sums:", np.round(weights.sum(axis=1), 3))
--- test
assert np.allclose(weights.sum(axis=1), 1.0), f"Each query's weights must sum to 1, but the row sums are {weights.sum(axis=1)}. Normalize across the keys, which is axis 1."
assert weights.shape == (3, 5), f"The weights should have shape (3, 5), but they have {weights.shape}."
--- hint
Each row is one query, and the keys are the columns. The softmax must be normalized over the columns of each row.
--- hint
Change `e.sum(axis=0)` to `e.sum(axis=1)`.
```

## Predict the mask row

```python predict id=predict-mask title="What can position 0 attend to?"
import numpy as np
print(np.tril(np.ones((3, 3)))[0])
--- options
* [1. 0. 0.]
[1. 1. 1.]
[0. 0. 1.]
[0.33 0.33 0.33]
--- explain
The first row of a lower-triangular matrix has a one only in its first column. Position 0 may attend only to itself, so every other weight is zeroed by the mask.
```

## Recap

- Attention scores every query against every key with a dot product, turns the scores into weights with softmax, and outputs a weighted sum of values.
- Scale the scores by $\sqrt{d}$ so that softmax keeps useful gradients as the dimension grows.
- Each row of the weights is a distribution over positions, so every row sums to one.
- A causal mask zeroes the weights for future positions, which lets a language model train on every position at once.

**Up next:** a capstone. You will train an image classifier from scratch on data you generate, using the pieces from this course.
