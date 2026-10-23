A trained model outputs a distribution over the next token, and generating text means choosing from it. Greedy decoding always picks the most likely token, which is safe but repetitive. Sampling draws from the distribution, which is more varied. **Temperature** and **top-k** control how adventurous the sampling is. Generating one token at a time also has a cost: each step would recompute attention over the whole past. A **KV-cache** stores the keys and values of past tokens so that each new step does only the new work.

## Temperature

Dividing the logits by a temperature $T$ before the softmax sharpens the distribution when $T < 1$ and flattens it when $T > 1$.

$$
p_i = \frac{e^{z_i / T}}{\sum_j e^{z_j / T}}
$$

```python run
import numpy as np

def probs_at_temperature(logits, T):
    z = np.asarray(logits, dtype=float) / T
    e = np.exp(z - z.max())
    return e / e.sum()

logits = np.array([2.0, 1.0, 0.0])
for T in [0.5, 1.0, 2.0]:
    print(f"temperature {T}: {np.round(probs_at_temperature(logits, T), 3)}")
```

At low temperature the most likely token dominates. At high temperature the choices become nearly equal, and the text becomes less coherent.

## Top-k

Top-k sampling keeps only the $k$ most likely tokens, sets the rest to zero probability, and renormalizes. It removes the long tail of unlikely tokens that occasionally derail generation.

```python run
def top_k_probs(logits, k, T=1.0):
    z = np.asarray(logits, dtype=float) / T
    keep = np.argsort(z)[-k:]
    masked = np.full_like(z, -np.inf)
    masked[keep] = z[keep]
    e = np.exp(masked - masked.max())
    return e / e.sum()

print("top-2 of the logits above:", np.round(top_k_probs(logits, 2), 3))
```

## The KV-cache

In a causal model, the keys and values of a token never change once computed. Generating token $t$ needs the keys and values of all earlier tokens, so storing them means each step computes only the new token's query, key and value.

```python run
rng = np.random.default_rng(0)
d = 4
Wq, Wk, Wv = (rng.normal(0, 0.5, (d, d)) for _ in range(3))
x = rng.normal(size=(5, d))                      # five tokens arrive one at a time

def attend(q, K, V):
    s = K @ q / np.sqrt(d)
    e = np.exp(s - s.max())
    return (e / e.sum()) @ V

K_cache, V_cache, outputs = [], [], []
for t in range(5):
    K_cache.append(x[t] @ Wk)                    # compute only the new key and value
    V_cache.append(x[t] @ Wv)
    outputs.append(attend(x[t] @ Wq, np.array(K_cache), np.array(V_cache)))

full = []
Kf, Vf = x @ Wk, x @ Wv
for t in range(5):
    full.append(attend(x[t] @ Wq, Kf[: t + 1], Vf[: t + 1]))
print("cached and full computation agree:", np.allclose(outputs, full))
```

The cached and recomputed outputs are identical, but the cached version does one key and one value per step rather than recomputing them all.

> **In the wild:** every serving system for language models keeps a KV-cache. Its memory grows with the length of the conversation, which is one reason long contexts are expensive.

> **Pitfall:** temperature must divide the logits, not multiply them. Multiplying flips the effect, sharpening when you wanted flattening.

Sampling from a distribution gives different tokens on each draw. With a low temperature the draws concentrate on the top choice.

```python run
rng_draw = np.random.default_rng(1)
for T in [0.3, 1.5]:
    p_t = probs_at_temperature(logits, T)
    draws = rng_draw.choice(3, size=500, p=p_t)
    print(f"temperature {T}: share of the top token in 500 draws {np.mean(draws == 0):.2f}")
```

## Challenge: temperature probabilities

```python exercise id=temperature-probs title="Probabilities at a temperature"
import numpy as np

# TODO: `temperature_probs(logits, T)` returns the softmax of logits divided by T, computed stably.
def temperature_probs(logits, T):
    ...
--- solution
import numpy as np

def temperature_probs(logits, T):
    z = np.asarray(logits, dtype=float) / T
    e = np.exp(z - z.max())
    return e / e.sum()
--- test
import numpy as np
result = temperature_probs([1.0, 1.0], 1.0)
assert result is not None, "Replace the `...` in `temperature_probs` with code that returns the probabilities."
assert np.allclose(result, [0.5, 0.5]), "Equal logits give equal probabilities at any temperature."
sharp = temperature_probs([2.0, 0.0], 0.5)
assert sharp[0] > temperature_probs([2.0, 0.0], 1.0)[0], "A lower temperature must make the most likely token more likely."
assert abs(sharp[0] - 1 / (1 + np.exp(-4.0))) < 1e-9, "With T = 0.5 the logits become [4, 0], so the first probability is 1 / (1 + e^(−4))."
--- hint
Divide the logits by the temperature first, then apply the stable softmax.
--- hint
`z = np.asarray(logits) / T`, then `e = np.exp(z - z.max())` and normalize.
```

## Challenge: top-k filter

```python exercise id=top-k-filter title="Keep the k largest logits"
import numpy as np

# TODO: `top_k_filter(logits, k)` returns a copy of the logits in which every entry except the k largest is set to −inf.
def top_k_filter(logits, k):
    ...
--- solution
import numpy as np

def top_k_filter(logits, k):
    z = np.asarray(logits, dtype=float)
    out = np.full_like(z, -np.inf)
    keep = np.argsort(z)[-k:]
    out[keep] = z[keep]
    return out
--- test
import numpy as np
result = top_k_filter([0.5, 3.0, 1.0, 2.0], 2)
assert result is not None, "Replace the `...` in `top_k_filter` with code that returns the filtered logits."
assert result[1] == 3.0 and result[3] == 2.0, "The two largest logits, 3 and 2, must be kept."
assert result[0] == -np.inf and result[2] == -np.inf, "All other logits must become minus infinity."
assert np.isfinite(result).sum() == 2, "Exactly k values should remain finite."
--- hint
Find the indices of the k largest values with `np.argsort`, then copy only those into an array of minus infinities.
--- hint
`keep = np.argsort(z)[-k:]`, then `out[keep] = z[keep]`.
```

## Debug the temperature direction

This sampler is meant to sharpen the distribution at low temperature, but it multiplies the logits by the temperature instead of dividing, so the effect is reversed.

```python debug id=temperature-direction title="Divide by the temperature"
import numpy as np

logits = np.array([2.0, 0.0])
T = 0.5
z = logits * T                              # bug: the temperature divides the logits
e = np.exp(z - z.max())
probs = e / e.sum()
print("probabilities:", np.round(probs, 3))
--- solution
import numpy as np

logits = np.array([2.0, 0.0])
T = 0.5
z = logits / T
e = np.exp(z - z.max())
probs = e / e.sum()
print("probabilities:", np.round(probs, 3))
--- test
assert probs[0] > 0.98, f"At temperature 0.5 the top token should dominate, with probability near 0.98, but it is {probs[0]:.3f}. Divide the logits by the temperature."
--- hint
Lower temperature should make the favourite stronger, which means the logits must grow when divided by a small number.
--- hint
Use `logits / T`.
```

## Predict the top-k result

```python predict id=predict-topk title="How many tokens keep a non-zero probability with top-2 sampling over five tokens?"
print(2)
--- options
* 2
5
1
3
--- explain
Top-k keeps exactly k tokens, the two most likely, and gives the rest zero probability. Two tokens keep non-zero probability.

```