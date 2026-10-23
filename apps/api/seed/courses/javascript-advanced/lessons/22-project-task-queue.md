Real applications issue far more asynchronous work than they can afford to run at once. An image pipeline with a thousand thumbnails, a crawler, a batch import that calls a rate-limited API: each one needs a queue that starts work in order, runs a bounded number of tasks in parallel, keeps going after failures and reports results to whoever asked. Promises give you the pieces, but the coordination (who starts next, what happens when one fails, when the queue is really empty) is your code to write.

In this capstone you'll build a `TaskQueue` in four stages. Each stage adds one idea: running a task safely, limiting concurrency, collecting results when some tasks fail, and then assembling everything into one class with pause and idle support. Every stage has its own challenge, and the last one is an integrated test of the whole class. Read each stage's run cells before you start its challenge, because they show the behavior the tests check.

## Why not just `Promise.all`?

The first instinct is to start everything and wait for all of it. That works until the list is long. The cell below starts four jobs at once, and the peak number of in-flight jobs is the number of jobs:

```js run
let inFlight = 0;
let peak = 0;
const job = async (n) => {
  inFlight++;
  peak = Math.max(peak, inFlight);
  await null;
  inFlight--;
  return n;
};

const all = await Promise.all([1, 2, 3, 4].map(job));
console.log(all, "peak:", peak);
```

`Promise.all` has no limit. With a thousand tasks, you'd open a thousand connections or allocate a thousand buffers simultaneously. The queue's job is to cap that number, and to keep the rest waiting in order without anyone polling for free slots.

Two more facts shape the design. Promises settle asynchronously, so a task should never start in the middle of the `add` call that scheduled it. And a rejected task is a result, not a crash: the queue has to report it to its caller and keep going.

```js run
const order = [];
Promise.resolve().then(() => order.push("microtask"));
order.push("sync");
console.log(order);
```

The log shows only `sync`. The microtask runs after the current code finishes, which is why the queue can record a task as running before the task's own code begins.

## Stage 1: run a task safely

A task is a function that returns a value or a promise. Your first helper has two jobs. It must start the task asynchronously, and it must convert both a synchronous `throw` and a rejected promise into a rejection that the caller can handle. A `Promise.resolve().then(...)` gives you both, because an exception inside `then` becomes a rejection.

```js exercise id=run-task title="Run a task asynchronously and safely"
function runTask(task) {
  // TODO: return a promise for the task's result.
  // The task must not start synchronously. A synchronous throw or a rejected promise
  // from the task should reject the returned promise. An async task should be awaited.
  return null;
}
--- solution
function runTask(task) {
  return Promise.resolve().then(() => task());
}
--- test
let started = false;
const pending = runTask(() => {
  started = true;
  return 6 * 7;
});
assert(started === false, "The task should not start synchronously");
assertEqual(await pending, 42, "The promise should resolve with the task's result");
assertEqual(await runTask(async () => "async ok"), "async ok", "Async tasks should be awaited");
let message = null;
try {
  await runTask(() => {
    throw new Error("nope");
  });
} catch (err) {
  message = err.message;
}
assertEqual(message, "nope", "A synchronous throw should reject the promise");
--- hint
Wrap the call in a promise chain. `Promise.resolve().then(callback)` runs `callback` asynchronously, and anything it throws or returns (including a promise) flows into the result.
--- hint
`return Promise.resolve().then(() => task());` is the whole function. The arrow matters: it calls `task` inside the chain, so the call itself is deferred.
```

## Stage 2: limit concurrency with a FIFO waiting list

A bounded queue keeps two things: how many tasks are running, and a list of tasks waiting for a slot. `add` puts a task on the waiting list and tries to start it. When a task finishes, it frees its slot and starts the next waiting task. Tasks start in the order they were added, and a rejected task frees its slot the same way a successful one does.

