So far, every program you've written has talked *at* people: it prints, and that's it. Real programs listen too. A tip calculator asks for the bill. A quiz asks for your answer. A sign-up form asks for your age. The moment your program can ask a question and use the reply, it stops being a script and starts being a tool someone can use.

Python's `input()` function asks the question. But it comes with one rule that trips up every beginner exactly once: **whatever the user types arrives as text**, even if they typed `42`. In this lesson you'll learn to read input, convert it into the numbers you need with `int()` and `float()`, spot the conversions that crash or quietly lie, and check input before trusting it.

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

## Asking a question with `input()`

`input("prompt")` shows the prompt, waits for the user to type something and press Enter, and **returns** what they typed, so you can store it in a variable.

Because this page can't pause for your keyboard, `input()` here reads answers you queue up with `type_answers(...)`. In a real terminal, Python waits for you to type. Think of `type_answers` as typing ahead of time: each `input()` call takes the next answer from the queue, and the output shows it right after the prompt, just like a terminal would.

```python run
type_answers("Maya")

name = input("What's your name? ")
print(f"Nice to meet you, {name}!")
```

Change `"Maya"` to your own name and run it again. You can queue several answers at once; they're used in order:

```python run
type_answers("Lisbon", "Portugal")

city = input("City: ")
country = input("Country: ")
print(f"Shipping to {city.title()}, {country.upper()}")
```

> **Tip:** end your prompt with a space (`"City: "`), otherwise the user's typing is glued right onto the colon. Small touch, big difference in how polished your program feels.

## `input()` always returns a string

Here's the rule that matters most in this lesson. Ask someone their age, and they type `27`. What do you get back?

```python run
type_answers("27")

age = input("How old are you? ")
print("type:", type(age))
age
```

The quotes in `'27'` and the `str` label give it away: `age` is **text** that happens to contain digits, not the number 27. `input()` has no idea what you're asking for, so it always hands you exactly the characters that were typed. Try to do math with it, and Python stops you:

```python run error
type_answers("27")

age = input("How old are you? ")
print("Next year you'll be", age + 1)
```

`TypeError: can only concatenate str (not "int") to str`. You met this one in lesson 05: `+` between a string and a number doesn't make sense. Python won't guess whether you meant math or gluing text. You have to say which one you mean by **converting** the value.

> **In the wild:** this isn't just an `input()` thing. Data from web forms, command-line arguments, CSV files and URLs all arrive as text. Converting it to the right type at the edge of your program is a habit professionals never skip.

## Converting types: `int()`, `float()`, `str()`

Python has a converter function named after each type. Hand it a value, and it returns a **new** value of that type:

| Function | Converts to | Example | Result |
|---|---|---|---|
| `int(x)` | whole number | `int("27")` | `27` |
| `float(x)` | decimal number | `float("4.99")` | `4.99` |
| `str(x)` | text | `str(27)` | `'27'` |
| `bool(x)` | `True` / `False` | `bool("hi")` | `True` (more on this soon) |

The usual pattern is to wrap `input()` directly inside the converter:

```python run
type_answers("27")

age = int(input("How old are you? "))
print("Next year you'll be", age + 1)
print("type now:", type(age))
```

Read `int(input("..."))` from the **inside out**: first `input()` runs and returns `"27"`, then `int()` turns that into `27`, and finally `=` puts the label `age` on it.

Use `int()` for things you count (tickets, people, years) and `float()` for things you measure (prices, weights, temperatures). Here's a whole little program, a restaurant tip calculator:

```python run
type_answers("84.50", "18", "3")

bill = float(input("Bill total: $"))
tip_percent = float(input("Tip %: "))
people = int(input("Split between how many people? "))

tip = bill * tip_percent / 100
total = bill + tip
print(f"Tip: ${tip:.2f} | Total: ${total:.2f} | Each pays: ${total / people:.2f}")
```

```python predict id=predict-text-times-two title="Text or number?"
print("3" * 2, int("3") * 2)
--- options
6 6
33 33
* 33 6
3 3 6
--- explain
`"3" * 2` is string repetition (lesson 05), so it gives `33`. After `int("3")` you have the number `3`, and `3 * 2` is `6`. Same characters, completely different behavior, all because of the type.
```

