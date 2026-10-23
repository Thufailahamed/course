You're sending wedding invitations, and three relatives each gave you their list. Some guests appear twice, a few appear on all three lists. How many *different* people are invited? Which friends do you and your partner have in common? Which tags does this blog post share with that one?

These are all questions about **uniqueness** and **overlap**, and Python has a collection built exactly for them: the **set**. A set holds each value at most once, can tell you in an instant whether something is inside it, and does Venn-diagram math (in common, combined, difference) with a single operator. By the end of this lesson you'll be using sets to clean up duplicates and compare groups in one line.

## A set keeps one of each

Turn a list into a set with `set(...)`, and every duplicate disappears:

```python run
rsvps = ["maya@mail.com", "leo@mail.com", "maya@mail.com",
         "ines@mail.com", "leo@mail.com", "maya@mail.com"]

guests = set(rsvps)

print("replies received:", len(rsvps))
print("different guests:", len(guests))
guests
```

Six replies, but only three different people. Notice the curly braces in the output: you can also write a set directly with `{...}`, just like a dictionary but with **values only**, no `key: value` pairs.

```python run
primes = {2, 3, 5, 7, 7, 7}          # duplicates in a literal are dropped too
letters = set("mississippi")         # any iterable works: here, a string

print("primes:", primes, "len", len(primes))
print("letters:", sorted(letters))   # sorted() gives you a tidy list
```

`set("mississippi")` loops over the string and keeps each letter once. Because sets have no reliable order, `sorted()` is the usual way to display one neatly. It returns a regular, sorted **list**.

> **Pitfall:** the order you see when you print a set is an accident of how Python stores it, not the order you added things. It can even change between runs of the same program. If order matters, sort the set or keep a list.

```python predict id=predict-set-len title="How many are left?"
print(len({3, 1, 3, 2, 1}), len(set("hello")))
--- options
5 5
3 5
* 3 4
3 3
--- explain
`{3, 1, 3, 2, 1}` keeps one 1, one 2 and one 3, so its length is 3. `set("hello")` keeps each letter once: `h`, `e`, `l`, `o`. The second `l` is a duplicate, so that's 4.
```

## The empty set trap: `set()` vs `{}`

Here's a quirk you need to know. Curly braces were used for dictionaries first, so an empty `{}` is an empty **dictionary**, not an empty set. To make an empty set, call `set()`.

```python run
print("{}     →", type({}))
print("set()  →", type(set()))
print("{1, 2} →", type({1, 2}))
```

| You write | You get |
|---|---|
| `{}` | an empty **dict** |
| `set()` | an empty **set** |
| `{"a", "b"}` | a set with two items |
| `{"a": 1}` | a dict with one key |

## Adding and removing items

Sets are mutable. `.add()` puts one item in (adding something that's already there quietly does nothing). For removing, you get a choice:

```python run
tags = {"travel", "food"}

tags.add("photography")
tags.add("food")               # already there: no change, no error
tags.discard("budget")         # not there: discard doesn't mind
tags.remove("travel")          # there: removed

print(sorted(tags))
```

The difference between `remove` and `discard` only shows when the item is missing:

```python run error
tags = {"food", "photography"}
tags.remove("budget")
```

`remove()` raises `KeyError` for a missing item, just like reading a missing dictionary key. Use `discard()` when "already gone" is fine, and `remove()` when a missing item would mean a bug you want to hear about.

```python predict id=predict-add-discard title="Add, add again, discard"
nums = {1, 2}
nums.add(2)
nums.add(3)
nums.discard(5)
print(len(nums), 2 in nums)
--- options
4 True
* 3 True
3 False
KeyError: 5
--- explain
Adding `2` again changes nothing, because it is already in the set. Adding `3` makes three items. `discard(5)` quietly does nothing when 5 is missing (it is `remove()` that would raise `KeyError`). So the set is `{1, 2, 3}`: length 3, and 2 is in it.
```

```python debug id=hashtag-set title="Collecting hashtags crashes with AttributeError"
posts = [
    "Morning run done #fitness #running",
    "New recipe tonight #cooking",
    "Long weekend #running #hiking #fitness",
]

# Collect every different hashtag used in the posts.
hashtags = {}
for post in posts:
    for word in post.split():
        if word.startswith("#"):
            hashtags.add(word)

print(sorted(hashtags))
--- solution
posts = [
    "Morning run done #fitness #running",
    "New recipe tonight #cooking",
    "Long weekend #running #hiking #fitness",
]

hashtags = set()
for post in posts:
    for word in post.split():
        if word.startswith("#"):
            hashtags.add(word)

print(sorted(hashtags))
--- test
assert isinstance(hashtags, set), f"`hashtags` should be a set, but it is a {type(hashtags).__name__}."
_expected = {w for p in posts for w in p.split() if w.startswith("#")}
assert hashtags == _expected, f"`hashtags` should be {sorted(_expected)}, but it is {sorted(hashtags)}."
--- hint
Run it and read the error: `'dict' object has no attribute 'add'`. Why is `hashtags` a dict?
--- hint
`{}` makes an empty dictionary. An empty set needs a different spelling.
```

## Membership: sets answer `in` instantly

`x in some_list` checks items one by one from the start, so the longer the list, the slower it gets. A set works like the coat check from the dictionary lesson: it computes a **hash** of the value and jumps almost straight to where it would be. The size of the set barely matters.

Here's a rough race. (`time` is a standard-library module, imported like `math`; you'll tour these modules in lesson 25.)

