Real-world text is messy. People type their email as `"  Maya.Chen@Example.COM "`, product codes arrive in lowercase, prices come in as `"$1,299.99"`, and a whole spreadsheet row can show up as one long line of commas. Before a program can *use* text, it has to clean it, split it apart, search it and, at the end, present it nicely to a human.

Python strings come with a built-in toolbox for exactly this. In this lesson you'll learn the dozen string methods professionals reach for every day, and **f-strings**, the modern way to drop values into text with perfect formatting. By the end you'll be able to tidy messy input, pull pieces out of a line of data, and print a receipt with neatly lined-up columns.

## Methods: actions a value knows how to do

In lesson 05 you used *functions* like `len(text)`, where the value goes inside the parentheses. A **method** is a function that belongs to a value. You call it with a dot: `value.method()`.

Think of every string as carrying its own little toolbox. The dot means "reach into this string's toolbox and use the tool called…".

```python run
city = "lisbon"

print(city.upper())       # every letter uppercase
print(city.title())       # first letter of each word uppercase
print("CAFÉ MENU".lower())
print("new york city".title())
```

The parentheses matter: they're what actually *runs* the method. You'll see what happens without them in a moment.

| Method | What it does | `"hello World".method()` |
|---|---|---|
| `.upper()` | all uppercase | `'HELLO WORLD'` |
| `.lower()` | all lowercase | `'hello world'` |
| `.title()` | Each Word Capitalized | `'Hello World'` |
| `.capitalize()` | only the very first letter | `'Hello world'` |

> **Coming from Excel:** these are Python's versions of `UPPER()`, `LOWER()` and `PROPER()`. Later in this lesson you'll meet the equivalents of `TRIM()` (`.strip()`) and `SUBSTITUTE()` (`.replace()`).

## Methods return a *new* string

Remember from lesson 05 that strings are **immutable**: once created, a string can never change. So how can `.upper()` work? It doesn't change the original. It builds a brand-new string and hands it back to you. If you don't catch it with a variable, it's gone.

```python run
greeting = "hello"

greeting.upper()                      # builds "HELLO"... and throws it away
print("after calling upper():", greeting)

loud = greeting.upper()               # catch the new string with a name
print("saved result:", loud)

greeting = greeting.upper()           # or replace the old label entirely
print("reassigned:", greeting)
```

The last line is the pattern you'll use most: `name = name.upper()` means "make an uppercase copy, then move the label `name` onto it".

> **Pitfall:** forgetting the parentheses doesn't raise an error. `print(greeting.upper)` prints something like `<built-in method upper of str object at 0x...>`. That's Python describing the *tool itself* instead of using it. If you ever see `built-in method` in your output, look for missing `()`.

```python predict id=predict-forgot-to-save title="Did the name change?"
name = "ada lovelace"
name.title()
print(name)
--- options
* ada lovelace
Ada Lovelace
ADA LOVELACE
None
--- explain
`name.title()` built the new string `"Ada Lovelace"`, but nothing saved it, so it vanished. `name` still points at the original lowercase text. To keep the result, write `name = name.title()`.
```

## Cleaning messy text: `strip` and `replace`

`.strip()` removes whitespace (spaces, tabs, newlines) from **both ends** of a string, never from the middle. It's the first thing you do to text that a human typed or a file delivered. The square brackets below are just there so you can *see* the invisible spaces.

```python run
raw_email = "   Maya.Chen@Example.COM \n"
clean_email = raw_email.strip().lower()

print("[" + raw_email + "]")
print("[" + clean_email + "]")
print("length before:", len(raw_email), "after:", len(clean_email))
```

Notice `raw_email.strip().lower()`. That's **chaining**: `.strip()` returns a new string, and `.lower()` is called on *that* string. Read it left to right like an assembly line: strip, then lowercase.

Two relatives: `.lstrip()` cleans only the left end, `.rstrip()` only the right. You can also tell `strip` *which* characters to remove: `"$$42$".strip("$")` gives `'42'`.

`.replace(old, new)` swaps every occurrence of one piece of text for another. Replacing with `""` deletes.

```python run
price_text = "$1,299.99"
plain = price_text.replace("$", "").replace(",", "")
print("plain:", plain)

phone = "555-867-5309"
print(phone.replace("-", " "))
print(phone.replace("-", "", 1))      # optional 3rd argument: only the first 1
```

