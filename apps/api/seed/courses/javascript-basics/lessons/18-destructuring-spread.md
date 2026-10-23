Pull three fields out of an object and you'll write three lines that look almost the same. Copy a list, add one item, and you'll write a clumsy sequence of `push` and `slice` calls. Pass a function a bag of options and you'll dig through it one property at a time. JavaScript has a compact syntax for all three jobs: destructuring, spread and rest. They're the same three dots and brackets you'll see in nearly every modern codebase, so it's worth learning them well.

By the end of this page you'll unpack values from arrays and objects in a single line, copy and merge them without mutating the originals, and collect any number of arguments into a list.

## Object destructuring

Destructuring lets you write the names you want on the left side of `=`, and JavaScript pulls the matching properties out of the object on the right:

```js run
const person = { name: "Ada", age: 36, city: "Leeds" };

const { name, age } = person;
console.log(name, age);
```

This is the same as writing `const name = person.name;` and `const age = person.age;`, but in one statement. The variable names must match the property names unless you rename them:

```js run
const user = { name: "Grace", role: "admin" };

const { name: userName, role = "guest", email = "none" } = user;
console.log(userName, role, email);
```

`name: userName` reads the `name` property and stores it in `userName`. `role = "guest"` gives a default that is used only when the property is missing or `undefined`, so `role` is `"admin"` here, and `email` gets its default `"none"`.

> **Tip:** Destructuring is the cleanest way to read the fields you need from a function's argument. Write `function show({ name, age })` in the parameter list, and the function receives those two values directly.

## Array destructuring

Arrays use square brackets on the left side. Position decides which value goes where. Skip a value with an empty slot, and collect the rest with `...`:

```js run
const colors = ["red", "green", "blue", "gold"];

const [first, second] = colors;
const [, , third] = colors;
const [head, ...others] = colors;

console.log(first, second, third);
console.log(head, others);
```

The `...others` on the left is a **rest** element: it gathers everything that's left into a new array. The rest element must come last. The same trick swaps two variables without a temporary one:

```js run
let left = 1;
let right = 2;
[left, right] = [right, left];

console.log(left, right);
```

Remember the rule for arrays and objects: destructuring creates new variables that hold the values. It doesn't create a copy of an object you pull values out of, so the usual sharing rules still apply to nested objects.

Now try it on a real problem. Write a function that splits a list into its first item and the rest:

```js exercise id=head-and-tail title="Split a list into head and tail"
function headAndTail(list) {
  // TODO: return { head, tail }, where head is the first item and tail is an array of the others
  // For an empty list, head is undefined and tail is []
  return null;
}
--- solution
function headAndTail(list) {
  const [head, ...tail] = list;
  return { head: head, tail: tail };
}
--- test
assertEqual(headAndTail([1, 2, 3]), { head: 1, tail: [2, 3] }, "Head is the first item; tail holds the rest");
assertEqual(headAndTail(["solo"]), { head: "solo", tail: [] }, "A one-item list has an empty tail");
assertEqual(headAndTail([]), { head: undefined, tail: [] }, "An empty list has no head and an empty tail");
--- hint
Destructure the list with a pattern like `[head, ...tail]`. The `...` collects everything after the first item.
--- hint
Declare `const [head, ...tail] = list;` and return an object whose properties are `head` and `tail`.
```

## Spread: copying and combining

Where a rest element gathers values into an array, spread does the reverse. Written as `...list` inside an array literal, it puts every item of `list` in place. That makes copying and combining simple:

```js run
const weekdays = ["mon", "tue", "wed"];
const week = [...weekdays, "thu", "fri"];
const copyOfDays = [...weekdays];

console.log(week);
console.log(copyOfDays === weekdays);
```

`copyOfDays` is a new array with the same items. The comparison prints `false`, because they are two separate arrays. This is the copy that `slice()` made in an earlier lesson, written in a more readable form.

Spread works on objects too. Inside an object literal, `...obj` copies in every property. Properties written after the spread override the copied values, which is how you update one field without touching the others:

```js run
const settings = { theme: "light", fontSize: 14, showGrid: true };
const darkSettings = { ...settings, theme: "dark" };

console.log(settings.theme, darkSettings.theme);
console.log(darkSettings.fontSize);
```

This is the modern replacement for `Object.assign({}, ...)` from the objects lesson. The original `settings` never changes, so you can keep the old state around if you need it.

