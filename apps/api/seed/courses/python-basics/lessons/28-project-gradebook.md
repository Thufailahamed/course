Every term, teachers everywhere export a spreadsheet of scores and then spend an evening with a calculator: averages, letter grades, who's at the top, who needs help, how the class did overall. It's slow and it's easy to get wrong. It's also exactly the kind of chore a short Python program does in a blink, and gets right every time.

In this project you'll build that program, a **gradebook analyzer**, from a raw CSV file all the way to a formatted report and a saved JSON summary. Nothing here is new. It's files, functions, loops, dictionaries, f-strings and `try`/`except` from the last 27 lessons, working together for the first time. That's the real skill this lesson teaches: taking a big job and breaking it into small functions you can write and test one at a time.

> **How this project works:** each step is a challenge that adds one piece of the program. Challenges run on their own, so each one includes the finished helpers it needs from earlier steps. At the end, you'll run the whole analyzer from top to bottom.

```python setup
# The gradebook files this project works with (hidden setup: runs before every cell and challenge).
with open("grades.csv", "w", encoding="utf-8") as f:
    f.write(
        "student,homework,midterm,final\n"
        "Ava,92,88,95\nBen,75,68,72\nChloe,85,91,89\nDiego,58,62,49\n"
        "Emma,99,94,97\nFarid,81,77,84\nGrace,62,65,66\nHiro,88,79,91\n"
    )
with open("grades_messy.csv", "w", encoding="utf-8") as f:
    f.write(
        "student,homework,midterm,final\n"
        "Ava,92,88,95\nBen,75,68,72\nChloe,85,91,89\nDiego,58,62,49\n"
        "Emma,99,94,97\nFarid,81,77,84\nGrace,62,65,66\nHiro,88,79,91\n"
        "Isla,90,,85\nJonas,78,absent,80\nKemal, 84 , 90 ,87\n"
    )
```

## The plan

Before writing any code, professionals sketch the program as a pipeline of small steps. Each step takes something in and hands something out:

```text
grades.csv ──► load_records ──► average ──► letter_grade ──► class_stats ──► report + summary.json
  (text)       (name, scores)    (number)     ("A".."F")      (mean, top,     (what a human
                                                               bottom)         reads)
```

Every box becomes one function. Small functions are easy to test on their own, and once each one works, the whole program is just a few lines that call them in order.

## Step 1: read the CSV

This page has its own little filesystem, and the setup has already written a file called `grades.csv` into it. Have a look at the raw text:

```python run
with open("grades.csv", encoding="utf-8") as f:
    print(f.read())
```

One header line, then one student per line, with a homework, midterm and final score. You learned in lesson 24 that `csv.DictReader` turns each line into a dictionary keyed by the header:

```python run
import csv

with open("grades.csv", newline="", encoding="utf-8") as f:
    rows = list(csv.DictReader(f))

print(len(rows), "rows")
rows[0]
```

Look closely at that dictionary. Something is about to bite anyone who tries to do math with it.

```python predict id=predict-csv-strings title="Adding two scores"
import csv

with open("grades.csv", newline="", encoding="utf-8") as f:
    rows = list(csv.DictReader(f))

print(rows[0]["homework"] + rows[0]["midterm"])
--- options
180
* 9288
92 88
TypeError
--- explain
A CSV file is just text, so **every value `DictReader` gives you is a string**: `'92'` and `'88'`, not `92` and `88`. `+` on two strings glues them together, giving `9288`. Convert with `float()` (or `int()`) before doing any math.
```

Converting one row is a short list comprehension over the score columns:

```python run
SCORE_COLUMNS = ["homework", "midterm", "final"]

row = rows[0]
scores = [float(row[col]) for col in SCORE_COLUMNS]
print(row["student"], scores)
```

Why `float` and not `int`? Teachers love half points. `int("88.5")` raises a `ValueError`, while `float("88.5")` is happy, and `float("92")` works too.

