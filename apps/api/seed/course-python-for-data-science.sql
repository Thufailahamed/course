DELETE FROM exercise_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_python_for_data_science');

DELETE FROM quiz_attempts WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_python_for_data_science');

DELETE FROM notes WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_python_for_data_science');

DELETE FROM lesson_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_python_for_data_science');

DELETE FROM discussions WHERE course_id = 'crs_python_for_data_science';

DELETE FROM certificates WHERE course_id = 'crs_python_for_data_science';

DELETE FROM enrollments WHERE course_id = 'crs_python_for_data_science';

DELETE FROM reviews WHERE course_id = 'crs_python_for_data_science';

DELETE FROM wishlist WHERE course_id = 'crs_python_for_data_science';

DELETE FROM path_courses WHERE course_id = 'crs_python_for_data_science';

DELETE FROM coupons WHERE course_id = 'crs_python_for_data_science';

DELETE FROM lessons WHERE course_id = 'crs_python_for_data_science';

DELETE FROM sections WHERE course_id = 'crs_python_for_data_science';

UPDATE order_items SET course_id = NULL WHERE course_id = 'crs_python_for_data_science';

DELETE FROM courses WHERE id = 'crs_python_for_data_science';

INSERT OR IGNORE INTO categories (id, slug, name, description, icon, sort_order) VALUES ('cat_data-science', 'data-science', 'Data Science', 'Python, pandas, visualization and experimentation.', 'bar-chart', 8);

