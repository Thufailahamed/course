You have a model with unknown parameters and some data. Which parameters should you choose? **Maximum likelihood estimation** (MLE) gives a principled answer: choose the parameters that make the observed data most probable. It sounds almost too simple, and yet it is hidden inside nearly every loss function you will meet. Mean squared error is maximum likelihood with Gaussian noise. Cross-entropy, the loss used for classifiers, is maximum likelihood with a Bernoulli model.

By the end of this lesson you will find maximum likelihood estimates by grid search and by formula, estimate the parameters of a Gaussian from data, show that least squares is maximum likelihood, and use log-likelihoods to avoid numerical underflow.

## Likelihood: how probable is the data?

Suppose you flip a coin 10 times and see 7 heads. For a coin with heads probability $p$, the probability of exactly this sequence is $p^7 (1 - p)^3$. As a function of $p$, this is the **likelihood**. The maximum likelihood estimate is the value of $p$ that makes it largest.

```python run
import numpy as np
import matplotlib.pyplot as plt

data = np.array([1, 1, 1, 0, 1, 1, 1, 0, 1, 0])     # 7 heads, 3 tails
heads = data.sum()
tails = len(data) - heads

grid = np.linspace(0.001, 0.999, 999)
log_likelihood = heads * np.log(grid) + tails * np.log(1 - grid)
best = grid[np.argmax(log_likelihood)]
print("maximum likelihood estimate of p:", round(float(best), 3))

fig, ax = plt.subplots()
ax.plot(grid, log_likelihood)
ax.axvline(best, color="tab:red", ls="--")
ax.set_xlabel("p"); ax.set_ylabel("log-likelihood"); ax.grid(alpha=0.3)
plt.show()
```

The curve peaks at 0.7. We used the **log**-likelihood: it has the same maximum, because the logarithm is increasing, and it turns products into sums, which is much better behaved numerically.

## The formula behind the peak

For a coin, the maximum likelihood estimate is simply the fraction of heads. You can derive it by setting the derivative of the log-likelihood to zero, but the answer is intuitive: the most probable $p$ is the observed frequency.

```python run
print("fraction of heads:", heads / len(data))
```

Setting the derivative of the log-likelihood to zero is the general recipe. For many models, this gives the answer in closed form. For others, the gradient descent you already know finds it.

## Gaussians: the mean and the variance

For measurements that follow a Gaussian distribution, the maximum likelihood estimates are the sample mean and the variance that divides by $n$ rather than $n - 1$.

$$
\hat{\mu} = \frac{1}{n}\sum_i x_i, \qquad \hat{\sigma}^2 = \frac{1}{n}\sum_i (x_i - \hat{\mu})^2
$$

```python run
rng = np.random.default_rng(5)
measurements = rng.normal(loc=10.0, scale=2.0, size=500)

mu_hat = measurements.mean()
sigma_hat = np.sqrt(np.mean((measurements - mu_hat) ** 2))
print(f"mu_hat = {mu_hat:.3f}, sigma_hat = {sigma_hat:.3f}   (true values: 10 and 2)")
print("matches np.std (which divides by n):", np.isclose(sigma_hat, measurements.std()))
```

> **Pitfall:** NumPy's `np.var` and `np.std` divide by $n$ by default, which is the maximum likelihood choice. The "unbiased" version divides by $n - 1$ and is set with `ddof=1`. Both are valid; know which one your code uses.

## Least squares is maximum likelihood

Suppose the data follow $y = wx + b + \varepsilon$, where the noise $\varepsilon$ is Gaussian. The likelihood of the data is largest when the sum of squared errors is smallest. So fitting by least squares is the same as maximum likelihood under Gaussian noise. Let's check that least squares recovers the right line.

```python run
rng = np.random.default_rng(1)
x = rng.uniform(-2, 2, 200)
y = 1.5 * x + 0.5 + rng.normal(0, 0.5, 200)

X = np.column_stack([x, np.ones_like(x)])
w_ls = np.linalg.lstsq(X, y, rcond=None)[0]
print("least-squares slope and intercept:", np.round(w_ls, 3), "(true values: 1.5 and 0.5)")
```