```js exercise id=create-queue title="A queue with a concurrency limit"
function createQueue(concurrency) {
  // TODO: return an object with add(task). add() returns a promise for that task's result.
  // At most `concurrency` tasks run at once, and waiting tasks start in the order they were added.
  // A task that throws must reject its own promise and must not block the queue.
  return null;
}
--- solution
function createQueue(concurrency) {
  const waiting = [];
  let active = 0;
  const next = () => {
    if (active >= concurrency || waiting.length === 0) return;
    const { task, resolve, reject } = waiting.shift();
    active++;
    Promise.resolve()
      .then(task)
      .then(resolve, reject)
      .finally(() => {
        active--;
        next();
      });
    next();
  };
  return {
    add(task) {
      return new Promise((resolve, reject) => {
        waiting.push({ task, resolve, reject });
        next();
      });
    },
  };
}
--- test
const q = createQueue(2);
let running = 0;
let peak = 0;
const job = (ms, value) => async () => {
  running++;
  peak = Math.max(peak, running);
  await new Promise((r) => setTimeout(r, ms));
  running--;
  return value;
};
const results = await Promise.all([q.add(job(20, "a")), q.add(job(10, "b")), q.add(job(10, "c"))]);
assertEqual(results, ["a", "b", "c"], "Each promise should resolve with its own task's result");
assertEqual(peak, 2, "No more than two tasks should run at once");

const failing = createQueue(1);
const boom = failing.add(() => {
  throw new Error("boom");
});
const after = failing.add(() => "still running");
let msg = null;
try {
  await boom;
} catch (err) {
  msg = err.message;
}
assertEqual(msg, "boom", "A failed task should reject its own promise");
assertEqual(await after, "still running", "A failed task must not block the next one");
--- hint
Keep the waiting tasks in an array of `{ task, resolve, reject }` records. `add` returns a `new Promise` whose resolvers go into that array, then asks the queue to start work.
--- hint
Write a `next()` function that starts one waiting task if `active < concurrency`. Run it from `add`, and call it again in `.finally` after decrementing `active`, so each freed slot is refilled.
```

> **Pitfall:** A common mistake is to decrement the counter only on success. A failed task then holds its slot forever, and the queue quietly stops after the first error. Decrement in `finally`, or in both branches, so every outcome frees the slot.

## Stage 3: collect every outcome, in input order

Sometimes the caller doesn't want the queue at all. It has a fixed list of tasks and wants every outcome, successes and failures alike, in the order the tasks were given. That's a worker pool: a fixed number of workers pull the next index from a shared counter until the list is empty. Each result goes into its own slot, so the output order is the input order even when tasks finish out of order.

```js run
const wait = (ms) => new Promise((r) => setTimeout(r, ms));
const tasks = [() => wait(30).then(() => "slow"), () => wait(5).then(() => "fast")];
const finished = await Promise.allSettled(tasks.map((t) => t()));
console.log(finished.map((r) => r.value));
```

`Promise.allSettled` describes each outcome without throwing, and it's the shape the next challenge returns. Its results are in input order too, regardless of which promise settled first.

```js exercise id=run-all title="A worker pool that reports every outcome"
async function runAll(tasks, limit) {
  // TODO: run the task functions with at most `limit` in flight at once.
  // Resolve with an array, in input order, of { status: "fulfilled", value } or
  // { status: "rejected", reason } for each task. Never stop early on a failure.
  return null;
}
--- solution
async function runAll(tasks, limit) {
  const results = new Array(tasks.length);
  let nextIndex = 0;
  const worker = async () => {
    while (nextIndex < tasks.length) {
      const i = nextIndex++;
      try {
        results[i] = { status: "fulfilled", value: await tasks[i]() };
      } catch (reason) {
        results[i] = { status: "rejected", reason };
      }
    }
  };
  await Promise.all(Array.from({ length: Math.min(limit, tasks.length) }, worker));
  return results;
}
--- test
const wait = (ms) => new Promise((r) => setTimeout(r, ms));
const outcomes = await runAll([
  () => 1,
  () => {
    throw new Error("no");
  },
  async () => 3,
], 2);
assertEqual(outcomes.map((o) => o.status), ["fulfilled", "rejected", "fulfilled"], "Each slot should report its own status");
assertEqual(outcomes[0].value, 1, "Fulfilled outcomes carry a value");
assertEqual(outcomes[1].reason.message, "no", "Rejected outcomes carry the error as reason");
assertEqual(outcomes[2].value, 3, "A later task should still run after a failure");

const ordered = await runAll([() => wait(30).then(() => "slow"), () => wait(5).then(() => "fast")], 2);
assertEqual(ordered.map((o) => o.value), ["slow", "fast"], "Results should follow input order, not finishing order");
--- hint
Start `limit` workers, each with the same loop: take the next unused index, await that task inside a `try`, and store the outcome at that index.
--- hint
Let each worker share the `nextIndex` counter. The `try`/`catch` inside the loop turns a rejection into a `{ status: "rejected" }` entry instead of stopping the worker.
```

## Stage 4: the integrated `TaskQueue`

Now assemble the pieces into one class, with the features a real queue needs: a `running` count and a `size` of waiting tasks, `pause` and `resume` to hold back new work, and `onIdle` to wait until everything, including the waiting list, has drained.

