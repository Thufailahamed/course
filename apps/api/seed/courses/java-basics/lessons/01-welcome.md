Java is one of the most widely used languages in the world. It runs Android apps, banking systems, search infrastructure, game servers and the tools developers use every day. Learning it well means you can read a large codebase, fix a bug under pressure, and understand the object-oriented ideas that show up in almost every engineering interview.

This course starts from nothing. You will write small programs, see what they print, and build up to three complete projects: a grade report, a to-do manager and a bank account. Every idea arrives next to a piece of code you can run, and most lessons end with challenges that check your work automatically.

## How the cells work

Each lesson is a notebook. Code lives in shaded **cells**, and you can edit any of them. Press **Run** to compile and execute the cell. Java is compiled, so the browser first runs `javac` and then starts the program — the first run of a lesson may take a few seconds while the compiler warms up.

```java run
System.out.println("Hello, learner!");
System.out.println("Two lines from two statements");
```

`System.out.println` prints its argument and then starts a new line. The text inside the double quotes is a **string**, and the quotation marks are not part of the output.

You can print numbers and do arithmetic directly:

```java run
System.out.println(3 * 7 + 1);
System.out.println(10 / 4);
System.out.println(10.0 / 4);
```

The second line prints `2`, not `2.5`, because both operands are integers. Integer division throws away the remainder. The third line uses a `double`, so the answer keeps its decimal part. That difference is one of the first things to internalise in Java.

## What you will need

Nothing to install. The Java compiler and a real JVM run inside this page. A modern browser and a little patience on the first load is all it takes.

> **Tip:** Work through the lessons in order. Each one builds on the last, and the checkpoint quizzes after every group of lessons tell you whether you are ready to move on.

## How challenges work

Some cells are marked as challenges. A challenge gives you a starting point that deliberately fails, a description of what to build, and hidden tests. Change the starter until every test passes. If you get stuck, reveal a hint; the hints get more specific each time.

Predict cells ask a different question: what will this print? Choose an answer before you run it. Getting a prediction wrong is one of the fastest ways to learn, because the explanation shows the rule you missed.

```java predict id=welcome-predict title="What does this print?"
int a = 7;
int b = 2;
System.out.println((a / b) + " " + (a % b));
--- options
* 3 1
3.5 1
3 2
2 1
--- explain
`a / b` is integer division, so `7 / 2` is `3`. The `%` operator gives the remainder, `1`. The string `" "` is joined between them, so the output is `3 1`.
```

The options are read top to bottom; the one marked with `*` is correct. When you pick an answer, the real program runs so you can compare.

## Your first goal

By the end of this section you will be able to write a complete Java program, store values in variables of the right type, and read the compiler errors Java gives you when something is wrong. Those three skills carry you through the rest of the language.

> **Pitfall:** Java is case-sensitive. `System` and `system` are different names, and `String` is not `string`. Most beginner compiler errors are a capital letter or a missing semicolon.