```python exercise id=age-next-year title="How old will you be next year?"
type_answers("29")

# TODO: 1) ask "How old are you? " with input(), convert the answer to a
#          whole number, and store it in `age`
#       2) store age + 1 in `next_year`
#       3) print a message like: Next year you'll be 30.
age = ...
next_year = ...

print(...)
--- solution
type_answers("29")

age = int(input("How old are you? "))
next_year = age + 1

print(f"Next year you'll be {next_year}.")
--- test
assert age is not ..., "Replace the `...` after `age =` with a call to input() wrapped in a converter."
assert not isinstance(age, str), f"`age` is the text {age!r}, not a number. input() always returns a string. Which function turns '29' into 29?"
assert isinstance(age, int), f"`age` should be a whole number (int), but it is {type(age).__name__}."
assert not _queued, "Your code never read the answer. Call input(\"How old are you? \") to get it."
assert age == 29, f"`age` should be 29 (the queued answer), but it is {age!r}."
assert next_year is not ..., "Replace the `...` after `next_year =`."
assert next_year == age + 1, f"`next_year` should be one more than age ({age + 1}), but it is {next_year!r}."
assert str(next_year) in _stdout.replace("29", "", 1), "Print a message that includes next year's age, like: Next year you'll be 30."
--- hint
`input(...)` gives you the text `"29"`. Wrap the whole call in the function that makes whole numbers.
--- hint
`age = int(input("How old are you? "))`, then build `next_year` from `age`.
--- hint
For the message, an f-string is easiest: `print(f"Next year you'll be {...}.")`.
```

## `int()` chops, it doesn't round

`int()` on a float simply cuts off everything after the decimal point. It never rounds up, not even for `7.99`. If you want proper rounding, use `round()` from lesson 04.

```python run
print("int(7.9):  ", int(7.9))
print("round(7.9):", round(7.9))
print("int(-2.7): ", int(-2.7))       # toward zero, not down
print("str(3.50): ", str(3.50))       # trailing zero is not kept
print("str(42) + '!':", str(42) + "!")
```

`str()` is the converter in the other direction. You'll use it less now that f-strings do the job for you (`f"{42}!"`), but it's handy whenever you need to glue a number onto text with `+`.

```python predict id=predict-int-vs-round title="Chop or round?"
print(int(7.9), round(7.9))
--- options
8 8
7 7
* 7 8
7.9 8
--- explain
`int()` throws away the fractional part, giving `7`. `round()` goes to the nearest whole number, giving `8`. Neither one changes the original `7.9`; both return new values.
```

## When conversion fails: `ValueError`

`int()` is strict. It only accepts text that looks exactly like a whole number. Anything else, and it refuses with a `ValueError`. Run this one; it fails on purpose:

```python run error
type_answers("3.5")
hours = int(input("Hours worked: "))
```

Read the last line: `ValueError: invalid literal for int() with base 10: '3.5'`. In plain words: "`'3.5'` doesn't look like a whole number". *Base 10* just means ordinary decimal digits. The fix depends on what you want: `float("3.5")` gives `3.5`, and if you truly need a whole number, convert to float first and then round: `round(float("3.5"))`.

Here's what the converters accept and reject:

```python run
print(int("42"), int("-7"), int("  42  "))     # sign and surrounding spaces are fine
print(float("3.5"), float("10"), float("1e3"))  # float accepts whole numbers too
print(round(float("3.5")))                       # decimal text -> rounded int

# All of these raise ValueError (try them!):
#   int("3.5")   int("ten")   int("")   float("12,5")   float("$4.99")
```

| Text | `int(text)` | `float(text)` |
|---|---|---|
| `"42"` | `42` | `42.0` |
| `" 42 "` | `42` (spaces ignored) | `42.0` |
| `"3.5"` | ValueError | `3.5` |
| `""` (user just pressed Enter) | ValueError | ValueError |
| `"12,5"` or `"$4.99"` | ValueError | ValueError |

A crash on bad input isn't a disaster; it's Python refusing to guess. In lesson 23 you'll learn `try` / `except`, which lets your program catch a `ValueError` and politely ask again. For now, you'll learn to check input *before* converting it.

## The `bool()` trap

`bool()` looks like it should turn `"False"` into `False`. It doesn't. Remember the truthiness rule from lesson 07: **any non-empty string is truthy**, whatever it says.

```python run
print('bool("False"):', bool("False"))
print('bool("no"):   ', bool("no"))
print('bool("0"):    ', bool("0"))
print('bool(""):     ', bool(""))      # only empty text is False

type_answers("  No ")
answer = input("Subscribe to our newsletter? ")
print("subscribed:", answer.strip().lower() == "yes")
```

To turn a yes/no answer into a boolean, **compare the cleaned-up text** with what you're looking for. `bool()` on user input is almost always a bug.

