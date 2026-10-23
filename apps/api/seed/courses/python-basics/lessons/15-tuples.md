Some data comes in fixed shapes. A map location is always a latitude and a longitude. A colour on screen is always red, green and blue. A date is a year, a month and a day. You don't `append` a fourth number to a GPS position, and you definitely don't want some other part of your program to quietly change one.

For data like this Python has the **tuple**: an ordered, **unchangeable** bundle of values, like a sealed envelope with a few facts inside. Tuples come with a superpower called **unpacking**, which lets you pull every piece out into its own named variable in a single line. You've already used it without knowing: `a, b = 1, 2` from lesson 3 was a tuple in disguise.

## Making tuples

Write a tuple with **parentheses** instead of square brackets. Indexing, slicing, `len()`, `in` and `for` loops all work exactly as they do on lists.

```python run
lisbon = (38.72, -9.14)            # (latitude, longitude)
orange = (255, 165, 0)             # (red, green, blue)
launch_day = (2026, 3, 14)         # (year, month, day)

print("latitude:", lisbon[0])
print("green channel:", orange[1])
print("year and month:", launch_day[:2])
print("is 0 in orange?", 0 in orange)
launch_day
```

The chip reads `tuple · len 3`. And notice that slicing a tuple gives you another tuple, `(2026, 3)`, just as slicing a list gives you a list.

Here's a detail that surprises people: it's the **comma** that makes a tuple, not the parentheses. The parentheses are mostly there for readability.

```python run
screen = 1920, 1080          # no parentheses, still a tuple
print(screen, type(screen))

empty = ()                   # the empty tuple is the exception: just ()
print(empty, len(empty))
```

### The one-item tuple needs a comma

Because parentheses also group maths, like `(2 + 3) * 4`, Python reads `("pizza")` as just the string `"pizza"` in brackets. To make a tuple with one item, add a trailing comma:

```python run
just_text = ("pizza")
one_tuple = ("pizza",)

print(type(just_text), len(just_text))   # a str of 5 characters
print(type(one_tuple), len(one_tuple))   # a tuple holding 1 item
```

It looks a little odd the first time, but it's the only way: `(x,)` is a one-item tuple.

```python predict id=predict-one-tuple title="Is it a tuple?"
t = (5)
u = (5,)
print(type(t), type(u))
--- options
<class 'tuple'> <class 'tuple'>
* <class 'int'> <class 'tuple'>
<class 'int'> <class 'int'>
<class 'tuple'> <class 'int'>
--- explain
`(5)` is just the number 5 inside grouping parentheses, the same as writing `5`. Only the **comma** turns it into a tuple, so `(5,)` is a one-item tuple.
```

## Tuples can't be changed

Once a tuple is made, its items are fixed. There's no item assignment, no `append`, no `remove`, no `sort`.

```python run error
orange = (255, 165, 0)
orange[1] = 140
```

The error is `TypeError: 'tuple' object does not support item assignment`, the same complaint you got when you tried to change a character in a string. Tuples are **immutable**, like strings and numbers, and unlike lists.

That might sound like a limitation. It's actually the point:

- **Safety.** You can pass a tuple anywhere in your program and know nothing will alter it behind your back. That's exactly the aliasing bug from the last lesson, made impossible.
- **Meaning.** A tuple tells the reader "this is a fixed record of a few related facts", while a list says "this is a collection that might grow or shrink".
- **Usable as keys.** Because they can't change, tuples can be used where Python needs values that stay put, such as dictionary keys and set members. You'll use that in the next two lessons.

If you need a "changed" tuple, you build a new one and rebind the name, exactly as you do with strings:

```python run
orange = (255, 165, 0)
darker = (orange[0], 140, orange[2])     # build a new tuple
print("original:", orange)
print("darker:  ", darker)

scores = (8, 9, 7, 9, 10)
print("count of 9s:", scores.count(9), "| first 9 at:", scores.index(9))
```