```python run
import time

ids_list = list(range(20_000))
ids_set = set(ids_list)
target = 19_999                  # near the end: the list has to check everything

start = time.perf_counter()
for attempt in range(100):
    found = target in ids_list
list_ms = (time.perf_counter() - start) * 1000

start = time.perf_counter()
for attempt in range(100):
    found = target in ids_set
set_ms = (time.perf_counter() - start) * 1000

print(f"100 lookups in a list: {list_ms:.2f} ms")
print(f"100 lookups in a set:  {set_ms:.2f} ms")
```

The exact numbers depend on your computer, but the set is dramatically faster, and the gap grows as the data grows.

> **In the wild:** whenever code checks "have I seen this before?" (blocked usernames, visited web pages, already-processed order IDs), professionals reach for a set. A check that takes seconds with a list of a million items is effectively instant with a set.

The hashing trick comes with the same rule as dictionary keys: **set items must be immutable.** Numbers, strings and tuples are fine; trying to put a list in a set raises `TypeError: unhashable type: 'list'`.

## Sets have no positions

Because a set has no order, it has no index either. There's no "first item" to ask for:

```python run error
finishers = {"Kenji", "Amara", "Lucas"}
print(finishers[0])
```

`'set' object is not subscriptable` means "this kind of value doesn't support `[...]`". If you need positions, convert with `sorted(...)` or `list(...)` first. You can still loop over a set with `for` and check `len()` and `in`; you just can't rely on the order.

```python exercise id=passport-stamps title="Count the countries you've visited"
stamps = ["Japan", "Peru", "Japan", "Kenya", "Peru", "Japan", "Iceland", "Kenya"]

# TODO: `countries` should be a set of the different countries in `stamps`
countries = ...

# TODO: `country_count` should be how many different countries there are
country_count = ...

# TODO: `alphabetical` should be a list of those countries, A to Z
alphabetical = ...

print(country_count, "countries:", alphabetical)
--- solution
stamps = ["Japan", "Peru", "Japan", "Kenya", "Peru", "Japan", "Iceland", "Kenya"]

countries = set(stamps)
country_count = len(countries)
alphabetical = sorted(countries)

print(country_count, "countries:", alphabetical)
--- test
assert countries is not ..., "Replace the `...` after `countries =` with a set built from `stamps`."
assert isinstance(countries, set), f"`countries` should be a set, but it is a {type(countries).__name__}."
assert countries == set(stamps), f"`countries` should contain each country in `stamps` once, but it is {countries}."
assert country_count is not ..., "Replace the `...` after `country_count =`."
assert country_count == len(set(stamps)), f"`country_count` should be {len(set(stamps))}, but it is {country_count!r}. Count the set, not the list."
assert alphabetical is not ..., "Replace the `...` after `alphabetical =`."
assert isinstance(alphabetical, list), f"`alphabetical` should be a list, but it is a {type(alphabetical).__name__}. `sorted()` returns a list."
assert alphabetical == sorted(set(stamps)), f"`alphabetical` should be {sorted(set(stamps))}, but it is {alphabetical}."
--- hint
`set(...)` drops duplicates, and `len()` works on sets.
--- hint
`sorted(countries)` returns a new list in alphabetical order.
```

## Set math: union, intersection, difference

This is where sets shine. Picture two overlapping circles, your friends and your partner's friends:

```text
        yours                 theirs
     ┌───────────┬─────────┬───────────┐
     │  Ana  Ben │  Chloe  │ Farah Gus │
     │           │   Dev   │           │
     └───────────┴─────────┴───────────┘
       yours - theirs  yours & theirs  theirs - yours
```

