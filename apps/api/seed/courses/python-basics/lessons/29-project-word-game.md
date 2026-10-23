In early 2022, a simple word game took over the internet: guess a secret five-letter word in six tries, and after each guess every letter turns green, yellow or gray. Millions of people shared their little grids of colored squares every morning. Wordle was originally written by one software engineer as a gift for his partner, and the core of it is small enough to build with what you already know.

That's this project. You'll build your own Wordle-style game piece by piece: picking a secret word, rejecting bad guesses, scoring letters (including the tricky case of repeated letters, which trips up plenty of real implementations), drawing the colored feedback, running the turn-by-turn game loop, tracking a player's stats and offering another round. It's strings, loops, dictionaries, functions and `random`, all working together in a program you can actually play.

> **How this project works:** each step is a challenge that builds one piece of the game. Challenges run on their own, so later steps bring in the finished helpers from earlier steps. At the end, you'll play a full session.

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
# The game's word list, plus wordgame.py: a module holding the finished helpers from the steps below.
WORDS = ["apple", "beach", "brave", "chair", "crane", "dance", "eagle", "flame", "ghost", "grape", "house",
         "lemon", "mango", "night", "ocean", "piano", "queen", "river", "stone", "tiger", "train", "water"]

_ENGINE = '''"""Finished helpers for the word game."""
from collections import Counter

SYMBOLS = {"G": "\U0001F7E9", "Y": "\U0001F7E8", "-": "⬜"}

def pick_secret(words, rng):
    return rng.choice([w.lower() for w in words if len(w) == 5])

def validate_guess(guess, words):
    if len(guess) != 5:
        return "Guesses must be 5 letters."
    if not guess.isalpha():
        return "Letters only, please."
    if guess not in words:
        return "Not in the word list."
    return None

def score_guess(guess, secret):
    marks = ["-"] * 5
    remaining = Counter(secret)
    for i in range(5):
        if guess[i] == secret[i]:
            marks[i] = "G"
            remaining[guess[i]] -= 1
    for i in range(5):
        if marks[i] == "-" and remaining[guess[i]] > 0:
            marks[i] = "Y"
            remaining[guess[i]] -= 1
    return "".join(marks)

def render(guess, marks):
    return "".join(SYMBOLS[m] for m in marks) + "  " + guess.upper()

def new_stats():
    return {"played": 0, "won": 0, "streak": 0, "best_streak": 0}

def update_stats(stats, result):
    stats["played"] += 1
    if result is None:
        stats["streak"] = 0
    else:
        stats["won"] += 1
        stats["streak"] += 1
        stats["best_streak"] = max(stats["best_streak"], stats["streak"])
'''
with open("wordgame.py", "w", encoding="utf-8") as _f:
    _f.write(_ENGINE)

import importlib as _importlib, sys as _sys
if "" not in _sys.path:
    _sys.path.insert(0, "")
_importlib.invalidate_caches()
```

## The plan

A game feels like one big thing, but it's really a handful of small jobs. Here's the whole program as a pipeline, one function per box:

```text
WORDS ─► pick_secret ─► ┌──────────── game loop (up to 6 turns) ────────────┐ ─► update_stats ─► play again?
                        │ input ─► validate_guess ─► score_guess ─► render  │
                        └───────────────────────────────────────────────────┘
```

The setup has loaded `WORDS`, the list of 22 five-letter words the game knows:

```python run
print(len(WORDS), "words, for example:", WORDS[:6])
```

## Step 1: choose a secret word

A game needs randomness, but a *test* needs the opposite: the same result every time. A `random.Random` object with a fixed **seed** gives you both. It produces a sequence that looks random but is exactly reproducible:

```python run
import random

rng = random.Random(42)
print([rng.choice(WORDS) for _ in range(3)])

rng = random.Random(42)    # same seed, fresh start
print([rng.choice(WORDS) for _ in range(3)])
```

Each `Random` object is its own independent "dice". Passing one around as a parameter (instead of using the module-level `random.choice`) means the caller decides how random the game is: seeded for testing, unseeded for real play.

```python predict id=predict-same-seed title="Two dice, same seed"
import random

a = random.Random(7)
b = random.Random(7)
print(a.randint(1, 100) == b.randint(1, 100), a.randint(1, 100) == b.randint(1, 100))
--- options
False False
* True True
True False
It changes every run
--- explain
Two generators with the same seed produce **the same sequence**, number for number. The first draws match, and so do the second draws. That's what makes seeded randomness perfect for testing: "random" behavior you can reproduce exactly.
```

Real word lists are rarely clean. Yours might come from a file with capitals, short words and long words mixed in, so `pick_secret` should only choose from the lowercase five-letter ones.

```python exercise id=pick-secret title="Pick the secret word"
import random

