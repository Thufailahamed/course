# Plotting with matplotlib and seaborn

A chart is an argument. Before you choose a chart type, finish this sentence: *"I want the reader to see that…"* If the answer is "revenue changed over time", you want a line. If it is "which region is biggest", a sorted bar chart. If it is "is there a relationship between ad spend and revenue", a scatter.

This lesson teaches the matplotlib object API — `fig` and `ax` — because it gives you control over every part of the figure. Seaborn is a higher-level library built on matplotlib; the concepts transfer directly.

## The figure and the axes

`plt.subplots()` returns two objects: a **Figure** (the whole canvas) and an **Axes** (one plot inside it). Call methods on `ax`, not on the global `plt`, when you want reliable, composable code.

```python run
import matplotlib.pyplot as plt

months = ["Jan", "Feb", "Mar", "Apr", "May"]
revenue = [120, 150, 130, 180, 210]

fig, ax = plt.subplots(figsize=(6, 3.5))
ax.plot(months, revenue, marker="o", color="#2563eb", linewidth=2)
ax.set_title("Monthly revenue")
ax.set_xlabel("Month")
ax.set_ylabel("Revenue ($)")
ax.grid(True, alpha=0.3)

plt.show()
```

Every chart needs a title and axis labels. A chart without units is a guessing game. `marker="o"` makes the individual observations visible, which is useful when there are only a few points.

## Compare categories with bars

Sort bars by the value you are comparing. A sorted chart answers "which is biggest?" at a glance; an alphabetical chart makes the reader do the work.

```python run
import matplotlib.pyplot as plt
import numpy as np

regions = ["East", "North", "South"]
totals = [120, 410, 350]
order = np.argsort(totals)[::-1]

fig, ax = plt.subplots(figsize=(6, 3.5))
ax.bar(np.array(regions)[order], np.array(totals)[order], color="#0f766e")
ax.set_title("Revenue by region")
ax.set_ylabel("Revenue ($)")
ax.spines[["top", "right"]].set_visible(False)

plt.show()
```

`np.argsort(totals)[::-1]` returns the positions that would sort the values ascending, reversed for descending. Indexing both arrays with it keeps labels and values aligned.

## Show a relationship with a scatter

```python run
import matplotlib.pyplot as plt
import numpy as np

ad_spend = np.array([10, 20, 30, 40, 50, 60])
revenue = np.array([80, 120, 150, 210, 240, 300])

fig, ax = plt.subplots(figsize=(5.5, 3.5))
ax.scatter(ad_spend, revenue, s=60, color="#7c3aed", alpha=0.85)
ax.set_title("Ad spend vs. revenue")
ax.set_xlabel("Ad spend ($k)")
ax.set_ylabel("Revenue ($k)")
ax.grid(True, alpha=0.25)

plt.show()
```

A scatter shows the joint distribution of two numeric variables. It can reveal a relationship, clusters, or outliers that a correlation coefficient would hide.

## Show a distribution with a histogram

```python run
import matplotlib.pyplot as plt
import numpy as np

order_values = np.array([12, 18, 18, 22, 25, 25, 30, 35, 40, 42, 55, 70, 85, 120])

fig, ax = plt.subplots(figsize=(5.5, 3.5))
ax.hist(order_values, bins=7, color="#f59e0b", edgecolor="white")
ax.set_title("Distribution of order values")
ax.set_xlabel("Order value ($)")
ax.set_ylabel("Number of orders")

plt.show()
```

Always plot a distribution before summarizing it with a mean. A long right tail, a second peak or a pile-up at zero changes the story.

## Two panels, one story

```python run
import matplotlib.pyplot as plt

months = ["Jan", "Feb", "Mar", "Apr"]
revenue = [120, 150, 130, 180]
orders = [12, 15, 13, 18]

fig, axes = plt.subplots(1, 2, figsize=(8, 3))
axes[0].plot(months, revenue, marker="o", color="#2563eb")
axes[0].set_title("Revenue")
axes[0].set_ylabel("$")

axes[1].bar(months, orders, color="#0f766e")
axes[1].set_title("Orders")
axes[1].set_ylabel("count")

fig.suptitle("Growth in the first four months")
plt.tight_layout()

plt.show()
```

`axes` is an array when you create more than one subplot. Index it like any other array. `tight_layout()` prevents labels from colliding.

> **Tip:** Prefer a small number of well-labelled charts to a dashboard of unreadable ones. If a chart needs a paragraph to explain what to look at, it is probably the wrong chart.

> **In the wild:** Seaborn's `sns.lineplot`, `sns.barplot` and `sns.scatterplot` accept a DataFrame and a column name, and add useful defaults for confidence intervals and grouping. The figure/axes model underneath is the same one you are learning here.
>
> **In this browser:** the lesson kernel ships matplotlib but not seaborn, so every runnable example uses matplotlib. When you move to a local notebook, `import seaborn as sns` gives you the same `fig`/`ax` objects with shorter defaults.

## Your turn: a line chart with a message

Build `fig` and `ax` with a line plot of weekly active users. Use markers, a title `"Weekly active users"`, x-label `"Week"` and y-label `"Users"`.

