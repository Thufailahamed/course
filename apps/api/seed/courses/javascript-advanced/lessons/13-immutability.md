Most bugs that look like "the value changed by itself" are not mysterious at all. Somewhere, two parts of your program hold the same array or object, and one of them changed it. A cart total shifts after you render it. A Redux-style reducer re-renders nothing because it returned the same reference. A sorted list breaks a binary search elsewhere. Immutability is the discipline of never changing a value in place, so that every reference you hold stays true for as long as you hold it.

In this lesson you'll learn exactly what JavaScript freezes (and what it doesn't), how to copy without accidentally sharing, and how to update deeply nested data while reusing everything that didn't change. That last technique, called structural sharing, is the reason modern state libraries can detect changes cheaply.

## Shared references are the root problem

Objects and arrays are stored by reference. Assigning one to a new name copies the reference, not the data, so both names point at the same thing:

```js run
const original = [1, 2, 3];
const alias = original;
alias.push(4);

console.log("original:", original);
console.log("same array?", alias === original);
```

Nothing was "copied" when you wrote `const alias = original`. Both names are windows onto one array. Every function that receives an array can change the caller's array in the same way, which is why a function that mutates its argument is a time bomb: it works in the test, and fails in the call site you forgot about.

> **Tip:** Immutability is a promise about your own code's habits, not a language feature you turn on. The rest of this lesson is about keeping that promise.

## `const` does not make a value immutable

`const` stops you from rebinding a name. It says nothing about the value the name holds:

```js run
const config = { theme: "dark" };
config.theme = "light";
console.log("theme is now:", config.theme);
// config = {}; // TypeError: Assignment to constant variable.
```

Reassigning `config` is an error. Editing `config.theme` is fine. Treat `const` as "this name always refers to the same object", and treat the object's contents as a separate question.

## `Object.freeze` is shallow

`Object.freeze(obj)` stops adding, removing and reassigning the object's own properties. It does not look inside. Nested objects remain fully mutable:

```js run
const user = Object.freeze({ name: "Ada", address: { city: "London" } });

console.log(Reflect.set(user, "name", "Grace"), user.name);
console.log(Reflect.set(user.address, "city", "Paris"), user.address.city);
console.log(Object.isFrozen(user), Object.isFrozen(user.address));
```

Two details matter here. First, `Reflect.set` returns `false` instead of throwing when a write is refused, so the output is the same in sloppy and strict mode. Plain assignment (`user.name = "Grace"`) is silently ignored in sloppy mode and throws a `TypeError` in strict mode, which is why code that depends on it behaves differently across files. Second, the nested `address` is still writable. Freezing is per object, one level at a time.

> **Pitfall:** `Object.freeze` is the most common "I made it immutable" mistake. A frozen object with a mutable nested object is shared mutable state with extra steps.

### Deep freeze

When you really need a value that can't change anywhere inside, freeze recursively. The idea is simple: freeze the object, then freeze each object-valued property.

```js exercise id=deep-freeze title="Freeze everything, recursively"
function deepFreeze(value) {
  // TODO: freeze `value` and every object or array nested inside it, then return it
  return null;
}
--- solution
function deepFreeze(value) {
  if (value !== null && typeof value === "object" && !Object.isFrozen(value)) {
    Object.freeze(value);
    for (const key of Object.keys(value)) deepFreeze(value[key]);
  }
  return value;
}
--- test
const data = deepFreeze({ a: { b: [1, { c: 2 }] } });
assert(Object.isFrozen(data), "The top-level object should be frozen");
assert(Object.isFrozen(data.a), "Nested objects should be frozen");
assert(Object.isFrozen(data.a.b), "Arrays inside objects should be frozen");
assert(Object.isFrozen(data.a.b[1]), "Objects inside arrays should be frozen");
const other = deepFreeze({ x: { y: { z: 1 } } });
assert(Object.isFrozen(other.x.y), "deepFreeze should work on new inputs too");
assert(deepFreeze(5) === 5, "Primitives should be returned unchanged");
--- hint
Walk the value with `Object.keys`, and recurse into every property whose value is an object.
--- hint
Only objects and arrays can be frozen, so check `value !== null && typeof value === "object"` first. Freezing before you recurse also stops infinite loops on circular structures.
```

Notice what makes this function reusable: it returns its input, so `deepFreeze({ ... })` can sit inside an expression. Also notice that it doesn't re-freeze objects that are already frozen, which keeps shared sub-objects from being walked twice.

## Copy first, then change the copy

The standard way to "change" an object is to create a new one that contains the changes. Spread syntax handles objects and arrays, and the ES2023 array methods give you non-mutating versions of the operations that used to mutate:

```js run
const nums = [3, 1, 2];

console.log(nums.toSorted(), nums);
console.log(nums.toReversed(), nums.with(0, 99), nums);
console.log(nums.toSpliced(1, 1), nums.toSorted((a, b) => a - b));
```

The original `nums` never changes. `sort`, `reverse`, `splice` and index assignment mutate; `toSorted`, `toReversed`, `toSpliced` and `with` return a new array. That's a quick way to audit a codebase: search for the mutating names on any value that other code can see.

Spread copies only one level deep, which is the same shallowness as `Object.freeze`:

```js run
const before = { user: { name: "Ada" }, count: 1 };
const after = { ...before, count: 2 };
after.user.name = "Grace";

console.log(before.count, before.user.name);
console.log(after.count, after === before);
```