def pick_secret(words, rng):
    """Return a random word from words, using rng (a random.Random object).

    Only 5-letter words count, and the result must be lowercase.
    """
    # TODO: build a list of the 5-letter words (lowercased), then pick one with rng
    candidates = ...
    return ...

rng = random.Random(42)
print(pick_secret(WORDS, rng))
print(pick_secret(["Hi", "TIGER", "Spaceship", "Mango"], rng))
--- solution
import random

def pick_secret(words, rng):
    """Return a random word from words, using rng (a random.Random object).

    Only 5-letter words count, and the result must be lowercase.
    """
    candidates = [w.lower() for w in words if len(w) == 5]
    return rng.choice(candidates)

rng = random.Random(42)
print(pick_secret(WORDS, rng))
print(pick_secret(["Hi", "TIGER", "Spaceship", "Mango"], rng))
--- test
import random
r = pick_secret(["Hi", "TIGER", "Spaceship", "Mango", "ox"], random.Random(1))
assert r is not ..., "`pick_secret` returns `...`. Replace the placeholders with your code."
assert isinstance(r, str), f"`pick_secret` should return a word (a string), but returned {r!r}."
assert r in ("tiger", "mango"), f"From ['Hi', 'TIGER', 'Spaceship', 'Mango', 'ox'] the only choices are 'tiger' and 'mango', but you returned {r!r}. Keep only 5-letter words, and lowercase them."
mixed = ["Plant", "sun", "Cloud", "rain", "Storm", "breeze", "Frost"]
expected = random.Random(7).choice([w.lower() for w in mixed if len(w) == 5])
assert pick_secret(mixed, random.Random(7)) == expected, "With the same seed, `pick_secret` should always pick the same word. Use `rng.choice(...)` on your filtered list (not `random.choice`)."
picks = {pick_secret(WORDS, random.Random(s)) for s in range(30)}
assert len(picks) > 5, f"30 different seeds only ever picked {picks}. Are you choosing randomly from the whole filtered list?"
--- hint
A list comprehension with an `if` filter builds `candidates`: keep `w.lower()` for each `w` whose length is 5.
--- hint
Then `return rng.choice(candidates)`. Use the `rng` you were given, so the seed controls the result.
```

## Step 2: is that a real guess?

Players make typos. Before a guess costs a turn, the game checks three rules: it has exactly 5 characters, they're all letters, and it's a word the game knows. `.isalpha()` is the letters-only cousin of `.isdigit()` from lesson 6:

```python run
for guess in ["crane", "cr4ne", "cra ne", "CRANE"]:
    print(f"{guess!r:9} isalpha: {guess.isalpha()}")
```

A space counts as "not a letter", and capitals are still letters. The game will tidy every guess with `.strip().lower()` before checking it, so `validate_guess` can assume a clean, lowercase string.

> **Tip:** Returning `None` for "all good" and a message string for "something's wrong" is a handy pattern: the caller can write `if problem:` because `None` is falsy and any non-empty message is truthy.

```python exercise id=validate-guess title="Reject invalid guesses"
def validate_guess(guess, words):
    """Check a (stripped, lowercase) guess. Return None if it's valid.

    Otherwise return one of these messages, checking the rules in this order:
      "Guesses must be 5 letters."
      "Letters only, please."
      "Not in the word list."
    """
    # TODO: check the three rules in order and return the matching message
    ...
    return None

for g in ["crane", "cat", "cr4ne", "zzzzz"]:
    print(g, "->", validate_guess(g, WORDS))
--- solution
def validate_guess(guess, words):
    """Check a (stripped, lowercase) guess. Return None if it's valid.

    Otherwise return one of these messages, checking the rules in this order:
      "Guesses must be 5 letters."
      "Letters only, please."
      "Not in the word list."
    """
    if len(guess) != 5:
        return "Guesses must be 5 letters."
    if not guess.isalpha():
        return "Letters only, please."
    if guess not in words:
        return "Not in the word list."
    return None

for g in ["crane", "cat", "cr4ne", "zzzzz"]:
    print(g, "->", validate_guess(g, WORDS))
