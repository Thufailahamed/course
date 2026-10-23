Plain objects are the default dictionary in JavaScript, and they're the wrong tool for a surprising number of jobs. Their keys are always strings (or symbols), so an object used as a key quietly becomes `"[object Object]"`. Numeric keys collide with their string forms. Inherited properties like `toString` show up in lookups. Maps and Sets fix these problems, and weak collections go one step further: they let the garbage collector reclaim entries whose keys nothing else uses.

By the end of this lesson you'll know when a Map beats an object, how equality works inside a Map or Set (it's not `===` exactly), and how to build caches that don't leak memory.

## Plain objects as dictionaries, and where they break

An object works fine when every key is a short string you control. Watch what happens when you use other kinds of keys:

```js run
const registry = {};
const userA = { id: 1 };
const userB = { id: 2 };
registry[userA] = "first";
registry[userB] = "second";

console.log(Object.keys(registry));
console.log(registry[{}]);
```

Both objects became the same key, because `String({ id: 1 })` and `String({ id: 2 })` are both `"[object Object]"`. The lookup with a brand-new `{}` found the last value written under that string. Nothing threw an error. The data just got quietly merged.

Compare a `Map`, which keeps each key as the exact value you gave it:

```js run
const byUser = new Map();
const userC = { id: 1 };
const userD = { id: 1 };
byUser.set(userC, "first").set(userD, "second");

console.log(byUser.size, byUser.get(userC), byUser.get({ id: 1 }));
```

Two objects that look identical are different keys, because a Map compares keys by identity. That's usually what you want for caches and registries keyed by entities.

> **Pitfall:** Objects inherit from `Object.prototype`. `"toString" in {}` is `true`, so a naive "has this word been seen?" check on an object will say yes for `"constructor"`. A `Map` has no inherited keys.

## How Maps and Sets compare keys: SameValueZero

Map and Set use an equality rule called SameValueZero. It's almost `===`, with two differences: `NaN` equals `NaN`, and `+0` equals `-0`. That makes lookups work for values that `===` gets wrong:

```js run
const special = new Map([[NaN, "not a number"], [0, "zero"]]);

console.log(special.get(NaN), special.get(-0), special.has(Number.NaN));
```

Plain `===` says `NaN !== NaN`, so you could never find a `NaN` key in an object or with `indexOf`. Map and Set make the value usable as a key anyway.

## Insertion order is part of the contract

Maps and Sets iterate in insertion order, and updating a key doesn't move it. That gives you a reliable order without sorting:

```js run
const scores = new Map();
scores.set("ada", 3).set("linus", 5).set("ada", 9);

console.log([...scores.keys()]);
console.log([...scores]);
```

`ada` stayed first even though its value changed. Deleting and re-adding a key moves it to the end. Object key order is more complicated (integer-like keys come first, in ascending order), which is one more reason to prefer a Map when order or non-string keys matter.

## Sets: membership and uniqueness

A Set stores each value once, and `has` is a constant-time check. That makes it the right tool for "have I seen this?" and for removing duplicates:

```js run
const tags = new Set(["js", "css", "js", "html"]);

console.log(tags.size, tags.has("css"), [...tags]);
tags.delete("css");
console.log(tags);
```

The second `"js"` was ignored. The same Set-based approach gives you the classic set operations, which you can express with spread and `filter`:

```js run
const left = new Set([1, 2, 3, 4]);
const right = new Set([3, 4, 5]);

const union = new Set([...left, ...right]);
const intersection = [...left].filter((x) => right.has(x));

console.log([...union], intersection);
```

> **Tip:** If you find yourself writing `array.includes(x)` inside a loop, you have an O(n²) algorithm. Build a Set once and call `has` in the loop instead. The change from `includes` to `has` is often the single biggest speedup in a data-processing function.

## Counting with a Map

Counting is a natural Map task, because the keys can be anything: strings, numbers, booleans or objects. Here's the pattern you'll use constantly.

```js exercise id=count-by title="Count by a key with a Map"
function countBy(items, keyOf) {
  // TODO: return a Map from each key (keyOf(item)) to how many items produced it.
  // Keys can be any value, so use a Map rather than a plain object.
  return null;
}
--- solution
function countBy(items, keyOf) {
  const counts = new Map();
  for (const item of items) {
    const key = keyOf(item);
    counts.set(key, (counts.get(key) ?? 0) + 1);
  }
  return counts;
}
--- test
const words = ["apple", "avocado", "banana", "blueberry", "cherry"];
const byLetter = countBy(words, (w) => w[0]);
assert(byLetter instanceof Map, "countBy should return a Map");
assertEqual([...byLetter], [["a", 2], ["b", 2], ["c", 1]], "Counts should follow first-seen key order");
const flags = countBy([true, false, true], (x) => x);
assertEqual(flags.get(true), 2, "Boolean keys should work too");
assertEqual(countBy([], (x) => x).size, 0, "No items should give an empty Map");
--- hint
Create a `new Map()`, loop over the items, and add 1 to the count stored under each key. `map.get(key)` returns `undefined` for a missing key, so give it a default with `??`.
--- hint
`counts.set(key, (counts.get(key) ?? 0) + 1)` is the whole update. Keep the loop and return the Map.
```

## Debugging: the object that merged two ids

Now the failure mode from the top of the lesson, in a realistic form. The function below is supposed to keep the first item for each id, and treat `1` and `"1"` as different ids. Read it carefully before you run it.

