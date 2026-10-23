Welcome to **NumPy Mastery**. You won't watch a single video in this course. Every lesson is a live coding environment, so you learn NumPy the way professionals actually learn it: by writing code, running it, breaking it, and fixing it.

There's a real Python interpreter running **inside this page**, with NumPy installed. Nothing to install, no notebooks to set up. This first lesson is a quick tour of the tools you'll use in every lesson after this one.

> **How to use this lesson:** read a little, run a little. Every grey box below is code you can edit and run.

## Run your first cell

Click **Run** on the cell below, or click inside it and press **Shift + Enter**.

```python run
import numpy as np

print("Hello from NumPy", np.__version__)
np.array([1, 2, 3]) * 10
```

Two things just happened:

1. `print(...)` wrote a line of text to the output.
2. The **last line** of the cell is an expression, so its value was displayed automatically, just like in a Jupyter notebook. Above the value you'll see a small label like `ndarray · shape (3,) · int32` telling you exactly what kind of array you got. You'll learn to read that label constantly.

> **Tip:** `numpy` is already imported as `np` in every cell, but writing `import numpy as np` yourself is a good habit. Real scripts always need it.

## Cells share memory, like a notebook

Variables you create in one cell are available in the cells that come after it, as long as you've **run** the earlier cell first.

```python run
temperatures = np.array([18.5, 21.0, 23.4, 19.8, 25.1])
print("Recorded", temperatures.size, "temperatures")
```

```python run
# Uses `temperatures` from the previous cell
warmest = temperatures.max()
print(f"Warmest day: {warmest}°C")
temperatures - temperatures.mean()
```

If you see a `NameError` here, run the cell above first. You can also click **Run all** in the bar at the top of the lesson. That bar also has **Restart** (wipe every variable and start fresh) and **Variables**, which shows everything currently in memory with its shape and dtype. Open it now and you'll find `temperatures` and `warmest`.

Edit freely. Change the numbers above and re-run both cells. If you make a mess, use the **⋯** menu on a cell and choose **Reset to original**.

## Errors are part of learning

You're going to see a lot of errors, and that's the point. Run this cell; it fails on purpose:

```python run error
prices = np.array([9.99, 4.50, 12.00])
quantities = np.array([3, 1])

prices * quantities
```

Notice three things about the error card:

- **The exact line** that failed is highlighted in red in the editor.
- A **plain-language tip** explains what this kind of error usually means. Here it's a *broadcasting* error, the most common NumPy error of all, which gets a whole lesson later.
- **Explain with Atlas** sends your code and the error to your AI tutor, who explains what went wrong without just rewriting your code.

Try fixing it: add a third quantity, like `[3, 1, 2]`, and run it again.

## Step through code with the debugger

Reading code is one thing; *watching* it run is another. Click **Debug** on the cell below instead of Run.

```python run
balance = 100.0
rates = np.array([0.05, 0.02, 0.04])

for year, rate in enumerate(rates, start=1):
    interest = balance * rate
    balance = balance + interest
    print(f"Year {year}: +{interest:.2f} -> {balance:.2f}")

balance
```

The debugger records the whole run, then lets you move through it:

- **Step** (→) moves forward one line, and **←** steps *back* in time.
- The **Variables** table highlights values that just **changed** in amber and values that are **new** in green.
- Click in the **gutter**, just left of the line numbers, to set a red **breakpoint**, then press **Continue** (F8) to jump straight to it.
- Drag the **timeline** slider to scrub through the entire execution.

Set a breakpoint on line 5 (`interest = ...`) and press Continue a few times. Watch `balance` grow each year.

## Predict before you run

Expert NumPy users can *predict* what code will do before running it. Predict cells train exactly that skill: pick an answer, and the code runs to show you the truth.

```python predict id=predict-shape title="What does this print?"
grid = np.zeros((3, 4))
print(grid.shape)
--- options
(4, 3)
* (3, 4)
(12,)
3
--- explain
`np.zeros((3, 4))` creates **3 rows and 4 columns**. `.shape` always lists the size of each dimension in order, so rows come first.
```

## Challenges: you write the code

Most of your learning happens in **challenges**. Each one has a goal, some starter code, and hidden tests. Write your solution, then press **Check** (or **Ctrl + Shift + Enter**).

- Stuck? Click **Hint**. Hints are revealed one at a time, from a gentle nudge to an almost-answer.
- Still stuck after a failed check? You can reveal the **reference solution**, but try for at least a few minutes first. The struggle is where the learning happens.
- Your solved challenges are saved to your account, and **solving every challenge in a lesson completes it automatically.**

```python exercise id=first-challenge title="Find the best score"
scores = np.array([88, 92, 79, 95, 84])

# Store the highest score in `best`, and the average score in `average`.
best = ...
average = ...
--- solution
scores = np.array([88, 92, 79, 95, 84])

best = scores.max()
average = scores.mean()
--- test
assert best is not ..., "Replace the `...` after `best =` with your code."
assert average is not ..., "Replace the `...` after `average =` with your code."
assert best == 95, f"`best` should be the highest score, but it is {best!r}."
assert np.isclose(average, 87.6), f"`average` should be the mean of the scores, but it is {average!r}."
--- hint
NumPy arrays have methods for common summaries. You already saw one of them earlier in this lesson.
--- hint
Try `scores.max()` for the highest value. There's a similarly named method for the average.
```

## Debug challenges: find and fix the bug

Some challenges hand you code that's **almost** right. Your job is to find the bug and fix it. Use **Run** to see the symptom and **Debug** to watch what's happening, then fix it and press **Check**.

```python debug id=first-bug title="The total is not a number"
order = np.array([12.5, 8.0, 3.25])

total = order.sum
print("Order total:", total)
--- solution
order = np.array([12.5, 8.0, 3.25])

total = order.sum()
print("Order total:", total)
--- test
assert callable(total) is False, "`total` is still a function, not a number. Did you call it?"
assert np.isclose(total, 23.75), f"`total` should be 23.75 but it is {total!r}."
assert "23.75" in _stdout, "Print the total so you can see it."
--- hint
Run the cell and look closely at what gets printed. Is that a number?
--- hint
`order.sum` *refers to* the method; `order.sum()` *calls* it.
```

## Your toolkit at a glance

| Action | How |
|---|---|
| Run a cell | **Run** or **Shift + Enter** |
| Check a challenge | **Check** or **Ctrl + Shift + Enter** |
| Step through code | **Debug**, then → / ← or F8 |
| Set a breakpoint | Click the gutter left of a line number |
| See all variables | **Variables** in the top bar |
| Start fresh | **Restart** in the top bar |
| Get help | **Hint**, **Explain with Atlas**, or the Q&A tab |
| Autocomplete | Type `np.` and wait a moment |

## Recap

- Every lesson runs real Python and NumPy in your browser. Edit everything.
- Example cells share variables in the order you run them; challenges run on their own.
- Errors come with the failing line, a plain-language tip and an AI explanation.
- The debugger lets you step forwards *and backwards* through any cell.
- Solve every challenge to complete a lesson.

**Up next:** why NumPy exists at all, and why `np.array` beats a Python list by a factor of 50 or more.