--- test
LEN, ALPHA, LIST = "Guesses must be 5 letters.", "Letters only, please.", "Not in the word list."
got = validate_guess("cat", WORDS)
assert got is not None, "validate_guess('cat', WORDS) returned None, but 'cat' is only 3 letters. Return \"Guesses must be 5 letters.\" for that case."
cases = [("cat", LEN), ("stones", LEN), ("", LEN), ("cr4ne", ALPHA), ("12345", ALPHA), ("cra e", ALPHA), ("zzzzz", LIST), ("hello", LIST)]
for guess, msg in cases:
    got = validate_guess(guess, WORDS)
    assert got == msg, f"validate_guess({guess!r}, WORDS) should return {msg!r}, but returned {got!r}."
for word in ["crane", "tiger", "water"]:
    assert validate_guess(word, WORDS) is None, f"{word!r} is a valid guess, so validate_guess should return None, but returned {validate_guess(word, WORDS)!r}."
assert validate_guess("zzzzz", ["zzzzz"]) is None, "Check the guess against the `words` parameter, not a fixed list."
--- hint
Three `if` statements, one per rule, each returning its message. Because `return` leaves the function, the order you write them in is the order they're checked.
--- hint
Use `len(guess) != 5`, `not guess.isalpha()` and `guess not in words`.
```

## Step 3: score a guess

Now the heart of the game. For each position in the guess:

| Mark | Meaning | Shown as |
|---|---|---|
| `"G"` | right letter, right spot | green |
| `"Y"` | the letter is in the word, but somewhere else | yellow |
| `"-"` | the letter isn't in the word | gray |

Comparing two words position by position is a job for `zip` (lesson 22), which walks both strings in step:

```python run
for g, s in zip("react", "crane"):
    print(g, s, "same spot!" if g == s else ("elsewhere" if g in "crane" else "nowhere"))
```

Start with this straightforward version. Don't worry about repeated letters yet: the next step deals with them.

```python exercise id=score-naive title="Score a guess (first version)"
def score_guess(guess, secret):
    """Return a 5-character string of marks, one per letter of guess:
    "G" = right letter, right spot; "Y" = in the word elsewhere; "-" = not in the word.
    """
    marks = ""
    # TODO: compare guess and secret letter by letter, adding one mark each time
    ...
    return marks

print(score_guess("react", "crane"))   # YYGY-
print(score_guess("crane", "crane"))   # GGGGG
--- solution
def score_guess(guess, secret):
    """Return a 5-character string of marks, one per letter of guess:
    "G" = right letter, right spot; "Y" = in the word elsewhere; "-" = not in the word.
    """
    marks = ""
    for g, s in zip(guess, secret):
        if g == s:
            marks += "G"
        elif g in secret:
            marks += "Y"
        else:
            marks += "-"
    return marks

print(score_guess("react", "crane"))   # YYGY-
print(score_guess("crane", "crane"))   # GGGGG
--- test
r = score_guess("react", "crane")
assert isinstance(r, str), f"`score_guess` should return a string of marks, but returned {r!r}."
assert r != "", "`score_guess` returned an empty string. Add one mark per letter of the guess."
assert len(r) == 5, f"There should be exactly 5 marks, one per letter, but got {r!r}."
assert r == "YYGY-", f"score_guess('react', 'crane') should be 'YYGY-', but got {r!r}."
def _ref(g, s):
    return "".join("G" if a == b else "Y" if a in s else "-" for a, b in zip(g, s))
for g, s in [("crane", "crane"), ("stone", "tiger"), ("ghost", "house"), ("piano", "train"), ("lemon", "mango")]:
    assert score_guess(g, s) == _ref(g, s), f"score_guess({g!r}, {s!r}) should be {_ref(g, s)!r}, but got {score_guess(g, s)!r}."
--- hint
Loop over the two words together with `for g, s in zip(guess, secret):` (or use `range(5)` and index both).
--- hint
Check green first (`g == s`), then yellow (`g in secret`), otherwise gray. Add the mark to `marks` with `+=`.
```

## Step 4: the repeated-letter trap

Your first version is right for words with no repeated letters. Now try one with a doubled letter. The secret below is `lemon`, which has only **one** `e`.

```python predict id=predict-naive-repeat title="One e, two yellows?"
def score_naive(guess, secret):
    marks = ""
    for g, s in zip(guess, secret):
        if g == s:
            marks += "G"
        elif g in secret:
            marks += "Y"
        else:
            marks += "-"
    return marks

