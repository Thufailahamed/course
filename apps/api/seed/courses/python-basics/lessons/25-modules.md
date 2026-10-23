You've already borrowed other people's code without making a fuss about it. `import math` gave you square roots, `import csv` read spreadsheets, `import json` saved your settings. Each of those was a **module**: a file of ready-made Python that someone else wrote, tested, and shared.

Python ships with hundreds of them, a collection called the **standard library**. Programmers describe Python as "batteries included" because of it: dates, randomness, statistics, counting, file paths and much more are already installed and waiting. In this lesson you'll learn exactly how `import` works, take a guided tour of the modules you'll reach for most, explore unfamiliar ones on your own, and split your own code into modules.

## What a module is

A module is simply a `.py` file full of definitions: functions, variables, sometimes classes. Importing it runs that file once and gives you a name to reach inside it with a dot:

```python run
import math

print("square root of 2:", math.sqrt(2))
print("pi to 5 places:", round(math.pi, 5))
print("round 7.2 up:", math.ceil(7.2))
math
```

Think of a module as a toolbox with a label on the lid. `import math` puts the toolbox on your bench; `math.sqrt` means "the `sqrt` tool from the `math` box". The label prevents confusion: `math.floor` and a variable you named `floor` can't collide.

## Four ways to import

| Style | Then you write | Good for |
|---|---|---|
| `import math` | `math.sqrt(9)` | most code: always clear where a name comes from |
| `from math import sqrt, pi` | `sqrt(9)` | a few names you use constantly |
| `import statistics as stats` | `stats.mean(...)` | long module names, or a famous convention |
| `from math import sqrt as root` | `root(9)` | avoiding a clash with one of your own names |

```python run
from math import sqrt, pi
import statistics as stats

print("diagonal of a 3x4 screen:", sqrt(3**2 + 4**2))
print("area of a 10cm pizza:", round(pi * 5**2, 1), "cm²")
print("average rating:", stats.mean([4, 5, 3, 5, 4]))
```

The most common import mistake is mixing the styles up. `import math` makes **only the name `math`** available; the functions stay inside the box:

```python run error
import math

whole_pizzas = floor(7.8)     # forgot the "math." part
print(whole_pizzas)
```

The fix is either `math.floor(7.8)` or `from math import floor` at the top. Both work; the first makes it obvious, months later, where `floor` came from.

> **Pitfall:** Never name your own file after a module you want to use. If you save your practice script as `random.py`, then `import random` inside it imports *your file* instead of Python's, and `random.randint` mysteriously "doesn't exist". The same goes for `math.py`, `csv.py`, `json.py` and friends.

> **Tip:** You'll sometimes see `from math import *`, which dumps every name from the module into your code. Avoid it: you can no longer tell where names came from, and it can silently overwrite your own variables.

## random: controlled chance

The `random` module makes games, simulations and shuffled quizzes possible. Real randomness is a problem when you're testing, though: you want the *same* "random" results every run. A **seed** gives you that. Same seed, same sequence, every time:

```python run
import random

random.seed(42)
print("dice roll:", random.randint(1, 6))           # 1 to 6, both ends included
print("lunch:", random.choice(["pizza", "sushi", "tacos"]))
print("raffle winners:", random.sample(["Ana", "Ben", "Cy", "Dee", "Eli"], 2))

playlist = ["intro", "verse", "chorus", "bridge"]
random.shuffle(playlist)                             # shuffles IN PLACE, returns None
print("shuffled:", playlist)
```

| Function | Does |
|---|---|
| `random.seed(n)` | make the sequence repeatable |
| `random.randint(a, b)` | whole number from `a` to `b`, **both included** |
| `random.random()` | float from 0.0 up to (not including) 1.0 |
| `random.choice(seq)` | one item |
| `random.sample(seq, k)` | `k` different items, as a new list |
| `random.shuffle(lst)` | reorder a list in place |

