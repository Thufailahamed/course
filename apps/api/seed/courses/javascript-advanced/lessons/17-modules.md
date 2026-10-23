Every real JavaScript program is a graph of modules. A bundle that ships to a browser, a Node server, a CLI tool: each is a set of files that import one another, and the order in which those files run, what they can see, and how many times their code executes all come from one system. When that system misbehaves, you see the symptoms far away from the cause: a configuration that's read before it's set, a singleton that exists twice, a feature that loads 400 KB too early. Understanding modules turns those symptoms into a short list of rules.

This lesson covers the ES module rules that decide what runs and what it sees, how a module is evaluated exactly once, why exports are live bindings and not copies, and how dynamic `import()` lets you load code only when it's needed. The syntax itself is in the static snippets below. The run cells simulate the module system, so you can watch the rules happen.

> **Note:** Import and export statements can't run inside this lesson's cells, because a cell is a script, not a file on disk. Everything you'd write with `import` is shown as static code, and the runnable examples model the same behavior with plain functions.

## Why modules exist: scope and a dependency graph

Before modules, every script shared one global scope. Two files that both declared `const config` collided, and the load order of `<script>` tags was the only dependency mechanism. Developers worked around it with the module pattern, an immediately invoked function that returns only what it wants to expose:

```js run
const counterModule = (() => {
  let count = 0;
  return {
    increment() {
      count += 1;
      return count;
    },
    get value() {
      return count;
    },
  };
})();

counterModule.increment();
console.log(counterModule.value, counterModule.count);
```

`count` is private: nothing outside can read or change it except through the methods. That encapsulation is the core idea behind modules. ES modules give it to you as a language feature, with two extra guarantees. A module has its own top-level scope, so nothing leaks into globals. And the import graph is static, so the engine can see every dependency before running any code.

## The syntax, as you'll write it

Here is the full vocabulary. These are static examples, not runnable cells:

```js
// math.js: named exports
export const PI = 3.14159;
export function area(r) {
  return PI * r * r;
}

// geometry.js: a default export and a re-export
export default class Shape {}
export { area } from "./math.js";

// app.js: import by name, rename, or take the whole namespace
import Shape, { area as circleArea, PI } from "./geometry.js";
import * as math from "./math.js";
```

A few rules are worth memorizing, because they explain most surprises:

- Each file is a module only when it's loaded as one (`type="module"` in HTML, `.mjs`, or `"type": "module"` in `package.json`). The same code in a classic script has different scoping and no static imports.
- Named exports are matched by name. Renaming with `as` happens on the importing side, and the exporting module never changes.
- A default export has no fixed name. Each importer chooses one, which is convenient and also how two different modules end up with the same confusing name.
- Imports are hoisted and resolved before any module body runs. An `import` can't be conditional. For that, you use dynamic `import()`.

> **Pitfall:** Because imports are static, a circular dependency (A imports B, and B imports A) doesn't crash. Instead, one module runs before the other has finished, and it sees the other's exports in their not-yet-initialized state. Keep the graph acyclic, and if you must have a cycle, don't read the other module's values at load time.

## Live bindings: an import is a window, not a copy

When module A exports a `let` variable, module B's import of it is a live binding. When A changes the variable, B sees the new value. An import is a read-only view onto the exporting module's variable, not a copy of its value.

The simulation below shows the idea with a getter. The exports object doesn't hold a number; it holds a function that reads the current value of `counter`:

```js run
let counter = 0;
const counterExports = {
  get counter() {
    return counter;
  },
};

function increment() {
  counter++;
}
increment();
increment();

console.log(counterExports.counter);
```

Two increments later, the reader sees 2, because it reads the variable each time. A CommonJS `require` gives you a copy of the value at the time of the call, which is why the two systems behave differently when the value changes. Live bindings also mean an importer can't assign to an import (`counter = 5` throws in ESM), so only the owning module can change its own state.

## Evaluation happens once

A module's body runs the first time it's imported, and every later import returns the same module instance. That caching rule is what makes singletons, shared stores and global configuration work across a whole application. It's also what makes side effects in module bodies dangerous: they happen once, at a moment determined by the import graph.

A small registry shows the rule in action. Each factory is a module body. The registry runs it on the first `load` and returns the cached exports afterwards:

