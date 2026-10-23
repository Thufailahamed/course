Raw data rarely answers questions on its own. *Who are the top ten customers? Which word appears most often? What does a typical order cost, and what does an unusually large one cost? Which bucket does each measurement fall into?* Answering questions like these means **ranking, searching, counting and summarizing**, and NumPy has a fast, vectorized tool for each.

In this lesson you'll learn to sort arrays (and sort one array *by another*), grab the top-k without sorting everything, count unique values, bin continuous data, and compute the robust statistics that analysts reach for every day: medians, percentiles, histograms and correlations.

## Sorting: `np.sort` versus `.sort()`

There are two ways to sort, and the difference matters:

- `np.sort(a)` returns a **new, sorted copy** and leaves `a` alone.
- `a.sort()` sorts `a` **in place** and returns `None`.

```python run
import numpy as np

temps = np.array([21.5, 18.0, 25.3, 19.9, 23.1])

sorted_copy = np.sort(temps)
print("np.sort :", sorted_copy)
print("original:", temps, "(unchanged)")

temps.sort()
print("after .sort():", temps, "(changed in place)")
```

Both sort in **ascending** order. NumPy has no `reverse=True` flag; to sort descending, reverse the result with a slice:

```python run
scores = np.array([72, 95, 88, 61, 79])
print("descending:", np.sort(scores)[::-1])
```

```python predict id=predict-sort-none title="What does this print?"
a = np.array([3, 1, 2])
result = a.sort()
print(result)
--- options
[1 2 3]
* None
[3 1 2]
[3 2 1]
--- explain
`.sort()` sorts **in place** and, like Python's `list.sort()`, returns `None`. `a` itself is now `[1 2 3]`, but `result` holds nothing. Writing `x = x.sort()` is a classic bug: it throws your data away.
```

### Sorting 2-D arrays

On a 2-D array, `np.sort` sorts along the **last axis** by default, so each row is sorted independently. Use `axis=0` to sort each column, or `axis=None` to flatten and sort everything.

```python run
M = np.array([[9, 2, 7],
              [4, 8, 1]])
print("axis=-1 (each row):\n", np.sort(M))
print("axis=0 (each column):\n", np.sort(M, axis=0))
print("axis=None (flattened):", np.sort(M, axis=None))
```

> **Pitfall:** sorting rows or columns independently **breaks the link between values in the same record**. If each row is a person, `np.sort(M, axis=0)` mixes up whose numbers are whose. To sort *records*, you need `argsort`.

## `argsort`: sort one array by another

`np.argsort(a)` doesn't return sorted values. It returns the **indices** that would sort `a`. That sounds abstract, but it's one of the most useful functions in NumPy: once you have the sorting order, you can apply it to *any* array that's aligned with `a`.

```python run
names = np.array(["Ada", "Grace", "Alan", "Linus", "Barbara"])
points = np.array([88, 95, 72, 95, 81])

order = np.argsort(points)
print("order:          ", order)
print("points[order]:  ", points[order])
print("names[order]:   ", names[order])        # names, sorted by points
print("highest first:  ", names[order[::-1]])
```

`points[order]` is just `np.sort(points)`, but `names[order]` puts the **names** in the order of their points. The two arrays stay aligned because both are reordered by the same index array.

> **Tip:** to sort descending by a numeric key, `np.argsort(-points)` is a neat alternative to reversing. It also keeps ties in their original order if you pass `kind="stable"`.

```python predict id=predict-argsort title="What does this print?"
print(np.argsort([30, 10, 20]))
--- options
[10 20 30]
* [1 2 0]
[2 0 1]
[0 1 2]
--- explain
The smallest value, 10, is at index **1**, the next, 20, is at index **2**, and the largest, 30, is at index **0**. `argsort` returns positions, not values.
```