INSERT INTO courses (id, slug, title, subtitle, description, category_id, instructor_id, level, language, price_cents, compare_at_price_cents, currency, thumbnail_key, preview_video_url, accent, status, featured, what_you_learn, requirements, target_audience, tags, duration_minutes, lessons_count, rating_avg, rating_count, students_count, published_at, created_at, updated_at) VALUES
('crs_python_for_data_science', 'python-for-data-science', 'Python for Data Science', 'NumPy, pandas, visualization and analysis — the foundation for everything in ML.', 'Most data-science courses show you a finished notebook and ask you to believe it. This one hands you the keyboard: **every lesson is a live coding environment** with Python, pandas, NumPy and matplotlib running inside your browser.

## Learn by doing, not by watching

- **Ten hands-on lessons, one checkpoint quiz.** Every concept is followed by runnable code you can edit and break.
- **30 auto-checked challenges.** Hidden tests check behaviour, not one specific answer, and progressive hints meet you where you''re stuck.
- **Debug challenges.** Real analyst bugs — a string column that should be numeric, a merge that duplicates rows, a broadcast that silently subtracts from the wrong axis — that you track down and fix.
- **Predict-the-output questions** train you to read code before you run it.
- **A real step-through debugger.** Watch variables change line by line instead of guessing.
- **Atlas, your AI tutor,** explains any error in plain language without spoiling the exercise.

## From first variable to first insight

You''ll start with the Python primitives that every DataFrame column is built from, then move through NumPy arrays, pandas tables, grouping, joins and reshaping, and finish by running a complete exploratory analysis on a messy subscription dataset and defending your conclusions with charts.

## Built for what comes next

NumPy and pandas are the substrate under scikit-learn, PyTorch, Jupyter, BI tools and almost every production ML pipeline. The habits you build here — vectorize, inspect shapes, validate joins, plot the distribution before modelling — will stay useful long after this course ends.', 'cat_data-science', 'usr_arjun', 'beginner', 'English', 0, NULL, 'USD', NULL, NULL, 210, 'published', 0, '["Write clean, idiomatic Python for real data work — types, control flow, functions and comprehensions","Think in arrays: index, slice, reshape and broadcast NumPy data without loops","Load, clean, filter, group, join and reshape tables with pandas","Choose the right chart and build clear, publication-ready visualizations with matplotlib","Run a complete exploratory analysis, from a messy CSV to written, evidence-backed conclusions","Read shape, dtype, merge and missing-value errors, then fix them with a real debugger"]', '["No data-science experience required — we start with the Python you need","A modern browser. Python, pandas, NumPy and matplotlib run inside the page; nothing to install"]', '["Complete beginners moving from spreadsheets to code","Analysts who want to turn one-off Excel work into repeatable Python","Students preparing for machine learning, statistics or a data role","Developers who know Python but want practical NumPy, pandas and EDA fluency"]', '["Python","pandas","NumPy","Matplotlib","Interactive","Data Analysis","Free"]', 152, 11, 0, 0, 88420, '2025-11-18T06:08:01.943Z', '2025-10-19T06:08:01.943Z', '2026-10-20T06:08:01.943Z');

INSERT INTO sections (id, course_id, title, position, created_at) VALUES
('sec_python_for_data_science_1', 'crs_python_for_data_science', 'Python Essentials', 0, '2026-06-25T06:08:01.943Z'),
('sec_python_for_data_science_2', 'crs_python_for_data_science', 'NumPy', 1, '2026-06-25T06:08:01.943Z'),
('sec_python_for_data_science_3', 'crs_python_for_data_science', 'pandas', 2, '2026-06-25T06:08:01.943Z'),
('sec_python_for_data_science_4', 'crs_python_for_data_science', 'Visualization & EDA', 3, '2026-06-25T06:08:01.943Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_python_for_data_science_1_1', 'sec_python_for_data_science_1', 'crs_python_for_data_science', 'Welcome: how this course works', 'interactive', 0, 480, NULL, NULL, '# Welcome: how this course works

You are about to do data science the way it is actually done: in a notebook, with real code, making mistakes and fixing them. This page is the orientation. In the next ten minutes you''ll run your first pandas table, learn the four moves every lesson uses, and finish with a checked challenge and a realistic bug.

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

A DataFrame is a table with named columns. The value of the last expression is displayed, so you don''t need `print` just to inspect something.

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
| **Debug** | Fix code that already runs but is wrong | Learn the failure modes you''ll meet at work |
| **Predict** | Commit to an answer *before* running | Read code like an analyst, not a spectator |

> **Tip:** Predict first, then run. Being wrong is useful; it shows you exactly which mental model needs updating.

Challenges run in a **fresh** namespace, so they can''t peek at variables from the examples above. A challenge that needs a table must define that table in the starter code — just like a function should not depend on a global it doesn''t own.

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
assert len(hours) == 4, "Use all four values in `hours`; don''t hard-code a smaller subset."
--- hint
`hours` is a pandas Series. It knows how to compute its own mean.
--- hint
Call `hours.mean()` and assign the result to `average`.
```

## Your first debug

This one already runs. That is the dangerous kind. The loop adds a price and a quantity instead of multiplying them, so the reported revenue is nonsense but looks plausible.

Run it, read the output, then fix the operator. Keep the loop and the `zip`.

```python debug id=revenue-miscalculation title="Revenue that doesn''t add up"
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

**Up next:** you''ll build the Python foundation every pandas operation rests on — variables, types, conditions and loops — using a messy orders dataset.
', 1, '[]', '[{"title":"pandas: 10 minutes to pandas","url":"https://pandas.pydata.org/docs/user_guide/10min.html"},{"title":"NumPy: the absolute basics for beginners","url":"https://numpy.org/doc/stable/user/absolute_beginners.html"},{"title":"Matplotlib: anatomy of a figure","url":"https://matplotlib.org/stable/users/explain/figure/figure_intro.html"}]', '2026-06-25T06:08:01.943Z', '2026-10-19T06:08:01.943Z'),
('les_python_for_data_science_1_2', 'sec_python_for_data_science_1', 'crs_python_for_data_science', 'Variables, types and control flow', 'interactive', 1, 960, NULL, NULL, '# Variables, types and control flow

Every pandas column is a sequence of values of one type, and almost every cleaning rule is a condition: *if the quantity is missing, set it to zero; if the customer is a member, waive shipping; if the price is a string, convert it.* Before you can manipulate a table, you need to be fluent with the single values inside it.

This lesson uses a small orders workflow to cover the Python you will use constantly: variables, numbers, strings, booleans, `None`, `if`/`elif`/`else`, and loops that accumulate a result.

## Names for values

A variable is a name bound to a value. Python infers the type from the value; you don''t declare it.

```python run
order_id = "ORD-1042"
units = 3
unit_price = 24.99
gift = False
note = None

subtotal = units * unit_price

print(type(order_id).__name__, type(units).__name__, type(unit_price).__name__)
print(f"Order {order_id}: {units} x ${unit_price:.2f} = ${subtotal:.2f}")
print("gift:", gift, "| note:", note)
```

The `f` before the string makes it an **f-string**: anything inside braces is evaluated, and `:.2f` formats a number with two decimal places. `None` is Python''s "no value here" — not zero, not an empty string. It is how a missing cell often arrives from a database.

> **Pitfall:** `unit_price = "24.99"` looks almost identical but is text. `units * unit_price` would then repeat the *string* three times instead of multiplying numbers. `type()` is your cheapest diagnostic.

## Strings are data too

Real text arrives with stray spaces and inconsistent capitalisation. String methods return a **new** string; they do not modify the original.

```python run
raw_city = "  lisbon "
city = raw_city.strip().title()

raw_email = "  ADA@Example.COM "
email = raw_email.strip().lower()

print(f"city={city!r}  email={email!r}")
print("starts with Lis:", city.startswith("Lis"))
print("has @:", "@" in email)
```

`strip()` removes whitespace from both ends, `title()` capitalises each word, and `lower()` normalises case. The `!r` in the f-string shows quotes around the value, which makes invisible spaces obvious.

## Decisions

Conditions produce booleans. `if` runs a block only when its condition is true; `elif` and `else` handle the alternatives. Python uses indentation, not braces, to define blocks.

```python run
order_total = 82.50
country = "Portugal"
member = False

if member or order_total >= 75:
    shipping = 0.0
elif order_total >= 50:
    shipping = 4.95
else:
    shipping = 9.95

print(f"shipping: ${shipping:.2f}")
print(f"order total: ${order_total + shipping:.2f}")
```

Read the first condition as "a member, **or** a basket of at least 75". `or` short-circuits: if `member` is true, Python never evaluates the second half. Use `and` when both conditions must hold.

> **Pitfall:** `=` assigns; `==` compares. `if total = 100` is a syntax error, and `if total == "100"` compares a number to a string — they are never equal.

## Loops that accumulate

A `for` loop walks through an iterable. When each item is a tuple, you can unpack it into named variables. This is the pattern behind many calculations that later become a single pandas expression.

```python run
orders = [
    ("A-1", 2, 19.99),
    ("A-2", 1, 5.50),
    ("A-3", 4, 3.25),
]

total = 0
for order_id, quantity, price in orders:
    line_total = quantity * price
    total += line_total
    print(f"{order_id}: ${line_total:.2f}")

print(f"TOTAL: ${total:.2f}")
```

`total += line_total` is shorthand for `total = total + line_total`. The accumulator must start at `0`; starting at `1` silently adds a phantom dollar.

## Your turn: a receipt

The quantity arrives as text from a form. Convert it, calculate the subtotal, apply a percentage discount, and store the final total in `total`.

```python exercise id=receipt-total title="Clean a receipt"
raw_units = "3"
unit_price = 24.99
discount_pct = 10

# TODO: convert raw_units to an int and compute the three amounts.
units = ...
subtotal = ...
discount = ...
total = ...
--- solution
raw_units = "3"
unit_price = 24.99
discount_pct = 10

units = int(raw_units)
subtotal = units * unit_price
discount = subtotal * discount_pct / 100
total = subtotal - discount
--- test
assert units is not ..., "Replace the `...` after `units =`."
assert isinstance(units, int), f"`units` should be an int, but it is {type(units).__name__}. Convert the string with int()."
assert units == 3, f"`units` should be 3, but it is {units!r}."
assert abs(subtotal - 74.97) < 1e-9, f"`subtotal` should be 74.97, but it is {subtotal!r}."
assert abs(discount - 7.497) < 1e-9, f"`discount` should be 7.497 (10% of 74.97), but it is {discount!r}."
assert abs(total - 67.473) < 1e-9, f"`total` should be 67.473, but it is {total!r}. Subtract the discount from the subtotal."
--- hint
`int("3")` gives the number 3. `"3" * 24.99` would be a very different (and very wrong) operation.
--- hint
`subtotal = units * unit_price`. A percentage is divided by 100: `discount = subtotal * discount_pct / 100`.
```

## Accumulate the order book

Finish the loop so each line total is multiplied out and added to `total`. The printed lines should be `39.98`, `5.50`, `13.00`, then `TOTAL: 58.48`.

```python exercise id=order-book-total title="Total the order book"
orders = [
    ("A-1", 2, 19.99),
    ("A-2", 1, 5.50),
    ("A-3", 4, 3.25),
]

total = 0
for order_id, quantity, price in orders:
    line_total = ...
    total += ...
    print(f"{order_id}: ${line_total:.2f}")

print(f"TOTAL: ${total:.2f}")
--- solution
orders = [
    ("A-1", 2, 19.99),
    ("A-2", 1, 5.50),
    ("A-3", 4, 3.25),
]

total = 0
for order_id, quantity, price in orders:
    line_total = quantity * price
    total += line_total
    print(f"{order_id}: ${line_total:.2f}")

print(f"TOTAL: ${total:.2f}")
--- test
assert abs(total - 58.48) < 1e-9, f"`total` should be 58.48, but it is {total!r}. Did you add the line total, not the price?"
assert "TOTAL: $58.48" in _stdout, f"The final line should read `TOTAL: $58.48`. Output was:\n{_stdout.strip()}"
assert "A-2: $5.50" in _stdout, "The second line should be `A-2: $5.50`; print the calculated line total, not the unit price."
--- hint
Inside the loop, `line_total` should be `quantity * price`, and `total` should grow by `line_total` each time.
--- hint
Start `total` at `0` before the loop, then use `total += line_total` in the body.
```

## A membership rule that is almost right

This shipping rule runs, but it charges a member. Read the condition carefully, then fix the boolean logic. The intended rule is: **free if the customer is a member or the subtotal is at least 75**.

```python debug id=member-shipping title="The member paid for shipping"
subtotal = 61.00
member = True

if subtotal >= 75 and member:
    shipping = 0.0
else:
    shipping = 4.95

print(f"shipping: ${shipping:.2f}")
--- solution
subtotal = 61.00
member = True

if subtotal >= 75 or member:
    shipping = 0.0
else:
    shipping = 4.95

print(f"shipping: ${shipping:.2f}")
--- test
assert shipping == 0.0, f"`shipping` should be 0.0 because the customer is a member, but it is {shipping!r}."
assert "shipping: $0.00" in _stdout, f"The printed result should be `shipping: $0.00`, but the output was {_stdout.strip()!r}."
--- hint
A member should get free shipping even when the subtotal is below 75. Which operator should connect the two conditions?
--- hint
Use `or`: free if `subtotal >= 75` **or** `member` is true.
```

## Predict the arithmetic

```python predict id=predict-operators title="Integer vs float arithmetic"
print(2 ** 3, 9 // 2, 9 % 2)
--- options
6 4.5 1
* 8 4 1
8 4.5 1
9 4 2
--- explain
`**` is exponentiation (2³ = 8), `//` is floor division (9 ÷ 2 = 4.5, rounded down to 4), and `%` is the remainder (9 − 8 = 1). Use `/` when you want the decimal result.
```

## Recap

- Variables are names bound to values; `type()` reveals what kind of value you actually have.
- Strings have methods (`strip`, `lower`, `title`) and support membership tests like `"@" in email`.
- `if`/`elif`/`else` choose a path. Use `or` when either condition is enough, `and` when both must hold.
- A loop plus an accumulator (`total += ...`) computes a result across many rows.
- `None` means missing, not zero; converting text to numbers is a deliberate step, not something Python guesses.

**Up next:** you''ll package these rules into reusable functions and replace loop boilerplate with comprehensions.
', 1, '[]', '[]', '2026-06-25T06:08:01.943Z', '2026-10-19T06:08:01.943Z'),
('les_python_for_data_science_1_3', 'sec_python_for_data_science_1', 'crs_python_for_data_science', 'Functions and comprehensions', 'interactive', 2, 840, NULL, NULL, '# Functions and comprehensions

Data work is full of rules you apply more than once: clean an email, apply a discount, split a name, format a price. Pasting the same five lines into ten cells is how notebooks rot. A **function** gives a rule a name, a clear input, and a return value. A **comprehension** expresses a whole transformation in one readable line.

By the end of this lesson you''ll package a pricing rule into a function, clean a list of email addresses, and recognise the difference between printing a result and returning it.

## A function is a named rule

```python run
def revenue(quantity, unit_price, discount_pct=0.0):
    """Return revenue after an optional percentage discount."""
    subtotal = quantity * unit_price
    return round(subtotal * (1 - discount_pct / 100), 2)


print(revenue(2, 19.99))
print(revenue(2, 19.99, 10))
print(revenue(quantity=5, unit_price=3.25, discount_pct=25))
```

The `def` line names the function and its **parameters**. `discount_pct=0.0` is a default, so callers can omit it. `return` sends a value back to the caller; without it, a function returns `None`.

Arguments can be passed by position or by name. Keyword arguments make a call self-documenting, especially when two numbers could easily be swapped.

> **Tip:** Keep functions small and give them one job. `revenue` calculates money; it does not print, save a file or update a dashboard. Pure functions are easy to test and reuse.

## Return more than one value

Python functions can return a tuple, which unpacks neatly:

```python run
def split_name(full_name):
    parts = full_name.strip().split(maxsplit=1)
    if len(parts) != 2:
        return parts[0], ""
    first, last = parts
    return first, last


first, last = split_name("  Ada Lovelace ")
print(f"{last}, {first}")
print(split_name("Prince"))
```

`maxsplit=1` means "split at most once", so a surname containing a space stays intact. Notice the early return for a single-word name: a good function handles the awkward input, not just the happy path.

## Comprehensions: a loop with a return value

A list comprehension builds a new list from an iterable. The expression before `for` is what goes into the result; the optional `if` filters items out.

```python run
raw_prices = ["$12.50", "$8.00", "n/a", "$5.25"]

prices = [float(value.replace("$", "")) for value in raw_prices if value.startswith("$")]

print(prices)
print("total:", sum(prices))
```

Read it left to right: *take each value, keep the ones that start with `$`, strip the dollar sign, convert to a float.* The original `raw_prices` is untouched.

A **dictionary comprehension** builds a lookup table. This is the shape of many joins and mappings you''ll meet in pandas.

```python run
products = [("A-1", 19.99), ("A-2", 5.50), ("A-3", 3.25)]

price_lookup = {sku: price for sku, price in products}
print(price_lookup)
print("most expensive:", max(price_lookup, key=price_lookup.get))
```

When the logic gets longer than one line, a normal `for` loop is usually clearer. Comprehensions are a tool, not a competition.

> **Pitfall:** A comprehension has its own scope in Python 3. The variable `value` does not leak into the surrounding code. If you need the count as well as the list, compute it separately or use a loop.

## Sorting with a key

`sorted` can sort anything if you tell it *what to compare*. A `lambda` is a tiny anonymous function, useful for exactly this.

```python run
rows = [("A-3", 13.00), ("A-1", 39.98), ("A-2", 5.50)]

by_value = sorted(rows, key=lambda row: row[1], reverse=True)
print(by_value)
```

`key=lambda row: row[1]` says "for each row, use the second element as the sort key." Without it, Python would compare the SKU strings first.

## Your turn: a reusable discount

Write `apply_discount(price, pct=10)` so it returns the price after removing `pct` percent, rounded to two decimals. The default must be 10.

```python exercise id=function-discount title="Write a reusable pricing rule"
def apply_discount(price, pct=10):
    # TODO: return the discounted price, rounded to 2 decimal places
    return ...


print(apply_discount(100, 20))
--- solution
def apply_discount(price, pct=10):
    return round(price * (1 - pct / 100), 2)


print(apply_discount(100, 20))
--- test
assert apply_discount(100, 20) == 80.0, f"apply_discount(100, 20) should be 80.0, but it returned {apply_discount(100, 20)!r}."
assert apply_discount(19.99) == 17.99, f"The default discount should be 10%: 19.99 becomes 17.99, but the function returned {apply_discount(19.99)!r}."
assert apply_discount(50, 0) == 50.0, "A 0% discount should leave the price unchanged."
assert apply_discount(50, 100) == 0.0, "A 100% discount should return 0.0."
assert isinstance(apply_discount(10), (int, float)), "Return a number, not a formatted string."
--- hint
A discount of `pct` percent leaves `(100 - pct) / 100` of the price. You can write that as `price * (1 - pct / 100)`.
--- hint
Wrap the calculation in `round(..., 2)` and put it after `return`.
```

## Your turn: clean a list of emails

Write `clean_emails(raw)` that strips whitespace, lowercases each address, keeps only entries containing `@`, removes duplicates, and returns the result sorted alphabetically. It must work for any input list, not just the sample.

```python exercise id=comprehension-emails title="Clean a list of emails"
def clean_emails(raw):
    # TODO: strip, lowercase, filter invalid entries, deduplicate, sort
    return ...


sample = ["  ADA@Example.com ", "ben@example.com", "not-an-email", " CHLOE@EXAMPLE.COM "]
print(clean_emails(sample))
--- solution
def clean_emails(raw):
    return sorted({email.strip().lower() for email in raw if email and "@" in email})


sample = ["  ADA@Example.com ", "ben@example.com", "not-an-email", " CHLOE@EXAMPLE.COM "]
print(clean_emails(sample))
--- test
assert clean_emails([" A@B.COM ", "bad", "a@b.com"]) == ["a@b.com"], "The function should lowercase, strip, filter entries without @, and remove duplicates."
assert clean_emails(["z@x.com", " a@b.com "]) == ["a@b.com", "z@x.com"], "The result should be sorted alphabetically."
assert clean_emails([]) == [], "An empty input should produce an empty list."
assert clean_emails(["no-at-sign", " also-bad "]) == [], "Entries without @ should be dropped."
--- hint
Use a set comprehension to remove duplicates while transforming: `{email.strip().lower() for email in raw if ...}`.
--- hint
Wrap the set in `sorted(...)`, and guard against empty or `None` entries with `if email and "@" in email`.
```

## The function that forgot to return

This function calculates the right number but the caller receives `None`, so the final `print` crashes. Run it, read the error, then fix the function. The calculation itself is correct.

```python debug id=missing-return title="The missing return"
def order_total(quantity, unit_price):
    subtotal = quantity * unit_price
    print(f"{subtotal:.2f}")


total = order_total(2, 19.99)
print(total + 1)
--- solution
def order_total(quantity, unit_price):
    subtotal = quantity * unit_price
    return subtotal


total = order_total(2, 19.99)
print(total + 1)
--- test
assert order_total(2, 19.99) == 39.98, f"order_total(2, 19.99) should return 39.98, but it returned {order_total(2, 19.99)!r}."
assert order_total(3, 5.50) == 16.5, f"order_total(3, 5.50) should return 16.5, but it returned {order_total(3, 5.50)!r}."
assert isinstance(order_total(1, 1), (int, float)), "Return the number, not a printed string."
--- hint
Run it. The error says you are adding `None` and `1`. Which function returned `None`?
--- hint
Replace the `print` inside the function with `return`. Keep the calculation.
```

## Predict the comprehension

```python predict id=predict-comprehension title="What survives the filter?"
print([x * 2 for x in range(5) if x % 2 == 1])
--- options
[0, 2, 4, 6, 8]
* [2, 6]
[1, 3]
[2, 4, 6, 8]
--- explain
`range(5)` is 0, 1, 2, 3, 4. The `if` keeps the odd values (1 and 3), and the expression doubles each one: 2 and 6. The filter runs before the expression.
```

## Recap

- `def` names a reusable rule; parameters are inputs and `return` is the output. A function without `return` gives back `None`.
- Defaults make optional behaviour explicit: `discount_pct=0.0`.
- List, set and dict comprehensions transform and filter in one expression; use a loop when the logic needs room.
- `sorted(..., key=lambda row: ...)` sorts by a computed key instead of the raw item.
- Returning a value is not the same as printing it. Tests call your function and inspect the return value.

**Up next:** you''ll leave single values behind and start thinking in arrays, where the same operation runs across thousands of rows at once.
', 0, '[]', '[]', '2026-06-25T06:08:01.943Z', '2026-10-19T06:08:01.943Z'),
('les_python_for_data_science_2_1', 'sec_python_for_data_science_2', 'crs_python_for_data_science', 'Arrays and broadcasting', 'interactive', 0, 1020, NULL, NULL, '# Arrays and broadcasting

A pandas column is built on a NumPy array, and a DataFrame is a collection of them. If you can picture an array''s **shape** and predict what happens when two shapes meet, pandas becomes much less mysterious — and a whole class of silent bugs disappears.

This lesson uses a small shop: three stores, four products, a price per product. You''ll index the grid, reduce it along each axis, and multiply every store by every price without writing a single loop.

## An array has a shape

```python run
import numpy as np

# rows = stores, columns = products
units = np.array([
    [10, 2, 0, 5],
    [3, 8, 1, 0],
    [7, 0, 4, 9],
])

print(units)
print("shape:", units.shape, "| ndim:", units.ndim, "| dtype:", units.dtype)
print("stores:", units.shape[0], "| products:", units.shape[1])
```

`shape` is a tuple, one number per axis. A 2-D array has rows then columns. `dtype` is the type shared by every element; here they are all integers, so NumPy chose a compact integer type.

> **Under the hood:** NumPy stores the values in one contiguous block plus a small amount of metadata (shape, strides, dtype). That is why operations over a million numbers can be fast: the loop happens in compiled code, not Python.

## Index and slice

Square brackets take one index per axis. A colon means "all of this axis". Negative indices count from the end.

```python run
print("store 0, product 2:", units[0, 2])
print("all stores, product 1:", units[:, 1])
print("store 1, all products:", units[1, :])
print("last row, last two products:", units[-1, -2:])
```

Boolean masks select by condition instead of position:

```python run
mask = units >= 5
print(mask)
print("values >= 5:", units[mask])
print("how many:", mask.sum())
```

`units >= 5` produces an array of `True`/`False` with the same shape. Using it as an index returns only the matching values, flattened into one dimension.

## Reduce along an axis

An aggregation removes an axis. `axis=1` collapses the columns and leaves one value per **row**; `axis=0` collapses the rows and leaves one value per **column**. The phrase to remember is *the axis you reduce disappears*.

```python run
print("units per store:", units.sum(axis=1))
print("units per product:", units.sum(axis=0))
print("mean units per product:", units.mean(axis=0).round(2))
```

The result of `units.sum(axis=1)` has shape `(3,)`: one total for each of the three stores. `axis=0` gives shape `(4,)`: one total for each product. If you are ever unsure, check the shape of the result.

## Broadcasting: different shapes, one operation

A price array with one value per product has shape `(4,)`. NumPy lines it up with the **last** axis of `units`, which is also length 4, and reuses the price for every store.

```python run
prices = np.array([2.50, 4.00, 10.00, 1.25])
revenue = units * prices

print("units:", units.shape, "| prices:", prices.shape, "-> revenue:", revenue.shape)
print(revenue)
```

No loop, no copied price matrix in your source. NumPy conceptually stretches `prices` down the rows. The rule is mechanical: align shapes from the right; dimensions are compatible when they are equal or one of them is 1.

A column vector is how you broadcast **per row**. `units.sum(axis=1)` has shape `(3,)`, but to divide each row by its own total you need shape `(3, 1)`.

```python run
row_totals = units.sum(axis=1, keepdims=True)
share = units / row_totals

print("row totals:", row_totals.shape)
print(share.round(2))
print("each row sums to:", share.sum(axis=1))
```

`keepdims=True` preserves the reduced axis as length 1, which is exactly the shape broadcasting needs. Without it, `(3, 4) / (3,)` raises because the lengths do not line up — but in a square matrix such as `(3, 3) / (3,)` the same mistake would silently divide across the wrong axis.

> **Pitfall:** A square matrix hides the `(n,)` vs `(n, 1)` bug. Always test a non-square example. If the shapes are compatible by accident, NumPy will happily return wrong numbers.

## Your turn: standardize exam scores

Standardizing means subtracting each **exam''s** mean and dividing by that exam''s standard deviation. Do it per column, so every exam ends with mean 0 and standard deviation 1.

```python exercise id=normalize-exams title="Standardize each exam"
import numpy as np

# rows = students, columns = exams
scores = np.array([
    [72.0, 85.0, 91.0],
    [88.0, 79.0, 94.0],
    [95.0, 92.0, 89.0],
    [61.0, 70.0, 78.0],
])

# TODO: compute one mean and std per exam (axis=0), then standardize.
exam_means = ...
exam_stds = ...
z = ...
--- solution
import numpy as np

scores = np.array([
    [72.0, 85.0, 91.0],
    [88.0, 79.0, 94.0],
    [95.0, 92.0, 89.0],
    [61.0, 70.0, 78.0],
])

exam_means = scores.mean(axis=0)
exam_stds = scores.std(axis=0)
z = (scores - exam_means) / exam_stds
--- test
assert exam_means is not ..., "Replace the `...` after `exam_means =`."
assert exam_means.shape == (3,), f"`exam_means` should have one value per exam, shape (3,), but has {exam_means.shape}."
assert np.allclose(exam_means, scores.mean(axis=0)), "Compute the mean down each column (axis=0), not across each student."
assert np.allclose(exam_stds, scores.std(axis=0)), "Compute the standard deviation down each column (axis=0)."
assert z.shape == scores.shape, f"`z` should keep the shape of `scores` (4, 3), but has {z.shape}."
assert np.allclose(z.mean(axis=0), 0), f"Each standardized exam should have mean 0, but the means are {z.mean(axis=0).round(3)}."
assert np.allclose(z.std(axis=0), 1), "Each standardized exam should have standard deviation 1."
--- hint
`axis=0` reduces the student axis and leaves one value per exam.
--- hint
Subtract `exam_means` from `scores`, then divide by `exam_stds`. Shapes `(4, 3) - (3,)` align on the last axis, which is exactly what you want here.
```

## Your turn: a price table

You have three base prices and four discount rates. Build a `(3, 4)` table where row `i`, column `j` is base price `i` after discount `j`. Use broadcasting, not loops.

```python exercise id=discount-table title="Every price at every discount"
import numpy as np

base = np.array([[10.0], [25.0], [40.0]])   # 3 products, one price each
discounts = np.array([0.0, 0.1, 0.25, 0.5])  # 4 discount rates

# TODO: use broadcasting to build a (3, 4) table.
price_table = ...
--- solution
import numpy as np

base = np.array([[10.0], [25.0], [40.0]])
discounts = np.array([0.0, 0.1, 0.25, 0.5])

price_table = base * (1 - discounts)
--- test
assert price_table is not ..., "Replace the `...` after `price_table =`."
assert price_table.shape == (3, 4), f"`price_table` should have shape (3, 4), but has {price_table.shape}."
expected = np.array([
    [10.0, 9.0, 7.5, 5.0],
    [25.0, 22.5, 18.75, 12.5],
    [40.0, 36.0, 30.0, 20.0],
])
assert np.allclose(price_table, expected), "Each row should be one product at all four discounts. Check the broadcasting direction."
--- hint
`base` has shape `(3, 1)` and `discounts` has shape `(4,)`. Align them from the right to get `(3, 4)`.
--- hint
Compute the fraction paid first: `1 - discounts` has shape `(4,)`. Multiply the column of prices by that row of fractions.
```

## The bug that hides in a square

Each row is one user''s ratings of three movies. We want to subtract each user''s own average from their ratings, so every row ends up averaging zero.

```python debug id=center-rows title="Rows that won''t center"
import numpy as np

ratings = np.array([
    [5.0, 4.0, 3.0],
    [2.0, 1.0, 3.0],
    [4.0, 4.0, 1.0],
])

user_avg = ratings.mean(axis=1)
centered = ratings - user_avg

print("row sums:", centered.sum(axis=1).round(2))
--- solution
import numpy as np

ratings = np.array([
    [5.0, 4.0, 3.0],
    [2.0, 1.0, 3.0],
    [4.0, 4.0, 1.0],
])

user_avg = ratings.mean(axis=1)
centered = ratings - user_avg[:, None]

print("row sums:", centered.sum(axis=1).round(2))
--- test
assert centered.shape == (3, 3), f"`centered` should keep the shape (3, 3), but has {centered.shape}."
assert np.allclose(centered.mean(axis=1), 0), f"Each row should average 0, but the row averages are {centered.mean(axis=1).round(3)}. Are you subtracting each user''s average from their own row?"
assert np.allclose(centered, ratings - ratings.mean(axis=1, keepdims=True)), "Subtract each user''s mean from every rating in that user''s row."
--- hint
Run it. There is no error, but the rows do not sum to zero. What shape is `user_avg`?
--- hint
`user_avg` is `(3,)`; broadcasting aligns it with the columns. Make it a column with `user_avg[:, None]` (or use `keepdims=True` when computing it).
```

## Predict the broadcast

```python predict id=predict-broadcast-shape title="Column meets row"
import numpy as np

print((np.ones((3, 1)) + np.ones(4)).shape)
--- options
(3, 1)
(4,)
* (3, 4)
Error: shapes don''t match
--- explain
Align from the right: `(3, 1)` becomes a column and `(4,)` a row. Since each pair has a 1, both stretch, producing a full `(3, 4)` table.
```

## Predict the reduction

```python predict id=predict-axis-sum title="Which axis disappears?"
import numpy as np

print(np.arange(6).reshape(2, 3).sum(axis=0))
--- options
[0 1 2]
* [3 5 7]
[3 12]
15
--- explain
The array is `[[0, 1, 2], [3, 4, 5]]`. `axis=0` collapses the rows, adding down each column: `[0+3, 1+4, 2+5]` = `[3, 5, 7]`. The result has shape `(3,)`.
```

## Recap

- `shape` is one number per axis; `axis=0` reduces rows and `axis=1` reduces columns.
- Boolean masks select by condition and return a flat array of matches.
- Broadcasting aligns shapes from the right; dimensions are compatible when equal or one is 1.
- `keepdims=True` and `[:, None]` turn a reduced axis back into a column for per-row arithmetic.
- Square shapes can hide a wrong-axis broadcast. Test a non-square case.

**Up next:** you''ll turn these array moves into fast, readable transformations and replace the last loops in your data pipeline.
', 0, '[]', '[]', '2026-06-25T06:08:01.943Z', '2026-10-19T06:08:01.943Z'),
('les_python_for_data_science_2_2', 'sec_python_for_data_science_2', 'crs_python_for_data_science', 'Vectorization in practice', 'interactive', 1, 720, NULL, NULL, '# Vectorization in practice

The first time you see NumPy code, it can look like magic: no loop, one line, and suddenly every row is transformed. It isn''t magic. It''s **vectorization** — expressing an operation on whole arrays so the loop moves into compiled code.

This lesson is about the practical payoff: fewer places to make an off-by-one error, clearer intent, and code that scales from ten rows to ten million. You''ll replace loop bodies with array expressions, use `np.where` for branching, and use `np.select` when there are more than two outcomes.

## The same calculation, two ways

```python run
import numpy as np

prices = np.array([19.99, 5.49, 102.00, 7.25])

taxed_loop = np.empty_like(prices)
for i, price in enumerate(prices):
    taxed_loop[i] = price * 1.2

taxed = prices * 1.2

print("same answer:", np.allclose(taxed_loop, taxed))
print(taxed.round(2))
```

The loop version has an index, a preallocated output, and a place to get the order wrong. The vectorized version says what it means: *multiply every price by 1.2*. On four values the speed difference is irrelevant; on a million rows it is not.

> **Under the hood:** Python loops execute one bytecode instruction at a time. A NumPy ufunc dispatches to a tight C loop over contiguous memory. The algorithm is the same; the interpreter overhead is gone.

## Functions that work element by element

NumPy''s **universal functions** (ufuncs) apply to every element and return a new array. `np.clip` is especially useful for cleaning implausible values without writing a conditional.

```python run
ages = np.array([12, 17, 24, 68, 81])

print("clipped to 18–65:", np.clip(ages, 18, 65))
print("square roots:", np.sqrt(np.array([1.0, 4.0, 9.0, 16.0])))
print("safe log:", np.log1p(np.array([0.0, 1.0, 9.0])))
```

`np.log1p(x)` computes `log(1 + x)` more accurately than `np.log(1 + x)` for tiny `x`. The names are worth knowing: `np.exp`, `np.log`, `np.sqrt`, `np.abs`, `np.round`, `np.clip`.

## Branching without a loop: `np.where`

`np.where(condition, value_if_true, value_if_false)` works element by element. The condition is an array; both result branches can be arrays too.

```python run
spend = np.array([10.0, 250.0, 80.0, 400.0, 30.0])

segment = np.where(spend >= 200, "high", "standard")
print(segment)

# A numeric version: keep 90% for high spenders, 100% for everyone else.
paid = np.where(spend >= 200, spend * 0.9, spend)
print(paid)
```

The condition and both branches must be broadcast-compatible. Here a scalar and an array combine cleanly.

## More than two outcomes: `np.select`

Nested `np.where` calls get unreadable quickly. `np.select` takes a list of conditions and a list of choices, evaluated in order, with a `default` for everything else.

```python run
scores = np.array([45, 62, 78, 91, 88])

grade = np.select(
    [scores >= 90, scores >= 80, scores >= 70],
    ["A", "B", "C"],
    default="F",
)
print(grade)
```

Order matters: the first matching condition wins. A score of 91 matches both `>= 90` and `>= 80`, and correctly becomes an A.

## Missing values are not zero

```python run
values = np.array([12.0, np.nan, 8.0, np.nan, 3.25])

print("is missing:", np.isnan(values))
print("mean ignoring missing:", np.nanmean(values))
print("filled with 0:", np.nan_to_num(values, nan=0.0))
```

`np.nan` is a float meaning "not a number"; it is not equal to itself, so `values == np.nan` never works. Use `np.isnan` to detect it and the `nan`-aware aggregations (`np.nanmean`, `np.nansum`, `np.nanmax`) when a missing value should be skipped rather than treated as zero.

> **Pitfall:** `np.nan_to_num` turns missing values into a real number. That is the right choice only when zero is a defensible substitute. For an average order value, filling a missing order with 0 changes the answer; leaving it out may be correct.

## Your turn: tax by price band

Apply 25% tax to prices above 100 and 15% to everything else. Build `final_prices` with one vectorized expression. Do not use a Python loop.

```python exercise id=vectorized-tax title="Tax by price band"
import numpy as np

prices = np.array([45.0, 120.0, 80.0, 250.0])

# TODO: 25% tax above 100, 15% otherwise.
final_prices = ...
--- solution
import numpy as np

prices = np.array([45.0, 120.0, 80.0, 250.0])

final_prices = np.where(prices > 100, prices * 1.25, prices * 1.15)
--- test
assert final_prices is not ..., "Replace the `...` after `final_prices =`."
assert final_prices.shape == (4,), f"`final_prices` should have shape (4,), but has {final_prices.shape}."
expected = np.array([51.75, 150.0, 92.0, 312.5])
assert np.allclose(final_prices, expected), f"Expected {expected}, but got {final_prices}."
assert np.allclose(final_prices[prices > 100], prices[prices > 100] * 1.25), "Prices above 100 need 25% tax."
assert np.allclose(final_prices[prices <= 100], prices[prices <= 100] * 1.15), "Prices at or below 100 need 15% tax."
--- hint
`np.where(condition, a, b)` chooses element by element. Use `prices > 100` as the condition.
--- hint
The two branches are `prices * 1.25` and `prices * 1.15`.
```

## Your turn: clip implausible ages

A survey collected ages, but two entries are outside the adult range. Use `np.clip` to cap every value at 18 on the low end and 65 on the high end, without changing the valid ages.

```python exercise id=clip-ages title="Clip implausible ages"
import numpy as np

ages = np.array([12, 17, 24, 68, 81])

# TODO: clip to the range 18–65.
cleaned = ...
--- solution
import numpy as np

ages = np.array([12, 17, 24, 68, 81])

cleaned = np.clip(ages, 18, 65)
--- test
assert cleaned is not ..., "Replace the `...` after `cleaned =`."
assert cleaned.tolist() == [18, 18, 24, 65, 65], f"Expected [18, 18, 24, 65, 65], but got {cleaned.tolist()}."
assert ages.tolist() == [12, 17, 24, 68, 81], "Do not modify the original `ages` array."
--- hint
`np.clip(array, lower, upper)` returns a new array with every value bounded.
--- hint
The lower bound is 18 and the upper bound is 65. Assign `np.clip(ages, 18, 65)` to `cleaned`.
```

## Your turn: three customer tiers

Use `np.select` to label each spend value:
- `"high"` for 400 or more
- `"medium"` for 200 or more
- `"low"` for 100 or more
- `"basic"` otherwise

```python exercise id=segment-spend title="Label spend tiers"
import numpy as np

spend = np.array([80.0, 220.0, 500.0, 45.0, 150.0])

# TODO: build `tier` with np.select.
tier = ...
--- solution
import numpy as np

spend = np.array([80.0, 220.0, 500.0, 45.0, 150.0])

tier = np.select(
    [spend >= 400, spend >= 200, spend >= 100],
    ["high", "medium", "low"],
    default="basic",
)
--- test
assert tier is not ..., "Replace the `...` after `tier =`."
assert list(tier) == ["basic", "medium", "high", "basic", "low"], f"Got {list(tier)}. Check the thresholds and the order of the conditions."
assert len(tier) == len(spend), "The result should have one label per spend value."
--- hint
`np.select` takes a list of conditions, a list of matching choices, and a `default=`.
--- hint
Order the thresholds from highest to lowest: `spend >= 400`, then `>= 200`, then `>= 100`.
```

## The ambiguous array

This looks reasonable, but Python can''t reduce an entire array to a single true/false value. Run it, read the error, then fix the mask. The goal is to select prices strictly between 20 and 100.

```python debug id=array-and-mask title="and does not mean element-wise"
import numpy as np

prices = np.array([12.0, 45.0, 80.0, 120.0])

mask = prices > 20 and prices < 100
selected = prices[mask]

print(selected)
--- solution
import numpy as np

prices = np.array([12.0, 45.0, 80.0, 120.0])

mask = (prices > 20) & (prices < 100)
selected = prices[mask]

print(selected)
--- test
assert mask.dtype == bool, f"`mask` should be a boolean array, but has dtype {mask.dtype}."
assert np.array_equal(mask, [False, True, True, False]), f"`mask` should be [False, True, True, False], but is {mask}."
assert np.array_equal(selected, [45.0, 80.0]), f"`selected` should be [45.0, 80.0], but is {selected}."
--- hint
Python''s `and` wants one truth value. NumPy needs element-wise boolean operators: `&` for and, `|` for or, `~` for not.
--- hint
Parenthesise each comparison: `(prices > 20) & (prices < 100)`. Without parentheses, operator precedence bites.
```

## Predict the conditional

```python predict id=predict-np-where title="Choose element by element"
import numpy as np

print(np.where(np.array([1, 5, 3]) > 2, 10, 0))
--- options
[10 10 10]
* [ 0 10 10]
[ 0 10 0]
Error: the condition is ambiguous
--- explain
Compare each element: `1 > 2` is false, `5 > 2` is true, `3 > 2` is true. The result is `[0, 10, 10]`. `np.where` evaluates the condition element by element; it does not reduce the array.
```

## Recap

- Vectorization replaces a Python loop with a whole-array expression, making intent clearer and execution faster.
- Ufuncs (`np.clip`, `np.sqrt`, `np.log1p`) operate element by element.
- `np.where` handles two branches; `np.select` handles ordered, multi-way choices.
- Use `np.isnan` and `np.nanmean` for missing values; `== np.nan` never detects them.
- Use `&`, `|` and `~` with parentheses for array logic; `and`/`or` require one truth value.

**Up next:** you''ll put the arrays into labelled tables and meet the object that will carry most of your analysis: the pandas DataFrame.
', 0, '[]', '[]', '2026-06-25T06:08:01.943Z', '2026-10-19T06:08:01.943Z'),
('les_python_for_data_science_3_1', 'sec_python_for_data_science_3', 'crs_python_for_data_science', 'DataFrames 101', 'interactive', 0, 1020, NULL, NULL, '# DataFrames 101

A NumPy array is a grid of values. A pandas **DataFrame** is a grid of values *with names*: named columns, a row index, and a dtype per column. That sounds like a small difference. In practice it is the difference between remembering that column 3 is price and writing `orders["unit_price"]`.

In this lesson you''ll create a DataFrame, inspect it before touching it, select rows and columns, derive new columns, parse dates and handle missing values. These are the moves you will repeat in every analysis.

## A table with names

```python run
import pandas as pd

orders = pd.DataFrame({
    "order_id": ["A-100", "A-101", "A-102", "A-103", "A-104", "A-105"],
    "city": ["Lisbon", " Porto ", "Lisbon", "Madrid", "porto", "Madrid"],
    "units": [2, 1, 4, 3, 2, 5],
    "unit_price": [19.99, 5.50, 12.00, 8.25, 4.25, 2.00],
    "status": ["delivered", "delivered", "cancelled", "delivered", "pending", "delivered"],
    "ordered_at": ["2026-01-03", "2026-01-04", "2026-01-09", "2026-02-01", "2026-02-02", "2026-02-08"],
})

orders
```

A DataFrame has an **index** on the left (0–5 here) and a **column index** across the top. The index is a label, not data — but it can carry meaning, and it participates in alignment when you combine tables.

## Inspect before you analyze

```python run
print("shape:", orders.shape)
print("\ndtypes:")
print(orders.dtypes)
print("\nfirst three rows:")
print(orders.head(3))
```

`shape` is `(rows, columns)`. `dtypes` tells you whether `units` is a number or text. `head()` shows the first rows without dumping the whole table. For a new dataset, also run `orders.info()` and `orders.describe()`: the first reports non-null counts and memory, the second summarizes numeric columns.

> **Tip:** Do not skip this step. A numeric-looking column stored as `object` will break arithmetic later, and a date stored as text cannot be filtered by month.

## Select rows and columns

`[]` with a column name returns a Series. `.loc` selects by **label**; `.iloc` selects by **position**. The distinction matters once your index is not 0, 1, 2…

```python run
print(orders["city"].head())
print("\nlabel selection:")
print(orders.loc[1, ["order_id", "city", "units"]])
print("\nposition selection:")
print(orders.iloc[:3, :3])
```

`.loc[1, ["order_id", "city", "units"]]` means "row with index label 1, these columns". `.iloc[0:3, 0:3]` means "the first three rows and the first three columns". Mixing them up is a classic source of wrong-row bugs.

## Filter rows

A boolean Series selects the rows where it is true. Combine conditions with `&` and `|`, and wrap each comparison in parentheses.

```python run
delivered = orders[(orders["status"] == "delivered") & (orders["units"] >= 2)]
delivered = delivered.sort_values("units", ascending=False)
delivered
```

`orders["units"] >= 2` is a Series of booleans, one per row. The outer `orders[...]` keeps the rows whose value is `True`. The result keeps the original index labels; that is normal and useful for tracing rows back.

## Derive columns

New columns are assigned like dictionary keys. String columns have a `.str` accessor; dates need `pd.to_datetime` before `.dt` works.

```python run
orders["revenue"] = orders["units"] * orders["unit_price"]
orders["city"] = orders["city"].str.strip().str.title()
orders["ordered_at"] = pd.to_datetime(orders["ordered_at"])
orders["month"] = orders["ordered_at"].dt.to_period("M")

orders.sort_values("revenue", ascending=False).head()
```

Every operation is vectorized: the multiplication happens across the whole column at once. `dt.to_period("M")` produces a month label such as `2026-01`, which is ideal for grouping later.

## Missing values are information

```python run
messy = pd.DataFrame({
    "order_id": ["B-1", "B-2", "B-3"],
    "quantity": [2, None, 4],
    "unit_price": [10.0, 5.0, 2.5],
})

print(messy.isna())
print("\nrows with any missing value:")
print(messy[messy.isna().any(axis=1)])

messy["quantity"] = messy["quantity"].fillna(0).astype(int)
messy["revenue"] = messy["quantity"] * messy["unit_price"]
messy
```

`fillna(0)` is a decision, not a default. For a missing quantity, zero may mean "nothing shipped"; for a missing price, zero would silently erase revenue. Sometimes `dropna()` is the honest choice. Decide with the business meaning in mind.

> **Pitfall:** `astype(int)` on a column with `NaN` raises. Fill or drop the missing values first. And `int` is not always right: a count can be integer; a price should stay float.

## Your turn: clean the order export

The export has padded city names, quantities stored as text, a missing quantity and dates stored as text. Produce `clean` with:

- `city` stripped and title-cased
- `quantity` as an integer, with missing values filled as 0
- `revenue = quantity * unit_price`
- `ordered_at` parsed as a datetime
- `month` as a `Period` such as `2026-01`

```python exercise id=clean-orders title="Clean the order export"
import pandas as pd

raw = pd.DataFrame({
    "order_id": ["A-1", "A-2", "A-3", "A-4"],
    "city": [" lisbon ", "PORTO", "Lisbon", " porto "],
    "quantity": ["2", "1", None, "3"],
    "unit_price": [19.99, 5.50, 12.00, 4.25],
    "ordered_at": ["2026-01-03", "2026-01-04", "2026-02-01", "2026-02-02"],
    "status": ["delivered", "cancelled", "delivered", "delivered"],
})

clean = raw.copy()

# TODO: transform the columns in `clean`.
clean["city"] = ...
clean["quantity"] = ...
clean["revenue"] = ...
clean["ordered_at"] = ...
clean["month"] = ...
--- solution
import pandas as pd

raw = pd.DataFrame({
    "order_id": ["A-1", "A-2", "A-3", "A-4"],
    "city": [" lisbon ", "PORTO", "Lisbon", " porto "],
    "quantity": ["2", "1", None, "3"],
    "unit_price": [19.99, 5.50, 12.00, 4.25],
    "ordered_at": ["2026-01-03", "2026-01-04", "2026-02-01", "2026-02-02"],
    "status": ["delivered", "cancelled", "delivered", "delivered"],
})

clean = raw.copy()
clean["city"] = clean["city"].str.strip().str.title()
clean["quantity"] = clean["quantity"].fillna(0).astype(int)
clean["revenue"] = clean["quantity"] * clean["unit_price"]
clean["ordered_at"] = pd.to_datetime(clean["ordered_at"])
clean["month"] = clean["ordered_at"].dt.to_period("M")
--- test
assert clean["city"].tolist() == ["Lisbon", "Porto", "Lisbon", "Porto"], f"City values should be cleaned, but are {clean[''city''].tolist()}."
assert pd.api.types.is_integer_dtype(clean["quantity"]), f"`quantity` should be an integer column, but has dtype {clean[''quantity''].dtype}. Convert the text and fill the missing value."
assert clean["quantity"].tolist() == [2, 1, 0, 3], f"`quantity` should be [2, 1, 0, 3], but is {clean[''quantity''].tolist()}."
assert clean["revenue"].round(2).tolist() == [39.98, 5.50, 0.0, 12.75], f"Revenue should be [39.98, 5.5, 0.0, 12.75], but is {clean[''revenue''].round(2).tolist()}."
assert str(clean["month"].iloc[0]) == "2026-01" and str(clean["month"].iloc[2]) == "2026-02", "`month` should be a Period column such as 2026-01."
assert clean.shape == (4, 8), f"`clean` should have 4 rows and 8 columns, but has shape {clean.shape}."
--- hint
String methods live on `.str`: `clean["city"].str.strip().str.title()`.
--- hint
For `quantity`, fill first, then convert: `clean["quantity"].fillna(0).astype(int)`. For the date, use `pd.to_datetime`, then `.dt.to_period("M")`.
```

## Your turn: the top delivered orders

Filter to delivered orders with revenue at least 50, sort by revenue from highest to lowest, and keep the first two rows in `result`.

```python exercise id=top-orders title="Find the top delivered orders"
import pandas as pd

orders = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E"],
    "status": ["delivered", "delivered", "cancelled", "delivered", "delivered"],
    "revenue": [80.0, 20.0, 100.0, 60.0, 50.0],
})

# TODO: filter, sort, and take the top two.
result = ...
--- solution
import pandas as pd

orders = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E"],
    "status": ["delivered", "delivered", "cancelled", "delivered", "delivered"],
    "revenue": [80.0, 20.0, 100.0, 60.0, 50.0],
})

