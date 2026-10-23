An object lives in memory and disappears when your program stops. To keep it, send it to another program, or store it in a file, you need to turn it into text first. JSON (JavaScript Object Notation) is the text format that nearly every API, configuration file and web app uses for that job. A weather service replies with JSON, a settings file is usually JSON, and a browser stores much of its state as JSON.

The good news is that JSON looks almost exactly like a JavaScript object literal. The bad news is that it's stricter, and not every value survives the trip. This page shows you how to convert in both directions with `JSON.stringify` and `JSON.parse`, how to control what gets saved, and which values silently disappear or change type along the way.

## JSON is text

JSON is a string that describes data. Keys and text values must use double quotes, and there are no comments, no trailing commas and no functions:

```js run
const book = { title: "Dune", year: 1965, tags: ["classic", "sci-fi"] };

const text = JSON.stringify(book);
console.log(text);
console.log(typeof text);
```

`JSON.stringify` turns a value into a string. The result is text, not an object, which is why `typeof text` is `"string"`. You can send that string over a network, write it to a file, or store it in a database.

To make the text easier to read, pass a number for indentation as the third argument:

```js run
const settings = { theme: "dark", fontSize: 14, panels: ["notes", "tasks"] };

console.log(JSON.stringify(settings, null, 2));
```

The `null` is the replacer, which we'll use in a moment. The `2` means each level is indented by two spaces. Use indentation for files that people will read or edit by hand.

## JSON.parse: text back into data

`JSON.parse` does the reverse. It reads a JSON string and builds the matching object, array, number, string, boolean or `null`:

```js run
const parsed = JSON.parse('{"city":"Leeds","open":true,"visits":[3,5]}');

console.log(parsed.city, parsed.open);
console.log(parsed.visits[1] + 1);
```

Because the result is a regular object, everything from the objects lesson applies: dot notation, loops and methods all work on it.

> **Pitfall:** `JSON.parse` is strict. Single quotes, unquoted keys and trailing commas are all syntax errors. The text `{'name': 'Ada'}` looks fine to a person, but it throws a `SyntaxError`, so wrap parsing of untrusted or user-supplied text in `try`/`catch`.

```js run
try {
  JSON.parse("{'name': 'Ada'}");
} catch (error) {
  console.log(error.name);
}
```

## What JSON keeps, and what it drops

JSON can represent only six kinds of value: objects, arrays, strings, numbers, booleans and `null`. Anything else is converted or removed when you stringify it. This is the most common source of "my data came back wrong" bugs:

```js run
const record = {
  when: new Date(Date.UTC(2026, 0, 5)),
  seen: new Set(["a"]),
  score: NaN,
  note: undefined,
  label: () => "hi",
};

console.log(JSON.stringify(record));
```

- A `Date` becomes its ISO string, so you get back text, not a `Date`.
- A `Set` has no JSON form, so it becomes `{}`.
- `NaN` and `Infinity` become `null`.
- `undefined` and functions are left out of objects entirely.

> **Pitfall:** `JSON.stringify` doesn't throw for these values, so the bug is silent. Before you save data, make sure every value is one of the six JSON types, or convert it explicitly. Store a `Date` as a string you can parse back, and a `Set` as an array.

Here is the first challenge, which fixes exactly that kind of bug. This function should save a set of tags, but it returns `"{}"`:

Look at the function and decide what shape of data JSON needs. Your fix must return text that parses back to the same list of tags, and an empty set must give `"[]"`.

```js debug id=save-tags title="Save a Set as an array"
function saveTags(tags) {
  return JSON.stringify(tags);
}
--- solution
function saveTags(tags) {
  return JSON.stringify([...tags]);
}
--- test
assertEqual(JSON.parse(saveTags(new Set(["a", "b"]))), ["a", "b"], "The saved text should parse back to the array of tags");
assertEqual(saveTags(new Set()), "[]", "An empty set should save as an empty JSON array");
assertEqual(JSON.parse(saveTags(new Set(["x"]))), ["x"], "A single tag should be saved too");
--- hint
A `Set` is not an array, so JSON can't see its items. Think about how to turn the set's items into an array before stringifying.
--- hint
Spread the set into a new array with `[...tags]`, then pass that array to `JSON.stringify`.
```

## The replacer: choosing what to save

The second argument of `JSON.stringify` can be a function that runs for every key and value. Return the value to keep it, or `undefined` to drop the key. It's the right tool when you want to save a record without sensitive fields.

