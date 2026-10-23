Most bugs that look random are really scope bugs: a variable that is `undefined` in one place but fine in another, a counter that resets to zero every time you call a function, or a helper that overwrites a value somewhere else in your program without you noticing. The fix is almost always the same: know where each name lives, and who is allowed to see it.

Scope is the set of rules that decides where a name can be used. Once you can read those rules, you can predict which variables exist at any line of code without running it, and you can design functions that don't reach into the rest of your program by accident.

## Global and function scope

A name declared at the top level of a file or cell is **global**: every function below it can see it. A name declared inside a function is **local** to that function. It exists while the function runs and disappears when the function returns:

```js run
const appName = "Gradebook";

function showName() {
  const label = "App: ";
  console.log(label + appName);
}

showName();
console.log(typeof label);
```

`showName` can read `appName` because it's global. The reverse is not true: the code outside the function cannot see `label`. Asking `typeof label` is a safe way to check whether a name exists, because `typeof` returns `"undefined"` for an unknown name instead of throwing an error.

## Block scope with let and const

Curly braces create a **block**, and variables declared with `let` or `const` belong to the block they're declared in. This includes `if` blocks and loop bodies:

```js run
for (let i = 0; i < 2; i++) {
  const doubled = i * 2;
  console.log("inside the loop:", doubled);
}

console.log("after the loop, typeof doubled:", typeof doubled);
```

The loop variable `i` and the constant `doubled` both vanish at the closing brace. This is what you want: a temporary value in one loop can't collide with a temporary value in the next.

> **Tip:** Declare variables in the smallest block that needs them. If a value is only used inside an `if`, declare it inside the `if`. Readers then know it can't be relied on elsewhere.

## Shadowing: an inner name hides an outer one

If you declare a name inside a block or function that already exists outside, the inner one **shadows** the outer one. Inside the block, the inner name wins. Outside it, nothing has changed:

```js run
const level = "global";

function check() {
  const level = "local";
  console.log("inside:", level);
}

check();
console.log("outside:", level);
```

Shadowing is legal and sometimes useful, but it's also a source of bugs, as you'll see in the next challenges.

## var is function-scoped, and that causes surprises

Before `let` and `const` existed, JavaScript had `var`. It behaves very differently. A `var` is scoped to the whole *function*, not the block, so it leaks out of `if` blocks and loops:

```js run
function demo() {
  if (true) {
    var leaked = "I escape the block";
    const trapped = "I stay inside";
  }
  console.log(leaked);
  console.log(typeof trapped);
}

demo();
```

> **Pitfall:** `var` is also **hoisted**. JavaScript moves the declaration to the top of its function, but not the assignment. A `var` can therefore be read before the line that sets it, and it will be `undefined` at that point. This is why this course uses `let` and `const` everywhere.

Here is a prediction question about hoisting. Read it carefully, because the function runs before the line you might expect:

```js predict id=hoisted-var title="What does the function print?"
function check() {
  console.log(count, typeof count);
  var count = 5;
}

check();
--- options
5 number
undefined number
* undefined undefined
ReferenceError: count is not defined
--- explain
The declaration `var count` is hoisted to the top of `check`, so `count` exists before the first `console.log`. But its assignment `= 5` hasn't run yet, so `count` is `undefined`. `typeof undefined` is the string "undefined", and that is what prints. With `let` instead, the same code would throw a ReferenceError, because `let` can't be read until its line runs.
```

> **Under the hood:** The engine splits a `var` into two steps. Before any line of the function runs, it creates the name with the value `undefined`. Later, when execution reaches `var count = 5`, it assigns `5`. `let` and `const` create the name too, but they leave it in a "not ready" state until their declaration runs, which is why reading them early throws instead of returning `undefined`.

## Functions remember where they were born

A function can use names from the scope where it was *defined*, even after that outer function has returned. The inner function keeps a live connection to those names. This is called a **closure**, and it's the reason a function can hold private state:

```js run
function makeGreeter(greeting) {
  return function (name) {
    return greeting + ", " + name + "!";
  };
}

const sayHi = makeGreeter("Hi");
const sayWelcome = makeGreeter("Welcome");
console.log(sayHi("Ada"));
console.log(sayWelcome("Grace"));
```

Each call to `makeGreeter` creates a fresh `greeting` for the function it returns. `sayHi` and `sayWelcome` don't share it. You'll meet closures again in JavaScript Advanced, but the rule is simple to use now: a function sees the names around it at the place it was written.

