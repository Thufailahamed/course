A chart is an argument made with shapes. Before you can make honest charts, you need to know what matplotlib is doing underneath: a **figure** is the whole canvas, and each **axes** is a plotting area with its own x and y scales. Every chart you will ever draw is built from those two parts, and once you understand them, the rest of plotting is choosing the right shape for the question.

## Figure and axes

```python run
import matplotlib.pyplot as plt
import numpy as np

fig, ax = plt.subplots(figsize=(5, 3))
x = np.arange(1, 7)
ax.plot(x, x ** 2, marker="o", label="squares")
ax.set_xlabel("day")
ax.set_ylabel("orders")
ax.set_title("A first line chart")
ax.legend()
plt.show()
```

`plt.subplots` returns both objects. Calls on `ax` (the axes) draw on that plotting area and label it. Always label the axes with units: a chart without labels is a guess.

## Choose a chart for the question

| Question | Chart | Why |
|---|---|---|
| How does a value change over time? | Line | Position in time is continuous |
| How do categories compare? | Bar | Length is easy to compare |
| How is a value spread out? | Histogram | Shows the shape of a distribution |
| Is there a relationship between two numbers? | Scatter | Each point is one observation |

Styling changes how a line reads. Colour, line style and markers each carry meaning, so choose them deliberately.

```python run
fig, ax = plt.subplots(figsize=(5, 3))
weeks = np.arange(1, 9)
ax.plot(weeks, [3, 4, 4, 6, 7, 7, 9, 12], color="#4c78a8", linewidth=2, label="this year")
ax.plot(weeks, [2, 3, 3, 4, 5, 5, 6, 7], color="#999999", linestyle="--", label="last year")
ax.set_xlabel("week")
ax.set_ylabel("orders")
ax.legend(frameon=False)
ax.spines[["top", "right"]].set_visible(False)
plt.show()
```

The solid line is the one you want the reader to follow, and the grey dashed line is the comparison. Emphasis comes from contrast.

## Bars and histograms

```python run
rng = np.random.default_rng(0)
orders = rng.gamma(shape=2.0, scale=15.0, size=300)    # skewed, like many real order sizes
cities = ["Lyon", "Paris", "Nice", "Brest"]
revenue = [4200, 6100, 2900, 1500]

fig, axes = plt.subplots(1, 2, figsize=(9, 3))
axes[0].bar(cities, revenue, color="#4c78a8")
axes[0].set_title("Revenue by city")
axes[0].set_ylabel("euros")
axes[1].hist(orders, bins=20, color="#f58518")
axes[1].set_title("Order sizes")
axes[1].set_xlabel("euros per order")
plt.tight_layout()
plt.show()
```

The histogram shows a long tail: most orders are small and a few are very large. An average alone would hide that shape, so plotting the distribution is the first thing to do with a new variable.

## Scatter plots show relationships

```python run
advertising = rng.uniform(0, 100, 60)
sales = 3.0 * advertising + rng.normal(0, 25, 60) + 40

fig, ax = plt.subplots(figsize=(5, 3.5))
ax.scatter(advertising, sales, alpha=0.7)
ax.set_xlabel("advertising spend (k€)")
ax.set_ylabel("sales (k€)")
ax.set_title("Spend and sales move together")
ax.grid(alpha=0.3)
plt.show()
```

Transparency (`alpha`) helps when points overlap. Notice that a relationship on a scatter plot shows association, not cause: the chart cannot tell you that spending caused the sales.

## Challenge: the category totals

Plotting starts with the numbers, so you will often write small functions that prepare data for a chart.

