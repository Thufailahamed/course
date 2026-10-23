Real programs live in a messy world. A user types `twelve` where you asked for a number. A shopping cart turns out to be empty right when you divide by its length. A file you expected isn't there. So far, every one of these has done the same thing: your program crashed with a red error card and stopped dead.

That's fine while you're learning, but it's not how finished software behaves. A cash register doesn't shut down because someone scanned a damaged barcode; it beeps, says "try again", and carries on. In this lesson you'll learn to read errors like a detective, catch the ones you expect with `try` and `except`, raise your own errors when someone misuses your functions, and avoid the two classic traps that hide bugs instead of handling them.

```python setup
# Simulated keyboard: the browser can't pause for typing, so input() reads queued answers.
_queued = []

def type_answers(*answers):
    """Queue up answers for the next input() calls, as if typed on a keyboard."""
    _queued.extend(str(a) for a in answers)

def input(prompt=""):
    print(prompt, end="")
    if not _queued:
        raise EOFError("input() has nothing to read. Call type_answers(...) first to simulate typing.")
    answer = _queued.pop(0)
    print(answer)
    return answer
```

## Reading a traceback: follow the trail

When something goes wrong, Python creates an **exception**: an object that describes the problem. If nothing deals with it, the program stops and prints a **traceback**, the trail of function calls that led to the problem. Run this cell; it fails on purpose:

```python run error
def average(prices):
    return sum(prices) / len(prices)

def receipt_line(cart):
    avg = average(cart)
    return f"Average item price: ${avg:.2f}"

print(receipt_line([3.50, 2.25]))
print(receipt_line([]))      # an empty cart
```

The first receipt printed fine. The second blew up. Here's how to read the traceback, like a stack of plates where the top plate was placed last:

```text
print(receipt_line([]))        ← 1. your code called receipt_line   (outermost)
  avg = average(cart)          ← 2. which called average
    sum(prices) / len(prices)  ← 3. where it actually broke         (innermost)
ZeroDivisionError: division by zero   ← what went wrong
```

1. **Read the last line first.** It names the exception type (`ZeroDivisionError`) and a message (`division by zero`). That's *what* happened.
2. **Then the line just above it.** That's *where* it happened: `len(prices)` was `0`.
3. **Then walk upward** to see *how you got there*. Often the real mistake is higher up: here, the bug isn't really in `average`, it's that someone passed it an empty cart.

> **Tip:** Python lists the calls from outermost (top) to innermost (bottom), which is why "read from the bottom up" works so well. The bottom line is the symptom; the frames above are the story.

## try and except: a safety net

Wrap risky code in `try`. If an exception happens inside it, Python jumps straight to the matching `except` block instead of crashing:

```python run
text = "twelve"

try:
    quantity = int(text)
    print("Got", quantity)
except ValueError:
    print(f"Sorry, {text!r} isn't a whole number.")

print("The program keeps going.")
```

Think of it like a trapeze act. `try` is the act; `except` is the net underneath. If the performer falls, the net catches them and the show goes on. Notice that `print("Got", quantity)` never ran: the moment `int(text)` failed, Python left the `try` block and the rest of it was skipped.

```text
try:                 ← run these lines one by one…
    line A           ✓
    line B           ✗ raises ValueError ─┐
    line C           (skipped)            │
except ValueError:                        │
    handle it        ← jumps here ◀───────┘
after the try        ← then carries on normally
```

If nothing fails, the `except` block is skipped entirely. And if a *different* kind of exception happens, one your `except` doesn't name, it isn't caught: it crashes just like before.

```python predict id=predict-first-match title="Which message prints?"
scores = [90, 85]
try:
    print("top:", scores[2])
except KeyError:
    print("no such key")
except IndexError:
    print("no such position")
--- options
top: 85
top: no such position
no such key
* no such position
--- explain
`scores[2]` asks for a third item in a two-item list, which raises `IndexError` **before** `print` gets to show anything, so `"top:"` never appears. Python checks the `except` clauses top to bottom: `KeyError` doesn't match (that's for dictionaries), `IndexError` does.
```

