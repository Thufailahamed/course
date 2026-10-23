Almost every program does arithmetic somewhere. A checkout adds up prices, a timer turns seconds into minutes, a game wraps a character around the screen, a bank applies interest. JavaScript makes all of this look easy, which is exactly why its surprises are dangerous. Money that is a fraction of a cent off, or a loop that never ends because of a sign error, can ship to real users if you do not know the rules.

In this lesson you will learn the arithmetic operators and how JavaScript orders them, the reason `0.1 + 0.2` is not `0.3`, and how to round and compare numbers safely. You will also use the `Math` object for the everyday operations that the operators do not cover.

## One number type

JavaScript has a single type for numbers. Whole numbers and decimals are both `number`, so `42` and `42.5` need no special handling:

```js run
console.log(typeof 42, typeof 42.5, typeof -7);
console.log(42 === 42.0);
```

Under the surface, every number is a 64-bit floating-point value. That design makes the language simple, and it has one consequence you must respect. Whole numbers stay exact up to `Number.MAX_SAFE_INTEGER`, which is `9007199254740991`. Beyond that, neighbouring integers can collapse into the same stored value.

```js run
console.log(Number.MAX_SAFE_INTEGER);
console.log(Number.MAX_SAFE_INTEGER + 2);
```

> **Under the hood:** For integers larger than the safe limit, JavaScript offers `BigInt`, written with an `n` suffix like `10n ** 20n`. You rarely need it for everyday code, but it is the right tool when exact large integers matter.

## The arithmetic operators

JavaScript has six arithmetic operators, and they behave as you would expect from school maths, with two details to remember.

| Operator | Name | Example | Result |
|---|---|---|---|
| `+` | addition | `7 + 2` | `9` |
| `-` | subtraction | `7 - 2` | `5` |
| `*` | multiplication | `7 * 2` | `14` |
| `/` | division | `7 / 2` | `3.5` |
| `%` | remainder | `7 % 2` | `1` |
| `**` | exponent | `7 ** 2` | `49` |

```js run
const pizzas = 3;
const slicesPerPizza = 8;
const people = 5;

const totalSlices = pizzas * slicesPerPizza;
console.log("Total slices:", totalSlices);
console.log("Fair share:", totalSlices / people);
console.log("Slices left over:", totalSlices % people);
console.log("A 30 cm square area:", 30 ** 2);
```

The first detail is that `/` always gives a decimal result, even when the division is exact. `8 / 4` is `2`, but `7 / 2` is `3.5`. JavaScript has no separate integer division operator, so when you want the whole number of groups, you use `Math.floor` with `/`. You will see that in the challenge below.

The second detail is `%`, the remainder. It gives what is left after you take as many whole groups as possible. It is handy for spotting even and odd numbers, cycling through a list, or finding how many items are left over.

> **Pitfall:** The remainder keeps the sign of the number on the left, not the sign of the divisor. `-7 % 3` is `-1`, not `2`. If you need a non-negative result for indexes, add the divisor and take the remainder again: `((n % size) + size) % size`.

### Precedence and parentheses

Multiplication, division and remainder run before addition and subtraction, just as in school. The exponent runs before all of them. When in doubt, add parentheses. They cost nothing and tell the next reader what you mean:

```js run
console.log(2 + 3 * 4);
console.log((2 + 3) * 4);
console.log(2 ** 3 ** 2);
```

The last line surprises people. `**` is right-associative, so `2 ** 3 ** 2` means `2 ** (3 ** 2)`, which is `2 ** 9`, giving `512`. Write parentheses when the exponents are nested.

## The floating-point surprise

Here is the part that trips up almost every developer the first time. Decimal fractions like `0.1` cannot be stored exactly in binary, just as `1/3` cannot be written exactly in decimal. JavaScript stores the closest value it can, and sums of those values drift:

```js run
console.log(0.1 + 0.2);
console.log(0.1 + 0.2 === 0.3);
console.log(0.5 + 0.25);
```

The first line is not a bug in the engine. Every language that uses binary floating point does the same thing. Sums of binary fractions like `0.5 + 0.25` are exact, so only some decimals drift. For money, the usual fix is to work in whole units, such as cents, and convert to decimals only for display.

> **Pitfall:** Never compare decimal results with `===`. Either round to the precision you need, or check that the difference is smaller than a small tolerance such as `Number.EPSILON`.

## Rounding with `Math`

The `Math` object holds the functions you need for rounding and the common calculations. Use `Math.round`, `Math.floor` and `Math.ceil` to round to a whole number, and `Math.trunc` to drop the decimal part:

```js run
const reading = 7.6;
console.log("round:", Math.round(reading));
console.log("floor:", Math.floor(reading));
console.log("ceil:", Math.ceil(reading));
console.log("trunc on -7.6:", Math.trunc(-7.6));
```

To round to a fixed number of decimal places, scale up, round, and scale back down. This keeps the result a number rather than text:

```js run
const rawPrice = 12.3456;
const cents = Math.round(rawPrice * 100);
console.log("in cents:", cents);
console.log("as a price:", cents / 100);
```

