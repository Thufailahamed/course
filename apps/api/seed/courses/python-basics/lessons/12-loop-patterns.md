Here's a secret experienced programmers rarely say out loud: almost every loop they write is one of about half a dozen **patterns**. Count the things that match. Find the biggest. Search until you find it. Stop early once you know the answer. Skip the junk. Keep asking until the input is valid. Once you can recognize these shapes, you stop inventing loops from scratch and start *assembling* them, and your code gets faster to write and much easier to read.

In this lesson you'll learn each pattern with a real example, plus the three keywords that give you fine control over a loop: `break` (stop now), `continue` (skip to the next item) and the curious `for…else` (run this only if the search came up empty). You'll also fix two classic bugs: announcing "not found" too early, and a `continue` that skips the line the loop depends on.

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

```python setup
# Hidden checker helper: lets the tests re-run your challenge code with other starting values.
import contextlib as _contextlib, io as _io, linecache as _linecache, re as _re, sys as _sys

def _rerun(_typed=None, **values):
    src = "".join(_linecache.cache["<cell>"][2])
    settings = ", ".join(f"{k} = {v!r}" for k, v in values.items()) or f"the answers {_typed}"
    for name, value in values.items():
        src, found = _re.subn(rf"(?m)^{name}\s*=(?!=).*$", f"{name} = {value!r}", src, count=1)
        assert found, f"Keep the line `{name} = ...` in your code so the checker can try other values."
    if _typed is not None:
        src = _re.sub(r"(?m)^type_answers\(.*\)[ \t]*(#.*)?$", "", src)
        _queued.clear()
        type_answers(*_typed)
    ns = {k: v for k, v in globals().items() if k in _SETUP_NAMES}
    out, steps = _io.StringIO(), [0]
    def guard(frame, event, arg):
        if frame.f_code.co_filename != "<cell>":
            return None
        steps[0] += 1
        if steps[0] > 200_000:
            raise AssertionError(f"With {settings}, your loop never stopped. Does every pass move closer to ending it?")
        return guard
    try:
        with _contextlib.redirect_stdout(out):
            _sys.settrace(guard)
            try:
                exec(compile(src, "<cell>", "exec"), ns)
            finally:
                _sys.settrace(None)
    except AssertionError:
        raise
    except Exception as e:
        raise AssertionError(f"With {settings}, your code crashed with {type(e).__name__}: {e}")
    ns["_out"] = out.getvalue()
    return ns

_SETUP_NAMES = set(globals()) | {"_SETUP_NAMES"}
```

## Pattern 1: counting matches

To count how many items pass a test, start a counter at 0 and add 1 whenever the test is true. It's an accumulator (lesson 11) with an `if` in front of the update.

```python run
forecast = "SSRCRSSRRS"     # one letter per day: S = sun, R = rain, C = cloud

rainy_days = 0
for day in forecast:
    if day == "R":
        rainy_days += 1

print("Rainy days in the next", len(forecast), "days:", rainy_days)
```

The same shape works with `range`. How many numbers below 100 are divisible by 7?

```python run
multiples = 0
for n in range(1, 100):
    if n % 7 == 0:
        multiples += 1
multiples
```

> **Tip:** For counting a single character or substring, the string method `.count()` from lesson 6 does it in one call (`forecast.count("R")`). The loop pattern earns its keep when the test is more interesting than "equals this exact text", like the password rules in the next challenge.

```python exercise id=password-strength title="How strong is this password?"
password = "Sunny2025Days!"

# TODO: loop over the password and count:
#   digits  -> characters where ch.isdigit() is True
#   uppers  -> capital letters, where ch.isupper() is True
# Then set `strong` to True if there are at least 2 digits AND at least 2 capitals.
digits = 0
uppers = 0
strong = ...

print(f"{digits} digits, {uppers} capitals, strong: {strong}")
--- solution
password = "Sunny2025Days!"

digits = 0
uppers = 0
for ch in password:
    if ch.isdigit():
        digits += 1
    elif ch.isupper():
        uppers += 1
strong = digits >= 2 and uppers >= 2

print(f"{digits} digits, {uppers} capitals, strong: {strong}")
--- test
assert digits != 0 or uppers != 0, "`digits` and `uppers` are both still 0. Loop over `password` and add 1 to the right counter for each character."
assert digits == 4, f"\"Sunny2025Days!\" has 4 digits, but `digits` is {digits}."
assert uppers == 2, f"\"Sunny2025Days!\" has 2 capital letters (S and D), but `uppers` is {uppers}."
assert strong is not ..., "Replace `strong = ...` with a True/False expression using your two counters."
assert strong is True, f"4 digits and 2 capitals is strong, but `strong` is {strong!r}."
for pw in ["password", "ABcd12", "Abc123", "XYZ9", "9Lives2Cats"]:
    d = sum(c.isdigit() for c in pw)
    u = sum(c.isupper() for c in pw)
    ns = _rerun(password=pw)
    got = (ns.get("digits"), ns.get("uppers"), ns.get("strong"))
    assert got == (d, u, d >= 2 and u >= 2), f"With password = {pw!r}, expected digits={d}, uppers={u}, strong={d >= 2 and u >= 2}, but got digits={got[0]!r}, uppers={got[1]!r}, strong={got[2]!r}."
--- hint
One `for` loop over `password`, with an `if` for digits and another check for capitals. Each one adds 1 to its own counter.
--- hint
After the loop (not inside it), `strong = digits >= 2 and uppers >= 2`.
```

