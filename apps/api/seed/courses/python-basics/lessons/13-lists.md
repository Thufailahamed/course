So far, every variable you've made has held **one** value: one price, one name, one temperature. But real programs juggle many values at once. A playlist has dozens of songs. A shopping cart has a handful of items. A week of weather is seven temperatures. Making `song1`, `song2`, `song3`… by hand doesn't scale, and you couldn't loop over them anyway.

A **list** solves this. It's one name for a whole ordered row of values that you can index, slice, loop over, grow and change. Lists are the most used collection in Python. By the end of this lesson you'll build lists from scratch, update them in place, compute totals and averages, and even store a grid like a cinema seat map.

## Your first list

Write a list with square brackets, separating the items with commas:

```python run
playlist = ["Levitating", "Blinding Lights", "Shivers", "As It Was"]

print(playlist)
print("songs:", len(playlist))
playlist
```

Look at the grey chip under the result: `list · len 4`. The list is **one value** that holds four others, in the order you wrote them. `len()` works on lists exactly as it did on strings: it counts the items.

A good mental picture is a row of numbered boxes, with one name tag on the whole row:

```text
playlist ──► ┌──────────────┬───────────────────┬───────────┬─────────────┐
             │ "Levitating" │ "Blinding Lights" │ "Shivers" │ "As It Was" │
             └──────────────┴───────────────────┴───────────┴─────────────┘
   index:           0                 1               2            3
```

Lists can hold any kind of value, including a mix of kinds, and they can be empty. An empty list `[]` is the usual starting point when you're about to collect things.

```python run
cart = []                                  # nothing in it yet
temperatures = [18.5, 21.0, 19.8, 23.4]    # floats
order = ["coffee", 2, 3.5, True]           # mixed: str, int, float, bool

print("cart:", cart, "length", len(cart))
print("temperatures:", temperatures)
print("order:", order)
```

> **Tip:** Mixed lists are legal, but in practice most lists hold one *kind* of thing: all prices, all names, all scores. That makes them easy to loop over and sum. When you want to bundle different facts about one thing (a name, an age, a city), you'll meet better tools in the next few lessons: tuples and dictionaries.

> **Coming from Excel:** a list is like a single column of cells. The difference is that Python counts rows from **0**, not 1.

## Indexing and slicing work just like strings

Everything you learned about string positions in lesson 5 carries straight over. Index from `0` at the front, or from `-1` at the back. Slices use `[start:stop:step]`, and `stop` is never included.

```python run
week = [14, 17, 21, 19, 23, 25, 16]   # daily highs, Monday to Sunday

print("Monday:   ", week[0])
print("Sunday:   ", week[-1])
print("weekdays: ", week[0:5])     # positions 0,1,2,3,4
print("weekend:  ", week[5:])      # from 5 to the end
print("every 2nd:", week[::2])
print("reversed: ", week[::-1])
```

Notice the difference in what you get back. A single index gives you **one item** (an `int` here). A slice always gives you **a new list**, even if it holds just one item, or none.

Ask for a position that doesn't exist and Python stops with an `IndexError`. A seven-day list has positions `0` to `6`, so `7` is one past the end:

```python run error
week = [14, 17, 21, 19, 23, 25, 16]
print("items:", len(week))
print(week[7])
```

Read the last line of the error first: `IndexError: list index out of range`. The traceback's line number points at `week[7]`. Whenever you see this, ask "how long is the list, and which position did I ask for?" Slices, by contrast, are forgiving: `week[5:100]` quietly stops at the end of the list.

```python predict id=predict-index-slice title="Index or slice?"
scores = [88, 92, 75, 64, 99]
print(scores[1], scores[-1], scores[1:3])
--- options
88 64 [88, 92, 75]
* 92 99 [92, 75]
92 99 [92, 75, 64]
88 99 [92, 75]
--- explain
Counting starts at 0, so `scores[1]` is the **second** item, `92`. `scores[-1]` is always the last item, `99`. The slice `scores[1:3]` takes positions 1 and 2 and stops **before** 3, giving `[92, 75]`. A single index gives an item; a slice gives a list.
```

## Lists are mutable: you can change them in place

Here's the big difference from strings. Strings are **immutable**: `name[0] = "J"` is a `TypeError`. Lists are **mutable**: you can replace any item by assigning to its position, and the list changes in place.