```python exercise id=leaderboard title="Build a top-3 leaderboard"
players = np.array(["kai", "mira", "otto", "zoe", "lev", "ana", "ravi"])
scores = np.array([1840, 2310, 1595, 2720, 2105, 1990, 2480])

# TODO: the names of the 3 highest-scoring players, best first
top3 = ...

# TODO: their scores, in the same order (best first)
top3_scores = ...

print(top3, top3_scores)
--- solution
players = np.array(["kai", "mira", "otto", "zoe", "lev", "ana", "ravi"])
scores = np.array([1840, 2310, 1595, 2720, 2105, 1990, 2480])

order = np.argsort(scores)[::-1]
top3 = players[order[:3]]
top3_scores = scores[order[:3]]

print(top3, top3_scores)
--- test
assert top3 is not ..., "Replace the `...` after `top3 =` with your code."
assert top3_scores is not ..., "Replace the `...` after `top3_scores =` with your code."
_names = list(np.asarray(top3))
_vals = list(np.asarray(top3_scores))
assert len(_names) == 3, f"`top3` should contain exactly 3 names, but it has {len(_names)}."
assert set(_names) == {"zoe", "ravi", "mira"}, f"`top3` should be the three highest scorers, but you have {_names}. Are you sorting by score?"
assert _names == ["zoe", "ravi", "mira"], f"The names are right but the order isn't: {_names}. Best first, please (descending order)."
assert [int(v) for v in _vals] == [2720, 2480, 2310], f"`top3_scores` should be the matching scores, best first, but it is {_vals}."
--- hint
`np.argsort(scores)` gives the indices from lowest to highest score. How do you flip that order?
--- hint
`order = np.argsort(scores)[::-1]`, then index *both* arrays with `order[:3]`.
```

## Debug challenge: the mixed-up podium

A race organizer wants to announce the winner. The code sorts both arrays and reads off the first entries, yet it crowns the wrong runner. (Lower times are better.)

```python debug id=misaligned-sort title="The fastest time goes to the wrong runner"
runners = np.array(["Hana", "Diego", "Wen", "Felix", "Omar"])
times = np.array([12.48, 11.93, 12.05, 11.71, 12.30])   # seconds

sorted_runners = np.sort(runners)
sorted_times = np.sort(times)

winner = sorted_runners[0]
best_time = sorted_times[0]
print(f"Winner: {winner} in {best_time} s")
--- solution
runners = np.array(["Hana", "Diego", "Wen", "Felix", "Omar"])
times = np.array([12.48, 11.93, 12.05, 11.71, 12.30])   # seconds

order = np.argsort(times)
sorted_runners = runners[order]
sorted_times = times[order]

winner = sorted_runners[0]
best_time = sorted_times[0]
print(f"Winner: {winner} in {best_time} s")
--- test
assert np.isclose(best_time, 11.71), f"`best_time` should be the fastest time, 11.71 s, but it is {best_time}."
assert str(winner) == "Felix", f"The winner is announced as {str(winner)!r}, but {str(winner)!r} didn't run 11.71 s. Check which runner actually has that time."
assert list(np.asarray(sorted_runners)) == ["Felix", "Diego", "Wen", "Omar", "Hana"], "`sorted_runners` should list the runners from fastest to slowest."
--- hint
`np.sort(runners)` sorts the names **alphabetically**, completely independently of the times. The two arrays no longer line up.
--- hint
Compute the order once from the times with `np.argsort(times)`, then apply that same order to both arrays.
```

## Top-k without a full sort: `partition`

Sorting a million values to find the 10 largest is wasteful. `np.partition(a, kth)` rearranges the array so the element at position `kth` is exactly where it would be after sorting, with everything smaller before it and everything larger after it, **in no particular order**. That takes linear time instead of $O(n \log n)$.

```python run
rng = np.random.default_rng(0)
values = rng.integers(0, 1000, size=12)
print("values:     ", values)

p = np.partition(values, -3)      # the 3 largest end up in the last 3 slots
print("partitioned:", p)
print("3 largest (unordered):", p[-3:])
print("3 largest (sorted):   ", np.sort(p[-3:])[::-1])
```

