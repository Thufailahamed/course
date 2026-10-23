Every decision a program makes comes down to a yes-or-no question. Is the password long enough? Is the cart over the free-shipping threshold? Is the user old enough to sign up? Is it the weekend? Python answers these questions with just two values: `True` and `False`.

This lesson is about asking those questions precisely: comparing numbers and text, combining conditions with `and`, `or` and `not`, and knowing which values Python treats as "true". It's the foundation for the next lesson, where your programs start making real decisions with `if`. Get these small expressions right, and `if` statements become easy.

## `True` and `False`

A **boolean** (type `bool`, named after the mathematician George Boole) is the simplest kind of value there is: it's either `True` or `False`. Nothing else.

```python run
is_raining = False
has_umbrella = True

print("Raining?", is_raining)
print("Umbrella?", has_umbrella)
type(has_umbrella)
```

Good boolean names read like a yes/no question: `is_raining`, `has_umbrella`, `can_vote`, `is_valid`. When you read `if can_vote` in the next lesson, it'll sound like English.

Both words are **capitalized**. Python is case-sensitive, so lowercase `true` isn't a boolean; it's just a name Python has never heard of:

```python run error
game_over = true
```

`NameError: name 'true' is not defined`. Python thought `true` was a variable you forgot to create. If you've used JavaScript or another language with lowercase `true`, this one will catch you a few times.

## Comparison operators: asking questions

You rarely type `True` or `False` directly. Most booleans come from **comparisons**: expressions that ask a question and evaluate to the answer.

| Operator | Question | Example | Result |
|---|---|---|---|
| `==` | equal to? | `5 == 5` | `True` |
| `!=` | not equal to? | `5 != 5` | `False` |
| `<` | less than? | `3 < 8` | `True` |
| `>` | greater than? | `3 > 8` | `False` |
| `<=` | less than or equal? | `8 <= 8` | `True` |
| `>=` | greater than or equal? | `7 >= 8` | `False` |

```python run
age = 17
voting_age = 18

print("equal?        ", age == voting_age)
print("not equal?    ", age != voting_age)
print("old enough?   ", age >= voting_age)

can_vote = age >= voting_age     # save the answer in a variable
print("can_vote:", can_vote)
```

Look closely at the last line: `can_vote = age >= voting_age`. Python evaluates the comparison on the right first, gets `False`, and then the `=` puts the label `can_vote` on that answer.

> **Pitfall:** `=` and `==` look alike but mean completely different things. A single `=` is a **command**: "put this label on this value". A double `==` is a **question**: "are these two equal?" Python won't let you write `if age = 18` (that's a SyntaxError), but mixing them up in your head is the source of countless beginner bugs.

Arithmetic happens **before** comparison, so you can compare calculations directly without parentheses:

```python run
cart_total = 32.0 + 14.5
print("free shipping?", cart_total >= 50)

print("even number?  ", 1234 % 2 == 0)       # remainder 0 means even

# Floats are fuzzy (lesson 04), so == can surprise you:
print("0.1 + 0.2 == 0.3? ", 0.1 + 0.2 == 0.3)
print("rounded first?    ", round(0.1 + 0.2, 2) == 0.3)
```

> **Tip:** never compare float results with `==` directly. Round both sides first, or check that the difference is tiny: `abs(a - b) < 0.0001`.

## Chained comparisons

Is the temperature between 18 and 24 degrees? In math you'd write $18 \le t \le 24$, and Python lets you write exactly that:

```python run
temperature = 21

comfortable = 18 <= temperature <= 24
print("comfortable?", comfortable)

print("valid percentage?", 0 <= 105 <= 100)
print("valid month?     ", 1 <= 12 <= 12)
```

`18 <= temperature <= 24` means "`18 <= temperature` **and** `temperature <= 24`". Most other languages can't do this; in Python it's the normal, readable way to check a range.