The design choice that makes the rest easy is a single `#pump` method. It runs whenever something changes (a task is added, a task finishes, the queue resumes), and it starts as many waiting tasks as the limit and the paused flag allow. Every other method only changes state and calls `#pump`.

```js run
class Counter {
  #count = 0;
  #bump() {
    this.#count++;
  }
  hit() {
    this.#bump();
    return this.#count;
  }
}

const counter = new Counter();
counter.hit();
console.log(counter.hit(), counter.count);
```

The class keeps `#count` and `#bump` private, so the only way to change the count is through `hit`. The `counter.count` in the log is `undefined` because no public property exists. The queue's `#pump` follows the same pattern: callers use `add`, `pause` and `resume`, and the scheduling logic stays behind them.

> **Under the hood:** Private `#` methods and fields are real privacy, enforced by the engine, not a naming convention. Code outside the class can't call `#pump`, so no caller can start tasks while the queue is paused, and no caller can corrupt the running count.

```js exercise id=task-queue title="The integrated TaskQueue"
class TaskQueue {
  constructor(concurrency) {
    this.concurrency = concurrency;
  }
  // TODO: implement the rest of the class.
  // add(task): queue a task and return a promise for its result. Tasks start in FIFO order,
  //   never more than `concurrency` at once, and each task starts asynchronously.
  // get running: the number of tasks currently running.
  // get size: the number of tasks waiting for a slot.
  // pause(): stop starting new tasks. Running tasks continue.
  // resume(): start new tasks again.
  // onIdle(): return a promise that resolves when nothing is running and nothing is waiting.
  add(task) {
    return null;
  }
}
--- solution
class TaskQueue {
  #concurrency;
  #waiting = [];
  #running = 0;
  #paused = false;
  #idleWaiters = [];

  constructor(concurrency) {
    this.#concurrency = concurrency;
  }
  get running() {
    return this.#running;
  }
  get size() {
    return this.#waiting.length;
  }
  add(task) {
    return new Promise((resolve, reject) => {
      this.#waiting.push({ task, resolve, reject });
      this.#pump();
    });
  }
  pause() {
    this.#paused = true;
  }
  resume() {
    this.#paused = false;
    this.#pump();
  }
  onIdle() {
    if (this.#running === 0 && this.#waiting.length === 0) return Promise.resolve();
    return new Promise((resolve) => this.#idleWaiters.push(resolve));
  }
  #pump() {
    while (!this.#paused && this.#running < this.#concurrency && this.#waiting.length > 0) {
      const { task, resolve, reject } = this.#waiting.shift();
      this.#running++;
      Promise.resolve()
        .then(task)
        .then(resolve, reject)
        .finally(() => {
          this.#running--;
          this.#pump();
          if (this.#running === 0 && this.#waiting.length === 0) {
            for (const w of this.#idleWaiters.splice(0)) w();
          }
        });
    }
  }
}
--- test
const q = new TaskQueue(2);
const order = [];
const job = (name, ms) => async () => {
  order.push("start " + name);
  await new Promise((r) => setTimeout(r, ms));
  order.push("end " + name);
  return name.toUpperCase();
};
const p1 = q.add(job("a", 30));
const p2 = q.add(job("b", 10));
const p3 = q.add(job("c", 10));
assertEqual(q.running, 2, "Two tasks should be running right after add");
assertEqual(q.size, 1, "The third task should wait for a slot");
assertEqual(await Promise.all([p1, p2, p3]), ["A", "B", "C"], "Each promise should resolve with its task's result");
assertEqual(order.slice(0, 2), ["start a", "start b"], "The first two tasks should start in FIFO order");
await q.onIdle();
assertEqual(q.running, 0, "Nothing should be running once idle");

q.pause();
let laterDone = false;
const later = q.add(() => "later").then((v) => {
  laterDone = true;
  return v;
});
await new Promise((r) => setTimeout(r, 20));
assertEqual(laterDone, false, "A paused queue must not start new tasks");
q.resume();
assertEqual(await later, "later", "Resuming should start the waiting task");

const slow = new TaskQueue(1);
slow.add(() => new Promise((res) => setTimeout(() => res(1), 20)));
let idle = false;
const waitIdle = slow.onIdle().then(() => {
  idle = true;
});
assertEqual(idle, false, "onIdle should wait while a task is running");
await waitIdle;
assertEqual(idle, true, "onIdle should resolve once the queue is empty");

const failing = new TaskQueue(1);
const bad = failing.add(() => {
  throw new Error("bad");
});
const fine = failing.add(() => "fine");
let badMessage = null;
try {
  await bad;
} catch (err) {
  badMessage = err.message;
}
assertEqual(badMessage, "bad", "A failed task should reject its own promise");
assertEqual(await fine, "fine", "A failed task should not block later tasks");
--- hint
Keep the state as private fields: the waiting list, the running count, the paused flag and the idle waiters. `add` pushes a record and calls a private `#pump` method.
--- hint
`#pump` loops while the queue is not paused, has a free slot and has waiting tasks. Inside it, `Promise.resolve().then(task).then(resolve, reject).finally(...)` runs each task. The `finally` decrements `#running`, calls `#pump` again and resolves idle waiters when the queue is empty.
```

## Debugging: the queue that stopped after one failure

Before the final recap, one bug from the real world. A queue that works in every happy-path test can stall the first time a task throws, because the failure path skipped the bookkeeping. Read this version and decide what the next waiting task would see.

```js debug id=stalled-queue title="The queue that stopped after one failure"
// Like createQueue, but a failing task must free its slot so the next task can run.
function createQueue(concurrency) {
  const waiting = [];
  let active = 0;
  const next = () => {
    if (active >= concurrency || waiting.length === 0) return;
    const { task, resolve, reject } = waiting.shift();
    active++;
    Promise.resolve()
      .then(task)
      .then(
        (value) => {
          active--;
          resolve(value);
          next();
        },
        (err) => {
          reject(err);
        },
      );
    next();
  };
  return {
    add(task) {
      return new Promise((resolve, reject) => {
        waiting.push({ task, resolve, reject });
        next();
      });
    },
  };
}
--- solution
function createQueue(concurrency) {
  const waiting = [];
  let active = 0;
  const next = () => {
    if (active >= concurrency || waiting.length === 0) return;
    const { task, resolve, reject } = waiting.shift();
    active++;
    Promise.resolve()
      .then(task)
      .then(
        (value) => {
          active--;
          resolve(value);
          next();
        },
        (err) => {
          active--;
          reject(err);
          next();
        },
      );
    next();
  };
  return {
    add(task) {
      return new Promise((resolve, reject) => {
        waiting.push({ task, resolve, reject });
        next();
      });
    },
  };
}
--- test
const q = createQueue(1);
const bad = q.add(() => {
  throw new Error("bad");
});
const ok = q.add(() => "ok");
let message = null;
try {
  await bad;
} catch (err) {
  message = err.message;
}
assertEqual(message, "bad", "The failure should reach the caller");
const outcome = await Promise.race([ok, new Promise((r) => setTimeout(() => r("stalled"), 50))]);
assertEqual(outcome, "ok", "A failed task must free its slot so the next task can run");
--- hint
Compare the success branch with the failure branch. What does the success branch do that the failure branch doesn't?
--- hint
The failure callback needs the same bookkeeping as the success callback: decrement `active`, reject the caller, then call `next()` to refill the slot.
```

> **Pitfall:** A promise callback that throws, or a branch that forgets a line of bookkeeping, fails silently. The caller is left waiting, and nothing reports an error. Test the failure path of every queue or pool, not just the success path.

## Predict: when does the next task run?

Last, a prediction about microtask ordering, since the queue depends on it. Predict the output before you check the options.

```js predict id=predict-microtask-order title="Two microtasks, one log"
const log = [];
const queueish = (task) => {
  Promise.resolve().then(task);
};
queueish(() => log.push("task"));
log.push("after add");
Promise.resolve().then(() => console.log(log.join(",")));
--- options
task,after add
after add
* after add,task
task
--- explain
`queueish` schedules `task` as a microtask, but the callback doesn't run yet. `"after add"` is pushed synchronously. The final `Promise.resolve().then` is also a microtask, scheduled after the task's, so the task runs first and pushes `"task"`, and then the logging callback prints `after add,task`. Scheduling order decides microtask order, and this is why `add` never runs the task synchronously.
```

## Recap

- Starting work is separate from accepting it. Defer the task with `Promise.resolve().then(...)` so it never runs inside the caller's call stack.
- A concurrency limit needs two pieces of state: the running count and a FIFO list of waiters. Free the slot on every outcome, including failure.
- Worker pools keep results in input order by writing each outcome to its own index, and they never stop early on a failure.
- A single `#pump` method that every state change calls keeps the queue's invariants in one place.
- Test the failure path and the pause path, not just the happy path.

**Up next:** the second capstone, a reactive store with subscriptions, the core idea behind modern state libraries.
