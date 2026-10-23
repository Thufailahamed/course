This capstone runs a monitored model end to end. A reference distribution is fixed at training time. Each day, a batch of production inputs arrives, its drift score is computed against the reference, and the level and retraining decision are recorded. The inputs drift partway through, and the monitoring should notice, persist and recommend retraining.

## The reference and the bins

The reference sample is drawn once, and the bins are set from it, as the drift lesson recommends.

```python run
import numpy as np

rng = np.random.default_rng(13)
reference = rng.normal(0, 1, 5000)
edges = np.linspace(-4, 4, 9)
ref_p = np.histogram(reference, bins=edges)[0] / len(reference)
print("reference shares:", np.round(ref_p, 3))
```

## A simulated week

The first four days come from the training distribution, and the rest are shifted. Each day's batch gets a score.

```python run
import math

def psi(expected, actual):
    return sum((a - e) * math.log(a / e) for e, a in zip(expected, actual))

days = []
for day in range(8):
    shift = 0.0 if day < 4 else 1.2
    batch = rng.normal(shift, 1, 500)
    act_p = np.histogram(batch, bins=edges)[0] / len(batch)
    act_p = np.clip(act_p, 1e-6, None)
    days.append(round(psi(np.clip(ref_p, 1e-6, None), act_p), 3))
print("daily PSI:", days)
```

## Levels and the retraining decision

The levels and the persistence rule from the monitoring lesson are applied to the daily scores.

```python run
def alert_level(v):
    return "ok" if v < 0.1 else ("watch" if v < 0.2 else "alert")

print("levels:", [alert_level(v) for v in days])
print("retrain the model after the week:", all(v > 0.2 for v in days[-3:]))
```

> **Pitfall:** the clipping of tiny proportions keeps the log finite, but it also changes the score of empty bins. Report the bin count with every score, so an empty bin is visible.

> **In the wild:** a monitoring capstone like this one becomes a scheduled job that writes scores to a dashboard, so the on-call engineer sees the shift before users do.

## Challenge: the daily report

```python exercise id=daily-report title="Summarize the drift alerts for the week"
# TODO: `daily_report(days_psi, threshold, consecutive)` returns a dictionary with "alerts", the zero-based indices of the days
# whose level is "alert", and "retrain", True when should_retrain on the list is True. The functions below are provided.
def alert_level(v):
    return "ok" if v < 0.1 else ("watch" if v < 0.2 else "alert")

def should_retrain(daily, threshold=0.2, consecutive=3):
    if len(daily) < consecutive:
        return False
    return all(v > threshold for v in daily[-consecutive:])

def daily_report(days_psi, threshold, consecutive):
    ...
--- solution
def alert_level(v):
    return "ok" if v < 0.1 else ("watch" if v < 0.2 else "alert")

def should_retrain(daily, threshold=0.2, consecutive=3):
    if len(daily) < consecutive:
        return False
    return all(v > threshold for v in daily[-consecutive:])

def daily_report(days_psi, threshold, consecutive):
    alerts = [i for i, v in enumerate(days_psi) if alert_level(v) == "alert"]
    return {"alerts": alerts, "retrain": should_retrain(days_psi, threshold, consecutive)}
--- test
result = daily_report([0.05, 0.25, 0.3, 0.4], 0.2, 3)
assert result is not None, "Replace the `...` in `daily_report` with code that returns the report."
assert result == {"alerts": [1, 2, 3], "retrain": True}, f"Days 1 to 3 are alerts, and the last three exceed 0.2, but you returned {result}."
assert daily_report([0.05, 0.05], 0.2, 3) == {"alerts": [], "retrain": False}, "A calm week has no alerts and no retraining."
--- hint
Enumerate the scores to get zero-based day indices, and reuse `should_retrain`.
--- hint
`[i for i, v in enumerate(days_psi) if alert_level(v) == "alert"]`.
```

## Challenge: count the alerts

The level function is provided, and your task is to count the days at the alert level.

```python exercise id=count-alerts title="Count the days at the alert level"
def alert_level(v):
    return "ok" if v < 0.1 else ("watch" if v < 0.2 else "alert")

# TODO: `count_alerts(days_psi)` returns how many scores in the list have the level "alert".
def count_alerts(days_psi):
    ...
--- solution
def alert_level(v):
    return "ok" if v < 0.1 else ("watch" if v < 0.2 else "alert")

def count_alerts(days_psi):
    return sum(alert_level(v) == "alert" for v in days_psi)
--- test
result = count_alerts([0.05, 0.25, 0.3])
assert result is not None, "Replace the `...` in `count_alerts` with code that returns the count."
assert result == 2, f"0.25 and 0.3 are alerts, so the count is 2, but you returned {result}."
assert count_alerts([0.01, 0.02]) == 0, "A calm week has no alerts."
--- hint
Sum a boolean over the scores, using the provided `alert_level`.
--- hint
`sum(alert_level(v) == "alert" for v in days_psi)`.
```

## Debug: days numbered from one

The alert days should be zero-based indices, but the enumeration starts at one, so every day is labelled one later.

```python debug id=day-index title="Number the days from zero"
days = [0.05, 0.25, 0.3, 0.4]
alerts = [i for i, v in enumerate(days, start=1) if v >= 0.2]   # bug: days are numbered from zero
print("alert days:", alerts)
--- solution
days = [0.05, 0.25, 0.3, 0.4]
alerts = [i for i, v in enumerate(days) if v >= 0.2]
print("alert days:", alerts)
--- test
assert alerts == [1, 2, 3], f"The alert days are the second to fourth entries, which are indices 1, 2 and 3, but the code gives {alerts}. Enumerate from zero."
--- hint
The first entry of a list has index zero.
--- hint
Remove `start=1`.
```

## Counting the levels

A summary of the levels across the week is the first thing an on-call engineer reads.

```python run
from collections import Counter
print("levels:", Counter(alert_level(v) for v in days))
```

## Predict the alert count

```python predict id=predict-alerts title="How many of these daily scores are at least 0.2?"
days = [0.05, 0.25, 0.3]
print(sum(v >= 0.2 for v in days))
--- options
* 2
1
3
0
--- explain
Two scores, 0.25 and 0.3, are at least 0.2.
```

## Recap

- Fix the reference and its bins before monitoring starts.
- Score each day against the reference, and record the level.
- Recommend retraining only on sustained drift, and require an approved evaluation before deploying.

**Up next:** the final assessment covers the whole course.
