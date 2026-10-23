This last project pulls the whole course together. You'll build a **budget tracker**: a `Budget` class that records expenses against a monthly limit, totals them by category, rejects bad input with clear errors, and saves itself to JSON so the data survives a reload. Then you'll write one function that reads a saved budget and turns it into a report.

The project has five stages, and each one is a challenge with tests. The stages build on each other, so each starter includes the class as you've written it so far. You'll use classes, methods, getters, objects, loops, `try`/`catch` and JSON, all of which you've now practiced. Nothing new is introduced, but the pieces have to fit together, which is the real skill this project trains.

## The design first

Before writing any code, decide what the object must do. A `Budget` has a monthly `limit`, and it keeps a list of expenses. Each expense has a `category` and an `amount`. From that data, it should be able to report a total, a total by category, and the money remaining. It should also save and load itself. Everything else, including the report, can be built from those few methods.

Here's a quick preview of the data shape, written as a plain object. Classes are just a tidier way to hold and act on this same shape:

```js run
const saved = {
  limit: 200,
  expenses: [
    { category: "Food", amount: 25.5 },
    { category: "Rent", amount: 120 },
  ],
};

console.log(saved.limit, saved.expenses.length);
console.log(saved.expenses[0].category, saved.expenses[0].amount);
```

## Stage 1: add expenses and total them

A `Budget` starts with a limit and an empty list. The constructor below is already written. Your job is `add`, which records one expense, and a `total` getter that adds up every amount:

```js exercise id=budget-total title="Stage 1: add expenses and total them"
class Budget {
  constructor(limit) {
    this.limit = limit;
    this.expenses = [];
  }

  add(category, amount) {
    // TODO: push an object { category, amount } onto this.expenses
  }

  get total() {
    // TODO: return the sum of every expense amount
    return null;
  }
}
--- solution
class Budget {
  constructor(limit) {
    this.limit = limit;
    this.expenses = [];
  }

  add(category, amount) {
    this.expenses.push({ category: category, amount: amount });
  }

  get total() {
    return this.expenses.reduce((sum, e) => sum + e.amount, 0);
  }
}
--- test
const budget = new Budget(100);
budget.add("Food", 12.5);
budget.add("Fun", 7.5);
assertEqual(budget.total, 20, "12.5 plus 7.5 should total 20");
assertEqual(budget.expenses.length, 2, "Each add should record one expense");
assertEqual(budget.expenses[0], { category: "Food", amount: 12.5 }, "The first expense should be stored as an object");
assertEqual(new Budget(50).total, 0, "A new budget with no expenses should total 0");
--- hint
`add` needs to store one object with two properties. Use `this.expenses.push(...)` and pass `{ category: category, amount: amount }`.
--- hint
For `total`, use `this.expenses.reduce((sum, e) => sum + e.amount, 0)`. Getters are read without parentheses, so `budget.total` gives the number directly.
```

> **Tip:** A getter is the right home for `total`, because it's always computed from the expenses and can never go out of date. Storing the total in a separate field would require updating it in every method that changes the list.

## Stage 2: totals by category

A budget report usually shows how much went to each category. An object is a natural fit: its keys are the category names and its values are the sums. The loop below builds that object for a small list, and it uses the `in` operator to check whether a category has been seen yet:

```js run
const items = [{ category: "Food", amount: 25.5 }, { category: "Food", amount: 14.5 }, { category: "Fun", amount: 30 }];
const totals = {};
for (const item of items) {
  if (!(item.category in totals)) totals[item.category] = 0;
  totals[item.category] = totals[item.category] + item.amount;
}

console.log(totals);
```

Your method does the same job for the expenses stored in the class:

