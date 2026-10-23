Promise chains are correct, but they make you think in callbacks. Every step lives in its own function, loops become recursion or `reduce`, and an error has to be threaded through `catch` at the right point. `async` and `await` keep the same promises underneath and let you write the code in order. A line that says `const user = await loadUser(id)` reads like sequential code, pauses the function until the value arrives, and then continues with a plain variable.

The convenience hides a few details you need to know. An `async` function always returns a promise, even when it returns a plain value. `await` pauses only the function it's in, not the whole program. A forgotten `await` silently gives you a promise where you expected a value. And an `await` inside a loop makes the work sequential, which may be far slower than you intended. This lesson covers those rules, along with the error handling patterns that actually work.

## An async function returns a promise

Marking a function `async` does two things. It makes `await` legal inside the body, and it wraps the function's return value in a promise. A value returned from an async function is delivered to the caller through that promise, and a thrown error becomes a rejection.

```js run
async function fetchScore(name) {
  return name.length * 10;
}

async function main() {
  const score = await fetchScore("Ada");
  console.log("score:", score);
}

main();
console.log("main started");
```

`main()` runs synchronously until its first `await`, and then it returns a promise. That's why `"main started"` prints before `"score:"`. The rest of `main` resumes later, once the awaited promise has settled. Calling an async function never blocks the caller.

> **Under the hood:** `await` splits the function in two. The code before the `await` runs now. The code after it becomes a continuation, which is queued as a microtask when the awaited promise settles. The engine keeps the function's local variables alive between the two halves, which is why `score` survives the pause.

## Sequential and concurrent are different programs

`await` waits for one thing at a time. Two awaits in a row run one after the other, which is what you want when the second request depends on the first. It's a mistake when the two requests are independent, because you pay for both delays in series.

```js run
const later = (ms, label) => new Promise((resolve) => setTimeout(() => resolve(label), ms));

async function sequentialTotal() {
  const start = Date.now();
  await later(30, "A");
  await later(30, "B");
  return Date.now() - start >= 50 ? "took at least 50 ms" : "too fast";
}

sequentialTotal().then(console.log);
```

Two 30 ms waits in a row can't finish in less than 60 ms, so the check passes. The code doesn't print a measured time, which would differ on every run. If the two waits were independent, you could start both before awaiting either, and you'd pay for only the slower one. You'll learn to do that properly with `Promise.all` in lesson 12.

> **Pitfall:** An `await` inside a `for` loop serializes the loop. Each iteration waits for the previous one, even when the iterations have nothing to do with each other. Sequential is right for dependent steps, and wrong for a batch of independent requests.

> **In the wild:** A dashboard that loads users, orders and metrics should start all three requests before it awaits any of them. Three sequential awaits turn a 300 ms page load into nearly a second, and nobody notices until the page is in production.

## Error handling uses try and catch

A rejected promise throws at the `await` that waits for it, so `try`/`catch` works exactly as it does for synchronous code. That's the main advantage of `await` over chained `.catch`: the error handling sits next to the code that can fail.

```js run
async function risky(flag) {
  if (flag) {
    throw new Error("network down");
  }
  return "fine";
}

async function attempt(flag) {
  try {
    return await risky(flag);
  } catch (err) {
    return "recovered from " + err.message;
  }
}

attempt(true).then(console.log);
attempt(false).then(console.log);
```

Both calls succeed as functions. The first `catch` handles the rejection, and the second returns the value normally.

> **Pitfall:** `return risky(flag)` without `await` inside a `try` doesn't catch anything. The function returns the promise, the `try` block exits immediately, and the rejection goes to whoever calls `attempt`. Here's the proof:

```js run
async function leaky() {
  try {
    return risky(true);
  } catch (err) {
    return "caught";
  }
}

leaky().catch((err) => console.log("escaped:", err.message));
```

The `try` finished before the rejection happened, so `catch` never ran. Always write `return await` when you want the local `catch` to see the error.

## A missing `await` returns a promise

Forgetting `await` is the most common async bug, and it doesn't throw. The expression evaluates to a promise, and a promise is always truthy, so a check on it always passes.

```js run
async function isOpen() {
  return false;
}

async function enter() {
  if (isOpen()) {
    return "walk in";
  }
  return "closed";
}

enter().then(console.log);
```

`isOpen()` returns a promise, which is truthy, so `enter` says `"walk in"` even though the door is closed. The fix is `await isOpen()`. You'll practice exactly that bug in the debug challenge below.

## `forEach` doesn't wait for async callbacks

`forEach` calls its callback and ignores what it returns. An `async` callback returns a promise, which `forEach` discards, so nothing waits for the work inside it.

```js run
async function saveAll(items) {
  const saved = [];
  items.forEach(async (item) => {
    await null;
    saved.push(item);
  });
  return saved.length;
}

saveAll(["a", "b"]).then((n) => console.log("saved count right away:", n));
```

The function returns before any of the callbacks has resumed, so the count is `0`. Use `for...of` with `await` for sequential work, or `Promise.all` with `map` for concurrent work. Both let the function wait for every item.

## Challenge: retry until it works

Write an async function that calls `fn` up to `attempts` times. It returns the first successful result. If every attempt fails, it throws the error from the last one. Remember that a rejected `await` must be caught inside the loop to try again.

