**Inheritance** lets one class build on another. The child class reuses the parent's fields and methods, can add its own, and can **override** a method to change its behaviour. **Polymorphism** means you can treat different child objects through the parent type and still get the right behaviour.

## Extending a class

```java run class
class Animal {
    void speak() {
        System.out.println("...");
    }
}

class Dog extends Animal {
    @Override
    void speak() {
        System.out.println("Woof");
    }
}

public class Main {
    public static void main(String[] args) {
        Animal animal = new Animal();
        Dog dog = new Dog();

        animal.speak();
        dog.speak();
    }
}
```

`extends` establishes the parent-child relationship. `@Override` is optional but recommended: the compiler checks that a method with that signature really exists in the parent.

## super

```java run class
class Animal {
    String name;

    Animal(String name) {
        this.name = name;
    }

    String describe() {
        return "Animal named " + name;
    }
}

class Dog extends Animal {
    Dog(String name) {
        super(name);
    }

    @Override
    String describe() {
        return "Dog named " + name;
    }
}

public class Main {
    public static void main(String[] args) {
        Dog dog = new Dog("Rex");
        System.out.println(dog.describe());
    }
}
```

`super(name)` calls the parent constructor. If the parent has no no-argument constructor, the child must call `super(...)` explicitly. `super.method()` calls the parent's version of a method when you want to extend rather than replace it.

## Polymorphism

```java run class
class Animal {
    String name;
    Animal(String name) { this.name = name; }
    String sound() { return "..."; }
}

class Dog extends Animal {
    Dog(String name) { super(name); }
    String sound() { return "Woof"; }
}

class Cat extends Animal {
    Cat(String name) { super(name); }
    String sound() { return "Meow"; }
}

public class Main {
    public static void main(String[] args) {
        Animal[] animals = {new Dog("Rex"), new Cat("Milo"), new Dog("Fido")};
        for (Animal animal : animals) {
            System.out.println(animal.name + ": " + animal.sound());
        }
    }
}
```

The array is typed as `Animal[]`, but each element is a specific subclass. At runtime Java calls the most specific override. This is **dynamic dispatch**, and it is what makes a collection of mixed objects useful.

## Abstract classes

```java run class
abstract class Shape {
    abstract double area();

    String label() {
        return "Area: " + area();
    }
}

class Square extends Shape {
    double side;
    Square(double side) { this.side = side; }

    @Override
    double area() {
        return side * side;
    }
}

public class Main {
    public static void main(String[] args) {
        Shape shape = new Square(4);
        System.out.println(shape.label());
    }
}
```

An `abstract` class cannot be instantiated. It can declare abstract methods that every concrete subclass must implement. `Shape` promises that every shape has an `area()`, without saying how to compute it.

```java predict class id=inheritance-predict title="What is printed?"
class Animal {
    String speak() { return "..."; }
}

class Dog extends Animal {
    String speak() { return "Woof"; }
}

public class Main {
    public static void main(String[] args) {
        Animal a = new Dog();
        System.out.println(a.speak());
    }
}
--- options
* Woof
...
Animal
compile error
--- explain
The variable type is `Animal`, but the object is a `Dog`. Java calls the override at runtime, so the result is `Woof`.
```

## Challenges

```java exercise class id=override-speak title="Override a method"
class Animal {
    String speak() {
        return "...";
    }
}

// Define class Dog that extends Animal and returns "Woof".

public class Main {
    public static void main(String[] args) {
        System.out.println(new Dog().speak());
    }
}
--- solution
class Animal {
    String speak() {
        return "...";
    }
}

class Dog extends Animal {
    @Override
    String speak() {
        return "Woof";
    }
}

public class Main {
    public static void main(String[] args) {
        System.out.println(new Dog().speak());
    }
}
--- test
Animal dog = new Dog();
__check(dog.speak().equals("Woof"), "A Dog should say Woof");
--- hint
Use `class Dog extends Animal`.
--- hint
Define `String speak()` with the same signature and return `"Woof"`.
```

```java exercise class id=abstract-shape title="Implement an abstract shape"
abstract class Shape {
    abstract double area();
}

// Define class Circle extends Shape with a radius constructor.

public class Main {
    public static void main(String[] args) {
        System.out.println(new Circle(2).area());
    }
}
--- solution
abstract class Shape {
    abstract double area();
}

class Circle extends Shape {
    double radius;

    Circle(double radius) {
        this.radius = radius;
    }

    @Override
    double area() {
        return Math.PI * radius * radius;
    }
}

public class Main {
    public static void main(String[] args) {
        System.out.println(new Circle(2).area());
    }
}
--- test
Shape circle = new Circle(2);
__check(Math.abs(circle.area() - Math.PI * 4) < 0.0001, "A circle with radius 2 has area 4 pi");
--- hint
`Circle extends Shape` must implement `area()`.
--- hint
Store the radius in a field and return `Math.PI * radius * radius`.
```

```java debug class id=fix-super-call title="The child constructor will not compile"
class Animal {
    String name;

    Animal(String name) {
        this.name = name;
    }
}

class Dog extends Animal {
    Dog(String name) {
        this.name = name;
    }
}

public class Main {
    public static void main(String[] args) {
        System.out.println(new Dog("Rex").name);
    }
}
--- solution
class Animal {
    String name;

    Animal(String name) {
        this.name = name;
    }
}

class Dog extends Animal {
    Dog(String name) {
        super(name);
    }
}

public class Main {
    public static void main(String[] args) {
        System.out.println(new Dog("Rex").name);
    }
}
--- test
Dog dog = new Dog("Rex");
__check(dog.name.equals("Rex"), "The dog should be named Rex");
--- hint
`Animal` has no no-argument constructor, so `Dog` must call the one that exists.
--- hint
Use `super(name);` as the first statement in the `Dog` constructor.
```
