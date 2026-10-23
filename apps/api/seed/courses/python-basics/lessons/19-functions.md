You've been calling functions since your very first line: `print()`, `len()`, `sum()`, `round()`. Each one is a little machine with a name. You hand it something, it does its job, and (usually) it hands something back. You never had to know *how* `len()` counts; you just trusted the name.

Now you get to build your own machines. A function lets you write a piece of logic **once**, give it a clear name, and use it a hundred times. It's the single biggest step from "a script that runs top to bottom" to "a program made of parts." By the end of this lesson you'll write functions that take inputs, return results, stop early when they've found an answer, hand back several values at once, and prove themselves correct with `assert`.

## Why functions? The copy-paste problem

Here's a shop working out the price of three orders after a 10% member discount and a $4.99 delivery fee:

```python run
order_a = 30.00
order_b = 12.50
order_c = 89.90

final_a = round(order_a * 0.9 + 4.99, 2)
final_b = round(order_b * 0.9 + 4.99, 2)
final_c = round(order_c * 0.9 + 4.99, 2)

print(final_a, final_b, final_c)
```

It works, but the same formula is written three times. If the discount changes to 15%, you have to find and edit every copy, and miss one and your prices are quietly wrong. Programmers call the fix **DRY: Don't Repeat Yourself.** Put the recipe in one place and give it a name:

```python run
def final_price(order):
    return round(order * 0.9 + 4.99, 2)

print(final_price(30.00), final_price(12.50), final_price(89.90))
```

Same results, one formula. Change the discount once and every order follows. And notice how the call *reads*: `final_price(30.00)` says what it means. A good function name turns a tangle of arithmetic into an idea.

## Anatomy of a function

A function is like a **recipe card**. Writing the card (defining) doesn't cook anything. Cooking happens only when someone follows the card (calling).

```python
def name(parameter1, parameter2):     # the header: def, a name, parentheses, a colon
    """What this function does."""    # optional docstring (more on this below)
    ...                               # the indented body
    return result                     # hand a value back to the caller
```

- `def` starts a definition. The name follows the same rules as variable names: `snake_case`, descriptive, usually a verb (`calculate_tax`, `send_reminder`).
- The **body** is the indented block, exactly like the body of an `if` or a `for`.
- Running a `def` only *creates* the function and stores it under its name. The body runs when you **call** it with parentheses: `name(...)`.

```python run
def say_hello():
    print("Hello from inside the function!")

print("Before the call")
say_hello()
say_hello()
print("After the calls")
```

The definition sat quietly until `say_hello()` was called, and then it ran once per call. Leave off the parentheses and you don't call it at all; you just refer to the function itself:

```python run
say_hello
```

That `function` chip is Python telling you "this is the recipe card, not the meal." Forgetting the `()` is a classic slip: no error, just nothing happens.

```python predict id=predict-def-not-run title="What does this print?"
def warn():
    print("Battery low!")

print("Phone is on")
--- options
Battery low!
* Phone is on
Battery low! Phone is on
Phone is on Battery low!
--- explain
Defining `warn` doesn't run its body. Nothing ever *calls* `warn()`, so only `"Phone is on"` is printed. A function body runs only when the function is called.
```

## Parameters and arguments

A function becomes useful when you can feed it different inputs. The names in the `def` line are **parameters**: empty slots waiting for values. The values you pass in a call are **arguments**: what actually fills the slots.

```python run
def greet(name, city):
    print(f"Hi {name}! How's the weather in {city}?")

greet("Amara", "Nairobi")
greet("Leo", "Oslo")
```

| Term | Where it lives | In the example |
|---|---|---|
| **parameter** | in the `def` line, a name | `name`, `city` |
| **argument** | in the call, a value | `"Amara"`, `"Oslo"` |

On each call, Python pairs arguments with parameters **left to right**: first argument into the first slot, second into the second. Inside the body, the parameters are ordinary variables. Pass the wrong number of arguments and Python stops you with a very readable error:

```python run error
greet("Amara")
```