## Pattern 2: finding the biggest (or smallest)

To find the maximum by hand, keep a "best so far" variable and replace it whenever you see something better. Python has a built-in `max()`, but writing the pattern yourself lets you track *extra* information, like **which day** was hottest.

```python run
temperatures = [18, 23, 31, 27, 19]     # Monday to Friday (lists: lesson 13)

hottest = None
hottest_day = 0
day = 0
for temp in temperatures:
    day += 1
    if hottest is None or temp > hottest:
        hottest = temp
        hottest_day = day

print(f"Hottest: {hottest}°C on day {hottest_day}")
```

Why start at `None` instead of `0`? Because 0 is a real temperature. Watch what happens with a cold week:

```python predict id=predict-max-start-zero title="The coldest week of the year"
highest = 0
for temp in [-5, -2, -9, -4]:
    if temp > highest:
        highest = temp
print(highest)
--- options
-2
* 0
-9
-5
--- explain
Every temperature is below 0, so `temp > highest` is never true and `highest` keeps its made-up starting value of 0, a temperature that never happened. Start with `None` (meaning "nothing seen yet") or with the first real value.
```

`None` means "no value yet", but you can't compare it with a number. That's why the condition says `hottest is None or temp > hottest`: thanks to short-circuiting (lesson 7), the comparison is skipped while `hottest` is still `None`. Leave that check out and Python complains on the first pass:

```python run error
coldest = None
for temp in [12, 8, 15]:
    if temp < coldest:
        coldest = temp
```

`TypeError: '<' not supported between instances of 'int' and 'NoneType'`: you asked whether 12 is less than "nothing", which has no answer.

```python exercise id=longest-word title="Find the longest word"
sentence = "the quick brown fox jumps over the lazy dog"

# TODO: loop over sentence.split() and set `longest` to the longest word.
# If several words tie for longest, keep the FIRST one.
# For this sentence the answer is "quick".
longest = ""

print("Longest word:", longest)
--- solution
sentence = "the quick brown fox jumps over the lazy dog"

longest = ""
for word in sentence.split():
    if len(word) > len(longest):
        longest = word

print("Longest word:", longest)
--- test
assert longest != "", "`longest` is still empty. Loop over `sentence.split()` and keep the longest word you've seen so far."
assert isinstance(longest, str), f"`longest` should be a word (a string), but it is {longest!r}."
assert longest in ("brown", "jumps") or longest == "quick", f"`longest` should be a 5-letter word, but it is {longest!r}."
assert longest == "quick", f"\"quick\", \"brown\" and \"jumps\" all have 5 letters; keep the first one. You got {longest!r}. Check `>` versus `>=`."
for text, want in [("I love programming in Python", "programming"), ("a bb cc ddd ee", "ddd"), ("sun moon star", "moon"), ("hello", "hello")]:
    got = _rerun(sentence=text).get("longest")
    assert got == want, f"With sentence = {text!r}, `longest` should be {want!r} but is {got!r}."
--- hint
`sentence.split()` (lesson 6) breaks the sentence into words you can loop over, one word per pass.
--- hint
Compare lengths: `if len(word) > len(longest):` then remember this word. Using `>` (not `>=`) keeps the first of several equally long words.
```

## Pattern 3: searching with a flag

"Is this item anywhere in here?" sounds simple, but there's a trap: you only know the answer is **no** after checking *every* item. A single mismatch tells you nothing. The fix is a **flag**: a boolean that starts `False` and flips to `True` when you find a match. You make the decision *after* the loop.