Tuples have just two methods, `count` and `index`, because every other list method would change the tuple.

> **Under the hood:** a tuple can't change *which* objects it holds, but if one of those objects is mutable, that object can still change. `team = ("Reds", ["Ana", "Ben"])` can't swap out the list, yet `team[1].append("Cleo")` works. In practice, tuples usually hold numbers and strings, so this rarely matters.

## Unpacking: one line, many names

**Unpacking** assigns each item of a tuple to its own variable, in order. The number of names on the left must match the number of items on the right.

```python run
reading = ("Reykjavik", 3.5, 82)          # (city, temperature, humidity)

city, temp, humidity = reading            # three names, three items
print(city, "is", temp, "degrees with", humidity, "% humidity")

# Swapping is just packing and unpacking at once:
home, away = "Lions", "Tigers"
home, away = away, home
print("home:", home, "| away:", away)
```

Look again at that swap. The right side, `away, home`, first **packs** the two current values into a tuple. Then the left side **unpacks** that tuple into the two names. That's why you never need a temporary variable to swap in Python.

Unpacking works on any sequence, not just tuples: lists and strings unpack too. If the counts don't match, you get a `ValueError`:

```python run error
reading = ("Reykjavik", 3.5, 82)
city, temp = reading
```

Read the last line: `ValueError: too many values to unpack (expected 2, got 3)`. Python tells you exactly how many names it had and how many values it found. Three items, two names, and Python refuses to guess which one to drop. With too few items you'd see `not enough values to unpack` instead.

```python predict id=predict-rotate title="Rotate three values"
a, b, c = 1, 2, 3
a, b, c = c, a, b
print(a, b, c)
--- options
1 2 3
3 3 3
* 3 1 2
2 3 1
--- explain
The right side is evaluated **first**, building the tuple `(3, 1, 2)` from the *old* values. Only then are the names reassigned: `a` gets 3, `b` gets 1, `c` gets 2. No value gets overwritten before it's used, which is why this "rotate" works in one line.
```

```python exercise id=unpack-flight title="Unpack a flight record"
# (flight code, from, to, hours, minutes)
flight = ("BA117", "London", "New York", 7, 45)

# TODO 1: unpack `flight` into five variables in ONE line:
#         code, origin, destination, hours, minutes
...

# TODO 2: `total_minutes` is the whole flight time in minutes.
total_minutes = ...

# TODO 3: `route` is a tuple of just the two places: (origin, destination)
route = ...

print("total minutes:", total_minutes)
print("route:", route)
--- solution
flight = ("BA117", "London", "New York", 7, 45)

code, origin, destination, hours, minutes = flight

total_minutes = hours * 60 + minutes

route = (origin, destination)

print("total minutes:", total_minutes)
print("route:", route)
--- test
assert total_minutes is not ... and route is not ..., "Replace each `...` with your code: unpack `flight` first (TODO 1), then fill in `total_minutes` and `route`."
assert code == "BA117" and origin == "London" and destination == "New York", "Unpack `flight` so that `code`, `origin` and `destination` hold its first three items, in order."
assert hours == 7 and minutes == 45, f"`hours` and `minutes` should be 7 and 45, but are {hours!r} and {minutes!r}."
assert total_minutes == flight[3] * 60 + flight[4], f"`total_minutes` should be {flight[3] * 60 + flight[4]}, but is {total_minutes!r}. Turn the hours into minutes, then add the extra minutes."
assert isinstance(route, tuple), f"`route` should be a tuple, but it's a {type(route).__name__}. Use parentheses and a comma."
assert route == ("London", "New York"), f"`route` should be ('London', 'New York'), but is {route!r}."
--- hint
Unpacking puts several names on the left of a single `=`, separated by commas, with the tuple on the right.
--- hint
TODO 1 is `code, origin, destination, hours, minutes = flight`. Then use those names for TODO 2 and 3: an hour has 60 minutes.
--- hint
`route = (origin, destination)`, with the comma between the two names.
```

