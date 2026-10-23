Modern state libraries (Redux, Zustand, Svelte stores, the signals behind several frameworks) share one core idea: keep the application state in one place, change it only through a controlled door, and tell interested parts of the program when it changes. Everything else is built on top of that. A component re-renders when the slice it reads changes. A cache invalidates when its source changes. A form validates when a field changes. The machinery is small, and the details decide whether an app stays fast and predictable.

In this capstone you'll build a reactive store in five steps. You'll write the basic container, add subscriptions with change detection, select a slice of state so listeners ignore unrelated changes, batch several updates into one notification, and then assemble everything into one store. Each step has its own challenge, and the test for each step checks behavior you can use directly in an app.

## The state container

The first run cell shows the core trick. The state lives in a variable that only the functions can reach, and the public door is a `set` that accepts either a new value or an updater. Updaters are important because they read the latest state at the moment of the update, so two updates in a row can't clobber each other.

```js run
let count = 0;
const setCount = (next) => {
  count = typeof next === "function" ? next(count) : next;
};

setCount(5);
setCount((c) => c + 1);
console.log(count);
```

Notice what the caller can't do: reach in and assign `count` directly. Every change goes through one function, and that's the single place where you can add notifications, logging or validation later.

## Change detection with `Object.is`

Before a store notifies anyone, it has to decide whether anything actually changed. The comparison it should use is `Object.is`, which is `===` with two fixes: `NaN` equals `NaN`, and `+0` is different from `-0`. For a store, the more important point is that objects compare by identity.

```js run
console.log(Object.is(NaN, NaN), NaN === NaN, Object.is(0, -0), 0 === -0);
```

That identity rule has a practical consequence. A selector that returns a fresh object on every call looks like a change every time, even when the data didn't move:

```js run
const state = { user: { name: "Ada" }, theme: "light" };
const selectUser = (s) => ({ user: s.user });

console.log(Object.is(selectUser(state), selectUser(state)), Object.is(selectUser(state).user, state.user));
```

The wrapper object is new each time, but the `user` inside it is the same reference. Stores rely on stable references: when a state update leaves a branch alone, the branch keeps its identity, and a selector that returns that branch reports no change. This is the structural sharing idea from the immutability lesson, now doing real work.

## Stage 1: a store with `get` and `set`

Your first challenge is the container itself. It must hold the state privately, return it from `get`, and accept updaters in `set`.

```js exercise id=create-store title="A store with get and set"
function createStore(initial) {
  // TODO: return { get, set }. get() returns the current state.
  // set(next) accepts a new state, or a function that receives the current state and returns the new one.
  return null;
}
--- solution
function createStore(initial) {
  let state = initial;
  return {
    get() {
      return state;
    },
    set(next) {
      state = typeof next === "function" ? next(state) : next;
    },
  };
}
--- test
const store = createStore({ count: 0 });
assertEqual(store.get(), { count: 0 }, "get should return the initial state");
store.set({ count: 5 });
assertEqual(store.get(), { count: 5 }, "set should replace the state with a value");
store.set((s) => ({ count: s.count + 1 }));
assertEqual(store.get(), { count: 6 }, "set should accept an updater that receives the current state");
const numbers = createStore(1);
numbers.set((n) => n * 10);
assertEqual(numbers.get(), 10, "Updaters work with primitive states too");
--- hint
Keep the state in a `let` variable inside `createStore`, and return an object whose methods read and write that variable.
--- hint
In `set`, check `typeof next === "function"`. If it is, call it with the current state and store the result. Otherwise store `next` directly.
```

## Stage 2: subscriptions and change notifications

A store that nobody hears from is just a variable. Subscriptions let other code react. The rules are simple, and each one matters: `subscribe` returns an unsubscribe function, listeners receive both the next and previous state, and setting an equal value does nothing at all.

