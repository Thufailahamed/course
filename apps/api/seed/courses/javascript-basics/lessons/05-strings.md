Most of what a program shows a person is text: a product name in a cart, an error message, a line in an email, a row in a report. A string is JavaScript's word for text, and you will build strings all day. Getting them right means knowing how quotes and escape characters work, how to join pieces together without mistakes, and why `+` is not always addition.

In this lesson you will create strings, read characters from them, and join values together in two ways. You will learn when template literals are clearer than plus signs, and you will see the classic trap where numbers and text mix silently.

## Creating strings

A string holds text. You can write one with double quotes, single quotes or backticks. Double and single quotes are interchangeable. Backticks produce a **template literal**, which has extra powers that you will meet shortly:

```js run
const city = "Lisbon";
const greeting = 'Good morning';
const note = `Ready for ${city}`;
console.log(city, greeting, note);
```

Strings are not split by line breaks, so a regular string must fit on one line. Two escape sequences handle the common cases: `\n` starts a new line and `\t` inserts a tab. A backslash also escapes a quote character inside a string.

```js run
console.log("Name:\tAda\nRole:\tEngineer");
console.log("She said \"yes\" twice.");
```

> **Pitfall:** Backslashes start escape sequences. A Windows path such as `"C:\new\table"` contains a newline and a tab, not the folders you meant. Use `\\` for a literal backslash, or use a template literal if the text must contain many backslashes.

## Strings have length and positions

Every character in a string has a position, called an **index**. The first character is at index `0`, not `1`. A string's `length` property counts its characters:

```js run
const word = "Hello";
console.log(word.length);
console.log(word[0], word[1], word[4]);
console.log(word[word.length - 1]);
```

Counting from zero feels odd at first, but it fits how computers store data in memory, and it makes ranges easy to write. The last valid index is always `length - 1`.

> **Pitfall:** Asking for a position past the end gives `undefined`, not an error. `word[99]` quietly returns `undefined`, and that surprise can bubble into a page as the text `undefined`. Check positions before you rely on them.

Strings are **immutable**. You cannot change one character in place. Methods that look like they change a string return a new one, and you must store the result. You will meet the most useful of these methods in the next lesson.

## Joining with `+`

The plus sign joins strings together, which is often the first way beginners build a sentence:

```js run
const product = "Notebook";
const price = 6;
console.log("Item: " + product + ", price: " + price);
```

Plus works on text, so it always produces text. Spaces inside the quotes are your responsibility. Forgetting a space is an easy mistake, so read the output carefully.

## Template literals

A template literal is written with backticks, and it lets you put any expression inside `${ ... }`. The expression is calculated, and the result is inserted into the text. Template literals also keep line breaks as you type them:

```js run
const product = "Notebook";
const price = 6;
const quantity = 3;
console.log(`Item: ${product}, total: ${price * quantity}`);

const card = `Thanks, Ada!
Your order ships on Monday.`;
console.log(card);
```

Most developers prefer template literals for anything with more than one value. They read like the output they produce, and there is no risk of a missing space or a stray quote. Use `+` when joining a couple of short values, and templates for everything else.

> **In the wild:** Logging, error messages and HTML generation in production code almost always use template literals, because readability matters more than the few extra characters they save.

## The `+` trap: numbers become text

Here is the rule that causes the most confusion. `+` adds two numbers, but as soon as one side is a string, it joins text. The other side is converted to text first:

```js run
console.log("1" + 2);
console.log("1" - 2);
console.log(1 + 2 + "3");
console.log("3" + 1 + 2);
```

Read those lines in order. The expression `1 + 2 + "3"` adds `1` and `2` first, because the operators run left to right, and then joins the text `"3"`, giving `"33"`. The string `"3" + 1 + 2` joins everywhere, giving `"312"`. The minus sign always works on numbers, so `"1" - 2` gives `-1`.

> **Pitfall:** When a number arrives as text, such as from a text box or a file, `+` silently concatenates instead of adding. Convert it first with `Number(value)` before doing arithmetic.

## Challenge: a receipt line

Build a receipt line with a template literal. The values are already defined in the starter. The line should look like `2 x Latte @ 4.5 = 9`, where the last number is the quantity times the price.

```js exercise id=receipt-line title="Build a receipt line"
const item = "Latte";
const price = 4.5;
const quantity = 2;
// TODO: store a receipt line in `line` using a template literal
let line = null;
--- solution
const item = "Latte";
const price = 4.5;
const quantity = 2;
let line = `${quantity} x ${item} @ ${price} = ${quantity * price}`;
--- test
assertEqual(line, "2 x Latte @ 4.5 = 9", "The line should read: 2 x Latte @ 4.5 = 9");
assert(typeof line === "string", "line should be text");
--- hint
A template literal starts and ends with backticks, and anything in `${ }` is calculated and inserted.
--- hint
Put `${quantity}` first, then the word `x`, then `${item}`, and so on. The final part is `${quantity * price}`.
```

## Challenge: initials from a name

Given a first and last name, build the two-letter initials in `initials`. For `"Ada"` and `"Lovelace"`, the result should be `"AL"`. Use the index syntax from this lesson.

```js exercise id=initials title="Pull initials from names"
const first = "Ada";
const last = "Lovelace";
// TODO: store the first letter of each name, in order, in `initials`
let initials = null;
--- solution
const first = "Ada";
const last = "Lovelace";
let initials = first[0] + last[0];
--- test
assertEqual(initials, "AL", "Ada Lovelace should give AL");
assert(initials.length === 2, "initials should be exactly two letters");
--- hint
Each name is a string, and `name[0]` gives its first character.
--- hint
Join the two characters with `+`, which works here because both sides are text: `first[0] + last[0]`.
```

## Challenge: fix the plus sign

A cart total should read `Total: 7`, but the program prints `Total: 34`. The bug is in how the numbers are joined. Fix the expression so the two counts are added before the text is joined.

```js debug id=fix-plus-concat title="Add before you join"
const apples = 3;
const pears = 4;
console.log("Total: " + apples + pears);
--- solution
const apples = 3;
const pears = 4;
console.log("Total: " + (apples + pears));
--- test
assert(_stdout === "Total: 7", "The program should print: Total: 7");
--- hint
Once the first `+` joins text onto `"Total: "`, every later `+` joins text too. Look for a way to make the addition happen first.
--- hint
Wrap the two counts in parentheses: `(apples + pears)`, so the addition finishes before the result meets the text.
```

## Predict the output

Remember that `+` runs left to right, and joining text is contagious.

```js predict id=predict-plus-order title="Left to right"
console.log("2" + 3 + 4, 2 + 3 + "4");
--- options
9 54
* 234 54
234 9
2345 9
--- explain
`"2" + 3` joins text, giving `"23"`, and `"23" + 4` joins again, giving `"234"`. The second expression adds `2 + 3` to make `5` first, and only then joins `"4"`, giving `"54"`. The output is `234 54`. The option `9 54` would be right only if every number were added before any text, which JavaScript does not do.
```

## Recap

- Strings can use single, double or backtick quotes; escapes like `\n` and `\t` write control characters.
- Characters are read by index, starting at `0`, and `length` gives the count.
- Template literals (`` `${value}` ``) insert expressions cleanly and can span lines.
- `+` adds numbers but joins text, and a number beside a string becomes text.
- Strings never change in place; methods return new ones.

**Up next:** the string methods you will use every day, including trimming, case changes, searching and splitting.
