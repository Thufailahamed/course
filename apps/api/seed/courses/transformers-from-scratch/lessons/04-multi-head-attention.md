One attention pattern captures one kind of relationship. A token may need to look at the previous word for grammar, at the subject of the sentence for agreement, and at a related noun for meaning, all at once. **Multi-head attention** runs several attentions in parallel, each on its own slice of the representation, then combines their outputs. Each head learns to look for something different.

## Splitting into heads

Suppose each token has $d$ features and there are $h$ heads. Each head works on $d / h$ features. Splitting is a reshape, and merging back is the reverse reshape.

```python run
import numpy as np

X = np.arange(12, dtype=float).reshape(3, 4)     # 3 tokens, 4 features
h = 2
n, d = X.shape
heads = X.reshape(n, h, d // h).transpose(1, 0, 2)   # shape (heads, tokens, features per head)
print("shape:", heads.shape)
print("head 0, token 0:", heads[0, 0])
print("head 1, token 0:", heads[1, 0])
```

Head 0 sees the first two features of every token, and head 1 sees the last two. Each head therefore has its own subspace to work in.

## The multi-head formula

Each head computes attention on its own projections of the input, and the results are concatenated and projected back to the model size:

$$
\operatorname{MultiHead}(X) = \operatorname{Concat}(\text{head}_1, \dots, \text{head}_h)\, W_O, \qquad \text{head}_i = \operatorname{Attention}(XW_i^Q, XW_i^K, XW_i^V)
$$

```python run
def attention_heads(H_q, H_k, H_v):
    d_head = H_q.shape[-1]
    scores = H_q @ H_k.transpose(0, 2, 1) / np.sqrt(d_head)
    e = np.exp(scores - scores.max(axis=-1, keepdims=True))
    w = e / e.sum(axis=-1, keepdims=True)
    return w @ H_v

rng = np.random.default_rng(0)
x = rng.normal(size=(5, 8))                     # 5 tokens, model size 8
h_count = 4
Wq, Wk, Wv = (rng.normal(size=(8, 8)) * 0.3 for _ in range(3))
def split(M):
    return M.reshape(5, h_count, 2).transpose(1, 0, 2)
out_heads = attention_heads(split(x @ Wq), split(x @ Wk), split(x @ Wv))
merged = out_heads.transpose(1, 0, 2).reshape(5, 8)
print("heads:", out_heads.shape, "| merged back to model size:", merged.shape)
```

The merged output has the same shape as the input, so the next layer does not need to know that attention was split.

> **Under the hood:** real models compute all the heads with one batched matrix product, the same way as this code, rather than looping over heads.

Each head sees a different slice of the features, so the heads produce different outputs for the same tokens.

```python run
out_per_head = [out_heads[h].round(2) for h in range(h_count)]
print("head 0, first token:", out_per_head[0][0])
print("head 1, first token:", out_per_head[1][0])
print("the heads disagree:", not np.allclose(out_heads[0], out_heads[1]))
```

## Challenge: split into heads

```python exercise id=split-heads title="Split the features into heads"
import numpy as np

# TODO: `split_heads(X, h)` takes a (tokens, features) array and returns a (heads, tokens, features // heads) array.
# Head i receives the features with indices i·(features // h) up to (i + 1)·(features // h) − 1.
def split_heads(X, h):
    ...
--- solution
import numpy as np

def split_heads(X, h):
    X = np.asarray(X)
    n, d = X.shape
    return X.reshape(n, h, d // h).transpose(1, 0, 2)
--- test
import numpy as np
X = np.arange(12, dtype=float).reshape(3, 4)
result = split_heads(X, 2)
assert result is not None, "Replace the `...` in `split_heads` with code that returns the heads."
assert result.shape == (2, 3, 2), f"Two heads of three tokens with two features each should give (2, 3, 2), but you returned {result.shape}."
assert np.array_equal(result[0, 0], [0.0, 1.0]) and np.array_equal(result[1, 0], [2.0, 3.0]), "Head 0 should hold the first two features of token 0, and head 1 the next two."
--- hint
Reshape to (tokens, heads, features per head), then move the heads axis to the front with `transpose(1, 0, 2)`.
--- hint
`X.reshape(n, h, d // h).transpose(1, 0, 2)`.
```

Splitting and merging are exact inverses, so no information is lost by the reshape alone. Check the round trip on the input.

```python run
round_trip = x.reshape(5, h_count, 2).transpose(1, 0, 2).transpose(1, 0, 2).reshape(5, 8)
print("split then merge recovers the input:", np.allclose(round_trip, x))
```

## Challenge: merge heads

```python exercise id=merge-heads title="Merge the heads back"
import numpy as np

# TODO: `merge_heads(H)` takes a (heads, tokens, features per head) array and returns a (tokens, heads × features per head)
# array, the exact inverse of splitting.
def merge_heads(H):
    ...
--- solution
import numpy as np

def merge_heads(H):
    H = np.asarray(H)
    h, n, dh = H.shape
    return H.transpose(1, 0, 2).reshape(n, h * dh)
--- test
import numpy as np
X = np.arange(12, dtype=float).reshape(3, 4)
H = X.reshape(3, 2, 2).transpose(1, 0, 2)
result = merge_heads(H)
assert result is not None, "Replace the `...` in `merge_heads` with code that returns the merged array."
assert result.shape == (3, 4), "Merging should restore the original shape."
assert np.array_equal(result, X), "Merging must be the exact inverse of splitting."
--- hint
Move the heads axis back to the middle with `transpose(1, 0, 2)`, then reshape so the head features sit side by side.
--- hint
`H.transpose(1, 0, 2).reshape(n, h * dh)`.
```

## Debug the reshape

This split is meant to give each head a slice of the features for every token, but it reshapes straight into heads, so the tokens get mixed across heads.

```python debug id=wrong-reshape title="Split features, not tokens"
import numpy as np

X = np.arange(12, dtype=float).reshape(3, 4)
heads = X.reshape(2, 3, 2)              # bug: this splits the tokens across heads
print("head 0:", heads[0])
--- solution
import numpy as np

X = np.arange(12, dtype=float).reshape(3, 4)
heads = X.reshape(3, 2, 2).transpose(1, 0, 2)
print("head 0:", heads[0])
--- test
assert np.array_equal(heads[0], [[0.0, 1.0], [4.0, 5.0], [8.0, 9.0]]), f"Head 0 should hold the first two features of every token, but it holds {heads[0].tolist()}. Keep the token axis first when you reshape."
--- hint
The token axis must stay in front when the features are split.
--- hint
Reshape to `(3, 2, 2)` and then move the head axis to the front.
```

## Predict the shape

```python predict id=predict-heads title="What shape is the output of two heads on four tokens with model size 8?"
import numpy as np
heads = np.zeros((2, 4, 4))
print(heads.transpose(1, 0, 2).reshape(4, 8).shape)
--- options
* (4, 8)
(2, 4, 4)
(8, 4)
(4, 4)
--- explain
Each head outputs four tokens of size four. Merging two heads gives four tokens of size eight, the original model size.
```

## Recap

- Multi-head attention splits the features into heads, runs attention on each, and merges the results.
- Each head can specialize in a different relationship between tokens.
- Splitting and merging are reshapes, and merging is the exact inverse of splitting.
- The merged output keeps the model's shape, so the rest of the network is unchanged.

**Up next:** causal masks and positional information, the two ingredients that make a language model work.
