The linear schedule is simple, but it wastes steps at low noise and overloads high noise. A cosine schedule spreads the signal more evenly across steps. DDIM goes further: it turns the sampler into a deterministic mapping from noise to image, so a sample can be produced in far fewer steps. This lesson builds both.

## Linear versus cosine

The cosine schedule defines alpha-bar directly from a cosine curve, which keeps the signal-to-noise ratio decreasing smoothly.

```python run
import numpy as np

def cosine_alpha_bar(t, T, s=0.008):
    f = lambda u: np.cos((u / T + s) / (1 + s) * np.pi / 2) ** 2
    return f(t) / f(0)

T = 100
linear_betas = np.linspace(1e-4, 0.02, T)
linear_abar = np.cumprod(1 - linear_betas)
for t in [10, 50, 90]:
    print(f"step {t}: linear {linear_abar[t]:.4f}, cosine {cosine_alpha_bar(t, T):.4f}")
```

The cosine schedule keeps more signal at the middle steps, where the linear schedule has already added a lot of noise.

## Signal-to-noise ratio

The ratio of signal to noise at each step is alpha-bar over one minus alpha-bar. It falls steadily as t grows.

```python run
snr = linear_abar / (1 - linear_abar)
print("linear SNR at steps 0, 50 and 99:", np.round(snr[[0, 50, 99]], 2))
```

## A deterministic DDIM step

DDIM first estimates x_0 from the noise prediction, then moves to the previous noise level with the same noise. With no fresh noise, the mapping is deterministic.

```python run
def ddim_step(x_t, eps, abar_t, abar_prev):
    x0 = (x_t - np.sqrt(1 - abar_t) * eps) / np.sqrt(abar_t)
    return np.sqrt(abar_prev) * x0 + np.sqrt(1 - abar_prev) * eps

x_t = np.array([0.8])
eps = np.array([0.3])
print("DDIM step:", np.round(ddim_step(x_t, eps, 0.5, 0.7), 4))
```

## Fewer steps, same model

Because DDIM is deterministic, it can skip steps. The sampler runs on a subset of the training timesteps.

```python run
steps = np.linspace(T - 1, 0, 10).round().astype(int)
print("ten DDIM timesteps out of 100:", steps)
```

> **Pitfall:** DDIM with more steps is not always better. Beyond a point, sample quality flattens while the cost keeps rising, so pick the step count by measuring quality, not by default.

> **In the wild:** most deployed diffusion services use a few dozen steps with a fast solver, because the cost of sampling is what users pay for.

## Challenge: cosine alpha-bar

```python exercise id=cosine-abar title="Cosine noise schedule"
import numpy as np

# TODO: `cosine_alpha_bar(t, T, s=0.008)` returns cos((t / T + s) / (1 + s) × π / 2)² divided by the same value at t = 0.
def cosine_alpha_bar(t, T, s=0.008):
    ...
--- solution
import numpy as np

def cosine_alpha_bar(t, T, s=0.008):
    f = lambda u: np.cos((u / T + s) / (1 + s) * np.pi / 2) ** 2
    return f(t) / f(0)
--- test
result = cosine_alpha_bar(0, 100)
assert result is not None, "Replace the `...` in `cosine_alpha_bar` with code that returns the value."
assert abs(result - 1.0) < 1e-9, "At step zero the schedule is normalized to one."
assert cosine_alpha_bar(100, 100) < 1e-6, "At the last step the signal is essentially gone."
--- hint
Write the cosine formula as a helper and divide by its value at zero.
--- hint
`f = lambda u: np.cos((u / T + s) / (1 + s) * np.pi / 2) ** 2` and `return f(t) / f(0)`.
```

## Challenge: DDIM step

```python exercise id=ddim-step title="One deterministic DDIM step"
import numpy as np

# TODO: `ddim_step(x_t, eps, abar_t, abar_prev)` estimates x_0 as (x_t − sqrt(1 − abar_t) × eps) / sqrt(abar_t), then returns
# sqrt(abar_prev) × x_0 + sqrt(1 − abar_prev) × eps.
def ddim_step(x_t, eps, abar_t, abar_prev):
    ...
--- solution
import numpy as np

def ddim_step(x_t, eps, abar_t, abar_prev):
    x0 = (x_t - np.sqrt(1 - abar_t) * eps) / np.sqrt(abar_t)
    return np.sqrt(abar_prev) * x0 + np.sqrt(1 - abar_prev) * eps
--- test
import numpy as np
result = ddim_step(np.array([1.0]), np.array([0.5]), 0.5, 0.5)
assert result is not None, "Replace the `...` in `ddim_step` with code that returns the next sample."
assert np.allclose(result, [1.0]), "When the noise level does not change, the step returns x_t."
--- hint
Compute x_0 first, then rebuild x at the previous noise level with the same noise.
--- hint
Both coefficients use `np.sqrt`.
```

## Debug: a cumulative sum instead of a product

Alpha-bar is the cumulative product of the alphas, but the code adds them up.

```python debug id=cumsum-abar title="Alpha-bar is a product, not a sum"
import numpy as np

betas = np.array([0.1, 0.1, 0.1])
alpha_bar = np.cumsum(1 - betas)        # bug: alpha-bar multiplies the alphas
print("alpha-bar:", np.round(alpha_bar, 4))
--- solution
import numpy as np

betas = np.array([0.1, 0.1, 0.1])
alpha_bar = np.cumprod(1 - betas)
print("alpha-bar:", np.round(alpha_bar, 4))
--- test
assert abs(alpha_bar[-1] - 0.729) < 1e-9, f"Three alphas of 0.9 multiply to 0.729, but the code gives {alpha_bar[-1]}. Use a cumulative product."
--- hint
A signal that passes through three steps is multiplied three times.
--- hint
Use `np.cumprod`.
```

## Predict the timesteps

```python predict id=predict-steps title="What are the four evenly spaced timesteps from 9 down to 0?"
import numpy as np
print(np.linspace(9, 0, 4).round().astype(int))
--- options
* [9 6 3 0]
[9 7 5 3]
[9 8 4 0]
[8 6 4 2]
--- explain
Four evenly spaced points from 9 to 0 are 9, 6, 3 and 0.
```

## Recap

- A cosine schedule spreads the signal more evenly than a linear one.
- Signal-to-noise falls with each step, and the schedule controls how fast.
- DDIM gives a deterministic sampler, which can run in far fewer steps.

**Up next:** conditioning the denoiser on a text prompt.