Other useful functions include `Math.abs`, `Math.min`, `Math.max`, `Math.sqrt` and the constant `Math.PI`:

```js run
console.log(Math.abs(-9), Math.max(3, 8, 5), Math.min(3, 8, 5));
console.log(Math.sqrt(144), Math.PI.toFixed(4));
```

> **Tip:** `toFixed(2)` formats a number with two decimal places, but it returns a string, such as `"12.35"`. Use it when you are printing a value, and keep the numeric version for further calculations.

## Special values: `NaN` and `Infinity`

Two special numbers show up when calculations go wrong. Dividing by zero gives `Infinity`, and a calculation with no valid result gives `NaN`, which stands for "not a number":

```js run
console.log(1 / 0);
console.log(0 / 0);
console.log(Math.sqrt(-1));
console.log(NaN === NaN);
```

`NaN` is never equal to anything, not even to itself. Test for it with `Number.isNaN(value)`. Because `NaN` poisons every calculation it touches, one stray `NaN` can make a whole report show `NaN`, which is why it is worth checking inputs early.

## Challenge: split a bill in cents

Four friends split a bill of 1003 cents, which is $10.03, three ways. Whole cents are the only unit that makes sense for the payment, so `perPerson` should be the whole number of cents each person pays, and `leftover` should be the cents that do not divide evenly.

```js exercise id=split-bill title="Split a bill in whole cents"
const billCents = 1003;
const people = 3;
// TODO: set perPerson to whole cents each person pays, and leftover to the cents that remain
let perPerson = null;
let leftover = null;
--- solution
const billCents = 1003;
const people = 3;
let perPerson = Math.floor(billCents / people);
let leftover = billCents % people;
--- test
assertEqual(perPerson, 334, "perPerson should be 334 cents for 1003 split three ways");
assertEqual(leftover, 1, "leftover should be 1 cent");
assertEqual(perPerson * people + leftover, billCents, "The shares plus the leftover should add back up to the bill");
--- hint
Division with `/` keeps the decimal part. You need the whole number of groups, and `Math.floor` removes the fraction.
--- hint
Use `Math.floor(billCents / people)` for each share, and `billCents % people` for the leftover.
```

## Challenge: round a price for display

A supplier's quote is `12.3456` per unit. Store the price rounded to the nearest cent as a number in `displayPrice`.

```js exercise id=round-price title="Round a price to cents"
const rawPrice = 12.3456;
// TODO: store rawPrice rounded to 2 decimal places in displayPrice, as a number
let displayPrice = null;
--- solution
const rawPrice = 12.3456;
let displayPrice = Math.round(rawPrice * 100) / 100;
--- test
assertEqual(displayPrice, 12.35, "displayPrice should be 12.35, the price rounded to the nearest cent");
assert(typeof displayPrice === "number", "displayPrice should stay a number, not text");
--- hint
Scale the price up by 100, round to a whole number with `Math.round`, then scale it back down by dividing by 100.
--- hint
`let displayPrice = Math.round(rawPrice * 100) / 100;` is the whole job. Note that `toFixed` would return text, which the test rejects.
```

## Challenge: compare money safely

This program tries to check that 10 cents plus 20 cents equals 30 cents. The exact comparison fails because of floating-point drift. Change the check so it prints `match` when the two values are equal within a tiny tolerance.

```js debug id=fix-float-compare title="Compare floats with a tolerance"
const total = 0.1 + 0.2;
console.log(total === 0.3 ? "match" : "off");
--- solution
const total = 0.1 + 0.2;
console.log(Math.abs(total - 0.3) < Number.EPSILON ? "match" : "off");
--- test
assert(_stdout === "match", "The check should print match, because 0.1 + 0.2 equals 0.3 within floating-point error");
--- hint
The bug is `===`, which needs an exact match. Think about the size of the difference between the two numbers.
--- hint
Compute `Math.abs(total - 0.3)`, then check whether it is smaller than `Number.EPSILON`.
```

## Predict the output

Floating-point drift shows up in the printed output, so look closely at the digits.

```js predict id=predict-float-sum title="The digits that drift"
console.log(0.1 + 0.2);
--- options
0.3
0.31
0.2
* 0.30000000000000004
--- explain
The sum is calculated in binary floating point, so the result is the closest stored value to 0.3, and that is not exactly 0.3. JavaScript prints the shortest decimal that identifies the stored value, which is `0.30000000000000004`. This is why exact comparisons on decimal sums fail.
```

## Recap

- All numbers share one type, and integers are exact only up to `Number.MAX_SAFE_INTEGER`.
- `/` always gives a decimal result; use `Math.floor` to get whole groups, and `%` for what remains.
- Remainders keep the sign of the left operand, and `**` is right-associative.
- `0.1 + 0.2` is not `0.3` in binary floating point; compare with a tolerance or work in whole units.
- `Math` provides rounding, `abs`, `min`, `max`, `sqrt` and `PI`, and `NaN` signals a calculation with no valid result.

**Up next:** strings, the text type, with quotes, template literals and joining values together.
