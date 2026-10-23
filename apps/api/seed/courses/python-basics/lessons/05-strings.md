Most of the data in the world is text: names, addresses, emails, product codes, song titles, messages. Before a program can tidy up a customer's name, pull the year out of a date, or check whether an email contains an `@`, it needs to take text apart and put it back together.

In Python, text is a **string**: a sequence of characters, one after another, like beads on a thread. By the end of this page you'll be able to write any text (including quotes and line breaks), glue strings together, measure them, grab any single character, cut out any piece with slicing, and even reverse a string in a few keystrokes.

## Three ways to quote

You already know strings go in quotes. Single and double quotes behave exactly the same, so pick whichever one *isn't* inside your text:

```python run
band = 'Queen'
song = "Don't Stop Me Now"
review = 'She called it "the best song ever".'
print(band, "-", song)
print(review)
```

For text that spans several lines, like an address or a poem, use **triple quotes**, either `"""` or `'''`. Line breaks inside them are kept exactly as typed:

```python run
address = """Ana Silva
12 Harbour Street
Lisbon, Portugal"""
print(address)
```

## Special characters: escape sequences

Some characters are hard to type inside a string, such as a new line or a quote that matches the outer ones. For these, Python uses a **backslash** `\` followed by a letter. The backslash says "the next character is special". This is called an **escape sequence**:

| Escape | Means | Example | Prints |
|---|---|---|---|
| `\n` | new line | `"Line 1\nLine 2"` | two lines |
| `\t` | tab (a wide gap) | `"Name\tScore"` | `Name    Score` |
| `\"` | a double quote | `"Say \"cheese\""` | `Say "cheese"` |
| `\'` | a single quote | `'It\'s here'` | `It's here` |
| `\\` | a real backslash | `"C:\\Users"` | `C:\Users` |

```python run
print("Shopping list:\n- milk\n- eggs\n- bread")
print("Player\tScore")
print("Mei\t1200")
print("Ravi\t950")
```

Even though `\n` is two keystrokes, it's **one character** in the string. Python reads the pair as a single "new line" character.

```python predict id=predict-escaped-quote title="Quotes inside quotes"
print("The sign said \"Back in 5 minutes\"")
--- options
The sign said \"Back in 5 minutes\"
* The sign said "Back in 5 minutes"
"The sign said "Back in 5 minutes""
The sign said Back in 5 minutes
--- explain
`\"` is an escape sequence: it puts a real `"` character into the string without ending it. When printed, the backslashes disappear and the quotes show. The outer quotes are never printed; they only mark where the string begins and ends.
```

## Gluing and repeating: `+` and `*`

`+` joins strings end to end (programmers call this **concatenation**), and `*` repeats a string a number of times:

```python run
first = "Ada"
last = "Lovelace"
full_name = first + " " + last
print(full_name)

print("Ha" * 3)
print("-" * 30)
```

Notice that `+` doesn't add a space for you: you add `" "` yourself. And `"-" * 30` is a quick way to draw a line, handy for receipts and reports.

But `+` only joins **strings with strings**. Try to glue a number onto text and Python refuses:

```python run error
item_count = 3
print("Items in cart: " + item_count)
```

*"can only concatenate str (not "int") to str"*: Python won't guess whether you meant maths or text. The fix is to turn the number into text first with `str()`:

```python run
item_count = 3
label = "Items in cart: " + str(item_count)
print(label)
```

`str(3)` gives the string `"3"`, which `+` can happily join. (Remember that `print` with commas also works for displaying, but `str()` is what you need when you're *building* a string to store or reuse. You'll learn the most elegant way, f-strings, in the next lesson.)

```python debug id=unread-messages title="The notification crashes"
name = "Priya"
unread = 3

message = "Hi " + name + ", you have " + unread + " new messages"
print(message)
--- solution
name = "Priya"
unread = 3

message = "Hi " + name + ", you have " + str(unread) + " new messages"
print(message)
--- test
assert isinstance(message, str), "`message` should be a string."
assert message == "Hi " + name + ", you have " + str(unread) + " new messages", f"`message` should read `Hi Priya, you have 3 new messages`, but it is {message!r}. Check the spaces."
assert isinstance(unread, int) and unread == 3, "Keep `unread` as the number 3. Convert it to text only where you build the message."
--- hint
Run it and read the last line of the error. Which value isn't a string?
--- hint
`unread` is a number. Convert it to text right where it's being joined, with `str(...)`.
```

