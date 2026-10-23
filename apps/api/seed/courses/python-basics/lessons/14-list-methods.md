A list isn't just a container; it's a little machine with buttons. Push a button and it inserts an item at the front, pulls one off the end, finds where something is, or sorts itself into order. Those buttons are **list methods**, and with about a dozen of them you can run a to-do app, a queue at a coffee shop, or a leaderboard.

This lesson also covers the most surprising thing about lists, the one that trips up beginners and professionals alike: two names can point at the **same** list, so changing "one" changes "both". Once you can picture why, you'll know exactly when to make a copy, and you'll be able to spot three classic list bugs on sight.

## Adding items: `append`, `insert` and `extend`

You already know `.append(item)`, which adds one item to the end. Two siblings fill in the gaps: `.insert(position, item)` squeezes an item in **before** the given position, and `.extend(other_list)` adds every item of another list to the end.

```python run
queue = ["Ana", "Ben"]

queue.append("Cleo")              # one item, at the end
print("append:", queue)

queue.insert(0, "Dana (VIP)")     # before position 0, i.e. at the front
print("insert:", queue)

queue.extend(["Eli", "Fay"])      # every item from another list
print("extend:", queue)
```

All three **change the list in place** and give back nothing useful. Mutating methods are like pressing a button on the machine: the machine changes, and there's no new machine handed back to you.

> **Pitfall:** `append` always adds exactly **one** item, even if that item is a whole list. If you `append` a list, you get a list *inside* your list. Use `extend` to add the items one by one.

```python predict id=predict-append-extend title="append a list"
cart = ["bread", "jam"]
cart.append(["tea", "honey"])
print(cart, len(cart))
--- options
['bread', 'jam', 'tea', 'honey'] 4
* ['bread', 'jam', ['tea', 'honey']] 3
['bread', 'jam', ['tea', 'honey']] 4
['bread', 'jam', 'tea', 'honey'] 3
--- explain
`append` adds its argument as **one** item, so the whole list `['tea', 'honey']` becomes the third item of `cart`, nested inside it. The length is 3. `cart.extend(["tea", "honey"])` would have added the two strings separately, for a length of 4.
```

## Removing items: `remove`, `pop` and `clear`

There are two ways to say which item should go: by **value** or by **position**.

| Method | Removes | Gives back | If it can't |
|---|---|---|---|
| `lst.remove(value)` | the **first** item equal to `value` | `None` | `ValueError` |
| `lst.pop()` | the **last** item | the removed item | `IndexError` on an empty list |
| `lst.pop(i)` | the item at position `i` | the removed item | `IndexError` |
| `lst.clear()` | everything | `None` | (never fails) |

```python run
playlist = ["Intro", "Hey Jude", "Yesterday", "Hey Jude", "Outro"]

playlist.remove("Hey Jude")     # only the FIRST match goes
print("after remove:", playlist)

last = playlist.pop()           # take the last one off, and keep it
print("popped:", last, "| left:", playlist)

first = playlist.pop(0)         # take the item at position 0
print("popped:", first, "| left:", playlist)
```

`pop` is the only remover that **hands the item back**, which makes it perfect for "take the next thing to work on": the next customer in a queue, the top card from a deck, the most recent action to undo.

Asking `remove` for something that isn't there is an error, not a silent no-op:

```python run error
basket = ["apple", "banana", "cherry"]
basket.remove("mango")
```

The last line says `ValueError` and tells you the item isn't in the list. When you're not sure an item is present, check first: `if "mango" in basket: basket.remove("mango")`.

## Finding items: `index` and `count`

