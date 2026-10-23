You've already used fancy arguments without thinking about it. `print("a", "b", sep="-")` passes two values *and* a named setting. `sorted(scores, reverse=True)` flips the order with a word instead of a position. `round(3.14159)` works with one argument, and `round(3.14159, 2)` with two. And `print` happily takes one value, five values, or none at all.

None of that is magic reserved for built-ins. In this lesson you'll give your own functions the same flexibility: **keyword arguments** that make calls readable, **default values** for settings people rarely change, functions that accept **any number** of inputs with `*args` and `**kwargs`, and the one famous trap (the mutable default) that bites almost every Python programmer once. By the end, you'll design function signatures that are pleasant to call and hard to misuse.

## Positional and keyword arguments

So far you've passed arguments **by position**: the first value fills the first parameter, the second fills the second. You can also pass them **by name**, writing `parameter=value` in the call. These are **keyword arguments**, and with them the order no longer matters.

```python run
def book_flight(origin, destination, passengers):
    return f"{passengers} seat(s) from {origin} to {destination}"

print(book_flight("Lisbon", "Tokyo", 2))                                  # positional
print(book_flight(destination="Tokyo", passengers=2, origin="Lisbon"))    # keyword, any order
print(book_flight("Lisbon", passengers=2, destination="Tokyo"))           # mixed
```

All three calls do the same thing. Keyword arguments shine when a call would otherwise be a mystery: `book_flight("Lisbon", "Tokyo", 2)` makes you remember which city is which, while `destination="Tokyo"` says it outright.

The one rule when mixing: **positional arguments come first, keywords after.** Once you've started naming, Python can no longer tell which slot a bare value belongs to:

```python run error
book_flight(origin="Lisbon", "Tokyo", 2)
```

That's a `SyntaxError`, so Python refuses to run the line at all. There's also a `TypeError` for filling the same slot twice, as in `book_flight("Lisbon", origin="Porto", ...)`: "got multiple values for argument 'origin'".

```python predict id=predict-positional-order title="What does this print?"
def describe(animal, name):
    return f"{name} the {animal}"

print(describe("Rex", "dog"))
--- options
Rex the dog
* dog the Rex
Rex the Rex
TypeError
--- explain
Positional arguments are matched by **order**, not by meaning. `"Rex"` lands in `animal` and `"dog"` lands in `name`, so you get `dog the Rex`. Calling `describe(name="Rex", animal="dog")` would make the intent impossible to mix up.
```

## Default values

Many functions have settings that are *usually* the same. Give such a parameter a **default value** in the `def` line, and callers can leave it out:

```python run
def make_coffee(size="medium", milk=True, sugars=0):
    order = f"{size} coffee"
    if milk:
        order += " with milk"
    if sugars:
        order += f" and {sugars} sugar(s)"
    return order

print(make_coffee())
print(make_coffee("large"))
print(make_coffee(sugars=2))
print(make_coffee("small", milk=False))
```

Look at the third call: `sugars=2` skips over `size` and `milk`, which keep their defaults. That's the real power of combining defaults with keywords: callers change only what they care about. It's exactly how `print(..., sep=" ", end="\n")` works.

Parameters **with** defaults must come **after** parameters without them. Otherwise a call like `f(5)` would be ambiguous:

```python run error
def greet(greeting="Hello", name):
    return f"{greeting}, {name}!"
```

The fix is to put the required parameter first: `def greet(name, greeting="Hello")`.

> **In the wild:** Library functions often have a dozen parameters with defaults. pandas' `read_csv` has more than 40! You'll typically pass one positional argument (the file) and two or three keywords, like `read_csv("sales.csv", sep=";", encoding="utf-8")`. Defaults are what make such powerful functions usable.

