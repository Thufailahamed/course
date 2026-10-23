Every program you will ever write starts with a simple question: how do I see what it is doing? In JavaScript, the answer is almost always `console.log`. It prints a value to the output, and it is the single most used command in debugging. Professional developers reach for it constantly, and so will you.

By the end of this page you will print text and numbers, write comments that explain your intent, and read the error messages JavaScript gives you when something goes wrong. Error messages look intimidating at first. They are actually a precise map to the line that needs fixing, and learning to read them is one of the fastest ways to get better.

## Printing with `console.log`

`console.log` takes one or more values and prints them on a line. When you pass several values, it puts a single space between them:

```js run
console.log("Hello, world!");
console.log("Score:", 42);
console.log("Passed?", true, "with", 3, "retries");
```

Notice what happens to the text. The strings print without their quotation marks, and the number and the boolean print as they are. The quotation marks are how you tell JavaScript "this is text, not a command". They never appear in the output.

Each call to `console.log` starts a new line. That is why three calls give you three lines, even though each one is short.

> **Under the hood:** `console.log` does not return anything useful. It writes to the output and returns `undefined`. That is why you should not write `console.log` on the last line of a function if you want the function to hand back a value. You will meet that distinction in the functions lesson.

## Comments: notes for the reader

A comment is text that JavaScript ignores. Comments explain *why* code does something, and they are how you leave a message for your future self. There are two kinds:

```js run
// A single-line comment starts with two slashes.
console.log("This line runs.");

/*
  A multi-line comment starts with slash-star
  and ends with star-slash. Use it for longer notes.
*/
console.log("This one runs too.");
```

Good comments say why something is non-obvious. A comment that repeats the code, like `// print hello`, adds noise. A comment like `// Prices are in cents to avoid rounding errors` is worth keeping.

> **Tip:** You can use a comment to switch a line off while you test something. Put `//` in front of a `console.log`, and it stops running without being deleted. Remove the slashes when you want it back.

## Statements and semicolons

Each instruction in a program is a **statement**. Statements usually end with a semicolon, like the lines above. JavaScript will insert semicolons for you in many places, but writing them yourself makes your intentions clear, and it avoids a subtle trap you will meet below.

Whitespace mostly does not matter. These two programs behave the same, but only the first is easy to read:

```js run
console.log("easy"); console.log("to read");
console.log("easy");
console.log("to read");
```

## Reading error messages

Mistakes happen, and JavaScript tells you about them. Errors come in a few families, and the name at the start of each message tells you the kind of problem:

| Error name | What it usually means |
|---|---|
| `SyntaxError` | The code is not valid JavaScript. Often a missing quote, bracket or comma. Nothing in the file runs. |
| `ReferenceError` | You used a name that does not exist, usually because of a spelling mistake. |
| `TypeError` | You used a value in a way its type does not allow, such as calling something that is not a function. |

You can catch an error and print its name and message yourself. This is useful when you want a program to keep going:

```js run
try {
  console.log(totl);
} catch (error) {
  console.log(error.name + ": " + error.message);
}
```

The variable is called `totl`, not `total`, and it was never declared. JavaScript cannot find it, so it reports a `ReferenceError`. The `try` and `catch` words are covered properly in the errors lesson later, but you can already see that the message names the problem clearly.

> **Pitfall:** A `SyntaxError` stops the whole cell before any line runs. If your output is empty, look for a syntax error first. The message usually points to the line where the parser got confused, and the real mistake is often a line or two earlier.

## Strings and their quotes

Text in JavaScript is a **string**, and you can wrap it in double quotes `"..."`, single quotes `'...'` or backticks `` `...` ``. Pick one style and stick to it. The most common beginner mistake is mixing quotes inside a string:

```js run
console.log("She said 'hello' and left.");
console.log('It\'s escaped with a backslash.');
```

If the text itself contains the quote character that wraps it, either use the other kind of quote around it or escape the inner quote with a backslash. The backslash tells JavaScript to treat the next character as plain text.

> **Pitfall:** An apostrophe inside single quotes, like `'It's fine'`, ends the string early. JavaScript then sees `s` as code, and you get a `SyntaxError`. Switching to double quotes, or escaping the apostrophe, fixes it.

## Challenge: fix the broken quote

This line is supposed to print `It's a sunny day`, but it does not run at all. Fix the single line so the output matches exactly.

```js debug id=fix-apostrophe title="Fix the broken quote"
console.log('It's a sunny day');
--- solution
console.log("It's a sunny day");
--- test
assert(_stdout === "It's a sunny day", "The output should be: It's a sunny day");
--- hint
Look at the quote characters. The apostrophe in "It's" is also a single quote, which closes the string early.
--- hint
Wrap the whole line in double quotes instead. Single quotes inside double quotes are plain text.
```

## Challenge: print a receipt

Write the code that prints this three-line receipt, one line per `console.log` call:

```
Coffee
Total: 4.5
Thanks!
```

The starter prints the wrong thing on purpose, so the tests fail until you replace it.

```js exercise id=print-receipt title="Print a three-line receipt"
// TODO: replace this line with three console.log calls
console.log("replace me");
--- solution
console.log("Coffee");
console.log("Total: 4.5");
console.log("Thanks!");
--- test
assert(_stdout === "Coffee\nTotal: 4.5\nThanks!", "Print exactly these three lines: Coffee, Total: 4.5, Thanks!");
--- hint
You need one `console.log` per line. Each call starts a new line of output.
--- hint
Write `console.log("Coffee");` and then the next two lines in the same way, changing the text.
```

## Challenge: switch off a debug line

This program prints a debugging line that should not appear in the final output. Use a comment to turn that one line off without deleting it, so the output is only `Order ready`.

```js exercise id=comment-out-debug title="Silence the debug line"
console.log("Order ready");
console.log("DEBUG: queue length is 3");
--- solution
console.log("Order ready");
// console.log("DEBUG: queue length is 3");
--- test
assert(_stdout === "Order ready", "Only 'Order ready' should print. Comment out the debug line.");
--- hint
A `//` at the start of a line makes JavaScript ignore everything after it on that line.
--- hint
Put `// ` in front of the second `console.log` and leave the first one alone.
```

## Predict the output

Before you run this cell, decide what it prints. Look closely at what sits inside the quotes and what sits outside.

```js predict id=predict-sum-text title="Text or arithmetic?"
console.log("1 + 1 =", 1 + 1);
--- options
* 1 + 1 = 2
2
1 + 1 = 11
11
--- explain
The text `"1 + 1 ="` is a string, so it prints exactly as written. The expression `1 + 1` is outside the quotes, so JavaScript calculates it and prints `2`. The output is `1 + 1 = 2`. The option `1 + 1 = 11` happens when you accidentally join the numbers as text. That is a real trap, and you will meet it again with `+` and strings.
```

## Recap

- `console.log` prints one or more values on a line, separated by spaces.
- Strings print without quotes; quotes only mark where text begins and ends.
- `//` and `/* */` leave notes that JavaScript ignores.
- `SyntaxError`, `ReferenceError` and `TypeError` tell you what kind of mistake you made, and the message points to it.
- Match your quote marks, or escape an apostrophe inside a single-quoted string.

**Up next:** variables with `let` and `const`, and how to give values a name you can reuse.