`np.argpartition` is to `partition` what `argsort` is to `sort`: it gives you **indices**, so you can find *which* items are in the top-k.

```python run
idx = np.argpartition(values, -3)[-3:]
print("indices of the top 3:", idx)
print("their values:        ", values[idx])
```

```python exercise id=top-k title="A fast top_k function"
def top_k(values, k):
    """Return the k largest values of a 1-D array, sorted from largest to smallest."""
    # TODO: use np.partition (or argpartition) to avoid sorting the whole array,
    # then sort just those k values in descending order
    ...

data = np.array([5, 17, 3, 42, 8, 23, 16, 4])
print(top_k(data, 3))   # expected: [42 23 17]
--- solution
def top_k(values, k):
    """Return the k largest values of a 1-D array, sorted from largest to smallest."""
    largest = np.partition(values, -k)[-k:]
    return np.sort(largest)[::-1]

data = np.array([5, 17, 3, 42, 8, 23, 16, 4])
print(top_k(data, 3))
--- test
_r = top_k(np.array([5, 17, 3, 42, 8, 23, 16, 4]), 3)
assert _r is not None, "`top_k` returned None. Did you forget `return`?"
_r = np.asarray(_r)
assert _r.shape == (3,), f"`top_k(data, 3)` should return 3 values, but returned shape {_r.shape}."
assert set(_r.tolist()) == {42, 23, 17}, f"`top_k(data, 3)` should contain 42, 23 and 17, but returned {_r.tolist()}."
assert _r.tolist() == [42, 23, 17], f"Right values, wrong order: {_r.tolist()}. Return them largest first."
_rng = np.random.default_rng(8)
for _k in (1, 5, 20):
    _v = _rng.normal(size=200)
    _got = np.asarray(top_k(_v.copy(), _k))
    assert np.allclose(_got, np.sort(_v)[::-1][:_k]), f"`top_k` is wrong for k={_k} on random data."
--- hint
`np.partition(values, -k)` puts the k largest values into the last k positions, but not in order.
--- hint
Take `np.partition(values, -k)[-k:]`, sort just those, and reverse with `[::-1]`.
```

## Counting: `np.unique`

`np.unique` returns the sorted distinct values. With `return_counts=True` it also counts how many times each appears, which is a one-line frequency table.

```python run
words = np.array(["the", "cat", "sat", "on", "the", "mat", "the", "cat"])

vocab, counts = np.unique(words, return_counts=True)
for w, c in zip(vocab, counts):
    print(f"{w:>4}: {c}")
```

With `return_inverse=True` you also get, for every original element, the index of its value in the unique array. That's an instant **integer encoding** of categorical data, exactly what machine-learning models need:

```python run
colors = np.array(["red", "blue", "red", "green", "blue", "red"])
categories, codes = np.unique(colors, return_inverse=True)
print("categories:", categories)
print("codes:     ", codes)
print("decoded:   ", categories[codes])
```

For non-negative integers, `np.bincount` counts occurrences of each value from 0 up to the maximum, and it's even faster:

```python run
dice = np.array([3, 6, 1, 3, 3, 5, 6, 2, 3, 1])
print(np.bincount(dice))            # index i holds the count of value i
print(np.bincount(dice, minlength=7)[1:])  # faces 1..6
```

```python exercise id=most-common title="Find the most common item"
orders = np.array([
    "latte", "espresso", "latte", "mocha", "flat white", "latte",
    "espresso", "mocha", "latte", "flat white", "espresso", "latte",
])

# TODO: the drink ordered most often, and how many times it was ordered
favorite = ...
favorite_count = ...
print(favorite, favorite_count)
--- solution
orders = np.array([
    "latte", "espresso", "latte", "mocha", "flat white", "latte",
    "espresso", "mocha", "latte", "flat white", "espresso", "latte",
])

drinks, counts = np.unique(orders, return_counts=True)
favorite = drinks[counts.argmax()]
favorite_count = counts.max()
print(favorite, favorite_count)
--- test
assert favorite is not ..., "Replace the `...` after `favorite =` with your code."
assert favorite_count is not ..., "Replace the `...` after `favorite_count =` with your code."
assert str(favorite) == "latte", f"`favorite` should be the most frequently ordered drink, but it is {favorite!r}."
assert int(favorite_count) == 5, f"`favorite_count` should be how many times {favorite!r} was ordered, but it is {favorite_count!r}."
--- hint
`np.unique(orders, return_counts=True)` gives you two aligned arrays: the drinks and their counts.
--- hint
`counts.argmax()` is the position of the biggest count. Use it to index the drinks array.
```

