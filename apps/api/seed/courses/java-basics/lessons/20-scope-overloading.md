Where a variable can be used is called its **scope**. Java limits variables to the block where they are declared, which prevents accidental name clashes and makes methods easier to reason about. **Overloading** lets several methods share a name as long as their parameter lists differ.

## Block scope

```java run class
public class Main {
    public static void main(String[] args) {
        int total = 0;

        for (int i = 1; i <= 3; i++) {
            int square = i * i;
            total += square;
        }

        System.out.println(total);
        // System.out.println(i);      // i is not visible here
        // System.out.println(square); // square is not visible here
    }
}
```

`i` and `square` are declared inside the loop block, so they disappear when the block ends. `total` is declared in the method block, so it remains available after the loop. The commented lines would not compile.

## Parameters are local too

```java run class
public class Main {
    static int next(int n) {
        n = n + 1;
        return n;
    }

    public static void main(String[] args) {
        int value = 10;
        int result = next(value);
        System.out.println(value);
        System.out.println(result);
    }
}
```

`n` is a copy of the argument. Changing it inside `next` does not change `value` in `main`. This is **pass by value**: Java always passes a copy of the variable's value.

## Overloading

Two methods can share a name when their parameter types or counts differ:

```java run class
public class Main {
    static int area(int side) {
        return side * side;
    }

    static int area(int width, int height) {
        return width * height;
    }

    static double area(double radius) {
        return 3.14159 * radius * radius;
    }

    public static void main(String[] args) {
        System.out.println(area(4));
        System.out.println(area(3, 5));
        System.out.println(area(2.0));
    }
}
```

The compiler picks the overload by the argument types and count. Return type alone is not enough: two methods cannot differ only by return type.

## Choosing the right overload

```java run class
public class Main {
    static String describe(int n) {
        return "whole number";
    }

    static String describe(double n) {
        return "decimal";
    }

    public static void main(String[] args) {
        System.out.println(describe(5));
        System.out.println(describe(5.0));
        System.out.println(describe(5L));
    }
}
```

An `int` argument picks the `int` overload. A `double` picks the `double` overload. A `long` can widen to `double` if no `long` overload exists. When overloads are ambiguous, the compiler reports an error rather than guessing.

```java predict class id=scope-predict title="What is printed?"
public class Main {
    static String pick(int n) {
        return "int";
    }

    static String pick(double n) {
        return "double";
    }

    public static void main(String[] args) {
        System.out.println(pick(5));
    }
}
--- options
* int
double
5
compile error
--- explain
The literal `5` is an `int`, so Java chooses the `pick(int)` overload without needing a conversion.
```

## Challenges

```java exercise class id=overload-area title="Overload an area method"
public class Main {
    // Add area(int side) and area(int width, int height).

    public static void main(String[] args) {
        System.out.println(area(4));
        System.out.println(area(3, 5));
    }
}
--- solution
public class Main {
    static int area(int side) {
        return side * side;
    }

    static int area(int width, int height) {
        return width * height;
    }

    public static void main(String[] args) {
        System.out.println(area(4));
        System.out.println(area(3, 5));
    }
}
--- test
__check(Main.area(4) == 16, "A square with side 4 has area 16");
__check(Main.area(3, 5) == 15, "A 3 by 5 rectangle has area 15");
--- hint
Both methods return `int` and are named `area`; the parameter lists differ.
--- hint
One takes `int side`, the other takes `int width, int height`.
```

```java exercise class id=clamp-method title="Clamp a value to a range"
public class Main {
    // Define static int clamp(int value, int min, int max).

    public static void main(String[] args) {
        System.out.println(clamp(15, 0, 10));
    }
}
--- solution
public class Main {
    static int clamp(int value, int min, int max) {
        if (value < min) {
            return min;
        }
        if (value > max) {
            return max;
        }
        return value;
    }

    public static void main(String[] args) {
        System.out.println(clamp(15, 0, 10));
    }
}
--- test
__check(Main.clamp(15, 0, 10) == 10, "15 clamps to 10");
__check(Main.clamp(-3, 0, 10) == 0, "-3 clamps to 0");
__check(Main.clamp(7, 0, 10) == 7, "7 stays 7");
--- hint
Check the lower bound first, then the upper bound, then return the original value.
--- hint
Use two `if` statements and a final `return value;`.
```

```java debug class id=fix-block-scope title="The sum is out of scope"
public class Main {
    static int total() {
        if (true) {
            int sum = 5;
        }
        return sum;
    }

    public static void main(String[] args) {
        System.out.println(total());
    }
}
--- solution
public class Main {
    static int total() {
        int sum = 0;
        if (true) {
            sum = 5;
        }
        return sum;
    }

    public static void main(String[] args) {
        System.out.println(total());
    }
}
--- test
__check(Main.total() == 5, "total should be 5");
--- hint
`sum` is declared inside the `if` block and disappears at the closing brace.
--- hint
Declare `sum` before the `if` and assign to it inside.
```
