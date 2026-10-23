A drift score is only useful when it becomes a decision. Alerts should fire when a shift is real, not when one noisy day looks unusual. A retraining rule should require the shift to persist, and it should hand the decision to a person when the stakes are high. Writing these rules down as code makes them testable and reviewable.

## Levels from a score

A score is mapped to a level, so the response is consistent across features.

```python run
def alert_level(psi_value):
    if psi_value < 0.1:
        return "ok"
    if psi_value < 0.2:
        return "watch"
    return "alert"

for v in [0.05, 0.15, 0.3]:
    print(v, "->", alert_level(v))
```

## A single bad day

One day above the threshold can be noise. The rule below looks at the most recent days.

```python run
daily_psi = [0.05, 0.12, 0.31, 0.08, 0.25]
recent = daily_psi[-3:]
print("last three days:", recent, "| all above 0.2:", all(v > 0.2 for v in recent))
```

## Persistence before retraining

Retraining is expensive and should be deliberate. Requiring several consecutive days above the threshold guards against false alarms.

```python run
def should_retrain(daily, threshold=0.2, consecutive=3):
    if len(daily) < consecutive:
        return False
    return all(v > threshold for v in daily[-consecutive:])

print(should_retrain([0.1, 0.25, 0.3, 0.4]), should_retrain([0.3, 0.1, 0.3, 0.4]))
```

## A decision needs an approval

Even when the rule fires, a retrained model should be evaluated and approved before it replaces the one in production.

```python run
retrain_triggered = True
evaluation_better = True
approved = retrain_triggered and evaluation_better
print("deploy the new model:", approved)
```

> **Pitfall:** an alert with no owner gets ignored. Route every alert to a named person or channel, and record what was done about it.

> **In the wild:** teams set a drift alert and a retrain policy together, and review the number of alerts each week, because too many alerts train people to ignore them.

## Challenge: alert level

```python exercise id=alert-level title="Map a drift score to a level"
# TODO: `alert_level(psi_value)` returns "ok" for values below 0.1, "watch" for values from 0.1 up to but not including 0.2, and
# "alert" for values of 0.2 or more.
def alert_level(psi_value):
    ...
--- solution
def alert_level(psi_value):
    if psi_value < 0.1:
        return "ok"
    if psi_value < 0.2:
        return "watch"
    return "alert"
--- test
assert alert_level(0.05) == "ok", "A small score is ok."
assert alert_level(0.1) == "watch", "A score of exactly 0.1 is the start of watch."
assert alert_level(0.2) == "alert", "A score of exactly 0.2 is an alert."
--- hint
Check the thresholds in order, from the lowest.
--- hint
Use `<` for the lower bounds and return "alert" last.
```

## Challenge: retraining rule

```python exercise id=should-retrain title="Retrain only on sustained drift"
# TODO: `should_retrain(daily, threshold=0.2, consecutive=3)` returns True when there are at least consecutive values and every
# one of the last consecutive values is greater than threshold. Otherwise it returns False.
def should_retrain(daily, threshold=0.2, consecutive=3):
    ...
--- solution
def should_retrain(daily, threshold=0.2, consecutive=3):
    if len(daily) < consecutive:
        return False
    return all(v > threshold for v in daily[-consecutive:])
--- test
assert should_retrain([0.1, 0.25, 0.3, 0.4]) is True, "The last three days are all above 0.2."
assert should_retrain([0.3, 0.1, 0.3, 0.4]) is False, "One day below the threshold in the last three stops the retrain."
assert should_retrain([0.5, 0.5]) is False, "Fewer days than the required count is not enough."
--- hint
Take the last `consecutive` values, then test that every one exceeds the threshold.
--- hint
`all(v > threshold for v in daily[-consecutive:])`.
```

## Debug: any day triggers retraining

Retraining should require every recent day to exceed the threshold, but this check fires when any single day does.

```python debug id=any-day title="Require every recent day above the threshold"
daily_psi = [0.3, 0.1, 0.3]
threshold = 0.2
recent = daily_psi[-3:]
retrain = any(v > threshold for v in recent)     # bug: one day above the threshold is enough
print("retrain:", retrain)
--- solution
daily_psi = [0.3, 0.1, 0.3]
threshold = 0.2
recent = daily_psi[-3:]
retrain = all(v > threshold for v in recent)
print("retrain:", retrain)
--- test
assert retrain is False, "The day with 0.1 is below the threshold, so the rule must not retrain. Require every day with all, not any."
--- hint
A sustained shift means all of the recent days are above the threshold.
--- hint
Use `all` instead of `any`.
```

## Predict the level

```python predict id=predict-level title="What alert level does a score of 0.25 give?"
def alert_level(psi_value):
    if psi_value < 0.1:
        return "ok"
    if psi_value < 0.2:
        return "watch"
    return "alert"
print(alert_level(0.25))
--- options
* alert
watch
ok
error
--- explain
A score of 0.25 is at least 0.2, so it is an alert.
```

## Recap

- Map scores to levels, so responses are consistent.
- Retrain only on sustained drift, and require an evaluation before deploying.
- Give every alert an owner, and review how often they fire.

**Up next:** a capstone that monitors a model end to end.
