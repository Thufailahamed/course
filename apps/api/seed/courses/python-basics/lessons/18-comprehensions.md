By now you've written this pattern dozens of times: make an empty list, loop over something, maybe check a condition, append a result. It works, but it takes four lines to say one idea: *"give me the prices with tax added"* or *"give me just the long words."*

Python has a shorthand for exactly this, the **comprehension**. It builds a whole list, dictionary or set in one line that reads almost like English: `[price * 1.2 for price in prices]`. Comprehensions are one of the things people love most about Python, and you'll see them in nearly every professional codebase. By the end of this lesson you'll be able to read them fluently, translate loops into them (and back), and know when a plain loop is the better choice.

## From loop to one line

Here's the familiar loop version. We want each price with 20% tax added:

```python run
prices = [4.50, 12.00, 7.25, 3.10]

with_tax = []
for price in prices:
    with_tax.append(round(price * 1.2, 2))

print(with_tax)
```

And here's the same thing as a **list comprehension**:

```python run
prices = [4.50, 12.00, 7.25, 3.10]

with_tax = [round(price * 1.2, 2) for price in prices]

print(with_tax)
```

Same result, one line. The translation is mechanical: the thing you were appending moves to the **front**, and the `for` line follows it, all inside square brackets.

```text
with_tax = []
for price in prices:                      ──┐
    with_tax.append(round(price * 1.2, 2)) ─┼──┐
                                            │  │
with_tax = [round(price * 1.2, 2)  for price in prices]
            └──── what to keep ──┘ └──── where it comes from ──┘
```

Read it aloud as *"round price times 1.2, **for** each price **in** prices."* The square brackets tell you the result is a new list. The original `prices` list is untouched.

```python predict id=predict-first-comp title="What does the comprehension build?"
print([n * 2 for n in range(4)])
--- options
[2, 4, 6, 8]
* [0, 2, 4, 6]
[0, 2, 4, 6, 8]
[0, 1, 2, 3, 0, 1, 2, 3]
--- explain
`range(4)` gives 0, 1, 2, 3 (the stop value is excluded), and each one is doubled: `[0, 2, 4, 6]`. The result always has exactly one item per item in the source, because there's no filter. (`[0, 1, 2, 3, 0, 1, 2, 3]` is what `list(range(4)) * 2` would give.)
```

```python exercise id=to-fahrenheit title="Convert the forecast to Fahrenheit"
celsius = [18.5, 22.0, 25.3, 19.8, 30.1]

# TODO: use a list comprehension to build `fahrenheit`:
# each temperature converted with  c * 9 / 5 + 32,  rounded to 1 decimal.
fahrenheit = ...

print(fahrenheit)
--- solution
celsius = [18.5, 22.0, 25.3, 19.8, 30.1]

fahrenheit = [round(c * 9 / 5 + 32, 1) for c in celsius]

print(fahrenheit)
--- test
assert fahrenheit is not ..., "Replace the `...` after `fahrenheit =` with a list comprehension."
assert isinstance(fahrenheit, list), f"`fahrenheit` should be a list, but it is a {type(fahrenheit).__name__}. Use square brackets."
assert len(fahrenheit) == len(celsius), f"`fahrenheit` should have one value per Celsius reading ({len(celsius)}), but has {len(fahrenheit)}."
_expected = [round(c * 9 / 5 + 32, 1) for c in celsius]
assert all(abs(f - e) < 0.051 for f, e in zip(fahrenheit, _expected)), f"`fahrenheit` should be {_expected}, but it is {fahrenheit}. Check the formula: c * 9 / 5 + 32."
assert fahrenheit == _expected, f"Close! Round each value to 1 decimal: {_expected}."
--- hint
The shape is `[<expression using c> for c in celsius]`.
--- hint
The expression is the formula wrapped in `round(..., 1)`.
```

## Filtering with `if`

Add an `if` at the **end** of a comprehension, and only items that pass the test are kept. It's the loop-with-an-`if` pattern, compressed:

```python run
transactions = [12.50, 230.00, 8.99, 75.00, 1200.00, 45.10]

big = [t for t in transactions if t >= 100]
print("big:", big)

words = "the quick brown fox jumps over the lazy dog".split()
long_words = [w.upper() for w in words if len(w) > 4]
print("long words:", long_words)
```

The order matches the loop you'd write: `for` first, then the `if` nested inside it. The expression at the front is only computed for items that pass, so you can transform and filter in one go.

