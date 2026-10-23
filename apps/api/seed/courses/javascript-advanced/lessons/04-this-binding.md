`this` is the most misunderstood word in JavaScript, mostly because it doesn't work the way its name suggests. It isn't "the object the function was written in", and it isn't fixed when the function is created. It's a value the engine passes in at each call, and it depends entirely on how the function is called. The same function can see a different `this` on every call, and that's why a method works when you call it on its object and crashes when you pass it to a callback.

In real code this shows up everywhere: event handlers that lose their component, `forEach` callbacks that read `undefined` where they expected an object, and libraries that accept a function and call it with a receiver you never chose. Once you can name the rule the engine uses, each of these becomes a two-second diagnosis.

## The rule is about the call

Every ordinary function call has a receiver, the value of `this` for that call. The engine chooses it from the way the call is written, using four rules in priority order:

1. **`new`**: `new Thing()` creates a new object and binds `this` to it.
2. **Explicit binding**: `fn.call(obj)`, `fn.apply(obj)` and `fn.bind(obj)` set `this` to `obj`.
3. **Implicit binding**: `obj.fn()` sets `this` to the object before the dot.
4. **Default binding**: a plain call `fn()` has no receiver, so `this` is `undefined` in strict mode and the global object in sloppy mode.

Arrow functions are the exception. They don't have a `this` of their own at all, and they use whatever `this` was in scope where they were written. More on that below.

```js run
const counter = {
  label: "clicks",
  count: 3,
  describe() {
    return this.label + ": " + this.count;
  },
};

console.log(counter.describe());
```

Here `counter.describe()` uses implicit binding. The receiver is `counter`, which is the object before the dot. Notice that the function's text says nothing about `counter`. Move `describe` into another object and it would describe that object instead.

> **Tip:** When you're unsure what `this` is, look at the call site, not the function definition. Find the `(` and look at what sits directly before the dot, if anything.

## Losing the receiver

The moment you read a method off its object and call it later, you've separated the function from the receiver. The call site is now a plain call.

```js run
const timer = {
  seconds: 30,
  tick() {
    "use strict";
    return this === undefined ? "lost" : "still bound: " + this.seconds;
  },
};

const detached = timer.tick;
console.log(timer.tick(), "|", detached());
```

`timer.tick()` keeps its receiver. `detached()` has no receiver, so `this` is `undefined`. The `"use strict"` directive inside `tick` makes that visible on every engine. Without it, a sloppy function would receive the global object instead, and `this.seconds` would be `undefined` rather than throwing.

This is the bug behind a huge share of "cannot read properties of undefined" errors in event handlers. The method was passed as a callback, and the callback ran with no receiver.

## call, apply and bind

Three built-in methods let you choose the receiver yourself. `call` and `apply` invoke the function immediately, and `bind` returns a new function with the receiver fixed.

```js run
function introduce(greeting, punctuation) {
  return greeting + ", I am " + this.name + punctuation;
}

const person = { name: "Grace" };
console.log(introduce.call(person, "Hi", "."));
console.log(introduce.apply(person, ["Hello", "!"]));

const bound = introduce.bind(person, "Hey");
console.log(bound("?"));
```

`call` takes the arguments one by one, and `apply` takes them as an array. The rule of thumb is to remember `call` as "comma-separated" and `apply` as "array". `bind` is different because it doesn't call anything. It creates a new function whose receiver is permanently `person`, and it can also fix leading arguments, here `"Hey"`.

> **Pitfall:** A bound function's `this` cannot be changed again. Calling `.call` on a bound function ignores the new receiver. You'll see this in the predictions below.

## Arrow functions take `this` from where they are written

An arrow function has no `this` binding of its own. When it refers to `this`, it reads the `this` of the nearest enclosing non-arrow function, the one that was active when the arrow was created. The receiver of the arrow itself is irrelevant.