Each region is one operator away:

```python run
yours = {"Ana", "Ben", "Chloe", "Dev"}
theirs = {"Chloe", "Dev", "Farah", "Gus"}

print("in common (&):     ", sorted(yours & theirs))
print("everyone (|):      ", sorted(yours | theirs))
print("only yours (-):    ", sorted(yours - theirs))
print("only theirs (-):   ", sorted(theirs - yours))
print("not shared (^):    ", sorted(yours ^ theirs))
```

| Operator | Method | Meaning | Question it answers |
|---|---|---|---|
| `a \| b` | `a.union(b)` | in a, b, or both | "Who's invited at all?" |
| `a & b` | `a.intersection(b)` | in both | "Which friends do we share?" |
| `a - b` | `a.difference(b)` | in a but not b | "What do I still need to buy?" |
| `a ^ b` | `a.symmetric_difference(b)` | in exactly one | "What's different between the lists?" |
| `a <= b` | `a.issubset(b)` | everything in a is also in b | "Do I have all the ingredients?" |

Order matters for `-` (like ordinary subtraction) but not for `|`, `&` or `^`. The method versions are handy because they accept **any** iterable, such as a plain list:

```python run
recipe = {"flour", "eggs", "milk", "sugar", "butter"}
pantry = ["flour", "sugar", "salt", "rice", "eggs"]          # a list

shopping = recipe.difference(pantry)
print("buy:", sorted(shopping))
print("can bake already?", recipe.issubset(pantry))
print("can bake after shopping?", recipe <= set(pantry) | shopping)
```

```python predict id=predict-set-ops title="Which region is which?"
a = {1, 2, 3, 4}
b = {3, 4, 5}
print(sorted(a - b), sorted(b - a), sorted(a ^ b))
--- options
[1, 2] [1, 2] [1, 2, 5]
* [1, 2] [5] [1, 2, 5]
[1, 2] [5] [3, 4]
[1, 2, 5] [5] [1, 2]
--- explain
`a - b` keeps what's in `a` but not in `b`: `[1, 2]`. Subtraction isn't symmetric, so `b - a` is just `[5]`. `a ^ b` keeps what's in exactly one of them, which is both differences combined: `[1, 2, 5]`. (`[3, 4]` would be `a & b`.)
```

```python exercise id=club-members title="Compare the club rosters"
chess = {"Ana", "Ben", "Chloe", "Dev", "Eli"}
drama = {"Chloe", "Eli", "Farah", "Gus"}

# TODO: use set operators (or methods) to fill in each one.
both = ...           # students in BOTH clubs
chess_only = ...     # students in chess but NOT in drama
everyone = ...       # students in at least one club
one_club_only = ...  # students in exactly one club

print("both:", both)
print("chess only:", chess_only)
print("everyone:", everyone)
print("exactly one club:", one_club_only)
--- solution
chess = {"Ana", "Ben", "Chloe", "Dev", "Eli"}
drama = {"Chloe", "Eli", "Farah", "Gus"}

both = chess & drama
chess_only = chess - drama
everyone = chess | drama
one_club_only = chess ^ drama

print("both:", both)
print("chess only:", chess_only)
print("everyone:", everyone)
print("exactly one club:", one_club_only)
--- test
_names = {"both": both, "chess_only": chess_only, "everyone": everyone, "one_club_only": one_club_only}
for _n, _v in _names.items():
    assert _v is not ..., f"Replace the `...` after `{_n} =` with a set expression."
for _n, _v in _names.items():
    assert isinstance(_v, set), f"`{_n}` should be a set, but it is a {type(_v).__name__}."
assert both == chess & drama, f"`both` should be {sorted(chess & drama)}, but it is {sorted(both)}."
assert chess_only == chess - drama, f"`chess_only` should be {sorted(chess - drama)}, but it is {sorted(chess_only)}. Order matters for `-`."
assert everyone == chess | drama, f"`everyone` should have {len(chess | drama)} students, but has {len(everyone)}."
assert one_club_only == chess ^ drama, f"`one_club_only` should be {sorted(chess ^ drama)}, but it is {sorted(one_club_only)}."
--- hint
Look at the table above: each question matches one operator, `&`, `-`, `|` or `^`.
--- hint
"Both" is the overlap (`&`); "at least one" is everything combined (`|`); "exactly one" is everything except the overlap (`^`).
```

## Removing duplicates but keeping the order

`set(items)` removes duplicates, but it scrambles the order. When order matters (a history of songs played, a list of steps), use the **seen-set** pattern: walk through the list, keep a set of what you've already seen, and only keep items the first time they show up.