```python exercise id=tidy-book-title title="Tidy up a book title"
raw_title = "   the HOBBIT   "

# TODO: make `book_title` a cleaned-up version of raw_title:
# no spaces at either end, and Each Word Capitalized ("The Hobbit").
# Build it from raw_title using string methods (don't just type the answer).
book_title = ...

print("[" + str(book_title) + "]")
--- solution
raw_title = "   the HOBBIT   "

book_title = raw_title.strip().title()

print("[" + str(book_title) + "]")
--- test
assert book_title is not ..., "Replace the `...` after `book_title =` with raw_title and some string methods."
assert isinstance(book_title, str), f"`book_title` should be a string, but it is {type(book_title).__name__}."
assert book_title == book_title.strip(), f"`book_title` still has spaces at the ends: {book_title!r}. Which method trims both ends?"
assert book_title == raw_title.strip().title(), f"`book_title` is {book_title!r}. It should have each word capitalized, like a book cover."
--- hint
You need two methods: one that removes spaces from the ends, and one that capitalizes each word.
--- hint
Methods can be chained: `raw_title.method_one().method_two()`. Each one works on the result of the previous one.
--- hint
`.strip()` trims the ends; `.title()` capitalizes each word.
```

## Splitting text into pieces, and joining them back

`.split(separator)` cuts a string wherever the separator appears and gives you back the pieces in a **list**: values in square brackets, separated by commas. You'll study lists properly in lesson 13. For now, all you need is that a list holds pieces in order and that you index it exactly like a string: `parts[0]` is the first piece.

```python run
row = "Lisbon,Portugal,24"
parts = row.split(",")

print("parts:", parts)
print("city:", parts[0])
print("country:", parts[1])
print("last piece:", parts[-1])
```

Call `.split()` with **no argument** and it splits on any run of whitespace and ignores spaces at the ends. That's the go-to way to break a sentence into words:

```python run
messy = "  the   quick brown    fox  "
print("split(' '):", messy.split(" "))   # every single space is a cut: empty pieces!
print("split():   ", messy.split())      # smart: words only
print("word count:", len(messy.split()))
```

`.join()` is the reverse: it glues a list of strings together. The surprise for beginners is *which way round* it goes. **The glue comes first**, then `.join(...)` with the pieces:

```python run
tags = ["python", "beginner", "tutorial"]

print(", ".join(tags))
print(" | ".join(tags))
print("-".join("2026 10 22".split()))    # split on spaces, rejoin with dashes
```

> **Tip:** say it out loud as *"glue dot join pieces"*. `", ".join(tags)` reads as "join the tags with a comma and a space between each".

`join` only glues **strings**. Hand it numbers and it stops with an error. Run this and read the last line of the message:

```python run error
scores = [98, 87, 92]
print(", ".join(scores))
```

`TypeError: sequence item 0: expected str instance, int found` means "item number 0 of the list should have been a string, but it's an int". You'll learn to convert a whole list in one line in the comprehensions lesson; for now, keep the pieces as text.

> **In the wild:** turning a title into a URL like `my-first-python-program` is called making a **slug**. Web frameworks such as Django ship a `slugify()` helper that does exactly the lowercase-split-join dance you're about to write.

```python exercise id=make-a-slug title="Turn a blog title into a URL slug"
title = "  My First   Python Program "

# TODO: make `slug` the URL-friendly version of title:
# all lowercase, words joined by single dashes, no spaces anywhere.
# For this title the result should be: my-first-python-program
slug = ...

print(slug)
--- solution
title = "  My First   Python Program "

slug = "-".join(title.lower().split())

print(slug)
--- test
assert slug is not ..., "Replace the `...` after `slug =` with an expression built from `title`."
assert isinstance(slug, str), f"`slug` should be a string, but it is {type(slug).__name__}."
assert " " not in slug, f"`slug` still contains spaces: {slug!r}. Every gap between words should become one dash."
assert slug == slug.lower(), f"`slug` should be all lowercase, but it is {slug!r}."
assert "--" not in slug and not slug.startswith("-") and not slug.endswith("-"), f"`slug` is {slug!r}: there are extra dashes. Did the runs of spaces each become dashes? `split()` with no argument ignores extra spaces."
assert slug == "-".join(title.lower().split()), f"`slug` should be the words of the title joined by dashes, but it is {slug!r}."
--- hint
Break the job into steps: lowercase the title, break it into words, glue the words back together with `-`.
--- hint
`.split()` with no argument gives you just the words, ignoring every extra space. `.replace(" ", "-")` would turn each of the three spaces in a row into its own dash.
--- hint
The glue goes first: `"-".join(some_list_of_words)`.
```

