So far, every program you've written has been a straight road: Python runs line 1, then line 2, then line 3, all the way to the end, every single time. Real programs aren't like that. A shop charges shipping *unless* your cart is over $50. A game shows "Game over" *only when* your lives hit zero. A banking app refuses a withdrawal *if* it would overdraw your account. Every one of those is a **decision**, and decisions are what turn a calculator into a program.

In this lesson you'll teach Python to choose. You'll write `if`, `else` and `elif` statements, learn why indentation is part of Python's grammar (not just decoration), and build real decision logic: shipping tiers, ticket prices and the famously tricky leap-year rule. You'll also learn the two bugs that trip up almost everyone: branches in the wrong order, and a line indented one level too far.

```python setup
# Hidden checker helper: lets the tests re-run your challenge code with other starting values.
import contextlib as _contextlib, io as _io, linecache as _linecache, re as _re

def _rerun(**values):
    src = "".join(_linecache.cache["<cell>"][2])
    for name, value in values.items():
        src, found = _re.subn(rf"(?m)^{name}\s*=(?!=).*$", f"{name} = {value!r}", src, count=1)
        assert found, f"Keep the line `{name} = ...` in your code so the checker can try other values."
    ns = {k: v for k, v in globals().items() if k in _SETUP_NAMES}
    out = _io.StringIO()
    try:
        with _contextlib.redirect_stdout(out):
            exec(compile(src, "<cell>", "exec"), ns)
    except Exception as e:
        settings = ", ".join(f"{k} = {v!r}" for k, v in values.items())
        raise AssertionError(f"With {settings}, your code crashed with {type(e).__name__}: {e}")
    ns["_out"] = out.getvalue()
    return ns

_SETUP_NAMES = set(globals()) | {"_SETUP_NAMES"}
```

## Your first `if`

An `if` statement asks a yes/no question. If the answer is `True`, Python runs the indented lines underneath. If it's `False`, Python skips them.

```python run
temperature = 31

if temperature > 25:
    print("It's a hot one. Grab some water!")

print("Weather check done.")
```

Change `temperature` to `18` and run it again. The first message disappears, but `"Weather check done."` still prints, because it isn't indented under the `if`.

Every `if` has the same shape:

```python
if condition:
    # indented lines run only when condition is True
    ...
# unindented lines always run
```

- The **condition** is any expression that produces `True` or `False`, like the comparisons and `and`/`or` logic from lesson 7.
- The line ends with a **colon** `:`. Forgetting it is a `SyntaxError`.
- The lines that belong to the `if` are **indented** by 4 spaces. That group of lines is called a **block**.

Here's the same program as a picture. The road splits at the question and joins back together afterwards:

```text
              temperature > 25 ?
               /            \
            True            False
             |                |
   print("It's a hot one…")   |   (skipped)
               \            /
         print("Weather check done.")   ← always runs
```

## Indentation is the structure

In many languages, curly braces `{ }` mark where a block starts and ends, and indentation is just for humans. In Python, **indentation is the grammar**. A block is every consecutive line indented under the colon. The first line that goes back to the outer level ends the block.

```python run
balance = 40
price = 55

if price > balance:
    shortfall = price - balance
    print("Card declined.")
    print("You need", shortfall, "more.")

print("Thanks for shopping with us.")
```

All three indented lines belong to the `if`, so they run together or not at all. Set `price = 25` and run again: only the thank-you line prints.

```python predict id=predict-indent-skip title="Which lines run?"
temperature = 15
if temperature > 25:
    print("Wear shorts")
print("Have a nice day")
--- options
Wear shorts
* Have a nice day
Nothing is printed
An IndentationError
--- explain
`15 > 25` is `False`, so the indented block (`print("Wear shorts")`) is skipped. The last `print` is **not** indented, so it's outside the `if` and runs no matter what.
```

If a line that should be inside the block isn't indented, Python can't tell what the `if` is supposed to do. Run this to see the error:

```python run error
temperature = 30
if temperature > 25:
print("It's hot!")
```