For code that shouldn't disturb anyone else's sequence, make your own private generator: `rng = random.Random(7)` gives an object with all the same methods (`rng.choice(...)`, `rng.randint(...)`), seeded with 7.

```python predict id=predict-seed title="Same seed, same rolls?"
import random

random.seed(5)
first = [random.randint(1, 6) for roll in range(3)]
random.seed(5)
second = [random.randint(1, 6) for roll in range(3)]
print(first == second)
--- options
* True
False
None
[True, True, True]
--- explain
"Random" numbers in a computer are produced by a formula. The seed is its starting point, so re-seeding with 5 replays exactly the same three rolls. That's why tests and games with replay features seed their generators.
```

```python exercise id=draw-winners title="A fair, repeatable raffle"
import random

def draw_winners(names, k, seed):
    """Return a list of k DIFFERENT winners picked from `names`.
    The same seed must always give the same winners.
    Don't change the `names` list itself."""
    # TODO: make a generator with random.Random(seed) (or call random.seed(seed)),
    # then pick k different names.
    ...

entrants = ["Ana", "Ben", "Cy", "Dee", "Eli", "Fay", "Gus"]
print("winners:", draw_winners(entrants, 3, seed=2026))
--- solution
import random

def draw_winners(names, k, seed):
    """Return a list of k DIFFERENT winners picked from `names`.
    The same seed must always give the same winners.
    Don't change the `names` list itself."""
    rng = random.Random(seed)
    return rng.sample(names, k)

entrants = ["Ana", "Ben", "Cy", "Dee", "Eli", "Fay", "Gus"]
print("winners:", draw_winners(entrants, 3, seed=2026))
--- test
people = ["Ana", "Ben", "Cy", "Dee", "Eli", "Fay", "Gus"]
before = list(people)
got = draw_winners(people, 3, seed=2026)
assert got is not None, "`draw_winners` returned None. Replace the `...` and return a list of winners."
assert isinstance(got, list), f"`draw_winners` should return a list, but returned {type(got).__name__}."
assert people == before, "`draw_winners` changed the `names` list. Pick winners without shuffling the original."
assert len(got) == 3, f"Asked for 3 winners but got {len(got)}: {got!r}."
assert len(set(got)) == 3, f"Winners must all be different people, but got {got!r}. Which function never picks the same item twice?"
assert all(name in people for name in got), f"Every winner must come from `names`, but got {got!r}."
assert draw_winners(people, 3, seed=2026) == got, "Calling again with the same seed gave different winners. Seed the generator inside the function."
draws = {tuple(draw_winners(people, 3, seed=s)) for s in range(8)}
assert len(draws) > 1, "Every seed gives the same winners. Make sure you actually use the `seed` argument."
big = draw_winners(list(range(50)), 10, seed=1)
assert len(big) == 10 and len(set(big)) == 10, "Try it on a bigger list: `draw_winners(list(range(50)), 10, seed=1)` should give 10 different items."
--- hint
To make results repeatable, the seed has to be set inside the function, every time it's called.
--- hint
`random.Random(seed)` creates a seeded generator. Which method picks `k` different items without changing the original list?
--- hint
`rng.sample(names, k)` returns a new list of `k` distinct items.
```

## datetime: dates without the headaches

How many days until a holiday? What date is 30 days after an invoice? Months have different lengths and leap years exist, so never do date math by hand. The `datetime` module's `date` and `timedelta` handle all of it:

```python run
from datetime import date, timedelta

trip_start = date(2026, 7, 14)
trip_end = date(2026, 7, 28)

print("nights away:", (trip_end - trip_start).days)
print("pack by:", trip_start - timedelta(days=3))
print("leaves on:", trip_start.strftime("%A %d %B %Y"))
print("weekday number:", trip_start.weekday(), "(Monday = 0 ... Sunday = 6)")
```

- Subtracting two dates gives a `timedelta`; its `.days` is a plain `int`.
- Adding or subtracting a `timedelta(days=...)` gives a new `date`, correctly rolling over months and years.
- `.strftime(...)` formats a date as text: `%A` weekday name, `%d` day, `%B` month name, `%Y` year.