```python predict id=predict-bool-text title="What does bool() make of these?"
print(bool("False"), bool(" "), bool(""))
--- options
False False False
False True False
* True True False
True False False
--- explain
`bool()` doesn't read the words; it only asks "is this text empty?". `"False"` has five characters and `" "` has one (a space), so both are truthy. Only the truly empty string `""` gives `False`.
```

```python exercise id=yes-or-no title="Understand yes and no"
type_answers("  Yes ", "no")

first = input("Do you want a receipt? ")
second = input("Do you want a bag? ")

# TODO: define two booleans:
#   wants_receipt -> True if `first`, cleaned up, is "yes" or "y"
#   wants_bag     -> the same rule applied to `second`
# Cleaned up = no spaces at the ends, and case doesn't matter.
wants_receipt = ...
wants_bag = ...

print("receipt:", wants_receipt, "| bag:", wants_bag)
--- solution
type_answers("  Yes ", "no")

first = input("Do you want a receipt? ")
second = input("Do you want a bag? ")

clean_first = first.strip().lower()
clean_second = second.strip().lower()
wants_receipt = clean_first == "yes" or clean_first == "y"
wants_bag = clean_second == "yes" or clean_second == "y"

print("receipt:", wants_receipt, "| bag:", wants_bag)
--- test
assert wants_receipt is not ... and wants_bag is not ..., "Replace both `...` placeholders with comparisons."
assert isinstance(wants_receipt, bool) and isinstance(wants_bag, bool), f"Both should be True or False, but you have {wants_receipt!r} and {wants_bag!r}. Each side of `or` needs its own `==` comparison."
assert wants_bag is False, "The customer typed 'no' for the bag, but `wants_bag` is True. Did you use bool()? Any non-empty text is truthy, even 'no'."
assert wants_receipt is True, "The customer typed '  Yes ' for the receipt, but `wants_receipt` is False. Clean the text first: remove the spaces and ignore the capital letter."
--- hint
`bool(first)` would be `True` for *any* answer, including "no". Compare the text instead.
--- hint
Clean the answer with `.strip().lower()`, then compare it with `"yes"` and with `"y"`.
--- hint
Remember from lesson 07: each side of `or` must be a full comparison, like `clean == "yes" or clean == "y"`.
```

## Debug challenge: 2 + 3 = 23?

```python debug id=tickets-glued title="Two plus three tickets makes twenty-three"
type_answers("2", "3")

adults = input("Adult tickets: ")
children = input("Child tickets: ")

total_tickets = adults + children
print("Total tickets:", total_tickets)
--- solution
type_answers("2", "3")

adults = int(input("Adult tickets: "))
children = int(input("Child tickets: "))

total_tickets = adults + children
print("Total tickets:", total_tickets)
--- test
assert total_tickets != "23", "`total_tickets` is '23': the two answers were glued together as text, not added as numbers."
assert isinstance(total_tickets, int), f"`total_tickets` should be a whole number, but it is {total_tickets!r} ({type(total_tickets).__name__})."
assert total_tickets == 5, f"2 adults + 3 children should be 5 tickets, but `total_tickets` is {total_tickets!r}."
assert "Total tickets: 5" in _stdout, "Keep the print line so the total is shown."
--- hint
Run it and look at the Variables panel. What type are `adults` and `children`? What does `+` do with two strings?
--- hint
Convert each answer to a whole number as you read it, so `+` does arithmetic.
```

## Debug challenge: the price that crashes

```python debug id=price-crash title="The grocery calculator crashes on a decimal price"
# Price per kg can have cents; weight is always whole kilos here.
type_answers("3.5", "4")

price_per_kg = int(input("Price per kg: $"))
kilos = int(input("How many kg? "))

cost = price_per_kg * kilos
print(f"Cost: ${cost:.2f}")
--- solution
type_answers("3.5", "4")

price_per_kg = float(input("Price per kg: $"))
kilos = int(input("How many kg? "))

cost = price_per_kg * kilos
print(f"Cost: ${cost:.2f}")
--- test
assert isinstance(price_per_kg, float), f"`price_per_kg` should be a decimal number (float), but it is {price_per_kg!r} ({type(price_per_kg).__name__})."
assert price_per_kg == 3.5, f"`price_per_kg` should be 3.5, but it is {price_per_kg!r}. Don't round the price, keep the cents."
assert cost == 14.0, f"3.5 per kg times 4 kg should cost 14.0, but `cost` is {cost!r}."
assert "Cost: $14.00" in _stdout, "Keep the print line so the cost is shown as $14.00."
--- hint
Run it and read the last line of the error. Which conversion failed, and on what text?
--- hint
`int()` only accepts whole-number text. Prices have cents. Which converter understands `"3.5"`?
```

