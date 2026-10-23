Almost every program does arithmetic somewhere: a shopping cart adds up prices, a fitness app turns seconds into minutes, a game wraps a character around the edge of the screen, a bank applies interest. Python is a superb calculator, but it has a few rules that surprise beginners, like why `7 / 2` and `7 // 2` give different answers, or why `0.1 + 0.2` isn't *quite* `0.3`.

By the end of this page you'll know Python's two kinds of numbers, all seven arithmetic operators (including the two secret weapons `//` and `%`), the order Python calculates in, how to round and compare numbers cleanly, and how to reach for the `math` module when you need square roots or rounding up.

## Two kinds of numbers: `int` and `float`

Python keeps whole numbers and decimal numbers as two different types:

- **`int`** (integer): a whole number with no decimal point, like `3`, `-40` or `2026`.
- **`float`** (floating-point number): a number with a decimal point, like `3.5`, `-0.25` or even `3.0`.

```python run
print(type(42), type(42.0))
print(type(-7), type(98.6))

slices = 8
price = 12.5
print("Mixing them:", slices * price)
```

`42` and `42.0` are the same amount, but not the same type: the decimal point alone makes a `float`. When you mix an `int` and a `float` in a calculation, Python gives you a `float`, so no precision is thrown away.

## The arithmetic operators

Python has seven arithmetic operators. You know the first four already:

| Operator | Name | Example | Result |
|---|---|---|---|
| `+` | addition | `7 + 2` | `9` |
| `-` | subtraction | `7 - 2` | `5` |
| `*` | multiplication | `7 * 2` | `14` |
| `/` | division | `7 / 2` | `3.5` |
| `//` | floor division | `7 // 2` | `3` |
| `%` | modulo (remainder) | `7 % 2` | `1` |
| `**` | exponent (power) | `7 ** 2` | `49` |

```python run
pizzas = 3
slices_per_pizza = 8
people = 5

total_slices = pizzas * slices_per_pizza
print("Total slices:", total_slices)
print("Fair share each:", total_slices / people)
print("Whole slices each:", total_slices // people)
print("Slices left over:", total_slices % people)
print("Area of a 30 cm square pizza box:", 30 ** 2, "square cm")
```

