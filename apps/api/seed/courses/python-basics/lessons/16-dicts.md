Lists are great when position matters: the first song, the third runner, the last item in the cart. But most questions you ask about data aren't about position. *What's Maya's phone number? How much does a latte cost? How many times did the word "storm" appear?* With a list you'd have to scan every item until you found the right one. With a **dictionary** you just ask for it by name.

Dictionaries are everywhere in real Python. Settings files, web API responses, database rows, word counts, shopping carts: they're all dictionaries under the hood. By the end of this lesson you'll be able to build them, look things up safely, count and group data with them, and read nested, JSON-shaped records like a pro.

## Key → value: a lookup table

Think of a real phone book. You don't look up "entry number 4,213"; you look up a **name** and get back a **number**. A Python dictionary (`dict`) works the same way: it stores pairs of a **key** and a **value**, and you use the key to find the value.

```python run
prices = {"espresso": 2.5, "latte": 3.8, "mocha": 4.2}

print("A latte costs", prices["latte"])
prices
```

Curly braces `{}` make a dictionary. Inside, each entry is written `key: value`, and entries are separated by commas. To read a value, put the key in square brackets, the same brackets you used for list positions, but with a key instead of a number.

```text
prices
 ┌────────────┬───────┐
 │ "espresso" │  2.5  │      prices["latte"]  →  3.8
 │ "latte"    │  3.8  │
 │ "mocha"    │  4.2  │      key goes in, value comes out
 └────────────┴───────┘
   keys         values
```

Keys are usually strings, but numbers and tuples work too. Values can be anything at all: numbers, strings, lists, even other dictionaries.

```python run
player = {
    "name": "Ana",
    "team": "Lisbon Lions",
    "jersey": 7,
    "goals": [2, 0, 1, 3],     # a list as a value
}
empty = {}

print(player["name"], "has scored", sum(player["goals"]), "goals")
print("entries in player:", len(player))
print("entries in empty:", len(empty))
```

`len()` counts **pairs**, not keys and values separately. Writing one pair per line, with a trailing comma after the last one, is how professionals format longer dictionaries: it's easy to read and easy to extend.

> **Coming from Excel/another language:** a dictionary is like a two-column lookup table where `VLOOKUP` is instant. In JavaScript it's an object, in Java a `HashMap`, in PHP an associative array.

## Missing keys: KeyError and `.get()`

Ask for a key that isn't there, and Python stops with a `KeyError`. Run this one; it fails on purpose:

```python run error
prices = {"espresso": 2.5, "latte": 3.8, "mocha": 4.2}

print(prices["cappuccino"])
```

Read the last line of the error: `KeyError: 'cappuccino'`. The message is simply the key that wasn't found. When you see it, check for typos, capital letters (`"Latte"` and `"latte"` are different keys) and whether the entry was ever added.

When a key might legitimately be missing, use the `.get()` method instead. It returns `None` if the key is missing, or a **default** that you choose:

```python run
prices = {"espresso": 2.5, "latte": 3.8, "mocha": 4.2}

print(prices.get("latte"))
print(prices.get("cappuccino"))          # None: no crash
print(prices.get("cappuccino", 0.0))     # your chosen default
```

| Expression | Key exists | Key missing |
|---|---|---|
| `d[key]` | the value | **KeyError** |
| `d.get(key)` | the value | `None` |
| `d.get(key, default)` | the value | `default` |

> **Tip:** Use `d[key]` when the key *must* be there; a crash then points straight at the bug. Use `.get(key, default)` when missing is normal, like a product with no discount.

```python predict id=predict-get-default title="What does .get() return?"
stock = {"apples": 3, "bananas": 0}
print(stock.get("pears"), stock.get("pears", 0), stock.get("bananas", 10))
--- options
* None 0 0
0 0 10
None 0 10
KeyError: 'pears'
--- explain
`.get()` never raises. With no default, a missing key gives `None`. With a default, a missing key gives the default. But `"bananas"` **does** exist (its value just happens to be 0), so `.get("bananas", 10)` returns the real value, `0`. The default is only used when the key is missing.
```

