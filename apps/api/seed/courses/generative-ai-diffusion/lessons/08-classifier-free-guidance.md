Conditioning alone tends to produce samples that are plausible but timid. Classifier-free guidance strengthens the conditioning without a separate classifier. The same network is trained with the prompt sometimes dropped, so it can predict noise with and without the condition. At sampling time the two predictions are combined, and a scale w controls how far the sample is pushed toward the prompt.

## The guidance formula

The guided noise is ε_u + w (ε_c − ε_u). At w = 0 it is the unconditional prediction, and at w = 1 it is the conditional one. Larger values extrapolate beyond the conditional prediction.

```python run
import numpy as np

eps_u = np.array([0.2, -0.1])     # unconditional prediction
eps_c = np.array([0.5, 0.3])      # conditional prediction
for w in [0.0, 1.0, 3.0, 7.5]:
    guided = eps_u + w * (eps_c - eps_u)
    print(f"w = {w}: {np.round(guided, 3)}")
```

## Dropping the condition during training

During training the prompt is replaced with a null embedding at a fixed rate, so the same network learns both predictions.

```python run
rng = np.random.default_rng(7)
drop_rate = 0.1
dropped = rng.random(10000) < drop_rate
print("share of training examples with the prompt dropped:", round(float(dropped.mean()), 3))
```

## Guidance grows the step

The magnitude of the guided prediction grows with the scale, which is one reason large scales oversaturate images.

```python run
for w in [1.0, 4.0, 7.5]:
    guided = eps_u + w * (eps_c - eps_u)
    print(f"w = {w}: norm {np.linalg.norm(guided):.3f}")
```

## Diversity and fidelity

A toy comparison of two spreads shows the trade-off: high guidance concentrates the samples and reduces their diversity.

```python run
samples_u = rng.normal(0.0, 1.0, 5000)
samples_c = rng.normal(1.0, 1.0, 5000)
for w in [1.0, 3.0]:
    guided = samples_u + w * (samples_c - samples_u)
    print(f"w = {w}: mean {guided.mean():.2f}, spread {guided.std():.2f}")
```

> **Pitfall:** a very high guidance scale gives oversaturated colours and distorted shapes. Typical values sit between roughly 3 and 10, and the right one depends on the model and sampler.

> **In the wild:** every text-to-image service exposes a guidance scale, which is the knob that trades faithfulness to the prompt against variety.

## Challenge: guided noise

```python exercise id=cfg title="Combine unconditional and conditional predictions"
# TODO: `cfg(eps_u, eps_c, w)` returns eps_u + w × (eps_c − eps_u).
def cfg(eps_u, eps_c, w):
    ...
--- solution
def cfg(eps_u, eps_c, w):
    return eps_u + w * (eps_c - eps_u)
--- test
result = cfg(0.2, 0.5, 3.0)
assert result is not None, "Replace the `...` in `cfg` with code that returns the guided value."
assert abs(result - 1.1) < 1e-9, f"0.2 + 3 × (0.5 − 0.2) = 1.1, but you returned {result}."
assert abs(cfg(0.2, 0.5, 0.0) - 0.2) < 1e-9, "With w = 0 the result is the unconditional prediction."
assert abs(cfg(0.2, 0.5, 1.0) - 0.5) < 1e-9, "With w = 1 the result is the conditional prediction."
--- hint
Subtract the unconditional prediction from the conditional one, scale by w, and add the unconditional prediction back.
--- hint
`eps_u + w * (eps_c - eps_u)`.
```

## Challenge: a guidance sweep

```python exercise id=cfg-sweep title="Guided values for several scales"
# TODO: `cfg_sweep(eps_u, eps_c, scales)` returns a list with cfg(eps_u, eps_c, w) for each w in scales. The function cfg is
# provided.
def cfg(eps_u, eps_c, w):
    return eps_u + w * (eps_c - eps_u)

def cfg_sweep(eps_u, eps_c, scales):
    ...
--- solution
def cfg(eps_u, eps_c, w):
    return eps_u + w * (eps_c - eps_u)

def cfg_sweep(eps_u, eps_c, scales):
    return [cfg(eps_u, eps_c, w) for w in scales]
--- test
result = cfg_sweep(0.0, 1.0, [0.0, 1.0, 2.0])
assert result is not None, "Replace the `...` in `cfg_sweep` with code that returns the list."
assert result == [0.0, 1.0, 2.0], f"With eps_u = 0 and eps_c = 1 the guided value equals w, so the list should be [0, 1, 2], but you returned {result}."
--- hint
A list comprehension over `scales` is enough.
--- hint
`[cfg(eps_u, eps_c, w) for w in scales]`.
```

## Debug: missing unconditional term

The guided value should start from the unconditional prediction, but the code drops that term.

```python debug id=cfg-missing-uncond title="Keep the unconditional term"
eps_u, eps_c, w = 0.3, 0.8, 0.0
guided = w * eps_c                  # bug: the unconditional term is missing
print("guided:", guided)
--- solution
eps_u, eps_c, w = 0.3, 0.8, 0.0
guided = eps_u + w * (eps_c - eps_u)
print("guided:", guided)
--- test
assert abs(guided - eps_u) < 1e-9, f"With w = 0 the guided value must be the unconditional prediction, 0.3, but the code gives {guided}. Keep the eps_u term."
--- hint
At w = 0 the output should not depend on the condition at all.
--- hint
Start the formula from `eps_u`.
```

## Predict the guided value

```python predict id=predict-cfg title="What is the guided value when eps_u = 0, eps_c = 1 and w = 7.5?"
print(0 + 7.5 * (1 - 0))
--- options
* 7.5
1.0
0.0
8.5
--- explain
The guided value is eps_u + w × (eps_c − eps_u) = 0 + 7.5 × 1 = 7.5.
```

## Recap

- Classifier-free guidance uses one network trained with the condition sometimes dropped.
- The guided prediction is ε_u + w (ε_c − ε_u), and w sets how strongly the prompt is followed.
- High scales improve fidelity and cost diversity, so the scale is a tuning choice.

**Up next:** latent diffusion, which runs all of this in a compressed space.