## Searching and binning: `searchsorted` and `digitize`

`np.searchsorted(sorted_array, values)` finds, for each value, the index where it would be inserted to keep the array sorted. It uses binary search, so it's very fast. A natural use is looking things up in a table of thresholds:

```python run
thresholds = np.array([0, 18.5, 25, 30])        # BMI category boundaries
labels = np.array(["?", "underweight", "healthy", "overweight", "obese"])

bmis = np.array([17.2, 22.8, 27.5, 31.0, 24.99])
idx = np.searchsorted(thresholds, bmis, side="right")
print(idx)
print(labels[idx])
```

`np.digitize(x, bins)` answers the same question, "which bin does each value fall in?", phrased for binning: values below `bins[0]` get 0, values in `[bins[0], bins[1])` get 1, and so on.

```python exercise id=letter-grades title="Convert scores to letter grades"
scores = np.array([93, 67, 85, 59, 72, 100, 80, 89.5])

# Grade boundaries:  F < 60 <= D < 70 <= C < 80 <= B < 90 <= A
bins = np.array([60, 70, 80, 90])
letters = np.array(["F", "D", "C", "B", "A"])

# TODO: one letter per score, as a NumPy array, with no Python loop
grades = ...
print(grades)
--- solution
scores = np.array([93, 67, 85, 59, 72, 100, 80, 89.5])

bins = np.array([60, 70, 80, 90])
letters = np.array(["F", "D", "C", "B", "A"])

grades = letters[np.digitize(scores, bins)]
print(grades)
--- test
assert grades is not ..., "Replace the `...` after `grades =` with your code."
_g = [str(x) for x in np.asarray(grades).tolist()]
assert len(_g) == 8, f"`grades` should have one letter per score (8), but has {len(_g)}."
assert _g[3] == "F" and _g[0] == "A", f"93 should be an A and 59 an F. You have {_g[0]!r} and {_g[3]!r}."
assert _g[6] == "B", f"Exactly 80 is a B (the lower boundary belongs to the higher grade), but you have {_g[6]!r}."
assert _g == ["A", "D", "B", "F", "C", "A", "B", "B"], f"Some grades are wrong: {_g}."
--- hint
`np.digitize(scores, bins)` gives a bin number from 0 to 4 for each score.
--- hint
Use those bin numbers as indices into `letters`: `letters[np.digitize(scores, bins)]`.
```

## Robust statistics: median, percentiles and quantiles

The mean is sensitive to outliers; the **median**, the middle value, is not. One billionaire walking into a café changes the mean income enormously and the median barely at all.

```python run
incomes = np.array([32_000, 41_000, 38_500, 45_000, 36_000, 39_000, 2_500_000.0])

print(f"mean:   {incomes.mean():>12,.0f}")
print(f"median: {np.median(incomes):>12,.0f}")
```

**Percentiles** generalize the median: the 90th percentile is the value below which 90% of the data falls. `np.percentile` takes values from 0 to 100, and `np.quantile` is identical but takes fractions from 0 to 1.

```python run
rng = np.random.default_rng(42)
latency_ms = rng.lognormal(mean=3.0, sigma=0.5, size=10_000)   # skewed, like real latencies

p50, p95, p99 = np.percentile(latency_ms, [50, 95, 99])
print(f"p50 = {p50:.1f} ms   p95 = {p95:.1f} ms   p99 = {p99:.1f} ms")
print("same via quantile:", np.round(np.quantile(latency_ms, [0.5, 0.95, 0.99]), 1))
```

