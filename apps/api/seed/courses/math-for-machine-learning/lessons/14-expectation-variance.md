Three numbers summarize almost everything you need to know about a random quantity. The **expectation** is its long-run average. The **variance** measures how far single draws typically stray from that average. The **covariance** tells you whether two quantities rise and fall together. These three ideas sit underneath every loss function, every statistical test and every dimensionality reduction method in this course.

By the end of this lesson you will compute expectations and variances from distributions and from data, use linearity to transform random quantities, and measure how two features co-vary, the foundation of the covariance matrix you met in PCA.

## Expectation: the probability-weighted average

The expectation of a discrete random variable is each value times its probability, summed:

$$
\mathbb{E}[X] = \sum_x x\, P(X = x)
$$

A fair die shows each face with probability $\frac{1}{6}$, so its expectation is $3.5$. The die never shows 3.5, but over many rolls the average approaches it.

```python run
import numpy as np

faces = np.arange(1, 7)
probs = np.full(6, 1 / 6)
expected = np.dot(faces, probs)
print("E[die] =", expected)
```

That last calculation is a dot product, which you met in the first lesson. Expectation is a weighted sum, and weighted sums are dot products.

The **Law of Large Numbers** says that sample averages converge to the expectation. Watch it happen.

```python run
rng = np.random.default_rng(0)
for n in [10, 1000, 100_000]:
    rolls = rng.integers(1, 7, size=n)
    print(f"n = {n:>7,}: sample mean = {rolls.mean():.3f}")
```

## Variance: how far draws stray

The variance is the expected squared distance from the mean:

$$
\operatorname{Var}(X) = \mathbb{E}\big[(X - \mu)^2\big] = \mathbb{E}[X^2] - \mu^2
$$

The second form is often easier to compute. Its square root is the standard deviation, which is in the same units as $X$.

```python run
var = np.dot(faces ** 2, probs) - expected ** 2
print("Var(die) =", round(var, 4), "| standard deviation =", round(np.sqrt(var), 4))
```

## Covariance: do two things move together?

For two random variables, the **covariance** is the expected product of their deviations from their means. Positive covariance means they tend to be high together; negative means one is high when the other is low.

$$
\operatorname{Cov}(X, Y) = \mathbb{E}\big[(X - \mu_X)(Y - \mu_Y)\big]
$$

Let's look at hours studied and exam scores, which we have simulated to be related.

```python run
rng = np.random.default_rng(2)
hours = rng.uniform(0, 10, 200)
score = 50 + 4 * hours + rng.normal(0, 5, 200)

print("covariance matrix:")
print(np.cov(hours, score).round(2))
print("correlation:", round(np.corrcoef(hours, score)[0, 1], 3))
```

The covariance matrix contains the variance of each variable on its diagonal and the covariance between them off the diagonal. The **correlation** rescales the covariance to lie between $-1$ and $1$, so it is easier to interpret.

```python run
import matplotlib.pyplot as plt

fig, ax = plt.subplots()
ax.scatter(hours, score, s=10, alpha=0.6)
ax.set_xlabel("hours studied"); ax.set_ylabel("exam score"); ax.grid(alpha=0.3)
plt.show()
```

> **Pitfall:** correlation measures *linear* association only, and it says nothing about causation. Hours studied and scores move together here because we built them that way. In real data, always look at the plot.

## Linearity: transforming random variables

Expectation is **linear**: $\mathbb{E}[aX + b] = a\,\mathbb{E}[X] + b$, always, whether or not the variables are independent. Variance scales with the square of the multiplier and ignores shifts: $\operatorname{Var}(aX + b) = a^2 \operatorname{Var}(X)$.

```python run
x = rng.normal(0, 1, 100_000)
y = 3 * x + 10
print("mean of y:", round(y.mean(), 2), "(expected 10)")
print("variance of y:", round(y.var(), 2), "(expected 3² · 1 = 9)")
```

These two rules make standardization work: $(X - \mu)/\sigma$ has mean 0 and variance 1. You used exactly that in the broadcasting lesson.

## Challenges

```python exercise id=expectation title="Expectation of a discrete variable"
# TODO: `expectation(values, probs)` should return the expected value of a discrete
# random variable that takes `values` with probabilities `probs`.
def expectation(values, probs):
    ...
--- solution
def expectation(values, probs):
    return np.dot(values, probs)
--- test
result = expectation([0.0, 1.0, 2.0], [0.5, 0.25, 0.25])
assert result is not None, "Replace the `...` in `expectation` with code that returns the expected value."
assert np.isclose(result, 0.75), f"0·0.5 + 1·0.25 + 2·0.25 = 0.75, but expectation returned {result!r}."
assert np.isclose(expectation([10.0, -4.0], [0.2, 0.8]), -1.2), "With values 10 and -4, the expectation is 10·0.2 + (-4)·0.8 = -1.2."
--- hint
Multiply each value by its probability and add them up. NumPy does both steps with a dot product.
--- hint
`np.dot(values, probs)`.
```

