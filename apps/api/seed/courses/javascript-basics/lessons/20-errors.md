Programs meet bad input every day. A user types "forty" into an age field, a file is missing, a network call times out, or a function gets a `null` where it expected an object. A program that ignores these problems will either crash with a confusing message or keep running with wrong numbers. Good error handling is the difference between a program that tells you what went wrong and one that silently does the wrong thing.

In JavaScript you signal a problem with `throw`, and you deal with it with `try` and `catch`. This page shows you how to throw clear errors at the right place, how to catch only the errors you can handle, and why an empty `catch` block is one of the most dangerous things you can write.

## Throwing an error

`throw` stops the current function immediately and sends an error upward. Whatever called the function gets the chance to handle it. Throw an `Error` object, because it carries a name and a message that you can read later:

```js run error
function checkAge(age) {
  if (age < 0) {
    throw new Error("Age cannot be negative");
  }
  return age;
}

console.log(checkAge(30));
console.log(checkAge(-1));
console.log("this line never runs");
```

Running this cell stops at the second call, because nothing caught the error. The browser shows it as an error card. An uncaught error is the program saying "I can't continue," which is often what you want during development.

> **Tip:** Check inputs at the start of a function and throw early, with a message that names the bad value. "Age cannot be negative, got -1" is far more useful than an error that appears three function calls later.

## try and catch

To handle an error instead of letting it stop the program, wrap the risky code in `try`, and put the recovery code in `catch`. The `catch` block receives the error object:

```js run
function checkAge(age) {
  if (age < 0) throw new Error("Age cannot be negative");
  return age;
}

try {
  console.log(checkAge(30));
  console.log(checkAge(-1));
  console.log("this line never runs");
} catch (error) {
  console.log("Caught:", error.message);
}
```

When `checkAge(-1)` throws, JavaScript jumps straight to the `catch` block. The line after the throw inside the `try` is skipped, and the program continues normally after the whole statement.

An `Error` object has two useful properties. `name` tells you the kind of error, and `message` describes what happened:

```js run
const problem = new TypeError("expected a number");

console.log(problem.name, "|", problem.message);
console.log(problem instanceof Error);
```

Built-in errors such as `TypeError` and `RangeError` are also `Error` objects, so one `catch` can handle either kind.

> **Pitfall:** Don't use `catch` to hide problems. An empty `catch` that does nothing turns a bug into a silent wrong answer, which is much harder to find than a crash. Catch an error only when you can really do something about it: return a fallback value, show a message to the user, or log it and rethrow.

Now write a function that throws a clear error for a specific bad case. Dividing by zero in JavaScript gives `Infinity` rather than an error, so the function has to check for it on purpose:

```js exercise id=safe-divide title="Throw on division by zero"
function safeDivide(a, b) {
  // TODO: if b is 0, throw an Error with the message "Cannot divide by zero"
  // Otherwise return a / b
  return null;
}
--- solution
function safeDivide(a, b) {
  if (b === 0) {
    throw new Error("Cannot divide by zero");
  }
  return a / b;
}
--- test
assertEqual(safeDivide(10, 4), 2.5, "safeDivide(10, 4) should return 2.5");
assertEqual(safeDivide(-9, 3), -3, "Negative numbers should divide normally");
let message = null;
try {
  safeDivide(1, 0);
} catch (error) {
  message = error.message;
}
assertEqual(message, "Cannot divide by zero", "Dividing by 0 should throw an Error with that exact message");
--- hint
Put an `if (b === 0)` check first. Inside it, use `throw new Error("...")` with the exact message from the instructions.
--- hint
Only do the division after the check. The `return a / b;` line stays at the end of the function, outside the `if`.
```

## finally: cleanup that always runs

A `finally` block runs whether the `try` succeeded, failed, or returned early. Use it for cleanup that must happen no matter what, like closing a file or stopping a timer:

```js run
function readFirst(list) {
  try {
    return list[0];
  } finally {
    console.log("cleanup done");
  }
}

console.log(readFirst(["alpha", "beta"]));
```

Even though `return` ends the function inside the `try`, the `finally` block still runs first. The output shows the cleanup line, then the value.

## Converting bad input into a fallback

A common pattern is to wrap a function that throws, and return a safe default when the input is bad. The helper below turns text into a number, and throws when the text isn't numeric:

