Most of the time an object is just a bag of properties, and you read and write it directly. A proxy lets you stand in front of an object and decide what happens for each operation: a property read, a write, a `delete`, a check with `in`, a call. The object itself doesn't change. The language asks your handler first, and your handler decides whether to forward the operation, change it or refuse it.

That power is why proxies sit under some of the most popular libraries in the ecosystem. Vue 3's reactivity system tracks reads and writes with them, form libraries use them for validation, and Immer uses them to let you "mutate" a copy of your state. This lesson shows you how the handlers work, why `Reflect` exists as their companion, and the places where proxies surprise people, such as methods that stop working when they're called through one.

## The handler and its traps

`new Proxy(target, handler)` creates a proxy. The `handler` is an object whose methods are called **traps**. Each trap is named after an operation: `get` for reads, `set` for writes, `has` for `in`, `deleteProperty` for `delete`, `ownKeys` for `Object.keys` and friends, and `apply` and `construct` for functions. If a handler doesn't define a trap, the operation goes straight to the target.

```js run
function withDefaults(target, defaults) {
  return new Proxy(target, {
    get(obj, key, receiver) {
      if (Reflect.has(obj, key)) {
        return Reflect.get(obj, key, receiver);
      }
      return defaults[key] ?? "(missing)";
    },
  });
}

const settings = withDefaults({ theme: "dark" }, { theme: "light", fontSize: 14 });
console.log(settings.theme, settings.fontSize, settings.locale);
```

Reads of `theme` go to the real object, because it has that key. Reads of `fontSize` fall back to the defaults, and `locale` appears nowhere, so the trap returns a placeholder. The caller writes `settings.fontSize` exactly as if it were a plain property. Nothing about the call site reveals that a handler is involved.

## Validation on write

The `set` trap is the natural place for validation. It runs for every assignment to the proxy, so a single trap guards every property.

```js run
function strictNumbers(target) {
  return new Proxy(target, {
    set(obj, key, value) {
      if (typeof value !== "number") {
        throw new TypeError(`${String(key)} must be a number`);
      }
      return Reflect.set(obj, key, value);
    },
  });
}

const scores = strictNumbers({});
scores.math = 90;
try {
  scores.art = "A";
} catch (err) {
  console.log(err.name, err.message);
}
console.log(scores.math, scores.art);
```

The bad write throws before anything is stored, so `art` never exists. Throwing from a trap is one option. Returning `false` from a `set` trap is the other, and it's the one the language uses for a failed assignment: in strict mode it throws a `TypeError`, and in sloppy mode it fails silently.

> **Pitfall:** Keys can be symbols as well as strings. The `set` trap receives symbol keys for things like `Symbol.iterator`, so convert with `String(key)` when you build a message, and don't assume `key` is a string when you do arithmetic on it.

## Reflect: the default behavior, as functions

`Reflect` is a built-in object with one static function for each operation a trap can intercept. `Reflect.get(target, key, receiver)` does the default read, `Reflect.set` the default write, and so on. Each returns what the operation would have returned, and the important point is that they're written so that a trap can forward to the default in a single line. The `receiver` argument matters for getters and setters: it's the object the property was accessed on, which may be the proxy rather than the target.

A useful property of `Reflect` is that it returns a boolean instead of throwing for failed writes or deletes. You can test whether an operation succeeded without a `try` block.

```js run
const accessLog = [];
const observed = new Proxy(
  { x: 1 },
  {
    get(t, k, r) {
      accessLog.push("get " + String(k));
      return Reflect.get(t, k, r);
    },
    set(t, k, v, r) {
      accessLog.push("set " + String(k));
      return Reflect.set(t, k, v, r);
    },
    has(t, k) {
      accessLog.push("has " + String(k));
      return Reflect.has(t, k);
    },
    deleteProperty(t, k) {
      accessLog.push("delete " + String(k));
      return Reflect.deleteProperty(t, k);
    },
  },
);

observed.x;
observed.y = 2;
"y" in observed;
delete observed.y;
console.log(accessLog.join(" | "));
```

Each operation you perform on `observed` appears in the log, in order, and the object behaves exactly as it would without the proxy. That's the pattern behind logging middleware, change tracking and most debugging tools. The traps forward everything, so nothing breaks.

## Negative indexes, a real example

Arrays don't support `arr[-1]`. A proxy can add it by rewriting the key before forwarding the read. The check must stay cheap, because every property read on the array goes through the trap, including `length` and methods like `map`.

```js run
function fromEnd(array) {
  return new Proxy(array, {
    get(target, key, receiver) {
      if (typeof key === "string" && /^-\d+$/.test(key)) {
        key = String(target.length + Number(key));
      }
      return Reflect.get(target, key, receiver);
    },
  });
}

const letters = fromEnd(["a", "b", "c"]);
console.log(letters[-1], letters[0], letters.length);
```

`letters[-1]` becomes `letters["2"]` before the value is read. The string test matters: symbols are keys too, and calling `Number` on a symbol throws. Keep traps defensive about the types they receive.

## Challenge: a read-only view

A read-only view lets callers read an object but refuse every change. Build one with a proxy. Test the refusal through `Reflect`, which returns `false` instead of throwing, so the check doesn't depend on strict mode.

