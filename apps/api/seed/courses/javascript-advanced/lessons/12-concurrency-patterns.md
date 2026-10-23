A dashboard that loads a user, their orders and their notifications has three independent requests. An upload tool that sends two hundred files has a different problem: start them all and the browser or server gives up, start them one at a time and the upload takes all afternoon. Both problems come up in real code daily, and promises give you the building blocks, but the right combinator depends on what you need when some of the work fails.

This lesson covers the four combinators, what each one promises when things go wrong, and the pattern that ties them together: a worker pool that caps how much runs at once. You'll see the usual traps, including `allSettled` results that look like values, timeouts that don't cancel their work, and a limit that quietly isn't a limit.

## Promise.all: all or nothing

`Promise.all` takes an array of promises and returns one promise. It fulfills with an array of every result, in the same order as the input, once all of them have fulfilled. If any input rejects, the combined promise rejects immediately with that reason, and the other results are discarded.

```js run
const ok = (ms, value) => new Promise((resolve) => setTimeout(() => resolve(value), ms));
const bad = (ms, message) => new Promise((_, reject) => setTimeout(() => reject(new Error(message)), ms));

Promise.all([ok(10, "a"), ok(5, "b"), ok(1, "c")]).then((values) => console.log(values.join(",")));
Promise.all([ok(5, "p"), bad(40, "late")]).catch((err) => console.log("all rejected:", err.message));
```

The first call returns `a,b,c` in input order, even though `c` finished first. The second rejects as soon as `bad` fails, which is 40 ms later. It doesn't wait for anything else, so `"all rejected: late"` prints at that point. Use `Promise.all` when every result is required, and a single failure means the whole operation is wrong.

> **Pitfall:** `Promise.all` rejects on the first failure, but it doesn't cancel the other promises. The requests keep running and their results are simply ignored. If a side effect matters, such as a write to a database, you need your own cancellation.

## Promise.allSettled: every outcome, no rejection

`allSettled` waits for everything and never rejects. Each entry in the result array is an object: `{ status: "fulfilled", value }` or `{ status: "rejected", reason }`. Use it when you want a report on each item, such as a batch import that should keep going after one bad row.

```js run
Promise.allSettled([ok(20, "x"), bad(5, "boom")]).then((results) => {
  console.log(results.map((r) => r.status).join(" "));
});
```

The rejection at 5 ms doesn't end the operation, and the result array arrives after the slower promise at 20 ms. The entries are objects with different fields for each status, which is the trap: reading `.value` from a rejected entry gives `undefined`, not an error. Check `status` before you use the other field.

## Promise.race: the first to settle wins

`race` settles with whichever input settles first, whether it fulfills or rejects. Its most common use is a timeout, where the work races against a timer that rejects.

```js run
Promise.race([ok(30, "slow"), ok(5, "quick")]).then((winner) => console.log("winner:", winner));
```

The 5 ms promise settles first, so `race` takes its value. The 30 ms promise still runs to completion, and its result is ignored. A race doesn't cancel the losers either, so a timed-out request may still finish in the background.

## Promise.any: the first success

`any` fulfills with the first input that fulfills, and it ignores rejections until every input has failed. If all of them reject, it rejects with an `AggregateError` whose `errors` array holds each reason. Use it when you have several equivalent sources, such as mirrors of the same file, and any one of them is good enough.

```js run
Promise.any([bad(5, "x"), bad(10, "y")]).catch((err) => {
  console.log(err.name, err.errors.map((e) => e.message).join("+"));
});
Promise.any([bad(5, "one"), ok(15, "two"), ok(30, "three")]).then((value) => console.log("first success:", value));
```

Both rejected inputs fail before any success, so the `AggregateError` comes first, at 10 ms. The 15 ms input is the first success, so `any` fulfills with `two` after that. The `three` input is still running and is ignored.

> **In the wild:** `Promise.any` is the usual tool for fetching from several CDN mirrors or fallback endpoints. The first healthy response wins, and the error only surfaces when every mirror is down.

## Limit the concurrency

Starting everything at once is the wrong default when there are many tasks. Each one holds memory, a socket or a file handle, and the other side may throttle you. The standard pattern is a pool of workers that all pull from one shared queue. Each worker takes the next item, awaits it, and repeats, so no more than `limit` tasks are ever in flight.