result = (
    orders[(orders["status"] == "delivered") & (orders["revenue"] >= 50)]
    .sort_values("revenue", ascending=False)
    .head(2)
)
--- test
assert result is not ..., "Replace the `...` after `result =`."
assert result.shape[0] == 2, f"`result` should have 2 rows, but has {result.shape[0]}. Did you sort before taking the top two?"
assert result["order_id"].tolist() == ["A", "D"], f"The top two delivered orders should be A and D, but got {result[''order_id''].tolist()}."
assert result["revenue"].tolist() == [80.0, 60.0], f"Revenue should be [80.0, 60.0], but is {result[''revenue''].tolist()}."
--- hint
Build the boolean mask first: status is delivered **and** revenue is at least 50. Use `&` with parentheses.
--- hint
Chain `.sort_values("revenue", ascending=False)` and `.head(2)` after filtering.
```

## The column that is secretly text

This table looks numeric, but the quantity column holds strings. The multiplication fails before the lesson can print. Fix the type at the boundary, then verify the revenue.

```python debug id=string-revenue title="Numbers stored as text"
import pandas as pd

orders = pd.DataFrame({
    "order_id": ["B-1", "B-2", "B-3"],
    "quantity": ["2", "3", "1"],
    "unit_price": [10.0, 5.0, 20.0],
})

