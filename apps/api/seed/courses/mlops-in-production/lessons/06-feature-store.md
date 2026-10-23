A feature store keeps the values that models use, with the time each value became known. Training needs the value that was current for each example at that moment. Using the latest value instead leaks information from the future into the training data, and the model looks better offline than it will in production.

## A feature history

Each feature value is stored with the time it became known, in ascending time order.

```python run
history = [(1, 10), (5, 20), (9, 15)]
print("feature history (time, value):", history)
```

## The value as of a time

The value to use for a given time is the latest stored value at or before that time.

```python run
def as_of(history, t):
    value = None
    for ts, v in history:
        if ts <= t:
            value = v
    return value

for t in [0, 4, 5, 10]:
    print(f"as of {t}: {as_of(history, t)}")
```

## Leakage in a naive join

Taking the latest value for every example mixes the future into the past.

```python run
examples = [(4, "a"), (6, "b")]
naive = [history[-1][1] for _ in examples]
correct = [as_of(history, t) for t, _ in examples]
print("naive (leaks):", naive, "| point-in-time:", correct)
```

## Labels joined to features

A label arrives at a time, and its features must be the values known at that time.

```python run
labels = [(4, 1), (6, 0)]
rows = [(t, label, as_of(history, t)) for t, label in labels]
print("training rows:", rows)
```

> **Pitfall:** a feature computed over the full dataset, including the test period, leaks the answer. Compute features with a cut-off at each example's time.

> **In the wild:** feature stores such as Feast perform point-in-time joins, so training and serving read the same values as of the same moments.

## Challenge: value as of a time

```python exercise id=as-of title="The feature value at a time"
# TODO: `as_of(history, t)` takes a list of (time, value) pairs sorted by time and returns the value of the latest pair whose
# time is at most t, or None if no pair qualifies.
def as_of(history, t):
    ...
--- solution
def as_of(history, t):
    value = None
    for ts, v in history:
        if ts <= t:
            value = v
    return value
--- test
history = [(1, "a"), (5, "b")]
assert as_of(history, 4) == "a", "At time 4 the value stored at time 1 is current."
assert as_of(history, 5) == "b", "At time 5 the newer value is current."
assert as_of(history, 0) is None, "Before the first value there is nothing to use."
--- hint
Keep the latest value whose time does not exceed t.
--- hint
Overwrite `value` for each pair with `ts <= t`.
```

## Challenge: label join

```python exercise id=label-join title="Join labels to features as of their time"
# TODO: `label_join(labels, history)` takes labels as (time, label) pairs and returns a list of (time, label, value) tuples, where
# value is the feature value as of that time. The function as_of below is provided.
def as_of(history, t):
    value = None
    for ts, v in history:
        if ts <= t:
            value = v
    return value

def label_join(labels, history):
    ...
--- solution
def as_of(history, t):
    value = None
    for ts, v in history:
        if ts <= t:
            value = v
    return value

def label_join(labels, history):
    return [(t, label, as_of(history, t)) for t, label in labels]
--- test
history = [(1, 10), (5, 20)]
result = label_join([(4, 1), (6, 0)], history)
assert result is not None, "Replace the `...` in `label_join` with code that returns the rows."
assert result == [(4, 1, 10), (6, 0, 20)], f"At time 4 the value is 10 and at time 6 it is 20, but you returned {result}."
--- hint
A list comprehension can call `as_of` for each label's time.
--- hint
`[(t, label, as_of(history, t)) for t, label in labels]`.
```

## Debug: reading the latest value

The join should use the value known at each example's time, but this version reads the newest value for every example.

```python debug id=latest-leak title="Use the value known at the example's time"
history = [(1, 10), (5, 20)]
t = 4
value = history[-1][1]               # bug: the newest value is 20, which is in the future at time 4
print("feature for time 4:", value)
--- solution
history = [(1, 10), (5, 20)]
t = 4
value = [v for ts, v in history if ts <= t][-1]
print("feature for time 4:", value)
--- test
assert value == 10, f"At time 4 only the value 10 from time 1 was known, but the code used {value}. Use the latest value at or before time 4."
--- hint
The value at time 5 did not exist yet at time 4.
--- hint
Filter the history to times at most t, then take the last value.
```

## Predict the value

```python predict id=predict-asof title="What value is current at time 4 for the history [(1, 10), (5, 20)]?"
history = [(1, 10), (5, 20)]
print([v for ts, v in history if ts <= 4][-1])
--- options
* 10
20
None
4
--- explain
The value stored at time 1 is current at time 4, because the value at time 5 has not happened yet.
```

## Recap

- Store each feature value with the time it became known.
- Join labels to the value as of their time, never to the latest value.
- Leakage makes offline metrics look better than production will be.

**Up next:** batch and online features, and how cached values stay fresh.
