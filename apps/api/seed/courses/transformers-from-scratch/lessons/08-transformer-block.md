A transformer block combines two sublayers: attention, which lets tokens exchange information, and a feed-forward network, which transforms each token on its own. Each sublayer is wrapped in a **residual connection**, so its output is added to its input. That addition is what lets very deep stacks train: every block only has to learn a correction to what is already there.

## The residual stream

A token's vector is a running sum. Each sublayer reads it, computes an update and adds that update back. The information about the token is preserved along the way, and nothing is lost to a fresh transformation at every layer.

```python run
import numpy as np

x = np.array([[1.0, -1.0, 0.5]])
update = np.array([[0.2, 0.0, -0.1]])        # what one sublayer wants to add
out = x + update
print("residual output:", out)
print("the input survives in the output:", np.allclose(out - update, x))
```

## Pre-norm blocks

In the modern arrangement, each sublayer reads a layer-normalized copy of the stream, and its output is added back to the unnormalized stream:

$$
x \leftarrow x + \operatorname{Attention}(\operatorname{LN}(x)), \qquad x \leftarrow x + \operatorname{FFN}(\operatorname{LN}(x))
$$

```python run
def layer_norm(x, eps=1e-5):
    mu = x.mean(axis=-1, keepdims=True)
    var = x.var(axis=-1, keepdims=True)
    return (x - mu) / np.sqrt(var + eps)

def feed_forward(x, W1, b1, W2, b2):
    return np.maximum(0.0, x @ W1 + b1) @ W2 + b2

rng = np.random.default_rng(0)
d, hidden = 4, 16
W1, b1 = rng.normal(0, 0.3, (d, hidden)), np.zeros(hidden)
W2, b2 = rng.normal(0, 0.3, (hidden, d)), np.zeros(d)
x = rng.normal(size=(3, d))
ffn_out = feed_forward(layer_norm(x), W1, b1, W2, b2)
print("feed-forward output shape:", ffn_out.shape)
print("input and output share a shape, so residuals can add:", (x + ffn_out).shape)
```

The feed-forward network expands each token to a wider hidden size, applies a non-linearity, and projects back. It is where much of a transformer's parameters live.

## Stacking blocks

```python run
def block(x, attention_fn, ffn_fn):
    x = x + attention_fn(layer_norm(x))
    x = x + ffn_fn(layer_norm(x))
    return x

identity_attention = lambda z: np.zeros_like(z)
x_out = x
for _ in range(4):
    x_out = block(x_out, identity_attention, lambda z: feed_forward(z, W1, b1, W2, b2))
print("after four blocks, shape:", x_out.shape)
```

Stacking blocks repeats this pattern. The residual path keeps the signal alive through depth, and each block adds one more layer of refinement.

> **Pitfall:** forgetting a residual connection is one of the most damaging transformer bugs. The network still runs, but the signal from the input is lost and deep stacks fail to learn.

> **In the wild:** GPT-2 and most later models use pre-norm blocks with residuals around both sublayers, as in the code above.

Stacking blocks grows the stream when each sublayer adds something. Track how the size of each token's vector changes across blocks.

```python run
stream = rng.normal(size=(3, d))
sizes = [np.linalg.norm(stream, axis=-1).mean()]
for _ in range(3):
    stream = block(stream, lambda z: 0.1 * z, lambda z: feed_forward(z, W1, b1, W2, b2))
    sizes.append(np.linalg.norm(stream, axis=-1).mean())
print("mean token norm after each block:", np.round(sizes, 3))
```

## Challenge: a transformer block

