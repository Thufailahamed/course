Welcome to **Python Basics**. You won't watch a single video in this course. Instead, every lesson is a live coding environment: you read a little, write a little, run it, and see what happens. That's how programmers actually learn, and it's the fastest way to go from "I've never coded" to "I can build things."

There's a real Python interpreter running **inside this page**. Nothing to install, no accounts to set up, no terminal to fight with. This first lesson is a short tour of the tools you'll use in every lesson after this one. By the end of it you'll have run code, fixed an error, stepped through a program line by line, and solved your first challenge.

> **How to use this lesson:** read a little, run a little. Every grey box below is code you can edit and run.

## Run your first cell

Click **Run** on the cell below, or click inside it and press **Shift + Enter**.

```python run
print("Hello, world!")
print("I'm running Python inside my browser.")
```

That's a complete Python program. `print(...)` tells Python to display whatever is inside the parentheses. The text inside the quotes is shown exactly as written.

Now try something: change the message to your own name, and run it again. You can't break anything. If you make a mess, use the **⋯** menu on the cell and choose **Reset to original**.

## Python shows you the last value

If the **last line** of a cell is a value or a calculation, Python displays it automatically, without `print`. Run this:

```python run
365 * 24
```

That's how many hours are in a year. Next to the result you'll see a small grey label, `int`. It tells you what *kind* of value you got. An `int` is a whole number. You'll meet many kinds soon: `float` for decimals, `str` for text, `list` for collections, and more. Glancing at that label becomes second nature.

## Cells share memory, like a notebook

Values you give a name to in one cell are available in the cells that come after it, as long as you've **run** the earlier cell first.

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

If you see a `NameError` here, it means Python doesn't know the name yet: run the cell above first. You can also click **Run all** in the bar at the top of the lesson. That bar also has **Restart** (wipe everything and start fresh) and **Variables**, which shows every name currently in memory and its value. Open it now and you'll find `city` and `temperature`.

## Errors are part of learning

You're going to see a lot of errors, and that's completely normal. Professional programmers see errors all day long. The skill isn't avoiding them; it's reading them calmly. Run this cell. It fails on purpose:

```python run error
item = "coffee"
price = 3.5

print("A " + item + " costs " + price)
```

Notice three things about the error card:

- **The exact line** that failed is highlighted in red in the editor.
- A **plain-language tip** explains what this kind of error usually means. Here Python is saying it can't glue text and a number together with `+`.
- **Explain with Atlas** sends your code and the error to your AI tutor, who explains what went wrong without just rewriting your code for you.

Try fixing it: wrap the price in quotes, `price = "3.5"`, and run it again. (You'll learn the proper way to mix text and numbers in a few lessons.)

## Step through code with the debugger

Reading code is one thing; *watching* it run is another. Click **Debug** on the cell below instead of Run.

```python run
savings = 100
for month in [1, 2, 3, 4]:
    savings = savings + 25
    print("After month", month, "you have", savings)

savings
```

Don't worry about understanding every line yet. The `for` line repeats the indented lines once per month; you'll learn exactly how in Section 3. Just watch it happen:

- **Step** (→) moves forward one line, and **←** steps *back* in time.
- The **Variables** table highlights values that just **changed** in amber and values that are **new** in green. Watch `savings` grow.
- Click in the **gutter**, just left of the line numbers, to set a red **breakpoint**, then press **Continue** (F8) to jump straight to it.
- Drag the **timeline** slider to scrub through the whole run.

The debugger is your secret weapon in this course. Whenever code does something you didn't expect, step through it and the answer is almost always obvious.

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
Anything inside quotes is **text**, and Python prints text exactly as written. It doesn't calculate it. Without the quotes, `print(2 + 3)` would do the math and print `5`.
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
message = "I'm learning Python!"

print(message)
--- test
assert message is not ..., "Replace the `...` after `message =` with some text in quotes."
assert isinstance(message, str), f"`message` should be text in quotes, like \"Hello\", but it's {message!r}."
assert "python" in message.lower(), f"Your message {message!r} should mention Python somewhere."
assert message in _stdout, "Keep the `print(message)` line so your message is shown."
--- hint
Text in Python goes inside quotes, like `"this"` or `'this'`.
--- hint
Try something like `message = "Python is fun"`.
```

## Debug challenges: find and fix the bug

Some challenges hand you code that's **almost** right. Your job is to find the bug and fix it. Press **Run** to see the symptom, **Debug** to watch what's happening, then fix it and press **Check**.

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
Look at what's being added together on the `total = ...` line. Is the bagel in there?
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

| Section | You'll learn to… |
|---|---|
| Getting Started | write and run programs, read errors, use variables |
| Numbers, Text & Truth | calculate, work with text, make true/false decisions, talk to users |
| Decisions & Loops | make programs choose and repeat |
| Collections | organize data with lists, tuples, dictionaries and sets |
| Functions | package code into reusable, testable pieces |
| Errors, Files & Modules | handle problems gracefully, save data, use Python's huge standard library |
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

**Up next:** your first real program: printing, comments, and how to read Python's error messages like a pro.
