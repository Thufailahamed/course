A **method** is a named block of code that can take inputs and return a result. Methods let you name an idea once and reuse it, instead of copying the same lines into every place that needs them.

> **Note:** Methods are declared inside a class, not inside another method. In this lesson every cell is a complete class, so the editor starts with `public class Main`.

## Declaring and calling

```java run class
public class Main {
    static int add(int a, int b) {
        return a + b;
    }

    public static void main(String[] args) {
        int result = add(3, 5);
        System.out.println(result);
        System.out.println(add(10, 20));
    }
}
```

The method header has four parts: the return type `int`, the name `add`, the parameter list `(int a, int b)`, and the body in braces. `return` sends a value back to the caller. `static` means the method belongs to the class itself, so `main` can call it without creating an object.

## Parameters and arguments

```java run class
public class Main {
    static double area(double width, double height) {
        return width * height;
    }

    static String greet(String name) {
        return "Hello, " + name + "!";
    }

    public static void main(String[] args) {
        System.out.println(area(3, 4));
        System.out.println(greet("Ada"));
    }
}
```

The names in the declaration (`width`, `height`) are **parameters**. The values at the call site (`3`, `4`) are **arguments**. Java checks that the argument types match the parameter types.

## Methods that return nothing

```java run class
public class Main {
    static void printLine(int width) {
        for (int i = 0; i < width; i++) {
            System.out.print("-");
        }
        System.out.println();
    }

    public static void main(String[] args) {
        printLine(5);
        printLine(12);
    }
}
```

`void` means "returns no value". A `void` method can still have side effects such as printing. You cannot assign its result to a variable.

## Returning early

```java run class
public class Main {
    static String classify(int n) {
        if (n < 0) {
            return "negative";
        }
        if (n == 0) {
            return "zero";
        }
        return "positive";
    }

    public static void main(String[] args) {
        System.out.println(classify(-4));
        System.out.println(classify(0));
        System.out.println(classify(9));
    }
}
```

Once a `return` runs, the method ends immediately. The compiler requires every possible path through a non-void method to return a value; that is why the final `return` is outside the `if` blocks.

```java predict class id=methods-predict title="What is printed?"
public class Main {
    static int doubleIt(int n) {
        return n * 2;
    }

    public static void main(String[] args) {
        System.out.println(doubleIt(3) + doubleIt(4));
    }
}
--- options
* 14
7
24
12
--- explain
`doubleIt(3)` is `6` and `doubleIt(4)` is `8`. The two results are added, giving `14`.
```

## Challenges

```java exercise class id=add-method title="Write an add method"
public class Main {
    // Define static int add(int a, int b) here.

    public static void main(String[] args) {
        System.out.println(add(2, 3));
    }
}
--- solution
public class Main {
    static int add(int a, int b) {
        return a + b;
    }

    public static void main(String[] args) {
        System.out.println(add(2, 3));
    }
}
--- test
__check(Main.add(2, 3) == 5, "add(2, 3) should return 5");
__check(Main.add(-4, 1) == -3, "add(-4, 1) should return -3");
--- hint
The return type is `int`, so the method must `return` a number.
--- hint
`static int add(int a, int b) { return a + b; }`
```

```java exercise class id=is-even-method title="Write an isEven method"
public class Main {
    // Define static boolean isEven(int n) here.

    public static void main(String[] args) {
        System.out.println(isEven(10));
    }
}
--- solution
public class Main {
    static boolean isEven(int n) {
        return n % 2 == 0;
    }

    public static void main(String[] args) {
        System.out.println(isEven(10));
    }
}
--- test
__check(Main.isEven(10), "10 is even");
__check(!Main.isEven(7), "7 is not even");
--- hint
A number is even when the remainder after dividing by 2 is zero.
--- hint
`return n % 2 == 0;`
```

```java debug class id=fix-square-method title="The square method returns the wrong value"
public class Main {
    static int square(int n) {
        return n + n;
    }

    public static void main(String[] args) {
        System.out.println(square(4));
    }
}
--- solution
public class Main {
    static int square(int n) {
        return n * n;
    }

    public static void main(String[] args) {
        System.out.println(square(4));
    }
}
--- test
__check(Main.square(4) == 16, "4 squared is 16");
__check(Main.square(5) == 25, "5 squared is 25");
--- hint
`n + n` doubles the number. Squaring means multiplying it by itself.
--- hint
Return `n * n`.
```
