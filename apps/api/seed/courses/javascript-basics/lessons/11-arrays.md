Almost every real program works with lists: the items in a cart, the rows in a report, the messages in a chat, the scores of a class. An **array** is JavaScript's ordered list. It holds any number of values, keeps them in order, and lets you reach any one of them by its position. Arrays are the bridge between the single values you have used so far and the collections that real data is made of.

This lesson covers creating arrays, reading and changing their items by index, looping over them, and the trap that surprises almost everyone: two variables can point at the same array. Once you understand that, many puzzling bugs suddenly make sense.

## Creating an array

An array literal is a list of values in square brackets, separated by commas. The items can be of any type, and they can be mixed:

```js run
const fruits = ["apple", "pear", "fig"];
const readings = [21.5, 22.1, 19.8];
const mixed = ["ready", 3, true];
console.log(fruits.length, readings.length, mixed.length);
```

The `length` property counts the items. An empty array, written `[]`, has length `0`. Use `const` for an array when the variable should always point at the same list. As you will see below, `const` does not stop the contents from changing.

## Reading items by index

Each item has an **index**, starting at `0`. Read an item with square brackets, just as you read a character from a string:

```js run
const fruits = ["apple", "pear", "fig"];
console.log(fruits[0]);
console.log(fruits[2]);
console.log(fruits[fruits.length - 1]);
```

The last item is always at index `length - 1`. Asking for an index past the end gives `undefined`, not an error, so check the bounds when a position comes from user input:

```js run
const fruits = ["apple", "pear", "fig"];
console.log(fruits[10]);
console.log(fruits[10] === undefined);
```

> **Pitfall:** Forgetting that the first index is `0` causes off-by-one errors. `fruits[3]` on a three-item array is `undefined`, not the last item. The last index is always `length - 1`.

## Changing items

Arrays are mutable. Assign to an index to replace the item there:

```js run
const fruits = ["apple", "pear", "fig"];
fruits[1] = "kiwi";
console.log(fruits);
console.log(fruits.length);
```

The `const` on the declaration stops the variable from pointing at a different array. It does not stop `fruits[1] = "kiwi"` from changing the array the variable already holds. That is the same rule you saw with `const` in the variables lesson, and it applies to every array and object.

## Looping over an array

The `for...of` loop visits each item in order, which is the clearest way to go through a list when you do not need the index:

```js run
const temperatures = [21, 24, 19];
let hottest = temperatures[0];
for (const t of temperatures) {
  if (t > hottest) hottest = t;
}
console.log("hottest:", hottest);
```

When you need the index as well, use a `for` loop with a counter, and read `array[i]` inside it. That is how you pair each item with its position.

## Arrays are references

This is the most important idea in this lesson. An array variable does not hold the list itself. It holds a reference, which is a pointer to the one list in memory. Assigning an array to a new variable copies the pointer, not the items, so both names point at the same list:

```js run
const original = [1, 2];
const alias = original;
alias[2] = 3;
console.log(original);
console.log(original === alias);
```

Changing `alias` also changed `original`, because they are the same array. The `===` check is `true` for the same array and `false` for two separate arrays that happen to hold the same items.

> **Pitfall:** Passing an array to a function, storing it in another object or assigning it to another variable shares it, rather than copying it. Shared arrays cause bugs where one part of a program changes data that another part expects to be stable. Make a copy when you need an independent list.

> **Under the hood:** Arrays are objects with numbered keys. That is why `typeof []` returns `"object"`, and why `Array.isArray(value)` is the reliable check when you need to know whether something is a list.

## Challenge: swap the first and last

The scores array should have its first and last items swapped, so `[70, 85, 92, 64]` becomes `[64, 85, 92, 70]`. Change the array in place by writing to indexes. You will need a temporary variable to hold one value during the swap.

```js exercise id=swap-ends title="Swap the first and last scores"
const scores = [70, 85, 92, 64];
// TODO: swap scores[0] and scores[scores.length - 1] in place
--- solution
const scores = [70, 85, 92, 64];
const lastIndex = scores.length - 1;
const first = scores[0];
scores[0] = scores[lastIndex];
scores[lastIndex] = first;
--- test
assertEqual(scores, [64, 85, 92, 70], "The first and last scores should swap places");
assertEqual(scores.length, 4, "The array should still hold four scores");
--- hint
Copy the first item into a temporary variable before you overwrite it, otherwise the value is lost.
--- hint
Write the first item into a variable, move the last item to index `0`, then write the saved value into the last index.
```

## Challenge: copy a list before changing it

`original` is a shared list, and `copy` should be a separate array with the same items. Build `copy` as a new array, and then changing `copy` must leave `original` alone. A loop with `push` is one way to do it, and `push` is covered in the next lesson.

```js exercise id=copy-list title="Make an independent copy"
const original = ["a", "b"];
// TODO: make copy a new array holding the same items as original, not a reference to it
let copy = original;
--- solution
const original = ["a", "b"];
let copy = [];
for (const item of original) {
  copy.push(item);
}
--- test
assert(copy !== original, "copy should be a different array, not the same one");
assertEqual(copy, ["a", "b"], "copy should hold the same items as original");
copy[2] = "c";
assertEqual(original, ["a", "b"], "Changing copy must not change original");
--- hint
Assigning `original` to `copy` only copies the reference. You need a second array.
--- hint
Start with `let copy = [];` and loop over `original` with `for...of`, adding each item to `copy`.
```

## Challenge: fix the shared list

A program keeps a `base` list of two places, and a `pinned` list should start as a copy of it so that adding a pinned place does not change `base`. The code shares one array instead. Fix it so `base` still has two items at the end.

```js debug id=fix-shared-array title="Stop sharing one array"
const base = ["home", "work"];
const pinned = base;
pinned[2] = "gym";
console.log(base.length);
--- solution
const base = ["home", "work"];
const pinned = base.slice();
pinned[2] = "gym";
console.log(base.length);
--- test
assert(_stdout === "2", "base should still have two items, so the program should print 2");
--- hint
`const pinned = base;` copies the reference, so both names change together.
--- hint
Use `base.slice()`, which returns a new array with the same items. `slice` is covered in the next lesson.
```

## Predict the output

A reference is a shared pointer, so an assignment through one name shows up through the other. Decide what the last line prints.

```js predict id=predict-alias-write title="One list, two names"
const a = [1, 2];
const b = a;
b[0] = 9;
console.log(a[0]);
--- options
1
* 9
2
undefined
--- explain
`b` is not a copy of `a`. It is another name for the same array. Writing `b[0] = 9` replaces the first item of that shared array, so reading `a[0]` now gives `9`. The option `1` assumes the assignment copied the array, which is the mistake this lesson warns about. The option `2` confuses the value with the index, and `undefined` would appear only if the index were out of range.
```

## Recap

- An array is an ordered list created with square brackets, and `length` counts its items.
- Items are read and changed by index, starting at `0`, and the last index is `length - 1`.
- Out-of-range indexes return `undefined`, so check bounds when positions come from outside.
- `const` fixes the reference, not the contents, so `const` arrays can still change.
- Assigning an array copies the reference, so two names can change the same list. Copy when you need independence.

**Up next:** array methods such as `push`, `pop`, `slice`, `splice`, `includes` and `sort`, and the default sort rule that surprises almost everyone.
