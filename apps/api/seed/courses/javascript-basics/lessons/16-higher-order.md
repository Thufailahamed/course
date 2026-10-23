Most of the loops you write over arrays are doing one of three jobs: changing every item, keeping some items, or boiling a list down to one answer. JavaScript has a method for each of those jobs, and they're called `map`, `filter` and `reduce`. Each takes a callback, so it's a **higher-order** function: a function that works with other functions.

Once you can see a loop as one of these three shapes, your code gets shorter and easier to read. Instead of tracking an index, a counter and a temporary array, you read a sentence: take these prices, add tax to each, and keep the ones over ten. This page teaches you to think that way, and to catch the bugs that come with it.

## map: change every item

`map` returns a new array with the same length. Each item is replaced by whatever your callback returns for it. The original array is left alone:

```js run
const prices = [10, 20, 35];
const withTax = prices.map((p) => p * 1.25);

console.log(withTax);
console.log(prices);
```

`withTax` is a new array, and `prices` still holds the original numbers. Keeping the input unchanged is one of the most useful habits you can build, because a function that doesn't change its input is easy to reason about and easy to test.

## filter: keep some items

`filter` also returns a new array, but it can be shorter. Your callback returns `true` to keep an item and `false` to drop it:

```js run
const scores = [45, 82, 67, 91, 58];
const passing = scores.filter((s) => s >= 60);

console.log(passing, passing.length);
```

The callback is a test, so it should return a boolean. Filtering never changes the values themselves; it only decides which ones survive.

## reduce: fold a list into one value

`reduce` is the most general of the three. It walks through the array and carries a running result from one item to the next. You give it a starting value, and it returns the final result:

```js run
const cart = [12.5, 3.25, 8];
const total = cart.reduce((sum, price) => sum + price, 0);

console.log("total:", total);
```

The callback receives two things: `sum`, the running result so far, and `price`, the current item. It returns the new running result. Starting from `0`, the function adds each price in turn. Read it as "start with 0, and for each price, add it to the sum."

> **Tip:** Any loop that adds, counts, finds a maximum or builds an object from a list can be written with `reduce`. But if a plain `for...of` is clearer to your reader, use it. The goal is readable code, not the fewest lines.

## Chaining the methods

Each of these methods returns an array, so you can call the next method on the result. Read a chain from left to right, one step at a time:

```js run
const readings = [4, 17, 9, 23, 2];
const bigDoubled = readings.filter((r) => r > 5).map((r) => r * 2);

console.log(bigDoubled);
```

First `filter` keeps `17`, `9` and `23`. Then `map` doubles them. The chain reads like the requirement, which is why this style is so common in real code.

`find` is the fourth method you'll use constantly. It returns the first item that passes the test, not an array:

```js run
const firstBig = readings.find((r) => r > 10);

console.log("first over 10:", firstBig);
```

Now, the first challenge. Write a function that keeps only the even numbers, then squares them. This is a chain of two steps, so pick the right method for each step:

```js exercise id=squares-of-evens title="Square only the even numbers"
const squaresOfEvens = (numbers) => {
  // TODO: keep the even numbers, then square each one. Return the new array.
  return null;
};
--- solution
const squaresOfEvens = (numbers) => numbers.filter((n) => n % 2 === 0).map((n) => n * n);
--- test
assertEqual(squaresOfEvens([1, 2, 3, 4]), [4, 16], "The evens 2 and 4 should be squared to 4 and 16");
assertEqual(squaresOfEvens([7, 9, 10]), [100], "Only 10 is even, so only 100 should come back");
assertEqual(squaresOfEvens([]), [], "An empty list should give an empty list");
assertEqual(squaresOfEvens([5, 3]), [], "No even numbers should give an empty list");
--- hint
Use `filter` first to keep the even numbers, then `map` to square them. You can call `.map` directly on the result of `.filter`.
--- hint
An even number has a remainder of 0 when divided by 2, so `n % 2 === 0` is your test. Square a number with `n * n`.
```

## reduce with a starting value

Here's a question with a trap. Consider what happens when you use `reduce` on text instead of numbers:

```js predict id=reduce-strings title="What does reduce return?"
console.log(["1", "2", "3"].reduce((a, b) => a + b, 0));
--- options
6
123
* 0123
NaN
--- explain
The starting value is `0`, a number. The first `+` adds `0` and the string `"1"`, and when one side of `+` is a string, JavaScript joins the two as text, producing `"01"`. Every later step keeps joining text, so the result is `"0123"`. Strings stay strings with `+`, so the numbers are never added together. Start the reduce with `""` when you're joining strings.
```

> **Pitfall:** `reduce` without a starting value uses the first item as the start. That's convenient for numbers, but on an empty array it throws a `TypeError`. When you're not sure the array has items, always pass the starting value explicitly.

Next, a reduce challenge. Find the longest word in a list. If two words tie, return the one that appears first:

```js exercise id=longest-word title="Find the longest word"
const longestWord = (words) => {
  // TODO: return the longest word. On a tie, return the earlier word. An empty list gives "".
  return null;
};
--- solution
const longestWord = (words) => words.reduce((best, word) => (word.length > best.length ? word : best), "");
--- test
assertEqual(longestWord(["cat", "horse", "dog"]), "horse", "horse is the longest word");
assertEqual(longestWord(["ab", "cd", "e"]), "ab", "On a tie in length, the earlier word should win");
assertEqual(longestWord(["lemonade"]), "lemonade", "A single word is its own longest word");
assertEqual(longestWord([]), "", "An empty list should give an empty string");
--- hint
Use `reduce` with `""` as the starting value. In the callback, keep whichever of `best` and `word` is longer.
--- hint
Compare `word.length > best.length`. Use a strict `>` so that a tie keeps the earlier word.
```

## The sneaky bug: map that returns nothing

`map` and `forEach` both take a callback, and it's easy to mix them up. `forEach` runs a function for its side effects and returns nothing. `map` needs your callback to return a value for each item. If it doesn't, you get a list of `undefined`:

```js run
const raw = [3, 5];
const doubled = raw.map((n) => { n * 2 });
const fixed = raw.map((n) => { return n * 2; });

console.log(doubled);
console.log(fixed);
```

The first call is the missing-`return` bug again, now inside a `map`. The callback runs once per item, but the values it computes are dropped.

Here is a debug challenge built on this mistake. The function is supposed to return a new array of doubled numbers, but it uses `forEach`. Fix it so `doubleAll([1, 2, 3])` returns `[2, 4, 6]` and `doubleAll([])` returns `[]`. Change which method is called; the callback should still return the doubled value.

```js debug id=double-all title="Use map, not forEach"
const doubleAll = (numbers) => {
  return numbers.forEach((n) => n * 2);
};
--- solution
const doubleAll = (numbers) => numbers.map((n) => n * 2);
--- test
assertEqual(doubleAll([1, 2, 3]), [2, 4, 6], "doubleAll([1, 2, 3]) should return [2, 4, 6]");
assertEqual(doubleAll([10]), [20], "A single number should be doubled too");
assertEqual(doubleAll([]), [], "An empty list should give an empty list");
--- hint
`forEach` returns `undefined`, no matter what your callback does. You need a method that builds a new array from the callback's return values.
--- hint
Replace `forEach` with `map`. The callback already returns `n * 2`, so the rest of the function can stay as it is.
```

> **Under the hood:** `map`, `filter` and `reduce` don't change the array they're called on. They create a new one and return it. `sort` is the exception: it sorts the array in place and returns the same array. If you need a sorted copy of an array you keep using, sort a copy: `prices.slice().sort(...)`.

> **In the wild:** These three methods are the backbone of front-end code. A React component turns a list of records into a list of elements with `map`, a search box narrows a list with `filter`, and a shopping total comes from `reduce`. The same patterns appear in data libraries like pandas and in SQL, where you'd write `WHERE` for `filter` and `GROUP BY` for `reduce`.

## Recap

- `map` returns a new array with the same length, where each item is replaced by the callback's return value.
- `filter` returns a new array with only the items for which the callback returns `true`.
- `reduce` carries a running result through the array; always pass a starting value, such as `0` or `""`.
- Chain these methods to read a data pipeline from left to right, and use `find` to get the first match.
- `forEach` returns `undefined`. If you need the results, use `map`, and make sure the callback returns a value.

**Up next:** Objects: grouping related data under named properties, and why two variables can point at the same object.