```python run
groceries = ["eggs", "milk", "bread", "apples"]

groceries[1] = "oat milk"     # swap one item
groceries[-1] = "pears"       # the last one too
print(groceries)

word = "bread"
letters = list(word)          # turn a string into a list of characters
letters[0] = "B"
print(letters)
```

The list still has four items; two of them are new. The string `word` is untouched because `list(word)` made a separate list of its characters. (More on `list(...)` in a moment.)

> **Under the hood:** a list doesn't really store its items "inside" itself. Each box holds a reference to a value that lives elsewhere in memory. Assigning `groceries[1] = "oat milk"` points box 1 at a different value. This detail matters a lot in the next lesson, when two names end up pointing at the *same* list.

```python predict id=predict-mutate title="Change one letter"
letters = list("cat")
letters[0] = "b"
print(letters, len(letters))
--- options
bat 3
* ['b', 'a', 't'] 3
['bat'] 1
['b', 'cat'] 2
--- explain
`list("cat")` splits the string into a list of single characters, `['c', 'a', 't']`. Assigning to position `0` replaces `'c'` with `'b'`. It's still a list (Python prints lists with brackets and quotes around strings), and it still has 3 items. To glue the letters back into a string you'd use `"".join(letters)` from lesson 6.
```

```python exercise id=update-leaderboard title="Update the leaderboard"
# A game leaderboard, best player first.
leaderboard = ["Ava", "Ben", "Chloe", "Dev", "Emma"]

# TODO 1: Chloe was disqualified. Replace her (position 2) with "Farah".
#         Replace the ... on the next line with one assignment.
...

# TODO 2: `winner` is the first name; `last_place` is the last name.
#         Use a negative index for last_place.
winner = ...
last_place = ...

# TODO 3: `podium` is a NEW list of the top three names. Use a slice.
podium = ...

print("Winner:", winner)
print("Last place:", last_place)
print("Podium:", podium)
--- solution
leaderboard = ["Ava", "Ben", "Chloe", "Dev", "Emma"]

leaderboard[2] = "Farah"

winner = leaderboard[0]
last_place = leaderboard[-1]

podium = leaderboard[:3]

print("Winner:", winner)
print("Last place:", last_place)
print("Podium:", podium)
--- test
assert winner is not ... and last_place is not ... and podium is not ..., "Replace each `...` after `winner =`, `last_place =` and `podium =` with your code."
assert isinstance(leaderboard, list) and len(leaderboard) == 5, f"`leaderboard` should still be a list of 5 names, but it is {leaderboard!r}. Replace Chloe; don't add or remove anyone."
assert "Chloe" not in leaderboard, "Chloe is still on the leaderboard. Assign a new name to her position with `leaderboard[2] = ...`."
assert leaderboard == ["Ava", "Ben", "Farah", "Dev", "Emma"], f"`leaderboard` should be ['Ava', 'Ben', 'Farah', 'Dev', 'Emma'] but is {leaderboard!r}. Remember positions start at 0."
assert winner == "Ava", f"`winner` should be the first name on the leaderboard, but is {winner!r}. The first position is 0, not 1."
assert last_place == "Emma", f"`last_place` should be the last name, but is {last_place!r}. Try index -1."
assert isinstance(podium, list), f"`podium` should be a list (a slice), but it's a {type(podium).__name__}."
assert podium == ["Ava", "Ben", "Farah"], f"`podium` should be the first three names after the swap, but is {podium!r}. The slice stops *before* its end index."
--- hint
Assigning to a position looks like assigning to a variable, with the index in brackets on the left: `some_list[position] = new_value`.
--- hint
Index `0` is the first item and `-1` is the last. A slice like `[:3]` takes positions 0, 1 and 2.
--- hint
TODO 1 is `leaderboard[2] = "Farah"`. Do it *before* building `podium`, so the podium includes Farah.
```

## Checking membership and looping

The `in` operator asks "is this value somewhere in the list?" and gives a `bool`, just like it did for strings. And a `for` loop visits every item in order, which you've already been doing with literal lists since lesson 11.

```python run
pantry = ["rice", "pasta", "tomatoes", "garlic", "olive oil"]

print("garlic" in pantry)        # True
print("basil" in pantry)         # False
print("basil" not in pantry)     # True

for item in pantry:
    print("-", item.title())
```