## How long is it? `len()`

`len()` counts the characters in a string. **Every** character counts, including spaces, punctuation and escape sequences like `\n`:

```python run
print(len("Lisbon"))
print(len("Hi there!"))
print(len(""))          # the empty string has no characters
password = "sunflower42"
print("Password length:", len(password))
```

```python predict id=predict-len-space title="Count the characters"
len("New York")
--- options
7
* 8
2
9
--- explain
`len` counts every character, and the space between the two words is a character too: 3 letters + 1 space + 4 letters = 8.
```

Time to put `+`, `*` and `len()` together:

```python exercise id=sale-banner title="Make a sale banner"
title = "SUMMER SALE"

# TODO: build two strings from `title`:
#   middle: "| " + the title + " |"
#   border: the "=" character repeated so it's exactly as long as `middle`
# Use + and *, and let len() do the counting for you.
middle = ...
border = ...

print(border)
print(middle)
print(border)
--- solution
title = "SUMMER SALE"

middle = "| " + title + " |"
border = "=" * len(middle)

print(border)
print(middle)
print(border)
--- test
assert middle is not ..., "Replace the `...` after `middle =` with a string built from `title`."
assert border is not ..., "Replace the `...` after `border =` with a repeated `=`."
assert isinstance(middle, str) and isinstance(border, str), "`middle` and `border` should both be strings."
assert middle == "| " + title + " |", f"`middle` should be the title with `| ` before it and ` |` after it, but it is {middle!r}. Check the spaces."
assert set(border) == {"="}, f"`border` should be made only of `=` characters, but it is {border!r}."
assert len(border) == len(middle), f"`border` has {len(border)} characters but `middle` has {len(middle)}. Make them the same length."
--- hint
Build `middle` with `+`, remembering to include the spaces: `"| "` and `" |"`.
--- hint
`"=" * 5` gives `"====="`. Multiply by the length of `middle`: `len(middle)` counts its characters for you.
```

## Indexing: one character at a time

Each character in a string has a numbered position called its **index**. Python starts counting from **0**, not 1. You read a character with square brackets: `word[index]`.

```text
 character:    P    y    t    h    o    n
 index:        0    1    2    3    4    5
 from the end: -6   -5   -4   -3   -2   -1
```

```python run
word = "Python"
print("first:", word[0])
print("second:", word[1])
print("last:", word[5])
print("also last:", word[-1])
print("second to last:", word[-2])
```

Negative indices count **from the end**: `-1` is the last character, `-2` the one before it, and so on. That's very handy when you don't know how long a string is: `name[-1]` is always the last character, whatever the name.

> **Under the hood:** why start at 0? The index is really an *offset*: "how many steps from the start". The first character is 0 steps from the start. Most programming languages count this way, and after a week it'll feel natural.

Ask for a position that doesn't exist and Python stops with an `IndexError`:

```python run error
city = "Rome"
print(city[4])
```

`"Rome"` has 4 characters, so its indices are `0` to `3`. The last valid index is always `len(text) - 1`, which is the source of many "off by one" bugs.

```python exercise id=initials title="Monogram initials"
first_name = "Grace"
last_name = "Hopper"

# TODO: using indexing on the two variables above, define:
#   initials:    the first letter of each name, each followed by a dot, e.g. "G.H."
#   last_letter: the final letter of last_name (use a negative index)
initials = ...
last_letter = ...

print("Initials:", initials)
print("Last name ends in:", last_letter)
--- solution
first_name = "Grace"
last_name = "Hopper"

initials = first_name[0] + "." + last_name[0] + "."
last_letter = last_name[-1]

print("Initials:", initials)
print("Last name ends in:", last_letter)
--- test
assert initials is not ..., "Replace the `...` after `initials =` with your code."
assert last_letter is not ..., "Replace the `...` after `last_letter =` with your code."
assert isinstance(initials, str), f"`initials` should be a string, but it is {initials!r}."
assert initials != first_name[1] + "." + last_name[1] + ".", "Those are the *second* letters. Indexing starts at 0."
assert initials == first_name[0] + "." + last_name[0] + ".", f"`initials` should be {first_name[0] + '.' + last_name[0] + '.'!r}, but it is {initials!r}."
assert last_letter == last_name[-1], f"`last_letter` should be the last character of {last_name!r}, but it is {last_letter!r}."
--- hint
The first character of any string is at index `0`, and the last is at index `-1`.
--- hint
Glue the pieces with `+`: the first letter of `first_name`, then `"."`, then the first letter of `last_name`, then `"."`.
```

