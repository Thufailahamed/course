A `while` loop repeats *until* something happens. But a huge amount of real programming is a different kind of repetition: do something **for each** thing. For each letter in a password, check it. For each day of the month, add up the sales. For each song in a playlist, print its title. For each row of seats, label every seat.

That's what the `for` loop is for, and it's the loop you'll write most often in Python. In this lesson you'll walk through strings letter by letter, count with `range()` (forwards, backwards and in steps), build up totals and new strings with **accumulators**, and nest one loop inside another to make grids and tables. You'll also meet the two bugs everyone hits with `for` loops: the range that stops one short, and the total that keeps getting reset.

```python setup
# Hidden checker helper: lets the tests re-run your challenge code with other starting values.
import contextlib as _contextlib, io as _io, linecache as _linecache, re as _re, sys as _sys

def _rerun(**values):
    src = "".join(_linecache.cache["<cell>"][2])
    settings = ", ".join(f"{k} = {v!r}" for k, v in values.items())
    for name, value in values.items():
        src, found = _re.subn(rf"(?m)^{name}\s*=(?!=).*$", f"{name} = {value!r}", src, count=1)
        assert found, f"Keep the line `{name} = ...` in your code so the checker can try other values."
    ns = {k: v for k, v in globals().items() if k in _SETUP_NAMES}
    out, steps = _io.StringIO(), [0]
    def guard(frame, event, arg):
        if frame.f_code.co_filename != "<cell>":
            return None
        steps[0] += 1
        if steps[0] > 200_000:
            raise AssertionError(f"With {settings}, your loop never stopped.")
        return guard
    try:
        with _contextlib.redirect_stdout(out):
            _sys.settrace(guard)
            try:
                exec(compile(src, "<cell>", "exec"), ns)
            finally:
                _sys.settrace(None)
    except AssertionError:
        raise
    except Exception as e:
        raise AssertionError(f"With {settings}, your code crashed with {type(e).__name__}: {e}")
    ns["_out"] = out.getvalue()
    return ns

_SETUP_NAMES = set(globals()) | {"_SETUP_NAMES"}
```

## For each letter in a string

A string is a sequence of characters, and a `for` loop can walk through it one character at a time:

```python run
for letter in "PYTHON":
    print("Give me a", letter + "!")

print("What does that spell?")
```

Read the first line as *"for each `letter` in `"PYTHON"`…"*. Python takes the first character, `"P"`, puts it in the variable `letter`, and runs the indented block. Then it takes `"Y"`, puts it in `letter`, runs the block again, and so on until the string runs out. You choose the variable name; `letter`, `ch` and `char` are all common.

```text
"PYTHON"   P    Y    T    H    O    N
           │    │    │    │    │    │
letter =   P →  Y →  T →  H →  O →  N  → (no more) → loop ends
```

Compare it with the `while` version you'd write after lesson 10. Same result, but you have to manage an index yourself:

```python run
word = "PYTHON"
i = 0
while i < len(word):
    print(word[i], end=" ")
    i += 1
print()

for letter in word:
    print(letter, end=" ")
print()
```

The `for` loop has no start, no condition and no update for you to get wrong. Python handles all three: it starts at the beginning, stops at the end, and moves forward by itself. That's why a `for` loop can't accidentally run forever over a string.

> **Under the hood:** Anything a `for` loop can walk through is called an **iterable**. Strings are iterables, and so are `range()`, lists, dictionaries, files and many more you'll meet later. One kind of loop works for all of them.

## For each item in a short list

You can also loop over a few values written in square brackets. That's a **list**, which you'll learn properly in lesson 13. For now, just use it as "these values, one at a time":

```python run
for song in ["Intro", "Golden Hour", "Midnight Drive", "Outro"]:
    print("Now playing:", song)
```

The pattern is identical: each value in turn is stored in `song` and the block runs once per value.