Read the last line: `greet() missing 1 required positional argument: 'city'`. It names the function and the exact slot that was left empty. (In lesson 20 you'll learn how to give parameters default values so they can be left out.)

## `return`: handing a value back

`print` shows something on the screen. `return` **hands a value back** to whoever called the function, so they can store it, compare it or do more math with it. The call expression itself *becomes* the returned value, the same way `len("hello")` becomes `5`.

```python run
def rectangle_area(width, height):
    return width * height

kitchen = rectangle_area(4, 3.5)
bedroom = rectangle_area(3, 3)

print("kitchen:", kitchen)
print("total floor:", kitchen + bedroom)
rectangle_area(2, 5) * 30     # price of flooring at $30 per square metre
```

Think of a vending machine. You put coins in (arguments), the machine works (body), and a snack drops into the tray (return value). What you do with the snack is up to you. A machine that only *showed you a picture* of the snack (print) wouldn't be much use.

```python exercise id=to-fahrenheit title="Celsius to Fahrenheit"
# TODO: complete the function so it RETURNS the temperature in Fahrenheit.
# The formula is: fahrenheit = celsius * 9 / 5 + 32
def to_fahrenheit(celsius):
    """Convert a temperature from Celsius to Fahrenheit."""
    ...

print("Lisbon:", to_fahrenheit(24))
print("Freezing:", to_fahrenheit(0))
--- solution
def to_fahrenheit(celsius):
    """Convert a temperature from Celsius to Fahrenheit."""
    return celsius * 9 / 5 + 32

print("Lisbon:", to_fahrenheit(24))
print("Freezing:", to_fahrenheit(0))
--- test
assert callable(to_fahrenheit), "`to_fahrenheit` should be a function defined with `def`."
assert to_fahrenheit(0) is not None, "`to_fahrenheit(0)` gave back `None`. Replace the `...` with a `return` statement."
assert isinstance(to_fahrenheit(0), (int, float)), f"`to_fahrenheit` should return a number, but returned {to_fahrenheit(0)!r}."
for c, f in [(0, 32), (100, 212), (-40, -40), (37, 98.6), (-12.5, 9.5)]:
    got = to_fahrenheit(c)
    assert abs(got - f) < 1e-9, f"`to_fahrenheit({c})` should be {f}, but returned {got}. Check the formula: celsius * 9 / 5 + 32."
--- hint
The body needs one line that starts with `return`.
--- hint
Use the parameter name inside the formula: `return celsius * ...`.
```

## `return` vs `print`: the big beginner trap

This is the most important idea in the lesson, so let's slow down. A function that **prints** its answer *looks* like it works when you run it, because you see the number. But the caller gets nothing back. Every function that finishes without hitting a `return` hands back the special value **`None`**, Python's way of saying "nothing here."

```python run
def add_tax_print(price):
    print(price * 1.2)          # shows it... and that's all

def add_tax_return(price):
    return price * 1.2          # hands it back

a = add_tax_print(10)
b = add_tax_return(10)
print("a is", a)
print("b is", b)
```

The first line of output, `12.0`, came from *inside* `add_tax_print`. But `a` is `None`, because that function never returned anything. Try doing math with `a`:

```python run error
a + 5
```

`unsupported operand type(s) for +: 'NoneType' and 'int'` is the fingerprint of this exact bug. Whenever you see `NoneType` in an error, ask: *which function forgot to return?*

| | `print(x)` | `return x` |
|---|---|---|
| Who sees it | a human, on the screen | the code that called the function |
| Can you store it, add it, compare it? | no | yes |
| What the call evaluates to | `None` | `x` |
| Ends the function | no | yes, immediately |

> **Tip:** As a rule, functions that *compute* something should `return` it, and let the caller decide whether to print. Your functions become reusable: the same `add_tax_return` can feed a receipt, a spreadsheet or a test.

```python predict id=predict-forgot-return title="What does this print?"
def double(n):
    n * 2

print(double(21))
--- options
42
* None
21
NameError
--- explain
The body *calculates* `n * 2` and then throws the result away. There's no `return`, so the function finishes and hands back `None`. Fix it with `return n * 2`.
```

```python debug id=line-totals-none title="The receipt is full of None"
def line_total(price, quantity):
    """Return the cost of one line on a receipt."""
    print(price * quantity)

cart = [(2.50, 4), (1.25, 2), (6.00, 1)]   # (price, quantity) pairs

line_totals = []
for price, qty in cart:
    line_totals.append(line_total(price, qty))

print("line totals:", line_totals)
--- solution
def line_total(price, quantity):
    """Return the cost of one line on a receipt."""
    return price * quantity

cart = [(2.50, 4), (1.25, 2), (6.00, 1)]   # (price, quantity) pairs

line_totals = []
for price, qty in cart:
    line_totals.append(line_total(price, qty))

print("line totals:", line_totals)
--- test
assert line_total(2.5, 4) is not None, "The caller still receives `None` from `line_total(2.5, 4)`. The value is shown on screen, but is it handed back?"
assert line_total(2.5, 4) == 10.0, f"`line_total(2.5, 4)` should give back 10.0, but gave {line_total(2.5, 4)!r}."
assert line_total(3, 7) == 21, f"`line_total(3, 7)` should give back 21, but gave {line_total(3, 7)!r}."
assert line_totals == [10.0, 2.5, 6.0], f"`line_totals` should be [10.0, 2.5, 6.0], but is {line_totals!r}."
--- hint
Run it. The numbers appear on screen, yet the list holds `None` three times. What does a function give back when it never says `return`?
--- hint
Change the one line inside `line_total` so it hands the value back instead of displaying it.
```

## `return` ends the function: returning early

The moment Python hits a `return`, the function is **over**. Any lines after it are skipped, even lines inside a loop. That sounds like a limitation, but it's a superpower: once you know the answer, you can leave.

```python run
def shipping_cost(order_total):
    if order_total >= 50:
        return 0            # free shipping: done, leave now
    if order_total >= 20:
        return 3.99
    return 7.99             # only reached for small orders

for total in [75, 50, 35, 8]:
    print(f"${total} order -> shipping ${shipping_cost(total)}")
```

No `elif` or `else` needed: each `return` exits, so a later line only runs when every earlier condition was false. This style, handling the special cases first and leaving, is called an **early return** (or a "guard clause"), and professional code uses it everywhere to avoid deeply nested `if`s.

Early returns work inside loops too. This function searches a list and stops at the first match:

```python run
def first_over_budget(expenses, budget):
    for amount in expenses:
        if amount > budget:
            return amount       # found one: stop searching
    return None                 # loop finished: nothing was over budget

print(first_over_budget([12, 40, 95, 300], 50))
print(first_over_budget([12, 40], 50))
```

Notice where the final `return None` sits: **after** the loop, not inside it. The function can only conclude "nothing found" once it has checked *every* item. Writing `return None` explicitly isn't required (it's the default), but it tells the reader you meant it.