```python run
guest = "Priya"
found = False

for name in ["Tom", "Priya", "Sam", "Lena"]:
    if name == guest:
        found = True

if found:
    print(guest, "is on the guest list.")
else:
    print(guest, "is not on the guest list.")
```

Try `guest = "Max"`. The `else` message prints exactly once, after every name has been checked.

```python debug id=no-flights-too-early title="It says 'no flights' even when there is one"
destinations = ["Paris", "Lisbon", "Rome", "Oslo"]
wanted = "Lisbon"

for city in destinations:
    if city == wanted:
        print("Good news: we fly to", wanted)
    else:
        print("Sorry, no flights to", wanted)
--- solution
destinations = ["Paris", "Lisbon", "Rome", "Oslo"]
wanted = "Lisbon"

found = False
for city in destinations:
    if city == wanted:
        found = True

if found:
    print("Good news: we fly to", wanted)
else:
    print("Sorry, no flights to", wanted)
--- test
lines = [line for line in _stdout.strip().splitlines() if line.strip()]
assert "Sorry" not in _stdout, f"Lisbon IS a destination, but your code still printed: {lines[0] if lines else 'nothing'}. Can you decide \"no flights\" after checking just one city?"
assert lines == ["Good news: we fly to Lisbon"], f"The program should print exactly one line, \"Good news: we fly to Lisbon\", but printed {len(lines)} line(s)."
out = [l for l in _rerun(wanted="Tokyo")["_out"].strip().splitlines() if l.strip()]
assert out == ["Sorry, no flights to Tokyo"], f"With wanted = \"Tokyo\", it should print \"Sorry, no flights to Tokyo\" exactly once, but printed: {out}."
out = [l for l in _rerun(wanted="Oslo")["_out"].strip().splitlines() if l.strip()]
assert out == ["Good news: we fly to Oslo"], f"With wanted = \"Oslo\" (the last city), it should print only the good news, but printed: {out}."
--- hint
Run it: you get one "Sorry" for Paris before Lisbon is even checked, and more after it. One city not matching doesn't mean no city matches.
--- hint
Use a flag: `found = False` before the loop, set it to `True` on a match, and move the good news / sorry decision to *after* the loop.
```

## `break`: stop as soon as you know

Once a search finds what it's looking for, there's no point checking the rest. `break` ends the loop immediately and jumps to the first line after it.

```python run
transactions = [42.50, 18.00, -250.00, 12.99, 7.25]   # money in (+) and out (-)

checked = 0
for amount in transactions:
    checked += 1
    if amount < -100:
        print("Large withdrawal spotted:", amount)
        break

print("Stopped after checking", checked, "transactions")
```

The loop stopped on the third transaction and never looked at the last two. On five items that saves almost nothing, but on five million it can save minutes.

## `for…else`: the built-in "not found"

Python has an unusual feature that fits the search pattern perfectly: a `for` loop can have an `else` block. It runs only if the loop **finished normally, without hitting `break`**. In other words: "searched everything and never found it."

```python run
wanted = "Rome"

for city in ["Paris", "Lisbon", "Oslo"]:
    if city == wanted:
        print("Found", wanted)
        break
else:
    print(wanted, "is not on the list")
```

No flag needed: `break` means found, `else` means not found. Notice the `else` lines up with `for`, not with the `if`.

> **Pitfall:** The name confuses everyone at first, because it has nothing to do with `if`/`else`. Read `for…else` as **"for… if no break"**. `while` loops can have one too, with the same meaning.

```python predict id=predict-for-else title="Break or else?"
for n in range(2, 6):
    if n * n > 10:
        print("found", n)
        break
else:
    print("none")
--- options
* found 4
found 4 none
none
found 5
--- explain
2² = 4 and 3² = 9 are not above 10, but 4² = 16 is, so `found 4` prints and `break` ends the loop. Because the loop was broken out of, the `else` block is skipped. It would only run if no square above 10 were found.
```

A number is **prime** if nothing except 1 and itself divides it evenly. That's a search: look for a divisor, and if the search comes up empty, the number is prime.

