A closure is a function that keeps using variables from the place where it was written, even after that place has finished running. It sounds like a niche feature until you count how much of JavaScript depends on it. Every callback you pass to `map` or `addEventListener` is a closure. Debounce and throttle helpers, memoization, private state in a module, and the `useState` hook in React all work because a function remembers its surroundings. And a surprising share of "my loop prints the wrong number" bugs are closures capturing a variable that changes later.

This lesson gives you the rule, the reason behind it and the three patterns you'll use most: private state, function factories and memoization. You'll also learn the loop trap well enough to spot it in code review.

## A function remembers where it was written

JavaScript uses **lexical scope**: a name is looked up in the function's own variables first, then in the function that wrote it, then outward to the top level. "Lexical" means that the lookup follows where the code was written on the page, not where the function is called from.

```js run
function makeGreeter(greeting) {
  const punctuation = "!";
  return function greet(name) {
    return greeting + ", " + name + punctuation;
  };
}

const hello = makeGreeter("Hello");
console.log(hello("Ada"));
```

`makeGreeter` has finished running by the time `hello` is called. Its local variables, `greeting` and `punctuation`, should be gone, yet `greet` still reads both. The inner function *closes over* the variables it mentions, so they stay alive for as long as `greet` does. The call site doesn't matter. `hello` can be passed to another file and called there, and it still knows the greeting.

The "close over" image is the right one. The inner function doesn't copy the value `"Hello"`. It keeps a live reference to the variable `greeting`.

## Closures capture variables, not values

This is the detail that matters most. Two closures created in the same scope share the variables of that scope, and they see every later change to them.

```js run
function makeCounter() {
  let count = 0;
  return {
    increment() {
      count += 1;
      return count;
    },
    read() {
      return count;
    },
  };
}

const counterA = makeCounter();
const counterB = makeCounter();
counterA.increment();
counterA.increment();
counterB.increment();
console.log(counterA.read(), counterB.read());
```

Each call to `makeCounter` creates a fresh `count`, so the two counters are independent. Within one counter, `increment` and `read` share the same `count`. That is the entire mechanism behind private state in JavaScript before `#private` fields existed, and it's still the most flexible tool you have.

> **Under the hood:** Each call to a function that contains closures creates an environment object holding the variables those closures reference. Every closure created during that call points at the same environment. That's why `increment` and `read` agree on `count`.

> **In the wild:** React's `useState` is a closure over a per-component store. Each render of a component reads the value from that store, and the setter closes over the same store. The "stale closure" bugs React developers hit are this exact mechanism: a callback created in one render keeps reading the variables of that render.

## The loop trap

Closures capture variables, not values, and a `var` loop counter is one variable for the whole loop. Run this and read the output carefully.

```js run
function collectWithVar() {
  const fns = [];
  for (var i = 0; i < 3; i++) {
    fns.push(() => i);
  }
  return fns.map((f) => f());
}

function collectWithLet() {
  const fns = [];
  for (let i = 0; i < 3; i++) {
    fns.push(() => i);
  }
  return fns.map((f) => f());
}

console.log(collectWithVar(), collectWithLet());
```

With `var`, the three functions all close over the same `i`, and by the time they run the loop has finished with `i === 3`. With `let`, the loop creates a new binding for each iteration, so each function keeps its own `i`. The fix is almost always to use `let`.

> **Pitfall:** The same bug appears with `setTimeout` inside a `var` loop. The callbacks run after the loop, so each one reads the final value. Anywhere a callback is created inside a loop, check which variable it captures.

## Closures keep things alive

A closure keeps every variable it references alive, and the objects those variables point to. That's usually what you want. It also means a long-lived callback can quietly hold a large object in memory after you've finished with it.

```js run
function makeSummary(records) {
  const total = records.reduce((sum, r) => sum + r.amount, 0);
  return () => "total: " + total;
}

const summaryText = makeSummary([{ amount: 5 }, { amount: 7 }]);
console.log(summaryText());
```

The returned arrow function refers only to `total`, so `records` isn't needed by it. Depending on the engine, the array may or may not be kept alive by the closure. Engines are free to optimize this, so you shouldn't rely on either outcome. The practical rule: a closure keeps the variables it *mentions* alive, so don't stash a large structure in a variable that a long-lived callback mentions when you only need a small part of it.

## Challenge: independent accumulators

An accumulator is a function that keeps a running total between calls. Each accumulator should own its total, so two of them never interfere.