```js run
const factories = new Map();
const loaded = new Map();

function define(name, factory) {
  factories.set(name, factory);
}

function load(name) {
  if (loaded.has(name)) return loaded.get(name);
  const factory = factories.get(name);
  if (!factory) throw new Error(`Unknown module: ${name}`);
  const exports = {};
  loaded.set(name, exports); // cache before running, so cycles see the partial exports
  factory(exports, load);
  return exports;
}

define("math", (exports) => {
  exports.add = (a, b) => a + b;
  console.log("evaluating math");
});
define("app", (exports, require) => {
  const m = require("math");
  exports.run = () => m.add(2, 3);
  console.log("evaluating app");
});

console.log(load("app").run());
console.log(load("math").add(10, 1));
```

`math` is evaluated while `app` is loading, before `app`'s own log line, and it's never evaluated again. The `loaded.set` call happens before the factory runs. That ordering is what lets a circular dependency receive a partially filled exports object instead of recursing forever, which is how CommonJS handles cycles.

Dynamic `import()` is the same cache with a promise in front of it. The first call starts loading, and later calls get the same promise:

```js run
const lazyCache = new Map();
const loadOnce = (name, load) => {
  if (!lazyCache.has(name)) lazyCache.set(name, load());
  return lazyCache.get(name);
};

const first = loadOnce("chart", async () => ({ draw: () => "drawn" }));
const second = loadOnce("chart", async () => ({ draw: () => "again" }));

console.log(first === second);
const chart = await first;
console.log(chart.draw());
```

In a real bundle, `await import("./chart.js")` is the same idea, and the bundler splits `chart.js` into its own file so the browser downloads it only when the code path runs.

> **In the wild:** Webpack, Vite and Rollup all build a module graph like the registry above. Code splitting is the one place where a dynamic `import()` creates a chunk boundary, and it's why a route-level `lazy()` in React works. The cache is also why a module that reads `window.location` at load time can give you stale data in a single-page app.

## Exercise: work out the evaluation order

The runtime order of a module graph is a depth-first walk: a module's dependencies run before the module itself, and each module runs once. Writing that walk yourself is the fastest way to internalize why the order is what it is, and why a cycle doesn't make it loop forever.

```js exercise id=evaluation-order title="Compute the order modules run in"
function evaluationOrder(graph, entry) {
  // TODO: `graph` maps each module name to the names it imports.
  // Return the names in the order they would be evaluated, starting from `entry`:
  // dependencies first, each module exactly once, and cycles must not loop forever.
  return null;
}
--- solution
function evaluationOrder(graph, entry) {
  const order = [];
  const visited = new Set();
  const visit = (name) => {
    if (visited.has(name)) return;
    visited.add(name);
    for (const dep of graph[name] ?? []) visit(dep);
    order.push(name);
  };
  visit(entry);
  return order;
}
--- test
const graph = { app: ["ui", "store"], ui: ["store", "react"], store: [], react: [] };
assertEqual(evaluationOrder(graph, "app"), ["store", "react", "ui", "app"], "Dependencies should come before the modules that import them");
assertEqual(evaluationOrder(graph, "store"), ["store"], "A leaf module should evaluate alone");
const cyclic = { a: ["b"], b: ["a", "c"], c: [] };
assertEqual(evaluationOrder(cyclic, "a"), ["c", "b", "a"], "A cycle should not loop forever, and each module appears once");
const diamond = { top: ["left", "right"], left: ["base"], right: ["base"], base: [] };
assertEqual(evaluationOrder(diamond, "top"), ["base", "left", "right", "top"], "A shared dependency should evaluate once");
--- hint
Walk the graph depth-first. Visit a module's dependencies first, and push the module's own name after them.
--- hint
Mark a module as visited before you recurse into its dependencies. That one line stops cycles, and it keeps a shared dependency from being pushed twice.
```

## Debugging a module that runs twice

The registry above caches on purpose. Here's a version that lost its cache, a common bug when someone "simplifies" a loader. The symptom is a setup function that runs twice and creates two copies of shared state.