```js exercise id=by-category title="Stage 2: totals by category"
class Budget {
  constructor(limit) {
    this.limit = limit;
    this.expenses = [];
  }

  add(category, amount) {
    this.expenses.push({ category: category, amount: amount });
  }

  get total() {
    return this.expenses.reduce((sum, e) => sum + e.amount, 0);
  }

  byCategory() {
    // TODO: return an object whose keys are categories and whose values are the summed amounts
    return null;
  }
}
--- solution
class Budget {
  constructor(limit) {
    this.limit = limit;
    this.expenses = [];
  }

  add(category, amount) {
    this.expenses.push({ category: category, amount: amount });
  }

  get total() {
    return this.expenses.reduce((sum, e) => sum + e.amount, 0);
  }

  byCategory() {
    const totals = {};
    for (const e of this.expenses) {
      if (!(e.category in totals)) totals[e.category] = 0;
      totals[e.category] = totals[e.category] + e.amount;
    }
    return totals;
  }
}
--- test
const budget = new Budget(200);
budget.add("Food", 25.5);
budget.add("Rent", 120);
budget.add("Food", 14.5);
assertEqual(budget.byCategory(), { Food: 40, Rent: 120 }, "Food should add up to 40 and Rent should stay 120");
assertEqual(new Budget(10).byCategory(), {}, "No expenses should give an empty object");
assertEqual(budget.total, 160, "byCategory should not change the total");
--- hint
Start with `const totals = {};`. Loop over `this.expenses`, and for each one add its amount to `totals[e.category]`.
--- hint
A category that isn't in `totals` yet has no value to add to. Set it to `0` first, using `if (!(e.category in totals))`, then add the amount.
```

## Stage 3: reject bad input

A budget that accepts `-5`, `0` or `"abc"` will produce nonsense totals, and nothing will tell you why. The right fix is to check each amount when it arrives and throw an error with a clear message. Errors are the place for that, because the caller can decide how to handle a bad entry.

The rule is: an amount must be a number, and it must be greater than zero. Here's the trap. The check below looks reasonable, but it lets a value through. This is your debug challenge:

```js debug id=validate-amount title="Stage 3: validate the amount"
class Budget {
  constructor(limit) {
    this.limit = limit;
    this.expenses = [];
  }

  add(category, amount) {
    if (amount < 0) {
      throw new Error("Amount must be a number greater than zero");
    }
    this.expenses.push({ category: category, amount: amount });
  }

  get total() {
    return this.expenses.reduce((sum, e) => sum + e.amount, 0);
  }
}
--- solution
class Budget {
  constructor(limit) {
    this.limit = limit;
    this.expenses = [];
  }

  add(category, amount) {
    if (typeof amount !== "number" || !(amount > 0)) {
      throw new Error("Amount must be a number greater than zero");
    }
    this.expenses.push({ category: category, amount: amount });
  }

  get total() {
    return this.expenses.reduce((sum, e) => sum + e.amount, 0);
  }
}
--- test
const budget = new Budget(100);
let errors = 0;
for (const bad of [0, -5, "abc"]) {
  try {
    budget.add("Food", bad);
  } catch (error) {
    errors = errors + 1;
  }
}
assertEqual(errors, 3, "0, -5 and 'abc' should each throw an error");
assertEqual(budget.expenses.length, 0, "Rejected amounts must not be recorded");
budget.add("Food", 12.5);
assertEqual(budget.total, 12.5, "A valid amount should still be accepted");
--- hint
Look at the boundary first. Does `0` make it past `amount < 0`? Use a check that also rejects `0`.
--- hint
Also consider the type. `"abc" < 0` is `false`, so a string gets past the check. A test like `typeof amount !== "number"` catches that case. Combine both checks with `||`.
```

Now, the last part of this stage is how the error is handled. A `try` around `add` catches the bad entry so the program can keep going, which is the pattern for a form where a single bad value shouldn't crash the whole app.

```js run
const demo = { limit: 50, expenses: [] };
for (const value of [10, -3]) {
  try {
    if (value <= 0) throw new Error("Amount must be greater than zero: " + value);
    demo.expenses.push(value);
  } catch (error) {
    console.log(error.message);
  }
}

console.log(demo.expenses);
```

