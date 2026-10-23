A program that cannot remember anything is a calculator with no memory. Variables give a value a name, so you can use it several times, change it when the world changes, and read the code later without decoding numbers. A shopping cart keeps a running total, a login form keeps the user's name, a game keeps a score. Each of those is a variable.

In this lesson you will learn the two keywords for declaring variables, `let` and `const`, when to use each, and the rules for naming them. You will also meet the trap that catches almost every beginner: a `const` that is not as constant as it looks.

## Declaring with `let`

A declaration creates a variable. Write the keyword, the name, an equals sign and the starting value:

```js run
let score = 10;
console.log("Score:", score);

score = score + 5;
console.log("After a bonus:", score);
```

The first line creates `score` and stores `10` in it. The second line does not create anything new. The `=` there means "store this value in the existing variable", so `score` now holds `15`. Reassigning a `let` variable is allowed as often as you need.

Read `=` as "becomes", not as "equals". The expression on the right is calculated first, and the result is stored in the name on the left. That is why `score = score + 5` makes sense even though it could never be true as maths.

## Declaring with `const`

`const` declares a variable that cannot be reassigned. It is short for *constant*:

```js run
const taxRate = 0.2;
console.log("Tax rate:", taxRate);

const label = "Total";
console.log(label, "is ready");
```

Use `const` when the name should keep pointing to the same value for its whole life. A tax rate, a list of product codes and a configuration setting usually fall into this group. Trying to reassign a `const` raises an error, which is exactly the point: the mistake shows up immediately rather than somewhere later.

> **Tip:** Start with `const` for every declaration. When you find you truly need to change the value, switch that one to `let`. Most of the variables in well-written code are `const`, and the code is easier to reason about because of it.

## Naming variables

A name must start with a letter, `_` or `$`. After that it can include digits. You cannot use spaces or hyphens, and you cannot use a reserved word such as `let`, `const`, `class` or `return`.

JavaScript developers write names in **camelCase**: the first word is lowercase and each later word starts with a capital letter. A name like `monthlyRent` says what the value is, and `r` says nothing. Names are case-sensitive, so `total` and `Total` are two separate variables.

```js run
const monthlyRent = 1200;
const utilityBill = 85;
const totalBills = monthlyRent + utilityBill;
console.log("Total bills:", totalBills);
```

## Checking a variable's type

Every value has a type. The `typeof` operator tells you which one:

```js run
let count = 42;
let price = 9.99;
let name = "Ada";
let isOpen = true;
console.log(typeof count, typeof price, typeof name, typeof isOpen);
```

Integers and decimals share one type, `number`, which is a useful surprise. You will learn more about numbers in the next lessons.

## Using a variable before it exists

A variable is only usable after its declaration line has run. Using it earlier fails, and the error message has an official name for the period in between: the *temporal dead zone*.

```js run
try {
  console.log(later);
  let later = 1;
} catch (error) {
  console.log(error.name + ": " + error.message);
}
```

> **Under the hood:** `let` and `const` are created when their block starts, but they stay unusable until the declaration line runs. The engine knows the name exists and refuses to read it early. Older code used `var`, which behaves differently and quietly returns `undefined` instead of failing. Avoid `var` in new code.

## Challenge: track a cart total

Use `let` to build a cart total from three item prices. The starter sets `cartTotal` to `null` on purpose, so the tests fail until you calculate it.

```js exercise id=cart-total title="Build a cart total with let"
const coffee = 3.5;
const bagel = 4.25;
const juice = 4.5;
// TODO: start a `let` variable at 0, add the three prices, and store the result in cartTotal
let cartTotal = null;
--- solution
const coffee = 3.5;
const bagel = 4.25;
const juice = 4.5;
let cartTotal = 0;
cartTotal = cartTotal + coffee;
cartTotal = cartTotal + bagel;
cartTotal = cartTotal + juice;
--- test
assertEqual(cartTotal, 12.25, "cartTotal should be 12.25, the sum of the three prices");
assert(typeof cartTotal === "number", "cartTotal should be a number");
--- hint
You need a variable that changes as you add each price, so it must be declared with `let`.
--- hint
Start `cartTotal` at `0`, then write one line per price that reassigns it to `cartTotal + price`.
```

## Challenge: fix the reassignment

This program should print a score of 15, but it crashes at the reassignment. Fix the declaration so the bonus can be added.

```js debug id=fix-const-reassign title="Make the score change"
{
  const score = 10;
  score = score + 5;
  console.log("Score:", score);
}
--- solution
{
  let score = 10;
  score = score + 5;
  console.log("Score:", score);
}
--- test
assert(_stdout === "Score: 15", "The program should print: Score: 15");
--- hint
Read the error: it says you tried to assign to a constant variable. Which keyword allows reassignment?
--- hint
Change `const` to `let` on the first line inside the braces. The reassignment and the `console.log` can stay exactly as they are.
```

## Challenge: a shopping list that grows

A `const` binding cannot point at a new array, but the array it points at can still change. Create a `const` array named `groceries` that starts with the two items below, add a third item with `push`, and store the item count in `itemCount`.

```js exercise id=grocery-list title="Grow a const array"
// TODO: create `groceries` with const and an array, then add "bread" with push
const groceries = null;
let itemCount = null;
--- solution
const groceries = ["milk", "eggs"];
groceries.push("bread");
let itemCount = groceries.length;
--- test
assertEqual(groceries, ["milk", "eggs", "bread"], "groceries should hold milk, eggs and bread in that order");
assertEqual(itemCount, 3, "itemCount should be 3");
--- hint
An array has a `push` method that adds an item to its end. Calling it does not reassign the variable.
--- hint
Write `const groceries = ["milk", "eggs"];`, then `groceries.push("bread");`, then read `groceries.length` into `itemCount`.
```

## Predict the output

The array keeps growing, even though its name is `const`. Work out what prints before you run it.

```js predict id=predict-const-array title="Const does not freeze contents"
const tags = ["js"];
tags.push("code");
console.log(tags.length);
--- options
1
* 2
TypeError: Assignment to constant variable.
3
--- explain
`const` stops the name `tags` from pointing at a different array. It does not stop the array from changing. `push` adds an item to the same array, so its length goes from 1 to 2. The `TypeError` option would be correct only if the code were `tags = [...]`, which reassigns the name. The `3` option miscounts, because only one `push` runs.
```

## Recap

- Use `let` for values that change and `const` for values that do not.
- Reassigning with `=` replaces the stored value; it does not create a new variable.
- Name variables in camelCase so the code explains itself.
- `typeof` reports a value's type, and all numbers, integers and decimals alike, are `number`.
- A `const` array or object can change its contents. Only the binding is fixed.

**Up next:** numbers in depth, including the four basic operators, `Math` functions, and the floating-point surprise that catches everyone.
