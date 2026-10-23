Every app you've ever used, from the calculator on your phone to the software that books flights, is built from the same humble idea: **a list of instructions that a computer follows one at a time.** That list is called a *program*, and by the end of this page you'll have written several of them.

You'll learn how to make Python display anything you want with `print()`, how to tell Python "this is text" versus "this is a number to calculate", how to leave notes for yourself with comments, and, maybe most valuable of all, how to read Python's error messages calmly and fix them in seconds. Professional developers spend a surprising amount of their day reading errors. You'll start that habit today.

## A program is a recipe

A recipe lists steps in order: preheat the oven, mix the flour, bake for 20 minutes. You don't bake before you mix. Python works the same way: it reads your program **from the top line to the bottom line**, doing exactly one instruction per line, in order.

```python run
print("Step 1: Preheat the oven to 180 degrees.")
print("Step 2: Mix flour, sugar and eggs.")
print("Step 3: Bake for 20 minutes.")
print("Done! Enjoy your cake.")
```

Four lines, four instructions, four lines of output, in the same order you wrote them. Try swapping two lines and running it again: the output order changes with them. Python never skips ahead or rearranges your steps.

## `print()` shows things on the screen

`print` is a **function**: a named action that Python already knows how to do. You *call* it by writing its name followed by parentheses, and you put the thing you want displayed *inside* the parentheses.

```python
print( what_to_show )
```

The text you want to show goes in **quotes**. Python calls a piece of text a **string** (as in "a string of characters"). Single or double quotes both work, as long as they match:

```python run
print("Good morning!")
print('Your coffee is ready.')
print("It's 7:30 and it's sunny.")
print()
print("(The empty print() above made a blank line.)")
```

Notice the third line: the text contains an apostrophe, so it's wrapped in *double* quotes. If you used single quotes there, Python would think the string ended at `It'`. Picking the other kind of quote is the easiest fix.

> **Tip:** Choose one style and stick with it. Most Python code uses double quotes `"..."`, switching to single quotes only when the text itself contains a `"`.

### Many things at once

You can give `print` several values, separated by commas. It shows them all on one line with **a single space between each**:

```python run
print("Order", "number", 42)
print("Playlist:", "Bohemian Rhapsody", "-", "Queen")
print("Tickets left:", 3)
```

That last line mixes text and a number in one `print`. The comma does the work of putting a space between them, so you don't need to add one yourself.

