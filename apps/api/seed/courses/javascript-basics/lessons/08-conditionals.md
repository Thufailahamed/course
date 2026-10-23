A program that does the same thing every time is only a recipe. Real software branches: it shows a discount for members, rejects a password that is too short, sends a late order to a different warehouse. Conditionals are how your code chooses which path to take, and they are the foundation for every loop and function you will write.

This lesson covers `if`, `else if` and `else`, the compact ternary operator for choosing between two values, and `switch` for picking one of many cases. You will also meet the most common mistake with `switch`, which is forgetting a `break`, and learn to write conditions that read clearly when someone else reviews them.

## `if` and `else`

An `if` statement runs a block of code only when its condition is truthy. An `else` block runs when the condition is falsy:

```js run
const stock = 0;

if (stock > 0) {
  console.log("Available to order");
} else {
  console.log("Out of stock");
}
```

The condition goes inside parentheses, and the code it controls goes inside curly braces. Put each statement on its own line inside the braces, and indent it. Indentation does not change how JavaScript runs the code, but it is how humans see the structure.

## `else if` for several outcomes

When there are more than two outcomes, chain `else if` checks. JavaScript tests them from the top, and it runs the first block whose condition is true. Later conditions are never checked after a match:

```js run
const score = 83;
let grade;

if (score >= 90) {
  grade = "A";
} else if (score >= 80) {
  grade = "B";
} else if (score >= 70) {
  grade = "C";
} else {
  grade = "F";
}
console.log("Grade:", grade);
```

The order matters. Put the most specific or highest threshold first. If you had written `score >= 70` first, an 83 would match that branch and never reach the `B` check. Test your chain with a boundary value, such as exactly `80`, to be sure.

> **Pitfall:** Chains are checked in order, so a broad condition placed first hides every condition after it. When a chain looks wrong, test with values at each boundary, not just a typical one.

## The ternary operator

For a simple choice that produces one value, the ternary `condition ? a : b` is shorter than an `if` and `else`. It returns `a` when the condition is truthy, and `b` otherwise:

```js run
const age = 16;
const ticket = age >= 18 ? "adult" : "youth";
console.log("Ticket:", ticket);
console.log(`Pass: ${age < 5 ? "free" : "paid"}`);
```

Use the ternary when you are choosing a value. Use `if` when you are running several statements. Nested ternaries are hard to read, so reach for `if` once you need more than one level.

## `switch` for many exact values

When one value is compared against several fixed options, `switch` is clearer than a long chain. It compares the value to each `case` with strict equality `===`, and it runs from the matching case onward until it meets a `break`:

```js run
const day = "sat";
let kind;

switch (day) {
  case "sat":
  case "sun":
    kind = "weekend";
    break;
  case "mon":
    kind = "start of week";
    break;
  default:
    kind = "weekday";
}
console.log(day, "is a", kind);
```

Two cases, `"sat"` and `"sun"`, share one block because the first has no `break`, so it falls through to the second. That is a deliberate use. `default` runs when no case matches, and it works like a final `else`.

> **Pitfall:** Forgetting `break` is the most common `switch` bug. Without it, execution keeps going into the next case, and it runs that code too. Add `break` at the end of every case unless you intend the fall-through.

> **Tip:** Use `switch` when you compare one value against fixed constants. Use `if` when conditions are ranges, or when each check is different: `score >= 80` belongs in an `if`, not a `switch`.

## Writing readable conditions

Conditions read best when they name the idea behind them. Compare these two versions:

```js run
const minutesLate = 12;
const isOnTime = minutesLate <= 5;
if (isOnTime) {
  console.log("On time");
} else {
  console.log("Late by", minutesLate, "minutes");
}
```

Naming the boolean with `isOnTime` makes the `if` read like a sentence. This is the habit of a good reviewer: name the condition once, then use the name.

## Challenge: assign a letter grade