## Cross-entropy: maximum likelihood for classifiers

When each label is 0 or 1, the natural model is a Bernoulli distribution with a predicted probability $\hat{p}_i$ for each sample. The negative log-likelihood of that model is the **cross-entropy**, the loss used to train almost every classifier.

$$
\text{CE} = -\frac{1}{n}\sum_i \bigl[y_i \log \hat{p}_i + (1 - y_i)\log(1 - \hat{p}_i)\bigr]
$$

```python run
def cross_entropy(y_true, p_pred):
    return -np.mean(y_true * np.log(p_pred) + (1 - y_true) * np.log(1 - p_pred))

y_true = np.array([1, 0, 1, 1])
good = np.array([0.9, 0.1, 0.8, 0.95])
bad = np.array([0.4, 0.6, 0.3, 0.5])
print("good model:", round(cross_entropy(y_true, good), 3))
print("bad model: ", round(cross_entropy(y_true, bad), 3))
```

Confident, correct predictions give a small loss. Confident, wrong predictions are punished heavily, because the logarithm of a small probability is very negative.

## Challenges

```python exercise id=bernoulli-loglik title="Bernoulli log-likelihood"
# TODO: `bernoulli_log_likelihood(p, data)` should return the log-likelihood of the 0/1
# array `data` under a Bernoulli model with probability p:
#   sum over i of  data_i * log(p) + (1 - data_i) * log(1 - p)
def bernoulli_log_likelihood(p, data):
    ...
--- solution
def bernoulli_log_likelihood(p, data):
    data = np.asarray(data, dtype=float)
    return np.sum(data * np.log(p) + (1 - data) * np.log(1 - p))
--- test
result = bernoulli_log_likelihood(0.5, [1, 0, 1, 1])
assert result is not None, "Replace the `...` in `bernoulli_log_likelihood` with code that returns the log-likelihood."
assert np.isclose(result, 4 * np.log(0.5)), f"Four flips with p = 0.5 give a log-likelihood of 4·log(0.5) = {4 * np.log(0.5):.4f}, but you returned {result!r}."
assert np.isclose(bernoulli_log_likelihood(0.7, [1, 1, 0]), 2 * np.log(0.7) + np.log(0.3)), "Check a second case: p = 0.7 with data [1, 1, 0]."
--- hint
Compute the two terms for every point, `data * log(p)` and `(1 - data) * log(1 - p)`, add them, and sum over the data.
--- hint
`np.sum(data * np.log(p) + (1 - data) * np.log(1 - p))`.
```

```python exercise id=gaussian-mle title="Maximum likelihood for a Gaussian"
# TODO: `gaussian_mle(data)` should return (mu_hat, sigma_hat), the maximum likelihood
# estimates of the mean and standard deviation of a Gaussian. Divide by n, not n - 1.
def gaussian_mle(data):
    ...
--- solution
def gaussian_mle(data):
    data = np.asarray(data, dtype=float)
    mu = data.mean()
    sigma = np.sqrt(np.mean((data - mu) ** 2))
    return mu, sigma
--- test
data = [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0]
result = gaussian_mle(data)
assert result is not None, "Replace the `...` in `gaussian_mle` with code that returns (mu, sigma)."
mu, sigma = result
assert np.isclose(mu, 5.0), f"The mean of these data is 5, but gaussian_mle returned mu = {mu!r}."
assert np.isclose(sigma, 2.0), f"The population standard deviation of these data is 2 (divide by n), but gaussian_mle returned sigma = {sigma!r}."
--- hint
The mean is `data.mean()`. For the variance, average the squared deviations from that mean, dividing by n.
--- hint
`sigma = np.sqrt(np.mean((data - mu) ** 2))`.
```