orders["revenue"] = orders["quantity"] * orders["unit_price"]
print(orders)
--- solution
import pandas as pd

orders = pd.DataFrame({
    "order_id": ["B-1", "B-2", "B-3"],
    "quantity": ["2", "3", "1"],
    "unit_price": [10.0, 5.0, 20.0],
})

orders["quantity"] = orders["quantity"].astype(int)
orders["revenue"] = orders["quantity"] * orders["unit_price"]
print(orders)
--- test
assert pd.api.types.is_integer_dtype(orders["quantity"]), f"`quantity` should be an integer column, but has dtype {orders[''quantity''].dtype}."
assert orders["quantity"].tolist() == [2, 3, 1], "The numeric values should stay 2, 3 and 1."
assert orders["revenue"].tolist() == [20.0, 15.0, 20.0], f"Revenue should be [20.0, 15.0, 20.0], but is {orders[''revenue''].tolist()}."
--- hint
Read the error. Is pandas multiplying numbers, or trying to repeat a string?
--- hint
Convert the column before multiplying: `orders["quantity"] = orders["quantity"].astype(int)`.
```

## Predict the filter

```python predict id=predict-row-count title="How many Lisbon rows?"
import pandas as pd

df = pd.DataFrame({
    "city": ["Lisbon", "Porto", "Lisbon"],
    "units": [2, 3, 4],
})

print(df[df["city"] == "Lisbon"].shape[0])
--- options
1
* 2
3
4
--- explain
The boolean mask is `[True, False, True]`, so two rows survive. `.shape[0]` then reads the number of rows in the filtered frame.
```

## Recap

- A DataFrame has named columns, an index and a dtype per column. Inspect `shape`, `dtypes`, `head()` and `info()` before analysis.
- Use `[]` for columns, `.loc` for labels, `.iloc` for positions, and boolean masks for filtering.
- Derive columns with vectorized arithmetic; use `.str` for text and `pd.to_datetime` + `.dt` for dates.
- Missing values are a decision: fill them only when the substitute is meaningful.
- Convert text to numbers before arithmetic. A dtype bug is not a formatting problem.

**Up next:** you''ll stop looking at individual rows and start answering questions about groups: revenue by region, average order by plan, share of total by month.
', 0, '[]', '[]', '2026-06-25T06:08:01.943Z', '2026-10-19T06:08:01.943Z'),
('les_python_for_data_science_3_2', 'sec_python_for_data_science_3', 'crs_python_for_data_science', 'Grouping and aggregation', 'interactive', 1, 840, NULL, NULL, '# Grouping and aggregation

Most analytical questions are not about one row. They are about **groups**: revenue by region, average order value by plan, signups by week, churn by cohort. pandas answers them with one idea — split the table into groups, apply a calculation to each, then combine the results.

That is `groupby`. Once it clicks, a whole category of spreadsheet pivot-table work becomes a single expression you can read, test and reuse.

## Split, apply, combine

```python run
import pandas as pd

sales = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E", "F", "G", "H"],
    "region": ["North", "South", "North", "East", "South", "North", "East", "South"],
    "rep": ["Ana", "Ben", "Ana", "Cara", "Ben", "Ana", "Cara", "Ben"],
    "month": ["Jan", "Jan", "Feb", "Jan", "Feb", "Feb", "Feb", "Jan"],
    "revenue": [120.0, 80.0, 200.0, 50.0, 160.0, 90.0, 70.0, 110.0],
})

by_region = sales.groupby("region")["revenue"].sum().sort_values(ascending=False)
by_region
```

Read `sales.groupby("region")["revenue"].sum()` from the inside out: split rows by region, take the revenue column, sum each group, combine into a Series indexed by region. The group key becomes the index.

## Several metrics at once

Named aggregation gives each output column an explicit name. This is the version to use in real analysis: the result is self-documenting and the columns are stable.

```python run
summary = (
    sales.groupby("region")
    .agg(
        total_revenue=("revenue", "sum"),
        avg_order=("revenue", "mean"),
        orders=("order_id", "count"),
    )
    .sort_values("total_revenue", ascending=False)
)

summary
```

`.agg` accepts a list of functions too, but named aggregation avoids MultiIndex columns and makes downstream code much easier. `count` counts non-null values; `size` counts rows, including nulls. Know which one your question needs.

> **Tip:** `groupby` sorts the keys by default. If order matters for a chart, sort explicitly by the metric you care about rather than relying on alphabetical order.

## Group by more than one key

```python run
by_month = sales.groupby(["region", "month"])["revenue"].sum()
print(by_month)

by_month_unstacked = by_month.unstack(fill_value=0)
by_month_unstacked
```

The result of a multi-key groupby has a **MultiIndex**. `unstack` moves the last level into columns, turning a long Series into a small table. That is the beginning of reshaping, which gets its own lesson.

## Keep the row count: `transform`

`agg` returns one row per group. `transform` returns one value per **original row**, which is what you need for a share-of-total column.

```python run
sales["region_total"] = sales.groupby("region")["revenue"].transform("sum")
sales["share"] = (sales["revenue"] / sales["region_total"]).round(3)

sales.sort_values(["region", "share"], ascending=[True, False])
```

`transform("sum")` broadcasts each region''s total back to every row in that region. The division is then ordinary element-wise arithmetic. This pattern powers cohort shares, within-group rankings and normalisation.

> **Pitfall:** A groupby with a column that has missing values will silently drop those rows from `sum`/`mean` (not from `size`). Check `sales["region"].isna().sum()` before you trust a total.

## Your turn: the regional scorecard

Build `summary` with one row per region, sorted by `total_revenue` from highest to lowest, and these columns:

- `total_revenue`: sum of revenue
- `orders`: number of orders
- `avg_order`: mean revenue

```python exercise id=region-summary title="Build the regional scorecard"
import pandas as pd

sales = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E", "F", "G", "H"],
    "region": ["North", "South", "North", "East", "South", "North", "East", "South"],
    "revenue": [120.0, 80.0, 200.0, 50.0, 160.0, 90.0, 70.0, 110.0],
})

# TODO: group by region, aggregate, and sort by total revenue.
summary = ...
--- solution
import pandas as pd

sales = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E", "F", "G", "H"],
    "region": ["North", "South", "North", "East", "South", "North", "East", "South"],
    "revenue": [120.0, 80.0, 200.0, 50.0, 160.0, 90.0, 70.0, 110.0],
})

