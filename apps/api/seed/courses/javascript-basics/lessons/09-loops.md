Computers are good at one thing humans find tedious: doing the same step thousands of times without getting bored or sloppy. A loop lets your code repeat a block of work until a condition says stop. It can total a month of transactions, check each character in a password, retry a failed request, or animate a frame of a game.

Loops are also where many bugs live. A loop that stops one step too early, or never stops at all, is among the most common mistakes in any language. In this lesson you will learn the three loop forms, when each one fits, how to control a loop with `break` and `continue`, and how to spot the two classic failures: the off-by-one error and the infinite loop.

## `while`: repeat while a condition holds

A `while` loop checks its condition before every pass. While the condition is truthy, the block runs. As soon as it is falsy, the loop ends:

```js run
let n = 3;
while (n > 0) {
  console.log(n);
  n--;
}
console.log("Liftoff");
```

`n--` subtracts one from `n`. It is a shorthand for `n = n - 1`, and `n++` adds one. Those two operators are how most counting loops move forward, and forgetting them is how loops become infinite.

> **Pitfall:** If the condition never becomes false, the loop never ends, and your page or script freezes. Always ask: what changes on each pass to move toward the stop condition?

## `for`: a loop with its own counter

When you know how many times to repeat, the `for` loop keeps the setup in one line. It has three parts separated by semicolons: start, condition and update. The start runs once, the condition is checked before each pass, and the update runs after each pass:

```js run
for (let i = 1; i <= 5; i++) {
  console.log(i, "squared is", i * i);
}
```

The `let i` declares the counter for this loop only, so it does not leak out to the rest of the program. That keeps loops from clashing with each other. Read the header as a sentence: start at 1, keep going while `i` is at most 5, and add one each time.

## `for...of`: visit each item

When you want every item in a sequence rather than a count, `for...of` is the clearest choice. Strings are sequences of characters, so you can use it on text now. You will use the same form constantly on arrays in the next lessons:

```js run
for (const letter of "JS!") {
  console.log("Character:", letter);
}
```

`const` works here because each loop pass creates a fresh `letter` and never reassigns it. Use `let` only if you actually change the variable inside the loop.

> **Tip:** Prefer `for...of` when you want the items, and `for` with a counter when you need the index, or when you must step by something other than one.

## `break` and `continue`

Two statements control a loop from inside. `break` stops the loop entirely. `continue` skips the rest of the current pass and moves to the next one:

```js run
for (let i = 1; i <= 10; i++) {
  if (i % 2 === 0) continue;
  if (i > 7) break;
  console.log("odd:", i);
}
```

This loop prints odd numbers up to 7. The even numbers are skipped by `continue`, and the loop ends at `break` once `i` passes 7. Notice that the `if` checks come before any output, so each pass decides early what to do.

## Off-by-one errors

The most common loop bug is running one time too few or too many. It usually comes from mixing up `<` and `<=`, or from starting at `0` when you meant `1`. Counting from zero is normal in JavaScript, and the counter should match the job:

```js run
let fromZero = 0;
for (let i = 0; i < 3; i++) fromZero++;
let fromOne = 0;
for (let i = 1; i <= 3; i++) fromOne++;
console.log("zero-based:", fromZero, "one-based:", fromOne);
```

Both loops run three times, and both are correct. The difference is that `i < 3` starts at zero, while `i <= 3` starts at one. Choose the pair that matches the range you need, and then check the first and last pass by hand.

> **Pitfall:** Do not use `for...in` to loop over arrays or strings. It visits property names, which are strings like `"0"`, and it can include inherited properties. Use `for...of` for values.

> **Under the hood:** A `for` loop's `let i` gets a new binding on each pass, so closures created inside the loop capture that pass's value. You do not need that detail yet, but it explains why loop variables behave well with callbacks.

## Challenge: add up one to n

Use a `for` loop to add the numbers from 1 to `n` inclusive, and store the result in `total`. With `n` set to `10`, the total should be `55`.

```js exercise id=sum-to-n title="Add the numbers from 1 to n"
const n = 10;
// TODO: use a for loop to add every whole number from 1 to n, and store the sum in total
let total = null;
--- solution
const n = 10;
let total = 0;
for (let i = 1; i <= n; i++) {
  total += i;
}
--- test
assertEqual(total, 55, "The sum of 1 to 10 should be 55");
--- hint
Start `total` at `0`, then add the counter to it on every pass.
--- hint
Use `for (let i = 1; i <= n; i++)` and write `total += i;` inside the braces. The `<=` makes the loop include `n`.
```

## Challenge: build a countdown

Build the string `"5 4 3 2 1"` in `countdown` from the value of `start`, counting down with a loop. Separate the numbers with single spaces, and do not add a trailing space.

```js exercise id=countdown-string title="Build a countdown string"
const start = 5;
// TODO: build "5 4 3 2 1" in countdown, using a loop that counts down from start to 1
let countdown = null;
--- solution
const start = 5;
let countdown = "";
for (let i = start; i >= 1; i--) {
  countdown += i;
  if (i > 1) countdown += " ";
}
--- test
assertEqual(countdown, "5 4 3 2 1", "countdown should read: 5 4 3 2 1");
--- hint
Start the counter at `start` and decrease it with `i--` until it reaches `1`. Start `countdown` as an empty string.
--- hint
Add a space after each number except the last. Test `if (i > 1)` before you add the space.
```

## Challenge: fix the loop bound

This loop should add the numbers 1 to 5 and print `15`, but it prints `10`. Fix the off-by-one error so the loop includes 5.

```js debug id=fix-loop-bound title="Include the last number"
let total = 0;
for (let i = 1; i < 5; i++) {
  total += i;
}
console.log(total);
--- solution
let total = 0;
for (let i = 1; i <= 5; i++) {
  total += i;
}
console.log(total);
--- test
assert(_stdout === "15", "The sum of 1 to 5 should print 15");
--- hint
The loop stops as soon as `i` is no longer less than 5, so 5 is never added. Which comparison includes 5?
--- hint
Change `i < 5` to `i <= 5` in the loop header.
```

## Predict the output

`continue` skips the rest of a pass, so watch which numbers reach the output.

```js predict id=predict-continue-skip title="Skip the multiples of three"
let out = "";
for (let i = 1; i <= 6; i++) {
  if (i % 3 === 0) continue;
  out += i;
}
console.log(out);
--- options
123456
1236
* 1245
1 2 4 5
--- explain
The loop runs for `i` from 1 to 6. When `i` is 3 or 6, `i % 3` is `0`, so `continue` skips the `out += i` line for those passes. The numbers 1, 2, 4 and 5 are added to the text with no spaces, giving `1245`. The option `1 2 4 5` would need a space to be added, which the code never does. The option `123456` forgets that `continue` skipped two values.
```

## Recap

- `while` repeats while its condition is true; `for` packs the start, test and update into one header.
- `for...of` visits every item in a sequence, and strings count as sequences of characters.
- `break` ends a loop, and `continue` skips to the next pass.
- Off-by-one errors come from `<` versus `<=` and from where you start counting.
- An infinite loop happens when nothing moves the loop toward its stop condition.

**Up next:** loop patterns, where you accumulate totals, search for a match and count the things that pass a test.
