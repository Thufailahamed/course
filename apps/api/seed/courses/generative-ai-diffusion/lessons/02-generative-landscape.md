A generative model learns a distribution over examples and can draw new ones from it. Three families dominate image generation. Variational autoencoders compress images to a latent space and decode samples from it. Generative adversarial networks train a generator against a discriminator. Diffusion models learn to reverse noise, which makes training stable and sampling controllable. This lesson uses a two-cluster toy dataset to see what "learning a distribution" means in practice.

## A two-cluster dataset

Real data often has several modes. This toy dataset draws from two Gaussian clusters with different weights.

```python run
import numpy as np

rng = np.random.default_rng(3)
weights = np.array([0.3, 0.7])
means = np.array([-2.0, 2.0])
component = rng.choice(2, size=2000, p=weights)
data = rng.normal(means[component], 0.5)
print("sample mean:", round(float(data.mean()), 3))
print("share near the first cluster:", round(float(np.mean(data < 0)), 3))
```

## Mixture means

The mean of a mixture is the weighted average of the component means, which matches the sample mean above.

```python run
print("mixture mean:", float(np.sum(weights * means)))
```

## Noise becomes data

A generator maps noise to data. An affine map is the simplest example: take a standard normal sample and scale and shift it.

```python run
z = rng.normal(size=5000)
x = 2.0 * z + 3.0
print("generated mean and standard deviation:", round(float(x.mean()), 2), round(float(x.std()), 2))
```

## Histograms show the modes

A histogram reveals the number of modes that a model must capture. Two bumps need a model that can represent two regions.

```python run
counts, edges = np.histogram(data, bins=8)
print("counts per bin:", counts)
```

> **Pitfall:** a model that matches the average of the data can still miss a mode entirely. Mode dropping is a classic failure of generators, and it is why diffusion models are evaluated on coverage as well as quality.

> **In the wild:** diffusion models displaced GANs in most image generation work, because their training objective is stable and their sample quality scales with compute.

## Challenge: mixture mean

```python exercise id=mixture-mean title="Mean of a mixture"
import numpy as np

# TODO: `mixture_mean(weights, means)` returns the mean of a mixture: the sum of each weight times its mean, divided by the
# sum of the weights.
def mixture_mean(weights, means):
    ...
--- solution
import numpy as np

def mixture_mean(weights, means):
    w = np.asarray(weights, dtype=float)
    m = np.asarray(means, dtype=float)
    return float(np.sum(w * m) / np.sum(w))
--- test
result = mixture_mean([0.25, 0.75], [0.0, 4.0])
assert result is not None, "Replace the `...` in `mixture_mean` with code that returns the mean."
assert abs(result - 3.0) < 1e-9, f"0.25 × 0 + 0.75 × 4 = 3, but you returned {result}."
assert abs(mixture_mean([1, 1], [0.0, 4.0]) - 2.0) < 1e-9, "Equal weights give the simple average of the means, 2."
--- hint
Multiply the weights and the means elementwise, then sum.
--- hint
`np.sum(w * m) / np.sum(w)`.
```

## Challenge: Gaussian sampling

```python exercise id=sample-gaussian title="Draw from a Gaussian with a given mean and spread"
import numpy as np

# TODO: `sample_gaussian(mu, sigma, n, rng)` returns an array of n samples from a normal distribution with mean mu and
# standard deviation sigma, drawn with the generator rng.
def sample_gaussian(mu, sigma, n, rng):
    ...
--- solution
import numpy as np

def sample_gaussian(mu, sigma, n, rng):
    return mu + sigma * rng.normal(size=n)
--- test
import numpy as np
result = sample_gaussian(2.0, 0.0, 5, np.random.default_rng(0))
assert result is not None, "Replace the `...` in `sample_gaussian` with code that returns the samples."
assert result.shape == (5,), f"Five samples should have shape (5,), but you returned shape {result.shape}."
assert np.allclose(result, 2.0), "With zero spread every sample equals the mean."
--- hint
Draw standard normal samples with `rng.normal(size=n)`, then scale by sigma and shift by mu.
--- hint
`mu + sigma * rng.normal(size=n)`.
```

## Debug: mixture weights

The mean should be normalized by the total weight, but the code forgets the division.

```python debug id=mixture-normalize title="Normalize the mixture weights"
import numpy as np

w = np.array([1.0, 1.0])
m = np.array([0.0, 4.0])
mean = np.sum(w * m)                  # bug: the weights are not normalized
print("mixture mean:", mean)
--- solution
import numpy as np

w = np.array([1.0, 1.0])
m = np.array([0.0, 4.0])
mean = np.sum(w * m) / np.sum(w)
print("mixture mean:", mean)
--- test
assert abs(mean - 2.0) < 1e-9, f"Two equal components at 0 and 4 have mean 2, but the code gives {mean}. Divide by the sum of the weights."
--- hint
Weights that do not sum to one must be normalized.
--- hint
Divide by `np.sum(w)`.
```

## Predict the mixture mean

```python predict id=predict-mix title="What is the mean of a mixture with equal weights on -1 and 1?"
import numpy as np
w = np.array([0.5, 0.5])
m = np.array([-1.0, 1.0])
print(float(np.sum(w * m)))
--- options
* 0.0
1.0
-1.0
0.5
--- explain
The two components are symmetric around zero, so their weighted mean is zero.
```

## Recap

- A generative model learns a distribution, and new examples are drawn from it.
- Mixtures have means that are weighted averages of their components.
- Histograms and coverage checks reveal whether a model captures every mode.

**Up next:** the forward process that adds noise, step by step.