Read the last line of the error first: `IndentationError: expected an indented block after 'if' statement on line 2`. Python is telling you exactly what's wrong and where. An `if` must have at least one indented line under it.

> **Tip:** Use 4 spaces per level (the editor inserts them when you press **Tab**). Never mix tabs and spaces in one file. They can look identical on screen and still confuse Python.

## `else`: the other road

Often you want to do one thing when the condition is true and something *different* when it's false. That's `else`. It has no condition of its own: it catches everything the `if` didn't.

```python run
order_number = 1047

if order_number % 2 == 0:
    print("Order", order_number, "ships from the north warehouse.")
else:
    print("Order", order_number, "ships from the south warehouse.")
```

Exactly one of the two blocks runs, never both and never neither. Notice `else:` lines up with `if`, not with the indented lines, and it also ends in a colon.

A common pattern is to give a variable a value in each branch, then use it afterwards:

```python run
password = "sunflower42"

if len(password) >= 8:
    verdict = "strong enough"
else:
    verdict = "too short"

print(f"Your password is {verdict}.")
```

```python exercise id=free-shipping title="Free shipping over $50"
cart_total = 42.50

# TODO: use if/else to set `shipping`:
#   0 when cart_total is 50 or more
#   4.99 otherwise
shipping = ...

print("Shipping:", shipping)
--- solution
cart_total = 42.50

if cart_total >= 50:
    shipping = 0
else:
    shipping = 4.99

print("Shipping:", shipping)
--- test
assert shipping is not ..., "Replace `shipping = ...` with an if/else that sets `shipping` to 0 or 4.99."
assert isinstance(shipping, (int, float)), f"`shipping` should be a number (0 or 4.99), but it is {shipping!r}."
assert shipping == 4.99, f"A $42.50 cart is under $50, so `shipping` should be 4.99, but it is {shipping!r}."
for total, want in [(50, 0), (49.99, 4.99), (120.0, 0), (0.5, 4.99)]:
    got = _rerun(cart_total=total).get("shipping")
    assert got == want, f"With cart_total = {total}, `shipping` should be {want} but is {got!r}. Check your condition (is exactly 50 included?)."
--- hint
The question is "is the cart total 50 or more?". Which comparison operator means "or more"?
--- hint
`if cart_total >= 50:` then set `shipping = 0`; under an `else:` set `shipping = 4.99`. Remember the colons and the indentation.
```

## `elif`: more than two roads

Life is rarely just yes or no. A grade can be A, B, C, D or F. For several choices, chain conditions with `elif` (short for "else if"):

```python run
score = 83

if score >= 90:
    grade = "A"
elif score >= 80:
    grade = "B"
elif score >= 70:
    grade = "C"
elif score >= 60:
    grade = "D"
else:
    grade = "F"

print("Score", score, "earns a", grade)
```

Python checks the conditions **from top to bottom** and runs the block of the **first one that's true**. Then it skips the rest of the chain entirely. So for `83`, Python asks "≥ 90?" (no), "≥ 80?" (yes) and stops there. It never even looks at `>= 70`, even though that's also true.

That's why `elif score >= 80` doesn't need to say `and score < 90`: if the score were 90 or more, the first branch would already have won.

| Keyword | Has a condition? | How many per chain | When its block runs |
|---|---|---|---|
| `if` | yes | exactly 1, at the start | its condition is true |
| `elif` | yes | 0 or more | every branch above was false, and its condition is true |
| `else` | no | 0 or 1, at the end | every branch above was false |

> **Under the hood:** At most one block in an `if`/`elif`/`else` chain ever runs. With an `else` at the end, *exactly* one runs. That guarantee is why chains are perfect for sorting things into categories.

Because the first true condition wins, **the order of the branches matters**. Look carefully at this one before you answer:

```python predict id=predict-first-match title="First match wins"
score = 95
if score >= 60:
    grade = "D"
elif score >= 70:
    grade = "C"
elif score >= 90:
    grade = "A"
else:
    grade = "F"
print(grade)
--- options
A
* D
F
D C A
--- explain
`95 >= 60` is already `True`, so the very first branch wins and the chain stops. The `>= 90` test is never reached. When ranges overlap like this, put the **strictest** check first (highest threshold at the top).
```