> **Pitfall:** Validating only at the moment of saving is too late. Check every amount at the door, in `add`, so the data inside the object is always valid. Then every other method can trust it.

## Stage 4: save and load as JSON

A budget that disappears when the page closes isn't very useful. JSON is the standard way to save data as text, and you learned to use it in the last lesson. The `save` method turns the state into a JSON string. The static `load` method reads that text and builds a new `Budget`:

```js run
const data = JSON.parse('{"limit":200,"expenses":[{"category":"Food","amount":12.5}]}');

console.log(data.limit, data.expenses[0].category);
console.log(JSON.stringify(data));
```

A `static` method belongs to the class itself, not to an instance. You call it as `Budget.load(text)`, and it returns a new `Budget`. Your task: write `save` and `load`, reusing `add` in `load` so that loaded data is validated too:

```js exercise id=save-load title="Stage 4: save and load a budget"
class Budget {
  constructor(limit) {
    this.limit = limit;
    this.expenses = [];
  }

  add(category, amount) {
    if (typeof amount !== "number" || !(amount > 0)) {
      throw new Error("Amount must be a number greater than zero");
    }
    this.expenses.push({ category: category, amount: amount });
  }

  get total() {
    return this.expenses.reduce((sum, e) => sum + e.amount, 0);
  }

  save() {
    // TODO: return JSON text with the limit and the expenses
    return null;
  }

  static load(text) {
    // TODO: parse the text, create a new Budget with the saved limit,
    // add each saved expense with add(), and return the new budget
    return null;
  }
}
--- solution
class Budget {
  constructor(limit) {
    this.limit = limit;
    this.expenses = [];
  }

  add(category, amount) {
    if (typeof amount !== "number" || !(amount > 0)) {
      throw new Error("Amount must be a number greater than zero");
    }
    this.expenses.push({ category: category, amount: amount });
  }

  get total() {
    return this.expenses.reduce((sum, e) => sum + e.amount, 0);
  }

  save() {
    return JSON.stringify({ limit: this.limit, expenses: this.expenses });
  }

  static load(text) {
    const data = JSON.parse(text);
    const budget = new Budget(data.limit);
    for (const e of data.expenses) {
      budget.add(e.category, e.amount);
    }
    return budget;
  }
}
--- test
const budget = new Budget(100);
budget.add("Food", 12.5);
budget.add("Rent", 80);
const text = budget.save();
assertEqual(typeof text, "string", "save() should return text");
const loaded = Budget.load(text);
assert(loaded instanceof Budget, "load() should return a Budget");
assertEqual(loaded.limit, 100, "The limit should survive the round trip");
assertEqual(loaded.total, 92.5, "The expenses should survive the round trip");
assertEqual(budget.total, 92.5, "Saving must not change the original budget");
--- hint
For `save`, call `JSON.stringify` with an object that has the `limit` and the `expenses` properties.
--- hint
In `load`, use `JSON.parse(text)` to get the data, then `new Budget(data.limit)`. Loop over `data.expenses` and call `budget.add(e.category, e.amount)` for each one.
```

> **Under the hood:** `JSON.stringify` saves only own data properties. The `total` getter lives on the class, not on the object, so it's never written to the text. That's why `load` must rebuild totals by adding the expenses again.

Here's a prediction question about exactly that behavior. Work out what each part prints:

```js predict id=getters-not-saved title="What does this print?"
class Pair {
  constructor(a, b) {
    this.a = a;
    this.b = b;
  }

  get sum() {
    return this.a + this.b;
  }
}

console.log(JSON.stringify(new Pair(2, 3)), new Pair(2, 3).sum);
--- options
{"a":2,"b":3,"sum":5} 5
* {"a":2,"b":3} 5
{"a":2,"b":3} 2
{} 5
--- explain
`JSON.stringify` writes the object's own data properties, `a` and `b`. The getter `sum` is defined on the class, so it isn't part of the saved text. Reading `new Pair(2, 3).sum` runs the getter and returns `5`. This is why `load` rebuilds the state from the raw expenses rather than trusting any saved totals.
```