```python exercise id=vowel-free title="Text-speak: drop the vowels"
message = "see you tomorrow"

# TODO: build `short` by looping over `message` and keeping
# every character EXCEPT the vowels a, e, i, o, u (in either case).
# Spaces and other characters stay. "see you tomorrow" -> "s y tmrrw"
short = ""

print(short)
--- solution
message = "see you tomorrow"

short = ""
for ch in message:
    if ch.lower() not in "aeiou":
        short += ch

print(short)
--- test
assert isinstance(short, str), f"`short` should be a string, but it is {short!r}."
assert short != "", "`short` is still empty. Loop over `message` and add each non-vowel character to `short`."
assert short == "s y tmrrw", f"`short` should be \"s y tmrrw\", but it is {short!r}."
for text in ["Python is fun", "AEIOU and sometimes Y", "rhythm", "Ice Cream On Ice"]:
    want = "".join(c for c in text if c.lower() not in "aeiou")
    got = _rerun(message=text).get("short")
    assert got == want, f"With message = {text!r}, `short` should be {want!r} but is {got!r}. Are capital vowels removed too?"
--- hint
Start with an empty string, then inside the loop use `+=` to glue on the characters you want to keep.
--- hint
`ch.lower() not in "aeiou"` is `True` for any character that is not a vowel, whatever its case.
```

## `range()`: counting made easy

To repeat something a set number of times, or to loop over numbers, use `range()`. It produces a sequence of whole numbers on demand:

```python run
for i in range(5):
    print("Push-up number", i)
```

`range(5)` gives **0, 1, 2, 3, 4**: five numbers, starting at 0, stopping *before* 5. That "stop before" rule is the same one you met with string slicing (`text[0:5]` stops before index 5), and it's the single most important thing to remember about `range`.

`range` has three forms:

| Call | Numbers produced | Read it as |
|---|---|---|
| `range(5)` | 0 1 2 3 4 | five numbers, from 0 |
| `range(1, 6)` | 1 2 3 4 5 | from 1, up to but **not including** 6 |
| `range(0, 20, 5)` | 0 5 10 15 | from 0, in steps of 5, stopping before 20 |
| `range(10, 0, -1)` | 10 9 8 … 1 | from 10, counting **down**, stopping before 0 |
| `range(3, 3)` | *(nothing)* | start ≥ stop: the loop body never runs |

When you want "1 to 10 inclusive", write `range(1, 11)`. The stop value is one past the last number you want.

```python run
for floor in range(1, 6):
    print("Floor", floor, end="  ")
print()

for countdown in range(10, 0, -1):
    print(countdown, end=" ")
print("Happy New Year!")
```

```python predict id=predict-range-step title="Stepping through a range"
for i in range(2, 10, 3):
    print(i, end=" ")
--- options
2 5 8 11
* 2 5 8
3 6 9
2 3 4 5 6 7 8 9
--- explain
Start at 2, then add 3 each time: 2, 5, 8. The next would be 11, which is not below the stop value 10, so the range ends at 8. (The trailing space printed by `end=" "` doesn't show in the output.)
```

`range` only works with whole numbers. A very common way to trip over that is dividing with `/`, which always gives a float (lesson 4):

```python run error
pages = 10
for page in range(pages / 2):
    print("Printing page", page)
```

`TypeError: 'float' object cannot be interpreted as an integer`. `10 / 2` is `5.0`, a float, and `range` refuses it. Use floor division, `range(pages // 2)`, or convert with `int(...)`.

## Accumulators: building up a result

Most loops don't just print; they **build something up**: a running total, a product, a new string. The pattern is always the same:

1. Create the accumulator **before** the loop, with a starting value.
2. Update it **inside** the loop, once per item.
3. Use the result **after** the loop.

```python run
total = 0                         # 1. start empty
for day in range(1, 8):
    total += day * 1000           # 2. add this day's distance
    print(f"Day {day}: running total {total:,} m")

print(f"Week total: {total / 1000} km")   # 3. use the result
```

The starting value depends on the job:

| Building a… | Start with | Update with |
|---|---|---|
| sum | `0` | `total += x` |
| product | `1` (multiplying by 0 would wipe it out) | `product *= x` |
| string | `""` | `text += piece` |

Building a string works the same way. Here the new letter goes on the *front* each time, which reverses the word:

```python run
word = "stressed"
backwards = ""
for letter in word:
    backwards = letter + backwards
print(backwards)
```

> **Tip:** Lost in a loop? Press **Debug** and step through it. Watching an accumulator change in the Variables table, one iteration at a time, makes almost every loop bug obvious.

