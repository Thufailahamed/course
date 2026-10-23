Welcome to **Transformers from Scratch**. A transformer is a stack of simple, repeated blocks, and each block does two things: it lets every token look at every other token, and it transforms each token's representation with a small neural network. Language models, image models and speech models have all been built from this design, so understanding it well is one of the most valuable things a deep-learning engineer can do.

This course builds the architecture one component at a time. Each lesson gives you the idea, the formula, and a NumPy implementation that runs in this page. The complete PyTorch model and training loop are shown as static code for you to run locally, and each of their parts is already familiar from a NumPy version.

> **How to use this lesson:** read a little, run a little. Every grey box runs in the page.

## Run a first attention

Here is the single idea that makes transformers work, in four lines. Each token builds its output as a weighted average of all tokens, with weights that depend on the content of the tokens.

```python run
import numpy as np

tokens = np.array([[1.0, 0.0], [0.0, 1.0], [1.0, 1.0]])   # three tokens, each a 2-number vector
scores = tokens @ tokens.T                               # how well each token matches each other token
weights = np.exp(scores) / np.exp(scores).sum(axis=1, keepdims=True)
print("attention weights:\n", np.round(weights, 3))
print("outputs:\n", np.round(weights @ tokens, 3))
```

Every row of the weight matrix sums to one, and every output mixes information from the whole sequence. Attention is a learned, content-based way for tokens to communicate.

## Predict the output

```python predict id=predict-rows title="What does each row of the weights sum to?"
import numpy as np
w = np.array([[0.2, 0.8], [0.5, 0.5]])
print(np.round(w.sum(axis=1), 2))
--- options
* [1. 1.]
[0.2 0.5]
[2. 2.]
[1. 0.]
--- explain
Each row is a probability distribution over the tokens, so it sums to one. Rows of this matrix sum to 1 and 1, which is the property softmax guarantees.
```

## Your first challenge

A **challenge** asks you to write a function that the course tests on new data.

```python exercise id=row-softmax title="A softmax over each row"
import numpy as np

# TODO: `row_softmax(Z)` returns a matrix of the same shape in which each row is turned into probabilities by softmax.
# Subtract each row's maximum first, for numerical stability.
def row_softmax(Z):
    ...
--- solution
import numpy as np

def row_softmax(Z):
    Z = np.asarray(Z, dtype=float)
    e = np.exp(Z - Z.max(axis=1, keepdims=True))
    return e / e.sum(axis=1, keepdims=True)
--- test
import numpy as np
result = row_softmax(np.array([[0.0, 0.0], [1000.0, 1000.0]]))
assert result is not None, "Replace the `...` in `row_softmax` with code that returns the probabilities."
assert result.shape == (2, 2), "The shape should be preserved."
assert np.allclose(result, 0.5), "Equal scores in a row give equal probabilities, even for huge values after the shift."
assert np.allclose(result.sum(axis=1), 1.0), "Each row must sum to one."
--- hint
Compute the maximum of each row with `axis=1, keepdims=True`, subtract it, then exponentiate and divide by the row sums.
--- hint
`e = np.exp(Z - Z.max(axis=1, keepdims=True))` and `return e / e.sum(axis=1, keepdims=True)`.
```

## Debug the wrong axis

This attention normalization is meant to make each token's weights sum to one, but it normalizes down the columns, so each token's weights are wrong.

```python debug id=softmax-axis title="Normalize each token's weights"
import numpy as np

scores = np.array([[2.0, 0.0], [1.0, 3.0]])
e = np.exp(scores)
weights = e / e.sum(axis=0, keepdims=True)           # bug: normalizes across the query tokens
print("row sums:", np.round(weights.sum(axis=1), 3))
--- solution
import numpy as np

scores = np.array([[2.0, 0.0], [1.0, 3.0]])
e = np.exp(scores)
weights = e / e.sum(axis=1, keepdims=True)
print("row sums:", np.round(weights.sum(axis=1), 3))
--- test
assert np.allclose(weights.sum(axis=1), 1.0), f"Each query's weights must sum to 1, but the row sums are {weights.sum(axis=1)}. Normalize across the keys, which is axis 1."
--- hint
Each row is one query, and its weights are over the keys, which are the columns.
--- hint
Use `axis=1` in the sum.
```

## Recap

- A transformer lets every token build its output from every other token, weighted by content.
- Attention weights are probabilities, one distribution per token, and each row sums to one.
- Shapes and axes decide whether attention means what you intend. Check them.
- Everything else in the architecture is built around this one operation.

**Up next:** where attention came from, and why it replaced recurrence.
