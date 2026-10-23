Imagine a shopping app that writes the price of a coffee, `3.5`, in forty different places. The day the price changes, someone has to find and fix all forty, and miss none. Real programs avoid this by giving values **names**: write `coffee_price = 3.5` once, then use `coffee_price` everywhere. Change it in one place and the whole program follows.

Those names are called **variables**, and they're how a program remembers things: a score that goes up, a bank balance that changes, the name a user typed in. By the end of this page you'll be able to create and update variables, name them like a professional, swap two values in one line, and peek at what *kind* of value a variable holds.

## A variable is a name tag on a value

Write a name, an equals sign, and a value:

```python run
city = "Barcelona"
temperature = 26
print(city)
print(temperature)
```

The line `temperature = 26` is called an **assignment**. Read it right to left: *"take the value 26 and stick the name tag `temperature` on it."* From then on, whenever Python sees `temperature`, it uses 26.

```text
  name tag            value
┌─────────────┐
│ city        │ ───▶  "Barcelona"
└─────────────┘
┌─────────────┐
│ temperature │ ───▶  26
└─────────────┘
```

> **Pitfall:** In Python, `=` does **not** mean "is equal to" like in maths. It's an instruction: *"make this name refer to this value."* That's why `26 = temperature` is a `SyntaxError`: `26` isn't a name, so there's nothing to attach a tag to. The name always goes on the left, the value on the right.

## Using variables in calculations

Once a value has a name, you can use the name anywhere you'd use the value itself, including inside calculations and other assignments:

```python run
coffee_price = 3.5
croissant_price = 2.25
coffees = 2

order_total = coffee_price * coffees + croissant_price
print("Order total:", order_total)
```

Python works out the right-hand side first (`3.5 * 2 + 2.25`), gets `9.25`, and then sticks the name `order_total` on the result. Change `coffees` to `3` and run again: the total follows automatically. That's the whole point.

Names make code **read like a sentence**. Compare `print(3.5 * 2 + 2.25)` with `print(coffee_price * coffees + croissant_price)`. Same result, but only one of them tells you what's going on.

```python exercise id=road-trip title="Plan the road trip"
distance_km = 450
litres_per_100km = 8
price_per_litre = 1.5

# TODO: using the three variables above (not the numbers!), define:
#   litres_needed: how many litres of fuel the whole trip uses
#   fuel_cost:     how much that fuel costs in total
litres_needed = ...
fuel_cost = ...

print("Litres needed:", litres_needed)
print("Fuel cost:", fuel_cost)
--- solution
distance_km = 450
litres_per_100km = 8
price_per_litre = 1.5

litres_needed = distance_km / 100 * litres_per_100km
fuel_cost = litres_needed * price_per_litre

print("Litres needed:", litres_needed)
print("Fuel cost:", fuel_cost)
--- test
assert litres_needed is not ..., "Replace the `...` after `litres_needed =` with a calculation using the variables above."
assert fuel_cost is not ..., "Replace the `...` after `fuel_cost =` with a calculation."
expected_litres = distance_km / 100 * litres_per_100km
assert litres_needed != distance_km * litres_per_100km, f"`litres_needed` is {litres_needed}, which is far too much. The car uses {litres_per_100km} litres per **100** km, so divide the distance by 100."
assert abs(litres_needed - expected_litres) < 1e-9, f"`litres_needed` should be {expected_litres} for this trip, but it is {litres_needed}."
assert abs(fuel_cost - expected_litres * price_per_litre) < 1e-9, f"`fuel_cost` should be the litres needed times the price per litre ({expected_litres * price_per_litre}), but it is {fuel_cost}."
--- hint
The car uses 8 litres for every 100 km. How many "hundreds of km" is the trip?
--- hint
`litres_needed` is the distance divided by 100, times the litres per 100 km. Then `fuel_cost` can use `litres_needed` itself.
```

## Reassigning: moving the name tag

A variable can be given a new value at any time. The old value isn't changed; the **name tag simply moves** to the new value:

```python run
mood = "sleepy"
print("Morning:", mood)

mood = "energised"
print("After coffee:", mood)
```

This is why they're called *variables*: what they refer to can vary. Every assignment says "from now on, this name means this value", and that holds until the next assignment to the same name.

```python predict id=predict-copy-tag title="Does b follow a?"
a = 5
b = a
a = 10
print(a, b)
--- options
10 10
* 10 5
5 5
5 10
--- explain
`b = a` puts the name `b` on the value `a` refers to **right now**, which is 5. It doesn't link `b` to `a` forever. When `a` is later moved to 10, `b` is still on 5. Assignment copies the *current* value's tag, not a permanent connection.
```

## Updating a variable: `x = x + 1`

Here's a line that would make a maths teacher wince:

```python run
score = 0
score = score + 10
score = score + 25
print("Score:", score)
```

It makes perfect sense once you remember that `=` means "assign" and the right side runs first. `score = score + 10` means: *take the current value of `score`, add 10, then move the `score` tag onto the result.* Step through it with **Debug** and watch `score` change from 0 to 10 to 35.

Updating a variable is so common that Python has shortcuts for it, called **augmented assignment**:

| Shortcut | Means | Example: `balance` starts at 100 |
|---|---|---|
| `x += 5` | `x = x + 5` | `balance += 50` → 150 |
| `x -= 5` | `x = x - 5` | `balance -= 30` → 70 |
| `x *= 2` | `x = x * 2` | `balance *= 2` → 200 |
| `x /= 2` | `x = x / 2` | `balance /= 4` → 25.0 |

```python run
balance = 100
balance += 50     # payday
balance -= 30     # groceries
balance -= 12.5   # cinema ticket
print("Balance:", balance)
```

You can only update a variable that already exists. Python has to know the current value before it can add to it:

```python run error
coins += 10
```

The `NameError` says `coins` isn't defined. `coins += 10` means `coins = coins + 10`, and the right side can't be worked out because `coins` has no value yet. The fix is to create it first, for example `coins = 0`, before any updates.

```python predict id=predict-augmented title="Follow the score"
points = 10
points += 5
points *= 2
points -= 1
points
--- options
14
* 29
19
30
--- explain
Take it one line at a time: 10, then `+= 5` gives 15, then `*= 2` doubles it to 30, then `-= 1` gives 29. Each update uses the value left by the line before it.
```

```python exercise id=step-counter title="Count your steps"
steps = 0

# TODO: update `steps` for each walk using +=, one line per walk:
#   morning walk: 3200 steps
#   lunch walk:   1500 steps
#   evening run:  4800 steps
...

print("Total steps today:", steps)
--- solution
steps = 0

steps += 3200
steps += 1500
steps += 4800

print("Total steps today:", steps)
--- test
assert steps != 0, "`steps` is still 0. Add each walk to it with `steps += ...`."
assert isinstance(steps, int), f"`steps` should be a whole number, but it is {steps!r}."
assert steps not in (3200, 1500, 4800), f"`steps` is {steps}, just one walk. Did you use `=` instead of `+=`, replacing the total instead of adding to it?"
assert steps == 3200 + 1500 + 4800, f"`steps` should be the total of all three walks, but it is {steps}."
assert "Total steps today:" in _stdout, "Keep the final `print` line so the total is shown."
--- hint
`steps += 3200` means "add 3200 to whatever `steps` currently is."
--- hint
Replace the `...` with three lines, each one `steps += <number of steps>`.
```

## Debug challenge: the order of updates matters

Because Python runs top to bottom, a calculation uses the values variables have **at that moment**. Change a variable later, and earlier results don't update themselves.

