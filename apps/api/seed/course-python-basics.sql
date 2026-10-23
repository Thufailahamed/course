DELETE FROM exercise_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_python_basics');

DELETE FROM quiz_attempts WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_python_basics');

DELETE FROM notes WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_python_basics');

DELETE FROM lesson_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_python_basics');

DELETE FROM discussions WHERE course_id = 'crs_python_basics';

DELETE FROM certificates WHERE course_id = 'crs_python_basics';

DELETE FROM enrollments WHERE course_id = 'crs_python_basics';

DELETE FROM reviews WHERE course_id = 'crs_python_basics';

DELETE FROM wishlist WHERE course_id = 'crs_python_basics';

DELETE FROM path_courses WHERE course_id = 'crs_python_basics';

DELETE FROM coupons WHERE course_id = 'crs_python_basics';

DELETE FROM lessons WHERE course_id = 'crs_python_basics';

DELETE FROM sections WHERE course_id = 'crs_python_basics';

UPDATE order_items SET course_id = NULL WHERE course_id = 'crs_python_basics';

DELETE FROM courses WHERE id = 'crs_python_basics';

INSERT OR IGNORE INTO categories (id, slug, name, description, icon, sort_order) VALUES ('cat_programming', 'programming', 'Programming', 'Python from first principles: core language, clean code and real projects.', 'code', 9);

INSERT INTO courses (id, slug, title, subtitle, description, category_id, instructor_id, level, language, price_cents, compare_at_price_cents, currency, thumbnail_key, preview_video_url, accent, status, featured, what_you_learn, requirements, target_audience, tags, duration_minutes, lessons_count, rating_avg, rating_count, students_count, published_at, created_at, updated_at) VALUES
('crs_python_basics', 'python-basics', 'Python Basics: The Interactive Course', 'Go from your first line of code to real programs, writing, running and debugging Python right in your browser.', 'Most beginner courses have you watch someone else type. This one puts the keyboard in your hands from the first minute: **every lesson is a live coding environment** with a real Python interpreter running inside your browser.

## Learn by doing, not by watching

- **No videos, no installs.** Read a short explanation, run the code, change it, break it and fix it, right on the page.
- **Over 100 hands-on challenges.** Each one is checked automatically by hidden tests, with progressive hints when you''re stuck.
- **Debug challenges.** Real beginner bugs (off-by-one loops, shared lists, forgotten `return`s) that you track down and fix.
- **A real debugger.** Step through your code line by line, *backwards and forwards*, and watch every variable change.
- **Predict-the-output questions** train you to read code like an expert before you run it.
- **Atlas, your AI tutor,** explains any error in plain language without handing you the answer.

## From zero to real programs

You''ll start with `print("Hello")` and finish by building three complete projects: a **gradebook analyzer** that reads and reports on CSV data, a **word-guessing game** with scoring and replay, and a **budget tracker** built with classes that saves to JSON.

## Built for what comes next

Everything here is the foundation for data science, automation, web development and machine learning. When you''re done, **Python Advanced** picks up exactly where this course ends.', 'cat_programming', 'usr_arjun', 'beginner', 'English', 4900, 9900, 'USD', NULL, NULL, 45, 'published', 1, '["Write clean, working Python programs from a blank page, with no setup or installs","Master variables, strings, numbers, conditions and loops until they feel automatic","Organize data with lists, tuples, dictionaries and sets, and know which one to reach for","Write reusable functions, handle errors gracefully and work with files, CSV and JSON","Read tracebacks and fix bugs with a real step-through debugger instead of guessing","Model real things with classes, and build three complete projects from scratch"]', '["No programming experience at all. We start from the very first line","A modern browser. Python runs inside the page, so there''s nothing to install"]', '["Complete beginners who want to learn to code properly, not just copy snippets","Analysts, marketers and scientists who want to automate their work with Python","Students preparing for data science, machine learning or a CS degree","Developers from other languages who want a fast, thorough tour of Python"]', '["Python","Interactive","Programming","Beginner","Fundamentals"]', 587, 38, 0, 0, 34870, '2025-11-17T16:33:30.916Z', '2025-10-18T16:33:30.916Z', '2026-10-04T16:33:30.916Z');

INSERT INTO sections (id, course_id, title, position, created_at) VALUES
('sec_python_basics_1', 'crs_python_basics', 'Getting Started', 0, '2026-06-24T16:33:30.916Z'),
('sec_python_basics_2', 'crs_python_basics', 'Numbers, Text & Truth', 1, '2026-06-24T16:33:30.916Z'),
('sec_python_basics_3', 'crs_python_basics', 'Decisions & Loops', 2, '2026-06-24T16:33:30.916Z'),
('sec_python_basics_4', 'crs_python_basics', 'Collections', 3, '2026-06-24T16:33:30.916Z'),
('sec_python_basics_5', 'crs_python_basics', 'Functions', 4, '2026-06-24T16:33:30.916Z'),
('sec_python_basics_6', 'crs_python_basics', 'Errors, Files & Modules', 5, '2026-06-24T16:33:30.916Z'),
('sec_python_basics_7', 'crs_python_basics', 'Objects & Classes', 6, '2026-06-24T16:33:30.916Z'),
('sec_python_basics_8', 'crs_python_basics', 'Capstone Projects', 7, '2026-06-24T16:33:30.916Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_python_basics_1_1', 'sec_python_basics_1', 'crs_python_basics', 'How this course works', 'interactive', 0, 480, NULL, NULL, 'Welcome to **Python Basics**. You won''t watch a single video in this course. Instead, every lesson is a live coding environment: you read a little, write a little, run it, and see what happens. That''s how programmers actually learn, and it''s the fastest way to go from "I''ve never coded" to "I can build things."

There''s a real Python interpreter running **inside this page**. Nothing to install, no accounts to set up, no terminal to fight with. This first lesson is a short tour of the tools you''ll use in every lesson after this one. By the end of it you''ll have run code, fixed an error, stepped through a program line by line, and solved your first challenge.

> **How to use this lesson:** read a little, run a little. Every grey box below is code you can edit and run.

## Run your first cell

Click **Run** on the cell below, or click inside it and press **Shift + Enter**.

```python run
print("Hello, world!")
print("I''m running Python inside my browser.")
```

That''s a complete Python program. `print(...)` tells Python to display whatever is inside the parentheses. The text inside the quotes is shown exactly as written.

Now try something: change the message to your own name, and run it again. You can''t break anything. If you make a mess, use the **⋯** menu on the cell and choose **Reset to original**.

## Python shows you the last value

If the **last line** of a cell is a value or a calculation, Python displays it automatically, without `print`. Run this:

```python run
365 * 24
```

That''s how many hours are in a year. Next to the result you''ll see a small grey label, `int`. It tells you what *kind* of value you got. An `int` is a whole number. You''ll meet many kinds soon: `float` for decimals, `str` for text, `list` for collections, and more. Glancing at that label becomes second nature.

## Cells share memory, like a notebook

Values you give a name to in one cell are available in the cells that come after it, as long as you''ve **run** the earlier cell first.

```python run
city = "Lisbon"
temperature = 24
print("Weather report ready for", city)
```

```python run
# Uses `city` and `temperature` from the cell above
print(city, "is", temperature, "degrees today.")
temperature + 5
```

If you see a `NameError` here, it means Python doesn''t know the name yet: run the cell above first. You can also click **Run all** in the bar at the top of the lesson. That bar also has **Restart** (wipe everything and start fresh) and **Variables**, which shows every name currently in memory and its value. Open it now and you''ll find `city` and `temperature`.

## Errors are part of learning

You''re going to see a lot of errors, and that''s completely normal. Professional programmers see errors all day long. The skill isn''t avoiding them; it''s reading them calmly. Run this cell. It fails on purpose:

```python run error
item = "coffee"
price = 3.5

print("A " + item + " costs " + price)
```

Notice three things about the error card:

- **The exact line** that failed is highlighted in red in the editor.
- A **plain-language tip** explains what this kind of error usually means. Here Python is saying it can''t glue text and a number together with `+`.
- **Explain with Atlas** sends your code and the error to your AI tutor, who explains what went wrong without just rewriting your code for you.

Try fixing it: wrap the price in quotes, `price = "3.5"`, and run it again. (You''ll learn the proper way to mix text and numbers in a few lessons.)

## Step through code with the debugger

Reading code is one thing; *watching* it run is another. Click **Debug** on the cell below instead of Run.

```python run
savings = 100
for month in [1, 2, 3, 4]:
    savings = savings + 25
    print("After month", month, "you have", savings)

savings
```

Don''t worry about understanding every line yet. The `for` line repeats the indented lines once per month; you''ll learn exactly how in Section 3. Just watch it happen:

- **Step** (→) moves forward one line, and **←** steps *back* in time.
- The **Variables** table highlights values that just **changed** in amber and values that are **new** in green. Watch `savings` grow.
- Click in the **gutter**, just left of the line numbers, to set a red **breakpoint**, then press **Continue** (F8) to jump straight to it.
- Drag the **timeline** slider to scrub through the whole run.

The debugger is your secret weapon in this course. Whenever code does something you didn''t expect, step through it and the answer is almost always obvious.

## Predict before you run

Good programmers can *predict* what code will do before running it. Predict cells train exactly that skill: pick an answer, and then the code runs to show you the truth.

```python predict id=predict-first title="What does this print?"
print("2 + 3")
--- options
5
* 2 + 3
"2 + 3"
2 3
--- explain
Anything inside quotes is **text**, and Python prints text exactly as written. It doesn''t calculate it. Without the quotes, `print(2 + 3)` would do the math and print `5`.
```

## Challenges: you write the code

Most of your learning happens in **challenges**. Each one has a goal, some starter code, and hidden tests that check your work. Write your solution, then press **Check** (or **Ctrl + Shift + Enter**).

- Starter code uses `...` as a placeholder. Replace it with your own code.
- Stuck? Click **Hint**. Hints are revealed one at a time, from a gentle nudge to an almost-answer.
- Still stuck after a failed check? You can reveal the **reference solution**, but try for a few minutes first. The struggle is where the learning happens.
- Your solved challenges are saved to your account, and **solving every challenge in a lesson completes it automatically.**

```python exercise id=first-greeting title="Your first message"
# Replace the ... with a message in quotes, like "Hi there!"
# The message must include the word Python.
message = ...

print(message)
--- solution
message = "I''m learning Python!"

print(message)
--- test
assert message is not ..., "Replace the `...` after `message =` with some text in quotes."
assert isinstance(message, str), f"`message` should be text in quotes, like \"Hello\", but it''s {message!r}."
assert "python" in message.lower(), f"Your message {message!r} should mention Python somewhere."
assert message in _stdout, "Keep the `print(message)` line so your message is shown."
--- hint
Text in Python goes inside quotes, like `"this"` or `''this''`.
--- hint
Try something like `message = "Python is fun"`.
```

## Debug challenges: find and fix the bug

Some challenges hand you code that''s **almost** right. Your job is to find the bug and fix it. Press **Run** to see the symptom, **Debug** to watch what''s happening, then fix it and press **Check**.

```python debug id=first-bug title="The bill shows the wrong total"
coffee = 3
bagel = 4

total = coffee + coffee
print("Your total is", total)
--- solution
coffee = 3
bagel = 4

total = coffee + bagel
print("Your total is", total)
--- test
assert total != 6, "The total is still 6. Which item was counted twice?"
assert total == 7, f"`total` should be the price of a coffee plus a bagel (7), but it is {total!r}."
assert "7" in _stdout, "Print the total so the customer can see it."
--- hint
Run it. The total is 6, but a coffee (3) and a bagel (4) should cost 7.
--- hint
Look at what''s being added together on the `total = ...` line. Is the bagel in there?
```

## Your toolkit at a glance

| Action | How |
|---|---|
| Run a cell | **Run** or **Shift + Enter** |
| Check a challenge | **Check** or **Ctrl + Shift + Enter** |
| Step through code | **Debug**, then → / ← or F8 |
| Set a breakpoint | Click the gutter left of a line number |
| See all variables | **Variables** in the top bar |
| Start fresh | **Restart** in the top bar |
| Get help | **Hint**, **Explain with Atlas**, or the Q&A tab |
| Autocomplete | Start typing a name and wait a moment |

## How the course is organized

| Section | You''ll learn to… |
|---|---|
| Getting Started | write and run programs, read errors, use variables |
| Numbers, Text & Truth | calculate, work with text, make true/false decisions, talk to users |
| Decisions & Loops | make programs choose and repeat |
| Collections | organize data with lists, tuples, dictionaries and sets |
| Functions | package code into reusable, testable pieces |
| Errors, Files & Modules | handle problems gracefully, save data, use Python''s huge standard library |
| Objects & Classes | design your own data types |
| Capstone Projects | build a gradebook analyzer, a word game and a budget tracker |

Each section ends with a short checkpoint quiz. Lessons take 15 to 25 minutes. A steady pace of one or two lessons a day gets you through the whole course in about a month.

## Recap

- Every lesson runs real Python in your browser. Edit everything; you can always reset.
- The last line of a cell is displayed automatically, with a label showing what kind of value it is.
- Example cells share memory in the order you run them; challenges run on their own.
- Errors come with the failing line, a plain-language tip and an AI explanation.
- The debugger lets you step forwards *and backwards* through any cell.
- Solve every challenge to complete a lesson.

**Up next:** your first real program: printing, comments, and how to read Python''s error messages like a pro.
', 1, '[]', '[{"title":"The official Python tutorial","url":"https://docs.python.org/3/tutorial/index.html"},{"title":"Python built-in functions reference","url":"https://docs.python.org/3/library/functions.html"}]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z'),
('les_python_basics_1_2', 'sec_python_basics_1', 'crs_python_basics', 'Your first program: print, comments and errors', 'interactive', 1, 840, NULL, NULL, 'Every app you''ve ever used, from the calculator on your phone to the software that books flights, is built from the same humble idea: **a list of instructions that a computer follows one at a time.** That list is called a *program*, and by the end of this page you''ll have written several of them.

You''ll learn how to make Python display anything you want with `print()`, how to tell Python "this is text" versus "this is a number to calculate", how to leave notes for yourself with comments, and, maybe most valuable of all, how to read Python''s error messages calmly and fix them in seconds. Professional developers spend a surprising amount of their day reading errors. You''ll start that habit today.

## A program is a recipe

A recipe lists steps in order: preheat the oven, mix the flour, bake for 20 minutes. You don''t bake before you mix. Python works the same way: it reads your program **from the top line to the bottom line**, doing exactly one instruction per line, in order.

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
print(''Your coffee is ready.'')
print("It''s 7:30 and it''s sunny.")
print()
print("(The empty print() above made a blank line.)")
```

Notice the third line: the text contains an apostrophe, so it''s wrapped in *double* quotes. If you used single quotes there, Python would think the string ended at `It''`. Picking the other kind of quote is the easiest fix.

> **Tip:** Choose one style and stick with it. Most Python code uses double quotes `"..."`, switching to single quotes only when the text itself contains a `"`.

### Many things at once

You can give `print` several values, separated by commas. It shows them all on one line with **a single space between each**:

```python run
print("Order", "number", 42)
print("Playlist:", "Bohemian Rhapsody", "-", "Queen")
print("Tickets left:", 3)
```

That last line mixes text and a number in one `print`. The comma does the work of putting a space between them, so you don''t need to add one yourself.

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

Here''s the single most important idea on this page. Quotes change *everything*:

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

Without quotes, Python does arithmetic with the symbols you''d expect, plus `*` for multiply and `/` for divide:

```python run
print("Pizza for 4 people:", 4 * 3, "slices")
print("Cost per person:", 36 / 4)
print("Change from a 50:", 50 - 12 - 18)
print("Hours in a week:", 7 * 24)
```

Python follows the math rules you learned at school: `*` and `/` happen before `+` and `-`, and you can use parentheses to change the order, like `(2 + 3) * 4`. Notice that `36 / 4` printed `9.0`, not `9`. Division always gives a decimal number in Python. You''ll learn why, and much more arithmetic, in lesson 4.

> **Coming from Excel:** there''s no `=` at the start. In a spreadsheet you type `=7*24`; in Python you just write `7 * 24`. The spaces around the operators are optional, but they make code much easier to read.

```python exercise id=minutes-in-week title="Let Python do the math"
# TODO: print exactly this line:
#   Minutes in a week: 10080
# Don''t type 10080 yourself! Let Python calculate it from
# 7 days, 24 hours and 60 minutes, using two values in one print().
print("Minutes in a week:", ...)
--- solution
print("Minutes in a week:", 7 * 24 * 60)
--- test
assert "Ellipsis" not in _stdout, "Replace the `...` with a calculation (no quotes) that multiplies days, hours and minutes."
out = " ".join(_stdout.split())
assert "7 * 24" not in out and "7*24" not in out, "Your calculation is inside quotes, so Python printed it as text. Remove the quotes around the math."
assert out != "Minutes in a week: 168", "That''s the number of HOURS in a week. Multiply by 60 as well to get minutes."
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
assert out != "09:30:15:", "There''s an extra `:` at the end. You only need to change the separator."
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

The third line didn''t run because it starts with `#`. Putting `#` in front of a line to temporarily switch it off is called **commenting it out**, and it''s a quick way to test what happens without a line, without deleting it.

> **Tip:** good comments explain **why**, not what. `# add tax` above `print(price * 1.2)` is fine, but `# UK VAT is 20%` is better: the code already says *what*, the comment tells you *why*.

> **In the wild:** professional teams leave `# TODO:` comments to mark unfinished work, and many code editors list every `TODO` in a project for you. You''ll see them in this course''s starter code too.

## Reading error messages

Sooner or later (usually sooner) Python will refuse to run your code and show you an **error**. This isn''t Python being difficult. An error message is Python telling you *exactly* what confused it and *where*. Learning to read one is a superpower.

### SyntaxError: Python can''t understand the code

*Syntax* means grammar. A `SyntaxError` means the code isn''t valid Python, like a sentence missing its full stop. Here a closing quote is missing:

```python run error
print("Welcome to the shop!")
print("Today''s special: pancakes)
print("Open until 6pm")
```

Notice that **nothing printed**, not even the welcome line, even though line 1 is perfectly fine. Python checks the grammar of the *whole* cell before running any of it. If the grammar is broken anywhere, nothing runs. The message *"unterminated string literal"* means "a piece of text was started with a quote but never closed".

The other classic SyntaxError is a missing parenthesis:

```python run error
print("Total:", 12 + 8
```

*"''('' was never closed"* is Python telling you it saw an opening `(` and reached the end of the code without finding the matching `)`. Every `(` needs a `)`, and every opening quote needs a closing quote.

### NameError: Python doesn''t know that word

A `NameError` means you used a name Python has never heard of. Almost always, it''s a typo:

```python run error
print("Step 1: Preheat the oven.")
print("Step 2: Mix the ingredients.")
prnt("Step 3: Bake for 20 minutes.")
print("Step 4: Enjoy!")
```

This time the first two lines **did** print. The grammar was fine (`prnt(...)` *looks* like a valid instruction), so Python started running. It only got stuck when it reached line 3 and found that no such thing as `prnt` exists, and it stopped right there. Line 4 never ran. Open the full traceback and you''ll see Python even guesses what you meant: *"Did you mean: ''print''?"*

| Error | What it means | When it''s caught | Did anything run? |
|---|---|---|---|
| `SyntaxError` | the code isn''t valid Python grammar | before running anything | no, nothing |
| `NameError` | a name Python doesn''t know (often a typo) | when Python reaches that line | yes, every line before it |

### How to read a traceback

The full error report is called a **traceback**. It looks intimidating, but you read it **from the bottom up**:

```text
Traceback (most recent call last):
  File "<cell>", line 3, in <module>          ← 3. WHERE: line 3
    prnt("Step 3: Bake for 20 minutes.")      ← 2. the exact code
    ^^^^                                      ←    pointing at the problem
NameError: name ''prnt'' is not defined. Did you mean: ''print''?
                                              ← 1. START HERE: what went wrong
```

1. **The last line** names the error type (`NameError`) and gives a description. Read this first.
2. **Just above it** is the line of code that failed, often with `^^^` marks under the exact spot.
3. **The line number** tells you where to look in your code.

In this course the failing line is also highlighted in red for you, and **Explain with Atlas** will talk you through any error you don''t understand.

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
assert lines == ["Packing list for the beach:", "- sunscreen", "- towel", "- sunglasses", "- a good book"], "Keep every item''s text exactly as it was, in the same order."
--- hint
Run it. The first three lines print and then a `NameError` appears. Read its last line: which name doesn''t exist?
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
', 1, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z'),
('les_python_basics_1_3', 'sec_python_basics_1', 'crs_python_basics', 'Variables: giving names to values', 'interactive', 2, 960, NULL, NULL, 'Imagine a shopping app that writes the price of a coffee, `3.5`, in forty different places. The day the price changes, someone has to find and fix all forty, and miss none. Real programs avoid this by giving values **names**: write `coffee_price = 3.5` once, then use `coffee_price` everywhere. Change it in one place and the whole program follows.

Those names are called **variables**, and they''re how a program remembers things: a score that goes up, a bank balance that changes, the name a user typed in. By the end of this page you''ll be able to create and update variables, name them like a professional, swap two values in one line, and peek at what *kind* of value a variable holds.

## A variable is a name tag on a value

Write a name, an equals sign, and a value:

```python run
city = "Barcelona"
temperature = 26
print(city)
print(temperature)
```

The line `temperature = 26` is called an **assignment**. Read it right to left: *"take the value 26 and stick the name tag `temperature` on it."* From then on, whenever Python sees `temperature`, it uses 26.

```text
  name tag            value
┌─────────────┐
│ city        │ ───▶  "Barcelona"
└─────────────┘
┌─────────────┐
│ temperature │ ───▶  26
└─────────────┘
```

> **Pitfall:** In Python, `=` does **not** mean "is equal to" like in maths. It''s an instruction: *"make this name refer to this value."* That''s why `26 = temperature` is a `SyntaxError`: `26` isn''t a name, so there''s nothing to attach a tag to. The name always goes on the left, the value on the right.

## Using variables in calculations

Once a value has a name, you can use the name anywhere you''d use the value itself, including inside calculations and other assignments:

```python run
coffee_price = 3.5
croissant_price = 2.25
coffees = 2

order_total = coffee_price * coffees + croissant_price
print("Order total:", order_total)
```

Python works out the right-hand side first (`3.5 * 2 + 2.25`), gets `9.25`, and then sticks the name `order_total` on the result. Change `coffees` to `3` and run again: the total follows automatically. That''s the whole point.

Names make code **read like a sentence**. Compare `print(3.5 * 2 + 2.25)` with `print(coffee_price * coffees + croissant_price)`. Same result, but only one of them tells you what''s going on.

```python exercise id=road-trip title="Plan the road trip"
distance_km = 450
litres_per_100km = 8
price_per_litre = 1.5

# TODO: using the three variables above (not the numbers!), define:
#   litres_needed: how many litres of fuel the whole trip uses
#   fuel_cost:     how much that fuel costs in total
litres_needed = ...
fuel_cost = ...

print("Litres needed:", litres_needed)
print("Fuel cost:", fuel_cost)
--- solution
distance_km = 450
litres_per_100km = 8
price_per_litre = 1.5

litres_needed = distance_km / 100 * litres_per_100km
fuel_cost = litres_needed * price_per_litre

print("Litres needed:", litres_needed)
print("Fuel cost:", fuel_cost)
--- test
assert litres_needed is not ..., "Replace the `...` after `litres_needed =` with a calculation using the variables above."
assert fuel_cost is not ..., "Replace the `...` after `fuel_cost =` with a calculation."
expected_litres = distance_km / 100 * litres_per_100km
assert litres_needed != distance_km * litres_per_100km, f"`litres_needed` is {litres_needed}, which is far too much. The car uses {litres_per_100km} litres per **100** km, so divide the distance by 100."
assert abs(litres_needed - expected_litres) < 1e-9, f"`litres_needed` should be {expected_litres} for this trip, but it is {litres_needed}."
assert abs(fuel_cost - expected_litres * price_per_litre) < 1e-9, f"`fuel_cost` should be the litres needed times the price per litre ({expected_litres * price_per_litre}), but it is {fuel_cost}."
--- hint
The car uses 8 litres for every 100 km. How many "hundreds of km" is the trip?
--- hint
`litres_needed` is the distance divided by 100, times the litres per 100 km. Then `fuel_cost` can use `litres_needed` itself.
```

## Reassigning: moving the name tag

A variable can be given a new value at any time. The old value isn''t changed; the **name tag simply moves** to the new value:

```python run
mood = "sleepy"
print("Morning:", mood)

mood = "energised"
print("After coffee:", mood)
```

This is why they''re called *variables*: what they refer to can vary. Every assignment says "from now on, this name means this value", and that holds until the next assignment to the same name.

```python predict id=predict-copy-tag title="Does b follow a?"
a = 5
b = a
a = 10
print(a, b)
--- options
10 10
* 10 5
5 5
5 10
--- explain
`b = a` puts the name `b` on the value `a` refers to **right now**, which is 5. It doesn''t link `b` to `a` forever. When `a` is later moved to 10, `b` is still on 5. Assignment copies the *current* value''s tag, not a permanent connection.
```

## Updating a variable: `x = x + 1`

Here''s a line that would make a maths teacher wince:

```python run
score = 0
score = score + 10
score = score + 25
print("Score:", score)
```

It makes perfect sense once you remember that `=` means "assign" and the right side runs first. `score = score + 10` means: *take the current value of `score`, add 10, then move the `score` tag onto the result.* Step through it with **Debug** and watch `score` change from 0 to 10 to 35.

Updating a variable is so common that Python has shortcuts for it, called **augmented assignment**:

| Shortcut | Means | Example: `balance` starts at 100 |
|---|---|---|
| `x += 5` | `x = x + 5` | `balance += 50` → 150 |
| `x -= 5` | `x = x - 5` | `balance -= 30` → 70 |
| `x *= 2` | `x = x * 2` | `balance *= 2` → 200 |
| `x /= 2` | `x = x / 2` | `balance /= 4` → 25.0 |

```python run
balance = 100
balance += 50     # payday
balance -= 30     # groceries
balance -= 12.5   # cinema ticket
print("Balance:", balance)
```

You can only update a variable that already exists. Python has to know the current value before it can add to it:

```python run error
coins += 10
```

The `NameError` says `coins` isn''t defined. `coins += 10` means `coins = coins + 10`, and the right side can''t be worked out because `coins` has no value yet. The fix is to create it first, for example `coins = 0`, before any updates.

```python predict id=predict-augmented title="Follow the score"
points = 10
points += 5
points *= 2
points -= 1
points
--- options
14
* 29
19
30
--- explain
Take it one line at a time: 10, then `+= 5` gives 15, then `*= 2` doubles it to 30, then `-= 1` gives 29. Each update uses the value left by the line before it.
```

```python exercise id=step-counter title="Count your steps"
steps = 0

# TODO: update `steps` for each walk using +=, one line per walk:
#   morning walk: 3200 steps
#   lunch walk:   1500 steps
#   evening run:  4800 steps
...

print("Total steps today:", steps)
--- solution
steps = 0

steps += 3200
steps += 1500
steps += 4800

print("Total steps today:", steps)
--- test
assert steps != 0, "`steps` is still 0. Add each walk to it with `steps += ...`."
assert isinstance(steps, int), f"`steps` should be a whole number, but it is {steps!r}."
assert steps not in (3200, 1500, 4800), f"`steps` is {steps}, just one walk. Did you use `=` instead of `+=`, replacing the total instead of adding to it?"
assert steps == 3200 + 1500 + 4800, f"`steps` should be the total of all three walks, but it is {steps}."
assert "Total steps today:" in _stdout, "Keep the final `print` line so the total is shown."
--- hint
`steps += 3200` means "add 3200 to whatever `steps` currently is."
--- hint
Replace the `...` with three lines, each one `steps += <number of steps>`.
```

## Debug challenge: the order of updates matters

Because Python runs top to bottom, a calculation uses the values variables have **at that moment**. Change a variable later, and earlier results don''t update themselves.

```python debug id=early-bird title="The discount isn''t in the total"
ticket_price = 40
tickets = 3

total = ticket_price * tickets
ticket_price -= 10    # early-bird discount

print("Price per ticket:", ticket_price)
print("Total to pay:", total)
--- solution
ticket_price = 40
tickets = 3

ticket_price -= 10    # early-bird discount
total = ticket_price * tickets

print("Price per ticket:", ticket_price)
print("Total to pay:", total)
--- test
assert ticket_price == 30, f"`ticket_price` should be 30 after the early-bird discount, but it is {ticket_price}."
assert total != 120, "The total is still 120, the price *before* the discount. When was `total` calculated?"
assert total == ticket_price * tickets, f"`total` ({total}) should equal the discounted price times the number of tickets ({ticket_price * tickets})."
--- hint
Run it. Each ticket costs 30, and there are 3 tickets, but the total says 120. Which price was used to compute the total?
--- hint
`total` is calculated once, on the line where it''s assigned. It doesn''t recalculate when `ticket_price` changes later. Reorder two lines.
```

## Naming variables well

Python has a few hard **rules** for names, and the community has strong **conventions** on top.

**The rules** (break them and you get a `SyntaxError`):

- Use letters, digits and underscores `_` only. No spaces, dashes or symbols.
- Don''t start with a digit: `player2` is fine, `2player` isn''t.
- Don''t use Python''s **reserved words** (keywords), like `if`, `for`, `class`, `True`, `None` or `def`. They already mean something.

```python run error
2nd_place = "Ana"
```

*"invalid decimal literal"* is Python''s way of saying "this starts like a number, but then it has letters in it". Names can''t start with a digit.

**The conventions** (Python won''t complain, but other programmers will):

| Name | Verdict | Why |
|---|---|---|
| `total_price` | great | lowercase words joined by underscores: **snake_case** |
| `x`, `tp` | poor | short names hide meaning (fine for tiny maths) |
| `TotalPrice` | unusual | this style is reserved for *classes* (lesson 26) |
| `total price` | invalid | spaces aren''t allowed |
| `total-price` | invalid | Python reads `-` as minus |
| `class` | invalid | a reserved word |

Names are also **case-sensitive**. `Score` and `score` are two completely separate variables:

```python run
score = 10
Score = 99
print("score:", score, "| Score:", Score)
```

> **In the wild:** professional Python follows **PEP 8**, the official style guide, which asks for `snake_case` names. Tools like Ruff and Black check and fix this automatically in most companies'' code. A good name saves a reader from needing a comment: `seconds_until_launch` explains itself; `s` doesn''t.

```python debug id=checkout-typo title="The checkout crashes before the total"
item_price = 12
quantity = 3

sub_total = item_price * quantity
tax = subtotal * 0.25
total = sub_total + tax

print("Total to pay:", total)
--- solution
item_price = 12
quantity = 3

sub_total = item_price * quantity
tax = sub_total * 0.25
total = sub_total + tax

print("Total to pay:", total)
--- test
assert tax == item_price * quantity * 0.25, f"`tax` should be 25% of the subtotal, but it is {tax}."
assert total == item_price * quantity * 1.25, f"`total` should be the subtotal plus tax ({item_price * quantity * 1.25}), but it is {total}."
assert "Total to pay:" in _stdout, "Keep the `print` line so the customer sees the total."
--- hint
Run it and read the last line of the error. Which name does Python say is not defined?
--- hint
Compare the name used on the `tax = ...` line with the name created on the line above it, character by character.
```

## Multiple assignment and swapping

You can assign several variables in one line by separating names and values with commas. The first name gets the first value, and so on:

```python run
home, away = 3, 1
print("Final score:", home, "-", away)
```

This makes one classic task beautifully easy: **swapping** two values. Here''s the trap first. Try to predict it:

```python predict id=predict-naive-swap title="A swap that goes wrong"
left = "Hey Jude"
right = "Yesterday"
left = right
right = left
print(left, "|", right)
--- options
Yesterday | Hey Jude
* Yesterday | Yesterday
Hey Jude | Hey Jude
Hey Jude | Yesterday
--- explain
After `left = right`, *both* names are on `"Yesterday"`, and nothing refers to `"Hey Jude"` any more. So `right = left` just puts `right` on `"Yesterday"` again. The original value of `left` was lost before it could be copied.
```

Python''s multiple assignment solves this. It works out **every value on the right first**, then assigns them all at once, so nothing gets overwritten too early:

```python run
left = "Hey Jude"
right = "Yesterday"
left, right = right, left
print(left, "|", right)
```

> **Coming from another language:** in many languages a swap needs a temporary variable (`temp = a; a = b; b = temp`). That works in Python too, but `a, b = b, a` is the Pythonic way.

```python exercise id=podium-swap title="Fix the podium"
# The judges made a mistake: the gold and silver medallists
# should be the other way round.
gold = "Mei"
silver = "Ravi"
bronze = "Lucia"

# TODO: swap the values of `gold` and `silver` using ONE line
# of multiple assignment. Leave `bronze` alone.
...

print("Gold:", gold, "| Silver:", silver, "| Bronze:", bronze)
--- solution
gold = "Mei"
silver = "Ravi"
bronze = "Lucia"

gold, silver = silver, gold

print("Gold:", gold, "| Silver:", silver, "| Bronze:", bronze)
--- test
assert not (gold == "Mei" and silver == "Ravi"), "Gold and silver haven''t been swapped yet. Replace the `...` with your swap."
assert gold != silver, f"`gold` and `silver` are both {gold!r}. One value was overwritten before it was copied. Try swapping both at once with commas."
assert gold == "Ravi" and silver == "Mei", f"After the swap, `gold` should be ''Ravi'' and `silver` should be ''Mei'', but they are {gold!r} and {silver!r}."
assert bronze == "Lucia", f"`bronze` should still be ''Lucia'', but it is {bronze!r}."
--- hint
Look at the swap example just above this challenge: names on the left, values on the right, separated by commas.
--- hint
The pattern is `first, second = second, first`, using `gold` and `silver`.
```

## What kind of value is it? A peek at `type()`

Every value in Python has a **type**, its kind. You''ve already seen the little type chip next to cell results. You can ask for it directly with `type()`:

```python run
print(type(26))
print(type(26.5))
print(type("Barcelona"))
type(True)
```

| Type | Short for | Examples |
|---|---|---|
| `int` | integer, a whole number | `26`, `-3`, `1000000` |
| `float` | floating-point, a number with a decimal point | `26.5`, `0.1`, `3.0` |
| `str` | string, a piece of text | `"Barcelona"`, `''26''` |
| `bool` | Boolean, true or false | `True`, `False` |

Notice that `"26"` in quotes would be a `str`, not an `int`: quotes always make text. You''ll study numbers in the next lesson, text in lesson 5, and `True`/`False` in lesson 7.

### A name can switch types

Python doesn''t fix a variable to one type. A name is just a tag, and you can move it onto any kind of value. This is called **dynamic typing**:

```python run
answer = 42
print(answer, "is a", type(answer))

answer = "forty-two"
print(answer, "is a", type(answer))
```

That''s flexible, but use it with care: a variable called `price` that''s sometimes a number and sometimes text is a bug waiting to happen. Good practice is to keep each name holding one kind of thing.

> **Coming from another language:** there are no declarations like `int x;` in Python. A variable comes into existence the first time you assign to it.

## Recap

- A **variable** is a name tag on a value: `price = 3.5`. The right side is worked out first, then the name is attached.
- Reassigning moves the tag; `b = a` copies the *current* value, not a permanent link.
- Update with `x = x + 1` or the shortcuts `+=`, `-=`, `*=`, `/=`. The variable must already exist.
- Calculations use values **as they are at that moment**, so the order of lines matters.
- Name things in descriptive `snake_case`; no leading digits, spaces or reserved words, and remember names are case-sensitive.
- `a, b = 1, 2` assigns several names at once, and `a, b = b, a` swaps. `type()` tells you a value''s kind: `int`, `float`, `str`.

**Up next:** numbers and arithmetic: whole numbers vs decimals, the operators `//`, `%` and `**`, and why `0.1 + 0.2` isn''t quite `0.3`.
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z'),
('les_python_basics_1_4', 'sec_python_basics_1', 'crs_python_basics', 'Checkpoint: getting started', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"In this course, what happens when the **last line** of a cell is a value or calculation, like `365 * 24`?","options":["Nothing, because you must always use `print()` to see a result","Python shows the value automatically, with a small label showing its type","Python raises an error because the value isn''t stored anywhere","The value is saved to a file"],"answerIndex":1,"explanation":"A cell displays the value of its last line automatically, along with a type chip such as `int`. Any earlier lines only show output if they call `print()`."},{"id":"q2","prompt":"What does `print(\"7 * 6\")` display?","options":["42","\"7 * 6\"","7 6","7 * 6"],"answerIndex":3,"explanation":"Anything in quotes is text, and Python prints text exactly as written, without the quotes. To calculate, leave out the quotes: `print(7 * 6)` shows `42`."},{"id":"q3","prompt":"What does `print(\"Total:\", 4 + 6, sep=\"\")` display?","options":["Total:10","Total: 10","Total: 4 + 6","Total:4+6"],"answerIndex":0,"explanation":"The calculation `4 + 6` becomes `10`, and `sep=\"\"` replaces the usual space between values with nothing, so the two pieces are joined directly: `Total:10`."},{"id":"q4","prompt":"A cell contains three `print` lines. Line 2 is missing its closing parenthesis. What do you see when you run it?","options":["Line 1 prints, then a SyntaxError appears","Lines 1 and 3 print, and line 2 is skipped","Nothing prints at all; only a SyntaxError appears","All three lines print, with a warning about line 2"],"answerIndex":2,"explanation":"Python checks the grammar of the whole cell before running anything. A SyntaxError anywhere means no line runs, not even the correct ones before it."},{"id":"q5","prompt":"You see `NameError: name ''totl'' is not defined` on line 5. What is the most likely cause?","options":["Line 5 is missing a closing quote","You divided by zero on line 5","Python has run out of memory","A typo: you probably meant a variable such as `total`, or `totl` was never assigned"],"answerIndex":3,"explanation":"A NameError means Python reached a name it doesn''t know. It''s almost always a typo, a capitalization difference, or using a variable before assigning it. Every line before line 5 has already run."},{"id":"q6","prompt":"What does this print? `a = 4; b = a; a = a + 1; print(a, b)`","options":["5 5","5 4","4 4","4 5"],"answerIndex":1,"explanation":"`b = a` puts the name `b` on the value `a` has *at that moment* (4). Moving `a` to 5 afterwards doesn''t affect `b`. Assignment never creates a permanent link between two names."},{"id":"q7","prompt":"`lives` starts at 3. Which line correctly takes one life away?","options":["`lives - 1`","`lives = - 1`","`lives -= 1`","`lives - 1 = lives`"],"answerIndex":2,"explanation":"`lives -= 1` is short for `lives = lives - 1`. On its own, `lives - 1` calculates 2 but doesn''t store it, `lives = - 1` sets `lives` to negative one, and `lives - 1 = lives` is a SyntaxError because the name must be on the left of `=`."},{"id":"q8","prompt":"Which of these is a valid **and** well-styled Python variable name?","options":["`high_score`","`high-score`","`2nd_score`","`class`"],"answerIndex":0,"explanation":"`high_score` follows the snake_case convention. `high-score` is read as a subtraction, `2nd_score` starts with a digit, and `class` is a reserved word, so all three are SyntaxErrors when you assign to them."},{"id":"q9","prompt":"`x = \"cat\"` and `y = \"dog\"`. Which line swaps them so that `x` is `\"dog\"` and `y` is `\"cat\"`?","options":["`x = y` then `y = x` on the next line","`x, y = y, x`","`x == y`","`x, y = x, y`"],"answerIndex":1,"explanation":"Multiple assignment works out all the values on the right first, then assigns them, so `x, y = y, x` swaps cleanly. Two separate lines would lose the original `x` before it''s copied, leaving both names on `\"dog\"`."},{"id":"q10","prompt":"After running `price = 19.99` and then `price = \"sold out\"`, what does `type(price)` give?","options":["`<class ''float''>`, because a variable keeps its first type","An error: a variable can''t change type","`<class ''str''>`","`<class ''int''>`"],"answerIndex":2,"explanation":"Python is dynamically typed: a name is just a tag that can be moved onto any value. After the second assignment, `price` refers to a string, so its type is `str`."}]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z'),
('les_python_basics_2_1', 'sec_python_basics_2', 'crs_python_basics', 'Numbers and arithmetic', 'interactive', 0, 960, NULL, NULL, 'Almost every program does arithmetic somewhere: a shopping cart adds up prices, a fitness app turns seconds into minutes, a game wraps a character around the edge of the screen, a bank applies interest. Python is a superb calculator, but it has a few rules that surprise beginners, like why `7 / 2` and `7 // 2` give different answers, or why `0.1 + 0.2` isn''t *quite* `0.3`.

By the end of this page you''ll know Python''s two kinds of numbers, all seven arithmetic operators (including the two secret weapons `//` and `%`), the order Python calculates in, how to round and compare numbers cleanly, and how to reach for the `math` module when you need square roots or rounding up.

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

> **Coming from Excel:** the power operator is `**`, not `^`. In Python `^` means something completely different (a bitwise operation you''ll rarely need), so `2 ^ 3` gives `1`, not `8`. Always write `2 ** 3`.

### `/` always gives a float

Regular division `/` **always** returns a `float`, even when the answer is a whole number. That''s a deliberate choice: the result type is predictable no matter what numbers go in.

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
- `a % b`: *what''s **left over** afterwards?*

Think of packing eggs into boxes of 12. With 30 eggs, `30 // 12` is `2` full boxes and `30 % 12` is `6` eggs left over. The classic use is splitting units, like turning a number of minutes into hours and minutes:

```python run
total_minutes = 135

hours = total_minutes // 60      # how many whole hours fit?
minutes = total_minutes % 60     # what''s left over?
print(total_minutes, "minutes is", hours, "h", minutes, "min")
```

Modulo has two more superpowers. `n % 2` is `0` for even numbers and `1` for odd ones, and `%` makes numbers **wrap around**, like the hands of a clock:

```python run
print("17 % 2 =", 17 % 2, "(odd)")
print("24 % 2 =", 24 % 2, "(even)")

now = 22                       # 10 pm on a 24-hour clock
flight_hours = 5
print("You land at", (now + flight_hours) % 24, "o''clock")
```

`22 + 5` is `27`, which isn''t a time. `27 % 24` wraps it back to `3`: 3 am. Any time something cycles (hours, days of the week, positions on a circular board game), `%` keeps the number in range.

```python exercise id=running-time title="Format a movie''s running time"
movie_minutes = 148

# TODO: split movie_minutes into whole hours and the minutes left over.
# Use // and %, and calculate from movie_minutes (don''t type the answers).
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
There are 60 minutes in an hour. `//` tells you how many whole hours fit; `%` gives what''s left.
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
assert future_day != today + days_ahead, f"{future_day} isn''t a day of the week. The days repeat every 7, so the number needs to wrap around."
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
The exponent goes first: `4 ** 2` is `16`. Then multiplication: `3 * 16` is `48`. Addition comes last: `2 + 48` is `50`. If you wanted a different order, you''d need parentheses, like `(2 + 3) * 4` for `20`.
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
Run it. An average can never be bigger than both numbers, so something''s off with the order of operations.
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

Read it from the bottom: `ZeroDivisionError: division by zero`. The `~~~^~~~` marks under the line point at the exact `/` that failed. This often happens with real data, like a new player who hasn''t played any games yet. In lesson 9 you''ll learn to check for zero first with `if`, and in lesson 23 to catch the error.

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
Python rounds exact halves to the nearest **even** number ("banker''s rounding"), so `2.5` becomes `2` and `3.5` becomes `4`. It avoids a bias: always rounding halves up would nudge totals upwards over thousands of values. Most of the time you won''t notice, but now you won''t be surprised either.
```

```python exercise id=weather-stats title="Weekly weather report"
mon, tue, wed, thu = 18.4, 22.7, 15.9, 21.3   # daily highs in degrees C

# TODO: define these four variables from mon, tue, wed and thu:
#   highest: the warmest day''s temperature
#   lowest:  the coldest day''s temperature
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
assert abs(average - _avg) > 1e-9 or round(_avg, 1) == _avg, f"`average` is {average}, which isn''t rounded yet. Use `round(..., 1)`."
assert abs(average - round(_avg, 1)) < 1e-9, f"`average` should be the mean of the four days rounded to 1 place ({round(_avg, 1)}), but it is {average}. Check your parentheses."
--- hint
`max()` and `min()` accept any number of values separated by commas.
--- hint
`round(value, 1)` rounds to one decimal place. For the average, add all four days inside parentheses before dividing by 4.
```

## Why `0.1 + 0.2` isn''t `0.3`

Here''s a famous surprise:

```python run
print(0.1 + 0.2)
print(1.1 + 2.2)
print("Rounded for display:", round(0.1 + 0.2, 2))
```

Python isn''t broken; every programming language does this. Computers store floats in **binary** (base 2), and most decimal fractions, like `0.1`, can''t be written exactly in binary. It''s the same reason you can''t write 1/3 exactly in decimal: `0.3333...` goes on forever and has to be cut off somewhere. Those tiny cut-off errors occasionally show up in the 17th digit.

What this means for you:

- For **display**, round: `round(total, 2)`. (Lesson 6 shows an even neater way.)
- Don''t expect two float calculations to be *exactly* equal. Compare them with a small tolerance instead; you''ll see how in lesson 7.

> **In the wild:** payment systems like Stripe store money as whole numbers of **cents** (`1999` instead of `19.99`), because `int`s are always exact. Python also has a `decimal` module for exact decimal arithmetic in finance code.

## Big numbers and readable numbers

Unlike floats, Python''s `int`s are **exact and unlimited**. They can be as big as your computer''s memory allows, and you''ll never lose a digit. To make long numbers readable, you can put underscores in them, the way you''d use commas on paper:

```python run
world_population = 8_100_000_000
print("People:", world_population)
print("Grains of rice on the 64th chess square:", 2 ** 63)
print("Exact:", 2 ** 100)
```

The underscores are just for humans. Python ignores them, so `8_100_000_000` and `8100000000` are the same number.

## The `math` module

For anything beyond basic arithmetic, Python has a **module** (a toolbox of extra functions) called `math`. You load it once with `import math`, then use its tools by writing `math.` followed by the name. You''ll learn all about modules in lesson 25.

```python run
import math

print("Square root of 144:", math.sqrt(144))
print("Pi:", math.pi)
print("Area of a 10 cm radius pizza:", round(math.pi * 10 ** 2, 1))
print("floor(4.9):", math.floor(4.9), "| ceil(4.1):", math.ceil(4.1))
```

`math.floor` always rounds **down** and `math.ceil` (short for *ceiling*) always rounds **up**, whatever the decimal. That''s different from `round`, which goes to the *nearest* whole number. Rounding up is exactly what you need when "a bit extra" still needs a whole extra thing, like a box, a bus or a page.

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
assert boxes_needed != _exact, f"You can''t buy {boxes_needed} boxes. Round to a whole number of boxes."
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
assert full_teams != players / team_size, f"`full_teams` is {full_teams}. You can''t field half a team. Only count the teams that are complete."
assert isinstance(full_teams, int), f"`full_teams` should be a whole number (int), but it is {full_teams!r}."
assert full_teams == players // team_size, f"`full_teams` should be {players // team_size}, but it is {full_teams}."
assert on_the_bench == players % team_size, f"{on_the_bench} players on the bench doesn''t look right; it should be the players left over after forming full teams."
--- hint
Run it: 7.5 teams and 0.0 players on the bench. Which operator gave a fraction of a team?
--- hint
You want "how many whole times does 4 fit into 30". That''s a different division operator.
```

## Recap

- Python has two number types: **`int`** for whole numbers and **`float`** for decimals. Mixing them gives a `float`.
- `/` always returns a `float`. `//` divides and rounds down; `%` gives the remainder. Together they split units, test even/odd and wrap values around.
- `**` is the exponent. Order of operations: parentheses, `**`, then `* / // %`, then `+ -`. When in doubt, use parentheses.
- `round()`, `abs()`, `min()` and `max()` are built in. `round` sends exact halves to the even number.
- Floats can be slightly imprecise (`0.1 + 0.2`), so round for display. `int`s are exact at any size, and `1_000_000` is a readable way to write big ones.
- `import math` gives you `math.sqrt`, `math.pi`, `math.floor` (round down) and `math.ceil` (round up).

**Up next:** strings: working with text, from quotes and special characters to picking out letters with indexing and slicing.
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_python_basics_2_2', 'sec_python_basics_2', 'crs_python_basics', 'Strings: text, indexing and slicing', 'interactive', 1, 1080, NULL, NULL, 'Most of the data in the world is text: names, addresses, emails, product codes, song titles, messages. Before a program can tidy up a customer''s name, pull the year out of a date, or check whether an email contains an `@`, it needs to take text apart and put it back together.

In Python, text is a **string**: a sequence of characters, one after another, like beads on a thread. By the end of this page you''ll be able to write any text (including quotes and line breaks), glue strings together, measure them, grab any single character, cut out any piece with slicing, and even reverse a string in a few keystrokes.

## Three ways to quote

You already know strings go in quotes. Single and double quotes behave exactly the same, so pick whichever one *isn''t* inside your text:

```python run
band = ''Queen''
song = "Don''t Stop Me Now"
review = ''She called it "the best song ever".''
print(band, "-", song)
print(review)
```

For text that spans several lines, like an address or a poem, use **triple quotes**, either `"""` or `''''''`. Line breaks inside them are kept exactly as typed:

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
| `\''` | a single quote | `''It\''s here''` | `It''s here` |
| `\\` | a real backslash | `"C:\\Users"` | `C:\Users` |

```python run
print("Shopping list:\n- milk\n- eggs\n- bread")
print("Player\tScore")
print("Mei\t1200")
print("Ravi\t950")
```

Even though `\n` is two keystrokes, it''s **one character** in the string. Python reads the pair as a single "new line" character.

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

Notice that `+` doesn''t add a space for you: you add `" "` yourself. And `"-" * 30` is a quick way to draw a line, handy for receipts and reports.

But `+` only joins **strings with strings**. Try to glue a number onto text and Python refuses:

```python run error
item_count = 3
print("Items in cart: " + item_count)
```

*"can only concatenate str (not "int") to str"*: Python won''t guess whether you meant maths or text. The fix is to turn the number into text first with `str()`:

```python run
item_count = 3
label = "Items in cart: " + str(item_count)
print(label)
```

`str(3)` gives the string `"3"`, which `+` can happily join. (Remember that `print` with commas also works for displaying, but `str()` is what you need when you''re *building* a string to store or reuse. You''ll learn the most elegant way, f-strings, in the next lesson.)

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
Run it and read the last line of the error. Which value isn''t a string?
--- hint
`unread` is a number. Convert it to text right where it''s being joined, with `str(...)`.
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
#   border: the "=" character repeated so it''s exactly as long as `middle`
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

Negative indices count **from the end**: `-1` is the last character, `-2` the one before it, and so on. That''s very handy when you don''t know how long a string is: `name[-1]` is always the last character, whatever the name.

> **Under the hood:** why start at 0? The index is really an *offset*: "how many steps from the start". The first character is 0 steps from the start. Most programming languages count this way, and after a week it''ll feel natural.

Ask for a position that doesn''t exist and Python stops with an `IndexError`:

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
assert initials == first_name[0] + "." + last_name[0] + ".", f"`initials` should be {first_name[0] + ''.'' + last_name[0] + ''.''!r}, but it is {initials!r}."
assert last_letter == last_name[-1], f"`last_letter` should be the last character of {last_name!r}, but it is {last_letter!r}."
--- hint
The first character of any string is at index `0`, and the last is at index `-1`.
--- hint
Glue the pieces with `+`: the first letter of `first_name`, then `"."`, then the first letter of `last_name`, then `"."`.
```

## Slicing: cutting out a piece

Indexing gets one character. **Slicing** gets a whole chunk: `text[start:stop]` gives the characters from index `start` **up to but not including** `stop`.

The easiest way to picture it: imagine the indices sit on the **fences between characters**. A slice cuts at two fences and keeps what''s between them.

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
Index 3 is `c` (B=0, a=1, r=2, c=3). The slice stops **before** index 7, so it takes indices 3, 4, 5 and 6: `c`, `e`, `l`, `o`. That''s `7 - 3 = 4` characters.
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
assert year == "2026" and day == "22", f"`year` and `day` were already right; keep them as ''2026'' and ''22'' (they are {year!r} and {day!r})."
assert month != "1", "`month` is still just ''1''. The slice stops one character too early."
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

## Strings can''t be changed (they''re immutable)

Here''s a rule that surprises many beginners: once a string is created, **you can''t change its characters**. Strings are **immutable**. Try to fix a typo by assigning to an index and Python refuses:

```python run error
city = "lisbon"
city[0] = "L"
```

*"''str'' object does not support item assignment"* means exactly that. Instead, you **build a new string** from the pieces you want and move the name onto it:

```python run
city = "lisbon"
city = "L" + city[1:]
city
```

The original `"lisbon"` was never modified; `city` now simply points to a brand-new string, `"Lisbon"`. Every string operation you''ve seen (`+`, `*`, slicing) works this way: it gives you a **new** string and leaves the old one alone. That turns out to be a big advantage: a string you hand to another part of your program can never be changed behind your back.

> **In the wild:** immutability is why strings can be used as keys in Python dictionaries (lesson 16), which power everything from JSON data to web frameworks like Django. Python can trust that a key''s text will never change.

## Is it in there? The `in` operator

`in` checks whether one string appears **inside** another. The answer is `True` or `False`, the two Boolean values you''ll study properly in lesson 7:

```python run
email = "mei.chen@example.com"
print("@" in email)
print("gmail" in email)
print("Chen" in email)
print("chen" in email)
```

Notice the last two: `"Chen"` isn''t found but `"chen"` is. Comparisons between strings are **case-sensitive**: `C` and `c` are different characters. (Lesson 6 shows how to compare text without worrying about case.)

## Recap

- Strings are text in `''single''`, `"double"` or `"""triple"""` quotes. Escape sequences like `\n`, `\t` and `\"` add special characters.
- `+` joins strings, `*` repeats them, and `len()` counts every character, spaces included. Use `str(number)` before joining a number with `+`.
- Indexing starts at **0**: `text[0]` is the first character, `text[-1]` the last. Going past the end raises `IndexError`.
- Slicing `text[start:stop:step]` includes `start` and **excludes** `stop`. Leave out ends to go from the start or to the end; `[::-1]` reverses.
- Strings are **immutable**: build a new string instead of changing one in place.
- `in` checks whether text appears inside a string, and it''s case-sensitive.

**Up next:** string methods and f-strings, the professional toolkit for cleaning, searching and formatting text.
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z'),
('les_python_basics_2_3', 'sec_python_basics_2', 'crs_python_basics', 'String methods and f-strings', 'interactive', 2, 1080, NULL, NULL, 'Real-world text is messy. People type their email as `"  Maya.Chen@Example.COM "`, product codes arrive in lowercase, prices come in as `"$1,299.99"`, and a whole spreadsheet row can show up as one long line of commas. Before a program can *use* text, it has to clean it, split it apart, search it and, at the end, present it nicely to a human.

Python strings come with a built-in toolbox for exactly this. In this lesson you''ll learn the dozen string methods professionals reach for every day, and **f-strings**, the modern way to drop values into text with perfect formatting. By the end you''ll be able to tidy messy input, pull pieces out of a line of data, and print a receipt with neatly lined-up columns.

## Methods: actions a value knows how to do

In lesson 05 you used *functions* like `len(text)`, where the value goes inside the parentheses. A **method** is a function that belongs to a value. You call it with a dot: `value.method()`.

Think of every string as carrying its own little toolbox. The dot means "reach into this string''s toolbox and use the tool called…".

```python run
city = "lisbon"

print(city.upper())       # every letter uppercase
print(city.title())       # first letter of each word uppercase
print("CAFÉ MENU".lower())
print("new york city".title())
```

The parentheses matter: they''re what actually *runs* the method. You''ll see what happens without them in a moment.

| Method | What it does | `"hello World".method()` |
|---|---|---|
| `.upper()` | all uppercase | `''HELLO WORLD''` |
| `.lower()` | all lowercase | `''hello world''` |
| `.title()` | Each Word Capitalized | `''Hello World''` |
| `.capitalize()` | only the very first letter | `''Hello world''` |

> **Coming from Excel:** these are Python''s versions of `UPPER()`, `LOWER()` and `PROPER()`. Later in this lesson you''ll meet the equivalents of `TRIM()` (`.strip()`) and `SUBSTITUTE()` (`.replace()`).

## Methods return a *new* string

Remember from lesson 05 that strings are **immutable**: once created, a string can never change. So how can `.upper()` work? It doesn''t change the original. It builds a brand-new string and hands it back to you. If you don''t catch it with a variable, it''s gone.

```python run
greeting = "hello"

greeting.upper()                      # builds "HELLO"... and throws it away
print("after calling upper():", greeting)

loud = greeting.upper()               # catch the new string with a name
print("saved result:", loud)

greeting = greeting.upper()           # or replace the old label entirely
print("reassigned:", greeting)
```

The last line is the pattern you''ll use most: `name = name.upper()` means "make an uppercase copy, then move the label `name` onto it".

> **Pitfall:** forgetting the parentheses doesn''t raise an error. `print(greeting.upper)` prints something like `<built-in method upper of str object at 0x...>`. That''s Python describing the *tool itself* instead of using it. If you ever see `built-in method` in your output, look for missing `()`.

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

`.strip()` removes whitespace (spaces, tabs, newlines) from **both ends** of a string, never from the middle. It''s the first thing you do to text that a human typed or a file delivered. The square brackets below are just there so you can *see* the invisible spaces.

```python run
raw_email = "   Maya.Chen@Example.COM \n"
clean_email = raw_email.strip().lower()

print("[" + raw_email + "]")
print("[" + clean_email + "]")
print("length before:", len(raw_email), "after:", len(clean_email))
```

Notice `raw_email.strip().lower()`. That''s **chaining**: `.strip()` returns a new string, and `.lower()` is called on *that* string. Read it left to right like an assembly line: strip, then lowercase.

Two relatives: `.lstrip()` cleans only the left end, `.rstrip()` only the right. You can also tell `strip` *which* characters to remove: `"$$42$".strip("$")` gives `''42''`.

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
# Build it from raw_title using string methods (don''t just type the answer).
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

`.split(separator)` cuts a string wherever the separator appears and gives you back the pieces in a **list**: values in square brackets, separated by commas. You''ll study lists properly in lesson 13. For now, all you need is that a list holds pieces in order and that you index it exactly like a string: `parts[0]` is the first piece.

```python run
row = "Lisbon,Portugal,24"
parts = row.split(",")

print("parts:", parts)
print("city:", parts[0])
print("country:", parts[1])
print("last piece:", parts[-1])
```

Call `.split()` with **no argument** and it splits on any run of whitespace and ignores spaces at the ends. That''s the go-to way to break a sentence into words:

```python run
messy = "  the   quick brown    fox  "
print("split('' ''):", messy.split(" "))   # every single space is a cut: empty pieces!
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

`TypeError: sequence item 0: expected str instance, int found` means "item number 0 of the list should have been a string, but it''s an int". You''ll learn to convert a whole list in one line in the comprehensions lesson; for now, keep the pieces as text.

> **In the wild:** turning a title into a URL like `my-first-python-program` is called making a **slug**. Web frameworks such as Django ship a `slugify()` helper that does exactly the lowercase-split-join dance you''re about to write.

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

Some methods don''t build new text; they *answer a question* about the text. `.startswith()` and `.endswith()` answer yes or no, which Python writes as `True` or `False`. (You met these two values with `in` last lesson; the next lesson is all about them.)

```python run
filename = "holiday_photo.JPG"
url = "https://example.com/menu"

print("is a photo?   ", filename.lower().endswith(".jpg"))
print("secure link?  ", url.startswith("https://"))
print("is a PDF?     ", filename.endswith(".pdf"))
```

`.find(text)` tells you **where** something is: the index of its first appearance, or `-1` if it isn''t there at all. `.count(text)` tells you **how many times** it appears (without overlaps).

```python run
review = "great food, great service, slow delivery"

print("find ''great'':   ", review.find("great"))
print("find ''service'': ", review.find("service"))
print("find ''pizza'':   ", review.find("pizza"))   # not there: -1
print("count ''great'':  ", review.count("great"))
```

> **Pitfall:** `-1` is a perfectly valid index (it means "the last character"), so a `.find()` that failed can sneak through as if it worked. `text[text.find("@"):]` on a string with no `@` silently gives you just the last character. If you only need yes/no, use `in` instead.

`.isdigit()` answers "is every character a digit 0–9?" It''s how you''ll check user input in lesson 08 before turning it into a number. Watch the edge cases:

```python run
print("''2026'':", "2026".isdigit())
print("''20.5'':", "20.5".isdigit())   # the dot isn''t a digit
print("''-3'':  ", "-3".isdigit())     # neither is the minus sign
print("'' 42'': ", " 42".isdigit())    # nor a space: strip first!
print("'''':    ", "".isdigit())       # empty text has no digits at all
```

```python predict id=predict-find-count title="Find and count"
print("banana".count("ana"), "banana".find("na"))
--- options
2 2
* 1 2
1 3
2 3
--- explain
`count` doesn''t let matches overlap: once it finds `ana` at positions 1–3, it continues searching from position 4 (`na`), so only **1** match. `find("na")` returns the index of the first `n`, and counting from 0 (`b`=0, `a`=1, `n`=2) that''s **2**.
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

## Debug challenge: the announcement that won''t shout

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
assert announcement == "FLASH SALE ENDS TONIGHT", f"`announcement` should be ''FLASH SALE ENDS TONIGHT'', but it is {announcement!r}."
assert "[FLASH SALE ENDS TONIGHT]" in _stdout, "Keep the print line so the cleaned announcement is shown."
--- hint
Run it with **Debug** and watch `announcement` in the Variables panel. Does it ever change?
--- hint
Strings are immutable: `.strip()` and `.upper()` *return* new strings. Something has to catch each result.
```

## f-strings: dropping values into text

Back in lesson 05 you glued text with `+`, which forced you to wrap every number in `str()`. There''s a much nicer way. Put an `f` right before the opening quote, and anything inside `{curly braces}` is evaluated as Python and slotted into the text:

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
| `:.2f` | exactly 2 decimal places | `f"{3.14159:.2f}"` | `''3.14''` |
| `:,` | thousands separators | `f"{1234567:,}"` | `''1,234,567''` |
| `:,.2f` | both | `f"{1234.5:,.2f}"` | `''1,234.50''` |
| `:>8` | right-align in 8 characters | `f"{''hi'':>8}"` | `''      hi''` |
| `:<8` | left-align in 8 characters | `f"{''hi'':<8}"` | `''hi      ''` |
| `:^8` | center in 8 characters | `f"{''hi'':^8}"` | `''   hi   ''` |
| `:>8.2f` | right-align *and* 2 decimals | `f"{4.5:>8.2f}"` | `''    4.50''` |

The order inside the spec is always **alignment and width first, then comma, then precision**.

```python run
salary = 1234567.891
print(f"raw:       {salary}")
print(f"2 places:  {salary:.2f}")
print(f"with ,:    {salary:,.2f}")
print(f"[{''left'':<10}] [{''right'':>10}] [{''mid'':^10}]")
```

Rounding with `:.2f` only changes how the number is **displayed**; the variable keeps its full value. That''s exactly what you want for money (and for the `0.1 + 0.2` fuzz you met in lesson 04).

```python predict id=predict-two-decimals title="Formatting money"
price = 4.5
print(f"Total: {price * 2:.2f}")
--- options
Total: 9.0
* Total: 9.00
Total: 9
Total: {price * 2:.2f}
--- explain
`price * 2` is the float `9.0`, and `:.2f` always shows exactly two decimals, so you get `9.00`. Without the spec you''d see `9.0`. And because the string starts with `f`, the braces are evaluated, not printed.
```

### The `=` debugging shortcut

Put an `=` at the end of the expression and the f-string prints the code *and* its value. It''s the fastest way to peek at variables while you''re figuring out a bug:

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

print(f"{''ITEM'':<14}{''PRICE'':>8}")
print("-" * 22)
print(f"{item1:<14}{price1:>8.2f}")
print(f"{item2:<14}{price2:>8.2f}")
print(f"{item3:<14}{price3:>8.2f}")
print("-" * 22)
print(f"{''TOTAL'':<14}{total:>8.2f}")
```

Every line is exactly 22 characters wide (14 + 8), which is why the columns line up. Once you learn loops in Section 3, you''ll print a whole shopping cart this way with just two lines of code.

```python exercise id=receipt-line title="Format a receipt line"
item = "Headphones"
qty = 3
unit_price = 1249.5

# TODO: build `line`, one row of a receipt, with an f-string:
#   - the item name left-aligned in a column 12 characters wide
#   - then the line total (qty * unit_price) right-aligned in 10 characters,
#     with thousands commas and exactly 2 decimals
# For these values, line should be:  ''Headphones    3,748.50''
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
assert "#p #y" not in post, "There''s a # between every letter. `join` walks through whatever you give it piece by piece. What are the pieces of a plain string?"
assert "," not in post, f"`post` still contains commas: {post!r}. The commas should disappear when you break the topics apart."
assert post == "#python #coding #beginners", f"`post` should be ''#python #coding #beginners'', but it is {post!r}. Check the separator you split on: it includes a space."
assert "#python #coding #beginners" in _stdout, "Print the post so you can see it."
--- hint
Run it. Every letter got its own `#`. When you give `join` a string, the "pieces" are its individual characters.
--- hint
`join` needs a list of words. Which method turns `"python, coding, beginners"` into a list of words? Watch out for the space after each comma.
```

## Recap

- A **method** is an action a value knows: `text.upper()`, `text.strip()`. Don''t forget the `()`.
- String methods **return new strings**; the original never changes. Save the result: `name = name.strip()`.
- Clean with `.strip()`, `.lower()`, `.replace()`; chain them left to right. Search with `.startswith()`, `.endswith()`, `.find()` (`-1` = not found), `.count()`, `.isdigit()`.
- `.split()` breaks text into a list of pieces; `"glue".join(pieces)` puts them back together.
- **f-strings** (`f"{expr}"`) drop any expression into text; format specs like `:.2f`, `:,` and `:<10` / `:>10` / `:^10` control the look, and `{x=}` is a built-in debugging peek.

**Up next:** `True` and `False`: comparisons, `and` / `or` / `not`, and how Python decides what counts as "true".
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z'),
('les_python_basics_2_4', 'sec_python_basics_2', 'crs_python_basics', 'Booleans, comparisons and logic', 'interactive', 3, 960, NULL, NULL, 'Every decision a program makes comes down to a yes-or-no question. Is the password long enough? Is the cart over the free-shipping threshold? Is the user old enough to sign up? Is it the weekend? Python answers these questions with just two values: `True` and `False`.

This lesson is about asking those questions precisely: comparing numbers and text, combining conditions with `and`, `or` and `not`, and knowing which values Python treats as "true". It''s the foundation for the next lesson, where your programs start making real decisions with `if`. Get these small expressions right, and `if` statements become easy.

## `True` and `False`

A **boolean** (type `bool`, named after the mathematician George Boole) is the simplest kind of value there is: it''s either `True` or `False`. Nothing else.

```python run
is_raining = False
has_umbrella = True

print("Raining?", is_raining)
print("Umbrella?", has_umbrella)
type(has_umbrella)
```

Good boolean names read like a yes/no question: `is_raining`, `has_umbrella`, `can_vote`, `is_valid`. When you read `if can_vote` in the next lesson, it''ll sound like English.

Both words are **capitalized**. Python is case-sensitive, so lowercase `true` isn''t a boolean; it''s just a name Python has never heard of:

```python run error
game_over = true
```

`NameError: name ''true'' is not defined`. Python thought `true` was a variable you forgot to create. If you''ve used JavaScript or another language with lowercase `true`, this one will catch you a few times.

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

> **Pitfall:** `=` and `==` look alike but mean completely different things. A single `=` is a **command**: "put this label on this value". A double `==` is a **question**: "are these two equal?" Python won''t let you write `if age = 18` (that''s a SyntaxError), but mixing them up in your head is the source of countless beginner bugs.

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

Is the temperature between 18 and 24 degrees? In math you''d write $18 \le t \le 24$, and Python lets you write exactly that:

```python run
temperature = 21

comfortable = 18 <= temperature <= 24
print("comfortable?", comfortable)

print("valid percentage?", 0 <= 105 <= 100)
print("valid month?     ", 1 <= 12 <= 12)
```

`18 <= temperature <= 24` means "`18 <= temperature` **and** `temperature <= 24`". Most other languages can''t do this; in Python it''s the normal, readable way to check a range.

```python exercise id=shipping-and-comfort title="Shipping and comfort checks"
cart_total = 47.5
free_shipping_minimum = 50
temperature = 26

# TODO: define two booleans using comparisons (don''t type True/False directly):
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
assert free_shipping == (cart_total >= free_shipping_minimum), f"`free_shipping` is {free_shipping}, but a cart of {cart_total} against a minimum of {free_shipping_minimum} should give {cart_total >= free_shipping_minimum}. ''At least'' means >=."
assert comfortable == (18 <= temperature <= 24), f"`comfortable` is {comfortable}, but {temperature} degrees is {''inside'' if 18 <= temperature <= 24 else ''outside''} the 18 to 24 range."
--- hint
"At least 50" includes 50 itself. Which operator means "greater than or equal"?
--- hint
For the range, Python lets you chain: `low <= value <= high`.
```

## Comparing strings

`==` works on text too, and it''s **exact**: every character must match, including case and spaces.

```python run
print("''yes'' == ''yes'':", "yes" == "yes")
print("''Yes'' == ''yes'':", "Yes" == "yes")             # case matters
print("''yes '' == ''yes'':", "yes " == "yes")           # so do spaces

answer = "  YES "
print("cleaned first:  ", answer.strip().lower() == "yes")
```

That last line is the professional habit: **normalize text before comparing it**. You''ll do this constantly with anything a human typed.

`<` and `>` compare strings **alphabetically**, character by character, like words in a dictionary. But there''s a twist: every uppercase letter comes before every lowercase letter.

```python run
print("apple < banana:  ", "apple" < "banana")
print("cat < car:       ", "cat" < "car")        # ''t'' comes after ''r''
print("Zebra < apple:   ", "Zebra" < "apple")    # uppercase sorts first!
print("''10'' < ''9'':      ", "10" < "9")           # text, not numbers
```

> **Under the hood:** every character has a number (its *code point*). `ord("A")` is 65, `ord("Z")` is 90, and `ord("a")` is 97. Strings are compared by these numbers, which is why `"Zebra" < "apple"`. And `"10" < "9"` is `True` because the first characters `"1"` and `"9"` are compared, and 1 comes first. Numbers stored as text sort wrongly. Remember that one.

A number and a string are **never** equal, even if they look alike: `18 == "18"` is simply `False`. And ordering them is an error: `18 < "18"` raises `TypeError: ''<'' not supported between instances of ''int'' and ''str''`.

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
assert attempt_1 == "4017" and attempt_2 == "4071", "Leave the user''s attempts as they were typed (text). Fix the comparison side instead."
--- hint
Run it. Both attempts are rejected, even the right one. Use `type()` on `attempt_2` and on `correct_pin`. Are they the same kind of value?
--- hint
A number and a string are never `==`, even if they look the same. Make both sides the same type: a PIN is really a code, not a quantity, so storing it as text makes sense. (`str(correct_pin)` works too.)
```

## Combining conditions: `and`, `or`, `not`

Real questions often have several parts. "You can board if you have a ticket **and** an ID." "You get in free if you''re a child **or** a senior." Python uses the plain English words:

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

> **Pitfall:** `or` in Python is *inclusive*: `True or True` is `True`. In everyday English, "tea or coffee?" usually means one or the other, but Python''s `or` is happy if both are true.

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

# Meant: "it''s a day off, AND it''s sunny" -> go to the beach?
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
`and` is evaluated before `or`, so this is `True or (False and False)`, which is `True or False`, which is `True`. If you read it left to right as `(True or False) and False`, you''d get `False`, which is exactly why parentheses are worth adding.
```

```python exercise id=cinema-discount title="Who gets the cinema discount?"
age = 70
is_member = False
is_peak_time = True

# TODO: define `gets_discount` as a single boolean expression.
# The rule: you get a discount if you''re a child (under 12) or a senior
# (65 or over) or a member... but never at peak time.
# Use and / or / not and parentheses. Don''t type True/False directly.
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
assert gets_discount == expected, f"`gets_discount` is {gets_discount}, but for age={age}, is_member={is_member}, is_peak_time={is_peak_time} it should be {expected}. Peak time cancels every discount. Did you group the ''or'' part in parentheses?"
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
Run it. You''d expect `False`, but it prints `Sunday`. Python read the line as `(day == "Saturday") or ("Sunday")`.
--- hint
`or` joins two complete questions. The right side, `"Sunday"`, isn''t a question; it''s just a non-empty string. Each side needs its own `day == ...`.
```

Why did it print `Sunday`? That''s the subject of the next section.

## Truthiness: what counts as true?

Every value in Python, not just booleans, can be treated as true or false. The `bool()` function shows you how Python sees it. The rule is short: **empty and zero things are falsy; everything else is truthy.**

```python run
print("0     ->", bool(0))
print("0.0   ->", bool(0.0))
print("''''    ->", bool(""))
print("[]    ->", bool([]))           # an empty list
print("42    ->", bool(42))
print("-3    ->", bool(-3))
print("''hi''  ->", bool("hi"))
print("'' ''   ->", bool(" "))          # a space is not empty!
print("''False'' ->", bool("False"))    # non-empty text: truthy!
```

| Falsy (count as `False`) | Truthy (count as `True`) |
|---|---|
| `0`, `0.0` | any other number, even negative |
| `""` (empty string) | any non-empty string, even `" "` or `"False"` |
| `[]` (empty list) and other empty collections | collections with something in them |
| `None` | almost everything else |

Truthiness is what lets you write `if cart:` in the next lesson to mean "if the cart isn''t empty".

> **Under the hood:** `bool` is a special kind of `int`: `True` behaves like `1` and `False` like `0`. So `True + True` is `2`, which turns out to be handy for counting how many conditions are true.

## Short-circuiting: `and` and `or` stop early

Python is lazy in a useful way. With `and`, if the left side is falsy, the answer is already known (it can''t be "both"), so the right side is **never evaluated**. With `or`, a truthy left side is enough.

There''s a second surprise: `and` and `or` don''t always return `True`/`False`. They return **whichever operand decided the answer**. That''s why the weekend bug printed `Sunday`: `day == "Saturday"` was `False`, so `or` returned its right side, the string `"Sunday"`.

```python run
nickname = ""
print("display:", nickname or "Guest")       # left is falsy -> right side

visits = 0
total_spent = 120.0
# Safe: if visits is 0, Python never runs the division.
big_spender = visits != 0 and total_spent / visits > 50
print("big spender:", big_spender)
```

`x or default` is a classic Python idiom: "use `x`, unless it''s empty, then use `default`". And the `visits != 0 and ...` pattern guards against a `ZeroDivisionError`: without it, `120.0 / 0` would crash.

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
assert display == (nickname.strip() or "Anonymous"), f"`display` should be {(nickname.strip() or ''Anonymous'')!r} for this nickname, but it is {display!r}."
--- hint
`"   "` is not empty (spaces are characters), so it''s truthy. What string method would turn it into `""`?
--- hint
Clean the nickname first, then put `or "Anonymous"` after it.
```

## `None`, and the one place for `is`

`None` is Python''s value for "nothing here yet": a middle name nobody entered, a score not recorded yet. It''s falsy, and it has its own type, `NoneType`.

To check for it, Python style uses `is` instead of `==`:

```python run
middle_name = None
best_time = 12.4

print("no middle name?", middle_name is None)
print("has best time? ", best_time is not None)
type(middle_name)
```

`is` asks "are these the very **same object**?", while `==` asks "do these have equal **values**?" There''s exactly one `None` object in all of Python, so `is None` is the precise question. For everything else, numbers and strings included, use `==`.

> **In the wild:** you''ll see `if value is None:` everywhere in professional code, from Django views to pandas internals. Linters (tools that check code style) even flag `== None` as a mistake.

## Combining it all: a password check

`not in` is the opposite of `in` from lesson 05: `" " not in password` is `True` when there''s no space anywhere.

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
assert not todo, f"Replace the `...` for: {'', ''.join(todo)}"
for k, v in names.items():
    assert isinstance(v, bool), f"`{k}` should be True or False, but it is {v!r}."
assert long_enough == (len(password) >= 8), f"`long_enough` is {long_enough}, but the password has {len(password)} characters. ''At least 8'' includes 8."
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
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_python_basics_2_5', 'sec_python_basics_2', 'crs_python_basics', 'Talking to users: input() and type conversion', 'interactive', 4, 960, NULL, NULL, 'So far, every program you''ve written has talked *at* people: it prints, and that''s it. Real programs listen too. A tip calculator asks for the bill. A quiz asks for your answer. A sign-up form asks for your age. The moment your program can ask a question and use the reply, it stops being a script and starts being a tool someone can use.

Python''s `input()` function asks the question. But it comes with one rule that trips up every beginner exactly once: **whatever the user types arrives as text**, even if they typed `42`. In this lesson you''ll learn to read input, convert it into the numbers you need with `int()` and `float()`, spot the conversions that crash or quietly lie, and check input before trusting it.

```python setup
# Simulated keyboard: the browser can''t pause for typing, so input() reads queued answers.
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

Because this page can''t pause for your keyboard, `input()` here reads answers you queue up with `type_answers(...)`. In a real terminal, Python waits for you to type. Think of `type_answers` as typing ahead of time: each `input()` call takes the next answer from the queue, and the output shows it right after the prompt, just like a terminal would.

```python run
type_answers("Maya")

name = input("What''s your name? ")
print(f"Nice to meet you, {name}!")
```

Change `"Maya"` to your own name and run it again. You can queue several answers at once; they''re used in order:

```python run
type_answers("Lisbon", "Portugal")

city = input("City: ")
country = input("Country: ")
print(f"Shipping to {city.title()}, {country.upper()}")
```

> **Tip:** end your prompt with a space (`"City: "`), otherwise the user''s typing is glued right onto the colon. Small touch, big difference in how polished your program feels.

## `input()` always returns a string

Here''s the rule that matters most in this lesson. Ask someone their age, and they type `27`. What do you get back?

```python run
type_answers("27")

age = input("How old are you? ")
print("type:", type(age))
age
```

The quotes in `''27''` and the `str` label give it away: `age` is **text** that happens to contain digits, not the number 27. `input()` has no idea what you''re asking for, so it always hands you exactly the characters that were typed. Try to do math with it, and Python stops you:

```python run error
type_answers("27")

age = input("How old are you? ")
print("Next year you''ll be", age + 1)
```

`TypeError: can only concatenate str (not "int") to str`. You met this one in lesson 05: `+` between a string and a number doesn''t make sense. Python won''t guess whether you meant math or gluing text. You have to say which one you mean by **converting** the value.

> **In the wild:** this isn''t just an `input()` thing. Data from web forms, command-line arguments, CSV files and URLs all arrive as text. Converting it to the right type at the edge of your program is a habit professionals never skip.

## Converting types: `int()`, `float()`, `str()`

Python has a converter function named after each type. Hand it a value, and it returns a **new** value of that type:

| Function | Converts to | Example | Result |
|---|---|---|---|
| `int(x)` | whole number | `int("27")` | `27` |
| `float(x)` | decimal number | `float("4.99")` | `4.99` |
| `str(x)` | text | `str(27)` | `''27''` |
| `bool(x)` | `True` / `False` | `bool("hi")` | `True` (more on this soon) |

The usual pattern is to wrap `input()` directly inside the converter:

```python run
type_answers("27")

age = int(input("How old are you? "))
print("Next year you''ll be", age + 1)
print("type now:", type(age))
```

Read `int(input("..."))` from the **inside out**: first `input()` runs and returns `"27"`, then `int()` turns that into `27`, and finally `=` puts the label `age` on it.

Use `int()` for things you count (tickets, people, years) and `float()` for things you measure (prices, weights, temperatures). Here''s a whole little program, a restaurant tip calculator:

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
#       3) print a message like: Next year you''ll be 30.
age = ...
next_year = ...

print(...)
--- solution
type_answers("29")

age = int(input("How old are you? "))
next_year = age + 1

print(f"Next year you''ll be {next_year}.")
--- test
assert age is not ..., "Replace the `...` after `age =` with a call to input() wrapped in a converter."
assert not isinstance(age, str), f"`age` is the text {age!r}, not a number. input() always returns a string. Which function turns ''29'' into 29?"
assert isinstance(age, int), f"`age` should be a whole number (int), but it is {type(age).__name__}."
assert not _queued, "Your code never read the answer. Call input(\"How old are you? \") to get it."
assert age == 29, f"`age` should be 29 (the queued answer), but it is {age!r}."
assert next_year is not ..., "Replace the `...` after `next_year =`."
assert next_year == age + 1, f"`next_year` should be one more than age ({age + 1}), but it is {next_year!r}."
assert str(next_year) in _stdout.replace("29", "", 1), "Print a message that includes next year''s age, like: Next year you''ll be 30."
--- hint
`input(...)` gives you the text `"29"`. Wrap the whole call in the function that makes whole numbers.
--- hint
`age = int(input("How old are you? "))`, then build `next_year` from `age`.
--- hint
For the message, an f-string is easiest: `print(f"Next year you''ll be {...}.")`.
```

## `int()` chops, it doesn''t round

`int()` on a float simply cuts off everything after the decimal point. It never rounds up, not even for `7.99`. If you want proper rounding, use `round()` from lesson 04.

```python run
print("int(7.9):  ", int(7.9))
print("round(7.9):", round(7.9))
print("int(-2.7): ", int(-2.7))       # toward zero, not down
print("str(3.50): ", str(3.50))       # trailing zero is not kept
print("str(42) + ''!'':", str(42) + "!")
```

`str()` is the converter in the other direction. You''ll use it less now that f-strings do the job for you (`f"{42}!"`), but it''s handy whenever you need to glue a number onto text with `+`.

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

Read the last line: `ValueError: invalid literal for int() with base 10: ''3.5''`. In plain words: "`''3.5''` doesn''t look like a whole number". *Base 10* just means ordinary decimal digits. The fix depends on what you want: `float("3.5")` gives `3.5`, and if you truly need a whole number, convert to float first and then round: `round(float("3.5"))`.

Here''s what the converters accept and reject:

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

A crash on bad input isn''t a disaster; it''s Python refusing to guess. In lesson 23 you''ll learn `try` / `except`, which lets your program catch a `ValueError` and politely ask again. For now, you''ll learn to check input *before* converting it.

## The `bool()` trap

`bool()` looks like it should turn `"False"` into `False`. It doesn''t. Remember the truthiness rule from lesson 07: **any non-empty string is truthy**, whatever it says.

```python run
print(''bool("False"):'', bool("False"))
print(''bool("no"):   '', bool("no"))
print(''bool("0"):    '', bool("0"))
print(''bool(""):     '', bool(""))      # only empty text is False

type_answers("  No ")
answer = input("Subscribe to our newsletter? ")
print("subscribed:", answer.strip().lower() == "yes")
```

To turn a yes/no answer into a boolean, **compare the cleaned-up text** with what you''re looking for. `bool()` on user input is almost always a bug.

```python predict id=predict-bool-text title="What does bool() make of these?"
print(bool("False"), bool(" "), bool(""))
--- options
False False False
False True False
* True True False
True False False
--- explain
`bool()` doesn''t read the words; it only asks "is this text empty?". `"False"` has five characters and `" "` has one (a space), so both are truthy. Only the truly empty string `""` gives `False`.
```

```python exercise id=yes-or-no title="Understand yes and no"
type_answers("  Yes ", "no")

first = input("Do you want a receipt? ")
second = input("Do you want a bag? ")

# TODO: define two booleans:
#   wants_receipt -> True if `first`, cleaned up, is "yes" or "y"
#   wants_bag     -> the same rule applied to `second`
# Cleaned up = no spaces at the ends, and case doesn''t matter.
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
assert wants_bag is False, "The customer typed ''no'' for the bag, but `wants_bag` is True. Did you use bool()? Any non-empty text is truthy, even ''no''."
assert wants_receipt is True, "The customer typed ''  Yes '' for the receipt, but `wants_receipt` is False. Clean the text first: remove the spaces and ignore the capital letter."
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
assert total_tickets != "23", "`total_tickets` is ''23'': the two answers were glued together as text, not added as numbers."
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
assert price_per_kg == 3.5, f"`price_per_kg` should be 3.5, but it is {price_per_kg!r}. Don''t round the price, keep the cents."
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

> **Pitfall:** `.isdigit()` says `False` for `"-5"` and `"2.5"`, because `-` and `.` aren''t digits. It''s perfect for counts and quantities, but not for prices or temperatures. For those, the bulletproof check is `try` / `except` (lesson 23).

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
assert not todo, f"Replace the `...` for: {'', ''.join(todo)}"
assert isinstance(is_valid, bool), f"`is_valid` should be True or False, but it is {is_valid!r}."
assert is_valid is True, "`is_valid` is False, but '' 135 '' is a valid number once the spaces are removed. Strip before checking."
assert not isinstance(minutes, str), f"`minutes` is still text ({minutes!r}). Convert it with int()."
assert minutes == 135, f"`minutes` should be 135, but it is {minutes!r}."
assert hours == minutes // 60, f"`hours` should be {minutes // 60}, but it is {hours!r}. Did you use / instead of //?"
assert isinstance(hours, int), f"`hours` should be a whole number, but it is {hours!r}. Floor division // keeps it whole."
assert leftover == minutes % 60, f"`leftover` should be {minutes % 60}, but it is {leftover!r}. Which operator gives the remainder?"
assert f"{hours}h {leftover}m" in _stdout, f"Print the length in the form {hours}h {leftover}m."
--- hint
`.strip().isdigit()` for the check. `int()` doesn''t mind the spaces, so you can convert `minutes_text` directly.
--- hint
Lesson 04: `//` gives how many whole 60s fit in, and `%` gives what''s left over.
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
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z'),
('les_python_basics_2_6', 'sec_python_basics_2', 'crs_python_basics', 'Checkpoint: numbers, text & truth', 'quiz', 5, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"What does `print(7 / 2, 7 // 2, 7 % 2)` print?","options":["3 3 1","3.5 3.5 1","3.5 3 1","3.5 3 0.5"],"answerIndex":2,"explanation":"`/` always gives a float (3.5). `//` is floor division: how many whole 2s fit into 7 (3). `%` is the remainder left over (1)."},{"id":"q2","prompt":"Why is `0.1 + 0.2 == 0.3` False in Python?","options":["Python adds floats left to right and loses the last digit","Floats are stored in binary, so 0.1 and 0.2 are tiny approximations and their sum is 0.30000000000000004","`==` only works on whole numbers","It''s a bug that was fixed in newer versions of Python"],"answerIndex":1,"explanation":"Most decimal fractions can''t be stored exactly in binary, so floats carry tiny rounding errors. Compare floats after rounding (or check that the difference is tiny), and use `round()` or `:.2f` for display."},{"id":"q3","prompt":"Given `word = \"Python\"`, what is `word[1:4]`?","options":["''yth''","''Pyt''","''ytho''","''Pyth''"],"answerIndex":0,"explanation":"Indexing starts at 0, so index 1 is `y`. A slice includes the start but stops *before* the stop index, giving indexes 1, 2 and 3: `''yth''`."},{"id":"q4","prompt":"`name = \"Jim\"` and you want `\"Tim\"`. Running `name[0] = \"T\"` raises a TypeError. Which line works?","options":["`name[0] == \"T\"`","`name.replace(\"J\", \"T\")` on its own line","`name[0:1] = \"T\"`","`name = \"T\" + name[1:]`"],"answerIndex":3,"explanation":"Strings are immutable, so you can''t change a character in place. Build a new string and move the label onto it: `\"T\" + name[1:]`. A bare `name.replace(...)` returns a new string but throws it away unless you save it."},{"id":"q5","prompt":"After running `city = \"  oslo \"` and then `city.strip().title()` on its own line, what does `print(\"[\" + city + \"]\")` show?","options":["[Oslo]","[  oslo ]","[oslo]","[  Oslo ]"],"answerIndex":1,"explanation":"String methods return a **new** string; they never change the original. The cleaned result was never saved, so `city` is unchanged. Write `city = city.strip().title()` to keep it."},{"id":"q6","prompt":"With `total = 1234.5`, what does `f\"${total:,.2f}\"` produce?","options":["''$1234.5''","''$1,234.5''","''$1234.50''","''$1,234.50''"],"answerIndex":3,"explanation":"In the format spec, `,` adds thousands separators and `.2f` shows exactly two decimals, so you get `$1,234.50`. The variable itself keeps its full value; only the display changes."},{"id":"q7","prompt":"`day = \"Tuesday\"`, but `is_weekend = day == \"Saturday\" or \"Sunday\"` gives a truthy result. Which line is correct?","options":["`is_weekend = day == (\"Saturday\" or \"Sunday\")`","`is_weekend = day == \"Saturday\" or day == \"Sunday\"`","`is_weekend = day == \"Saturday\" and \"Sunday\"`","`is_weekend = (day == \"Saturday\" or \"Sunday\") == True`"],"answerIndex":1,"explanation":"Each side of `or` must be a complete comparison. The buggy version is read as `(day == \"Saturday\") or \"Sunday\"`, and the non-empty string `\"Sunday\"` is always truthy. `(\"Saturday\" or \"Sunday\")` is just `\"Saturday\"`, so the first option never matches Sunday."},{"id":"q8","prompt":"What does `print(True or False and False, bool(\"False\"), bool(0))` print?","options":["False False False","True False False","True True False","False True True"],"answerIndex":2,"explanation":"`and` binds tighter than `or`, so the first is `True or (False and False)`, which is `True`. `bool(\"False\")` is `True` because any non-empty string is truthy. `bool(0)` is `False` because zero is falsy."},{"id":"q9","prompt":"A program runs `a = input(\"First: \")` and `b = input(\"Second: \")`. The user types 2 and then 3. What does `print(a + b)` show?","options":["5","23","2 3","A TypeError"],"answerIndex":1,"explanation":"`input()` always returns a string, so `a` is `\"2\"` and `b` is `\"3\"`, and `+` glues text together: `\"23\"`. Convert first with `int(input(...))` to add them as numbers."},{"id":"q10","prompt":"`price = int(input(\"Price: \"))` crashes with `ValueError: invalid literal for int() with base 10: ''4.99''`. What is the right fix?","options":["Use `float(input(\"Price: \"))`, because `int()` only accepts whole-number text","Use `bool(input(\"Price: \"))` to check the input first","Use `str(input(\"Price: \"))`, because the input isn''t a string yet","Use `int(input(\"Price: \").strip())`, because the problem is extra spaces"],"answerIndex":0,"explanation":"`int()` refuses text with a decimal point. `float()` understands `\"4.99\"`. `str()` changes nothing (input is already text), `bool()` would just give True, and `int()` already ignores surrounding spaces."}]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z'),
('les_python_basics_3_1', 'sec_python_basics_3', 'crs_python_basics', 'Making decisions with if, elif and else', 'interactive', 0, 1080, NULL, NULL, 'So far, every program you''ve written has been a straight road: Python runs line 1, then line 2, then line 3, all the way to the end, every single time. Real programs aren''t like that. A shop charges shipping *unless* your cart is over $50. A game shows "Game over" *only when* your lives hit zero. A banking app refuses a withdrawal *if* it would overdraw your account. Every one of those is a **decision**, and decisions are what turn a calculator into a program.

In this lesson you''ll teach Python to choose. You''ll write `if`, `else` and `elif` statements, learn why indentation is part of Python''s grammar (not just decoration), and build real decision logic: shipping tiers, ticket prices and the famously tricky leap-year rule. You''ll also learn the two bugs that trip up almost everyone: branches in the wrong order, and a line indented one level too far.

```python setup
# Hidden checker helper: lets the tests re-run your challenge code with other starting values.
import contextlib as _contextlib, io as _io, linecache as _linecache, re as _re

def _rerun(**values):
    src = "".join(_linecache.cache["<cell>"][2])
    for name, value in values.items():
        src, found = _re.subn(rf"(?m)^{name}\s*=(?!=).*$", f"{name} = {value!r}", src, count=1)
        assert found, f"Keep the line `{name} = ...` in your code so the checker can try other values."
    ns = {k: v for k, v in globals().items() if k in _SETUP_NAMES}
    out = _io.StringIO()
    try:
        with _contextlib.redirect_stdout(out):
            exec(compile(src, "<cell>", "exec"), ns)
    except Exception as e:
        settings = ", ".join(f"{k} = {v!r}" for k, v in values.items())
        raise AssertionError(f"With {settings}, your code crashed with {type(e).__name__}: {e}")
    ns["_out"] = out.getvalue()
    return ns

_SETUP_NAMES = set(globals()) | {"_SETUP_NAMES"}
```

## Your first `if`

An `if` statement asks a yes/no question. If the answer is `True`, Python runs the indented lines underneath. If it''s `False`, Python skips them.

```python run
temperature = 31

if temperature > 25:
    print("It''s a hot one. Grab some water!")

print("Weather check done.")
```

Change `temperature` to `18` and run it again. The first message disappears, but `"Weather check done."` still prints, because it isn''t indented under the `if`.

Every `if` has the same shape:

```python
if condition:
    # indented lines run only when condition is True
    ...
# unindented lines always run
```

- The **condition** is any expression that produces `True` or `False`, like the comparisons and `and`/`or` logic from lesson 7.
- The line ends with a **colon** `:`. Forgetting it is a `SyntaxError`.
- The lines that belong to the `if` are **indented** by 4 spaces. That group of lines is called a **block**.

Here''s the same program as a picture. The road splits at the question and joins back together afterwards:

```text
              temperature > 25 ?
               /            \
            True            False
             |                |
   print("It''s a hot one…")   |   (skipped)
               \            /
         print("Weather check done.")   ← always runs
```

## Indentation is the structure

In many languages, curly braces `{ }` mark where a block starts and ends, and indentation is just for humans. In Python, **indentation is the grammar**. A block is every consecutive line indented under the colon. The first line that goes back to the outer level ends the block.

```python run
balance = 40
price = 55

if price > balance:
    shortfall = price - balance
    print("Card declined.")
    print("You need", shortfall, "more.")

print("Thanks for shopping with us.")
```

All three indented lines belong to the `if`, so they run together or not at all. Set `price = 25` and run again: only the thank-you line prints.

```python predict id=predict-indent-skip title="Which lines run?"
temperature = 15
if temperature > 25:
    print("Wear shorts")
print("Have a nice day")
--- options
Wear shorts
* Have a nice day
Nothing is printed
An IndentationError
--- explain
`15 > 25` is `False`, so the indented block (`print("Wear shorts")`) is skipped. The last `print` is **not** indented, so it''s outside the `if` and runs no matter what.
```

If a line that should be inside the block isn''t indented, Python can''t tell what the `if` is supposed to do. Run this to see the error:

```python run error
temperature = 30
if temperature > 25:
print("It''s hot!")
```

Read the last line of the error first: `IndentationError: expected an indented block after ''if'' statement on line 2`. Python is telling you exactly what''s wrong and where. An `if` must have at least one indented line under it.

> **Tip:** Use 4 spaces per level (the editor inserts them when you press **Tab**). Never mix tabs and spaces in one file. They can look identical on screen and still confuse Python.

## `else`: the other road

Often you want to do one thing when the condition is true and something *different* when it''s false. That''s `else`. It has no condition of its own: it catches everything the `if` didn''t.

```python run
order_number = 1047

if order_number % 2 == 0:
    print("Order", order_number, "ships from the north warehouse.")
else:
    print("Order", order_number, "ships from the south warehouse.")
```

Exactly one of the two blocks runs, never both and never neither. Notice `else:` lines up with `if`, not with the indented lines, and it also ends in a colon.

A common pattern is to give a variable a value in each branch, then use it afterwards:

```python run
password = "sunflower42"

if len(password) >= 8:
    verdict = "strong enough"
else:
    verdict = "too short"

print(f"Your password is {verdict}.")
```

```python exercise id=free-shipping title="Free shipping over $50"
cart_total = 42.50

# TODO: use if/else to set `shipping`:
#   0 when cart_total is 50 or more
#   4.99 otherwise
shipping = ...

print("Shipping:", shipping)
--- solution
cart_total = 42.50

if cart_total >= 50:
    shipping = 0
else:
    shipping = 4.99

print("Shipping:", shipping)
--- test
assert shipping is not ..., "Replace `shipping = ...` with an if/else that sets `shipping` to 0 or 4.99."
assert isinstance(shipping, (int, float)), f"`shipping` should be a number (0 or 4.99), but it is {shipping!r}."
assert shipping == 4.99, f"A $42.50 cart is under $50, so `shipping` should be 4.99, but it is {shipping!r}."
for total, want in [(50, 0), (49.99, 4.99), (120.0, 0), (0.5, 4.99)]:
    got = _rerun(cart_total=total).get("shipping")
    assert got == want, f"With cart_total = {total}, `shipping` should be {want} but is {got!r}. Check your condition (is exactly 50 included?)."
--- hint
The question is "is the cart total 50 or more?". Which comparison operator means "or more"?
--- hint
`if cart_total >= 50:` then set `shipping = 0`; under an `else:` set `shipping = 4.99`. Remember the colons and the indentation.
```

## `elif`: more than two roads

Life is rarely just yes or no. A grade can be A, B, C, D or F. For several choices, chain conditions with `elif` (short for "else if"):

```python run
score = 83

if score >= 90:
    grade = "A"
elif score >= 80:
    grade = "B"
elif score >= 70:
    grade = "C"
elif score >= 60:
    grade = "D"
else:
    grade = "F"

print("Score", score, "earns a", grade)
```

Python checks the conditions **from top to bottom** and runs the block of the **first one that''s true**. Then it skips the rest of the chain entirely. So for `83`, Python asks "≥ 90?" (no), "≥ 80?" (yes) and stops there. It never even looks at `>= 70`, even though that''s also true.

That''s why `elif score >= 80` doesn''t need to say `and score < 90`: if the score were 90 or more, the first branch would already have won.

| Keyword | Has a condition? | How many per chain | When its block runs |
|---|---|---|---|
| `if` | yes | exactly 1, at the start | its condition is true |
| `elif` | yes | 0 or more | every branch above was false, and its condition is true |
| `else` | no | 0 or 1, at the end | every branch above was false |

> **Under the hood:** At most one block in an `if`/`elif`/`else` chain ever runs. With an `else` at the end, *exactly* one runs. That guarantee is why chains are perfect for sorting things into categories.

Because the first true condition wins, **the order of the branches matters**. Look carefully at this one before you answer:

```python predict id=predict-first-match title="First match wins"
score = 95
if score >= 60:
    grade = "D"
elif score >= 70:
    grade = "C"
elif score >= 90:
    grade = "A"
else:
    grade = "F"
print(grade)
--- options
A
* D
F
D C A
--- explain
`95 >= 60` is already `True`, so the very first branch wins and the chain stops. The `>= 90` test is never reached. When ranges overlap like this, put the **strictest** check first (highest threshold at the top).
```

```python debug id=shipping-tiers-order title="Heavy parcels get a cheap rate"
# Rates:  up to 1 kg: 2.99   over 1 kg: 4.99   over 5 kg: 9.99   over 10 kg: 19.99
weight_kg = 12

if weight_kg > 1:
    shipping = 4.99
elif weight_kg > 5:
    shipping = 9.99
elif weight_kg > 10:
    shipping = 19.99
else:
    shipping = 2.99

print(f"Shipping for {weight_kg} kg: ${shipping}")
--- solution
# Rates:  up to 1 kg: 2.99   over 1 kg: 4.99   over 5 kg: 9.99   over 10 kg: 19.99
weight_kg = 12

if weight_kg > 10:
    shipping = 19.99
elif weight_kg > 5:
    shipping = 9.99
elif weight_kg > 1:
    shipping = 4.99
else:
    shipping = 2.99

print(f"Shipping for {weight_kg} kg: ${shipping}")
--- test
assert shipping == 19.99, f"A 12 kg parcel should cost 19.99 to ship, but `shipping` is {shipping!r}. Which branch won?"
for w, want in [(0.5, 2.99), (1, 2.99), (3, 4.99), (5, 4.99), (7, 9.99), (10, 9.99), (10.5, 19.99), (40, 19.99)]:
    got = _rerun(weight_kg=w).get("shipping")
    assert got == want, f"With weight_kg = {w}, `shipping` should be {want} but is {got!r}."
--- hint
Run it: a 12 kg parcel is charged 4.99. Which condition is checked first, and is it true for 12?
--- hint
`12 > 1` is true, so the first branch wins before the heavier tiers are ever checked. Put the strictest check (the biggest weight) at the top.
```

```python exercise id=ticket-prices title="Cinema ticket prices"
age = 34

# TODO: use if/elif/else to set `price` from the visitor''s age:
#   under 3        -> 0   (free)
#   3 to 12        -> 8   (child)
#   13 to 64       -> 14  (adult)
#   65 and over    -> 9   (senior)
price = ...

print(f"Ticket for age {age}: ${price}")
--- solution
age = 34

if age < 3:
    price = 0
elif age <= 12:
    price = 8
elif age <= 64:
    price = 14
else:
    price = 9

print(f"Ticket for age {age}: ${price}")
--- test
assert price is not ..., "Replace `price = ...` with an if/elif/else chain that sets `price`."
assert isinstance(price, (int, float)), f"`price` should be a number, but it is {price!r}."
assert price == 14, f"A 34-year-old pays the adult price (14), but `price` is {price!r}."
for a, want in [(1, 0), (2, 0), (3, 8), (12, 8), (13, 14), (40, 14), (64, 14), (65, 9), (90, 9)]:
    got = _rerun(age=a).get("price")
    assert got == want, f"With age = {a}, `price` should be {want} but is {got!r}. Check the boundary ages carefully."
--- hint
Work from the youngest group upwards (or the oldest downwards). Each `elif` only needs the upper limit, because earlier branches already handled the smaller ages.
--- hint
Start with `if age < 3:` for the free tickets. Then `elif age <= 12:` for children. What comes next?
```

## Nested `if`s, or `and`?

You can put an `if` inside another `if`''s block. The inner one is only reached when the outer condition is true:

```python run
username = "maya"
password = "tulip-77"

if username == "maya":
    if password == "tulip-77":
        print("Welcome back, Maya!")
    else:
        print("Wrong password.")
else:
    print("No such user.")
```

Nesting is the right tool when each level needs its *own* `else` (here, different error messages). But when you only care whether *both* things are true, `and` says it in one flat line:

```python run
temperature = 24
is_raining = False

if temperature > 20 and not is_raining:
    print("Picnic weather!")
else:
    print("Maybe a museum today.")
```

> **Tip:** Every level of nesting is one more thing a reader has to hold in their head. If you see an `if` whose only content is another `if` with no `else`, merge them with `and`. Flat is better than nested (that''s literally a line in *The Zen of Python*; run `import this` sometime).

This next challenge is a classic. The leap-year rule has an exception *and* an exception to the exception, so it''s a great test of careful decision logic.

```python exercise id=leap-year title="Leap year detective"
year = 2024

# A year is a leap year if it is divisible by 4,
# EXCEPT years divisible by 100 are not leap years,
# EXCEPT years divisible by 400 are leap years after all.
#   2024 -> True   2023 -> False   1900 -> False   2000 -> True
# TODO: set `is_leap` to True or False (use if/elif/else, or one boolean expression).
is_leap = ...

print(year, "is a leap year:", is_leap)
--- solution
year = 2024

if year % 400 == 0:
    is_leap = True
elif year % 100 == 0:
    is_leap = False
elif year % 4 == 0:
    is_leap = True
else:
    is_leap = False

print(year, "is a leap year:", is_leap)
--- test
assert is_leap is not ..., "Replace `is_leap = ...` with your decision logic."
assert isinstance(is_leap, bool), f"`is_leap` should be True or False, but it is {is_leap!r}."
assert is_leap is True, "2024 is divisible by 4 (and not by 100), so it is a leap year."
for y, want in [(2023, False), (1900, False), (2000, True), (2100, False), (2400, True), (1996, True), (2019, False)]:
    got = _rerun(year=y).get("is_leap")
    assert got == want, f"With year = {y}, `is_leap` should be {want} but is {got!r}."
--- hint
"Divisible by 4" means `year % 4 == 0`: the remainder is zero.
--- hint
Check the most specific rule first: is it divisible by 400? Then by 100? Then by 4? The first match decides.
--- hint
Or as one expression: `year % 4 == 0 and (year % 100 != 0 or ...)`. What belongs in the gap?
```

## Separate `if`s vs one chain

An `elif` chain picks **one** branch. A row of separate `if` statements is different: each one is its own independent question, so several (or all, or none) can run.

```python predict id=predict-separate-ifs title="How many badges?"
points = 120
badges = ""
if points >= 50:
    badges += "bronze "
if points >= 100:
    badges += "silver "
if points >= 200:
    badges += "gold "
print(badges.strip())
--- options
silver
bronze
* bronze silver
bronze silver gold
--- explain
These are three **separate** `if` statements, not an `elif` chain, so Python asks all three questions. 120 passes the first two, so both badges are added. If the second and third were `elif`, only `bronze` would be awarded.
```

Choose deliberately:

| You want… | Use |
|---|---|
| exactly one category (grade, price tier, shipping rate) | one `if`/`elif`/`else` chain |
| every rule that applies (badges, warnings, discounts that stack) | separate `if` statements |

## Truthiness in conditions

A condition doesn''t have to be a comparison. Python accepts any value and uses its truthiness, which you met in lesson 7: `0`, `0.0` and `""` count as false, and nearly everything else counts as true. That makes "is this empty?" checks short and readable:

```python run
nickname = "   "

if nickname.strip():
    print("Hello,", nickname.strip())
else:
    print("Please choose a nickname.")
```

`nickname.strip()` removes the spaces and leaves `""`, which is falsy, so the `else` runs. Try `nickname = "  Leo "`.

> **Pitfall:** When comparing text that came from a person, normalize it first. `answer == "yes"` is `False` for `"Yes"` or `"yes "`. Write `answer.strip().lower() == "yes"` instead.

## Debug: the missing receipt total

Indentation decides which lines belong to a block, so one extra indent can quietly move a line *inside* an `if` where it only runs sometimes. This is one of the most common beginner bugs, because the code still runs without any error.

```python debug id=receipt-indent title="Small orders get no total"
subtotal = 30

if subtotal >= 100:
    discount = subtotal * 0.10
    print(f"Big order! You saved ${discount:.2f}")
    total = subtotal - discount
    print(f"Total to pay: ${total:.2f}")
--- solution
subtotal = 30
discount = 0

if subtotal >= 100:
    discount = subtotal * 0.10
    print(f"Big order! You saved ${discount:.2f}")

total = subtotal - discount
print(f"Total to pay: ${total:.2f}")
--- test
assert "Total to pay" in _stdout, "A $30 order printed no total at all. Which lines only run when the order is $100 or more?"
assert total == 30, f"With no discount, `total` should be 30, but it is {total!r}."
small = _rerun(subtotal=45)
assert small.get("total") == 45 and "Total to pay: $45.00" in small["_out"], "A $45 order should print `Total to pay: $45.00`."
assert "saved" not in small["_out"], "Only orders of $100 or more should print the savings message."
big = _rerun(subtotal=200)
assert big.get("total") == 180, f"A $200 order gets 10% off, so `total` should be 180, but it is {big.get(''total'')!r}."
assert "saved $20.00" in big["_out"] and "Total to pay: $180.00" in big["_out"], "A $200 order should print both the savings line and `Total to pay: $180.00`."
--- hint
Run it with `subtotal = 30`: nothing prints at all. Then set `subtotal = 150`: both lines print. So the total lines are only running for big orders.
--- hint
Move the two `total` lines out of the `if` block (un-indent them). Then `discount` needs a value even when the `if` doesn''t run: give it a starting value of `0` before the `if`.
```

## One-line decisions: conditional expressions

When all you''re doing is choosing between **two values**, a full `if`/`else` block can feel like a lot of ceremony. Python has a compact form called a **conditional expression**:

```python
value_if_true if condition else value_if_false
```

It reads almost like English, and it produces a value you can store, print or put in an f-string:

```python run
lives = 0
status = "Game over" if lives == 0 else "Keep playing"
print(status)

stock = 3
print(f"{stock} left" if stock > 0 else "Sold out")
```

Use it for short, simple choices. As soon as there are three outcomes, or each branch needs several lines, go back to a normal `if`/`elif`/`else`. Readability wins.

> **Coming from Excel:** a conditional expression is Python''s version of `=IF(A1=0, "Game over", "Keep playing")`, just with the condition in the middle.

```python exercise id=plural-items title="1 item, 2 items"
count = 1

# TODO: set `label` to "1 item" when count is 1,
# and to "<count> items" otherwise (e.g. "0 items", "3 items").
# Try a conditional expression: ... if ... else ...
label = ...

print("Your basket:", label)
--- solution
count = 1

label = "1 item" if count == 1 else f"{count} items"

print("Your basket:", label)
--- test
assert label is not ..., "Replace `label = ...` with your expression."
assert isinstance(label, str), f"`label` should be text like \"1 item\", but it is {label!r}."
assert label == "1 item", f"With count = 1, `label` should be \"1 item\" but is {label!r}."
for c, want in [(0, "0 items"), (2, "2 items"), (7, "7 items"), (1, "1 item")]:
    got = _rerun(count=c).get("label")
    assert got == want, f"With count = {c}, `label` should be {want!r} but is {got!r}."
--- hint
Only one case is special: exactly 1. Everything else (including 0) gets an "s".
--- hint
Shape: `label = "1 item" if count == 1 else ...`. For the else part, an f-string can put the number in: `f"{count} items"`.
```

> **In the wild:** Decision logic is everywhere in professional code. A web framework like Django checks `if request.method == "POST":` to decide whether a form was submitted. A data script says `if row_count == 0:` to warn about an empty file. The patterns are exactly the ones you just wrote: guard checks, `elif` chains for categories, and short conditional expressions for labels.

## Recap

- `if condition:` runs its indented **block** only when the condition is true. Lines after the block always run.
- **Indentation is grammar** in Python: 4 spaces per level, and a missing indent is an `IndentationError`.
- `else` handles "everything else"; `elif` adds more choices. In a chain, **the first true condition wins** and the rest are skipped, so put the strictest checks first.
- Use an `elif` chain for "exactly one category" and separate `if`s when several rules can apply. Prefer `and` over nesting when you don''t need an inner `else`.
- `a if condition else b` picks between two values in one line.

**Up next:** `while` loops, so your programs can repeat something until a goal is reached.
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z'),
('les_python_basics_3_2', 'sec_python_basics_3', 'crs_python_basics', 'while loops: repeat until done', 'interactive', 1, 960, NULL, NULL, 'Computers are spectacularly good at one thing humans hate: doing the same step again and again without getting bored. Add this week''s savings, check whether you''ve hit your goal, repeat. Ask for a password, check it, ask again. Move the game character, redraw the screen, repeat sixty times a second. Each of these is a **loop**, and the simplest loop in Python is `while`.

A `while` loop is an `if` that keeps going: *while* the condition is true, run the block, then come back and ask again. In this lesson you''ll write loops that count, compound interest until a savings goal is reached, and keep reading input until the user says stop. You''ll also learn to spot (and escape) the classic loop bugs: the loop that never ends, and the loop that stops one step too early.

```python setup
# Simulated keyboard: the browser can''t pause for typing, so input() reads queued answers.
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

Here''s a rocket countdown. Run it, then press **Debug** and step through it to watch `count` shrink:

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

Almost every `while` loop you''ll write has the same three ingredients:

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

The condition is checked **before** the first iteration too. If it''s false from the start, the body never runs at all:

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

`while` really shines when you *don''t know in advance* how many repetitions you''ll need. How many years until your savings double at 7% interest? You could do the maths with logarithms, or you could just let Python simulate it year by year:

```python run
balance = 1000
goal = 2000
years = 0

while balance < goal:
    balance = balance * 1.07     # add 7% interest
    years += 1

print(f"After {years} years you have ${balance:,.2f}")
```

The loop doesn''t care how many years it takes. It keeps compounding until the goal is reached, then stops. Change `goal` to `10_000` and run it again.

> **In the wild:** "Keep going until done" loops are everywhere in professional code: a script that retries a flaky download until it succeeds (with a limit!), a game''s main loop that runs `while running:`, and machine-learning training that continues `while error > target`. Same three ingredients every time.

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
    assert ns.get("weeks") == want, f"With goal = {g} and weekly = {w}, `weeks` should be {want} but is {ns.get(''weeks'')!r}."
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

If you ever do launch a runaway loop in this course, don''t panic: press **Stop** on the cell (or **Restart** in the top bar) to interrupt it. The debugger also stops recording after a fixed number of steps, so stepping through a runaway loop won''t freeze your page.

> **Tip:** When a loop waits for a value to reach a limit, prefer `<`, `>`, `<=` or `>=` over `!=`. A range check can''t be "jumped over"; an exact match can. And when a loop talks to the outside world (a network, a user), add a cap like `attempts < 5` so it can''t run forever.

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
    assert ns.get("years") == y, f"With rate = {r} and goal = {g}, `years` should be {y} but is {ns.get(''years'')!r}."
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
Because `n` is increased **before** it''s added, the values added are 1, 2, 3, 4 and 5, which sum to 15. If the two lines were swapped, the loop would add 0, 1, 2, 3 and 4, giving 10.
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
assert "1" in lines, f"The countdown printed {'', ''.join(lines)}. It should say 1 before \"Go!\"."
assert lines == ["5", "4", "3", "2", "1", "Go!"], f"The output should be 5, 4, 3, 2, 1, Go! on separate lines, but it was: {'', ''.join(lines)}."
three = [line.strip() for line in _rerun(seconds=3)["_out"].strip().splitlines()]
assert three == ["3", "2", "1", "Go!"], f"With seconds = 3, the output should be 3, 2, 1, Go!, but it was: {'', ''.join(three)}."
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

The next challenge is a famous puzzle called the **hailstone sequence** (or the Collatz problem). Pick any whole number. If it''s even, halve it. If it''s odd, triple it and add 1. Repeat until you reach 1. Mathematicians believe *every* starting number eventually reaches 1, but nobody has ever proved it.

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

Sometimes the loop''s job is to keep asking a person for input until they type a special "stop" value, called a **sentinel**. Because this page can''t pause for your keyboard, `input()` here reads answers you queue up with `type_answers(...)`. In a real terminal, Python waits for you to type.

```python run
type_answers("4.50", "12", "3.25", "done")

total = 0
entry = input("Price (or ''done''): ")

while entry != "done":
    total += float(entry)
    entry = input("Price (or ''done''): ")

print(f"Basket total: ${total:.2f}")
```

Look at the shape: read once **before** the loop, then read again as the **last line** of the body. The second `input()` is the update. Forget it, and `entry` never changes, so the loop never ends.

Forget the conversion from lesson 8 instead, and Python stops you on the first pass. Read the last line of this error:

```python run error
type_answers("4.50", "done")

total = 0
entry = input("Price (or ''done''): ")

while entry != "done":
    total += entry
    entry = input("Price (or ''done''): ")
```

`TypeError: unsupported operand type(s) for +=: ''int'' and ''str''`: you tried to add the text `"4.50"` to the number `0`. `input()` always returns a string, so wrap it in `float(...)` before doing maths.

### A preview: `while True` and `break`

Reading input twice (before the loop and at the end) works, but it repeats a line. Many programmers prefer a loop that runs "forever" and leaves through an exit door in the middle. `break` ends the loop immediately:

```python run
type_answers("red", "green", "quit")

while True:
    colour = input("Favourite colour (or ''quit''): ")
    if colour == "quit":
        break
    print("Nice choice:", colour.upper())

print("Bye!")
```

`while True` would loop forever on its own; the `break` is the only way out. You''ll study `break`, its partner `continue`, and when to use each in lesson 12.

```python exercise id=guess-the-number title="Guess the number"
type_answers("50", "75", "62")   # the player''s guesses, in order
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
assert ns.get("tries") == 4, f"With secret = 30 and guesses 10, 90, 40, 30, `tries` should be 4 but is {ns.get(''tries'')!r}."
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
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_python_basics_3_3', 'sec_python_basics_3', 'crs_python_basics', 'for loops and range()', 'interactive', 2, 1080, NULL, NULL, 'A `while` loop repeats *until* something happens. But a huge amount of real programming is a different kind of repetition: do something **for each** thing. For each letter in a password, check it. For each day of the month, add up the sales. For each song in a playlist, print its title. For each row of seats, label every seat.

That''s what the `for` loop is for, and it''s the loop you''ll write most often in Python. In this lesson you''ll walk through strings letter by letter, count with `range()` (forwards, backwards and in steps), build up totals and new strings with **accumulators**, and nest one loop inside another to make grids and tables. You''ll also meet the two bugs everyone hits with `for` loops: the range that stops one short, and the total that keeps getting reset.

```python setup
# Hidden checker helper: lets the tests re-run your challenge code with other starting values.
import contextlib as _contextlib, io as _io, linecache as _linecache, re as _re, sys as _sys

def _rerun(**values):
    src = "".join(_linecache.cache["<cell>"][2])
    settings = ", ".join(f"{k} = {v!r}" for k, v in values.items())
    for name, value in values.items():
        src, found = _re.subn(rf"(?m)^{name}\s*=(?!=).*$", f"{name} = {value!r}", src, count=1)
        assert found, f"Keep the line `{name} = ...` in your code so the checker can try other values."
    ns = {k: v for k, v in globals().items() if k in _SETUP_NAMES}
    out, steps = _io.StringIO(), [0]
    def guard(frame, event, arg):
        if frame.f_code.co_filename != "<cell>":
            return None
        steps[0] += 1
        if steps[0] > 200_000:
            raise AssertionError(f"With {settings}, your loop never stopped.")
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

## For each letter in a string

A string is a sequence of characters, and a `for` loop can walk through it one character at a time:

```python run
for letter in "PYTHON":
    print("Give me a", letter + "!")

print("What does that spell?")
```

Read the first line as *"for each `letter` in `"PYTHON"`…"*. Python takes the first character, `"P"`, puts it in the variable `letter`, and runs the indented block. Then it takes `"Y"`, puts it in `letter`, runs the block again, and so on until the string runs out. You choose the variable name; `letter`, `ch` and `char` are all common.

```text
"PYTHON"   P    Y    T    H    O    N
           │    │    │    │    │    │
letter =   P →  Y →  T →  H →  O →  N  → (no more) → loop ends
```

Compare it with the `while` version you''d write after lesson 10. Same result, but you have to manage an index yourself:

```python run
word = "PYTHON"
i = 0
while i < len(word):
    print(word[i], end=" ")
    i += 1
print()

for letter in word:
    print(letter, end=" ")
print()
```

The `for` loop has no start, no condition and no update for you to get wrong. Python handles all three: it starts at the beginning, stops at the end, and moves forward by itself. That''s why a `for` loop can''t accidentally run forever over a string.

> **Under the hood:** Anything a `for` loop can walk through is called an **iterable**. Strings are iterables, and so are `range()`, lists, dictionaries, files and many more you''ll meet later. One kind of loop works for all of them.

## For each item in a short list

You can also loop over a few values written in square brackets. That''s a **list**, which you''ll learn properly in lesson 13. For now, just use it as "these values, one at a time":

```python run
for song in ["Intro", "Golden Hour", "Midnight Drive", "Outro"]:
    print("Now playing:", song)
```

The pattern is identical: each value in turn is stored in `song` and the block runs once per value.

```python exercise id=vowel-free title="Text-speak: drop the vowels"
message = "see you tomorrow"

# TODO: build `short` by looping over `message` and keeping
# every character EXCEPT the vowels a, e, i, o, u (in either case).
# Spaces and other characters stay. "see you tomorrow" -> "s y tmrrw"
short = ""

print(short)
--- solution
message = "see you tomorrow"

short = ""
for ch in message:
    if ch.lower() not in "aeiou":
        short += ch

print(short)
--- test
assert isinstance(short, str), f"`short` should be a string, but it is {short!r}."
assert short != "", "`short` is still empty. Loop over `message` and add each non-vowel character to `short`."
assert short == "s y tmrrw", f"`short` should be \"s y tmrrw\", but it is {short!r}."
for text in ["Python is fun", "AEIOU and sometimes Y", "rhythm", "Ice Cream On Ice"]:
    want = "".join(c for c in text if c.lower() not in "aeiou")
    got = _rerun(message=text).get("short")
    assert got == want, f"With message = {text!r}, `short` should be {want!r} but is {got!r}. Are capital vowels removed too?"
--- hint
Start with an empty string, then inside the loop use `+=` to glue on the characters you want to keep.
--- hint
`ch.lower() not in "aeiou"` is `True` for any character that is not a vowel, whatever its case.
```

## `range()`: counting made easy

To repeat something a set number of times, or to loop over numbers, use `range()`. It produces a sequence of whole numbers on demand:

```python run
for i in range(5):
    print("Push-up number", i)
```

`range(5)` gives **0, 1, 2, 3, 4**: five numbers, starting at 0, stopping *before* 5. That "stop before" rule is the same one you met with string slicing (`text[0:5]` stops before index 5), and it''s the single most important thing to remember about `range`.

`range` has three forms:

| Call | Numbers produced | Read it as |
|---|---|---|
| `range(5)` | 0 1 2 3 4 | five numbers, from 0 |
| `range(1, 6)` | 1 2 3 4 5 | from 1, up to but **not including** 6 |
| `range(0, 20, 5)` | 0 5 10 15 | from 0, in steps of 5, stopping before 20 |
| `range(10, 0, -1)` | 10 9 8 … 1 | from 10, counting **down**, stopping before 0 |
| `range(3, 3)` | *(nothing)* | start ≥ stop: the loop body never runs |

When you want "1 to 10 inclusive", write `range(1, 11)`. The stop value is one past the last number you want.

```python run
for floor in range(1, 6):
    print("Floor", floor, end="  ")
print()

for countdown in range(10, 0, -1):
    print(countdown, end=" ")
print("Happy New Year!")
```

```python predict id=predict-range-step title="Stepping through a range"
for i in range(2, 10, 3):
    print(i, end=" ")
--- options
2 5 8 11
* 2 5 8
3 6 9
2 3 4 5 6 7 8 9
--- explain
Start at 2, then add 3 each time: 2, 5, 8. The next would be 11, which is not below the stop value 10, so the range ends at 8. (The trailing space printed by `end=" "` doesn''t show in the output.)
```

`range` only works with whole numbers. A very common way to trip over that is dividing with `/`, which always gives a float (lesson 4):

```python run error
pages = 10
for page in range(pages / 2):
    print("Printing page", page)
```

`TypeError: ''float'' object cannot be interpreted as an integer`. `10 / 2` is `5.0`, a float, and `range` refuses it. Use floor division, `range(pages // 2)`, or convert with `int(...)`.

## Accumulators: building up a result

Most loops don''t just print; they **build something up**: a running total, a product, a new string. The pattern is always the same:

1. Create the accumulator **before** the loop, with a starting value.
2. Update it **inside** the loop, once per item.
3. Use the result **after** the loop.

```python run
total = 0                         # 1. start empty
for day in range(1, 8):
    total += day * 1000           # 2. add this day''s distance
    print(f"Day {day}: running total {total:,} m")

print(f"Week total: {total / 1000} km")   # 3. use the result
```

The starting value depends on the job:

| Building a… | Start with | Update with |
|---|---|---|
| sum | `0` | `total += x` |
| product | `1` (multiplying by 0 would wipe it out) | `product *= x` |
| string | `""` | `text += piece` |

Building a string works the same way. Here the new letter goes on the *front* each time, which reverses the word:

```python run
word = "stressed"
backwards = ""
for letter in word:
    backwards = letter + backwards
print(backwards)
```

> **Tip:** Lost in a loop? Press **Debug** and step through it. Watching an accumulator change in the Variables table, one iteration at a time, makes almost every loop bug obvious.

```python exercise id=bookshelf-orders title="Arranging the bookshelf"
books = 5

# How many different orders can you arrange `books` books on a shelf?
# It''s 1 x 2 x 3 x ... x books (for 5 books: 1 x 2 x 3 x 4 x 5 = 120).
# TODO: give `arrangements` a sensible starting value, then use a
# for loop over range(...) to multiply it by every number from 1 to books.
arrangements = ...

print(books, "books can be arranged in", arrangements, "ways")
--- solution
books = 5

arrangements = 1
for n in range(1, books + 1):
    arrangements *= n

print(books, "books can be arranged in", arrangements, "ways")
--- test
assert arrangements is not ..., "Replace `arrangements = ...` with a starting value, then add a for loop."
assert isinstance(arrangements, int), f"`arrangements` should be a whole number, but it is {arrangements!r}."
assert arrangements != 0, "`arrangements` is 0. Anything multiplied by 0 stays 0. What should a product start at?"
assert arrangements != 24, "`arrangements` is 24, which is 1 x 2 x 3 x 4. Your range stops one number too early."
assert arrangements == 120, f"5 books can be arranged in 120 ways, but `arrangements` is {arrangements}."
for b in [1, 3, 7, 10]:
    want = 1
    for k in range(2, b + 1):
        want *= k
    got = _rerun(books=b).get("arrangements")
    assert got == want, f"With books = {b}, `arrangements` should be {want} but is {got!r}."
--- hint
A product accumulator starts at 1, because multiplying by 1 changes nothing.
--- hint
You need the numbers 1 up to *and including* `books`. Remember that `range` stops before its stop value.
--- hint
`for n in range(1, books + 1):` then `arrangements *= n` inside the loop.
```

```python debug id=pushup-challenge title="The 30-day challenge only counts 29 days"
# Day 1: 10 push-ups. Every day after that: 2 more than the day before.
# How many push-ups in total over the whole challenge?
days = 30
total = 0

for day in range(1, days):
    pushups = 10 + 2 * (day - 1)
    total += pushups

print("Total push-ups:", total)
--- solution
# Day 1: 10 push-ups. Every day after that: 2 more than the day before.
# How many push-ups in total over the whole challenge?
days = 30
total = 0

for day in range(1, days + 1):
    pushups = 10 + 2 * (day - 1)
    total += pushups

print("Total push-ups:", total)
--- test
assert total != 1102, "The total is still 1102, which leaves out the final day. Which day numbers does your range produce?"
assert total == 1170, f"Over 30 days the total should be 1170 push-ups, but `total` is {total}."
assert day == days, f"The last day the loop ran was day {day}, but the challenge lasts {days} days."
for d in [1, 7, 14]:
    want = sum(10 + 2 * (k - 1) for k in range(1, d + 1))
    got = _rerun(days=d).get("total")
    assert got == want, f"With days = {d}, `total` should be {want} but is {got!r}."
--- hint
Press **Debug** and step to the end. What is the value of `day` on the last pass?
--- hint
`range(1, days)` stops *before* `days`. How do you make it include the last day?
```

## `for` or `while`?

Both loops repeat, so how do you choose? Ask: *do I know what I''m looping over?*

| Situation | Loop |
|---|---|
| each character of a string, each item of a collection | `for` |
| a known number of times (10 rounds, days 1–30) | `for` with `range` |
| until something happens (goal reached, user types "quit", guess is right) | `while` |
| you can''t know the number of repetitions in advance | `while` |

When either would work, prefer `for`. It''s shorter, and since Python manages the counting, it can''t turn into an infinite loop.

## The loop variable after the loop

The loop variable is an ordinary variable. When the loop ends, it keeps the **last value** it was given:

```python predict id=predict-loop-var-after title="What''s left in the loop variable?"
for i in range(3):
    print("tick", end=" ")
print(i)
--- options
3
* tick tick tick 2
tick tick tick 3
tick tick tick
--- explain
`range(3)` produces 0, 1 and 2, so after printing three ticks the loop ends with `i` still holding its last value, `2`. It never becomes 3, because 3 is never produced by the range.
```

> **Pitfall:** If the loop runs zero times (say `range(0)` or an empty string), the loop variable is never created. Using it after the loop then raises a `NameError`. Don''t rely on the loop variable after the loop unless you''re sure the loop ran.

## Accumulator bugs: start before, update inside

Where you put the starting line matters just as much as the update. This program is supposed to add up a week of step counts:

```python debug id=weekly-steps-reset title="The weekly total only counts Sunday"
# Steps walked each day, Monday to Sunday
daily_steps = [8200, 10450, 6300, 12000, 9100, 7600, 11250]

for steps in daily_steps:
    total = 0
    total += steps

print("Total steps this week:", total)
--- solution
# Steps walked each day, Monday to Sunday
daily_steps = [8200, 10450, 6300, 12000, 9100, 7600, 11250]

total = 0
for steps in daily_steps:
    total += steps

print("Total steps this week:", total)
--- test
assert total != 11250, "The total is 11250, which is only Sunday''s steps. Each pass throws the earlier days away. Which line does that?"
assert total == 64900, f"The week''s total should be 64900, but `total` is {total}."
for week in [[1000, 2000, 3000], [5000], [100, 200, 300, 400, 500, 600, 700]]:
    got = _rerun(daily_steps=week).get("total")
    assert got == sum(week), f"With daily_steps = {week}, `total` should be {sum(week)} but is {got!r}."
--- hint
Press **Debug** and watch `total` as the loop runs. What happens to it at the start of every pass?
--- hint
`total = 0` is inside the loop, so it resets the total on every pass. The starting value should be set once, before the loop begins.
```

## Nested loops: loops inside loops

A loop''s body can contain another loop. For **each** pass of the outer loop, the inner loop runs **all the way through**. That''s exactly what you need for anything shaped like a grid: rows and seats, days and hours, a times table.

```python run
for row in "ABC":
    for seat in range(1, 5):
        print(f"{row}{seat}", end=" ")
    print()          # after each row, start a new line
```

The inner loop prints one row of seats on a single line (`end=" "` keeps them together). The plain `print()` is indented under the *outer* loop, so it runs once per row and moves to the next line. Getting that indentation right is the whole trick of nested loops.

Patterns work the same way: the inner loop''s range can even depend on the outer loop variable.

```python run
for row in range(1, 5):
    for star in range(row):
        print("*", end="")
    print()
```

```python predict id=predict-nested-count title="How many times does the inner line run?"
count = 0
for i in range(3):
    for j in range(4):
        count += 1
print(count)
--- options
7
* 12
3
4
--- explain
The outer loop runs 3 times, and *each time* the inner loop runs 4 times, so the inner line runs 3 × 4 = 12 times. Nested loops multiply; that''s why they can get slow on big inputs.
```

```python exercise id=times-table title="Print a times table"
size = 4

# TODO: use two nested for loops to print a size x size times table,
# one row per line, with the numbers separated by spaces.
# For size = 4 the output is:
#   1 2 3 4
#   2 4 6 8
#   3 6 9 12
#   4 8 12 16
# (Lining the columns up with an f-string like f"{n:4}" is a nice extra.)
--- solution
size = 4

for row in range(1, size + 1):
    for col in range(1, size + 1):
        print(f"{row * col:4}", end="")
    print()
--- test
def _table(text):
    return [line.split() for line in text.splitlines() if line.strip()]

def _expected(n):
    return [[str(r * c) for c in range(1, n + 1)] for r in range(1, n + 1)]

got = _table(_stdout)
assert got, "Nothing was printed yet. Use two nested `for` loops with `range` to print the table."
assert len(got) == size, f"The table should have {size} rows (one per line), but {len(got)} lines were printed. Is your plain `print()` indented under the outer loop?"
assert got == _expected(size), f"The rows should be {['' ''.join(r) for r in _expected(size)]}, but they were {['' ''.join(r) for r in got]}."
for n in [3, 6]:
    rows = _table(_rerun(size=n)["_out"])
    assert rows == _expected(n), f"With size = {n}, the table isn''t right. The first row printed was {'' ''.join(rows[0]) if rows else ''nothing''}."
--- hint
The outer loop picks the row number (1 to `size`), and the inner loop goes through the column numbers (1 to `size`). Each cell is `row * col`.
--- hint
Inside the inner loop, print one product with `end=" "` so it stays on the same line. After the inner loop finishes (but still inside the outer loop), call `print()` to start a new line.
```

> **In the wild:** `for` loops over `range` and over collections are the bread and butter of everyday scripts: renaming every file in a folder, sending a reminder to each person on a list, processing every row of a spreadsheet. Data libraries like pandas run their fastest loops in compiled code behind the scenes, but the mental model is the same one you just practised: for each item, do something.

## Recap

- `for item in iterable:` runs the block once **for each** item, storing it in the loop variable. Strings give you one character at a time.
- `range(stop)`, `range(start, stop)` and `range(start, stop, step)` produce whole numbers; the **stop value is never included**. Count down with a negative step.
- Accumulators start **before** the loop (`0` for sums, `1` for products, `""` for strings) and update **inside** it.
- Use `for` when you know what you''re looping over; use `while` when you''re waiting for something to happen.
- Nested loops run the inner loop completely for every pass of the outer loop, which is perfect for grids and tables.

**Up next:** loop patterns: counting matches, finding the biggest value, searching, and stepping out early with `break` and `continue`.
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z'),
('les_python_basics_3_4', 'sec_python_basics_3', 'crs_python_basics', 'Loop patterns: counting, searching, break and continue', 'interactive', 3, 1200, NULL, NULL, 'Here''s a secret experienced programmers rarely say out loud: almost every loop they write is one of about half a dozen **patterns**. Count the things that match. Find the biggest. Search until you find it. Stop early once you know the answer. Skip the junk. Keep asking until the input is valid. Once you can recognize these shapes, you stop inventing loops from scratch and start *assembling* them, and your code gets faster to write and much easier to read.

In this lesson you''ll learn each pattern with a real example, plus the three keywords that give you fine control over a loop: `break` (stop now), `continue` (skip to the next item) and the curious `for…else` (run this only if the search came up empty). You''ll also fix two classic bugs: announcing "not found" too early, and a `continue` that skips the line the loop depends on.

```python setup
# Simulated keyboard: the browser can''t pause for typing, so input() reads queued answers.
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

To count how many items pass a test, start a counter at 0 and add 1 whenever the test is true. It''s an accumulator (lesson 11) with an `if` in front of the update.

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

`None` means "no value yet", but you can''t compare it with a number. That''s why the condition says `hottest is None or temp > hottest`: thanks to short-circuiting (lesson 7), the comparison is skipped while `hottest` is still `None`. Leave that check out and Python complains on the first pass:

```python run error
coldest = None
for temp in [12, 8, 15]:
    if temp < coldest:
        coldest = temp
```

`TypeError: ''<'' not supported between instances of ''int'' and ''NoneType''`: you asked whether 12 is less than "nothing", which has no answer.

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
assert longest != "", "`longest` is still empty. Loop over `sentence.split()` and keep the longest word you''ve seen so far."
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

"Is this item anywhere in here?" sounds simple, but there''s a trap: you only know the answer is **no** after checking *every* item. A single mismatch tells you nothing. The fix is a **flag**: a boolean that starts `False` and flips to `True` when you find a match. You make the decision *after* the loop.

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

```python debug id=no-flights-too-early title="It says ''no flights'' even when there is one"
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
assert "Sorry" not in _stdout, f"Lisbon IS a destination, but your code still printed: {lines[0] if lines else ''nothing''}. Can you decide \"no flights\" after checking just one city?"
assert lines == ["Good news: we fly to Lisbon"], f"The program should print exactly one line, \"Good news: we fly to Lisbon\", but printed {len(lines)} line(s)."
out = [l for l in _rerun(wanted="Tokyo")["_out"].strip().splitlines() if l.strip()]
assert out == ["Sorry, no flights to Tokyo"], f"With wanted = \"Tokyo\", it should print \"Sorry, no flights to Tokyo\" exactly once, but printed: {out}."
out = [l for l in _rerun(wanted="Oslo")["_out"].strip().splitlines() if l.strip()]
assert out == ["Good news: we fly to Oslo"], f"With wanted = \"Oslo\" (the last city), it should print only the good news, but printed: {out}."
--- hint
Run it: you get one "Sorry" for Paris before Lisbon is even checked, and more after it. One city not matching doesn''t mean no city matches.
--- hint
Use a flag: `found = False` before the loop, set it to `True` on a match, and move the good news / sorry decision to *after* the loop.
```

## `break`: stop as soon as you know

Once a search finds what it''s looking for, there''s no point checking the rest. `break` ends the loop immediately and jumps to the first line after it.

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

A number is **prime** if nothing except 1 and itself divides it evenly. That''s a search: look for a divisor, and if the search comes up empty, the number is prime.

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

`continue` abandons the **current** pass and jumps straight back to the top of the loop for the next item. It''s handy for skipping junk without wrapping the rest of the body in an extra `if`.

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
assert passes != 1000, "The loop hit the safety cap of 1000 passes, so it''s stuck. Press Debug and watch: does `n` ever change?"
assert total == 37, f"1 to 10 without 3, 6 and 9 adds up to 37, but `total` is {total}." + (" Is 10 included?" if total == 27 else "")
for lim in [20, 5, 1]:
    want = sum(k for k in range(1, lim + 1) if k % 3 != 0)
    ns = _rerun(limit=lim)
    assert ns.get("total") == want, f"With limit = {lim}, `total` should be {want} but is {ns.get(''total'')!r}."
--- hint
Press **Debug** and watch `n`. It starts at 0, and 0 is a multiple of 3, so `continue` runs. Which line never gets reached?
--- hint
The update `n += 1` must happen on every pass, including the skipped ones. Move it above the `if`, so `continue` can''t jump over it. (Check that 10 is still included in the total.)
```

## Pattern 4: `while True` until the input is valid

You previewed this in lesson 10. When a program needs a valid answer from a person, it should keep asking until it gets one. The cleanest shape is a loop that runs "forever" with a `break` as the exit door. As in lesson 10, `input()` here reads answers queued with `type_answers(...)`, because this page can''t pause for your keyboard.

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
#   if it''s correct: set unlocked = True, print "Unlocked!" and stop asking
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
assert ns.get("attempts") == 3, f"With three wrong PINs, the loop should stop after 3 attempts, but `attempts` is {ns.get(''attempts'')!r}."
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

`break` leaves the **innermost** loop it''s in, not every loop around it. Here the inner loop stops at the first free seat in a row, but the outer loop carries on to the next row anyway:

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

> **In the wild:** When nested searches get complicated, professionals usually move the search into a **function** and use `return` to exit every loop at once. You''ll learn functions in lesson 19, and this is one of the reasons they''re so useful.

## Recap

- **Count:** start at 0, add 1 inside an `if`. **Find the best:** keep a "best so far" (start with `None` or the first value, never a made-up number).
- **Search:** use a flag, and decide "not found" only **after** the loop has checked everything.
- `break` stops a loop immediately; `continue` skips to the next pass. In a `while` loop, make sure `continue` can''t skip the update.
- `for…else` runs the `else` block only if the loop finished **without** `break`: a built-in "not found".
- `while True` + `break` (with a limit where it matters) is the standard shape for "keep asking until the input is valid".

**Up next:** lists, Python''s ordered collections. You''ve been looping over them already; now you''ll create, change and grow them yourself.
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z'),
('les_python_basics_3_5', 'sec_python_basics_3', 'crs_python_basics', 'Checkpoint: decisions & loops', 'quiz', 4, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"Which numbers does `range(1, 10, 3)` produce?","options":["1, 4, 7, 10","3, 6, 9","1, 4, 7","1, 2, 3, 4, 5, 6, 7, 8, 9"],"answerIndex":2,"explanation":"Start at 1 and add 3 each time: 1, 4, 7. The next value, 10, is not below the stop value, and `range` never includes its stop value."},{"id":"q2","prompt":"`score = 85`. The chain is `if score >= 60:` → `grade = \"D\"`, then `elif score >= 80:` → `grade = \"B\"`, then `else:` → `grade = \"F\"`. What is `grade` afterwards?","options":["\"B\"","\"D\"","\"D\" and then \"B\", so it ends as \"B\"","\"F\""],"answerIndex":1,"explanation":"In an `if`/`elif`/`else` chain, only the first true branch runs. `85 >= 60` is already true, so `grade` becomes \"D\" and the rest of the chain is skipped. Put the strictest check (the highest threshold) first."},{"id":"q3","prompt":"What does the expression `\"even\" if 7 % 2 == 0 else \"odd\"` evaluate to?","options":["\"even\"","True","1","\"odd\""],"answerIndex":3,"explanation":"`7 % 2` is 1, so the condition `7 % 2 == 0` is False and the conditional expression produces the value after `else`: \"odd\"."},{"id":"q4","prompt":"A `while` loop''s condition is already False the very first time Python checks it. How many times does the loop body run?","options":["0 times","Once, because the body always runs before the check","Forever","It raises an error"],"answerIndex":0,"explanation":"A `while` loop checks its condition before every pass, including the first. If it''s False from the start, the body is skipped entirely and Python moves on."},{"id":"q5","prompt":"This loop never ends: `while balance < goal:` with a body that only does `new_balance = balance * 1.05`. Which fix is right?","options":["Change the condition to `while balance <= goal:`","Add `print(new_balance)` inside the loop","Update the variable the condition checks: `balance = balance * 1.05`","Put `balance = 0` inside the loop"],"answerIndex":2,"explanation":"The condition looks at `balance`, but the body never changes `balance`, so the condition can never become False. Every loop needs an update that moves it toward ending."},{"id":"q6","prompt":"When does the `else` block of a `for...else` loop run?","options":["When the loop body raises an error","Only when the loop finishes without hitting `break`","After every iteration where the `if` inside the loop was False","Always, after the loop ends"],"answerIndex":1,"explanation":"Read `for...else` as \"for... if no break\". It runs once, after the loop, only if the loop went through every item without breaking out. That makes it a built-in \"not found\" for searches."},{"id":"q7","prompt":"A program adds up a week of sales with a `for` loop, but the printed total is always just the last day''s sales. What is the most likely bug?","options":["The `range` stops one day too early","`+=` should be `=+`","The `print` is inside the loop","`total = 0` is inside the loop, so it resets on every pass"],"answerIndex":3,"explanation":"An accumulator must be created once, before the loop. If `total = 0` sits inside the body, each pass wipes out everything added so far, leaving only the final day."},{"id":"q8","prompt":"An outer loop `for i in range(4):` contains an inner loop `for j in range(5):`, whose body is `count += 1`. If `count` starts at 0, what is it at the end?","options":["20","9","5","4"],"answerIndex":0,"explanation":"For each of the 4 outer passes, the inner loop runs all 5 times, so the inner line runs 4 × 5 = 20 times. Nested loops multiply."},{"id":"q9","prompt":"A `break` statement sits inside an inner loop, which is nested inside an outer loop. What happens when it runs?","options":["Both loops stop immediately","The whole program stops","Only the inner loop stops; the outer loop continues with its next pass","The inner loop skips to its next item"],"answerIndex":2,"explanation":"`break` only leaves the innermost loop it''s in. To stop the outer loop as well, set a flag before breaking and check it in the outer loop (or, later, `return` from a function)."},{"id":"q10","prompt":"A search loop has `if city == wanted:` print \"found\", `else:` print \"not found\". For a list where the match is the 3rd city, it prints \"not found\" twice before \"found\". What''s the right fix?","options":["Swap the `if` and `else` blocks","Use a flag (or `for...else`) and only decide \"not found\" after the loop has checked every city","Add `continue` after the \"not found\" print","Change `==` to `!=`"],"answerIndex":1,"explanation":"One mismatch doesn''t mean there''s no match anywhere. Set `found = False` before the loop, set it to True on a match, and print the result after the loop (or use `break` with `for...else`)."}]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z'),
('les_python_basics_4_1', 'sec_python_basics_4', 'crs_python_basics', 'Lists: ordered collections', 'interactive', 0, 1080, NULL, NULL, 'So far, every variable you''ve made has held **one** value: one price, one name, one temperature. But real programs juggle many values at once. A playlist has dozens of songs. A shopping cart has a handful of items. A week of weather is seven temperatures. Making `song1`, `song2`, `song3`… by hand doesn''t scale, and you couldn''t loop over them anyway.

A **list** solves this. It''s one name for a whole ordered row of values that you can index, slice, loop over, grow and change. Lists are the most used collection in Python. By the end of this lesson you''ll build lists from scratch, update them in place, compute totals and averages, and even store a grid like a cinema seat map.

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

Lists can hold any kind of value, including a mix of kinds, and they can be empty. An empty list `[]` is the usual starting point when you''re about to collect things.

```python run
cart = []                                  # nothing in it yet
temperatures = [18.5, 21.0, 19.8, 23.4]    # floats
order = ["coffee", 2, 3.5, True]           # mixed: str, int, float, bool

print("cart:", cart, "length", len(cart))
print("temperatures:", temperatures)
print("order:", order)
```

> **Tip:** Mixed lists are legal, but in practice most lists hold one *kind* of thing: all prices, all names, all scores. That makes them easy to loop over and sum. When you want to bundle different facts about one thing (a name, an age, a city), you''ll meet better tools in the next few lessons: tuples and dictionaries.

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

Ask for a position that doesn''t exist and Python stops with an `IndexError`. A seven-day list has positions `0` to `6`, so `7` is one past the end:

```python run error
week = [14, 17, 21, 19, 23, 25, 16]
print("items:", len(week))
print(week[7])
```

Read the last line of the error first: `IndexError: list index out of range`. The traceback''s line number points at `week[7]`. Whenever you see this, ask "how long is the list, and which position did I ask for?" Slices, by contrast, are forgiving: `week[5:100]` quietly stops at the end of the list.

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

Here''s the big difference from strings. Strings are **immutable**: `name[0] = "J"` is a `TypeError`. Lists are **mutable**: you can replace any item by assigning to its position, and the list changes in place.

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

> **Under the hood:** a list doesn''t really store its items "inside" itself. Each box holds a reference to a value that lives elsewhere in memory. Assigning `groceries[1] = "oat milk"` points box 1 at a different value. This detail matters a lot in the next lesson, when two names end up pointing at the *same* list.

```python predict id=predict-mutate title="Change one letter"
letters = list("cat")
letters[0] = "b"
print(letters, len(letters))
--- options
bat 3
* [''b'', ''a'', ''t''] 3
[''bat''] 1
[''b'', ''cat''] 2
--- explain
`list("cat")` splits the string into a list of single characters, `[''c'', ''a'', ''t'']`. Assigning to position `0` replaces `''c''` with `''b''`. It''s still a list (Python prints lists with brackets and quotes around strings), and it still has 3 items. To glue the letters back into a string you''d use `"".join(letters)` from lesson 6.
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
assert isinstance(leaderboard, list) and len(leaderboard) == 5, f"`leaderboard` should still be a list of 5 names, but it is {leaderboard!r}. Replace Chloe; don''t add or remove anyone."
assert "Chloe" not in leaderboard, "Chloe is still on the leaderboard. Assign a new name to her position with `leaderboard[2] = ...`."
assert leaderboard == ["Ava", "Ben", "Farah", "Dev", "Emma"], f"`leaderboard` should be [''Ava'', ''Ben'', ''Farah'', ''Dev'', ''Emma''] but is {leaderboard!r}. Remember positions start at 0."
assert winner == "Ava", f"`winner` should be the first name on the leaderboard, but is {winner!r}. The first position is 0, not 1."
assert last_place == "Emma", f"`last_place` should be the last name, but is {last_place!r}. Try index -1."
assert isinstance(podium, list), f"`podium` should be a list (a slice), but it''s a {type(podium).__name__}."
assert podium == ["Ava", "Ben", "Farah"], f"`podium` should be the first three names after the swap, but is {podium!r}. The slice stops *before* its end index."
--- hint
Assigning to a position looks like assigning to a variable, with the index in brackets on the left: `some_list[position] = new_value`.
--- hint
Index `0` is the first item and `-1` is the last. A slice like `[:3]` takes positions 0, 1 and 2.
--- hint
TODO 1 is `leaderboard[2] = "Farah"`. Do it *before* building `podium`, so the podium includes Farah.
```

## Checking membership and looping

The `in` operator asks "is this value somewhere in the list?" and gives a `bool`, just like it did for strings. And a `for` loop visits every item in order, which you''ve already been doing with literal lists since lesson 11.

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

`range(len(dishes))` produces `0, 1, 2`: exactly the valid positions, because `range` stops *before* its end, and a list of length 3 ends at position 2. That''s the same "stop is excluded" rule as slices, and it''s why the two fit together so neatly.

> **Tip:** If you only need the items, loop over the list directly (`for dish in dishes`). It''s shorter and can''t go out of range. In lesson 22 you''ll meet `enumerate()` and `zip()`, which make the "position plus item" and "two lists side by side" cases even cleaner.

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
assert oldest == "latte", f"`oldest` should be the first order, ''latte'', but is {oldest!r}."
assert newest == "flat white", f"`newest` should be the last order, ''flat white'', but is {newest!r}."
assert "Most recent: flat white" in _stdout, "Keep the print lines so the barista sees the most recent order."
--- hint
Run it and read the last line of the error. How many orders are there, and which positions exist?
--- hint
The list has 5 items, so its positions are 0 to 4. `len(orders)` is 5: one past the end. You want the position just before that, or the "count from the back" index.
```

## Building a list with `append`

Most lists aren''t typed out by hand. They''re **built up** while a program runs: start with an empty list, then add to the end with `.append(value)`. It''s the list version of the accumulator pattern from lesson 11.

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

`.append()` is a **method**, an action the list knows how to do, just like `.upper()` is an action a string knows. But there''s a key difference. String methods return a *new* string and leave the original alone. List methods like `.append()` **change the list itself**. That''s mutability at work, and it''s why you write `bargains.append(price)` on its own line, not `bargains = bargains.append(price)`. You''ll see exactly what goes wrong with that second version in the next lesson.

> **In the wild:** "start with `[]`, loop, `append`" is everywhere in real code: collecting the rows of a spreadsheet that match a filter, gathering error messages to show a user all at once, or saving each day''s reading from a sensor. In lesson 18 you''ll learn a one-line shortcut for it, the list comprehension.

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

# TODO: compute these from `minutes` (don''t type the answers in by hand).
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

A list can hold other lists. That''s the natural way to store anything with rows and columns: a game board, a seating chart, a calendar month, a spreadsheet.

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

To visit every square, nest two loops: the outer loop walks the rows, the inner loop walks the squares in the current row. It''s the same nested-loop shape as the multiplication table in lesson 11.

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
assert isinstance(seats, list) and len(seats) == 3 and all(isinstance(r, list) and len(r) == 4 for r in seats), "`seats` should still be 3 rows of 4 seats. Change one seat, don''t replace whole rows."
assert seats[1][2] == "X", f"Row 1, column 2 should now be ''X'', but it''s {seats[1][2]!r}. Index the row first, then the column: `seats[row][col]`."
changed = [(r, c) for r in range(3) for c in range(4) if seats[r][c] != original[r][c]]
assert changed == [(1, 2)], f"Only the seat at row 1, column 2 should change, but these changed: {changed}. Check the order of your indexes."
expected_free = sum(row.count("O") for row in seats)
assert free != expected_free + 1, f"`free` is {free}: that''s the count from *before* your booking. Count after marking the seat."
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

print(f"{''TOTAL'':<8} ${total:>6.2f}")
--- solution
items = ["milk", "cheese", "bread", "coffee"]
prices = [4.50, 12.00, 3.25, 8.75]

total = 0
for i in range(len(prices)):
    print(f"{items[i]:<8} ${prices[i]:>6.2f}")
    total += prices[i]

print(f"{''TOTAL'':<8} ${total:>6.2f}")
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
- Indexing and slicing work exactly like strings: positions start at 0, `-1` is the last item, and a slice''s stop is excluded. A position past the end raises `IndexError`; the last valid index is `len(lst) - 1`.
- Lists are **mutable**: `lst[i] = value` replaces an item in place, and `.append(value)` adds to the end. Start with `[]` and append in a loop to build a list.
- `in` checks membership, `for item in lst` visits every item, and `range(len(lst))` gives every valid position.
- `sum`, `min`, `max` and `len` summarize a list of numbers; `list("abc")` and `list(range(5))` turn other things into lists.
- Lists can hold lists. Access a grid with `grid[row][col]` and visit every cell with two nested loops.

**Up next:** working with lists: methods like `insert`, `pop` and `remove`, sorting with `sort()` and `sorted()`, and the surprising way two names can share one list.
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_python_basics_4_2', 'sec_python_basics_4', 'crs_python_basics', 'Working with lists: methods, sorting and copies', 'interactive', 1, 1080, NULL, NULL, 'A list isn''t just a container; it''s a little machine with buttons. Push a button and it inserts an item at the front, pulls one off the end, finds where something is, or sorts itself into order. Those buttons are **list methods**, and with about a dozen of them you can run a to-do app, a queue at a coffee shop, or a leaderboard.

This lesson also covers the most surprising thing about lists, the one that trips up beginners and professionals alike: two names can point at the **same** list, so changing "one" changes "both". Once you can picture why, you''ll know exactly when to make a copy, and you''ll be able to spot three classic list bugs on sight.

## Adding items: `append`, `insert` and `extend`

You already know `.append(item)`, which adds one item to the end. Two siblings fill in the gaps: `.insert(position, item)` squeezes an item in **before** the given position, and `.extend(other_list)` adds every item of another list to the end.

```python run
queue = ["Ana", "Ben"]

queue.append("Cleo")              # one item, at the end
print("append:", queue)

queue.insert(0, "Dana (VIP)")     # before position 0, i.e. at the front
print("insert:", queue)

queue.extend(["Eli", "Fay"])      # every item from another list
print("extend:", queue)
```

All three **change the list in place** and give back nothing useful. Mutating methods are like pressing a button on the machine: the machine changes, and there''s no new machine handed back to you.

> **Pitfall:** `append` always adds exactly **one** item, even if that item is a whole list. If you `append` a list, you get a list *inside* your list. Use `extend` to add the items one by one.

```python predict id=predict-append-extend title="append a list"
cart = ["bread", "jam"]
cart.append(["tea", "honey"])
print(cart, len(cart))
--- options
[''bread'', ''jam'', ''tea'', ''honey''] 4
* [''bread'', ''jam'', [''tea'', ''honey'']] 3
[''bread'', ''jam'', [''tea'', ''honey'']] 4
[''bread'', ''jam'', ''tea'', ''honey''] 3
--- explain
`append` adds its argument as **one** item, so the whole list `[''tea'', ''honey'']` becomes the third item of `cart`, nested inside it. The length is 3. `cart.extend(["tea", "honey"])` would have added the two strings separately, for a length of 4.
```

## Removing items: `remove`, `pop` and `clear`

There are two ways to say which item should go: by **value** or by **position**.

| Method | Removes | Gives back | If it can''t |
|---|---|---|---|
| `lst.remove(value)` | the **first** item equal to `value` | `None` | `ValueError` |
| `lst.pop()` | the **last** item | the removed item | `IndexError` on an empty list |
| `lst.pop(i)` | the item at position `i` | the removed item | `IndexError` |
| `lst.clear()` | everything | `None` | (never fails) |

```python run
playlist = ["Intro", "Hey Jude", "Yesterday", "Hey Jude", "Outro"]

playlist.remove("Hey Jude")     # only the FIRST match goes
print("after remove:", playlist)

last = playlist.pop()           # take the last one off, and keep it
print("popped:", last, "| left:", playlist)

first = playlist.pop(0)         # take the item at position 0
print("popped:", first, "| left:", playlist)
```

`pop` is the only remover that **hands the item back**, which makes it perfect for "take the next thing to work on": the next customer in a queue, the top card from a deck, the most recent action to undo.

Asking `remove` for something that isn''t there is an error, not a silent no-op:

```python run error
basket = ["apple", "banana", "cherry"]
basket.remove("mango")
```

The last line says `ValueError` and tells you the item isn''t in the list. When you''re not sure an item is present, check first: `if "mango" in basket: basket.remove("mango")`.

## Finding items: `index` and `count`

`.index(value)` tells you the position of the first match (and raises `ValueError` if there''s none). `.count(value)` tells you how many times a value appears (and happily returns `0`).

```python run
rolls = [3, 6, 2, 6, 6, 1, 4]     # dice rolls in a board game

print("first six at position:", rolls.index(6))
print("number of sixes:", rolls.count(6))
print("number of fives:", rolls.count(5))

if 5 in rolls:
    print("first five at:", rolls.index(5))
else:
    print("no fives rolled")
```

```python exercise id=todo-shuffle title="Reorganize a to-do list"
todo = ["email Sam", "buy milk", "gym", "pay rent"]

# TODO 1: "pay rent" is urgent. Move it to the FRONT of the list
#         (take it out, then put it back in at position 0).
...

# TODO 2: The gym session got cancelled. Remove "gym".
...

# TODO 3: Add "call mom" and then "water plants" to the end.
...

# TODO 4: You finish the first task. Take it off the front of the
#         list with a method that gives it back, and store it in `finished`.
finished = ...

print("Finished:", finished)
print("Still to do:", todo)
--- solution
todo = ["email Sam", "buy milk", "gym", "pay rent"]

todo.remove("pay rent")
todo.insert(0, "pay rent")

todo.remove("gym")

todo.extend(["call mom", "water plants"])

finished = todo.pop(0)

print("Finished:", finished)
print("Still to do:", todo)
--- test
assert finished is not ..., "Replace the `...` after `finished =` with code that takes the first task off the list."
assert isinstance(todo, list), "`todo` should still be a list."
assert "gym" not in todo, "\"gym\" is still on the list. Remove it with `.remove(...)`."
assert "pay rent" not in todo or todo.count("pay rent") != 1 or todo[0] != "pay rent", "\"pay rent\" is at the front, but you haven''t finished it yet. TODO 4 should pop the first task off the list."
assert todo.count("pay rent") <= 1, "\"pay rent\" appears more than once. Remove it before inserting it at the front."
assert "call mom" in todo and "water plants" in todo, "Add both \"call mom\" and \"water plants\" to the end of the list."
assert finished == "pay rent", f"`finished` should be the first task after moving \"pay rent\" to the front, but it''s {finished!r}. Did TODO 1 put it at position 0? Did you pop position 0, not the end?"
assert todo == ["email Sam", "buy milk", "call mom", "water plants"], f"`todo` should be [''email Sam'', ''buy milk'', ''call mom'', ''water plants''], but is {todo!r}."
--- hint
Each TODO is one method (TODO 1 is two). `remove` takes a value, `insert` takes a position and a value, and `extend` adds several items at once.
--- hint
`pop()` with no argument takes the **last** item. To take the first, give it a position: `pop(0)`.
--- hint
TODO 1 is `todo.remove("pay rent")` then `todo.insert(0, "pay rent")`. TODO 4 is `finished = todo.pop(0)`.
```

## Sorting: `sort()` versus `sorted()`

Python gives you two ways to sort, and the difference between them is one of the most important ideas in this lesson.

- `lst.sort()` is a **method**: it rearranges the list **in place** and returns `None`.
- `sorted(lst)` is a **built-in function**: it leaves the original alone and returns a **new**, sorted list.

Both accept `reverse=True` for largest-first order.

```python run
scores = [72, 95, 88, 61, 99]

ranked = sorted(scores, reverse=True)   # new list; scores unchanged
print("ranked:", ranked)
print("scores:", scores)

scores.sort()                           # rearranges scores itself
print("scores after .sort():", scores)
```

The trap is that `.sort()` *looks* like it should give you the sorted list back. It doesn''t. It follows the same rule as `append`, `insert` and `remove`: methods that change a list in place return `None`, as a reminder that nothing new was created.

```python predict id=predict-sort-none title="What does sort() return?"
nums = [3, 1, 2]
result = nums.sort()
print(result, nums)
--- options
[1, 2, 3] [3, 1, 2]
[1, 2, 3] [1, 2, 3]
* None [1, 2, 3]
None [3, 1, 2]
--- explain
`.sort()` rearranges `nums` **in place** and returns `None`, so `result` is `None` while `nums` itself is now sorted. If you want a sorted copy as a value, use `sorted(nums)` instead.
```

| | `lst.sort()` | `sorted(lst)` |
|---|---|---|
| Changes the original? | yes | no |
| Returns | `None` | a new list |
| Works on | lists only | anything you can loop over (strings, ranges, …) |
| Use when | you''re done with the old order | you need to keep the original |

### Sorting by a key

Strings sort by their characters'' codes, which puts **every uppercase letter before every lowercase letter**. That''s rarely what people want. The `key=` argument tells Python what to compare *instead* of the items themselves. You pass the name of a function **without parentheses**, and Python calls it on each item for you.

```python run
names = ["bella", "Zoe", "adam", "Carlos"]

print("default:      ", sorted(names))                  # capitals first!
print("ignoring case:", sorted(names, key=str.lower))   # compare lowercase versions
print("by length:    ", sorted(names, key=len))         # compare len(name)
```

With `key=str.lower`, Python sorts as if every name were lowercase, but the list it returns still holds the original names. With `key=len`, it compares lengths. You''ll do much more with `key=` in lesson 22, including writing your own tiny key functions.

`.reverse()` is a simpler cousin: it flips the list in place without sorting anything (and, yes, returns `None`). The slice `lst[::-1]` gives you a reversed **copy** instead.

```python run
history = ["home", "news", "sports", "weather"]   # pages visited, oldest first

newest_first = history[::-1]    # a reversed copy
print("copy:    ", newest_first)

history.reverse()               # flips history itself
print("in place:", history)
```

```python exercise id=sort-guest-list title="Sort the guest list"
guests = ["zoe", "Maximilian", "Adam", "bella", "Carlos"]

# TODO 1: `alphabetical` is a NEW list of the guests in A-Z order,
#         ignoring upper/lower case (so "Adam" comes before "bella").
alphabetical = ...

# TODO 2: `longest_first` is a NEW list of the guests ordered by the
#         length of their name, longest name first.
longest_first = ...

# `guests` itself must stay in its original order.
print("A-Z:", alphabetical)
print("Longest first:", longest_first)
print("Original:", guests)
--- solution
guests = ["zoe", "Maximilian", "Adam", "bella", "Carlos"]

alphabetical = sorted(guests, key=str.lower)

longest_first = sorted(guests, key=len, reverse=True)

print("A-Z:", alphabetical)
print("Longest first:", longest_first)
print("Original:", guests)
--- test
assert alphabetical is not ... and longest_first is not ..., "Replace the `...` after `alphabetical =` and `longest_first =` with sorted lists."
assert alphabetical is not None and longest_first is not None, "One of your lists is `None`. `.sort()` returns None; `sorted(...)` returns a new list."
assert guests == ["zoe", "Maximilian", "Adam", "bella", "Carlos"], f"`guests` changed to {guests!r}. Use `sorted(...)`, which leaves the original alone, instead of `.sort()`."
assert isinstance(alphabetical, list) and sorted(alphabetical) == sorted(guests), f"`alphabetical` should contain the same five names as `guests`, but is {alphabetical!r}."
assert alphabetical != sorted(guests), "Capital letters are sorting before lowercase ones. Sort with `key=str.lower` to ignore case."
assert alphabetical == sorted(guests, key=str.lower), f"`alphabetical` should be in A-Z order ignoring case, but is {alphabetical!r}."
assert isinstance(longest_first, list) and sorted(longest_first) == sorted(guests), f"`longest_first` should contain the same five names as `guests`, but is {longest_first!r}."
lengths = [len(n) for n in longest_first]
assert lengths != sorted(lengths), "Your names go from shortest to longest. Add `reverse=True`."
assert lengths == sorted(lengths, reverse=True), f"`longest_first` should be ordered by name length, longest first. The lengths are {lengths}."
--- hint
You need new lists and must keep `guests` untouched, so reach for the built-in `sorted(...)`, not the `.sort()` method.
--- hint
`sorted` takes `key=` (what to compare) and `reverse=True` (largest first). Useful keys here: `str.lower` and `len`, written without parentheses.
--- hint
`alphabetical = sorted(guests, key=str.lower)`. For the second, sort by `len` and reverse.
```

```python debug id=top-scores-none title="The top scores crash with a NoneType error"
scores = [72, 95, 88, 61, 99, 84]

# Sort best-first, then take the top three for the podium.
scores = scores.sort(reverse=True)
top_three = scores[:3]

print("Top three:", top_three)
--- solution
scores = [72, 95, 88, 61, 99, 84]

scores.sort(reverse=True)
top_three = scores[:3]

print("Top three:", top_three)
--- test
assert scores is not None, "`scores` is None. `.sort()` sorts in place and returns None, so don''t assign its result back to `scores`."
assert isinstance(scores, list) and sorted(scores) == [61, 72, 84, 88, 95, 99], f"`scores` should still hold all six scores, but is {scores!r}."
assert top_three == [99, 95, 88], f"`top_three` should be [99, 95, 88], but is {top_three!r}."
assert "[99, 95, 88]" in _stdout, "Print the top three so the podium can be announced."
--- hint
Run it and read the error: `''NoneType'' object is not subscriptable` means you tried `[...]` on `None`. Which line turned `scores` into `None`?
--- hint
`.sort()` changes the list in place and returns `None`. Either call it on a line of its own, or use `sorted(...)`, which returns a new list.
```

## Two names, one list

Here''s the surprise. Run this and look at `weekday_menu`:

```python run
weekday_menu = ["soup", "salad"]
weekend_menu = weekday_menu          # looks like a copy... it isn''t

weekend_menu.append("pancakes")

print("weekend:", weekend_menu)
print("weekday:", weekday_menu)      # pancakes on a Tuesday?!
print("same list?", weekend_menu is weekday_menu)
```

Remember the mental model from lesson 3: a variable is a **name tag** on a value. `weekend_menu = weekday_menu` doesn''t copy anything. It sticks a second name tag on the **same** list. Mutate the list through either name and both names see the change. This is called **aliasing**.

```text
weekday_menu ──┐
               ├──► ["soup", "salad", "pancakes"]     one list, two name tags
weekend_menu ──┘
```

`is` asks "are these the very same object?", while `==` asks "do these hold equal values?". Two separate lists with the same items are `==` but not `is`.

Strings and numbers never surprised you like this because they''re immutable: you can''t change them in place, only rebind a name to a new value. Aliasing only bites with **mutable** values, such as lists (and, soon, dictionaries and sets).

### Making a real copy

When you want an independent list, ask for a copy. These three are equivalent:

```python run
original = ["flour", "sugar", "eggs"]

copy_a = original.copy()
copy_b = original[:]          # a slice of everything
copy_c = list(original)       # build a new list from it

copy_a.append("butter")
print("original:", original)
print("copy_a:  ", copy_a)
print("equal values?", copy_b == original, "| same object?", copy_b is original)
```

> **Tip:** Pick one style and stick with it. `.copy()` is the most readable, because it says exactly what you mean.

```python predict id=predict-alias title="The backup that wasn''t"
original = [10, 20, 30]
backup = original
original.append(40)
print(len(backup), backup is original)
--- options
3 False
3 True
4 False
* 4 True
--- explain
`backup = original` doesn''t copy anything: both names point at **one** list. Appending through `original` changes that list, so `backup` sees 4 items too, and `backup is original` is `True`. A real backup would be `backup = original.copy()`.
```

```python debug id=draft-menu-alias title="Editing the draft changes the published menu"
# The restaurant''s live menu, as customers see it.
menu = ["soup", "salad", "steak"]

# Start next month''s draft from the current menu, then edit the draft.
draft = menu
draft.append("tiramisu")
draft[0] = "gazpacho"

print("Published menu:", menu)
print("Draft menu:    ", draft)
--- solution
menu = ["soup", "salad", "steak"]

draft = menu.copy()
draft.append("tiramisu")
draft[0] = "gazpacho"

print("Published menu:", menu)
print("Draft menu:    ", draft)
--- test
assert menu == ["soup", "salad", "steak"], f"The published `menu` changed to {menu!r}. Customers shouldn''t see the draft edits yet!"
assert draft is not menu, "`draft` and `menu` are still the same list. Make `draft` an independent copy."
assert draft == ["gazpacho", "salad", "steak", "tiramisu"], f"`draft` should be [''gazpacho'', ''salad'', ''steak'', ''tiramisu''], but is {draft!r}."
--- hint
Run it: the published menu has tiramisu on it. `draft = menu` didn''t create a second list; it created a second *name*.
--- hint
Give `draft` its own list to edit: `.copy()`, `[:]` or `list(...)` all work.
```

### The grid that copies itself

Aliasing hides in one more place: building a grid with `*`. Multiplying a list repeats its items, so `[0] * 3` is `[0, 0, 0]`. But `[row] * 3` repeats the **same row object** three times:

```python run
bad = [[0] * 3] * 3          # three name tags on ONE row
bad[0][0] = 1
print("bad: ", bad)          # every row changed!

good = []
for r in range(3):
    good.append([0] * 3)     # a brand-new row each time round the loop
good[0][0] = 1
print("good:", good)
```

The loop version creates a fresh `[0] * 3` on every pass, so each row is its own list. (`[0] * 3` is fine on its own, because numbers are immutable.)

> **Under the hood:** `.copy()` is a **shallow** copy: it makes a new outer list, but the items inside are the same objects as before. For a list of numbers or strings that''s all you need. For a grid, `grid.copy()` gives you a new outer list holding the *same* rows, so copy each row too: build a new list and `append(row.copy())` for every row.

## Don''t change a list while you loop over it

A `for` loop over a list walks through it by position: item 0, item 1, item 2, and so on. If you remove items as you go, everything after the removed item shifts one place left, and the loop skips over whatever slid into the gap.

```python run
nums = [2, 4, 5, 6, 8]
for n in nums:
    if n % 2 == 0:
        nums.remove(n)      # removing while looping over nums

print(nums)                 # expected [5]... but evens survived
```

Use **Debug** on that cell and watch: after `2` is removed, `4` slides into position 0, and the loop moves on to position 1 (the `5`), never seeing the `4`.

The safe patterns are:

1. **Build a new list** of the items you want to keep (the `[]` + loop + `append` pattern), then use it.
2. **Loop over a copy** (`for n in nums[:]:`) while removing from the original.

```python run
nums = [2, 4, 5, 6, 8]

odds = []
for n in nums:
    if n % 2 != 0:
        odds.append(n)
nums = odds

print(nums)
```

> **In the wild:** this exact bug shows up in real scripts that clean up data: removing blank rows from a spreadsheet, finished jobs from a queue, or expired sessions from a server. It''s so common that some languages throw an error when you try it. Python doesn''t, so it''s on you to spot it.

```python debug id=expired-coupons title="Some expired coupons survive the cleanup"
coupons = ["SAVE10", "EXPIRED-A", "EXPIRED-B", "FREESHIP", "EXPIRED-C"]

# Remove every coupon whose code starts with "EXPIRED".
for code in coupons:
    if code.startswith("EXPIRED"):
        coupons.remove(code)

print("Valid coupons:", coupons)
--- solution
coupons = ["SAVE10", "EXPIRED-A", "EXPIRED-B", "FREESHIP", "EXPIRED-C"]

for code in coupons[:]:
    if code.startswith("EXPIRED"):
        coupons.remove(code)

print("Valid coupons:", coupons)
--- test
assert isinstance(coupons, list), "`coupons` should still be a list of coupon codes."
left = [c for c in coupons if c.startswith("EXPIRED")]
assert not left, f"These expired coupons are still in `coupons`: {left}. The loop is skipping items."
assert coupons == ["SAVE10", "FREESHIP"], f"`coupons` should be [''SAVE10'', ''FREESHIP''] (valid ones, in order), but is {coupons!r}."
assert "FREESHIP" in _stdout and "EXPIRED" not in _stdout, "Print the cleaned-up list of valid coupons."
--- hint
Run it, then **Debug** it and watch which `code` the loop visits right after it removes "EXPIRED-A".
--- hint
Removing an item shifts the rest left, so the loop skips the next one. Either loop over a copy (`coupons[:]`), or build a new list of the valid codes and assign it back to `coupons`.
```

## Recap

- `append` adds one item, `insert(i, x)` adds before position `i`, and `extend` adds every item of another list. `remove(value)` deletes the first match, `pop()` / `pop(i)` removes **and returns** an item, and `clear()` empties the list.
- `index` finds a position and `count` counts matches. `remove` and `index` raise `ValueError` when the value is missing, so check with `in` first.
- `lst.sort()` sorts **in place and returns `None`**; `sorted(lst)` returns a **new** list. Both take `reverse=True` and `key=` (like `key=len` or `key=str.lower`).
- `b = a` makes two names for **one** list. Use `a.copy()`, `a[:]` or `list(a)` for an independent copy, and build grids with a loop, not `[[0] * n] * n`.
- Never remove from a list while looping over it. Build a new list, or loop over a copy.

**Up next:** tuples and unpacking: fixed-size records you can''t accidentally change, and a neat way to pull several values out at once.
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z'),
('les_python_basics_4_3', 'sec_python_basics_4', 'crs_python_basics', 'Tuples and unpacking', 'interactive', 2, 840, NULL, NULL, 'Some data comes in fixed shapes. A map location is always a latitude and a longitude. A colour on screen is always red, green and blue. A date is a year, a month and a day. You don''t `append` a fourth number to a GPS position, and you definitely don''t want some other part of your program to quietly change one.

For data like this Python has the **tuple**: an ordered, **unchangeable** bundle of values, like a sealed envelope with a few facts inside. Tuples come with a superpower called **unpacking**, which lets you pull every piece out into its own named variable in a single line. You''ve already used it without knowing: `a, b = 1, 2` from lesson 3 was a tuple in disguise.

## Making tuples

Write a tuple with **parentheses** instead of square brackets. Indexing, slicing, `len()`, `in` and `for` loops all work exactly as they do on lists.

```python run
lisbon = (38.72, -9.14)            # (latitude, longitude)
orange = (255, 165, 0)             # (red, green, blue)
launch_day = (2026, 3, 14)         # (year, month, day)

print("latitude:", lisbon[0])
print("green channel:", orange[1])
print("year and month:", launch_day[:2])
print("is 0 in orange?", 0 in orange)
launch_day
```

The chip reads `tuple · len 3`. And notice that slicing a tuple gives you another tuple, `(2026, 3)`, just as slicing a list gives you a list.

Here''s a detail that surprises people: it''s the **comma** that makes a tuple, not the parentheses. The parentheses are mostly there for readability.

```python run
screen = 1920, 1080          # no parentheses, still a tuple
print(screen, type(screen))

empty = ()                   # the empty tuple is the exception: just ()
print(empty, len(empty))
```

### The one-item tuple needs a comma

Because parentheses also group maths, like `(2 + 3) * 4`, Python reads `("pizza")` as just the string `"pizza"` in brackets. To make a tuple with one item, add a trailing comma:

```python run
just_text = ("pizza")
one_tuple = ("pizza",)

print(type(just_text), len(just_text))   # a str of 5 characters
print(type(one_tuple), len(one_tuple))   # a tuple holding 1 item
```

It looks a little odd the first time, but it''s the only way: `(x,)` is a one-item tuple.

```python predict id=predict-one-tuple title="Is it a tuple?"
t = (5)
u = (5,)
print(type(t), type(u))
--- options
<class ''tuple''> <class ''tuple''>
* <class ''int''> <class ''tuple''>
<class ''int''> <class ''int''>
<class ''tuple''> <class ''int''>
--- explain
`(5)` is just the number 5 inside grouping parentheses, the same as writing `5`. Only the **comma** turns it into a tuple, so `(5,)` is a one-item tuple.
```

## Tuples can''t be changed

Once a tuple is made, its items are fixed. There''s no item assignment, no `append`, no `remove`, no `sort`.

```python run error
orange = (255, 165, 0)
orange[1] = 140
```

The error is `TypeError: ''tuple'' object does not support item assignment`, the same complaint you got when you tried to change a character in a string. Tuples are **immutable**, like strings and numbers, and unlike lists.

That might sound like a limitation. It''s actually the point:

- **Safety.** You can pass a tuple anywhere in your program and know nothing will alter it behind your back. That''s exactly the aliasing bug from the last lesson, made impossible.
- **Meaning.** A tuple tells the reader "this is a fixed record of a few related facts", while a list says "this is a collection that might grow or shrink".
- **Usable as keys.** Because they can''t change, tuples can be used where Python needs values that stay put, such as dictionary keys and set members. You''ll use that in the next two lessons.

If you need a "changed" tuple, you build a new one and rebind the name, exactly as you do with strings:

```python run
orange = (255, 165, 0)
darker = (orange[0], 140, orange[2])     # build a new tuple
print("original:", orange)
print("darker:  ", darker)

scores = (8, 9, 7, 9, 10)
print("count of 9s:", scores.count(9), "| first 9 at:", scores.index(9))
```

Tuples have just two methods, `count` and `index`, because every other list method would change the tuple.

> **Under the hood:** a tuple can''t change *which* objects it holds, but if one of those objects is mutable, that object can still change. `team = ("Reds", ["Ana", "Ben"])` can''t swap out the list, yet `team[1].append("Cleo")` works. In practice, tuples usually hold numbers and strings, so this rarely matters.

## Unpacking: one line, many names

**Unpacking** assigns each item of a tuple to its own variable, in order. The number of names on the left must match the number of items on the right.

```python run
reading = ("Reykjavik", 3.5, 82)          # (city, temperature, humidity)

city, temp, humidity = reading            # three names, three items
print(city, "is", temp, "degrees with", humidity, "% humidity")

# Swapping is just packing and unpacking at once:
home, away = "Lions", "Tigers"
home, away = away, home
print("home:", home, "| away:", away)
```

Look again at that swap. The right side, `away, home`, first **packs** the two current values into a tuple. Then the left side **unpacks** that tuple into the two names. That''s why you never need a temporary variable to swap in Python.

Unpacking works on any sequence, not just tuples: lists and strings unpack too. If the counts don''t match, you get a `ValueError`:

```python run error
reading = ("Reykjavik", 3.5, 82)
city, temp = reading
```

Read the last line: `ValueError: too many values to unpack (expected 2, got 3)`. Python tells you exactly how many names it had and how many values it found. Three items, two names, and Python refuses to guess which one to drop. With too few items you''d see `not enough values to unpack` instead.

```python predict id=predict-rotate title="Rotate three values"
a, b, c = 1, 2, 3
a, b, c = c, a, b
print(a, b, c)
--- options
1 2 3
3 3 3
* 3 1 2
2 3 1
--- explain
The right side is evaluated **first**, building the tuple `(3, 1, 2)` from the *old* values. Only then are the names reassigned: `a` gets 3, `b` gets 1, `c` gets 2. No value gets overwritten before it''s used, which is why this "rotate" works in one line.
```

```python exercise id=unpack-flight title="Unpack a flight record"
# (flight code, from, to, hours, minutes)
flight = ("BA117", "London", "New York", 7, 45)

# TODO 1: unpack `flight` into five variables in ONE line:
#         code, origin, destination, hours, minutes
...

# TODO 2: `total_minutes` is the whole flight time in minutes.
total_minutes = ...

# TODO 3: `route` is a tuple of just the two places: (origin, destination)
route = ...

print("total minutes:", total_minutes)
print("route:", route)
--- solution
flight = ("BA117", "London", "New York", 7, 45)

code, origin, destination, hours, minutes = flight

total_minutes = hours * 60 + minutes

route = (origin, destination)

print("total minutes:", total_minutes)
print("route:", route)
--- test
assert total_minutes is not ... and route is not ..., "Replace each `...` with your code: unpack `flight` first (TODO 1), then fill in `total_minutes` and `route`."
assert code == "BA117" and origin == "London" and destination == "New York", "Unpack `flight` so that `code`, `origin` and `destination` hold its first three items, in order."
assert hours == 7 and minutes == 45, f"`hours` and `minutes` should be 7 and 45, but are {hours!r} and {minutes!r}."
assert total_minutes == flight[3] * 60 + flight[4], f"`total_minutes` should be {flight[3] * 60 + flight[4]}, but is {total_minutes!r}. Turn the hours into minutes, then add the extra minutes."
assert isinstance(route, tuple), f"`route` should be a tuple, but it''s a {type(route).__name__}. Use parentheses and a comma."
assert route == ("London", "New York"), f"`route` should be (''London'', ''New York''), but is {route!r}."
--- hint
Unpacking puts several names on the left of a single `=`, separated by commas, with the tuple on the right.
--- hint
TODO 1 is `code, origin, destination, hours, minutes = flight`. Then use those names for TODO 2 and 3: an hour has 60 minutes.
--- hint
`route = (origin, destination)`, with the comma between the two names.
```

## Star unpacking: "and the rest"

Sometimes you care about the first item (or the last) and want everything else bundled together. Put a `*` in front of one name, and it collects all the leftover items **as a list**:

```python run
finish_times = [41.2, 43.8, 44.0, 47.5, 52.1]   # minutes, fastest first

winner, *others = finish_times
print("winner:", winner, "| others:", others)

*everyone_else, last = finish_times
print("last place:", last)

first, *middle, final = finish_times
print("middle of the pack:", middle)
```

Only one name per unpacking can have a star, and the starred name is always a list, even if it ends up empty or with a single item.

```python predict id=predict-star title="Star-unpack a string"
first, *middle, last = "python"
print(first, middle, last)
--- options
p ytho n
* p [''y'', ''t'', ''h'', ''o''] n
p (''y'', ''t'', ''h'', ''o'') n
p y n
--- explain
A string unpacks one character at a time. `first` takes `''p''`, `last` takes `''n''`, and the starred name collects everything in between. A starred name **always becomes a list**, so `middle` is `[''y'', ''t'', ''h'', ''o'']`, not a string or a tuple.
```

```python exercise id=race-podium title="Medals and the rest of the field"
# Runners in the order they crossed the finish line.
finishers = ["Kim", "Luis", "Mia", "Noah", "Omar", "Pia", "Quinn"]

# TODO 1: In ONE line, unpack `finishers` into `gold`, `silver`, `bronze`
#         and a starred name `others` that collects everyone else.
...

# TODO 2: `podium` is a tuple of the three medallists, in order.
podium = ...

print("Podium:", podium)
--- solution
finishers = ["Kim", "Luis", "Mia", "Noah", "Omar", "Pia", "Quinn"]

gold, silver, bronze, *others = finishers

podium = (gold, silver, bronze)

print("Podium:", podium)
print("Others:", others)
--- test
assert podium is not ..., "Replace each `...` with your code: unpack `finishers` first (TODO 1), then build the `podium` tuple."
assert gold == "Kim" and silver == "Luis" and bronze == "Mia", f"`gold`, `silver` and `bronze` should be the first three finishers, but are {gold!r}, {silver!r}, {bronze!r}."
assert isinstance(others, list), f"`others` should be a list (that''s what a starred name gives you), but it''s a {type(others).__name__}."
assert others == finishers[3:], f"`others` should hold everyone after the podium, {finishers[3:]}, but is {others!r}."
assert isinstance(podium, tuple), f"`podium` should be a tuple, but it''s a {type(podium).__name__}."
assert podium == ("Kim", "Luis", "Mia"), f"`podium` should be (''Kim'', ''Luis'', ''Mia''), but is {podium!r}."
--- hint
List the names you want on the left of `=`, in finishing order. One of them gets a `*` to collect the leftovers.
--- hint
TODO 1 looks like `gold, silver, bronze, *others = finishers`. TODO 2 packs three names back into a tuple with parentheses and commas.
```

## Getting several results back at once

Tuples are how Python hands you **more than one result** from a single operation. The built-in `divmod(a, b)` computes `a // b` and `a % b` together and returns them as a pair. Unpack it straight away and each result gets a good name:

```python run
print("divmod gives:", divmod(135, 60))

hours, minutes = divmod(135, 60)          # 135 minutes of film
print(f"Running time: {hours}h {minutes}m")

user, _, domain = "maria@example.com".partition("@")
print("user:", user, "| domain:", domain)
```

`.partition(sep)` is another string method that returns a tuple: the part before the separator, the separator itself, and the part after. The `_` is a convention every Python programmer recognises: "there''s a value here, but I don''t need it".

> **In the wild:** this "return a tuple, unpack it on the spot" pattern is everywhere. A function that looks up a user might return `(found, user)`; a sensor reading might return `(value, unit)`. In lesson 19 you''ll write your own functions that `return total, average` and get unpacked in exactly this way.

## Tuples in loops

A list of tuples is one of the most common shapes of data in Python: each tuple is one **record** (one row of a table), and the list holds all the records. Unpack each tuple right in the `for` line, and every column gets its own name:

```python run
results = [("Ana", 91), ("Ben", 78), ("Cleo", 85), ("Dev", 94)]

best_name, best_score = results[0]
for name, score in results:
    print(f"{name:<5} {score:>3}")
    if score > best_score:
        best_name, best_score = name, score

print("Top student:", best_name, "with", best_score)
```

Compare `for name, score in results` with the alternative, `for r in results:` followed by `r[0]` and `r[1]`. Same behaviour, but the unpacked version reads like a sentence.

```python exercise id=warmest-city title="Find the warmest city"
# (city, temperature in Celsius) at noon today
readings = [
    ("Oslo", 4.5),
    ("Cairo", 31.2),
    ("Lima", 19.8),
    ("Sydney", 24.6),
    ("Toronto", 11.0),
]

# TODO: loop over `readings`, unpacking each tuple in the for line, and work out:
#   warmest       -> the name of the warmest city
#   warmest_temp  -> its temperature
#   above_20      -> a list of the cities warmer than 20 degrees, in order
warmest = ...
warmest_temp = ...
above_20 = ...

print(f"Warmest: {warmest} ({warmest_temp}°C)")
print("Above 20°C:", above_20)
--- solution
readings = [
    ("Oslo", 4.5),
    ("Cairo", 31.2),
    ("Lima", 19.8),
    ("Sydney", 24.6),
    ("Toronto", 11.0),
]

warmest, warmest_temp = readings[0]
above_20 = []
for city, temp in readings:
    if temp > warmest_temp:
        warmest, warmest_temp = city, temp
    if temp > 20:
        above_20.append(city)

print(f"Warmest: {warmest} ({warmest_temp}°C)")
print("Above 20°C:", above_20)
--- test
assert warmest is not ... and warmest_temp is not ... and above_20 is not ..., "Replace each `...` with your code: start from the first reading, then loop over `readings`."
top_temp = max(t for _, t in readings)
top_city = [c for c, t in readings if t == top_temp][0]
assert warmest_temp == top_temp, f"`warmest_temp` should be the highest temperature ({top_temp}), but is {warmest_temp!r}."
assert warmest == top_city, f"`warmest` should be the city with {top_temp}°C, {top_city!r}, but is {warmest!r}. Update the name and the temperature together."
assert isinstance(above_20, list), f"`above_20` should be a list of city names, but it''s a {type(above_20).__name__}."
expected = [c for c, t in readings if t > 20]
assert above_20 == expected, f"`above_20` should be {expected}, but is {above_20!r}. Append the city name (not the whole tuple) when its temperature is over 20."
--- hint
Use the "find the max" pattern from lesson 12: start with the first reading as the best so far, then replace it whenever you see something warmer.
--- hint
Start with `warmest, warmest_temp = readings[0]` and `above_20 = []`. Then loop with `for city, temp in readings:`.
--- hint
Inside the loop you need two separate `if`s: one compares `temp` with `warmest_temp`, the other checks `temp > 20` and appends `city`.
```

```python debug id=hat-sizes-letters title="The hat comes in eight sizes, one letter each"
# Each product has a tuple of the sizes it comes in.
shirt_sizes = ("S", "M", "L", "XL")
hat_sizes = ("ONE SIZE")

for size in hat_sizes:
    print("Hat available in:", size)
print("Number of hat sizes:", len(hat_sizes))
--- solution
shirt_sizes = ("S", "M", "L", "XL")
hat_sizes = ("ONE SIZE",)

for size in hat_sizes:
    print("Hat available in:", size)
print("Number of hat sizes:", len(hat_sizes))
--- test
assert shirt_sizes == ("S", "M", "L", "XL"), "Leave `shirt_sizes` as it was."
assert isinstance(hat_sizes, tuple), f"`hat_sizes` is a {type(hat_sizes).__name__}, not a tuple. Parentheses alone don''t make a tuple."
assert hat_sizes == ("ONE SIZE",), f"`hat_sizes` should be a tuple holding the single size ''ONE SIZE'', but is {hat_sizes!r}."
assert "Hat available in: ONE SIZE" in _stdout, "The loop should print the one hat size, ''ONE SIZE'', on a single line."
assert "Number of hat sizes: 1" in _stdout, "The hat should come in exactly 1 size."
--- hint
Run it. The loop goes letter by letter, which is what looping over a **string** does. What type is `hat_sizes` really?
--- hint
`("ONE SIZE")` is just a string in brackets. What tiny character turns it into a one-item tuple?
```

```python debug id=members-unpack-crash title="Reading the member list crashes"
# Each member record is (name, city, age).
members = [("Ana", "Porto", 34), ("Ben", "Leeds", 29), ("Cleo", "Austin", 41)]

total_age = 0
for name, age in members:
    print(f"{name} is {age}")
    total_age += age

print("Average age:", round(total_age / len(members), 1))
--- solution
members = [("Ana", "Porto", 34), ("Ben", "Leeds", 29), ("Cleo", "Austin", 41)]

total_age = 0
for name, city, age in members:
    print(f"{name} is {age}")
    total_age += age

print("Average age:", round(total_age / len(members), 1))
--- test
assert total_age == 34 + 29 + 41, f"`total_age` should be {34 + 29 + 41}, but is {total_age!r}. Is `age` really the third item of each record?"
for n, c, a in members:
    assert f"{n} is {a}" in _stdout, f"The output should include the line \"{n} is {a}\"."
assert "Average age: 34.7" in _stdout, "Print the average age (34.7) at the end."
--- hint
Run it and read the last line of the error. How many items are in each tuple, and how many names does the `for` line unpack into?
--- hint
Every record has three items: name, city and age. The `for` line needs three names too. If you don''t need the city, you can call it `_`.
```

## Tuples vs. lists

| | Tuple | List |
|---|---|---|
| Written as | `("Ana", 34)` | `["Ana", "Ben"]` |
| Can change after creation? | no (immutable) | yes (mutable) |
| Typical use | a fixed **record**: a few related facts, often of different kinds | a **collection** of similar things that may grow or shrink |
| Example | `(lat, lon)`, `(r, g, b)`, `(name, score)` | a playlist, a cart, the day''s readings |
| Methods | just `count` and `index` | `append`, `insert`, `remove`, `pop`, `sort`, … |
| Usable as a dictionary key | yes | no |

A handy rule of thumb: if you''d describe the data with "and" (a name **and** a score **and** a date), it''s a tuple. If you''d describe it with "a bunch of" (a bunch of scores), it''s a list. And the two combine naturally: a **list of tuples** is a whole table of records.

## Recap

- A **tuple** is an ordered, **immutable** sequence written with parentheses: `(38.72, -9.14)`. Indexing, slicing, `len`, `in` and loops work just like lists.
- The **comma** makes the tuple. A one-item tuple needs a trailing comma, `("pizza",)`; without it you just have the value in brackets.
- Tuples can''t be changed (`TypeError` on item assignment), which makes them safe to share and usable as dictionary keys. Build a new tuple when you need a changed version.
- **Unpacking** assigns each item to a name: `city, temp = reading`. The counts must match, or you get `ValueError`. `a, b = b, a` swaps, and `first, *rest = items` collects leftovers into a list.
- Tuples carry several results at once (`hours, minutes = divmod(135, 60)`), and `for name, score in pairs:` unpacks each record of a list of tuples right in the loop.

**Up next:** dictionaries, Python''s way to look things up by key, like a phone book that finds a number from a name.
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z'),
('les_python_basics_4_4', 'sec_python_basics_4', 'crs_python_basics', 'Dictionaries: look things up by key', 'interactive', 3, 1200, NULL, NULL, 'Lists are great when position matters: the first song, the third runner, the last item in the cart. But most questions you ask about data aren''t about position. *What''s Maya''s phone number? How much does a latte cost? How many times did the word "storm" appear?* With a list you''d have to scan every item until you found the right one. With a **dictionary** you just ask for it by name.

Dictionaries are everywhere in real Python. Settings files, web API responses, database rows, word counts, shopping carts: they''re all dictionaries under the hood. By the end of this lesson you''ll be able to build them, look things up safely, count and group data with them, and read nested, JSON-shaped records like a pro.

## Key → value: a lookup table

Think of a real phone book. You don''t look up "entry number 4,213"; you look up a **name** and get back a **number**. A Python dictionary (`dict`) works the same way: it stores pairs of a **key** and a **value**, and you use the key to find the value.

```python run
prices = {"espresso": 2.5, "latte": 3.8, "mocha": 4.2}

print("A latte costs", prices["latte"])
prices
```

Curly braces `{}` make a dictionary. Inside, each entry is written `key: value`, and entries are separated by commas. To read a value, put the key in square brackets, the same brackets you used for list positions, but with a key instead of a number.

```text
prices
 ┌────────────┬───────┐
 │ "espresso" │  2.5  │      prices["latte"]  →  3.8
 │ "latte"    │  3.8  │
 │ "mocha"    │  4.2  │      key goes in, value comes out
 └────────────┴───────┘
   keys         values
```

Keys are usually strings, but numbers and tuples work too. Values can be anything at all: numbers, strings, lists, even other dictionaries.

```python run
player = {
    "name": "Ana",
    "team": "Lisbon Lions",
    "jersey": 7,
    "goals": [2, 0, 1, 3],     # a list as a value
}
empty = {}

print(player["name"], "has scored", sum(player["goals"]), "goals")
print("entries in player:", len(player))
print("entries in empty:", len(empty))
```

`len()` counts **pairs**, not keys and values separately. Writing one pair per line, with a trailing comma after the last one, is how professionals format longer dictionaries: it''s easy to read and easy to extend.

> **Coming from Excel/another language:** a dictionary is like a two-column lookup table where `VLOOKUP` is instant. In JavaScript it''s an object, in Java a `HashMap`, in PHP an associative array.

## Missing keys: KeyError and `.get()`

Ask for a key that isn''t there, and Python stops with a `KeyError`. Run this one; it fails on purpose:

```python run error
prices = {"espresso": 2.5, "latte": 3.8, "mocha": 4.2}

print(prices["cappuccino"])
```

Read the last line of the error: `KeyError: ''cappuccino''`. The message is simply the key that wasn''t found. When you see it, check for typos, capital letters (`"Latte"` and `"latte"` are different keys) and whether the entry was ever added.

When a key might legitimately be missing, use the `.get()` method instead. It returns `None` if the key is missing, or a **default** that you choose:

```python run
prices = {"espresso": 2.5, "latte": 3.8, "mocha": 4.2}

print(prices.get("latte"))
print(prices.get("cappuccino"))          # None: no crash
print(prices.get("cappuccino", 0.0))     # your chosen default
```

| Expression | Key exists | Key missing |
|---|---|---|
| `d[key]` | the value | **KeyError** |
| `d.get(key)` | the value | `None` |
| `d.get(key, default)` | the value | `default` |

> **Tip:** Use `d[key]` when the key *must* be there; a crash then points straight at the bug. Use `.get(key, default)` when missing is normal, like a product with no discount.

```python predict id=predict-get-default title="What does .get() return?"
stock = {"apples": 3, "bananas": 0}
print(stock.get("pears"), stock.get("pears", 0), stock.get("bananas", 10))
--- options
* None 0 0
0 0 10
None 0 10
KeyError: ''pears''
--- explain
`.get()` never raises. With no default, a missing key gives `None`. With a default, a missing key gives the default. But `"bananas"` **does** exist (its value just happens to be 0), so `.get("bananas", 10)` returns the real value, `0`. The default is only used when the key is missing.
```

## Adding, changing and removing entries

Dictionaries are mutable, like lists. Assigning to a key **adds** it if it''s new, or **replaces** its value if it already exists. There''s no separate "add" method.

```python run
cart = {"milk": 1, "bread": 1}

cart["eggs"] = 12          # new key: added
cart["milk"] = 2           # existing key: replaced
cart["bread"] += 1         # read, add 1, store back

print(cart)
```

To remove entries, use `del` when you just want the entry gone, or `.pop()` when you also want its value back:

```python run
cart = {"milk": 2, "bread": 2, "eggs": 12, "candy": 3}

del cart["candy"]                  # gone
eggs = cart.pop("eggs")            # gone, and you get the value
nothing = cart.pop("coffee", 0)    # missing key + default: no crash

print("removed eggs:", eggs)
print("cart now:", cart)
print("coffee popped:", nothing)
```

Notice that the dictionary printed in the order you added the keys. Since Python 3.7, dictionaries **remember insertion order**, so printing and looping always follow the order entries were added.

```python exercise id=cafe-stock title="Update the café''s stock"
stock = {"croissant": 12, "muffin": 8, "bagel": 5, "scone": 4}

# TODO 1: 3 muffins were sold. Lower the "muffin" count by 3.
# TODO 2: a delivery brought 6 bagels. Raise the "bagel" count by 6.
# TODO 3: the café now sells cookies. Add "cookie" with a count of 20.
# TODO 4: scones are discontinued. Remove "scone" with .pop()
#         and store how many were left in `removed`.
removed = ...

print(stock)
print("scones removed:", removed)
--- solution
stock = {"croissant": 12, "muffin": 8, "bagel": 5, "scone": 4}

stock["muffin"] -= 3
stock["bagel"] += 6
stock["cookie"] = 20
removed = stock.pop("scone")

print(stock)
print("scones removed:", removed)
--- test
assert isinstance(stock, dict), "`stock` should still be a dictionary."
assert stock.get("muffin") != 8, "The muffin count is still 8. Subtract the 3 that were sold: `stock[\"muffin\"] -= 3`."
assert stock.get("muffin") == 5, f"`stock[\"muffin\"]` should be 8 - 3 = 5, but it is {stock.get(''muffin'')!r}."
assert stock.get("bagel") == 11, f"`stock[\"bagel\"]` should be 5 + 6 = 11, but it is {stock.get(''bagel'')!r}."
assert "cookie" in stock, "Add a `\"cookie\"` key to `stock`."
assert stock["cookie"] == 20, f"`stock[\"cookie\"]` should be 20, but it is {stock[''cookie'']!r}."
assert removed is not ..., "Replace the `...` after `removed =` with `stock.pop(...)`."
assert "scone" not in stock, "`\"scone\"` is still in `stock`. Use `.pop()` to remove it."
assert removed == 4, f"`removed` should hold the number of scones that were left (4), but it is {removed!r}."
assert stock == {"croissant": 12, "muffin": 5, "bagel": 11, "cookie": 20}, f"`stock` should end up as croissant 12, muffin 5, bagel 11, cookie 20, but it is {stock}."
--- hint
Assigning to a key adds it or replaces it, and `+=` / `-=` work on dictionary entries just like on variables.
--- hint
`stock["muffin"] -= 3` handles TODO 1. For TODO 4, `.pop(key)` removes the key AND returns its value.
```

## `in` checks keys, not values

`in` asks "is this a **key** in the dictionary?" It does not look at values. To search values, ask the dictionary for them explicitly with `.values()`:

```python run
ages = {"Mia": 31, "Leo": 28}

print("''Mia'' in ages:         ", "Mia" in ages)
print("31 in ages:            ", 31 in ages)            # 31 is a value, not a key
print("31 in ages.values():   ", 31 in ages.values())
```

This is the classic way to avoid a KeyError: check first, then read.

```python run
prices = {"espresso": 2.5, "latte": 3.8, "mocha": 4.2}
order = "chai"

if order in prices:
    print(order, "costs", prices[order])
else:
    print("Sorry, we don''t sell", order)
```

## Looping over a dictionary

A `for` loop over a dictionary gives you its **keys**. There are three views you can loop over, depending on what you need:

| You write | Each loop gives you |
|---|---|
| `for k in d:` or `for k in d.keys():` | a key |
| `for v in d.values():` | a value |
| `for k, v in d.items():` | a `(key, value)` tuple, unpacked into two names |

`.items()` is the one you''ll use most. It''s the tuple unpacking you learned in the last lesson, applied to each pair:

```python run
temps = {"Lisbon": 24, "Oslo": 9, "Cairo": 35, "Lima": 19}

for city, temp in temps.items():
    print(f"{city:<8}{temp:>4} °C")

print("hottest reading:", max(temps.values()))
print("cities:", list(temps.keys()))
```

`sum()`, `max()`, `min()` and `sorted()` all work on `.values()` and `.keys()`, and `list(...)` turns them into a regular list when you need one.

```python exercise id=cart-total title="Ring up the shopping cart"
prices = {"apples": 0.5, "bread": 2.25, "milk": 1.2, "eggs": 3.0}
cart = {"apples": 6, "milk": 2, "eggs": 1}     # item -> quantity

# TODO: loop over cart.items(). For each item:
#   - look up its price in `prices`
#   - print a line with the item name and its cost, e.g. "apples: $3.00"
#   - add price * quantity to `total`
total = 0
...

print(f"Total: ${total:.2f}")
--- solution
prices = {"apples": 0.5, "bread": 2.25, "milk": 1.2, "eggs": 3.0}
cart = {"apples": 6, "milk": 2, "eggs": 1}

total = 0
for item, quantity in cart.items():
    cost = prices[item] * quantity
    print(f"{item}: ${cost:.2f}")
    total += cost

print(f"Total: ${total:.2f}")
--- test
assert prices == {"apples": 0.5, "bread": 2.25, "milk": 1.2, "eggs": 3.0}, "Don''t change `prices`; just read from it."
assert cart == {"apples": 6, "milk": 2, "eggs": 1}, "Don''t change `cart`; just loop over it."
expected = 0
for _item, _qty in cart.items():
    expected += prices[_item] * _qty
assert isinstance(total, (int, float)), f"`total` should be a number, but it is {total!r}."
assert total != 0, "`total` is still 0. Replace the `...` with a loop over `cart.items()` that adds to `total`."
assert abs(total - expected) < 0.001, f"`total` should be {expected:.2f}, but it is {total}. Did you multiply each price by its quantity?"
_lines = _stdout.lower()
for _item in cart:
    assert _item in _lines, f"Print a line for each item in the cart. `{_item}` is missing."
assert "bread" not in _lines, "Bread isn''t in the cart, so it shouldn''t appear on the receipt."
--- hint
`for item, quantity in cart.items():` gives you each name and its quantity. The price is in the *other* dictionary.
--- hint
Inside the loop: `cost = prices[item] * quantity`, print it, then `total += cost`.
```

## Counting with a dictionary

One of the most useful dictionary patterns: **counting** how often each thing appears. The key is the thing, the value is its count so far. For each item, read the current count (0 if it''s new), add 1, and store it back.

```python run
text = "the storm hit the coast and the storm passed"

counts = {}
for word in text.split():
    counts[word] = counts.get(word, 0) + 1

print(counts)
print("''storm'' appears", counts["storm"], "times")
```

`counts.get(word, 0)` is doing the heavy lifting: the first time a word is seen, there''s no key yet, so it returns `0` instead of crashing.

> **In the wild:** word counts, votes, page views per URL, errors per server: counting with a dictionary is something professionals write constantly. Python even ships a ready-made counting dictionary, `collections.Counter`, which you''ll meet in lesson 25.

```python debug id=vote-tally title="Counting the votes crashes"
votes = ["pizza", "tacos", "pizza", "sushi", "tacos", "pizza"]

tally = {}
for food in votes:
    tally[food] += 1

print(tally)
--- solution
votes = ["pizza", "tacos", "pizza", "sushi", "tacos", "pizza"]

tally = {}
for food in votes:
    tally[food] = tally.get(food, 0) + 1

print(tally)
--- test
assert isinstance(tally, dict), "`tally` should be a dictionary."
assert tally, "`tally` is empty. Each vote should add 1 to its food''s count."
expected = {}
for _v in votes:
    expected[_v] = expected.get(_v, 0) + 1
assert tally == expected, f"`tally` should be {expected}, but it is {tally}."
--- hint
Run it and read the last line of the error: `KeyError: ''pizza''`. What does `tally["pizza"]` hold before the first pizza vote is counted?
--- hint
`tally[food] += 1` has to *read* the old count first, and for a new food there isn''t one. `tally.get(food, 0)` reads with a fallback.
```

## Grouping: lists as values

Counting answers "how many?". **Grouping** answers "which ones?". The value for each key is a list that you append to. The only extra step: the first time you see a key, give it an empty list.

```python run
tasks = [("email Sam", "high"), ("water plants", "low"),
         ("pay rent", "high"), ("tidy desk", "low"), ("book dentist", "medium")]

by_priority = {}
for task, priority in tasks:
    if priority not in by_priority:
        by_priority[priority] = []          # first time: start an empty list
    by_priority[priority].append(task)      # then add to it

for priority, items in by_priority.items():
    print(f"{priority:>6}: {items}")
```

`by_priority[priority]` gives you the **actual list** stored in the dictionary, so `.append()` changes it in place. You don''t need to assign it back.

```python exercise id=group-songs title="Group the playlist by genre"
songs = [
    ("Blinding Lights", "pop"),
    ("Bohemian Rhapsody", "rock"),
    ("Levitating", "pop"),
    ("Take Five", "jazz"),
    ("Hotel California", "rock"),
    ("So What", "jazz"),
]

# TODO: build `by_genre` so each genre maps to a list of its song titles,
# in playlist order, e.g. by_genre["pop"] == ["Blinding Lights", "Levitating"]
by_genre = {}
for title, genre in songs:
    ...

print(by_genre)
--- solution
songs = [
    ("Blinding Lights", "pop"),
    ("Bohemian Rhapsody", "rock"),
    ("Levitating", "pop"),
    ("Take Five", "jazz"),
    ("Hotel California", "rock"),
    ("So What", "jazz"),
]

by_genre = {}
for title, genre in songs:
    if genre not in by_genre:
        by_genre[genre] = []
    by_genre[genre].append(title)

print(by_genre)
--- test
assert isinstance(by_genre, dict), "`by_genre` should be a dictionary."
assert by_genre, "`by_genre` is still empty. Inside the loop, add each title to its genre''s list."
expected = {}
for _t, _g in songs:
    expected.setdefault(_g, []).append(_t)
assert set(by_genre) == set(expected), f"`by_genre` should have the keys {sorted(expected)}, but has {sorted(by_genre)}."
for _g, _titles in expected.items():
    assert isinstance(by_genre[_g], list), f"`by_genre[{_g!r}]` should be a list of titles, but it is {by_genre[_g]!r}."
    assert by_genre[_g] == _titles, f"`by_genre[{_g!r}]` should be {_titles}, but it is {by_genre[_g]}. Is a new list being created every time?"
--- hint
Each genre needs its own list. Only create that empty list when the genre isn''t a key yet.
--- hint
`if genre not in by_genre: by_genre[genre] = []`, then `by_genre[genre].append(...)` on its own line.
```

> **Tip:** Writing `by_genre[genre] = [title]` on every song looks tempting, but it **replaces** the list each time, so only the last title per genre survives. Create the list once, then append.

## Nested dictionaries: JSON-shaped data

Values can be lists and dictionaries, which can hold more lists and dictionaries. That lets one variable describe a whole real-world record. You reach inside by chaining brackets, one level at a time, reading left to right:

```python run
user = {
    "name": "Priya",
    "address": {"city": "Toronto", "postcode": "M5V 2T6"},
    "orders": [
        {"id": 1001, "total": 42.50},
        {"id": 1002, "total": 17.25},
    ],
}

print(user["address"]["city"])          # dict → dict → value
print(user["orders"][1]["total"])       # dict → list → dict → value

spent = 0
for order in user["orders"]:
    spent += order["total"]
print("lifetime spend:", spent)
```

Read `user["orders"][1]["total"]` step by step: `user["orders"]` is a list; `[1]` is its second item, a dictionary; `["total"]` is a value inside that.

> **In the wild:** this is exactly the shape of **JSON**, the format nearly every web API speaks. Ask a weather service or a payment provider for data, and you get back nested dictionaries and lists like this one. You''ll load real JSON files in lesson 24.

```python predict id=predict-nested title="Reach inside the record"
trip = {"city": "Rome", "days": [{"weather": "sun", "high": 29}, {"weather": "rain", "high": 22}]}
print(len(trip), len(trip["days"]), trip["days"][-1]["weather"])
--- options
3 2 rain
* 2 2 rain
2 2 sun
2 4 rain
--- explain
`trip` has two keys, `"city"` and `"days"`, so `len(trip)` is 2, no matter how much data is nested inside. `trip["days"]` is a list of two dictionaries, and `[-1]` picks the last one, whose `"weather"` is `"rain"`.
```

```python exercise id=hottest-day title="Find the hottest day in the forecast"
forecast = {
    "city": "Seville",
    "days": [
        {"day": "Mon", "high": 31},
        {"day": "Tue", "high": 36},
        {"day": "Wed", "high": 34},
        {"day": "Thu", "high": 29},
    ],
}

# TODO: loop over forecast["days"] and find the day with the highest "high".
# Set `hottest_day` to its name (e.g. "Mon") and `hottest_temp` to its high.
hottest_day = ...
hottest_temp = ...

print(f"Hottest in {forecast[''city'']}: {hottest_day} at {hottest_temp} °C")
--- solution
forecast = {
    "city": "Seville",
    "days": [
        {"day": "Mon", "high": 31},
        {"day": "Tue", "high": 36},
        {"day": "Wed", "high": 34},
        {"day": "Thu", "high": 29},
    ],
}

hottest_day = forecast["days"][0]["day"]
hottest_temp = forecast["days"][0]["high"]
for day in forecast["days"]:
    if day["high"] > hottest_temp:
        hottest_temp = day["high"]
        hottest_day = day["day"]

print(f"Hottest in {forecast[''city'']}: {hottest_day} at {hottest_temp} °C")
--- test
assert hottest_day is not ..., "Replace the `...` after `hottest_day =` with your code."
assert hottest_temp is not ..., "Replace the `...` after `hottest_temp =` with your code."
_best = forecast["days"][0]
for _d in forecast["days"]:
    if _d["high"] > _best["high"]:
        _best = _d
assert isinstance(hottest_day, str), f"`hottest_day` should be the day''s name, like \"Mon\", but it is {hottest_day!r}."
assert hottest_temp == _best["high"], f"`hottest_temp` should be the highest \"high\" ({_best[''high'']}), but it is {hottest_temp!r}."
assert hottest_day == _best["day"], f"`hottest_day` should be {_best[''day'']!r} (the day with that high), but it is {hottest_day!r}."
--- hint
This is the "find the maximum" loop pattern from lesson 12: start with the first day as the best so far, then replace it whenever a hotter day comes along.
--- hint
Each item in `forecast["days"]` is a dictionary, so inside `for day in forecast["days"]:` you can read `day["high"]` and `day["day"]`.
```

## The rules for keys

Two rules keep dictionaries fast and predictable.

**1. Keys are unique.** Assigning to an existing key replaces its value, and that applies even when you type a key twice in the same literal: the last one wins.

**2. Keys must be immutable.** Strings, numbers and tuples can be keys. Lists and dictionaries can''t, because they could change after being filed away, and the dictionary would lose track of them.

```python run error
seats = {["row A", 3]: "Maya"}
```

`TypeError: unhashable type: ''list''` is Python''s way of saying "this can''t be a key". ("Hashable" roughly means "safe to file away because it never changes".) The fix is usually a tuple, which is perfect for things like grid coordinates:

```python run
seats = {("A", 3): "Maya", ("A", 4): "Jon", ("B", 1): "Ines"}

print("A3 is booked by", seats[("A", 3)])
print("Is B2 taken?", ("B", 2) in seats)
```

> **Under the hood:** a dictionary turns each key into a number called a **hash** and uses it to jump almost directly to the right slot, like a coat check ticket. That''s why lookups stay fast even with millions of entries, and why a key must never change: its ticket number would no longer match.

```python predict id=predict-duplicate-keys title="The same key twice"
scores = {"Ana": 10, "Ben": 7, "Ana": 15}
print(len(scores), scores["Ana"])
--- options
3 10
3 15
2 10
* 2 15
--- explain
Keys are unique, so `"Ana"` can only appear once. When a key is repeated in a literal, the later value replaces the earlier one, just as `scores["Ana"] = 15` would. That leaves two entries, and Ana''s value is 15.
```

## Merging dictionaries: `.update()` and `|`

Often you have **defaults** and want to layer someone''s **choices** on top. `.update()` changes a dictionary in place; the `|` operator builds a brand-new merged dictionary. In both, when a key appears on both sides, the **right-hand side wins**.

```python run
defaults = {"theme": "light", "font_size": 14, "notifications": True}
choices = {"theme": "dark", "language": "pt"}

settings = defaults | choices         # new dict; defaults is untouched
print("settings:", settings)
print("defaults:", defaults)

defaults.update({"font_size": 16})    # changes defaults itself
print("updated defaults:", defaults)
```

- Want a **new** merged dictionary? `merged = a | b`
- Want to change `a` **in place**? `a.update(b)` (or the shorthand `a |= b`)
- Want a plain **copy**? `a.copy()` or `dict(a)`

> **Pitfall:** just like lists, `b = a` doesn''t copy a dictionary. It gives the same dictionary a second name, so changing one "changes" both. Use `a.copy()` when you need an independent dictionary.

## Debug challenge: the number that''s "free" but isn''t

```python debug id=jersey-check title="Taken jersey numbers show up as available"
# Each player''s name maps to their jersey number.
roster = {"Ana": 7, "Ben": 10, "Chloe": 23}

# New players asked for these numbers. Which ones are still free?
requested = [7, 12, 10, 99]
available = []
for number in requested:
    if number in roster:
        print(number, "is taken")
    else:
        available.append(number)

print("available:", available)
--- solution
roster = {"Ana": 7, "Ben": 10, "Chloe": 23}

requested = [7, 12, 10, 99]
available = []
for number in requested:
    if number in roster.values():
        print(number, "is taken")
    else:
        available.append(number)

print("available:", available)
--- test
assert isinstance(available, list), "`available` should be a list."
_taken = set(roster.values())
_expected = [n for n in requested if n not in _taken]
assert 7 not in available, "7 is Ana''s number, but it''s still listed as available."
assert available == _expected, f"`available` should be {_expected}, but it is {available}."
--- hint
Run it: every number comes out available, even 7. What does `in` look at when you use it on a dictionary?
--- hint
`number in roster` checks the **keys** (the names). The jersey numbers are the values, which you can get with `roster.values()`.
```

## Recap

- A dictionary maps unique, immutable **keys** to **values**: `d = {"latte": 3.8}`, read with `d["latte"]`.
- A missing key raises `KeyError`; `.get(key, default)` reads safely, and `key in d` checks first.
- Assign to add or replace (`d[k] = v`); remove with `del d[k]` or `d.pop(k)`. Dictionaries keep insertion order.
- `in` and plain `for` loops see **keys**; use `.values()` and `.items()` for the rest.
- Count with `d[k] = d.get(k, 0) + 1`; group by appending to a list stored under each key.
- Nested dictionaries and lists describe JSON-shaped records; merge dictionaries with `|` or `.update()` (right side wins).

**Up next:** sets, Python''s collection for uniqueness and lightning-fast membership checks.
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_python_basics_4_5', 'sec_python_basics_4', 'crs_python_basics', 'Sets: uniqueness and membership', 'interactive', 4, 840, NULL, NULL, 'You''re sending wedding invitations, and three relatives each gave you their list. Some guests appear twice, a few appear on all three lists. How many *different* people are invited? Which friends do you and your partner have in common? Which tags does this blog post share with that one?

These are all questions about **uniqueness** and **overlap**, and Python has a collection built exactly for them: the **set**. A set holds each value at most once, can tell you in an instant whether something is inside it, and does Venn-diagram math (in common, combined, difference) with a single operator. By the end of this lesson you''ll be using sets to clean up duplicates and compare groups in one line.

## A set keeps one of each

Turn a list into a set with `set(...)`, and every duplicate disappears:

```python run
rsvps = ["maya@mail.com", "leo@mail.com", "maya@mail.com",
         "ines@mail.com", "leo@mail.com", "maya@mail.com"]

guests = set(rsvps)

print("replies received:", len(rsvps))
print("different guests:", len(guests))
guests
```

Six replies, but only three different people. Notice the curly braces in the output: you can also write a set directly with `{...}`, just like a dictionary but with **values only**, no `key: value` pairs.

```python run
primes = {2, 3, 5, 7, 7, 7}          # duplicates in a literal are dropped too
letters = set("mississippi")         # any iterable works: here, a string

print("primes:", primes, "len", len(primes))
print("letters:", sorted(letters))   # sorted() gives you a tidy list
```

`set("mississippi")` loops over the string and keeps each letter once. Because sets have no reliable order, `sorted()` is the usual way to display one neatly. It returns a regular, sorted **list**.

> **Pitfall:** the order you see when you print a set is an accident of how Python stores it, not the order you added things. It can even change between runs of the same program. If order matters, sort the set or keep a list.

```python predict id=predict-set-len title="How many are left?"
print(len({3, 1, 3, 2, 1}), len(set("hello")))
--- options
5 5
3 5
* 3 4
3 3
--- explain
`{3, 1, 3, 2, 1}` keeps one 1, one 2 and one 3, so its length is 3. `set("hello")` keeps each letter once: `h`, `e`, `l`, `o`. The second `l` is a duplicate, so that''s 4.
```

## The empty set trap: `set()` vs `{}`

Here''s a quirk you need to know. Curly braces were used for dictionaries first, so an empty `{}` is an empty **dictionary**, not an empty set. To make an empty set, call `set()`.

```python run
print("{}     →", type({}))
print("set()  →", type(set()))
print("{1, 2} →", type({1, 2}))
```

| You write | You get |
|---|---|
| `{}` | an empty **dict** |
| `set()` | an empty **set** |
| `{"a", "b"}` | a set with two items |
| `{"a": 1}` | a dict with one key |

## Adding and removing items

Sets are mutable. `.add()` puts one item in (adding something that''s already there quietly does nothing). For removing, you get a choice:

```python run
tags = {"travel", "food"}

tags.add("photography")
tags.add("food")               # already there: no change, no error
tags.discard("budget")         # not there: discard doesn''t mind
tags.remove("travel")          # there: removed

print(sorted(tags))
```

The difference between `remove` and `discard` only shows when the item is missing:

```python run error
tags = {"food", "photography"}
tags.remove("budget")
```

`remove()` raises `KeyError` for a missing item, just like reading a missing dictionary key. Use `discard()` when "already gone" is fine, and `remove()` when a missing item would mean a bug you want to hear about.

```python predict id=predict-add-discard title="Add, add again, discard"
nums = {1, 2}
nums.add(2)
nums.add(3)
nums.discard(5)
print(len(nums), 2 in nums)
--- options
4 True
* 3 True
3 False
KeyError: 5
--- explain
Adding `2` again changes nothing, because it is already in the set. Adding `3` makes three items. `discard(5)` quietly does nothing when 5 is missing (it is `remove()` that would raise `KeyError`). So the set is `{1, 2, 3}`: length 3, and 2 is in it.
```

```python debug id=hashtag-set title="Collecting hashtags crashes with AttributeError"
posts = [
    "Morning run done #fitness #running",
    "New recipe tonight #cooking",
    "Long weekend #running #hiking #fitness",
]

# Collect every different hashtag used in the posts.
hashtags = {}
for post in posts:
    for word in post.split():
        if word.startswith("#"):
            hashtags.add(word)

print(sorted(hashtags))
--- solution
posts = [
    "Morning run done #fitness #running",
    "New recipe tonight #cooking",
    "Long weekend #running #hiking #fitness",
]

hashtags = set()
for post in posts:
    for word in post.split():
        if word.startswith("#"):
            hashtags.add(word)

print(sorted(hashtags))
--- test
assert isinstance(hashtags, set), f"`hashtags` should be a set, but it is a {type(hashtags).__name__}."
_expected = {w for p in posts for w in p.split() if w.startswith("#")}
assert hashtags == _expected, f"`hashtags` should be {sorted(_expected)}, but it is {sorted(hashtags)}."
--- hint
Run it and read the error: `''dict'' object has no attribute ''add''`. Why is `hashtags` a dict?
--- hint
`{}` makes an empty dictionary. An empty set needs a different spelling.
```

## Membership: sets answer `in` instantly

`x in some_list` checks items one by one from the start, so the longer the list, the slower it gets. A set works like the coat check from the dictionary lesson: it computes a **hash** of the value and jumps almost straight to where it would be. The size of the set barely matters.

Here''s a rough race. (`time` is a standard-library module, imported like `math`; you''ll tour these modules in lesson 25.)

```python run
import time

ids_list = list(range(20_000))
ids_set = set(ids_list)
target = 19_999                  # near the end: the list has to check everything

start = time.perf_counter()
for attempt in range(100):
    found = target in ids_list
list_ms = (time.perf_counter() - start) * 1000

start = time.perf_counter()
for attempt in range(100):
    found = target in ids_set
set_ms = (time.perf_counter() - start) * 1000

print(f"100 lookups in a list: {list_ms:.2f} ms")
print(f"100 lookups in a set:  {set_ms:.2f} ms")
```

The exact numbers depend on your computer, but the set is dramatically faster, and the gap grows as the data grows.

> **In the wild:** whenever code checks "have I seen this before?" (blocked usernames, visited web pages, already-processed order IDs), professionals reach for a set. A check that takes seconds with a list of a million items is effectively instant with a set.

The hashing trick comes with the same rule as dictionary keys: **set items must be immutable.** Numbers, strings and tuples are fine; trying to put a list in a set raises `TypeError: unhashable type: ''list''`.

## Sets have no positions

Because a set has no order, it has no index either. There''s no "first item" to ask for:

```python run error
finishers = {"Kenji", "Amara", "Lucas"}
print(finishers[0])
```

`''set'' object is not subscriptable` means "this kind of value doesn''t support `[...]`". If you need positions, convert with `sorted(...)` or `list(...)` first. You can still loop over a set with `for` and check `len()` and `in`; you just can''t rely on the order.

```python exercise id=passport-stamps title="Count the countries you''ve visited"
stamps = ["Japan", "Peru", "Japan", "Kenya", "Peru", "Japan", "Iceland", "Kenya"]

# TODO: `countries` should be a set of the different countries in `stamps`
countries = ...

# TODO: `country_count` should be how many different countries there are
country_count = ...

# TODO: `alphabetical` should be a list of those countries, A to Z
alphabetical = ...

print(country_count, "countries:", alphabetical)
--- solution
stamps = ["Japan", "Peru", "Japan", "Kenya", "Peru", "Japan", "Iceland", "Kenya"]

countries = set(stamps)
country_count = len(countries)
alphabetical = sorted(countries)

print(country_count, "countries:", alphabetical)
--- test
assert countries is not ..., "Replace the `...` after `countries =` with a set built from `stamps`."
assert isinstance(countries, set), f"`countries` should be a set, but it is a {type(countries).__name__}."
assert countries == set(stamps), f"`countries` should contain each country in `stamps` once, but it is {countries}."
assert country_count is not ..., "Replace the `...` after `country_count =`."
assert country_count == len(set(stamps)), f"`country_count` should be {len(set(stamps))}, but it is {country_count!r}. Count the set, not the list."
assert alphabetical is not ..., "Replace the `...` after `alphabetical =`."
assert isinstance(alphabetical, list), f"`alphabetical` should be a list, but it is a {type(alphabetical).__name__}. `sorted()` returns a list."
assert alphabetical == sorted(set(stamps)), f"`alphabetical` should be {sorted(set(stamps))}, but it is {alphabetical}."
--- hint
`set(...)` drops duplicates, and `len()` works on sets.
--- hint
`sorted(countries)` returns a new list in alphabetical order.
```

## Set math: union, intersection, difference

This is where sets shine. Picture two overlapping circles, your friends and your partner''s friends:

```text
        yours                 theirs
     ┌───────────┬─────────┬───────────┐
     │  Ana  Ben │  Chloe  │ Farah Gus │
     │           │   Dev   │           │
     └───────────┴─────────┴───────────┘
       yours - theirs  yours & theirs  theirs - yours
```

Each region is one operator away:

```python run
yours = {"Ana", "Ben", "Chloe", "Dev"}
theirs = {"Chloe", "Dev", "Farah", "Gus"}

print("in common (&):     ", sorted(yours & theirs))
print("everyone (|):      ", sorted(yours | theirs))
print("only yours (-):    ", sorted(yours - theirs))
print("only theirs (-):   ", sorted(theirs - yours))
print("not shared (^):    ", sorted(yours ^ theirs))
```

| Operator | Method | Meaning | Question it answers |
|---|---|---|---|
| `a \| b` | `a.union(b)` | in a, b, or both | "Who''s invited at all?" |
| `a & b` | `a.intersection(b)` | in both | "Which friends do we share?" |
| `a - b` | `a.difference(b)` | in a but not b | "What do I still need to buy?" |
| `a ^ b` | `a.symmetric_difference(b)` | in exactly one | "What''s different between the lists?" |
| `a <= b` | `a.issubset(b)` | everything in a is also in b | "Do I have all the ingredients?" |

Order matters for `-` (like ordinary subtraction) but not for `|`, `&` or `^`. The method versions are handy because they accept **any** iterable, such as a plain list:

```python run
recipe = {"flour", "eggs", "milk", "sugar", "butter"}
pantry = ["flour", "sugar", "salt", "rice", "eggs"]          # a list

shopping = recipe.difference(pantry)
print("buy:", sorted(shopping))
print("can bake already?", recipe.issubset(pantry))
print("can bake after shopping?", recipe <= set(pantry) | shopping)
```

```python predict id=predict-set-ops title="Which region is which?"
a = {1, 2, 3, 4}
b = {3, 4, 5}
print(sorted(a - b), sorted(b - a), sorted(a ^ b))
--- options
[1, 2] [1, 2] [1, 2, 5]
* [1, 2] [5] [1, 2, 5]
[1, 2] [5] [3, 4]
[1, 2, 5] [5] [1, 2]
--- explain
`a - b` keeps what''s in `a` but not in `b`: `[1, 2]`. Subtraction isn''t symmetric, so `b - a` is just `[5]`. `a ^ b` keeps what''s in exactly one of them, which is both differences combined: `[1, 2, 5]`. (`[3, 4]` would be `a & b`.)
```

```python exercise id=club-members title="Compare the club rosters"
chess = {"Ana", "Ben", "Chloe", "Dev", "Eli"}
drama = {"Chloe", "Eli", "Farah", "Gus"}

# TODO: use set operators (or methods) to fill in each one.
both = ...           # students in BOTH clubs
chess_only = ...     # students in chess but NOT in drama
everyone = ...       # students in at least one club
one_club_only = ...  # students in exactly one club

print("both:", both)
print("chess only:", chess_only)
print("everyone:", everyone)
print("exactly one club:", one_club_only)
--- solution
chess = {"Ana", "Ben", "Chloe", "Dev", "Eli"}
drama = {"Chloe", "Eli", "Farah", "Gus"}

both = chess & drama
chess_only = chess - drama
everyone = chess | drama
one_club_only = chess ^ drama

print("both:", both)
print("chess only:", chess_only)
print("everyone:", everyone)
print("exactly one club:", one_club_only)
--- test
_names = {"both": both, "chess_only": chess_only, "everyone": everyone, "one_club_only": one_club_only}
for _n, _v in _names.items():
    assert _v is not ..., f"Replace the `...` after `{_n} =` with a set expression."
for _n, _v in _names.items():
    assert isinstance(_v, set), f"`{_n}` should be a set, but it is a {type(_v).__name__}."
assert both == chess & drama, f"`both` should be {sorted(chess & drama)}, but it is {sorted(both)}."
assert chess_only == chess - drama, f"`chess_only` should be {sorted(chess - drama)}, but it is {sorted(chess_only)}. Order matters for `-`."
assert everyone == chess | drama, f"`everyone` should have {len(chess | drama)} students, but has {len(everyone)}."
assert one_club_only == chess ^ drama, f"`one_club_only` should be {sorted(chess ^ drama)}, but it is {sorted(one_club_only)}."
--- hint
Look at the table above: each question matches one operator, `&`, `-`, `|` or `^`.
--- hint
"Both" is the overlap (`&`); "at least one" is everything combined (`|`); "exactly one" is everything except the overlap (`^`).
```

## Removing duplicates but keeping the order

`set(items)` removes duplicates, but it scrambles the order. When order matters (a history of songs played, a list of steps), use the **seen-set** pattern: walk through the list, keep a set of what you''ve already seen, and only keep items the first time they show up.

```python run
searches = ["boots", "tent", "boots", "stove", "tent", "lantern"]

seen = set()
unique_searches = []
for term in searches:
    if term not in seen:
        seen.add(term)
        unique_searches.append(term)

print(unique_searches)
```

The list holds the order; the set answers "seen it?" instantly. You get the best of both.

```python exercise id=recently-played title="Recently played, without repeats"
plays = ["Levitating", "Yellow", "Levitating", "Hello", "Yellow",
         "Halo", "Hello", "Levitating", "Clocks"]

# TODO: build `history`, a list with each song ONCE,
# in the order it was FIRST played. Use `seen` to remember songs.
history = []
seen = set()
for song in plays:
    ...

print(history)
--- solution
plays = ["Levitating", "Yellow", "Levitating", "Hello", "Yellow",
         "Halo", "Hello", "Levitating", "Clocks"]

history = []
seen = set()
for song in plays:
    if song not in seen:
        seen.add(song)
        history.append(song)

print(history)
--- test
assert isinstance(history, list), f"`history` should be a list, but it is a {type(history).__name__}."
assert history, "`history` is still empty. Inside the loop, append each song the first time you see it."
_expected = []
for _s in plays:
    if _s not in _expected:
        _expected.append(_s)
assert len(history) == len(_expected), f"`history` should have {len(_expected)} songs (one each), but has {len(history)}."
assert history == _expected, f"`history` should be {_expected} (order of first play), but it is {history}."
--- hint
For each song, ask: is it already in `seen`? Only if it isn''t, do two things.
--- hint
`if song not in seen:` then `seen.add(song)` and `history.append(song)`.
```

> **Tip:** there''s also a famous one-liner for this, `list(dict.fromkeys(plays))`, which works because dictionary keys are unique *and* keep insertion order. The loop is clearer while you''re learning, and it''s easy to extend (for example, to ignore capital letters).

## frozenset: a set that can''t change

A `frozenset` is an immutable set. You can''t add or remove items, and in exchange it can be used where only immutable values are allowed: as a dictionary key or as an item in another set.

```python run
pizza_a = frozenset({"cheese", "basil", "tomato"})
pizza_b = frozenset({"tomato", "cheese", "basil"})   # same toppings, different order

prices = {pizza_a: 11.5}
print("same pizza?", pizza_a == pizza_b)
print("price:", prices[pizza_b])
```

You won''t need `frozenset` often, but now you''ll recognize it when you see it.

## Debug challenge: the jumbled leaderboard

```python debug id=top-scores title="The top 3 scores come out in a random order"
scores = [88, 95, 72, 95, 100, 64, 88, 91]

# Show the 3 highest DIFFERENT scores, best first: [100, 95, 91]
unique_scores = list(set(scores))
top3 = unique_scores[:3]

print("Top 3 distinct scores:", top3)
--- solution
scores = [88, 95, 72, 95, 100, 64, 88, 91]

unique_scores = sorted(set(scores), reverse=True)
top3 = unique_scores[:3]

print("Top 3 distinct scores:", top3)
--- test
_want = sorted(set(scores), reverse=True)[:3]
assert isinstance(top3, list), f"`top3` should be a list, but it is a {type(top3).__name__}."
assert len(top3) == 3, f"`top3` should hold 3 scores, but has {len(top3)}."
assert len(set(top3)) == 3, f"`top3` contains a duplicate: {top3}. Remove duplicates first."
assert sorted(top3) == sorted(_want), f"`top3` should contain the three highest scores, but it is {top3}. A set doesn''t keep any useful order."
assert top3 == _want, f"`top3` should be best first, {_want}, but it is {top3}."
--- hint
Run it: the scores are unique, but they aren''t the top 3. What order does `list(set(...))` give you?
--- hint
A set has no meaningful order, so sort it yourself, from highest to lowest, before slicing off the first three.
```

## Recap

- A **set** stores each value once: `set(items)` removes duplicates, and `{1, 2, 3}` is a set literal.
- `{}` is an empty **dict**; an empty set is `set()`.
- `.add()` puts items in; `.remove()` raises `KeyError` if missing, `.discard()` doesn''t.
- Membership with `in` is near-instant for sets, but they have **no order and no indexing**; use `sorted()` to display them.
- `|` union, `&` intersection, `-` difference, `^` symmetric difference, `<=` subset.
- Keep order while removing duplicates with a seen-set loop; `frozenset` is the immutable version.

**Up next:** comprehensions, a compact way to build lists, dictionaries and sets in a single readable line.
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z'),
('les_python_basics_4_6', 'sec_python_basics_4', 'crs_python_basics', 'Comprehensions: build collections in one line', 'interactive', 5, 960, NULL, NULL, 'By now you''ve written this pattern dozens of times: make an empty list, loop over something, maybe check a condition, append a result. It works, but it takes four lines to say one idea: *"give me the prices with tax added"* or *"give me just the long words."*

Python has a shorthand for exactly this, the **comprehension**. It builds a whole list, dictionary or set in one line that reads almost like English: `[price * 1.2 for price in prices]`. Comprehensions are one of the things people love most about Python, and you''ll see them in nearly every professional codebase. By the end of this lesson you''ll be able to read them fluently, translate loops into them (and back), and know when a plain loop is the better choice.

## From loop to one line

Here''s the familiar loop version. We want each price with 20% tax added:

```python run
prices = [4.50, 12.00, 7.25, 3.10]

with_tax = []
for price in prices:
    with_tax.append(round(price * 1.2, 2))

print(with_tax)
```

And here''s the same thing as a **list comprehension**:

```python run
prices = [4.50, 12.00, 7.25, 3.10]

with_tax = [round(price * 1.2, 2) for price in prices]

print(with_tax)
```

Same result, one line. The translation is mechanical: the thing you were appending moves to the **front**, and the `for` line follows it, all inside square brackets.

```text
with_tax = []
for price in prices:                      ──┐
    with_tax.append(round(price * 1.2, 2)) ─┼──┐
                                            │  │
with_tax = [round(price * 1.2, 2)  for price in prices]
            └──── what to keep ──┘ └──── where it comes from ──┘
```

Read it aloud as *"round price times 1.2, **for** each price **in** prices."* The square brackets tell you the result is a new list. The original `prices` list is untouched.

```python predict id=predict-first-comp title="What does the comprehension build?"
print([n * 2 for n in range(4)])
--- options
[2, 4, 6, 8]
* [0, 2, 4, 6]
[0, 2, 4, 6, 8]
[0, 1, 2, 3, 0, 1, 2, 3]
--- explain
`range(4)` gives 0, 1, 2, 3 (the stop value is excluded), and each one is doubled: `[0, 2, 4, 6]`. The result always has exactly one item per item in the source, because there''s no filter. (`[0, 1, 2, 3, 0, 1, 2, 3]` is what `list(range(4)) * 2` would give.)
```

```python exercise id=to-fahrenheit title="Convert the forecast to Fahrenheit"
celsius = [18.5, 22.0, 25.3, 19.8, 30.1]

# TODO: use a list comprehension to build `fahrenheit`:
# each temperature converted with  c * 9 / 5 + 32,  rounded to 1 decimal.
fahrenheit = ...

print(fahrenheit)
--- solution
celsius = [18.5, 22.0, 25.3, 19.8, 30.1]

fahrenheit = [round(c * 9 / 5 + 32, 1) for c in celsius]

print(fahrenheit)
--- test
assert fahrenheit is not ..., "Replace the `...` after `fahrenheit =` with a list comprehension."
assert isinstance(fahrenheit, list), f"`fahrenheit` should be a list, but it is a {type(fahrenheit).__name__}. Use square brackets."
assert len(fahrenheit) == len(celsius), f"`fahrenheit` should have one value per Celsius reading ({len(celsius)}), but has {len(fahrenheit)}."
_expected = [round(c * 9 / 5 + 32, 1) for c in celsius]
assert all(abs(f - e) < 0.051 for f, e in zip(fahrenheit, _expected)), f"`fahrenheit` should be {_expected}, but it is {fahrenheit}. Check the formula: c * 9 / 5 + 32."
assert fahrenheit == _expected, f"Close! Round each value to 1 decimal: {_expected}."
--- hint
The shape is `[<expression using c> for c in celsius]`.
--- hint
The expression is the formula wrapped in `round(..., 1)`.
```

## Filtering with `if`

Add an `if` at the **end** of a comprehension, and only items that pass the test are kept. It''s the loop-with-an-`if` pattern, compressed:

```python run
transactions = [12.50, 230.00, 8.99, 75.00, 1200.00, 45.10]

big = [t for t in transactions if t >= 100]
print("big:", big)

words = "the quick brown fox jumps over the lazy dog".split()
long_words = [w.upper() for w in words if len(w) > 4]
print("long words:", long_words)
```

The order matches the loop you''d write: `for` first, then the `if` nested inside it. The expression at the front is only computed for items that pass, so you can transform and filter in one go.

```python exercise id=clean-signups title="Tidy up the sign-up sheet"
raw_names = ["  maya ", "LEO", "", "ines carvalho", "   ", "sam  "]

# TODO: build `names` with a list comprehension:
#  - skip entries that are empty or only spaces
#  - strip the spaces and put each remaining name in Title Case
# Expected: ["Maya", "Leo", "Ines Carvalho", "Sam"]
names = ...

print(names)
--- solution
raw_names = ["  maya ", "LEO", "", "ines carvalho", "   ", "sam  "]

names = [n.strip().title() for n in raw_names if n.strip()]

print(names)
--- test
assert names is not ..., "Replace the `...` after `names =` with a list comprehension."
assert isinstance(names, list), f"`names` should be a list, but it is a {type(names).__name__}."
_expected = [n.strip().title() for n in raw_names if n.strip() != ""]
assert "" not in names, "There''s still an empty name in the list. Filter out entries that are blank after stripping."
assert len(names) == len(_expected), f"`names` should have {len(_expected)} names, but has {len(names)}: {names}. Entries that are only spaces count as blank."
assert names == _expected, f"`names` should be {_expected}, but it is {names}. Strip AND title-case each name."
--- hint
Two jobs: the expression at the front cleans each name, and an `if` at the end decides which ones to keep.
--- hint
`n.strip()` is `""` for a blank entry, and an empty string is falsy, so `if n.strip()` keeps only the real names.
```

## Choosing a value with `if ... else`

Sometimes you don''t want to drop items; you want to **choose** what each one becomes. That''s the conditional expression from lesson 9, `a if condition else b`, and it goes at the **front**, as the value:

```python run
scores = [72, 45, 88, 50, 39]

results = ["pass" if s >= 50 else "fail" for s in scores]
print(results)
```

Every score produces exactly one label, so the result has the same length as `scores`. This is the source of the most common comprehension mix-up, so here it is side by side:

| Where the `if` goes | What it does | Result length |
|---|---|---|
| `[x for x in items if cond]` (end) | **filters**: drops items that fail | same or shorter |
| `[a if cond else b for x in items]` (front) | **chooses** a value for every item | always the same |

An `if` at the end can''t have an `else`, and an `if` at the front must have one. Mix them up and Python refuses before running anything:

```python run error
temps = [21, -999, 23, 22]
fixed = [t if t > -100 for t in temps]
```

`SyntaxError` means Python couldn''t even read the line. An `if` before the `for` is a conditional expression, and it needs its `else`.

```python predict id=predict-filter-vs-choose title="Filter or choose?"
nums = [3, -1, 4, -5]
print([n for n in nums if n > 0], [n if n > 0 else 0 for n in nums])
--- options
[3, 4] [3, 4]
[3, 0, 4, 0] [3, 0, 4, 0]
* [3, 4] [3, 0, 4, 0]
[3, 0, 4, 0] [3, 4]
--- explain
The first comprehension has its `if` at the end, so it **filters**: the negatives are dropped, leaving `[3, 4]`. The second has `if ... else` at the front, so it **chooses** a value for every item: negatives become 0 and the list keeps all four positions.
```

```python debug id=sensor-gaps title="Bad readings vanish instead of becoming 0"
# Hourly readings from a sensor. -1 means the sensor glitched that hour.
readings = [14, 15, -1, 17, -1, 19, 18]

# Replace each glitch with 0, but keep one value per hour
# so that cleaned[i] still lines up with hour i.
cleaned = [r for r in readings if r != -1]

print("hours:", len(readings), "cleaned values:", len(cleaned))
print(cleaned)
--- solution
readings = [14, 15, -1, 17, -1, 19, 18]

cleaned = [r if r != -1 else 0 for r in readings]

print("hours:", len(readings), "cleaned values:", len(cleaned))
print(cleaned)
--- test
assert isinstance(cleaned, list), "`cleaned` should be a list."
assert len(cleaned) == len(readings), f"`cleaned` has {len(cleaned)} values but there are {len(readings)} hours. The glitches were dropped instead of replaced."
assert -1 not in cleaned, "`cleaned` still contains -1. Replace each glitch with 0."
_expected = [0 if r == -1 else r for r in readings]
assert cleaned == _expected, f"`cleaned` should be {_expected}, but it is {cleaned}."
--- hint
Run it: 7 hours went in, but only 5 values came out. Is the `if` filtering or choosing?
--- hint
To keep every item and pick a value for each one, move the condition to the front as `value_if_true if condition else value_if_false`.
```

## Dictionary and set comprehensions

The same idea works with curly braces. Write `key: value` at the front and you get a **dictionary**; write a single value and you get a **set**.

```python run
menu = {"espresso": 2.50, "latte": 3.80, "mocha": 4.20}

happy_hour = {drink: round(price * 0.8, 2) for drink, price in menu.items()}
print("happy hour:", happy_hour)

names = ["Ana", "Benedict", "Lu"]
name_lengths = {name: len(name) for name in names}
print("lengths:", name_lengths)
```

Looping over `.items()` and unpacking each pair, exactly like in a `for` loop, is the most common way to transform one dictionary into another. Filters work too:

```python run
emails = ["maya@gmail.com", "leo@work.org", "ines@gmail.com", "sam@school.edu", "jo@work.org"]

domains = {e.split("@")[1] for e in emails}                 # set: no duplicates
gmail_users = {e.split("@")[0] for e in emails if e.endswith("@gmail.com")}

print("domains:", sorted(domains))
print("gmail users:", sorted(gmail_users))
```

| Brackets | Front part | You get |
|---|---|---|
| `[ ... ]` | `value` | a list |
| `{ ... }` | `key: value` | a dict |
| `{ ... }` | `value` | a set |

```python predict id=predict-set-comp title="How many are left?"
greetings = ["Hi", "hi", "HI", "Hey", "hey"]
print(len({g.lower() for g in greetings}))
--- options
5
3
* 2
1
--- explain
Curly braces with a single value at the front build a **set**, and a set keeps each value once. After `.lower()` the words are `hi, hi, hi, hey, hey`, which collapse to just `{"hi", "hey"}`: 2 items.
```

```python exercise id=stock-report title="Build the stock report"
stock = {"apples": 40, "pears": 3, "kiwis": 0, "plums": 12, "figs": 4}
prices = {"apples": 0.50, "pears": 0.75, "kiwis": 0.40, "plums": 0.60, "figs": 1.20}

# TODO 1: `low_stock` is a SET of the items with fewer than 5 left
low_stock = ...

# TODO 2: `stock_value` is a DICT mapping each item to quantity * price,
#         rounded to 2 decimals, e.g. stock_value["apples"] == 20.0
stock_value = ...

print("reorder:", low_stock)
print("value:", stock_value)
--- solution
stock = {"apples": 40, "pears": 3, "kiwis": 0, "plums": 12, "figs": 4}
prices = {"apples": 0.50, "pears": 0.75, "kiwis": 0.40, "plums": 0.60, "figs": 1.20}

low_stock = {item for item, qty in stock.items() if qty < 5}

stock_value = {item: round(qty * prices[item], 2) for item, qty in stock.items()}

print("reorder:", low_stock)
print("value:", stock_value)
--- test
assert low_stock is not ..., "Replace the `...` after `low_stock =` with a set comprehension."
assert isinstance(low_stock, set), f"`low_stock` should be a set, but it is a {type(low_stock).__name__}. Use curly braces with a single value at the front."
_low = {i for i, q in stock.items() if q < 5}
assert low_stock == _low, f"`low_stock` should be {sorted(_low)}, but it is {sorted(low_stock)}."
assert stock_value is not ..., "Replace the `...` after `stock_value =` with a dictionary comprehension."
assert isinstance(stock_value, dict), f"`stock_value` should be a dict, but it is a {type(stock_value).__name__}. Use `key: value` at the front."
_val = {i: round(q * prices[i], 2) for i, q in stock.items()}
assert set(stock_value) == set(_val), f"`stock_value` should have a key for every item: {sorted(_val)}."
_off = [i for i in _val if abs(stock_value[i] - _val[i]) > 0.005]
assert not _off, f"Wrong value for {'', ''.join(_off)}. Each should be quantity * price, e.g. {_off[0]} is {_val[_off[0]]}."
--- hint
Both loop over `stock.items()`, unpacking `item, qty`. The set needs an `if` at the end; the dict needs no filter.
--- hint
The dictionary''s front part is `item: round(qty * prices[item], 2)`.
```

## Nested comprehensions: flattening

A comprehension can have more than one `for`. The rule that makes them readable: **write the `for` clauses in the same order as the nested loops.** The classic use is flattening a list of lists into one list:

```python run
weekly_steps = [
    [8200, 9100, 7600],      # week 1
    [10400, 6900, 8800],     # week 2
]

all_days = [steps for week in weekly_steps for steps in week]
print(all_days)
print("total:", sum(all_days))
```

```text
for week in weekly_steps:          [steps  for week in weekly_steps  for steps in week]
    for steps in week:                      └──── outer loop ──────┘ └─ inner loop ─┘
        all_days.append(steps)      (the value still goes first)
```

```python exercise id=seat-labels title="Label every seat in the cinema"
rows = "ABC"
seats_per_row = 4

# TODO: use ONE list comprehension with two `for` clauses to build `seats`:
# ["A1", "A2", "A3", "A4", "B1", ..., "C4"]  (row by row)
seats = ...

print("seats:", seats)
--- solution
rows = "ABC"
seats_per_row = 4

seats = [f"{row}{n}" for row in rows for n in range(1, seats_per_row + 1)]

print("seats:", seats)
--- test
assert seats is not ..., "Replace the `...` after `seats =` with a list comprehension."
assert isinstance(seats, list), f"`seats` should be a list, but it is a {type(seats).__name__}."
_expected = [r + str(n) for r in rows for n in range(1, seats_per_row + 1)]
assert len(seats) == len(_expected), f"There should be {len(_expected)} seats ({len(rows)} rows x {seats_per_row}), but `seats` has {len(seats)}. Check the range of seat numbers."
assert all(isinstance(s, str) for s in seats), "Each seat label should be a string like \"A1\"."
assert sorted(seats) == sorted(_expected), f"Some labels are wrong. Expected labels like {_expected[:3]}, got {seats[:3]}. Seat numbers start at 1."
assert seats == _expected, f"The labels are right but the order isn''t. Go row by row: {_expected[:5]}... Which `for` should come first?"
--- hint
Think of the nested loops first: for each row, for each number from 1 to 4. Then write the `for` clauses in that same order.
--- hint
`range(1, seats_per_row + 1)` gives 1 to 4, and `f"{row}{n}"` glues a row letter to a number.
```

## When not to use a comprehension

Comprehensions are for **building a collection**. They''re at their best when they''re short enough to read in one breath. Two warning signs that a plain loop would be better:

```python
# 1. Too much going on: a conditional value, unpacking AND a two-part filter.
labels = [f"{n}: {s:.1f}" if s >= 50 else f"{n}: retake" for n, s in results if n and s is not None]

# 2. Used only for its side effect: builds a useless list of None values.
[print(name) for name in guests]
```

For the second one, just write the loop. `print()` isn''t building anything:

```python
for name in guests:
    print(name)
```

> **Tip:** a good rule of thumb: if a comprehension doesn''t fit comfortably on one line, or you need to explain it with a comment, write the loop instead. Readable code beats clever code, every time.

## A teaser: generator expressions

Drop the square brackets inside a function call, and you get a **generator expression**. It produces values one at a time for the function to consume, without ever building the full list in memory:

```python run
cart = {"apples": 6, "milk": 2, "eggs": 1}
prices = {"apples": 0.5, "milk": 1.2, "eggs": 3.0}

total = sum(prices[item] * qty for item, qty in cart.items())
print("total:", total)

words = ["comprehension", "set", "dictionary", "list"]
print("longest word length:", max(len(w) for w in words))
```

That one-line `sum(...)` replaces a whole accumulator loop. You''ll learn how generators work under the hood in **Python Advanced**; for now, enjoy the shortcut for `sum`, `max` and `min`.

> **In the wild:** in data work you''ll constantly see lines like `{row["id"]: row for row in rows}` (index records by ID) or `[r for r in records if r["status"] == "active"]`. pandas and Django code is full of them.

## Debug challenge: the same name over and over

```python debug id=badge-names title="Every badge has the same name"
guests = ["maya", "leo", "ines"]

for name in guests:
    print("Checking in", name)

# Make a name badge for every guest: ["Maya", "Leo", "Ines"]
badges = [name.title() for guest in guests]

print(badges)
--- solution
guests = ["maya", "leo", "ines"]

for name in guests:
    print("Checking in", name)

badges = [guest.title() for guest in guests]

print(badges)
--- test
assert isinstance(badges, list), "`badges` should be a list."
assert len(badges) == len(guests), f"There should be one badge per guest ({len(guests)}), but there are {len(badges)}."
_expected = [g.title() for g in guests]
assert len(set(badges)) == len(badges), f"The badges are {badges}: the same name repeated. Is the front of the comprehension using the loop variable?"
assert badges == _expected, f"`badges` should be {_expected}, but it is {badges}."
--- hint
Run it and look at what `name` holds after the `for` loop above finishes. Which name does the comprehension keep using?
--- hint
The comprehension''s own loop variable is `guest`, but the front part uses `name`, a leftover from the earlier loop.
```

## Recap

- A list comprehension `[expr for x in items]` builds a new list: the value goes first, then the `for`.
- An `if` at the **end** filters items out; `a if cond else b` at the **front** chooses a value for every item.
- Curly braces give a **dict** (`{k: v for ...}`) or a **set** (`{v for ...}`); loop over `.items()` to transform dictionaries.
- Multiple `for` clauses run in the same order as nested loops, which is how you flatten lists of lists.
- `sum(x for x in ...)` is a generator expression: no brackets, no temporary list.
- If it doesn''t fit comfortably on one line, or it''s only for side effects like `print`, write a normal loop.

**Up next:** functions, where you''ll learn to package code into reusable, named pieces with `def`, parameters and return values.
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z'),
('les_python_basics_4_7', 'sec_python_basics_4', 'crs_python_basics', 'Checkpoint: collections', 'quiz', 6, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"What does `scores = [70, 85, 90]` followed by `print(scores[len(scores)])` do?","options":["Prints `90`","Raises `IndexError: list index out of range`","Prints `3`","Prints `None`"],"answerIndex":1,"explanation":"Positions start at 0, so a list of length 3 has indexes 0, 1 and 2. `len(scores)` is 3, one past the end. The last item is `scores[len(scores) - 1]`, or simply `scores[-1]`."},{"id":"q2","prompt":"What does `nums = [3, 1, 2]; result = nums.sort(); print(result)` print?","options":["`[1, 2, 3]`","`[3, 1, 2]`","`None`","An error, because `sort` needs an argument"],"answerIndex":2,"explanation":"`.sort()` sorts the list **in place** and returns `None`. `nums` is now `[1, 2, 3]`, but `result` is `None`. If you want a new sorted list back, use `sorted(nums)`."},{"id":"q3","prompt":"After `a = [1, 2]`, `b = a` and `b.append(3)`, what is `a`?","options":["`[1, 2, 3]`","`[1, 2]`","`[3]`","`None`"],"answerIndex":0,"explanation":"`b = a` doesn''t copy anything: it gives the same list a second name. Appending through `b` changes the one shared list, so `a` sees it too. Use `a.copy()`, `a[:]` or `list(a)` to get an independent copy."},{"id":"q4","prompt":"Which of these creates a tuple containing just the number 5?","options":["`(5)`","`[5]`","`tuple(5)`","`(5,)`"],"answerIndex":3,"explanation":"The comma makes a tuple, not the parentheses. `(5)` is just the number 5 in brackets, `[5]` is a list, and `tuple(5)` raises a `TypeError` because 5 isn''t iterable. `(5,)` (or even `5,`) is a one-element tuple."},{"id":"q5","prompt":"What is `rest` after `first, *rest = [10, 20, 30, 40]`?","options":["`(20, 30, 40)`","`[20, 30, 40]`","`40`","`ValueError: too many values to unpack`"],"answerIndex":1,"explanation":"`first` takes the first item, and the starred name collects everything else **as a list**, so `rest` is `[20, 30, 40]`. The star is what prevents the ''too many values'' error."},{"id":"q6","prompt":"Starting from `tally = {}`, what is `tally` after running `for ch in \"banana\": tally[ch] = tally.get(ch, 0) + 1`?","options":["`{''a'': 3, ''b'': 1, ''n'': 2}`","`KeyError: ''b''`","`{''b'': 1, ''a'': 3, ''n'': 2}`","`{''b'': 1, ''a'': 1, ''n'': 1}`"],"answerIndex":2,"explanation":"`.get(ch, 0)` returns 0 for a letter that hasn''t been seen yet, so there''s no `KeyError`, and each letter''s count goes up by 1 every time it appears. Dictionaries keep insertion order, so the keys appear in the order first seen: b, a, n."},{"id":"q7","prompt":"With `roster = {\"Ana\": 7, \"Ben\": 10}`, which expression is `True`?","options":["`\"Ana\" in roster`","`7 in roster`","`(\"Ana\", 7) in roster`","`10 in roster.keys()`"],"answerIndex":0,"explanation":"`in` on a dictionary checks its **keys**, and the keys here are the names. The jersey numbers are values, so you''d need `7 in roster.values()` to search them."},{"id":"q8","prompt":"You write `seen = {}` and later call `seen.add(\"Maya\")`. What happens?","options":["`\"Maya\"` is added to an empty set","`\"Maya\"` is added as a dictionary key with the value `None`","Nothing; `.add()` on an empty collection is ignored","`AttributeError`, because `{}` is an empty dictionary, which has no `.add()` method"],"answerIndex":3,"explanation":"Curly braces were used for dictionaries first, so `{}` is an empty **dict**. Dictionaries don''t have `.add()`. An empty set must be written `set()`."},{"id":"q9","prompt":"What does `sorted({1, 2, 3} ^ {2, 3, 4})` return?","options":["`[2, 3]`","`[1, 2, 3, 4]`","`[1, 4]`","`[1]`"],"answerIndex":2,"explanation":"`^` is the symmetric difference: items in exactly one of the two sets. 2 and 3 are in both, so they''re left out, leaving 1 and 4. (`&` would give `[2, 3]` and `|` would give `[1, 2, 3, 4]`.)"},{"id":"q10","prompt":"With `nums = [1, 2, 3, 4]`, which comprehension produces `[0, 2, 0, 4]`?","options":["`[n for n in nums if n % 2 == 0]`","`[n if n % 2 == 0 else 0 for n in nums]`","`[0 if n % 2 == 0 else n for n in nums]`","`[n for n in nums if n % 2 == 0 else 0]`"],"answerIndex":1,"explanation":"To keep every position and **choose** a value for each item, `if ... else` goes at the front. An `if` at the end **filters** (giving `[2, 4]`), and an `else` at the end is a `SyntaxError`. The third option swaps the values, giving `[1, 0, 3, 0]`."}]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z'),
('les_python_basics_5_1', 'sec_python_basics_5', 'crs_python_basics', 'Defining functions: parameters and return values', 'interactive', 0, 1080, NULL, NULL, 'You''ve been calling functions since your very first line: `print()`, `len()`, `sum()`, `round()`. Each one is a little machine with a name. You hand it something, it does its job, and (usually) it hands something back. You never had to know *how* `len()` counts; you just trusted the name.

Now you get to build your own machines. A function lets you write a piece of logic **once**, give it a clear name, and use it a hundred times. It''s the single biggest step from "a script that runs top to bottom" to "a program made of parts." By the end of this lesson you''ll write functions that take inputs, return results, stop early when they''ve found an answer, hand back several values at once, and prove themselves correct with `assert`.

## Why functions? The copy-paste problem

Here''s a shop working out the price of three orders after a 10% member discount and a $4.99 delivery fee:

```python run
order_a = 30.00
order_b = 12.50
order_c = 89.90

final_a = round(order_a * 0.9 + 4.99, 2)
final_b = round(order_b * 0.9 + 4.99, 2)
final_c = round(order_c * 0.9 + 4.99, 2)

print(final_a, final_b, final_c)
```

It works, but the same formula is written three times. If the discount changes to 15%, you have to find and edit every copy, and miss one and your prices are quietly wrong. Programmers call the fix **DRY: Don''t Repeat Yourself.** Put the recipe in one place and give it a name:

```python run
def final_price(order):
    return round(order * 0.9 + 4.99, 2)

print(final_price(30.00), final_price(12.50), final_price(89.90))
```

Same results, one formula. Change the discount once and every order follows. And notice how the call *reads*: `final_price(30.00)` says what it means. A good function name turns a tangle of arithmetic into an idea.

## Anatomy of a function

A function is like a **recipe card**. Writing the card (defining) doesn''t cook anything. Cooking happens only when someone follows the card (calling).

```python
def name(parameter1, parameter2):     # the header: def, a name, parentheses, a colon
    """What this function does."""    # optional docstring (more on this below)
    ...                               # the indented body
    return result                     # hand a value back to the caller
```

- `def` starts a definition. The name follows the same rules as variable names: `snake_case`, descriptive, usually a verb (`calculate_tax`, `send_reminder`).
- The **body** is the indented block, exactly like the body of an `if` or a `for`.
- Running a `def` only *creates* the function and stores it under its name. The body runs when you **call** it with parentheses: `name(...)`.

```python run
def say_hello():
    print("Hello from inside the function!")

print("Before the call")
say_hello()
say_hello()
print("After the calls")
```

The definition sat quietly until `say_hello()` was called, and then it ran once per call. Leave off the parentheses and you don''t call it at all; you just refer to the function itself:

```python run
say_hello
```

That `function` chip is Python telling you "this is the recipe card, not the meal." Forgetting the `()` is a classic slip: no error, just nothing happens.

```python predict id=predict-def-not-run title="What does this print?"
def warn():
    print("Battery low!")

print("Phone is on")
--- options
Battery low!
* Phone is on
Battery low! Phone is on
Phone is on Battery low!
--- explain
Defining `warn` doesn''t run its body. Nothing ever *calls* `warn()`, so only `"Phone is on"` is printed. A function body runs only when the function is called.
```

## Parameters and arguments

A function becomes useful when you can feed it different inputs. The names in the `def` line are **parameters**: empty slots waiting for values. The values you pass in a call are **arguments**: what actually fills the slots.

```python run
def greet(name, city):
    print(f"Hi {name}! How''s the weather in {city}?")

greet("Amara", "Nairobi")
greet("Leo", "Oslo")
```

| Term | Where it lives | In the example |
|---|---|---|
| **parameter** | in the `def` line, a name | `name`, `city` |
| **argument** | in the call, a value | `"Amara"`, `"Oslo"` |

On each call, Python pairs arguments with parameters **left to right**: first argument into the first slot, second into the second. Inside the body, the parameters are ordinary variables. Pass the wrong number of arguments and Python stops you with a very readable error:

```python run error
greet("Amara")
```

Read the last line: `greet() missing 1 required positional argument: ''city''`. It names the function and the exact slot that was left empty. (In lesson 20 you''ll learn how to give parameters default values so they can be left out.)

## `return`: handing a value back

`print` shows something on the screen. `return` **hands a value back** to whoever called the function, so they can store it, compare it or do more math with it. The call expression itself *becomes* the returned value, the same way `len("hello")` becomes `5`.

```python run
def rectangle_area(width, height):
    return width * height

kitchen = rectangle_area(4, 3.5)
bedroom = rectangle_area(3, 3)

print("kitchen:", kitchen)
print("total floor:", kitchen + bedroom)
rectangle_area(2, 5) * 30     # price of flooring at $30 per square metre
```

Think of a vending machine. You put coins in (arguments), the machine works (body), and a snack drops into the tray (return value). What you do with the snack is up to you. A machine that only *showed you a picture* of the snack (print) wouldn''t be much use.

```python exercise id=to-fahrenheit title="Celsius to Fahrenheit"
# TODO: complete the function so it RETURNS the temperature in Fahrenheit.
# The formula is: fahrenheit = celsius * 9 / 5 + 32
def to_fahrenheit(celsius):
    """Convert a temperature from Celsius to Fahrenheit."""
    ...

print("Lisbon:", to_fahrenheit(24))
print("Freezing:", to_fahrenheit(0))
--- solution
def to_fahrenheit(celsius):
    """Convert a temperature from Celsius to Fahrenheit."""
    return celsius * 9 / 5 + 32

print("Lisbon:", to_fahrenheit(24))
print("Freezing:", to_fahrenheit(0))
--- test
assert callable(to_fahrenheit), "`to_fahrenheit` should be a function defined with `def`."
assert to_fahrenheit(0) is not None, "`to_fahrenheit(0)` gave back `None`. Replace the `...` with a `return` statement."
assert isinstance(to_fahrenheit(0), (int, float)), f"`to_fahrenheit` should return a number, but returned {to_fahrenheit(0)!r}."
for c, f in [(0, 32), (100, 212), (-40, -40), (37, 98.6), (-12.5, 9.5)]:
    got = to_fahrenheit(c)
    assert abs(got - f) < 1e-9, f"`to_fahrenheit({c})` should be {f}, but returned {got}. Check the formula: celsius * 9 / 5 + 32."
--- hint
The body needs one line that starts with `return`.
--- hint
Use the parameter name inside the formula: `return celsius * ...`.
```

## `return` vs `print`: the big beginner trap

This is the most important idea in the lesson, so let''s slow down. A function that **prints** its answer *looks* like it works when you run it, because you see the number. But the caller gets nothing back. Every function that finishes without hitting a `return` hands back the special value **`None`**, Python''s way of saying "nothing here."

```python run
def add_tax_print(price):
    print(price * 1.2)          # shows it... and that''s all

def add_tax_return(price):
    return price * 1.2          # hands it back

a = add_tax_print(10)
b = add_tax_return(10)
print("a is", a)
print("b is", b)
```

The first line of output, `12.0`, came from *inside* `add_tax_print`. But `a` is `None`, because that function never returned anything. Try doing math with `a`:

```python run error
a + 5
```

`unsupported operand type(s) for +: ''NoneType'' and ''int''` is the fingerprint of this exact bug. Whenever you see `NoneType` in an error, ask: *which function forgot to return?*

| | `print(x)` | `return x` |
|---|---|---|
| Who sees it | a human, on the screen | the code that called the function |
| Can you store it, add it, compare it? | no | yes |
| What the call evaluates to | `None` | `x` |
| Ends the function | no | yes, immediately |

> **Tip:** As a rule, functions that *compute* something should `return` it, and let the caller decide whether to print. Your functions become reusable: the same `add_tax_return` can feed a receipt, a spreadsheet or a test.

```python predict id=predict-forgot-return title="What does this print?"
def double(n):
    n * 2

print(double(21))
--- options
42
* None
21
NameError
--- explain
The body *calculates* `n * 2` and then throws the result away. There''s no `return`, so the function finishes and hands back `None`. Fix it with `return n * 2`.
```

```python debug id=line-totals-none title="The receipt is full of None"
def line_total(price, quantity):
    """Return the cost of one line on a receipt."""
    print(price * quantity)

cart = [(2.50, 4), (1.25, 2), (6.00, 1)]   # (price, quantity) pairs

line_totals = []
for price, qty in cart:
    line_totals.append(line_total(price, qty))

print("line totals:", line_totals)
--- solution
def line_total(price, quantity):
    """Return the cost of one line on a receipt."""
    return price * quantity

cart = [(2.50, 4), (1.25, 2), (6.00, 1)]   # (price, quantity) pairs

line_totals = []
for price, qty in cart:
    line_totals.append(line_total(price, qty))

print("line totals:", line_totals)
--- test
assert line_total(2.5, 4) is not None, "The caller still receives `None` from `line_total(2.5, 4)`. The value is shown on screen, but is it handed back?"
assert line_total(2.5, 4) == 10.0, f"`line_total(2.5, 4)` should give back 10.0, but gave {line_total(2.5, 4)!r}."
assert line_total(3, 7) == 21, f"`line_total(3, 7)` should give back 21, but gave {line_total(3, 7)!r}."
assert line_totals == [10.0, 2.5, 6.0], f"`line_totals` should be [10.0, 2.5, 6.0], but is {line_totals!r}."
--- hint
Run it. The numbers appear on screen, yet the list holds `None` three times. What does a function give back when it never says `return`?
--- hint
Change the one line inside `line_total` so it hands the value back instead of displaying it.
```

## `return` ends the function: returning early

The moment Python hits a `return`, the function is **over**. Any lines after it are skipped, even lines inside a loop. That sounds like a limitation, but it''s a superpower: once you know the answer, you can leave.

```python run
def shipping_cost(order_total):
    if order_total >= 50:
        return 0            # free shipping: done, leave now
    if order_total >= 20:
        return 3.99
    return 7.99             # only reached for small orders

for total in [75, 50, 35, 8]:
    print(f"${total} order -> shipping ${shipping_cost(total)}")
```

No `elif` or `else` needed: each `return` exits, so a later line only runs when every earlier condition was false. This style, handling the special cases first and leaving, is called an **early return** (or a "guard clause"), and professional code uses it everywhere to avoid deeply nested `if`s.

Early returns work inside loops too. This function searches a list and stops at the first match:

```python run
def first_over_budget(expenses, budget):
    for amount in expenses:
        if amount > budget:
            return amount       # found one: stop searching
    return None                 # loop finished: nothing was over budget

print(first_over_budget([12, 40, 95, 300], 50))
print(first_over_budget([12, 40], 50))
```

Notice where the final `return None` sits: **after** the loop, not inside it. The function can only conclude "nothing found" once it has checked *every* item. Writing `return None` explicitly isn''t required (it''s the default), but it tells the reader you meant it.

```python exercise id=ticket-price title="Cinema ticket prices"
# TODO: return the ticket price for a given age:
#   under 3      -> 0     (babies are free)
#   3 to 12      -> 8
#   13 to 64     -> 14
#   65 and over  -> 9
# Early returns make this short and clear.
def ticket_price(age):
    """Return the ticket price in dollars for a visitor of this age."""
    ...

print("toddler:", ticket_price(2))
print("adult:", ticket_price(30))
--- solution
def ticket_price(age):
    """Return the ticket price in dollars for a visitor of this age."""
    if age < 3:
        return 0
    if age <= 12:
        return 8
    if age >= 65:
        return 9
    return 14

print("toddler:", ticket_price(2))
print("adult:", ticket_price(30))
--- test
assert ticket_price(30) is not None, "`ticket_price(30)` gave back `None`. Replace the `...` and make sure every path ends in a `return`."
cases = {0: 0, 2: 0, 3: 8, 7: 8, 12: 8, 13: 14, 40: 14, 64: 14, 65: 9, 90: 9}
for age, price in cases.items():
    got = ticket_price(age)
    assert got is not None, f"`ticket_price({age})` gave back `None`. Is there a path through your function that never reaches a `return`?"
    assert got == price, f"`ticket_price({age})` should be {price}, but is {got!r}. Check the boundary: is {age} included in the right group?"
--- hint
Handle one age group per `if`, and `return` the price right away. Later checks only run if earlier ones didn''t return.
--- hint
Watch the edges: 3 pays 8, 12 pays 8, 13 pays 14, 65 pays 9. Use `<`, `<=` or `>=` accordingly.
--- hint
Start with `if age < 3: return 0`, then `if age <= 12: return 8`, and so on, with a final `return` for everyone else.
```

The flip side of "return ends the function" is a bug every programmer writes at least once: putting a `return` in a loop where it fires too soon.

```python debug id=all-in-stock title="Everything looks in stock"
def all_in_stock(quantities):
    """Return True only if every quantity is above zero."""
    for qty in quantities:
        if qty <= 0:
            return False
        else:
            return True

shelf = [5, 12, 0, 3]
print("All in stock?", all_in_stock(shelf))
--- solution
def all_in_stock(quantities):
    """Return True only if every quantity is above zero."""
    for qty in quantities:
        if qty <= 0:
            return False
    return True

shelf = [5, 12, 0, 3]
print("All in stock?", all_in_stock(shelf))
--- test
assert all_in_stock([5, 12, 0, 3]) is False, "`all_in_stock([5, 12, 0, 3])` should be False: one item has 0 left. Does your loop look past the first item?"
assert all_in_stock([4, 2, 9]) is True, "`all_in_stock([4, 2, 9])` should be True."
assert all_in_stock([0, 8]) is False, "`all_in_stock([0, 8])` should be False."
assert all_in_stock([7, 1, 1, -2]) is False, "`all_in_stock([7, 1, 1, -2])` should be False: the last item is below zero."
assert all_in_stock([]) is True, "With no items to check, nothing is out of stock, so `all_in_stock([])` should be True (not None)."
--- hint
Click **Debug** and step through. How many items does the loop look at before the function returns?
--- hint
You can say "False" as soon as you find a bad item, but you can only say "True" after checking *all* of them. Where does a line go so it runs after the loop finishes?
```

## Returning several values at once

A function can only `return` one thing, but that thing can be a **tuple**. Write the values separated by commas, and unpack them at the call site just like you did in lesson 15:

```python run
def price_range(prices):
    return min(prices), max(prices)

cheapest, priciest = price_range([4.99, 12.00, 2.49, 7.25])
print("cheapest:", cheapest)
print("priciest:", priciest)
price_range([10, 3, 8])
```

The last line shows what really comes back: a single tuple, `(3, 10)`. The unpacking on the call side is what makes it *feel* like two return values.

```python predict id=predict-tuple-return title="What is displayed?"
def split_minutes(total):
    return total // 60, total % 60

split_minutes(135)
--- options
2 15
2:15
* (2, 15)
[2, 15]
--- explain
`return a, b` builds a tuple, and a tuple displays with parentheses. You''d unpack it with `hours, minutes = split_minutes(135)` to get the two numbers separately.
```

```python exercise id=score-summary title="Summarize a game''s scores"
# TODO: return THREE values, in this order: the lowest score, the highest
# score, and the average score rounded to 1 decimal place.
def score_summary(scores):
    """Return (lowest, highest, average) for a non-empty list of scores."""
    ...

print(score_summary([72, 95, 88, 61]))
--- solution
def score_summary(scores):
    """Return (lowest, highest, average) for a non-empty list of scores."""
    average = round(sum(scores) / len(scores), 1)
    return min(scores), max(scores), average

low, high, avg = score_summary([72, 95, 88, 61])
print(f"low {low}, high {high}, average {avg}")
--- test
result = score_summary([72, 95, 88, 61])
assert result is not None, "`score_summary` gave back `None`. Replace the `...` with code that ends in `return`."
assert isinstance(result, tuple), f"`score_summary` should return a tuple of three values (`return a, b, c`), but returned {result!r}."
assert len(result) == 3, f"Return exactly three values (lowest, highest, average), not {len(result)}."
assert result[:2] == (61, 95), f"The first two values should be the lowest (61) and highest (95), in that order, but got {result[:2]}."
assert result[2] == 79.0, f"The average of [72, 95, 88, 61] is 79.0, but your third value is {result[2]!r}."
fresh = score_summary([10, 3, 4])
assert fresh == (3, 10, 5.7), f"`score_summary([10, 3, 4])` should be (3, 10, 5.7), but is {fresh!r}. Is the average rounded to 1 decimal?"
assert score_summary([50]) == (50, 50, 50.0), f"`score_summary([50])` should be (50, 50, 50.0), but is {score_summary([50])!r}."
--- hint
`min()`, `max()`, `sum()` and `len()` all work on a list.
--- hint
The average is `sum(scores) / len(scores)`, passed through `round(..., 1)`.
--- hint
Separate the three values with commas after `return`: `return lowest, highest, average`.
```

## Docstrings: say what your function does

The string on the first line of a function''s body is its **docstring**. It''s not a comment: Python stores it with the function, and tools like editors, autocomplete and `help()` show it to anyone using your code.

```python run
def bmi(weight_kg, height_m):
    """Return body-mass index: weight in kg divided by height in metres squared."""
    return round(weight_kg / height_m ** 2, 1)

help(bmi)
```

A good docstring says **what goes in and what comes out**, in one sentence if possible: "Return the shipping cost for an order total in dollars." Use triple quotes, even for one line, so it''s easy to extend later. (You''ll use `help()` to explore Python''s own modules in lesson 25.)

> **In the wild:** In professional codebases (Django, pandas, the Python standard library itself), almost every public function has a docstring. Documentation websites are often *generated* straight from them, so the docstring is the manual.

## Functions calling functions

Once a function exists, other functions can use it, just like you use `len()` inside your own code. This is how big programs are built: small, trustworthy pieces stacked into bigger ones.

```python run
def subtotal(prices):
    """Return the sum of all prices."""
    return sum(prices)

def with_tax(amount, rate):
    """Return amount plus tax at the given rate (0.2 means 20%)."""
    return round(amount * (1 + rate), 2)

def checkout(prices):
    """Return the amount to charge: subtotal plus 20% tax."""
    return with_tax(subtotal(prices), 0.2)

print("to pay:", checkout([3.50, 12.00, 4.25]))
```

Each function does one job and has a name that explains it. `checkout` reads almost like English. Press **Debug** on that cell and step *into* the calls: you''ll see Python jump into `subtotal`, return, jump into `with_tax`, return, and finally finish `checkout`.

> **Tip:** If you can''t describe what a function does in one short sentence without the word "and", it''s probably doing two jobs. Split it.

## Testing your function with `assert`

How do you know your function works? You could print results and eyeball them, but professionals write **checks** that run automatically. Python''s `assert` statement does exactly that: `assert condition, "message"` does nothing if the condition is true, and stops with an `AssertionError` if it''s false.

```python run
def is_even(n):
    return n % 2 == 0

assert is_even(4)
assert not is_even(7)
assert is_even(0), "zero counts as even"
print("All is_even checks passed!")
```

Silence means success. Now see what a failing check looks like:

```python run error
def average(numbers):
    return sum(numbers) / 2      # bug: assumes there are always two numbers

assert average([4, 6]) == 5
assert average([3, 6, 9]) == 6, "average of three numbers is wrong"
```

The first check passed by luck, and the second one caught the bug with your message attached. Good checks include **ordinary** cases, **edge** cases (zero, empty, the boundary between two groups) and inputs that are *different from your examples*, so the function can''t be right by coincidence. That''s exactly how the hidden tests in this course check your challenges.

```python exercise id=initials-with-tests title="Initials that pass their own checks"
# TODO: complete `initials` so it returns the capitalized first letter
# of each word, each followed by a dot:
#    "ada lovelace" -> "A.L."    "grace brewster hopper" -> "G.B.H."
# The asserts below are your safety net: until the function works, they
# stop the program with a clear message. Don''t change them.
def initials(full_name):
    """Return initials like ''A.L.'' for a name like ''ada lovelace''."""
    ...

assert initials("ada lovelace") == "A.L.", "initials(''ada lovelace'') should be ''A.L.''"
assert initials("Alan Turing") == "A.T.", "initials(''Alan Turing'') should be ''A.T.''"
print("All checks passed!")
--- solution
def initials(full_name):
    """Return initials like ''A.L.'' for a name like ''ada lovelace''."""
    result = ""
    for word in full_name.split():
        result += word[0].upper() + "."
    return result

assert initials("ada lovelace") == "A.L.", "initials(''ada lovelace'') should be ''A.L.''"
assert initials("Alan Turing") == "A.T.", "initials(''Alan Turing'') should be ''A.T.''"
print("All checks passed!")
--- test
got = initials("ada lovelace")
assert isinstance(got, str), f"`initials` should return a string, but returned {got!r}."
assert got == "A.L.", f"`initials(''ada lovelace'')` should be ''A.L.'', but is {got!r}."
assert initials("grace brewster hopper") == "G.B.H.", f"`initials(''grace brewster hopper'')` should be ''G.B.H.'', but is {initials(''grace brewster hopper'')!r}."
assert initials("  bob   ross ") == "B.R.", f"Extra spaces shouldn''t matter: `initials(''  bob   ross '')` should be ''B.R.'', but is {initials(''  bob   ross '')!r}. Try `.split()` with no argument."
assert initials("cher") == "C.", f"`initials(''cher'')` should be ''C.'', but is {initials(''cher'')!r}."
assert "All checks passed!" in _stdout, "Keep the asserts and the final print, so you can see your checks pass."
--- hint
Press Run first: your own assert stops the program and says what''s wrong. That''s exactly what checks are for. Now make the function earn a pass.
--- hint
`full_name.split()` gives you the words. Take `word[0]` from each one and make it uppercase.
--- hint
Build the answer in a loop with an accumulator string, adding `word[0].upper() + "."` each time, then `return` it after the loop. (A comprehension with `"".join(...)` works too.)
```

## Recap

- `def name(params):` defines a function; its body runs only when you **call** it with `name(args)`. Without `()`, nothing runs.
- **Parameters** are the named slots in the `def` line; **arguments** are the values you pass, matched left to right.
- `return` hands a value back to the caller and ends the function immediately. A function with no `return` gives back `None`, and `NoneType` in an error usually means a missing `return`.
- Prefer `return` over `print` in functions that compute something. Put "found nothing" returns *after* the loop, not inside it.
- `return a, b` returns a tuple you can unpack; a docstring documents what goes in and comes out; `assert` turns your expectations into automatic checks.

**Up next:** arguments in depth: default values, keyword arguments, and functions that accept any number of inputs with `*args` and `**kwargs`.
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_python_basics_5_2', 'sec_python_basics_5', 'crs_python_basics', 'Arguments in depth: defaults, keywords, *args and **kwargs', 'interactive', 1, 1080, NULL, NULL, 'You''ve already used fancy arguments without thinking about it. `print("a", "b", sep="-")` passes two values *and* a named setting. `sorted(scores, reverse=True)` flips the order with a word instead of a position. `round(3.14159)` works with one argument, and `round(3.14159, 2)` with two. And `print` happily takes one value, five values, or none at all.

None of that is magic reserved for built-ins. In this lesson you''ll give your own functions the same flexibility: **keyword arguments** that make calls readable, **default values** for settings people rarely change, functions that accept **any number** of inputs with `*args` and `**kwargs`, and the one famous trap (the mutable default) that bites almost every Python programmer once. By the end, you''ll design function signatures that are pleasant to call and hard to misuse.

## Positional and keyword arguments

So far you''ve passed arguments **by position**: the first value fills the first parameter, the second fills the second. You can also pass them **by name**, writing `parameter=value` in the call. These are **keyword arguments**, and with them the order no longer matters.

```python run
def book_flight(origin, destination, passengers):
    return f"{passengers} seat(s) from {origin} to {destination}"

print(book_flight("Lisbon", "Tokyo", 2))                                  # positional
print(book_flight(destination="Tokyo", passengers=2, origin="Lisbon"))    # keyword, any order
print(book_flight("Lisbon", passengers=2, destination="Tokyo"))           # mixed
```

All three calls do the same thing. Keyword arguments shine when a call would otherwise be a mystery: `book_flight("Lisbon", "Tokyo", 2)` makes you remember which city is which, while `destination="Tokyo"` says it outright.

The one rule when mixing: **positional arguments come first, keywords after.** Once you''ve started naming, Python can no longer tell which slot a bare value belongs to:

```python run error
book_flight(origin="Lisbon", "Tokyo", 2)
```

That''s a `SyntaxError`, so Python refuses to run the line at all. There''s also a `TypeError` for filling the same slot twice, as in `book_flight("Lisbon", origin="Porto", ...)`: "got multiple values for argument ''origin''".

```python predict id=predict-positional-order title="What does this print?"
def describe(animal, name):
    return f"{name} the {animal}"

print(describe("Rex", "dog"))
--- options
Rex the dog
* dog the Rex
Rex the Rex
TypeError
--- explain
Positional arguments are matched by **order**, not by meaning. `"Rex"` lands in `animal` and `"dog"` lands in `name`, so you get `dog the Rex`. Calling `describe(name="Rex", animal="dog")` would make the intent impossible to mix up.
```

## Default values

Many functions have settings that are *usually* the same. Give such a parameter a **default value** in the `def` line, and callers can leave it out:

```python run
def make_coffee(size="medium", milk=True, sugars=0):
    order = f"{size} coffee"
    if milk:
        order += " with milk"
    if sugars:
        order += f" and {sugars} sugar(s)"
    return order

print(make_coffee())
print(make_coffee("large"))
print(make_coffee(sugars=2))
print(make_coffee("small", milk=False))
```

Look at the third call: `sugars=2` skips over `size` and `milk`, which keep their defaults. That''s the real power of combining defaults with keywords: callers change only what they care about. It''s exactly how `print(..., sep=" ", end="\n")` works.

Parameters **with** defaults must come **after** parameters without them. Otherwise a call like `f(5)` would be ambiguous:

```python run error
def greet(greeting="Hello", name):
    return f"{greeting}, {name}!"
```

The fix is to put the required parameter first: `def greet(name, greeting="Hello")`.

> **In the wild:** Library functions often have a dozen parameters with defaults. pandas'' `read_csv` has more than 40! You''ll typically pass one positional argument (the file) and two or three keywords, like `read_csv("sales.csv", sep=";", encoding="utf-8")`. Defaults are what make such powerful functions usable.

```python exercise id=format-price title="Format a price tag"
# TODO 1: replace the two ... in the def line with defaults:
#   `currency` defaults to "$", `decimals` defaults to 2.
# TODO 2: replace the ... in the body to RETURN the price string.
# Examples:
#   format_price(4.5)                    -> "$4.50"
#   format_price(4.5, "€")               -> "€4.50"
#   format_price(1299, decimals=0)       -> "$1299"
#   format_price(3.14159, "£", 3)        -> "£3.142"
def format_price(amount, currency=..., decimals=...):
    """Return `amount` formatted as a price string, like ''$4.50''."""
    ...

print(format_price(4.5))
--- solution
def format_price(amount, currency="$", decimals=2):
    """Return `amount` formatted as a price string, like ''$4.50''."""
    return f"{currency}{amount:.{decimals}f}"

print(format_price(4.5))
--- test
assert ... not in (format_price.__defaults__ or ()), "Replace the two `...` defaults in the `def` line with real values."
assert format_price(4.5) is not None, "`format_price` gave back `None`. Replace the `...` in the body with a `return` statement."
assert isinstance(format_price(4.5), str), f"`format_price` should return a string, but returned {format_price(4.5)!r}."
assert format_price(4.5) == "$4.50", f"`format_price(4.5)` should be ''$4.50'' (default currency and 2 decimals), but is {format_price(4.5)!r}."
assert format_price(4.5, "€") == "€4.50", f"`format_price(4.5, ''€'')` should be ''€4.50'', but is {format_price(4.5, ''€'')!r}. Is `currency` the second parameter?"
assert format_price(1299, decimals=0) == "$1299", f"`format_price(1299, decimals=0)` should be ''$1299'', but is {format_price(1299, decimals=0)!r}."
assert format_price(3.14159, "£", 3) == "£3.142", f"`format_price(3.14159, ''£'', 3)` should be ''£3.142'', but is {format_price(3.14159, ''£'', 3)!r}."
assert format_price(amount=7, currency="¥", decimals=1) == "¥7.0", "All three parameters should be named `amount`, `currency` and `decimals`."
--- hint
In the header, a default is written `name=value`, so `currency="$"` and `decimals=2`.
--- hint
An f-string format spec can contain another `{...}`: `f"{amount:.{decimals}f}"` uses the value of `decimals` as the number of digits.
--- hint
`round(amount, decimals)` alone won''t add trailing zeros (4.5 stays `4.5`). Build the string with the format spec, then put `currency` in front.
```

## The mutable default trap

Here''s a function that adds an item to a shopping cart, or starts a new cart if you don''t pass one. It looks perfectly reasonable. Run it:

```python run
def add_item(item, cart=[]):
    cart.append(item)
    return cart

alice = add_item("apples")
bob = add_item("bread")
print("alice:", alice)
print("bob:  ", bob)
```

Bob never asked for apples! Both "new" carts are **the same list**.

> **Under the hood:** A default value is created **once**, when Python runs the `def` line, not each time the function is called. Every call that leaves out `cart` gets that one shared list. Numbers, strings and `None` are immutable, so sharing them is harmless. A list, dict or set can be changed in place, so changes pile up between calls.

The fix is a pattern you''ll see in professional code everywhere: default to **`None`**, and create the fresh list *inside* the function, where it runs on every call.

```python run
def add_item(item, cart=None):
    if cart is None:
        cart = []            # a brand-new list, every call
    cart.append(item)
    return cart

alice = add_item("apples")
bob = add_item("bread")
print("alice:", alice)
print("bob:  ", bob)
add_item("milk", alice)     # you can still pass your own cart
```

(`is None` is the standard way to test for `None`, as you saw in lesson 7.)

```python predict id=predict-mutable-default title="What does this print?"
def log_visit(page, history=[]):
    history.append(page)
    return len(history)

print(log_visit("home"), log_visit("shop"), log_visit("cart"))
--- options
1 1 1
* 1 2 3
3 3 3
0 1 2
--- explain
All three calls share the **same** default list, created once when the `def` ran. It grows to 1, then 2, then 3 items. With `history=None` and `if history is None: history = []` inside, each call would start fresh and print `1 1 1`.
```

```python debug id=playlist-shared-default title="New playlists already have songs"
def new_playlist(name, songs=[]):
    """Return a playlist dict. Starts empty unless songs are given."""
    return {"name": name, "songs": songs}

road_trip = new_playlist("Road trip")
road_trip["songs"].append("Life is a Highway")

study = new_playlist("Study")
print("study songs:", study["songs"])   # should be empty!
--- solution
def new_playlist(name, songs=None):
    """Return a playlist dict. Starts empty unless songs are given."""
    if songs is None:
        songs = []
    return {"name": name, "songs": songs}

road_trip = new_playlist("Road trip")
road_trip["songs"].append("Life is a Highway")

study = new_playlist("Study")
print("study songs:", study["songs"])   # should be empty!
--- test
assert study["songs"] == [], f"The Study playlist should start empty, but has {study[''songs'']!r}. Are two playlists sharing one list?"
assert road_trip["songs"] == ["Life is a Highway"], f"Road trip should hold exactly one song, but has {road_trip[''songs'']!r}."
a = new_playlist("A")
b = new_playlist("B")
a["songs"].append("x")
assert b["songs"] == [], "Two playlists made without `songs` still share the same list. Each call needs its own new list."
mine = ["Song 1"]
assert new_playlist("Mine", mine)["songs"] == ["Song 1"], "When songs ARE passed in, the playlist should use them."
--- hint
Run it: the Study playlist starts with a song it never got. When is the default `[]` created: once, or on every call?
--- hint
Use `None` as the default, and inside the function replace it with a fresh `[]` when `songs is None`.
```

## `*args`: any number of positional arguments

`print` accepts as many values as you give it. Your functions can too: put a `*` before a parameter name, and it collects **all the extra positional arguments into a tuple**. By convention it''s called `args`, but a descriptive name is often better.

```python run
def total(*prices):
    print("prices is a", type(prices).__name__, "holding", prices)
    return sum(prices)

print(total(4.50, 2.25))
print(total(10, 20, 30, 40))
print(total())
```

You can combine `*args` with normal parameters. The normal ones fill up first, and the star collects whatever is left:

```python run
def order(customer, *items):
    return f"{customer} ordered {len(items)} item(s): {'', ''.join(items)}"

order("Priya", "latte", "croissant", "orange juice")
```

```python predict id=predict-args-list title="What does this print?"
def count_items(*items):
    return len(items)

groceries = ["eggs", "rice", "kale"]
print(count_items(groceries))
--- options
3
* 1
0
TypeError
--- explain
`*items` collects each **argument** into the tuple, and only one argument was passed: the whole list. So `items` is `(["eggs", "rice", "kale"],)`, a tuple holding one list, and its length is 1. To pass the three strings as separate arguments you''d call `count_items(*groceries)`, which you''ll meet in a moment.
```

```python exercise id=average-of title="An average of anything"
# `*numbers` collects every number passed in.
# TODO: return their average, rounded to 2 decimal places.
# With no numbers at all, return 0.
#   average_of(4, 8, 6)  -> 6.0
#   average_of(2.5)      -> 2.5
#   average_of()         -> 0
def average_of(*numbers):
    """Return the average of all the numbers passed in (0 if none)."""
    ...

print(average_of(4, 8, 6))
--- solution
def average_of(*numbers):
    """Return the average of all the numbers passed in (0 if none)."""
    if not numbers:
        return 0
    return round(sum(numbers) / len(numbers), 2)

print(average_of(4, 8, 6))
--- test
assert average_of(4, 8, 6) is not None, "`average_of` gave back `None`. Replace the `...` with code that returns the average."
assert average_of(4, 8, 6) == 6.0, f"`average_of(4, 8, 6)` should be 6.0, but is {average_of(4, 8, 6)!r}."
assert average_of(2.5) == 2.5, f"`average_of(2.5)` should be 2.5, but is {average_of(2.5)!r}."
assert average_of(1, 2, 2) == 1.67, f"`average_of(1, 2, 2)` should be 1.67 (rounded to 2 decimals), but is {average_of(1, 2, 2)!r}."
assert average_of(10, 20, 30, 40, 50, 60) == 35.0, "`average_of` should work with six numbers too."
assert average_of() == 0, f"`average_of()` with no numbers should return 0, but returned {average_of()!r}. Watch out for dividing by zero!"
--- hint
`*numbers` gathers every positional argument into a tuple. Inside the function, `numbers` is just a tuple: `sum()` and `len()` work on it.
--- hint
An empty tuple is falsy. Check `if not numbers:` first, and return 0 early.
--- hint
Otherwise, `round(sum(numbers) / len(numbers), 2)`.
```

## `**kwargs`: any number of keyword arguments

Two stars collect any extra **keyword** arguments into a **dictionary**: names become keys, values become values. The conventional name is `kwargs` ("keyword arguments").

```python run
def make_profile(username, **details):
    profile = {"username": username}
    profile.update(details)
    return profile

print(make_profile("sam_codes"))
print(make_profile("ana_k", city="Porto", age=29, likes="surfing"))
```

`**kwargs` is perfect when the set of options is open-ended: tags on a blog post, extra columns in a record, settings passed through to another function.

```python exercise id=trip-summary title="A flexible trip summary"
# `trip_summary` takes a required `destination`, and `**details` collects
# ANY number of keyword details into a dict.
# TODO: return one line: the destination, then each detail
# as "key: value", all joined by " | ", in the order they were given.
#   trip_summary("Kyoto", nights=5, budget=1800)
#     -> "Kyoto | nights: 5 | budget: 1800"
#   trip_summary("Rome") -> "Rome"
def trip_summary(destination, **details):
    """Return a one-line summary of a trip and its details."""
    ...

print(trip_summary("Kyoto", nights=5, budget=1800))
--- solution
def trip_summary(destination, **details):
    """Return a one-line summary of a trip and its details."""
    parts = [destination]
    for key, value in details.items():
        parts.append(f"{key}: {value}")
    return " | ".join(parts)

print(trip_summary("Kyoto", nights=5, budget=1800))
--- test
got = trip_summary("Kyoto", nights=5, budget=1800)
assert got is not None, "`trip_summary` gave back `None`. Replace the `...` with code that returns a string."
assert isinstance(got, str), f"`trip_summary` should return a string, but returned {got!r}."
assert got == "Kyoto | nights: 5 | budget: 1800", f"Expected ''Kyoto | nights: 5 | budget: 1800'', but got {got!r}."
assert trip_summary("Rome") == "Rome", f"With no details, `trip_summary(''Rome'')` should be just ''Rome'', but is {trip_summary(''Rome'')!r}."
fresh = trip_summary("Reykjavík", season="winter", travellers=3, car=True)
assert fresh == "Reykjavík | season: winter | travellers: 3 | car: True", f"`trip_summary` should accept any keywords, in order. Got {fresh!r}."
assert trip_summary(destination="Cairo", nights=2) == "Cairo | nights: 2", "The required parameter should be called `destination`."
--- hint
Inside the function, `details` is an ordinary dict, like `{"nights": 5, "budget": 1800}`.
--- hint
Loop over `details.items()` to get each key and value, building a list of strings that starts with `destination`.
--- hint
`" | ".join(parts)` glues a list of strings together with the separator.
```

## Unpacking at the call site: `*` and `**` in calls

The stars also work in the **opposite direction**. In a *call*, `*sequence` spreads a list or tuple out into separate positional arguments, and `**dictionary` spreads a dict out into keyword arguments.

```python run
def book_table(name, guests, time):
    return f"Table for {guests} under ''{name}'' at {time}"

walk_in = ["Okafor", 4, "19:30"]
online = {"time": "20:00", "name": "Lindqvist", "guests": 2}

print(book_table(*walk_in))      # same as book_table("Okafor", 4, "19:30")
print(book_table(**online))      # same as book_table(time="20:00", name=..., guests=2)

scores = [88, 92, 79]
print(*scores, sep=" / ")        # works with built-ins too
```

This is handy when your data already lives in a list or dict, for instance a row read from a file (lesson 24) or settings loaded from JSON.

| Where | `*` | `**` |
|---|---|---|
| in a `def` | **collects** extra positional args into a tuple | **collects** extra keyword args into a dict |
| in a call | **spreads** a list/tuple into positional args | **spreads** a dict into keyword args |

## Keyword-only arguments

Sometimes a call is only safe if it''s readable. Anything after a lone `*` in the parameter list **must** be passed by keyword:

```python run
def transfer(amount, *, from_account, to_account):
    return f"Moved ${amount} from {from_account} to {to_account}"

transfer(250, from_account="savings", to_account="checking")
```

Nobody can accidentally swap the two accounts by order, because order isn''t allowed:

```python run error
transfer(250, "savings", "checking")
```

> **In the wild:** Python''s own `sorted(items, key=..., reverse=...)` makes `key` and `reverse` keyword-only for exactly this reason: `sorted(items, len, True)` would be unreadable.

When you combine everything, Python requires this order in the `def` line:

```python
def f(required, with_default=1, *args, keyword_only, **kwargs):
    ...
```

You''ll rarely need all five kinds at once. Most good functions have a couple of required parameters and a few defaults.

## Debug: the wrong slot

The most common argument bug isn''t a crash. It''s a call that passes the right values **in the wrong order**, so the function silently computes nonsense.

```python debug id=savings-wrong-order title="Savings grow to almost nothing"
def future_value(deposit, yearly_rate, years):
    """Return what `deposit` grows to after `years` of compound interest."""
    return round(deposit * (1 + yearly_rate) ** years, 2)

# Ana deposits $1000 at 5% a year for 10 years.
ana = future_value(0.05, 1000, 10)
# Ben deposits $2500 at 3% a year for 20 years.
ben = future_value(2500, 20, 0.03)

print("Ana will have:", ana)
print("Ben will have:", ben)
--- solution
def future_value(deposit, yearly_rate, years):
    """Return what `deposit` grows to after `years` of compound interest."""
    return round(deposit * (1 + yearly_rate) ** years, 2)

# Ana deposits $1000 at 5% a year for 10 years.
ana = future_value(deposit=1000, yearly_rate=0.05, years=10)
# Ben deposits $2500 at 3% a year for 20 years.
ben = future_value(deposit=2500, yearly_rate=0.03, years=20)

print("Ana will have:", ana)
print("Ben will have:", ben)
--- test
assert ana == round(1000 * 1.05 ** 10, 2), f"Ana should end with about $1628.89, but `ana` is {ana!r}. Which value went into which parameter?"
assert ben == round(2500 * 1.03 ** 20, 2), f"Ben should end with about $4515.28, but `ben` is {ben!r}. Check the order of his three arguments."
assert future_value(100, 0.1, 2) == 121.0, "`future_value` itself was correct. Fix the calls, not the formula."
--- hint
Run it. Ana''s result is tiny and Ben''s is enormous. Compare each call''s argument order with the `def` line.
--- hint
Either reorder the values to match `deposit, yearly_rate, years`, or (better) pass them as keyword arguments so the order can''t be wrong.
```

> **Tip:** When a function has several parameters of the same type (three numbers, two account names), call it with keywords. It costs a few characters and prevents a whole class of silent bugs.

## Recap

- Arguments can be **positional** (matched by order) or **keyword** (`name=value`, any order). Positional ones must come first.
- **Defaults** (`def f(x, size="medium")`) make parameters optional; parameters with defaults go after those without.
- Defaults are created **once**, so never use a mutable default like `[]` or `{}`. Default to `None` and create a fresh one inside.
- `*args` collects extra positional arguments into a tuple; `**kwargs` collects extra keyword arguments into a dict. In a call, `*` and `**` do the reverse and spread a list or dict out.
- Parameters after a lone `*` are **keyword-only**, which keeps calls readable and order-proof.

**Up next:** scope: where the names inside a function live, why a function can read a global but not change it, and how to avoid accidentally hiding Python''s built-ins.
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z'),
('les_python_basics_5_3', 'sec_python_basics_5', 'crs_python_basics', 'Scope: where names live', 'interactive', 2, 840, NULL, NULL, 'Two of your functions both use a variable called `total`. Does one overwrite the other? Your program has a `score` at the top, and a function that tries to add a point to it, and Python crashes with an error you''ve never seen. You named a variable `sum`, and three cells later `sum([1, 2, 3])` says `''int'' object is not callable`.

All three puzzles have the same answer: **scope**, the rules for *where a name lives* and *which part of the code can see it*. Think of each function call as its own little room with its own sticky notes on the wall. Code in the room can glance out of the window at the notes in the hallway, but it writes on its own wall. Once you see code this way, those confusing errors become obvious, and you''ll understand why good functions take everything they need as parameters and hand results back with `return`.

## Local variables live inside the function

A variable created inside a function is **local**: it exists only while that call is running, and only code inside the function can see it.

```python run
def checkout(subtotal):
    discount = subtotal * 0.1          # local to checkout
    return subtotal - discount

print("to pay:", checkout(80))
```

The function used `discount` just fine. But from outside, there''s no such name:

```python run error
print(discount)
```

When `checkout` returned, its room was cleared out, sticky notes and all. Only the **returned value** made it out. That''s a feature: a function''s helper variables can''t leak out and collide with yours.

Every call also gets a **brand-new** room. Local variables don''t remember anything from the previous call:

```python run
def count_vowels(word):
    count = 0                          # starts at 0 on EVERY call
    for letter in word.lower():
        if letter in "aeiou":
            count += 1
    return count

print(count_vowels("banana"), count_vowels("sky"), count_vowels("Ouagadougou"))
```

## Parameters are local too

A parameter is just a local variable that gets filled in from the call. Reassigning it inside the function changes the function''s own note, not the caller''s variable:

```python run
def apply_coupon(price):
    price = price - 5          # rebinds the LOCAL name `price`
    return price

price = 30
new_price = apply_coupon(price)
print("price:", price, "| new_price:", new_price)
```

Two different `price`s: one in the hallway (the global, still 30), one inside the function''s room (25). The only way the result gets out is `return`.

> **Pitfall:** Reassigning a parameter (`items = [...]`) only changes the local name. But *mutating* the object it refers to (`items.append(...)`, `scores[0] = 99`) changes the one list both names point to, exactly like the aliasing you saw in lesson 14. If a function shouldn''t change a list it was given, work on a copy.

```python predict id=predict-param-local title="What does this print?"
lives = 3

def lose_life(lives):
    lives = lives - 1
    return lives

lose_life(lives)
print(lives)
--- options
2
* 3
None
UnboundLocalError
--- explain
Inside `lose_life`, `lives` is a **parameter**, a local name. Subtracting 1 rebinds only that local. The function returns 2, but nobody stores the result, so the global `lives` is still 3. You''d need `lives = lose_life(lives)`.
```

```python exercise id=sale-prices title="A sale that leaves the menu alone"
# TODO: return a NEW list where every price is reduced by `percent`
# percent, rounded to 2 decimals. The list passed in must NOT change.
#   discounted([10.0, 4.5], 20) -> [8.0, 3.6]
def discounted(prices, percent):
    """Return a new list of prices reduced by `percent` percent."""
    ...

menu = [10.0, 4.5, 8.0]
sale = discounted(menu, 20)
print("sale:", sale)
print("menu:", menu)
--- solution
def discounted(prices, percent):
    """Return a new list of prices reduced by `percent` percent."""
    result = []
    for p in prices:
        result.append(round(p * (1 - percent / 100), 2))
    return result

menu = [10.0, 4.5, 8.0]
sale = discounted(menu, 20)
print("sale:", sale)
print("menu:", menu)
--- test
probe = [10.0, 4.5, 8.0]
out = discounted(probe, 20)
assert out is not None, "`discounted` gave back `None`. Replace the `...` with code that returns a new list."
assert isinstance(out, list), f"`discounted` should return a list, but returned {out!r}."
assert probe == [10.0, 4.5, 8.0], f"The list passed in was changed to {probe!r}. Build a new list instead of changing `prices` in place."
assert out is not probe, "You returned the same list object you were given. Return a brand-new list."
assert out == [8.0, 3.6, 6.4], f"`discounted([10.0, 4.5, 8.0], 20)` should be [8.0, 3.6, 6.4], but is {out!r}."
fresh = [100, 19.99]
assert discounted(fresh, 15) == [85.0, 16.99], f"`discounted([100, 19.99], 15)` should be [85.0, 16.99], but is {discounted(fresh, 15)!r}."
assert discounted([], 50) == [], "An empty menu should give an empty list."
--- hint
A price reduced by 20% is `price * (1 - 20 / 100)`.
--- hint
Start with an empty list, append each new price in a loop, and return that new list. (A list comprehension works too.) Never assign into `prices[i]`.
```

## Globals: readable from anywhere

A variable created at the top level of your program (outside any function) is **global**. Functions can **read** globals without doing anything special:

```python run
TAX_RATE = 0.2          # a global constant

def with_tax(amount):
    return round(amount * (1 + TAX_RATE), 2)    # reading a global: fine

print(with_tax(50), with_tax(19.99))
```

> **Tip:** Writing a global in `UPPER_CASE` is a convention meaning "this is a constant; nobody changes it." Reading global *constants* from functions is perfectly normal and good style. Things get messy when functions start *changing* globals, as you''ll see below.

## How Python finds a name: LEGB

When Python meets a name, it searches four places, **in order**, and uses the first match:

```text
 L  Local      names created in the current function call
 E  Enclosing  names in any function wrapped around this one (see the end of the lesson)
 G  Global     names created at the top level of the program
 B  Built-in   Python''s own names: print, len, sum, max, str, ...
```

That''s why `len` works everywhere (it''s found in Built-in), and why a local variable **hides** a global with the same name: Local is checked first.

```python run
city = "Paris"                  # global

def postcard():
    city = "Kyoto"              # local: hides the global inside this function
    return f"Greetings from {city}!"

print(postcard())
print("global city is still:", city)
```

```python predict id=predict-legb title="What does this print?"
greeting = "Hello"

def welcome(name):
    greeting = "Welcome"
    return f"{greeting}, {name}"

print(welcome("Kai"), greeting)
--- options
Hello, Kai Hello
Welcome, Kai Welcome
* Welcome, Kai Hello
Hello, Kai Welcome
--- explain
Inside `welcome`, the assignment creates a **local** `greeting`, so the function uses `"Welcome"`. Outside, the global `greeting` was never touched and is still `"Hello"`.
```

## Changing a global: the UnboundLocalError

Here''s the crash from the introduction. A game keeps a global `score`, and a function tries to add a point:

```python run error
score = 0

def add_point():
    score = score + 1
    return score

add_point()
```

`cannot access local variable ''score'' where it is not associated with a value`. Why "local"? Because of one simple rule:

> **Under the hood:** Python decides whether a name is local **before** the function runs, by scanning the whole body. If the name is **assigned anywhere** in the function (`=`, `+=`, a `for` loop variable…), it''s local for the **entire** function. So in `score = score + 1`, the `score` on the right is the local one too, and it doesn''t have a value yet.

You can tell Python "I mean the global one" with the `global` keyword:

```python run
score = 0

def add_point():
    global score         # assignments now go to the global `score`
    score = score + 1

add_point()
add_point()
print("score:", score)
```

It works, but most experienced programmers avoid `global`. A function that secretly changes the outside world is hard to test (you must reset the global before every check), hard to reuse (it only works with *that one* variable) and hard to debug (any function might have changed `score`). The cleaner design passes the value **in** and hands the new value **back**:

```python run
def add_points(score, points=1):
    return score + points

score = 0
score = add_points(score)
score = add_points(score, 5)
print("score:", score)
```

Now `add_points` works for any player''s score, and the line `score = add_points(score, 5)` shows exactly where `score` changes.

| | Changes a global with `global` | Takes parameters, returns a result |
|---|---|---|
| Where the change happens | hidden inside the function | visible at the call: `x = f(x)` |
| Works with other variables? | only that one global | any value you pass |
| Easy to test? | must set up and reset the global | just call it and check the return |

```python debug id=visit-counter title="The visit counter crashes"
visits = 0

def record_visit():
    """Add one to the site''s visit counter."""
    visits += 1

record_visit()
record_visit()
record_visit()
print("visits:", visits)
--- solution
visits = 0

def record_visit(count):
    """Return the visit counter plus one."""
    return count + 1

visits = record_visit(visits)
visits = record_visit(visits)
visits = record_visit(visits)
print("visits:", visits)
--- test
assert visits == 3, f"After three visits, `visits` should be 3, but it is {visits!r}."
assert "visits: 3" in _stdout, "Keep the final print so the count is shown."
if record_visit.__code__.co_argcount == 1:
    assert record_visit(41) == 42, "`record_visit(count)` should return the count plus one."
else:
    before = visits
    record_visit()
    assert visits == before + 1, "Each call to `record_visit()` should add one to `visits`."
--- hint
Run it and read the error: Python says `visits` is a *local* variable. Which line inside the function assigns to `visits`?
--- hint
Quick fix: declare `global visits` at the top of the function body. Cleaner fix: give the function a `count` parameter, `return count + 1`, and store the result with `visits = record_visit(visits)`.
```

```python exercise id=weekly-pay title="Payroll without globals"
# This version depends on globals, so it can only ever pay ONE person:
hours_worked = 45
hourly_rate = 20.0

def pay_for_this_week():
    return hours_worked * hourly_rate

# TODO: write `weekly_pay(hours, rate)` that uses ONLY its parameters.
# Hours up to 40 are paid at `rate`; every hour over 40 is paid at 1.5 x rate.
#   weekly_pay(45, 20.0) -> 40*20 + 5*30 = 950.0
#   weekly_pay(30, 15.0) -> 450.0
def weekly_pay(hours, rate):
    """Return the pay for a week, with time-and-a-half after 40 hours."""
    ...

print("Ana:", weekly_pay(45, 20.0))
print("Ben:", weekly_pay(30, 15.0))
--- solution
hours_worked = 45
hourly_rate = 20.0

def pay_for_this_week():
    return hours_worked * hourly_rate

def weekly_pay(hours, rate):
    """Return the pay for a week, with time-and-a-half after 40 hours."""
    if hours <= 40:
        return hours * rate
    overtime = hours - 40
    return 40 * rate + overtime * rate * 1.5

print("Ana:", weekly_pay(45, 20.0))
print("Ben:", weekly_pay(30, 15.0))
--- test
assert weekly_pay(45, 20.0) is not None, "`weekly_pay` gave back `None`. Replace the `...` with code that returns the pay."
assert weekly_pay(30, 15.0) == 450.0, f"30 hours at $15 should be 450.0 (no overtime), but got {weekly_pay(30, 15.0)!r}."
assert weekly_pay(45, 20.0) == 950.0, f"45 hours at $20 should be 950.0 (40 normal + 5 overtime at $30), but got {weekly_pay(45, 20.0)!r}."
assert weekly_pay(40, 10.0) == 400.0, f"Exactly 40 hours has no overtime: expected 400.0, got {weekly_pay(40, 10.0)!r}."
hours_worked, hourly_rate = 1, 1
assert weekly_pay(50, 12.0) == 660.0, f"50 hours at $12 should be 660.0, but got {weekly_pay(50, 12.0)!r}. Does your function still read the globals instead of its parameters?"
assert weekly_pay(0, 25.0) == 0, "0 hours should pay 0."
--- hint
Inside `weekly_pay`, use only `hours` and `rate`. Never `hours_worked` or `hourly_rate`.
--- hint
If `hours <= 40`, the answer is simply `hours * rate`. Otherwise split it into the first 40 hours and the overtime hours.
--- hint
Overtime pay is `(hours - 40) * rate * 1.5`, added to `40 * rate`.
```

## Shadowing built-ins

The **B** in LEGB holds Python''s built-in names: `print`, `len`, `sum`, `max`, `min`, `list`, `str`, `input`, `type`… They''re not reserved words, so nothing stops you from creating a global with the same name. And because Global is checked *before* Built-in, your variable then **hides** the built-in:

```python run error
prices = [4.50, 12.00, 3.25]

sum = 0                       # a natural name for a running total...
for p in prices:
    sum += p
print("total:", sum)

sum([1, 2, 3])                # ...but now `sum` is a float, not the function
```

`''float'' object is not callable` means "you put `(...)` after something that isn''t a function." Here, `sum` now refers to `19.75`. This is called **shadowing**, and it''s especially sneaky in a notebook, where the broken name sticks around for every later cell. To get the built-in back, delete your variable so the lookup falls through to Built-in again:

```python run
del sum                       # remove the global; `sum` is the built-in again
sum([1, 2, 3])
```

The real fix is prevention: pick names that say what the value *is*: `total`, `cart_total`, `highest_temp`, `word_list`.

| Tempting name | Shadows | Better name |
|---|---|---|
| `sum` | `sum()` | `total` |
| `max`, `min` | `max()`, `min()` | `highest`, `best_score`, `lowest_price` |
| `list`, `dict` | `list()`, `dict()` | `items`, `prices`, `lookup` |
| `str`, `input` | `str()`, `input()` | `text`, `answer` |
| `type`, `id` | `type()`, `id()` | `kind`, `user_id` |

> **Tip:** Most code editors color built-in names differently. If your variable name lights up in the "built-in" color, rename it.

```python debug id=shadowed-max title="max() stopped working"
temps = [18, 24, 21, 30, 27]

# Find the hottest day by hand.
max = temps[0]
for t in temps:
    if t > max:
        max = t
print("hottest this week:", max)

# Later in the program...
last_weekend = [12, 15, 9]
weekend_high = max(last_weekend)
print("weekend high:", weekend_high)
--- solution
temps = [18, 24, 21, 30, 27]

# Find the hottest day by hand.
hottest = temps[0]
for t in temps:
    if t > hottest:
        hottest = t
print("hottest this week:", hottest)

# Later in the program...
last_weekend = [12, 15, 9]
weekend_high = max(last_weekend)
print("weekend high:", weekend_high)
--- test
assert callable(max), "`max` still refers to a number, not the built-in function. Rename the variable that holds the hottest temperature."
assert weekend_high == 15, f"`weekend_high` should be 15, but is {weekend_high!r}."
assert "hottest this week: 30" in _stdout, "Keep printing the hottest temperature of the week (30)."
assert "weekend high: 15" in _stdout, "Print the weekend high too."
--- hint
Run it and read the last line of the error: `''int'' object is not callable`. Which name was being called with `(...)`, and what does that name hold now?
--- hint
The hand-written loop reuses the name `max` for a number. Give that variable its own name (like `hottest`) everywhere it appears in the loop and print.
```

## A peek at nested functions (the E in LEGB)

You can define a function *inside* another function. The inner one is local to the outer one, and it can **read** the outer function''s variables. That outer layer is the **Enclosing** scope.

```python run
def print_receipt(items, currency="$"):
    def line(name, price):                     # a helper only print_receipt needs
        return f"{name:<12}{currency}{price:>7.2f}"   # reads `currency` from the enclosing function

    for name, price in items:
        print(line(name, price))
    print(line("TOTAL", sum(price for name, price in items)))

print_receipt([("Coffee", 3.5), ("Bagel", 2.25), ("Juice", 4.0)])
```

Nested helpers keep a big function tidy without adding more names to the global scope. They''re also the doorway to powerful ideas like **closures** and **decorators**, which you''ll meet in *Python Advanced*. For now, just recognize the pattern when you see it.

## Recap

- Variables created inside a function, including its parameters, are **local**: each call gets fresh ones, and they vanish when the call ends. Only the return value gets out.
- Python looks names up in **LEGB** order: Local, Enclosing, Global, Built-in. The first match wins, so a local hides a global with the same name.
- Functions can **read** globals freely. **Assigning** to a name anywhere in a function makes it local everywhere in that function, which is what causes `UnboundLocalError`.
- `global name` lets a function rebind a global, but passing values in and returning results out (`x = f(x)`) is cleaner, more reusable and easier to test.
- Don''t name variables `sum`, `max`, `list`, `str`… You''ll shadow the built-in. If you do, `del` your variable to get it back.

**Up next:** the built-in toolkit: `sorted` with `key` and `lambda`, `enumerate`, `zip`, `any`/`all` and more power tools that replace a lot of hand-written loops.
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z'),
('les_python_basics_5_4', 'sec_python_basics_5', 'crs_python_basics', 'The built-in toolkit: sorted, enumerate, zip and lambda', 'interactive', 3, 1080, NULL, NULL, 'Python ships with about 70 **built-in functions**, always available, no `import` needed. You already know a handful: `print`, `len`, `sum`, `round`. The rest of the toolkit is where Python starts to feel like a superpower. Sorting a leaderboard by score, numbering a to-do list, pairing up two lists, checking whether *any* temperature broke a record: each of these is a five-line loop in most languages and a single, readable line in Python.

This lesson is a tour of the tools professionals reach for every day: `sorted` and `min`/`max` with a **`key`**, tiny throwaway functions called **`lambda`**, `enumerate`, `zip`, `any`/`all`, `map`/`filter`, `reversed` and `isinstance`. You''ll write functions that use them, and fix two classic bugs they were invented to prevent.

## The everyday six

A quick refresher on the built-ins you''ve been using since Section 2:

```python run
temps = [18.5, 24.0, -3.2, 30.1, 21.7]

print("readings:", len(temps))
print("total:   ", round(sum(temps), 1))
print("coldest: ", min(temps), " hottest:", max(temps))
print("biggest swing from zero:", abs(min(temps)))
print("average: ", round(sum(temps) / len(temps), 2))
```

`len`, `sum`, `min`, `max`, `abs` and `round` cover most simple statistics. The rest of this lesson is about telling these tools *how* to compare things.

## `sorted()` with a `key`

You met `sorted()` in lesson 14: it returns a **new** sorted list and leaves the original alone, with `reverse=True` for descending order. Its real power is the `key` parameter: a **function** that `sorted` calls on each item to decide what to compare.

```python run
fruits = ["banana", "kiwi", "fig", "cherry"]

print(sorted(fruits))                 # alphabetical
print(sorted(fruits, key=len))        # by length: compares len("banana"), len("kiwi"), ...
print(sorted(fruits, key=len, reverse=True))
```

Notice `key=len`, not `key=len()`. You''re handing `sorted` the function itself, the recipe card, so *it* can call it on every item. And `key` doesn''t change the items: you still get fruit names back, just in a new order.

Any function that takes one item works as a key, including your own:

```python run
products = [("headphones", 79.99), ("cable", 9.50), ("speaker", 45.00)]

def price_of(product):
    return product[1]

sorted(products, key=price_of)
```

```python predict id=predict-sort-key-len title="What is displayed?"
sorted(["melon", "fig", "apple", "kiwi"], key=len)
--- options
[''apple'', ''fig'', ''kiwi'', ''melon'']
* [''fig'', ''kiwi'', ''melon'', ''apple'']
[''fig'', ''kiwi'', ''apple'', ''melon'']
[3, 4, 5, 5]
--- explain
`key=len` sorts by length: 3, 4, then two words of length 5. When keys tie, `sorted` is **stable**: tied items keep their original order, so `"melon"` (which came first) stays before `"apple"`. And you get the words back, not the lengths.
```

## `lambda`: a function without a name

Writing a whole `def` just to say "use the second item" feels heavy. A **lambda** is a one-expression function you can write right where you need it:

```python run
double = lambda n: n * 2         # same as: def double(n): return n * 2
print(double(21))

products = [("headphones", 79.99), ("cable", 9.50), ("speaker", 45.00)]
sorted(products, key=lambda product: product[1])
```

Read `lambda product: product[1]` as "a function that takes `product` and returns `product[1]`." The rules:

- `lambda parameters: expression`. No `return` keyword; the expression''s value **is** the return value.
- Only a **single expression**: no loops, no `if` blocks, no assignments. (A conditional expression `a if cond else b` is fine.)
- Use lambdas for short, one-off functions passed to other functions, like `key=`. If you''d give it a name, or it needs more than one line, write a `def`.

Sorting a dictionary by its values is the classic lambda job. `.items()` gives `(key, value)` pairs, and the lambda picks the value:

```python run
votes = {"pizza": 14, "sushi": 22, "tacos": 9, "curry": 17}

ranked = sorted(votes.items(), key=lambda pair: pair[1], reverse=True)
print(ranked)
print("winner:", ranked[0][0])
```

> **In the wild:** `key=lambda ...` is everywhere in real code: sorting database rows by date, files by size, users by last login. pandas uses the same idea in `df.sort_values(key=...)`, and you''ll use it to sort transactions in the budget-tracker project.

Python refuses to sort things it can''t compare. Mixed numbers and strings are the usual culprit:

```python run error
sorted([42, "7", 19])
```

`''<'' not supported between instances of ''str'' and ''int''` means two items couldn''t be compared. Data from files and `input()` often arrives as strings, so convert first (or use `key=int`, as you''ll see in the last challenge).

```python exercise id=leaderboard title="Build a leaderboard"
# TODO: return a list of (name, score) tuples, highest score first.
#   leaderboard({"ana": 120, "ben": 340, "caro": 210})
#     -> [("ben", 340), ("caro", 210), ("ana", 120)]
def leaderboard(scores):
    """Return (name, score) pairs from the dict, sorted by score, highest first."""
    ...

print(leaderboard({"ana": 120, "ben": 340, "caro": 210}))
--- solution
def leaderboard(scores):
    """Return (name, score) pairs from the dict, sorted by score, highest first."""
    return sorted(scores.items(), key=lambda pair: pair[1], reverse=True)

print(leaderboard({"ana": 120, "ben": 340, "caro": 210}))
--- test
got = leaderboard({"ana": 120, "ben": 340, "caro": 210})
assert got is not None, "`leaderboard` gave back `None`. Replace the `...` with a `return` statement."
assert isinstance(got, list), f"`leaderboard` should return a list, but returned {type(got).__name__}. `sorted()` always gives a list."
assert all(isinstance(p, tuple) and len(p) == 2 for p in got), f"Each item should be a (name, score) tuple, but got {got!r}. Try sorting `scores.items()`."
assert got == [("ben", 340), ("caro", 210), ("ana", 120)], f"Expected [(''ben'', 340), (''caro'', 210), (''ana'', 120)], but got {got!r}."
fresh = leaderboard({"zed": 5, "yan": 50, "xia": 500, "wil": 0})
assert fresh == [("xia", 500), ("yan", 50), ("zed", 5), ("wil", 0)], f"Sort by the SCORE, not the name: got {fresh!r}."
assert leaderboard({}) == [], "An empty dict should give an empty leaderboard."
--- hint
`scores.items()` gives `(name, score)` pairs. Sort those.
--- hint
Tell `sorted` to compare the second item of each pair with `key=lambda pair: pair[1]`.
--- hint
Highest first means `reverse=True`.
```

## `min()` and `max()` with a `key`

`min` and `max` accept the same `key=` idea. Instead of the smallest *value*, you get the item whose *key* is smallest:

```python run
cities = ["Rome", "Copenhagen", "Oslo", "Amsterdam"]
print("longest name:", max(cities, key=len))

flights = [("Lisbon", 189), ("Madrid", 74), ("Paris", 120)]
cheapest = min(flights, key=lambda flight: flight[1])
print("cheapest:", cheapest)

stock = {"apples": 40, "pears": 3, "plums": 18}
print("running low:", min(stock, key=stock.get))
```

That last line is a neat trick: looping over a dict gives its **keys**, and `stock.get` is a function that turns a key into its value. So `min(stock, key=stock.get)` means "the key with the smallest value."

```python exercise id=cheapest-item title="Find the best deal"
# TODO: return the NAME of the cheapest product.
#   cheapest({"tea": 3.20, "coffee": 4.10, "juice": 2.90}) -> "juice"
def cheapest(prices):
    """Return the name of the product with the lowest price."""
    ...

print(cheapest({"tea": 3.20, "coffee": 4.10, "juice": 2.90}))
--- solution
def cheapest(prices):
    """Return the name of the product with the lowest price."""
    return min(prices, key=prices.get)

print(cheapest({"tea": 3.20, "coffee": 4.10, "juice": 2.90}))
--- test
got = cheapest({"tea": 3.20, "coffee": 4.10, "juice": 2.90})
assert got is not None, "`cheapest` gave back `None`. Replace the `...` with a `return` statement."
assert isinstance(got, str), f"`cheapest` should return the product''s name (a string), but returned {got!r}."
assert got == "juice", f"The cheapest product is juice (2.90), but you returned {got!r}."
fresh = {"laptop": 899.0, "mouse": 19.99, "monitor": 149.0, "cable": 25.0}
assert cheapest(fresh) == "mouse", f"For {fresh}, the cheapest is ''mouse'', but you returned {cheapest(fresh)!r}. Are you comparing prices, not names?"
assert cheapest({"zebra cake": 1, "apple pie": 9}) == "zebra cake", "Compare the PRICES: alphabetically first isn''t the same as cheapest."
--- hint
`min(prices)` alone compares the keys (the names) alphabetically. You need it to compare the prices instead.
--- hint
Give `min` a `key` that turns a name into its price: `prices.get` does exactly that. A lambda like `lambda name: prices[name]` works too.
```

## `enumerate()`: a counter that comes for free

You often need each item **and** its position: numbering a list, reporting which row was bad. Beginners reach for `range(len(...))`, but `enumerate` hands you `(index, item)` pairs directly, and `start=` sets the first number:

```python run
playlist = ["Bohemian Rhapsody", "Hey Jude", "Wonderwall"]

for position, song in enumerate(playlist, start=1):
    print(f"{position}. {song}")

list(enumerate(["a", "b", "c"]))
```

| Instead of… | Write… |
|---|---|
| `for i in range(len(songs)):` then `songs[i]` | `for i, song in enumerate(songs):` |
| a separate `count = 1` … `count += 1` | `enumerate(songs, start=1)` |

Fewer moving parts means fewer off-by-one mistakes, like this one:

```python debug id=numbered-tasks title="The to-do list loses its first task"
def numbered(tasks):
    """Return lines like ''1. Buy milk'', numbered from 1, one per task."""
    lines = []
    for i in range(1, len(tasks)):
        lines.append(f"{i}. {tasks[i]}")
    return lines

for line in numbered(["Buy milk", "Call grandma", "Pay rent"]):
    print(line)
--- solution
def numbered(tasks):
    """Return lines like ''1. Buy milk'', numbered from 1, one per task."""
    lines = []
    for i, task in enumerate(tasks, start=1):
        lines.append(f"{i}. {task}")
    return lines

for line in numbered(["Buy milk", "Call grandma", "Pay rent"]):
    print(line)
--- test
got = numbered(["Buy milk", "Call grandma", "Pay rent"])
assert len(got) == 3, f"Three tasks should give three lines, but got {len(got)}: {got!r}. Is a task being skipped?"
assert got == ["1. Buy milk", "2. Call grandma", "3. Pay rent"], f"Expected [''1. Buy milk'', ''2. Call grandma'', ''3. Pay rent''], but got {got!r}."
fresh = numbered(["Water plants"])
assert fresh == ["1. Water plants"], f"A one-task list should give [''1. Water plants''], but got {fresh!r}."
assert numbered([]) == [], "No tasks should give no lines."
assert numbered(list("abcd"))[-1] == "4. d", "The last of four tasks should be numbered 4."
--- hint
Run it: "Buy milk" is missing, and the numbers belong to the wrong tasks. The loop starts at index 1, skipping index 0, and the same `i` is used both as the display number and the index.
--- hint
`enumerate(tasks, start=1)` gives you a display number starting at 1 *and* each task, so you don''t need to index into the list at all.
```

## `zip()`: walk several lists together

`zip` pairs up items from two (or more) sequences, position by position, like a zipper joining two rows of teeth:

```python run
players = ["Maya", "Tom", "Inès"]
goals = [3, 1, 4]

for player, scored in zip(players, goals):
    print(f"{player} scored {scored}")

dict(zip(players, goals))
```

`dict(zip(keys, values))` is the standard way to build a dictionary from two parallel lists. One thing to know: `zip` **stops at the shortest** input, silently dropping leftovers.

```python predict id=predict-zip-short title="What is displayed?"
list(zip(["Mon", "Tue", "Wed"], [21, 19]))
--- options
[(''Mon'', 21), (''Tue'', 19), (''Wed'', None)]
* [(''Mon'', 21), (''Tue'', 19)]
[(''Mon'', ''Tue'', ''Wed''), (21, 19)]
ValueError
--- explain
`zip` makes pairs by position and stops as soon as **either** input runs out. `"Wed"` has no partner, so it''s dropped without an error. Make sure your lists line up!
```

```python exercise id=total-cost title="Add up a shopping list"
# TODO: `prices` and `quantities` are parallel lists: prices[0] goes with
# quantities[0], and so on. Return the total cost, rounded to 2 decimals.
#   total_cost([2.50, 1.20], [4, 3]) -> 13.6
def total_cost(prices, quantities):
    """Return the sum of price * quantity for each pair, rounded to 2 decimals."""
    ...

print(total_cost([2.50, 1.20], [4, 3]))
--- solution
def total_cost(prices, quantities):
    """Return the sum of price * quantity for each pair, rounded to 2 decimals."""
    return round(sum(price * qty for price, qty in zip(prices, quantities)), 2)

print(total_cost([2.50, 1.20], [4, 3]))
--- test
got = total_cost([2.50, 1.20], [4, 3])
assert got is not None, "`total_cost` gave back `None`. Replace the `...` with a `return` statement."
assert isinstance(got, (int, float)), f"`total_cost` should return a number, but returned {got!r}."
assert got == 13.6, f"`total_cost([2.50, 1.20], [4, 3])` should be 13.6, but is {got!r}."
assert total_cost([0.99, 5.0, 12.49], [3, 1, 2]) == 32.95, f"Expected 32.95 for three items, but got {total_cost([0.99, 5.0, 12.49], [3, 1, 2])!r}. Is every pair counted?"
assert total_cost([], []) == 0, "An empty shopping list should cost 0."
assert total_cost([1.1], [3]) == 3.3, f"`total_cost([1.1], [3])` should be 3.3 (rounded), but is {total_cost([1.1], [3])!r}."
--- hint
`zip(prices, quantities)` gives you `(price, qty)` pairs to loop over.
--- hint
Multiply each pair and add them up, either with an accumulator loop or `sum(price * qty for price, qty in zip(...))`.
--- hint
Wrap the final total in `round(..., 2)`.
```

## `any()` and `all()`: questions about a whole collection

`any(...)` is `True` if **at least one** item is truthy. `all(...)` is `True` only if **every** item is. Paired with a generator expression (the comprehension-without-brackets from lesson 18), they read almost like English:

```python run
temps = [18, 24, 31, 27]
scores = [72, 88, 95]

print("any heatwave day? ", any(t > 30 for t in temps))
print("all passed?       ", all(s >= 50 for s in scores))
print("any zero stock?   ", any(qty == 0 for qty in [5, 3, 8]))
```

Like `and`/`or`, they **short-circuit**: `any` stops at the first `True`, `all` stops at the first `False`. That''s the same idea as the "search with a flag" loops from lesson 12, in one line.

```python predict id=predict-any-all-empty title="What does this print?"
print(any([]), all([]))
--- options
False False
True True
* False True
True False
--- explain
`any([])` asks "is at least one item true?" With no items, no: `False`. `all([])` asks "is there any item that''s false?" There isn''t, so it''s `True`. Mathematicians call this "vacuously true": every item of an empty list passes, because there are none to fail.
```

```python exercise id=password-check title="A password strength check"
# TODO: return True only if the password meets ALL three rules:
#   - at least 8 characters long
#   - contains at least one digit        (str.isdigit helps)
#   - contains at least one uppercase letter (str.isupper helps)
def strong_password(password):
    """Return True if password has 8+ chars, a digit and an uppercase letter."""
    ...

print(strong_password("Sunshine42"), strong_password("password"))
--- solution
def strong_password(password):
    """Return True if password has 8+ chars, a digit and an uppercase letter."""
    long_enough = len(password) >= 8
    has_digit = any(ch.isdigit() for ch in password)
    has_upper = any(ch.isupper() for ch in password)
    return long_enough and has_digit and has_upper

print(strong_password("Sunshine42"), strong_password("password"))
--- test
assert strong_password("Sunshine42") is not None, "`strong_password` gave back `None`. Replace the `...` with a `return` statement."
cases = {
    "Sunshine42": True, "password": False, "Password": False, "password1": False,
    "PASSWORD1": True, "Ab1": False, "Abcdefg1": True, "abcdefg1": False, "12345678X": True, "": False,
}
for pw, expected in cases.items():
    got = strong_password(pw)
    assert got is expected or got == expected, f"`strong_password({pw!r})` should be {expected}, but is {got!r}."
--- hint
Check each rule separately. Length is `len(password) >= 8`.
--- hint
"Contains at least one digit" is `any(ch.isdigit() for ch in password)`. The uppercase rule has the same shape.
--- hint
Combine the three checks with `and` and return the result.
```

## `map()` and `filter()` vs comprehensions

Two older tools apply a function to every item. `map(function, items)` transforms each item; `filter(function, items)` keeps the items where the function returns something truthy. Both hand back a lazy object, so wrap them in `list()` to see the results:

```python run
names = ["ada", "grace", "linus"]
prices = [4.99, 120.0, 15.5, 89.0]

print(list(map(str.title, names)))
print(list(filter(lambda p: p < 50, prices)))

# The same results with comprehensions (lesson 18):
print([name.title() for name in names])
print([p for p in prices if p < 50])
```

| Task | `map` / `filter` | Comprehension |
|---|---|---|
| Apply an existing function | `list(map(str.title, names))` | `[n.title() for n in names]` |
| Keep matching items | `list(filter(lambda p: p < 50, prices))` | `[p for p in prices if p < 50]` |
| Transform *and* filter | `list(map(..., filter(..., ...)))` | `[p * 2 for p in prices if p < 50]` |

Most Python programmers prefer comprehensions: they read left to right and don''t need `lambda`. `map` is nice when you already have a named function, like `map(int, ["3", "14", "15"])`. You''ll see both in real code, so it''s worth recognizing them.

## `reversed()` and `isinstance()`

`reversed(seq)` walks a sequence backwards **without** changing it (unlike `list.reverse()`, which reverses in place). `isinstance(value, type)` asks "is this value of this type?", and accepts a tuple of types for "any of these":

```python run
countdown = [1, 2, 3, 4, 5]
print("launch in:", list(reversed(countdown)), "| original:", countdown)

mixed = [12, "n/a", 7.5, None, 3, "8"]
numbers = [x for x in mixed if isinstance(x, (int, float))]
print("numbers only:", numbers, "sum:", sum(numbers))
```

`isinstance` is how a function checks it got the kind of input it expects, which you''ll use when validating data in the next section.

## Debug: sorting numbers that are really text

```python debug id=top-scores-strings title="The top scores are in the wrong order"
def top_scores(raw_scores, n=3):
    """Return the n highest scores, as ints, highest first.
    The scores arrive as strings, e.g. from a file."""
    ordered = sorted(raw_scores, reverse=True)
    return [int(s) for s in ordered[:n]]

print(top_scores(["85", "9", "100", "42", "77"]))
--- solution
def top_scores(raw_scores, n=3):
    """Return the n highest scores, as ints, highest first.
    The scores arrive as strings, e.g. from a file."""
    ordered = sorted(raw_scores, key=int, reverse=True)
    return [int(s) for s in ordered[:n]]

print(top_scores(["85", "9", "100", "42", "77"]))
--- test
got = top_scores(["85", "9", "100", "42", "77"])
assert got == [100, 85, 77], f"The top three of 85, 9, 100, 42, 77 are [100, 85, 77], but got {got!r}."
fresh = top_scores(["3", "20", "1000", "500", "6"], n=2)
assert fresh == [1000, 500], f"`top_scores([''3'', ''20'', ''1000'', ''500'', ''6''], n=2)` should be [1000, 500], but got {fresh!r}."
assert top_scores(["7", "70", "700"], n=5) == [700, 70, 7], "Asking for more scores than exist should return them all, highest first."
--- hint
Run it: 9 comes out on top. Strings compare **character by character**, and `"9"` beats `"1"` (the start of `"100"`) just like "z" beats "a".
--- hint
Tell `sorted` to compare the scores as numbers. Which built-in turns `"100"` into `100`? It can be the `key`.
```

> **Pitfall:** Text that looks like numbers sorts alphabetically: `"10" < "9"` is `True`. Whenever numbers come from a file, a form or `input()`, convert them (or sort with `key=int` / `key=float`) before comparing.

## Recap

- `sorted(items, key=..., reverse=...)` and `min`/`max(items, key=...)` compare items by whatever the `key` function returns; you pass the function itself (`key=len`), not a call.
- `lambda params: expression` is a tiny unnamed function, perfect for one-off keys like `key=lambda pair: pair[1]`. Use `def` for anything bigger.
- `enumerate(items, start=1)` gives `(number, item)` pairs and replaces error-prone `range(len(...))` loops; `zip(a, b)` walks lists side by side (stopping at the shortest), and `dict(zip(keys, values))` builds a dict.
- `any(...)` and `all(...)` answer "at least one?" and "every one?" in a single line.
- `map`/`filter` exist, but comprehensions usually read better; `reversed()` walks backwards without changing the original; `isinstance(x, (int, float))` checks types.

**Up next:** errors and exceptions: reading tracebacks like a pro, catching problems with `try` and `except`, and raising your own errors when a function gets bad input.
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z'),
('les_python_basics_5_5', 'sec_python_basics_5', 'crs_python_basics', 'Checkpoint: functions', 'quiz', 4, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"A function is defined as `def add_tax(price): print(price * 1.2)`. After `total = add_tax(10)`, what does `print(total)` show?","options":["`12.0`","`None`","`10`","A `NameError`, because `total` was never defined"],"answerIndex":1,"explanation":"The function prints 12.0 (you see that on screen during the call) but never returns anything, so the call gives back `None` and `total` is `None`. Functions that compute a value should `return` it."},{"id":"q2","prompt":"In `def greet(name, city):` and the call `greet(\"Ana\", \"Porto\")`, which statement is correct?","options":["`\"Ana\"` and `\"Porto\"` are parameters; `name` and `city` are arguments","`name` and `city` are both arguments and parameters","Python matches `\"Porto\"` to `city` because it looks like a city name","`name` and `city` are parameters; `\"Ana\"` and `\"Porto\"` are arguments"],"answerIndex":3,"explanation":"Parameters are the names in the `def` line; arguments are the values passed in the call. Positional arguments are matched to parameters by order, never by meaning."},{"id":"q3","prompt":"`all_positive(nums)` loops `for n in nums:` and inside has `if n <= 0: return False` followed by `else: return True`. Why does `all_positive([3, -1, 5])` return `True`?","options":["The `return True` runs on the first item, ending the function before the rest are checked","`for` loops can''t contain `return` statements","`-1 <= 0` is `False` in Python","The function needs `global nums` to read the list"],"answerIndex":0,"explanation":"`return` ends the function immediately. Here it returns after looking at only the first item. The fix is to remove the `else` and put `return True` after the loop, once every item has been checked."},{"id":"q4","prompt":"Given `def log(item, history=[]): history.append(item); return history`, what does `print(log(\"b\"))` show if `log(\"a\")` was called just before?","options":["`[''b'']`","`[''a'']`","`[''a'', ''b'']`","`[]`"],"answerIndex":2,"explanation":"A default value is created once, when the `def` runs. Both calls share the same list, so it remembers `\"a\"`. Use `history=None` and create a new list inside the function instead."},{"id":"q5","prompt":"Which function header is NOT valid Python?","options":["`def order(item, size=\"M\"):`","`def order(size=\"M\", item):`","`def order(*items, gift_wrap=False):`","`def order(item, **options):`"],"answerIndex":1,"explanation":"Parameters with defaults must come after parameters without them; otherwise a call like `order(\"tea\")` would be ambiguous. Python raises a `SyntaxError` for that header."},{"id":"q6","prompt":"Inside `def team(captain, *players, **settings):`, the call `team(\"Kai\", \"Lu\", \"Mo\", kit=\"red\")` gives `players` and `settings` which values?","options":["`players` is `[\"Lu\", \"Mo\"]` and `settings` is `[\"kit\", \"red\"]`","`players` is `(\"Kai\", \"Lu\", \"Mo\")` and `settings` is `{\"kit\": \"red\"}`","`players` is `(\"Lu\", \"Mo\")` and `settings` is `(\"kit\", \"red\")`","`players` is `(\"Lu\", \"Mo\")` and `settings` is `{\"kit\": \"red\"}`"],"answerIndex":3,"explanation":"`captain` takes the first positional argument. `*players` collects the remaining positional arguments into a tuple, and `**settings` collects the keyword arguments into a dict."},{"id":"q7","prompt":"With `coins = 10` at the top level, calling a function whose body is `coins = coins - 1` raises `UnboundLocalError`. What is the best explanation?","options":["Because `coins` is assigned inside `spend`, it''s local for the whole function, so the `coins` on the right has no value yet","Functions can''t read global variables at all","`coins - 1` is negative, which Python doesn''t allow","`spend()` needs to be called with `coins` as an argument because it has a parameter"],"answerIndex":0,"explanation":"Python decides scope before running the function: any name assigned in the body is local everywhere in it. Reading a global is fine; assigning to it needs `global`, or better, a parameter and a return value: `coins = spend(coins)`."},{"id":"q8","prompt":"A program contains `sum = 0` near the top. Later, `sum([1, 2, 3])` fails with `TypeError: ''int'' object is not callable`. What''s the cleanest fix?","options":["Write `sum[1, 2, 3]` instead","Use `global sum` before calling it","Rename the variable to something like `total`, so it no longer shadows the built-in `sum`","Import `sum` from the `math` module"],"answerIndex":2,"explanation":"Python finds names in LEGB order, and the global `sum` is found before the built-in one. Renaming your variable (or `del sum` in a notebook) lets the lookup reach the built-in function again."},{"id":"q9","prompt":"What is the value of `sorted([\"10\", \"9\", \"100\"])`?","options":["`[''9'', ''10'', ''100'']`","`[''10'', ''100'', ''9'']`","`[''100'', ''10'', ''9'']`","A `TypeError`, because the strings contain numbers"],"answerIndex":1,"explanation":"Strings compare character by character, so `\"1...\"` comes before `\"9\"`, and `\"10\"` is a prefix of `\"100\"`. To sort them as numbers, use `sorted(values, key=int)`."},{"id":"q10","prompt":"Which expression gives the name of the player with the highest score, given `scores = {\"ana\": 12, \"ben\": 30, \"cy\": 21}`?","options":["`max(scores)`","`max(scores.values())`","`sorted(scores, reverse=True)[0]`","`max(scores, key=scores.get)`"],"answerIndex":3,"explanation":"Looping over a dict gives its keys, so `max(scores)` compares names alphabetically (giving `''cy''`). `key=scores.get` tells `max` to compare each name''s score, and it still returns the name: `''ben''`. `max(scores.values())` returns 30, not a name."}]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_python_basics_6_1', 'sec_python_basics_6', 'crs_python_basics', 'Errors and exceptions: try, except and raise', 'interactive', 0, 1080, NULL, NULL, 'Real programs live in a messy world. A user types `twelve` where you asked for a number. A shopping cart turns out to be empty right when you divide by its length. A file you expected isn''t there. So far, every one of these has done the same thing: your program crashed with a red error card and stopped dead.

That''s fine while you''re learning, but it''s not how finished software behaves. A cash register doesn''t shut down because someone scanned a damaged barcode; it beeps, says "try again", and carries on. In this lesson you''ll learn to read errors like a detective, catch the ones you expect with `try` and `except`, raise your own errors when someone misuses your functions, and avoid the two classic traps that hide bugs instead of handling them.

```python setup
# Simulated keyboard: the browser can''t pause for typing, so input() reads queued answers.
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

## Reading a traceback: follow the trail

When something goes wrong, Python creates an **exception**: an object that describes the problem. If nothing deals with it, the program stops and prints a **traceback**, the trail of function calls that led to the problem. Run this cell; it fails on purpose:

```python run error
def average(prices):
    return sum(prices) / len(prices)

def receipt_line(cart):
    avg = average(cart)
    return f"Average item price: ${avg:.2f}"

print(receipt_line([3.50, 2.25]))
print(receipt_line([]))      # an empty cart
```

The first receipt printed fine. The second blew up. Here''s how to read the traceback, like a stack of plates where the top plate was placed last:

```text
print(receipt_line([]))        ← 1. your code called receipt_line   (outermost)
  avg = average(cart)          ← 2. which called average
    sum(prices) / len(prices)  ← 3. where it actually broke         (innermost)
ZeroDivisionError: division by zero   ← what went wrong
```

1. **Read the last line first.** It names the exception type (`ZeroDivisionError`) and a message (`division by zero`). That''s *what* happened.
2. **Then the line just above it.** That''s *where* it happened: `len(prices)` was `0`.
3. **Then walk upward** to see *how you got there*. Often the real mistake is higher up: here, the bug isn''t really in `average`, it''s that someone passed it an empty cart.

> **Tip:** Python lists the calls from outermost (top) to innermost (bottom), which is why "read from the bottom up" works so well. The bottom line is the symptom; the frames above are the story.

## try and except: a safety net

Wrap risky code in `try`. If an exception happens inside it, Python jumps straight to the matching `except` block instead of crashing:

```python run
text = "twelve"

try:
    quantity = int(text)
    print("Got", quantity)
except ValueError:
    print(f"Sorry, {text!r} isn''t a whole number.")

print("The program keeps going.")
```

Think of it like a trapeze act. `try` is the act; `except` is the net underneath. If the performer falls, the net catches them and the show goes on. Notice that `print("Got", quantity)` never ran: the moment `int(text)` failed, Python left the `try` block and the rest of it was skipped.

```text
try:                 ← run these lines one by one…
    line A           ✓
    line B           ✗ raises ValueError ─┐
    line C           (skipped)            │
except ValueError:                        │
    handle it        ← jumps here ◀───────┘
after the try        ← then carries on normally
```

If nothing fails, the `except` block is skipped entirely. And if a *different* kind of exception happens, one your `except` doesn''t name, it isn''t caught: it crashes just like before.

```python predict id=predict-first-match title="Which message prints?"
scores = [90, 85]
try:
    print("top:", scores[2])
except KeyError:
    print("no such key")
except IndexError:
    print("no such position")
--- options
top: 85
top: no such position
no such key
* no such position
--- explain
`scores[2]` asks for a third item in a two-item list, which raises `IndexError` **before** `print` gets to show anything, so `"top:"` never appears. Python checks the `except` clauses top to bottom: `KeyError` doesn''t match (that''s for dictionaries), `IndexError` does.
```

## Catch specific exceptions (and look inside them)

You can stack several `except` clauses, group types in a tuple, and use `as e` to get the exception object itself. Its message is often exactly what you want to show:

```python run
def describe_order(order, item):
    try:
        qty = int(order[item])
        per_box = 12 // qty
        print(f"{item}: {qty} ordered, {per_box} fit per box")
    except KeyError:
        print(f"{item}: not on this order")
    except (ValueError, ZeroDivisionError) as e:
        print(f"{item}: bad quantity ({type(e).__name__}: {e})")

order = {"mugs": "4", "plates": "zero", "bowls": "0"}
for item in ["mugs", "plates", "bowls", "spoons"]:
    describe_order(order, item)
```

Why be specific? Because each exception type is a *different problem*, and only some of them are problems you know how to fix. A missing key means "not ordered". A bad quantity means "ask again". Something you didn''t predict, like a typo in your own code, should still crash loudly so you notice it.

### A field guide to common exceptions

You''ve met most of these already. Here they are side by side:

| Exception | Typical cause | Example |
|---|---|---|
| `ValueError` | Right type, wrong value | `int("ten")` |
| `TypeError` | Wrong type for the operation | `"3" + 4` |
| `KeyError` | Dictionary key doesn''t exist | `{"tea": 2}["coffee"]` |
| `IndexError` | List/string position out of range | `[1, 2, 3][10]` |
| `ZeroDivisionError` | Dividing by zero | `10 / 0` |
| `NameError` | Name not defined (often a typo) | `totl + 1` |
| `AttributeError` | Value doesn''t have that method | `"hi".shout()` |
| `FileNotFoundError` | No file at that path (next lesson!) | `open("missing.txt")` |

Run the cell below to see each one''s real message. It uses `except Exception as e`, which catches *any* ordinary error, purely so this demo can keep going:

```python run
experiments = [
    lambda: int("ten"),
    lambda: "3" + 4,
    lambda: {"tea": 2}["coffee"],
    lambda: [1, 2, 3][10],
    lambda: 10 / 0,
    lambda: totl + 1,
    lambda: "hi".shout(),
    lambda: open("missing.txt"),
]
for attempt in experiments:
    try:
        attempt()
    except Exception as e:
        print(f"{type(e).__name__:18} {e}")
```

```python exercise id=parse-price title="Prices that never crash"
def parse_price(text):
    """Turn text like "4.99", " 12 " or "$3.50" into a float.
    If the text isn''t a number, return None instead of crashing."""
    # TODO: remove any "$", try to convert with float(),
    # and catch the ValueError that float() raises on bad text.
    ...

# Try it out:
for raw in ["4.99", " 12 ", "$3.50", "free", ""]:
    print(repr(raw), "->", parse_price(raw))
--- solution
def parse_price(text):
    """Turn text like "4.99", " 12 " or "$3.50" into a float.
    If the text isn''t a number, return None instead of crashing."""
    try:
        return float(text.replace("$", ""))
    except ValueError:
        return None

for raw in ["4.99", " 12 ", "$3.50", "free", ""]:
    print(repr(raw), "->", parse_price(raw))
--- test
got = parse_price("4.99")
assert got is not None, "`parse_price(\"4.99\")` returned None. Replace the `...` with a try/except that returns the converted number."
assert isinstance(got, float), f"`parse_price(\"4.99\")` should return a float, but returned {got!r}."
assert got == 4.99, f"`parse_price(\"4.99\")` should be 4.99, not {got!r}."
assert parse_price(" 12 ") == 12.0, f"`parse_price(\" 12 \")` should be 12.0, not {parse_price('' 12 '')!r}."
assert parse_price("$3.50") == 3.5, f"`parse_price(\"$3.50\")` should be 3.5, not {parse_price(''$3.50'')!r}. Did you remove the $ first?"
assert parse_price("0.75") == 0.75 and parse_price("$120") == 120.0, "Check your function on a few more prices, like \"0.75\" and \"$120\"."
for bad in ["free", "", "12 dollars", "$"]:
    assert parse_price(bad) is None, f"`parse_price({bad!r})` should return None, not {parse_price(bad)!r}."
--- hint
`float("free")` raises `ValueError`. Put the conversion inside `try:` and `return None` in the `except ValueError:` block.
--- hint
Clean the text before converting: `text.replace("$", "")` removes the dollar sign. `float()` already ignores spaces around the number.
--- hint
The shape is: `try:` → `return float(...)`, then `except ValueError:` → `return None`.
```

## else and finally: the full shape

A `try` statement can have two more optional parts:

- `else:` runs only if the `try` block finished **without** an exception. It''s the "success" path.
- `finally:` runs **no matter what**: success, caught error, even an uncaught crash. It''s for cleanup you must never skip.

```python run
def checkout(cart_total, paid_text):
    try:
        paid = float(paid_text)
    except ValueError:
        print(f"  {paid_text!r} isn''t an amount")
    else:
        print(f"  change due: ${paid - cart_total:.2f}")
    finally:
        print("  (receipt printer reset)")

print("Customer 1:")
checkout(7.25, "10")
print("Customer 2:")
checkout(7.25, "ten bucks")
```

Why not just put the "change due" line inside `try`? Because then a bug in *that* line could be caught by the `except` and misreported. Keeping the `try` block to the one line that can fail is a habit you''ll see again in a debug challenge below.

```python predict id=predict-else-finally title="In what order?"
def check(qty_text):
    try:
        qty = int(qty_text)
    except ValueError:
        print("bad", end=" ")
    else:
        print("ok", end=" ")
    finally:
        print("done", end=" ")

check("3")
check("x")
--- options
ok bad done
* ok done bad done
ok done bad
done ok done bad
--- explain
For `"3"`, the conversion works, so `else` prints `ok`, then `finally` prints `done`. For `"x"`, `except` prints `bad`, then `finally` prints `done` again. `finally` runs on **every** call, after the other blocks.
```

## Validating input: ask until it''s right

Here''s where `try`/`except` really shines. Because this page can''t pause for your keyboard, `input()` here reads answers you queue up with `type_answers(...)`. In a real terminal, Python waits for you to type.

The pattern is a `while True` loop that only `break`s once the answer is valid:

```python run
type_answers("twelve", "-3", "2")

while True:
    text = input("How many tickets? ")
    try:
        tickets = int(text)
    except ValueError:
        print("  Please type a whole number, like 3.")
        continue
    if tickets < 1:
        print("  You need at least one ticket.")
        continue
    break

print("Booking", tickets, "tickets")
```

Two kinds of "wrong" are handled differently: `"twelve"` can''t even be converted (an exception), while `-3` converts fine but breaks a rule (an `if`). Real validation almost always needs both.

```python exercise id=ask-quantity title="Keep asking until the quantity is valid"
def ask_quantity():
    """Ask "Quantity? " until the user types a whole number of at least 1.
    Print a short message after each bad answer. Return the quantity as an int."""
    # TODO: loop with input("Quantity? "), convert with int() inside try/except,
    # reject numbers below 1, and return the first valid one.
    ...

type_answers("a dozen", "0", "6")
quantity = ask_quantity()
print("quantity:", quantity)
--- solution
def ask_quantity():
    """Ask "Quantity? " until the user types a whole number of at least 1.
    Print a short message after each bad answer. Return the quantity as an int."""
    while True:
        text = input("Quantity? ")
        try:
            qty = int(text)
        except ValueError:
            print("Please enter a whole number.")
            continue
        if qty < 1:
            print("The quantity must be at least 1.")
            continue
        return qty

type_answers("a dozen", "0", "6")
quantity = ask_quantity()
print("quantity:", quantity)
--- test
assert quantity is not None, "`ask_quantity()` returned None. Replace the `...` with a loop that returns the first valid quantity."
assert isinstance(quantity, int), f"`ask_quantity()` should return an int, but returned {quantity!r} ({type(quantity).__name__}). Did you convert with int()?"
assert quantity == 6, f"With answers ''a dozen'', ''0'', ''6'' the quantity should be 6, but it is {quantity!r}."
extra = [l for l in _stdout.splitlines() if l.strip() and not l.startswith("Quantity?") and not l.startswith("quantity:")]
assert len(extra) >= 2, "Print a short message after each bad answer (''a dozen'' and ''0'' should each get one)."
_queued.clear()
type_answers("2.5", "-1", "seven", "11")
again = ask_quantity()
assert again == 11, f"With answers ''2.5'', ''-1'', ''seven'', ''11'' your function returned {again!r} instead of 11."
assert not _queued, "Your function should stop asking as soon as it gets a valid answer."
type_answers("3", "99")
assert ask_quantity() == 3, "When the very first answer is valid, return it straight away."
--- hint
Start with `while True:` and read one answer per loop with `text = input("Quantity? ")`.
--- hint
Inside the loop: `try: qty = int(text)` / `except ValueError:` print a message and `continue`. Then check `if qty < 1:` the same way.
--- hint
When neither check failed, `return qty`. Returning from inside the loop ends both the loop and the function.
```

## raise: signal your own errors

So far Python has raised exceptions *at* you. You can raise them too. When someone calls your function with values that make no sense, the professional move is to **refuse loudly** with `raise`, rather than return a weird result that causes trouble later:

```python run error
def set_volume(level):
    if not 0 <= level <= 10:
        raise ValueError(f"volume must be between 0 and 10, got {level}")
    print("Volume set to", level)

set_volume(7)
set_volume(11)
```

The error message reads exactly like Python''s own, because it *is* a real exception: whoever calls `set_volume` can catch it with `except ValueError`, just like they would for `int("ten")`.

Pick the exception type that describes the problem: `ValueError` for a bad value of the right type (a negative age), `TypeError` for the wrong type entirely (a list where a number belongs).

```python run
def safe_set_volume(level):
    try:
        set_volume(level)
    except ValueError as e:
        print("Refused:", e)

safe_set_volume(4)
safe_set_volume(-2)
```

> **In the wild:** Libraries raise exceptions constantly. Django raises `Http404` when a page doesn''t exist, the `requests` library raises `ConnectionError` when the network is down, and pandas raises `KeyError` for a missing column. Your web framework catches them and turns them into friendly error pages.

```python exercise id=withdraw-raise title="An ATM that refuses bad withdrawals"
def withdraw(balance, amount):
    """Return the new balance after taking out `amount`.
    Raise ValueError if amount is 0 or negative,
    and raise ValueError if amount is more than balance."""
    # TODO: check both rules with if + raise ValueError("...message..."),
    # then return the new balance.
    ...

print(withdraw(100, 30))
try:
    withdraw(50, 80)
except ValueError as e:
    print("Refused:", e)
--- solution
def withdraw(balance, amount):
    """Return the new balance after taking out `amount`.
    Raise ValueError if amount is 0 or negative,
    and raise ValueError if amount is more than balance."""
    if amount <= 0:
        raise ValueError(f"amount must be positive, got {amount}")
    if amount > balance:
        raise ValueError(f"insufficient funds: balance is {balance}, asked for {amount}")
    return balance - amount

print(withdraw(100, 30))
try:
    withdraw(50, 80)
except ValueError as e:
    print("Refused:", e)
--- test
got = withdraw(100, 30)
assert got is not None, "`withdraw(100, 30)` returned None. Replace the `...` and return the new balance."
assert got == 70, f"`withdraw(100, 30)` should return 70, but returned {got!r}."
assert withdraw(250.5, 0.5) == 250.0, "`withdraw(250.5, 0.5)` should return 250.0."
assert withdraw(40, 40) == 0, "Taking out the whole balance is allowed: `withdraw(40, 40)` should return 0."
for bal, amt, why in [(50, 80, "more than the balance"), (100, 0, "zero"), (100, -20, "negative")]:
    try:
        result = withdraw(bal, amt)
    except ValueError as e:
        assert str(e).strip(), f"Give the ValueError for an amount that''s {why} a helpful message, like raise ValueError(\"...\")."
    except Exception as e:
        assert False, f"`withdraw({bal}, {amt})` raised {type(e).__name__}; it should raise ValueError."
    else:
        assert False, f"`withdraw({bal}, {amt})` returned {result!r}, but an amount that''s {why} should raise ValueError."
--- hint
Check the bad cases first, before doing any math. Each one is an `if` followed by `raise ValueError("...")`.
--- hint
The rules are `amount <= 0` and `amount > balance`. Withdrawing exactly the balance is fine.
--- hint
After both checks pass, `return balance - amount`.
```

## Why a bare `except:` is dangerous

You can write `except:` with no exception type. It catches **everything**: bad input, yes, but also typos in your own code, missing variables, even someone pressing Ctrl+C to stop the program. It''s like a smoke alarm that you''ve wrapped in a towel because it was beeping at toast: quiet, but now it won''t warn you about the real fire.

| Write this | Catches | Use it when |
|---|---|---|
| `except ValueError:` | exactly that problem | almost always |
| `except (ValueError, KeyError):` | a few named problems | several expected failures, same handling |
| `except Exception as e:` | any ordinary error | top level of a program, *and* you log `e` |
| `except:` | everything, silently | basically never |

```python debug id=bare-except-typo title="Every cart total comes out as 0.0"
def total_cost(price_texts):
    """Add up prices given as text, skipping any that aren''t numbers."""
    total = 0.0
    for text in price_texts:
        try:
            total += flaot(text)
        except:
            pass  # skip prices that aren''t numbers
    return total

cart = ["2.50", "oops", "1.25", "4.00"]
print("total:", total_cost(cart))
--- solution
def total_cost(price_texts):
    """Add up prices given as text, skipping any that aren''t numbers."""
    total = 0.0
    for text in price_texts:
        try:
            total += float(text)
        except ValueError:
            pass  # skip prices that aren''t numbers
    return total

cart = ["2.50", "oops", "1.25", "4.00"]
print("total:", total_cost(cart))
--- test
got = total_cost(["2.50", "oops", "1.25", "4.00"])
assert got != 0.0, "The total is still 0.0, so every price is being skipped. What is the `except` hiding from you?"
assert abs(got - 7.75) < 1e-9, f"The cart should total 7.75, but `total_cost` returned {got!r}."
assert abs(total_cost(["10", "n/a", "0.5"]) - 10.5) < 1e-9, "`total_cost([\"10\", \"n/a\", \"0.5\"])` should be 10.5 (skipping \"n/a\")."
assert total_cost([]) == 0.0, "An empty cart should total 0.0."
--- hint
Temporarily delete the `try:`/`except:` lines (keep the `total += ...` line) and run it. What error appears?
--- hint
There''s a typo that raises `NameError` on every price, and the bare `except:` silently swallows it. Fix the typo.
--- hint
Then make the safety net specific: `except ValueError:` skips bad prices but would let a typo crash loudly.
```

## Keep the try block small

The second trap is the mirror image: a `try` block that wraps too much. The `except` was written for *one* line''s failure, but it catches the same exception type from *any* line inside, including a line with a bug.

```python debug id=try-too-big title="Good rows are being skipped"
def tally(rows):
    """Add up points per player from "name,points" rows.
    Skip (and report) rows whose points aren''t a number."""
    points = {}
    for row in rows:
        try:
            name, score = row.split(",")
            points[name] = points[name] + int(score)
        except (ValueError, KeyError):
            print("skipping bad row:", row)
    return points

totals = tally(["ana,12", "ben,7", "ana,5", "cara,oops", "ben,3"])
print(totals)
--- solution
def tally(rows):
    """Add up points per player from "name,points" rows.
    Skip (and report) rows whose points aren''t a number."""
    points = {}
    for row in rows:
        try:
            name, score = row.split(",")
            score = int(score)
        except ValueError:
            print("skipping bad row:", row)
            continue
        points[name] = points.get(name, 0) + score
    return points

totals = tally(["ana,12", "ben,7", "ana,5", "cara,oops", "ben,3"])
print(totals)
--- test
assert totals != {}, "`totals` is empty, so every row was skipped. Use Debug to see which exception the good rows raise."
assert totals == {"ana": 17, "ben": 10}, f"`totals` should be {{''ana'': 17, ''ben'': 10}}, but it is {totals!r}."
assert "cara,oops" in _stdout, "The row ''cara,oops'' really is bad, so it should still be reported as skipped."
assert "ana,12" not in _stdout and "ben,7" not in _stdout, "Good rows like ''ana,12'' are still being reported as skipped."
fresh = tally(["zed,1", "zed,2", "broken", "amy,4"])
assert fresh == {"zed": 3, "amy": 4}, f"`tally([\"zed,1\", \"zed,2\", \"broken\", \"amy,4\"])` should be {{''zed'': 3, ''amy'': 4}}, not {fresh!r}."
--- hint
Debug it and watch the first row, `"ana,12"`. It''s a perfectly good row, so why does it land in the `except`?
--- hint
`points[name]` raises `KeyError` the first time a player appears, and the `except` mistakes that for a bad row. A KeyError was never a "bad row" problem.
--- hint
Only the parsing (`split` and `int`) belongs inside `try` with `except ValueError`. Do the dictionary update afterwards, using `points.get(name, 0)`.
```

## Ask permission or ask forgiveness?

There are two styles for dealing with things that might fail, and Python programmers have names for both:

- **LBYL**, "Look Before You Leap": check first with an `if`, then act.
- **EAFP**, "Easier to Ask Forgiveness than Permission": just try it, and handle the exception if it fails.

```python run
stock = {"apples": 12, "pears": 0}

# LBYL: look before you leap
if "kiwis" in stock:
    print("kiwis:", stock["kiwis"])
else:
    print("kiwis: not stocked (checked first)")

# EAFP: ask forgiveness
try:
    print("kiwis:", stock["kiwis"])
except KeyError:
    print("kiwis: not stocked (handled the KeyError)")
```

Both work here. The difference shows up when the "look" is hard to get exactly right:

```python predict id=predict-isdigit title="Is it a number?"
text = "-5"
print(text.isdigit(), int(text))
--- options
True -5
* False -5
False
True 5
--- explain
`.isdigit()` only says yes if **every character** is a digit, and `-` isn''t one. Yet `int("-5")` happily returns `-5`. An LBYL check with `.isdigit()` would wrongly reject negative numbers (and `" 7"` with a space). Trying `int()` and catching `ValueError` asks the expert, Python''s own converter, instead of guessing.
```

| | LBYL (`if` first) | EAFP (`try` first) |
|---|---|---|
| Reads like | "Is this allowed? Then do it." | "Do it; if it fails, handle that." |
| Good for | simple, cheap checks (`if key in d`) | conversions, files, anything hard to pre-check |
| Risk | your check can disagree with reality | a too-broad `try` can hide bugs |

> **Coming from another language:** `try`/`except`/`raise` are Python''s `try`/`catch`/`throw`. Python leans further toward EAFP than most languages; exceptions are an everyday tool here, not a last resort.

## Recap

- A **traceback** reads bottom-up: the last line says *what* went wrong, the frames above show *where* and *how you got there*.
- `try`/`except SomeError:` catches an expected failure so the program can recover; name **specific** exception types, and use `as e` to read the message.
- `else` runs when the `try` succeeded; `finally` runs every time, for cleanup.
- Validate input with a `while True` loop: catch conversion errors with `except ValueError`, check rules with `if`, and `break` or `return` when it''s right.
- `raise ValueError("clear message")` makes your own functions refuse bad input loudly.
- Never use a bare `except:`, and keep `try` blocks small, so real bugs still crash where you can see them.

**Up next:** reading and writing files, plus the CSV and JSON formats that real-world data lives in. (Expect to meet `FileNotFoundError` again.)
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z'),
('les_python_basics_6_2', 'sec_python_basics_6', 'crs_python_basics', 'Reading and writing files, CSV and JSON', 'interactive', 1, 1200, NULL, NULL, 'Every program you''ve written so far has had amnesia. The moment it finishes, every list, dictionary and high score vanishes. **Files** are how programs remember: a to-do app saves your tasks, a game saves your progress, a script at work reads last month''s sales and writes a report for your boss.

In this lesson you''ll read and write plain text files, then the two formats most real-world data arrives in: **CSV** (spreadsheet-style rows) and **JSON** (nested dictionaries and lists, the language of web APIs). By the end you''ll be able to load a spreadsheet export, total it up, and save the results somewhere safe.

> **About this page''s files:** this page has its own small, sandboxed filesystem that lives in your browser''s memory. Your code can create, read and overwrite files freely here without touching anything on your computer. Files last until you reload the page.

## Writing your first file

A file is just text (or bytes) stored under a name. To use one, you `open()` it, which gives you a *file object* to read from or write to. The second argument is the **mode**: `"w"` means "write":

```python run
with open("shopping.txt", "w", encoding="utf-8") as f:
    f.write("milk\n")
    f.write("eggs\n")
    f.write("coffee\n")

print("Saved!")
```

Three things are happening:

- `open("shopping.txt", "w", ...)` creates the file (or empties it if it already exists) and hands you a file object, which we''ve named `f`.
- `f.write(...)` adds text. It does **not** add a line break for you; that''s what the `\n` is for.
- `with ... as f:` closes the file automatically when the indented block ends, even if an error happens inside it.

Now read it back. With no mode, `open()` defaults to `"r"` for read:

```python run
with open("shopping.txt", encoding="utf-8") as f:
    contents = f.read()

print(contents)
contents
```

The displayed value shows the truth: the file is one string, with `\n` characters marking where each line ends.

> **Under the hood:** Writing to disk is slow, so Python collects your writes in a *buffer* and saves them in batches. Closing the file flushes whatever is left. Forget to close it and your last few lines might never reach the disk. A `with` block makes closing automatic, like a library that takes your book back the moment you walk out the door.

## The three modes you''ll use

| Mode | Meaning | If the file exists… | If it doesn''t… |
|---|---|---|---|
| `"r"` (default) | read | reads it | `FileNotFoundError` |
| `"w"` | write | **erases it first** | creates it |
| `"a"` | append | adds to the end | creates it |

That middle row deserves a warning sign. `"w"` doesn''t mean "edit"; it means "start over with a blank page". To add to an existing file, use `"a"`:

```python run
with open("diary.txt", "w", encoding="utf-8") as f:   # start fresh
    f.write("Mon: rained all day\n")

with open("diary.txt", "a", encoding="utf-8") as f:   # add to the end
    f.write("Tue: sunny, went cycling\n")
    f.write("Wed: rained again\n")

with open("diary.txt", encoding="utf-8") as f:
    print(f.read())
```

```python predict id=predict-no-newline title="Where did the line break go?"
with open("todo.txt", "w", encoding="utf-8") as f:
    f.write("eggs")
    f.write("milk")

with open("todo.txt", encoding="utf-8") as f:
    print(f.read())
--- options
eggs milk
* eggsmilk
milk
[''eggs'', ''milk'']
--- explain
Unlike `print`, `f.write()` writes **exactly** the text you give it: no space, no newline. The two words end up glued together on one line. Write `"eggs\n"` to end the line. (And `"w"` only erases the file once, when it''s opened, so both writes survive.)
```

> **Tip:** Always pass `encoding="utf-8"`. Without it, Python uses your operating system''s default, which on some Windows machines can''t handle accents or emoji, so `"café ☕"` saved on one computer comes back garbled on another. UTF-8 is the universal choice.

## Reading line by line

Most text files are a list of records, one per line. You have several ways to get at the lines:

| Code | Gives you |
|---|---|
| `f.read()` | the whole file as one string |
| `f.readline()` | the next single line (including its `\n`) |
| `f.readlines()` | a list of all lines (each including its `\n`) |
| `for line in f:` | one line at a time: the usual choice, and memory-friendly for huge files |

```python predict id=predict-readlines title="What''s in the list?"
with open("pets.txt", "w", encoding="utf-8") as f:
    f.write("cat\ndog\n")

with open("pets.txt", encoding="utf-8") as f:
    lines = f.readlines()
print(lines)
--- options
[''cat'', ''dog'']
* [''cat\n'', ''dog\n'']
[''cat\ndog\n'']
[''cat\n'', ''dog\n'', '''']
--- explain
Each line keeps its newline character at the end. That''s usually not what you want, which is why reading code almost always calls `.strip()` (or `.rstrip("\n")`) on each line.
```

Looping over the file object is the everyday pattern. Strip each line, skip the blanks, and you''ve got clean data:

```python run
with open("playlist.txt", "w", encoding="utf-8") as f:
    f.write("Bohemian Rhapsody\n\nDancing Queen\nHey Jude\n")

songs = []
with open("playlist.txt", encoding="utf-8") as f:
    for line in f:
        title = line.strip()
        if title:                 # skip blank lines
            songs.append(title)

print(len(songs), "songs:", songs)
```

```python exercise id=read-numbers title="Load temperatures from a file"
# This creates the file for you (one reading per line, with a blank line in the middle):
with open("temps.txt", "w", encoding="utf-8") as f:
    f.write("21.5\n19.0\n\n23.25\n")

def read_numbers(path):
    """Return a list of floats, one per non-blank line of the file at `path`."""
    # TODO: open the file, loop over its lines, skip blank ones,
    # and convert each remaining line with float().
    ...

temps = read_numbers("temps.txt")
print("temps:", temps)
--- solution
with open("temps.txt", "w", encoding="utf-8") as f:
    f.write("21.5\n19.0\n\n23.25\n")

def read_numbers(path):
    """Return a list of floats, one per non-blank line of the file at `path`."""
    numbers = []
    with open(path, encoding="utf-8") as f:
        for line in f:
            if line.strip():
                numbers.append(float(line))
    return numbers

temps = read_numbers("temps.txt")
print("temps:", temps)
--- test
assert temps is not None, "`read_numbers` returned None. Replace the `...` with code that builds and returns a list."
assert isinstance(temps, list), f"`read_numbers` should return a list, but returned {type(temps).__name__}."
assert temps != ["21.5", "19.0", "23.25"], "Those are strings. Convert each line with float()."
assert temps == [21.5, 19.0, 23.25], f"`read_numbers(\"temps.txt\")` should be [21.5, 19.0, 23.25], but is {temps!r}. Did you skip the blank line?"
with open("_check_numbers.txt", "w", encoding="utf-8") as f:
    f.write("  4\n\n-2.5\n10\n\n")
fresh = read_numbers("_check_numbers.txt")
assert fresh == [4.0, -2.5, 10.0], f"On a different file your function returned {fresh!r} instead of [4.0, -2.5, 10.0]. Make sure it reads the `path` it''s given."
--- hint
Use `with open(path, encoding="utf-8") as f:` and then `for line in f:`. Build a list as you go.
--- hint
A blank line is `"\n"`, and `"\n".strip()` is `""`, which is falsy. So `if line.strip():` keeps only real lines.
--- hint
Inside the `if`, `numbers.append(float(line))`. `float()` ignores the newline and spaces around the number. Return the list at the end.
```

## When the file isn''t there

Reading a file that doesn''t exist raises `FileNotFoundError`, which you met in the last lesson:

```python run error
with open("recipes.txt", encoding="utf-8") as f:
    print(f.read())
```

A missing file is often perfectly normal: the first time an app runs, there''s no save file yet. That''s a job for `try`/`except`:

```python run
try:
    with open("recipes.txt", encoding="utf-8") as f:
        recipes = f.read()
except FileNotFoundError:
    recipes = ""
    print("No recipe book yet, starting with an empty one.")

print("recipes loaded:", repr(recipes))
```

## pathlib: paths as objects

Python''s `pathlib` module (you''ll learn about modules and `import` properly next lesson) wraps a file path in a `Path` object with handy methods. For small files, `read_text` and `write_text` open, read or write, and close in one call:

```python run
from pathlib import Path

notes = Path("notes.txt")
notes.unlink(missing_ok=True)          # delete it if it''s left over, for a clean demo

print("exists before?", notes.exists())
notes.write_text("Buy stamps\nCall grandma\n", encoding="utf-8")
print("exists after? ", notes.exists())
print("lines:", notes.read_text(encoding="utf-8").splitlines())
print("name:", notes.name, "| stem:", notes.stem, "| suffix:", notes.suffix)
```

`.splitlines()` is a neat trick: it splits text into lines *and* drops the `\n` characters in one go.

> **In the wild:** Professional code increasingly uses `pathlib` everywhere. Paths combine with `/`, so `Path("reports") / "2026" / "march.csv"` builds a correct path on Windows, macOS and Linux alike, no fiddling with slashes.

## Debug challenge: the forgetful log

```python debug id=workout-log title="The log only remembers the last workout"
def log_workout(path, entry):
    """Add `entry` as a new line at the end of the log file."""
    with open(path, "w", encoding="utf-8") as f:
        f.write(entry)

# Start a fresh log with a title line
with open("workouts.txt", "w", encoding="utf-8") as f:
    f.write("WORKOUT LOG\n")

log_workout("workouts.txt", "run 5km")
log_workout("workouts.txt", "swim 1km")
log_workout("workouts.txt", "yoga 30min")

with open("workouts.txt", encoding="utf-8") as f:
    print(f.read())
--- solution
def log_workout(path, entry):
    """Add `entry` as a new line at the end of the log file."""
    with open(path, "a", encoding="utf-8") as f:
        f.write(entry + "\n")

with open("workouts.txt", "w", encoding="utf-8") as f:
    f.write("WORKOUT LOG\n")

log_workout("workouts.txt", "run 5km")
log_workout("workouts.txt", "swim 1km")
log_workout("workouts.txt", "yoga 30min")

with open("workouts.txt", encoding="utf-8") as f:
    print(f.read())
--- test
with open("workouts.txt", encoding="utf-8") as f:
    lines = f.read().splitlines()
assert "WORKOUT LOG" in lines, "The title line ''WORKOUT LOG'' was wiped out. Which open() mode erases a file every time it''s opened?"
assert len(lines) == 4, f"The log should have 4 lines (title + 3 workouts) but has {len(lines)}: {lines!r}. Does each entry end with a newline?"
assert lines == ["WORKOUT LOG", "run 5km", "swim 1km", "yoga 30min"], f"The log lines should be the title then the three workouts in order, but are {lines!r}."
with open("_check_log.txt", "w", encoding="utf-8") as f:
    f.write("LOG\n")
log_workout("_check_log.txt", "plank 2min")
log_workout("_check_log.txt", "squats x20")
with open("_check_log.txt", encoding="utf-8") as f:
    assert f.read() == "LOG\nplank 2min\nsquats x20\n", "`log_workout` should add each entry on its own line at the end of whatever file it''s given."
--- hint
Run it: only `yoga 30min` survives, and even the title is gone. Look at the mode in `log_workout`''s `open()` call.
--- hint
`"w"` erases the file each time it''s opened. You want the mode that adds to the end.
--- hint
Once that''s fixed, the entries will be glued together on one line. `write()` doesn''t add line breaks for you.
```

## CSV: spreadsheet data as text

A **CSV** (comma-separated values) file is a table stored as plain text: one row per line, columns separated by commas, usually with a header row. Every spreadsheet app can export one. It looks like you could just `.split(",")`… until a value contains a comma:

```python run
line = ''Alex,"Reds, Under-12",7''
print(line.split(","))   # 4 pieces: the team name got cut in half
```

The `csv` module knows the rules: commas inside quotes, quotes inside quotes, and more. `csv.reader` turns each line into a list of strings:

```python run
import csv

with open("roster.csv", "w", encoding="utf-8", newline="") as f:
    f.write(''name,team,goals\nAlex,"Reds, Under-12",7\nSam,Blues,3\nPriya,Blues,11\n'')

with open("roster.csv", encoding="utf-8", newline="") as f:
    rows = list(csv.reader(f))

header, data = rows[0], rows[1:]
print("header:", header)
for row in data:
    print(row)
```

Usually you''d rather refer to columns by **name** than by position. `csv.DictReader` reads the header for you and turns every row into a dictionary:

```python run
with open("roster.csv", encoding="utf-8", newline="") as f:
    players = list(csv.DictReader(f))

print(players[0])
total_goals = sum(int(p["goals"]) for p in players)
print("total goals:", total_goals)
```

Notice the `int(...)`. **Everything that comes out of a CSV file is a string**, even `"7"`. The file is just text; it has no idea which columns are numbers. Converting is your job.

> **Pitfall:** Pass `newline=""` whenever you open a file for the `csv` module. The module handles line endings itself, and without it, CSV files written on Windows get a blank line between every row.

```python exercise id=category-totals title="Total the spending by category"
import csv

# A bank export (created for you):
with open("expenses.csv", "w", encoding="utf-8", newline="") as f:
    f.write("date,category,amount\n"
            "2026-03-01,food,12.50\n"
            "2026-03-01,travel,40\n"
            "2026-03-02,food,7.25\n"
            "2026-03-03,fun,15\n")

def totals_by_category(path):
    """Read a CSV with columns date, category, amount.
    Return a dict mapping each category to its total amount (a float)."""
    # TODO: use csv.DictReader, convert each amount with float(),
    # and add it to that category''s running total.
    ...

totals = totals_by_category("expenses.csv")
print(totals)
--- solution
import csv

with open("expenses.csv", "w", encoding="utf-8", newline="") as f:
    f.write("date,category,amount\n"
            "2026-03-01,food,12.50\n"
            "2026-03-01,travel,40\n"
            "2026-03-02,food,7.25\n"
            "2026-03-03,fun,15\n")

def totals_by_category(path):
    """Read a CSV with columns date, category, amount.
    Return a dict mapping each category to its total amount (a float)."""
    totals = {}
    with open(path, encoding="utf-8", newline="") as f:
        for row in csv.DictReader(f):
            cat = row["category"]
            totals[cat] = totals.get(cat, 0.0) + float(row["amount"])
    return totals

totals = totals_by_category("expenses.csv")
print(totals)
--- test
assert totals is not None, "`totals_by_category` returned None. Replace the `...` with code that builds and returns a dict."
assert isinstance(totals, dict), f"`totals_by_category` should return a dict, but returned {type(totals).__name__}."
assert set(totals) == {"food", "travel", "fun"}, f"The categories should be food, travel and fun, but your keys are {sorted(totals)!r}. Did the header row sneak in?"
assert all(isinstance(v, (int, float)) for v in totals.values()), f"Totals should be numbers, but got {totals!r}. Remember: CSV values are strings until you convert them."
assert abs(totals["food"] - 19.75) < 1e-9, f"food should total 19.75 (12.50 + 7.25), but is {totals[''food'']!r}."
assert totals["travel"] == 40 and totals["fun"] == 15, f"travel should be 40 and fun 15, but got {totals!r}."
with open("_check_expenses.csv", "w", encoding="utf-8", newline="") as f:
    f.write("date,category,amount\n2026-04-01,rent,900\n2026-04-02,gifts,20.5\n2026-04-09,gifts,4.5\n")
fresh = totals_by_category("_check_expenses.csv")
assert fresh == {"rent": 900.0, "gifts": 25.0}, f"On a different file your function returned {fresh!r} instead of {{''rent'': 900.0, ''gifts'': 25.0}}."
--- hint
`for row in csv.DictReader(f):` gives you dicts like `{"date": "2026-03-01", "category": "food", "amount": "12.50"}`.
--- hint
`row["amount"]` is a string. Convert it with `float()` before adding.
--- hint
The counting pattern from the dictionaries lesson works here: `totals[cat] = totals.get(cat, 0.0) + amount`.
```

### Writing CSV

`csv.writer` does the reverse: hand it lists, and it writes correctly quoted lines. `writerow` writes one row; `writerows` writes a whole list of them:

```python run
results = [("Priya", "Blues", 11), ("Alex", "Reds, Under-12", 7)]

with open("top_scorers.csv", "w", encoding="utf-8", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["name", "team", "goals"])
    writer.writerows(results)

print(Path("top_scorers.csv").read_text(encoding="utf-8"))
```

The writer added quotes around `"Reds, Under-12"` automatically, and converted the numbers to text for you.

```python exercise id=save-scores title="Save a leaderboard as CSV"
import csv

def save_scores(path, scores):
    """Write `scores` (a dict of player -> points) to a CSV file at `path`:
    a header row  player,points  then one row per player, highest points first."""
    # TODO: sort the players by points (highest first),
    # then write the header and rows with csv.writer.
    ...

save_scores("leaderboard.csv", {"mia": 40, "leo": 95, "ava": 72})
print("saved leaderboard.csv")
--- solution
import csv

def save_scores(path, scores):
    """Write `scores` (a dict of player -> points) to a CSV file at `path`:
    a header row  player,points  then one row per player, highest points first."""
    ranked = sorted(scores.items(), key=lambda pair: pair[1], reverse=True)
    with open(path, "w", encoding="utf-8", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["player", "points"])
        writer.writerows(ranked)

save_scores("leaderboard.csv", {"mia": 40, "leo": 95, "ava": 72})
print("saved leaderboard.csv")
--- test
from pathlib import Path
check = Path("_check_scores.csv")
check.unlink(missing_ok=True)
save_scores("_check_scores.csv", {"zoe": 3, "kai": 10, "ivy": 7})
assert check.exists(), "`save_scores` didn''t create a file. Replace the `...` and open `path` in \"w\" mode."
with open(check, encoding="utf-8", newline="") as f:
    rows = [r for r in csv.reader(f) if r]
assert rows, "The file is empty. Write the header row and one row per player."
assert rows[0] == ["player", "points"], f"The first row should be the header [''player'', ''points''], but is {rows[0]!r}."
assert len(rows) == 4, f"Expected a header plus 3 player rows, but found {len(rows)} rows."
assert sorted(rows[1:]) == sorted([["kai", "10"], ["ivy", "7"], ["zoe", "3"]]), f"The player rows should hold each name and their points, but are {rows[1:]!r}."
assert rows[1:] == [["kai", "10"], ["ivy", "7"], ["zoe", "3"]], f"Put the highest score first. Your rows are in this order: {[r[0] for r in rows[1:]]}."
--- hint
`sorted(scores.items(), key=lambda pair: pair[1], reverse=True)` gives `(player, points)` tuples, best first.
--- hint
Open with `open(path, "w", encoding="utf-8", newline="")`, make `writer = csv.writer(f)`, then `writer.writerow([...header...])`.
--- hint
Each `(player, points)` tuple is already a row, so `writer.writerows(ranked)` writes them all.
```

## Debug challenge: the priciest item

```python debug id=priciest-item title="The most expensive item is a latte?"
import csv

with open("menu.csv", "w", encoding="utf-8", newline="") as f:
    f.write("item,price\nlatte,4.50\nbagel,3.25\nlunch special,12.00\ncookie,2.75\n")

def most_expensive(path):
    """Return the name of the most expensive item in a menu CSV."""
    with open(path, encoding="utf-8", newline="") as f:
        menu = list(csv.DictReader(f))
    priciest = max(menu, key=lambda row: row["price"])
    return priciest["item"]

print("Most expensive:", most_expensive("menu.csv"))
--- solution
import csv

with open("menu.csv", "w", encoding="utf-8", newline="") as f:
    f.write("item,price\nlatte,4.50\nbagel,3.25\nlunch special,12.00\ncookie,2.75\n")

def most_expensive(path):
    """Return the name of the most expensive item in a menu CSV."""
    with open(path, encoding="utf-8", newline="") as f:
        menu = list(csv.DictReader(f))
    priciest = max(menu, key=lambda row: float(row["price"]))
    return priciest["item"]

print("Most expensive:", most_expensive("menu.csv"))
--- test
got = most_expensive("menu.csv")
assert got != "latte", "Still ''latte''. Compare \"4.50\" and \"12.00\" as text: which comes first alphabetically?"
assert got == "lunch special", f"The most expensive item is the lunch special (12.00), but your function says {got!r}."
with open("_check_menu.csv", "w", encoding="utf-8", newline="") as f:
    f.write("item,price\ntea,2.5\nsteak,25\ncake,9.75\n")
fresh = most_expensive("_check_menu.csv")
assert fresh == "steak", f"For a menu with tea 2.5, steak 25 and cake 9.75, your function returned {fresh!r} instead of ''steak''."
--- hint
Run it. A 4.50 latte beats a 12.00 lunch? Remember what type every CSV value has.
--- hint
`"4.50" > "12.00"` is `True`, because strings compare character by character and `"4"` comes after `"1"`.
--- hint
Make the `key` function return a number instead of the raw text.
```

## JSON: saving nested data

CSV is great for flat tables, but what about a dictionary that contains a list that contains more dictionaries? **JSON** (JavaScript Object Notation) stores exactly that kind of nested data, and it looks almost like Python:

| Python | JSON |
|---|---|
| `dict` | object `{...}` (keys always strings) |
| `list` (and `tuple`) | array `[...]` |
| `str` | string, always in **double** quotes |
| `int`, `float` | number |
| `True` / `False` | `true` / `false` |
| `None` | `null` |

`json.dumps` ("dump string") turns Python data into JSON text; `json.loads` ("load string") turns JSON text back into Python data:

```python run
import json

recipe = {"name": "Pancakes", "serves": 4, "vegan": False,
          "ingredients": ["flour", "milk", "eggs"], "rating": None}

text = json.dumps(recipe)
print(text)

back = json.loads(text)
print(back["ingredients"][0], "| same data?", back == recipe)
```

```python predict id=predict-json-dumps title="What does the JSON look like?"
import json
print(json.dumps({"done": True, "due": None, "tags": ("home", "urgent")}))
--- options
{''done'': True, ''due'': None, ''tags'': (''home'', ''urgent'')}
{"done": True, "due": None, "tags": ["home", "urgent"]}
* {"done": true, "due": null, "tags": ["home", "urgent"]}
{"done": true, "due": null, "tags": ("home", "urgent")}
--- explain
JSON has its own spellings: double quotes, lowercase `true`/`false`, `null` for `None`, and square-bracket arrays. JSON has no tuples, so a tuple becomes an array, and it will come back as a **list** when you load it.
```

To work with files, drop the `s`: `json.dump(data, f)` writes to an open file and `json.load(f)` reads from one. Add `indent=2` and the file becomes pleasant for humans to read too:

```python run
trip = {"destination": "Kyoto", "nights": 5,
        "stops": [{"city": "Osaka", "nights": 2}, {"city": "Nara", "nights": 1}]}

with open("trip.json", "w", encoding="utf-8") as f:
    json.dump(trip, f, indent=2)

print(Path("trip.json").read_text(encoding="utf-8"))

with open("trip.json", encoding="utf-8") as f:
    loaded = json.load(f)
print("total nights:", loaded["nights"] + sum(s["nights"] for s in loaded["stops"]))
```

> **In the wild:** JSON is everywhere: nearly every web API sends JSON, VS Code''s settings are a JSON file, and Python projects ship config in it. When you call a weather API, you get JSON text back and `json.loads` turns it into ordinary dictionaries and lists.

```python exercise id=settings-json title="Save and load app settings"
import json

def save_settings(path, settings):
    """Write the `settings` dict to `path` as JSON, with indent=2."""
    # TODO: open the file for writing and json.dump the settings into it.
    ...

def load_settings(path):
    """Return the settings dict stored at `path`.
    If the file doesn''t exist yet, return {"theme": "light", "volume": 5}."""
    # TODO: json.load the file; catch FileNotFoundError and return the defaults.
    ...

save_settings("settings.json", {"theme": "dark", "volume": 8, "muted": False})
print(load_settings("settings.json"))
print(load_settings("no_such_file.json"))
--- solution
import json

def save_settings(path, settings):
    """Write the `settings` dict to `path` as JSON, with indent=2."""
    with open(path, "w", encoding="utf-8") as f:
        json.dump(settings, f, indent=2)

def load_settings(path):
    """Return the settings dict stored at `path`.
    If the file doesn''t exist yet, return {"theme": "light", "volume": 5}."""
    try:
        with open(path, encoding="utf-8") as f:
            return json.load(f)
    except FileNotFoundError:
        return {"theme": "light", "volume": 5}

save_settings("settings.json", {"theme": "dark", "volume": 8, "muted": False})
print(load_settings("settings.json"))
print(load_settings("no_such_file.json"))
--- test
from pathlib import Path
check = Path("_check_settings.json")
check.unlink(missing_ok=True)
data = {"theme": "solarized", "volume": 3, "muted": True, "recent": ["a.txt", "b.txt"]}
save_settings("_check_settings.json", data)
assert check.exists(), "`save_settings` didn''t create the file. Replace its `...` with code that opens `path` in \"w\" mode."
text = check.read_text(encoding="utf-8")
try:
    parsed = json.loads(text)
except ValueError:
    assert False, f"The file doesn''t contain valid JSON. It contains: {text[:60]!r}. Use json.dump."
assert parsed == data, f"The saved JSON should hold the settings exactly, but it holds {parsed!r}."
assert "\n  " in text, "Save with `indent=2` so the file is easy for people to read."
loaded = load_settings("_check_settings.json")
assert loaded is not None, "`load_settings` returned None. Replace its `...` and return the loaded dict."
assert loaded == data, f"`load_settings` should return what was saved, {data!r}, but returned {loaded!r}."
Path("_missing_settings.json").unlink(missing_ok=True)
default = load_settings("_missing_settings.json")
assert default == {"theme": "light", "volume": 5}, f"For a missing file, `load_settings` should return the defaults, but returned {default!r}."
--- hint
Saving: `with open(path, "w", encoding="utf-8") as f:` then `json.dump(settings, f, indent=2)`.
--- hint
Loading: put the `with open(path, ...)` and `return json.load(f)` inside a `try:` block.
--- hint
Add `except FileNotFoundError:` and return the default dictionary from the docstring.
```

## Recap

- Open files with `with open(path, mode, encoding="utf-8") as f:`, so they''re always closed. Modes: `"r"` read (default), `"w"` **erase** and write, `"a"` append.
- `write()` adds exactly what you give it: include `"\n"` yourself. When reading, `.strip()` each line (or use `.splitlines()`).
- `pathlib.Path` gives you `exists()`, `read_text()` and `write_text()`; catch `FileNotFoundError` when a file might not exist yet.
- Use the `csv` module (with `newline=""`) for tables: `csv.reader`, `csv.DictReader` and `csv.writer`. **Every CSV value is a string** until you convert it.
- Use `json.dump`/`json.load` (files) and `json.dumps`/`json.loads` (strings) for nested dicts and lists; `indent=2` makes files readable.

**Up next:** modules and the standard library: how `import` really works, Python''s "batteries included" toolkit (`random`, `datetime`, `collections` and more), and how to split your own code into modules.
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z'),
('les_python_basics_6_3', 'sec_python_basics_6', 'crs_python_basics', 'Modules and the standard library', 'interactive', 2, 960, NULL, NULL, 'You''ve already borrowed other people''s code without making a fuss about it. `import math` gave you square roots, `import csv` read spreadsheets, `import json` saved your settings. Each of those was a **module**: a file of ready-made Python that someone else wrote, tested, and shared.

Python ships with hundreds of them, a collection called the **standard library**. Programmers describe Python as "batteries included" because of it: dates, randomness, statistics, counting, file paths and much more are already installed and waiting. In this lesson you''ll learn exactly how `import` works, take a guided tour of the modules you''ll reach for most, explore unfamiliar ones on your own, and split your own code into modules.

## What a module is

A module is simply a `.py` file full of definitions: functions, variables, sometimes classes. Importing it runs that file once and gives you a name to reach inside it with a dot:

```python run
import math

print("square root of 2:", math.sqrt(2))
print("pi to 5 places:", round(math.pi, 5))
print("round 7.2 up:", math.ceil(7.2))
math
```

Think of a module as a toolbox with a label on the lid. `import math` puts the toolbox on your bench; `math.sqrt` means "the `sqrt` tool from the `math` box". The label prevents confusion: `math.floor` and a variable you named `floor` can''t collide.

## Four ways to import

| Style | Then you write | Good for |
|---|---|---|
| `import math` | `math.sqrt(9)` | most code: always clear where a name comes from |
| `from math import sqrt, pi` | `sqrt(9)` | a few names you use constantly |
| `import statistics as stats` | `stats.mean(...)` | long module names, or a famous convention |
| `from math import sqrt as root` | `root(9)` | avoiding a clash with one of your own names |

```python run
from math import sqrt, pi
import statistics as stats

print("diagonal of a 3x4 screen:", sqrt(3**2 + 4**2))
print("area of a 10cm pizza:", round(pi * 5**2, 1), "cm²")
print("average rating:", stats.mean([4, 5, 3, 5, 4]))
```

The most common import mistake is mixing the styles up. `import math` makes **only the name `math`** available; the functions stay inside the box:

```python run error
import math

whole_pizzas = floor(7.8)     # forgot the "math." part
print(whole_pizzas)
```

The fix is either `math.floor(7.8)` or `from math import floor` at the top. Both work; the first makes it obvious, months later, where `floor` came from.

> **Pitfall:** Never name your own file after a module you want to use. If you save your practice script as `random.py`, then `import random` inside it imports *your file* instead of Python''s, and `random.randint` mysteriously "doesn''t exist". The same goes for `math.py`, `csv.py`, `json.py` and friends.

> **Tip:** You''ll sometimes see `from math import *`, which dumps every name from the module into your code. Avoid it: you can no longer tell where names came from, and it can silently overwrite your own variables.

## random: controlled chance

The `random` module makes games, simulations and shuffled quizzes possible. Real randomness is a problem when you''re testing, though: you want the *same* "random" results every run. A **seed** gives you that. Same seed, same sequence, every time:

```python run
import random

random.seed(42)
print("dice roll:", random.randint(1, 6))           # 1 to 6, both ends included
print("lunch:", random.choice(["pizza", "sushi", "tacos"]))
print("raffle winners:", random.sample(["Ana", "Ben", "Cy", "Dee", "Eli"], 2))

playlist = ["intro", "verse", "chorus", "bridge"]
random.shuffle(playlist)                             # shuffles IN PLACE, returns None
print("shuffled:", playlist)
```

| Function | Does |
|---|---|
| `random.seed(n)` | make the sequence repeatable |
| `random.randint(a, b)` | whole number from `a` to `b`, **both included** |
| `random.random()` | float from 0.0 up to (not including) 1.0 |
| `random.choice(seq)` | one item |
| `random.sample(seq, k)` | `k` different items, as a new list |
| `random.shuffle(lst)` | reorder a list in place |

For code that shouldn''t disturb anyone else''s sequence, make your own private generator: `rng = random.Random(7)` gives an object with all the same methods (`rng.choice(...)`, `rng.randint(...)`), seeded with 7.

```python predict id=predict-seed title="Same seed, same rolls?"
import random

random.seed(5)
first = [random.randint(1, 6) for roll in range(3)]
random.seed(5)
second = [random.randint(1, 6) for roll in range(3)]
print(first == second)
--- options
* True
False
None
[True, True, True]
--- explain
"Random" numbers in a computer are produced by a formula. The seed is its starting point, so re-seeding with 5 replays exactly the same three rolls. That''s why tests and games with replay features seed their generators.
```

```python exercise id=draw-winners title="A fair, repeatable raffle"
import random

def draw_winners(names, k, seed):
    """Return a list of k DIFFERENT winners picked from `names`.
    The same seed must always give the same winners.
    Don''t change the `names` list itself."""
    # TODO: make a generator with random.Random(seed) (or call random.seed(seed)),
    # then pick k different names.
    ...

entrants = ["Ana", "Ben", "Cy", "Dee", "Eli", "Fay", "Gus"]
print("winners:", draw_winners(entrants, 3, seed=2026))
--- solution
import random

def draw_winners(names, k, seed):
    """Return a list of k DIFFERENT winners picked from `names`.
    The same seed must always give the same winners.
    Don''t change the `names` list itself."""
    rng = random.Random(seed)
    return rng.sample(names, k)

entrants = ["Ana", "Ben", "Cy", "Dee", "Eli", "Fay", "Gus"]
print("winners:", draw_winners(entrants, 3, seed=2026))
--- test
people = ["Ana", "Ben", "Cy", "Dee", "Eli", "Fay", "Gus"]
before = list(people)
got = draw_winners(people, 3, seed=2026)
assert got is not None, "`draw_winners` returned None. Replace the `...` and return a list of winners."
assert isinstance(got, list), f"`draw_winners` should return a list, but returned {type(got).__name__}."
assert people == before, "`draw_winners` changed the `names` list. Pick winners without shuffling the original."
assert len(got) == 3, f"Asked for 3 winners but got {len(got)}: {got!r}."
assert len(set(got)) == 3, f"Winners must all be different people, but got {got!r}. Which function never picks the same item twice?"
assert all(name in people for name in got), f"Every winner must come from `names`, but got {got!r}."
assert draw_winners(people, 3, seed=2026) == got, "Calling again with the same seed gave different winners. Seed the generator inside the function."
draws = {tuple(draw_winners(people, 3, seed=s)) for s in range(8)}
assert len(draws) > 1, "Every seed gives the same winners. Make sure you actually use the `seed` argument."
big = draw_winners(list(range(50)), 10, seed=1)
assert len(big) == 10 and len(set(big)) == 10, "Try it on a bigger list: `draw_winners(list(range(50)), 10, seed=1)` should give 10 different items."
--- hint
To make results repeatable, the seed has to be set inside the function, every time it''s called.
--- hint
`random.Random(seed)` creates a seeded generator. Which method picks `k` different items without changing the original list?
--- hint
`rng.sample(names, k)` returns a new list of `k` distinct items.
```

## datetime: dates without the headaches

How many days until a holiday? What date is 30 days after an invoice? Months have different lengths and leap years exist, so never do date math by hand. The `datetime` module''s `date` and `timedelta` handle all of it:

```python run
from datetime import date, timedelta

trip_start = date(2026, 7, 14)
trip_end = date(2026, 7, 28)

print("nights away:", (trip_end - trip_start).days)
print("pack by:", trip_start - timedelta(days=3))
print("leaves on:", trip_start.strftime("%A %d %B %Y"))
print("weekday number:", trip_start.weekday(), "(Monday = 0 ... Sunday = 6)")
```

- Subtracting two dates gives a `timedelta`; its `.days` is a plain `int`.
- Adding or subtracting a `timedelta(days=...)` gives a new `date`, correctly rolling over months and years.
- `.strftime(...)` formats a date as text: `%A` weekday name, `%d` day, `%B` month name, `%Y` year.

> **Tip:** `date.today()` gives the current date. It''s perfect in real programs, but it changes every day, so the examples and tests in this course stick to fixed dates you can predict.

```python exercise id=library-due-date title="When is the book due?"
from datetime import date, timedelta

def due_date(borrowed, days=21):
    """Return the date a library book is due: `days` days after `borrowed`.
    The library is closed at weekends, so if that lands on a Saturday
    or Sunday, the book is due the following Monday instead."""
    # TODO: add a timedelta, then use .weekday() (Saturday = 5, Sunday = 6)
    # to push weekend dates forward to Monday.
    ...

print(due_date(date(2026, 3, 2)))     # lands on a Monday
print(due_date(date(2026, 3, 7)))     # would land on a Saturday
--- solution
from datetime import date, timedelta

def due_date(borrowed, days=21):
    """Return the date a library book is due: `days` days after `borrowed`.
    The library is closed at weekends, so if that lands on a Saturday
    or Sunday, the book is due the following Monday instead."""
    due = borrowed + timedelta(days=days)
    if due.weekday() == 5:
        due += timedelta(days=2)
    elif due.weekday() == 6:
        due += timedelta(days=1)
    return due

print(due_date(date(2026, 3, 2)))
print(due_date(date(2026, 3, 7)))
--- test
got = due_date(date(2026, 3, 2))
assert got is not None, "`due_date` returned None. Replace the `...` and return a date."
assert isinstance(got, date), f"`due_date` should return a date object, but returned {got!r}. Add a timedelta to `borrowed`."
assert got == date(2026, 3, 23), f"Borrowed on 2026-03-02, the book is due 21 days later on 2026-03-23, but you returned {got}."
def _ref(b, d=21):
    x = b + timedelta(days=d)
    return x + timedelta(days={5: 2, 6: 1}.get(x.weekday(), 0))
sat = due_date(date(2026, 3, 7))
assert sat.weekday() not in (5, 6), f"2026-03-07 + 21 days is a Saturday, so the book should be due on Monday, but you returned {sat} ({sat.strftime(''%A'')})."
assert sat == date(2026, 3, 30), f"A Saturday due date should move to the next Monday (2026-03-30), but you returned {sat}."
for b, d in [(date(2026, 3, 8), 21), (date(2025, 12, 20), 14), (date(2026, 2, 20), 8), (date(2028, 2, 10), 21), (date(2026, 10, 30), 7)]:
    mine = due_date(b, d)
    assert mine == _ref(b, d), f"`due_date({b!r}, {d})` should be {_ref(b, d)} but is {mine}. Check the `days` argument and the weekend rule."
--- hint
Start with `due = borrowed + timedelta(days=days)`. Use the `days` parameter, not a hard-coded 21.
--- hint
`due.weekday()` is 5 for Saturday and 6 for Sunday. How many days does each need to reach Monday?
--- hint
Add `timedelta(days=2)` for a Saturday and `timedelta(days=1)` for a Sunday, then return `due`.
```

## collections: Counter and defaultdict

Back in the dictionaries lesson you counted words with `counts[w] = counts.get(w, 0) + 1`. That pattern is so common that the `collections` module has a ready-made tool for it. A `Counter` is a dictionary that counts:

```python run
from collections import Counter

votes = ["pizza", "tacos", "pizza", "sushi", "pizza", "tacos"]
tally = Counter(votes)

print(tally)
print("pizza votes:", tally["pizza"], "| burger votes:", tally["burger"])   # missing → 0, no KeyError
print("top two:", tally.most_common(2))
```

Its sibling `defaultdict` creates a starting value automatically the first time you touch a key. `defaultdict(list)` is perfect for grouping:

```python run
from collections import defaultdict

books = [("Dune", "sci-fi"), ("Emma", "classic"), ("Neuromancer", "sci-fi"), ("Persuasion", "classic"), ("Hyperion", "sci-fi")]

by_genre = defaultdict(list)
for title, genre in books:
    by_genre[genre].append(title)     # no "if genre not in by_genre" needed

print(dict(by_genre))
```

```python predict id=predict-counter title="Most common letter"
from collections import Counter
print(Counter("banana").most_common(1))
--- options
(''a'', 3)
* [(''a'', 3)]
{''a'': 3}
a
--- explain
A `Counter` can count any iterable, including the letters of a string. `most_common(n)` always returns a **list** of `(item, count)` tuples, even when you ask for just one, so `.most_common(1)[0]` would give the tuple `(''a'', 3)`.
```

## string and statistics: two small gems

The `string` module holds handy constants, and `statistics` does the averages you''d otherwise write by hand:

```python run
import string
import statistics

print("letters:", string.ascii_lowercase)
print("punctuation:", string.punctuation)

lap_times = [61.2, 59.8, 60.5, 62.1, 59.8]
print("mean:", round(statistics.mean(lap_times), 2))
print("median:", statistics.median(lap_times))
print("mode:", statistics.mode(lap_times))
print("stdev:", round(statistics.stdev(lap_times), 2))
```

`string.punctuation` pairs beautifully with `.strip()`: `"hello!".strip(string.punctuation)` is `"hello"`. You''ll need that next.

```python exercise id=top-words title="The most common words in a review"
from collections import Counter
import string

def top_words(text, n):
    """Return the n most common words in `text` as a list of (word, count) tuples,
    most common first. Ignore case and strip punctuation from the ends of words."""
    # TODO: lowercase the text, split it into words, strip punctuation
    # from each word, skip any that become empty, then count with Counter.
    ...

review = "Great coffee! The coffee was hot, the staff were great, and the cake... the CAKE was great too."
print(top_words(review, 3))
--- solution
from collections import Counter
import string

def top_words(text, n):
    """Return the n most common words in `text` as a list of (word, count) tuples,
    most common first. Ignore case and strip punctuation from the ends of words."""
    words = [w.strip(string.punctuation) for w in text.lower().split()]
    return Counter(w for w in words if w).most_common(n)

review = "Great coffee! The coffee was hot, the staff were great, and the cake... the CAKE was great too."
print(top_words(review, 3))
--- test
got = top_words("Great coffee! The coffee was hot, the staff were great, and the cake... the CAKE was great too.", 3)
assert got is not None, "`top_words` returned None. Replace the `...` and return the result of `.most_common(n)`."
assert isinstance(got, list), f"`top_words` should return a list of (word, count) tuples, but returned {type(got).__name__}."
assert len(got) == 3, f"Asked for 3 words but got {len(got)}: {got!r}."
assert got[0] == ("the", 4), f"The top word should be (''the'', 4), but is {got[0]!r}. Did you lowercase the text?"
assert got[1] == ("great", 3), f"Second should be (''great'', 3), but is {got[1]!r}. Are ''great,'' and ''Great'' counted as the same word?"
assert got[2] in [("coffee", 2), ("was", 2), ("cake", 2)], f"Third should be one of the words that appear twice, but is {got[2]!r}."
fresh = top_words("Go, go, GO! Stop. stop... wait -- go?", 2)
assert fresh == [("go", 4), ("stop", 2)], f"`top_words(\"Go, go, GO! Stop. stop... wait -- go?\", 2)` should be [(''go'', 4), (''stop'', 2)], not {fresh!r}."
assert top_words("...", 5) == [], "Text that''s only punctuation has no words: return an empty list."
--- hint
`text.lower().split()` gives you the words; `word.strip(string.punctuation)` cleans each one. A lone `--` or `...` becomes `""`, so skip empty strings.
--- hint
`Counter(list_of_words)` counts them all at once. Which Counter method returns the top `n` as `(word, count)` tuples?
--- hint
Return `Counter(...).most_common(n)`.
```

## Exploring a module on your own

Nobody memorizes the standard library. Professionals look things up, and Python has two built-in tools for it. `dir(module)` lists the names inside; `help(thing)` prints its documentation:

```python run
import random

public = [name for name in dir(random) if not name.startswith("_")]
print(len(public), "public names, such as:", public[:8])

help(random.randint)
```

Names starting with `_` are internal plumbing, so we filter them out. When you find a promising name, `help()` tells you what it does and what arguments it takes.

> **In the wild:** The official docs at docs.python.org include "The Python Standard Library" with a page for every module. Beyond the standard library, `pip install` gives you over half a million third-party packages, such as `requests` for the web, `pandas` for data and `django` for websites, and they''re all imported exactly the way you''ve learned here.

## Debug challenge: random stopped working

```python debug id=random-name-clash title="random.seed suddenly doesn''t exist"
import random
from random import random     # "so I can write random() for a quick coin flip"

def pick_snack(snacks, seed):
    """Pick one snack, reproducibly, using the seed."""
    random.seed(seed)
    return random.choice(snacks)

def coin_flip():
    return "heads" if random() < 0.5 else "tails"

print("snack:", pick_snack(["chips", "apple", "popcorn", "pretzels"], seed=1))
print("flip:", coin_flip())
--- solution
import random

def pick_snack(snacks, seed):
    """Pick one snack, reproducibly, using the seed."""
    random.seed(seed)
    return random.choice(snacks)

def coin_flip():
    return "heads" if random.random() < 0.5 else "tails"

print("snack:", pick_snack(["chips", "apple", "popcorn", "pretzels"], seed=1))
print("flip:", coin_flip())
--- test
import random as _rnd
snacks = ["chips", "apple", "popcorn", "pretzels"]
_rnd.seed(1)
expected = _rnd.choice(snacks)
assert pick_snack(snacks, seed=1) == expected, f"`pick_snack(snacks, seed=1)` should pick {expected!r}."
_rnd.seed(9)
expected9 = _rnd.choice(["tea", "cake", "fruit"])
assert pick_snack(["tea", "cake", "fruit"], seed=9) == expected9, "`pick_snack` should seed and then pick from the list it''s given."
_rnd.seed(0)
flips = [coin_flip() for i in range(20)]
assert set(flips) == {"heads", "tails"}, f"`coin_flip()` should return ''heads'' or ''tails'' at random, but 20 flips gave {sorted(set(flips))}."
--- hint
Run it and read the last line of the error: `random` is a *function* by the time `pick_snack` runs, not the module.
--- hint
`from random import random` takes the `random()` function out of the module and gives it the name `random`, replacing the module you imported on the line above.
--- hint
Keep the plain `import random` only, and write `random.random()` inside `coin_flip`.
```

## Debug challenge: the map distance crashes

```python debug id=missing-math-prefix title="NameError: sqrt is not defined"
import math

def distance(x1, y1, x2, y2):
    """Straight-line distance between two points on a city grid (in km)."""
    return sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2)

def taxi_fare(km):
    """$3 to start, plus $2 for every km or part of a km."""
    return 3 + 2 * ceil(km)

d = distance(0, 0, 3, 4)
print("distance:", d, "km | fare: $", taxi_fare(d))
--- solution
import math

def distance(x1, y1, x2, y2):
    """Straight-line distance between two points on a city grid (in km)."""
    return math.sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2)

def taxi_fare(km):
    """$3 to start, plus $2 for every km or part of a km."""
    return 3 + 2 * math.ceil(km)

d = distance(0, 0, 3, 4)
print("distance:", d, "km | fare: $", taxi_fare(d))
--- test
assert distance(0, 0, 3, 4) == 5.0, f"`distance(0, 0, 3, 4)` should be 5.0, not {distance(0, 0, 3, 4)!r}."
assert abs(distance(1, 1, 4, 5) - 5.0) < 1e-9 and abs(distance(0, 0, 1, 1) - 2 ** 0.5) < 1e-9, "`distance` should use the Pythagorean formula for any two points."
assert taxi_fare(5.0) == 13, f"`taxi_fare(5.0)` should be 13 ($3 + 5 km x $2), not {taxi_fare(5.0)!r}."
assert taxi_fare(1.2) == 7, f"`taxi_fare(1.2)` should round the 1.2 km up to 2 km, giving 7, not {taxi_fare(1.2)!r}."
--- hint
Read the error''s last line: Python has never heard of `sqrt`. Where does it actually live?
--- hint
`import math` only creates the name `math`. Fix the first NameError, run again, and you''ll meet a second one of the same kind.
--- hint
Either write `math.sqrt` and `math.ceil`, or change the import to `from math import sqrt, ceil`.
```

## Writing your own modules

Here''s the satisfying part: **any `.py` file is a module**. Once a program grows past a screen or two, you split it into files (say, `shop_utils.py` for helper functions and `main.py` for the program itself) and `import` one from the other.

This page''s sandboxed filesystem lets us do it for real. First, write a module file:

```python run
from pathlib import Path

Path("shop_utils.py").write_text(''''''\
"""Helpers for our little online shop."""

TAX_RATE = 0.2

def with_tax(price):
    """Return the price including tax, rounded to cents."""
    return round(price * (1 + TAX_RATE), 2)

def format_price(price):
    return f"${price:,.2f}"
'''''', encoding="utf-8")

print("wrote shop_utils.py")
```

Now import it exactly like a standard library module. Python finds it because it''s in the current folder:

```python run
import importlib
importlib.invalidate_caches()   # only needed because the file was created while Python was running

import shop_utils

print("tax rate:", shop_utils.TAX_RATE)
print("price with tax:", shop_utils.format_price(shop_utils.with_tax(49.99)))
```

> **Under the hood:** Python runs a module''s code only **the first time** it''s imported, then keeps it in memory (in `sys.modules`). A second `import shop_utils` is instant and doesn''t re-run the file. That''s also why editing a module file doesn''t affect a program that already imported it until you restart.

## `if __name__ == "__main__":`

Every module has a built-in variable called `__name__`. When Python runs a file **directly** (`python greetings.py`), it sets `__name__` to `"__main__"`. When the file is **imported**, `__name__` is the module''s own name instead. That lets one file behave both ways:

```python run
Path("greetings.py").write_text(''''''\
def greet(name):
    return f"Hello, {name}!"

print("inside greetings.py, __name__ is", repr(__name__))

if __name__ == "__main__":
    # Only runs when the file is run directly, e.g. a quick self-test
    print(greet("tester"))
'''''', encoding="utf-8")
importlib.invalidate_caches()

import greetings
print(greetings.greet("Ana"))
```

Because we *imported* `greetings`, its `__name__` was `"greetings"`, so the self-test inside the `if` was skipped. Run that file directly and the self-test would run instead. (Run the cell a second time and the module''s `print` won''t appear: it was already imported.)

```python predict id=predict-dunder-name title="What is __name__ here?"
print(__name__)
--- options
* __main__
main
None
__name__
--- explain
Your cells run as the main program, not as an imported module, so `__name__` is `"__main__"`. That''s exactly the situation `if __name__ == "__main__":` checks for.
```

> **In the wild:** Almost every Python script you''ll read at work ends with `if __name__ == "__main__": main()`. It means "run the program when started directly, but let other files import my functions without kicking it off". Test tools like `pytest` rely on that: they import your file to test its functions without running the whole program.

## Recap

- A **module** is a `.py` file of reusable code; the **standard library** is the big set of modules that comes with Python.
- `import math` → `math.sqrt(...)`; `from math import sqrt` → `sqrt(...)`; `as` gives a shorter or non-clashing name. Don''t name your files after modules you use.
- Tour highlights: `random` (seed it for repeatable results), `datetime` (`date`, `timedelta`, `.weekday()`, `.strftime`), `collections` (`Counter`, `defaultdict`), `string`, `statistics`.
- Explore unfamiliar modules with `dir()` and `help()`.
- Your own `.py` files are modules too; `if __name__ == "__main__":` separates "run me" code from "import me" code.

**Up next:** classes and objects, where you''ll design your own data types, like a `BankAccount` that knows its own balance.
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_python_basics_6_4', 'sec_python_basics_6', 'crs_python_basics', 'Checkpoint: errors, files & modules', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"A traceback ends with `KeyError: ''coffee''`. Where should you look first to understand what went wrong?","options":["The first line of the traceback, because that''s where the program started","The last line, then the code line just above it, then work upward through the calls","Only at the line numbers, since the message is usually misleading","At the `import` statements at the top of the file"],"answerIndex":1,"explanation":"Read tracebacks bottom-up: the last line says what went wrong (a missing dictionary key), the line above it shows where, and the frames above that show how the program got there."},{"id":"q2","prompt":"A `try` block runs `n = int(\"3.5\")` and then `print(\"ok\")`. It has an `except ValueError:` block that prints `bad`, and a `finally:` block that prints `done`. What is printed?","options":["ok, then done","bad","3, then ok, then done","bad, then done"],"answerIndex":3,"explanation":"`int(\"3.5\")` raises `ValueError` (int() can''t parse a decimal point), so `print(\"ok\")` is skipped and the `except` block prints `bad`. `finally` always runs, so `done` prints too."},{"id":"q3","prompt":"Why is a bare `except:` (with no exception type) considered dangerous?","options":["It''s a SyntaxError in modern Python","It only catches the first error and then crashes on the second","It also catches bugs you didn''t expect, like a NameError from a typo, and hides them silently","It makes the program run much more slowly"],"answerIndex":2,"explanation":"A bare `except:` catches everything, including typos in your own code and even Ctrl+C. Catch the specific exception you expect, such as `except ValueError:`, so real bugs still crash where you can see them."},{"id":"q4","prompt":"You''re writing `set_age(age)` and someone passes `-4`. What''s the most professional response inside the function?","options":["`raise ValueError(\"age can''t be negative\")`","`print(\"bad age\")` and carry on","Quietly change the age to 0","`return None` with no message"],"answerIndex":0,"explanation":"Raising an exception refuses bad input loudly and clearly. The caller can catch the `ValueError` if they know how to handle it; otherwise the problem surfaces right away instead of causing confusing results later."},{"id":"q5","prompt":"`notes.txt` contains three lines. What happens after running `with open(\"notes.txt\", \"w\") as f: f.write(\"new idea\\n\")`?","options":["The file has four lines, with \"new idea\" at the end","The file contains only \"new idea\"","Python raises FileExistsError because the file already exists","The file has four lines, with \"new idea\" at the start"],"answerIndex":1,"explanation":"Mode `\"w\"` erases the file as soon as it''s opened, then writes. To add to the end of an existing file, open it in append mode, `\"a\"`."},{"id":"q6","prompt":"A CSV has a `price` column. After `rows = list(csv.DictReader(f))`, what is the type of `rows[0][\"price\"]`?","options":["float","int or float, depending on the value","Decimal","str"],"answerIndex":3,"explanation":"A CSV file is plain text, and the `csv` module doesn''t guess types. Every value is a string until you convert it with `int()` or `float()`. Comparing prices as strings gives wrong answers, for example `\"4.50\" > \"12.00\"` is True."},{"id":"q7","prompt":"What does `json.dumps({\"done\": False, \"note\": None})` return?","options":["`{\"done\": false, \"note\": null}`","`{''done'': False, ''note'': None}`","`{\"done\": False, \"note\": None}`","`{\"done\": \"False\", \"note\": \"None\"}`"],"answerIndex":0,"explanation":"JSON has its own spellings: double-quoted strings, lowercase `true`/`false`, and `null` for Python''s `None`. `json.loads` converts them back to Python values."},{"id":"q8","prompt":"`import random` followed by `roll = randint(1, 6)` crashes with `NameError: name ''randint'' is not defined`. Which fix is right?","options":["Change the first line to `import randint`","Write `roll = random.randint(1, 6)`","Write `roll = random(randint(1, 6))`","Add `randint = 6` before the roll"],"answerIndex":1,"explanation":"`import random` creates only the name `random`; its functions stay inside the module, reached with a dot. Alternatively, `from random import randint` makes `randint` available directly."},{"id":"q9","prompt":"What does `Counter([\"red\", \"blue\", \"red\", \"green\", \"red\"]).most_common(1)` return? (`Counter` comes from the `collections` module.)","options":["`\"red\"`","`(\"red\", 3)`","`[(\"red\", 3)]`","`{\"red\": 3}`"],"answerIndex":2,"explanation":"`most_common(n)` always returns a list of `(item, count)` tuples, most common first, even when n is 1."},{"id":"q10","prompt":"A file `tools.py` ends with `if __name__ == \"__main__\": run_demo()`. When does `run_demo()` run?","options":["Every time anything imports `tools`","Never, because `__name__` is always \"tools\"","Only when `tools.py` is run directly as the main program, not when it''s imported","Only the second time it is imported"],"answerIndex":2,"explanation":"Python sets `__name__` to \"__main__\" for the file it runs directly, and to the module''s own name (\"tools\") when it''s imported. The guard lets a file work both as a runnable script and as an importable module."}]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z'),
('les_python_basics_7_1', 'sec_python_basics_7', 'crs_python_basics', 'Classes and objects: your own data types', 'interactive', 0, 1200, NULL, NULL, 'So far you''ve described the world with Python''s built-in types: a string for a name, a float for a price, a list for a playlist, a dict for a customer record. That takes you a long way, but real programs are full of *things*: bank accounts, pets, playlists, game characters, orders. Each one has some data (a balance, a name, a list of songs) **and** some actions that belong with that data (deposit, rename, add a song).

A **class** lets you invent your own type that bundles the two together. By the end of this lesson you''ll be able to write a `BankAccount` that knows how to take deposits, a `Playlist` that keeps track of its own songs, and a game `Character` that can take damage and heal, and you''ll understand the one word that confuses every beginner at first: `self`.

## You''ve been using objects all along

Every value in Python is an **object**: a bundle of data plus the actions it knows how to do. You''ve called those actions **methods** since lesson 6. Look at what `type()` says about a few familiar values:

```python run
city = "lisbon"
print(type(city))
print(city.title())          # a method: an action this string knows

scores = [72, 90]
scores.append(85)            # a method that changes this list
print(type(scores), scores)
```

Notice the word **class** in `<class ''str''>` and `<class ''list''>`. `str` and `list` are classes that come with Python. `"lisbon"` is one particular string object made from the `str` class; `scores` is one particular list made from the `list` class. Today you''ll write classes of your own, and they''ll work exactly the same way.

## A class is a blueprint, an instance is a house

The best mental model is an architect''s blueprint. The blueprint describes what every house will have (rooms, a front door, a mailbox) but you can''t live in a blueprint. You use it to build actual houses, and each house has its own furniture, its own paint colour, its own address.

```text
            class Pet                       ← the blueprint (written once)
   "every pet has a name, a species, an age"
                 │
       ┌─────────┴──────────┐
       ▼                    ▼
   ┌──────────────┐    ┌──────────────┐
   │ name: "Rex"  │    │ name: "Luna" │  ← instances (objects) built from it,
   │ species: dog │    │ species: cat │    each with its own data
   │ age: 3       │    │ age: 5       │
   └──────────────┘    └──────────────┘
```

| Word | Meaning | Everyday version |
|---|---|---|
| **class** | the blueprint that describes a kind of thing | the house plans |
| **instance** / **object** | one actual thing built from the class | one particular house |
| **attribute** | a piece of data stored on an object | the colour of *that* house''s door |
| **method** | a function defined inside a class | something a house can do: "ring doorbell" |

Here is the smallest possible class. `class Pet:` starts the blueprint, and `pass` means "nothing else yet". Calling the class like a function, `Pet()`, builds a new instance:

```python run
class Pet:
    pass

rex = Pet()
luna = Pet()

rex.name = "Rex"        # attach an attribute to this one object
luna.name = "Luna"

print(type(rex))
print(rex.name, "and", luna.name)
print("same object?", rex is luna)
```

`<class ''__main__.Pet''>` reads as "the `Pet` class defined in this program" (`__main__` is Python''s name for the program you''re running). Class names use **CapitalizedWords** (`Pet`, `BankAccount`), unlike the snake_case you use for variables and functions, so you can spot a class at a glance.

Attaching attributes from outside like this works, but it''s fragile: forget one line and that pet simply has no `name`. A good blueprint should guarantee that every object is built complete.

## `__init__`: setting up each new object

A class can define a special method called `__init__` (two underscores on each side, said "dunder init"). Python runs it **automatically** every time you build a new instance. Its job is to fill in the new object''s attributes.

```python run
class Pet:
    def __init__(self, name, species, age):
        print(f"  (__init__ is setting up {name})")
        self.name = name
        self.species = species
        self.age = age

rex = Pet("Rex", "dog", 3)
luna = Pet("Luna", "cat", 5)

print(rex.name, "is a", rex.species)
print(luna.name, "is", luna.age, "years old")
```

Here''s what happens when Python reads `rex = Pet("Rex", "dog", 3)`:

```text
1. Python builds a brand-new, empty Pet object.
2. It calls  __init__(that_new_object, "Rex", "dog", 3)
                      ▲
                      └── this is what `self` receives
3. Inside __init__, self.name = name stores "Rex" ON the new object.
4. The finished object comes back and gets the name tag `rex`.
```

You pass three arguments, but `__init__` has four parameters. The extra first one, `self`, is filled in by Python: it''s the object being built.

> **Tip:** `self.name = name` looks repetitive, but the two names are different things. The right-hand `name` is the parameter, a temporary local variable that disappears when `__init__` ends. The left-hand `self.name` is an **attribute** stored on the object, and it lives as long as the object does.

## `self` means "this particular object"

Methods are functions written inside the class. Every method''s first parameter is `self`, and inside the method `self` means *whichever object the method was called on*. When you write `rex.describe()`, `self` is `rex`. When you write `luna.describe()`, `self` is `luna`. One blueprint, many objects, and `self` is how the shared code knows which one it''s working on.

```python run
class Pet:
    def __init__(self, name, species, age):
        self.name = name
        self.species = species
        self.age = age

    def describe(self):
        return f"{self.name} the {self.species}, age {self.age}"

rex = Pet("Rex", "dog", 3)
luna = Pet("Luna", "cat", 5)

print(rex.describe())
print(luna.describe())
print(Pet.describe(rex))   # what rex.describe() really does behind the scenes
```

That last line is the secret. `rex.describe()` is shorthand for `Pet.describe(rex)`: Python looks up `describe` on the class and passes `rex` in as the first argument. That''s all `self` is: an ordinary parameter that Python fills in for you.

> **Coming from another language:** In Java, C# or JavaScript the equivalent is `this`, and it''s implicit. Python makes it explicit: you always write `self` in the method''s parameter list and always write `self.` to reach an attribute. The name `self` is only a convention, but every Python programmer uses it, so you should too.

Forget `self` in a method definition and you get one of the most baffling-looking errors in Python. Run it:

```python run error
class Pet:
    def __init__(self, name):
        self.name = name

    def speak():                 # forgot self!
        return "..."

rex = Pet("Rex")
rex.speak()
```

"takes 0 positional arguments but 1 was given", yet you didn''t pass any arguments! You did, invisibly: `rex.speak()` is really `Pet.speak(rex)`, so Python passed `rex` and the method had no parameter to receive it. Whenever you see a "but 1 was given" error on a method call, check for a missing `self`.

```python predict id=predict-self-greet title="Who is self?"
class Greeter:
    def __init__(self, name):
        self.name = name

    def greet(self, other):
        return f"Hi {other}, I''m {self.name}"

ana = Greeter("Ana")
ben = Greeter("Ben")
print(ben.greet("Ana"))
--- options
* Hi Ana, I''m Ben
Hi Ben, I''m Ana
Hi Ana, I''m Ana
Hi other, I''m self.name
--- explain
The method was called **on `ben`**, so inside `greet`, `self` is `ben` and `self.name` is `"Ben"`. The argument `"Ana"` lands in the `other` parameter. Read `ben.greet("Ana")` as `Greeter.greet(ben, "Ana")` and it''s clear which value goes where.
```

```python exercise id=song-class title="A song that knows its length"
class Song:
    """One song on a playlist."""

    def __init__(self, title, artist, seconds):
        # TODO: store title, artist and seconds as attributes on self
        ...

    def duration(self):
        """Return the length as ''m:ss'', e.g. 205 seconds -> ''3:25''."""
        # TODO: use self.seconds to build the string
        ...

track = Song("Bohemian Rhapsody", "Queen", 354)
print(track.duration())    # should print 5:54
--- solution
class Song:
    """One song on a playlist."""

    def __init__(self, title, artist, seconds):
        self.title = title
        self.artist = artist
        self.seconds = seconds

    def duration(self):
        """Return the length as ''m:ss'', e.g. 205 seconds -> ''3:25''."""
        minutes = self.seconds // 60
        secs = self.seconds % 60
        return f"{minutes}:{secs:02}"

track = Song("Bohemian Rhapsody", "Queen", 354)
print(track.duration())
--- test
s = Song("Africa", "Toto", 295)
for attr in ("title", "artist", "seconds"):
    assert hasattr(s, attr), f"Replace the `...` in `__init__`: each Song needs a `{attr}` attribute, stored with `self.{attr} = ...`."
assert (s.title, s.artist, s.seconds) == ("Africa", "Toto", 295), f"The attributes should hold the values passed in, but got title={s.title!r}, artist={s.artist!r}, seconds={s.seconds!r}."
d = s.duration()
assert d is not None and d is not ..., "`duration()` should **return** the ''m:ss'' string. Replace the `...` and make sure you `return` it."
assert isinstance(d, str), f"`duration()` should return a string like ''4:55'', not {type(d).__name__}."
assert d == "4:55", f"Song(''Africa'', ''Toto'', 295).duration() should be ''4:55'', but is {d!r}."
assert Song("Intro", "x", 65).duration() == "1:05", f"65 seconds should be ''1:05'' (seconds always have two digits), but got {Song(''Intro'', ''x'', 65).duration()!r}."
assert Song("Jingle", "x", 9).duration() == "0:09", f"9 seconds should be ''0:09'', but got {Song(''Jingle'', ''x'', 9).duration()!r}."
assert Song("Epic", "x", 600).duration() == "10:00", f"600 seconds should be ''10:00'', but got {Song(''Epic'', ''x'', 600).duration()!r}."
assert "5:54" in _stdout, "Keep the `print(track.duration())` line at the bottom."
--- hint
In `__init__`, each parameter needs to be saved on the object: `self.title = title`, and the same for the other two.
--- hint
Inside `duration`, reach the length with `self.seconds`. Floor division `//` by 60 gives whole minutes; `%` 60 gives the leftover seconds.
--- hint
To always show two digits for the seconds, use a format spec: `f"{secs:02}"` turns `5` into `05`.
```

## Methods that change the object

Methods can do more than read attributes: they can **update** them. This is where classes really shine. The data and the rules for changing it live in one place, so nobody can "forget" a rule.

```python run
class BankAccount:
    def __init__(self, owner, balance=0):
        self.owner = owner
        self.balance = balance

    def deposit(self, amount):
        self.balance += amount
        return self.balance

    def withdraw(self, amount):
        if amount > self.balance:
            raise ValueError(f"Insufficient funds: balance {self.balance}, tried {amount}")
        self.balance -= amount
        return self.balance

acct = BankAccount("Maya", 100)
acct.deposit(50)
acct.withdraw(30)
print(acct.owner, "has", acct.balance)
```

Two details are worth noticing. `__init__` takes a default value (`balance=0`) just like any function from lesson 20. And `withdraw` refuses bad requests by raising a `ValueError`, exactly as you learned in lesson 23. The account protects itself.

## Two objects, two separate sets of attributes

This is the heart of the whole idea. Each instance carries **its own** attributes. Changing one object''s balance never touches another''s, even though they were built from the same blueprint and share the same method code.

```python run
maya = BankAccount("Maya", 100)
leo = BankAccount("Leo")

maya.deposit(25)
leo.deposit(500)

print("Maya:", maya.balance, " Leo:", leo.balance)
print(vars(maya))     # vars() shows the attributes stored on one object
print(vars(leo))
```

`vars(obj)` reveals something lovely: under the hood, each object keeps its attributes in its own little dictionary. Here''s the picture:

```text
  class BankAccount            (one copy of the methods, shared by everyone)
  ├─ __init__(self, owner, balance=0)
  ├─ deposit(self, amount)
  └─ withdraw(self, amount)
          ▲                              ▲
          │ "my class is"                │ "my class is"
  maya ──►┌────────────────────┐  leo ──►┌────────────────────┐
          │ owner:   "Maya"    │         │ owner:   "Leo"     │
          │ balance: 125       │         │ balance: 500       │
          └────────────────────┘         └────────────────────┘
        maya.deposit(25)  →  BankAccount.deposit(maya, 25)  →  only maya''s box changes
```

The methods exist once, on the class. The data exists once **per object**. `self` is the bridge: it tells the shared method which box to read and write.

```python predict id=predict-two-counters title="Two counters"
class ClickCounter:
    def __init__(self):
        self.count = 0

    def click(self):
        self.count += 1

a = ClickCounter()
b = ClickCounter()
a.click()
a.click()
b.click()
print(a.count, b.count)
--- options
* 2 1
3 3
1 1
0 0
--- explain
`a` and `b` each got their own `count` attribute when `__init__` ran. `a.click()` updates `a.count` only, because inside the method `self` is `a`. Two clicks on `a`, one on `b`: `2 1`.
```

```python exercise id=playlist-class title="Build a Playlist class"
class Playlist:
    """A named list of song titles."""

    def __init__(self, name):
        # TODO: store the name, and start self.songs as an empty list
        ...

    def add(self, title):
        """Add a song title to the end of this playlist."""
        # TODO
        ...

    def count(self):
        """Return how many songs are on this playlist."""
        # TODO
        ...

road_trip = Playlist("Road trip")
road_trip.add("Africa")
road_trip.add("Mr. Blue Sky")
print(road_trip.count())    # should print 2
--- solution
class Playlist:
    """A named list of song titles."""

    def __init__(self, name):
        self.name = name
        self.songs = []

    def add(self, title):
        """Add a song title to the end of this playlist."""
        self.songs.append(title)

    def count(self):
        """Return how many songs are on this playlist."""
        return len(self.songs)

road_trip = Playlist("Road trip")
road_trip.add("Africa")
road_trip.add("Mr. Blue Sky")
print(road_trip.count())
--- test
p = Playlist("Gym")
assert hasattr(p, "name"), "Replace the `...` in `__init__`: store the playlist''s name with `self.name = name`."
assert p.name == "Gym", f"`name` should be the value passed in (''Gym''), but is {p.name!r}."
assert hasattr(p, "songs"), "Each Playlist needs a `songs` attribute that starts as an empty list."
assert isinstance(p.songs, list), f"`songs` should be a list, not {type(p.songs).__name__}."
assert p.songs == [], f"A new playlist should start with no songs, but `songs` is {p.songs!r}."
p.add("Eye of the Tiger")
p.add("Stronger")
assert p.songs == ["Eye of the Tiger", "Stronger"], f"After adding two songs, `songs` should be [''Eye of the Tiger'', ''Stronger''], but is {p.songs!r}."
c = p.count()
assert c is not None and c is not ..., "`count()` should **return** the number of songs (use `return`, not `print`)."
assert c == 2, f"`count()` should be 2 after two adds, but is {c!r}."
q = Playlist("Chill")
assert q.songs == [] and q.count() == 0, "A second playlist should start empty. Make sure each Playlist gets its own new list in `__init__`."
q.add("Weightless")
assert p.count() == 2 and q.count() == 1, "Adding to one playlist changed another. Each playlist must have its own `songs` list."
--- hint
In `__init__`, create two attributes: one for the name, and `self.songs = []` so every new playlist gets its own empty list.
--- hint
`add` should append to *this* playlist''s list: `self.songs.append(...)`. `count` can use `len()` on the same list.
--- hint
Both `add` and `count` must go through `self`. A bare `songs` inside a method is a different, local name.
```

## The attribute that vanished

Inside a method, a name **without** `self.` is just an ordinary local variable, gone the moment the method returns. Forgetting `self.` is the single most common class bug. In `__init__` it shows up as a missing attribute:

```python run error
class Player:
    def __init__(self, name):
        self.name = name
        lives = 3            # meant to be self.lives!

hero = Player("Aria")
print(hero.name)
print(hero.lives)
```

Read the last line of the traceback: `''Player'' object has no attribute ''lives''`. Python is telling you the truth. `lives = 3` created a local variable inside `__init__`, and it vanished when `__init__` finished. Nothing was ever stored on the object. The same `AttributeError` appears if you simply misspell an attribute (`hero.live`), so check spelling first, then check for a missing `self.`.

In other methods the same slip is even sneakier, because there''s often no error at all. Track this one down:

```python debug id=score-never-changes title="The score never goes up"
class Player:
    def __init__(self, name):
        self.name = name
        self.score = 0

    def add_points(self, points):
        score = self.score + points

    def report(self):
        return f"{self.name}: {self.score} points"

ana = Player("Ana")
ana.add_points(10)
ana.add_points(25)
print(ana.report())    # should say 35 points
--- solution
class Player:
    def __init__(self, name):
        self.name = name
        self.score = 0

    def add_points(self, points):
        self.score = self.score + points

    def report(self):
        return f"{self.name}: {self.score} points"

ana = Player("Ana")
ana.add_points(10)
ana.add_points(25)
print(ana.report())
--- test
assert ana.score != 0, "Ana''s score is still 0 after scoring 35 points. Where does `add_points` put its result?"
assert ana.score == 35, f"Ana''s score should be 35 (10 + 25), but it is {ana.score!r}."
p = Player("Ben")
p.add_points(7)
p.add_points(3)
p.add_points(5)
assert p.score == 15, f"A fresh player who scores 7, 3 and 5 should have 15 points, but has {p.score!r}."
assert "35 points" in _stdout, "Keep the `print(ana.report())` line so the score is shown."
--- hint
Run it, or use **Debug** and step into `add_points`. Watch the Variables panel: the new total is calculated, but where is it stored?
--- hint
`score = ...` creates a local variable that disappears when the method ends. To change the object, the assignment has to go through `self`.
```

## Class attributes: shared by every instance

Attributes set with `self.something = ...` belong to one object. You can also put a variable directly inside the class body. That''s a **class attribute**: one value, stored on the class, shared by every instance. It''s perfect for settings that apply to all objects, like an interest rate.

```python run
class SavingsAccount:
    interest_rate = 0.02          # class attribute: shared by all accounts

    def __init__(self, owner, balance):
        self.owner = owner        # instance attributes: one per account
        self.balance = balance

    def add_interest(self):
        self.balance += self.balance * self.interest_rate
        return round(self.balance, 2)

maya = SavingsAccount("Maya", 1000)
leo = SavingsAccount("Leo", 250)
print("Maya''s rate:", maya.interest_rate, " Leo''s rate:", leo.interest_rate)

SavingsAccount.interest_rate = 0.03     # the bank changes the rate for everyone
print("after the change:", maya.add_interest(), leo.add_interest())
```

How does `maya.interest_rate` work when `maya` has no such attribute in her own box? Python looks things up in a fixed order:

```text
maya.interest_rate
   1. Look in maya''s own attributes  {owner: "Maya", balance: 1000}   → not there
   2. Look in her class, SavingsAccount  {interest_rate: 0.03, ...}   → found it!
```

That lookup order explains a surprising consequence. *Reading* through an instance falls back to the class, but *assigning* through an instance always writes into that instance''s own box, creating a new attribute that hides the class one:

```python predict id=predict-class-attr-shadow title="Who gets the new rate?"
class Account:
    rate = 0.02

a = Account()
b = Account()
a.rate = 0.05
print(a.rate, b.rate, Account.rate)
--- options
0.05 0.05 0.05
* 0.05 0.02 0.02
0.05 0.05 0.02
0.02 0.02 0.02
--- explain
`a.rate = 0.05` stores a **new instance attribute** on `a` only. When you read `a.rate`, Python finds it in `a`''s own box first. `b` has no `rate` of its own, so `b.rate` falls back to the class, which still says `0.02`. To change the value for everyone, assign to `Account.rate`.
```

> **Pitfall:** A class attribute that is a **list or dict** is shared by every instance, and methods like `.append()` change that one shared object, not a per-instance copy. Look:

```python run
class Dog:
    tricks = []                    # one list for ALL dogs!

    def __init__(self, name):
        self.name = name

    def learn(self, trick):
        self.tricks.append(trick)

rex = Dog("Rex")
fido = Dog("Fido")
rex.learn("sit")
fido.learn("roll over")
print("Rex knows:", rex.tricks)
print("rex.tricks is fido.tricks:", rex.tricks is fido.tricks)
```

`self.tricks.append(...)` doesn''t assign anything; it *reads* `self.tricks` (which falls back to the class''s one list) and then changes that list. The rule of thumb: **numbers, strings and settings can be class attributes; anything each object should own, especially lists and dicts, gets created in `__init__` with `self.`.** It''s the same "one list, two names" aliasing you met in lesson 14, and the same trap as the mutable default argument from lesson 20.

```python exercise id=game-character title="A game character with health"
class Character:
    max_health = 100   # class attribute: the cap for every character

    def __init__(self, name):
        # TODO: store the name, and start self.health at the class''s max_health
        ...

    def take_damage(self, amount):
        """Lose `amount` health, but never drop below 0."""
        # TODO
        ...

    def heal(self, amount):
        """Gain `amount` health, but never go above max_health."""
        # TODO
        ...

    def is_alive(self):
        """Return True if health is above 0, otherwise False."""
        # TODO
        ...

hero = Character("Aria")
hero.take_damage(30)
hero.heal(10)
print(hero.is_alive())
--- solution
class Character:
    max_health = 100

    def __init__(self, name):
        self.name = name
        self.health = self.max_health

    def take_damage(self, amount):
        """Lose `amount` health, but never drop below 0."""
        self.health = max(0, self.health - amount)

    def heal(self, amount):
        """Gain `amount` health, but never go above max_health."""
        self.health = min(self.max_health, self.health + amount)

    def is_alive(self):
        """Return True if health is above 0, otherwise False."""
        return self.health > 0

hero = Character("Aria")
hero.take_damage(30)
hero.heal(10)
print(hero.is_alive())
--- test
c = Character("Tester")
assert hasattr(c, "name") and hasattr(c, "health"), "Replace the `...` in `__init__`: each character needs `name` and `health` attributes."
assert c.name == "Tester", f"`name` should be the value passed in, but is {c.name!r}."
assert c.health == 100, f"A new character should start at max_health (100), but has {c.health!r} health."
assert Character.max_health == 100, "Leave the class attribute `max_health = 100` as it is."
c.take_damage(30)
assert c.health == 70, f"After 30 damage, health should be 70, but is {c.health!r}."
c.heal(10)
assert c.health == 80, f"After healing 10, health should be 80, but is {c.health!r}."
c.heal(500)
assert c.health == 100, f"Healing can''t go above max_health: expected 100, got {c.health!r}."
alive = c.is_alive()
assert alive is True, f"`is_alive()` should return True for a character with {c.health} health, but returned {alive!r}."
c.take_damage(250)
assert c.health == 0, f"Health should never drop below 0, but is {c.health!r} after a huge hit."
assert c.is_alive() is False, f"`is_alive()` should return False at 0 health, but returned {c.is_alive()!r}."
other = Character("Other")
assert other.health == 100, "Damaging one character changed another. Each character needs its own `health`."
Character.max_health = 150
try:
    tank = Character("Tank")
    assert tank.health == 150, "When `Character.max_health` changes to 150, new characters should start at 150. Use the class attribute instead of typing 100."
    tank.take_damage(20)
    tank.heal(100)
    assert tank.health == 150, f"With max_health 150, healing should cap at 150, but health is {tank.health!r}. Use `self.max_health` in `heal` instead of 100."
finally:
    Character.max_health = 100
--- hint
In `__init__`, start health from the class attribute: `self.health = self.max_health` (reading through `self` falls back to the class).
--- hint
To clamp a value, `max(0, x)` never goes below 0 and `min(cap, x)` never goes above `cap`.
--- hint
`is_alive` should `return` a comparison such as `self.health > 0`, which is already `True` or `False`.
```

```python debug id=shared-cart title="Every customer sees the same cart"
class ShoppingCart:
    items = []                  # every cart starts empty

    def __init__(self, customer):
        self.customer = customer

    def add(self, item):
        self.items.append(item)

    def size(self):
        return len(self.items)

ana = ShoppingCart("Ana")
ben = ShoppingCart("Ben")
ana.add("apples")
ana.add("bread")
ben.add("coffee")

print("Ana''s cart:", ana.items)
print("Ben''s cart:", ben.items)
--- solution
class ShoppingCart:
    def __init__(self, customer):
        self.customer = customer
        self.items = []         # every cart starts empty

    def add(self, item):
        self.items.append(item)

    def size(self):
        return len(self.items)

ana = ShoppingCart("Ana")
ben = ShoppingCart("Ben")
ana.add("apples")
ana.add("bread")
ben.add("coffee")

print("Ana''s cart:", ana.items)
print("Ben''s cart:", ben.items)
--- test
assert ana.items is not ben.items, "Ana and Ben are still sharing one list. Each cart needs its own `items` list."
assert ana.items == ["apples", "bread"], f"Ana''s cart should be [''apples'', ''bread''], but is {ana.items!r}."
assert ben.items == ["coffee"], f"Ben''s cart should be [''coffee''], but is {ben.items!r}."
c1 = ShoppingCart("Cleo")
c2 = ShoppingCart("Dev")
assert c1.items == [] and c2.items == [], f"A brand-new cart should be empty, but a new cart has {c1.items!r}."
c1.add("tea")
assert c2.size() == 0 and c1.size() == 1, "Adding to one new cart changed another cart."
--- hint
Run it: Ben''s cart contains Ana''s groceries. How many `items` lists exist in this program? Check with `ana.items is ben.items`.
--- hint
`items = []` in the class body is a class attribute: one list shared by every cart. Where should a list that belongs to *one* cart be created?
```

## When should you write a class?

You could model a bank account with a dict and a few functions, and for tiny scripts that''s fine. A class earns its place when data and the rules for changing it belong together:

| Use… | When… | Example |
|---|---|---|
| plain values, lists, dicts | you''re just holding data | a list of temperatures, a settings dict |
| functions | you''re transforming data in one step | `average(scores)` |
| a **class** | several pieces of data travel together **and** have behaviour or rules | an account that refuses overdrafts, a character that can''t heal past full |

A good sign you need a class: you keep passing the same dict to five different functions, each of which pokes at its keys. Moving those functions into a class as methods gives the data a home and gives each rule one obvious place to live.

> **In the wild:** Almost every library you''ll use is built from classes. In Django, each database table is a class (`class Order(models.Model)`), and each row you load is an instance. A pandas `DataFrame` is a class, and `df.head()` is a method call with `df` as `self`. Even `datetime.date(2026, 3, 14)` from lesson 25 builds an instance with attributes `.year`, `.month` and `.day`.

## Recap

- A **class** is a blueprint; calling it (`Pet("Rex", "dog", 3)`) builds an **instance**, a separate object with its own data.
- `__init__` runs automatically on every new instance. Use it to create every attribute with `self.name = value`.
- `self` is "this particular object": `rex.describe()` is really `Pet.describe(rex)`. Every method takes `self` first.
- Inside methods, always reach attributes through `self.`; a bare name is a local variable that vanishes when the method ends.
- Methods live once on the class; attributes live separately on each instance, so changing one object never affects another.
- **Class attributes** are shared by all instances: good for settings like `interest_rate`, dangerous for lists and dicts, which belong in `__init__`.

**Up next:** special methods, properties and inheritance: make your objects print nicely, compare with `==`, validate their own data, and build new classes on top of old ones.
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z'),
('les_python_basics_7_2', 'sec_python_basics_7', 'crs_python_basics', 'Special methods, properties and inheritance', 'interactive', 1, 1200, NULL, NULL, 'Your classes from the last lesson work, but they still feel like second-class citizens. Print one and you get `<__main__.Book object at 0x7f3a...>`. Compare two identical ones with `==` and Python says `False`. Try to `sorted()` a list of them and you get an error. Built-in types like `str` and `list` do all of this effortlessly. What do they know that your classes don''t?

The answer is **special methods**: hooks with double-underscore names that let your objects plug into Python''s own syntax: `print`, `==`, `<`, `len()`. In this lesson you''ll add those hooks, use **properties** to compute values and reject bad data, build new classes on top of existing ones with **inheritance**, and finish with `@dataclass`, the shortcut professionals use to skip the boilerplate entirely.

## Special methods: Python''s hooks

You already met one special method: `__init__`, which Python calls for you when an object is built. There are dozens more, and they all follow the same idea. When you write ordinary Python syntax, Python quietly translates it into a method call:

```python run
word = "banana"
print(len(word), word.__len__())             # len(x)  →  x.__len__()
print(3 + 4, (3).__add__(4))                 # a + b   →  a.__add__(b)
print(word == "banana", word.__eq__("banana"))  # a == b  →  a.__eq__(b)
```

That''s the whole trick. `len()` works on strings because `str` defines `__len__`. If *your* class defines `__len__`, `len()` will work on your objects too. Python programmers call these **dunder methods** (for **d**ouble **under**score).

> **Tip:** You define dunder methods, but you almost never call them directly. Write `len(playlist)`, not `playlist.__len__()`. Python does the translating.

Here''s what a plain class gives you before you add any hooks:

```python run
class Book:
    def __init__(self, title, author, pages):
        self.title = title
        self.author = author
        self.pages = pages

book = Book("Dune", "Frank Herbert", 412)
print(book)
print(book == Book("Dune", "Frank Herbert", 412))
```

The default printout shows the class name and a memory address (yours will differ from anyone else''s). Correct, and almost useless. And `==` says `False` because, without instructions, Python only considers an object equal to *itself*. Let''s fix both.

## `__str__` and `__repr__`: how your object looks

Python has two ways of turning an object into text, for two different audiences:

| | `__str__` | `__repr__` |
|---|---|---|
| Audience | the **user** of your program | the **developer** (you!) |
| Goal | friendly and readable | unambiguous, ideally looks like code that rebuilds the object |
| Used by | `print(obj)`, `str(obj)`, f-strings | the value display at the end of a cell, the debugger, objects **inside lists and dicts**, `repr(obj)` |
| Example | `Dune by Frank Herbert` | `Book(''Dune'', ''Frank Herbert'', 412)` |

Both must **return** a string.

```python run
class Book:
    def __init__(self, title, author, pages):
        self.title = title
        self.author = author
        self.pages = pages

    def __str__(self):
        return f"{self.title} by {self.author}"

    def __repr__(self):
        return f"Book({self.title!r}, {self.author!r}, {self.pages})"

book = Book("Dune", "Frank Herbert", 412)
print(book)
print(f"Now reading: {book}")
print([book, Book("Emma", "Jane Austen", 474)])
book
```

Inside an f-string, `!r` inserts the *repr* of a value, so strings come out with their quotes: `''Dune''` instead of `Dune`. That''s what makes the repr look like real code.

Notice the list: a list prints its items using their `__repr__`, not their `__str__`. If you only write one of the two, write `__repr__`: Python falls back to it when `__str__` is missing, but not the other way around.

```python predict id=predict-str-repr-list title="str or repr?"
class Card:
    def __init__(self, rank, suit):
        self.rank = rank
        self.suit = suit

    def __str__(self):
        return f"{self.rank} of {self.suit}"

    def __repr__(self):
        return f"Card({self.rank!r}, {self.suit!r})"

card = Card("A", "spades")
print(card, [card])
--- options
A of spades [A of spades]
* A of spades [Card(''A'', ''spades'')]
Card(''A'', ''spades'') [Card(''A'', ''spades'')]
A of spades [''A of spades'']
--- explain
`print(card)` uses `__str__`, giving the friendly `A of spades`. But a list always shows its contents with `__repr__`, so the card inside `[card]` appears as `Card(''A'', ''spades'')`. That''s deliberate: inside a container, an unambiguous view matters more than a pretty one.
```

```python exercise id=product-str-repr title="Make products print nicely"
class Product:
    def __init__(self, name, price):
        self.name = name
        self.price = price

    def __str__(self):
        # TODO: return a friendly string like ''Coffee beans: $12.50''
        # (always two decimal places)
        return "..."

    def __repr__(self):
        # TODO: return a developer string like "Product(''Coffee beans'', 12.5)"
        return "..."

item = Product("Coffee beans", 12.5)
print(item)
print([item])
--- solution
class Product:
    def __init__(self, name, price):
        self.name = name
        self.price = price

    def __str__(self):
        return f"{self.name}: ${self.price:.2f}"

    def __repr__(self):
        return f"Product({self.name!r}, {self.price!r})"

item = Product("Coffee beans", 12.5)
print(item)
print([item])
--- test
p = Product("Green tea", 4.5)
s, r = p.__str__(), p.__repr__()
assert s != "...", "Replace the `\"...\"` in `__str__` with an f-string built from `self.name` and `self.price`."
assert r != "...", "Replace the `\"...\"` in `__repr__` with an f-string that looks like `Product(''Green tea'', 4.5)`."
assert isinstance(s, str) and isinstance(r, str), "Both methods must **return** a string."
assert s == "Green tea: $4.50", f"str(Product(''Green tea'', 4.5)) should be ''Green tea: $4.50'', but is {s!r}."
assert str(Product("Bagel", 3)) == "Bagel: $3.00", f"The price should always show two decimals: expected ''Bagel: $3.00'', got {str(Product(''Bagel'', 3))!r}."
assert r == "Product(''Green tea'', 4.5)", f"repr(Product(''Green tea'', 4.5)) should be \"Product(''Green tea'', 4.5)\", but is {r!r}. Did you use !r for the name so it gets quotes?"
assert repr(Product("Oat milk", 2.99)) == "Product(''Oat milk'', 2.99)", f"repr should work for any product, but got {repr(Product(''Oat milk'', 2.99))!r}."
assert "Coffee beans: $12.50" in _stdout, "Keep the `print(item)` line."
--- hint
Both methods must `return` an f-string. For the price, the format spec `:.2f` from lesson 6 gives exactly two decimals.
--- hint
In `__repr__`, `{self.name!r}` puts quotes around the name automatically. The price can go in as is.
```

Here''s the classic `__str__` mistake. The symptom is an error that sounds confusing until you know the rule:

```python debug id=ticket-str-prints title="Printing a ticket crashes"
class Ticket:
    def __init__(self, event, seat, price):
        self.event = event
        self.seat = seat
        self.price = price

    def __str__(self):
        print(f"{self.event} | seat {self.seat} | ${self.price:.2f}")

ticket = Ticket("Jazz Night", "B12", 45)
print(ticket)
--- solution
class Ticket:
    def __init__(self, event, seat, price):
        self.event = event
        self.seat = seat
        self.price = price

    def __str__(self):
        return f"{self.event} | seat {self.seat} | ${self.price:.2f}"

ticket = Ticket("Jazz Night", "B12", 45)
print(ticket)
--- test
assert str(ticket) == "Jazz Night | seat B12 | $45.00", f"str(ticket) should be ''Jazz Night | seat B12 | $45.00'', but is {str(ticket)!r}."
other = Ticket("Comedy Club", "A1", 19.5)
assert str(other) == "Comedy Club | seat A1 | $19.50", f"A different ticket should print as ''Comedy Club | seat A1 | $19.50'', but got {str(other)!r}."
assert _stdout.count("Jazz Night") == 1, "The ticket text should be printed exactly once, by `print(ticket)`. `__str__` itself shouldn''t print anything."
--- hint
Run it. The ticket text does appear, and *then* Python complains: `__str__ returned non-string (type NoneType)`. What does a function give back when it never says `return`?
--- hint
`print(ticket)` asks `__str__` for a string and prints it itself. `__str__` should hand the string back, not print it.
```

## `__eq__`, `__lt__` and `__len__`: comparing and measuring

By default, `a == b` on your objects means "are these the very same object?", the same as `a is b`. Usually that''s not what you want: two `Point(1, 2)` objects should count as equal. Define `__eq__` to say what "equal" means for your type:

```python run
class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __eq__(self, other):
        if not isinstance(other, Point):
            return False
        return self.x == other.x and self.y == other.y

    def __repr__(self):
        return f"Point({self.x}, {self.y})"

a = Point(1, 2)
b = Point(1, 2)
print("a == b:", a == b, "  a is b:", a is b)
print("a == ''hello'':", a == "hello")
print("in the list?", Point(1, 2) in [Point(0, 0), b])
```

`in` uses `==` behind the scenes, so once `__eq__` exists, membership checks work too. The `isinstance` guard from lesson 22 keeps comparisons with other types from crashing on a missing `.x`.

> **Under the hood:** Experienced Python developers often write `return NotImplemented` instead of `return False` in that guard. It tells Python "I don''t know how to compare with this; ask the other object". For your own code at this stage, `False` is perfectly fine.

```python predict id=predict-default-eq title="Same coin?"
class Coin:
    def __init__(self, value):
        self.value = value

a = Coin(25)
b = Coin(25)
print(a == b, a.value == b.value)
--- options
True True
* False True
False False
True False
--- explain
`Coin` has no `__eq__`, so `a == b` falls back to identity: are `a` and `b` the **same object**? They''re two separate objects built by two separate calls, so the answer is `False`, even though their data matches. Comparing the attributes directly compares two ints, which are equal. Defining `__eq__` would make `a == b` mean what you expect.
```

`__len__` lets `len()` work on your object, and `__lt__` ("less than") defines `<`. Once `<` works, `sorted()`, `min()` and `max()` work too, because they only need to ask "is this one smaller than that one?":

```python run
class Playlist:
    def __init__(self, name, songs):
        self.name = name
        self.songs = list(songs)

    def __len__(self):
        return len(self.songs)

    def __lt__(self, other):
        return len(self) < len(other)

    def __repr__(self):
        return f"Playlist({self.name!r}, {len(self)} songs)"

gym = Playlist("Gym", ["Stronger", "Lose Yourself", "Eye of the Tiger"])
chill = Playlist("Chill", ["Weightless"])
party = Playlist("Party", ["Uptown Funk", "Shut Up and Dance"])

print("len(gym):", len(gym), "  chill < gym:", chill < gym)
sorted([gym, chill, party])
```

| You write | Python calls | Define it to… |
|---|---|---|
| `Thing(...)` | `__init__` | set up a new object''s attributes |
| `print(x)`, `str(x)`, `f"{x}"` | `__str__` | give users a friendly description |
| `repr(x)`, `[x]`, the debugger | `__repr__` | give developers an exact description |
| `x == y` | `__eq__` | decide when two objects count as equal |
| `x < y`, `sorted(...)` | `__lt__` | define a natural order |
| `len(x)` | `__len__` | report a size |

There are many more (`__add__` for `+`, `__contains__` for `in`, `__getitem__` for `x[i]`), all working the same way. You now know the pattern for every one of them.

```python exercise id=sortable-runners title="Sort the race results"
class Runner:
    def __init__(self, name, minutes):
        self.name = name
        self.minutes = minutes

    def __repr__(self):
        return f"Runner({self.name!r}, {self.minutes})"

    def __lt__(self, other):
        """A runner is ''less than'' another if they finished faster."""
        # TODO: return True or False by comparing the two runners'' minutes
        ...

    def __eq__(self, other):
        """Two runners are equal if they have the same name AND the same time."""
        # TODO
        ...

results = [Runner("Kim", 42.5), Runner("Ola", 39.8), Runner("Sam", 45.1), Runner("Ida", 40.2)]

# TODO: the 3 fastest runners, fastest first. Use sorted() on `results`.
podium = ...
print(podium)
--- solution
class Runner:
    def __init__(self, name, minutes):
        self.name = name
        self.minutes = minutes

    def __repr__(self):
        return f"Runner({self.name!r}, {self.minutes})"

    def __lt__(self, other):
        """A runner is ''less than'' another if they finished faster."""
        return self.minutes < other.minutes

    def __eq__(self, other):
        """Two runners are equal if they have the same name AND the same time."""
        return self.name == other.name and self.minutes == other.minutes

results = [Runner("Kim", 42.5), Runner("Ola", 39.8), Runner("Sam", 45.1), Runner("Ida", 40.2)]

podium = sorted(results)[:3]
print(podium)
--- test
fast, slow = Runner("Fast", 30.0), Runner("Slow", 35.0)
lt = fast.__lt__(slow)
assert lt is not None and lt is not ..., "Replace the `...` in `__lt__`: it should return True when `self` finished faster than `other`."
assert (fast < slow) is True and (slow < fast) is False, f"`Runner(''Fast'', 30.0) < Runner(''Slow'', 35.0)` should be True and the reverse False, but got {fast < slow!r} and {slow < fast!r}."
eq = Runner("Kim", 42.5).__eq__(Runner("Kim", 42.5))
assert eq is not None and eq is not ..., "Replace the `...` in `__eq__`: it should return True or False."
assert Runner("Kim", 42.5) == Runner("Kim", 42.5), "Two runners with the same name and time should be equal."
assert Runner("Kim", 42.5) != Runner("Ola", 42.5), "Runners with different names should not be equal, even with the same time."
assert Runner("Kim", 42.5) != Runner("Kim", 50.0), "The same runner with a different time should not be equal."
assert podium is not ..., "Replace the `...` after `podium =` using `sorted(results)`."
assert isinstance(podium, list), f"`podium` should be a list, not {type(podium).__name__}."
names = [r.name for r in podium]
assert names == ["Ola", "Ida", "Kim"], f"The podium should be Ola, Ida, Kim (fastest first), but is {names}."
fresh = sorted([Runner("a", 5), Runner("b", 3), Runner("c", 4)])
assert [r.name for r in fresh] == ["b", "c", "a"], "sorted() should order any list of runners by time once `__lt__` works."
--- hint
`__lt__` gets two runners: `self` and `other`. Return the result of comparing their `minutes` with `<`.
--- hint
`__eq__` should return a combined comparison: the names match **and** the minutes match.
--- hint
With `__lt__` in place, `sorted(results)` puts the fastest first. A slice `[:3]` keeps the top three.
```

## Properties: attributes that compute or protect

Sometimes a value should be *calculated* from other attributes, not stored. A rectangle''s area depends on its width and height; if you stored it separately, it would go stale the moment the width changed. A **property** is a method that you read like an attribute, without parentheses:

```python run
class Rectangle:
    def __init__(self, width, height):
        self.width = width
        self.height = height

    @property
    def area(self):
        return self.width * self.height

room = Rectangle(4, 3)
print("area:", room.area)          # no parentheses!
room.width = 5
print("after widening:", room.area)
```

The `@property` line above the method is a **decorator**: a label that changes how the function below it behaves. Here it turns `area` from "a method you call" into "an attribute you read", which is computed fresh each time. (You''ll learn to write your own decorators in Python Advanced.)

Because `area` is now a value, not a method, adding parentheses is a mistake. Python first computes `room.area` (getting `20`), then tries to call `20()`:

```python run error
room.area()
```

"`''int'' object is not callable`" is Python''s way of saying "you put `()` after something that isn''t a function". With properties, drop the parentheses.

Properties have a second superpower: **validation**. You can attach a *setter* that runs every time someone assigns to the attribute, and reject bad values before they ever get stored:

```python run
class BankAccount:
    def __init__(self, owner, balance=0):
        self.owner = owner
        self.balance = balance          # this assignment goes through the setter below

    @property
    def balance(self):
        return self._balance

    @balance.setter
    def balance(self, value):
        if value < 0:
            raise ValueError(f"balance can''t be negative (got {value})")
        self._balance = value

acct = BankAccount("Maya", 100)
acct.balance = 80
print("balance:", acct.balance)
try:
    acct.balance = -500
except ValueError as e:
    print("Rejected:", e)
print("still:", acct.balance)
```

The real number lives in `self._balance`. The leading underscore is a Python convention meaning "internal: don''t touch this directly from outside the class". Everyone else goes through `acct.balance`, so every read and every write passes through your code. Even `__init__` uses the setter, so you can''t *create* an account with a negative balance either.

> **Coming from another language:** Java and C# programmers often write `getBalance()`/`setBalance()` for every field. In Python you start with plain attributes, and only turn one into a property when you need computation or validation. Code that uses `acct.balance` doesn''t have to change at all.

```python exercise id=temperature-property title="A thermometer that knows physics"
class Temperature:
    def __init__(self, celsius):
        self.celsius = celsius            # goes through the setter below

    @property
    def celsius(self):
        return self._celsius

    @celsius.setter
    def celsius(self, value):
        # TODO: raise a ValueError if value is below -273.15 (absolute zero).
        # Otherwise, store it in self._celsius.
        ...

    @property
    def fahrenheit(self):
        """The same temperature in Fahrenheit: C * 9 / 5 + 32."""
        # TODO
        ...

today = Temperature(21)
print(today.fahrenheit)       # should print 69.8
--- solution
class Temperature:
    def __init__(self, celsius):
        self.celsius = celsius

    @property
    def celsius(self):
        return self._celsius

    @celsius.setter
    def celsius(self, value):
        if value < -273.15:
            raise ValueError(f"{value} is below absolute zero")
        self._celsius = value

    @property
    def fahrenheit(self):
        """The same temperature in Fahrenheit: C * 9 / 5 + 32."""
        return self.celsius * 9 / 5 + 32

today = Temperature(21)
print(today.fahrenheit)
--- test
t = Temperature(100)
assert hasattr(t, "_celsius"), "Replace the `...` in the `celsius` setter: store the value with `self._celsius = value`."
assert t.celsius == 100, f"Temperature(100).celsius should be 100, but is {t.celsius!r}."
f = t.fahrenheit
assert f is not None and f is not ..., "Replace the `...` in `fahrenheit`: it should **return** the converted temperature."
assert isinstance(f, (int, float)), f"`fahrenheit` should be a number you read without parentheses (keep `@property`), but it is {type(f).__name__}."
assert abs(f - 212) < 1e-9, f"100 °C should be 212 °F, but `fahrenheit` gave {f!r}."
assert abs(Temperature(-40).fahrenheit - (-40)) < 1e-9, "-40 °C should be -40 °F."
t.celsius = 37
assert abs(t.fahrenheit - 98.6) < 1e-9, f"After setting celsius to 37, fahrenheit should be 98.6, but is {t.fahrenheit!r}. Compute it from `self.celsius` each time."
Temperature(-273.15)
try:
    Temperature(-300)
    raised = False
except ValueError:
    raised = True
assert raised, "Temperature(-300) should raise a ValueError: nothing is colder than -273.15 °C."
try:
    t.celsius = -500
except ValueError:
    pass
else:
    assert False, "Setting `t.celsius = -500` should raise a ValueError too (the setter runs on every assignment)."
assert t.celsius == 37, f"A rejected value must not be stored: celsius should still be 37, but is {t.celsius!r}."
--- hint
In the setter, check the value first with an `if`. If it''s too cold, `raise ValueError("...")`; only after that check, store it.
--- hint
`fahrenheit` is computed fresh every time it''s read, from `self.celsius`. Don''t store it anywhere.
--- hint
The formula is `self.celsius * 9 / 5 + 32`. Make sure the method `return`s it.
```

## Inheritance: building on an existing class

A savings account *is* an account: it has an owner and a balance, it takes deposits. It just adds interest on top. Rather than copy all of `Account`''s code, you can say "a `SavingsAccount` is a kind of `Account`" and only write what''s new. That''s **inheritance**:

```python run
class Account:
    def __init__(self, owner, balance=0):
        self.owner = owner
        self.balance = balance

    def deposit(self, amount):
        self.balance += amount

    def withdraw(self, amount):
        self.balance -= amount

    def __str__(self):
        return f"{self.owner}: ${self.balance:,.2f}"

class SavingsAccount(Account):                     # "is a kind of Account"
    def __init__(self, owner, balance=0, rate=0.02):
        super().__init__(owner, balance)           # let Account set up owner and balance
        self.rate = rate                           # then add what''s new

    def add_interest(self):
        self.deposit(self.balance * self.rate)

nest_egg = SavingsAccount("Maya", 1000, rate=0.05)
nest_egg.deposit(200)          # inherited from Account
nest_egg.add_interest()        # SavingsAccount''s own method
print(nest_egg)                # Account''s __str__
print(isinstance(nest_egg, SavingsAccount), isinstance(nest_egg, Account))
```

`Account` is the **parent** (or *base*) class and `SavingsAccount` is the **child** (or *subclass*). `super()` means "my parent class", so `super().__init__(owner, balance)` runs `Account`''s setup on this new object before the child adds its own `rate`. And because a savings account *is* an account, `isinstance` says `True` for both.

When you call a method, Python searches upward until it finds it:

```text
nest_egg.deposit(200)
   1. nest_egg''s own attributes      {owner, balance, rate}           → no
   2. class SavingsAccount           {__init__, add_interest}         → no
   3. class Account (the parent)     {__init__, deposit, withdraw...} → found it!
```

A child can also **override** a parent''s method by defining one with the same name. Python finds the child''s version first. Inside it, `super().method(...)` still reaches the parent''s version, so you can extend behaviour instead of rewriting it:

```python run
class CheckingAccount(Account):
    fee = 1.50                                     # class attribute

    def withdraw(self, amount):                    # overrides Account.withdraw
        super().withdraw(amount + self.fee)        # reuse the parent, add the fee

spending = CheckingAccount("Leo", 100)
spending.withdraw(20)
print(spending)
```

```python predict id=predict-inheritance-chain title="Which speak() runs?"
class Animal:
    def speak(self):
        return "..."

class Dog(Animal):
    def speak(self):
        return "Woof"

class Puppy(Dog):
    pass

p = Puppy()
print(p.speak(), isinstance(p, Animal))
--- options
... True
* Woof True
Woof False
... False
--- explain
`Puppy` defines nothing, so Python searches upward: `Puppy` → `Dog`, where it finds `speak` and returns `"Woof"`. The search stops at the first match, so `Animal`''s version never runs. And a `Puppy` is a `Dog`, which is an `Animal`, so `isinstance(p, Animal)` is `True`.
```

```python debug id=savings-no-balance title="The savings account has no balance"
class Account:
    def __init__(self, owner, balance=0):
        self.owner = owner
        self.balance = balance

    def deposit(self, amount):
        self.balance += amount

class SavingsAccount(Account):
    def __init__(self, owner, balance=0, rate=0.02):
        self.rate = rate

    def add_interest(self):
        self.balance += self.balance * self.rate

college_fund = SavingsAccount("Priya", 2000, rate=0.05)
college_fund.add_interest()
print(college_fund.owner, college_fund.balance)    # should be Priya 2100.0
--- solution
class Account:
    def __init__(self, owner, balance=0):
        self.owner = owner
        self.balance = balance

    def deposit(self, amount):
        self.balance += amount

class SavingsAccount(Account):
    def __init__(self, owner, balance=0, rate=0.02):
        super().__init__(owner, balance)
        self.rate = rate

    def add_interest(self):
        self.balance += self.balance * self.rate

college_fund = SavingsAccount("Priya", 2000, rate=0.05)
college_fund.add_interest()
print(college_fund.owner, college_fund.balance)
--- test
assert college_fund.owner == "Priya", f"`college_fund.owner` should be ''Priya'', but is {college_fund.owner!r}."
assert abs(college_fund.balance - 2100) < 1e-9, f"After 5% interest on 2000, the balance should be 2100.0, but is {college_fund.balance!r}."
assert college_fund.rate == 0.05, "Keep storing the interest rate in `self.rate`."
s = SavingsAccount("Tom", 100)
assert s.balance == 100 and s.rate == 0.02, "A new SavingsAccount(''Tom'', 100) should have balance 100 and the default rate 0.02."
s.deposit(50)
assert s.balance == 150, "The inherited `deposit` method should still work."
assert isinstance(s, Account), "SavingsAccount should still inherit from Account."
--- hint
Run it and read the last line of the error: the object has no `balance`. Which `__init__` is supposed to create `owner` and `balance`? Did it ever run?
--- hint
When a child defines its own `__init__`, the parent''s `__init__` no longer runs automatically. Call it yourself, first thing, with `super()`.
```

```python exercise id=manager-pay title="Managers get a bonus"
class Employee:
    def __init__(self, name, salary):
        self.name = name
        self.salary = salary

    def pay(self):
        """Monthly pay: yearly salary / 12, rounded to cents."""
        return round(self.salary / 12, 2)

class Manager(Employee):
    def __init__(self, name, salary, bonus):
        # TODO: let Employee set up name and salary, then store the bonus
        ...

    def pay(self):
        """A manager''s monthly pay is an employee''s monthly pay plus the bonus."""
        # TODO: reuse Employee''s pay() via super(), then add self.bonus
        ...

staff = [Employee("Ana", 48000), Manager("Raj", 72000, 500)]
for person in staff:
    print(person.pay())          # should print 4000.0 then 6500.0
--- solution
class Employee:
    def __init__(self, name, salary):
        self.name = name
        self.salary = salary

    def pay(self):
        """Monthly pay: yearly salary / 12, rounded to cents."""
        return round(self.salary / 12, 2)

class Manager(Employee):
    def __init__(self, name, salary, bonus):
        super().__init__(name, salary)
        self.bonus = bonus

    def pay(self):
        """A manager''s monthly pay is an employee''s monthly pay plus the bonus."""
        return super().pay() + self.bonus

staff = [Employee("Ana", 48000), Manager("Raj", 72000, 500)]
for person in staff:
    print(person.pay())
--- test
m = Manager("Zoe", 60000, 300)
assert hasattr(m, "name") and hasattr(m, "salary"), "Replace the `...` in `Manager.__init__`: call `super().__init__(...)` so the manager gets a `name` and `salary`."
assert hasattr(m, "bonus"), "Each Manager also needs a `bonus` attribute."
assert (m.name, m.salary, m.bonus) == ("Zoe", 60000, 300), f"Expected name=''Zoe'', salary=60000, bonus=300, but got {m.name!r}, {m.salary!r}, {m.bonus!r}."
p = m.pay()
assert p is not None and p is not ..., "`Manager.pay()` should **return** the monthly pay plus the bonus."
assert abs(p - 5300) < 1e-9, f"Manager(''Zoe'', 60000, 300).pay() should be 5300.0 (5000 + 300), but is {p!r}."
assert isinstance(m, Employee), "Manager should still inherit from Employee."
original_pay = Employee.pay
Employee.pay = lambda self: 1000
try:
    reused = Manager("Lee", 12000, 50).pay()
finally:
    Employee.pay = original_pay
assert reused == 1050, "`Manager.pay()` should build on Employee''s version with `super().pay()` instead of repeating the salary formula."
--- hint
In `__init__`, the first line should hand `name` and `salary` to the parent: `super().__init__(name, salary)`. Then store the bonus on `self`.
--- hint
In `pay`, `super().pay()` gives you the normal employee pay. Add the bonus and `return` the result.
```

## Composition: "has a" instead of "is a"

Inheritance is powerful, but beginners tend to overuse it. Before writing `class B(A)`, say the sentence out loud: **"a B *is an* A"**. A savings account *is an* account: inheritance fits. A playlist *is a* song? No. A playlist **has** songs. When the relationship is "has a", store the other objects as attributes instead. That''s **composition**:

```python run
class Song:
    def __init__(self, title, seconds):
        self.title = title
        self.seconds = seconds

class Playlist:
    def __init__(self, name):
        self.name = name
        self.songs = []                     # a Playlist HAS Songs

    def add(self, song):
        self.songs.append(song)

    def total_minutes(self):
        return round(sum(song.seconds for song in self.songs) / 60, 1)

road_trip = Playlist("Road trip")
road_trip.add(Song("Africa", 295))
road_trip.add(Song("Mr. Blue Sky", 303))
print(road_trip.name, "lasts", road_trip.total_minutes(), "minutes")
```

| Relationship | Sentence | Tool | Examples |
|---|---|---|---|
| **is a** | "a savings account *is an* account" | inheritance: `class SavingsAccount(Account)` | `Dog(Animal)`, `Manager(Employee)` |
| **has a** | "a playlist *has* songs" | composition: an attribute holding other objects | `Playlist` has `Song`s, `Car` has an `Engine`, `Order` has `Product`s |

> **Tip:** When in doubt, prefer composition. It keeps classes small and independent, and you can swap parts easily. Deep inheritance chains (`A` → `B` → `C` → `D`) are hard to follow because behaviour is spread across many classes.

## `@dataclass`: the professional shortcut

Look back at all the classes in this lesson. Most `__init__` methods just copy parameters onto `self`, and `__repr__` and `__eq__` are pure routine. Python''s `dataclasses` module writes all of that for you:

```python run
from dataclasses import dataclass, field

@dataclass
class Book:
    title: str
    author: str
    pages: int = 0

@dataclass
class Order:
    customer: str
    items: list = field(default_factory=list)    # a NEW list for every order

a = Book("Dune", "Frank Herbert", 412)
print(a)
print("equal?", a == Book("Dune", "Frank Herbert", 412))

ana, ben = Order("Ana"), Order("Ben")
ana.items.append("tea")
print(ana, ben)
```

Each line like `title: str` declares a field. The `: str` part is a **type annotation**, a label saying what kind of value belongs there. Python doesn''t enforce it, but it documents your intent and editors use it to catch mistakes. From those lines, `@dataclass` generates `__init__`, a readable `__repr__` and a field-by-field `__eq__`. You can still add your own methods and properties as usual.

Notice `field(default_factory=list)`. A dataclass won''t let you write `items: list = []`, precisely to protect you from the shared-list trap from the last lesson. `default_factory=list` means "call `list()` to make a fresh empty list for each new object". (Add `@dataclass(order=True)` and it generates `<` too, comparing fields in order.)

> **In the wild:** Dataclasses are everywhere in modern Python: configuration objects, API responses, game state, rows of a report. Libraries like Pydantic (used by FastAPI) and SQLAlchemy build on the very same `name: type` style. And you''ll use one yourself in the budget tracker project.

## Recap

- **Special methods** (dunders) hook your objects into Python syntax: `__str__` for `print`, `__repr__` for developers and containers, `__eq__` for `==`, `__lt__` for `<` and `sorted()`, `__len__` for `len()`. `__str__` and `__repr__` must **return** a string.
- Without `__eq__`, `==` only checks whether two names point at the very same object.
- `@property` turns a method into a computed attribute (read without parentheses); a `.setter` validates every assignment, storing the real value in an `_underscore` attribute.
- **Inheritance** (`class Child(Parent)`) reuses a parent''s code; call `super().__init__(...)` in the child''s `__init__`, and override methods to change behaviour, using `super().method()` to build on the original.
- Use inheritance for "is a" and **composition** (objects as attributes) for "has a". When unsure, prefer composition.
- `@dataclass` writes `__init__`, `__repr__` and `__eq__` for you; use `field(default_factory=list)` for list fields.

**Up next:** your first capstone project, a gradebook analyzer that reads student scores from a CSV file, calculates averages and letter grades, and writes a polished report.
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z'),
('les_python_basics_7_3', 'sec_python_basics_7', 'crs_python_basics', 'Checkpoint: objects & classes', 'quiz', 2, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"Given `class Pet:` with a method `def describe(self): ...`, what does `rex.describe()` actually do?","options":["Calls `Pet.describe(rex)`, so inside the method `self` is `rex`","Calls `describe()` with no arguments at all","Creates a new Pet and calls `describe` on it","Calls `Pet.describe(Pet)`, so `self` is the class"],"answerIndex":0,"explanation":"Calling a method on an object passes that object in as the first argument. `self` is just the name of the parameter that receives it: \"this particular object\"."},{"id":"q2","prompt":"A `Counter` class sets `self.count = 0` in `__init__`, and its method is `def add(self): count = self.count + 1`. After `c = Counter()`, `c.add()`, `c.add()`, what does `print(c.count)` show?","options":["2","1","An AttributeError","0"],"answerIndex":3,"explanation":"`count = self.count + 1` creates a local variable that vanishes when `add` returns. The object''s attribute is never updated. The fix is `self.count += 1`."},{"id":"q3","prompt":"Calling `rex.speak()` raises `TypeError: Pet.speak() takes 0 positional arguments but 1 was given`. What''s the most likely bug?","options":["`rex` was never created","The method was defined as `def speak():` without `self`","`speak` needs to return a string","You must call it as `Pet.speak()` instead"],"answerIndex":1,"explanation":"`rex.speak()` silently passes `rex` as the first argument. If the method has no `self` parameter, there''s nowhere to put it, hence \"1 was given\"."},{"id":"q4","prompt":"A class has `tricks = []` written directly in the class body, and a method does `self.tricks.append(trick)`. What happens when two different dogs each learn a trick?","options":["Each dog gets its own list automatically","Python raises an error because class attributes can''t be changed","Both tricks end up in one list shared by every dog","Only the first dog''s trick is saved"],"answerIndex":2,"explanation":"A class attribute is one object shared by all instances, and `.append()` changes that shared list. Lists and dicts that each object should own must be created in `__init__` with `self.tricks = []`."},{"id":"q5","prompt":"A class is defined as `class Account: rate = 0.02`. After `a = Account()`, `b = Account()` and `a.rate = 0.05`, what does `print(b.rate)` show?","options":["0.05","0.02","An AttributeError","None"],"answerIndex":1,"explanation":"Assigning `a.rate = 0.05` creates a new attribute on `a` only. `b` has no `rate` of its own, so reading `b.rate` falls back to the class value, `0.02`."},{"id":"q6","prompt":"A class defines both `__str__` and `__repr__`. Which one does `print([item])` use for the object inside the list?","options":["`__str__`, because `print` always uses `__str__`","Neither; lists print memory addresses","`__init__`","`__repr__`, because containers show their items with `__repr__`"],"answerIndex":3,"explanation":"`print(item)` would use `__str__`, but a list builds its text from each item''s `__repr__`. That''s why `__repr__` is the one to write if you only write one."},{"id":"q7","prompt":"Printing an object crashes with `TypeError: __str__ returned non-string (type NoneType)`. Which fix is right?","options":["Change `print(...)` inside `__str__` to `return ...`","Wrap the call as `print(str(obj))`","Rename `__str__` to `__repr__`","Add `self` to the `print` call inside `__str__`"],"answerIndex":0,"explanation":"`__str__` must return a string. A `__str__` that prints its text and returns nothing hands `None` back to Python, which raises this TypeError."},{"id":"q8","prompt":"In `class Rectangle`, `area` is defined with `@property`. How do you read a rectangle''s area?","options":["`room.area()`","`room.area`","`Rectangle.area()`","`property(room.area)`"],"answerIndex":1,"explanation":"A property is read like an attribute, without parentheses. `room.area()` would compute the number and then try to call it, raising `TypeError: ''int'' object is not callable`."},{"id":"q9","prompt":"`class SavingsAccount(Account)` defines its own `__init__` that only sets `self.rate = rate`. Creating one and reading `.balance` raises AttributeError. What''s missing?","options":["`SavingsAccount` must also define `deposit`","A `@property` for balance","A call to `super().__init__(owner, balance)` inside the child''s `__init__`","The parent class name should be in quotes"],"answerIndex":2,"explanation":"When a child defines `__init__`, the parent''s `__init__` no longer runs automatically. Calling `super().__init__(...)` lets `Account` set up `owner` and `balance` before the child adds `rate`."},{"id":"q10","prompt":"Which design uses composition (\"has a\") rather than inheritance (\"is a\")?","options":["`class Manager(Employee)`","`class Puppy(Dog)`","`class SavingsAccount(Account)`","A `Playlist` class whose `songs` attribute holds a list of `Song` objects"],"answerIndex":3,"explanation":"A playlist is not a kind of song; it has songs, so it stores them as an attribute. The other three are genuine \"is a\" relationships, where inheritance fits."}]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_python_basics_8_1', 'sec_python_basics_8', 'crs_python_basics', 'Project: gradebook analyzer', 'interactive', 0, 1500, NULL, NULL, 'Every term, teachers everywhere export a spreadsheet of scores and then spend an evening with a calculator: averages, letter grades, who''s at the top, who needs help, how the class did overall. It''s slow and it''s easy to get wrong. It''s also exactly the kind of chore a short Python program does in a blink, and gets right every time.

In this project you''ll build that program, a **gradebook analyzer**, from a raw CSV file all the way to a formatted report and a saved JSON summary. Nothing here is new. It''s files, functions, loops, dictionaries, f-strings and `try`/`except` from the last 27 lessons, working together for the first time. That''s the real skill this lesson teaches: taking a big job and breaking it into small functions you can write and test one at a time.

> **How this project works:** each step is a challenge that adds one piece of the program. Challenges run on their own, so each one includes the finished helpers it needs from earlier steps. At the end, you''ll run the whole analyzer from top to bottom.

```python setup
# The gradebook files this project works with (hidden setup: runs before every cell and challenge).
with open("grades.csv", "w", encoding="utf-8") as f:
    f.write(
        "student,homework,midterm,final\n"
        "Ava,92,88,95\nBen,75,68,72\nChloe,85,91,89\nDiego,58,62,49\n"
        "Emma,99,94,97\nFarid,81,77,84\nGrace,62,65,66\nHiro,88,79,91\n"
    )
with open("grades_messy.csv", "w", encoding="utf-8") as f:
    f.write(
        "student,homework,midterm,final\n"
        "Ava,92,88,95\nBen,75,68,72\nChloe,85,91,89\nDiego,58,62,49\n"
        "Emma,99,94,97\nFarid,81,77,84\nGrace,62,65,66\nHiro,88,79,91\n"
        "Isla,90,,85\nJonas,78,absent,80\nKemal, 84 , 90 ,87\n"
    )
```

## The plan

Before writing any code, professionals sketch the program as a pipeline of small steps. Each step takes something in and hands something out:

```text
grades.csv ──► load_records ──► average ──► letter_grade ──► class_stats ──► report + summary.json
  (text)       (name, scores)    (number)     ("A".."F")      (mean, top,     (what a human
                                                               bottom)         reads)
```

Every box becomes one function. Small functions are easy to test on their own, and once each one works, the whole program is just a few lines that call them in order.

## Step 1: read the CSV

This page has its own little filesystem, and the setup has already written a file called `grades.csv` into it. Have a look at the raw text:

```python run
with open("grades.csv", encoding="utf-8") as f:
    print(f.read())
```

One header line, then one student per line, with a homework, midterm and final score. You learned in lesson 24 that `csv.DictReader` turns each line into a dictionary keyed by the header:

```python run
import csv

with open("grades.csv", newline="", encoding="utf-8") as f:
    rows = list(csv.DictReader(f))

print(len(rows), "rows")
rows[0]
```

Look closely at that dictionary. Something is about to bite anyone who tries to do math with it.

```python predict id=predict-csv-strings title="Adding two scores"
import csv

with open("grades.csv", newline="", encoding="utf-8") as f:
    rows = list(csv.DictReader(f))

print(rows[0]["homework"] + rows[0]["midterm"])
--- options
180
* 9288
92 88
TypeError
--- explain
A CSV file is just text, so **every value `DictReader` gives you is a string**: `''92''` and `''88''`, not `92` and `88`. `+` on two strings glues them together, giving `9288`. Convert with `float()` (or `int()`) before doing any math.
```

Converting one row is a short list comprehension over the score columns:

```python run
SCORE_COLUMNS = ["homework", "midterm", "final"]

row = rows[0]
scores = [float(row[col]) for col in SCORE_COLUMNS]
print(row["student"], scores)
```

Why `float` and not `int`? Teachers love half points. `int("88.5")` raises a `ValueError`, while `float("88.5")` is happy, and `float("92")` works too.

```python exercise id=load-records title="Load the gradebook into records"
import csv

SCORE_COLUMNS = ["homework", "midterm", "final"]

def load_records(path):
    """Read a gradebook CSV and return a list of (name, scores) tuples.

    scores is a list of floats, one per column in SCORE_COLUMNS.
    """
    records = []
    with open(path, newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            # TODO: get the student''s name from the "student" column
            name = ...
            # TODO: build a list of floats from this row''s SCORE_COLUMNS
            scores = ...
            records.append((name, scores))
    return records

records = load_records("grades.csv")
print(len(records), "students")
print(records[0])
--- solution
import csv

SCORE_COLUMNS = ["homework", "midterm", "final"]

def load_records(path):
    """Read a gradebook CSV and return a list of (name, scores) tuples.

    scores is a list of floats, one per column in SCORE_COLUMNS.
    """
    records = []
    with open(path, newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            name = row["student"]
            scores = [float(row[col]) for col in SCORE_COLUMNS]
            records.append((name, scores))
    return records

records = load_records("grades.csv")
print(len(records), "students")
print(records[0])
--- test
recs = load_records("grades.csv")
assert isinstance(recs, list), f"`load_records` should return a list, but returned {type(recs).__name__}."
assert len(recs) == 8, f"grades.csv has 8 students, but you returned {len(recs)} records."
first = recs[0]
assert isinstance(first, tuple) and len(first) == 2, f"Each record should be a (name, scores) tuple, but the first one is {first!r}."
name, scores = first
assert name is not ..., "Replace the `...` after `name =` with the value from the \"student\" column."
assert scores is not ..., "Replace the `...` after `scores =` with a list of the row''s scores."
assert name == "Ava", f"The first record''s name should be ''Ava'', but it''s {name!r}. Use row[\"student\"]."
assert isinstance(scores, list), f"`scores` should be a list, but it''s a {type(scores).__name__}."
assert all(isinstance(s, (int, float)) for s in scores), f"Scores should be numbers, but got {scores!r}. CSV values are text: convert each one with float()."
assert scores == [92, 88, 95], f"Ava''s scores should be [92.0, 88.0, 95.0], but got {scores!r}."
with open("check_grades.csv", "w", encoding="utf-8") as f:
    f.write("student,homework,midterm,final\nKim,88.5,90,79\nLeo,70,65,72\n")
try:
    fresh = load_records("check_grades.csv")
except ValueError:
    raise AssertionError("Your function crashed on a half-point score like ''88.5''. Convert with float(), not int().")
assert fresh == [("Kim", [88.5, 90.0, 79.0]), ("Leo", [70.0, 65.0, 72.0])], f"On a different file, load_records returned {fresh!r}. Make sure you read from `path` and convert every score column."
--- hint
Each `row` is a dictionary like `{"student": "Ava", "homework": "92", ...}`. The name is one lookup away.
--- hint
For the scores, loop over `SCORE_COLUMNS` and convert each `row[col]` with `float()`. A list comprehension does it in one line.
```

## Step 2: one student''s average

An average is the sum divided by the count. The one trap is an empty list: a student with no scores yet would crash the whole report.

```python run error
scores = []
sum(scores) / len(scores)
```

`ZeroDivisionError` on line 2, because `len([])` is 0. Your `average` function should check for that first and return `0.0` instead. Also, don''t round inside `average`. Rounding is a *display* decision, and rounding too early makes later math (like the class mean) drift.

```python run
scores = [92.0, 88.0, 95.0]
avg = sum(scores) / len(scores)
print("full precision:", avg)
print(f"for humans:      {avg:.1f}")
```

```python exercise id=average-score title="Write the average function"
def average(scores):
    """Return the mean of a list of scores, or 0.0 if the list is empty."""
    # TODO: return 0.0 for an empty list, otherwise the mean (don''t round it)
    ...

print(average([92.0, 88.0, 95.0]))   # about 91.67
print(average([]))                   # 0.0
--- solution
def average(scores):
    """Return the mean of a list of scores, or 0.0 if the list is empty."""
    if not scores:
        return 0.0
    return sum(scores) / len(scores)

print(average([92.0, 88.0, 95.0]))   # about 91.67
print(average([]))                   # 0.0
--- test
r = average([90, 80, 70])
assert r is not None, "`average` returned None. Replace the `...` with code that `return`s the mean (returning, not printing)."
assert r is not ..., "Replace the `...` with your code."
assert isinstance(r, (int, float)), f"`average` should return a number, but returned {r!r}."
assert r == 80, f"average([90, 80, 70]) should be 80, but got {r!r}."
assert abs(average([88.5, 91.5]) - 90) < 1e-9, f"average([88.5, 91.5]) should be 90, but got {average([88.5, 91.5])!r}."
third = average([1, 2, 2])
assert abs(third - 5 / 3) < 1e-9, f"average([1, 2, 2]) should be 1.6666..., but got {third!r}. Don''t round inside `average`; round only when you display."
try:
    empty = average([])
except ZeroDivisionError:
    raise AssertionError("average([]) crashed with ZeroDivisionError. Check for an empty list before dividing.")
assert empty == 0.0, f"average([]) should return 0.0, but returned {empty!r}."
--- hint
An empty list is falsy, so `if not scores:` is a neat way to spot it.
--- hint
Return `0.0` early for the empty case; otherwise return `sum(scores) / len(scores)`.
```

## Step 3: letter grades

The school''s scale is a ladder: **A** for 90 and up, **B** for 80 and up, **C** for 70, **D** for 60, and **F** below that. An `if`/`elif` chain is the natural fit, and as you saw in lesson 9, **Python takes the first branch whose condition is true and skips the rest.** So the order of the rungs matters.

A teammate wrote this version. Run it and see what grades the class gets.

```python debug id=grade-ladder title="Everyone passes with a D"
def letter_grade(avg):
    """Return the letter grade: A 90+, B 80+, C 70+, D 60+, otherwise F."""
    if avg >= 60:
        return "D"
    elif avg >= 70:
        return "C"
    elif avg >= 80:
        return "B"
    elif avg > 90:
        return "A"
    else:
        return "F"

for name, avg in [("Emma", 96.7), ("Chloe", 88.3), ("Ben", 71.7), ("Grace", 64.3), ("Diego", 56.3)]:
    print(name, letter_grade(avg))
--- solution
def letter_grade(avg):
    """Return the letter grade: A 90+, B 80+, C 70+, D 60+, otherwise F."""
    if avg >= 90:
        return "A"
    elif avg >= 80:
        return "B"
    elif avg >= 70:
        return "C"
    elif avg >= 60:
        return "D"
    else:
        return "F"

for name, avg in [("Emma", 96.7), ("Chloe", 88.3), ("Ben", 71.7), ("Grace", 64.3), ("Diego", 56.3)]:
    print(name, letter_grade(avg))
--- test
assert letter_grade(96.7) == "A", f"letter_grade(96.7) returns {letter_grade(96.7)!r}, not ''A''. Python stops at the FIRST true condition. Which one is checked first?"
assert letter_grade(88.3) == "B", f"letter_grade(88.3) should be ''B'', got {letter_grade(88.3)!r}."
assert letter_grade(90) == "A", f"An average of exactly 90 should be an A, but got {letter_grade(90)!r}. Look at the comparison operator on the A line."
cases = {100: "A", 89.99: "B", 80: "B", 79.9: "C", 70: "C", 69.5: "D", 60: "D", 59.99: "F", 0: "F"}
wrong = [f"{a} -> {letter_grade(a)!r} (expected {g!r})" for a, g in cases.items() if letter_grade(a) != g]
assert not wrong, "Some boundaries are off: " + "; ".join(wrong)
--- hint
Run it: 96.7 gets a D. An average of 96.7 is also `>= 60`, so the very first branch wins. Which rung should be tested first?
--- hint
Put the highest cutoff at the top and work downward. Then check the A line once more: should exactly 90 count?
```

> **Tip:** When a chain of `elif`s checks ranges with `>=`, always go **from the highest cutoff down** (or, with `<`, from the lowest up). Then each branch only has to say where its range *starts*.

## Step 4: class statistics

With every student''s average in a dictionary, the class-wide numbers come from tools you already know. The mean is the sum of the values over their count. For the top student, `max` with a `key` (lesson 22) compares the *averages* but hands back the *name*:

```python run
averages = {"Ava": 91.67, "Ben": 71.67, "Chloe": 88.33, "Diego": 56.33}

print("max of the dict:      ", max(averages))
print("max of the values:    ", max(averages.values()))
print("name with highest avg:", max(averages, key=lambda name: averages[name]))
```

Plain `max(averages)` loops over the **keys**, so it returns the alphabetically last name. The `key` version is the one you want: it ranks each name by its average.

```python exercise id=class-stats title="Summarize the whole class"
def class_stats(averages):
    """Summarize a dict of {name: average}.

    Return a dict with three keys:
      "mean":    the mean of all the averages
      "highest": the NAME of the student with the highest average
      "lowest":  the NAME of the student with the lowest average
    """
    # TODO: fill in the three values
    mean = ...
    highest = ...
    lowest = ...
    return {"mean": mean, "highest": highest, "lowest": lowest}

averages = {"Ava": 91.67, "Ben": 71.67, "Chloe": 88.33, "Diego": 56.33, "Emma": 96.67}
print(class_stats(averages))
--- solution
def class_stats(averages):
    """Summarize a dict of {name: average}.

    Return a dict with three keys:
      "mean":    the mean of all the averages
      "highest": the NAME of the student with the highest average
      "lowest":  the NAME of the student with the lowest average
    """
    mean = sum(averages.values()) / len(averages)
    highest = max(averages, key=lambda name: averages[name])
    lowest = min(averages, key=lambda name: averages[name])
    return {"mean": mean, "highest": highest, "lowest": lowest}

averages = {"Ava": 91.67, "Ben": 71.67, "Chloe": 88.33, "Diego": 56.33, "Emma": 96.67}
print(class_stats(averages))
--- test
fresh = {"Rosa": 77.0, "Sam": 93.5, "Tao": 61.25, "Uma": 85.0}
s = class_stats(fresh)
assert isinstance(s, dict), f"`class_stats` should return a dict, but returned {type(s).__name__}."
for key in ["mean", "highest", "lowest"]:
    assert s.get(key) is not ..., f"Replace the `...` for `{key}` with your code."
assert isinstance(s["mean"], (int, float)), f"\"mean\" should be a number, but it''s {s[''mean'']!r}."
assert abs(s["mean"] - 79.1875) < 1e-9, f"For {fresh} the mean should be 79.1875, but got {s[''mean'']!r}. Sum the VALUES and divide by how many there are."
assert not isinstance(s["highest"], (int, float)), f"\"highest\" should be a student''s name, not a number ({s[''highest'']!r}). Use max() with a key."
assert s["highest"] == "Sam", f"For {fresh} the highest should be ''Sam'', but got {s[''highest'']!r}. Rank names by their average, not alphabetically."
assert s["lowest"] == "Tao", f"For {fresh} the lowest should be ''Tao'', but got {s[''lowest'']!r}."
assert fresh == {"Rosa": 77.0, "Sam": 93.5, "Tao": 61.25, "Uma": 85.0}, "`class_stats` shouldn''t change the dictionary it''s given."
--- hint
`averages.values()` gives you just the numbers; `sum(...)` and `len(...)` do the rest for the mean.
--- hint
`max(averages, key=lambda name: averages[name])` returns the name whose average is largest. `min` works the same way.
```

## Step 5: the grade distribution

A good report also shows how many students landed on each letter. That''s the counting pattern from lesson 16: start a dictionary of zeros, then add 1 for each student. Starting with all five letters at zero means letters nobody got still show up in the report.

There''s a classic bug hiding in this version. Run it and look at the total.

```python debug id=grade-counts title="The distribution only counts one student"
def grade_distribution(grades):
    """Count students per letter. grades is a dict of {name: letter}.

    Return a dict with all five letters A, B, C, D, F as keys.
    """
    for letter in grades.values():
        counts = {"A": 0, "B": 0, "C": 0, "D": 0, "F": 0}
        counts[letter] += 1
    return counts

grades = {"Ava": "A", "Ben": "C", "Chloe": "B", "Diego": "F",
          "Emma": "A", "Farid": "B", "Grace": "D", "Hiro": "B"}
dist = grade_distribution(grades)
print(dist)
print("students counted:", sum(dist.values()))
--- solution
def grade_distribution(grades):
    """Count students per letter. grades is a dict of {name: letter}.

    Return a dict with all five letters A, B, C, D, F as keys.
    """
    counts = {"A": 0, "B": 0, "C": 0, "D": 0, "F": 0}
    for letter in grades.values():
        counts[letter] += 1
    return counts

grades = {"Ava": "A", "Ben": "C", "Chloe": "B", "Diego": "F",
          "Emma": "A", "Farid": "B", "Grace": "D", "Hiro": "B"}
dist = grade_distribution(grades)
print(dist)
print("students counted:", sum(dist.values()))
--- test
d = grade_distribution(grades)
assert sum(d.values()) == 8, f"8 students went in, but the counts add up to {sum(d.values())}. Is something being reset on every pass of the loop?"
assert d == {"A": 2, "B": 3, "C": 1, "D": 1, "F": 1}, f"Expected {{''A'': 2, ''B'': 3, ''C'': 1, ''D'': 1, ''F'': 1}}, but got {d}."
d2 = grade_distribution({"x": "C", "y": "C", "z": "A"})
assert d2 == {"A": 1, "B": 0, "C": 2, "D": 0, "F": 0}, f"On another class, expected {{''A'': 1, ''B'': 0, ''C'': 2, ''D'': 0, ''F'': 0}} but got {d2}."
try:
    d3 = grade_distribution({})
except NameError:
    raise AssertionError("grade_distribution({}) crashed: with no students the loop never runs, so `counts` never exists. Create it before the loop.")
assert d3 == {"A": 0, "B": 0, "C": 0, "D": 0, "F": 0}, f"With no students every count should be 0, but got {d3}."
--- hint
Click **Debug** and watch `counts` as the loop runs. What happens to it at the start of every pass?
--- hint
An accumulator must be created **once, before** the loop. Move the line that builds the zero dictionary up one level.
```

## Step 6: a report people can read

Numbers in a dictionary are for programs. People want a neat table. f-string format specs (lesson 6) line columns up: `:<8` pads to 8 characters on the left, `:>6.1f` right-aligns a number in 6 characters with one decimal.

```python predict id=predict-alignment title="Lining up a row"
name = "Ben"
avg = 71.666
print(f"[{name:<6}{avg:>7.1f}]")
--- options
[Ben 71.7]
[Ben   71.666]
* [Ben      71.7]
[   Ben71.7   ]
--- explain
`{name:<6}` pads `Ben` with 3 spaces on the right to make 6 characters. `{avg:>7.1f}` rounds to `71.7` (4 characters) and pads it with 3 spaces on the left to make 7. Together that''s `Ben` followed by 6 spaces, then `71.7`. The brackets just make the spaces visible.
```

Sorting puts the strongest students on top. `sorted` with a `key` and `reverse=True` orders the names by their average, highest first:

```python run
averages = {"Ava": 91.667, "Ben": 71.667, "Chloe": 88.333, "Diego": 56.333}

for name in sorted(averages, key=lambda n: averages[n], reverse=True):
    print(f"{name:<8}{averages[name]:>6.1f}")
```

```python exercise id=report-lines title="Format the report lines"
def letter_grade(avg):  # from Step 3
    if avg >= 90:
        return "A"
    elif avg >= 80:
        return "B"
    elif avg >= 70:
        return "C"
    elif avg >= 60:
        return "D"
    else:
        return "F"

def format_report(averages):
    """Return a list of report lines, highest average first.

    Each line: the name left-aligned in 8 characters, the average
    right-aligned in 6 characters with 1 decimal, two spaces, the letter.
    Example: ''Emma      96.7  A''
    """
    lines = []
    # TODO: loop over the names sorted by average (highest first)
    # and append one formatted line per student to `lines`
    ...
    return lines

averages = {"Ava": 91.667, "Ben": 71.667, "Chloe": 88.333, "Diego": 56.333, "Emma": 96.667}
for line in format_report(averages):
    print(line)
--- solution
def letter_grade(avg):  # from Step 3
    if avg >= 90:
        return "A"
    elif avg >= 80:
        return "B"
    elif avg >= 70:
        return "C"
    elif avg >= 60:
        return "D"
    else:
        return "F"

def format_report(averages):
    """Return a list of report lines, highest average first.

    Each line: the name left-aligned in 8 characters, the average
    right-aligned in 6 characters with 1 decimal, two spaces, the letter.
    Example: ''Emma      96.7  A''
    """
    lines = []
    for name in sorted(averages, key=lambda n: averages[n], reverse=True):
        avg = averages[name]
        lines.append(f"{name:<8}{avg:>6.1f}  {letter_grade(avg)}")
    return lines

averages = {"Ava": 91.667, "Ben": 71.667, "Chloe": 88.333, "Diego": 56.333, "Emma": 96.667}
for line in format_report(averages):
    print(line)
--- test
fresh = {"Rosa": 77.0, "Sam": 93.5, "Tao": 61.25, "Uma": 85.0}
got = format_report(fresh)
assert isinstance(got, list), f"`format_report` should return a list of strings, but returned {type(got).__name__}."
assert got, "`format_report` returned an empty list. Append one line per student to `lines`."
assert len(got) == 4, f"There are 4 students, so there should be 4 lines, but you returned {len(got)}."
assert all(isinstance(line, str) for line in got), "Every item in the list should be a string (an f-string line)."
order = [line.split()[0] if line.split() else "" for line in got]
assert order == ["Sam", "Uma", "Rosa", "Tao"], f"Lines should go from highest average to lowest (Sam, Uma, Rosa, Tao), but the order is {order}."
expected = [f"{n:<8}{fresh[n]:>6.1f}  {letter_grade(fresh[n])}" for n in ["Sam", "Uma", "Rosa", "Tao"]]
for g, e in zip(got, expected):
    assert g.rstrip() == e, f"A line should look like {e!r}, but yours is {g!r}. Check the widths (:<8 and :>6.1f) and the two spaces before the letter."
--- hint
`sorted(averages, key=lambda n: averages[n], reverse=True)` gives the names, best first.
--- hint
Inside the loop, build each line with an f-string like `f"{name:<8}{avg:>6.1f}  {letter_grade(avg)}"` and append it.
```

## Step 7: real data is messy

The file you''ve used so far is perfect. Real exports are not: a student missed the midterm (empty cell), someone typed `absent` into a score column, a spreadsheet added stray spaces. Here''s the messy version of the gradebook:

```python run
with open("grades_messy.csv", encoding="utf-8") as f:
    for line in f.readlines()[-4:]:
        print(repr(line))
```

Isla''s midterm is empty, and Jonas has the word `absent`. Watch what `float` does with those:

```python run error
print(float(" 84 "))     # stray spaces are fine
print(float(""))         # an empty cell is not
```

`float` quietly ignores surrounding spaces, so Kemal''s row is fine. But an empty string or a word raises `ValueError`, and without protection one bad row would crash the whole report for everyone. The fix is the `try`/`except` pattern from lesson 23: **try** to convert the row, and if it fails, set the row aside and keep going.

> **Pitfall:** Catch `ValueError` specifically, not everything with a bare `except:`. A bare `except` would also hide your own typos, like a misspelled column name (`KeyError`), and you''d silently skip every row without knowing why.

```python exercise id=messy-rows title="Skip the bad rows instead of crashing"
import csv

SCORE_COLUMNS = ["homework", "midterm", "final"]

def load_records(path):
    """Read a gradebook CSV. Return a tuple (records, skipped):

    records: list of (name, scores) tuples for rows with valid scores
    skipped: list of names whose row had a missing or invalid score
    """
    records = []
    skipped = []
    with open(path, newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            name = row["student"]
            # TODO: protect the conversion with try/except ValueError.
            # Good rows go into `records`; for bad rows, add the name to `skipped`.
            scores = [float(row[col]) for col in SCORE_COLUMNS]
            records.append((name, scores))
    return records, skipped

# Works on the clean file. When you''re done, try "grades_messy.csv" too.
records, skipped = load_records("grades.csv")
print(len(records), "loaded; skipped:", skipped)
--- solution
import csv

SCORE_COLUMNS = ["homework", "midterm", "final"]

def load_records(path):
    """Read a gradebook CSV. Return a tuple (records, skipped):

    records: list of (name, scores) tuples for rows with valid scores
    skipped: list of names whose row had a missing or invalid score
    """
    records = []
    skipped = []
    with open(path, newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            name = row["student"]
            try:
                scores = [float(row[col]) for col in SCORE_COLUMNS]
            except ValueError:
                skipped.append(name)
                continue
            records.append((name, scores))
    return records, skipped

records, skipped = load_records("grades_messy.csv")
print(len(records), "loaded; skipped:", skipped)
--- test
try:
    out = load_records("grades_messy.csv")
except ValueError as e:
    raise AssertionError(f"load_records crashed on grades_messy.csv with ValueError: {e}. Wrap the conversion in try/except ValueError.")
assert isinstance(out, tuple) and len(out) == 2, "`load_records` should return a tuple: (records, skipped)."
recs, skip = out
assert skip == ["Isla", "Jonas"], f"`skipped` should be [''Isla'', ''Jonas''], but it''s {skip!r}."
names = [r[0] for r in recs]
assert "Isla" not in names and "Jonas" not in names, f"Skipped students must not also appear in `records`, but records has {names}."
assert len(recs) == 9, f"9 rows are valid (including Kemal, whose spaces are fine), but `records` has {len(recs)}: {names}."
assert ("Kemal", [84.0, 90.0, 87.0]) in recs, "Kemal''s row has stray spaces but valid numbers, so it should be kept as (''Kemal'', [84.0, 90.0, 87.0])."
with open("check_messy.csv", "w", encoding="utf-8") as f:
    f.write("student,homework,midterm,final\nZed,abc,1,2\nYan,50,60,70\nXia,80,,90\n")
recs2, skip2 = load_records("check_messy.csv")
assert recs2 == [("Yan", [50.0, 60.0, 70.0])] and skip2 == ["Zed", "Xia"], f"On another file expected ([(''Yan'', [50.0, 60.0, 70.0])], [''Zed'', ''Xia'']) but got ({recs2!r}, {skip2!r})."
--- hint
Put the `scores = [...]` line inside a `try:` block. In `except ValueError:`, append `name` to `skipped`.
--- hint
After recording a skipped name, `continue` jumps to the next row so the bad one is never appended. (An `else:` block on the `try` that does the append works too.)
```

## Step 8: put it all together and save a summary

Reports are for people; a **JSON summary** is for other programs, like a dashboard, an email script, or next term''s analyzer. `json.dump` writes a dictionary to a file, and `indent=2` keeps it readable:

```python run
import json

demo = {"class_mean": 79.5, "highest": "Emma", "skipped": ["Isla"]}
print(json.dumps(demo, indent=2))
```

Now the final step: one function, `analyze`, that runs the whole pipeline on a file and saves the result. The helpers from the earlier steps are included in finished form; `load_records` and `letter_grade` are written a little more compactly, but they do exactly what yours do.

```python exercise id=analyze-gradebook title="Analyze a gradebook end to end"
import csv, json

SCORE_COLUMNS = ["homework", "midterm", "final"]

def load_records(path):  # Steps 1 and 7
    records, skipped = [], []
    with open(path, newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            try:
                records.append((row["student"], [float(row[c]) for c in SCORE_COLUMNS]))
            except ValueError:
                skipped.append(row["student"])
    return records, skipped

def average(scores):  # Step 2
    return sum(scores) / len(scores) if scores else 0.0

def letter_grade(avg):  # Step 3, as a loop over (cutoff, letter) pairs
    for cutoff, letter in [(90, "A"), (80, "B"), (70, "C"), (60, "D")]:
        if avg >= cutoff:
            return letter
    return "F"

def analyze(path, out_path):
    """Analyze a gradebook CSV, save a JSON summary to out_path, and return the summary."""
    records, skipped = load_records(path)
    averages = {name: average(scores) for name, scores in records}
    # TODO 1: build `summary`, a dict with these keys:
    #   "students":   {name: {"average": avg rounded to 1 decimal, "grade": letter}}
    #   "class_mean": the mean of all the averages, rounded to 1 decimal
    #   "highest", "lowest": the names of the top and bottom students
    #   "skipped":    the list of skipped names
    summary = ...
    # TODO 2: save `summary` to out_path as JSON with indent=2
    ...
    return summary

print(analyze("grades_messy.csv", "summary.json"))
--- solution
import csv, json

SCORE_COLUMNS = ["homework", "midterm", "final"]

def load_records(path):  # Steps 1 and 7
    records, skipped = [], []
    with open(path, newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            try:
                records.append((row["student"], [float(row[c]) for c in SCORE_COLUMNS]))
            except ValueError:
                skipped.append(row["student"])
    return records, skipped

def average(scores):  # Step 2
    return sum(scores) / len(scores) if scores else 0.0

def letter_grade(avg):  # Step 3, as a loop over (cutoff, letter) pairs
    for cutoff, letter in [(90, "A"), (80, "B"), (70, "C"), (60, "D")]:
        if avg >= cutoff:
            return letter
    return "F"

def analyze(path, out_path):
    """Analyze a gradebook CSV, save a JSON summary to out_path, and return the summary."""
    records, skipped = load_records(path)
    averages = {name: average(scores) for name, scores in records}
    summary = {
        "students": {n: {"average": round(a, 1), "grade": letter_grade(a)} for n, a in averages.items()},
        "class_mean": round(average(list(averages.values())), 1),
        "highest": max(averages, key=lambda n: averages[n]),
        "lowest": min(averages, key=lambda n: averages[n]),
        "skipped": skipped,
    }
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(summary, f, indent=2)
    return summary

print(analyze("grades_messy.csv", "summary.json"))
--- test
import os
for p in ["check_summary.json", "check_two.json"]:
    if os.path.exists(p):
        os.remove(p)
res = analyze("grades_messy.csv", "check_summary.json")
assert res is not ..., "Replace `summary = ...` with the summary dictionary (TODO 1)."
assert isinstance(res, dict), f"`analyze` should return a dict, but returned {type(res).__name__}."
missing = [k for k in ["students", "class_mean", "highest", "lowest", "skipped"] if k not in res]
assert not missing, f"The summary is missing these keys: {missing}."
students = res["students"]
assert isinstance(students, dict) and len(students) == 9, f"\"students\" should be a dict with the 9 valid students, but it''s {students!r}."
assert students.get("Emma") == {"average": 96.7, "grade": "A"}, f"Emma''s entry should be {{''average'': 96.7, ''grade'': ''A''}}, but it''s {students.get(''Emma'')!r}. Round each average to 1 decimal."
assert students.get("Grace") == {"average": 64.3, "grade": "D"}, f"Grace''s entry should be {{''average'': 64.3, ''grade'': ''D''}}, but it''s {students.get(''Grace'')!r}."
raw = [sum(s) / 3 for _, s in load_records("grades_messy.csv")[0]]
assert res["class_mean"] == round(sum(raw) / len(raw), 1), f"\"class_mean\" should be {round(sum(raw) / len(raw), 1)}, but it''s {res[''class_mean'']!r}."
assert res["highest"] == "Emma" and res["lowest"] == "Diego", f"Highest/lowest should be ''Emma''/''Diego'', but got {res[''highest'']!r}/{res[''lowest'']!r}."
assert res["skipped"] == ["Isla", "Jonas"], f"\"skipped\" should be [''Isla'', ''Jonas''], but it''s {res[''skipped'']!r}."
assert os.path.exists("check_summary.json"), "`analyze` didn''t create a file at `out_path` (TODO 2). Open it in ''w'' mode and use json.dump."
with open("check_summary.json", encoding="utf-8") as f:
    text = f.read()
assert json.loads(text) == json.loads(json.dumps(res)), "The JSON file should contain exactly the summary you return."
assert "\n  " in text, "The JSON file is all on one line. Pass indent=2 to json.dump."
with open("check_two.csv", "w", encoding="utf-8") as f:
    f.write("student,homework,midterm,final\nNia,100,90,80\nOli,50,,70\nPia,60,70,65\n")
res2 = analyze("check_two.csv", "check_two.json")
assert res2["students"] == {"Nia": {"average": 90.0, "grade": "A"}, "Pia": {"average": 65.0, "grade": "D"}}, f"On another file, \"students\" came out as {res2[''students'']!r}."
assert (res2["class_mean"], res2["highest"], res2["lowest"], res2["skipped"]) == (77.5, "Nia", "Pia", ["Oli"]), "On another file, the class mean, highest, lowest or skipped list is off. Compute them from `averages` and `skipped`, not from fixed values."
--- hint
Build the "students" part with a dict comprehension over `averages.items()`: each value is `{"average": round(avg, 1), "grade": letter_grade(avg)}`.
--- hint
The class mean is the average of `averages.values()` (your `average` function needs a list, so wrap them in `list(...)`). Top and bottom use `max`/`min` with a `key`, just like Step 4.
--- hint
For TODO 2: `with open(out_path, "w", encoding="utf-8") as f:` then `json.dump(summary, f, indent=2)`.
```

## The finished analyzer

Here is the whole program in one place, run from top to bottom on the messy file. The first cell holds the building blocks you wrote; the second is the "main" part that uses them to print a report a teacher could actually hand out.

```python run
import csv, json

SCORE_COLUMNS = ["homework", "midterm", "final"]

def load_records(path):
    records, skipped = [], []
    with open(path, newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            try:
                records.append((row["student"], [float(row[c]) for c in SCORE_COLUMNS]))
            except ValueError:
                skipped.append(row["student"])
    return records, skipped

def average(scores):
    return sum(scores) / len(scores) if scores else 0.0

def letter_grade(avg):
    for cutoff, letter in [(90, "A"), (80, "B"), (70, "C"), (60, "D")]:
        if avg >= cutoff:
            return letter
    return "F"

print("building blocks ready")
```

```python run
records, skipped = load_records("grades_messy.csv")
averages = {name: average(scores) for name, scores in records}
counts = {"A": 0, "B": 0, "C": 0, "D": 0, "F": 0}

print(f"{''STUDENT'':<8}{''AVG'':>6}  GRADE")
print("-" * 21)
for name in sorted(averages, key=lambda n: averages[n], reverse=True):
    grade = letter_grade(averages[name])
    counts[grade] += 1
    print(f"{name:<8}{averages[name]:>6.1f}  {grade}")

print("-" * 21)
print(f"class mean: {average(list(averages.values())):.1f}")
for letter, n in counts.items():
    print(f"  {letter} | {''#'' * n} {n}")
print("skipped (fix these rows):", ", ".join(skipped))
```

Change a score in the setup data in your head: if Diego''s final were 89 instead of 49, which line of this report would change? Programs like this make "what if" questions cheap, which is half of why people automate things.

> **In the wild:** this exact pipeline (load, clean, compute per-row values, aggregate, report, export) is the daily bread of data analysis. In the pandas library, Steps 1 to 5 shrink to a few lines like `pd.read_csv(...)`, `df.mean(axis=1)` and `value_counts()`, but under the hood it''s doing what you just built by hand, and knowing that makes pandas far less mysterious.

## Recap

- Big programs are built from **small functions**, each with one job, each tested on its own before you connect them.
- Everything read from a CSV is **text**: convert with `float()` (or `int()`) before doing math.
- `if`/`elif` ladders on ranges go **from the highest cutoff down**, because the first true branch wins.
- Accumulators (like a counts dictionary) are created **once, before** the loop.
- `try`/`except ValueError` lets one bad row be **skipped and reported** instead of crashing the whole program.
- f-string alignment (`:<8`, `:>6.1f`) makes readable reports; `json.dump(..., indent=2)` makes machine-readable ones.

**Up next:** a word-guessing game, where you''ll use random choice, string scoring and a game loop to build your own version of Wordle.
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z'),
('les_python_basics_8_2', 'sec_python_basics_8', 'crs_python_basics', 'Project: a word-guessing game', 'interactive', 1, 1500, NULL, NULL, 'In early 2022, a simple word game took over the internet: guess a secret five-letter word in six tries, and after each guess every letter turns green, yellow or gray. Millions of people shared their little grids of colored squares every morning. Wordle was originally written by one software engineer as a gift for his partner, and the core of it is small enough to build with what you already know.

That''s this project. You''ll build your own Wordle-style game piece by piece: picking a secret word, rejecting bad guesses, scoring letters (including the tricky case of repeated letters, which trips up plenty of real implementations), drawing the colored feedback, running the turn-by-turn game loop, tracking a player''s stats and offering another round. It''s strings, loops, dictionaries, functions and `random`, all working together in a program you can actually play.

> **How this project works:** each step is a challenge that builds one piece of the game. Challenges run on their own, so later steps bring in the finished helpers from earlier steps. At the end, you''ll play a full session.

```python setup
# Simulated keyboard: the browser can''t pause for typing, so input() reads queued answers.
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
# The game''s word list, plus wordgame.py: a module holding the finished helpers from the steps below.
WORDS = ["apple", "beach", "brave", "chair", "crane", "dance", "eagle", "flame", "ghost", "grape", "house",
         "lemon", "mango", "night", "ocean", "piano", "queen", "river", "stone", "tiger", "train", "water"]

_ENGINE = ''''''"""Finished helpers for the word game."""
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
''''''
with open("wordgame.py", "w", encoding="utf-8") as _f:
    _f.write(_ENGINE)

import importlib as _importlib, sys as _sys
if "" not in _sys.path:
    _sys.path.insert(0, "")
_importlib.invalidate_caches()
```

## The plan

A game feels like one big thing, but it''s really a handful of small jobs. Here''s the whole program as a pipeline, one function per box:

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
Two generators with the same seed produce **the same sequence**, number for number. The first draws match, and so do the second draws. That''s what makes seeded randomness perfect for testing: "random" behavior you can reproduce exactly.
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
assert r in ("tiger", "mango"), f"From [''Hi'', ''TIGER'', ''Spaceship'', ''Mango'', ''ox''] the only choices are ''tiger'' and ''mango'', but you returned {r!r}. Keep only 5-letter words, and lowercase them."
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

Players make typos. Before a guess costs a turn, the game checks three rules: it has exactly 5 characters, they''re all letters, and it''s a word the game knows. `.isalpha()` is the letters-only cousin of `.isdigit()` from lesson 6:

```python run
for guess in ["crane", "cr4ne", "cra ne", "CRANE"]:
    print(f"{guess!r:9} isalpha: {guess.isalpha()}")
```

A space counts as "not a letter", and capitals are still letters. The game will tidy every guess with `.strip().lower()` before checking it, so `validate_guess` can assume a clean, lowercase string.

> **Tip:** Returning `None` for "all good" and a message string for "something''s wrong" is a handy pattern: the caller can write `if problem:` because `None` is falsy and any non-empty message is truthy.

```python exercise id=validate-guess title="Reject invalid guesses"
def validate_guess(guess, words):
    """Check a (stripped, lowercase) guess. Return None if it''s valid.

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
    """Check a (stripped, lowercase) guess. Return None if it''s valid.

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
assert got is not None, "validate_guess(''cat'', WORDS) returned None, but ''cat'' is only 3 letters. Return \"Guesses must be 5 letters.\" for that case."
cases = [("cat", LEN), ("stones", LEN), ("", LEN), ("cr4ne", ALPHA), ("12345", ALPHA), ("cra e", ALPHA), ("zzzzz", LIST), ("hello", LIST)]
for guess, msg in cases:
    got = validate_guess(guess, WORDS)
    assert got == msg, f"validate_guess({guess!r}, WORDS) should return {msg!r}, but returned {got!r}."
for word in ["crane", "tiger", "water"]:
    assert validate_guess(word, WORDS) is None, f"{word!r} is a valid guess, so validate_guess should return None, but returned {validate_guess(word, WORDS)!r}."
assert validate_guess("zzzzz", ["zzzzz"]) is None, "Check the guess against the `words` parameter, not a fixed list."
--- hint
Three `if` statements, one per rule, each returning its message. Because `return` leaves the function, the order you write them in is the order they''re checked.
--- hint
Use `len(guess) != 5`, `not guess.isalpha()` and `guess not in words`.
```

## Step 3: score a guess

Now the heart of the game. For each position in the guess:

| Mark | Meaning | Shown as |
|---|---|---|
| `"G"` | right letter, right spot | green |
| `"Y"` | the letter is in the word, but somewhere else | yellow |
| `"-"` | the letter isn''t in the word | gray |

Comparing two words position by position is a job for `zip` (lesson 22), which walks both strings in step:

```python run
for g, s in zip("react", "crane"):
    print(g, s, "same spot!" if g == s else ("elsewhere" if g in "crane" else "nowhere"))
```

Start with this straightforward version. Don''t worry about repeated letters yet: the next step deals with them.

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
assert r == "YYGY-", f"score_guess(''react'', ''crane'') should be ''YYGY-'', but got {r!r}."
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
assert score_guess("geese", "eagle") == "YY--G", f"score_guess(''geese'', ''eagle'') should be ''YY--G'', but got {score_guess(''geese'', ''eagle'')!r}. The green E already used up one of eagle''s two Es."
assert score_guess("puppy", "apple") == "Y-G--", f"score_guess(''puppy'', ''apple'') should be ''Y-G--'', but got {score_guess(''puppy'', ''apple'')!r}."
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

Players don''t want to read `"YY--G"`. A dictionary that maps each mark to a colored square turns it into the famous grid:

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
    # TODO: build and return the line (don''t print it)
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
assert r is not None, "`render` returned None. Build the line and `return` it (don''t print it)."
assert isinstance(r, str), f"`render` should return a string, but returned {r!r}."
assert r == "🟩🟨⬜⬜🟩  CRANE", f"render(''crane'', ''GY--G'') should be ''🟩🟨⬜⬜🟩  CRANE'', but got {r!r}."
r2 = render("tiger", "-YG-G")
assert r2 == "⬜🟨🟩⬜🟩  TIGER", f"render(''tiger'', ''-YG-G'') should be ''⬜🟨🟩⬜🟩  TIGER'', but got {r2!r}."
assert render("ghost", "GGGGG") == "🟩" * 5 + "  GHOST", "A perfect guess should render as five green squares, two spaces, then the word in capitals."
--- hint
Look up each mark in `SYMBOLS` and glue the squares together with `"".join(...)`.
--- hint
Then add two spaces and `guess.upper()`: `squares + "  " + guess.upper()`.
```

## Your helpers, packaged as a module

You''ve now written every helper the game needs. In a real project they''d live in their own file so the main program can import them, and that''s what the setup did: it saved finished versions in a module called `wordgame.py` (lesson 25). From here on, challenges import them instead of repeating them.

```python run
import wordgame

print([name for name in dir(wordgame) if not name.startswith("_")])
print(wordgame.render("geese", wordgame.score_guess("geese", "eagle")))
```

## Step 6: the game loop

Now for the part that makes it a *game*: asking the player for guesses, turn after turn.

Because this page can''t pause for your keyboard, `input()` here reads answers you queue up with `type_answers(...)`. In a real terminal, Python waits for you to type.

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
- A **valid** guess prints its colored row. If it''s the secret, the player wins: **return the turn number** right away.
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
assert r == 3, f"The player typed stone, tiger, crane with secret ''crane'', so play_game should return 3 (won on turn 3), but returned {r!r}."
assert "STONE" in out and "🟩🟩🟩🟩🟩  CRANE" in out, "Print the rendered row for each valid guess, using render(guess, score_guess(guess, secret))."
r, out = _play("crane", ["cr4ne", "hello", "zzzzz", "crane"])
assert r == 1, f"Invalid guesses shouldn''t use up a turn, so winning after three typos is still turn 1, but play_game returned {r!r}."
assert "Letters only, please." in out, "When validate_guess reports a problem, print its message so the player knows what went wrong."
r, out = _play("crane", ["  CRANE "])
assert r == 1, f"''  CRANE '' should count as ''crane'' (strip and lowercase the answer), but play_game returned {r!r}."
r, out = _play("tiger", ["crane", "stone", "water", "house", "lemon", "night", "tiger"])
assert r != 7, "The player got a 7th guess! The loop should stop after max_turns valid guesses."
assert r is None, f"After 6 wrong guesses play_game should return None, but returned {r!r}."
assert len(_queued) == 1, "play_game read more guesses than it should have after the 6th miss."
r, out = _play("tiger", ["crane", "stone", "tiger"], max_turns=2)
assert r is None, f"With max_turns=2, two misses should end the game (return None), but play_game returned {r!r}."
_queued.clear()
--- hint
Use `while turn <= max_turns:`. Inside it, read the guess, check it with `validate_guess`, and `continue` if there''s a problem.
--- hint
For a valid guess: print the rendered row, `return turn` if `guess == secret`, and otherwise do `turn += 1` at the bottom of the loop.
```

## Step 7: keeping score

Players love their stats: how many games played, how many won, the current winning streak and the best streak ever. A dictionary holds them all, and a function updates it after each game.

Since dictionaries are mutable, a function can **update one in place**: changes made through the parameter are visible to the caller, because both names point to the same dictionary (lesson 14''s aliasing, used on purpose this time).

```python run
def add_point(scores, player):
    scores[player] = scores.get(player, 0) + 1   # changes the caller''s dict

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
assert s["played"] == 1, f"After one game, \"played\" should be 1, but it''s {s[''played'']}. Update the dictionary you were given (e.g. stats[\"played\"] += 1)."
assert s["won"] == 1 and s["streak"] == 1, f"After one win, \"won\" and \"streak\" should both be 1, but stats are {s}."
s = new_stats()
for res in [3, 5, None, 2, 4, 6, None, 1]:
    update_stats(s, res)
expected = {"played": 8, "won": 6, "streak": 1, "best_streak": 3}
assert s == expected, f"After the results [3, 5, None, 2, 4, 6, None, 1] the stats should be {expected}, but they are {s}."
s = new_stats()
for res in [None, 1, 1, None]:
    update_stats(s, res)
assert s == {"played": 4, "won": 2, "streak": 0, "best_streak": 2}, f"After [None, 1, 1, None] the stats should be {{''played'': 4, ''won'': 2, ''streak'': 0, ''best_streak'': 2}}, but they are {s}."
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
assert st["played"] == 3, f"The player answered ''y'', then ''YES'', then ''no'', so 3 games should be played, but stats show {st[''played'']}. Look closely at the `if again ...` condition: what does `or \"no\"` do on its own?"
assert st == {"played": 3, "won": 3, "streak": 3, "best_streak": 3}, f"After winning 3 games the stats should be {{''played'': 3, ''won'': 3, ''streak'': 3, ''best_streak'': 3}}, but they are {st}."
r = _random.Random(4)
first = pick_secret(WORDS, r)
st = _session(4, [first, " N "])
assert st["played"] == 1, f"Answering ''N'' should stop after one game, but {st[''played'']} were played."
r = _random.Random(6)
wrong = [w for w in WORDS if w != pick_secret(WORDS, r)][:6]
st = _session(6, wrong + ["n"])
assert st == {"played": 1, "won": 0, "streak": 0, "best_streak": 0}, f"One lost game, then ''n'', should give {{''played'': 1, ''won'': 0, ''streak'': 0, ''best_streak'': 0}}, but got {st}."
_queued.clear()
--- hint
Run it: you answered `y`, yet only one game was played. Use **Debug** and step onto the `if again ...` line. What is `again` there, and which way does the `if` go?
--- hint
`again == "n" or "no"` means `(again == "n") or ("no")`, and a non-empty string is always truthy (lesson 7). Compare `again` against each answer separately, or check `again in ("n", "no")`.
```

## Play a full session

Here''s the finished game, assembled from your pieces. The first cell defines the two loops; the second queues up a player''s answers (including a typo) and plays a whole session with seed `5`.

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
print(f"Played {stats[''played'']}, won {stats[''won'']} ({100 * stats[''won''] // stats[''played'']}%), best streak {stats[''best_streak'']}")
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
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_python_basics_8_3', 'sec_python_basics_8', 'crs_python_basics', 'Project: budget tracker with classes and JSON', 'interactive', 2, 1500, NULL, NULL, 'Where did all the money go this month? Almost everyone has asked that question, and the apps that answer it (Mint, YNAB, your bank''s "insights" tab) are, at their core, a list of transactions plus a few clever ways to add them up. In this final project you''ll build your own: a **budget tracker** that records income and expenses, refuses bad data, knows its balance, breaks spending down by category and by month, finds your biggest expenses, and saves everything to a JSON file so nothing is lost when the program stops.

This is the project where your classes earn their keep. A `Transaction` is a small record type, a `Budget` owns a list of them and knows how to answer questions about them, and the rest of the program just talks to the `Budget`. It''s the same shape as real-world software, from banking backends to web shops, and it uses nearly everything you''ve learned in this course.

> **How this project works:** each step is a challenge that adds one piece to the two classes. Challenges run on their own, so each one includes the finished parts it needs from earlier steps. At the end you''ll run the whole tracker, save it, load it back, and print a monthly report.

```python setup
# Two months of Maya''s finances: (date, description, amount, category, kind)
SAMPLE = [
    ("2026-03-01", "Salary", 3200.00, "salary", "income"),
    ("2026-03-02", "Rent", 1150.00, "housing", "expense"),
    ("2026-03-05", "Groceries", 84.30, "food", "expense"),
    ("2026-03-09", "Train pass", 92.00, "transport", "expense"),
    ("2026-03-14", "Concert tickets", 120.00, "fun", "expense"),
    ("2026-03-19", "Groceries", 61.75, "food", "expense"),
    ("2026-03-23", "Freelance logo", 450.00, "side gig", "income"),
    ("2026-03-28", "Dinner out", 58.40, "food", "expense"),
    ("2026-04-01", "Salary", 3200.00, "salary", "income"),
    ("2026-04-02", "Rent", 1150.00, "housing", "expense"),
    ("2026-04-06", "Groceries", 77.10, "food", "expense"),
    ("2026-04-11", "Bike repair", 145.00, "transport", "expense"),
]
```

## The plan

Two classes, each with a clear job:

```text
Transaction  (a @dataclass: one line on a bank statement)
  date, description, amount, category, kind ("income" or "expense")
  .signed            → +amount for income, -amount for expenses

Budget  (owns the list, answers questions)
  .add(...)          → validates, then records a Transaction
  .balance           → everything in minus everything out
  .spending_by_category()   .monthly_summary(month)   .top_expenses(n)
  .save(path)  /  load_budget(path)  → JSON on disk
```

The setup has loaded `SAMPLE`: two months of transactions for Maya, a designer with a day job and a side gig. Each row is a tuple in the same order as the `Transaction` fields.

```python run
print(len(SAMPLE), "transactions")
for row in SAMPLE[:3]:
    print(row)
```

## Step 1: the Transaction record

A transaction is pure data with a fixed set of fields: exactly what `@dataclass` (lesson 27) was made for. It writes `__init__`, `__repr__` and `__eq__` for you.

Amounts are always stored as **positive** numbers, and `kind` says which way the money moved. That keeps the data easy to read ("Rent: 1150, expense"), and a `signed` property turns it into a plus-or-minus number whenever you need to do math. For printing, a negative number with a thousands separator lines up nicely with a format spec:

```python run
for amount in [3200.0, -1150.0, -84.3]:
    print(f"[{amount:>10,.2f}]")
```

```python predict id=predict-signed-format title="Formatting a negative amount"
print(f"[{-1150:>10,.2f}]")
--- options
[-1150.00]
* [ -1,150.00]
[-1,150.00 ]
[  -1150.00]
--- explain
`,` adds a thousands separator and `.2f` gives two decimals, so the number becomes `-1,150.00`. That''s 9 characters, and `>10` right-aligns it in a field of 10 by adding one space on the left. The minus sign counts as a character.
```

```python exercise id=transaction-dataclass title="Build the Transaction record"
from dataclasses import dataclass

@dataclass
class Transaction:
    date: str          # "YYYY-MM-DD"
    description: str
    amount: float      # always positive
    category: str
    kind: str          # "income" or "expense"

    @property
    def signed(self):
        """The amount with a sign: positive for income, negative for an expense."""
        # TODO: return the signed amount
        ...

    def __str__(self):
        """One statement line: the date, two spaces, the description left-aligned
        in 16 characters, the signed amount right-aligned in 10 characters with
        commas and 2 decimals, two spaces, then the category in parentheses."""
        # TODO: replace the placeholder with an f-string built from the spec above
        return "TODO"

rent = Transaction("2026-03-02", "Rent", 1150.0, "housing", "expense")
print(rent.signed)
print(rent)
--- solution
from dataclasses import dataclass

@dataclass
class Transaction:
    date: str          # "YYYY-MM-DD"
    description: str
    amount: float      # always positive
    category: str
    kind: str          # "income" or "expense"

    @property
    def signed(self):
        """The amount with a sign: positive for income, negative for an expense."""
        return self.amount if self.kind == "income" else -self.amount

    def __str__(self):
        """One statement line: the date, two spaces, the description left-aligned
        in 16 characters, the signed amount right-aligned in 10 characters with
        commas and 2 decimals, two spaces, then the category in parentheses."""
        return f"{self.date}  {self.description:<16}{self.signed:>10,.2f}  ({self.category})"

rent = Transaction("2026-03-02", "Rent", 1150.0, "housing", "expense")
print(rent.signed)
print(rent)
--- test
rent = Transaction("2026-03-02", "Rent", 1150.0, "housing", "expense")
pay = Transaction("2026-03-01", "Salary", 3200.0, "salary", "income")
assert rent.signed is not None and rent.signed is not ..., "`signed` returns nothing yet. Replace the `...` with a `return` statement."
assert rent.signed == -1150.0, f"An expense of 1150 should have signed == -1150.0, but got {rent.signed!r}."
assert pay.signed == 3200.0, f"An income of 3200 should have signed == 3200.0, but got {pay.signed!r}."
assert str(rent) != "TODO", "Replace the placeholder `return \"TODO\"` in `__str__` with your f-string."
assert isinstance(str(rent), str), "`__str__` must return a string."
for t in [rent, pay, Transaction("2026-04-11", "Bike repair", 145.5, "transport", "expense")]:
    expected = f"{t.date}  {t.description:<16}{t.signed:>10,.2f}  ({t.category})"
    assert str(t) == expected, f"str() should give {expected!r}, but gave {str(t)!r}. Check the widths (:<16 and :>10,.2f), the two-space gaps and the parentheses."
--- hint
`signed` is a one-line conditional expression: the amount if `self.kind == "income"`, otherwise its negative.
--- hint
For `__str__`, use `{self.description:<16}` and `{self.signed:>10,.2f}` inside one f-string, with two spaces after the date and before the `(category)`.
```

## Step 2: a Budget that refuses bad data

A budget is only as trustworthy as the data in it. A negative expense, an amount typed as text or a misspelled kind like `"expence"` would quietly poison every total. So the `add` method acts like a bouncer: it checks everything first and **raises a `ValueError`** (lesson 23) for anything invalid, before it ever touches the list.

```python run error
def deposit(balance, amount):
    if amount <= 0:
        raise ValueError(f"amount must be positive, not {amount}")
    return balance + amount

print(deposit(100, 25))
print(deposit(100, -40))
```

The first call works; the second stops the program with your own message, pointing at the exact problem. That''s much better than a wrong balance discovered weeks later. The code that *calls* `add` decides what to do about it, usually with `try`/`except`.

> **Pitfall:** Check the type **before** comparing. `"50" <= 0` raises a confusing `TypeError`, but `not isinstance(amount, (int, float)) or amount <= 0` short-circuits (lesson 7): if the amount isn''t a number, the comparison never runs.

```python exercise id=budget-add title="Add transactions, with validation"
from dataclasses import dataclass

@dataclass
class Transaction:  # Step 1 (without __str__)
    date: str
    description: str
    amount: float
    category: str
    kind: str

class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []

    def add(self, date, description, amount, category, kind):
        """Validate, then record a new Transaction and return it."""
        # TODO 1: raise ValueError if kind is not "income" or "expense"
        # TODO 2: raise ValueError if amount is not a number (int or float) greater than 0
        # TODO 3: create a Transaction (store the amount as a float),
        #         append it to self.transactions, and return it
        ...

budget = Budget("Maya")
budget.add("2026-03-01", "Salary", 3200, "salary", "income")
try:
    budget.add("2026-03-02", "Oops", -50, "food", "expense")
except ValueError as e:
    print("rejected:", e)
print(len(budget.transactions), "transaction(s) recorded")
--- solution
from dataclasses import dataclass

@dataclass
class Transaction:  # Step 1 (without __str__)
    date: str
    description: str
    amount: float
    category: str
    kind: str

class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []

    def add(self, date, description, amount, category, kind):
        """Validate, then record a new Transaction and return it."""
        if kind not in ("income", "expense"):
            raise ValueError(f"kind must be ''income'' or ''expense'', not {kind!r}")
        if not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError(f"amount must be a positive number, not {amount!r}")
        t = Transaction(date, description, float(amount), category, kind)
        self.transactions.append(t)
        return t

budget = Budget("Maya")
budget.add("2026-03-01", "Salary", 3200, "salary", "income")
try:
    budget.add("2026-03-02", "Oops", -50, "food", "expense")
except ValueError as e:
    print("rejected:", e)
print(len(budget.transactions), "transaction(s) recorded")
--- test
b = Budget("Test")
t = b.add("2026-05-01", "Paycheck", 2000, "salary", "income")
assert len(b.transactions) == 1, f"After one valid add, `transactions` should hold 1 item, but holds {len(b.transactions)}. Append the new Transaction."
assert t is not None, "`add` should return the Transaction it created."
assert isinstance(t, Transaction), f"`add` should return a Transaction, but returned {t!r}."
assert t == Transaction("2026-05-01", "Paycheck", 2000.0, "salary", "income"), f"The recorded transaction looks wrong: {t!r}."
assert isinstance(t.amount, float), f"Store the amount as a float (2000 becomes 2000.0), but it''s {t.amount!r}."
bad = [(-50, "expense", "a negative amount"), (0, "expense", "an amount of 0"), ("50", "expense", "an amount given as text"),
       (25, "expence", "the misspelled kind ''expence''"), (25, "refund", "the kind ''refund''")]
for amount, kind, why in bad:
    before = len(b.transactions)
    try:
        b.add("2026-05-02", "Bad", amount, "food", kind)
    except ValueError:
        pass
    except TypeError:
        raise AssertionError(f"`add` crashed with TypeError for {why}. Check the type with isinstance BEFORE comparing to 0, and raise ValueError.")
    else:
        raise AssertionError(f"`add` accepted {why}. It should raise ValueError.")
    assert len(b.transactions) == before, f"`add` raised for {why}, but only after appending it. Validate first."
b.add("2026-05-03", "Coffee", 3.5, "food", "expense")
assert len(b.transactions) == 2, "Valid adds should still work after rejected ones."
--- hint
`if kind not in ("income", "expense"): raise ValueError("...")` handles TODO 1. Put both checks at the top of the method, before anything is appended.
--- hint
For TODO 2: `if not isinstance(amount, (int, float)) or amount <= 0: raise ValueError(...)`. Then build `Transaction(date, description, float(amount), category, kind)`, append it, and return it.
```

## Step 3: two budgets, one history?

Maya''s roommate Leo wants a budget too. The code below creates one for each of them, but something is very wrong: Leo can see Maya''s rent.

```python debug id=shared-history title="Every budget shows everyone''s transactions"
from dataclasses import dataclass

@dataclass
class Transaction:
    date: str
    description: str
    amount: float
    category: str
    kind: str

class Budget:
    transactions = []      # the budget''s history

    def __init__(self, owner):
        self.owner = owner

    def add(self, date, description, amount, category, kind):  # Step 2 (validation shortened)
        if kind not in ("income", "expense") or not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError("invalid transaction")
        t = Transaction(date, description, float(amount), category, kind)
        self.transactions.append(t)
        return t

maya = Budget("Maya")
leo = Budget("Leo")
maya.add("2026-03-02", "Rent", 1150, "housing", "expense")
leo.add("2026-03-04", "Gym", 35, "health", "expense")
print("Maya has", len(maya.transactions), "transactions")
print("Leo has", len(leo.transactions), "transactions")
--- solution
from dataclasses import dataclass

@dataclass
class Transaction:
    date: str
    description: str
    amount: float
    category: str
    kind: str

class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []      # each budget''s own history

    def add(self, date, description, amount, category, kind):  # Step 2 (validation shortened)
        if kind not in ("income", "expense") or not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError("invalid transaction")
        t = Transaction(date, description, float(amount), category, kind)
        self.transactions.append(t)
        return t

maya = Budget("Maya")
leo = Budget("Leo")
maya.add("2026-03-02", "Rent", 1150, "housing", "expense")
leo.add("2026-03-04", "Gym", 35, "health", "expense")
print("Maya has", len(maya.transactions), "transactions")
print("Leo has", len(leo.transactions), "transactions")
--- test
a = Budget("A")
b = Budget("B")
a.add("2026-06-01", "Book", 12, "fun", "expense")
assert len(b.transactions) == 0, f"Budget B is brand new, but it already holds {len(b.transactions)} transaction(s) added to budget A. Are both budgets sharing one list?"
assert a.transactions is not b.transactions, "Two budgets still share the same `transactions` list object."
assert len(a.transactions) == 1, f"Budget A should hold exactly the 1 transaction added to it, but holds {len(a.transactions)}."
assert [t.description for t in maya.transactions] == ["Rent"], "Maya''s budget should contain only her rent."
assert [t.description for t in leo.transactions] == ["Gym"], "Leo''s budget should contain only his gym membership."
--- hint
Run it: both budgets report 2 transactions. Where is the `transactions` list created, and how many times does that line run?
--- hint
A list written in the class body is a **class attribute**: one list shared by every instance (lesson 26). Give each budget its own list by creating it in `__init__` with `self.transactions = []`.
```

## Step 4: the balance

The balance is everything that came in minus everything that went out. Since `signed` already carries the direction, it''s just a sum.

It should be a **property** (lesson 27), not a stored number. A stored balance would have to be updated by every method that adds or removes a transaction, and one forgotten update would make it wrong forever. A property is computed fresh from the transactions every time you read it, so it can never drift out of sync.

```python predict id=predict-live-property title="Is the property up to date?"
class Jar:
    def __init__(self):
        self.coins = [5, 10]

    @property
    def total(self):
        return sum(self.coins)

jar = Jar()
jar.coins.append(20)
print(jar.total)
--- options
15
* 35
<bound method Jar.total of <__main__.Jar object>>
TypeError: ''int'' object is not callable
--- explain
A property runs its code **every time** you read it, so `jar.total` sums the list as it is right now, including the 20 added after the jar was created: `35`. And because it''s a property, you read it like an attribute, with no parentheses.
```

Adding up values that pass a test is a one-liner with a generator expression (lesson 18) inside `sum`:

```python run
amounts = [(3200.0, "income"), (1150.0, "expense"), (84.3, "expense")]
print("money out:", sum(a for a, kind in amounts if kind == "expense"))
```

```python exercise id=balance-property title="Add balance and totals"
from dataclasses import dataclass

@dataclass
class Transaction:  # Step 1
    date: str
    description: str
    amount: float
    category: str
    kind: str

    @property
    def signed(self):
        return self.amount if self.kind == "income" else -self.amount

class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []

    def add(self, date, description, amount, category, kind):  # Step 2 (validation shortened)
        if kind not in ("income", "expense") or not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError("invalid transaction")
        self.transactions.append(Transaction(date, description, float(amount), category, kind))

    def total(self, kind):
        """Return the sum of the amounts of all transactions of this kind ("income" or "expense")."""
        # TODO
        ...

    # TODO: add a `balance` PROPERTY: the sum of every transaction''s signed amount

budget = Budget("Maya")
for row in SAMPLE:
    budget.add(*row)
print("income:  ", budget.total("income"))
print("expenses:", budget.total("expense"))
--- solution
from dataclasses import dataclass

@dataclass
class Transaction:  # Step 1
    date: str
    description: str
    amount: float
    category: str
    kind: str

    @property
    def signed(self):
        return self.amount if self.kind == "income" else -self.amount

class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []

    def add(self, date, description, amount, category, kind):  # Step 2 (validation shortened)
        if kind not in ("income", "expense") or not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError("invalid transaction")
        self.transactions.append(Transaction(date, description, float(amount), category, kind))

    def total(self, kind):
        """Return the sum of the amounts of all transactions of this kind ("income" or "expense")."""
        return sum(t.amount for t in self.transactions if t.kind == kind)

    @property
    def balance(self):
        return sum(t.signed for t in self.transactions)

budget = Budget("Maya")
for row in SAMPLE:
    budget.add(*row)
print("income:  ", budget.total("income"))
print("expenses:", budget.total("expense"))
print("balance: ", budget.balance)
--- test
b = Budget("Test")
b.add("2026-07-01", "Pay", 1000, "salary", "income")
b.add("2026-07-02", "Food", 120.5, "food", "expense")
b.add("2026-07-03", "Bus", 30, "transport", "expense")
inc = b.total("income")
assert inc is not None, "`total` returns None. Replace the `...` with a `return` statement."
assert abs(inc - 1000) < 1e-9, f"total(''income'') should be 1000.0, but got {inc!r}."
assert abs(b.total("expense") - 150.5) < 1e-9, f"total(''expense'') should be 150.5, but got {b.total(''expense'')!r}."
assert "balance" in vars(Budget), "Add a `balance` property to the Budget class."
assert isinstance(vars(Budget)["balance"], property), "`balance` should be a @property, so it''s read as `budget.balance` with no parentheses. Put `@property` on the line above `def balance(self):`."
assert abs(b.balance - 849.5) < 1e-9, f"The balance should be 1000 - 120.5 - 30 = 849.5, but got {b.balance!r}."
b.add("2026-07-04", "Gift", 50, "gifts", "income")
assert abs(b.balance - 899.5) < 1e-9, "After another income of 50, the balance should update to 899.5. Compute it from the transactions each time."
m = Budget("Maya")
for row in SAMPLE:
    m.add(*row)
assert round(m.balance, 2) == 3911.45, f"Maya''s balance from SAMPLE should be 3911.45, but got {m.balance!r}."
--- hint
`total` is a `sum(...)` over `t.amount` for each transaction `t` whose `t.kind == kind`.
--- hint
For the balance: `@property` on one line, then `def balance(self):` returning `sum(t.signed for t in self.transactions)`.
```

> **In the wild:** real finance software never stores money as `float`. `0.1 + 0.2` isn''t exactly `0.3` (lesson 4), and over thousands of transactions those tiny errors add up to missing cents. Banks use the `decimal` module''s `Decimal` type, or store whole **cents** as integers. Floats are fine for learning, and we round for display, but now you know why your bank doesn''t.

## Step 5: where does the money go?

The most useful question a budget answers is "what am I spending on?" That''s the grouping-and-summing pattern from lesson 16: a dictionary from category to total, built in one loop.

A plain dictionary keeps keys in the order they were first added. For a report you want the biggest category first, so sort the `(category, total)` pairs by their total and rebuild the dictionary from them:

```python run
totals = {"food": 281.55, "housing": 2300.0, "fun": 120.0}

ordered = sorted(totals.items(), key=lambda pair: pair[1], reverse=True)
print(ordered)
dict(ordered)
```

```python exercise id=category-totals title="Spending by category"
from dataclasses import dataclass

@dataclass
class Transaction:  # Step 1 (without the extras)
    date: str
    description: str
    amount: float
    category: str
    kind: str

class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []

    def add(self, date, description, amount, category, kind):  # Step 2 (validation shortened)
        if kind not in ("income", "expense") or not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError("invalid transaction")
        self.transactions.append(Transaction(date, description, float(amount), category, kind))

    def spending_by_category(self):
        """Return {category: total spent} for EXPENSES only.

        Round each total to 2 decimals, and order the dict from the biggest total to the smallest.
        """
        totals = {}
        # TODO 1: add up each expense''s amount under its category
        # TODO 2: return a dict with rounded totals, biggest first
        ...

budget = Budget("Maya")
for row in SAMPLE:
    budget.add(*row)
print(budget.spending_by_category())
--- solution
from dataclasses import dataclass

@dataclass
class Transaction:  # Step 1 (without the extras)
    date: str
    description: str
    amount: float
    category: str
    kind: str

class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []

    def add(self, date, description, amount, category, kind):  # Step 2 (validation shortened)
        if kind not in ("income", "expense") or not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError("invalid transaction")
        self.transactions.append(Transaction(date, description, float(amount), category, kind))

    def spending_by_category(self):
        """Return {category: total spent} for EXPENSES only.

        Round each total to 2 decimals, and order the dict from the biggest total to the smallest.
        """
        totals = {}
        for t in self.transactions:
            if t.kind == "expense":
                totals[t.category] = totals.get(t.category, 0) + t.amount
        ordered = sorted(totals.items(), key=lambda pair: pair[1], reverse=True)
        return {category: round(total, 2) for category, total in ordered}

budget = Budget("Maya")
for row in SAMPLE:
    budget.add(*row)
print(budget.spending_by_category())
--- test
m = Budget("Maya")
for row in SAMPLE:
    m.add(*row)
got = m.spending_by_category()
assert got is not None, "`spending_by_category` returns None. Finish the TODOs and `return` the dictionary."
assert isinstance(got, dict), f"`spending_by_category` should return a dict, but returned {type(got).__name__}."
assert "salary" not in got and "side gig" not in got, f"Only expenses count, but your totals include income categories: {got}."
expected = {"housing": 2300.0, "food": 281.55, "transport": 237.0, "fun": 120.0}
assert got == expected, f"Expected {expected}, but got {got}. Add every expense into its category, and round each total to 2 decimals."
assert list(got) == list(expected), f"The categories should go from biggest to smallest total: {list(expected)}, but yours are in the order {list(got)}."
b = Budget("Test")
b.add("2026-08-01", "Pay", 900, "salary", "income")
for desc, amount, cat in [("Cinema", 12.5, "fun"), ("Lunch", 9.99, "food"), ("Arcade", 20, "fun"), ("Dinner", 30.02, "food")]:
    b.add("2026-08-02", desc, amount, cat, "expense")
got2 = b.spending_by_category()
assert got2 == {"food": 40.01, "fun": 32.5} and list(got2) == ["food", "fun"], f"For a different budget expected {{''food'': 40.01, ''fun'': 32.5}} (food first), but got {got2}."
--- hint
TODO 1 is the counting pattern with amounts instead of 1: `totals[t.category] = totals.get(t.category, 0) + t.amount`, only when `t.kind == "expense"`.
--- hint
For TODO 2, sort `totals.items()` with `key=lambda pair: pair[1], reverse=True`, then build the result with a dict comprehension that rounds each total.
```

## Step 6: one month at a time

People think about money month by month. Because the dates are stored as `"YYYY-MM-DD"` strings, "all transactions in March 2026" is simply those whose date **starts with** `"2026-03"`:

```python run
dates = ["2026-03-01", "2026-03-28", "2026-04-02", "2025-03-15"]
print([d for d in dates if d.startswith("2026-03")])
```

> **Tip:** Dates written year-month-day (the ISO 8601 format) sort correctly even as plain strings, because the most significant part comes first. That''s why programmers love them. For real date arithmetic, like "30 days from now", convert to `datetime.date` objects (lesson 25).

```python exercise id=month-summary title="Summarize a month"
from dataclasses import dataclass

@dataclass
class Transaction:  # Step 1 (without the extras)
    date: str
    description: str
    amount: float
    category: str
    kind: str

class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []

    def add(self, date, description, amount, category, kind):  # Step 2 (validation shortened)
        if kind not in ("income", "expense") or not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError("invalid transaction")
        self.transactions.append(Transaction(date, description, float(amount), category, kind))

    def monthly_summary(self, month):
        """month is a "YYYY-MM" string. Return a dict with three keys,
        each rounded to 2 decimals:
          "income":   total income that month
          "expenses": total expenses that month
          "net":      income minus expenses
        """
        # TODO: only count transactions whose date starts with `month`
        ...

budget = Budget("Maya")
for row in SAMPLE:
    budget.add(*row)
print("March:", budget.monthly_summary("2026-03"))
print("April:", budget.monthly_summary("2026-04"))
--- solution
from dataclasses import dataclass

@dataclass
class Transaction:  # Step 1 (without the extras)
    date: str
    description: str
    amount: float
    category: str
    kind: str

class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []

    def add(self, date, description, amount, category, kind):  # Step 2 (validation shortened)
        if kind not in ("income", "expense") or not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError("invalid transaction")
        self.transactions.append(Transaction(date, description, float(amount), category, kind))

    def monthly_summary(self, month):
        """month is a "YYYY-MM" string. Return a dict with three keys,
        each rounded to 2 decimals:
          "income":   total income that month
          "expenses": total expenses that month
          "net":      income minus expenses
        """
        in_month = [t for t in self.transactions if t.date.startswith(month)]
        income = sum(t.amount for t in in_month if t.kind == "income")
        expenses = sum(t.amount for t in in_month if t.kind == "expense")
        return {"income": round(income, 2), "expenses": round(expenses, 2), "net": round(income - expenses, 2)}

budget = Budget("Maya")
for row in SAMPLE:
    budget.add(*row)
print("March:", budget.monthly_summary("2026-03"))
print("April:", budget.monthly_summary("2026-04"))
--- test
m = Budget("Maya")
for row in SAMPLE:
    m.add(*row)
march = m.monthly_summary("2026-03")
assert march is not None, "`monthly_summary` returns None. Replace the `...` and `return` a dictionary."
assert isinstance(march, dict), f"`monthly_summary` should return a dict, but returned {type(march).__name__}."
missing = [k for k in ["income", "expenses", "net"] if k not in march]
assert not missing, f"The summary is missing the key(s) {missing}."
assert march == {"income": 3650.0, "expenses": 1566.45, "net": 2083.55}, f"March 2026 should be {{''income'': 3650.0, ''expenses'': 1566.45, ''net'': 2083.55}}, but got {march}. Count only dates that start with ''2026-03''."
april = m.monthly_summary("2026-04")
assert april == {"income": 3200.0, "expenses": 1372.1, "net": 1827.9}, f"April 2026 should be {{''income'': 3200.0, ''expenses'': 1372.1, ''net'': 1827.9}}, but got {april}."
assert m.monthly_summary("2026-05") == {"income": 0, "expenses": 0, "net": 0}, f"A month with no transactions should give all zeros, but got {m.monthly_summary(''2026-05'')}."
b = Budget("Test")
b.add("2025-03-10", "Old pay", 500, "salary", "income")
b.add("2026-03-10", "New pay", 800, "salary", "income")
assert b.monthly_summary("2026-03")["income"] == 800, "March 2025 is not March 2026. Match the whole \"YYYY-MM\" at the start of the date."
--- hint
First filter: `[t for t in self.transactions if t.date.startswith(month)]`. Then sum the income and the expenses separately from that list.
--- hint
Build the result as `{"income": round(income, 2), "expenses": round(expenses, 2), "net": round(income - expenses, 2)}`.
```

## Step 7: the biggest expenses

"Show me my three biggest expenses" is a filter plus a sort. `sorted` with a `key` (lesson 22) can order the `Transaction` objects by any attribute:

```python run
items = [("Rent", 1150.0), ("Groceries", 84.3), ("Concert", 120.0)]
print(sorted(items, key=lambda item: item[1]))
print(sorted(items, key=lambda item: item[1], reverse=True)[:2])
```

Maya''s tracker has a `top_expenses` method, but its answers are useless.

```python debug id=top-expenses title="The top expenses list shows the smallest purchases"
from dataclasses import dataclass

@dataclass
class Transaction:
    date: str
    description: str
    amount: float
    category: str
    kind: str

class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []

    def add(self, date, description, amount, category, kind):  # Step 2 (validation shortened)
        if kind not in ("income", "expense") or not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError("invalid transaction")
        self.transactions.append(Transaction(date, description, float(amount), category, kind))

    def top_expenses(self, n=3):
        """Return the n largest EXPENSES, biggest first."""
        return sorted(self.transactions, key=lambda t: t.amount)[:n]

budget = Budget("Maya")
for row in SAMPLE:
    budget.add(*row)
for t in budget.top_expenses():
    print(t.description, t.amount)
--- solution
from dataclasses import dataclass

@dataclass
class Transaction:
    date: str
    description: str
    amount: float
    category: str
    kind: str

class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []

    def add(self, date, description, amount, category, kind):  # Step 2 (validation shortened)
        if kind not in ("income", "expense") or not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError("invalid transaction")
        self.transactions.append(Transaction(date, description, float(amount), category, kind))

    def top_expenses(self, n=3):
        """Return the n largest EXPENSES, biggest first."""
        expenses = [t for t in self.transactions if t.kind == "expense"]
        return sorted(expenses, key=lambda t: t.amount, reverse=True)[:n]

budget = Budget("Maya")
for row in SAMPLE:
    budget.add(*row)
for t in budget.top_expenses():
    print(t.description, t.amount)
--- test
m = Budget("Maya")
for row in SAMPLE:
    m.add(*row)
top = m.top_expenses()
amounts = [t.amount for t in top]
assert len(top) == 3, f"top_expenses() should return 3 transactions by default, but returned {len(top)}."
assert not (amounts == sorted(amounts) and amounts[0] < amounts[-1]), f"The amounts {amounts} go from smallest to biggest. The biggest should come first."
assert all(t.kind == "expense" for t in top), f"Income snuck into the top expenses: {[t.description for t in top]}. Only expenses should count."
assert amounts == [1150.0, 1150.0, 145.0], f"Maya''s top 3 expenses should be 1150.0, 1150.0 and 145.0, but got {amounts}."
b = Budget("Test")
b.add("2026-09-01", "Pay", 5000, "salary", "income")
for desc, amount in [("Snack", 4), ("Laptop", 1299), ("Book", 25), ("Phone", 699)]:
    b.add("2026-09-02", desc, amount, "stuff", "expense")
assert [t.description for t in b.top_expenses(2)] == ["Laptop", "Phone"], f"For another budget, top_expenses(2) should be Laptop then Phone, but got {[t.description for t in b.top_expenses(2)]}."
--- hint
Run it: you get the three *smallest* purchases. What order does `sorted` use unless you tell it otherwise?
--- hint
Two fixes: sort with `reverse=True`, and only sort the transactions whose `kind` is `"expense"`, otherwise Maya''s salary tops the list.
```

## Step 8: save and load with JSON

A budget that vanishes when the program ends isn''t much use. JSON (lesson 24) can store dictionaries, lists, strings and numbers, but not your own classes, so saving means converting each `Transaction` into a plain dictionary first. The `dataclasses` module has a function for exactly that:

```python run
from dataclasses import dataclass, asdict
import json

@dataclass
class Point:
    city: str
    temp: float

d = asdict(Point("Lisbon", 24.5))
print(d)
print(json.dumps({"readings": [d]}))
```

JSON only knows a few types, so some things change shape on the round trip. Predict this one:

```python predict id=predict-json-roundtrip title="What comes back from JSON?"
import json

saved = json.dumps({"amount": 12.5, "tags": ("food", "weekly")})
print(json.loads(saved))
--- options
{''amount'': 12.5, ''tags'': (''food'', ''weekly'')}
* {''amount'': 12.5, ''tags'': [''food'', ''weekly'']}
{"amount": 12.5, "tags": ["food", "weekly"]}
{''amount'': ''12.5'', ''tags'': [''food'', ''weekly'']}
--- explain
JSON has arrays but no tuples, so the tuple is saved as an array and **comes back as a list**. Numbers stay numbers. And `json.loads` returns a real Python dict, which prints with single quotes; the double-quoted text is what `json.dumps` produces.
```

Loading is the reverse: read the dictionaries back and turn each one into a transaction again. The neat trick is that each saved dictionary has exactly the keys `add` takes as parameters, so `**` unpacking (lesson 20) passes them all at once: `budget.add(**t)`. Even better, loading through `add` means **a corrupted file can''t sneak bad data past your validation.**

```python exercise id=save-load title="Save to JSON and load it back"
from dataclasses import dataclass, asdict
import json

@dataclass
class Transaction:
    date: str
    description: str
    amount: float
    category: str
    kind: str

class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []

    def add(self, date, description, amount, category, kind):  # Step 2 (validation shortened)
        if kind not in ("income", "expense") or not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError("invalid transaction")
        self.transactions.append(Transaction(date, description, float(amount), category, kind))

    def save(self, path):
        """Write {"owner": ..., "transactions": [ {...}, ... ]} to path as JSON (indent=2)."""
        # TODO: build the dict (use asdict for each transaction) and json.dump it
        ...

def load_budget(path):
    """Read a file written by Budget.save and return a new Budget with the same data."""
    # TODO: json.load the file, create a Budget for the owner, and add each transaction
    ...

budget = Budget("Maya")
for row in SAMPLE:
    budget.add(*row)
budget.save("maya_budget.json")
copy = load_budget("maya_budget.json")
print(copy)
--- solution
from dataclasses import dataclass, asdict
import json

@dataclass
class Transaction:
    date: str
    description: str
    amount: float
    category: str
    kind: str

class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []

    def add(self, date, description, amount, category, kind):  # Step 2 (validation shortened)
        if kind not in ("income", "expense") or not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError("invalid transaction")
        self.transactions.append(Transaction(date, description, float(amount), category, kind))

    def save(self, path):
        """Write {"owner": ..., "transactions": [ {...}, ... ]} to path as JSON (indent=2)."""
        data = {"owner": self.owner, "transactions": [asdict(t) for t in self.transactions]}
        with open(path, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=2)

def load_budget(path):
    """Read a file written by Budget.save and return a new Budget with the same data."""
    with open(path, encoding="utf-8") as f:
        data = json.load(f)
    budget = Budget(data["owner"])
    for t in data["transactions"]:
        budget.add(**t)
    return budget

budget = Budget("Maya")
for row in SAMPLE:
    budget.add(*row)
budget.save("maya_budget.json")
copy = load_budget("maya_budget.json")
print(copy.owner, len(copy.transactions), "transactions")
--- test
import os
if os.path.exists("check_budget.json"):
    os.remove("check_budget.json")
b = Budget("Lin")
b.add("2026-10-01", "Pay", 1800, "salary", "income")
b.add("2026-10-03", "Rent", 700, "housing", "expense")
b.add("2026-10-05", "Tea", 4.25, "food", "expense")
b.save("check_budget.json")
assert os.path.exists("check_budget.json"), "`save` didn''t create the file. Open `path` in ''w'' mode and json.dump into it."
with open("check_budget.json", encoding="utf-8") as f:
    text = f.read()
try:
    data = json.loads(text)
except ValueError:
    raise AssertionError("The saved file isn''t valid JSON. Use json.dump(data, f, indent=2).")
assert isinstance(data, dict) and data.get("owner") == "Lin", f"The file should hold a dict with \"owner\": \"Lin\", but holds {data!r}."
assert isinstance(data.get("transactions"), list) and len(data["transactions"]) == 3, "The file''s \"transactions\" should be a list with one dict per transaction."
assert data["transactions"][2] == {"date": "2026-10-05", "description": "Tea", "amount": 4.25, "category": "food", "kind": "expense"}, f"Each transaction should be saved as a dict of its fields, but the last one is {data[''transactions''][2]!r}."
assert "\n  " in text, "Pass indent=2 to json.dump so the file is readable."
loaded = load_budget("check_budget.json")
assert loaded is not None, "`load_budget` returns None. Build a Budget from the file and `return` it."
assert isinstance(loaded, Budget), f"`load_budget` should return a Budget, but returned {type(loaded).__name__}."
assert loaded.owner == "Lin", f"The loaded budget''s owner should be ''Lin'', but is {loaded.owner!r}."
assert loaded.transactions == b.transactions, "The loaded transactions should equal the saved ones, in the same order."
assert loaded is not b and loaded.transactions is not b.transactions, "`load_budget` should build a NEW Budget from the file."
with open("check_bad.json", "w", encoding="utf-8") as f:
    json.dump({"owner": "Eve", "transactions": [{"date": "2026-10-01", "description": "Hack", "amount": -999, "category": "x", "kind": "income"}]}, f)
try:
    load_budget("check_bad.json")
except ValueError:
    pass
else:
    raise AssertionError("A file with a negative amount loaded without complaint. Add each transaction back through `add`, so validation runs.")
--- hint
In `save`: `data = {"owner": self.owner, "transactions": [asdict(t) for t in self.transactions]}`, then open `path` with `"w"` and `json.dump(data, f, indent=2)`.
--- hint
In `load_budget`: `json.load` the file, create `Budget(data["owner"])`, then loop over `data["transactions"]` calling `budget.add(**t)` for each one. Don''t forget to return the budget.
```

## The finished tracker

Here''s the complete program, assembled from your steps. First the record type:

```python run
from dataclasses import dataclass, asdict
import json

@dataclass
class Transaction:
    date: str
    description: str
    amount: float
    category: str
    kind: str

    @property
    def signed(self):
        return self.amount if self.kind == "income" else -self.amount

    def __str__(self):
        return f"{self.date}  {self.description:<16}{self.signed:>10,.2f}  ({self.category})"

print(Transaction("2026-03-02", "Rent", 1150.0, "housing", "expense"))
```

Then the `Budget` class with every method from Steps 2 to 8:

```python run
class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []

    def add(self, date, description, amount, category, kind):
        if kind not in ("income", "expense"):
            raise ValueError(f"kind must be ''income'' or ''expense'', not {kind!r}")
        if not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError(f"amount must be a positive number, not {amount!r}")
        self.transactions.append(Transaction(date, description, float(amount), category, kind))
        return self.transactions[-1]

    @property
    def balance(self):
        return sum(t.signed for t in self.transactions)

    def spending_by_category(self):
        totals = {}
        for t in self.transactions:
            if t.kind == "expense":
                totals[t.category] = totals.get(t.category, 0) + t.amount
        return {c: round(v, 2) for c, v in sorted(totals.items(), key=lambda p: p[1], reverse=True)}

    def monthly_summary(self, month):
        rows = [t for t in self.transactions if t.date.startswith(month)]
        inc = sum(t.amount for t in rows if t.kind == "income")
        exp = sum(t.amount for t in rows if t.kind == "expense")
        return {"income": round(inc, 2), "expenses": round(exp, 2), "net": round(inc - exp, 2)}

    def top_expenses(self, n=3):
        expenses = [t for t in self.transactions if t.kind == "expense"]
        return sorted(expenses, key=lambda t: t.amount, reverse=True)[:n]

    def save(self, path):
        data = {"owner": self.owner, "transactions": [asdict(t) for t in self.transactions]}
        with open(path, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=2)

print("Budget is ready:", [name for name in vars(Budget) if not name.startswith("_")])
```

And now the end-to-end run, together with `load_budget`: record Maya''s two months, try to sneak in a bad transaction, save to disk, load it back as a fresh object, and print a report from the *loaded* copy.

```python run
def load_budget(path):
    with open(path, encoding="utf-8") as f:
        data = json.load(f)
    budget = Budget(data["owner"])
    for t in data["transactions"]:
        budget.add(**t)
    return budget

maya = Budget("Maya")
for row in SAMPLE:
    maya.add(*row)

try:
    maya.add("2026-04-15", "Refund?", -30, "food", "expense")
except ValueError as e:
    print("rejected:", e)

maya.save("maya_budget.json")
budget = load_budget("maya_budget.json")

print(f"\n=== {budget.owner}''s budget: {len(budget.transactions)} transactions ===")
for t in budget.transactions[-4:]:
    print(t)
print(f"\nBalance: {budget.balance:,.2f}")
for month in ["2026-03", "2026-04"]:
    s = budget.monthly_summary(month)
    print(f"{month}: in {s[''income'']:>9,.2f}   out {s[''expenses'']:>9,.2f}   net {s[''net'']:>9,.2f}")
```

```python run
print("Where the money went:")
for category, total in budget.spending_by_category().items():
    bar = "#" * round(total / 100)
    print(f"  {category:<10}{total:>9,.2f}  {bar}")

print("\nBiggest expenses:")
for t in budget.top_expenses(3):
    print(" ", t)
```

Every number in that report came from the JSON file, through your validation, into your classes. Try it yourself: add a transaction for May in the first cell, or change a category, and run the three cells again.

> **In the wild:** this design (small data classes, a class that owns and validates them, JSON for storage) is how countless real apps start. Web frameworks like FastAPI build on the same idea: a `pydantic` model is a dataclass with validation built in, and it converts to and from JSON automatically to send data over the internet.

## You did it

Take a moment, because this is a real milestone. Thirty lessons ago, `print("Hello, world!")` was new. Look at what you can do now:

| Section | What you can do now |
|---|---|
| Getting Started | write and run programs, read tracebacks calmly, name values with variables |
| Numbers, Text & Truth | calculate, slice and format text, combine conditions, convert user input |
| Decisions & Loops | make programs choose with `if`/`elif`, repeat with `while` and `for`, search and stop early |
| Collections | pick the right container (list, tuple, dict or set) and build them with comprehensions |
| Functions | package logic into reusable, testable functions with flexible arguments |
| Errors, Files & Modules | handle failures gracefully, read and write CSV and JSON, use the standard library |
| Objects & Classes | design your own types with methods, properties, special methods and dataclasses |
| Capstone Projects | build complete programs: a gradebook analyzer, a word game and a budget tracker |

More important than any single feature: you''ve learned to **break a big problem into small functions, test each piece, read errors instead of fearing them, and use the debugger to see what your code is really doing.** That''s the actual job of a programmer, and it carries over to every language and library you''ll ever touch.

Some ways to keep the momentum going:

- **Extend a project.** Give the budget tracker monthly limits per category that warn you when you''re close, or add a hard mode to the word game. Changing working code is the best practice there is.
- **Automate something real.** Rename a folder of photos, clean up a messy spreadsheet export, or summarize your own bank''s CSV download.
- **Read other people''s code.** The Python standard library is written in clear Python; open a module you''ve used and see how it works.

### Next: Python Advanced

**Python Advanced** picks up exactly where this course ends, with the tools professionals use to write code that is faster, safer and easier to maintain:

- **Generators and iterators**: process huge files and endless streams one item at a time, using almost no memory.
- **Decorators**: add logging, timing, caching or access checks to any function with a single `@` line.
- **Context managers**: write your own `with` blocks that always clean up, just like `open()` does.
- **Type hints**: describe what your functions expect and let tools catch bugs before you run anything.
- **Testing with pytest**: turn the `assert` checks you''ve been passing all course into a professional test suite.
- **Async programming**: let your program do many slow things (like web requests) at once.
- **Packaging**: turn your code into an installable package other people can use.

## Recap

- A `@dataclass` is the quickest way to define a record type, and a **property** like `signed` or `balance` computes values fresh so they can never go stale.
- Validate in one place (`add`) and **raise `ValueError`** for bad data, so nothing invalid ever gets into the list.
- Create mutable attributes like lists **in `__init__`**, never in the class body, or every instance shares them.
- Grouping with a dict, filtering with `startswith` and sorting with `key=lambda ...` answer most "where did the money go?" questions.
- Saving means converting objects to plain dicts (`asdict`) for JSON; loading back through `add(**t)` re-runs your validation.
- You can now build complete, useful programs from a blank page. Congratulations!

**Up next:** the final exam, then **Python Advanced**: generators, decorators, context managers, typing, testing, async and packaging.
', 0, '[]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z'),
('les_python_basics_8_4', 'sec_python_basics_8', 'crs_python_basics', 'Final exam: Python Basics', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"What does `print(\"3\" + \"4\")` display?","options":["7","3 4","34","An error: you can''t add strings"],"answerIndex":2,"explanation":"The quotes make both values text (`str`). For strings, `+` means concatenation: it glues them together into `34`. Without the quotes, `print(3 + 4)` would do the math and print `7`."},{"id":"q2","prompt":"What does `print(17 // 5, 17 % 5)` display?","options":["3 2","3.4 2","3 0.4","2 3"],"answerIndex":0,"explanation":"`//` is floor division: 5 goes into 17 three whole times. `%` is the remainder left over: 17 - 15 = 2. Together they split 17 into \"3 groups of 5, plus 2\", the same trick that turns minutes into hours and minutes."},{"id":"q3","prompt":"What is the value of `\"python\"[1:4]`?","options":["''pyt''","''yth''","''ytho''","''pyth''"],"answerIndex":1,"explanation":"Indexing starts at 0, so index 1 is `y`. A slice includes the start and **excludes** the stop, giving indexes 1, 2 and 3: `''yth''`."},{"id":"q4","prompt":"`if answer == \"yes\" or \"y\":` runs its block even when `answer` is `\"no\"`. Which fix is right?","options":["`if answer == (\"yes\" or \"y\"):`","`if answer = \"yes\" or answer = \"y\":`","`if answer is \"yes\" or \"y\":`","`if answer in (\"yes\", \"y\"):`"],"answerIndex":3,"explanation":"The original reads as `(answer == \"yes\") or (\"y\")`, and a non-empty string is always truthy. Checking membership in a tuple compares `answer` with each value. `(\"yes\" or \"y\")` is just `\"yes\"`, `=` inside an `if` is a SyntaxError, and `is` has the same `or` problem."},{"id":"q5","prompt":"A program runs `a = input(\"First: \")` and `b = input(\"Second: \")`. The user types `2` and then `3`. What does `print(a + b)` show?","options":["5","2 3","23","TypeError"],"answerIndex":2,"explanation":"`input()` always returns a string, so `a + b` is `\"2\" + \"3\"`, which concatenates to `23`. Convert first, e.g. `int(a) + int(b)`, to get `5`."},{"id":"q6","prompt":"With `score = 85`, a chain checks `if score >= 60:` (grade \"D\"), then `elif score >= 80:` (grade \"B\"), then `elif score >= 90:` (grade \"A\"). Which grade is assigned?","options":["A","D","B","None: it''s an error"],"answerIndex":1,"explanation":"Python runs the **first** branch whose condition is true and skips the rest. 85 is `>= 60`, so the first branch wins and the grade is \"D\". Range ladders using `>=` must start from the highest cutoff."},{"id":"q7","prompt":"What is `total` after running `total = 0`, then `for i in range(1, 5): total += i`?","options":["10","15","4","14"],"answerIndex":0,"explanation":"`range(1, 5)` produces 1, 2, 3 and 4. The stop value 5 is **excluded**. 1 + 2 + 3 + 4 = 10."},{"id":"q8","prompt":"After `a = [1, 2, 3]`, then `b = a`, then `b.append(4)`, what does `print(a)` show?","options":["[1, 2, 3]","[4]","An error","[1, 2, 3, 4]"],"answerIndex":3,"explanation":"`b = a` doesn''t copy the list. It puts a second name tag on the **same** list, so appending through `b` changes what `a` sees too. Use `a.copy()` or `a[:]` when you need an independent list."},{"id":"q9","prompt":"Counting words with `counts[word] += 1` crashes with a `KeyError` on the first new word. Which line is a correct replacement?","options":["`counts[word] = 1`","`counts.append(word)`","`counts[word] = counts.get(word, 0) + 1`","`counts[word] == counts[word] + 1`"],"answerIndex":2,"explanation":"`.get(word, 0)` returns the current count, or 0 when the word isn''t a key yet, so the first sighting becomes 1 and later ones keep adding. `= 1` would reset the count every time, dictionaries have no `append`, and `==` only compares."},{"id":"q10","prompt":"What does `type({})` return?","options":["<class ''set''>","<class ''dict''>","<class ''list''>","<class ''tuple''>"],"answerIndex":1,"explanation":"Empty curly braces create an empty **dictionary**, because dictionaries had the `{}` syntax first. To make an empty set, call `set()`."},{"id":"q11","prompt":"What is `[n * n for n in range(6) if n % 2 == 0]`?","options":["[0, 4, 16]","[0, 1, 4, 9, 16, 25]","[4, 16]","[0, 2, 4]"],"answerIndex":0,"explanation":"The `if` keeps only the even numbers from 0 to 5 (0, 2 and 4), and the expression squares each one: 0, 4 and 16."},{"id":"q12","prompt":"Given `def add(item, items=[]): items.append(item); return items`, what does `add(\"a\")` followed by `print(add(\"b\"))` print?","options":["[''b'']","[''a'']","[''a'', ''b'']","[''b'', ''a'']"],"answerIndex":2,"explanation":"A default value is created **once**, when the function is defined, so every call that relies on it shares the same list. The fix is the `None` idiom: `items=None`, then `if items is None: items = []` inside the function."},{"id":"q13","prompt":"What does this print? `try:` runs `int(\"abc\")` then `print(\"A\")`; `except ValueError:` runs `print(\"B\")`; `finally:` runs `print(\"C\")`.","options":["A, then C","B only","A, then B, then C","B, then C"],"answerIndex":3,"explanation":"`int(\"abc\")` raises `ValueError` immediately, so `print(\"A\")` never runs. The matching `except` prints B, and a `finally` block **always** runs at the end, printing C."},{"id":"q14","prompt":"A script adds one line to `log.txt` each time it runs, using `open(\"log.txt\", \"w\")`. But the file only ever contains the latest line. What''s the fix?","options":["Open the file with mode \"r\"","Open the file with mode \"a\" to append","Call `f.close()` twice","Add \"\\n\" to the end of the line"],"answerIndex":1,"explanation":"Mode `\"w\"` wipes the file each time it''s opened. Mode `\"a\"` (append) keeps what''s there and adds to the end. You still want the `\\n` so lines don''t run together, but it doesn''t stop the wiping."},{"id":"q15","prompt":"A class `Pet` has `def __init__(self, name): name = name`. What happens when you run `p = Pet(\"Rex\")` and then `print(p.name)`?","options":["It prints Rex","It prints None","AttributeError: ''Pet'' object has no attribute ''name''","SyntaxError"],"answerIndex":2,"explanation":"`name = name` just reassigns the local parameter, which vanishes when `__init__` ends. Nothing is stored on the object. To create an attribute, assign through `self`: `self.name = name`."}]', '[]', '2026-06-24T16:33:30.916Z', '2026-10-18T16:33:30.916Z');

INSERT INTO path_courses (path_id, course_id, position) VALUES
('pth_ml_engineer', 'crs_python_basics', 0);

INSERT INTO enrollments (id, user_id, course_id, source, progress_percent, last_lesson_id, last_activity_at, completed_at, created_at) VALUES
('enr_crs_python_basics_demo', 'usr_student', 'crs_python_basics', 'purchase', 29, 'les_python_basics_3_2', '2026-10-19T16:33:30.916Z', NULL, '2026-08-23T16:33:30.916Z');

INSERT INTO lesson_progress (user_id, lesson_id, course_id, completed, position_seconds, completed_at, updated_at) VALUES
('usr_student', 'les_python_basics_1_1', 'crs_python_basics', 1, 0, '2026-09-02T16:33:30.916Z', '2026-09-02T16:33:30.916Z'),
('usr_student', 'les_python_basics_1_2', 'crs_python_basics', 1, 0, '2026-09-03T16:33:30.916Z', '2026-09-03T16:33:30.916Z'),
('usr_student', 'les_python_basics_1_3', 'crs_python_basics', 1, 0, '2026-09-04T16:33:30.916Z', '2026-09-04T16:33:30.916Z'),
('usr_student', 'les_python_basics_1_4', 'crs_python_basics', 1, 0, '2026-09-05T16:33:30.916Z', '2026-09-05T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_1', 'crs_python_basics', 1, 0, '2026-09-06T16:33:30.916Z', '2026-09-06T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_2', 'crs_python_basics', 1, 0, '2026-09-07T16:33:30.916Z', '2026-09-07T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_3', 'crs_python_basics', 1, 0, '2026-09-08T16:33:30.916Z', '2026-09-08T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_4', 'crs_python_basics', 1, 0, '2026-09-09T16:33:30.916Z', '2026-09-09T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_5', 'crs_python_basics', 1, 0, '2026-09-10T16:33:30.916Z', '2026-09-10T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_6', 'crs_python_basics', 1, 0, '2026-09-11T16:33:30.916Z', '2026-09-11T16:33:30.916Z'),
('usr_student', 'les_python_basics_3_1', 'crs_python_basics', 1, 0, '2026-09-12T16:33:30.916Z', '2026-09-12T16:33:30.916Z');

INSERT INTO exercise_progress (user_id, lesson_id, cell_id, code, passed, attempts, solved_at, updated_at) VALUES
('usr_student', 'les_python_basics_1_1', 'first-greeting', 'message = "I''m learning Python!"

print(message)', 1, 2, '2026-09-02T16:33:30.916Z', '2026-09-02T16:33:30.916Z'),
('usr_student', 'les_python_basics_1_1', 'first-bug', 'coffee = 3
bagel = 4

total = coffee + bagel
print("Your total is", total)', 1, 2, '2026-09-02T16:33:30.916Z', '2026-09-02T16:33:30.916Z'),
('usr_student', 'les_python_basics_1_2', 'postcard', 'print("Greetings from Lisbon!")
print("The custard tarts are incredible and the sun never stops shining.")
print("Wish you were here!")', 1, 2, '2026-09-03T16:33:30.916Z', '2026-09-03T16:33:30.916Z'),
('usr_student', 'les_python_basics_1_2', 'minutes-in-week', 'print("Minutes in a week:", 7 * 24 * 60)', 1, 2, '2026-09-03T16:33:30.916Z', '2026-09-03T16:33:30.916Z'),
('usr_student', 'les_python_basics_1_2', 'clock-time', 'print("09", "30", "15", sep=":")', 1, 2, '2026-09-03T16:33:30.916Z', '2026-09-03T16:33:30.916Z'),
('usr_student', 'les_python_basics_1_2', 'missing-paren', 'print("=== Movie Night ===")
print("Film: The Princess Bride")
print("Snacks:", "popcorn", "lemonade")
print("Starts at 8pm")', 1, 2, '2026-09-03T16:33:30.916Z', '2026-09-03T16:33:30.916Z'),
('usr_student', 'les_python_basics_1_2', 'capital-print', 'print("Packing list for the beach:")
print("- sunscreen")
print("- towel")
print("- sunglasses")
print("- a good book")', 1, 2, '2026-09-03T16:33:30.916Z', '2026-09-03T16:33:30.916Z'),
('usr_student', 'les_python_basics_1_2', 'receipt-formula', '# A cafe receipt: 2 lattes at 4 each, 1 muffin at 3
print("Lattes:", 2 * 4)
print("Muffin:", 3)
print("Total:", 2 * 4 + 3)', 1, 2, '2026-09-03T16:33:30.916Z', '2026-09-03T16:33:30.916Z'),
('usr_student', 'les_python_basics_1_3', 'road-trip', 'distance_km = 450
litres_per_100km = 8
price_per_litre = 1.5

litres_needed = distance_km / 100 * litres_per_100km
fuel_cost = litres_needed * price_per_litre

print("Litres needed:", litres_needed)
print("Fuel cost:", fuel_cost)', 1, 2, '2026-09-04T16:33:30.916Z', '2026-09-04T16:33:30.916Z'),
('usr_student', 'les_python_basics_1_3', 'step-counter', 'steps = 0

steps += 3200
steps += 1500
steps += 4800

print("Total steps today:", steps)', 1, 2, '2026-09-04T16:33:30.916Z', '2026-09-04T16:33:30.916Z'),
('usr_student', 'les_python_basics_1_3', 'early-bird', 'ticket_price = 40
tickets = 3

ticket_price -= 10    # early-bird discount
total = ticket_price * tickets

print("Price per ticket:", ticket_price)
print("Total to pay:", total)', 1, 2, '2026-09-04T16:33:30.916Z', '2026-09-04T16:33:30.916Z'),
('usr_student', 'les_python_basics_1_3', 'checkout-typo', 'item_price = 12
quantity = 3

sub_total = item_price * quantity
tax = sub_total * 0.25
total = sub_total + tax

print("Total to pay:", total)', 1, 2, '2026-09-04T16:33:30.916Z', '2026-09-04T16:33:30.916Z'),
('usr_student', 'les_python_basics_1_3', 'podium-swap', 'gold = "Mei"
silver = "Ravi"
bronze = "Lucia"

gold, silver = silver, gold

print("Gold:", gold, "| Silver:", silver, "| Bronze:", bronze)', 1, 2, '2026-09-04T16:33:30.916Z', '2026-09-04T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_1', 'running-time', 'movie_minutes = 148

hours = movie_minutes // 60
minutes = movie_minutes % 60

print("Running time:", hours, "h", minutes, "min")', 1, 2, '2026-09-06T16:33:30.916Z', '2026-09-06T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_1', 'day-of-week', 'today = 3
days_ahead = 100

future_day = (today + days_ahead) % 7

print("In", days_ahead, "days it will be day number", future_day)', 1, 2, '2026-09-06T16:33:30.916Z', '2026-09-06T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_1', 'average-too-high', 'match_1 = 82
match_2 = 90

average = (match_1 + match_2) / 2
print("Average score:", average)', 1, 2, '2026-09-06T16:33:30.916Z', '2026-09-06T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_1', 'weather-stats', 'mon, tue, wed, thu = 18.4, 22.7, 15.9, 21.3

highest = max(mon, tue, wed, thu)
lowest = min(mon, tue, wed, thu)
spread = round(highest - lowest, 1)
average = round((mon + tue + wed + thu) / 4, 1)

print("High:", highest, "| Low:", lowest, "| Spread:", spread, "| Average:", average)', 1, 2, '2026-09-06T16:33:30.916Z', '2026-09-06T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_1', 'egg-boxes', 'import math

eggs = 75
box_size = 12

boxes_needed = math.ceil(eggs / box_size)

print("Boxes needed:", boxes_needed)', 1, 2, '2026-09-06T16:33:30.916Z', '2026-09-06T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_1', 'half-a-team', 'players = 30
team_size = 4

full_teams = players // team_size
on_the_bench = players - full_teams * team_size

print("Full teams:", full_teams)
print("Players on the bench:", on_the_bench)', 1, 2, '2026-09-06T16:33:30.916Z', '2026-09-06T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_2', 'unread-messages', 'name = "Priya"
unread = 3

message = "Hi " + name + ", you have " + str(unread) + " new messages"
print(message)', 1, 2, '2026-09-07T16:33:30.916Z', '2026-09-07T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_2', 'sale-banner', 'title = "SUMMER SALE"

middle = "| " + title + " |"
border = "=" * len(middle)

print(border)
print(middle)
print(border)', 1, 2, '2026-09-07T16:33:30.916Z', '2026-09-07T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_2', 'initials', 'first_name = "Grace"
last_name = "Hopper"

initials = first_name[0] + "." + last_name[0] + "."
last_letter = last_name[-1]

print("Initials:", initials)
print("Last name ends in:", last_letter)', 1, 2, '2026-09-07T16:33:30.916Z', '2026-09-07T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_2', 'boarding-pass', 'code = "BA0492LHRJFK"

airline = code[:2]
flight_number = code[2:6]
origin = code[6:9]
destination = code[-3:]

print(airline, flight_number, "from", origin, "to", destination)', 1, 2, '2026-09-07T16:33:30.916Z', '2026-09-07T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_2', 'month-cut-short', 'order_date = "2026-10-22"

year = order_date[0:4]
month = order_date[5:7]
day = order_date[8:10]

print("Year:", year, "| Month:", month, "| Day:", day)', 1, 2, '2026-09-07T16:33:30.916Z', '2026-09-07T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_2', 'spy-messages', 'backwards = "!thginot 9 ta kcod eht ta teeM"
padded = "B*r*i*n*g* *t*h*e* *m*a*p"

message_1 = backwards[::-1]
message_2 = padded[::2]

print(message_1)
print(message_2)', 1, 2, '2026-09-07T16:33:30.916Z', '2026-09-07T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_3', 'tidy-book-title', 'raw_title = "   the HOBBIT   "

book_title = raw_title.strip().title()

print("[" + str(book_title) + "]")', 1, 2, '2026-09-08T16:33:30.916Z', '2026-09-08T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_3', 'make-a-slug', 'title = "  My First   Python Program "

slug = "-".join(title.lower().split())

print(slug)', 1, 2, '2026-09-08T16:33:30.916Z', '2026-09-08T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_3', 'email-parts', 'email = "maya.chen@example.com"

at = email.find("@")
user = email[:at]
domain = email[at + 1:]

print("user:", user)
print("domain:", domain)', 1, 2, '2026-09-08T16:33:30.916Z', '2026-09-08T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_3', 'quiet-announcement', 'announcement = "  flash sale ends tonight  "

announcement = announcement.strip()
announcement = announcement.upper()

print("[" + announcement + "]")', 1, 2, '2026-09-08T16:33:30.916Z', '2026-09-08T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_3', 'receipt-line', 'item = "Headphones"
qty = 3
unit_price = 1249.5

line = f"{item:<12}{qty * unit_price:>10,.2f}"

print("[" + str(line) + "]")', 1, 2, '2026-09-08T16:33:30.916Z', '2026-09-08T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_3', 'letter-hashtags', 'topics = "python, coding, beginners"

words = topics.split(", ")
post = "#" + " #".join(words)

print(post)', 1, 2, '2026-09-08T16:33:30.916Z', '2026-09-08T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_4', 'shipping-and-comfort', 'cart_total = 47.5
free_shipping_minimum = 50
temperature = 26

free_shipping = cart_total >= free_shipping_minimum
comfortable = 18 <= temperature <= 24

print("free shipping:", free_shipping)
print("comfortable:", comfortable)', 1, 2, '2026-09-09T16:33:30.916Z', '2026-09-09T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_4', 'pin-rejected', 'correct_pin = "4071"
attempt_1 = "4017"
attempt_2 = "4071"

first_ok = attempt_1 == correct_pin
second_ok = attempt_2 == correct_pin

print("attempt 1 accepted:", first_ok)
print("attempt 2 accepted:", second_ok)', 1, 2, '2026-09-09T16:33:30.916Z', '2026-09-09T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_4', 'cinema-discount', 'age = 70
is_member = False
is_peak_time = True

gets_discount = (age < 12 or age >= 65 or is_member) and not is_peak_time

print("discount:", gets_discount)', 1, 2, '2026-09-09T16:33:30.916Z', '2026-09-09T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_4', 'always-weekend', 'day = "Tuesday"

is_weekend = day == "Saturday" or day == "Sunday"

print("Is it the weekend?", is_weekend)', 1, 2, '2026-09-09T16:33:30.916Z', '2026-09-09T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_4', 'display-name', 'nickname = "   "

display = nickname.strip() or "Anonymous"

print("Posted by:", display)', 1, 2, '2026-09-09T16:33:30.916Z', '2026-09-09T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_4', 'password-rules', 'password = "sunflower42"

long_enough = len(password) >= 8
no_spaces = " " not in password
not_common = password.lower() != "password"
is_valid = long_enough and no_spaces and not_common

print(f"{long_enough=} {no_spaces=} {not_common=}")
print("valid:", is_valid)', 1, 2, '2026-09-09T16:33:30.916Z', '2026-09-09T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_5', 'age-next-year', 'type_answers("29")

age = int(input("How old are you? "))
next_year = age + 1

print(f"Next year you''ll be {next_year}.")', 1, 2, '2026-09-10T16:33:30.916Z', '2026-09-10T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_5', 'yes-or-no', 'type_answers("  Yes ", "no")

first = input("Do you want a receipt? ")
second = input("Do you want a bag? ")

clean_first = first.strip().lower()
clean_second = second.strip().lower()
wants_receipt = clean_first == "yes" or clean_first == "y"
wants_bag = clean_second == "yes" or clean_second == "y"

print("receipt:", wants_receipt, "| bag:", wants_bag)', 1, 2, '2026-09-10T16:33:30.916Z', '2026-09-10T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_5', 'tickets-glued', 'type_answers("2", "3")

adults = int(input("Adult tickets: "))
children = int(input("Child tickets: "))

total_tickets = adults + children
print("Total tickets:", total_tickets)', 1, 2, '2026-09-10T16:33:30.916Z', '2026-09-10T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_5', 'price-crash', 'type_answers("3.5", "4")

price_per_kg = float(input("Price per kg: $"))
kilos = int(input("How many kg? "))

cost = price_per_kg * kilos
print(f"Cost: ${cost:.2f}")', 1, 2, '2026-09-10T16:33:30.916Z', '2026-09-10T16:33:30.916Z'),
('usr_student', 'les_python_basics_2_5', 'minutes-to-hours', 'type_answers(" 135 ")

minutes_text = input("Movie length in minutes: ")

is_valid = minutes_text.strip().isdigit()
minutes = int(minutes_text)
hours = minutes // 60
leftover = minutes % 60

print(f"{hours}h {leftover}m")', 1, 2, '2026-09-10T16:33:30.916Z', '2026-09-10T16:33:30.916Z'),
('usr_student', 'les_python_basics_3_1', 'free-shipping', 'cart_total = 42.50

if cart_total >= 50:
    shipping = 0
else:
    shipping = 4.99

print("Shipping:", shipping)', 1, 2, '2026-09-12T16:33:30.916Z', '2026-09-12T16:33:30.916Z'),
('usr_student', 'les_python_basics_3_1', 'shipping-tiers-order', '# Rates:  up to 1 kg: 2.99   over 1 kg: 4.99   over 5 kg: 9.99   over 10 kg: 19.99
weight_kg = 12

if weight_kg > 10:
    shipping = 19.99
elif weight_kg > 5:
    shipping = 9.99
elif weight_kg > 1:
    shipping = 4.99
else:
    shipping = 2.99

print(f"Shipping for {weight_kg} kg: ${shipping}")', 1, 2, '2026-09-12T16:33:30.916Z', '2026-09-12T16:33:30.916Z'),
('usr_student', 'les_python_basics_3_1', 'ticket-prices', 'age = 34

if age < 3:
    price = 0
elif age <= 12:
    price = 8
elif age <= 64:
    price = 14
else:
    price = 9

print(f"Ticket for age {age}: ${price}")', 1, 2, '2026-09-12T16:33:30.916Z', '2026-09-12T16:33:30.916Z'),
('usr_student', 'les_python_basics_3_1', 'leap-year', 'year = 2024

if year % 400 == 0:
    is_leap = True
elif year % 100 == 0:
    is_leap = False
elif year % 4 == 0:
    is_leap = True
else:
    is_leap = False

print(year, "is a leap year:", is_leap)', 1, 2, '2026-09-12T16:33:30.916Z', '2026-09-12T16:33:30.916Z'),
('usr_student', 'les_python_basics_3_1', 'receipt-indent', 'subtotal = 30
discount = 0

if subtotal >= 100:
    discount = subtotal * 0.10
    print(f"Big order! You saved ${discount:.2f}")

total = subtotal - discount
print(f"Total to pay: ${total:.2f}")', 1, 2, '2026-09-12T16:33:30.916Z', '2026-09-12T16:33:30.916Z'),
('usr_student', 'les_python_basics_3_1', 'plural-items', 'count = 1

label = "1 item" if count == 1 else f"{count} items"

print("Your basket:", label)', 1, 2, '2026-09-12T16:33:30.916Z', '2026-09-12T16:33:30.916Z');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_basics_1', 'usr_seed00000a', 'crs_python_basics', 5, 'Exceptional production quality', 'Beautifully structured. The quizzes caught gaps in my understanding and the AI tutor was surprisingly helpful when I got stuck on the harder sections.', '2026-08-28T12:33:30.916Z', '2026-08-28T12:33:30.916Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000a');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_basics_2', 'usr_seed00000i', 'crs_python_basics', 4, 'Clear explanations', 'The visual explanations of difficult concepts are the best I''ve seen. Code is clean and modern. Updated content too, which matters a lot in this field.', '2026-10-07T15:33:30.916Z', '2026-10-07T15:33:30.916Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000i');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_basics_3', 'usr_seed00001i', 'crs_python_basics', 4, 'Helped me land an ML role', 'I was a backend engineer trying to move into ML. This course gave me the vocabulary and the hands-on confidence to pass technical interviews. Highly recommended.', '2026-08-19T09:33:30.916Z', '2026-08-19T09:33:30.916Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001i');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_basics_4', 'usr_seed00001r', 'crs_python_basics', 5, 'Helped me land an ML role', 'I was a backend engineer trying to move into ML. This course gave me the vocabulary and the hands-on confidence to pass technical interviews. Highly recommended.', '2026-09-26T10:33:30.916Z', '2026-09-26T10:33:30.916Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001r');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_basics_5', 'usr_seed00001s', 'crs_python_basics', 5, 'Finally clicked', 'I''d tried learning this from scattered blog posts and papers. Having a single coherent narrative with good visuals made it click. The capstone tied everything together.', '2026-08-03T01:33:30.916Z', '2026-08-03T01:33:30.916Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001s');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_basics_6', 'usr_seed00001y', 'crs_python_basics', 5, 'Solid and practical', 'Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I''d take another course from this instructor.', '2026-10-05T05:33:30.916Z', '2026-10-05T05:33:30.916Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001y');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_basics_7', 'usr_seed00002o', 'crs_python_basics', 5, 'Solid and practical', 'Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I''d take another course from this instructor.', '2026-10-03T20:33:30.916Z', '2026-10-03T20:33:30.916Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002o');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_basics_8', 'usr_seed000032', 'crs_python_basics', 5, 'Best course I''ve taken on the topic', 'The explanations build intuition before the math, and every concept is backed by code you actually run. I finally understand what''s happening under the hood instead of copying snippets.', '2026-10-01T03:33:30.916Z', '2026-10-01T03:33:30.916Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000032');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_basics_9', 'usr_seed000044', 'crs_python_basics', 5, 'Helped me land an ML role', 'I was a backend engineer trying to move into ML. This course gave me the vocabulary and the hands-on confidence to pass technical interviews. Highly recommended.', '2026-09-28T09:33:30.916Z', '2026-09-28T09:33:30.916Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000044');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_python_basics_10', 'usr_seed00004f', 'crs_python_basics', 5, 'Solid and practical', 'Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I''d take another course from this instructor.', '2026-08-08T04:33:30.916Z', '2026-08-08T04:33:30.916Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00004f');

UPDATE courses SET rating_avg = coalesce((SELECT avg(rating) FROM reviews WHERE course_id = 'crs_python_basics'), 0), rating_count = (SELECT count(*) FROM reviews WHERE course_id = 'crs_python_basics') WHERE id = 'crs_python_basics';