```python exercise id=clean-signups title="Tidy up the sign-up sheet"
raw_names = ["  maya ", "LEO", "", "ines carvalho", "   ", "sam  "]

# TODO: build `names` with a list comprehension:
#  - skip entries that are empty or only spaces
#  - strip the spaces and put each remaining name in Title Case
# Expected: ["Maya", "Leo", "Ines Carvalho", "Sam"]
names = ...

print(names)
--- solution
raw_names = ["  maya ", "LEO", "", "ines carvalho", "   ", "sam  "]

names = [n.strip().title() for n in raw_names if n.strip()]

print(names)
--- test
assert names is not ..., "Replace the `...` after `names =` with a list comprehension."
assert isinstance(names, list), f"`names` should be a list, but it is a {type(names).__name__}."
_expected = [n.strip().title() for n in raw_names if n.strip() != ""]
assert "" not in names, "There's still an empty name in the list. Filter out entries that are blank after stripping."
assert len(names) == len(_expected), f"`names` should have {len(_expected)} names, but has {len(names)}: {names}. Entries that are only spaces count as blank."
assert names == _expected, f"`names` should be {_expected}, but it is {names}. Strip AND title-case each name."
--- hint
Two jobs: the expression at the front cleans each name, and an `if` at the end decides which ones to keep.
--- hint
`n.strip()` is `""` for a blank entry, and an empty string is falsy, so `if n.strip()` keeps only the real names.
```

## Choosing a value with `if ... else`

Sometimes you don't want to drop items; you want to **choose** what each one becomes. That's the conditional expression from lesson 9, `a if condition else b`, and it goes at the **front**, as the value:

```python run
scores = [72, 45, 88, 50, 39]

results = ["pass" if s >= 50 else "fail" for s in scores]
print(results)
```

Every score produces exactly one label, so the result has the same length as `scores`. This is the source of the most common comprehension mix-up, so here it is side by side:

| Where the `if` goes | What it does | Result length |
|---|---|---|
| `[x for x in items if cond]` (end) | **filters**: drops items that fail | same or shorter |
| `[a if cond else b for x in items]` (front) | **chooses** a value for every item | always the same |

An `if` at the end can't have an `else`, and an `if` at the front must have one. Mix them up and Python refuses before running anything:

```python run error
temps = [21, -999, 23, 22]
fixed = [t if t > -100 for t in temps]
```

`SyntaxError` means Python couldn't even read the line. An `if` before the `for` is a conditional expression, and it needs its `else`.

```python predict id=predict-filter-vs-choose title="Filter or choose?"
nums = [3, -1, 4, -5]
print([n for n in nums if n > 0], [n if n > 0 else 0 for n in nums])
--- options
[3, 4] [3, 4]
[3, 0, 4, 0] [3, 0, 4, 0]
* [3, 4] [3, 0, 4, 0]
[3, 0, 4, 0] [3, 4]
--- explain
The first comprehension has its `if` at the end, so it **filters**: the negatives are dropped, leaving `[3, 4]`. The second has `if ... else` at the front, so it **chooses** a value for every item: negatives become 0 and the list keeps all four positions.
```

```python debug id=sensor-gaps title="Bad readings vanish instead of becoming 0"
# Hourly readings from a sensor. -1 means the sensor glitched that hour.
readings = [14, 15, -1, 17, -1, 19, 18]

# Replace each glitch with 0, but keep one value per hour
# so that cleaned[i] still lines up with hour i.
cleaned = [r for r in readings if r != -1]

print("hours:", len(readings), "cleaned values:", len(cleaned))
print(cleaned)
--- solution
readings = [14, 15, -1, 17, -1, 19, 18]

cleaned = [r if r != -1 else 0 for r in readings]

print("hours:", len(readings), "cleaned values:", len(cleaned))
print(cleaned)
--- test
assert isinstance(cleaned, list), "`cleaned` should be a list."
assert len(cleaned) == len(readings), f"`cleaned` has {len(cleaned)} values but there are {len(readings)} hours. The glitches were dropped instead of replaced."
assert -1 not in cleaned, "`cleaned` still contains -1. Replace each glitch with 0."
_expected = [0 if r == -1 else r for r in readings]
assert cleaned == _expected, f"`cleaned` should be {_expected}, but it is {cleaned}."
--- hint
Run it: 7 hours went in, but only 5 values came out. Is the `if` filtering or choosing?
--- hint
To keep every item and pick a value for each one, move the condition to the front as `value_if_true if condition else value_if_false`.
```

## Dictionary and set comprehensions

The same idea works with curly braces. Write `key: value` at the front and you get a **dictionary**; write a single value and you get a **set**.

```python run
menu = {"espresso": 2.50, "latte": 3.80, "mocha": 4.20}

happy_hour = {drink: round(price * 0.8, 2) for drink, price in menu.items()}
print("happy hour:", happy_hour)

names = ["Ana", "Benedict", "Lu"]
name_lengths = {name: len(name) for name in names}
print("lengths:", name_lengths)
```

