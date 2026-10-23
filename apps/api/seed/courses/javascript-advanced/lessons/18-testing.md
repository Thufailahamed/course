Tests are the only part of your code that describes what it's supposed to do, in a form a machine can check on every change. A good test suite lets you refactor a module at 5 p.m. on a Friday and still sleep. A bad one, full of brittle mocks and assertions nobody understands, slows every change down and eventually gets skipped. The difference is rarely the test framework. It's whether the tests check behavior, whether they run deterministically, and whether they can fail for the right reason.

This lesson takes the machinery apart. You'll build a small test runner so you know what Jest or Vitest is doing for you, learn the assertion and async pitfalls that cause false passes, and write test doubles (stubs, spies and fake clocks) that isolate the code under test from time, network and randomness.

## What a test runner does

Strip away the features and a test runner is three things: a registry of named functions, a loop that calls each one inside a `try`, and a summary. The loop is where the important rules live. The cells below build a minimal version, with `expectEqual` standing in for an assertion library:

```js run
const tests = [];
function test(name, fn) {
  tests.push({ name, fn });
}
function expectEqual(actual, expected) {
  const a = JSON.stringify(actual);
  const e = JSON.stringify(expected);
  if (a !== e) throw new Error(`expected ${e} but got ${a}`);
}
console.log("helpers ready:", typeof test, typeof expectEqual);
```

Registering tests does nothing on its own. Notice that the test bodies are not called here; they're stored. The runner decides when to call them, in what order, and how to report the result.

```js run
test("adds numbers", () => expectEqual(2 + 3, 5));
test("sorts numerically", () => expectEqual([10, 9].sort((a, b) => a - b), [9, 10]));
test("catches the default sort mistake", () => expectEqual([10, 9].sort(), [9, 10]));
console.log("registered:", tests.length);
```

Now the runner. It awaits each test, so async tests work, and it catches failures per test, so one broken test doesn't hide the others:

```js run
async function runAll() {
  let passed = 0;
  for (const t of tests) {
    try {
      await t.fn();
      passed++;
      console.log("PASS", t.name);
    } catch (err) {
      console.log("FAIL", t.name, "-", err.message);
    }
  }
  console.log(`${passed}/${tests.length} passed`);
}

await runAll();
```

The third test fails for the right reason: `sort()` compares strings by default, so `10` comes before `9`. The failure message names the expected value and the actual one, which is most of what a good assertion library does.

> **Tip:** Make the failure message say what was expected *and* what happened. A message like "assertion failed" forces the reader to rerun the code in their head. Libraries print a diff for exactly that reason.

## Assertions: compare structure, not references

Most assertion mistakes come from comparing with the wrong equality. `===` on two arrays or two objects compares identity, so two identical-looking results are "different" and the test fails for no good reason. Deep equality compares structure. Your `expectEqual` above uses `JSON.stringify`, which is a simple but leaky approximation: it ignores `undefined` properties, it depends on key order, and it can't tell `NaN` from `null`.

The opposite mistake is just as common: a test that passes because it compares too little. `expect(result).toBeTruthy()` passes for any non-empty value. A strong assertion pins down the exact value you care about.

> **Pitfall:** An assertion that can't fail is worse than no assertion, because it reports green. After you write a test, break the code on purpose and confirm the test goes red. This takes ten seconds and catches a surprising number of tests that check nothing.

## Async tests: the missing await

The most dangerous test bug is an async test that doesn't wait. If the function under test returns a promise and the test doesn't await it, the test body finishes first, the runner marks it passed, and the rejection arrives later with nobody listening.

```js run
async function expectRejects(promise) {
  try {
    await promise;
  } catch (err) {
    return err.message;
  }
  throw new Error("expected a rejection");
}
console.log(await expectRejects(Promise.reject(new Error("demo"))));
```

The helper awaits the promise and turns a rejection into a result. Now an async function and a test that uses it:

```js run
async function fetchUser(id) {
  await null;
  if (id < 0) throw new Error("invalid id");
  return { id };
}

test("rejects bad ids", async () => {
  const message = await expectRejects(fetchUser(-1));
  expectEqual(message, "invalid id");
});
console.log("async test registered:", tests.length);
```

Every async assertion needs an `await` (or a `return`) in front of it. Without one, the test body finishes before the promise settles, so a failure arrives after the runner has already marked the test as passed. That's why linters flag floating promises.

