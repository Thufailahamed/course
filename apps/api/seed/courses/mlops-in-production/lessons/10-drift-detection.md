A model is trained on a sample of the world, and the world keeps moving. Data drift means the distribution of inputs in production has shifted from the training distribution. The population stability index compares the two distributions bin by bin. A small value means the inputs look the same, and a large value means they have moved enough to threaten the model.

## Binning a feature

Both distributions are compared over the same bins. Each bin holds the share of values that fall in it.

```python run
import numpy as np

def bin_proportions(values, edges):
    counts, _ = np.histogram(values, bins=edges)
    return counts / counts.sum()

rng = np.random.default_rng(12)
reference = rng.normal(0, 1, 5000)
edges = np.linspace(-3, 3, 7)
print("reference bin shares:", np.round(bin_proportions(reference, edges), 3))
```

## Shifted production data

Production data with a shifted mean puts more of its mass in the upper bins.

```python run
production = rng.normal(0.8, 1, 5000)
print("production bin shares:", np.round(bin_proportions(production, edges), 3))
```

## The population stability index

For each bin the index adds (actual − expected) times the log of actual over expected. The sum is zero when the distributions match, and it grows as they diverge.

```python run
import math

def psi(expected, actual):
    return sum((a - e) * math.log(a / e) for e, a in zip(expected, actual))

exp_p = bin_proportions(reference, edges)
act_p = bin_proportions(production, edges)
print("PSI of the shifted data:", round(psi(exp_p, act_p), 3))
print("PSI of the reference against itself:", round(psi(exp_p, exp_p), 3))
```

## Reading the index

A common rule of thumb reads a value below 0.1 as stable, 0.1 to 0.2 as a shift to watch, and above 0.2 as a shift that needs action.

```python run
for value in [0.05, 0.15, 0.3]:
    level = "stable" if value < 0.1 else ("watch" if value < 0.2 else "act")
    print(value, "->", level)
```

> **Pitfall:** the index depends on the bins. Choose bins from the reference data, not from production, or the comparison moves with the bins.

> **In the wild:** monitoring systems compute a drift score for every feature each day, and surface the features whose scores have risen the most.

## Challenge: bin proportions

```python exercise id=bin-proportions title="Share of values in each bin"
import numpy as np

# TODO: `bin_proportions(values, edges)` returns a numpy array with the share of values in each bin defined by the edges. Use
# np.histogram with bins=edges and divide the counts by their total.
def bin_proportions(values, edges):
    ...
--- solution
import numpy as np

def bin_proportions(values, edges):
    counts, _ = np.histogram(values, bins=edges)
    return counts / counts.sum()
--- test
import numpy as np
result = bin_proportions([0.5, 1.5, 2.5, 2.9], [0, 1, 2, 3])
assert result is not None, "Replace the `...` in `bin_proportions` with code that returns the shares."
assert np.allclose(result, [0.25, 0.25, 0.5]), f"One value falls in each of the first two bins and two in the last, so the shares are [0.25, 0.25, 0.5], but you returned {result}."
--- hint
Use `np.histogram`, and divide by the total of the counts.
--- hint
`counts, _ = np.histogram(values, bins=edges)`.
```

## Challenge: population stability index

```python exercise id=psi title="Population stability index"
import math

# TODO: `psi(expected, actual)` takes two lists of bin proportions and returns the sum over bins of (actual − expected) times
# log(actual / expected).
def psi(expected, actual):
    ...
--- solution
import math

def psi(expected, actual):
    return sum((a - e) * math.log(a / e) for e, a in zip(expected, actual))
--- test
assert abs(psi([0.5, 0.5], [0.5, 0.5])) < 1e-12, "Identical distributions have an index of zero."
result = psi([0.5, 0.5], [0.9, 0.1])
expected_value = (0.9 - 0.5) * math.log(0.9 / 0.5) + (0.1 - 0.5) * math.log(0.1 / 0.5)
assert result is not None, "Replace the `...` in `psi` with code that returns the index."
assert abs(result - expected_value) < 1e-9, f"The index for [0.5, 0.5] against [0.9, 0.1] is {expected_value:.4f}, but you returned {result}."
--- hint
Zip the two lists, then add up the terms.
--- hint
Each term is `(a - e) * math.log(a / e)`.
```

## Debug: the sign of the log ratio

The index should be positive when the distributions differ, but the log ratio is inverted, which flips the sign.

```python debug id=psi-sign title="Take the log of actual over expected"
import math
expected = [0.5, 0.5]
actual = [0.9, 0.1]
psi_value = sum((a - e) * math.log(e / a) for e, a in zip(expected, actual))   # bug: the ratio is inverted
print("psi:", round(psi_value, 4))
--- solution
import math
expected = [0.5, 0.5]
actual = [0.9, 0.1]
psi_value = sum((a - e) * math.log(a / e) for e, a in zip(expected, actual))
print("psi:", round(psi_value, 4))
--- test
assert abs(psi_value - 0.8789) < 1e-4, f"The index for these distributions is 0.8789, but the code gives {psi_value:.4f}. The log ratio is actual over expected."
--- hint
Each term must be positive when the actual share exceeds the expected share.
--- hint
Write `math.log(a / e)`.
```

## Predict the index

```python predict id=predict-psi title="What is the index of a distribution against itself?"
import math
e = [0.5, 0.5]
a = [0.5, 0.5]
print(round(sum((x - y) * math.log(x / y) for x, y in zip(a, e)), 3))
--- options
* 0.0
1.0
0.5
-1.0
--- explain
Every term has a difference of zero, so the sum is zero.
```

## Recap

- Drift compares the binned distribution of a feature in production with the reference.
- The population stability index is zero for identical distributions and grows as they diverge.
- Choose the bins from the reference, and read the index against agreed thresholds.

**Up next:** alerting and retraining rules, which turn drift scores into decisions.
