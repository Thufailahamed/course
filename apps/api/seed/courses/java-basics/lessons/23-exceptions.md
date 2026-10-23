An **exception** is Java's way of saying that something went wrong. Instead of returning a special value and hoping every caller checks it, the method stops and an exception travels up the call stack until something catches it.

## Catching an exception

```java run
String text = "not a number";

try {
    int value = Integer.parseInt(text);
    System.out.println(value);
} catch (NumberFormatException e) {
    System.out.println("That was not a number.");
}
```

The `try` block holds code that might fail. If it throws, control jumps to the matching `catch`. The variable `e` is the exception object; `e.getMessage()` usually explains what happened.

## Different exception types

```java run
int[] values = {1, 2, 3};

try {
    System.out.println(values[5]);
} catch (ArrayIndexOutOfBoundsException e) {
    System.out.println("Index out of range");
}

try {
    System.out.println(10 / 0);
} catch (ArithmeticException e) {
    System.out.println("Cannot divide by zero");
}
```

Catch the specific type you expect. A catch for `Exception` catches almost everything, including bugs you did not anticipate; that can hide problems instead of handling them.

## Throwing your own

```java run
int age = -5;

try {
    if (age < 0) {
        throw new IllegalArgumentException("Age cannot be negative");
    }
    System.out.println("Age: " + age);
} catch (IllegalArgumentException e) {
    System.out.println("Rejected: " + e.getMessage());
}
```

`throw` raises an exception immediately. `IllegalArgumentException` is the standard choice when a caller passes a value that violates the method's contract.

## finally

```java run
try {
    System.out.println("Opening resource");
    throw new RuntimeException("boom");
} catch (RuntimeException e) {
    System.out.println("Handled: " + e.getMessage());
} finally {
    System.out.println("Cleanup always runs");
}
```

The `finally` block runs whether the try succeeds, throws, or returns. Use it for cleanup such as closing a file. In modern Java, try-with-resources is often cleaner for that job.

```java predict id=exceptions-predict title="What is printed?"
try {
    int value = Integer.parseInt("abc");
    System.out.println("parsed");
} catch (NumberFormatException e) {
    System.out.print("caught ");
} finally {
    System.out.print("done");
}
System.out.println();
--- options
* caught done
parsed done
caught
done
--- explain
`"abc"` cannot be parsed, so the catch prints `caught `. The finally block always runs and prints `done`, giving `caught done`.
```

## Challenges

```java exercise id=safe-parse title="Parse safely with a fallback"
String text = "42";
int value = 0;

// Parse text. If it is invalid, set value to -1.
--- solution
String text = "42";
int value;

try {
    value = Integer.parseInt(text);
} catch (NumberFormatException e) {
    value = -1;
}
--- test
__check(value == 42, "42 parses to 42");
--- hint
Put the parse inside `try` and assign `-1` in the `catch`.
--- hint
Catch `NumberFormatException`.
```

```java exercise id=safe-divide title="Divide with a fallback"
int numerator = 10;
int denominator = 0;
int result = 0;

// Set result to numerator / denominator, or -1 if the division fails.
--- solution
int numerator = 10;
int denominator = 0;
int result;

try {
    result = numerator / denominator;
} catch (ArithmeticException e) {
    result = -1;
}
--- test
__check(result == -1, "Dividing by zero should fall back to -1");
--- hint
Catch `ArithmeticException`.
--- hint
Assign `-1` in the catch block.
```

```java debug id=fix-catch-order title="The catch blocks are in the wrong order"
String text = "42";
try {
    int value = Integer.parseInt(text);
    System.out.println(value);
} catch (Exception e) {
    System.out.println("general");
} catch (NumberFormatException e) {
    System.out.println("number");
}
--- solution
String text = "42";
try {
    int value = Integer.parseInt(text);
    System.out.println(value);
} catch (NumberFormatException e) {
    System.out.println("number");
} catch (Exception e) {
    System.out.println("general");
}
--- test
__check(__out().trim().equals("42"), "Valid input should print 42");
--- hint
Java rejects a specific catch that comes after a broader one, because it would be unreachable.
--- hint
Put `NumberFormatException` before `Exception`.
```