```python exercise id=load-records title="Load the gradebook into records"
import csv

SCORE_COLUMNS = ["homework", "midterm", "final"]

def load_records(path):
    """Read a gradebook CSV and return a list of (name, scores) tuples.

    scores is a list of floats, one per column in SCORE_COLUMNS.
    """
    records = []
    with open(path, newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            # TODO: get the student's name from the "student" column
            name = ...
            # TODO: build a list of floats from this row's SCORE_COLUMNS
            scores = ...
            records.append((name, scores))
    return records

records = load_records("grades.csv")
print(len(records), "students")
print(records[0])
--- solution
import csv

SCORE_COLUMNS = ["homework", "midterm", "final"]

def load_records(path):
    """Read a gradebook CSV and return a list of (name, scores) tuples.

    scores is a list of floats, one per column in SCORE_COLUMNS.
    """
    records = []
    with open(path, newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            name = row["student"]
            scores = [float(row[col]) for col in SCORE_COLUMNS]
            records.append((name, scores))
    return records

records = load_records("grades.csv")
print(len(records), "students")
print(records[0])
--- test
recs = load_records("grades.csv")
assert isinstance(recs, list), f"`load_records` should return a list, but returned {type(recs).__name__}."
assert len(recs) == 8, f"grades.csv has 8 students, but you returned {len(recs)} records."
first = recs[0]
assert isinstance(first, tuple) and len(first) == 2, f"Each record should be a (name, scores) tuple, but the first one is {first!r}."
name, scores = first
assert name is not ..., "Replace the `...` after `name =` with the value from the \"student\" column."
assert scores is not ..., "Replace the `...` after `scores =` with a list of the row's scores."
assert name == "Ava", f"The first record's name should be 'Ava', but it's {name!r}. Use row[\"student\"]."
assert isinstance(scores, list), f"`scores` should be a list, but it's a {type(scores).__name__}."
assert all(isinstance(s, (int, float)) for s in scores), f"Scores should be numbers, but got {scores!r}. CSV values are text: convert each one with float()."
assert scores == [92, 88, 95], f"Ava's scores should be [92.0, 88.0, 95.0], but got {scores!r}."
with open("check_grades.csv", "w", encoding="utf-8") as f:
    f.write("student,homework,midterm,final\nKim,88.5,90,79\nLeo,70,65,72\n")
try:
    fresh = load_records("check_grades.csv")
except ValueError:
    raise AssertionError("Your function crashed on a half-point score like '88.5'. Convert with float(), not int().")
assert fresh == [("Kim", [88.5, 90.0, 79.0]), ("Leo", [70.0, 65.0, 72.0])], f"On a different file, load_records returned {fresh!r}. Make sure you read from `path` and convert every score column."
--- hint
Each `row` is a dictionary like `{"student": "Ava", "homework": "92", ...}`. The name is one lookup away.
--- hint
For the scores, loop over `SCORE_COLUMNS` and convert each `row[col]` with `float()`. A list comprehension does it in one line.
```

## Step 2: one student's average

An average is the sum divided by the count. The one trap is an empty list: a student with no scores yet would crash the whole report.

```python run error
scores = []
sum(scores) / len(scores)
```

`ZeroDivisionError` on line 2, because `len([])` is 0. Your `average` function should check for that first and return `0.0` instead. Also, don't round inside `average`. Rounding is a *display* decision, and rounding too early makes later math (like the class mean) drift.

```python run
scores = [92.0, 88.0, 95.0]
avg = sum(scores) / len(scores)
print("full precision:", avg)
print(f"for humans:      {avg:.1f}")
```

```python exercise id=average-score title="Write the average function"
def average(scores):
    """Return the mean of a list of scores, or 0.0 if the list is empty."""
    # TODO: return 0.0 for an empty list, otherwise the mean (don't round it)
    ...

print(average([92.0, 88.0, 95.0]))   # about 91.67
print(average([]))                   # 0.0
--- solution
def average(scores):
    """Return the mean of a list of scores, or 0.0 if the list is empty."""
    if not scores:
        return 0.0
    return sum(scores) / len(scores)

print(average([92.0, 88.0, 95.0]))   # about 91.67
print(average([]))                   # 0.0
--- test
r = average([90, 80, 70])
assert r is not None, "`average` returned None. Replace the `...` with code that `return`s the mean (returning, not printing)."
assert r is not ..., "Replace the `...` with your code."
assert isinstance(r, (int, float)), f"`average` should return a number, but returned {r!r}."
assert r == 80, f"average([90, 80, 70]) should be 80, but got {r!r}."
assert abs(average([88.5, 91.5]) - 90) < 1e-9, f"average([88.5, 91.5]) should be 90, but got {average([88.5, 91.5])!r}."
third = average([1, 2, 2])
assert abs(third - 5 / 3) < 1e-9, f"average([1, 2, 2]) should be 1.6666..., but got {third!r}. Don't round inside `average`; round only when you display."
try:
    empty = average([])
except ZeroDivisionError:
    raise AssertionError("average([]) crashed with ZeroDivisionError. Check for an empty list before dividing.")
assert empty == 0.0, f"average([]) should return 0.0, but returned {empty!r}."
--- hint
An empty list is falsy, so `if not scores:` is a neat way to spot it.
--- hint
Return `0.0` early for the empty case; otherwise return `sum(scores) / len(scores)`.
```

