Real programs are made of small named pieces: a function that calculates a total, one that formats a price, one that checks whether a password is long enough. A function lets you write that logic once, give it a name, and use it everywhere. Without functions you end up copying code, and the copies drift apart the first time you fix a bug in only one of them.

By the end of this page you'll write functions that take parameters, send values back with `return`, fall back to default values for optional input, and you'll know the most common beginner bug: a function that quietly returns `undefined` because it forgot to say what it hands back.

## Declaring and calling a function

A function is a block of code with a name. You *declare* it once with the `function` keyword, and you *call* it, with parentheses, every time you want it to run:

```js run
function sayHello() {
  console.log("Hello from a function!");
}

sayHello();
sayHello();
```

Declaring a function doesn't run it. Nothing prints until the call on the line `sayHello();`. Each call runs the body again from the top, which is the whole point: write it once, run it as many times as you need.

## Parameters and arguments

Names inside the parentheses are **parameters**: placeholders the function expects. The values you pass in when you call it are **arguments**. The function gets its own copy of each argument, bound to the parameter name:

```js run
function square(n) {
  console.log(n, "squared is", n * n);
}

square(4);
square(1.5);
```

Parameters are local to the function. The name `n` exists only while `square` is running, so you can reuse the same name in another function without any clash.

> **Pitfall:** JavaScript doesn't complain when you call a function with too few arguments. The missing parameters simply become `undefined`.

```js run
function describe(name, age) {
  return `${name} is ${age} years old`;
}

console.log(describe("Ada", 36));
console.log(describe("Grace"));
```

The second line prints `Grace is undefined years old`. Nothing crashed, and that's exactly why this bug hides in real code. Later in this course you'll see defaults that prevent it.

## Returning a value

Printing is not the same as producing a result. A function that only prints can't feed its answer into the next calculation. The `return` statement sends a value back to the caller, and it also ends the function immediately:

```js run
function add(a, b) {
  return a + b;
}

const total = add(2, 3) * 10;
console.log("total:", total);
add(1, 1)
```

The final line of the cell shows `2`, because that is the value of the last expression. Notice that `add(2, 3)` is replaced by `5` right where it's called, so `5 * 10` gives `50`.

`return` also acts as an early exit. As soon as it runs, nothing after it in the function is executed:

```js run
function firstNegative(numbers) {
  for (const n of numbers) {
    if (n < 0) return n;
  }
  return null;
}

console.log(firstNegative([3, -2, -7]));
console.log(firstNegative([1, 2]));
```

> **Tip:** Name a function after what it *returns*, not after what it does internally. `averageOf(scores)` tells the reader what to expect at the call site, and `calculateAverageAndPrint(scores)` tells them the function does two jobs.

> **Pitfall:** A function with no `return` statement gives back `undefined`. The function still runs, so the bug looks like the logic is fine until you try to use the result.

Try it yourself. Write a function that converts Celsius to Fahrenheit using the formula `F = C * 9 / 5 + 32`:

```js exercise id=to-fahrenheit title="Convert Celsius to Fahrenheit"
function toFahrenheit(celsius) {
  // TODO: return celsius * 9 / 5 + 32
  return null;
}
--- solution
function toFahrenheit(celsius) {
  return celsius * 9 / 5 + 32;
}
--- test
assert(toFahrenheit(0) === 32, "Freezing point: toFahrenheit(0) should be 32");
assert(toFahrenheit(100) === 212, "Boiling point: toFahrenheit(100) should be 212");
assert(toFahrenheit(-40) === -40, "-40 is the same on both scales");
assert(toFahrenheit(20) === 68, "toFahrenheit(20) should be 68");
--- hint
The function must give the converted value back to the caller, so it needs a `return`.
--- hint
Multiplication and division run before addition, so `celsius * 9 / 5 + 32` does the right thing without parentheses.
```

Here is a function with that exact bug. The total is calculated correctly, then thrown away. Your job is to change the function so `addTax(80)` gives `100`, `addTax(8)` gives `10`, and `addTax(0)` gives `0`. Read it carefully and find what's missing; the fix is a single line.