```python exercise id=format-price title="Format a price tag"
# TODO 1: replace the two ... in the def line with defaults:
#   `currency` defaults to "$", `decimals` defaults to 2.
# TODO 2: replace the ... in the body to RETURN the price string.
# Examples:
#   format_price(4.5)                    -> "$4.50"
#   format_price(4.5, "€")               -> "€4.50"
#   format_price(1299, decimals=0)       -> "$1299"
#   format_price(3.14159, "£", 3)        -> "£3.142"
def format_price(amount, currency=..., decimals=...):
    """Return `amount` formatted as a price string, like '$4.50'."""
    ...

print(format_price(4.5))
--- solution
def format_price(amount, currency="$", decimals=2):
    """Return `amount` formatted as a price string, like '$4.50'."""
    return f"{currency}{amount:.{decimals}f}"

print(format_price(4.5))
--- test
assert ... not in (format_price.__defaults__ or ()), "Replace the two `...` defaults in the `def` line with real values."
assert format_price(4.5) is not None, "`format_price` gave back `None`. Replace the `...` in the body with a `return` statement."
assert isinstance(format_price(4.5), str), f"`format_price` should return a string, but returned {format_price(4.5)!r}."
assert format_price(4.5) == "$4.50", f"`format_price(4.5)` should be '$4.50' (default currency and 2 decimals), but is {format_price(4.5)!r}."
assert format_price(4.5, "€") == "€4.50", f"`format_price(4.5, '€')` should be '€4.50', but is {format_price(4.5, '€')!r}. Is `currency` the second parameter?"
assert format_price(1299, decimals=0) == "$1299", f"`format_price(1299, decimals=0)` should be '$1299', but is {format_price(1299, decimals=0)!r}."
assert format_price(3.14159, "£", 3) == "£3.142", f"`format_price(3.14159, '£', 3)` should be '£3.142', but is {format_price(3.14159, '£', 3)!r}."
assert format_price(amount=7, currency="¥", decimals=1) == "¥7.0", "All three parameters should be named `amount`, `currency` and `decimals`."
--- hint
In the header, a default is written `name=value`, so `currency="$"` and `decimals=2`.
--- hint
An f-string format spec can contain another `{...}`: `f"{amount:.{decimals}f}"` uses the value of `decimals` as the number of digits.
--- hint
`round(amount, decimals)` alone won't add trailing zeros (4.5 stays `4.5`). Build the string with the format spec, then put `currency` in front.
```

## The mutable default trap

Here's a function that adds an item to a shopping cart, or starts a new cart if you don't pass one. It looks perfectly reasonable. Run it:

```python run
def add_item(item, cart=[]):
    cart.append(item)
    return cart

alice = add_item("apples")
bob = add_item("bread")
print("alice:", alice)
print("bob:  ", bob)
```

Bob never asked for apples! Both "new" carts are **the same list**.

> **Under the hood:** A default value is created **once**, when Python runs the `def` line, not each time the function is called. Every call that leaves out `cart` gets that one shared list. Numbers, strings and `None` are immutable, so sharing them is harmless. A list, dict or set can be changed in place, so changes pile up between calls.

The fix is a pattern you'll see in professional code everywhere: default to **`None`**, and create the fresh list *inside* the function, where it runs on every call.

```python run
def add_item(item, cart=None):
    if cart is None:
        cart = []            # a brand-new list, every call
    cart.append(item)
    return cart

alice = add_item("apples")
bob = add_item("bread")
print("alice:", alice)
print("bob:  ", bob)
add_item("milk", alice)     # you can still pass your own cart
```

(`is None` is the standard way to test for `None`, as you saw in lesson 7.)

```python predict id=predict-mutable-default title="What does this print?"
def log_visit(page, history=[]):
    history.append(page)
    return len(history)

print(log_visit("home"), log_visit("shop"), log_visit("cart"))
--- options
1 1 1
* 1 2 3
3 3 3
0 1 2
--- explain
All three calls share the **same** default list, created once when the `def` ran. It grows to 1, then 2, then 3 items. With `history=None` and `if history is None: history = []` inside, each call would start fresh and print `1 1 1`.
```