```python exercise id=postcard title="Write a postcard"
# TODO: print a three-line postcard, one print() per line:
#   line 1: Greetings from ... (any city you like), ending with !
#   line 2: anything you want to say about your trip
#   line 3: exactly: Wish you were here!
print(...)
print(...)
print(...)
--- solution
print("Greetings from Lisbon!")
print("The custard tarts are incredible and the sun never stops shining.")
print("Wish you were here!")
--- test
assert "Ellipsis" not in _stdout, "Replace each `...` with some text in quotes, like `\"Greetings from Rome!\"`."
lines = [line.strip() for line in _stdout.strip().splitlines()]
assert len(lines) == 3, f"Your postcard should be exactly 3 lines, but it printed {len(lines)}. Use one print() per line."
assert lines[0].startswith("Greetings from "), f"Line 1 should start with `Greetings from ` and then a city, but it is {lines[0]!r}."
assert lines[0].endswith("!") and len(lines[0]) > len("Greetings from !"), f"Line 1 should name a city and end with `!`, like `Greetings from Paris!`. Yours is {lines[0]!r}."
assert lines[1], "Line 2 is empty. Write something about your trip."
assert lines[2] == "Wish you were here!", f"Line 3 should be exactly `Wish you were here!`, but it is {lines[2]!r}. Check capitals and the `!`."
--- hint
Each `...` needs to become a piece of text inside quotes, for example `print("Greetings from Tokyo!")`.
--- hint
Line 3 has to match exactly, capital W and exclamation mark included: `print("Wish you were here!")`.
```

## Text versus numbers

Here's the single most important idea on this page. Quotes change *everything*:

```python run
print(2 + 3)
print("2 + 3")
```

Without quotes, `2 + 3` is a **calculation**: Python works it out and prints `5`. With quotes, `"2 + 3"` is just **text**, five characters that happen to look like math, and Python prints them exactly as written. Python never looks inside a string to see if it "means" something.

| You write | Python sees | It prints |
|---|---|---|
| `print(2 + 3)` | a calculation | `5` |
| `print("2 + 3")` | text | `2 + 3` |
| `print("Total:", 2 + 3)` | text, then a calculation | `Total: 5` |

```python predict id=predict-mixed-print title="Text, numbers, or both?"
print("10 + 5 =", 10 + 5)
--- options
10 + 5 = 10 + 5
* 10 + 5 = 15
15 = 15
10 + 5 =15
--- explain
`print` received **two** things: the text `"10 + 5 ="`, shown exactly as written, and the calculation `10 + 5`, which Python works out to `15`. A comma between them puts a single space in the output.
```

## Python is a calculator

Without quotes, Python does arithmetic with the symbols you'd expect, plus `*` for multiply and `/` for divide:

```python run
print("Pizza for 4 people:", 4 * 3, "slices")
print("Cost per person:", 36 / 4)
print("Change from a 50:", 50 - 12 - 18)
print("Hours in a week:", 7 * 24)
```

Python follows the math rules you learned at school: `*` and `/` happen before `+` and `-`, and you can use parentheses to change the order, like `(2 + 3) * 4`. Notice that `36 / 4` printed `9.0`, not `9`. Division always gives a decimal number in Python. You'll learn why, and much more arithmetic, in lesson 4.

> **Coming from Excel:** there's no `=` at the start. In a spreadsheet you type `=7*24`; in Python you just write `7 * 24`. The spaces around the operators are optional, but they make code much easier to read.

```python exercise id=minutes-in-week title="Let Python do the math"
# TODO: print exactly this line:
#   Minutes in a week: 10080
# Don't type 10080 yourself! Let Python calculate it from
# 7 days, 24 hours and 60 minutes, using two values in one print().
print("Minutes in a week:", ...)
--- solution
print("Minutes in a week:", 7 * 24 * 60)
--- test
assert "Ellipsis" not in _stdout, "Replace the `...` with a calculation (no quotes) that multiplies days, hours and minutes."
out = " ".join(_stdout.split())
assert "7 * 24" not in out and "7*24" not in out, "Your calculation is inside quotes, so Python printed it as text. Remove the quotes around the math."
assert out != "Minutes in a week: 168", "That's the number of HOURS in a week. Multiply by 60 as well to get minutes."
assert out == "Minutes in a week: 10080", f"Expected `Minutes in a week: 10080`, but your program printed `{out}`."
--- hint
The `...` should be a calculation, not text, so no quotes around it.
--- hint
Multiply the days by the hours in a day by the minutes in an hour, using `*` between each number.
```

## Controlling spaces and line endings: `sep` and `end`

By default, `print` puts a space *between* values and starts a new line *at the end*. You can change both:

- `sep="..."` sets the **separator** placed between values.
- `end="..."` sets what goes at the **end** instead of a new line.

```python run
print("2026", "10", "22", sep="-")
print("apples", "bread", "milk", sep=", ")
print("Loading", end="...")
print("done!")
```

The third `print` ended with `...` instead of a new line, so the fourth one carried on from the same spot. These go *after* the values, separated by a comma, and their own value is text in quotes.

```python predict id=predict-end title="Where do the lines break?"
print("Ready", end=" ")
print("set", end=" ")
print("go!")
--- options
Ready
Readysetgo!
* Ready set go!
go!
--- explain
`end=" "` replaces the usual new line with a space, so the next `print` continues on the same line. Only the last `print` uses the default ending (a new line), so everything appears on a single line: `Ready set go!`.
```

```python exercise id=clock-time title="Build a digital clock"
# TODO: this prints "09 30 15". Make it print the time as
#   09:30:15
# Keep the three separate values; change only how print() joins them.
print("09", "30", "15")
--- solution
print("09", "30", "15", sep=":")
--- test
out = _stdout.strip()
assert out != "09 30 15", "The parts are still joined by spaces. Which setting controls what goes *between* the values?"
assert out != "09:30:15:", "There's an extra `:` at the end. You only need to change the separator."
assert out == "09:30:15", f"Expected exactly `09:30:15`, but got `{out}`. Check for stray spaces."
--- hint
`print` puts a space between values by default. You can replace that space.
--- hint
Add `sep=` with a colon in quotes as a fourth item inside the parentheses.
```

## Comments: notes for humans

Anything after a `#` on a line is a **comment**. Python ignores it completely. Comments are for the humans who read your code, including you, three weeks from now.

