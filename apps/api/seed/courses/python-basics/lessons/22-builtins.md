Python ships with about 70 **built-in functions**, always available, no `import` needed. You already know a handful: `print`, `len`, `sum`, `round`. The rest of the toolkit is where Python starts to feel like a superpower. Sorting a leaderboard by score, numbering a to-do list, pairing up two lists, checking whether *any* temperature broke a record: each of these is a five-line loop in most languages and a single, readable line in Python.

This lesson is a tour of the tools professionals reach for every day: `sorted` and `min`/`max` with a **`key`**, tiny throwaway functions called **`lambda`**, `enumerate`, `zip`, `any`/`all`, `map`/`filter`, `reversed` and `isinstance`. You'll write functions that use them, and fix two classic bugs they were invented to prevent.

## The everyday six

A quick refresher on the built-ins you've been using since Section 2:

```python run
temps = [18.5, 24.0, -3.2, 30.1, 21.7]

print("readings:", len(temps))
print("total:   ", round(sum(temps), 1))
print("coldest: ", min(temps), " hottest:", max(temps))
print("biggest swing from zero:", abs(min(temps)))
print("average: ", round(sum(temps) / len(temps), 2))
```

`len`, `sum`, `min`, `max`, `abs` and `round` cover most simple statistics. The rest of this lesson is about telling these tools *how* to compare things.

## `sorted()` with a `key`

You met `sorted()` in lesson 14: it returns a **new** sorted list and leaves the original alone, with `reverse=True` for descending order. Its real power is the `key` parameter: a **function** that `sorted` calls on each item to decide what to compare.

```python run
fruits = ["banana", "kiwi", "fig", "cherry"]

print(sorted(fruits))                 # alphabetical
print(sorted(fruits, key=len))        # by length: compares len("banana"), len("kiwi"), ...
print(sorted(fruits, key=len, reverse=True))
```

Notice `key=len`, not `key=len()`. You're handing `sorted` the function itself, the recipe card, so *it* can call it on every item. And `key` doesn't change the items: you still get fruit names back, just in a new order.

Any function that takes one item works as a key, including your own:

```python run
products = [("headphones", 79.99), ("cable", 9.50), ("speaker", 45.00)]

def price_of(product):
    return product[1]

sorted(products, key=price_of)
```

```python predict id=predict-sort-key-len title="What is displayed?"
sorted(["melon", "fig", "apple", "kiwi"], key=len)
--- options
['apple', 'fig', 'kiwi', 'melon']
* ['fig', 'kiwi', 'melon', 'apple']
['fig', 'kiwi', 'apple', 'melon']
[3, 4, 5, 5]
--- explain
`key=len` sorts by length: 3, 4, then two words of length 5. When keys tie, `sorted` is **stable**: tied items keep their original order, so `"melon"` (which came first) stays before `"apple"`. And you get the words back, not the lengths.
```

## `lambda`: a function without a name

Writing a whole `def` just to say "use the second item" feels heavy. A **lambda** is a one-expression function you can write right where you need it:

```python run
double = lambda n: n * 2         # same as: def double(n): return n * 2
print(double(21))

products = [("headphones", 79.99), ("cable", 9.50), ("speaker", 45.00)]
sorted(products, key=lambda product: product[1])
```

Read `lambda product: product[1]` as "a function that takes `product` and returns `product[1]`." The rules:

- `lambda parameters: expression`. No `return` keyword; the expression's value **is** the return value.
- Only a **single expression**: no loops, no `if` blocks, no assignments. (A conditional expression `a if cond else b` is fine.)
- Use lambdas for short, one-off functions passed to other functions, like `key=`. If you'd give it a name, or it needs more than one line, write a `def`.

Sorting a dictionary by its values is the classic lambda job. `.items()` gives `(key, value)` pairs, and the lambda picks the value:

```python run
votes = {"pizza": 14, "sushi": 22, "tacos": 9, "curry": 17}

ranked = sorted(votes.items(), key=lambda pair: pair[1], reverse=True)
print(ranked)
print("winner:", ranked[0][0])
```

> **In the wild:** `key=lambda ...` is everywhere in real code: sorting database rows by date, files by size, users by last login. pandas uses the same idea in `df.sort_values(key=...)`, and you'll use it to sort transactions in the budget-tracker project.

Python refuses to sort things it can't compare. Mixed numbers and strings are the usual culprit:

