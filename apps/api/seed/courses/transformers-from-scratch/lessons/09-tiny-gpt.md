Now the parts come together. A decoder-only transformer, the GPT design, is an embedding, a stack of blocks with causal attention, a final normalization and a projection back to the vocabulary. Given a sequence of tokens, it outputs a distribution over the next token at every position. This lesson assembles a tiny version in NumPy and checks the property that defines a causal language model: the future cannot influence the past.

## The architecture

```python run
import numpy as np

rng = np.random.default_rng(0)
vocab, d, T = 12, 8, 5
E = rng.normal(0, 0.1, (vocab, d))           # token embeddings
P = rng.normal(0, 0.1, (16, d))               # position embeddings
Wq, Wk, Wv = (rng.normal(0, 0.3, (d, d)) for _ in range(3))
W1, b1 = rng.normal(0, 0.3, (d, 16)), np.zeros(16)
W2, b2 = rng.normal(0, 0.3, (16, d)), np.zeros(d)

def layer_norm(x, eps=1e-5):
    return (x - x.mean(axis=-1, keepdims=True)) / np.sqrt(x.var(axis=-1, keepdims=True) + eps)

def causal_attention(x):
    Q, K, V = x @ Wq, x @ Wk, x @ Wv
    scores = Q @ K.T / np.sqrt(d)
    scores = np.where(np.triu(np.ones_like(scores, dtype=bool), k=1), -np.inf, scores)
    e = np.exp(scores - scores.max(axis=-1, keepdims=True))
    return (e / e.sum(axis=-1, keepdims=True)) @ V

def tiny_gpt(tokens):
    x = E[tokens] + P[:len(tokens)]
    x = x + causal_attention(layer_norm(x))
    x = x + np.maximum(0, layer_norm(x) @ W1 + b1) @ W2 + b2
    return layer_norm(x) @ E.T                # logits over the vocabulary, tied to the embeddings

tokens = np.array([1, 4, 7, 2, 9])
logits = tiny_gpt(tokens)
print("logits shape (tokens, vocabulary):", logits.shape)
```

The output projection reuses the embedding table, a technique called weight tying. It saves parameters and often helps.

## The causal property

Position $t$ must depend only on tokens $0$ to $t$. Changing a later token must leave the earlier predictions unchanged. This test is the most important check on a causal model.

```python run
changed = tokens.copy()
changed[-1] = 0                               # change only the last token
diff_before = np.abs(tiny_gpt(tokens)[:-1] - tiny_gpt(changed)[:-1]).max()
print("largest change in earlier predictions:", diff_before)
```

A difference of zero means the past is unaffected by the future. Without the causal mask this number would be large.

## Next-token predictions

```python run
probs = np.exp(logits - logits.max(axis=-1, keepdims=True))
probs = probs / probs.sum(axis=-1, keepdims=True)
print("probability of each next token at the last position sums to:", round(float(probs[-1].sum()), 6))
print("most likely next token after the sequence:", int(np.argmax(probs[-1])))
```

> **In the wild:** GPT-2, GPT-3 and their successors are this architecture at a much larger scale, with more layers, wider features, many heads and a large vocabulary.

For a whole sequence the model produces one attention matrix per layer. Its shape shows that every token has a row of weights over the tokens it may see.

```python run
x_demo = E[tokens] + P[:len(tokens)]
Q_demo, K_demo = x_demo @ Wq, x_demo @ Wk
s_demo = Q_demo @ K_demo.T / np.sqrt(d)
s_demo = np.where(np.triu(np.ones_like(s_demo, dtype=bool), k=1), -np.inf, s_demo)
w_demo = np.exp(s_demo - s_demo.max(axis=-1, keepdims=True))
w_demo = w_demo / w_demo.sum(axis=-1, keepdims=True)
print("attention matrix shape:", w_demo.shape)
print("first row (sees only itself):", np.round(w_demo[0], 3))
```

## Challenge: causal attention

