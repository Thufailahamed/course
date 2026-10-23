You use iterators every time you write `for...of`, spread an array, or destructure a `Map`. They're the protocol that lets one loop read from anything that produces values in sequence: an array, a string, a `Map`, a stream of lines from a file, a paginated API. Generators are the most convenient way to write those producers. A generator is a function that can pause in the middle of its work, hand a value to the caller, and resume exactly where it stopped.

Pausing is the important part. It means you can describe a sequence that's infinite, or too large to hold in memory, and take only the values you need. It also means you can clean up when a loop stops early. This lesson covers the protocol underneath, the generator syntax built on it, and the patterns that make lazy code easier to write than the eager alternative.

## The iterator protocol

An **iterator** is any object with a `next()` method. Each call returns an object `{ value, done }`. While `done` is `false`, `value` is the next item. When `done` becomes `true`, the sequence is over. An **iterable** is an object with a method at the key `Symbol.iterator` that returns an iterator. `for...of`, spread and destructuring all use that method.

```js run
function range(start, end) {
  let current = start;
  return {
    [Symbol.iterator]() {
      return this;
    },
    next() {
      if (current < end) {
        return { value: current++, done: false };
      }
      return { value: undefined, done: true };
    },
  };
}

console.log([...range(1, 4)]);
```

Every step is manual here: track `current`, decide when to stop, and return the right shape. The spread operator calls `next()` until `done` is `true`, collecting each `value`. The `current` variable lives in a closure, which you already know from lesson 3. It's the state that lets `next()` remember where it is.

> **Pitfall:** This iterator is single-use. The first full pass moves `current` to `end`, and every later pass sees `done` immediately. Many built-in iterators behave the same way, and `Map.prototype.entries()` returns a fresh iterator each time, which is why you can loop over the same `Map` twice but not over the same iterator object twice.

## Generators write the state machine for you

A `function*` declaration creates a generator function. Calling it doesn't run the body. It returns a generator object, which is an iterator. The body runs when `next()` is first called, and it pauses at each `yield`, handing that value to the caller.

```js run
function* rangeGen(start, end) {
  for (let n = start; n < end; n++) {
    yield n;
  }
}

console.log([...rangeGen(1, 4)], Array.from(rangeGen(0, 3), (n) => n * 10));
```

`rangeGen` does the same job as the hand-written iterator in four lines. The loop variable and the stop condition are the state, and the engine keeps them between calls. `Array.from` takes an optional map function as its second argument, so you can transform each value as it's collected.

> **Under the hood:** A generator object stores where its body paused, along with its local variables. Each `next()` resumes execution from that point until the next `yield` or `return`. The engine doesn't copy the function. It keeps the same stack frame alive in a suspended state.

## Lazy sequences and infinite data

Because nothing runs until you ask for the next value, a generator can describe an infinite sequence. The consumer decides how much to read.

```js run
function* naturals() {
  let n = 1;
  while (true) {
    yield n++;
  }
}

function* take(source, count) {
  if (count <= 0) {
    return;
  }
  let taken = 0;
  for (const value of source) {
    yield value;
    taken += 1;
    if (taken === count) {
      return;
    }
  }
}

console.log([...take(naturals(), 5)]);
```

`naturals()` would never finish if it were spread directly, so `take` limits it. `take` is itself a generator, so it's lazy too: it asks `naturals` for a value only when its own consumer asks for one. Chaining generators like this is how you build a pipeline that processes one item at a time, without building intermediate arrays.

> **Pitfall:** Spreading or calling `Array.from` on an infinite generator never returns. Always put a limit between an unbounded source and anything that collects it.

## Cleanup when a loop stops early

When a `for...of` loop exits early, through `break`, `return` or a thrown error, the engine calls the iterator's `return()` method. For a generator, that resumes it with a return at the current `yield`, which runs any `finally` blocks. That's how generators release files, locks or connections no matter how the loop ends.

```js run
function* lines() {
  try {
    yield "first";
    yield "second";
    yield "third";
  } finally {
    console.log("cleanup ran");
  }
}

for (const line of lines()) {
  console.log(line);
  if (line === "second") {
    break;
  }
}
```

The loop stops after `"second"`, and `"third"` is never produced. But the `finally` still runs, because `break` closed the generator. A hand-written iterator would have to implement `return()` itself to get this, which is one reason generators are the safer default.

## Challenge: chunk a sequence lazily

A chunk generator groups items into arrays of a given size, and yields each group as soon as it's full. The last group may be shorter. Write it lazily, so it works with any iterable, including ones with no end.