> **Tip:** `date.today()` gives the current date. It's perfect in real programs, but it changes every day, so the examples and tests in this course stick to fixed dates you can predict.

```python exercise id=library-due-date title="When is the book due?"
from datetime import date, timedelta

def due_date(borrowed, days=21):
    """Return the date a library book is due: `days` days after `borrowed`.
    The library is closed at weekends, so if that lands on a Saturday
    or Sunday, the book is due the following Monday instead."""
    # TODO: add a timedelta, then use .weekday() (Saturday = 5, Sunday = 6)
    # to push weekend dates forward to Monday.
    ...

print(due_date(date(2026, 3, 2)))     # lands on a Monday
print(due_date(date(2026, 3, 7)))     # would land on a Saturday
--- solution
from datetime import date, timedelta

def due_date(borrowed, days=21):
    """Return the date a library book is due: `days` days after `borrowed`.
    The library is closed at weekends, so if that lands on a Saturday
    or Sunday, the book is due the following Monday instead."""
    due = borrowed + timedelta(days=days)
    if due.weekday() == 5:
        due += timedelta(days=2)
    elif due.weekday() == 6:
        due += timedelta(days=1)
    return due

print(due_date(date(2026, 3, 2)))
print(due_date(date(2026, 3, 7)))
--- test
got = due_date(date(2026, 3, 2))
assert got is not None, "`due_date` returned None. Replace the `...` and return a date."
assert isinstance(got, date), f"`due_date` should return a date object, but returned {got!r}. Add a timedelta to `borrowed`."
assert got == date(2026, 3, 23), f"Borrowed on 2026-03-02, the book is due 21 days later on 2026-03-23, but you returned {got}."
def _ref(b, d=21):
    x = b + timedelta(days=d)
    return x + timedelta(days={5: 2, 6: 1}.get(x.weekday(), 0))
sat = due_date(date(2026, 3, 7))
assert sat.weekday() not in (5, 6), f"2026-03-07 + 21 days is a Saturday, so the book should be due on Monday, but you returned {sat} ({sat.strftime('%A')})."
assert sat == date(2026, 3, 30), f"A Saturday due date should move to the next Monday (2026-03-30), but you returned {sat}."
for b, d in [(date(2026, 3, 8), 21), (date(2025, 12, 20), 14), (date(2026, 2, 20), 8), (date(2028, 2, 10), 21), (date(2026, 10, 30), 7)]:
    mine = due_date(b, d)
    assert mine == _ref(b, d), f"`due_date({b!r}, {d})` should be {_ref(b, d)} but is {mine}. Check the `days` argument and the weekend rule."
--- hint
Start with `due = borrowed + timedelta(days=days)`. Use the `days` parameter, not a hard-coded 21.
--- hint
`due.weekday()` is 5 for Saturday and 6 for Sunday. How many days does each need to reach Monday?
--- hint
Add `timedelta(days=2)` for a Saturday and `timedelta(days=1)` for a Sunday, then return `due`.
```

## collections: Counter and defaultdict

Back in the dictionaries lesson you counted words with `counts[w] = counts.get(w, 0) + 1`. That pattern is so common that the `collections` module has a ready-made tool for it. A `Counter` is a dictionary that counts:

```python run
from collections import Counter

votes = ["pizza", "tacos", "pizza", "sushi", "pizza", "tacos"]
tally = Counter(votes)

print(tally)
print("pizza votes:", tally["pizza"], "| burger votes:", tally["burger"])   # missing → 0, no KeyError
print("top two:", tally.most_common(2))
```

Its sibling `defaultdict` creates a starting value automatically the first time you touch a key. `defaultdict(list)` is perfect for grouping:

```python run
from collections import defaultdict

books = [("Dune", "sci-fi"), ("Emma", "classic"), ("Neuromancer", "sci-fi"), ("Persuasion", "classic"), ("Hyperion", "sci-fi")]

by_genre = defaultdict(list)
for title, genre in books:
    by_genre[genre].append(title)     # no "if genre not in by_genre" needed

print(dict(by_genre))
```