```js run
const listeners = [];
let value = 1;
listeners.push((next, prev) => console.log("changed", prev, "->", next));

const setValue = (next) => {
  const prev = value;
  value = next;
  if (!Object.is(prev, next)) listeners.forEach((fn) => fn(next, prev));
};

setValue(2);
setValue(2);
```

The second `setValue(2)` is silent, which is the behavior you want. A store that notifies on every write forces every subscriber to do its own comparison, and most subscribers get that comparison wrong.

```js exercise id=subscribable-store title="Notify subscribers when the state changes"
function createSubscribableStore(initial) {
  // TODO: return { get, set, subscribe }. Like createStore, but:
  // subscribe(listener) registers a listener and returns an unsubscribe function.
  // After a set that changes the state (compared with Object.is), every listener is called
  // as listener(nextState, previousState). Setting an equal state does nothing.
  return null;
}
--- solution
function createSubscribableStore(initial) {
  let state = initial;
  const listeners = new Set();
  return {
    get() {
      return state;
    },
    set(next) {
      const prev = state;
      state = typeof next === "function" ? next(state) : next;
      if (Object.is(state, prev)) return;
      for (const fn of [...listeners]) fn(state, prev);
    },
    subscribe(fn) {
      listeners.add(fn);
      return () => {
        listeners.delete(fn);
      };
    },
  };
}
--- test
const store = createSubscribableStore(0);
const log = [];
const stop = store.subscribe((next, prev) => log.push([next, prev]));
store.set(1);
store.set(1);
store.set((n) => n + 1);
assertEqual(log, [[1, 0], [2, 1]], "Listeners should receive (next, previous), and equal values should not notify");
stop();
store.set(10);
assertEqual(log.length, 2, "An unsubscribed listener should stop receiving changes");
assertEqual(store.get(), 10, "The state should still update without subscribers");
--- hint
Keep a `Set` of listeners next to the state. `subscribe` adds to the set, and returns a function that deletes from it.
--- hint
In `set`, remember the previous state and compute the next one. Return early if `Object.is(state, prev)`. Otherwise loop over a copy of the listeners and call each with `(state, prev)`.
```

> **Pitfall:** Iterate over a copy of the listener set (`[...listeners]`). If a listener unsubscribes itself while the loop runs, a live iteration can skip the next listener, which is exactly the bug from the design patterns lesson.

## Stage 3: select a slice

Most components don't care about the whole state. A header wants `user.name`, and a counter wants `count`. A selector is a function that picks out the slice a listener cares about, and `select` calls the listener only when that slice changes. An update to the theme should never wake a listener that reads the count.

The `select` function below works on any store with `get` and `subscribe`, which is why its test builds a tiny store by hand. That's the point of keeping the interface small.

```js exercise id=select-slice title="Subscribe to one slice of the state"
function select(store, selector, listener) {
  // TODO: subscribe to `store`, and call listener(value, previousValue) only when
  // selector(state) changes (compared with Object.is). Return the unsubscribe function.
  return null;
}
--- solution
function select(store, selector, listener) {
  let last = selector(store.get());
  return store.subscribe((state) => {
    const value = selector(state);
    if (Object.is(value, last)) return;
    const prev = last;
    last = value;
    listener(value, prev);
  });
}
--- test
let state = { count: 0, theme: "light" };
const subs = new Set();
const store = {
  get: () => state,
  subscribe(fn) {
    subs.add(fn);
    return () => subs.delete(fn);
  },
  set(next) {
    const prev = state;
    state = next;
    for (const fn of [...subs]) fn(state, prev);
  },
};
const seen = [];
const stop = select(store, (s) => s.count, (value, prev) => seen.push([value, prev]));
store.set({ count: 0, theme: "dark" });
assertEqual(seen, [], "A change to another slice should not notify");
store.set({ count: 3, theme: "dark" });
assertEqual(seen, [[3, 0]], "A changed slice should notify with the new and previous values");
stop();
store.set({ count: 4, theme: "dark" });
assertEqual(seen.length, 1, "After unsubscribing, the listener should stop");
--- hint
Compute the slice once when you subscribe and keep it in a variable. Each time the store notifies, compute the slice again and compare it with that variable.
--- hint
Inside the subscription callback: `const value = selector(state)`. If `Object.is(value, last)`, return. Otherwise update `last` and call `listener(value, prev)`.
```