Sometimes you need the **position** as well as the item, for example to number a list or to look something up in a second list at the same position. Loop over `range(len(...))` and index with the loop variable:

```python run
dishes = ["Pad Thai", "Margherita", "Ramen"]
prices = [11.50, 9.00, 13.25]

for i in range(len(dishes)):
    print(f"{i + 1}. {dishes[i]:<12} ${prices[i]:.2f}")
```

`range(len(dishes))` produces `0, 1, 2`: exactly the valid positions, because `range` stops *before* its end, and a list of length 3 ends at position 2. That's the same "stop is excluded" rule as slices, and it's why the two fit together so neatly.

> **Tip:** If you only need the items, loop over the list directly (`for dish in dishes`). It's shorter and can't go out of range. In lesson 22 you'll meet `enumerate()` and `zip()`, which make the "position plus item" and "two lists side by side" cases even cleaner.

```python debug id=newest-order-crash title="Showing the newest order crashes"
# A coffee shop queue: oldest order first, newest order last.
orders = ["latte", "mocha", "espresso", "chai", "flat white"]

oldest = orders[0]
newest = orders[len(orders)]

print(f"{len(orders)} orders waiting")
print("Make first:", oldest)
print("Most recent:", newest)
--- solution
orders = ["latte", "mocha", "espresso", "chai", "flat white"]

oldest = orders[0]
newest = orders[-1]

print(f"{len(orders)} orders waiting")
print("Make first:", oldest)
print("Most recent:", newest)
--- test
assert oldest == "latte", f"`oldest` should be the first order, 'latte', but is {oldest!r}."
assert newest == "flat white", f"`newest` should be the last order, 'flat white', but is {newest!r}."
assert "Most recent: flat white" in _stdout, "Keep the print lines so the barista sees the most recent order."
--- hint
Run it and read the last line of the error. How many orders are there, and which positions exist?
--- hint
The list has 5 items, so its positions are 0 to 4. `len(orders)` is 5: one past the end. You want the position just before that, or the "count from the back" index.
```

## Building a list with `append`

Most lists aren't typed out by hand. They're **built up** while a program runs: start with an empty list, then add to the end with `.append(value)`. It's the list version of the accumulator pattern from lesson 11.

```python run
prices = [3.99, 12.50, 0.99, 24.00, 7.25, 1.49]

bargains = []                  # start empty
for price in prices:
    if price < 5:
        bargains.append(price) # add to the end

print("bargains:", bargains)
print("how many:", len(bargains))
```

Step through it with **Debug** and watch `bargains` grow one item at a time in the Variables table.

`.append()` is a **method**, an action the list knows how to do, just like `.upper()` is an action a string knows. But there's a key difference. String methods return a *new* string and leave the original alone. List methods like `.append()` **change the list itself**. That's mutability at work, and it's why you write `bargains.append(price)` on its own line, not `bargains = bargains.append(price)`. You'll see exactly what goes wrong with that second version in the next lesson.

> **In the wild:** "start with `[]`, loop, `append`" is everywhere in real code: collecting the rows of a spreadsheet that match a filter, gathering error messages to show a user all at once, or saving each day's reading from a sensor. In lesson 18 you'll learn a one-line shortcut for it, the list comprehension.