`.index(value)` tells you the position of the first match (and raises `ValueError` if there's none). `.count(value)` tells you how many times a value appears (and happily returns `0`).

```python run
rolls = [3, 6, 2, 6, 6, 1, 4]     # dice rolls in a board game

print("first six at position:", rolls.index(6))
print("number of sixes:", rolls.count(6))
print("number of fives:", rolls.count(5))

if 5 in rolls:
    print("first five at:", rolls.index(5))
else:
    print("no fives rolled")
```

```python exercise id=todo-shuffle title="Reorganize a to-do list"
todo = ["email Sam", "buy milk", "gym", "pay rent"]

# TODO 1: "pay rent" is urgent. Move it to the FRONT of the list
#         (take it out, then put it back in at position 0).
...

# TODO 2: The gym session got cancelled. Remove "gym".
...

# TODO 3: Add "call mom" and then "water plants" to the end.
...

# TODO 4: You finish the first task. Take it off the front of the
#         list with a method that gives it back, and store it in `finished`.
finished = ...

print("Finished:", finished)
print("Still to do:", todo)
--- solution
todo = ["email Sam", "buy milk", "gym", "pay rent"]

todo.remove("pay rent")
todo.insert(0, "pay rent")

todo.remove("gym")

todo.extend(["call mom", "water plants"])

finished = todo.pop(0)

print("Finished:", finished)
print("Still to do:", todo)
--- test
assert finished is not ..., "Replace the `...` after `finished =` with code that takes the first task off the list."
assert isinstance(todo, list), "`todo` should still be a list."
assert "gym" not in todo, "\"gym\" is still on the list. Remove it with `.remove(...)`."
assert "pay rent" not in todo or todo.count("pay rent") != 1 or todo[0] != "pay rent", "\"pay rent\" is at the front, but you haven't finished it yet. TODO 4 should pop the first task off the list."
assert todo.count("pay rent") <= 1, "\"pay rent\" appears more than once. Remove it before inserting it at the front."
assert "call mom" in todo and "water plants" in todo, "Add both \"call mom\" and \"water plants\" to the end of the list."
assert finished == "pay rent", f"`finished` should be the first task after moving \"pay rent\" to the front, but it's {finished!r}. Did TODO 1 put it at position 0? Did you pop position 0, not the end?"
assert todo == ["email Sam", "buy milk", "call mom", "water plants"], f"`todo` should be ['email Sam', 'buy milk', 'call mom', 'water plants'], but is {todo!r}."
--- hint
Each TODO is one method (TODO 1 is two). `remove` takes a value, `insert` takes a position and a value, and `extend` adds several items at once.
--- hint
`pop()` with no argument takes the **last** item. To take the first, give it a position: `pop(0)`.
--- hint
TODO 1 is `todo.remove("pay rent")` then `todo.insert(0, "pay rent")`. TODO 4 is `finished = todo.pop(0)`.
```

## Sorting: `sort()` versus `sorted()`

Python gives you two ways to sort, and the difference between them is one of the most important ideas in this lesson.

- `lst.sort()` is a **method**: it rearranges the list **in place** and returns `None`.
- `sorted(lst)` is a **built-in function**: it leaves the original alone and returns a **new**, sorted list.

Both accept `reverse=True` for largest-first order.

```python run
scores = [72, 95, 88, 61, 99]

ranked = sorted(scores, reverse=True)   # new list; scores unchanged
print("ranked:", ranked)
print("scores:", scores)

scores.sort()                           # rearranges scores itself
print("scores after .sort():", scores)
```

The trap is that `.sort()` *looks* like it should give you the sorted list back. It doesn't. It follows the same rule as `append`, `insert` and `remove`: methods that change a list in place return `None`, as a reminder that nothing new was created.

```python predict id=predict-sort-none title="What does sort() return?"
nums = [3, 1, 2]
result = nums.sort()
print(result, nums)
--- options
[1, 2, 3] [3, 1, 2]
[1, 2, 3] [1, 2, 3]
* None [1, 2, 3]
None [3, 1, 2]
--- explain
`.sort()` rearranges `nums` **in place** and returns `None`, so `result` is `None` while `nums` itself is now sorted. If you want a sorted copy as a value, use `sorted(nums)` instead.
```

| | `lst.sort()` | `sorted(lst)` |
|---|---|---|
| Changes the original? | yes | no |
| Returns | `None` | a new list |
| Works on | lists only | anything you can loop over (strings, ranges, …) |
| Use when | you're done with the old order | you need to keep the original |

### Sorting by a key

Strings sort by their characters' codes, which puts **every uppercase letter before every lowercase letter**. That's rarely what people want. The `key=` argument tells Python what to compare *instead* of the items themselves. You pass the name of a function **without parentheses**, and Python calls it on each item for you.

```python run
names = ["bella", "Zoe", "adam", "Carlos"]

print("default:      ", sorted(names))                  # capitals first!
print("ignoring case:", sorted(names, key=str.lower))   # compare lowercase versions
print("by length:    ", sorted(names, key=len))         # compare len(name)
```

With `key=str.lower`, Python sorts as if every name were lowercase, but the list it returns still holds the original names. With `key=len`, it compares lengths. You'll do much more with `key=` in lesson 22, including writing your own tiny key functions.

`.reverse()` is a simpler cousin: it flips the list in place without sorting anything (and, yes, returns `None`). The slice `lst[::-1]` gives you a reversed **copy** instead.

```python run
history = ["home", "news", "sports", "weather"]   # pages visited, oldest first

newest_first = history[::-1]    # a reversed copy
print("copy:    ", newest_first)

history.reverse()               # flips history itself
print("in place:", history)
```

```python exercise id=sort-guest-list title="Sort the guest list"
guests = ["zoe", "Maximilian", "Adam", "bella", "Carlos"]

# TODO 1: `alphabetical` is a NEW list of the guests in A-Z order,
#         ignoring upper/lower case (so "Adam" comes before "bella").
alphabetical = ...

# TODO 2: `longest_first` is a NEW list of the guests ordered by the
#         length of their name, longest name first.
longest_first = ...

# `guests` itself must stay in its original order.
print("A-Z:", alphabetical)
print("Longest first:", longest_first)
print("Original:", guests)
--- solution
guests = ["zoe", "Maximilian", "Adam", "bella", "Carlos"]

alphabetical = sorted(guests, key=str.lower)

longest_first = sorted(guests, key=len, reverse=True)

print("A-Z:", alphabetical)
print("Longest first:", longest_first)
print("Original:", guests)
--- test
assert alphabetical is not ... and longest_first is not ..., "Replace the `...` after `alphabetical =` and `longest_first =` with sorted lists."
assert alphabetical is not None and longest_first is not None, "One of your lists is `None`. `.sort()` returns None; `sorted(...)` returns a new list."
assert guests == ["zoe", "Maximilian", "Adam", "bella", "Carlos"], f"`guests` changed to {guests!r}. Use `sorted(...)`, which leaves the original alone, instead of `.sort()`."
assert isinstance(alphabetical, list) and sorted(alphabetical) == sorted(guests), f"`alphabetical` should contain the same five names as `guests`, but is {alphabetical!r}."
assert alphabetical != sorted(guests), "Capital letters are sorting before lowercase ones. Sort with `key=str.lower` to ignore case."
assert alphabetical == sorted(guests, key=str.lower), f"`alphabetical` should be in A-Z order ignoring case, but is {alphabetical!r}."
assert isinstance(longest_first, list) and sorted(longest_first) == sorted(guests), f"`longest_first` should contain the same five names as `guests`, but is {longest_first!r}."
lengths = [len(n) for n in longest_first]
assert lengths != sorted(lengths), "Your names go from shortest to longest. Add `reverse=True`."
assert lengths == sorted(lengths, reverse=True), f"`longest_first` should be ordered by name length, longest first. The lengths are {lengths}."
--- hint
You need new lists and must keep `guests` untouched, so reach for the built-in `sorted(...)`, not the `.sort()` method.
--- hint
`sorted` takes `key=` (what to compare) and `reverse=True` (largest first). Useful keys here: `str.lower` and `len`, written without parentheses.
--- hint
`alphabetical = sorted(guests, key=str.lower)`. For the second, sort by `len` and reverse.
```

```python debug id=top-scores-none title="The top scores crash with a NoneType error"
scores = [72, 95, 88, 61, 99, 84]

# Sort best-first, then take the top three for the podium.
scores = scores.sort(reverse=True)
top_three = scores[:3]

print("Top three:", top_three)
--- solution
scores = [72, 95, 88, 61, 99, 84]

scores.sort(reverse=True)
top_three = scores[:3]

print("Top three:", top_three)
--- test
assert scores is not None, "`scores` is None. `.sort()` sorts in place and returns None, so don't assign its result back to `scores`."
assert isinstance(scores, list) and sorted(scores) == [61, 72, 84, 88, 95, 99], f"`scores` should still hold all six scores, but is {scores!r}."
assert top_three == [99, 95, 88], f"`top_three` should be [99, 95, 88], but is {top_three!r}."
assert "[99, 95, 88]" in _stdout, "Print the top three so the podium can be announced."
--- hint
Run it and read the error: `'NoneType' object is not subscriptable` means you tried `[...]` on `None`. Which line turned `scores` into `None`?
--- hint
`.sort()` changes the list in place and returns `None`. Either call it on a line of its own, or use `sorted(...)`, which returns a new list.
```

## Two names, one list

Here's the surprise. Run this and look at `weekday_menu`:

```python run
weekday_menu = ["soup", "salad"]
weekend_menu = weekday_menu          # looks like a copy... it isn't

weekend_menu.append("pancakes")

print("weekend:", weekend_menu)
print("weekday:", weekday_menu)      # pancakes on a Tuesday?!
print("same list?", weekend_menu is weekday_menu)
```

Remember the mental model from lesson 3: a variable is a **name tag** on a value. `weekend_menu = weekday_menu` doesn't copy anything. It sticks a second name tag on the **same** list. Mutate the list through either name and both names see the change. This is called **aliasing**.

```text
weekday_menu ──┐
               ├──► ["soup", "salad", "pancakes"]     one list, two name tags
weekend_menu ──┘
```

`is` asks "are these the very same object?", while `==` asks "do these hold equal values?". Two separate lists with the same items are `==` but not `is`.

Strings and numbers never surprised you like this because they're immutable: you can't change them in place, only rebind a name to a new value. Aliasing only bites with **mutable** values, such as lists (and, soon, dictionaries and sets).

### Making a real copy

When you want an independent list, ask for a copy. These three are equivalent:

```python run
original = ["flour", "sugar", "eggs"]

copy_a = original.copy()
copy_b = original[:]          # a slice of everything
copy_c = list(original)       # build a new list from it

copy_a.append("butter")
print("original:", original)
print("copy_a:  ", copy_a)
print("equal values?", copy_b == original, "| same object?", copy_b is original)
```

> **Tip:** Pick one style and stick with it. `.copy()` is the most readable, because it says exactly what you mean.

```python predict id=predict-alias title="The backup that wasn't"
original = [10, 20, 30]
backup = original
original.append(40)
print(len(backup), backup is original)
--- options
3 False
3 True
4 False
* 4 True
--- explain
`backup = original` doesn't copy anything: both names point at **one** list. Appending through `original` changes that list, so `backup` sees 4 items too, and `backup is original` is `True`. A real backup would be `backup = original.copy()`.
```

```python debug id=draft-menu-alias title="Editing the draft changes the published menu"
# The restaurant's live menu, as customers see it.
menu = ["soup", "salad", "steak"]

# Start next month's draft from the current menu, then edit the draft.
draft = menu
draft.append("tiramisu")
draft[0] = "gazpacho"

print("Published menu:", menu)
print("Draft menu:    ", draft)
--- solution
menu = ["soup", "salad", "steak"]

draft = menu.copy()
draft.append("tiramisu")
draft[0] = "gazpacho"

print("Published menu:", menu)
print("Draft menu:    ", draft)
--- test
assert menu == ["soup", "salad", "steak"], f"The published `menu` changed to {menu!r}. Customers shouldn't see the draft edits yet!"
assert draft is not menu, "`draft` and `menu` are still the same list. Make `draft` an independent copy."
assert draft == ["gazpacho", "salad", "steak", "tiramisu"], f"`draft` should be ['gazpacho', 'salad', 'steak', 'tiramisu'], but is {draft!r}."
--- hint
Run it: the published menu has tiramisu on it. `draft = menu` didn't create a second list; it created a second *name*.
--- hint
Give `draft` its own list to edit: `.copy()`, `[:]` or `list(...)` all work.
```

### The grid that copies itself

Aliasing hides in one more place: building a grid with `*`. Multiplying a list repeats its items, so `[0] * 3` is `[0, 0, 0]`. But `[row] * 3` repeats the **same row object** three times:

```python run
bad = [[0] * 3] * 3          # three name tags on ONE row
bad[0][0] = 1
print("bad: ", bad)          # every row changed!

good = []
for r in range(3):
    good.append([0] * 3)     # a brand-new row each time round the loop
good[0][0] = 1
print("good:", good)
```

The loop version creates a fresh `[0] * 3` on every pass, so each row is its own list. (`[0] * 3` is fine on its own, because numbers are immutable.)

> **Under the hood:** `.copy()` is a **shallow** copy: it makes a new outer list, but the items inside are the same objects as before. For a list of numbers or strings that's all you need. For a grid, `grid.copy()` gives you a new outer list holding the *same* rows, so copy each row too: build a new list and `append(row.copy())` for every row.

## Don't change a list while you loop over it

A `for` loop over a list walks through it by position: item 0, item 1, item 2, and so on. If you remove items as you go, everything after the removed item shifts one place left, and the loop skips over whatever slid into the gap.

```python run
nums = [2, 4, 5, 6, 8]
for n in nums:
    if n % 2 == 0:
        nums.remove(n)      # removing while looping over nums

print(nums)                 # expected [5]... but evens survived
```

Use **Debug** on that cell and watch: after `2` is removed, `4` slides into position 0, and the loop moves on to position 1 (the `5`), never seeing the `4`.

The safe patterns are:

1. **Build a new list** of the items you want to keep (the `[]` + loop + `append` pattern), then use it.
2. **Loop over a copy** (`for n in nums[:]:`) while removing from the original.

```python run
nums = [2, 4, 5, 6, 8]

odds = []
for n in nums:
    if n % 2 != 0:
        odds.append(n)
nums = odds

print(nums)
```

> **In the wild:** this exact bug shows up in real scripts that clean up data: removing blank rows from a spreadsheet, finished jobs from a queue, or expired sessions from a server. It's so common that some languages throw an error when you try it. Python doesn't, so it's on you to spot it.

```python debug id=expired-coupons title="Some expired coupons survive the cleanup"
coupons = ["SAVE10", "EXPIRED-A", "EXPIRED-B", "FREESHIP", "EXPIRED-C"]

# Remove every coupon whose code starts with "EXPIRED".
for code in coupons:
    if code.startswith("EXPIRED"):
        coupons.remove(code)

print("Valid coupons:", coupons)
--- solution
coupons = ["SAVE10", "EXPIRED-A", "EXPIRED-B", "FREESHIP", "EXPIRED-C"]

for code in coupons[:]:
    if code.startswith("EXPIRED"):
        coupons.remove(code)

print("Valid coupons:", coupons)
--- test
assert isinstance(coupons, list), "`coupons` should still be a list of coupon codes."
left = [c for c in coupons if c.startswith("EXPIRED")]
assert not left, f"These expired coupons are still in `coupons`: {left}. The loop is skipping items."
assert coupons == ["SAVE10", "FREESHIP"], f"`coupons` should be ['SAVE10', 'FREESHIP'] (valid ones, in order), but is {coupons!r}."
assert "FREESHIP" in _stdout and "EXPIRED" not in _stdout, "Print the cleaned-up list of valid coupons."
--- hint
Run it, then **Debug** it and watch which `code` the loop visits right after it removes "EXPIRED-A".
--- hint
Removing an item shifts the rest left, so the loop skips the next one. Either loop over a copy (`coupons[:]`), or build a new list of the valid codes and assign it back to `coupons`.
```

## Recap

- `append` adds one item, `insert(i, x)` adds before position `i`, and `extend` adds every item of another list. `remove(value)` deletes the first match, `pop()` / `pop(i)` removes **and returns** an item, and `clear()` empties the list.
- `index` finds a position and `count` counts matches. `remove` and `index` raise `ValueError` when the value is missing, so check with `in` first.
- `lst.sort()` sorts **in place and returns `None`**; `sorted(lst)` returns a **new** list. Both take `reverse=True` and `key=` (like `key=len` or `key=str.lower`).
- `b = a` makes two names for **one** list. Use `a.copy()`, `a[:]` or `list(a)` for an independent copy, and build grids with a loop, not `[[0] * n] * n`.
- Never remove from a list while looping over it. Build a new list, or loop over a copy.

**Up next:** tuples and unpacking: fixed-size records you can't accidentally change, and a neat way to pull several values out at once.
