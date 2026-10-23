Programs rarely receive values in exactly the type they need. A command-line argument arrives as text, a price may need rounding to cents, and a calculation may outgrow its variable. This lesson is about moving safely between types.

## Widening and narrowing

A **widening** conversion happens automatically when no information can be lost: `int` to `long`, `int` to `double`, `char` to `int`. A **narrowing** conversion needs a cast and may lose information:

```java run
int count = 42;
long big = count;
double decimal = count;

System.out.println(big);
System.out.println(decimal);

double price = 19.99;
int truncated = (int) price;
System.out.println(truncated);

long population = 8_000_000_000L;
int tooSmall = (int) population;
System.out.println(tooSmall);
```

`(int) 19.99` truncates to `19`. Casting a `long` that does not fit into an `int` wraps around to an unrelated value, so only cast when you know the range is safe.

## Text to numbers

```java run
String quantityText = "12";
String priceText = "4.75";

int quantity = Integer.parseInt(quantityText);
double price = Double.parseDouble(priceText);
double total = quantity * price;

System.out.println(String.format("%d x %.2f = %.2f", quantity, price, total));
```

`Integer.parseInt` returns an `int`. `Double.parseDouble` returns a `double`. If the text contains spaces or currency symbols, trim or remove them first. An invalid value throws `NumberFormatException`, which we will handle properly with exceptions later.

## Number to text

```java run
int score = 95;
double rate = 0.5;

String scoreText = String.valueOf(score);
String rateText = Double.toString(rate);

System.out.println(scoreText + rateText);
System.out.println("Score: " + score);
```

Concatenating with `""` also converts a value to text, but `String.valueOf` states the intent more clearly. `Integer.toString`, `Double.toString` and `String.format` are all useful depending on the context.

## A first look at input

On a desktop, `Scanner` reads typed input:

```text
import java.util.Scanner;

Scanner scanner = new Scanner(System.in);
System.out.print("Your name: ");
String name = scanner.nextLine();
System.out.println("Hello, " + name);
```

The first line is an import; the rest belongs inside a method. This browser runtime does not provide interactive standard input, so the lessons use fixed values and parsed strings instead. The parsing skills are the same ones you need when the text comes from a file, a web form or a command-line argument.

## When arithmetic overflows

```java run
int max = Integer.MAX_VALUE;
System.out.println(max);
System.out.println(max + 1);

long safe = 2_000_000_000L * 2;
System.out.println(safe);
```

An `int` cannot hold `2,147,483,648`, so adding one wraps around to the smallest negative value. Use a `long` when the result may exceed about two billion, and write the literal with an `L` suffix so the multiplication itself uses 64 bits.

```java predict id=conversion-predict title="What is printed?"
System.out.println((int) 3.99);
--- options
* 3
4
3.99
3.0
--- explain
Casting a `double` to `int` truncates toward zero; it does not round. Use `Math.round(3.99)` if you want `4`.
```

## Challenges

```java exercise id=parse-price title="Parse a price from text"
String priceText = "12.50";
double price = 0;

// Convert the text to a double.
--- solution
String priceText = "12.50";
double price = Double.parseDouble(priceText);
--- test
__check(Math.abs(price - 12.5) < 0.0001, "The parsed price should be 12.5");
--- hint
Use `Double.parseDouble`.
--- hint
`double price = Double.parseDouble(priceText);`
```

```java exercise id=round-to-int title="Round a decimal to the nearest integer"
double value = 9.99;
int rounded = 0;

// Round to the nearest whole number, not truncate.
--- solution
double value = 9.99;
int rounded = (int) Math.round(value);
--- test
__check(rounded == 10, "9.99 rounds to 10");
--- hint
`Math.round` returns a `long`; cast it to `int`.
--- hint
`int rounded = (int) Math.round(value);`
```

```java debug id=fix-long-overflow title="The population calculation is negative"
long total = 2_000_000_000 * 2;
System.out.println(total);
--- solution
long total = 2_000_000_000L * 2;
System.out.println(total);
--- test
__check(__out().trim().equals("4000000000"), "Two billion times two is four billion");
--- hint
Both operands are `int`, so the multiplication happens in 32 bits before the result is stored.
--- hint
Put an `L` after the first number: `2_000_000_000L * 2`.
```
