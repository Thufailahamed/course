At each step the model produces a score, called a logit, for every token in its vocabulary. A softmax turns the scores into probabilities, and the next token is sampled from them. Temperature rescales the scores before the softmax: low values make the choice sharper, and high values make it more random. Top-p limits sampling to the smallest set of tokens that covers most of the probability.

## Softmax at a temperature

Dividing the logits by the temperature before the softmax sharpens the distribution when the temperature is below one.

```python run
import numpy as np

def softmax_temp(logits, T=1.0):
    z = np.asarray(logits, dtype=float) / T
    e = np.exp(z - z.max())
    return e / e.sum()

logits = [2.0, 1.0, 0.1]
for T in [1.0, 0.5, 2.0]:
    print(f"T = {T}: {np.round(softmax_temp(logits, T), 3)}")
```

## Equal logits stay uniform

If every token has the same score, no temperature can prefer one of them.

```python run
print("equal logits:", np.round(softmax_temp([0.0, 0.0, 0.0], 0.3), 3))
```

## Greedy choice

Greedy decoding picks the single most probable token, which is what temperature zero approaches.

```python run
greedy = int(np.argmax(softmax_temp(logits, 1.0)))
print("greedy token index:", greedy)
```

## Top-p keeps the likely tokens

Top-p sorts the tokens by probability and keeps the smallest prefix whose total reaches p. The rest are excluded and the kept mass is renormalized.

```python run
probs = np.array([0.5, 0.3, 0.15, 0.05])
order = np.argsort(-probs)
cum = np.cumsum(probs[order])
keep = order[: int(np.searchsorted(cum, 0.7)) + 1]
mask = np.zeros_like(probs)
mask[keep] = 1
nucleus = probs * mask / (probs * mask).sum()
print("nucleus:", np.round(nucleus, 3))
```

> **Pitfall:** temperature zero is not always deterministic in practice, because hosted models can vary between runs. Test prompts with several samples, not one.

> **In the wild:** teams usually leave top-p near 1 and tune temperature for the task. Extraction and classification prefer low temperatures, and brainstorming prefers higher ones.

## Challenge: softmax at a temperature

```python exercise id=softmax-temp title="Softmax at a temperature"
import numpy as np

# TODO: `softmax_temp(logits, T)` returns the softmax of the logits divided by T, as a numpy array of probabilities.
def softmax_temp(logits, T):
    ...
--- solution
import numpy as np

def softmax_temp(logits, T):
    z = np.asarray(logits, dtype=float) / T
    e = np.exp(z - z.max())
    return e / e.sum()
--- test
import numpy as np
result = softmax_temp([0.0, 0.0], 1.0)
assert result is not None, "Replace the `...` in `softmax_temp` with code that returns the probabilities."
assert np.allclose(result, [0.5, 0.5]), "Equal logits give equal probabilities."
expected = np.exp(np.array([1.0, 0.0]) / 0.5)
expected = expected / expected.sum()
assert np.allclose(softmax_temp([1.0, 0.0], 0.5), expected), "Divide the logits by the temperature before the softmax."
--- hint
Divide by T first, then subtract the maximum for stability before exponentiating.
--- hint
`z = np.asarray(logits, dtype=float) / T`.
```

## Challenge: top-p filter

```python exercise id=top-p title="Keep the nucleus of a distribution"
import numpy as np

# TODO: `top_p_filter(probs, p)` keeps the smallest set of most probable tokens whose total probability reaches p, sets the
# rest to zero, and renormalizes the kept probabilities. Return the array in the original order.
def top_p_filter(probs, p):
    ...
--- solution
import numpy as np

def top_p_filter(probs, p):
    probs = np.asarray(probs, dtype=float)
    order = np.argsort(-probs)
    cum = np.cumsum(probs[order])
    keep = order[: int(np.searchsorted(cum, p)) + 1]
    mask = np.zeros_like(probs)
    mask[keep] = 1
    kept = probs * mask
    return kept / kept.sum()
--- test
import numpy as np
result = top_p_filter([0.5, 0.3, 0.15, 0.05], 0.7)
assert result is not None, "Replace the `...` in `top_p_filter` with code that returns the nucleus."
assert np.allclose(result, [0.625, 0.375, 0.0, 0.0]), f"The two most likely tokens reach 0.8 ≥ 0.7, so they are kept and renormalized to [0.625, 0.375, 0, 0], but you returned {result}."
assert np.allclose(top_p_filter([0.2, 0.8], 0.5), [0.0, 1.0]), "One token can cover the threshold on its own."
--- hint
Sort indices by decreasing probability, take the cumulative sum, and keep up to the first position where it reaches p.
--- hint
`np.searchsorted(cum, p)` gives the number of tokens strictly below p, so keep one more.
```

## Debug: the temperature in the wrong direction

The temperature should divide the logits. This version multiplies them, which flattens the distribution when T is below one.

```python debug id=temp-direction title="Divide the logits by the temperature"
import numpy as np

logits = np.array([2.0, 0.0])
T = 0.5
z = logits * T                               # bug: the temperature should divide
p0 = np.exp(z[0]) / np.exp(z).sum()
print("probability of token 0:", round(float(p0), 5))
--- solution
import numpy as np

logits = np.array([2.0, 0.0])
T = 0.5
z = logits / T
p0 = np.exp(z[0]) / np.exp(z).sum()
print("probability of token 0:", round(float(p0), 5))
--- test
expected = np.exp(4.0) / (np.exp(4.0) + 1.0)
assert abs(p0 - expected) < 1e-4, f"Dividing by 0.5 gives logits [4, 0], so token 0 has probability {expected:.5f}, but the code gives {p0:.5f}. Divide by T."
--- hint
A temperature below one should make the top token more likely, so the logits must be scaled up.
--- hint
`z = logits / T`.
```

## Predict the uniform distribution

```python predict id=predict-uniform title="What is the probability of the first token when two logits are both zero and T is 2?"
import numpy as np
z = np.zeros(2) / 2.0
print(round(float(np.exp(z[0]) / np.exp(z).sum()), 2))
--- options
* 0.5
0.27
0.73
1.0
--- explain
Equal logits remain equal at any temperature, so the two tokens share the probability equally.
```

## Recap

- Logits become probabilities through a softmax, and temperature divides the logits first.
- Top-p restricts sampling to the nucleus of likely tokens, then renormalizes.
- Choose sampling settings for the task, and test them with more than one sample.

**Up next:** prompts, and how to budget what goes into one.
