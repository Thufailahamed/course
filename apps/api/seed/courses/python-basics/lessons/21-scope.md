Two of your functions both use a variable called `total`. Does one overwrite the other? Your program has a `score` at the top, and a function that tries to add a point to it, and Python crashes with an error you've never seen. You named a variable `sum`, and three cells later `sum([1, 2, 3])` says `'int' object is not callable`.

All three puzzles have the same answer: **scope**, the rules for *where a name lives* and *which part of the code can see it*. Think of each function call as its own little room with its own sticky notes on the wall. Code in the room can glance out of the window at the notes in the hallway, but it writes on its own wall. Once you see code this way, those confusing errors become obvious, and you'll understand why good functions take everything they need as parameters and hand results back with `return`.

## Local variables live inside the function

A variable created inside a function is **local**: it exists only while that call is running, and only code inside the function can see it.

```python run
def checkout(subtotal):
    discount = subtotal * 0.1          # local to checkout
    return subtotal - discount

print("to pay:", checkout(80))
```

The function used `discount` just fine. But from outside, there's no such name:

```python run error
print(discount)
```

When `checkout` returned, its room was cleared out, sticky notes and all. Only the **returned value** made it out. That's a feature: a function's helper variables can't leak out and collide with yours.

Every call also gets a **brand-new** room. Local variables don't remember anything from the previous call:

```python run
def count_vowels(word):
    count = 0                          # starts at 0 on EVERY call
    for letter in word.lower():
        if letter in "aeiou":
            count += 1
    return count

print(count_vowels("banana"), count_vowels("sky"), count_vowels("Ouagadougou"))
```

## Parameters are local too

A parameter is just a local variable that gets filled in from the call. Reassigning it inside the function changes the function's own note, not the caller's variable:

```python run
def apply_coupon(price):
    price = price - 5          # rebinds the LOCAL name `price`
    return price

price = 30
new_price = apply_coupon(price)
print("price:", price, "| new_price:", new_price)
```

Two different `price`s: one in the hallway (the global, still 30), one inside the function's room (25). The only way the result gets out is `return`.

> **Pitfall:** Reassigning a parameter (`items = [...]`) only changes the local name. But *mutating* the object it refers to (`items.append(...)`, `scores[0] = 99`) changes the one list both names point to, exactly like the aliasing you saw in lesson 14. If a function shouldn't change a list it was given, work on a copy.

```python predict id=predict-param-local title="What does this print?"
lives = 3

def lose_life(lives):
    lives = lives - 1
    return lives

lose_life(lives)
print(lives)
--- options
2
* 3
None
UnboundLocalError
--- explain
Inside `lose_life`, `lives` is a **parameter**, a local name. Subtracting 1 rebinds only that local. The function returns 2, but nobody stores the result, so the global `lives` is still 3. You'd need `lives = lose_life(lives)`.
```

```python exercise id=sale-prices title="A sale that leaves the menu alone"
# TODO: return a NEW list where every price is reduced by `percent`
# percent, rounded to 2 decimals. The list passed in must NOT change.
#   discounted([10.0, 4.5], 20) -> [8.0, 3.6]
def discounted(prices, percent):
    """Return a new list of prices reduced by `percent` percent."""
    ...

menu = [10.0, 4.5, 8.0]
sale = discounted(menu, 20)
print("sale:", sale)
print("menu:", menu)
--- solution
def discounted(prices, percent):
    """Return a new list of prices reduced by `percent` percent."""
    result = []
    for p in prices:
        result.append(round(p * (1 - percent / 100), 2))
    return result

menu = [10.0, 4.5, 8.0]
sale = discounted(menu, 20)
print("sale:", sale)
print("menu:", menu)
--- test
probe = [10.0, 4.5, 8.0]
out = discounted(probe, 20)
assert out is not None, "`discounted` gave back `None`. Replace the `...` with code that returns a new list."
assert isinstance(out, list), f"`discounted` should return a list, but returned {out!r}."
assert probe == [10.0, 4.5, 8.0], f"The list passed in was changed to {probe!r}. Build a new list instead of changing `prices` in place."
assert out is not probe, "You returned the same list object you were given. Return a brand-new list."
assert out == [8.0, 3.6, 6.4], f"`discounted([10.0, 4.5, 8.0], 20)` should be [8.0, 3.6, 6.4], but is {out!r}."
fresh = [100, 19.99]
assert discounted(fresh, 15) == [85.0, 16.99], f"`discounted([100, 19.99], 15)` should be [85.0, 16.99], but is {discounted(fresh, 15)!r}."
assert discounted([], 50) == [], "An empty menu should give an empty list."
--- hint
A price reduced by 20% is `price * (1 - 20 / 100)`.
--- hint
Start with an empty list, append each new price in a loop, and return that new list. (A list comprehension works too.) Never assign into `prices[i]`.
```