```python debug id=early-bird title="The discount isn't in the total"
ticket_price = 40
tickets = 3

total = ticket_price * tickets
ticket_price -= 10    # early-bird discount

print("Price per ticket:", ticket_price)
print("Total to pay:", total)
--- solution
ticket_price = 40
tickets = 3

ticket_price -= 10    # early-bird discount
total = ticket_price * tickets

print("Price per ticket:", ticket_price)
print("Total to pay:", total)
--- test
assert ticket_price == 30, f"`ticket_price` should be 30 after the early-bird discount, but it is {ticket_price}."
assert total != 120, "The total is still 120, the price *before* the discount. When was `total` calculated?"
assert total == ticket_price * tickets, f"`total` ({total}) should equal the discounted price times the number of tickets ({ticket_price * tickets})."
--- hint
Run it. Each ticket costs 30, and there are 3 tickets, but the total says 120. Which price was used to compute the total?
--- hint
`total` is calculated once, on the line where it's assigned. It doesn't recalculate when `ticket_price` changes later. Reorder two lines.
```

## Naming variables well

Python has a few hard **rules** for names, and the community has strong **conventions** on top.

**The rules** (break them and you get a `SyntaxError`):

- Use letters, digits and underscores `_` only. No spaces, dashes or symbols.
- Don't start with a digit: `player2` is fine, `2player` isn't.
- Don't use Python's **reserved words** (keywords), like `if`, `for`, `class`, `True`, `None` or `def`. They already mean something.

```python run error
2nd_place = "Ana"
```

*"invalid decimal literal"* is Python's way of saying "this starts like a number, but then it has letters in it". Names can't start with a digit.

