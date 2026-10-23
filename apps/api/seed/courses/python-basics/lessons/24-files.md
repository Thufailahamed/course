Every program you've written so far has had amnesia. The moment it finishes, every list, dictionary and high score vanishes. **Files** are how programs remember: a to-do app saves your tasks, a game saves your progress, a script at work reads last month's sales and writes a report for your boss.

In this lesson you'll read and write plain text files, then the two formats most real-world data arrives in: **CSV** (spreadsheet-style rows) and **JSON** (nested dictionaries and lists, the language of web APIs). By the end you'll be able to load a spreadsheet export, total it up, and save the results somewhere safe.

> **About this page's files:** this page has its own small, sandboxed filesystem that lives in your browser's memory. Your code can create, read and overwrite files freely here without touching anything on your computer. Files last until you reload the page.

## Writing your first file

A file is just text (or bytes) stored under a name. To use one, you `open()` it, which gives you a *file object* to read from or write to. The second argument is the **mode**: `"w"` means "write":

```python run
with open("shopping.txt", "w", encoding="utf-8") as f:
    f.write("milk\n")
    f.write("eggs\n")
    f.write("coffee\n")

print("Saved!")
```

Three things are happening:

- `open("shopping.txt", "w", ...)` creates the file (or empties it if it already exists) and hands you a file object, which we've named `f`.
- `f.write(...)` adds text. It does **not** add a line break for you; that's what the `\n` is for.
- `with ... as f:` closes the file automatically when the indented block ends, even if an error happens inside it.

Now read it back. With no mode, `open()` defaults to `"r"` for read:

```python run
with open("shopping.txt", encoding="utf-8") as f:
    contents = f.read()

print(contents)
contents
```

The displayed value shows the truth: the file is one string, with `\n` characters marking where each line ends.

> **Under the hood:** Writing to disk is slow, so Python collects your writes in a *buffer* and saves them in batches. Closing the file flushes whatever is left. Forget to close it and your last few lines might never reach the disk. A `with` block makes closing automatic, like a library that takes your book back the moment you walk out the door.

## The three modes you'll use

| Mode | Meaning | If the file exists… | If it doesn't… |
|---|---|---|---|
| `"r"` (default) | read | reads it | `FileNotFoundError` |
| `"w"` | write | **erases it first** | creates it |
| `"a"` | append | adds to the end | creates it |

That middle row deserves a warning sign. `"w"` doesn't mean "edit"; it means "start over with a blank page". To add to an existing file, use `"a"`:

```python run
with open("diary.txt", "w", encoding="utf-8") as f:   # start fresh
    f.write("Mon: rained all day\n")

with open("diary.txt", "a", encoding="utf-8") as f:   # add to the end
    f.write("Tue: sunny, went cycling\n")
    f.write("Wed: rained again\n")

with open("diary.txt", encoding="utf-8") as f:
    print(f.read())
```

```python predict id=predict-no-newline title="Where did the line break go?"
with open("todo.txt", "w", encoding="utf-8") as f:
    f.write("eggs")
    f.write("milk")

with open("todo.txt", encoding="utf-8") as f:
    print(f.read())
--- options
eggs milk
* eggsmilk
milk
['eggs', 'milk']
--- explain
Unlike `print`, `f.write()` writes **exactly** the text you give it: no space, no newline. The two words end up glued together on one line. Write `"eggs\n"` to end the line. (And `"w"` only erases the file once, when it's opened, so both writes survive.)
```

> **Tip:** Always pass `encoding="utf-8"`. Without it, Python uses your operating system's default, which on some Windows machines can't handle accents or emoji, so `"café ☕"` saved on one computer comes back garbled on another. UTF-8 is the universal choice.

## Reading line by line

Most text files are a list of records, one per line. You have several ways to get at the lines:

| Code | Gives you |
|---|---|
| `f.read()` | the whole file as one string |
| `f.readline()` | the next single line (including its `\n`) |
| `f.readlines()` | a list of all lines (each including its `\n`) |
| `for line in f:` | one line at a time: the usual choice, and memory-friendly for huge files |