```js run
const team = {
  name: "Platform",
  members: ["Ada", "Lin"],
  withArrow() {
    return this.members.map((m) => m + " @ " + this.name);
  },
  withFunction() {
    "use strict";
    return this.members.map(function (m) {
      return m + " @ " + (this === undefined ? "undefined" : this.name);
    });
  },
};

console.log(team.withArrow());
console.log(team.withFunction());
```

`withArrow` works because the arrow reads `this` from `withArrow`, which was called as `team.withArrow()`. `withFunction` has a classic `function` callback, and `map` calls that callback with no receiver. Strict mode makes the lost `this` obvious as `undefined`. The fix for a callback that needs the outer `this` is an arrow function, or the second argument to `map`, which is a `thisArg`.

> **In the wild:** Before arrow functions, the standard fix was `const self = this;` or `.bind(this)` in the constructor. You still see both in older React class components and in jQuery plugins. Arrow functions remove the need for them, as long as the arrow is written inside the method that owns the data.

## The `new` rule

`new` is the highest-priority rule, and it's the one that makes constructor functions work. Calling a function with `new` creates an empty object, sets its prototype (you'll learn that in lesson 5), runs the function with `this` bound to the new object, and returns that object.

```js run
function Point(x, y) {
  this.x = x;
  this.y = y;
}

const p = new Point(2, 3);
console.log(p.x + p.y, p instanceof Point);
```

Classes, which you'll meet in lesson 6, are built on this same mechanism. Notice that calling `Point(2, 3)` *without* `new` would set `x` and `y` on whatever `this` happens to be, which in sloppy mode is the global object. That's exactly the hazard the `class` syntax was designed to prevent.

## Challenge: bind every method you need

A common pattern is to give an object's methods to other code, such as a list of callbacks. Write a helper that binds the named methods of an object to that object, in place, so they keep working when they're detached.

```js exercise id=bind-methods title="Bind methods to their object"
function bindMethods(obj, names) {
  // TODO: for each name in `names`, replace obj[name] with a version bound to obj.
  // Return obj.
  return null;
}
--- solution
function bindMethods(obj, names) {
  for (const name of names) {
    obj[name] = obj[name].bind(obj);
  }
  return obj;
}
--- test
const store = {
  total: 0,
  add(n) {
    this.total += n;
    return this.total;
  },
  read() {
    return this.total;
  },
};
const returned = bindMethods(store, ["add", "read"]);
assert(returned === store, "bindMethods should return the same object");
const add = store.add;
const read = store.read;
add(5);
add(2);
assertEqual(read(), 7, "A detached bound method should still update obj.total");
const other = { total: 100, add: store.add };
other.add(1);
assertEqual(store.total, 8, "A bound method should keep its original receiver, even when copied");
--- hint
A detached method loses its receiver. `bind` returns a new function with the receiver fixed, so think about what you can assign back to `obj[name]`.
--- hint
Loop over `names`, and for each one assign `obj[name].bind(obj)` back to `obj[name]`. Return `obj` at the end.
```

## Challenge: write your own `call`

Implementing `call` is a classic interview question, and it teaches the implicit rule directly. The trick is to make the function a property of the receiver, call it as a method, and clean up afterwards. Assume the receiver is always an object.

```js exercise id=my-call title="Implement call"
function myCall(fn, thisArg, ...args) {
  // TODO: call fn with thisArg as its receiver and args as its arguments,
  // without using fn.call, fn.apply or fn.bind.
  // Leave thisArg with exactly the properties it had before.
  return null;
}
--- solution
function myCall(fn, thisArg, ...args) {
  const key = "__myCallTemp";
  thisArg[key] = fn;
  const result = thisArg[key](...args);
  delete thisArg[key];
  return result;
}
--- test
const account = { owner: "Ada", balance: 10 };
const describe = function (bonus) {
  return this.owner + " has " + (this.balance + bonus);
};
assertEqual(myCall(describe, account, 5), "Ada has 15", "myCall should use thisArg as this");
assertEqual(myCall(describe, { owner: "Lin", balance: 1 }, 0), "Lin has 1", "The receiver should change with each call");
assertEqual(Object.keys(account), ["owner", "balance"], "thisArg should not keep the temporary property");
assert(myCall(function () { return this; }, account) === account, "this should be exactly thisArg");
--- hint
A method is called with the object before the dot as its receiver. So if you store `fn` as a property of `thisArg`, calling that property gives `fn` the right `this`.
--- hint
Put `fn` on `thisArg` under a temporary key, call `thisArg[key](...args)`, then remove the key with `delete` before you return the result.
```

