Some answers cannot be matched exactly, such as a summary or a helpful reply. A judge model can score them, but a judge is a measurement instrument, and it needs calibration. Compare the judge with human labels on the same items. Raw agreement can look high even when the judge is no better than chance, so Cohen's kappa corrects for the agreement expected by chance.

## Raw agreement

```python run
def agreement(a, b):
    return sum(x == y for x, y in zip(a, b)) / len(a)

human = [1, 1, 0, 0, 1, 0]
judge = [1, 0, 0, 0, 1, 1]
print("raw agreement:", round(agreement(human, judge), 3))
```

## Agreement expected by chance

If both raters use label 1 half the time, they agree by chance half the time. Kappa measures agreement beyond that baseline.

```python run
from collections import Counter

def chance_agreement(a, b):
    n = len(a)
    ca, cb = Counter(a), Counter(b)
    return sum((ca[l] / n) * (cb[l] / n) for l in set(a) | set(b))

print("chance agreement:", round(chance_agreement(human, judge), 3))
```

## Cohen's kappa

Kappa is the observed agreement minus the chance agreement, divided by one minus the chance agreement.

```python run
def cohens_kappa(a, b):
    po = agreement(a, b)
    pe = chance_agreement(a, b)
    return 1.0 if pe == 1 else (po - pe) / (1 - pe)

print("kappa:", round(cohens_kappa(human, judge), 3))
```

## Bias of the judge

A judge that says yes more often than people do is biased, even when it is right on some items. Compare the label rates.

```python run
print("human yes rate:", round(sum(human) / len(human), 3), "| judge yes rate:", round(sum(judge) / len(judge), 3))
```

> **Pitfall:** a judge scored only against itself, or by its own explanations, looks consistent and can still be wrong. Always calibrate against human labels on a sample from the real task.

> **In the wild:** judges are used to rank model outputs at scale, and their kappa with people on the actual task is the number that decides whether to trust them.

## Challenge: agreement

```python exercise id=agreement title="Fraction of equal labels"
# TODO: `agreement(a, b)` returns the fraction of positions where the two label lists are equal.
def agreement(a, b):
    ...
--- solution
def agreement(a, b):
    return sum(x == y for x, y in zip(a, b)) / len(a)
--- test
result = agreement([1, 0, 1, 1], [1, 0, 0, 1])
assert result is not None, "Replace the `...` in `agreement` with code that returns the fraction."
assert abs(result - 0.75) < 1e-9, f"Three of four positions agree, so the fraction is 0.75, but you returned {result}."
assert agreement([1, 1], [0, 0]) == 0.0, "No agreement gives zero."
--- hint
Pair the lists with `zip`, count the equal pairs, then divide by the length.
--- hint
`sum(x == y for x, y in zip(a, b)) / len(a)`.
```

## Challenge: Cohen's kappa

```python exercise id=kappa title="Cohen's kappa for two raters"
from collections import Counter

# TODO: `cohens_kappa(a, b)` returns (po − pe) / (1 − pe), where po is the fraction of equal labels and pe is the chance
# agreement from the label frequencies of each rater. Return 1.0 when pe equals 1.
def cohens_kappa(a, b):
    ...
--- solution
from collections import Counter

def cohens_kappa(a, b):
    n = len(a)
    po = sum(x == y for x, y in zip(a, b)) / n
    ca, cb = Counter(a), Counter(b)
    pe = sum((ca[l] / n) * (cb[l] / n) for l in set(a) | set(b))
    return 1.0 if pe == 1 else (po - pe) / (1 - pe)
--- test
result = cohens_kappa([1, 1, 0, 0], [1, 0, 0, 0])
assert result is not None, "Replace the `...` in `cohens_kappa` with code that returns the kappa."
assert abs(result - 0.5) < 1e-9, f"Observed agreement is 0.75 and chance agreement is 0.5, so kappa is (0.75 − 0.5) / 0.5 = 0.5, but you returned {result}."
assert abs(cohens_kappa([1, 0, 1], [1, 0, 1]) - 1.0) < 1e-9, "Perfect agreement gives kappa one."
--- hint
Compute the observed agreement and the chance agreement, then apply the formula.
--- hint
Chance agreement sums the products of the two raters' label frequencies.
--- hint
Labels can be 0 or 1, so take the union of the labels from both raters.
```

## Debug: a shifted comparison

Each judge label should be compared with the human label at the same position, but the second list is shifted by one.

```python debug id=shifted-zip title="Compare labels at the same position"
human = [1, 0, 1]
judge = [1, 0, 1]
matches = sum(x == y for x, y in zip(human, judge[1:]))    # bug: judge is shifted by one position
print("agreement:", matches / len(human))
--- solution
human = [1, 0, 1]
judge = [1, 0, 1]
matches = sum(x == y for x, y in zip(human, judge))
print("agreement:", matches / len(human))
--- test
assert matches / len(human) == 1.0, f"The two lists are identical, so agreement is 1.0, but the code gives {matches / len(human)}. Pair the lists at the same index."
--- hint
zip pairs the first elements together, so both lists must start at the same position.
--- hint
Remove the slice on `judge`.
```

## Predict the self-agreement

```python predict id=predict-self title="What is the agreement of a rater with itself?"
a = [1, 0, 1, 0]
print(sum(x == y for x, y in zip(a, a)) / len(a))
--- options
* 1.0
0.5
0.0
0.25
--- explain
Every position matches itself, so the fraction of agreement is one.
```

## Recap

- Raw agreement can be high by chance, so compare with Cohen's kappa.
- Check the judge against human labels on the real task, and check its label rates for bias.
- A judge is an instrument, and it needs calibration like any other.

**Up next:** cost and latency, which decide whether a working system is affordable.
