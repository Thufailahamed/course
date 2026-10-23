Most machine-learning projects fail before any model is trained, because the problem was framed badly. A model needs three things: a **target**, the thing you want to predict; **features**, the information you will use to predict it; and a **metric**, the number that says how good a prediction is. Once those three are clear, the algorithm is the easy part.

This lesson walks through the workflow on a realistic question: how much will a flat sell for? You will define the target and features, split the data so that the test set stays untouched, and measure a baseline that every model must beat.

## Frame the problem

Write the question as a sentence with a prediction in it. "Predict the sale price of a flat, in thousands of euros, from its size, floor and age, so that the agency can set a listing price." Then fill in the three parts:

| Part | Here |
|---|---|
| Target | sale price (thousands of euros) |
| Features | size (m²), floor, age (years) |
| Metric | mean absolute error, in thousands of euros |

The metric matters as much as the model. Mean absolute error reads directly as "we are typically off by this much", which is the question the agency asks.

## Build a dataset

The data below are generated, so you can see exactly how they were made. Real data is never this clean, and the workflow stays the same.

```python run
import numpy as np

rng = np.random.default_rng(42)
n = 200
size = rng.uniform(35, 140, n)
floor = rng.integers(0, 12, n).astype(float)
age = rng.uniform(0, 60, n)
price = 2.8 * size + 3.0 * floor - 0.9 * age + 40 + rng.normal(0, 15, n)

X = np.column_stack([size, floor, age])      # one row per flat, one column per feature
y = price                                     # the target
print("features:", X.shape, "| target:", y.shape)
print("first flat:", X[0].round(1), "→ price", round(y[0], 1))
```

## Split before you look

The test set plays the role of the future. It must stay out of every decision you make while building the model, including the choice of baseline. Split the rows once, at random, with a fixed seed so the split is reproducible.

```python run
order = rng.permutation(n)
n_test = int(0.2 * n)
test_idx, train_idx = order[:n_test], order[n_test:]
print("training flats:", len(train_idx), "| test flats:", len(test_idx))
```

Before modelling, look at the target itself. A model that predicts a target nobody understands is a model nobody will trust.

```python run
print("price range:", round(y.min(), 1), "to", round(y.max(), 1), "thousand euros")
print("median price:", round(float(np.median(y)), 1))
print("flats above 300k:", int((y > 300).sum()), "of", len(y))
```

## A baseline everyone must beat

Before any model, predict the average training price for every test flat. The error of this guess is the bar a real model has to clear.

```python run
baseline = y[train_idx].mean()
baseline_mae = np.mean(np.abs(y[test_idx] - baseline))
print("baseline guess:", round(baseline, 1), "thousand euros")
print("baseline mean absolute error:", round(baseline_mae, 1), "thousand euros")
```

A model that cannot beat "guess the average" is not yet useful, however sophisticated it looks. This baseline is the first thing to report in any project.

> **Pitfall:** do not choose the baseline, the features or the model by looking at the test set. Every decision made by peeking turns the test score into an optimistic guess.

## Challenge: a reproducible split

