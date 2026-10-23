Random forests build trees side by side, independently. **Gradient boosting** builds them one after another. Each new tree is trained to predict the mistakes the current model still makes, and its predictions are added to the total with a small step size. Boosting is among the strongest methods for tabular data, and the idea is only a few lines of code.

## The residual idea

Start with a simple prediction, such as the average. The residuals, which are the errors, say what is still wrong. Fit a small tree to those residuals, add a fraction of its output to the prediction, and repeat.

$$
F_{m}(x) = F_{m-1}(x) + \eta \, h_m(x), \qquad h_m \text{ is fitted to the residuals } y - F_{m-1}(x)
$$

The learning rate $\eta$ is the fraction you add each round. Small steps need more rounds but generalize better.

```python run
import numpy as np

rng = np.random.default_rng(0)
x = np.sort(rng.uniform(0, 6, 120))
y = np.sin(x) + rng.normal(0, 0.2, 120)

prediction = np.full_like(y, y.mean())          # round 0: predict the average
print("round 0 mean squared error:", round(np.mean((y - prediction) ** 2), 3))
residuals = y - prediction
print("the first residuals:", residuals[:4].round(2))
```

## A stump as the weak learner

Boosting usually fits small trees. Here each one is a *stump*: a single split with a constant value on each side, chosen to minimize squared error.

```python run
def fit_stump(x, r):
    best = None
    for t in np.unique(x)[:-1]:
        left, right = r[x <= t], r[x > t]
        sse = np.sum((left - left.mean()) ** 2) + np.sum((right - right.mean()) ** 2)
        if best is None or sse < best[0]:
            best = (sse, float(t), float(left.mean()), float(right.mean()))
    return best[1:]

def stump_value(stump, x):
    t, lm, rm = stump
    return np.where(x <= t, lm, rm)

stump = fit_stump(x, residuals)
print("split at", round(stump[0], 2), "| left value", round(stump[1], 2), "| right value", round(stump[2], 2))
```

## Boost

```python run
lr = 0.3
pred = np.full_like(y, y.mean())
stumps = []
for round_ in range(60):
    resid = y - pred
    s = fit_stump(x, resid)
    stumps.append(s)
    pred = pred + lr * stump_value(s, x)
    if round_ in (0, 9, 59):
        print(f"round {round_ + 1:>2}: mean squared error {np.mean((y - pred) ** 2):.3f}")
```

Each round fits the remaining error and shrinks it. After sixty rounds the model follows the sine curve closely, although every stump is a crude step function.

## The learning rate trades speed for care

```python run
for rate in [0.05, 0.3, 1.0]:
    p = np.full_like(y, y.mean())
    for _ in range(20):
        p = p + rate * stump_value(fit_stump(x, y - p), x)
    print(f"learning rate {rate:>4}: error after 20 rounds {np.mean((y - p) ** 2):.3f}")
```

A rate of one is fastest here but takes the largest risks on noisier data. Smaller rates with more rounds are the usual default.

> **In the wild:** XGBoost, LightGBM and scikit-learn's `GradientBoostingRegressor` use this idea with deeper trees and extra tricks such as regularization and early stopping.

```python
# Static: run this on your own machine with xgboost installed
from xgboost import XGBRegressor

model = XGBRegressor(n_estimators=200, learning_rate=0.05, max_depth=3)
model.fit(x.reshape(-1, 1), y)
print(model.predict(x[:3].reshape(-1, 1)))
```

## Challenge: fit one stump

