Design patterns have a bad reputation in JavaScript, mostly because the textbook versions were written for languages without first-class functions, closures or object literals. In JavaScript, many classic patterns are a single function or a plain object. The useful question is not "which pattern is this?" but "what problem am I solving, and which of the three or four shapes that solve it does the language already give me?"

This lesson covers the patterns you'll meet in real code: observers (events and subscriptions), factories (creating objects by name), strategies (swapping behavior at runtime) and decorators (wrapping behavior without touching it). For each one you'll see the JavaScript-native form first, then the place where it tends to break.

## Observer: publish, subscribe, and don't break the loop

The observer pattern separates the code that produces events from the code that reacts to them. A store changes state and tells subscribers; a button emits clicks and listeners respond. The producer keeps a list of subscribers and calls each one when something happens.

A class with a private set of listeners is the smallest working version. `subscribe` returns an unsubscribe function, which is the most useful part of the design: the subscriber owns its own cleanup.

```js run
class Notifier {
  #listeners = new Set();

  subscribe(fn) {
    this.#listeners.add(fn);
    return () => this.#listeners.delete(fn);
  }

  notify(value) {
    for (const fn of this.#listeners) fn(value);
  }
}

const notifier = new Notifier();
const stop = notifier.subscribe((v) => console.log("got", v));
notifier.notify(1);
stop();
notifier.notify(2);
```

The second notification is silent, because the unsubscribe function removed the listener. Forgetting that cleanup is the number one cause of leaks in long-lived UIs: a component unmounts, its listener stays on the store, and the store keeps calling a dead component.

Now the subtle part. Each listener in an observer might unsubscribe itself, or another listener, while `notify` is running. Iterating a live collection while it changes is where observers get their hardest bugs, and the next challenge is built around it. For now, the safe rule is to notify from a snapshot.

```js exercise id=create-emitter title="An event emitter with unsubscribe"
function createEmitter() {
  // TODO: return { on(event, listener), emit(event, ...args) }.
  // on() returns an unsubscribe function. emit() calls every listener subscribed to `event`
  // with the arguments, in subscription order. Emitting with no listeners does nothing.
  return null;
}
--- solution
function createEmitter() {
  const events = new Map();
  return {
    on(event, listener) {
      const entry = { listener };
      if (!events.has(event)) events.set(event, []);
      events.get(event).push(entry);
      return () => {
        events.set(event, events.get(event).filter((e) => e !== entry));
      };
    },
    emit(event, ...args) {
      const entries = events.get(event) ?? [];
      for (const entry of [...entries]) entry.listener(...args);
    },
  };
}
--- test
const bus = createEmitter();
const got = [];
const off = bus.on("save", (x) => got.push(`a:${x}`));
bus.on("save", (x) => got.push(`b:${x}`));
bus.emit("save", 1);
off();
bus.emit("save", 2);
assertEqual(got, ["a:1", "b:1", "b:2"], "Listeners run in order, and unsubscribed ones stop receiving events");
bus.emit("nothing");
assertEqual(got.length, 3, "Emitting an event with no listeners should do nothing");
--- hint
Keep a list of listeners per event name in a Map. The unsubscribe function needs to remove exactly the entry that `on` added, so give each subscription its own object.
--- hint
In `emit`, copy the list first (`[...entries]`) and call each entry's listener with `...args`. Create the list in `on` when the event is new.
```

## Debugging: the listener that skipped its neighbor

Here is a hub that works in simple cases and fails in the one case that real listeners hit often: a listener that unsubscribes itself, such as a "run once" handler. Read the loop carefully. What happens to the index when the list shrinks in the middle of the loop?

```js debug id=emit-live-list title="The listener that was skipped"
// Each subscriber receives every published value. A subscriber may unsubscribe while a publish is running.
function createHub() {
  const listeners = [];
  return {
    subscribe(fn) {
      listeners.push(fn);
      return () => {
        const i = listeners.indexOf(fn);
        if (i !== -1) listeners.splice(i, 1);
      };
    },
    publish(value) {
      for (let i = 0; i < listeners.length; i++) {
        listeners[i](value);
      }
    },
  };
}
--- solution
function createHub() {
  const listeners = [];
  return {
    subscribe(fn) {
      listeners.push(fn);
      return () => {
        const i = listeners.indexOf(fn);
        if (i !== -1) listeners.splice(i, 1);
      };
    },
    publish(value) {
      for (const fn of [...listeners]) fn(value);
    },
  };
}
--- test
const hub = createHub();
const calls = [];
const offOnce = hub.subscribe((v) => {
  calls.push("once:" + v);
  offOnce();
});
hub.subscribe((v) => calls.push("steady:" + v));
hub.publish(1);
hub.publish(2);
assertEqual(calls, ["once:1", "steady:1", "steady:2"], "Every subscriber should run on the first publish, even when one unsubscribes during it");
--- hint
Think about the index. When the first listener removes itself, what does the listener that used to be at index 1 become?
--- hint
Iterate over a copy of the array, for example `for (const fn of [...listeners])`. Unsubscribing then changes the live array, but the loop keeps the snapshot it started with.
```

> **Pitfall:** Iterating a live array while callbacks modify it is the observer pattern's classic bug. The fix is a snapshot. The same reasoning applies to any "for each handler" loop, including DOM event listeners that call `removeEventListener` in their own body.

## Factory: create by name, hide the constructor

A factory is a function that decides which kind of object to build. In JavaScript you usually don't need a class hierarchy for it. A table from names to constructor functions does the job, and it keeps the choice in one place:

```js run
const shapeFactories = {
  square: (size) => ({ kind: "square", area: size * size }),
  circle: (r) => ({ kind: "circle", area: Math.round(Math.PI * r * r) }),
};

function createShape(kind, size) {
  const make = shapeFactories[kind];
  if (!make) throw new Error(`No factory for ${kind}`);
  return make(size);
}

console.log(createShape("square", 3));
console.log(createShape("circle", 2).area);
```

The factory is the only code that knows the names. Callers ask for `"square"` and never import a `Square` class, so you can add a shape by adding one entry to the table.

> **Pitfall:** `shapeFactories["toString"]` is a function, because plain objects inherit from `Object.prototype`. The `if (!make)` guard passes, and the factory calls `Object.prototype.toString` by mistake. Either use `Object.hasOwn(table, kind)` or, better, a `Map`, which only has the entries you put in it.

## Strategy: swap an algorithm by name

A strategy is a function you select at runtime. Shipping costs, tax rules and sort orders are typical: the calling code is the same, and only the rule changes. Passing the function itself is usually enough, which is why the strategy pattern needs no interface in JavaScript.

```js run
const shipping = {
  ground: (w) => 5 + w * 0.5,
  air: (w) => 12 + w * 1.25,
};

const withSurcharge = (fn, extra) => (w) => fn(w) + extra;
const rush = withSurcharge(shipping.air, 4);

console.log(shipping.ground(10), rush(10));
```

`withSurcharge` takes a strategy and returns a new one. That's the decorator pattern, the next section, and it's the most common way strategies get composed. The calling code never changes when the rules do.

The exercise below turns the strategy table into a pricer. It also repeats the lesson from the factory pitfall, so you'll see the same trap in a different form.

```js exercise id=create-pricing title="A pricing function driven by named strategies"
function createPricing(strategies) {
  // TODO: `strategies` maps a name to a function of the amount.
  // Return price(kind, amount), which runs the matching strategy.
  // An unknown name should throw Error("Unknown pricing strategy: <name>").
  // Names inherited from Object.prototype, such as "toString", are not strategies.
  return null;
}
--- solution
function createPricing(strategies) {
  const table = new Map(Object.entries(strategies));
  return (kind, amount) => {
    if (!table.has(kind)) throw new Error(`Unknown pricing strategy: ${kind}`);
    return table.get(kind)(amount);
  };
}
--- test
const price = createPricing({ regular: (a) => a, member: (a) => a * 0.9, sale: (a) => Math.round(a * 0.5) });
assertEqual(price("regular", 100), 100, "A regular strategy should return the amount");
assertEqual(price("member", 50), 45, "Each strategy should be chosen by name");
assertEqual(price("sale", 33), 17, "Strategies should run with the given amount");
let message = null;
try {
  price("toString", 1);
} catch (err) {
  message = err.message;
}
assertEqual(message, "Unknown pricing strategy: toString", "Inherited names must not count as strategies");
--- hint
`Object.entries(strategies)` gives you `[name, fn]` pairs. A `Map` built from those pairs holds exactly the names you supplied, so `has(kind)` is a safe check.
--- hint
Inside the returned function: if `table.has(kind)` is false, throw the error. Otherwise call `table.get(kind)(amount)`.
```

## Decorator: wrap behavior without changing it

A decorator is a function that takes a function and returns a new one with extra behavior around it. Logging, timing, caching and retries are all decorators. The original function never knows it's wrapped, and you can stack several.

Stacking order is worth tracing carefully, because the outermost wrapper runs first:

```js predict id=predict-decorator-order title="Which wrapper runs first"
const log = [];
const withLog = (name, fn) => (...args) => {
  log.push(name);
  return fn(...args);
};
const double = (n) => n * 2;
const wrapped = withLog("outer", withLog("inner", double));
console.log(wrapped(4), log.join(">"));
--- options
8 inner>outer
4 outer>inner
16 outer>inner
* 8 outer>inner
--- explain
`wrapped` is the outer wrapper. It pushes `"outer"`, then calls the inner wrapper, which pushes `"inner"` and calls `double`. `double(4)` is 8, and the log reads `outer>inner`. The outer wrapper runs its own code before it calls the one it wraps, so the outer name is recorded first. Stacking decorators is how middleware works in Express and in many HTTP clients.
```

## Singleton: one instance, through a closure

A singleton is a value you want exactly one of: a logger, a configuration object, a connection pool. In a module, the module cache already gives you one, as the modules lesson showed. You can also get one with a closure, which makes the lazy creation explicit:

```js run
const makeLogger = (() => {
  let instance = null;
  return () => {
    if (!instance) {
      instance = {
        lines: [],
        write(msg) {
          this.lines.push(msg);
        },
      };
    }
    return instance;
  };
})();

makeLogger().write("start");
makeLogger().write("done");
console.log(makeLogger() === makeLogger(), makeLogger().lines);
```

The first call creates the instance, and every later call returns the same object. Be cautious with singletons in tests: a shared instance carries state from one test into the next, and that's a common source of order-dependent failures.

> **In the wild:** Node's `EventEmitter` and the browser's `addEventListener` are observers. Express middleware is a chain of decorators around a handler. Redux and most reactive stores are observers with a snapshot-based notify step, exactly the fix from the debugging section above.

## Recap

- Many classic patterns are a function, a closure or a plain object in JavaScript. Reach for the simplest shape that solves the problem.
- Observers must return an unsubscribe function, and they must notify from a snapshot so listeners can change the list safely.
- Factories and strategy tables should use a `Map` (or `Object.hasOwn`), so inherited names never count as entries.
- Decorators wrap a function and return a new one. The outermost wrapper runs first, and stacking them composes behavior.
- A singleton is a value created once. Treat shared singleton state as something tests must reset.

**Up next:** functional programming: pure functions, composition, and currying, and how they make the patterns you just learned easier to reason about.
