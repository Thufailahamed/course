Real text is messy. Users type extra spaces, mix capital letters, paste in whole sentences when you wanted one word, and send a file with a date in the wrong place. Every program that handles text ends up cleaning, searching and reshaping it, and JavaScript gives you a set of string methods for exactly that work.

In this lesson you will use the methods you will reach for every day: trimming and changing case, searching, cutting out pieces, splitting and joining, replacing, and padding for tidy output. You will also learn the rule that governs all of them, which is that strings never change in place. Once that clicks, most string bugs become easy to spot.

## Methods return new strings

A **method** is a function attached to a value. You call it with a dot, and it works on that value. String methods never modify the original string, because strings are immutable. They return a new string, and you must keep it if you want to use it:

```js run
const raw = "  Hello  ";
const cleaned = raw.trim();
console.log("raw:", JSON.stringify(raw));
console.log("cleaned:", JSON.stringify(cleaned));
console.log("untouched:", JSON.stringify(raw));
```

`JSON.stringify` puts quotation marks around the text, so the spaces are visible. You will meet it again in the JSON lesson.

> **Pitfall:** Calling `name.trim()` on its own line and then using `name` later does nothing. The trimmed copy is thrown away. Write `name = name.trim()` or store the result in a new variable.

## Trimming and changing case

Input from people almost always needs cleaning first. `trim` removes spaces at both ends, and the case methods turn text into all capitals or all lowercase:

```js run
const typed = "  Ada.Lovelace@Example.COM  ";
console.log(typed.trim().toLowerCase());
console.log("shout".toUpperCase());
```

Lowercasing before a comparison is a common habit. Email domains and usernames are often case-insensitive, so `ADA@example.com` and `ada@example.com` should match. Make both sides the same case, then compare.

## Searching inside a string

Four methods answer "is this text in there?" and "where is it?":

- `includes(text)` returns `true` or `false`.
- `startsWith(text)` and `endsWith(text)` check the ends.
- `indexOf(text)` returns the index of the first match, or `-1` when nothing matches.

```js run
const file = "report-2026-final.pdf";
console.log(file.includes("2026"));
console.log(file.startsWith("report"), file.endsWith(".csv"));
console.log(file.indexOf("final"), file.indexOf("draft"));
```

All of these are case-sensitive. `"Report".includes("report")` is `false`. Lowercase both sides when the case should not matter.

> **Pitfall:** `indexOf` returns `-1` when nothing is found, and `-1` is truthy in an `if`. Compare with `!== -1` when you need a position, or use `includes` when you only need yes or no.

## Cutting out pieces with `slice`

`slice(start, end)` returns the characters from `start` up to, but not including, `end`. Leave out `end` to go all the way to the finish. Negative numbers count backward from the end:

```js run
const language = "JavaScript";
console.log(language.slice(0, 4));
console.log(language.slice(4));
console.log(language.slice(-6));
console.log(language.slice(-6, -3));
```

The end index is excluded, which means `slice(0, 4)` gives four characters and `slice(4, 4)` gives an empty string. This rule keeps the lengths of pieces predictable: `end - start` is always the count.

## Splitting and joining

`split` breaks a string into an array of pieces at a separator. It is the standard way to read a line of comma-separated values:

```js run
const row = "Ada,Lovelace,36";
const fields = row.split(",");
console.log(fields);
console.log(fields[1], fields.length);
console.log(fields.join(" | "));
```

Arrays get a full lesson later. For now, notice that `split` gives you a list, and `join` puts a list back together with a separator you choose.

> **Tip:** `split("")` splits into single characters, but it splits by UTF-16 code units, so an emoji such as a family of people counts as several pieces. Use it for plain text, and be careful with emoji.

## Replacing text

`replace` swaps the first match it finds. `replaceAll` swaps every match. Confusing the two is a classic source of half-fixed data:

```js run
const note = "cat, cat, cat";
console.log(note.replace("cat", "dog"));
console.log(note.replaceAll("cat", "dog"));
```

Both methods match plain text here. You can pass a pattern for more complex matching, which is covered in more advanced courses.

