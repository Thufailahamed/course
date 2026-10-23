So far you've made single objects by hand. That works for one student or one settings panel, but a program that handles a hundred students needs a repeatable way to create objects with the same shape and the same behavior. A **class** is that blueprint. You write it once, and then `new` stamps out as many independent objects, called instances, as you need.

Classes also group the data and the functions that work on it in one place. A `Budget` class holds its own list of expenses and knows how to total them, so the rest of your program doesn't have to know how that works. This page shows you how to write a class, how methods and getters use `this`, and the mistakes that come up when you first start using them.

## Declaring a class and creating instances

A class declaration starts with the `class` keyword. The `constructor` method runs once for each new instance and sets up its starting data:

```js run
class Dog {
  constructor(name, age) {
    this.name = name;
    this.age = age;
  }
}

const rex = new Dog("Rex", 4);
const pip = new Dog("Pip", 1);

console.log(rex.name, rex.age);
console.log(pip.name, pip.age);
```

`this` inside the constructor refers to the new object being built. Each `new Dog(...)` call produces a fresh object with its own `name` and `age`. Rex and Pip don't share anything except the blueprint.

> **Tip:** Put every property the object will ever need in the constructor, even if it starts empty. A reader can see the object's full shape at a glance, instead of discovering properties as the program runs.

## Methods use this

Methods are functions written inside the class body, without the `function` keyword. They're shared by every instance, and `this` points at the instance the method was called on:

```js run
class Car {
  constructor(make) {
    this.make = make;
    this.miles = 0;
  }

  drive(distance) {
    this.miles = this.miles + distance;
    return this.miles;
  }
}

const civic = new Car("Honda");
civic.drive(120);
console.log(civic.make, civic.drive(30));
```

`civic.drive(30)` changes `civic.miles`, and only `civic`. A second car would keep its own mileage.

Now try writing a class yourself. This one tracks a count that starts at zero and goes up by one each time you call a method:

```js exercise id=counter-class title="Write a Counter class"
class Counter {
  constructor() {
    // TODO: start this.count at 0
    this.count = null;
  }

  increment() {
    // TODO: add 1 to this.count
  }
}
--- solution
class Counter {
  constructor() {
    this.count = 0;
  }

  increment() {
    this.count = this.count + 1;
  }
}
--- test
const first = new Counter();
const second = new Counter();
first.increment();
first.increment();
assertEqual(first.count, 2, "Two increments should leave count at 2");
assertEqual(second.count, 0, "A new counter must start at 0, separate from the first one");
second.increment();
assertEqual(second.count, 1, "The second counter should count on its own");
--- hint
The constructor starts the count, and each method call changes it. Fix the `null` first.
--- hint
Inside `increment`, write `this.count = this.count + 1;`. Make sure the constructor sets `this.count` to `0`, not `null`.
```

Next, a class that holds a list of its own. A stack works like a pile of plates: you push onto the top, and pop from the top, so the last item in is the first one out. The class keeps the list in `this.items`, and each method is a small, clear action on that list:

```js exercise id=stack-class title="Build a Stack class"
class Stack {
  constructor() {
    this.items = [];
  }

  push(item) {
    // TODO: add item to the end of this.items
  }

  pop() {
    // TODO: remove the last item from this.items and return it
    return null;
  }

  get size() {
    // TODO: return how many items are in the stack
    return null;
  }
}
--- solution
class Stack {
  constructor() {
    this.items = [];
  }

  push(item) {
    this.items.push(item);
  }

  pop() {
    return this.items.pop();
  }

  get size() {
    return this.items.length;
  }
}
--- test
const stack = new Stack();
stack.push("a");
stack.push("b");
assertEqual(stack.size, 2, "Two pushes should give a size of 2");
assertEqual(stack.pop(), "b", "pop should return the most recent item");
assertEqual(stack.size, 1, "pop should remove the item it returns");
assertEqual(new Stack().size, 0, "A new stack should be empty");
--- hint
Each method works on `this.items`, which is already an array. Arrays have `push`, `pop` and `length`.
--- hint
`push` adds to the end, `pop` removes and returns the last item, and `this.items.length` is the size.
```

## Getters: properties that compute a value

A **getter** looks like a property when you read it, but runs a method behind the scenes. Use one when a value can always be worked out from the data you already store. Storing a derived value risks it going out of date:

```js run
class Temperature {
  constructor(celsius) {
    this.celsius = celsius;
  }

  get fahrenheit() {
    return this.celsius * 9 / 5 + 32;
  }
}

const boiling = new Temperature(100);
console.log(boiling.fahrenheit);
boiling.celsius = 0;
console.log(boiling.fahrenheit);
```

You write `boiling.fahrenheit` without parentheses, and the value always matches the current `celsius`. There's no `fahrenheit` field to update.