print(score_naive("queen", "lemon"))
--- options
* --YYG
--Y-G
--YY-
GGYYG
--- explain
The naive version asks "is this letter anywhere in the secret?" separately for each `e`, so **both** `e`s get yellow. But `lemon` has only one `e`. The real game would mark the second `e` gray: `--Y-G`. That misleads the player into thinking the word has two `e`s.
```

The real rule: **each letter of the secret can only "pay for" one mark.** Greens get paid first, then yellows go out left to right while unclaimed copies remain. A `Counter` (lesson 25) is the perfect ledger for "how many of each letter are still unclaimed":

```python run
from collections import Counter

remaining = Counter("eagle")
print("before:", remaining)
remaining["e"] -= 1          # one e gets claimed
print("after: ", remaining)
print("z count:", remaining["z"])   # missing letters count as 0, no KeyError
```

```text
secret  E A G L E          guess  G E E S E
pass 1: greens   ........E is green (last spot)  → claim one E   ledger: E1 A1 G1 L1
pass 2: yellows  G → yellow (claims G), E → yellow (claims the last E),
                 E → gray (no E left), S → gray                   result: Y Y - - G
```

A teammate wrote the two-pass version below, but players are complaining about phantom yellows.

```python debug id=score-repeats title="Too many yellows for repeated letters"
from collections import Counter

def score_guess(guess, secret):
    """Score a guess, handling repeated letters like the real game."""
    marks = ["-"] * 5
    remaining = Counter(secret)      # unclaimed copies of each letter

    # Pass 1: greens
    for i in range(5):
        if guess[i] == secret[i]:
            marks[i] = "G"

    # Pass 2: yellows, only while unclaimed copies are left
    for i in range(5):
        if marks[i] == "-" and remaining[guess[i]] > 0:
            marks[i] = "Y"
            remaining[guess[i]] -= 1
    return "".join(marks)

print(score_guess("geese", "eagle"))   # should be YY--G
print(score_guess("puppy", "apple"))   # should be Y-G--
--- solution
from collections import Counter

def score_guess(guess, secret):
    """Score a guess, handling repeated letters like the real game."""
    marks = ["-"] * 5
    remaining = Counter(secret)      # unclaimed copies of each letter

    # Pass 1: greens
    for i in range(5):
        if guess[i] == secret[i]:
            marks[i] = "G"
            remaining[guess[i]] -= 1

    # Pass 2: yellows, only while unclaimed copies are left
    for i in range(5):
        if marks[i] == "-" and remaining[guess[i]] > 0:
            marks[i] = "Y"
            remaining[guess[i]] -= 1
    return "".join(marks)

print(score_guess("geese", "eagle"))   # should be YY--G
print(score_guess("puppy", "apple"))   # should be Y-G--
--- test
from collections import Counter as _C
def _ref(g, s):
    m, left = ["-"] * 5, _C(c for c, d in zip(s, g) if c != d)
    for i in range(5):
        if g[i] == s[i]:
            m[i] = "G"
    for i in range(5):
        if m[i] == "-" and left[g[i]] > 0:
            m[i], left[g[i]] = "Y", left[g[i]] - 1
    return "".join(m)
assert score_guess("geese", "eagle") == "YY--G", f"score_guess('geese', 'eagle') should be 'YY--G', but got {score_guess('geese', 'eagle')!r}. The green E already used up one of eagle's two Es."
assert score_guess("puppy", "apple") == "Y-G--", f"score_guess('puppy', 'apple') should be 'Y-G--', but got {score_guess('puppy', 'apple')!r}."
pairs = [("queen", "lemon"), ("speed", "abide"), ("level", "hello"), ("eagle", "eagle"), ("allee", "eagle"), ("crane", "react"), ("mamma", "maxim")]
for g, s in pairs:
    assert score_guess(g, s) == _ref(g, s), f"score_guess({g!r}, {s!r}) should be {_ref(g, s)!r}, but got {score_guess(g, s)!r}."
--- hint
Run it: `geese` against `eagle` gets three yellow-or-green Es, but `eagle` only has two. Which pass forgets to update the ledger?
--- hint
A green also uses up one copy of its letter. In pass 1, after marking a green, take that letter off `remaining`, the same way pass 2 does for yellows.
```

> **In the wild:** this exact repeated-letter bug shipped in several early Wordle clones. Edge cases like doubled letters are where real programs break, which is why professionals write tests for them specifically, just like the hidden tests on these challenges.

## Step 5: show the feedback

Players don't want to read `"YY--G"`. A dictionary that maps each mark to a colored square turns it into the famous grid:

```python run
SYMBOLS = {"G": "🟩", "Y": "🟨", "-": "⬜"}