```python run error
sorted([42, "7", 19])
```

`'<' not supported between instances of 'str' and 'int'` means two items couldn't be compared. Data from files and `input()` often arrives as strings, so convert first (or use `key=int`, as you'll see in the last challenge).

```python exercise id=leaderboard title="Build a leaderboard"
# TODO: return a list of (name, score) tuples, highest score first.
#   leaderboard({"ana": 120, "ben": 340, "caro": 210})
#     -> [("ben", 340), ("caro", 210), ("ana", 120)]
def leaderboard(scores):
    """Return (name, score) pairs from the dict, sorted by score, highest first."""
    ...

print(leaderboard({"ana": 120, "ben": 340, "caro": 210}))
--- solution
def leaderboard(scores):
    """Return (name, score) pairs from the dict, sorted by score, highest first."""
    return sorted(scores.items(), key=lambda pair: pair[1], reverse=True)

print(leaderboard({"ana": 120, "ben": 340, "caro": 210}))
--- test
got = leaderboard({"ana": 120, "ben": 340, "caro": 210})
assert got is not None, "`leaderboard` gave back `None`. Replace the `...` with a `return` statement."
assert isinstance(got, list), f"`leaderboard` should return a list, but returned {type(got).__name__}. `sorted()` always gives a list."
assert all(isinstance(p, tuple) and len(p) == 2 for p in got), f"Each item should be a (name, score) tuple, but got {got!r}. Try sorting `scores.items()`."
assert got == [("ben", 340), ("caro", 210), ("ana", 120)], f"Expected [('ben', 340), ('caro', 210), ('ana', 120)], but got {got!r}."
fresh = leaderboard({"zed": 5, "yan": 50, "xia": 500, "wil": 0})
assert fresh == [("xia", 500), ("yan", 50), ("zed", 5), ("wil", 0)], f"Sort by the SCORE, not the name: got {fresh!r}."
assert leaderboard({}) == [], "An empty dict should give an empty leaderboard."
--- hint
`scores.items()` gives `(name, score)` pairs. Sort those.
--- hint
Tell `sorted` to compare the second item of each pair with `key=lambda pair: pair[1]`.
--- hint
Highest first means `reverse=True`.
```

## `min()` and `max()` with a `key`

`min` and `max` accept the same `key=` idea. Instead of the smallest *value*, you get the item whose *key* is smallest:

```python run
cities = ["Rome", "Copenhagen", "Oslo", "Amsterdam"]
print("longest name:", max(cities, key=len))

flights = [("Lisbon", 189), ("Madrid", 74), ("Paris", 120)]
cheapest = min(flights, key=lambda flight: flight[1])
print("cheapest:", cheapest)

stock = {"apples": 40, "pears": 3, "plums": 18}
print("running low:", min(stock, key=stock.get))
```

That last line is a neat trick: looping over a dict gives its **keys**, and `stock.get` is a function that turns a key into its value. So `min(stock, key=stock.get)` means "the key with the smallest value."

```python exercise id=cheapest-item title="Find the best deal"
# TODO: return the NAME of the cheapest product.
#   cheapest({"tea": 3.20, "coffee": 4.10, "juice": 2.90}) -> "juice"
def cheapest(prices):
    """Return the name of the product with the lowest price."""
    ...

print(cheapest({"tea": 3.20, "coffee": 4.10, "juice": 2.90}))
--- solution
def cheapest(prices):
    """Return the name of the product with the lowest price."""
    return min(prices, key=prices.get)

print(cheapest({"tea": 3.20, "coffee": 4.10, "juice": 2.90}))
--- test
got = cheapest({"tea": 3.20, "coffee": 4.10, "juice": 2.90})
assert got is not None, "`cheapest` gave back `None`. Replace the `...` with a `return` statement."
assert isinstance(got, str), f"`cheapest` should return the product's name (a string), but returned {got!r}."
assert got == "juice", f"The cheapest product is juice (2.90), but you returned {got!r}."
fresh = {"laptop": 899.0, "mouse": 19.99, "monitor": 149.0, "cable": 25.0}
assert cheapest(fresh) == "mouse", f"For {fresh}, the cheapest is 'mouse', but you returned {cheapest(fresh)!r}. Are you comparing prices, not names?"
assert cheapest({"zebra cake": 1, "apple pie": 9}) == "zebra cake", "Compare the PRICES: alphabetically first isn't the same as cheapest."
--- hint
`min(prices)` alone compares the keys (the names) alphabetically. You need it to compare the prices instead.
--- hint
Give `min` a `key` that turns a name into its price: `prices.get` does exactly that. A lambda like `lambda name: prices[name]` works too.
```