## Stage 5: the budget report

The final function reads saved budget text and returns a report: one line per category in alphabetical order, then the total and what remains. This time you don't need the class at all. The saved text has a known shape, an object with a `limit` and an array of `expenses`, so a plain function can read it directly. That's a useful design check: if your saved data is clear, any part of the program can use it.

Your function gets the text, parses it, groups the amounts by category, and builds the lines. Use an object for the totals, as you did in stage 2, and sort the category names with `sort()`:

```js exercise id=budget-report title="Stage 5: the budget report"
function budgetReport(text) {
  // TODO: parse the saved text, which looks like {"limit":200,"expenses":[{"category":"Food","amount":25.5}]}
  // Sum the amounts per category. Return an array of lines:
  // "Category: total" for each category in alphabetical order, then
  // "Total: <sum of all amounts> of <limit>", then "Remaining: <limit minus the sum>".
  return null;
}
--- solution
function budgetReport(text) {
  const data = JSON.parse(text);
  const totals = {};
  let sum = 0;
  for (const e of data.expenses) {
    if (!(e.category in totals)) totals[e.category] = 0;
    totals[e.category] = totals[e.category] + e.amount;
    sum = sum + e.amount;
  }
  const lines = Object.keys(totals).sort().map((name) => `${name}: ${totals[name]}`);
  lines.push(`Total: ${sum} of ${data.limit}`);
  lines.push(`Remaining: ${data.limit - sum}`);
  return lines;
}
--- test
const text = JSON.stringify({
  limit: 200,
  expenses: [
    { category: "Food", amount: 25.5 },
    { category: "Rent", amount: 120 },
    { category: "Food", amount: 14.5 },
    { category: "Fun", amount: 30 },
  ],
});
assertEqual(
  budgetReport(text),
  ["Food: 40", "Fun: 30", "Rent: 120", "Total: 190 of 200", "Remaining: 10"],
  "The report should list categories alphabetically, then the total and what is left"
);
assertEqual(budgetReport('{"limit":50,"expenses":[]}'), ["Total: 0 of 50", "Remaining: 50"], "An empty budget should still give a total and remaining line");
--- hint
Start with `JSON.parse(text)`. The expenses are in `data.expenses`, and the limit is `data.limit`.
--- hint
Group the amounts exactly as in stage 2, with an object keyed by category. `Object.keys(totals).sort()` gives the names in alphabetical order, and a template literal turns each one into a line.
```

## Running the whole tracker

Once all five stages pass, the class and the report function form a complete tracker. Create a budget, add a few expenses, save it, and show the report from the saved text. Load the same text into a second budget and compare the totals. If the two agree, your save and load code is correct. The check is a quick way to test a round trip, which is exactly the kind of confidence that real data code needs.

> **In the wild:** Budgeting apps, expense trackers and accounting tools all follow this design: a validated record, totals computed from the records rather than stored separately, and a text format for saving. The same ideas show up in shopping carts, invoices and game inventories. Once you see the pattern, you can build any of them.

## What you built

You now have three complete projects behind you. In this one you combined classes with getters and static methods, objects used as maps, validation with `throw` and `try`, and JSON for saving and loading. The most important lesson isn't any single feature. It's the habit of keeping data valid at the boundary, computing derived values instead of storing them, and testing each piece before the next one depends on it.

## Recap

- A class holds data and the methods that work on it. Add a `get` for values that can always be computed from that data.
- Use an object as a map from keys to totals, and check `key in obj` before you add to it.
- Validate input where it enters the program, throw a clear `Error`, and let the caller decide how to recover.
- `JSON.stringify` saves own data properties only. Getters are rebuilt by the code, not restored from the text.
- A `static` method, such as `Budget.load(text)`, belongs to the class and returns a new instance.

**Up next:** Final exam: JavaScript Basics. Ten questions across the whole course, to check how much of the language you can now read and write with confidence.