## Step 3: letter grades

The school's scale is a ladder: **A** for 90 and up, **B** for 80 and up, **C** for 70, **D** for 60, and **F** below that. An `if`/`elif` chain is the natural fit, and as you saw in lesson 9, **Python takes the first branch whose condition is true and skips the rest.** So the order of the rungs matters.

A teammate wrote this version. Run it and see what grades the class gets.

```python debug id=grade-ladder title="Everyone passes with a D"
def letter_grade(avg):
    """Return the letter grade: A 90+, B 80+, C 70+, D 60+, otherwise F."""
    if avg >= 60:
        return "D"
    elif avg >= 70:
        return "C"
    elif avg >= 80:
        return "B"
    elif avg > 90:
        return "A"
    else:
        return "F"

for name, avg in [("Emma", 96.7), ("Chloe", 88.3), ("Ben", 71.7), ("Grace", 64.3), ("Diego", 56.3)]:
    print(name, letter_grade(avg))
--- solution
def letter_grade(avg):
    """Return the letter grade: A 90+, B 80+, C 70+, D 60+, otherwise F."""
    if avg >= 90:
        return "A"
    elif avg >= 80:
        return "B"
    elif avg >= 70:
        return "C"
    elif avg >= 60:
        return "D"
    else:
        return "F"

for name, avg in [("Emma", 96.7), ("Chloe", 88.3), ("Ben", 71.7), ("Grace", 64.3), ("Diego", 56.3)]:
    print(name, letter_grade(avg))
--- test
assert letter_grade(96.7) == "A", f"letter_grade(96.7) returns {letter_grade(96.7)!r}, not 'A'. Python stops at the FIRST true condition. Which one is checked first?"
assert letter_grade(88.3) == "B", f"letter_grade(88.3) should be 'B', got {letter_grade(88.3)!r}."
assert letter_grade(90) == "A", f"An average of exactly 90 should be an A, but got {letter_grade(90)!r}. Look at the comparison operator on the A line."
cases = {100: "A", 89.99: "B", 80: "B", 79.9: "C", 70: "C", 69.5: "D", 60: "D", 59.99: "F", 0: "F"}
wrong = [f"{a} -> {letter_grade(a)!r} (expected {g!r})" for a, g in cases.items() if letter_grade(a) != g]
assert not wrong, "Some boundaries are off: " + "; ".join(wrong)
--- hint
Run it: 96.7 gets a D. An average of 96.7 is also `>= 60`, so the very first branch wins. Which rung should be tested first?
--- hint
Put the highest cutoff at the top and work downward. Then check the A line once more: should exactly 90 count?
```

> **Tip:** When a chain of `elif`s checks ranges with `>=`, always go **from the highest cutoff down** (or, with `<`, from the lowest up). Then each branch only has to say where its range *starts*.

## Step 4: class statistics

With every student's average in a dictionary, the class-wide numbers come from tools you already know. The mean is the sum of the values over their count. For the top student, `max` with a `key` (lesson 22) compares the *averages* but hands back the *name*:

```python run
averages = {"Ava": 91.67, "Ben": 71.67, "Chloe": 88.33, "Diego": 56.33}

print("max of the dict:      ", max(averages))
print("max of the values:    ", max(averages.values()))
print("name with highest avg:", max(averages, key=lambda name: averages[name]))
```

Plain `max(averages)` loops over the **keys**, so it returns the alphabetically last name. The `key` version is the one you want: it ranks each name by its average.

