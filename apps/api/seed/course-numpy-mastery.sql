DELETE FROM exercise_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_numpy_mastery');

DELETE FROM quiz_attempts WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_numpy_mastery');

DELETE FROM notes WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_numpy_mastery');

DELETE FROM lesson_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_numpy_mastery');

DELETE FROM discussions WHERE course_id = 'crs_numpy_mastery';

DELETE FROM certificates WHERE course_id = 'crs_numpy_mastery';

DELETE FROM enrollments WHERE course_id = 'crs_numpy_mastery';

DELETE FROM reviews WHERE course_id = 'crs_numpy_mastery';

DELETE FROM wishlist WHERE course_id = 'crs_numpy_mastery';

DELETE FROM path_courses WHERE course_id = 'crs_numpy_mastery';

DELETE FROM coupons WHERE course_id = 'crs_numpy_mastery';

DELETE FROM lessons WHERE course_id = 'crs_numpy_mastery';

DELETE FROM sections WHERE course_id = 'crs_numpy_mastery';

UPDATE order_items SET course_id = NULL WHERE course_id = 'crs_numpy_mastery';

DELETE FROM courses WHERE id = 'crs_numpy_mastery';

INSERT INTO courses (id, slug, title, subtitle, description, category_id, instructor_id, level, language, price_cents, compare_at_price_cents, currency, thumbnail_key, preview_video_url, accent, status, featured, what_you_learn, requirements, target_audience, tags, duration_minutes, lessons_count, rating_avg, rating_count, students_count, published_at, created_at, updated_at) VALUES
('crs_numpy_mastery', 'numpy-mastery', 'NumPy Mastery: The Interactive Course', 'Write, run and debug real NumPy in your browser, from your first array to vectorized machine-learning code.', 'Most people learn NumPy by copying snippets until something works. This course is different: **every lesson is a live coding environment**. You read a short explanation, run the code, change it, break it, and fix it, all inside your browser with a real Python interpreter and NumPy.

## Learn by doing, not by watching

- **Runnable code everywhere.** Every example is editable and runs instantly. Variables persist across cells like a notebook.
- **140 hands-on challenges.** Each one is checked automatically, with progressive hints when you''re stuck.
- **Debug challenges.** You get realistic buggy code (wrong axis, accidental copy, broadcasting mistakes) and fix it.
- **A real debugger.** Step through code line by line, set breakpoints, and watch every variable change.
- **48 predict-the-output questions** build the intuition that separates NumPy beginners from experts.
- **Atlas, your AI tutor,** explains any error in plain language without handing you the answer.

## What you''ll build

You''ll finish with three capstone projects written from scratch in pure NumPy: **k-means clustering**, **linear regression trained with gradient descent**, and a **Game of Life + Monte Carlo simulation**. These are the same building blocks used inside scikit-learn, PyTorch and pandas.

## Why NumPy?

NumPy is the foundation of the entire Python data stack. pandas, scikit-learn, PyTorch, JAX, SciPy and matplotlib all speak its language. Once you think in arrays, everything else gets easier.', 'cat_data-science', 'usr_daniel', 'beginner', 'English', 6900, 12900, 'USD', NULL, NULL, 205, 'published', 1, '["Create, index, reshape and combine N-dimensional arrays with confidence","Replace slow Python loops with fast, vectorized NumPy code","Master broadcasting, the axis argument and views vs. copies","Solve linear systems, compute statistics and work with images as arrays","Debug shape, dtype and broadcasting errors like a pro, with a real step-through debugger","Build k-means, linear regression and simulations from scratch"]', '["Basic Python: variables, lists, loops and functions","A modern browser. Nothing to install; Python runs in the page"]', '["Python developers moving into data science or machine learning","Students who want NumPy fluency before deep learning","Analysts who want to go beyond spreadsheets and pandas one-liners"]', '["NumPy","Python","Interactive","Data Science","Linear Algebra"]', 528, 36, 0, 0, 21360, '2025-12-10T11:38:55.077Z', '2025-11-10T11:38:55.077Z', '2026-10-15T11:38:55.077Z');

INSERT INTO sections (id, course_id, title, position, created_at) VALUES
('sec_numpy_1', 'crs_numpy_mastery', 'Welcome to NumPy', 0, '2026-06-24T11:38:55.077Z'),
('sec_numpy_2', 'crs_numpy_mastery', 'Creating Arrays', 1, '2026-06-24T11:38:55.077Z'),
('sec_numpy_3', 'crs_numpy_mastery', 'Indexing & Selection', 2, '2026-06-24T11:38:55.077Z'),
('sec_numpy_4', 'crs_numpy_mastery', 'Reshaping & Combining', 3, '2026-06-24T11:38:55.077Z'),
('sec_numpy_5', 'crs_numpy_mastery', 'Vectorized Computation', 4, '2026-06-24T11:38:55.077Z'),
('sec_numpy_6', 'crs_numpy_mastery', 'Linear Algebra & Statistics', 5, '2026-06-24T11:38:55.077Z'),
('sec_numpy_7', 'crs_numpy_mastery', 'NumPy in the Real World', 6, '2026-06-24T11:38:55.077Z'),
('sec_numpy_8', 'crs_numpy_mastery', 'Capstone Projects', 7, '2026-06-24T11:38:55.077Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_numpy_1_1', 'sec_numpy_1', 'crs_numpy_mastery', 'How this course works', 'interactive', 0, 480, NULL, NULL, 'Welcome to **NumPy Mastery**. You won''t watch a single video in this course. Every lesson is a live coding environment, so you learn NumPy the way professionals actually learn it: by writing code, running it, breaking it, and fixing it.

There''s a real Python interpreter running **inside this page**, with NumPy installed. Nothing to install, no notebooks to set up. This first lesson is a quick tour of the tools you''ll use in every lesson after this one.

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
2. The **last line** of the cell is an expression, so its value was displayed automatically, just like in a Jupyter notebook. Above the value you''ll see a small label like `ndarray · shape (3,) · int32` telling you exactly what kind of array you got. You''ll learn to read that label constantly.

> **Tip:** `numpy` is already imported as `np` in every cell, but writing `import numpy as np` yourself is a good habit. Real scripts always need it.

## Cells share memory, like a notebook

Variables you create in one cell are available in the cells that come after it, as long as you''ve **run** the earlier cell first.

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

If you see a `NameError` here, run the cell above first. You can also click **Run all** in the bar at the top of the lesson. That bar also has **Restart** (wipe every variable and start fresh) and **Variables**, which shows everything currently in memory with its shape and dtype. Open it now and you''ll find `temperatures` and `warmest`.

Edit freely. Change the numbers above and re-run both cells. If you make a mess, use the **⋯** menu on a cell and choose **Reset to original**.

## Errors are part of learning

You''re going to see a lot of errors, and that''s the point. Run this cell; it fails on purpose:

```python run error
prices = np.array([9.99, 4.50, 12.00])
quantities = np.array([3, 1])

prices * quantities
```

Notice three things about the error card:

- **The exact line** that failed is highlighted in red in the editor.
- A **plain-language tip** explains what this kind of error usually means. Here it''s a *broadcasting* error, the most common NumPy error of all, which gets a whole lesson later.
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
Try `scores.max()` for the highest value. There''s a similarly named method for the average.
```

## Debug challenges: find and fix the bug

Some challenges hand you code that''s **almost** right. Your job is to find the bug and fix it. Use **Run** to see the symptom and **Debug** to watch what''s happening, then fix it and press **Check**.

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
', 1, '[]', '[{"title":"NumPy: the absolute basics for beginners","url":"https://numpy.org/doc/stable/user/absolute_beginners.html"},{"title":"NumPy API reference","url":"https://numpy.org/doc/stable/reference/index.html"}]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_1_2', 'sec_numpy_1', 'crs_numpy_mastery', 'Why NumPy? Lists vs. arrays', 'interactive', 1, 840, NULL, NULL, 'Python lists are wonderful. They hold anything, grow on demand, and you''ve used them since your first week of Python. So why does every data library, from pandas and scikit-learn to PyTorch and JAX, build on a different container?

Because lists are built for **flexibility**, and numerical work needs **speed and math**. By the end of this lesson you''ll understand what a NumPy array really is, why it''s often 50× faster than a list, and when a plain list is still the right tool.

## Lists don''t do math

Start with something that looks like it should work. Two lists of numbers, added together:

```python run
a = [1, 2, 3]
b = [10, 20, 30]

print("a + b =", a + b)
print("a * 3 =", a * 3)
```

That''s not arithmetic. To a list, `+` means **concatenate** and `* 3` means **repeat three times**. Lists are general-purpose sequences: they have no idea their contents are numbers.

To add element by element with lists, you need a loop (or a comprehension):

```python run
a = [1, 2, 3]
b = [10, 20, 30]

sums = [x + y for x, y in zip(a, b)]
scaled = [x * 3 for x in a]
print("sums:  ", sums)
print("scaled:", scaled)
```

It works, but you''ll write that pattern thousands of times, and as you''ll see shortly, it''s slow.

## Arrays do math, element by element

A NumPy array looks like a list but behaves like a mathematical vector. Operators apply **to every element**:

```python run
import numpy as np

a = np.array([1, 2, 3])
b = np.array([10, 20, 30])

print("a + b  =", a + b)
print("a * 3  =", a * 3)
print("a ** 2 =", a ** 2)
print("b / a  =", b / a)
```

No loops, no comprehensions. This style, operating on whole arrays at once, is called **vectorization**, and it''s the single most important idea in this course.

Notice the printed form too: arrays print with **spaces, not commas**: `[11 22 33]`, not `[11, 22, 33]`. That''s how you can tell an array from a list at a glance.

```python predict id=predict-array-times-two title="What does this print?"
a = np.array([1, 2, 3])
print(a * 2)
--- options
[2, 4, 6]
* [2 4 6]
[1 2 3 1 2 3]
[1, 2, 3, 1, 2, 3]
--- explain
Arrays multiply **element-wise**, so every element is doubled. And arrays print without commas: `[2 4 6]`. The list version, `[1, 2, 3] * 2`, would repeat the list instead: `[1, 2, 3, 1, 2, 3]`.
```

```python exercise id=price-with-tax title="Add sales tax to every price"
prices = [19.99, 5.49, 120.00, 42.50]

# 1. Convert `prices` into a NumPy array called `prices_arr`.
# 2. Compute `with_tax`: every price increased by 20% (multiply by 1.2).
#    No loops or comprehensions. Let NumPy do the work.
prices_arr = ...
with_tax = ...
--- solution
prices = [19.99, 5.49, 120.00, 42.50]

prices_arr = np.array(prices)
with_tax = prices_arr * 1.2
--- test
assert prices_arr is not ..., "Replace the `...` after `prices_arr =` with your code."
assert isinstance(prices_arr, np.ndarray), f"`prices_arr` should be a NumPy array, but it is a {type(prices_arr).__name__}. Try `np.array(prices)`."
assert with_tax is not ..., "Replace the `...` after `with_tax =` with your code."
assert isinstance(with_tax, np.ndarray), f"`with_tax` should be a NumPy array, but it is a {type(with_tax).__name__}."
assert with_tax.shape == (4,), f"`with_tax` should hold 4 prices, but its shape is {with_tax.shape}."
assert np.allclose(with_tax, [23.988, 6.588, 144.0, 51.0]), "Each price should be multiplied by 1.2. Check your numbers."
--- hint
First turn the list into an array with `np.array(...)`. Once you have an array, arithmetic applies to every element.
--- hint
`prices_arr * 1.2` multiplies each element by 1.2.
```

## Why arrays are fast

Let''s measure. We''ll sum the squares of 200,000 numbers, once with a Python loop and once with NumPy:

```python run
import time

n = 200_000
numbers = list(range(n))
arr = np.arange(n, dtype=np.float64)

start = time.perf_counter()
total = 0
for x in numbers:
    total += x * x
loop_ms = (time.perf_counter() - start) * 1000

start = time.perf_counter()
total_np = (arr * arr).sum()
numpy_ms = (time.perf_counter() - start) * 1000

print(f"Python loop: {loop_ms:7.2f} ms")
print(f"NumPy:       {numpy_ms:7.2f} ms")
print(f"Speed-up:    {loop_ms / numpy_ms:.0f}x")
```

Run it a few times: the exact numbers vary, but NumPy wins by a wide margin. (Here `np.arange(n)` just means "the numbers 0 to n-1 as an array". You''ll meet it properly in a later lesson.)

Where does that speed come from? It''s all about how the data is stored.

> **Under the hood:** a Python list is an array of *pointers*. Each element is a separate Python object living somewhere else in memory, with its own type tag and reference count. To add two elements, the interpreter must follow both pointers, check both types, find the right `+`, and allocate a brand-new object for the result.
>
> A NumPy array is a single **contiguous block of raw numbers**, all of the **same type**. Adding two arrays runs one tight loop in compiled C over that block, with no type checks per element and no objects created. Modern CPUs love this layout: it fits caches well and can process several numbers per instruction.

Two properties make all of that possible:

| | Python list | NumPy array |
|---|---|---|
| Element types | Anything, mixed | **One** type for all elements (the *dtype*) |
| Storage | Pointers to scattered objects | One contiguous block of raw values |
| `+` and `*` | Concatenate / repeat | Element-wise math |
| Size | Grows with `.append` | Fixed when created |
| Speed on numbers | Interpreter loop | Compiled loop over raw memory |

## Arrays are compact, too

All those separate Python objects cost memory. Let''s compare 1,000 floats:

```python run
import sys

values = [float(i) for i in range(1000)]
arr = np.array(values)

list_bytes = sys.getsizeof(values) + sum(sys.getsizeof(v) for v in values)
print(f"list : {list_bytes:,} bytes")
print(f"array: {arr.nbytes:,} bytes of data")
print(f"The list uses about {list_bytes / arr.nbytes:.1f}x more memory")
```

Each float in the array takes exactly 8 bytes. In a list, each float is a full Python object (24 bytes) *plus* an 8-byte pointer to it. With millions of values, that difference decides whether your data fits in memory at all.

## One array, one type

Because an array stores raw values of a single type, NumPy must pick **one** type that fits everything you give it. Watch what happens with mixed inputs:

```python run
ints = np.array([1, 2, 3])
mixed = np.array([1, 2.5, 3])
words = np.array([1, "two", 3.0])

print(ints, "->", ints.dtype)
print(mixed, "->", mixed.dtype)
print(words, "->", words.dtype)
```

- A single float makes the whole array `float64`: the integers are converted to `1.0` and `3.0`.
- A string makes everything a string (`<U32` means "Unicode string, up to 32 characters"). Your numbers are now text, and math on them will fail.

> **Pitfall:** the integer type you see may be `int64` *or* `int32`. NumPy uses your platform''s native integer size, and this in-browser Python uses 32-bit integers, while most desktop Pythons use 64-bit. Floats are `float64` everywhere. You''ll learn to control dtypes precisely in a later lesson.

```python debug id=list-math-bug title="Adding up two sensors"
# Two sensors measured the same 4 moments. We want the element-wise total,
# e.g. the first total should be 1.5 + 0.5 = 2.0
sensor_a = [1.5, 2.0, 2.5, 3.0]
sensor_b = [0.5, 0.5, 1.0, 1.0]

total = sensor_a + sensor_b
print("total:", total)
--- solution
sensor_a = np.array([1.5, 2.0, 2.5, 3.0])
sensor_b = np.array([0.5, 0.5, 1.0, 1.0])

total = sensor_a + sensor_b
print("total:", total)
--- test
assert len(total) == 4, f"`total` should have 4 values (one per moment), but it has {len(total)}. Did the two lists get glued together?"
assert np.allclose(total, [2.0, 2.5, 3.5, 4.0]), "Each value of `total` should be sensor_a + sensor_b at that moment."
assert isinstance(total, np.ndarray), "Make `total` a NumPy array by working with arrays instead of lists."
--- hint
Run the code and count how many values `total` has. Is that what "element-wise total" means?
--- hint
With lists, `+` concatenates. Convert the readings to NumPy arrays first, and `+` will add element by element.
```

```python exercise id=celsius-to-fahrenheit title="Convert a week of temperatures"
celsius = [12.0, 15.5, 18.0, 21.5, 19.0, 16.5, 14.0]

# Convert every temperature to Fahrenheit using  F = C * 9/5 + 32
# Store the result as a NumPy array in `fahrenheit`. One line, no loop.
fahrenheit = ...
--- solution
celsius = [12.0, 15.5, 18.0, 21.5, 19.0, 16.5, 14.0]

fahrenheit = np.array(celsius) * 9 / 5 + 32
--- test
assert fahrenheit is not ..., "Replace the `...` with your conversion."
assert isinstance(fahrenheit, np.ndarray), f"`fahrenheit` should be a NumPy array, but it is a {type(fahrenheit).__name__}."
assert fahrenheit.shape == (7,), f"There are 7 temperatures, but `fahrenheit` has shape {fahrenheit.shape}."
expected = np.array(celsius) * 9 / 5 + 32
assert np.allclose(fahrenheit, expected), f"The first value should be {expected[0]:.1f}°F (12°C). Check the formula: C * 9/5 + 32."
--- hint
Convert the list with `np.array(celsius)`, then write the formula exactly as you would for a single number.
--- hint
`np.array(celsius) * 9 / 5 + 32` applies the formula to all seven values at once.
```

## When lists are still the right tool

NumPy arrays are not a replacement for lists everywhere. Lists are better when:

- **You''re building a collection one item at a time.** Lists append in constant time. An array has a fixed size, so `np.append` copies the *entire* array every call.
- **The data is ragged or mixed:** rows of different lengths, records that combine names, numbers and dates.
- **The collection is small and you aren''t doing math on it.** A list of five file names doesn''t need NumPy.

The idiomatic pattern is: **collect in a list, convert once, then compute with arrays.**

```python run
import time

n = 5_000

start = time.perf_counter()
grown = np.array([])
for i in range(n):
    grown = np.append(grown, i * 0.5)   # copies the whole array every time!
append_ms = (time.perf_counter() - start) * 1000

start = time.perf_counter()
items = []
for i in range(n):
    items.append(i * 0.5)               # cheap
collected = np.array(items)             # convert once
list_ms = (time.perf_counter() - start) * 1000

print(f"np.append in a loop: {append_ms:6.1f} ms")
print(f"list, then convert:  {list_ms:6.1f} ms")
print("same result:", np.array_equal(grown, collected))
```

> **In the wild:** this is exactly why pandas tells you not to grow a DataFrame row by row. Each append copies everything. Build a list of rows (or dicts) and construct the DataFrame once.

```python debug id=append-in-loop-bug title="Where did my results go?"
readings = [3, 1, 4, 1, 5, 9, 2, 6]

# Goal: `squares` should hold the square of every reading.
squares = np.array([])
for r in readings:
    np.append(squares, r ** 2)

print("squares:", squares)
--- solution
readings = [3, 1, 4, 1, 5, 9, 2, 6]

squares = np.array(readings) ** 2

print("squares:", squares)
--- test
assert isinstance(squares, np.ndarray), "`squares` should be a NumPy array."
assert squares.size == 8, f"`squares` should hold 8 values, one per reading, but it holds {squares.size}."
assert np.allclose(squares, [9, 1, 16, 1, 25, 81, 4, 36]), "Each value should be the square of the matching reading."
--- hint
Run it with **Debug** and watch `squares` as the loop runs. Does it ever change?
--- hint
`np.append` doesn''t modify the array in place. It *returns a new array*, and here that return value is thrown away.
--- hint
You don''t need a loop at all: convert `readings` to an array and square the whole thing with `** 2`.
```

## Recap

- Lists treat `+` as concatenation and `*` as repetition; arrays do **element-wise math**.
- An array is one contiguous block of values that all share **one dtype**, which is why vectorized code runs in compiled C and is dramatically faster.
- Arrays are compact: 8 bytes per float instead of more than 30 for a Python float in a list.
- Mixed inputs are converted to a single common type. A stray string turns everything into text.
- Use lists to *collect* data and arrays to *compute* on it; never grow an array with `np.append` in a loop.

**Up next:** creating your first arrays, and reading their `shape`, `dtype` and other vital statistics.
', 1, '[]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_1_3', 'sec_numpy_1', 'crs_numpy_mastery', 'Your first arrays: shape, dtype and friends', 'interactive', 2, 960, NULL, NULL, 'Every NumPy workflow starts the same way: you turn some data into an array, then ask it questions. *How big are you? How many dimensions? What type are your numbers?* Professionals check these constantly. Most NumPy bugs are shape or dtype surprises that a quick look at `.shape` would have caught.

In this lesson you''ll create 1-D, 2-D and 3-D arrays from Python lists, and learn the handful of attributes that describe every array. By the end you''ll read `ndarray · shape (2, 3) · float64` the way a doctor reads a pulse.

## From lists to arrays

`np.array` takes a list, or a list of lists, and builds an array from it:

```python run
import numpy as np

prices = np.array([4.99, 2.50, 7.25])
prices
```

A **list of lists** becomes a 2-D array. Each inner list is a **row**:

```python run
grid = np.array([
    [1, 2, 3],
    [4, 5, 6],
])
grid
```

Go one level deeper and you get 3-D: here, 2 "pages", each with 2 rows and 3 columns. Think of a stack of spreadsheets, or a short video of tiny grayscale frames.

```python run
cube = np.array([
    [[1, 2, 3], [4, 5, 6]],
    [[7, 8, 9], [10, 11, 12]],
])
print(cube)
print("shape:", cube.shape)
```

## The vital statistics of an array

Every array carries a few attributes that describe it completely:

| Attribute | Meaning | For `grid` above |
|---|---|---|
| `.shape` | Size along each dimension, as a tuple | `(2, 3)` |
| `.ndim` | Number of dimensions (*axes*) | `2` |
| `.size` | Total number of elements | `6` |
| `.dtype` | The single type shared by every element | an integer type |
| `.itemsize` | Bytes per element | depends on dtype |
| `.nbytes` | Total bytes of data (`size × itemsize`) | depends on dtype |

```python run
readings = np.array([
    [20.1, 20.4, 21.0, 21.7],
    [19.8, 19.9, 20.2, 20.6],
    [22.3, 22.9, 23.1, 23.8],
])

print("shape:   ", readings.shape)
print("ndim:    ", readings.ndim)
print("size:    ", readings.size)
print("dtype:   ", readings.dtype)
print("itemsize:", readings.itemsize, "bytes")
print("nbytes:  ", readings.nbytes, "bytes")
```

Read the shape **from the outside in**: `(3, 4)` means 3 rows, each with 4 columns. For 3-D arrays, `(pages, rows, columns)`.

> **Tip:** that''s exactly what the small label above a displayed value tells you. `ndarray · shape (3, 4) · float64` is the type, the shape and the dtype at a glance. Get in the habit of glancing at it after every run.

```python predict id=predict-vital-stats title="What does this print?"
m = np.array([[1, 2, 3], [4, 5, 6]])
print(m.shape, m.ndim, m.size)
--- options
(3, 2) 2 6
* (2, 3) 2 6
(2, 3) 6 2
(2, 3) 2 3
--- explain
Two inner lists means **2 rows**, each with **3 columns**, so the shape is `(2, 3)`. There are two dimensions (`ndim` is 2) and 2 × 3 = **6** elements in total.
```

`len()` works on arrays too, but it only counts the **first** dimension, the number of rows:

```python run
print("len(readings) =", len(readings))
print("readings.shape[0] =", readings.shape[0])
print("readings.size =", readings.size)
```

> **Pitfall:** `len(a)` is *not* the number of elements for a 2-D array. Use `a.size` for the total and `a.shape[1]` for the number of columns.

```python exercise id=sales-table title="Build a sales table"
# Quarterly sales (in $1000s) for three stores:
#   Downtown:  120, 135, 150, 170
#   Airport:    90,  95, 110, 105
#   Suburbs:    60,  80,  75,  95
#
# 1. Build a 2-D array `sales` with one ROW per store (in the order above)
#    and one COLUMN per quarter.
# 2. Use attributes (not hard-coded numbers) to set:
#    n_stores   = number of rows
#    n_quarters = number of columns
sales = ...
n_stores = ...
n_quarters = ...
--- solution
sales = np.array([
    [120, 135, 150, 170],
    [90, 95, 110, 105],
    [60, 80, 75, 95],
])
n_stores = sales.shape[0]
n_quarters = sales.shape[1]
--- test
assert sales is not ..., "Replace the `...` after `sales =` with a nested list wrapped in `np.array(...)`."
assert isinstance(sales, np.ndarray), f"`sales` should be a NumPy array, but it is a {type(sales).__name__}."
assert sales.ndim == 2, f"`sales` should be 2-D (rows and columns) but has {sales.ndim} dimension(s)."
assert sales.shape == (3, 4), f"`sales` should have shape (3, 4): 3 stores × 4 quarters. Yours is {sales.shape}."
assert np.array_equal(sales[0], [120, 135, 150, 170]), "The first row should be the Downtown store''s four quarters."
assert np.array_equal(sales, [[120, 135, 150, 170], [90, 95, 110, 105], [60, 80, 75, 95]]), "Some values don''t match the data in the comment. Check each row."
assert n_stores == 3 and n_quarters == 4, f"Expected n_stores=3 and n_quarters=4, got {n_stores} and {n_quarters}."
--- hint
Each store becomes one inner list, and the outer list holds the three stores: `np.array([[...], [...], [...]])`.
--- hint
`sales.shape` is a tuple `(rows, columns)`. Index into it with `[0]` and `[1]`.
```

## How NumPy chooses a dtype

When you don''t specify a dtype, NumPy picks the simplest type that can hold **all** your values:

```python run
print(np.array([1, 2, 3]).dtype)            # whole numbers  -> integer
print(np.array([1, 2.0, 3]).dtype)          # any float       -> float64
print(np.array([True, False, True]).dtype)  # booleans        -> bool
print(np.array([1 + 2j, 3]).dtype)          # any complex     -> complex128
```

The integer line may say `int64` or `int32`. NumPy''s default integer matches the platform. This in-browser Python is a 32-bit platform, so it uses `int32`; most laptops and servers use `int64`. Floats are always `float64` by default.

You can also choose the dtype yourself with `dtype=`. Smaller types use less memory, which matters for big data like images:

```python run
for dt in [np.float64, np.float32, np.int16, np.uint8]:
    a = np.array([1, 2, 3, 4], dtype=dt)
    print(f"{str(a.dtype):8}  itemsize={a.itemsize}  nbytes={a.nbytes}")
```

`uint8` means *unsigned 8-bit integer*: values from 0 to 255 in a single byte. It''s exactly what image pixels use.

```python exercise id=compact-dtype title="Shrink a dataset"
levels = [12, 250, 7, 99, 180, 3, 64]   # sensor levels, always between 0 and 255

# 1. `wide`: an array of `levels` with dtype np.int64
# 2. `compact`: an array of `levels` with dtype np.uint8
# 3. `saved`: how many bytes `compact` saves compared to `wide` (use .nbytes)
wide = ...
compact = ...
saved = ...
--- solution
levels = [12, 250, 7, 99, 180, 3, 64]

wide = np.array(levels, dtype=np.int64)
compact = np.array(levels, dtype=np.uint8)
saved = wide.nbytes - compact.nbytes
--- test
assert wide is not ... and compact is not ..., "Replace the `...` placeholders for `wide` and `compact`."
assert isinstance(wide, np.ndarray) and isinstance(compact, np.ndarray), "`wide` and `compact` should both be NumPy arrays."
assert wide.dtype == np.int64, f"`wide` should have dtype int64, but it is {wide.dtype}. Pass dtype=np.int64."
assert compact.dtype == np.uint8, f"`compact` should have dtype uint8, but it is {compact.dtype}. Pass dtype=np.uint8."
assert np.array_equal(wide, levels) and np.array_equal(compact, levels), "Both arrays should contain the same seven levels."
assert saved is not ..., "Replace the `...` after `saved =`."
assert saved == 49, f"`saved` should be wide.nbytes - compact.nbytes. You have {saved!r}."
--- hint
`np.array(levels, dtype=np.uint8)` builds an array with a specific dtype.
--- hint
`int64` takes 8 bytes per element and `uint8` takes 1. Subtract the two `.nbytes` values.
```

## Arrays must be rectangular

Because an array is one regular block of memory, every row must have the **same length**. A ragged list can''t become a normal array:

```python run error
ragged = np.array([
    [1, 2, 3],
    [4, 5],
])
```

The message, *"inhomogeneous shape after 1 dimensions"*, means "row lengths don''t match". Fix the data (pad the short row, or drop it), or keep ragged data in a Python list.

> **Under the hood:** you *can* force it with `dtype=object`, but then each element is a pointer to a Python object again. You get none of NumPy''s speed. It''s an escape hatch, not a solution.

## Back to Python: `tolist()` and scalars

Sometimes you need plain Python data again, for JSON, a web API, or a library that expects lists. `.tolist()` converts the whole array, turning every element into a native Python number:

```python run
a = np.array([[1.5, 2.5], [3.5, 4.5]])
as_list = a.tolist()

print(as_list)
print("type of a[0, 0]:      ", type(a[0, 0]))
print("type of as_list[0][0]:", type(as_list[0][0]))
```

Indexing a single element gives you a **NumPy scalar** (like `np.float64`), which behaves like a number but keeps its dtype. `.item()` converts one element to a plain Python number.

An array can even have **zero** dimensions: a single value with shape `()`. You''ll occasionally get one from reductions or from wrapping a lone number:

```python run
zero_d = np.array(3.14)
print("ndim:", zero_d.ndim, " shape:", zero_d.shape, " size:", zero_d.size)
print("as a Python float:", zero_d.item())
np.array([10, 20, 30]).sum()
```

The last line displays `np.int32(60)` or `np.int64(60)`. That''s how NumPy 2 shows a scalar''s repr, with its dtype attached. `print()` shows just `60`.

```python predict id=predict-zero-d title="What does this print?"
x = np.array(7.5)
print(x.ndim, x.shape)
--- options
1 (1,)
* 0 ()
0 (1,)
1 ()
--- explain
`np.array(7.5)` wraps a single number without any list around it, so there are **no axes at all**. `ndim` is `0` and the shape is the empty tuple `()`. Compare `np.array([7.5])`, which is 1-D with shape `(1,)`.
```

```python exercise id=describe-array title="Write an array inspector"
# Write a function `describe(arr)` that returns a one-line summary string like:
#   "2-D array, shape (3, 4), 12 elements of float64"
# using the array''s attributes. It must work for ANY array you pass in.
def describe(arr):
    ...

print(describe(np.array([[1.0, 2.0], [3.0, 4.0]])))
--- solution
def describe(arr):
    return f"{arr.ndim}-D array, shape {arr.shape}, {arr.size} elements of {arr.dtype}"

print(describe(np.array([[1.0, 2.0], [3.0, 4.0]])))
--- test
r = describe(np.zeros((3, 4)))
assert r is not None, "`describe` returned None. Did you forget `return`?"
assert isinstance(r, str), f"`describe` should return a string, but it returned {type(r).__name__}."
assert r == "2-D array, shape (3, 4), 12 elements of float64", f"For a float64 array of shape (3, 4) expected ''2-D array, shape (3, 4), 12 elements of float64'' but got {r!r}."
r2 = describe(np.ones((2, 2, 5), dtype=np.float32))
assert r2 == "3-D array, shape (2, 2, 5), 20 elements of float32", f"Your function should work for any array. For shape (2, 2, 5) float32 it returned {r2!r}."
r3 = describe(np.array([True, False]))
assert r3 == "1-D array, shape (2,), 2 elements of bool", f"For a 1-D bool array it returned {r3!r}."
--- hint
An f-string can drop attributes right into the text: `f"{arr.ndim}-D array, ..."`.
--- hint
You need four attributes: `ndim`, `shape`, `size` and `dtype`. Printing a tuple or a dtype inside an f-string gives exactly the format shown.
```

## Two classic beginner bugs

```python debug id=nested-brackets-bug title="A 2×3 array that won''t build"
# We want a 2-D array with 2 rows and 3 columns.
matrix = np.array([1, 2, 3], [4, 5, 6])
print(matrix.shape)
--- solution
matrix = np.array([[1, 2, 3], [4, 5, 6]])
print(matrix.shape)
--- test
assert isinstance(matrix, np.ndarray), "`matrix` should be a NumPy array."
assert matrix.shape == (2, 3), f"`matrix` should have shape (2, 3), but it has {matrix.shape}."
assert np.array_equal(matrix, [[1, 2, 3], [4, 5, 6]]), "The rows should be [1, 2, 3] and [4, 5, 6]."
--- hint
The confusing "Field elements" error happens because NumPy is trying to read `[4, 5, 6]` as a *dtype* description. The second argument of `np.array` is `dtype`. Why did your second row end up there?
--- hint
`np.array` takes **one** data argument. Both rows must be inside a single outer list: `np.array([[...], [...]])`.
```

```python debug id=string-numbers-bug title="Numbers that came in as text"
# Values read from a CSV file arrive as strings.
raw = ["3.5", "4.0", "2.5", "5.0"]

values = np.array(raw)
average = values.mean()
print("average:", average)
--- solution
raw = ["3.5", "4.0", "2.5", "5.0"]

values = np.array(raw, dtype=float)
average = values.mean()
print("average:", average)
--- test
assert np.issubdtype(values.dtype, np.floating), f"`values` should hold numbers (a float dtype), but its dtype is {values.dtype}."
assert np.isclose(average, 3.75), f"`average` should be 3.75, got {average!r}."
--- hint
Check `values.dtype` (the Variables panel or the Debug button will show it). What does `<U3` mean?
--- hint
The array holds **text**, and you can''t take the mean of text. Ask NumPy to convert while building the array: `np.array(raw, dtype=float)`.
```

## Recap

- `np.array(list)` makes a 1-D array; nested lists make 2-D and 3-D arrays, with each inner list as a row.
- `.shape`, `.ndim`, `.size`, `.dtype`, `.itemsize` and `.nbytes` describe any array. Check them constantly.
- `len(a)` counts only the first axis; `a.size` counts every element.
- NumPy infers the simplest dtype that fits everything; set `dtype=` to control it. The default integer is platform-dependent (`int32` here).
- Arrays must be rectangular; ragged data stays in lists.
- `.tolist()` and `.item()` convert back to plain Python; a 0-d array has shape `()`.

**Up next:** you rarely type arrays out by hand. Meet the factory functions (`zeros`, `ones`, `full`, `eye`) that build arrays of any shape instantly.
', 0, '[]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_1_4', 'sec_numpy_1', 'crs_numpy_mastery', 'Checkpoint: NumPy fundamentals', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"What does `[1, 2, 3] + [4, 5, 6]` produce for Python lists, and what does `np.array([1, 2, 3]) + np.array([4, 5, 6])` produce?","options":["Both give [5, 7, 9]","The list version gives [1, 2, 3, 4, 5, 6]; the array version gives [5 7 9]","The list version raises a TypeError; the array version gives [5 7 9]","Both give [1, 2, 3, 4, 5, 6]"],"answerIndex":1,"explanation":"For lists, `+` means concatenation. For NumPy arrays, arithmetic operators work element by element."},{"id":"q2","prompt":"Which is the main reason vectorized NumPy code is much faster than a Python loop over a list?","options":["NumPy automatically runs your code on the GPU","NumPy caches the results of previous calculations","Python lists are limited to 1,000 elements","Arrays store same-typed raw values in one contiguous block, so the work runs in a compiled loop without per-element Python objects"],"answerIndex":3,"explanation":"A list holds pointers to separate Python objects, each needing type checks. An array is a homogeneous, contiguous buffer processed by compiled C loops."},{"id":"q3","prompt":"What is the dtype of `np.array([1, 2.5, 3])`?","options":["float64","An integer dtype","object","A string dtype"],"answerIndex":0,"explanation":"An array has a single dtype. One float forces every element to become a float, so the result is float64."},{"id":"q4","prompt":"For `a = np.array([[1, 2, 3], [4, 5, 6]])`, which statement is correct?","options":["a.shape == (3, 2) and len(a) == 6","a.shape == (2, 3) and len(a) == 6","a.shape == (2, 3) and len(a) == 2","a.ndim == 3 and a.size == 6"],"answerIndex":2,"explanation":"Two inner lists of three elements make shape (2, 3). `len` counts only the first axis (2 rows); `a.size` counts all 6 elements."},{"id":"q5","prompt":"You need to collect 10,000 measurements one at a time inside a loop, then analyze them. What is the idiomatic approach?","options":["Start with np.array([]) and call np.append in the loop","Append to a Python list in the loop, then convert once with np.array(...)","Create a string and convert it to an array at the end","Use np.concatenate on every iteration"],"answerIndex":1,"explanation":"Arrays have a fixed size, so np.append and np.concatenate copy the whole array every time. Lists append cheaply. Collect in a list, then convert once."},{"id":"q6","prompt":"What are `ndim` and `shape` of `np.array(4.2)`?","options":["ndim 0, shape ()","ndim 1, shape (1,)","ndim 1, shape ()","ndim 0, shape (1,)"],"answerIndex":0,"explanation":"Wrapping a lone number (no list) makes a 0-dimensional array: no axes, so the shape is the empty tuple ()."}]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_2_1', 'sec_numpy_2', 'crs_numpy_mastery', 'Array factories: zeros, ones, full and eye', 'interactive', 0, 840, NULL, NULL, 'You rarely type arrays out by hand. Real NumPy code starts with a **blank canvas**: a matrix of zeros to accumulate results into, a vector of ones to use as weights, an identity matrix for linear algebra, an array of `NaN`s that marks "no data yet". NumPy''s *factory functions* build these instantly, at any size, with exactly the dtype you ask for.

By the end of this lesson you''ll be able to allocate any array you need in one line, and you''ll know the two classic traps: passing a shape the wrong way and accidentally inheriting an integer dtype.

## `zeros` and `ones`: the workhorses

`np.zeros(shape)` and `np.ones(shape)` build arrays filled with 0 and 1. The **shape** is a single argument: an integer for 1-D, or a **tuple** for anything with more dimensions.

```python run
import numpy as np

print(np.zeros(5))
print()
print(np.ones((2, 4)))
```

Notice the dots: `0.` and `1.`. Factory functions default to **`float64`**, because most numerical work (averages, weights, probabilities) needs fractions. Ask for something else with `dtype=`:

```python run
counts = np.zeros(4, dtype=int)
flags = np.ones((2, 3), dtype=bool)

print(counts, counts.dtype)
print(flags)
```

> **Tip:** `dtype=int` gives you the platform''s default integer: `int64` on most desktops, and `int32` in this browser runtime, because WebAssembly is a 32-bit platform. When the exact width matters, say so explicitly with `dtype=np.int64`.

### The shape-tuple trap

This is one of the most common first-week NumPy errors. Can you spot what''s wrong before you run it?

```python run error
grid = np.zeros(3, 4)
```

`np.zeros` takes the shape as **one** argument. Here `3` was read as the shape and `4` as the *second* parameter, `dtype`. NumPy has no idea what data type "4" is, hence the cryptic message. The fix is a pair of parentheses: `np.zeros((3, 4))`.

> **Pitfall:** `np.zeros(3, 4)` fails, but `np.random.rand(3, 4)` works. Some older functions take the dimensions as separate arguments. Modern NumPy consistently uses a shape tuple, so make that your habit.

```python predict id=predict-default-dtype title="What dtype does np.zeros give you?"
a = np.zeros((2, 3))
print(a.dtype)
--- options
int64
* float64
int32
bool
--- explain
Unless you pass `dtype=`, `np.zeros`, `np.ones` and `np.empty` all produce **`float64`**, the double-precision floating point type that NumPy uses by default for numerical work.
```

```python exercise id=scoreboard title="Set up a scoreboard"
# A tournament has 4 players who each play 3 rounds.
# Create `board`: one row per player, one column per round,
# every score starting at 0, stored as integers.
board = ...
--- solution
board = np.zeros((4, 3), dtype=int)
--- test
assert board is not ..., "Replace the `...` with a call to a NumPy factory function."
assert isinstance(board, np.ndarray), f"`board` should be a NumPy array, not {type(board).__name__}."
assert board.shape == (4, 3), f"`board` should have shape (4, 3), one row per player and one column per round, but it has shape {board.shape}."
assert np.issubdtype(board.dtype, np.integer), f"Scores should be stored as integers, but `board` has dtype {board.dtype}. Pass `dtype=int`."
assert (board == 0).all(), "Every score should start at 0."
--- hint
You need a 2-D array of zeros. Remember the shape goes in as a single tuple: `(rows, columns)`.
--- hint
`np.zeros((rows, cols), dtype=...)`. Which dtype stores whole numbers?
```

## `full`: any constant you like

When the starting value isn''t 0 or 1, use `np.full(shape, fill_value)`. A very common pattern is filling with **`np.nan`** ("not a number") to mean *missing*. Then any value you never fill in stands out instead of silently pretending to be a real 0.

```python run
print(np.full((2, 3), 7.5))
print()

# Hourly sensor readings, none received yet
readings = np.full(6, np.nan)
readings[2] = 21.4
readings
```

`np.full` infers the dtype from the fill value: `7.5` gives floats, `True` gives booleans, and `np.nan` is a float, so it gives `float64`. As always, you can override it with `dtype=`.

```python exercise id=missing-day title="Mark a week of missing data"
# Build `week`: a 7 x 24 array (days x hours) of temperature readings
# where every entry starts as missing (NaN).
# Then record one real reading: day 0, hour 9 was 18.5 degrees.
week = ...
--- solution
week = np.full((7, 24), np.nan)
week[0, 9] = 18.5
--- test
assert week is not ..., "Replace the `...` with an array built by `np.full`."
assert isinstance(week, np.ndarray), f"`week` should be a NumPy array, not {type(week).__name__}."
assert week.shape == (7, 24), f"`week` should have shape (7, 24), days by hours, but it has shape {week.shape}."
assert np.issubdtype(week.dtype, np.floating), f"`week` needs a float dtype to hold NaN, but it has {week.dtype}."
assert week[0, 9] == 18.5, f"The reading at day 0, hour 9 should be 18.5, but it is {week[0, 9]}."
assert np.isnan(week).sum() == 7 * 24 - 1, f"Every other entry should still be NaN; found {np.isnan(week).sum()} NaNs instead of {7 * 24 - 1}."
--- hint
`np.full(shape, value)` fills an array with any value. NumPy''s missing-value marker is `np.nan`.
--- hint
After creating the array, assign to a single element with `week[day, hour] = value`.
```

## `empty`: fast, but full of garbage

`np.empty(shape)` allocates memory **without initializing it**. It''s marginally faster than `zeros` because it skips writing anything, but the array contains whatever bytes were lying around in memory:

```python run
junk = np.empty(5)
print("Whatever was in memory:", junk)

# Only safe when you overwrite every element before reading:
squares = np.empty(5)
for i in range(5):
    squares[i] = i ** 2
squares
```

The values in `junk` might look like zeros, tiny numbers like `6.9e-310`, or leftovers from a previous calculation, and they can change from run to run.

> **Pitfall:** Never use `np.empty` for accumulators (`total += ...`) or anything you might only partly fill. Bugs caused by garbage values are maddening because they appear and disappear at random. When in doubt, use `np.zeros`; the speed difference almost never matters.

## Identity and diagonal matrices

Linear algebra constantly needs the **identity matrix**, which has ones on the main diagonal and zeros elsewhere. Multiplying by it leaves a vector unchanged, the matrix equivalent of multiplying by 1.

```python run
print(np.eye(3))
print()
print(np.eye(4, k=1))   # shift the diagonal up by one
print()
print(np.eye(2, 3))     # eye also does rectangular matrices
```

`np.identity(n)` is the same as `np.eye(n)` but always square, with no `k` option. Then there''s `np.diag`, which works **in both directions**:

```python run
D = np.diag([2.0, 4.0, 6.0])     # 1-D in → 2-D diagonal matrix out
print(D)
print()

M = np.array([[1, 2, 3],
              [4, 5, 6],
              [7, 8, 9]])
print("Diagonal of M:", np.diag(M))   # 2-D in → 1-D diagonal out
```

> **In the wild:** `np.eye(num_classes)[labels]` is a classic one-liner for one-hot encoding class labels in machine learning. You''ll see why it works in the fancy-indexing lesson.

```python predict id=predict-eye-sum title="How many ones?"
a = np.eye(3, k=-1)
print(a.sum())
--- options
3.0
* 2.0
1.0
0.0
--- explain
`k=-1` moves the diagonal **one step below** the main diagonal. In a 3×3 matrix that diagonal only has two positions, `[1, 0]` and `[2, 1]`, so the array holds two ones. The sum is a float (`2.0`) because `eye` returns `float64`.
```

```python exercise id=build-matrices title="Build three special matrices"
# 1. `I`: the 3 x 3 identity matrix
# 2. `D`: a diagonal matrix with 2, 4, 6 on its diagonal
# 3. `S`: a 4 x 4 "shift" matrix with ones just ABOVE the main diagonal
I = ...
D = ...
S = ...
--- solution
I = np.eye(3)
D = np.diag([2, 4, 6])
S = np.eye(4, k=1)
--- test
for name, value in [("I", I), ("D", D), ("S", S)]:
    assert value is not ..., f"Replace the `...` after `{name} =` with your code."
    assert isinstance(value, np.ndarray), f"`{name}` should be a NumPy array, not {type(value).__name__}."
assert I.shape == (3, 3) and np.array_equal(I, np.identity(3)), "`I` should be the 3 x 3 identity: ones on the diagonal, zeros elsewhere."
assert D.shape == (3, 3), f"`D` should be 3 x 3 but has shape {D.shape}. Pass the diagonal values as a 1-D list."
assert np.array_equal(np.diag(D), [2, 4, 6]), f"`D` should have 2, 4, 6 on its diagonal, but it has {np.diag(D)}."
assert np.count_nonzero(D) == 3, "`D` should be zero everywhere off the diagonal."
assert S.shape == (4, 4), f"`S` should be 4 x 4 but has shape {S.shape}."
assert S.sum() == 3 and all(S[i, i + 1] == 1 for i in range(3)), "`S` needs ones on the diagonal just above the main one, at positions (0,1), (1,2), (2,3). Check the sign of `k`."
--- hint
All three can be built with `np.eye` and `np.diag`. Look back at the examples above.
--- hint
`np.diag` turns a list into a diagonal matrix. For `S`, `np.eye` takes a `k=` argument: positive `k` moves the diagonal up.
```

## `*_like`: match an existing array

Often you want a new array with **the same shape and dtype** as one you already have. Instead of writing `np.zeros(data.shape, dtype=data.dtype)`, use the `_like` family: `zeros_like`, `ones_like`, `full_like` and `empty_like`.

```python run
pixels = np.array([[12, 200, 37],
                   [90, 255, 0]], dtype=np.uint8)

mask = np.zeros_like(pixels)
print(mask.shape, mask.dtype)

halfway = np.full_like(pixels, 127)
print(halfway)
```

Copying the dtype is exactly what you want most of the time, and exactly what bites you the rest of the time. If the original array holds integers, the new one does too, and any fractions you store in it are **silently truncated**:

```python run
counts = np.array([3, 1, 4])
fractions = np.zeros_like(counts)
fractions[0] = 0.75          # stored into an integer array!
print(fractions)

print(np.zeros_like(counts, dtype=float))   # override the dtype when you need to
```

```python debug id=probabilities-zero title="All the probabilities are zero"
# Convert word counts into probabilities that sum to 1.
counts = np.array([30, 50, 20])

probs = np.zeros_like(counts)
for i in range(len(counts)):
    probs[i] = counts[i] / counts.sum()

print("probabilities:", probs)
print("sum:", probs.sum())
--- solution
counts = np.array([30, 50, 20])

probs = np.zeros_like(counts, dtype=float)
for i in range(len(counts)):
    probs[i] = counts[i] / counts.sum()

print("probabilities:", probs)
print("sum:", probs.sum())
--- test
assert isinstance(probs, np.ndarray), "`probs` should still be a NumPy array."
assert np.issubdtype(probs.dtype, np.floating), f"`probs` has dtype {probs.dtype}, so every fraction gets truncated to 0. It needs a floating-point dtype."
assert probs.shape == (3,), f"`probs` should have shape (3,) but has {probs.shape}."
assert np.allclose(probs, [0.3, 0.5, 0.2]), f"`probs` should be [0.3, 0.5, 0.2] but is {probs}."
assert np.isclose(probs.sum(), 1.0), "The probabilities should sum to 1."
--- hint
Run it and look at the output. Then ask: what dtype does `np.zeros_like(counts)` produce, given what `counts` contains?
--- hint
`zeros_like` copies the dtype of its input. Each `0.3` stored into an integer array becomes `0`. Override the dtype with `dtype=float`.
```

> **Under the hood:** this loop is deliberately slow and un-NumPy-like. The vectorized version is simply `probs = counts / counts.sum()`. Division of integer arrays always produces floats, so the bug can''t even happen. You''ll learn to write code like that in the vectorization section.

## Cheat sheet

| You want… | Use |
|---|---|
| All zeros / ones | `np.zeros(shape)`, `np.ones(shape)` |
| Any constant (often `np.nan`) | `np.full(shape, value)` |
| Uninitialized memory you will fully overwrite | `np.empty(shape)` |
| Identity / shifted diagonal | `np.eye(n, k=...)`, `np.identity(n)` |
| Diagonal matrix ↔ diagonal vector | `np.diag(v)`, `np.diag(M)` |
| Same shape & dtype as `x` | `np.zeros_like(x)`, `np.full_like(x, v)`, … |

## Recap

- Shapes are passed as **one argument**: an int, or a tuple like `(3, 4)`. `np.zeros(3, 4)` is an error.
- Factories default to `float64`; use `dtype=` to choose integers, booleans or anything else.
- `np.full(shape, np.nan)` is the idiomatic way to start with "missing" values.
- `np.empty` is uninitialized garbage. Only use it when you overwrite every element.
- `np.eye` and `np.diag` build identity and diagonal matrices; `np.diag` also extracts diagonals.
- `*_like` functions copy shape **and dtype**, so watch out for integer truncation.

**Up next:** sequences and grids with `arange`, `linspace` and `meshgrid`, plus why `arange` with float steps can surprise you.
', 0, '[]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_2_2', 'sec_numpy_2', 'crs_numpy_mastery', 'Ranges and grids: arange, linspace, meshgrid', 'interactive', 1, 960, NULL, NULL, 'Plotting a function, sampling a signal, sweeping a learning rate, evaluating a loss surface: they all start with a **sequence of evenly spaced numbers**. NumPy gives you two tools for this, and choosing the right one is the difference between code that works and code that''s subtly off by one point.

In this lesson you''ll learn when to reach for `arange` versus `linspace`, how to space values logarithmically, and how `meshgrid` turns two 1-D ranges into a 2-D grid so you can evaluate functions of two variables in a single expression.

## `arange`: like `range`, but an array

`np.arange(start, stop, step)` works exactly like Python''s built-in `range`, but returns an array and also accepts floats.

```python run
import numpy as np

print(np.arange(5))           # 0 .. 4
print(np.arange(2, 10))       # 2 .. 9
print(np.arange(2, 10, 3))    # 2, 5, 8
print(np.arange(10, 0, -2))   # counting down
```

The interval is **half-open**: `start` is included and `stop` is **not**. `np.arange(2, 10)` stops at 9. That''s the same convention as `range` and slicing, so `len(np.arange(n)) == n` always holds.

```python predict id=predict-arange-len title="How many elements?"
a = np.arange(0, 10, 3)
print(len(a))
--- options
3
* 4
10
9
--- explain
The values are `0, 3, 6, 9`. `9` is still below the stop value `10`, so it is included, giving **4** elements. The next step, `12`, would pass the stop.
```

```python exercise id=evens-and-countdown title="Two sequences with arange"
# 1. `evens`: every even number from 0 up to AND INCLUDING 20
# 2. `countdown`: 10, 9, 8, ... down to 1
evens = ...
countdown = ...
--- solution
evens = np.arange(0, 21, 2)
countdown = np.arange(10, 0, -1)
--- test
assert evens is not ..., "Replace the `...` after `evens =` with your code."
assert countdown is not ..., "Replace the `...` after `countdown =` with your code."
assert isinstance(evens, np.ndarray) and isinstance(countdown, np.ndarray), "Both results should be NumPy arrays. Use `np.arange`."
assert evens.tolist() == list(range(0, 21, 2)), f"`evens` should be 0, 2, ..., 20 (11 values) but is {evens.tolist()}. Is 20 included?" if len(evens) != 10 else "`evens` is missing 20: `stop` is exclusive, so it must be larger than 20."
assert countdown.tolist() == list(range(10, 0, -1)), f"`countdown` should be 10, 9, ..., 1 but is {countdown.tolist()}."
--- hint
`stop` is exclusive. To include 20, the stop value has to be a bit larger than 20.
--- hint
To count down, use a negative step: `np.arange(start, stop, -1)`. Again, `stop` itself is not included.
```

### The float-step trap

`arange` with a **float** step looks innocent, but the number of elements is computed as `ceil((stop - start) / step)`, and floating-point arithmetic is never exact:

```python run
print(np.arange(1, 1.3, 0.1))   # 1.3 sneaks in!
print(np.arange(1, 1.4, 0.1))
print((1.3 - 1) / 0.1)          # slightly more than 3
```

`(1.3 - 1) / 0.1` is `3.0000000000000004`, so `ceil` gives **4** elements, and `1.3` appears even though `stop` is supposedly excluded. Whether the endpoint shows up depends on tiny rounding errors.

> **Rule of thumb:** use `arange` for **integers**. For floats, use `linspace` and specify *how many* points you want instead of the step size.

## `linspace`: say how many points you want

`np.linspace(start, stop, num)` returns exactly `num` evenly spaced values, and by default **includes both endpoints**.

```python run
print(np.linspace(0, 1, 5))
print(np.linspace(0, 1, 5, endpoint=False))   # like arange: stop excluded

values, step = np.linspace(0, 10, 4, retstep=True)
print(values, "step =", step)
```

The `retstep=True` option also returns the spacing NumPy chose, which is handy when you need it for numerical integration or plotting.

```python predict id=predict-linspace title="What does this print?"
print(np.linspace(0, 1, 5))
--- options
[0.  0.2 0.4 0.6 0.8]
* [0.   0.25 0.5  0.75 1.  ]
[0.   0.25 0.5  0.75]
[0 1 2 3 4]
--- explain
Five points from 0 to 1 **inclusive** means four equal gaps of `0.25`. NumPy pads the printed numbers so the columns line up, which is why you see `0.` followed by spaces.
```

Here''s `linspace` doing what it''s best at: sampling a smooth curve. Plotting libraries draw a curve by connecting sampled points, so a couple of hundred `linspace` points give a smooth line. Try changing `200` to `8` and watch the curve turn into a jagged polygon.

```python run
import matplotlib.pyplot as plt

x = np.linspace(0, 2 * np.pi, 200)
plt.plot(x, np.sin(x), label="sin(x)")
plt.plot(x, np.cos(x), label="cos(x)", linestyle="--")
plt.axhline(0, color="gray", linewidth=0.6)
plt.legend()
plt.title("200 points from linspace")
plt.show()
```

```python exercise id=sample-wave title="Sample one full sine wave"
# Create `t`: exactly 50 evenly spaced time points from 0 to 2π, INCLUDING 2π.
# Then compute `wave`: the sine of every time point.
t = ...
wave = ...
--- solution
t = np.linspace(0, 2 * np.pi, 50)
wave = np.sin(t)
--- test
assert t is not ..., "Replace the `...` after `t =` with your code."
assert wave is not ..., "Replace the `...` after `wave =` with your code."
assert isinstance(t, np.ndarray), f"`t` should be a NumPy array, not {type(t).__name__}."
assert t.shape == (50,), f"`t` should contain exactly 50 points but has shape {t.shape}."
assert np.isclose(t[0], 0), f"`t` should start at 0, not {t[0]}."
assert np.isclose(t[-1], 2 * np.pi), f"`t` should end exactly at 2π ({2 * np.pi:.5f}) but ends at {t[-1]:.5f}. Is the endpoint included?"
assert np.allclose(np.diff(t), np.diff(t)[0]), "The points in `t` should be evenly spaced."
assert isinstance(wave, np.ndarray) and wave.shape == (50,), "`wave` should be an array with one value per time point."
assert np.allclose(wave, np.sin(t)), "`wave` should be the sine of each value in `t`. Use `np.sin`."
--- hint
When you know *how many* points you need and want both ends included, `linspace` is the right tool.
--- hint
`np.pi` is π. NumPy''s `np.sin` works on a whole array at once.
```

## Logarithmic spacing: `logspace` and `geomspace`

Some quantities span many orders of magnitude: learning rates, frequencies, regularization strengths. Spacing them evenly on a linear scale wastes almost every point on the high end. Use **logarithmic** spacing instead, where each value is a constant *multiple* of the previous one.

```python run
print(np.logspace(0, 3, 4))          # 10**0 .. 10**3
print(np.geomspace(1, 1000, 4))      # same, but give the endpoints directly
print(np.geomspace(1e-4, 1e-1, 4))   # a learning-rate sweep
```

`np.logspace(a, b, n)` takes **exponents** (base 10 by default), while `np.geomspace(start, stop, n)` takes the actual endpoint values. Most people find `geomspace` easier to read.

> **In the wild:** hyperparameter searches in scikit-learn often use `np.logspace(-4, 4, 20)` to try regularization strengths `C` from 0.0001 to 10,000.

```python exercise id=frequency-ladder title="Build a log-spaced frequency ladder"
# An audio test needs 5 frequencies from 10 Hz to 100,000 Hz,
# each 10 times the previous one: 10, 100, 1000, 10000, 100000.
# Build `freqs` WITHOUT typing the values out by hand.
freqs = ...
--- solution
freqs = np.geomspace(10, 100_000, 5)
--- test
assert freqs is not ..., "Replace the `...` with a call to `np.geomspace` or `np.logspace`."
assert isinstance(freqs, np.ndarray), f"`freqs` should be a NumPy array, not {type(freqs).__name__}."
assert freqs.shape == (5,), f"`freqs` should have 5 values but has shape {freqs.shape}."
assert np.allclose(freqs, [10, 100, 1_000, 10_000, 100_000]), f"`freqs` should be 10, 100, ..., 100000 but is {freqs}. If you used logspace, remember it takes exponents."
--- hint
You want each value to be a constant multiple of the previous one: geometric spacing.
--- hint
`np.geomspace(start, stop, num)` takes the real endpoints. `np.logspace(1, 5, 5)` takes the exponents of 10.
```

## `meshgrid`: from two axes to a full grid

To evaluate a function of **two** variables, like $z = x^2 + y^2$, you need every combination of `x` and `y`. `np.meshgrid` takes two 1-D arrays and returns two 2-D arrays, one holding the x-coordinate of every grid point and one holding the y-coordinate.

```python run
x = np.array([0, 1, 2])
y = np.array([10, 20])

X, Y = np.meshgrid(x, y)
print("X =\n", X)
print("Y =\n", Y)
print("shapes:", X.shape, Y.shape)
```

Read it point by point: the grid point in row `i`, column `j` has coordinates `(X[i, j], Y[i, j])`. With the default `indexing="xy"`, **rows follow `y` and columns follow `x`**, so the shape is `(len(y), len(x))`. That''s the convention plotting libraries expect, like an image where x runs left to right.

Once you have `X` and `Y`, any formula becomes a single vectorized expression. Here is the "bowl" $z = x^2 + y^2$ evaluated on a 5 × 5 grid, with no loops:

```python run
x = np.linspace(-2, 2, 5)
y = np.linspace(-2, 2, 5)
X, Y = np.meshgrid(x, y)

Z = X ** 2 + Y ** 2
print(Z)
```

The center of the grid is 0 and the corners are 8: the bowl''s shape, written out as numbers. With a finer grid and a more interesting function, you can hand the same `X`, `Y` and `Z` to matplotlib and see the surface as a contour map. Every 2-D heatmap and loss-landscape plot you''ve seen is built exactly this way:

```python run
import matplotlib.pyplot as plt

x = np.linspace(-2, 2, 120)
y = np.linspace(-2, 2, 120)
X, Y = np.meshgrid(x, y)
Z = np.sin(X ** 2 + Y ** 2) * np.exp(-(X ** 2 + Y ** 2) / 3)

plt.contourf(X, Y, Z, levels=20, cmap="viridis")
plt.colorbar(label="z")
plt.gca().set_aspect("equal")
plt.title("z = sin(x² + y²) · exp(−(x² + y²) / 3)")
plt.show()
```

### `xy` versus `ij` indexing

Matrix-style code often wants the *first* index to follow the *first* input instead. Pass `indexing="ij"` and the shape flips to `(len(x), len(y))`:

```python run
x = np.array([0, 1, 2])
y = np.array([10, 20])

Xi, Yi = np.meshgrid(x, y, indexing="ij")
print("xy shape:", np.meshgrid(x, y)[0].shape)
print("ij shape:", Xi.shape)
print(Xi)
```

> **Pitfall:** mixing up `xy` and `ij` doesn''t raise an error when `x` and `y` have the same length. You silently get a **transposed** result. Use different lengths while developing so a shape mismatch exposes the mistake.

```python exercise id=multiplication-table title="Evaluate a function on a grid"
x = np.linspace(0, 1, 3)    # 3 x-values
y = np.linspace(0, 2, 5)    # 5 y-values

# Use np.meshgrid (default "xy" indexing) to compute `Z`, where
# Z[i, j] = x[j] * y[i]  for every combination, without any loops.
Z = ...
--- solution
x = np.linspace(0, 1, 3)
y = np.linspace(0, 2, 5)

X, Y = np.meshgrid(x, y)
Z = X * Y
--- test
assert Z is not ..., "Replace the `...` with an expression built from `np.meshgrid`."
assert isinstance(Z, np.ndarray), f"`Z` should be a NumPy array, not {type(Z).__name__}."
assert Z.shape == (5, 3), f"`Z` should have shape (5, 3), rows following y and columns following x, but it has {Z.shape}." + (" That''s the transpose; did you use indexing=''ij'' or swap x and y?" if Z.shape == (3, 5) else "")
assert np.allclose(Z, np.outer(y, x)), "`Z[i, j]` should equal `x[j] * y[i]`. Build X and Y with meshgrid, then multiply them."
--- hint
`X, Y = np.meshgrid(x, y)` gives you two arrays with the same shape as the grid.
--- hint
Once you have `X` and `Y`, the whole function is just `X * Y`.
```

```python debug id=histogram-edges title="The last bin is missing"
# We want 10 equal-width histogram bins covering [0, 1].
# 10 bins need 11 edges: 0.0, 0.1, ..., 1.0
edges = np.arange(0, 1.0, 0.1)

print("number of edges:", len(edges))
print("last edge:", edges[-1])
--- solution
# We want 10 equal-width histogram bins covering [0, 1].
# 10 bins need 11 edges: 0.0, 0.1, ..., 1.0
edges = np.linspace(0, 1, 11)

print("number of edges:", len(edges))
print("last edge:", edges[-1])
--- test
assert isinstance(edges, np.ndarray), "`edges` should be a NumPy array."
assert len(edges) == 11, f"10 bins need 11 edges, but `edges` has {len(edges)}."
assert edges[0] == 0 and edges[-1] == 1.0, f"The edges should run from exactly 0.0 to exactly 1.0, but the last one is {edges[-1]!r}."
assert np.allclose(edges, np.arange(11) / 10), "The edges should be evenly spaced: 0.0, 0.1, ..., 1.0."
--- hint
Run it. How many edges came out, and what is the last one? Remember what `arange` does with `stop`.
--- hint
Patching the stop to something like `1.05` happens to work, but it''s fragile. What you know is *how many* edges you need, and that both ends must be included. Which function takes exactly that?
```

## Choosing the right tool

| Situation | Use |
|---|---|
| Integer sequence, indices, counters | `np.arange(start, stop, step)` |
| *N* float points between two values, endpoints included | `np.linspace(start, stop, N)` |
| Values spanning orders of magnitude | `np.geomspace(start, stop, N)` or `np.logspace(a, b, N)` |
| Every (x, y) combination for a 2-D function | `X, Y = np.meshgrid(x, y)` |

## Recap

- `arange` is half-open, like `range`: `stop` is excluded. It''s ideal for integers.
- With float steps, `arange`''s length depends on rounding error, so prefer `linspace`.
- `linspace(a, b, n)` gives exactly `n` points with both ends included; `endpoint=False` and `retstep=True` tweak it.
- `geomspace` and `logspace` space values multiplicatively, which is perfect for hyperparameter sweeps.
- `meshgrid(x, y)` returns coordinate grids of shape `(len(y), len(x))`; `indexing="ij"` flips that.
- Once you have `X` and `Y`, any formula `f(X, Y)` is evaluated over the whole grid at once.

**Up next:** random numbers done right with `np.random.default_rng`, seeding, sampling and simulation.
', 0, '[]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_2_3', 'sec_numpy_2', 'crs_numpy_mastery', 'Random numbers the modern way', 'interactive', 2, 960, NULL, NULL, 'Randomness is everywhere in data work. You shuffle a dataset before splitting it, initialize neural-network weights, bootstrap a confidence interval, simulate a million customers, or add noise to test a model''s robustness. All of it needs random numbers that are **fast**, **statistically sound** and, crucially, **reproducible**. If you can''t rerun an experiment and get the same result, you can''t debug it.

NumPy''s modern random API, built around `np.random.default_rng`, gives you all three. In this lesson you''ll learn how to create and seed a generator, draw numbers from common distributions in any shape, sample and shuffle, run your first simulation, and avoid the seeding mistakes that make experiments silently non-reproducible.

## Meet the Generator

Everything starts with one line:

```python run
import numpy as np

rng = np.random.default_rng(42)   # 42 is the seed

print(rng.random(3))              # floats in [0, 1)
print(rng.integers(1, 7, size=10))  # dice rolls: 1..6
```

`rng` is a **`Generator`** object. You call methods on it to draw random numbers, and it keeps track of its own internal state. The **seed** (`42` here) fixes the starting state, so the sequence of numbers is completely determined by it.

> **Pitfall:** `rng.integers(low, high)` follows the same half-open convention as `range` and `arange`: `high` is **excluded**. A six-sided die is `rng.integers(1, 7)`, not `rng.integers(1, 6)`, which would never roll a 6.

### Same seed, same numbers

Reproducibility is the whole point of seeding. Two generators created with the same seed produce the identical sequence:

```python run
a = np.random.default_rng(2024)
b = np.random.default_rng(2024)

print(a.normal(size=4))
print(b.normal(size=4))

c = np.random.default_rng()       # no seed: fresh entropy from the OS
print(c.normal(size=4))           # different every time you run this cell
```

Without a seed, `default_rng()` pulls entropy from your operating system and you get different numbers each run. That''s fine for a game, but for experiments you want to reproduce, **always seed**.

```python predict id=predict-same-seed title="Are these equal?"
x = np.random.default_rng(5).random()
y = np.random.default_rng(5).random()
print(x == y)
--- options
* True
False
It depends on the time of day
It raises an error
--- explain
Both generators start from the **same seed**, so they are in the same state and produce the same first number. This is exactly what makes seeded experiments reproducible.
```

### Why not `np.random.seed`?

You''ll see a lot of older code like `np.random.seed(0)` followed by `np.random.rand(3)`. That **legacy API** uses one hidden, global generator shared by your whole program and every library you import.

| | Legacy `np.random.rand(...)` | Modern `rng = np.random.default_rng(seed)` |
|---|---|---|
| State | One hidden global | Explicit object you pass around |
| Isolation | Any library call can change your sequence | Each generator is independent |
| Algorithm | Mersenne Twister | PCG64: faster, better statistical properties |
| Recommended | Only for old code | **Yes**, NumPy''s official recommendation |

With the legacy API, if a library you call happens to draw one random number, every number *you* draw afterwards changes. With an explicit `Generator`, that can''t happen.

## Distributions and shapes

Every `Generator` method accepts a `size=` argument, which is a **shape**, exactly like `np.zeros`. Pass an int for 1-D or a tuple for more dimensions:

```python run
rng = np.random.default_rng(0)

print("uniform:", rng.uniform(-1, 1, size=3))
print("normal:\n", rng.normal(loc=170, scale=8, size=(2, 3)))   # heights in cm
print("integers:\n", rng.integers(0, 10, size=(2, 5)))
```

The methods you''ll use most often:

| Method | Draws |
|---|---|
| `rng.random(size)` | Floats uniformly in $[0, 1)$ |
| `rng.uniform(low, high, size)` | Floats uniformly in $[\text{low}, \text{high})$ |
| `rng.integers(low, high, size)` | Integers in $[\text{low}, \text{high})$ |
| `rng.normal(loc, scale, size)` | Gaussian with mean `loc` and standard deviation `scale` |
| `rng.choice(a, size, replace, p)` | Samples from an array, optionally weighted |
| `rng.permutation(a)` / `rng.shuffle(a)` | Random reordering |

```python predict id=predict-size-shape title="What shape comes out?"
rng = np.random.default_rng(0)
rolls = rng.integers(1, 7, size=(3, 2))
print(rolls.shape)
--- options
(6,)
* (3, 2)
(2, 3)
(3,)
--- explain
`size=` is a **shape**, just like the argument to `np.zeros`. `size=(3, 2)` gives 3 rows and 2 columns of dice rolls.
```

```python exercise id=roll-dice title="Roll a thousand dice"
rng = np.random.default_rng(7)

# Use `rng` to simulate 1000 rolls of a fair six-sided die.
# `rolls` should be a 1-D integer array with values from 1 to 6.
rolls = ...
--- solution
rng = np.random.default_rng(7)

rolls = rng.integers(1, 7, size=1000)
--- test
assert rolls is not ..., "Replace the `...` with a call on `rng`."
assert isinstance(rolls, np.ndarray), f"`rolls` should be a NumPy array, not {type(rolls).__name__}."
assert rolls.shape == (1000,), f"`rolls` should hold 1000 rolls in a 1-D array, but has shape {rolls.shape}."
assert np.issubdtype(rolls.dtype, np.integer), f"Dice rolls are whole numbers, but `rolls` has dtype {rolls.dtype}."
assert rolls.min() >= 1, f"A die can''t roll {rolls.min()}. The lowest face is 1."
assert rolls.max() <= 6, f"A die can''t roll {rolls.max()}. The highest face is 6."
assert 6 in rolls, "In 1000 rolls, a 6 never appeared. Remember `high` is exclusive in `rng.integers(low, high)`."
assert len(np.unique(rolls)) == 6, "Every face from 1 to 6 should appear at least once in 1000 rolls."
--- hint
`rng.integers(low, high, size=...)` draws integers. Which values of `low` and `high` give the faces 1 through 6?
--- hint
`high` is excluded, so it needs to be one more than the largest face.
```

## Sampling and shuffling

`rng.choice` picks elements from an array. By default it samples **with replacement**, so the same element can be picked more than once. Pass `replace=False` for distinct picks, and `p=` to weight the options:

```python run
rng = np.random.default_rng(1)
colors = np.array(["red", "green", "blue", "gold"])

print("with replacement:   ", rng.choice(colors, size=6))
print("without replacement:", rng.choice(colors, size=3, replace=False))
print("weighted:           ", rng.choice(colors, size=8, p=[0.7, 0.1, 0.1, 0.1]))
```

To reorder data there are two methods, and the difference matters:

```python run
rng = np.random.default_rng(3)
deck = np.arange(10)

shuffled = rng.permutation(deck)   # returns a NEW shuffled copy
print("permutation:", shuffled, "| original:", deck)

rng.shuffle(deck)                  # shuffles IN PLACE, returns None
print("after shuffle:", deck)
```

> **Pitfall:** `deck = rng.shuffle(deck)` is a classic bug. `shuffle` works in place and returns `None`, so you just replaced your data with `None`. Use `permutation` when you want the result as a new array.

```python exercise id=train-test-split title="Split a dataset randomly"
rng = np.random.default_rng(0)
samples = np.arange(100)   # stand-ins for 100 data points

# Randomly split `samples` into:
#   `train`: 80 samples
#   `test`:  the other 20
# Every sample must land in exactly one of the two sets,
# and the split must be random (not simply the first 80).
train = ...
test = ...
--- solution
rng = np.random.default_rng(0)
samples = np.arange(100)

shuffled = rng.permutation(samples)
train = shuffled[:80]
test = shuffled[80:]
--- test
assert train is not ... and test is not ..., "Replace both `...` placeholders with your code."
assert isinstance(train, np.ndarray) and isinstance(test, np.ndarray), "`train` and `test` should both be NumPy arrays."
assert len(train) == 80, f"`train` should hold 80 samples, but it has {len(train)}."
assert len(test) == 20, f"`test` should hold 20 samples, but it has {len(test)}."
assert len(np.intersect1d(train, test)) == 0, "Some samples appear in both `train` and `test`. The sets must not overlap."
assert np.array_equal(np.sort(np.concatenate([train, test])), np.arange(100)), "Together, `train` and `test` should contain every sample exactly once."
assert not np.array_equal(np.sort(train), np.arange(80)), "`train` is just the first 80 samples. The split needs to be random. Shuffle first."
--- hint
Shuffle a copy of `samples` first, then cut it into two pieces.
--- hint
`shuffled = rng.permutation(samples)`, then slice: `shuffled[:80]` takes the first 80 elements and `shuffled[80:]` takes the rest.
```

## Your first simulation: two dice

What''s the probability that two dice add up to 7? You could work it out by hand ($6/36 \approx 0.167$), or you can **simulate** it: roll a million pairs and count. This is the *Monte Carlo method*, and with NumPy it''s three lines:

```python run
import matplotlib.pyplot as plt

rng = np.random.default_rng(0)
n = 100_000
totals = rng.integers(1, 7, size=n) + rng.integers(1, 7, size=n)

print("P(total == 7) ≈", (totals == 7).mean())

values, counts = np.unique(totals, return_counts=True)
plt.bar(values, counts / n, color="#4C6EF5")
plt.xticks(values)
plt.xlabel("sum of two dice")
plt.ylabel("probability")
plt.show()
```

`np.unique(..., return_counts=True)` returns each distinct total with how often it occurred, and the bars reveal the famous triangle: 7 is the most likely sum. `totals == 7` compares every element and gives an array of `True`/`False`. The mean of a boolean array is the **fraction** of `True`s, because `True` counts as 1 and `False` as 0. You''ll use this trick constantly; boolean arrays get a full lesson later.

## Independent streams with `spawn`

Sometimes you need several random streams that don''t interfere: one per worker process, per experiment arm, or per simulated agent. Don''t create them with seeds `0, 1, 2…` by hand. Ask a generator to **spawn** statistically independent children:

```python run
parent = np.random.default_rng(42)
workers = parent.spawn(3)

for i, w in enumerate(workers):
    print(f"worker {i}:", w.integers(0, 100, size=5))
```

The whole family is still reproducible from the single seed `42`, but each child produces its own independent sequence.

```python debug id=identical-trials title="Every trial gives the same result"
# Simulate 5 trials. In each, roll 3 dice and record the total.
results = []
for trial in range(5):
    rng = np.random.default_rng(0)
    results.append(rng.integers(1, 7, size=3).sum())

results = np.array(results)
print("totals per trial:", results)
--- solution
# Simulate 5 trials. In each, roll 3 dice and record the total.
rng = np.random.default_rng(0)
results = []
for trial in range(5):
    results.append(rng.integers(1, 7, size=3).sum())

results = np.array(results)
print("totals per trial:", results)
--- test
assert isinstance(results, np.ndarray), "`results` should be a NumPy array of totals."
assert results.shape == (5,), f"There should be one total per trial (5), but `results` has shape {results.shape}."
assert ((results >= 3) & (results <= 18)).all(), "Each total of three dice must be between 3 and 18."
assert len(set(results.tolist())) > 1, "All five trials still produce the same total. Each trial is starting from the same random state."
--- hint
Use **Debug** and watch `rng` being created. How many times does it happen, and with which seed?
--- hint
Re-seeding inside the loop resets the generator to the same state every time, so every trial draws the same numbers. Create the generator **once**, before the loop.
```

```python debug id=duplicate-winners title="Someone won twice"
rng = np.random.default_rng(2)
entrants = np.array(["Ana", "Ben", "Chen", "Dev", "Eli",
                     "Fay", "Gus", "Hana", "Ivo", "Jia"])

# Pick 8 DIFFERENT people for a focus group.
chosen = rng.choice(entrants, size=8)
print(chosen)
--- solution
rng = np.random.default_rng(2)
entrants = np.array(["Ana", "Ben", "Chen", "Dev", "Eli",
                     "Fay", "Gus", "Hana", "Ivo", "Jia"])

# Pick 8 DIFFERENT people for a focus group.
chosen = rng.choice(entrants, size=8, replace=False)
print(chosen)
--- test
assert isinstance(chosen, np.ndarray), "`chosen` should be a NumPy array."
assert len(chosen) == 8, f"The focus group needs 8 people, but `chosen` has {len(chosen)}."
assert set(chosen.tolist()) <= set(entrants.tolist()), "Everyone in `chosen` must come from `entrants`."
assert len(set(chosen.tolist())) == 8, f"Only {len(set(chosen.tolist()))} distinct people were chosen; some were picked more than once."
--- hint
Run it and read the names carefully. Does anyone appear twice?
--- hint
`rng.choice` samples **with replacement** by default. There''s a keyword argument to turn that off.
```

## Recap

- Create one generator per experiment with `rng = np.random.default_rng(seed)` and draw everything from it.
- The same seed always reproduces the same sequence; no seed means fresh randomness every run.
- `size=` is a shape, exactly like `np.zeros`. `integers(low, high)` excludes `high`.
- `choice` samples with replacement unless you pass `replace=False`; `p=` adds weights.
- `permutation` returns a shuffled copy; `shuffle` works in place and returns `None`.
- Seed **once**, outside your loops, and use `rng.spawn(n)` for independent streams.

**Up next:** dtypes in depth. Why `uint8` pixels wrap around, why `0.1 + 0.2 != 0.3`, and how to choose the right precision.
', 0, '[]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_numpy_2_4', 'sec_numpy_2', 'crs_numpy_mastery', 'dtypes in depth: precision, casting and overflow', 'interactive', 3, 1080, NULL, NULL, 'Every NumPy array stores **one type of number**, packed tightly in memory. That single choice, the array''s **dtype**, decides how much memory it uses, how precise its arithmetic is, which values it can hold, and what happens when a result doesn''t fit. Most of the time NumPy picks sensible defaults, but the bugs dtypes cause are among the nastiest you''ll meet: pixel values that wrap from 255 back to 4, file sizes that turn negative, fractions that silently become zero.

This lesson gives you a working mental model of dtypes: the main families, how to convert between them safely, NumPy''s promotion rules for mixed arithmetic, and the overflow and precision traps that catch professionals.

## The dtype families

```python run
import numpy as np

for dt in [np.bool_, np.int8, np.int16, np.int32, np.int64, np.uint8,
           np.float16, np.float32, np.float64, np.complex128]:
    d = np.dtype(dt)
    print(f"{d.name:>10}  {d.itemsize:>2} bytes   kind={d.kind}")
```

| Kind | dtypes | Holds |
|---|---|---|
| `b` boolean | `bool` | `True` / `False` (1 byte each) |
| `i` signed integer | `int8`, `int16`, `int32`, `int64` | Whole numbers, negative or positive |
| `u` unsigned integer | `uint8` … `uint64` | Whole numbers ≥ 0; `uint8` is the classic pixel type |
| `f` floating point | `float16`, `float32`, `float64` | Real numbers with limited precision |
| `c` complex | `complex64`, `complex128` | Numbers with a real and an imaginary part |

The number in the name is the size in **bits**. `int8` uses 8 bits, so it can only represent $2^8 = 256$ different values.

```python run
print(np.iinfo(np.int8))
print(np.iinfo(np.uint8))
print("int32 range:", np.iinfo(np.int32).min, "to", np.iinfo(np.int32).max)
print("int64 max:  ", np.iinfo(np.int64).max)
```

`np.iinfo` reports the limits of integer types, and `np.finfo` does the same for floats.

## The default integer depends on your platform

When you write `np.array([1, 2, 3])` without a dtype, NumPy uses the platform''s **default integer**. Run this:

```python run
a = np.array([1, 2, 3])
print("default int here:", a.dtype)
print("np.intp (the index type):", np.dtype(np.intp))
print("bytes per element:", a.itemsize)
```

In this browser the answer is **`int32`**. Python here runs on WebAssembly, a 32-bit platform. On a typical 64-bit Linux or macOS desktop, the same code prints `int64`. Windows used `int32` before NumPy 2.0 and `int64` since.

This isn''t a curiosity; it changes results. With 32-bit integers, values above about 2.1 billion **wrap around**:

```python run
big = np.arange(100_000)
print("dtype:", big.dtype)
print("sum:", big.sum())
print("correct sum:", sum(range(100_000)))
```

In this browser the sum is wrong: it overflowed `int32` and wrapped around to `704982704`. On a 64-bit desktop it would happen to be right, which is exactly why this kind of bug survives testing on your laptop and then fails on another machine.

> **Rule:** when the size of an integer matters, **say it explicitly**: `np.arange(100_000, dtype=np.int64)`, or `big.sum(dtype=np.int64)`. Never assume the default is 64 bits.

## Choosing a dtype saves memory

The same million numbers take very different amounts of memory:

```python run
n = 1_000_000
for dt in [np.float64, np.float32, np.float16, np.uint8]:
    arr = np.zeros(n, dtype=dt)
    print(f"{np.dtype(dt).name:>8}: {arr.nbytes / 1e6:5.1f} MB")
```

Deep-learning frameworks train in `float32` (or even 16-bit types) for exactly this reason: half the memory and twice the throughput, at a precision cost that neural networks tolerate well. Images are stored as `uint8` because a pixel channel only needs 0 to 255.

```python exercise id=shrink-memory title="Halve the memory of a dataset"
rng = np.random.default_rng(0)
measurements = rng.normal(size=100_000)   # float64 by default

# 1. Create `compact`: the same values stored as 32-bit floats.
# 2. Compute `saved_bytes`: how many bytes the conversion saves.
compact = ...
saved_bytes = ...
--- solution
rng = np.random.default_rng(0)
measurements = rng.normal(size=100_000)

compact = measurements.astype(np.float32)
saved_bytes = measurements.nbytes - compact.nbytes
--- test
assert compact is not ..., "Replace the `...` after `compact =` with your code."
assert saved_bytes is not ..., "Replace the `...` after `saved_bytes =` with your code."
assert isinstance(compact, np.ndarray), f"`compact` should be a NumPy array, not {type(compact).__name__}."
assert compact.dtype == np.float32, f"`compact` should have dtype float32, but it has {compact.dtype}."
assert compact.shape == measurements.shape, f"`compact` should keep all {measurements.size} values, but it has shape {compact.shape}."
assert np.allclose(compact, measurements, rtol=1e-6, atol=1e-6), "`compact` should hold the same values as `measurements`, just at lower precision."
assert saved_bytes == 400_000, f"Converting 100,000 values from 8-byte to 4-byte floats saves 400,000 bytes, but `saved_bytes` is {saved_bytes}. Try the `.nbytes` attribute."
--- hint
Arrays have an `.astype(dtype)` method that returns a converted copy.
--- hint
Every array has `.nbytes`, its total size in bytes. Subtract the new size from the old one.
```

## Converting with `astype`

`arr.astype(new_dtype)` returns a **new** array converted to another dtype. Converting floats to integers **truncates toward zero**; it does not round:

```python run
values = np.array([2.9, -2.9, 0.5, 7.5])

print("astype(int32):  ", values.astype(np.int32))
print("round, then int:", np.round(values).astype(np.int32))
```

Notice that `np.round(0.5)` is `0` and `np.round(7.5)` is `8`. NumPy uses **round half to even** ("banker''s rounding"), which avoids a systematic upward bias when you round lots of halves.

```python predict id=predict-astype title="What does this print?"
a = np.array([1.9, -1.9])
print(a.astype(np.int32))
--- options
[ 2 -2]
* [ 1 -1]
[ 1 -2]
[ 2 -1]
--- explain
`astype` to an integer type **truncates toward zero**: it chops off the fractional part. `1.9 → 1` and `-1.9 → -1`. To round instead, call `np.round` first.
```

```python exercise id=round-prices title="Round prices to whole dollars"
prices = np.array([1.99, 2.5, 3.49, -0.6, 7.5, 12.01])

# Create `dollars`: each price rounded to the NEAREST whole number,
# stored with an integer dtype.
dollars = ...
--- solution
prices = np.array([1.99, 2.5, 3.49, -0.6, 7.5, 12.01])

dollars = np.round(prices).astype(np.int64)
--- test
assert dollars is not ..., "Replace the `...` with your code."
assert isinstance(dollars, np.ndarray), f"`dollars` should be a NumPy array, not {type(dollars).__name__}."
assert np.issubdtype(dollars.dtype, np.integer), f"`dollars` should have an integer dtype, but it has {dollars.dtype}. Convert with `.astype(...)`."
assert dollars.shape == prices.shape, f"`dollars` should have one entry per price, shape {prices.shape}, but has {dollars.shape}."
truncated = prices.astype(np.int64)
assert not (np.array_equal(dollars, truncated)), "These values were truncated, not rounded: 1.99 became 1. `astype` chops toward zero, so round first."
assert np.array_equal(dollars, np.round(prices)), f"`dollars` should be the prices rounded to the nearest integer, {np.round(prices).astype(int).tolist()}, but it is {dollars.tolist()}."
--- hint
`astype(int)` on its own truncates (1.99 → 1). You need to round *before* converting.
--- hint
`np.round(prices)` rounds but keeps the float dtype. Chain `.astype(...)` onto the result.
```

## Integer overflow: when numbers wrap around

Integers have a fixed number of bits. When a result is too large, NumPy array arithmetic doesn''t raise an error. It **wraps around**, like a car odometer rolling over:

```python run
pixels = np.array([250, 251, 252], dtype=np.uint8)
print("uint8 250..252 + 10:", pixels + 10)     # 260 wraps to 4

small = np.array([127], dtype=np.int8)
print("int8 127 + 1:", small + 1)              # wraps to -128
```

The arithmetic is done modulo $2^8 = 256$: `260 mod 256 = 4`. This is fast and predictable, which is why hardware works this way, but it means a bug produces *plausible-looking wrong numbers* instead of an error.

NumPy does catch one case: a Python integer that can''t fit into the array''s dtype **at all**.

```python run error
pixels = np.array([200], dtype=np.uint8)
pixels + 300
```

```python predict id=predict-overflow title="What does this print?"
x = np.array([250], dtype=np.uint8)
print(x + 10)
--- options
[260]
* [4]
[255]
OverflowError
--- explain
`10` fits in a `uint8`, so it adopts the array''s dtype and the addition runs in 8-bit arithmetic. `260` doesn''t fit, so it wraps modulo 256 to **4**. NumPy doesn''t clip at 255 or raise; that''s your job.
```

```python debug id=brighten-image title="Bright pixels turn dark"
# Brighten a tiny grayscale image by 100 levels.
# Pixel values must stay within 0-255; anything brighter should become 255.
image = np.array([[ 10, 120, 200],
                  [ 90, 160, 250]], dtype=np.uint8)

brighter = image + 100
print(brighter)
--- solution
# Brighten a tiny grayscale image by 100 levels.
# Pixel values must stay within 0-255; anything brighter should become 255.
image = np.array([[ 10, 120, 200],
                  [ 90, 160, 250]], dtype=np.uint8)

brighter = np.clip(image.astype(np.int16) + 100, 0, 255).astype(np.uint8)
print(brighter)
--- test
expected = np.array([[110, 220, 255], [190, 255, 255]], dtype=np.uint8)
assert isinstance(brighter, np.ndarray), "`brighter` should be a NumPy array."
assert brighter.shape == image.shape, f"`brighter` should keep the image shape {image.shape}, but has {brighter.shape}."
assert brighter.dtype == np.uint8, f"Images must stay uint8, but `brighter` has dtype {brighter.dtype}. Convert back with `.astype(np.uint8)`."
assert brighter[0, 2] != 44, "The pixel at 200 still becomes 44: 300 wrapped around modulo 256. Do the math in a wider dtype first."
assert np.array_equal(brighter, expected), f"Expected\n{expected}\nbut got\n{brighter}\nBright pixels should saturate at 255."
--- hint
Run it and compare `image` with `brighter`. What happened to 200 and 250?
--- hint
Convert to a wider integer type (like `np.int16`) *before* adding, so 300 can exist. Then cap the values with `np.clip(x, 0, 255)` and convert back to `np.uint8`.
```

```python debug id=negative-file-sizes title="File sizes turned negative"
# File sizes in kilobytes, stored compactly as 32-bit integers.
sizes_kb = np.array([3_500_000, 1_200_000, 4_800_000, 950_000], dtype=np.int32)

sizes_bytes = sizes_kb * 1024
total_bytes = sizes_bytes.sum()

print("bytes per file:", sizes_bytes)
print("total:", total_bytes)
--- solution
# File sizes in kilobytes, stored compactly as 32-bit integers.
sizes_kb = np.array([3_500_000, 1_200_000, 4_800_000, 950_000], dtype=np.int32)

sizes_bytes = sizes_kb.astype(np.int64) * 1024
total_bytes = sizes_bytes.sum()

print("bytes per file:", sizes_bytes)
print("total:", total_bytes)
--- test
true_bytes = [3_500_000 * 1024, 1_200_000 * 1024, 4_800_000 * 1024, 950_000 * 1024]
assert isinstance(sizes_bytes, np.ndarray), "`sizes_bytes` should be a NumPy array."
assert (sizes_bytes > 0).all(), f"Some sizes are negative: {sizes_bytes.tolist()}. The multiplication overflowed int32 (max ≈ 2.1 billion)."
assert sizes_bytes.tolist() == true_bytes, f"`sizes_bytes` should be {true_bytes} but is {sizes_bytes.tolist()}."
assert int(total_bytes) == sum(true_bytes), f"`total_bytes` should be {sum(true_bytes):,} but is {int(total_bytes):,}."
--- hint
Run the cell. A 3.5 GB file can''t have a negative size. Compare the true size, 3,500,000 × 1024, with `np.iinfo(np.int32).max`.
--- hint
Multiplying two int32 values produces an int32 result, which overflows. Convert to `np.int64` **before** multiplying.
```

## Promotion: what dtype do mixed operations produce?

When you combine different dtypes, NumPy **promotes** them to a type that can represent both:

```python run
print("int8  + int16  ->", np.result_type(np.int8, np.int16))
print("int32 + float32 ->", np.result_type(np.int32, np.float32))
print("uint8 + float  ->", (np.array([1], dtype=np.uint8) + 1.5).dtype)
print("bool  + int8   ->", np.result_type(np.bool_, np.int8))
```

`int32 + float32` becomes `float64` because `float32` can''t represent every `int32` exactly. NumPy picks the smallest type that''s safe for both.

Python numbers are a special case. Since NumPy 2, plain Python `int`s and `float`s are **"weak"**: they adapt to the array''s dtype instead of forcing an upgrade. NumPy *scalars* are not weak:

```python run
x = np.array([1.0, 2.0], dtype=np.float32)

print("float32 array * 2.5            ->", (x * 2.5).dtype)              # Python float: stays float32
print("float32 array * np.float64(2.5) ->", (x * np.float64(2.5)).dtype)  # NumPy scalar: promotes
```

> **Under the hood:** this behavior is defined by NumPy''s NEP 50, introduced in NumPy 2.0. Older versions sometimes peeked at the *value* of a Python number to choose the result type, which made results data-dependent. If you maintain older code, this is a common source of tiny differences after upgrading.

```python exercise id=smallest-dtype title="Pick the smallest dtype that fits"
# Store these item counts using the SMALLEST UNSIGNED integer dtype
# that can hold all of them exactly.
values = [0, 255, 256, 40_000]

counts = ...
--- solution
values = [0, 255, 256, 40_000]

counts = np.array(values, dtype=np.uint16)
--- test
assert counts is not ..., "Replace the `...` with a NumPy array built from `values`."
assert isinstance(counts, np.ndarray), f"`counts` should be a NumPy array, not {type(counts).__name__}."
assert counts.dtype.kind == "u", f"Counts are never negative, so use an UNSIGNED dtype (uint...). `counts` has {counts.dtype}."
assert counts.tolist() == values, f"`counts` should hold exactly {values}, but holds {counts.tolist()}. Did a value overflow?"
assert counts.dtype == np.uint16, f"{counts.dtype} works, but it isn''t the smallest unsigned type that fits 40,000. Compare the max of each with `np.iinfo`."
--- hint
List the unsigned types from smallest to largest and check each one''s maximum with `np.iinfo(np.uint8).max`, `np.iinfo(np.uint16).max`, and so on.
--- hint
`uint8` stops at 255, so 256 doesn''t fit. Pass your choice with `np.array(values, dtype=...)`.
```

## Floating-point precision

Floats store numbers in binary with a fixed number of significant digits, so most decimals, like `0.1`, can''t be represented exactly:

```python run
print(0.1 + 0.2)
print(0.1 + 0.2 == 0.3)
print(np.isclose(0.1 + 0.2, 0.3))

print("float64 eps:", np.finfo(np.float64).eps)   # ~16 significant digits
print("float32 eps:", np.finfo(np.float32).eps)   # ~7 significant digits
print("float16 can''t count past 2048 by ones:", np.float16(2048) + np.float16(1))
```

`eps` (machine epsilon) is the gap between 1.0 and the next representable number. A `float16` has so few bits that once you reach 2048, adding 1 changes nothing at all.

> **Rule:** never compare floats with `==`. Use `np.isclose(a, b)` for scalars and `np.allclose(a, b)` for whole arrays; both allow a small tolerance.

```python debug id=books-dont-balance title="The books never balance"
payments = np.array([0.1, 0.2])
expected_total = 0.3

total = payments.sum()
if total == expected_total:
    status = "balanced"
else:
    status = "MISMATCH"

print(f"total = {total!r} -> {status}")
--- solution
payments = np.array([0.1, 0.2])
expected_total = 0.3

total = payments.sum()
if np.isclose(total, expected_total):
    status = "balanced"
else:
    status = "MISMATCH"

print(f"total = {total!r} -> {status}")
--- test
assert status == "balanced", f"0.1 + 0.2 should count as matching 0.3, but `status` is {status!r}. Exact `==` on floats fails because of tiny rounding errors."
assert np.isclose(total, 0.3), "`total` should still be the sum of the payments."
--- hint
Look at the printed `total`. It''s not *exactly* 0.3.
--- hint
Replace the exact comparison with a tolerant one: `np.isclose(total, expected_total)`.
```

> **In the wild:** for money, professionals avoid floats entirely and store **integer cents** (`int64`). Integers are exact; floats are approximations.

## Booleans and complex numbers

Booleans behave like 0 and 1 in arithmetic, which makes counting easy. Complex numbers unlock square roots of negatives and are everywhere in signal processing:

```python run
passed = np.array([True, False, True, True])
print("number passed:", passed.sum(), "| share:", passed.mean())

z = np.array([3 + 4j, -1 + 0j])
print("dtype:", z.dtype, "| magnitudes:", np.abs(z))
print("sqrt of -4 as complex:", np.sqrt(np.array([-4 + 0j])))
print("sqrt of -4 as float:  ", np.sqrt(np.array([-4.0])))
```

The square root of a negative `float64` is `nan`. On a desktop NumPy also prints a `RuntimeWarning: invalid value encountered`, but this browser runtime can''t detect floating-point errors, so the `nan` appears silently. Either way, the dtype decides the answer: to get `2j` you need a complex input.

## Safe casting

`astype` will convert anything you ask for, even if it loses information. To guard against that, pass `casting="safe"`, or ask first with `np.can_cast`:

```python run
print("int16 -> int32 safe?  ", np.can_cast(np.int16, np.int32))
print("float64 -> int32 safe?", np.can_cast(np.float64, np.int32))
print("int64 -> int8 safe?   ", np.can_cast(np.int64, np.int8))
```

```python run error
np.array([1.5, 2.7]).astype(np.int32, casting="safe")
```

## Recap

- An array''s **dtype** fixes its memory per element, its precision and its range. Check it with `.dtype`, `np.iinfo` and `np.finfo`.
- The default integer is **platform-dependent**: `int32` in this browser, usually `int64` on desktops. Pass `dtype=` when size matters.
- `astype` creates a converted copy; float → int **truncates**, so `np.round` first.
- Integer arithmetic **wraps around** silently on overflow. Widen first (`astype(np.int64)`, `int16` for pixels) and `np.clip` when you need saturation.
- Mixed operations promote to a safe common type; Python scalars are "weak" and adopt the array''s dtype.
- Floats are approximations: compare with `np.isclose` / `np.allclose`, never `==`.

**Up next:** indexing and slicing in N dimensions, the core skill of selecting exactly the data you want.
', 0, '[]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_2_5', 'sec_numpy_2', 'crs_numpy_mastery', 'Checkpoint: creating arrays', 'quiz', 4, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"You run `np.zeros(3, 4)`. What happens?","options":["It creates a 3 × 4 array of zeros","It creates a 1-D array of 3 zeros with dtype int","It raises a TypeError, because 4 is interpreted as the dtype argument","It creates a 4 × 3 array of zeros"],"answerIndex":2,"explanation":"Factory functions take the shape as a single argument. Here 3 is the shape and 4 lands in the `dtype` parameter, which is not a valid data type. Write `np.zeros((3, 4))`."},{"id":"q2","prompt":"`counts` is an integer array. You create `out = np.zeros_like(counts)` and assign `out[0] = 0.75`. What is stored in `out[0]`?","options":["0.75","1","0","NaN"],"answerIndex":2,"explanation":"`zeros_like` copies the dtype of its input, so `out` is an integer array. Assigning 0.75 truncates it to 0. Pass `dtype=float` to avoid this."},{"id":"q3","prompt":"You need exactly 11 evenly spaced points from 0.0 to 1.0, with both endpoints included. Which call is the most reliable?","options":["np.arange(0, 1.0, 0.1)","np.arange(0, 1.1, 0.1)","np.linspace(0, 1, 11)","np.linspace(0, 1, 10)"],"answerIndex":2,"explanation":"`linspace` lets you specify the number of points and includes the endpoint by default. `arange` excludes `stop`, and with float steps its length depends on rounding error."},{"id":"q4","prompt":"With `x` of length 3 and `y` of length 5, what is the shape of `X` in `X, Y = np.meshgrid(x, y)`?","options":["(3, 5)","(5, 3)","(15,)","(3, 3)"],"answerIndex":1,"explanation":"With the default `indexing=\"xy\"`, rows follow `y` and columns follow `x`, so the grid has shape `(len(y), len(x)) = (5, 3)`. Pass `indexing=\"ij\"` for `(3, 5)`."},{"id":"q5","prompt":"A simulation creates `rng = np.random.default_rng(0)` inside a loop and draws one number per iteration. What goes wrong?","options":["Nothing, it is the recommended pattern","Every iteration draws the same number, because the generator is reset to the same state each time","It raises an error because a generator can only be created once","The numbers are no longer reproducible between runs"],"answerIndex":1,"explanation":"Re-seeding resets the generator, so each iteration starts from the identical state and produces the same value. Create the generator once, outside the loop, and keep drawing from it."},{"id":"q6","prompt":"`a = np.array([250], dtype=np.uint8)`. What is `a + 10`?","options":["array([260])","array([255]), clipped to the maximum","array([4]), wrapped around modulo 256","It raises an OverflowError"],"answerIndex":2,"explanation":"The Python int 10 fits in uint8, so the addition runs in 8-bit arithmetic and 260 wraps around to 260 − 256 = 4. NumPy neither clips nor raises for array overflow; widen the dtype first if you need the true result."},{"id":"q7","prompt":"Which statement about NumPy''s default integer dtype is correct?","options":["It is always int64","It is always int32","It depends on the platform: int64 on most 64-bit desktops, but int32 on 32-bit platforms such as WebAssembly","NumPy has no default integer; you must always pass dtype="],"answerIndex":2,"explanation":"The default integer follows the platform''s pointer size (`np.intp`). In this browser runtime it is int32, so large sums can overflow. Pass `dtype=np.int64` when the size matters."}]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_3_1', 'sec_numpy_3', 'crs_numpy_mastery', 'Indexing and slicing in N dimensions', 'interactive', 0, 1080, NULL, NULL, 'Almost every line of real NumPy code reaches *into* an array: the last 30 days of prices, the first three channels of an image, every other row of a dataset. Indexing and slicing are how you say "this part, please". Once you''re fluent, you''ll replace whole loops with a single bracket expression.

In this lesson you''ll learn to pick out single elements, ranges, strided samples and sub-grids from arrays of any dimension, and you''ll learn the one rule that trips up nearly everyone: **an integer index removes a dimension; a slice keeps it.**

## Indexing in one dimension

A 1-D array is indexed exactly like a Python list. Positions start at `0`, and **negative indices count from the end**: `-1` is the last element, `-2` the one before it.

```python run
import numpy as np

prices = np.array([101.5, 102.0, 99.8, 103.2, 104.9, 104.1, 106.3])

print("first:", prices[0])
print("third:", prices[2])
print("last:", prices[-1])
print("second to last:", prices[-2])
```

Indexing past the end raises an `IndexError`. Valid indices for an array of length `n` run from `0` to `n - 1`, or from `-n` to `-1`.

```python run error
prices[7]
```

## Slicing: `start:stop:step`

A **slice** selects a range. `a[start:stop]` includes `start` but **excludes** `stop`, so `a[2:5]` gives you exactly `5 - 2 = 3` elements. Any part can be omitted:

| Slice | Meaning |
|---|---|
| `a[:3]` | the first 3 elements |
| `a[3:]` | everything from index 3 on |
| `a[-3:]` | the last 3 elements |
| `a[::2]` | every second element |
| `a[1::2]` | every second element, starting at index 1 |
| `a[::-1]` | the whole array, reversed |

```python run
days = np.arange(10)          # 0, 1, ..., 9

print("first three:   ", days[:3])
print("index 2 to 5:  ", days[2:5])
print("last three:    ", days[-3:])
print("evens:         ", days[::2])
print("odds:          ", days[1::2])
print("reversed:      ", days[::-1])
```

> **Tip:** The half-open convention makes sizes easy: `a[:k]` and `a[k:]` split an array into two pieces with no overlap and nothing missing. That''s exactly what you want for train/test splits.

```python predict id=predict-slice title="What does this print?"
a = np.arange(10, 20)
print(a[2:8:3])
--- options
[12 15 18]
* [12 15]
[13 16]
[12 14 16]
--- explain
`np.arange(10, 20)` is `[10, 11, ..., 19]`. Start at index 2 (value `12`), step by 3 to index 5 (value `15`). The next index would be 8, but `stop` is **excluded**, so the slice ends there.
```

```python exercise id=slice-week title="Slice a week of readings"
# 14 days of step counts, oldest first
steps = np.array([4200, 8100, 7600, 10200, 6300, 12000, 9800,
                  5100, 7700, 11300, 8800, 6900, 13100, 9400])

# TODO: use slicing (no loops, no np.array([...]) by hand)
first_week = ...      # the first 7 days
last_three = ...      # the final 3 days
every_other = ...     # days 0, 2, 4, ... (every second day)
newest_first = ...    # all 14 days, most recent first
--- solution
steps = np.array([4200, 8100, 7600, 10200, 6300, 12000, 9800,
                  5100, 7700, 11300, 8800, 6900, 13100, 9400])

first_week = steps[:7]
last_three = steps[-3:]
every_other = steps[::2]
newest_first = steps[::-1]
--- test
for name, val in [("first_week", first_week), ("last_three", last_three), ("every_other", every_other), ("newest_first", newest_first)]:
    assert val is not ..., f"Replace the `...` after `{name} =` with a slice of `steps`."
    assert isinstance(val, np.ndarray), f"`{name}` should be a NumPy array (a slice of `steps`), not {type(val).__name__}."
assert first_week.shape == (7,), f"`first_week` should hold 7 days but has shape {first_week.shape}."
assert np.array_equal(first_week, steps[:7]), "`first_week` should be the first 7 values of `steps`."
assert last_three.shape == (3,), f"`last_three` should hold 3 days but has shape {last_three.shape}."
assert np.array_equal(last_three, [6900, 13100, 9400]), "`last_three` should be the final 3 values, in their original order. Negative start indices help here."
assert np.array_equal(every_other, steps[0::2]), "`every_other` should start at day 0 and take every second day."
assert np.array_equal(newest_first, steps[::-1]), "`newest_first` should contain all 14 values in reverse order."
--- hint
A slice is `start:stop:step`, and any part can be left out.
--- hint
Negative indices count from the end, so `-3` is "three from the end". A negative step walks backwards.
--- hint
You''ll need `[:7]`, a slice starting at `-3`, a step of `2`, and a step of `-1`.
```

## Two dimensions: rows first, then columns

A 2-D array is a grid. You index it with **one index per axis, separated by a comma**: `grid[row, col]`. Axis 0 runs down the rows, axis 1 runs across the columns.

```python run
grid = np.arange(1, 13).reshape(3, 4)
print(grid)
print()
print("row 1, col 2:", grid[1, 2])
print("bottom-right:", grid[-1, -1])
```

You may also see `grid[1][2]`. It gives the same answer, but it works in two steps: `grid[1]` builds the whole row first, then `[2]` indexes into it. `grid[1, 2]` is a single, faster operation, and with slices the two forms can mean completely different things, as you''ll see in a moment. **Always use the comma form.**

### Rows, columns and sub-grids

Put a slice in any position. A bare `:` means "everything along this axis".

```python run
grid = np.arange(1, 13).reshape(3, 4)

print("row 0:        ", grid[0, :])     # same as grid[0]
print("column 2:     ", grid[:, 2])
print("top-left 2x2:\n", grid[:2, :2])
print("every other column:\n", grid[:, ::2])
```

> **Pitfall:** `grid[:, 2]` is column 2, but `grid[:][2]` is **row 2**. `grid[:]` is the whole grid, and the second `[2]` then picks a row. This is the classic reason to avoid chained brackets.

```python predict id=predict-chained title="Chained brackets vs. a comma"
grid = np.arange(1, 13).reshape(3, 4)
print(grid[:][1], grid[:, 1])
--- options
[2 6 10] [2 6 10]
* [5 6 7 8] [ 2  6 10]
[5 6 7 8] [5 6 7 8]
[ 2  6 10] [5 6 7 8]
--- explain
`grid[:]` is just the whole grid, so `grid[:][1]` selects **row** 1: `[5 6 7 8]`. The comma form `grid[:, 1]` means "every row, column 1": `[ 2  6 10]`. NumPy pads `2` and `6` so every value has the same width as `10`.
```

## Integer index vs. slice: the dimension rule

Here''s the rule that explains most surprises in NumPy indexing:

- An **integer** index *selects one position* and **removes** that axis.
- A **slice** *selects a range* (even a range of length 1) and **keeps** the axis.

```python run
grid = np.arange(1, 13).reshape(3, 4)

row_int = grid[1]       # integer -> axis removed
row_slice = grid[1:2]   # slice   -> axis kept

print(row_int, "shape:", row_int.shape)
print(row_slice, "shape:", row_slice.shape)
print("column as 1-D:", grid[:, 0].shape, " column as 2-D:", grid[:, 0:1].shape)
```

Both contain the same numbers, but `(4,)` and `(1, 4)` behave differently in arithmetic and matrix multiplication. When a function expects a 2-D input, such as a single sample for a scikit-learn model, the slice form keeps your data the right shape.

> **In the wild:** `model.predict(X[0])` often errors with "Expected 2D array, got 1D array". `model.predict(X[0:1])` passes a batch of one sample, with shape `(1, n_features)`, and just works.

```python exercise id=grid-select title="Carve up a sales table"
# Rows = 4 stores, columns = 6 months (Jan..Jun)
sales = np.array([[12, 15, 14, 18, 21, 25],
                  [ 8,  9, 11, 10, 13, 12],
                  [20, 22, 19, 24, 26, 30],
                  [ 5,  7,  6,  9,  8, 11]])

# TODO: use a single indexing expression for each
store2 = ...        # every month for store 2 (third row), as a 1-D array
march = ...         # every store''s March figures (column 2), as a 1-D array
q2 = ...            # all stores, months Apr..Jun (last 3 columns), 2-D
top_left = ...      # first 2 stores x first 2 months, shape (2, 2)
store0_2d = ...     # store 0''s row, but KEEP it 2-D: shape (1, 6)
--- solution
sales = np.array([[12, 15, 14, 18, 21, 25],
                  [ 8,  9, 11, 10, 13, 12],
                  [20, 22, 19, 24, 26, 30],
                  [ 5,  7,  6,  9,  8, 11]])

store2 = sales[2]
march = sales[:, 2]
q2 = sales[:, 3:]
top_left = sales[:2, :2]
store0_2d = sales[0:1]
--- test
names = ["store2", "march", "q2", "top_left", "store0_2d"]
for n in names:
    assert globals()[n] is not ..., f"Replace the `...` after `{n} =` with an indexing expression on `sales`."
    assert isinstance(globals()[n], np.ndarray), f"`{n}` should be a NumPy array taken from `sales`."
assert store2.shape == (6,), f"`store2` should be 1-D with 6 months, but has shape {store2.shape}. An integer index drops the row axis."
assert np.array_equal(store2, [20, 22, 19, 24, 26, 30]), "`store2` should be the third row (index 2)."
assert march.shape == (4,), f"`march` should have one value per store, shape (4,), but has {march.shape}."
assert np.array_equal(march, [14, 11, 19, 6]), "`march` should be column index 2 (Jan is 0). Did you select a row by accident?"
assert q2.shape == (4, 3), f"`q2` should be shape (4, 3), but is {q2.shape}."
assert np.array_equal(q2, sales[:, -3:]), "`q2` should contain the last 3 months for every store."
assert top_left.shape == (2, 2) and np.array_equal(top_left, [[12, 15], [8, 9]]), f"`top_left` should be the first 2 rows and first 2 columns; you have shape {top_left.shape}."
assert store0_2d.shape == (1, 6), f"`store0_2d` should keep both axes, shape (1, 6), but has {store0_2d.shape}. Use a slice instead of an integer."
assert np.array_equal(store0_2d[0], sales[0]), "`store0_2d` should contain store 0''s figures."
--- hint
Use the comma form: `sales[rows, columns]`. A bare `:` means "all of this axis".
--- hint
An integer index drops an axis; a slice like `0:1` keeps it, even though it only selects one row.
--- hint
Columns come second: March is `sales[:, 2]`, and the last three months are `sales[:, 3:]` (or `-3:`).
```

## Higher dimensions and the ellipsis

The same rules extend to any number of axes: one index per axis, separated by commas, with **missing trailing axes treated as `:`**. A batch of RGB images, for example, is often shaped `(images, height, width, channels)`.

```python run
images = np.arange(2 * 4 * 4 * 3).reshape(2, 4, 4, 3)   # 2 tiny 4x4 RGB images

print("one image:      ", images[0].shape)          # trailing axes default to '':''
print("its red channel:", images[0, :, :, 0].shape)
print("all red channels:", images[..., 0].shape)    # ''...'' fills in every '':'' needed
print("2x2 crop of all:", images[:, :2, :2].shape)
```

`...` (the **ellipsis**) stands for "as many `:` as needed". `images[..., 0]` means "the last axis at position 0, everything else untouched", and it works whether the array is 3-D or 7-D.

## Assigning to slices

Indexing works on the left of `=` too. Assigning a single value **broadcasts** it to the whole selection; assigning an array requires matching shapes.

```python run
board = np.zeros((5, 5), dtype=int)

board[0, :] = 1          # top row
board[:, -1] = 2         # right column
board[2, 1:4] = [7, 8, 9]
board[3:, :2] = 5        # bottom-left block
print(board)
```

This writes **into the original array**. That''s powerful, and it''s also the start of the next lesson''s story about views and copies.

```python exercise id=frame-border title="Draw a frame"
# TODO: write a function that returns an n x n integer array of zeros
# with a border of 1s around the edge, using slice assignment (no loops).
def framed(n):
    out = np.zeros((n, n), dtype=int)
    # your slice assignments here
    ...
    return out

print(framed(5))
--- solution
def framed(n):
    out = np.zeros((n, n), dtype=int)
    out[0, :] = 1
    out[-1, :] = 1
    out[:, 0] = 1
    out[:, -1] = 1
    return out

print(framed(5))
--- test
r = framed(5)
assert isinstance(r, np.ndarray) and r.shape == (5, 5), f"`framed(5)` should return a 5x5 array, got {getattr(r, ''shape'', type(r).__name__)}."
expected = np.ones((5, 5), dtype=int); expected[1:-1, 1:-1] = 0
assert r[0].tolist() == [1] * 5, "The top row should be all 1s."
assert r[-1].tolist() == [1] * 5, "The bottom row should be all 1s."
assert r[:, 0].tolist() == [1] * 5 and r[:, -1].tolist() == [1] * 5, "The left and right columns should be all 1s."
assert np.array_equal(r, expected), "The inside of the frame should stay 0."
r8 = framed(8)
e8 = np.ones((8, 8), dtype=int); e8[1:-1, 1:-1] = 0
assert np.array_equal(r8, e8), "Your function should work for any size, e.g. `framed(8)`. Use negative indices rather than hard-coded positions."
--- hint
Four assignments do it: the first row, the last row, the first column, the last column.
--- hint
`out[0, :] = 1` sets the top row. Use `-1` for "last", so it works for any `n`.
```

## Debug challenge: the off-by-one split

```python debug id=split-off-by-one title="The test set is one row short"
# 10 samples, 3 features each. We want the first 8 rows for training
# and the remaining 2 rows for testing — every row used exactly once.
data = np.arange(30).reshape(10, 3)

train = data[:8]
test = data[9:]

print("train rows:", len(train), " test rows:", len(test))
--- solution
data = np.arange(30).reshape(10, 3)

train = data[:8]
test = data[8:]

print("train rows:", len(train), " test rows:", len(test))
--- test
assert train.shape == (8, 3), f"`train` should be the first 8 rows, shape (8, 3), but has {train.shape}."
assert test.shape == (2, 3), f"`test` should have 2 rows, but has {test.shape[0]}. Is a row being skipped?"
assert np.array_equal(np.concatenate([train, test]), data), "Together, `train` and `test` should contain every row of `data` exactly once, in order."
--- hint
Run it: 8 + 1 = 9, so one row disappeared. Which index belongs to neither piece?
--- hint
`data[:8]` stops *before* index 8. Where should the test slice start so that row 8 isn''t lost?
```

## Debug challenge: the wrong axis

```python debug id=column-not-row title="Average temperature per sensor"
# Rows are hours (6), columns are sensors (3).
readings = np.array([[20.1, 18.4, 22.0],
                     [20.5, 18.9, 22.4],
                     [21.0, 19.3, 22.9],
                     [21.4, 19.8, 23.1],
                     [21.9, 20.0, 23.6],
                     [22.3, 20.4, 24.0]])

# Average of sensor 1 (the middle column) across all hours
sensor1 = readings[1]
sensor1_mean = sensor1.mean()
print("sensor 1 values:", sensor1)
print("sensor 1 mean:", round(sensor1_mean, 2))
--- solution
readings = np.array([[20.1, 18.4, 22.0],
                     [20.5, 18.9, 22.4],
                     [21.0, 19.3, 22.9],
                     [21.4, 19.8, 23.1],
                     [21.9, 20.0, 23.6],
                     [22.3, 20.4, 24.0]])

sensor1 = readings[:, 1]
sensor1_mean = sensor1.mean()
print("sensor 1 values:", sensor1)
print("sensor 1 mean:", round(sensor1_mean, 2))
--- test
assert sensor1.shape == (6,), f"`sensor1` should have one value per hour (6 values), but has shape {sensor1.shape}. Look at which axis you indexed."
assert np.allclose(sensor1, [18.4, 18.9, 19.3, 19.8, 20.0, 20.4]), "`sensor1` should be the middle column of `readings`."
assert np.isclose(sensor1_mean, 19.4666666), f"`sensor1_mean` should be about 19.47, got {sensor1_mean}."
--- hint
Run it and look at `sensor 1 values`: you get 3 numbers, but there are 6 hours.
--- hint
`readings[1]` is **row** 1, which is one hour. A column needs a `:` for the rows first.
```

## Recap

- 1-D: `a[i]`, negative indices from the end, and `a[start:stop:step]` with `stop` **excluded**. `a[::-1]` reverses.
- N-D: one index per axis, separated by commas: `a[row, col]`. Prefer this over `a[row][col]`.
- `:` means "this whole axis", and `...` fills in as many `:` as needed.
- **Integer index removes an axis; a slice keeps it.** `a[1]` is `(4,)`, `a[1:2]` is `(1, 4)`.
- You can assign to any selection, and a scalar on the right is spread across all of it.

**Up next:** slices don''t copy your data; they''re *windows* into it. That''s fast, and it''s also NumPy''s number-one source of bugs.
', 0, '[]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_3_2', 'sec_numpy_3', 'crs_numpy_mastery', 'Views vs. copies: NumPy''s #1 source of bugs', 'interactive', 1, 960, NULL, NULL, 'Here''s a bug that has cost data scientists entire afternoons. You take the first few rows of a dataset, normalize them for a quick experiment… and later discover your *original* dataset changed too. No error, no warning, just quietly wrong numbers flowing into everything downstream.

The cause is one of NumPy''s best features: **slicing doesn''t copy data.** A slice is a *view*, a new window onto the same memory. In this lesson you''ll learn exactly which operations create views and which create copies, how to check, and how to write code that never surprises you.

## A slice is a window, not a copy

Watch what happens to `prices` when we change `first_three`:

```python run
import numpy as np

prices = np.array([10.0, 20.0, 30.0, 40.0, 50.0])
first_three = prices[:3]

first_three[0] = 999.0
print("first_three:", first_three)
print("prices:     ", prices)        # changed too!
```

`first_three` never had its own numbers. It''s a little header saying "start at the beginning of `prices`'' memory and show 3 elements". Write through it, and you write into `prices`.

```text
prices        →  [ 999 | 20 | 30 | 40 | 50 ]   one block of memory
first_three   →  [ 999 | 20 | 30 ]             same memory, shorter window
```

### Why NumPy works this way

Views make slicing **instant and free**, no matter how big the array is. Taking a slice of the 4-million-element array below doesn''t copy 32 MB of data; it just creates a tiny new header. That''s why NumPy can chew through huge datasets, and it''s also how libraries like pandas and PyTorch avoid copying your data behind your back.

```python run
import time

big = np.zeros(4_000_000)

t = time.perf_counter(); window = big[1000:3_000_000]; t_view = time.perf_counter() - t
t = time.perf_counter(); copied = big[1000:3_000_000].copy(); t_copy = time.perf_counter() - t

print(f"view: {t_view * 1e6:8.1f} µs   (no data moved)")
print(f"copy: {t_copy * 1e6:8.1f} µs   ({copied.nbytes / 1e6:.0f} MB moved)")
```

## How to tell: `.base` and `np.shares_memory`

Two tools tell you whether arrays share data:

- `b.base` is the array that `b` borrows its memory from, or `None` if `b` owns its data.
- `np.shares_memory(a, b)` answers directly: do these two arrays overlap in memory?

```python run
a = np.arange(10)
s = a[2:6]
c = a[2:6].copy()

print("s.base is a:        ", s.base is a)
print("c.base:             ", c.base)
print("shares_memory(a, s):", np.shares_memory(a, s))
print("shares_memory(a, c):", np.shares_memory(a, c))
```

> **Tip:** When you''re unsure, don''t guess. `np.shares_memory(original, result)` takes one line and settles it.

## `.copy()`: when you want your own data

If you''re going to modify a piece of an array and you need the original untouched, take an explicit copy:

```python run
scores = np.array([72, 85, 90, 64, 88])

top = scores[1:4].copy()   # independent
top[:] = 0
print("top:   ", top)
print("scores:", scores)   # unchanged
```

```python exercise id=independent-crop title="Crop without damaging the original"
image = np.arange(1, 26).reshape(5, 5)   # a tiny 5x5 "image"

# TODO: make `crop` the 3x3 centre of `image` (rows 1-3, columns 1-3)
# as an INDEPENDENT array, then blank it out by setting all of crop to 0.
# `image` must stay exactly as it was.
crop = ...

print(crop)
print(image)
--- solution
image = np.arange(1, 26).reshape(5, 5)

crop = image[1:4, 1:4].copy()
crop[:] = 0

print(crop)
print(image)
--- test
assert crop is not ..., "Replace the `...` after `crop =` with a slice of `image`."
assert isinstance(crop, np.ndarray), "`crop` should be a NumPy array."
assert crop.shape == (3, 3), f"`crop` should be the 3x3 centre, but has shape {crop.shape}. Rows 1-3 are the slice `1:4`."
assert np.array_equal(image, np.arange(1, 26).reshape(5, 5)), "`image` was modified! Your crop is still a view into it. Make it independent first."
assert not np.shares_memory(crop, image), "`crop` still shares memory with `image`."
assert np.all(crop == 0), "After cropping, set every value of `crop` to 0."
--- hint
A plain slice is a view, so writing to it writes into `image`. What method gives an array its own memory?
--- hint
Slice the centre with `image[1:4, 1:4]`, call `.copy()` on it, then set `crop[:] = 0`.
```

## Views vs. copies: the cheat sheet

The rule of thumb: **if NumPy can describe the result as a regular pattern of steps through the same memory, you get a view. Otherwise you get a copy.**

| Operation | Result | Why |
|---|---|---|
| `a[2:8]`, `a[::2]`, `a[:, 1]` | **view** | regular strides through the same memory |
| `a.reshape(...)` | view (usually) | same data, new shape |
| `a.T`, `a.transpose()` | **view** | same data, axes swapped |
| `a.ravel()` | view if possible | copies only when it must |
| `a[[0, 2, 4]]` (fancy indexing) | **copy** | arbitrary positions can''t be one stride pattern |
| `a[a > 0]` (boolean mask) | **copy** | same reason |
| `a + 1`, `a * b`, `np.sqrt(a)` | **copy** | new values, new memory |
| `a.flatten()`, `a.copy()`, `np.array(a)` | **copy** | always, by design |

```python run
a = np.arange(12).reshape(3, 4)

for label, b in [("a[1:, ::2]", a[1:, ::2]), ("a.T", a.T), ("a.reshape(4, 3)", a.reshape(4, 3)),
                 ("a[[0, 2]]", a[[0, 2]]), ("a[a > 5]", a[a > 5]), ("a * 2", a * 2)]:
    print(f"{label:18} shares memory: {np.shares_memory(a, b)}")
```

```python predict id=predict-mask-copy title="Does the original change?"
a = np.array([1, 2, 3, 4, 5])
big = a[a > 2]
big[0] = 100
print(a)
--- options
[  1   2 100   4   5]
* [1 2 3 4 5]
[100   2   3   4   5]
[100 4 5]
--- explain
Boolean indexing picks arbitrary positions, so NumPy has to gather them into **new memory**. `big` is a copy, and changing it leaves `a` alone. (Assigning *through* a mask, as in `a[a > 2] = 100`, is different: that writes into `a` directly.)
```

```python exercise id=view-or-copy title="View or copy?"
a = np.arange(10)

# TODO: for each expression, write True if the result is a VIEW of `a`
# (shares its memory) or False if it''s a COPY. Predict first, then
# verify with np.shares_memory if you like.
answers = {
    "a[3:7]":            ...,
    "a[[1, 3, 5]]":      ...,
    "a.reshape(2, 5)":   ...,
    "a[a % 2 == 0]":     ...,
    "a[::-1]":           ...,
    "a * 1":             ...,
}
--- solution
a = np.arange(10)

answers = {
    "a[3:7]":            True,
    "a[[1, 3, 5]]":      False,
    "a.reshape(2, 5)":   True,
    "a[a % 2 == 0]":     False,
    "a[::-1]":           True,
    "a * 1":             False,
}
--- test
assert isinstance(answers, dict), "`answers` should stay a dictionary."
truth = {"a[3:7]": True, "a[[1, 3, 5]]": False, "a.reshape(2, 5)": True, "a[a % 2 == 0]": False, "a[::-1]": True, "a * 1": False}
missing = [k for k in truth if answers.get(k) is ...]
assert not missing, f"Fill in True or False for: {'', ''.join(missing)}"
for k, v in answers.items():
    assert isinstance(v, (bool, np.bool_)), f"The answer for `{k}` should be True or False, not {v!r}."
wrong = [k for k in truth if bool(answers.get(k)) != truth[k]]
assert not wrong, f"{len(wrong)} answer(s) are off. Recheck: {'', ''.join(wrong)}. Try `np.shares_memory(a, <expression>)`."
--- hint
Slices (including negative steps), reshapes and transposes describe a regular walk through the same memory.
--- hint
Fancy indexing (a list of positions), boolean masks and arithmetic always produce new arrays.
```

## Functions that mutate their arguments

Views get more dangerous when they cross a function boundary. NumPy arrays are passed **by reference**, and in-place operators like `-=`, `*=` and `[:] =` write into the caller''s array.

```python run
def center_in_place(x):
    x -= x.mean()       # modifies the caller''s array!
    return x

def center(x):
    return x - x.mean() # builds a new array; the input is untouched

data = np.array([2.0, 4.0, 6.0])
print("center:         ", center(data), " data:", data)
print("center_in_place:", center_in_place(data), " data:", data)
```

`x -= m` and `x = x - m` look almost identical, but the first **writes into existing memory** while the second creates a new array and rebinds the name `x`. In-place operations save memory, which matters for huge arrays, so use them deliberately and document it. Never use them by accident in a function that "returns" a result.

> **In the wild:** pandas'' famous `SettingWithCopyWarning` exists precisely because of this view/copy ambiguity. Knowing the NumPy rules makes that warning make sense.

## Debug challenge: the function that ate the dataset

```python debug id=normalize-mutates title="Scaling corrupts the raw data"
raw = np.array([[ 50.0, 1.2],
                [ 80.0, 3.4],
                [ 65.0, 2.1],
                [ 95.0, 4.8]])

def min_max_scale(x):
    """Return a scaled copy of x, with each column mapped to [0, 1]."""
    x -= x.min(axis=0)
    x /= x.max(axis=0)
    return x

scaled = min_max_scale(raw)
print("scaled:\n", scaled)
print("raw (should be unchanged):\n", raw)
--- solution
raw = np.array([[ 50.0, 1.2],
                [ 80.0, 3.4],
                [ 65.0, 2.1],
                [ 95.0, 4.8]])

def min_max_scale(x):
    """Return a scaled copy of x, with each column mapped to [0, 1]."""
    x = x - x.min(axis=0)
    x = x / x.max(axis=0)
    return x

scaled = min_max_scale(raw)
print("scaled:\n", scaled)
print("raw (should be unchanged):\n", raw)
--- test
original = np.array([[50.0, 1.2], [80.0, 3.4], [65.0, 2.1], [95.0, 4.8]])
assert np.allclose(raw, original), "`raw` was modified by `min_max_scale`. The function should leave its input alone."
assert not np.shares_memory(scaled, raw), "`scaled` shares memory with `raw`, so it''s still operating in place."
assert np.allclose(scaled.min(axis=0), 0) and np.allclose(scaled.max(axis=0), 1), "Each column of `scaled` should run from 0 to 1."
probe = np.array([[1.0, 10.0], [3.0, 30.0]])
probe_before = probe.copy()
out = min_max_scale(probe)
assert np.allclose(probe, probe_before), "`min_max_scale` still modifies whatever array you pass in."
assert np.allclose(out, [[0, 0], [1, 1]]), "`min_max_scale` should map each column to [0, 1]."
--- hint
Run it and compare `raw` before and after. The scaling is correct, but the docstring promises a *copy*.
--- hint
`x -= ...` and `x /= ...` write into the caller''s array. What''s the non-in-place way to write the same arithmetic?
```

## Debug challenge: every snapshot is the same

This one is the "list of views" bug. It shows up in simulations, training loops, and anywhere you save the state of something as it changes.

```python debug id=snapshot-history title="The history only remembers the last step"
# A particle moves by `velocity` each step; we record its position history.
position = np.array([0.0, 0.0])
velocity = np.array([1.0, 0.5])

history = []
for step in range(4):
    history.append(position)
    position += velocity

for i, p in enumerate(history):
    print(f"step {i}: {p}")
--- solution
position = np.array([0.0, 0.0])
velocity = np.array([1.0, 0.5])

history = []
for step in range(4):
    history.append(position.copy())
    position += velocity

for i, p in enumerate(history):
    print(f"step {i}: {p}")
--- test
assert len(history) == 4, f"`history` should have 4 snapshots, has {len(history)}."
expected = [[0.0, 0.0], [1.0, 0.5], [2.0, 1.0], [3.0, 1.5]]
got = [np.asarray(p).tolist() for p in history]
assert len({tuple(p) for p in got}) > 1, "Every snapshot in `history` is identical. They are all the same array object."
assert got == expected, f"`history` should be {expected}, but is {got}."
assert np.allclose(position, [4.0,2.0]), "`position` should end at [4.0, 2.0] after 4 steps."
--- hint
Use **Debug** and watch `history` as the loop runs. Do the earlier entries change when `position` changes?
--- hint
`history.append(position)` stores *the same array object* every time, and `+=` updates it in place. Store a snapshot instead.
```

## Debug challenge: the update that never happens

```python debug id=chained-fancy title="Restocking does nothing"
# Columns: [item_id, quantity]. Restock items in rows 0 and 3 to quantity 50.
inventory = np.array([[101,  3],
                      [102, 40],
                      [103, 17],
                      [104,  0]])

rows_to_restock = [0, 3]
inventory[rows_to_restock][:, 1] = 50

print(inventory)
--- solution
inventory = np.array([[101,  3],
                      [102, 40],
                      [103, 17],
                      [104,  0]])

rows_to_restock = [0, 3]
inventory[rows_to_restock, 1] = 50

print(inventory)
--- test
assert inventory.shape == (4, 2), "`inventory` should still be a 4x2 array."
assert inventory[0, 1] == 50 and inventory[3, 1] == 50, f"Rows 0 and 3 should have quantity 50, but they are {inventory[0, 1]} and {inventory[3, 1]}."
assert inventory[1, 1] == 40 and inventory[2, 1] == 17, "Rows 1 and 2 should be left alone."
assert inventory[:, 0].tolist() == [101, 102, 103, 104], "Item ids in column 0 must not change."
--- hint
Run it: nothing changed, and no error. `inventory[rows_to_restock]` uses a list of rows. Is that a view or a copy?
--- hint
Chained indexing assigns into a temporary copy that''s immediately thrown away. Do the whole selection in **one** indexing expression: rows, then column.
```

## Recap

- **Slices, reshapes and transposes are views**: they share memory with the original, so writing through them changes it.
- **Fancy indexing, boolean masks and arithmetic make copies.**
- Check with `np.shares_memory(a, b)` or `b.base`. Use `.copy()` when you need independent data.
- In-place operators (`+=`, `-=`, `[:] =`) modify existing memory, including your caller''s arrays.
- Store snapshots with `.copy()`, and never assign through chained fancy indexing. Do it in one bracket expression.

**Up next:** boolean masks, the most expressive way to ask "which elements match?" and then filter, count or fix them.
', 0, '[]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_3_3', 'sec_numpy_3', 'crs_numpy_mastery', 'Boolean masks and filtering', 'interactive', 2, 960, NULL, NULL, '"Which customers spent more than $100?" "How many sensor readings are out of range?" "Replace every negative value with zero." Questions like these are the bread and butter of data work, and in NumPy they all have the same answer: a **boolean mask**.

A mask is an array of `True`/`False` values, one per element, that marks the elements you care about. You can then use it to **filter**, **count**, **test**, or **overwrite**, all without writing a single loop. By the end of this lesson you''ll do in one line what used to take five.

## Comparisons produce masks

Compare an array with a value and you don''t get a single `True` or `False`. You get an **array** of them, one per element. Its dtype is `bool`.

```python run
import numpy as np

temps = np.array([22.5, 31.0, 28.4, 35.2, 19.8, 30.1, 33.7])
hot = temps > 30

print("temps:", temps)
print("hot:  ", hot)
print("dtype:", hot.dtype, " shape:", hot.shape)
```

Every comparison operator works this way: `>`, `>=`, `<`, `<=`, `==` and `!=`. You can compare against another array of the same shape too, element by element.

## Filtering with `a[mask]`

Put a mask inside the brackets and NumPy keeps only the elements where the mask is `True`:

```python run
temps = np.array([22.5, 31.0, 28.4, 35.2, 19.8, 30.1, 33.7])

print("hot days:     ", temps[temps > 30])
print("mild days:    ", temps[temps <= 30])
print("not exactly 30.1:", temps[temps != 30.1])
```

Read `temps[temps > 30]` as "temps, *where* temps is greater than 30". The result is a new 1-D array, a **copy** (remember the last lesson), containing just the matches, in their original order.

## Counting, fractions, `any` and `all`

Because `True` counts as `1` and `False` as `0`, summary statistics on a mask answer counting questions directly:

```python run
temps = np.array([22.5, 31.0, 28.4, 35.2, 19.8, 30.1, 33.7])
hot = temps > 30

print("how many hot days:", hot.sum())
print("fraction hot:     ", round(hot.mean(), 3))
print("any above 35?     ", (temps > 35).any())
print("all above 15?     ", (temps > 15).all())
```

| Question | Expression |
|---|---|
| How many match? | `mask.sum()` or `np.count_nonzero(mask)` |
| What fraction match? | `mask.mean()` |
| Does at least one match? | `mask.any()` |
| Do they all match? | `mask.all()` |

```python exercise id=heatwave-stats title="Heatwave report"
temps = np.array([24.1, 29.8, 31.2, 33.5, 30.0, 27.6, 34.9, 36.1, 28.3, 31.7])

# TODO (no loops):
hot_temps = ...      # the temperatures strictly above 30, as an array
n_hot = ...          # how many days were strictly above 30
frac_hot = ...       # the fraction of days strictly above 30 (between 0 and 1)
any_extreme = ...    # True if any day reached 36 or more
--- solution
temps = np.array([24.1, 29.8, 31.2, 33.5, 30.0, 27.6, 34.9, 36.1, 28.3, 31.7])

hot_temps = temps[temps > 30]
n_hot = (temps > 30).sum()
frac_hot = (temps > 30).mean()
any_extreme = (temps >= 36).any()
--- test
for n in ["hot_temps", "n_hot", "frac_hot", "any_extreme"]:
    assert globals()[n] is not ..., f"Replace the `...` after `{n} =` with your code."
assert isinstance(hot_temps, np.ndarray), "`hot_temps` should be an array, filtered from `temps` with a mask."
assert np.allclose(hot_temps, [31.2, 33.5, 34.9, 36.1, 31.7]), f"`hot_temps` should be the values strictly above 30, in order. Note that 30.0 itself is not above 30. Got {hot_temps}."
assert n_hot == 5, f"`n_hot` should count the hot days, but is {n_hot!r}. Did you sum the temperatures instead of the mask?"
assert np.isclose(frac_hot, 0.5), f"`frac_hot` should be a fraction between 0 and 1, but is {frac_hot!r}."
assert bool(any_extreme) is True, "`any_extreme` should be True: one day reached 36.1."
assert isinstance(any_extreme, (bool, np.bool_)), "`any_extreme` should be a single True/False value."
--- hint
Build the mask once: `temps > 30`. Then filter with it, sum it, and average it.
--- hint
`.any()` turns a whole mask into a single True/False: "is at least one element True?"
```

## Combining conditions: `&`, `|` and `~`

To combine masks, use the **element-wise** logical operators:

| Operator | Meaning |
|---|---|
| `a & b` | and: both true |
| `a \| b` | or: at least one true |
| `~a` | not: flip every value |

**Always wrap each comparison in parentheses.** In Python, `&` and `|` bind *more tightly* than `>` and `<`, so `x > 1 & x < 5` is parsed as `x > (1 & x) < 5`. That''s not what you meant, and it usually crashes.

```python run
prices = np.array([4.99, 12.50, 18.00, 25.00, 9.75, 15.25])

mid_range = (prices >= 10) & (prices <= 20)
outside = ~mid_range
cheap_or_premium = (prices < 5) | (prices > 20)

print("10–20:            ", prices[mid_range])
print("outside 10–20:    ", prices[outside])
print("cheap or premium: ", prices[cheap_or_premium])
```

### Why not `and` and `or`?

Python''s `and`/`or`/`not` need a single `True` or `False`. NumPy refuses to guess whether a whole array counts as true, so it raises this famous error:

```python run error
prices = np.array([4.99, 12.50, 18.00, 25.00])
mask = (prices > 10) and (prices < 20)
```

> **Pitfall:** "The truth value of an array with more than one element is ambiguous" almost always means you used `and`, `or`, `not` or an `if` on an array. Use `&`, `|`, `~`, or reduce the mask with `.any()` / `.all()` first.

```python predict id=predict-count title="Count the matches"
a = np.array([3, 8, 1, 9, 4, 7])
print(((a > 2) & (a < 8)).sum())
--- options
2
* 3
4
22
--- explain
`(a > 2)` is `[T, T, F, T, T, T]` and `(a < 8)` is `[T, F, T, F, T, T]`. Combining them with `&` leaves `[T, F, F, F, T, T]`, which marks `3`, `4` and `7`. Summing a mask counts the `True` values: **3**. (The sum of the matching *values* would be 14.)
```

```python exercise id=order-bands title="Segment the orders"
orders = np.array([12.0, 45.5, 89.9, 20.0, 150.0, 50.0, 7.25, 64.0, 33.3, 210.0])

# TODO: use masks combined with & | ~
medium = ...        # orders from 20 up to 50, INCLUDING both 20 and 50
not_medium = ...    # every order NOT in `medium`, original order
small_or_huge = ... # orders under 10 OR over 200
--- solution
orders = np.array([12.0, 45.5, 89.9, 20.0, 150.0, 50.0, 7.25, 64.0, 33.3, 210.0])

is_medium = (orders >= 20) & (orders <= 50)
medium = orders[is_medium]
not_medium = orders[~is_medium]
small_or_huge = orders[(orders < 10) | (orders > 200)]
--- test
for n in ["medium", "not_medium", "small_or_huge"]:
    assert globals()[n] is not ..., f"Replace the `...` after `{n} =` with your code."
    assert isinstance(globals()[n], np.ndarray), f"`{n}` should be an array of order values (filter `orders` with a mask)."
assert np.allclose(medium, [45.5, 20.0, 50.0, 33.3]), f"`medium` should include 20 and 50 themselves (use >= and <=). Got {medium}."
assert np.allclose(not_medium, [12.0, 89.9, 150.0, 7.25, 64.0, 210.0]), f"`not_medium` should be everything else, in the original order. Got {not_medium}."
assert np.allclose(small_or_huge, [7.25, 210.0]), f"`small_or_huge` should combine two conditions with `|`. Got {small_or_huge}."
assert len(medium) + len(not_medium) == len(orders), "`medium` and `not_medium` together should cover every order exactly once."
--- hint
Wrap each comparison in parentheses, then join them: `(orders >= 20) & (orders <= 50)`.
--- hint
Save that mask in a variable, then use `~mask` to flip it for `not_medium`.
```

## Assigning through a mask

Masks work on the left of `=` too, and this time you''re writing **into the original array**. It''s the cleanest way to fix bad values:

```python run
signal = np.array([0.4, -0.2, 1.3, 7.5, 0.9, -3.1, 1.1])

signal[signal < 0] = 0        # negative readings are sensor glitches
signal[signal > 2] = 2        # cap spikes at 2
print(signal)
```

You can also assign an array, as long as it has one value per `True`:

```python run
grades = np.array([55, 72, 48, 90, 61])
failing = grades < 60

grades[failing] = grades[failing] + 5    # a curve, for failing grades only
print(grades)
```

```python exercise id=clip-outliers title="Clean a sensor signal"
signal = np.array([12.0, -4.0, 55.0, 101.5, 87.0, -0.5, 230.0, 64.0])

# TODO: modify `signal` IN PLACE using mask assignment:
#   - negative values become 0
#   - values above 100 become 100
# Then set `n_fixed` to how many values you changed in total.
n_fixed = ...
--- solution
signal = np.array([12.0, -4.0, 55.0, 101.5, 87.0, -0.5, 230.0, 64.0])

low = signal < 0
high = signal > 100
n_fixed = low.sum() + high.sum()
signal[low] = 0
signal[high] = 100
--- test
assert n_fixed is not ..., "Replace the `...` after `n_fixed =` with your count."
assert np.allclose(signal, [12.0, 0.0, 55.0, 100.0, 87.0, 0.0, 100.0, 64.0]), f"`signal` should have negatives set to 0 and values above 100 set to 100. Got {signal}."
assert n_fixed == 4, f"`n_fixed` should be 4 (2 negatives + 2 above 100), but is {n_fixed!r}. Count before you overwrite, or the masks will change!"
--- hint
`signal[signal < 0] = 0` fixes the negatives in one line. Do the same for the high values.
--- hint
Count the matches **before** you overwrite them: after the fix, nothing is negative any more.
```

## Membership with `np.isin`

To ask "is each element one of these values?", use `np.isin(a, values)`. It''s much cleaner than chaining `==` with `|`:

```python run
product_ids = np.array([101, 204, 305, 101, 412, 204, 999])
on_sale = [101, 412]

mask = np.isin(product_ids, on_sale)
print(mask)
print("sale items sold:", mask.sum())
print("everything else:", product_ids[~mask])
```

## Masks on 2-D arrays: selecting rows

On a 2-D array, `grid[grid > 5]` returns the matching values flattened to 1-D, because the matches don''t form a rectangle. Far more common in practice is building a mask from **one column** and using it to select **whole rows**:

```python run
# Columns: age, income (k$), region code
people = np.array([[23, 41, 1],
                   [35, 78, 2],
                   [47, 95, 1],
                   [29, 52, 3],
                   [61, 60, 2]])

over_30 = people[:, 0] > 30           # one True/False per ROW
print("mask:", over_30)
print(people[over_30])                # whole rows where age > 30
print("matching values only:", people[people > 50])
```

This is exactly how a pandas filter like `df[df["age"] > 30]` works under the hood.

```python exercise id=filter-rows title="Find the target customers"
# Columns: customer_id, age, region, spend
customers = np.array([[1, 25, 2, 120],
                      [2, 41, 5, 340],
                      [3, 33, 1,  80],
                      [4, 52, 2, 510],
                      [5, 29, 5, 260],
                      [6, 38, 3, 150],
                      [7, 45, 2,  95]])

# TODO: select the full ROWS of customers who are aged 30 or older
# AND live in region 2 or 5. Then collect their ids.
targets = ...       # 2-D array of matching rows (all 4 columns)
target_ids = ...    # 1-D array of their customer_id values
--- solution
customers = np.array([[1, 25, 2, 120],
                      [2, 41, 5, 340],
                      [3, 33, 1,  80],
                      [4, 52, 2, 510],
                      [5, 29, 5, 260],
                      [6, 38, 3, 150],
                      [7, 45, 2,  95]])

mask = (customers[:, 1] >= 30) & np.isin(customers[:, 2], [2, 5])
targets = customers[mask]
target_ids = targets[:, 0]
--- test
assert targets is not ..., "Replace the `...` after `targets =` with a row selection."
assert target_ids is not ..., "Replace the `...` after `target_ids =` with your code."
assert isinstance(targets, np.ndarray) and targets.ndim == 2, f"`targets` should be 2-D: whole rows of `customers`. Got {getattr(targets, ''shape'', type(targets).__name__)}. Build the mask from columns, then index rows."
assert targets.shape[1] == 4, f"`targets` should keep all 4 columns, but has shape {targets.shape}."
assert np.array_equal(np.asarray(target_ids), [2, 4, 7]), f"`target_ids` should be the ids of customers aged >= 30 in region 2 or 5. Got {np.asarray(target_ids)}."
assert np.array_equal(targets, customers[[1, 3, 6]]), "`targets` should contain the full rows for those customers."
--- hint
Age is column 1 and region is column 2. Slice a column with `customers[:, 1]` to get one value per row.
--- hint
Combine `(customers[:, 1] >= 30)` with `np.isin(customers[:, 2], [2, 5])` using `&`, then index rows with the result.
```

## Debug challenge: the precedence trap

```python debug id=precedence-trap title="Selecting the mid-priced items crashes"
prices = np.array([3.5, 12.0, 18.75, 22.0, 9.99, 15.5])

mid = prices[prices >= 10 & prices <= 20]
print("mid-priced:", mid)
--- solution
prices = np.array([3.5, 12.0, 18.75, 22.0, 9.99, 15.5])

mid = prices[(prices >= 10) & (prices <= 20)]
print("mid-priced:", mid)
--- test
assert np.allclose(mid, [12.0, 18.75, 15.5]), f"`mid` should be the prices from 10 to 20, got {mid}."
--- hint
Run it and read the error. Python evaluates `&` *before* the comparisons, so what is `10 & prices`?
--- hint
Wrap each comparison in its own parentheses so they''re evaluated first.
```

## Debug challenge: counting the wrong thing

```python debug id=count-not-sum title="Pass rate over 100%?"
scores = np.array([78, 45, 92, 60, 38, 85, 71, 55])

n_passed = scores[scores >= 60].sum()
pass_rate = n_passed / len(scores)
print("passed:", n_passed)
print(f"pass rate: {pass_rate:.0%}")
--- solution
scores = np.array([78, 45, 92, 60, 38, 85, 71, 55])

n_passed = (scores >= 60).sum()
pass_rate = n_passed / len(scores)
print("passed:", n_passed)
print(f"pass rate: {pass_rate:.0%}")
--- test
assert n_passed == 5, f"`n_passed` should be the number of students who passed (5), but it is {n_passed}. Are you adding up scores?"
assert np.isclose(pass_rate, 0.625), f"`pass_rate` should be 5/8 = 0.625, got {pass_rate}."
--- hint
Run it: a pass rate of 4600% is a big clue. What exactly is being summed?
--- hint
`scores[mask].sum()` adds the matching *scores*. To count matches, sum the *mask* itself.
```

## Recap

- Comparisons on arrays return **boolean masks**, one `True`/`False` per element.
- `a[mask]` filters (and returns a copy). `a[mask] = value` writes into the original.
- `mask.sum()` counts, `mask.mean()` gives a fraction, `.any()` / `.all()` reduce to one answer.
- Combine with `&`, `|`, `~`, and **always parenthesize** each comparison. Never use `and`/`or` on arrays.
- `np.isin(a, values)` tests membership; a mask built from one column selects whole rows.

**Up next:** fancy indexing, selecting elements by *position* with arrays of indices, and `np.where` for "if this, then that" across an entire array.
', 0, '[]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_numpy_3_4', 'sec_numpy_3', 'crs_numpy_mastery', 'Fancy indexing and np.where', 'interactive', 3, 960, NULL, NULL, 'Slices pick *regular* patterns: a range, every other element, the last ten. Masks pick elements that *match a condition*. But sometimes you know exactly **which positions** you want: rows 3, 17 and 42; the top-5 scores you just found; the color for each of 10,000 class labels. That''s **fancy indexing**: indexing with an *array of integers*.

You''ll also meet `np.where`, NumPy''s vectorized "if this, then that". Together they replace a huge category of loops, and they''re the core of lookup tables, sampling and label encoding in every ML codebase.

## Indexing with a list of positions

Pass a list (or array) of integers and NumPy returns the elements at those positions, **in the order you asked**. Repeats are allowed.

```python run
import numpy as np

letters = np.array(["a", "b", "c", "d", "e", "f"])

print(letters[[0, 3, 5]])        # pick positions
print(letters[[5, 4, 3]])        # any order you like
print(letters[[1, 1, 1, 0]])     # repeats are fine
print(letters[[-1, 0]])          # negative indices too
```

The result always has the **shape of the index array**. Index with a 2-D array of positions and you get a 2-D result:

```python run
values = np.array([10, 20, 30, 40, 50])
idx = np.array([[0, 1],
                [3, 4]])
values[idx]
```

```python predict id=predict-fancy title="What does this print?"
a = np.array([7, 3, 9, 1])
print(a[[2, 2, 0]] + a[[1, 3, 3]])
--- options
* [12 10  8]
[ 9  9  7]
[16  4 10]
[3 5 3]
--- explain
`a[[2, 2, 0]]` is `[9, 9, 7]` and `a[[1, 3, 3]]` is `[3, 1, 1]`. Adding them element-wise gives `[12, 10, 8]`. NumPy pads `8` with an extra space so every value has the width of the widest one (`12`).
```

## Rows and columns of a 2-D array

In 2-D, a list in the first position selects **rows**; a list after `:` selects **columns**.

```python run
scores = np.array([[88, 92, 79],
                   [65, 70, 81],
                   [95, 89, 91],
                   [72, 68, 77]])   # 4 students x 3 exams

print("students 0 and 2:\n", scores[[0, 2]])
print("exams 2 and 0, every student:\n", scores[:, [2, 0]])
```

### Pairs of index arrays select *points*, not a grid

Here''s the part that surprises everyone. When you pass index arrays for **two axes**, NumPy pairs them up element by element: `m[[r0, r1], [c0, c1]]` gives you `m[r0, c0]` and `m[r1, c1]`, **just two values**, not a 2x2 block.

```python run
m = np.arange(1, 17).reshape(4, 4)
print(m)
print("points (0,1) and (3,2):", m[[0, 3], [1, 2]])
print("the diagonal:          ", m[[0, 1, 2, 3], [0, 1, 2, 3]])
```

When you want the full **sub-grid** of the chosen rows × chosen columns, wrap them with `np.ix_`:

```python run
m = np.arange(1, 17).reshape(4, 4)
rows, cols = [0, 3], [1, 2]

print(m[np.ix_(rows, cols)])     # rows 0 and 3, crossed with columns 1 and 2
```

> **Tip:** Think of `m[rows, cols]` as "zip the two lists into coordinates", and `m[np.ix_(rows, cols)]` as "every combination of these rows and these columns".

```python exercise id=city-distances title="Distances between chosen cities"
cities = np.array(["Lisbon", "Madrid", "Paris", "Berlin", "Rome"])
# km between every pair of cities (symmetric)
dist = np.array([[   0,  503, 1453, 2311, 1861],
                 [ 503,    0, 1053, 1869, 1365],
                 [1453, 1053,    0,  878, 1106],
                 [2311, 1869,  878,    0, 1181],
                 [1861, 1365, 1106, 1181,    0]])

trip = [2, 3, 4]   # Paris, Berlin, Rome

# TODO (no loops):
trip_names = ...   # the names of the trip cities, in trip order
sub = ...          # 3x3 distances between the trip cities only
legs = ...         # 1-D: Paris→Berlin and Berlin→Rome distances, i.e. dist[2,3] and dist[3,4]
--- solution
cities = np.array(["Lisbon", "Madrid", "Paris", "Berlin", "Rome"])
dist = np.array([[   0,  503, 1453, 2311, 1861],
                 [ 503,    0, 1053, 1869, 1365],
                 [1453, 1053,    0,  878, 1106],
                 [2311, 1869,  878,    0, 1181],
                 [1861, 1365, 1106, 1181,    0]])

trip = [2, 3, 4]

trip_names = cities[trip]
sub = dist[np.ix_(trip, trip)]
legs = dist[trip[:-1], trip[1:]]
--- test
for n in ["trip_names", "sub", "legs"]:
    assert globals()[n] is not ..., f"Replace the `...` after `{n} =` with an indexing expression."
assert list(trip_names) == ["Paris", "Berlin", "Rome"], f"`trip_names` should be the names at the trip positions. Got {list(trip_names)}."
assert isinstance(sub, np.ndarray) and sub.shape == (3, 3), f"`sub` should be a 3x3 block, but has shape {getattr(sub, ''shape'', None)}. Pairing two lists gives points; you need every combination."
assert np.array_equal(sub, [[0, 878, 1106], [878, 0, 1181], [1106, 1181, 0]]), "`sub` should contain the distances among Paris, Berlin and Rome only."
assert np.array_equal(np.asarray(legs), [878, 1181]), f"`legs` should be [878, 1181]: two point lookups, (2,3) and (3,4). Got {np.asarray(legs)}."
--- hint
`cities[trip]` picks names. For the 3x3 block you want rows *crossed with* columns. Which helper builds that?
--- hint
`dist[np.ix_(trip, trip)]` gives the block. For `legs`, pair row indices `[2, 3]` with column indices `[3, 4]`.
```

## Fancy indexing makes copies, but assignment works

Like boolean masks, fancy indexing **gathers** values into new memory, so the result is a copy. Assigning *through* a fancy index in a single expression does write into the original:

```python run
stock = np.array([5, 0, 12, 0, 3])
picked = stock[[1, 3]]
picked[:] = 99                 # modifies the copy only
print("after editing copy:", stock)

stock[[1, 3]] = 20             # direct assignment writes through
print("after assignment:  ", stock)
```

> **Pitfall:** With **repeated** indices, `a[idx] += 1` adds only **once** per unique position: it reads all values, adds 1, then writes them back, and later writes overwrite earlier ones. To accumulate, use `np.add.at(a, idx, 1)`, or `np.bincount` for counting.

## Lookup tables: the ML superpower

Fancy indexing turns any array into a **lookup table**. If `palette` holds one row per class, then `palette[labels]` gives the row for *every* label at once, whatever shape `labels` has.

```python run
palette = np.array([[230,  57,  70],    # class 0: red
                    [ 69, 123, 157],    # class 1: blue
                    [ 42, 157, 143]])   # class 2: green
names = np.array(["cat", "dog", "bird"])

labels = np.array([2, 0, 0, 1, 2, 1])   # e.g. model predictions
print(names[labels])
print(palette[labels].shape)            # one RGB color per label
```

This is how segmentation masks get colored, how token ids become embeddings (`embedding_matrix[token_ids]`), and how predicted class indices become human-readable names.

```python exercise id=label-lookup title="Decode model predictions"
class_names = np.array(["negative", "neutral", "positive"])
class_weights = np.array([1.5, 1.0, 0.8])     # one weight per class

predictions = np.array([2, 2, 0, 1, 2, 0, 1, 2])

# TODO (no loops, no if-statements):
predicted_names = ...   # the class name for each prediction
sample_weights = ...    # the weight for each prediction
total_weight = ...      # the sum of sample_weights
--- solution
class_names = np.array(["negative", "neutral", "positive"])
class_weights = np.array([1.5, 1.0, 0.8])

predictions = np.array([2, 2, 0, 1, 2, 0, 1, 2])

predicted_names = class_names[predictions]
sample_weights = class_weights[predictions]
total_weight = sample_weights.sum()
--- test
for n in ["predicted_names", "sample_weights", "total_weight"]:
    assert globals()[n] is not ..., f"Replace the `...` after `{n} =` with your code."
assert isinstance(predicted_names, np.ndarray) and predicted_names.shape == (8,), "`predicted_names` should have one name per prediction (8 total). Index `class_names` with the predictions array."
assert list(predicted_names) == ["positive", "positive", "negative", "neutral", "positive", "negative", "neutral", "positive"], f"`predicted_names` don''t match the predictions. Got {list(predicted_names)}."
assert np.allclose(sample_weights, [0.8, 0.8, 1.5, 1.0, 0.8, 1.5, 1.0, 0.8]), f"`sample_weights` should be the class weight for each prediction. Got {sample_weights}."
assert np.isclose(total_weight, 8.2), f"`total_weight` should be the sum of the sample weights (8.2), got {total_weight!r}."
--- hint
The predictions are class *indices*, so they can index any array that has one entry per class.
--- hint
`class_names[predictions]` decodes all 8 at once. Do the same with `class_weights`.
```

## `np.where`: vectorized if/else

`np.where(condition, x, y)` builds a new array choosing, element by element, from `x` where the condition is true and from `y` where it''s false. `x` and `y` can be arrays or single values.

```python run
hours = np.array([38, 45, 40, 52, 30])
rate = 20.0

label = np.where(hours > 40, "overtime", "regular")
pay = np.where(hours > 40, 40 * rate + (hours - 40) * rate * 1.5, hours * rate)

print(label)
print(pay)
```

Unlike assigning through a mask, `np.where` **doesn''t modify anything**. It returns a fresh array, which makes it ideal inside functions.

### Finding positions: `np.where(cond)`, `np.nonzero`, `np.argwhere`

With only a condition, `np.where(cond)` returns **where** it''s true: a *tuple* of index arrays, one per axis (the same as `np.nonzero`). `np.argwhere` gives the same information as one `(row, col)` pair per match.

```python run
grid = np.array([[0, 7, 0],
                 [3, 0, 9]])

rows, cols = np.where(grid > 0)
print("rows:", rows, " cols:", cols)
print("values:", grid[rows, cols])
print("as coordinates:\n", np.argwhere(grid > 0))
```

```python predict id=predict-where title="What does np.where return?"
a = np.array([4, -2, 7, -5])
print(np.where(a < 0, 0, a))
--- options
[0 1 0 1]
[-2 -5]
* [4 0 7 0]
(array([1, 3]),)
--- explain
The three-argument form picks from `0` where `a < 0` and from `a` everywhere else, so negatives become 0. The one-argument form, `np.where(a < 0)`, would return positions instead: `(array([1, 3]),)`.
```

```python exercise id=where-discount title="Tiered discounts"
cart = np.array([15.0, 120.0, 49.99, 75.0, 250.0, 8.5])

# TODO (no loops):
# Items priced 100 or more get 20% off; everything else gets 5% off.
final = ...          # final price of each item, as an array
discounted = ...     # the POSITIONS (indices) of items priced 100 or more, as a 1-D array
--- solution
cart = np.array([15.0, 120.0, 49.99, 75.0, 250.0, 8.5])

final = np.where(cart >= 100, cart * 0.8, cart * 0.95)
discounted = np.where(cart >= 100)[0]
--- test
assert final is not ..., "Replace the `...` after `final =` with your code."
assert discounted is not ..., "Replace the `...` after `discounted =` with your code."
assert isinstance(final, np.ndarray) and final.shape == cart.shape, f"`final` should have one price per item, shape {cart.shape}."
assert np.allclose(final, [14.25, 96.0, 47.4905, 71.25, 200.0, 8.075]), f"`final` should apply 20% off for items >= 100 and 5% off for the rest. Got {final}."
d = np.asarray(discounted)
assert d.ndim == 1, f"`discounted` should be a 1-D array of indices. `np.where(cond)` returns a tuple, so take its first element. Got {discounted!r}."
assert d.tolist() == [1, 4], f"`discounted` should be the indices [1, 4], got {d.tolist()}."
--- hint
`np.where(cart >= 100, <price if true>, <price if false>)` does the whole cart at once.
--- hint
`np.where(condition)` with one argument returns a *tuple* like `(array([...]),)`. Grab element `[0]` for a 1-D array (or use `np.nonzero`).
```

## `np.take` and `np.put`

`np.take(a, idx)` is the function form of `a[idx]`, and `np.put(a, idx, values)` is the function form of `a[idx] = values` (on the *flattened* array). They''re handy when you want to choose the axis programmatically: `np.take(m, idx, axis=1)` selects columns.

```python run
m = np.arange(12).reshape(3, 4)
print(np.take(m, [0, 2], axis=1))     # same as m[:, [0, 2]]

flat = np.zeros(6, dtype=int)
np.put(flat, [1, 4], [7, 9])
print(flat)
```

## Debug challenge: points instead of a block

```python debug id=points-not-block title="The sub-matrix has the wrong shape"
# Correlation between 5 features. Extract the block for features 0, 2 and 4.
corr = np.array([[1.0, 0.2, 0.7, 0.1, 0.4],
                 [0.2, 1.0, 0.3, 0.8, 0.5],
                 [0.7, 0.3, 1.0, 0.2, 0.6],
                 [0.1, 0.8, 0.2, 1.0, 0.3],
                 [0.4, 0.5, 0.6, 0.3, 1.0]])

keep = [0, 2, 4]
block = corr[keep, keep]
print("block shape:", block.shape)
print(block)
--- solution
corr = np.array([[1.0, 0.2, 0.7, 0.1, 0.4],
                 [0.2, 1.0, 0.3, 0.8, 0.5],
                 [0.7, 0.3, 1.0, 0.2, 0.6],
                 [0.1, 0.8, 0.2, 1.0, 0.3],
                 [0.4, 0.5, 0.6, 0.3, 1.0]])

keep = [0, 2, 4]
block = corr[np.ix_(keep, keep)]
print("block shape:", block.shape)
print(block)
--- test
assert block.shape == (3, 3), f"`block` should be 3x3, but has shape {block.shape}. Two index lists are paired into points, not crossed into a grid."
assert np.allclose(block, [[1.0, 0.7, 0.4], [0.7, 1.0, 0.6], [0.4, 0.6, 1.0]]), "`block` should hold the correlations among features 0, 2 and 4."
--- hint
Run it: the "block" is just `[1. 1. 1.]`, the diagonal. Why only 3 values?
--- hint
`corr[keep, keep]` zips the lists into the points (0,0), (2,2), (4,4). You need every row × column combination.
```

## Debug challenge: a histogram that undercounts

```python debug id=undercount-labels title="Every class count is 0 or 1"
# Count how many times each class (0, 1 or 2) appears.
labels = np.array([0, 2, 1, 2, 2, 0, 1, 2, 0, 2])

counts = np.zeros(3, dtype=int)
counts[labels] += 1
print("counts:", counts, " total:", counts.sum(), "of", len(labels))
--- solution
labels = np.array([0, 2, 1, 2, 2, 0, 1, 2, 0, 2])

counts = np.zeros(3, dtype=int)
np.add.at(counts, labels, 1)
print("counts:", counts, " total:", counts.sum(), "of", len(labels))
--- test
assert np.array_equal(counts, [3, 2, 5]), f"`counts` should be [3, 2, 5], got {counts}. Repeated indices only get incremented once with `+=`."
assert counts.sum() == len(labels), "The counts should add up to the number of labels."
--- hint
Run it: the counts add up to 3, not 10. What happens when the same index appears several times in `counts[labels] += 1`?
--- hint
`+=` with fancy indexing reads, adds and writes once per unique position. `np.add.at(counts, labels, 1)` accumulates properly (and `np.bincount(labels)` also works).
```

## Recap

- **Fancy indexing** uses integer arrays: `a[[3, 0, 3]]` picks positions in any order, with repeats, and the result has the index array''s shape.
- In 2-D, `m[rows]` and `m[:, cols]` select rows and columns. `m[r, c]` **pairs** indices into points, and `m[np.ix_(r, c)]` takes the **grid**.
- Fancy indexing returns **copies**; assign in one expression. Use `np.add.at` when indices repeat.
- `table[labels]` turns any per-class array into a per-sample lookup.
- `np.where(cond, x, y)` is a vectorized if/else; `np.where(cond)`, `np.nonzero` and `np.argwhere` find positions.

**Up next:** reshaping, giving the same data a new shape, and understanding the memory order that makes it possible.
', 0, '[]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_3_5', 'sec_numpy_3', 'crs_numpy_mastery', 'Checkpoint: indexing & selection', 'quiz', 4, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"`grid` has shape (5, 8). What is the shape of `grid[2]` compared with `grid[2:3]`?","options":["(8,) and (8,)","(8,) and (1, 8)","(1, 8) and (8,)","(5,) and (1, 5)"],"answerIndex":1,"explanation":"An integer index removes the axis it selects, leaving shape (8,). A slice keeps the axis, even if it has length 1, so `grid[2:3]` is (1, 8)."},{"id":"q2","prompt":"You run `w = data[:100]` and then `w *= 2`. What happens to `data`?","options":["Nothing; `w` is an independent copy","Its first 100 elements are doubled, because a slice is a view","NumPy raises an error because views are read-only","All of `data` is doubled"],"answerIndex":1,"explanation":"Basic slicing returns a view that shares memory with `data`, and `*=` writes in place, so the first 100 elements of `data` change too. Use `data[:100].copy()` if you need independent data."},{"id":"q3","prompt":"Which of these produces a COPY of `a` rather than a view?","options":["a[::-1]","a.reshape(2, -1)","a[[0, 1, 2]]","a.T"],"answerIndex":2,"explanation":"Fancy indexing with a list of positions always gathers values into new memory. Slices (including negative steps), reshapes and transposes are views whenever possible."},{"id":"q4","prompt":"What is the correct way to select prices between 10 and 20 (inclusive)?","options":["prices[prices >= 10 and prices <= 20]","prices[prices >= 10 & prices <= 20]","prices[(prices >= 10) & (prices <= 20)]","prices[10 <= prices <= 20]"],"answerIndex":2,"explanation":"Use the element-wise `&`, and wrap each comparison in parentheses because `&` binds more tightly than `>=`. Python''s `and` (and chained comparisons, which use `and` internally) need a single True/False and raise a ValueError on arrays."},{"id":"q5","prompt":"`m = np.arange(16).reshape(4, 4)`. What does `m[[0, 2], [1, 3]]` return?","options":["A 2x2 block of rows 0 and 2 crossed with columns 1 and 3","Two values: m[0, 1] and m[2, 3]","Rows 0 and 2 only","An IndexError, because you can''t pass two lists"],"answerIndex":1,"explanation":"Two index arrays are paired element by element into coordinates (0, 1) and (2, 3), giving `[1, 11]`. To get the 2x2 block of every combination, use `m[np.ix_([0, 2], [1, 3])]`."},{"id":"q6","prompt":"`labels = np.array([0, 2, 2, 1])` and `counts = np.zeros(3)`. After `counts[labels] += 1`, what is `counts`?","options":["[1. 1. 2.]","[1. 1. 1.]","[0. 1. 2.]","[1. 2. 1.]"],"answerIndex":1,"explanation":"With fancy indexing, `+=` reads the selected values once, adds 1, and writes them back, so the repeated index 2 is only incremented once. Use `np.add.at(counts, labels, 1)` or `np.bincount(labels)` to accumulate repeats correctly."}]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_4_1', 'sec_numpy_4', 'crs_numpy_mastery', 'reshape, ravel and memory order', 'interactive', 0, 840, NULL, NULL, 'Data rarely arrives in the shape you need. A sensor streams one long list of readings; an image comes off the network as a flat buffer of bytes; a model wants its input as `(batch, features)`. Reshaping is how you get from the shape you **have** to the shape you **need**, usually without copying a single byte.

In this lesson you''ll master `reshape` (including the handy `-1`), learn how NumPy decides which element goes where, and see why `ravel`, `flatten` and `.T` behave differently in ways that cause real bugs.

## Same data, new shape

`reshape` gives you a new **view** of the same numbers, arranged into a different shape. The elements keep their order: NumPy simply re-reads them into rows of a new length.

```python run
import numpy as np

a = np.arange(12)
print("original:", a)
print()
print("reshape(3, 4):")
print(a.reshape(3, 4))
print()
print("reshape(2, 6):")
print(a.reshape(2, 6))
```

You can go to any number of dimensions, as long as the **total number of elements stays the same**. Here 2 × 3 × 2 = 12:

```python run
a.reshape(2, 3, 2)
```

Ask for a shape that holds a different number of elements and NumPy refuses:

```python run error
np.arange(12).reshape(5, 3)
```

> **Tip:** before reshaping, multiply the new dimensions in your head and compare with `.size`. 5 × 3 = 15 ≠ 12.

## Let NumPy do the math with `-1`

Often you know every dimension except one. Pass `-1` for that one and NumPy works it out from the size:

```python run
readings = np.arange(24)

print(readings.reshape(4, -1).shape)    # 4 rows -> 6 columns
print(readings.reshape(-1, 8).shape)    # 8 columns -> 3 rows
print(readings.reshape(-1).shape)       # flatten to 1-D
print(readings.reshape(2, -1, 3).shape) # 2 x ? x 3 -> ? = 4
```

You can use `-1` only **once** per reshape, and the remaining dimensions must divide the size evenly.

```python predict id=predict-minus-one title="What shape does this print?"
a = np.arange(24)
print(a.reshape(2, -1, 4).shape)
--- options
(2, 12, 4)
* (2, 3, 4)
(2, -1, 4)
(2, 4, 3)
--- explain
24 elements split as 2 × ? × 4 means ? = 24 / (2 × 4) = **3**. The `-1` is replaced by the computed size, and the other dimensions stay where you put them: `(2, 3, 4)`.
```

```python exercise id=hourly-by-day title="Reshape a stream of hourly readings"
# 72 hourly temperature readings: three days, back to back.
stream = np.round(15 + 8 * np.sin(np.arange(72) * 2 * np.pi / 24), 1)

# 1. `by_day`: reshape `stream` so each ROW is one day of 24 hours.
#    Use -1 so it would still work for any number of whole days.
# 2. `day3`: the readings of the third day (a 1-D array of 24 values).
by_day = ...
day3 = ...
--- solution
stream = np.round(15 + 8 * np.sin(np.arange(72) * 2 * np.pi / 24), 1)

by_day = stream.reshape(-1, 24)
day3 = by_day[2]
--- test
assert by_day is not ..., "Replace the `...` after `by_day =`."
assert isinstance(by_day, np.ndarray), "`by_day` should be a NumPy array."
assert by_day.shape == (3, 24), f"`by_day` should have one row per day: shape (3, 24). Yours is {by_day.shape}."
assert np.array_equal(by_day[1], stream[24:48]), "Row 1 should hold hours 24–47 of the stream (the second day)."
assert day3 is not ..., "Replace the `...` after `day3 =`."
assert np.shape(day3) == (24,), f"`day3` should be a 1-D array of 24 readings, but its shape is {np.shape(day3)}."
assert np.array_equal(day3, stream[48:]), "`day3` should be the last 24 readings, the third day (row index 2)."
--- hint
Each row should have 24 values; let NumPy compute the number of rows: `stream.reshape(-1, 24)`.
--- hint
Rows are numbered from 0, so the third day is row `2`.
```

## Which element goes where? Memory order

When NumPy reshapes, it reads the elements in order and fills the new shape **row by row**: the last axis changes fastest. This is called **C order** (after the C language), and it''s the default.

You can also ask for **Fortran order** (`order="F"`), which fills **column by column**: the first axis changes fastest.

```python run
a = np.arange(1, 7)

print("C order (row by row):")
print(a.reshape(2, 3, order="C"))
print()
print("F order (column by column):")
print(a.reshape(2, 3, order="F"))
```

Think of it as reading a book: C order reads across each line, then moves down; F order reads down each column, then moves right.

> **In the wild:** MATLAB, Fortran, R and many scientific file formats store matrices column by column. When you load raw numbers from those tools, `order="F"` puts them back where they belong.

```python exercise id=column-major-import title="Import a column-major matrix"
# A MATLAB export stored this 3x4 matrix COLUMN BY COLUMN:
#   [[ 1,  2,  3,  4],
#    [ 5,  6,  7,  8],
#    [ 9, 10, 11, 12]]
raw = np.array([1, 5, 9, 2, 6, 10, 3, 7, 11, 4, 8, 12])

# Rebuild the matrix as `m`, shape (3, 4), with a single reshape call.
m = ...
--- solution
raw = np.array([1, 5, 9, 2, 6, 10, 3, 7, 11, 4, 8, 12])

m = raw.reshape(3, 4, order="F")
--- test
assert m is not ..., "Replace the `...` with a reshape of `raw`."
assert isinstance(m, np.ndarray), "`m` should be a NumPy array."
assert m.shape == (3, 4), f"`m` should have shape (3, 4), but it has {m.shape}."
expected = np.arange(1, 13).reshape(3, 4)
assert not np.array_equal(m, raw.reshape(3, 4)), "That''s the default C (row-by-row) order, which scrambles this data. The raw values were stored column by column."
assert np.array_equal(m, expected), "The first row should read 1, 2, 3, 4. Check the `order` you used."
--- hint
The default reshape fills row by row. This data was written column by column.
--- hint
`reshape` takes an `order=` argument: `"C"` for row by row, `"F"` for column by column.
```

## Reshape returns a view, not a copy

A reshaped array usually **shares memory** with the original. No data is copied: NumPy just records a new shape for the same buffer. That makes reshape essentially free, but it also means a change through one name is visible through the other:

```python run
a = np.zeros(6)
grid = a.reshape(2, 3)

grid[0, 0] = 99
print("grid:\n", grid)
print("a:", a)
print("share memory?", np.shares_memory(a, grid))
```

```python predict id=predict-reshape-view title="What does this print?"
a = np.zeros(4)
r = a.reshape(2, 2)
r[1, 1] = 5
print(a[3])
--- options
0.0
* 5.0
5
IndexError
--- explain
`r` is a **view** of `a`''s memory. `r[1, 1]` is the 4th element in row-major order, which is `a[3]`. Writing through the view changes `a`, and since `a` is float64 it prints `5.0`.
```

> **Under the hood:** reshape can return a view only when the new shape can be described as a fixed step through the existing memory. For a freshly created array that''s always true. For some already-transposed or sliced arrays it isn''t, and NumPy quietly makes a copy. You''ll dig into *strides*, the mechanism behind this, in the performance lesson.

## Flattening: `ravel` vs `flatten`

Both turn any array into 1-D. The difference is exactly the view/copy question:

| | Returns | Memory |
|---|---|---|
| `a.ravel()` | a **view** whenever possible | shares memory, fast |
| `a.flatten()` | **always a new copy** | independent, safe to modify |
| `a.reshape(-1)` | same as `ravel` | view when possible |

```python run
grid = np.arange(6).reshape(2, 3)

r = grid.ravel()
f = grid.flatten()

r[0] = -1     # writes through to grid
f[1] = -2     # does not
print(grid)
print("ravel shares memory:  ", np.shares_memory(grid, r))
print("flatten shares memory:", np.shares_memory(grid, f))
```

Rule of thumb: use `ravel()` (or `reshape(-1)`) when you only **read** the flat data; use `flatten()` when you''re going to **modify** it and the original must stay intact.

```python debug id=ravel-mutation-bug title="The image changed behind my back"
image = np.array([[10.0, 20.0],
                  [30.0, 40.0]])

# Make a normalized 1-D version for a histogram (values 0..1).
# `image` itself must keep its original pixel values!
pixels = image.ravel()
pixels /= pixels.max()

print("pixels:", pixels)
print("image: ", image.tolist())
--- solution
image = np.array([[10.0, 20.0],
                  [30.0, 40.0]])

pixels = image.flatten()
pixels /= pixels.max()

print("pixels:", pixels)
print("image: ", image.tolist())
--- test
assert np.array_equal(image, [[10.0, 20.0], [30.0, 40.0]]), f"`image` was modified. It should still be [[10, 20], [30, 40]], but it is {image.tolist()}."
assert np.allclose(pixels, [0.25, 0.5, 0.75, 1.0]), "`pixels` should be the flattened image divided by its maximum."
assert not np.shares_memory(image, pixels), "`pixels` still shares memory with `image`."
--- hint
Run it and compare `image` before and after. Which line connects `pixels` to `image`''s memory?
--- hint
`ravel()` returns a view, and `/=` modifies in place, through the view. You need a flattening method that always copies.
```

## `reshape` is not transpose

Here''s one of the most common shape bugs in real code. Transposing with `.T` (which you''ll study properly in the next lesson) **swaps rows and columns**: row *i* becomes column *i*. Reshaping to the swapped shape does **not** do that. It just re-reads the same elements in order:

```python run
scores = np.array([[90, 80, 70],
                   [60, 50, 40]])   # 2 students x 3 subjects

print("scores.T  (correct: 3 subjects x 2 students):")
print(scores.T)
print()
print("scores.reshape(3, 2)  (same shape, scrambled data):")
print(scores.reshape(3, 2))
```

Both results have shape `(3, 2)`, so shape checks won''t save you. Only the values reveal the bug.

```python debug id=reshape-vs-transpose-bug title="Subjects got mixed up"
# Rows are students, columns are subjects (math, physics, chemistry).
grades = np.array([[95, 82, 74],
                   [61, 88, 90],
                   [78, 70, 85],
                   [84, 93, 66]])

# We need one ROW PER SUBJECT (each row = all 4 students'' grades for that subject).
by_subject = grades.reshape(3, 4)
math = by_subject[0]
print("math grades:", math)
--- solution
grades = np.array([[95, 82, 74],
                   [61, 88, 90],
                   [78, 70, 85],
                   [84, 93, 66]])

by_subject = grades.T
math = by_subject[0]
print("math grades:", math)
--- test
assert by_subject.shape == (3, 4), f"`by_subject` should have shape (3, 4), but it has {by_subject.shape}."
assert np.array_equal(math, [95, 61, 78, 84]), f"Math grades should be the first column of `grades`: [95, 61, 78, 84]. You have {np.asarray(math).tolist()}."
assert np.array_equal(by_subject, np.array([[95, 82, 74], [61, 88, 90], [78, 70, 85], [84, 93, 66]]).T), "Every row of `by_subject` should be one column of `grades`."
--- hint
Compare `math` with the first *column* of `grades`. Which numbers ended up in the first row?
--- hint
`reshape(3, 4)` re-reads elements row by row; it doesn''t move columns into rows. Swapping axes is a transpose: `.T`.
```

## `np.resize`: when sizes don''t match on purpose

`reshape` insists on the same number of elements. `np.resize` doesn''t: it **repeats** the data to fill a larger shape, or truncates it for a smaller one. It''s occasionally handy for tiling a pattern, but it''s rarely what you want for real data. A reshape mistake that "works" with `resize` is still a mistake.

```python run
pattern = np.array([1, 2, 3])
print(np.resize(pattern, (3, 4)))
print(np.resize(pattern, 2))
```

```python exercise id=batch-samples title="Prepare mini-batches for a model"
# 40 samples, each with 3 features, arrive as one flat array of 120 numbers:
# sample 0 is flat[0:3], sample 1 is flat[3:6], and so on.
flat = np.linspace(0, 1, 120)

# 1. `X`: one row per sample, one column per feature (use -1 for the rows).
# 2. `batches`: `X` split into mini-batches of 8 samples each,
#    shape (number_of_batches, 8, 3). Use -1 again.
X = ...
batches = ...
--- solution
flat = np.linspace(0, 1, 120)

X = flat.reshape(-1, 3)
batches = X.reshape(-1, 8, 3)
--- test
assert X is not ... and batches is not ..., "Replace both `...` placeholders."
assert isinstance(X, np.ndarray) and isinstance(batches, np.ndarray), "`X` and `batches` should be NumPy arrays."
assert X.shape == (40, 3), f"`X` should have shape (40, 3): 40 samples × 3 features. Yours is {X.shape}."
assert np.array_equal(X[1], flat[3:6]), "Each row of `X` should be one sample: X[1] should equal flat[3:6]."
assert batches.shape == (5, 8, 3), f"`batches` should have shape (5, 8, 3): 5 batches of 8 samples × 3 features. Yours is {batches.shape}."
assert np.array_equal(batches[1, 0], X[8]), "The first sample of batch 1 should be sample 8 (X[8])."
--- hint
Each row of `X` has 3 values, so `flat.reshape(-1, 3)`.
--- hint
For `batches`, the last two dimensions are fixed: `(?, 8, 3)`. Let `-1` compute the number of batches.
```

## Recap

- `reshape` rearranges the same elements into a new shape; the total size must not change.
- Use `-1` (once) to let NumPy infer one dimension from the size.
- Reshape fills **row by row** (C order) by default; `order="F"` fills column by column for data from MATLAB/Fortran.
- Reshaped arrays and `ravel()` are usually **views** sharing memory; `flatten()` always copies.
- `reshape` to the swapped shape is **not** a transpose. Use `.T` to turn rows into columns.
- `np.resize` repeats or truncates data to fit; it''s rarely what you want.

**Up next:** adding, removing and swapping axes with `np.newaxis`, `squeeze`, `transpose` and `moveaxis`.
', 0, '[]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_4_2', 'sec_numpy_4', 'crs_numpy_mastery', 'Adding, removing and swapping axes', 'interactive', 1, 840, NULL, NULL, 'Three numbers can be a lot of different things. `[1, 2, 3]` might be a flat list of values, a **row** in a table, a **column** in a table, or a **batch** containing a single sample. The numbers are identical; only the *axes* differ. And when you combine arrays, or hand one to a library like scikit-learn or PyTorch, those axes decide whether your code works, crashes, or, worst of all, silently computes the wrong thing.

This lesson gives you precise control over axes: adding them with `np.newaxis` and `expand_dims`, removing them with `squeeze`, and reordering them with `transpose`, `swapaxes` and `moveaxis`.

## Rows, columns and plain 1-D arrays

A 1-D array has one axis. It''s neither a row nor a column, just a sequence. To make it a row or a column, you give it a second axis of length 1:

```python run
import numpy as np

v = np.array([1, 2, 3])
row = v.reshape(1, 3)
col = v.reshape(3, 1)

print("v   shape:", v.shape)
print("row shape:", row.shape)
print(row)
print("col shape:", col.shape)
print(col)
```

| Shape | Name | Looks like |
|---|---|---|
| `(3,)` | 1-D array | `[1 2 3]` |
| `(1, 3)` | row vector | `[[1 2 3]]` |
| `(3, 1)` | column vector | `[[1] [2] [3]]` |

## Adding an axis with `np.newaxis`

Reshape works, but you have to spell out every dimension. The idiomatic way to add a length-1 axis is to index with **`np.newaxis`**, which is simply an alias for `None`, at the position where the new axis should go:

```python run
v = np.array([1, 2, 3])

print(v[np.newaxis, :].shape)   # new axis in front -> row    (1, 3)
print(v[:, np.newaxis].shape)   # new axis at the end -> column (3, 1)
print(v[:, None].shape)         # None means exactly the same thing
print(v[None, :, None].shape)   # as many as you like          (1, 3, 1)
```

Read `v[:, np.newaxis]` as "keep the existing axis (`:`), then add a new one". It''s a **view**: no data is copied.

Why does this matter? Because column vectors let you combine arrays in two directions at once. Multiplying a `(3, 1)` column by a `(4,)` row stretches both into a `(3, 4)` table. This is **broadcasting**, and it gets its own lesson soon. For now, just see what an extra axis can do:

```python run
quantities = np.array([1, 2, 5])            # 3 order sizes
unit_prices = np.array([9.5, 12.0, 3.25, 7.0])  # 4 products

totals = quantities[:, np.newaxis] * unit_prices
print("shape:", totals.shape)
print(totals)
```

Row *i*, column *j* holds `quantities[i] * unit_prices[j]`: a complete price table in one line.

```python exercise id=price-table title="Build a discount table"
prices = np.array([20.0, 35.0, 50.0, 80.0])   # 4 products
discounts = np.array([0.0, 0.1, 0.25])        # 3 discount levels

# 1. `price_col`: `prices` as a COLUMN vector, shape (4, 1).
# 2. `table`: the discounted price of every product at every level,
#    shape (4, 3), where table[i, j] = prices[i] * (1 - discounts[j]).
price_col = ...
table = ...
--- solution
prices = np.array([20.0, 35.0, 50.0, 80.0])
discounts = np.array([0.0, 0.1, 0.25])

price_col = prices[:, np.newaxis]
table = price_col * (1 - discounts)
--- test
assert price_col is not ..., "Replace the `...` after `price_col =`."
assert np.shape(price_col) == (4, 1), f"`price_col` should be a column vector with shape (4, 1), but it has shape {np.shape(price_col)}."
assert table is not ..., "Replace the `...` after `table =`."
assert np.shape(table) == (4, 3), f"`table` should have one row per product and one column per discount: (4, 3). Yours is {np.shape(table)}."
expected = prices[:, None] * (1 - discounts)
assert np.allclose(table[:, 0], prices), "Column 0 (no discount) should equal the original prices."
assert np.allclose(table, expected), "Check the formula: price × (1 − discount). For example table[3, 2] should be 60.0."
--- hint
`prices[:, np.newaxis]` turns the 4 prices into a column.
--- hint
Multiply the column by `(1 - discounts)`, a 1-D array of 3 factors. NumPy stretches the result into a 4 × 3 table.
```

## `np.expand_dims`: the named version

`np.expand_dims(a, axis)` does the same thing as `np.newaxis`, but you say *which position* the new axis should take. That''s often clearer in functions, especially with negative axes:

```python run
image = np.zeros((28, 28))        # one grayscale image

print(np.expand_dims(image, axis=0).shape)    # (1, 28, 28)   batch of one
print(np.expand_dims(image, axis=-1).shape)   # (28, 28, 1)   add a channel axis
print(np.expand_dims(image, axis=(0, -1)).shape)  # (1, 28, 28, 1) both at once
```

> **In the wild:** deep-learning models almost always expect a **batch** axis first. Passing a single image of shape `(28, 28)` to a model that wants `(batch, height, width, channels)` is the classic "expected 4 dimensions, got 2" error. `expand_dims` is the fix.

```python exercise id=batch-of-one title="Prepare a single image for a model"
rng = np.random.default_rng(7)
digit = rng.random((28, 28))      # one 28x28 grayscale image

# The model expects input shaped (batch, height, width, channels).
# Create `model_input` with shape (1, 28, 28, 1) from `digit`, without copying data
# by hand. Use np.expand_dims or np.newaxis.
model_input = ...
--- solution
rng = np.random.default_rng(7)
digit = rng.random((28, 28))

model_input = np.expand_dims(digit, axis=(0, -1))
--- test
assert model_input is not ..., "Replace the `...` with your code."
assert isinstance(model_input, np.ndarray), "`model_input` should be a NumPy array."
assert model_input.shape == (1, 28, 28, 1), f"`model_input` should have shape (1, 28, 28, 1), but it has {model_input.shape}."
assert np.array_equal(model_input[0, :, :, 0], digit), "The image data should be unchanged. Only add axes; don''t reshape or reorder the pixels."
--- hint
You need two new axes: one at the front (batch) and one at the end (channels).
--- hint
`np.expand_dims(digit, axis=(0, -1))` adds both at once, or index with `digit[np.newaxis, :, :, np.newaxis]`.
```

## Removing axes with `squeeze`

`squeeze` does the opposite: it **removes axes of length 1**. Without arguments it removes all of them; with `axis=` it removes only the one you name.

```python run
x = np.zeros((1, 3, 1, 4))

print("squeeze():       ", x.squeeze().shape)
print("squeeze(axis=0): ", x.squeeze(axis=0).shape)
print("squeeze(axis=2): ", x.squeeze(axis=2).shape)
```

You can only squeeze an axis whose length is 1. Anything else is an error, because it would throw data away:

```python run error
np.zeros((1, 3)).squeeze(axis=1)
```

```python predict id=predict-squeeze title="What does this print?"
x = np.zeros((1, 3, 1, 2))
print(x.squeeze().shape)
--- options
(1, 3, 1, 2)
* (3, 2)
(3, 1, 2)
(6,)
--- explain
`squeeze()` with no axis removes **every** axis of length 1, here the first and the third, leaving `(3, 2)`. It never merges or reorders axes, so it can''t produce `(6,)`.
```

> **Pitfall:** a bare `squeeze()` is dangerous when a dimension *happens* to be 1. A batch with one sample loses its batch axis too. In library code, prefer `squeeze(axis=...)` so only the axis you mean disappears.

```python debug id=squeeze-batch-bug title="It works until the batch has one sample"
def scores_1d(model_output):
    """model_output has shape (batch, 1). Return a 1-D array of shape (batch,)."""
    scores = model_output.squeeze()
    print("got", len(scores), "scores")
    return scores

scores_1d(np.array([[0.9], [0.2], [0.7]]))   # fine: batch of 3
scores_1d(np.array([[0.4]]))                 # batch of 1
--- solution
def scores_1d(model_output):
    """model_output has shape (batch, 1). Return a 1-D array of shape (batch,)."""
    scores = model_output.squeeze(axis=1)
    print("got", len(scores), "scores")
    return scores

scores_1d(np.array([[0.9], [0.2], [0.7]]))
scores_1d(np.array([[0.4]]))
--- test
r3 = scores_1d(np.array([[0.9], [0.2], [0.7]]))
assert np.shape(r3) == (3,), f"For a batch of 3, expected shape (3,), got {np.shape(r3)}."
r1 = scores_1d(np.array([[0.4]]))
assert np.shape(r1) == (1,), f"For a batch of 1, expected shape (1,), but got {np.shape(r1)}. The batch axis was squeezed away."
assert np.allclose(r1, [0.4]), "The single score should be 0.4."
--- hint
Run it. The batch of 3 works; the batch of 1 crashes. What shape does `squeeze()` produce for an array of shape `(1, 1)`?
--- hint
`squeeze()` removed **both** length-1 axes, including the batch axis. Only remove the feature axis: `squeeze(axis=1)` (or `model_output[:, 0]`).
```

## Reordering axes: `transpose`

For a 2-D array, `.T` swaps rows and columns. In general, `.T` **reverses the order of all axes**, and `transpose(*axes)` lets you choose any order. Each number says which old axis goes in that position:

```python run
a = np.zeros((2, 3, 4))

print(".T:                 ", a.T.shape)                    # reversed
print("transpose(1, 0, 2): ", a.transpose(1, 0, 2).shape)  # swap first two
print("transpose(0, 2, 1): ", a.transpose(0, 2, 1).shape)  # swap last two
```

Read `transpose(1, 0, 2)` as: *new axis 0 is old axis 1, new axis 1 is old axis 0, new axis 2 is old axis 2.*

```python predict id=predict-transpose title="What does this print?"
a = np.zeros((5, 6, 7))
print(a.transpose(2, 0, 1).shape)
--- options
(6, 7, 5)
* (7, 5, 6)
(7, 6, 5)
(5, 7, 6)
--- explain
New position 0 takes old axis **2** (size 7), position 1 takes old axis **0** (size 5), and position 2 takes old axis **1** (size 6): `(7, 5, 6)`.
```

Like reshape, transposing is free: it returns a **view** with the axes relabeled, and no data moves.

## `swapaxes` and `moveaxis`

Writing out a full permutation is error-prone for arrays with many axes. Two helpers cover the common cases:

- `np.swapaxes(a, i, j)` swaps two axes and leaves the rest alone.
- `np.moveaxis(a, source, destination)` moves one axis to a new position and shifts the others along.

The most famous use is converting image batches between the two conventions used by deep-learning libraries:

```python run
batch = np.zeros((8, 32, 32, 3))   # (N, H, W, C)  channels-last: TensorFlow, PIL, matplotlib

nchw_a = batch.transpose(0, 3, 1, 2)      # explicit permutation
nchw_b = np.moveaxis(batch, -1, 1)        # "move channels to position 1"
swapped = np.swapaxes(batch, 1, 2)        # swap height and width

print("transpose:", nchw_a.shape)
print("moveaxis: ", nchw_b.shape)
print("swapaxes: ", swapped.shape)
```

> **In the wild:** PyTorch wants images as `(N, C, H, W)` (channels first). TensorFlow, PIL and matplotlib use `(N, H, W, C)` (channels last). `np.moveaxis(batch, -1, 1)` and back with `np.moveaxis(batch, 1, -1)` is a line you''ll write many times.

```python exercise id=channels-first title="Convert a batch for PyTorch"
rng = np.random.default_rng(42)
batch = rng.random((16, 24, 24, 3))   # (N, H, W, C)

# Create `chw`: the same batch in (N, C, H, W) order.
# Every value must stay attached to the same image, row, column and channel.
chw = ...
--- solution
rng = np.random.default_rng(42)
batch = rng.random((16, 24, 24, 3))

chw = np.moveaxis(batch, -1, 1)
--- test
assert chw is not ..., "Replace the `...` with your code."
assert isinstance(chw, np.ndarray), "`chw` should be a NumPy array."
assert chw.shape == (16, 3, 24, 24), f"`chw` should have shape (16, 3, 24, 24), but it has {chw.shape}."
assert np.array_equal(chw[5, 2], batch[5, :, :, 2]), "The channel-2 plane of image 5 doesn''t match. Did you reshape instead of reordering axes?"
assert np.array_equal(chw[0, :, 3, 7], batch[0, 3, 7, :]), "The pixel at row 3, column 7 of image 0 should keep its 3 channel values."
--- hint
Reshape would scramble the pixels. You need to *reorder* axes: move the last axis (channels) to position 1.
--- hint
`np.moveaxis(batch, -1, 1)` or `batch.transpose(0, 3, 1, 2)`.
```

```python debug id=row-weights-bug title="Weight each row"
# Each ROW of `matrix` belongs to one sensor; scale row i by weights[i].
matrix = np.array([[1.0, 2.0, 3.0, 4.0],
                   [1.0, 1.0, 1.0, 1.0],
                   [2.0, 0.0, 2.0, 0.0]])
weights = np.array([10.0, 0.5, 3.0])

scaled = matrix * weights[np.newaxis, :]
print(scaled)
--- solution
matrix = np.array([[1.0, 2.0, 3.0, 4.0],
                   [1.0, 1.0, 1.0, 1.0],
                   [2.0, 0.0, 2.0, 0.0]])
weights = np.array([10.0, 0.5, 3.0])

scaled = matrix * weights[:, np.newaxis]
print(scaled)
--- test
assert np.shape(scaled) == (3, 4), f"`scaled` should keep the matrix''s shape (3, 4), got {np.shape(scaled)}."
assert np.allclose(scaled[0], [10, 20, 30, 40]), "Row 0 should be multiplied by 10."
assert np.allclose(scaled[1], [0.5, 0.5, 0.5, 0.5]), "Row 1 should be multiplied by 0.5."
assert np.allclose(scaled[2], [6, 0, 6, 0]), "Row 2 should be multiplied by 3."
--- hint
Read the error: the shapes are `(3, 4)` and `(1, 3)`. Should `weights` be a row or a column here?
--- hint
One weight per **row** means the weights must run down a column: shape `(3, 1)`. Put the new axis *after* the existing one.
```

## Recap

- A 1-D array `(n,)` is neither a row `(1, n)` nor a column `(n, 1)`; adding a length-1 axis makes it one.
- `a[np.newaxis, :]`, `a[:, None]` and `np.expand_dims(a, axis)` add axes as free views.
- `squeeze()` removes length-1 axes. Pass `axis=` so a batch of one doesn''t lose its batch axis.
- `.T` reverses all axes; `transpose(order)` picks any order; `swapaxes` and `moveaxis` handle common moves.
- Channels-last `(N, H, W, C)` ↔ channels-first `(N, C, H, W)` is a `moveaxis`, never a `reshape`.

**Up next:** joining arrays with `concatenate` and `stack`, and splitting them apart again.
', 0, '[]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_4_3', 'sec_numpy_4', 'crs_numpy_mastery', 'Joining and splitting arrays', 'interactive', 2, 840, NULL, NULL, 'Real data arrives in pieces: one file per month, one array per sensor, one batch at a time from a data loader. And before you train a model, you cut a dataset into training, validation and test pieces. Joining and splitting arrays is everyday NumPy work, and the functions involved differ in one crucial way: **do they join along an existing axis, or create a new one?**

By the end of this lesson you''ll pick the right tool among `concatenate`, `stack`, `vstack`, `hstack` and `column_stack` without guessing, split arrays cleanly, and recognize the shape errors these functions throw.

## `concatenate`: join along an existing axis

`np.concatenate` takes a **list** of arrays and glues them end to end along one axis. For 1-D arrays there''s only one axis, so the result is simply longer:

```python run
import numpy as np

week1 = np.array([5, 8, 6])
week2 = np.array([7, 9])
week3 = np.array([4, 6, 8, 3])

np.concatenate([week1, week2, week3])
```

With 2-D arrays you choose the axis. `axis=0` (the default) stacks **more rows** underneath; `axis=1` adds **more columns** to the right:

```python run
a = np.array([[1, 2, 3],
              [4, 5, 6]])
b = np.array([[7, 8, 9],
              [10, 11, 12]])

print("axis=0 ->", np.concatenate([a, b], axis=0).shape)
print(np.concatenate([a, b], axis=0))
print()
print("axis=1 ->", np.concatenate([a, b], axis=1).shape)
print(np.concatenate([a, b], axis=1))
```

The rule: every array must have the **same number of dimensions**, and the **same size on every axis except the one you join along**. Adding rows of a different width fails:

```python run error
table = np.zeros((2, 3))
wide_rows = np.ones((2, 4))

np.concatenate([table, wide_rows], axis=0)
```

The message tells you exactly what went wrong: along dimension 1 (columns), one array has size 3 and the other has size 4. Joining along `axis=1` would work here, because then only the row counts must match.

```python predict id=predict-concatenate title="What does this print?"
a = np.zeros((2, 3))
b = np.ones((4, 3))
print(np.concatenate([a, b]).shape)
--- options
(6, 6)
* (6, 3)
(2, 7)
(2, 3)
--- explain
The default is `axis=0`, so the rows add up: 2 + 4 = **6** rows. The other axis (3 columns) must match, and it does, so it stays `3`: `(6, 3)`.
```

## `stack`: join along a new axis

`np.stack` works differently: all inputs must have **exactly the same shape**, and the result gains a **new** axis that indexes which input each slice came from.

```python run
red = np.full((2, 2), 255)
green = np.full((2, 2), 128)
blue = np.zeros((2, 2), dtype=int)

print("stack axis=0: ", np.stack([red, green, blue]).shape)           # (3, 2, 2) channels first
print("stack axis=-1:", np.stack([red, green, blue], axis=-1).shape)  # (2, 2, 3) channels last
print("concatenate:  ", np.concatenate([red, green, blue]).shape)    # (6, 2): no new axis
```

Use **concatenate** to make an axis *longer*. Use **stack** to make *more axes*: turning a list of same-shaped samples into a batch, or separate channels into one image.

```python predict id=predict-stack title="What does this print?"
x = np.zeros(3)
y = np.ones(3)
print(np.stack([x, y], axis=1).shape)
--- options
(2, 3)
* (3, 2)
(6,)
(3, 1, 2)
--- explain
Stacking two arrays of shape `(3,)` creates a new axis of size **2**. With `axis=1` the new axis goes *second*, giving `(3, 2)`: each row pairs `x[i]` with `y[i]`. With the default `axis=0` it would be `(2, 3)`.
```

```python debug id=stack-instead-of-concat-bug title="Two days of readings, one long series"
# Hourly readings from two consecutive days.
day1 = np.linspace(10, 20, 24)
day2 = np.linspace(20, 12, 24)

# We want ONE continuous series of 48 hourly readings.
series = np.stack([day1, day2])
print("shape:", series.shape)
print("hour 30:", series[30])
--- solution
day1 = np.linspace(10, 20, 24)
day2 = np.linspace(20, 12, 24)

series = np.concatenate([day1, day2])
print("shape:", series.shape)
print("hour 30:", series[30])
--- test
assert series.shape == (48,), f"`series` should be one 1-D series of 48 readings, but its shape is {series.shape}."
assert np.array_equal(series[:24], day1) and np.array_equal(series[24:], day2), "The series should be day1''s readings followed by day2''s."
--- hint
Look at the printed shape. Did joining the days make the series *longer*, or did it add a new axis?
--- hint
`np.stack` creates a new axis, giving `(2, 24)`. To extend the existing axis, use `np.concatenate`.
```

## The convenience functions: `vstack`, `hstack`, `column_stack`

These shortcuts mostly wrap `concatenate`, with special handling for 1-D inputs, which is exactly where they''re most useful:

| Function | 2-D inputs | 1-D inputs of length n |
|---|---|---|
| `np.vstack` | concatenate rows (`axis=0`) | treats each as a **row** → `(k, n)` |
| `np.hstack` | concatenate columns (`axis=1`) | concatenates end to end → `(k·n,)` |
| `np.column_stack` | concatenate columns | treats each as a **column** → `(n, k)` |

```python run
heights = np.array([1.62, 1.75, 1.80])
weights = np.array([58.0, 72.5, 80.1])

print("vstack:\n", np.vstack([heights, weights]))
print("hstack:\n", np.hstack([heights, weights]))
print("column_stack:\n", np.column_stack([heights, weights]))
```

> **In the wild:** scikit-learn expects a feature matrix `X` of shape `(n_samples, n_features)`: one **row per sample**, one **column per feature**. If you have each feature as its own 1-D array, `np.column_stack` builds `X` in one call.

```python exercise id=feature-matrix title="Build a feature matrix"
# Five patients, three measurements each, stored as separate 1-D arrays.
age = np.array([34, 51, 29, 62, 45])
bmi = np.array([22.1, 27.4, 24.8, 30.2, 26.0])
heart_rate = np.array([68, 74, 80, 71, 66])

# Build `X` with one ROW per patient and one COLUMN per feature,
# in the order age, bmi, heart_rate. Shape (5, 3).
X = ...
--- solution
age = np.array([34, 51, 29, 62, 45])
bmi = np.array([22.1, 27.4, 24.8, 30.2, 26.0])
heart_rate = np.array([68, 74, 80, 71, 66])

X = np.column_stack([age, bmi, heart_rate])
--- test
assert X is not ..., "Replace the `...` with your code."
assert isinstance(X, np.ndarray), "`X` should be a NumPy array."
assert X.shape != (3, 5), "That''s one row per *feature*. Models expect one row per *patient*: shape (5, 3)."
assert X.shape == (5, 3), f"`X` should have shape (5, 3), but it has {X.shape}."
assert np.allclose(X[:, 1], bmi), "Column 1 should be `bmi`. Check the order of the features."
assert np.allclose(X[3], [62, 30.2, 71]), "Row 3 should hold patient 3''s age, BMI and heart rate."
--- hint
Each 1-D array should become a **column**. One of the functions in the table does exactly that.
--- hint
`np.column_stack([age, bmi, heart_rate])`, or equivalently `np.stack([...], axis=1)`.
```

Notice that `X` comes out as `float64`: one float column forces the whole array to float, because an array has a single dtype.

```python exercise id=bias-column title="Add a bias column"
# A design matrix for linear regression: 4 samples, 2 features.
X = np.array([[2.0, 3.0],
              [1.0, 5.0],
              [4.0, 1.0],
              [3.0, 2.0]])

# Linear models often prepend a column of ones (the "bias" or intercept term).
# Create `X_b` of shape (4, 3) whose FIRST column is all ones,
# followed by the two original columns. It must work for any number of rows.
X_b = ...
--- solution
X = np.array([[2.0, 3.0],
              [1.0, 5.0],
              [4.0, 1.0],
              [3.0, 2.0]])

X_b = np.hstack([np.ones((X.shape[0], 1)), X])
--- test
assert X_b is not ..., "Replace the `...` with your code."
assert isinstance(X_b, np.ndarray), "`X_b` should be a NumPy array."
assert X_b.shape == (4, 3), f"`X_b` should have shape (4, 3), but it has {X_b.shape}."
assert np.all(X_b[:, 0] == 1), "The first column of `X_b` should be all ones."
assert np.array_equal(X_b[:, 1:], X), "Columns 1 and 2 of `X_b` should be the original features, unchanged."
--- hint
Build a column of ones with shape `(number_of_rows, 1)` using `np.ones`. `X.shape[0]` gives the number of rows.
--- hint
Join it to the left of `X` along the columns: `np.hstack([ones_column, X])` or `np.concatenate([...], axis=1)`.
```

```python debug id=append-row-bug title="Adding one more row"
table = np.array([[1, 2, 3, 4],
                  [5, 6, 7, 8],
                  [9, 10, 11, 12]])
new_row = np.array([13, 14, 15, 16])

# Append `new_row` as a 4th row of the table.
table = np.concatenate([table, new_row])
print(table)
--- solution
table = np.array([[1, 2, 3, 4],
                  [5, 6, 7, 8],
                  [9, 10, 11, 12]])
new_row = np.array([13, 14, 15, 16])

table = np.concatenate([table, new_row[np.newaxis, :]])
print(table)
--- test
assert table.shape == (4, 4), f"`table` should have 4 rows of 4 values, shape (4, 4), but it is {table.shape}."
assert np.array_equal(table[-1], [13, 14, 15, 16]), "The last row should be `new_row`."
assert np.array_equal(table[:3], [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]]), "The original three rows should be unchanged."
--- hint
Read the error: the arrays have a different *number of dimensions*. What are `table.ndim` and `new_row.ndim`?
--- hint
`concatenate` needs both arrays to be 2-D. Turn `new_row` into a `(1, 4)` row with `new_row[np.newaxis, :]`, or use `np.vstack([table, new_row])`, which does that for you.
```

## Splitting arrays apart

`np.split` is the inverse of `concatenate`. Give it either a **number of equal sections** or a list of **indices to cut at**:

```python run
a = np.arange(12)

print("3 equal parts:", np.split(a, 3))
print("cut at 2 and 7:", np.split(a, [2, 7]))
```

Equal sections must divide the length exactly; `np.array_split` relaxes that, making the first pieces one element longer when needed:

```python run
a = np.arange(10)
print([p.tolist() for p in np.array_split(a, 3)])
```

For 2-D arrays, `axis=` picks the direction, and `vsplit` / `hsplit` are shortcuts for splitting rows and columns:

```python run
grid = np.arange(16).reshape(4, 4)

top, bottom = np.vsplit(grid, 2)       # split rows
left, right = np.hsplit(grid, [1])     # cut after column 0
print("top:\n", top)
print("left column shape:", left.shape, " right shape:", right.shape)
```

> **Tip:** the pieces returned by `split` are **views** into the original array, so splitting is cheap even for large data.

```python exercise id=train-val-test title="Split a dataset 70 / 15 / 15"
rng = np.random.default_rng(0)
data = rng.normal(size=(200, 4))    # 200 samples (rows), 4 features

# Split the ROWS of `data`, in order, into:
#   train: the first 70% of rows
#   val:   the next 15%
#   test:  the final 15%
# Compute the cut points from len(data); don''t hard-code 140 and 170.
train, val, test = ..., ..., ...
--- solution
rng = np.random.default_rng(0)
data = rng.normal(size=(200, 4))

n = len(data)
train, val, test = np.split(data, [int(n * 0.70), int(n * 0.85)])
--- test
assert train is not ... and val is not ... and test is not ..., "Replace the three `...` placeholders."
assert all(isinstance(p, np.ndarray) for p in (train, val, test)), "`train`, `val` and `test` should be NumPy arrays."
assert train.shape == (140, 4), f"`train` should have 140 rows and 4 columns, but has shape {train.shape}."
assert val.shape == (30, 4), f"`val` should have 30 rows, but has shape {val.shape}."
assert test.shape == (30, 4), f"`test` should have 30 rows, but has shape {test.shape}."
assert np.array_equal(np.concatenate([train, val, test]), data), "Together, the three pieces should be exactly `data`, in the original order."
--- hint
`np.split(data, [i, j])` returns three pieces: rows `[:i]`, `[i:j]` and `[j:]`.
--- hint
The cut points are 70% and 85% of the number of rows: `int(len(data) * 0.70)` and `int(len(data) * 0.85)`.
```

## Repeating: `tile` and `repeat`

Two more ways to build bigger arrays from smaller ones. `np.repeat` repeats **each element**; `np.tile` repeats the **whole array**:

```python run
a = np.array([1, 2, 3])

print("repeat:", np.repeat(a, 2))        # each element twice
print("tile:  ", np.tile(a, 2))          # whole array twice
print("tile 2-D:\n", np.tile(a, (2, 2))) # 2 copies down, 2 across
```

> **Under the hood:** `tile` and `repeat` really allocate the bigger array. When you only need repetition to *combine* arrays, broadcasting (coming up soon) does the same job without copying anything.

## Recap

- `np.concatenate` joins along an **existing** axis; all other axis sizes must match.
- `np.stack` joins same-shaped arrays along a **new** axis, turning a list of samples into a batch.
- `vstack` / `hstack` / `column_stack` are shortcuts; `column_stack` turns 1-D features into the columns of a feature matrix.
- "Different number of dimensions" errors usually mean a 1-D array needs `np.newaxis` before joining.
- `np.split` (exact), `np.array_split` (uneven), `vsplit` and `hsplit` cut arrays into views.
- `repeat` duplicates elements; `tile` duplicates the whole array.

**Up next:** vectorized computation begins: universal functions and element-wise math.
', 0, '[]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_4_4', 'sec_numpy_4', 'crs_numpy_mastery', 'Checkpoint: reshaping & combining', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"`a = np.arange(24)`. What is `a.reshape(4, -1).shape`?","options":["(4, 24)","(4, 6)","(6, 4)","It raises an error because -1 is not a valid size"],"answerIndex":1,"explanation":"`-1` tells NumPy to infer that dimension from the total size: 24 / 4 = 6."},{"id":"q2","prompt":"You need a 1-D version of an array that you will modify, and the original must stay unchanged. Which should you use?","options":["a.ravel()","a.reshape(-1)","a.flatten()","a.squeeze()"],"answerIndex":2,"explanation":"`ravel()` and `reshape(-1)` return views whenever possible, so in-place changes would write through to the original. `flatten()` always returns an independent copy."},{"id":"q3","prompt":"`m` has shape (2, 3), with students as rows and subjects as columns. Which expression gives one row per subject, with each row holding every student''s grade for that subject?","options":["m.reshape(3, 2)","m.ravel()","np.resize(m, (3, 2))","m.T"],"answerIndex":3,"explanation":"Only a transpose moves columns into rows. `reshape(3, 2)` has the right shape but re-reads the elements in row order, scrambling the data."},{"id":"q4","prompt":"A model outputs `out` with shape (batch, 1). Which expression reliably returns shape (batch,), even when batch == 1?","options":["out.squeeze(axis=1)","out.squeeze()","out.ravel()[0]","out.T"],"answerIndex":0,"explanation":"A bare `squeeze()` removes every length-1 axis, so a batch of one collapses to shape (). `squeeze(axis=1)` removes only the feature axis."},{"id":"q5","prompt":"`images` has shape (32, 64, 64, 3) in (N, H, W, C) order. Which call produces (N, C, H, W) for PyTorch?","options":["images.reshape(32, 3, 64, 64)","images.T","np.swapaxes(images, 0, 3)","np.moveaxis(images, -1, 1)"],"answerIndex":3,"explanation":"`moveaxis(images, -1, 1)` moves the channel axis to position 1 and keeps the others in order. `reshape` would scramble pixels, `.T` reverses all axes, and swapping axes 0 and 3 exchanges batch and channels."},{"id":"q6","prompt":"`a` and `b` both have shape (5, 3). What are the shapes of `np.concatenate([a, b])` and `np.stack([a, b])`?","options":["(10, 3) and (2, 5, 3)","(2, 5, 3) and (10, 3)","(10, 3) and (10, 3)","(5, 6) and (5, 3, 2)"],"answerIndex":0,"explanation":"`concatenate` lengthens an existing axis (axis 0 by default: 5 + 5 rows). `stack` adds a new axis of size 2 in front."},{"id":"q7","prompt":"`table` has shape (3, 4) and `row` has shape (4,). Why does `np.concatenate([table, row])` fail, and what fixes it?","options":["The dtypes differ; use row.astype(float)","concatenate only accepts two 1-D arrays; use np.append","The arrays have a different number of dimensions; use row[np.newaxis, :] or np.vstack([table, row])","The row is too short; pad it to 12 elements"],"answerIndex":2,"explanation":"`concatenate` requires the same number of dimensions. Making the row 2-D with shape (1, 4) fixes it, and `vstack` does that automatically."}]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_5_1', 'sec_numpy_5', 'crs_numpy_mastery', 'Universal functions and element-wise math', 'interactive', 0, 960, NULL, NULL, 'Every time you write `a + b` or `np.sqrt(a)` on arrays, NumPy is calling a **universal function**, or *ufunc*. A ufunc is a function that works element by element, runs in compiled C, and knows how to handle arrays of any shape. They are the engine behind almost every line of fast NumPy code.

This lesson is about learning that engine well. You''ll learn which operators map to which ufuncs, the rounding and clipping functions you''ll use daily, the difference between `np.max` and `np.maximum` (a classic interview question), and the extra powers every ufunc has: `out=`, `where=`, `.reduce`, `.accumulate` and `.outer`.

## Operators are ufuncs in disguise

Arithmetic on arrays is **element-wise**: the operation is applied to each pair of matching elements. Each operator is shorthand for a named ufunc.

```python run
import numpy as np

a = np.array([1, 2, 3, 4])
b = np.array([10, 20, 30, 40])

print("a + b  ->", a + b, " same as np.add:", np.add(a, b))
print("a * b  ->", a * b, " same as np.multiply:", np.multiply(a, b))
print("b - a  ->", b - a, " same as np.subtract:", np.subtract(b, a))
print("a ** 2 ->", a ** 2, " same as np.power:", np.power(a, 2))
np.add
```

That last line shows the ufunc object itself. It''s a real object with attributes and methods, which you''ll use later in this lesson.

| Operator | ufunc | Operator | ufunc |
|---|---|---|---|
| `+` | `np.add` | `//` | `np.floor_divide` |
| `-` | `np.subtract` | `%` | `np.mod` |
| `*` | `np.multiply` | `**` | `np.power` |
| `/` | `np.divide` | `-a` | `np.negative` |
| `>` `<` `==` | `np.greater`, `np.less`, `np.equal` | `abs(a)` | `np.abs` |

> **Under the hood:** a Python loop calls `+` once per element, paying interpreter overhead every time. A ufunc makes one call and loops in C over raw memory. That''s where the 10–100× speedups come from.

## The math toolbox

NumPy mirrors the `math` module, but every function works on whole arrays at once.

```python run
x = np.array([0.0, 1.0, 4.0, 9.0])
print("sqrt:", np.sqrt(x))
print("exp: ", np.exp([0.0, 1.0, 2.0]).round(3))
print("log: ", np.log([1.0, np.e, np.e ** 2]))      # natural log
print("log10:", np.log10([1, 10, 1000]))

angles = np.array([0, np.pi / 2, np.pi])
print("sin: ", np.sin(angles).round(6))
print("abs: ", np.abs(np.array([-3, 0, 2.5])))
```

> **Pitfall:** `math.sqrt(array)` fails with a `TypeError`. The `math` module only understands single numbers. Always use the `np.` version on arrays.

Some inputs are outside a function''s domain. Instead of crashing, NumPy returns `nan` (not a number) or `-inf`:

```python run
print(np.log(np.array([1.0, 0.0, -1.0])))
print(np.sqrt(np.array([4.0, -4.0])))
print(np.array([1.0, -1.0]) / 0)
```

On desktop NumPy each of these lines also prints a `RuntimeWarning` such as *divide by zero encountered in log*. The browser build of NumPy can''t detect floating-point exceptions, so here the results appear silently. Either way, a stray `nan` or `inf` is your signal that something went outside the valid range. You''ll meet NaN properly in a later lesson.

## Rounding: round, floor, ceil and trunc

Four functions, four different rules. Mixing them up is a common source of off-by-one bugs.

```python run
v = np.array([-2.5, -1.7, -0.2, 0.2, 1.5, 2.5, 2.7])

print("round:", np.round(v))   # nearest; ties go to the EVEN number
print("floor:", np.floor(v))   # always down (toward -infinity)
print("ceil: ", np.ceil(v))    # always up (toward +infinity)
print("trunc:", np.trunc(v))   # toward zero (drop the decimals)
print("round to 1 dp:", np.round(np.array([3.14159, 2.71828]), 1))
```

Look at `round`: `1.5 → 2` but `2.5 → 2`. NumPy (like Python) uses **banker''s rounding**: exact halves go to the nearest even number, which avoids a systematic upward bias when you round millions of values. Also note that all four return **floats**; use `.astype(int)` if you need integers.

```python predict id=predict-floor title="Floor of negative numbers"
print(np.floor(np.array([-1.5, 1.5])))
--- options
[-1.  1.]
* [-2.  1.]
[-1.  2.]
[-2.  2.]
--- explain
`floor` always rounds **down**, toward negative infinity. Down from `-1.5` is `-2`, and down from `1.5` is `1`. If you wanted "chop off the decimals" behavior, that''s `np.trunc`, which gives `[-1.  1.]`.
```

## clip, and maximum vs. max

`np.clip(a, lo, hi)` limits every value to the range `[lo, hi]`. It''s perfect for capping outliers, keeping probabilities inside `[0, 1]`, or keeping pixel values in `0..255`.

```python run
readings = np.array([-5, 12, 47, 103, 88, 250])
print("clipped to 0..100:", np.clip(readings, 0, 100))

# Two functions with confusingly similar names:
a = np.array([3, 9, 1, 7])
b = np.array([5, 2, 8, 6])
print("np.max(a)        ->", np.max(a))            # ONE number: the largest in a
print("np.maximum(a, b) ->", np.maximum(a, b))     # element-wise: larger of each pair
print("np.maximum(a, 5) ->", np.maximum(a, 5))     # floor every value at 5
```

- `np.max(a)` is an **aggregation**: it collapses an array to its single largest value.
- `np.maximum(a, b)` is a **ufunc**: it compares two arrays element by element and returns an array of the same shape.

`np.maximum(x, 0)` is exactly the **ReLU** activation used in neural networks.

```python exercise id=relu-and-clip title="Activations from ufuncs"
z = np.array([-2.0, -0.5, 0.0, 1.5, 3.0, 8.0])

# TODO 1: `relu` should be z with every negative value replaced by 0.
#         (Use a ufunc: no loops, no if-statements.)
relu = ...

# TODO 2: `capped` should be z limited to the range [-1, 1].
capped = ...
--- solution
z = np.array([-2.0, -0.5, 0.0, 1.5, 3.0, 8.0])

relu = np.maximum(z, 0)
capped = np.clip(z, -1, 1)
--- test
assert relu is not ..., "Replace the `...` after `relu =` with your code."
assert capped is not ..., "Replace the `...` after `capped =` with your code."
assert isinstance(relu, np.ndarray), "`relu` should be a NumPy array with one value per element of `z`."
assert relu.shape == z.shape, f"`relu` should have the same shape as `z` {z.shape}, but has {relu.shape}. Did you use np.max instead of np.maximum?"
assert np.allclose(relu, [0, 0, 0, 1.5, 3, 8]), f"`relu` should keep positives and turn negatives into 0, but it is {relu}."
assert isinstance(capped, np.ndarray) and capped.shape == z.shape, "`capped` should be an array with the same shape as `z`."
assert np.allclose(capped, [-1, -0.5, 0, 1, 1, 1]), f"`capped` should limit every value to [-1, 1], but it is {capped}."
--- hint
You need an *element-wise* "larger of two values" for `relu`, and a "limit to a range" function for `capped`.
--- hint
`np.maximum(z, 0)` compares every element with 0. For the range, look at `np.clip(array, low, high)`.
```

## Division: true, floor and modulo

`/` always produces floats ("true division"). `//` rounds down to the nearest integer ("floor division"), and `%` gives the remainder. Together they convert seconds to minutes, flat indices to row/column, and much more.

```python run
seconds = np.array([59, 60, 125, 3600])
print("minutes (float):", seconds / 60)
print("whole minutes:  ", seconds // 60)
print("leftover secs:  ", seconds % 60)

# Flat position -> (row, col) in a grid that is 4 columns wide
idx = np.arange(10)
print("rows:", idx // 4)
print("cols:", idx % 4)
```

> **Pitfall:** `//` floors toward negative infinity, so `-7 // 2` is `-4`, not `-3`. That matters when your data can be negative.

```python debug id=average-rating title="The ratings average is always a whole number"
# A product has received this many 1..5 star ratings.
star_counts = np.array([4, 1, 7, 20, 31])          # counts for 1, 2, 3, 4, 5 stars
stars = np.arange(1, 6)

total_stars = (stars * star_counts).sum()
num_ratings = star_counts.sum()
average = total_stars // num_ratings

print(f"Average rating: {average} from {num_ratings} ratings")
--- solution
star_counts = np.array([4, 1, 7, 20, 31])
stars = np.arange(1, 6)

total_stars = (stars * star_counts).sum()
num_ratings = star_counts.sum()
average = total_stars / num_ratings

print(f"Average rating: {average} from {num_ratings} ratings")
--- test
assert np.isclose(average, 262 / 63), f"`average` should be the exact mean rating (about 4.16), but it is {average!r}. Is part of the answer being thrown away?"
assert num_ratings == 63, "Don''t change how `num_ratings` is computed."
--- hint
Run it. Is 4 really the average of mostly 4s and 5s? Something is discarding the fractional part.
--- hint
`//` is *floor* division. Which operator keeps the decimals?
```

## Comparisons produce boolean arrays

Comparison operators are ufuncs too. They return arrays of `True`/`False`, which you can count, combine and use as masks.

```python run
temps = np.array([12, 25, 31, 18, 29, 35])
hot = temps > 28
print("hot days:   ", hot)
print("how many:   ", hot.sum())           # True counts as 1
print("fraction:   ", hot.mean())
print("mild (18-28):", (temps >= 18) & (temps <= 28))
```

Because `True` is 1 and `False` is 0, `.sum()` counts matches and `.mean()` gives the fraction. Combine conditions with `&` (and), `|` (or) and `~` (not), and **always wrap each comparison in parentheses**, because `&` binds more tightly than `>`.

## Superpowers: out= and where=

Every ufunc accepts two extra arguments:

- `out=` writes the result into an existing array instead of allocating a new one. That''s useful for large arrays and tight loops.
- `where=` applies the operation only where a boolean mask is `True`. Elsewhere, `out` keeps its old values.

```python run
values = np.array([4.0, 0.0, 9.0, 0.0, 16.0])
counts = np.array([2.0, 0.0, 3.0, 0.0, 4.0])

# Safe division: only divide where counts != 0, use 0.0 elsewhere.
result = np.zeros_like(values)
np.divide(values, counts, out=result, where=counts != 0)
print("safe ratio:", result)

# In-place: square roots written back into the same array
buf = np.array([1.0, 4.0, 9.0])
np.sqrt(buf, out=buf)
buf
```

> **Pitfall:** always pass an initialized `out=` array when you use `where=`. Positions where the mask is `False` are **not written**, so without `out` they would contain uninitialized garbage.

```python exercise id=safe-per-capita title="Safe per-capita rates"
cases = np.array([120.0, 0.0, 45.0, 300.0, 18.0])
population = np.array([10_000.0, 0.0, 1_500.0, 0.0, 2_000.0])   # 0 = missing data

# TODO: compute `rate` = cases / population * 1000 (cases per 1,000 people),
# but wherever population is 0 the rate must be 0.0, and no division-by-zero
# should happen. Use np.divide with out= and where=.
rate = ...
--- solution
cases = np.array([120.0, 0.0, 45.0, 300.0, 18.0])
population = np.array([10_000.0, 0.0, 1_500.0, 0.0, 2_000.0])

rate = np.zeros_like(cases)
np.divide(cases, population, out=rate, where=population != 0)
rate *= 1000
--- test
assert rate is not ..., "Replace the `...` after `rate =` with your code."
assert isinstance(rate, np.ndarray), "`rate` should be a NumPy array."
assert rate.shape == cases.shape, f"`rate` should have one value per region {cases.shape}, but has shape {rate.shape}."
assert not np.isnan(rate).any() and not np.isinf(rate).any(), f"`rate` contains nan or inf: {rate}. Where population is 0, the rate should be exactly 0.0."
assert np.allclose(rate, [12.0, 0.0, 30.0, 0.0, 9.0]), f"Expected cases per 1,000 people, got {rate}."
--- hint
Start with `rate = np.zeros_like(cases)` so the "skipped" positions already hold 0.0.
--- hint
`np.divide(cases, population, out=rate, where=population != 0)` fills only the valid positions. Then scale by 1000.
```

## Ufunc methods: reduce, accumulate, outer

Because ufuncs are objects, they come with methods that turn a simple two-input operation into something much more powerful.

```python run
a = np.array([1, 2, 3, 4, 5])

print("add.reduce:       ", np.add.reduce(a))          # 1+2+3+4+5 = sum
print("multiply.reduce:  ", np.multiply.reduce(a))     # 1*2*3*4*5 = product
print("add.accumulate:   ", np.add.accumulate(a))      # running sum = cumsum
print("maximum.accumulate:", np.maximum.accumulate(np.array([3, 1, 4, 1, 5, 9, 2])))

# outer: apply the op to EVERY pair -> a 2-D table
print(np.multiply.outer(np.arange(1, 4), np.arange(1, 6)))
```

- `ufunc.reduce` folds an array down to one value. `np.add.reduce` is what `np.sum` does.
- `ufunc.accumulate` keeps every intermediate result. `np.maximum.accumulate` gives a "running maximum", the highest value seen so far, which is great for tracking peaks or drawdowns in a price series.
- `ufunc.outer(x, y)` builds the full table of `op(x[i], y[j])`. The multiplication table above has shape `(3, 5)`.

```python predict id=predict-accumulate title="Running maximum"
print(np.maximum.accumulate(np.array([2, 5, 3, 8, 1])))
--- options
[2 7 10 18 19]
* [2 5 5 8 8]
[8 8 8 8 8]
[2 5 3 8 1]
--- explain
`accumulate` keeps every partial result: max(2)=2, max(2,5)=5, max(5,3)=5, max(5,8)=8, max(8,1)=8. It''s a running maximum. (`[2 7 10 18 19]` would be `np.add.accumulate`, the running sum.)
```

```python exercise id=record-highs title="Days that set a new record"
# Daily closing price of a stock
price = np.array([100, 102, 101, 105, 104, 108, 108, 107, 112])

# TODO 1: `running_high` = the highest price seen up to and including each day.
running_high = ...

# TODO 2: `drawdown` = how far each day''s price is below its running high
#         (0 on days at the high, positive otherwise).
drawdown = ...
--- solution
price = np.array([100, 102, 101, 105, 104, 108, 108, 107, 112])

running_high = np.maximum.accumulate(price)
drawdown = running_high - price
--- test
assert running_high is not ..., "Replace the `...` after `running_high =` with your code."
assert drawdown is not ..., "Replace the `...` after `drawdown =` with your code."
assert isinstance(running_high, np.ndarray) and running_high.shape == price.shape, "`running_high` should be an array with one value per day."
assert np.array_equal(running_high, [100, 102, 102, 105, 105, 108, 108, 108, 112]), f"`running_high` should never decrease and should track the best price so far, but it is {running_high}."
assert isinstance(drawdown, np.ndarray) and drawdown.shape == price.shape, "`drawdown` should be an array with one value per day."
assert np.array_equal(drawdown, [0, 0, 1, 0, 1, 0, 0, 1, 0]), f"`drawdown` should be running_high - price, but it is {drawdown}."
--- hint
You want a *running* version of "maximum". Which ufunc method keeps every intermediate result?
--- hint
`np.maximum.accumulate(price)` gives the running high. The drawdown is a simple element-wise subtraction.
```

```python debug id=power-overflow title="Squares that go negative"
# Squared distances in meters for a sensor network
distances = np.array([1_000, 30_000, 50_000, 70_000], dtype=np.int32)

squared = distances ** 2
print("squared distances:", squared)
print("all positive?", (squared > 0).all())
--- solution
distances = np.array([1_000, 30_000, 50_000, 70_000], dtype=np.int32)

squared = distances.astype(np.int64) ** 2
print("squared distances:", squared)
print("all positive?", (squared > 0).all())
--- test
assert (np.asarray(squared) > 0).all(), f"Some squares are not positive: {squared}. The int32 type can only hold values up to about 2.1 billion."
assert np.array_equal(np.asarray(squared, dtype=np.float64), np.array([1e6, 9e8, 2.5e9, 4.9e9])), f"Expected the true squares [1e6, 9e8, 2.5e9, 4.9e9], got {squared}."
--- hint
Run it. A distance squared can''t be negative. What is the largest number an `int32` can hold?
--- hint
`np.iinfo(np.int32).max` is about 2.1 billion, and 50,000² is 2.5 billion. Convert to a wider type (`np.int64` or `float`) *before* squaring.
```

Integer ufuncs wrap around silently on overflow instead of raising an error. That''s the price of C speed, and you saw it in detail in the dtypes lesson.

## Recap

- Operators like `+`, `*`, `>` and `**` are ufuncs: element-wise, compiled and fast.
- `np.round` uses banker''s rounding; `floor`, `ceil` and `trunc` each round in a fixed direction and all return floats.
- `np.max` collapses an array; `np.maximum` compares two arrays element by element. `np.clip` limits values to a range.
- `/` gives floats, `//` floors, `%` is the remainder. Watch out for `//` when you wanted an average.
- `out=` reuses memory and `where=` masks the operation. Together they give safe division.
- `.reduce`, `.accumulate` and `.outer` turn any binary ufunc into sums, running totals and lookup tables.

**Up next:** broadcasting, the rule that decides what happens when you combine arrays of *different* shapes.
', 0, '[]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_numpy_5_2', 'sec_numpy_5', 'crs_numpy_mastery', 'Broadcasting, demystified', 'interactive', 1, 1200, NULL, NULL, 'Here''s a question that trips up almost everyone: what should happen when you add an array of shape `(3, 4)` to one of shape `(4,)`? Or multiply `(5, 1)` by `(1, 3)`? In plain Python, combining a list of 12 numbers with a list of 4 makes no sense. In NumPy it''s routine, and the rule that makes it work is called **broadcasting**.

Broadcasting is how NumPy *stretches* smaller arrays to match bigger ones, **without copying any data**. It lets you center a dataset in one line, build a multiplication table without loops, and compute every pairwise distance between thousands of points. It''s also the source of the single most common NumPy error message. By the end of this lesson you''ll be able to predict the shape of any broadcast in your head, and you''ll know how to fix it when it fails.

## You already use it: scalars

The simplest broadcast is an array combined with a single number. The scalar is "stretched" to the shape of the array.

```python run
import numpy as np

prices = np.array([19.99, 5.49, 102.00, 7.25])
print("with 20% tax:", prices * 1.2)
print("minus $5:    ", prices - 5)
print("shape of prices:", prices.shape, "| shape of a scalar:", np.shape(5))
```

Conceptually, NumPy treats `5` as if it were `[5, 5, 5, 5]`. In reality it never builds that array. It reuses the same number for every element, which is why broadcasting is both fast and memory-free.

## Stretching a row across a matrix

Now something bigger. A shop chain has 3 stores selling 4 products. `units[i, j]` is how many of product `j` store `i` sold, and `price[j]` is the price of product `j`.

```python run
units = np.array([[10,  2, 0, 5],     # store 0
                  [ 3,  8, 1, 0],     # store 1
                  [ 7,  0, 4, 9]])    # store 2
price = np.array([2.50, 4.00, 10.00, 1.25])   # one price per product (column)

revenue = units * price
print("units:", units.shape, " price:", price.shape, " ->", revenue.shape)
revenue
```

`price` has shape `(4,)`, so NumPy lines it up with the **last** axis of `units` (the 4 columns) and reuses it for every row. Each column gets multiplied by its own price. You didn''t write a loop, and no `(3, 4)` copy of `price` was created.

## The two rules

Broadcasting follows a short, mechanical procedure. To combine two arrays:

1. **Align the shapes from the right.** If one array has fewer dimensions, pretend it has extra size-1 dimensions on the **left**.
2. **Compare each pair of dimensions.** They''re compatible if they are **equal**, or if **one of them is 1**. A size-1 dimension is stretched to match the other. The result takes the larger size in each position.

If any pair is incompatible (different sizes, neither is 1), NumPy raises an error.

```
units  (3, 4)        units  (3, 4)        a  (3, 1)         a  (3, 4)
price     (4,)       col    (3, 1)        b     (4,)        b     (3,)
       ───────              ───────             ───────            ───────
result (3, 4) ✓      result (3, 4) ✓      result (3, 4) ✓   4 vs 3 ✗ error
```

You can ask NumPy to apply the rules for you with `np.broadcast_shapes`, without creating any arrays:

```python run
print(np.broadcast_shapes((3, 4), (4,)))        # row across matrix
print(np.broadcast_shapes((3, 1), (4,)))        # column x row -> table
print(np.broadcast_shapes((5, 1, 3), (4, 1)))   # works in any number of dims
print(np.broadcast_shapes((8, 1, 6, 1), (7, 1, 5)))
```

Work through the last one with the rules: align `(8, 1, 6, 1)` and `(7, 1, 5)` from the right → `(8, 1, 6, 1)` vs `(1, 7, 1, 5)` → `(8, 7, 6, 5)`.

```python predict id=predict-table-shape title="Column meets row"
col = np.ones((3, 1))
row = np.ones(4)
print((col + row).shape)
--- options
(3, 1)
(4,)
* (3, 4)
Error: shapes don''t match
--- explain
Align from the right: `(3, 1)` vs `(4,)` becomes `(3, 1)` vs `(1, 4)`. In each position one of the sizes is 1, so both get stretched: the column is copied across 4 columns and the row is copied down 3 rows. The result is a full `(3, 4)` table.
```

```python predict id=predict-incompatible title="Will this broadcast?"
grades = np.zeros((2, 3))     # 2 students x 3 subjects
curve = np.zeros(2)           # one curve per student
try:
    print((grades + curve).shape)
except ValueError:
    print("ValueError")
--- options
(2, 3)
* ValueError
(2, 2)
(3, 2)
--- explain
Align from the right: `(2, 3)` vs `(2,)` compares **3 with 2**. They aren''t equal and neither is 1, so NumPy raises. NumPy never guesses which axis you meant; it only ever pads on the **left**.
```

## When it fails: reading the error

Here''s the error you''ll see most in your NumPy career. Run it and read it carefully:

```python run error
scores = np.ones((3, 4))           # 3 students x 4 exams
bonus = np.array([1.0, 2.0, 0.5])  # one bonus per student
scores + bonus
```

`operands could not be broadcast together with shapes (3,4) (3,)` tells you exactly what happened. Aligning from the right puts `bonus`''s 3 against the **4 exams**, not the 3 students. 4 vs. 3: incompatible.

The bonus is *per student*, meaning per **row**, so it needs to run down axis 0. We need shape `(3, 1)`: a **column vector**.

## Column vectors: [:, None]

There are three common ways to turn a 1-D array of shape `(n,)` into a column of shape `(n, 1)`. They''re all equivalent:

```python run
bonus = np.array([1.0, 2.0, 0.5])

print(bonus[:, None].shape)         # index with None: insert a new axis
print(bonus[:, np.newaxis].shape)   # np.newaxis is literally None
print(bonus.reshape(-1, 1).shape)   # reshape to "as many rows as needed, 1 column"

scores = np.ones((3, 4))
scores + bonus[:, None]
```

Now `(3, 4)` vs `(3, 1)` aligns the 3 with the 3 students, and the bonus is stretched across all 4 exams. Read `bonus[:, None]` as "keep all the existing data along the first axis, and add a new axis of length 1 after it".

> **Tip:** when you think "one value per **row**", you want shape `(n, 1)`. When you think "one value per **column**", shape `(m,)` (or `(1, m)`) already works.

## Outer operations: tables without loops

Combine a column with a row and you get every combination: an "outer" operation. This is one of the most useful patterns in NumPy.

```python run
base_price = np.array([10.0, 25.0, 40.0])        # 3 products
discount = np.array([0.0, 0.1, 0.25, 0.5])       # 4 discount levels

# rows = products, columns = discounts
table = base_price[:, None] * (1 - discount)
print(table.shape)
table
```

```python exercise id=times-table title="Build a times table"
# TODO: build `table`, a (9, 9) array where table[i, j] == (i + 1) * (j + 1),
# i.e. the classic times table from 1x1 up to 9x9.
# Use broadcasting: no loops, and no np.outer.
n = np.arange(1, 10)

table = ...
--- solution
n = np.arange(1, 10)

table = n[:, None] * n
--- test
assert table is not ..., "Replace the `...` after `table =` with your code."
assert isinstance(table, np.ndarray), "`table` should be a NumPy array."
assert table.shape == (9, 9), f"`table` should have shape (9, 9) but has {table.shape}. Turn one copy of `n` into a column with n[:, None]."
expected = np.arange(1, 10).reshape(9, 1) * np.arange(1, 10).reshape(1, 9)
assert np.array_equal(table, expected), f"table[i, j] should equal (i + 1) * (j + 1). For example table[2, 3] should be 12, but it is {table[2, 3]}."
--- hint
You need one copy of `n` running down the rows (shape `(9, 1)`) and one running across the columns (shape `(9,)`).
--- hint
`n[:, None]` is a column. Multiply it by `n`.
```

## The silent trap: (n,) vs (n, 1)

The broadcasting error is annoying, but at least it''s loud. The **real** danger is when shapes happen to be compatible in the wrong way. Then you get no error, just wrong numbers.

The classic case is a **square** matrix. Suppose you want to subtract each **row''s** mean from that row. `X.mean(axis=1)` computes one mean per row; you''ll study the `axis` argument in depth next lesson.

```python run
X = np.array([[1.0, 2.0, 3.0],
              [10.0, 20.0, 30.0],
              [100.0, 200.0, 300.0]])

row_means = X.mean(axis=1)          # shape (3,): [2, 20, 200]
wrong = X - row_means               # (3,3) - (3,): aligned with COLUMNS!
right = X - row_means[:, None]      # (3,3) - (3,1): aligned with ROWS

print("row means:", row_means)
print("wrong (no error!):\n", wrong)
print("right:\n", right)
```

Because the matrix is 3×3, `(3,)` lines up with the columns perfectly well, so NumPy has no reason to complain. It subtracts 2 from column 0, 20 from column 1 and 200 from column 2. With a non-square matrix the same bug would have raised an error. Square matrices hide it.

> **Pitfall:** whenever you combine a 1-D array with a 2-D one, ask yourself "is this per row or per column?" If it''s per row, you need `[:, None]`. Testing your code on a **non-square** example is a cheap way to surface these bugs.

```python debug id=center-rows title="Rows that won''t center"
# Each row is one user''s ratings of 3 movies. We want to remove each user''s
# personal bias: subtract each user''s average rating from their own ratings,
# so every row ends up averaging 0.
ratings = np.array([[5.0, 4.0, 3.0],
                    [2.0, 1.0, 3.0],
                    [4.0, 4.0, 1.0]])

user_avg = ratings.mean(axis=1)
centered = ratings - user_avg

print("row averages after centering:", centered.mean(axis=1).round(3))
--- solution
ratings = np.array([[5.0, 4.0, 3.0],
                    [2.0, 1.0, 3.0],
                    [4.0, 4.0, 1.0]])

user_avg = ratings.mean(axis=1)
centered = ratings - user_avg[:, None]

print("row averages after centering:", centered.mean(axis=1).round(3))
--- test
assert centered.shape == (3, 3), f"`centered` should keep the shape (3, 3), but has {centered.shape}."
assert np.allclose(centered.mean(axis=1), 0), f"Each row of `centered` should average 0, but the row averages are {centered.mean(axis=1).round(3)}. Is each user''s average being subtracted from the right row?"
assert np.allclose(centered, ratings - ratings.mean(axis=1, keepdims=True)), "Subtract each user''s own average from every rating in that user''s row."
--- hint
Run it. The row averages are not 0, and there''s no error. The shapes are `(3, 3)` and `(3,)`: which axis does the `(3,)` get lined up with?
--- hint
`user_avg` holds one value per **row**, so it needs shape `(3, 1)` to broadcast down the rows. Try `user_avg[:, None]`.
```

## Standardizing columns: the data-science classic

In machine learning you almost always **standardize** features before training: subtract each column''s mean and divide by each column''s standard deviation, so every feature has mean 0 and std 1. With broadcasting it''s a single line, because "per column" statistics have shape `(n_features,)` and line up with the last axis automatically.

```python run
rng = np.random.default_rng(0)
# 6 houses x 3 features: size (m²), bedrooms, age (years)
X = np.column_stack([rng.normal(120, 30, 6), rng.integers(1, 6, 6), rng.normal(25, 10, 6)])

mu = X.mean(axis=0)       # shape (3,): one mean per column
sigma = X.std(axis=0)     # shape (3,): one std per column
Z = (X - mu) / sigma      # (6,3) with (3,): aligned with columns

print("means:", Z.mean(axis=0).round(6))
print("stds: ", Z.std(axis=0).round(6))
```

```python exercise id=min-max-scale title="Min-max scale every feature"
# Each row is a patient; columns are heart rate, temperature, and age.
X = np.array([[72.0, 36.6, 34.0],
              [88.0, 38.1, 61.0],
              [64.0, 36.9, 19.0],
              [95.0, 37.4, 45.0]])

# TODO: min-max scale each COLUMN so its smallest value becomes 0 and its
# largest becomes 1:   (x - column_min) / (column_max - column_min)
# Use broadcasting; X.min(axis=0) gives one minimum per column.
scaled = ...
--- solution
X = np.array([[72.0, 36.6, 34.0],
              [88.0, 38.1, 61.0],
              [64.0, 36.9, 19.0],
              [95.0, 37.4, 45.0]])

col_min = X.min(axis=0)
col_max = X.max(axis=0)
scaled = (X - col_min) / (col_max - col_min)
--- test
assert scaled is not ..., "Replace the `...` after `scaled =` with your code."
assert isinstance(scaled, np.ndarray), "`scaled` should be a NumPy array."
assert scaled.shape == X.shape, f"`scaled` should have the same shape as X {X.shape}, but has {scaled.shape}."
assert np.allclose(scaled.min(axis=0), 0), f"Every column''s minimum should become 0, but the column minimums are {scaled.min(axis=0).round(3)}. Are you scaling per column (axis=0)?"
assert np.allclose(scaled.max(axis=0), 1), f"Every column''s maximum should become 1, but the column maximums are {scaled.max(axis=0).round(3)}."
expected = (X - X.min(axis=0)) / (X.max(axis=0) - X.min(axis=0))
assert np.allclose(scaled, expected), "The relative spacing within each column should be preserved: use (x - min) / (max - min)."
--- hint
Compute `X.min(axis=0)` and `X.max(axis=0)`. Each has shape `(3,)`, one value per column, which already lines up with the last axis of `X`.
--- hint
`scaled = (X - col_min) / (col_max - col_min)`, with both statistics computed using `axis=0`.
```

## keepdims: broadcasting-friendly statistics

You saw that per-row statistics need `[:, None]` before you can broadcast them back. Reductions can do that for you: pass `keepdims=True` and the reduced axis is kept with length 1.

```python run
counts = np.array([[3, 1, 6],
                   [0, 4, 4],
                   [5, 5, 0],
                   [2, 2, 6]])

print(counts.sum(axis=1).shape)                  # (4,)   can''t divide (4,3) by this
print(counts.sum(axis=1, keepdims=True).shape)   # (4, 1) broadcasts down the rows

shares = counts / counts.sum(axis=1, keepdims=True)
print(shares.round(2))
print("each row sums to:", shares.sum(axis=1))
```

```python debug id=row-proportions title="Turn counts into row percentages"
# Website visits: rows = 4 days, columns = 3 traffic sources.
visits = np.array([[120,  30, 50],
                   [ 80,  60, 60],
                   [200, 100, 100],
                   [ 50,  25, 25]])

# Goal: percentage of each day''s traffic coming from each source.
pct = visits / visits.sum(axis=1) * 100
print(pct.round(1))
--- solution
visits = np.array([[120,  30, 50],
                   [ 80,  60, 60],
                   [200, 100, 100],
                   [ 50,  25, 25]])

pct = visits / visits.sum(axis=1, keepdims=True) * 100
print(pct.round(1))
--- test
assert pct.shape == (4, 3), f"`pct` should have shape (4, 3), one percentage per day and source, but has {pct.shape}."
assert np.allclose(pct.sum(axis=1), 100), f"Each day''s percentages should add up to 100, but they add up to {pct.sum(axis=1).round(1)}."
assert np.allclose(pct[0], [60, 15, 25]), f"Day 0 should be [60, 15, 25] percent, got {pct[0].round(1)}."
--- hint
Run it and read the error message. Which two shapes are being combined?
--- hint
`visits.sum(axis=1)` has shape `(4,)`, which gets aligned with the 3 columns. Keep the summed axis with `keepdims=True` (or add `[:, None]`) so it has shape `(4, 1)`.
```

## Pairwise distances: broadcasting in 3-D

Here''s where broadcasting really shines. Given `n` points in 2-D, compute the distance between **every pair**. With loops, that''s a double `for` over `n²` pairs. With broadcasting, it''s three lines.

The trick: turn the `(n, 2)` array of points into two views, one of shape `(n, 1, 2)` and one of shape `(1, n, 2)`. Subtracting them broadcasts to `(n, n, 2)`, every point minus every other point.

```python run
points = np.array([[0.0, 0.0],
                   [3.0, 4.0],
                   [6.0, 8.0],
                   [0.0, 5.0]])

diff = points[:, None, :] - points[None, :, :]   # (4,1,2) - (1,4,2) -> (4,4,2)
dist = np.sqrt((diff ** 2).sum(axis=-1))          # sum over the x/y axis -> (4,4)

print("diff shape:", diff.shape)
print(dist.round(2))
```

Read `dist[i, j]` as "distance from point `i` to point `j`". The diagonal is 0 (every point is 0 away from itself), and the matrix is symmetric. This exact pattern powers k-nearest neighbors, clustering (you''ll use it in the k-means project), and attention in Transformers.

```python exercise id=nearest-store title="Find each customer''s nearest store"
customers = np.array([[1.0, 1.0],
                      [9.0, 8.0],
                      [4.0, 6.0],
                      [8.0, 1.0],
                      [0.0, 9.0]])          # 5 customers (x, y)
stores = np.array([[0.0, 0.0],
                   [10.0, 10.0],
                   [5.0, 5.0]])             # 3 stores (x, y)

# TODO 1: `dist` must be a (5, 3) array where dist[i, j] is the straight-line
#         distance from customer i to store j. Use broadcasting, no loops.
dist = ...

# TODO 2: `nearest` = for each customer, the index (0, 1 or 2) of the closest store.
#         Hint: np.argmin(..., axis=1) returns the position of the smallest value in each row.
nearest = ...
--- solution
customers = np.array([[1.0, 1.0],
                      [9.0, 8.0],
                      [4.0, 6.0],
                      [8.0, 1.0],
                      [0.0, 9.0]])
stores = np.array([[0.0, 0.0],
                   [10.0, 10.0],
                   [5.0, 5.0]])

diff = customers[:, None, :] - stores[None, :, :]
dist = np.sqrt((diff ** 2).sum(axis=-1))
nearest = np.argmin(dist, axis=1)
--- test
assert dist is not ..., "Replace the `...` after `dist =` with your code."
assert nearest is not ..., "Replace the `...` after `nearest =` with your code."
assert isinstance(dist, np.ndarray), "`dist` should be a NumPy array."
assert dist.shape == (5, 3), f"`dist` should have shape (5, 3), one row per customer and one column per store, but has {dist.shape}. Try customers[:, None, :] - stores[None, :, :]."
expected = np.sqrt(((customers[:, None, :] - stores[None, :, :]) ** 2).sum(axis=-1))
assert np.allclose(dist, expected), f"dist[i, j] should be the Euclidean distance. For customer 0 and store 2 that''s {expected[0, 2]:.3f}, but you have {dist[0, 2]:.3f}."
nearest = np.asarray(nearest)
assert nearest.shape == (5,), f"`nearest` should have one store index per customer (shape (5,)), but has shape {nearest.shape}. Did you use axis=1?"
assert np.array_equal(nearest, [0, 1, 2, 2, 2]), f"`nearest` should be [0, 1, 2, 2, 2], but is {nearest}."
--- hint
Give `customers` a store axis and `stores` a customer axis: `customers[:, None, :]` has shape `(5, 1, 2)` and `stores[None, :, :]` has shape `(1, 3, 2)`.
--- hint
Subtract them to get shape `(5, 3, 2)`, square, sum over the last axis (`axis=-1`) and take `np.sqrt`. Then `np.argmin(dist, axis=1)`.
```

```python debug id=distance-shape title="A distance matrix with the wrong shape"
# Distances between every pair of 4 sensors on a line (positions in km).
positions = np.array([0.0, 2.5, 7.0, 10.0])

pairwise = np.abs(positions - positions)
print("shape:", pairwise.shape)
print(pairwise)
--- solution
positions = np.array([0.0, 2.5, 7.0, 10.0])

pairwise = np.abs(positions[:, None] - positions)
print("shape:", pairwise.shape)
print(pairwise)
--- test
assert pairwise.shape == (4, 4), f"`pairwise` should be a (4, 4) matrix, one entry per pair of sensors, but has shape {pairwise.shape}."
assert np.allclose(pairwise, np.abs(positions.reshape(-1, 1) - positions.reshape(1, -1))), "pairwise[i, j] should be |positions[i] - positions[j]|."
assert pairwise[0, 3] == 10.0, f"Sensors 0 and 3 are 10 km apart, but pairwise[0, 3] is {pairwise[0, 3]}."
--- hint
Run it. Subtracting an array from itself element by element always gives zeros. You want *every* position against *every other* position.
--- hint
Make one side a column: `positions[:, None] - positions` broadcasts `(4, 1)` against `(4,)` into a `(4, 4)` table.
```

## Under the hood: stretching without copying

How can NumPy stretch an array without copying it? With **strides**. A stride is how many bytes to jump to reach the next element along an axis. A broadcast dimension simply gets a stride of **0**: stepping along it keeps reading the same memory.

`np.broadcast_to` makes this visible:

```python run
row = np.array([1, 2, 3], dtype=np.int64)
big = np.broadcast_to(row, (1000, 3))

print("shape:", big.shape)
print("strides (bytes):", big.strides)     # (0, 8): moving down a row moves 0 bytes!
print("shares memory with row?", np.shares_memory(big, row))
print("writeable?", big.flags.writeable)
big[:2]
```

The "1000 × 3" array costs exactly as much memory as the original 3 numbers. It''s also **read-only**: since every row is the same memory, writing to one would change them all. Call `.copy()` if you need an independent, writable array.

> **In the wild:** PyTorch and JAX use exactly the same broadcasting rules, so everything in this lesson transfers directly to deep learning code. In pandas, `df - df.mean()` broadcasts per column by aligning labels instead of positions.

## Recap

- Broadcasting combines arrays of different shapes by **stretching size-1 (or missing) dimensions**, with no copying.
- Rules: **align shapes from the right**; each pair of dimensions must be **equal or include a 1**.
- One value **per row** means shape `(n, 1)`: use `[:, None]`, `reshape(-1, 1)` or `keepdims=True`.
- Square matrices can hide bugs: `(n,)` silently lines up with the **columns**. Test on non-square data.
- Column ⊗ row gives an outer table. `a[:, None, :] - b[None, :, :]` gives every pairwise difference.
- Use `np.broadcast_shapes` to check shapes, and read "could not be broadcast" errors right to left.

**Up next:** aggregations and the `axis` argument, so you''ll know exactly which way `sum`, `mean` and `argmax` collapse your data.
', 0, '[]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_5_3', 'sec_numpy_5', 'crs_numpy_mastery', 'Aggregations and the axis argument', 'interactive', 2, 1080, NULL, NULL, 'Data analysis is mostly about **summarizing**: total revenue, average score, the busiest hour, the best-performing region. In NumPy these summaries are called **aggregations** (or *reductions*), because they reduce many numbers to fewer numbers.

The functions themselves are easy: `sum`, `mean`, `max`. The hard part, and the one that separates confident NumPy users from everyone else, is the **`axis` argument**. Get it right and you can summarize a 3-D dataset in one line. Get it wrong and you''ll silently average the wrong thing. This lesson gives you a mental model for `axis` that never fails.

## The core aggregations

On a 1-D array, every aggregation collapses all the values into a single result.

```python run
import numpy as np

steps = np.array([8_200, 10_450, 6_300, 12_900, 9_100, 4_800, 11_250])   # one week

print("total:  ", steps.sum())
print("mean:   ", steps.mean().round(1))
print("std:    ", steps.std().round(1))
print("min/max:", steps.min(), steps.max())
print("argmax: ", steps.argmax(), "(the position of the max: day 3)")
print("product of [1..5]:", np.arange(1, 6).prod())
```

Each one exists both as a method (`steps.sum()`) and as a function (`np.sum(steps)`). They''re identical, so use whichever reads better. Note the difference between `max` (the largest **value**) and `argmax` (**where** it is). The `arg` functions return indices, which you can use to look up other information:

```python run
days = np.array(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"])
print("Most active day:", days[steps.argmax()])
print("Laziest day:    ", days[steps.argmin()])
```

## The axis argument: "the axis you collapse"

Now a 2-D dataset: weekly sales for 4 weeks (rows) across 3 regions (columns).

```python run
sales = np.array([[120,  95, 210],    # week 0
                  [135, 110, 190],    # week 1
                  [150,  90, 230],    # week 2
                  [160, 105, 250]])   # week 3
#                 North  South  West

print("shape:", sales.shape)
print("sum()        ->", sales.sum(), "(everything)")
print("sum(axis=0)  ->", sales.sum(axis=0), "(one total per REGION)")
print("sum(axis=1)  ->", sales.sum(axis=1), "(one total per WEEK)")
```

Here''s the mental model: **`axis` is the dimension that disappears.**

- `sales` has shape `(4, 3)`: axis 0 has length 4 (weeks), axis 1 has length 3 (regions).
- `sum(axis=0)` collapses axis 0, the weeks. The weeks get added together, leaving shape `(3,)`: one number per region.
- `sum(axis=1)` collapses axis 1, the regions, leaving shape `(4,)`: one number per week.

To predict the result''s shape, take the input shape and **delete** the axis you pass. `(4, 3)` with `axis=0` → `(3,)`. With `axis=1` → `(4,)`.

> **Tip:** say it out loud as "sum **over** the weeks" (axis 0) or "sum **over** the regions" (axis 1). You name the thing that gets used up, not the thing that''s left.

This works in any number of dimensions:

```python run
# 7 days x 24 hours x 3 sensors of temperature readings
rng = np.random.default_rng(42)
temps = rng.normal(20, 3, size=(7, 24, 3))

print("per day & sensor (avg over hours):", temps.mean(axis=1).shape)
print("per hour & sensor (avg over days):", temps.mean(axis=0).shape)
print("per sensor (avg over days AND hours):", temps.mean(axis=(0, 1)).round(2))
print("negative axes count from the end:", temps.mean(axis=-1).shape)
```

Pass a **tuple** of axes to collapse several at once, as in `axis=(0, 1)` above. `axis=-1` always means "the last axis", which is handy when you don''t want to count dimensions.

```python predict id=predict-axis-shape title="Which dimension disappears?"
data = np.ones((2, 3, 4))
print(data.sum(axis=1).shape)
--- options
(3,)
(2, 3)
* (2, 4)
(3, 4)
--- explain
Delete the axis you pass. Start from `(2, 3, 4)` and remove axis 1 (the `3`), which leaves `(2, 4)`. Each of those 8 numbers is a sum of 3 values.
```

```python exercise id=region-report title="The regional sales report"
sales = np.array([[120,  95, 210],
                  [135, 110, 190],
                  [150,  90, 230],
                  [160, 105, 250]])   # rows = weeks 0-3, columns = North, South, West
regions = np.array(["North", "South", "West"])

# TODO 1: `region_totals` = total sales for each region over all 4 weeks (shape (3,)).
region_totals = ...

# TODO 2: `weekly_avg` = average sales per region for each week (shape (4,)).
weekly_avg = ...

# TODO 3: `top_region_each_week` = the NAME of the best-selling region in each week
#         (an array of 4 strings). Use argmax and index into `regions`.
top_region_each_week = ...
--- solution
sales = np.array([[120,  95, 210],
                  [135, 110, 190],
                  [150,  90, 230],
                  [160, 105, 250]])
regions = np.array(["North", "South", "West"])

region_totals = sales.sum(axis=0)
weekly_avg = sales.mean(axis=1)
top_region_each_week = regions[sales.argmax(axis=1)]
--- test
assert region_totals is not ..., "Replace the `...` after `region_totals =` with your code."
assert weekly_avg is not ..., "Replace the `...` after `weekly_avg =` with your code."
assert top_region_each_week is not ..., "Replace the `...` after `top_region_each_week =` with your code."
region_totals = np.asarray(region_totals)
assert region_totals.shape == (3,), f"`region_totals` should have one value per region (shape (3,)), but has shape {region_totals.shape}. Which axis holds the weeks?"
assert np.array_equal(region_totals, [565, 400, 880]), f"`region_totals` should be [565, 400, 880], got {region_totals}."
weekly_avg = np.asarray(weekly_avg)
assert weekly_avg.shape == (4,), f"`weekly_avg` should have one value per week (shape (4,)), but has shape {weekly_avg.shape}."
assert np.allclose(weekly_avg, sales.mean(axis=1)), f"`weekly_avg` should be the mean across the 3 regions for each week, got {weekly_avg}."
top = np.asarray(top_region_each_week)
assert top.shape == (4,), f"`top_region_each_week` should have one name per week (shape (4,)), but has shape {top.shape}."
assert top.dtype.kind == "U", "`top_region_each_week` should contain region names (strings), not indices. Use the indices from argmax to index `regions`."
assert top.tolist() == ["West"] * 4, f"Expected the best region in each week, got {top.tolist()}."
--- hint
Weeks are axis 0 and regions are axis 1. To get one number *per region*, collapse the weeks.
--- hint
`sales.sum(axis=0)`, `sales.mean(axis=1)`, and `regions[sales.argmax(axis=1)]`. argmax returns positions, and indexing `regions` with them turns positions into names.
```

## argmax on a 2-D array

Without an `axis`, `argmax` treats the array as if it were flattened into 1-D, and returns a single **flat** index. To turn it back into a `(row, col)` position, use `np.unravel_index`:

```python run
flat_idx = sales.argmax()
print("flat index:", flat_idx)
row, col = np.unravel_index(flat_idx, sales.shape)
print(f"best single cell: week {row}, region {col} -> {sales[row, col]}")
print("best week per region:", sales.argmax(axis=0))
```

## keepdims: aggregate, then broadcast back

Often you aggregate only to **combine the result with the original data**: dividing by a row total, subtracting a column mean, comparing to a row maximum. That''s broadcasting, and as you saw last lesson, per-row results need shape `(n, 1)`.

`keepdims=True` keeps the collapsed axis as a size-1 dimension, so the result broadcasts straight back against the original:

```python run
print(sales.max(axis=1).shape)                  # (4,)
print(sales.max(axis=1, keepdims=True).shape)   # (4, 1)

# How far below its week''s best region is each region?
gap = sales.max(axis=1, keepdims=True) - sales
gap
```

```python exercise id=row-scaling title="Scale each student''s scores"
# Rows = 4 students, columns = 5 quizzes (scores out of 20).
scores = np.array([[12, 15,  9, 18, 14],
                   [20, 19, 17, 20, 18],
                   [ 5,  8, 11,  7,  9],
                   [14, 14, 16, 12, 19]])

# TODO: `relative` = each score divided by that STUDENT''S best score, so every
# student''s best quiz becomes 1.0. Use .max(..., keepdims=True) and broadcasting.
relative = ...
--- solution
scores = np.array([[12, 15,  9, 18, 14],
                   [20, 19, 17, 20, 18],
                   [ 5,  8, 11,  7,  9],
                   [14, 14, 16, 12, 19]])

relative = scores / scores.max(axis=1, keepdims=True)
--- test
assert relative is not ..., "Replace the `...` after `relative =` with your code."
assert isinstance(relative, np.ndarray), "`relative` should be a NumPy array."
assert relative.shape == (4, 5), f"`relative` should keep the shape (4, 5), but has {relative.shape}."
assert np.allclose(relative.max(axis=1), 1.0), f"Each student''s best score should become 1.0, but the row maximums are {relative.max(axis=1).round(3)}. Are you dividing by each ROW''s max?"
assert np.allclose(relative, scores / scores.max(axis=1)[:, None]), "Divide every score by its own student''s (row''s) maximum."
--- hint
The maximum *per student* means collapsing the quizzes, which is axis 1.
--- hint
`scores.max(axis=1, keepdims=True)` has shape `(4, 1)`, which broadcasts across the 5 quizzes.
```

```python debug id=student-averages title="One average per student, please"
# 5 students (rows) x 3 exams (columns)
scores = np.array([[78, 85, 90],
                   [62, 70, 58],
                   [95, 98, 92],
                   [88, 79, 84],
                   [70, 65, 80]])
names = ["Ana", "Ben", "Cleo", "Dev", "Eli"]

student_avg = scores.mean(axis=0)

for name, avg in zip(names, student_avg):
    print(f"{name}: {avg:.1f}")
--- solution
scores = np.array([[78, 85, 90],
                   [62, 70, 58],
                   [95, 98, 92],
                   [88, 79, 84],
                   [70, 65, 80]])
names = ["Ana", "Ben", "Cleo", "Dev", "Eli"]

student_avg = scores.mean(axis=1)

for name, avg in zip(names, student_avg):
    print(f"{name}: {avg:.1f}")
--- test
student_avg = np.asarray(student_avg)
assert student_avg.shape == (5,), f"There are 5 students, so `student_avg` should have 5 values, but it has shape {student_avg.shape}. Which axis did you collapse?"
assert np.allclose(student_avg, [84.333333, 63.333333, 95.0, 83.666667, 71.666667]), f"Each value should be one student''s mean over the 3 exams, got {student_avg.round(2)}."
assert "Eli" in _stdout, "Every student, including Eli, should be printed."
--- hint
Run it. Only 3 names are printed, and `zip` quietly stopped early. How many averages did you compute, and why 3?
--- hint
`axis=0` collapses the *students* (rows), giving one value per exam. To average each student''s exams, collapse axis 1.
```

## Running totals: cumsum and cumprod

Sometimes you want every intermediate result, not just the final total. `cumsum` gives a running sum and `cumprod` a running product. Both accept `axis` too.

```python run
deposits = np.array([100, 50, 0, 200, 75])
print("balance after each deposit:", deposits.cumsum())

# Daily returns of an investment: +2%, -1%, +3%, ...
returns = np.array([0.02, -0.01, 0.03, -0.02, 0.01])
growth = (1 + returns).cumprod()
print("value of $1 over time:", growth.round(4))
print(f"total return: {growth[-1] - 1:.2%}")
```

`cumprod` is the right tool for **compounding**: returns multiply, they don''t add. Summing the returns (+3%) gives a slightly wrong answer compared with the true compounded return.

```python exercise id=compound-growth title="Track a portfolio"
start_value = 10_000.0
monthly_returns = np.array([0.04, -0.02, 0.015, 0.03, -0.05, 0.02])

# TODO 1: `values` = portfolio value at the END of each month (shape (6,)),
#         compounding the returns from start_value. Use cumprod.
values = ...

# TODO 2: `best_month` = index of the month with the highest end-of-month value.
best_month = ...
--- solution
start_value = 10_000.0
monthly_returns = np.array([0.04, -0.02, 0.015, 0.03, -0.05, 0.02])

values = start_value * (1 + monthly_returns).cumprod()
best_month = values.argmax()
--- test
assert values is not ..., "Replace the `...` after `values =` with your code."
assert best_month is not ..., "Replace the `...` after `best_month =` with your code."
values = np.asarray(values, dtype=float)
assert values.shape == (6,), f"`values` should have one value per month (shape (6,)), but has shape {values.shape}."
expected = 10_000.0 * np.cumprod(1 + np.array([0.04, -0.02, 0.015, 0.03, -0.05, 0.02]))
assert not np.allclose(values, 10_000.0 + 10_000.0 * np.cumsum(monthly_returns)), "It looks like you added the returns. Returns compound: multiply the growth factors (1 + r) instead."
assert np.allclose(values, expected), f"After month 0 the value should be {expected[0]:.2f}; your values are {values.round(2)}."
assert int(best_month) == 3, f"`best_month` should be the index of the highest value, got {best_month!r}."
--- hint
A +4% month multiplies the value by 1.04. Build the growth factors with `1 + monthly_returns`.
--- hint
`start_value * (1 + monthly_returns).cumprod()` gives the value after each month. Then `argmax`.
```

## Differences: np.diff

`np.diff` does the opposite of `cumsum`: it computes the change between **consecutive** elements, so the result is one element shorter.

```python run
balance = np.array([100, 150, 150, 350, 425])
print("changes:", np.diff(balance))                  # 4 values from 5
print("back to deposits:", np.diff(balance, prepend=0))
print("second difference:", np.diff(balance, n=2))   # change of the change
```

`prepend=0` pads the front so the output has the same length as the input. Combining `cumsum` and `diff` lets you move between "totals" and "increments" at will.

```python debug id=pct-change title="Day-over-day percent change"
prices = np.array([50.0, 52.0, 49.4, 51.87, 54.46])

# Percent change from each day to the next: (today - yesterday) / yesterday * 100
pct = np.diff(prices) / prices * 100
print(pct.round(2))
--- solution
prices = np.array([50.0, 52.0, 49.4, 51.87, 54.46])

pct = np.diff(prices) / prices[:-1] * 100
print(pct.round(2))
--- test
pct = np.asarray(pct)
assert pct.shape == (4,), f"5 prices give 4 day-over-day changes, so `pct` should have shape (4,), but has {pct.shape}."
assert np.allclose(pct, [4.0, -5.0, 5.0, 4.99325236]), f"The first change should be +4% (50 -> 52), got {pct.round(2)}. Are you dividing by *yesterday''s* price?"
--- hint
Run it and read the error: `np.diff(prices)` has 4 elements but `prices` has 5.
--- hint
Each change should be divided by the price it started from, which is every price except the last: `prices[:-1]`.
```

## Standard deviation and ddof

There are two formulas for standard deviation. The *population* std divides by $n$; the *sample* std divides by $n - 1$, which corrects the bias when your data is a sample from a bigger population:

$$
\sigma = \sqrt{\frac{1}{n - \text{ddof}} \sum_i (x_i - \bar{x})^2}
$$

NumPy defaults to `ddof=0` (population). pandas and most statistics textbooks default to `ddof=1`. Mixing them up is a classic reason why "my NumPy and pandas numbers don''t match".

```python run
x = np.array([4.0, 8.0, 6.0, 5.0, 7.0])
print("np.std (ddof=0):", x.std().round(4))
print("sample  (ddof=1):", x.std(ddof=1).round(4))
print("var with ddof=1:", x.var(ddof=1))
```

> **In the wild:** `df.std()` in pandas uses `ddof=1`. If you need NumPy to agree with it, pass `ddof=1` explicitly. scikit-learn''s `StandardScaler` uses `ddof=0`.

## Recap

- Aggregations (`sum`, `mean`, `std`, `min`, `max`, `prod`) collapse values; `argmin`/`argmax` return **positions**.
- **`axis` is the dimension that disappears.** Delete it from the shape to predict the result. Use a tuple to collapse several; `-1` means the last axis.
- Without `axis`, `argmax` returns a flat index; `np.unravel_index` converts it back to coordinates.
- `keepdims=True` keeps a size-1 axis so the result broadcasts back against the original.
- `cumsum`/`cumprod` keep running results (use `cumprod` for compounding); `np.diff` gives consecutive changes.
- `std` uses `ddof=0` by default; pandas uses `ddof=1`.

**Up next:** putting it all together. You''ll turn slow Python loops into fast vectorized NumPy code, step by step.
', 0, '[]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_5_4', 'sec_numpy_5', 'crs_numpy_mastery', 'From loops to vectorized code', 'interactive', 3, 1080, NULL, NULL, 'You now know all the ingredients: ufuncs, broadcasting, masks and aggregations. This lesson is about the **skill** that combines them: looking at a Python loop and rewriting it as a handful of whole-array operations. That''s what "vectorized code" means, and it''s the single biggest difference between NumPy code that crawls and NumPy code that flies.

You''ll learn a repeatable recipe for translating loops, measure the speedups yourself, and work through the classics every data scientist writes eventually: conditional logic with `np.where`, moving averages, a numerically stable softmax and one-hot encoding. You''ll also learn when *not* to bother, because some loops are perfectly fine.

## How big is the difference?

Let''s measure it. Both versions compute the sum of squares of 50,000 numbers.

```python run
import numpy as np
import time

x = np.random.default_rng(0).random(50_000)

t0 = time.perf_counter()
total = 0.0
for value in x:
    total += value * value
loop_s = time.perf_counter() - t0

t0 = time.perf_counter()
total_vec = np.sum(x * x)
vec_s = time.perf_counter() - t0

print(f"loop:       {loop_s * 1000:8.2f} ms  -> {total:.4f}")
print(f"vectorized: {vec_s * 1000:8.2f} ms  -> {total_vec:.4f}")
print(f"speedup:    {loop_s / vec_s:8.0f}x")
```

The exact numbers depend on your machine (and Python here runs inside your browser), but the gap is almost always **dozens to hundreds of times**. The loop pays Python''s interpreter overhead for each of the 50,000 elements; the vectorized version makes a couple of calls and loops in C.

> **Tip:** `time.perf_counter()` is the right clock for measuring short durations. For serious benchmarks, repeat the measurement several times and take the best. The first run often includes one-off warm-up costs.

## The translation recipe

Almost every numeric loop can be translated with four moves:

| In the loop you see… | Replace it with… |
|---|---|
| arithmetic on one element (`x[i] * 2 + 1`) | the same arithmetic on the whole array (`x * 2 + 1`) |
| `if` / `else` choosing a value | `np.where(condition, a, b)` or a boolean mask |
| an accumulator (`total += …`, `best = max(best, …)`) | a reduction (`.sum()`, `.max()`, `.argmax()`) |
| a running value (`running += x[i]; out.append(running)`) | a cumulative op (`.cumsum()`, `np.maximum.accumulate`) |
| a nested loop over pairs | broadcasting (`a[:, None] - b`) |

Let''s apply it. Here''s a shipping-cost calculator written the "Python way":

```python run
weights = np.array([0.4, 2.5, 7.0, 1.2, 12.5, 4.8])   # kg

def shipping_loop(weights):
    costs = []
    for w in weights:
        if w <= 1:
            costs.append(4.99)              # flat rate for small parcels
        else:
            costs.append(4.99 + 1.5 * (w - 1))
    return np.array(costs)

def shipping_vec(weights):
    return np.where(weights <= 1, 4.99, 4.99 + 1.5 * (weights - 1))

print(shipping_loop(weights))
print(shipping_vec(weights))
print("same?", np.allclose(shipping_loop(weights), shipping_vec(weights)))
```

`np.where(cond, a, b)` is the vectorized `if/else`: wherever `cond` is `True` it picks from `a`, otherwise from `b`. All three arguments broadcast, so `a` and `b` can be scalars or arrays.

> **Pitfall:** `np.where` evaluates **both** branches for every element and then picks. If a branch could fail (like dividing by zero or taking `log(0)`), it still runs and still warns. In that case, use the `where=` argument from the ufuncs lesson instead.

```python predict id=predict-where title="What does np.where return?"
temps = np.array([12, 25, 31, 18])
print(np.where(temps > 20, "warm", "cool"))
--- options
[''cool'' ''warm'']
* [''cool'' ''warm'' ''warm'' ''cool'']
[1 2]
[False  True  True False]
--- explain
With three arguments, `np.where` returns an array the same shape as the condition, choosing `"warm"` where it''s `True` and `"cool"` where it''s `False`. (With only one argument, `np.where(temps > 20)` would instead return the **indices** of the `True` values: `(array([1, 2]),)`.)
```

## More than two choices: np.select

For multi-way branching (`if / elif / elif / else`), nesting `np.where` gets ugly fast. `np.select` takes a list of conditions and a matching list of choices; the **first** true condition wins.

```python run
scores = np.array([95, 82, 67, 74, 58, 88])

conditions = [scores >= 90, scores >= 80, scores >= 70, scores >= 60]
choices = ["A", "B", "C", "D"]
grades = np.select(conditions, choices, default="F")
grades
```

```python exercise id=vectorize-tax title="Vectorize the tax calculator"
def tax_loop(incomes):
    """Reference implementation: progressive tax, one person at a time."""
    out = []
    for income in incomes:
        if income <= 10_000:
            tax = 0.0
        elif income <= 40_000:
            tax = (income - 10_000) * 0.20
        else:
            tax = 30_000 * 0.20 + (income - 40_000) * 0.40
        out.append(tax)
    return np.array(out)

# TODO: implement tax_vec(incomes) so it returns exactly what tax_loop returns,
# for an ARRAY of incomes, without any Python loop (no for, no list comprehension).
# np.select or nested np.where both work.
def tax_vec(incomes):
    incomes = np.asarray(incomes, dtype=float)
    ...

print(tax_vec(np.array([8_000, 25_000, 40_000, 100_000])))
--- solution
def tax_loop(incomes):
    out = []
    for income in incomes:
        if income <= 10_000:
            tax = 0.0
        elif income <= 40_000:
            tax = (income - 10_000) * 0.20
        else:
            tax = 30_000 * 0.20 + (income - 40_000) * 0.40
        out.append(tax)
    return np.array(out)

def tax_vec(incomes):
    incomes = np.asarray(incomes, dtype=float)
    return np.select(
        [incomes <= 10_000, incomes <= 40_000],
        [0.0, (incomes - 10_000) * 0.20],
        default=30_000 * 0.20 + (incomes - 40_000) * 0.40,
    )

print(tax_vec(np.array([8_000, 25_000, 40_000, 100_000])))
--- test
import inspect
probe = np.array([0, 9_999, 10_000, 10_001, 25_000, 40_000, 40_001, 123_456.0])
res = tax_vec(probe)
assert res is not None, "`tax_vec` returned None. Don''t forget the `return` statement."
res = np.asarray(res, dtype=float)
assert res.shape == probe.shape, f"`tax_vec` should return one tax per income (shape {probe.shape}), but returned shape {res.shape}."
assert np.allclose(res, tax_loop(probe)), f"For incomes {probe.tolist()} the taxes should be {tax_loop(probe).tolist()}, but tax_vec returned {res.tolist()}."
rng = np.random.default_rng(7)
fresh = rng.uniform(0, 200_000, 500)
assert np.allclose(tax_vec(fresh), tax_loop(fresh)), "tax_vec matches on the example incomes but not on random ones. Check each bracket''s formula."
src = inspect.getsource(tax_vec)
assert " for " not in src and "\tfor " not in src and "while" not in src, "`tax_vec` still contains a loop. Express the brackets with np.select or np.where instead."
--- hint
Translate each branch into an array expression: the condition becomes a boolean array, and each `tax = ...` becomes a whole-array formula.
--- hint
`np.select([incomes <= 10_000, incomes <= 40_000], [0.0, (incomes - 10_000) * 0.20], default=...)`. Conditions are checked in order, so the second one only applies to incomes above 10,000.
```

```python debug id=and-vs-amp title="The working-age filter crashes"
ages = np.array([12, 19, 35, 64, 70, 41, 17])
salaries = np.array([0, 18_000, 52_000, 61_000, 0, 75_000, 4_000])

# Working age is 18 to 64 inclusive. Count workers and their average salary.
working = (ages >= 18) and (ages <= 64)

print("working-age people:", working.sum())
print("average salary:", salaries[working].mean())
--- solution
ages = np.array([12, 19, 35, 64, 70, 41, 17])
salaries = np.array([0, 18_000, 52_000, 61_000, 0, 75_000, 4_000])

working = (ages >= 18) & (ages <= 64)

print("working-age people:", working.sum())
print("average salary:", salaries[working].mean())
--- test
working = np.asarray(working)
assert working.dtype == bool and working.shape == ages.shape, f"`working` should be a boolean array with one entry per person, got dtype {working.dtype} and shape {working.shape}."
assert working.tolist() == [False, True, True, True, False, True, False], f"`working` marks the wrong people: {working.tolist()}. Ages 18 to 64 inclusive count."
assert "51500" in _stdout.replace(",", ""), "Print the average salary of the working-age people (it should be 51500.0)."
--- hint
Run it and read the error. Python''s `and` needs a single True/False, but each comparison produces a whole array.
--- hint
Use the element-wise operator `&` instead of `and`, and keep the parentheses around each comparison.
```

## Running computations: the moving average

A **moving average** smooths noisy data by averaging each window of `k` consecutive values. The loop version re-adds `k` numbers for every window. There''s a beautiful vectorized trick using `cumsum`: the sum of any window is the difference of two cumulative sums.

$$
\text{window sum}(i, i+k) = C_{i+k} - C_i, \quad \text{where } C = [0, x_0, x_0 + x_1, \dots]
$$

```python run
x = np.array([3.0, 5.0, 4.0, 8.0, 6.0, 9.0, 7.0, 10.0])
k = 3

# Loop version
loop_ma = np.array([x[i:i + k].mean() for i in range(len(x) - k + 1)])

# Vectorized: one cumsum, one subtraction, one division
c = np.concatenate([[0.0], np.cumsum(x)])
vec_ma = (c[k:] - c[:-k]) / k

print("loop:      ", loop_ma.round(3))
print("vectorized:", vec_ma.round(3))
```

Each window costs one subtraction no matter how big `k` is. With a window of 1,000 points, that''s 1,000 times less work than re-summing.

```python exercise id=moving-average title="Smooth a noisy signal"
# TODO: implement moving_average(x, k) returning the mean of every window of k
# consecutive values (so the result has len(x) - k + 1 values).
# Use the cumsum trick: no Python loops.
def moving_average(x, k):
    x = np.asarray(x, dtype=float)
    ...

print(moving_average([1, 2, 3, 4, 5, 6], 2))   # expect [1.5 2.5 3.5 4.5 5.5]
--- solution
def moving_average(x, k):
    x = np.asarray(x, dtype=float)
    c = np.concatenate([[0.0], np.cumsum(x)])
    return (c[k:] - c[:-k]) / k

print(moving_average([1, 2, 3, 4, 5, 6], 2))
--- test
import inspect
out = moving_average([1, 2, 3, 4, 5, 6], 2)
assert out is not None, "`moving_average` returned None. Did you forget `return`?"
out = np.asarray(out, dtype=float)
assert out.shape == (5,), f"6 values with k=2 give 5 windows, so the result should have shape (5,), but has {out.shape}."
assert np.allclose(out, [1.5, 2.5, 3.5, 4.5, 5.5]), f"moving_average([1..6], 2) should be [1.5 2.5 3.5 4.5 5.5], got {out}."
sig = np.random.default_rng(3).normal(size=200)
for k in (1, 5, 17):
    ref = np.convolve(sig, np.ones(k) / k, mode="valid")
    got = np.asarray(moving_average(sig, k), dtype=float)
    assert got.shape == ref.shape and np.allclose(got, ref), f"With k={k} on a 200-point signal, the result should have {ref.size} values matching each window''s mean."
src = inspect.getsource(moving_average)
assert " for " not in src and "while" not in src, "`moving_average` still contains a loop. Use the cumsum trick instead."
--- hint
Build `c` = a 0 followed by `np.cumsum(x)`. Then the sum of the window starting at `i` is `c[i + k] - c[i]`.
--- hint
`c[k:]` lines up every window''s end with `c[:-k]`, every window''s start. Subtract them and divide by `k`.
```

## Softmax: vectorized and numerically stable

Softmax turns a vector of scores into probabilities. It''s used at the end of almost every classification network:

$$
\text{softmax}(z)_i = \frac{e^{z_i}}{\sum_j e^{z_j}}
$$

Vectorized, it''s two lines. There''s a catch, though: `np.exp` overflows to `inf` for inputs above about 709, and `inf / inf` is `nan`. The standard fix exploits the fact that softmax doesn''t change if you subtract the same constant from every score, so you subtract the **maximum** first.

```python run
def softmax(z):
    z = np.asarray(z, dtype=float)
    e = np.exp(z - z.max(axis=-1, keepdims=True))   # largest exponent becomes e^0 = 1
    return e / e.sum(axis=-1, keepdims=True)

print(softmax([2.0, 1.0, 0.1]).round(3))
print(softmax([1000.0, 999.0, 998.1]).round(3))   # same differences -> same answer

# Works on a whole batch at once: one row per example
batch = np.array([[2.0, 1.0, 0.1],
                  [0.0, 0.0, 0.0]])
softmax(batch).round(3)
```

Thanks to `axis=-1` and `keepdims=True`, the same function handles a single vector or a batch of thousands of rows.

```python debug id=softmax-overflow title="Softmax returns nan"
def softmax(z):
    z = np.asarray(z, dtype=float)
    e = np.exp(z)
    return e / e.sum()

logits = np.array([800.0, 805.0, 790.0])   # large raw scores from a model
probs = softmax(logits)
print("probabilities:", probs)
print("sum:", probs.sum())
--- solution
def softmax(z):
    z = np.asarray(z, dtype=float)
    e = np.exp(z - z.max())
    return e / e.sum()

logits = np.array([800.0, 805.0, 790.0])
probs = softmax(logits)
print("probabilities:", probs)
print("sum:", probs.sum())
--- test
with np.errstate(all="ignore"):
    p = np.asarray(softmax(np.array([800.0, 805.0, 790.0])), dtype=float)
    small = np.asarray(softmax(np.array([1.0, 2.0, 3.0])), dtype=float)
assert not np.isnan(p).any(), f"softmax still produces nan for large inputs: {p}. np.exp(800) overflows to inf."
assert np.isclose(p.sum(), 1.0), f"The probabilities should sum to 1, but they sum to {p.sum()}."
ref = np.exp(np.array([-5.0, 0.0, -15.0])) / np.exp(np.array([-5.0, 0.0, -15.0])).sum()
assert np.allclose(p, ref, atol=1e-9), f"Expected about [0.0067, 0.9933, 0.0000003], got {p}."
assert np.allclose(small, np.exp([1.0, 2.0, 3.0]) / np.exp([1.0, 2.0, 3.0]).sum()), "Your fix changed the result for ordinary inputs. Softmax must still give the same probabilities."
--- hint
Run it: `np.exp(800)` is too big for a float64 and becomes `inf`. What can you subtract from every score without changing the softmax result?
--- hint
Subtract the largest score first: `np.exp(z - z.max())`. The biggest exponent becomes `e^0 = 1`, so nothing overflows.
```

## One-hot encoding

Machine-learning models usually need categories as **one-hot** vectors: class `2` out of 4 becomes `[0, 0, 1, 0]`. With broadcasting, you compare every label against every possible class at once.

```python run
labels = np.array([2, 0, 3, 1, 2])
n_classes = 4

# Compare a column of labels against a row of class ids -> (5, 4) boolean table
one_hot = (labels[:, None] == np.arange(n_classes)).astype(int)
print(one_hot)

# Equivalent trick: pick rows of the identity matrix
print(np.array_equal(one_hot, np.eye(n_classes, dtype=int)[labels]))
```

```python exercise id=one-hot-decode title="Encode and decode classes"
labels = np.array([1, 4, 0, 4, 2, 3])
n_classes = 5

# TODO 1: `encoded` = one-hot encoding of `labels` as an INTEGER array of shape (6, 5).
encoded = ...

# TODO 2: `decoded` = turn `encoded` back into the original labels (shape (6,)).
#         Each row has a single 1: find its position.
decoded = ...
--- solution
labels = np.array([1, 4, 0, 4, 2, 3])
n_classes = 5

encoded = (labels[:, None] == np.arange(n_classes)).astype(int)
decoded = encoded.argmax(axis=1)
--- test
assert encoded is not ..., "Replace the `...` after `encoded =` with your code."
assert decoded is not ..., "Replace the `...` after `decoded =` with your code."
encoded = np.asarray(encoded)
assert encoded.shape == (6, 5), f"`encoded` should have one row per label and one column per class (shape (6, 5)), but has {encoded.shape}."
assert encoded.dtype.kind in "iu", f"`encoded` should hold integers (0 and 1), but has dtype {encoded.dtype}. Try .astype(int)."
assert np.array_equal(encoded, np.eye(5, dtype=int)[[1, 4, 0, 4, 2, 3]]), "Each row of `encoded` should have a single 1, in the column given by its label."
decoded = np.asarray(decoded)
assert decoded.shape == (6,), f"`decoded` should have one label per row (shape (6,)), but has {decoded.shape}. Did you use axis=1?"
assert np.array_equal(decoded, labels), f"`decoded` should give back {labels.tolist()}, got {decoded.tolist()}."
--- hint
For encoding, compare `labels[:, None]` (a column) with `np.arange(n_classes)` (a row) and convert the boolean table to integers.
--- hint
To decode, find where the 1 is in each row: `encoded.argmax(axis=1)`.
```

## np.vectorize is not vectorization

NumPy ships a function called `np.vectorize` that wraps a scalar Python function so it accepts arrays. It''s convenient, but the name is misleading: **it''s still a Python loop under the hood**.

```python run
def clamp_score(s):
    return 0 if s < 0 else (100 if s > 100 else s)

scores = np.random.default_rng(1).normal(50, 40, 50_000)
clamp_v = np.vectorize(clamp_score)

t0 = time.perf_counter(); a = clamp_v(scores); t_vec = time.perf_counter() - t0
t0 = time.perf_counter(); b = np.clip(scores, 0, 100); t_clip = time.perf_counter() - t0

print(f"np.vectorize: {t_vec * 1000:7.1f} ms")
print(f"np.clip:      {t_clip * 1000:7.1f} ms")
print("same result?", np.allclose(a, b))
```

Use `np.vectorize` for convenience on small data, or to apply a genuinely complicated function you can''t express with array operations. Don''t expect it to be fast.

## When loops are fine

Vectorization isn''t a religion. Keep the loop when:

- **Each step depends on the previous result** in a way no cumulative function covers, like a simulation where tomorrow''s state is a nonlinear function of today''s. Loop over *time*, but vectorize *within* each step.
- **The data is tiny.** A loop over 10 items costs microseconds; clarity wins.
- **The vectorized version needs a gigantic temporary array.** Broadcasting a `(100_000, 100_000)` distance matrix would need 80 GB. Process it in chunks inside a loop.

```python run
# A loop over TIME with vectorized work inside: 1,000 random walkers, 50 steps
rng = np.random.default_rng(0)
positions = np.zeros(1_000)
for step in range(50):                       # loop over time is fine...
    positions += rng.choice([-1, 1], size=1_000)   # ...each step updates all walkers at once
print("mean position:", positions.mean().round(2), "| spread:", positions.std().round(2))
```

> **In the wild:** this "loop over time, vectorize over the batch" pattern is exactly how neural networks are trained: a Python loop over training steps, with every step processing a whole batch of examples as arrays.

## Recap

- Vectorized code replaces per-element Python work with whole-array operations, often for a **10–100×+** speedup.
- Recipe: element arithmetic → array arithmetic; `if/else` → `np.where` / `np.select`; accumulators → reductions; running values → `cumsum` and friends; nested pair loops → broadcasting.
- Combine conditions with `&`, `|` and `~`, never `and`/`or`.
- The cumsum trick computes any moving window in constant time per window.
- Stable softmax subtracts the max first; one-hot is `labels[:, None] == np.arange(k)`.
- `np.vectorize` is a convenience loop, not a speedup. Loops over time or chunks are fine.

**Up next:** linear algebra. Dot products, the `@` operator and `einsum`, the language of machine learning.
', 0, '[]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_5_5', 'sec_numpy_5', 'crs_numpy_mastery', 'Checkpoint: vectorized computation', 'quiz', 4, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"What is the difference between `np.max(a)` and `np.maximum(a, b)`?","options":["They are aliases for the same function","`np.max` returns the single largest value of `a`; `np.maximum` compares `a` and `b` element by element and returns an array","`np.max` works on 1-D arrays only; `np.maximum` works on any shape","`np.maximum` returns the index of the largest value"],"answerIndex":1,"explanation":"`np.max` is an aggregation that collapses an array, while `np.maximum` is a ufunc that returns the larger of each pair. `np.maximum(z, 0)` is the ReLU activation."},{"id":"q2","prompt":"What shape does `np.ones((5, 1)) + np.ones(3)` produce?","options":["(5, 1)","(3,)","(5, 3)","It raises a broadcasting error"],"answerIndex":2,"explanation":"Align from the right: (5, 1) vs (1, 3). Each pair contains a 1, so both are stretched and the result is (5, 3)."},{"id":"q3","prompt":"`X` has shape (100, 3): 100 samples, 3 features. Which expression subtracts each sample''s (row''s) mean from that row?","options":["X - X.mean(axis=0)","X - X.mean(axis=1)","X - X.mean(axis=1, keepdims=True)","X - X.mean()"],"answerIndex":2,"explanation":"`X.mean(axis=1)` has shape (100,), which can''t broadcast against the 3 columns. `keepdims=True` keeps shape (100, 1), which broadcasts down the rows. `axis=0` would center the columns instead."},{"id":"q4","prompt":"`data` has shape (7, 24, 3). What is the shape of `data.sum(axis=(0, 1))`?","options":["(3,)","(7, 24)","(24, 3)","A single number"],"answerIndex":0,"explanation":"The axis argument names the dimensions that disappear. Removing axes 0 and 1 from (7, 24, 3) leaves (3,), one total per sensor."},{"id":"q5","prompt":"Why does `np.where((age > 18) and (age < 65), 1, 0)` raise an error on an array `age`?","options":["`np.where` needs exactly one argument","Python''s `and` needs a single True/False, but each comparison is a whole boolean array; use `&` instead","Comparisons don''t work on integer arrays","The parentheses are in the wrong place; it should be `age > 18 & age < 65`"],"answerIndex":1,"explanation":"`and`, `or` and `not` ask for the truth value of an entire array, which is ambiguous. Use the element-wise operators `&`, `|` and `~`, and keep the parentheses, because `&` binds more tightly than `>`."},{"id":"q6","prompt":"Why does a numerically stable softmax compute `np.exp(z - z.max())` instead of `np.exp(z)`?","options":["It makes the function faster","Subtracting a constant from every score doesn''t change softmax, and it prevents `np.exp` from overflowing to inf (which would produce nan)","It rounds the probabilities so they sum exactly to 1","It turns the scores into a one-hot vector"],"answerIndex":1,"explanation":"softmax(z) = softmax(z - c) for any constant c. Choosing c = max(z) makes the largest exponent e^0 = 1, so large scores like 800 no longer overflow."},{"id":"q7","prompt":"Which statement about `np.vectorize` is true?","options":["It compiles a Python function to C, making it as fast as a ufunc","It is a convenience wrapper that still calls the Python function once per element","It only works on functions that already use NumPy","It runs the function on multiple CPU cores"],"answerIndex":1,"explanation":"Despite the name, `np.vectorize` is essentially a loop. Real speedups come from expressing the computation with ufuncs, broadcasting and reductions."}]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_numpy_6_1', 'sec_numpy_6', 'crs_numpy_mastery', 'Dot products, @ and einsum', 'interactive', 0, 1080, NULL, NULL, 'Almost every number a machine-learning model produces is a **dot product** at heart. A linear regression prediction, a neural-network layer, a recommendation score, the similarity between two sentence embeddings: each one comes down to multiplying matching entries and adding them up. GPUs exist largely to do this one operation very, very fast.

In this lesson you''ll learn the three tools NumPy gives you for it: the `@` operator, `np.dot`, and the Swiss-army knife `np.einsum`. You''ll also learn the shape rule that makes matrix multiplication predictable instead of mysterious. By the end you''ll write the forward pass of a neural-network layer in a single line.

## The dot product

The dot product of two vectors of the same length multiplies them element by element and sums the result:

$$
\mathbf{a} \cdot \mathbf{b} = \sum_{i=1}^{n} a_i b_i = a_1 b_1 + a_2 b_2 + \dots + a_n b_n
$$

A concrete example: a shopping basket. `prices` holds the price of each item and `quantities` how many you bought. The total bill is their dot product.

```python run
import numpy as np

prices = np.array([2.50, 0.99, 4.25, 1.75])
quantities = np.array([2, 6, 1, 3])

by_hand = (prices * quantities).sum()   # multiply, then add up
with_dot = np.dot(prices, quantities)
with_at = prices @ quantities           # the matrix-multiplication operator

print("by hand: ", by_hand)
print("np.dot:  ", with_dot)
print("@:       ", with_at)
```

All three agree. `prices * quantities` alone is **not** a dot product; it''s the element-wise product, an array of the same length. The dot product is that array *summed*, so it''s a single number.

> **Under the hood:** geometrically, $\mathbf{a} \cdot \mathbf{b} = \lVert\mathbf{a}\rVert \, \lVert\mathbf{b}\rVert \cos\theta$, where $\theta$ is the angle between the vectors. Large and positive means "pointing the same way", zero means perpendicular, and negative means pointing apart. We''ll use this for similarity search later in the lesson.

```python predict id=predict-self-dot title="What does this print?"
a = np.array([1, 2, 3])
print(a @ a)
--- options
[1 4 9]
* 14
6
[[1 2 3]]
--- explain
`a @ a` is the dot product of `a` with itself: $1\cdot1 + 2\cdot2 + 3\cdot3 = 14$. The element-wise product `a * a` would give `[1 4 9]`. A vector dotted with itself is its **squared length**.
```

## `*` versus `@`

This is the single most important distinction in this lesson:

| Operator | Name | What it does | Shapes |
|---|---|---|---|
| `A * B` | element-wise product | multiplies matching entries | must broadcast |
| `A @ B` | matrix product | rows of `A` dotted with columns of `B` | inner dimensions must match |

On matrices the difference is dramatic:

```python run
A = np.array([[1, 2],
              [3, 4]])
B = np.array([[10, 20],
              [30, 40]])

print("A * B (element-wise):")
print(A * B)
print()
print("A @ B (matrix product):")
print(A @ B)
```

Look at the top-left entry of `A @ B`: it''s row 0 of `A` dotted with column 0 of `B`, so $1\cdot10 + 2\cdot30 = 70$. Every entry of a matrix product is one dot product:

$$
(AB)_{ij} = \sum_k A_{ik} B_{kj}
$$

> **Pitfall:** because `A * B` happily runs whenever the shapes broadcast, typing `*` when you meant `@` usually produces **no error**, just wrong numbers. When results look wrong in linear-algebra code, check this first.

## The shape rule

Matrix multiplication has one rule that you should be able to recite in your sleep:

$$
(n, \mathbf{k}) \;@\; (\mathbf{k}, m) \;\longrightarrow\; (n, m)
$$

The **inner** dimensions must match, and they disappear; the **outer** dimensions survive. A matrix times a vector follows the same rule, with the vector acting as a `(k,)` shape:

```python run
X = np.arange(12).reshape(4, 3)   # 4 samples, 3 features
w = np.array([0.5, -1.0, 2.0])    # one weight per feature

print("X shape:", X.shape, " w shape:", w.shape)
print("X @ w  ->", (X @ w).shape)  # (4, 3) @ (3,) -> (4,): one number per sample
X @ w
```

When the inner dimensions don''t match, NumPy tells you exactly which ones disagree:

```python run error
W = np.ones((4, 2))
X @ W    # (4, 3) @ (4, 2): inner dims are 3 and 4
```

Reading that error message is a skill: `size 4 is different from 3` names the two inner dimensions. Usually the fix is to transpose one operand (`X.T`) or to rethink which axis means what.

```python predict id=predict-matmul-shape title="What shape does this produce?"
A = np.ones((2, 3))
B = np.ones((3, 4))
print((A @ B).shape)
--- options
(3, 3)
* (2, 4)
(4, 2)
(2, 3, 4)
--- explain
Apply the rule: $(2, \mathbf{3}) @ (\mathbf{3}, 4) \to (2, 4)$. The matching inner 3s vanish and the outer dimensions survive.
```

### `np.dot` versus `@`

For 1-D and 2-D arrays, `np.dot(A, B)` and `A @ B` give identical results. Prefer `@`: it reads like math, and it has the sensible behavior for stacks of matrices that you''ll see next. `np.dot` treats 3-D arrays in a surprising way that is rarely what you want.

## Challenge: weighted course grades

```python exercise id=weighted-grade title="Compute every student''s final grade"
# Rows are students; columns are: homework, midterm, final exam (out of 100)
scores = np.array([
    [92, 78, 85],
    [65, 88, 72],
    [80, 91, 94],
    [55, 60, 70],
    [99, 95, 89],
])
# Homework counts 20%, the midterm 30%, the final exam 50%
weights = np.array([0.2, 0.3, 0.5])

# TODO: one final grade per student, shape (5,), using a matrix product
grades = ...

# TODO: the index (row number) of the student with the highest grade
top_student = ...
--- solution
scores = np.array([
    [92, 78, 85],
    [65, 88, 72],
    [80, 91, 94],
    [55, 60, 70],
    [99, 95, 89],
])
weights = np.array([0.2, 0.3, 0.5])

grades = scores @ weights
top_student = grades.argmax()
--- test
assert grades is not ..., "Replace the `...` after `grades =` with your code."
assert isinstance(grades, np.ndarray), "`grades` should be a NumPy array."
assert grades.shape == (5,), f"`grades` should have one value per student, shape (5,), but has shape {grades.shape}. Check the order of the operands."
_expected = np.array([84.3, 75.4, 90.3, 64.0, 92.8])
assert np.allclose(grades, _expected), f"`grades` should be the weighted sum of each row. Got {np.round(grades, 2)}."
assert top_student is not ..., "Replace the `...` after `top_student =` with your code."
assert int(top_student) == 4, f"`top_student` should be the row index of the best grade, but it is {top_student!r}."
--- hint
Each final grade is `0.2*homework + 0.3*midterm + 0.5*final`, which is the dot product of a row with `weights`. A matrix product does that for every row at once.
--- hint
Shapes: `(5, 3) @ (3,)` gives `(5,)`. For the second part, remember `argmax` from the aggregations lesson.
```

## Stacks of matrices: batched `@`

In deep learning you rarely multiply just one matrix. You multiply a **batch** of them: one per image, per sentence or per attention head. `@` treats every dimension except the last two as a batch dimension, and those batch dimensions even **broadcast**:

```python run
rng = np.random.default_rng(0)

A = rng.normal(size=(8, 2, 3))   # 8 matrices, each 2x3
B = rng.normal(size=(8, 3, 5))   # 8 matrices, each 3x5
W = rng.normal(size=(3, 5))      # a single 3x5 matrix

print("batch @ batch :", (A @ B).shape)   # pairs them up: 8 products
print("batch @ single:", (A @ W).shape)   # W broadcasts across the batch

# Check one slice by hand
print("slice 3 matches:", np.allclose((A @ B)[3], A[3] @ B[3]))
```

The shape rule still applies to the last two axes, `(2, 3) @ (3, 5) → (2, 5)`, and the leading `8` comes along for the ride.

## Outer products

The dot product collapses two vectors into one number. The **outer product** does the opposite: it expands them into a matrix of every pairwise product, $(\mathbf{a}\mathbf{b}^\top)_{ij} = a_i b_j$.

```python run
a = np.array([1, 2, 3])
b = np.array([10, 20])

print(np.outer(a, b))
print()
# Same thing with broadcasting: a column (3, 1) times a row (1, 2)
print(a[:, None] * b[None, :])
```

A multiplication table is an outer product, and so is a matrix built from "every user times every item" scores.

## `np.einsum`: say exactly what you mean

Einstein summation describes an operation by **labelling the axes** of each input. Repeated labels are multiplied; labels missing from the output are summed. The string `"ij,jk->ik"` reads as: "the first input has axes *i, j*, the second has *j, k*; multiply along the shared *j*, sum it away, and return *i, k*." That''s exactly matrix multiplication.

```python run
M = np.arange(9).reshape(3, 3)
v = np.array([1, 0, 2])

print("sum of all :", np.einsum("ij->", M), "=", M.sum())
print("trace      :", np.einsum("ii->", M), "=", np.trace(M))
print("transpose  :\n", np.einsum("ij->ji", M))
print("mat @ vec  :", np.einsum("ij,j->i", M, v), "=", M @ v)
print("dot        :", np.einsum("i,i->", v, v), "=", v @ v)
print("outer      :\n", np.einsum("i,j->ij", v, v))
```

Once you can read the labels, einsum turns complicated tensor contractions into one readable line. Here''s a batched matrix product with an explicit batch axis `b`:

```python run
A = rng.normal(size=(8, 2, 3))
B = rng.normal(size=(8, 3, 5))

C = np.einsum("bij,bjk->bik", A, B)
print(C.shape, np.allclose(C, A @ B))
```

> **In the wild:** attention in a Transformer is often written as `np.einsum("bhqd,bhkd->bhqk", Q, K)` (batch, heads, queries, keys, head dimension). That''s the same idea with more labels.

| einsum | Equivalent |
|---|---|
| `"i,i->"` | `a @ b` (dot product) |
| `"i,j->ij"` | `np.outer(a, b)` |
| `"ij->ji"` | `M.T` |
| `"ii->"` | `np.trace(M)` |
| `"ij,jk->ik"` | `A @ B` |
| `"ij,ij->i"` | `(A * B).sum(axis=1)` (row-wise dots) |

## Challenge: row-by-row dot products

```python exercise id=rowwise-dots title="Dot each row with its partner"
rng = np.random.default_rng(42)
queries = rng.normal(size=(6, 4))   # 6 query vectors
keys = rng.normal(size=(6, 4))      # 6 key vectors, paired by row

# TODO: scores[i] should be the dot product of queries[i] with keys[i]
# Result shape: (6,). Try np.einsum, but any correct approach works.
scores = ...
--- solution
rng = np.random.default_rng(42)
queries = rng.normal(size=(6, 4))
keys = rng.normal(size=(6, 4))

scores = np.einsum("ij,ij->i", queries, keys)
--- test
assert scores is not ..., "Replace the `...` after `scores =` with your code."
scores = np.asarray(scores)
_expected = (queries * keys).sum(axis=1)
assert scores.shape == (6,), f"`scores` should have one value per row, shape (6,), but has shape {scores.shape}. Note that `queries @ keys.T` computes *every* pair (6x6), not just matching rows."
assert np.allclose(scores, _expected), "`scores[i]` should be the dot product of `queries[i]` with `keys[i]`."
--- hint
You want the *diagonal* of the full pairwise product, but computing all 36 dot products only to keep 6 is wasteful.
--- hint
Multiply element-wise, then sum along the feature axis, or use einsum: both inputs are labelled `ij`, and you keep only `i`.
```

## Cosine similarity

Remember $\mathbf{a}\cdot\mathbf{b} = \lVert\mathbf{a}\rVert\lVert\mathbf{b}\rVert\cos\theta$? Rearranging gives **cosine similarity**, the standard way to compare embeddings in search engines and recommendation systems:

$$
\cos\theta = \frac{\mathbf{a}\cdot\mathbf{b}}{\lVert\mathbf{a}\rVert\,\lVert\mathbf{b}\rVert}
$$

It ranges from $-1$ (opposite) through $0$ (unrelated) to $1$ (same direction), and it ignores length: a vector and its double are perfectly similar.

```python run
v = np.array([1.0, 2.0, 2.0])
print("length of v:", np.sqrt(v @ v))   # 3.0; np.linalg.norm(v) does the same
print("v vs 2v    :", (v @ (2 * v)) / (np.sqrt(v @ v) * np.sqrt((2 * v) @ (2 * v))))
```

```python exercise id=cosine-similarity title="Write a cosine similarity function"
def cosine_similarity(a, b):
    """Return the cosine similarity between 1-D arrays a and b, as a float."""
    # TODO: dot product divided by the product of the two lengths
    ...

# Try it: these two "movie taste" vectors point in similar directions
alice = np.array([5.0, 1.0, 0.0, 4.0])
bob = np.array([4.0, 0.0, 1.0, 5.0])
print(cosine_similarity(alice, bob))
--- solution
def cosine_similarity(a, b):
    """Return the cosine similarity between 1-D arrays a and b, as a float."""
    return float(a @ b / (np.sqrt(a @ a) * np.sqrt(b @ b)))

alice = np.array([5.0, 1.0, 0.0, 4.0])
bob = np.array([4.0, 0.0, 1.0, 5.0])
print(cosine_similarity(alice, bob))
--- test
_r = cosine_similarity(np.array([1.0, 0.0]), np.array([1.0, 0.0]))
assert _r is not None, "`cosine_similarity` returned None. Did you forget `return`?"
assert np.isclose(_r, 1.0), f"Identical vectors should have similarity 1.0, got {_r!r}."
assert np.isclose(cosine_similarity(np.array([1.0, 0.0]), np.array([0.0, 3.0])), 0.0), "Perpendicular vectors should have similarity 0.0."
assert np.isclose(cosine_similarity(np.array([1.0, 2.0]), np.array([-2.0, -4.0])), -1.0), "Opposite vectors should have similarity -1.0."
assert np.isclose(cosine_similarity(np.array([3.0, 4.0]), np.array([6.0, 8.0])), 1.0), "Length shouldn''t matter: a vector and its double have similarity 1.0. Are you dividing by both lengths?"
_rng = np.random.default_rng(7)
for _ in range(5):
    _a, _b = _rng.normal(size=10), _rng.normal(size=10)
    _want = _a @ _b / (np.linalg.norm(_a) * np.linalg.norm(_b))
    assert np.isclose(cosine_similarity(_a, _b), _want), "Your function gives the wrong answer on random vectors."
--- hint
You need three dot products: `a @ b`, `a @ a` and `b @ b`. The length of a vector is the square root of its dot product with itself.
--- hint
`return (a @ b) / (np.sqrt(a @ a) * np.sqrt(b @ b))`, then wrap it in `float(...)`.
```

## Debug challenge: rotating points

A 2-D rotation by angle $\theta$ is the matrix $R = \begin{pmatrix}\cos\theta & -\sin\theta\\ \sin\theta & \cos\theta\end{pmatrix}$. To rotate a point $\mathbf{p}$ you compute $R\mathbf{p}$. With points stored as **rows** of an `(n, 2)` array, rotating all of them at once is `points @ R.T`.

The code below is supposed to rotate two points by 90° counter-clockwise: $(1, 0) \to (0, 1)$ and $(0, 2) \to (-2, 0)$. It runs without any error, but the answer is wrong.

```python debug id=rotate-points title="The rotation runs, but the points end up in the wrong place"
theta = np.pi / 2   # 90 degrees
R = np.array([[np.cos(theta), -np.sin(theta)],
              [np.sin(theta),  np.cos(theta)]])

points = np.array([[1.0, 0.0],
                   [0.0, 2.0]])   # one point per row

rotated = points * R
print(np.round(rotated, 3))
--- solution
theta = np.pi / 2   # 90 degrees
R = np.array([[np.cos(theta), -np.sin(theta)],
              [np.sin(theta),  np.cos(theta)]])

points = np.array([[1.0, 0.0],
                   [0.0, 2.0]])   # one point per row

rotated = points @ R.T
print(np.round(rotated, 3))
--- test
assert rotated.shape == (2, 2), f"`rotated` should still hold 2 points of 2 coordinates, shape (2, 2), but has {rotated.shape}."
assert np.allclose(rotated[0], [0.0, 1.0]), f"(1, 0) rotated 90° should land on (0, 1), but landed on {np.round(rotated[0], 3)}."
assert np.allclose(rotated[1], [-2.0, 0.0]), f"(0, 2) rotated 90° should land on (-2, 0), but landed on {np.round(rotated[1], 3)}."
--- hint
`points` and `R` happen to both be 2×2, so `*` broadcasts silently. Is element-wise multiplication what a rotation needs?
--- hint
Rotating one point is `R @ p`. With points stacked as rows, transpose: `(R @ points.T).T`, which equals `points @ R.T`.
```

## A neural-network layer in one line

A dense ("fully connected") layer takes a batch of inputs `X` of shape `(batch, in_features)`, a weight matrix `W` of shape `(in_features, out_features)` and a bias `b` of shape `(out_features,)`, and computes

$$
Y = \mathrm{ReLU}(XW + \mathbf{b}), \qquad \mathrm{ReLU}(z) = \max(0, z)
$$

That''s a matrix product, a broadcast addition of the bias to every row, and an element-wise maximum. Everything you''ve learned so far is in that one line.

```python run
rng = np.random.default_rng(1)
X = rng.normal(size=(4, 3))    # 4 samples, 3 features each
W = rng.normal(size=(3, 2))    # 3 inputs -> 2 outputs
b = np.array([0.1, -0.2])

Z = X @ W + b                  # (4, 3) @ (3, 2) -> (4, 2), then + (2,) broadcasts
Y = np.maximum(Z, 0)           # ReLU
print("Z shape:", Z.shape)
print(np.round(Y, 3))
```

```python exercise id=dense-layer title="Implement a two-layer network''s forward pass"
def dense(X, W, b):
    """One dense layer with ReLU: max(0, X @ W + b)."""
    # TODO
    ...

def mlp(X, W1, b1, W2, b2):
    """Two layers: a ReLU hidden layer, then a linear output layer (no ReLU)."""
    # TODO: feed X through dense(...), then multiply by W2 and add b2
    ...

rng = np.random.default_rng(3)
X = rng.normal(size=(5, 4))
W1, b1 = rng.normal(size=(4, 8)), np.zeros(8)
W2, b2 = rng.normal(size=(8, 1)), np.array([0.5])
print(np.shape(mlp(X, W1, b1, W2, b2)))   # should be (5, 1)
--- solution
def dense(X, W, b):
    """One dense layer with ReLU: max(0, X @ W + b)."""
    return np.maximum(X @ W + b, 0)

def mlp(X, W1, b1, W2, b2):
    """Two layers: a ReLU hidden layer, then a linear output layer (no ReLU)."""
    return dense(X, W1, b1) @ W2 + b2

rng = np.random.default_rng(3)
X = rng.normal(size=(5, 4))
W1, b1 = rng.normal(size=(4, 8)), np.zeros(8)
W2, b2 = rng.normal(size=(8, 1)), np.array([0.5])
print(np.shape(mlp(X, W1, b1, W2, b2)))
--- test
_rng = np.random.default_rng(11)
_X = _rng.normal(size=(7, 3))
_W = _rng.normal(size=(3, 4))
_b = _rng.normal(size=4)
_d = dense(_X, _W, _b)
assert _d is not None, "`dense` returned None. Did you forget `return`?"
_d = np.asarray(_d)
assert _d.shape == (7, 4), f"`dense` on a (7, 3) batch with a (3, 4) weight matrix should return shape (7, 4), got {_d.shape}."
assert (_d >= 0).all(), "`dense` should apply ReLU, so no output can be negative."
assert np.allclose(_d, np.maximum(_X @ _W + _b, 0)), "`dense` should compute max(0, X @ W + b). Is the bias added before the ReLU?"
_W2 = _rng.normal(size=(4, 2))
_b2 = np.array([-5.0, 5.0])
_m = mlp(_X, _W, _b, _W2, _b2)
assert _m is not None, "`mlp` returned None. Did you forget `return`?"
_m = np.asarray(_m)
assert _m.shape == (7, 2), f"`mlp` should return shape (7, 2) here, got {_m.shape}."
_want = np.maximum(_X @ _W + _b, 0) @ _W2 + _b2
assert np.allclose(_m, _want), "`mlp` gives the wrong numbers. The output layer is linear: no ReLU after `@ W2 + b2`."
--- hint
`np.maximum(a, 0)` is ReLU: it compares element-wise and keeps the larger value. Don''t confuse it with `np.max`, which reduces an array to one number.
--- hint
`mlp` is `dense(X, W1, b1) @ W2 + b2`. Remember to `return` from both functions.
```

## Recap

- The dot product multiplies matching entries and sums them: $\mathbf{a}\cdot\mathbf{b} = \sum_i a_i b_i$. It''s the core operation of linear models and neural networks.
- `*` is element-wise; `@` is matrix multiplication. Mixing them up often fails **silently**.
- The shape rule: $(n, k) @ (k, m) \to (n, m)$. Inner dimensions must match and disappear.
- `@` treats leading axes as a **batch**, and they broadcast. Prefer `@` over `np.dot`.
- `np.einsum` labels axes: repeated labels multiply, and labels missing from the output are summed.
- Cosine similarity, $\frac{\mathbf{a}\cdot\mathbf{b}}{\lVert\mathbf{a}\rVert\lVert\mathbf{b}\rVert}$, compares directions regardless of length.

**Up next:** `np.linalg`, for solving systems of equations, decompositions, and why you should almost never call `inv`.
', 0, '[]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_6_2', 'sec_numpy_6', 'crs_numpy_mastery', 'Solving systems with np.linalg', 'interactive', 1, 1080, NULL, NULL, 'Linear algebra is the engine room of scientific computing. Fitting a model, balancing a chemical equation, computing a portfolio, compressing an image, running PageRank: under the surface, each one solves a system of equations or decomposes a matrix. NumPy''s `np.linalg` module gives you industrial-strength versions of all of these, backed by the same LAPACK routines that power MATLAB, R and Julia.

In this lesson you''ll solve systems of equations the right way, measure vectors and matrices with norms, take matrices apart with eigen- and singular-value decompositions, and fit models with least squares. Along the way you''ll learn the most important habit in numerical linear algebra: **never trust `==` on floats, and almost never call `inv`.**

```python setup
rng_data = np.random.default_rng(2024)
x_data = np.linspace(0, 10, 30)
y_data = 2.5 * x_data + 1.0 + rng_data.normal(scale=1.5, size=30)
```

## Systems of linear equations

Here is a small system:

$$
\begin{aligned}
2x + \phantom{3}y &= 5 \\
x + 3y &= 10
\end{aligned}
$$

In matrix form it''s $A\mathbf{x} = \mathbf{b}$: the coefficients go into $A$, the right-hand side into $\mathbf{b}$, and the unknowns into $\mathbf{x}$. `np.linalg.solve(A, b)` finds $\mathbf{x}$.

```python run
import numpy as np

A = np.array([[2.0, 1.0],
              [1.0, 3.0]])
b = np.array([5.0, 10.0])

x = np.linalg.solve(A, b)
print("solution x:", x)
print("check A @ x:", A @ x)
```

The solution is $x = 1, y = 3$. Always check a solution by plugging it back in: `A @ x` should reproduce `b`.

> **Tip:** each **row** of `A` is one equation and each **column** belongs to one unknown. If you have $m$ equations in $n$ unknowns, `A` has shape `(m, n)`.

## Why not just invert?

From algebra class you know $\mathbf{x} = A^{-1}\mathbf{b}$, and `np.linalg.inv` exists. So why not use it? Two reasons:

1. **Speed:** computing the full inverse does roughly three times the work of solving directly, and you usually only need $A^{-1}\mathbf{b}$, not $A^{-1}$ itself.
2. **Accuracy:** inverting amplifies rounding errors. On a badly conditioned matrix, the difference is dramatic.

The Hilbert matrix, $H_{ij} = \frac{1}{i + j + 1}$, is a famously ill-conditioned matrix. We know the true answer, a vector of ones, so we can measure each method''s error:

```python run
n = 10
i = np.arange(n)
H = 1.0 / (i[:, None] + i[None, :] + 1)   # broadcasting builds the matrix
x_true = np.ones(n)
b = H @ x_true

err_solve = np.abs(np.linalg.solve(H, b) - x_true).max()
err_inv = np.abs(np.linalg.inv(H) @ b - x_true).max()
print(f"max error with solve: {err_solve:.1e}")
print(f"max error with inv:   {err_inv:.1e}")
print(f"condition number:     {np.linalg.cond(H):.1e}")
```

The **condition number** measures how much a matrix can amplify errors in the input. A rule of thumb: you lose about $\log_{10}(\text{cond})$ digits of precision. Float64 has about 16 digits, so a condition number around $10^{13}$ leaves only a few trustworthy ones. Well-behaved matrices have condition numbers close to 1.

| Task | Use | Avoid |
|---|---|---|
| Solve $A\mathbf{x}=\mathbf{b}$ | `np.linalg.solve(A, b)` | `np.linalg.inv(A) @ b` |
| Many right-hand sides | `np.linalg.solve(A, B)`, with `B` holding one column per system | inverting once and reusing it |
| Over-determined (more equations than unknowns) | `np.linalg.lstsq(A, b)` | `solve` (needs a square matrix) |
| Check a result | `np.allclose(A @ x, b)` | `(A @ x == b).all()` |

## Challenge: what does each pastry cost?

```python exercise id=bakery-prices title="Recover prices from three days of sales"
# A bakery sells croissants, muffins and scones. You only know the daily totals:
#   Monday:    3 croissants + 2 muffins + 4 scones = $19.50
#   Tuesday:   1 croissant  + 5 muffins + 2 scones = $20.50
#   Wednesday: 4 croissants + 1 muffin  + 3 scones = $17.50

# TODO: build the coefficient matrix (one row per day, one column per pastry)
A = ...
# TODO: build the vector of daily totals
b = ...
# TODO: solve for [croissant, muffin, scone] prices
prices = ...
print(prices)
--- solution
A = np.array([[3, 2, 4],
              [1, 5, 2],
              [4, 1, 3]], dtype=float)
b = np.array([19.5, 20.5, 17.5])
prices = np.linalg.solve(A, b)
print(prices)
--- test
assert A is not ..., "Replace the `...` after `A =` with the coefficient matrix."
assert b is not ..., "Replace the `...` after `b =` with the daily totals."
assert prices is not ..., "Replace the `...` after `prices =` with your solution."
A = np.asarray(A); b = np.asarray(b); prices = np.asarray(prices)
assert A.shape == (3, 3), f"`A` should be 3x3 (3 days × 3 pastries), but has shape {A.shape}."
assert b.shape == (3,), f"`b` should hold the 3 daily totals, but has shape {b.shape}."
assert np.allclose(A @ np.array([2.5, 3.0, 1.5]), b), "`A` and `b` don''t describe the bakery''s sales. Each row should be one day: the number of croissants, muffins and scones sold."
assert prices.shape == (3,), f"`prices` should hold 3 prices, but has shape {prices.shape}."
assert np.allclose(prices, [2.5, 3.0, 1.5]), f"`prices` should solve A @ prices = b, but A @ prices = {np.round(A @ prices, 3)}."
--- hint
Row 0 of `A` is Monday: `[3, 2, 4]`. `b` is `[19.5, 20.5, 17.5]`.
--- hint
`np.linalg.solve(A, b)` returns the unknowns in column order: croissant, muffin, scone.
```

## Singular matrices: when there''s no unique answer

If one equation is just a multiple of another, the system has infinitely many solutions (or none), and the matrix is **singular**. Its determinant is zero, its rank is less than its size, and `solve` has no meaningful answer to give:

```python run
S = np.array([[1.0, 2.0],
              [2.0, 4.0]])   # row 2 = 2 × row 1

print("determinant:", np.linalg.det(S))
print("rank:       ", np.linalg.matrix_rank(S), "of", S.shape[0])
```

```python run
b_s = np.array([3.0, 6.0])

if np.linalg.matrix_rank(S) < S.shape[0]:
    print("S is singular: there is no unique solution.")
    # lstsq still works: it returns the smallest solution that fits best
    sol, *_ = np.linalg.lstsq(S, b_s, rcond=None)
    print("minimum-norm solution:", np.round(sol, 3))
    print("it fits:", np.allclose(S @ sol, b_s))
```

> **Pitfall:** never call `solve` on a matrix you haven''t checked. Depending on the LAPACK build, a singular matrix either raises `LinAlgError` or silently returns `inf`/`nan` or huge, meaningless numbers. Check `matrix_rank` (or `cond`) first, and fall back to `lstsq` when the system is singular.

The **rank** is the number of truly independent rows (or columns). It''s a far more reliable singularity test than checking `det == 0`, because determinants of nearly singular matrices are tiny but rarely exactly zero in floating point.

> **Pitfall:** a determinant''s size says little about how invertible a matrix is. `0.1 * np.eye(10)` has determinant $10^{-10}$ yet is perfectly well-conditioned (cond = 1). Use `matrix_rank` or `cond`, not `det`.

```python predict id=predict-rank title="What does this print?"
M = np.array([[1, 2, 3],
              [2, 4, 6],
              [1, 0, 1]])
print(np.linalg.matrix_rank(M))
--- options
3
* 2
1
0
--- explain
Row 2 is exactly twice row 1, so it adds no new information. Row 3 is independent of row 1, so there are **2** independent rows. The matrix is singular, because rank 2 is less than size 3.
```

## Norms: how big is a vector?

A **norm** measures the size of a vector. The most common is the Euclidean (L2) norm $\lVert\mathbf{v}\rVert_2 = \sqrt{\sum v_i^2}$, the straight-line length. Others are useful too:

| `ord` | Name | Formula | Used for |
|---|---|---|---|
| `2` (default) | Euclidean / L2 | $\sqrt{\sum v_i^2}$ | distances, weight decay |
| `1` | Manhattan / L1 | $\sum \lvert v_i\rvert$ | sparsity (lasso), city-block distance |
| `np.inf` | max norm | $\max \lvert v_i\rvert$ | worst-case error |

```python run
v = np.array([3.0, -4.0, 0.0])
print("L2:  ", np.linalg.norm(v))
print("L1:  ", np.linalg.norm(v, ord=1))
print("max: ", np.linalg.norm(v, ord=np.inf))

M = np.array([[1.0, 2.0], [3.0, 4.0]])
print("Frobenius norm of M:", np.linalg.norm(M))   # sqrt of the sum of all squared entries
```

With `axis=`, `norm` computes one norm per row or column. This is how you measure many vectors at once:

```python run
points = np.array([[3.0, 4.0],
                   [1.0, 0.0],
                   [5.0, 12.0]])
print(np.linalg.norm(points, axis=1))   # length of each row
```

```python predict id=predict-norm title="What does this print?"
print(np.linalg.norm([6, 8]))
--- options
14.0
* 10.0
100.0
48.0
--- explain
The L2 norm is $\sqrt{6^2 + 8^2} = \sqrt{100} = 10$. NumPy returns a float, so it prints `10.0`.
```

```python exercise id=normalize-rows title="Scale every row to unit length"
def normalize_rows(X):
    """Return a copy of X where every row has L2 norm 1 (same direction)."""
    # TODO: divide each row by its own length
    ...

X = np.array([[3.0, 4.0],
              [0.0, 2.0],
              [1.0, 1.0]])
print(normalize_rows(X))
--- solution
def normalize_rows(X):
    """Return a copy of X where every row has L2 norm 1 (same direction)."""
    return X / np.linalg.norm(X, axis=1, keepdims=True)

X = np.array([[3.0, 4.0],
              [0.0, 2.0],
              [1.0, 1.0]])
print(normalize_rows(X))
--- test
_X = np.array([[3.0, 4.0], [0.0, 2.0], [1.0, 1.0]])
_out = normalize_rows(_X.copy())
assert _out is not None, "`normalize_rows` returned None. Did you forget `return`?"
_out = np.asarray(_out)
assert _out.shape == _X.shape, f"The output should keep the input''s shape {_X.shape}, but has shape {_out.shape}."
assert np.allclose(_out[0], [0.6, 0.8]), f"Row [3, 4] has length 5, so it should become [0.6, 0.8], not {np.round(_out[0], 3)}. Are you dividing each row by its own length?"
_rng = np.random.default_rng(5)
_R = _rng.normal(size=(6, 4)) * _rng.uniform(1, 10, size=(6, 1))
_n = np.asarray(normalize_rows(_R.copy()))
assert np.allclose(np.linalg.norm(_n, axis=1), 1.0), "Every row of the result should have length 1."
assert np.allclose(_n * np.linalg.norm(_R, axis=1, keepdims=True), _R), "Rows should keep their direction; only their length should change."
--- hint
`np.linalg.norm(X, axis=1)` gives one length per row, shape `(n,)`. Dividing an `(n, d)` array by an `(n,)` array doesn''t broadcast the way you want.
--- hint
Pass `keepdims=True` so the lengths have shape `(n, 1)` and divide each row correctly.
```

## Debug challenge: the "failed" verification

An engineer solved a system and added a sanity check. The check reports that the solution is wrong, but the solution looks perfect when printed. Find out why, and make the check trustworthy.

```python debug id=float-verify title="The solution looks right, but the check says it''s wrong"
A = np.array([[0.1, 0.2, 0.3],
              [0.4, 0.5, 0.7],
              [0.7, 0.8, 1.0]])
b = np.array([1.4, 3.5, 5.3])

x = np.linalg.inv(A) @ b
ok = (A @ x == b).all()

print("x =", x)
print("verified:", ok)
--- solution
A = np.array([[0.1, 0.2, 0.3],
              [0.4, 0.5, 0.7],
              [0.7, 0.8, 1.0]])
b = np.array([1.4, 3.5, 5.3])

x = np.linalg.solve(A, b)
ok = np.allclose(A @ x, b)

print("x =", x)
print("verified:", ok)
--- test
assert np.allclose(x, [1.0, 2.0, 3.0]), f"`x` should solve the system, giving [1, 2, 3], but it is {x}."
assert bool(ok) is True, "`ok` is still False. Print `A @ x - b` and look at the size of the differences. How should floats be compared?"
--- hint
Print `A @ x - b`. The differences are around $10^{-15}$. Real, but meaningless.
--- hint
Compare floats with a tolerance: `np.allclose(A @ x, b)`. While you''re there, replace `inv(A) @ b` with `np.linalg.solve(A, b)`.
```

## Eigenvalues: directions a matrix only stretches

An **eigenvector** $\mathbf{v}$ of a square matrix $A$ is a direction that $A$ doesn''t rotate, only stretches, by a factor $\lambda$ called the **eigenvalue**:

$$
A\mathbf{v} = \lambda\mathbf{v}
$$

For **symmetric** matrices, like covariance matrices, distance matrices and graph Laplacians, always use `np.linalg.eigh`. It''s faster, it returns real eigenvalues sorted in ascending order, and its eigenvectors are orthonormal. The general `np.linalg.eig` can return complex numbers and makes no ordering promises.

```python run
rng = np.random.default_rng(0)
data = rng.normal(size=(200, 2)) @ np.array([[3.0, 0.0], [1.2, 0.5]])
C = np.cov(data, rowvar=False)          # 2x2 symmetric covariance matrix

eigenvalues, eigenvectors = np.linalg.eigh(C)
print("eigenvalues :", np.round(eigenvalues, 3))
print("eigenvectors (columns):\n", np.round(eigenvectors, 3))

v = eigenvectors[:, -1]                 # the column for the largest eigenvalue
print("A v == λ v ?", np.allclose(C @ v, eigenvalues[-1] * v))
```

The eigenvector with the largest eigenvalue is the direction in which the data varies most. That''s exactly the first **principal component** in PCA.

> **Pitfall:** eigenvectors are the **columns** of the returned matrix, not the rows. `eigenvectors[:, i]` pairs with `eigenvalues[i]`.

## SVD: the decomposition behind compression

The **singular value decomposition** factors *any* matrix, square or not, into three pieces:

$$
M = U \, \Sigma \, V^\top
$$

$U$ and $V$ have orthonormal columns, and $\Sigma$ is diagonal with **singular values** $\sigma_1 \ge \sigma_2 \ge \dots \ge 0$. Each singular value measures how much one "layer" of the matrix matters. Keeping only the largest $k$ gives the **best possible rank-$k$ approximation** (the Eckart–Young theorem). That''s the idea behind image compression, recommender systems and latent semantic analysis.

```python run
rng = np.random.default_rng(1)
# A 6x5 matrix that''s secretly rank 2, plus a little noise
M = rng.normal(size=(6, 2)) @ rng.normal(size=(2, 5)) + 0.01 * rng.normal(size=(6, 5))

U, S, Vt = np.linalg.svd(M, full_matrices=False)
print("shapes:", U.shape, S.shape, Vt.shape)
print("singular values:", np.round(S, 3))
print("rebuilds M:", np.allclose(U @ np.diag(S) @ Vt, M))
```

Two large singular values and three tiny ones reveal the hidden rank-2 structure. The tiny ones are the noise.

```python exercise id=low-rank title="Build the best rank-k approximation"
def rank_k_approx(M, k):
    """Return the best rank-k approximation of M, using the SVD."""
    U, S, Vt = np.linalg.svd(M, full_matrices=False)
    # TODO: keep only the first k singular values/vectors and multiply back together
    ...

rng = np.random.default_rng(1)
M = rng.normal(size=(6, 2)) @ rng.normal(size=(2, 5)) + 0.01 * rng.normal(size=(6, 5))
approx = rank_k_approx(M, 2)
if approx is not None:
    print("rank:", np.linalg.matrix_rank(approx))
    print("max error:", np.abs(approx - M).max())
--- solution
def rank_k_approx(M, k):
    """Return the best rank-k approximation of M, using the SVD."""
    U, S, Vt = np.linalg.svd(M, full_matrices=False)
    return U[:, :k] @ np.diag(S[:k]) @ Vt[:k, :]

rng = np.random.default_rng(1)
M = rng.normal(size=(6, 2)) @ rng.normal(size=(2, 5)) + 0.01 * rng.normal(size=(6, 5))
approx = rank_k_approx(M, 2)
if approx is not None:
    print("rank:", np.linalg.matrix_rank(approx))
    print("max error:", np.abs(approx - M).max())
--- test
_rng = np.random.default_rng(99)
_M = _rng.normal(size=(8, 6))
_A = rank_k_approx(_M.copy(), 3)
assert _A is not None, "`rank_k_approx` returned None. Did you forget `return`?"
_A = np.asarray(_A)
assert _A.shape == _M.shape, f"The approximation should have the same shape as M, {_M.shape}, but has {_A.shape}."
assert np.linalg.matrix_rank(_A) == 3, f"`rank_k_approx(M, 3)` should have rank 3, but has rank {np.linalg.matrix_rank(_A)}."
_S = np.linalg.svd(_M, compute_uv=False)
_err = np.linalg.norm(_M - _A)
assert np.isclose(_err, np.sqrt((_S[3:] ** 2).sum())), "That''s a rank-3 matrix, but not the *best* one. Keep the **largest** singular values: the first k."
assert np.allclose(rank_k_approx(_M, 6), _M), "With k equal to the full rank, you should get M back exactly."
--- hint
Slice each factor: the first `k` columns of `U`, the first `k` values of `S`, and the first `k` **rows** of `Vt`.
--- hint
`U[:, :k] @ np.diag(S[:k]) @ Vt[:k, :]`. Equivalently, `(U[:, :k] * S[:k]) @ Vt[:k]` uses broadcasting instead of building a diagonal matrix.
```

## Least squares: fitting a line

With more equations than unknowns, as with 30 noisy measurements and only 2 parameters, there''s usually no exact solution. **Least squares** finds the parameters that minimize the total squared error, $\lVert A\mathbf{x} - \mathbf{b}\rVert^2$.

To fit $y = m x + c$, build a **design matrix** with one column per parameter: a column of `x` values for the slope, and a column of **ones** for the intercept.

```python run
print("x_data shape:", x_data.shape, " first values:", np.round(x_data[:3], 2))

design = np.column_stack([x_data, np.ones_like(x_data)])   # shape (30, 2)
print("design matrix (first rows):\n", np.round(design[:3], 2))

coef, residuals, rank, sing_vals = np.linalg.lstsq(design, y_data, rcond=None)
print("slope, intercept:", np.round(coef, 3))
```

The data was generated from $y = 2.5x + 1$ plus noise, and least squares recovers parameters very close to that.

```python run
import matplotlib.pyplot as plt

slope, intercept = coef
plt.scatter(x_data, y_data, s=18, label="data")
plt.plot(x_data, slope * x_data + intercept, color="crimson", label=f"fit: y = {slope:.2f}x + {intercept:.2f}")
plt.legend()
plt.show()
```

```python debug id=missing-intercept title="The fitted line is forced through the origin"
# Fit y = m*x + c to the lesson''s data (x_data, y_data)
design = x_data[:, None]           # shape (30, 1)

coef, *_ = np.linalg.lstsq(design, y_data, rcond=None)
slope = coef[0]
intercept = 0.0

print(f"y = {slope:.3f} x + {intercept:.3f}")
--- solution
design = np.column_stack([x_data, np.ones_like(x_data)])

coef, *_ = np.linalg.lstsq(design, y_data, rcond=None)
slope, intercept = coef

print(f"y = {slope:.3f} x + {intercept:.3f}")
--- test
_d = np.column_stack([x_data, np.ones_like(x_data)])
_want, *_ = np.linalg.lstsq(_d, y_data, rcond=None)
assert np.isclose(intercept, _want[1]), f"`intercept` should be fitted from the data (about {_want[1]:.2f}), but it is {float(intercept):.3f}. Where does the intercept come from in the design matrix?"
assert np.isclose(slope, _want[0]), f"`slope` should be about {_want[0]:.3f}, but it is {float(slope):.3f}. Without an intercept, the slope gets distorted to compensate."
--- hint
Each column of the design matrix corresponds to one parameter. How many parameters does $y = mx + c$ have, and how many columns does `design` have?
--- hint
Add a column of ones: `np.column_stack([x_data, np.ones_like(x_data)])`. Then `lstsq` returns both the slope and the intercept.
```

> **In the wild:** `sklearn.linear_model.LinearRegression` does exactly this (with `fit_intercept=True` adding the column of ones for you), and `np.polyfit(x, y, 1)` is a convenient shortcut for polynomials.

## Recap

- Solve $A\mathbf{x}=\mathbf{b}$ with `np.linalg.solve`, not `inv(A) @ b`. It''s faster and more accurate.
- Verify with `np.allclose(A @ x, b)`; never compare floats with `==`.
- The **condition number** tells you how many digits you can trust. Use `matrix_rank` and `cond`, not `det`, to detect near-singular matrices.
- `np.linalg.norm` measures length (L2, L1, max), and `axis=` computes one norm per row.
- For symmetric matrices use `eigh`; eigenvectors are the **columns**.
- The SVD $M = U\Sigma V^\top$ gives the best low-rank approximations, and `lstsq` fits over-determined systems. Don''t forget the column of ones.

**Up next:** sorting, searching and statistics: ranking, top-k, binning and summarizing data.
', 0, '[]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_6_3', 'sec_numpy_6', 'crs_numpy_mastery', 'Sorting, searching and statistics', 'interactive', 2, 960, NULL, NULL, 'Raw data rarely answers questions on its own. *Who are the top ten customers? Which word appears most often? What does a typical order cost, and what does an unusually large one cost? Which bucket does each measurement fall into?* Answering questions like these means **ranking, searching, counting and summarizing**, and NumPy has a fast, vectorized tool for each.

In this lesson you''ll learn to sort arrays (and sort one array *by another*), grab the top-k without sorting everything, count unique values, bin continuous data, and compute the robust statistics that analysts reach for every day: medians, percentiles, histograms and correlations.

## Sorting: `np.sort` versus `.sort()`

There are two ways to sort, and the difference matters:

- `np.sort(a)` returns a **new, sorted copy** and leaves `a` alone.
- `a.sort()` sorts `a` **in place** and returns `None`.

```python run
import numpy as np

temps = np.array([21.5, 18.0, 25.3, 19.9, 23.1])

sorted_copy = np.sort(temps)
print("np.sort :", sorted_copy)
print("original:", temps, "(unchanged)")

temps.sort()
print("after .sort():", temps, "(changed in place)")
```

Both sort in **ascending** order. NumPy has no `reverse=True` flag; to sort descending, reverse the result with a slice:

```python run
scores = np.array([72, 95, 88, 61, 79])
print("descending:", np.sort(scores)[::-1])
```

```python predict id=predict-sort-none title="What does this print?"
a = np.array([3, 1, 2])
result = a.sort()
print(result)
--- options
[1 2 3]
* None
[3 1 2]
[3 2 1]
--- explain
`.sort()` sorts **in place** and, like Python''s `list.sort()`, returns `None`. `a` itself is now `[1 2 3]`, but `result` holds nothing. Writing `x = x.sort()` is a classic bug: it throws your data away.
```

### Sorting 2-D arrays

On a 2-D array, `np.sort` sorts along the **last axis** by default, so each row is sorted independently. Use `axis=0` to sort each column, or `axis=None` to flatten and sort everything.

```python run
M = np.array([[9, 2, 7],
              [4, 8, 1]])
print("axis=-1 (each row):\n", np.sort(M))
print("axis=0 (each column):\n", np.sort(M, axis=0))
print("axis=None (flattened):", np.sort(M, axis=None))
```

> **Pitfall:** sorting rows or columns independently **breaks the link between values in the same record**. If each row is a person, `np.sort(M, axis=0)` mixes up whose numbers are whose. To sort *records*, you need `argsort`.

## `argsort`: sort one array by another

`np.argsort(a)` doesn''t return sorted values. It returns the **indices** that would sort `a`. That sounds abstract, but it''s one of the most useful functions in NumPy: once you have the sorting order, you can apply it to *any* array that''s aligned with `a`.

```python run
names = np.array(["Ada", "Grace", "Alan", "Linus", "Barbara"])
points = np.array([88, 95, 72, 95, 81])

order = np.argsort(points)
print("order:          ", order)
print("points[order]:  ", points[order])
print("names[order]:   ", names[order])        # names, sorted by points
print("highest first:  ", names[order[::-1]])
```

`points[order]` is just `np.sort(points)`, but `names[order]` puts the **names** in the order of their points. The two arrays stay aligned because both are reordered by the same index array.

> **Tip:** to sort descending by a numeric key, `np.argsort(-points)` is a neat alternative to reversing. It also keeps ties in their original order if you pass `kind="stable"`.

```python predict id=predict-argsort title="What does this print?"
print(np.argsort([30, 10, 20]))
--- options
[10 20 30]
* [1 2 0]
[2 0 1]
[0 1 2]
--- explain
The smallest value, 10, is at index **1**, the next, 20, is at index **2**, and the largest, 30, is at index **0**. `argsort` returns positions, not values.
```

```python exercise id=leaderboard title="Build a top-3 leaderboard"
players = np.array(["kai", "mira", "otto", "zoe", "lev", "ana", "ravi"])
scores = np.array([1840, 2310, 1595, 2720, 2105, 1990, 2480])

# TODO: the names of the 3 highest-scoring players, best first
top3 = ...

# TODO: their scores, in the same order (best first)
top3_scores = ...

print(top3, top3_scores)
--- solution
players = np.array(["kai", "mira", "otto", "zoe", "lev", "ana", "ravi"])
scores = np.array([1840, 2310, 1595, 2720, 2105, 1990, 2480])

order = np.argsort(scores)[::-1]
top3 = players[order[:3]]
top3_scores = scores[order[:3]]

print(top3, top3_scores)
--- test
assert top3 is not ..., "Replace the `...` after `top3 =` with your code."
assert top3_scores is not ..., "Replace the `...` after `top3_scores =` with your code."
_names = list(np.asarray(top3))
_vals = list(np.asarray(top3_scores))
assert len(_names) == 3, f"`top3` should contain exactly 3 names, but it has {len(_names)}."
assert set(_names) == {"zoe", "ravi", "mira"}, f"`top3` should be the three highest scorers, but you have {_names}. Are you sorting by score?"
assert _names == ["zoe", "ravi", "mira"], f"The names are right but the order isn''t: {_names}. Best first, please (descending order)."
assert [int(v) for v in _vals] == [2720, 2480, 2310], f"`top3_scores` should be the matching scores, best first, but it is {_vals}."
--- hint
`np.argsort(scores)` gives the indices from lowest to highest score. How do you flip that order?
--- hint
`order = np.argsort(scores)[::-1]`, then index *both* arrays with `order[:3]`.
```

## Debug challenge: the mixed-up podium

A race organizer wants to announce the winner. The code sorts both arrays and reads off the first entries, yet it crowns the wrong runner. (Lower times are better.)

```python debug id=misaligned-sort title="The fastest time goes to the wrong runner"
runners = np.array(["Hana", "Diego", "Wen", "Felix", "Omar"])
times = np.array([12.48, 11.93, 12.05, 11.71, 12.30])   # seconds

sorted_runners = np.sort(runners)
sorted_times = np.sort(times)

winner = sorted_runners[0]
best_time = sorted_times[0]
print(f"Winner: {winner} in {best_time} s")
--- solution
runners = np.array(["Hana", "Diego", "Wen", "Felix", "Omar"])
times = np.array([12.48, 11.93, 12.05, 11.71, 12.30])   # seconds

order = np.argsort(times)
sorted_runners = runners[order]
sorted_times = times[order]

winner = sorted_runners[0]
best_time = sorted_times[0]
print(f"Winner: {winner} in {best_time} s")
--- test
assert np.isclose(best_time, 11.71), f"`best_time` should be the fastest time, 11.71 s, but it is {best_time}."
assert str(winner) == "Felix", f"The winner is announced as {str(winner)!r}, but {str(winner)!r} didn''t run 11.71 s. Check which runner actually has that time."
assert list(np.asarray(sorted_runners)) == ["Felix", "Diego", "Wen", "Omar", "Hana"], "`sorted_runners` should list the runners from fastest to slowest."
--- hint
`np.sort(runners)` sorts the names **alphabetically**, completely independently of the times. The two arrays no longer line up.
--- hint
Compute the order once from the times with `np.argsort(times)`, then apply that same order to both arrays.
```

## Top-k without a full sort: `partition`

Sorting a million values to find the 10 largest is wasteful. `np.partition(a, kth)` rearranges the array so the element at position `kth` is exactly where it would be after sorting, with everything smaller before it and everything larger after it, **in no particular order**. That takes linear time instead of $O(n \log n)$.

```python run
rng = np.random.default_rng(0)
values = rng.integers(0, 1000, size=12)
print("values:     ", values)

p = np.partition(values, -3)      # the 3 largest end up in the last 3 slots
print("partitioned:", p)
print("3 largest (unordered):", p[-3:])
print("3 largest (sorted):   ", np.sort(p[-3:])[::-1])
```

`np.argpartition` is to `partition` what `argsort` is to `sort`: it gives you **indices**, so you can find *which* items are in the top-k.

```python run
idx = np.argpartition(values, -3)[-3:]
print("indices of the top 3:", idx)
print("their values:        ", values[idx])
```

```python exercise id=top-k title="A fast top_k function"
def top_k(values, k):
    """Return the k largest values of a 1-D array, sorted from largest to smallest."""
    # TODO: use np.partition (or argpartition) to avoid sorting the whole array,
    # then sort just those k values in descending order
    ...

data = np.array([5, 17, 3, 42, 8, 23, 16, 4])
print(top_k(data, 3))   # expected: [42 23 17]
--- solution
def top_k(values, k):
    """Return the k largest values of a 1-D array, sorted from largest to smallest."""
    largest = np.partition(values, -k)[-k:]
    return np.sort(largest)[::-1]

data = np.array([5, 17, 3, 42, 8, 23, 16, 4])
print(top_k(data, 3))
--- test
_r = top_k(np.array([5, 17, 3, 42, 8, 23, 16, 4]), 3)
assert _r is not None, "`top_k` returned None. Did you forget `return`?"
_r = np.asarray(_r)
assert _r.shape == (3,), f"`top_k(data, 3)` should return 3 values, but returned shape {_r.shape}."
assert set(_r.tolist()) == {42, 23, 17}, f"`top_k(data, 3)` should contain 42, 23 and 17, but returned {_r.tolist()}."
assert _r.tolist() == [42, 23, 17], f"Right values, wrong order: {_r.tolist()}. Return them largest first."
_rng = np.random.default_rng(8)
for _k in (1, 5, 20):
    _v = _rng.normal(size=200)
    _got = np.asarray(top_k(_v.copy(), _k))
    assert np.allclose(_got, np.sort(_v)[::-1][:_k]), f"`top_k` is wrong for k={_k} on random data."
--- hint
`np.partition(values, -k)` puts the k largest values into the last k positions, but not in order.
--- hint
Take `np.partition(values, -k)[-k:]`, sort just those, and reverse with `[::-1]`.
```

## Counting: `np.unique`

`np.unique` returns the sorted distinct values. With `return_counts=True` it also counts how many times each appears, which is a one-line frequency table.

```python run
words = np.array(["the", "cat", "sat", "on", "the", "mat", "the", "cat"])

vocab, counts = np.unique(words, return_counts=True)
for w, c in zip(vocab, counts):
    print(f"{w:>4}: {c}")
```

With `return_inverse=True` you also get, for every original element, the index of its value in the unique array. That''s an instant **integer encoding** of categorical data, exactly what machine-learning models need:

```python run
colors = np.array(["red", "blue", "red", "green", "blue", "red"])
categories, codes = np.unique(colors, return_inverse=True)
print("categories:", categories)
print("codes:     ", codes)
print("decoded:   ", categories[codes])
```

For non-negative integers, `np.bincount` counts occurrences of each value from 0 up to the maximum, and it''s even faster:

```python run
dice = np.array([3, 6, 1, 3, 3, 5, 6, 2, 3, 1])
print(np.bincount(dice))            # index i holds the count of value i
print(np.bincount(dice, minlength=7)[1:])  # faces 1..6
```

```python exercise id=most-common title="Find the most common item"
orders = np.array([
    "latte", "espresso", "latte", "mocha", "flat white", "latte",
    "espresso", "mocha", "latte", "flat white", "espresso", "latte",
])

# TODO: the drink ordered most often, and how many times it was ordered
favorite = ...
favorite_count = ...
print(favorite, favorite_count)
--- solution
orders = np.array([
    "latte", "espresso", "latte", "mocha", "flat white", "latte",
    "espresso", "mocha", "latte", "flat white", "espresso", "latte",
])

drinks, counts = np.unique(orders, return_counts=True)
favorite = drinks[counts.argmax()]
favorite_count = counts.max()
print(favorite, favorite_count)
--- test
assert favorite is not ..., "Replace the `...` after `favorite =` with your code."
assert favorite_count is not ..., "Replace the `...` after `favorite_count =` with your code."
assert str(favorite) == "latte", f"`favorite` should be the most frequently ordered drink, but it is {favorite!r}."
assert int(favorite_count) == 5, f"`favorite_count` should be how many times {favorite!r} was ordered, but it is {favorite_count!r}."
--- hint
`np.unique(orders, return_counts=True)` gives you two aligned arrays: the drinks and their counts.
--- hint
`counts.argmax()` is the position of the biggest count. Use it to index the drinks array.
```

## Searching and binning: `searchsorted` and `digitize`

`np.searchsorted(sorted_array, values)` finds, for each value, the index where it would be inserted to keep the array sorted. It uses binary search, so it''s very fast. A natural use is looking things up in a table of thresholds:

```python run
thresholds = np.array([0, 18.5, 25, 30])        # BMI category boundaries
labels = np.array(["?", "underweight", "healthy", "overweight", "obese"])

bmis = np.array([17.2, 22.8, 27.5, 31.0, 24.99])
idx = np.searchsorted(thresholds, bmis, side="right")
print(idx)
print(labels[idx])
```

`np.digitize(x, bins)` answers the same question, "which bin does each value fall in?", phrased for binning: values below `bins[0]` get 0, values in `[bins[0], bins[1])` get 1, and so on.

```python exercise id=letter-grades title="Convert scores to letter grades"
scores = np.array([93, 67, 85, 59, 72, 100, 80, 89.5])

# Grade boundaries:  F < 60 <= D < 70 <= C < 80 <= B < 90 <= A
bins = np.array([60, 70, 80, 90])
letters = np.array(["F", "D", "C", "B", "A"])

# TODO: one letter per score, as a NumPy array, with no Python loop
grades = ...
print(grades)
--- solution
scores = np.array([93, 67, 85, 59, 72, 100, 80, 89.5])

bins = np.array([60, 70, 80, 90])
letters = np.array(["F", "D", "C", "B", "A"])

grades = letters[np.digitize(scores, bins)]
print(grades)
--- test
assert grades is not ..., "Replace the `...` after `grades =` with your code."
_g = [str(x) for x in np.asarray(grades).tolist()]
assert len(_g) == 8, f"`grades` should have one letter per score (8), but has {len(_g)}."
assert _g[3] == "F" and _g[0] == "A", f"93 should be an A and 59 an F. You have {_g[0]!r} and {_g[3]!r}."
assert _g[6] == "B", f"Exactly 80 is a B (the lower boundary belongs to the higher grade), but you have {_g[6]!r}."
assert _g == ["A", "D", "B", "F", "C", "A", "B", "B"], f"Some grades are wrong: {_g}."
--- hint
`np.digitize(scores, bins)` gives a bin number from 0 to 4 for each score.
--- hint
Use those bin numbers as indices into `letters`: `letters[np.digitize(scores, bins)]`.
```

## Robust statistics: median, percentiles and quantiles

The mean is sensitive to outliers; the **median**, the middle value, is not. One billionaire walking into a café changes the mean income enormously and the median barely at all.

```python run
incomes = np.array([32_000, 41_000, 38_500, 45_000, 36_000, 39_000, 2_500_000.0])

print(f"mean:   {incomes.mean():>12,.0f}")
print(f"median: {np.median(incomes):>12,.0f}")
```

**Percentiles** generalize the median: the 90th percentile is the value below which 90% of the data falls. `np.percentile` takes values from 0 to 100, and `np.quantile` is identical but takes fractions from 0 to 1.

```python run
rng = np.random.default_rng(42)
latency_ms = rng.lognormal(mean=3.0, sigma=0.5, size=10_000)   # skewed, like real latencies

p50, p95, p99 = np.percentile(latency_ms, [50, 95, 99])
print(f"p50 = {p50:.1f} ms   p95 = {p95:.1f} ms   p99 = {p99:.1f} ms")
print("same via quantile:", np.round(np.quantile(latency_ms, [0.5, 0.95, 0.99]), 1))
```

> **In the wild:** site-reliability engineers watch p95 and p99 latency rather than the mean, because the slowest 1% of requests are the ones users complain about.

### Histograms

`np.histogram` counts how many values fall in each bin. It returns the counts and the bin **edges**, and there''s always one more edge than counts.

```python run
counts, edges = np.histogram(latency_ms, bins=6, range=(0, 120))
for c, lo, hi in zip(counts, edges[:-1], edges[1:]):
    print(f"{lo:5.0f}–{hi:<4.0f} ms {''█'' * (c // 150)} {c}")
```

```python run
import matplotlib.pyplot as plt

plt.hist(latency_ms, bins=50, color="#4f7cff")
plt.axvline(p95, color="crimson", linestyle="--", label="p95")
plt.xlabel("latency (ms)")
plt.legend()
plt.show()
```

## Relationships: covariance and correlation

`np.corrcoef` measures how strongly variables move together, from $-1$ (perfectly opposite) through $0$ (no linear relationship) to $+1$ (perfectly together). It returns a **matrix**: entry $(i, j)$ is the correlation between variable $i$ and variable $j$, so the diagonal is always 1.

```python run
rng = np.random.default_rng(3)
hours_studied = rng.uniform(0, 10, size=50)
exam_score = 50 + 4 * hours_studied + rng.normal(scale=6, size=50)
phone_minutes = rng.uniform(0, 300, size=50)

R = np.corrcoef([hours_studied, exam_score, phone_minutes])
print(np.round(R, 2))
```

Studying correlates strongly with the score, and phone time (random in this fake data) barely at all. `np.cov` returns the covariance matrix in the same layout. It''s the raw, unnormalized version that PCA uses.

> **Pitfall:** `np.corrcoef` and `np.cov` treat each **row** as a variable by default. If your data is laid out as `(samples, features)`, the usual layout, pass `rowvar=False` or transpose it first. Otherwise you''ll get a giant samples-by-samples matrix.

```python debug id=percentile-scale title="The 90th-percentile report crashes"
response_times = np.array([120, 95, 210, 180, 99, 143, 300, 87, 160, 132])

# Report the median and the 90th percentile response time
median = np.quantile(response_times, 50)
p90 = np.quantile(response_times, 90)

print(f"median: {median:.1f} ms, p90: {p90:.1f} ms")
--- solution
response_times = np.array([120, 95, 210, 180, 99, 143, 300, 87, 160, 132])

median = np.quantile(response_times, 0.5)
p90 = np.quantile(response_times, 0.9)

print(f"median: {median:.1f} ms, p90: {p90:.1f} ms")
--- test
assert np.isclose(median, np.median(response_times)), f"`median` should be {np.median(response_times)}, but it is {median}."
assert np.isclose(p90, np.percentile(response_times, 90)), f"`p90` should be the 90th percentile, {np.percentile(response_times, 90):.1f}, but it is {p90}."
--- hint
Run it and read the error message carefully: what range does `np.quantile` expect?
--- hint
`np.quantile` takes fractions from 0 to 1, while `np.percentile` takes 0 to 100. Use `0.5` and `0.9`, or switch to `np.percentile`.
```

## Recap

- `np.sort(a)` returns a sorted copy; `a.sort()` sorts in place and returns `None`. Reverse with `[::-1]`.
- `np.argsort` returns the sorting **order**. Apply it to aligned arrays to sort records without scrambling them.
- `np.partition` / `np.argpartition` find the top-k in linear time.
- `np.unique(..., return_counts=True)` builds frequency tables, `return_inverse=True` encodes categories as integers, and `np.bincount` counts small non-negative ints.
- `np.searchsorted` and `np.digitize` map values to bins with no loops.
- Use the median and percentiles for skewed data, `np.histogram` for distributions, and `np.corrcoef` for relationships (mind `rowvar`).

**Up next:** NaN, infinity and the floating-point traps that bite every data scientist eventually.
', 0, '[]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_6_4', 'sec_numpy_6', 'crs_numpy_mastery', 'Checkpoint: linear algebra & statistics', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"A has shape (32, 10, 64) and W has shape (64, 16). What is the shape of A @ W?","options":["(32, 10, 16)","(32, 64, 16)","(10, 16)","It raises an error: the batch dimensions don''t match"],"answerIndex":0,"explanation":"@ multiplies the last two axes, (10, 64) @ (64, 16) → (10, 16), and treats the leading 32 as a batch dimension. W broadcasts across the batch, giving (32, 10, 16)."},{"id":"q2","prompt":"X has shape (100, 3) and w has shape (3,). Which expression gives one prediction per sample, with shape (100,)?","options":["X * w","X @ w","w @ X","np.outer(X, w)"],"answerIndex":1,"explanation":"(100, 3) @ (3,) → (100,): each row is dotted with w. X * w broadcasts element-wise and returns a (100, 3) array; w @ X fails because its inner dimensions (3 and 100) don''t match."},{"id":"q3","prompt":"What does np.einsum(\"ij,ij->i\", A, B) compute for two arrays of shape (n, d)?","options":["The full matrix product A @ B.T, shape (n, n)","The dot product of each row of A with the matching row of B, shape (n,)","The sum of every element of A * B, a single number","The outer product of A and B"],"answerIndex":1,"explanation":"i appears in both inputs and the output, so it''s kept; j is repeated and missing from the output, so it''s multiplied and summed. That gives row-wise dot products, the same as (A * B).sum(axis=1)."},{"id":"q4","prompt":"You need to solve Ax = b for a square matrix A. Which approach is recommended?","options":["x = np.linalg.inv(A) @ b, because it''s the textbook formula","x = np.linalg.solve(A, b)","x = b / A","x = np.linalg.det(A) * b"],"answerIndex":1,"explanation":"solve factorizes A and solves directly, which is faster and more accurate than forming the inverse. Explicit inversion amplifies rounding errors, especially for ill-conditioned matrices."},{"id":"q5","prompt":"You want to fit y = m·x + c with np.linalg.lstsq. What should the design matrix look like?","options":["Just x as a single column","Two columns: x and a column of ones","Two columns: x and y","A square matrix built with np.outer(x, x)"],"answerIndex":1,"explanation":"Each column corresponds to one parameter. The x column multiplies the slope m, and a column of ones multiplies the intercept c. Without the ones column, the line is forced through the origin."},{"id":"q6","prompt":"names and scores are aligned 1-D arrays. Which expression lists the names from highest to lowest score?","options":["np.sort(names)[::-1]","names[np.argsort(scores)[::-1]]","np.sort(scores)[::-1]","names[np.sort(scores)]"],"answerIndex":1,"explanation":"argsort returns the indices that sort scores ascending, and reversing them gives descending order. Indexing names with those indices keeps every name paired with its score. np.sort(names) sorts alphabetically, ignoring the scores."}]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_numpy_7_1', 'sec_numpy_7', 'crs_numpy_mastery', 'NaN, infinity and floating-point traps', 'interactive', 0, 960, NULL, NULL, 'Real data is messy. Sensors drop out, survey answers are left blank, and a division somewhere quietly produces infinity. NumPy represents these gaps with special floating-point values, **NaN** ("not a number") and **inf**. They behave in ways that surprise almost everyone the first time.

In this lesson you''ll learn to detect, summarise and repair missing values, and you''ll meet the floating-point traps behind a whole category of "but the numbers look equal!" bugs. By the end you''ll write numeric code that survives contact with real-world data.

## Meet NaN and infinity

`np.nan` and `np.inf` are ordinary `float64` values with special meanings. Infinity comes from overflow or division by zero. NaN comes from undefined operations like `0 / 0` or `inf - inf`, and it''s also the conventional marker for "missing".

```python run
import numpy as np

print("nan:", np.nan, type(np.nan).__name__)
print("inf:", np.inf, "  -inf:", -np.inf)
print("inf + 1   =", np.inf + 1)
print("inf - inf =", np.inf - np.inf)
print("0 * inf   =", 0 * np.inf)
np.array([1.0, np.nan, np.inf, -np.inf])
```

The key property of NaN: **it poisons everything it touches.** Any arithmetic involving NaN produces NaN, and so does any summary that includes one.

```python run
readings = np.array([21.5, 22.0, np.nan, 23.1, 22.4])

print("sum: ", readings.sum())
print("mean:", readings.mean())
print("max: ", readings.max())
```

One missing reading wiped out every statistic. That''s deliberate: NumPy refuses to pretend it knows a value it doesn''t. Your job is to decide what "missing" should mean.

## NaN is not equal to itself

This is the single most surprising rule in floating point, and it''s mandated by the IEEE 754 standard. NaN compares as *unequal to everything, including itself.*

```python run
x = np.nan
print("x == x:      ", x == x)
print("x != x:      ", x != x)
print("np.isnan(x): ", np.isnan(x))

values = np.array([1.0, np.nan, 3.0])
print("values == np.nan:", values == np.nan)
print("np.isnan(values):", np.isnan(values))
```

So `values == np.nan` can **never** find missing values. It''s always all `False`. Always use the dedicated tests:

| Function | True where the value is… |
|---|---|
| `np.isnan(a)` | NaN |
| `np.isinf(a)` | `+inf` or `-inf` |
| `np.isfinite(a)` | a normal number (not NaN, not ±inf) |
| `np.isposinf(a)` / `np.isneginf(a)` | `+inf` / `-inf` specifically |

> **Pitfall:** `if value == np.nan:` is a classic silent bug. It never triggers, so your "missing value" branch is dead code. Linters flag it; reviewers miss it.

```python predict id=predict-nan-count title="How many matches?"
data = np.array([np.nan, 2.0, np.nan, 4.0])
print((data == np.nan).sum(), np.isnan(data).sum())
--- options
2 2
* 0 2
0 0
2 0
--- explain
`data == np.nan` is `False` everywhere because NaN never equals anything, so its sum is `0`. `np.isnan` correctly finds the **2** missing values. Summing a boolean array counts the `True`s.
```

## NaN-aware statistics

NumPy ships a family of functions that **skip** NaN instead of propagating it. Same names, with a `nan` prefix:

```python run
readings = np.array([21.5, 22.0, np.nan, 23.1, 22.4])

print("nanmean:", np.nanmean(readings))
print("nansum: ", np.nansum(readings))
print("nanmax: ", np.nanmax(readings))
print("nanstd: ", round(np.nanstd(readings), 4))
print("valid count:", np.count_nonzero(~np.isnan(readings)))
```

They also take `axis`, which is perfect for tables where each column has its own gaps:

```python run
# rows = days, columns = three weather stations
table = np.array([
    [14.2, np.nan, 15.1],
    [13.8, 12.9,   np.nan],
    [np.nan, 13.4, 15.6],
    [14.9, 13.1,   15.0],
])
print("per-station mean:", np.nanmean(table, axis=0).round(2))
print("per-day max:     ", np.nanmax(table, axis=1))
```

> **Under the hood:** `np.nanmean(a)` is equivalent to `a[~np.isnan(a)].mean()` for a 1-D array, but it handles `axis` for you and never materialises the filtered copy row by row.

```python exercise id=station-averages title="Average each station, ignoring gaps"
# Each column is a sensor; NaN marks a missed reading.
temps = np.array([
    [20.1, 19.8, np.nan, 21.0],
    [20.4, np.nan, 18.9, 21.3],
    [np.nan, 19.5, 19.1, 20.8],
    [20.0, 19.9, 19.4, np.nan],
])

# TODO 1: `station_mean`: the mean of each column, ignoring NaN (shape (4,))
station_mean = ...

# TODO 2: `missing_per_station`: how many NaNs each column has (shape (4,), integers)
missing_per_station = ...
--- solution
temps = np.array([
    [20.1, 19.8, np.nan, 21.0],
    [20.4, np.nan, 18.9, 21.3],
    [np.nan, 19.5, 19.1, 20.8],
    [20.0, 19.9, 19.4, np.nan],
])

station_mean = np.nanmean(temps, axis=0)
missing_per_station = np.isnan(temps).sum(axis=0)
--- test
assert station_mean is not ..., "Replace the `...` after `station_mean =` with your code."
assert missing_per_station is not ..., "Replace the `...` after `missing_per_station =` with your code."
station_mean = np.asarray(station_mean)
assert station_mean.shape == (4,), f"`station_mean` should have one value per column, shape (4,), but has shape {station_mean.shape}. Check your axis."
assert not np.isnan(station_mean).any(), "`station_mean` still contains NaN. Use a NaN-aware function so missing readings are skipped."
expected = np.array([np.mean([20.1, 20.4, 20.0]), np.mean([19.8, 19.5, 19.9]), np.mean([18.9, 19.1, 19.4]), np.mean([21.0, 21.3, 20.8])])
assert np.allclose(station_mean, expected), f"`station_mean` should be {expected.round(3)} but is {station_mean.round(3)}."
missing_per_station = np.asarray(missing_per_station)
assert missing_per_station.shape == (4,), f"`missing_per_station` should have shape (4,) but has {missing_per_station.shape}."
assert np.array_equal(missing_per_station, [1, 1, 1, 1]), f"Each column has exactly one NaN, but you got {missing_per_station}."
--- hint
There''s a `nan`-prefixed version of `mean`. Columns run along `axis=0`.
--- hint
To count NaNs, build a boolean mask with `np.isnan(temps)` and sum it down the columns.
```

## Repairing missing data

Skipping NaN is one strategy. Often you need a complete array, for example to feed a model. Common repairs:

```python run
signal = np.array([3.0, np.nan, 4.5, np.nan, np.nan, 6.0])

# 1. Drop missing values
print("dropped: ", signal[~np.isnan(signal)])

# 2. Fill with a constant (or the mean of the valid values)
print("filled 0:", np.nan_to_num(signal, nan=0.0))
print("mean fill:", np.where(np.isnan(signal), np.nanmean(signal), signal))

# 3. Linear interpolation from the neighbouring valid points
idx = np.arange(signal.size)
ok = ~np.isnan(signal)
print("interp:  ", np.interp(idx, idx[ok], signal[ok]))
```

`np.nan_to_num` can also replace infinities (`posinf=`, `neginf=`), and `np.where(mask, replacement, original)` is the general-purpose "fix these positions" tool.

> **In the wild:** pandas'' `fillna`, `dropna` and `interpolate` are thin, friendly wrappers around exactly these NumPy operations, and pandas uses NaN as its missing marker for float columns.

```python exercise id=fill-column-means title="Impute with column means"
# Rows are patients, columns are lab measurements. Fill each NaN
# with the mean of the *valid* values in its own column.
labs = np.array([
    [5.1, 140.0, np.nan],
    [4.8, np.nan, 0.9],
    [np.nan, 138.0, 1.1],
    [5.5, 142.0, 1.0],
])

# TODO: build `filled`, a copy of `labs` with no NaN left.
# Don''t modify `labs` itself.
filled = ...
--- solution
labs = np.array([
    [5.1, 140.0, np.nan],
    [4.8, np.nan, 0.9],
    [np.nan, 138.0, 1.1],
    [5.5, 142.0, 1.0],
])

col_means = np.nanmean(labs, axis=0)
filled = np.where(np.isnan(labs), col_means, labs)
--- test
assert filled is not ..., "Replace the `...` after `filled =` with your code."
filled = np.asarray(filled, dtype=float)
assert filled.shape == (4, 3), f"`filled` should keep the shape (4, 3) but has {filled.shape}."
assert not np.isnan(filled).any(), "`filled` still contains NaN values."
assert np.isnan(labs).sum() == 3, "Don''t modify `labs` in place. Build a new array (np.where returns one)."
means = np.array([np.mean([5.1, 4.8, 5.5]), np.mean([140.0, 138.0, 142.0]), np.mean([0.9, 1.1, 1.0])])
expected = np.where(np.isnan(labs), means, labs)
assert np.allclose(filled[~np.isnan(labs)], labs[~np.isnan(labs)]), "Valid (non-NaN) values must stay exactly as they were."
assert np.allclose(filled, expected), f"Each NaN should become its column''s mean {means.round(3)}. Got:\n{filled.round(3)}"
--- hint
First compute one mean per column with `np.nanmean(labs, axis=0)`. That gives shape `(3,)`.
--- hint
`np.where(np.isnan(labs), col_means, labs)` broadcasts the `(3,)` means across every row: NaN positions take the mean, everything else keeps its value.
```

## Division by zero: silent infinities

Plain Python raises `ZeroDivisionError`. NumPy arrays follow the IEEE floating-point rules instead: `x / 0` is `±inf`, `0 / 0` is `nan`, and the computation **keeps going**.

```python run
num = np.array([1.0, -2.0, 0.0, 4.0])
den = np.array([2.0, 0.0, 0.0, 8.0])

ratio = num / den
print("ratio:", ratio)
print("finite?", np.isfinite(ratio))
print("sqrt(-1):", np.sqrt(np.array([-1.0])))
print("float32 overflow:", np.float32(3e38) * np.float32(10))
```

No error and no message: `inf` and `nan` just flow quietly into whatever comes next. That''s why careful numeric code **checks its own results** with `np.isfinite` rather than hoping something would have complained.

> **On your desktop:** regular NumPy also prints a `RuntimeWarning: divide by zero encountered…` for the cell above. In this browser runtime the warning never appears, because WebAssembly has no floating-point exception flags. Either way, a warning scrolling past in a log is easy to miss. On desktop, `with np.errstate(divide="ignore", invalid="ignore"):` silences expected warnings for one block, and `np.errstate(divide="raise")` turns them into exceptions. Avoid `np.seterr(all="ignore")` at module level, because it hides real bugs everywhere.

The robust pattern: decide what a bad division *should* produce, then either repair the result or never compute it.

```python run
num = np.array([1.0, -2.0, 0.0, 4.0])
den = np.array([2.0, 0.0, 0.0, 8.0])

# Repair afterwards: replace anything non-finite
ratio = num / den
print("repaired: ", np.where(np.isfinite(ratio), ratio, 0.0))

# Or avoid the bad division entirely: only divide where den != 0
print("out/where:", np.divide(num, den, out=np.zeros_like(num), where=den != 0))
```

The `where=` argument tells the ufunc which positions to compute, and `out=` supplies the values for the positions it skips.

> **Pitfall:** always pass `out=` together with `where=`. Without it, the skipped slots contain whatever happened to be in memory.

## Comparing floats: never use `==`

Most decimal fractions can''t be represented exactly in binary. `0.1` is really `0.1000000000000000055511…`. Errors are tiny but real, and they break exact equality:

```python run
print("0.1 + 0.2 == 0.3:", 0.1 + 0.2 == 0.3)
print("0.1 + 0.2 =", repr(0.1 + 0.2))

a = np.array([0.1 + 0.2, 1 / 3 * 3, np.sqrt(2) ** 2])
b = np.array([0.3, 1.0, 2.0])
print("a == b:          ", a == b)
print("np.isclose(a, b):", np.isclose(a, b))
print("np.allclose(a, b):", np.allclose(a, b))
```

`np.isclose(a, b)` is true when $|a - b| \le \text{atol} + \text{rtol} \cdot |b|$, with defaults `rtol=1e-05` and `atol=1e-08`.

- **rtol** (relative) scales with the magnitude, which is good for large numbers.
- **atol** (absolute) is a floor for values near zero, where relative error is meaningless.

```python run
big = 1_000_000.0
print("isclose(1e6, 1e6 + 1):", np.isclose(big, big + 1))   # relative diff 1e-6 < rtol
print("isclose(1e-9, 2e-9):  ", np.isclose(1e-9, 2e-9))     # both below atol
print("…with atol=0:         ", np.isclose(1e-9, 2e-9, atol=0))
print("NaN vs NaN:           ", np.isclose(np.nan, np.nan), np.isclose(np.nan, np.nan, equal_nan=True))
```

> **Pitfall:** the default `atol=1e-08` means *every* pair of numbers smaller than about `1e-8` is "close", so `1e-9` and `2e-9` compare equal even though one is twice the other. When you work with tiny quantities (probabilities, gradients), set `atol` deliberately.

```python debug id=converged-check title="The optimizer never converges"
# Gradient descent on f(x) = (x - 0.3)**2 ; it should stop near x = 0.3
x = 0.0
learning_rate = 0.1
steps = 0

while steps < 500:
    x = x - learning_rate * 2 * (x - 0.3)
    steps += 1
    if x == 0.3:          # stop once we''ve reached the minimum
        break

converged = steps < 500
print(f"x = {x!r} after {steps} steps, converged={converged}")
--- solution
# Gradient descent on f(x) = (x - 0.3)**2 ; it should stop near x = 0.3
x = 0.0
learning_rate = 0.1
steps = 0

while steps < 500:
    x = x - learning_rate * 2 * (x - 0.3)
    steps += 1
    if np.isclose(x, 0.3):          # stop once we''ve reached the minimum
        break

converged = steps < 500
print(f"x = {x!r} after {steps} steps, converged={converged}")
--- test
assert converged, f"The loop still ran all {steps} steps. The stopping condition never fired."
assert abs(x - 0.3) < 1e-4, f"`x` should end very close to 0.3 but is {x!r}."
assert steps < 120, f"It took {steps} steps. Use a tolerance-based comparison so it stops as soon as x is close to 0.3."
--- hint
Run it: `x` gets *extremely* close to 0.3. Why does the `if` never fire?
--- hint
Floating-point results almost never land exactly on a decimal like 0.3. Compare with a tolerance (`np.isclose`) instead of `==`.
```

## Catastrophic cancellation and summation

Subtracting two nearly-equal numbers wipes out most of their significant digits. This is **catastrophic cancellation**. A float64 carries about 16 significant digits; if two numbers agree in the first 12, their difference has only about 4 left.

```python run
# Variance via the "textbook shortcut"  E[x²] - E[x]²  vs the stable two-pass formula
data = 1e9 + np.array([4.0, 7.0, 13.0, 16.0])   # true variance = 22.5

shortcut = np.mean(data**2) - np.mean(data) ** 2
two_pass = np.mean((data - data.mean()) ** 2)
print("shortcut:", shortcut)
print("two-pass:", two_pass)
print("np.var:  ", np.var(data))
```

The shortcut subtracts two numbers around `1e18` and returns a **negative variance**, which is mathematically impossible. `np.var` centres the data first, so it gets the right answer. Precision also matters when adding many numbers:

```python run
values = np.full(1_000_000, 0.1, dtype=np.float32)

print("float32 naive loop-style:", np.cumsum(values)[-1])
print("float32 np.sum (pairwise):", values.sum())
print("float64 np.sum:          ", values.astype(np.float64).sum())
```

`np.cumsum` accumulates strictly left-to-right, so rounding errors pile up. `np.sum` uses **pairwise summation**, which is far more accurate, and switching to float64 helps even more. (The float64 total is not exactly 100000 because `0.1` itself was rounded when stored as float32.)

> **Tip:** if a result depends on subtracting nearly-equal quantities, rearrange the math, for instance by subtracting the mean first. Library functions like `np.var`, `np.std`, `np.logaddexp` and `np.log1p` exist precisely to avoid these traps.

## Integer arrays can''t hold NaN

NaN is a *float* concept. There''s no integer bit pattern for "missing", so integer arrays can''t store it:

```python run error
counts = np.array([3, 5, 2, 8])
print(counts.dtype)
counts[1] = np.nan
```

```python run
counts = np.array([3, 5, 2, 8])
as_float = counts.astype(float)      # promote first
as_float[1] = np.nan
print(as_float, as_float.dtype)

# A NaN can also sneak in through ordinary math: int / int is float
print(np.array([1, 2]) / np.array([0, 2]))
```

> **In the wild:** this is why a pandas integer column silently becomes `float64` the moment a value goes missing (unless you opt into pandas'' nullable `Int64` type).

```python debug id=missing-sentinel title="Missing values counted as real data"
# A survey stored "no answer" as -1. Compute the average rating (1-5)
# over people who actually answered, and how many skipped.
raw = np.array([4, -1, 5, 3, -1, 2, 5, -1])

ratings = raw.copy()
ratings[ratings == -1] = 0        # mark missing

answered = ratings.size
average = ratings.mean()
print(f"{answered} answers, average {average:.2f}")
--- solution
# A survey stored "no answer" as -1. Compute the average rating (1-5)
# over people who actually answered, and how many skipped.
raw = np.array([4, -1, 5, 3, -1, 2, 5, -1])

ratings = raw.astype(float)
ratings[ratings == -1] = np.nan   # mark missing

answered = np.count_nonzero(~np.isnan(ratings))
average = np.nanmean(ratings)
print(f"{answered} answers, average {average:.2f}")
--- test
assert answered == 5, f"Five people answered, but `answered` is {answered}."
assert np.isclose(average, 3.8), f"The average of the real answers (4, 5, 3, 2, 5) is 3.8, but `average` is {average}."
assert "3.80" in _stdout, "Keep the print so the result is shown."
--- hint
Replacing "missing" with `0` makes it look like a real (terrible) rating. What value means "missing" in NumPy?
--- hint
You can''t put NaN into an integer array. Convert with `.astype(float)` first, then use NaN-aware functions for the count and the mean.
```

```python exercise id=safe-growth title="Safe percentage change"
# Week-over-week revenue. Some weeks had zero revenue (store closed).
previous = np.array([200.0, 0.0, 150.0, 0.0, 80.0])
current = np.array([220.0, 50.0, 120.0, 0.0, 100.0])

# TODO: `growth` = (current - previous) / previous, as a percentage (* 100).
# Wherever `previous` is 0, the growth is undefined: put NaN there
# (no inf allowed in the result).
growth = ...
--- solution
previous = np.array([200.0, 0.0, 150.0, 0.0, 80.0])
current = np.array([220.0, 50.0, 120.0, 0.0, 100.0])

growth = np.divide(current - previous, previous, out=np.full_like(previous, np.nan), where=previous != 0) * 100
--- test
assert growth is not ..., "Replace the `...` after `growth =` with your code."
growth = np.asarray(growth, dtype=float)
assert growth.shape == (5,), f"`growth` should have shape (5,) but has {growth.shape}."
assert np.array_equal(np.isnan(growth), previous == 0), f"NaN should appear exactly where `previous` is 0. Got {growth}."
assert np.allclose(growth[previous != 0], [10.0, -20.0, 25.0]), f"Growth for the valid weeks should be [10, -20, 25] percent, got {growth[previous != 0]}."
assert not np.isinf(growth).any(), "`growth` contains infinity. Replace those positions with NaN."
--- hint
Dividing by zero silently produces `inf` (or `nan` for 0/0). Those positions need to end up as NaN.
--- hint
Either divide and then set `growth[previous == 0] = np.nan`, or never divide there: `np.divide(..., out=np.full_like(previous, np.nan), where=previous != 0)`.
```

## Recap

- `np.nan` marks missing or undefined values, and it propagates through every calculation.
- NaN is never equal to anything, even itself. Detect it with `np.isnan`, `np.isinf` and `np.isfinite`, never `==`.
- `np.nanmean`, `np.nansum`, `np.nanmax` and friends skip NaN, and they support `axis`.
- Repair gaps with boolean masks, `np.where`, `np.nan_to_num` or `np.interp`.
- Division by zero silently gives `inf`/`nan`. Check results with `np.isfinite`, or divide only where it''s safe with `where=` and `out=`.
- Compare floats with `np.isclose`/`np.allclose` and think about `rtol` and `atol`. Beware cancellation, and prefer float64 for long sums.

**Up next:** images are just arrays. You''ll crop, flip, recolor and blur pictures using nothing but NumPy.
', 0, '[]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_7_2', 'sec_numpy_7', 'crs_numpy_mastery', 'Images are just arrays', 'interactive', 1, 1080, NULL, NULL, 'Every photo on your phone, every frame of video and every image fed to a neural network is, underneath, just a NumPy-style array of numbers. Once you see an image as an array, editing it is a matter of indexing, slicing and arithmetic you already know.

In this lesson you''ll take apart a small picture: you''ll split it into color channels, convert it to grayscale with a dot product, crop and rotate it with slicing, brighten it *without* the classic overflow bug, find objects with boolean masks, and blur it with a few shifted slices. Along the way you''ll see exactly what preprocessing libraries like torchvision do before an image reaches a model.

## An image is a 3-D array

A color image is stored as an array of shape `(height, width, 3)`: rows of pixels, columns of pixels, and three **channels** (red, green, blue). Each value is usually a `uint8`, an unsigned 8-bit integer from `0` (none of that color) to `255` (full intensity).

To avoid downloading anything, this lesson draws its own picture. The setup below builds a small landscape (sky, sun, grass and a red house) and defines a `show()` helper for displaying images side by side.

```python setup
def make_scene(h=96, w=128):
    """A tiny synthetic landscape: sky gradient, sun, grass and a red house."""
    y, x = np.mgrid[0:h, 0:w]
    t = 1 - y / (h - 1)                              # 1 at the top, 0 at the bottom
    img = np.zeros((h, w, 3), dtype=np.uint8)
    img[..., 0] = 70                                  # red channel
    img[..., 1] = (60 + 150 * t).astype(np.uint8)    # green channel
    img[..., 2] = (100 + 153 * t).astype(np.uint8)   # blue channel
    sun = (x - 95) ** 2 + (y - 25) ** 2 < 14 ** 2
    img[sun] = [255, 210, 60]
    img[y > h * 0.7] = [60, 140, 70]                 # grass
    img[50:72, 20:50] = [200, 40, 40]                # house
    return img

scene = make_scene()
```

```python setup
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

def show(*images, titles=None, height=2.4):
    """Display images (H, W, 3) or grayscale (H, W), values 0-255, side by side."""
    tiles = []
    for im in images:
        im = np.clip(np.asarray(im), 0, 255).astype(np.uint8)
        tiles.append(np.repeat(im[..., None], 3, axis=2) if im.ndim == 2 else im)
    h = max(t.shape[0] for t in tiles)
    gap = np.full((h, 10, 3), 255, dtype=np.uint8)
    parts, centers, x = [], [], 0
    for t in tiles:
        padded = np.full((h, t.shape[1], 3), 255, dtype=np.uint8)
        padded[: t.shape[0]] = t
        parts += [padded, gap]
        centers.append(x + t.shape[1] / 2)
        x += t.shape[1] + gap.shape[1]
    canvas = np.concatenate(parts[:-1], axis=1)
    fig, ax = plt.subplots(figsize=(height * canvas.shape[1] / h, height + 0.3))
    ax.imshow(canvas, interpolation="nearest")
    for i, cx in enumerate(centers):
        label = titles[i] if titles else f"{images[i].shape}"
        ax.text(cx, -3, label, ha="center", va="bottom", fontsize=9)
    ax.axis("off")
```

```python run
print("shape:", scene.shape)
print("dtype:", scene.dtype)
print("values from", scene.min(), "to", scene.max())
print("top-left pixel (R, G, B):", scene[0, 0])
show(scene, titles=["our scene"])
```

Reading `scene[row, col]` gives one pixel, a length-3 array of red, green and blue. Row `0` is the **top** of the image, which is the opposite of a math plot''s y-axis. That convention trips people up when they flip or crop.

> **Under the hood:** `96 × 128 × 3 = 36,864` bytes. A 12-megapixel phone photo is the same idea at `3000 × 4000 × 3`, about 36 MB uncompressed. That''s why images are stored as `uint8` and not `float64`, which would be eight times larger.

## Channels

Slicing the last axis pulls out a single channel as a 2-D grayscale image. Bright areas mean "a lot of this color".

```python run
red, green, blue = scene[..., 0], scene[..., 1], scene[..., 2]
print("red channel shape:", red.shape)
print("mean R, G, B:", red.mean().round(1), green.mean().round(1), blue.mean().round(1))
show(red, green, blue, titles=["red", "green", "blue"])
```

The sun and house glow in the red channel, while the sky glows in blue. The `...` (ellipsis) means "all the leading axes", so `scene[..., 0]` is the same as `scene[:, :, 0]`, and it keeps working for batches of images shaped `(N, H, W, 3)`.

```python predict id=predict-pixel-shape title="What shape is this?"
pixel_row = scene[10, :, :]
print(pixel_row.shape)
--- options
(10, 3)
* (128, 3)
(96, 3)
(3,)
--- explain
Fixing the row index (`10`) removes the first axis. What remains is every column (`128`) and every channel (`3`): one horizontal line of pixels.
```

## Grayscale with a dot product

To convert to grayscale, take a **weighted sum** of the channels. Human eyes are most sensitive to green and least to blue, so the standard (ITU-R BT.601) weights are:

$$\text{gray} = 0.299\,R + 0.587\,G + 0.114\,B$$

A weighted sum over the last axis is exactly what `@` (matrix multiplication) does when the right operand is a 1-D vector: `(H, W, 3) @ (3,) → (H, W)`.

```python run
weights = np.array([0.299, 0.587, 0.114])
gray = scene @ weights
print(gray.shape, gray.dtype, gray.min().round(2), gray.max().round(2))
show(scene, gray.astype(np.uint8), titles=["color", "grayscale"])
```

The result is `float64`. To store it as an image again, you round and convert back to `uint8`.

```python exercise id=to-grayscale title="Convert to an 8-bit grayscale image"
weights = np.array([0.299, 0.587, 0.114])

# TODO: `gray8` should be the grayscale version of `scene`:
#   - shape (96, 128)
#   - dtype uint8
#   - each pixel = the weighted sum of R, G, B, ROUNDED to the nearest integer
gray8 = ...
--- solution
weights = np.array([0.299, 0.587, 0.114])

gray8 = np.round(scene @ weights).astype(np.uint8)
--- test
assert gray8 is not ..., "Replace the `...` after `gray8 =` with your code."
gray8 = np.asarray(gray8)
assert gray8.shape == (96, 128), f"`gray8` should have shape (96, 128), one value per pixel, but has {gray8.shape}."
assert gray8.dtype == np.uint8, f"`gray8` should have dtype uint8 but has {gray8.dtype}. Convert with .astype(np.uint8)."
_ref = np.round(make_scene() @ np.array([0.299, 0.587, 0.114])).astype(np.uint8)
_diff = np.abs(gray8.astype(int) - _ref.astype(int))
assert _diff.max() <= 1 and np.mean(_diff == 0) > 0.99, "Some pixels are off. Make sure you round *before* converting to uint8 (astype truncates)."
assert np.array_equal(gray8, _ref), "Almost! A few pixels differ by 1. Use np.round(...) before .astype(np.uint8)."
--- hint
`scene @ weights` gives the float grayscale values. You saw it just above.
--- hint
`.astype(np.uint8)` *truncates* (172.9 becomes 172). Wrap the float values in `np.round(...)` first.
```

## Cropping, flipping and rotating

Geometry is pure indexing. Slicing crops; a negative step flips; `np.rot90` rotates in 90° steps. All of these return **views**, so they''re instant and use no extra memory.

```python run
crop = scene[40:80, 10:60]          # rows 40-79, columns 10-59
upside_down = scene[::-1]           # reverse the rows
mirrored = scene[:, ::-1]           # reverse the columns
rotated = np.rot90(scene)           # 90° counter-clockwise

print("crop:", crop.shape, " rotated:", rotated.shape)
show(crop, upside_down, mirrored, rotated, titles=["crop", "flip rows", "mirror", "rot90"])
```

`np.flip(scene, axis=0)` and `np.flip(scene, axis=1)` are named equivalents of `scene[::-1]` and `scene[:, ::-1]`. Notice that the rotated image has shape `(128, 96, 3)`: height and width swap.

> **Pitfall:** never write `scene[::-1, ::-1, ::-1]` to "flip everything". Reversing the *last* axis swaps the R and B channels, turning your red house blue. Flip only the spatial axes (0 and 1).

```python exercise id=house-thumbnail title="Make a mirrored thumbnail of the house"
# The house occupies rows 50-71 and columns 20-49 of `scene`.

# TODO: `thumb` = the house region, mirrored left-to-right,
# keeping only every 2nd row and every 2nd column (half resolution).
thumb = ...
--- solution
thumb = scene[50:72, 20:50][::2, ::-2]
--- test
assert thumb is not ..., "Replace the `...` after `thumb =` with your code."
thumb = np.asarray(thumb)
_house = make_scene()[50:72, 20:50]
assert thumb.ndim == 3 and thumb.shape[2] == 3, f"`thumb` should still be a color image (H, W, 3) but has shape {thumb.shape}. Don''t slice away the channels."
assert thumb.shape == (11, 15, 3), f"Half of 22 rows × 30 columns is (11, 15, 3), but `thumb` has shape {thumb.shape}."
_options = [_house[::2, ::-1][:, ::2], _house[::2, ::-2], _house[:, ::-1][::2, ::2], _house[::2, ::2][:, ::-1]]
assert any(np.array_equal(thumb, o) for o in _options), "The crop or the mirroring isn''t right. Check the region (rows 50:72, columns 20:50), and reverse the columns, not the rows."
--- hint
First crop with `scene[50:72, 20:50]`, which has shape (22, 30, 3).
--- hint
A step of `2` keeps every second element and a step of `-1` reverses. You can chain slices: `region[::2, ::-1][:, ::2]`, or combine them into a single `::-2`.
```

## Brightness, contrast and the overflow trap

Brightening means adding to every value. But `uint8` can only hold 0–255, and NumPy integer arithmetic **wraps around** silently: `250 + 10` becomes `4`.

```python run
bright_wrong = scene + 80                                  # uint8 + int stays uint8: wraps!
bright_right = np.clip(scene.astype(np.int16) + 80, 0, 255).astype(np.uint8)

print("sun pixel before:", scene[25, 95], " wrong:", bright_wrong[25, 95], " right:", bright_right[25, 95])
show(scene, bright_wrong, bright_right, titles=["original", "+80 (wrapped)", "+80 (clipped)"])
```

The fix is always the same three steps: **widen** the dtype (`int16`, `int32` or `float`), do the math, then **clip** to `[0, 255]` and convert back.

```python predict id=predict-uint8-wrap title="What does uint8 arithmetic give?"
a = np.array([250, 100], dtype=np.uint8)
print(a + np.uint8(10))
--- options
[260 110]
[255 110]
* [  4 110]
[250 110]
--- explain
`uint8` arithmetic is modulo 256: `250 + 10 = 260`, and `260 - 256 = 4`. NumPy doesn''t raise an error or clip for you, so it''s on you to widen and clip.
```

Contrast stretches values away from the middle gray (128). The same widen-compute-clip recipe applies:

```python run
def adjust_contrast(img, factor):
    out = (img.astype(np.float64) - 128) * factor + 128
    return np.clip(out, 0, 255).astype(np.uint8)

show(adjust_contrast(scene, 0.5), scene, adjust_contrast(scene, 1.8), titles=["contrast ×0.5", "original", "contrast ×1.8"])
```

```python debug id=brighten-overflow title="The sun turned black"
def brighten(img, amount):
    """Add `amount` to every channel, saturating at 255."""
    out = img + amount
    out[out > 255] = 255
    return out

bright = brighten(scene, 60)
print("sun pixel:", bright[25, 95])     # should be [255 255 120]
--- solution
def brighten(img, amount):
    """Add `amount` to every channel, saturating at 255."""
    out = img.astype(np.int16) + amount
    out[out > 255] = 255
    return out.astype(np.uint8)

bright = brighten(scene, 60)
print("sun pixel:", bright[25, 95])     # should be [255 255 120]
--- test
_src = make_scene()
_b = brighten(_src, 60)
assert isinstance(_b, np.ndarray) and _b.shape == _src.shape, f"`brighten` should return an image with the same shape {_src.shape}."
assert _b.dtype == np.uint8, f"`brighten` should return a uint8 image (so it can be displayed and stored), but returned {_b.dtype}."
assert np.array_equal(_b[25, 95], [255, 255, 120]), f"The sun pixel should saturate to [255 255 120] but is {_b[25, 95]}. Values are still wrapping around."
assert np.array_equal(_b, np.clip(_src.astype(int) + 60, 0, 255).astype(np.uint8)), "Some pixels are still wrong. Every channel should be min(value + amount, 255)."
assert np.array_equal(brighten(_src, 0), _src), "brighten(img, 0) should return an identical image."
--- hint
Debug it and look at `out` right after `img + amount`. Can a `uint8` ever be greater than 255?
--- hint
`out > 255` is never True because the overflow already happened during the addition. Widen first (`img.astype(np.int16)`), then saturate, then convert back to `np.uint8`.
```

## Finding things with masks

A boolean condition on the channels produces a **mask**: a `(H, W)` array that is `True` wherever a pixel matches. Combine conditions with `&` and `|` (always in parentheses).

```python run
r, g, b = (scene[..., i].astype(int) for i in range(3))
is_red = (r > 150) & (g < 80) & (b < 80)

rows, cols = np.nonzero(is_red)
print("red pixels:", is_red.sum())
print("bounding box: rows", rows.min(), "to", rows.max(), "| cols", cols.min(), "to", cols.max())

highlight = scene.copy()
highlight[is_red] = [255, 255, 0]          # paint the matches yellow
show(is_red.astype(np.uint8) * 255, highlight, titles=["mask", "highlighted"])
```

`np.nonzero(mask)` returns the row and column indices of every `True`. Their min and max give the object''s bounding box, and their means give its center. This is the core of classic color-based object tracking.

```python exercise id=find-the-sun title="Locate the sun"
# The sun''s pixels are bright red, fairly bright green and low blue:
#   R > 230, G > 180, B < 100

# TODO 1: `sun_mask`: boolean array of shape (96, 128), True on sun pixels
sun_mask = ...

# TODO 2: `center`: (row, col) of the sun''s center, as the mean row
# and mean column of the sun pixels (two floats in a tuple)
center = ...
--- solution
r, g, b = scene[..., 0], scene[..., 1], scene[..., 2]
sun_mask = (r > 230) & (g > 180) & (b < 100)

rows, cols = np.nonzero(sun_mask)
center = (rows.mean(), cols.mean())
--- test
assert sun_mask is not ..., "Replace the `...` after `sun_mask =` with your code."
assert center is not ..., "Replace the `...` after `center =` with your code."
sun_mask = np.asarray(sun_mask)
assert sun_mask.shape == (96, 128), f"`sun_mask` should have shape (96, 128), one value per pixel, but has {sun_mask.shape}."
assert sun_mask.dtype == bool, f"`sun_mask` should be a boolean array but has dtype {sun_mask.dtype}. Combine comparisons with &."
_s = make_scene().astype(int)
_ref = (_s[..., 0] > 230) & (_s[..., 1] > 180) & (_s[..., 2] < 100)
assert sun_mask.sum() == _ref.sum(), f"The sun has {_ref.sum()} pixels but your mask has {sun_mask.sum()}. Check each condition and combine them with & (not `and`)."
assert np.array_equal(sun_mask, _ref), "The mask has the right count but marks the wrong pixels."
assert len(center) == 2, "`center` should be a pair: (row, col)."
assert np.allclose(center, (25, 95), atol=0.5), f"The sun is centered near row 25, column 95, but `center` is {tuple(np.round(center, 2))}. Did you swap rows and columns?"
--- hint
Pull out the channels with `scene[..., 0]`, `scene[..., 1]` and `scene[..., 2]`, then combine three comparisons with `&`, each in parentheses.
--- hint
`rows, cols = np.nonzero(sun_mask)` gives the coordinates of every sun pixel. The center is their means.
```

## Blurring with shifted slices

A **box blur** replaces each pixel with the average of its 3×3 neighbourhood. You don''t need a loop over pixels: pad the image by one pixel, then add up the nine shifted copies of it. Each shifted slice lines up a different neighbour with every pixel at once.

```python run
gray = (scene @ [0.299, 0.587, 0.114])
padded = np.pad(gray, 1, mode="edge")        # (98, 130): repeat edge pixels
H, W = gray.shape

total = np.zeros_like(gray)
for dy in range(3):
    for dx in range(3):
        total += padded[dy:dy + H, dx:dx + W]
blurred = total / 9

print("padded:", padded.shape, " blurred:", blurred.shape)
show(gray.astype(np.uint8), blurred.astype(np.uint8), titles=["sharp", "3×3 box blur"])
```

The nine iterations of that tiny loop each process the *whole* image in one vectorized step. This "shift and accumulate" pattern is how convolutions are often explained, and it''s the operation at the heart of convolutional neural networks.

> **In the wild:** for larger kernels you''d reach for `scipy.ndimage.uniform_filter` or `np.lib.stride_tricks.sliding_window_view` (covered in the performance lesson), but the idea is exactly this.

```python exercise id=box-blur title="Write a k×k box blur"
def box_blur(gray, k):
    """Blur a 2-D float image with a k×k box filter (k odd).

    Pad with mode="edge" by k // 2 pixels, then average the k*k shifted
    slices. The result must have the same shape as `gray`.
    """
    # TODO
    ...

result = box_blur(scene @ [0.299, 0.587, 0.114], 5)
--- solution
def box_blur(gray, k):
    """Blur a 2-D float image with a k×k box filter (k odd)."""
    r = k // 2
    padded = np.pad(gray, r, mode="edge")
    H, W = gray.shape
    total = np.zeros(gray.shape, dtype=float)
    for dy in range(k):
        for dx in range(k):
            total += padded[dy:dy + H, dx:dx + W]
    return total / (k * k)

result = box_blur(scene @ [0.299, 0.587, 0.114], 5)
--- test
def _ref_blur(g, k):
    r = k // 2
    p = np.pad(g, r, mode="edge")
    H, W = g.shape
    return sum(p[dy:dy + H, dx:dx + W] for dy in range(k) for dx in range(k)) / (k * k)
_g = make_scene() @ np.array([0.299, 0.587, 0.114])
_out = box_blur(_g, 3)
assert _out is not None, "`box_blur` returned None. Did you forget `return`?"
_out = np.asarray(_out)
assert _out.shape == _g.shape, f"The blurred image should keep the shape {_g.shape}, but has {_out.shape}. Pad by k // 2 before slicing."
assert np.allclose(_out, _ref_blur(_g, 3)), "box_blur(gray, 3) gives the wrong values. Each pixel should be the mean of its 3×3 neighbourhood (edge-padded)."
assert np.allclose(box_blur(_g, 5), _ref_blur(_g, 5)), "Works for k=3 but not k=5. Make the padding and the loops depend on k."
_rng = np.random.default_rng(1)
_n = _rng.uniform(0, 255, size=(7, 9))
assert np.allclose(box_blur(_n, 3), _ref_blur(_n, 3)), "Doesn''t work on a different image size. Avoid hard-coding 96 and 128."
assert np.allclose(box_blur(_n, 1), _n), "With k=1 the image should be unchanged."
--- hint
Start from the 3×3 version above and replace every hard-coded `3` and `1` with something based on `k`: the padding is `k // 2` and there are `k` offsets in each direction.
--- hint
`H, W = gray.shape`, then accumulate `padded[dy:dy + H, dx:dx + W]` for `dy` and `dx` in `range(k)`, and divide by `k * k`. Don''t forget to `return` it.
```

## Images for machine learning

Before an image reaches a neural network it''s typically:

1. converted to float and **scaled to [0, 1]** by dividing by 255,
2. **standardized** per channel (subtract the mean, divide by the standard deviation),
3. **transposed** from `(H, W, C)` to `(C, H, W)`, the layout PyTorch expects,
4. **stacked** into a batch `(N, C, H, W)`.

```python run
x = scene.astype(np.float32) / 255.0                  # 1. [0, 1]
mean = x.mean(axis=(0, 1))                            # one mean per channel
std = x.std(axis=(0, 1))
x = (x - mean) / std                                  # 2. standardize
chw = np.transpose(x, (2, 0, 1))                      # 3. (3, 96, 128)
batch = np.stack([chw, chw[:, :, ::-1]])              # 4. image + mirrored copy

print("per-channel mean:", mean.round(3))
print("after standardizing:", x.mean(axis=(0, 1)).round(6), x.std(axis=(0, 1)).round(3))
print("CHW:", chw.shape, " batch:", batch.shape, batch.dtype)
```

Note `axis=(0, 1)`: reducing over height *and* width at once leaves one statistic per channel. The mirrored copy in the batch is a simple form of **data augmentation**.

> **In the wild:** `torchvision.transforms.ToTensor()` performs steps 1 and 3; `Normalize(mean, std)` performs step 2. There''s no magic in them, just the NumPy you wrote above.

## Recap

- A color image is a `(H, W, 3)` `uint8` array: rows, columns, channels. Row 0 is the top.
- Channels are slices (`img[..., 0]`), and grayscale is a weighted sum: `img @ [0.299, 0.587, 0.114]`.
- Crops, flips and rotations are slicing (`[::-1]`) and `np.rot90`: free views, no copying.
- `uint8` math wraps around silently. Widen, compute, `np.clip` to `[0, 255]`, convert back.
- Boolean masks over channels find objects, and `np.nonzero` gives their coordinates.
- A blur is an average of shifted slices; ML preprocessing is scale → standardize → transpose → stack.

**Up next:** structured arrays and file I/O: saving, loading and parsing real data files with NumPy.
', 0, '[]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_7_3', 'sec_numpy_7', 'crs_numpy_mastery', 'Structured arrays and file I/O', 'interactive', 2, 840, NULL, NULL, 'Sooner or later, your arrays have to leave memory. You save a trained model''s weights, load a dataset someone exported as CSV, or read a log with a few missing fields. NumPy has fast tools for all of this, plus **structured arrays**, which let one array hold records with named fields of different types, like rows in a table.

In this lesson you''ll save and load NumPy''s binary formats, parse messy text files, and build and query structured arrays. You''ll also learn where NumPy''s I/O ends and pandas should take over.

> **About files in this course:** your code runs in the browser, so files written here live in a temporary in-memory filesystem that disappears when you leave. The examples use `io.BytesIO` and `io.StringIO`, in-memory "files" that behave exactly like real ones. In a normal script you''d just pass a filename like `"weights.npy"` instead.

```python setup
import io

SALES_CSV = """day,units,price
1,12,9.99
2,7,10.49
3,15,9.49
4,9,10.99
5,20,8.99
"""

SENSOR_CSV = """# station log, exported 2024-05-01
time,temp,humidity
0,21.4,40
1,,42
2,22.1,
3,22.8,45
"""
```

## `.npy`: NumPy''s native format

`np.save` writes one array to the **`.npy`** format, a tiny header (dtype, shape, memory order) followed by the raw bytes. `np.load` reads it back **exactly**: same dtype, same shape, no rounding, and very fast.

```python run
weights = np.random.default_rng(0).normal(size=(3, 4)).astype(np.float32)

buf = io.BytesIO()            # stands in for open("weights.npy", "wb")
np.save(buf, weights)
print("bytes written:", buf.tell(), " (48 data bytes + header)")

buf.seek(0)                   # rewind before reading
restored = np.load(buf)
print(restored.dtype, restored.shape, "identical:", np.array_equal(weights, restored))
```

> **Pitfall:** after writing to an in-memory buffer, its position is at the end. Forgetting `buf.seek(0)` before `np.load` gives an `EOFError` or a "file is empty" error. Real files don''t need this, because you reopen them.

## `.npz`: many arrays in one file

`np.savez(file, name=array, ...)` bundles several arrays into one `.npz` archive (a zip of `.npy` files). `np.savez_compressed` does the same with compression. Loading gives a lazy, dictionary-like object:

```python run
rng = np.random.default_rng(1)
W = rng.normal(size=(4, 2))
b = np.zeros(2)
epoch = np.array(17)

buf = io.BytesIO()
np.savez(buf, W=W, b=b, epoch=epoch)
buf.seek(0)

ckpt = np.load(buf)
print("arrays in file:", list(ckpt.keys()))
print("W shape:", ckpt["W"].shape, " epoch:", int(ckpt["epoch"]))
```

This is a perfectly good way to checkpoint a small model or cache an expensive preprocessing step.

> **Tip:** text vs. binary matters. A float64 written as text takes ~25 characters; in `.npy` it takes exactly 8 bytes and loads with zero parsing. Use binary formats for anything you''ll reload with NumPy, and text when humans or other tools need to read it.

```python exercise id=checkpoint-roundtrip title="Save and restore a checkpoint"
rng = np.random.default_rng(42)
W = rng.normal(size=(5, 3)).astype(np.float32)
b = np.full(3, 0.1, dtype=np.float32)

# TODO 1: save BOTH arrays into the in-memory file `ckpt`
#         under the names "W" and "b" (one archive, one call).
ckpt = io.BytesIO()
...

# TODO 2: rewind `ckpt`, load it, and put the restored arrays in W2 and b2.
W2 = ...
b2 = ...
--- solution
rng = np.random.default_rng(42)
W = rng.normal(size=(5, 3)).astype(np.float32)
b = np.full(3, 0.1, dtype=np.float32)

ckpt = io.BytesIO()
np.savez(ckpt, W=W, b=b)

ckpt.seek(0)
data = np.load(ckpt)
W2 = data["W"]
b2 = data["b"]
--- test
assert W2 is not ... and b2 is not ..., "Replace the `...` after `W2 =` and `b2 =` with the arrays loaded from `ckpt`."
assert isinstance(ckpt, io.BytesIO) and ckpt.getbuffer().nbytes > 0, "Nothing was written to `ckpt`. Use np.savez(ckpt, W=W, b=b)."
ckpt.seek(0)
try:
    _z = np.load(ckpt)
    _names = sorted(_z.keys())
except Exception as _e:
    raise AssertionError(f"`ckpt` doesn''t contain an .npz archive ({type(_e).__name__}). Save both arrays in one np.savez call.")
assert _names == ["W", "b"], f"The archive should contain arrays named ''W'' and ''b'', but has {_names}. Pass them as keyword arguments."
_W = np.random.default_rng(42).normal(size=(5, 3)).astype(np.float32)
assert isinstance(W2, np.ndarray) and W2.dtype == np.float32, f"`W2` should be the float32 array loaded back from the file, got {type(W2).__name__} {getattr(W2, ''dtype'', '''')}."
assert np.array_equal(W2, _W) and np.array_equal(b2, np.full(3, 0.1, dtype=np.float32)), "The restored arrays don''t match the originals."
assert W2 is not W and b2 is not b, "`W2` and `b2` should come from `np.load(ckpt)`, not be the original variables."
--- hint
`np.savez(file, W=W, b=b)` stores each keyword argument as a named array.
--- hint
Call `ckpt.seek(0)`, then `data = np.load(ckpt)`, then index it like a dict: `data["W"]`.
```

## Text files: `savetxt` and `loadtxt`

For CSV and other plain-text tables, `np.loadtxt` parses numbers into an array. Its most useful parameters:

| Parameter | Purpose |
|---|---|
| `delimiter=","` | column separator (default: any whitespace) |
| `skiprows=1` | skip header lines |
| `usecols=(1, 2)` | read only some columns |
| `dtype=int` | parse as a specific type |
| `unpack=True` | return columns as separate arrays |
| `comments="#"` | ignore lines/text after this marker (the default) |

```python run
sales = np.loadtxt(io.StringIO(SALES_CSV), delimiter=",", skiprows=1)
print(sales.shape, sales.dtype)
print(sales)

units, price = np.loadtxt(io.StringIO(SALES_CSV), delimiter=",", skiprows=1, usecols=(1, 2), unpack=True)
print("total revenue:", round((units * price).sum(), 2))
```

`np.savetxt` goes the other way. `fmt` controls the number format and `header` adds a first line (prefixed with `# ` unless you pass `comments=""`):

```python run
table = np.column_stack([np.arange(1, 4), np.array([0.25, 0.5, 0.75])])

out = io.StringIO()
np.savetxt(out, table, delimiter=",", fmt=["%d", "%.2f"], header="id,ratio", comments="")
print(out.getvalue())
```

```python predict id=predict-roundtrip-dtype title="Which dtypes come back?"
a = np.array([1, 2, 3], dtype=np.int16)

binary = io.BytesIO(); np.save(binary, a); binary.seek(0)
text = io.StringIO(); np.savetxt(text, a); text.seek(0)

print(np.load(binary).dtype, np.loadtxt(text).dtype)
--- options
int16 int16
int64 float64
* int16 float64
float64 float64
--- explain
`.npy` stores the dtype in its header, so `int16` survives exactly. Text has no type information, and `np.loadtxt` parses numbers as `float64` unless you pass `dtype=`. This is one more reason to prefer binary formats for NumPy-to-NumPy storage.
```

```python exercise id=parse-sales title="Analyse a sales export"
# SALES_CSV (defined in the lesson setup) has a header row and
# three columns: day, units, price.

# TODO 1: `units`: the units column as an integer array (shape (5,))
units = ...

# TODO 2: `best_day`: the day number (from the day column) with the
#         highest revenue (units * price), as a Python int
best_day = ...
--- solution
data = np.loadtxt(io.StringIO(SALES_CSV), delimiter=",", skiprows=1)
day, units, price = data.T
units = units.astype(int)
revenue = units * price
best_day = int(day[np.argmax(revenue)])
--- test
assert units is not ..., "Replace the `...` after `units =` with your code."
assert best_day is not ..., "Replace the `...` after `best_day =` with your code."
units = np.asarray(units)
assert units.shape == (5,), f"`units` should be one column with 5 values, but has shape {units.shape}. Did you skip the header and select column 1?"
assert np.issubdtype(units.dtype, np.integer), f"`units` should be integers, but has dtype {units.dtype}. Use dtype=int or .astype(int)."
assert units.tolist() == [12, 7, 15, 9, 20], f"`units` should be [12, 7, 15, 9, 20], got {units.tolist()}."
assert isinstance(best_day, (int, np.integer)), f"`best_day` should be an integer day number, got {type(best_day).__name__} {best_day!r}."
assert int(best_day) == 5, f"Revenue is units × price; the best day is not {best_day}. Use np.argmax on the revenue and look up that row''s day."
--- hint
`np.loadtxt(io.StringIO(SALES_CSV), delimiter=",", skiprows=1)` gives a (5, 3) float array. Its columns are day, units and price.
--- hint
`np.argmax(revenue)` returns the *row index* of the maximum. Use it to index the day column, then wrap the result in `int(...)`.
```

## Messy text: `np.genfromtxt`

`loadtxt` is strict: an empty field is an error. Real exports have gaps. `np.genfromtxt` handles missing values, filling them with `nan` by default (or with `filling_values=` of your choice):

```python run error
np.loadtxt(io.StringIO(SENSOR_CSV), delimiter=",", skiprows=2)
```

```python run
log = np.genfromtxt(io.StringIO(SENSOR_CSV), delimiter=",", skip_header=2)
print(log)
print("mean temp:", np.nanmean(log[:, 1]).round(2), " mean humidity:", np.nanmean(log[:, 2]).round(2))
```

With `names=True`, `genfromtxt` reads the header row and returns a **structured array** whose columns you access by name:

```python run
log = np.genfromtxt(io.StringIO(SENSOR_CSV), delimiter=",", names=True, skip_header=1)
print("fields:", log.dtype.names)
print("temp column:", log["temp"])
```

(The `# station log…` line is skipped by `skip_header=1`, and the next line becomes the field names.)

## Structured arrays: records with named fields

A regular array holds one dtype. A **structured dtype** describes a *record*: a fixed set of named fields, each with its own type. It''s NumPy''s answer to a table row or a C struct.

```python run
player_t = np.dtype([("name", "U12"), ("age", "i4"), ("score", "f8")])

players = np.array([
    ("Ada", 36, 91.5),
    ("Grace", 29, 88.0),
    ("Linus", 41, 79.25),
    ("Margaret", 33, 95.0),
], dtype=player_t)

print(players.dtype)
print("one record:", players[0])
print("one field: ", players["score"])
print("bytes per record:", players.itemsize)
```

`"U12"` is a Unicode string of up to 12 characters, `"i4"` a 4-byte integer and `"f8"` an 8-byte float. Fields behave like ordinary arrays, so boolean masks, aggregations and sorting all work:

```python run
seniors = players[players["age"] > 30]
print("over 30:", seniors["name"])
print("their mean score:", seniors["score"].mean())

ranked = np.sort(players, order="score")[::-1]     # highest score first
print("leaderboard:", ranked["name"])
```

`np.sort(..., order="field")` sorts whole records by one (or several) fields. `np.argsort(players["score"])` gives the same ordering as indices.

> **In the wild:** structured arrays are how NumPy reads binary file formats with fixed-size records, and how `pandas.DataFrame.to_records()` hands data back to NumPy. They''re compact and fast, but limited: no easy column insertion, no grouping, and awkward missing values.

```python exercise id=build-records title="Build and query a structured array"
orders = [
    ("A-100", 3, 19.99),
    ("A-101", 1, 249.00),
    ("A-102", 12, 4.50),
    ("A-103", 2, 89.90),
]

# TODO 1: `order_t`: a structured dtype with fields
#         "id" (string, up to 8 chars), "qty" (int32), "price" (float64)
order_t = ...

# TODO 2: `table`: a structured array of `orders` using `order_t`
table = ...

# TODO 3: `big_ids`: the ids of orders whose total (qty * price) exceeds 100,
#         as a NumPy array of strings, in their original order
big_ids = ...
--- solution
orders = [
    ("A-100", 3, 19.99),
    ("A-101", 1, 249.00),
    ("A-102", 12, 4.50),
    ("A-103", 2, 89.90),
]

order_t = np.dtype([("id", "U8"), ("qty", "i4"), ("price", "f8")])
table = np.array(orders, dtype=order_t)
big_ids = table["id"][table["qty"] * table["price"] > 100]
--- test
assert order_t is not ... and table is not ... and big_ids is not ..., "Replace every `...` with your code."
order_t = np.dtype(order_t)
assert order_t.names == ("id", "qty", "price"), f"The dtype should have fields (''id'', ''qty'', ''price'') in that order, but has {order_t.names}."
assert order_t["qty"] == np.dtype("int32"), f"''qty'' should be int32 (''i4''), but is {order_t[''qty'']}."
assert order_t["price"] == np.dtype("float64"), f"''price'' should be float64 (''f8''), but is {order_t[''price'']}."
assert order_t["id"].kind == "U" and order_t["id"].itemsize // 4 >= 5, f"''id'' should be a Unicode string field like ''U8'', but is {order_t[''id'']}."
assert isinstance(table, np.ndarray) and table.dtype == order_t and table.shape == (4,), f"`table` should be a structured array of 4 records with dtype order_t, got shape {getattr(table, ''shape'', None)}."
assert table["id"].tolist() == ["A-100", "A-101", "A-102", "A-103"], "The ids in `table` were truncated or are wrong. Is the string field long enough?"
assert list(np.asarray(big_ids)) == ["A-101", "A-103"], f"Orders over 100 are A-101 (249.00) and A-103 (179.80); got {list(np.asarray(big_ids))}. Note A-102 is 12 × 4.50 = 54."
--- hint
A structured dtype is a list of `(name, type)` pairs: `np.dtype([("id", "U8"), ...])`.
--- hint
Compute totals from two fields, `table["qty"] * table["price"]`, then use that boolean mask to index `table["id"]`.
```

```python debug id=leaderboard-order title="The leaderboard is alphabetical"
scores = np.array([
    ("zoe", 88.5), ("adam", 92.0), ("mia", 79.0), ("liam", 95.5),
], dtype=[("player", "U10"), ("points", "f8")])

# Top 3 players by points, best first
leaderboard = np.sort(scores)[:3]
top3 = leaderboard["player"]
print("Top 3:", top3)
--- solution
scores = np.array([
    ("zoe", 88.5), ("adam", 92.0), ("mia", 79.0), ("liam", 95.5),
], dtype=[("player", "U10"), ("points", "f8")])

# Top 3 players by points, best first
leaderboard = np.sort(scores, order="points")[::-1][:3]
top3 = leaderboard["player"]
print("Top 3:", top3)
--- test
assert list(top3) == ["liam", "adam", "zoe"], f"The top 3 by points should be [''liam'', ''adam'', ''zoe''], but you got {list(top3)}."
assert "liam" in _stdout, "Keep the print so you can see the leaderboard."
--- hint
Run it. Which field is `np.sort` sorting by when you don''t tell it?
--- hint
Without `order=`, structured arrays sort by the *first* field (the name). Pass `order="points"`, then reverse with `[::-1]` so the highest score comes first, then take 3.
```

## When to reach for pandas

NumPy''s I/O is perfect for **numeric arrays**: model weights, images, simulation outputs, matrices. For **tabular data** with mixed types, string columns, dates, many missing values or grouping, switch to pandas: `pd.read_csv` is far more forgiving and featureful than `genfromtxt`, and a DataFrame is a far better structured array.

| Job | Best tool |
|---|---|
| Save/load arrays for later NumPy use | `np.save` / `np.load` (`.npy`) |
| Several arrays, e.g. a checkpoint | `np.savez` / `np.savez_compressed` |
| Simple numeric CSV | `np.loadtxt` / `np.savetxt` |
| CSV with gaps, few columns | `np.genfromtxt` |
| Real-world tables (types, dates, joins, groupby) | `pandas.read_csv` → DataFrame |
| Huge arrays that don''t fit in memory | `np.load(..., mmap_mode="r")`, or formats like HDF5 / Zarr |

> **Under the hood:** `np.load(path, mmap_mode="r")` memory-maps a `.npy` file. The OS loads only the slices you actually touch, so you can index into a 50 GB array on a laptop.

## Recap

- `np.save`/`np.load` use the `.npy` format, which is exact, fast and dtype-preserving. `np.savez` bundles named arrays.
- With in-memory buffers, remember `seek(0)` before reading back.
- `np.loadtxt`/`np.savetxt` handle clean numeric text (`delimiter`, `skiprows`, `usecols`, `unpack`, `fmt`).
- `np.genfromtxt` tolerates missing fields (→ `nan`) and can read headers with `names=True`.
- Structured dtypes give named, mixed-type fields. Use `np.sort(..., order="field")` and boolean masks on fields.
- Use pandas for heavy tabular work and memory mapping for arrays bigger than RAM.

**Up next:** what an array really is in memory (strides, contiguity and layout) and how that knowledge makes your code faster.
', 0, '[]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_7_4', 'sec_numpy_7', 'crs_numpy_mastery', 'Memory layout, strides and performance', 'interactive', 3, 1080, NULL, NULL, 'Why is `a.T` instant on a gigabyte array, while `a.T.copy()` takes a second? Why does `ravel()` sometimes return a view and sometimes a copy? Why can a "rolling window" over a million points cost zero extra memory? It all comes down to one idea: **an array is a flat block of bytes plus a little metadata saying how to walk it.**

This lesson opens the hood. You''ll learn to read `strides` and `flags`, understand C and Fortran order, build zero-copy windows with `sliding_window_view`, cut memory with in-place operations and smaller dtypes, and measure speed properly. This is the knowledge that turns "it works" into "it works on the real dataset".

> **A note on numbers:** this lesson uses explicit `dtype=np.int64` / `np.float64` so that every byte count is the same on every machine. (In this browser runtime the *default* integer is 32-bit, which would halve some numbers.)

## An array is a buffer plus metadata

Every ndarray has a contiguous **data buffer** and a few attributes that interpret it:

- `dtype`: how to read each element (here 8-byte integers),
- `shape`: the logical dimensions,
- `strides`: **how many bytes to jump** to move one step along each axis.

```python run
a = np.arange(12, dtype=np.int64).reshape(3, 4)
print(a)
print("shape:   ", a.shape)
print("itemsize:", a.itemsize, "bytes")
print("nbytes:  ", a.nbytes, "bytes")
print("strides: ", a.strides)
```

`strides == (32, 8)` means: to move down one **row**, skip 32 bytes (4 elements × 8 bytes); to move right one **column**, skip 8 bytes. The byte offset of element `a[i, j]` is therefore:

$$\text{offset}(i, j) = i \cdot \text{strides}[0] + j \cdot \text{strides}[1]$$

```python run
i, j = 2, 1
offset = i * a.strides[0] + j * a.strides[1]
flat = a.ravel()                         # the buffer, viewed as 1-D
print("offset:", offset, "bytes = element", offset // a.itemsize, "of the buffer")
print("a[2, 1] =", a[i, j], "   buffer element:", flat[offset // a.itemsize])
```

> **Under the hood:** NumPy indexing is never a search. It''s one multiply-add per axis on the strides, which is why `a[i, j]` costs the same on a 10-element array and a 10-billion-element one.

```python exercise id=byte-offset title="Compute a byte offset from strides"
def byte_offset(arr, index):
    """Return the byte offset of arr[index] from the start of arr''s data.

    `index` is a tuple with one non-negative integer per axis.
    Use only arr.strides; don''t touch the data.
    """
    # TODO
    ...

result = byte_offset(np.zeros((4, 5, 6), dtype=np.float64), (1, 2, 3))
--- solution
def byte_offset(arr, index):
    """Return the byte offset of arr[index] from the start of arr''s data."""
    return sum(i * s for i, s in zip(index, arr.strides))

result = byte_offset(np.zeros((4, 5, 6), dtype=np.float64), (1, 2, 3))
--- test
_z = np.zeros((4, 5, 6), dtype=np.float64)
_r = byte_offset(_z, (1, 2, 3))
assert _r is not None, "`byte_offset` returned None. Did you forget `return`?"
assert _r == 1 * 240 + 2 * 48 + 3 * 8, f"For a (4, 5, 6) float64 array, strides are {_z.strides}, so index (1, 2, 3) is at {1*240 + 2*48 + 3*8} bytes; you returned {_r}."
assert byte_offset(_z, (0, 0, 0)) == 0, "Index (0, 0, 0) should be at offset 0."
_t = np.arange(20, dtype=np.int64).reshape(4, 5).T
assert byte_offset(_t, (3, 1)) == 3 * 8 + 1 * 40, f"Your function fails on a transposed array (strides {_t.strides}). Use arr.strides rather than assuming row-major order."
_s = np.arange(100, dtype=np.int32)[::3]
assert byte_offset(_s, (4,)) == 4 * 12, f"Your function fails on a strided slice (strides {_s.strides}). Don''t compute strides from the shape yourself."
--- hint
Each axis contributes `index_along_that_axis * stride_of_that_axis`. Add them up.
--- hint
`zip(index, arr.strides)` pairs each index with its stride; `sum(i * s for i, s in ...)` finishes the job.
```

## Transpose is free: it just swaps strides

Transposing doesn''t move a single byte. It returns a **view** with the shape and strides reversed:

```python run
a = np.arange(12, dtype=np.int64).reshape(3, 4)
t = a.T
print("a strides:", a.strides, "  t strides:", t.strides)
print("same memory?", np.shares_memory(a, t))
print("a C-contiguous:", a.flags["C_CONTIGUOUS"], " F-contiguous:", a.flags["F_CONTIGUOUS"])
print("t C-contiguous:", t.flags["C_CONTIGUOUS"], " F-contiguous:", t.flags["F_CONTIGUOUS"])
```

The same buffer can be read in two natural orders:

| Order | Last index changes fastest? | Typical source |
|---|---|---|
| **C** (row-major) | yes, rows are contiguous | NumPy''s default, C, PyTorch |
| **F** (column-major) | no, columns are contiguous | Fortran, MATLAB, R, LAPACK |

`a.T` of a C-ordered array is exactly an F-ordered array. `np.asfortranarray(a)` and `np.ascontiguousarray(a)` convert between them, copying only if needed.

```python predict id=predict-transpose-strides title="What are the strides?"
grid = np.zeros((4, 5), dtype=np.float64)
print(grid.T.strides)
--- options
(40, 8)
* (8, 40)
(8, 32)
(32, 8)
--- explain
`grid` is C-ordered with strides `(5 × 8, 8) = (40, 8)`. Transposing just reverses the strides, giving `(8, 40)`. No data moves.
```

## When views become copies

Slicing with a step, transposing and many reshapes produce views with unusual strides. They''re still views, but they''re **not contiguous**. Operations that need a flat, contiguous buffer then have to copy:

```python run
a = np.arange(12, dtype=np.int64).reshape(3, 4)

every_other = a[:, ::2]
print("a[:, ::2] strides:", every_other.strides, " contiguous:", every_other.flags["C_CONTIGUOUS"])

print("a.ravel() shares memory:  ", np.shares_memory(a, a.ravel()))     # contiguous → view
print("a.T.ravel() shares memory:", np.shares_memory(a, a.T.ravel()))   # C-order walk of F data → copy

c = np.ascontiguousarray(every_other)
print("after ascontiguousarray:", c.strides, c.flags["C_CONTIGUOUS"])
```

`ravel()` returns a view when it can and silently copies when it can''t. That''s convenient, but dangerous if you write to the result and expect the original to change.

> **In the wild:** libraries that call C code (BLAS, image codecs, some PyTorch ops) often require contiguous input and quietly call `ascontiguousarray` for you. If you see unexplained memory spikes, a hidden copy of a transposed or strided array is a prime suspect. PyTorch even has a method for it: `tensor.contiguous()`.

```python debug id=ravel-clamp title="The clamp didn''t stick"
# Clamp every value above 5 down to 0, in place.
data = np.arange(12, dtype=np.float64).reshape(3, 4)
grid = data.T                     # (4, 3) view of the same data

flat = grid.ravel()
flat[flat > 5] = 0

print("max after clamp:", grid.max())   # should be 5.0
--- solution
# Clamp every value above 5 down to 0, in place.
data = np.arange(12, dtype=np.float64).reshape(3, 4)
grid = data.T                     # (4, 3) view of the same data

grid[grid > 5] = 0

print("max after clamp:", grid.max())   # should be 5.0
--- test
assert grid.max() == 5.0, f"`grid` still contains values above 5 (max is {grid.max()}). The writes didn''t reach `grid`."
assert data.max() == 5.0, "`data` should be clamped too, since `grid` is a view of it."
assert (grid == 0).sum() == 7, f"Exactly 7 values (6 through 11) should become 0, plus the original 0, so 7 zeros in total. Got {(grid == 0).sum()}."
assert np.shares_memory(grid, data), "Keep `grid` as a view of `data`, and modify it in place."
--- hint
Debug it and compare `flat` with `grid` after the assignment. Does `np.shares_memory(grid, flat)` hold?
--- hint
`grid` is a transposed (F-ordered) view, so `ravel()` had to make a **copy**, and you modified the copy. Apply the boolean mask to `grid` directly.
```

## Zero-copy windows with `sliding_window_view`

Because strides are just numbers, you can create views that *revisit* the same bytes. `np.lib.stride_tricks.sliding_window_view` builds every window of a series as a 2-D view, with **no copying at all**:

```python run
from numpy.lib.stride_tricks import sliding_window_view

prices = np.array([10.0, 11.0, 12.5, 12.0, 13.5, 14.0, 13.0, 15.5])
windows = sliding_window_view(prices, 3)

print("windows shape:", windows.shape, " strides:", windows.strides)
print(windows)
print("3-day rolling mean:", windows.mean(axis=1).round(2))
print("shares memory with prices:", np.shares_memory(windows, prices))
```

Both strides are 8 bytes: one step to the next window *and* one step within a window move by a single element. Six windows of three, built from eight numbers, and not a byte copied.

```python predict id=predict-window-shape title="Shape of the windows"
x = np.arange(10, dtype=np.int64)
w = np.lib.stride_tricks.sliding_window_view(x, 4)
print(w.shape, w.strides)
--- options
(10, 4) (8, 8)
* (7, 4) (8, 8)
(7, 4) (32, 8)
(6, 4) (8, 8)
--- explain
A window of 4 fits `10 - 4 + 1 = 7` times. Consecutive windows start one element (8 bytes) apart, and elements within a window are also 8 bytes apart, so the strides are `(8, 8)`.
```

It works in 2-D too: `sliding_window_view(img, (3, 3))` gives shape `(H-2, W-2, 3, 3)`, every 3×3 patch of an image. A blur is then `patches.mean(axis=(2, 3))`.

> **Pitfall:** windows overlap in memory, so **never write** to a sliding-window view; one write changes several windows at once. NumPy marks these views read-only to protect you.

```python exercise id=rolling-stats title="Rolling mean and max"
from numpy.lib.stride_tricks import sliding_window_view

def rolling(x, w):
    """Return (means, maxes) over every window of length w in the 1-D array x.

    Both results have length len(x) - w + 1. Use sliding_window_view (no Python loops).
    """
    # TODO
    ...

result = rolling(np.array([3.0, 1.0, 4.0, 1.0, 5.0, 9.0, 2.0]), 3)
--- solution
from numpy.lib.stride_tricks import sliding_window_view

def rolling(x, w):
    """Return (means, maxes) over every window of length w in the 1-D array x."""
    windows = sliding_window_view(x, w)
    return windows.mean(axis=1), windows.max(axis=1)

result = rolling(np.array([3.0, 1.0, 4.0, 1.0, 5.0, 9.0, 2.0]), 3)
--- test
_out = rolling(np.array([3.0, 1.0, 4.0, 1.0, 5.0, 9.0, 2.0]), 3)
assert _out is not None, "`rolling` returned None. It should return a pair (means, maxes)."
assert len(_out) == 2, "`rolling` should return two arrays: (means, maxes)."
_m, _x = np.asarray(_out[0]), np.asarray(_out[1])
assert _m.shape == (5,), f"With 7 values and w=3 there are 5 windows, but `means` has shape {_m.shape}. Reduce along the window axis (axis=1)."
assert np.allclose(_m, [8/3, 2.0, 10/3, 5.0, 16/3]), f"The rolling means are wrong: {_m.round(3)}."
assert np.array_equal(_x, [4.0, 4.0, 5.0, 9.0, 9.0]), f"The rolling maxes are wrong: {_x}."
_rng = np.random.default_rng(3)
_y = _rng.normal(size=50)
_m2, _x2 = rolling(_y, 7)
assert np.allclose(_m2, np.convolve(_y, np.ones(7) / 7, mode="valid")), "`rolling` gives wrong means for other inputs. Avoid hard-coding the window length."
assert np.allclose(_x2, [_y[i:i + 7].max() for i in range(44)]), "`rolling` gives wrong maxes for other inputs."
--- hint
`sliding_window_view(x, w)` has shape `(len(x) - w + 1, w)`: one row per window.
--- hint
Reduce each row: `.mean(axis=1)` and `.max(axis=1)`, then `return` both as a tuple.
```

## Fewer temporaries: in-place ops and `out=`

An expression like `a * 2 + 1` allocates a **temporary** array for `a * 2`, then *another* for the `+ 1`. On large arrays, allocating and filling that memory can cost more than the arithmetic itself. In-place operators and the `out=` argument reuse existing buffers:

```python run
import time

def best_ms(fn, repeat=5):
    """Best of several runs, in milliseconds. A single timing is noisy."""
    times = []
    for _ in range(repeat):
        t0 = time.perf_counter()
        fn()
        times.append(time.perf_counter() - t0)
    return min(times) * 1000

a = np.random.default_rng(0).normal(size=1_000_000)
buf = np.empty_like(a)

def with_temporaries():
    return a * 2.0 + 1.0

def in_place():
    np.multiply(a, 2.0, out=buf)    # write into an existing buffer
    np.add(buf, 1.0, out=buf)       # in-place add: no new array
    return buf

print(f"a * 2 + 1      : {best_ms(with_temporaries):.2f} ms")
print(f"out= / in-place: {best_ms(in_place):.2f} ms")
print("same result:", np.allclose(with_temporaries(), in_place()))
```

The exact numbers depend on your machine (and the browser), but the in-place version never allocates. That matters even more for **peak memory**: with temporaries, a 4 GB array briefly needs 12 GB.

> **Pitfall:** an in-place result must fit the array''s dtype. `ints *= 0.5` raises an error, because NumPy won''t silently write floats into an integer buffer. Convert first, or write to a new array.

```python run error
counts = np.array([10, 20, 30], dtype=np.int64)
counts *= 0.5
```

## Choosing dtypes to save memory

The simplest performance win is often a smaller dtype. Halving the bytes per element halves memory *and* the bandwidth every operation consumes:

```python run
n = 1_000_000
for dt in [np.float64, np.float32, np.int64, np.int16, np.uint8]:
    print(f"{np.dtype(dt).name:>8}: {np.zeros(n, dtype=dt).nbytes / 1e6:5.1f} MB")
```

| Data | Good dtype | Why |
|---|---|---|
| Pixel values 0–255 | `uint8` | 8× smaller than float64 |
| ML features and weights | `float32` | GPU-native, plenty of precision |
| Small categories / labels | `int8` / `int16` | if the value range fits |
| Money, long sums, statistics | `float64` | precision matters more than size |

The trade-offs are the ones you met earlier: smaller integers **overflow** sooner, and float32 keeps only about 7 significant digits.

```python exercise id=shrink-dataset title="Put a dataset on a diet"
rng = np.random.default_rng(7)
pixels = rng.integers(0, 256, size=(200, 200), dtype=np.int64)          # values 0..255
features = rng.normal(size=(5000, 32))                                    # float64

# TODO 1: `pixels_small`: the same values stored as uint8
pixels_small = ...

# TODO 2: `features_small`: the features stored as float32
features_small = ...

# TODO 3: `saved_mb`: total megabytes saved (bytes / 1e6) by both conversions
saved_mb = ...
--- solution
rng = np.random.default_rng(7)
pixels = rng.integers(0, 256, size=(200, 200), dtype=np.int64)
features = rng.normal(size=(5000, 32))

pixels_small = pixels.astype(np.uint8)
features_small = features.astype(np.float32)
saved_mb = (pixels.nbytes - pixels_small.nbytes + features.nbytes - features_small.nbytes) / 1e6
--- test
assert pixels_small is not ... and features_small is not ... and saved_mb is not ..., "Replace every `...` with your code."
assert isinstance(pixels_small, np.ndarray) and pixels_small.dtype == np.uint8, f"`pixels_small` should have dtype uint8, got {getattr(pixels_small, ''dtype'', type(pixels_small).__name__)}."
assert np.array_equal(pixels_small, pixels), "`pixels_small` should hold exactly the same values as `pixels`."
assert isinstance(features_small, np.ndarray) and features_small.dtype == np.float32, f"`features_small` should have dtype float32, got {getattr(features_small, ''dtype'', type(features_small).__name__)}."
assert features_small.shape == (5000, 32) and np.allclose(features_small, features, atol=1e-6), "`features_small` should contain the same values (to float32 precision)."
_expected = (200 * 200 * 7 + 5000 * 32 * 4) / 1e6
assert np.isclose(saved_mb, _expected), f"You should save {_expected:.2f} MB in total, but `saved_mb` is {saved_mb!r}. Compare .nbytes before and after for both arrays."
--- hint
`.astype(np.uint8)` and `.astype(np.float32)` create the smaller copies.
--- hint
Every array has `.nbytes`. Saved bytes = (old − new) for pixels plus (old − new) for features; divide by `1e6`.
```

```python debug id=scale-in-place title="The memory-saving rescale crashes"
# Convert raw sensor counts to volts IN PLACE to avoid a second big array.
# 1 count = 0.004 volts.
raw = np.array([120, 455, 1023, 87, 640], dtype=np.int64)

volts = raw
volts *= 0.004
print("volts:", volts)
--- solution
# Convert raw sensor counts to volts IN PLACE to avoid a second big array.
# 1 count = 0.004 volts.
raw = np.array([120, 455, 1023, 87, 640], dtype=np.int64)

volts = raw.astype(np.float64)
volts *= 0.004
print("volts:", volts)
--- test
assert isinstance(volts, np.ndarray) and np.issubdtype(volts.dtype, np.floating), f"`volts` should be a floating-point array, but has dtype {getattr(volts, ''dtype'', None)}."
assert np.allclose(volts, [0.48, 1.82, 4.092, 0.348, 2.56]), f"`volts` has the wrong values: {volts}."
assert raw.dtype == np.int64 and raw.tolist() == [120, 455, 1023, 87, 640], "Keep `raw` as the original integer counts."
--- hint
Run it and read the error: NumPy refuses to store float results into an integer buffer.
--- hint
An integer array can never hold 0.48. Make one float copy (`raw.astype(np.float64)`), then scale that copy in place. That''s still just one extra array.
```

## Measuring performance properly

Some rules for timing code so the numbers mean something:

1. **Use `time.perf_counter()`**, a high-resolution clock meant for intervals.
2. **Repeat and take the minimum.** Noise from other processes only ever makes runs slower, so the best run is the most honest. (In Jupyter, `%timeit` does this for you.)
3. **Time realistic sizes.** At 100 elements Python overhead dominates; at 10 million, memory bandwidth does.
4. **Check the answers match** before celebrating a speedup.

```python run
import time

def best_ms(fn, repeat=5):
    times = []
    for _ in range(repeat):
        t0 = time.perf_counter()
        fn()
        times.append(time.perf_counter() - t0)
    return min(times) * 1000

m = np.random.default_rng(1).normal(size=(1000, 1000))
mt = m.T                                       # F-ordered view

print(f"sum of C-ordered array  : {best_ms(lambda: m.sum()):.2f} ms")
print(f"sum of transposed view  : {best_ms(lambda: mt.sum()):.2f} ms")
print(f"make it contiguous (copy): {best_ms(lambda: np.ascontiguousarray(mt)):.2f} ms")
```

Summing barely cares about layout (for full reductions NumPy walks memory in whichever order is fastest), but forcing a contiguous copy of the transposed view costs real time and 8 MB of memory. The lesson: **copies are the expensive part.** Know when you''re making one.

## Recap

- An ndarray is a flat buffer plus `dtype`, `shape` and `strides`: bytes to skip per axis.
- Transpose, slicing and many reshapes only change strides, so they''re free **views**; `np.shares_memory` and `.flags` tell you what you have.
- C order makes rows contiguous and F order makes columns contiguous. `ravel()` and C code may silently copy non-contiguous data.
- `sliding_window_view` builds overlapping windows with zero copies. Read from them, never write.
- In-place operators and `out=` avoid temporaries; smaller dtypes cut memory and bandwidth.
- Time with `perf_counter`, repeat, take the best, and verify results.

**Up next:** the capstone projects, starting with k-means clustering built from scratch.
', 0, '[]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_7_5', 'sec_numpy_7', 'crs_numpy_mastery', 'Checkpoint: NumPy in the real world', 'quiz', 4, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"`values` is a float array that may contain NaN. Which expression correctly counts the missing entries?","options":["(values == np.nan).sum()","np.isnan(values).sum()","(values is np.nan).sum()","values.count(np.nan)"],"answerIndex":1,"explanation":"NaN never compares equal to anything, including itself, so `values == np.nan` is all False. `np.isnan` returns a boolean mask, and summing it counts the True values."},{"id":"q2","prompt":"Why does `np.isclose(1e-9, 2e-9)` return `True` with default arguments?","options":["Because both numbers round to zero in float64","Because the default absolute tolerance `atol=1e-08` is larger than their difference","Because `isclose` only compares the first 7 significant digits","Because `rtol` is relative to the larger number, which makes any two small numbers equal"],"answerIndex":1,"explanation":"`isclose` checks `|a - b| <= atol + rtol * |b|`. The difference is 1e-9, which is below the default `atol` of 1e-8. When working with tiny magnitudes, set `atol` explicitly (often `atol=0`)."},{"id":"q3","prompt":"An image `img` has dtype uint8. What is the safest way to brighten it by 80?","options":["img + 80","np.clip(img + 80, 0, 255)","np.clip(img.astype(np.int16) + 80, 0, 255).astype(np.uint8)","(img + 80).astype(np.uint8)"],"answerIndex":2,"explanation":"uint8 arithmetic wraps around modulo 256, so `img + 80` overflows before any clipping can happen. Widen the dtype first, compute, clip to [0, 255], then convert back to uint8."},{"id":"q4","prompt":"You saved an int16 array with `np.savetxt` and read it back with `np.loadtxt` (no `dtype=` argument). What dtype do you get?","options":["int16","int64","float64","object"],"answerIndex":2,"explanation":"Text files carry no type information, and `np.loadtxt` parses numbers as float64 by default. The binary `.npy` format (`np.save` / `np.load`) preserves the exact dtype and shape."},{"id":"q5","prompt":"`a = np.zeros((3, 4), dtype=np.float64)`. What are the strides of `a.T`?","options":["(32, 8)","(8, 32)","(8, 24)","(24, 8)"],"answerIndex":1,"explanation":"`a` is C-ordered with strides (4 × 8, 8) = (32, 8). Transposing creates a view that simply reverses the strides, giving (8, 32). No data is copied."},{"id":"q6","prompt":"Which statement about `np.lib.stride_tricks.sliding_window_view(x, 5)` is true?","options":["It copies every window into a new array, so memory grows 5×","It returns a read-only view whose overlapping windows share x''s memory","It only works on 2-D arrays","Writing to one window safely updates only that window"],"answerIndex":1,"explanation":"The windows are built purely with strides, so no data is copied and the windows overlap in memory. That''s why NumPy makes the view read-only: a single write would change several windows at once."}]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_numpy_8_1', 'sec_numpy_8', 'crs_numpy_mastery', 'Project: k-means clustering from scratch', 'interactive', 0, 1500, NULL, NULL, 'You''ve spent this course learning NumPy one tool at a time: indexing, broadcasting, reductions along an axis, boolean masks. In this project they come together. You''ll build **k-means clustering**, one of the most widely used algorithms in machine learning, from scratch in about twenty lines of NumPy.

k-means takes a cloud of unlabelled points and discovers groups in it. It powers customer segmentation, image color compression, document grouping and the "vector quantization" inside modern speech and image models. scikit-learn''s `KMeans` does exactly what you''re about to write, plus a few speed tricks.

> **How this project works:** each stage is a challenge that builds one piece of the algorithm. Challenges run in their own namespace, so each one restates the helpers it needs from earlier stages. At the end you''ll assemble everything into a complete `kmeans` function and watch it find the clusters.

```python setup
rng = np.random.default_rng(42)
true_centers = np.array([[0.0, 0.0], [5.0, 5.0], [0.0, 6.0]])
X = np.vstack([c + rng.normal(scale=0.8, size=(60, 2)) for c in true_centers])
```

## Meet the data

The lesson setup created `X`: 180 points in 2-D, secretly drawn around three centers. k-means won''t get the centers. It has to find them.

```python run
import matplotlib.pyplot as plt

print("X shape:", X.shape)
print("first 3 points:\n", X[:3].round(2))

plt.scatter(X[:, 0], X[:, 1], s=14, color="0.35")
plt.title("180 unlabelled points")
plt.axis("equal")
plt.show()
```

To your eye there are obviously three groups. The goal is to make the computer see them too.

## The algorithm in one sentence

Pick $k$ centroids, then repeat two steps until nothing changes: **assign** every point to its nearest centroid, then **move** every centroid to the mean of its points.

Each round lowers the *inertia*, the total squared distance from points to their centroids:

$$
J = \sum_{i=1}^{n} \lVert x_i - \mu_{c_i} \rVert^2
$$

Here $x_i$ is a point, $c_i$ is the cluster it''s assigned to, and $\mu_{c_i}$ is that cluster''s centroid. The assign step picks the best $c_i$ for fixed centroids; the move step picks the best $\mu$ for fixed assignments. Neither step can increase $J$, so the algorithm always converges.

## Stage 1: choose starting centroids

The simplest good initialization is to pick $k$ **distinct** data points at random. `rng.choice` can sample indices without replacement:

```python run
demo_rng = np.random.default_rng(0)
idx = demo_rng.choice(10, size=4, replace=False)
print("4 distinct indices out of 10:", idx)
print("as rows of X:\n", X[idx].round(2))
```

```python exercise id=init-centroids title="Pick k random starting centroids"
def init_centroids(X, k, seed=0):
    """Return k distinct rows of X, chosen at random, as a (k, d) array."""
    rng = np.random.default_rng(seed)
    # TODO: pick k distinct row indices with rng.choice, then index X with them
    idx = ...
    return ...

centroids = init_centroids(X, 3, seed=0)
print(centroids)
--- solution
def init_centroids(X, k, seed=0):
    """Return k distinct rows of X, chosen at random, as a (k, d) array."""
    rng = np.random.default_rng(seed)
    idx = rng.choice(len(X), size=k, replace=False)
    return X[idx]

centroids = init_centroids(X, 3, seed=0)
print(centroids)
--- test
C = init_centroids(X, 3, seed=0)
assert C is not ..., "init_centroids returns `...`. Replace the placeholders with your code."
assert isinstance(C, np.ndarray), f"init_centroids should return a NumPy array, not {type(C).__name__}."
assert C.shape == (3, 2), f"With k=3 on 2-D data the result should have shape (3, 2), but it has {C.shape}."
fresh = np.arange(40.0).reshape(20, 2)
C5 = init_centroids(fresh, 5, seed=1)
assert C5.shape == (5, 2), f"init_centroids(fresh, 5) should have shape (5, 2), got {C5.shape}. Are you using `k`?"
rows = {tuple(r) for r in fresh}
assert all(tuple(r) in rows for r in C5), "Every centroid should be an actual row of X."
assert len({tuple(r) for r in C5}) == 5, "The k starting centroids must be distinct rows. Sample without replacement."
assert np.array_equal(init_centroids(fresh, 5, seed=1), C5), "The same seed should always give the same centroids. Build the generator from `seed`."
assert not np.array_equal(init_centroids(fresh, 5, seed=2), C5), "Different seeds should usually give different centroids. Are you ignoring `seed`?"
--- hint
You need `k` distinct integers between `0` and `len(X) - 1`. Then use them as a fancy index into `X`.
--- hint
`rng.choice(n, size=k, replace=False)` returns `k` distinct indices from `range(n)`, and `X[idx]` picks those rows.
```

## Stage 2: every distance at once

The assign step needs the distance from **every point to every centroid**: an `(n, k)` table. A double loop would work, but it''s slow and un-NumPy-like. Broadcasting does it in one expression:

- `X[:, None, :]` has shape `(n, 1, d)`: each point on its own "row".
- `C[None, :, :]` has shape `(1, k, d)`: all centroids along a new middle axis.
- Their difference broadcasts to `(n, k, d)`: every point minus every centroid.

Square, then sum over the last axis `d` to get squared Euclidean distances. Here it is on a tiny example you can check by hand:

```python run
P = np.array([[0.0, 0.0], [3.0, 4.0]])      # 2 points
Q = np.array([[0.0, 0.0], [3.0, 0.0], [0.0, 4.0]])  # 3 centroids

diff = P[:, None, :] - Q[None, :, :]
print("diff shape:", diff.shape)
(diff ** 2).sum(axis=2)
```

Row 1 says the point `(3, 4)` is at squared distance 25 from the origin, 16 from `(3, 0)` and 9 from `(0, 4)`. That''s exactly $3^2+4^2$, $4^2$ and $3^2$.

```python predict id=predict-diff-shape title="What shape is the broadcast difference?"
X = np.zeros((180, 2))
C = np.zeros((3, 2))
diff = X[:, None, :] - C[None, :, :]
print(diff.shape)
--- options
(180, 2)
* (180, 3, 2)
(3, 180, 2)
(180, 3)
--- explain
`(180, 1, 2)` and `(1, 3, 2)` broadcast axis by axis: `180` vs `1` gives `180`, `1` vs `3` gives `3`, and `2` vs `2` gives `2`. The squared distances only become `(180, 3)` after you **sum over the last axis**.
```

```python exercise id=squared-distances title="Compute all point-to-centroid distances"
def squared_distances(X, C):
    """Return an (n, k) array: the squared distance from each point to each centroid."""
    # TODO: broadcast X to (n, 1, d) and C to (1, k, d), subtract, square, sum over d
    diff = ...
    return ...

D = squared_distances(X, X[:3])
print(D)
--- solution
def squared_distances(X, C):
    """Return an (n, k) array: the squared distance from each point to each centroid."""
    diff = X[:, None, :] - C[None, :, :]
    return (diff ** 2).sum(axis=2)

D = squared_distances(X, X[:3])
print(D)
--- test
rng_t = np.random.default_rng(7)
P = rng_t.normal(size=(9, 3))
Q = rng_t.normal(size=(4, 3))
D = squared_distances(P, Q)
assert D is not ..., "squared_distances returns `...`. Replace the placeholders with your code."
assert isinstance(D, np.ndarray), f"squared_distances should return a NumPy array, not {type(D).__name__}."
assert D.shape == (9, 4), f"For 9 points and 4 centroids the result should be (9, 4), not {D.shape}. Which axis are you summing over?"
expected = np.array([[((p - q) ** 2).sum() for q in Q] for p in P])
assert np.allclose(D, expected), "The shape is right but some distances are wrong. Square the differences before summing, and sum over the last axis."
self_d = squared_distances(X, X[:3])
assert np.allclose(self_d[[0, 1, 2], [0, 1, 2]], 0), "A point''s distance to itself should be 0."
--- hint
Insert new axes with `None`: `X[:, None, :]` and `C[None, :, :]`. Subtracting them broadcasts to `(n, k, d)`.
--- hint
After subtracting, square with `** 2` and reduce the coordinate axis with `.sum(axis=2)` (or `axis=-1`).
```

## Stage 3: assign each point to its nearest centroid

With the `(n, k)` distance table, the nearest centroid for each point is the **column** with the smallest value in that point''s **row**. That''s `argmin` along `axis=1`:

```python run
D = np.array([[4.0, 1.0, 9.0],
              [0.5, 5.0, 2.0],
              [7.0, 6.0, 3.0]])
print("nearest centroid per point:", D.argmin(axis=1))
print("smallest distance per point:", D.min(axis=1))
```

```python predict id=predict-argmin title="Which labels come out?"
D = np.array([[4, 1, 9],
              [0, 5, 2]])
print(D.argmin(axis=0))
--- options
[1 0]
* [1 0 1]
[0 1 0]
[1 0 2]
--- explain
`axis=0` reduces **down the rows**, so you get one answer per **column**: the row index of each column''s minimum. That''s the wrong question for k-means, where you want one label per point (row), so you''d use `axis=1`.
```

```python exercise id=assign-labels title="Assign points to their nearest centroid"
def squared_distances(X, C):  # from Stage 2
    return ((X[:, None, :] - C[None, :, :]) ** 2).sum(axis=2)

def assign(X, C):
    """Return an (n,) integer array: the index of the nearest centroid for each point."""
    D = squared_distances(X, C)
    # TODO: for every row of D, find the column with the smallest distance
    return ...

labels = assign(X, X[:3])
print(labels)
--- solution
def squared_distances(X, C):  # from Stage 2
    return ((X[:, None, :] - C[None, :, :]) ** 2).sum(axis=2)

def assign(X, C):
    """Return an (n,) integer array: the index of the nearest centroid for each point."""
    D = squared_distances(X, C)
    return D.argmin(axis=1)

labels = assign(X, X[:3])
print(labels)
--- test
C = np.array([[0.0, 0.0], [10.0, 10.0]])
P = np.array([[1.0, 1.0], [9.0, 8.0], [-2.0, 0.5], [6.0, 6.0]])
labels = assign(P, C)
assert labels is not ..., "assign returns `...`. Replace the placeholder with your code."
labels = np.asarray(labels)
assert labels.shape == (4,), f"assign should return one label per point, shape (4,), not {labels.shape}. Which axis did you reduce?"
assert np.issubdtype(labels.dtype, np.integer), f"Labels should be integer centroid indices, not {labels.dtype}. Did you use min instead of argmin?"
assert labels.tolist() == [0, 1, 0, 1], f"Expected labels [0, 1, 0, 1] for the test points but got {labels.tolist()}."
C3 = np.array([[0.0, 0.0], [5.0, 5.0], [0.0, 6.0]])
assert np.array_equal(assign(X, C3), squared_distances(X, C3).argmin(axis=1)), "assign gives different labels than the nearest centroid on the lesson data."
--- hint
You want the *position* of the minimum, not the minimum value itself.
--- hint
`D.argmin(axis=1)` returns, for each row, the column index of its smallest entry.
```

## Stage 4: move the centroids

Each centroid moves to the **mean of the points assigned to it**. A boolean mask selects one cluster''s points, and `.mean(axis=0)` averages them coordinate by coordinate:

```python run
labels = np.array([0, 1, 0, 1, 1])
pts = np.array([[0.0, 0.0], [10.0, 0.0], [2.0, 2.0], [12.0, 2.0], [11.0, 4.0]])

cluster_1 = pts[labels == 1]
print("points in cluster 1:\n", cluster_1)
print("their centroid:", cluster_1.mean(axis=0))
```

```python debug id=centroid-mean-bug title="The centroids collapse onto the diagonal"
X_small = np.array([[0.0, 0.0], [2.0, 0.0], [10.0, 4.0], [12.0, 6.0]])
labels = np.array([0, 0, 1, 1])
k = 2

centroids = np.zeros((k, 2))
for j in range(k):
    centroids[j] = X_small[labels == j].mean()

print(centroids)
--- solution
X_small = np.array([[0.0, 0.0], [2.0, 0.0], [10.0, 4.0], [12.0, 6.0]])
labels = np.array([0, 0, 1, 1])
k = 2

centroids = np.zeros((k, 2))
for j in range(k):
    centroids[j] = X_small[labels == j].mean(axis=0)

print(centroids)
--- test
assert centroids.shape == (2, 2), f"centroids should still have shape (2, 2), got {centroids.shape}."
assert not np.allclose(centroids[:, 0], centroids[:, 1]), "Both coordinates of each centroid are still identical. Each coordinate needs its own mean."
assert np.allclose(centroids, [[1.0, 0.0], [11.0, 5.0]]), f"Each centroid should be the coordinate-wise mean of its points. Got {centroids.tolist()}."
--- hint
Run it and look at the output: both numbers in each row are the same. What is `.mean()` averaging over when you don''t tell it an axis?
--- hint
Without an `axis`, `.mean()` flattens the array and returns a single number, which then broadcasts into both coordinates. Average each column separately instead.
```

Real data has one more wrinkle: a centroid can end up with **no points at all**, especially with a bad initialization. The mean of an empty array is `nan` (with a warning), and a `nan` centroid poisons every later step. The standard fix is to leave an empty cluster''s centroid where it was.

```python exercise id=update-centroids title="Update centroids, safely"
def update_centroids(X, labels, old_centroids):
    """Return a (k, d) array whose row j is the mean of the points labelled j.

    If cluster j has no points, keep old_centroids[j] instead.
    """
    k = len(old_centroids)
    new = old_centroids.copy()
    # TODO: for each cluster j, select its points with a mask and, if any, store their mean in new[j]
    ...
    return new
--- solution
def update_centroids(X, labels, old_centroids):
    """Return a (k, d) array whose row j is the mean of the points labelled j.

    If cluster j has no points, keep old_centroids[j] instead.
    """
    k = len(old_centroids)
    new = old_centroids.copy()
    for j in range(k):
        members = X[labels == j]
        if len(members) > 0:
            new[j] = members.mean(axis=0)
    return new
--- test
P = np.array([[0.0, 0.0], [2.0, 2.0], [10.0, 0.0], [12.0, 2.0]])
old = np.array([[1.0, 1.0], [5.0, 5.0], [100.0, 100.0]])
lab = np.array([0, 0, 1, 1])
new = update_centroids(P, lab, old)
assert isinstance(new, np.ndarray), f"update_centroids should return a NumPy array, not {type(new).__name__}."
assert new.shape == (3, 2), f"The result should have one row per centroid, shape (3, 2), got {new.shape}."
assert not np.isnan(new).any(), "The result contains NaN. That happens when you average an empty cluster; skip clusters with no points."
assert np.allclose(new[1], [11.0, 1.0]), f"Row 1 should be the mean of the points labelled 1, but it is {new[1].tolist()}."
assert np.allclose(new[0], [1.0, 1.0]), f"Row 0 should be the mean of the points labelled 0, but it is {new[0].tolist()}."
assert np.allclose(new[2], [100.0, 100.0]), "Cluster 2 has no points, so it should keep its old centroid."
assert np.allclose(old, [[1.0, 1.0], [5.0, 5.0], [100.0, 100.0]]), "old_centroids was modified. Write into the copy, `new`, instead."
--- hint
Loop `for j in range(k):` and build a mask with `labels == j` to select that cluster''s points.
--- hint
`members = X[labels == j]`. Only when `len(members) > 0`, set `new[j] = members.mean(axis=0)`.
```

## Stage 5: put it all together

Now assemble the full algorithm. The helpers from Stages 2 and 4 are provided; you write the loop.

**Stopping rule:** if the new centroids are (almost) identical to the old ones, assignments can''t change any more, so stop early. `np.allclose(new_centroids, centroids)` is the right test; never compare floats with `==`.

```python exercise id=kmeans-full title="Write the complete k-means algorithm"
def squared_distances(X, C):  # Stage 2
    return ((X[:, None, :] - C[None, :, :]) ** 2).sum(axis=2)

def update_centroids(X, labels, old_centroids):  # Stage 4
    new = old_centroids.copy()
    for j in range(len(old_centroids)):
        members = X[labels == j]
        if len(members) > 0:
            new[j] = members.mean(axis=0)
    return new

def kmeans(X, k, seed=0, max_iter=100):
    """Cluster X into k groups. Return (centroids, labels, inertia)."""
    rng = np.random.default_rng(seed)
    centroids = X[rng.choice(len(X), size=k, replace=False)]
    for _ in range(max_iter):
        # TODO 1: assign every point to its nearest centroid
        labels = ...
        # TODO 2: move each centroid to the mean of its points
        new_centroids = ...
        # TODO 3: stop (break) when the centroids no longer move
        ...
        centroids = new_centroids
    # TODO 4: inertia = sum of squared distances from each point to its own centroid
    inertia = ...
    return centroids, labels, inertia

C, labels, inertia = kmeans(X, 3)
print("centroids:\n", C)
print("inertia:", inertia)
--- solution
def squared_distances(X, C):  # Stage 2
    return ((X[:, None, :] - C[None, :, :]) ** 2).sum(axis=2)

def update_centroids(X, labels, old_centroids):  # Stage 4
    new = old_centroids.copy()
    for j in range(len(old_centroids)):
        members = X[labels == j]
        if len(members) > 0:
            new[j] = members.mean(axis=0)
    return new

def kmeans(X, k, seed=0, max_iter=100):
    """Cluster X into k groups. Return (centroids, labels, inertia)."""
    rng = np.random.default_rng(seed)
    centroids = X[rng.choice(len(X), size=k, replace=False)]
    for _ in range(max_iter):
        labels = squared_distances(X, centroids).argmin(axis=1)
        new_centroids = update_centroids(X, labels, centroids)
        if np.allclose(new_centroids, centroids):
            break
        centroids = new_centroids
    inertia = squared_distances(X, centroids).min(axis=1).sum()
    return centroids, labels, inertia

C, labels, inertia = kmeans(X, 3)
print("centroids:\n", C)
print("inertia:", inertia)
--- test
rng_t = np.random.default_rng(123)
centers = np.array([[0.0, 0.0], [8.0, 0.0], [4.0, 7.0], [-6.0, 6.0]])
P = np.vstack([c + rng_t.normal(scale=0.6, size=(40, 2)) for c in centers])
out = kmeans(P, 4, seed=3)
assert isinstance(out, tuple) and len(out) == 3, "kmeans should return a tuple: (centroids, labels, inertia)."
C, lab, inertia = out
assert C is not ... and lab is not ... and inertia is not ..., "kmeans still returns a `...` placeholder. Fill in every TODO."
C = np.asarray(C)
lab = np.asarray(lab)
assert C.shape == (4, 2), f"With k=4 the centroids should have shape (4, 2), got {C.shape}."
assert lab.shape == (160,), f"labels should hold one entry per point, shape (160,), got {lab.shape}."
D = ((P[:, None, :] - C[None, :, :]) ** 2).sum(axis=2)
assert np.array_equal(lab, D.argmin(axis=1)), "At convergence every label should point to its nearest centroid. Are the labels from the final assignment step?"
for j in range(4):
    if np.any(lab == j):
        assert np.allclose(C[j], P[lab == j].mean(axis=0), atol=1e-6), "At convergence each centroid should equal the mean of its points. Did the loop stop before converging?"
assert np.ndim(inertia) == 0, "inertia should be a single number."
assert np.isclose(float(inertia), D.min(axis=1).sum()), "inertia should be the sum of squared distances from each point to its assigned centroid."
C2, _, _ = kmeans(P, 4, seed=3)
assert np.allclose(C, C2), "Running kmeans twice with the same seed should give the same centroids."
--- hint
TODO 1 is Stage 3 in one line: `squared_distances(X, centroids).argmin(axis=1)`. TODO 2 is a call to `update_centroids`.
--- hint
For TODO 3: `if np.allclose(new_centroids, centroids): break`.
--- hint
For TODO 4: take the distance table for the final centroids, keep each row''s smallest entry with `.min(axis=1)`, and add them all up.
```

## Watch it work

Here''s a compact reference implementation that also records the centroids after every iteration, so you can watch them travel. Compare it with yours.

```python run
import matplotlib.pyplot as plt

def kmeans_history(X, k, seed=0, max_iter=100):
    rng = np.random.default_rng(seed)
    C = X[rng.choice(len(X), size=k, replace=False)]
    history = [C]
    for _ in range(max_iter):
        labels = ((X[:, None] - C[None]) ** 2).sum(-1).argmin(1)
        new = np.array([X[labels == j].mean(0) if np.any(labels == j) else C[j] for j in range(k)])
        history.append(new)
        if np.allclose(new, C):
            break
        C = new
    return C, labels, np.array(history)

C, labels, hist = kmeans_history(X, 3, seed=5)
plt.scatter(X[:, 0], X[:, 1], c=labels, s=14, cmap="viridis", alpha=0.7)
for j in range(3):
    plt.plot(hist[:, j, 0], hist[:, j, 1], "k.--", lw=1)
plt.scatter(C[:, 0], C[:, 1], marker="X", s=180, c="crimson", edgecolor="white", zorder=3)
plt.title(f"k-means converged in {len(hist) - 1} iterations")
plt.axis("equal")
plt.show()
print("found centers:\n", C[np.argsort(C[:, 0] + C[:, 1])].round(2))
```

The dashed lines trace each centroid''s journey from its random start to the center of its cluster. Compare the found centers with `true_centers` from the setup: `[0, 0]`, `[0, 6]` and `[5, 5]`.

> **Pitfall:** k-means only finds a *local* optimum. An unlucky start can put two centroids in the same blob. In practice you run it several times with different seeds and keep the result with the lowest inertia. scikit-learn does this for you (`n_init`), and it also uses a smarter start called **k-means++**.

## How many clusters?

k-means needs you to choose $k$. A classic heuristic is the **elbow method**: plot the best inertia for each $k$ and look for the point where adding clusters stops helping much.

```python run
import matplotlib.pyplot as plt

ks = range(1, 8)
best = []
for k in ks:
    runs = [kmeans_history(X, k, seed=s)[0] for s in range(5)]
    inertias = [((X[:, None] - C[None]) ** 2).sum(-1).min(1).sum() for C in runs]
    best.append(min(inertias))

plt.plot(list(ks), best, "o-")
plt.xlabel("k")
plt.ylabel("inertia (best of 5 seeds)")
plt.title("The elbow is at k = 3")
plt.show()
print(np.round(best, 1))
```

Inertia always falls as $k$ grows (with $k = n$ it would be 0), but the drop flattens sharply after $k = 3$. That bend is the elbow.

> **In the wild:** the broadcasting distance trick you wrote in Stage 2 is everywhere: nearest-neighbor search, attention scores in transformers, and the vector quantizers inside audio codecs all compute "every item against every item" tables the same way. For very large `n`, libraries expand $\lVert x - \mu \rVert^2 = \lVert x \rVert^2 - 2\,x\cdot\mu + \lVert \mu \rVert^2$ so the middle term becomes a single matrix multiply and the `(n, k, d)` array is never built.

## Recap

- k-means alternates two steps, **assign** and **move**, and each one lowers the inertia $J$.
- Broadcasting `(n, 1, d)` against `(1, k, d)` builds every point-to-centroid distance without a Python loop.
- `argmin(axis=1)` turns a distance table into labels; boolean masks plus `.mean(axis=0)` turn labels into centroids.
- Guard against empty clusters, compare floats with `np.allclose`, and restart with several seeds.
- The elbow plot is a quick, practical way to choose $k$.

**Up next:** another core ML algorithm, linear regression, trained with gradient descent.
', 0, '[]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_8_2', 'sec_numpy_8', 'crs_numpy_mastery', 'Project: linear regression with gradient descent', 'interactive', 1, 1500, NULL, NULL, 'Linear regression is the "hello world" of machine learning, and it''s far more than a warm-up. The training loop you''ll write here is the same one that trains every neural network: **predict, measure the error, compute the gradient, step downhill, repeat**. PyTorch automates the gradient part; everything else is exactly this.

In this project you''ll implement it all in NumPy: predictions, the mean squared error, its gradient (derived by hand), batch gradient descent, feature scaling and mini-batches. At the end you''ll check your answer against NumPy''s exact least-squares solver and recover the hidden "true" weights from noisy data.

> **How this project works:** each stage is a challenge that builds one piece. Challenges run in their own namespace, so later stages restate the helpers they need. The run cells between stages explore what you just built.

```python setup
rng = np.random.default_rng(0)
n = 200
# Three features on wildly different scales, like real tabular data
X = rng.normal(size=(n, 3)) * np.array([1.0, 10.0, 0.1]) + np.array([0.0, 50.0, 1.0])
true_w = np.array([2.0, -0.5, 30.0])
true_b = 4.0
y = X @ true_w + true_b + rng.normal(scale=0.5, size=n)
```

## The data

The setup created `X`, a `(200, 3)` matrix with one row per example and one column per feature, and targets `y`, generated from hidden weights plus a little noise. Our job is to recover the weights from `X` and `y` alone.

```python run
print("X:", X.shape, "  y:", y.shape)
print("first rows of X:\n", X[:3].round(2))
print("column means:", X.mean(axis=0).round(2))
print("column stds: ", X.std(axis=0).round(2))
```

Look at those scales: the second feature sits around 50 and swings by 10, while the third barely moves around 1. Keep that in mind. It will bite us in Stage 4.

## Stage 1: the model

A linear model predicts each target as a weighted sum of the features plus a bias:

$$
\hat{y}_i = w_1 x_{i1} + w_2 x_{i2} + w_3 x_{i3} + b \quad\Longleftrightarrow\quad \hat{y} = Xw + b
$$

The matrix form on the right does all 200 predictions at once: `X @ w` is a matrix–vector product of shape `(200, 3) @ (3,)`, and the scalar `b` broadcasts across the result.

```python predict id=predict-xw-shape title="What shape are the predictions?"
X = np.ones((200, 3))
w = np.array([2.0, -0.5, 30.0])
print((X @ w + 4.0).shape)
--- options
* (200,)
(200, 1)
(3,)
(200, 3)
--- explain
`(200, 3) @ (3,)` contracts the shared dimension of length 3 and leaves one number per row: a 1-D array of shape `(200,)`. Adding the scalar bias doesn''t change the shape.
```

```python exercise id=make-predictions title="Implement the model"
def predict(X, w, b):
    """Return the model''s prediction for every row of X, shape (n,)."""
    # TODO: one matrix-vector product, plus the bias
    return ...

y_hat = predict(X, np.zeros(3), 0.0)
print(y_hat)
--- solution
def predict(X, w, b):
    """Return the model''s prediction for every row of X, shape (n,)."""
    return X @ w + b

y_hat = predict(X, np.zeros(3), 0.0)
print(y_hat)
--- test
rng_t = np.random.default_rng(3)
Xt = rng_t.normal(size=(7, 4))
wt = rng_t.normal(size=4)
out = predict(Xt, wt, 1.5)
assert out is not ..., "predict returns `...`. Replace the placeholder with your code."
out = np.asarray(out)
assert out.shape == (7,), f"For 7 examples predict should return shape (7,), got {out.shape}."
assert np.allclose(out, Xt @ wt + 1.5), "Some predictions are wrong. Each one should be the row dotted with w, plus b."
assert np.allclose(predict(Xt, wt, 0.0) + 2.0, predict(Xt, wt, 2.0)), "Changing b should shift every prediction by the same amount."
--- hint
`@` is NumPy''s matrix-multiplication operator. What shape do you get from `X @ w`?
--- hint
`X @ w + b` is the entire model.
```

## Stage 2: how wrong are we?

To learn, the model needs a single number that measures its error. The standard choice for regression is the **mean squared error**:

$$
L(w, b) = \frac{1}{n} \sum_{i=1}^{n} \left(\hat{y}_i - y_i\right)^2
$$

Squaring makes every error positive and punishes big misses much more than small ones.

```python exercise id=mse-loss title="Implement the mean squared error"
def mse(y_pred, y):
    """Return the mean squared error between predictions and targets, as one number."""
    # TODO: average the squared differences
    return ...

print(mse(np.array([1.0, 2.0, 3.0]), np.array([1.0, 2.0, 5.0])))
--- solution
def mse(y_pred, y):
    """Return the mean squared error between predictions and targets, as one number."""
    return np.mean((y_pred - y) ** 2)

print(mse(np.array([1.0, 2.0, 3.0]), np.array([1.0, 2.0, 5.0])))
--- test
r = mse(np.array([1.0, 2.0, 3.0]), np.array([1.0, 2.0, 5.0]))
assert r is not ..., "mse returns `...`. Replace the placeholder with your code."
assert np.ndim(r) == 0, f"mse should return a single number, but got shape {np.shape(r)}. Did you forget to average?"
assert np.isclose(r, 4 / 3), f"mse([1, 2, 3], [1, 2, 5]) should be 4/3 (one error of 2, squared, averaged over 3), got {r}."
rng_t = np.random.default_rng(5)
a, b = rng_t.normal(size=50), rng_t.normal(size=50)
assert np.isclose(mse(a, b), ((a - b) ** 2).sum() / 50), "mse is wrong on random data. Square first, then take the mean."
assert np.isclose(mse(a, a), 0.0), "The error of perfect predictions should be 0."
--- hint
Compute the differences, square them with `** 2`, then reduce with a mean.
--- hint
`np.mean((y_pred - y) ** 2)`. Note that the mean is taken *after* squaring.
```

With weights of zero, every prediction is just `b = 0`, so the loss is huge. A lucky guess does better, and the true weights do best of all:

```python run
def loss(w, b):
    return np.mean((X @ w + b - y) ** 2)

print("all zeros:  ", round(loss(np.zeros(3), 0.0), 2))
print("rough guess:", round(loss(np.array([1.0, -0.4, 25.0]), 0.0), 2))
print("true params:", round(loss(true_w, true_b), 3), " (just the noise, about 0.5² = 0.25)")
```

## Stage 3: which way is downhill?

Gradient descent improves the weights by stepping **against the gradient**, the direction in which the loss increases fastest. Differentiating $L$ with the chain rule gives two compact formulas. Write $e = \hat{y} - y$ for the vector of errors:

$$
\frac{\partial L}{\partial w} = \frac{2}{n} X^\top e \qquad\qquad \frac{\partial L}{\partial b} = \frac{2}{n} \sum_{i=1}^{n} e_i
$$

Read the first one as: each feature''s gradient is the correlation between that feature and the errors. `X.T @ e` has shape `(3, 200) @ (200,)`, which gives `(3,)`: one number per weight, exactly the shape of `w`.

How can you be sure a gradient formula is right? Compare it with a **numerical** estimate: nudge a parameter by a tiny $\varepsilon$ in each direction and measure the slope. Here''s the idea on a one-variable function whose derivative you know:

```python run
f = lambda w: (w - 3.0) ** 2         # derivative: 2 (w - 3)
w0, eps = 5.0, 1e-6

numerical = (f(w0 + eps) - f(w0 - eps)) / (2 * eps)
print("numerical slope:", round(numerical, 6))
print("exact slope:    ", 2 * (w0 - 3.0))
```

Professionals call this a **gradient check**, and it''s exactly how the hidden tests verify your next function.

```python exercise id=gradients title="Compute the gradients"
def gradients(X, y, w, b):
    """Return (grad_w, grad_b): the gradient of the MSE with respect to w and b."""
    n = len(X)
    error = ...   # TODO: predictions minus targets, shape (n,)
    grad_w = ...  # TODO: (2 / n) * X transposed times the error, shape (d,)
    grad_b = ...  # TODO: (2 / n) * the sum of the errors, a single number
    return grad_w, grad_b

print(gradients(X, y, np.zeros(3), 0.0))
--- solution
def gradients(X, y, w, b):
    """Return (grad_w, grad_b): the gradient of the MSE with respect to w and b."""
    n = len(X)
    error = X @ w + b - y
    grad_w = 2 / n * X.T @ error
    grad_b = 2 / n * error.sum()
    return grad_w, grad_b

print(gradients(X, y, np.zeros(3), 0.0))
--- test
rng_t = np.random.default_rng(11)
Xt = rng_t.normal(size=(30, 3))
yt = rng_t.normal(size=30)
wt = rng_t.normal(size=3)
bt = 0.7
out = gradients(Xt, yt, wt, bt)
assert isinstance(out, tuple) and len(out) == 2, "gradients should return a tuple (grad_w, grad_b)."
gw, gb = out
assert gw is not ... and gb is not ..., "gradients still returns a `...` placeholder. Fill in all three TODOs."
gw = np.asarray(gw)
assert gw.shape == (3,), f"grad_w should have one entry per feature, shape (3,), got {gw.shape}."
assert np.ndim(gb) == 0, f"grad_b should be a single number, got shape {np.shape(gb)}."
def _loss(w, b):
    return np.mean((Xt @ w + b - yt) ** 2)
eps = 1e-6
num_w = np.array([(_loss(wt + eps * e, bt) - _loss(wt - eps * e, bt)) / (2 * eps) for e in np.eye(3)])
num_b = (_loss(wt, bt + eps) - _loss(wt, bt - eps)) / (2 * eps)
assert np.allclose(gw, num_w, atol=1e-4), "grad_w doesn''t match the numerical gradient check. Check the sign of the error, the 2/n factor and the transpose."
assert np.isclose(gb, num_b, atol=1e-4), "grad_b doesn''t match the numerical gradient check. It should be 2/n times the sum of the errors."
--- hint
Start with `error = X @ w + b - y`. The order matters: predictions *minus* targets.
--- hint
`X.T @ error` sums each feature times the error over all examples. Scale it by `2 / n`. For the bias, sum the errors instead.
```

## A classic shape bug

Real datasets often load the target as a **column**, shape `(n, 1)`, instead of a flat `(n,)` vector. That one innocent difference triggers broadcasting in a way that silently wrecks training:

```python predict id=predict-column-broadcast title="Column minus row"
y_col = np.zeros((200, 1))
y_hat = np.zeros(200)
print((y_hat - y_col).shape)
--- options
(200,)
(200, 1)
* (200, 200)
(1, 200)
--- explain
`(200,)` is treated as `(1, 200)` and broadcast against `(200, 1)`, producing a full `(200, 200)` table of every prediction minus every target. No error is raised; the numbers are just meaningless.
```

```python debug id=column-vector-bug title="Training crashes with a broadcasting error"
rng_d = np.random.default_rng(1)
Xd = rng_d.normal(size=(50, 2))
yd = (Xd @ np.array([3.0, -1.0]) + 2.0).reshape(-1, 1)   # targets loaded as a column

w = np.zeros(2)
b = 0.0
for step in range(200):
    error = Xd @ w + b - yd
    grad_w = 2 / len(Xd) * Xd.T @ error
    grad_b = 2 / len(Xd) * error.sum()
    w = w - 0.1 * grad_w
    b = b - 0.1 * grad_b

print("w shape:", np.shape(w))
print("w:", w)
print("b:", b)
--- solution
rng_d = np.random.default_rng(1)
Xd = rng_d.normal(size=(50, 2))
yd = Xd @ np.array([3.0, -1.0]) + 2.0   # keep the targets as a flat (n,) vector

w = np.zeros(2)
b = 0.0
for step in range(200):
    error = Xd @ w + b - yd
    grad_w = 2 / len(Xd) * Xd.T @ error
    grad_b = 2 / len(Xd) * error.sum()
    w = w - 0.1 * grad_w
    b = b - 0.1 * grad_b

print("w shape:", np.shape(w))
print("w:", w)
print("b:", b)
--- test
assert np.shape(w) == (2,), f"w should have shape (2,), one weight per feature, but it has shape {np.shape(w)}."
assert np.ndim(b) == 0, "b should be a single number."
assert np.allclose(w, [3.0, -1.0], atol=1e-2), f"Training should recover w = [3, -1], but got {np.round(w, 3).tolist()}."
assert np.isclose(b, 2.0, atol=1e-2), f"Training should recover b = 2, but got {b}."
--- hint
Run it. The error says the update tried to combine `w` (shape `(2,)`) with a gradient of shape `(2, 50)`, but the gradient should have the same shape as `w`. Use **Debug** and check the shape of `error` on the very first iteration.
--- hint
`Xd @ w` has shape `(50,)` but `yd` has shape `(50, 1)`, so their difference broadcasts to `(50, 50)`. Make the targets a flat vector, for example by dropping the `.reshape(-1, 1)` or calling `.ravel()`.
```

> **In the wild:** this exact bug is a rite of passage in PyTorch too, where `nn.MSELoss` will warn that "target size is different to input size" and then broadcast anyway. When a loss looks strangely stuck, print the shapes of predictions and targets first.

## Stage 4: why scale matters

Let''s run gradient descent on the raw features. A learning rate of `0.01` sounds modest:

```python run
def train(X, y, lr, epochs):
    w, b = np.zeros(X.shape[1]), 0.0
    for _ in range(epochs):
        error = X @ w + b - y
        w = w - lr * 2 / len(X) * X.T @ error
        b = b - lr * 2 / len(X) * error.sum()
    return w, b, np.mean((X @ w + b - y) ** 2)

for lr, epochs in [(0.01, 20), (1e-4, 500)]:
    w, b, final = train(X, y, lr, epochs)
    print(f"lr={lr:<6} epochs={epochs:<4} loss={final:.4g}  w={np.round(w, 2)}")
```

With `lr=0.01` the loss explodes to `inf` or `nan`. With a tiny `lr=1e-4` it''s stable, but after 500 epochs it''s nowhere near the answer. The second feature (values around 50) has a gradient thousands of times steeper than the third (values around 1), and a single learning rate can''t suit both: it''s too big for one and too small for the other.

The fix is **standardization**: shift and scale every column to mean 0 and standard deviation 1,

$$
x''_{ij} = \frac{x_{ij} - \mu_j}{\sigma_j}
$$

so every feature lives on the same scale and one learning rate works for all of them.

```python exercise id=standardize title="Standardize the features"
def standardize(X):
    """Scale every column to mean 0 and std 1. Return (X_scaled, mean, std)."""
    mean = ...       # TODO: one mean per column, shape (d,)
    std = ...        # TODO: one standard deviation per column, shape (d,)
    X_scaled = ...   # TODO: broadcasting does the rest
    return X_scaled, mean, std

Xs, mu, sigma = standardize(X)
print("mean:", mu)
print("std: ", sigma)
--- solution
def standardize(X):
    """Scale every column to mean 0 and std 1. Return (X_scaled, mean, std)."""
    mean = X.mean(axis=0)
    std = X.std(axis=0)
    X_scaled = (X - mean) / std
    return X_scaled, mean, std

Xs, mu, sigma = standardize(X)
print("mean:", mu)
print("std: ", sigma)
--- test
rng_t = np.random.default_rng(9)
A = rng_t.normal(loc=[5.0, -20.0, 100.0], scale=[2.0, 0.1, 30.0], size=(80, 3))
out = standardize(A)
assert isinstance(out, tuple) and len(out) == 3, "standardize should return a tuple (X_scaled, mean, std)."
Xs_t, mu_t, sd_t = out
assert Xs_t is not ... and mu_t is not ... and sd_t is not ..., "standardize still returns a `...` placeholder. Fill in all three TODOs."
assert np.shape(mu_t) == (3,) and np.shape(sd_t) == (3,), f"mean and std should hold one value per column, shape (3,), got {np.shape(mu_t)} and {np.shape(sd_t)}. Which axis did you reduce over?"
assert np.shape(Xs_t) == (80, 3), f"X_scaled should keep the shape of X, (80, 3), got {np.shape(Xs_t)}."
assert np.allclose(Xs_t.mean(axis=0), 0.0, atol=1e-9), "Every column of X_scaled should have mean 0."
assert np.allclose(Xs_t.std(axis=0), 1.0), "Every column of X_scaled should have standard deviation 1."
assert np.allclose(Xs_t * sd_t + mu_t, A), "You should be able to undo the scaling: X_scaled * std + mean should equal X."
--- hint
Reduce **down the rows** so you get one statistic per column: `axis=0`.
--- hint
`mean = X.mean(axis=0)`, `std = X.std(axis=0)`, then `(X - mean) / std`. The `(3,)` statistics broadcast across all rows.
```

Now the learning rate has a predictable effect. Watch the loss curves for four rates on the standardized features:

```python run
import matplotlib.pyplot as plt

Xs = (X - X.mean(axis=0)) / X.std(axis=0)

for lr in [0.01, 0.1, 0.5, 1.05]:
    w, b, losses = np.zeros(3), 0.0, []
    for _ in range(60):
        error = Xs @ w + b - y
        losses.append(np.mean(error ** 2))
        w = w - lr * 2 / len(Xs) * Xs.T @ error
        b = b - lr * 2 / len(Xs) * error.sum()
    plt.semilogy(losses, label=f"lr = {lr}")
    print(f"lr={lr:<5} final loss {losses[-1]:.4g}")

plt.xlabel("epoch")
plt.ylabel("MSE (log scale)")
plt.legend()
plt.title("Too small crawls, too big diverges")
plt.show()
```

`0.01` crawls, `0.1` and `0.5` converge quickly, and `1.05` overshoots further on every step until it diverges. Finding the largest learning rate that still converges is the first thing you tune in any training run.

## Stage 5: the full training loop

Time to assemble everything into a reusable `fit` function. It takes standardized features, runs batch gradient descent, and returns the learned parameters together with the loss history.

```python exercise id=fit-gd title="Train with batch gradient descent"
def fit(X, y, lr=0.1, epochs=500):
    """Batch gradient descent for linear regression. Return (w, b, losses)."""
    n, d = X.shape
    w = np.zeros(d)
    b = 0.0
    losses = []
    for epoch in range(epochs):
        # TODO 1: compute the error vector (predictions minus targets)
        # TODO 2: append the current MSE to `losses`
        # TODO 3: compute grad_w and grad_b
        # TODO 4: step downhill: w = w - lr * grad_w, and the same for b
        ...
    return w, b, np.array(losses)

Xs = (X - X.mean(axis=0)) / X.std(axis=0)
w, b, losses = fit(Xs, y)
print("w:", w, " b:", b)
print("epochs recorded:", len(losses))
--- solution
def fit(X, y, lr=0.1, epochs=500):
    """Batch gradient descent for linear regression. Return (w, b, losses)."""
    n, d = X.shape
    w = np.zeros(d)
    b = 0.0
    losses = []
    for epoch in range(epochs):
        error = X @ w + b - y
        losses.append(np.mean(error ** 2))
        grad_w = 2 / n * X.T @ error
        grad_b = 2 / n * error.sum()
        w = w - lr * grad_w
        b = b - lr * grad_b
    return w, b, np.array(losses)

Xs = (X - X.mean(axis=0)) / X.std(axis=0)
w, b, losses = fit(Xs, y)
print("w:", w, " b:", b)
print("epochs recorded:", len(losses))
--- test
rng_t = np.random.default_rng(5)
Xt = rng_t.normal(size=(150, 4))
wt = np.array([1.5, -2.0, 0.5, 3.0])
yt = Xt @ wt - 1.0 + rng_t.normal(scale=0.1, size=150)
out = fit(Xt, yt, lr=0.1, epochs=300)
assert isinstance(out, tuple) and len(out) == 3, "fit should return a tuple (w, b, losses)."
w_t, b_t, losses_t = out
losses_t = np.asarray(losses_t)
assert losses_t.shape == (300,), f"losses should hold one value per epoch, shape (300,), got {losses_t.shape}."
assert np.shape(w_t) == (4,), f"w should have one weight per feature, shape (4,), got {np.shape(w_t)}."
assert losses_t[-1] < losses_t[0], "The loss went up during training. Check the sign of your update: step *against* the gradient."
assert np.all(np.diff(losses_t) <= 1e-9), "With lr=0.1 on standardized data the loss should never increase. Are you computing the loss and gradients from the same, current w and b?"
A = np.column_stack([Xt, np.ones(150)])
best = np.linalg.lstsq(A, yt, rcond=None)[0]
assert np.allclose(w_t, best[:4], atol=1e-2), f"After 300 epochs w should match the least-squares solution {np.round(best[:4], 3).tolist()}, but got {np.round(w_t, 3).tolist()}."
assert np.isclose(b_t, best[4], atol=1e-2), f"After 300 epochs b should be close to {best[4]:.3f}, but got {b_t:.3f}."
--- hint
Inside the loop, reuse your Stage 3 code: `error = X @ w + b - y`, then `losses.append(np.mean(error ** 2))`.
--- hint
The gradients are `2 / n * X.T @ error` and `2 / n * error.sum()`. Then update with `w = w - lr * grad_w` and `b = b - lr * grad_b`.
```

## Mini-batches: how big models actually train

Batch gradient descent touches **every** example before each step. With millions of rows that''s too slow, so real training uses **mini-batches**: shuffle the data each epoch, then take a step on each small chunk. Each step is noisier but far cheaper, and the noise even helps escape bad regions in deep networks.

```python run
Xs = (X - X.mean(axis=0)) / X.std(axis=0)
rng_mb = np.random.default_rng(0)
w, b, batch = np.zeros(3), 0.0, 32

for epoch in range(30):
    order = rng_mb.permutation(len(Xs))          # a fresh shuffle every epoch
    for start in range(0, len(Xs), batch):
        idx = order[start:start + batch]
        error = Xs[idx] @ w + b - y[idx]
        w = w - 0.05 * 2 / len(idx) * Xs[idx].T @ error
        b = b - 0.05 * 2 / len(idx) * error.sum()

print("steps taken:", 30 * int(np.ceil(len(Xs) / batch)))
print("mini-batch w:", w.round(3), " b:", round(b, 3))
print("final loss:  ", round(np.mean((Xs @ w + b - y) ** 2), 4))
```

> **Under the hood:** this inner loop is exactly what `torch.utils.data.DataLoader(shuffle=True, batch_size=32)` plus an optimizer step does. Only the gradient computation is automated.

## The payoff: recover the hidden weights

Two last questions. Did gradient descent find the *best possible* answer? And what do the weights mean in the original units?

For linear regression we can check exactly, because the optimum has a closed form: least squares. `np.linalg.lstsq` solves it directly once we append a column of ones for the bias. To compare with gradient descent, undo the standardization: if $x'' = (x - \mu)/\sigma$, then $w = w'' / \sigma$ and $b = b'' - \sum_j \mu_j w''_j / \sigma_j$.

```python run
mu, sigma = X.mean(axis=0), X.std(axis=0)
Xs = (X - mu) / sigma

w_s, b_s = np.zeros(3), 0.0
for _ in range(500):
    error = Xs @ w_s + b_s - y
    w_s, b_s = w_s - 0.1 * 2 / n * Xs.T @ error, b_s - 0.1 * 2 / n * error.sum()

w_gd = w_s / sigma
b_gd = b_s - (mu / sigma) @ w_s

A = np.column_stack([X, np.ones(n)])
exact = np.linalg.lstsq(A, y, rcond=None)[0]

print("true:           w =", true_w, "    b =", true_b)
print("gradient desc.: w =", w_gd.round(3), " b =", round(b_gd, 3))
print("least squares:  w =", exact[:3].round(3), " b =", round(exact[3], 3))
```

Gradient descent matches the exact least-squares solution, and both land within the noise of the true parameters: `w ≈ [2, -0.5, 30]` and `b ≈ 4`. You''ve recovered the hidden law behind the data.

> **Tip:** for linear regression specifically, prefer `np.linalg.lstsq`. It''s exact and needs no learning rate. Gradient descent earns its keep when there''s no closed form, which is the case for logistic regression, neural networks and almost every other model.

## Recap

- A linear model is `X @ w + b`; matrix form makes all predictions at once.
- MSE measures error; its gradients are $\frac{2}{n}X^\top e$ and $\frac{2}{n}\sum e$, and a numerical gradient check verifies them.
- Keep targets as `(n,)` vectors: `(n,)` minus `(n, 1)` silently broadcasts to `(n, n)`.
- Standardize features so a single learning rate suits every weight, then tune the rate: too small crawls, too large diverges.
- Mini-batches trade exact gradients for cheap, frequent steps. That''s how every large model trains.

**Up next:** the final project, where you simulate whole worlds with vectorized NumPy: Conway''s Game of Life and Monte Carlo experiments.
', 0, '[]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_8_3', 'sec_numpy_8', 'crs_numpy_mastery', 'Project: Game of Life and Monte Carlo simulation', 'interactive', 2, 1320, NULL, NULL, 'Simulation is where vectorized thinking pays off most dramatically. Instead of updating one cell, one particle or one dart at a time, you update **all of them at once** with a handful of array operations. A simulation that crawls as a Python loop runs comfortably in NumPy, even in a browser.

In this final project you''ll build three classic simulations:

1. **Conway''s Game of Life**: a whole universe evolving by simple local rules, updated with no loops over cells.
2. **Monte Carlo estimation of π**: throwing a hundred thousand random darts at once.
3. **Random walks**: thousands of random paths simulated together, and the surprising $\sqrt{t}$ law they obey.

```python setup
def show(board):
    """Print a 0/1 board: █ for live cells, · for dead ones."""
    print("\n".join("".join("█" if v else "·" for v in row) for row in board))

glider = np.zeros((8, 8), dtype=int)
glider[0, 1] = glider[1, 2] = glider[2, 0] = glider[2, 1] = glider[2, 2] = 1
```

## Part 1: the Game of Life

The Game of Life is played on a grid of cells, each alive (`1`) or dead (`0`). Every generation, every cell looks at its **8 neighbors** and follows two rules:

| Cell is… | Live neighbors | Next generation |
|---|---|---|
| alive | 2 or 3 | stays alive (survival) |
| alive | anything else | dies (loneliness or overcrowding) |
| dead | exactly 3 | comes alive (birth) |
| dead | anything else | stays dead |

From these rules emerge gliders that crawl across the grid, oscillators, and even patterns that build other patterns. The setup created a **glider** and a `show` helper to print boards:

```python run
show(glider)
print("live cells:", glider.sum())
```

### Counting neighbors without looping over cells

The naive approach visits every cell and inspects its 8 neighbors, a double loop over the whole grid. The NumPy approach flips it around: **shift the entire board** in each of the 8 directions and add the shifted copies together. Each cell then holds exactly how many live neighbors it has.

`np.roll` shifts an array along an axis and **wraps** what falls off one edge around to the other. That turns the grid into a torus, so gliders that leave on the right re-enter on the left:

```python run
a = np.array([1, 2, 3, 4, 5])
print("roll right by 1:", np.roll(a, 1))
print("roll left by 1: ", np.roll(a, -1))

b = np.array([[1, 0, 0],
              [0, 0, 0],
              [0, 0, 0]])
print("2-D roll by (1, 1), down and right:")
print(np.roll(b, (1, 1), axis=(0, 1)))
```

```python predict id=predict-roll title="Where does the last element go?"
print(np.roll(np.array([1, 2, 3, 4]), 1))
--- options
[2 3 4 1]
* [4 1 2 3]
[0 1 2 3]
[1 2 3 4]
--- explain
Rolling by `+1` moves every element one position to the right, and the element that falls off the end (`4`) wraps around to the front. With a plain shift it would be lost; with `np.roll` nothing is ever lost.
```

```python exercise id=count-neighbors title="Count every cell''s live neighbors"
def count_neighbors(board):
    """For every cell, count live neighbors among the 8 surrounding cells (edges wrap around)."""
    total = np.zeros_like(board)
    for dy in (-1, 0, 1):
        for dx in (-1, 0, 1):
            if (dy, dx) == (0, 0):
                continue  # a cell is not its own neighbor
            # TODO: add the board shifted by dy rows and dx columns into `total`
            ...
    return total

print(count_neighbors(glider))
--- solution
def count_neighbors(board):
    """For every cell, count live neighbors among the 8 surrounding cells (edges wrap around)."""
    total = np.zeros_like(board)
    for dy in (-1, 0, 1):
        for dx in (-1, 0, 1):
            if (dy, dx) == (0, 0):
                continue  # a cell is not its own neighbor
            total += np.roll(board, (dy, dx), axis=(0, 1))
    return total

print(count_neighbors(glider))
--- test
rng_t = np.random.default_rng(2)
B = (rng_t.random((7, 9)) < 0.4).astype(int)
B_before = B.copy()
N = count_neighbors(B)
assert N is not None and N is not ..., "count_neighbors should return the array of counts."
N = np.asarray(N)
assert N.shape == (7, 9), f"The counts should have the same shape as the board, (7, 9), got {N.shape}."
assert N.any(), "Every count is 0. Add each shifted copy of the board into `total`."
ref = np.zeros((7, 9), dtype=int)
for i in range(7):
    for j in range(9):
        ref[i, j] = sum(B[(i + di) % 7, (j + dj) % 9] for di in (-1, 0, 1) for dj in (-1, 0, 1) if (di, dj) != (0, 0))
assert np.array_equal(N, ref), "Some counts are wrong. Shift along both axes at once (rows by dy, columns by dx), and remember edges wrap."
assert np.array_equal(B, B_before), "count_neighbors should not modify the board."
--- hint
This loop runs only 8 times, once per direction, not once per cell. Each time, add a shifted copy of the *whole* board to `total`.
--- hint
`np.roll(board, (dy, dx), axis=(0, 1))` shifts rows by `dy` and columns by `dx` in one call. Add it with `total += ...`.
```

### One generation in three lines

With neighbor counts in hand, the rules become boolean array logic. Remember from earlier in the course: combine element-wise conditions with `&` and `|`, and **always wrap each comparison in parentheses**.

```python exercise id=life-step title="Advance the universe one generation"
def count_neighbors(board):  # from the previous challenge
    total = np.zeros_like(board)
    for dy in (-1, 0, 1):
        for dx in (-1, 0, 1):
            if (dy, dx) != (0, 0):
                total += np.roll(board, (dy, dx), axis=(0, 1))
    return total

def step(board):
    """Return the next generation as an integer array of 0s and 1s."""
    n = count_neighbors(board)
    # TODO: live cells survive with 2 or 3 neighbors; dead cells are born with exactly 3
    return ...

print(step(glider))
--- solution
def count_neighbors(board):  # from the previous challenge
    total = np.zeros_like(board)
    for dy in (-1, 0, 1):
        for dx in (-1, 0, 1):
            if (dy, dx) != (0, 0):
                total += np.roll(board, (dy, dx), axis=(0, 1))
    return total

def step(board):
    """Return the next generation as an integer array of 0s and 1s."""
    n = count_neighbors(board)
    survive = (board == 1) & ((n == 2) | (n == 3))
    born = (board == 0) & (n == 3)
    return (survive | born).astype(int)

show(step(glider))
--- test
blinker = np.zeros((5, 5), dtype=int)
blinker[2, 1:4] = 1
nxt = step(blinker)
assert nxt is not ..., "step returns `...`. Replace the placeholder with your code."
nxt = np.asarray(nxt)
assert nxt.shape == (5, 5), f"step should return a board of the same shape, (5, 5), got {nxt.shape}."
assert np.issubdtype(nxt.dtype, np.integer), f"step should return 0s and 1s as integers, not {nxt.dtype}. Try `.astype(int)`."
assert set(np.unique(nxt).tolist()) <= {0, 1}, "The next generation should contain only 0s and 1s."
vertical = np.zeros((5, 5), dtype=int)
vertical[1:4, 2] = 1
assert np.array_equal(nxt, vertical), "A horizontal line of 3 (a ''blinker'') should turn vertical after one step."
assert np.array_equal(blinker[2, 1:4], [1, 1, 1]), "step should not modify the board it''s given."
block = np.zeros((4, 4), dtype=int)
block[1:3, 1:3] = 1
assert np.array_equal(step(block), block), "A 2×2 block is stable; it should not change."
g = glider.copy()
for _ in range(4):
    g = step(g)
assert np.array_equal(g, np.roll(glider, (1, 1), axis=(0, 1))), "After 4 generations the glider should move one cell down and one cell right."
rng_t = np.random.default_rng(4)
B = (rng_t.random((9, 11)) < 0.35).astype(int)
N = count_neighbors(B)
ref = np.array([[1 if (B[i, j] and N[i, j] in (2, 3)) or (not B[i, j] and N[i, j] == 3) else 0 for j in range(11)] for i in range(9)])
assert np.array_equal(step(B), ref), "step gives the wrong result on a random board. Check both rules: survival with 2 or 3, birth with exactly 3."
--- hint
Build two boolean masks: `survive` for live cells with 2 or 3 neighbors, and `born` for dead cells with exactly 3. The next board is `survive | born`.
--- hint
`survive = (board == 1) & ((n == 2) | (n == 3))`. Write `born` the same way, then convert the combined mask with `.astype(int)`.
```

### Debug challenge: the universe explodes

A teammate wrote their own `step`, but every simulation instantly fills with life. Their neighbor count is correct; the bug is elsewhere.

```python debug id=life-precedence-bug title="Why is every cell suddenly alive?"
def count_neighbors(board):
    total = np.zeros_like(board)
    for dy in (-1, 0, 1):
        for dx in (-1, 0, 1):
            if (dy, dx) != (0, 0):
                total += np.roll(board, (dy, dx), axis=(0, 1))
    return total

def step(board):
    n = count_neighbors(board)
    born = (board == 0) & (n == 3)
    survive = board == 1 & (n == 2) | (n == 3)
    return (born | survive).astype(int)

blinker = np.zeros((5, 5), dtype=int)
blinker[2, 1:4] = 1
show(step(blinker))
--- solution
def count_neighbors(board):
    total = np.zeros_like(board)
    for dy in (-1, 0, 1):
        for dx in (-1, 0, 1):
            if (dy, dx) != (0, 0):
                total += np.roll(board, (dy, dx), axis=(0, 1))
    return total

def step(board):
    n = count_neighbors(board)
    born = (board == 0) & (n == 3)
    survive = (board == 1) & ((n == 2) | (n == 3))
    return (born | survive).astype(int)

blinker = np.zeros((5, 5), dtype=int)
blinker[2, 1:4] = 1
show(step(blinker))
--- test
blinker = np.zeros((5, 5), dtype=int)
blinker[2, 1:4] = 1
vertical = np.zeros((5, 5), dtype=int)
vertical[1:4, 2] = 1
out = np.asarray(step(blinker))
assert out.sum() < 10, "Almost every cell came alive. Dead cells must stay dead unless they have exactly 3 neighbors."
assert np.array_equal(out, vertical), f"A horizontal blinker should become vertical, but the next board has {int(out.sum())} live cells instead of 3."
g = glider.copy()
for _ in range(4):
    g = step(g)
assert np.array_equal(g, np.roll(glider, (1, 1), axis=(0, 1))), "The glider should move one cell diagonally every 4 generations."
--- hint
Run it: almost every dead cell came alive. Which line decides whether a cell is alive in the next generation, and could it be true for a *dead* cell?
--- hint
In Python, `&` and `|` bind **more tightly** than `==`. So `board == 1 & (n == 2) | (n == 3)` is read as `board == ((1 & (n == 2)) | (n == 3))`. Add parentheses around each comparison.
```

### Watch it live

Here''s the glider over eight generations. Each frame uses the same `step` logic you just wrote:

```python run
import matplotlib.pyplot as plt

def life_step(board):
    n = sum(np.roll(board, (dy, dx), axis=(0, 1)) for dy in (-1, 0, 1) for dx in (-1, 0, 1) if (dy, dx) != (0, 0))
    return (((board == 1) & ((n == 2) | (n == 3))) | ((board == 0) & (n == 3))).astype(int)

fig, axes = plt.subplots(1, 8, figsize=(10, 1.6))
board = glider
for gen, ax in enumerate(axes):
    ax.imshow(board, cmap="Greys", vmin=0, vmax=1)
    ax.set_title(f"gen {gen}", fontsize=8)
    ax.set_xticks([])
    ax.set_yticks([])
    board = life_step(board)
plt.show()
```

Every four generations the glider reappears one cell further down and to the right. Now scale up: a random 64 × 64 "soup" left to evolve for 150 generations. That''s 615,000 cell updates, with no loop over cells:

```python run
import matplotlib.pyplot as plt

soup = (np.random.default_rng(1).random((64, 64)) < 0.3).astype(int)
population = [soup.sum()]
for _ in range(150):
    soup = life_step(soup)
    population.append(soup.sum())

fig, (left, right) = plt.subplots(1, 2, figsize=(9, 3.4))
left.plot(population)
left.set_xlabel("generation")
left.set_ylabel("live cells")
left.set_title("Population settles down")
right.imshow(soup, cmap="Greys")
right.set_title("Generation 150")
right.set_xticks([])
right.set_yticks([])
plt.show()
print("start:", population[0], " end:", population[-1])
```

The population crashes from chaos, then settles into a sparse world of stable blocks, blinkers and the occasional glider.

## Part 2: Monte Carlo π

Monte Carlo methods answer hard questions with random sampling. Here''s the classic: throw darts uniformly at the unit square $[0, 1]^2$. The quarter circle $x^2 + y^2 \le 1$ covers an area of $\pi / 4$, so the fraction of darts landing inside approximates $\pi / 4$:

$$
\pi \approx 4 \cdot \frac{\#\{\text{darts with } x^2 + y^2 \le 1\}}{n}
$$

With NumPy, all $n$ darts are thrown at once: one `(n, 2)` array of random numbers, one comparison, and one mean.

```python exercise id=estimate-pi title="Estimate π by throwing darts"
def estimate_pi(n, seed=0):
    """Estimate π from n random points in the unit square."""
    rng = np.random.default_rng(seed)
    points = ...   # TODO: n random points, shape (n, 2), uniform in [0, 1)
    inside = ...   # TODO: boolean mask, True where x² + y² <= 1
    return ...     # TODO: 4 times the fraction of points inside

print(estimate_pi(100_000))
--- solution
def estimate_pi(n, seed=0):
    """Estimate π from n random points in the unit square."""
    rng = np.random.default_rng(seed)
    points = rng.random((n, 2))
    inside = (points ** 2).sum(axis=1) <= 1
    return 4 * inside.mean()

print(estimate_pi(100_000))
--- test
est = estimate_pi(200_000, seed=1)
assert est is not ..., "estimate_pi returns `...`. Replace the placeholders with your code."
assert np.ndim(est) == 0, f"estimate_pi should return a single number, got shape {np.shape(est)}."
assert abs(float(est) - np.pi) < 0.02, f"With 200,000 darts the estimate should be within 0.02 of π, but it is {float(est):.4f}."
assert estimate_pi(1000, seed=4) == estimate_pi(1000, seed=4), "The same seed should give the same estimate. Build the generator from `seed`."
assert estimate_pi(1000, seed=4) != estimate_pi(1000, seed=5), "Different seeds should give different estimates. Are you ignoring `seed`?"
small = float(estimate_pi(10, seed=0))
hits = small * 10 / 4
assert np.isclose(hits, round(hits)), "With n=10 the estimate should be 4 × (a whole number of hits) / 10. Is every point counted exactly once?"
--- hint
`rng.random((n, 2))` gives `n` points. Each row is one `(x, y)` dart.
--- hint
Square every coordinate, sum each row with `.sum(axis=1)`, and compare with `<= 1`. The mean of a boolean array is the fraction of `True` values.
```

Here are the darts, plus the question every simulation must answer: **how accurate is it?**

```python run
import matplotlib.pyplot as plt

rng = np.random.default_rng(0)
pts = rng.random((3000, 2))
inside = (pts ** 2).sum(axis=1) <= 1

plt.figure(figsize=(3.8, 3.8))
plt.scatter(*pts[inside].T, s=3, color="tab:blue")
plt.scatter(*pts[~inside].T, s=3, color="tab:orange")
plt.title(f"3,000 darts: π ≈ {4 * inside.mean():.4f}")
plt.gca().set_aspect("equal")
plt.show()
```

```python run
import matplotlib.pyplot as plt

rng = np.random.default_rng(1)
ns = np.array([100, 1_000, 10_000, 100_000])
errors = []
for n in ns:
    estimates = [4 * ((rng.random((n, 2)) ** 2).sum(axis=1) <= 1).mean() for _ in range(10)]
    errors.append(np.mean(np.abs(np.array(estimates) - np.pi)))

plt.loglog(ns, errors, "o-", label="average error (10 runs)")
plt.loglog(ns, 1.3 / np.sqrt(ns), "k--", label=r"$\propto 1/\sqrt{n}$")
plt.xlabel("darts")
plt.ylabel("|estimate − π|")
plt.legend()
plt.show()
print(np.round(errors, 5))
```

The error shrinks like $1/\sqrt{n}$: **100× more darts buy only 10× more accuracy**. That law holds for every Monte Carlo method, from option pricing to particle physics, and it''s why those fields care so much about fast, vectorized sampling.

## Part 3: random walks

A random walk starts at 0 and takes steps of $+1$ or $-1$ with equal probability. It models diffusing molecules, stock prices and gambler''s fortunes. The position after each step is the **running total** of the steps, which is exactly what `cumsum` computes:

```python run
rng = np.random.default_rng(3)
steps = rng.choice([-1, 1], size=10)
print("steps:    ", steps)
print("positions:", steps.cumsum())
```

```python predict id=predict-cumsum title="Where does the walk end, and how low does it go?"
steps = np.array([1, -1, -1, 1, 1])
positions = steps.cumsum()
print(positions[-1], positions.min())
--- options
* 1 -1
1 0
5 -1
3 -2
--- explain
The running totals are `1, 0, -1, 0, 1`. The walk ends at `1` (the same as `steps.sum()`), and its lowest point is `-1`, after the third step.
```

To study walks statistically, simulate thousands at once: a 2-D array of steps with **one walk per row**, and a cumulative sum **along each row**.

```python exercise id=random-walks title="Simulate many walks at once"
def random_walks(n_walks, n_steps, seed=0):
    """Return positions of shape (n_walks, n_steps): each row is one walk of ±1 steps."""
    rng = np.random.default_rng(seed)
    steps = ...   # TODO: random -1/+1 steps, shape (n_walks, n_steps)
    return ...    # TODO: the running total along each walk (row)

walks = random_walks(5, 8)
print(walks)
--- solution
def random_walks(n_walks, n_steps, seed=0):
    """Return positions of shape (n_walks, n_steps): each row is one walk of ±1 steps."""
    rng = np.random.default_rng(seed)
    steps = rng.choice([-1, 1], size=(n_walks, n_steps))
    return steps.cumsum(axis=1)

walks = random_walks(5, 8)
print(walks)
--- test
P = random_walks(4000, 100, seed=3)
assert P is not ..., "random_walks returns `...`. Replace the placeholders with your code."
P = np.asarray(P)
assert P.shape == (4000, 100), f"random_walks(4000, 100) should have shape (4000, 100), got {P.shape}."
assert set(np.unique(P[:, 0]).tolist()) <= {-1, 1}, "Each walk''s first position should be its first step: -1 or +1."
assert set(np.unique(np.diff(P, axis=1)).tolist()) <= {-1, 1}, "Consecutive positions in a walk should differ by exactly ±1. Is the running total taken along each row (axis=1)?"
assert np.array_equal(random_walks(50, 20, seed=1), random_walks(50, 20, seed=1)), "The same seed should give the same walks."
final = P[:, -1].astype(float)
assert abs(final.mean()) < 0.6, f"Steps should be +1 or -1 with equal probability, but the average final position is {final.mean():.2f}."
assert abs(np.sqrt((final ** 2).mean()) - 10) < 0.6, "After 100 fair ±1 steps the typical distance from 0 should be about 10. Check that steps are independent."
--- hint
`rng.choice([-1, 1], size=(n_walks, n_steps))` draws every step of every walk in one call.
--- hint
`cumsum` needs an axis here: the running total must go along each row, `axis=1`. Without an axis it flattens everything into one long walk.
```

Now the payoff. Simulate 2,000 walks of 400 steps and look at how far they spread:

```python run
import matplotlib.pyplot as plt

rng = np.random.default_rng(7)
walks = rng.choice([-1, 1], size=(2000, 400)).cumsum(axis=1)
t = np.arange(1, 401)
rms = np.sqrt((walks.astype(float) ** 2).mean(axis=0))

plt.plot(t, walks[:12].T, lw=0.8, alpha=0.8)
plt.plot(t, rms, "k", lw=2, label="RMS distance over 2,000 walks")
plt.plot(t, -rms, "k", lw=2)
plt.plot(t, np.sqrt(t), "r--", label=r"$\sqrt{t}$")
plt.xlabel("step t")
plt.ylabel("position")
plt.legend(loc="upper left")
plt.show()
print("RMS distance after 100, 400 steps:", rms[99].round(2), rms[399].round(2))
```

The black envelope tracks $\sqrt{t}$ almost perfectly. A random walker travels a typical distance of $\sqrt{t}$ after $t$ steps: **four times the time, only twice the distance**. This is the same square-root law as the Monte Carlo error above, and the reason diffusion is so slow.

```python exercise id=walk-stats title="Summarize a batch of walks"
def walk_stats(positions, target=10):
    """Return (mean_final, rms_final, frac_reached) for a (n_walks, n_steps) array."""
    final = ...          # TODO: the last position of every walk, shape (n_walks,)
    mean_final = ...     # TODO: the average final position
    rms_final = ...      # TODO: root-mean-square final distance: sqrt(mean(final ** 2))
    frac_reached = ...   # TODO: fraction of walks whose position is ever >= target
    return mean_final, rms_final, frac_reached

demo = np.array([[1, 2, 3, 2], [-1, -2, -1, 0], [1, 0, 1, 2]])
print(walk_stats(demo, target=3))
--- solution
def walk_stats(positions, target=10):
    """Return (mean_final, rms_final, frac_reached) for a (n_walks, n_steps) array."""
    final = positions[:, -1]
    mean_final = final.mean()
    rms_final = np.sqrt((final.astype(float) ** 2).mean())
    frac_reached = (positions.max(axis=1) >= target).mean()
    return mean_final, rms_final, frac_reached

demo = np.array([[1, 2, 3, 2], [-1, -2, -1, 0], [1, 0, 1, 2]])
print(walk_stats(demo, target=3))
--- test
demo = np.array([[1, 2, 3, 2], [-1, -2, -1, 0], [1, 0, 1, 2]])
out = walk_stats(demo, target=3)
assert isinstance(out, tuple) and len(out) == 3, "walk_stats should return a tuple (mean_final, rms_final, frac_reached)."
m, r, f = out
assert m is not ... and r is not ... and f is not ..., "walk_stats still returns a `...` placeholder. Fill in every TODO."
assert np.ndim(m) == 0 and np.ndim(r) == 0 and np.ndim(f) == 0, "All three statistics should be single numbers. Did you reduce over the right axis?"
assert np.isclose(m, 4 / 3), f"mean_final should average the *last* position of each walk (2, 0 and 2), giving 1.333, but got {m}."
assert np.isclose(r, np.sqrt(8 / 3)), f"rms_final should be sqrt(mean(final ** 2)) = sqrt((4 + 0 + 4) / 3), but got {r}."
assert np.isclose(f, 1 / 3), f"Only the first walk ever reaches 3, so frac_reached should be 1/3, but got {f}. Look at each walk''s maximum, not its final position."
rng_t = np.random.default_rng(8)
P = rng_t.choice([-1, 1], size=(300, 60)).cumsum(axis=1)
m2, r2, f2 = walk_stats(P, target=8)
assert np.isclose(m2, P[:, -1].mean()) and np.isclose(r2, np.sqrt((P[:, -1].astype(float) ** 2).mean())), "walk_stats gives the wrong mean or RMS on random walks."
assert np.isclose(f2, (P.max(axis=1) >= 8).mean()), "walk_stats gives the wrong frac_reached on random walks. Respect the `target` argument."
--- hint
The final positions are the last *column*: `positions[:, -1]`. Means and RMS of that 1-D array are single numbers.
--- hint
A walk "ever reaches" the target when its **maximum** over time is at least `target`: `positions.max(axis=1) >= target` gives one boolean per walk, and its `.mean()` is the fraction.
```

> **In the wild:** these exact patterns (shifted-array stencils, batched random sampling, `cumsum` along an axis) power real scientific code: image filters and fluid simulations use roll-and-add stencils, reinforcement learning computes discounted returns with cumulative sums, and Monte Carlo dropout and bootstrapping are batched sampling.

## Recap

- Vectorized simulations update **every** cell, dart or walker at once; loops shrink to a handful of passes over whole arrays.
- `np.roll` plus addition counts neighbors on a wrapping grid; boolean masks with parenthesized `&` / `|` express the rules.
- Monte Carlo estimates converge like $1/\sqrt{n}$, and random walks spread like $\sqrt{t}$.
- `cumsum(axis=1)` turns a batch of steps into a batch of trajectories, and per-row reductions such as `max(axis=1)` summarize them.

**Congratulations!** You''ve completed every project in NumPy Mastery. You can now read, write and debug the array code behind pandas, scikit-learn and PyTorch. Take the final exam to earn your certificate.
', 0, '[]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z'),
('les_numpy_8_4', 'sec_numpy_8', 'crs_numpy_mastery', 'Final exam: NumPy Mastery', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"What does np.zeros((4, 3, 2)).ndim return?","options":["2","3","24","(4, 3, 2)"],"answerIndex":1,"explanation":"ndim is the number of dimensions (axes). The shape (4, 3, 2) has three entries, so ndim is 3. 24 is .size, and (4, 3, 2) is .shape."},{"id":"q2","prompt":"Which is the recommended way to generate reproducible random numbers in modern NumPy?","options":["np.random.seed(42) followed by np.random.rand(...)","rng = np.random.default_rng(42) and then methods such as rng.normal(...)","import random; random.seed(42)","Random numbers in NumPy cannot be made reproducible"],"answerIndex":1,"explanation":"default_rng creates an independent Generator with a better algorithm (PCG64) and no hidden global state. The legacy np.random.seed API still works but is discouraged, and Python''s random module doesn''t seed NumPy at all."},{"id":"q3","prompt":"After a = np.arange(5), b = a[1:3] and b[0] = 99, what is a?","options":["[0 1 2 3 4]","[99 1 2 3 4]","[0 99 2 3 4]","An error, because slices are read-only"],"answerIndex":2,"explanation":"Basic slicing returns a **view** that shares memory with the original. Writing to b[0] writes to a[1]. Use a[1:3].copy() when you need independent data."},{"id":"q4","prompt":"Which expression selects the elements of a that are greater than 2 **and** less than 6?","options":["a[a > 2 and a < 6]","a[(a > 2) & (a < 6)]","a[2 < a < 6]","a[a > 2 & a < 6]"],"answerIndex":1,"explanation":"Element-wise logic needs &, and each comparison needs parentheses because & binds more tightly than >. and and chained comparisons ask for a single True/False and raise \"truth value of an array is ambiguous\"."},{"id":"q5","prompt":"What is the shape of np.arange(12).reshape(3, -1)?","options":["(3, -1)","(3, 4)","(4, 3)","(3, 12)"],"answerIndex":1,"explanation":"-1 tells NumPy to infer that dimension from the total size: 12 elements in 3 rows leaves 4 columns."},{"id":"q6","prompt":"Which of these always returns a **copy** rather than a view of a?","options":["a[1:4]","a[:, 0]","a[[1, 2, 3]] (fancy indexing with a list)","a.T"],"answerIndex":2,"explanation":"Indexing with an integer array or list (fancy indexing) gathers arbitrary elements into new memory, so it always copies. Slices, single-column selection with a slice, and transposes are views."},{"id":"q7","prompt":"What is the shape of np.ones((5, 1)) + np.ones((1, 4))?","options":["(5, 4)","(5, 1)","(1, 4)","It raises a broadcasting error"],"answerIndex":0,"explanation":"Broadcasting compares dimensions from the right: 1 vs 4 gives 4, and 5 vs 1 gives 5. Each size-1 axis is stretched, giving (5, 4). This is the trick behind outer products and pairwise distance tables."},{"id":"q8","prompt":"Which pair of shapes **cannot** be broadcast together?","options":["(3, 4) and (4,)","(3, 4) and (3,)","(3, 1) and (1, 4)","(2, 3, 4) and (3, 1)"],"answerIndex":1,"explanation":"Shapes align from the **right**, so (3,) is compared with the trailing 4 of (3, 4), and 3 ≠ 4. To add a per-row value, reshape it to (3, 1), for example v[:, None]."},{"id":"q9","prompt":"X has shape (100, 5): 100 samples, 5 features. What is the shape of X.mean(axis=0)?","options":["(100,)","(5,)","(100, 5)","(), a single number"],"answerIndex":1,"explanation":"The axis you pass is the one that disappears. Averaging over axis=0 (the samples) leaves one mean per feature: shape (5,)."},{"id":"q10","prompt":"Why is keepdims=True useful in X - X.mean(axis=1, keepdims=True) when X has shape (100, 5)?","options":["It makes the mean more numerically accurate","It keeps the result shaped (100, 1), so it broadcasts to subtract each row''s own mean","It prevents X from being modified in place","Without it, NumPy would average over every element"],"answerIndex":1,"explanation":"Without keepdims the row means have shape (100,), which aligns with the trailing axis of length 5 and fails to broadcast. Keeping the reduced axis as size 1 gives (100, 1), which lines up row by row."},{"id":"q11","prompt":"For a float array a that may contain missing values, which expression correctly counts the NaNs?","options":["(a == np.nan).sum()","np.isnan(a).sum()","np.nansum(a)","(a is np.nan).sum()"],"answerIndex":1,"explanation":"NaN is not equal to anything, not even itself, so a == np.nan is always False and counts 0. np.isnan tests each element properly. np.nansum adds up the non-NaN values instead of counting NaNs."},{"id":"q12","prompt":"With A of shape (3, 4) and B of shape (4, 2), what does np.einsum(''ij,jk->ik'', A, B) compute?","options":["The element-wise product, shape (3, 4)","The matrix product A @ B, shape (3, 2)","The outer product, shape (3, 4, 4, 2)","The sum of all elements of A times all elements of B"],"answerIndex":1,"explanation":"The repeated index j is summed over, and ik is kept: C[i, k] = sum over j of A[i, j] * B[j, k]. That is exactly matrix multiplication."},{"id":"q13","prompt":"To solve the linear system Ax = b, why prefer np.linalg.solve(A, b) over np.linalg.inv(A) @ b?","options":["inv only works on 2×2 matrices","solve is faster and more numerically accurate because it never forms the inverse","solve returns an approximate answer, which is usually good enough","They are identical; it''s purely a matter of style"],"answerIndex":1,"explanation":"solve factorizes A and back-substitutes, which takes less work and loses less precision than computing a full inverse and then multiplying. Explicit inverses are rarely needed in numerical code."},{"id":"q14","prompt":"You train linear regression with gradient descent on raw features whose values range from about 0.1 to 50. The loss grows to inf within a few epochs. What is the most likely cause, and the standard fix?","options":["Too few epochs: train for longer","The learning rate is too large for the steepest feature: standardize the features (or lower the learning rate)","The bias term is missing: add a column of ones","Gradient descent cannot fit linear models: always use np.linalg.lstsq"],"answerIndex":1,"explanation":"Large-valued features make the loss surface very steep along their weights, so a learning rate that is fine for the others overshoots and diverges. Standardizing to mean 0 and std 1 puts every weight on the same scale so one learning rate suits them all."},{"id":"q15","prompt":"a = np.zeros((1000, 1000)) is a C-contiguous float64 array. What is a.strides, and what does it mean?","options":["(8, 8000): stepping to the next row skips 8 bytes","(8000, 8): the next row is 8,000 bytes away, the next column 8 bytes away","(1000, 1): strides are counted in elements","(1, 1000): columns are stored contiguously"],"answerIndex":1,"explanation":"Strides are in **bytes**. In row-major (C) order a row holds 1000 × 8 bytes, so moving one row skips 8,000 bytes while moving one column skips a single 8-byte float. That''s why iterating along the last axis is the cache-friendly direction, and why a.T can be a free view: it just swaps the strides."}]', '[]', '2026-06-24T11:38:55.077Z', '2026-10-18T11:38:55.077Z');

INSERT INTO path_courses (path_id, course_id, position) VALUES
('pth_ml_engineer', 'crs_numpy_mastery', 1);

INSERT INTO enrollments (id, user_id, course_id, source, progress_percent, last_lesson_id, last_activity_at, completed_at, created_at) VALUES
('enr_crs_numpy_mastery_demo', 'usr_student', 'crs_numpy_mastery', 'purchase', 11, 'les_numpy_2_1', '2026-10-19T11:38:55.077Z', NULL, '2026-08-23T11:38:55.077Z');

INSERT INTO lesson_progress (user_id, lesson_id, course_id, completed, position_seconds, completed_at, updated_at) VALUES
('usr_student', 'les_numpy_1_1', 'crs_numpy_mastery', 1, 0, '2026-09-02T11:38:55.077Z', '2026-09-02T11:38:55.077Z'),
('usr_student', 'les_numpy_1_2', 'crs_numpy_mastery', 1, 0, '2026-09-03T11:38:55.077Z', '2026-09-03T11:38:55.077Z'),
('usr_student', 'les_numpy_1_3', 'crs_numpy_mastery', 1, 0, '2026-09-04T11:38:55.077Z', '2026-09-04T11:38:55.077Z'),
('usr_student', 'les_numpy_1_4', 'crs_numpy_mastery', 1, 0, '2026-09-05T11:38:55.077Z', '2026-09-05T11:38:55.077Z');

INSERT INTO exercise_progress (user_id, lesson_id, cell_id, code, passed, attempts, solved_at, updated_at) VALUES
('usr_student', 'les_numpy_1_1', 'first-challenge', 'scores = np.array([88, 92, 79, 95, 84])

best = scores.max()
average = scores.mean()', 1, 2, '2026-09-02T11:38:55.077Z', '2026-09-02T11:38:55.077Z'),
('usr_student', 'les_numpy_1_1', 'first-bug', 'order = np.array([12.5, 8.0, 3.25])

total = order.sum()
print("Order total:", total)', 1, 2, '2026-09-02T11:38:55.077Z', '2026-09-02T11:38:55.077Z'),
('usr_student', 'les_numpy_1_2', 'price-with-tax', 'prices = [19.99, 5.49, 120.00, 42.50]

prices_arr = np.array(prices)
with_tax = prices_arr * 1.2', 1, 2, '2026-09-03T11:38:55.077Z', '2026-09-03T11:38:55.077Z'),
('usr_student', 'les_numpy_1_2', 'list-math-bug', 'sensor_a = np.array([1.5, 2.0, 2.5, 3.0])
sensor_b = np.array([0.5, 0.5, 1.0, 1.0])

total = sensor_a + sensor_b
print("total:", total)', 1, 2, '2026-09-03T11:38:55.077Z', '2026-09-03T11:38:55.077Z'),
('usr_student', 'les_numpy_1_2', 'celsius-to-fahrenheit', 'celsius = [12.0, 15.5, 18.0, 21.5, 19.0, 16.5, 14.0]

fahrenheit = np.array(celsius) * 9 / 5 + 32', 1, 2, '2026-09-03T11:38:55.077Z', '2026-09-03T11:38:55.077Z'),
('usr_student', 'les_numpy_1_2', 'append-in-loop-bug', 'readings = [3, 1, 4, 1, 5, 9, 2, 6]

squares = np.array(readings) ** 2

print("squares:", squares)', 1, 2, '2026-09-03T11:38:55.077Z', '2026-09-03T11:38:55.077Z'),
('usr_student', 'les_numpy_1_3', 'sales-table', 'sales = np.array([
    [120, 135, 150, 170],
    [90, 95, 110, 105],
    [60, 80, 75, 95],
])
n_stores = sales.shape[0]
n_quarters = sales.shape[1]', 1, 2, '2026-09-04T11:38:55.077Z', '2026-09-04T11:38:55.077Z'),
('usr_student', 'les_numpy_1_3', 'compact-dtype', 'levels = [12, 250, 7, 99, 180, 3, 64]

wide = np.array(levels, dtype=np.int64)
compact = np.array(levels, dtype=np.uint8)
saved = wide.nbytes - compact.nbytes', 1, 2, '2026-09-04T11:38:55.077Z', '2026-09-04T11:38:55.077Z'),
('usr_student', 'les_numpy_1_3', 'describe-array', 'def describe(arr):
    return f"{arr.ndim}-D array, shape {arr.shape}, {arr.size} elements of {arr.dtype}"

print(describe(np.array([[1.0, 2.0], [3.0, 4.0]])))', 1, 2, '2026-09-04T11:38:55.077Z', '2026-09-04T11:38:55.077Z'),
('usr_student', 'les_numpy_1_3', 'nested-brackets-bug', 'matrix = np.array([[1, 2, 3], [4, 5, 6]])
print(matrix.shape)', 1, 2, '2026-09-04T11:38:55.077Z', '2026-09-04T11:38:55.077Z'),
('usr_student', 'les_numpy_1_3', 'string-numbers-bug', 'raw = ["3.5", "4.0", "2.5", "5.0"]

values = np.array(raw, dtype=float)
average = values.mean()
print("average:", average)', 1, 2, '2026-09-04T11:38:55.077Z', '2026-09-04T11:38:55.077Z');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_numpy_mastery_1', 'usr_seed000007', 'crs_numpy_mastery', 5, 'Clear explanations', 'The visual explanations of difficult concepts are the best I''ve seen. Code is clean and modern. Updated content too, which matters a lot in this field.', '2026-07-31T01:38:55.077Z', '2026-07-31T01:38:55.077Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000007');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_numpy_mastery_2', 'usr_seed00000k', 'crs_numpy_mastery', 4, 'Dense but fantastic', 'This is not a fluffy overview — it goes deep. Expect to pause and re-watch, but the payoff is real. The instructor clearly knows the material at a research level.', '2026-08-12T18:38:55.077Z', '2026-08-12T18:38:55.077Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000k');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_numpy_mastery_3', 'usr_seed000011', 'crs_numpy_mastery', 5, 'Dense but fantastic', 'This is not a fluffy overview — it goes deep. Expect to pause and re-watch, but the payoff is real. The instructor clearly knows the material at a research level.', '2026-10-20T12:38:55.077Z', '2026-10-20T12:38:55.077Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000011');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_numpy_mastery_4', 'usr_seed00001j', 'crs_numpy_mastery', 5, 'Exceptional production quality', 'Beautifully structured. The quizzes caught gaps in my understanding and the AI tutor was surprisingly helpful when I got stuck on the harder sections.', '2026-08-03T03:38:55.077Z', '2026-08-03T03:38:55.077Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001j');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_numpy_mastery_5', 'usr_seed000021', 'crs_numpy_mastery', 5, 'Best course I''ve taken on the topic', 'The explanations build intuition before the math, and every concept is backed by code you actually run. I finally understand what''s happening under the hood instead of copying snippets.', '2026-10-14T22:38:55.077Z', '2026-10-14T22:38:55.077Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000021');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_numpy_mastery_6', 'usr_seed00002b', 'crs_numpy_mastery', 5, 'Dense but fantastic', 'This is not a fluffy overview — it goes deep. Expect to pause and re-watch, but the payoff is real. The instructor clearly knows the material at a research level.', '2026-09-26T01:38:55.077Z', '2026-09-26T01:38:55.077Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002b');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_numpy_mastery_7', 'usr_seed00003k', 'crs_numpy_mastery', 5, 'Finally clicked', 'I''d tried learning this from scattered blog posts and papers. Having a single coherent narrative with good visuals made it click. The capstone tied everything together.', '2026-10-16T09:38:55.077Z', '2026-10-16T09:38:55.077Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00003k');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_numpy_mastery_8', 'usr_seed00003m', 'crs_numpy_mastery', 4, 'Clear explanations', 'The visual explanations of difficult concepts are the best I''ve seen. Code is clean and modern. Updated content too, which matters a lot in this field.', '2026-09-23T18:38:55.077Z', '2026-09-23T18:38:55.077Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00003m');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_numpy_mastery_9', 'usr_seed00003p', 'crs_numpy_mastery', 4, 'Clear explanations', 'The visual explanations of difficult concepts are the best I''ve seen. Code is clean and modern. Updated content too, which matters a lot in this field.', '2026-08-31T09:38:55.077Z', '2026-08-31T09:38:55.077Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00003p');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_numpy_mastery_10', 'usr_seed00004e', 'crs_numpy_mastery', 4, 'Solid and practical', 'Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I''d take another course from this instructor.', '2026-08-15T16:38:55.077Z', '2026-08-15T16:38:55.077Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00004e');

UPDATE courses SET rating_avg = coalesce((SELECT avg(rating) FROM reviews WHERE course_id = 'crs_numpy_mastery'), 0), rating_count = (SELECT count(*) FROM reviews WHERE course_id = 'crs_numpy_mastery') WHERE id = 'crs_numpy_mastery';