## Stage 4: batching, and a read that sees the draft

Sometimes one user action updates several fields, and subscribers should hear about the result once, not once per field. A batch collects updates in a draft and writes the store a single time at the end. The draft has to behave like the store while the batch runs: a read inside the batch must see the updates that already happened in it.

Here's a batch helper with a bug in its draft. Read it closely before you run the test.

```js debug id=batch-stale-draft title="Updates that overwrite each other"
// Run several updates as one: each read and update sees the batch's earlier updates,
// and the store is written once at the end, if anything changed.
function runBatch(store, fn) {
  const start = store.get();
  let pending = start;
  fn({
    get: () => start,
    set(next) {
      pending = typeof next === "function" ? next(pending) : next;
    },
  });
  if (pending !== start) store.set(pending);
}
--- solution
function runBatch(store, fn) {
  const start = store.get();
  let pending = start;
  fn({
    get: () => pending,
    set(next) {
      pending = typeof next === "function" ? next(pending) : next;
    },
  });
  if (pending !== start) store.set(pending);
}
--- test
let value = { a: 0 };
const store = { get: () => value, set(next) { value = next; } };
runBatch(store, (draft) => {
  draft.set({ a: draft.get().a + 1 });
  draft.set({ a: draft.get().a + 1 });
});
assertEqual(value, { a: 2 }, "A read inside the batch should see the earlier updates in that batch");

let writes = 0;
const counted = { get: () => value, set(next) { writes++; value = next; } };
runBatch(counted, (draft) => {
  draft.set({ a: 5 });
  draft.set({ a: 6 });
});
assertEqual(writes, 1, "The store should be written once per batch");
assertEqual(value, { a: 6 }, "The final value should be the last update");
--- hint
Look at what `get` returns while the batch is still running. Should it return the store's value from before the batch, or the draft?
--- hint
`get` should return `pending`, the draft that already includes the earlier updates in this batch.
```

> **Under the hood:** A batch works because the draft is a separate value. Reads and writes go to `pending`, and the store is touched once. Libraries call this a transaction or a draft, and immer's `produce` is the same idea applied to nested objects.

## Final: the reactive store

Now assemble the store. It needs `get` and `set` from stage 1, `subscribe` with change detection from stage 2, `select` from stage 3, and batching from stage 4, combined so that a batch suppresses notifications until it finishes.

The design is one `depth` counter and one `notify` helper. `notify` returns early while a batch is open, and `batch` increments the counter, runs its function, decrements it in a `finally` and then notifies once with the state from before the batch. `select` is `subscribe` plus a remembered value, so it reuses the notification path rather than duplicating it.

