Every decision a program makes comes down to a question with a yes or no answer. Is the user logged in? Is the cart empty? Has the price dropped below the limit? JavaScript answers those questions with booleans, the values `true` and `false`. Get the comparisons wrong, and the program takes the wrong branch without ever raising an error, which makes these bugs some of the hardest to find.

In this lesson you will build booleans with comparison operators, combine them with `&&`, `||` and `!`, and learn why `==` and `===` give different answers. You will also learn which values count as true or false when they are not booleans, and how to supply defaults without accidentally throwing away a real zero.

## Booleans from comparisons

A comparison produces a boolean. The operators are `>`, `<`, `>=`, `<=`, and the two equality checks you will learn below:

```js run
const age = 18;
console.log(age >= 18);
console.log(age < 13);
console.log(age !== 21);
```

`!==` means "not strictly equal". The exclamation mark negates a check, which is why you will see `!` in many conditions.

## Strict equality: `===`

Use `===` to ask whether two values are the same, both in type and in value. Use `!==` for "not the same". This is the check you should use almost every time:

```js run
console.log(5 === 5);
console.log(5 === "5");
console.log("ada" === "ada");
console.log(null === undefined);
```

The second line is `false` because `5` is a number and `"5"` is text. Types matter, and a strict check respects them.

> **Pitfall:** `==` is the loose equality operator, and it converts types before comparing. That conversion follows rules that are hard to remember, so most style guides forbid `==` in favour of `===`. The next example shows why.

## Loose equality: why `==` surprises people

Loose equality tries to make the two sides the same type before it compares them. The results can look wrong:

```js run
console.log(0 == "");
console.log(0 == "0");
console.log(null == 0);
console.log(null == undefined);
```

`0 == ""` is `true`, because the empty string converts to `0`. `0 == "0"` is also `true`. But `null == 0` is `false`, even though `null` looks like "nothing". Unless you know all of these rules, you cannot predict the result. Strict equality is always predictable, so use it.

> **Pitfall:** The one common case where `==` is accepted is `value == null`, which is `true` for both `null` and `undefined`. Outside that case, prefer `===`.

## Truthy and falsy values

Conditions do not need a real boolean. JavaScript treats any value as either **truthy** or **falsy** when it is used where a yes-or-no answer is expected. There are only a few falsy values:

- `false`, `0`, `-0`, `0n`
- `""` (the empty string)
- `null`, `undefined`
- `NaN`

Everything else is truthy, including `"0"`, `"false"`, `[]` and `{}`:

```js run
console.log(Boolean(0), Boolean(""), Boolean(null));
console.log(Boolean("0"), Boolean("false"));
console.log(Boolean([]), Boolean({}));
```

> **Pitfall:** `if (list)` is true for an empty array, because `[]` is truthy. To check for an empty list, test its length: `if (list.length > 0)`. Many bugs come from assuming empty things are falsy.

## Combining conditions

Three operators combine booleans. `&&` (and) is true only when both sides are true. `||` (or) is true when at least one side is true. `!` (not) flips a value:

```js run
const hasTicket = true;
const isOver18 = false;
console.log(hasTicket && isOver18);
console.log(hasTicket || isOver18);
console.log(!hasTicket);
```

These operators also short-circuit: they stop as soon as the answer is known. `&&` skips the right side when the left is falsy, and `||` skips the right side when the left is truthy. That is why `user && user.name` is a safe way to read a property only when `user` exists.

## Defaults with `||` and `??`

Sometimes you want a fallback when a value is missing. `||` returns its right side whenever the left side is falsy, which includes `0` and `""`. That is often too broad. The `??` operator only falls back for `null` and `undefined`:

```js run
const savedVolume = 0;
console.log(savedVolume || 50);
console.log(savedVolume ?? 50);
```

A volume of `0` is a real setting, meaning silent. `||` throws it away and plays at 50, while `??` keeps the zero.

> **Tip:** Reach for `??` when a missing value means "use the default", and `||` only when every falsy value should be replaced. The difference matters most for numbers and empty strings.

## Challenge: compare form input

A form gives you the answer as text. The value `"42"` should match the number `42`, so you need to convert before you compare. Store `true` in `matches` if the converted input equals `expected`, and `false` otherwise.

```js exercise id=form-matches title="Convert before you compare"
const input = "42";
const expected = 42;
// TODO: set matches to true when the input, converted to a number, equals expected
let matches = null;
--- solution
const input = "42";
const expected = 42;
let matches = Number(input) === expected;
--- test
assertEqual(matches, true, "The text \"42\" should match the number 42 after conversion");
assert(typeof matches === "boolean", "matches should be a boolean, true or false");
--- hint
Strict equality `===` will say `false` for `"42"` and `42`, because the types differ. Convert the input first.
--- hint
`Number(input)` turns the text into a number. Compare that with `===` and store the boolean result in `matches`.
```

## Challenge: keep a real zero

A discount of `0` means no discount, but this code replaces it with `10`. Fix the fallback so that `0` survives and only a missing value gets the default.

```js debug id=fix-zero-default title="Keep the zero"
const userDiscount = 0;
const discountPercent = userDiscount || 10;
console.log(discountPercent);
--- solution
const userDiscount = 0;
const discountPercent = userDiscount ?? 10;
console.log(discountPercent);
--- test
assert(_stdout === "0", "A discount of 0 should stay 0, so the program should print 0");
--- hint
`||` replaces every falsy value, including `0`. Look for an operator that only falls back for missing values.
--- hint
Change `||` to `??` on the second line. It replaces only `null` and `undefined`.
```

## Challenge: combine two rules

A driver can drive if they are at least 18 years old and hold a licence. Insurance is also required. The values are set in the starter; store the combined result in `canDrive`.

```js exercise id=can-drive title="Combine three conditions"
const age = 25;
const hasLicence = true;
const hasInsurance = true;
// TODO: store true in canDrive only when age is 18 or more, the licence is held, and insurance is held
let canDrive = null;
--- solution
const age = 25;
const hasLicence = true;
const hasInsurance = true;
let canDrive = age >= 18 && hasLicence && hasInsurance;
--- test
assertEqual(canDrive, true, "A 25-year-old with a licence and insurance can drive");
assert(typeof canDrive === "boolean", "canDrive should be true or false");
--- hint
Each condition is a boolean on its own. Join them with `&&`, which needs all of them to be true.
--- hint
The age check is a comparison: `age >= 18`. Put it first, then the two boolean variables, joined with `&&`.
```

## Predict the output

Equality and truthiness both matter here. Track each part of the expression separately.

```js predict id=predict-equality-truth title="Loose and strict together"
console.log(0 == "", 0 === "", "" ? "yes" : "no");
--- options
true true yes
* true false no
true false yes
false false no
--- explain
`0 == ""` is `true` because the loose check converts the empty string to `0`. `0 === ""` is `false` because the types differ. The empty string is falsy, so the conditional `"" ? "yes" : "no"` picks `no`. The option `true false yes` forgets that the empty string is falsy, and `false false no` wrongly says the loose check fails.
```

## Recap

- Comparisons like `>=` and `===` return `true` or `false`.
- Use `===` and `!==`; `==` converts types first and gives surprising answers.
- The falsy values are `false`, `0`, `""`, `null`, `undefined` and `NaN`; everything else is truthy, including `[]`.
- `&&`, `||` and `!` combine booleans and short-circuit.
- `??` supplies a default only for `null` and `undefined`, so a real `0` survives.

**Up next:** conditionals, with `if`, `else`, `else if`, and the `switch` statement for choosing among many cases.