```js debug id=dedupe-by-id title="Ids that collide"
// Keep the first item for each id. Ids can be numbers or strings, and 1 and "1" are different ids.
function dedupeById(items) {
  const seen = {};
  const result = [];
  for (const item of items) {
    if (!seen[item.id]) {
      seen[item.id] = true;
      result.push(item);
    }
  }
  return result;
}
--- solution
function dedupeById(items) {
  const seen = new Set();
  const result = [];
  for (const item of items) {
    if (!seen.has(item.id)) {
      seen.add(item.id);
      result.push(item);
    }
  }
  return result;
}
--- test
const rows = [{ id: 1, n: "a" }, { id: "1", n: "b" }, { id: 1, n: "c" }, { id: 2, n: "d" }];
const kept = dedupeById(rows).map((r) => r.n);
assertEqual(kept, ["a", "b", "d"], "1 and '1' are different ids; only the repeated numeric 1 is dropped");
assertEqual(dedupeById([]), [], "An empty list should stay empty");
--- hint
A plain object converts every key to a string, so `1` and `"1"` land on the same property. Which collection keeps keys exactly as they are?
--- hint
Replace `seen` with a `Set`, and use `has` and `add` in place of bracket lookups.
```

The bug is a type coercion hidden inside a property lookup. Nothing crashes; a row just disappears. That's why tests with mixed key types are worth writing for any dedupe function.

## WeakMap and WeakSet: keys that don't keep the object alive

A Map holds its keys strongly. As long as the Map exists, every key object is reachable and cannot be garbage collected, even if nothing else in your program uses it. For a cache keyed by DOM nodes or user objects, that's a memory leak waiting to happen.

A `WeakMap` holds its keys weakly. It stores a value against an object without preventing that object from being collected. The trade-off is that a WeakMap has no `size`, no iteration and no `keys()`, because the contents can change at any moment as objects are collected.

```js run
const cache = new WeakMap();
const page = { url: "/home" };
cache.set(page, { views: 41 });

console.log(cache.has(page), cache.get(page).views, cache.has({ url: "/home" }));
```

WeakMap keys must be objects (or non-registered symbols), which is exactly the case where you want this behavior. A `WeakSet` works the same way for "have I processed this object?" checks.

The most common use is a memoization cache keyed by an object argument:

```js exercise id=weak-memo title="Cache per object without leaking"
function memoizeByObject(fn) {
  // TODO: return a function that calls fn(obj) once per distinct object,
  // and returns the cached result on later calls with that same object.
  // Use a WeakMap so cached entries can be collected with their keys.
  return null;
}
--- solution
function memoizeByObject(fn) {
  const cache = new WeakMap();
  return (obj) => {
    if (!cache.has(obj)) cache.set(obj, fn(obj));
    return cache.get(obj);
  };
}
--- test
let calls = 0;
const area = memoizeByObject((rect) => { calls++; return rect.w * rect.h; });
const box = { w: 3, h: 4 };
assertEqual(area(box), 12, "The first call should compute the value");
assertEqual(area(box), 12, "The second call should return the cached value");
assertEqual(calls, 1, "fn should run only once for the same object");
assertEqual(area({ w: 3, h: 4 }), 12, "An equal-looking object is a new key");
assertEqual(calls, 2, "A new object should trigger a new computation");
--- hint
Create the WeakMap once, outside the returned function, so every call shares it. Check `has` before you compute.
--- hint
Inside the returned function: if `cache` has no entry for `obj`, call `fn(obj)` and `set` the result. Then return `cache.get(obj)`.
```

> **Under the hood:** The cache entry lives as long as its key is reachable. When the rectangle object is garbage collected, its cached area goes with it. With a Map, you'd have to remember to call `delete` yourself, or the cache would grow forever.

## WeakRef: a reference that doesn't own the object

A `WeakRef` wraps an object without keeping it alive. You read the target with `deref()`, which returns the object while it still exists and `undefined` after it has been collected:

```js run
let session = { user: "ada" };
const ref = new WeakRef(session);

console.log(ref.deref() === session, ref.deref().user);
```

While `session` is still referenced by a variable, `deref()` returns it. Once nothing else holds the object, the engine is free to collect it, and `deref()` may then return `undefined`. You can't predict when that happens, so treat `WeakRef` as an optimization for caches and never as a way to decide program logic. A `FinalizationRegistry` lets you run cleanup code after an object is collected, with the same caveat: the timing is up to the engine, and the callback may never run at all.

> **Pitfall:** Never write logic that depends on when collection happens. Tests that pass locally and fail in CI are almost always a sign of code that assumed the garbage collector's timing.

## Predict: keys are compared by SameValueZero

```js predict id=predict-nan-key title="Set membership with special values"
const seen = new Set([NaN, NaN, 0, -0]);
console.log(seen.size, [...seen].join(" "));
--- options
4 NaN NaN 0 0
* 2 NaN 0
3 NaN 0 -0
2 NaN -0
--- explain
A Set keeps one copy of each value under SameValueZero. The two `NaN`s collapse into one because `NaN` equals `NaN` under this rule. The `0` and `-0` also collapse into one, and the stored value is `+0`, so the join prints `0`. The result is a size of 2 with the values `NaN` and `0`.
```

## Recap

- Plain objects coerce keys to strings, so object keys collide, and numbers and their string forms merge. Use a Map when keys aren't simple strings.
- Map and Set compare keys with SameValueZero: `NaN` equals `NaN`, and `+0` equals `-0`.
- Both keep insertion order, and updating a key doesn't move it.
- Set `has` is a constant-time membership check. Build a Set once instead of calling `includes` in a loop.
- WeakMap and WeakSet hold object keys weakly, which makes them the right choice for caches keyed by objects. They are not iterable on purpose.
- Never write logic that depends on when the garbage collector runs.

**Up next:** regular expressions, the pattern language you can learn to read rather than fear.