## Debug: a callback that loses `this`

This method should add every number in a list to the running total. It throws instead. Find the callback that has no receiver, and fix it without changing `add`.

```js debug id=scoreboard-callback title="Fix the callback's this"
const scoreboard = {
  points: 0,
  add(n) {
    this.points += n;
    return this.points;
  },
  addAll(list) {
    list.forEach(function (n) {
      this.add(n);
    });
    return this.points;
  },
};
--- solution
const scoreboard = {
  points: 0,
  add(n) {
    this.points += n;
    return this.points;
  },
  addAll(list) {
    list.forEach((n) => {
      this.add(n);
    });
    return this.points;
  },
};
--- test
assertEqual(scoreboard.addAll([1, 2, 3]), 6, "addAll([1, 2, 3]) should bring the total to 6");
assertEqual(scoreboard.addAll([10]), 16, "addAll should keep adding to the same total");
assertEqual(scoreboard.add(4), 20, "add should still work on its own");
--- hint
Run it and read the message. Ask what `this` is inside the `function (n)` callback, which `forEach` calls with no receiver.
--- hint
An arrow function keeps the `this` of the `addAll` call it sits inside. Change the callback to an arrow function.
```

## Predict: a detached method in strict mode

The method below checks whether it has a receiver. Work out what each call sees.

```js predict id=predict-detached-this title="Predict the detached call"
const robot = {
  name: "R2",
  speak() {
    "use strict";
    return this ? this.name : "nobody";
  },
};
const speak = robot.speak;
console.log(robot.speak() + " " + speak());
--- options
* R2 nobody
R2 R2
R2 undefined
undefined undefined
--- explain
`robot.speak()` has `robot` as its receiver, so `this.name` is `"R2"`. `speak()` is a plain call, and because `speak` runs in strict mode, `this` is `undefined`, which is falsy, so the function returns `"nobody"`. The option `R2 undefined` describes what a sloppy function would do: it would receive the global object and read `globalThis.name`, which is `undefined`. Strict mode turns that silent mistake into an explicit check.
```

## Predict: bind beats call

Here a bound function meets a later `call`. Think about which receiver can still change.

```js predict id=predict-bind-wins title="Predict the bound call"
function label(prefix) {
  return prefix + ":" + this.id;
}
const bound = label.bind({ id: 7 }, "job");
console.log(bound.call({ id: 99 }));
--- options
* job:7
job:99
undefined:7
job:undefined
--- explain
`bind` fixes two things: the receiver, `{ id: 7 }`, and the first argument, `"job"`. A bound function ignores any later `call` or `apply` receiver, so `bound.call({ id: 99 })` still reads `id` from the bound object. The `99` never gets a chance. Explicit binding wins over the implicit rule that `call` would normally apply.
```

## Recap

- `this` is decided at each call by how the function is called: `new`, then explicit binding, then the object before the dot, then the default.
- A method stops having a receiver when you read it off its object and call it later. Strict mode makes the lost receiver `undefined`.
- `call` and `apply` set the receiver for one call, and `bind` fixes it permanently. A bound function cannot be rebound.
- Arrow functions don't have their own `this`. They read it from the code they were written in, which makes them the right choice for callbacks inside methods.
- When debugging, look at the call site, not the function definition.

**Up next:** prototypes and the prototype chain, which decide what happens when a property lookup misses on an object, and why `new` sets up the object's parent.