```js exercise id=read-only-view title="A read-only view"
function readOnly(obj) {
  // TODO: return a proxy that reads through to obj,
  // but refuses writes and deletes (so Reflect.set and Reflect.deleteProperty return false).
  return null;
}
--- solution
function readOnly(obj) {
  return new Proxy(obj, {
    set() {
      return false;
    },
    deleteProperty() {
      return false;
    },
    defineProperty() {
      return false;
    },
  });
}
--- test
const view = readOnly({ a: 1, nested: { b: 2 } });
assertEqual(view.a, 1, "Reads should pass through to the original object");
assertEqual(Reflect.set(view, "a", 99), false, "Writes must be refused");
assertEqual(view.a, 1, "A refused write should not change the value");
assertEqual(Reflect.deleteProperty(view, "a"), false, "Deletes must be refused");
assertEqual(view.a, 1, "A refused delete should leave the property in place");
assertEqual(view.nested.b, 2, "Nested objects are read through the view as plain objects");
--- hint
A `set` trap that returns `false` refuses the write. Do the same for `deleteProperty`. The other traps can pass through by default.
--- hint
Create the proxy with a handler that has `set`, `deleteProperty` and `defineProperty` methods, each returning `false`.
```

## Challenge: watch for changes

Build a proxy that calls a listener every time a property is set. This is the core of a reactive store, which you'll build for real in the capstone. The listener receives the key and the value that was stored.

```js exercise id=watch-changes title="Watch for changes"
function watch(obj, onChange) {
  // TODO: return a proxy over obj. After each successful set, call onChange(key, value).
  return null;
}
--- solution
function watch(obj, onChange) {
  return new Proxy(obj, {
    set(target, key, value) {
      const ok = Reflect.set(target, key, value);
      if (ok) {
        onChange(key, value);
      }
      return ok;
    },
  });
}
--- test
const changes = [];
const state = watch({ count: 0 }, (key, value) => changes.push([key, value]));
state.count = 1;
state.count += 2;
state.label = "x";
assertEqual(changes, [["count", 1], ["count", 3], ["label", "x"]], "Every set should notify the listener with the stored value");
assertEqual(state.count, 3, "The stored value should be the last one written");
--- hint
Your `set` trap must store the value, and it can then call the listener. Make sure the trap returns the success flag, so assignment still behaves normally.
--- hint
`Reflect.set(target, key, value)` stores the value and returns a boolean. Call `onChange` only when that boolean is `true`.
```

## Debug: methods that refuse the proxy

This wraps a `Map` so that you can use it normally, but calls to `set` throw an error that says the receiver is incompatible. The methods of built-in collections expect the real `Map`, not the proxy in front of it. Fix the `get` trap so methods run against the target.

```js debug id=map-proxy-methods title="Bind methods to the target"
function observableMap() {
  return new Proxy(new Map(), {
    get(target, key) {
      return Reflect.get(target, key);
    },
  });
}
--- solution
function observableMap() {
  return new Proxy(new Map(), {
    get(target, key) {
      const value = Reflect.get(target, key);
      return typeof value === "function" ? value.bind(target) : value;
    },
  });
}
--- test
const m = observableMap();
m.set("a", 1);
m.set("b", 2);
assertEqual(m.get("a"), 1, "get should read from the underlying map");
assertEqual(m.size, 2, "size should count the stored entries");
assertEqual(m.has("b"), true, "has should see the stored keys");
--- hint
Run it and read the error. It says a `Map` method was called on a receiver that isn't a `Map`. The proxy is that receiver.
--- hint
In the `get` trap, check whether the value you read is a function. If it is, return a version bound to `target` instead of the raw function.
```

## Predict: the trap order

Each trap call is recorded in order. Watch carefully how the assignment `p.a = p.a + 1` is evaluated, because the right-hand side runs before the write.

```js predict id=predict-proxy-trace title="Predict the trap calls"
const seen = [];
const p = new Proxy({ a: 1 }, {
  get(target, key) {
    seen.push("get:" + key);
    return target[key];
  },
  set(target, key, value) {
    seen.push("set:" + key);
    target[key] = value;
    return true;
  },
});
p.a = p.a + 1;
p.b = 5;
console.log(seen.join(" "));
--- options
* get:a set:a set:b
set:a get:a set:b
get:a set:a
get:a set:a set:b get:b
--- explain
The left side of `p.a = ...` identifies the property but doesn't read it. The right side, `p.a + 1`, runs first, so the `get` trap fires for `a`. The result is then written, which fires the `set` trap for `a`. Then `p.b = 5` fires `set` for `b`. There's no `get` for `b`, because the assignment never reads it. The option `set:a get:a set:b` assumes the write happens before the read, which is backwards.
```

## Recap

- A proxy wraps a target and runs a handler's traps for each operation on it. Undefined traps fall through to the target.
- Use the `set` trap to validate writes, and return `false` to refuse them. Use `get` for defaults, computed properties or key rewriting.
- `Reflect` provides each default operation as a function, returns booleans for failed writes and deletes, and lets a trap forward cleanly with the right receiver.
- Built-in methods such as `Map.prototype.set` check their receiver, so calls through a proxy need the method bound to the target.
- Proxies add a cost to every operation they intercept, and private `#fields` aren't reachable through a proxy at all, so use them where the interception earns its keep.

**Up next:** promises, the object that represents a value that isn't ready yet, and the states, chaining and error rules that let you compose asynchronous work.