## Star unpacking: "and the rest"

Sometimes you care about the first item (or the last) and want everything else bundled together. Put a `*` in front of one name, and it collects all the leftover items **as a list**:

```python run
finish_times = [41.2, 43.8, 44.0, 47.5, 52.1]   # minutes, fastest first

winner, *others = finish_times
print("winner:", winner, "| others:", others)

*everyone_else, last = finish_times
print("last place:", last)

first, *middle, final = finish_times
print("middle of the pack:", middle)
```

Only one name per unpacking can have a star, and the starred name is always a list, even if it ends up empty or with a single item.

```python predict id=predict-star title="Star-unpack a string"
first, *middle, last = "python"
print(first, middle, last)
--- options
p ytho n
* p ['y', 't', 'h', 'o'] n
p ('y', 't', 'h', 'o') n
p y n
--- explain
A string unpacks one character at a time. `first` takes `'p'`, `last` takes `'n'`, and the starred name collects everything in between. A starred name **always becomes a list**, so `middle` is `['y', 't', 'h', 'o']`, not a string or a tuple.
```

```python exercise id=race-podium title="Medals and the rest of the field"
# Runners in the order they crossed the finish line.
finishers = ["Kim", "Luis", "Mia", "Noah", "Omar", "Pia", "Quinn"]

# TODO 1: In ONE line, unpack `finishers` into `gold`, `silver`, `bronze`
#         and a starred name `others` that collects everyone else.
...

# TODO 2: `podium` is a tuple of the three medallists, in order.
podium = ...

print("Podium:", podium)
--- solution
finishers = ["Kim", "Luis", "Mia", "Noah", "Omar", "Pia", "Quinn"]

gold, silver, bronze, *others = finishers

podium = (gold, silver, bronze)

print("Podium:", podium)
print("Others:", others)
--- test
assert podium is not ..., "Replace each `...` with your code: unpack `finishers` first (TODO 1), then build the `podium` tuple."
assert gold == "Kim" and silver == "Luis" and bronze == "Mia", f"`gold`, `silver` and `bronze` should be the first three finishers, but are {gold!r}, {silver!r}, {bronze!r}."
assert isinstance(others, list), f"`others` should be a list (that's what a starred name gives you), but it's a {type(others).__name__}."
assert others == finishers[3:], f"`others` should hold everyone after the podium, {finishers[3:]}, but is {others!r}."
assert isinstance(podium, tuple), f"`podium` should be a tuple, but it's a {type(podium).__name__}."
assert podium == ("Kim", "Luis", "Mia"), f"`podium` should be ('Kim', 'Luis', 'Mia'), but is {podium!r}."
--- hint
List the names you want on the left of `=`, in finishing order. One of them gets a `*` to collect the leftovers.
--- hint
TODO 1 looks like `gold, silver, bronze, *others = finishers`. TODO 2 packs three names back into a tuple with parentheses and commas.
```

## Getting several results back at once

Tuples are how Python hands you **more than one result** from a single operation. The built-in `divmod(a, b)` computes `a // b` and `a % b` together and returns them as a pair. Unpack it straight away and each result gets a good name:

```python run
print("divmod gives:", divmod(135, 60))

hours, minutes = divmod(135, 60)          # 135 minutes of film
print(f"Running time: {hours}h {minutes}m")

user, _, domain = "maria@example.com".partition("@")
print("user:", user, "| domain:", domain)
```

`.partition(sep)` is another string method that returns a tuple: the part before the separator, the separator itself, and the part after. The `_` is a convention every Python programmer recognises: "there's a value here, but I don't need it".

> **In the wild:** this "return a tuple, unpack it on the spot" pattern is everywhere. A function that looks up a user might return `(found, user)`; a sensor reading might return `(value, unit)`. In lesson 19 you'll write your own functions that `return total, average` and get unpacked in exactly this way.

