Senior engineers don't debug faster because they type faster or because they remember more APIs. They debug faster because they have a method. They make the failure reproducible, they shrink it until its cause is obvious, they read errors all the way down, and they check their assumptions instead of editing code until the symptom goes away. That last habit is the most expensive one to lose. A change that makes a test pass without explaining why is a bug you haven't found yet.

This lesson builds that method around the parts of JavaScript that break in predictable ways: error objects and their causes, the `try`/`finally` control flow, closures that capture the wrong variable, and the tools (`console` helpers, breakpoints, stack traces) that show you what really happened.

## Start with a reproduction you can run

Before you read a line of the implementation, make the failure happen on demand, in the smallest input that still shows it. A reproduction is a script or a test with a fixed input and an expected output. Once you have one, every hypothesis becomes a five-second experiment instead of a debate.

Shrinking matters as much as reproducing. If a 200-line function fails on a 40-item list, halve the list until the smallest failing input remains. That's binary search applied to the input, and it usually points straight at the branch that's wrong. The same logic applies to code: comment out half of a pipeline, and see which half still produces the bad value.

> **Tip:** Write down the observed result and the expected result before you touch the code. The gap between them is the specification of your bug. Vague symptoms ("it's broken on Safari") turn into precise ones once you name the input, the output and the step where they diverge.

## Read errors all the way down

An error object carries more than a message. Its `cause` links it to the error that triggered it, `name` tells you the category, and `stack` records where it was thrown. Wrapping an error with a more helpful message is good practice, as long as you keep the original attached:

```js run
const inner = new TypeError("expected a number");
const outer = new Error("could not add", { cause: inner });

console.log(outer.message, "<-", outer.cause.message, outer.cause instanceof TypeError);
```

When you catch and rethrow, use `cause`. A rethrow that only copies the message throws away the stack and type of the original failure, and the next person to debug the code has to guess what went wrong.

Custom error classes help too. Set `name` so logs and debuggers show the category, and add the fields a handler needs:

```js run
class ValidationError extends Error {
  constructor(field, message) {
    super(message);
    this.name = "ValidationError";
    this.field = field;
  }
}

try {
  throw new ValidationError("email", "missing @");
} catch (err) {
  console.log(err.name, err.field, err instanceof ValidationError, err instanceof Error);
}
```

The exercise below applies the cause pattern to a realistic wrapper: a config parser that should report its own failure while keeping the parser's error attached.

```js exercise id=parse-config title="Wrap an error without losing it"
function parseConfig(text) {
  // TODO: return the parsed JSON value.
  // If JSON.parse throws, throw a new Error("Invalid config") whose cause is the original error.
  return null;
}
--- solution
function parseConfig(text) {
  try {
    return JSON.parse(text);
  } catch (err) {
    throw new Error("Invalid config", { cause: err });
  }
}
--- test
assertEqual(parseConfig('{"debug": true}'), { debug: true }, "Valid JSON should parse as before");
let caught = null;
try {
  parseConfig("{not json");
} catch (err) {
  caught = err;
}
assert(caught instanceof Error, "A bad config should throw an Error");
assertEqual(caught.message, "Invalid config", "The message should describe the config problem");
assert(caught.cause instanceof SyntaxError, "The original SyntaxError should be attached as cause");
--- hint
A `try`/`catch` around `JSON.parse` gives you the original error in `err`. Inside `catch`, throw a new `Error` with your message.
--- hint
The second argument to `new Error` takes an options object. Pass `{ cause: err }` so the original error stays attached.
```

## `try`, `catch` and `finally`: control flow, not just error handling

`finally` runs whether the `try` block returns, throws or completes normally. That's what makes it useful for cleanup, and it's also where a surprising amount of debugging time goes. A `return` inside `finally` replaces whatever the `try` was about to return, and it silently swallows any error that was in flight.

Read this predict cell carefully. The `return` in `try` is evaluated first, but `finally` still gets the last word.

```js predict id=predict-finally title="Which value survives the finally"
let log = [];
function f() {
  try {
    return log.push("try");
  } finally {
    log.push("finally");
  }
}
console.log(f(), log.join(","));
--- options
2 try,finally
* 1 try,finally
1 try
undefined try,finally
--- explain
`log.push("try")` runs first and returns the new length, 1, which is the value `try` wants to return. Then `finally` runs and pushes `"finally"`, but it has no `return`, so the pending value 1 is returned. The log reads `try,finally` because the `finally` block still runs before the function exits. If `finally` had its own `return`, that value would win.
```

> **Pitfall:** `return` inside `finally` is the classic way to lose an error. A `finally` block that returns a value cancels a thrown exception, so the caller never sees the failure. Keep `finally` for cleanup only, and never put a `return` or `throw` there unless you mean to override everything before it.

## Closures capture variables, not values

The most confusing bug in this lesson is one you can reproduce without any I/O. A callback created in a loop sees the variable, and the variable keeps changing. With `var`, there's only one variable for the whole loop. With `let`, each iteration gets its own copy:

```js run
const fns = [];
for (var i = 0; i < 3; i++) fns.push(() => i);

const fns2 = [];
for (let j = 0; j < 3; j++) fns2.push(() => j);

console.log(fns.map((f) => f()), fns2.map((f) => f()));
```

By the time the callbacks run, `i` is 3, so every callback returns 3. Each `j` belongs to its own iteration, so the callbacks return 0, 1 and 2. This is why the same bug appears with `setTimeout` inside a `var` loop, and why a stale value in a callback is one of the first things to check when a handler reports the wrong item.