Looping over `.items()` and unpacking each pair, exactly like in a `for` loop, is the most common way to transform one dictionary into another. Filters work too:

```python run
emails = ["maya@gmail.com", "leo@work.org", "ines@gmail.com", "sam@school.edu", "jo@work.org"]

domains = {e.split("@")[1] for e in emails}                 # set: no duplicates
gmail_users = {e.split("@")[0] for e in emails if e.endswith("@gmail.com")}

print("domains:", sorted(domains))
print("gmail users:", sorted(gmail_users))
```

| Brackets | Front part | You get |
|---|---|---|
| `[ ... ]` | `value` | a list |
| `{ ... }` | `key: value` | a dict |
| `{ ... }` | `value` | a set |

```python predict id=predict-set-comp title="How many are left?"
greetings = ["Hi", "hi", "HI", "Hey", "hey"]
print(len({g.lower() for g in greetings}))
--- options
5
3
* 2
1
--- explain
Curly braces with a single value at the front build a **set**, and a set keeps each value once. After `.lower()` the words are `hi, hi, hi, hey, hey`, which collapse to just `{"hi", "hey"}`: 2 items.
```

```python exercise id=stock-report title="Build the stock report"
stock = {"apples": 40, "pears": 3, "kiwis": 0, "plums": 12, "figs": 4}
prices = {"apples": 0.50, "pears": 0.75, "kiwis": 0.40, "plums": 0.60, "figs": 1.20}

# TODO 1: `low_stock` is a SET of the items with fewer than 5 left
low_stock = ...

# TODO 2: `stock_value` is a DICT mapping each item to quantity * price,
#         rounded to 2 decimals, e.g. stock_value["apples"] == 20.0
stock_value = ...

print("reorder:", low_stock)
print("value:", stock_value)
--- solution
stock = {"apples": 40, "pears": 3, "kiwis": 0, "plums": 12, "figs": 4}
prices = {"apples": 0.50, "pears": 0.75, "kiwis": 0.40, "plums": 0.60, "figs": 1.20}

low_stock = {item for item, qty in stock.items() if qty < 5}

stock_value = {item: round(qty * prices[item], 2) for item, qty in stock.items()}

print("reorder:", low_stock)
print("value:", stock_value)
--- test
assert low_stock is not ..., "Replace the `...` after `low_stock =` with a set comprehension."
assert isinstance(low_stock, set), f"`low_stock` should be a set, but it is a {type(low_stock).__name__}. Use curly braces with a single value at the front."
_low = {i for i, q in stock.items() if q < 5}
assert low_stock == _low, f"`low_stock` should be {sorted(_low)}, but it is {sorted(low_stock)}."
assert stock_value is not ..., "Replace the `...` after `stock_value =` with a dictionary comprehension."
assert isinstance(stock_value, dict), f"`stock_value` should be a dict, but it is a {type(stock_value).__name__}. Use `key: value` at the front."
_val = {i: round(q * prices[i], 2) for i, q in stock.items()}
assert set(stock_value) == set(_val), f"`stock_value` should have a key for every item: {sorted(_val)}."
_off = [i for i in _val if abs(stock_value[i] - _val[i]) > 0.005]
assert not _off, f"Wrong value for {', '.join(_off)}. Each should be quantity * price, e.g. {_off[0]} is {_val[_off[0]]}."
--- hint
Both loop over `stock.items()`, unpacking `item, qty`. The set needs an `if` at the end; the dict needs no filter.
--- hint
The dictionary's front part is `item: round(qty * prices[item], 2)`.
```

## Nested comprehensions: flattening

A comprehension can have more than one `for`. The rule that makes them readable: **write the `for` clauses in the same order as the nested loops.** The classic use is flattening a list of lists into one list:

```python run
weekly_steps = [
    [8200, 9100, 7600],      # week 1
    [10400, 6900, 8800],     # week 2
]

all_days = [steps for week in weekly_steps for steps in week]
print(all_days)
print("total:", sum(all_days))
```

```text
for week in weekly_steps:          [steps  for week in weekly_steps  for steps in week]
    for steps in week:                      └──── outer loop ──────┘ └─ inner loop ─┘
        all_days.append(steps)      (the value still goes first)
```

