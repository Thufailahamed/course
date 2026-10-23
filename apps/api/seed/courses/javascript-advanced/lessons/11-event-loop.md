A JavaScript engine runs one thing at a time. There are no threads running your code in parallel, and yet a page can animate, fetch data and respond to a click at the same moment. The mechanism that makes this work is the event loop: a simple cycle that picks the next piece of work, runs it to completion, and then picks the next. Once you know the cycle, the orderings you've been predicting all course stop looking arbitrary. A promise callback runs before a zero-millisecond timer. A timer callback can run a chain of promise callbacks before the next timer. A long synchronous loop freezes everything.

This lesson gives you the model in precise terms: the call stack, two queues with different priorities, and the rule that drains one of them completely before the other gets a turn. Then you'll apply it to predictions that are hard to get right by intuition.

## The loop, in three parts

The engine has a **call stack**, which runs the code you wrote. Timers, network responses and user events are handled by the host environment, which queues a callback when they're ready. The engine keeps two queues of callbacks.

- The **task queue**, also called the macrotask queue, holds timer callbacks, I/O, event handlers and the initial script.
- The **microtask queue** holds promise reactions (the callbacks passed to `then`, `catch` and `finally`), the continuations of `await`, and anything passed to `queueMicrotask`.

The loop runs like this. Take one task from the task queue and run it to completion on the call stack. When the stack is empty, drain the microtask queue completely, including any microtasks queued while draining. Then take the next task. Browsers may render a frame between tasks, which is why a long task makes the page feel stuck.

```js run
const order = [];
setTimeout(() => order.push("timer 1"), 0);
Promise.resolve().then(() => {
  order.push("micro 1");
  Promise.resolve().then(() => order.push("micro 2, queued by micro 1"));
});
setTimeout(() => console.log(order.join(" | ")), 10);
```

The timer was scheduled first, but both microtasks run before `timer 1`. `micro 2` was queued while `micro 1` was running, and the drain keeps going until the microtask queue is empty, so it runs in the same drain. Only then does the loop take the next task, the timer.

> **Under the hood:** The microtask drain is not a single step. The engine repeats it until the microtask queue is empty, and any new microtasks join the same drain. That's why a chain of promise callbacks can finish before a timer that was scheduled long before it.

## A timer callback is a task

Each timer callback is its own task. Between two timers, the engine drains the microtask queue, so promise work that a timer started finishes before the next timer begins. This is what makes a timer-driven sequence predictable.

```js run
const seq = [];
setTimeout(() => {
  seq.push("timer A");
  Promise.resolve().then(() => seq.push("micro after A"));
}, 0);
setTimeout(() => {
  seq.push("timer B");
  console.log(seq.join(", "));
}, 0);
```

`micro after A` is queued while `timer A` runs, so it runs before the loop takes `timer B`. If the microtask had been scheduled as another timer, `timer B` would have won. The distinction between the two queues is the whole point.

> **Pitfall:** Because the microtask queue is drained completely, a microtask that keeps queuing another microtask never gives timers or rendering a turn. A recursive `then` loop or an `await` inside a tight loop with no real waiting can freeze a page just as surely as a synchronous `while` loop. Put a timer or a real I/O wait in the loop when you need the rest of the program to keep running.

## Microtasks cannot be overtaken

Every microtask queued before the drain starts runs before any of the microtasks queued during the drain, in the order they were queued. Each callback is a queue entry, and entries run in FIFO order. Use this rule and you can predict chains that look tangled.

```js run
const trace = [];
async function worker() {
  trace.push("worker start");
  await null;
  trace.push("worker after await");
}
worker();
trace.push("script end");
Promise.resolve().then(() => console.log(trace.join(" -> ")));
```

The `await` in `worker` queued its continuation during the synchronous call. The final `then` was queued after that. The microtask queue is FIFO, so the continuation runs first, and the logging callback prints the complete trace last.

## Timers with different delays

Timers are sorted by the time they're due, not by the order they were created. Timers with the same delay run in creation order. A zero delay is not "now": it's the smallest delay the host allows, and it still waits behind any microtasks and any timer that is already due.

```js run
const timeline = [];
setTimeout(() => timeline.push("50 ms"), 50);
setTimeout(() => timeline.push("0 ms"), 0);
setTimeout(() => timeline.push("0 ms again"), 0);
setTimeout(() => console.log(timeline.join(", ")), 80);
```

The two zero-delay timers run first in creation order, and the 50 ms timer comes after them. The final timer is scheduled for 80 ms, which leaves a safe margin after the 50 ms one. Don't rely on timers to fire at exact times: they fire at or after their delay, and the exact moment depends on what else is running.

> **In the wild:** Node adds two more queues, `process.nextTick` and `setImmediate`, which have their own priority rules. They're Node-specific, so the course doesn't use them, but you'll see them in server code. Browsers don't have them. Browser code uses `queueMicrotask` and `setTimeout`, and the rules here apply to both.

## Challenge: run a callback before the timers

`queueMicrotask` runs a callback after the current synchronous code and before any timer. Write a helper that uses a promise to schedule a function that way, and returns a promise for its result.

```js exercise id=run-soon title="Run before the timers"
function runSoon(fn) {
  // TODO: schedule fn to run as a microtask. Return a promise that resolves to fn's result.
  return null;
}
--- solution
function runSoon(fn) {
  return Promise.resolve().then(fn);
}
--- test
const log = [];
const pending = runSoon(() => {
  log.push("soon");
  return 5;
});
log.push("now");
assertEqual(await pending, 5, "runSoon should resolve to fn's return value");
assertEqual(log, ["now", "soon"], "fn must run after the current synchronous code");
assertEqual(await runSoon(() => "x"), "x", "A second call should work the same way");
--- hint
A promise's `then` callback is a microtask. You can start a chain from `Promise.resolve()` and pass `fn` to its `then`.
--- hint
`return Promise.resolve().then(fn);` queues `fn` and hands back a promise for its result.
```