## Searching inside text

Some methods don't build new text; they *answer a question* about the text. `.startswith()` and `.endswith()` answer yes or no, which Python writes as `True` or `False`. (You met these two values with `in` last lesson; the next lesson is all about them.)

```python run
filename = "holiday_photo.JPG"
url = "https://example.com/menu"

print("is a photo?   ", filename.lower().endswith(".jpg"))
print("secure link?  ", url.startswith("https://"))
print("is a PDF?     ", filename.endswith(".pdf"))
```

`.find(text)` tells you **where** something is: the index of its first appearance, or `-1` if it isn't there at all. `.count(text)` tells you **how many times** it appears (without overlaps).

```python run
review = "great food, great service, slow delivery"

print("find 'great':   ", review.find("great"))
print("find 'service': ", review.find("service"))
print("find 'pizza':   ", review.find("pizza"))   # not there: -1
print("count 'great':  ", review.count("great"))
```

> **Pitfall:** `-1` is a perfectly valid index (it means "the last character"), so a `.find()` that failed can sneak through as if it worked. `text[text.find("@"):]` on a string with no `@` silently gives you just the last character. If you only need yes/no, use `in` instead.

`.isdigit()` answers "is every character a digit 0–9?" It's how you'll check user input in lesson 08 before turning it into a number. Watch the edge cases:

```python run
print("'2026':", "2026".isdigit())
print("'20.5':", "20.5".isdigit())   # the dot isn't a digit
print("'-3':  ", "-3".isdigit())     # neither is the minus sign
print("' 42': ", " 42".isdigit())    # nor a space: strip first!
print("'':    ", "".isdigit())       # empty text has no digits at all
```

```python predict id=predict-find-count title="Find and count"
print("banana".count("ana"), "banana".find("na"))
--- options
2 2
* 1 2
1 3
2 3
--- explain
`count` doesn't let matches overlap: once it finds `ana` at positions 1–3, it continues searching from position 4 (`na`), so only **1** match. `find("na")` returns the index of the first `n`, and counting from 0 (`b`=0, `a`=1, `n`=2) that's **2**.
```

```python exercise id=email-parts title="Split an email address in two"
email = "maya.chen@example.com"

# TODO: define two strings built from `email`:
#   user   -> everything before the @   ("maya.chen")
#   domain -> everything after the @    ("example.com")
# Use string methods and/or slicing. The @ itself belongs to neither.
user = ...
domain = ...

print("user:", user)
print("domain:", domain)
--- solution
email = "maya.chen@example.com"

at = email.find("@")
user = email[:at]
domain = email[at + 1:]

print("user:", user)
print("domain:", domain)
--- test
assert user is not ... and domain is not ..., "Replace both `...` placeholders with expressions built from `email`."
assert isinstance(user, str) and isinstance(domain, str), "`user` and `domain` should both be strings."
expected_user, expected_domain = email.split("@")
assert "@" not in user and "@" not in domain, f"The @ should not be in either part, but you have user={user!r}, domain={domain!r}. Check your slice boundaries."
assert user == expected_user, f"`user` should be the part before the @, but it is {user!r}."
assert domain == expected_domain, f"`domain` should be the part after the @, but it is {domain!r}."
--- hint
Two good routes: find the position of the `@` and slice around it, or split the email at the `@`.
--- hint
`email.find("@")` gives the index of the `@`. Slicing `[:i]` stops *before* index `i`; to skip the `@` on the other side, start one past it.
--- hint
Or: `email.split("@")` gives a list of two pieces. Index `[0]` is the user, `[1]` is the domain.
```

## Debug challenge: the announcement that won't shout