marks = "YY--G"
print([SYMBOLS[m] for m in marks])
```

```python exercise id=render-row title="Draw the colored row"
SYMBOLS = {"G": "🟩", "Y": "🟨", "-": "⬜"}

def render(guess, marks):
    """Return one line of feedback: the symbol for each mark, two spaces, then the guess in capitals.

    Example: render("crane", "GY--G") returns "🟩🟨⬜⬜🟩  CRANE"
    """
    # TODO: build and return the line (don't print it)
    ...

print(render("crane", "GY--G"))
print(render("geese", "YY--G"))
--- solution
SYMBOLS = {"G": "🟩", "Y": "🟨", "-": "⬜"}

def render(guess, marks):
    """Return one line of feedback: the symbol for each mark, two spaces, then the guess in capitals.

    Example: render("crane", "GY--G") returns "🟩🟨⬜⬜🟩  CRANE"
    """
    squares = "".join(SYMBOLS[m] for m in marks)
    return squares + "  " + guess.upper()

print(render("crane", "GY--G"))
print(render("geese", "YY--G"))
--- test
r = render("crane", "GY--G")
assert r is not None, "`render` returned None. Build the line and `return` it (don't print it)."
assert isinstance(r, str), f"`render` should return a string, but returned {r!r}."
assert r == "🟩🟨⬜⬜🟩  CRANE", f"render('crane', 'GY--G') should be '🟩🟨⬜⬜🟩  CRANE', but got {r!r}."
r2 = render("tiger", "-YG-G")
assert r2 == "⬜🟨🟩⬜🟩  TIGER", f"render('tiger', '-YG-G') should be '⬜🟨🟩⬜🟩  TIGER', but got {r2!r}."
assert render("ghost", "GGGGG") == "🟩" * 5 + "  GHOST", "A perfect guess should render as five green squares, two spaces, then the word in capitals."
--- hint
Look up each mark in `SYMBOLS` and glue the squares together with `"".join(...)`.
--- hint
Then add two spaces and `guess.upper()`: `squares + "  " + guess.upper()`.
```

## Your helpers, packaged as a module

You've now written every helper the game needs. In a real project they'd live in their own file so the main program can import them, and that's what the setup did: it saved finished versions in a module called `wordgame.py` (lesson 25). From here on, challenges import them instead of repeating them.

```python run
import wordgame

print([name for name in dir(wordgame) if not name.startswith("_")])
print(wordgame.render("geese", wordgame.score_guess("geese", "eagle")))
```

## Step 6: the game loop

Now for the part that makes it a *game*: asking the player for guesses, turn after turn.

Because this page can't pause for your keyboard, `input()` here reads answers you queue up with `type_answers(...)`. In a real terminal, Python waits for you to type.

```python run
type_answers("Ada", "7")
name = input("Your name: ")
lucky = int(input("Lucky number: "))
print(f"Hi {name}, double your lucky number is {lucky * 2}.")
```

If the program asks for more answers than you queued, you get an error instead of a frozen page. Run this; it fails on purpose:

```python run error
guess = input("Guess 1/6: ")
```

The `EOFError` ("end of file") is what Python raises in a real terminal too, when input runs out (for example, if you press Ctrl+D). In this lesson it just means "queue more answers with `type_answers` first".

The loop has a few rules that are easy to get subtly wrong, so here they are in plain words:

- A turn counter starts at 1, and the loop runs **while `turn <= max_turns`**.
- An **invalid** guess prints the problem and asks again **without** using up a turn (`continue` before `turn += 1`).
- A **valid** guess prints its colored row. If it's the secret, the player wins: **return the turn number** right away.
- If the loop runs out, the player loses: print the secret and return `None`.

```python exercise id=play-game title="Write the game loop"
from wordgame import validate_guess, score_guess, render   # finished helpers from Steps 2-5

def play_game(secret, words, max_turns=6):
    """Play one round. Return the turn number of a win, or None if every turn is used up.

    - Ask with input(f"Guess {turn}/{max_turns}: "), then strip and lowercase the answer.
    - If validate_guess finds a problem, print it and ask again (no turn used).
    - Otherwise print render(guess, score_guess(guess, secret)).
    """
    turn = 1
    # TODO: loop while turn <= max_turns, following the rules above
    ...
    print("Out of turns! The word was", secret.upper())
    return None

