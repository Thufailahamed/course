Almost every interesting piece of JavaScript code waits for something: a network response, a file, a timer, a user's click. A promise is the object that stands for a result that doesn't exist yet. It's the handle you pass around, attach callbacks to, and combine with other handles, so the code can say "when this value arrives, do that" instead of blocking or nesting callbacks ten levels deep.

Promises are also where most asynchronous bugs begin. A chain that forgets to `return` a value silently passes `undefined` down the line. A `catch` that doesn't rethrow hides a failure from everyone upstream. A `new Promise` wrapped around another promise adds a layer that is never needed. This lesson gives you the exact states, the rules for chaining and error propagation, and the traps that come up in real code.

## Three states, one decision

A promise is always in one of three states. It starts **pending**. It becomes **fulfilled** with a value, or **rejected** with a reason. Once it leaves pending, it's **settled**, and it never changes again. That one-way rule is what makes promises safe to share: every consumer sees the same result, however late it attaches.

The executor you pass to `new Promise` runs immediately and synchronously. It calls `resolve(value)` or `reject(reason)` to settle the promise.

```js run
const ready = new Promise((resolve) => {
  console.log("executor runs now");
  resolve("ok");
  console.log("still inside the executor");
});

ready.then((value) => console.log("value:", value));
console.log("after then");
```

The executor's two logs run before `then` is even called, so the first two lines are synchronous. The callback passed to `then` runs later, after the current script has finished, which is why `"after then"` comes before `"value:"`. A promise's callbacks are always asynchronous, even when the promise is already settled. You'll see exactly why in lesson 11.

> **Pitfall:** Calling `resolve` or `reject` doesn't stop the executor. Any code after the call still runs, and a `throw` after `resolve` is silently ignored, because the promise is already settled. Return right after you settle, when the code after that point should not run.

## Chaining: each `then` returns a new promise

`then`, `catch` and `finally` each return a new promise. Whatever your callback returns becomes the value of that new promise. If you return another promise, the chain waits for it and then adopts its result, which is called flattening. That's how a sequence of asynchronous steps becomes a flat chain instead of a pyramid.

```js run
const doubledPlusOne = Promise.resolve(10)
  .then((n) => n * 2)
  .then((n) => n + 1);

doubledPlusOne.then((value) => console.log("chain result:", value));
console.log("chain started");
```

Each `then` receives the value from the step before it. The final value is available only at the end of the chain. The script prints `"chain started"` first, because every step runs asynchronously.

> **Pitfall:** A callback with braces and no `return` returns `undefined`, and the next step receives `undefined`. This is the single most common promise bug. An arrow function with an expression body returns automatically, so the braces are where the bug hides.

## Errors travel down the chain

A rejection skips every `then` callback until it reaches a handler for rejections, either a `catch` or the second argument of `then`. A handler that returns normally turns the chain back into fulfilled, so later steps run again.

```js run
const steps = [];
Promise.reject(new Error("disk full"))
  .then(() => steps.push("skipped"))
  .catch((err) => steps.push("caught: " + err.message))
  .then(() => console.log(steps.join(", ")));
```

The `then` in the middle is skipped entirely, because the chain is rejected. The `catch` handles the error, pushes a message, and returns `undefined`, which fulfills the chain again. So the final `then` runs normally. That's the intended design: a `catch` recovers. If you want to report and continue failing, throw again inside the handler.

> **Pitfall:** `then(onSuccess, onFailure)` and `then(onSuccess).catch(onFailure)` are not the same. In the first form, `onFailure` handles only errors from the earlier promise, not errors thrown by `onSuccess`. In the second, the `catch` also handles errors from `onSuccess`.

## Two ticks for a returned promise

Returning a promise from `then` costs more than returning a plain value, because the chain has to wait for the inner promise and then copy its result. You can see the difference in ordering with two chains that start at the same time.

```js run
Promise.resolve(1)
  .then((n) => Promise.resolve(n + 1))
  .then((n) => console.log("flattened:", n));

Promise.reject(new Error("x")).then(null, (err) => console.log("handled by second arg:", err.message));
```

Both chains start immediately. The second one handles its rejection in its first callback, while the first chain needs more steps to adopt the inner promise. So the second message prints first, even though it was written second. The exact order is decided by the rules of the microtask queue, which lesson 11 explains.

## `finally` passes the value through

`finally` runs whether the promise fulfilled or rejected, and it takes no value. Its callback can't change the result. Whatever came in goes out, so `finally` is for cleanup like hiding a spinner, not for transforming data.

```js run
Promise.resolve("data")
  .finally(() => console.log("finally runs, value is ignored"))
  .then((value) => console.log("still have:", value));
```

The `finally` callback runs first and its return value is discarded. The `then` after it still receives `"data"`, because `finally` returns the original value.

## Challenge: a delay you can await

Write a function that returns a promise which resolves to a value after a short delay. It's the building block for almost every timing demo in the rest of the course.

