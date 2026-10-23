Computers are spectacularly good at one thing humans hate: doing the same step again and again without getting bored. Add this week's savings, check whether you've hit your goal, repeat. Ask for a password, check it, ask again. Move the game character, redraw the screen, repeat sixty times a second. Each of these is a **loop**, and the simplest loop in Python is `while`.

A `while` loop is an `if` that keeps going: *while* the condition is true, run the block, then come back and ask again. In this lesson you'll write loops that count, compound interest until a savings goal is reached, and keep reading input until the user says stop. You'll also learn to spot (and escape) the classic loop bugs: the loop that never ends, and the loop that stops one step too early.

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

## Your first `while` loop

Here's a rocket countdown. Run it, then press **Debug** and step through it to watch `count` shrink:

```python run
count = 3

while count > 0:
    print(count)
    count -= 1

print("Liftoff!")
```

Read it like English: *while `count` is greater than 0, print it and subtract 1.* Python checks the condition, runs the block, then jumps **back up** to check the condition again. When `count` reaches `0`, `0 > 0` is false, the loop ends, and Python carries on with the first line after the block.

```text
         ┌──────────────────────────┐
         ▼                          │
   count > 0 ? ── True ──► print(count)
         │                 count -= 1 ──┘   (back to the question)
       False
         │
         ▼
   print("Liftoff!")
```

The syntax mirrors `if`: the keyword, a condition, a colon, and an indented block. The difference is what happens at the end of the block:

| | `if` | `while` |
|---|---|---|
| Checks the condition | once | before **every** pass |
| Runs the block | 0 or 1 times | 0, 1, 2, … times |
| After the block | moves on | goes back to the condition |

Each pass through the block is called an **iteration**.

## The three parts of every loop

Almost every `while` loop you'll write has the same three ingredients:

1. **Start:** set up a variable before the loop (`lap = 1`).
2. **Condition:** the question that decides whether to go round again (`lap <= 5`).
3. **Update:** a line inside the body that changes the variable, so the condition eventually becomes false (`lap += 1`).

```python run
lap = 1                      # 1. start

while lap <= 5:              # 2. condition
    print("Running lap", lap)
    lap += 1                 # 3. update

print("Finished after", lap - 1, "laps")
```

Notice that after the loop, `lap` is `6`, not `5`. The loop only stops once the condition is false, which means the variable has already gone one step past the last value that ran.

```python predict id=predict-doubling title="Where does it stop?"
n = 1
while n < 10:
    n = n * 2
print(n)
--- options
8
10
* 16
32
--- explain
`n` goes 1 → 2 → 4 → 8 → 16. When `n` is 8, `8 < 10` is still true, so the loop runs once more and doubles it to 16. Then `16 < 10` is false and the loop ends. The last value is always the **first one that fails** the condition, not the last one that passed.
```

The condition is checked **before** the first iteration too. If it's false from the start, the body never runs at all:

```python predict id=predict-zero-iterations title="A game with no lives"
lives = 0
while lives > 0:
    print("Playing...")
    lives -= 1
print("Game over")
--- options
Playing... Game over
* Game over
Nothing is printed
The loop runs forever
--- explain
`0 > 0` is false the very first time Python asks, so the body is skipped entirely and Python goes straight to `print("Game over")`. A `while` loop can run **zero** times.
```

## Repeat until a goal is reached

`while` really shines when you *don't know in advance* how many repetitions you'll need. How many years until your savings double at 7% interest? You could do the maths with logarithms, or you could just let Python simulate it year by year:

```python run
balance = 1000
goal = 2000
years = 0

while balance < goal:
    balance = balance * 1.07     # add 7% interest
    years += 1

print(f"After {years} years you have ${balance:,.2f}")
```

The loop doesn't care how many years it takes. It keeps compounding until the goal is reached, then stops. Change `goal` to `10_000` and run it again.

> **In the wild:** "Keep going until done" loops are everywhere in professional code: a script that retries a flaky download until it succeeds (with a limit!), a game's main loop that runs `while running:`, and machine-learning training that continues `while error > target`. Same three ingredients every time.

