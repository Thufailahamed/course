Nothing a model sees is certain. Sensors are noisy, customers are unpredictable and the next word in a sentence could be many things. Probability gives you a language for that uncertainty. A **random variable** is a quantity whose value you don't know until you observe it, and its **distribution** says which values are likely and which are rare. Two families carry most of the weight in machine learning: the binomial, for counts of successes, and the Gaussian (normal), for measurements that cluster around an average.

By the end of this lesson you will simulate random variables with NumPy, compute exact probabilities from formulas and compare the two, read a probability density, and compute tail probabilities with the error function.

## Simulate first, then calculate

The fastest way to build intuition is to simulate. Flip a fair coin many times and the fraction of heads settles near 0.5. NumPy's random generator makes this instant. We seed it so that every run is identical.

```python run
import numpy as np

rng = np.random.default_rng(0)

ten_flips = rng.integers(0, 2, size=10)        # 1 = heads, 0 = tails
print("ten flips:", ten_flips)
print("fraction of heads in 10 flips:", ten_flips.mean())

many = rng.integers(0, 2, size=100_000)
print("fraction of heads in 100,000 flips:", round(many.mean(), 4))
```

Ten flips can give any fraction. A hundred thousand flips land very close to one half. That tightening is the Law of Large Numbers, and you will meet it again in the next lesson.

## Discrete distributions: the probability mass function

A discrete random variable takes values you can list, such as the number of heads in $n$ flips. Its **probability mass function** (PMF) gives the probability of each value. For the binomial distribution, the number of successes $k$ in $n$ trials with success probability $p$ has

$$
P(X = k) = \binom{n}{k} p^k (1 - p)^{n - k}
$$

Let's check the formula against a simulation of 100,000 experiments, each with 10 flips.

```python run
from math import comb

n, p = 10, 0.5
simulated = rng.binomial(n, p, size=100_000)

for k in [3, 5, 7]:
    exact = comb(n, k) * p ** k * (1 - p) ** (n - k)
    print(f"P(X = {k}): simulated {np.mean(simulated == k):.4f}   exact {exact:.4f}")
```

The simulated frequencies match the exact probabilities. The formula is a prediction, and the simulation is an experiment that confirms it.

## Continuous distributions: the probability density

A continuous variable, such as a height or a temperature, can take any value in a range, so the probability of exactly one value is zero. Instead we use a **probability density function** (PDF): probabilities are areas under the curve. The Gaussian density is

$$
f(x) = \frac{1}{\sigma\sqrt{2\pi}}\exp\!\left(-\frac{(x - \mu)^2}{2\sigma^2}\right)
$$

with mean $\mu$ and standard deviation $\sigma$. The histogram below overlays the formula on 5,000 samples.

```python run
import matplotlib.pyplot as plt

def gaussian_pdf(x, mu=0.0, sigma=1.0):
    return np.exp(-(x - mu) ** 2 / (2 * sigma ** 2)) / (sigma * np.sqrt(2 * np.pi))

samples = rng.normal(loc=0.0, scale=1.0, size=5000)
xs = np.linspace(-4, 4, 300)

fig, ax = plt.subplots()
ax.hist(samples, bins=40, density=True, alpha=0.5, label="5,000 samples")
ax.plot(xs, gaussian_pdf(xs), color="tab:red", label="the density formula")
ax.set_xlabel("x"); ax.legend()
plt.show()
```

The bars follow the curve, so the formula describes the samples well.

## Areas are probabilities

The probability that $X$ falls between $-1$ and $1$ is the area under the curve between those points. We can estimate that area by integrating the density numerically with the trapezoid rule.

```python run
xs = np.linspace(-1, 1, 2001)
area = np.trapezoid(gaussian_pdf(xs), xs)
print("P(-1 < X < 1) ≈", round(area, 4))
print("from the samples:", round(np.mean(np.abs(samples) < 1), 3))
```

About 68% of a standard Gaussian lies within one standard deviation of the mean. This "68–95–99.7" rule is a good mental anchor.

> **Pitfall:** a density can be larger than 1. The Gaussian density at its peak is about 0.4 for $\sigma = 1$, but about 4 for $\sigma = 0.1$, because a narrow curve concentrates the same total area into less width. Only areas, not heights, are probabilities.

## Challenges

