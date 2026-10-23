Real text arrives messy: names with extra spaces, comma-separated lists, numbers still wearing their string clothes. This lesson adds the tools that turn raw text into structured values, and a mutable helper for building strings efficiently.

## Formatting output

`String.format` builds a string from a template. The percent sign starts a placeholder:

```java run
String name = "Ada";
int score = 95;
double ratio = 0.875;

System.out.println(String.format("%s scored %d points", name, score));
System.out.println(String.format("Ratio: %.2f", ratio));
System.out.println(String.format("%-8s|", name));
System.out.println(String.format("%8s|", name));
```

`%s` is a string, `%d` is an integer, and `%.2f` is a decimal with two places. The width and alignment can be controlled: `%-8s` pads on the right, `%8s` pads on the left. `System.out.printf` is a shortcut that prints the formatted result directly.

## Splitting text

```java run
String csv = "red,green,blue";
String[] colors = csv.split(",");

System.out.println(colors.length);
System.out.println(colors[0]);
System.out.println(colors[2]);
```

`split` returns an array of strings. The delimiter is a regular expression, so a few characters such as `.` and `|` need escaping; a comma or a space works as written. We will use arrays properly in a later lesson.

## Building strings with StringBuilder

Strings are immutable, so joining many pieces with `+` creates a new string each time. `StringBuilder` avoids that:

```java run
StringBuilder builder = new StringBuilder();
builder.append("Latent");
builder.append(" ");
builder.append("Java");
builder.append("!");
System.out.println(builder.toString());
System.out.println(builder.length());
```

`append` returns the same builder, so calls can be chained. Convert it back to a `String` with `toString()` before printing or comparing.

## Parsing numbers

Text that looks like a number is still text. `Integer.parseInt` and `Double.parseDouble` convert it:

```java run
String countText = "42";
String priceText = "19.99";

int count = Integer.parseInt(countText);
double price = Double.parseDouble(priceText);

System.out.println(count + 1);
System.out.println(price * 2);
```

If the text is not a valid number, parsing throws `NumberFormatException`. In a real program, validate input before parsing it.

```java predict id=string-methods-predict title="What is printed?"
String csv = "a,b,c";
System.out.println(csv.split(",").length);
--- options
* 3
2
4
a,b,c
--- explain
`split(",")` produces three strings: `"a"`, `"b"` and `"c"`. The array's `length` is 3.
```

## Challenges

```java exercise id=name-initials title="Turn a full name into initials"
String fullName = "Ada Lovelace";
String initials = "";

// Split on the space and build "A.L."
--- solution
String fullName = "Ada Lovelace";
String[] parts = fullName.split(" ");
String initials = parts[0].charAt(0) + "." + parts[1].charAt(0) + ".";
--- test
__check(initials.equals("A.L."), "The initials of Ada Lovelace are A.L.");
--- hint
`split(" ")` gives an array with the first and last name.
--- hint
Take `charAt(0)` from each part and join them with dots.
```

```java exercise id=reverse-word title="Reverse a word with StringBuilder"
String word = "hello";
String reversed = "";

// Use a StringBuilder to reverse the word.
--- solution
String word = "hello";
String reversed = new StringBuilder(word).reverse().toString();
--- test
__check(reversed.equals("olleh"), "hello reversed is olleh");
--- hint
Create a `StringBuilder` from the word, call `reverse()`, then `toString()`.
--- hint
`new StringBuilder(word).reverse().toString()`
```

```java debug id=fix-split-index title="The last name crashes the program"
String fullName = "Grace Hopper";
String[] parts = fullName.split(" ");
System.out.println(parts[2]);
--- solution
String fullName = "Grace Hopper";
String[] parts = fullName.split(" ");
System.out.println(parts[1]);
--- test
__check(__out().trim().equals("Hopper"), "The last name is Hopper");
--- hint
Arrays are zero-indexed. A two-word name has indexes 0 and 1.
--- hint
Print `parts[1]`.
```
