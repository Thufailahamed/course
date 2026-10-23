The forward process turns a clean image into noise over T steps. At each step a little Gaussian noise is added and the signal is scaled down slightly. The schedule of those small amounts is set in advance, and it determines everything about training. Crucially, the noisy image at any step can be sampled in one shot, without simulating the chain, and this closed form is what makes training fast.

## The per-step noise schedule

Each step t uses a small variance beta_t. Let alpha_t = 1 − beta_t, and let alpha-bar at step t be the product of alpha over all steps up to t.

```python run
import numpy as np

betas = np.linspace(1e-4, 0.02, 10)
alphas = 1 - betas
alpha_bar = np.cumprod(alphas)
print("alpha-bar for 10 steps:", np.round(alpha_bar, 4))
```

Alpha-bar starts near one, meaning the image is almost unchanged, and falls toward zero, meaning the image is almost pure noise.

## The step-by-step process matches the closed form

Iterating one step at a time gives the same alpha-bar as the product formula. The check below confirms it.

```python run
p = 1.0
loop_values = []
for b in betas:
    p *= 1 - b
    loop_values.append(p)
print("step-by-step matches the product:", np.allclose(loop_values, alpha_bar))
```

## Noising an image in one shot

The noisy image at step t is the scaled clean image plus scaled noise, x_t = sqrt(alpha-bar_t) x_0 + sqrt(1 − alpha-bar_t) ε.

```python run
rng = np.random.default_rng(4)
x0 = np.array([1.0, -1.0, 2.0, 0.5])
eps = rng.normal(size=4)
for t in [0, 4, 9]:
    xt = np.sqrt(alpha_bar[t]) * x0 + np.sqrt(1 - alpha_bar[t]) * eps
    print(f"step {t}: alpha-bar {alpha_bar[t]:.3f}, x_t {np.round(xt, 2)}")
```

## Noise at the end

With a full 1000-step schedule the alpha-bar at the last step is tiny, so the sample is almost pure standard normal noise.

```python run
betas_full = np.linspace(1e-4, 0.02, 1000)
abar_end = np.prod(1 - betas_full)
x_T = np.sqrt(1 - abar_end) * rng.normal(size=10000)
print("alpha-bar at the last step:", float(abar_end))
print("variance of the last noisy sample:", round(float(x_T.var()), 3))
```

> **Pitfall:** the scaling factors are square roots, not the alpha-bar values themselves. Mixing them up gives a signal that fades too fast and a training target that is wrong.

> **In the wild:** the schedule is one of the first things to tune when a diffusion model produces grey or washed-out images, because it sets how much of the signal the model sees at each noise level.

## Challenge: alpha-bar

```python exercise id=alpha-bar title="Cumulative product of the alphas"
import numpy as np

# TODO: `alpha_bar(betas)` returns the cumulative product of (1 − beta) over the list of betas, as a numpy array.
def alpha_bar(betas):
    ...
--- solution
import numpy as np

def alpha_bar(betas):
    return np.cumprod(1 - np.asarray(betas, dtype=float))
--- test
import numpy as np
result = alpha_bar([0.1, 0.1])
assert result is not None, "Replace the `...` in `alpha_bar` with code that returns the cumulative product."
assert np.allclose(result, [0.9, 0.81]), f"The alphas are 0.9 and 0.9, so the cumulative product is [0.9, 0.81], but you returned {result}."
--- hint
Take `1 − betas` and then the cumulative product along the only axis.
--- hint
`np.cumprod(1 - np.asarray(betas, dtype=float))`.
```

## Challenge: forward sample

```python exercise id=forward-sample title="Noise a clean value in one step"
import numpy as np

# TODO: `forward_sample(x0, abar_t, eps)` returns sqrt(abar_t) × x0 + sqrt(1 − abar_t) × eps for arrays x0 and eps.
def forward_sample(x0, abar_t, eps):
    ...
--- solution
import numpy as np

def forward_sample(x0, abar_t, eps):
    x0 = np.asarray(x0, dtype=float)
    eps = np.asarray(eps, dtype=float)
    return np.sqrt(abar_t) * x0 + np.sqrt(1 - abar_t) * eps
--- test
import numpy as np
result = forward_sample(np.array([1.0, 2.0]), 1.0, np.array([5.0, 5.0]))
assert result is not None, "Replace the `...` in `forward_sample` with code that returns the noisy sample."
assert np.allclose(result, [1.0, 2.0]), "With alpha-bar 1 there is no noise, so the output is x0."
assert np.allclose(forward_sample(np.array([1.0, 2.0]), 0.0, np.array([5.0, 5.0])), [5.0, 5.0]), "With alpha-bar 0 the output is pure noise."
--- hint
Use `np.sqrt` on both coefficients.
--- hint
`np.sqrt(abar_t) * x0 + np.sqrt(1 - abar_t) * eps`.
```

## Debug: a missing square root

The signal should be scaled by the square root of alpha-bar, but the code uses alpha-bar directly.

```python debug id=signal-scale title="Scale the signal by the square root of alpha-bar"
import numpy as np

abar = 0.25
x0 = np.array([4.0])
eps = np.array([0.0])
xt = abar * x0 + np.sqrt(1 - abar) * eps        # bug: the signal coefficient should be sqrt(abar)
print("x_t:", xt)
--- solution
import numpy as np

abar = 0.25
x0 = np.array([4.0])
eps = np.array([0.0])
xt = np.sqrt(abar) * x0 + np.sqrt(1 - abar) * eps
print("x_t:", xt)
--- test
assert abs(xt[0] - 2.0) < 1e-9, f"The signal should be sqrt(0.25) × 4 = 2, but the code gives {xt[0]}. Use the square root of alpha-bar."
--- hint
sqrt(0.25) is 0.5, not 0.25.
--- hint
Wrap `abar` in `np.sqrt`.
```

## Predict the product

```python predict id=predict-abar title="What is alpha-bar after one step with beta 0.5?"
import numpy as np
print(float(np.cumprod(1 - np.array([0.5]))[-1]))
--- options
* 0.5
0.25
0.75
1.0
--- explain
After one step alpha is 1 − 0.5 = 0.5, and the cumulative product is just that value.
```

## Recap

- The forward process has a closed form, so any noise level is one sample away.
- Alpha-bar is the cumulative product of the per-step alphas.
- The signal is scaled by the square root of alpha-bar, and the noise by the square root of one minus alpha-bar.

**Up next:** training the denoiser to predict the noise.
