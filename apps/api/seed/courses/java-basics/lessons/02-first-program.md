Every Java program is built from **statements**, and every statement ends with a semicolon. The statement you will use most as a beginner is `System.out.println`, which prints a value and moves to the next line.

Java is compiled. Before anything runs, `javac` checks the whole file for mistakes. That is why a missing semicolon stops the program before the first line executes — and why the compiler's message is often more useful than the program's output.

## Printing values

```java run
System.out.println("Hello, world!");
System.out.println(42);
System.out.println(3.5);
System.out.println(true);
```

Notice that strings keep their quotes in the code but not in the output. Numbers and booleans print as they are. Each `println` starts a new line.

`print` is the same method without the newline:

```java run
System.out.print("Loading");
System.out.print(".");
System.out.print(".");
System.out.println(" done");
```

Everything lands on one line because only the final call starts a new line.

## Comments

A comment is text the compiler ignores. Use it to explain *why* something is the way it is, not to repeat what the code already says.

```java run
// A single-line comment starts with two slashes.
System.out.println("This runs.");

/*
  A block comment can span several lines.
  It is useful for longer explanations.
*/
System.out.println("This runs too.");
```

## Escape sequences

Some characters cannot appear directly inside a string. Java uses a backslash to escape them:

```java run
System.out.println("She said, \"Java is fun.\"");
System.out.println("First line\nSecond line");
System.out.println("Name:\tAda");
System.out.println("A backslash: \\");
```

`\"` puts a quote inside the string, `\n` starts a new line, `\t` inserts a tab, and `\\` prints a single backslash.

## Reading compiler errors

Try running a cell with a mistake. The compiler prints the file and line number, then a message:

```text
Main.java:3: error: ';' expected
    System.out.println("Hello")
                               ^
```

The caret points at the place the compiler noticed the problem. The fix is on the line above: add the semicolon. Java reports the first error it cannot recover from, so fix that one before worrying about later messages.

```java predict id=first-program-predict title="What is printed?"
System.out.print("A");
System.out.print("B");
System.out.println("C");
--- options
* ABC
A B C
A
B
C
ABC
--- explain
`print` does not add a newline, so `A`, `B` and `C` are written one after another. `println` adds the newline at the end, producing a single line `ABC`.
```

## Challenges

```java exercise id=print-receipt title="Print a three-line receipt"
// Print exactly these three lines:
// Coffee
// 3.50
// Total: 3.50
System.out.println("Coffee");
--- solution
System.out.println("Coffee");
System.out.println("3.50");
System.out.println("Total: 3.50");
--- test
__check(__out().trim().equals("Coffee\n3.50\nTotal: 3.50"), "Print the item, the price and the total, each on its own line");
--- hint
You need three `println` calls, one per line.
--- hint
The total line is `Total: 3.50` — include the word and the colon.
```

```java exercise id=print-initials title="Build one line with print"
// Print JVM on a single line using print for the first two letters
// and println for the last one.
System.out.println("J");
System.out.println("V");
System.out.println("M");
--- solution
System.out.print("J");
System.out.print("V");
System.out.println("M");
--- test
__check(__out().trim().equals("JVM"), "The three letters should share one line");
--- hint
`print` does not move to the next line. Use it for `J` and `V`, then `println` for `M`.
```

```java debug id=fix-missing-semicolon title="Fix the code that will not compile"
System.out.println("Compiling")
System.out.println("and running");
--- solution
System.out.println("Compiling");
System.out.println("and running");
--- test
__check(__out().trim().equals("Compiling\nand running"), "Both lines should print after the code compiles");
--- hint
Read the compiler error. It points at the end of the first line.
--- hint
Every statement in Java ends with a semicolon.
```
