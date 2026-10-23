A **variable** is a named box that holds a value. In Java every box has a fixed **type**, and the compiler refuses to put the wrong kind of value inside it. That strictness feels fussy at first; later it is what lets a large program fail at compile time instead of in front of a user.

## Declaring and using variables

```java run
int age = 36;
double price = 19.99;
char grade = 'A';
boolean ready = true;
String name = "Ada";

System.out.println(name + " is " + age);
System.out.println("Price: " + price);
System.out.println("Grade: " + grade);
System.out.println("Ready? " + ready);
```

`int` holds whole numbers, `double` holds decimals, `char` holds one character in single quotes, `boolean` is `true` or `false`, and `String` holds text in double quotes. `String` is a class, so its name is capitalised; the other four are primitives and use lowercase.

A variable can be changed after it is declared, as long as the new value has the same type:

```java run
int score = 10;
System.out.println(score);
score = 25;
score = score + 5;
System.out.println(score);
```

The `=` sign means "store the value on the right in the variable on the left". It is not a question. `score = score + 5` reads the old value, adds five, and stores the result back.

## Names and constants

Variable names start with a letter, `$` or `_`, and cannot contain spaces. By convention Java uses `camelCase` for variables and methods, and `PascalCase` for classes. Choose names that say what the value means: `totalPrice`, not `x`.

Add `final` when a value should never change. The compiler enforces it:

```java run
final double TAX_RATE = 0.2;
double subtotal = 50.0;
double total = subtotal * (1 + TAX_RATE);

System.out.println("Subtotal: " + subtotal);
System.out.println("Total: " + total);
```

Constants are written in `UPPER_SNAKE_CASE` by convention. Trying to assign to `TAX_RATE` again would be a compile error, which is exactly what you want for a value that must stay fixed.

## Types decide what operations mean

```java run
int items = 7;
int people = 2;
System.out.println(items / people);
System.out.println(items % people);

double exactItems = 7;
System.out.println(exactItems / people);

String label = "Items: " + items;
System.out.println(label);
```

Integer division gives `3`, and `%` gives the remainder `1`. Mixing a `double` into the division gives `3.5`. When one side of `+` is a `String`, Java converts the other side to text and joins them.

```java predict id=variables-predict title="What does this print?"
int apples = 4;
int oranges = 3;
System.out.println("Total: " + apples + oranges);
--- options
* Total: 43
Total: 7
7
Total: 4 3
--- explain
`+` is evaluated left to right. `"Total: " + apples` becomes the string `"Total: 4"`, and then `+ oranges` joins `3`, giving `"Total: 43"`. Use `(apples + oranges)` if you want the sum first.
```

## Challenges

```java exercise id=swap-values title="Swap two variables"
int a = 3;
int b = 8;

// Swap the values so a is 8 and b is 3.
--- solution
int a = 3;
int b = 8;

int temp = a;
a = b;
b = temp;
--- test
__check(a == 8 && b == 3, "a should be 8 and b should be 3");
--- hint
If you write `a = b` first, the old value of `a` is lost. Save it in a third variable.
--- hint
Use `int temp = a;`, then `a = b;`, then `b = temp;`.
```

```java exercise id=celsius-to-fahrenheit title="Convert Celsius to Fahrenheit"
int celsius = 25;
double fahrenheit = 0;

// Use the formula F = C * 9 / 5 + 32.
--- solution
int celsius = 25;
double fahrenheit = celsius * 9.0 / 5 + 32;
--- test
__check(Math.abs(fahrenheit - 77.0) < 0.0001, "25 Celsius is 77 Fahrenheit");
--- hint
Use `9.0`, not `9`, or integer division will drop the fraction.
--- hint
`double fahrenheit = celsius * 9.0 / 5 + 32;`
```

```java debug id=fix-score-type title="The score will not compile"
int score = "95";
System.out.println("Score: " + score);
--- solution
int score = 95;
System.out.println("Score: " + score);
--- test
__check(__out().trim().equals("Score: 95"), "The output should be Score: 95");
--- hint
`"95"` is a string because of the quotes. `int` needs a number without quotes.
--- hint
Remove the quotes around `95`.
```