```python debug id=shipping-tiers-order title="Heavy parcels get a cheap rate"
# Rates:  up to 1 kg: 2.99   over 1 kg: 4.99   over 5 kg: 9.99   over 10 kg: 19.99
weight_kg = 12

if weight_kg > 1:
    shipping = 4.99
elif weight_kg > 5:
    shipping = 9.99
elif weight_kg > 10:
    shipping = 19.99
else:
    shipping = 2.99

print(f"Shipping for {weight_kg} kg: ${shipping}")
--- solution
# Rates:  up to 1 kg: 2.99   over 1 kg: 4.99   over 5 kg: 9.99   over 10 kg: 19.99
weight_kg = 12

if weight_kg > 10:
    shipping = 19.99
elif weight_kg > 5:
    shipping = 9.99
elif weight_kg > 1:
    shipping = 4.99
else:
    shipping = 2.99

print(f"Shipping for {weight_kg} kg: ${shipping}")
--- test
assert shipping == 19.99, f"A 12 kg parcel should cost 19.99 to ship, but `shipping` is {shipping!r}. Which branch won?"
for w, want in [(0.5, 2.99), (1, 2.99), (3, 4.99), (5, 4.99), (7, 9.99), (10, 9.99), (10.5, 19.99), (40, 19.99)]:
    got = _rerun(weight_kg=w).get("shipping")
    assert got == want, f"With weight_kg = {w}, `shipping` should be {want} but is {got!r}."
--- hint
Run it: a 12 kg parcel is charged 4.99. Which condition is checked first, and is it true for 12?
--- hint
`12 > 1` is true, so the first branch wins before the heavier tiers are ever checked. Put the strictest check (the biggest weight) at the top.
```

```python exercise id=ticket-prices title="Cinema ticket prices"
age = 34

# TODO: use if/elif/else to set `price` from the visitor's age:
#   under 3        -> 0   (free)
#   3 to 12        -> 8   (child)
#   13 to 64       -> 14  (adult)
#   65 and over    -> 9   (senior)
price = ...

print(f"Ticket for age {age}: ${price}")
--- solution
age = 34

if age < 3:
    price = 0
elif age <= 12:
    price = 8
elif age <= 64:
    price = 14
else:
    price = 9

print(f"Ticket for age {age}: ${price}")
--- test
assert price is not ..., "Replace `price = ...` with an if/elif/else chain that sets `price`."
assert isinstance(price, (int, float)), f"`price` should be a number, but it is {price!r}."
assert price == 14, f"A 34-year-old pays the adult price (14), but `price` is {price!r}."
for a, want in [(1, 0), (2, 0), (3, 8), (12, 8), (13, 14), (40, 14), (64, 14), (65, 9), (90, 9)]:
    got = _rerun(age=a).get("price")
    assert got == want, f"With age = {a}, `price` should be {want} but is {got!r}. Check the boundary ages carefully."
--- hint
Work from the youngest group upwards (or the oldest downwards). Each `elif` only needs the upper limit, because earlier branches already handled the smaller ages.
--- hint
Start with `if age < 3:` for the free tickets. Then `elif age <= 12:` for children. What comes next?
```

## Nested `if`s, or `and`?

You can put an `if` inside another `if`'s block. The inner one is only reached when the outer condition is true:

```python run
username = "maya"
password = "tulip-77"

if username == "maya":
    if password == "tulip-77":
        print("Welcome back, Maya!")
    else:
        print("Wrong password.")
else:
    print("No such user.")
```

Nesting is the right tool when each level needs its *own* `else` (here, different error messages). But when you only care whether *both* things are true, `and` says it in one flat line:

```python run
temperature = 24
is_raining = False

if temperature > 20 and not is_raining:
    print("Picnic weather!")
else:
    print("Maybe a museum today.")
```