## Catch specific exceptions (and look inside them)

You can stack several `except` clauses, group types in a tuple, and use `as e` to get the exception object itself. Its message is often exactly what you want to show:

```python run
def describe_order(order, item):
    try:
        qty = int(order[item])
        per_box = 12 // qty
        print(f"{item}: {qty} ordered, {per_box} fit per box")
    except KeyError:
        print(f"{item}: not on this order")
    except (ValueError, ZeroDivisionError) as e:
        print(f"{item}: bad quantity ({type(e).__name__}: {e})")

order = {"mugs": "4", "plates": "zero", "bowls": "0"}
for item in ["mugs", "plates", "bowls", "spoons"]:
    describe_order(order, item)
```

Why be specific? Because each exception type is a *different problem*, and only some of them are problems you know how to fix. A missing key means "not ordered". A bad quantity means "ask again". Something you didn't predict, like a typo in your own code, should still crash loudly so you notice it.

### A field guide to common exceptions

You've met most of these already. Here they are side by side:

| Exception | Typical cause | Example |
|---|---|---|
| `ValueError` | Right type, wrong value | `int("ten")` |
| `TypeError` | Wrong type for the operation | `"3" + 4` |
| `KeyError` | Dictionary key doesn't exist | `{"tea": 2}["coffee"]` |
| `IndexError` | List/string position out of range | `[1, 2, 3][10]` |
| `ZeroDivisionError` | Dividing by zero | `10 / 0` |
| `NameError` | Name not defined (often a typo) | `totl + 1` |
| `AttributeError` | Value doesn't have that method | `"hi".shout()` |
| `FileNotFoundError` | No file at that path (next lesson!) | `open("missing.txt")` |

Run the cell below to see each one's real message. It uses `except Exception as e`, which catches *any* ordinary error, purely so this demo can keep going:

```python run
experiments = [
    lambda: int("ten"),
    lambda: "3" + 4,
    lambda: {"tea": 2}["coffee"],
    lambda: [1, 2, 3][10],
    lambda: 10 / 0,
    lambda: totl + 1,
    lambda: "hi".shout(),
    lambda: open("missing.txt"),
]
for attempt in experiments:
    try:
        attempt()
    except Exception as e:
        print(f"{type(e).__name__:18} {e}")
```