```python exercise id=category-totals title="Totals for a bar chart"
# TODO: `category_totals(categories, amounts)` takes two equal-length lists: a category label for each
# amount, and the amount itself. Return a dict mapping each category to the total of its amounts.
def category_totals(categories, amounts):
    ...
--- solution
def category_totals(categories, amounts):
    totals = {}
    for c, a in zip(categories, amounts):
        totals[c] = totals.get(c, 0) + a
    return totals
--- test
result = category_totals(["Tea", "Coffee", "Tea"], [4.0, 9.0, 2.5])
assert result is not None, "Replace the `...` in `category_totals` with code that returns the dictionary."
assert result == {"Tea": 6.5, "Coffee": 9.0}, f"Tea adds to 4 + 2.5 = 6.5 and Coffee to 9, but you returned {result}."
assert category_totals([], []) == {}, "No categories should give an empty dictionary."
assert category_totals(["a"], [3]) == {"a": 3}, "A single amount is its own total."
--- hint
Loop over the pairs with `zip`, and add each amount to the running total for its category, starting from 0.
--- hint
`totals[c] = totals.get(c, 0) + a` inside a loop over `zip(categories, amounts)`.
```

## Challenge: histogram counts

```python exercise id=histogram-counts title="Count values per histogram bin"
import numpy as np

# TODO: `histogram_counts(values, bins)` returns a list with the number of values that fall into each of
# `bins` equal-width bins between the minimum and maximum of `values`. Use np.histogram.
def histogram_counts(values, bins):
    ...
--- solution
import numpy as np

def histogram_counts(values, bins):
    counts, _ = np.histogram(values, bins=bins)
    return counts.tolist()
--- test
import numpy as np
result = histogram_counts([1.0, 2.0, 2.5, 9.0], 2)
assert result is not None, "Replace the `...` in `histogram_counts` with code that returns the counts."
assert result == [3, 1], f"Between 1 and 5 there are three values (1, 2, 2.5) and between 5 and 9 there is one, so the counts are [3, 1], but you returned {result}."
assert sum(histogram_counts([0.0, 1.0, 2.0, 3.0], 3)) == 4, "Every value must land in exactly one bin."
--- hint
`np.histogram(values, bins=bins)` returns two arrays: the counts and the bin edges. You need only the counts.
--- hint
`counts, _ = np.histogram(values, bins=bins)`, then return `counts.tolist()`.
```

## Debug the missing labels

This chart code runs, but the bars are unlabeled and the y-axis has no title.

```python debug id=label-axes title="Label the chart"
import matplotlib.pyplot as plt

fig, ax = plt.subplots(figsize=(4, 3))
ax.bar(["Lyon", "Paris"], [4200, 6100])
ax.set_title("Revenue")
ax.set_ylabel("")                  # bug: an empty label tells the reader nothing
print(ax.get_ylabel() == "", ax.get_title())
plt.close(fig)
--- solution
import matplotlib.pyplot as plt

fig, ax = plt.subplots(figsize=(4, 3))
ax.bar(["Lyon", "Paris"], [4200, 6100])
ax.set_title("Revenue")
ax.set_ylabel("euros")
print(ax.get_ylabel(), ax.get_title())
plt.close(fig)
--- test
assert ax.get_ylabel() != "", "The y-axis needs a label that says what the numbers measure, such as 'euros'."
assert ax.get_title() == "Revenue", "The title should stay as Revenue."
--- hint
An empty string is a label you did not write. Give the axis a description with units.
--- hint
`ax.set_ylabel("euros")`.
```

## Predict the figure count

```python predict id=predict-subplots title="How many axes does this make?"
import matplotlib.pyplot as plt
fig, axes = plt.subplots(2, 3)
print(len(axes.ravel()))
plt.close(fig)
--- options
* 6
2
3
5
--- explain
`subplots(2, 3)` makes a grid with two rows and three columns, so six axes. `ravel()` flattens the grid into a list, and its length is six.
```

## Recap

- A figure is the canvas, and each axes is a plotting area you draw on and label.
- Match the chart to the question: lines for change over time, bars for comparison, histograms for spread, and scatter plots for relationships.
- Always label the axes and give a clear title.
- Association in a scatter plot is not causation.

**Up next:** plotting straight from DataFrames, and choosing the right chart for real data.