## Padding and repeating

`padStart` adds characters to the front until the string reaches a target length. Padding is how you line up numbers in a table, or write a time such as `09:05` instead of `9:5`:

```js run
const hour = "9";
const minute = "5";
console.log(hour.padStart(2, "0") + ":" + minute.padStart(2, "0"));
console.log("-".repeat(12));
```

The `padEnd` method works the same way at the back, and `repeat(n)` gives you `n` copies of the text.

> **In the wild:** Text tables in command-line tools, invoice printouts and log output all rely on `padStart` and `padEnd` to keep columns aligned.

## Challenge: normalize an email

Clean the email address in `rawEmail` so it has no surrounding spaces and is all lowercase. Store the result in `email`.

```js exercise id=normalize-email title="Normalize an email address"
const rawEmail = "  Ada.Lovelace@Example.COM  ";
// TODO: trim the spaces and lowercase the address, then store it in `email`
let email = null;
--- solution
const rawEmail = "  Ada.Lovelace@Example.COM  ";
let email = rawEmail.trim().toLowerCase();
--- test
assertEqual(email, "ada.lovelace@example.com", "The email should be trimmed and lowercase");
assert(!email.includes(" "), "The email should not contain spaces");
--- hint
Chain two methods: one removes the spaces at the ends, and one changes the case. Order does not matter here.
--- hint
`rawEmail.trim().toLowerCase()` produces the cleaned value. Store it in `email`.
```

## Challenge: mask a card number

Show only the last four digits of a card number. The masked version should be `**** **** **** 4242`, built from `card`, so that the last four characters come from the card number rather than being typed in.

```js exercise id=mask-card title="Mask all but four digits"
const card = "4242424242424242";
// TODO: store the masked version in `masked`, using the last four digits of `card`
let masked = null;
--- solution
const card = "4242424242424242";
let masked = "**** **** **** " + card.slice(-4);
--- test
assertEqual(masked, "**** **** **** 4242", "The masked card should read **** **** **** 4242");
assertEqual(masked.length, 19, "The masked value should be 19 characters long");
--- hint
`slice` with a negative start counts from the end, so `card.slice(-4)` gives the last four characters.
--- hint
Join the four stars groups and the last four digits with `+`, or use a template literal with `${card.slice(-4)}`.
```

## Challenge: fix the replacement

A note should read `dog, dog, dog` after the change, but only the first `cat` changes. Fix the call so every match is replaced.

```js debug id=fix-replace-all title="Replace every match"
const text = "cat, cat, cat";
const result = text.replace("cat", "dog");
console.log(result);
--- solution
const text = "cat, cat, cat";
const result = text.replaceAll("cat", "dog");
console.log(result);
--- test
assert(_stdout === "dog, dog, dog", "The program should print: dog, dog, dog");
--- hint
`replace` only swaps the first match. Look for the method that swaps every match.
--- hint
Replace `replace` with `replaceAll` on the second line. Keep the same arguments.
```

## Predict the output

Searching returns a position, and a missing match returns `-1`. Work out both numbers.

```js predict id=predict-index-of title="Where the match starts"
console.log("banana".indexOf("na"), "banana".indexOf("x"));
--- options
* 2 -1
2 0
-1 2
3 -1
--- explain
`indexOf` returns the index where the first match begins. In `banana`, the letters `n` and `a` start at index 2, so the answer is `2`. Nothing in `banana` matches `x`, so the second call returns `-1`. The option `2 0` mistakes a missing match for the first character. The option `3 -1` counts the position as the third letter rather than the index that starts at zero.
```

## Recap

- String methods return new strings; the original never changes.
- `trim`, `toLowerCase` and `toUpperCase` clean up input before you compare it.
- `includes`, `startsWith`, `endsWith` and `indexOf` search; `indexOf` returns `-1` when nothing matches.
- `slice` takes a start and an excluded end, and negative indexes count from the end.
- `split` and `join` move between text and lists, `replaceAll` replaces every match, and `padStart` aligns output.

**Up next:** booleans, the true and false values that drive every decision, and the equality rules that trip up almost everyone.