```python exercise id=seat-labels title="Label every seat in the cinema"
rows = "ABC"
seats_per_row = 4

# TODO: use ONE list comprehension with two `for` clauses to build `seats`:
# ["A1", "A2", "A3", "A4", "B1", ..., "C4"]  (row by row)
seats = ...

print("seats:", seats)
--- solution
rows = "ABC"
seats_per_row = 4

seats = [f"{row}{n}" for row in rows for n in range(1, seats_per_row + 1)]

print("seats:", seats)
--- test
assert seats is not ..., "Replace the `...` after `seats =` with a list comprehension."
assert isinstance(seats, list), f"`seats` should be a list, but it is a {type(seats).__name__}."
_expected = [r + str(n) for r in rows for n in range(1, seats_per_row + 1)]
assert len(seats) == len(_expected), f"There should be {len(_expected)} seats ({len(rows)} rows x {seats_per_row}), but `seats` has {len(seats)}. Check the range of seat numbers."
assert all(isinstance(s, str) for s in seats), "Each seat label should be a string like \"A1\"."
assert sorted(seats) == sorted(_expected), f"Some labels are wrong. Expected labels like {_expected[:3]}, got {seats[:3]}. Seat numbers start at 1."
assert seats == _expected, f"The labels are right but the order isn't. Go row by row: {_expected[:5]}... Which `for` should come first?"
--- hint
Think of the nested loops first: for each row, for each number from 1 to 4. Then write the `for` clauses in that same order.
--- hint
`range(1, seats_per_row + 1)` gives 1 to 4, and `f"{row}{n}"` glues a row letter to a number.
```

## When not to use a comprehension

Comprehensions are for **building a collection**. They're at their best when they're short enough to read in one breath. Two warning signs that a plain loop would be better:

```python
# 1. Too much going on: a conditional value, unpacking AND a two-part filter.
labels = [f"{n}: {s:.1f}" if s >= 50 else f"{n}: retake" for n, s in results if n and s is not None]

# 2. Used only for its side effect: builds a useless list of None values.
[print(name) for name in guests]
```

For the second one, just write the loop. `print()` isn't building anything:

```python
for name in guests:
    print(name)
```

> **Tip:** a good rule of thumb: if a comprehension doesn't fit comfortably on one line, or you need to explain it with a comment, write the loop instead. Readable code beats clever code, every time.

## A teaser: generator expressions

Drop the square brackets inside a function call, and you get a **generator expression**. It produces values one at a time for the function to consume, without ever building the full list in memory:

```python run
cart = {"apples": 6, "milk": 2, "eggs": 1}
prices = {"apples": 0.5, "milk": 1.2, "eggs": 3.0}

total = sum(prices[item] * qty for item, qty in cart.items())
print("total:", total)

words = ["comprehension", "set", "dictionary", "list"]
print("longest word length:", max(len(w) for w in words))
```

That one-line `sum(...)` replaces a whole accumulator loop. You'll learn how generators work under the hood in **Python Advanced**; for now, enjoy the shortcut for `sum`, `max` and `min`.

> **In the wild:** in data work you'll constantly see lines like `{row["id"]: row for row in rows}` (index records by ID) or `[r for r in records if r["status"] == "active"]`. pandas and Django code is full of them.

## Debug challenge: the same name over and over

```python debug id=badge-names title="Every badge has the same name"
guests = ["maya", "leo", "ines"]

for name in guests:
    print("Checking in", name)

# Make a name badge for every guest: ["Maya", "Leo", "Ines"]
badges = [name.title() for guest in guests]

print(badges)
--- solution
guests = ["maya", "leo", "ines"]

for name in guests:
    print("Checking in", name)

badges = [guest.title() for guest in guests]

print(badges)
--- test
assert isinstance(badges, list), "`badges` should be a list."
assert len(badges) == len(guests), f"There should be one badge per guest ({len(guests)}), but there are {len(badges)}."
_expected = [g.title() for g in guests]
assert len(set(badges)) == len(badges), f"The badges are {badges}: the same name repeated. Is the front of the comprehension using the loop variable?"
assert badges == _expected, f"`badges` should be {_expected}, but it is {badges}."
--- hint
Run it and look at what `name` holds after the `for` loop above finishes. Which name does the comprehension keep using?
--- hint
The comprehension's own loop variable is `guest`, but the front part uses `name`, a leftover from the earlier loop.
```

## Recap

- A list comprehension `[expr for x in items]` builds a new list: the value goes first, then the `for`.
- An `if` at the **end** filters items out; `a if cond else b` at the **front** chooses a value for every item.
- Curly braces give a **dict** (`{k: v for ...}`) or a **set** (`{v for ...}`); loop over `.items()` to transform dictionaries.
- Multiple `for` clauses run in the same order as nested loops, which is how you flatten lists of lists.
- `sum(x for x in ...)` is a generator expression: no brackets, no temporary list.
- If it doesn't fit comfortably on one line, or it's only for side effects like `print`, write a normal loop.

**Up next:** functions, where you'll learn to package code into reusable, named pieces with `def`, parameters and return values.