```python predict id=predict-readlines title="What's in the list?"
with open("pets.txt", "w", encoding="utf-8") as f:
    f.write("cat\ndog\n")

with open("pets.txt", encoding="utf-8") as f:
    lines = f.readlines()
print(lines)
--- options
['cat', 'dog']
* ['cat\n', 'dog\n']
['cat\ndog\n']
['cat\n', 'dog\n', '']
--- explain
Each line keeps its newline character at the end. That's usually not what you want, which is why reading code almost always calls `.strip()` (or `.rstrip("\n")`) on each line.
```

Looping over the file object is the everyday pattern. Strip each line, skip the blanks, and you've got clean data:

```python run
with open("playlist.txt", "w", encoding="utf-8") as f:
    f.write("Bohemian Rhapsody\n\nDancing Queen\nHey Jude\n")

songs = []
with open("playlist.txt", encoding="utf-8") as f:
    for line in f:
        title = line.strip()
        if title:                 # skip blank lines
            songs.append(title)

print(len(songs), "songs:", songs)
```

```python exercise id=read-numbers title="Load temperatures from a file"
# This creates the file for you (one reading per line, with a blank line in the middle):
with open("temps.txt", "w", encoding="utf-8") as f:
    f.write("21.5\n19.0\n\n23.25\n")

def read_numbers(path):
    """Return a list of floats, one per non-blank line of the file at `path`."""
    # TODO: open the file, loop over its lines, skip blank ones,
    # and convert each remaining line with float().
    ...

temps = read_numbers("temps.txt")
print("temps:", temps)
--- solution
with open("temps.txt", "w", encoding="utf-8") as f:
    f.write("21.5\n19.0\n\n23.25\n")

def read_numbers(path):
    """Return a list of floats, one per non-blank line of the file at `path`."""
    numbers = []
    with open(path, encoding="utf-8") as f:
        for line in f:
            if line.strip():
                numbers.append(float(line))
    return numbers

temps = read_numbers("temps.txt")
print("temps:", temps)
--- test
assert temps is not None, "`read_numbers` returned None. Replace the `...` with code that builds and returns a list."
assert isinstance(temps, list), f"`read_numbers` should return a list, but returned {type(temps).__name__}."
assert temps != ["21.5", "19.0", "23.25"], "Those are strings. Convert each line with float()."
assert temps == [21.5, 19.0, 23.25], f"`read_numbers(\"temps.txt\")` should be [21.5, 19.0, 23.25], but is {temps!r}. Did you skip the blank line?"
with open("_check_numbers.txt", "w", encoding="utf-8") as f:
    f.write("  4\n\n-2.5\n10\n\n")
fresh = read_numbers("_check_numbers.txt")
assert fresh == [4.0, -2.5, 10.0], f"On a different file your function returned {fresh!r} instead of [4.0, -2.5, 10.0]. Make sure it reads the `path` it's given."
--- hint
Use `with open(path, encoding="utf-8") as f:` and then `for line in f:`. Build a list as you go.
--- hint
A blank line is `"\n"`, and `"\n".strip()` is `""`, which is falsy. So `if line.strip():` keeps only real lines.
--- hint
Inside the `if`, `numbers.append(float(line))`. `float()` ignores the newline and spaces around the number. Return the list at the end.
```

## When the file isn't there

Reading a file that doesn't exist raises `FileNotFoundError`, which you met in the last lesson:

```python run error
with open("recipes.txt", encoding="utf-8") as f:
    print(f.read())
```

A missing file is often perfectly normal: the first time an app runs, there's no save file yet. That's a job for `try`/`except`:

```python run
try:
    with open("recipes.txt", encoding="utf-8") as f:
        recipes = f.read()
except FileNotFoundError:
    recipes = ""
    print("No recipe book yet, starting with an empty one.")

print("recipes loaded:", repr(recipes))
```

## pathlib: paths as objects

Python's `pathlib` module (you'll learn about modules and `import` properly next lesson) wraps a file path in a `Path` object with handy methods. For small files, `read_text` and `write_text` open, read or write, and close in one call:

```python run
from pathlib import Path

notes = Path("notes.txt")
notes.unlink(missing_ok=True)          # delete it if it's left over, for a clean demo

print("exists before?", notes.exists())
notes.write_text("Buy stamps\nCall grandma\n", encoding="utf-8")
print("exists after? ", notes.exists())
print("lines:", notes.read_text(encoding="utf-8").splitlines())
print("name:", notes.name, "| stem:", notes.stem, "| suffix:", notes.suffix)
```

`.splitlines()` is a neat trick: it splits text into lines *and* drops the `\n` characters in one go.

> **In the wild:** Professional code increasingly uses `pathlib` everywhere. Paths combine with `/`, so `Path("reports") / "2026" / "march.csv"` builds a correct path on Windows, macOS and Linux alike, no fiddling with slashes.

## Debug challenge: the forgetful log

```python debug id=workout-log title="The log only remembers the last workout"
def log_workout(path, entry):
    """Add `entry` as a new line at the end of the log file."""
    with open(path, "w", encoding="utf-8") as f:
        f.write(entry)

# Start a fresh log with a title line
with open("workouts.txt", "w", encoding="utf-8") as f:
    f.write("WORKOUT LOG\n")

log_workout("workouts.txt", "run 5km")
log_workout("workouts.txt", "swim 1km")
log_workout("workouts.txt", "yoga 30min")

with open("workouts.txt", encoding="utf-8") as f:
    print(f.read())
--- solution
def log_workout(path, entry):
    """Add `entry` as a new line at the end of the log file."""
    with open(path, "a", encoding="utf-8") as f:
        f.write(entry + "\n")

with open("workouts.txt", "w", encoding="utf-8") as f:
    f.write("WORKOUT LOG\n")

log_workout("workouts.txt", "run 5km")
log_workout("workouts.txt", "swim 1km")
log_workout("workouts.txt", "yoga 30min")

with open("workouts.txt", encoding="utf-8") as f:
    print(f.read())
--- test
with open("workouts.txt", encoding="utf-8") as f:
    lines = f.read().splitlines()
assert "WORKOUT LOG" in lines, "The title line 'WORKOUT LOG' was wiped out. Which open() mode erases a file every time it's opened?"
assert len(lines) == 4, f"The log should have 4 lines (title + 3 workouts) but has {len(lines)}: {lines!r}. Does each entry end with a newline?"
assert lines == ["WORKOUT LOG", "run 5km", "swim 1km", "yoga 30min"], f"The log lines should be the title then the three workouts in order, but are {lines!r}."
with open("_check_log.txt", "w", encoding="utf-8") as f:
    f.write("LOG\n")
log_workout("_check_log.txt", "plank 2min")
log_workout("_check_log.txt", "squats x20")
with open("_check_log.txt", encoding="utf-8") as f:
    assert f.read() == "LOG\nplank 2min\nsquats x20\n", "`log_workout` should add each entry on its own line at the end of whatever file it's given."
--- hint
Run it: only `yoga 30min` survives, and even the title is gone. Look at the mode in `log_workout`'s `open()` call.
--- hint
`"w"` erases the file each time it's opened. You want the mode that adds to the end.
--- hint
Once that's fixed, the entries will be glued together on one line. `write()` doesn't add line breaks for you.
```

## CSV: spreadsheet data as text

A **CSV** (comma-separated values) file is a table stored as plain text: one row per line, columns separated by commas, usually with a header row. Every spreadsheet app can export one. It looks like you could just `.split(",")`… until a value contains a comma:

```python run
line = 'Alex,"Reds, Under-12",7'
print(line.split(","))   # 4 pieces: the team name got cut in half
```

The `csv` module knows the rules: commas inside quotes, quotes inside quotes, and more. `csv.reader` turns each line into a list of strings:

```python run
import csv

with open("roster.csv", "w", encoding="utf-8", newline="") as f:
    f.write('name,team,goals\nAlex,"Reds, Under-12",7\nSam,Blues,3\nPriya,Blues,11\n')

with open("roster.csv", encoding="utf-8", newline="") as f:
    rows = list(csv.reader(f))

header, data = rows[0], rows[1:]
print("header:", header)
for row in data:
    print(row)
```

Usually you'd rather refer to columns by **name** than by position. `csv.DictReader` reads the header for you and turns every row into a dictionary:

```python run
with open("roster.csv", encoding="utf-8", newline="") as f:
    players = list(csv.DictReader(f))

print(players[0])
total_goals = sum(int(p["goals"]) for p in players)
print("total goals:", total_goals)
```

Notice the `int(...)`. **Everything that comes out of a CSV file is a string**, even `"7"`. The file is just text; it has no idea which columns are numbers. Converting is your job.

> **Pitfall:** Pass `newline=""` whenever you open a file for the `csv` module. The module handles line endings itself, and without it, CSV files written on Windows get a blank line between every row.

```python exercise id=category-totals title="Total the spending by category"
import csv

# A bank export (created for you):
with open("expenses.csv", "w", encoding="utf-8", newline="") as f:
    f.write("date,category,amount\n"
            "2026-03-01,food,12.50\n"
            "2026-03-01,travel,40\n"
            "2026-03-02,food,7.25\n"
            "2026-03-03,fun,15\n")

def totals_by_category(path):
    """Read a CSV with columns date, category, amount.
    Return a dict mapping each category to its total amount (a float)."""
    # TODO: use csv.DictReader, convert each amount with float(),
    # and add it to that category's running total.
    ...

totals = totals_by_category("expenses.csv")
print(totals)
--- solution
import csv

with open("expenses.csv", "w", encoding="utf-8", newline="") as f:
    f.write("date,category,amount\n"
            "2026-03-01,food,12.50\n"
            "2026-03-01,travel,40\n"
            "2026-03-02,food,7.25\n"
            "2026-03-03,fun,15\n")

def totals_by_category(path):
    """Read a CSV with columns date, category, amount.
    Return a dict mapping each category to its total amount (a float)."""
    totals = {}
    with open(path, encoding="utf-8", newline="") as f:
        for row in csv.DictReader(f):
            cat = row["category"]
            totals[cat] = totals.get(cat, 0.0) + float(row["amount"])
    return totals

totals = totals_by_category("expenses.csv")
print(totals)
--- test
assert totals is not None, "`totals_by_category` returned None. Replace the `...` with code that builds and returns a dict."
assert isinstance(totals, dict), f"`totals_by_category` should return a dict, but returned {type(totals).__name__}."
assert set(totals) == {"food", "travel", "fun"}, f"The categories should be food, travel and fun, but your keys are {sorted(totals)!r}. Did the header row sneak in?"
assert all(isinstance(v, (int, float)) for v in totals.values()), f"Totals should be numbers, but got {totals!r}. Remember: CSV values are strings until you convert them."
assert abs(totals["food"] - 19.75) < 1e-9, f"food should total 19.75 (12.50 + 7.25), but is {totals['food']!r}."
assert totals["travel"] == 40 and totals["fun"] == 15, f"travel should be 40 and fun 15, but got {totals!r}."
with open("_check_expenses.csv", "w", encoding="utf-8", newline="") as f:
    f.write("date,category,amount\n2026-04-01,rent,900\n2026-04-02,gifts,20.5\n2026-04-09,gifts,4.5\n")
fresh = totals_by_category("_check_expenses.csv")
assert fresh == {"rent": 900.0, "gifts": 25.0}, f"On a different file your function returned {fresh!r} instead of {{'rent': 900.0, 'gifts': 25.0}}."
--- hint
`for row in csv.DictReader(f):` gives you dicts like `{"date": "2026-03-01", "category": "food", "amount": "12.50"}`.
--- hint
`row["amount"]` is a string. Convert it with `float()` before adding.
--- hint
The counting pattern from the dictionaries lesson works here: `totals[cat] = totals.get(cat, 0.0) + amount`.
```

### Writing CSV

`csv.writer` does the reverse: hand it lists, and it writes correctly quoted lines. `writerow` writes one row; `writerows` writes a whole list of them:

```python run
results = [("Priya", "Blues", 11), ("Alex", "Reds, Under-12", 7)]

with open("top_scorers.csv", "w", encoding="utf-8", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["name", "team", "goals"])
    writer.writerows(results)

print(Path("top_scorers.csv").read_text(encoding="utf-8"))
```

The writer added quotes around `"Reds, Under-12"` automatically, and converted the numbers to text for you.

```python exercise id=save-scores title="Save a leaderboard as CSV"
import csv

def save_scores(path, scores):
    """Write `scores` (a dict of player -> points) to a CSV file at `path`:
    a header row  player,points  then one row per player, highest points first."""
    # TODO: sort the players by points (highest first),
    # then write the header and rows with csv.writer.
    ...

save_scores("leaderboard.csv", {"mia": 40, "leo": 95, "ava": 72})
print("saved leaderboard.csv")
--- solution
import csv

def save_scores(path, scores):
    """Write `scores` (a dict of player -> points) to a CSV file at `path`:
    a header row  player,points  then one row per player, highest points first."""
    ranked = sorted(scores.items(), key=lambda pair: pair[1], reverse=True)
    with open(path, "w", encoding="utf-8", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["player", "points"])
        writer.writerows(ranked)

save_scores("leaderboard.csv", {"mia": 40, "leo": 95, "ava": 72})
print("saved leaderboard.csv")
--- test
from pathlib import Path
check = Path("_check_scores.csv")
check.unlink(missing_ok=True)
save_scores("_check_scores.csv", {"zoe": 3, "kai": 10, "ivy": 7})
assert check.exists(), "`save_scores` didn't create a file. Replace the `...` and open `path` in \"w\" mode."
with open(check, encoding="utf-8", newline="") as f:
    rows = [r for r in csv.reader(f) if r]
assert rows, "The file is empty. Write the header row and one row per player."
assert rows[0] == ["player", "points"], f"The first row should be the header ['player', 'points'], but is {rows[0]!r}."
assert len(rows) == 4, f"Expected a header plus 3 player rows, but found {len(rows)} rows."
assert sorted(rows[1:]) == sorted([["kai", "10"], ["ivy", "7"], ["zoe", "3"]]), f"The player rows should hold each name and their points, but are {rows[1:]!r}."
assert rows[1:] == [["kai", "10"], ["ivy", "7"], ["zoe", "3"]], f"Put the highest score first. Your rows are in this order: {[r[0] for r in rows[1:]]}."
--- hint
`sorted(scores.items(), key=lambda pair: pair[1], reverse=True)` gives `(player, points)` tuples, best first.
--- hint
Open with `open(path, "w", encoding="utf-8", newline="")`, make `writer = csv.writer(f)`, then `writer.writerow([...header...])`.
--- hint
Each `(player, points)` tuple is already a row, so `writer.writerows(ranked)` writes them all.
```

## Debug challenge: the priciest item

```python debug id=priciest-item title="The most expensive item is a latte?"
import csv

with open("menu.csv", "w", encoding="utf-8", newline="") as f:
    f.write("item,price\nlatte,4.50\nbagel,3.25\nlunch special,12.00\ncookie,2.75\n")

def most_expensive(path):
    """Return the name of the most expensive item in a menu CSV."""
    with open(path, encoding="utf-8", newline="") as f:
        menu = list(csv.DictReader(f))
    priciest = max(menu, key=lambda row: row["price"])
    return priciest["item"]

print("Most expensive:", most_expensive("menu.csv"))
--- solution
import csv

with open("menu.csv", "w", encoding="utf-8", newline="") as f:
    f.write("item,price\nlatte,4.50\nbagel,3.25\nlunch special,12.00\ncookie,2.75\n")

def most_expensive(path):
    """Return the name of the most expensive item in a menu CSV."""
    with open(path, encoding="utf-8", newline="") as f:
        menu = list(csv.DictReader(f))
    priciest = max(menu, key=lambda row: float(row["price"]))
    return priciest["item"]

print("Most expensive:", most_expensive("menu.csv"))
--- test
got = most_expensive("menu.csv")
assert got != "latte", "Still 'latte'. Compare \"4.50\" and \"12.00\" as text: which comes first alphabetically?"
assert got == "lunch special", f"The most expensive item is the lunch special (12.00), but your function says {got!r}."
with open("_check_menu.csv", "w", encoding="utf-8", newline="") as f:
    f.write("item,price\ntea,2.5\nsteak,25\ncake,9.75\n")
fresh = most_expensive("_check_menu.csv")
assert fresh == "steak", f"For a menu with tea 2.5, steak 25 and cake 9.75, your function returned {fresh!r} instead of 'steak'."
--- hint
Run it. A 4.50 latte beats a 12.00 lunch? Remember what type every CSV value has.
--- hint
`"4.50" > "12.00"` is `True`, because strings compare character by character and `"4"` comes after `"1"`.
--- hint
Make the `key` function return a number instead of the raw text.
```

## JSON: saving nested data

CSV is great for flat tables, but what about a dictionary that contains a list that contains more dictionaries? **JSON** (JavaScript Object Notation) stores exactly that kind of nested data, and it looks almost like Python:

| Python | JSON |
|---|---|
| `dict` | object `{...}` (keys always strings) |
| `list` (and `tuple`) | array `[...]` |
| `str` | string, always in **double** quotes |
| `int`, `float` | number |
| `True` / `False` | `true` / `false` |
| `None` | `null` |

`json.dumps` ("dump string") turns Python data into JSON text; `json.loads` ("load string") turns JSON text back into Python data:

```python run
import json

recipe = {"name": "Pancakes", "serves": 4, "vegan": False,
          "ingredients": ["flour", "milk", "eggs"], "rating": None}

text = json.dumps(recipe)
print(text)

back = json.loads(text)
print(back["ingredients"][0], "| same data?", back == recipe)
```

```python predict id=predict-json-dumps title="What does the JSON look like?"
import json
print(json.dumps({"done": True, "due": None, "tags": ("home", "urgent")}))
--- options
{'done': True, 'due': None, 'tags': ('home', 'urgent')}
{"done": True, "due": None, "tags": ["home", "urgent"]}
* {"done": true, "due": null, "tags": ["home", "urgent"]}
{"done": true, "due": null, "tags": ("home", "urgent")}
--- explain
JSON has its own spellings: double quotes, lowercase `true`/`false`, `null` for `None`, and square-bracket arrays. JSON has no tuples, so a tuple becomes an array, and it will come back as a **list** when you load it.
```

To work with files, drop the `s`: `json.dump(data, f)` writes to an open file and `json.load(f)` reads from one. Add `indent=2` and the file becomes pleasant for humans to read too:

```python run
trip = {"destination": "Kyoto", "nights": 5,
        "stops": [{"city": "Osaka", "nights": 2}, {"city": "Nara", "nights": 1}]}

with open("trip.json", "w", encoding="utf-8") as f:
    json.dump(trip, f, indent=2)

print(Path("trip.json").read_text(encoding="utf-8"))

with open("trip.json", encoding="utf-8") as f:
    loaded = json.load(f)
print("total nights:", loaded["nights"] + sum(s["nights"] for s in loaded["stops"]))
```

> **In the wild:** JSON is everywhere: nearly every web API sends JSON, VS Code's settings are a JSON file, and Python projects ship config in it. When you call a weather API, you get JSON text back and `json.loads` turns it into ordinary dictionaries and lists.

```python exercise id=settings-json title="Save and load app settings"
import json

def save_settings(path, settings):
    """Write the `settings` dict to `path` as JSON, with indent=2."""
    # TODO: open the file for writing and json.dump the settings into it.
    ...

def load_settings(path):
    """Return the settings dict stored at `path`.
    If the file doesn't exist yet, return {"theme": "light", "volume": 5}."""
    # TODO: json.load the file; catch FileNotFoundError and return the defaults.
    ...

save_settings("settings.json", {"theme": "dark", "volume": 8, "muted": False})
print(load_settings("settings.json"))
print(load_settings("no_such_file.json"))
--- solution
import json

def save_settings(path, settings):
    """Write the `settings` dict to `path` as JSON, with indent=2."""
    with open(path, "w", encoding="utf-8") as f:
        json.dump(settings, f, indent=2)

def load_settings(path):
    """Return the settings dict stored at `path`.
    If the file doesn't exist yet, return {"theme": "light", "volume": 5}."""
    try:
        with open(path, encoding="utf-8") as f:
            return json.load(f)
    except FileNotFoundError:
        return {"theme": "light", "volume": 5}

save_settings("settings.json", {"theme": "dark", "volume": 8, "muted": False})
print(load_settings("settings.json"))
print(load_settings("no_such_file.json"))
--- test
from pathlib import Path
check = Path("_check_settings.json")
check.unlink(missing_ok=True)
data = {"theme": "solarized", "volume": 3, "muted": True, "recent": ["a.txt", "b.txt"]}
save_settings("_check_settings.json", data)
assert check.exists(), "`save_settings` didn't create the file. Replace its `...` with code that opens `path` in \"w\" mode."
text = check.read_text(encoding="utf-8")
try:
    parsed = json.loads(text)
except ValueError:
    assert False, f"The file doesn't contain valid JSON. It contains: {text[:60]!r}. Use json.dump."
assert parsed == data, f"The saved JSON should hold the settings exactly, but it holds {parsed!r}."
assert "\n  " in text, "Save with `indent=2` so the file is easy for people to read."
loaded = load_settings("_check_settings.json")
assert loaded is not None, "`load_settings` returned None. Replace its `...` and return the loaded dict."
assert loaded == data, f"`load_settings` should return what was saved, {data!r}, but returned {loaded!r}."
Path("_missing_settings.json").unlink(missing_ok=True)
default = load_settings("_missing_settings.json")
assert default == {"theme": "light", "volume": 5}, f"For a missing file, `load_settings` should return the defaults, but returned {default!r}."
--- hint
Saving: `with open(path, "w", encoding="utf-8") as f:` then `json.dump(settings, f, indent=2)`.
--- hint
Loading: put the `with open(path, ...)` and `return json.load(f)` inside a `try:` block.
--- hint
Add `except FileNotFoundError:` and return the default dictionary from the docstring.
```

## Recap

- Open files with `with open(path, mode, encoding="utf-8") as f:`, so they're always closed. Modes: `"r"` read (default), `"w"` **erase** and write, `"a"` append.
- `write()` adds exactly what you give it: include `"\n"` yourself. When reading, `.strip()` each line (or use `.splitlines()`).
- `pathlib.Path` gives you `exists()`, `read_text()` and `write_text()`; catch `FileNotFoundError` when a file might not exist yet.
- Use the `csv` module (with `newline=""`) for tables: `csv.reader`, `csv.DictReader` and `csv.writer`. **Every CSV value is a string** until you convert it.
- Use `json.dump`/`json.load` (files) and `json.dumps`/`json.loads` (strings) for nested dicts and lists; `indent=2` makes files readable.

**Up next:** modules and the standard library: how `import` really works, Python's "batteries included" toolkit (`random`, `datetime`, `collections` and more), and how to split your own code into modules.