## Slicing: cutting out a piece

Indexing gets one character. **Slicing** gets a whole chunk: `text[start:stop]` gives the characters from index `start` **up to but not including** `stop`.

The easiest way to picture it: imagine the indices sit on the **fences between characters**. A slice cuts at two fences and keeps what's between them.

```text
         P   y   t   h   o   n
       |   |   |   |   |   |   |
       0   1   2   3   4   5   6

 word[1:4]  cuts at fences 1 and 4  →  "yth"
 word[0:2]  cuts at fences 0 and 2  →  "Py"
```

```python run
word = "Python"
print(word[1:4])
print(word[0:2])
print(word[2:6])
print("length of word[1:4]:", len(word[1:4]))
```

A nice side effect of "stop is excluded": the length of `text[a:b]` is simply `b - a`. And you can **leave out** either end. A missing start means "from the beginning", a missing stop means "to the end":

```python run
filename = "holiday_photo.jpg"
print(filename[:7])     # first 7 characters
print(filename[8:])     # from index 8 to the end
print(filename[-3:])    # the last 3 characters
print(filename[:])      # the whole thing
```

`filename[-3:]` is a great pattern: "the last 3 characters", the file extension here, no matter how long the name is. Slices are also forgiving: unlike indexing, a slice that runs past the end just stops at the end, with no error.

```python predict id=predict-slice title="Where does the slice stop?"
team = "Barcelona"
print(team[3:7])
--- options
celon
* celo
rcel
rcelo
--- explain
Index 3 is `c` (B=0, a=1, r=2, c=3). The slice stops **before** index 7, so it takes indices 3, 4, 5 and 6: `c`, `e`, `l`, `o`. That's `7 - 3 = 4` characters.
```

```python exercise id=boarding-pass title="Read a boarding pass code"
# Format: 2-letter airline, 4-digit flight number,
# 3-letter origin airport, 3-letter destination airport.
code = "BA0492LHRJFK"

# TODO: slice `code` into its four parts (each one a string):
airline = ...        # "BA"
flight_number = ...  # "0492"
origin = ...         # "LHR"
destination = ...    # "JFK"  (try a negative slice!)

print(airline, flight_number, "from", origin, "to", destination)
--- solution
code = "BA0492LHRJFK"

airline = code[:2]
flight_number = code[2:6]
origin = code[6:9]
destination = code[-3:]

print(airline, flight_number, "from", origin, "to", destination)
--- test
for _name, _val in [("airline", airline), ("flight_number", flight_number), ("origin", origin), ("destination", destination)]:
    assert _val is not ..., f"Replace the `...` after `{_name} =` with a slice of `code`."
    assert isinstance(_val, str), f"`{_name}` should be a string sliced from `code`, but it is {_val!r}."
assert airline == code[:2], f"`airline` should be the first 2 characters, but it is {airline!r}."
assert flight_number == code[2:6], f"`flight_number` should be the 4 digits after the airline, but it is {flight_number!r}. Remember the stop index is not included."
assert origin == code[6:9], f"`origin` should be the 3 letters after the flight number, but it is {origin!r}."
assert destination == code[-3:], f"`destination` should be the last 3 characters, but it is {destination!r}."
--- hint
Each part starts where the previous one stopped. The airline is `code[0:2]`, so the flight number starts at index 2.
--- hint
A slice of 4 characters starting at index 2 is `code[2:6]`. For the last 3 characters of any string, use `code[-3:]`.
```

```python debug id=month-cut-short title="The month is cut short"
order_date = "2026-10-22"

year = order_date[0:4]
month = order_date[5:6]
day = order_date[8:10]

print("Year:", year, "| Month:", month, "| Day:", day)
--- solution
order_date = "2026-10-22"

year = order_date[0:4]
month = order_date[5:7]
day = order_date[8:10]

print("Year:", year, "| Month:", month, "| Day:", day)
--- test
assert year == "2026" and day == "22", f"`year` and `day` were already right; keep them as '2026' and '22' (they are {year!r} and {day!r})."
assert month != "1", "`month` is still just '1'. The slice stops one character too early."
assert month == order_date[5:7], f"`month` should be the two digits of the month, but it is {month!r}."
--- hint
Run it: the month shows as `1`, but October is `10`. How many characters does `[5:6]` take?
--- hint
The stop index is **excluded**. To take two characters starting at index 5, the stop must be 5 + 2.
```