```python debug id=playlist-shared-default title="New playlists already have songs"
def new_playlist(name, songs=[]):
    """Return a playlist dict. Starts empty unless songs are given."""
    return {"name": name, "songs": songs}

road_trip = new_playlist("Road trip")
road_trip["songs"].append("Life is a Highway")

study = new_playlist("Study")
print("study songs:", study["songs"])   # should be empty!
--- solution
def new_playlist(name, songs=None):
    """Return a playlist dict. Starts empty unless songs are given."""
    if songs is None:
        songs = []
    return {"name": name, "songs": songs}

road_trip = new_playlist("Road trip")
road_trip["songs"].append("Life is a Highway")

study = new_playlist("Study")
print("study songs:", study["songs"])   # should be empty!
--- test
assert study["songs"] == [], f"The Study playlist should start empty, but has {study['songs']!r}. Are two playlists sharing one list?"
assert road_trip["songs"] == ["Life is a Highway"], f"Road trip should hold exactly one song, but has {road_trip['songs']!r}."
a = new_playlist("A")
b = new_playlist("B")
a["songs"].append("x")
assert b["songs"] == [], "Two playlists made without `songs` still share the same list. Each call needs its own new list."
mine = ["Song 1"]
assert new_playlist("Mine", mine)["songs"] == ["Song 1"], "When songs ARE passed in, the playlist should use them."
--- hint
Run it: the Study playlist starts with a song it never got. When is the default `[]` created: once, or on every call?
--- hint
Use `None` as the default, and inside the function replace it with a fresh `[]` when `songs is None`.
```

## `*args`: any number of positional arguments

`print` accepts as many values as you give it. Your functions can too: put a `*` before a parameter name, and it collects **all the extra positional arguments into a tuple**. By convention it's called `args`, but a descriptive name is often better.

```python run
def total(*prices):
    print("prices is a", type(prices).__name__, "holding", prices)
    return sum(prices)

print(total(4.50, 2.25))
print(total(10, 20, 30, 40))
print(total())
```

You can combine `*args` with normal parameters. The normal ones fill up first, and the star collects whatever is left:

```python run
def order(customer, *items):
    return f"{customer} ordered {len(items)} item(s): {', '.join(items)}"

order("Priya", "latte", "croissant", "orange juice")
```

```python predict id=predict-args-list title="What does this print?"
def count_items(*items):
    return len(items)

groceries = ["eggs", "rice", "kale"]
print(count_items(groceries))
--- options
3
* 1
0
TypeError
--- explain
`*items` collects each **argument** into the tuple, and only one argument was passed: the whole list. So `items` is `(["eggs", "rice", "kale"],)`, a tuple holding one list, and its length is 1. To pass the three strings as separate arguments you'd call `count_items(*groceries)`, which you'll meet in a moment.
```

```python exercise id=average-of title="An average of anything"
# `*numbers` collects every number passed in.
# TODO: return their average, rounded to 2 decimal places.
# With no numbers at all, return 0.
#   average_of(4, 8, 6)  -> 6.0
#   average_of(2.5)      -> 2.5
#   average_of()         -> 0
def average_of(*numbers):
    """Return the average of all the numbers passed in (0 if none)."""
    ...

print(average_of(4, 8, 6))
--- solution
def average_of(*numbers):
    """Return the average of all the numbers passed in (0 if none)."""
    if not numbers:
        return 0
    return round(sum(numbers) / len(numbers), 2)

print(average_of(4, 8, 6))
--- test
assert average_of(4, 8, 6) is not None, "`average_of` gave back `None`. Replace the `...` with code that returns the average."
assert average_of(4, 8, 6) == 6.0, f"`average_of(4, 8, 6)` should be 6.0, but is {average_of(4, 8, 6)!r}."
assert average_of(2.5) == 2.5, f"`average_of(2.5)` should be 2.5, but is {average_of(2.5)!r}."
assert average_of(1, 2, 2) == 1.67, f"`average_of(1, 2, 2)` should be 1.67 (rounded to 2 decimals), but is {average_of(1, 2, 2)!r}."
assert average_of(10, 20, 30, 40, 50, 60) == 35.0, "`average_of` should work with six numbers too."
assert average_of() == 0, f"`average_of()` with no numbers should return 0, but returned {average_of()!r}. Watch out for dividing by zero!"
--- hint
`*numbers` gathers every positional argument into a tuple. Inside the function, `numbers` is just a tuple: `sum()` and `len()` work on it.
--- hint
An empty tuple is falsy. Check `if not numbers:` first, and return 0 early.
--- hint
Otherwise, `round(sum(numbers) / len(numbers), 2)`.
```

