Randomness is everywhere in data work. You shuffle a dataset before splitting it, initialize neural-network weights, bootstrap a confidence interval, simulate a million customers, or add noise to test a model's robustness. All of it needs random numbers that are **fast**, **statistically sound** and, crucially, **reproducible**. If you can't rerun an experiment and get the same result, you can't debug it.

NumPy's modern random API, built around `np.random.default_rng`, gives you all three. In this lesson you'll learn how to create and seed a generator, draw numbers from common distributions in any shape, sample and shuffle, run your first simulation, and avoid the seeding mistakes that make experiments silently non-reproducible.

## Meet the Generator

Everything starts with one line:

```python run
import numpy as np

rng = np.random.default_rng(42)   # 42 is the seed

print(rng.random(3))              # floats in [0, 1)
print(rng.integers(1, 7, size=10))  # dice rolls: 1..6
```

`rng` is a **`Generator`** object. You call methods on it to draw random numbers, and it keeps track of its own internal state. The **seed** (`42` here) fixes the starting state, so the sequence of numbers is completely determined by it.

> **Pitfall:** `rng.integers(low, high)` follows the same half-open convention as `range` and `arange`: `high` is **excluded**. A six-sided die is `rng.integers(1, 7)`, not `rng.integers(1, 6)`, which would never roll a 6.

### Same seed, same numbers

Reproducibility is the whole point of seeding. Two generators created with the same seed produce the identical sequence:

```python run
a = np.random.default_rng(2024)
b = np.random.default_rng(2024)

print(a.normal(size=4))
print(b.normal(size=4))

c = np.random.default_rng()       # no seed: fresh entropy from the OS
print(c.normal(size=4))           # different every time you run this cell
```

Without a seed, `default_rng()` pulls entropy from your operating system and you get different numbers each run. That's fine for a game, but for experiments you want to reproduce, **always seed**.

```python predict id=predict-same-seed title="Are these equal?"
x = np.random.default_rng(5).random()
y = np.random.default_rng(5).random()
print(x == y)
--- options
* True
False
It depends on the time of day
It raises an error
--- explain
Both generators start from the **same seed**, so they are in the same state and produce the same first number. This is exactly what makes seeded experiments reproducible.
```

### Why not `np.random.seed`?

You'll see a lot of older code like `np.random.seed(0)` followed by `np.random.rand(3)`. That **legacy API** uses one hidden, global generator shared by your whole program and every library you import.

| | Legacy `np.random.rand(...)` | Modern `rng = np.random.default_rng(seed)` |
|---|---|---|
| State | One hidden global | Explicit object you pass around |
| Isolation | Any library call can change your sequence | Each generator is independent |
| Algorithm | Mersenne Twister | PCG64: faster, better statistical properties |
| Recommended | Only for old code | **Yes**, NumPy's official recommendation |

With the legacy API, if a library you call happens to draw one random number, every number *you* draw afterwards changes. With an explicit `Generator`, that can't happen.

## Distributions and shapes

Every `Generator` method accepts a `size=` argument, which is a **shape**, exactly like `np.zeros`. Pass an int for 1-D or a tuple for more dimensions:

```python run
rng = np.random.default_rng(0)

print("uniform:", rng.uniform(-1, 1, size=3))
print("normal:\n", rng.normal(loc=170, scale=8, size=(2, 3)))   # heights in cm
print("integers:\n", rng.integers(0, 10, size=(2, 5)))
```

The methods you'll use most often:

| Method | Draws |
|---|---|
| `rng.random(size)` | Floats uniformly in $[0, 1)$ |
| `rng.uniform(low, high, size)` | Floats uniformly in $[\text{low}, \text{high})$ |
| `rng.integers(low, high, size)` | Integers in $[\text{low}, \text{high})$ |
| `rng.normal(loc, scale, size)` | Gaussian with mean `loc` and standard deviation `scale` |
| `rng.choice(a, size, replace, p)` | Samples from an array, optionally weighted |
| `rng.permutation(a)` / `rng.shuffle(a)` | Random reordering |

```python predict id=predict-size-shape title="What shape comes out?"
rng = np.random.default_rng(0)
rolls = rng.integers(1, 7, size=(3, 2))
print(rolls.shape)
--- options
(6,)
* (3, 2)
(2, 3)
(3,)
--- explain
`size=` is a **shape**, just like the argument to `np.zeros`. `size=(3, 2)` gives 3 rows and 2 columns of dice rolls.
```