```python exercise id=ticket-price title="Cinema ticket prices"
# TODO: return the ticket price for a given age:
#   under 3      -> 0     (babies are free)
#   3 to 12      -> 8
#   13 to 64     -> 14
#   65 and over  -> 9
# Early returns make this short and clear.
def ticket_price(age):
    """Return the ticket price in dollars for a visitor of this age."""
    ...

print("toddler:", ticket_price(2))
print("adult:", ticket_price(30))
--- solution
def ticket_price(age):
    """Return the ticket price in dollars for a visitor of this age."""
    if age < 3:
        return 0
    if age <= 12:
        return 8
    if age >= 65:
        return 9
    return 14

print("toddler:", ticket_price(2))
print("adult:", ticket_price(30))
--- test
assert ticket_price(30) is not None, "`ticket_price(30)` gave back `None`. Replace the `...` and make sure every path ends in a `return`."
cases = {0: 0, 2: 0, 3: 8, 7: 8, 12: 8, 13: 14, 40: 14, 64: 14, 65: 9, 90: 9}
for age, price in cases.items():
    got = ticket_price(age)
    assert got is not None, f"`ticket_price({age})` gave back `None`. Is there a path through your function that never reaches a `return`?"
    assert got == price, f"`ticket_price({age})` should be {price}, but is {got!r}. Check the boundary: is {age} included in the right group?"
--- hint
Handle one age group per `if`, and `return` the price right away. Later checks only run if earlier ones didn't return.
--- hint
Watch the edges: 3 pays 8, 12 pays 8, 13 pays 14, 65 pays 9. Use `<`, `<=` or `>=` accordingly.
--- hint
Start with `if age < 3: return 0`, then `if age <= 12: return 8`, and so on, with a final `return` for everyone else.
```

The flip side of "return ends the function" is a bug every programmer writes at least once: putting a `return` in a loop where it fires too soon.

```python debug id=all-in-stock title="Everything looks in stock"
def all_in_stock(quantities):
    """Return True only if every quantity is above zero."""
    for qty in quantities:
        if qty <= 0:
            return False
        else:
            return True

shelf = [5, 12, 0, 3]
print("All in stock?", all_in_stock(shelf))
--- solution
def all_in_stock(quantities):
    """Return True only if every quantity is above zero."""
    for qty in quantities:
        if qty <= 0:
            return False
    return True

shelf = [5, 12, 0, 3]
print("All in stock?", all_in_stock(shelf))
--- test
assert all_in_stock([5, 12, 0, 3]) is False, "`all_in_stock([5, 12, 0, 3])` should be False: one item has 0 left. Does your loop look past the first item?"
assert all_in_stock([4, 2, 9]) is True, "`all_in_stock([4, 2, 9])` should be True."
assert all_in_stock([0, 8]) is False, "`all_in_stock([0, 8])` should be False."
assert all_in_stock([7, 1, 1, -2]) is False, "`all_in_stock([7, 1, 1, -2])` should be False: the last item is below zero."
assert all_in_stock([]) is True, "With no items to check, nothing is out of stock, so `all_in_stock([])` should be True (not None)."
--- hint
Click **Debug** and step through. How many items does the loop look at before the function returns?
--- hint
You can say "False" as soon as you find a bad item, but you can only say "True" after checking *all* of them. Where does a line go so it runs after the loop finishes?
```