```python exercise id=savings-weeks title="Saving up for a bike"
goal = 250       # the bike costs $250
weekly = 15      # you save $15 every week
savings = 0
weeks = 0

# TODO: write a while loop that keeps adding `weekly` to `savings`
# (and 1 to `weeks`) until savings is enough to buy the bike.

print(f"After {weeks} weeks you have ${savings}")
--- solution
goal = 250
weekly = 15
savings = 0
weeks = 0

while savings < goal:
    savings += weekly
    weeks += 1

print(f"After {weeks} weeks you have ${savings}")
--- test
assert weeks != 0, "`weeks` is still 0. Add a `while` loop that adds to `savings` and `weeks` until you can afford the bike."
assert savings >= goal, f"`savings` is {savings}, but you need at least {goal}. Should the loop keep going?"
assert weeks == 17, f"Saving $15 a week, it takes 17 weeks to reach $250, but `weeks` is {weeks}. After 16 weeks you only have $240."
assert savings == 255, f"After 17 weeks of $15, `savings` should be 255, but it is {savings}."
for g, w in [(100, 25), (10, 50), (1000, 40), (99, 33)]:
    ns = _rerun(goal=g, weekly=w)
    want = -(-g // w)
    assert ns.get("weeks") == want, f"With goal = {g} and weekly = {w}, `weeks` should be {want} but is {ns.get('weeks')!r}."
--- hint
The question to keep asking is "do I still need more money?" Which comparison between `savings` and `goal` says that?
--- hint
`while savings < goal:` and then, indented underneath, two update lines: one for `savings`, one for `weeks`.
```

## Infinite loops (and how to escape them)

If nothing in the body ever makes the condition false, the loop runs **forever**. This is the most famous loop bug, and every programmer writes one sooner or later. The usual causes:

- forgetting the update line (`lap += 1`) entirely,
- updating the wrong variable, or
- updating in a way that jumps *over* the stopping point.

That last one is sneaky. This loop counts down by 3 and waits for the value to equal exactly 0, but 10, 7, 4, 1, −2… never *equals* 0. A **safety cap** (`steps < 8`) stops it anyway, so you can see what goes wrong:

```python run
x = 10
steps = 0

while x != 0 and steps < 8:   # the cap stops a runaway loop
    x -= 3
    steps += 1
    print("x is now", x)

print("Stopped after", steps, "steps with x =", x)
```

Without the cap, this would never end. The fix is to make the condition robust: `while x > 0` stops no matter how big the steps are.

If you ever do launch a runaway loop in this course, don't panic: press **Stop** on the cell (or **Restart** in the top bar) to interrupt it. The debugger also stops recording after a fixed number of steps, so stepping through a runaway loop won't freeze your page.

> **Tip:** When a loop waits for a value to reach a limit, prefer `<`, `>`, `<=` or `>=` over `!=`. A range check can't be "jumped over"; an exact match can. And when a loop talks to the outside world (a network, a user), add a cap like `attempts < 5` so it can't run forever.

This next bug is the "forgot to update" kind. The programmer was careful and added a safety cap, which is why it finishes at all.

```python debug id=savings-never-grow title="The savings plan takes 100 years"
balance = 500
goal = 1000
rate = 0.05      # 5% interest per year
years = 0

while balance < goal and years < 100:   # safety cap: never more than 100 years
    interest = balance * rate
    new_balance = balance + interest
    years += 1

print(f"Reached ${balance:,.2f} after {years} years")
--- solution
balance = 500
goal = 1000
rate = 0.05      # 5% interest per year
years = 0

while balance < goal and years < 100:   # safety cap: never more than 100 years
    interest = balance * rate
    balance = balance + interest
    years += 1

print(f"Reached ${balance:,.2f} after {years} years")
--- test
assert years != 100, "It still takes 100 years: the loop only stopped because of the safety cap. Is `balance` actually growing?"
assert balance >= goal, f"`balance` ends at {balance:.2f}, which is below the goal of {goal}."
assert years == 15, f"At 5% a year, $500 doubles in 15 years, but `years` is {years}."
for r, g in [(0.10, 1000), (0.05, 600), (0.20, 5000)]:
    b, y = 500, 0
    while b < g and y < 100:
        b, y = b + b * r, y + 1
    ns = _rerun(rate=r, goal=g)
    assert ns.get("years") == y, f"With rate = {r} and goal = {g}, `years` should be {y} but is {ns.get('years')!r}."
--- hint
Run it, then press **Debug** and watch the Variables table. Which variable does the loop condition check, and does it ever change?
--- hint
The new total is calculated and stored in `new_balance`, but the condition looks at `balance`. Make the loop update `balance` itself.
```

## Off by one: `<` or `<=`?

A loop that runs one time too many or one time too few is called an **off-by-one** error. It almost always comes down to the condition: `<` versus `<=`, or `> 0` versus `> 1`. Compare these two:

```python run
n = 1
while n < 5:
    print("A", n)
    n += 1

n = 1
while n <= 5:
    print("B", n)
    n += 1
```

Loop A prints 1 to 4; loop B prints 1 to 5. Neither is wrong in general. The question is always: *should the boundary value itself get a turn?*

The position of the update line inside the body matters too. Trace this one carefully (or use **Debug**):

```python predict id=predict-update-first title="Update first, then add"
n = 0
total = 0
while n < 5:
    n += 1
    total += n
print(total)
--- options
10
* 15
5
21
--- explain
Because `n` is increased **before** it's added, the values added are 1, 2, 3, 4 and 5, which sum to 15. If the two lines were swapped, the loop would add 0, 1, 2, 3 and 4, giving 10.
```

```python debug id=countdown-skips-one title="The countdown never says 1"
seconds = 5

while seconds > 1:
    print(seconds)
    seconds -= 1

print("Go!")
--- solution
seconds = 5

while seconds > 0:
    print(seconds)
    seconds -= 1

print("Go!")
--- test
lines = [line.strip() for line in _stdout.strip().splitlines()]
assert "1" in lines, f"The countdown printed {', '.join(lines)}. It should say 1 before \"Go!\"."
assert lines == ["5", "4", "3", "2", "1", "Go!"], f"The output should be 5, 4, 3, 2, 1, Go! on separate lines, but it was: {', '.join(lines)}."
three = [line.strip() for line in _rerun(seconds=3)["_out"].strip().splitlines()]
assert three == ["3", "2", "1", "Go!"], f"With seconds = 3, the output should be 3, 2, 1, Go!, but it was: {', '.join(three)}."
--- hint
Run it: the numbers stop at 2. When `seconds` is 1, what does the condition `seconds > 1` say?
--- hint
1 should still get its turn. Change the condition so the loop also runs when `seconds` is exactly 1.
```

## Decisions inside loops

The body of a loop can contain anything, including `if` statements. This is where loops get powerful: repeat a step, and make a decision on every pass.

```python run
battery = 100
hour = 0

while battery > 0:
    hour += 1
    battery -= 15
    if battery <= 0:
        print(f"Hour {hour}: phone died")
    elif battery < 30:
        print(f"Hour {hour}: low battery ({battery}%)")

print("The phone lasted", hour, "hours")
```

Notice the indentation levels: the `if`/`elif` is *inside* the loop (one level in), and the `print` lines are inside the `if` (two levels in). The final `print` is back at the left edge, so it runs once, after the loop is completely done.

The next challenge is a famous puzzle called the **hailstone sequence** (or the Collatz problem). Pick any whole number. If it's even, halve it. If it's odd, triple it and add 1. Repeat until you reach 1. Mathematicians believe *every* starting number eventually reaches 1, but nobody has ever proved it.

```python exercise id=hailstone-steps title="The hailstone game"
n = 6
steps = 0

# TODO: while n is not 1:
#   if n is even, halve it (use // so it stays a whole number)
#   otherwise, set n to 3 * n + 1
#   and add 1 to steps on every pass.
# For n = 6 the numbers go 6, 3, 10, 5, 16, 8, 4, 2, 1 (8 steps).

print("Steps to reach 1:", steps)
--- solution
n = 6
steps = 0

while n != 1:
    if n % 2 == 0:
        n = n // 2
    else:
        n = 3 * n + 1
    steps += 1

print("Steps to reach 1:", steps)
--- test
assert steps != 0, "`steps` is still 0. Write a `while` loop that keeps changing `n` until it reaches 1, counting each step."
assert n == 1, f"After the loop, `n` should have reached 1, but it is {n!r}."
assert steps == 8, f"Starting from 6 it takes 8 steps to reach 1, but `steps` is {steps}. Did you count every pass exactly once?"
for start in [7, 1, 27, 16]:
    m, want = start, 0
    while m != 1:
        m = m // 2 if m % 2 == 0 else 3 * m + 1
        want += 1
    got = _rerun(n=start).get("steps")
    assert got == want, f"With n = {start}, `steps` should be {want} but is {got!r}."
--- hint
You need three things: a loop that runs `while n != 1`, an `if`/`else` inside it, and a counter update.
--- hint
"Even" means `n % 2 == 0`. Put `steps += 1` inside the loop but *outside* the `if`/`else`, so it counts every pass.
--- hint
Here `n != 1` is safe even though the tip above prefers range checks: the sequence lands on exactly 1, it never jumps past it.
```