```python exercise id=covariance title="Covariance from scratch"
# TODO: `covariance(x, y)` should return the population covariance of x and y:
# the mean of (x - mean(x)) * (y - mean(y)). Don't use np.cov.
def covariance(x, y):
    ...
--- solution
def covariance(x, y):
    x = np.asarray(x, dtype=float)
    y = np.asarray(y, dtype=float)
    return np.mean((x - x.mean()) * (y - y.mean()))
--- test
rng = np.random.default_rng(11)
x = rng.normal(size=500)
y = 0.5 * x + rng.normal(size=500)
result = covariance(x, y)
assert result is not None, "Replace the `...` in `covariance` with code that returns the covariance."
assert np.isclose(result, np.cov(x, y, bias=True)[0, 1]), f"covariance should match np.cov(x, y, bias=True), but it returned {result!r}."
assert np.isclose(covariance([1.0, 2.0, 3.0], [1.0, 2.0, 3.0]), 2 / 3), "The covariance of a variable with itself is its variance, here 2/3."
--- hint
Subtract each mean from its variable, multiply the two deviation arrays elementwise, then take the mean.
--- hint
`np.mean((x - x.mean()) * (y - y.mean()))`.
```

```python exercise id=correlation title="Correlation from scratch"
# TODO: `correlation(x, y)` should return the Pearson correlation coefficient:
# covariance(x, y) / (std(x) * std(y)), with population standard deviations.
def correlation(x, y):
    ...
--- solution
def correlation(x, y):
    x = np.asarray(x, dtype=float)
    y = np.asarray(y, dtype=float)
    cov = np.mean((x - x.mean()) * (y - y.mean()))
    return cov / (x.std() * y.std())
--- test
rng = np.random.default_rng(12)
x = rng.normal(size=300)
y = -2.0 * x + rng.normal(size=300)
result = correlation(x, y)
assert result is not None, "Replace the `...` in `correlation` with code that returns the correlation."
assert np.isclose(result, np.corrcoef(x, y)[0, 1]), f"correlation should match np.corrcoef, but it returned {result!r}."
assert np.isclose(correlation([1.0, 2.0, 3.0], [2.0, 4.0, 6.0]), 1.0), "Perfectly linear data have correlation 1."
--- hint
Divide your covariance by the product of the two standard deviations. `x.std()` already gives the population standard deviation.
--- hint
`cov / (x.std() * y.std())`, where `cov` is the covariance you wrote in the previous challenge.
```

```python debug uncentered-covariance id=uncentered-covariance title="Covariance that is far too large"
x = np.array([10.0, 12.0, 14.0, 16.0, 18.0])
y = np.array([20.0, 21.0, 23.0, 26.0, 27.0])

# Covariance: the average of (x - mean x) * (y - mean y)
cov_xy = np.mean(x * y)
print("cov:", round(cov_xy, 3))
print("np.cov (bias=True):", round(np.cov(x, y, bias=True)[0, 1], 3))
--- solution
x = np.array([10.0, 12.0, 14.0, 16.0, 18.0])
y = np.array([20.0, 21.0, 23.0, 26.0, 27.0])

# Covariance: the average of (x - mean x) * (y - mean y)
cov_xy = np.mean((x - x.mean()) * (y - y.mean()))
print("cov:", round(cov_xy, 3))
print("np.cov (bias=True):", round(np.cov(x, y, bias=True)[0, 1], 3))
--- test
assert np.isclose(cov_xy, np.cov(x, y, bias=True)[0, 1]), f"cov_xy should match np.cov, which is {np.cov(x, y, bias=True)[0, 1]:.3f}, but it is {cov_xy:.3f}."
--- hint
`np.mean(x * y)` is the average of the raw products, not of the deviations. Covariance centers each variable first.
--- hint
Replace `x * y` with the product of the deviations: `(x - x.mean()) * (y - y.mean())`.
```

```python predict id=predict-linearity title="Scaling and shifting a variable"
X = np.array([1.0, 2.0, 3.0, 4.0])
Y = 2 * X + 1
print(Y.mean(), Y.var())
--- options
* 6.0 5.0
6.0 20.0
5.0 5.0
6.0 10.0
--- explain
Y is `[3, 5, 7, 9]`, with mean 6. Its deviations are -3, -1, 1, 3, and their squares average to `(9 + 1 + 1 + 9) / 4 = 5`. Doubling X doubles the mean's contribution, and the variance grows by 2² = 4 times, while the shift +1 changes the mean but not the variance.
```

## Recap

- Expectation is the probability-weighted average. Over many draws, sample means converge to it.
- Variance is the expected squared distance from the mean, $\mathbb{E}[X^2] - \mu^2$.
- Covariance measures how two variables move together, and correlation rescales it to $[-1, 1]$.
- Expectation is linear. Variance scales by the square of the multiplier and ignores shifts.

**Up next:** Bayes' rule, the formula for updating a belief when new evidence arrives.