```python predict id=predict-counter title="Most common letter"
from collections import Counter
print(Counter("banana").most_common(1))
--- options
('a', 3)
* [('a', 3)]
{'a': 3}
a
--- explain
A `Counter` can count any iterable, including the letters of a string. `most_common(n)` always returns a **list** of `(item, count)` tuples, even when you ask for just one, so `.most_common(1)[0]` would give the tuple `('a', 3)`.
```

## string and statistics: two small gems

The `string` module holds handy constants, and `statistics` does the averages you'd otherwise write by hand:

```python run
import string
import statistics

print("letters:", string.ascii_lowercase)
print("punctuation:", string.punctuation)

lap_times = [61.2, 59.8, 60.5, 62.1, 59.8]
print("mean:", round(statistics.mean(lap_times), 2))
print("median:", statistics.median(lap_times))
print("mode:", statistics.mode(lap_times))
print("stdev:", round(statistics.stdev(lap_times), 2))
```

`string.punctuation` pairs beautifully with `.strip()`: `"hello!".strip(string.punctuation)` is `"hello"`. You'll need that next.

```python exercise id=top-words title="The most common words in a review"
from collections import Counter
import string

def top_words(text, n):
    """Return the n most common words in `text` as a list of (word, count) tuples,
    most common first. Ignore case and strip punctuation from the ends of words."""
    # TODO: lowercase the text, split it into words, strip punctuation
    # from each word, skip any that become empty, then count with Counter.
    ...

review = "Great coffee! The coffee was hot, the staff were great, and the cake... the CAKE was great too."
print(top_words(review, 3))
--- solution
from collections import Counter
import string

def top_words(text, n):
    """Return the n most common words in `text` as a list of (word, count) tuples,
    most common first. Ignore case and strip punctuation from the ends of words."""
    words = [w.strip(string.punctuation) for w in text.lower().split()]
    return Counter(w for w in words if w).most_common(n)

review = "Great coffee! The coffee was hot, the staff were great, and the cake... the CAKE was great too."
print(top_words(review, 3))
--- test
got = top_words("Great coffee! The coffee was hot, the staff were great, and the cake... the CAKE was great too.", 3)
assert got is not None, "`top_words` returned None. Replace the `...` and return the result of `.most_common(n)`."
assert isinstance(got, list), f"`top_words` should return a list of (word, count) tuples, but returned {type(got).__name__}."
assert len(got) == 3, f"Asked for 3 words but got {len(got)}: {got!r}."
assert got[0] == ("the", 4), f"The top word should be ('the', 4), but is {got[0]!r}. Did you lowercase the text?"
assert got[1] == ("great", 3), f"Second should be ('great', 3), but is {got[1]!r}. Are 'great,' and 'Great' counted as the same word?"
assert got[2] in [("coffee", 2), ("was", 2), ("cake", 2)], f"Third should be one of the words that appear twice, but is {got[2]!r}."
fresh = top_words("Go, go, GO! Stop. stop... wait -- go?", 2)
assert fresh == [("go", 4), ("stop", 2)], f"`top_words(\"Go, go, GO! Stop. stop... wait -- go?\", 2)` should be [('go', 4), ('stop', 2)], not {fresh!r}."
assert top_words("...", 5) == [], "Text that's only punctuation has no words: return an empty list."
--- hint
`text.lower().split()` gives you the words; `word.strip(string.punctuation)` cleans each one. A lone `--` or `...` becomes `""`, so skip empty strings.
--- hint
`Counter(list_of_words)` counts them all at once. Which Counter method returns the top `n` as `(word, count)` tuples?
--- hint
Return `Counter(...).most_common(n)`.
```

## Exploring a module on your own

Nobody memorizes the standard library. Professionals look things up, and Python has two built-in tools for it. `dir(module)` lists the names inside; `help(thing)` prints its documentation:

```python run
import random

public = [name for name in dir(random) if not name.startswith("_")]
print(len(public), "public names, such as:", public[:8])

help(random.randint)
```

Names starting with `_` are internal plumbing, so we filter them out. When you find a promising name, `help()` tells you what it does and what arguments it takes.

> **In the wild:** The official docs at docs.python.org include "The Python Standard Library" with a page for every module. Beyond the standard library, `pip install` gives you over half a million third-party packages, such as `requests` for the web, `pandas` for data and `django` for websites, and they're all imported exactly the way you've learned here.

## Debug challenge: random stopped working

```python debug id=random-name-clash title="random.seed suddenly doesn't exist"
import random
from random import random     # "so I can write random() for a quick coin flip"

def pick_snack(snacks, seed):
    """Pick one snack, reproducibly, using the seed."""
    random.seed(seed)
    return random.choice(snacks)

def coin_flip():
    return "heads" if random() < 0.5 else "tails"

print("snack:", pick_snack(["chips", "apple", "popcorn", "pretzels"], seed=1))
print("flip:", coin_flip())
--- solution
import random

def pick_snack(snacks, seed):
    """Pick one snack, reproducibly, using the seed."""
    random.seed(seed)
    return random.choice(snacks)

def coin_flip():
    return "heads" if random.random() < 0.5 else "tails"

print("snack:", pick_snack(["chips", "apple", "popcorn", "pretzels"], seed=1))
print("flip:", coin_flip())
--- test
import random as _rnd
snacks = ["chips", "apple", "popcorn", "pretzels"]
_rnd.seed(1)
expected = _rnd.choice(snacks)
assert pick_snack(snacks, seed=1) == expected, f"`pick_snack(snacks, seed=1)` should pick {expected!r}."
_rnd.seed(9)
expected9 = _rnd.choice(["tea", "cake", "fruit"])
assert pick_snack(["tea", "cake", "fruit"], seed=9) == expected9, "`pick_snack` should seed and then pick from the list it's given."
_rnd.seed(0)
flips = [coin_flip() for i in range(20)]
assert set(flips) == {"heads", "tails"}, f"`coin_flip()` should return 'heads' or 'tails' at random, but 20 flips gave {sorted(set(flips))}."
--- hint
Run it and read the last line of the error: `random` is a *function* by the time `pick_snack` runs, not the module.
--- hint
`from random import random` takes the `random()` function out of the module and gives it the name `random`, replacing the module you imported on the line above.
--- hint
Keep the plain `import random` only, and write `random.random()` inside `coin_flip`.
```

## Debug challenge: the map distance crashes

```python debug id=missing-math-prefix title="NameError: sqrt is not defined"
import math

def distance(x1, y1, x2, y2):
    """Straight-line distance between two points on a city grid (in km)."""
    return sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2)