```js exercise id=make-accumulator title="Build an accumulator"
function createAccumulator(start) {
  // TODO: return a function add(x) that adds x to a running total,
  // starting from `start`, and returns the new total.
  return null;
}
--- solution
function createAccumulator(start) {
  let total = start;
  return function add(x) {
    total += x;
    return total;
  };
}
--- test
const first = createAccumulator(10);
const second = createAccumulator(0);
assertEqual(first(5), 15, "first(5) on an accumulator started at 10 should return 15");
assertEqual(first(-3), 12, "The running total should persist between calls");
assertEqual(second(4), 4, "A second accumulator must keep its own total");
assertEqual(first(0), 12, "Calling the other accumulator should not change this one");
--- hint
The running total must live in a variable that the returned function can see, but that the outside world can't reach directly. Where can you declare it?
--- hint
Declare `let total = start;` inside `createAccumulator`, then return a function that adds to `total` and returns it.
```

## Challenge: call a function only once

Wrap a function so that the first call runs it and every later call returns the same result without running it again. Hint at the closure: it has to remember two things between calls.

```js exercise id=once-only title="Call at most once"
function once(fn) {
  // TODO: return a wrapper that calls fn only the first time.
  // Later calls return the same value as the first call.
  return null;
}
--- solution
function once(fn) {
  let called = false;
  let result;
  return function (...args) {
    if (!called) {
      called = true;
      result = fn(...args);
    }
    return result;
  };
}
--- test
let calls = 0;
const doubled = once((n) => {
  calls += 1;
  return n * 2;
});
assertEqual(doubled(4), 8, "The first call should return fn's result");
assertEqual(doubled(100), 8, "Later calls should return the first result, not recompute");
assertEqual(calls, 1, "fn should run exactly once");
const greet = once((name) => "hi " + name);
assertEqual(greet("Lin"), "hi Lin", "once should pass arguments through");
--- hint
You need two pieces of state: whether the function has already run, and what it returned. Both must survive between calls.
--- hint
Keep a `called` flag and a `result` variable in the outer function. The wrapper runs `fn` only when `called` is false, then stores the result.
```

## Debug: the loop that returns the wrong labels

This helper should return an object whose method for each name returns that name. Every method returns `undefined` instead. Find the closure that captures the wrong variable, and fix it.

```js debug id=getters-in-a-loop title="Fix the loop getters"
function makeNameGetters(names) {
  const getters = {};
  for (var i = 0; i < names.length; i++) {
    getters[names[i]] = () => names[i];
  }
  return getters;
}
--- solution
function makeNameGetters(names) {
  const getters = {};
  for (let i = 0; i < names.length; i++) {
    getters[names[i]] = () => names[i];
  }
  return getters;
}
--- test
const getters = makeNameGetters(["ada", "lin", "grace"]);
assertEqual(getters.ada(), "ada", "getters.ada() should return 'ada'");
assertEqual(getters.grace(), "grace", "Each getter should return its own name");
const other = makeNameGetters(["x"]);
assertEqual(other.x(), "x", "A fresh call should also work with one name");
--- hint
Run the code and call one of the getters. Then ask which `i` each arrow function is reading, and when the loop finishes what `i` holds.
--- hint
A `var` loop variable is shared by the whole function. Change the loop declaration so each iteration gets its own binding.
```

## Predict the result of two counters

Two counters come from the same factory. One call happens before the join, and one is inside the join. Work out the values carefully, since the second counter starts from its own state.

```js predict id=predict-two-counters title="Predict the counter values"
function makeCounter() {
  let n = 0;
  return () => ++n;
}
const a = makeCounter();
const b = makeCounter();
a();
a();
console.log([a(), b()].join(" "));
--- options
* 3 1
2 1
3 3
1 1
--- explain
Each call to `makeCounter` creates its own `n`. After two calls, `a` has `n === 2`, so the next call of `a()` returns 3. `b` has never been called, so its first call returns 1. The arguments of `join` are evaluated left to right, so `a()` runs before `b()`. Option `2 1` forgets that `a()` is called inside the array, and `3 3` wrongly shares one `n` between the two counters.
```

## Recap

- A function keeps live references to the variables it mentions, even after the function that created them has returned. This is a closure.
- Lexical scope is decided by where code is written, not by where a function is called.
- Each call to a factory creates its own variables, which is how you get independent private state.
- A `var` loop variable is shared by the whole function, so closures created in the loop all see its final value. `let` gives each iteration its own binding.
- Closures keep their referenced variables alive, so a long-lived callback can hold memory you thought was free.

**Up next:** `this` and the four ways a function gets its receiver, and why a method can lose its object the moment you pass it as a callback.