## Globals: readable from anywhere

A variable created at the top level of your program (outside any function) is **global**. Functions can **read** globals without doing anything special:

```python run
TAX_RATE = 0.2          # a global constant

def with_tax(amount):
    return round(amount * (1 + TAX_RATE), 2)    # reading a global: fine

print(with_tax(50), with_tax(19.99))
```

> **Tip:** Writing a global in `UPPER_CASE` is a convention meaning "this is a constant; nobody changes it." Reading global *constants* from functions is perfectly normal and good style. Things get messy when functions start *changing* globals, as you'll see below.

## How Python finds a name: LEGB

When Python meets a name, it searches four places, **in order**, and uses the first match:

```text
 L  Local      names created in the current function call
 E  Enclosing  names in any function wrapped around this one (see the end of the lesson)
 G  Global     names created at the top level of the program
 B  Built-in   Python's own names: print, len, sum, max, str, ...
```

That's why `len` works everywhere (it's found in Built-in), and why a local variable **hides** a global with the same name: Local is checked first.

```python run
city = "Paris"                  # global

def postcard():
    city = "Kyoto"              # local: hides the global inside this function
    return f"Greetings from {city}!"

print(postcard())
print("global city is still:", city)
```

```python predict id=predict-legb title="What does this print?"
greeting = "Hello"

def welcome(name):
    greeting = "Welcome"
    return f"{greeting}, {name}"

print(welcome("Kai"), greeting)
--- options
Hello, Kai Hello
Welcome, Kai Welcome
* Welcome, Kai Hello
Hello, Kai Welcome
--- explain
Inside `welcome`, the assignment creates a **local** `greeting`, so the function uses `"Welcome"`. Outside, the global `greeting` was never touched and is still `"Hello"`.
```

## Changing a global: the UnboundLocalError

Here's the crash from the introduction. A game keeps a global `score`, and a function tries to add a point:

```python run error
score = 0

def add_point():
    score = score + 1
    return score

add_point()
```

`cannot access local variable 'score' where it is not associated with a value`. Why "local"? Because of one simple rule:

> **Under the hood:** Python decides whether a name is local **before** the function runs, by scanning the whole body. If the name is **assigned anywhere** in the function (`=`, `+=`, a `for` loop variable…), it's local for the **entire** function. So in `score = score + 1`, the `score` on the right is the local one too, and it doesn't have a value yet.

You can tell Python "I mean the global one" with the `global` keyword:

```python run
score = 0

def add_point():
    global score         # assignments now go to the global `score`
    score = score + 1

add_point()
add_point()
print("score:", score)
```

It works, but most experienced programmers avoid `global`. A function that secretly changes the outside world is hard to test (you must reset the global before every check), hard to reuse (it only works with *that one* variable) and hard to debug (any function might have changed `score`). The cleaner design passes the value **in** and hands the new value **back**:

```python run
def add_points(score, points=1):
    return score + points

score = 0
score = add_points(score)
score = add_points(score, 5)
print("score:", score)
```

Now `add_points` works for any player's score, and the line `score = add_points(score, 5)` shows exactly where `score` changes.

| | Changes a global with `global` | Takes parameters, returns a result |
|---|---|---|
| Where the change happens | hidden inside the function | visible at the call: `x = f(x)` |
| Works with other variables? | only that one global | any value you pass |
| Easy to test? | must set up and reset the global | just call it and check the return |