```python exercise id=shipping-and-comfort title="Shipping and comfort checks"
cart_total = 47.5
free_shipping_minimum = 50
temperature = 26

# TODO: define two booleans using comparisons (don't type True/False directly):
#   free_shipping -> True if cart_total is at least free_shipping_minimum
#   comfortable   -> True if temperature is between 18 and 24, inclusive
free_shipping = ...
comfortable = ...

print("free shipping:", free_shipping)
print("comfortable:", comfortable)
--- solution
cart_total = 47.5
free_shipping_minimum = 50
temperature = 26

free_shipping = cart_total >= free_shipping_minimum
comfortable = 18 <= temperature <= 24

print("free shipping:", free_shipping)
print("comfortable:", comfortable)
--- test
assert free_shipping is not ... and comfortable is not ..., "Replace both `...` placeholders with comparisons."
assert isinstance(free_shipping, bool), f"`free_shipping` should be True or False, but it is {free_shipping!r}. Use a comparison like `a >= b`."
assert isinstance(comfortable, bool), f"`comfortable` should be True or False, but it is {comfortable!r}."
assert free_shipping == (cart_total >= free_shipping_minimum), f"`free_shipping` is {free_shipping}, but a cart of {cart_total} against a minimum of {free_shipping_minimum} should give {cart_total >= free_shipping_minimum}. 'At least' means >=."
assert comfortable == (18 <= temperature <= 24), f"`comfortable` is {comfortable}, but {temperature} degrees is {'inside' if 18 <= temperature <= 24 else 'outside'} the 18 to 24 range."
--- hint
"At least 50" includes 50 itself. Which operator means "greater than or equal"?
--- hint
For the range, Python lets you chain: `low <= value <= high`.
```

## Comparing strings

`==` works on text too, and it's **exact**: every character must match, including case and spaces.

```python run
print("'yes' == 'yes':", "yes" == "yes")
print("'Yes' == 'yes':", "Yes" == "yes")             # case matters
print("'yes ' == 'yes':", "yes " == "yes")           # so do spaces

answer = "  YES "
print("cleaned first:  ", answer.strip().lower() == "yes")
```

That last line is the professional habit: **normalize text before comparing it**. You'll do this constantly with anything a human typed.

`<` and `>` compare strings **alphabetically**, character by character, like words in a dictionary. But there's a twist: every uppercase letter comes before every lowercase letter.

```python run
print("apple < banana:  ", "apple" < "banana")
print("cat < car:       ", "cat" < "car")        # 't' comes after 'r'
print("Zebra < apple:   ", "Zebra" < "apple")    # uppercase sorts first!
print("'10' < '9':      ", "10" < "9")           # text, not numbers
```

> **Under the hood:** every character has a number (its *code point*). `ord("A")` is 65, `ord("Z")` is 90, and `ord("a")` is 97. Strings are compared by these numbers, which is why `"Zebra" < "apple"`. And `"10" < "9"` is `True` because the first characters `"1"` and `"9"` are compared, and 1 comes first. Numbers stored as text sort wrongly. Remember that one.

A number and a string are **never** equal, even if they look alike: `18 == "18"` is simply `False`. And ordering them is an error: `18 < "18"` raises `TypeError: '<' not supported between instances of 'int' and 'str'`.

```python predict id=predict-string-order title="Which word comes first?"
print("apple" < "Banana")
--- options
True
* False
TypeError
apple
--- explain
Comparison goes character by character using code points, and **all uppercase letters come before all lowercase ones**. `"a"` (97) is greater than `"B"` (66), so `"apple" < "Banana"` is `False`, even though a dictionary would put apple first. To compare like a dictionary, lowercase both sides: `"apple".lower() < "Banana".lower()`.
```

```python debug id=pin-rejected title="The correct PIN is rejected"
# A door keypad: the user types digits, which arrive as TEXT.
correct_pin = 4071
attempt_1 = "4017"     # typed by the user
attempt_2 = "4071"     # typed by the user

first_ok = attempt_1 == correct_pin
second_ok = attempt_2 == correct_pin

print("attempt 1 accepted:", first_ok)
print("attempt 2 accepted:", second_ok)
--- solution
correct_pin = "4071"
attempt_1 = "4017"
attempt_2 = "4071"

first_ok = attempt_1 == correct_pin
second_ok = attempt_2 == correct_pin

print("attempt 1 accepted:", first_ok)
print("attempt 2 accepted:", second_ok)
--- test
assert isinstance(first_ok, bool) and isinstance(second_ok, bool), "`first_ok` and `second_ok` should both be True or False."
assert second_ok is True, "Attempt 2 typed exactly the right digits but is still rejected. What *type* is `attempt_2`, and what type is `correct_pin`?"
assert first_ok is False, "Attempt 1 has the digits in the wrong order and must be rejected."
assert attempt_1 == "4017" and attempt_2 == "4071", "Leave the user's attempts as they were typed (text). Fix the comparison side instead."
--- hint
Run it. Both attempts are rejected, even the right one. Use `type()` on `attempt_2` and on `correct_pin`. Are they the same kind of value?
--- hint
A number and a string are never `==`, even if they look the same. Make both sides the same type: a PIN is really a code, not a quantity, so storing it as text makes sense. (`str(correct_pin)` works too.)
```