type_answers("stone", "cr4ne", "crane")
print("result:", play_game("crane", WORDS))
--- solution
from wordgame import validate_guess, score_guess, render   # finished helpers from Steps 2-5

def play_game(secret, words, max_turns=6):
    """Play one round. Return the turn number of a win, or None if every turn is used up.

    - Ask with input(f"Guess {turn}/{max_turns}: "), then strip and lowercase the answer.
    - If validate_guess finds a problem, print it and ask again (no turn used).
    - Otherwise print render(guess, score_guess(guess, secret)).
    """
    turn = 1
    while turn <= max_turns:
        guess = input(f"Guess {turn}/{max_turns}: ").strip().lower()
        problem = validate_guess(guess, words)
        if problem:
            print(problem)
            continue
        print(render(guess, score_guess(guess, secret)))
        if guess == secret:
            return turn
        turn += 1
    print("Out of turns! The word was", secret.upper())
    return None

type_answers("stone", "cr4ne", "crane")
print("result:", play_game("crane", WORDS))
--- test
import io, contextlib
def _play(secret, answers, **kw):
    _queued.clear()
    type_answers(*answers)
    buf = io.StringIO()
    try:
        with contextlib.redirect_stdout(buf):
            result = play_game(secret, WORDS, **kw)
    except EOFError:
        raise AssertionError(f"With the answers {answers}, play_game kept asking for more guesses. Does the loop stop (return) when the guess is right?")
    return result, buf.getvalue()
r, out = _play("crane", ["stone", "tiger", "crane"])
assert r == 3, f"The player typed stone, tiger, crane with secret 'crane', so play_game should return 3 (won on turn 3), but returned {r!r}."
assert "STONE" in out and "🟩🟩🟩🟩🟩  CRANE" in out, "Print the rendered row for each valid guess, using render(guess, score_guess(guess, secret))."
r, out = _play("crane", ["cr4ne", "hello", "zzzzz", "crane"])
assert r == 1, f"Invalid guesses shouldn't use up a turn, so winning after three typos is still turn 1, but play_game returned {r!r}."
assert "Letters only, please." in out, "When validate_guess reports a problem, print its message so the player knows what went wrong."
r, out = _play("crane", ["  CRANE "])
assert r == 1, f"'  CRANE ' should count as 'crane' (strip and lowercase the answer), but play_game returned {r!r}."
r, out = _play("tiger", ["crane", "stone", "water", "house", "lemon", "night", "tiger"])
assert r != 7, "The player got a 7th guess! The loop should stop after max_turns valid guesses."
assert r is None, f"After 6 wrong guesses play_game should return None, but returned {r!r}."
assert len(_queued) == 1, "play_game read more guesses than it should have after the 6th miss."
r, out = _play("tiger", ["crane", "stone", "tiger"], max_turns=2)
assert r is None, f"With max_turns=2, two misses should end the game (return None), but play_game returned {r!r}."
_queued.clear()
--- hint
Use `while turn <= max_turns:`. Inside it, read the guess, check it with `validate_guess`, and `continue` if there's a problem.
--- hint
For a valid guess: print the rendered row, `return turn` if `guess == secret`, and otherwise do `turn += 1` at the bottom of the loop.
```

## Step 7: keeping score

Players love their stats: how many games played, how many won, the current winning streak and the best streak ever. A dictionary holds them all, and a function updates it after each game.

Since dictionaries are mutable, a function can **update one in place**: changes made through the parameter are visible to the caller, because both names point to the same dictionary (lesson 14's aliasing, used on purpose this time).

```python run
def add_point(scores, player):
    scores[player] = scores.get(player, 0) + 1   # changes the caller's dict

table = {"Ada": 2}
add_point(table, "Ada")
add_point(table, "Lin")
print(table)
```

```python exercise id=update-stats title="Track wins and streaks"
def new_stats():
    """A fresh stats dictionary for a new player."""
    return {"played": 0, "won": 0, "streak": 0, "best_streak": 0}

def update_stats(stats, result):
    """Update stats IN PLACE after one game.

    result is the winning turn number (1-6), or None for a loss.
    - "played" goes up by 1 after every game
    - a win adds 1 to "won" and to "streak"; "best_streak" keeps the longest streak so far
    - a loss resets "streak" to 0
    """
    # TODO: update the dictionary you were given
    ...

stats = new_stats()
for result in [3, 5, None, 2, 4, 6, None, 1]:
    update_stats(stats, result)
print(stats)
--- solution
def new_stats():
    """A fresh stats dictionary for a new player."""
    return {"played": 0, "won": 0, "streak": 0, "best_streak": 0}