## Tuples in loops

A list of tuples is one of the most common shapes of data in Python: each tuple is one **record** (one row of a table), and the list holds all the records. Unpack each tuple right in the `for` line, and every column gets its own name:

```python run
results = [("Ana", 91), ("Ben", 78), ("Cleo", 85), ("Dev", 94)]

best_name, best_score = results[0]
for name, score in results:
    print(f"{name:<5} {score:>3}")
    if score > best_score:
        best_name, best_score = name, score

print("Top student:", best_name, "with", best_score)
```

Compare `for name, score in results` with the alternative, `for r in results:` followed by `r[0]` and `r[1]`. Same behaviour, but the unpacked version reads like a sentence.

```python exercise id=warmest-city title="Find the warmest city"
# (city, temperature in Celsius) at noon today
readings = [
    ("Oslo", 4.5),
    ("Cairo", 31.2),
    ("Lima", 19.8),
    ("Sydney", 24.6),
    ("Toronto", 11.0),
]

# TODO: loop over `readings`, unpacking each tuple in the for line, and work out:
#   warmest       -> the name of the warmest city
#   warmest_temp  -> its temperature
#   above_20      -> a list of the cities warmer than 20 degrees, in order
warmest = ...
warmest_temp = ...
above_20 = ...

print(f"Warmest: {warmest} ({warmest_temp}°C)")
print("Above 20°C:", above_20)
--- solution
readings = [
    ("Oslo", 4.5),
    ("Cairo", 31.2),
    ("Lima", 19.8),
    ("Sydney", 24.6),
    ("Toronto", 11.0),
]

warmest, warmest_temp = readings[0]
above_20 = []
for city, temp in readings:
    if temp > warmest_temp:
        warmest, warmest_temp = city, temp
    if temp > 20:
        above_20.append(city)

print(f"Warmest: {warmest} ({warmest_temp}°C)")
print("Above 20°C:", above_20)
--- test
assert warmest is not ... and warmest_temp is not ... and above_20 is not ..., "Replace each `...` with your code: start from the first reading, then loop over `readings`."
top_temp = max(t for _, t in readings)
top_city = [c for c, t in readings if t == top_temp][0]
assert warmest_temp == top_temp, f"`warmest_temp` should be the highest temperature ({top_temp}), but is {warmest_temp!r}."
assert warmest == top_city, f"`warmest` should be the city with {top_temp}°C, {top_city!r}, but is {warmest!r}. Update the name and the temperature together."
assert isinstance(above_20, list), f"`above_20` should be a list of city names, but it's a {type(above_20).__name__}."
expected = [c for c, t in readings if t > 20]
assert above_20 == expected, f"`above_20` should be {expected}, but is {above_20!r}. Append the city name (not the whole tuple) when its temperature is over 20."
--- hint
Use the "find the max" pattern from lesson 12: start with the first reading as the best so far, then replace it whenever you see something warmer.
--- hint
Start with `warmest, warmest_temp = readings[0]` and `above_20 = []`. Then loop with `for city, temp in readings:`.
--- hint
Inside the loop you need two separate `if`s: one compares `temp` with `warmest_temp`, the other checks `temp > 20` and appends `city`.
```