```python debug id=quiet-announcement title="The announcement stays lowercase"
# Clean up a store announcement: trim the spaces and make it UPPERCASE.
announcement = "  flash sale ends tonight  "

announcement.strip()
announcement.upper()

print("[" + announcement + "]")
--- solution
announcement = "  flash sale ends tonight  "

announcement = announcement.strip()
announcement = announcement.upper()

print("[" + announcement + "]")
--- test
assert announcement != "  flash sale ends tonight  ", "`announcement` is completely unchanged. The methods ran, but where did their results go?"
assert announcement == announcement.strip(), f"`announcement` still has spaces at the ends: {announcement!r}."
assert announcement == announcement.upper(), f"`announcement` should be all uppercase, but it is {announcement!r}."
assert announcement == "FLASH SALE ENDS TONIGHT", f"`announcement` should be 'FLASH SALE ENDS TONIGHT', but it is {announcement!r}."
assert "[FLASH SALE ENDS TONIGHT]" in _stdout, "Keep the print line so the cleaned announcement is shown."
--- hint
Run it with **Debug** and watch `announcement` in the Variables panel. Does it ever change?
--- hint
Strings are immutable: `.strip()` and `.upper()` *return* new strings. Something has to catch each result.
```

## f-strings: dropping values into text

Back in lesson 05 you glued text with `+`, which forced you to wrap every number in `str()`. There's a much nicer way. Put an `f` right before the opening quote, and anything inside `{curly braces}` is evaluated as Python and slotted into the text:

```python run
item = "coffee"
price = 3.5
qty = 2

print("old way: " + str(qty) + " x " + item + " = " + str(price * qty))
print(f"new way: {qty} x {item} = {price * qty}")
print(f"Shout it: {item.upper()}! Name has {len(item)} letters.")
```

Any expression works in the braces: arithmetic, method calls, `len()`. The f stands for *formatted*, and the f-string is the one everyone uses in modern Python.

> **Pitfall:** forget the `f` and the braces are printed literally: `print("{qty} cups")` shows `{qty} cups`. If you see curly braces in your output, check for a missing `f`.

## Format specs: control how values look

Add a colon inside the braces, and after it a tiny **format spec** describing how the value should look. The most useful ones:

| Spec | Meaning | Example | Result |
|---|---|---|---|
| `:.2f` | exactly 2 decimal places | `f"{3.14159:.2f}"` | `'3.14'` |
| `:,` | thousands separators | `f"{1234567:,}"` | `'1,234,567'` |
| `:,.2f` | both | `f"{1234.5:,.2f}"` | `'1,234.50'` |
| `:>8` | right-align in 8 characters | `f"{'hi':>8}"` | `'      hi'` |
| `:<8` | left-align in 8 characters | `f"{'hi':<8}"` | `'hi      '` |
| `:^8` | center in 8 characters | `f"{'hi':^8}"` | `'   hi   '` |
| `:>8.2f` | right-align *and* 2 decimals | `f"{4.5:>8.2f}"` | `'    4.50'` |

The order inside the spec is always **alignment and width first, then comma, then precision**.

```python run
salary = 1234567.891
print(f"raw:       {salary}")
print(f"2 places:  {salary:.2f}")
print(f"with ,:    {salary:,.2f}")
print(f"[{'left':<10}] [{'right':>10}] [{'mid':^10}]")
```

Rounding with `:.2f` only changes how the number is **displayed**; the variable keeps its full value. That's exactly what you want for money (and for the `0.1 + 0.2` fuzz you met in lesson 04).

```python predict id=predict-two-decimals title="Formatting money"
price = 4.5
print(f"Total: {price * 2:.2f}")
--- options
Total: 9.0
* Total: 9.00
Total: 9
Total: {price * 2:.2f}
--- explain
`price * 2` is the float `9.0`, and `:.2f` always shows exactly two decimals, so you get `9.00`. Without the spec you'd see `9.0`. And because the string starts with `f`, the braces are evaluated, not printed.
```

### The `=` debugging shortcut

Put an `=` at the end of the expression and the f-string prints the code *and* its value. It's the fastest way to peek at variables while you're figuring out a bug:

```python run
subtotal = 18.5
tax_rate = 0.08
print(f"{subtotal=}")
print(f"{tax_rate=}")
print(f"{subtotal * tax_rate=:.2f}")
```

> **In the wild:** professional code is full of f-strings: log messages (`f"Loaded {count:,} rows in {seconds:.1f}s"`), file names (`f"report_{year}.csv"`), and the `{x=}` trick is a favorite during debugging sessions.

## Building a receipt with aligned columns

Width specs are what turn a jumble of prints into a tidy table. Give every column a fixed width: text left-aligned, numbers right-aligned so the decimal points line up.