```python exercise id=convert-temperatures title="Convert a week of temperatures"
celsius = [12.5, 18.0, 21.3, 25.0, 30.8, 16.2]

# TODO 1: Build `fahrenheit`: each temperature converted with
#         F = C * 9 / 5 + 32, rounded to 1 decimal place, in the same order.
# TODO 2: Build `warm_days`: the Celsius temperatures that are 20 or more.
fahrenheit = []
warm_days = []
for c in celsius:
    ...

print("Fahrenheit:", fahrenheit)
print("Warm days (C):", warm_days)
--- solution
celsius = [12.5, 18.0, 21.3, 25.0, 30.8, 16.2]

fahrenheit = []
warm_days = []
for c in celsius:
    fahrenheit.append(round(c * 9 / 5 + 32, 1))
    if c >= 20:
        warm_days.append(c)

print("Fahrenheit:", fahrenheit)
print("Warm days (C):", warm_days)
--- test
assert isinstance(fahrenheit, list) and isinstance(warm_days, list), "Keep `fahrenheit` and `warm_days` as lists and add to them with `.append()`."
assert fahrenheit != [], "`fahrenheit` is still empty. Inside the loop, convert `c` and `.append()` the result to `fahrenheit`."
assert len(fahrenheit) == len(celsius), f"`fahrenheit` should have one value per Celsius temperature ({len(celsius)}), but has {len(fahrenheit)}. Is the append inside the loop, and not inside the `if`?"
expected_f = [round(c * 9 / 5 + 32, 1) for c in celsius]
for got, c in zip(fahrenheit, celsius):
    exact = c * 9 / 5 + 32
    assert isinstance(got, (int, float)), f"Each Fahrenheit value should be a number, but found {got!r}."
    assert abs(got - exact) < 0.06, f"{c}°C should convert to about {round(exact, 1)}°F, but your list has {got}. Check the formula: C * 9 / 5 + 32."
assert fahrenheit == expected_f, f"Round each value to 1 decimal place with `round(value, 1)`. Expected {expected_f}, got {fahrenheit}."
assert warm_days == [c for c in celsius if c >= 20], f"`warm_days` should hold the Celsius temperatures of 20 or more, in order, but is {warm_days!r}. Did you use > instead of >=?"
--- hint
Inside the loop, `c` is one Celsius temperature. Work out its Fahrenheit value, then add it to the end of `fahrenheit`.
--- hint
`round(value, 1)` rounds to one decimal. `fahrenheit.append(...)` adds to the list. For `warm_days`, put an `if c >= 20:` inside the same loop.
--- hint
The loop body is two parts: `fahrenheit.append(round(c * 9 / 5 + 32, 1))`, then an `if` that appends `c` to `warm_days`.
```

## `sum`, `min` and `max` on lists

You met `min()` and `max()` with separate numbers in lesson 4. Hand them a list and they look through the whole thing. `sum()` adds every item up. Together with `len()`, that gives you an average in one line:

```python run
steps = [8_204, 10_550, 6_120, 12_087, 9_430]   # five days of step counts

total = sum(steps)
average = total / len(steps)

print("total:  ", total)
print("average:", round(average))
print("best:   ", max(steps))
print("worst:  ", min(steps))
```

`min` and `max` also work on a list of strings, where they compare alphabetically (`max(["pear", "apple", "fig"])` is `"pear"`). `sum` only works on numbers.

> **Pitfall:** `sum([])` is `0`, but `max([])` and `min([])` raise a `ValueError`, because an empty list has no largest item. Dividing by `len([])` raises `ZeroDivisionError`. If a list might be empty, check first with `if steps:` (an empty list is falsy, as you saw in lesson 7).

```python exercise id=workout-stats title="Weekly workout stats"
minutes = [32, 45, 0, 28, 60, 15, 41]   # minutes exercised, Monday to Sunday

# TODO: compute these from `minutes` (don't type the answers in by hand).
total = ...         # total minutes this week
average = ...       # average minutes per day, rounded to 1 decimal place
best = ...          # the most minutes on any single day
active_days = ...   # how many days had 30 minutes or more

print(f"Total: {total} min, average: {average} min/day")
print(f"Best day: {best} min, active days: {active_days}")
--- solution
minutes = [32, 45, 0, 28, 60, 15, 41]

total = sum(minutes)
average = round(total / len(minutes), 1)
best = max(minutes)
active_days = 0
for m in minutes:
    if m >= 30:
        active_days += 1

print(f"Total: {total} min, average: {average} min/day")
print(f"Best day: {best} min, active days: {active_days}")
--- test
assert total is not ... and average is not ... and best is not ... and active_days is not ..., "Replace every `...` with a calculation that uses `minutes`."
assert total == sum(minutes), f"`total` should be the sum of all the minutes ({sum(minutes)}), but is {total!r}. Try `sum(minutes)`."
exact = sum(minutes) / len(minutes)
assert not (isinstance(average, int) and average == sum(minutes) // len(minutes)), f"`average` is {average}, a whole number. Use `/` (true division), not `//`."
assert isinstance(average, (int, float)) and abs(average - exact) < 0.051, f"`average` should be the total divided by the number of days (about {exact:.3f}), but is {average!r}."
assert average == round(exact, 1), f"Round the average to 1 decimal place: it should be {round(exact, 1)}, not {average}."
assert best == max(minutes), f"`best` should be the largest value in `minutes` ({max(minutes)}), but is {best!r}."
expected_active = len([m for m in minutes if m >= 30])
assert active_days == expected_active, f"`active_days` should be {expected_active}, but is {active_days!r}. Count days where minutes >= 30 (30 itself counts)."
--- hint
Python has built-ins for three of these: one adds up a list, one finds the biggest item, and `len()` counts the days.
--- hint
`average` is `sum(minutes) / len(minutes)`, wrapped in `round(..., 1)`. For `active_days`, use the counting pattern from lesson 12: start at 0, loop, add 1 when the condition holds.
--- hint
`active_days = 0`, then `for m in minutes:` with `if m >= 30: active_days += 1` inside.
```

## Making lists from other things: `list()`

`list(...)` turns anything you can loop over into a list. That includes a string (one item per character) and a `range` (one item per number). And `str.split()`, which you met in lesson 6, already hands you a list.

```python run
print(list("hello"))
print(list(range(5)))
print(list(range(10, 0, -3)))

