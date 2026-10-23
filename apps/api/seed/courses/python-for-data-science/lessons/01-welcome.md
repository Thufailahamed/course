# Welcome: how this course works

You are about to do data science the way it is actually done: in a notebook, with real code, making mistakes and fixing them. This page is the orientation. In the next ten minutes you'll run your first pandas table, learn the four moves every lesson uses, and finish with a checked challenge and a realistic bug.

There are no videos to sit through and nothing to install. Python 3, NumPy, pandas and matplotlib run inside this page, in your browser. Every grey block is a live cell: edit it, press **Run**, and the result appears underneath.

## The loop: read, run, break, fix

Here is a tiny dataset. It describes four learners and how many lessons they finished.

```python run
import pandas as pd

cohort = pd.DataFrame({
    "learner": ["Amina", "Ben", "Chloe", "Diego"],
    "hours": [4.5, 2.0, 6.0, 3.5],
    "completed": [7, 3, 10, 5],
})

cohort
```

A DataFrame is a table with named columns. The value of the last expression is displayed, so you don't need `print` just to inspect something.

Now change the cell. Add a column, sort it, break it — the kernel is yours. The variables you create persist for the rest of the lesson, like a Jupyter notebook.

```python run
cohort["lessons_per_hour"] = (cohort["completed"] / cohort["hours"]).round(2)

cohort.sort_values("lessons_per_hour", ascending=False)
```

That is already the shape of most analysis: create a column, derive a rate, rank it, and ask whether the ranking makes sense. (Chloe finishes 1.67 lessons per hour; Ben finishes 1.5. The difference is small, which is itself a finding worth noticing.)

## The four moves

Every lesson follows the same rhythm.

| Move | What you do | What it is for |
|---|---|---|
| **Run** | Execute an example and read the output | Build intuition by changing one thing |
| **Check** | Attempt a challenge, then run the hidden tests | Prove the idea works on fresh data |
| **Debug** | Fix code that already runs but is wrong | Learn the failure modes you'll meet at work |
| **Predict** | Commit to an answer *before* running | Read code like an analyst, not a spectator |

> **Tip:** Predict first, then run. Being wrong is useful; it shows you exactly which mental model needs updating.

Challenges run in a **fresh** namespace, so they can't peek at variables from the examples above. A challenge that needs a table must define that table in the starter code — just like a function should not depend on a global it doesn't own.

## How progress works

- A coding challenge is complete when its hidden tests pass. You can retry as many times as you like.
- The **Debug** button steps through code line by line, forwards and backwards, showing every variable at each stop.
- **Atlas**, the AI tutor, can explain an error or a concept. It is instructed not to hand you the answer to an exercise.
- Each lesson ends with a short recap and a single **Up next** line. The checkpoint quiz needs 70% to pass.
- The course is finished when every lesson is complete and the checkpoint passes.

## Your first check

Complete the cell so `average` holds the mean number of hours across the cohort. The test will check the value, not how you calculated it.

```python exercise id=average-hours title="Find the average study time"
import pandas as pd

cohort = pd.DataFrame({
    "learner": ["Amina", "Ben", "Chloe", "Diego"],
    "hours": [4.5, 2.0, 6.0, 3.5],
})

hours = cohort["hours"]

# TODO: compute the mean of `hours`
average = ...
--- solution
import pandas as pd

cohort = pd.DataFrame({
    "learner": ["Amina", "Ben", "Chloe", "Diego"],
    "hours": [4.5, 2.0, 6.0, 3.5],
})

hours = cohort["hours"]
average = hours.mean()
--- test
assert average is not ..., "Replace the `...` after `average =` with your calculation."
assert abs(float(average) - 4.0) < 1e-9, f"`average` should be 4.0, but it is {average!r}. Add the four values and divide by how many there are."
assert len(hours) == 4, "Use all four values in `hours`; don't hard-code a smaller subset."
--- hint
`hours` is a pandas Series. It knows how to compute its own mean.
--- hint
Call `hours.mean()` and assign the result to `average`.
```

## Your first debug

This one already runs. That is the dangerous kind. The loop adds a price and a quantity instead of multiplying them, so the reported revenue is nonsense but looks plausible.

Run it, read the output, then fix the operator. Keep the loop and the `zip`.

```python debug id=revenue-miscalculation title="Revenue that doesn't add up"
prices = [12.50, 8.00, 5.25]
quantities = [2, 3, 4]

revenue = 0
for price, quantity in zip(prices, quantities):
    revenue += price + quantity   # price * quantity is what we mean

print(round(revenue, 2))
--- solution
prices = [12.50, 8.00, 5.25]
quantities = [2, 3, 4]

revenue = 0
for price, quantity in zip(prices, quantities):
    revenue += price * quantity

print(round(revenue, 2))
--- test
assert revenue == 70.0, f"`revenue` should be 70.0 (25 + 24 + 21), but it is {revenue!r}. What does price + quantity represent?"
assert _stdout.strip() == "70.0", f"The printed revenue should be 70.0, but the output was {_stdout.strip()!r}."
--- hint
Read the loop body literally. `price + quantity` adds $12.50 to 2 units, which is not the same as selling 2 units at $12.50 each.
--- hint
Change the `+` in `revenue +=` to `*`. Leave the rest of the loop alone.
```

## Predict the output

Before running anything, decide what this cell prints.

```python predict id=predict-cohort-size title="How many rows?"
import pandas as pd

cohort = pd.DataFrame({
    "learner": ["Amina", "Ben", "Chloe", "Diego"],
    "hours": [4.5, 2.0, 6.0, 3.5],
})

print(len(cohort))
--- options
3
* 4
5
Error: a DataFrame has no length
--- explain
`len(df)` returns the number of rows, not the number of columns. There are four learners, so the answer is 4. Use `df.shape` when you want both dimensions: `(4, 2)`.
```

## One last look at the data

You can always ask a table how big it is and what types it holds. `shape` is `(rows, columns)`; `dtypes` tells you which columns are numbers, text or booleans.

```python run
print("shape:", cohort.shape)
print("\ntypes:")
print(cohort.dtypes)
```

Those two lines are the first thing to run on any unfamiliar dataset. A numeric column stored as text is one of the most common causes of a "correct" analysis that is quietly wrong.

## Recap

- Cells are live: edit, run, and read the output. Variables persist across run cells.
- A challenge runs in a fresh namespace and is checked by hidden tests, so it must define everything it needs.
- Debug challenges are bugs that already run; predict questions force you to commit before executing.
- `df.shape` gives rows and columns; `df.dtypes` tells you whether the columns mean what you think.
- Progress is earned by passing tests, not by scrolling.

**Up next:** you'll build the Python foundation every pandas operation rests on — variables, types, conditions and loops — using a messy orders dataset.
