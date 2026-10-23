Most loops you write fall into a handful of shapes. You add up a running total, you look for the first item that meets a rule, you count how many items pass a test, or you build a new result one piece at a time. Once you can name the shape, the loop almost writes itself. Before you know the shape, every loop feels like a fresh puzzle.

This lesson teaches those four patterns: accumulate, search, count and build. You will practise them on strings, so you can focus on the pattern rather than on arrays, which arrive in the next two lessons. Each pattern uses the same ingredients: a starting value, a loop over the input, and a rule for updating the result.

## Accumulate: add up as you go

An **accumulator** is a variable that starts with a neutral value and gets updated on every pass. For a sum, the neutral value is `0`. For a string, it is the empty string `""`:

```js run
const text = "a1b2c3";
let digitSum = 0;
for (const ch of text) {
  if ("0123456789".includes(ch)) {
    digitSum += Number(ch);
  }
}
console.log("digit sum:", digitSum);
```

The rule is always the same: start neutral, update the total using the current item, and read the total after the loop. Notice that the check `"0123456789".includes(ch)` filters out letters before you convert anything. Converting `"a"` with `Number` would give `NaN`, and one `NaN` would spoil the total.

> **Pitfall:** Accumulators must start at the right neutral value. A sum that starts at `1` adds one extra, and a product that starts at `0` stays zero forever. Check the starting value first when a total is wrong.

## Search: stop at the first match

When you want to find something, the loop should stop as soon as it succeeds. Store the answer you want, usually an index, and use `break` to leave the loop early. If the loop finishes without a match, the answer keeps its default, often `-1`:

```js run
const label = "order No. 4471";
let firstDigit = -1;
for (let i = 0; i < label.length; i++) {
  if ("0123456789".includes(label[i])) {
    firstDigit = i;
    break;
  }
}
console.log("first digit at index", firstDigit);
```

The `break` is the part that matters. Without it, the loop keeps going and overwrites the answer with later matches, so you get the last one rather than the first. That bug appears in the challenge below.

> **Tip:** Use a sentinel value like `-1` for "not found". It is the same value `indexOf` returns, so the convention is familiar to anyone who reads your code.

## Count: tally what passes a test

Counting is an accumulator that adds `1` only when a rule holds. Put the test in an `if`, and increment inside the block:

```js run
const phrase = "Loop Pattern";
let vowels = 0;
for (const ch of phrase.toLowerCase()) {
  if ("aeiou".includes(ch)) vowels++;
}
console.log("vowels:", vowels);
```

Lowercasing first means you only need one set of vowels to test against. Choose the rule that makes the test simplest, and do any normalizing before the loop.

## Build: create a new result

Sometimes the output is a new string built from the input. The reversed text is a good example. Each pass adds the current character to the **front** of the result, so the last character read ends up first:

```js run
const word = "stressed";
let reversed = "";
for (const ch of word) {
  reversed = ch + reversed;
}
console.log(reversed);
```

Adding to the front rather than the back is the key idea. Writing `reversed + ch` would rebuild the original word. This pattern, building a result from its parts, is the one that lets you turn one kind of data into another.

> **Under the hood:** Each `+` on strings creates a new string, because strings never change in place. For a few characters that cost is nothing. For very long text, repeated concatenation in a loop can be slow, and the usual fix is to collect the pieces and join them once at the end.

## Combining patterns

Real loops often mix patterns. Consider a password check that counts uppercase letters and stops early if it finds a space. The loop does two jobs: it counts, and it can break on a disallowed character. Write the simplest version of each job, then combine them in one loop, and test the edge cases, such as an empty string or a value with no matches.

## Challenge: sum the digits

Add up every digit in `text`, and store the total in `digitSum`. For `"order 66, item 7"`, the digits are 6, 6 and 7, so the total is `19`. Letters, spaces and punctuation should not count.

```js exercise id=digit-sum title="Sum the digits in text"
const text = "order 66, item 7";
// TODO: loop over text, add up every digit character, and store the sum in digitSum
let digitSum = null;
--- solution
const text = "order 66, item 7";
let digitSum = 0;
for (const ch of text) {
  if ("0123456789".includes(ch)) {
    digitSum += Number(ch);
  }
}
--- test
assertEqual(digitSum, 19, "The digits 6, 6 and 7 should sum to 19");
--- hint
Start `digitSum` at `0`. Inside the loop, check whether the character is a digit before you add it.
--- hint
Use `"0123456789".includes(ch)` as the check, and `digitSum += Number(ch);` inside the matching block.
```

## Challenge: find the first capital letter

Store the index of the first uppercase letter in `firstUpper`, using `-1` if there isn't one. For `"hello World"`, the answer is `6`. Use a loop with `break`, so the search stops at the first match.

```js exercise id=first-capital title="Find the first capital letter"
const text = "hello World";
// TODO: store the index of the first uppercase letter in firstUpper, or -1 if there is none
let firstUpper = null;
--- solution
const text = "hello World";
let firstUpper = -1;
for (let i = 0; i < text.length; i++) {
  if (text[i] !== text[i].toLowerCase()) {
    firstUpper = i;
    break;
  }
}
--- test
assertEqual(firstUpper, 6, "The first capital letter in hello World is at index 6");
--- hint
Start `firstUpper` at `-1`, then loop over the indexes. A letter is uppercase when it differs from its lowercase form.
--- hint
Compare `text[i]` with `text[i].toLowerCase()`. When they differ, store `i` and `break`.
```

## Challenge: fix the search that finds the last match

This loop should report the index of the first digit in `"a1b22c3"`, which is `1`. It reports `6` instead. Fix the loop so it stops at the first digit it finds.

```js debug id=fix-search-loop title="Stop at the first match"
const text = "a1b22c3";
let found = -1;
for (let i = 0; i < text.length; i++) {
  if ("0123456789".includes(text[i])) found = i;
}
console.log(found);
--- solution
const text = "a1b22c3";
let found = -1;
for (let i = 0; i < text.length; i++) {
  if ("0123456789".includes(text[i])) {
    found = i;
    break;
  }
}
console.log(found);
--- test
assert(_stdout === "1", "The first digit in a1b22c3 is at index 1, so the program should print 1");
--- hint
Each match overwrites `found`, so the last digit wins. Ask what should happen after the first match is recorded.
--- hint
Put `found = i;` in a block and add `break;` after it, so the loop stops at the first digit.
```

## Predict the output

Count carefully. The test looks at each character, including the space, so decide which letters are vowels before you run it.

```js predict id=predict-count-vowels title="Counting characters"
let count = 0;
for (const ch of "Loop Pattern") {
  if ("aeiou".includes(ch)) count++;
}
console.log(count);
--- options
3
* 4
5
0
--- explain
The loop checks every character of `Loop Pattern` against `aeiou`. The vowels are the lowercase `o`, `o`, `a` and `e`, which makes four matches, so the output is `4`. The capital `L` and `P` are consonants, so they never count. The check is case-sensitive, so an uppercase vowel such as `O` would not match `aeiou` either. Lowercase the text first when capitals should count. The option `5` counts a letter that is not a vowel, and the option `3` misses one of the lowercase vowels.
```

## Recap

- An accumulator starts at a neutral value and changes on every pass.
- A search stores its answer and uses `break` to stop at the first match.
- Counting is an accumulator that adds `1` only when a rule holds.
- Building a result, such as reversing text, adds each piece to the front or back of a new value.
- Pick the pattern first, then write the simplest loop that fits it.

**Up next:** arrays, the ordered lists you will loop over constantly.