def update_stats(stats, result):
    """Update stats IN PLACE after one game.

    result is the winning turn number (1-6), or None for a loss.
    - "played" goes up by 1 after every game
    - a win adds 1 to "won" and to "streak"; "best_streak" keeps the longest streak so far
    - a loss resets "streak" to 0
    """
    stats["played"] += 1
    if result is None:
        stats["streak"] = 0
    else:
        stats["won"] += 1
        stats["streak"] += 1
        stats["best_streak"] = max(stats["best_streak"], stats["streak"])

stats = new_stats()
for result in [3, 5, None, 2, 4, 6, None, 1]:
    update_stats(stats, result)
print(stats)
--- test
s = new_stats()
update_stats(s, 4)
assert s["played"] == 1, f"After one game, \"played\" should be 1, but it's {s['played']}. Update the dictionary you were given (e.g. stats[\"played\"] += 1)."
assert s["won"] == 1 and s["streak"] == 1, f"After one win, \"won\" and \"streak\" should both be 1, but stats are {s}."
s = new_stats()
for res in [3, 5, None, 2, 4, 6, None, 1]:
    update_stats(s, res)
expected = {"played": 8, "won": 6, "streak": 1, "best_streak": 3}
assert s == expected, f"After the results [3, 5, None, 2, 4, 6, None, 1] the stats should be {expected}, but they are {s}."
s = new_stats()
for res in [None, 1, 1, None]:
    update_stats(s, res)
assert s == {"played": 4, "won": 2, "streak": 0, "best_streak": 2}, f"After [None, 1, 1, None] the stats should be {{'played': 4, 'won': 2, 'streak': 0, 'best_streak': 2}}, but they are {s}."
--- hint
Always do `stats["played"] += 1`. Then branch on whether `result is None` (a loss) or not (a win).
--- hint
On a win, bump `"won"` and `"streak"`, then set `"best_streak"` to `max(...)` of itself and the current streak. On a loss, set `"streak"` back to 0.
```

## Step 8: play again?

The last piece wraps everything in a **session**: pick a secret, play, update the stats, then ask whether to go again. This is the `while True` + `break` pattern from lesson 12: loop forever, and break out when the player says no.

The version below has a bug that makes it rude: it never lets you play a second game, no matter what you answer. (The seed `3` secretly picks `flame` and then `stone`, so the demo answers win both games.)

```python debug id=play-again title="The session quits even when you say yes"
import random
from wordgame import pick_secret, validate_guess, score_guess, render, new_stats, update_stats

def play_game(secret, words, max_turns=6):  # Step 6, finished
    turn = 1
    while turn <= max_turns:
        guess = input(f"Guess {turn}/{max_turns}: ").strip().lower()
        problem = validate_guess(guess, words)
        if problem:
            print(problem)
            continue
        print(render(guess, score_guess(guess, secret)))
        if guess == secret:
            return turn
        turn += 1
    print("Out of turns! The word was", secret.upper())
    return None

def play_session(words, seed):
    """Keep playing games until the player answers n or no. Return the stats."""
    rng = random.Random(seed)
    stats = new_stats()
    while True:
        secret = pick_secret(words, rng)
        update_stats(stats, play_game(secret, words))
        again = input("Play again? (y/n) ").strip().lower()
        if again == "n" or "no":
            break
    return stats

type_answers("flame", "y", "stone", "n")
print(play_session(WORDS, seed=3))
--- solution
import random
from wordgame import pick_secret, validate_guess, score_guess, render, new_stats, update_stats

def play_game(secret, words, max_turns=6):  # Step 6, finished
    turn = 1
    while turn <= max_turns:
        guess = input(f"Guess {turn}/{max_turns}: ").strip().lower()
        problem = validate_guess(guess, words)
        if problem:
            print(problem)
            continue
        print(render(guess, score_guess(guess, secret)))
        if guess == secret:
            return turn
        turn += 1
    print("Out of turns! The word was", secret.upper())
    return None

def play_session(words, seed):
    """Keep playing games until the player answers n or no. Return the stats."""
    rng = random.Random(seed)
    stats = new_stats()
    while True:
        secret = pick_secret(words, rng)
        update_stats(stats, play_game(secret, words))
        again = input("Play again? (y/n) ").strip().lower()
        if again == "n" or again == "no":
            break
    return stats