```python debug id=visit-counter title="The visit counter crashes"
visits = 0

def record_visit():
    """Add one to the site's visit counter."""
    visits += 1

record_visit()
record_visit()
record_visit()
print("visits:", visits)
--- solution
visits = 0

def record_visit(count):
    """Return the visit counter plus one."""
    return count + 1

visits = record_visit(visits)
visits = record_visit(visits)
visits = record_visit(visits)
print("visits:", visits)
--- test
assert visits == 3, f"After three visits, `visits` should be 3, but it is {visits!r}."
assert "visits: 3" in _stdout, "Keep the final print so the count is shown."
if record_visit.__code__.co_argcount == 1:
    assert record_visit(41) == 42, "`record_visit(count)` should return the count plus one."
else:
    before = visits
    record_visit()
    assert visits == before + 1, "Each call to `record_visit()` should add one to `visits`."
--- hint
Run it and read the error: Python says `visits` is a *local* variable. Which line inside the function assigns to `visits`?
--- hint
Quick fix: declare `global visits` at the top of the function body. Cleaner fix: give the function a `count` parameter, `return count + 1`, and store the result with `visits = record_visit(visits)`.
```

```python exercise id=weekly-pay title="Payroll without globals"
# This version depends on globals, so it can only ever pay ONE person:
hours_worked = 45
hourly_rate = 20.0

def pay_for_this_week():
    return hours_worked * hourly_rate

# TODO: write `weekly_pay(hours, rate)` that uses ONLY its parameters.
# Hours up to 40 are paid at `rate`; every hour over 40 is paid at 1.5 x rate.
#   weekly_pay(45, 20.0) -> 40*20 + 5*30 = 950.0
#   weekly_pay(30, 15.0) -> 450.0
def weekly_pay(hours, rate):
    """Return the pay for a week, with time-and-a-half after 40 hours."""
    ...

print("Ana:", weekly_pay(45, 20.0))
print("Ben:", weekly_pay(30, 15.0))
--- solution
hours_worked = 45
hourly_rate = 20.0

def pay_for_this_week():
    return hours_worked * hourly_rate

def weekly_pay(hours, rate):
    """Return the pay for a week, with time-and-a-half after 40 hours."""
    if hours <= 40:
        return hours * rate
    overtime = hours - 40
    return 40 * rate + overtime * rate * 1.5

print("Ana:", weekly_pay(45, 20.0))
print("Ben:", weekly_pay(30, 15.0))
--- test
assert weekly_pay(45, 20.0) is not None, "`weekly_pay` gave back `None`. Replace the `...` with code that returns the pay."
assert weekly_pay(30, 15.0) == 450.0, f"30 hours at $15 should be 450.0 (no overtime), but got {weekly_pay(30, 15.0)!r}."
assert weekly_pay(45, 20.0) == 950.0, f"45 hours at $20 should be 950.0 (40 normal + 5 overtime at $30), but got {weekly_pay(45, 20.0)!r}."
assert weekly_pay(40, 10.0) == 400.0, f"Exactly 40 hours has no overtime: expected 400.0, got {weekly_pay(40, 10.0)!r}."
hours_worked, hourly_rate = 1, 1
assert weekly_pay(50, 12.0) == 660.0, f"50 hours at $12 should be 660.0, but got {weekly_pay(50, 12.0)!r}. Does your function still read the globals instead of its parameters?"
assert weekly_pay(0, 25.0) == 0, "0 hours should pay 0."
--- hint
Inside `weekly_pay`, use only `hours` and `rate`. Never `hours_worked` or `hourly_rate`.
--- hint
If `hours <= 40`, the answer is simply `hours * rate`. Otherwise split it into the first 40 hours and the overtime hours.
--- hint
Overtime pay is `(hours - 40) * rate * 1.5`, added to `40 * rate`.
```

## Shadowing built-ins

The **B** in LEGB holds Python's built-in names: `print`, `len`, `sum`, `max`, `min`, `list`, `str`, `input`, `type`… They're not reserved words, so nothing stops you from creating a global with the same name. And because Global is checked *before* Built-in, your variable then **hides** the built-in:

```python run error
prices = [4.50, 12.00, 3.25]

sum = 0                       # a natural name for a running total...
for p in prices:
    sum += p
print("total:", sum)

sum([1, 2, 3])                # ...but now `sum` is a float, not the function
```

