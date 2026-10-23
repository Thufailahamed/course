Language models learn by predicting the next token. Every position in a sequence gives one training example: the input is the tokens so far, and the target is the token that follows. The loss is the cross-entropy between the model's predicted distribution and the true next token, averaged over all positions. Nothing else about training is special, and the simplicity is a large part of its power.

## Shifting the targets

Given the tokens of a sentence, the inputs are everything except the last token, and the targets are everything except the first. Position $t$ is trained to predict token $t + 1$.

```python run
import numpy as np

tokens = np.array([5, 2, 9, 4, 1])
inputs, targets = tokens[:-1], tokens[1:]
for i, t in zip(inputs, targets):
    print(f"given {i}, the next token should be {t}")
```

Predicting the token you were given would be trivial, so the shift is what turns copying into learning.

## Cross-entropy over the vocabulary

For one position, the model outputs logits, one score per vocabulary entry. The loss is the negative log of the probability assigned to the correct token:

$$
\mathcal{L} = -\log \frac{e^{z_y}}{\sum_j e^{z_j}} = \operatorname{logsumexp}(z) - z_y
$$

```python run
def cross_entropy(logits, target):
    m = logits.max()
    lse = m + np.log(np.exp(logits - m).sum())
    return lse - logits[target]

logits = np.array([2.0, 0.5, -1.0])
print("loss if the true token is 0:", round(cross_entropy(logits, 0), 4))
print("loss if the true token is 2:", round(cross_entropy(logits, 2), 4))
print("uniform guess over 3 tokens:", round(np.log(3), 4))
```

A confident correct prediction has a small loss. A uniform guess over a vocabulary of size $V$ costs $\log V$, which is the baseline a trained model must beat.

## Perplexity

The average loss in nats can be read as perplexity, $e^{\mathcal{L}}$: roughly how many equally likely choices the model is torn between. A uniform model over a vocabulary of 50 has perplexity 50.

```python run
print("perplexity of a uniform model over 50 tokens:", round(float(np.exp(np.log(50))), 2))
```

> **Pitfall:** the loss must average over positions, not sum them, or long sequences dominate the update. Frameworks do this for you, but when you write a loss yourself, check its scale.

> **In the wild:** almost every language model in production is trained with exactly this objective, on trillions of tokens.

A randomly initialized model is close to uniform, so its loss starts near the log of the vocabulary size. Check that at initialization.

```python run
rng_init = np.random.default_rng(0)
V_init = 50
random_logits = rng_init.normal(0, 0.01, (4, V_init))
random_targets = rng_init.integers(0, V_init, 4)
print("loss at initialization:", round(float(np.mean([cross_entropy(random_logits[i], random_targets[i]) for i in range(4)])), 3))
print("log of the vocabulary size:", round(float(np.log(V_init)), 3))
```

## Challenge: the next-token pairs

```python exercise id=next-pairs title="Shift a sequence into inputs and targets"
import numpy as np

# TODO: `next_token_pairs(tokens)` returns a tuple (inputs, targets), where inputs holds every token except the last
# and targets holds every token except the first.
def next_token_pairs(tokens):
    ...
--- solution
import numpy as np

def next_token_pairs(tokens):
    tokens = np.asarray(tokens)
    return tokens[:-1], tokens[1:]
--- test
import numpy as np
inputs, targets = next_token_pairs([7, 3, 5])
assert inputs is not None, "Replace the `...` in `next_token_pairs` with code that returns (inputs, targets)."
assert list(inputs) == [7, 3], f"The inputs should be the tokens without the last one, [7, 3], but you returned {list(inputs)}."
assert list(targets) == [3, 5], f"The targets should be the tokens without the first one, [3, 5], but you returned {list(targets)}."
--- hint
Slice the array twice: once to drop the last element and once to drop the first.
--- hint
`return tokens[:-1], tokens[1:]`.
```

## Challenge: mean cross-entropy

```python exercise id=mean-ce title="Average cross-entropy over positions"
import numpy as np

# TODO: `mean_cross_entropy(logits, targets)` takes a (positions, vocabulary) array of logits and an array of target
# indices. It returns the average over positions of logsumexp(row) − row[target], computed stably.
def mean_cross_entropy(logits, targets):
    ...
--- solution
import numpy as np

def mean_cross_entropy(logits, targets):
    logits = np.asarray(logits, dtype=float)
    targets = np.asarray(targets)
    m = logits.max(axis=1, keepdims=True)
    lse = (m + np.log(np.exp(logits - m).sum(axis=1, keepdims=True))).ravel()
    return float(np.mean(lse - logits[np.arange(len(targets)), targets]))
--- test
import numpy as np
result = mean_cross_entropy(np.zeros((2, 3)), [0, 2])
assert result is not None, "Replace the `...` in `mean_cross_entropy` with code that returns the loss."
assert abs(result - np.log(3)) < 1e-9, f"Uniform logits over three tokens cost log 3 per position, so the mean is log 3 ≈ 1.0986, but you returned {result!r}."
big = mean_cross_entropy(np.array([[1000.0, 0.0]]), [0])
assert abs(big) < 1e-9, "A confident correct prediction with huge logits should cost almost nothing, without overflow."
--- hint
Subtract each row's maximum before the exponential, then pick out the logit of each target with fancy indexing.
--- hint
`logits[np.arange(len(targets)), targets]` picks one entry per row.
```

## Debug the shift

This training setup is meant to predict the next token, but it uses the same tokens as inputs and targets, so the model is asked to copy its input.

```python debug id=no-shift title="Predict the next token, not the current one"
import numpy as np

tokens = np.array([5, 2, 9, 4, 1])
inputs, targets = tokens[:-1], tokens[:-1]     # bug: the targets should be shifted by one position
print("inputs:", inputs, "targets:", targets)
--- solution
import numpy as np

tokens = np.array([5, 2, 9, 4, 1])
inputs, targets = tokens[:-1], tokens[1:]
print("inputs:", inputs, "targets:", targets)
--- test
assert list(targets) == [2, 9, 4, 1], f"The target for each input is the next token, so targets should be [2, 9, 4, 1], but they are {list(targets)}."
--- hint
The target at position t is the token at position t + 1.
--- hint
Start the targets at the second token: `tokens[1:]`.
```

## Predict the loss

```python predict id=predict-ce title="What is the cross-entropy of a uniform guess over four tokens?"
import numpy as np
print(round(float(np.log(4)), 3))
--- options
* 1.386
0.25
4.0
2.0
--- explain
A uniform guess gives each of the four tokens probability one quarter, and the negative log of that is log 4 ≈ 1.386.
```

## Recap

- Each position in a sequence is one training example: predict the next token from the tokens before it.
- Targets are the inputs shifted by one position.
- Cross-entropy is logsumexp of the logits minus the logit of the true token, averaged over positions.
- Perplexity is the exponential of the loss, and a uniform model's perplexity is the vocabulary size.

**Up next:** learning-rate schedules and gradient accumulation, the training knobs that make large models trainable.