## `enumerate()`: a counter that comes for free

You often need each item **and** its position: numbering a list, reporting which row was bad. Beginners reach for `range(len(...))`, but `enumerate` hands you `(index, item)` pairs directly, and `start=` sets the first number:

```python run
playlist = ["Bohemian Rhapsody", "Hey Jude", "Wonderwall"]

for position, song in enumerate(playlist, start=1):
    print(f"{position}. {song}")

list(enumerate(["a", "b", "c"]))
```

| Instead of… | Write… |
|---|---|
| `for i in range(len(songs)):` then `songs[i]` | `for i, song in enumerate(songs):` |
| a separate `count = 1` … `count += 1` | `enumerate(songs, start=1)` |

Fewer moving parts means fewer off-by-one mistakes, like this one:

```python debug id=numbered-tasks title="The to-do list loses its first task"
def numbered(tasks):
    """Return lines like '1. Buy milk', numbered from 1, one per task."""
    lines = []
    for i in range(1, len(tasks)):
        lines.append(f"{i}. {tasks[i]}")
    return lines

for line in numbered(["Buy milk", "Call grandma", "Pay rent"]):
    print(line)
--- solution
def numbered(tasks):
    """Return lines like '1. Buy milk', numbered from 1, one per task."""
    lines = []
    for i, task in enumerate(tasks, start=1):
        lines.append(f"{i}. {task}")
    return lines

for line in numbered(["Buy milk", "Call grandma", "Pay rent"]):
    print(line)
--- test
got = numbered(["Buy milk", "Call grandma", "Pay rent"])
assert len(got) == 3, f"Three tasks should give three lines, but got {len(got)}: {got!r}. Is a task being skipped?"
assert got == ["1. Buy milk", "2. Call grandma", "3. Pay rent"], f"Expected ['1. Buy milk', '2. Call grandma', '3. Pay rent'], but got {got!r}."
fresh = numbered(["Water plants"])
assert fresh == ["1. Water plants"], f"A one-task list should give ['1. Water plants'], but got {fresh!r}."
assert numbered([]) == [], "No tasks should give no lines."
assert numbered(list("abcd"))[-1] == "4. d", "The last of four tasks should be numbered 4."
--- hint
Run it: "Buy milk" is missing, and the numbers belong to the wrong tasks. The loop starts at index 1, skipping index 0, and the same `i` is used both as the display number and the index.
--- hint
`enumerate(tasks, start=1)` gives you a display number starting at 1 *and* each task, so you don't need to index into the list at all.
```

## `zip()`: walk several lists together

`zip` pairs up items from two (or more) sequences, position by position, like a zipper joining two rows of teeth:

```python run
players = ["Maya", "Tom", "Inès"]
goals = [3, 1, 4]

for player, scored in zip(players, goals):
    print(f"{player} scored {scored}")

dict(zip(players, goals))
```

`dict(zip(keys, values))` is the standard way to build a dictionary from two parallel lists. One thing to know: `zip` **stops at the shortest** input, silently dropping leftovers.

```python predict id=predict-zip-short title="What is displayed?"
list(zip(["Mon", "Tue", "Wed"], [21, 19]))
--- options
[('Mon', 21), ('Tue', 19), ('Wed', None)]
* [('Mon', 21), ('Tue', 19)]
[('Mon', 'Tue', 'Wed'), (21, 19)]
ValueError
--- explain
`zip` makes pairs by position and stops as soon as **either** input runs out. `"Wed"` has no partner, so it's dropped without an error. Make sure your lists line up!
```