csv_line = "Tokyo,Paris,Lima,Cairo"
cities = csv_line.split(",")
print(cities, "->", len(cities), "cities")
```

`list(range(5))` is a handy way to *see* what a range contains: `range` on its own is a lazy recipe for numbers, not a list.

```python predict id=predict-list-range title="A list from a range"
nums = list(range(2, 11, 3))
print(nums, sum(nums))
--- options
[2, 5, 8, 11] 26
* [2, 5, 8] 15
[2, 3, 4, 5, 6, 7, 8, 9, 10] 54
[3, 6, 9] 18
--- explain
`range(2, 11, 3)` starts at 2 and counts up by 3: 2, 5, 8. The next number, 11, is the stop value, and **stop is never included**. `list(...)` collects those numbers into `[2, 5, 8]`, and their sum is 15.
```

## Lists inside lists: grids

A list can hold other lists. That's the natural way to store anything with rows and columns: a game board, a seating chart, a calendar month, a spreadsheet.

```python run
# A tic-tac-toe board: a list of 3 rows, each row a list of 3 squares.
board = [
    ["X", "O", "X"],
    [" ", "X", "O"],
    ["O", " ", "X"],
]

print("rows:", len(board))
print("middle row:", board[1])
print("middle square:", board[1][1])
print("bottom-left:", board[2][0])
```

Read `board[1][1]` from left to right: `board[1]` is the middle **row** (itself a list), and `[1]` picks the middle **square** of that row. Row first, then column.

```text
             col 0  col 1  col 2
board[0] ──► [ "X" , "O" , "X" ]
board[1] ──► [ " " , "X" , "O" ]      board[1][1] is "X"
board[2] ──► [ "O" , " " , "X" ]      board[2][0] is "O"
```

To visit every square, nest two loops: the outer loop walks the rows, the inner loop walks the squares in the current row. It's the same nested-loop shape as the multiplication table in lesson 11.

```python run
board[1][0] = "O"     # O plays the empty middle-left square

for row in board:
    line = ""
    for square in row:
        line += f"[{square}]"
    print(line)
```

```python predict id=predict-grid title="Rows and columns"
grid = [[1, 2, 3], [4, 5, 6]]
print(len(grid), grid[1][0], grid[0][-1])
--- options
6 4 3
2 2 3
* 2 4 3
3 4 6
--- explain
`grid` holds **two** items (two inner lists), so `len(grid)` is `2`, not 6: `len` only counts the top level. `grid[1]` is the second row `[4, 5, 6]`, and its item `[0]` is `4`. `grid[0]` is `[1, 2, 3]`, and `[-1]` is its last item, `3`.
```

```python exercise id=cinema-seats title="Book a cinema seat"
# A tiny cinema. "O" = free seat, "X" = taken. Row 0 is the front.
seats = [
    ["X", "X", "O", "O"],
    ["O", "X", "O", "X"],
    ["O", "O", "O", "O"],
]

# TODO 1: You book the seat in row 1, column 2. Mark it as taken.
#         Replace the ... on the next line with one assignment.
...

# TODO 2: Count how many seats are still free in the whole cinema
#         (after your booking) and store the number in `free`.
free = ...

for row in seats:
    print(" ".join(row))
print("Free seats:", free)
--- solution
seats = [
    ["X", "X", "O", "O"],
    ["O", "X", "O", "X"],
    ["O", "O", "O", "O"],
]

seats[1][2] = "X"

free = 0
for row in seats:
    for seat in row:
        if seat == "O":
            free += 1