## Adding, changing and removing entries

Dictionaries are mutable, like lists. Assigning to a key **adds** it if it's new, or **replaces** its value if it already exists. There's no separate "add" method.

```python run
cart = {"milk": 1, "bread": 1}

cart["eggs"] = 12          # new key: added
cart["milk"] = 2           # existing key: replaced
cart["bread"] += 1         # read, add 1, store back

print(cart)
```

To remove entries, use `del` when you just want the entry gone, or `.pop()` when you also want its value back:

```python run
cart = {"milk": 2, "bread": 2, "eggs": 12, "candy": 3}

del cart["candy"]                  # gone
eggs = cart.pop("eggs")            # gone, and you get the value
nothing = cart.pop("coffee", 0)    # missing key + default: no crash

print("removed eggs:", eggs)
print("cart now:", cart)
print("coffee popped:", nothing)
```

Notice that the dictionary printed in the order you added the keys. Since Python 3.7, dictionaries **remember insertion order**, so printing and looping always follow the order entries were added.

```python exercise id=cafe-stock title="Update the café's stock"
stock = {"croissant": 12, "muffin": 8, "bagel": 5, "scone": 4}

# TODO 1: 3 muffins were sold. Lower the "muffin" count by 3.
# TODO 2: a delivery brought 6 bagels. Raise the "bagel" count by 6.
# TODO 3: the café now sells cookies. Add "cookie" with a count of 20.
# TODO 4: scones are discontinued. Remove "scone" with .pop()
#         and store how many were left in `removed`.
removed = ...

print(stock)
print("scones removed:", removed)
--- solution
stock = {"croissant": 12, "muffin": 8, "bagel": 5, "scone": 4}

stock["muffin"] -= 3
stock["bagel"] += 6
stock["cookie"] = 20
removed = stock.pop("scone")

print(stock)
print("scones removed:", removed)
--- test
assert isinstance(stock, dict), "`stock` should still be a dictionary."
assert stock.get("muffin") != 8, "The muffin count is still 8. Subtract the 3 that were sold: `stock[\"muffin\"] -= 3`."
assert stock.get("muffin") == 5, f"`stock[\"muffin\"]` should be 8 - 3 = 5, but it is {stock.get('muffin')!r}."
assert stock.get("bagel") == 11, f"`stock[\"bagel\"]` should be 5 + 6 = 11, but it is {stock.get('bagel')!r}."
assert "cookie" in stock, "Add a `\"cookie\"` key to `stock`."
assert stock["cookie"] == 20, f"`stock[\"cookie\"]` should be 20, but it is {stock['cookie']!r}."
assert removed is not ..., "Replace the `...` after `removed =` with `stock.pop(...)`."
assert "scone" not in stock, "`\"scone\"` is still in `stock`. Use `.pop()` to remove it."
assert removed == 4, f"`removed` should hold the number of scones that were left (4), but it is {removed!r}."
assert stock == {"croissant": 12, "muffin": 5, "bagel": 11, "cookie": 20}, f"`stock` should end up as croissant 12, muffin 5, bagel 11, cookie 20, but it is {stock}."
--- hint
Assigning to a key adds it or replaces it, and `+=` / `-=` work on dictionary entries just like on variables.
--- hint
`stock["muffin"] -= 3` handles TODO 1. For TODO 4, `.pop(key)` removes the key AND returns its value.
```

## `in` checks keys, not values

`in` asks "is this a **key** in the dictionary?" It does not look at values. To search values, ask the dictionary for them explicitly with `.values()`:

```python run
ages = {"Mia": 31, "Leo": 28}

print("'Mia' in ages:         ", "Mia" in ages)
print("31 in ages:            ", 31 in ages)            # 31 is a value, not a key
print("31 in ages.values():   ", 31 in ages.values())
```

This is the classic way to avoid a KeyError: check first, then read.

```python run
prices = {"espresso": 2.5, "latte": 3.8, "mocha": 4.2}
order = "chai"

if order in prices:
    print(order, "costs", prices[order])
else:
    print("Sorry, we don't sell", order)
```

## Looping over a dictionary

A `for` loop over a dictionary gives you its **keys**. There are three views you can loop over, depending on what you need:

| You write | Each loop gives you |
|---|---|
| `for k in d:` or `for k in d.keys():` | a key |
| `for v in d.values():` | a value |
| `for k, v in d.items():` | a `(key, value)` tuple, unpacked into two names |

`.items()` is the one you'll use most. It's the tuple unpacking you learned in the last lesson, applied to each pair:

```python run
temps = {"Lisbon": 24, "Oslo": 9, "Cairo": 35, "Lima": 19}

for city, temp in temps.items():
    print(f"{city:<8}{temp:>4} °C")

print("hottest reading:", max(temps.values()))
print("cities:", list(temps.keys()))
```

`sum()`, `max()`, `min()` and `sorted()` all work on `.values()` and `.keys()`, and `list(...)` turns them into a regular list when you need one.

```python exercise id=cart-total title="Ring up the shopping cart"
prices = {"apples": 0.5, "bread": 2.25, "milk": 1.2, "eggs": 3.0}
cart = {"apples": 6, "milk": 2, "eggs": 1}     # item -> quantity

# TODO: loop over cart.items(). For each item:
#   - look up its price in `prices`
#   - print a line with the item name and its cost, e.g. "apples: $3.00"
#   - add price * quantity to `total`
total = 0
...

print(f"Total: ${total:.2f}")
--- solution
prices = {"apples": 0.5, "bread": 2.25, "milk": 1.2, "eggs": 3.0}
cart = {"apples": 6, "milk": 2, "eggs": 1}

total = 0
for item, quantity in cart.items():
    cost = prices[item] * quantity
    print(f"{item}: ${cost:.2f}")
    total += cost

print(f"Total: ${total:.2f}")
--- test
assert prices == {"apples": 0.5, "bread": 2.25, "milk": 1.2, "eggs": 3.0}, "Don't change `prices`; just read from it."
assert cart == {"apples": 6, "milk": 2, "eggs": 1}, "Don't change `cart`; just loop over it."
expected = 0
for _item, _qty in cart.items():
    expected += prices[_item] * _qty
assert isinstance(total, (int, float)), f"`total` should be a number, but it is {total!r}."
assert total != 0, "`total` is still 0. Replace the `...` with a loop over `cart.items()` that adds to `total`."
assert abs(total - expected) < 0.001, f"`total` should be {expected:.2f}, but it is {total}. Did you multiply each price by its quantity?"
_lines = _stdout.lower()
for _item in cart:
    assert _item in _lines, f"Print a line for each item in the cart. `{_item}` is missing."
assert "bread" not in _lines, "Bread isn't in the cart, so it shouldn't appear on the receipt."
--- hint
`for item, quantity in cart.items():` gives you each name and its quantity. The price is in the *other* dictionary.
--- hint
Inside the loop: `cost = prices[item] * quantity`, print it, then `total += cost`.
```

## Counting with a dictionary

One of the most useful dictionary patterns: **counting** how often each thing appears. The key is the thing, the value is its count so far. For each item, read the current count (0 if it's new), add 1, and store it back.

```python run
text = "the storm hit the coast and the storm passed"

counts = {}
for word in text.split():
    counts[word] = counts.get(word, 0) + 1

print(counts)
print("'storm' appears", counts["storm"], "times")
```

`counts.get(word, 0)` is doing the heavy lifting: the first time a word is seen, there's no key yet, so it returns `0` instead of crashing.

> **In the wild:** word counts, votes, page views per URL, errors per server: counting with a dictionary is something professionals write constantly. Python even ships a ready-made counting dictionary, `collections.Counter`, which you'll meet in lesson 25.

```python debug id=vote-tally title="Counting the votes crashes"
votes = ["pizza", "tacos", "pizza", "sushi", "tacos", "pizza"]

tally = {}
for food in votes:
    tally[food] += 1

print(tally)
--- solution
votes = ["pizza", "tacos", "pizza", "sushi", "tacos", "pizza"]

tally = {}
for food in votes:
    tally[food] = tally.get(food, 0) + 1

print(tally)
--- test
assert isinstance(tally, dict), "`tally` should be a dictionary."
assert tally, "`tally` is empty. Each vote should add 1 to its food's count."
expected = {}
for _v in votes:
    expected[_v] = expected.get(_v, 0) + 1
assert tally == expected, f"`tally` should be {expected}, but it is {tally}."
--- hint
Run it and read the last line of the error: `KeyError: 'pizza'`. What does `tally["pizza"]` hold before the first pizza vote is counted?
--- hint
`tally[food] += 1` has to *read* the old count first, and for a new food there isn't one. `tally.get(food, 0)` reads with a fallback.
```

## Grouping: lists as values

Counting answers "how many?". **Grouping** answers "which ones?". The value for each key is a list that you append to. The only extra step: the first time you see a key, give it an empty list.

```python run
tasks = [("email Sam", "high"), ("water plants", "low"),
         ("pay rent", "high"), ("tidy desk", "low"), ("book dentist", "medium")]

by_priority = {}
for task, priority in tasks:
    if priority not in by_priority:
        by_priority[priority] = []          # first time: start an empty list
    by_priority[priority].append(task)      # then add to it

for priority, items in by_priority.items():
    print(f"{priority:>6}: {items}")
```

`by_priority[priority]` gives you the **actual list** stored in the dictionary, so `.append()` changes it in place. You don't need to assign it back.

```python exercise id=group-songs title="Group the playlist by genre"
songs = [
    ("Blinding Lights", "pop"),
    ("Bohemian Rhapsody", "rock"),
    ("Levitating", "pop"),
    ("Take Five", "jazz"),
    ("Hotel California", "rock"),
    ("So What", "jazz"),
]

# TODO: build `by_genre` so each genre maps to a list of its song titles,
# in playlist order, e.g. by_genre["pop"] == ["Blinding Lights", "Levitating"]
by_genre = {}
for title, genre in songs:
    ...

print(by_genre)
--- solution
songs = [
    ("Blinding Lights", "pop"),
    ("Bohemian Rhapsody", "rock"),
    ("Levitating", "pop"),
    ("Take Five", "jazz"),
    ("Hotel California", "rock"),
    ("So What", "jazz"),
]

by_genre = {}
for title, genre in songs:
    if genre not in by_genre:
        by_genre[genre] = []
    by_genre[genre].append(title)

print(by_genre)
--- test
assert isinstance(by_genre, dict), "`by_genre` should be a dictionary."
assert by_genre, "`by_genre` is still empty. Inside the loop, add each title to its genre's list."
expected = {}
for _t, _g in songs:
    expected.setdefault(_g, []).append(_t)
assert set(by_genre) == set(expected), f"`by_genre` should have the keys {sorted(expected)}, but has {sorted(by_genre)}."
for _g, _titles in expected.items():
    assert isinstance(by_genre[_g], list), f"`by_genre[{_g!r}]` should be a list of titles, but it is {by_genre[_g]!r}."
    assert by_genre[_g] == _titles, f"`by_genre[{_g!r}]` should be {_titles}, but it is {by_genre[_g]}. Is a new list being created every time?"
--- hint
Each genre needs its own list. Only create that empty list when the genre isn't a key yet.
--- hint
`if genre not in by_genre: by_genre[genre] = []`, then `by_genre[genre].append(...)` on its own line.
```

> **Tip:** Writing `by_genre[genre] = [title]` on every song looks tempting, but it **replaces** the list each time, so only the last title per genre survives. Create the list once, then append.

## Nested dictionaries: JSON-shaped data

Values can be lists and dictionaries, which can hold more lists and dictionaries. That lets one variable describe a whole real-world record. You reach inside by chaining brackets, one level at a time, reading left to right:

```python run
user = {
    "name": "Priya",
    "address": {"city": "Toronto", "postcode": "M5V 2T6"},
    "orders": [
        {"id": 1001, "total": 42.50},
        {"id": 1002, "total": 17.25},
    ],
}

print(user["address"]["city"])          # dict → dict → value
print(user["orders"][1]["total"])       # dict → list → dict → value

spent = 0
for order in user["orders"]:
    spent += order["total"]
print("lifetime spend:", spent)
```

Read `user["orders"][1]["total"]` step by step: `user["orders"]` is a list; `[1]` is its second item, a dictionary; `["total"]` is a value inside that.

> **In the wild:** this is exactly the shape of **JSON**, the format nearly every web API speaks. Ask a weather service or a payment provider for data, and you get back nested dictionaries and lists like this one. You'll load real JSON files in lesson 24.

```python predict id=predict-nested title="Reach inside the record"
trip = {"city": "Rome", "days": [{"weather": "sun", "high": 29}, {"weather": "rain", "high": 22}]}
print(len(trip), len(trip["days"]), trip["days"][-1]["weather"])
--- options
3 2 rain
* 2 2 rain
2 2 sun
2 4 rain
--- explain
`trip` has two keys, `"city"` and `"days"`, so `len(trip)` is 2, no matter how much data is nested inside. `trip["days"]` is a list of two dictionaries, and `[-1]` picks the last one, whose `"weather"` is `"rain"`.
```

```python exercise id=hottest-day title="Find the hottest day in the forecast"
forecast = {
    "city": "Seville",
    "days": [
        {"day": "Mon", "high": 31},
        {"day": "Tue", "high": 36},
        {"day": "Wed", "high": 34},
        {"day": "Thu", "high": 29},
    ],
}

# TODO: loop over forecast["days"] and find the day with the highest "high".
# Set `hottest_day` to its name (e.g. "Mon") and `hottest_temp` to its high.
hottest_day = ...
hottest_temp = ...

print(f"Hottest in {forecast['city']}: {hottest_day} at {hottest_temp} °C")
--- solution
forecast = {
    "city": "Seville",
    "days": [
        {"day": "Mon", "high": 31},
        {"day": "Tue", "high": 36},
        {"day": "Wed", "high": 34},
        {"day": "Thu", "high": 29},
    ],
}

hottest_day = forecast["days"][0]["day"]
hottest_temp = forecast["days"][0]["high"]
for day in forecast["days"]:
    if day["high"] > hottest_temp:
        hottest_temp = day["high"]
        hottest_day = day["day"]

print(f"Hottest in {forecast['city']}: {hottest_day} at {hottest_temp} °C")
--- test
assert hottest_day is not ..., "Replace the `...` after `hottest_day =` with your code."
assert hottest_temp is not ..., "Replace the `...` after `hottest_temp =` with your code."
_best = forecast["days"][0]
for _d in forecast["days"]:
    if _d["high"] > _best["high"]:
        _best = _d
assert isinstance(hottest_day, str), f"`hottest_day` should be the day's name, like \"Mon\", but it is {hottest_day!r}."
assert hottest_temp == _best["high"], f"`hottest_temp` should be the highest \"high\" ({_best['high']}), but it is {hottest_temp!r}."
assert hottest_day == _best["day"], f"`hottest_day` should be {_best['day']!r} (the day with that high), but it is {hottest_day!r}."
--- hint
This is the "find the maximum" loop pattern from lesson 12: start with the first day as the best so far, then replace it whenever a hotter day comes along.
--- hint
Each item in `forecast["days"]` is a dictionary, so inside `for day in forecast["days"]:` you can read `day["high"]` and `day["day"]`.
```

## The rules for keys

Two rules keep dictionaries fast and predictable.

**1. Keys are unique.** Assigning to an existing key replaces its value, and that applies even when you type a key twice in the same literal: the last one wins.

**2. Keys must be immutable.** Strings, numbers and tuples can be keys. Lists and dictionaries can't, because they could change after being filed away, and the dictionary would lose track of them.

```python run error
seats = {["row A", 3]: "Maya"}
```

`TypeError: unhashable type: 'list'` is Python's way of saying "this can't be a key". ("Hashable" roughly means "safe to file away because it never changes".) The fix is usually a tuple, which is perfect for things like grid coordinates:

```python run
seats = {("A", 3): "Maya", ("A", 4): "Jon", ("B", 1): "Ines"}

print("A3 is booked by", seats[("A", 3)])
print("Is B2 taken?", ("B", 2) in seats)
```

> **Under the hood:** a dictionary turns each key into a number called a **hash** and uses it to jump almost directly to the right slot, like a coat check ticket. That's why lookups stay fast even with millions of entries, and why a key must never change: its ticket number would no longer match.

```python predict id=predict-duplicate-keys title="The same key twice"
scores = {"Ana": 10, "Ben": 7, "Ana": 15}
print(len(scores), scores["Ana"])
--- options
3 10
3 15
2 10
* 2 15
--- explain
Keys are unique, so `"Ana"` can only appear once. When a key is repeated in a literal, the later value replaces the earlier one, just as `scores["Ana"] = 15` would. That leaves two entries, and Ana's value is 15.
```

## Merging dictionaries: `.update()` and `|`

Often you have **defaults** and want to layer someone's **choices** on top. `.update()` changes a dictionary in place; the `|` operator builds a brand-new merged dictionary. In both, when a key appears on both sides, the **right-hand side wins**.

```python run
defaults = {"theme": "light", "font_size": 14, "notifications": True}
choices = {"theme": "dark", "language": "pt"}

settings = defaults | choices         # new dict; defaults is untouched
print("settings:", settings)
print("defaults:", defaults)

defaults.update({"font_size": 16})    # changes defaults itself
print("updated defaults:", defaults)
```

- Want a **new** merged dictionary? `merged = a | b`
- Want to change `a` **in place**? `a.update(b)` (or the shorthand `a |= b`)
- Want a plain **copy**? `a.copy()` or `dict(a)`

> **Pitfall:** just like lists, `b = a` doesn't copy a dictionary. It gives the same dictionary a second name, so changing one "changes" both. Use `a.copy()` when you need an independent dictionary.

## Debug challenge: the number that's "free" but isn't

```python debug id=jersey-check title="Taken jersey numbers show up as available"
# Each player's name maps to their jersey number.
roster = {"Ana": 7, "Ben": 10, "Chloe": 23}

# New players asked for these numbers. Which ones are still free?
requested = [7, 12, 10, 99]
available = []
for number in requested:
    if number in roster:
        print(number, "is taken")
    else:
        available.append(number)

print("available:", available)
--- solution
roster = {"Ana": 7, "Ben": 10, "Chloe": 23}

requested = [7, 12, 10, 99]
available = []
for number in requested:
    if number in roster.values():
        print(number, "is taken")
    else:
        available.append(number)

print("available:", available)
--- test
assert isinstance(available, list), "`available` should be a list."
_taken = set(roster.values())
_expected = [n for n in requested if n not in _taken]
assert 7 not in available, "7 is Ana's number, but it's still listed as available."
assert available == _expected, f"`available` should be {_expected}, but it is {available}."
--- hint
Run it: every number comes out available, even 7. What does `in` look at when you use it on a dictionary?
--- hint
`number in roster` checks the **keys** (the names). The jersey numbers are the values, which you can get with `roster.values()`.
```

## Recap

- A dictionary maps unique, immutable **keys** to **values**: `d = {"latte": 3.8}`, read with `d["latte"]`.
- A missing key raises `KeyError`; `.get(key, default)` reads safely, and `key in d` checks first.
- Assign to add or replace (`d[k] = v`); remove with `del d[k]` or `d.pop(k)`. Dictionaries keep insertion order.
- `in` and plain `for` loops see **keys**; use `.values()` and `.items()` for the rest.
- Count with `d[k] = d.get(k, 0) + 1`; group by appending to a list stored under each key.
- Nested dictionaries and lists describe JSON-shaped records; merge dictionaries with `|` or `.update()` (right side wins).

**Up next:** sets, Python's collection for uniqueness and lightning-fast membership checks.