## Returning several values at once

A function can only `return` one thing, but that thing can be a **tuple**. Write the values separated by commas, and unpack them at the call site just like you did in lesson 15:

```python run
def price_range(prices):
    return min(prices), max(prices)

cheapest, priciest = price_range([4.99, 12.00, 2.49, 7.25])
print("cheapest:", cheapest)
print("priciest:", priciest)
price_range([10, 3, 8])
```

The last line shows what really comes back: a single tuple, `(3, 10)`. The unpacking on the call side is what makes it *feel* like two return values.

```python predict id=predict-tuple-return title="What is displayed?"
def split_minutes(total):
    return total // 60, total % 60

split_minutes(135)
--- options
2 15
2:15
* (2, 15)
[2, 15]
--- explain
`return a, b` builds a tuple, and a tuple displays with parentheses. You'd unpack it with `hours, minutes = split_minutes(135)` to get the two numbers separately.
```

```python exercise id=score-summary title="Summarize a game's scores"
# TODO: return THREE values, in this order: the lowest score, the highest
# score, and the average score rounded to 1 decimal place.
def score_summary(scores):
    """Return (lowest, highest, average) for a non-empty list of scores."""
    ...

print(score_summary([72, 95, 88, 61]))
--- solution
def score_summary(scores):
    """Return (lowest, highest, average) for a non-empty list of scores."""
    average = round(sum(scores) / len(scores), 1)
    return min(scores), max(scores), average

low, high, avg = score_summary([72, 95, 88, 61])
print(f"low {low}, high {high}, average {avg}")
--- test
result = score_summary([72, 95, 88, 61])
assert result is not None, "`score_summary` gave back `None`. Replace the `...` with code that ends in `return`."
assert isinstance(result, tuple), f"`score_summary` should return a tuple of three values (`return a, b, c`), but returned {result!r}."
assert len(result) == 3, f"Return exactly three values (lowest, highest, average), not {len(result)}."
assert result[:2] == (61, 95), f"The first two values should be the lowest (61) and highest (95), in that order, but got {result[:2]}."
assert result[2] == 79.0, f"The average of [72, 95, 88, 61] is 79.0, but your third value is {result[2]!r}."
fresh = score_summary([10, 3, 4])
assert fresh == (3, 10, 5.7), f"`score_summary([10, 3, 4])` should be (3, 10, 5.7), but is {fresh!r}. Is the average rounded to 1 decimal?"
assert score_summary([50]) == (50, 50, 50.0), f"`score_summary([50])` should be (50, 50, 50.0), but is {score_summary([50])!r}."
--- hint
`min()`, `max()`, `sum()` and `len()` all work on a list.
--- hint
The average is `sum(scores) / len(scores)`, passed through `round(..., 1)`.
--- hint
Separate the three values with commas after `return`: `return lowest, highest, average`.
```

## Docstrings: say what your function does

The string on the first line of a function's body is its **docstring**. It's not a comment: Python stores it with the function, and tools like editors, autocomplete and `help()` show it to anyone using your code.

```python run
def bmi(weight_kg, height_m):
    """Return body-mass index: weight in kg divided by height in metres squared."""
    return round(weight_kg / height_m ** 2, 1)

help(bmi)
```

A good docstring says **what goes in and what comes out**, in one sentence if possible: "Return the shipping cost for an order total in dollars." Use triple quotes, even for one line, so it's easy to extend later. (You'll use `help()` to explore Python's own modules in lesson 25.)

> **In the wild:** In professional codebases (Django, pandas, the Python standard library itself), almost every public function has a docstring. Documentation websites are often *generated* straight from them, so the docstring is the manual.

## Functions calling functions

Once a function exists, other functions can use it, just like you use `len()` inside your own code. This is how big programs are built: small, trustworthy pieces stacked into bigger ones.

```python run
def subtotal(prices):
    """Return the sum of all prices."""
    return sum(prices)

def with_tax(amount, rate):
    """Return amount plus tax at the given rate (0.2 means 20%)."""
    return round(amount * (1 + rate), 2)

def checkout(prices):
    """Return the amount to charge: subtotal plus 20% tax."""
    return with_tax(subtotal(prices), 0.2)

print("to pay:", checkout([3.50, 12.00, 4.25]))
```