`'float' object is not callable` means "you put `(...)` after something that isn't a function." Here, `sum` now refers to `19.75`. This is called **shadowing**, and it's especially sneaky in a notebook, where the broken name sticks around for every later cell. To get the built-in back, delete your variable so the lookup falls through to Built-in again:

```python run
del sum                       # remove the global; `sum` is the built-in again
sum([1, 2, 3])
```

The real fix is prevention: pick names that say what the value *is*: `total`, `cart_total`, `highest_temp`, `word_list`.

| Tempting name | Shadows | Better name |
|---|---|---|
| `sum` | `sum()` | `total` |
| `max`, `min` | `max()`, `min()` | `highest`, `best_score`, `lowest_price` |
| `list`, `dict` | `list()`, `dict()` | `items`, `prices`, `lookup` |
| `str`, `input` | `str()`, `input()` | `text`, `answer` |
| `type`, `id` | `type()`, `id()` | `kind`, `user_id` |

> **Tip:** Most code editors color built-in names differently. If your variable name lights up in the "built-in" color, rename it.

```python debug id=shadowed-max title="max() stopped working"
temps = [18, 24, 21, 30, 27]

# Find the hottest day by hand.
max = temps[0]
for t in temps:
    if t > max:
        max = t
print("hottest this week:", max)

# Later in the program...
last_weekend = [12, 15, 9]
weekend_high = max(last_weekend)
print("weekend high:", weekend_high)
--- solution
temps = [18, 24, 21, 30, 27]

# Find the hottest day by hand.
hottest = temps[0]
for t in temps:
    if t > hottest:
        hottest = t
print("hottest this week:", hottest)

# Later in the program...
last_weekend = [12, 15, 9]
weekend_high = max(last_weekend)
print("weekend high:", weekend_high)
--- test
assert callable(max), "`max` still refers to a number, not the built-in function. Rename the variable that holds the hottest temperature."
assert weekend_high == 15, f"`weekend_high` should be 15, but is {weekend_high!r}."
assert "hottest this week: 30" in _stdout, "Keep printing the hottest temperature of the week (30)."
assert "weekend high: 15" in _stdout, "Print the weekend high too."
--- hint
Run it and read the last line of the error: `'int' object is not callable`. Which name was being called with `(...)`, and what does that name hold now?
--- hint
The hand-written loop reuses the name `max` for a number. Give that variable its own name (like `hottest`) everywhere it appears in the loop and print.
```

## A peek at nested functions (the E in LEGB)

You can define a function *inside* another function. The inner one is local to the outer one, and it can **read** the outer function's variables. That outer layer is the **Enclosing** scope.

```python run
def print_receipt(items, currency="$"):
    def line(name, price):                     # a helper only print_receipt needs
        return f"{name:<12}{currency}{price:>7.2f}"   # reads `currency` from the enclosing function

    for name, price in items:
        print(line(name, price))
    print(line("TOTAL", sum(price for name, price in items)))

print_receipt([("Coffee", 3.5), ("Bagel", 2.25), ("Juice", 4.0)])
```

Nested helpers keep a big function tidy without adding more names to the global scope. They're also the doorway to powerful ideas like **closures** and **decorators**, which you'll meet in *Python Advanced*. For now, just recognize the pattern when you see it.

## Recap

- Variables created inside a function, including its parameters, are **local**: each call gets fresh ones, and they vanish when the call ends. Only the return value gets out.
- Python looks names up in **LEGB** order: Local, Enclosing, Global, Built-in. The first match wins, so a local hides a global with the same name.
- Functions can **read** globals freely. **Assigning** to a name anywhere in a function makes it local everywhere in that function, which is what causes `UnboundLocalError`.
- `global name` lets a function rebind a global, but passing values in and returning results out (`x = f(x)`) is cleaner, more reusable and easier to test.
- Don't name variables `sum`, `max`, `list`, `str`… You'll shadow the built-in. If you do, `del` your variable to get it back.

**Up next:** the built-in toolkit: `sorted` with `key` and `lambda`, `enumerate`, `zip`, `any`/`all` and more power tools that replace a lot of hand-written loops.