for row in seats:
    print(" ".join(row))
print("Free seats:", free)
--- test
assert free is not ..., "Replace the `...` after `free =` with code that counts the free seats."
original = [["X", "X", "O", "O"], ["O", "X", "O", "X"], ["O", "O", "O", "O"]]
assert isinstance(seats, list) and len(seats) == 3 and all(isinstance(r, list) and len(r) == 4 for r in seats), "`seats` should still be 3 rows of 4 seats. Change one seat, don't replace whole rows."
assert seats[1][2] == "X", f"Row 1, column 2 should now be 'X', but it's {seats[1][2]!r}. Index the row first, then the column: `seats[row][col]`."
changed = [(r, c) for r in range(3) for c in range(4) if seats[r][c] != original[r][c]]
assert changed == [(1, 2)], f"Only the seat at row 1, column 2 should change, but these changed: {changed}. Check the order of your indexes."
expected_free = sum(row.count("O") for row in seats)
assert free != expected_free + 1, f"`free` is {free}: that's the count from *before* your booking. Count after marking the seat."
assert free == expected_free, f"`free` should be {expected_free}, but is {free!r}. Loop over every row, and every seat in each row."
--- hint
Booking means replacing one item inside one inner list. `seats[1]` is row 1; add a second index for the column.
--- hint
For TODO 2, use the counting pattern with a nested loop: start `free` at 0, loop `for row in seats:`, then `for seat in row:`, and add 1 when the seat is `"O"`.
--- hint
TODO 1 is `seats[1][2] = "X"`. For TODO 2, replace the `free = ...` line with `free = 0` followed by the two loops.
```

## Debug challenge: the receipt that skips an item

Off-by-one mistakes with `range(len(...))` are the classic list bug. The code runs perfectly, the output *looks* fine at a glance, and the answer is quietly wrong.

```python debug id=receipt-skips-item title="The receipt total is too low"
items = ["milk", "cheese", "bread", "coffee"]
prices = [4.50, 12.00, 3.25, 8.75]

total = 0
for i in range(1, len(prices)):
    print(f"{items[i]:<8} ${prices[i]:>6.2f}")
    total += prices[i]

print(f"{'TOTAL':<8} ${total:>6.2f}")
--- solution
items = ["milk", "cheese", "bread", "coffee"]
prices = [4.50, 12.00, 3.25, 8.75]

total = 0
for i in range(len(prices)):
    print(f"{items[i]:<8} ${prices[i]:>6.2f}")
    total += prices[i]

print(f"{'TOTAL':<8} ${total:>6.2f}")
--- test
assert abs(total - 24.00) > 0.001, "The total is still $24.00. One item is never added. Which one is missing from the printed receipt?"
assert abs(total - sum(prices)) < 0.001, f"`total` should be ${sum(prices):.2f} (every price added once), but is ${total:.2f}."
lines = [line.split() for line in _stdout.strip().splitlines()]
names = [parts[0] for parts in lines if parts]
for item in items:
    assert names.count(item) == 1, f"The receipt should list {item!r} exactly once, but it appears {names.count(item)} time(s)."
assert "TOTAL" in _stdout and "28.50" in _stdout, "Print the TOTAL line at the end of the receipt."
--- hint
Run it and read the receipt. Four items went in the cart; how many lines are printed?
--- hint
The first item in a list is at position 0. Which positions does `range(1, len(prices))` produce?
```

## Recap

- A **list** is an ordered collection in square brackets: `["a", "b", "c"]`. `[]` is an empty list, and `len()` counts the items.
- Indexing and slicing work exactly like strings: positions start at 0, `-1` is the last item, and a slice's stop is excluded. A position past the end raises `IndexError`; the last valid index is `len(lst) - 1`.
- Lists are **mutable**: `lst[i] = value` replaces an item in place, and `.append(value)` adds to the end. Start with `[]` and append in a loop to build a list.
- `in` checks membership, `for item in lst` visits every item, and `range(len(lst))` gives every valid position.
- `sum`, `min`, `max` and `len` summarize a list of numbers; `list("abc")` and `list(range(5))` turn other things into lists.
- Lists can hold lists. Access a grid with `grid[row][col]` and visit every cell with two nested loops.

**Up next:** working with lists: methods like `insert`, `pop` and `remove`, sorting with `sort()` and `sorted()`, and the surprising way two names can share one list.