```js debug id=fix-missing-return title="Fix the missing return"
function addTax(price) {
  // Bug: the total is calculated, but the function never hands it back
  const total = price * 1.25;
}
--- solution
function addTax(price) {
  const total = price * 1.25;
  return total;
}
--- test
assert(addTax(80) === 100, "addTax(80) should return 100");
assert(addTax(8) === 10, "addTax(8) should return 10");
assert(addTax(0) === 0, "addTax(0) should return 0");
--- hint
Read the last line of the function. Does anything in it send `total` back to the caller?
--- hint
Add a `return` statement that gives back `total`.
```

## Default parameters

Sometimes a parameter should have a sensible value when the caller leaves it out. Give it a default with `=`:

```js run
function greet(name, greeting = "Hello") {
  return `${greeting}, ${name}!`;
}

console.log(greet("Ada"));
console.log(greet("Ada", "Welcome"));
```

A default is used only when the argument is missing or is literally `undefined`. It is not used for `null`, which is a deliberate "no value" that you passed on purpose:

```js run
function greet(name, greeting = "Hello") {
  return `${greeting}, ${name}!`;
}

console.log(greet("Ada", undefined));
console.log(greet("Ada", null));
```

The first line uses the default. The second prints `null, Ada!`, because `null` is a real value and the default never applies to it. This distinction matters when you read data from forms, files or APIs, where "empty" can show up as `null` or as a missing field.

Now put defaults to work. Your function should format an amount of money with exactly two decimal places and a currency code, and it should default to `"USD"`:

```js exercise id=format-price title="Format a price with a default currency"
function formatPrice(amount, currency = "USD") {
  // TODO: return the amount with exactly 2 decimals, a space, then the currency
  // Example: formatPrice(12.5, "EUR") should return "12.50 EUR"
  return null;
}
--- solution
function formatPrice(amount, currency = "USD") {
  return amount.toFixed(2) + " " + currency;
}
--- test
assert(formatPrice(5) === "5.00 USD", "formatPrice(5) should use USD and two decimals: '5.00 USD'");
assert(formatPrice(12.5, "EUR") === "12.50 EUR", "formatPrice(12.5, 'EUR') should return '12.50 EUR'");
assert(formatPrice(0.1, "GBP") === "0.10 GBP", "Single-digit cents still need two decimals");
--- hint
Look at the default value in the parameter list: `currency = "USD"` will be used when you don't pass a second argument.
--- hint
`toFixed(2)` converts a number to a string with exactly two decimal places. Join the pieces with `+` or a template literal.
```

## Functions help you compose

Once a function works, you can call it from another function. Small functions are easier to test and reuse than one long function that does everything:

```js run
function sum(numbers) {
  let total = 0;
  for (const n of numbers) total += n;
  return total;
}

function average(numbers) {
  return sum(numbers) / numbers.length;
}

console.log(average([80, 90, 100]));
```

`average` never touches the loop. It trusts `sum` to add the numbers, and divides the result by the count. That trust is what makes large programs manageable: each function has one job and a clear input and output.

Here is a prediction question about the function you just fixed. Read the code and decide what it prints before you check:

```js predict id=no-return-value title="What does this print?"
function double(n) {
  n * 2;
}

console.log(double(3), double(3) === undefined);
--- options
6 false
undefined false
* undefined true
3 true
--- explain
`n * 2;` is a calculation with no `return`, so the function finishes without a value. Its result is `undefined`, which prints as `undefined`, and `double(3) === undefined` is `true`. The calculation happened, but nothing was handed back, the same bug you just fixed in `addTax`.
```

> **Under the hood:** When a function reaches the end of its body without a `return`, JavaScript behaves as if it ran `return undefined;`. That's why the result is always defined, and why `undefined` is the value you see when you forget.

> **In the wild:** Built-in functions follow the same rule. `console.log` returns `undefined`, and `Array.prototype.sort` returns the array it sorted, so writing `const sorted = items.sort()` works, but writing `const sorted = items.push(x)` gives you the length, not the array. Always check what a function returns.

## Recap

- A function is declared with `function name(params) { ... }` and runs only when you call it with `name(args)`.
- Parameters are local placeholders; arguments are the values you pass in. Missing arguments become `undefined`.
- `return` sends a value back to the caller and ends the function right away.
- A function with no `return` gives back `undefined`, which is the most common beginner bug.
- Default parameters like `currency = "USD"` apply only to missing or `undefined` arguments, never to `null`.

**Up next:** Scope: where variables live, and why a variable declared inside a function disappears when the function ends.