```js debug id=module-cache title="A module that runs twice"
// Each module's factory must run at most once, however many times it is loaded.
function createRegistry() {
  const factories = new Map();
  return {
    define(name, factory) {
      factories.set(name, factory);
    },
    load(name) {
      const factory = factories.get(name);
      if (!factory) throw new Error(`Unknown module: ${name}`);
      const exports = {};
      factory(exports, (dep) => this.load(dep));
      return exports;
    },
  };
}
--- solution
function createRegistry() {
  const factories = new Map();
  const cache = new Map();
  return {
    define(name, factory) {
      factories.set(name, factory);
    },
    load(name) {
      if (cache.has(name)) return cache.get(name);
      const factory = factories.get(name);
      if (!factory) throw new Error(`Unknown module: ${name}`);
      const exports = {};
      cache.set(name, exports);
      factory(exports, (dep) => this.load(dep));
      return exports;
    },
  };
}
--- test
const reg = createRegistry();
let runs = 0;
reg.define("config", (exports) => {
  runs++;
  exports.debug = true;
});
const first = reg.load("config");
const second = reg.load("config");
assertEqual(runs, 1, "The factory should run once, however many times it is loaded");
assert(first === second, "Loading twice should return the same exports object");
assertEqual(first.debug, true, "The exports should still be populated");
reg.define("util", (exports, require) => {
  exports.cfg = require("config");
});
assert(reg.load("util").cfg === first, "Dependencies should share the cached exports");
assertEqual(runs, 1, "Requiring from another module should not run the factory again");
--- hint
Look at `load`. What should it check before it does any work?
--- hint
Add a `cache` Map. Return the cached exports when the name is already there, and store the new `exports` object in the cache before you call the factory, so cycles see the same object.
```

> **Pitfall:** Module-level state is per module instance. If your test runner reloads modules between tests (or your bundler duplicates a package), two copies of a "singleton" can exist side by side. Symptoms look like a store that updates but whose subscribers never fire.

## Exercise: a namespace that refuses writes

Real ES module namespace objects are frozen, and their exports are read through getters, which is what makes live bindings readable from outside. This exercise builds that shape yourself, and it combines the getter and freezing ideas from the immutability lesson.

```js exercise id=live-namespace title="A frozen namespace of getters"
function createNamespace(getters) {
  // TODO: return a frozen object with one property per key of `getters`.
  // Each property should be a getter that calls the matching function,
  // so every read sees the current value.
  return null;
}
--- solution
function createNamespace(getters) {
  const ns = {};
  for (const name of Object.keys(getters)) {
    Object.defineProperty(ns, name, { enumerable: true, get: getters[name] });
  }
  return Object.freeze(ns);
}
--- test
let count = 1;
const ns = createNamespace({ count: () => count, double: () => count * 2 });
assertEqual(ns.count, 1, "Reading a getter should return its current value");
count = 5;
assertEqual(ns.count, 5, "Getters should see later changes: live bindings");
assertEqual(ns.double, 10, "Derived getters should update too");
assert(Object.isFrozen(ns), "The namespace should be frozen");
assert(Reflect.set(ns, "count", 99) === false, "Writes to the namespace should be refused");
assertEqual(ns.count, 5, "The value should be unchanged after a refused write");
--- hint
`Object.defineProperty(obj, name, { enumerable: true, get: fn })` creates a getter. Use the function from `getters` as the getter, so it runs on every read.
--- hint
After you define every property, return `Object.freeze(ns)`. A frozen object refuses writes, and `Reflect.set` returns `false` instead of throwing.
```

## Predict: what a second require returns

```js predict id=predict-module-cache title="Evaluated once"
let evaluations = 0;
const cache = new Map();
function requireOnce(name, factory) {
  if (!cache.has(name)) {
    evaluations++;
    cache.set(name, factory());
  }
  return cache.get(name);
}
const a = requireOnce("db", () => ({ n: 1 }));
const b = requireOnce("db", () => ({ n: 2 }));
console.log(evaluations, b.n, a === b);
--- options
2 2 false
1 2 true
* 1 1 true
2 1 true
--- explain
The factory for `db` runs once, so `evaluations` is 1. The second call finds the cached object and returns the very same object as the first. That's why `b.n` is 1 and `a === b` is true, even though the second factory would have produced `n: 2`. The second factory is never called. This is the same rule that ESM and CommonJS apply: the first import evaluates the module, and every later import shares its exports.
```

## Dynamic loading in practice

Static imports are the right default, because they let bundlers and tools see the whole graph. Reach for dynamic `import()` when a piece of code is rarely needed: an admin panel, a heavy charting library, a locale file. The rule of thumb is to load on the first use and keep the cache, which is exactly the `loadOnce` pattern you just ran.

> **Tip:** Keep the module boundary where the cost is. If you dynamically import a small helper that's always used, you add a network round trip for no gain. Measure the bundle, then split.

## Recap

- Modules have their own scope, and the import graph is static, so every dependency is known before any body runs.
- A module body runs once. Later imports receive the same exports object, which is why singletons and shared state work.
- Imports are live bindings: a view onto the exporter's variable, which makes it read-only from the importing side.
- Cycles give partial exports. Don't read another module's values at load time.
- Dynamic `import()` is the same cache with a promise. It splits code at a boundary you choose.

**Up next:** testing, where you'll write assertions, group tests into suites and replace the expensive parts of your code with test doubles.