```python debug id=hat-sizes-letters title="The hat comes in eight sizes, one letter each"
# Each product has a tuple of the sizes it comes in.
shirt_sizes = ("S", "M", "L", "XL")
hat_sizes = ("ONE SIZE")

for size in hat_sizes:
    print("Hat available in:", size)
print("Number of hat sizes:", len(hat_sizes))
--- solution
shirt_sizes = ("S", "M", "L", "XL")
hat_sizes = ("ONE SIZE",)

for size in hat_sizes:
    print("Hat available in:", size)
print("Number of hat sizes:", len(hat_sizes))
--- test
assert shirt_sizes == ("S", "M", "L", "XL"), "Leave `shirt_sizes` as it was."
assert isinstance(hat_sizes, tuple), f"`hat_sizes` is a {type(hat_sizes).__name__}, not a tuple. Parentheses alone don't make a tuple."
assert hat_sizes == ("ONE SIZE",), f"`hat_sizes` should be a tuple holding the single size 'ONE SIZE', but is {hat_sizes!r}."
assert "Hat available in: ONE SIZE" in _stdout, "The loop should print the one hat size, 'ONE SIZE', on a single line."
assert "Number of hat sizes: 1" in _stdout, "The hat should come in exactly 1 size."
--- hint
Run it. The loop goes letter by letter, which is what looping over a **string** does. What type is `hat_sizes` really?
--- hint
`("ONE SIZE")` is just a string in brackets. What tiny character turns it into a one-item tuple?
```

```python debug id=members-unpack-crash title="Reading the member list crashes"
# Each member record is (name, city, age).
members = [("Ana", "Porto", 34), ("Ben", "Leeds", 29), ("Cleo", "Austin", 41)]

total_age = 0
for name, age in members:
    print(f"{name} is {age}")
    total_age += age

print("Average age:", round(total_age / len(members), 1))
--- solution
members = [("Ana", "Porto", 34), ("Ben", "Leeds", 29), ("Cleo", "Austin", 41)]

total_age = 0
for name, city, age in members:
    print(f"{name} is {age}")
    total_age += age

print("Average age:", round(total_age / len(members), 1))
--- test
assert total_age == 34 + 29 + 41, f"`total_age` should be {34 + 29 + 41}, but is {total_age!r}. Is `age` really the third item of each record?"
for n, c, a in members:
    assert f"{n} is {a}" in _stdout, f"The output should include the line \"{n} is {a}\"."
assert "Average age: 34.7" in _stdout, "Print the average age (34.7) at the end."
--- hint
Run it and read the last line of the error. How many items are in each tuple, and how many names does the `for` line unpack into?
--- hint
Every record has three items: name, city and age. The `for` line needs three names too. If you don't need the city, you can call it `_`.
```

## Tuples vs. lists

| | Tuple | List |
|---|---|---|
| Written as | `("Ana", 34)` | `["Ana", "Ben"]` |
| Can change after creation? | no (immutable) | yes (mutable) |
| Typical use | a fixed **record**: a few related facts, often of different kinds | a **collection** of similar things that may grow or shrink |
| Example | `(lat, lon)`, `(r, g, b)`, `(name, score)` | a playlist, a cart, the day's readings |
| Methods | just `count` and `index` | `append`, `insert`, `remove`, `pop`, `sort`, … |
| Usable as a dictionary key | yes | no |

A handy rule of thumb: if you'd describe the data with "and" (a name **and** a score **and** a date), it's a tuple. If you'd describe it with "a bunch of" (a bunch of scores), it's a list. And the two combine naturally: a **list of tuples** is a whole table of records.

## Recap

- A **tuple** is an ordered, **immutable** sequence written with parentheses: `(38.72, -9.14)`. Indexing, slicing, `len`, `in` and loops work just like lists.
- The **comma** makes the tuple. A one-item tuple needs a trailing comma, `("pizza",)`; without it you just have the value in brackets.
- Tuples can't be changed (`TypeError` on item assignment), which makes them safe to share and usable as dictionary keys. Build a new tuple when you need a changed version.
- **Unpacking** assigns each item to a name: `city, temp = reading`. The counts must match, or you get `ValueError`. `a, b = b, a` swaps, and `first, *rest = items` collects leftovers into a list.
- Tuples carry several results at once (`hours, minutes = divmod(135, 60)`), and `for name, score in pairs:` unpacks each record of a list of tuples right in the loop.

**Up next:** dictionaries, Python's way to look things up by key, like a phone book that finds a number from a name.