## Combining conditions: `and`, `or`, `not`

Real questions often have several parts. "You can board if you have a ticket **and** an ID." "You get in free if you're a child **or** a senior." Python uses the plain English words:

- `a and b` is `True` only when **both** are `True`.
- `a or b` is `True` when **at least one** is `True`.
- `not a` flips it: `not True` is `False`.

| `a` | `b` | `a and b` | `a or b` | `not a` |
|---|---|---|---|---|
| `True` | `True` | `True` | `True` | `False` |
| `True` | `False` | `False` | `True` | `False` |
| `False` | `True` | `False` | `True` | `True` |
| `False` | `False` | `False` | `False` | `True` |

```python run
has_ticket = True
has_id = False
age = 70

can_board = has_ticket and has_id
free_entry = age < 12 or age >= 65
needs_help_desk = not has_id

print("can board:      ", can_board)
print("free entry:     ", free_entry)
print("needs help desk:", needs_help_desk)
```

> **Pitfall:** `or` in Python is *inclusive*: `True or True` is `True`. In everyday English, "tea or coffee?" usually means one or the other, but Python's `or` is happy if both are true.

### Precedence: who goes first

When an expression mixes everything, Python applies this order (like times-before-plus in math):

```text
1.  arithmetic            ** then * / // % then + -
2.  comparisons           == != < > <= >=
3.  not
4.  and
5.  or                    (last)
```

So `not` binds tightest of the three, and `and` is done before `or`. That means `a or b and c` is read as `a or (b and c)`, which is often *not* what the writer meant.

```python run
is_weekend = True
is_holiday = False
is_sunny = False

# Meant: "it's a day off, AND it's sunny" -> go to the beach?
no_parens = is_weekend or is_holiday and is_sunny
with_parens = (is_weekend or is_holiday) and is_sunny

print("without parentheses:", no_parens)     # wrong: read as weekend or (holiday and sunny)
print("with parentheses:   ", with_parens)
```

> **Tip:** whenever you mix `and` and `or`, add parentheses, even if you know the rules. They cost nothing and make your intent obvious to the next reader (who is often you, next month).

```python predict id=predict-and-or-precedence title="and before or"
print(True or False and False)
--- options
* True
False
None
--- explain
`and` is evaluated before `or`, so this is `True or (False and False)`, which is `True or False`, which is `True`. If you read it left to right as `(True or False) and False`, you'd get `False`, which is exactly why parentheses are worth adding.
```

```python exercise id=cinema-discount title="Who gets the cinema discount?"
age = 70
is_member = False
is_peak_time = True

# TODO: define `gets_discount` as a single boolean expression.
# The rule: you get a discount if you're a child (under 12) or a senior
# (65 or over) or a member... but never at peak time.
# Use and / or / not and parentheses. Don't type True/False directly.
gets_discount = ...

print("discount:", gets_discount)
--- solution
age = 70
is_member = False
is_peak_time = True

gets_discount = (age < 12 or age >= 65 or is_member) and not is_peak_time

print("discount:", gets_discount)
--- test
assert gets_discount is not ..., "Replace the `...` after `gets_discount =` with a boolean expression."
assert isinstance(gets_discount, bool), f"`gets_discount` should be True or False, but it is {gets_discount!r}. Build it from comparisons joined with and / or / not."
expected = (age < 12 or age >= 65 or is_member) and not is_peak_time
assert gets_discount == expected, f"`gets_discount` is {gets_discount}, but for age={age}, is_member={is_member}, is_peak_time={is_peak_time} it should be {expected}. Peak time cancels every discount. Did you group the 'or' part in parentheses?"
--- hint
Split the rule in two: "who qualifies" (three things joined by `or`) and "when" (not peak time).
--- hint
Wrap the qualifying part in parentheses, then combine it with the timing part using `and`.
--- hint
The shape is `(... or ... or ...) and not is_peak_time`.
```