Here's the exercise. Write a function that saves a user record as JSON, without the password:

```js exercise id=save-record title="Save a record without its password"
function saveRecord(record) {
  // TODO: return the record as JSON text, with the password key left out
  return null;
}
--- solution
function saveRecord(record) {
  return JSON.stringify(record, (key, value) => (key === "password" ? undefined : value));
}
--- test
const saved = saveRecord({ name: "Ada", password: "secret", age: 36 });
assert(typeof saved === "string", "saveRecord should return text");
assert(!saved.includes("secret"), "The password value must not appear in the text");
assertEqual(JSON.parse(saved), { name: "Ada", age: 36 }, "Name and age should be kept exactly");
assertEqual(JSON.parse(saveRecord({ id: 7 })), { id: 7 }, "Records without a password should save normally");
--- hint
Pass a second argument to `JSON.stringify`: a function that receives `(key, value)`. Return `undefined` when the key is `"password"`.
--- hint
Inside the replacer, `return key === "password" ? undefined : value;` keeps every other key exactly as it is.
```

> **Under the hood:** The replacer runs once for the top-level object (with an empty key) and then once for every property, including those inside nested arrays and objects. That's why a single replacer can filter a whole tree of data.

## Deep copies with a round trip

Spread copies only one level deep. A JSON round trip, `JSON.parse(JSON.stringify(value))`, copies everything inside a plain-data structure, because it builds every object and array again from text:

```js run
const original = { name: "Ada", scores: [90, 85] };
const copy = JSON.parse(JSON.stringify(original));

copy.scores.push(100);
console.log(original.scores, copy.scores);
```

Be careful about what the round trip loses. Dates come back as strings, and `undefined`, functions and `Set`s are gone. Use it for plain data, such as settings or API responses, and use a structured copy for anything richer.

Now a function that reads a list of numbers from JSON text. Your job is to parse the text and add up the prices inside it:

```js exercise id=total-from-json title="Total the prices in JSON text"
function totalFromJson(text) {
  // TODO: parse the JSON text, then return the sum of every item's price
  // The text looks like {"items":[{"price":2.5},{"price":4}]}
  return null;
}
--- solution
function totalFromJson(text) {
  const data = JSON.parse(text);
  return data.items.reduce((total, item) => total + item.price, 0);
}
--- test
assertEqual(totalFromJson('{"items":[{"price":2.5},{"price":4}]}'), 6.5, "2.5 and 4 should total 6.5");
assertEqual(totalFromJson('{"items":[{"price":10}]}'), 10, "A single item should total its own price");
assertEqual(totalFromJson('{"items":[]}'), 0, "An empty list of items should total 0");
--- hint
Start with `JSON.parse(text)` to turn the text into an object you can use. Then the items are in `data.items`.
--- hint
Use `data.items.reduce(...)` with a starting value of `0`, and add each `item.price` to the running total.
```

Here is a prediction question about what survives the trip. Work out which values disappear before you check:

```js predict id=json-drops-values title="What does this print?"
console.log(JSON.stringify({ a: undefined, b: 1, c: [undefined] }));
--- options
{"a":null,"b":1,"c":[null]}
* {"b":1,"c":[null]}
{"b":1,"c":[]}
{"a":undefined,"b":1,"c":[undefined]}
--- explain
Inside an object, a key whose value is `undefined` is left out completely, so `a` disappears. Inside an array, `undefined` can't be skipped without shifting positions, so JSON writes it as `null`. The result is `{"b":1,"c":[null]}`. Text in JSON never contains the word `undefined`.
```

> **In the wild:** Most web APIs send and receive JSON, and so do configuration files like `package.json` and the data many apps keep in `localStorage`. When something looks wrong after a save-and-reload, the cause is often one of the lossy conversions in this lesson, such as a date that came back as text.

## Recap

- `JSON.stringify(value)` turns data into text. A third argument, such as `2`, adds indentation.
- `JSON.parse(text)` turns JSON text back into data. Bad text throws a `SyntaxError`, so guard it with `try`/`catch`.
- JSON only has objects, arrays, strings, numbers, booleans and `null`. Dates become strings, `Set`s become `{}`, and `undefined` values are dropped from objects.
- A replacer function, passed as the second argument to `JSON.stringify`, lets you filter or change values as they're saved.
- A round trip, `JSON.parse(JSON.stringify(x))`, makes a deep copy of plain data.

**Up next:** Dates and time, without the traps: creating dates, doing arithmetic with them, and keeping time zones from ruining your results.
