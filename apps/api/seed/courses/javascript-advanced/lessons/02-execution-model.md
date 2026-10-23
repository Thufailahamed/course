Most "impossible" JavaScript bugs come from a wrong model of order. A function is called before the line that defines it and still works. A `const` is read on the line above its declaration and throws. A recursive helper runs fine on a small list and crashes with a `RangeError` on a large one. None of these are random. Each one follows from two facts: how the engine runs code one call at a time on a stack, and how it sets up names before any of that code runs.

This lesson gives you both facts. You'll see where a function's variables live while it runs, why the engine can run a function that is declared further down the file, and why a `let` read too early throws instead of returning `undefined`. Those rules explain most of what you'll meet in the rest of the course, from closures to the event loop.

## Every call gets a frame

When the engine runs a function, it creates an execution context: a record of the function's parameters, its local variables and the point where it should return. The engine keeps these records on a **call stack**, a last-in, first-out list. Calling a function pushes a frame. Returning pops it. Only the frame on top is running.

```js run
function square(n) {
  return n * n;
}

function sumOfSquares(a, b) {
  return square(a) + square(b);
}

console.log(sumOfSquares(3, 4));
```

When `sumOfSquares` runs, its frame is on the stack. It calls `square`, which pushes a second frame. `square` returns and its frame disappears, and then the second call does the same. At any moment the stack is exactly the chain of calls that hasn't returned yet. That chain is what a stack trace shows you.

The stack is not infinite. Each frame takes memory, so a function that calls itself without stopping eventually exhausts it. Engines throw a `RangeError` when that happens, and you can catch it like any other error.

```js run
function countDown(n) {
  return n === 0 ? "liftoff" : countDown(n - 1);
}

function tryDeep(n) {
  try {
    return countDown(n);
  } catch (err) {
    return err instanceof RangeError ? "stack overflow" : "other error";
  }
}

console.log(tryDeep(100));
console.log(tryDeep(1000000));
```

The first call finishes because it only needs a hundred frames. The second needs a million, and the engine stops it. The exact limit depends on the engine and how much memory each frame uses, so never design code that depends on a specific depth. Design it to loop instead of recursing when the input size is unbounded. You'll practice exactly that in the first challenge below.

> **Under the hood:** Each call creates a new execution context with its own variable environment. Two calls to the same function don't share local variables. This is also why recursion works: each frame has its own `n`.

## Hoisting: declarations move up, values don't

Before a function body runs, the engine scans it for declarations and sets them up. This step is called hoisting, and the important detail is what gets hoisted and what doesn't.

- A **function declaration** is hoisted with its body. You can call it above the line where it appears.
- A **`var`** is hoisted as a name, initialized to `undefined`. You can read it before its assignment, and you get `undefined`.
- A **`let`** or **`const`** is hoisted too, but it's left uninitialized. Reading it before its declaration is an error.

```js run
function hoistingDemo() {
  const before = [typeof greet, typeof legacy];
  function greet() {
    return "hello";
  }
  var legacy = "value";
  return [before, greet(), legacy];
}

console.log(hoistingDemo());
```

`greet` works from the first line because the whole function was hoisted. `legacy` exists from the first line but holds `undefined` until its assignment runs. Hoisting moves the declaration up, not the assignment.

> **Pitfall:** A function *expression* such as `const greet = () => "hi"` is not a function declaration. Only the name `greet` is hoisted, and it sits uninitialized until the `const` line runs. Calling it earlier is a `ReferenceError`, not a `TypeError`, because the binding exists but is in the temporal dead zone.

## The temporal dead zone

A `let` or `const` binding exists from the start of its block, but it can't be touched until execution reaches its declaration. The span between the start of the block and that declaration is the **temporal dead zone**, or TDZ. Reading the name there throws a `ReferenceError`.

```js run
function tdzDemo() {
  const attempts = [];
  try {
    attempts.push(count);
  } catch (err) {
    attempts.push(err.name);
  }
  let count = 1;
  attempts.push(count);
  return attempts;
}

console.log(tdzDemo());
```

The first read fails and is recorded as `"ReferenceError"`. After the declaration, the same name works. The TDZ also catches `typeof`, which normally never throws. `typeof undeclaredName` is `"undefined"`, but `typeof letNameInTheDeadZone` throws, because the binding exists and is simply not ready.

The TDZ exists for a good reason. A `let` that silently returned `undefined` before its line would hide the bug that the code is running in the wrong order. An error points at the problem.

## Block scope versus function scope

`var` belongs to the nearest function. `let` and `const` belong to the nearest block: the braces of an `if`, a loop or a plain `{ }`. Mixing the two is where most hoisting confusion starts.

```js run
function scopeDemo(flag) {
  if (flag) {
    var fromVar = "visible";
    let fromLet = "hidden";
  }
  return [fromVar, typeof fromLet];
}

console.log(scopeDemo(true));
console.log(scopeDemo(false));
```

`fromVar` escapes the `if` block because `var` is scoped to the whole function. `fromLet` stays inside the block, and outside it the name is simply not visible. When `flag` is false, the block never runs, so `fromVar` exists but holds `undefined`.

