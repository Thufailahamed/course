Performance advice usually arrives as folklore: "use `for` loops, they're faster", "never use `forEach`", "wrap everything in `useMemo`". Most of it is either outdated or aimed at the wrong problem. The costs that actually hurt real programs are algorithmic. A function that scans an array inside a loop gets slower with the square of the input size, and no micro-optimization will rescue it. A function that runs the same expensive computation on every keystroke makes the interface stutter. Learning to see those patterns is worth far more than memorizing which loop form is faster this year.

This lesson covers three tools you'll use constantly: reasoning about how work grows with input size, memoization (trading memory for repeated work), and debounce (refusing to do work until the input settles). You'll also learn how to measure before you optimize, so you can tell which one you actually need.

## Measure before you believe

Timing a function with `performance.now()` is easy, but the numbers are noisy. The first run includes JIT warm-up, the garbage collector can fire in the middle of a measurement, and the browser may be busy with other work. A single timing is an anecdote. Repeat the run, look at the median, and compare two versions under the same conditions.

Because the lesson output has to be the same for every learner, the examples here count work instead of timing it. Counting is often the more useful measurement anyway: a counter tells you how many operations an algorithm performs, and that number scales in a way you can predict.

> **Tip:** Measure in the environment you ship. A function that's fast in a Node benchmark may be slow in a Web Worker on a phone, and profilers in your browser or Node show you where the time actually goes.

## Growth rate: count the work, not the seconds

Consider finding every pair of items in a list. The nested-loop version does a fixed amount of work for each pair, so counting the steps shows the growth directly:

```js run
function countPairs(items) {
  let steps = 0;
  for (let i = 0; i < items.length; i++) {
    for (let j = i + 1; j < items.length; j++) steps++;
  }
  return steps;
}

console.log(countPairs([1, 2, 3, 4]), countPairs(Array(10).fill(0)));
```

Ten items give 45 pairs, and a thousand would give nearly half a million. Doubling the input roughly quadruples the work. This is O(n²), and it's the shape behind most "it was fine in development and freezes with real data" bugs.

Now the membership check that hides inside a loop. `includes` scans the array from the start, so it's O(n) per call. A `Set` answers `has` in roughly constant time. Put the first inside the second's loop, and you've multiplied them:

```js run
const ids = Array.from({ length: 1000 }, (_, i) => i * 2);
const lookups = [...Array(1000).keys()];
const idSet = new Set(ids);

console.log(lookups.filter((x) => ids.includes(x)).length, lookups.filter((x) => idSet.has(x)).length);
```

Both lines print the same answer. Only the cost differs, and with a thousand items the difference in real time is already visible. With a hundred thousand, it's the difference between a responsive page and a hung one.

> **Pitfall:** Don't optimize the loop body when the problem is the loop count. Replacing `forEach` with `for` changes the constant factor. Replacing `includes` inside a loop with a Set changes the growth rate.

## Memoization: remember the answers you already computed

Memoization stores a function's results so that repeated calls with the same input skip the work. It works only for pure functions, the ones whose output depends only on their arguments, with no side effects. A cache of a function that reads the clock or the network returns stale answers.

The cache is a Map keyed on the input. The count below shows the effect: four calls, but only two real computations.

```js run
let slowCalls = 0;
const square = (n) => {
  slowCalls++;
  return n * n;
};
const cache = new Map();
const cachedSquare = (n) => {
  if (!cache.has(n)) cache.set(n, square(n));
  return cache.get(n);
};

[4, 4, 5, 4].forEach((n) => cachedSquare(n));
console.log(slowCalls, cache.size);
```

A Map key for a single number is simple. For a function with several arguments, the key has to identify the whole argument list. `JSON.stringify` is a practical choice for plain data, with the limitation that objects are compared by their contents, not their identity:

```js run
const memo = new Map();
const keyOf = (args) => JSON.stringify(args);

memo.set(keyOf([1, { id: 2 }]), "found");
console.log(memo.get(keyOf([1, { id: 2 }])), memo.get(keyOf([1, { id: 3 }])));
```

Recursive functions are where memoization changes the complexity class. Here is Fibonacci with a memo. Each value is computed once, and every later request is a lookup:

```js predict id=predict-memo-calls title="Counting the work"
let calls = 0;
const memo = new Map();
function fib(n) {
  calls++;
  if (n < 2) return n;
  if (memo.has(n)) return memo.get(n);
  const value = fib(n - 1) + fib(n - 2);
  memo.set(n, value);
  return value;
}
console.log(fib(10), calls);
--- options
55 10
* 55 19
55 177
89 19
--- explain
Every call increments `calls`, including the ones that return from the memo. With memoization, each `n` from 2 to 10 is computed once, and the other calls are cache hits. Without the memo, `fib(10)` makes 177 calls, because each value is recomputed many times. Memoization turns an exponential recursion into a linear one, which is the most dramatic complexity change you'll meet in everyday code.
```

Write the reusable version as an exercise. The test counts how many times the wrapped function really runs.

```js exercise id=memoize title="Memoize any function of JSON-friendly arguments"
function memoize(fn) {
  // TODO: return a function that calls fn only once per distinct argument list.
  // Key the cache on the arguments with JSON.stringify(args).
  return null;
}
--- solution
function memoize(fn) {
  const cache = new Map();
  return (...args) => {
    const key = JSON.stringify(args);
    if (!cache.has(key)) cache.set(key, fn(...args));
    return cache.get(key);
  };
}
--- test
let calls = 0;
const slowAdd = memoize((a, b) => { calls++; return a + b; });
assertEqual(slowAdd(2, 3), 5, "The first call should compute the sum");
assertEqual(slowAdd(2, 3), 5, "The second call should use the cache");
assertEqual(calls, 1, "fn should run once for the same arguments");
assertEqual(slowAdd(3, 2), 5, "Swapped arguments are a different call");
assertEqual(calls, 2, "A new argument list should compute again");
--- hint
Use `(...args)` to accept any number of arguments, and `fn(...args)` to call the original function with them.
--- hint
`const key = JSON.stringify(args);` gives one string key for the whole argument list. Check `cache.has(key)` before computing, as in the example above.
```

A cache can also be wrong in a quiet way. Here's a two-argument version with a key that forgets an argument.

```js debug id=memo-key title="A cache that ignores one argument"
// Cache results of fn(a, b). The same pair of arguments should be computed only once.
function memoize2(fn) {
  const cache = new Map();
  return (a, b) => {
    if (!cache.has(a)) cache.set(a, fn(a, b));
    return cache.get(a);
  };
}
--- solution
function memoize2(fn) {
  const cache = new Map();
  return (a, b) => {
    const key = JSON.stringify([a, b]);
    if (!cache.has(key)) cache.set(key, fn(a, b));
    return cache.get(key);
  };
}
--- test
const power = memoize2((base, exp) => base ** exp);
assertEqual(power(2, 3), 8, "2 ** 3 should be 8");
assertEqual(power(2, 4), 16, "The same base with a different exponent needs its own result");
assertEqual(power(3, 2), 9, "A different base should also be computed");
--- hint
The cache key has to identify the whole set of arguments. Keying on `a` alone means `(2, 3)` and `(2, 4)` share one entry.
--- hint
Build the key from both arguments, for example `JSON.stringify([a, b])`, and use that same key for `has`, `set` and `get`.
```

> **Under the hood:** Memoized values live as long as the cache does. An unbounded Map keyed by user input is a memory leak with a friendly face. Bound the cache (an LRU, or a size limit), or key it on something that the garbage collector can release, like the WeakMap pattern from the previous lesson.

## Debounce: wait until the input settles

