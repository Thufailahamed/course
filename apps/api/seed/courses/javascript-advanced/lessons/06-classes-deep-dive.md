The `class` keyword is often described as "syntax sugar for prototypes", and that's accurate but incomplete. Classes change behavior in ways the old constructor functions could not: their bodies always run in strict mode, their methods are never enumerable, they can't be called without `new`, and they gained real private state with `#` names. Those rules are the reason class-based code is easier to reason about, and they're also the source of the errors you'll hit when you forget one of them.

This lesson goes past the basics you already know. You'll see how a class builds its prototype, how fields are initialized in a derived class (and why a base constructor can see the wrong values), how private state works and why it isn't just a naming convention, and how to stop methods from losing their receiver. The examples focus on the rules that catch experienced developers.

## Classes are prototypes with better rules

A class declaration creates a constructor function whose `prototype` holds the methods. Everything from the last lesson still applies, but the class adds three guarantees. Methods are non-enumerable, so `for...in` and `Object.keys` skip them. The body runs in strict mode, so a lost `this` becomes `undefined` instead of the global object. And calling the class without `new` throws a `TypeError`.

```js run
class Account {
  #balance = 0;
  static count = 0;

  constructor(owner) {
    this.owner = owner;
    Account.count += 1;
  }

  deposit(amount) {
    if (amount <= 0) {
      throw new RangeError("Deposit must be positive");
    }
    this.#balance += amount;
    return this;
  }

  get balance() {
    return this.#balance;
  }
}

const acct = new Account("Ada");
acct.deposit(50).deposit(25);
console.log(acct.owner, acct.balance, Account.count);
console.log(Object.keys(acct));
```

`#balance` is a private field. Code outside the class can't read or write it, and the `balance` getter is the only read path. `static count` belongs to the class itself, not to instances, so `Account.count` is the right place to read it. `deposit` returns `this`, which lets you chain calls. `Object.keys` shows only the public data, `owner`, and not `balance`.

> **Under the hood:** A private name like `#balance` is not a string key. Each class creates its own private names, so two classes that both use `#balance` never collide, and a subclass can't reach its parent's private fields by name. Private fields are stored per object in a hidden slot that only the defining class can access.

## Field initialization order

Fields are initialized in a precise sequence. In a base class, fields run before the constructor body. In a derived class, they run immediately after `super()` returns. That timing is the most common surprise with inheritance, and it shows up when a base constructor calls a method that a subclass overrides.

```js run
class Base {
  constructor() {
    this.log = this.describe();
  }
  describe() {
    return "base";
  }
}

class Derived extends Base {
  label = "derived-label";
  describe() {
    return "derived sees " + this.label;
  }
}

const d = new Derived();
console.log(d.log, d.label);
```

When `Base`'s constructor runs, `Derived`'s fields don't exist yet. `this.describe()` still dispatches to `Derived.prototype.describe`, which reads `this.label` before the field is set, so it gets `undefined`. Only after `super()` returns is `label` assigned. The example prints the stale value and then the correct one.

> **Pitfall:** Don't call overridable methods from a base constructor. The subclass hasn't finished setting itself up, and the method sees a half-built object. Put that logic in an explicit `init()` call made after construction, or move the state into the constructor that owns it.

## Static members and brand checks

`static` members belong to the class. `static #name` is a private static field, and a static block runs once when the class is defined. Private names also support a check called a brand check: `#field in obj` is `true` only when `obj` was created by the class that declares that private field. It's the reliable way to test "is this really a Temperature?" without relying on a property that anyone could fake.

```js run
class Temperature {
  static #instances = 0;
  #celsius;

  constructor(celsius) {
    this.#celsius = celsius;
    Temperature.#instances += 1;
  }

  static fromFahrenheit(f) {
    return new Temperature(((f - 32) * 5) / 9);
  }

  static get created() {
    return Temperature.#instances;
  }

  static isTemperature(value) {
    return #celsius in value;
  }

  get celsius() {
    return this.#celsius;
  }
}

const boiling = Temperature.fromFahrenheit(212);
console.log(boiling.celsius, Temperature.created, Temperature.isTemperature(boiling), Temperature.isTemperature({}));
```

`instanceof` checks the prototype chain, so it can be fooled by any object whose prototype was set to `Temperature.prototype`. The brand check can't be fooled that way. An object only has `#celsius` if the constructor created it.

## Methods lose `this` just like functions

Class bodies are strict, which is good news for debugging: a detached method sees `undefined` rather than the global object. It still loses its receiver, though, and the fix is the same as with any function.

```js run
class Button {
  constructor(label) {
    this.label = label;
  }
  click() {
    return this.label + " clicked";
  }
}

const btn = new Button("OK");
const handler = btn.click;
try {
  handler();
} catch (err) {
  console.log(err.name);
}
```

`handler()` runs `click` with `this` set to `undefined`, so `this.label` throws. Event handlers have this problem constantly. There are two standard fixes: bind the method in the constructor, or declare it as an arrow function class field, which captures the instance as `this`. You'll practice the second one in the debug challenge below.

## Challenge: a stack with private storage

A stack keeps its items private, so callers can only use the operations you define. Build a `Stack` whose `items` array can't be reached from outside.