Use the same grade ranges shown above: 90 and up is `A`, 80 and up is `B`, 70 and up is `C`, and anything below that is `F`. Store the result in `letter`, for the score in `score`.

```js exercise id=grade-letter title="Assign a letter grade"
const score = 83;
// TODO: set letter to "A", "B", "C" or "F" using the ranges above
let letter = null;
--- solution
const score = 83;
let letter;
if (score >= 90) {
  letter = "A";
} else if (score >= 80) {
  letter = "B";
} else if (score >= 70) {
  letter = "C";
} else {
  letter = "F";
}
--- test
assertEqual(letter, "B", "An 83 should get a B");
--- hint
Chain `if` and `else if` checks from the highest range down. The first match wins.
--- hint
Start with `if (score >= 90)`, then use `else if` for `80`, `70`, and a final `else` for the rest.
```

## Challenge: a plan that falls through

A pricing function should charge 15 for `pro`, but the `team` price of 40 is also applied. The program prints the wrong total. Fix the `switch` so only the matching case runs.

```js debug id=fix-switch-break title="Stop the fall-through"
const plan = "pro";
let price = 0;
switch (plan) {
  case "basic":
    price = 5;
  case "pro":
    price = 15;
  case "team":
    price = 40;
    break;
  default:
    price = 0;
}
console.log(price);
--- solution
const plan = "pro";
let price = 0;
switch (plan) {
  case "basic":
    price = 5;
    break;
  case "pro":
    price = 15;
    break;
  case "team":
    price = 40;
    break;
  default:
    price = 0;
}
console.log(price);
--- test
assert(_stdout === "15", "The pro plan should cost 15, so the program should print 15");
--- hint
Execution falls from `case "pro"` into `case "team"`, because the first case has no `break`.
--- hint
Add `break;` after `price = 15;` so the switch stops at the matching case.
```

## Challenge: pick a shipping message

Use a `switch` on `shipping` to set `message`. The `"express"` option should say `Arrives tomorrow`, `"standard"` should say `Arrives in 3-5 days`, and anything else should say `Arrives in 2 weeks`.

```js exercise id=shipping-message title="Choose a shipping message"
const shipping = "express";
// TODO: use a switch on shipping to set message, with a default for unknown options
let message = null;
--- solution
const shipping = "express";
let message;
switch (shipping) {
  case "express":
    message = "Arrives tomorrow";
    break;
  case "standard":
    message = "Arrives in 3-5 days";
    break;
  default:
    message = "Arrives in 2 weeks";
}
--- test
assertEqual(message, "Arrives tomorrow", "express shipping should say: Arrives tomorrow");
--- hint
Write one `case` for each shipping option, then a `default` for the rest. Each case needs a `break`.
--- hint
A case looks like `case "express": message = "..."; break;`. Keep the text for each option exactly as given.
```

## Predict the output

Work out which cases run, including the ones that fall through without a `break`.

```js predict id=predict-switch-fallthrough title="Where the switch lands"
let out = "";
switch (2) {
  case 1: out += "one ";
  case 2: out += "two ";
  case 3: out += "three"; break;
  default: out += "other";
}
console.log(out);
--- options
two
one two three
* two three
other
--- explain
The value `2` matches `case 2`, so execution starts there and appends `"two "`. Because that case has no `break`, it falls through to `case 3`, which appends `"three"` and then breaks. The `case 1` block never runs, and `default` is skipped. The result is `two three`. The option `one two three` runs the earlier case, which does not match the value.
```

## Recap

- `if`, `else if` and `else` run the first block whose condition is truthy, checked from the top.
- The ternary `a ? b : c` chooses between two values in one expression.
- `switch` compares one value with `===` against fixed cases, and `default` catches the rest.
- A missing `break` makes execution fall through into the next case, which is usually a bug.
- Name conditions with booleans, such as `isOnTime`, so the code reads like a sentence.

**Up next:** loops, the way to repeat work with `while`, `for` and `for...of`.
