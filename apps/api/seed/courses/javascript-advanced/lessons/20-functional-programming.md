Functional programming in JavaScript is not a religion you have to join. It's a set of habits that make code easier to test, reorder and reuse: functions that take their inputs as arguments and return their results, data that isn't changed under your feet, and small pieces that combine into bigger ones. The payoff is concrete. A pure function can be tested with one call and no setup. A pipeline of pure steps can be rearranged or cached without fear. And many of the bugs earlier in this course (shared mutation, stale state, hidden dependencies) simply can't happen inside code that follows these rules.

This lesson covers purity and why it matters, higher-order functions (and the reduce that underlies most of them), composition and pipelines, and currying and partial application. Along the way you'll meet the pitfalls that catch people who learn these tools from a slogan rather than from the rules.

## Pure functions: the output depends only on the input

A pure function does two things. Its result depends only on its arguments, and it doesn't change anything outside itself. Break either rule and the function becomes impure, which means it can return different answers for the same input or do work you didn't ask for.

```js run
let taxRate = 0.2;
const priceImpure = (p) => p * (1 + taxRate);
const pricePure = (p, rate) => p * (1 + rate);

taxRate = 0.5;
console.log(priceImpure(100), pricePure(100, 0.2));
```

`priceImpure(100)` changed its answer when some other code changed `taxRate`, and nothing in the call site shows that. `pricePure` takes everything it needs as arguments, so the call site is the whole story. Purity is about making dependencies visible, and it's the same idea as dependency injection from the testing lesson, applied to plain functions.

> **Tip:** When a function feels hard to test, look for the hidden input (a global, a clock, a random number, the DOM) and move it into the parameter list. The function usually gets shorter and more obviously correct.

## Higher-order functions and reduce

A higher-order function takes a function as an argument, or returns one. `map`, `filter` and `reduce` are the three you'll use most, and all three are built on one idea: walk through a collection and accumulate a result. `reduce` is the general form, and you can express the others with it:

```js run
const double = (xs) => xs.reduce((out, x) => [...out, x * 2], []);
const evens = (xs) => xs.reduce((out, x) => (x % 2 === 0 ? [...out, x] : out), []);

console.log(double([1, 2, 3]), evens([1, 2, 3, 4]));
```

The second argument to `reduce`, the seed, is the starting accumulator. Every version above passes `[]`, so the accumulator is a fresh array each time the function runs.

> **Pitfall:** `[...out, x]` copies the whole accumulator on every step. For a list of ten thousand items, that's about fifty million element copies. In performance-sensitive code, use `push` on a local array that you own, and return it at the end. Purity is about the function's external effects. A local mutable accumulator is fine, because nothing outside sees it change.

### The seed matters

A `reduce` without a seed uses the first element as the starting accumulator. That's convenient until the array is empty or has one element, and the behavior changes:

```js predict id=predict-reduce-seed title="Reduce with and without a seed"
const nums = [5];
console.log(nums.reduce((a, b) => a + b), nums.reduce((a, b) => a + b, 10));
--- options
15 5
15 15
* 5 15
5 10
--- explain
With one element and no seed, `reduce` returns that element and never calls the callback, so the first result is 5. With a seed of 10, the callback runs once and computes 10 + 5, which is 15. The rule to remember: a `reduce` without a seed throws a `TypeError` on an empty array, so give a seed whenever the input might be empty.
```

The next challenge shows that rule in a realistic setting: a function that picks the best item, which must handle an empty list.

```js debug id=best-item title="The reduce that crashes on empty input"
// Return the item with the highest score, or null when the list is empty. On ties, keep the earlier item.
function bestItem(items) {
  return items.reduce((best, item) => (item.score > best.score ? item : best));
}
--- solution
function bestItem(items) {
  return items.reduce((best, item) => (best === null || item.score > best.score ? item : best), null);
}
--- test
assertEqual(bestItem([]), null, "An empty list should give null, not an error");
assertEqual(bestItem([{ name: "a", score: 3 }]).name, "a", "A single item should be returned");
const ranked = [{ name: "a", score: 3 }, { name: "b", score: 9 }, { name: "c", score: 9 }];
assertEqual(bestItem(ranked).name, "b", "The highest score wins, and ties keep the earlier item");
--- hint
Without a seed, `reduce` starts from the first item. With an empty array there is no first item, so `best` is `undefined` and reading `.score` throws.
--- hint
Pass `null` as the seed, and in the callback treat `best === null` as "nothing chosen yet", so the first item always becomes the initial best.
```

## Composition: small steps, joined into a pipeline

Composition joins functions so that the output of one becomes the input of the next. Two directions exist, and mixing them up is a common source of confusion. `compose` applies the rightmost function first, the way mathematics writes `f(g(x))`. `pipe` applies the leftmost first, which reads top to bottom like a list of steps.

```js run
const compose = (...fns) => (x) => fns.reduceRight((v, f) => f(v), x);
const addOne = (x) => x + 1;
const times3 = (x) => x * 3;

console.log(compose(addOne, times3)(4), compose(times3, addOne)(4));
```

`compose(addOne, times3)(4)` is `addOne(times3(4))`, which is 13. The order changes the answer, so composition is not commutative in general. That's why you name the direction you're writing.

Pipelines are how this shows up in real code: data goes in one end, and each stage transforms it. Read the stages as a list, and each one can be tested alone.