type_answers("flame", "y", "stone", "n")
print(play_session(WORDS, seed=3))
--- test
import io, contextlib, random as _random
def _session(seed, answers):
    _queued.clear()
    type_answers(*answers)
    try:
        with contextlib.redirect_stdout(io.StringIO()):
            stats = play_session(WORDS, seed=seed)
    except EOFError:
        raise AssertionError(f"With the answers {answers}, play_session kept going after the player said no.")
    return stats
r = _random.Random(11)
s1, s2, s3 = (pick_secret(WORDS, r) for _ in range(3))
st = _session(11, [s1, "y", s2, "YES", s3, "no"])
assert st["played"] == 3, f"The player answered 'y', then 'YES', then 'no', so 3 games should be played, but stats show {st['played']}. Look closely at the `if again ...` condition: what does `or \"no\"` do on its own?"
assert st == {"played": 3, "won": 3, "streak": 3, "best_streak": 3}, f"After winning 3 games the stats should be {{'played': 3, 'won': 3, 'streak': 3, 'best_streak': 3}}, but they are {st}."
r = _random.Random(4)
first = pick_secret(WORDS, r)
st = _session(4, [first, " N "])
assert st["played"] == 1, f"Answering 'N' should stop after one game, but {st['played']} were played."
r = _random.Random(6)
wrong = [w for w in WORDS if w != pick_secret(WORDS, r)][:6]
st = _session(6, wrong + ["n"])
assert st == {"played": 1, "won": 0, "streak": 0, "best_streak": 0}, f"One lost game, then 'n', should give {{'played': 1, 'won': 0, 'streak': 0, 'best_streak': 0}}, but got {st}."
_queued.clear()
--- hint
Run it: you answered `y`, yet only one game was played. Use **Debug** and step onto the `if again ...` line. What is `again` there, and which way does the `if` go?
--- hint
`again == "n" or "no"` means `(again == "n") or ("no")`, and a non-empty string is always truthy (lesson 7). Compare `again` against each answer separately, or check `again in ("n", "no")`.
```

## Play a full session

Here's the finished game, assembled from your pieces. The first cell defines the two loops; the second queues up a player's answers (including a typo) and plays a whole session with seed `5`.

```python run
import random
from wordgame import pick_secret, validate_guess, score_guess, render, new_stats, update_stats

def play_game(secret, words, max_turns=6):
    turn = 1
    while turn <= max_turns:
        guess = input(f"Guess {turn}/{max_turns}: ").strip().lower()
        problem = validate_guess(guess, words)
        if problem:
            print(problem)
            continue
        print(render(guess, score_guess(guess, secret)))
        if guess == secret:
            print(f"Got it in {turn}!")
            return turn
        turn += 1
    print("Out of turns! The word was", secret.upper())
    return None

def play_session(words, seed):
    rng = random.Random(seed)
    stats = new_stats()
    while True:
        update_stats(stats, play_game(pick_secret(words, rng), words))
        if input("Play again? (y/n) ").strip().lower() in ("n", "no"):
            return stats

print("game ready")
```

```python run
type_answers("crane", "tigr", "river", "tiger", "y",
             "house", "ghost", "n")
stats = play_session(WORDS, seed=5)

print()
print(f"Played {stats['played']}, won {stats['won']} ({100 * stats['won'] // stats['played']}%), best streak {stats['best_streak']}")
```

Read the transcript from top to bottom: the typo `tigr` was rejected without costing a turn, each guess got its colored row, and the stats came out right. Try changing the queued answers to lose a game on purpose, or change the seed to get different secrets. In a real terminal, delete the `type_answers` line and the game is genuinely playable.

> **Tip:** Want to play it for real on your own computer? Save the helpers and the two loops in a `.py` file, change `seed=5` to `seed=None` (a `Random(None)` seeds itself from the system, so every session is different), and run it with `python wordgame.py`.

## Recap

- A program is a **pipeline of small functions**: pick, validate, score, render, loop, track. Each was built and tested on its own.
- `random.Random(seed)` gives **reproducible randomness**: perfect for tests, and swappable for true randomness in real play.
- Returning `None` for "OK" and a message for "problem" lets callers write a clean `if problem:`.
- Repeated letters need a **ledger** (a `Counter`) so each secret letter pays for only one mark, greens first.
- Game loops track a counter, `continue` past invalid input without spending a turn, and `return` the moment the game is decided.
- `x == "a" or "b"` is always true: compare against each value, or use `x in ("a", "b")`.

**Up next:** the final project, a budget tracker built with classes, validation and JSON, where everything in this course comes together.