```python exercise id=causal-attn title="Causal self-attention"
import numpy as np

# TODO: `causal_self_attention(x, Wq, Wk, Wv)` takes a (tokens, d) array and returns the causal self-attention output:
# queries, keys and values are x @ Wq, x @ Wk and x @ Wv. Scores are scaled by sqrt(d) and future positions are masked.
def causal_self_attention(x, Wq, Wk, Wv):
    ...
--- solution
import numpy as np

def causal_self_attention(x, Wq, Wk, Wv):
    x = np.asarray(x, dtype=float)
    Q, K, V = x @ Wq, x @ Wk, x @ Wv
    d = Q.shape[-1]
    scores = Q @ K.T / np.sqrt(d)
    scores = np.where(np.triu(np.ones_like(scores, dtype=bool), k=1), -np.inf, scores)
    e = np.exp(scores - scores.max(axis=-1, keepdims=True))
    return (e / e.sum(axis=-1, keepdims=True)) @ V
--- test
import numpy as np
rng_t = np.random.default_rng(3)
x_t = rng_t.normal(size=(4, 3))
Wq_t, Wk_t, Wv_t = (rng_t.normal(size=(3, 3)) for _ in range(3))
out = causal_self_attention(x_t, Wq_t, Wk_t, Wv_t)
assert out is not None, "Replace the `...` in `causal_self_attention` with code that returns the output."
assert out.shape == (4, 3), "There is one output per token, with the value size."
x2 = x_t.copy()
x2[-1] += 5.0
out2 = causal_self_attention(x2, Wq_t, Wk_t, Wv_t)
assert np.allclose(out[:-1], out2[:-1]), "Changing the last token must not change any earlier output. Check the causal mask."
--- hint
Build Q, K and V with the three matrices, scale the scores, mask the future, then take the softmax and multiply by V.
--- hint
Use the same steps as the attention lesson, with `np.triu(..., k=1)` as the mask.
```

## Challenge: next-token distribution

```python exercise id=next-distribution title="The next-token distribution"
import numpy as np

# TODO: `next_token_distribution(logits)` takes a (positions, vocabulary) array of logits and returns the softmax
# probabilities of the LAST position only, as a 1-D array that sums to one.
def next_token_distribution(logits):
    ...
--- solution
import numpy as np

def next_token_distribution(logits):
    last = np.asarray(logits, dtype=float)[-1]
    e = np.exp(last - last.max())
    return e / e.sum()
--- test
import numpy as np
result = next_token_distribution(np.array([[0.0, 0.0], [1.0, 1.0]]))
assert result is not None, "Replace the `...` in `next_token_distribution` with code that returns the probabilities."
assert result.shape == (2,), "There is one probability per vocabulary entry, for the last position only."
assert np.allclose(result, [0.5, 0.5]), "The last row has equal logits, so the distribution is uniform."
assert abs(result.sum() - 1.0) < 1e-9, "The probabilities must sum to one."
--- hint
Take the last row with `[-1]`, then apply the stable softmax to that row alone.
--- hint
`last = np.asarray(logits)[-1]`, then the usual shifted exponential and normalization.
```

## Debug the missing mask

This attention is meant to be causal, but the mask is missing, so each token can see the future and the model would cheat during training.

```python debug id=no-causal-mask title="Hide the future"
import numpy as np

rng_d = np.random.default_rng(4)
x = rng_d.normal(size=(4, 3))
Wq, Wk, Wv = (rng_d.normal(size=(3, 3)) for _ in range(3))
Q, K, V = x @ Wq, x @ Wk, x @ Wv
scores = Q @ K.T / np.sqrt(3)                 # bug: no mask is applied
e = np.exp(scores - scores.max(axis=-1, keepdims=True))
out = (e / e.sum(axis=-1, keepdims=True)) @ V
print("first output:", np.round(out[0], 3))
--- solution
import numpy as np

rng_d = np.random.default_rng(4)
x = rng_d.normal(size=(4, 3))
Wq, Wk, Wv = (rng_d.normal(size=(3, 3)) for _ in range(3))
Q, K, V = x @ Wq, x @ Wk, x @ Wv
scores = Q @ K.T / np.sqrt(3)
scores = np.where(np.triu(np.ones_like(scores, dtype=bool), k=1), -np.inf, scores)
e = np.exp(scores - scores.max(axis=-1, keepdims=True))
out = (e / e.sum(axis=-1, keepdims=True)) @ V
print("first output:", np.round(out[0], 3))
--- test
assert np.allclose(out[0], V[0]), "The first token may attend only to itself, so its output must equal its own value V[0]. Mask the future positions before the softmax."
--- hint
Positions after token t must get a score of minus infinity before the softmax.
--- hint
`scores = np.where(np.triu(np.ones_like(scores, dtype=bool), k=1), -np.inf, scores)`.
```

## Predict the causal check

```python predict id=predict-causal-gpt title="In a causal model, what happens to the first position's prediction if the last token changes?"
print("it stays the same")
--- options
* it stays the same
it changes
it becomes zero
it becomes random
--- explain
The first position can only attend to itself, so no later token can affect its output. That is what makes the model causal.

```