```js run
const meter = { now: 0, peak: 0 };
async function measured(n) {
  meter.now += 1;
  meter.peak = Math.max(meter.peak, meter.now);
  await ok(10, null);
  meter.now -= 1;
  return n * n;
}

Promise.all([1, 2, 3, 4, 5].map(measured)).then((squares) => {
  console.log(squares.join(" "), "peak:", meter.peak);
});
```

Mapping over the array with `Promise.all` starts all five tasks immediately, so the peak is five. That's the problem a limit solves. The next challenge asks you to build the limited version, and you'll be able to see the peak drop.

> **Pitfall:** A `forEach` or `map` with `async` callbacks starts everything at once. Wrapping the same code in a `for` loop with `await` runs it strictly one at a time. A pool sits between those extremes: a fixed number of workers, each sequential, running in parallel with one another.

## Challenge: summarize every outcome

Given an array of promises, return a list of strings in the same order. A fulfilled promise becomes `"ok:<value>"`, and a rejected one becomes `"err:<message>"`. The function must never reject, even when some inputs do.

```js exercise id=describe-all title="Describe every outcome"
async function describeAll(promises) {
  // TODO: wait for all of them to settle and return one string per input, in order.
  // "ok:<value>" for a fulfilled input, "err:<message>" for a rejected one.
  return null;
}
--- solution
async function describeAll(promises) {
  const settled = await Promise.allSettled(promises);
  return settled.map((r) =>
    r.status === "fulfilled" ? "ok:" + r.value : "err:" + r.reason.message
  );
}
--- test
const failing = Promise.reject(new Error("no"));
failing.catch(() => {});
const later = new Promise((resolve) => setTimeout(() => resolve(3), 5));
const result = await describeAll([Promise.resolve(1), failing, later]);
assertEqual(result, ["ok:1", "err:no", "ok:3"], "Each outcome should be described in input order");
assertEqual(await describeAll([]), [], "An empty input should give an empty list");
--- hint
`Promise.allSettled` gives you an array of `{ status, ... }` objects. Map over that array.
--- hint
Check `status` first. Fulfilled entries carry `value`, and rejected entries carry `reason`, which is an `Error` with a `message`.
```

## Challenge: a timeout that names its failure

Write `withTimeout(promise, ms)`. It returns a promise that follows `promise` if it settles within `ms` milliseconds. Otherwise it rejects with an `Error` whose message is `"timed out after " + ms + " ms"`.

```js exercise id=with-timeout title="Add a timeout"
function withTimeout(promise, ms) {
  // TODO: race `promise` against a timer. If the timer wins, reject with
  // new Error("timed out after " + ms + " ms").
  return null;
}
--- solution
function withTimeout(promise, ms) {
  let timerId;
  const timer = new Promise((_, reject) => {
    timerId = setTimeout(() => reject(new Error("timed out after " + ms + " ms")), ms);
  });
  return Promise.race([promise, timer]).finally(() => clearTimeout(timerId));
}
--- test
const quick = withTimeout(new Promise((resolve) => setTimeout(() => resolve("done"), 5)), 50);
assertEqual(await quick, "done", "A promise that finishes in time should pass its value through");
let message = null;
try {
  await withTimeout(new Promise((resolve) => setTimeout(() => resolve("late"), 60)), 10);
} catch (err) {
  message = err.message;
}
assertEqual(message, "timed out after 10 ms", "A slow promise should reject with the timeout message");
--- hint
`Promise.race` settles with whichever input settles first. Build a second promise that rejects after `ms` milliseconds.
--- hint
Create a timer promise with `new Promise((_, reject) => setTimeout(...))` and race it against the input. Put the exact message in the `Error`.
```

## Challenge: a worker pool

Write `mapLimit(items, limit, fn)`. It calls `fn` on each item and returns the results in input order, but never has more than `limit` calls in flight. If any call rejects, the returned promise rejects.