## Test doubles: stubs, spies and fakes

A unit test should exercise one piece of logic, but real code reaches out to the network, the clock and the random number generator. A **test double** replaces a dependency with a controlled stand-in. The vocabulary matters less than the principle: pass dependencies in, so a test can substitute them.

```js run
async function greet(loadUser, id) {
  const user = await loadUser(id);
  return `Hello, ${user.name}`;
}

const fakeLoader = async (id) => ({ name: `user${id}` });
console.log(await greet(fakeLoader, 7));
```

`greet` doesn't know whether `loadUser` talks to a server or to a lambda that returns a fixed object. That's dependency injection, and it's the reason most testable code takes its collaborators as arguments.

Three kinds of double come up constantly:

- A **stub** returns canned answers. `fakeLoader` above is a stub.
- A **spy** wraps a real or fake function and records how it was called. You use it to assert "this was called once, with these arguments".
- A **fake** is a working but simplified implementation, such as an in-memory store in place of a database.

A spy is small enough to build from scratch, and the exercise below does exactly that:

```js exercise id=create-spy title="Record every call to a function"
function createSpy(impl = () => undefined) {
  // TODO: return a function that forwards its arguments to `impl` and returns its result.
  // Record the arguments of every call in `spy.calls`, an array of argument arrays.
  return null;
}
--- solution
function createSpy(impl = () => undefined) {
  const spy = (...args) => {
    spy.calls.push(args);
    return impl(...args);
  };
  spy.calls = [];
  return spy;
}
--- test
const add = createSpy((a, b) => a + b);
assertEqual(add(1, 2), 3, "The spy should return what impl returns");
add(10, 20);
assertEqual(add.calls, [[1, 2], [10, 20]], "Each call's arguments should be recorded in order");
const quiet = createSpy();
assertEqual(quiet("x"), undefined, "Without an implementation, the spy returns undefined");
assertEqual(quiet.calls, [["x"]], "Calls without an implementation are still recorded");
--- hint
Use a rest parameter, `(...args)`, to capture the arguments, and `impl(...args)` to forward them. The `calls` array can live on the spy function itself.
--- hint
Inside the spy: `spy.calls.push(args);` then `return impl(...args);`. Set `spy.calls = []` before you return the spy.
```

## Predict: when is the count read?

Spies make it easy to write assertions, and easy to misread the order of evaluation. Predict this output before you check the options.

```js predict id=predict-spy-order title="Reading the spy's record"
const spy = (fn) => {
  const s = (...args) => {
    s.calls.push(args);
    return fn(...args);
  };
  s.calls = [];
  return s;
};
const add = spy((a, b) => a + b);
add(1, 2);
add(3, 4);
console.log(add.calls.length, add.calls[1][0], add(5, 5));
--- options
3 3 10
* 2 3 10
2 4 10
2 3 5
--- explain
Two calls are recorded before the `console.log`, so `add.calls.length` is 2 and `add.calls[1][0]` is 3, the first argument of the second call. Arguments are evaluated left to right, and the third call `add(5, 5)` returns 10 and is recorded after the length has already been read. The third value is the return value of the call, not part of the record at that moment.
```

## The false green: a runner that doesn't await

Now the bug that real test suites hit when someone writes a tiny runner of their own. The runner calls each test but doesn't wait for async ones. Read it, then predict what it reports for a test that fails asynchronously.

```js debug id=run-async-tests title="The test that passed too early"
// Run each test, and report whether it passed. Async tests must be awaited, so their failures are caught.
async function runTests(tests) {
  const results = [];
  for (const [name, fn] of tests) {
    try {
      fn();
      results.push({ name, passed: true });
    } catch (err) {
      results.push({ name, passed: false, error: err.message });
    }
  }
  return results;
}
--- solution
async function runTests(tests) {
  const results = [];
  for (const [name, fn] of tests) {
    try {
      await fn();
      results.push({ name, passed: true });
    } catch (err) {
      results.push({ name, passed: false, error: err.message });
    }
  }
  return results;
}
--- test
// The rejection is handled here, so a runner that drops the promise does not leave an unhandled rejection.
const failing = () => {
  const p = Promise.reject(new Error("boom"));
  p.catch(() => {});
  return p;
};
const results = await runTests([
  ["sync pass", () => {}],
  ["async fail", failing],
]);
assertEqual(results[0].passed, true, "A passing sync test should pass");
assertEqual(results[1].passed, false, "An async test that rejects must be reported as failed");
assertEqual(results[1].error, "boom", "The error message should be kept");
--- hint
`try` only catches errors that happen during the synchronous call. What does `fn()` return for an async function, and where does its error go?
--- hint
Await the result of `fn()` inside the `try`. An awaited rejection is thrown into the `catch`, just like a synchronous error.
```

