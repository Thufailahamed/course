JavaScript runs more of the world than any other language. It powers the buttons and forms in your browser, the servers behind many apps, the scripts that build and test software, and the tools developers use every day. Learning it well means you can read a codebase, fix a bug in a live page, and understand what your teammates are talking about in code review.

This course starts from nothing. You will write small programs, see what they print, and build up to a complete project: a grade report, a to-do manager and a budget tracker that saves its data as JSON. Every idea arrives right next to a piece of code you can run, and every lesson ends with challenges that check your work.

## How the cells work

Each lesson is a notebook. Code lives in shaded **cells**, and you can change any of them. Press **Run** on a cell to execute it. Output appears underneath, and the last expression in a cell is shown as a value too.

```js run
console.log("Hello, learner!");
console.log("Two lines", "from one call");
```

The first line prints text exactly as written. The second shows that `console.log` takes several values and separates them with a space. Try editing the text and running the cell again. Nothing you do here can break the course, so experiment freely.

Some cells end with a bare expression instead of a `console.log`. The runtime shows its value automatically:

```js run
3 * 7 + 1
```

That `22` is not printed by a command. It is the value of the last line, shown for you. You will use this a lot while exploring, because it lets you check a calculation without writing `console.log` around it.

## What you will need

You do not need to install anything. The cells run JavaScript in your browser's own engine, so the code you see is the code that runs on a real JavaScript engine. You will need a text editor only if you later build programs on your own computer.

A little comfort with arithmetic helps, but you do not need a background in programming. If you have used a spreadsheet with formulas, you already understand the basic idea of an expression that produces a value.

> **Tip:** Work through the lessons in order. Each one builds on the last, and the checkpoint quizzes after every group of lessons tell you whether you are ready to move on.

## How challenges work

Some cells are marked as challenges. A challenge gives you a starting point that deliberately fails, a description of what to build, and a set of hidden tests. Change the starter until every test passes. If you get stuck, reveal a hint, and the hints get more specific each time.

Predict cells ask a different question: what will this print? Choose an answer before you run it. Getting a prediction wrong is one of the fastest ways to learn, because the explanation shows the rule you missed.

> **Pitfall:** Do not judge yourself by how fast you solve a challenge. Reading an error message carefully and fixing the cause is the real skill, and the course is designed so that every error is a lesson.

## Your first goal

By the end of the course you will be able to write functions that take inputs and return results, transform arrays of data without manual loops, model real things with objects and classes, and handle errors and dates without the usual traps. You will also finish the three projects, which are the best proof that you can build something real.

Turn the page when you are ready, and let's write your first program.

## Recap

- Each lesson is a notebook of cells: **Run** a cell to see its output.
- `console.log` prints values, and the last expression in a cell is shown automatically.
- Challenges start out failing on purpose. Your job is to make the hidden tests pass.
- Predictions improve your reading of code, so commit to an answer before you run it.
- Nothing needs installing, and experimenting is safe.

**Up next:** your first program, with `console.log`, comments and how to read an error message.
