Sampling starts from pure noise and applies the learned reversal one step at a time, from the last step to the first. Each step removes a fraction of the predicted noise and adds back a small amount of fresh noise, which keeps the samples diverse. This is the DDPM ancestral sampler, and its update is a simple formula built from the schedule and the network output.

## The reverse mean

The DDPM mean for the previous step is (x_t − β_t / sqrt(1 − abar_t) × ε̂) / sqrt(α_t).

```python run
import numpy as np

def ddpm_mean(x_t, eps_hat, alpha, abar, beta):
    return (x_t - beta / np.sqrt(1 - abar) * eps_hat) / np.sqrt(alpha)

print("mean with zero predicted noise:", round(float(ddpm_mean(2.0, 0.0, 0.5, 0.5, 0.5)), 4))
print("mean with predicted noise 1:", round(float(ddpm_mean(1.0, 1.0, 0.5, 0.75, 0.5)), 4))
```

## A full reverse loop

The loop below runs the sampler with a placeholder noise predictor that always returns zero. The output shows that the model's predictions drive the result.

```python run
T = 10
betas = np.linspace(1e-4, 0.2, T)
alphas = 1 - betas
abars = np.cumprod(alphas)
rng = np.random.default_rng(6)
x = rng.normal(size=5)
for t in reversed(range(T)):
    eps_hat = np.zeros_like(x)                 # a placeholder model
    mean = ddpm_mean(x, eps_hat, alphas[t], abars[t], betas[t])
    noise = rng.normal(size=5) if t > 0 else 0.0
    x = mean + np.sqrt(betas[t]) * noise
print("final samples:", np.round(x, 3))
```

## The noise scale at each step

Each step adds noise with scale sqrt(beta). The last step is the exception, because it adds none.

```python run
print("noise scale per step:", np.round(np.sqrt(betas), 4))
```

## How many steps

A sampler with T steps needs T network evaluations, which is why sampling is slow compared with a GAN.

```python run
for T_try in [50, 200, 1000]:
    print(f"{T_try} steps means {T_try} network calls per image")
```

> **Pitfall:** a sampler that adds noise at the last step produces grainy images. Skipping noise at t = 0 is part of the algorithm, not an optimization.

> **In the wild:** modern samplers use far fewer steps than the training schedule, with ODE solvers or distilled models, because each network call is expensive.

## Challenge: the reverse mean

```python exercise id=ddpm-mean title="One reverse step of the DDPM sampler"
import numpy as np

# TODO: `ddpm_mean(x_t, eps_hat, alpha, abar, beta)` returns (x_t − beta / sqrt(1 − abar) × eps_hat) / sqrt(alpha).
def ddpm_mean(x_t, eps_hat, alpha, abar, beta):
    ...
--- solution
import numpy as np

def ddpm_mean(x_t, eps_hat, alpha, abar, beta):
    return (x_t - beta / np.sqrt(1 - abar) * eps_hat) / np.sqrt(alpha)
--- test
import numpy as np
result = ddpm_mean(1.0, 1.0, 0.5, 0.75, 0.5)
assert result is not None, "Replace the `...` in `ddpm_mean` with code that returns the mean."
assert abs(result) < 1e-9, f"beta / sqrt(1 − abar) = 0.5 / 0.5 = 1, so the result is (1 − 1) / sqrt(0.5) = 0, but you returned {result}."
assert abs(ddpm_mean(2.0, 0.0, 0.5, 0.5, 0.5) - 2.0 / np.sqrt(0.5)) < 1e-9, "With zero predicted noise the mean is x_t divided by sqrt(alpha)."
--- hint
Compute the scaled noise term first, subtract it from x_t, then divide by sqrt(alpha).
--- hint
`(x_t - beta / np.sqrt(1 - abar) * eps_hat) / np.sqrt(alpha)`.
```

## Challenge: step schedule

```python exercise id=sample-steps title="Evenly spaced timesteps for sampling"
import numpy as np

# TODO: `sample_steps(T, n)` returns n integer timesteps from T − 1 down to 0, evenly spaced and including both ends.
def sample_steps(T, n):
    ...
--- solution
import numpy as np

def sample_steps(T, n):
    return np.linspace(T - 1, 0, n).round().astype(int)
--- test
result = sample_steps(10, 4)
assert result is not None, "Replace the `...` in `sample_steps` with code that returns the timesteps."
assert result.tolist() == [9, 6, 3, 0], f"Four steps from 9 to 0 are [9, 6, 3, 0], but you returned {result.tolist()}."
--- hint
`np.linspace` gives evenly spaced floats, which you then round to integers.
--- hint
`np.linspace(T - 1, 0, n).round().astype(int)`.
```

## Debug: the wrong order of steps

The reverse process must visit the timesteps from the last one to the first, but this loop visits them in increasing order.

```python debug id=step-order title="Run the reverse process from the last step"
T = 5
order = list(range(T))                 # bug: the reverse process starts at the last step
print("visiting order:", order)
--- solution
T = 5
order = list(reversed(range(T)))
print("visiting order:", order)
--- test
assert order == [4, 3, 2, 1, 0], f"The reverse process runs from step 4 down to 0, but the order is {order}. Use reversed(range(T))."
--- hint
Noise is removed from the most noisy step first.
--- hint
`list(reversed(range(T)))`.
```

## Predict the step size

```python predict id=predict-mean title="What is the reverse mean of x_t = 2 with zero predicted noise and alpha 0.5, to two decimals?"
import numpy as np
print(round(2 / np.sqrt(0.5), 2))
--- options
* 2.83
1.41
4.0
2.0
--- explain
With zero predicted noise the mean is x_t divided by sqrt(alpha), which is 2 divided by sqrt(0.5), about 2.83.
```

## Recap

- DDPM sampling runs the reverse process from the most noisy step to the clean one.
- Each step applies the reverse mean, and adds noise except at the final step.
- The number of steps sets the cost, one network call per step.

**Up next:** noise schedules, and DDIM, which samples deterministically with fewer steps.
