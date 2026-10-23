This is the capstone. You will assemble the components from this course into a small language model, and then judge it the way a careful practitioner would: against a simple baseline, using perplexity on text the model did not see, and with a check that the model learned something rather than memorized.

Full training of a transformer needs an automatic-differentiation engine, which is shown as PyTorch code for you to run locally. Here you will build the model's forward pass and evaluation in NumPy, using the weights of a small model, and compare it with a bigram baseline that counts word pairs.

## The corpus

```python run
import numpy as np

train_text = "the cat sat on the mat the dog sat on the log the cat saw the dog"
test_text = "the dog sat on the mat the cat saw the log"
vocab = sorted(set(train_text.split()))
word_to_id = {w: i for i, w in enumerate(vocab)}
train_ids = np.array([word_to_id[w] for w in train_text.split()])
test_ids = np.array([word_to_id[w] for w in test_text.split()])
print("vocabulary size:", len(vocab), "| training tokens:", len(train_ids), "| test tokens:", len(test_ids))
```

## A bigram baseline

A bigram model predicts the next word from the previous word alone, using counts with add-one smoothing so that unseen pairs keep a little probability.

```python run
V = len(vocab)
counts = np.zeros((V, V))
for a, b in zip(train_ids[:-1], train_ids[1:]):
    counts[a, b] += 1

def bigram_prob(a, b):
    return (counts[a, b] + 1) / (counts[a].sum() + V)

test_logprobs = [np.log(bigram_prob(a, b)) for a, b in zip(test_ids[:-1], test_ids[1:])]
print("bigram test perplexity:", round(float(np.exp(-np.mean(test_logprobs))), 3))
```

## An untrained transformer

A transformer with random weights should be no better than guessing among the vocabulary, so its perplexity is close to the vocabulary size. That number is the floor a trained model must beat.

```python run
rng = np.random.default_rng(0)
d = 8
E = rng.normal(0, 0.1, (V, d))
P = rng.normal(0, 0.1, (32, d))
Wq, Wk, Wv = (rng.normal(0, 0.3, (d, d)) for _ in range(3))

def layer_norm(x):
    return (x - x.mean(axis=-1, keepdims=True)) / np.sqrt(x.var(axis=-1, keepdims=True) + 1e-5)

def causal_attention(x):
    Q, K, Vv = x @ Wq, x @ Wk, x @ Wv
    s = Q @ K.T / np.sqrt(d)
    s = np.where(np.triu(np.ones_like(s, dtype=bool), k=1), -np.inf, s)
    e = np.exp(s - s.max(axis=-1, keepdims=True))
    return (e / e.sum(axis=-1, keepdims=True)) @ Vv

def model_logits(ids):
    x = E[ids] + P[:len(ids)]
    x = x + causal_attention(layer_norm(x))
    return layer_norm(x) @ E.T

def log_softmax(z):
    m = z.max(axis=-1, keepdims=True)
    return z - m - np.log(np.exp(z - m).sum(axis=-1, keepdims=True))

logp = log_softmax(model_logits(test_ids))
targets = test_ids[1:]
untrained = -np.mean(logp[:-1][np.arange(len(targets)), targets])
print("untrained transformer perplexity:", round(float(np.exp(untrained)), 3), "| vocabulary size:", V)
```

## Judge the result honestly

A model that scores better than the baseline on the training text but not on the test text has memorized. The honest comparison uses only the test text, and the report states both numbers and the gap.

```python run
print("bigram test perplexity:", round(float(np.exp(-np.mean(test_logprobs))), 2))
print("untrained transformer:", round(float(np.exp(untrained)), 2))
print("a trained model must beat the bigram on text it has never seen to be worth using")
```

> **In the wild:** language-model evaluation reports perplexity or accuracy on held-out corpora, compared with simple baselines, and checks for contamination of the test set with training text.

## Challenge: perplexity from log probabilities

```python exercise id=perplexity title="Perplexity from log probabilities"
import numpy as np

# TODO: `perplexity(logprobs)` takes a list of natural-log probabilities, one per predicted token, and returns the
# perplexity, exp of the negative mean.
def perplexity(logprobs):
    ...
--- solution
import numpy as np

def perplexity(logprobs):
    return float(np.exp(-np.mean(np.asarray(logprobs, dtype=float))))
--- test
import numpy as np
result = perplexity([np.log(0.5), np.log(0.5)])
assert result is not None, "Replace the `...` in `perplexity` with code that returns the perplexity."
assert abs(result - 2.0) < 1e-9, f"Every token has probability one half, so the perplexity is 2, but you returned {result!r}."
assert abs(perplexity([np.log(0.25)] * 3) - 4.0) < 1e-9, "A probability of one quarter per token gives perplexity 4."
--- hint
Take the mean of the log probabilities, negate it, and exponentiate.
--- hint
`np.exp(-np.mean(logprobs))`.
```

## Challenge: smoothed bigram probability

```python exercise id=bigram-smooth title="Add-one smoothed bigram probability"
import numpy as np

# TODO: `bigram_prob(counts, a, b)` returns the add-one smoothed probability of word b after word a: (count[a, b] + 1)
# divided by (the total count in row a + the number of columns). Use the counts matrix as given.
def bigram_prob(counts, a, b):
    ...
--- solution
import numpy as np

def bigram_prob(counts, a, b):
    counts = np.asarray(counts, dtype=float)
    return (counts[a, b] + 1) / (counts[a].sum() + counts.shape[1])
--- test
import numpy as np
counts_t = np.array([[0.0, 3.0], [1.0, 0.0]])
assert abs(bigram_prob(counts_t, 0, 1) - 4 / 5) < 1e-9, "Row 0 has total 3 and two columns, so P(1 | 0) = (3 + 1) / (3 + 2) = 0.8."
assert abs(bigram_prob(counts_t, 0, 0) - 1 / 5) < 1e-9, "An unseen pair keeps probability (0 + 1) / 5 = 0.2."
assert bigram_prob(counts_t, 1, 0) > 0, "Smoothing keeps every probability above zero."
--- hint
Add one to the count of the pair, and add the number of columns to the row total.
--- hint
`(counts[a, b] + 1) / (counts[a].sum() + counts.shape[1])`.
```

## Debug the smoothing

This bigram probability is meant to be smoothed, but it omits the add-one, so an unseen pair gets probability zero and the log is infinite.

```python debug id=no-smoothing title="Smooth unseen pairs"
import numpy as np

counts = np.array([[0.0, 3.0], [1.0, 0.0]])
p = counts[0, 0] / counts[0].sum()          # bug: no smoothing, so the unseen pair has probability 0
print("probability:", p, "| log:", np.log(p) if p > 0 else "-inf")
--- solution
import numpy as np

counts = np.array([[0.0, 3.0], [1.0, 0.0]])
p = (counts[0, 0] + 1) / (counts[0].sum() + counts.shape[1])
print("probability:", p, "| log:", np.log(p))
--- test
assert p > 0, "An unseen pair needs a smoothed, positive probability, or its log is minus infinity. Add one to the count and the number of columns to the total."
--- hint
Add-one smoothing adds one to every count.
--- hint
`(counts[0, 0] + 1) / (counts[0].sum() + 2)`.
```

## Predict the baseline

```python predict id=predict-capstone title="What is the perplexity of a uniform model over four words?"
import numpy as np
print(float(np.exp(-np.mean(np.log(np.full(5, 0.25))))))
--- options
* 4.0
0.25
1.0
5.0
--- explain
A uniform model gives each of the four words probability one quarter, and the perplexity of a uniform model is the number of words, four.

```