> **In the wild:** site-reliability engineers watch p95 and p99 latency rather than the mean, because the slowest 1% of requests are the ones users complain about.

### Histograms

`np.histogram` counts how many values fall in each bin. It returns the counts and the bin **edges**, and there's always one more edge than counts.

```python run
counts, edges = np.histogram(latency_ms, bins=6, range=(0, 120))
for c, lo, hi in zip(counts, edges[:-1], edges[1:]):
    print(f"{lo:5.0f}–{hi:<4.0f} ms {'█' * (c // 150)} {c}")
```

```python run
import matplotlib.pyplot as plt

plt.hist(latency_ms, bins=50, color="#4f7cff")
plt.axvline(p95, color="crimson", linestyle="--", label="p95")
plt.xlabel("latency (ms)")
plt.legend()
plt.show()
```

## Relationships: covariance and correlation

`np.corrcoef` measures how strongly variables move together, from $-1$ (perfectly opposite) through $0$ (no linear relationship) to $+1$ (perfectly together). It returns a **matrix**: entry $(i, j)$ is the correlation between variable $i$ and variable $j$, so the diagonal is always 1.

```python run
rng = np.random.default_rng(3)
hours_studied = rng.uniform(0, 10, size=50)
exam_score = 50 + 4 * hours_studied + rng.normal(scale=6, size=50)
phone_minutes = rng.uniform(0, 300, size=50)

R = np.corrcoef([hours_studied, exam_score, phone_minutes])
print(np.round(R, 2))
```

Studying correlates strongly with the score, and phone time (random in this fake data) barely at all. `np.cov` returns the covariance matrix in the same layout. It's the raw, unnormalized version that PCA uses.

> **Pitfall:** `np.corrcoef` and `np.cov` treat each **row** as a variable by default. If your data is laid out as `(samples, features)`, the usual layout, pass `rowvar=False` or transpose it first. Otherwise you'll get a giant samples-by-samples matrix.

```python debug id=percentile-scale title="The 90th-percentile report crashes"
response_times = np.array([120, 95, 210, 180, 99, 143, 300, 87, 160, 132])

# Report the median and the 90th percentile response time
median = np.quantile(response_times, 50)
p90 = np.quantile(response_times, 90)

print(f"median: {median:.1f} ms, p90: {p90:.1f} ms")
--- solution
response_times = np.array([120, 95, 210, 180, 99, 143, 300, 87, 160, 132])

median = np.quantile(response_times, 0.5)
p90 = np.quantile(response_times, 0.9)

print(f"median: {median:.1f} ms, p90: {p90:.1f} ms")
--- test
assert np.isclose(median, np.median(response_times)), f"`median` should be {np.median(response_times)}, but it is {median}."
assert np.isclose(p90, np.percentile(response_times, 90)), f"`p90` should be the 90th percentile, {np.percentile(response_times, 90):.1f}, but it is {p90}."
--- hint
Run it and read the error message carefully: what range does `np.quantile` expect?
--- hint
`np.quantile` takes fractions from 0 to 1, while `np.percentile` takes 0 to 100. Use `0.5` and `0.9`, or switch to `np.percentile`.
```

## Recap

- `np.sort(a)` returns a sorted copy; `a.sort()` sorts in place and returns `None`. Reverse with `[::-1]`.
- `np.argsort` returns the sorting **order**. Apply it to aligned arrays to sort records without scrambling them.
- `np.partition` / `np.argpartition` find the top-k in linear time.
- `np.unique(..., return_counts=True)` builds frequency tables, `return_inverse=True` encodes categories as integers, and `np.bincount` counts small non-negative ints.
- `np.searchsorted` and `np.digitize` map values to bins with no loops.
- Use the median and percentiles for skewed data, `np.histogram` for distributions, and `np.corrcoef` for relationships (mind `rowvar`).

**Up next:** NaN, infinity and the floating-point traps that bite every data scientist eventually.
