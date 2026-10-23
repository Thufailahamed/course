A chart can be accurate and still mislead. A truncated axis makes a small difference look enormous. Too many colours hide the one point you wanted to make. A pie chart with eleven slices asks the reader to compare angles they cannot judge. Honest charts are a discipline, and the rules are simple: start bars at zero, label everything, use colour with purpose, and let the chart answer one question.

## Bars start at zero

```python run
import matplotlib.pyplot as plt
import numpy as np

values = [102.0, 104.0, 107.0]
labels = ["A", "B", "C"]

fig, axes = plt.subplots(1, 2, figsize=(8, 3))
axes[0].bar(labels, values)
axes[0].set_ylim(100, 108)
axes[0].set_title("Truncated axis: looks dramatic")
axes[1].bar(labels, values)
axes[1].set_ylim(0, 110)
axes[1].set_title("Zero baseline: honest")
plt.tight_layout()
plt.show()
```

The two charts show identical data. The left one suggests C is many times bigger than A, when it is about five per cent larger. Bars encode value by length, so their base must be zero. Lines are different: a line chart can use a narrower range, because the slope, not the height, carries the message.

## Use colour with purpose

```python run
categories = ["Tea", "Coffee", "Cocoa", "Juice", "Water", "Soda"]
sales = [42, 55, 18, 25, 30, 12]

fig, axes = plt.subplots(1, 2, figsize=(8, 3))
axes[0].bar(categories, sales, color=["#e45756", "#4c78a8", "#4c78a8", "#4c78a8", "#4c78a8", "#4c78a8"])
axes[0].set_title("One highlight: coffee leads")
axes[1].bar(categories, sales, color=plt.cm.tab10(range(len(categories))))
axes[1].set_title("Six colours: which one matters?")
for ax in axes:
    ax.tick_params(axis="x", rotation=45)
plt.tight_layout()
plt.show()
```

Use one strong colour to highlight the point, and grey or a single muted colour for everything else. Rainbow colouring gives the eye no clue where to look.

## Label everything

A reader should be able to understand the chart from its title, axes and labels alone, without reading the surrounding text.

```python run
fig, ax = plt.subplots(figsize=(5, 3))
bars = ax.bar(["Tea", "Coffee"], [42, 55], color="#4c78a8")
ax.bar_label(bars, fmt="%d units")
ax.set_ylabel("units sold, January 2026")
ax.set_title("Coffee outsold tea in January")
ax.spines[["top", "right"]].set_visible(False)
plt.tight_layout()
plt.show()
```

`bar_label` writes the value on each bar, so nobody has to estimate it from the axis. Removing the top and right frame lines makes the chart lighter without losing information.

A reference line gives the reader something to measure against. For a target or a previous period, draw it as a faint horizontal line and label it.

```python run
targets = [40, 42, 45, 43, 48, 50]
fig, ax = plt.subplots(figsize=(5, 3))
ax.plot(range(1, 7), targets, marker="o", color="#4c78a8")
ax.axhline(45, color="#e45756", linestyle=":", linewidth=1)
ax.text(6, 45.5, "target 45", color="#e45756", ha="right")
ax.set_xlabel("month")
ax.set_ylabel("orders (thousands)")
ax.set_title("Orders against target")
plt.tight_layout()
plt.show()
```

## Pie charts: usually not

Humans compare lengths far better than angles. With more than three slices, a pie chart is hard to read, and a sorted bar chart is almost always clearer.

> **Pitfall:** do not use pie charts for many categories, and never use 3-D effects. Both make values harder to compare.

## Challenge: the honest y-limit

```python exercise id=honest-limit title="Choose a bar chart's lower limit"
# TODO: `bar_baseline(values)` returns the lower y-axis limit to use for a bar chart of these values:
# 0 for bars, so the lengths are honest. Return the number 0 for any non-empty list of non-negative values.
# For an empty list, return 0 too.
def bar_baseline(values):
    ...
--- solution
def bar_baseline(values):
    return 0
--- test
assert bar_baseline([102.0, 104.0]) == 0, "Bars must start at zero so their lengths compare honestly."
assert bar_baseline([]) == 0, "An empty chart should still start at zero."
assert bar_baseline([5, 1, 9]) == 0, "The baseline does not depend on the values for bar charts."
--- hint
This is a rule, not a calculation: a bar chart's baseline is zero.
--- hint
`return 0`.
```

## Challenge: padded axis limits

```python exercise id=axis-limits title="Axis limits with breathing room"
import numpy as np

# TODO: `axis_limits(values, pad)` returns a (lower, upper) pair for a line chart of `values`. The range is the
# difference between the maximum and minimum. Extend both ends by `pad` times that range. Use the rule for
# line charts: do not force the axis to start at zero.
def axis_limits(values, pad):
    ...
--- solution
import numpy as np

def axis_limits(values, pad):
    values = np.asarray(values, dtype=float)
    low, high = values.min(), values.max()
    span = high - low
    return (low - pad * span, high + pad * span)
--- test
import numpy as np
lo, hi = axis_limits([10.0, 20.0, 30.0], 0.1)
assert lo is not None, "Replace the `...` in `axis_limits` with code that returns the pair of limits."
assert np.isclose(lo, 8.0) and np.isclose(hi, 32.0), f"The range is 20, so 10% is 2: the limits should be 8 and 32, but you returned ({lo}, {hi})."
lo2, hi2 = axis_limits([5.0, 5.0], 0.5)
assert np.isclose(lo2, 5.0) and np.isclose(hi2, 5.0), "With no range there is nothing to pad."
--- hint
Find the minimum and maximum, compute the span, then subtract and add `pad * span`.
--- hint
`return (low - pad * span, high + pad * span)`.
```

## Debug the misleading axis

This chart is meant to compare two prices honestly, but its axis starts near the values, which exaggerates a small difference.

```python debug id=truncated-axis title="Start the bars at zero"
import matplotlib.pyplot as plt

fig, ax = plt.subplots(figsize=(4, 3))
ax.bar(["Standard", "Premium"], [49.0, 51.0])
ax.set_ylim(48, 52)                 # bug: the truncated axis makes a 4% gap look huge
print("bottom limit:", ax.get_ylim()[0])
plt.close(fig)
--- solution
import matplotlib.pyplot as plt

fig, ax = plt.subplots(figsize=(4, 3))
ax.bar(["Standard", "Premium"], [49.0, 51.0])
ax.set_ylim(0, 52)
print("bottom limit:", ax.get_ylim()[0])
plt.close(fig)
--- test
assert ax.get_ylim()[0] == 0, f"A bar chart's lower limit should be 0 for an honest comparison, but it is {ax.get_ylim()[0]}."
--- hint
Bars encode value by length, so the bars must begin at zero.
--- hint
Change the lower limit in `set_ylim` to 0.
```

## Predict the axis

```python predict id=predict-zero title="What is the lower limit of an honest bar chart?"
import matplotlib.pyplot as plt
fig, ax = plt.subplots()
ax.bar(["a", "b"], [10, 12])
print(ax.get_ylim()[0] <= 0)
plt.close(fig)
--- options
* True
False
10
12
--- explain
Matplotlib starts a bar chart at zero by default, so the lower limit is at or below zero and the expression is True. Truncating the axis is a deliberate choice that you must justify.
```

## Recap

- Bars start at zero. Lines can use tighter ranges because slope carries the message.
- Use colour to highlight one point, not to decorate.
- Label titles, axes and values, so the chart stands alone.
- Avoid pie charts with many slices and 3-D effects.

**Up next:** exploratory data analysis, the structured workflow that turns a new dataset into reliable answers.