The top-level `count` is independent, but `user` is the same object in both. Mutating `after.user` changed `before.user` too.

> **Under the hood:** A spread creates a new object whose own properties are copied as values. For a property holding an object, the value copied is the reference. That's why the nested object is shared.

## Structural sharing: update one branch, reuse the rest

Shallow copies are enough when you only touch one level. For a deep update, copy each object along the path to the change, and reuse every other branch as it is. The result is a new root, a handful of new intermediate objects, and everything else shared with the old version. Comparing two versions then becomes cheap: if a branch is the same reference, you know nothing under it changed.

```js exercise id=set-in-path title="Update a nested value without mutating"
function setIn(obj, path, value) {
  // TODO: return a NEW object where the value at `path` (an array of keys) is `value`.
  // Copy only the objects along the path. Every other branch should be shared.
  return null;
}
--- solution
function setIn(obj, path, value) {
  if (path.length === 0) return value;
  const [key, ...rest] = path;
  const copy = Array.isArray(obj) ? [...obj] : { ...obj };
  copy[key] = setIn(obj?.[key], rest, value);
  return copy;
}
--- test
const state = { user: { name: "Ada", tags: ["a"] }, ok: true };
const next = setIn(state, ["user", "name"], "Grace");
assertEqual(next, { user: { name: "Grace", tags: ["a"] }, ok: true }, "The new object should carry the update");
assert(state.user.name === "Ada", "The original object must not change");
assert(next !== state && next.user !== state.user, "Objects along the path should be new copies");
assert(next.user.tags === state.user.tags, "Untouched branches should be shared, not copied");
assertEqual(setIn({ items: [10, 20, 30] }, ["items", 1], 99), { items: [10, 99, 30] }, "Arrays along the path should update too");
assertEqual(setIn({}, ["a", "b"], 1), { a: { b: 1 } }, "Missing levels should be created");
--- hint
Split the path into its first key and the rest. The first key picks the child, and the rest of the path is handled by a smaller call to the same function.
--- hint
Make the copy before you assign to it: `const copy = Array.isArray(obj) ? [...obj] : { ...obj };`, then set `copy[key]` to the result of the recursive call.
```

Structural sharing is what makes React's `memo`, Redux selectors and many "did this change?" checks fast: they compare references, not contents. You'll see the same idea again in the reactive store capstone.

## `structuredClone` for deep copies

When you need a fully independent copy, `structuredClone` walks the whole value and duplicates every level:

```js run
const source = { when: "start", items: [1, { deep: true }] };
const copy = structuredClone(source);
copy.items[1].deep = false;

console.log(source.items[1].deep, copy.items[1].deep);
```

`structuredClone` handles nested objects, arrays, `Map`, `Set`, `Date` and cycles. It does not copy functions or class prototypes, and it throws on them, so it's a tool for plain data. Use it when you want a copy you can edit freely; use structural sharing when you want cheap updates and reference comparisons.

## Debugging a mutating function

The most common immutability bug is a helper that looks pure but changes its argument. Here's one. Run it in your head before you read the solution.

```js debug id=mutating-add title="The list that changed under everyone"
// Each call should return a NEW list with the todo added, leaving the input untouched.
function addTodo(list, todo) {
  list.push({ text: todo, done: false });
  return list;
}
--- solution
function addTodo(list, todo) {
  return [...list, { text: todo, done: false }];
}
--- test
const first = [];
const second = addTodo(first, "write tests");
const third = addTodo(second, "ship it");
assertEqual(first, [], "The original list must not change");
assertEqual(second.map((t) => t.text), ["write tests"], "The result should contain the new todo");
assertEqual(third.map((t) => t.text), ["write tests", "ship it"], "Chained calls should accumulate todos");
--- hint
`push` changes the array it's called on. Which array does this function call it on?
--- hint
Build the new array from the old one instead of changing the old one: spread `list` into a new array literal and append the new item.
```

The function returns a list that looks right, so the bug only shows up when someone still holds the old list. That's the signature of mutation bugs: they hide until two references meet.

## Predict: sorting is a mutation

Predict what this prints before you check the options.

```js predict id=predict-sort-mutates title="Who got sorted?"
const scores = [10, 9, 100];
const sorted = scores.sort();
console.log(sorted === scores, scores.join(","));
--- options
false 10,9,100
* true 10,100,9
true 9,10,100
false 100,10,9
--- explain
`sort()` sorts the array in place and returns that same array, so `sorted === scores` is `true`. It also compares elements as strings by default, so `"10"` comes before `"100"`, which comes before `"9"`. That's the default-sort pitfall: you need `(a, b) => a - b` for numbers. Use `toSorted` when you want a sorted copy and the original untouched.
```

> **In the wild:** Redux and other reducer-based stores rely on this rule. If a reducer mutates the old state and returns it, the store sees the same reference, decides nothing changed, and components don't re-render. The fix is always the same: return a new top-level object, and reuse the branches that didn't change.

## Recap

- Objects and arrays are shared by reference, so a mutation is visible through every alias.
- `const` fixes the binding, not the contents. `Object.freeze` is shallow; use a recursive freeze for deep immutability.
- Use non-mutating operations (`toSorted`, `toReversed`, `with`, spread) when you're handed data you don't own.
- Structural sharing copies only the objects along the changed path, which keeps updates cheap and makes reference checks meaningful.
- `structuredClone` gives you an independent deep copy of plain data.

**Up next:** Maps, Sets and weak references, the collections you reach for when objects are the keys.