```python exercise id=is-prime title="Is it prime?"
n = 29     # always 2 or more

# TODO: set `is_prime` to True or False.
# Search for a divisor: try every d from 2 up to (but not including) n.
# If n % d == 0, n is NOT prime, and you can stop searching.
# If no divisor is found, n IS prime. (for...else fits perfectly, or use a flag.)
is_prime = ...

print(n, "is prime:", is_prime)
--- solution
n = 29

for d in range(2, n):
    if n % d == 0:
        is_prime = False
        break
else:
    is_prime = True

print(n, "is prime:", is_prime)
--- test
assert is_prime is not ..., "Replace `is_prime = ...` with a search loop that decides True or False."
assert isinstance(is_prime, bool), f"`is_prime` should be True or False, but it is {is_prime!r}."
assert is_prime is True, "29 has no divisors other than 1 and 29, so `is_prime` should be True."
for m, want in [(2, True), (4, False), (9, False), (91, False), (97, True), (13, True), (25, False)]:
    got = _rerun(n=m).get("is_prime")
    assert got == want, f"With n = {m}, `is_prime` should be {want} but is {got!r}." + (" (91 = 7 x 13.)" if m == 91 else "")
--- hint
Loop with `for d in range(2, n):`. Inside, check `n % d == 0`: a remainder of 0 means `d` divides `n` evenly.
--- hint
On a divisor, set `is_prime = False` and `break`. Then add an `else:` lined up with the `for`, which sets `is_prime = True`.
--- hint
With a flag instead: `is_prime = True` before the loop, and set it to `False` when you find a divisor.
```

## `continue`: skip to the next item

`continue` abandons the **current** pass and jumps straight back to the top of the loop for the next item. It's handy for skipping junk without wrapping the rest of the body in an extra `if`.

```python run
readings = [21.5, -999, 22.1, 22.8, -999, 23.4]   # -999 means "sensor glitch"

total = 0
valid = 0
for r in readings:
    if r == -999:
        continue           # skip glitches, go to the next reading
    total += r
    valid += 1

print(f"Average of {valid} valid readings: {total / valid:.2f}")
```

```python predict id=predict-continue-skip title="Skipping the dashes"
for ch in "a-b-c":
    if ch == "-":
        continue
    print(ch, end="")
--- options
a-b-c
a
* abc
a b c
--- explain
For each `-`, `continue` jumps back to the top of the loop before `print` runs, so only `a`, `b` and `c` are printed. `end=""` keeps them together with no spaces.
```

| Keyword | Effect | Typical use |
|---|---|---|
| `break` | leave the loop completely | stop a search once found |
| `continue` | skip the rest of this pass, start the next | ignore invalid or unwanted items |
| `for…else` | run a block only if no `break` happened | "searched everything, not found" |

`continue` has one dangerous interaction. In a `while` loop, the update line is part of the body, and `continue` can skip it. The programmer below added a safety cap, which is the only reason this finishes:

```python debug id=continue-skips-update title="The total is stuck at zero"
# Add up the whole numbers from 1 to limit, skipping multiples of 3.
limit = 10
n = 0
total = 0
passes = 0

while n < limit and passes < 1000:   # safety cap
    passes += 1
    if n % 3 == 0:
        continue
    total += n
    n += 1

print("Total:", total, "after", passes, "passes")
--- solution
# Add up the whole numbers from 1 to limit, skipping multiples of 3.
limit = 10
n = 0
total = 0
passes = 0

while n < limit and passes < 1000:   # safety cap
    passes += 1
    n += 1
    if n % 3 == 0:
        continue
    total += n

print("Total:", total, "after", passes, "passes")
--- test
assert passes != 1000, "The loop hit the safety cap of 1000 passes, so it's stuck. Press Debug and watch: does `n` ever change?"
assert total == 37, f"1 to 10 without 3, 6 and 9 adds up to 37, but `total` is {total}." + (" Is 10 included?" if total == 27 else "")
for lim in [20, 5, 1]:
    want = sum(k for k in range(1, lim + 1) if k % 3 != 0)
    ns = _rerun(limit=lim)
    assert ns.get("total") == want, f"With limit = {lim}, `total` should be {want} but is {ns.get('total')!r}."
--- hint
Press **Debug** and watch `n`. It starts at 0, and 0 is a multiple of 3, so `continue` runs. Which line never gets reached?
--- hint
The update `n += 1` must happen on every pass, including the skipped ones. Move it above the `if`, so `continue` can't jump over it. (Check that 10 is still included in the total.)
```

## Pattern 4: `while True` until the input is valid

You previewed this in lesson 10. When a program needs a valid answer from a person, it should keep asking until it gets one. The cleanest shape is a loop that runs "forever" with a `break` as the exit door. As in lesson 10, `input()` here reads answers queued with `type_answers(...)`, because this page can't pause for your keyboard.

```python run
type_answers("twelve", "-3", "12")

while True:
    answer = input("How many tickets? ")
    if not answer.isdigit():
        print("Please type a whole number.")
        continue
    tickets = int(answer)
    if tickets == 0:
        print("You need at least one ticket.")
        continue
    break

print("Booking", tickets, "tickets.")
```