The starter's test reports a pass for the async failure, and the rejection is left floating. This is the same mistake as the missing `await` above, now living inside the tool that's supposed to catch it. Any function that calls user-supplied callbacks needs to decide whether they can be async, and then honor that decision.

## Testing time without waiting for it

Code that depends on the clock or on timers is hard to test, because a real test would have to wait. The fix is to inject the clock. Here is a fake clock that runs scheduled callbacks when you advance time, so a test can say "move forward 15 milliseconds" and finish instantly.

```js exercise id=fake-clock title="A fake clock that runs timers on demand"
function createFakeClock() {
  // TODO: return an object with:
  // now(): the current fake time, starting at 0
  // setTimeout(fn, delay): schedule fn to run at now() + delay
  // advance(ms): move time forward by ms, running due timers in time order
  return null;
}
--- solution
function createFakeClock() {
  let time = 0;
  const timers = [];
  return {
    now: () => time,
    setTimeout(fn, delay) {
      timers.push({ at: time + delay, fn });
      timers.sort((a, b) => a.at - b.at);
    },
    advance(ms) {
      const target = time + ms;
      while (timers.length && timers[0].at <= target) {
        const next = timers.shift();
        time = next.at;
        next.fn();
      }
      time = target;
    },
  };
}
--- test
const clock = createFakeClock();
const log = [];
clock.setTimeout(() => log.push("b"), 20);
clock.setTimeout(() => log.push("a"), 10);
assertEqual(log, [], "Nothing should run before time advances");
clock.advance(15);
assertEqual(log, ["a"], "Only timers that are due should run");
assertEqual(clock.now(), 15, "Time should land on the advanced point");
clock.advance(10);
assertEqual(log, ["a", "b"], "Later timers should run when their time arrives");

const second = createFakeClock();
const order = [];
second.setTimeout(() => {
  order.push("first");
  second.setTimeout(() => order.push("nested"), 5);
}, 10);
second.advance(20);
assertEqual(order, ["first", "nested"], "A timer scheduled inside the window should run in the same advance");
--- hint
Keep an array of `{ at, fn }` records. `advance` should loop while the earliest timer is due, and set `time` to each timer's `at` before running it.
--- hint
Sort the array by `at` after each insertion, and in `advance`, call `shift()` on the earliest timer. Set `time = target` once the loop finishes.
```

> **Under the hood:** The fake clock's `advance` sets `time` to each timer's scheduled moment before running it, so code inside a timer that asks `now()` sees the right time. That's the same contract real timers give you, and it's what makes nested scheduling behave the same way in tests as in production.

## What to test, and what to leave alone

A few habits keep a suite useful. Test behavior through the public function, not its internal helpers, so refactors don't break tests. Give each test one reason to fail, and name it after the behavior: "rejects negative ids" tells the reader more than "test 3". Keep tests deterministic, so no real time, no real network and no `Math.random` without a seed. And prefer a few tests on real collaborators over many tests on mocks: when the mocks drift from reality, the tests keep passing while the product breaks.

> **In the wild:** Vitest and Jest give you `describe` and `it` suites, `vi.fn()` or `jest.fn()` spies, and fake timers. Under the hood they do what the mini runner above does: they register tests, await them, and report the outcome. Knowing that makes their failure messages and their "why did this pass?" moments much less mysterious.

## Recap

- A test runner registers functions, awaits each one inside a `try`, and reports per test, so one failure never hides the rest.
- Compare structure with deep equality, and make each assertion specific enough to fail when the behavior changes.
- Await every async assertion. A missing `await` produces a green test that checks nothing.
- Inject dependencies so tests can replace them with stubs, spies and fakes.
- Inject the clock too: a fake clock turns "wait 10 seconds" into a deterministic `advance(10000)`.
- Break your code on purpose now and then, and confirm your tests go red.

**Up next:** design patterns in JavaScript, where observer, factory and strategy show up in code you already use.
