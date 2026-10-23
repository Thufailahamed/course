Every object in JavaScript has a hidden link to another object, its prototype. When you read a property and the object doesn't have it, the engine doesn't give up. It follows the link and checks there, then follows the next link, and so on until it finds the property or runs out of links. That chain of links is the prototype chain, and it's the reason methods like `push` and `toUpperCase` work on values that never defined them.

Most developers meet prototypes through error messages and a little bit of `class` syntax, and they treat the chain as magic. This lesson makes it concrete. You'll see exactly where a lookup goes, why assignment behaves differently from reading, and the shared-state bugs that come from putting mutable data on a prototype. Those bugs are subtle enough to survive code review, which is why they're worth understanding in detail.

## Lookup walks the chain

Start with a plain link. `Object.create(proto)` creates a new object whose prototype is `proto`. Reading a property on the new object checks its own properties first, and then the prototype.

```js run
const animal = {
  legs: 4,
  breathe() {
    return "breathing";
  },
};

const dog = Object.create(animal);
dog.bark = function () {
  return "woof";
};

console.log(dog.legs, dog.breathe(), dog.bark());
console.log(Object.getPrototypeOf(dog) === animal, Object.hasOwn(dog, "legs"));
```

`dog.legs` isn't an own property of `dog`, so the engine reads it from `animal`. `dog.breathe` is found one link up. `dog.bark` is an own property. The last line separates the two questions that matter: is `animal` the prototype of `dog`, and does `dog` own `legs`? `Object.hasOwn` answers the second one, and it's the safe way to check ownership.

> **Under the hood:** The prototype is an internal slot called `[[Prototype]]`. It isn't a normal property you can see with `Object.keys`. `Object.getPrototypeOf` reads it, and `Object.setPrototypeOf` changes it, although changing it after an object is created is slow and should be avoided.

## Reading and writing follow different rules

Reading a property walks the chain. Writing a property does not. When you assign `child.count = 5`, the engine creates or updates an **own** property on `child`, and it leaves the prototype alone. This is called shadowing: the own property hides the inherited one until you delete it.

```js run
const base = { level: 1 };
const child = Object.create(base);

child.level = 5;
console.log(base.level, child.level);

delete child.level;
console.log(child.level);
```

After the assignment, `child` has its own `level`, and the prototype's `level` is unchanged. Deleting the own property reveals the inherited value again. Shadowing is how JavaScript lets an instance override a default without touching the defaults for everyone else.

There's one exception worth knowing. If the prototype has a setter for that name, assignment calls the setter instead of creating an own property. That's how `class` setters work, and you'll see it in lesson 6.

## Constructors and `prototype`

Functions have a `prototype` property. When you call a function with `new`, the new object's prototype is set to that function's `prototype`. That single fact is how constructor functions share methods across every instance.

```js run
function Robot(name) {
  this.name = name;
}

Robot.prototype.greet = function () {
  return "I am " + this.name;
};

const r1 = new Robot("R1");
const r2 = new Robot("R2");

console.log(r1.greet(), r2.greet(), r1.greet === r2.greet);
console.log(Object.getPrototypeOf(r1) === Robot.prototype);
```

`name` is set on each instance, because each robot has its own name. `greet` lives once on `Robot.prototype`, and every instance reaches it through the chain. `r1.greet === r2.greet` is `true` because there's only one function. This is why methods belong on the prototype rather than being recreated in the constructor for every object.

> **In the wild:** The DOM is one long prototype chain. A `<button>` element inherits from `HTMLButtonElement`, then `HTMLElement`, `Element`, `Node` and `EventTarget`. When you call `addEventListener` on a button, the method is found three or four links up, and nothing about the button had to define it.

> **Pitfall:** `Robot.prototype` is not the same thing as `Object.getPrototypeOf(robot)`, although they're the same object for instances. The `prototype` property belongs to the function, and it's the value used when the function is called with `new`. The `[[Prototype]]` link belongs to each object.

## The shared-state trap

Because lookup goes through the prototype, a mutable value on a prototype is shared by every object that inherits from it. Reading it is fine. Mutating it through an instance changes it for all instances, and the instance never gets its own copy.

```js run
const proto = { tags: [] };
const a = Object.create(proto);
const b = Object.create(proto);

a.tags.push("x");
console.log(b.tags, proto.tags === a.tags);
```

`a.tags.push("x")` reads `tags` through the chain, gets the shared array, and pushes into it. Nothing was assigned to `a.tags`, so no own property was created. Every object that inherits from `proto` now sees the change.

> **Pitfall:** Never put arrays or plain objects on a prototype, and never rely on a constructor's `prototype` for per-instance state. Assign them in the constructor, where each instance gets its own. The same rule applies to any object that a library puts on a prototype and asks you to mutate.

## Objects without a prototype

`Object.create(null)` makes an object with no prototype at all. It has no inherited methods, so names like `toString` or `constructor` don't collide with anything. This is handy for dictionaries that hold arbitrary keys.

```js run
const dict = Object.create(null);
dict.apple = 3;

console.log("apple" in dict, "toString" in dict, Object.getPrototypeOf(dict));
```

The `in` operator checks the whole chain. On an ordinary object, `"toString" in {}` is `true`, because `toString` is inherited from `Object.prototype`. A null-prototype object returns `false`, and `Object.getPrototypeOf` returns `null`.