```js run
function parseCount(text) {
  const n = Number(text);
  if (Number.isNaN(n)) throw new Error("Not a number: " + text);
  return n;
}

console.log(parseCount("42"));
console.log(parseCount(" 7 "));
```

Your next task is the wrapper. It should use `parseCount`, return the number when the text is valid, and return `0` when it isn't:

```js exercise id=read-count title="Fall back to zero on bad input"
function parseCount(text) {
  const n = Number(text);
  if (Number.isNaN(n)) throw new Error("Not a number: " + text);
  return n;
}

function readCount(text) {
  // TODO: return parseCount(text) when it works, or 0 when parseCount throws
  return null;
}
--- solution
function parseCount(text) {
  const n = Number(text);
  if (Number.isNaN(n)) throw new Error("Not a number: " + text);
  return n;
}

function readCount(text) {
  try {
    return parseCount(text);
  } catch (error) {
    return 0;
  }
}
--- test
assertEqual(readCount("42"), 42, 'readCount("42") should return 42');
assertEqual(readCount(" 7 "), 7, "Spaces around a valid number are fine");
assertEqual(readCount("3.5"), 3.5, "Decimals are valid counts too");
assertEqual(readCount("oops"), 0, 'readCount("oops") should fall back to 0');
assertEqual(readCount("abc12"), 0, "Mixed text should fall back to 0 as well");
--- hint
Put the call to `parseCount(text)` inside a `try` block, and return its result from there.
--- hint
Add a `catch` block that returns `0`. Because the `try` block already returns on success, you only need the one `return` in each block.
```

Now the debug challenge. This function should return the square root of a number, or `null` when the number is negative. It returns `undefined` instead:

```js debug id=safe-root title="Return null when the error is caught"
function root(n) {
  if (n < 0) throw new Error("negative input");
  return Math.sqrt(n);
}

function safeRoot(n) {
  try {
    return root(n);
  } catch (error) {
    console.log(error.message);
  }
}
--- solution
function root(n) {
  if (n < 0) throw new Error("negative input");
  return Math.sqrt(n);
}

function safeRoot(n) {
  try {
    return root(n);
  } catch (error) {
    console.log(error.message);
    return null;
  }
}
--- test
assertEqual(safeRoot(9), 3, "safeRoot(9) should return 3");
assertEqual(safeRoot(0), 0, "safeRoot(0) should return 0");
assertEqual(safeRoot(-4), null, "safeRoot(-4) should return null, not undefined");
--- hint
When `catch` runs, the function reaches the end without a `return`, which gives back `undefined`. What value should the caller get instead?
--- hint
Add `return null;` at the end of the `catch` block, after the message is logged.
```

Here is a prediction question about `finally`. Look at the order of events before you decide:

```js predict id=finally-runs-first title="What does this print?"
const log = [];

function f() {
  try {
    return "t";
  } finally {
    log.push("f");
  }
}

console.log(f(), log.length);
--- options
t 0
* t 1
f 1
undefined 0
--- explain
The `return "t"` is reached, so `f()` produces `"t"`. Before the function actually exits, the `finally` block runs and pushes one item into `log`, so `log.length` is `1`. The value of the `try` block is what the caller gets, and the cleanup still happens first. The `console.log` runs after `f()` has finished, so it sees the updated `log`.
```

> **Under the hood:** When an error is thrown, JavaScript unwinds the call stack one function at a time, running any `finally` blocks on the way, until it finds a `catch`. If none exists, the error reaches the top of the program and is reported as uncaught.

> **In the wild:** `fetch` requests, file reads and JSON parsing all throw when something goes wrong. Real apps catch these at the edges of the program, where a user action or a network call starts, show a friendly message, and log the details for the developer. The inner functions usually just throw.

## Recap

- Use `throw new Error("message")` to stop a function and report a problem with a clear description.
- `try` runs risky code; `catch` receives the error object and recovers. An uncaught error stops the program.
- An `Error` has `name` and `message` properties, and `instanceof Error` checks the type.
- `finally` runs whether the `try` block returns, throws or completes, which makes it the place for cleanup.
- Never leave a `catch` empty. Return a fallback, handle the case, or log and rethrow.

**Up next:** JSON: saving and sharing data as text, and reading that text back into objects and arrays.