## Challenge: one callback per macrotask

Write an async function that runs each function in an array in its own timer tick, one after another, and collects the results. Each function must run after the current microtasks have been processed.

```js exercise id=one-task-per-tick title="One task per tick"
async function runPerTick(fns) {
  // TODO: for each fn, wait for one timer tick (setTimeout 0), then call it and keep its result.
  // Return the results in order.
  return null;
}
--- solution
async function runPerTick(fns) {
  const results = [];
  for (const fn of fns) {
    await new Promise((resolve) => setTimeout(resolve, 0));
    results.push(fn());
  }
  return results;
}
--- test
const log = [];
const pending = runPerTick([() => { log.push("a"); return "A"; }, () => { log.push("b"); return "B"; }]);
Promise.resolve().then(() => log.push("micro"));
assertEqual(await pending, ["A", "B"], "runPerTick should return each result in order");
assertEqual(log, ["micro", "a", "b"], "The microtask must run before the first timer-based call");
assertEqual(await runPerTick([]), [], "An empty list should give an empty array");
--- hint
Each step needs to wait for a timer. `await new Promise((resolve) => setTimeout(resolve, 0));` gives you one tick.
--- hint
Loop over `fns` with `for...of`. Await a fresh timer promise before each call, then push the call's result into an array.
```

## Debug: the total that returns too early

This function should return the sum of a list, but it returns `0`. It starts a promise callback that sets `total` and returns before that callback runs. Fix it so the function waits for the value.

```js debug id=total-returns-early title="Wait for the value"
async function loadTotal(values) {
  let total = 0;
  Promise.resolve(values).then((list) => {
    total = list.reduce((sum, n) => sum + n, 0);
  });
  return total;
}
--- solution
async function loadTotal(values) {
  const list = await Promise.resolve(values);
  return list.reduce((sum, n) => sum + n, 0);
}
--- test
assertEqual(await loadTotal([1, 2, 3]), 6, "loadTotal([1, 2, 3]) should be 6");
assertEqual(await loadTotal([10]), 10, "The total should come from the input, not a fixed value");
assertEqual(await loadTotal([]), 0, "An empty list should total 0");
--- hint
Run it and check the result. Ask whether the `return` happens before or after the `then` callback runs.
--- hint
Await the promise instead of attaching a callback to it. The value is then available as a normal variable before the function returns.
```

## Predict: timers, microtasks and a nested timer

A timer callback can start new microtasks, and those microtasks finish before the next timer runs. Track the order carefully.

```js predict id=predict-timer-micro title="Predict the timer and microtask order"
const out = [];
setTimeout(() => {
  out.push("timer 1");
  Promise.resolve().then(() => out.push("micro in timer 1"));
}, 0);
setTimeout(() => {
  out.push("timer 2");
  console.log(out.join(" "));
}, 0);
Promise.resolve().then(() => out.push("micro"));
out.push("sync");
--- options
* sync micro timer 1 micro in timer 1 timer 2
sync micro timer 1 timer 2 micro in timer 1
sync timer 1 micro timer 2 micro in timer 1
micro sync timer 1 micro in timer 1 timer 2
--- explain
The synchronous script pushes `"sync"` first. The promise callback then runs as a microtask, so `"micro"` comes next. The loop takes the first timer, which logs `"timer 1"` and queues a new microtask. Before the next task starts, the microtask queue is drained, so `"micro in timer 1"` runs. Only then does the second timer run. A microtask created inside a timer finishes before the next timer, which is the rule that surprises most people.
```

## Predict: a microtask that queues another

Promise callbacks can start more promise callbacks. The new ones don't jump the line; they wait their turn behind the callbacks that were already queued.

```js predict id=predict-nested-micro title="Predict the nested microtasks"
const out = [];
Promise.resolve().then(() => {
  out.push("A");
  Promise.resolve().then(() => out.push("C"));
}).then(() => out.push("B"));
Promise.resolve().then(() => out.push("D"));
setTimeout(() => console.log(out.join(" ")), 0);
--- options
* A D C B
A C B D
A B C D
D A B C
--- explain
The script queues two microtasks: the first callback that pushes `"A"`, and the callback that pushes `"D"`. When `"A"`'s callback runs, it queues a new microtask for `"C"`, which lands behind `"D"`. The `then` that pushes `"B"` is waiting for the first callback to return, and it's queued only after that callback finishes, so it's behind `"C"`. The order is A, D, C, B. The option `A C B D` assumes the new microtask jumps ahead of the queue, which it doesn't.
```

## Recap

- The event loop runs one task at a time. After each task, the whole microtask queue is drained, including microtasks queued during the drain, before the next task.
- Promise callbacks and `await` continuations are microtasks. Timer callbacks are tasks.
- A microtask queued inside a timer finishes before the next timer runs. A microtask that keeps queuing microtasks can starve timers and rendering.
- Timers run in order of their due time, and zero delay still waits behind everything already queued.
- When an output depends on the order of asynchronous work, trace the synchronous code first, then the microtask queue, then the timers.

**Up next:** concurrency patterns, where you'll combine promises with `Promise.all`, `allSettled`, `race` and `any` to run independent work at once, and limit how much of it runs in parallel.