```python exercise id=transformer-block title="One transformer block"
import numpy as np

def layer_norm(x, eps=1e-5):
    mu = x.mean(axis=-1, keepdims=True)
    var = x.var(axis=-1, keepdims=True)
    return (x - mu) / np.sqrt(var + eps)

# TODO: `block(x, attention_fn, ffn_fn)` returns the output of one pre-norm block: first x plus attention_fn applied to
# layer_norm(x), then that result plus ffn_fn applied to layer_norm of it.
def block(x, attention_fn, ffn_fn):
    ...
--- solution
import numpy as np

def layer_norm(x, eps=1e-5):
    mu = x.mean(axis=-1, keepdims=True)
    var = x.var(axis=-1, keepdims=True)
    return (x - mu) / np.sqrt(var + eps)

def block(x, attention_fn, ffn_fn):
    x = x + attention_fn(layer_norm(x))
    x = x + ffn_fn(layer_norm(x))
    return x
--- test
import numpy as np
x = np.array([[1.0, 2.0, 3.0]])
out = block(x, lambda z: np.zeros_like(z), lambda z: 2.0 * z)
assert out is not None, "Replace the `...` in `block` with code that returns the block output."
normed = layer_norm(x)
assert np.allclose(out, x + 2.0 * layer_norm(x)), "With zero attention and a feed-forward of 2·z, the output should be x + 2·LN(x) after the residuals, computed on the normalized stream."
assert out.shape == x.shape, "A block keeps the shape of its input."
--- hint
Apply the attention to a normalized copy, add the result to `x`. Then do the same with the feed-forward on the new `x`.
--- hint
`x = x + attention_fn(layer_norm(x))`, then `x = x + ffn_fn(layer_norm(x))`, then return `x`.
```

## Challenge: the feed-forward sublayer

```python exercise id=ffn-layer title="The feed-forward sublayer"
import numpy as np

# TODO: `feed_forward(x, W1, b1, W2, b2)` returns max(0, x W1 + b1) W2 + b2 for a (tokens, d) array x.
def feed_forward(x, W1, b1, W2, b2):
    ...
--- solution
import numpy as np

def feed_forward(x, W1, b1, W2, b2):
    return np.maximum(0.0, np.asarray(x, dtype=float) @ W1 + b1) @ W2 + b2
--- test
import numpy as np
W1_t = np.array([[1.0, -1.0]])
b1_t = np.zeros(2)
W2_t = np.array([[1.0], [1.0]])
b2_t = np.array([0.5])
result = feed_forward(np.array([[2.0], [-3.0]]), W1_t, b1_t, W2_t, b2_t)
assert result is not None, "Replace the `...` in `feed_forward` with code that returns the output."
assert result.shape == (2, 1), "Two tokens with output size one should give shape (2, 1)."
assert np.allclose(result, [[2.5], [3.5]]), f"For x = 2 the hidden units are [2, −2] → [2, 0], so the output is 2 + 0.5 = 2.5. For x = −3 they are [−3, 3] → [0, 3], so the output is 3 + 0.5 = 3.5. You returned {result.ravel()}."
--- hint
Compute the hidden layer, `x @ W1 + b1`, apply `np.maximum(0, ...)`, then the second layer.
--- hint
`np.maximum(0.0, x @ W1 + b1) @ W2 + b2`.
```

## Debug the residual

This block is meant to keep the input through the residual connection, but it returns only the attention output, so the token's own information is discarded.

```python debug id=missing-residual title="Keep the residual connection"
import numpy as np

def layer_norm(x, eps=1e-5):
    return (x - x.mean(axis=-1, keepdims=True)) / np.sqrt(x.var(axis=-1, keepdims=True) + eps)

x = np.array([[1.0, 2.0, 3.0]])
attn = lambda z: 0.5 * z
out = attn(layer_norm(x))                     # bug: the residual connection is missing
print("output:", np.round(out, 3))
--- solution
import numpy as np

def layer_norm(x, eps=1e-5):
    return (x - x.mean(axis=-1, keepdims=True)) / np.sqrt(x.var(axis=-1, keepdims=True) + eps)

x = np.array([[1.0, 2.0, 3.0]])
attn = lambda z: 0.5 * z
out = x + attn(layer_norm(x))
print("output:", np.round(out, 3))
--- test
assert np.allclose(out, x + 0.5 * layer_norm(x)), "The block output must add the sublayer's result to the input, through a residual connection."
--- hint
A residual connection adds the input back to the sublayer's output.
--- hint
`out = x + attn(layer_norm(x))`.
```

## Predict the residual

```python predict id=predict-residual title="What is the output of x + f(x) when f returns zero?"
import numpy as np
x = np.array([1.0, 2.0])
print(x + np.zeros_like(x))
--- options
* [1. 2.]
[0. 0.]
[2. 4.]
[1. 0.]
--- explain
A sublayer that returns zero leaves the stream unchanged, which is what residuals guarantee: the input is always preserved.

```