```python exercise id=parse-price title="Prices that never crash"
def parse_price(text):
    """Turn text like "4.99", " 12 " or "$3.50" into a float.
    If the text isn't a number, return None instead of crashing."""
    # TODO: remove any "$", try to convert with float(),
    # and catch the ValueError that float() raises on bad text.
    ...

# Try it out:
for raw in ["4.99", " 12 ", "$3.50", "free", ""]:
    print(repr(raw), "->", parse_price(raw))
--- solution
def parse_price(text):
    """Turn text like "4.99", " 12 " or "$3.50" into a float.
    If the text isn't a number, return None instead of crashing."""
    try:
        return float(text.replace("$", ""))
    except ValueError:
        return None

for raw in ["4.99", " 12 ", "$3.50", "free", ""]:
    print(repr(raw), "->", parse_price(raw))
--- test
got = parse_price("4.99")
assert got is not None, "`parse_price(\"4.99\")` returned None. Replace the `...` with a try/except that returns the converted number."
assert isinstance(got, float), f"`parse_price(\"4.99\")` should return a float, but returned {got!r}."
assert got == 4.99, f"`parse_price(\"4.99\")` should be 4.99, not {got!r}."
assert parse_price(" 12 ") == 12.0, f"`parse_price(\" 12 \")` should be 12.0, not {parse_price(' 12 ')!r}."
assert parse_price("$3.50") == 3.5, f"`parse_price(\"$3.50\")` should be 3.5, not {parse_price('$3.50')!r}. Did you remove the $ first?"
assert parse_price("0.75") == 0.75 and parse_price("$120") == 120.0, "Check your function on a few more prices, like \"0.75\" and \"$120\"."
for bad in ["free", "", "12 dollars", "$"]:
    assert parse_price(bad) is None, f"`parse_price({bad!r})` should return None, not {parse_price(bad)!r}."
--- hint
`float("free")` raises `ValueError`. Put the conversion inside `try:` and `return None` in the `except ValueError:` block.
--- hint
Clean the text before converting: `text.replace("$", "")` removes the dollar sign. `float()` already ignores spaces around the number.
--- hint
The shape is: `try:` → `return float(...)`, then `except ValueError:` → `return None`.
```

## else and finally: the full shape

A `try` statement can have two more optional parts:

- `else:` runs only if the `try` block finished **without** an exception. It's the "success" path.
- `finally:` runs **no matter what**: success, caught error, even an uncaught crash. It's for cleanup you must never skip.

```python run
def checkout(cart_total, paid_text):
    try:
        paid = float(paid_text)
    except ValueError:
        print(f"  {paid_text!r} isn't an amount")
    else:
        print(f"  change due: ${paid - cart_total:.2f}")
    finally:
        print("  (receipt printer reset)")

print("Customer 1:")
checkout(7.25, "10")
print("Customer 2:")
checkout(7.25, "ten bucks")
```

Why not just put the "change due" line inside `try`? Because then a bug in *that* line could be caught by the `except` and misreported. Keeping the `try` block to the one line that can fail is a habit you'll see again in a debug challenge below.

```python predict id=predict-else-finally title="In what order?"
def check(qty_text):
    try:
        qty = int(qty_text)
    except ValueError:
        print("bad", end=" ")
    else:
        print("ok", end=" ")
    finally:
        print("done", end=" ")

check("3")
check("x")
--- options
ok bad done
* ok done bad done
ok done bad
done ok done bad
--- explain
For `"3"`, the conversion works, so `else` prints `ok`, then `finally` prints `done`. For `"x"`, `except` prints `bad`, then `finally` prints `done` again. `finally` runs on **every** call, after the other blocks.
```

## Validating input: ask until it's right

Here's where `try`/`except` really shines. Because this page can't pause for your keyboard, `input()` here reads answers you queue up with `type_answers(...)`. In a real terminal, Python waits for you to type.

The pattern is a `while True` loop that only `break`s once the answer is valid:

```python run
type_answers("twelve", "-3", "2")

while True:
    text = input("How many tickets? ")
    try:
        tickets = int(text)
    except ValueError:
        print("  Please type a whole number, like 3.")
        continue
    if tickets < 1:
        print("  You need at least one ticket.")
        continue
    break

print("Booking", tickets, "tickets")
```

Two kinds of "wrong" are handled differently: `"twelve"` can't even be converted (an exception), while `-3` converts fine but breaks a rule (an `if`). Real validation almost always needs both.

```python exercise id=ask-quantity title="Keep asking until the quantity is valid"
def ask_quantity():
    """Ask "Quantity? " until the user types a whole number of at least 1.
    Print a short message after each bad answer. Return the quantity as an int."""
    # TODO: loop with input("Quantity? "), convert with int() inside try/except,
    # reject numbers below 1, and return the first valid one.
    ...

type_answers("a dozen", "0", "6")
quantity = ask_quantity()
print("quantity:", quantity)
--- solution
def ask_quantity():
    """Ask "Quantity? " until the user types a whole number of at least 1.
    Print a short message after each bad answer. Return the quantity as an int."""
    while True:
        text = input("Quantity? ")
        try:
            qty = int(text)
        except ValueError:
            print("Please enter a whole number.")
            continue
        if qty < 1:
            print("The quantity must be at least 1.")
            continue
        return qty

type_answers("a dozen", "0", "6")
quantity = ask_quantity()
print("quantity:", quantity)
--- test
assert quantity is not None, "`ask_quantity()` returned None. Replace the `...` with a loop that returns the first valid quantity."
assert isinstance(quantity, int), f"`ask_quantity()` should return an int, but returned {quantity!r} ({type(quantity).__name__}). Did you convert with int()?"
assert quantity == 6, f"With answers 'a dozen', '0', '6' the quantity should be 6, but it is {quantity!r}."
extra = [l for l in _stdout.splitlines() if l.strip() and not l.startswith("Quantity?") and not l.startswith("quantity:")]
assert len(extra) >= 2, "Print a short message after each bad answer ('a dozen' and '0' should each get one)."
_queued.clear()
type_answers("2.5", "-1", "seven", "11")
again = ask_quantity()
assert again == 11, f"With answers '2.5', '-1', 'seven', '11' your function returned {again!r} instead of 11."
assert not _queued, "Your function should stop asking as soon as it gets a valid answer."
type_answers("3", "99")
assert ask_quantity() == 3, "When the very first answer is valid, return it straight away."
--- hint
Start with `while True:` and read one answer per loop with `text = input("Quantity? ")`.
--- hint
Inside the loop: `try: qty = int(text)` / `except ValueError:` print a message and `continue`. Then check `if qty < 1:` the same way.
--- hint
When neither check failed, `return qty`. Returning from inside the loop ends both the loop and the function.
```

## raise: signal your own errors

So far Python has raised exceptions *at* you. You can raise them too. When someone calls your function with values that make no sense, the professional move is to **refuse loudly** with `raise`, rather than return a weird result that causes trouble later:

```python run error
def set_volume(level):
    if not 0 <= level <= 10:
        raise ValueError(f"volume must be between 0 and 10, got {level}")
    print("Volume set to", level)

set_volume(7)
set_volume(11)
```

The error message reads exactly like Python's own, because it *is* a real exception: whoever calls `set_volume` can catch it with `except ValueError`, just like they would for `int("ten")`.

Pick the exception type that describes the problem: `ValueError` for a bad value of the right type (a negative age), `TypeError` for the wrong type entirely (a list where a number belongs).

```python run
def safe_set_volume(level):
    try:
        set_volume(level)
    except ValueError as e:
        print("Refused:", e)

safe_set_volume(4)
safe_set_volume(-2)
```

> **In the wild:** Libraries raise exceptions constantly. Django raises `Http404` when a page doesn't exist, the `requests` library raises `ConnectionError` when the network is down, and pandas raises `KeyError` for a missing column. Your web framework catches them and turns them into friendly error pages.

```python exercise id=withdraw-raise title="An ATM that refuses bad withdrawals"
def withdraw(balance, amount):
    """Return the new balance after taking out `amount`.
    Raise ValueError if amount is 0 or negative,
    and raise ValueError if amount is more than balance."""
    # TODO: check both rules with if + raise ValueError("...message..."),
    # then return the new balance.
    ...

print(withdraw(100, 30))
try:
    withdraw(50, 80)
except ValueError as e:
    print("Refused:", e)
--- solution
def withdraw(balance, amount):
    """Return the new balance after taking out `amount`.
    Raise ValueError if amount is 0 or negative,
    and raise ValueError if amount is more than balance."""
    if amount <= 0:
        raise ValueError(f"amount must be positive, got {amount}")
    if amount > balance:
        raise ValueError(f"insufficient funds: balance is {balance}, asked for {amount}")
    return balance - amount

print(withdraw(100, 30))
try:
    withdraw(50, 80)
except ValueError as e:
    print("Refused:", e)
--- test
got = withdraw(100, 30)
assert got is not None, "`withdraw(100, 30)` returned None. Replace the `...` and return the new balance."
assert got == 70, f"`withdraw(100, 30)` should return 70, but returned {got!r}."
assert withdraw(250.5, 0.5) == 250.0, "`withdraw(250.5, 0.5)` should return 250.0."
assert withdraw(40, 40) == 0, "Taking out the whole balance is allowed: `withdraw(40, 40)` should return 0."
for bal, amt, why in [(50, 80, "more than the balance"), (100, 0, "zero"), (100, -20, "negative")]:
    try:
        result = withdraw(bal, amt)
    except ValueError as e:
        assert str(e).strip(), f"Give the ValueError for an amount that's {why} a helpful message, like raise ValueError(\"...\")."
    except Exception as e:
        assert False, f"`withdraw({bal}, {amt})` raised {type(e).__name__}; it should raise ValueError."
    else:
        assert False, f"`withdraw({bal}, {amt})` returned {result!r}, but an amount that's {why} should raise ValueError."
--- hint
Check the bad cases first, before doing any math. Each one is an `if` followed by `raise ValueError("...")`.
--- hint
The rules are `amount <= 0` and `amount > balance`. Withdrawing exactly the balance is fine.
--- hint
After both checks pass, `return balance - amount`.
```

## Why a bare `except:` is dangerous

You can write `except:` with no exception type. It catches **everything**: bad input, yes, but also typos in your own code, missing variables, even someone pressing Ctrl+C to stop the program. It's like a smoke alarm that you've wrapped in a towel because it was beeping at toast: quiet, but now it won't warn you about the real fire.

| Write this | Catches | Use it when |
|---|---|---|
| `except ValueError:` | exactly that problem | almost always |
| `except (ValueError, KeyError):` | a few named problems | several expected failures, same handling |
| `except Exception as e:` | any ordinary error | top level of a program, *and* you log `e` |
| `except:` | everything, silently | basically never |

```python debug id=bare-except-typo title="Every cart total comes out as 0.0"
def total_cost(price_texts):
    """Add up prices given as text, skipping any that aren't numbers."""
    total = 0.0
    for text in price_texts:
        try:
            total += flaot(text)
        except:
            pass  # skip prices that aren't numbers
    return total

cart = ["2.50", "oops", "1.25", "4.00"]
print("total:", total_cost(cart))
--- solution
def total_cost(price_texts):
    """Add up prices given as text, skipping any that aren't numbers."""
    total = 0.0
    for text in price_texts:
        try:
            total += float(text)
        except ValueError:
            pass  # skip prices that aren't numbers
    return total

cart = ["2.50", "oops", "1.25", "4.00"]
print("total:", total_cost(cart))
--- test
got = total_cost(["2.50", "oops", "1.25", "4.00"])
assert got != 0.0, "The total is still 0.0, so every price is being skipped. What is the `except` hiding from you?"
assert abs(got - 7.75) < 1e-9, f"The cart should total 7.75, but `total_cost` returned {got!r}."
assert abs(total_cost(["10", "n/a", "0.5"]) - 10.5) < 1e-9, "`total_cost([\"10\", \"n/a\", \"0.5\"])` should be 10.5 (skipping \"n/a\")."
assert total_cost([]) == 0.0, "An empty cart should total 0.0."
--- hint
Temporarily delete the `try:`/`except:` lines (keep the `total += ...` line) and run it. What error appears?
--- hint
There's a typo that raises `NameError` on every price, and the bare `except:` silently swallows it. Fix the typo.
--- hint
Then make the safety net specific: `except ValueError:` skips bad prices but would let a typo crash loudly.
```

## Keep the try block small

The second trap is the mirror image: a `try` block that wraps too much. The `except` was written for *one* line's failure, but it catches the same exception type from *any* line inside, including a line with a bug.

```python debug id=try-too-big title="Good rows are being skipped"
def tally(rows):
    """Add up points per player from "name,points" rows.
    Skip (and report) rows whose points aren't a number."""
    points = {}
    for row in rows:
        try:
            name, score = row.split(",")
            points[name] = points[name] + int(score)
        except (ValueError, KeyError):
            print("skipping bad row:", row)
    return points

totals = tally(["ana,12", "ben,7", "ana,5", "cara,oops", "ben,3"])
print(totals)
--- solution
def tally(rows):
    """Add up points per player from "name,points" rows.
    Skip (and report) rows whose points aren't a number."""
    points = {}
    for row in rows:
        try:
            name, score = row.split(",")
            score = int(score)
        except ValueError:
            print("skipping bad row:", row)
            continue
        points[name] = points.get(name, 0) + score
    return points

totals = tally(["ana,12", "ben,7", "ana,5", "cara,oops", "ben,3"])
print(totals)
--- test
assert totals != {}, "`totals` is empty, so every row was skipped. Use Debug to see which exception the good rows raise."
assert totals == {"ana": 17, "ben": 10}, f"`totals` should be {{'ana': 17, 'ben': 10}}, but it is {totals!r}."
assert "cara,oops" in _stdout, "The row 'cara,oops' really is bad, so it should still be reported as skipped."
assert "ana,12" not in _stdout and "ben,7" not in _stdout, "Good rows like 'ana,12' are still being reported as skipped."
fresh = tally(["zed,1", "zed,2", "broken", "amy,4"])
assert fresh == {"zed": 3, "amy": 4}, f"`tally([\"zed,1\", \"zed,2\", \"broken\", \"amy,4\"])` should be {{'zed': 3, 'amy': 4}}, not {fresh!r}."
--- hint
Debug it and watch the first row, `"ana,12"`. It's a perfectly good row, so why does it land in the `except`?
--- hint
`points[name]` raises `KeyError` the first time a player appears, and the `except` mistakes that for a bad row. A KeyError was never a "bad row" problem.
--- hint
Only the parsing (`split` and `int`) belongs inside `try` with `except ValueError`. Do the dictionary update afterwards, using `points.get(name, 0)`.
```

## Ask permission or ask forgiveness?

There are two styles for dealing with things that might fail, and Python programmers have names for both:

- **LBYL**, "Look Before You Leap": check first with an `if`, then act.
- **EAFP**, "Easier to Ask Forgiveness than Permission": just try it, and handle the exception if it fails.

```python run
stock = {"apples": 12, "pears": 0}

# LBYL: look before you leap
if "kiwis" in stock:
    print("kiwis:", stock["kiwis"])
else:
    print("kiwis: not stocked (checked first)")

# EAFP: ask forgiveness
try:
    print("kiwis:", stock["kiwis"])
except KeyError:
    print("kiwis: not stocked (handled the KeyError)")
```

Both work here. The difference shows up when the "look" is hard to get exactly right:

```python predict id=predict-isdigit title="Is it a number?"
text = "-5"
print(text.isdigit(), int(text))
--- options
True -5
* False -5
False
True 5
--- explain
`.isdigit()` only says yes if **every character** is a digit, and `-` isn't one. Yet `int("-5")` happily returns `-5`. An LBYL check with `.isdigit()` would wrongly reject negative numbers (and `" 7"` with a space). Trying `int()` and catching `ValueError` asks the expert, Python's own converter, instead of guessing.
```

| | LBYL (`if` first) | EAFP (`try` first) |
|---|---|---|
| Reads like | "Is this allowed? Then do it." | "Do it; if it fails, handle that." |
| Good for | simple, cheap checks (`if key in d`) | conversions, files, anything hard to pre-check |
| Risk | your check can disagree with reality | a too-broad `try` can hide bugs |

> **Coming from another language:** `try`/`except`/`raise` are Python's `try`/`catch`/`throw`. Python leans further toward EAFP than most languages; exceptions are an everyday tool here, not a last resort.

## Recap

- A **traceback** reads bottom-up: the last line says *what* went wrong, the frames above show *where* and *how you got there*.
- `try`/`except SomeError:` catches an expected failure so the program can recover; name **specific** exception types, and use `as e` to read the message.
- `else` runs when the `try` succeeded; `finally` runs every time, for cleanup.
- Validate input with a `while True` loop: catch conversion errors with `except ValueError`, check rules with `if`, and `break` or `return` when it's right.
- `raise ValueError("clear message")` makes your own functions refuse bad input loudly.
- Never use a bare `except:`, and keep `try` blocks small, so real bugs still crash where you can see them.

**Up next:** reading and writing files, plus the CSV and JSON formats that real-world data lives in. (Expect to meet `FileNotFoundError` again.)