summary = (
    sales.groupby("region")
    .agg(
        total_revenue=("revenue", "sum"),
        orders=("order_id", "count"),
        avg_order=("revenue", "mean"),
    )
    .sort_values("total_revenue", ascending=False)
)
--- test
assert summary is not ..., "Replace the `...` after `summary =`."
assert list(summary.columns) == ["total_revenue", "orders", "avg_order"], f"Columns should be total_revenue, orders, avg_order, but are {list(summary.columns)}."
assert summary.index.tolist() == ["North", "South", "East"], f"Sort by total revenue descending; index should be North, South, East, but is {summary.index.tolist()}."
assert summary.loc["North", "total_revenue"] == 410.0, f"North revenue should be 410.0, but is {summary.loc[''North'', ''total_revenue'']!r}."
assert summary.loc["South", "orders"] == 3, f"South should have 3 orders, but has {summary.loc[''South'', ''orders'']!r}."
assert abs(summary.loc["East", "avg_order"] - 60.0) < 1e-9, "East''s average order should be 60.0."
--- hint
Start with `sales.groupby("region")`, then use `.agg(...)` with named tuples such as `total_revenue=("revenue", "sum")`.
--- hint
Sort after aggregating: `.sort_values("total_revenue", ascending=False)`.
```

## Your turn: share of the region

Add a column `share` holding each order''s fraction of its **region''s** revenue, rounded to 3 decimals. Do not compute the totals by hand; let `transform` broadcast them.

```python exercise id=share-of-total title="Share of the region"
import pandas as pd

sales = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E"],
    "region": ["North", "South", "North", "South", "North"],
    "revenue": [120.0, 80.0, 200.0, 160.0, 90.0],
})

# TODO: add a `share` column; keep all five rows.
share = ...
--- solution
import pandas as pd

sales = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E"],
    "region": ["North", "South", "North", "South", "North"],
    "revenue": [120.0, 80.0, 200.0, 160.0, 90.0],
})

share = (sales["revenue"] / sales.groupby("region")["revenue"].transform("sum")).round(3)
--- test
assert share is not ..., "Replace the `...` after `share =`."
assert len(share) == len(sales), f"`share` should have one value per row ({len(sales)}), but has {len(share)}. Use transform, not agg."
assert share.round(3).tolist() == [0.293, 0.333, 0.488, 0.667, 0.220], f"Shares should be [0.293, 0.333, 0.488, 0.667, 0.220], but are {share.round(3).tolist()}."
assert abs(share.iloc[0] - 120 / 410) < 1e-3, "The first North order is 120 out of 410."
--- hint
`transform("sum")` returns a value for every row, unlike `sum()` which collapses each group to one value.
--- hint
Use `sales.groupby("region")["revenue"].transform("sum")` as the denominator, then divide the revenue column and round.
```

## The metric that answered a different question

This code runs, but it reports the average order value by region when the brief asked for **total revenue**. Fix the aggregation. The grouping and output shape are already right.

```python debug id=groupby-metric title="Mean instead of total"
import pandas as pd

sales = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E"],
    "region": ["North", "South", "North", "South", "North"],
    "revenue": [120.0, 80.0, 200.0, 160.0, 90.0],
})

result = sales.groupby("region")["revenue"].mean()
print(result)
--- solution
import pandas as pd

sales = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E"],
    "region": ["North", "South", "North", "South", "North"],
    "revenue": [120.0, 80.0, 200.0, 160.0, 90.0],
})

result = sales.groupby("region")["revenue"].sum()
print(result)
--- test
assert result.loc["North"] == 410.0, f"North total revenue should be 410.0, but is {result.loc[''North'']!r}."
assert result.loc["South"] == 240.0, f"South total revenue should be 240.0, but is {result.loc[''South'']!r}."
assert len(result) == 2, "Return one value per region, not one value per row."
--- hint
Run it. North returns 136.67, which is the average of 120, 200 and 90. The brief asked for the total.
--- hint
Replace `.mean()` with `.sum()`.
```

## Predict the group sizes

```python predict id=predict-group-size title="Sizes by team"
import pandas as pd

df = pd.DataFrame({
    "team": ["beta", "alpha", "beta", "alpha", "beta"],
    "points": [10, 20, 30, 40, 50],
})

print(df.groupby("team").size().tolist())
--- options
[3, 2]
* [2, 3]
[10, 30, 50]
[20, 40]
--- explain
`groupby` sorts the group keys alphabetically by default: alpha has 2 rows, beta has 3. `.size()` counts rows. If you wanted points per team, you would select the `points` column and use `.sum()`.
```

## Recap

- `groupby` splits rows, applies an aggregation, and combines one result per group.
- Named `.agg(total=("column", "sum"))` produces stable, readable columns.
- Multiple keys create a MultiIndex; `unstack` turns the last level into columns.
- `transform` returns one value per original row, perfect for shares and normalisation.
- Choose the metric deliberately: sum, mean, count and size answer different questions.

**Up next:** you''ll combine multiple tables and reshape between long and wide layouts — the two operations that turn separate exports into one analysis-ready dataset.
', 0, '[]', '[]', '2026-06-25T06:08:01.943Z', '2026-10-19T06:08:01.943Z'),
('les_python_for_data_science_3_3', 'sec_python_for_data_science_3', 'crs_python_for_data_science', 'Joining and reshaping', 'interactive', 2, 840, NULL, NULL, '# Joining and reshaping

Real datasets rarely arrive as one tidy table. Customers live in one export, orders in another, monthly targets in a third. Before you can answer a question you often have to **join** tables on a shared key, then **reshape** between a long layout (one row per observation) and a wide layout (one column per category).

This lesson uses a customer table and an order table with a deliberate gap: one order belongs to a customer who is not in the customer export. That gap is the whole point.

## Join on a key

```python run
import pandas as pd

customers = pd.DataFrame({
    "customer_id": [1, 2, 3, 4],
    "name": ["Ana", "Ben", "Cara", "Dev"],
    "segment": ["Pro", "Free", "Pro", None],
})

orders = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E"],
    "customer_id": [1, 2, 1, 3, 5],
    "revenue": [120.0, 80.0, 200.0, 50.0, 90.0],
})

enriched = orders.merge(customers, on="customer_id", how="left")
enriched
```

A **left join** keeps every row on the left (all orders) and attaches matching customer columns. Order E has no customer 5, so `name` and `segment` become `NaN`. An **inner join** would silently drop E; a **right join** would keep every customer; an **outer join** keeps both sides.

> **Pitfall:** Check row counts before and after every join. A duplicated key on the right side multiplies rows, and an inner join can delete rows you needed. `merge(..., validate="many_to_one")` makes pandas raise if the right key is not unique.

## Diagnose a join with `indicator`

```python run
check = orders.merge(customers, on="customer_id", how="left", indicator=True)
print(check["_merge"].value_counts().to_dict())
print("orders with no customer:", check.loc[check["name"].isna(), "order_id"].tolist())
```

`_merge` labels each row as `both`, `left_only` or `right_only`. This is the fastest way to answer "how many rows failed to match?" without guessing from `NaN` values.

## Stack tables with `concat`

`merge` combines columns by key. `concat` stacks rows (or columns) by position. Use `ignore_index=True` when the original indices are meaningless.

```python run
jan = pd.DataFrame({"month": ["Jan", "Jan"], "revenue": [100.0, 200.0]})
feb = pd.DataFrame({"month": ["Feb", "Feb"], "revenue": [150.0, 250.0]})

combined = pd.concat([jan, feb], ignore_index=True)
combined
```

If the two tables have different columns, `concat` aligns them by name and fills the gaps with `NaN`. That is useful, but it is also how a typo in one export creates an accidental extra column.

## Reshape: long and wide

A **long** table has one row per region-month. A **wide** table has one row per region and one column per month. `pivot_table` goes long → wide; `melt` goes wide → long.

```python run
long = pd.DataFrame({
    "region": ["North", "North", "South", "South"],
    "month": ["Jan", "Feb", "Jan", "Feb"],
    "revenue": [60.0, 20.0, 30.0, 40.0],
})

wide = long.pivot_table(
    index="region",
    columns="month",
    values="revenue",
    aggfunc="sum",
    fill_value=0,
)
print(wide)

back_to_long = wide.reset_index().melt(
    id_vars="region",
    var_name="month",
    value_name="revenue",
)
back_to_long
```

`pivot_table` can aggregate when several rows share the same index/column pair. `pivot` is the stricter version and raises on duplicates. `melt` is the inverse: identifier columns stay, the remaining columns become two columns — one for the old column name, one for the value.

> **In the wild:** plotting libraries often prefer long data (one column for the category, one for the value). Wide data is convenient for reading a table and for some statistical models. Being able to move between them is a core skill.

## Your turn: keep every order

Left-join `customers` onto `orders`, then fill the missing `segment` with `"Unknown"`. Keep all five orders and all original order columns.

```python exercise id=enrich-orders title="Enrich orders without losing rows"
import pandas as pd

customers = pd.DataFrame({
    "customer_id": [1, 2, 3, 4],
    "name": ["Ana", "Ben", "Cara", "Dev"],
    "segment": ["Pro", "Free", "Pro", None],
})

orders = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E"],
    "customer_id": [1, 2, 1, 3, 5],
    "revenue": [120.0, 80.0, 200.0, 50.0, 90.0],
})

# TODO: left-join, then fill missing segments.
enriched = ...
--- solution
import pandas as pd

customers = pd.DataFrame({
    "customer_id": [1, 2, 3, 4],
    "name": ["Ana", "Ben", "Cara", "Dev"],
    "segment": ["Pro", "Free", "Pro", None],
})

orders = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E"],
    "customer_id": [1, 2, 1, 3, 5],
    "revenue": [120.0, 80.0, 200.0, 50.0, 90.0],
})

enriched = orders.merge(customers, on="customer_id", how="left")
enriched["segment"] = enriched["segment"].fillna("Unknown")
--- test
assert enriched is not ..., "Replace the `...` after `enriched =`."
assert len(enriched) == 5, f"All five orders must survive the join, but `enriched` has {len(enriched)} rows. Which join keeps unmatched left rows?"
assert enriched["order_id"].tolist() == ["A", "B", "C", "D", "E"], f"Order rows should stay in order A–E, but are {enriched[''order_id''].tolist()}."
assert enriched["segment"].tolist() == ["Pro", "Free", "Pro", "Pro", "Unknown"], f"Segments should be [Pro, Free, Pro, Pro, Unknown], but are {enriched[''segment''].tolist()}."
assert enriched.loc[enriched["order_id"] == "E", "name"].isna().all(), "Order E has no matching customer; its name should remain missing."
assert enriched["revenue"].sum() == 540.0, "The join should not change or duplicate revenue."
--- hint
Use `how="left"` so every row from `orders` is retained.
--- hint
After the join, `enriched["segment"].fillna("Unknown")` replaces the missing segment. Assign it back to the column.
```

## Your turn: build the monthly matrix

Pivot `long` so each row is a region, each column is a month, and the values are summed revenue. Fill missing cells with 0.

```python exercise id=monthly-wide title="Long to wide"
import pandas as pd

long = pd.DataFrame({
    "region": ["North", "North", "South", "South", "North"],
    "month": ["Jan", "Feb", "Jan", "Feb", "Jan"],
    "revenue": [10.0, 20.0, 30.0, 40.0, 50.0],
})

# TODO: build a wide table indexed by region.
wide = ...
--- solution
import pandas as pd

long = pd.DataFrame({
    "region": ["North", "North", "South", "South", "North"],
    "month": ["Jan", "Feb", "Jan", "Feb", "Jan"],
    "revenue": [10.0, 20.0, 30.0, 40.0, 50.0],
})

wide = long.pivot_table(
    index="region",
    columns="month",
    values="revenue",
    aggfunc="sum",
    fill_value=0,
)
--- test
assert wide is not ..., "Replace the `...` after `wide =`."
assert wide.shape == (2, 2), f"`wide` should have 2 rows and 2 columns, but has shape {wide.shape}."
assert wide.index.tolist() == ["North", "South"], f"Rows should be regions, but the index is {wide.index.tolist()}."
assert set(wide.columns) == {"Jan", "Feb"}, f"Columns should be Jan and Feb, but are {list(wide.columns)}."
assert wide.loc["North", "Jan"] == 60.0, f"North January should be 60.0 (10 + 50), but is {wide.loc[''North'', ''Jan'']!r}."
assert wide.loc["South", "Feb"] == 40.0, "South February should be 40.0."
--- hint
`pivot_table(index="region", columns="month", values="revenue", aggfunc="sum", fill_value=0)` does the whole job.
--- hint
The two North January rows must be added together, so use `aggfunc="sum"`, not `pivot`.
```

## The join that deleted a row

The brief is "every order, with the customer segment where we know it." This code runs, but the result has four rows instead of five. Find the order that disappeared and change the join so the missing customer stays visible.

```python debug id=inner-join title="The order that vanished"
import pandas as pd

customers = pd.DataFrame({
    "customer_id": [1, 2, 3],
    "segment": ["Pro", "Free", "Pro"],
})

orders = pd.DataFrame({
    "order_id": ["A", "B", "C", "D"],
    "customer_id": [1, 2, 3, 99],
    "revenue": [120.0, 80.0, 60.0, 40.0],
})

result = orders.merge(customers, on="customer_id", how="inner")
print(result)
--- solution
import pandas as pd

customers = pd.DataFrame({
    "customer_id": [1, 2, 3],
    "segment": ["Pro", "Free", "Pro"],
})

orders = pd.DataFrame({
    "order_id": ["A", "B", "C", "D"],
    "customer_id": [1, 2, 3, 99],
    "revenue": [120.0, 80.0, 60.0, 40.0],
})

result = orders.merge(customers, on="customer_id", how="left")
print(result)
--- test
assert len(result) == 4, f"All four orders should survive, but `result` has {len(result)} rows."
assert result["order_id"].tolist() == ["A", "B", "C", "D"], f"Order rows should be A–D, but are {result[''order_id''].tolist()}."
assert result.loc[result["order_id"] == "D", "segment"].isna().all(), "Order D has no matching customer, so its segment should be missing."
assert result["revenue"].sum() == 300.0, "The join should not change the total revenue."
--- hint
Count the rows before and after. Which order has a customer_id that is absent from `customers`?
--- hint
An inner join keeps only matches. Use `how="left"` so every order is retained.
```

## Predict the inner join

```python predict id=predict-merge-rows title="How many matches?"
import pandas as pd

left = pd.DataFrame({"id": [1, 2], "x": ["a", "b"]})
right = pd.DataFrame({"id": [2, 3], "y": ["c", "d"]})