## `**kwargs`: any number of keyword arguments

Two stars collect any extra **keyword** arguments into a **dictionary**: names become keys, values become values. The conventional name is `kwargs` ("keyword arguments").

```python run
def make_profile(username, **details):
    profile = {"username": username}
    profile.update(details)
    return profile

print(make_profile("sam_codes"))
print(make_profile("ana_k", city="Porto", age=29, likes="surfing"))
```

`**kwargs` is perfect when the set of options is open-ended: tags on a blog post, extra columns in a record, settings passed through to another function.

```python exercise id=trip-summary title="A flexible trip summary"
# `trip_summary` takes a required `destination`, and `**details` collects
# ANY number of keyword details into a dict.
# TODO: return one line: the destination, then each detail
# as "key: value", all joined by " | ", in the order they were given.
#   trip_summary("Kyoto", nights=5, budget=1800)
#     -> "Kyoto | nights: 5 | budget: 1800"
#   trip_summary("Rome") -> "Rome"
def trip_summary(destination, **details):
    """Return a one-line summary of a trip and its details."""
    ...

print(trip_summary("Kyoto", nights=5, budget=1800))
--- solution
def trip_summary(destination, **details):
    """Return a one-line summary of a trip and its details."""
    parts = [destination]
    for key, value in details.items():
        parts.append(f"{key}: {value}")
    return " | ".join(parts)

print(trip_summary("Kyoto", nights=5, budget=1800))
--- test
got = trip_summary("Kyoto", nights=5, budget=1800)
assert got is not None, "`trip_summary` gave back `None`. Replace the `...` with code that returns a string."
assert isinstance(got, str), f"`trip_summary` should return a string, but returned {got!r}."
assert got == "Kyoto | nights: 5 | budget: 1800", f"Expected 'Kyoto | nights: 5 | budget: 1800', but got {got!r}."
assert trip_summary("Rome") == "Rome", f"With no details, `trip_summary('Rome')` should be just 'Rome', but is {trip_summary('Rome')!r}."
fresh = trip_summary("Reykjavík", season="winter", travellers=3, car=True)
assert fresh == "Reykjavík | season: winter | travellers: 3 | car: True", f"`trip_summary` should accept any keywords, in order. Got {fresh!r}."
assert trip_summary(destination="Cairo", nights=2) == "Cairo | nights: 2", "The required parameter should be called `destination`."
--- hint
Inside the function, `details` is an ordinary dict, like `{"nights": 5, "budget": 1800}`.
--- hint
Loop over `details.items()` to get each key and value, building a list of strings that starts with `destination`.
--- hint
`" | ".join(parts)` glues a list of strings together with the separator.
```

## Unpacking at the call site: `*` and `**` in calls

The stars also work in the **opposite direction**. In a *call*, `*sequence` spreads a list or tuple out into separate positional arguments, and `**dictionary` spreads a dict out into keyword arguments.

```python run
def book_table(name, guests, time):
    return f"Table for {guests} under '{name}' at {time}"

walk_in = ["Okafor", 4, "19:30"]
online = {"time": "20:00", "name": "Lindqvist", "guests": 2}

print(book_table(*walk_in))      # same as book_table("Okafor", 4, "19:30")
print(book_table(**online))      # same as book_table(time="20:00", name=..., guests=2)

scores = [88, 92, 79]
print(*scores, sep=" / ")        # works with built-ins too
```