```python exercise id=class-stats title="Summarize the whole class"
def class_stats(averages):
    """Summarize a dict of {name: average}.

    Return a dict with three keys:
      "mean":    the mean of all the averages
      "highest": the NAME of the student with the highest average
      "lowest":  the NAME of the student with the lowest average
    """
    # TODO: fill in the three values
    mean = ...
    highest = ...
    lowest = ...
    return {"mean": mean, "highest": highest, "lowest": lowest}

averages = {"Ava": 91.67, "Ben": 71.67, "Chloe": 88.33, "Diego": 56.33, "Emma": 96.67}
print(class_stats(averages))
--- solution
def class_stats(averages):
    """Summarize a dict of {name: average}.

    Return a dict with three keys:
      "mean":    the mean of all the averages
      "highest": the NAME of the student with the highest average
      "lowest":  the NAME of the student with the lowest average
    """
    mean = sum(averages.values()) / len(averages)
    highest = max(averages, key=lambda name: averages[name])
    lowest = min(averages, key=lambda name: averages[name])
    return {"mean": mean, "highest": highest, "lowest": lowest}

averages = {"Ava": 91.67, "Ben": 71.67, "Chloe": 88.33, "Diego": 56.33, "Emma": 96.67}
print(class_stats(averages))
--- test
fresh = {"Rosa": 77.0, "Sam": 93.5, "Tao": 61.25, "Uma": 85.0}
s = class_stats(fresh)
assert isinstance(s, dict), f"`class_stats` should return a dict, but returned {type(s).__name__}."
for key in ["mean", "highest", "lowest"]:
    assert s.get(key) is not ..., f"Replace the `...` for `{key}` with your code."
assert isinstance(s["mean"], (int, float)), f"\"mean\" should be a number, but it's {s['mean']!r}."
assert abs(s["mean"] - 79.1875) < 1e-9, f"For {fresh} the mean should be 79.1875, but got {s['mean']!r}. Sum the VALUES and divide by how many there are."
assert not isinstance(s["highest"], (int, float)), f"\"highest\" should be a student's name, not a number ({s['highest']!r}). Use max() with a key."
assert s["highest"] == "Sam", f"For {fresh} the highest should be 'Sam', but got {s['highest']!r}. Rank names by their average, not alphabetically."
assert s["lowest"] == "Tao", f"For {fresh} the lowest should be 'Tao', but got {s['lowest']!r}."
assert fresh == {"Rosa": 77.0, "Sam": 93.5, "Tao": 61.25, "Uma": 85.0}, "`class_stats` shouldn't change the dictionary it's given."
--- hint
`averages.values()` gives you just the numbers; `sum(...)` and `len(...)` do the rest for the mean.
--- hint
`max(averages, key=lambda name: averages[name])` returns the name whose average is largest. `min` works the same way.
```

## Step 5: the grade distribution

A good report also shows how many students landed on each letter. That's the counting pattern from lesson 16: start a dictionary of zeros, then add 1 for each student. Starting with all five letters at zero means letters nobody got still show up in the report.

There's a classic bug hiding in this version. Run it and look at the total.

```python debug id=grade-counts title="The distribution only counts one student"
def grade_distribution(grades):
    """Count students per letter. grades is a dict of {name: letter}.

    Return a dict with all five letters A, B, C, D, F as keys.
    """
    for letter in grades.values():
        counts = {"A": 0, "B": 0, "C": 0, "D": 0, "F": 0}
        counts[letter] += 1
    return counts

grades = {"Ava": "A", "Ben": "C", "Chloe": "B", "Diego": "F",
          "Emma": "A", "Farid": "B", "Grace": "D", "Hiro": "B"}
dist = grade_distribution(grades)
print(dist)
print("students counted:", sum(dist.values()))
--- solution
def grade_distribution(grades):
    """Count students per letter. grades is a dict of {name: letter}.

    Return a dict with all five letters A, B, C, D, F as keys.
    """
    counts = {"A": 0, "B": 0, "C": 0, "D": 0, "F": 0}
    for letter in grades.values():
        counts[letter] += 1
    return counts

grades = {"Ava": "A", "Ben": "C", "Chloe": "B", "Diego": "F",
          "Emma": "A", "Farid": "B", "Grace": "D", "Hiro": "B"}
dist = grade_distribution(grades)
print(dist)
print("students counted:", sum(dist.values()))
--- test
d = grade_distribution(grades)
assert sum(d.values()) == 8, f"8 students went in, but the counts add up to {sum(d.values())}. Is something being reset on every pass of the loop?"
assert d == {"A": 2, "B": 3, "C": 1, "D": 1, "F": 1}, f"Expected {{'A': 2, 'B': 3, 'C': 1, 'D': 1, 'F': 1}}, but got {d}."
d2 = grade_distribution({"x": "C", "y": "C", "z": "A"})
assert d2 == {"A": 1, "B": 0, "C": 2, "D": 0, "F": 0}, f"On another class, expected {{'A': 1, 'B': 0, 'C': 2, 'D': 0, 'F': 0}} but got {d2}."
try:
    d3 = grade_distribution({})
except NameError:
    raise AssertionError("grade_distribution({}) crashed: with no students the loop never runs, so `counts` never exists. Create it before the loop.")
assert d3 == {"A": 0, "B": 0, "C": 0, "D": 0, "F": 0}, f"With no students every count should be 0, but got {d3}."
--- hint
Click **Debug** and watch `counts` as the loop runs. What happens to it at the start of every pass?
--- hint
An accumulator must be created **once, before** the loop. Move the line that builds the zero dictionary up one level.
```