```js exercise id=chunk-lazily title="Chunk a sequence"
function* chunk(items, size) {
  // TODO: yield arrays of `size` consecutive items from any iterable.
  // The final array may be shorter. Don't convert the input to an array first.
  return null;
}
--- solution
function* chunk(items, size) {
  let group = [];
  for (const item of items) {
    group.push(item);
    if (group.length === size) {
      yield group;
      group = [];
    }
  }
  if (group.length > 0) {
    yield group;
  }
}
--- test
assertEqual([...chunk([1, 2, 3, 4, 5], 2)], [[1, 2], [3, 4], [5]], "Five items in pairs should leave one short group at the end");
assertEqual([...chunk([], 3)], [], "An empty input should yield nothing");
assertEqual([...chunk(["a", "b"], 5)], [["a", "b"]], "A size bigger than the input should yield one short group");
function* numbersForever() {
  let n = 0;
  while (true) {
    yield n++;
  }
}
const first = chunk(numbersForever(), 3).next().value;
assertEqual(first, [0, 1, 2], "chunk must pull values lazily, so it can start on an infinite source");
--- hint
Keep a `group` array. Push each item, and when it reaches `size`, yield it and start a new group.
--- hint
After the loop, yield the leftover group if it isn't empty. Remember that `yield group;` pauses until the caller asks again, so the `group = []` line runs on the next call.
```

## Challenge: an infinite Fibonacci generator

Write a generator that produces the Fibonacci numbers forever, starting from 0 and 1. The test will stop it with `break`, so the generator only needs to be correct at each step.

```js exercise id=fibonacci-stream title="Fibonacci stream"
function* fibonacci() {
  // TODO: yield 0, 1, 1, 2, 3, 5, ... forever.
  return null;
}
--- solution
function* fibonacci() {
  let a = 0;
  let b = 1;
  while (true) {
    yield a;
    [a, b] = [b, a + b];
  }
}
--- test
const seen = [];
for (const value of fibonacci()) {
  seen.push(value);
  if (seen.length === 9) {
    break;
  }
}
assertEqual(seen, [0, 1, 1, 2, 3, 5, 8, 13, 21], "The first nine Fibonacci numbers should appear in order");
const it = fibonacci();
it.next();
it.next();
assertEqual(it.next().value, 1, "The third value should be 1");
assertEqual(typeof it.next().value, "number", "The sequence should keep going");
--- hint
Keep two variables, the current number and the next one. Each step yields the current number and then moves both forward.
--- hint
Inside `while (true)`, yield `a`, then update with `[a, b] = [b, a + b];`. The destructuring swap avoids a temporary variable.
```

## Debug: the generator that ran out

This function should report how many words a sentence has, and what its first word is. It reports the count correctly, but the first word is `undefined`. The bug is about how far the iterator has already moved.

```js debug id=exhausted-generator title="Fix the exhausted generator"
function* wordsOf(text) {
  for (const word of text.split(" ")) {
    yield word;
  }
}
function summarize(text) {
  const words = wordsOf(text);
  const count = [...words].length;
  const first = [...words][0];
  return [count, first];
}
--- solution
function* wordsOf(text) {
  for (const word of text.split(" ")) {
    yield word;
  }
}
function summarize(text) {
  const words = [...wordsOf(text)];
  return [words.length, words[0]];
}
--- test
assertEqual(summarize("the quick fox"), [3, "the"], "summarize should count three words and return the first");
assertEqual(summarize("hello"), [1, "hello"], "A single word should count as one and be its own first word");
--- hint
Run it and look at the first value. Then ask how many times the generator can be read before it's finished.
--- hint
A generator object can only be read once. Collect its values into an array once, and use the array for both the count and the first word.
```

## Predict: when the body runs

A generator's body doesn't start when you create the generator. Trace what gets pushed to the log, in order, as the program runs.

```js predict id=predict-gen-laziness title="Predict the generator trace"
const trace = [];
function* numbers() {
  trace.push("start");
  yield 1;
  trace.push("after 1");
  yield 2;
  trace.push("after 2");
}
const it = numbers();
trace.push("created");
it.next();
trace.push("paused");
it.next();
console.log(trace.join(", "));
--- options
* created, start, paused, after 1
start, created, paused, after 1
created, start, after 1, paused
created, start, paused, after 1, after 2
--- explain
Calling `numbers()` only creates the generator object, so `"start"` isn't logged yet. `"created"` is pushed next. The first `it.next()` runs the body until `yield 1`, which logs `"start"` on the way. Then `"paused"` is pushed. The second `next()` resumes right after the `yield`, logging `"after 1"`, and it pauses at `yield 2`. The line `"after 2"` never runs, because nothing asks for a third value.
```

## Recap

- An iterator is an object with `next()` that returns `{ value, done }`. An iterable provides one at `Symbol.iterator`, and `for...of`, spread and destructuring all use it.
- A generator function returns a generator object. Its body runs only when `next()` is called, and it pauses at each `yield`.
- Generators are lazy, so they can describe infinite sequences. Put a limit between an unbounded source and anything that collects it.
- When a loop exits early, the generator's `return()` runs its `finally` blocks, which is how cleanup happens reliably.
- A generator object can be consumed only once. Collect it into an array when you need more than one pass.

**Up next:** proxies and `Reflect`, which intercept the operations on an object itself, such as property reads, writes and deletes, so you can observe or change how the language treats it.
