Users experience the slow requests, not the average one. A service with a fast median can still frustrate many people if its tail is long. Latency targets are therefore written as percentiles: p50 for the typical request and p95 or p99 for the tail. The nearest-rank method gives a percentile directly from a sorted list of measurements.

## Percentiles by nearest rank

The nearest-rank percentile takes the value at position ceiling of p times n over 100, counting from one.

```python run
import math

def percentile(values, p):
    s = sorted(values)
    rank = math.ceil(p / 100 * len(s))
    return s[max(rank, 1) - 1]

latencies = [12, 15, 14, 90, 13, 16, 18, 11, 14, 300]
print("p50:", percentile(latencies, 50), "| p90:", percentile(latencies, 90))
```

## The mean hides the tail

The average of these latencies is pulled up by two slow requests, and the median is not.

```python run
print("mean:", round(sum(latencies) / len(latencies), 1), "| p50:", percentile(latencies, 50))
```

## Checking a budget

A latency budget is met when the chosen percentile is within it.

```python run
budget_ms = 100
print("p95 within budget:", percentile(latencies, 95) <= budget_ms)
```

## Where the time goes

Total latency is the sum of the stages, and the largest stage is the one to optimize.

```python run
stages = {"queue": 4, "feature lookup": 12, "model": 38, "serialization": 3}
slowest = max(stages, key=stages.get)
print("total:", sum(stages.values()), "ms | slowest stage:", slowest)
```

> **Pitfall:** averages of percentiles are not percentiles. Compute the percentile over the raw measurements, and do not average per-server percentiles.

> **In the wild:** service dashboards show p50, p95 and p99 over time, and an alert fires when the budget is exceeded for a sustained period.

## Challenge: nearest-rank percentile

```python exercise id=percentile title="Nearest-rank percentile"
import math

# TODO: `percentile(values, p)` returns the nearest-rank percentile: sort the values, take rank = ceil(p / 100 × n), and return
# the value at position rank counted from one. Use rank 1 when the rank would be zero.
def percentile(values, p):
    ...
--- solution
import math

def percentile(values, p):
    s = sorted(values)
    rank = math.ceil(p / 100 * len(s))
    return s[max(rank, 1) - 1]
--- test
data = list(range(1, 11))
assert percentile(data, 50) is not None, "Replace the `...` in `percentile` with code that returns the value."
assert percentile(data, 50) == 5, f"The 50th percentile of 1 to 10 is 5, but you returned {percentile(data, 50)}."
assert percentile(data, 95) == 10, "The 95th percentile of 1 to 10 is 10."
assert percentile(data, 10) == 1, "The 10th percentile of 1 to 10 is 1."
--- hint
Sort first, then find the rank, then subtract one to index the list.
--- hint
`s[math.ceil(p / 100 * len(s)) - 1]`, guarding against a rank of zero.
```

## Challenge: within budget

```python exercise id=within-budget title="Does a percentile meet the budget?"
import math

def percentile(values, p):
    s = sorted(values)
    rank = math.ceil(p / 100 * len(s))
    return s[max(rank, 1) - 1]

# TODO: `within_budget(latencies, budget_ms, p=95)` returns True when the nearest-rank percentile p of the latencies is at most
# budget_ms. The function percentile above is provided.
def within_budget(latencies, budget_ms, p=95):
    ...
--- solution
import math

def percentile(values, p):
    s = sorted(values)
    rank = math.ceil(p / 100 * len(s))
    return s[max(rank, 1) - 1]

def within_budget(latencies, budget_ms, p=95):
    return percentile(latencies, p) <= budget_ms
--- test
result = within_budget([10, 20, 30, 400], 100)
assert result is not None, "Replace the `...` in `within_budget` with code that returns the check."
assert result is False, "The 95th percentile here is 400, which is over the budget of 100."
assert within_budget([10, 20, 30], 100) is True, "The 95th percentile of these values is 30, within the budget."
--- hint
Compare the percentile to the budget with `<=`.
--- hint
`percentile(latencies, p) <= budget_ms`.
```

## Debug: a percentile off by one

The median of five values should be the third, but the index is taken as the rank itself, which is one position too far.

```python debug id=percentile-index title="Index the list from one"
import math
values = [1, 2, 3, 4, 5]
p = 50
s = sorted(values)
rank = math.ceil(p / 100 * len(s))
value = s[rank]                      # bug: nearest rank counts from one, so the index is rank - 1
print("p50:", value)
--- solution
import math
values = [1, 2, 3, 4, 5]
p = 50
s = sorted(values)
rank = math.ceil(p / 100 * len(s))
value = s[rank - 1]
print("p50:", value)
--- test
assert value == 3, f"The median of 1 to 5 is 3, but the code gives {value}. Subtract one from the rank to index the list."
--- hint
The third of five values has rank 3 and index 2.
--- hint
Use `s[rank - 1]`.
```

## Predict the median

```python predict id=predict-median title="What is the nearest-rank p50 of 1 to 5?"
import math
s = [1, 2, 3, 4, 5]
print(s[math.ceil(0.5 * len(s)) - 1])
--- options
* 3
2
4
5
--- explain
The rank is ceiling of 2.5, which is 3, so the value at position 3 is 3.
```

## Recap

- Report latency as percentiles, and set budgets on the tail.
- The nearest-rank method is exact and easy to check.
- Find the slowest stage before optimizing anything.

**Up next:** data drift, and how to detect that the inputs have changed.