## Step 6: a report people can read

Numbers in a dictionary are for programs. People want a neat table. f-string format specs (lesson 6) line columns up: `:<8` pads to 8 characters on the left, `:>6.1f` right-aligns a number in 6 characters with one decimal.

```python predict id=predict-alignment title="Lining up a row"
name = "Ben"
avg = 71.666
print(f"[{name:<6}{avg:>7.1f}]")
--- options
[Ben 71.7]
[Ben   71.666]
* [Ben      71.7]
[   Ben71.7   ]
--- explain
`{name:<6}` pads `Ben` with 3 spaces on the right to make 6 characters. `{avg:>7.1f}` rounds to `71.7` (4 characters) and pads it with 3 spaces on the left to make 7. Together that's `Ben` followed by 6 spaces, then `71.7`. The brackets just make the spaces visible.
```

Sorting puts the strongest students on top. `sorted` with a `key` and `reverse=True` orders the names by their average, highest first:

```python run
averages = {"Ava": 91.667, "Ben": 71.667, "Chloe": 88.333, "Diego": 56.333}

for name in sorted(averages, key=lambda n: averages[n], reverse=True):
    print(f"{name:<8}{averages[name]:>6.1f}")
```

```python exercise id=report-lines title="Format the report lines"
def letter_grade(avg):  # from Step 3
    if avg >= 90:
        return "A"
    elif avg >= 80:
        return "B"
    elif avg >= 70:
        return "C"
    elif avg >= 60:
        return "D"
    else:
        return "F"

def format_report(averages):
    """Return a list of report lines, highest average first.

    Each line: the name left-aligned in 8 characters, the average
    right-aligned in 6 characters with 1 decimal, two spaces, the letter.
    Example: 'Emma      96.7  A'
    """
    lines = []
    # TODO: loop over the names sorted by average (highest first)
    # and append one formatted line per student to `lines`
    ...
    return lines

averages = {"Ava": 91.667, "Ben": 71.667, "Chloe": 88.333, "Diego": 56.333, "Emma": 96.667}
for line in format_report(averages):
    print(line)
--- solution
def letter_grade(avg):  # from Step 3
    if avg >= 90:
        return "A"
    elif avg >= 80:
        return "B"
    elif avg >= 70:
        return "C"
    elif avg >= 60:
        return "D"
    else:
        return "F"

def format_report(averages):
    """Return a list of report lines, highest average first.

    Each line: the name left-aligned in 8 characters, the average
    right-aligned in 6 characters with 1 decimal, two spaces, the letter.
    Example: 'Emma      96.7  A'
    """
    lines = []
    for name in sorted(averages, key=lambda n: averages[n], reverse=True):
        avg = averages[name]
        lines.append(f"{name:<8}{avg:>6.1f}  {letter_grade(avg)}")
    return lines

averages = {"Ava": 91.667, "Ben": 71.667, "Chloe": 88.333, "Diego": 56.333, "Emma": 96.667}
for line in format_report(averages):
    print(line)
--- test
fresh = {"Rosa": 77.0, "Sam": 93.5, "Tao": 61.25, "Uma": 85.0}
got = format_report(fresh)
assert isinstance(got, list), f"`format_report` should return a list of strings, but returned {type(got).__name__}."
assert got, "`format_report` returned an empty list. Append one line per student to `lines`."
assert len(got) == 4, f"There are 4 students, so there should be 4 lines, but you returned {len(got)}."
assert all(isinstance(line, str) for line in got), "Every item in the list should be a string (an f-string line)."
order = [line.split()[0] if line.split() else "" for line in got]
assert order == ["Sam", "Uma", "Rosa", "Tao"], f"Lines should go from highest average to lowest (Sam, Uma, Rosa, Tao), but the order is {order}."
expected = [f"{n:<8}{fresh[n]:>6.1f}  {letter_grade(fresh[n])}" for n in ["Sam", "Uma", "Rosa", "Tao"]]
for g, e in zip(got, expected):
    assert g.rstrip() == e, f"A line should look like {e!r}, but yours is {g!r}. Check the widths (:<8 and :>6.1f) and the two spaces before the letter."
--- hint
`sorted(averages, key=lambda n: averages[n], reverse=True)` gives the names, best first.
--- hint
Inside the loop, build each line with an f-string like `f"{name:<8}{avg:>6.1f}  {letter_grade(avg)}"` and append it.
```

## Step 7: real data is messy

The file you've used so far is perfect. Real exports are not: a student missed the midterm (empty cell), someone typed `absent` into a score column, a spreadsheet added stray spaces. Here's the messy version of the gradebook:

```python run
with open("grades_messy.csv", encoding="utf-8") as f:
    for line in f.readlines()[-4:]:
        print(repr(line))
```

Isla's midterm is empty, and Jonas has the word `absent`. Watch what `float` does with those:

```python run error
print(float(" 84 "))     # stray spaces are fine
print(float(""))         # an empty cell is not
```

`float` quietly ignores surrounding spaces, so Kemal's row is fine. But an empty string or a word raises `ValueError`, and without protection one bad row would crash the whole report for everyone. The fix is the `try`/`except` pattern from lesson 23: **try** to convert the row, and if it fails, set the row aside and keep going.

> **Pitfall:** Catch `ValueError` specifically, not everything with a bare `except:`. A bare `except` would also hide your own typos, like a misspelled column name (`KeyError`), and you'd silently skip every row without knowing why.

```python exercise id=messy-rows title="Skip the bad rows instead of crashing"
import csv

SCORE_COLUMNS = ["homework", "midterm", "final"]

def load_records(path):
    """Read a gradebook CSV. Return a tuple (records, skipped):

    records: list of (name, scores) tuples for rows with valid scores
    skipped: list of names whose row had a missing or invalid score
    """
    records = []
    skipped = []
    with open(path, newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            name = row["student"]
            # TODO: protect the conversion with try/except ValueError.
            # Good rows go into `records`; for bad rows, add the name to `skipped`.
            scores = [float(row[col]) for col in SCORE_COLUMNS]
            records.append((name, scores))
    return records, skipped

# Works on the clean file. When you're done, try "grades_messy.csv" too.
records, skipped = load_records("grades.csv")
print(len(records), "loaded; skipped:", skipped)
--- solution
import csv

SCORE_COLUMNS = ["homework", "midterm", "final"]

def load_records(path):
    """Read a gradebook CSV. Return a tuple (records, skipped):

    records: list of (name, scores) tuples for rows with valid scores
    skipped: list of names whose row had a missing or invalid score
    """
    records = []
    skipped = []
    with open(path, newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            name = row["student"]
            try:
                scores = [float(row[col]) for col in SCORE_COLUMNS]
            except ValueError:
                skipped.append(name)
                continue
            records.append((name, scores))
    return records, skipped

records, skipped = load_records("grades_messy.csv")
print(len(records), "loaded; skipped:", skipped)
--- test
try:
    out = load_records("grades_messy.csv")
except ValueError as e:
    raise AssertionError(f"load_records crashed on grades_messy.csv with ValueError: {e}. Wrap the conversion in try/except ValueError.")
assert isinstance(out, tuple) and len(out) == 2, "`load_records` should return a tuple: (records, skipped)."
recs, skip = out
assert skip == ["Isla", "Jonas"], f"`skipped` should be ['Isla', 'Jonas'], but it's {skip!r}."
names = [r[0] for r in recs]
assert "Isla" not in names and "Jonas" not in names, f"Skipped students must not also appear in `records`, but records has {names}."
assert len(recs) == 9, f"9 rows are valid (including Kemal, whose spaces are fine), but `records` has {len(recs)}: {names}."
assert ("Kemal", [84.0, 90.0, 87.0]) in recs, "Kemal's row has stray spaces but valid numbers, so it should be kept as ('Kemal', [84.0, 90.0, 87.0])."
with open("check_messy.csv", "w", encoding="utf-8") as f:
    f.write("student,homework,midterm,final\nZed,abc,1,2\nYan,50,60,70\nXia,80,,90\n")
recs2, skip2 = load_records("check_messy.csv")
assert recs2 == [("Yan", [50.0, 60.0, 70.0])] and skip2 == ["Zed", "Xia"], f"On another file expected ([('Yan', [50.0, 60.0, 70.0])], ['Zed', 'Xia']) but got ({recs2!r}, {skip2!r})."
--- hint
Put the `scores = [...]` line inside a `try:` block. In `except ValueError:`, append `name` to `skipped`.
--- hint
After recording a skipped name, `continue` jumps to the next row so the bad one is never appended. (An `else:` block on the `try` that does the append works too.)
```

## Step 8: put it all together and save a summary

Reports are for people; a **JSON summary** is for other programs, like a dashboard, an email script, or next term's analyzer. `json.dump` writes a dictionary to a file, and `indent=2` keeps it readable:

```python run
import json

demo = {"class_mean": 79.5, "highest": "Emma", "skipped": ["Isla"]}
print(json.dumps(demo, indent=2))
```

