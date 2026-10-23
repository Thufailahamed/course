You already know the syntax. You can write a function, map over an array and fetch some data. What costs developers hours is the gap between what the code *looks* like it does and what the engine actually does: a callback that sees the wrong `this`, a variable that changes after a closure captured it, a `console.log` that prints before the line above it, a promise that resolves but never gets awaited. These bugs don't crash. They quietly produce wrong results, and they show up in production, in a race that only happens on slow networks.

This course closes that gap. You'll build a precise mental model of how JavaScript runs, and then you'll check that model against real output, every single lesson. Reading about the event loop is not enough. You have to predict what it prints, run it, and be wrong sometimes, because that is how the model gets corrected.

## How the course works

Every lesson mixes three kinds of code cell. You'll see all three the moment you scroll down.

- **Examples** (`run` cells) execute when you press **Run**. They share one scope, like a notebook, so a `const` you declare in one cell is still there in the next. Output appears under the cell.
- **Challenges** ask you to write or fix code. Starter code has a visible stub that makes the tests fail. Press **Check** and hidden tests call your function with inputs you haven't seen, so hard-coding the answer won't pass.
- **Predictions** show a short program and four possible outputs. Pick the one you think it prints, then run it to see whether you're right. The explanation after each prediction is where most of the learning happens.

> **Tip:** Make a prediction before you press Run, even when you're sure. Being confidently wrong is the fastest way to find a gap in your model, and the gaps are what this course is for.

Stuck on a challenge? Click **Hint**. Hints escalate, from a nudge, to the relevant API, to an almost-answer. You can reveal the reference solution after a failed check, but spend a few minutes on it first. The struggle is where the learning happens.

Each section ends with a short checkpoint quiz. Quizzes test the reasoning behind the answers, not trivia, and every wrong option is one that a real developer has believed.

## Two surprises to warm up

Before the course gets serious, here are two behaviors that trip up almost everyone. You don't need to understand them yet. Just notice that the output is not what you'd write down from intuition.

```js run
console.log(0.1 + 0.2);
console.log([10, 9, 1].sort());
console.log(null == 0, null >= 0);
```

The first line is binary floating-point rounding: numbers are stored in base 2, so `0.1` and `0.2` are only approximations. The second is `sort()` comparing elements as strings by default, so `"10"` comes before `"9"`. The third is `==` doing type coercion in a way that makes `null` both equal to `0` and greater than or equal to it. Yes, both. Every one of these has a precise rule behind it, and the rules are what you'll learn.

## Scope is shared across cells

Here is the notebook behavior in action. The first cell declares a name; the second cell uses it.

```js run
const planet = "Mars";
console.log("Hello from", planet);
```

```js run
const moons = planet === "Mars" ? 2 : 0;
console.log(planet, "has", moons, "moons");
```

This is a convenience of the course, not of JavaScript itself. Inside a real program, every file and function has its own scope, and you'll spend most of this course learning exactly where names come from. Keep the notebook behavior in mind, though: when a lesson defines a helper in one cell, the later cells can call it.

## The order of things, in one example

Now the big one. This program mixes synchronous code, a promise callback and a timer. Read it, then run it.

```js run
console.log("1. script starts");
setTimeout(() => console.log("4. timer fires"), 0);
Promise.resolve().then(() => console.log("3. promise callback"));
console.log("2. script ends");
```

The timer was scheduled before the promise, and it asked for zero milliseconds, yet it printed last. That is the event loop at work: the promise callback sits in a queue that runs before the timer's queue, even when the timer's delay is zero. Lesson 11 takes this apart completely. For now, notice the question it raises: *why would a zero-delay timer ever wait?*

## A first prediction

Here is the same idea written as a prediction. The program collects its output into an array and prints the array once, so the whole answer fits on one line.

```js predict id=predict-the-order title="Predict the order"
const out = [];
setTimeout(() => out.push("timeout"), 0);
Promise.resolve().then(() => out.push("promise"));
out.push("sync");
setTimeout(() => console.log(out.join(" ")), 10);
--- options
* sync promise timeout
sync timeout promise
promise sync timeout
timeout promise sync
--- explain
The three `push` calls happen in the order the engine reaches them. `out.push("sync")` runs during the script itself, so it's first. The promise callback runs as soon as the script finishes, before any timer, so `promise` comes next. The timer callback runs last, when its turn comes around in the event loop. The final `console.log` waits 10 ms, which gives both queued callbacks time to run first.
```

## How to read a prediction

Every prediction prints a single line, and that line is compared exactly with the option you choose. That's deliberate. Asynchronous ordering is easiest to reason about when you see one sequence of words, and the output is never a matter of formatting.

When you read a prediction, don't ask "what would a typical program do?" Ask a narrower question: which lines run during the script itself, and which callbacks are waiting for something to finish? Answer those two questions in order, and most ordering puzzles stop being puzzles.

The explanation under each prediction tells you which rule decided the answer. Read it even when you were right. A right answer for the wrong reason is the most common way to fail the next prediction.

> **Tip:** Keep a scratch file open next to the course. Whenever a prediction surprises you, write the rule in your own words. Two or three sentences per surprise becomes a personal reference by the end of the course.

## What you need

You should be comfortable with functions, arrays, objects and loops, and you should have written at least a little code that uses `fetch` or `setTimeout`. You don't need to know anything about compilers, engines or the specification. Those details will come up when they explain a behavior, and never before.

Nothing here runs outside the browser. Every example uses only the standard language and the console, so you won't install anything, and you won't spend time on configuration. Your attention belongs on the semantics.

## What this course will change

By the end you'll be able to read the sentence "the callback runs asynchronously" and say exactly when it runs, which queue it sits in, and what can run before it. You'll know why `this` disappears when you pass a method as a callback, why a closure in a loop sees the final value of `i`, and why a missing `await` produces a promise where you expected a number.

The path is deliberate. First the machine: the call stack, scope, closures and `this`. Then objects: prototypes, classes, iterators, generators and proxies. Then asynchronous code: promises, `async`/`await`, the event loop and concurrency patterns. Each step rests on the one before it.

> **In the wild:** The `this` and closure bugs you'll fix in lessons 3 and 4 are the same ones that break React event handlers, Express middleware and Node's EventEmitter callbacks. Learn the rule once and you'll recognize the pattern in every framework you touch.

> **Pitfall:** Don't skim the predictions. They are the cheapest tutorial you'll ever get, and skipping them is how people end up with a course's worth of facts and no working model.

## Recap

- Lessons mix examples you run, challenges with hidden tests, and predictions you answer before you run them.
- Cells share one scope, so declarations carry from one cell to the next.
- Predict first. A wrong prediction that you understand is worth more than a right guess you don't.
- Hints escalate and reference solutions are there when you need them, after a real attempt.
- Asynchronous output is ordered by a set of rules, not by where the code appears on the page.

**Up next:** the execution model, where you'll learn how the call stack, hoisting and the temporal dead zone decide what runs and when.