Here's the challenge for this idea. Write a function that merges a set of user settings over a set of defaults. The user's values must win, and neither input may be changed:

```js exercise id=merge-settings title="Merge settings over defaults"
function mergeSettings(defaults, overrides) {
  // TODO: return a new object with every default, where overrides replace any matching keys
  return null;
}
--- solution
function mergeSettings(defaults, overrides) {
  return { ...defaults, ...overrides };
}
--- test
const defaults = { theme: "light", fontSize: 14 };
const overrides = { fontSize: 18 };
assertEqual(mergeSettings(defaults, overrides), { theme: "light", fontSize: 18 }, "Overrides should replace matching keys and keep the rest");
assertEqual(defaults, { theme: "light", fontSize: 14 }, "The defaults object must not be changed");
assertEqual(mergeSettings({ a: 1 }, {}), { a: 1 }, "No overrides should give back the defaults");
assertEqual(mergeSettings({}, { b: 2 }), { b: 2 }, "Overrides can add new keys");
--- hint
Spread both objects into a new object literal: `{ ...defaults, ...overrides }`.
--- hint
Order matters. The object spread last wins when two objects share a key, so put `overrides` after `defaults`.
```

> **Pitfall:** Spread copies only one level deep. The new object gets the same nested objects and arrays as the original, not copies of them. If you change a nested value through the copy, you change it in the original too. For nested data, copy each level you plan to change, or use the deep-copy techniques you'll see in the JSON lesson.

## Rest parameters

When you write `...` in a function's parameter list, you collect any number of arguments into an array. That's a rest parameter, and it's the mirror image of spreading an array into a call:

```js run
function sumAll(...numbers) {
  return numbers.reduce((total, n) => total + n, 0);
}

console.log(sumAll(1, 2, 3));
console.log(sumAll(10));
console.log(sumAll());

const values = [4, 5, 6];
console.log(sumAll(...values));
```

Inside `sumAll`, `numbers` is a real array, so every array method works. Calling `sumAll(...values)` spreads the array back out into separate arguments.

Next, a debug challenge. This function should return the first two items of an array, but it returns `[undefined, undefined]`:

```js debug id=first-two title="Destructure the array, not an object"
function firstTwo(pair) {
  const { first, second } = pair;
  return [first, second];
}
--- solution
function firstTwo(pair) {
  const [first, second] = pair;
  return [first, second];
}
--- test
assertEqual(firstTwo(["a", "b"]), ["a", "b"], "firstTwo should return the first two items");
assertEqual(firstTwo([1, 2, 3]), [1, 2], "Extra items should be ignored");
--- hint
The `{ }` brackets on the left mean you're reading properties by name. Arrays don't have properties called `first` or `second`.
--- hint
Use `[` and `]` on the left side instead, so the values are taken by position.
```

Fix it so the function returns the first two items. Then work out what the next prediction prints before you check it:

```js predict id=skip-and-defaults title="What do these lines print?"
const [a, , c] = [1, 2, 3];
const { x = 5, y = 7 } = { x: undefined, y: null };
console.log(a, c, x, y);
--- options
1 2 5 7
1 3 undefined null
* 1 3 5 null
1 3 5 7
--- explain
The empty slot in `[a, , c]` skips `2`, so `a` is `1` and `c` is `3`. In the object, `x` is `undefined`, so its default `5` applies. But `y` is `null`, which is a real value, so the default `7` is not used and `y` is `null`. Defaults only replace `undefined`.
```

> **Under the hood:** Destructuring reads values by calling the same property lookups you'd write yourself, and it works on anything that is iterable for arrays. Spread and rest use the same iteration protocol, which is why `[...text]` splits a string into characters.

> **In the wild:** React components and functions in most libraries take one options object, such as `render({ width, height, color })`. Destructuring in the parameter list is how those functions read their options, and spread is how wrappers pass options through unchanged.

## Recap

- Object destructuring, `const { name, age } = person`, pulls out properties by name. Rename with `key: newName` and add defaults with `key = value`.
- Array destructuring, `const [a, , c] = list`, takes values by position. A `...rest` element gathers the remaining items.
- Spread, `[...list]` or `{ ...obj }`, copies and combines arrays and objects. Later keys override earlier ones.
- Spread copies only one level, so nested objects are still shared between the copy and the original.
- Rest parameters, `function f(...args)`, collect every argument into a real array.

**Up next:** Classes: a blueprint for creating many objects that share the same properties and methods.