## Steps and reversing: `[start:stop:step]`

A slice can take a third number, the **step**: how far to jump each time. A step of `2` takes every second character. A **negative** step walks backwards, which gives you the famous one-liner for reversing a string:

```python run
alphabet = "abcdefghij"
print(alphabet[::2])     # every 2nd character
print(alphabet[1::3])    # start at index 1, then every 3rd
print(alphabet[::-1])    # walk backwards: reversed!
print("racecar"[::-1], "stressed"[::-1])
```

`[::-1]` reads as "from the start, to the end, stepping by -1", which means the whole string, back to front.

```python exercise id=spy-messages title="Decode the spy messages"
# Two secret messages were intercepted.
backwards = "!thginot 9 ta kcod eht ta teeM"
padded = "B*r*i*n*g* *t*h*e* *m*a*p"   # the real letters are every 2nd character

# TODO: decode each message with a slice:
#   message_1: `backwards` reversed
#   message_2: every 2nd character of `padded`, starting with the first
message_1 = ...
message_2 = ...

print(message_1)
print(message_2)
--- solution
backwards = "!thginot 9 ta kcod eht ta teeM"
padded = "B*r*i*n*g* *t*h*e* *m*a*p"

message_1 = backwards[::-1]
message_2 = padded[::2]

print(message_1)
print(message_2)
--- test
assert message_1 is not ..., "Replace the `...` after `message_1 =` with a slice of `backwards`."
assert message_2 is not ..., "Replace the `...` after `message_2 =` with a slice of `padded`."
assert message_1 == backwards[::-1], f"`message_1` should be `backwards` reversed, but it is {message_1!r}."
assert message_2 != padded[1::2], "You got all the `*` characters. Start from the very first character instead."
assert message_2 == padded[::2], f"`message_2` should be every 2nd character of `padded`, but it is {message_2!r}."
--- hint
Both messages use the three-number slice form `[start:stop:step]`, leaving start and stop empty.
--- hint
A step of `-1` walks backwards through the string; a step of `2` skips every other character.
```

## Strings can't be changed (they're immutable)

Here's a rule that surprises many beginners: once a string is created, **you can't change its characters**. Strings are **immutable**. Try to fix a typo by assigning to an index and Python refuses:

```python run error
city = "lisbon"
city[0] = "L"
```

*"'str' object does not support item assignment"* means exactly that. Instead, you **build a new string** from the pieces you want and move the name onto it:

```python run
city = "lisbon"
city = "L" + city[1:]
city
```

The original `"lisbon"` was never modified; `city` now simply points to a brand-new string, `"Lisbon"`. Every string operation you've seen (`+`, `*`, slicing) works this way: it gives you a **new** string and leaves the old one alone. That turns out to be a big advantage: a string you hand to another part of your program can never be changed behind your back.

> **In the wild:** immutability is why strings can be used as keys in Python dictionaries (lesson 16), which power everything from JSON data to web frameworks like Django. Python can trust that a key's text will never change.

## Is it in there? The `in` operator

`in` checks whether one string appears **inside** another. The answer is `True` or `False`, the two Boolean values you'll study properly in lesson 7:

```python run
email = "mei.chen@example.com"
print("@" in email)
print("gmail" in email)
print("Chen" in email)
print("chen" in email)
```

Notice the last two: `"Chen"` isn't found but `"chen"` is. Comparisons between strings are **case-sensitive**: `C` and `c` are different characters. (Lesson 6 shows how to compare text without worrying about case.)

## Recap

- Strings are text in `'single'`, `"double"` or `"""triple"""` quotes. Escape sequences like `\n`, `\t` and `\"` add special characters.
- `+` joins strings, `*` repeats them, and `len()` counts every character, spaces included. Use `str(number)` before joining a number with `+`.
- Indexing starts at **0**: `text[0]` is the first character, `text[-1]` the last. Going past the end raises `IndexError`.
- Slicing `text[start:stop:step]` includes `start` and **excludes** `stop`. Leave out ends to go from the start or to the end; `[::-1]` reverses.
- Strings are **immutable**: build a new string instead of changing one in place.
- `in` checks whether text appears inside a string, and it's case-sensitive.

**Up next:** string methods and f-strings, the professional toolkit for cleaning, searching and formatting text.
