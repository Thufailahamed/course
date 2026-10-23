Knowing how to read and change an array by index is the foundation, but most of the array work in real code is done by methods. A method adds an item to the end, removes the first one, cuts out a section, checks whether a value is present, or puts the list in order. Learn these few well and you will read and write list code fluently for the rest of your career.

This lesson covers the methods you will use most: `push`, `pop`, `shift` and `unshift` for adding and removing at the ends, `slice` and `splice` for taking pieces out, `includes` and `indexOf` for searching, and `sort`. The `sort` method has a rule that catches almost everyone, so it gets a section of its own.

## Adding and removing at the ends

`push` adds items to the end, and `pop` removes the last item and returns it. `unshift` and `shift` do the same work at the front. Each of these changes the array in place:

```js run
const queue = ["email"];
queue.push("report", "invoice");
console.log(queue);
console.log("removed:", queue.pop());
console.log("front:", queue.shift());
console.log(queue);
```

`push` returns the new length, and `pop` and `shift` return the item they removed. Those return values are useful when you need the removed item right away, as in a task queue, where each task is handled as it leaves the front.

> **Pitfall:** `shift` and `unshift` move every remaining item to a new index. That is fine for short lists, but a long queue that shifts constantly is slower than one that only pushes and pops at the end. Choose the end that matches your access pattern.

## Copying a piece with `slice`

`slice(start, end)` returns a new array with the items from `start` up to, but not including, `end`. It does not change the original, which makes it safe for taking a copy or a window of data:

```js run
const letters = ["a", "b", "c", "d"];
const middle = letters.slice(1, 3);
console.log(middle);
console.log(letters);
console.log(letters.slice(-2));
```

The end index is excluded, the same rule as with strings, and negative numbers count from the end. Calling `slice()` with no arguments returns a full copy of the array, which is the quickest way to protect an original list before you change a copy.

## Removing or replacing with `splice`

`splice(start, deleteCount, ...items)` changes the array itself. It removes `deleteCount` items starting at `start`, inserts any items you give it at that spot, and returns the removed items:

```js run
const letters = ["a", "b", "c", "d"];
const removed = letters.splice(1, 2, "X");
console.log("removed:", removed);
console.log("now:", letters);
```

`splice` is the mutating sibling of `slice`. Its name is easy to confuse with `slice`, so check which one you wrote. If you want the original to stay the same, use `slice`.

> **Tip:** Read the method name for its effect. `slice` slices a copy, and `splice` splices the original. Mixing them up is a common source of "my list changed when it shouldn't have" bugs.

## Searching with `includes` and `indexOf`

`includes(value)` answers the yes-or-no question: is this value in the array? `indexOf(value)` returns the position of the first match, or `-1` when there is none. Both use strict equality, so `"2"` and `2` are different:

```js run
const roles = ["admin", "editor", "viewer"];
console.log(roles.includes("editor"));
console.log(roles.indexOf("viewer"), roles.indexOf("guest"));
console.log([1, 2, 3].includes("2"));
```

Use `includes` when you only need to know whether something is present, since it reads more clearly. Use `indexOf` when you need the position to change or remove the item.

## Sorting, and the default rule

`sort` puts an array in order, and it changes the array in place. By default, it compares items as **strings**, not as numbers. That makes the result look wrong as soon as you sort numbers of different lengths:

```js run
console.log([10, 9, 100, 1].sort());
console.log(["pear", "Apple", "fig"].sort());
```

The default sort converts each item to text and compares the text character by character, so `"100"` comes before `"9"`. Uppercase letters also sort before lowercase, because their character codes are smaller.

To sort numbers, pass a comparison function that returns a negative number when the first item should come first, and a positive one when it should come later. For numbers, subtracting does this:

```js run
const sorted = [10, 9, 100, 1].sort((a, b) => a - b);
console.log(sorted);
```

The arrow syntax `(a, b) => a - b` is a function. You will learn it properly in the functions lessons, but for now you only need to know that the comparison's sign decides the order.

