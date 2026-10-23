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
('crs_python_for_data_science', 'python-for-data-science', 'Python for Data Science', 'NumPy, pandas, visualization and analysis — the foundation for everything in ML.', 'Data science starts with a simple question and a messy table. This course teaches the everyday craft of turning raw data into answers: writing clear Python, reshaping tables with pandas, cleaning the mistakes that every real dataset contains, drawing charts that tell the truth, and presenting what you found.

## Learn by doing

- **Runnable code everywhere.** Every idea is a cell you can edit, run and break in the page.
- **Real analysis workflows.** You clean a messy sales table, reshape it, and answer business questions with it.
- **Challenges with hidden tests.** Your functions are checked on new data, so a hard-coded answer will not pass.
- **Debug challenges.** You fix the mistakes analysts actually make: chained assignment that silently does nothing, joins that duplicate rows, averages over missing values, and charts with misleading axes.
- **Predict-the-output questions** that build a feel for how pandas behaves before you run it.

## What you''ll cover

- **Python for data:** clean containers, comprehensions and functions you can test.
- **NumPy for data:** arrays, boolean masks and missing values, as the engine under pandas.
- **pandas:** DataFrames, selection, cleaning, grouping, joining, reshaping and time series.
- **Visualization:** matplotlib from first principles, pandas plotting, and the design rules behind honest charts.
- **Exploratory analysis:** a repeatable workflow, outliers, relationships, and a capstone analysis from start to finish.

## Why this course?

Every machine-learning project begins here. Most of the hours in a data job go into loading, checking, cleaning and understanding data, not into fancy models. This course gives you those skills in the order you will use them.

No prior experience is needed. You will get the most from it by running every cell and trying to predict the output first.', 'cat_data-science', 'usr_arjun', 'beginner', 'English', 0, NULL, 'USD', NULL, NULL, 210, 'published', 0, '["Write clean, idiomatic Python for data work","Select, filter, clean and reshape tabular data with pandas","Group, join and summarize data the way analysts do every day","Work with time series: parse dates, resample and smooth","Plot honest, readable charts with matplotlib and pandas","Run a complete exploratory data analysis and report what you found"]', '["No programming experience required. You will learn Python as you go","A modern browser. Python, NumPy, pandas and matplotlib run in the page"]', '["Complete beginners who want a career in data","Analysts moving from spreadsheets to code","Engineers who need to explore data before building models"]', '["Python","pandas","NumPy","Free"]', 306, 19, 0, 0, 88420, '2025-12-11T06:40:00.179Z', '2025-11-11T06:40:00.179Z', '2026-10-14T06:40:00.179Z');

INSERT INTO sections (id, course_id, title, position, created_at) VALUES
('sec_python_for_data_science_1', 'crs_python_for_data_science', 'Python for Data Work', 0, '2026-06-25T06:40:00.179Z'),
('sec_python_for_data_science_2', 'crs_python_for_data_science', 'NumPy for Data', 1, '2026-06-25T06:40:00.179Z'),
('sec_python_for_data_science_3', 'crs_python_for_data_science', 'pandas Essentials', 2, '2026-06-25T06:40:00.179Z'),
('sec_python_for_data_science_4', 'crs_python_for_data_science', 'Visualization', 3, '2026-06-25T06:40:00.179Z'),
('sec_python_for_data_science_5', 'crs_python_for_data_science', 'Exploratory Data Analysis', 4, '2026-06-25T06:40:00.179Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_python_for_data_science_1_1', 'sec_python_for_data_science_1', 'crs_python_for_data_science', 'How this course works', 'interactive', 0, 480, NULL, NULL, 'Welcome to **Python for Data Science**. Almost every data question you will ever answer follows the same path: load a table, check that it means what you think it means, clean it, reshape it, look at it, and then say something true about it. This course walks that path with you, one step at a time, using the tools the profession uses: Python, NumPy, pandas and matplotlib.

You will not just read about these tools. Every example is a live cell, and every challenge is a function you write and test. By the end you will have analyzed a messy sales dataset from start to finish.

> **How to use this lesson:** read a little, run a little. Edit a value in a cell and run it again to see what changes.

## Run your first cell

Click **Run** on the cell below, or click inside it and press **Shift + Enter**.

```python run
import pandas as pd

sales = pd.DataFrame({
    "city": ["Lyon", "Paris", "Lyon", "Nice"],
    "units": [3, 7, 2, 5],
    "price": [9.5, 8.0, 9.5, 12.0],
})
print(sales)
```

The first run can take a few seconds, because the browser downloads pandas the first time you import it. Later cells reuse it.

## Cells share memory, like a notebook

Variables you create in one cell are available in the cells below it, once you have run the earlier cell.

```python run
sales["revenue"] = sales["units"] * sales["price"]
sales
```

The last line of a cell is shown automatically, so ending with a table is a quick way to look at it. **Run all** executes every cell in order, and **Restart** clears memory.

## Errors are information

Analysts meet errors all day. Here is one on purpose:

```python run error
sales["discount"]
```

Read the message: pandas says the column does not exist. The error card explains the problem in plain language. Most of the time, the fix is to look at the data you actually have, which is the habit this course is built around.

## Predict before you run

Experienced analysts predict a result before running it. Read the code, choose an answer, then run it.

```python predict id=predict-filter title="How many rows survive the filter?"
import pandas as pd
df = pd.DataFrame({"price": [5, 12, 20, 9]})
print(len(df[df["price"] > 9]))
--- options
* 2
3
4
1
--- explain
Only 12 and 20 are strictly greater than 9. The 9 is excluded because `>` is a strict comparison. The filter keeps two rows, so `len` returns 2.
```

## Your first challenge

A **challenge** asks you to write a function. The course runs it against hidden tests on new data, so it has to be correct in general, not only for the example. Press **Check** to test your code, and use the hints if you get stuck.

```python exercise id=total-revenue title="Total revenue"
import pandas as pd

# TODO: `total_revenue(df)` should return the sum of the `units * price` for every row, as one number.
def total_revenue(df):
    ...
--- solution
import pandas as pd

def total_revenue(df):
    return (df["units"] * df["price"]).sum()
--- test
import pandas as pd
sample = pd.DataFrame({"units": [2, 1], "price": [3.0, 10.0]})
result = total_revenue(sample)
assert result is not None, "Replace the `...` in `total_revenue` with code that returns the total."
assert abs(result - 16.0) < 1e-9, f"2 × 3 + 1 × 10 = 16, but you returned {result!r}."
other = pd.DataFrame({"units": [4, 0, 5], "price": [2.5, 99.0, 1.0]})
assert abs(total_revenue(other) - 15.0) < 1e-9, "Rows with zero units add nothing. Check that you multiply column by column."
--- hint
Multiply the two columns elementwise: `df["units"] * df["price"]`. Then add up the result with `.sum()`.
--- hint
`return (df["units"] * df["price"]).sum()`.
```

## Debug a silent mistake

A **debug challenge** starts with code that runs but does the wrong thing. Here, a discount is meant to apply to expensive items only, but the assignment goes to a copy and changes nothing.

```python debug id=chained-assign title="Make the discount stick"
import pandas as pd

df = pd.DataFrame({"item": ["pen", "lamp", "desk"], "price": [2.0, 40.0, 150.0]})
df[df["price"] > 30]["price"] = df["price"] * 0.9      # does this change df?
print(df)
--- solution
import pandas as pd

df = pd.DataFrame({"item": ["pen", "lamp", "desk"], "price": [2.0, 40.0, 150.0]})
df.loc[df["price"] > 30, "price"] = df["price"] * 0.9
print(df)
--- test
expected = [2.0, 36.0, 135.0]
assert list(df["price"].round(6)) == expected, f"Prices should be {expected} after a 10% discount on items over 30, but they are {list(df[''price''].round(6))}. Use one `.loc` call that selects rows and the column together."
--- hint
Chained indexing, `df[mask]["price"] = ...`, can assign to a temporary copy. A single `.loc[rows, column]` assignment updates the original DataFrame.
--- hint
`df.loc[df["price"] > 30, "price"] = df["price"] * 0.9`, but note the right side is the full column; `.loc` assigns it only to the selected rows.
```

## Recap

- A pandas DataFrame is a table whose columns are series. Operations on columns are vectorized.
- The last line of a cell is shown automatically, so end with a table to look at it.
- Read error messages: they usually name the column or line at fault.
- Write functions that take data and return answers, then test them on fresh data.

**Up next:** Python''s core data containers, and the comprehensions that turn one table of records into another.
', 1, '[]', '[{"title":"pandas documentation: getting started","url":"https://pandas.pydata.org/docs/getting_started/index.html"},{"title":"Python for Data Analysis (Wes McKinney, free online chapters)","url":"https://wesmckinney.com/book/"},{"title":"Matplotlib tutorials","url":"https://matplotlib.org/stable/tutorials/index.html"}]', '2026-06-25T06:40:00.179Z', '2026-10-19T06:40:00.179Z'),
('les_python_for_data_science_1_2', 'sec_python_for_data_science_1', 'crs_python_for_data_science', 'Containers, loops and comprehensions for data', 'interactive', 1, 960, NULL, NULL, 'Before you can analyze a table, you need to handle the raw records it came from. In Python those are usually lists of dictionaries, one per row, and the core skills are the same ones you use with pandas later: picking values out, counting, sorting and transforming. This lesson builds those habits with the built-in containers and comprehensions.

## Lists, dictionaries and sets

A **list** keeps items in order. A **dictionary** maps keys to values, which suits one record with named fields. A **set** keeps only unique items.

```python run
orders = [
    {"customer": "Ana", "city": "Lyon", "amount": 42.0},
    {"customer": "Ben", "city": "Paris", "amount": 17.5},
    {"customer": "Ana", "city": "Lyon", "amount": 8.0},
    {"customer": "Cam", "city": "Nice", "amount": 30.0},
]

print("first order:", orders[0])
print("number of orders:", len(orders))
print("distinct cities:", {order["city"] for order in orders})
```

Notice that the set of cities has no duplicates and no order. Use a set when you only care about membership.

## Counting with a dictionary

Counting how often each value occurs is one of the most common data tasks. The pattern is a dictionary that starts empty and grows as you read each record.

```python run
counts = {}
for order in orders:
    city = order["city"]
    counts[city] = counts.get(city, 0) + 1

print(counts)
```

`counts.get(city, 0)` returns the current count, or zero for a city not yet seen. pandas will do this in one line later, but understanding the loop tells you what it is doing.

## Comprehensions: transform in one line

A **list comprehension** builds a new list from an old one. Read it as "for each item, keep this expression, optionally filtered by this condition".

```python run
big_orders = [o["amount"] for o in orders if o["amount"] >= 20]
print("large order amounts:", big_orders)

upper_customers = sorted({o["customer"].upper() for o in orders})
print("customers, shouted:", upper_customers)
```

A **dictionary comprehension** works the same way and is handy for lookups:

```python run
total_by_customer = {}
for o in orders:
    total_by_customer[o["customer"]] = total_by_customer.get(o["customer"], 0) + o["amount"]
print(total_by_customer)
```

## Sorting records

`sorted` returns a new list, and the `key` argument says what to compare. Pass `reverse=True` for descending order.

```python run
by_amount = sorted(orders, key=lambda o: o["amount"], reverse=True)
for o in by_amount:
    print(f"{o[''customer'']:<4} {o[''amount'']:>6.2f}")
```

## Challenge: the busiest city

```python exercise id=busiest-city title="Find the city with the most orders"
# TODO: `busiest_city(orders)` takes a list of order dictionaries (each has a "city" key)
# and returns the city that appears most often. If two cities tie, return the one that comes
# first alphabetically.
def busiest_city(orders):
    ...
--- solution
def busiest_city(orders):
    counts = {}
    for order in orders:
        counts[order["city"]] = counts.get(order["city"], 0) + 1
    return sorted(counts, key=lambda city: (-counts[city], city))[0]
--- test
sample = [{"city": "Lyon"}, {"city": "Paris"}, {"city": "Lyon"}]
result = busiest_city(sample)
assert result is not None, "Replace the `...` in `busiest_city` with code that returns a city name."
assert result == "Lyon", f"Lyon has two orders and Paris has one, so the answer is Lyon, but you returned {result!r}."
tie = [{"city": "Nice"}, {"city": "Brest"}]
assert busiest_city(tie) == "Brest", "On a tie, return the alphabetically first city."
big = [{"city": c} for c in ["Oslo"] * 3 + ["Rome"] * 5 + ["Bern"] * 5]
assert busiest_city(big) == "Bern", "Rome and Bern tie at five, and Bern comes first alphabetically."
--- hint
Count the cities first, as in the counting example above. Then choose the best city, with ties broken alphabetically.
--- hint
`sorted(counts, key=lambda city: (-counts[city], city))[0]` sorts by highest count first, then by name, and takes the first.
```

## Challenge: total spent per customer

```python exercise id=spend-per-customer title="Total spend for each customer"
# TODO: `spend_by_customer(orders)` takes a list of order dictionaries with "customer" and "amount" keys.
# Return a dictionary mapping each customer to the sum of their amounts.
def spend_by_customer(orders):
    ...
--- solution
def spend_by_customer(orders):
    totals = {}
    for o in orders:
        totals[o["customer"]] = totals.get(o["customer"], 0) + o["amount"]
    return totals
--- test
sample = [{"customer": "Ana", "amount": 10.0}, {"customer": "Ben", "amount": 4.0}, {"customer": "Ana", "amount": 2.5}]
result = spend_by_customer(sample)
assert result is not None, "Replace the `...` in `spend_by_customer` with code that returns the dictionary."
assert result == {"Ana": 12.5, "Ben": 4.0}, f"Ana spent 10 + 2.5 = 12.5 and Ben spent 4, but you returned {result}."
assert spend_by_customer([]) == {}, "No orders should give an empty dictionary."
--- hint
Start from an empty dictionary and add each order''s amount to its customer''s running total, using `get` with a default of 0.
--- hint
`totals[o["customer"]] = totals.get(o["customer"], 0) + o["amount"]` inside a loop.
```

## Debug the shared list

This code tries to build a 3 × 3 grid of zeros, but changing one cell changes a whole column.

```python debug id=shared-rows title="Build independent rows"
grid = [[0] * 3] * 3          # every row is the same list object
grid[0][1] = 9
print(grid)
--- solution
grid = [[0] * 3 for _ in range(3)]    # a new list for each row
grid[0][1] = 9
print(grid)
--- test
assert grid == [[0, 9, 0], [0, 0, 0], [0, 0, 0]], f"Only the first row should change, but the grid is {grid}. Build each row as its own list."
--- hint
`[[0] * 3] * 3` repeats one list reference three times. Changing one row changes all of them.
--- hint
Use a comprehension so that each row is created fresh: `[[0] * 3 for _ in range(3)]`.
```

## Predict the output

```python predict id=predict-counts title="What does the dictionary contain?"
words = ["a", "b", "a", "c", "a"]
counts = {}
for w in words:
    counts[w] = counts.get(w, 0) + 1
print(counts["a"])
--- options
* 3
2
1
5
--- explain
The letter a appears three times in the list, and each occurrence adds one to its count. The `get` with a default of 0 means the first occurrence starts from zero.
```

## Recap

- Lists keep order, dictionaries map keys to values, and sets keep unique items.
- Counting with `get(key, 0) + 1` is the pattern behind every group-by.
- Comprehensions transform and filter collections in one readable expression.
- `sorted` takes a `key` to decide what to compare, and returns a new list.

**Up next:** functions. Turning these loops into named, tested functions is what makes an analysis repeatable.
', 0, '[]', '[]', '2026-06-25T06:40:00.179Z', '2026-10-19T06:40:00.179Z'),
('les_python_for_data_science_1_3', 'sec_python_for_data_science_1', 'crs_python_for_data_science', 'Functions you can trust', 'interactive', 2, 960, NULL, NULL, 'An analysis you cannot repeat is not an analysis. Once a calculation lives in a function with a clear input and output, you can run it on next month''s data, test it, and explain it to a colleague. This lesson shows what makes a function trustworthy in data work: clear inputs, return values instead of printing, and never changing the data you were given.

## Inputs, outputs and return values

A function takes arguments and gives back a result with `return`. A function that only prints cannot be reused, because its answer disappears.

```python run
def average_price(prices):
    """Return the mean of a list of prices, or None if there are none."""
    if not prices:
        return None
    return sum(prices) / len(prices)

print(average_price([2.0, 4.0, 9.0]))
print(average_price([]))
```

The docstring is the text in triple quotes. It tells the next reader what the function expects and returns. Write it for every function you share.

## Default arguments

A default value makes an argument optional. Keep defaults simple and never use a mutable object such as a list as one, for a reason you will see in the debug challenge.

```python run
def format_money(amount, currency="EUR", decimals=2):
    return f"{amount:,.{decimals}f} {currency}"

print(format_money(1234.5))
print(format_money(1234.5, currency="USD", decimals=0))
```

## Pure functions and the input you were given

A **pure** function returns a result and leaves its inputs alone. Impure functions change the data they were passed, so a caller can be surprised later. In analysis, surprises are expensive.

```python run
prices = [10.0, 25.0, 40.0]

def with_tax(values, rate):
    return [v * (1 + rate) for v in values]    # builds a new list

taxed = with_tax(prices, 0.2)
print("original:", prices)
print("taxed:   ", [round(v, 2) for v in taxed])
```

The original list is unchanged, and you can call the function as often as you like.

## Lambdas and sorting by a rule

A **lambda** is a small unnamed function, useful as a `key` for sorting. A named function is better when the logic is longer than one line.

```python run
products = [("kettle", 35.0), ("mug", 6.5), ("tea", 6.5), ("grinder", 80.0)]

by_price = sorted(products, key=lambda p: (p[1], p[0]))   # price, then name
for name, price in by_price:
    print(f"{name:<8} {price:>6.2f}")
```

## Challenge: parse messy prices

Exported data often stores prices as text, with currency symbols and missing entries. Your job is to turn that list into clean numbers, skipping the entries that cannot be read.

```python exercise id=clean-prices title="Parse messy price strings"
# TODO: `clean_prices(values)` takes a list of strings such as "$12.50", "7", " 3,5 " or "n/a".
# Return a list of floats for every value that can be read. Remove "$", spaces, and turn a
# decimal comma into a dot. Skip anything that cannot be read as a number, including "" and "n/a".
def clean_prices(values):
    ...
--- solution
def clean_prices(values):
    cleaned = []
    for raw in values:
        text = raw.replace("$", "").replace(" ", "").replace(",", ".")
        try:
            cleaned.append(float(text))
        except ValueError:
            continue
    return cleaned
--- test
result = clean_prices(["$12.50", "7", " 3,5 ", "n/a", ""])
assert result is not None, "Replace the `...` in `clean_prices` with code that returns the cleaned list."
assert result == [12.5, 7.0, 3.5], f"Expected [12.5, 7.0, 3.5], but you returned {result}."
assert clean_prices([]) == [], "An empty list should give an empty list."
assert clean_prices(["$1,000.00"]) == [], "This value has two decimal separators after the comma is changed to a dot, so it cannot be read as one number and should be skipped."
assert clean_prices(["$0.99", "$100"]) == [0.99, 100.0], "Dollar signs should be removed before converting."
--- hint
For each value, first remove the characters you do not want, then try `float(...)`. Catch the `ValueError` to skip values that are not numbers.
--- hint
Use `raw.replace("$", "")`, then the spaces, then the commas, and convert the result with `float` inside a `try` block.
```

## Challenge: summarize a column

```python exercise id=summarize-values title="Summarize a list of numbers"
# TODO: `summarize(values)` returns a dictionary with the keys "count", "mean", "min" and "max" for a non-empty
# list of numbers. For an empty list, return None.
def summarize(values):
    ...
--- solution
def summarize(values):
    if not values:
        return None
    return {"count": len(values), "mean": sum(values) / len(values), "min": min(values), "max": max(values)}
--- test
result = summarize([2.0, 4.0, 9.0])
assert result is not None, "Replace the `...` in `summarize` with code that returns the dictionary."
assert result == {"count": 3, "mean": 5.0, "min": 2.0, "max": 9.0}, f"For [2, 4, 9] the summary is count 3, mean 5, min 2, max 9, but you returned {result}."
assert summarize([]) is None, "An empty list has nothing to summarize, so return None."
--- hint
Use `len`, `sum`, `min` and `max` on the list. Divide the sum by the count for the mean.
--- hint
Check for an empty list first with `if not values: return None`.
```

## Debug the default that remembers

This function is meant to collect each analyst''s notes into a fresh list, but the notes keep piling up across calls.

```python debug id=mutable-default title="Stop sharing one list between calls"
def add_note(note, notes=[]):
    notes.append(note)
    return notes

add_note("first call")
print(add_note("second call"))
--- solution
def add_note(note, notes=None):
    if notes is None:
        notes = []
    notes.append(note)
    return notes

add_note("first call")
print(add_note("second call"))
--- test
assert add_note("a") == ["a"], "A call with a new note should return a list containing just that note."
assert add_note("b") == ["b"], f"Each call without a list should start fresh, but the second call returned {add_note(''b'')}. Avoid a mutable default argument."
--- hint
Python creates a default list once, when the function is defined, so every call shares it.
--- hint
Use `None` as the default and create the list inside the function when it is `None`.
```

## Predict the result

```python predict id=predict-return title="What does the function return?"
def total(values):
    result = 0
    for v in values:
        result += v
    return result

print(total([1, 2, 3]) + total([4]))
--- options
* 10
6
4
7
--- explain
The first call sums 1, 2 and 3 to 6. The second sums 4 to 4. Adding the two results gives 10. Each call has its own `result` variable, so nothing carries over between calls.
```

## Recap

- Return values, do not print them, so results can be reused and tested.
- Write a docstring describing what goes in and comes out.
- Prefer pure functions that build new data rather than changing their inputs.
- Never use a mutable default argument. Use `None` and create the object inside the function.

**Up next:** NumPy arrays. They are the engine underneath pandas, and they make calculations over whole columns fast and short.
', 0, '[]', '[]', '2026-06-25T06:40:00.179Z', '2026-10-19T06:40:00.179Z'),
('les_python_for_data_science_2_1', 'sec_python_for_data_science_2', 'crs_python_for_data_science', 'Arrays, boolean masks and vectorized thinking', 'interactive', 0, 960, NULL, NULL, 'pandas stores each column as a NumPy array, so the same ideas work in both. An array lets you write "multiply every price by the tax rate" in one expression, and it runs the loop for you in fast compiled code. Once you think in whole columns, a great deal of analysis becomes a short line of code.

## Vectorized arithmetic

```python run
import numpy as np

units = np.array([3, 7, 2, 5])
price = np.array([9.5, 8.0, 9.5, 12.0])

revenue = units * price              # one multiplication per row, no loop
print("revenue:", revenue)
print("total:", revenue.sum())
```

Both arrays have four elements, and the multiplication pairs them up position by position. That is the vectorized way of thinking: describe the calculation for the whole column.

## Boolean masks: select by condition

Comparing an array with a value gives a **boolean mask**, an array of `True` and `False`. Using the mask to index the array keeps only the `True` positions.

```python run
mask = revenue > 30
print("mask:", mask)
print("rows with revenue above 30:", revenue[mask])
print("how many:", mask.sum())
```

`True` counts as 1, so `mask.sum()` counts the matches. This is how analysts answer "how many orders were large?" without writing a loop.

## Combining conditions: `&` and `|`

To combine two masks, use `&` for "and" and `|` for "or". Each condition needs its own parentheses, because `&` binds tighter than comparisons.

```python run
units_ok = units >= 3
price_ok = price < 10
both = (units_ok) & (price_ok)
print("both conditions:", both)
print("either condition:", (units_ok) | (price_ok))
```

> **Pitfall:** `and` and `or` do not work on arrays. They raise an error for arrays with more than one element, which is a good thing, because it stops a silent mistake.

## `np.where`: choose a value per row

`np.where(condition, if_true, if_false)` builds a new array, taking a value from one of two options for each position.

```python run
discount = np.where(price > 9, 0.10, 0.0)
final_price = price * (1 - discount)
print("discount per row:", discount)
print("final prices:", np.round(final_price, 2))
```

## Aggregations and axes

Functions such as `sum`, `mean` and `max` reduce an array. On a two-dimensional table, the `axis` argument chooses the direction: `axis=0` works down the rows (one answer per column), and `axis=1` works across each row.

```python run
table = np.array([
    [3, 9.5],
    [7, 8.0],
    [2, 9.5],
])
print("per column totals:", table.sum(axis=0))
print("per row totals:", table.sum(axis=1))
```

## Challenge: a tiered discount

```python exercise id=tiered-discount title="Apply a discount above a threshold"
import numpy as np

# TODO: `apply_discount(prices, threshold, rate)` returns a new array in which every price strictly above
# `threshold` is reduced by `rate` (for example 0.1 for ten percent). Other prices stay the same.
def apply_discount(prices, threshold, rate):
    ...
--- solution
import numpy as np

def apply_discount(prices, threshold, rate):
    prices = np.asarray(prices, dtype=float)
    return np.where(prices > threshold, prices * (1 - rate), prices)
--- test
import numpy as np
result = apply_discount(np.array([5.0, 10.0, 20.0]), 9.0, 0.5)
assert result is not None, "Replace the `...` in `apply_discount` with code that returns the new prices."
assert np.allclose(result, [5.0, 5.0, 10.0]), f"Only prices above 9 should drop by half: expected [5, 5, 10], but you returned {result}."
assert np.allclose(apply_discount([9.0], 9.0, 0.5), [9.0]), "A price equal to the threshold is not above it, so it stays the same."
assert np.allclose(apply_discount([100.0, 1.0], 50.0, 0.1), [90.0, 1.0]), "The function should work for any threshold and rate."
--- hint
Build a mask with `prices > threshold`, then use `np.where` to choose between the discounted price and the original.
--- hint
`return np.where(prices > threshold, prices * (1 - rate), prices)`.
```

## Challenge: the share above a threshold

```python exercise id=share-above title="Share of values above a threshold"
import numpy as np

# TODO: `share_above(values, threshold)` returns the fraction of values that are strictly greater than
# `threshold`, as a float between 0 and 1. Use a boolean mask.
def share_above(values, threshold):
    ...
--- solution
import numpy as np

def share_above(values, threshold):
    values = np.asarray(values, dtype=float)
    return float((values > threshold).mean())
--- test
import numpy as np
result = share_above(np.array([1.0, 5.0, 7.0, 9.0]), 4.0)
assert result is not None, "Replace the `...` in `share_above` with code that returns the fraction."
assert np.isclose(result, 0.75), f"Three of four values are above 4, so the share is 0.75, but you returned {result!r}."
assert np.isclose(share_above([3.0, 3.0], 3.0), 0.0), "Values equal to the threshold are not strictly above it."
assert np.isclose(share_above([10.0], 1.0), 1.0), "A single value above the threshold gives a share of 1."
--- hint
`values > threshold` is a boolean mask. Its mean is the fraction of True values.
--- hint
`return float((values > threshold).mean())`.
```

## Debug the mask operator

This code is meant to keep rows that are both large and cheap, but it raises an error.

```python debug id=mask-operator title="Combine masks correctly"
import numpy as np

units = np.array([3, 7, 2, 5])
price = np.array([9.5, 8.0, 9.5, 12.0])
both = (units >= 3) and (price < 10)     # bug: `and` cannot combine arrays
print(units[both])
--- solution
import numpy as np

units = np.array([3, 7, 2, 5])
price = np.array([9.5, 8.0, 9.5, 12.0])
both = (units >= 3) & (price < 10)
print(units[both])
--- test
assert list(both) == [True, True, False, False], f"The mask should be [True, True, False, False], but it is {both}. Combine array conditions with `&`."
--- hint
Python''s `and` works on single values. For element-by-element logic on arrays, use `&`.
--- hint
Replace `and` with `&`, and keep the parentheses around each comparison.
```

## Predict the output

```python predict id=predict-mask title="How many values pass?"
import numpy as np
a = np.array([1, 4, 6, 8])
print((a > 3).sum())
--- options
* 3
2
4
1
--- explain
Only 1 fails the test `a > 3`. The other three values, 4, 6 and 8, are greater than 3, so the sum of the mask is 3.
```

## Recap

- Arithmetic on arrays applies to every position at once.
- A boolean mask selects rows, and `mask.sum()` counts them.
- Combine masks with `&` and `|`, and wrap each condition in parentheses.
- `np.where` chooses one of two values per position, and `axis` picks the direction of an aggregation.

**Up next:** missing values. Real data always has gaps, and how you treat them changes every answer.
', 0, '[]', '[]', '2026-06-25T06:40:00.179Z', '2026-10-19T06:40:00.179Z'),
('les_python_for_data_science_2_2', 'sec_python_for_data_science_2', 'crs_python_for_data_science', 'Missing values with NumPy', 'interactive', 1, 840, NULL, NULL, 'Real data has gaps. A sensor drops a reading, a survey question is skipped, a sale is recorded without a price. In Python, a missing number is usually `NaN`, short for "not a number". `NaN` behaves in ways that surprise people, and most wrong averages in analysis come from forgetting that. This lesson shows what `NaN` does and how to handle it deliberately.

## NaN spreads through arithmetic

Any arithmetic that touches `NaN` gives `NaN`. A single gap poisons a sum. And `NaN` is never equal to anything, not even itself.

```python run
import numpy as np

readings = np.array([21.5, np.nan, 23.0, 22.5])
print("sum:", readings.sum())
print("nan == nan:", np.nan == np.nan)
print("which are missing:", np.isnan(readings))
```

Test for missing values with `np.isnan` (or `isna` in pandas), never with `==`.

## Ignore gaps on purpose

The NumPy functions with a `nan` prefix skip missing values. Use them when a gap should be ignored, and be clear in your report that you did so.

```python run
print("plain mean:", readings.mean())
print("mean ignoring gaps:", np.nanmean(readings))
print("count of real values:", np.count_nonzero(~np.isnan(readings)))
```

The plain mean is `NaN`, which tells you there is a gap. The `nanmean` answer is only an honest summary if three of four readings are a fair sample. Always report how many values went into the answer.

## Why the count matters

```python run
sparse = np.array([np.nan, np.nan, 40.0])
print("nanmean of sparse data:", np.nanmean(sparse))
print("values used:", np.count_nonzero(~np.isnan(sparse)), "of", sparse.size)
```

One real value out of three gives a number that looks precise, but it rests on very little evidence. A good analysis states the sample size next to every average.

## Replace gaps with a rule

Sometimes you need a complete array. You can fill gaps with a value that has a justification, such as the median of the observed readings, and say so.

```python run
filled = np.where(np.isnan(readings), np.nanmedian(readings), readings)
print("filled:", filled)
```

> **Pitfall:** filling gaps with zero is almost always wrong. Zero is a real value, and it pulls averages down. Fill with the median, the mean, or the previous value, and record which one you used.

## Challenge: a mean that admits its gaps

```python exercise id=safe-mean title="Mean of the observed values"
import numpy as np

# TODO: `safe_mean(values)` returns the mean of the values that are not NaN. If every value is NaN,
# or the array is empty, return NaN instead of raising an error or warning.
def safe_mean(values):
    ...
--- solution
import numpy as np

def safe_mean(values):
    values = np.asarray(values, dtype=float)
    observed = values[~np.isnan(values)]
    if observed.size == 0:
        return np.nan
    return observed.mean()
--- test
import numpy as np
result = safe_mean([2.0, np.nan, 4.0])
assert result is not None, "Replace the `...` in `safe_mean` with code that returns the mean."
assert np.isclose(result, 3.0), f"The observed values are 2 and 4, whose mean is 3, but you returned {result!r}."
assert np.isnan(safe_mean([np.nan, np.nan])), "If every value is missing, the answer should be NaN."
assert np.isnan(safe_mean([])), "An empty input has no mean, so the answer should be NaN."
assert np.isclose(safe_mean([7.0]), 7.0), "A single observed value is its own mean."
--- hint
Keep only the values where `np.isnan(values)` is False, then average those.
--- hint
`observed = values[~np.isnan(values)]`, and return `np.nan` when `observed` is empty.
```

## Challenge: fill gaps with the median

```python exercise id=fill-median title="Fill gaps with the median of the observed values"
import numpy as np

# TODO: `fill_with_median(values)` returns a new array in which each NaN is replaced by the median of the
# observed (non-NaN) values. If every value is NaN, return a copy of the input unchanged.
def fill_with_median(values):
    ...
--- solution
import numpy as np

def fill_with_median(values):
    values = np.asarray(values, dtype=float)
    if np.all(np.isnan(values)):
        return values.copy()
    return np.where(np.isnan(values), np.nanmedian(values), values)
--- test
import numpy as np
result = fill_with_median([1.0, np.nan, 3.0, 10.0])
assert result is not None, "Replace the `...` in `fill_with_median` with code that returns the filled array."
assert np.allclose(result, [1.0, 3.0, 3.0, 10.0]), f"The observed values are 1, 3 and 10 with median 3, so the gap should become 3. You returned {result}."
assert np.isnan(fill_with_median([np.nan, np.nan])).all(), "If nothing is observed there is no median, so the values stay missing."
assert np.allclose(fill_with_median([2.0, 4.0]), [2.0, 4.0]), "An array without gaps should come back unchanged."
--- hint
`np.nanmedian` gives the median of the observed values. Use `np.where(np.isnan(values), median, values)` to choose between them.
--- hint
Handle the all-missing case first, because the median of nothing is not a number you can use.
```

## Debug the comparison

This code is supposed to count missing readings, but it always reports zero.

```python debug id=nan-compare title="Find missing values correctly"
import numpy as np

readings = np.array([21.5, np.nan, 23.0, np.nan])
missing = np.count_nonzero(readings == np.nan)     # bug: NaN is never equal to anything
print("missing:", missing)
--- solution
import numpy as np

readings = np.array([21.5, np.nan, 23.0, np.nan])
missing = np.count_nonzero(np.isnan(readings))
print("missing:", missing)
--- test
assert missing == 2, f"There are two missing readings, but the code reports {missing}. Test for missing values with np.isnan."
--- hint
`x == np.nan` is always False, so nothing matches. NumPy has a function built for this test.
--- hint
Use `np.isnan(readings)` instead of `readings == np.nan`.
```

## Predict the average

```python predict id=predict-nanmean title="What does nanmean return?"
import numpy as np
print(np.nanmean(np.array([1.0, np.nan, 3.0, np.nan])))
--- options
* 2.0
1.0
nan
4.0
--- explain
`nanmean` ignores the two missing values and averages the observed 1 and 3, which gives 2.0. The plain `mean` would have returned nan.
```

## Recap

- `NaN` poisons arithmetic and is never equal to anything. Test for it with `np.isnan`.
- Use the `nan` functions such as `nanmean` when a gap should be ignored, and report how many values were used.
- Filling gaps is a decision. Use a justified value, never zero by default.
- Missing values are information too: a pattern of gaps can reveal a problem in the data collection.

**Up next:** pandas. A DataFrame puts named columns, mixed types and missing values into one table, and this is where most of your analysis will happen.
', 0, '[]', '[]', '2026-06-25T06:40:00.179Z', '2026-10-19T06:40:00.179Z'),
('les_python_for_data_science_3_1', 'sec_python_for_data_science_3', 'crs_python_for_data_science', 'DataFrames: load, inspect and summarize', 'interactive', 0, 1080, NULL, NULL, 'A **DataFrame** is a table: rows are observations, columns are named variables, and each column holds one type of value. It is the central object of pandas, and most of your analysis will begin with loading one and asking what it contains. This lesson shows how to load data, how to look at it before you trust it, and how to summarize it.

The examples use a small sales export, stored as text so the page needs no files. Reading from `io.StringIO` is the same as reading a real CSV file.

## Load a table

```python run
import io
import pandas as pd

CSV = """date,city,product,units,price
2026-01-03,Lyon,Tea,4,6.50
2026-01-03,Paris,Coffee,2,9.00
2026-01-04,Lyon,Coffee,1,9.00
2026-01-05,Nice,Tea,,6.50
2026-01-06,Paris,Tea,5,6.50
2026-02-01,Nice,Coffee,3,9.50
2026-02-02,Lyon,Tea,2,6.50
2026-02-02,Paris,Coffee,4,9.50
"""

sales = pd.read_csv(io.StringIO(CSV))
sales
```

`read_csv` read the header row for the column names and guessed a type for each column. Notice that the empty units cell on 5 January became a missing value, shown as `NaN`.

## Look before you trust

Three methods answer most first questions about a new table: what it looks like, what types it has, and whether anything is missing.

```python run
print(sales.shape)
sales.head(3)
```

```python run
sales.info()
```

`info` lists every column with its type and how many values are not missing. A column with fewer non-null values than rows has gaps, and you now know which.

## Summaries

`describe` gives count, mean, spread and quartiles for every numeric column in one table.

```python run
sales.describe()
```

Read it critically. The count of `units` is smaller than the number of rows because of the missing value, and `describe` quietly skips it. An average of a column always tells you how many values it used.

## Single columns and simple statistics

```python run
print("units total:", sales["units"].sum())
print("average price:", round(sales["price"].mean(), 2))
print("distinct products:", sales["product"].nunique())
print("most common city:", sales["city"].value_counts().index[0])
```

`value_counts` is the quick way to see how often each category appears, and it is the first thing to check on any text column.

## Create and check a new column

You can derive new columns from existing ones. Each new column is a vectorized calculation, the same idea you saw with NumPy arrays.

```python run
sales["revenue"] = sales["units"] * sales["price"]
print(sales[["city", "units", "price", "revenue"]])
```

Notice that the missing units produced a missing revenue. pandas propagates gaps through calculations rather than inventing values, which is the honest behavior.

## Challenge: load orders from text

```python exercise id=load-orders title="Load a CSV with parsed dates"
import io
import pandas as pd

# TODO: `load_orders(text)` takes CSV text with a "date" column and returns a DataFrame. The "date"
# column must be parsed as datetimes (not plain text). All other columns keep the types pandas gives them.
def load_orders(text):
    ...
--- solution
import io
import pandas as pd

def load_orders(text):
    return pd.read_csv(io.StringIO(text), parse_dates=["date"])
--- test
import io
import pandas as pd
text = "date,amount\n2026-03-01,10\n2026-03-02,20\n"
result = load_orders(text)
assert result is not None, "Replace the `...` in `load_orders` with code that returns the DataFrame."
assert isinstance(result, pd.DataFrame), "load_orders should return a DataFrame."
assert pd.api.types.is_datetime64_any_dtype(result["date"]), "The date column should be parsed as datetimes. Use parse_dates=[''date''] in read_csv."
assert result["amount"].sum() == 30, "The amounts should be read as numbers and sum to 30."
assert len(result) == 2, "There are two rows of data."
--- hint
`pd.read_csv` accepts a `parse_dates` argument, a list of column names to convert to dates. Wrap the text in `io.StringIO`.
--- hint
`return pd.read_csv(io.StringIO(text), parse_dates=["date"])`.
```

## Challenge: profile a table

```python exercise id=column-profile title="Profile a DataFrame"
import pandas as pd

# TODO: `column_profile(df)` returns a dictionary with three keys: "rows" (the number of rows), "columns"
# (the list of column names, in order) and "missing" (the total number of missing cells in the whole table).
def column_profile(df):
    ...
--- solution
import pandas as pd

def column_profile(df):
    return {"rows": len(df), "columns": list(df.columns), "missing": int(df.isna().sum().sum())}
--- test
import numpy as np
import pandas as pd
df = pd.DataFrame({"a": [1, np.nan, 3], "b": ["x", None, "z"]})
result = column_profile(df)
assert result is not None, "Replace the `...` in `column_profile` with code that returns the dictionary."
assert result["rows"] == 3, "The table has three rows."
assert result["columns"] == ["a", "b"], f"The column names should be a and b, in order, but you returned {result[''columns'']}."
assert result["missing"] == 2, "There are two missing cells: one in a and one in b."
--- hint
`len(df)` gives the number of rows, and `list(df.columns)` the names. For the missing total, `df.isna().sum()` gives one count per column, and summing that gives the total.
--- hint
`int(df.isna().sum().sum())` counts all missing cells.
```

## Debug the header

This code is meant to read the file and find the `units` column, but it fails.

```python debug id=header-row title="Use the header row"
import io
import pandas as pd

CSV = "date,city,units\n2026-01-03,Lyon,4\n2026-01-04,Paris,2\n"
df = pd.read_csv(io.StringIO(CSV), header=None)     # bug: this treats the header as data
print(df["units"].sum())
--- solution
import io
import pandas as pd

CSV = "date,city,units\n2026-01-03,Lyon,4\n2026-01-04,Paris,2\n"
df = pd.read_csv(io.StringIO(CSV))
print(df["units"].sum())
--- test
assert "units" in df.columns, f"The columns should be named from the header row, but they are {list(df.columns)}. Remove header=None."
assert df["units"].sum() == 6, "The units should sum to 6."
--- hint
`header=None` tells pandas there is no header row, so the names become numbers and the first line is treated as data.
--- hint
Remove the `header=None` argument. The default reads the first row as column names.
```

## Predict the shape

```python predict id=predict-shape title="What is the shape of the table?"
import io
import pandas as pd
df = pd.read_csv(io.StringIO("a,b\n1,2\n3,4\n5,6\n"))
print(df.shape)
--- options
* (3, 2)
(2, 3)
(4, 2)
(3, 3)
--- explain
The header gives two columns, and the three data rows give three rows. The header is not counted as a row, so the shape is (3, 2) for rows and columns in that order.
```

## Recap

- `read_csv` turns text or a file into a DataFrame, and `parse_dates` converts date columns.
- Look before you trust: `head`, `info`, `describe` and `value_counts` answer the first questions.
- Missing values are visible in `info`, and pandas carries them through calculations.
- Create new columns with vectorized expressions over existing ones.

**Up next:** selecting and filtering rows and columns, which is how you ask a table specific questions.
', 0, '[]', '[]', '2026-06-25T06:40:00.179Z', '2026-10-19T06:40:00.179Z'),
('les_python_for_data_science_3_2', 'sec_python_for_data_science_3', 'crs_python_for_data_science', 'Selecting, filtering and assigning', 'interactive', 1, 1080, NULL, NULL, 'Most questions about a table are selections: "the Lyon orders", "the three largest sales", "the price column for March". pandas has a small set of tools for selecting, and knowing which one to use is most of the skill. This lesson covers label-based and position-based selection, boolean filters, and assigning values safely.

```python run
import io
import pandas as pd

CSV = """date,city,product,units,price
2026-01-03,Lyon,Tea,4,6.50
2026-01-03,Paris,Coffee,2,9.00
2026-01-04,Lyon,Coffee,1,9.00
2026-01-05,Nice,Tea,6,6.50
2026-01-06,Paris,Tea,5,6.50
2026-02-01,Nice,Coffee,3,9.50
2026-02-02,Lyon,Tea,2,6.50
2026-02-02,Paris,Coffee,4,9.50
"""
sales = pd.read_csv(io.StringIO(CSV), parse_dates=["date"])
print("loaded", sales.shape[0], "orders")
```

## Columns: one name or several

A single name in square brackets returns a column as a **Series**. A list of names returns a DataFrame with those columns.

```python run
print(type(sales["units"]).__name__)
sales[["city", "units"]].head(3)
```

Double brackets, `sales[["city", "units"]]`, is a list of column names. It is the most common mistake for beginners.

## Rows by condition: boolean filters

A comparison on a column gives a mask, and indexing with the mask keeps the matching rows. You met this with NumPy arrays; it works the same way here.

```python run
lyon = sales[sales["city"] == "Lyon"]
print(lyon)
```

Combine conditions with `&` (and) and `|` (or), and wrap each one in parentheses:

```python run
big_tea = sales[(sales["product"] == "Tea") & (sales["units"] >= 4)]
print(big_tea[["date", "city", "units"]])
```

## Position and label: `loc` and `iloc`

`iloc` selects by position, with integers, the way Python lists work. `loc` selects by label, which here means the row index and column names.

```python run
print(sales.iloc[0])                       # the first row, by position
print(sales.loc[2, ["city", "price"]])     # row with index label 2, two columns
```

Use `loc` with a mask to select rows and columns together:

```python run
sales.loc[sales["units"] >= 4, ["city", "units"]]
```

## Assign safely

To change values in some rows, use one `loc` call that names the rows and the column. Assigning through a selected copy, such as `sales[mask]["units"] = 0`, can silently change nothing.

```python run
sales.loc[sales["city"] == "Nice", "price"] = sales.loc[sales["city"] == "Nice", "price"] * 1.05
print(sales.loc[sales["city"] == "Nice", ["city", "price"]])
```

## Sorting and the largest rows

```python run
top = sales.sort_values("units", ascending=False).head(3)
print(top[["city", "product", "units"]])
```

`nlargest` does the same job in one step when you only need the top few: `sales.nlargest(3, "units")`.

## Challenge: large orders, ranked

```python exercise id=large-orders title="Rows above a threshold, ranked"
import pandas as pd

# TODO: `large_orders(df, min_units)` returns the rows where `units` is at least `min_units`,
# sorted by `price` from highest to lowest. Keep all the columns, and give the rows a fresh 0-based index.
def large_orders(df, min_units):
    ...
--- solution
import pandas as pd

def large_orders(df, min_units):
    big = df[df["units"] >= min_units]
    return big.sort_values("price", ascending=False).reset_index(drop=True)
--- test
import pandas as pd
df = pd.DataFrame({"city": ["A", "B", "C", "D"], "units": [5, 2, 8, 5], "price": [3.0, 9.0, 4.0, 7.0]})
result = large_orders(df, 5)
assert result is not None, "Replace the `...` in `large_orders` with code that returns the filtered table."
assert list(result["city"]) == ["D", "C", "A"], f"Units at least 5 are A, C and D. Sorted by price, highest first, that is D (7), C (4), A (3), but you returned {list(result[''city''])}."
assert list(result.index) == [0, 1, 2], "Reset the index so the rows are numbered 0, 1, 2."
assert list(large_orders(df, 9)["city"]) == [], "If nothing qualifies, return an empty table."
--- hint
Filter first with a boolean mask, then sort with `sort_values("price", ascending=False)`, then restart the index with `reset_index(drop=True)`.
--- hint
`big = df[df["units"] >= min_units]`, then `big.sort_values("price", ascending=False).reset_index(drop=True)`.
```

## Challenge: one city''s rows

```python exercise id=city-rows title="Select one city''s rows"
import pandas as pd

# TODO: `city_rows(df, city)` returns the rows where the city column equals `city`, keeping only the columns
# "city" and "units". Reset the index so the rows are numbered from 0.
def city_rows(df, city):
    ...
--- solution
import pandas as pd

def city_rows(df, city):
    rows = df[df["city"] == city]
    return rows[["city", "units"]].reset_index(drop=True)
--- test
import pandas as pd
df = pd.DataFrame({"city": ["Lyon", "Paris", "Lyon"], "units": [4, 2, 1], "price": [6.5, 9.0, 6.5]})
result = city_rows(df, "Lyon")
assert result is not None, "Replace the `...` in `city_rows` with code that returns the selected rows."
assert list(result.columns) == ["city", "units"], f"Keep only the city and units columns, but you returned {list(result.columns)}."
assert result["units"].tolist() == [4, 1], "Lyon has two rows, with units 4 and 1."
assert list(result.index) == [0, 1], "Reset the index to 0, 1."
assert len(city_rows(df, "Nice")) == 0, "A city with no rows should give an empty table."
--- hint
Filter with a mask, then select the two columns with a list of names, then `reset_index(drop=True)`.
--- hint
`rows = df[df["city"] == city]` and `return rows[["city", "units"]].reset_index(drop=True)`.
```

## Debug the column selection

This code is meant to show the city and units columns, but it raises an error.

```python debug id=double-brackets title="Select several columns"
import io
import pandas as pd

sales = pd.read_csv(io.StringIO("city,units,price\nLyon,4,6.5\nParis,2,9.0\n"))
view = sales["city", "units"]                 # bug: a tuple is not a list of columns
print(view)
--- solution
import io
import pandas as pd

sales = pd.read_csv(io.StringIO("city,units,price\nLyon,4,6.5\nParis,2,9.0\n"))
view = sales[["city", "units"]]
print(view)
--- test
assert list(view.columns) == ["city", "units"], f"The view should have the city and units columns, but it has {list(view.columns)}. Pass a list of names inside the brackets."
--- hint
Inside `[]`, a list of names needs its own square brackets.
--- hint
`sales[["city", "units"]]`.
```

## Predict the rows

```python predict id=predict-filter title="How many rows match?"
import pandas as pd
df = pd.DataFrame({"units": [1, 4, 6, 4]})
print(len(df[df["units"] >= 4]))
--- options
* 3
2
4
1
--- explain
Three values are at least 4: the two 4s and the 6. The condition is inclusive because of `>=`, so both 4s count.
```

## Recap

- One column name returns a Series; a list of names returns a DataFrame.
- Filter rows with a boolean mask, combining conditions with `&` and `|` inside parentheses.
- Use `loc` for labels and conditions together, and `iloc` for positions.
- Assign with a single `loc` call so the change lands in the original table.

**Up next:** cleaning data. Filtering only works if the values you filter on are correct, and real exports rarely are.
', 0, '[]', '[]', '2026-06-25T06:40:00.179Z', '2026-10-19T06:40:00.179Z'),
('les_python_for_data_science_3_3', 'sec_python_for_data_science_3', 'crs_python_for_data_science', 'Cleaning data: types, duplicates and gaps', 'interactive', 2, 1200, NULL, NULL, 'Real exports are messy. A city is spelled "lyon", "Lyon " and "LYON". A price is text. The same order appears twice. A units cell is blank. Every analysis built on dirty data gives a confident answer that is wrong, so cleaning is not a chore before the real work. For most analysts it is most of the real work. This lesson shows the standard cleaning moves, in the order you usually need them.

```python run
import io
import pandas as pd

RAW = """order_id,city,units,price
1, Lyon ,4,6.50
2,lyon,2,6.50
2,lyon,2,6.50
3,PARIS,n/a,9.00
4,Paris,5,
5,Nice,3,9.50
"""
raw = pd.read_csv(io.StringIO(RAW), dtype=str)
raw
```

I read every column as text on purpose. That shows the real problems: spaces, mixed case, a duplicate row, a non-numeric entry and a blank price.

## Clean text: strip and standardize case

`str` methods work on whole columns. Strip spaces, then choose one standard case.

```python run
clean = raw.copy()
clean["city"] = clean["city"].str.strip().str.title()
print(clean["city"].tolist())
```

## Convert types: text to numbers

`pd.to_numeric` turns text into numbers. With `errors="coerce"`, values that cannot be read become missing (`NaN`) instead of raising an error, and you can count them.

```python run
clean["units"] = pd.to_numeric(clean["units"], errors="coerce")
clean["price"] = pd.to_numeric(clean["price"], errors="coerce")
print(clean[["units", "price"]])
print("missing units:", clean["units"].isna().sum())
print("missing prices:", clean["price"].isna().sum())
```

Always count what you converted to missing. A silent coercion can hide a whole category of errors.

## Remove duplicates

```python run
no_dupes = clean.drop_duplicates()
print("rows before:", len(clean), "after:", len(no_dupes))
```

`drop_duplicates` compares whole rows by default. To treat rows with the same key as duplicates, pass `subset=["order_id"]`, and decide which copy to keep with `keep="first"` or `keep="last"`.

## Handle gaps: drop or fill

```python run
print(no_dupes.dropna(subset=["price"]))
```

Dropping rows removes information. Filling is a decision too. Fill with a justified value, and never with zero for a quantity or price, because zero is a real value that drags averages down:

```python run
median_price = no_dupes["price"].median()
filled = no_dupes.assign(price=no_dupes["price"].fillna(median_price))
print(filled["price"].tolist())
```

> **Pitfall:** `fillna(0)` is the most common cleaning mistake. It invents sales of zero where the data is simply unknown.

## Check the result

After cleaning, check it the way you checked the raw data: shape, types, missing values and the distinct categories.

```python run
print(no_dupes.dtypes)
print(no_dupes["city"].value_counts())
```

## Challenge: clean the orders

```python exercise id=clean-orders title="Clean a raw order table"
import pandas as pd

# TODO: `clean_orders(df)` takes a table with columns order_id, city, units and price, all read as text.
# Return a cleaned copy: strip spaces and use title case for city; convert units and price to numbers
# (unreadable values become NaN); drop exact duplicate rows; and drop rows where price is missing.
# Keep the rows in their original order, with a fresh 0-based index.
def clean_orders(df):
    ...
--- solution
import pandas as pd

def clean_orders(df):
    out = df.copy()
    out["city"] = out["city"].str.strip().str.title()
    out["units"] = pd.to_numeric(out["units"], errors="coerce")
    out["price"] = pd.to_numeric(out["price"], errors="coerce")
    out = out.drop_duplicates()
    out = out.dropna(subset=["price"])
    return out.reset_index(drop=True)
--- test
import pandas as pd
raw = pd.DataFrame({
    "order_id": ["1", "1", "2", "3"],
    "city": [" lyon ", " lyon ", "PARIS", "nice"],
    "units": ["4", "4", "n/a", "3"],
    "price": ["6.5", "6.5", "9", ""],
})
result = clean_orders(raw)
assert result is not None, "Replace the `...` in `clean_orders` with code that returns the cleaned table."
assert list(result["city"]) == ["Lyon", "Paris"], f"Expected the cities Lyon and Paris after cleaning, but got {list(result[''city''])}. Strip spaces, then use title case, and drop the row with no price."
assert len(result) == 2, "The duplicate Lyon row should be removed, and the Nice row has no price, so two rows remain."
assert result["price"].tolist() == [6.5, 9.0], "Prices should be numbers."
assert result["units"].isna().tolist() == [False, True], "The unreadable units ''n/a'' should become NaN, not be dropped or set to 0."
assert list(result.index) == [0, 1], "Use a fresh 0-based index."
--- hint
Clean each column in order: text first, then numbers with `pd.to_numeric(..., errors="coerce")`, then `drop_duplicates()`, then `dropna(subset=["price"])`.
--- hint
After dropping rows, call `reset_index(drop=True)` so the index starts at 0 again.
```

## Challenge: count unreadable values

```python exercise id=count-unreadable title="Count values that cannot be read as numbers"
import pandas as pd

# TODO: `count_unreadable(values)` takes a Series of text values. Return how many of them cannot be read as
# numbers, after stripping spaces. Empty text counts as unreadable too.
def count_unreadable(values):
    ...
--- solution
import pandas as pd

def count_unreadable(values):
    cleaned = values.str.strip()
    numbers = pd.to_numeric(cleaned.where(cleaned != "", None), errors="coerce")
    return int(numbers.isna().sum())
--- test
import pandas as pd
result = count_unreadable(pd.Series(["4", " 2.5 ", "n/a", "", "7"]))
assert result is not None, "Replace the `...` in `count_unreadable` with code that returns the count."
assert result == 2, f"''n/a'' and the empty text cannot be read as numbers, so the count is 2, but you returned {result!r}."
assert count_unreadable(pd.Series(["1", "2"])) == 0, "All readable values give a count of 0."
--- hint
Convert with `pd.to_numeric(..., errors="coerce")`, which makes unreadable values missing. Then count the missing values.
--- hint
Strip the spaces first, then `pd.to_numeric(values.str.strip(), errors="coerce").isna().sum()`. Treat empty text as missing too.
```

## Debug the text comparison

This code is meant to count Lyon orders, but it finds only some of them.

```python debug id=strip-spaces title="Clean before you compare"
import pandas as pd

cities = pd.Series([" Lyon", "Lyon ", "Lyon", "Paris"])
lyon_count = (cities == "Lyon").sum()        # bug: spaces are part of the text
print("Lyon orders:", lyon_count)
--- solution
import pandas as pd

cities = pd.Series([" Lyon", "Lyon ", "Lyon", "Paris"])
lyon_count = (cities.str.strip() == "Lyon").sum()
print("Lyon orders:", lyon_count)
--- test
assert lyon_count == 3, f"After stripping spaces, three rows are Lyon, but lyon_count is {lyon_count}. Clean the text before comparing it."
--- hint
" Lyon" and "Lyon" are different strings to Python, even though a person sees the same city.
--- hint
Compare `cities.str.strip()` with "Lyon" instead of `cities` itself.
```

## Predict the count

```python predict id=predict-clean title="How many rows remain?"
import pandas as pd
df = pd.DataFrame({"a": [1, 1, 2, None]})
print(len(df.drop_duplicates().dropna()))
--- options
* 2
3
1
4
--- explain
The rows are 1, 1, 2 and missing. Removing the duplicate 1 leaves 1, 2 and missing. Dropping the missing row leaves 1 and 2, so two rows remain.
```

## Recap

- Clean text first: strip spaces and standardize case, so equal values compare equal.
- Convert types with `pd.to_numeric(..., errors="coerce")`, and count what became missing.
- Remove duplicates deliberately, and decide what counts as the same record.
- Fill gaps only with a justified value. Never default to zero.

**Up next:** grouping and aggregation. Once your data is clean, this is how you turn thousands of rows into a few answers.
', 0, '[]', '[]', '2026-06-25T06:40:00.179Z', '2026-10-19T06:40:00.179Z'),
('les_python_for_data_science_3_4', 'sec_python_for_data_science_3', 'crs_python_for_data_science', 'Grouping and aggregation', 'interactive', 3, 1080, NULL, NULL, 'Most business questions are "per something" questions: revenue per city, average basket per customer, returns per product. In pandas the pattern is always the same, and it has three steps: split the rows into groups, apply a calculation to each group, and combine the results. This lesson shows that pattern in its common forms: simple totals, named aggregations, and transformations that keep every row.

```python run
import io
import pandas as pd

CSV = """date,city,product,units,price
2026-01-03,Lyon,Tea,4,6.50
2026-01-03,Paris,Coffee,2,9.00
2026-01-04,Lyon,Coffee,1,9.00
2026-01-05,Nice,Tea,6,6.50
2026-01-06,Paris,Tea,5,6.50
2026-02-01,Nice,Coffee,3,9.50
2026-02-02,Lyon,Tea,2,6.50
2026-02-02,Paris,Coffee,4,9.50
"""
sales = pd.read_csv(io.StringIO(CSV), parse_dates=["date"])
sales["revenue"] = sales["units"] * sales["price"]
print("loaded", len(sales), "orders")
```

## Split, apply, combine

```python run
by_city = sales.groupby("city")["revenue"].sum()
print(by_city)
```

`groupby("city")` splits the rows by city, `["revenue"]` picks the column, and `sum()` applies to each group. The result is indexed by city.

## Several statistics at once

Named aggregation gives each output column a clear name and its own calculation.

```python run
summary = sales.groupby("city").agg(
    orders=("units", "size"),
    units=("units", "sum"),
    revenue=("revenue", "sum"),
    avg_price=("price", "mean"),
)
print(summary.sort_values("revenue", ascending=False))
```

`size` counts rows in each group, which is different from `count`. `count` skips missing values, so it can be smaller than `size`.

## Groups with several keys

```python run
by_city_product = sales.groupby(["city", "product"])["units"].sum()
print(by_city_product)
```

`unstack` turns the inner key into columns, which is the table you would show in a report:

```python run
by_city_product.unstack(fill_value=0)
```

## Transform: keep every row

`transform` computes a group result and broadcasts it back to each row. It is how you compare a row with its group, such as its share of the city total.

```python run
sales["city_revenue"] = sales.groupby("city")["revenue"].transform("sum")
sales["share_of_city"] = (sales["revenue"] / sales["city_revenue"]).round(3)
print(sales[["city", "product", "revenue", "share_of_city"]])
```

Every row keeps its identity, and the new column has the same length as the table.

> **Pitfall:** `sum` and `mean` treat missing values differently from what you might expect. A group where every unit is missing gives 0 for `sum` and NaN for `mean`. Check the count of values behind every average.

## Challenge: revenue by city

```python exercise id=revenue-by-city title="Revenue per city, largest first"
import pandas as pd

# TODO: `revenue_by_city(df)` takes a table with columns city, units and price. Revenue is units × price for
# each row. Return a Series of total revenue per city, named "revenue", indexed by city, largest first.
def revenue_by_city(df):
    ...
--- solution
import pandas as pd

def revenue_by_city(df):
    revenue = df["units"] * df["price"]
    totals = revenue.groupby(df["city"]).sum()
    return totals.sort_values(ascending=False).rename("revenue")
--- test
import pandas as pd
df = pd.DataFrame({"city": ["Lyon", "Paris", "Lyon", "Nice"], "units": [2, 1, 3, 4], "price": [10.0, 40.0, 10.0, 5.0]})
result = revenue_by_city(df)
assert result is not None, "Replace the `...` in `revenue_by_city` with code that returns the Series."
assert isinstance(result, pd.Series), "The result should be a Series."
assert result.index.tolist() == ["Lyon", "Paris", "Nice"], f"Lyon (50), Paris (40) and Nice (20) should be listed largest first, but the order is {result.index.tolist()}. Lyon is 2×10 + 3×10 = 50."
assert result["Lyon"] == 50.0, f"Lyon''s revenue should be 2×10 + 3×10 = 50, but it is {result[''Lyon'']}."
assert result.name == "revenue", "Name the Series ''revenue''."
--- hint
Compute the revenue column first, then group it by the city column and sum each group. The sorted order comes last.
--- hint
`revenue.groupby(df["city"]).sum()`, then `sort_values(ascending=False)`, then `rename("revenue")`.
```

## Challenge: average price by product

```python exercise id=avg-price-product title="Average price per product"
import pandas as pd

# TODO: `average_price_by_product(df)` takes a table with "product" and "price" columns. Return a Series of the
# mean price per product, indexed by product name in alphabetical order.
def average_price_by_product(df):
    ...
--- solution
import pandas as pd

def average_price_by_product(df):
    return df.groupby("product")["price"].mean().sort_index()
--- test
import pandas as pd
df = pd.DataFrame({"product": ["Tea", "Coffee", "Tea", "Cocoa"], "price": [6.0, 9.0, 8.0, 7.0]})
result = average_price_by_product(df)
assert result is not None, "Replace the `...` in `average_price_by_product` with code that returns the Series."
assert list(result.index) == ["Cocoa", "Coffee", "Tea"], f"The products should be in alphabetical order, but you returned {list(result.index)}."
assert abs(result["Tea"] - 7.0) < 1e-9, "The two Tea prices are 6 and 8, so the mean is 7."
assert abs(result["Coffee"] - 9.0) < 1e-9, "Coffee has one price, 9."
--- hint
Group by product, take the mean of price, then sort the index alphabetically.
--- hint
`df.groupby("product")["price"].mean().sort_index()`.
```

## Debug the wrong aggregate

This code is meant to report total units per city, but it computes something else.

```python debug id=mean-not-sum title="Total units, not average units"
import io
import pandas as pd

df = pd.read_csv(io.StringIO("city,units\nLyon,4\nLyon,3\nParis,2\n"))
totals = df.groupby("city")["units"].mean()     # bug: this is the average per order
print(totals)
--- solution
import io
import pandas as pd

df = pd.read_csv(io.StringIO("city,units\nLyon,4\nLyon,3\nParis,2\n"))
totals = df.groupby("city")["units"].sum()
print(totals)
--- test
assert totals["Lyon"] == 7, f"Lyon sold 4 + 3 = 7 units, but totals says {totals[''Lyon'']}. Use sum, not mean, for a total."
assert totals["Paris"] == 2, "Paris sold 2 units."
--- hint
The question asks for a total. An average answers a different question.
--- hint
Replace `mean()` with `sum()`.
```

## Predict the group sizes

```python predict id=predict-groups title="How many rows are in group A?"
import pandas as pd
df = pd.DataFrame({"g": ["A", "B", "A", "A"], "v": [1, 2, None, 4]})
print(df.groupby("g")["v"].size()["A"])
--- options
* 3
2
4
1
--- explain
`size` counts every row in the group, including the one whose value is missing. Group A has three rows, so the answer is 3. `count` would give 2, because it skips the missing value.
```

## Recap

- Group, apply, combine: `groupby(...)` followed by an aggregation.
- Use named aggregation for several statistics with clear names.
- `transform` keeps every row and broadcasts the group result back.
- Check which aggregate you asked for. Totals and averages answer different questions.

**Up next:** joining and reshaping. Real analysis almost always combines more than one table.
', 0, '[]', '[]', '2026-06-25T06:40:00.179Z', '2026-10-19T06:40:00.179Z'),
('les_python_for_data_science_3_5', 'sec_python_for_data_science_3', 'crs_python_for_data_science', 'Joining and reshaping tables', 'interactive', 4, 1080, NULL, NULL, 'Real data lives in several tables: orders in one, customers in another, regional targets in a third. Joining them is how you bring the facts together, and reshaping is how you turn a long table into the wide one a person can read. Both are easy to get subtly wrong, and the subtle mistakes are the ones that change answers. This lesson covers the join types, how to check a join''s result, and the main reshaping tools.

```python run
import io
import pandas as pd

ORDERS = """order_id,city,units
1,Lyon,4
2,Paris,2
3,Nice,5
4,Lyon,1
5,Brest,3
"""
REGIONS = """city,region
Lyon,Auvergne
Paris,Ile-de-France
Nice,Provence
"""
orders = pd.read_csv(io.StringIO(ORDERS))
regions = pd.read_csv(io.StringIO(REGIONS))
orders
```

## Join types

`merge` joins two tables on a shared column. The `how` argument decides which rows to keep.

```python run
left = orders.merge(regions, on="city", how="left")
print(left)
```

A **left** join keeps every order, even Brest, which has no region in the lookup table, so its region is missing. An **inner** join would silently drop it:

```python run
inner = orders.merge(regions, on="city", how="inner")
print("left rows:", len(left), "| inner rows:", len(inner))
```

Choose the join by asking what you must not lose. Here, losing an order would understate revenue, so the left join is the safe choice.

## Check the join

Two checks catch most join mistakes: did the row count change, and did the key match one-to-one as you expected? `validate` makes pandas enforce the second one.

```python run
checked = orders.merge(regions, on="city", how="left", validate="many_to_one")
print("rows before:", len(orders), "| after:", len(checked))
```

If the lookup table had two rows for Lyon, every Lyon order would be duplicated, and the totals would be inflated. `validate="many_to_one"` raises an error in that case, which is what you want.

## Stack tables: concat

```python run
january = pd.DataFrame({"city": ["Lyon"], "units": [4]})
february = pd.DataFrame({"city": ["Paris"], "units": [7]})
combined = pd.concat([january, february], ignore_index=True)
print(combined)
```

`concat` stacks rows when the tables have the same columns, which is how monthly exports are usually combined.

## Reshape: long to wide

A **pivot table** turns a long table, one row per fact, into a grid with one row per category and one column per other category.

```python run
long_table = pd.DataFrame({
    "city": ["Lyon", "Lyon", "Paris", "Paris"],
    "product": ["Tea", "Coffee", "Tea", "Coffee"],
    "units": [4, 1, 5, 2],
})
wide = long_table.pivot_table(index="city", columns="product", values="units", aggfunc="sum", fill_value=0)
print(wide)
```

`melt` does the opposite, turning the wide grid back into a long table, which is what most plotting and modelling tools expect:

```python run
print(wide.reset_index().melt(id_vars="city", var_name="product", value_name="units"))
```

## Challenge: attach regions

```python exercise id=attach-regions title="Attach a region to every order"
import pandas as pd

# TODO: `attach_regions(orders, regions)` returns the orders table with a "region" column added from the
# regions table, matched on "city". Keep every order, even when it has no region (leave that region missing).
# Raise an error if the regions table has more than one row for the same city.
def attach_regions(orders, regions):
    ...
--- solution
import pandas as pd

def attach_regions(orders, regions):
    return orders.merge(regions, on="city", how="left", validate="many_to_one")
--- test
import pandas as pd
orders = pd.DataFrame({"city": ["Lyon", "Brest", "Lyon"], "units": [1, 2, 3]})
regions = pd.DataFrame({"city": ["Lyon"], "region": ["Auvergne"]})
result = attach_regions(orders, regions)
assert result is not None, "Replace the `...` in `attach_regions` with code that returns the joined table."
assert len(result) == 3, f"All three orders should be kept, but the result has {len(result)} rows."
assert result["region"].tolist()[0] == "Auvergne" and pd.isna(result["region"].tolist()[1]), "Lyon should get its region and Brest should keep a missing region."
dupes = pd.DataFrame({"city": ["Lyon", "Lyon"], "region": ["A", "B"]})
try:
    attach_regions(orders, dupes)
    raised = False
except Exception:
    raised = True
assert raised, "If the regions table has two rows for one city, the join should raise an error instead of duplicating orders."
--- hint
Use `merge` with `how="left"` so no order is lost, and pass `validate="many_to_one"` to guard against duplicate city rows.
--- hint
`return orders.merge(regions, on="city", how="left", validate="many_to_one")`.
```

## Challenge: orders per region

```python exercise id=orders-per-region title="Count orders per region"
import pandas as pd

# TODO: `orders_per_region(orders, regions)` left-joins orders with regions on "city". Orders with no matching
# region count as "Unknown". Return a Series with the number of orders per region, sorted from most to fewest.
def orders_per_region(orders, regions):
    ...
--- solution
import pandas as pd

def orders_per_region(orders, regions):
    joined = orders.merge(regions, on="city", how="left", validate="many_to_one")
    joined["region"] = joined["region"].fillna("Unknown")
    return joined["region"].value_counts()
--- test
import pandas as pd
orders = pd.DataFrame({"city": ["Lyon", "Brest", "Lyon", "Paris"]})
regions = pd.DataFrame({"city": ["Lyon", "Paris"], "region": ["Auvergne", "Ile-de-France"]})
result = orders_per_region(orders, regions)
assert result is not None, "Replace the `...` in `orders_per_region` with code that returns the counts."
assert result["Auvergne"] == 2, "Two orders are from Lyon, so Auvergne has 2."
assert result["Unknown"] == 1, "Brest has no region, so one order should be counted as Unknown."
assert result.index[0] == "Auvergne", "The region with the most orders should come first."
assert result.sum() == len(orders), "Every order should be counted exactly once."
--- hint
Left-join so no order is lost, fill the missing regions with "Unknown", and count with `value_counts()`.
--- hint
`joined["region"].fillna("Unknown")` before `value_counts()`.
```

## Debug the duplicated orders

This code is meant to attach regions to the orders, but the order count grows.

```python debug id=duplicate-join title="Stop the join from duplicating orders"
import pandas as pd

orders = pd.DataFrame({"city": ["Lyon", "Paris"], "units": [4, 2]})
regions = pd.DataFrame({"city": ["Lyon", "Lyon", "Paris"], "region": ["Auvergne", "Rhone", "Ile-de-France"]})
joined = orders.merge(regions, on="city", how="left")     # bug: Lyon appears twice in regions
print(len(orders), "->", len(joined))
--- solution
import pandas as pd

orders = pd.DataFrame({"city": ["Lyon", "Paris"], "units": [4, 2]})
regions = pd.DataFrame({"city": ["Lyon", "Lyon", "Paris"], "region": ["Auvergne", "Rhone", "Ile-de-France"]})
regions = regions.drop_duplicates(subset="city", keep="first")
joined = orders.merge(regions, on="city", how="left")
print(len(orders), "->", len(joined))
--- test
assert len(joined) == len(orders), f"The join should keep {len(orders)} orders, but it returned {len(joined)} rows. Make sure the regions table has one row per city before you merge."
assert list(joined["region"]) == ["Auvergne", "Ile-de-France"], "Each city should get one region."
--- hint
A lookup table with duplicate keys multiplies the rows it joins to. Remove the duplicates from the lookup table first.
--- hint
`regions = regions.drop_duplicates(subset="city", keep="first")` before the merge.
```

## Predict the row count

```python predict id=predict-join title="How many rows come out?"
import pandas as pd
a = pd.DataFrame({"k": [1, 2, 3]})
b = pd.DataFrame({"k": [2, 2, 5]})
print(len(a.merge(b, on="k", how="inner")))
--- options
* 2
1
3
4
--- explain
Only key 2 appears in both tables. In `b` it appears twice, so the single 2 in `a` is matched twice, giving two rows. Key 1 and 3 have no match and are dropped by the inner join.
```

## Recap

- A left join keeps every row of the main table; an inner join keeps only matches. Choose by what you cannot afford to lose.
- Check joins: compare row counts, and use `validate` to catch duplicate keys.
- `concat` stacks tables with the same columns.
- `pivot_table` turns long data into a grid, and `melt` turns a grid back into long data.

**Up next:** time series. Most business data is ordered by time, and dates need their own tools.
', 0, '[]', '[]', '2026-06-25T06:40:00.179Z', '2026-10-19T06:40:00.179Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_python_for_data_science_3_6', 'sec_python_for_data_science_3', 'crs_python_for_data_science', 'Time series: dates, resampling and rolling windows', 'interactive', 5, 1080, NULL, NULL, 'Most business data has a clock attached: orders happen on a day, sensors report every minute, subscriptions renew each month. Time series need three things pandas does well: parsing dates correctly, grouping them into periods such as weeks or months, and comparing each value with what came before. This lesson covers those three, and the mistakes that most often break them.

```python run
import io
import pandas as pd

CSV = """date,revenue
2026-01-01,120
2026-01-02,95
2026-01-05,140
2026-01-06,80
2026-01-09,160
2026-01-12,110
2026-01-13,175
2026-01-16,90
"""
daily = pd.read_csv(io.StringIO(CSV), parse_dates=["date"])
daily = daily.set_index("date")
daily
```

Setting the date as the index tells pandas that the rows are ordered by time, and unlocks the time-based methods below.

## Date parts

The `.dt` accessor gives the parts of a date as columns, which are useful for grouping and for spotting weekly patterns.

```python run
parts = daily.reset_index()
parts["weekday"] = parts["date"].dt.day_name()
parts["week"] = parts["date"].dt.isocalendar().week
print(parts[["date", "weekday", "week", "revenue"]])
```

## Resample: totals per period

`resample` groups by a time period. `"W"` means weeks ending on Sunday, and `"ME"` means calendar month ends.

```python run
weekly = daily["revenue"].resample("W").sum()
print(weekly)
```

Notice a week with no rows still appears, with a total of zero. That is correct: nothing was sold, and the calendar has no gap in it.

## Rolling windows: smooth the noise

A **rolling window** averages the last few values at each step. A 3-day average smooths day-to-day noise and shows the trend.

```python run
daily["rolling_3"] = daily["revenue"].rolling(3).mean().round(1)
print(daily)
```

The first two rolling values are missing, because there are not yet three days to average. That is the honest answer, not a bug.

## Change over time

`pct_change` compares each value with the previous one, and `shift` moves values down by a number of rows so you can line up a value with its past.

```python run
daily["day_over_day"] = daily["revenue"].pct_change().round(3)
daily["yesterday"] = daily["revenue"].shift(1)
print(daily[["revenue", "yesterday", "day_over_day"]].head(4))
```

> **Pitfall:** `shift`, `rolling` and `pct_change` depend on row order. They look at the previous row, not the previous date. If the rows are not sorted by time first, the comparisons are meaningless, so call `sort_index()` before doing them.

## Challenge: weekly totals

```python exercise id=weekly-totals title="Weekly revenue totals"
import pandas as pd

# TODO: `weekly_totals(df)` takes a table with a datetime column "date" and a numeric column "revenue".
# Return a Series with the total revenue for each week that ends on Sunday, indexed by the week''s dates
# using the "W" rule of resample. Weeks with no sales must appear with a total of 0.
def weekly_totals(df):
    ...
--- solution
import pandas as pd

def weekly_totals(df):
    series = df.set_index("date")["revenue"].sort_index()
    return series.resample("W").sum()
--- test
import pandas as pd
df = pd.DataFrame({
    "date": pd.to_datetime(["2026-01-20", "2026-01-05", "2026-01-06"]),
    "revenue": [5.0, 10.0, 20.0],
})
result = weekly_totals(df)
assert result is not None, "Replace the `...` in `weekly_totals` with code that returns the weekly Series."
assert isinstance(result, pd.Series), "The result should be a Series."
assert list(result.values) == [30.0, 0.0, 5.0], f"The rows on 5 and 6 January share a week (30), the week of 12 January is empty (0), and 20 January gives 5. You returned {list(result.values)}. Sort by date, then resample by week."
assert len(result) == 3, "Weeks with no sales must still appear in the result."
--- hint
Put the dates in the index, sort it, then call `resample("W")` followed by `sum()`.
--- hint
`series = df.set_index("date")["revenue"].sort_index()`, then `series.resample("W").sum()`.
```

## Challenge: a rolling average in time order

```python exercise id=rolling-average title="Rolling average in date order"
import pandas as pd

# TODO: `rolling_average(df, window)` takes a table with a datetime column "date" and a numeric column "revenue"
# (rows may be unsorted). Sort by date, then return a Series of the rolling mean of revenue over `window` rows,
# indexed by date.
def rolling_average(df, window):
    ...
--- solution
import pandas as pd

def rolling_average(df, window):
    ordered = df.sort_values("date").set_index("date")["revenue"]
    return ordered.rolling(window).mean()
--- test
import pandas as pd
df = pd.DataFrame({
    "date": pd.to_datetime(["2026-01-03", "2026-01-01", "2026-01-02", "2026-01-04"]),
    "revenue": [30.0, 10.0, 20.0, 40.0],
})
result = rolling_average(df, 2)
assert result is not None, "Replace the `...` in `rolling_average` with code that returns the rolling Series."
assert list(result.values[1:]) == [15.0, 25.0, 35.0], f"In date order the 2-day averages are NaN, 15, 25, 35, but you returned {list(result.values)}. Sort by date first."
assert pd.isna(result.iloc[0]), "The first value has no full window, so it is missing."
--- hint
Sort the rows by date before you compute the rolling window.
--- hint
`df.sort_values("date").set_index("date")["revenue"].rolling(window).mean()`.
```

## Debug the rolling order

This code is meant to compute a 2-day rolling average in date order, but the rows are not sorted first.

```python debug id=sort-first title="Sort by time before you roll"
import pandas as pd

ts = pd.DataFrame({
    "date": pd.to_datetime(["2026-01-03", "2026-01-01", "2026-01-02"]),
    "revenue": [30.0, 10.0, 20.0],
})
ts["rolling_2"] = ts["revenue"].rolling(2).mean()      # bug: the rows are not in date order yet
ts = ts.sort_values("date")
print(ts)
--- solution
import pandas as pd

ts = pd.DataFrame({
    "date": pd.to_datetime(["2026-01-03", "2026-01-01", "2026-01-02"]),
    "revenue": [30.0, 10.0, 20.0],
})
ts = ts.sort_values("date")
ts["rolling_2"] = ts["revenue"].rolling(2).mean()
print(ts)
--- test
assert list(ts["revenue"]) == [10.0, 20.0, 30.0], "The table should be in date order."
assert ts["rolling_2"].iloc[1] == 15.0 and ts["rolling_2"].iloc[2] == 25.0, f"In date order the 2-day averages are 15 and 25, but the table has {list(ts[''rolling_2''])}. Sort by date before you calculate the rolling values."
--- hint
Rolling windows look at the previous rows. The rows must be in date order first.
--- hint
Move `ts = ts.sort_values("date")` above the rolling line.
```

## Predict the rolling value

```python predict id=predict-rolling title="What is the second value?"
import pandas as pd
s = pd.Series([2.0, 4.0, 6.0, 8.0])
print(s.rolling(2).mean().iloc[1])
--- options
* 3.0
2.0
4.0
6.0
--- explain
A 2-row window at position 1 covers the values 2 and 4, whose mean is 3. The first position has no full window, so it is missing.
```

## Recap

- Set the date as the index and sort it, so time-based methods work on the right order.
- `resample("W")` or `resample("ME")` groups rows by period, and empty periods appear as zero.
- `rolling` smooths a series, and its first values are missing until the window fills.
- `shift` and `pct_change` compare each value with the previous row, so sort first.

**Up next:** visualization. A table of numbers rarely tells the story on its own, and a good chart makes the pattern visible at once.
', 0, '[]', '[]', '2026-06-25T06:40:00.179Z', '2026-10-19T06:40:00.179Z'),
('les_python_for_data_science_3_7', 'sec_python_for_data_science_3', 'crs_python_for_data_science', 'Checkpoint: pandas essentials', 'quiz', 6, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"You want the number of rows per city, counting rows whose units value is missing. Which call does this?","options":["df.groupby(''city'')[''units''].count()","df.groupby(''city'')[''units''].size()","df.groupby(''city'').sum()","df[''city''].count()"],"answerIndex":1,"explanation":"size() counts every row in each group, including missing values. count() skips missing values, so it can give a smaller number."},{"id":"q2","prompt":"Which operation keeps every row of the orders table, adding region data where a match exists?","options":["orders.merge(regions, on=''city'', how=''inner'')","orders.merge(regions, on=''city'', how=''left'')","regions.merge(orders, on=''city'', how=''right'')","pd.concat([orders, regions])"],"answerIndex":1,"explanation":"A left join keeps all rows of the left table. An inner join would drop orders with no matching region, and concat stacks rows rather than joining them."},{"id":"q3","prompt":"What does pd.to_numeric(values, errors=''coerce'') do with a value such as ''n/a''?","options":["Raises an error and stops","Converts it to 0","Converts it to a missing value (NaN)","Keeps it as text"],"answerIndex":2,"explanation":"With errors=''coerce'', unreadable values become NaN, so you can count them and decide how to handle them."},{"id":"q4","prompt":"A lookup table has two rows for the same key, and you merge it into a table of orders. What is the likely result?","options":["Each order is kept once, with the first region","The orders are duplicated, which inflates totals","pandas removes the duplicate lookup rows automatically","The merge fails and nothing is returned"],"answerIndex":1,"explanation":"A many-to-many or one-to-many match multiplies the rows. Validating the join, for example with validate=''many_to_one'', catches this."},{"id":"q5","prompt":"Why should you call sort_index() before computing a rolling average of a time series?","options":["Rolling averages require the index to be numbers","Rolling windows use the previous rows, so the rows must be in time order","It makes the calculation faster","It removes missing values"],"answerIndex":1,"explanation":"A rolling window looks at the previous rows, not the previous dates. If the rows are out of time order, the averages mix up different periods."}]', '[]', '2026-06-25T06:40:00.179Z', '2026-10-19T06:40:00.179Z'),
('les_python_for_data_science_4_1', 'sec_python_for_data_science_4', 'crs_python_for_data_science', 'Plotting with matplotlib from first principles', 'interactive', 0, 960, NULL, NULL, 'A chart is an argument made with shapes. Before you can make honest charts, you need to know what matplotlib is doing underneath: a **figure** is the whole canvas, and each **axes** is a plotting area with its own x and y scales. Every chart you will ever draw is built from those two parts, and once you understand them, the rest of plotting is choosing the right shape for the question.

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
assert ax.get_ylabel() != "", "The y-axis needs a label that says what the numbers measure, such as ''euros''."
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
', 0, '[]', '[]', '2026-06-25T06:40:00.179Z', '2026-10-19T06:40:00.179Z'),
('les_python_for_data_science_4_2', 'sec_python_for_data_science_4', 'crs_python_for_data_science', 'Plotting DataFrames and choosing the right chart', 'interactive', 1, 960, NULL, NULL, 'Once your data is in a DataFrame, pandas can draw the common charts in one line each, and it chooses sensible defaults. Those one-liners are fast, but a plot is only as useful as the summary behind it. This lesson shows how to plot straight from a DataFrame, how to group before plotting, and how to pick the chart that answers the question you actually have.

```python run
import io
import pandas as pd
import matplotlib.pyplot as plt

CSV = """date,city,product,units,price
2026-01-03,Lyon,Tea,4,6.50
2026-01-03,Paris,Coffee,2,9.00
2026-01-04,Lyon,Coffee,1,9.00
2026-01-05,Nice,Tea,6,6.50
2026-01-06,Paris,Tea,5,6.50
2026-01-07,Nice,Coffee,3,9.50
2026-01-08,Lyon,Tea,2,6.50
2026-01-09,Paris,Coffee,4,9.50
2026-01-10,Nice,Tea,7,6.50
2026-01-11,Lyon,Coffee,3,9.00
"""
sales = pd.read_csv(io.StringIO(CSV), parse_dates=["date"])
sales["revenue"] = sales["units"] * sales["price"]
print("loaded", len(sales), "orders")
```

## Plot a summary, not raw rows

The usual pipeline is to summarize first, then plot the summary. The chart shows one bar per city, which a reader can compare at a glance.

```python run
city_revenue = sales.groupby("city")["revenue"].sum().sort_values(ascending=False)

fig, ax = plt.subplots(figsize=(5, 3))
city_revenue.plot(kind="bar", ax=ax, color="#4c78a8")
ax.set_ylabel("revenue (€)")
ax.set_title("Revenue by city")
ax.tick_params(axis="x", rotation=0)
plt.tight_layout()
plt.show()
```

## Trends over time

Resample to a regular period first, then draw a line. Plotting every raw order against time would be a cloud of points that hides the trend.

```python run
daily = sales.set_index("date")["revenue"].resample("D").sum()

fig, ax = plt.subplots(figsize=(6, 3))
daily.plot(ax=ax, marker="o")
ax.set_ylabel("revenue (€)")
ax.set_title("Daily revenue")
ax.grid(alpha=0.3)
plt.show()
```

## Compare product mixes with a stacked bar

```python run
mix = sales.pivot_table(index="city", columns="product", values="units", aggfunc="sum", fill_value=0)
fig, ax = plt.subplots(figsize=(5, 3))
mix.plot(kind="bar", stacked=True, ax=ax)
ax.set_ylabel("units")
ax.set_title("Units by city and product")
ax.tick_params(axis="x", rotation=0)
plt.tight_layout()
plt.show()
```

A stacked bar shows totals and parts together, but comparing the parts across bars is hard. If the question is about the parts, use grouped bars or small multiples instead.

## Boxplots for spread across groups

```python run
fig, ax = plt.subplots(figsize=(5, 3))
sales.boxplot(column="units", by="city", ax=ax)
ax.set_title("Units per order, by city")
ax.set_xlabel("")
ax.set_ylabel("units")
plt.suptitle("")
plt.tight_layout()
plt.show()
```

A boxplot shows the median, the middle half of the values, and the extremes. It is the right chart when you want to compare distributions, not only averages.

## Challenge: a summary table for plotting

```python exercise id=plot-summary title="Prepare the data for a chart"
import pandas as pd

# TODO: `plot_summary(df)` takes a table with columns city and revenue. Return a DataFrame with one row
# per city, sorted by revenue from highest to lowest, and two columns: "revenue" (the total) and
# "share" (that total as a fraction of the grand total, rounded to 3 decimals).
def plot_summary(df):
    ...
--- solution
import pandas as pd

def plot_summary(df):
    totals = df.groupby("city")["revenue"].sum().sort_values(ascending=False)
    share = (totals / totals.sum()).round(3)
    return pd.DataFrame({"revenue": totals, "share": share})
--- test
import pandas as pd
df = pd.DataFrame({"city": ["Lyon", "Paris", "Lyon", "Nice"], "revenue": [10.0, 25.0, 20.0, 40.0]})
result = plot_summary(df)
assert result is not None, "Replace the `...` in `plot_summary` with code that returns the summary table."
assert result.index.tolist() == ["Nice", "Lyon", "Paris"], f"Nice (40), Lyon (30) and Paris (25) should be listed from highest to lowest revenue, but the order is {result.index.tolist()}."
assert result.loc["Nice", "revenue"] == 40.0 and result.loc["Lyon", "revenue"] == 30.0, "The revenue column should hold each city''s total."
assert abs(result.loc["Nice", "share"] - 0.421) < 1e-9, "The grand total is 95, so Nice''s share is 40 / 95, rounded to 0.421."
assert list(result.columns) == ["revenue", "share"], "The table should have exactly the revenue and share columns."
--- hint
Group by city and sum the revenue, then sort from highest to lowest.
--- hint
Divide each total by the sum of all the totals to get the share, then round it.
--- hint
`totals = df.groupby("city")["revenue"].sum().sort_values(ascending=False)`, then build the table with `pd.DataFrame({"revenue": totals, "share": (totals / totals.sum()).round(3)})`.
```

## Challenge: the top entries for a chart

```python exercise id=top-for-chart title="Keep the largest entries for a chart"
import pandas as pd

# TODO: `top_for_chart(series, n)` returns the `n` largest values of a Series, sorted from largest to smallest.
# If the Series has fewer than `n` values, return all of them.
def top_for_chart(series, n):
    ...
--- solution
import pandas as pd

def top_for_chart(series, n):
    return series.sort_values(ascending=False).head(n)
--- test
import pandas as pd
s = pd.Series({"Tea": 3.0, "Coffee": 9.0, "Cocoa": 5.0, "Water": 1.0})
result = top_for_chart(s, 2)
assert result is not None, "Replace the `...` in `top_for_chart` with code that returns the Series."
assert list(result.index) == ["Coffee", "Cocoa"], f"The two largest are Coffee (9) and Cocoa (5), but you returned {list(result.index)}."
assert len(top_for_chart(s, 10)) == 4, "Asking for more than exist should return all of them."
--- hint
Sort in descending order, then take the first n with `head`.
--- hint
`series.sort_values(ascending=False).head(n)`.
```

## Debug the chart input

This code builds a bar chart of revenue per city, but the bars are the wrong height.

```python debug id=plot-units title="Plot revenue, not units"
import io
import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv(io.StringIO("city,units,price\nLyon,4,6.5\nParis,2,9.0\nLyon,1,6.5\n"))
df["revenue"] = df["units"] * df["price"]
totals = df.groupby("city")["units"].sum()     # bug: this sums units, not revenue
fig, ax = plt.subplots(figsize=(4, 3))
totals.plot(kind="bar", ax=ax)
plt.close(fig)
print(totals)
--- solution
import io
import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv(io.StringIO("city,units,price\nLyon,4,6.5\nParis,2,9.0\nLyon,1,6.5\n"))
df["revenue"] = df["units"] * df["price"]
totals = df.groupby("city")["revenue"].sum()
fig, ax = plt.subplots(figsize=(4, 3))
totals.plot(kind="bar", ax=ax)
plt.close(fig)
print(totals)
--- test
assert abs(totals["Lyon"] - 32.5) < 1e-9, f"Lyon''s revenue is 4 × 6.5 + 1 × 6.5 = 32.5, but totals says {totals[''Lyon'']}. Sum the revenue column."
assert abs(totals["Paris"] - 18.0) < 1e-9, "Paris''s revenue is 2 × 9 = 18."
--- hint
The chart title and axis say revenue, so the data must be revenue. Check which column the sum is taken from.
--- hint
Group the `revenue` column, not `units`.
```

## Predict the bar count

```python predict id=predict-bars title="How many bars does the chart have?"
import pandas as pd
df = pd.DataFrame({"city": ["Lyon", "Paris", "Lyon", "Nice", "Nice"], "revenue": [1, 2, 3, 4, 5]})
print(len(df.groupby("city")["revenue"].sum()))
--- options
* 3
5
2
4
--- explain
Grouping collapses rows into one result per distinct city. There are three cities, so the bar chart has three bars, not one per row.
```

## Recap

- Summarize first, then plot. A chart of one bar per group is easier to read than a cloud of raw rows.
- Use lines for trends over time after resampling, bars for comparison, stacked bars for totals with parts, and boxplots for spread.
- Check the column you plot: the title and the data must describe the same quantity.
- Keep one question per chart.

**Up next:** charts that tell the truth. Plots can mislead as easily as they clarify.
', 0, '[]', '[]', '2026-06-25T06:40:00.179Z', '2026-10-19T06:40:00.179Z'),
('les_python_for_data_science_4_3', 'sec_python_for_data_science_4', 'crs_python_for_data_science', 'Charts that tell the truth', 'interactive', 2, 840, NULL, NULL, 'A chart can be accurate and still mislead. A truncated axis makes a small difference look enormous. Too many colours hide the one point you wanted to make. A pie chart with eleven slices asks the reader to compare angles they cannot judge. Honest charts are a discipline, and the rules are simple: start bars at zero, label everything, use colour with purpose, and let the chart answer one question.

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

```python exercise id=honest-limit title="Choose a bar chart''s lower limit"
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
This is a rule, not a calculation: a bar chart''s baseline is zero.
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
assert ax.get_ylim()[0] == 0, f"A bar chart''s lower limit should be 0 for an honest comparison, but it is {ax.get_ylim()[0]}."
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
', 0, '[]', '[]', '2026-06-25T06:40:00.179Z', '2026-10-19T06:40:00.179Z'),
('les_python_for_data_science_5_1', 'sec_python_for_data_science_5', 'crs_python_for_data_science', 'A repeatable exploratory workflow', 'interactive', 0, 1080, NULL, NULL, 'Exploratory data analysis, or EDA, is the stage where you get to know a dataset before you trust anything it says. Good analysts follow a rough routine: state the question, check the structure, check the gaps, look at each variable on its own, look at how variables relate, and write down what you found and what you doubt. The routine matters more than any single method, because it is what keeps you from answering the wrong question with confident-looking numbers.

## Start with a question

Write the question down before you touch the data. "Which product should we promote?" is vague. "Which product has the highest revenue per order, after returns, in the last quarter?" tells you which columns and which rows matter, and it stops you from wandering.

## Check the structure

The first look at a dataset answers: how many rows, which columns, what types, and what one row represents.

```python run
import numpy as np
import pandas as pd

rng = np.random.default_rng(3)
n = 300
orders = pd.DataFrame({
    "order_id": np.arange(1, n + 1),
    "customer": rng.integers(1, 80, n),
    "city": rng.choice(["Lyon", "Paris", "Nice", "Lille"], n, p=[0.3, 0.35, 0.2, 0.15]),
    "product": rng.choice(["Tea", "Coffee", "Cocoa"], n, p=[0.4, 0.4, 0.2]),
    "units": rng.poisson(3, n) + 1,
    "price": rng.uniform(5, 12, n).round(2),
})
orders.loc[rng.random(n) < 0.05, "price"] = np.nan      # some prices were never recorded
orders.loc[rng.random(n) < 0.02, "units"] = 0           # zero-unit orders look suspicious

print("rows:", len(orders), "| columns:", orders.shape[1])
print("one row is one order:", orders["order_id"].is_unique)
orders.head()
```

Asking "is `order_id` unique?" is a real check. If an identifier repeats, every count built on it is suspect.

## Check the gaps

```python run
missing = orders.isna().sum()
print(missing[missing > 0])
print("share of rows with any gap:", round(orders.isna().any(axis=1).mean(), 3))
```

Missing values are information. If prices are missing mostly in one city, that is a finding about the data collection, not only a cleaning chore.

## Look at each variable

For numbers, look at the range and the shape. For categories, look at how many values there are and how they are spread.

```python run
print(orders["units"].describe().round(2))
print(orders["product"].value_counts(normalize=True).round(3))
```

Sanity-check the minimum and maximum. A zero-unit order might be a legitimate return, or a data entry error, and you need to find out which before you use it.

## Test the question on a slice

Before computing the final answer, compute it for one group to see if the logic works and whether the numbers are sensible.

```python run
paris = orders[orders["city"] == "Paris"]
print("Paris orders:", len(paris), "| units:", paris["units"].sum())
```

## Write down what you found

A notebook is a record. Keep a short note for each finding: what you saw, how you checked it, and what you still doubt.

> **Pitfall:** the most dangerous EDA mistake is to stop after the first clean-looking summary. A table with no visible problems can still hide duplicates, a broken join, or a column that means something else than its name.

## Challenge: a missing-value report

```python exercise id=missing-report title="Report the columns with gaps"
import pandas as pd

# TODO: `missing_report(df)` returns a Series with the number of missing values in each column that has at
# least one, sorted from most to fewest. Columns with no missing values are left out.
def missing_report(df):
    ...
--- solution
import pandas as pd

def missing_report(df):
    counts = df.isna().sum()
    counts = counts[counts > 0]
    return counts.sort_values(ascending=False)
--- test
import numpy as np
import pandas as pd
df = pd.DataFrame({"a": [1, None, 3], "b": [None, None, 2], "c": [1, 2, 3]})
result = missing_report(df)
assert result is not None, "Replace the `...` in `missing_report` with code that returns the Series."
assert list(result.index) == ["b", "a"], f"Column b has two gaps and a has one, so the order should be b then a. You returned {list(result.index)}."
assert list(result.values) == [2, 1], "The counts should be 2 for b and 1 for a."
assert "c" not in result.index, "Columns with no gaps should not appear in the report."
--- hint
`df.isna().sum()` counts the missing values in each column. Keep only the counts above zero, then sort.
--- hint
`counts = df.isna().sum(); counts = counts[counts > 0]; return counts.sort_values(ascending=False)`.
```

## Challenge: profile one variable

```python exercise id=value-profile title="Profile a numeric variable"
import pandas as pd

# TODO: `value_profile(series)` returns a dictionary with the keys "observed" (the number of values that are not
# missing), "median", "min" and "max" for a numeric Series. Ignore missing values in every statistic.
def value_profile(series):
    ...
--- solution
import pandas as pd

def value_profile(series):
    observed = series.dropna()
    return {"observed": int(observed.count()), "median": float(observed.median()),
            "min": float(observed.min()), "max": float(observed.max())}
--- test
import numpy as np
import pandas as pd
result = value_profile(pd.Series([4.0, np.nan, 1.0, 7.0]))
assert result is not None, "Replace the `...` in `value_profile` with code that returns the dictionary."
assert result["observed"] == 3, "Three values are observed, because one is missing."
assert result["median"] == 4.0, f"The median of 1, 4 and 7 is 4, but you returned {result[''median'']}."
assert result["min"] == 1.0 and result["max"] == 7.0, "The minimum is 1 and the maximum is 7."
--- hint
Drop the missing values first, so every statistic uses only the observed values.
--- hint
`observed = series.dropna()`, then count, median, min and max on `observed`.
```

## Debug the count of customers

This code is meant to count distinct customers, but it counts orders.

```python debug id=distinct-customers title="Count customers, not rows"
import pandas as pd

orders = pd.DataFrame({"customer": [1, 1, 2, 3, 3, 3], "units": [2, 1, 4, 1, 1, 2]})
customers = len(orders["customer"])           # bug: this is the number of rows
print("distinct customers:", customers)
--- solution
import pandas as pd

orders = pd.DataFrame({"customer": [1, 1, 2, 3, 3, 3], "units": [2, 1, 4, 1, 1, 2]})
customers = orders["customer"].nunique()
print("distinct customers:", customers)
--- test
assert customers == 3, f"There are three distinct customers (1, 2 and 3), but the code reports {customers}. Count unique values, not rows."
--- hint
`len` counts every row, including repeat orders from the same customer.
--- hint
Use `nunique()`, which counts distinct values in a column.
```

## Predict the answer

```python predict id=predict-eda title="How many missing prices are there?"
import pandas as pd
df = pd.DataFrame({"price": [1.0, None, None, 4.0, None]})
print(df["price"].isna().sum())
--- options
* 3
2
4
5
--- explain
There are five rows, and three of them have no price. `isna` marks the missing entries, and `sum` counts the marks.
```

## Recap

- Start with a question, so you know which columns and rows matter.
- Check the structure: row count, uniqueness of identifiers, and types.
- Look at gaps, and each variable on its own, including its extremes.
- Test the logic on a slice, and write down what you found and what you doubt.

**Up next:** relationships between variables, and the outliers that can distort every average.
', 0, '[]', '[]', '2026-06-25T06:40:00.179Z', '2026-10-19T06:40:00.179Z'),
('les_python_for_data_science_5_2', 'sec_python_for_data_science_5', 'crs_python_for_data_science', 'Relationships, correlation and outliers', 'interactive', 1, 1080, NULL, NULL, 'Once you know what each variable looks like, the next questions are about pairs: do units and revenue move together, does one city sell at higher prices, and are some values so extreme that they change every average? This lesson covers correlation as a summary of a relationship, the outliers that can make it lie, and the simple rules that flag suspicious values.

```python run
import numpy as np
import pandas as pd

rng = np.random.default_rng(7)
n = 200
ads = rng.uniform(0, 50, n)
sales = 40 + 2.5 * ads + rng.normal(0, 12, n)
frame = pd.DataFrame({"ads": ads, "sales": sales, "returns": rng.poisson(2, n)})
frame.corr().round(2)
```

## Correlation: how well a line describes a pair

The correlation coefficient runs from -1 to 1. Near 1 means the two variables rise together, near -1 means one falls as the other rises, and near 0 means no linear relationship. Here, advertising and sales are strongly related, while returns are unrelated to both.

```python run
print("ads vs sales:", round(frame["ads"].corr(frame["sales"]), 3))
print("ads vs returns:", round(frame["ads"].corr(frame["returns"]), 3))
```

> **Pitfall:** correlation measures a straight-line relationship only, and it is badly distorted by a single extreme point. Always look at a scatter plot before you trust a coefficient.

## A correlation an outlier made

```python run
x = np.arange(1, 11, dtype=float)
y = x * 0.5 + np.array([0.2, -0.3, 0.1, 0.0, -0.2, 0.3, -0.1, 0.2, 0.0, -0.2])
with_outlier = np.append(x, 40.0), np.append(y, 2.0)
print("without the outlier:", round(np.corrcoef(x, y)[0, 1], 3))
print("with one extreme point:", round(np.corrcoef(with_outlier[0], with_outlier[1])[0, 1], 3))
```

The first line is a clean, strong relationship. Adding one strange point at x = 40 changes the picture, even though the other ten points are unchanged. Outliers can create a relationship, hide one, or flip its sign.

## Flag outliers with the IQR rule

The **interquartile range** (IQR) is the distance between the first and third quartiles, the middle half of the data. A common rule marks any value more than 1.5 IQRs beyond the quartiles as a potential outlier.

```python run
q1, q3 = frame["sales"].quantile([0.25, 0.75])
iqr = q3 - q1
low, high = q1 - 1.5 * iqr, q3 + 1.5 * iqr
flags = (frame["sales"] < low) | (frame["sales"] > high)
print("bounds:", round(low, 1), "to", round(high, 1))
print("flagged:", int(flags.sum()), "of", len(frame))
```

A flag is a question, not a verdict. Before you remove a value, find out why it is extreme. A very large order from a wholesale customer is real and often the most important row in the data.

## Skewed data and the log scale

Money, counts and durations are often skewed, with a long tail. A logarithm pulls the tail in, so typical values and extreme values can both be seen.

```python run
orders = rng.lognormal(mean=3.0, sigma=0.8, size=500)
print("mean:", round(orders.mean(), 1), "| median:", round(np.median(orders), 1))
print("log-mean:", round(np.log(orders).mean(), 2), "| exp of log-mean:", round(np.exp(np.log(orders).mean()), 1))
```

When the mean sits well above the median, a few large values drive it. Report the median alongside the mean for skewed variables.

## Challenge: flag outliers

```python exercise id=iqr-outliers title="Flag outliers with the IQR rule"
import pandas as pd

# TODO: `iqr_outliers(values)` takes a pandas Series of numbers and returns a boolean Series of the same
# length that is True where a value is below Q1 − 1.5·IQR or above Q3 + 1.5·IQR, where IQR = Q3 − Q1.
def iqr_outliers(values):
    ...
--- solution
import pandas as pd

def iqr_outliers(values):
    q1 = values.quantile(0.25)
    q3 = values.quantile(0.75)
    iqr = q3 - q1
    return (values < q1 - 1.5 * iqr) | (values > q3 + 1.5 * iqr)
--- test
import pandas as pd
values = pd.Series([10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 60.0])
result = iqr_outliers(values)
assert result is not None, "Replace the `...` in `iqr_outliers` with code that returns the flags."
assert isinstance(result, pd.Series) and len(result) == len(values), "Return one flag per value, as a Series of the same length."
assert result.tolist() == [False, False, False, False, False, False, True], f"Only 60 should be flagged, but you returned {result.tolist()}."
assert not iqr_outliers(pd.Series([1.0, 2.0, 3.0])).any(), "Evenly spaced values have no outliers under this rule."
--- hint
Compute the quartiles with `values.quantile(0.25)` and `values.quantile(0.75)`, then the fences from the IQR. Compare each value with both fences.
--- hint
`return (values < q1 - 1.5 * iqr) | (values > q3 + 1.5 * iqr)`.
```

## Challenge: a correlation from scratch

```python exercise id=pearson title="Correlation from scratch"
import numpy as np

# TODO: `pearson(x, y)` returns the Pearson correlation coefficient of two equal-length arrays, using
# the formula: covariance divided by the product of the two standard deviations. Use the mean-centered values.
def pearson(x, y):
    ...
--- solution
import numpy as np

def pearson(x, y):
    x = np.asarray(x, dtype=float)
    y = np.asarray(y, dtype=float)
    xc = x - x.mean()
    yc = y - y.mean()
    return float((xc * yc).sum() / np.sqrt((xc ** 2).sum() * (yc ** 2).sum()))
--- test
import numpy as np
result = pearson([1.0, 2.0, 3.0], [2.0, 4.0, 6.0])
assert result is not None, "Replace the `...` in `pearson` with code that returns the coefficient."
assert np.isclose(result, 1.0), f"y is exactly 2x, so the correlation is 1, but you returned {result!r}."
assert np.isclose(pearson([1.0, 2.0, 3.0], [6.0, 4.0, 2.0]), -1.0), "A perfectly decreasing line has correlation -1."
assert np.isclose(pearson([1.0, 2.0, 3.0], [1.0, 3.0, 2.0]), 0.5), "Check the formula on this example: the answer is 0.5."
--- hint
Subtract each array''s mean. The numerator is the sum of the products of the centered values, and the denominator is the square root of the product of the two sums of squares.
--- hint
`num = (xc * yc).sum()` and `den = np.sqrt((xc ** 2).sum() * (yc ** 2).sum())`, then return `num / den`.
```

## Debug the fence

This code is meant to flag the same outlier, but it misses it because one fence has the wrong sign.

```python debug id=fence-sign title="Flag values above the upper fence"
import pandas as pd

values = pd.Series([10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 60.0])
q1, q3 = values.quantile(0.25), values.quantile(0.75)
iqr = q3 - q1
upper = q3 - 1.5 * iqr           # bug: the upper fence must be above Q3
flags = values > upper
print(flags.tolist())
--- solution
import pandas as pd

values = pd.Series([10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 60.0])
q1, q3 = values.quantile(0.25), values.quantile(0.75)
iqr = q3 - q1
upper = q3 + 1.5 * iqr
flags = values > upper
print(flags.tolist())
--- test
assert upper > q3, f"The upper fence should sit above the third quartile ({q3}), but it is {upper}."
assert flags.tolist() == [False, False, False, False, False, False, True], f"Only 60 should be flagged, but the flags are {flags.tolist()}."
--- hint
The upper fence is Q3 plus 1.5 times the IQR, so it is larger than Q3, not smaller.
--- hint
Change the minus sign to a plus sign.
```

## Predict the correlation

```python predict id=predict-corr title="What is the correlation of a variable with itself?"
import pandas as pd
s = pd.Series([3.0, 1.0, 4.0, 1.0, 5.0])
print(round(s.corr(s), 1))
--- options
* 1.0
0.0
-1.0
0.5
--- explain
A variable is perfectly correlated with itself, so the coefficient is exactly 1. This is a useful sanity check when you build a correlation table.
```

## Recap

- Correlation summarizes a straight-line relationship and is distorted by outliers. Plot the pair before trusting the number.
- The IQR rule flags values beyond 1.5 IQRs from the quartiles. A flag is a question to investigate, not a reason to delete.
- For skewed data, report the median alongside the mean, and consider a log scale.
- Never remove an extreme value without understanding it first.

**Up next:** a complete capstone analysis of a sales dataset, using every step in this course.
', 0, '[]', '[]', '2026-06-25T06:40:00.179Z', '2026-10-19T06:40:00.179Z'),
('les_python_for_data_science_5_3', 'sec_python_for_data_science_5', 'crs_python_for_data_science', 'Capstone: a complete sales analysis', 'interactive', 2, 1800, NULL, NULL, 'This is the capstone. You will analyze a sales dataset from start to finish, the way you would for a real business question: load it, check it, clean it, answer questions with grouped summaries and time series, show the results in charts, and write down what you can and cannot conclude.

The question is this: **how is revenue changing, which products and cities matter most, and where are returns a problem?**

The dataset is generated in the page, and like real exports it is messy: inconsistent city spellings, missing prices and duplicate rows. Nothing has been prepared for you.

## Load and inspect

```python run
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

def make_sales(seed=11, n=360):
    rng = np.random.default_rng(seed)
    dates = pd.Timestamp("2026-01-01") + pd.to_timedelta(rng.integers(0, 181, n), unit="D")
    city = rng.choice(["Lyon", "Paris", "Nice", "Lille"], n, p=[0.3, 0.35, 0.2, 0.15])
    product = rng.choice(["Tea", "Coffee", "Cocoa"], n, p=[0.4, 0.4, 0.2])
    base = pd.Series(product).map({"Tea": 6.5, "Coffee": 9.0, "Cocoa": 7.5}).to_numpy()
    unit_price = (base * rng.uniform(0.95, 1.10, n)).round(2)
    units = rng.poisson(3, n) + 1
    returned = rng.random(n) < np.where(city == "Nice", 0.15, 0.05)
    df = pd.DataFrame({
        "order_id": np.arange(1, n + 1), "date": dates, "city": city, "product": product,
        "units": units, "unit_price": unit_price, "returned": returned,
    })
    messy = rng.random(n) < 0.05
    df.loc[messy, "city"] = " " + df.loc[messy, "city"].str.upper() + " "
    df.loc[rng.random(n) < 0.04, "unit_price"] = np.nan
    return pd.concat([df, df.iloc[:3]], ignore_index=True)   # three exact duplicate rows

raw = make_sales()
print("rows:", len(raw), "| missing prices:", int(raw["unit_price"].isna().sum()))
print("distinct city spellings:", raw["city"].nunique())
raw.head()
```

Three things need attention before any calculation: the city names have stray spaces and capitals, some prices are missing, and some rows are duplicated.

## Clean

```python run
def clean(df):
    out = df.copy()
    out["city"] = out["city"].str.strip().str.title()
    out = out.drop_duplicates()
    out = out.dropna(subset=["unit_price"])
    return out.reset_index(drop=True)

sales = clean(raw)
print("rows before:", len(raw), "| after:", len(sales))
print("cities:", sorted(sales["city"].unique()))
```

Dropping the missing prices removes about four per cent of orders. That is a decision, and it biases revenue downward if the missing prices are not random. A careful analyst reports it, and may check whether the dropped orders differ from the rest.

## Revenue over time

```python run
sales["revenue"] = sales["units"] * sales["unit_price"]
monthly = sales.set_index("date")["revenue"].resample("ME").sum()
growth = (monthly.pct_change() * 100).round(1)
print(pd.DataFrame({"revenue": monthly.round(0), "growth %": growth}))
```

The first month has no growth figure, because there is no earlier month to compare with. Read the growth column as a trend, not as a precise forecast.

## Products and cities

```python run
by_product = sales.groupby("product").agg(
    orders=("order_id", "size"),
    revenue=("revenue", "sum"),
    avg_units=("units", "mean"),
).sort_values("revenue", ascending=False)
print(by_product.round(1))

by_city = sales.groupby("city").agg(
    orders=("order_id", "size"),
    revenue=("revenue", "sum"),
    return_rate=("returned", "mean"),
).sort_values("return_rate", ascending=False)
print(by_city.round(3))
```

`returned` is a yes-or-no column, so its mean is the share of orders returned.

## Show the results

```python run
fig, axes = plt.subplots(1, 2, figsize=(9, 3.5))
axes[0].plot(monthly.index, monthly.values, marker="o")
axes[0].set_title("Monthly revenue")
axes[0].set_ylabel("euros")
axes[0].tick_params(axis="x", rotation=30)

axes[1].bar(by_city.index, by_city["return_rate"] * 100, color="#e45756")
axes[1].set_title("Return rate by city")
axes[1].set_ylabel("% of orders")
axes[1].set_ylim(0, max(10, by_city["return_rate"].max() * 110))
plt.tight_layout()
plt.show()
```

## Write the findings

A finding is a claim plus the evidence behind it. Compute the numbers in code, then state them.

```python run
top_product = by_product.index[0]
top_share = by_product["revenue"].iloc[0] / by_product["revenue"].sum()
worst_city = by_city.index[0]
print(f"1. {top_product} brings in {top_share:.0%} of revenue.")
print(f"2. {worst_city} has the highest return rate: {by_city.loc[worst_city, ''return_rate'']:.1%}.")
print(f"3. Based on {len(sales)} orders over {sales[''date''].dt.to_period(''M'').nunique()} months.")
print("Limits: missing prices were dropped, and six months is a short history.")
```

Notice what the findings do not claim. A return rate difference between cities is an observation, not proof of the cause, and six months of data cannot show seasonality.

## Challenge: clean the sales table

```python exercise id=clean-sales title="Clean a raw sales table"
import pandas as pd

# TODO: `clean_sales(df)` returns a cleaned copy of a sales table. Strip spaces from the city and use title case,
# remove exact duplicate rows, drop rows whose unit_price is missing, and keep the original order with a
# fresh 0-based index.
def clean_sales(df):
    ...
--- solution
import pandas as pd

def clean_sales(df):
    out = df.copy()
    out["city"] = out["city"].str.strip().str.title()
    out = out.drop_duplicates()
    out = out.dropna(subset=["unit_price"])
    return out.reset_index(drop=True)
--- test
import pandas as pd
raw = pd.DataFrame({
    "city": [" lyon ", "PARIS", " lyon ", "nice"],
    "unit_price": [5.0, None, 5.0, 8.0],
    "units": [2, 1, 2, 3],
})
result = clean_sales(raw)
assert result is not None, "Replace the `...` in `clean_sales` with code that returns the cleaned table."
assert list(result["city"]) == ["Lyon", "Nice"], f"After cleaning the rows should be Lyon and Nice, but you returned {list(result[''city''])}. Strip spaces, use title case, remove the duplicate Lyon row and the row with no price."
assert list(result.index) == [0, 1], "Use a fresh 0-based index."
assert "unit_price" in result.columns and result["unit_price"].notna().all(), "No missing prices should remain."
--- hint
Do the steps in order: clean the city text, drop the duplicate rows, drop rows with no price, then reset the index.
--- hint
`out = df.copy(); out["city"] = out["city"].str.strip().str.title(); out = out.drop_duplicates().dropna(subset=["unit_price"]); return out.reset_index(drop=True)`.
```

## Challenge: monthly revenue

```python exercise id=monthly-revenue title="Revenue per month"
import pandas as pd

# TODO: `monthly_revenue(df)` takes a table with a datetime column "date", "units" and "unit_price". Compute the
# revenue of each order (units × unit_price), and return a Series of total revenue per calendar month, indexed by
# month end ("ME"). Months with no orders are included with 0.
def monthly_revenue(df):
    ...
--- solution
import pandas as pd

def monthly_revenue(df):
    revenue = df["units"] * df["unit_price"]
    return revenue.groupby(df["date"]).sum().resample("ME").sum()
--- test
import pandas as pd
df = pd.DataFrame({
    "date": pd.to_datetime(["2026-02-03", "2026-01-05", "2026-01-20"]),
    "units": [2, 2, 1],
    "unit_price": [10.0, 10.0, 5.0],
})
result = monthly_revenue(df)
assert result is not None, "Replace the `...` in `monthly_revenue` with code that returns the monthly Series."
assert list(result.values) == [25.0, 20.0], f"January is 20 + 5 = 25 and February is 20, but you returned {list(result.values)}. Order the months in time."
assert len(result) == 2, "There should be one row per month."
assert result.index[0].month == 1 and result.index[1].month == 2, "The first entry should be January and the second February."
--- hint
Compute the revenue column first. Then sum it per date, and resample by calendar month with `resample("ME")`.
--- hint
`revenue = df["units"] * df["unit_price"]`, then group it by the dates with `revenue.groupby(df["date"]).sum()`. A Series indexed by datetime can then be resampled with `.resample("ME").sum()`.
```

## Challenge: return rate by city

```python exercise id=return-rate title="Return rate per city"
import pandas as pd

# TODO: `return_rate_by_city(df)` takes a table with columns "city" and "returned" (True or False). Return a
# Series of the share of orders returned in each city, indexed by city, highest rate first.
def return_rate_by_city(df):
    ...
--- solution
import pandas as pd

def return_rate_by_city(df):
    rates = df.groupby("city")["returned"].mean()
    return rates.sort_values(ascending=False)
--- test
import pandas as pd
df = pd.DataFrame({
    "city": ["Lyon", "Lyon", "Paris", "Paris", "Paris", "Nice"],
    "returned": [True, False, False, False, False, True],
})
result = return_rate_by_city(df)
assert result is not None, "Replace the `...` in `return_rate_by_city` with code that returns the rates."
assert list(result.index) == ["Nice", "Lyon", "Paris"], f"Nice is 100%, Lyon 50% and Paris 0%, so the order should be Nice, Lyon, Paris. You returned {list(result.index)}."
assert abs(result["Lyon"] - 0.5) < 1e-9, "Lyon has one return in two orders, so its rate is 0.5."
assert abs(result["Paris"]) < 1e-9, "Paris has no returns."
--- hint
The mean of a True/False column is the share of True values, so `mean()` gives the rate directly.
--- hint
`rates = df.groupby("city")["returned"].mean(); return rates.sort_values(ascending=False)`.
```

## Debug the ranking

This code is meant to report the two highest-revenue products, but it returns the two lowest.

```python debug id=top-products title="Rank the highest revenue first"
import pandas as pd

revenue = pd.Series({"Tea": 1200.0, "Coffee": 2600.0, "Cocoa": 900.0}).sort_index()
top = revenue.sort_values().head(2)            # bug: ascending order puts the smallest first
print(top)
--- solution
import pandas as pd

revenue = pd.Series({"Tea": 1200.0, "Coffee": 2600.0, "Cocoa": 900.0}).sort_index()
top = revenue.sort_values(ascending=False).head(2)
print(top)
--- test
assert list(top.index) == ["Coffee", "Tea"], f"The two highest revenues are Coffee (2600) and Tea (1200), but top shows {list(top.index)}. Sort in descending order."
--- hint
`sort_values()` sorts in ascending order by default.
--- hint
Pass `ascending=False` before taking the first two rows.
```

## Predict the growth

```python predict id=predict-growth title="What is the growth from 100 to 150?"
import pandas as pd
s = pd.Series([100.0, 150.0])
print(round(s.pct_change().iloc[1] * 100, 1))
--- options
* 50.0
150.0
33.3
100.0
--- explain
`pct_change` computes (150 - 100) / 100 = 0.5, which is 50 per cent when multiplied by 100. The first value has no previous value, so it is missing, and the second value is the one that shows the change.
```

## Recap

- Start with a question and check the data before any calculation.
- Clean deliberately, and report every decision that removes or changes data.
- Answer with grouped summaries and time series, then show the answer in a chart with clear labels.
- Write findings as claims with evidence, and state their limits.

**Up next:** the final assessment, which checks the whole course.
', 0, '[]', '[]', '2026-06-25T06:40:00.179Z', '2026-10-19T06:40:00.179Z'),
('les_python_for_data_science_5_4', 'sec_python_for_data_science_5', 'crs_python_for_data_science', 'Final assessment: Python for Data Science', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"A dataset contains orders from one customer several times. What does df[''customer''].nunique() return?","options":["The number of orders","The number of distinct customers","The number of missing customers","The total of all customer ids"],"answerIndex":1,"explanation":"nunique counts distinct values, so repeat orders from the same customer count once."},{"id":"q2","prompt":"Why is it wrong to fill missing prices with zero before computing revenue?","options":["Zero is not a valid number","It invents sales of zero value where the price is simply unknown, which pulls averages down","It makes the calculation slower","pandas does not allow zeros in numeric columns"],"answerIndex":1,"explanation":"A missing price is not a zero price. Filling with zero silently treats unknown values as real zeros, so totals and averages are biased."},{"id":"q3","prompt":"Which result is a correct use of df.isna()?","options":["df.isna().sum() counts missing values in each column","df.isna() drops the missing rows","df.isna() replaces missing values with zero","df.isna() returns the number of rows"],"answerIndex":0,"explanation":"isna marks each missing entry as True. Summing those marks counts the missing values per column. It does not change the table."},{"id":"q4","prompt":"You want the share of orders returned in each city, given a True/False column returned. Which expression is correct?","options":["df.groupby(''city'')[''returned''].sum()","df.groupby(''city'')[''returned''].mean()","df.groupby(''city'')[''returned''].size()","df[''returned''].value_counts()"],"answerIndex":1,"explanation":"The mean of a True/False column is the fraction of True values, which is the share returned within each group."},{"id":"q5","prompt":"In a chart of revenue per city, what is the most important reason to start the bars at zero?","options":["It makes the chart load faster","Bar length encodes value, so a truncated baseline exaggerates differences","It is required by matplotlib","It removes outliers"],"answerIndex":1,"explanation":"Readers judge bars by their length. A baseline above zero makes small differences look large, which misleads."},{"id":"q6","prompt":"An IQR rule flags a value far above the others. What is the right next step?","options":["Delete it immediately","Investigate why it is extreme before deciding whether to keep it","Replace it with the mean","Ignore it because the rule flagged it"],"answerIndex":1,"explanation":"A flag is a question. An extreme value can be an error, or a real and important case such as a large wholesale order."},{"id":"q7","prompt":"After resampling daily sales to months with resample(''ME'').sum(), a month with no sales appears in the result. What value does it have?","options":["NaN","0","The previous month''s total","It is left out of the result"],"answerIndex":1,"explanation":"resample creates every period in the range, and summing an empty period gives 0. This keeps the calendar complete for trends and charts."}]', '[]', '2026-06-25T06:40:00.179Z', '2026-10-19T06:40:00.179Z');

INSERT INTO path_courses (path_id, course_id, position) VALUES
('pth_ml_engineer', 'crs_python_for_data_science', 1);

INSERT INTO enrollments (id, user_id, course_id, source, progress_percent, last_lesson_id, last_activity_at, completed_at, created_at) VALUES
('enr_crs_python_for_data_science_demo', 'usr_student', 'crs_python_for_data_science', 'free', 100, 'les_python_for_data_science_5_4', '2026-10-20T06:40:00.179Z', '2026-08-24T06:40:00.179Z', '2026-08-24T06:40:00.179Z');

INSERT INTO lesson_progress (user_id, lesson_id, course_id, completed, position_seconds, completed_at, updated_at) VALUES
('usr_student', 'les_python_for_data_science_1_1', 'crs_python_for_data_science', 1, 0, '2026-09-03T06:40:00.179Z', '2026-09-03T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_1_2', 'crs_python_for_data_science', 1, 0, '2026-09-04T06:40:00.179Z', '2026-09-04T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_1_3', 'crs_python_for_data_science', 1, 0, '2026-09-05T06:40:00.179Z', '2026-09-05T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_2_1', 'crs_python_for_data_science', 1, 0, '2026-09-06T06:40:00.179Z', '2026-09-06T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_2_2', 'crs_python_for_data_science', 1, 0, '2026-09-07T06:40:00.179Z', '2026-09-07T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_3_1', 'crs_python_for_data_science', 1, 0, '2026-09-08T06:40:00.179Z', '2026-09-08T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_3_2', 'crs_python_for_data_science', 1, 0, '2026-09-09T06:40:00.179Z', '2026-09-09T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_3_3', 'crs_python_for_data_science', 1, 0, '2026-09-10T06:40:00.179Z', '2026-09-10T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_3_4', 'crs_python_for_data_science', 1, 0, '2026-09-11T06:40:00.179Z', '2026-09-11T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_3_5', 'crs_python_for_data_science', 1, 0, '2026-09-12T06:40:00.179Z', '2026-09-12T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_3_6', 'crs_python_for_data_science', 1, 0, '2026-09-13T06:40:00.179Z', '2026-09-13T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_3_7', 'crs_python_for_data_science', 1, 0, '2026-09-14T06:40:00.179Z', '2026-09-14T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_4_1', 'crs_python_for_data_science', 1, 0, '2026-09-15T06:40:00.179Z', '2026-09-15T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_4_2', 'crs_python_for_data_science', 1, 0, '2026-09-16T06:40:00.179Z', '2026-09-16T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_4_3', 'crs_python_for_data_science', 1, 0, '2026-09-17T06:40:00.179Z', '2026-09-17T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_5_1', 'crs_python_for_data_science', 1, 0, '2026-09-18T06:40:00.179Z', '2026-09-18T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_5_2', 'crs_python_for_data_science', 1, 0, '2026-09-19T06:40:00.179Z', '2026-09-19T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_5_3', 'crs_python_for_data_science', 1, 0, '2026-09-20T06:40:00.179Z', '2026-09-20T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_5_4', 'crs_python_for_data_science', 1, 0, '2026-09-21T06:40:00.179Z', '2026-09-21T06:40:00.179Z');

INSERT INTO exercise_progress (user_id, lesson_id, cell_id, code, passed, attempts, solved_at, updated_at) VALUES
('usr_student', 'les_python_for_data_science_1_1', 'total-revenue', 'import pandas as pd

def total_revenue(df):
    return (df["units"] * df["price"]).sum()', 1, 2, '2026-09-03T06:40:00.179Z', '2026-09-03T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_1_1', 'chained-assign', 'import pandas as pd

df = pd.DataFrame({"item": ["pen", "lamp", "desk"], "price": [2.0, 40.0, 150.0]})
df.loc[df["price"] > 30, "price"] = df["price"] * 0.9
print(df)', 1, 2, '2026-09-03T06:40:00.179Z', '2026-09-03T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_1_2', 'busiest-city', 'def busiest_city(orders):
    counts = {}
    for order in orders:
        counts[order["city"]] = counts.get(order["city"], 0) + 1
    return sorted(counts, key=lambda city: (-counts[city], city))[0]', 1, 2, '2026-09-04T06:40:00.179Z', '2026-09-04T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_1_2', 'spend-per-customer', 'def spend_by_customer(orders):
    totals = {}
    for o in orders:
        totals[o["customer"]] = totals.get(o["customer"], 0) + o["amount"]
    return totals', 1, 2, '2026-09-04T06:40:00.179Z', '2026-09-04T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_1_2', 'shared-rows', 'grid = [[0] * 3 for _ in range(3)]    # a new list for each row
grid[0][1] = 9
print(grid)', 1, 2, '2026-09-04T06:40:00.179Z', '2026-09-04T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_1_3', 'clean-prices', 'def clean_prices(values):
    cleaned = []
    for raw in values:
        text = raw.replace("$", "").replace(" ", "").replace(",", ".")
        try:
            cleaned.append(float(text))
        except ValueError:
            continue
    return cleaned', 1, 2, '2026-09-05T06:40:00.179Z', '2026-09-05T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_1_3', 'summarize-values', 'def summarize(values):
    if not values:
        return None
    return {"count": len(values), "mean": sum(values) / len(values), "min": min(values), "max": max(values)}', 1, 2, '2026-09-05T06:40:00.179Z', '2026-09-05T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_1_3', 'mutable-default', 'def add_note(note, notes=None):
    if notes is None:
        notes = []
    notes.append(note)
    return notes

add_note("first call")
print(add_note("second call"))', 1, 2, '2026-09-05T06:40:00.179Z', '2026-09-05T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_2_1', 'tiered-discount', 'import numpy as np

def apply_discount(prices, threshold, rate):
    prices = np.asarray(prices, dtype=float)
    return np.where(prices > threshold, prices * (1 - rate), prices)', 1, 2, '2026-09-06T06:40:00.179Z', '2026-09-06T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_2_1', 'share-above', 'import numpy as np

def share_above(values, threshold):
    values = np.asarray(values, dtype=float)
    return float((values > threshold).mean())', 1, 2, '2026-09-06T06:40:00.179Z', '2026-09-06T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_2_1', 'mask-operator', 'import numpy as np

units = np.array([3, 7, 2, 5])
price = np.array([9.5, 8.0, 9.5, 12.0])
both = (units >= 3) & (price < 10)
print(units[both])', 1, 2, '2026-09-06T06:40:00.179Z', '2026-09-06T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_2_2', 'safe-mean', 'import numpy as np

def safe_mean(values):
    values = np.asarray(values, dtype=float)
    observed = values[~np.isnan(values)]
    if observed.size == 0:
        return np.nan
    return observed.mean()', 1, 2, '2026-09-07T06:40:00.179Z', '2026-09-07T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_2_2', 'fill-median', 'import numpy as np

def fill_with_median(values):
    values = np.asarray(values, dtype=float)
    if np.all(np.isnan(values)):
        return values.copy()
    return np.where(np.isnan(values), np.nanmedian(values), values)', 1, 2, '2026-09-07T06:40:00.179Z', '2026-09-07T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_2_2', 'nan-compare', 'import numpy as np

readings = np.array([21.5, np.nan, 23.0, np.nan])
missing = np.count_nonzero(np.isnan(readings))
print("missing:", missing)', 1, 2, '2026-09-07T06:40:00.179Z', '2026-09-07T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_3_1', 'load-orders', 'import io
import pandas as pd

def load_orders(text):
    return pd.read_csv(io.StringIO(text), parse_dates=["date"])', 1, 2, '2026-09-08T06:40:00.179Z', '2026-09-08T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_3_1', 'column-profile', 'import pandas as pd

def column_profile(df):
    return {"rows": len(df), "columns": list(df.columns), "missing": int(df.isna().sum().sum())}', 1, 2, '2026-09-08T06:40:00.179Z', '2026-09-08T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_3_1', 'header-row', 'import io
import pandas as pd

CSV = "date,city,units\n2026-01-03,Lyon,4\n2026-01-04,Paris,2\n"
df = pd.read_csv(io.StringIO(CSV))
print(df["units"].sum())', 1, 2, '2026-09-08T06:40:00.179Z', '2026-09-08T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_3_2', 'large-orders', 'import pandas as pd

def large_orders(df, min_units):
    big = df[df["units"] >= min_units]
    return big.sort_values("price", ascending=False).reset_index(drop=True)', 1, 2, '2026-09-09T06:40:00.179Z', '2026-09-09T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_3_2', 'city-rows', 'import pandas as pd

def city_rows(df, city):
    rows = df[df["city"] == city]
    return rows[["city", "units"]].reset_index(drop=True)', 1, 2, '2026-09-09T06:40:00.179Z', '2026-09-09T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_3_2', 'double-brackets', 'import io
import pandas as pd

sales = pd.read_csv(io.StringIO("city,units,price\nLyon,4,6.5\nParis,2,9.0\n"))
view = sales[["city", "units"]]
print(view)', 1, 2, '2026-09-09T06:40:00.179Z', '2026-09-09T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_3_3', 'clean-orders', 'import pandas as pd

def clean_orders(df):
    out = df.copy()
    out["city"] = out["city"].str.strip().str.title()
    out["units"] = pd.to_numeric(out["units"], errors="coerce")
    out["price"] = pd.to_numeric(out["price"], errors="coerce")
    out = out.drop_duplicates()
    out = out.dropna(subset=["price"])
    return out.reset_index(drop=True)', 1, 2, '2026-09-10T06:40:00.179Z', '2026-09-10T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_3_3', 'count-unreadable', 'import pandas as pd

def count_unreadable(values):
    cleaned = values.str.strip()
    numbers = pd.to_numeric(cleaned.where(cleaned != "", None), errors="coerce")
    return int(numbers.isna().sum())', 1, 2, '2026-09-10T06:40:00.179Z', '2026-09-10T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_3_3', 'strip-spaces', 'import pandas as pd

cities = pd.Series([" Lyon", "Lyon ", "Lyon", "Paris"])
lyon_count = (cities.str.strip() == "Lyon").sum()
print("Lyon orders:", lyon_count)', 1, 2, '2026-09-10T06:40:00.179Z', '2026-09-10T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_3_4', 'revenue-by-city', 'import pandas as pd

def revenue_by_city(df):
    revenue = df["units"] * df["price"]
    totals = revenue.groupby(df["city"]).sum()
    return totals.sort_values(ascending=False).rename("revenue")', 1, 2, '2026-09-11T06:40:00.179Z', '2026-09-11T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_3_4', 'avg-price-product', 'import pandas as pd

def average_price_by_product(df):
    return df.groupby("product")["price"].mean().sort_index()', 1, 2, '2026-09-11T06:40:00.179Z', '2026-09-11T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_3_4', 'mean-not-sum', 'import io
import pandas as pd

df = pd.read_csv(io.StringIO("city,units\nLyon,4\nLyon,3\nParis,2\n"))
totals = df.groupby("city")["units"].sum()
print(totals)', 1, 2, '2026-09-11T06:40:00.179Z', '2026-09-11T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_3_5', 'attach-regions', 'import pandas as pd

def attach_regions(orders, regions):
    return orders.merge(regions, on="city", how="left", validate="many_to_one")', 1, 2, '2026-09-12T06:40:00.179Z', '2026-09-12T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_3_5', 'orders-per-region', 'import pandas as pd

def orders_per_region(orders, regions):
    joined = orders.merge(regions, on="city", how="left", validate="many_to_one")
    joined["region"] = joined["region"].fillna("Unknown")
    return joined["region"].value_counts()', 1, 2, '2026-09-12T06:40:00.179Z', '2026-09-12T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_3_5', 'duplicate-join', 'import pandas as pd

orders = pd.DataFrame({"city": ["Lyon", "Paris"], "units": [4, 2]})
regions = pd.DataFrame({"city": ["Lyon", "Lyon", "Paris"], "region": ["Auvergne", "Rhone", "Ile-de-France"]})
regions = regions.drop_duplicates(subset="city", keep="first")
joined = orders.merge(regions, on="city", how="left")
print(len(orders), "->", len(joined))', 1, 2, '2026-09-12T06:40:00.179Z', '2026-09-12T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_3_6', 'weekly-totals', 'import pandas as pd

def weekly_totals(df):
    series = df.set_index("date")["revenue"].sort_index()
    return series.resample("W").sum()', 1, 2, '2026-09-13T06:40:00.179Z', '2026-09-13T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_3_6', 'rolling-average', 'import pandas as pd

def rolling_average(df, window):
    ordered = df.sort_values("date").set_index("date")["revenue"]
    return ordered.rolling(window).mean()', 1, 2, '2026-09-13T06:40:00.179Z', '2026-09-13T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_3_6', 'sort-first', 'import pandas as pd

ts = pd.DataFrame({
    "date": pd.to_datetime(["2026-01-03", "2026-01-01", "2026-01-02"]),
    "revenue": [30.0, 10.0, 20.0],
})
ts = ts.sort_values("date")
ts["rolling_2"] = ts["revenue"].rolling(2).mean()
print(ts)', 1, 2, '2026-09-13T06:40:00.179Z', '2026-09-13T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_4_1', 'category-totals', 'def category_totals(categories, amounts):
    totals = {}
    for c, a in zip(categories, amounts):
        totals[c] = totals.get(c, 0) + a
    return totals', 1, 2, '2026-09-15T06:40:00.179Z', '2026-09-15T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_4_1', 'histogram-counts', 'import numpy as np

def histogram_counts(values, bins):
    counts, _ = np.histogram(values, bins=bins)
    return counts.tolist()', 1, 2, '2026-09-15T06:40:00.179Z', '2026-09-15T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_4_1', 'label-axes', 'import matplotlib.pyplot as plt

fig, ax = plt.subplots(figsize=(4, 3))
ax.bar(["Lyon", "Paris"], [4200, 6100])
ax.set_title("Revenue")
ax.set_ylabel("euros")
print(ax.get_ylabel(), ax.get_title())
plt.close(fig)', 1, 2, '2026-09-15T06:40:00.179Z', '2026-09-15T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_4_2', 'plot-summary', 'import pandas as pd

def plot_summary(df):
    totals = df.groupby("city")["revenue"].sum().sort_values(ascending=False)
    share = (totals / totals.sum()).round(3)
    return pd.DataFrame({"revenue": totals, "share": share})', 1, 2, '2026-09-16T06:40:00.179Z', '2026-09-16T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_4_2', 'top-for-chart', 'import pandas as pd

def top_for_chart(series, n):
    return series.sort_values(ascending=False).head(n)', 1, 2, '2026-09-16T06:40:00.179Z', '2026-09-16T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_4_2', 'plot-units', 'import io
import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv(io.StringIO("city,units,price\nLyon,4,6.5\nParis,2,9.0\nLyon,1,6.5\n"))
df["revenue"] = df["units"] * df["price"]
totals = df.groupby("city")["revenue"].sum()
fig, ax = plt.subplots(figsize=(4, 3))
totals.plot(kind="bar", ax=ax)
plt.close(fig)
print(totals)', 1, 2, '2026-09-16T06:40:00.179Z', '2026-09-16T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_4_3', 'honest-limit', 'def bar_baseline(values):
    return 0', 1, 2, '2026-09-17T06:40:00.179Z', '2026-09-17T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_4_3', 'axis-limits', 'import numpy as np

def axis_limits(values, pad):
    values = np.asarray(values, dtype=float)
    low, high = values.min(), values.max()
    span = high - low
    return (low - pad * span, high + pad * span)', 1, 2, '2026-09-17T06:40:00.179Z', '2026-09-17T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_4_3', 'truncated-axis', 'import matplotlib.pyplot as plt

fig, ax = plt.subplots(figsize=(4, 3))
ax.bar(["Standard", "Premium"], [49.0, 51.0])
ax.set_ylim(0, 52)
print("bottom limit:", ax.get_ylim()[0])
plt.close(fig)', 1, 2, '2026-09-17T06:40:00.179Z', '2026-09-17T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_5_1', 'missing-report', 'import pandas as pd

def missing_report(df):
    counts = df.isna().sum()
    counts = counts[counts > 0]
    return counts.sort_values(ascending=False)', 1, 2, '2026-09-18T06:40:00.179Z', '2026-09-18T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_5_1', 'value-profile', 'import pandas as pd

def value_profile(series):
    observed = series.dropna()
    return {"observed": int(observed.count()), "median": float(observed.median()),
            "min": float(observed.min()), "max": float(observed.max())}', 1, 2, '2026-09-18T06:40:00.179Z', '2026-09-18T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_5_1', 'distinct-customers', 'import pandas as pd

orders = pd.DataFrame({"customer": [1, 1, 2, 3, 3, 3], "units": [2, 1, 4, 1, 1, 2]})
customers = orders["customer"].nunique()
print("distinct customers:", customers)', 1, 2, '2026-09-18T06:40:00.179Z', '2026-09-18T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_5_2', 'iqr-outliers', 'import pandas as pd

def iqr_outliers(values):
    q1 = values.quantile(0.25)
    q3 = values.quantile(0.75)
    iqr = q3 - q1
    return (values < q1 - 1.5 * iqr) | (values > q3 + 1.5 * iqr)', 1, 2, '2026-09-19T06:40:00.179Z', '2026-09-19T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_5_2', 'pearson', 'import numpy as np

def pearson(x, y):
    x = np.asarray(x, dtype=float)
    y = np.asarray(y, dtype=float)
    xc = x - x.mean()
    yc = y - y.mean()
    return float((xc * yc).sum() / np.sqrt((xc ** 2).sum() * (yc ** 2).sum()))', 1, 2, '2026-09-19T06:40:00.179Z', '2026-09-19T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_5_2', 'fence-sign', 'import pandas as pd

values = pd.Series([10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 60.0])
q1, q3 = values.quantile(0.25), values.quantile(0.75)
iqr = q3 - q1
upper = q3 + 1.5 * iqr
flags = values > upper
print(flags.tolist())', 1, 2, '2026-09-19T06:40:00.179Z', '2026-09-19T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_5_3', 'clean-sales', 'import pandas as pd

def clean_sales(df):
    out = df.copy()
    out["city"] = out["city"].str.strip().str.title()
    out = out.drop_duplicates()
    out = out.dropna(subset=["unit_price"])
    return out.reset_index(drop=True)', 1, 2, '2026-09-20T06:40:00.179Z', '2026-09-20T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_5_3', 'monthly-revenue', 'import pandas as pd

def monthly_revenue(df):
    revenue = df["units"] * df["unit_price"]
    return revenue.groupby(df["date"]).sum().resample("ME").sum()', 1, 2, '2026-09-20T06:40:00.179Z', '2026-09-20T06:40:00.179Z'),
('usr_student', 'les_python_for_data_science_5_3', 'return-rate', 'import pandas as pd

def return_rate_by_city(df):
    rates = df.groupby("city")["returned"].mean()
    return rates.sort_values(ascending=False)', 1, 2, '2026-09-20T06:40:00.179Z', '2026-09-20T06:40:00.179Z');

INSERT INTO exercise_progress (user_id, lesson_id, cell_id, code, passed, attempts, solved_at, updated_at) VALUES
('usr_student', 'les_python_for_data_science_5_3', 'top-products', 'import pandas as pd

revenue = pd.Series({"Tea": 1200.0, "Coffee": 2600.0, "Cocoa": 900.0}).sort_index()
top = revenue.sort_values(ascending=False).head(2)
print(top)', 1, 2, '2026-09-20T06:40:00.179Z', '2026-09-20T06:40:00.179Z');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_1', 'usr_seed000000', 'crs_python_for_data_science', 5, 'Great instructor, great community', 'Questions in the Q&A got thoughtful answers quickly. The notes feature and lesson resources made it easy to review before my exam.', '2026-08-01T06:40:00.179Z', '2026-08-01T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000000');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_2', 'usr_seed000001', 'crs_python_for_data_science', 5, 'Dense but fantastic', 'This is not a fluffy overview — it goes deep. Expect to pause and re-watch, but the payoff is real. The instructor clearly knows the material at a research level.', '2026-07-30T10:40:00.179Z', '2026-07-30T10:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000001');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_3', 'usr_seed00000b', 'crs_python_for_data_science', 4, 'Finally clicked', 'I''d tried learning this from scattered blog posts and papers. Having a single coherent narrative with good visuals made it click. The capstone tied everything together.', '2026-08-05T06:40:00.179Z', '2026-08-05T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000b');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_4', 'usr_seed00000d', 'crs_python_for_data_science', 5, 'Best course I''ve taken on the topic', 'The explanations build intuition before the math, and every concept is backed by code you actually run. I finally understand what''s happening under the hood instead of copying snippets.', '2026-08-09T06:40:00.179Z', '2026-08-09T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000d');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_5', 'usr_seed00000j', 'crs_python_for_data_science', 5, 'Worth every minute', 'Clear, well-paced and incredibly practical. The projects were challenging in the right way, and I used what I learned at work within a week of finishing.', '2026-08-10T22:40:00.179Z', '2026-08-10T22:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000j');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_6', 'usr_seed00000k', 'crs_python_for_data_science', 5, 'Solid and practical', 'Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I''d take another course from this instructor.', '2026-10-03T06:40:00.179Z', '2026-10-03T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000k');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_7', 'usr_seed00000o', 'crs_python_for_data_science', 5, 'Solid and practical', 'Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I''d take another course from this instructor.', '2026-10-01T06:40:00.179Z', '2026-10-01T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000o');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_8', 'usr_seed00000r', 'crs_python_for_data_science', 5, 'Helped me land an ML role', 'I was a backend engineer trying to move into ML. This course gave me the vocabulary and the hands-on confidence to pass technical interviews. Highly recommended.', '2026-08-06T06:40:00.179Z', '2026-08-06T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000r');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_9', 'usr_seed00000w', 'crs_python_for_data_science', 4, 'Helped me land an ML role', 'I was a backend engineer trying to move into ML. This course gave me the vocabulary and the hands-on confidence to pass technical interviews. Highly recommended.', '2026-09-26T07:40:00.179Z', '2026-09-26T07:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000w');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_10', 'usr_seed00000y', 'crs_python_for_data_science', 2, 'Very good', 'Good content overall, but I wanted more exercises and a slower pace in the later sections. Still learned a lot.', '2026-10-05T06:40:00.179Z', '2026-10-05T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000y');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_11', 'usr_seed000017', 'crs_python_for_data_science', 4, 'Exceptional production quality', 'Beautifully structured. The quizzes caught gaps in my understanding and the AI tutor was surprisingly helpful when I got stuck on the harder sections.', '2026-10-07T06:40:00.179Z', '2026-10-07T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000017');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_12', 'usr_seed00001d', 'crs_python_for_data_science', 5, 'Worth every minute', 'Clear, well-paced and incredibly practical. The projects were challenging in the right way, and I used what I learned at work within a week of finishing.', '2026-10-21T06:40:00.179Z', '2026-10-21T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001d');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_13', 'usr_seed00001h', 'crs_python_for_data_science', 5, 'Finally clicked', 'I''d tried learning this from scattered blog posts and papers. Having a single coherent narrative with good visuals made it click. The capstone tied everything together.', '2026-10-15T06:40:00.179Z', '2026-10-15T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001h');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_14', 'usr_seed00001k', 'crs_python_for_data_science', 4, 'Dense but fantastic', 'This is not a fluffy overview — it goes deep. Expect to pause and re-watch, but the payoff is real. The instructor clearly knows the material at a research level.', '2026-08-24T06:40:00.179Z', '2026-08-24T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001k');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_15', 'usr_seed00001o', 'crs_python_for_data_science', 4, 'Helped me land an ML role', 'I was a backend engineer trying to move into ML. This course gave me the vocabulary and the hands-on confidence to pass technical interviews. Highly recommended.', '2026-07-29T14:40:00.179Z', '2026-07-29T14:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001o');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_16', 'usr_seed00001r', 'crs_python_for_data_science', 4, 'Exceptional production quality', 'Beautifully structured. The quizzes caught gaps in my understanding and the AI tutor was surprisingly helpful when I got stuck on the harder sections.', '2026-07-28T08:40:00.179Z', '2026-07-28T08:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001r');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_17', 'usr_seed00001y', 'crs_python_for_data_science', 5, 'Finally clicked', 'I''d tried learning this from scattered blog posts and papers. Having a single coherent narrative with good visuals made it click. The capstone tied everything together.', '2026-07-25T06:40:00.179Z', '2026-07-25T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001y');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_18', 'usr_seed000024', 'crs_python_for_data_science', 5, 'Great instructor, great community', 'Questions in the Q&A got thoughtful answers quickly. The notes feature and lesson resources made it easy to review before my exam.', '2026-09-03T06:40:00.179Z', '2026-09-03T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000024');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_19', 'usr_seed00002a', 'crs_python_for_data_science', 5, 'Worth every minute', 'Clear, well-paced and incredibly practical. The projects were challenging in the right way, and I used what I learned at work within a week of finishing.', '2026-07-31T06:40:00.179Z', '2026-07-31T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002a');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_20', 'usr_seed00002d', 'crs_python_for_data_science', 5, 'Solid and practical', 'Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I''d take another course from this instructor.', '2026-07-21T06:40:00.179Z', '2026-07-21T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002d');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_21', 'usr_seed00002q', 'crs_python_for_data_science', 5, 'Exceptional production quality', 'Beautifully structured. The quizzes caught gaps in my understanding and the AI tutor was surprisingly helpful when I got stuck on the harder sections.', '2026-07-17T06:40:00.179Z', '2026-07-17T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002q');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_22', 'usr_seed00002r', 'crs_python_for_data_science', 5, 'Clear explanations', 'The visual explanations of difficult concepts are the best I''ve seen. Code is clean and modern. Updated content too, which matters a lot in this field.', '2026-06-27T06:40:00.179Z', '2026-06-27T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002r');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_23', 'usr_seed00002v', 'crs_python_for_data_science', 5, 'Solid and practical', 'Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I''d take another course from this instructor.', '2026-09-25T00:40:00.179Z', '2026-09-25T00:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002v');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_24', 'usr_seed00002w', 'crs_python_for_data_science', 4, 'Clear explanations', 'The visual explanations of difficult concepts are the best I''ve seen. Code is clean and modern. Updated content too, which matters a lot in this field.', '2026-09-03T06:40:00.179Z', '2026-09-03T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002w');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_25', 'usr_seed00002y', 'crs_python_for_data_science', 4, 'Solid and practical', 'Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I''d take another course from this instructor.', '2026-08-28T06:40:00.179Z', '2026-08-28T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002y');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_26', 'usr_seed000036', 'crs_python_for_data_science', 5, 'Clear explanations', 'The visual explanations of difficult concepts are the best I''ve seen. Code is clean and modern. Updated content too, which matters a lot in this field.', '2026-09-06T06:40:00.179Z', '2026-09-06T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000036');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_27', 'usr_seed00003g', 'crs_python_for_data_science', 5, 'Best course I''ve taken on the topic', 'The explanations build intuition before the math, and every concept is backed by code you actually run. I finally understand what''s happening under the hood instead of copying snippets.', '2026-07-11T06:40:00.179Z', '2026-07-11T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00003g');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_28', 'usr_seed00003n', 'crs_python_for_data_science', 5, 'Dense but fantastic', 'This is not a fluffy overview — it goes deep. Expect to pause and re-watch, but the payoff is real. The instructor clearly knows the material at a research level.', '2026-08-14T06:40:00.179Z', '2026-08-14T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00003n');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_29', 'usr_seed00003r', 'crs_python_for_data_science', 4, 'Exceptional production quality', 'Beautifully structured. The quizzes caught gaps in my understanding and the AI tutor was surprisingly helpful when I got stuck on the harder sections.', '2026-06-28T06:40:00.179Z', '2026-06-28T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00003r');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_30', 'usr_seed00003u', 'crs_python_for_data_science', 5, 'Solid and practical', 'Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I''d take another course from this instructor.', '2026-09-29T06:40:00.179Z', '2026-09-29T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00003u');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_31', 'usr_seed00003z', 'crs_python_for_data_science', 5, 'Finally clicked', 'I''d tried learning this from scattered blog posts and papers. Having a single coherent narrative with good visuals made it click. The capstone tied everything together.', '2026-10-23T06:40:00.179Z', '2026-10-23T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00003z');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_32', 'usr_seed000046', 'crs_python_for_data_science', 5, 'Great instructor, great community', 'Questions in the Q&A got thoughtful answers quickly. The notes feature and lesson resources made it easy to review before my exam.', '2026-09-18T06:40:00.179Z', '2026-09-18T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000046');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_33', 'usr_seed000047', 'crs_python_for_data_science', 2, 'Very good', 'Good content overall, but I wanted more exercises and a slower pace in the later sections. Still learned a lot.', '2026-10-22T10:40:00.179Z', '2026-10-22T10:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000047');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_34', 'usr_seed000048', 'crs_python_for_data_science', 5, 'Dense but fantastic', 'This is not a fluffy overview — it goes deep. Expect to pause and re-watch, but the payoff is real. The instructor clearly knows the material at a research level.', '2026-10-09T06:40:00.179Z', '2026-10-09T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000048');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_for_data_science_35', 'usr_seed00004c', 'crs_python_for_data_science', 4, 'Clear explanations', 'The visual explanations of difficult concepts are the best I''ve seen. Code is clean and modern. Updated content too, which matters a lot in this field.', '2026-09-22T06:40:00.179Z', '2026-09-22T06:40:00.179Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00004c');

UPDATE courses SET rating_avg = coalesce((SELECT avg(rating) FROM reviews WHERE course_id = 'crs_python_for_data_science'), 0), rating_count = (SELECT count(*) FROM reviews WHERE course_id = 'crs_python_for_data_science') WHERE id = 'crs_python_for_data_science';