```js exercise id=delay-value title="A delay that resolves"
function delay(ms, value) {
  // TODO: return a promise that resolves to `value` after `ms` milliseconds.
  return null;
}
--- solution
function delay(ms, value) {
  return new Promise((resolve) => {
    setTimeout(() => resolve(value), ms);
  });
}
--- test
const pending = delay(10, "hi");
assert(pending instanceof Promise, "delay should return a Promise");
assertEqual(await pending, "hi", "The promise should resolve to the given value");
assertEqual(await delay(5), undefined, "With no value, it should resolve to undefined");
--- hint
Create a `new Promise`. Inside its executor, call `setTimeout` with a callback that calls `resolve` with the value.
--- hint
`setTimeout(() => resolve(value), ms)` runs the resolve after the delay. Return the promise from the function, and don't call `resolve` synchronously.
```

## Challenge: wrap an error with context

A function that loads a profile receives a fetcher, which returns a promise of a user. Return the upper-cased name on success. On failure, reject with a new `Error` whose message says what failed and keeps the original message. Use a promise chain, not `async`/`await`, since that's the point of this lesson.

```js exercise id=profile-errors title="Add context to a failure"
function loadProfile(fetcher) {
  // TODO: call fetcher(). On success, resolve to user.name in upper case.
  // On failure, reject with new Error("profile failed: " + original message).
  return null;
}
--- solution
function loadProfile(fetcher) {
  return fetcher()
    .then((user) => user.name.toUpperCase())
    .catch((err) => {
      throw new Error("profile failed: " + err.message);
    });
}
--- test
assertEqual(await loadProfile(() => Promise.resolve({ name: "ada" })), "ADA", "A successful load should return the upper-cased name");
let message = null;
try {
  await loadProfile(() => Promise.reject(new Error("boom")));
} catch (err) {
  message = err.message;
}
assertEqual(message, "profile failed: boom", "A failed fetch should reject with added context");
--- hint
`fetcher()` returns a promise. You can chain `.then` for the success case and `.catch` for the failure case.
--- hint
In the `catch`, throw a new `Error` that includes `err.message`. Throwing inside a `catch` rejects the chain, so the caller sees the new error.
```

## Debug: the chain that forgot to return

This chain should report the square of a number. It reports `undefined` instead. The bug is one missing word, and the symptom only appears in the final result, several steps away from the cause.

```js debug id=missing-return title="Fix the missing return"
function squareThenLabel(n) {
  return Promise.resolve(n)
    .then((value) => {
      value * value;
    })
    .then((squared) => "square is " + squared);
}
--- solution
function squareThenLabel(n) {
  return Promise.resolve(n)
    .then((value) => {
      return value * value;
    })
    .then((squared) => "square is " + squared);
}
--- test
assertEqual(await squareThenLabel(3), "square is 9", "squareThenLabel(3) should be 'square is 9'");
assertEqual(await squareThenLabel(7), "square is 49", "The square should follow the input, not a fixed value");
--- hint
Run it and read the final value. Then trace where the number goes: does the first `then` pass anything to the second one?
--- hint
A block-bodied arrow function only returns what you write with `return`. Return `value * value` from the first callback.
```

## Predict: callbacks in order

Synchronous code, `then` callbacks and the executor all interleave in a specific way. Trace the order carefully, and remember that each `then` callback is queued when its promise is already settled.

```js predict id=predict-promise-order title="Predict the promise order"
const log = [];
Promise.resolve("a").then((v) => log.push(v));
log.push("b");
new Promise((resolve) => {
  log.push("c");
  resolve("d");
}).then((v) => log.push(v));
log.push("e");
setTimeout(() => console.log(log.join(" ")), 0);
--- options
* b c e a d
a b c e d
b c e d a
c b e a d
--- explain
Everything before the first `then` callback runs synchronously: `"b"` is pushed, then the executor pushes `"c"`, and `"e"` is pushed. The two `then` callbacks run afterward, as microtasks, in the order they were queued. `Promise.resolve("a")` was already settled when its `then` was called, so `"a"` is queued first. The second promise is settled inside its executor, so `"d"` is queued second. The `setTimeout` callback runs last of all, so it prints the complete log.
```

## Recap

- A promise is pending until it settles, once, as fulfilled with a value or rejected with a reason. The executor runs synchronously, and `then` callbacks always run asynchronously.
- `then`, `catch` and `finally` return new promises. A returned value becomes the next value, and a returned promise is flattened into it.
- Rejections skip `then` callbacks until a `catch` or a rejection handler recovers. A recovered chain continues normally.
- A block-bodied callback returns `undefined` unless you write `return`. That silent `undefined` is the most common promise bug.
- `finally` runs cleanup and passes the original value or error through unchanged.

**Up next:** `async` and `await`, which let you write promise chains as if they were ordinary sequential code, along with the error handling and the missing-`await` traps that come with them.