This is handy when your data already lives in a list or dict, for instance a row read from a file (lesson 24) or settings loaded from JSON.

| Where | `*` | `**` |
|---|---|---|
| in a `def` | **collects** extra positional args into a tuple | **collects** extra keyword args into a dict |
| in a call | **spreads** a list/tuple into positional args | **spreads** a dict into keyword args |

## Keyword-only arguments

Sometimes a call is only safe if it's readable. Anything after a lone `*` in the parameter list **must** be passed by keyword:

```python run
def transfer(amount, *, from_account, to_account):
    return f"Moved ${amount} from {from_account} to {to_account}"

transfer(250, from_account="savings", to_account="checking")
```

Nobody can accidentally swap the two accounts by order, because order isn't allowed:

```python run error
transfer(250, "savings", "checking")
```

> **In the wild:** Python's own `sorted(items, key=..., reverse=...)` makes `key` and `reverse` keyword-only for exactly this reason: `sorted(items, len, True)` would be unreadable.

When you combine everything, Python requires this order in the `def` line:

```python
def f(required, with_default=1, *args, keyword_only, **kwargs):
    ...
```

You'll rarely need all five kinds at once. Most good functions have a couple of required parameters and a few defaults.

## Debug: the wrong slot

The most common argument bug isn't a crash. It's a call that passes the right values **in the wrong order**, so the function silently computes nonsense.

```python debug id=savings-wrong-order title="Savings grow to almost nothing"
def future_value(deposit, yearly_rate, years):
    """Return what `deposit` grows to after `years` of compound interest."""
    return round(deposit * (1 + yearly_rate) ** years, 2)

# Ana deposits $1000 at 5% a year for 10 years.
ana = future_value(0.05, 1000, 10)
# Ben deposits $2500 at 3% a year for 20 years.
ben = future_value(2500, 20, 0.03)

print("Ana will have:", ana)
print("Ben will have:", ben)
--- solution
def future_value(deposit, yearly_rate, years):
    """Return what `deposit` grows to after `years` of compound interest."""
    return round(deposit * (1 + yearly_rate) ** years, 2)

# Ana deposits $1000 at 5% a year for 10 years.
ana = future_value(deposit=1000, yearly_rate=0.05, years=10)
# Ben deposits $2500 at 3% a year for 20 years.
ben = future_value(deposit=2500, yearly_rate=0.03, years=20)

print("Ana will have:", ana)
print("Ben will have:", ben)
--- test
assert ana == round(1000 * 1.05 ** 10, 2), f"Ana should end with about $1628.89, but `ana` is {ana!r}. Which value went into which parameter?"
assert ben == round(2500 * 1.03 ** 20, 2), f"Ben should end with about $4515.28, but `ben` is {ben!r}. Check the order of his three arguments."
assert future_value(100, 0.1, 2) == 121.0, "`future_value` itself was correct. Fix the calls, not the formula."
--- hint
Run it. Ana's result is tiny and Ben's is enormous. Compare each call's argument order with the `def` line.
--- hint
Either reorder the values to match `deposit, yearly_rate, years`, or (better) pass them as keyword arguments so the order can't be wrong.
```

> **Tip:** When a function has several parameters of the same type (three numbers, two account names), call it with keywords. It costs a few characters and prevents a whole class of silent bugs.

## Recap

- Arguments can be **positional** (matched by order) or **keyword** (`name=value`, any order). Positional ones must come first.
- **Defaults** (`def f(x, size="medium")`) make parameters optional; parameters with defaults go after those without.
- Defaults are created **once**, so never use a mutable default like `[]` or `{}`. Default to `None` and create a fresh one inside.
- `*args` collects extra positional arguments into a tuple; `**kwargs` collects extra keyword arguments into a dict. In a call, `*` and `**` do the reverse and spread a list or dict out.
- Parameters after a lone `*` are **keyword-only**, which keeps calls readable and order-proof.

**Up next:** scope: where the names inside a function live, why a function can read a global but not change it, and how to avoid accidentally hiding Python's built-ins.