Here is the first challenge. Write a function that returns a counter. Each call to the counter returns the next number, and every counter keeps its own count:

```js exercise id=make-counter title="Build a counter with private state"
function makeCounter() {
  // TODO: return a function. Each time it is called, it returns 1, then 2, then 3...
  // Keep the count in a variable that only the returned function can reach.
  return null;
}
--- solution
function makeCounter() {
  let count = 0;
  return function () {
    count = count + 1;
    return count;
  };
}
--- test
const first = makeCounter();
const second = makeCounter();
assert(typeof first === "function", "makeCounter() should return a function");
assertEqual(first(), 1, "The first call should return 1");
assertEqual(first(), 2, "The second call on the same counter should return 2");
assertEqual(second(), 1, "A new counter should start its own count at 1");
assertEqual(first(), 3, "Counters must not share their count");
--- hint
The count has to live outside the returned function, but inside `makeCounter`. Declare it with `let` before the `return`.
--- hint
Return a `function () { ... }` that increases `count` by one and then returns it. Each call to `makeCounter` creates a new `count`.
```

## Using scope to protect your data

A function can change an outer variable, which is convenient and dangerous. If a helper writes into a name that the rest of the program also uses, the bug shows up far away from its cause. Scope is your main defense: keep values local unless something truly needs to be shared.

Scope also lets you build a helper that remembers one result. Here is a wrapper that calls a function only the first time:

```js exercise id=run-once title="Run a function only the first time"
function once(fn) {
  // TODO: return a function that calls fn the first time it's called,
  // remembers the result, and returns that same result on every later call.
  return null;
}
--- solution
function once(fn) {
  let called = false;
  let result;
  return function (value) {
    if (!called) {
      called = true;
      result = fn(value);
    }
    return result;
  };
}
--- test
let calls = 0;
const doubleOnce = once(function (n) {
  calls = calls + 1;
  return n * 2;
});
assertEqual(doubleOnce(5), 10, "The first call should return fn(5), which is 10");
assertEqual(doubleOnce(7), 10, "Later calls should return the saved result, not 14");
assertEqual(calls, 1, "fn should run exactly once");
const other = once(function (s) { return s.toUpperCase(); });
assertEqual(other("hi"), "HI", "once should work with any function");
--- hint
You need two pieces of state: whether `fn` has already run, and the result it returned. Both must live outside the returned function.
--- hint
Inside the returned function, check the flag. If it's not set, call `fn(value)`, save its result and set the flag. Always return the saved result.
```

Now the bug. This function should add up the numbers in a list, but it always returns `0`, because of shadowing. Read the code and identify which `total` the `return` line sees. Your fix should keep one running total, so `sumAll([1, 2, 3])` returns `6`, `sumAll([10, -4])` returns `6`, and `sumAll([])` returns `0`.

```js debug id=shadowed-total title="Fix the shadowed total"
function sumAll(numbers) {
  let total = 0;
  for (const n of numbers) {
    let total = 0; // Bug: this creates a new, separate total
    total = total + n;
  }
  return total;
}
--- solution
function sumAll(numbers) {
  let total = 0;
  for (const n of numbers) {
    total = total + n;
  }
  return total;
}
--- test
assertEqual(sumAll([1, 2, 3]), 6, "sumAll([1, 2, 3]) should return 6");
assertEqual(sumAll([10, -4]), 6, "Negative numbers should be added too");
assertEqual(sumAll([]), 0, "An empty list should give 0");
assertEqual(sumAll([5]), 5, "A single number should be returned as its own sum");
--- hint
Count the `let total` declarations. Which of them is the one the loop updates, and which one does `return` read?
--- hint
Delete the `let` inside the loop, so the loop adds to the same `total` that was created before the loop.
```

> **In the wild:** Browsers and bundlers expose this discipline everywhere. Modules and function scopes keep a library's helper variables private, which is why a library can ship dozens of internal names without breaking the page that uses it. Global variables are the first thing developers try to remove when a project grows.

## Recap

- Names declared at the top level are global; names declared inside a function are local to it.
- `let` and `const` are scoped to their block, including `if` blocks and loops. Use the smallest block that works.
- An inner declaration with the same name **shadows** the outer one, which is a frequent source of bugs.
- `var` is scoped to the whole function and is hoisted, so it can be read as `undefined` before its line runs.
- A closure is a function that keeps access to the variables where it was defined, which lets it hold private state.

**Up next:** Arrow functions and callbacks: a shorter way to write functions, and how to pass a function into another function.
