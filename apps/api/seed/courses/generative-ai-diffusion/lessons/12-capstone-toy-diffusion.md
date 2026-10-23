This capstone builds a complete diffusion pipeline on two-dimensional data, so every part is visible. You generate a dataset with two clusters, noise it with the forward process, learn a denoiser from the pairs, sample with the reverse process and check the samples against the data. The denoiser is a nearest-neighbour regressor rather than a neural network, which keeps the code short and the behaviour easy to inspect.

## The dataset

Two clusters around (−2, 0) and (2, 0) play the role of an image distribution.

```python run
import numpy as np

rng = np.random.default_rng(10)
centers = np.array([[-2.0, 0.0], [2.0, 0.0]])
which = rng.integers(0, 2, size=1000)
data = centers[which] + rng.normal(0, 0.3, size=(1000, 2))
print("dataset shape:", data.shape)
print("share in the first cluster:", round(float(np.mean(which == 0)), 3))
```

## The noise schedule

The capstone uses 50 steps with a linear schedule, and the alpha-bar values come from the same formulas as earlier lessons.

```python run
T = 50
betas = np.linspace(1e-4, 0.2, T)
alphas = 1 - betas
abar = np.cumprod(alphas)
print("alpha-bar at the start, middle and end:", round(float(abar[0]), 4), round(float(abar[25]), 4), round(float(abar[-1]), 4))
```

## Training pairs

For each step we noise the data and record the noise that was added. Each step gets its own set of pairs, because the noise an input carries depends on the step.

```python run
def make_pairs(x0, t, rng):
    eps = rng.normal(size=x0.shape)
    xt = np.sqrt(abar[t]) * x0 + np.sqrt(1 - abar[t]) * eps
    return xt, eps

train_x = {}
train_e = {}
for t in range(T):
    train_x[t], train_e[t] = make_pairs(data[:, 0], t, rng)
print("pairs per step:", len(train_x[0]), "| steps:", len(train_x))
```

## A nearest-neighbour denoiser

At a given step, the denoiser predicts the noise for a point by averaging the noise of the k nearest training points from that step.

```python run
def knn_eps(x, tx, te, k=20):
    idx = np.argsort(np.abs(tx - x))[:k]
    return float(np.mean(te[idx]))

t0 = 25
print("predicted noise at x = 0.5 for step 25:", round(knn_eps(0.5, train_x[t0], train_e[t0]), 3))
```

## Sampling and evaluation

The reverse loop samples points from noise, and the fraction that lands near a cluster measures coverage.

```python run
samples = []
for _ in range(200):
    x = rng.normal(size=1)
    for t in reversed(range(T)):
        eps_hat = knn_eps(x[0], train_x[t], train_e[t])
        mean = (x - betas[t] / np.sqrt(1 - abar[t]) * eps_hat) / np.sqrt(alphas[t])
        noise = rng.normal(size=1) if t > 0 else 0.0
        x = mean + np.sqrt(betas[t]) * noise
    samples.append(x[0])
samples = np.array(samples)
near = np.mean(np.minimum(np.abs(samples + 2.0), np.abs(samples - 2.0)) <= 1.0)
print("fraction of samples near a cluster:", round(float(near), 3))
```

> **Pitfall:** a sampler can look good on the training pairs and fail on samples, because errors in the predicted noise compound over many steps. Always measure the final samples, not only the training loss.

> **In the wild:** this is the same loop as a production sampler. The learned denoiser is what changes, and the evaluation of samples against the data distribution is what tells you whether it worked.

## Challenge: nearest-neighbour noise

```python exercise id=knn-eps title="Average the noise of the nearest training points"
import numpy as np

# TODO: `knn_eps(x, train_x, train_eps, k)` returns the mean of train_eps over the k training points whose train_x values are
# closest to x. Use the absolute distance.
def knn_eps(x, train_x, train_eps, k):
    ...
--- solution
import numpy as np

def knn_eps(x, train_x, train_eps, k):
    dist = np.abs(np.asarray(train_x, dtype=float) - x)
    idx = np.argsort(dist)[:k]
    return float(np.mean(np.asarray(train_eps, dtype=float)[idx]))
--- test
import numpy as np
result = knn_eps(0.9, np.array([0.0, 1.0, 10.0]), np.array([1.0, 2.0, 3.0]), 2)
assert result is not None, "Replace the `...` in `knn_eps` with code that returns the mean."
assert abs(result - 1.5) < 1e-9, f"The two nearest points are x = 1 and x = 0, with noise 2 and 1, so the mean is 1.5, but you returned {result}."
--- hint
Sort the distances with `np.argsort` and take the first k indices.
--- hint
`idx = np.argsort(np.abs(train_x - x))[:k]`.
```

## Challenge: coverage

```python exercise id=coverage title="Fraction of samples near a centre"
import numpy as np

# TODO: `fraction_near(samples, centers, radius)` returns the fraction of samples whose distance to the nearest centre is at
# most radius.
def fraction_near(samples, centers, radius):
    ...
--- solution
import numpy as np

def fraction_near(samples, centers, radius):
    samples = np.asarray(samples, dtype=float)
    centers = np.asarray(centers, dtype=float)
    nearest = np.min(np.abs(samples[:, None] - centers[None, :]), axis=1)
    return float(np.mean(nearest <= radius))
--- test
result = fraction_near(np.array([0.1, 5.0]), np.array([0.0]), 1.0)
assert result is not None, "Replace the `...` in `fraction_near` with code that returns the fraction."
assert abs(result - 0.5) < 1e-9, f"One of the two samples is within 1 of the centre, so the fraction is 0.5, but you returned {result}."
--- hint
Compute the distance from every sample to every centre, take the minimum over centres, then compare with the radius.
--- hint
Use broadcasting: `samples[:, None] - centers[None, :]`.
```

## Debug: the farthest points instead of the nearest

The nearest-neighbour denoiser should use the closest points, but the sort order is reversed.

```python debug id=knn-farthest title="Use the nearest points, not the farthest"
import numpy as np

train_x = np.array([0.0, 1.0, 10.0])
train_e = np.array([1.0, 2.0, 3.0])
x = 0.9
dist = np.abs(train_x - x)
idx = np.argsort(-dist)[:2]          # bug: the negative sort picks the farthest points
print("prediction:", float(np.mean(train_e[idx])))
--- solution
import numpy as np

train_x = np.array([0.0, 1.0, 10.0])
train_e = np.array([1.0, 2.0, 3.0])
x = 0.9
dist = np.abs(train_x - x)
idx = np.argsort(dist)[:2]
print("prediction:", float(np.mean(train_e[idx])))
--- test
assert abs(float(np.mean(train_e[idx])) - 1.5) < 1e-9, f"The nearest two points have noise 2 and 1, so the prediction is 1.5, but the code gives {float(np.mean(train_e[idx]))}. Sort the distances without negating them."
--- hint
The closest points have the smallest distances, and argsort puts smallest first.
--- hint
Remove the minus sign.
```

## Predict the fraction

```python predict id=predict-cov title="What fraction is inside when two samples are 0.1 and 5.0 and the centre is 0 with radius 1?"
print(0.5)
--- options
* 0.5
1.0
0.0
0.25
--- explain
Only the sample at 0.1 is within radius 1 of the centre, so one of two samples is inside.
```

## Recap

- A diffusion pipeline has four parts: the dataset, the noise schedule, the denoiser and the reverse sampler.
- The denoiser learns to predict noise from training pairs, and the sampler applies it step by step.
- Evaluate the final samples against the data, because training loss alone can hide sampling failures.

**Up next:** the final assessment covers the whole course.