```js exercise id=pipe-steps title="Pipe steps from left to right"
function pipe(...fns) {
  // TODO: return a function that takes one input and passes it through `fns`
  // from left to right, returning the final result. With no steps, return the input unchanged.
  return null;
}
--- solution
function pipe(...fns) {
  return (input) => fns.reduce((value, fn) => fn(value), input);
}
--- test
assertEqual(pipe((x) => x + 1, (x) => x * 2)(3), 8, "Steps should run left to right");
assertEqual(pipe((x) => x * 2, (x) => x + 1)(3), 7, "Swapping the steps should change the result");
assertEqual(pipe()(5), 5, "An empty pipe should return its input");
assertEqual(pipe((s) => s.trim(), (s) => s.toUpperCase())("  hi "), "HI", "Each step receives the previous step's result");
--- hint
`reduce` over `fns`, with the input as the seed, does this in one line. Each step takes the accumulated value.
--- hint
`(input) => fns.reduce((value, fn) => fn(value), input)` is the whole function. The seed is `input`, so an empty `fns` returns `input` unchanged.
```

> **Pitfall:** A pipeline built on functions that take extra arguments can pass the wrong one. Many array methods call their callback with `(item, index, array)`, which leads to the next example.

```js run
console.log(["1", "2", "3"].map(parseInt));
console.log(["1", "2", "3"].map((s) => parseInt(s, 10)));
```

`parseInt` accepts `(string, radix)`, so `map` passes the index as the radix. Index 1 means base 1, which is invalid, and index 2 means base 2, where `3` is not a digit. The fix is to wrap the function so that only the intended argument reaches it. Composition works best when each step has exactly the arity you think it has.

## Currying and partial application

A curried function takes its arguments one or a few at a time. Each call returns a function until all the arguments have arrived, and then it computes the result. Currying lets you fix some arguments early and reuse the result, which is partial application.

The built-in tool for partial application is `bind`. It fixes leading arguments and returns a new function:

```js run
const greet = (greeting, name) => `${greeting}, ${name}!`;
const hello = greet.bind(null, "Hello");

console.log(hello("Ada"), hello.length);
```

A bound function's `length` counts only the arguments you haven't fixed, which is why `hello.length` is 1. Keep that in mind, because the currying helper you're about to write depends on `length`.

Currying is an arity-driven transformation. The helper below collects arguments across calls until it has as many as the original function declares, then calls it:

```js exercise id=curry-arity title="Curry a function by its arity"
function curry(fn) {
  // TODO: return a function that collects arguments across calls until it has
  // fn.length of them, then returns fn applied to all of them.
  return null;
}
--- solution
function curry(fn) {
  return function curried(...args) {
    if (args.length >= fn.length) return fn(...args);
    return (...more) => curried(...args, ...more);
  };
}
--- test
const add3 = curry((a, b, c) => a + b + c);
assertEqual(add3(1)(2)(3), 6, "One argument at a time should work");
assertEqual(add3(1, 2)(3), 6, "Mixing groups of arguments should work");
assertEqual(add3(1)(2, 3), 6, "Any split of the arguments should work");
assertEqual(add3(1, 2, 3), 6, "All arguments at once should work");
const times = curry((a, b) => a * b);
const triple = times(3);
assertEqual([1, 2, 4].map(triple), [3, 6, 12], "A partially applied function should be reusable");
--- hint
Use `fn.length` to know how many arguments you need. If you already have enough, call `fn(...args)`. If not, return a function that will add more arguments and call the curried function again.
--- hint
Name the returned function, for example `function curried(...args)`, so it can call itself with `curried(...args, ...more)`.
```

> **Under the hood:** `fn.length` counts parameters before the first one with a default value, and it doesn't count rest parameters. A function declared as `(a, b = 2)` has length 1, so a curry built on `length` would call it too early. Write curried functions with explicit parameters, or pass the arity as an argument when the signature is unusual.

## Purity in practice: the test you get for free

Pure functions are easy to test because the test needs nothing but inputs and expected outputs. You don't mock a clock, reset global state or wait for a timer. This is the strongest practical argument for functional style in a codebase that already has side effects: push the effects to the edges, and keep the logic in pure functions in the middle.

A shopping total is a good example. The calculation is pure and the I/O is at the edge:

```js run
const lineTotal = (item) => item.price * item.qty;
const cartTotal = (items) => items.reduce((sum, item) => sum + lineTotal(item), 0);

const cart = [{ price: 4, qty: 2 }, { price: 1.5, qty: 3 }];
console.log(cartTotal(cart), cartTotal([]));
```

Both functions are trivially testable. A pure function can also be memoized without worrying about stale results, which is why the performance lesson's cache works so well on pure data transforms.

## Recap

- A pure function's result depends only on its arguments and it changes nothing outside itself. Move hidden inputs into parameters.
- `reduce` is the general form of `map` and `filter`. Always give it a seed when the input might be empty.
- `compose` applies right to left, `pipe` applies left to right. Name the direction you're writing.
- Callbacks receive extra arguments like the index. Wrap a function when it must receive only the intended argument, as with `parseInt`.
- Currying uses `fn.length`, and `bind` fixes leading arguments. Watch out for default and rest parameters, which change the length.

**Up next:** debugging like a senior engineer: the tools, the habits and the traps that separate a fix from a guess.
