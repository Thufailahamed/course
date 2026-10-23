An experiment is a training run with its parameters and metrics recorded. Tracking makes runs comparable: you can see which settings produced which score, and you can reproduce the best one. Without tracking, the best result is remembered rather than recorded, and a regression goes unnoticed until someone asks why the model got worse.

## A run registry

Each run stores its parameters and its metrics as data, so the registry can be searched.

```python run
runs = [
    {"name": "run-a", "params": {"lr": 0.1, "depth": 4}, "metrics": {"accuracy": 0.81}},
    {"name": "run-b", "params": {"lr": 0.01, "depth": 4}, "metrics": {"accuracy": 0.88}},
    {"name": "run-c", "params": {"lr": 0.01, "depth": 6}, "metrics": {"accuracy": 0.79}},
]
for r in runs:
    print(r["name"], r["params"], r["metrics"])
```

## The best run

The best run is the one with the highest value of the chosen metric.

```python run
best = max(runs, key=lambda r: r["metrics"]["accuracy"])
print("best run:", best["name"], best["metrics"]["accuracy"])
```

## What differs between two runs

When two runs disagree, the parameters that differ are the first place to look.

```python run
def diff_params(a, b):
    keys = set(a) | set(b)
    return sorted(k for k in keys if a.get(k) != b.get(k))

print("differences between run-a and run-b:", diff_params(runs[0]["params"], runs[1]["params"]))
```

## Seeds and repeats

A single run can be lucky. Repeating a run with several seeds shows the spread of the result.

```python run
seed_scores = [0.86, 0.88, 0.85, 0.87]
mean = sum(seed_scores) / len(seed_scores)
spread = max(seed_scores) - min(seed_scores)
print(f"mean {mean:.3f}, spread {spread:.3f}")
```

> **Pitfall:** choosing the best of many runs on the test set inflates the score. Select on a validation set and report the test score once.

> **In the wild:** teams log every run to a shared tracker with the code version and data fingerprint, so a result is reproducible months later.

## Challenge: the best run

```python exercise id=best-run title="The run with the highest metric"
# TODO: `best_run(runs, metric)` takes a list of runs, each a dictionary with a "metrics" mapping, and returns the run whose
# value for metric is highest. If runs tie, return the earliest one.
def best_run(runs, metric):
    ...
--- solution
def best_run(runs, metric):
    return max(runs, key=lambda r: r["metrics"][metric])
--- test
runs = [{"name": "x", "metrics": {"acc": 0.7}}, {"name": "y", "metrics": {"acc": 0.9}}, {"name": "z", "metrics": {"acc": 0.9}}]
result = best_run(runs, "acc")
assert result is not None, "Replace the `...` in `best_run` with code that returns the run."
assert result["name"] == "y", f"y and z tie at 0.9 and y comes first, so y is the best run, but you returned {result['name']}."
--- hint
`max` with a `key` function returns the first maximum it finds.
--- hint
`max(runs, key=lambda r: r["metrics"][metric])`.
```

## Challenge: parameter differences

```python exercise id=diff-params title="Which parameters differ"
# TODO: `diff_params(a, b)` takes two parameter dictionaries and returns the sorted list of keys whose values differ, including
# keys present in only one of them.
def diff_params(a, b):
    ...
--- solution
def diff_params(a, b):
    keys = set(a) | set(b)
    return sorted(k for k in keys if a.get(k) != b.get(k))
--- test
result = diff_params({"lr": 0.1, "depth": 4}, {"lr": 0.01, "depth": 4, "warmup": 3})
assert result is not None, "Replace the `...` in `diff_params` with code that returns the keys."
assert result == ["lr", "warmup"], f"lr changed and warmup is only in the second run, so the result is ['lr', 'warmup'], but you returned {result}."
assert diff_params({"a": 1}, {"a": 1}) == [], "Identical parameters have no differences."
--- hint
Use the union of the two key sets, and compare with `get` so a missing key counts as a difference.
--- hint
`sorted(k for k in keys if a.get(k) != b.get(k))`.
```

## Debug: picking the worst run

The best run should have the highest accuracy, but this version picks the lowest.

```python debug id=min-not-max title="Pick the highest metric, not the lowest"
runs = [{"name": "a", "acc": 0.81}, {"name": "b", "acc": 0.88}]
best = min(runs, key=lambda r: r["acc"])          # bug: min returns the lowest score
print("best:", best["name"])
--- solution
runs = [{"name": "a", "acc": 0.81}, {"name": "b", "acc": 0.88}]
best = max(runs, key=lambda r: r["acc"])
print("best:", best["name"])
--- test
assert best["name"] == "b", f"Run b has the higher accuracy, so it is the best run, but the code picks {best['name']}. Use max, not min."
--- hint
Higher accuracy is better.
--- hint
Use `max` for a metric where larger is better.
```

## Predict the best accuracy

```python predict id=predict-best title="What is the best accuracy among 0.81, 0.88 and 0.79?"
print(max([0.81, 0.88, 0.79]))
--- options
* 0.88
0.81
0.79
0.83
--- explain
The largest of the three values is 0.88.
```

## Recap

- Record the parameters and metrics of every run, and compare them.
- Select on validation data, and report the test score once.
- Repeat runs with several seeds to see the spread.

**Up next:** pipelines, and the order in which their tasks must run.
