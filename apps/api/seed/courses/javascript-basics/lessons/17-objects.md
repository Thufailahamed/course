Real data rarely arrives as a loose pile of values. A student has a name, a list of scores and an enrollment year. A product has a price, a stock count and a category. You need a way to keep those pieces together under their own names, and that's what an object is for. Almost every API response, configuration file and settings panel you'll meet in JavaScript is an object, or a list of them.

This page covers how to create objects, read and change their properties, store functions inside them as methods, and loop over their contents. It also covers the rule that surprises most beginners: an object is shared, not copied, when you assign it to another variable.

## Creating an object

An object literal is a list of `key: value` pairs inside curly braces. Each key is a property name, and each value can be anything: a number, a string, an array, or another object:

```js run
const student = {
  name: "Ada",
  age: 36,
  scores: [91, 84, 77],
  active: true,
};

console.log(student.name, student.scores.length);
console.log(student);
```

The dot notation `student.name` reads the property called `name`. The trailing comma after the last property is allowed, and it makes future edits cleaner.

> **Tip:** Use dot notation when you know the property name when you write the code. Use it for almost everything, because it reads like plain English.

## Bracket notation for dynamic keys

Sometimes the property name is in a variable, or it isn't a valid identifier, such as one with a space. Then you use square brackets with a string inside:

```js run
const prices = { apple: 0.5, "dark chocolate": 3.25 };
const fruit = "apple";

console.log(prices[fruit]);
console.log(prices["dark chocolate"]);
console.log(prices.pear);
```

Reading a property that doesn't exist returns `undefined`. It doesn't throw an error, which is convenient and also how missing data slips through unnoticed. Check for the value you expect before you use it.

## Changing, adding and removing properties

Objects are mutable. You can change an existing property with `=`, add a new one the same way, and remove one with `delete`:

```js run
const cart = { items: 2, coupon: "SPRING" };

cart.items = cart.items + 1;
cart.total = 42.5;
delete cart.coupon;

console.log(cart);
console.log("coupon" in cart);
```

The `in` operator tells you whether a property exists. It's the right test when the value itself could legitimately be `undefined` or `0`.

Here's the first challenge. Write a function that builds a person object with an `isAdult` flag computed from the age:

```js exercise id=make-person title="Build a person object"
function makePerson(name, age) {
  // TODO: return { name, age, isAdult }, where isAdult is true when age is 18 or more
  return null;
}
--- solution
function makePerson(name, age) {
  return { name: name, age: age, isAdult: age >= 18 };
}
--- test
assertEqual(makePerson("Ada", 36), { name: "Ada", age: 36, isAdult: true }, "An adult should have isAdult: true");
assertEqual(makePerson("Sam", 17), { name: "Sam", age: 17, isAdult: false }, "Under 18 should be isAdult: false");
assertEqual(makePerson("Lee", 18), { name: "Lee", age: 18, isAdult: true }, "Exactly 18 counts as an adult");
--- hint
Create an object with three properties. The first two come from the parameters.
--- hint
The third property is a comparison: `age >= 18` already produces `true` or `false`.
```

## Methods: functions stored in objects

A property can hold a function. When it does, it's called a **method**. Inside a method, the keyword `this` refers to the object the method was called on, so the method can read and change that object's own data:

```js run
const counter = {
  count: 0,
  increment() {
    this.count = this.count + 1;
    return this.count;
  },
};

console.log(counter.increment(), counter.increment());
```

`increment() { ... }` is shorthand for `increment: function () { ... }`. The second form is the same thing written out in full.

> **Pitfall:** `this` depends on how a function is called, not where it's written. If you copy a method out of its object, `this` no longer points at the object. Calling `const bump = counter.increment; bump();` loses the link, so `this.count` reads from the wrong place and gives you `undefined` or a `TypeError`. Call methods with the object in front, like `counter.increment()`.

## Looping over an object

You can't loop over an object with `for...of` directly, because an object isn't a list. Ask for its keys, values or both with the built-in functions, and then loop over the array you get back:

```js run
const inventory = { apples: 12, pears: 0, plums: 7 };

console.log(Object.keys(inventory));
console.log(Object.values(inventory));

for (const [name, count] of Object.entries(inventory)) {
  console.log(name, "->", count);
}
```

`Object.entries` returns an array of `[key, value]` pairs, which is the most useful of the three when you need both. The `[name, count]` in the loop is array destructuring, which you'll meet properly in the next lesson.

Now a challenge that uses this. Write a function that adds up every value in an object:

```js exercise id=total-stock title="Total the stock"
function totalStock(stock) {
  // TODO: return the sum of all the numbers stored in the stock object
  return null;
}
--- solution
function totalStock(stock) {
  let total = 0;
  for (const count of Object.values(stock)) {
    total = total + count;
  }
  return total;
}
--- test
assertEqual(totalStock({ apples: 3, pears: 5 }), 8, "3 apples and 5 pears make 8");
assertEqual(totalStock({ plums: 0 }), 0, "A single zero should give 0");
assertEqual(totalStock({}), 0, "An empty object should give 0");
assertEqual(totalStock({ a: 10, b: 20, c: 30 }), 60, "Every property should be included");
--- hint
`Object.values(stock)` gives you an array of the numbers. Loop over that array and add each one to a running total that starts at `0`.
--- hint
Use `for (const count of Object.values(stock))` and add `count` to `total` inside the loop.
```

## Objects are shared, not copied

This is the rule that causes the most real bugs. A variable holding an object stores a *reference* to that object. Assigning the object to a second variable doesn't copy it; both names point at the same thing:

```js run
const original = { city: "Leeds", visits: 1 };
const alias = original;

alias.visits = 2;

console.log(original.visits);
console.log(original === alias);
```

Changing the object through `alias` changed the object that `original` also sees. The `const` keyword doesn't change this. It stops you from reassigning the name `original` to a different value, but the object it refers to can still be modified freely.

> **Pitfall:** `const` protects the variable, not the object. `const user = { name: "Ada" }; user.name = "Grace";` is allowed. If a function receives an object and changes it, the caller sees the change too.

To make a real copy, create a new object and copy the properties into it. `Object.assign` does that. The next lesson introduces spread syntax, a shorter way to do the same job.

```js run
const profile = { name: "Ada", city: "Leeds" };
const copy = Object.assign({}, profile);

copy.city = "York";

console.log(profile.city, copy.city);
```

Here is the debug challenge. This function is supposed to return an updated profile without touching the one it received. It doesn't:

```js debug id=with-city title="Stop changing the caller's object"
function withCity(profile, city) {
  const copy = profile;
  copy.city = city;
  return copy;
}
--- solution
function withCity(profile, city) {
  return Object.assign({}, profile, { city: city });
}
--- test
const original = { name: "Ada", city: "Leeds", visits: 4 };
const updated = withCity(original, "York");
assertEqual(updated.city, "York", "The returned profile should have the new city");
assertEqual(updated.name, "Ada", "Other properties should be kept");
assertEqual(updated.visits, 4, "Every property should be copied across");
assertEqual(original.city, "Leeds", "The original profile must not be changed");
--- hint
Look at the line `const copy = profile;`. It doesn't create a new object; it gives the same object a second name. Start `copy` as a new, empty object, and copy `profile` into it.
--- hint
`Object.assign({}, profile)` makes a new object with all of `profile`'s properties. Set `city` on that new object and return it.
```

Fix it so `withCity(profile, "York")` returns a profile whose `city` is `"York"`, while the original keeps its old city and all of its other properties.

Here is a prediction question about the shared-reference rule. Read it carefully before you check:

```js predict id=shared-reference title="What do these lines print?"
const a = { n: 1 };
const b = a;
b.n = 2;
console.log(a.n, a === b);
--- options
1 false
2 false
* 2 true
1 true
--- explain
`b = a` doesn't copy the object; both names point at the same object. Setting `b.n = 2` changes that one object, so `a.n` is `2`. And because `a` and `b` are the same object, `a === b` is `true`. Only `b` was written to, but both names see the change.
```

> **Under the hood:** Objects live in memory, and variables hold references to them. Arrays are objects too, so everything you learned about shared lists in the array lessons applies here. The same is true for functions passed to other functions.

> **In the wild:** Frameworks like React rely on comparing references to decide whether something changed. A component that receives a new object reference re-renders, but one that is mutated in place may not. This is why many state-management libraries ask you to create a new object for every update rather than editing the old one.

## Recap

- An object is a set of named properties. Create one with `{ key: value }` and read it with `obj.key` or `obj["key"]`.
- A missing property reads as `undefined`. Use `in` to check whether a property exists.
- A function stored in a property is a method. Use `this` inside it to reach the object's own data, and call it with the object in front.
- Use `Object.keys`, `Object.values` and `Object.entries` to loop over an object's contents.
- Assigning an object to another variable shares it. Copy with `Object.assign({}, obj)` when you need an independent object.

**Up next:** Destructuring, spread and rest: shorter ways to pull values out of objects and arrays, and to copy and combine them.