Now the final step: one function, `analyze`, that runs the whole pipeline on a file and saves the result. The helpers from the earlier steps are included in finished form; `load_records` and `letter_grade` are written a little more compactly, but they do exactly what yours do.

```python exercise id=analyze-gradebook title="Analyze a gradebook end to end"
import csv, json

SCORE_COLUMNS = ["homework", "midterm", "final"]

def load_records(path):  # Steps 1 and 7
    records, skipped = [], []
    with open(path, newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            try:
                records.append((row["student"], [float(row[c]) for c in SCORE_COLUMNS]))
            except ValueError:
                skipped.append(row["student"])
    return records, skipped

def average(scores):  # Step 2
    return sum(scores) / len(scores) if scores else 0.0

def letter_grade(avg):  # Step 3, as a loop over (cutoff, letter) pairs
    for cutoff, letter in [(90, "A"), (80, "B"), (70, "C"), (60, "D")]:
        if avg >= cutoff:
            return letter
    return "F"

def analyze(path, out_path):
    """Analyze a gradebook CSV, save a JSON summary to out_path, and return the summary."""
    records, skipped = load_records(path)
    averages = {name: average(scores) for name, scores in records}
    # TODO 1: build `summary`, a dict with these keys:
    #   "students":   {name: {"average": avg rounded to 1 decimal, "grade": letter}}
    #   "class_mean": the mean of all the averages, rounded to 1 decimal
    #   "highest", "lowest": the names of the top and bottom students
    #   "skipped":    the list of skipped names
    summary = ...
    # TODO 2: save `summary` to out_path as JSON with indent=2
    ...
    return summary

print(analyze("grades_messy.csv", "summary.json"))
--- solution
import csv, json

SCORE_COLUMNS = ["homework", "midterm", "final"]

def load_records(path):  # Steps 1 and 7
    records, skipped = [], []
    with open(path, newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            try:
                records.append((row["student"], [float(row[c]) for c in SCORE_COLUMNS]))
            except ValueError:
                skipped.append(row["student"])
    return records, skipped

def average(scores):  # Step 2
    return sum(scores) / len(scores) if scores else 0.0

def letter_grade(avg):  # Step 3, as a loop over (cutoff, letter) pairs
    for cutoff, letter in [(90, "A"), (80, "B"), (70, "C"), (60, "D")]:
        if avg >= cutoff:
            return letter
    return "F"

def analyze(path, out_path):
    """Analyze a gradebook CSV, save a JSON summary to out_path, and return the summary."""
    records, skipped = load_records(path)
    averages = {name: average(scores) for name, scores in records}
    summary = {
        "students": {n: {"average": round(a, 1), "grade": letter_grade(a)} for n, a in averages.items()},
        "class_mean": round(average(list(averages.values())), 1),
        "highest": max(averages, key=lambda n: averages[n]),
        "lowest": min(averages, key=lambda n: averages[n]),
        "skipped": skipped,
    }
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(summary, f, indent=2)
    return summary

print(analyze("grades_messy.csv", "summary.json"))
--- test
import os
for p in ["check_summary.json", "check_two.json"]:
    if os.path.exists(p):
        os.remove(p)
res = analyze("grades_messy.csv", "check_summary.json")
assert res is not ..., "Replace `summary = ...` with the summary dictionary (TODO 1)."
assert isinstance(res, dict), f"`analyze` should return a dict, but returned {type(res).__name__}."
missing = [k for k in ["students", "class_mean", "highest", "lowest", "skipped"] if k not in res]
assert not missing, f"The summary is missing these keys: {missing}."
students = res["students"]
assert isinstance(students, dict) and len(students) == 9, f"\"students\" should be a dict with the 9 valid students, but it's {students!r}."
assert students.get("Emma") == {"average": 96.7, "grade": "A"}, f"Emma's entry should be {{'average': 96.7, 'grade': 'A'}}, but it's {students.get('Emma')!r}. Round each average to 1 decimal."
assert students.get("Grace") == {"average": 64.3, "grade": "D"}, f"Grace's entry should be {{'average': 64.3, 'grade': 'D'}}, but it's {students.get('Grace')!r}."
raw = [sum(s) / 3 for _, s in load_records("grades_messy.csv")[0]]
assert res["class_mean"] == round(sum(raw) / len(raw), 1), f"\"class_mean\" should be {round(sum(raw) / len(raw), 1)}, but it's {res['class_mean']!r}."
assert res["highest"] == "Emma" and res["lowest"] == "Diego", f"Highest/lowest should be 'Emma'/'Diego', but got {res['highest']!r}/{res['lowest']!r}."
assert res["skipped"] == ["Isla", "Jonas"], f"\"skipped\" should be ['Isla', 'Jonas'], but it's {res['skipped']!r}."
assert os.path.exists("check_summary.json"), "`analyze` didn't create a file at `out_path` (TODO 2). Open it in 'w' mode and use json.dump."
with open("check_summary.json", encoding="utf-8") as f:
    text = f.read()
assert json.loads(text) == json.loads(json.dumps(res)), "The JSON file should contain exactly the summary you return."
assert "\n  " in text, "The JSON file is all on one line. Pass indent=2 to json.dump."
with open("check_two.csv", "w", encoding="utf-8") as f:
    f.write("student,homework,midterm,final\nNia,100,90,80\nOli,50,,70\nPia,60,70,65\n")
res2 = analyze("check_two.csv", "check_two.json")
assert res2["students"] == {"Nia": {"average": 90.0, "grade": "A"}, "Pia": {"average": 65.0, "grade": "D"}}, f"On another file, \"students\" came out as {res2['students']!r}."
assert (res2["class_mean"], res2["highest"], res2["lowest"], res2["skipped"]) == (77.5, "Nia", "Pia", ["Oli"]), "On another file, the class mean, highest, lowest or skipped list is off. Compute them from `averages` and `skipped`, not from fixed values."
--- hint
Build the "students" part with a dict comprehension over `averages.items()`: each value is `{"average": round(avg, 1), "grade": letter_grade(avg)}`.
--- hint
The class mean is the average of `averages.values()` (your `average` function needs a list, so wrap them in `list(...)`). Top and bottom use `max`/`min` with a `key`, just like Step 4.
--- hint
For TODO 2: `with open(out_path, "w", encoding="utf-8") as f:` then `json.dump(summary, f, indent=2)`.
```