print(pd.merge(left, right, on="id", how="inner").shape[0])
--- options
0
* 1
2
3
--- explain
Only `id=2` appears on both sides. An inner join keeps matching keys only, so the result has one row. A left join would keep both left rows, with a missing `y` for id 1.
```

## Recap

- `merge` combines columns on a key; `how` decides which unmatched rows survive.
- Always compare row counts before and after a join, and use `indicator=True` to diagnose unmatched keys.
- `concat` stacks tables by position; align columns by name.
- `pivot_table` goes long → wide and can aggregate duplicates; `melt` goes wide → long.
- Inner joins delete unmatched rows. Left joins preserve the left table and expose gaps as `NaN`.

**Up next:** you''ll make those gaps and patterns visible with charts, then run a complete exploratory analysis from raw CSV to written conclusions.
', 0, '[]', '[]', '2026-06-25T06:08:01.943Z', '2026-10-19T06:08:01.943Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_python_for_data_science_3_4', 'sec_python_for_data_science_3', 'crs_python_for_data_science', 'Checkpoint: pandas', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"What does `df.shape` return for a table with 12 rows and 4 columns?","options":["48","(12, 4)","(4, 12)","12"],"answerIndex":1,"explanation":"`shape` is a tuple of (rows, columns), so it is `(12, 4)`."},{"id":"q2","prompt":"Which expression selects only the rows of `df` where `revenue` is greater than 100?","options":["df.filter(100)","df[df.revenue > 100]","df.loc[100]","df.revenue.max() > 100"],"answerIndex":1,"explanation":"A boolean Series inside `df[...]` keeps the rows where the condition is true. `loc`/`iloc` select by label or position, not by a condition in this form."},{"id":"q3","prompt":"`a` has shape `(3, 1)` and `b` has shape `(4,)`. What is the shape of `a + b`?","options":["(3, 1)","(3, 4)","(4, 3)","A ValueError is raised"],"answerIndex":1,"explanation":"Align from the right: `(3, 1)` against `(1, 4)`. Each size-1 dimension stretches, producing `(3, 4)`."},{"id":"q4","prompt":"You want one value per original row showing each row''s share of its group''s total. Which operation should you use?","options":["groupby(...).sum()","groupby(...).transform(\"sum\")","pivot_table","drop_duplicates"],"answerIndex":1,"explanation":"`transform` returns a result aligned to the original rows; `sum` collapses each group to one value. You can then divide the row value by the transformed total."},{"id":"q5","prompt":"A left join between `orders` and `customers` on `customer_id` keeps…","options":["Only orders with a matching customer","Every order, with missing customer fields filled with NaN where there is no match","Every customer, even those with no orders","Only rows present in both tables"],"answerIndex":1,"explanation":"A left join preserves all rows from the left table. Unmatched right-side columns become NaN. An inner join is the one that keeps only matches."},{"id":"q6","prompt":"`orders[\"quantity\"]` has dtype `object` and contains values like `\"2\"` and `\"3\"`. What is the safest first step before multiplying by price?","options":["Use `str.replace`","Convert with `pd.to_numeric` or `.astype(int)`","Sort the column","Call `.mean()`"],"answerIndex":1,"explanation":"The values are text. Convert them to a numeric dtype before arithmetic. `.astype(int)` works when the values are clean integers; `pd.to_numeric(..., errors=\"coerce\")` handles messier input."},{"id":"q7","prompt":"Which pandas result has one row per region and one column for each month?","options":["A long table","A wide table","A MultiIndex Series","A Boolean mask"],"answerIndex":1,"explanation":"Wide data puts categories in columns. `pivot_table` turns long region-month rows into a region-by-month matrix."},{"id":"q8","prompt":"When is a line chart usually a better choice than a bar chart?","options":["When comparing unordered categories","When showing a value changing over time","When every value is missing","When there are more than 1,000 categories"],"answerIndex":1,"explanation":"A line encodes continuity and is natural for a time series. Bars compare discrete categories; too many categories on either chart becomes unreadable."}]', '[]', '2026-06-25T06:08:01.943Z', '2026-10-19T06:08:01.943Z'),
('les_python_for_data_science_4_1', 'sec_python_for_data_science_4', 'crs_python_for_data_science', 'Plotting with matplotlib and seaborn', 'interactive', 0, 840, NULL, NULL, '# Plotting with matplotlib and seaborn

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

> **In the wild:** Seaborn''s `sns.lineplot`, `sns.barplot` and `sns.scatterplot` accept a DataFrame and a column name, and add useful defaults for confidence intervals and grouping. The figure/axes model underneath is the same one you are learning here.
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

**Up next:** you''ll combine everything — loading a messy CSV, cleaning it, deriving metrics, grouping, joining and plotting — into one end-to-end exploratory analysis.
', 0, '[]', '[]', '2026-06-25T06:08:01.943Z', '2026-10-19T06:08:01.943Z'),
('les_python_for_data_science_4_2', 'sec_python_for_data_science_4', 'crs_python_for_data_science', 'An end-to-end EDA', 'interactive', 1, 1140, NULL, NULL, '# An end-to-end EDA

Exploratory data analysis is not a checklist. It is a conversation with a dataset: you inspect, form a question, calculate, plot, then revise the question. This final lesson runs that loop on a realistic subscription export.

The business question: **which plans drive revenue, and where is churn concentrated?** The data is deliberately messy — padded plan names, inconsistent country casing, a missing seat count, dates stored as text, and churn recorded as `yes`/`no`. By the end you''ll have a cleaned table, a plan scorecard, a monthly view and two charts that support a written conclusion.

## 1. Load and look

```python run
import io
import pandas as pd

csv_data = """customer_id,plan,signup_date,monthly_fee,seats,churned,country
1, Pro ,2026-01-04,49.00,3,no, Portugal
2,pro,2026-02-11,49.00,,yes, portugal
3,Basic,2026-01-19,19.00,1,no,Spain
4,Basic,2026-03-02,19.00,2,yes,Spain
5, Pro,2026-02-20,49.00,4,no,Portugal
6,basic,2026-03-15,19.00,1,no, spain 
7,Pro,2026-01-28,49.00,2,yes,Portugal
8,Basic,2026-02-05,19.00,3,no,Spain
"""

df = pd.read_csv(io.StringIO(csv_data))
print("shape:", df.shape)
print("\ndtypes:")
print(df.dtypes)
print("\nmissing values:")
print(df.isna().sum())
df.head()
```

Before cleaning anything, note what you have: eight customers, one missing `seats`, and text columns that should be categorical. `churned` is text, so it cannot be averaged yet.

## 2. Clean at the boundary

```python run
clean = df.copy()
clean["plan"] = clean["plan"].str.strip().str.lower()
clean["country"] = clean["country"].str.strip().str.lower()
clean["seats"] = clean["seats"].fillna(1).astype(int)
clean["signup_date"] = pd.to_datetime(clean["signup_date"])
clean["churned"] = clean["churned"].str.strip().str.lower().eq("yes")
clean["mrr"] = (clean["monthly_fee"] * clean["seats"]).round(2)

clean.head()
```

`mrr` is monthly recurring revenue: fee per seat times seats. Filling a missing seat count with 1 is an assumption; it should be documented. Every cleaning decision has a business meaning, and the analysis is only as defensible as those decisions.

## 3. Ask about plans

```python run
plan_summary = (
    clean.groupby("plan")
    .agg(
        customers=("customer_id", "count"),
        mrr=("mrr", "sum"),
        churned=("churned", "sum"),
    )
)
plan_summary["churn_rate"] = (plan_summary["churned"] / plan_summary["customers"]).round(2)
plan_summary.sort_values("mrr", ascending=False)
```

Pro has four customers and 490 MRR; Basic has four customers and 133 MRR. Pro churns 2 of 4 (50%), Basic churns 1 of 4 (25%). The higher-revenue plan is also the higher-churn plan — that is the tension worth investigating.

## 4. Add time

```python run
clean["month"] = clean["signup_date"].dt.to_period("M")
monthly = clean.groupby("month").agg(
    signups=("customer_id", "count"),
    mrr_added=("mrr", "sum"),
)
monthly
```

A monthly view turns a static snapshot into a trend. January had 3 signups, February 3, March 2. With eight rows this is anecdotal, not statistically meaningful — but the habit of checking the time dimension is what matters.

## 5. Show the evidence

```python run
import matplotlib.pyplot as plt

plan_plot = plan_summary.sort_values("mrr", ascending=False)

fig, axes = plt.subplots(1, 2, figsize=(9, 3.5))

axes[0].bar(plan_plot.index, plan_plot["mrr"], color=["#2563eb", "#0f766e"])
axes[0].set_title("MRR by plan")
axes[0].set_ylabel("MRR ($)")

axes[1].bar(plan_plot.index, plan_plot["churn_rate"], color=["#dc2626", "#f59e0b"])
axes[1].set_title("Churn rate by plan")
axes[1].set_ylabel("Share of customers")
axes[1].set_ylim(0, 1)

fig.suptitle("Revenue and churn do not point the same way")
plt.tight_layout()
plt.show()
```

The two panels make the trade-off visible: Pro brings more revenue but loses a larger share of customers. A good EDA ends with a sentence like that, not just a table.

> **In the wild:** Before shipping a recommendation, check the sample size, the time window and the definition of churn. "50% churn" based on four customers is a hypothesis, not a forecast.

## Your turn: clean the subscriptions

Build `clean` from `raw` with:

- `plan` and `country` stripped and lowercased
- `seats` filled with 1 and converted to integer
- `signup_date` parsed as datetime
- `churned` as a boolean (`"yes"` → `True`)
- `mrr = monthly_fee * seats`, rounded to 2 decimals

```python exercise id=clean-subscriptions title="Clean the subscription export"
import pandas as pd

raw = pd.DataFrame({
    "customer_id": [1, 2, 3, 4, 5],
    "plan": [" Pro ", "pro", "Basic", "basic", " Pro"],
    "country": [" Portugal", "portugal ", "Spain", "SPAIN", "Portugal"],
    "signup_date": ["2026-01-04", "2026-02-11", "2026-01-19", "2026-03-02", "2026-02-20"],
    "monthly_fee": [49.0, 49.0, 19.0, 19.0, 49.0],
    "seats": [3, None, 1, 2, 4],
    "churned": ["no", "yes", "no", "yes", "no"],
})

clean = raw.copy()

# TODO: clean every column described above.
clean["plan"] = ...
clean["country"] = ...
clean["seats"] = ...
clean["signup_date"] = ...
clean["churned"] = ...
clean["mrr"] = ...
--- solution
import pandas as pd

raw = pd.DataFrame({
    "customer_id": [1, 2, 3, 4, 5],
    "plan": [" Pro ", "pro", "Basic", "basic", " Pro"],
    "country": [" Portugal", "portugal ", "Spain", "SPAIN", "Portugal"],
    "signup_date": ["2026-01-04", "2026-02-11", "2026-01-19", "2026-03-02", "2026-02-20"],
    "monthly_fee": [49.0, 49.0, 19.0, 19.0, 49.0],
    "seats": [3, None, 1, 2, 4],
    "churned": ["no", "yes", "no", "yes", "no"],
})

clean = raw.copy()
clean["plan"] = clean["plan"].str.strip().str.lower()
clean["country"] = clean["country"].str.strip().str.lower()
clean["seats"] = clean["seats"].fillna(1).astype(int)
clean["signup_date"] = pd.to_datetime(clean["signup_date"])
clean["churned"] = clean["churned"].str.strip().str.lower().eq("yes")
clean["mrr"] = (clean["monthly_fee"] * clean["seats"]).round(2)
--- test
assert clean["plan"].tolist() == ["pro", "pro", "basic", "basic", "pro"], f"Plans should be [pro, pro, basic, basic, pro], but are {clean[''plan''].tolist()}."
assert clean["country"].tolist() == ["portugal", "portugal", "spain", "spain", "portugal"], f"Countries should be normalized, but are {clean[''country''].tolist()}."
assert clean["seats"].tolist() == [3, 1, 1, 2, 4], f"Seats should be [3, 1, 1, 2, 4], but are {clean[''seats''].tolist()}."
assert pd.api.types.is_integer_dtype(clean["seats"]), "`seats` should be an integer column."
assert clean["churned"].tolist() == [False, True, False, True, False], f"`churned` should be [False, True, False, True, False], but is {clean[''churned''].tolist()}."
assert clean["mrr"].tolist() == [147.0, 49.0, 19.0, 38.0, 196.0], f"MRR should be [147.0, 49.0, 19.0, 38.0, 196.0], but is {clean[''mrr''].tolist()}."
assert clean.shape == (5, 8), f"`clean` should have 5 rows and 8 columns, but has shape {clean.shape}."
--- hint
Use `.str.strip().str.lower()` on both text columns, then `fillna(1).astype(int)` for seats.
--- hint
`pd.to_datetime` parses the dates; `eq("yes")` converts the churn labels to booleans. Revenue is `monthly_fee * seats`, rounded to 2 decimals.
```

## Your turn: the plan scorecard

Build `scorecard` with one row per plan, sorted by `mrr` descending, and these columns:

- `customers`: count of customers
- `mrr`: sum of MRR
- `churned`: count of churned customers
- `churn_rate`: churned / customers, rounded to 2 decimals

```python exercise id=plan-scorecard title="Build the plan scorecard"
import pandas as pd

clean = pd.DataFrame({
    "customer_id": [1, 2, 3, 4, 5, 6],
    "plan": ["pro", "pro", "basic", "basic", "pro", "basic"],
    "mrr": [147.0, 49.0, 19.0, 38.0, 196.0, 57.0],
    "churned": [False, True, False, True, True, False],
})

# TODO: group by plan, aggregate, add churn_rate, sort by MRR.
scorecard = ...
--- solution
import pandas as pd

clean = pd.DataFrame({
    "customer_id": [1, 2, 3, 4, 5, 6],
    "plan": ["pro", "pro", "basic", "basic", "pro", "basic"],
    "mrr": [147.0, 49.0, 19.0, 38.0, 196.0, 57.0],
    "churned": [False, True, False, True, True, False],
})

scorecard = (
    clean.groupby("plan")
    .agg(
        customers=("customer_id", "count"),
        mrr=("mrr", "sum"),
        churned=("churned", "sum"),
    )
)
scorecard["churn_rate"] = (scorecard["churned"] / scorecard["customers"]).round(2)
scorecard = scorecard.sort_values("mrr", ascending=False)
--- test
assert scorecard is not ..., "Replace the `...` after `scorecard =`."
assert scorecard.index.tolist() == ["pro", "basic"], f"Sort by MRR descending; index should be pro, basic, but is {scorecard.index.tolist()}."
assert scorecard.loc["pro", "mrr"] == 392.0, f"Pro MRR should be 392.0, but is {scorecard.loc[''pro'', ''mrr'']!r}."
assert scorecard.loc["pro", "churn_rate"] == 0.67, f"Pro churn rate should be 0.67 (2 of 3), but is {scorecard.loc[''pro'', ''churn_rate'']!r}."
assert scorecard.loc["basic", "customers"] == 3, "Basic should have 3 customers."
--- hint
Start with `.groupby("plan").agg(...)` using named aggregations for customers, mrr and churned.
--- hint
Add `churn_rate` after aggregating, then sort with `.sort_values("mrr", ascending=False)`.
```

## The churn rate that crashes

This is a common real-world failure: someone loads a fresh export, forgets that `churned` is still text, and calls `.mean()`. Run it, read the error, then compute the rate without modifying `df`.

```python debug id=churn-rate title="A mean of yes and no"
import pandas as pd

df = pd.DataFrame({
    "customer_id": [1, 2, 3, 4],
    "churned": ["no", "yes", "no", "yes"],
})

churn_rate = df["churned"].mean()
print(churn_rate)
--- solution
import pandas as pd

df = pd.DataFrame({
    "customer_id": [1, 2, 3, 4],
    "churned": ["no", "yes", "no", "yes"],
})

churn_rate = df["churned"].eq("yes").mean()
print(churn_rate)
--- test
assert abs(float(churn_rate) - 0.5) < 1e-9, f"`churn_rate` should be 0.5, but is {churn_rate!r}."
assert df["churned"].tolist() == ["no", "yes", "no", "yes"], "Keep the original `churned` column as text; compute the rate from it."
--- hint
Run it. pandas cannot average strings. Turn the labels into booleans first.
--- hint
`df["churned"].eq("yes")` gives `[False, True, False, True]`; the mean of a boolean Series is the share of `True` values.
```

## Predict the churn rate

```python predict id=predict-churn-rate title="Mean of booleans"
import pandas as pd

df = pd.DataFrame({"churned": [False, True, False, True, False]})
print(round(df["churned"].mean(), 2))
--- options
0.2
* 0.4
0.6
2.0
--- explain
`True` counts as 1 and `False` as 0, so the mean is `2 / 5 = 0.4`. This is the clean way to compute a rate once the column is boolean.
```

## The conclusion

The scorecard and charts support a specific, limited claim: **Pro contributes most of the revenue per customer, but also shows more churn in this small sample.** The next step is not a bigger chart; it is more data and a sharper question. How long do Pro customers stay? Does churn concentrate in a signup cohort? Is the missing seat count hiding a segment?

That is the real output of EDA: not a dashboard, but a better next question.

## Recap

- Inspect shape, dtypes and missing values before cleaning; the data will tell you what needs a decision.
- Clean text, numeric and date columns at the boundary, then derive business metrics such as MRR.
- Group by meaningful entities and add rates alongside counts; a count alone rarely answers a business question.
- Add a time dimension and plot the evidence. Check the sample size before turning a chart into a claim.
- A good analysis ends with a written conclusion and the next question, not just a table.

**You''re done with the lessons.** If you haven''t already, pass the checkpoint quiz at the end of the pandas section, then return to any challenge you skipped. The patterns here — inspect, clean, group, join, plot, question — are the ones you''ll use in every dataset that follows.
', 0, '[]', '[]', '2026-06-25T06:08:01.943Z', '2026-10-19T06:08:01.943Z');

INSERT INTO path_courses (path_id, course_id, position) VALUES
('pth_ml_engineer', 'crs_python_for_data_science', 1);

INSERT INTO enrollments (id, user_id, course_id, source, progress_percent, last_lesson_id, last_activity_at, completed_at, created_at) VALUES
('enr_crs_python_for_data_science_demo', 'usr_student', 'crs_python_for_data_science', 'free', 100, 'les_python_for_data_science_4_2', '2026-10-20T06:08:01.943Z', '2026-08-24T06:08:01.943Z', '2026-08-24T06:08:01.943Z');

INSERT INTO lesson_progress (user_id, lesson_id, course_id, completed, position_seconds, completed_at, updated_at) VALUES
('usr_student', 'les_python_for_data_science_1_1', 'crs_python_for_data_science', 1, 0, '2026-09-03T06:08:01.943Z', '2026-09-03T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_1_2', 'crs_python_for_data_science', 1, 0, '2026-09-04T06:08:01.943Z', '2026-09-04T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_1_3', 'crs_python_for_data_science', 1, 0, '2026-09-05T06:08:01.943Z', '2026-09-05T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_2_1', 'crs_python_for_data_science', 1, 0, '2026-09-06T06:08:01.943Z', '2026-09-06T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_2_2', 'crs_python_for_data_science', 1, 0, '2026-09-07T06:08:01.943Z', '2026-09-07T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_3_1', 'crs_python_for_data_science', 1, 0, '2026-09-08T06:08:01.943Z', '2026-09-08T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_3_2', 'crs_python_for_data_science', 1, 0, '2026-09-09T06:08:01.943Z', '2026-09-09T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_3_3', 'crs_python_for_data_science', 1, 0, '2026-09-10T06:08:01.943Z', '2026-09-10T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_3_4', 'crs_python_for_data_science', 1, 0, '2026-09-11T06:08:01.943Z', '2026-09-11T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_4_1', 'crs_python_for_data_science', 1, 0, '2026-09-12T06:08:01.943Z', '2026-09-12T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_4_2', 'crs_python_for_data_science', 1, 0, '2026-09-13T06:08:01.943Z', '2026-09-13T06:08:01.943Z');

INSERT INTO exercise_progress (user_id, lesson_id, cell_id, code, passed, attempts, solved_at, updated_at) VALUES
('usr_student', 'les_python_for_data_science_1_1', 'average-hours', 'import pandas as pd

cohort = pd.DataFrame({
    "learner": ["Amina", "Ben", "Chloe", "Diego"],
    "hours": [4.5, 2.0, 6.0, 3.5],
})

hours = cohort["hours"]
average = hours.mean()', 1, 2, '2026-09-03T06:08:01.943Z', '2026-09-03T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_1_1', 'revenue-miscalculation', 'prices = [12.50, 8.00, 5.25]
quantities = [2, 3, 4]

revenue = 0
for price, quantity in zip(prices, quantities):
    revenue += price * quantity

print(round(revenue, 2))', 1, 2, '2026-09-03T06:08:01.943Z', '2026-09-03T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_1_2', 'receipt-total', 'raw_units = "3"
unit_price = 24.99
discount_pct = 10

units = int(raw_units)
subtotal = units * unit_price
discount = subtotal * discount_pct / 100
total = subtotal - discount', 1, 2, '2026-09-04T06:08:01.943Z', '2026-09-04T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_1_2', 'order-book-total', 'orders = [
    ("A-1", 2, 19.99),
    ("A-2", 1, 5.50),
    ("A-3", 4, 3.25),
]

total = 0
for order_id, quantity, price in orders:
    line_total = quantity * price
    total += line_total
    print(f"{order_id}: ${line_total:.2f}")

print(f"TOTAL: ${total:.2f}")', 1, 2, '2026-09-04T06:08:01.943Z', '2026-09-04T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_1_2', 'member-shipping', 'subtotal = 61.00
member = True

if subtotal >= 75 or member:
    shipping = 0.0
else:
    shipping = 4.95

print(f"shipping: ${shipping:.2f}")', 1, 2, '2026-09-04T06:08:01.943Z', '2026-09-04T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_1_3', 'function-discount', 'def apply_discount(price, pct=10):
    return round(price * (1 - pct / 100), 2)


print(apply_discount(100, 20))', 1, 2, '2026-09-05T06:08:01.943Z', '2026-09-05T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_1_3', 'comprehension-emails', 'def clean_emails(raw):
    return sorted({email.strip().lower() for email in raw if email and "@" in email})


sample = ["  ADA@Example.com ", "ben@example.com", "not-an-email", " CHLOE@EXAMPLE.COM "]
print(clean_emails(sample))', 1, 2, '2026-09-05T06:08:01.943Z', '2026-09-05T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_1_3', 'missing-return', 'def order_total(quantity, unit_price):
    subtotal = quantity * unit_price
    return subtotal


total = order_total(2, 19.99)
print(total + 1)', 1, 2, '2026-09-05T06:08:01.943Z', '2026-09-05T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_2_1', 'normalize-exams', 'import numpy as np

scores = np.array([
    [72.0, 85.0, 91.0],
    [88.0, 79.0, 94.0],
    [95.0, 92.0, 89.0],
    [61.0, 70.0, 78.0],
])

exam_means = scores.mean(axis=0)
exam_stds = scores.std(axis=0)
z = (scores - exam_means) / exam_stds', 1, 2, '2026-09-06T06:08:01.943Z', '2026-09-06T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_2_1', 'discount-table', 'import numpy as np

base = np.array([[10.0], [25.0], [40.0]])
discounts = np.array([0.0, 0.1, 0.25, 0.5])

price_table = base * (1 - discounts)', 1, 2, '2026-09-06T06:08:01.943Z', '2026-09-06T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_2_1', 'center-rows', 'import numpy as np

ratings = np.array([
    [5.0, 4.0, 3.0],
    [2.0, 1.0, 3.0],
    [4.0, 4.0, 1.0],
])

user_avg = ratings.mean(axis=1)
centered = ratings - user_avg[:, None]

print("row sums:", centered.sum(axis=1).round(2))', 1, 2, '2026-09-06T06:08:01.943Z', '2026-09-06T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_2_2', 'vectorized-tax', 'import numpy as np

prices = np.array([45.0, 120.0, 80.0, 250.0])

final_prices = np.where(prices > 100, prices * 1.25, prices * 1.15)', 1, 2, '2026-09-07T06:08:01.943Z', '2026-09-07T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_2_2', 'clip-ages', 'import numpy as np

ages = np.array([12, 17, 24, 68, 81])

cleaned = np.clip(ages, 18, 65)', 1, 2, '2026-09-07T06:08:01.943Z', '2026-09-07T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_2_2', 'segment-spend', 'import numpy as np

spend = np.array([80.0, 220.0, 500.0, 45.0, 150.0])

tier = np.select(
    [spend >= 400, spend >= 200, spend >= 100],
    ["high", "medium", "low"],
    default="basic",
)', 1, 2, '2026-09-07T06:08:01.943Z', '2026-09-07T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_2_2', 'array-and-mask', 'import numpy as np

prices = np.array([12.0, 45.0, 80.0, 120.0])

mask = (prices > 20) & (prices < 100)
selected = prices[mask]

print(selected)', 1, 2, '2026-09-07T06:08:01.943Z', '2026-09-07T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_3_1', 'clean-orders', 'import pandas as pd

raw = pd.DataFrame({
    "order_id": ["A-1", "A-2", "A-3", "A-4"],
    "city": [" lisbon ", "PORTO", "Lisbon", " porto "],
    "quantity": ["2", "1", None, "3"],
    "unit_price": [19.99, 5.50, 12.00, 4.25],
    "ordered_at": ["2026-01-03", "2026-01-04", "2026-02-01", "2026-02-02"],
    "status": ["delivered", "cancelled", "delivered", "delivered"],
})

clean = raw.copy()
clean["city"] = clean["city"].str.strip().str.title()
clean["quantity"] = clean["quantity"].fillna(0).astype(int)
clean["revenue"] = clean["quantity"] * clean["unit_price"]
clean["ordered_at"] = pd.to_datetime(clean["ordered_at"])
clean["month"] = clean["ordered_at"].dt.to_period("M")', 1, 2, '2026-09-08T06:08:01.943Z', '2026-09-08T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_3_1', 'top-orders', 'import pandas as pd

orders = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E"],
    "status": ["delivered", "delivered", "cancelled", "delivered", "delivered"],
    "revenue": [80.0, 20.0, 100.0, 60.0, 50.0],
})

result = (
    orders[(orders["status"] == "delivered") & (orders["revenue"] >= 50)]
    .sort_values("revenue", ascending=False)
    .head(2)
)', 1, 2, '2026-09-08T06:08:01.943Z', '2026-09-08T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_3_1', 'string-revenue', 'import pandas as pd

orders = pd.DataFrame({
    "order_id": ["B-1", "B-2", "B-3"],
    "quantity": ["2", "3", "1"],
    "unit_price": [10.0, 5.0, 20.0],
})

orders["quantity"] = orders["quantity"].astype(int)
orders["revenue"] = orders["quantity"] * orders["unit_price"]
print(orders)', 1, 2, '2026-09-08T06:08:01.943Z', '2026-09-08T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_3_2', 'region-summary', 'import pandas as pd

sales = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E", "F", "G", "H"],
    "region": ["North", "South", "North", "East", "South", "North", "East", "South"],
    "revenue": [120.0, 80.0, 200.0, 50.0, 160.0, 90.0, 70.0, 110.0],
})

