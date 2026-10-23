Turning a pretrained encoder into a classifier needs two steps. **Pooling** reduces the per-token vectors to one vector for the whole text, and a small **classification head**, usually a linear layer followed by softmax, maps that vector to class probabilities. Only the head is new. During fine-tuning the encoder's weights are adjusted too, but the mathematics of the head and of the loss is the same as in any multi-class classifier.

## Softmax over classes

```python run
import numpy as np

def softmax_rows(Z):
    e = np.exp(Z - Z.max(axis=1, keepdims=True))
    return e / e.sum(axis=1, keepdims=True)

logits = np.array([[2.0, 0.5, -1.0], [0.0, 0.0, 0.0]])
probs = softmax_rows(logits)
print(np.round(probs, 3))
print("rows sum to:", probs.sum(axis=1))
```

Equal logits give equal probabilities, one over the number of classes. That is the honest answer of an untrained head.

## A head on top of pooled vectors

The head is a weight matrix and a bias. Given pooled vectors for a batch of texts, it produces one row of logits per text.

```python run
rng = np.random.default_rng(0)
n_per_class, d = 20, 4
centres = np.array([[1.0, 0.0, 0.0, 0.0], [0.0, 1.0, 0.0, 0.0], [0.0, 0.0, 1.0, 0.0]])
X = np.vstack([c + rng.normal(0, 0.3, (n_per_class, d)) for c in centres])
y = np.repeat([0, 1, 2], n_per_class)
W = np.zeros((d, 3))
b = np.zeros(3)
for _ in range(300):
    P = softmax_rows(X @ W + b)
    G = P.copy()
    G[np.arange(len(y)), y] -= 1
    W -= 0.5 * X.T @ G / len(y)
    b -= 0.5 * G.mean(axis=0)
accuracy = np.mean(np.argmax(X @ W + b, axis=1) == y)
print("training accuracy of the head:", round(float(accuracy), 3))
```

The head learns to separate the three clusters. In real fine-tuning the pooled vectors come from the encoder, which is also updated.

## Cross-entropy

The loss for a batch is the average negative log probability of each text's correct class. It is small when the head is confident and right, and large when it is confident and wrong.

```python run
P_demo = np.array([[0.7, 0.2, 0.1], [0.1, 0.8, 0.1]])
labels = np.array([0, 1])
loss = -np.mean(np.log(P_demo[np.arange(2), labels]))
print("cross-entropy:", round(float(loss), 4))
```

> **Pitfall:** pooling must respect padding. Averaging over padding positions makes a text's representation depend on how much padding the batch needed, which changes predictions for the same text.

> **In the wild:** `AutoModelForSequenceClassification` in Hugging Face adds exactly this head on top of a pretrained encoder, and it pools the [CLS] token by default.

Mean pooling averages token vectors over the real tokens. A weight of one for each real token and zero for padding gives the same result with a single product.

```python run
import numpy as np
H = np.array([[1.0, 2.0], [3.0, 4.0], [9.0, 9.0]])
keep = np.array([1.0, 1.0, 0.0])
print("mean over real tokens:", (keep @ H) / keep.sum())
```

## Challenge: row softmax

```python exercise id=softmax-rows title="Softmax over each row"
import numpy as np

# TODO: `softmax_rows(Z)` returns the softmax of each row of the 2-D array Z, computed stably.
def softmax_rows(Z):
    ...
--- solution
import numpy as np

def softmax_rows(Z):
    Z = np.asarray(Z, dtype=float)
    e = np.exp(Z - Z.max(axis=1, keepdims=True))
    return e / e.sum(axis=1, keepdims=True)
--- test
import numpy as np
result = softmax_rows(np.array([[0.0, 0.0, 0.0], [1000.0, 1000.0, 0.0]]))
assert result is not None, "Replace the `...` in `softmax_rows` with code that returns the probabilities."
assert np.allclose(result[0], [1 / 3, 1 / 3, 1 / 3]), "Equal logits give equal probabilities."
assert np.allclose(result[1], [0.5, 0.5, 0.0], atol=1e-9), "Huge logits must not overflow. Subtract the row maximum first."
assert np.allclose(result.sum(axis=1), 1.0), "Each row sums to one."
--- hint
Subtract each row's maximum before exponentiating, then divide by the row sums.
--- hint
`e = np.exp(Z - Z.max(axis=1, keepdims=True))` and `e / e.sum(axis=1, keepdims=True)`.
```

## Challenge: cross-entropy from probabilities

```python exercise id=ce-from-probs title="Average negative log probability of the correct class"
import numpy as np

# TODO: `cross_entropy_from_probs(P, y)` takes a (texts, classes) array of probabilities and an array of correct class
# indices. Return the mean of −log P[i, y_i] over the texts.
def cross_entropy_from_probs(P, y):
    ...
--- solution
import numpy as np

def cross_entropy_from_probs(P, y):
    P = np.asarray(P, dtype=float)
    y = np.asarray(y)
    return float(-np.mean(np.log(P[np.arange(len(y)), y])))
--- test
import numpy as np
result = cross_entropy_from_probs(np.array([[0.5, 0.5], [0.25, 0.75]]), [0, 1])
assert result is not None, "Replace the `...` in `cross_entropy_from_probs` with code that returns the loss."
expected = -(np.log(0.5) + np.log(0.75)) / 2
assert abs(result - expected) < 1e-9, f"The correct-class probabilities are 0.5 and 0.75, so the loss is {expected:.4f}, but you returned {result!r}."
assert abs(cross_entropy_from_probs(np.array([[1.0, 0.0]]), [0])) < 1e-9, "A certain correct prediction has zero loss."
--- hint
Pick the probability of the correct class in each row with fancy indexing, take the negative log, and average.
--- hint
`P[np.arange(len(y)), y]`.
```

## Debug the column

This loss is meant to use each text's correct class, but it always reads the first class column.

```python debug id=wrong-column title="Read the correct class for each text"
import numpy as np

P = np.array([[0.1, 0.9], [0.8, 0.2]])
y = np.array([1, 0])
picked = P[:, 0]                       # bug: always the first class, not the correct one
print("picked:", picked)
--- solution
import numpy as np

P = np.array([[0.1, 0.9], [0.8, 0.2]])
y = np.array([1, 0])
picked = P[np.arange(len(y)), y]
print("picked:", picked)
--- test
assert np.allclose(picked, [0.9, 0.8]), f"The correct classes are 1 and 0, so the picked probabilities are [0.9, 0.8], but they are {picked}. Index each row by its own label."
--- hint
Each text has its own label, so the column changes from row to row.
--- hint
`P[np.arange(len(y)), y]` picks one entry per row.
```

## Predict the probability

```python predict id=predict-softmax title="What is the softmax probability of each class when all logits are zero and there are four classes?"
import numpy as np
z = np.zeros(4)
print(round(float(np.exp(z[0]) / np.exp(z).sum()), 2))
--- options
* 0.25
0.5
0.0
1.0
--- explain
With four equal logits every class has probability one quarter.
```