Each function does one job and has a name that explains it. `checkout` reads almost like English. Press **Debug** on that cell and step *into* the calls: you'll see Python jump into `subtotal`, return, jump into `with_tax`, return, and finally finish `checkout`.

> **Tip:** If you can't describe what a function does in one short sentence without the word "and", it's probably doing two jobs. Split it.

## Testing your function with `assert`

How do you know your function works? You could print results and eyeball them, but professionals write **checks** that run automatically. Python's `assert` statement does exactly that: `assert condition, "message"` does nothing if the condition is true, and stops with an `AssertionError` if it's false.

```python run
def is_even(n):
    return n % 2 == 0

assert is_even(4)
assert not is_even(7)
assert is_even(0), "zero counts as even"
print("All is_even checks passed!")
```

Silence means success. Now see what a failing check looks like:

```python run error
def average(numbers):
    return sum(numbers) / 2      # bug: assumes there are always two numbers

assert average([4, 6]) == 5
assert average([3, 6, 9]) == 6, "average of three numbers is wrong"
```

The first check passed by luck, and the second one caught the bug with your message attached. Good checks include **ordinary** cases, **edge** cases (zero, empty, the boundary between two groups) and inputs that are *different from your examples*, so the function can't be right by coincidence. That's exactly how the hidden tests in this course check your challenges.

```python exercise id=initials-with-tests title="Initials that pass their own checks"
# TODO: complete `initials` so it returns the capitalized first letter
# of each word, each followed by a dot:
#    "ada lovelace" -> "A.L."    "grace brewster hopper" -> "G.B.H."
# The asserts below are your safety net: until the function works, they
# stop the program with a clear message. Don't change them.
def initials(full_name):
    """Return initials like 'A.L.' for a name like 'ada lovelace'."""
    ...

assert initials("ada lovelace") == "A.L.", "initials('ada lovelace') should be 'A.L.'"
assert initials("Alan Turing") == "A.T.", "initials('Alan Turing') should be 'A.T.'"
print("All checks passed!")
--- solution
def initials(full_name):
    """Return initials like 'A.L.' for a name like 'ada lovelace'."""
    result = ""
    for word in full_name.split():
        result += word[0].upper() + "."
    return result

assert initials("ada lovelace") == "A.L.", "initials('ada lovelace') should be 'A.L.'"
assert initials("Alan Turing") == "A.T.", "initials('Alan Turing') should be 'A.T.'"
print("All checks passed!")
--- test
got = initials("ada lovelace")
assert isinstance(got, str), f"`initials` should return a string, but returned {got!r}."
assert got == "A.L.", f"`initials('ada lovelace')` should be 'A.L.', but is {got!r}."
assert initials("grace brewster hopper") == "G.B.H.", f"`initials('grace brewster hopper')` should be 'G.B.H.', but is {initials('grace brewster hopper')!r}."
assert initials("  bob   ross ") == "B.R.", f"Extra spaces shouldn't matter: `initials('  bob   ross ')` should be 'B.R.', but is {initials('  bob   ross ')!r}. Try `.split()` with no argument."
assert initials("cher") == "C.", f"`initials('cher')` should be 'C.', but is {initials('cher')!r}."
assert "All checks passed!" in _stdout, "Keep the asserts and the final print, so you can see your checks pass."
--- hint
Press Run first: your own assert stops the program and says what's wrong. That's exactly what checks are for. Now make the function earn a pass.
--- hint
`full_name.split()` gives you the words. Take `word[0]` from each one and make it uppercase.
--- hint
Build the answer in a loop with an accumulator string, adding `word[0].upper() + "."` each time, then `return` it after the loop. (A comprehension with `"".join(...)` works too.)
```

## Recap

- `def name(params):` defines a function; its body runs only when you **call** it with `name(args)`. Without `()`, nothing runs.
- **Parameters** are the named slots in the `def` line; **arguments** are the values you pass, matched left to right.
- `return` hands a value back to the caller and ends the function immediately. A function with no `return` gives back `None`, and `NoneType` in an error usually means a missing `return`.
- Prefer `return` over `print` in functions that compute something. Put "found nothing" returns *after* the loop, not inside it.
- `return a, b` returns a tuple you can unpack; a docstring documents what goes in and comes out; `assert` turns your expectations into automatic checks.

**Up next:** arguments in depth: default values, keyword arguments, and functions that accept any number of inputs with `*args` and `**kwargs`.