```python exercise id=stable-cross-entropy title="Cross-entropy that never takes log(0)"
# TODO: `safe_cross_entropy(y_true, p_pred)` should compute the same cross-entropy as
# before, but clip the predictions to [1e-12, 1 - 1e-12] first, so that the logarithm
# never sees 0 or 1 and the loss stays finite.
def safe_cross_entropy(y_true, p_pred):
    ...
--- solution
def safe_cross_entropy(y_true, p_pred):
    y_true = np.asarray(y_true, dtype=float)
    p = np.clip(np.asarray(p_pred, dtype=float), 1e-12, 1 - 1e-12)
    return -np.mean(y_true * np.log(p) + (1 - y_true) * np.log(1 - p))
--- test
good = safe_cross_entropy([1, 0, 1, 1], [0.9, 0.1, 0.8, 0.95])
assert good is not None, "Replace the `...` in `safe_cross_entropy` with code that returns the loss."
assert np.isclose(good, 0.1213, atol=1e-3), f"The cross-entropy of the good model should be about 0.1213, but you returned {good!r}."
worst = safe_cross_entropy([1, 0], [0.0, 1.0])
assert np.isfinite(worst), "Completely wrong predictions of exactly 0 or 1 should give a large but finite loss. Clip the predictions before taking the logarithm."
assert np.isclose(safe_cross_entropy([1, 0], [1.0, 0.0]), 0.0, atol=1e-6), "Perfect predictions should give a loss close to 0."
--- hint
`np.clip(p, 1e-12, 1 - 1e-12)` keeps every probability strictly inside (0, 1).
--- hint
Clip `p_pred` first, then use the same formula as `cross_entropy`.
```

```python debug log-underflow id=log-underflow title="A likelihood that vanishes"
rng = np.random.default_rng(0)
data = rng.binomial(1, 0.6, size=2000)     # 2000 coin flips with true p = 0.6
p = 0.6

# Likelihood of the data, then its logarithm
likelihood = np.prod(p ** data * (1 - p) ** (1 - data))
log_likelihood = np.log(likelihood)
print("log-likelihood:", log_likelihood)
--- solution
rng = np.random.default_rng(0)
data = rng.binomial(1, 0.6, size=2000)     # 2000 coin flips with true p = 0.6
p = 0.6

# Log-likelihood: the sum of the log probabilities
log_likelihood = np.sum(data * np.log(p) + (1 - data) * np.log(1 - p))
print("log-likelihood:", log_likelihood)
--- test
expected = np.sum(data * np.log(0.6) + (1 - data) * np.log(0.4))
assert np.isfinite(log_likelihood), f"The log-likelihood should be a finite number, but it is {log_likelihood!r}. Multiplying 2000 probabilities underflows to 0."
assert np.isclose(log_likelihood, expected), f"The log-likelihood should be about {expected:.2f}, but it is {log_likelihood!r}."
--- hint
Look at the printed value. A log of exactly 0 becomes minus infinity: the likelihood has underflowed.
--- hint
Multiply 2000 numbers below 1 and the product shrinks below the smallest float. Take logarithms of each factor first, then add them.
```

```python predict id=predict-mle title="The maximum likelihood mean"
print(np.mean([2, 4, 6]))
--- options
* 4.0
2.0
6.0
12.0
--- explain
For a Gaussian, the maximum likelihood estimate of the mean is the sample mean. `(2 + 4 + 6) / 3 = 4`.
```

```python predict id=predict-mle-var title="Dividing by n or by n - 1"
print(np.var([1.0, 3.0]))
--- options
* 1.0
2.0
0.5
4.0
--- explain
The mean is 2 and the squared deviations are both 1. Dividing their sum (2) by n = 2 gives 1.0. Dividing by n - 1 would give 2.0; that is the `ddof=1` version.
```

## Recap

- Maximum likelihood chooses the parameters that make the observed data most probable.
- Work with log-likelihoods: the maximum is the same, and sums replace products, which avoids underflow.
- For a Gaussian, the MLE is the sample mean and the variance divided by $n$.
- Least squares is maximum likelihood under Gaussian noise, and cross-entropy is maximum likelihood for binary labels.

**Up next:** the final assessment. It draws together the whole course.