```python exercise id=bookshelf-orders title="Arranging the bookshelf"
books = 5

# How many different orders can you arrange `books` books on a shelf?
# It's 1 x 2 x 3 x ... x books (for 5 books: 1 x 2 x 3 x 4 x 5 = 120).
# TODO: give `arrangements` a sensible starting value, then use a
# for loop over range(...) to multiply it by every number from 1 to books.
arrangements = ...

print(books, "books can be arranged in", arrangements, "ways")
--- solution
books = 5

arrangements = 1
for n in range(1, books + 1):
    arrangements *= n

print(books, "books can be arranged in", arrangements, "ways")
--- test
assert arrangements is not ..., "Replace `arrangements = ...` with a starting value, then add a for loop."
assert isinstance(arrangements, int), f"`arrangements` should be a whole number, but it is {arrangements!r}."
assert arrangements != 0, "`arrangements` is 0. Anything multiplied by 0 stays 0. What should a product start at?"
assert arrangements != 24, "`arrangements` is 24, which is 1 x 2 x 3 x 4. Your range stops one number too early."
assert arrangements == 120, f"5 books can be arranged in 120 ways, but `arrangements` is {arrangements}."
for b in [1, 3, 7, 10]:
    want = 1
    for k in range(2, b + 1):
        want *= k
    got = _rerun(books=b).get("arrangements")
    assert got == want, f"With books = {b}, `arrangements` should be {want} but is {got!r}."
--- hint
A product accumulator starts at 1, because multiplying by 1 changes nothing.
--- hint
You need the numbers 1 up to *and including* `books`. Remember that `range` stops before its stop value.
--- hint
`for n in range(1, books + 1):` then `arrangements *= n` inside the loop.
```

```python debug id=pushup-challenge title="The 30-day challenge only counts 29 days"
# Day 1: 10 push-ups. Every day after that: 2 more than the day before.
# How many push-ups in total over the whole challenge?
days = 30
total = 0

for day in range(1, days):
    pushups = 10 + 2 * (day - 1)
    total += pushups

print("Total push-ups:", total)
--- solution
# Day 1: 10 push-ups. Every day after that: 2 more than the day before.
# How many push-ups in total over the whole challenge?
days = 30
total = 0

for day in range(1, days + 1):
    pushups = 10 + 2 * (day - 1)
    total += pushups

print("Total push-ups:", total)
--- test
assert total != 1102, "The total is still 1102, which leaves out the final day. Which day numbers does your range produce?"
assert total == 1170, f"Over 30 days the total should be 1170 push-ups, but `total` is {total}."
assert day == days, f"The last day the loop ran was day {day}, but the challenge lasts {days} days."
for d in [1, 7, 14]:
    want = sum(10 + 2 * (k - 1) for k in range(1, d + 1))
    got = _rerun(days=d).get("total")
    assert got == want, f"With days = {d}, `total` should be {want} but is {got!r}."
--- hint
Press **Debug** and step to the end. What is the value of `day` on the last pass?
--- hint
`range(1, days)` stops *before* `days`. How do you make it include the last day?
```

## `for` or `while`?

Both loops repeat, so how do you choose? Ask: *do I know what I'm looping over?*

| Situation | Loop |
|---|---|
| each character of a string, each item of a collection | `for` |
| a known number of times (10 rounds, days 1–30) | `for` with `range` |
| until something happens (goal reached, user types "quit", guess is right) | `while` |
| you can't know the number of repetitions in advance | `while` |

When either would work, prefer `for`. It's shorter, and since Python manages the counting, it can't turn into an infinite loop.

## The loop variable after the loop

The loop variable is an ordinary variable. When the loop ends, it keeps the **last value** it was given:

```python predict id=predict-loop-var-after title="What's left in the loop variable?"
for i in range(3):
    print("tick", end=" ")
print(i)
--- options
3
* tick tick tick 2
tick tick tick 3
tick tick tick
--- explain
`range(3)` produces 0, 1 and 2, so after printing three ticks the loop ends with `i` still holding its last value, `2`. It never becomes 3, because 3 is never produced by the range.
```

> **Pitfall:** If the loop runs zero times (say `range(0)` or an empty string), the loop variable is never created. Using it after the loop then raises a `NameError`. Don't rely on the loop variable after the loop unless you're sure the loop ran.

## Accumulator bugs: start before, update inside

Where you put the starting line matters just as much as the update. This program is supposed to add up a week of step counts:

```python debug id=weekly-steps-reset title="The weekly total only counts Sunday"
# Steps walked each day, Monday to Sunday
daily_steps = [8200, 10450, 6300, 12000, 9100, 7600, 11250]

for steps in daily_steps:
    total = 0
    total += steps

print("Total steps this week:", total)
--- solution
# Steps walked each day, Monday to Sunday
daily_steps = [8200, 10450, 6300, 12000, 9100, 7600, 11250]

total = 0
for steps in daily_steps:
    total += steps

print("Total steps this week:", total)
--- test
assert total != 11250, "The total is 11250, which is only Sunday's steps. Each pass throws the earlier days away. Which line does that?"
assert total == 64900, f"The week's total should be 64900, but `total` is {total}."
for week in [[1000, 2000, 3000], [5000], [100, 200, 300, 400, 500, 600, 700]]:
    got = _rerun(daily_steps=week).get("total")
    assert got == sum(week), f"With daily_steps = {week}, `total` should be {sum(week)} but is {got!r}."
--- hint
Press **Debug** and watch `total` as the loop runs. What happens to it at the start of every pass?
--- hint
`total = 0` is inside the loop, so it resets the total on every pass. The starting value should be set once, before the loop begins.
```

## Nested loops: loops inside loops

A loop's body can contain another loop. For **each** pass of the outer loop, the inner loop runs **all the way through**. That's exactly what you need for anything shaped like a grid: rows and seats, days and hours, a times table.

```python run
for row in "ABC":
    for seat in range(1, 5):
        print(f"{row}{seat}", end=" ")
    print()          # after each row, start a new line
```

The inner loop prints one row of seats on a single line (`end=" "` keeps them together). The plain `print()` is indented under the *outer* loop, so it runs once per row and moves to the next line. Getting that indentation right is the whole trick of nested loops.

Patterns work the same way: the inner loop's range can even depend on the outer loop variable.

```python run
for row in range(1, 5):
    for star in range(row):
        print("*", end="")
    print()
```

```python predict id=predict-nested-count title="How many times does the inner line run?"
count = 0
for i in range(3):
    for j in range(4):
        count += 1
print(count)
--- options
7
* 12
3
4
--- explain
The outer loop runs 3 times, and *each time* the inner loop runs 4 times, so the inner line runs 3 × 4 = 12 times. Nested loops multiply; that's why they can get slow on big inputs.
```

```python exercise id=times-table title="Print a times table"
size = 4

# TODO: use two nested for loops to print a size x size times table,
# one row per line, with the numbers separated by spaces.
# For size = 4 the output is:
#   1 2 3 4
#   2 4 6 8
#   3 6 9 12
#   4 8 12 16
# (Lining the columns up with an f-string like f"{n:4}" is a nice extra.)
--- solution
size = 4

for row in range(1, size + 1):
    for col in range(1, size + 1):
        print(f"{row * col:4}", end="")
    print()
--- test
def _table(text):
    return [line.split() for line in text.splitlines() if line.strip()]

def _expected(n):
    return [[str(r * c) for c in range(1, n + 1)] for r in range(1, n + 1)]

got = _table(_stdout)
assert got, "Nothing was printed yet. Use two nested `for` loops with `range` to print the table."
assert len(got) == size, f"The table should have {size} rows (one per line), but {len(got)} lines were printed. Is your plain `print()` indented under the outer loop?"
assert got == _expected(size), f"The rows should be {[' '.join(r) for r in _expected(size)]}, but they were {[' '.join(r) for r in got]}."
for n in [3, 6]:
    rows = _table(_rerun(size=n)["_out"])
    assert rows == _expected(n), f"With size = {n}, the table isn't right. The first row printed was {' '.join(rows[0]) if rows else 'nothing'}."
--- hint
The outer loop picks the row number (1 to `size`), and the inner loop goes through the column numbers (1 to `size`). Each cell is `row * col`.
--- hint
Inside the inner loop, print one product with `end=" "` so it stays on the same line. After the inner loop finishes (but still inside the outer loop), call `print()` to start a new line.
```

> **In the wild:** `for` loops over `range` and over collections are the bread and butter of everyday scripts: renaming every file in a folder, sending a reminder to each person on a list, processing every row of a spreadsheet. Data libraries like pandas run their fastest loops in compiled code behind the scenes, but the mental model is the same one you just practised: for each item, do something.

## Recap

- `for item in iterable:` runs the block once **for each** item, storing it in the loop variable. Strings give you one character at a time.
- `range(stop)`, `range(start, stop)` and `range(start, stop, step)` produce whole numbers; the **stop value is never included**. Count down with a negative step.
- Accumulators start **before** the loop (`0` for sums, `1` for products, `""` for strings) and update **inside** it.
- Use `for` when you know what you're looping over; use `while` when you're waiting for something to happen.
- Nested loops run the inner loop completely for every pass of the outer loop, which is perfect for grids and tables.

**Up next:** loop patterns: counting matches, finding the biggest value, searching, and stepping out early with `break` and `continue`.