**The conventions** (Python won't complain, but other programmers will):

| Name | Verdict | Why |
|---|---|---|
| `total_price` | great | lowercase words joined by underscores: **snake_case** |
| `x`, `tp` | poor | short names hide meaning (fine for tiny maths) |
| `TotalPrice` | unusual | this style is reserved for *classes* (lesson 26) |
| `total price` | invalid | spaces aren't allowed |
| `total-price` | invalid | Python reads `-` as minus |
| `class` | invalid | a reserved word |

Names are also **case-sensitive**. `Score` and `score` are two completely separate variables:

```python run
score = 10
Score = 99
print("score:", score, "| Score:", Score)
```

> **In the wild:** professional Python follows **PEP 8**, the official style guide, which asks for `snake_case` names. Tools like Ruff and Black check and fix this automatically in most companies' code. A good name saves a reader from needing a comment: `seconds_until_launch` explains itself; `s` doesn't.

```python debug id=checkout-typo title="The checkout crashes before the total"
item_price = 12
quantity = 3

sub_total = item_price * quantity
tax = subtotal * 0.25
total = sub_total + tax

print("Total to pay:", total)
--- solution
item_price = 12
quantity = 3

sub_total = item_price * quantity
tax = sub_total * 0.25
total = sub_total + tax

print("Total to pay:", total)
--- test
assert tax == item_price * quantity * 0.25, f"`tax` should be 25% of the subtotal, but it is {tax}."
assert total == item_price * quantity * 1.25, f"`total` should be the subtotal plus tax ({item_price * quantity * 1.25}), but it is {total}."
assert "Total to pay:" in _stdout, "Keep the `print` line so the customer sees the total."
--- hint
Run it and read the last line of the error. Which name does Python say is not defined?
--- hint
Compare the name used on the `tax = ...` line with the name created on the line above it, character by character.
```

## Multiple assignment and swapping

You can assign several variables in one line by separating names and values with commas. The first name gets the first value, and so on:

```python run
home, away = 3, 1
print("Final score:", home, "-", away)
```

This makes one classic task beautifully easy: **swapping** two values. Here's the trap first. Try to predict it:

```python predict id=predict-naive-swap title="A swap that goes wrong"
left = "Hey Jude"
right = "Yesterday"
left = right
right = left
print(left, "|", right)
--- options
Yesterday | Hey Jude
* Yesterday | Yesterday
Hey Jude | Hey Jude
Hey Jude | Yesterday
--- explain
After `left = right`, *both* names are on `"Yesterday"`, and nothing refers to `"Hey Jude"` any more. So `right = left` just puts `right` on `"Yesterday"` again. The original value of `left` was lost before it could be copied.
```

Python's multiple assignment solves this. It works out **every value on the right first**, then assigns them all at once, so nothing gets overwritten too early:

```python run
left = "Hey Jude"
right = "Yesterday"
left, right = right, left
print(left, "|", right)
```

> **Coming from another language:** in many languages a swap needs a temporary variable (`temp = a; a = b; b = temp`). That works in Python too, but `a, b = b, a` is the Pythonic way.

```python exercise id=podium-swap title="Fix the podium"
# The judges made a mistake: the gold and silver medallists
# should be the other way round.
gold = "Mei"
silver = "Ravi"
bronze = "Lucia"

# TODO: swap the values of `gold` and `silver` using ONE line
# of multiple assignment. Leave `bronze` alone.
...

print("Gold:", gold, "| Silver:", silver, "| Bronze:", bronze)
--- solution
gold = "Mei"
silver = "Ravi"
bronze = "Lucia"

gold, silver = silver, gold

print("Gold:", gold, "| Silver:", silver, "| Bronze:", bronze)
--- test
assert not (gold == "Mei" and silver == "Ravi"), "Gold and silver haven't been swapped yet. Replace the `...` with your swap."
assert gold != silver, f"`gold` and `silver` are both {gold!r}. One value was overwritten before it was copied. Try swapping both at once with commas."
assert gold == "Ravi" and silver == "Mei", f"After the swap, `gold` should be 'Ravi' and `silver` should be 'Mei', but they are {gold!r} and {silver!r}."
assert bronze == "Lucia", f"`bronze` should still be 'Lucia', but it is {bronze!r}."
--- hint
Look at the swap example just above this challenge: names on the left, values on the right, separated by commas.
--- hint
The pattern is `first, second = second, first`, using `gold` and `silver`.
```

## What kind of value is it? A peek at `type()`

Every value in Python has a **type**, its kind. You've already seen the little type chip next to cell results. You can ask for it directly with `type()`:

```python run
print(type(26))
print(type(26.5))
print(type("Barcelona"))
type(True)
```

| Type | Short for | Examples |
|---|---|---|
| `int` | integer, a whole number | `26`, `-3`, `1000000` |
| `float` | floating-point, a number with a decimal point | `26.5`, `0.1`, `3.0` |
| `str` | string, a piece of text | `"Barcelona"`, `'26'` |
| `bool` | Boolean, true or false | `True`, `False` |

Notice that `"26"` in quotes would be a `str`, not an `int`: quotes always make text. You'll study numbers in the next lesson, text in lesson 5, and `True`/`False` in lesson 7.

### A name can switch types

Python doesn't fix a variable to one type. A name is just a tag, and you can move it onto any kind of value. This is called **dynamic typing**:

```python run
answer = 42
print(answer, "is a", type(answer))

answer = "forty-two"
print(answer, "is a", type(answer))
```

That's flexible, but use it with care: a variable called `price` that's sometimes a number and sometimes text is a bug waiting to happen. Good practice is to keep each name holding one kind of thing.

> **Coming from another language:** there are no declarations like `int x;` in Python. A variable comes into existence the first time you assign to it.

## Recap

- A **variable** is a name tag on a value: `price = 3.5`. The right side is worked out first, then the name is attached.
- Reassigning moves the tag; `b = a` copies the *current* value, not a permanent link.
- Update with `x = x + 1` or the shortcuts `+=`, `-=`, `*=`, `/=`. The variable must already exist.
- Calculations use values **as they are at that moment**, so the order of lines matters.
- Name things in descriptive `snake_case`; no leading digits, spaces or reserved words, and remember names are case-sensitive.
- `a, b = 1, 2` assigns several names at once, and `a, b = b, a` swaps. `type()` tells you a value's kind: `int`, `float`, `str`.

**Up next:** numbers and arithmetic: whole numbers vs decimals, the operators `//`, `%` and `**`, and why `0.1 + 0.2` isn't quite `0.3`.