summary = (
    sales.groupby("region")
    .agg(
        total_revenue=("revenue", "sum"),
        orders=("order_id", "count"),
        avg_order=("revenue", "mean"),
    )
    .sort_values("total_revenue", ascending=False)
)', 1, 2, '2026-09-09T06:08:01.943Z', '2026-09-09T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_3_2', 'share-of-total', 'import pandas as pd

sales = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E"],
    "region": ["North", "South", "North", "South", "North"],
    "revenue": [120.0, 80.0, 200.0, 160.0, 90.0],
})

share = (sales["revenue"] / sales.groupby("region")["revenue"].transform("sum")).round(3)', 1, 2, '2026-09-09T06:08:01.943Z', '2026-09-09T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_3_2', 'groupby-metric', 'import pandas as pd

sales = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E"],
    "region": ["North", "South", "North", "South", "North"],
    "revenue": [120.0, 80.0, 200.0, 160.0, 90.0],
})

result = sales.groupby("region")["revenue"].sum()
print(result)', 1, 2, '2026-09-09T06:08:01.943Z', '2026-09-09T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_3_3', 'enrich-orders', 'import pandas as pd

customers = pd.DataFrame({
    "customer_id": [1, 2, 3, 4],
    "name": ["Ana", "Ben", "Cara", "Dev"],
    "segment": ["Pro", "Free", "Pro", None],
})

orders = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E"],
    "customer_id": [1, 2, 1, 3, 5],
    "revenue": [120.0, 80.0, 200.0, 50.0, 90.0],
})

enriched = orders.merge(customers, on="customer_id", how="left")
enriched["segment"] = enriched["segment"].fillna("Unknown")', 1, 2, '2026-09-10T06:08:01.943Z', '2026-09-10T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_3_3', 'monthly-wide', 'import pandas as pd

long = pd.DataFrame({
    "region": ["North", "North", "South", "South", "North"],
    "month": ["Jan", "Feb", "Jan", "Feb", "Jan"],
    "revenue": [10.0, 20.0, 30.0, 40.0, 50.0],
})

wide = long.pivot_table(
    index="region",
    columns="month",
    values="revenue",
    aggfunc="sum",
    fill_value=0,
)', 1, 2, '2026-09-10T06:08:01.943Z', '2026-09-10T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_3_3', 'inner-join', 'import pandas as pd

customers = pd.DataFrame({
    "customer_id": [1, 2, 3],
    "segment": ["Pro", "Free", "Pro"],
})

orders = pd.DataFrame({
    "order_id": ["A", "B", "C", "D"],
    "customer_id": [1, 2, 3, 99],
    "revenue": [120.0, 80.0, 60.0, 40.0],
})

result = orders.merge(customers, on="customer_id", how="left")
print(result)', 1, 2, '2026-09-10T06:08:01.943Z', '2026-09-10T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_4_1', 'plot-trend', 'import matplotlib.pyplot as plt

weeks = ["W1", "W2", "W3", "W4", "W5"]
users = [1200, 1350, 1280, 1600, 1750]

fig, ax = plt.subplots(figsize=(6, 3.5))
ax.plot(weeks, users, marker="o", color="#2563eb")
ax.set_title("Weekly active users")
ax.set_xlabel("Week")
ax.set_ylabel("Users")', 1, 2, '2026-09-12T06:08:01.943Z', '2026-09-12T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_4_1', 'plot-bars', 'import matplotlib.pyplot as plt
import numpy as np

regions = ["East", "North", "South"]
totals = [120, 410, 350]