## Repeat until the user says stop

Sometimes the loop's job is to keep asking a person for input until they type a special "stop" value, called a **sentinel**. Because this page can't pause for your keyboard, `input()` here reads answers you queue up with `type_answers(...)`. In a real terminal, Python waits for you to type.

```python run
type_answers("4.50", "12", "3.25", "done")

total = 0
entry = input("Price (or 'done'): ")

while entry != "done":
    total += float(entry)
    entry = input("Price (or 'done'): ")

print(f"Basket total: ${total:.2f}")
```

Look at the shape: read once **before** the loop, then read again as the **last line** of the body. The second `input()` is the update. Forget it, and `entry` never changes, so the loop never ends.

Forget the conversion from lesson 8 instead, and Python stops you on the first pass. Read the last line of this error:

```python run error
type_answers("4.50", "done")

total = 0
entry = input("Price (or 'done'): ")

while entry != "done":
    total += entry
    entry = input("Price (or 'done'): ")
```

`TypeError: unsupported operand type(s) for +=: 'int' and 'str'`: you tried to add the text `"4.50"` to the number `0`. `input()` always returns a string, so wrap it in `float(...)` before doing maths.

### A preview: `while True` and `break`

Reading input twice (before the loop and at the end) works, but it repeats a line. Many programmers prefer a loop that runs "forever" and leaves through an exit door in the middle. `break` ends the loop immediately:

```python run
type_answers("red", "green", "quit")

while True:
    colour = input("Favourite colour (or 'quit'): ")
    if colour == "quit":
        break
    print("Nice choice:", colour.upper())

print("Bye!")
```

`while True` would loop forever on its own; the `break` is the only way out. You'll study `break`, its partner `continue`, and when to use each in lesson 12.

```python exercise id=guess-the-number title="Guess the number"
type_answers("50", "75", "62")   # the player's guesses, in order
secret = 62
tries = 0
guess = -1

# TODO: while guess is not the secret:
#   read a guess with int(input("Your guess: ")) and add 1 to tries
#   print "Too low", "Too high" or "Got it!" depending on the guess

print("Tries:", tries)
--- solution
type_answers("50", "75", "62")
secret = 62
tries = 0
guess = -1

while guess != secret:
    guess = int(input("Your guess: "))
    tries += 1
    if guess < secret:
        print("Too low")
    elif guess > secret:
        print("Too high")
    else:
        print("Got it!")

print("Tries:", tries)
--- test
assert tries != 0, "`tries` is still 0. Write a `while` loop that reads guesses with `input()` until the secret is found."
assert isinstance(guess, int), f"`guess` should be a whole number, but it is {guess!r}. Did you convert the input with `int(...)`?"
assert guess == secret and tries == 3, f"The player guessed 50, 75, 62, so they should find it in 3 tries, but `tries` is {tries}."
low, high, got = _stdout.find("Too low"), _stdout.find("Too high"), _stdout.find("Got it!")
assert -1 not in (low, high, got), "Print \"Too low\", \"Too high\" and \"Got it!\" for the matching guesses."
assert low < high < got, "The messages should come in order: 50 is too low, 75 is too high, 62 is right."
ns = _rerun(_typed=("10", "90", "40", "30"), secret=30)
assert ns.get("tries") == 4, f"With secret = 30 and guesses 10, 90, 40, 30, `tries` should be 4 but is {ns.get('tries')!r}."
assert ns["_out"].count("Too high") == 2 and ns["_out"].count("Got it!") == 1, "With secret = 30, the guesses 90 and 40 should both print \"Too high\"."
--- hint
`guess` starts at -1 so the condition `guess != secret` is true the first time. The first line inside the loop should read a new guess.
--- hint
Inside the loop: read and convert the guess, add 1 to `tries`, then an `if`/`elif`/`else` comparing `guess` with `secret`.
```

## Recap

- `while condition:` repeats its block as long as the condition is true, checking **before every pass**, so it can run zero times.
- Every loop needs a **start**, a **condition** and an **update**. A missing or wrong update is an infinite loop; press **Stop** to escape one.
- Prefer range checks (`>`, `<=`) over exact `!=` matches, and add a safety cap when a loop depends on the outside world.
- Off-by-one bugs live in the condition (`<` vs `<=`) and in where the update sits in the body.
- Sentinel loops read input until a stop value; `while True` with `break` is a tidy alternative.

**Up next:** `for` loops and `range()`, the easiest way to repeat something a known number of times or walk through every letter of a string.