```python exercise id=total-cost title="Add up a shopping list"
# TODO: `prices` and `quantities` are parallel lists: prices[0] goes with
# quantities[0], and so on. Return the total cost, rounded to 2 decimals.
#   total_cost([2.50, 1.20], [4, 3]) -> 13.6
def total_cost(prices, quantities):
    """Return the sum of price * quantity for each pair, rounded to 2 decimals."""
    ...

print(total_cost([2.50, 1.20], [4, 3]))
--- solution
def total_cost(prices, quantities):
    """Return the sum of price * quantity for each pair, rounded to 2 decimals."""
    return round(sum(price * qty for price, qty in zip(prices, quantities)), 2)

print(total_cost([2.50, 1.20], [4, 3]))
--- test
got = total_cost([2.50, 1.20], [4, 3])
assert got is not None, "`total_cost` gave back `None`. Replace the `...` with a `return` statement."
assert isinstance(got, (int, float)), f"`total_cost` should return a number, but returned {got!r}."
assert got == 13.6, f"`total_cost([2.50, 1.20], [4, 3])` should be 13.6, but is {got!r}."
assert total_cost([0.99, 5.0, 12.49], [3, 1, 2]) == 32.95, f"Expected 32.95 for three items, but got {total_cost([0.99, 5.0, 12.49], [3, 1, 2])!r}. Is every pair counted?"
assert total_cost([], []) == 0, "An empty shopping list should cost 0."
assert total_cost([1.1], [3]) == 3.3, f"`total_cost([1.1], [3])` should be 3.3 (rounded), but is {total_cost([1.1], [3])!r}."
--- hint
`zip(prices, quantities)` gives you `(price, qty)` pairs to loop over.
--- hint
Multiply each pair and add them up, either with an accumulator loop or `sum(price * qty for price, qty in zip(...))`.
--- hint
Wrap the final total in `round(..., 2)`.
```

## `any()` and `all()`: questions about a whole collection

`any(...)` is `True` if **at least one** item is truthy. `all(...)` is `True` only if **every** item is. Paired with a generator expression (the comprehension-without-brackets from lesson 18), they read almost like English:

```python run
temps = [18, 24, 31, 27]
scores = [72, 88, 95]

print("any heatwave day? ", any(t > 30 for t in temps))
print("all passed?       ", all(s >= 50 for s in scores))
print("any zero stock?   ", any(qty == 0 for qty in [5, 3, 8]))
```

Like `and`/`or`, they **short-circuit**: `any` stops at the first `True`, `all` stops at the first `False`. That's the same idea as the "search with a flag" loops from lesson 12, in one line.

```python predict id=predict-any-all-empty title="What does this print?"
print(any([]), all([]))
--- options
False False
True True
* False True
True False
--- explain
`any([])` asks "is at least one item true?" With no items, no: `False`. `all([])` asks "is there any item that's false?" There isn't, so it's `True`. Mathematicians call this "vacuously true": every item of an empty list passes, because there are none to fail.
```

```python exercise id=password-check title="A password strength check"
# TODO: return True only if the password meets ALL three rules:
#   - at least 8 characters long
#   - contains at least one digit        (str.isdigit helps)
#   - contains at least one uppercase letter (str.isupper helps)
def strong_password(password):
    """Return True if password has 8+ chars, a digit and an uppercase letter."""
    ...

print(strong_password("Sunshine42"), strong_password("password"))
--- solution
def strong_password(password):
    """Return True if password has 8+ chars, a digit and an uppercase letter."""
    long_enough = len(password) >= 8
    has_digit = any(ch.isdigit() for ch in password)
    has_upper = any(ch.isupper() for ch in password)
    return long_enough and has_digit and has_upper

print(strong_password("Sunshine42"), strong_password("password"))
--- test
assert strong_password("Sunshine42") is not None, "`strong_password` gave back `None`. Replace the `...` with a `return` statement."
cases = {
    "Sunshine42": True, "password": False, "Password": False, "password1": False,
    "PASSWORD1": True, "Ab1": False, "Abcdefg1": True, "abcdefg1": False, "12345678X": True, "": False,
}
for pw, expected in cases.items():
    got = strong_password(pw)
    assert got is expected or got == expected, f"`strong_password({pw!r})` should be {expected}, but is {got!r}."
--- hint
Check each rule separately. Length is `len(password) >= 8`.
--- hint
"Contains at least one digit" is `any(ch.isdigit() for ch in password)`. The uppercase rule has the same shape.
--- hint
Combine the three checks with `and` and return the result.
```

## `map()` and `filter()` vs comprehensions

Two older tools apply a function to every item. `map(function, items)` transforms each item; `filter(function, items)` keeps the items where the function returns something truthy. Both hand back a lazy object, so wrap them in `list()` to see the results:

```python run
names = ["ada", "grace", "linus"]
prices = [4.99, 120.0, 15.5, 89.0]

print(list(map(str.title, names)))
print(list(filter(lambda p: p < 50, prices)))

# The same results with comprehensions (lesson 18):
print([name.title() for name in names])
print([p for p in prices if p < 50])
```

| Task | `map` / `filter` | Comprehension |
|---|---|---|
| Apply an existing function | `list(map(str.title, names))` | `[n.title() for n in names]` |
| Keep matching items | `list(filter(lambda p: p < 50, prices))` | `[p for p in prices if p < 50]` |
| Transform *and* filter | `list(map(..., filter(..., ...)))` | `[p * 2 for p in prices if p < 50]` |

Most Python programmers prefer comprehensions: they read left to right and don't need `lambda`. `map` is nice when you already have a named function, like `map(int, ["3", "14", "15"])`. You'll see both in real code, so it's worth recognizing them.

## `reversed()` and `isinstance()`

`reversed(seq)` walks a sequence backwards **without** changing it (unlike `list.reverse()`, which reverses in place). `isinstance(value, type)` asks "is this value of this type?", and accepts a tuple of types for "any of these":

```python run
countdown = [1, 2, 3, 4, 5]
print("launch in:", list(reversed(countdown)), "| original:", countdown)

mixed = [12, "n/a", 7.5, None, 3, "8"]
numbers = [x for x in mixed if isinstance(x, (int, float))]
print("numbers only:", numbers, "sum:", sum(numbers))
```

`isinstance` is how a function checks it got the kind of input it expects, which you'll use when validating data in the next section.

## Debug: sorting numbers that are really text

```python debug id=top-scores-strings title="The top scores are in the wrong order"
def top_scores(raw_scores, n=3):
    """Return the n highest scores, as ints, highest first.
    The scores arrive as strings, e.g. from a file."""
    ordered = sorted(raw_scores, reverse=True)
    return [int(s) for s in ordered[:n]]

print(top_scores(["85", "9", "100", "42", "77"]))
--- solution
def top_scores(raw_scores, n=3):
    """Return the n highest scores, as ints, highest first.
    The scores arrive as strings, e.g. from a file."""
    ordered = sorted(raw_scores, key=int, reverse=True)
    return [int(s) for s in ordered[:n]]

print(top_scores(["85", "9", "100", "42", "77"]))
--- test
got = top_scores(["85", "9", "100", "42", "77"])
assert got == [100, 85, 77], f"The top three of 85, 9, 100, 42, 77 are [100, 85, 77], but got {got!r}."
fresh = top_scores(["3", "20", "1000", "500", "6"], n=2)
assert fresh == [1000, 500], f"`top_scores(['3', '20', '1000', '500', '6'], n=2)` should be [1000, 500], but got {fresh!r}."
assert top_scores(["7", "70", "700"], n=5) == [700, 70, 7], "Asking for more scores than exist should return them all, highest first."
--- hint
Run it: 9 comes out on top. Strings compare **character by character**, and `"9"` beats `"1"` (the start of `"100"`) just like "z" beats "a".
--- hint
Tell `sorted` to compare the scores as numbers. Which built-in turns `"100"` into `100`? It can be the `key`.
```

> **Pitfall:** Text that looks like numbers sorts alphabetically: `"10" < "9"` is `True`. Whenever numbers come from a file, a form or `input()`, convert them (or sort with `key=int` / `key=float`) before comparing.

## Recap

- `sorted(items, key=..., reverse=...)` and `min`/`max(items, key=...)` compare items by whatever the `key` function returns; you pass the function itself (`key=len`), not a call.
- `lambda params: expression` is a tiny unnamed function, perfect for one-off keys like `key=lambda pair: pair[1]`. Use `def` for anything bigger.
- `enumerate(items, start=1)` gives `(number, item)` pairs and replaces error-prone `range(len(...))` loops; `zip(a, b)` walks lists side by side (stopping at the shortest), and `dict(zip(keys, values))` builds a dict.
- `any(...)` and `all(...)` answer "at least one?" and "every one?" in a single line.
- `map`/`filter` exist, but comprehensions usually read better; `reversed()` walks backwards without changing the original; `isinstance(x, (int, float))` checks types.

**Up next:** errors and exceptions: reading tracebacks like a pro, catching problems with `try` and `except`, and raising your own errors when a function gets bad input.