```python run
# Weekly grocery budget calculator
print("Groceries:", 45 + 30 + 12)   # three shops this week

# print("This line is switched off, so it never runs.")
print("Budget left:", 100 - 87)
```

The third line didn't run because it starts with `#`. Putting `#` in front of a line to temporarily switch it off is called **commenting it out**, and it's a quick way to test what happens without a line, without deleting it.

> **Tip:** good comments explain **why**, not what. `# add tax` above `print(price * 1.2)` is fine, but `# UK VAT is 20%` is better: the code already says *what*, the comment tells you *why*.

> **In the wild:** professional teams leave `# TODO:` comments to mark unfinished work, and many code editors list every `TODO` in a project for you. You'll see them in this course's starter code too.

## Reading error messages

Sooner or later (usually sooner) Python will refuse to run your code and show you an **error**. This isn't Python being difficult. An error message is Python telling you *exactly* what confused it and *where*. Learning to read one is a superpower.

### SyntaxError: Python can't understand the code

*Syntax* means grammar. A `SyntaxError` means the code isn't valid Python, like a sentence missing its full stop. Here a closing quote is missing:

```python run error
print("Welcome to the shop!")
print("Today's special: pancakes)
print("Open until 6pm")
```

Notice that **nothing printed**, not even the welcome line, even though line 1 is perfectly fine. Python checks the grammar of the *whole* cell before running any of it. If the grammar is broken anywhere, nothing runs. The message *"unterminated string literal"* means "a piece of text was started with a quote but never closed".

The other classic SyntaxError is a missing parenthesis:

```python run error
print("Total:", 12 + 8
```

*"'(' was never closed"* is Python telling you it saw an opening `(` and reached the end of the code without finding the matching `)`. Every `(` needs a `)`, and every opening quote needs a closing quote.

### NameError: Python doesn't know that word

A `NameError` means you used a name Python has never heard of. Almost always, it's a typo:

```python run error
print("Step 1: Preheat the oven.")
print("Step 2: Mix the ingredients.")
prnt("Step 3: Bake for 20 minutes.")
print("Step 4: Enjoy!")
```

This time the first two lines **did** print. The grammar was fine (`prnt(...)` *looks* like a valid instruction), so Python started running. It only got stuck when it reached line 3 and found that no such thing as `prnt` exists, and it stopped right there. Line 4 never ran. Open the full traceback and you'll see Python even guesses what you meant: *"Did you mean: 'print'?"*

| Error | What it means | When it's caught | Did anything run? |
|---|---|---|---|
| `SyntaxError` | the code isn't valid Python grammar | before running anything | no, nothing |
| `NameError` | a name Python doesn't know (often a typo) | when Python reaches that line | yes, every line before it |

### How to read a traceback

The full error report is called a **traceback**. It looks intimidating, but you read it **from the bottom up**:

```text
Traceback (most recent call last):
  File "<cell>", line 3, in <module>          ← 3. WHERE: line 3
    prnt("Step 3: Bake for 20 minutes.")      ← 2. the exact code
    ^^^^                                      ←    pointing at the problem
NameError: name 'prnt' is not defined. Did you mean: 'print'?
                                              ← 1. START HERE: what went wrong
```

1. **The last line** names the error type (`NameError`) and gives a description. Read this first.
2. **Just above it** is the line of code that failed, often with `^^^` marks under the exact spot.
3. **The line number** tells you where to look in your code.

In this course the failing line is also highlighted in red for you, and **Explain with Atlas** will talk you through any error you don't understand.

> **Pitfall:** Python is **case-sensitive**. `print` and `Print` are completely different names to Python, and only the lowercase one exists. `Print("hi")` is a `NameError`.