## The finished analyzer

Here is the whole program in one place, run from top to bottom on the messy file. The first cell holds the building blocks you wrote; the second is the "main" part that uses them to print a report a teacher could actually hand out.

```python run
import csv, json

SCORE_COLUMNS = ["homework", "midterm", "final"]

def load_records(path):
    records, skipped = [], []
    with open(path, newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            try:
                records.append((row["student"], [float(row[c]) for c in SCORE_COLUMNS]))
            except ValueError:
                skipped.append(row["student"])
    return records, skipped

def average(scores):
    return sum(scores) / len(scores) if scores else 0.0

def letter_grade(avg):
    for cutoff, letter in [(90, "A"), (80, "B"), (70, "C"), (60, "D")]:
        if avg >= cutoff:
            return letter
    return "F"

print("building blocks ready")
```

```python run
records, skipped = load_records("grades_messy.csv")
averages = {name: average(scores) for name, scores in records}
counts = {"A": 0, "B": 0, "C": 0, "D": 0, "F": 0}

print(f"{'STUDENT':<8}{'AVG':>6}  GRADE")
print("-" * 21)
for name in sorted(averages, key=lambda n: averages[n], reverse=True):
    grade = letter_grade(averages[name])
    counts[grade] += 1
    print(f"{name:<8}{averages[name]:>6.1f}  {grade}")

print("-" * 21)
print(f"class mean: {average(list(averages.values())):.1f}")
for letter, n in counts.items():
    print(f"  {letter} | {'#' * n} {n}")
print("skipped (fix these rows):", ", ".join(skipped))
```

Change a score in the setup data in your head: if Diego's final were 89 instead of 49, which line of this report would change? Programs like this make "what if" questions cheap, which is half of why people automate things.

> **In the wild:** this exact pipeline (load, clean, compute per-row values, aggregate, report, export) is the daily bread of data analysis. In the pandas library, Steps 1 to 5 shrink to a few lines like `pd.read_csv(...)`, `df.mean(axis=1)` and `value_counts()`, but under the hood it's doing what you just built by hand, and knowing that makes pandas far less mysterious.

## Recap

- Big programs are built from **small functions**, each with one job, each tested on its own before you connect them.
- Everything read from a CSV is **text**: convert with `float()` (or `int()`) before doing math.
- `if`/`elif` ladders on ranges go **from the highest cutoff down**, because the first true branch wins.
- Accumulators (like a counts dictionary) are created **once, before** the loop.
- `try`/`except ValueError` lets one bad row be **skipped and reported** instead of crashing the whole program.
- f-string alignment (`:<8`, `:>6.1f`) makes readable reports; `json.dump(..., indent=2)` makes machine-readable ones.

**Up next:** a word-guessing game, where you'll use random choice, string scoring and a game loop to build your own version of Wordle.