```js exercise id=private-stack title="A stack with private storage"
class Stack {
  // TODO: store items in a private field, and implement push, pop, peek and a size getter.
  // push(x) returns the new size. pop() removes and returns the top item, or undefined.
  // peek() returns the top item without removing it, or undefined.
  push(item) {
    return null;
  }
}
--- solution
class Stack {
  #items = [];

  push(item) {
    this.#items.push(item);
    return this.#items.length;
  }

  pop() {
    return this.#items.pop();
  }

  peek() {
    return this.#items[this.#items.length - 1];
  }

  get size() {
    return this.#items.length;
  }
}
--- test
const s = new Stack();
assertEqual(s.push("a"), 1, "push should return the new size");
assertEqual(s.push("b"), 2, "push should return the new size again");
assertEqual(s.peek(), "b", "peek should return the top item");
assertEqual(s.size, 2, "size should count the items");
assertEqual(s.pop(), "b", "pop should return the top item");
assertEqual(s.pop(), "a", "pop should return the next item");
assertEqual(s.pop(), undefined, "pop on an empty stack should return undefined");
assertEqual(Object.keys(s), [], "Items must not be visible as own properties");
assertEqual(JSON.stringify(s), "{}", "Serializing the stack should reveal nothing private");
--- hint
Use a private field such as `#items = [];`. You can call `push`, `pop` and `length` on it from inside the class, and nowhere else.
--- hint
`push` and `pop` on the array do most of the work. `peek` reads the last element by index, and `size` is a getter that returns the array's length.
```

## Challenge: extend and call the parent

Subclasses reuse behavior with `extends` and call the parent's version with `super`. Build an `Animal` with a `speak` method, and a `Dog` that overrides it by first calling the parent's version.

```js exercise id=dog-speaks title="Override and call super"
class Animal {
  constructor(name) {
    this.name = name;
  }
  speak() {
    return this.name + " makes a sound";
  }
}

class Dog extends Animal {
  // TODO: override speak so it returns the parent's sentence followed by " and barks"
  speak() {
    return null;
  }
}
--- solution
class Animal {
  constructor(name) {
    this.name = name;
  }
  speak() {
    return this.name + " makes a sound";
  }
}

class Dog extends Animal {
  speak() {
    return super.speak() + " and barks";
  }
}
--- test
const rex = new Dog("Rex");
assertEqual(rex.speak(), "Rex makes a sound and barks", "Dog.speak should extend the parent's sentence");
assert(rex instanceof Dog, "rex should be a Dog");
assert(rex instanceof Animal, "rex should also be an Animal");
assertEqual(new Dog("Fido").name, "Fido", "The name should come from the parent constructor");
--- hint
`super.speak()` calls the parent's version of the method, with the current object as `this`.
--- hint
Return `super.speak()` concatenated with `" and barks"`. You don't need to call the parent constructor, since `Dog` inherits it automatically.
```

## Debug: a timer that loses itself

This class should count down when you call `tick` as a standalone function, for example when it's passed to `setTimeout` or to an event system. It throws instead. Fix the method so the receiver can't be lost.

```js debug id=timer-tick-arrow title="Keep tick bound"
class Countdown {
  constructor(seconds) {
    this.seconds = seconds;
  }
  tick() {
    this.seconds -= 1;
    return this.seconds;
  }
}
--- solution
class Countdown {
  constructor(seconds) {
    this.seconds = seconds;
  }
  tick = () => {
    this.seconds -= 1;
    return this.seconds;
  };
}
--- test
const timer = new Countdown(3);
const tick = timer.tick;
assertEqual(tick(), 2, "A detached tick should count down from 3 to 2");
assertEqual(tick(), 1, "A second detached tick should count to 1");
assertEqual(timer.seconds, 1, "The original instance should carry the updated value");
assertEqual(new Countdown(5).tick(), 4, "Normal method calls should still work");
--- hint
Run it and read the error. Then check what `this` is when `tick` is called without a receiver, which is how `const tick = timer.tick` calls it.
--- hint
A class field can hold an arrow function, which captures `this` from the instance it's created in. Turn `tick()` into a field whose value is an arrow function.
```

## Predict: the order of constructors

Watch the order of events, because it is the most useful model for derived classes. The derived constructor runs before `super()`, the base constructor runs next, and the subclass's field initializers run after `super()` returns.

```js predict id=predict-field-order title="Predict the constructor order"
const log = [];
class A {
  constructor() {
    log.push("A constructor");
    this.init();
  }
  init() {
    log.push("A init");
  }
}
class B extends A {
  field = log.push("B field");
  constructor() {
    log.push("B before super");
    super();
    log.push("B after super");
  }
  init() {
    log.push("B init");
  }
}
new B();
console.log(log.join(", "));
--- options
* B before super, A constructor, B init, B field, B after super
B before super, A constructor, B field, B init, B after super
A constructor, B init, B before super, B field, B after super
B before super, B field, A constructor, B init, B after super
--- explain
`B`'s constructor starts first, so `"B before super"` is logged. `super()` runs `A`'s constructor, which calls `this.init()`. Because `init` is overridden, that call reaches `B.prototype.init`, which logs `"B init"`, before `B`'s fields exist. Only after `super()` returns does `B` initialize its field, logging `"B field"`, and then `"B after super"` runs. `"A init"` never appears, because the override replaced it.
```

## Recap

- A class builds its prototype with non-enumerable methods, runs in strict mode, and can't be called without `new`.
- `#private` fields and methods are real privacy, enforced by the engine. `#field in obj` checks that an object was created by the class that declares that field.
- Derived fields are initialized after `super()` returns. A base constructor that calls an overridden method sees the subclass before it's ready.
- A method loses its receiver when it's detached. Bind it in the constructor or make it an arrow-function field.
- Use `super.method()` to extend a parent's behavior instead of copying it.

**Up next:** iterators and generators, which let a function pause in the middle of its work and hand back one value at a time.