## Debug challenges: fix the errors

Each program below has one bug. Press **Run** first and read the error from the bottom up. The error message will lead you straight to the fix.

```python debug id=missing-paren title="Nothing prints at all"
print("=== Movie Night ===")
print("Film: The Princess Bride")
print("Snacks:", "popcorn", "lemonade"
print("Starts at 8pm")
--- solution
print("=== Movie Night ===")
print("Film: The Princess Bride")
print("Snacks:", "popcorn", "lemonade")
print("Starts at 8pm")
--- test
lines = [line.strip() for line in _stdout.strip().splitlines()]
assert len(lines) == 4, f"All 4 lines of the invitation should print, but {len(lines)} did."
assert lines[2] == "Snacks: popcorn lemonade", f"Line 3 should read `Snacks: popcorn lemonade`, but it is {lines[2]!r}."
assert lines[0] == "=== Movie Night ===" and lines[3] == "Starts at 8pm", "Keep the other lines of the invitation exactly as they were."
--- hint
Run it and read the last line of the error: which symbol was "never closed"?
--- hint
Count the opening and closing parentheses on each line. One `print(` is missing its `)`.
```

```python debug id=capital-print title="The packing list stops halfway"
print("Packing list for the beach:")
print("- sunscreen")
print("- towel")
Print("- sunglasses")
print("- a good book")
--- solution
print("Packing list for the beach:")
print("- sunscreen")
print("- towel")
print("- sunglasses")
print("- a good book")
--- test
lines = [line.strip() for line in _stdout.strip().splitlines()]
assert "- sunglasses" in lines, "The sunglasses never got packed. Which line stops the program?"
assert len(lines) == 5, f"All 5 lines should print, but {len(lines)} did."
assert lines == ["Packing list for the beach:", "- sunscreen", "- towel", "- sunglasses", "- a good book"], "Keep every item's text exactly as it was, in the same order."
--- hint
Run it. The first three lines print and then a `NameError` appears. Read its last line: which name doesn't exist?
--- hint
Python is case-sensitive. Compare line 4 with the lines that work, letter by letter.
```

This last one runs without any error at all, which makes it sneakier. The symptom is in the *output*:

```python debug id=receipt-formula title="The receipt shows the formula, not the total"
# A cafe receipt: 2 lattes at 4 each, 1 muffin at 3
print("Lattes:", "2 * 4")
print("Muffin:", 3)
print("Total:", "2 * 4 + 3")
--- solution
# A cafe receipt: 2 lattes at 4 each, 1 muffin at 3
print("Lattes:", 2 * 4)
print("Muffin:", 3)
print("Total:", 2 * 4 + 3)
--- test
out = " ".join(_stdout.split())
assert "*" not in out, "The receipt still shows a `*`. Those calculations are inside quotes, so Python prints them as text."
lines = [" ".join(line.split()) for line in _stdout.strip().splitlines()]
assert lines[0] == "Lattes: 8", f"The lattes line should be `Lattes: 8`, but it is {lines[0]!r}."
assert len(lines) == 3 and lines[2] == "Total: 11", f"The total line should be `Total: 11`, but it is {lines[-1]!r}."
--- hint
Run it and look at the receipt. Is Python calculating, or just repeating what you typed?
--- hint
Quotes mean "this is text, show it exactly". Which quotes are wrapped around something that should be calculated?
```

## Recap

- A **program** is a list of instructions, and Python runs them **top to bottom**, one at a time.
- `print()` displays values. Commas separate several values (shown with spaces), `sep=` changes the separator, and `end=` changes what comes at the end of the line.
- **Quotes make text.** `print(2 + 3)` calculates `5`; `print("2 + 3")` shows the text `2 + 3`.
- `#` starts a **comment**: a note Python ignores, also handy for switching a line off.
- A **SyntaxError** (missing quote or parenthesis) means nothing runs; a **NameError** (usually a typo) stops the program at that line.
- Read tracebacks **bottom up**: error type and message first, then the line number.

**Up next:** variables, so you can give names to values and stop typing the same number over and over.