```python run
item1, price1 = "Flat white", 3.8
item2, price2 = "Croissant", 2.95
item3, price3 = "Orange juice", 4.5
total = price1 + price2 + price3

print(f"{'ITEM':<14}{'PRICE':>8}")
print("-" * 22)
print(f"{item1:<14}{price1:>8.2f}")
print(f"{item2:<14}{price2:>8.2f}")
print(f"{item3:<14}{price3:>8.2f}")
print("-" * 22)
print(f"{'TOTAL':<14}{total:>8.2f}")
```

Every line is exactly 22 characters wide (14 + 8), which is why the columns line up. Once you learn loops in Section 3, you'll print a whole shopping cart this way with just two lines of code.

```python exercise id=receipt-line title="Format a receipt line"
item = "Headphones"
qty = 3
unit_price = 1249.5

# TODO: build `line`, one row of a receipt, with an f-string:
#   - the item name left-aligned in a column 12 characters wide
#   - then the line total (qty * unit_price) right-aligned in 10 characters,
#     with thousands commas and exactly 2 decimals
# For these values, line should be:  'Headphones    3,748.50'
line = ...

print("[" + str(line) + "]")
--- solution
item = "Headphones"
qty = 3
unit_price = 1249.5

line = f"{item:<12}{qty * unit_price:>10,.2f}"

print("[" + str(line) + "]")
--- test
assert line is not ..., "Replace the `...` after `line =` with an f-string, like f\"{item:<12}...\"."
assert isinstance(line, str), f"`line` should be a string, but it is {type(line).__name__}."
total = qty * unit_price
expected = f"{item:<12}{total:>10,.2f}"
assert line.startswith(item), f"`line` should start with the item name, but it is {line!r}."
assert f"{total:,.2f}" in line, f"`line` should contain the total {total:,.2f} (with a comma and 2 decimals), but it is {line!r}. Did you multiply qty by unit_price?"
assert len(line) == 22, f"`line` should be exactly 22 characters wide (12 + 10), but it is {len(line)}: {line!r}. Check your two widths."
assert line == expected, f"`line` is {line!r} but should be {expected!r}. Check the alignment symbols: < for left, > for right."
--- hint
You need two pairs of braces next to each other: one for the item, one for the total. Each gets its own format spec after a colon.
--- hint
Left-align in 12 is `:<12`. For the number, combine right-align in 10, a comma, and 2 decimals, in that order.
--- hint
The second spec looks like `:>10,.2f`, and the expression in front of it can be the multiplication itself.
```

## Debug challenge: hashtags gone wrong

```python debug id=letter-hashtags title="The hashtags come out one letter at a time"
# Turn a comma-separated list of topics into hashtags for a social post.
# Expected result: #python #coding #beginners
topics = "python, coding, beginners"

post = "#" + " #".join(topics)

print(post)
--- solution
topics = "python, coding, beginners"

words = topics.split(", ")
post = "#" + " #".join(words)

print(post)
--- test
assert isinstance(post, str), "`post` should be a string."
assert "#p #y" not in post, "There's a # between every letter. `join` walks through whatever you give it piece by piece. What are the pieces of a plain string?"
assert "," not in post, f"`post` still contains commas: {post!r}. The commas should disappear when you break the topics apart."
assert post == "#python #coding #beginners", f"`post` should be '#python #coding #beginners', but it is {post!r}. Check the separator you split on: it includes a space."
assert "#python #coding #beginners" in _stdout, "Print the post so you can see it."
--- hint
Run it. Every letter got its own `#`. When you give `join` a string, the "pieces" are its individual characters.
--- hint
`join` needs a list of words. Which method turns `"python, coding, beginners"` into a list of words? Watch out for the space after each comma.
```

## Recap

- A **method** is an action a value knows: `text.upper()`, `text.strip()`. Don't forget the `()`.
- String methods **return new strings**; the original never changes. Save the result: `name = name.strip()`.
- Clean with `.strip()`, `.lower()`, `.replace()`; chain them left to right. Search with `.startswith()`, `.endswith()`, `.find()` (`-1` = not found), `.count()`, `.isdigit()`.
- `.split()` breaks text into a list of pieces; `"glue".join(pieces)` puts them back together.
- **f-strings** (`f"{expr}"`) drop any expression into text; format specs like `:.2f`, `:,` and `:<10` / `:>10` / `:^10` control the look, and `{x=}` is a built-in debugging peek.

**Up next:** `True` and `False`: comparisons, `and` / `or` / `not`, and how Python decides what counts as "true".