> **Tip:** Use `let` and `const` by default. Their block scope and their TDZ errors make an accidental read of a not-yet-set value fail loudly, where `var` would give you a quiet `undefined`.

## Challenge: a loop that doesn't recurse

Recursion is the clearest way to write a sum, and it's the wrong way once the input can be large. Each call adds a frame, and the stack has a limit. Your job is to write the loop version.

```js exercise id=sum-without-recursion title="Sum without recursion"
function sumTo(n) {
  // TODO: return 1 + 2 + ... + n using a loop, not recursion
  return null;
}
--- solution
function sumTo(n) {
  let total = 0;
  for (let i = 1; i <= n; i++) {
    total += i;
  }
  return total;
}
--- test
assertEqual(sumTo(0), 0, "sumTo(0) should be 0");
assertEqual(sumTo(10), 55, "sumTo(10) should be 55");
assertEqual(sumTo(100000), 5000050000, "sumTo(100000) should not overflow the stack");
--- hint
Start with a total of `0`, then add each number from `1` up to `n` inside a loop.
--- hint
A `for` loop with `let i = 1` and `i <= n` visits every number once. Add each `i` to a running total and return it after the loop.
```

## Challenge: a missing declaration

This function returns labels for a list of items. It fails with a `ReferenceError` before it ever gets to the `map`. Use the TDZ rules above to find out why, and fix it without changing what the function returns.

```js debug id=label-before-declaration title="Fix the early read"
function buildLabels(items) {
  const labels = items.map(formatLabel);
  const formatLabel = (item) => `#${item}`;
  return labels;
}
--- solution
function buildLabels(items) {
  const formatLabel = (item) => `#${item}`;
  const labels = items.map(formatLabel);
  return labels;
}
--- test
assertEqual(buildLabels([1, 2]), ["#1", "#2"], "buildLabels([1, 2]) should return ['#1', '#2']");
assertEqual(buildLabels(["a"]), ["#a"], "Labels should be built from any item, not just numbers");
assertEqual(buildLabels([]), [], "An empty list should produce an empty array");
--- hint
Run the code and read the error. It names the variable that is being read too early.
--- hint
`formatLabel` is a `const`, so it sits in the temporal dead zone until its line runs. Move that declaration above the line that uses it.
```

## Challenge: catching the right error

When a getter throws a `ReferenceError`, the name it refers to is probably a binding that isn't ready yet. Other errors mean a real bug, and they should keep propagating. Write a helper that makes that distinction.

```js exercise id=read-or-report title="Read or report"
function tryRead(getter) {
  // TODO: call getter(). Return its result, or "not initialized" if it throws a ReferenceError.
  // Any other error must be rethrown.
  return null;
}
--- solution
function tryRead(getter) {
  try {
    return getter();
  } catch (err) {
    if (err instanceof ReferenceError) {
      return "not initialized";
    }
    throw err;
  }
}
--- test
assertEqual(tryRead(() => 42), 42, "tryRead should return the getter's value");
assertEqual(tryRead(() => notDeclaredAnywhere), "not initialized", "A ReferenceError should become the string 'not initialized'");
let rethrown = false;
try {
  tryRead(() => {
    throw new TypeError("boom");
  });
} catch (err) {
  rethrown = err instanceof TypeError;
}
assert(rethrown, "Other errors such as TypeError must be rethrown");
--- hint
A `try` block around `getter()` lets you inspect whatever it throws. `err instanceof ReferenceError` tells you which kind it is.
--- hint
Return from the `try` on success. In the `catch`, return the message for `ReferenceError`, and use `throw err;` for everything else.
```

## Predict the hoisting result

Here's a function that reads its declarations before they're assigned. The output is one line. Work out what `typeof` returns for each name at the moment it's read.

```js predict id=predict-hoisting title="Predict the typeof results"
const log = [];
function mystery() {
  log.push(typeof helper, typeof later);
  function helper() {}
  var later = () => {};
  return log.join(" ");
}
console.log(mystery());
--- options
* function undefined
undefined undefined
function function
undefined function
--- explain
Function declarations are hoisted with their bodies, so `helper` is already a function on the first line. `var later` is hoisted as a name with the value `undefined`, and the arrow function is assigned only when the line `var later = ...` runs. So `typeof later` reads `undefined` at that moment, and the arrow function is never visible to the first `push`.
```
```

## Recap

- Each function call pushes a frame onto the call stack, and returning pops it. The stack is finite, so deep recursion throws a `RangeError`.
- Hoisting sets up names before a function runs. Function declarations come with their bodies. `var` starts as `undefined`. `let` and `const` stay uninitialized.
- The temporal dead zone makes reading a `let` or `const` before its declaration throw a `ReferenceError`. This is a feature: it turns an ordering bug into an error.
- `var` is scoped to its function, while `let` and `const` are scoped to their block.
- Prefer loops over deep recursion for unbounded input, and prefer `let` and `const` so that ordering mistakes fail loudly.

**Up next:** closures and lexical scope, where you'll see how a function remembers the variables around it after those variables' scopes have ended.