def taxi_fare(km):
    """$3 to start, plus $2 for every km or part of a km."""
    return 3 + 2 * ceil(km)

d = distance(0, 0, 3, 4)
print("distance:", d, "km | fare: $", taxi_fare(d))
--- solution
import math

def distance(x1, y1, x2, y2):
    """Straight-line distance between two points on a city grid (in km)."""
    return math.sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2)

def taxi_fare(km):
    """$3 to start, plus $2 for every km or part of a km."""
    return 3 + 2 * math.ceil(km)

d = distance(0, 0, 3, 4)
print("distance:", d, "km | fare: $", taxi_fare(d))
--- test
assert distance(0, 0, 3, 4) == 5.0, f"`distance(0, 0, 3, 4)` should be 5.0, not {distance(0, 0, 3, 4)!r}."
assert abs(distance(1, 1, 4, 5) - 5.0) < 1e-9 and abs(distance(0, 0, 1, 1) - 2 ** 0.5) < 1e-9, "`distance` should use the Pythagorean formula for any two points."
assert taxi_fare(5.0) == 13, f"`taxi_fare(5.0)` should be 13 ($3 + 5 km x $2), not {taxi_fare(5.0)!r}."
assert taxi_fare(1.2) == 7, f"`taxi_fare(1.2)` should round the 1.2 km up to 2 km, giving 7, not {taxi_fare(1.2)!r}."
--- hint
Read the error's last line: Python has never heard of `sqrt`. Where does it actually live?
--- hint
`import math` only creates the name `math`. Fix the first NameError, run again, and you'll meet a second one of the same kind.
--- hint
Either write `math.sqrt` and `math.ceil`, or change the import to `from math import sqrt, ceil`.
```

## Writing your own modules

Here's the satisfying part: **any `.py` file is a module**. Once a program grows past a screen or two, you split it into files (say, `shop_utils.py` for helper functions and `main.py` for the program itself) and `import` one from the other.

This page's sandboxed filesystem lets us do it for real. First, write a module file:

```python run
from pathlib import Path