```python exercise id=split-indices title="A reproducible train and test split"
import numpy as np

# TODO: `split_indices(n, test_fraction, seed)` returns a tuple (train_idx, test_idx) of integer arrays.
# Shuffle the numbers 0 to n-1 with np.random.default_rng(seed). The test part holds int(test_fraction * n)
# rows. The two arrays must not share any index, and together they must cover every row.
def split_indices(n, test_fraction, seed):
    ...
--- solution
import numpy as np

def split_indices(n, test_fraction, seed):
    order = np.random.default_rng(seed).permutation(n)
    n_test = int(test_fraction * n)
    return order[n_test:], order[:n_test]
--- test
import numpy as np
result = split_indices(10, 0.3, 0)
assert result is not None, "Replace the `...` in `split_indices` with code that returns (train_idx, test_idx)."
train_idx, test_idx = result
assert len(test_idx) == 3 and len(train_idx) == 7, f"With 10 rows and a 30% test fraction there should be 3 test rows and 7 training rows, but you returned {len(train_idx)} and {len(test_idx)}."
assert set(train_idx) & set(test_idx) == set(), "A row must not appear in both the training and the test set."
assert sorted(list(train_idx) + list(test_idx)) == list(range(10)), "Every row should appear exactly once."
again = split_indices(10, 0.3, 0)
assert np.array_equal(again[1], test_idx), "The same seed must give the same split."
--- hint
Use `np.random.default_rng(seed).permutation(n)` to get shuffled row numbers. Cut off the first `n_test` of them for the test set.
--- hint
`order = np.random.default_rng(seed).permutation(n)`, `n_test = int(test_fraction * n)`, then return the rest and the first part.
```

## Challenge: the baseline error

```python exercise id=baseline-error title="The error of a constant guess"
import numpy as np

# TODO: `baseline_mae(y_train, y_test)` predicts the training mean for every test value and returns the
# mean absolute error of that guess.
def baseline_mae(y_train, y_test):
    ...
--- solution
import numpy as np

def baseline_mae(y_train, y_test):
    guess = np.mean(y_train)
    return float(np.mean(np.abs(np.asarray(y_test) - guess)))
--- test
import numpy as np
result = baseline_mae(np.array([1.0, 3.0]), np.array([2.0, 6.0]))
assert result is not None, "Replace the `...` in `baseline_mae` with code that returns the error."
assert np.isclose(result, 2.0), f"The guess is the training mean 2. The errors are |2 − 2| = 0 and |6 − 2| = 4, whose mean is 2, but you returned {result!r}."
assert np.isclose(baseline_mae([5.0], [5.0, 5.0]), 0.0), "A perfect guess has zero error."
--- hint
Compute the training mean first. Then take the absolute differences from the test values and average them.
--- hint
`guess = np.mean(y_train)` and `return float(np.mean(np.abs(np.asarray(y_test) - guess)))`.
```

## Debug the overlap

This split is meant to hold out 20% of the flats, but the two parts overlap, so some flats are both trained on and tested on.

```python debug id=overlap-split title="Keep training and test rows apart"
import numpy as np

rng = np.random.default_rng(0)
n = 10
order = rng.permutation(n)
cut = int(0.8 * n)
train_idx = order[:cut]
test_idx = order[:n - cut]          # bug: the test rows are taken from the start of the training rows
print("train:", train_idx, "test:", test_idx)
--- solution
import numpy as np

rng = np.random.default_rng(0)
n = 10
order = rng.permutation(n)
cut = int(0.8 * n)
train_idx = order[:cut]
test_idx = order[cut:]
print("train:", train_idx, "test:", test_idx)
--- test
assert set(train_idx) & set(test_idx) == set(), f"No row may be in both sets, but these overlap: {set(train_idx) & set(test_idx)}. The test rows must come from after the training rows."
assert len(test_idx) == 2, "The test set should hold the remaining 2 rows."
--- hint
In a split, the training rows and the test rows are different slices of the same shuffled order.
--- hint
Take the test rows from `order[cut:]`, the part after the training rows.
```

## Predict the split size

```python predict id=predict-split title="How many training flats are there?"
n = 150
test_fraction = 0.2
n_test = int(test_fraction * n)
print(n - n_test)
--- options
* 120
30
150
100
--- explain
Twenty per cent of 150 is 30 test flats, so 120 remain for training. The training and test parts together always add up to the full dataset.
```

## Recap

- Frame the problem with a target, features and a metric before you model anything.
- Split the data once, at random, with a fixed seed, and keep the test set untouched.
- Measure a baseline first. A model must beat it to be worth anything.
- Overlapping training and test rows make every score dishonest.

**Up next:** your first model, linear regression, and the closed-form solution behind it.
