Once text is tokens, each token must become a vector the network can compute with. An **embedding table** maps every token id to a learned vector, and a position table adds where in the sequence the token sits. The result is the input to the transformer. Before any layer reads it, the representation is typically normalized, and **layer normalization** is the tool that keeps the numbers in a stable range at every layer.

## Embedding lookup

An embedding is a row lookup: token id 7 selects row 7 of the table. The model learns the rows during training, so tokens used in similar ways end up with similar vectors.

```python run
import numpy as np

rng = np.random.default_rng(0)
vocab_size, d_model = 10, 4
E = rng.normal(0, 0.1, (vocab_size, d_model))      # one learned row per token
tokens = np.array([3, 7, 3])
x = E[tokens]                                       # lookup: shape (3 tokens, 4 features)
print("shape:", x.shape)
print("the same token gives the same vector:", np.allclose(x[0], x[2]))
```

## Layer normalization

Layer normalization standardizes each token's own feature vector: subtract its mean and divide by its standard deviation, then apply a learned scale and shift. It works per token, so it does not depend on the other tokens or on the batch size.

$$
\operatorname{LN}(x) = \gamma \odot \frac{x - \mu}{\sqrt{\sigma^2 + \epsilon}} + \beta, \qquad \mu, \sigma^2 \text{ computed over the features of each token}
$$

```python run
def layer_norm(x, gamma=1.0, beta=0.0, eps=1e-5):
    mu = x.mean(axis=-1, keepdims=True)
    var = x.var(axis=-1, keepdims=True)
    return gamma * (x - mu) / np.sqrt(var + eps) + beta

normed = layer_norm(x * 100.0)                     # badly scaled input
print("means per token:", np.round(normed.mean(axis=-1), 6))
print("std per token:  ", np.round(normed.std(axis=-1), 4))
```

Whatever the input scale, each token comes out with mean zero and standard deviation one.

> **Pitfall:** normalize across the features, which is the last axis, not across the tokens. Normalizing across tokens makes each token depend on the rest of the sequence.

> **In the wild:** transformers place layer normalization before each sublayer in modern designs, which makes deep stacks train more reliably.

The same token at two positions gets two different vectors, because the position rows differ. This is how the model can tell "dog" at the start of a sentence from "dog" at the end.

```python run
P_demo = rng.normal(0, 0.1, (6, 4))
same_token = E[np.array([3, 3])] + P_demo[:2]
print("same token, two positions, identical:", np.allclose(same_token[0], same_token[1]))
print("difference between them:", np.round(same_token[1] - same_token[0], 3))
```

## Challenge: the embedding with positions

```python exercise id=embed-tokens title="Embeddings plus positions"
import numpy as np

# TODO: `embed(tokens, E, P)` returns the token embeddings E[tokens] with the position rows P[0 .. len(tokens) − 1] added.
def embed(tokens, E, P):
    ...
--- solution
import numpy as np

def embed(tokens, E, P):
    tokens = np.asarray(tokens)
    E = np.asarray(E, dtype=float)
    P = np.asarray(P, dtype=float)
    return E[tokens] + P[:len(tokens)]
--- test
import numpy as np
E_t = np.array([[1.0, 0.0], [0.0, 1.0], [2.0, 2.0]])
P_t = np.array([[10.0, 10.0], [20.0, 20.0], [30.0, 30.0]])
result = embed([2, 0], E_t, P_t)
assert result is not None, "Replace the `...` in `embed` with code that returns the embeddings."
assert result.shape == (2, 2), "Two tokens with two features should give shape (2, 2)."
assert np.allclose(result, [[12.0, 12.0], [21.0, 20.0]]), f"Token 2 gives [2, 2] plus position 0 [10, 10], and token 0 gives [1, 0] plus position 1 [20, 20]. You returned {result}."
--- hint
Look up the rows with `E[tokens]`, take the first `len(tokens)` position rows with `P[:len(tokens)]`, and add them.
--- hint
`return E[tokens] + P[:len(tokens)]`.
```

Learned scale and shift let the network undo the normalization where it wants to. With a gain of two and a shift of one, the output has standard deviation two and mean one.

```python run
gamma_demo, beta_demo = 2.0, 1.0
normed_demo = gamma_demo * layer_norm(x) + beta_demo
print("mean per token:", np.round(normed_demo.mean(axis=-1), 4))
print("std per token:", np.round(normed_demo.std(axis=-1), 4))
```

## Challenge: layer normalization

```python exercise id=layer-norm-fn title="Layer normalization of each token"
import numpy as np

# TODO: `layer_norm(x)` standardizes each row of the 2-D array x (each token) to mean zero and standard deviation one,
# using eps = 1e-5 in the denominator. Normalize across the features, which is the last axis.
def layer_norm(x):
    ...
--- solution
import numpy as np

def layer_norm(x):
    x = np.asarray(x, dtype=float)
    mu = x.mean(axis=-1, keepdims=True)
    var = x.var(axis=-1, keepdims=True)
    return (x - mu) / np.sqrt(var + 1e-5)
--- test
import numpy as np
result = layer_norm(np.array([[1.0, 2.0, 3.0], [10.0, 10.0, 40.0]]))
assert result is not None, "Replace the `...` in `layer_norm` with code that returns the normalized rows."
assert result.shape == (2, 3), "The shape should be preserved."
assert np.allclose(result.mean(axis=-1), 0.0, atol=1e-9), "Each row should have mean zero."
assert np.allclose(result.std(axis=-1), 1.0, atol=1e-3), "Each row should have standard deviation one."
assert np.allclose(result[0], [-1.2247, 0.0, 1.2247], atol=1e-3), f"The first row [1, 2, 3] normalizes to about [−1.225, 0, 1.225], but you returned {result[0]}."
--- hint
Compute the mean and variance of each row with `axis=-1, keepdims=True`, then subtract and divide.
--- hint
`(x - mu) / np.sqrt(var + 1e-5)`.
```

## Debug the normalization axis

This layer norm is meant to normalize each token's features, but it averages across the tokens, so every token depends on the others.

```python debug id=ln-axis title="Normalize across features"
import numpy as np

x = np.array([[1.0, 2.0, 3.0], [10.0, 10.0, 40.0]])
mu = x.mean(axis=0, keepdims=True)                   # bug: averages down the tokens
var = x.var(axis=0, keepdims=True)
out = (x - mu) / np.sqrt(var + 1e-5)
print("row means:", np.round(out.mean(axis=1), 3))
--- solution
import numpy as np

x = np.array([[1.0, 2.0, 3.0], [10.0, 10.0, 40.0]])
mu = x.mean(axis=-1, keepdims=True)
var = x.var(axis=-1, keepdims=True)
out = (x - mu) / np.sqrt(var + 1e-5)
print("row means:", np.round(out.mean(axis=1), 3))
--- test
assert np.allclose(out.mean(axis=1), 0.0, atol=1e-6), f"Each token's features should average to zero, but the row means are {out.mean(axis=1)}. Normalize across the last axis."
--- hint
Each token is one row, and its features are the columns.
--- hint
Use `axis=-1`, which runs across the features of each row.
```

## Predict the shape

```python predict id=predict-embed title="What shape is the embedding of a sequence of 5 tokens with model size 8?"
import numpy as np
E = np.zeros((100, 8))
tokens = np.arange(5)
print(E[tokens].shape)
--- options
* (5, 8)
(100, 8)
(8, 5)
(5,)
--- explain
The lookup selects one row of size 8 for each of the 5 tokens, giving shape (5, 8). The vocabulary of 100 rows is not kept.

```