Path("shop_utils.py").write_text('''\
"""Helpers for our little online shop."""

TAX_RATE = 0.2

def with_tax(price):
    """Return the price including tax, rounded to cents."""
    return round(price * (1 + TAX_RATE), 2)

def format_price(price):
    return f"${price:,.2f}"
''', encoding="utf-8")

print("wrote shop_utils.py")
```

Now import it exactly like a standard library module. Python finds it because it's in the current folder:

```python run
import importlib
importlib.invalidate_caches()   # only needed because the file was created while Python was running

import shop_utils

print("tax rate:", shop_utils.TAX_RATE)
print("price with tax:", shop_utils.format_price(shop_utils.with_tax(49.99)))
```

> **Under the hood:** Python runs a module's code only **the first time** it's imported, then keeps it in memory (in `sys.modules`). A second `import shop_utils` is instant and doesn't re-run the file. That's also why editing a module file doesn't affect a program that already imported it until you restart.

## `if __name__ == "__main__":`

Every module has a built-in variable called `__name__`. When Python runs a file **directly** (`python greetings.py`), it sets `__name__` to `"__main__"`. When the file is **imported**, `__name__` is the module's own name instead. That lets one file behave both ways:

```python run
Path("greetings.py").write_text('''\
def greet(name):
    return f"Hello, {name}!"

print("inside greetings.py, __name__ is", repr(__name__))

if __name__ == "__main__":
    # Only runs when the file is run directly, e.g. a quick self-test
    print(greet("tester"))
''', encoding="utf-8")
importlib.invalidate_caches()

import greetings
print(greetings.greet("Ana"))
```

Because we *imported* `greetings`, its `__name__` was `"greetings"`, so the self-test inside the `if` was skipped. Run that file directly and the self-test would run instead. (Run the cell a second time and the module's `print` won't appear: it was already imported.)

```python predict id=predict-dunder-name title="What is __name__ here?"
print(__name__)
--- options
* __main__
main
None
__name__
--- explain
Your cells run as the main program, not as an imported module, so `__name__` is `"__main__"`. That's exactly the situation `if __name__ == "__main__":` checks for.
```

> **In the wild:** Almost every Python script you'll read at work ends with `if __name__ == "__main__": main()`. It means "run the program when started directly, but let other files import my functions without kicking it off". Test tools like `pytest` rely on that: they import your file to test its functions without running the whole program.

## Recap

- A **module** is a `.py` file of reusable code; the **standard library** is the big set of modules that comes with Python.
- `import math` → `math.sqrt(...)`; `from math import sqrt` → `sqrt(...)`; `as` gives a shorter or non-clashing name. Don't name your files after modules you use.
- Tour highlights: `random` (seed it for repeatable results), `datetime` (`date`, `timedelta`, `.weekday()`, `.strftime`), `collections` (`Counter`, `defaultdict`), `string`, `statistics`.
- Explore unfamiliar modules with `dir()` and `help()`.
- Your own `.py` files are modules too; `if __name__ == "__main__":` separates "run me" code from "import me" code.

**Up next:** classes and objects, where you'll design your own data types, like a `BankAccount` that knows its own balance.