## Debug challenge: every day is the weekend

This is one of the most common logic bugs in all of Python. It runs without any error, which is what makes it sneaky.

```python debug id=always-weekend title="Every day counts as the weekend"
day = "Tuesday"

is_weekend = day == "Saturday" or "Sunday"

print("Is it the weekend?", is_weekend)
--- solution
day = "Tuesday"

is_weekend = day == "Saturday" or day == "Sunday"

print("Is it the weekend?", is_weekend)
--- test
assert isinstance(is_weekend, bool), f"`is_weekend` should be True or False, but it is {is_weekend!r}. Python read the right side of `or` as a value on its own, not as part of a comparison."
assert is_weekend is False, "Tuesday is not the weekend, but `is_weekend` is True."
assert day == "Tuesday", "Keep `day` as Tuesday; fix the comparison instead."
--- hint
Run it. You'd expect `False`, but it prints `Sunday`. Python read the line as `(day == "Saturday") or ("Sunday")`.
--- hint
`or` joins two complete questions. The right side, `"Sunday"`, isn't a question; it's just a non-empty string. Each side needs its own `day == ...`.
```

Why did it print `Sunday`? That's the subject of the next section.

## Truthiness: what counts as true?

Every value in Python, not just booleans, can be treated as true or false. The `bool()` function shows you how Python sees it. The rule is short: **empty and zero things are falsy; everything else is truthy.**

```python run
print("0     ->", bool(0))
print("0.0   ->", bool(0.0))
print("''    ->", bool(""))
print("[]    ->", bool([]))           # an empty list
print("42    ->", bool(42))
print("-3    ->", bool(-3))
print("'hi'  ->", bool("hi"))
print("' '   ->", bool(" "))          # a space is not empty!
print("'False' ->", bool("False"))    # non-empty text: truthy!
```

| Falsy (count as `False`) | Truthy (count as `True`) |
|---|---|
| `0`, `0.0` | any other number, even negative |
| `""` (empty string) | any non-empty string, even `" "` or `"False"` |
| `[]` (empty list) and other empty collections | collections with something in them |
| `None` | almost everything else |

Truthiness is what lets you write `if cart:` in the next lesson to mean "if the cart isn't empty".

> **Under the hood:** `bool` is a special kind of `int`: `True` behaves like `1` and `False` like `0`. So `True + True` is `2`, which turns out to be handy for counting how many conditions are true.

## Short-circuiting: `and` and `or` stop early