```python exercise id=roll-dice title="Roll a thousand dice"
rng = np.random.default_rng(7)

# Use `rng` to simulate 1000 rolls of a fair six-sided die.
# `rolls` should be a 1-D integer array with values from 1 to 6.
rolls = ...
--- solution
rng = np.random.default_rng(7)

rolls = rng.integers(1, 7, size=1000)
--- test
assert rolls is not ..., "Replace the `...` with a call on `rng`."
assert isinstance(rolls, np.ndarray), f"`rolls` should be a NumPy array, not {type(rolls).__name__}."
assert rolls.shape == (1000,), f"`rolls` should hold 1000 rolls in a 1-D array, but has shape {rolls.shape}."
assert np.issubdtype(rolls.dtype, np.integer), f"Dice rolls are whole numbers, but `rolls` has dtype {rolls.dtype}."
assert rolls.min() >= 1, f"A die can't roll {rolls.min()}. The lowest face is 1."
assert rolls.max() <= 6, f"A die can't roll {rolls.max()}. The highest face is 6."
assert 6 in rolls, "In 1000 rolls, a 6 never appeared. Remember `high` is exclusive in `rng.integers(low, high)`."
assert len(np.unique(rolls)) == 6, "Every face from 1 to 6 should appear at least once in 1000 rolls."
--- hint
`rng.integers(low, high, size=...)` draws integers. Which values of `low` and `high` give the faces 1 through 6?
--- hint
`high` is excluded, so it needs to be one more than the largest face.
```

## Sampling and shuffling

`rng.choice` picks elements from an array. By default it samples **with replacement**, so the same element can be picked more than once. Pass `replace=False` for distinct picks, and `p=` to weight the options:

```python run
rng = np.random.default_rng(1)
colors = np.array(["red", "green", "blue", "gold"])

print("with replacement:   ", rng.choice(colors, size=6))
print("without replacement:", rng.choice(colors, size=3, replace=False))
print("weighted:           ", rng.choice(colors, size=8, p=[0.7, 0.1, 0.1, 0.1]))
```

To reorder data there are two methods, and the difference matters:

```python run
rng = np.random.default_rng(3)
deck = np.arange(10)

shuffled = rng.permutation(deck)   # returns a NEW shuffled copy
print("permutation:", shuffled, "| original:", deck)

rng.shuffle(deck)                  # shuffles IN PLACE, returns None
print("after shuffle:", deck)
```

> **Pitfall:** `deck = rng.shuffle(deck)` is a classic bug. `shuffle` works in place and returns `None`, so you just replaced your data with `None`. Use `permutation` when you want the result as a new array.

```python exercise id=train-test-split title="Split a dataset randomly"
rng = np.random.default_rng(0)
samples = np.arange(100)   # stand-ins for 100 data points

# Randomly split `samples` into:
#   `train`: 80 samples
#   `test`:  the other 20
# Every sample must land in exactly one of the two sets,
# and the split must be random (not simply the first 80).
train = ...
test = ...
--- solution
rng = np.random.default_rng(0)
samples = np.arange(100)

shuffled = rng.permutation(samples)
train = shuffled[:80]
test = shuffled[80:]
--- test
assert train is not ... and test is not ..., "Replace both `...` placeholders with your code."
assert isinstance(train, np.ndarray) and isinstance(test, np.ndarray), "`train` and `test` should both be NumPy arrays."
assert len(train) == 80, f"`train` should hold 80 samples, but it has {len(train)}."
assert len(test) == 20, f"`test` should hold 20 samples, but it has {len(test)}."
assert len(np.intersect1d(train, test)) == 0, "Some samples appear in both `train` and `test`. The sets must not overlap."
assert np.array_equal(np.sort(np.concatenate([train, test])), np.arange(100)), "Together, `train` and `test` should contain every sample exactly once."
assert not np.array_equal(np.sort(train), np.arange(80)), "`train` is just the first 80 samples. The split needs to be random. Shuffle first."
--- hint
Shuffle a copy of `samples` first, then cut it into two pieces.
--- hint
`shuffled = rng.permutation(samples)`, then slice: `shuffled[:80]` takes the first 80 elements and `shuffled[80:]` takes the rest.
```

## Your first simulation: two dice

What's the probability that two dice add up to 7? You could work it out by hand ($6/36 \approx 0.167$), or you can **simulate** it: roll a million pairs and count. This is the *Monte Carlo method*, and with NumPy it's three lines:

```python run
import matplotlib.pyplot as plt

rng = np.random.default_rng(0)
n = 100_000
totals = rng.integers(1, 7, size=n) + rng.integers(1, 7, size=n)

print("P(total == 7) ≈", (totals == 7).mean())

values, counts = np.unique(totals, return_counts=True)
plt.bar(values, counts / n, color="#4C6EF5")
plt.xticks(values)
plt.xlabel("sum of two dice")
plt.ylabel("probability")
plt.show()
```

`np.unique(..., return_counts=True)` returns each distinct total with how often it occurred, and the bars reveal the famous triangle: 7 is the most likely sum. `totals == 7` compares every element and gives an array of `True`/`False`. The mean of a boolean array is the **fraction** of `True`s, because `True` counts as 1 and `False` as 0. You'll use this trick constantly; boolean arrays get a full lesson later.

## Independent streams with `spawn`

Sometimes you need several random streams that don't interfere: one per worker process, per experiment arm, or per simulated agent. Don't create them with seeds `0, 1, 2…` by hand. Ask a generator to **spawn** statistically independent children:

```python run
parent = np.random.default_rng(42)
workers = parent.spawn(3)

for i, w in enumerate(workers):
    print(f"worker {i}:", w.integers(0, 100, size=5))
```

The whole family is still reproducible from the single seed `42`, but each child produces its own independent sequence.

```python debug id=identical-trials title="Every trial gives the same result"
# Simulate 5 trials. In each, roll 3 dice and record the total.
results = []
for trial in range(5):
    rng = np.random.default_rng(0)
    results.append(rng.integers(1, 7, size=3).sum())

results = np.array(results)
print("totals per trial:", results)
--- solution
# Simulate 5 trials. In each, roll 3 dice and record the total.
rng = np.random.default_rng(0)
results = []
for trial in range(5):
    results.append(rng.integers(1, 7, size=3).sum())

results = np.array(results)
print("totals per trial:", results)
--- test
assert isinstance(results, np.ndarray), "`results` should be a NumPy array of totals."
assert results.shape == (5,), f"There should be one total per trial (5), but `results` has shape {results.shape}."
assert ((results >= 3) & (results <= 18)).all(), "Each total of three dice must be between 3 and 18."
assert len(set(results.tolist())) > 1, "All five trials still produce the same total. Each trial is starting from the same random state."
--- hint
Use **Debug** and watch `rng` being created. How many times does it happen, and with which seed?
--- hint
Re-seeding inside the loop resets the generator to the same state every time, so every trial draws the same numbers. Create the generator **once**, before the loop.
```

```python debug id=duplicate-winners title="Someone won twice"
rng = np.random.default_rng(2)
entrants = np.array(["Ana", "Ben", "Chen", "Dev", "Eli",
                     "Fay", "Gus", "Hana", "Ivo", "Jia"])

# Pick 8 DIFFERENT people for a focus group.
chosen = rng.choice(entrants, size=8)
print(chosen)
--- solution
rng = np.random.default_rng(2)
entrants = np.array(["Ana", "Ben", "Chen", "Dev", "Eli",
                     "Fay", "Gus", "Hana", "Ivo", "Jia"])

# Pick 8 DIFFERENT people for a focus group.
chosen = rng.choice(entrants, size=8, replace=False)
print(chosen)
--- test
assert isinstance(chosen, np.ndarray), "`chosen` should be a NumPy array."
assert len(chosen) == 8, f"The focus group needs 8 people, but `chosen` has {len(chosen)}."
assert set(chosen.tolist()) <= set(entrants.tolist()), "Everyone in `chosen` must come from `entrants`."
assert len(set(chosen.tolist())) == 8, f"Only {len(set(chosen.tolist()))} distinct people were chosen; some were picked more than once."
--- hint
Run it and read the names carefully. Does anyone appear twice?
--- hint
`rng.choice` samples **with replacement** by default. There's a keyword argument to turn that off.
```

## Recap

- Create one generator per experiment with `rng = np.random.default_rng(seed)` and draw everything from it.
- The same seed always reproduces the same sequence; no seed means fresh randomness every run.
- `size=` is a shape, exactly like `np.zeros`. `integers(low, high)` excludes `high`.
- `choice` samples with replacement unless you pass `replace=False`; `p=` adds weights.
- `permutation` returns a shuffled copy; `shuffle` works in place and returns `None`.
- Seed **once**, outside your loops, and use `rng.spawn(n)` for independent streams.

**Up next:** dtypes in depth. Why `uint8` pixels wrap around, why `0.1 + 0.2 != 0.3`, and how to choose the right precision.