Each `continue` means "that answer was no good, ask again"; the `break` only happens once every check has passed. (`"-3".isdigit()` is `False` because of the minus sign, so negative numbers are rejected too.)

In real systems, "forever" usually has a limit. A bank card gives you three attempts, not infinite ones:

```python exercise id=pin-attempts title="Three tries to enter your PIN"
type_answers("1111", "2580", "9999")   # what the user types, in order
correct_pin = "2580"
attempts = 0
unlocked = False

# TODO: let the user try at most 3 times. For each try:
#   read a PIN with input("PIN: ") and add 1 to `attempts`
#   if it's correct: set unlocked = True, print "Unlocked!" and stop asking
# If all 3 tries are wrong, print "Card locked" (once, at the end).

print("Attempts used:", attempts)
--- solution
type_answers("1111", "2580", "9999")
correct_pin = "2580"
attempts = 0
unlocked = False

while attempts < 3:
    pin = input("PIN: ")
    attempts += 1
    if pin == correct_pin:
        unlocked = True
        print("Unlocked!")
        break

if not unlocked:
    print("Card locked")

print("Attempts used:", attempts)
--- test
assert attempts != 0, "`attempts` is still 0. Write a loop that reads a PIN with `input()` and counts each try."
assert unlocked is True, "The second PIN typed is correct, so `unlocked` should end up True."
assert attempts == 2, f"The right PIN is the 2nd one typed, so the loop should stop after 2 attempts, but `attempts` is {attempts}. Did you `break`?"
assert "Unlocked!" in _stdout and "Card locked" not in _stdout, "When the PIN is right, print \"Unlocked!\" and not \"Card locked\"."
ns = _rerun(_typed=("0000", "1234", "4321", "2580"))
assert ns.get("attempts") == 3, f"With three wrong PINs, the loop should stop after 3 attempts, but `attempts` is {ns.get('attempts')!r}."
assert ns.get("unlocked") is False and ns["_out"].count("Card locked") == 1, "After three wrong PINs, `unlocked` should stay False and \"Card locked\" should print exactly once."
assert "Unlocked!" not in ns["_out"], "A 4th try must not be allowed: after three wrong PINs, the card stays locked."
ns = _rerun(_typed=("2580",))
assert ns.get("attempts") == 1 and ns.get("unlocked") is True, "If the first PIN is right, the loop should stop after 1 attempt."
--- hint
`while attempts < 3:` gives at most three tries. Inside: read, count, then check the PIN.
--- hint
On the correct PIN, set the flag, print, and `break`. After the loop, `if not unlocked:` tells you every try failed. (A `while…else` works here too.)
```

## Nested loops: `break` only escapes one level

`break` leaves the **innermost** loop it's in, not every loop around it. Here the inner loop stops at the first free seat in a row, but the outer loop carries on to the next row anyway:

```python run
seating = "XXOX XOOO OXXX"      # one block per row: X = taken, O = free

row_number = 0
for row in seating.split():
    row_number += 1
    seat_number = 0
    for seat in row:
        seat_number += 1
        if seat == "O":
            print(f"Row {row_number}: first free seat is {seat_number}")
            break        # leaves the inner loop only
```

To stop *both* loops after the very first free seat in the whole theatre, combine `break` with a flag that the outer loop checks:

```python run
found = False
row_number = 0
for row in seating.split():
    row_number += 1
    seat_number = 0
    for seat in row:
        seat_number += 1
        if seat == "O":
            found = True
            break
    if found:
        break

print(f"Book row {row_number}, seat {seat_number}")
```

> **In the wild:** When nested searches get complicated, professionals usually move the search into a **function** and use `return` to exit every loop at once. You'll learn functions in lesson 19, and this is one of the reasons they're so useful.

## Recap

- **Count:** start at 0, add 1 inside an `if`. **Find the best:** keep a "best so far" (start with `None` or the first value, never a made-up number).
- **Search:** use a flag, and decide "not found" only **after** the loop has checked everything.
- `break` stops a loop immediately; `continue` skips to the next pass. In a `while` loop, make sure `continue` can't skip the update.
- `for…else` runs the `else` block only if the loop finished **without** `break`: a built-in "not found".
- `while True` + `break` (with a limit where it matters) is the standard shape for "keep asking until the input is valid".

**Up next:** lists, Python's ordered collections. You've been looping over them already; now you'll create, change and grow them yourself.