Here is the same bug, and this time you fix it. The starter is what a reader sees when a loop-built list of callbacks misbehaves.

```js debug id=loop-closures title="Every getter says the same thing"
// Return an array of n functions. The i-th function returns i.
function makeGetters(n) {
  const getters = [];
  for (var i = 0; i < n; i++) {
    getters.push(() => i);
  }
  return getters;
}
--- solution
function makeGetters(n) {
  const getters = [];
  for (let i = 0; i < n; i++) {
    getters.push(() => i);
  }
  return getters;
}
--- test
assertEqual(makeGetters(3).map((g) => g()), [0, 1, 2], "Each getter should return its own index");
assertEqual(makeGetters(0), [], "Zero getters should give an empty array");
assertEqual(makeGetters(5).map((g) => g()).at(-1), 4, "The last getter should return the last index");
--- hint
Look at the loop declaration. `var` creates one variable shared by the whole function, so every closure reads its final value.
--- hint
Change `var` to `let` in the loop header. Each iteration then gets a fresh binding that its closure keeps.
```

## Use the console and the debugger as instruments

`console.log` is the first tool, but the `console` object has more. `console.count` tallies how often a line runs, which is useful for finding a loop that runs far more often than you expect. `console.assert` checks an invariant and reports only when it fails. `console.trace` prints the call path that led to a line. The `debugger` statement pauses execution in any open devtools session, and you can step through with the variables in view.

```js run
for (const item of ["a", "b", "a"]) console.count(item);
console.log("finished counting");
```

A count of 2 for `"a"` in a loop over three items tells you the duplicate is where you expected it. A count of 40 for an item you only meant to visit once tells you the loop is driven by something else. Prefer counting to scattering `console.log` calls through a hot path, because counts stay readable in long runs.

> **Under the hood:** Breakpoints and `debugger` work because the engine pauses the thread and gives you the current scope chain. Closures keep their variables alive, so a breakpoint inside a callback can show you values from the loop that created it. That's why the `var` bug is visible in the debugger: you can see one shared `i` that has already become 3.

## Exercise: the first attempt that works

Fallback chains are common in production code: try the primary source, then the cache, then a default. The usual mistake is to catch each error and forget it, which makes the final failure impossible to diagnose. Keep the errors and report them together.

```js exercise id=first-success title="Try each attempt until one succeeds"
function firstSuccess(fns) {
  // TODO: call each function in order and return the first result that does not throw.
  // If every function throws, throw an AggregateError with the collected errors
  // and the message "All attempts failed".
  return null;
}
--- solution
function firstSuccess(fns) {
  const errors = [];
  for (const fn of fns) {
    try {
      return fn();
    } catch (err) {
      errors.push(err);
    }
  }
  throw new AggregateError(errors, "All attempts failed");
}
--- test
const fail = (msg) => () => {
  throw new Error(msg);
};
assertEqual(firstSuccess([fail("a"), () => 42, () => 7]), 42, "The first working attempt should win");
assertEqual(firstSuccess([() => 1, fail("never reached")]), 1, "Later attempts should not run after a success");
let thrown = null;
try {
  firstSuccess([fail("x"), fail("y")]);
} catch (err) {
  thrown = err;
}
assert(thrown instanceof AggregateError, "All failures should throw an AggregateError");
assertEqual(thrown.errors.map((e) => e.message), ["x", "y"], "Every underlying error should be kept");
assertEqual(thrown.message, "All attempts failed", "The aggregate error should have a clear message");
--- hint
A `for...of` loop with a `try` inside can `return` on the first success, and push each caught error into an array.
--- hint
After the loop, every attempt has failed. Throw `new AggregateError(errors, "All attempts failed")`.
```

## Silent failures and unhandled rejections

Two failure modes account for many "it just stopped working" reports. The first is an empty `catch` block, which turns every error into a missing value. The second is a promise rejection with no handler. In browsers and Node, an unhandled rejection is reported to the console, and in a server it can terminate the process. Either way, the symptom appears far from the cause.

Treat every `catch` as a decision. Either handle the error in a way that makes sense for this code, add context and rethrow it with `cause`, or let it propagate. An empty `catch` is almost never the right decision. Treat every promise the same way: await it, return it or attach a handler.

> **Pitfall:** Logging an error and returning `undefined` looks like handling, but it moves the failure to a later line where the `undefined` breaks something. Return an explicit fallback you designed, or rethrow.

## A debugging routine

When a bug resists, go through the same short routine each time. Reproduce it with a fixed input. Shrink the input until the smallest failing case remains. Write down the expected and actual values at the step where they diverge. Form one hypothesis, and design a single experiment to test it, such as a breakpoint, a count or a changed input. Only then change code, and keep the reproduction as a test so the bug can't return quietly.

> **In the wild:** Browser devtools, Node's `--inspect` and the performance profiler all rest on the same mechanics you just used: pausing execution, reading scopes and counting calls. Learning them once means every new environment is familiar.

## Recap

- Turn a bug into a reproduction with fixed inputs, then shrink the input until the cause is visible.
- Use `cause` when you wrap an error, so the original type and stack survive the rethrow.
- `finally` always runs and can override a `return` or swallow an error. Keep it for cleanup.
- Closures capture variables. Use `let` in loops that create callbacks, and remember that `var` has one shared binding.
- Use `console.count`, breakpoints and stack traces to observe a running program instead of guessing from its output.
- Never let an error disappear. Handle it deliberately, rethrow with context, or let it surface.

**Up next:** the first capstone. You'll build an async task queue with a concurrency limit, one stage at a time.
