Many prototypes never reach production, and the reasons are rarely the model. Data is not versioned, experiments cannot be reproduced, features differ between training and serving, and nobody owns the monitoring. Maturity models describe this progression, from manual work at the bottom to automated, monitored systems at the top. A team can use a checklist to see where it stands.

## Checking maturity

A team's maturity can be read from a checklist, where each practice is either in place or not. The level is the number of practices that are in place, counted from the start, because a later practice needs the earlier ones.

```python run
checks = [True, True, False, True]
level = 0
for ok in checks:
    if not ok:
        break
    level += 1
print("maturity level:", level, "of", len(checks))
```

## The practices in order

The order matters. Versioned data makes experiments comparable, comparable experiments make pipelines trustworthy, and trustworthy pipelines make monitoring meaningful.

```python run
practices = ["versioned data", "tracked experiments", "automated pipeline", "monitored serving"]
for i, p in enumerate(practices, start=1):
    print(f"{i}. {p}")
```

## Counting the practices in place

```python run
practices_in_place = sum([True, True, False, True])
print("practices in place:", practices_in_place, "of 4")
```

## Where the time goes

A large part of a project's time goes to the work around the model. A rough split makes the point.

```python run
share = {"model code": 20, "data work": 35, "serving and monitoring": 30, "coordination": 15}
print(share, "| total:", sum(share.values()))
```

> **Pitfall:** a team that jumps to deployment before versioning data cannot tell whether a regression came from the code or the data. Put the practices in order, and skip none.

> **In the wild:** teams use maturity checklists in planning reviews, so that the next investment goes to the lowest unmet practice.

## Challenge: share of a whole

```python exercise id=pct-of title="Percentage of a whole"
# TODO: `pct_of(part, whole)` returns 100 × part / whole as a float.
def pct_of(part, whole):
    ...
--- solution
def pct_of(part, whole):
    return 100 * part / whole
--- test
result = pct_of(30, 120)
assert result is not None, "Replace the `...` in `pct_of` with code that returns the percentage."
assert abs(result - 25.0) < 1e-9, f"30 of 120 is 25 percent, but you returned {result}."
assert abs(pct_of(1, 4) - 25.0) < 1e-9, "One of four is 25 percent."
--- hint
Multiply by 100 before dividing so the result is a percentage.
--- hint
`return 100 * part / whole`.
```

## Challenge: maturity level

```python exercise id=maturity-level title="Count the leading practices in place"
# TODO: `maturity_level(checks)` takes a list of booleans and returns how many leading entries are True, stopping at the first
# False.
def maturity_level(checks):
    ...
--- solution
def maturity_level(checks):
    level = 0
    for ok in checks:
        if not ok:
            break
        level += 1
    return level
--- test
result = maturity_level([True, True, False, True])
assert result is not None, "Replace the `...` in `maturity_level` with code that returns the level."
assert result == 2, f"Two practices are in place before the first gap, so the level is 2, but you returned {result}."
assert maturity_level([True, True, True]) == 3, "All practices in place give the full count."
assert maturity_level([False, True]) == 0, "A missing first practice gives level zero."
--- hint
Stop counting at the first False.
--- hint
Use `break` inside the loop when `ok` is False.
```

## Debug: counting every practice

The level should stop at the first gap, but the code counts every practice that is in place.

```python debug id=count-all title="Stop at the first gap"
checks = [True, False, True]
level = sum(checks)                 # bug: counts every True, not the leading ones
print("maturity level:", level)
--- solution
checks = [True, False, True]
level = 0
for ok in checks:
    if not ok:
        break
    level += 1
print("maturity level:", level)
--- test
assert level == 1, f"Only the first practice is in place before the gap, so the level is 1, but the code gives {level}. Stop at the first False."
--- hint
A later practice does not count while an earlier one is missing.
--- hint
Loop and break on the first False.
```

## Predict the level

```python predict id=predict-level title="What maturity level does [True, True, True, False] give?"
checks = [True, True, True, False]
print(next((i for i, ok in enumerate(checks) if not ok), len(checks)))
--- options
* 3
4
2
0
--- explain
The first gap is at position 3, counting from zero, so three practices are in place before it.
```

## Recap

- Maturity is the number of practices in place, counted in order.
- A gap at a lower level limits the value of the levels above it.
- Measure the team's position before choosing the next investment.

**Up next:** reproducibility, starting with versioned data.