Python is lazy in a useful way. With `and`, if the left side is falsy, the answer is already known (it can't be "both"), so the right side is **never evaluated**. With `or`, a truthy left side is enough.

There's a second surprise: `and` and `or` don't always return `True`/`False`. They return **whichever operand decided the answer**. That's why the weekend bug printed `Sunday`: `day == "Saturday"` was `False`, so `or` returned its right side, the string `"Sunday"`.

```python run
nickname = ""
print("display:", nickname or "Guest")       # left is falsy -> right side

visits = 0
total_spent = 120.0
# Safe: if visits is 0, Python never runs the division.
big_spender = visits != 0 and total_spent / visits > 50
print("big spender:", big_spender)
```

`x or default` is a classic Python idiom: "use `x`, unless it's empty, then use `default`". And the `visits != 0 and ...` pattern guards against a `ZeroDivisionError`: without it, `120.0 / 0` would crash.

```python predict id=predict-or-default title="Guest or name?"
name = ""
print(name or "Guest")
--- options
True
False
* Guest
name
--- explain
`or` returns the first truthy operand. `name` is an empty string, which is falsy, so `or` moves on and returns `"Guest"`. With `name = "Maya"`, it would print `Maya`.
```

```python exercise id=display-name title="Fall back to Anonymous"
nickname = "   "

# TODO: define `display` for a comment section:
# the nickname without surrounding spaces, or "Anonymous" if nothing is
# left after removing them. Use `or`, not an if statement.
display = ...

print("Posted by:", display)
--- solution
nickname = "   "

display = nickname.strip() or "Anonymous"

print("Posted by:", display)
--- test
assert display is not ..., "Replace the `...` after `display =` with an expression using `or`."
assert isinstance(display, str), f"`display` should be a string, but it is {display!r}."
assert display != nickname, f"`display` is {display!r}: just spaces. A name made only of spaces should count as empty. Remove them first."
assert display == (nickname.strip() or "Anonymous"), f"`display` should be {(nickname.strip() or 'Anonymous')!r} for this nickname, but it is {display!r}."
--- hint
`"   "` is not empty (spaces are characters), so it's truthy. What string method would turn it into `""`?
--- hint
Clean the nickname first, then put `or "Anonymous"` after it.
```

## `None`, and the one place for `is`

`None` is Python's value for "nothing here yet": a middle name nobody entered, a score not recorded yet. It's falsy, and it has its own type, `NoneType`.

To check for it, Python style uses `is` instead of `==`:

```python run
middle_name = None
best_time = 12.4

print("no middle name?", middle_name is None)
print("has best time? ", best_time is not None)
type(middle_name)
```

`is` asks "are these the very **same object**?", while `==` asks "do these have equal **values**?" There's exactly one `None` object in all of Python, so `is None` is the precise question. For everything else, numbers and strings included, use `==`.

> **In the wild:** you'll see `if value is None:` everywhere in professional code, from Django views to pandas internals. Linters (tools that check code style) even flag `== None` as a mistake.

## Combining it all: a password check

`not in` is the opposite of `in` from lesson 05: `" " not in password` is `True` when there's no space anywhere.

```python exercise id=password-rules title="Check a password against the rules"
password = "sunflower42"

# TODO: define four booleans:
#   long_enough -> the password has at least 8 characters
#   no_spaces   -> the password contains no space characters
#   not_common  -> the password, lowercased, is not equal to "password"
#   is_valid    -> True only when all three rules pass
long_enough = ...
no_spaces = ...
not_common = ...
is_valid = ...

print(f"{long_enough=} {no_spaces=} {not_common=}")
print("valid:", is_valid)
--- solution
password = "sunflower42"

long_enough = len(password) >= 8
no_spaces = " " not in password
not_common = password.lower() != "password"
is_valid = long_enough and no_spaces and not_common

print(f"{long_enough=} {no_spaces=} {not_common=}")
print("valid:", is_valid)
--- test
names = {"long_enough": long_enough, "no_spaces": no_spaces, "not_common": not_common, "is_valid": is_valid}
todo = [k for k, v in names.items() if v is ...]
assert not todo, f"Replace the `...` for: {', '.join(todo)}"
for k, v in names.items():
    assert isinstance(v, bool), f"`{k}` should be True or False, but it is {v!r}."
assert long_enough == (len(password) >= 8), f"`long_enough` is {long_enough}, but the password has {len(password)} characters. 'At least 8' includes 8."
assert no_spaces == (" " not in password), f"`no_spaces` is {no_spaces}. Check for a space with `in` / `not in`."
assert not_common == (password.lower() != "password"), f"`not_common` is {not_common}. Compare the lowercased password with \"password\" using !=."
assert is_valid == (long_enough and no_spaces and not_common), f"`is_valid` is {is_valid}, but it should be True only when all three rules are True."
--- hint
Each rule is one comparison: `len(...)` with `>=`, `not in` for the space, and `!=` for the common-password check.
--- hint
`is_valid` combines the three booleans you already made. Which operator means "all of them"?
```

## Recap

- A **boolean** is `True` or `False` (capitalized). Comparisons `== != < > <= >=` produce them, and arithmetic happens first.
- Ranges read naturally with **chained comparisons**: `18 <= temp <= 24`. Never `==` floats directly.
- Strings compare exactly and alphabetically by code point: case and spaces matter, uppercase sorts first, `"10" < "9"`. A number never equals a string.
- `and` (both), `or` (at least one), `not` (flip). Precedence is `not`, then `and`, then `or`, so use parentheses. Each side of `or` must be a full condition: `day == "Sat" or day == "Sun"`.
- **Falsy**: `0`, `0.0`, `""`, empty collections, `None`. Everything else is truthy. `x or default` and `guard and risky` rely on short-circuiting. Check for `None` with `is None`.

**Up next:** talking to users: reading what they type with `input()` and converting text into numbers you can calculate with.