Here is the debug challenge that uses a getter. The class is supposed to return the rectangle's area, but the getter fails. Fix the class so that `new Rectangle(3, 4).area` is `12` and `new Rectangle(2, 10).area` is `20`. The error you see when you run it names the missing variable, which is a clue about where to look.

```js debug id=rectangle-area title="Fix the getter that can't see the data"
class Rectangle {
  constructor(width, height) {
    this.width = width;
    this.height = height;
  }

  get area() {
    return width * height;
  }
}
--- solution
class Rectangle {
  constructor(width, height) {
    this.width = width;
    this.height = height;
  }

  get area() {
    return this.width * this.height;
  }
}
--- test
assertEqual(new Rectangle(3, 4).area, 12, "A 3 by 4 rectangle has area 12");
assertEqual(new Rectangle(2, 10).area, 20, "A 2 by 10 rectangle has area 20");
const square = new Rectangle(5, 5);
square.width = 6;
assertEqual(square.area, 30, "The area should follow the current width, so it must be computed on each read");
--- hint
Inside a class, `width` on its own is not a property. The data lives on the instance, so you have to reach it through `this`.
--- hint
Write `this.width * this.height`. Remember that every instance keeps its own width and height.
```

> **Pitfall:** Forgetting `this.` inside a class is one of the most common mistakes. JavaScript looks for a variable called `width`, can't find one, and throws a `ReferenceError`. The data is on the object, so the code has to name the object.

## Forgetting new

A class constructor only works with `new`. Call it without `new`, and JavaScript refuses:

```js run
class Beagle {
  constructor(name) {
    this.name = name;
  }
}

try {
  Beagle("Rex");
} catch (error) {
  console.log(error.name + ": " + error.message);
}
```

The error is a `TypeError` that names the class. Seeing it is a clue that you forgot `new`. This is a helpful failure, because the other way, an ordinary function that quietly misuses `this`, is much harder to find.

## Checking what an object is

The `instanceof` operator asks whether an object was made from a particular class. It's the reliable way to check the type of an object you're given:

```js run
class Point {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }
}

const origin = new Point(0, 0);
console.log(origin instanceof Point);
console.log(origin instanceof Object);
console.log(origin instanceof Beagle);
```

Every instance of `Point` is also an `Object`, which is why the second line prints `true`. The third line checks against `Beagle`, a class with no connection to `origin`, so it's `false`. In a real program you'd check against the class that actually made the object.

Here is a prediction question about instances. Two objects made from the same class are separate things, even when their data looks identical:

```js predict id=separate-instances title="What does this print?"
class Point {
  constructor(x) {
    this.x = x;
  }
}

const p = new Point(3);
const q = new Point(3);
console.log(p === q, p.x === q.x, p instanceof Point);
--- options
true true true
* false true true
false false true
true true false
--- explain
`new` creates a new object each time, so `p` and `q` are two different objects and `p === q` is `false`. Their `x` values are both `3`, so `p.x === q.x` is `true`. And `p` was built from `Point`, so `p instanceof Point` is `true`. Equal data doesn't make two objects the same object.
```

> **Under the hood:** A class is mostly a more readable way to write a constructor function with a prototype. Methods are stored once on the prototype, and every instance looks them up from there. That's why thousands of instances share one copy of each method rather than each carrying its own.

> **In the wild:** Classes are how many UI libraries and game engines represent the things on screen, such as a button, a sprite or a chart. Each instance stores its own state, like its position or label, and methods such as `draw()` or `update()` do the work with `this`.

## Methods can return `this`

A method that ends with `return this` hands back the same object, so calls can be chained. This is how many libraries let you write several steps in one line.

```js run
class Point {
  constructor(x, y) { this.x = x; this.y = y; }
  add(other) { return new Point(this.x + other.x, this.y + other.y); }
}

const a = new Point(1, 2);
const b = new Point(10, 20);
console.log(a.add(b));
a.add(b).add(b)
```

Notice that `add` builds a new `Point` and leaves `a` alone. The method returns a fresh value instead of changing the original, which is often the safer design.

```js predict id=method-result title="What does this print?"
class Box {
  constructor(size) { this.size = size; }
  grow() { this.size += 1; return this; }
}

const box = new Box(2);
console.log(box.grow().grow().size);
--- options
2
* 4
3
5
--- explain
`grow()` returns `this`, the same object, so the calls chain. Each call adds 1 to `size`, so two calls take it from 2 to 4.
```

## Recap

- A class is a blueprint. `new ClassName(args)` runs the constructor and returns a new, independent instance.
- Methods are written in the class body, and `this` refers to the instance they were called on.
- A getter, written `get name() { ... }`, is read like a property and computes its value each time.
- Inside a class, reach instance data with `this.`; a bare name is a variable, and it doesn't exist.
- Calling a class without `new` throws a `TypeError`, and `instanceof` checks which class created an object.

**Up next:** Errors: throw, try and catch, so your programs can report problems clearly and recover from them.