## Challenge: find the owner

Given an object and a key, find the object in its prototype chain that actually owns the key, or return `null` if no link has it. You'll need `Object.hasOwn` and `Object.getPrototypeOf`.

```js exercise id=find-owner title="Find the owner"
function findOwner(obj, key) {
  // TODO: walk obj and its prototypes. Return the first object that owns `key`,
  // or null if none of them does.
  return null;
}
--- solution
function findOwner(obj, key) {
  let current = obj;
  while (current !== null) {
    if (Object.hasOwn(current, key)) {
      return current;
    }
    current = Object.getPrototypeOf(current);
  }
  return null;
}
--- test
const grandparent = { color: "red" };
const parent = Object.create(grandparent);
parent.size = 2;
const child = Object.create(parent);
child.name = "box";
assert(findOwner(child, "name") === child, "An own property should be found on the object itself");
assert(findOwner(child, "size") === parent, "size should be found on the parent");
assert(findOwner(child, "color") === grandparent, "color should be found two links up");
assert(findOwner(child, "missing") === null, "A key that nobody owns should give null");
assert(findOwner(Object.create(null), "x") === null, "A null-prototype object has no chain to search");
--- hint
Start with `obj`. If it owns `key`, you're done. Otherwise move to its prototype. Stop when the prototype is `null`.
--- hint
Use a `while` loop over `current`. Check `Object.hasOwn(current, key)`, and set `current = Object.getPrototypeOf(current)` at the end of each step.
```

## Challenge: copy only the own entries

`for...in` is a common way to list an object's keys, and it has a trap. It visits inherited enumerable properties as well as own ones. Write a function that returns `[key, value]` pairs for own properties only.

```js exercise id=own-entries title="Own entries only"
function ownEntries(obj) {
  // TODO: return an array of [key, value] pairs for the properties that obj owns.
  // Ignore anything inherited from its prototype.
  return null;
}
--- solution
function ownEntries(obj) {
  return Object.keys(obj).map((key) => [key, obj[key]]);
}
--- test
const base = { inherited: "yes" };
const item = Object.create(base);
item.a = 1;
item.b = "two";
assertEqual(ownEntries(item), [["a", 1], ["b", "two"]], "Only own properties should be listed");
assertEqual(ownEntries({}), [], "An empty object should give an empty list");
const fresh = { x: 9 };
assertEqual(ownEntries(fresh), [["x", 9]], "Plain objects should work the same way");
--- hint
`for...in` walks the whole chain. `Object.keys` lists only the object's own enumerable keys.
--- hint
Call `Object.keys(obj)` and map each key to a pair `[key, obj[key]]`.
```

## Debug: one cart for every shopper

Each shopper should get an empty cart, but the carts share one list. The bug is about where the array lives. Fix it so every `Cart` owns its own `items`.

```js debug id=shared-cart-items title="Give each cart its own items"
function Cart() {}
Cart.prototype.items = [];
Cart.prototype.add = function (item) {
  this.items.push(item);
  return this.items.length;
};
--- solution
function Cart() {
  this.items = [];
}
Cart.prototype.add = function (item) {
  this.items.push(item);
  return this.items.length;
};
--- test
const first = new Cart();
const second = new Cart();
assertEqual(first.add("apple"), 1, "The first cart should hold one item");
assertEqual(second.add("pear"), 1, "A second cart must start empty, not share the first cart's list");
assertEqual(first.items, ["apple"], "The first cart should keep only its own item");
assertEqual(second.items, ["pear"], "The second cart should keep only its own item");
--- hint
Run the code and add an item to two different carts. Look at where `items` is defined, and ask whether `this.items.push` creates a new property or reads one from the prototype.
--- hint
Initialize `items` in the constructor with `this.items = [];`. Each `new Cart()` then runs that line and gets its own array.
```

## Predict: shadowing versus shared objects

Two properties on the same chain behave differently. One is a number, which gets shadowed when you assign. The other is an object, which is shared when you change it through the child.

```js predict id=predict-shadow-vs-shared title="Predict the shared object"
const parent = { count: 1, nested: { hits: 0 } };
const child = Object.create(parent);
child.count += 10;
child.nested.hits += 5;
console.log([parent.count, child.count, parent.nested.hits].join(" "));
--- options
* 1 11 5
11 11 5
1 11 0
1 1 0
--- explain
`child.count += 10` reads the inherited `1`, adds 10, and assigns `11` as an own property of `child`, so the parent's `count` stays `1`. `child.nested` is not assigned, so `hits += 5` reads the shared `nested` object through the chain and changes it. That object belongs to `parent`, so `parent.nested.hits` becomes `5`. The number was shadowed, and the object was shared.
```

## Recap

- Property lookup walks the prototype chain until it finds the property or reaches `null`.
- Assignment creates an own property on the object you assign to, which shadows an inherited value. It doesn't modify the prototype.
- `Object.hasOwn` tests ownership, and `in` tests the whole chain. `for...in` also walks the chain, so use `Object.keys` when you want own properties only.
- Constructor functions put shared methods on `prototype`. Mutable per-instance state belongs in the constructor.
- Mutating a shared array or object through an inherited reference changes it for everyone who inherits from it.

**Up next:** classes in depth, which are a clearer syntax over this same prototype machinery, plus the private fields, getters and inheritance rules that the syntax adds.