```js exercise id=retry-until-success title="Retry an async call"
async function retry(fn, attempts) {
  // TODO: call fn() up to `attempts` times. Return the first result that succeeds.
  // If all attempts fail, throw the error from the last attempt.
  return null;
}
--- solution
async function retry(fn, attempts) {
  let lastError;
  for (let i = 0; i < attempts; i++) {
    try {
      return await fn();
    } catch (err) {
      lastError = err;
    }
  }
  throw lastError;
}
--- test
let calls = 0;
const flaky = async () => {
  calls += 1;
  if (calls < 3) {
    throw new Error("try " + calls);
  }
  return "ok on " + calls;
};
assertEqual(await retry(flaky, 5), "ok on 3", "retry should return the first successful result");
assertEqual(calls, 3, "retry should stop calling fn once it succeeds");

let count = 0;
const broken = async () => {
  count += 1;
  throw new Error("fail " + count);
};
let message = null;
try {
  await retry(broken, 2);
} catch (err) {
  message = err.message;
}
assertEqual(message, "fail 2", "When every attempt fails, the last error should be thrown");
assertEqual(count, 2, "retry should make exactly the allowed number of attempts");
--- hint
Use a `for` loop that runs `attempts` times. Inside it, `try` to `await fn()` and return the result. Keep the caught error in a variable outside the loop.
--- hint
`return await fn();` inside `try` makes the rejection land in your `catch`. After the loop, `throw lastError;` gives the caller the final failure.
```

## Challenge: run tasks one after another

Write an async function that runs an array of task functions in order, waits for each to finish before starting the next, and returns their results in the same order. Each task returns a promise.

```js exercise id=run-in-order title="Run tasks in order"
async function runInOrder(tasks) {
  // TODO: run each task in turn, waiting for it to finish before starting the next.
  // Return an array of the results, in the same order as the tasks.
  return null;
}
--- solution
async function runInOrder(tasks) {
  const results = [];
  for (const task of tasks) {
    results.push(await task());
  }
  return results;
}
--- test
const seen = [];
const slow = () =>
  new Promise((resolve) => {
    setTimeout(() => {
      seen.push("slow");
      resolve("one");
    }, 30);
  });
const fast = () =>
  new Promise((resolve) => {
    setTimeout(() => {
      seen.push("fast");
      resolve("two");
    }, 5);
  });
assertEqual(await runInOrder([slow, fast]), ["one", "two"], "Results should come back in task order");
assertEqual(seen, ["slow", "fast"], "Tasks must finish one at a time, so the slow one finishes first");
assertEqual(await runInOrder([]), [], "An empty list should give an empty array");
--- hint
Loop over `tasks` with `for...of`. Inside the loop, `await task()` and push its result into an array.
--- hint
Each iteration should wait for the previous task to finish. Don't call `tasks.map(...)` here, because `map` starts every task right away.
```

## Debug: the check that always passes

This function should deny deletion unless the user is an admin. It allows every user, because `isAllowed` returns a promise and the `if` treats any promise as true. Fix it so the check waits for the answer.

```js debug id=missing-await-check title="Await the permission check"
async function isAllowed(user) {
  return user.role === "admin";
}
async function deleteRecord(user, id) {
  if (isAllowed(user)) {
    return "deleted " + id;
  }
  return "denied";
}
--- solution
async function isAllowed(user) {
  return user.role === "admin";
}
async function deleteRecord(user, id) {
  if (await isAllowed(user)) {
    return "deleted " + id;
  }
  return "denied";
}
--- test
assertEqual(await deleteRecord({ role: "admin" }, 7), "deleted 7", "Admins should be allowed to delete");
assertEqual(await deleteRecord({ role: "guest" }, 7), "denied", "Non-admins must be denied");
--- hint
Run it with a guest user and look at the result. Then ask what `isAllowed(user)` returns, and whether an `if` can tell a promise from a value.
--- hint
Put `await` in front of the call to `isAllowed` inside the `if`. Then the condition sees the boolean.
```

## Predict: where the continuation runs

Each `step` runs until its `await`, then yields. Work out which lines run synchronously and which resume afterward.

```js predict id=predict-await-order title="Predict the await order"
const log = [];
async function step(name) {
  log.push(name + " start");
  await null;
  log.push(name + " resumed");
}
step("A");
step("B");
log.push("main");
setTimeout(() => console.log(log.join(", ")), 0);
--- options
* A start, B start, main, A resumed, B resumed
A start, A resumed, B start, B resumed, main
main, A start, B start, A resumed, B resumed
A start, B start, A resumed, B resumed, main
--- explain
Calling `step("A")` runs its body until `await null`, logging `"A start"`, and then returns a promise. The same happens for `"B"`. Back in the main script, `"main"` is logged. Only then do the continuations run as microtasks, in the order the awaits were reached, so `"A resumed"` and then `"B resumed"`. The `setTimeout` callback comes last, so the whole log is printed in one line.
```

## Recap

- An `async` function always returns a promise. Its return value resolves that promise, and a thrown error rejects it.
- `await` pauses the enclosing function until the promise settles. The code before it runs synchronously when the function is called.
- Sequential `await`s run one after another. Use `Promise.all` (lesson 12) when the work is independent.
- Put `await` before `return` inside a `try` block to catch the rejection locally.
- A missing `await` leaves you holding a promise, which is always truthy. `forEach` never waits for an async callback, so use `for...of` for sequential work.

**Up next:** the event loop, which decides the exact order in which microtasks, timers and rendering run, and explains everything you've seen in the predictions so far.