## Checking input before you convert it

You can avoid many `ValueError`s by checking the text first. `.isdigit()` from lesson 06 answers "is every character a digit?", and `.strip()` removes the stray spaces people type by accident.

```python run
type_answers(" 12 ", "twelve")

first = input("How many cupcakes? ")
second = input("How many cupcakes? ")

print("first looks like a whole number? ", first.strip().isdigit())
print("second looks like a whole number?", second.strip().isdigit())

# Short-circuiting (lesson 07) as a guard: int() only runs if the check passed
print("first is a sensible order?  ", first.strip().isdigit() and int(first) <= 100)
print("second is a sensible order? ", second.strip().isdigit() and int(second) <= 100)
```

The last two lines use the guard pattern from lesson 07: when `.isdigit()` is `False`, `and` stops right there, so `int("twelve")` never runs and nothing crashes. In the next lesson, `if` will let you *react* to that `False`, for example by printing "Please enter a number".

> **Pitfall:** `.isdigit()` says `False` for `"-5"` and `"2.5"`, because `-` and `.` aren't digits. It's perfect for counts and quantities, but not for prices or temperatures. For those, the bulletproof check is `try` / `except` (lesson 23).

```python exercise id=minutes-to-hours title="Convert typed minutes into hours"
type_answers(" 135 ")

minutes_text = input("Movie length in minutes: ")

# TODO: define:
#   is_valid -> True if minutes_text, stripped, contains only digits
#   minutes  -> minutes_text converted to an int
#   hours    -> the number of whole hours in `minutes`
#   leftover -> the minutes left over after taking out the whole hours
# Then print the length like: 2h 15m
is_valid = ...
minutes = ...
hours = ...
leftover = ...

print(...)
--- solution
type_answers(" 135 ")

minutes_text = input("Movie length in minutes: ")

is_valid = minutes_text.strip().isdigit()
minutes = int(minutes_text)
hours = minutes // 60
leftover = minutes % 60

print(f"{hours}h {leftover}m")
--- test
todo = [k for k, v in {"is_valid": is_valid, "minutes": minutes, "hours": hours, "leftover": leftover}.items() if v is ...]
assert not todo, f"Replace the `...` for: {', '.join(todo)}"
assert isinstance(is_valid, bool), f"`is_valid` should be True or False, but it is {is_valid!r}."
assert is_valid is True, "`is_valid` is False, but ' 135 ' is a valid number once the spaces are removed. Strip before checking."
assert not isinstance(minutes, str), f"`minutes` is still text ({minutes!r}). Convert it with int()."
assert minutes == 135, f"`minutes` should be 135, but it is {minutes!r}."
assert hours == minutes // 60, f"`hours` should be {minutes // 60}, but it is {hours!r}. Did you use / instead of //?"
assert isinstance(hours, int), f"`hours` should be a whole number, but it is {hours!r}. Floor division // keeps it whole."
assert leftover == minutes % 60, f"`leftover` should be {minutes % 60}, but it is {leftover!r}. Which operator gives the remainder?"
assert f"{hours}h {leftover}m" in _stdout, f"Print the length in the form {hours}h {leftover}m."
--- hint
`.strip().isdigit()` for the check. `int()` doesn't mind the spaces, so you can convert `minutes_text` directly.
--- hint
Lesson 04: `//` gives how many whole 60s fit in, and `%` gives what's left over.
--- hint
An f-string prints it: `f"{hours}h {leftover}m"`.
```

## Recap

- `input("prompt ")` shows a prompt and **returns what the user typed, always as a `str`**, even if they typed digits.
- Convert with `int()` (counts), `float()` (measurements), and `str()` (back to text). Read nested calls inside out: `int(input(...))`.
- `int()` chops decimals (`int(7.9)` is `7`); use `round()` to round. `int("3.5")` is a `ValueError`; use `float()` for decimal text.
- `bool("False")` is `True`: any non-empty text is truthy. Turn yes/no answers into booleans by comparing cleaned text.
- Check before converting with `.strip().isdigit()`, and guard risky conversions with `and`. Proper error handling comes in lesson 23.

**Up next:** making decisions with `if`, `elif` and `else`, so your programs can finally *react* to what users tell them.