```js exercise id=create-reactive-store title="A reactive store with select and batch"
function createReactiveStore(initial) {
  // TODO: return a store with:
  // get(): the current state
  // set(valueOrUpdater): update the state and notify subscribers if it changed (Object.is)
  // subscribe(listener): listener(next, prev) on each change; returns an unsubscribe function
  // select(selector, listener): like subscribe, but only when selector(state) changes
  // batch(fn): run fn. Updates inside it notify subscribers once, after fn returns, if the state changed
  return null;
}
--- solution
function createReactiveStore(initial) {
  let state = initial;
  let depth = 0;
  const listeners = new Set();
  const notify = (prev) => {
    if (depth > 0 || Object.is(state, prev)) return;
    for (const fn of [...listeners]) fn(state, prev);
  };
  const store = {
    get: () => state,
    set(next) {
      const prev = state;
      state = typeof next === "function" ? next(state) : next;
      notify(prev);
    },
    subscribe(fn) {
      listeners.add(fn);
      return () => listeners.delete(fn);
    },
    select(selector, listener) {
      let last = selector(state);
      return store.subscribe((next) => {
        const value = selector(next);
        if (Object.is(value, last)) return;
        const prev = last;
        last = value;
        listener(value, prev);
      });
    },
    batch(fn) {
      const prev = state;
      depth++;
      try {
        fn();
      } finally {
        depth--;
        notify(prev);
      }
    },
  };
  return store;
}
--- test
const s = createReactiveStore({ n: 0, label: "x" });
const seen = [];
const unsub = s.subscribe((next) => seen.push(next.n));
s.set((st) => ({ ...st, n: 1 }));
assertEqual(seen, [1], "Subscribers should receive the new state once");
s.set((st) => st);
assertEqual(seen, [1], "Setting the same state should not notify");
unsub();
s.set({ n: 9, label: "y" });
assertEqual(seen, [1], "Unsubscribed listeners should stop receiving changes");

const t = createReactiveStore({ count: 0, theme: "light" });
const changes = [];
t.select((st) => st.count, (value, prev) => changes.push([value, prev]));
t.set((st) => ({ ...st, theme: "dark" }));
assertEqual(changes, [], "A change outside the selected slice should not notify");
t.set((st) => ({ ...st, count: 2 }));
assertEqual(changes, [[2, 0]], "A changed slice should notify with the new and previous values");

const b = createReactiveStore({ a: 1, b: 1 });
let notifications = 0;
b.subscribe(() => notifications++);
b.batch(() => {
  b.set((st) => ({ ...st, a: 2 }));
  b.set((st) => ({ ...st, b: 2 }));
});
assertEqual(notifications, 1, "A batch should notify once, after all its updates");
assertEqual(b.get(), { a: 2, b: 2 }, "Every update in the batch should be applied");
b.batch(() => {});
assertEqual(notifications, 1, "An empty batch should not notify");
--- hint
Start from the stage 2 store: a `Set` of listeners, a `notify(prev)` helper, and `set` calling it. Then add a `depth` counter that `notify` checks.
--- hint
`select` can be built on `subscribe`: remember the last selected value and compare on each change. `batch` increments `depth`, runs `fn` inside a `try`, and in the `finally` decrements `depth` and calls `notify` with the state from before the batch.
```

## Predict: unsubscribing is per listener

Last, a prediction about subscriptions. Predict the output before you check the options. The subscriber list is copied before each notification, which is the same snapshot discipline you've been using.

```js predict id=predict-store-notify title="Who hears the change"
const seen = [];
const subs = [];
const subscribe = (fn) => {
  subs.push(fn);
  return () => subs.splice(subs.indexOf(fn), 1);
};
const offA = subscribe((v) => seen.push("a" + v));
subscribe((v) => seen.push("b" + v));
subs.slice().forEach((fn) => fn(1));
offA();
subs.slice().forEach((fn) => fn(2));
console.log(seen.join(" "));
--- options
a1 b1 a2 b2
* a1 b1 b2
a1 a2 b2
b1 b2
--- explain
The first notification reaches both listeners, so `seen` gets `a1` and `b1`. `offA()` removes exactly the listener it returned for, which is `a`, leaving `b` subscribed. The second notification reaches only `b`, so the output is `a1 b1 b2`. A common bug is an unsubscribe that removes by position or pops the last listener, which would remove the wrong one.
```

## Recap

- A store owns its state. Changes go through `set`, which accepts a value or an updater that reads the latest state.
- Notify only on real changes, compared with `Object.is`, and pass both the next and previous state to listeners.
- Selectors should return stable references. A new object on every call looks like a change every time.
- `select` subscribes to a slice, so unrelated updates don't wake a listener.
- A batch uses a draft for reads and writes, writes the store once, and notifies once, even when the batch throws.

**Up next:** the final capstone, an API client with retries, caching and cancellation, built stage by stage on the same habits you've practiced here.