> **Pitfall:** `sort` changes the array you call it on. Calling `sort` on a list someone else owns reorders their data as a side effect. Copy first with `slice()` if the original order matters.

> **In the wild:** Developers who forget the comparison function ship bugs where ranks, prices or dates sort as text. The fix is one line, but the symptom can look like a database problem.

## Challenge: manage a task queue

A queue starts with `"email"` and `"report"`. Add `"invoice"` to the end, then remove the first task and store it in `nextTask`. At the end, `tasks` should hold `"report"` and `"invoice"`, and `nextTask` should be `"email"`.

```js exercise id=task-queue title="Manage a task queue"
const tasks = ["email", "report"];
// TODO: add "invoice" to the end of tasks, then remove the first task and store it in nextTask
let nextTask = null;
--- solution
const tasks = ["email", "report"];
tasks.push("invoice");
let nextTask = tasks.shift();
--- test
assertEqual(tasks, ["report", "invoice"], "tasks should hold report and invoice after the queue moves");
assertEqual(nextTask, "email", "nextTask should be the first task, email");
--- hint
`push` adds to the end, and `shift` removes the first item and returns it.
--- hint
Write `tasks.push("invoice");` and then `let nextTask = tasks.shift();`. The order matters: push first, then shift.
```

## Challenge: sort scores numerically

Sort the scores from smallest to largest, and store the sorted array in `ranked`. The default sort would put `100` before `9`, so pass a comparison function.

```js exercise id=sorted-scores title="Sort scores numerically"
const scores = [88, 9, 100, 45];
// TODO: sort scores from smallest to largest numerically, and store the result in ranked
let ranked = null;
--- solution
const scores = [88, 9, 100, 45];
let ranked = scores.sort((a, b) => a - b);
--- test
assertEqual(ranked, [9, 45, 88, 100], "The scores should sort numerically, not as text");
--- hint
Call `sort` with a function that takes two numbers and returns `a - b`.
--- hint
`let ranked = scores.sort((a, b) => a - b);` does the whole job, because `sort` returns the sorted array.
```

## Challenge: fix the text sort

This program should print the sizes in ascending numeric order as `1, 9, 10, 100`, but it sorts them as text. Fix the `sort` call.

```js debug id=fix-default-sort title="Sort numbers, not text"
const sizes = [10, 9, 100, 1];
sizes.sort();
console.log(sizes.join(", "));
--- solution
const sizes = [10, 9, 100, 1];
sizes.sort((a, b) => a - b);
console.log(sizes.join(", "));
--- test
assert(_stdout === "1, 9, 10, 100", "The sizes should print in numeric order: 1, 9, 10, 100");
--- hint
Without a comparison function, `sort` compares the text of each number, which puts `100` before `9`.
--- hint
Pass `(a, b) => a - b` to `sort` so it compares the numbers themselves.
```

## Predict the output

The default sort compares text, and the join output reveals the order it chose. Work out the sequence before you run it.

```js predict id=predict-default-sort title="Text order"
console.log([3, 20, 100].sort().join(" "));
--- options
3 20 100
* 100 20 3
3 100 20
100 3 20
--- explain
With no comparison function, `sort` converts each number to text and compares the text. The strings `"100"`, `"20"` and `"3"` compare character by character, and `"1"` comes before `"2"`, which comes before `"3"`. So the sorted order is `100`, `20`, `3`, and `join` prints `100 20 3`. The option `3 20 100` is the numeric order, which the default sort does not use.
```

## Recap

- `push` and `pop` work at the end, and `shift` and `unshift` work at the front; all four change the array.
- `slice` returns a new piece of an array and leaves the original alone, and `slice()` makes a full copy.
- `splice` changes the array in place, removing and inserting items at a position.
- `includes` answers yes or no, and `indexOf` returns the position or `-1`.
- `sort` changes the array and compares text by default, so pass `(a, b) => a - b` for numbers.

**Up next:** functions, the named, reusable blocks of code that take inputs, return values and make your programs easier to build and test.
