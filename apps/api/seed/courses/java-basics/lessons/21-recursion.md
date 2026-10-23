**Recursion** is a method calling itself. It is a natural fit for problems that contain a smaller copy of themselves: factorials, directory trees, parsing nested expressions. Every recursive method needs a **base case** that stops the chain.

## Factorial

```java run class
public class Main {
    static int factorial(int n) {
        if (n <= 1) {
            return 1;
        }
        return n * factorial(n - 1);
    }

    public static void main(String[] args) {
        System.out.println(factorial(5));
    }
}
```

`factorial(5)` calls `factorial(4)`, which calls `factorial(3)`, and so on. The base case returns `1` for `n <= 1`. Then the multiplications unwind: `2 * 1`, `3 * 2`, `4 * 6`, `5 * 24`.

## Following the call stack

```java run class
public class Main {
    static int sumTo(int n) {
        if (n == 0) {
            return 0;
        }
        int rest = sumTo(n - 1);
        System.out.println("n=" + n + ", rest=" + rest);
        return n + rest;
    }

    public static void main(String[] args) {
        System.out.println(sumTo(4));
    }
}
```

The print statements run **after** the recursive call returns, so they appear from the smallest `n` upward. This is the key difference from a loop: the work after the call happens on the way back out.

## Fibonacci

```java run class
public class Main {
    static int fib(int n) {
        if (n <= 1) {
            return n;
        }
        return fib(n - 1) + fib(n - 2);
    }

    public static void main(String[] args) {
        for (int i = 0; i <= 8; i++) {
            System.out.print(fib(i) + " ");
        }
        System.out.println();
    }
}
```

This version is correct but slow for large `n`, because it recomputes the same values many times. Recursion is elegant, not automatically efficient. Later you can add memoisation or use a loop.

## When recursion goes wrong

```java run class
public class Main {
    static int countdown(int n) {
        if (n == 0) {
            return 0;
        }
        return countdown(n - 1) + 1;
    }

    public static void main(String[] args) {
        System.out.println(countdown(5));
    }
}
```

If the base case is missing or unreachable, the calls never stop and the JVM throws `StackOverflowError`. Check two things: does every path reach a base case, and does each call move closer to it?

```java predict class id=recursion-predict title="What is printed?"
public class Main {
    static int factorial(int n) {
        if (n <= 1) return 1;
        return n * factorial(n - 1);
    }

    public static void main(String[] args) {
        System.out.println(factorial(4));
    }
}
--- options
* 24
12
10
4
--- explain
`4 * 3 * 2 * 1 = 24`. The base case returns `1` when `n` reaches 1.
```

## Challenges

```java exercise class id=recursive-factorial title="Write factorial recursively"
public class Main {
    // Define static int factorial(int n).

    public static void main(String[] args) {
        System.out.println(factorial(5));
    }
}
--- solution
public class Main {
    static int factorial(int n) {
        if (n <= 1) {
            return 1;
        }
        return n * factorial(n - 1);
    }

    public static void main(String[] args) {
        System.out.println(factorial(5));
    }
}
--- test
__check(Main.factorial(1) == 1, "1! is 1");
__check(Main.factorial(5) == 120, "5! is 120");
--- hint
The base case is `n <= 1`.
--- hint
Otherwise return `n * factorial(n - 1)`.
```

```java exercise class id=recursive-digit-sum title="Sum digits recursively"
public class Main {
    // Define static int digitSum(int n) for non-negative n.

    public static void main(String[] args) {
        System.out.println(digitSum(472));
    }
}
--- solution
public class Main {
    static int digitSum(int n) {
        if (n < 10) {
            return n;
        }
        return n % 10 + digitSum(n / 10);
    }

    public static void main(String[] args) {
        System.out.println(digitSum(472));
    }
}
--- test
__check(Main.digitSum(472) == 13, "4 + 7 + 2 is 13");
__check(Main.digitSum(9) == 9, "A single digit is its own sum");
--- hint
The last digit is `n % 10`; the rest of the number is `n / 10`.
--- hint
Base case: when `n < 10`, return `n`.
```

```java debug class id=fix-recursive-base title="Factorial returns zero"
public class Main {
    static int factorial(int n) {
        if (n == 0) {
            return 0;
        }
        return n * factorial(n - 1);
    }

    public static void main(String[] args) {
        System.out.println(factorial(4));
    }
}
--- solution
public class Main {
    static int factorial(int n) {
        if (n == 0) {
            return 1;
        }
        return n * factorial(n - 1);
    }

    public static void main(String[] args) {
        System.out.println(factorial(4));
    }
}
--- test
__check(Main.factorial(4) == 24, "4! is 24");
--- hint
Multiplying anything by zero gives zero. The empty product is `1`.
--- hint
Return `1` from the base case.
```