fig, ax = plt.subplots(figsize=(6, 3.5))
order = np.argsort(totals)[::-1]
ax.bar(np.array(regions)[order], np.array(totals)[order], color="#0f766e")
ax.set_title("Revenue by region")
ax.set_ylabel("Revenue ($)")', 1, 2, '2026-09-12T06:08:01.943Z', '2026-09-12T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_4_1', 'plot-labels', 'import matplotlib.pyplot as plt

weeks = ["W1", "W2", "W3", "W4"]
users = [900, 1100, 1050, 1400]

fig, ax = plt.subplots(figsize=(6, 3.5))
ax.plot(weeks, users, marker="o")
ax.set_title("Weekly active users")
ax.set_xlabel("Week")
ax.set_ylabel("Users")

print(ax.get_xlabel(), "|", ax.get_ylabel())', 1, 2, '2026-09-12T06:08:01.943Z', '2026-09-12T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_4_2', 'clean-subscriptions', 'import pandas as pd

raw = pd.DataFrame({
    "customer_id": [1, 2, 3, 4, 5],
    "plan": [" Pro ", "pro", "Basic", "basic", " Pro"],
    "country": [" Portugal", "portugal ", "Spain", "SPAIN", "Portugal"],
    "signup_date": ["2026-01-04", "2026-02-11", "2026-01-19", "2026-03-02", "2026-02-20"],
    "monthly_fee": [49.0, 49.0, 19.0, 19.0, 49.0],
    "seats": [3, None, 1, 2, 4],
    "churned": ["no", "yes", "no", "yes", "no"],
})

clean = raw.copy()
clean["plan"] = clean["plan"].str.strip().str.lower()
clean["country"] = clean["country"].str.strip().str.lower()
clean["seats"] = clean["seats"].fillna(1).astype(int)
clean["signup_date"] = pd.to_datetime(clean["signup_date"])
clean["churned"] = clean["churned"].str.strip().str.lower().eq("yes")
clean["mrr"] = (clean["monthly_fee"] * clean["seats"]).round(2)', 1, 2, '2026-09-13T06:08:01.943Z', '2026-09-13T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_4_2', 'plan-scorecard', 'import pandas as pd

clean = pd.DataFrame({
    "customer_id": [1, 2, 3, 4, 5, 6],
    "plan": ["pro", "pro", "basic", "basic", "pro", "basic"],
    "mrr": [147.0, 49.0, 19.0, 38.0, 196.0, 57.0],
    "churned": [False, True, False, True, True, False],
})

scorecard = (
    clean.groupby("plan")
    .agg(
        customers=("customer_id", "count"),
        mrr=("mrr", "sum"),
        churned=("churned", "sum"),
    )
)
scorecard["churn_rate"] = (scorecard["churned"] / scorecard["customers"]).round(2)
scorecard = scorecard.sort_values("mrr", ascending=False)', 1, 2, '2026-09-13T06:08:01.943Z', '2026-09-13T06:08:01.943Z'),
('usr_student', 'les_python_for_data_science_4_2', 'churn-rate', 'import pandas as pd

df = pd.DataFrame({
    "customer_id": [1, 2, 3, 4],
    "churned": ["no", "yes", "no", "yes"],
})

churn_rate = df["churned"].eq("yes").mean()
print(churn_rate)', 1, 2, '2026-09-13T06:08:01.943Z', '2026-09-13T06:08:01.943Z');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_1', 'usr_seed000000', 'crs_python_for_data_science', 5, 'Best course I''ve taken on the topic', 'The explanations build intuition before the math, and every concept is backed by code you actually run. I finally understand what''s happening under the hood instead of copying snippets.', '2026-07-25T06:08:01.943Z', '2026-07-25T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000000');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_2', 'usr_seed000002', 'crs_python_for_data_science', 5, 'Worth every minute', 'Clear, well-paced and incredibly practical. The projects were challenging in the right way, and I used what I learned at work within a week of finishing.', '2026-09-29T06:08:01.943Z', '2026-09-29T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000002');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_3', 'usr_seed000004', 'crs_python_for_data_science', 5, 'Exceptional production quality', 'Beautifully structured. The quizzes caught gaps in my understanding and the AI tutor was surprisingly helpful when I got stuck on the harder sections.', '2026-08-01T06:08:01.943Z', '2026-08-01T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000004');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_4', 'usr_seed000008', 'crs_python_for_data_science', 5, 'Helped me land an ML role', 'I was a backend engineer trying to move into ML. This course gave me the vocabulary and the hands-on confidence to pass technical interviews. Highly recommended.', '2026-09-13T06:08:01.943Z', '2026-09-13T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000008');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_5', 'usr_seed000009', 'crs_python_for_data_science', 5, 'Dense but fantastic', 'This is not a fluffy overview — it goes deep. Expect to pause and re-watch, but the payoff is real. The instructor clearly knows the material at a research level.', '2026-08-17T06:08:01.943Z', '2026-08-17T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000009');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_6', 'usr_seed00000a', 'crs_python_for_data_science', 5, 'Finally clicked', 'I''d tried learning this from scattered blog posts and papers. Having a single coherent narrative with good visuals made it click. The capstone tied everything together.', '2026-10-22T06:08:01.943Z', '2026-10-22T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000a');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_7', 'usr_seed00000e', 'crs_python_for_data_science', 5, 'Great instructor, great community', 'Questions in the Q&A got thoughtful answers quickly. The notes feature and lesson resources made it easy to review before my exam.', '2026-10-14T06:08:01.943Z', '2026-10-14T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000e');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_8', 'usr_seed00000j', 'crs_python_for_data_science', 5, 'Solid and practical', 'Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I''d take another course from this instructor.', '2026-07-02T06:08:01.943Z', '2026-07-02T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000j');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_9', 'usr_seed00000k', 'crs_python_for_data_science', 5, 'Clear explanations', 'The visual explanations of difficult concepts are the best I''ve seen. Code is clean and modern. Updated content too, which matters a lot in this field.', '2026-07-28T06:08:01.943Z', '2026-07-28T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000k');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_10', 'usr_seed00000l', 'crs_python_for_data_science', 5, 'Best course I''ve taken on the topic', 'The explanations build intuition before the math, and every concept is backed by code you actually run. I finally understand what''s happening under the hood instead of copying snippets.', '2026-09-21T06:08:01.943Z', '2026-09-21T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000l');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_11', 'usr_seed00000n', 'crs_python_for_data_science', 5, 'Worth every minute', 'Clear, well-paced and incredibly practical. The projects were challenging in the right way, and I used what I learned at work within a week of finishing.', '2026-09-13T06:08:01.943Z', '2026-09-13T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000n');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_12', 'usr_seed00000q', 'crs_python_for_data_science', 5, 'Exceptional production quality', 'Beautifully structured. The quizzes caught gaps in my understanding and the AI tutor was surprisingly helpful when I got stuck on the harder sections.', '2026-09-15T06:08:01.943Z', '2026-09-15T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000q');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_13', 'usr_seed00000r', 'crs_python_for_data_science', 5, 'Helped me land an ML role', 'I was a backend engineer trying to move into ML. This course gave me the vocabulary and the hands-on confidence to pass technical interviews. Highly recommended.', '2026-07-26T06:08:01.943Z', '2026-07-26T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000r');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_14', 'usr_seed00000s', 'crs_python_for_data_science', 5, 'Dense but fantastic', 'This is not a fluffy overview — it goes deep. Expect to pause and re-watch, but the payoff is real. The instructor clearly knows the material at a research level.', '2026-07-10T06:08:01.943Z', '2026-07-10T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000s');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_15', 'usr_seed00000u', 'crs_python_for_data_science', 5, 'Finally clicked', 'I''d tried learning this from scattered blog posts and papers. Having a single coherent narrative with good visuals made it click. The capstone tied everything together.', '2026-10-21T06:08:01.943Z', '2026-10-21T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000u');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_16', 'usr_seed00000y', 'crs_python_for_data_science', 5, 'Great instructor, great community', 'Questions in the Q&A got thoughtful answers quickly. The notes feature and lesson resources made it easy to review before my exam.', '2026-06-28T06:08:01.943Z', '2026-06-28T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000y');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_17', 'usr_seed000012', 'crs_python_for_data_science', 5, 'Solid and practical', 'Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I''d take another course from this instructor.', '2026-07-02T06:08:01.943Z', '2026-07-02T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000012');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_18', 'usr_seed000013', 'crs_python_for_data_science', 5, 'Clear explanations', 'The visual explanations of difficult concepts are the best I''ve seen. Code is clean and modern. Updated content too, which matters a lot in this field.', '2026-08-01T06:08:01.943Z', '2026-08-01T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000013');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_19', 'usr_seed000015', 'crs_python_for_data_science', 5, 'Best course I''ve taken on the topic', 'The explanations build intuition before the math, and every concept is backed by code you actually run. I finally understand what''s happening under the hood instead of copying snippets.', '2026-07-12T06:08:01.943Z', '2026-07-12T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000015');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_20', 'usr_seed000016', 'crs_python_for_data_science', 5, 'Worth every minute', 'Clear, well-paced and incredibly practical. The projects were challenging in the right way, and I used what I learned at work within a week of finishing.', '2026-10-20T06:08:01.943Z', '2026-10-20T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000016');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_21', 'usr_seed000017', 'crs_python_for_data_science', 5, 'Exceptional production quality', 'Beautifully structured. The quizzes caught gaps in my understanding and the AI tutor was surprisingly helpful when I got stuck on the harder sections.', '2026-08-14T06:08:01.943Z', '2026-08-14T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000017');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_22', 'usr_seed00001b', 'crs_python_for_data_science', 5, 'Helped me land an ML role', 'I was a backend engineer trying to move into ML. This course gave me the vocabulary and the hands-on confidence to pass technical interviews. Highly recommended.', '2026-07-08T06:08:01.943Z', '2026-07-08T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001b');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_23', 'usr_seed00001e', 'crs_python_for_data_science', 5, 'Dense but fantastic', 'This is not a fluffy overview — it goes deep. Expect to pause and re-watch, but the payoff is real. The instructor clearly knows the material at a research level.', '2026-07-28T06:08:01.943Z', '2026-07-28T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001e');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_24', 'usr_seed00001f', 'crs_python_for_data_science', 5, 'Finally clicked', 'I''d tried learning this from scattered blog posts and papers. Having a single coherent narrative with good visuals made it click. The capstone tied everything together.', '2026-08-18T06:08:01.943Z', '2026-08-18T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001f');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_25', 'usr_seed00001h', 'crs_python_for_data_science', 4, 'Great instructor, great community', 'Questions in the Q&A got thoughtful answers quickly. The notes feature and lesson resources made it easy to review before my exam.', '2026-06-26T06:08:01.943Z', '2026-06-26T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001h');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_26', 'usr_seed00001j', 'crs_python_for_data_science', 4, 'Solid and practical', 'Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I''d take another course from this instructor.', '2026-07-19T06:08:01.943Z', '2026-07-19T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001j');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_27', 'usr_seed00001l', 'crs_python_for_data_science', 4, 'Clear explanations', 'The visual explanations of difficult concepts are the best I''ve seen. Code is clean and modern. Updated content too, which matters a lot in this field.', '2026-10-08T06:08:01.943Z', '2026-10-08T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001l');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_28', 'usr_seed00001r', 'crs_python_for_data_science', 4, 'Best course I''ve taken on the topic', 'The explanations build intuition before the math, and every concept is backed by code you actually run. I finally understand what''s happening under the hood instead of copying snippets.', '2026-06-25T06:08:01.943Z', '2026-06-25T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001r');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_29', 'usr_seed00001s', 'crs_python_for_data_science', 4, 'Worth every minute', 'Clear, well-paced and incredibly practical. The projects were challenging in the right way, and I used what I learned at work within a week of finishing.', '2026-10-09T06:08:01.943Z', '2026-10-09T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001s');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_30', 'usr_seed00001t', 'crs_python_for_data_science', 4, 'Exceptional production quality', 'Beautifully structured. The quizzes caught gaps in my understanding and the AI tutor was surprisingly helpful when I got stuck on the harder sections.', '2026-10-09T06:08:01.943Z', '2026-10-09T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001t');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_31', 'usr_seed00001u', 'crs_python_for_data_science', 4, 'Helped me land an ML role', 'I was a backend engineer trying to move into ML. This course gave me the vocabulary and the hands-on confidence to pass technical interviews. Highly recommended.', '2026-07-18T06:08:01.943Z', '2026-07-18T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001u');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_32', 'usr_seed00001x', 'crs_python_for_data_science', 4, 'Dense but fantastic', 'This is not a fluffy overview — it goes deep. Expect to pause and re-watch, but the payoff is real. The instructor clearly knows the material at a research level.', '2026-10-06T06:08:01.943Z', '2026-10-06T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001x');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_33', 'usr_seed000020', 'crs_python_for_data_science', 4, 'Finally clicked', 'I''d tried learning this from scattered blog posts and papers. Having a single coherent narrative with good visuals made it click. The capstone tied everything together.', '2026-07-20T06:08:01.943Z', '2026-07-20T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000020');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_34', 'usr_seed000022', 'crs_python_for_data_science', 4, 'Great instructor, great community', 'Questions in the Q&A got thoughtful answers quickly. The notes feature and lesson resources made it easy to review before my exam.', '2026-08-29T06:08:01.943Z', '2026-08-29T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000022');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_35', 'usr_seed000023', 'crs_python_for_data_science', 4, 'Solid and practical', 'Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I''d take another course from this instructor.', '2026-08-11T06:08:01.943Z', '2026-08-11T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000023');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_36', 'usr_seed000025', 'crs_python_for_data_science', 4, 'Clear explanations', 'The visual explanations of difficult concepts are the best I''ve seen. Code is clean and modern. Updated content too, which matters a lot in this field.', '2026-09-26T06:08:01.943Z', '2026-09-26T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000025');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_37', 'usr_seed000026', 'crs_python_for_data_science', 4, 'Best course I''ve taken on the topic', 'The explanations build intuition before the math, and every concept is backed by code you actually run. I finally understand what''s happening under the hood instead of copying snippets.', '2026-08-24T06:08:01.943Z', '2026-08-24T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000026');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_38', 'usr_seed000028', 'crs_python_for_data_science', 4, 'Worth every minute', 'Clear, well-paced and incredibly practical. The projects were challenging in the right way, and I used what I learned at work within a week of finishing.', '2026-07-06T06:08:01.943Z', '2026-07-06T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000028');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_39', 'usr_seed00002b', 'crs_python_for_data_science', 4, 'Exceptional production quality', 'Beautifully structured. The quizzes caught gaps in my understanding and the AI tutor was surprisingly helpful when I got stuck on the harder sections.', '2026-10-14T06:08:01.943Z', '2026-10-14T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002b');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_40', 'usr_seed00002f', 'crs_python_for_data_science', 4, 'Helped me land an ML role', 'I was a backend engineer trying to move into ML. This course gave me the vocabulary and the hands-on confidence to pass technical interviews. Highly recommended.', '2026-07-25T06:08:01.943Z', '2026-07-25T06:08:01.943Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002f');

UPDATE courses SET rating_avg = coalesce((SELECT avg(rating) FROM reviews WHERE course_id = 'crs_python_for_data_science'), 0), rating_count = (SELECT count(*) FROM reviews WHERE course_id = 'crs_python_for_data_science') WHERE id = 'crs_python_for_data_science';
