Java's number types are precise about what they can hold. `int` is a 32-bit whole number, `long` is 64-bit, and `double` stores decimals in the same approximate way most languages do. Choosing the right type prevents a surprising amount of trouble.

## Arithmetic and precedence

```java run
int a = 17;
int b = 5;

System.out.println(a + b);
System.out.println(a - b);
System.out.println(a * b);
System.out.println(a / b);
System.out.println(a % b);
```

`*`, `/` and `%` happen before `+` and `-`, just like in maths. Use parentheses when you want a different order:

```java run
System.out.println(2 + 3 * 4);
System.out.println((2 + 3) * 4);
System.out.println(10 - 4 - 3);
System.out.println(10 - (4 - 3));
```

The first prints `14`, the second `20`. Subtraction is left-associative, so the third prints `3`; the parentheses in the fourth change it to `9`.

## Integer division and remainders

With two `int` values, `/` throws away the fraction. `%` gives what is left over:

```java run
int totalSeconds = 367;
int minutes = totalSeconds / 60;
int seconds = totalSeconds % 60;
System.out.println(minutes + " minutes and " + seconds + " seconds");
```

This "divide and remainder" pair appears everywhere: converting currencies, splitting work into pages, and pulling digits out of a number.

## The Math class

`Math` is a utility class with common operations. It is already available, so no import is needed for these calls:

```java run
System.out.println(Math.abs(-7));
System.out.println(Math.max(12, 30));
System.out.println(Math.min(12, 30));
System.out.println(Math.pow(2, 10));
System.out.println(Math.sqrt(81));
System.out.println(Math.round(3.6));
```

`Math.pow` returns a `double`, even when both arguments are whole numbers. `Math.round` returns a `long`.

## Converting between number types

A value can widen automatically when there is no loss, for example `int` to `double`. Going the other way needs a **cast**, and a cast truncates:

```java run
int whole = 42;
double widened = whole;
System.out.println(widened);

double price = 19.99;
int truncated = (int) price;
System.out.println(truncated);

int count = 10;
count += 5;
count *= 2;
System.out.println(count);
```

`(int) 19.99` is `19`, not `20`. If you want rounding, call `Math.round` first. Compound assignments such as `+=` and `*=` update a variable in place.

```java predict id=numbers-predict title="What does Java print?"
System.out.println(-7 % 3);
--- options
* -1
1
-2
2
--- explain
In Java the remainder keeps the sign of the left operand. `-7 / 3` is `-2` (truncating toward zero), and `-7 - (-2 * 3)` is `-1`.
```

## Challenges

```java exercise id=average-three title="Average three integers"
int a = 7;
int b = 8;
int c = 10;
double average = 0;

// Compute the average with a decimal result.
--- solution
int a = 7;
int b = 8;
int c = 10;
double average = (a + b + c) / 3.0;
--- test
__check(Math.abs(average - 8.333333333333334) < 0.0001, "The average of 7, 8 and 10 is 8.333...");
--- hint
Add the three values first, then divide by `3.0`.
--- hint
`double average = (a + b + c) / 3.0;`
```

```java exercise id=digit-sum title="Sum the digits of a number"
int number = 472;
int sum = 0;

// Use / and % to add the three digits.
--- solution
int number = 472;
int sum = 0;

sum += number % 10;
number /= 10;
sum += number % 10;
number /= 10;
sum += number % 10;
--- test
__check(sum == 13, "4 + 7 + 2 is 13");
--- hint
`number % 10` gives the last digit. `number / 10` removes it.
--- hint
Repeat the pair three times, once for each digit.
```

```java debug id=fix-integer-average title="The average is missing its decimal"
int a = 3;
int b = 4;
double average = (a + b) / 2;
System.out.println(average);
--- solution
int a = 3;
int b = 4;
double average = (a + b) / 2.0;
System.out.println(average);
--- test
__check(__out().trim().equals("3.5"), "The average of 3 and 4 is 3.5");
--- hint
The division happens before the result is stored in the `double`.
--- hint
Change `2` to `2.0` so the division uses decimal arithmetic.
```
