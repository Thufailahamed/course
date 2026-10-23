Before transformers, language was modelled with recurrent networks. A recurrent network reads one token at a time and carries a hidden state forward. That state must hold everything the model needs to remember, and it is squeezed through one fixed-size vector at every step. Two problems follow: information from early tokens fades, and each step must wait for the previous one, so the work cannot run in parallel across the sequence.

Attention removes both problems. Every token can read directly from any other token, and all positions are computed at once with matrix products. This lesson shows the contrast in code.

## The bottleneck

A recurrent summary keeps one state, updated at each step. The state's usefulness for a token from far in the past depends on how well it survives many updates.

```python run
import numpy as np

rng = np.random.default_rng(0)
x = rng.normal(size=(10, 4))             # ten tokens, four features each
state = np.zeros(4)
for token in x:
    state = np.tanh(0.9 * state + token)  # a simple recurrent update
print("final state, one vector for all ten tokens:", np.round(state, 2))
```

Everything the model knows about ten tokens must fit in one vector of four numbers after the last step. Attention avoids this compression by keeping every token's representation available.

## Attention as a lookup

Attention treats each token as a query that looks up the keys of all tokens and returns a weighted mix of their values. The weights depend on how well the query matches each key.

```python run
query = np.array([1.0, 0.0, 0.0, 0.0])
keys = np.eye(4)                          # four tokens with orthogonal keys
values = np.arange(4, dtype=float).reshape(4, 1)
scores = keys @ query
weights = np.exp(scores) / np.exp(scores).sum()
print("weights:", np.round(weights, 3))
print("output:", np.round(weights @ values, 3))
```

The query matches the first key exactly, so most of the weight lands on the first value. Changing the query changes which tokens the output draws from, without any change in the architecture.

What happens when two keys are partly similar to the query? The weights split between them, and the output blends their values.

```python run
keys = np.array([[1.0, 0.0, 0.0, 0.0], [0.0, 1.0, 0.0, 0.0], [0.5, 0.0, 0.0, 0.0]])
w = np.exp(keys @ query)
w = w / w.sum()
print("weights with a partly similar third key:", np.round(w, 3))
```

## Parallel computation

Recurrent steps depend on each other. Attention scores every pair of tokens with one matrix product, so the whole sequence is processed together.

```python run
Q = rng.normal(size=(10, 4))
K = rng.normal(size=(10, 4))
all_scores = Q @ K.T
print("one matrix product gives all", all_scores.size, "pairwise scores at once, shape", all_scores.shape)
```

> **Pitfall:** attention alone has no sense of order. The sequence "dog bites man" and "man bites dog" contain the same tokens, so the model needs positional information, which a later lesson adds.

> **In the wild:** the speed of parallel training is a large part of why transformers scaled up. Recurrent models could not use modern accelerators as efficiently.

## Challenge: attention weights for one query

```python exercise id=query-weights title="Attention weights for one query"
import numpy as np

# TODO: `query_weights(q, K)` returns the softmax of the dot products between one query vector q and each row of K.
# The result is a 1-D array of weights that sum to one.
def query_weights(q, K):
    ...
--- solution
import numpy as np

def query_weights(q, K):
    scores = np.asarray(K, dtype=float) @ np.asarray(q, dtype=float)
    e = np.exp(scores - scores.max())
    return e / e.sum()
--- test
import numpy as np
result = query_weights(np.array([1.0, 0.0]), np.array([[1.0, 0.0], [0.0, 1.0]]))
assert result is not None, "Replace the `...` in `query_weights` with code that returns the weights."
assert result.shape == (2,), "There is one weight per key."
expected = np.exp([1.0, 0.0]) / np.exp([1.0, 0.0]).sum()
assert np.allclose(result, expected), f"The scores are [1, 0], so the weights should be {expected}, but you returned {result}."
assert abs(result.sum() - 1.0) < 1e-9, "The weights must sum to one."
--- hint
Multiply the key matrix by the query to get one score per key, then take the softmax.
--- hint
`scores = K @ q`, then the usual shifted exponential and normalization.
```

## Challenge: the attention output

```python exercise id=attention-output title="Mix values with attention weights"
import numpy as np

# TODO: `attention_output(weights, V)` returns the weighted sum of the rows of V, using the weight vector.
def attention_output(weights, V):
    ...
--- solution
import numpy as np

def attention_output(weights, V):
    return np.asarray(weights, dtype=float) @ np.asarray(V, dtype=float)
--- test
import numpy as np
result = attention_output(np.array([0.25, 0.75]), np.array([[4.0, 0.0], [0.0, 8.0]]))
assert result is not None, "Replace the `...` in `attention_output` with code that returns the output."
assert np.allclose(result, [1.0, 6.0]), f"0.25 × [4, 0] + 0.75 × [0, 8] = [1, 6], but you returned {result}."
--- hint
A weighted sum of rows is a vector-matrix product: weights on the left, values on the right.
--- hint
`return weights @ V`.
```

## Debug the sequence order

This check is meant to show that attention is order-blind, but the swap of two tokens changes the result of the sum in the wrong place.

```python debug id=order-blind title="Attention output does not depend on order"
import numpy as np

tokens = np.array([[1.0, 0.0], [0.0, 1.0]])
weights = np.array([[0.9, 0.1], [0.2, 0.8]])
out = weights @ tokens
perm = np.array([1, 0])
out_swapped = weights @ tokens[perm]
print("same output after swapping tokens?", np.allclose(out, out_swapped))
--- solution
import numpy as np

tokens = np.array([[1.0, 0.0], [0.0, 1.0]])
weights = np.array([[0.9, 0.1], [0.2, 0.8]])
out = weights @ tokens
perm = np.array([1, 0])
out_swapped = weights[:, perm] @ tokens[perm]
print("same output after swapping tokens?", np.allclose(out, out_swapped))
--- test
assert np.allclose(out, out_swapped), "Permuting the tokens together with their weights must leave the output unchanged. Permute the weight columns too."
--- hint
When the tokens are reordered, the weight matrix's columns must be reordered in the same way.
--- hint
Use `weights[:, perm]` as well as `tokens[perm]`.
```

## Predict the output

```python predict id=predict-state title="How many numbers summarize ten tokens in the recurrent version?"
import numpy as np
state = np.zeros(4)
print(state.size)
--- options
* 4
10
40
1
--- explain
The recurrent state is one vector of size four, however many tokens were read. That fixed size is the bottleneck attention removes.
```

## Recap

- Recurrent models compress the whole past into one state, which fades over long distances.
- Attention lets every token read directly from every other token, with weights set by content.
- A query-key-value lookup returns a weighted mix of values, and all pairs are scored with one matrix product.
- Attention has no built-in sense of order, so positions must be added.

**Up next:** scaled dot-product attention in full, with the formula and its scaling.