```python exercise id=stump-fit title="Fit a regression stump"
import numpy as np

# TODO: `stump_fit(x, r)` returns (threshold, left_value, right_value) for the single split on x that minimizes
# the total squared error of r around each side's mean. Try the midpoint between neighbouring distinct values
# of x, with x <= t on the left. Keep the first split on a tie.
def stump_fit(x, r):
    ...
--- solution
import numpy as np

def stump_fit(x, r):
    x = np.asarray(x, dtype=float)
    r = np.asarray(r, dtype=float)
    values = np.unique(x)
    best = None
    for lo, hi in zip(values[:-1], values[1:]):
        t = (lo + hi) / 2
        left, right = r[x <= t], r[x > t]
        sse = np.sum((left - left.mean()) ** 2) + np.sum((right - right.mean()) ** 2)
        if best is None or sse < best[0]:
            best = (sse, float(t), float(left.mean()), float(right.mean()))
    return best[1:]
--- test
import numpy as np
x_t = np.array([1.0, 2.0, 3.0, 10.0, 11.0])
r_t = np.array([1.0, 1.0, 1.0, 5.0, 5.0])
result = stump_fit(x_t, r_t)
assert result is not None, "Replace the `...` in `stump_fit` with code that returns (threshold, left, right)."
t, lv, rv = result
assert np.isclose(t, 6.5), f"The best split lies between 3 and 10, at 6.5, but you returned {t}."
assert np.isclose(lv, 1.0) and np.isclose(rv, 5.0), f"The left side averages 1 and the right side averages 5, but you returned {lv} and {rv}."
--- hint
For each midpoint, compute the sum of squared differences from the mean on each side, add the two, and keep the smallest.
--- hint
Keep the best tuple `(sse, t, left mean, right mean)` and return everything except the `sse`.
```

## Challenge: boosted prediction

```python exercise id=boosted-predict title="Combine the stumps"
import numpy as np

# TODO: `boosted_predict(x, base, stumps, lr)` returns base + lr × (the sum of the stump outputs). A stump is a tuple
# (threshold, left_value, right_value); its output for x is left_value where x <= threshold and right_value otherwise.
def boosted_predict(x, base, stumps, lr):
    ...
--- solution
import numpy as np

def boosted_predict(x, base, stumps, lr):
    x = np.asarray(x, dtype=float)
    total = np.zeros_like(x)
    for t, lv, rv in stumps:
        total += np.where(x <= t, lv, rv)
    return base + lr * total
--- test
import numpy as np
x_t = np.array([0.0, 5.0])
stumps_t = [(2.0, 1.0, -1.0), (4.0, 0.5, 2.0)]
result = boosted_predict(x_t, 10.0, stumps_t, 0.5)
assert result is not None, "Replace the `...` in `boosted_predict` with code that returns the predictions."
assert np.allclose(result, [10.0 + 0.5 * (1.0 + 0.5), 10.0 + 0.5 * (-1.0 + 2.0)]), f"For x = 0 the stumps give 1 + 0.5 = 1.5, and for x = 5 they give -1 + 2 = 1. With base 10 and rate 0.5 the answers are 10.75 and 10.5, but you returned {result}."
--- hint
Start from an array of zeros, add each stump's output for every x, then scale the total by `lr` and add `base`.
--- hint
Inside a loop over the stumps, use `np.where(x <= t, lv, rv)` and add it to the total.
```

## Debug the residual

This boosting step is meant to move the prediction towards the target, but the residual has the wrong sign, so the fit moves away from it.

```python debug id=residual-sign title="Fit the residual, not its negative"
import numpy as np

y = np.array([2.0, 4.0, 6.0])
pred = np.array([1.0, 1.0, 1.0])
residual = pred - y                 # bug: the residual is the target minus the prediction
print("residual to fit:", residual)
--- solution
import numpy as np

y = np.array([2.0, 4.0, 6.0])
pred = np.array([1.0, 1.0, 1.0])
residual = y - pred
print("residual to fit:", residual)
--- test
assert np.allclose(residual, [1.0, 3.0, 5.0]), f"The residual is the truth minus the prediction, [1, 3, 5], but you have {residual}. Reverse the subtraction."
--- hint
The boosting step must point the new tree towards the missing amount, which is target minus prediction.
--- hint
`residual = y - pred`.
```

## Predict the update

```python predict id=predict-boost title="What is the prediction after one round?"
import numpy as np
base = 0.0
lr = 0.5
stump_output = 2.0
print(base + lr * stump_output)
--- options
* 1.0
2.0
0.5
4.0
--- explain
One round adds the learning rate times the stump's output: 0.5 × 2 = 1. The learning rate keeps each correction small.
```

## Recap

- Gradient boosting fits each new weak model to the residuals of the ensemble so far.
- The learning rate shrinks each correction. Smaller steps need more rounds and usually generalize better.
- Stumps are crude on their own, and many of them add up to a good curve.
- XGBoost and LightGBM use deeper trees and regularization on the same principle.

**Up next:** nearest neighbours, a method with no training step at all.