> **Coming from Excel:** the power operator is `**`, not `^`. In Python `^` means something completely different (a bitwise operation you'll rarely need), so `2 ^ 3` gives `1`, not `8`. Always write `2 ** 3`.

### `/` always gives a float

Regular division `/` **always** returns a `float`, even when the answer is a whole number. That's a deliberate choice: the result type is predictable no matter what numbers go in.

```python predict id=predict-division title="Two kinds of division"
print(10 / 2, 10 // 2)
--- options
5 5
* 5.0 5
5.0 5.0
5 5.0
--- explain
`/` is "true division" and always produces a `float`, so `10 / 2` is `5.0`. `//` is floor division: it divides and rounds **down** to a whole number, and with two `int`s it gives an `int`, so `10 // 2` is `5`.
```

## Floor division and modulo: the dynamic duo

`//` and `%` look odd at first, but they answer two everyday questions together:

- `a // b`: *how many **whole** times does `b` fit into `a`?*
- `a % b`: *what's **left over** afterwards?*

Think of packing eggs into boxes of 12. With 30 eggs, `30 // 12` is `2` full boxes and `30 % 12` is `6` eggs left over. The classic use is splitting units, like turning a number of minutes into hours and minutes:

```python run
total_minutes = 135

hours = total_minutes // 60      # how many whole hours fit?
minutes = total_minutes % 60     # what's left over?
print(total_minutes, "minutes is", hours, "h", minutes, "min")
```

Modulo has two more superpowers. `n % 2` is `0` for even numbers and `1` for odd ones, and `%` makes numbers **wrap around**, like the hands of a clock:

```python run
print("17 % 2 =", 17 % 2, "(odd)")
print("24 % 2 =", 24 % 2, "(even)")

now = 22                       # 10 pm on a 24-hour clock
flight_hours = 5
print("You land at", (now + flight_hours) % 24, "o'clock")
```

`22 + 5` is `27`, which isn't a time. `27 % 24` wraps it back to `3`: 3 am. Any time something cycles (hours, days of the week, positions on a circular board game), `%` keeps the number in range.

```python exercise id=running-time title="Format a movie's running time"
movie_minutes = 148

# TODO: split movie_minutes into whole hours and the minutes left over.
# Use // and %, and calculate from movie_minutes (don't type the answers).
hours = ...
minutes = ...

print("Running time:", hours, "h", minutes, "min")
--- solution
movie_minutes = 148

hours = movie_minutes // 60
minutes = movie_minutes % 60

print("Running time:", hours, "h", minutes, "min")
--- test
assert hours is not ..., "Replace the `...` after `hours =` with a calculation."
assert minutes is not ..., "Replace the `...` after `minutes =` with a calculation."
assert isinstance(hours, int), f"`hours` should be a whole number (int), but it is {hours!r}. Did you use `/` instead of `//`?"
assert hours == movie_minutes // 60, f"`hours` should be the number of whole hours in {movie_minutes} minutes, but it is {hours}."
assert minutes != movie_minutes, "`minutes` should be only the minutes left over after taking out the whole hours."
assert minutes == movie_minutes % 60, f"`minutes` should be the leftover minutes after {hours} whole hours, but it is {minutes}."
--- hint
There are 60 minutes in an hour. `//` tells you how many whole hours fit; `%` gives what's left.
--- hint
`hours = movie_minutes // 60`, and `minutes` uses the same two numbers with a different operator.
```

```python exercise id=day-of-week title="What day will it be?"
# Days are numbered 0 = Monday, 1 = Tuesday, ... 6 = Sunday.
today = 3            # Thursday
days_ahead = 100

# TODO: set future_day to the day number (0 to 6) it will be
# `days_ahead` days from `today`. It must wrap around the week.
future_day = ...

print("In", days_ahead, "days it will be day number", future_day)
--- solution
today = 3
days_ahead = 100

future_day = (today + days_ahead) % 7

print("In", days_ahead, "days it will be day number", future_day)
--- test
assert future_day is not ..., "Replace the `...` after `future_day =` with a calculation."
assert future_day != today + days_ahead, f"{future_day} isn't a day of the week. The days repeat every 7, so the number needs to wrap around."
assert isinstance(future_day, int) and 0 <= future_day <= 6, f"`future_day` should be a whole number from 0 to 6, but it is {future_day!r}."
assert future_day == (today + days_ahead) % 7, f"`future_day` should be {(today + days_ahead) % 7}, but it is {future_day}. Did you add `today` before wrapping?"
--- hint
Add the days first, then wrap the total so it stays within one week of 7 days.
--- hint
Use parentheses so the addition happens before the `%`: `(today + days_ahead) % ...`.
```

## Order of operations

Python follows the same order of operations you learned in school, with a couple of extra operators slotted in. Higher rows happen first:

| Priority | Operators | Meaning |
|---|---|---|
| 1 (first) | `( )` | anything in parentheses |
| 2 | `**` | exponent |
| 3 | `-x` | negative sign |
| 4 | `*` `/` `//` `%` | multiply and divide family, left to right |
| 5 (last) | `+` `-` | add and subtract, left to right |

```python predict id=predict-precedence title="Who goes first?"
2 + 3 * 4 ** 2
--- options
400
196
* 50
146
--- explain
The exponent goes first: `4 ** 2` is `16`. Then multiplication: `3 * 16` is `48`. Addition comes last: `2 + 48` is `50`. If you wanted a different order, you'd need parentheses, like `(2 + 3) * 4` for `20`.
```

When in doubt, add parentheses. They cost nothing and make your intent obvious to the next reader:

```python run
book = 40
bookmark = 5

# A 10% discount means paying 0.9 of the price
print("10% off everything:      ", (book + bookmark) * 0.9)
print("10% off the bookmark only:", book + bookmark * 0.9)
```

Same numbers, same operators, different answers. Without parentheses, only `bookmark` gets multiplied by `0.9`, which is probably not what the shop intended.

> **Pitfall:** `-2 ** 2` is `-4`, not `4`, because `**` happens before the negative sign. Write `(-2) ** 2` if you mean "negative two, squared".

```python debug id=average-too-high title="The average is higher than both scores"
match_1 = 82
match_2 = 90

average = match_1 + match_2 / 2
print("Average score:", average)
--- solution
match_1 = 82
match_2 = 90

average = (match_1 + match_2) / 2
print("Average score:", average)
--- test
assert average != match_1 + match_2 / 2, f"The average is {average}, higher than both scores. Python is still dividing only `match_2` by 2."
assert average == (match_1 + match_2) / 2, f"`average` should be halfway between {match_1} and {match_2}, but it is {average}."
--- hint
Run it. An average can never be bigger than both numbers, so something's off with the order of operations.
--- hint
Division happens before addition. How do you make the addition happen first?
```

## When a calculation is impossible

Dividing by zero has no answer, so Python stops with an error instead of guessing:

```python run error
total_points = 0
games_played = 0
print("Points per game:", total_points / games_played)
```

Read it from the bottom: `ZeroDivisionError: division by zero`. The `~~~^~~~` marks under the line point at the exact `/` that failed. This often happens with real data, like a new player who hasn't played any games yet. In lesson 9 you'll learn to check for zero first with `if`, and in lesson 23 to catch the error.

## Handy built-ins: `round`, `abs`, `min`, `max`

Python comes with a few number functions ready to use, no setup needed:

```python run
print(round(21.456))          # nearest whole number
print(round(21.456, 1))       # 1 decimal place
print(abs(-12.5))             # distance from zero: drops the minus sign
print(min(18, 7, 25, 11))     # smallest of any number of values
print(max(18.5, 22.1, 15.0))  # largest
```

| Function | What it does | Example | Result |
|---|---|---|---|
| `round(x)` | nearest whole number | `round(4.7)` | `5` |
| `round(x, n)` | round to `n` decimal places | `round(3.14159, 2)` | `3.14` |
| `abs(x)` | absolute value | `abs(-8)` | `8` |
| `min(a, b, ...)` | smallest value | `min(4, 9, 2)` | `2` |
| `max(a, b, ...)` | largest value | `max(4, 9, 2)` | `9` |

```python predict id=predict-round-half title="Rounding halves"
print(round(2.5), round(3.5))
--- options
3 4
* 2 4
2 3
3.0 4.0
--- explain
Python rounds exact halves to the nearest **even** number ("banker's rounding"), so `2.5` becomes `2` and `3.5` becomes `4`. It avoids a bias: always rounding halves up would nudge totals upwards over thousands of values. Most of the time you won't notice, but now you won't be surprised either.
```

```python exercise id=weather-stats title="Weekly weather report"
mon, tue, wed, thu = 18.4, 22.7, 15.9, 21.3   # daily highs in degrees C

# TODO: define these four variables from mon, tue, wed and thu:
#   highest: the warmest day's temperature
#   lowest:  the coldest day's temperature
#   spread:  highest minus lowest, rounded to 1 decimal place
#   average: the mean of the four days, rounded to 1 decimal place
highest = ...
lowest = ...
spread = ...
average = ...

print("High:", highest, "| Low:", lowest, "| Spread:", spread, "| Average:", average)
--- solution
mon, tue, wed, thu = 18.4, 22.7, 15.9, 21.3

highest = max(mon, tue, wed, thu)
lowest = min(mon, tue, wed, thu)
spread = round(highest - lowest, 1)
average = round((mon + tue + wed + thu) / 4, 1)

print("High:", highest, "| Low:", lowest, "| Spread:", spread, "| Average:", average)
--- test
for _name, _val in [("highest", highest), ("lowest", lowest), ("spread", spread), ("average", average)]:
    assert _val is not ..., f"Replace the `...` after `{_name} =` with your calculation."
assert highest == max(mon, tue, wed, thu), f"`highest` should be the warmest of the four days, but it is {highest}."
assert lowest == min(mon, tue, wed, thu), f"`lowest` should be the coldest of the four days, but it is {lowest}."
_spread = round(max(mon, tue, wed, thu) - min(mon, tue, wed, thu), 1)
assert abs(spread - _spread) < 1e-9, f"`spread` should be {_spread}, but it is {spread}. Did you round to 1 decimal place?"
_avg = (mon + tue + wed + thu) / 4
assert abs(average - _avg) > 1e-9 or round(_avg, 1) == _avg, f"`average` is {average}, which isn't rounded yet. Use `round(..., 1)`."
assert abs(average - round(_avg, 1)) < 1e-9, f"`average` should be the mean of the four days rounded to 1 place ({round(_avg, 1)}), but it is {average}. Check your parentheses."
--- hint
`max()` and `min()` accept any number of values separated by commas.
--- hint
`round(value, 1)` rounds to one decimal place. For the average, add all four days inside parentheses before dividing by 4.
```

## Why `0.1 + 0.2` isn't `0.3`

Here's a famous surprise:

```python run
print(0.1 + 0.2)
print(1.1 + 2.2)
print("Rounded for display:", round(0.1 + 0.2, 2))
```

Python isn't broken; every programming language does this. Computers store floats in **binary** (base 2), and most decimal fractions, like `0.1`, can't be written exactly in binary. It's the same reason you can't write 1/3 exactly in decimal: `0.3333...` goes on forever and has to be cut off somewhere. Those tiny cut-off errors occasionally show up in the 17th digit.

What this means for you:

- For **display**, round: `round(total, 2)`. (Lesson 6 shows an even neater way.)
- Don't expect two float calculations to be *exactly* equal. Compare them with a small tolerance instead; you'll see how in lesson 7.

> **In the wild:** payment systems like Stripe store money as whole numbers of **cents** (`1999` instead of `19.99`), because `int`s are always exact. Python also has a `decimal` module for exact decimal arithmetic in finance code.

## Big numbers and readable numbers

Unlike floats, Python's `int`s are **exact and unlimited**. They can be as big as your computer's memory allows, and you'll never lose a digit. To make long numbers readable, you can put underscores in them, the way you'd use commas on paper:

```python run
world_population = 8_100_000_000
print("People:", world_population)
print("Grains of rice on the 64th chess square:", 2 ** 63)
print("Exact:", 2 ** 100)
```

The underscores are just for humans. Python ignores them, so `8_100_000_000` and `8100000000` are the same number.

## The `math` module

For anything beyond basic arithmetic, Python has a **module** (a toolbox of extra functions) called `math`. You load it once with `import math`, then use its tools by writing `math.` followed by the name. You'll learn all about modules in lesson 25.

```python run
import math

print("Square root of 144:", math.sqrt(144))
print("Pi:", math.pi)
print("Area of a 10 cm radius pizza:", round(math.pi * 10 ** 2, 1))
print("floor(4.9):", math.floor(4.9), "| ceil(4.1):", math.ceil(4.1))
```

`math.floor` always rounds **down** and `math.ceil` (short for *ceiling*) always rounds **up**, whatever the decimal. That's different from `round`, which goes to the *nearest* whole number. Rounding up is exactly what you need when "a bit extra" still needs a whole extra thing, like a box, a bus or a page.

```python exercise id=egg-boxes title="How many egg boxes?"
import math

eggs = 75
box_size = 12

# TODO: every egg needs a place in a box, so a partly filled box
# still counts as a box. Set boxes_needed to a whole number,
# calculated from eggs and box_size.
boxes_needed = ...

print("Boxes needed:", boxes_needed)
--- solution
import math

eggs = 75
box_size = 12

boxes_needed = math.ceil(eggs / box_size)

print("Boxes needed:", boxes_needed)
--- test
import math as _m
assert boxes_needed is not ..., "Replace the `...` after `boxes_needed =` with a calculation."
_exact = eggs / box_size
assert boxes_needed != _exact, f"You can't buy {boxes_needed} boxes. Round to a whole number of boxes."
assert boxes_needed != eggs // box_size, f"{boxes_needed} boxes only hold {boxes_needed * box_size} eggs, but there are {eggs}. The leftover eggs need a box too, so round **up**."
assert isinstance(boxes_needed, int), f"`boxes_needed` should be a whole number (int), but it is {boxes_needed!r}."
assert boxes_needed == _m.ceil(eggs / box_size), f"`boxes_needed` should be {_m.ceil(eggs / box_size)}, but it is {boxes_needed}."
--- hint
`eggs / box_size` is about 6.25 boxes. Rounding to the nearest whole number would leave some eggs without a box.
--- hint
One of the two `math` functions above always rounds **up**. Wrap the division in it.
```

## Debug challenge: the wrong kind of division

```python debug id=half-a-team title="Seven and a half teams"
# 30 players sign up for a 4-a-side football tournament.
players = 30
team_size = 4

full_teams = players / team_size
on_the_bench = players - full_teams * team_size

print("Full teams:", full_teams)
print("Players on the bench:", on_the_bench)
--- solution
players = 30
team_size = 4

full_teams = players // team_size
on_the_bench = players - full_teams * team_size

print("Full teams:", full_teams)
print("Players on the bench:", on_the_bench)
--- test
assert full_teams != players / team_size, f"`full_teams` is {full_teams}. You can't field half a team. Only count the teams that are complete."
assert isinstance(full_teams, int), f"`full_teams` should be a whole number (int), but it is {full_teams!r}."
assert full_teams == players // team_size, f"`full_teams` should be {players // team_size}, but it is {full_teams}."
assert on_the_bench == players % team_size, f"{on_the_bench} players on the bench doesn't look right; it should be the players left over after forming full teams."
--- hint
Run it: 7.5 teams and 0.0 players on the bench. Which operator gave a fraction of a team?
--- hint
You want "how many whole times does 4 fit into 30". That's a different division operator.
```

## Recap

- Python has two number types: **`int`** for whole numbers and **`float`** for decimals. Mixing them gives a `float`.
- `/` always returns a `float`. `//` divides and rounds down; `%` gives the remainder. Together they split units, test even/odd and wrap values around.
- `**` is the exponent. Order of operations: parentheses, `**`, then `* / // %`, then `+ -`. When in doubt, use parentheses.
- `round()`, `abs()`, `min()` and `max()` are built in. `round` sends exact halves to the even number.
- Floats can be slightly imprecise (`0.1 + 0.2`), so round for display. `int`s are exact at any size, and `1_000_000` is a readable way to write big ones.
- `import math` gives you `math.sqrt`, `math.pi`, `math.floor` (round down) and `math.ceil` (round up).

**Up next:** strings: working with text, from quotes and special characters to picking out letters with indexing and slicing.