```js exercise id=map-with-limit title="Map with a concurrency limit"
async function mapLimit(items, limit, fn) {
  // TODO: run fn on every item, with at most `limit` calls running at once.
  // Return the results in input order. Reject if any call rejects.
  return null;
}
--- solution
async function mapLimit(items, limit, fn) {
  const results = new Array(items.length);
  let next = 0;
  async function worker() {
    while (next < items.length) {
      const index = next;
      next += 1;
      results[index] = await fn(items[index]);
    }
  }
  const workers = Array.from({ length: Math.min(limit, items.length) }, () => worker());
  await Promise.all(workers);
  return results;
}
--- test
let running = 0;
let peak = 0;
const tracked = async (n) => {
  running += 1;
  peak = Math.max(peak, running);
  await new Promise((resolve) => setTimeout(resolve, 5));
  running -= 1;
  return n * 10;
};
assertEqual(await mapLimit([1, 2, 3, 4, 5], 2, tracked), [10, 20, 30, 40, 50], "Results should follow the input order");
assertEqual(peak, 2, "At most two calls may be in flight at once");
assertEqual(await mapLimit([], 3, tracked), [], "An empty input should give an empty array");
let failed = false;
try {
  await mapLimit([1, 2], 2, async (n) => {
    if (n === 2) throw new Error("bad item");
    return n;
  });
} catch (err) {
  failed = err.message === "bad item";
}
assert(failed, "A rejection from fn should reject the whole result");
--- hint
Start `limit` workers. Each worker repeatedly takes the next unclaimed index from a shared counter, awaits `fn` on that item, and stores the result.
--- hint
Claim an index by reading `next` and incrementing it before you `await`. Then `await Promise.all(workers)` and return `results`. A rejection inside a worker rejects `Promise.all`.
```

## Debug: adding up the survivors

This should add up only the numbers that succeeded. It returns `NaN`, because it adds the `value` of every entry, and a rejected entry has no `value`. Fix it so only the fulfilled entries count.

```js debug id=sum-successes title="Sum only the successes"
async function sumSuccessful(promises) {
  const results = await Promise.allSettled(promises);
  return results.reduce((total, r) => total + r.value, 0);
}
--- solution
async function sumSuccessful(promises) {
  const results = await Promise.allSettled(promises);
  return results
    .filter((r) => r.status === "fulfilled")
    .reduce((total, r) => total + r.value, 0);
}
--- test
const broken = Promise.reject(new Error("x"));
broken.catch(() => {});
const mixed = [Promise.resolve(2), broken, Promise.resolve(5)];
assertEqual(await sumSuccessful(mixed), 7, "Rejected entries should be left out of the sum");
assertEqual(await sumSuccessful([Promise.resolve(4)]), 4, "A single success should sum to itself");
--- hint
Run it and look at the total. Ask what `r.value` is for an entry whose status is `"rejected"`.
--- hint
Filter the settled results to those with `status === "fulfilled"` before you reduce them.
```

## Predict: which wins and what settles

Timers, a race and `allSettled` all interact here. Track when each promise settles, and remember that a race ignores everything after the first settlement.

```js predict id=predict-race-settle title="Predict the race and allSettled"
const out = [];
const slow = new Promise((resolve) => setTimeout(() => resolve("slow"), 20));
const fast = new Promise((resolve) => setTimeout(() => resolve("fast"), 5));
const broken = new Promise((_, reject) => setTimeout(() => reject(new Error("broke")), 10));
Promise.race([slow, fast, broken]).then((v) => out.push("race: " + v));
Promise.allSettled([slow, broken]).then((r) => out.push(r.map((x) => x.status).join(",")));
setTimeout(() => console.log(out.join(" | ")), 40);
--- options
* race: fast | fulfilled,rejected
race: fast | rejected,fulfilled
race: slow | fulfilled,rejected
race: broke | fulfilled,rejected
--- explain
`fast` settles at 5 ms, before anything else, so `race` fulfills with `"fast"`. The later rejection at 10 ms is ignored by the race, because it has already settled. `allSettled` waits for both `slow` and `broken`. The rejection at 10 ms is recorded first, and the fulfillment at 20 ms completes the set. The results array keeps input order, so it reads `fulfilled,rejected`, not the other way around. Both callbacks have run by the time the log prints at 40 ms.
```

## Recap

- `Promise.all` fulfills with every value in input order and rejects on the first failure. It doesn't cancel the others.
- `Promise.allSettled` never rejects. Check each entry's `status` before you read `value` or `reason`.
- `Promise.race` settles with the first settlement, which makes it the basis for timeouts, but the losing work keeps running.
- `Promise.any` fulfills with the first success, and rejects with an `AggregateError` only when everything fails.
- Limit concurrency with a pool of workers that share one queue. Starting everything with `map` plus `Promise.all` is not a limit.

**Up next:** immutability, where you'll learn to freeze, copy and update data safely, so that shared state, like the results your pool returns, can't change under the code that reads it.