```python run
searches = ["boots", "tent", "boots", "stove", "tent", "lantern"]

seen = set()
unique_searches = []
for term in searches:
    if term not in seen:
        seen.add(term)
        unique_searches.append(term)

print(unique_searches)
```

The list holds the order; the set answers "seen it?" instantly. You get the best of both.

```python exercise id=recently-played title="Recently played, without repeats"
plays = ["Levitating", "Yellow", "Levitating", "Hello", "Yellow",
         "Halo", "Hello", "Levitating", "Clocks"]

# TODO: build `history`, a list with each song ONCE,
# in the order it was FIRST played. Use `seen` to remember songs.
history = []
seen = set()
for song in plays:
    ...

print(history)
--- solution
plays = ["Levitating", "Yellow", "Levitating", "Hello", "Yellow",
         "Halo", "Hello", "Levitating", "Clocks"]

history = []
seen = set()
for song in plays:
    if song not in seen:
        seen.add(song)
        history.append(song)

print(history)
--- test
assert isinstance(history, list), f"`history` should be a list, but it is a {type(history).__name__}."
assert history, "`history` is still empty. Inside the loop, append each song the first time you see it."
_expected = []
for _s in plays:
    if _s not in _expected:
        _expected.append(_s)
assert len(history) == len(_expected), f"`history` should have {len(_expected)} songs (one each), but has {len(history)}."
assert history == _expected, f"`history` should be {_expected} (order of first play), but it is {history}."
--- hint
For each song, ask: is it already in `seen`? Only if it isn't, do two things.
--- hint
`if song not in seen:` then `seen.add(song)` and `history.append(song)`.
```

> **Tip:** there's also a famous one-liner for this, `list(dict.fromkeys(plays))`, which works because dictionary keys are unique *and* keep insertion order. The loop is clearer while you're learning, and it's easy to extend (for example, to ignore capital letters).

## frozenset: a set that can't change

A `frozenset` is an immutable set. You can't add or remove items, and in exchange it can be used where only immutable values are allowed: as a dictionary key or as an item in another set.

```python run
pizza_a = frozenset({"cheese", "basil", "tomato"})
pizza_b = frozenset({"tomato", "cheese", "basil"})   # same toppings, different order

prices = {pizza_a: 11.5}
print("same pizza?", pizza_a == pizza_b)
print("price:", prices[pizza_b])
```

You won't need `frozenset` often, but now you'll recognize it when you see it.

## Debug challenge: the jumbled leaderboard

```python debug id=top-scores title="The top 3 scores come out in a random order"
scores = [88, 95, 72, 95, 100, 64, 88, 91]

# Show the 3 highest DIFFERENT scores, best first: [100, 95, 91]
unique_scores = list(set(scores))
top3 = unique_scores[:3]

print("Top 3 distinct scores:", top3)
--- solution
scores = [88, 95, 72, 95, 100, 64, 88, 91]

unique_scores = sorted(set(scores), reverse=True)
top3 = unique_scores[:3]

print("Top 3 distinct scores:", top3)
--- test
_want = sorted(set(scores), reverse=True)[:3]
assert isinstance(top3, list), f"`top3` should be a list, but it is a {type(top3).__name__}."
assert len(top3) == 3, f"`top3` should hold 3 scores, but has {len(top3)}."
assert len(set(top3)) == 3, f"`top3` contains a duplicate: {top3}. Remove duplicates first."
assert sorted(top3) == sorted(_want), f"`top3` should contain the three highest scores, but it is {top3}. A set doesn't keep any useful order."
assert top3 == _want, f"`top3` should be best first, {_want}, but it is {top3}."
--- hint
Run it: the scores are unique, but they aren't the top 3. What order does `list(set(...))` give you?
--- hint
A set has no meaningful order, so sort it yourself, from highest to lowest, before slicing off the first three.
```

## Recap

- A **set** stores each value once: `set(items)` removes duplicates, and `{1, 2, 3}` is a set literal.
- `{}` is an empty **dict**; an empty set is `set()`.
- `.add()` puts items in; `.remove()` raises `KeyError` if missing, `.discard()` doesn't.
- Membership with `in` is near-instant for sets, but they have **no order and no indexing**; use `sorted()` to display them.
- `|` union, `&` intersection, `-` difference, `^` symmetric difference, `<=` subset.
- Keep order while removing duplicates with a seen-set loop; `frozenset` is the immutable version.

**Up next:** comprehensions, a compact way to build lists, dictionaries and sets in a single readable line.