> **Tip:** Every level of nesting is one more thing a reader has to hold in their head. If you see an `if` whose only content is another `if` with no `else`, merge them with `and`. Flat is better than nested (that's literally a line in *The Zen of Python*; run `import this` sometime).

This next challenge is a classic. The leap-year rule has an exception *and* an exception to the exception, so it's a great test of careful decision logic.

```python exercise id=leap-year title="Leap year detective"
year = 2024

# A year is a leap year if it is divisible by 4,
# EXCEPT years divisible by 100 are not leap years,
# EXCEPT years divisible by 400 are leap years after all.
#   2024 -> True   2023 -> False   1900 -> False   2000 -> True
# TODO: set `is_leap` to True or False (use if/elif/else, or one boolean expression).
is_leap = ...

print(year, "is a leap year:", is_leap)
--- solution
year = 2024

if year % 400 == 0:
    is_leap = True
elif year % 100 == 0:
    is_leap = False
elif year % 4 == 0:
    is_leap = True
else:
    is_leap = False

print(year, "is a leap year:", is_leap)
--- test
assert is_leap is not ..., "Replace `is_leap = ...` with your decision logic."
assert isinstance(is_leap, bool), f"`is_leap` should be True or False, but it is {is_leap!r}."
assert is_leap is True, "2024 is divisible by 4 (and not by 100), so it is a leap year."
for y, want in [(2023, False), (1900, False), (2000, True), (2100, False), (2400, True), (1996, True), (2019, False)]:
    got = _rerun(year=y).get("is_leap")
    assert got == want, f"With year = {y}, `is_leap` should be {want} but is {got!r}."
--- hint
"Divisible by 4" means `year % 4 == 0`: the remainder is zero.
--- hint
Check the most specific rule first: is it divisible by 400? Then by 100? Then by 4? The first match decides.
--- hint
Or as one expression: `year % 4 == 0 and (year % 100 != 0 or ...)`. What belongs in the gap?
```

## Separate `if`s vs one chain

An `elif` chain picks **one** branch. A row of separate `if` statements is different: each one is its own independent question, so several (or all, or none) can run.

```python predict id=predict-separate-ifs title="How many badges?"
points = 120
badges = ""
if points >= 50:
    badges += "bronze "
if points >= 100:
    badges += "silver "
if points >= 200:
    badges += "gold "
print(badges.strip())
--- options
silver
bronze
* bronze silver
bronze silver gold
--- explain
These are three **separate** `if` statements, not an `elif` chain, so Python asks all three questions. 120 passes the first two, so both badges are added. If the second and third were `elif`, only `bronze` would be awarded.
```

Choose deliberately:

| You want… | Use |
|---|---|
| exactly one category (grade, price tier, shipping rate) | one `if`/`elif`/`else` chain |
| every rule that applies (badges, warnings, discounts that stack) | separate `if` statements |

## Truthiness in conditions

A condition doesn't have to be a comparison. Python accepts any value and uses its truthiness, which you met in lesson 7: `0`, `0.0` and `""` count as false, and nearly everything else counts as true. That makes "is this empty?" checks short and readable:

```python run
nickname = "   "

if nickname.strip():
    print("Hello,", nickname.strip())
else:
    print("Please choose a nickname.")
```

`nickname.strip()` removes the spaces and leaves `""`, which is falsy, so the `else` runs. Try `nickname = "  Leo "`.

> **Pitfall:** When comparing text that came from a person, normalize it first. `answer == "yes"` is `False` for `"Yes"` or `"yes "`. Write `answer.strip().lower() == "yes"` instead.

## Debug: the missing receipt total

Indentation decides which lines belong to a block, so one extra indent can quietly move a line *inside* an `if` where it only runs sometimes. This is one of the most common beginner bugs, because the code still runs without any error.

```python debug id=receipt-indent title="Small orders get no total"
subtotal = 30

if subtotal >= 100:
    discount = subtotal * 0.10
    print(f"Big order! You saved ${discount:.2f}")
    total = subtotal - discount
    print(f"Total to pay: ${total:.2f}")
--- solution
subtotal = 30
discount = 0

if subtotal >= 100:
    discount = subtotal * 0.10
    print(f"Big order! You saved ${discount:.2f}")

total = subtotal - discount
print(f"Total to pay: ${total:.2f}")
--- test
assert "Total to pay" in _stdout, "A $30 order printed no total at all. Which lines only run when the order is $100 or more?"
assert total == 30, f"With no discount, `total` should be 30, but it is {total!r}."
small = _rerun(subtotal=45)
assert small.get("total") == 45 and "Total to pay: $45.00" in small["_out"], "A $45 order should print `Total to pay: $45.00`."
assert "saved" not in small["_out"], "Only orders of $100 or more should print the savings message."
big = _rerun(subtotal=200)
assert big.get("total") == 180, f"A $200 order gets 10% off, so `total` should be 180, but it is {big.get('total')!r}."
assert "saved $20.00" in big["_out"] and "Total to pay: $180.00" in big["_out"], "A $200 order should print both the savings line and `Total to pay: $180.00`."
--- hint
Run it with `subtotal = 30`: nothing prints at all. Then set `subtotal = 150`: both lines print. So the total lines are only running for big orders.
--- hint
Move the two `total` lines out of the `if` block (un-indent them). Then `discount` needs a value even when the `if` doesn't run: give it a starting value of `0` before the `if`.
```

## One-line decisions: conditional expressions

When all you're doing is choosing between **two values**, a full `if`/`else` block can feel like a lot of ceremony. Python has a compact form called a **conditional expression**:

```python
value_if_true if condition else value_if_false
```

It reads almost like English, and it produces a value you can store, print or put in an f-string:

```python run
lives = 0
status = "Game over" if lives == 0 else "Keep playing"
print(status)

stock = 3
print(f"{stock} left" if stock > 0 else "Sold out")
```

Use it for short, simple choices. As soon as there are three outcomes, or each branch needs several lines, go back to a normal `if`/`elif`/`else`. Readability wins.

> **Coming from Excel:** a conditional expression is Python's version of `=IF(A1=0, "Game over", "Keep playing")`, just with the condition in the middle.

```python exercise id=plural-items title="1 item, 2 items"
count = 1

# TODO: set `label` to "1 item" when count is 1,
# and to "<count> items" otherwise (e.g. "0 items", "3 items").
# Try a conditional expression: ... if ... else ...
label = ...

print("Your basket:", label)
--- solution
count = 1

label = "1 item" if count == 1 else f"{count} items"

print("Your basket:", label)
--- test
assert label is not ..., "Replace `label = ...` with your expression."
assert isinstance(label, str), f"`label` should be text like \"1 item\", but it is {label!r}."
assert label == "1 item", f"With count = 1, `label` should be \"1 item\" but is {label!r}."
for c, want in [(0, "0 items"), (2, "2 items"), (7, "7 items"), (1, "1 item")]:
    got = _rerun(count=c).get("label")
    assert got == want, f"With count = {c}, `label` should be {want!r} but is {got!r}."
--- hint
Only one case is special: exactly 1. Everything else (including 0) gets an "s".
--- hint
Shape: `label = "1 item" if count == 1 else ...`. For the else part, an f-string can put the number in: `f"{count} items"`.
```

> **In the wild:** Decision logic is everywhere in professional code. A web framework like Django checks `if request.method == "POST":` to decide whether a form was submitted. A data script says `if row_count == 0:` to warn about an empty file. The patterns are exactly the ones you just wrote: guard checks, `elif` chains for categories, and short conditional expressions for labels.

## Recap

- `if condition:` runs its indented **block** only when the condition is true. Lines after the block always run.
- **Indentation is grammar** in Python: 4 spaces per level, and a missing indent is an `IndentationError`.
- `else` handles "everything else"; `elif` adds more choices. In a chain, **the first true condition wins** and the rest are skipped, so put the strictest checks first.
- Use an `elif` chain for "exactly one category" and separate `if`s when several rules can apply. Prefer `and` over nesting when you don't need an inner `else`.
- `a if condition else b` picks between two values in one line.

**Up next:** `while` loops, so your programs can repeat something until a goal is reached.