Some work should happen once a burst is over, not once per event. Search-as-you-type, window resizing and auto-save all fire faster than anyone can read the results. Debounce returns a wrapper that postpones the call: each invocation cancels the pending one and schedules a new one. The function runs only when `wait` milliseconds pass with no new calls.

The two parts of a debounce are the timer ID, which has to outlive any single call, and the latest arguments, which should be the ones that run.

```js exercise id=debounce title="Debounce: run once after the calls stop"
function debounce(fn, wait) {
  // TODO: return a function that, on each call, cancels any pending call and
  // schedules fn with the latest arguments to run `wait` ms later.
  return null;
}
--- solution
function debounce(fn, wait) {
  let timer = null;
  return (...args) => {
    clearTimeout(timer);
    timer = setTimeout(() => fn(...args), wait);
  };
}
--- test
const seen = [];
const save = debounce((value) => seen.push(value), 30);
save("a");
save("b");
save("c");
assertEqual(seen, [], "Nothing should run synchronously");
await new Promise((r) => setTimeout(r, 60));
assertEqual(seen, ["c"], "Only the last call should run, once, after the quiet period");
save("d");
await new Promise((r) => setTimeout(r, 60));
assertEqual(seen, ["c", "d"], "A new burst should schedule a new run");
--- hint
Keep the timer ID in a variable outside the returned function, so each call can cancel the previous timer with `clearTimeout`.
--- hint
Inside the returned function, call `clearTimeout(timer)` first, then assign `timer = setTimeout(() => fn(...args), wait)`.
```

> **Pitfall:** Debounce delays the result, so a debounced save can lose data if the user closes the tab during the wait. Flush pending calls on `pagehide` or `beforeunload` when the work matters. Throttle is the alternative when you need a steady rate of updates rather than a single update at the end.

## Set-based dedupe in linear time

Deduplication is a good closing example, because the naive version looks harmless. Checking the result array with `includes` before every push is O(n²) in the worst case. Tracking what you've emitted in a Set keeps the whole pass linear.

```js exercise id=unique-in-order title="Unique values, first occurrence wins"
function uniqueInOrder(items) {
  // TODO: return the values of `items` without duplicates, keeping the order of first appearance.
  // Aim for linear time: a Set lookup per item beats scanning the result with includes.
  return null;
}
--- solution
function uniqueInOrder(items) {
  const seen = new Set();
  const result = [];
  for (const item of items) {
    if (!seen.has(item)) {
      seen.add(item);
      result.push(item);
    }
  }
  return result;
}
--- test
assertEqual(uniqueInOrder([3, 1, 3, 2, 1]), [3, 1, 2], "Keep the first occurrence of each value");
assertEqual(uniqueInOrder(["b", "a", "b"]), ["b", "a"], "Strings should work too");
assertEqual(uniqueInOrder([]), [], "An empty list should stay empty");
const big = Array.from({ length: 20000 }, (_, i) => i % 1000);
assertEqual(uniqueInOrder(big).length, 1000, "A large input should still give the distinct count");
--- hint
Track what you've already emitted in a Set, and push an item to the result only the first time you see it.
--- hint
Inside a `for...of` loop: `if (!seen.has(item)) { seen.add(item); result.push(item); }`.
```

> **In the wild:** React's `useMemo` and `memo` are memoization with a dependency list, and framework routers and build tools cache parsed results the same way. Each of them works only because the cached functions are treated as pure, which is the contract you take on when you memoize.

## Recap

- Count the work an algorithm does. Nested loops over the same data grow with the square of the input, and that matters far more than loop syntax.
- Replace repeated `includes` calls with a Set when membership checks happen inside a loop.
- Memoize pure functions with a Map keyed on the full argument list, and bound the cache when its keys come from users.
- Debounce delays work until a burst of events settles. Keep the timer outside the wrapper, and cancel it on each call.
- Measure before you optimize, repeat your measurements, and trust counts and growth rates over single timings.

**Up next:** modules, the unit of code organization that decides what your program loads, when, and what it can see.