```python exercise id=binomial-pmf title="A binomial probability"
from math import comb

# TODO: `binom_pmf(k, n, p)` should return P(X = k) for a binomial with n trials and
# success probability p, using comb(n, k) * p**k * (1 - p)**(n - k).
def binom_pmf(k, n, p):
    ...
--- solution
from math import comb

def binom_pmf(k, n, p):
    return comb(n, k) * p ** k * (1 - p) ** (n - k)
--- test
result = binom_pmf(2, 4, 0.5)
assert result is not None, "Replace the `...` in `binom_pmf` with code that returns the probability."
assert np.isclose(result, 0.375), f"With 4 fair flips, P(2 heads) is 6/16 = 0.375, but binom_pmf returned {result!r}."
total = sum(binom_pmf(k, 6, 0.3) for k in range(7))
assert np.isclose(total, 1.0), f"The probabilities over every k should add up to 1, but they add up to {total!r}."
--- hint
`comb(n, k)` counts the ways to choose which trials are successes. Multiply by the probability of one particular arrangement.
--- hint
The formula is `comb(n, k) * p**k * (1 - p)**(n - k)`.
```

```python exercise id=tail-probability title="Tail probability of a Gaussian"
from math import erf, sqrt

# TODO: `prob_above(mu, sigma, threshold)` should return P(X > threshold) for a Gaussian
# with mean mu and standard deviation sigma. Use the error function:
#   P(X > t) = 0.5 * (1 - erf((t - mu) / (sigma * sqrt(2))))
def prob_above(mu, sigma, threshold):
    ...
--- solution
from math import erf, sqrt

def prob_above(mu, sigma, threshold):
    return 0.5 * (1 - erf((threshold - mu) / (sigma * sqrt(2))))
--- test
result = prob_above(0.0, 1.0, 1.0)
assert result is not None, "Replace the `...` in `prob_above` with code that returns the probability."
assert np.isclose(result, 0.158655, atol=1e-5), f"P(X > 1) for a standard Gaussian is about 0.158655, but prob_above returned {result!r}."
assert np.isclose(prob_above(10.0, 2.0, 12.0), 0.158655, atol=1e-5), "A threshold one standard deviation above the mean (10 + 2 = 12) should give the same tail."
assert np.isclose(prob_above(5.0, 3.0, 5.0), 0.5, atol=1e-9), "Half of a Gaussian lies above its mean."
--- hint
Standardize first: `(threshold - mu) / sigma` counts the standard deviations above the mean.
--- hint
Convert to standard units, then apply `erf` with `sigma * sqrt(2)` in the denominator.
```

```python debug scale-vs-variance id=scale-vs-variance title="Too spread out"
rng = np.random.default_rng(1)
variance = 4.0          # we want a standard deviation of 2
samples = rng.normal(loc=0.0, scale=variance, size=50_000)
print("std of samples:", round(samples.std(), 2))
--- solution
rng = np.random.default_rng(1)
variance = 4.0          # we want a standard deviation of 2
samples = rng.normal(loc=0.0, scale=np.sqrt(variance), size=50_000)
print("std of samples:", round(samples.std(), 2))
--- test
assert np.isclose(samples.std(), 2.0, atol=0.05), f"The samples should have standard deviation 2, but their standard deviation is {samples.std():.3f}."
--- hint
The printed standard deviation is about 4, which is the variance. `scale` in `rng.normal` expects the standard deviation.
--- hint
Pass `scale=np.sqrt(variance)`.
```

```python predict id=predict-mean title="The average of a Bernoulli sample"
flips = np.array([1, 0, 1, 1])
print(flips.mean())
--- options
* 0.75
0.5
3
1.0
--- explain
Three of the four flips are heads, so the average is 3/4 = 0.75. For a sequence of 0s and 1s, the mean is the fraction of successes, which estimates the probability p.
```

```python predict id=predict-comb title="Counting arrangements"
from math import comb
print(comb(5, 2))
--- options
5
* 10
20
7
--- explain
`comb(5, 2)` is the number of ways to choose 2 of 5 items without regard to order: `5! / (2! · 3!) = 10`.
```

## Recap

- A random variable has a distribution: the probabilities of its values.
- Simulation with a seeded generator builds intuition; formulas give exact answers.
- A discrete distribution has a PMF that gives probabilities directly. The binomial counts successes.
- A continuous distribution has a density, and probabilities are areas under it. The Gaussian is the central example.
- The Gaussian's standard deviation is the `scale` argument in NumPy, not the variance.

**Up next:** expectation, variance and covariance. These three numbers summarize any distribution, and they are the building blocks of every loss function.
