Open almost any modern JavaScript file and you'll see `=>` everywhere: inside `map` and `filter` calls, in event handlers, in every step of a promise chain. The arrow is just a shorter way to write a function. The part that trips people up is not the syntax but the moment when the arrow quietly returns nothing, and that bug is common enough that you should learn to spot it on sight.

This page covers the arrow syntax, the two shapes it can take, and callbacks: functions you pass to other functions so they can call them later. Callbacks are the reason arrows matter, because they're how JavaScript lets you say "do this for each item" without writing the loop yourself.

## Arrow syntax

An arrow function replaces the `function` keyword with `=>`. You can store it in a `const` like any other value:

```js run
const square = (n) => n * n;
const add = (a, b) => a + b;
const shout = (text) => text.toUpperCase() + "!";

console.log(square(5), add(2, 3), shout("hey"));
```

When the body is a single expression, like `n * n`, the arrow returns that expression's value automatically. You don't write `return`. With one parameter, the parentheses are optional (`n => n * n` also works), but many teams keep them for consistency.

## Block bodies need an explicit return

If you put the body in curly braces, the arrow becomes a normal block, and a block does nothing unless you `return` from it:

```js run
const doubleIt = (n) => { n * 2 };
const doubleRight = (n) => { return n * 2; };

console.log(doubleIt(4));
console.log(doubleRight(4));
```

The first function computes `n * 2` and throws the result away. This is the same missing-`return` bug from the functions lesson, and it's easy to write when you switch between the short and long forms.

> **Pitfall:** `=> { ... }` and `=> ( ... )` mean different things. Braces start a block that needs a `return`. Parentheses wrap a single expression, and that expression is the return value. Forgetting this is the most common arrow bug.

Here's the debug challenge for this idea. The function is meant to produce a label like `Item: pen`. Change it so `makeLabel("pen")` returns `"Item: pen"` and `makeLabel("mug")` returns `"Item: mug"`. Two different fixes work: add `return`, or drop the braces. Either is correct.

```js debug id=label-missing-return title="Fix the arrow that returns nothing"
const makeLabel = (name) => {
  `Item: ${name}`;
};
--- solution
const makeLabel = (name) => `Item: ${name}`;
--- test
assertEqual(makeLabel("pen"), "Item: pen", 'makeLabel("pen") should return "Item: pen"');
assertEqual(makeLabel("mug"), "Item: mug", 'makeLabel("mug") should return "Item: mug"');
assertEqual(makeLabel("cap"), "Item: cap", "The label should work for any name");
--- hint
Look at the braces. A block body only returns a value when it contains a `return` statement.
--- hint
Either add `return` before the template literal, or remove the braces so the arrow returns the template literal directly.
```

> **Tip:** Use the short form when the function is one clear expression, and the block form when you need several steps. Both are fine. Pick the one that makes the return value obvious to the reader.

## Returning an object takes parentheses

Objects use curly braces too, so an arrow that returns an object literal needs parentheses around it:

```js run
const makePoint = (x, y) => ({ x: x, y: y });

console.log(JSON.stringify(makePoint(3, 4)));
```

Leave out the parentheses and the braces start a block instead. A block containing `x: x, y: y` isn't valid JavaScript, so the whole cell fails with a SyntaxError before anything runs. Try it in a scratch cell if you like; the error message is a good one to recognize.

Now a prediction question. Read the arrow carefully, including its parentheses:

```js predict id=pair-object-return title="What does the arrow return?"
const pairOf = (a) => ({ a: a, double: a * 2 });

console.log(JSON.stringify(pairOf(4)));
--- options
{a:4,double:8}
* {"a":4,"double":8}
4 8
undefined
--- explain
The parentheses make the arrow return the object literal. `JSON.stringify` turns it into text, and JSON text always uses double quotes around keys and strings, so the output is `{"a":4,"double":8}`. The first option is what `console.log` would show for the object directly, but this line prints it as JSON text. Without the parentheses, the answer would be `undefined`.
```

## Functions as values: callbacks

Functions are values in JavaScript. You can pass one to another function, and the receiving function decides when, and how often, to call it. A function you pass in this way is a **callback**:

```js run
function repeatAction(times, action) {
  for (let i = 1; i <= times; i++) {
    action(i);
  }
}

repeatAction(3, (i) => console.log("step", i));
```

`repeatAction` knows how to loop. The caller supplies what to do in each step. You separate *when* from *what*, which is the core idea behind almost every library you'll use.

The built-in array methods work the same way. `forEach` calls your callback once for each item:

```js run
const names = ["ada", "grace", "linus"];
names.forEach((name) => console.log("Hello,", name));
```

> **Pitfall:** `forEach` doesn't return a new array. It returns `undefined`, and it's meant for side effects like printing or updating something. When you want a new array from the items, use `map`, which you'll meet in the next lesson.

Here's the first challenge that uses a callback. Write `applyTwice`, which takes a function and a value, calls the function twice, and returns the result:

```js exercise id=apply-twice title="Apply a function twice"
const applyTwice = (fn, value) => {
  // TODO: return fn applied to value, then applied again to that result
  return null;
};
--- solution
const applyTwice = (fn, value) => fn(fn(value));
--- test
assertEqual(applyTwice((n) => n + 3, 10), 16, "Adding 3 twice to 10 should give 16");
assertEqual(applyTwice((n) => n * n, 3), 81, "Squaring 3 twice should give 81");
assertEqual(applyTwice((s) => s + "!", "hi"), "hi!!", "Appending '!' twice should give 'hi!!'");
--- hint
The inner call is `fn(value)`. The outer call passes that result back into `fn`.
--- hint
Write `fn(fn(value))`, and make sure the block body returns it, or use the short form without braces.
```

Next, write a function that takes a test callback and counts how many items pass it. This is the pattern behind `filter`, built by hand, so you can see the loop that the built-in hides:

```js exercise id=count-where title="Count the items that pass a test"
const countWhere = (items, test) => {
  // TODO: return how many items make test(item) return true
  return null;
};
--- solution
const countWhere = (items, test) => {
  let count = 0;
  items.forEach((item) => {
    if (test(item)) count = count + 1;
  });
  return count;
};
--- test
assertEqual(countWhere([1, 2, 3, 4, 5], (n) => n % 2 === 0), 2, "Two of 1 to 5 are even");
assertEqual(countWhere(["a", "bb", "ccc"], (s) => s.length > 1), 2, "Two strings are longer than one character");
assertEqual(countWhere([], () => true), 0, "An empty list has nothing that passes");
assertEqual(countWhere([7, 8, 9], () => false), 0, "A test that never passes should count 0");
--- hint
Start `count` at `0`, then call `items.forEach` with a callback that adds one to `count` when `test(item)` is true.
--- hint
Inside the callback, use `if (test(item))`. After the loop, return `count`. Don't forget that `forEach` itself returns nothing.
```

> **Under the hood:** An arrow function doesn't have its own `this`. It uses the `this` of the code around it where it was written. A regular `function` gets its own `this`, decided by how it's called. This difference is why arrows are the usual choice for callbacks inside methods, and it's the reason `this` surprises people when they pass a regular function as a callback. You'll see this in the classes lesson.

```js
// A regular callback gets its own `this`, which is not the object you expect.
const timer = {
  seconds: 0,
  tick() {
    [1, 2].forEach((step) => { this.seconds += step; }); // arrow: this is timer
  },
};
```

> **In the wild:** Browsers take callbacks for almost everything. An event listener such as `button.addEventListener("click", () => ...)` and a `.then(result => ...)` on a promise are both callbacks, and each one is a small arrow function written exactly like the ones on this page.

## Recap

- `(params) => expression` is a short function that returns the expression's value automatically.
- `(params) => { statements }` is a block body: it returns nothing unless you write `return`.
- To return an object literal from a short arrow, wrap it in parentheses: `() => ({ ... })`.
- A callback is a function passed to another function, which decides when to call it.
- `forEach` returns `undefined`; use it for side effects, and use `map` or `filter` when you need a new array.

**Up next:** Thinking in transformations: `map`, `filter` and `reduce`, the three callback methods that replace most loops over arrays.