```python exercise id=plot-trend title="Plot the weekly trend"
import matplotlib.pyplot as plt

weeks = ["W1", "W2", "W3", "W4", "W5"]
users = [1200, 1350, 1280, 1600, 1750]

fig, ax = plt.subplots(figsize=(6, 3.5))

# TODO: plot the line and label the chart.
...
--- solution
import matplotlib.pyplot as plt

weeks = ["W1", "W2", "W3", "W4", "W5"]
users = [1200, 1350, 1280, 1600, 1750]

fig, ax = plt.subplots(figsize=(6, 3.5))
ax.plot(weeks, users, marker="o", color="#2563eb")
ax.set_title("Weekly active users")
ax.set_xlabel("Week")
ax.set_ylabel("Users")
--- test
assert len(ax.lines) == 1, f"Expected one line, but the axes has {len(ax.lines)}."
assert ax.lines[0].get_ydata().tolist() == users, f"The line should plot {users}."
assert ax.get_title() == "Weekly active users", f"Title should be `Weekly active users`, but is {ax.get_title()!r}."
assert ax.get_xlabel() == "Week", f"x-label should be `Week`, but is {ax.get_xlabel()!r}."
assert ax.get_ylabel() == "Users", f"y-label should be `Users`, but is {ax.get_ylabel()!r}."
assert ax.lines[0].get_marker() not in ("", "None", None), "Add markers so individual weeks are visible."
--- hint
`ax.plot(weeks, users, marker="o")` draws the line and points.
--- hint
Set the three labels with `ax.set_title(...)`, `ax.set_xlabel(...)` and `ax.set_ylabel(...)`.
```

## Your turn: a sorted bar chart

Plot total revenue by region, sorted from largest to smallest. Give the chart the title `"Revenue by region"` and y-label `"Revenue ($)"`.

```python exercise id=plot-bars title="Sort the bars"
import matplotlib.pyplot as plt
import numpy as np

regions = ["East", "North", "South"]
totals = [120, 410, 350]

fig, ax = plt.subplots(figsize=(6, 3.5))

# TODO: sort the values and draw bars.
...
--- solution
import matplotlib.pyplot as plt
import numpy as np

regions = ["East", "North", "South"]
totals = [120, 410, 350]

fig, ax = plt.subplots(figsize=(6, 3.5))
order = np.argsort(totals)[::-1]
ax.bar(np.array(regions)[order], np.array(totals)[order], color="#0f766e")
ax.set_title("Revenue by region")
ax.set_ylabel("Revenue ($)")
--- test
assert len(ax.patches) == 3, f"Expected three bars, but found {len(ax.patches)}."
heights = [round(p.get_height(), 2) for p in ax.patches]
assert heights == [410.0, 350.0, 120.0], f"Bars should be sorted largest first, but heights are {heights}. Use argsort to reorder both labels and values."
assert ax.get_title() == "Revenue by region", f"Title should be `Revenue by region`, but is {ax.get_title()!r}."
assert ax.get_ylabel() == "Revenue ($)", f"y-label should be `Revenue ($)`, but is {ax.get_ylabel()!r}."
--- hint
`np.argsort(totals)` gives ascending positions. Reverse it with `[::-1]` for descending.
--- hint
Index both the labels and the values with the same `order` so the bars stay aligned: `ax.bar(np.array(regions)[order], np.array(totals)[order])`.
```

## The chart with the labels swapped

This chart runs, but a reader would misread both axes. Fix the labels so the horizontal axis is the week and the vertical axis is users. Keep the data and title.

```python debug id=plot-labels title="Labels on the wrong axes"
import matplotlib.pyplot as plt

weeks = ["W1", "W2", "W3", "W4"]
users = [900, 1100, 1050, 1400]

fig, ax = plt.subplots(figsize=(6, 3.5))
ax.plot(weeks, users, marker="o")
ax.set_title("Weekly active users")
ax.set_xlabel("Users")
ax.set_ylabel("Week")

print(ax.get_xlabel(), "|", ax.get_ylabel())
--- solution
import matplotlib.pyplot as plt

weeks = ["W1", "W2", "W3", "W4"]
users = [900, 1100, 1050, 1400]

fig, ax = plt.subplots(figsize=(6, 3.5))
ax.plot(weeks, users, marker="o")
ax.set_title("Weekly active users")
ax.set_xlabel("Week")
ax.set_ylabel("Users")

print(ax.get_xlabel(), "|", ax.get_ylabel())
--- test
assert ax.get_xlabel() == "Week", f"x-label should be `Week`, but is {ax.get_xlabel()!r}."
assert ax.get_ylabel() == "Users", f"y-label should be `Users`, but is {ax.get_ylabel()!r}."
assert ax.get_title() == "Weekly active users", "Keep the title unchanged."
assert len(ax.lines) == 1, "Keep the existing line plot."
--- hint
Read the chart as a stranger: what does a point 1,100 on the vertical axis mean if the label says "Week"?
--- hint
Swap the two strings: x is Week, y is Users.
```

## Predict the bar count

```python predict id=predict-patch-count title="How many bars?"
import matplotlib.pyplot as plt

fig, ax = plt.subplots()
ax.bar(["A", "B", "C"], [10, 20, 15])
print(len(ax.patches))
--- options
0
* 3
1
6
--- explain
Each bar is a patch. Three categories produce three rectangles, so `len(ax.patches)` is 3. The heights are available through `patch.get_height()`.
```

## Recap

- Use the object API: `fig, ax = plt.subplots()`, then call methods on `ax`.
- Match the chart to the question: line for time, sorted bar for categories, scatter for relationships, histogram for distributions.
- Always label the title and both axes, including units.
- Sort bars before plotting; keep labels and values aligned with the same index.
- A distribution plot can change the summary you choose. Look before you average.

**Up next:** you'll combine everything — loading a messy CSV, cleaning it, deriving metrics, grouping, joining and plotting — into one end-to-end exploratory analysis.
