A **class** is a blueprint. An **object** is one instance built from that blueprint. Classes bundle data (fields) with the operations that belong to that data (methods), which is the heart of object-oriented programming.

## Fields, constructors and methods

```java run class
class Counter {
    int value;

    Counter(int start) {
        value = start;
    }

    void increment() {
        value++;
    }

    int getValue() {
        return value;
    }
}

public class Main {
    public static void main(String[] args) {
        Counter counter = new Counter(10);
        counter.increment();
        counter.increment();
        System.out.println(counter.getValue());
    }
}
```

`new Counter(10)` allocates an object and runs the constructor. The constructor has the same name as the class and no return type. Fields belong to each object, so two counters keep separate values.

## this

```java run class
class Person {
    String name;
    int age;

    Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    void birthday() {
        this.age++;
    }
}

public class Main {
    public static void main(String[] args) {
        Person ada = new Person("Ada", 36);
        ada.birthday();
        System.out.println(ada.name + " is " + ada.age);
    }
}
```

`this` refers to the current object. It is essential when a parameter has the same name as a field: `this.name = name` assigns the parameter to the field, while `name = name` would assign the parameter to itself.

## Encapsulation

```java run class
class Temperature {
    private double celsius;

    Temperature(double celsius) {
        this.celsius = celsius;
    }

    double getCelsius() {
        return celsius;
    }

    double getFahrenheit() {
        return celsius * 9 / 5 + 32;
    }

    void setCelsius(double celsius) {
        if (celsius < -273.15) {
            throw new IllegalArgumentException("Below absolute zero");
        }
        this.celsius = celsius;
    }
}

public class Main {
    public static void main(String[] args) {
        Temperature t = new Temperature(25);
        System.out.println(t.getFahrenheit());
        t.setCelsius(30);
        System.out.println(t.getCelsius());
    }
}
```

A `private` field cannot be read or written from outside the class. Access goes through methods, which can validate input. This is **encapsulation**: the object protects its own invariants.

## toString and static members

```java run class
class Point {
    int x;
    int y;

    Point(int x, int y) {
        this.x = x;
        this.y = y;
    }

    public String toString() {
        return "(" + x + ", " + y + ")";
    }

    static Point origin() {
        return new Point(0, 0);
    }
}

public class Main {
    public static void main(String[] args) {
        Point p = new Point(3, 4);
        System.out.println(p);
        System.out.println(Point.origin());
    }
}
```

`toString` is called automatically when an object is printed. A `static` method belongs to the class, not to a particular object, so you call it with `Point.origin()`.

```java predict class id=classes-predict title="What is printed?"
class Counter {
    int value;
    Counter(int start) { value = start; }
    void increment() { value++; }
}

public class Main {
    public static void main(String[] args) {
        Counter c = new Counter(5);
        c.increment();
        c.increment();
        System.out.println(c.value);
    }
}
--- options
* 7
5
6
2
--- explain
The counter starts at 5 and is incremented twice, so its value is 7.
```

## Challenges

```java exercise class id=create-book title="Create a Book class"
public class Main {
    // Define class Book with title and author fields,
    // a constructor, and String getTitle().

    public static void main(String[] args) {
        Book book = new Book("Java", "Ada");
        System.out.println(book.getTitle());
    }
}
--- solution
class Book {
    String title;
    String author;

    Book(String title, String author) {
        this.title = title;
        this.author = author;
    }

    String getTitle() {
        return title;
    }
}

public class Main {
    public static void main(String[] args) {
        Book book = new Book("Java", "Ada");
        System.out.println(book.getTitle());
    }
}
--- test
Book book = new Book("Java", "Ada");
__check(book.getTitle().equals("Java"), "getTitle should return Java");
--- hint
The constructor should store both parameters in fields.
--- hint
Use `this.title = title;` and `this.author = author;`.
```

```java exercise class id=counter-class title="Build a Counter class"
public class Main {
    // Define class Counter with a constructor, increment() and getValue().

    public static void main(String[] args) {
        Counter c = new Counter();
        c.increment();
        System.out.println(c.getValue());
    }
}
--- solution
class Counter {
    private int value;

    Counter() {
        value = 0;
    }

    void increment() {
        value++;
    }

    int getValue() {
        return value;
    }
}

public class Main {
    public static void main(String[] args) {
        Counter c = new Counter();
        c.increment();
        System.out.println(c.getValue());
    }
}
--- test
Counter c = new Counter();
c.increment();
c.increment();
__check(c.getValue() == 2, "Two increments should give 2");
--- hint
Keep an `int value` field and increase it in `increment`.
--- hint
`getValue` returns the field.
```

```java debug class id=fix-this-assignment title="The constructor never stores the name"
class User {
    String name;

    User(String name) {
        name = name;
    }

    String getName() {
        return name;
    }
}

public class Main {
    public static void main(String[] args) {
        User user = new User("Ada");
        System.out.println(user.getName());
    }
}
--- solution
class User {
    String name;

    User(String name) {
        this.name = name;
    }

    String getName() {
        return name;
    }
}

public class Main {
    public static void main(String[] args) {
        User user = new User("Ada");
        System.out.println(user.getName());
    }
}
--- test
User user = new User("Ada");
__check(user.getName().equals("Ada"), "The name should be Ada");
--- hint
The parameter `name` hides the field with the same name.
--- hint
Use `this.name = name;`.
```
