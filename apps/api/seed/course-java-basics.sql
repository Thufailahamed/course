DELETE FROM exercise_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_java_basics');

DELETE FROM quiz_attempts WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_java_basics');

DELETE FROM notes WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_java_basics');

DELETE FROM lesson_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_java_basics');

DELETE FROM discussions WHERE course_id = 'crs_java_basics';

DELETE FROM certificates WHERE course_id = 'crs_java_basics';

DELETE FROM enrollments WHERE course_id = 'crs_java_basics';

DELETE FROM reviews WHERE course_id = 'crs_java_basics';

DELETE FROM wishlist WHERE course_id = 'crs_java_basics';

DELETE FROM path_courses WHERE course_id = 'crs_java_basics';

DELETE FROM coupons WHERE course_id = 'crs_java_basics';

DELETE FROM lessons WHERE course_id = 'crs_java_basics';

DELETE FROM sections WHERE course_id = 'crs_java_basics';

UPDATE order_items SET course_id = NULL WHERE course_id = 'crs_java_basics';

DELETE FROM courses WHERE id = 'crs_java_basics';

INSERT OR IGNORE INTO categories (id, slug, name, description, icon, sort_order) VALUES ('cat_programming', 'programming', 'Programming', 'Python from first principles: core language, clean code and real projects.', 'code', 9);

INSERT INTO courses (id, slug, title, subtitle, description, category_id, instructor_id, level, language, price_cents, compare_at_price_cents, currency, thumbnail_key, preview_video_url, accent, status, featured, what_you_learn, requirements, target_audience, tags, duration_minutes, lessons_count, rating_avg, rating_count, students_count, published_at, created_at, updated_at) VALUES
('crs_java_basics', 'java-basics', 'Java Basics: The Interactive Course', 'Go from your first line of code to real programs, writing, running and debugging Java right in your browser.', 'Most beginner courses have you watch someone else type. This one puts the keyboard in your hands from the first minute: **every lesson is a live coding environment** with a real Java compiler and JVM running inside your browser.

## Learn by doing, not by watching

- **No videos, no installs.** Read a short explanation, run the code, change it, break it and fix it, right on the page.
- **Over 100 hands-on challenges.** Each one is checked by hidden tests, with progressive hints when you''re stuck.
- **Debug challenges.** Real beginner bugs (off-by-one loops, `=` instead of `==`, integer division, null references) that you track down and fix.
- **Predict-the-output questions** train you to read code like an experienced developer before you run it.
- **Atlas, your AI tutor,** explains any compiler error or exception in plain language without handing you the answer.

## From zero to real programs

You''ll start with `System.out.println("Hello")` and finish by building three complete projects: a **grade report** that summarizes student data, a **to-do manager** built with objects and lists, and a **bank account** built with classes, encapsulation and exceptions.

## Built for what comes next

Everything here is the foundation for Android, Spring, backend services and a CS degree. Java''s static types, collections and object model show up in almost every codebase you will meet.', 'cat_programming', 'usr_arjun', 'beginner', 'English', 0, NULL, 'USD', NULL, NULL, 25, 'published', 1, '["Write and run Java from a blank page, with nothing to install","Master variables, types, strings, conditionals, loops and arrays","Organize data with ArrayList, HashMap and HashSet, and sort it with confidence","Write methods and classes that model real things, and understand inheritance and interfaces","Read compiler errors and stack traces, and fix bugs instead of guessing","Build three complete projects: a grade report, a to-do list and a bank account"]', '["No programming experience at all. We start from the very first line","A modern browser. Java and its compiler run inside the page, so there''s nothing to install"]', '["Complete beginners who want a thorough, practical first language","Students preparing for a CS course, AP Computer Science or a coding interview","Developers from Python, JavaScript or other languages who need Java''s static types and object model","Anyone who wants to build Android apps, backend services or enterprise software later"]', '["Java","Interactive","Programming","Beginner","Object-Oriented"]', 591, 38, 0, 0, 18320, '2025-09-10T06:04:00.410Z', '2025-08-11T06:04:00.410Z', '2026-10-14T06:04:00.410Z');

INSERT INTO sections (id, course_id, title, position, created_at) VALUES
('sec_java_basics_1', 'crs_java_basics', 'Getting Started', 0, '2026-06-25T06:04:00.410Z'),
('sec_java_basics_2', 'crs_java_basics', 'Numbers, Text & Truth', 1, '2026-06-25T06:04:00.410Z'),
('sec_java_basics_3', 'crs_java_basics', 'Decisions & Loops', 2, '2026-06-25T06:04:00.410Z'),
('sec_java_basics_4', 'crs_java_basics', 'Collections', 3, '2026-06-25T06:04:00.410Z'),
('sec_java_basics_5', 'crs_java_basics', 'Methods', 4, '2026-06-25T06:04:00.410Z'),
('sec_java_basics_6', 'crs_java_basics', 'Errors, Files & Packages', 5, '2026-06-25T06:04:00.410Z'),
('sec_java_basics_7', 'crs_java_basics', 'Objects & Classes', 6, '2026-06-25T06:04:00.410Z'),
('sec_java_basics_8', 'crs_java_basics', 'Capstone Projects', 7, '2026-06-25T06:04:00.410Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_java_basics_1_1', 'sec_java_basics_1', 'crs_java_basics', 'How this course works', 'interactive', 0, 480, NULL, NULL, 'Java is one of the most widely used languages in the world. It runs Android apps, banking systems, search infrastructure, game servers and the tools developers use every day. Learning it well means you can read a large codebase, fix a bug under pressure, and understand the object-oriented ideas that show up in almost every engineering interview.

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
', 1, '[]', '[{"title":"The Java Tutorials (Oracle)","url":"https://docs.oracle.com/javase/tutorial/"},{"title":"Java API specification","url":"https://docs.oracle.com/en/java/javase/17/docs/api/"}]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_1_2', 'sec_java_basics_1', 'crs_java_basics', 'Your first program: println, comments and errors', 'interactive', 1, 840, NULL, NULL, 'Every Java program is built from **statements**, and every statement ends with a semicolon. The statement you will use most as a beginner is `System.out.println`, which prints a value and moves to the next line.

Java is compiled. Before anything runs, `javac` checks the whole file for mistakes. That is why a missing semicolon stops the program before the first line executes — and why the compiler''s message is often more useful than the program''s output.

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
Main.java:3: error: '';'' expected
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
', 1, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_1_3', 'sec_java_basics_1', 'crs_java_basics', 'Variables and types: giving names to values', 'interactive', 2, 960, NULL, NULL, 'A **variable** is a named box that holds a value. In Java every box has a fixed **type**, and the compiler refuses to put the wrong kind of value inside it. That strictness feels fussy at first; later it is what lets a large program fail at compile time instead of in front of a user.

## Declaring and using variables

```java run
int age = 36;
double price = 19.99;
char grade = ''A'';
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
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_1_4', 'sec_java_basics_1', 'crs_java_basics', 'Checkpoint: getting started', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"What does `System.out.println(\"Java\")` display?","options":["`\"Java\"` with the quotation marks","`Java` without the quotation marks","`System.out.println`","Nothing until you call `print`"],"answerIndex":1,"explanation":"The quotes mark the text in the source code. `println` prints the characters between them, not the quotes themselves."},{"id":"q2","prompt":"A Java cell is missing a semicolon at the end of one statement. What happens when you run it?","options":["The earlier statements run, then the bad line is skipped","Only the bad line is skipped and the rest runs","The whole cell fails to compile and nothing runs","Java adds the semicolon automatically"],"answerIndex":2,"explanation":"Java is compiled before it runs. A syntax error anywhere in the cell prevents the whole cell from compiling, so no statement executes."},{"id":"q3","prompt":"What is the difference between `print` and `println`?","options":["`print` adds a newline; `println` does not","`print` only accepts strings; `println` accepts any type","`println` adds a newline after the value; `print` does not","They are identical in Java"],"answerIndex":2,"explanation":"Both write a value, but `println` moves to the next line afterwards. `print` leaves the cursor on the same line."},{"id":"q4","prompt":"Which declaration correctly stores the text `hello`?","options":["`String greeting = \"hello\";`","`string greeting = ''hello'';`","`String greeting = ''hello'';`","`str greeting = \"hello\";`"],"answerIndex":0,"explanation":"`String` is capitalised, and a string uses double quotes. Single quotes are for a single `char`."},{"id":"q5","prompt":"What does `System.out.println(7 / 2)` display?","options":["`3.5`","`3`","`4`","A compile error"],"answerIndex":1,"explanation":"Both operands are `int`, so Java performs integer division and discards the remainder. Use `7 / 2.0` for `3.5`."},{"id":"q6","prompt":"What does `System.out.println(\"Total: \" + 4 + 3)` display?","options":["`Total: 7`","`Total: 43`","`7`","`Total: 4 3`"],"answerIndex":1,"explanation":"Evaluation goes left to right. `\"Total: \" + 4` becomes the string `\"Total: 4\"`, and adding `3` joins another character, giving `Total: 43`."},{"id":"q7","prompt":"Which value can be stored in a `boolean` variable?","options":["`\"true\"`","`1`","`true`","`''true''`"],"answerIndex":2,"explanation":"A `boolean` holds the literal `true` or `false`, without quotes. The quoted version is a `String`, `1` is an `int`, and `''true''` is not a valid `char`."},{"id":"q8","prompt":"How do you declare a variable that holds a single letter `A`?","options":["`char letter = \"A\";`","`char letter = ''A'';`","`String letter = ''A'';`","`letter char = ''A'';`"],"answerIndex":1,"explanation":"A `char` uses single quotes around exactly one character. Double quotes would make a `String`."},{"id":"q9","prompt":"Which variable name is valid Java?","options":["`2ndPlace`","`total-price`","`totalPrice`","`class`"],"answerIndex":2,"explanation":"Names cannot start with a digit, cannot contain a hyphen, and cannot be a reserved word such as `class`. `totalPrice` follows camelCase convention."},{"id":"q10","prompt":"What happens if you try to assign a new value to a variable declared `final`?","options":["The value changes, but a warning is printed","The assignment is ignored","The code does not compile","The variable becomes a `String`"],"answerIndex":2,"explanation":"`final` means the variable can be assigned once. A later assignment is a compile-time error, which is useful for constants."}]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_2_1', 'sec_java_basics_2', 'crs_java_basics', 'Numbers and arithmetic', 'interactive', 0, 960, NULL, NULL, 'Java''s number types are precise about what they can hold. `int` is a 32-bit whole number, `long` is 64-bit, and `double` stores decimals in the same approximate way most languages do. Choosing the right type prevents a surprising amount of trouble.

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
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_2_2', 'sec_java_basics_2', 'crs_java_basics', 'Strings: text, concatenation and length', 'interactive', 1, 1080, NULL, NULL, 'A `String` is a sequence of characters. Unlike the primitive types, it is an object with methods, and it is **immutable**: once created, its characters never change. Every method that seems to modify a string actually returns a new one.

## Creating and joining strings

```java run
String first = "Ada";
String last = "Lovelace";
String full = first + " " + last;

System.out.println(full);
System.out.println("Length: " + full.length());
System.out.println("Upper: " + full.toUpperCase());
System.out.println("Lower: " + full.toLowerCase());
```

The `+` operator joins strings. `length()` counts characters, including spaces. `toUpperCase()` and `toLowerCase()` return new strings; they do not alter `full`.

## Indexing and slicing

Characters are numbered from zero. `charAt(0)` is the first character. `substring(start, end)` includes `start` but stops before `end`:

```java run
String word = "programming";

System.out.println(word.charAt(0));
System.out.println(word.charAt(word.length() - 1));
System.out.println(word.substring(0, 4));
System.out.println(word.substring(4));
```

`substring(0, 4)` gives `"prog"`. `substring(4)` runs to the end and gives `"ramming"`. Asking for an index outside the string throws an exception, so check `length()` when the input is not fixed.

## Comparing strings

Use `equals`, not `==`, to compare text. `==` asks whether two variables point at the same object; `equals` asks whether the characters are the same:

```java run
String a = "java";
String b = "java";
String c = new String("java");

System.out.println(a == b);
System.out.println(a == c);
System.out.println(a.equals(c));
System.out.println(a.equalsIgnoreCase("JAVA"));
```

The first is `true` because identical literals share storage. The second is `false` because `new String` creates a separate object. The third is `true` because the contents match. In real programs, always use `equals` for text.

## Useful methods

```java run
String sentence = "  Learning Java is fun  ";

System.out.println(sentence.trim());
System.out.println(sentence.trim().contains("Java"));
System.out.println(sentence.trim().startsWith("Learn"));
System.out.println(sentence.trim().endsWith("fun"));
System.out.println(sentence.replace("fun", "worthwhile"));
System.out.println(sentence.indexOf("Java"));
System.out.println(String.join(" | ", "one", "two", "three"));
```

`trim()` removes leading and trailing spaces. `contains`, `startsWith` and `endsWith` return booleans. `replace` returns a new string. `indexOf` returns the position of the first match, or `-1` if it is absent.

```java predict id=strings-predict title="What is printed?"
String s = "Java";
System.out.println(s.substring(1, 3));
--- options
* av
ava
Ja
va
--- explain
`substring(1, 3)` starts at index 1 (`a`) and stops before index 3, so it returns the characters at indexes 1 and 2: `"av"`.
```

## Challenges

```java exercise id=make-username title="Build a username"
String first = "Ada";
String last = "Lovelace";
String username = "";

// Join the lower-case first name, a dot, and the lower-case last name.
--- solution
String first = "Ada";
String last = "Lovelace";
String username = first.toLowerCase() + "." + last.toLowerCase();
--- test
__check(username.equals("ada.lovelace"), "The username should be ada.lovelace");
--- hint
Call `toLowerCase()` on each name before joining them.
--- hint
`first.toLowerCase() + "." + last.toLowerCase()`
```

```java exercise id=first-last-letter title="Print the first and last letters"
String word = "programming";

// Print the first character, a space, and the last character.
--- solution
String word = "programming";
System.out.println(word.charAt(0) + " " + word.charAt(word.length() - 1));
--- test
__check(__out().trim().equals("p g"), "The output should be p g");
--- hint
The last index is `word.length() - 1`.
--- hint
Join `charAt(0)`, `" "`, and `charAt(word.length() - 1)`.
```

```java debug id=fix-string-compare title="The answer is rejected"
String answer = new String("yes");
System.out.println(answer == "yes" ? "accepted" : "rejected");
--- solution
String answer = new String("yes");
System.out.println(answer.equals("yes") ? "accepted" : "rejected");
--- test
__check(__out().trim().equals("accepted"), "A matching answer should be accepted");
--- hint
`==` compares object references, not the characters inside the strings.
--- hint
Replace `answer == "yes"` with `answer.equals("yes")`.
```
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_2_3', 'sec_java_basics_2', 'crs_java_basics', 'String methods and formatting', 'interactive', 2, 1080, NULL, NULL, 'Real text arrives messy: names with extra spaces, comma-separated lists, numbers still wearing their string clothes. This lesson adds the tools that turn raw text into structured values, and a mutable helper for building strings efficiently.

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
`split(",")` produces three strings: `"a"`, `"b"` and `"c"`. The array''s `length` is 3.
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
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_2_4', 'sec_java_basics_2', 'crs_java_basics', 'Booleans, comparisons and logic', 'interactive', 3, 960, NULL, NULL, 'A `boolean` is either `true` or `false`. Comparisons produce booleans, and logical operators combine them. Almost every decision a program makes is a boolean behind the scenes.

## Comparisons

```java run
int age = 20;
System.out.println(age > 18);
System.out.println(age >= 20);
System.out.println(age < 18);
System.out.println(age == 20);
System.out.println(age != 20);
```

The result of each comparison is a boolean, which prints as `true` or `false`. Use `==` for equality and `!=` for inequality. A single `=` assigns; a double `==` compares.

Strings need `equals` instead of `==`, as the previous lesson showed:

```java run
String role = "admin";
System.out.println(role.equals("admin"));
System.out.println(role.equalsIgnoreCase("ADMIN"));
System.out.println(!role.isEmpty());
```

## Combining conditions

`&&` means **and**, `||` means **or**, and `!` means **not**. `&&` binds more tightly than `||`, so parentheses are often clearer:

```java run
int age = 16;
boolean hasTicket = true;

System.out.println(age >= 18 && hasTicket);
System.out.println(age >= 18 || hasTicket);
System.out.println(!hasTicket);
System.out.println((age >= 13 && age <= 19) || hasTicket);
```

Both `&&` and `||` short-circuit. In `a && b`, if `a` is false, `b` is not evaluated. In `a || b`, if `a` is true, `b` is not evaluated. That matters when the right side has a side effect or could throw.

```java run
int count = 0;
boolean result = false && (++count > 0);
System.out.println(result);
System.out.println(count);

boolean other = true || (++count > 0);
System.out.println(other);
System.out.println(count);
```

`count` stays `0` in both cases because the right side never runs. Short-circuiting is a feature, not a quirk: it lets you write `name != null && name.length() > 0` safely.

## Boolean values from text

```java run
String flag = "true";
boolean enabled = Boolean.parseBoolean(flag);
System.out.println(enabled);
System.out.println(Boolean.toString(false));
```

`parseBoolean` returns `true` only for the text `"true"`, ignoring case. Everything else becomes `false`; it does not throw.

```java predict id=booleans-predict title="What is printed?"
System.out.println(true && false || true);
--- options
* true
false
compile error
null
--- explain
`&&` is evaluated before `||`, so the expression is `(true && false) || true`, which is `false || true`, or `true`.
```

## Challenges

```java exercise id=is-teenager title="Check for the teenage years"
int age = 15;
boolean isTeenager = false;

// True when age is from 13 through 19, inclusive.
--- solution
int age = 15;
boolean isTeenager = age >= 13 && age <= 19;
--- test
__check(isTeenager, "15 is a teenager");
--- hint
Two comparisons joined with `&&`: at least 13 and at most 19.
--- hint
`age >= 13 && age <= 19`
```

```java exercise id=can-vote title="Check voting eligibility"
int age = 20;
boolean citizen = true;
boolean canVote = false;

// A person can vote when they are 18 or older and a citizen.
--- solution
int age = 20;
boolean citizen = true;
boolean canVote = age >= 18 && citizen;
--- test
__check(canVote, "A 20-year-old citizen can vote");
--- hint
Both conditions must be true, so use `&&`.
--- hint
`age >= 18 && citizen`
```

```java debug id=fix-ride-condition title="The ride check lets the wrong person on"
int height = 130;
int age = 6;
boolean canRide = height >= 120 || age >= 8;
System.out.println(canRide);
--- solution
int height = 130;
int age = 6;
boolean canRide = height >= 120 && age >= 8;
System.out.println(canRide);
--- test
__check(__out().trim().equals("false"), "A six-year-old is too young even when tall enough");
--- hint
The ride requires **both** a tall enough rider and an old enough rider.
--- hint
Change `||` to `&&`.
```
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_2_5', 'sec_java_basics_2', 'crs_java_basics', 'Type conversion and reading input', 'interactive', 4, 960, NULL, NULL, 'Programs rarely receive values in exactly the type they need. A command-line argument arrives as text, a price may need rounding to cents, and a calculation may outgrow its variable. This lesson is about moving safely between types.

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
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_2_6', 'sec_java_basics_2', 'crs_java_basics', 'Checkpoint: numbers, text & truth', 'quiz', 5, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"What is `17 % 5`?","options":["`3`","`2`","`3.4`","`0`"],"answerIndex":1,"explanation":"`%` gives the remainder. 17 divided by 5 is 3 with 2 left over, so the result is `2`."},{"id":"q2","prompt":"What does `System.out.println(2 + 3 * 4)` display?","options":["`20`","`14`","`24`","`11`"],"answerIndex":1,"explanation":"Multiplication happens before addition, so the expression is `2 + 12`, which is `14`."},{"id":"q3","prompt":"Why does `System.out.println(10 / 4)` print `2` instead of `2.5`?","options":["Java rounds every division down to the nearest even number","Both operands are `int`, so integer division discards the fraction","`println` cannot print decimals","The `4` should be in quotes"],"answerIndex":1,"explanation":"When both operands are integers, `/` performs integer division. At least one operand must be a `double` for a decimal result."},{"id":"q4","prompt":"What does `(int) 3.99` produce?","options":["`4`","`3`","`3.99`","`3.0`"],"answerIndex":1,"explanation":"A cast to `int` truncates toward zero. It does not round. Use `Math.round` if you need `4`."},{"id":"q5","prompt":"What is `\"programming\".length()`?","options":["`10`","`11`","`12`","`9`"],"answerIndex":1,"explanation":"`programming` has 11 characters, so `length()` returns `11`."},{"id":"q6","prompt":"What does `\"Java\".substring(1, 3)` return?","options":["`\"Jav\"`","`\"av\"`","`\"ava\"`","`\"va\"`"],"answerIndex":1,"explanation":"The start index is included and the end index is excluded. Indexes 1 and 2 are `a` and `v`, so the result is `\"av\"`."},{"id":"q7","prompt":"Why should you use `equals` instead of `==` to compare two strings?","options":["`==` does not compile for strings","`==` compares references, while `equals` compares the characters","`equals` is faster in every case","There is no difference in Java"],"answerIndex":1,"explanation":"`==` asks whether both variables refer to the same object. Two different `String` objects can contain identical text, and only `equals` checks that text."},{"id":"q8","prompt":"What does `System.out.println(\"Sum: \" + (2 + 3))` display?","options":["`Sum: 23`","`Sum: 5`","`Sum: 2 + 3`","`5`"],"answerIndex":1,"explanation":"The parentheses force `2 + 3` to be calculated first. The resulting `5` is then joined to the string."},{"id":"q9","prompt":"What happens when `Integer.parseInt(\"hello\")` runs?","options":["It returns `0`","It returns `null`","It throws `NumberFormatException`","It prints a warning and returns `-1`"],"answerIndex":2,"explanation":"`parseInt` requires text that represents an integer. `hello` does not, so it throws `NumberFormatException`."},{"id":"q10","prompt":"Why might `long total = 2_000_000_000 * 2;` produce a negative number?","options":["The underscores are invalid in numeric literals","The multiplication happens as `int` before the result is stored in the `long`","`long` cannot hold values above one billion","Java randomly overflows large literals"],"answerIndex":1,"explanation":"Both operands are `int`, so the multiplication overflows in 32 bits. Write `2_000_000_000L * 2` to force 64-bit arithmetic."}]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_3_1', 'sec_java_basics_3', 'crs_java_basics', 'Making decisions with if, else if and else', 'interactive', 0, 1080, NULL, NULL, '`if` runs a block only when a condition is true. `else` runs when it is false. `else if` chains several possibilities, and only the first matching branch runs.

## A single decision

```java run
int temperature = 31;

if (temperature > 30) {
    System.out.println("It is hot.");
}

System.out.println("Done checking.");
```

The braces define the block controlled by the `if`. The final line always runs because it is outside the braces. Indentation is for humans; the braces are what the compiler follows.

## Two branches

```java run
int age = 16;

if (age >= 18) {
    System.out.println("Adult");
} else {
    System.out.println("Minor");
}
```

Exactly one of the two blocks runs. The condition must be a `boolean`; Java will not accept `if (age)` the way some languages do.

## Several branches

```java run
int score = 85;

if (score >= 90) {
    System.out.println("A");
} else if (score >= 80) {
    System.out.println("B");
} else if (score >= 70) {
    System.out.println("C");
} else {
    System.out.println("Needs work");
}
```

Order matters. Once a condition matches, the rest are skipped. If the first check were `score >= 70`, an 85 would get a `C` and the later branches would never be considered.

## The conditional operator

For a short either/or choice, the ternary operator is compact:

```java run
int stock = 0;
String status = stock > 0 ? "In stock" : "Sold out";
System.out.println(status);

int a = 12;
int b = 30;
int larger = a > b ? a : b;
System.out.println(larger);
```

`condition ? valueIfTrue : valueIfFalse` produces a value. Use it when both choices are simple; a full `if` is easier to read when the branches contain several statements.

```java predict id=if-else-predict title="What is printed?"
int score = 85;
if (score >= 90) {
    System.out.println("A");
} else if (score >= 80) {
    System.out.println("B");
} else {
    System.out.println("C");
}
--- options
* B
A
C
B
C
--- explain
The first condition is false. The second, `score >= 80`, is true, so `B` prints and the `else` is skipped.
```

## Challenges

```java exercise id=grade-letter title="Turn a score into a letter grade"
int score = 85;
String grade = "";

// 90+ is A, 80-89 is B, 70-79 is C, below 70 is F.
--- solution
int score = 85;
String grade;

if (score >= 90) {
    grade = "A";
} else if (score >= 80) {
    grade = "B";
} else if (score >= 70) {
    grade = "C";
} else {
    grade = "F";
}
--- test
__check(grade.equals("B"), "85 should be a B");
--- hint
Check the highest threshold first, then work downward.
--- hint
Assign `grade` in each branch and leave the declaration without an initial value if you prefer.
```

```java exercise id=even-odd title="Print even or odd"
int number = 7;

// Print "even" when the number is divisible by 2, otherwise "odd".
--- solution
int number = 7;
if (number % 2 == 0) {
    System.out.println("even");
} else {
    System.out.println("odd");
}
--- test
__check(__out().trim().equals("odd"), "7 is odd");
--- hint
A number is even when `number % 2 == 0`.
--- hint
Print `"even"` in the `if` branch and `"odd"` in the `else` branch.
```

```java debug id=fix-grade-order title="The top score gets the wrong grade"
int score = 95;
String grade;

if (score >= 60) {
    grade = "D";
} else if (score >= 80) {
    grade = "B";
} else if (score >= 90) {
    grade = "A";
} else {
    grade = "F";
}

System.out.println(grade);
--- solution
int score = 95;
String grade;

if (score >= 90) {
    grade = "A";
} else if (score >= 80) {
    grade = "B";
} else if (score >= 60) {
    grade = "D";
} else {
    grade = "F";
}

System.out.println(grade);
--- test
__check(__out().trim().equals("A"), "A score of 95 is an A");
--- hint
An `else if` chain stops at the first true condition. A 95 matches `score >= 60` first.
--- hint
Put the strictest, highest threshold first.
```
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_3_2', 'sec_java_basics_3', 'crs_java_basics', 'switch, case and enums', 'interactive', 1, 960, NULL, NULL, 'A `switch` chooses one branch from a list of exact values. It is clearer than a long `if/else if` chain when you are matching a small set of constants such as a day number, a menu item or a command name.

## Switching on an integer

```java run
int day = 3;

switch (day) {
    case 1:
        System.out.println("Monday");
        break;
    case 2:
        System.out.println("Tuesday");
        break;
    case 3:
        System.out.println("Wednesday");
        break;
    default:
        System.out.println("Another day");
}
```

`break` exits the switch. Without it, execution **falls through** into the next case. `default` runs when no case matches; it is optional but usually a good idea.

## Switching on a string

Java 7 and later allow strings in a switch. The comparison is case-sensitive:

```java run
String command = "start";

switch (command) {
    case "start":
        System.out.println("Starting...");
        break;
    case "stop":
        System.out.println("Stopping...");
        break;
    default:
        System.out.println("Unknown command");
}
```

`"Start"` with a capital S would not match `"start"`. Normalise with `toLowerCase()` first if the input may vary.

## Intentional fall-through

Fall-through is sometimes useful when several cases share the same action:

```java run
int month = 4;

switch (month) {
    case 12:
    case 1:
    case 2:
        System.out.println("Winter");
        break;
    case 3:
    case 4:
    case 5:
        System.out.println("Spring");
        break;
    default:
        System.out.println("Another season");
}
```

The empty cases fall through to the next non-empty one. This is the one place where omitting `break` is deliberate; add a comment when you do it so the next reader knows it is not a bug.

```java run
char grade = ''B'';

switch (grade) {
    case ''A'':
        System.out.println("Excellent");
        break;
    case ''B'':
    case ''C'':
        System.out.println("Good");
        break;
    default:
        System.out.println("Keep practising");
}
```

`char` works too, because a character is an integer-like value under the hood.

```java predict id=switch-predict title="What is printed?"
int n = 1;
switch (n) {
    case 1:
        System.out.print("one");
    case 2:
        System.out.print("two");
        break;
    default:
        System.out.print("other");
}
System.out.println();
--- options
* onetwo
one
two
one two
--- explain
Case 1 has no `break`, so execution falls through and also runs case 2. Both `print` calls happen before the switch exits, producing `onetwo`.
```

## Challenges

```java exercise id=day-type title="Classify a day with switch"
int day = 6;
String type = "";

// 1-5 are weekdays; 6 and 7 are weekend days.
--- solution
int day = 6;
String type;

switch (day) {
    case 1:
    case 2:
    case 3:
    case 4:
    case 5:
        type = "weekday";
        break;
    case 6:
    case 7:
        type = "weekend";
        break;
    default:
        type = "unknown";
}
--- test
__check(type.equals("weekend"), "Day 6 is a weekend day");
--- hint
Group the weekday cases together and assign once.
--- hint
Cases 6 and 7 can share one branch.
```

```java exercise id=menu-price title="Look up a menu price"
String item = "coffee";
double price = 0;

// coffee = 3.5, tea = 2.5, juice = 4.0, anything else = 0.
--- solution
String item = "coffee";
double price;

switch (item) {
    case "coffee":
        price = 3.5;
        break;
    case "tea":
        price = 2.5;
        break;
    case "juice":
        price = 4.0;
        break;
    default:
        price = 0;
}
--- test
__check(Math.abs(price - 3.5) < 0.0001, "Coffee costs 3.5");
--- hint
Switch on the `String` and assign `price` in each branch.
--- hint
Do not forget the `break` after each case.
```

```java debug id=fix-missing-break title="One case prints two answers"
int choice = 1;
switch (choice) {
    case 1:
        System.out.println("one");
    case 2:
        System.out.println("two");
        break;
    default:
        System.out.println("other");
}
--- solution
int choice = 1;
switch (choice) {
    case 1:
        System.out.println("one");
        break;
    case 2:
        System.out.println("two");
        break;
    default:
        System.out.println("other");
}
--- test
__check(__out().trim().equals("one"), "Choice 1 should print only one");
--- hint
Execution is falling through from case 1 into case 2.
--- hint
Add a `break` after the first `println`.
```
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_3_3', 'sec_java_basics_3', 'crs_java_basics', 'while loops: repeat until done', 'interactive', 2, 960, NULL, NULL, 'A `while` loop repeats a block as long as its condition is true. The condition is checked **before** each pass, so a loop can run zero times. Something inside the loop must eventually make the condition false, or the program never stops.

## Counting with while

```java run
int i = 1;
while (i <= 5) {
    System.out.println(i);
    i++;
}
System.out.println("Finished");
```

`i++` adds one to `i`. Without it, `i` stays `1`, the condition stays true, and the loop runs forever. That is an **infinite loop**, and it is the most common while-loop bug.

## Accumulating a result

```java run
int n = 1;
int sum = 0;

while (n <= 10) {
    sum += n;
    n++;
}

System.out.println("Sum: " + sum);
```

The loop variable `n` controls how many passes happen; `sum` carries the result forward. Keeping those roles separate makes loops much easier to reason about.

## do-while

A `do-while` checks its condition **after** the body, so the body always runs at least once:

```java run
int attempts = 0;

do {
    attempts++;
    System.out.println("Attempt " + attempts);
} while (attempts < 3);
```

This is useful for menus and retry prompts, where you need to show something before you can decide whether to repeat.

## break and continue

`break` leaves the loop immediately. `continue` skips the rest of the current pass and jumps back to the condition:

```java run
int i = 0;
while (i < 10) {
    i++;
    if (i == 3) {
        continue;
    }
    if (i == 6) {
        break;
    }
    System.out.println(i);
}
```

This prints `1`, `2`, `4`, `5`. It skips `3` and stops before printing `6`. Use both sparingly; a clear condition is usually easier to read.

```java predict id=while-predict title="What is printed?"
int i = 0;
while (i < 3) {
    System.out.print(i);
    i++;
}
System.out.println();
--- options
* 012
123
0123
0
1
2
--- explain
The loop runs for `i` equal to 0, 1 and 2. At `i == 3` the condition is false. `print` keeps the digits on one line, giving `012`.
```

## Challenges

```java exercise id=countdown title="Count down with a while loop"
int n = 5;

// Print 5, 4, 3, 2, 1 — each on its own line.
--- solution
int n = 5;
while (n >= 1) {
    System.out.println(n);
    n--;
}
--- test
__check(__out().trim().equals("5\n4\n3\n2\n1"), "Count down from 5 to 1");
--- hint
Start at 5 and subtract one each pass.
--- hint
The condition can be `n >= 1`.
```

```java exercise id=sum-to-ten title="Sum the numbers from 1 to 10"
int i = 1;
int sum = 0;

// Add every number from 1 through 10.
--- solution
int i = 1;
int sum = 0;
while (i <= 10) {
    sum += i;
    i++;
}
--- test
__check(sum == 55, "1 + 2 + ... + 10 is 55");
--- hint
Add `i` to `sum` inside the loop, then increment `i`.
--- hint
`sum += i; i++;`
```

```java debug id=fix-loop-bound title="The loop prints one number too many"
int i = 0;
while (i <= 3) {
    System.out.println(i);
    i++;
}
--- solution
int i = 0;
while (i < 3) {
    System.out.println(i);
    i++;
}
--- test
__check(__out().trim().equals("0\n1\n2"), "The loop should print 0, 1 and 2 only");
--- hint
With `i <= 3`, the body runs when `i` is 3 as well.
--- hint
Change the condition to `i < 3`.
```
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_3_4', 'sec_java_basics_3', 'crs_java_basics', 'for loops and loop patterns', 'interactive', 3, 1080, NULL, NULL, 'A `for` loop puts the counter''s setup, condition and update on one line. It is the right tool when you know how many passes you need, or when you are walking through a sequence.

## The three parts

```java run
for (int i = 1; i <= 5; i++) {
    System.out.println(i);
}
```

The three parts are separated by semicolons:

1. **Initialisation** — `int i = 1` runs once.
2. **Condition** — `i <= 5` is checked before every pass.
3. **Update** — `i++` runs after every pass.

The variable `i` exists only inside the loop. That keeps temporary counters from leaking into the rest of the method.

## Accumulating

```java run
int sum = 0;

for (int i = 1; i <= 10; i++) {
    sum += i;
}

System.out.println("Sum: " + sum);
```

The counter moves forward; the accumulator stays alive after the loop. This pattern — one variable to count, another to collect — covers a huge number of problems.

## Nested loops

A loop inside a loop is useful for grids. The outer loop controls rows and the inner loop controls columns:

```java run
for (int row = 1; row <= 3; row++) {
    for (int col = 1; col <= 3; col++) {
        System.out.print(row * col + " ");
    }
    System.out.println();
}
```

The inner loop completes all three columns for each row. Indentation is your friend here: it is easy to lose track of which loop a statement belongs to.

## Counting down and stepping

All three parts are flexible:

```java run
for (int i = 10; i >= 0; i -= 2) {
    System.out.print(i + " ");
}
System.out.println();

for (int i = 0; i < 5; i++) {
    if (i == 2) {
        continue;
    }
    System.out.print(i + " ");
}
System.out.println();
```

The first loop counts down by two. The second skips `2` with `continue`, printing `0 1 3 4`. Changing the update is often cleaner than adding an `if` inside the body.

```java predict id=for-predict title="What is printed?"
int sum = 0;
for (int i = 0; i < 5; i++) {
    if (i % 2 == 0) {
        sum += i;
    }
}
System.out.println(sum);
--- options
* 6
4
10
0
--- explain
The even values below 5 are 0, 2 and 4. Their sum is `0 + 2 + 4 = 6`.
```

## Challenges

```java exercise id=print-evens title="Print the even numbers from 2 to 10"
// Use a for loop to print 2, 4, 6, 8, 10 — one per line.
--- solution
for (int i = 2; i <= 10; i += 2) {
    System.out.println(i);
}
--- test
__check(__out().trim().equals("2\n4\n6\n8\n10"), "Print the five even numbers from 2 through 10");
--- hint
Start at 2, stop at 10, and increase by 2 each pass.
--- hint
`for (int i = 2; i <= 10; i += 2)`
```

```java exercise id=times-table title="Print a times table"
int n = 3;

// Print three lines, from "3 x 1 = 3" through "3 x 3 = 9".
--- solution
int n = 3;
for (int i = 1; i <= 3; i++) {
    System.out.println(n + " x " + i + " = " + (n * i));
}
--- test
__check(__out().trim().equals("3 x 1 = 3\n3 x 2 = 6\n3 x 3 = 9"), "Print the three multiplication facts in order");
--- hint
Use a loop from 1 to 3 and build each line with string concatenation.
--- hint
Put `(n * i)` in parentheses so the multiplication happens before the string join.
```

```java debug id=fix-for-bound title="The last number is missing"
for (int i = 1; i < 5; i++) {
    System.out.println(i);
}
--- solution
for (int i = 1; i <= 5; i++) {
    System.out.println(i);
}
--- test
__check(__out().trim().equals("1\n2\n3\n4\n5"), "The loop should include 5");
--- hint
The condition is checked before each pass. When `i` is 5, `i < 5` is false.
--- hint
Change `<` to `<=`.
```
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_3_5', 'sec_java_basics_3', 'crs_java_basics', 'Checkpoint: decisions & loops', 'quiz', 4, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"In an `if / else if / else` chain, how many branches can run?","options":["All branches whose conditions are true","Exactly one branch at most","At least two branches","Only the `else` branch"],"answerIndex":1,"explanation":"The chain checks conditions in order and stops at the first true one. At most one branch runs; `else` runs only when none matched."},{"id":"q2","prompt":"What is the value of `status` after `int stock = 0; String status = stock > 0 ? \"In stock\" : \"Sold out\";`?","options":["`\"In stock\"`","`\"Sold out\"`","`0`","A compile error"],"answerIndex":1,"explanation":"The condition is false, so the ternary chooses the value after the colon: `\"Sold out\"`."},{"id":"q3","prompt":"A `switch` case has no `break`. What happens?","options":["The switch exits immediately","Execution falls through into the next case","The program throws an exception","The case is skipped"],"answerIndex":1,"explanation":"Without `break`, execution continues into the following case, even if its value does not match. This is called fall-through."},{"id":"q4","prompt":"When does the `default` branch of a `switch` run?","options":["Always, after every matching case","Only when no case matches","Only when the switch value is `null`","Only if there is no `break`"],"answerIndex":1,"explanation":"`default` is the fallback. It runs when none of the case labels match the switch value."},{"id":"q5","prompt":"How many times does this loop run? `int i = 5; while (i < 3) { i++; }`","options":["Zero times","Once","Twice","Forever"],"answerIndex":0,"explanation":"The condition is checked before the first pass. Since `5 < 3` is false, the body never runs."},{"id":"q6","prompt":"What is guaranteed about a `do-while` loop?","options":["It runs exactly once at most","Its body runs at least once","It never runs more than ten times","Its condition is checked before the body"],"answerIndex":1,"explanation":"A `do-while` checks its condition after the body, so the body always executes at least once."},{"id":"q7","prompt":"What does `for (int i = 1; i < 5; i++)` count through?","options":["`1, 2, 3, 4, 5`","`1, 2, 3, 4`","`0, 1, 2, 3, 4`","`2, 3, 4, 5`"],"answerIndex":1,"explanation":"The loop starts at 1 and continues while `i < 5`. When `i` becomes 5, the condition is false, so 5 is not included."},{"id":"q8","prompt":"What is the difference between `break` and `continue` inside a loop?","options":["`break` skips the current pass; `continue` exits the loop","`break` exits the loop; `continue` skips to the next pass","They are identical","`continue` only works in `while` loops"],"answerIndex":1,"explanation":"`break` leaves the loop entirely. `continue` finishes the current pass early and goes back to the loop condition."},{"id":"q9","prompt":"How many times does the inner statement run? `for (int r = 0; r < 3; r++) { for (int c = 0; c < 2; c++) { System.out.println(r + \" \" + c); } }`","options":["`5`","`6`","`3`","`2`"],"answerIndex":1,"explanation":"The outer loop runs 3 times and the inner loop runs 2 times for each outer pass, so the statement runs `3 * 2 = 6` times."},{"id":"q10","prompt":"Which mistake most often causes an infinite `while` loop?","options":["Using `<=` instead of `<`","Forgetting to update the loop variable inside the body","Declaring the loop variable outside the loop","Printing inside the loop"],"answerIndex":1,"explanation":"If nothing changes the value in the condition, the condition stays true forever. Every loop needs a path that eventually makes it false."}]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_4_1', 'sec_java_basics_4', 'crs_java_basics', 'Arrays: many values, one name', 'interactive', 0, 1080, NULL, NULL, 'An **array** holds a fixed number of values of the same type. The length is chosen when the array is created and never changes. Arrays are the foundation for lists, tables, and most of the data structures you will meet later.

## Creating an array

```java run
int[] scores = {90, 85, 77, 96};

System.out.println(scores.length);
System.out.println(scores[0]);
System.out.println(scores[3]);
System.out.println(Arrays.toString(scores));
```

The square brackets after the type mean "array of `int`". `length` is a field, not a method, so there are no parentheses. Indexes start at 0, so the last valid index is `length - 1`.

`Arrays.toString` turns the whole array into readable text. Printing the array directly would show a memory-style reference such as `[I@1b6d3586`, which is rarely useful.

## Default values

```java run
int[] counts = new int[4];
boolean[] flags = new boolean[3];
String[] names = new String[2];

System.out.println(Arrays.toString(counts));
System.out.println(Arrays.toString(flags));
System.out.println(Arrays.toString(names));
```

A new numeric array is filled with `0`, a boolean array with `false`, and an object array with `null`. You can assign values later:

```java run
int[] counts = new int[4];
counts[0] = 7;
counts[2] = 4;
System.out.println(Arrays.toString(counts));
```

## Walking an array

```java run
int[] values = {4, 8, 15, 16, 23, 42};
int sum = 0;

for (int i = 0; i < values.length; i++) {
    sum += values[i];
}
System.out.println("Sum: " + sum);

for (int value : values) {
    System.out.print(value + " ");
}
System.out.println();
```

The classic `for` loop gives you the index, which you need when the position matters. The enhanced `for` loop gives you each value directly, which is shorter and less error-prone. Use `i < values.length`, never `i <= values.length`; the latter reads one past the end and throws `ArrayIndexOutOfBoundsException`.

## Two-dimensional arrays

```java run
int[][] grid = {
    {1, 2, 3},
    {4, 5, 6}
};

System.out.println(grid.length);
System.out.println(grid[0].length);
System.out.println(grid[1][2]);
```

`grid.length` is the number of rows. `grid[0].length` is the number of columns in the first row. Java arrays can even be ragged, with rows of different lengths.

```java predict id=arrays-predict title="What is printed?"
int[] nums = {3, 6, 9};
System.out.println(nums[1] + nums.length);
--- options
* 9
6
3
12
--- explain
`nums[1]` is `6` and `nums.length` is `3`. Their sum is `9`.
```

## Challenges

```java exercise id=sum-array title="Sum an array"
int[] values = {4, 8, 15, 16, 23, 42};
int sum = 0;

// Add every element to sum.
--- solution
int[] values = {4, 8, 15, 16, 23, 42};
int sum = 0;

for (int i = 0; i < values.length; i++) {
    sum += values[i];
}
--- test
__check(sum == 108, "The values add up to 108");
--- hint
Loop from `0` while `i < values.length`.
--- hint
Add `values[i]` to `sum` inside the loop.
```

```java exercise id=max-array title="Find the largest value"
int[] values = {4, 8, 15, 16, 23, 42};
int max = values[0];

// Compare every element with max and keep the larger one.
--- solution
int[] values = {4, 8, 15, 16, 23, 42};
int max = values[0];

for (int i = 1; i < values.length; i++) {
    if (values[i] > max) {
        max = values[i];
    }
}
--- test
__check(max == 42, "42 is the largest value");
--- hint
Start with the first element, then compare the rest.
--- hint
If `values[i] > max`, assign `values[i]` to `max`.
```

```java debug id=fix-array-bound title="The loop runs past the end"
int[] scores = {10, 20, 30};
int sum = 0;

for (int i = 0; i <= scores.length; i++) {
    sum += scores[i];
}
--- solution
int[] scores = {10, 20, 30};
int sum = 0;

for (int i = 0; i < scores.length; i++) {
    sum += scores[i];
}
--- test
__check(sum == 60, "The three scores add up to 60");
--- hint
The valid indexes are `0`, `1` and `2`. `length` is `3`.
--- hint
Use `<` instead of `<=` in the loop condition.
```
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_4_2', 'sec_java_basics_4', 'crs_java_basics', 'Array algorithms: sums, searches and extremes', 'interactive', 1, 1080, NULL, NULL, 'Most array work falls into a few patterns: find something, count something, rearrange something, or copy and sort. Once you recognise the pattern, the loop almost writes itself.

## Searching

A **linear search** checks each element in turn and stops when it finds a match:

```java run
int[] values = {4, 8, 15, 16, 23, 42};
int target = 15;
int foundAt = -1;

for (int i = 0; i < values.length; i++) {
    if (values[i] == target) {
        foundAt = i;
        break;
    }
}

System.out.println(foundAt);
```

Starting at `-1` is a common convention for "not found", because every real index is zero or greater. The `break` stops the search as soon as the answer is known.

## Counting

```java run
int[] votes = {1, 0, 1, 1, 0, 1, 0};
int yes = 0;

for (int vote : votes) {
    if (vote == 1) {
        yes++;
    }
}

System.out.println("Yes: " + yes);
System.out.println("No: " + (votes.length - yes));
```

A counter plus a condition is all a "how many" question needs.

## Reversing in place

To reverse an array without creating another one, swap the ends and move inward:

```java run
int[] nums = {1, 2, 3, 4, 5};

for (int left = 0, right = nums.length - 1; left < right; left++, right--) {
    int temp = nums[left];
    nums[left] = nums[right];
    nums[right] = temp;
}

System.out.println(Arrays.toString(nums));
```

The loop stops when the pointers meet in the middle. Swapping every pair twice would undo the work, so the condition is `left < right`, not `left < nums.length`.

## Copying and sorting

```java run
int[] original = {9, 2, 7, 1};
int[] copy = Arrays.copyOf(original, original.length);

Arrays.sort(copy);

System.out.println(Arrays.toString(original));
System.out.println(Arrays.toString(copy));
System.out.println(Arrays.equals(original, copy));
```

`Arrays.copyOf` creates a new array. Sorting the copy leaves the original untouched. `Arrays.equals` compares contents element by element; `==` would only compare the two array references.

```java predict id=array-algorithms-predict title="What is printed?"
int[] a = {1, 2, 3};
int[] b = Arrays.copyOf(a, 3);
b[0] = 9;
System.out.println(a[0] + " " + b[0]);
--- options
* 1 9
9 9
1 1
9 1
--- explain
`Arrays.copyOf` creates a separate array, so changing `b[0]` does not affect `a[0]`.
```

## Challenges

```java exercise id=contains-value title="Search for a value"
int[] values = {4, 8, 15, 16, 23, 42};
int target = 23;
boolean found = false;

// Set found to true when target appears in the array.
--- solution
int[] values = {4, 8, 15, 16, 23, 42};
int target = 23;
boolean found = false;

for (int value : values) {
    if (value == target) {
        found = true;
        break;
    }
}
--- test
__check(found, "23 is in the array");
--- hint
Loop over the values and compare each one with `target`.
--- hint
Set `found = true` and `break` when you find a match.
```

```java exercise id=reverse-array title="Reverse an array in place"
int[] nums = {1, 2, 3, 4};

// Reverse the elements without creating a new array.
--- solution
int[] nums = {1, 2, 3, 4};

for (int left = 0, right = nums.length - 1; left < right; left++, right--) {
    int temp = nums[left];
    nums[left] = nums[right];
    nums[right] = temp;
}
--- test
__check(Arrays.equals(nums, new int[]{4, 3, 2, 1}), "The array should become 4, 3, 2, 1");
--- hint
Use two indexes, one at each end, and swap inward.
--- hint
Stop when `left >= right`.
```

```java debug id=fix-smallest-after-sort title="The smallest value is wrong"
int[] values = {9, 2, 7};
int smallest = values[0];
Arrays.sort(values);
System.out.println(smallest);
--- solution
int[] values = {9, 2, 7};
Arrays.sort(values);
int smallest = values[0];
System.out.println(smallest);
--- test
__check(__out().trim().equals("2"), "After sorting, the smallest value is 2");
--- hint
`smallest` is read before the array is sorted.
--- hint
Move the assignment below `Arrays.sort(values);`.
```
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_4_3', 'sec_java_basics_4', 'crs_java_basics', 'ArrayList: a growable array', 'interactive', 2, 1080, NULL, NULL, 'An array has a fixed length. An `ArrayList` grows and shrinks as you add and remove items, which makes it the default choice for a collection whose size you do not know in advance.

## Creating and adding

```java run
ArrayList<String> names = new ArrayList<>();

names.add("Ada");
names.add("Grace");
names.add("Alan");

System.out.println(names.size());
System.out.println(names.get(0));
System.out.println(names);
```

`ArrayList<String>` means "a list of strings". The angle brackets hold the **type parameter**. `add` appends to the end, `size()` returns the count, and `get(index)` reads an element. Printing the list directly gives a readable `[Ada, Grace, Alan]`.

## Changing and removing

```java run
ArrayList<String> names = new ArrayList<>();
names.add("Ada");
names.add("Grace");
names.add("Alan");

names.set(1, "Hopper");
names.remove("Ada");

System.out.println(names);
System.out.println(names.contains("Hopper"));
System.out.println(names.indexOf("Alan"));
```

`set(index, value)` replaces an element. `remove(value)` removes the first matching value, while `remove(index)` removes by position. After a removal, later elements shift left, so indexes change.

## Walking a list

```java run
ArrayList<Integer> scores = new ArrayList<>();
scores.add(90);
scores.add(85);
scores.add(77);

for (int i = 0; i < scores.size(); i++) {
    System.out.println(i + ": " + scores.get(i));
}

int total = 0;
for (int score : scores) {
    total += score;
}
System.out.println("Total: " + total);
```

Use `size()` rather than a stored length. The enhanced `for` loop is ideal when you only need the values. `ArrayList<Integer>` uses the wrapper class `Integer`, not `int`; Java converts automatically when adding and reading.

## Building from existing values

```java run
ArrayList<String> colors = new ArrayList<>(Arrays.asList("red", "green", "blue"));
System.out.println(colors);
System.out.println(colors.isEmpty());

colors.clear();
System.out.println(colors.isEmpty());
```

`Arrays.asList` creates a fixed-size list view that is useful as a starting point. Copying it into a new `ArrayList` gives you a fully mutable list. `clear()` removes everything.

```java predict id=arraylist-predict title="What is printed?"
ArrayList<String> list = new ArrayList<>();
list.add("a");
list.add("b");
list.add("c");
list.remove(1);
System.out.println(list.get(1));
--- options
* c
b
a
IndexOutOfBoundsException
--- explain
Removing index 1 removes `"b"`. The list becomes `[a, c]`, so index 1 is now `"c"`.
```

## Challenges

```java exercise id=add-names title="Build a list of names"
ArrayList<String> names = new ArrayList<>();

// Add Ada, Grace and Alan in that order.
--- solution
ArrayList<String> names = new ArrayList<>();
names.add("Ada");
names.add("Grace");
names.add("Alan");
--- test
__check(names.size() == 3 && names.get(0).equals("Ada") && names.get(1).equals("Grace") && names.get(2).equals("Alan"), "Add the three names in order");
--- hint
Call `add` once per name.
--- hint
`names.add("Ada");` and so on.
```

```java exercise id=sum-integer-list title="Sum a list of integers"
ArrayList<Integer> numbers = new ArrayList<>(Arrays.asList(3, 6, 9));
int sum = 0;

// Add every number in the list.
--- solution
ArrayList<Integer> numbers = new ArrayList<>(Arrays.asList(3, 6, 9));
int sum = 0;

for (int number : numbers) {
    sum += number;
}
--- test
__check(sum == 18, "3 + 6 + 9 is 18");
--- hint
Use an enhanced `for` loop over `numbers`.
--- hint
`for (int number : numbers) { sum += number; }`
```

```java debug id=fix-list-bound title="The list loop crashes"
ArrayList<Integer> numbers = new ArrayList<>(Arrays.asList(10, 20, 30));
int sum = 0;

for (int i = 0; i <= numbers.size(); i++) {
    sum += numbers.get(i);
}
--- solution
ArrayList<Integer> numbers = new ArrayList<>(Arrays.asList(10, 20, 30));
int sum = 0;

for (int i = 0; i < numbers.size(); i++) {
    sum += numbers.get(i);
}
--- test
__check(sum == 60, "The three numbers add up to 60");
--- hint
Valid indexes are `0` through `size() - 1`.
--- hint
Change `<=` to `<`.
```
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_4_4', 'sec_java_basics_4', 'crs_java_basics', 'HashMap: look things up by key', 'interactive', 3, 1200, NULL, NULL, 'A `HashMap` stores **keys** and **values**. You give it a key and it gives back the associated value, usually in constant time. It is the natural structure for lookups: a name to a phone number, a word to its count, a product code to a price.

## Putting and getting

```java run
HashMap<String, Integer> ages = new HashMap<>();

ages.put("Ada", 36);
ages.put("Grace", 45);

System.out.println(ages.get("Ada"));
System.out.println(ages.size());
System.out.println(ages);
```

`HashMap<String, Integer>` maps strings to integers. `put` adds a pair or replaces the value for an existing key. `get` returns the value, or `null` if the key is absent.

## Missing keys

```java run
HashMap<String, Integer> stock = new HashMap<>();
stock.put("apple", 3);

System.out.println(stock.get("pear"));
System.out.println(stock.getOrDefault("pear", 0));
System.out.println(stock.containsKey("apple"));
```

`get` on a missing key returns `null`, which can cause a `NullPointerException` if you immediately do arithmetic with it. `getOrDefault` supplies a fallback and is usually the safer choice.

## Updating counts

```java run
String[] words = {"java", "code", "java", "test", "java"};
HashMap<String, Integer> counts = new HashMap<>();

for (String word : words) {
    counts.put(word, counts.getOrDefault(word, 0) + 1);
}

System.out.println(counts.get("java"));
System.out.println(counts.get("code"));
```

The `getOrDefault(word, 0) + 1` pattern reads the old count (or zero), adds one, and stores it back. This is the standard frequency-counting idiom.

## Removing and iterating

```java run
HashMap<String, Integer> scores = new HashMap<>();
scores.put("Ada", 95);
scores.put("Grace", 88);
scores.put("Alan", 91);

scores.remove("Grace");
System.out.println(scores.containsKey("Grace"));

for (String name : scores.keySet()) {
    System.out.println(name + " -> " + scores.get(name));
}

for (HashMap.Entry<String, Integer> entry : scores.entrySet()) {
    System.out.println(entry.getKey() + ": " + entry.getValue());
}
```

`keySet()` gives the keys, `values()` gives the values, and `entrySet()` gives key-value pairs. A `HashMap` does **not** promise iteration order; if you need sorted keys, use a `TreeMap`.

```java predict id=hashmap-predict title="What is printed?"
HashMap<String, Integer> map = new HashMap<>();
map.put("a", 1);
System.out.println(map.get("b"));
--- options
* null
0
1
b
--- explain
There is no entry for `"b"`, so `get` returns `null`. Use `getOrDefault("b", 0)` if you want a number.
```

## Challenges

```java exercise id=word-frequency title="Count occurrences of a word"
String[] words = {"java", "code", "java", "test", "java"};
HashMap<String, Integer> counts = new HashMap<>();

// Count how many times each word appears.
--- solution
String[] words = {"java", "code", "java", "test", "java"};
HashMap<String, Integer> counts = new HashMap<>();

for (String word : words) {
    counts.put(word, counts.getOrDefault(word, 0) + 1);
}
--- test
__check(counts.get("java") == 3 && counts.get("code") == 1, "java appears three times and code once");
--- hint
Loop over the words and update the count for each one.
--- hint
`counts.put(word, counts.getOrDefault(word, 0) + 1);`
```

```java exercise id=price-lookup title="Store and look up a price"
HashMap<String, Double> prices = new HashMap<>();

// Add apple -> 1.5 and bread -> 3.0, then read the apple price.
double applePrice = 0;
--- solution
HashMap<String, Double> prices = new HashMap<>();
prices.put("apple", 1.5);
prices.put("bread", 3.0);
double applePrice = prices.get("apple");
--- test
__check(Math.abs(applePrice - 1.5) < 0.0001, "An apple costs 1.5");
--- hint
Use `put` for each pair, then `get("apple")`.
--- hint
`double applePrice = prices.get("apple");`
```

```java debug id=fix-missing-key title="The missing key crashes the count"
String word = "pear";
HashMap<String, Integer> counts = new HashMap<>();
counts.put("apple", 2);

counts.put(word, counts.get(word) + 1);
System.out.println(counts.get(word));
--- solution
String word = "pear";
HashMap<String, Integer> counts = new HashMap<>();
counts.put("apple", 2);

counts.put(word, counts.getOrDefault(word, 0) + 1);
System.out.println(counts.get(word));
--- test
__check(__out().trim().equals("1"), "The first pear should count as 1");
--- hint
`counts.get("pear")` is `null`, and `null + 1` throws.
--- hint
Replace `get(word)` with `getOrDefault(word, 0)`.
```
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_java_basics_4_5', 'sec_java_basics_4', 'crs_java_basics', 'HashSet: uniqueness and membership', 'interactive', 4, 840, NULL, NULL, 'A `Set` is a collection with **no duplicates**. Adding a value that is already present does nothing. Sets answer "have I seen this?" and "how many distinct values are there?" without any extra bookkeeping.

## HashSet basics

```java run
HashSet<String> tags = new HashSet<>();

tags.add("java");
tags.add("code");
tags.add("java");

System.out.println(tags.size());
System.out.println(tags.contains("code"));
System.out.println(tags.contains("python"));
System.out.println(tags);
```

The second `"java"` is ignored, so the size is `2`. `contains` returns a boolean. Like `HashMap`, `HashSet` does not promise iteration order.

## add returns a boolean

`add` returns `true` when the value was new and `false` when it was already there. That return value is useful for detecting duplicates:

```java run
HashSet<Integer> seen = new HashSet<>();
int[] numbers = {3, 7, 3, 9};

for (int n : numbers) {
    boolean wasNew = seen.add(n);
    System.out.println(n + " new? " + wasNew);
}
```

This is cleaner than calling `contains` and then `add`, because it does both in one step.

## Removing and clearing

```java run
HashSet<String> selected = new HashSet<>();
selected.add("red");
selected.add("green");
selected.add("blue");

selected.remove("green");
System.out.println(selected);
System.out.println(selected.isEmpty());

selected.clear();
System.out.println(selected.size());
```

## Iterating and sorting

```java run
HashSet<String> names = new HashSet<>();
names.add("Ada");
names.add("Grace");
names.add("Alan");

for (String name : names) {
    System.out.println(name);
}

TreeSet<String> sorted = new TreeSet<>(names);
System.out.println(sorted);
```

A `TreeSet` keeps its values in sorted order. Converting a `HashSet` into a `TreeSet` is a quick way to get a deterministic order for display or comparison.

```java predict id=sets-predict title="What is printed?"
HashSet<String> set = new HashSet<>();
set.add("a");
set.add("a");
set.add("b");
System.out.println(set.size());
--- options
* 2
1
3
0
--- explain
The second `"a"` is a duplicate and is ignored. The set contains `"a"` and `"b"`, so its size is `2`.
```

## Challenges

```java exercise id=count-unique title="Count distinct words"
String[] words = {"java", "code", "java", "test", "code"};
HashSet<String> unique = new HashSet<>();

// Add every word to the set, then read its size.
int count = 0;
--- solution
String[] words = {"java", "code", "java", "test", "code"};
HashSet<String> unique = new HashSet<>();

for (String word : words) {
    unique.add(word);
}
int count = unique.size();
--- test
__check(count == 3, "There are three distinct words");
--- hint
A `HashSet` ignores duplicates automatically.
--- hint
Loop through `words`, then set `count = unique.size()`.
```

```java exercise id=has-duplicate title="Detect whether an array has duplicates"
int[] numbers = {4, 8, 15, 8};
boolean hasDuplicate = false;
HashSet<Integer> seen = new HashSet<>();

// Set hasDuplicate to true if any value appears more than once.
--- solution
int[] numbers = {4, 8, 15, 8};
boolean hasDuplicate = false;
HashSet<Integer> seen = new HashSet<>();

for (int n : numbers) {
    if (!seen.add(n)) {
        hasDuplicate = true;
        break;
    }
}
--- test
__check(hasDuplicate, "8 appears twice");
--- hint
`seen.add(n)` returns false when `n` was already present.
--- hint
Set `hasDuplicate = true` when `!seen.add(n)`.
```

```java debug id=fix-duplicate-flag title="The duplicate check is backwards"
int[] numbers = {1, 2, 3};
boolean hasDuplicate = false;
HashSet<Integer> seen = new HashSet<>();

for (int n : numbers) {
    if (seen.add(n)) {
        hasDuplicate = true;
    }
}
System.out.println(hasDuplicate);
--- solution
int[] numbers = {1, 2, 3};
boolean hasDuplicate = false;
HashSet<Integer> seen = new HashSet<>();

for (int n : numbers) {
    if (!seen.add(n)) {
        hasDuplicate = true;
    }
}
System.out.println(hasDuplicate);
--- test
__check(__out().trim().equals("false"), "No value repeats, so the flag should stay false");
--- hint
A successful `add` means the value was **new**, not duplicated.
--- hint
Negate the condition: `if (!seen.add(n))`.
```
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_4_6', 'sec_java_basics_4', 'crs_java_basics', 'Sorting, comparing and the Collections toolkit', 'interactive', 5, 1080, NULL, NULL, 'Sorting turns unordered data into something you can search, compare and display predictably. Java provides ready-made sorts; you rarely need to write the algorithm yourself.

## Sorting arrays

```java run
int[] scores = {90, 72, 85, 96, 77};
Arrays.sort(scores);
System.out.println(Arrays.toString(scores));

String[] names = {"Grace", "Ada", "Alan"};
Arrays.sort(names);
System.out.println(Arrays.toString(names));
```

`Arrays.sort` sorts numbers ascending and strings in lexicographic order. It modifies the array in place and returns nothing.

## Sorting lists

```java run
ArrayList<String> colors = new ArrayList<>(Arrays.asList("red", "blue", "green"));
Collections.sort(colors);
System.out.println(colors);

ArrayList<Integer> numbers = new ArrayList<>(Arrays.asList(9, 2, 7));
Collections.sort(numbers);
System.out.println(numbers);
```

`Collections.sort` works on lists. For a `List<String>`, the natural order is alphabetical. For a `List<Integer>`, it is numeric.

## Custom order with Comparator

```java run
Integer[] values = {3, 1, 2};
Arrays.sort(values, Collections.reverseOrder());
System.out.println(Arrays.toString(values));

ArrayList<String> words = new ArrayList<>(Arrays.asList("java", "code", "test"));
words.sort(Comparator.comparingInt(String::length));
System.out.println(words);
```

`Collections.reverseOrder()` gives descending order. `Comparator.comparingInt(String::length)` sorts by string length. A comparator returns a negative number, zero, or a positive number to say whether the first item comes before, equal to, or after the second.

Primitive arrays such as `int[]` cannot use `reverseOrder()` directly because it needs objects. Use `Integer[]` when you need a custom comparator, or sort ascending and reverse the result yourself.

## Sorting part of an array

```java run
Integer[] values = {9, 4, 7, 1, 3};
Arrays.sort(values, 1, 4);
System.out.println(Arrays.toString(values));

ArrayList<String> words = new ArrayList<>(Arrays.asList("pear", "apple", "fig"));
words.sort(Comparator.reverseOrder());
System.out.println(words);
```

The three-argument `Arrays.sort(array, from, to)` sorts only indexes `from` through `to - 1`, leaving the rest untouched. `Comparator.reverseOrder()` works on the list because its elements are objects.

```java predict id=sorting-predict title="What is printed?"
Integer[] nums = {3, 1, 2};
Arrays.sort(nums, Collections.reverseOrder());
System.out.println(Arrays.toString(nums));
--- options
* [3, 2, 1]
[1, 2, 3]
[3, 1, 2]
[2, 1, 3]
--- explain
`reverseOrder()` sorts from largest to smallest, so the output is `[3, 2, 1]`.
```

## Challenges

```java exercise id=sort-scores title="Sort scores ascending"
int[] scores = {90, 72, 85, 96, 77};

// Sort the array in ascending order.
--- solution
int[] scores = {90, 72, 85, 96, 77};
Arrays.sort(scores);
--- test
__check(Arrays.equals(scores, new int[]{72, 77, 85, 90, 96}), "The scores should be sorted from low to high");
--- hint
Use `Arrays.sort` on the array.
--- hint
`Arrays.sort(scores);`
```

```java exercise id=sort-words-by-length title="Sort words by length"
ArrayList<String> words = new ArrayList<>(Arrays.asList("programming", "java", "code"));

// Sort shortest first. Ties may stay in any order.
--- solution
ArrayList<String> words = new ArrayList<>(Arrays.asList("programming", "java", "code"));
words.sort(Comparator.comparingInt(String::length));
--- test
__check(words.get(0).length() <= words.get(1).length() && words.get(1).length() <= words.get(2).length(), "The words should be ordered from shortest to longest");
--- hint
Use `Comparator.comparingInt`.
--- hint
`words.sort(Comparator.comparingInt(String::length));`
```

```java debug id=fix-sort-direction title="The list is sorted backwards"
Integer[] values = {1, 3, 2};
Arrays.sort(values, Collections.reverseOrder());
System.out.println(Arrays.toString(values));
--- solution
Integer[] values = {1, 3, 2};
Arrays.sort(values);
System.out.println(Arrays.toString(values));
--- test
__check(__out().trim().equals("[1, 2, 3]"), "The output should be [1, 2, 3]");
--- hint
The task asks for ascending order, but `reverseOrder()` sorts descending.
--- hint
Remove the comparator: `Arrays.sort(values);`
```
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_4_7', 'sec_java_basics_4', 'crs_java_basics', 'Checkpoint: collections', 'quiz', 6, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"How do you read the number of elements in an array named `scores`?","options":["`scores.size()`","`scores.length()`","`scores.length`","`length(scores)`"],"answerIndex":2,"explanation":"An array''s `length` is a field, so it has no parentheses. `ArrayList` uses `size()` instead."},{"id":"q2","prompt":"What is the last valid index of `int[] values = new int[5]`?","options":["`5`","`4`","`6`","`0`"],"answerIndex":1,"explanation":"Indexes start at 0, so an array of length 5 has indexes 0 through 4. Reading `values[5]` throws `ArrayIndexOutOfBoundsException`."},{"id":"q3","prompt":"What is the initial value of each element in `new int[3]`?","options":["`null`","`0`","`1`","Undefined until assigned"],"answerIndex":1,"explanation":"New numeric arrays are filled with zero. Boolean arrays start as `false`, and object arrays start as `null`."},{"id":"q4","prompt":"Why is `Arrays.toString(values)` useful?","options":["It sorts the array","It prints a readable list of the elements","It returns the array''s length","It converts the array to an `ArrayList`"],"answerIndex":1,"explanation":"Printing an array directly shows a reference-like value. `Arrays.toString` builds a string such as `[1, 2, 3]`."},{"id":"q5","prompt":"In an enhanced `for` loop (`for (int value : values)`), what does `value` hold?","options":["The index of the current element","A copy of the current element''s value","A reference that can resize the array","The array''s length"],"answerIndex":1,"explanation":"The enhanced loop assigns each element to the variable. Changing `value` does not change the array, because it is a copy."},{"id":"q6","prompt":"Which call returns the number of items in an `ArrayList` named `items`?","options":["`items.length`","`items.length()`","`items.size()`","`items.count`"],"answerIndex":2,"explanation":"`ArrayList` is a class, so it exposes `size()` as a method. Arrays use the `length` field."},{"id":"q7","prompt":"For `ArrayList<String> list = new ArrayList<>(Arrays.asList(\"a\", \"b\", \"c\"));`, what does `list.remove(1)` remove?","options":["The value `\"1\"`","The element at index 1, which is `\"b\"`","The first element","Nothing, because `remove` only accepts strings"],"answerIndex":1,"explanation":"An `int` argument selects the overload that removes by index. Index 1 holds `\"b\"`."},{"id":"q8","prompt":"What does `map.get(\"missing\")` return for a `HashMap<String, Integer>`?","options":["`0`","`null`","`-1`","It throws an exception"],"answerIndex":1,"explanation":"A missing key returns `null`. Use `getOrDefault` if you need a numeric fallback."},{"id":"q9","prompt":"What is the size of a `HashSet` after adding `\"a\"`, `\"a\"`, and `\"b\"`?","options":["`1`","`2`","`3`","`0`"],"answerIndex":1,"explanation":"A set ignores duplicates. It contains `\"a\"` and `\"b\"`, so its size is `2`."},{"id":"q10","prompt":"What does `Arrays.sort(values)` do to the array?","options":["Returns a new sorted copy and leaves the original alone","Sorts the array in place and returns nothing","Reverses the array","Only works on `String[]`"],"answerIndex":1,"explanation":"`Arrays.sort` mutates the array in place. If you need to keep the original order, copy the array first."}]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_5_1', 'sec_java_basics_5', 'crs_java_basics', 'Methods: parameters and return values', 'interactive', 0, 1080, NULL, NULL, 'A **method** is a named block of code that can take inputs and return a result. Methods let you name an idea once and reuse it, instead of copying the same lines into every place that needs them.

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
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_5_2', 'sec_java_basics_5', 'crs_java_basics', 'Scope, static and overloading', 'interactive', 1, 1080, NULL, NULL, 'Where a variable can be used is called its **scope**. Java limits variables to the block where they are declared, which prevents accidental name clashes and makes methods easier to reason about. **Overloading** lets several methods share a name as long as their parameter lists differ.

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

`n` is a copy of the argument. Changing it inside `next` does not change `value` in `main`. This is **pass by value**: Java always passes a copy of the variable''s value.

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
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_5_3', 'sec_java_basics_5', 'crs_java_basics', 'Recursion: methods that call themselves', 'interactive', 2, 960, NULL, NULL, '**Recursion** is a method calling itself. It is a natural fit for problems that contain a smaller copy of themselves: factorials, directory trees, parsing nested expressions. Every recursive method needs a **base case** that stops the chain.

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
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_5_4', 'sec_java_basics_5', 'crs_java_basics', 'Method patterns: validation, helpers and decomposition', 'interactive', 3, 1080, NULL, NULL, 'Good methods are small, named clearly, and do one job. This lesson collects patterns you will use constantly: decomposing a problem into helpers, accepting a variable number of arguments, returning an array, and guarding against empty input.

## Decomposition

```java run class
public class Main {
    static int total(int[] scores) {
        int sum = 0;
        for (int score : scores) {
            sum += score;
        }
        return sum;
    }

    static double average(int[] scores) {
        if (scores.length == 0) {
            return 0;
        }
        return (double) total(scores) / scores.length;
    }

    static String grade(double average) {
        if (average >= 90) return "A";
        if (average >= 80) return "B";
        if (average >= 70) return "C";
        return "F";
    }

    public static void main(String[] args) {
        int[] scores = {90, 85, 77, 96};
        System.out.println(total(scores));
        System.out.println(average(scores));
        System.out.println(grade(average(scores)));
    }
}
```

Each method has one responsibility: add, average, or grade. `average` reuses `total`; `grade` reuses `average`. If the grading rule changes, only one method changes.

## Variable arguments

```java run class
public class Main {
    static int sum(int... numbers) {
        int total = 0;
        for (int n : numbers) {
            total += n;
        }
        return total;
    }

    public static void main(String[] args) {
        System.out.println(sum());
        System.out.println(sum(5));
        System.out.println(sum(1, 2, 3, 4));
    }
}
```

`int... numbers` accepts zero or more integers and packs them into an array. A method can have only one varargs parameter, and it must come last.

## Returning an array

```java run class
public class Main {
    static int[] evens(int[] values) {
        int count = 0;
        for (int value : values) {
            if (value % 2 == 0) {
                count++;
            }
        }

        int[] result = new int[count];
        int index = 0;
        for (int value : values) {
            if (value % 2 == 0) {
                result[index] = value;
                index++;
            }
        }
        return result;
    }

    public static void main(String[] args) {
        int[] result = evens(new int[]{3, 4, 8, 9, 10});
        System.out.println(Arrays.toString(result));
    }
}
```

The first pass counts how many values qualify; the second fills an array of exactly that size. This two-pass pattern avoids returning arrays with unused zeros at the end.

## Guard clauses

```java run class
public class Main {
    static String label(String name) {
        if (name == null || name.trim().isEmpty()) {
            return "anonymous";
        }
        return name.trim();
    }

    public static void main(String[] args) {
        System.out.println(label("  Ada  "));
        System.out.println(label(""));
        System.out.println(label(null));
    }
}
```

A **guard clause** handles the invalid case first and returns early. The main path stays unindented and easy to read. This is usually clearer than nesting the whole method inside an `if`.

```java predict class id=method-patterns-predict title="What is printed?"
public class Main {
    static int sum(int... numbers) {
        int total = 0;
        for (int n : numbers) total += n;
        return total;
    }

    public static void main(String[] args) {
        System.out.println(sum(1, 2, 3));
    }
}
--- options
* 6
3
1
compile error
--- explain
`1 + 2 + 3 = 6`. The varargs parameter collects all three arguments into an array and the loop adds them.
```

## Challenges

```java exercise class id=count-vowels title="Count the vowels in a word"
public class Main {
    // Define static int countVowels(String text).

    public static void main(String[] args) {
        System.out.println(countVowels("programming"));
    }
}
--- solution
public class Main {
    static int countVowels(String text) {
        int count = 0;
        String vowels = "aeiou";
        for (int i = 0; i < text.length(); i++) {
            if (vowels.indexOf(text.charAt(i)) >= 0) {
                count++;
            }
        }
        return count;
    }

    public static void main(String[] args) {
        System.out.println(countVowels("programming"));
    }
}
--- test
__check(Main.countVowels("programming") == 3, "programming has three vowels");
__check(Main.countVowels("xyz") == 0, "xyz has no vowels");
--- hint
Loop through the characters and check whether each one appears in `"aeiou"`.
--- hint
`"aeiou".indexOf(text.charAt(i)) >= 0`
```

```java exercise class id=filter-evens-method title="Return only the even values"
public class Main {
    // Define static int[] evens(int[] values).

    public static void main(String[] args) {
        System.out.println(Arrays.toString(evens(new int[]{1, 2, 4, 5})));
    }
}
--- solution
public class Main {
    static int[] evens(int[] values) {
        int count = 0;
        for (int value : values) {
            if (value % 2 == 0) count++;
        }
        int[] result = new int[count];
        int index = 0;
        for (int value : values) {
            if (value % 2 == 0) {
                result[index++] = value;
            }
        }
        return result;
    }

    public static void main(String[] args) {
        System.out.println(Arrays.toString(evens(new int[]{1, 2, 4, 5})));
    }
}
--- test
__check(Arrays.equals(Main.evens(new int[]{1, 2, 4, 5}), new int[]{2, 4}), "The even values are 2 and 4");
--- hint
Count the evens first so you can size the result array.
--- hint
Use a second index that starts at 0 and increments only when you store an even value.
```

```java debug class id=fix-varargs-sum title="The varargs sum ignores later numbers"
public class Main {
    static int sum(int... numbers) {
        return numbers[0];
    }

    public static void main(String[] args) {
        System.out.println(sum(1, 2, 3));
    }
}
--- solution
public class Main {
    static int sum(int... numbers) {
        int total = 0;
        for (int n : numbers) {
            total += n;
        }
        return total;
    }

    public static void main(String[] args) {
        System.out.println(sum(1, 2, 3));
    }
}
--- test
__check(Main.sum(1, 2, 3) == 6, "1 + 2 + 3 is 6");
__check(Main.sum() == 0, "The empty sum is 0");
--- hint
`numbers` is an array; returning `numbers[0]` returns only the first value.
--- hint
Loop over all the numbers and add them to a running total.
```
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_5_5', 'sec_java_basics_5', 'crs_java_basics', 'Checkpoint: methods', 'quiz', 4, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"What does a `void` return type mean?","options":["The method returns `null`","The method returns no value","The method cannot take parameters","The method is private"],"answerIndex":1,"explanation":"`void` means the method performs an action but does not send a value back. You cannot assign its result to a variable."},{"id":"q2","prompt":"In `static int add(int a, int b)`, what are `a` and `b` called?","options":["Arguments","Parameters","Return values","Fields"],"answerIndex":1,"explanation":"The names in the method declaration are parameters. The values supplied at the call site, such as `add(2, 3)`, are arguments."},{"id":"q3","prompt":"Why can `main` call a method marked `static` without creating an object?","options":["`static` methods are copied into `main`","`static` members belong to the class itself","`main` is not really a method","Java creates a hidden object automatically"],"answerIndex":1,"explanation":"A static method belongs to the class, not to an instance. `main` is static too, so it can call other static methods directly."},{"id":"q4","prompt":"A non-void method has an `if` with a `return` but no `return` after it. What does the compiler do?","options":["Returns `0` automatically","Returns `null` automatically","Reports that a return value is missing on some path","Runs the `if` branch twice"],"answerIndex":2,"explanation":"Every possible path through a non-void method must return a value. The compiler checks this before the program runs."},{"id":"q5","prompt":"Where can a variable declared inside a `for` loop body be used?","options":["Anywhere in the method","Only inside that loop body block","Only after the loop","In other methods of the same class"],"answerIndex":1,"explanation":"A local variable''s scope is the block where it is declared. It disappears at the closing brace of that block."},{"id":"q6","prompt":"When an `int` is passed to a method and the method changes its parameter, what happens to the caller''s variable?","options":["It changes too","It is unchanged, because Java passes a copy","It becomes `null`","The program does not compile"],"answerIndex":1,"explanation":"Java is pass-by-value. The method receives a copy of the value, so reassigning the parameter does not affect the caller''s variable."},{"id":"q7","prompt":"Which two methods correctly overload each other?","options":["`int area(int s)` and `double area(int s)`","`int area(int s)` and `int area(int w, int h)`","`int area(int s)` and `int area(int side)`","`void area(int s)` and `int area(int s)`"],"answerIndex":1,"explanation":"Overloads must differ in their parameter lists. Differing only by return type or parameter names is not enough."},{"id":"q8","prompt":"What is the essential part of every recursive method?","options":["A loop","A base case that stops the recursion","A `static` modifier","An array parameter"],"answerIndex":1,"explanation":"Without a base case, the method keeps calling itself until the stack overflows. Each recursive call must also move closer to that base case."},{"id":"q9","prompt":"What does the parameter `int... numbers` accept?","options":["Exactly one integer","Zero or more integers, packed into an array","Only an `int[]` variable","Any object type"],"answerIndex":1,"explanation":"Varargs accepts a variable number of arguments. Inside the method, `numbers` behaves like an `int[]`."},{"id":"q10","prompt":"What is a guard clause?","options":["A loop that protects an array","An early return for an invalid or edge case","A `try` block around every method","A `static` field used as a lock"],"answerIndex":1,"explanation":"A guard clause handles the invalid case first and returns early, leaving the main path unindented and easier to read."}]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_6_1', 'sec_java_basics_6', 'crs_java_basics', 'Exceptions: try, catch and throw', 'interactive', 0, 1080, NULL, NULL, 'An **exception** is Java''s way of saying that something went wrong. Instead of returning a special value and hoping every caller checks it, the method stops and an exception travels up the call stack until something catches it.

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

`throw` raises an exception immediately. `IllegalArgumentException` is the standard choice when a caller passes a value that violates the method''s contract.

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
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_6_2', 'sec_java_basics_6', 'crs_java_basics', 'Reading and writing files', 'interactive', 1, 1200, NULL, NULL, 'Files let a program keep data after it stops. Java''s `java.nio.file` package provides `Path` for locations and `Files` for operations. The browser runtime gives Java a small virtual filesystem, so the same code works here and on a desktop.

## Writing and reading

```java run
Path path = Paths.get("notes.txt");
List<String> lines = Arrays.asList("first line", "second line", "third line");

Files.write(path, lines);
System.out.println(Files.readAllLines(path));
```

`Paths.get` creates a path object; it does not touch the disk. `Files.write` creates or replaces the file and writes each list element as a line. `Files.readAllLines` returns a `List<String>`.

## Appending

```java run
Path path = Paths.get("log.txt");

Files.write(path, Arrays.asList("started"), StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING);
Files.write(path, Arrays.asList("finished"), StandardOpenOption.APPEND);

System.out.println(Files.readAllLines(path));
```

The first call creates a fresh file. The second opens it in append mode, so `finished` is added after `started`. Without `CREATE`, writing to a path that does not exist throws `NoSuchFileException`.

## Inspecting a file

```java run
Path path = Paths.get("report.txt");
Files.write(path, Arrays.asList("alpha", "beta"));

System.out.println(Files.exists(path));
System.out.println(Files.size(path));
System.out.println(Files.readAllLines(path).size());
```

`exists` returns a boolean, `size` returns the number of bytes, and the size of the returned list tells you how many lines were read. File sizes depend on encoding and line endings, so do not assume one character equals one byte.

## Handling missing files

```java run
Path path = Paths.get("does-not-exist.txt");

try {
    System.out.println(Files.readAllLines(path));
} catch (IOException e) {
    System.out.println("Could not read the file: " + e.getClass().getSimpleName());
}
```

`readAllLines` declares a checked `IOException`, so the compiler requires you to catch it or declare it. A checked exception is part of the method''s contract; the compiler makes sure callers acknowledge it.

```java predict id=files-predict title="What is printed?"
Path path = Paths.get("missing-file.txt");
System.out.println(Files.exists(path));
--- options
* false
true
null
IOException
--- explain
`exists` checks the filesystem and returns `false` when the path is absent. It does not throw for a missing file.
```

## Challenges

```java exercise id=write-and-read title="Write a file and read it back"
Path path = Paths.get("challenge.txt");
String result = "";

// Write "one" and "two" as two lines, then join the lines with "|".
--- solution
Path path = Paths.get("challenge.txt");
Files.write(path, Arrays.asList("one", "two"));
String result = String.join("|", Files.readAllLines(path));
--- test
__check(result.equals("one|two"), "The file should contain one and two");
--- hint
Use `Files.write` with `Arrays.asList(...)`.
--- hint
`String.join("|", Files.readAllLines(path))`
```

```java exercise id=count-file-lines title="Count the lines in a file"
Path path = Paths.get("count.txt");
int count = 0;

// Write three lines, then count them by reading the file.
--- solution
Path path = Paths.get("count.txt");
Files.write(path, Arrays.asList("alpha", "beta", "gamma"));
int count = Files.readAllLines(path).size();
--- test
__check(count == 3, "The file should have three lines");
--- hint
`Files.readAllLines` returns a list whose `size()` is the line count.
--- hint
Write three strings first.
```

```java debug id=fix-missing-create title="Appending to a new file fails"
Path path = Paths.get("new-log.txt");
Files.write(path, Arrays.asList("first"), StandardOpenOption.APPEND);
System.out.println(Files.exists(path));
--- solution
Path path = Paths.get("new-log.txt");
Files.write(path, Arrays.asList("first"), StandardOpenOption.CREATE, StandardOpenOption.APPEND);
System.out.println(Files.exists(path));
--- test
__check(__out().trim().equals("true"), "The file should exist after writing");
--- hint
Append mode does not create a missing file by itself.
--- hint
Add `StandardOpenOption.CREATE` to the options.
```
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_6_3', 'sec_java_basics_6', 'crs_java_basics', 'Packages, imports and the standard library', 'interactive', 2, 960, NULL, NULL, 'Java organises classes into **packages**. A package is a namespace: it keeps `Date` from one library separate from `Date` in another, and it gives classes a stable full name such as `java.util.ArrayList`.

## Imports

```java run class
import java.util.ArrayList;

public class Main {
    public static void main(String[] args) {
        ArrayList<String> names = new ArrayList<>();
        names.add("Ada");
        names.add("Grace");
        System.out.println(names);
    }
}
```

`import java.util.ArrayList;` lets you write `ArrayList` instead of the full name. Imports go after the package declaration and before the class. The runtime places your class in a package automatically, so the cell starts directly with the import.

A wildcard import brings in every class from a package:

```java run class
import java.util.*;

public class Main {
    public static void main(String[] args) {
        HashMap<String, Integer> ages = new HashMap<>();
        ages.put("Ada", 36);
        System.out.println(ages.get("Ada"));
    }
}
```

Wildcards are convenient while learning. In a large codebase, explicit imports make it easier to see where each name comes from.

## Fully qualified names

You can always use the full name and skip the import:

```java run class
public class Main {
    public static void main(String[] args) {
        java.util.ArrayList<String> items = new java.util.ArrayList<>();
        items.add("pen");
        items.add("paper");
        System.out.println(items.size());
    }
}
```

This is useful when two packages contain classes with the same simple name, because importing both would make the short name ambiguous.

## Static imports

A static import lets you call a class''s static members without the class name:

```java run class
import static java.lang.Math.*;

public class Main {
    public static void main(String[] args) {
        System.out.println(sqrt(81));
        System.out.println(max(3, 9));
        System.out.println(PI);
    }
}
```

Use static imports sparingly. `sqrt(81)` is readable in a maths-heavy method, but `abs(x)` without context can be harder to trace than `Math.abs(x)`.

## java.lang is automatic

```java run class
public class Main {
    public static void main(String[] args) {
        String text = "hello";
        System.out.println(text.toUpperCase());
        System.out.println(Integer.parseInt("42"));
    }
}
```

`String`, `System`, `Integer`, `Math` and the wrapper classes live in `java.lang`, which is imported automatically. That is why you have never needed an import for `System.out`.

```java predict class id=packages-predict title="What is printed?"
import static java.lang.Math.*;

public class Main {
    public static void main(String[] args) {
        System.out.println(sqrt(16));
    }
}
--- options
* 4.0
4
16.0
compile error
--- explain
`Math.sqrt` returns a `double`, and `sqrt(16)` is `4.0`. The static import only removes the need to write `Math.`.
```

## Challenges

```java exercise class id=use-import title="Use an imported ArrayList"
// Add the import and finish count().

public class Main {
    static int count() {
        return 0;
    }

    public static void main(String[] args) {
        System.out.println(count());
    }
}
--- solution
import java.util.ArrayList;

public class Main {
    static int count() {
        ArrayList<String> items = new ArrayList<>();
        items.add("one");
        items.add("two");
        return items.size();
    }

    public static void main(String[] args) {
        System.out.println(count());
    }
}
--- test
__check(Main.count() == 2, "The list should contain two items");
--- hint
Add `import java.util.ArrayList;` above the class.
--- hint
Create the list, add two strings, and return `items.size()`.
```

```java exercise class id=fully-qualified-map title="Use a fully qualified name"
public class Main {
    // Define static int size() using java.util.HashMap without an import.

    public static void main(String[] args) {
        System.out.println(size());
    }
}
--- solution
public class Main {
    static int size() {
        java.util.HashMap<String, Integer> map = new java.util.HashMap<>();
        map.put("a", 1);
        return map.size();
    }

    public static void main(String[] args) {
        System.out.println(size());
    }
}
--- test
__check(Main.size() == 1, "The map should contain one entry");
--- hint
Write the full type name `java.util.HashMap` in the declaration and the constructor.
--- hint
Put one entry in the map and return `map.size()`.
```

```java debug class id=fix-missing-import title="DecimalFormat cannot be found"
public class Main {
    public static void main(String[] args) {
        DecimalFormat format = new DecimalFormat("0.00");
        System.out.println(format.format(2.5));
    }
}
--- solution
import java.text.DecimalFormat;

public class Main {
    public static void main(String[] args) {
        DecimalFormat format = new DecimalFormat("0.00");
        System.out.println(format.format(2.5));
    }
}
--- test
__runMain();
__check(__out().trim().equals("2.50"), "The program should print 2.50");
--- hint
The compiler does not know the short name `DecimalFormat`.
--- hint
Add `import java.text.DecimalFormat;` at the top.
```
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_6_4', 'sec_java_basics_6', 'crs_java_basics', 'Checkpoint: errors, files & packages', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"What happens when code inside a `try` block throws an exception that matches a `catch`?","options":["The rest of the `try` block still runs","Control jumps to the matching `catch` block","The program always exits","The exception is ignored"],"answerIndex":1,"explanation":"The remaining statements in `try` are skipped. Execution moves to the first matching `catch`, then continues after the try/catch."},{"id":"q2","prompt":"When does a `finally` block run?","options":["Only when the `try` succeeds","Only when an exception is caught","Whether the `try` succeeds, throws, or returns","Only if there is no `catch`"],"answerIndex":2,"explanation":"`finally` is for cleanup, so it runs on every path out of the try/catch structure, including an early `return`."},{"id":"q3","prompt":"Which statement about checked exceptions is true?","options":["They never need to be handled","The compiler requires callers to catch or declare them","They only occur in loops","They are the same as `RuntimeException`"],"answerIndex":1,"explanation":"A checked exception is part of a method''s contract. The compiler ensures every caller catches it or declares it with `throws`."},{"id":"q4","prompt":"Why must `catch (NumberFormatException e)` come before `catch (Exception e)`?","options":["Java checks catch blocks alphabetically","The broader `Exception` catch would make the specific one unreachable","`NumberFormatException` is not an `Exception`","It makes the program run faster"],"answerIndex":1,"explanation":"A specific subclass must be caught before its superclass. Otherwise the broad catch would handle everything and the compiler rejects the unreachable one."},{"id":"q5","prompt":"What does `throw new IllegalArgumentException(\"bad input\");` do?","options":["Prints the message and continues","Creates an exception and immediately raises it","Returns `\"bad input\"` to the caller","Only works inside a `catch` block"],"answerIndex":1,"explanation":"`throw` raises the exception immediately. It travels up the call stack until a matching `catch` handles it."},{"id":"q6","prompt":"What does `Files.write(path, lines)` do by default?","options":["Appends to the file without changing existing content","Creates or replaces the file and writes the lines","Only writes if the file already exists","Returns the file''s contents"],"answerIndex":1,"explanation":"The default options create the file if needed and truncate an existing file, so the result contains exactly the supplied lines."},{"id":"q7","prompt":"What type does `Files.readAllLines(path)` return?","options":["`String`","`String[]`","`List<String>`","`ArrayList<String>`"],"answerIndex":2,"explanation":"It returns a `List<String>`, one string per line. You can call `size()` or iterate over it."},{"id":"q8","prompt":"Which option adds text to the end of an existing file?","options":["`StandardOpenOption.CREATE`","`StandardOpenOption.TRUNCATE_EXISTING`","`StandardOpenOption.APPEND`","`StandardOpenOption.READ`"],"answerIndex":2,"explanation":"`APPEND` writes after the existing content. Combine it with `CREATE` if the file may not exist yet."},{"id":"q9","prompt":"Where do `import` statements go?","options":["Inside `main`","After the class declaration","After the package declaration and before the class","At the end of the file"],"answerIndex":2,"explanation":"Imports come after the package statement and before any class declarations. The runtime adds the package line for you."},{"id":"q10","prompt":"Why is no import needed for `System.out.println`?","options":["`System` is a primitive type","`java.lang` is imported automatically","`println` is a keyword","Every class is in the default package"],"answerIndex":1,"explanation":"`System`, `String`, `Math`, `Integer` and the other core classes live in `java.lang`, which every Java file imports implicitly."}]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_7_1', 'sec_java_basics_7', 'crs_java_basics', 'Classes and objects: your own data types', 'interactive', 0, 1200, NULL, NULL, 'A **class** is a blueprint. An **object** is one instance built from that blueprint. Classes bundle data (fields) with the operations that belong to that data (methods), which is the heart of object-oriented programming.

## Fields, constructors and methods

```java run class
class Counter {
    int value;

    Counter(int start) {
        value = start;
    }

    void increment() {
        value++;
    }

    int getValue() {
        return value;
    }
}

public class Main {
    public static void main(String[] args) {
        Counter counter = new Counter(10);
        counter.increment();
        counter.increment();
        System.out.println(counter.getValue());
    }
}
```

`new Counter(10)` allocates an object and runs the constructor. The constructor has the same name as the class and no return type. Fields belong to each object, so two counters keep separate values.

## this

```java run class
class Person {
    String name;
    int age;

    Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    void birthday() {
        this.age++;
    }
}

public class Main {
    public static void main(String[] args) {
        Person ada = new Person("Ada", 36);
        ada.birthday();
        System.out.println(ada.name + " is " + ada.age);
    }
}
```

`this` refers to the current object. It is essential when a parameter has the same name as a field: `this.name = name` assigns the parameter to the field, while `name = name` would assign the parameter to itself.

## Encapsulation

```java run class
class Temperature {
    private double celsius;

    Temperature(double celsius) {
        this.celsius = celsius;
    }

    double getCelsius() {
        return celsius;
    }

    double getFahrenheit() {
        return celsius * 9 / 5 + 32;
    }

    void setCelsius(double celsius) {
        if (celsius < -273.15) {
            throw new IllegalArgumentException("Below absolute zero");
        }
        this.celsius = celsius;
    }
}

public class Main {
    public static void main(String[] args) {
        Temperature t = new Temperature(25);
        System.out.println(t.getFahrenheit());
        t.setCelsius(30);
        System.out.println(t.getCelsius());
    }
}
```

A `private` field cannot be read or written from outside the class. Access goes through methods, which can validate input. This is **encapsulation**: the object protects its own invariants.

## toString and static members

```java run class
class Point {
    int x;
    int y;

    Point(int x, int y) {
        this.x = x;
        this.y = y;
    }

    public String toString() {
        return "(" + x + ", " + y + ")";
    }

    static Point origin() {
        return new Point(0, 0);
    }
}

public class Main {
    public static void main(String[] args) {
        Point p = new Point(3, 4);
        System.out.println(p);
        System.out.println(Point.origin());
    }
}
```

`toString` is called automatically when an object is printed. A `static` method belongs to the class, not to a particular object, so you call it with `Point.origin()`.

```java predict class id=classes-predict title="What is printed?"
class Counter {
    int value;
    Counter(int start) { value = start; }
    void increment() { value++; }
}

public class Main {
    public static void main(String[] args) {
        Counter c = new Counter(5);
        c.increment();
        c.increment();
        System.out.println(c.value);
    }
}
--- options
* 7
5
6
2
--- explain
The counter starts at 5 and is incremented twice, so its value is 7.
```

## Challenges

```java exercise class id=create-book title="Create a Book class"
public class Main {
    // Define class Book with title and author fields,
    // a constructor, and String getTitle().

    public static void main(String[] args) {
        Book book = new Book("Java", "Ada");
        System.out.println(book.getTitle());
    }
}
--- solution
class Book {
    String title;
    String author;

    Book(String title, String author) {
        this.title = title;
        this.author = author;
    }

    String getTitle() {
        return title;
    }
}

public class Main {
    public static void main(String[] args) {
        Book book = new Book("Java", "Ada");
        System.out.println(book.getTitle());
    }
}
--- test
Book book = new Book("Java", "Ada");
__check(book.getTitle().equals("Java"), "getTitle should return Java");
--- hint
The constructor should store both parameters in fields.
--- hint
Use `this.title = title;` and `this.author = author;`.
```

```java exercise class id=counter-class title="Build a Counter class"
public class Main {
    // Define class Counter with a constructor, increment() and getValue().

    public static void main(String[] args) {
        Counter c = new Counter();
        c.increment();
        System.out.println(c.getValue());
    }
}
--- solution
class Counter {
    private int value;

    Counter() {
        value = 0;
    }

    void increment() {
        value++;
    }

    int getValue() {
        return value;
    }
}

public class Main {
    public static void main(String[] args) {
        Counter c = new Counter();
        c.increment();
        System.out.println(c.getValue());
    }
}
--- test
Counter c = new Counter();
c.increment();
c.increment();
__check(c.getValue() == 2, "Two increments should give 2");
--- hint
Keep an `int value` field and increase it in `increment`.
--- hint
`getValue` returns the field.
```

```java debug class id=fix-this-assignment title="The constructor never stores the name"
class User {
    String name;

    User(String name) {
        name = name;
    }

    String getName() {
        return name;
    }
}

public class Main {
    public static void main(String[] args) {
        User user = new User("Ada");
        System.out.println(user.getName());
    }
}
--- solution
class User {
    String name;

    User(String name) {
        this.name = name;
    }

    String getName() {
        return name;
    }
}

public class Main {
    public static void main(String[] args) {
        User user = new User("Ada");
        System.out.println(user.getName());
    }
}
--- test
User user = new User("Ada");
__check(user.getName().equals("Ada"), "The name should be Ada");
--- hint
The parameter `name` hides the field with the same name.
--- hint
Use `this.name = name;`.
```
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_7_2', 'sec_java_basics_7', 'crs_java_basics', 'Inheritance, interfaces and polymorphism', 'interactive', 1, 1200, NULL, NULL, '**Inheritance** lets one class build on another. The child class reuses the parent''s fields and methods, can add its own, and can **override** a method to change its behaviour. **Polymorphism** means you can treat different child objects through the parent type and still get the right behaviour.

## Extending a class

```java run class
class Animal {
    void speak() {
        System.out.println("...");
    }
}

class Dog extends Animal {
    @Override
    void speak() {
        System.out.println("Woof");
    }
}

public class Main {
    public static void main(String[] args) {
        Animal animal = new Animal();
        Dog dog = new Dog();

        animal.speak();
        dog.speak();
    }
}
```

`extends` establishes the parent-child relationship. `@Override` is optional but recommended: the compiler checks that a method with that signature really exists in the parent.

## super

```java run class
class Animal {
    String name;

    Animal(String name) {
        this.name = name;
    }

    String describe() {
        return "Animal named " + name;
    }
}

class Dog extends Animal {
    Dog(String name) {
        super(name);
    }

    @Override
    String describe() {
        return "Dog named " + name;
    }
}

public class Main {
    public static void main(String[] args) {
        Dog dog = new Dog("Rex");
        System.out.println(dog.describe());
    }
}
```

`super(name)` calls the parent constructor. If the parent has no no-argument constructor, the child must call `super(...)` explicitly. `super.method()` calls the parent''s version of a method when you want to extend rather than replace it.

## Polymorphism

```java run class
class Animal {
    String name;
    Animal(String name) { this.name = name; }
    String sound() { return "..."; }
}

class Dog extends Animal {
    Dog(String name) { super(name); }
    String sound() { return "Woof"; }
}

class Cat extends Animal {
    Cat(String name) { super(name); }
    String sound() { return "Meow"; }
}

public class Main {
    public static void main(String[] args) {
        Animal[] animals = {new Dog("Rex"), new Cat("Milo"), new Dog("Fido")};
        for (Animal animal : animals) {
            System.out.println(animal.name + ": " + animal.sound());
        }
    }
}
```

The array is typed as `Animal[]`, but each element is a specific subclass. At runtime Java calls the most specific override. This is **dynamic dispatch**, and it is what makes a collection of mixed objects useful.

## Abstract classes

```java run class
abstract class Shape {
    abstract double area();

    String label() {
        return "Area: " + area();
    }
}

class Square extends Shape {
    double side;
    Square(double side) { this.side = side; }

    @Override
    double area() {
        return side * side;
    }
}

public class Main {
    public static void main(String[] args) {
        Shape shape = new Square(4);
        System.out.println(shape.label());
    }
}
```

An `abstract` class cannot be instantiated. It can declare abstract methods that every concrete subclass must implement. `Shape` promises that every shape has an `area()`, without saying how to compute it.

```java predict class id=inheritance-predict title="What is printed?"
class Animal {
    String speak() { return "..."; }
}

class Dog extends Animal {
    String speak() { return "Woof"; }
}

public class Main {
    public static void main(String[] args) {
        Animal a = new Dog();
        System.out.println(a.speak());
    }
}
--- options
* Woof
...
Animal
compile error
--- explain
The variable type is `Animal`, but the object is a `Dog`. Java calls the override at runtime, so the result is `Woof`.
```

## Challenges

```java exercise class id=override-speak title="Override a method"
class Animal {
    String speak() {
        return "...";
    }
}

// Define class Dog that extends Animal and returns "Woof".

public class Main {
    public static void main(String[] args) {
        System.out.println(new Dog().speak());
    }
}
--- solution
class Animal {
    String speak() {
        return "...";
    }
}

class Dog extends Animal {
    @Override
    String speak() {
        return "Woof";
    }
}

public class Main {
    public static void main(String[] args) {
        System.out.println(new Dog().speak());
    }
}
--- test
Animal dog = new Dog();
__check(dog.speak().equals("Woof"), "A Dog should say Woof");
--- hint
Use `class Dog extends Animal`.
--- hint
Define `String speak()` with the same signature and return `"Woof"`.
```

```java exercise class id=abstract-shape title="Implement an abstract shape"
abstract class Shape {
    abstract double area();
}

// Define class Circle extends Shape with a radius constructor.

public class Main {
    public static void main(String[] args) {
        System.out.println(new Circle(2).area());
    }
}
--- solution
abstract class Shape {
    abstract double area();
}

class Circle extends Shape {
    double radius;

    Circle(double radius) {
        this.radius = radius;
    }

    @Override
    double area() {
        return Math.PI * radius * radius;
    }
}

public class Main {
    public static void main(String[] args) {
        System.out.println(new Circle(2).area());
    }
}
--- test
Shape circle = new Circle(2);
__check(Math.abs(circle.area() - Math.PI * 4) < 0.0001, "A circle with radius 2 has area 4 pi");
--- hint
`Circle extends Shape` must implement `area()`.
--- hint
Store the radius in a field and return `Math.PI * radius * radius`.
```

```java debug class id=fix-super-call title="The child constructor will not compile"
class Animal {
    String name;

    Animal(String name) {
        this.name = name;
    }
}

class Dog extends Animal {
    Dog(String name) {
        this.name = name;
    }
}

public class Main {
    public static void main(String[] args) {
        System.out.println(new Dog("Rex").name);
    }
}
--- solution
class Animal {
    String name;

    Animal(String name) {
        this.name = name;
    }
}

class Dog extends Animal {
    Dog(String name) {
        super(name);
    }
}

public class Main {
    public static void main(String[] args) {
        System.out.println(new Dog("Rex").name);
    }
}
--- test
Dog dog = new Dog("Rex");
__check(dog.name.equals("Rex"), "The dog should be named Rex");
--- hint
`Animal` has no no-argument constructor, so `Dog` must call the one that exists.
--- hint
Use `super(name);` as the first statement in the `Dog` constructor.
```
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_7_3', 'sec_java_basics_7', 'crs_java_basics', 'Checkpoint: objects & classes', 'quiz', 2, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"What is the relationship between a class and an object?","options":["A class is one instance of an object","An object is one instance created from a class blueprint","They are two names for the same thing","An object must contain at least one `main` method"],"answerIndex":1,"explanation":"The class describes the fields and methods. Each object is a separate instance with its own field values."},{"id":"q2","prompt":"Which statement about a constructor is true?","options":["It must return `void`","It has the same name as the class and no return type","It can only be called once per program","It must be `static`"],"answerIndex":1,"explanation":"A constructor shares the class name, has no return type, and runs when `new` creates an object."},{"id":"q3","prompt":"Why is `this.name = name;` useful in a constructor?","options":["It creates a second field","It assigns the parameter to the field when both have the same name","It makes the field `static`","It calls the parent constructor"],"answerIndex":1,"explanation":"`this.name` refers to the object''s field, while `name` on the right is the parameter. Without `this`, the assignment would target the parameter."},{"id":"q4","prompt":"What does marking a field `private` do?","options":["Prevents the field from being initialized","Allows access only from inside the same class","Makes the field read-only everywhere","Stores the field in a file"],"answerIndex":1,"explanation":"`private` hides the field from other classes. Code outside the class must use public methods, which can validate values."},{"id":"q5","prompt":"What is `toString()` used for?","options":["Converting a class to a file","Providing a readable string when an object is printed or concatenated","Deleting an object from memory","Comparing two objects for equality"],"answerIndex":1,"explanation":"`println` and string concatenation call `toString` automatically. Overriding it gives objects a useful display form."},{"id":"q6","prompt":"How do you call a `static` method named `origin` on a class named `Point`?","options":["`new Point().origin()`","`Point.origin()`","`Point->origin()`","`origin(Point)`"],"answerIndex":1,"explanation":"A static method belongs to the class, so it is called with the class name. An instance is not required."},{"id":"q7","prompt":"Which keyword establishes inheritance?","options":["`implements`","`extends`","`inherits`","`super`"],"answerIndex":1,"explanation":"A class inherits from another class with `extends`. `implements` is for interfaces."},{"id":"q8","prompt":"What does overriding a method mean?","options":["Declaring two methods with the same name in one class","Providing a subclass version of a method inherited from the parent","Making a method `static`","Calling the parent method twice"],"answerIndex":1,"explanation":"An override has the same signature as a parent method and replaces its behaviour for the subclass."},{"id":"q9","prompt":"When must a subclass call `super(...)`?","options":["Always, in every constructor","When the parent has no no-argument constructor","Only when the subclass has no constructor","Only for static methods"],"answerIndex":1,"explanation":"Java calls the parent''s no-argument constructor automatically. If the parent only has a constructor with parameters, the subclass must call it explicitly."},{"id":"q10","prompt":"What does this print? `Animal a = new Dog(); System.out.println(a.speak());` where `Dog` overrides `speak()`.","options":["The `Animal` version, because the variable type is `Animal`","The `Dog` version, because the object is a `Dog`","A compile error","`null`"],"answerIndex":1,"explanation":"Java dispatches overridden methods based on the object''s runtime type, not the variable''s declared type. The `Dog` override runs."}]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_java_basics_8_1', 'sec_java_basics_8', 'crs_java_basics', 'Project: grade report', 'interactive', 0, 1500, NULL, NULL, 'This project combines arrays, methods, formatting and classes into a small grade reporter. You will build it in pieces, then assemble the pieces into one object.

## Step 1: total and average

```java run class
public class Main {
    static int total(int[] scores) {
        int sum = 0;
        for (int score : scores) {
            sum += score;
        }
        return sum;
    }

    static double average(int[] scores) {
        if (scores.length == 0) {
            return 0;
        }
        return (double) total(scores) / scores.length;
    }

    public static void main(String[] args) {
        int[] scores = {90, 85, 77, 96};
        System.out.println(total(scores));
        System.out.println(average(scores));
    }
}
```

The cast to `double` happens before the division, so the average keeps its decimal part. The empty-array guard avoids dividing by zero.

## Step 2: letter grades

```java run class
public class Main {
    static String letter(double average) {
        if (average >= 90) return "A";
        if (average >= 80) return "B";
        if (average >= 70) return "C";
        return "F";
    }

    public static void main(String[] args) {
        System.out.println(letter(95));
        System.out.println(letter(85));
        System.out.println(letter(72));
        System.out.println(letter(60));
    }
}
```

Each guard returns immediately, so the thresholds can be read from highest to lowest without nested `else` blocks.

## Step 3: a GradeReport object

```java run class
class GradeReport {
    private int[] scores;

    GradeReport(int[] scores) {
        this.scores = scores;
    }

    int total() {
        int sum = 0;
        for (int score : scores) {
            sum += score;
        }
        return sum;
    }

    double average() {
        if (scores.length == 0) return 0;
        return (double) total() / scores.length;
    }

    int highest() {
        int max = scores[0];
        for (int score : scores) {
            if (score > max) max = score;
        }
        return max;
    }

    String summary() {
        return String.format("Average: %.1f, highest: %d", average(), highest());
    }
}

public class Main {
    public static void main(String[] args) {
        GradeReport report = new GradeReport(new int[]{90, 85, 77, 96});
        System.out.println(report.summary());
    }
}
```

The object owns the scores and exposes only the operations callers need. `summary` hides the formatting details.

## Step 4: a full report

```java run class
class GradeReport {
    private String student;
    private int[] scores;

    GradeReport(String student, int[] scores) {
        this.student = student;
        this.scores = scores;
    }

    double average() {
        if (scores.length == 0) return 0;
        int sum = 0;
        for (int score : scores) sum += score;
        return (double) sum / scores.length;
    }

    String letter() {
        double avg = average();
        if (avg >= 90) return "A";
        if (avg >= 80) return "B";
        if (avg >= 70) return "C";
        return "F";
    }

    void print() {
        System.out.println("Report for " + student);
        for (int i = 0; i < scores.length; i++) {
            System.out.println("  Test " + (i + 1) + ": " + scores[i]);
        }
        System.out.println(String.format("  Average: %.1f (%s)", average(), letter()));
    }
}

public class Main {
    public static void main(String[] args) {
        new GradeReport("Ada", new int[]{90, 85, 77, 96}).print();
        new GradeReport("Grace", new int[]{88, 92, 79}).print();
    }
}
```

Adding the student''s name and a `print` method turns the calculation into a report. Each object produces its own section without `main` knowing the details.

```java predict class id=grade-report-predict title="What is printed?"
public class Main {
    public static void main(String[] args) {
        System.out.println(String.format("%.2f", 3.14159));
    }
}
--- options
* 3.14
3.1
3.142
3
--- explain
`%.2f` formats a decimal with exactly two digits after the point, rounding the rest, so the result is `3.14`.
```

## Challenges

```java exercise class id=report-average title="Write the average method"
public class Main {
    // Define static double average(int[] scores).

    public static void main(String[] args) {
        System.out.println(average(new int[]{90, 81}));
    }
}
--- solution
public class Main {
    static double average(int[] scores) {
        if (scores.length == 0) return 0;
        int sum = 0;
        for (int score : scores) sum += score;
        return (double) sum / scores.length;
    }

    public static void main(String[] args) {
        System.out.println(average(new int[]{90, 81}));
    }
}
--- test
__check(Math.abs(Main.average(new int[]{90, 81}) - 85.5) < 0.0001, "The average of 90 and 81 is 85.5");
__check(Main.average(new int[]{}) == 0, "An empty report has average 0");
--- hint
Sum the values, then divide by the length.
--- hint
Cast the sum to `double` before dividing.
```

```java exercise class id=report-letter title="Write the letter method"
public class Main {
    // Define static String letter(double average).

    public static void main(String[] args) {
        System.out.println(letter(85));
    }
}
--- solution
public class Main {
    static String letter(double average) {
        if (average >= 90) return "A";
        if (average >= 80) return "B";
        if (average >= 70) return "C";
        return "F";
    }

    public static void main(String[] args) {
        System.out.println(letter(85));
    }
}
--- test
__check(Main.letter(95).equals("A"), "95 is an A");
__check(Main.letter(85).equals("B"), "85 is a B");
__check(Main.letter(65).equals("F"), "65 is an F");
--- hint
Check the highest threshold first.
--- hint
Return a letter from each branch.
```

```java debug class id=fix-report-average title="The report average is truncated"
class GradeReport {
    int[] scores;
    GradeReport(int[] scores) { this.scores = scores; }

    double average() {
        int sum = 0;
        for (int score : scores) sum += score;
        return sum / scores.length;
    }
}

public class Main {
    public static void main(String[] args) {
        System.out.println(new GradeReport(new int[]{90, 81}).average());
    }
}
--- solution
class GradeReport {
    int[] scores;
    GradeReport(int[] scores) { this.scores = scores; }

    double average() {
        int sum = 0;
        for (int score : scores) sum += score;
        return (double) sum / scores.length;
    }
}

public class Main {
    public static void main(String[] args) {
        System.out.println(new GradeReport(new int[]{90, 81}).average());
    }
}
--- test
__check(Math.abs(new GradeReport(new int[]{90, 81}).average() - 85.5) < 0.0001, "The average should be 85.5");
--- hint
Both `sum` and `scores.length` are integers, so the division truncates.
--- hint
Cast `sum` to `double` before dividing.
```
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_8_2', 'sec_java_basics_8', 'crs_java_basics', 'Project: a to-do manager', 'interactive', 1, 1500, NULL, NULL, 'A to-do list is a small but realistic program: it stores items, changes their state, removes them, and reports what is left. You will build it with `ArrayList`, classes and methods.

## Step 1: a list of strings

```java run class
import java.util.ArrayList;

public class Main {
    public static void main(String[] args) {
        ArrayList<String> tasks = new ArrayList<>();
        tasks.add("Buy milk");
        tasks.add("Write report");
        tasks.add("Call Ada");

        tasks.remove("Write report");
        System.out.println(tasks);
        System.out.println(tasks.size());
    }
}
```

`remove("Write report")` removes by value. Removing by index would be `remove(1)`. The two overloads are easy to mix up, so choose deliberately.

## Step 2: a Task class

```java run class
class Task {
    String title;
    boolean done;

    Task(String title) {
        this.title = title;
        this.done = false;
    }

    void complete() {
        done = true;
    }

    public String toString() {
        return (done ? "[x] " : "[ ] ") + title;
    }
}

public class Main {
    public static void main(String[] args) {
        Task task = new Task("Buy milk");
        System.out.println(task);
        task.complete();
        System.out.println(task);
    }
}
```

The boolean `done` is part of the task''s state. `toString` gives a compact display, and the ternary chooses the checkbox.

## Step 3: a TodoList class

```java run class
import java.util.ArrayList;

class Task {
    String title;
    boolean done;
    Task(String title) { this.title = title; }
    void complete() { done = true; }
    public String toString() { return (done ? "[x] " : "[ ] ") + title; }
}

class TodoList {
    private ArrayList<Task> tasks = new ArrayList<>();

    void add(String title) {
        tasks.add(new Task(title));
    }

    void complete(int index) {
        if (index >= 0 && index < tasks.size()) {
            tasks.get(index).complete();
        }
    }

    int remaining() {
        int count = 0;
        for (Task task : tasks) {
            if (!task.done) count++;
        }
        return count;
    }

    void print() {
        for (int i = 0; i < tasks.size(); i++) {
            System.out.println(i + ": " + tasks.get(i));
        }
    }
}

public class Main {
    public static void main(String[] args) {
        TodoList list = new TodoList();
        list.add("Buy milk");
        list.add("Write report");
        list.complete(0);
        list.print();
        System.out.println("Remaining: " + list.remaining());
    }
}
```

`complete` checks the index before touching the list. The `remaining` method counts only unfinished tasks. `print` shows the index so the user knows what to pass to `complete`.

## Step 4: a complete small app

```java run class
import java.util.ArrayList;

class Task {
    String title;
    boolean done;
    Task(String title) { this.title = title; }
    void complete() { done = true; }
    public String toString() { return (done ? "[x] " : "[ ] ") + title; }
}

class TodoList {
    private ArrayList<Task> tasks = new ArrayList<>();

    void add(String title) {
        if (title == null || title.trim().isEmpty()) {
            throw new IllegalArgumentException("Title cannot be empty");
        }
        tasks.add(new Task(title.trim()));
    }

    void complete(int index) {
        if (index < 0 || index >= tasks.size()) {
            throw new IndexOutOfBoundsException("No task at " + index);
        }
        tasks.get(index).complete();
    }

    void removeCompleted() {
        for (int i = tasks.size() - 1; i >= 0; i--) {
            if (tasks.get(i).done) {
                tasks.remove(i);
            }
        }
    }

    int remaining() {
        int count = 0;
        for (Task task : tasks) if (!task.done) count++;
        return count;
    }

    void print() {
        for (int i = 0; i < tasks.size(); i++) {
            System.out.println(i + ": " + tasks.get(i));
        }
    }
}

public class Main {
    public static void main(String[] args) {
        TodoList list = new TodoList();
        list.add("Buy milk");
        list.add("Write report");
        list.add("Call Ada");
        list.complete(1);
        list.removeCompleted();
        list.print();
        System.out.println("Remaining: " + list.remaining());
    }
}
```

`removeCompleted` walks **backwards**. Removing from an `ArrayList` shifts later elements left, so a forward loop would skip the item after each removal. Walking backwards keeps the indexes valid.

```java predict class id=todo-predict title="What is printed?"
import java.util.ArrayList;

public class Main {
    public static void main(String[] args) {
        ArrayList<String> tasks = new ArrayList<>();
        tasks.add("a");
        tasks.add("b");
        tasks.add("c");
        tasks.remove(0);
        System.out.println(tasks.get(0));
    }
}
--- options
* b
a
c
IndexOutOfBoundsException
--- explain
Removing index 0 removes `"a"` and shifts the rest left. The list is `[b, c]`, so index 0 is `"b"`.
```

## Challenges

```java exercise class id=add-task title="Add tasks to the list"
import java.util.ArrayList;

class TodoList {
    ArrayList<String> tasks = new ArrayList<>();

    // Add a method add(String title) that appends the title.
}

public class Main {
    public static void main(String[] args) {
        TodoList list = new TodoList();
        list.add("Buy milk");
        System.out.println(list.tasks.size());
    }
}
--- solution
import java.util.ArrayList;

class TodoList {
    ArrayList<String> tasks = new ArrayList<>();

    void add(String title) {
        tasks.add(title);
    }
}

public class Main {
    public static void main(String[] args) {
        TodoList list = new TodoList();
        list.add("Buy milk");
        System.out.println(list.tasks.size());
    }
}
--- test
TodoList list = new TodoList();
list.add("Buy milk");
list.add("Write report");
__check(list.tasks.size() == 2, "Two tasks should be stored");
--- hint
The method takes a `String` and calls `tasks.add`.
--- hint
`void add(String title) { tasks.add(title); }`
```

```java exercise class id=complete-task title="Mark a task complete"
class Task {
    String title;
    boolean done;
    Task(String title) { this.title = title; }

    // Add complete().
}

public class Main {
    public static void main(String[] args) {
        Task task = new Task("Buy milk");
        task.complete();
        System.out.println(task.done);
    }
}
--- solution
class Task {
    String title;
    boolean done;
    Task(String title) { this.title = title; }

    void complete() {
        done = true;
    }
}

public class Main {
    public static void main(String[] args) {
        Task task = new Task("Buy milk");
        task.complete();
        System.out.println(task.done);
    }
}
--- test
Task task = new Task("Buy milk");
task.complete();
__check(task.done, "complete() should set done to true");
--- hint
`done` starts as `false` by default.
--- hint
`void complete() { done = true; }`
```

```java debug class id=fix-remaining-count title="The remaining count includes finished tasks"
import java.util.ArrayList;

class Task {
    boolean done;
    Task(boolean done) { this.done = done; }
}

class TodoList {
    ArrayList<Task> tasks = new ArrayList<>();

    int remaining() {
        return tasks.size();
    }
}

public class Main {
    public static void main(String[] args) {
        TodoList list = new TodoList();
        list.tasks.add(new Task(true));
        list.tasks.add(new Task(false));
        System.out.println(list.remaining());
    }
}
--- solution
import java.util.ArrayList;

class Task {
    boolean done;
    Task(boolean done) { this.done = done; }
}

class TodoList {
    ArrayList<Task> tasks = new ArrayList<>();

    int remaining() {
        int count = 0;
        for (Task task : tasks) {
            if (!task.done) count++;
        }
        return count;
    }
}

public class Main {
    public static void main(String[] args) {
        TodoList list = new TodoList();
        list.tasks.add(new Task(true));
        list.tasks.add(new Task(false));
        System.out.println(list.remaining());
    }
}
--- test
TodoList list = new TodoList();
list.tasks.add(new Task(true));
list.tasks.add(new Task(false));
list.tasks.add(new Task(false));
__check(list.remaining() == 2, "Only the two unfinished tasks should count");
--- hint
`size()` counts every task, finished or not.
--- hint
Loop through the tasks and count only those with `!task.done`.
```
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_8_3', 'sec_java_basics_8', 'crs_java_basics', 'Project: a bank account with classes and exceptions', 'interactive', 2, 1500, NULL, NULL, 'The final project is a bank account. It brings together classes, encapsulation, collections, exceptions and formatting. The rules are simple, but they must be enforced every time: a balance cannot go negative, and a withdrawal larger than the balance must fail.

## Step 1: deposit and withdraw

```java run class
class BankAccount {
    private double balance;

    BankAccount(double opening) {
        balance = opening;
    }

    void deposit(double amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("Deposit must be positive");
        }
        balance += amount;
    }

    boolean withdraw(double amount) {
        if (amount <= 0 || amount > balance) {
            return false;
        }
        balance -= amount;
        return true;
    }

    double getBalance() {
        return balance;
    }
}

public class Main {
    public static void main(String[] args) {
        BankAccount account = new BankAccount(100);
        account.deposit(50);
        System.out.println(account.withdraw(30));
        System.out.println(account.getBalance());
        System.out.println(account.withdraw(500));
        System.out.println(account.getBalance());
    }
}
```

`withdraw` returns a boolean so the caller knows whether the operation happened. The second withdrawal fails and the balance stays `120`.

## Step 2: validate at the boundary

```java run class
class BankAccount {
    private double balance;

    BankAccount(double opening) {
        if (opening < 0) {
            throw new IllegalArgumentException("Opening balance cannot be negative");
        }
        balance = opening;
    }

    void deposit(double amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("Deposit must be positive");
        }
        balance += amount;
    }

    void withdraw(double amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("Withdrawal must be positive");
        }
        if (amount > balance) {
            throw new IllegalStateException("Insufficient funds");
        }
        balance -= amount;
    }

    double getBalance() {
        return balance;
    }
}

public class Main {
    public static void main(String[] args) {
        BankAccount account = new BankAccount(50);
        try {
            account.withdraw(80);
        } catch (IllegalStateException e) {
            System.out.println(e.getMessage());
        }
        System.out.println(account.getBalance());
    }
}
```

Sometimes a boolean is the right signal, sometimes an exception is. Use a boolean for an expected outcome such as "not enough money"; use an exception when the caller has violated the contract, such as a negative deposit.

## Step 3: keep a history

```java run class
import java.util.ArrayList;

class BankAccount {
    private double balance;
    private ArrayList<String> history = new ArrayList<>();

    BankAccount(double opening) {
        balance = opening;
        history.add(String.format("open %.2f", opening));
    }

    void deposit(double amount) {
        if (amount <= 0) throw new IllegalArgumentException("Deposit must be positive");
        balance += amount;
        history.add(String.format("deposit %.2f", amount));
    }

    boolean withdraw(double amount) {
        if (amount <= 0 || amount > balance) return false;
        balance -= amount;
        history.add(String.format("withdraw %.2f", amount));
        return true;
    }

    void printHistory() {
        for (String entry : history) {
            System.out.println(entry);
        }
    }

    double getBalance() { return balance; }
}

public class Main {
    public static void main(String[] args) {
        BankAccount account = new BankAccount(100);
        account.deposit(25);
        account.withdraw(40);
        account.withdraw(500);
        account.printHistory();
        System.out.println(String.format("Balance: %.2f", account.getBalance()));
    }
}
```

The failed withdrawal does not appear in the history because it returns before recording anything. Keeping the balance and the history updated in the same method prevents the two from drifting apart.

## Step 4: transfer between accounts

```java run class
class BankAccount {
    private double balance;

    BankAccount(double opening) {
        if (opening < 0) throw new IllegalArgumentException("Negative opening balance");
        balance = opening;
    }

    boolean withdraw(double amount) {
        if (amount <= 0 || amount > balance) return false;
        balance -= amount;
        return true;
    }

    void deposit(double amount) {
        if (amount <= 0) throw new IllegalArgumentException("Deposit must be positive");
        balance += amount;
    }

    double getBalance() { return balance; }
}

public class Main {
    static boolean transfer(BankAccount from, BankAccount to, double amount) {
        if (!from.withdraw(amount)) {
            return false;
        }
        to.deposit(amount);
        return true;
    }

    public static void main(String[] args) {
        BankAccount ada = new BankAccount(100);
        BankAccount grace = new BankAccount(20);

        System.out.println(transfer(ada, grace, 30));
        System.out.println(ada.getBalance());
        System.out.println(grace.getBalance());

        System.out.println(transfer(ada, grace, 500));
        System.out.println(ada.getBalance());
        System.out.println(grace.getBalance());
    }
}
```

A transfer is a withdrawal followed by a deposit. Checking the withdrawal first means a failed transfer leaves both accounts untouched. In a real system this would also need a transaction so a crash between the two steps cannot lose money.

```java predict class id=bank-predict title="What is printed?"
class BankAccount {
    private double balance;
    BankAccount(double balance) { this.balance = balance; }
    boolean withdraw(double amount) {
        if (amount > balance) return false;
        balance -= amount;
        return true;
    }
    double getBalance() { return balance; }
}

public class Main {
    public static void main(String[] args) {
        BankAccount account = new BankAccount(50);
        System.out.println(account.withdraw(80) + " " + account.getBalance());
    }
}
--- options
* false 50.0
true 30.0
false 30.0
true 50.0
--- explain
`withdraw(80)` returns `false` and leaves the balance at `50.0`. The string join produces `false 50.0`.
```

## Challenges

```java exercise class id=bank-deposit title="Add a deposit method"
class BankAccount {
    private double balance;

    BankAccount(double opening) {
        balance = opening;
    }

    // Add deposit(double amount). Reject amounts that are not positive.

    double getBalance() { return balance; }
}

public class Main {
    public static void main(String[] args) {
        BankAccount account = new BankAccount(10);
        account.deposit(5);
        System.out.println(account.getBalance());
    }
}
--- solution
class BankAccount {
    private double balance;

    BankAccount(double opening) {
        balance = opening;
    }

    void deposit(double amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("Deposit must be positive");
        }
        balance += amount;
    }

    double getBalance() { return balance; }
}

public class Main {
    public static void main(String[] args) {
        BankAccount account = new BankAccount(10);
        account.deposit(5);
        System.out.println(account.getBalance());
    }
}
--- test
BankAccount account = new BankAccount(10);
account.deposit(5);
__check(Math.abs(account.getBalance() - 15) < 0.0001, "The balance should be 15");
--- hint
Add the amount to `balance` after validating it.
--- hint
`balance += amount;`
```

```java exercise class id=bank-withdraw title="Add a checked withdrawal"
class BankAccount {
    private double balance;

    BankAccount(double opening) {
        balance = opening;
    }

    // Add boolean withdraw(double amount): false if too large or not positive.

    double getBalance() { return balance; }
}

public class Main {
    public static void main(String[] args) {
        BankAccount account = new BankAccount(100);
        System.out.println(account.withdraw(30));
    }
}
--- solution
class BankAccount {
    private double balance;

    BankAccount(double opening) {
        balance = opening;
    }

    boolean withdraw(double amount) {
        if (amount <= 0 || amount > balance) {
            return false;
        }
        balance -= amount;
        return true;
    }

    double getBalance() { return balance; }
}

public class Main {
    public static void main(String[] args) {
        BankAccount account = new BankAccount(100);
        System.out.println(account.withdraw(30));
    }
}
--- test
BankAccount account = new BankAccount(100);
__check(account.withdraw(30), "A valid withdrawal should succeed");
__check(Math.abs(account.getBalance() - 70) < 0.0001, "The balance should be 70");
__check(!account.withdraw(500), "An overdraft should fail");
--- hint
Check `amount <= 0 || amount > balance` before subtracting.
--- hint
Return `false` for a rejected withdrawal and `true` after a successful one.
```

```java debug class id=fix-withdraw-guard title="The account goes negative"
class BankAccount {
    private double balance;

    BankAccount(double opening) {
        balance = opening;
    }

    boolean withdraw(double amount) {
        balance -= amount;
        return true;
    }

    double getBalance() { return balance; }
}

public class Main {
    public static void main(String[] args) {
        BankAccount account = new BankAccount(50);
        System.out.println(account.withdraw(80));
        System.out.println(account.getBalance());
    }
}
--- solution
class BankAccount {
    private double balance;

    BankAccount(double opening) {
        balance = opening;
    }

    boolean withdraw(double amount) {
        if (amount <= 0 || amount > balance) {
            return false;
        }
        balance -= amount;
        return true;
    }

    double getBalance() { return balance; }
}

public class Main {
    public static void main(String[] args) {
        BankAccount account = new BankAccount(50);
        System.out.println(account.withdraw(80));
        System.out.println(account.getBalance());
    }
}
--- test
BankAccount account = new BankAccount(50);
__check(!account.withdraw(80), "The overdraft should be rejected");
__check(Math.abs(account.getBalance() - 50) < 0.0001, "The balance should stay 50");
--- hint
The method subtracts before checking whether the withdrawal is allowed.
--- hint
Return `false` when `amount > balance`, before changing `balance`.
```
', 0, '[]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z'),
('les_java_basics_8_4', 'sec_java_basics_8', 'crs_java_basics', 'Final exam: Java Basics', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"A grade report method returns `sum / scores.length` and the average is always a whole number. What is the fix?","options":["Use `Math.round(sum / scores.length)`","Cast before dividing: `(double) sum / scores.length`","Store `sum` in a `String`","Use `%` instead of `/`"],"answerIndex":1,"explanation":"Both operands are integers, so the division truncates. Casting `sum` to `double` forces decimal division."},{"id":"q2","prompt":"Why does a `for` loop that removes items from an `ArrayList` often skip elements?","options":["`ArrayList` cannot remove items","Each removal shifts later elements left, so the next index is skipped","The loop variable is always reset","`remove` only works on the last element"],"answerIndex":1,"explanation":"Removing an element closes the gap by shifting later elements left. Iterating backwards, or using an `Iterator`, avoids skipping."},{"id":"q3","prompt":"What is the safest way to read a count from a `HashMap<String, Integer>` when the key may be missing?","options":["`map.get(key) + 1`","`map.getOrDefault(key, 0)`","`map.containsKey(key) + 1`","`map.remove(key)`"],"answerIndex":1,"explanation":"`get` returns `null` for a missing key, and unboxing `null` for arithmetic throws `NullPointerException`. `getOrDefault` supplies a real number."},{"id":"q4","prompt":"What is the main guarantee of a `HashSet`?","options":["Elements stay in insertion order","Elements are sorted automatically","It contains no duplicate values","Every element has an integer key"],"answerIndex":2,"explanation":"A set stores each distinct value once. It does not promise order; use a `TreeSet` for sorted order or a `LinkedHashSet` for insertion order."},{"id":"q5","prompt":"What happens if a recursive method has no base case?","options":["It returns `null`","It runs until the JVM throws `StackOverflowError`","It automatically becomes a loop","It compiles but never runs"],"answerIndex":1,"explanation":"Each call adds a frame to the call stack. Without a base case the stack eventually runs out of space."},{"id":"q6","prompt":"In a `try / catch / finally` block, which parts run when the `try` throws a caught exception?","options":["Only the `try`","The `catch` and then the `finally`","Only the `finally`","The `try` again, then the `finally`"],"answerIndex":1,"explanation":"The matching `catch` handles the exception, and `finally` runs afterwards on the way out."},{"id":"q7","prompt":"Why does a bank account keep its `balance` field `private`?","options":["Private fields use less memory","So changes go through methods that can enforce the account rules","So the field cannot be printed","Because `double` fields must be private"],"answerIndex":1,"explanation":"Encapsulation protects the invariant that the balance never goes negative. A public field could be changed to any value by any code."},{"id":"q8","prompt":"`Animal a = new Dog();` where `Dog` extends `Animal` and overrides `speak()`. Which `speak()` runs?","options":["`Animal.speak()`","`Dog.speak()`","Both, one after the other","Neither; the call is ambiguous"],"answerIndex":1,"explanation":"The declared type controls what you can call, but the runtime object controls which override executes. The `Dog` version runs."},{"id":"q9","prompt":"Why use a `StringBuilder` instead of joining many pieces with `+` in a loop?","options":["`StringBuilder` can store numbers without conversion","Strings are immutable, so each `+` creates a new string","`+` does not work inside loops","`StringBuilder` sorts the pieces"],"answerIndex":1,"explanation":"Because strings cannot change, repeated concatenation allocates a new string each time. `StringBuilder` appends into one growing buffer."},{"id":"q10","prompt":"What does this print? `for (int i = 0; i < 3; i++) { System.out.print(i); }`","options":["`123`","`012`","`0123`","`0 1 2`"],"answerIndex":1,"explanation":"The loop runs for 0, 1 and 2. `print` keeps them on one line, producing `012`."}]', '[]', '2026-06-25T06:04:00.410Z', '2026-10-19T06:04:00.410Z');

INSERT INTO enrollments (id, user_id, course_id, source, progress_percent, last_lesson_id, last_activity_at, completed_at, created_at) VALUES
('enr_crs_java_basics_demo', 'usr_student', 'crs_java_basics', 'free', 13, 'les_java_basics_2_2', '2026-10-20T06:04:00.410Z', NULL, '2026-08-24T06:04:00.410Z');

INSERT INTO lesson_progress (user_id, lesson_id, course_id, completed, position_seconds, completed_at, updated_at) VALUES
('usr_student', 'les_java_basics_1_1', 'crs_java_basics', 1, 0, '2026-09-03T06:04:00.410Z', '2026-09-03T06:04:00.410Z'),
('usr_student', 'les_java_basics_1_2', 'crs_java_basics', 1, 0, '2026-09-04T06:04:00.410Z', '2026-09-04T06:04:00.410Z'),
('usr_student', 'les_java_basics_1_3', 'crs_java_basics', 1, 0, '2026-09-05T06:04:00.410Z', '2026-09-05T06:04:00.410Z'),
('usr_student', 'les_java_basics_1_4', 'crs_java_basics', 1, 0, '2026-09-06T06:04:00.410Z', '2026-09-06T06:04:00.410Z'),
('usr_student', 'les_java_basics_2_1', 'crs_java_basics', 1, 0, '2026-09-07T06:04:00.410Z', '2026-09-07T06:04:00.410Z');

INSERT INTO exercise_progress (user_id, lesson_id, cell_id, code, passed, attempts, solved_at, updated_at) VALUES
('usr_student', 'les_java_basics_1_2', 'print-receipt', 'System.out.println("Coffee");
System.out.println("3.50");
System.out.println("Total: 3.50");', 1, 2, '2026-09-04T06:04:00.410Z', '2026-09-04T06:04:00.410Z'),
('usr_student', 'les_java_basics_1_2', 'print-initials', 'System.out.print("J");
System.out.print("V");
System.out.println("M");', 1, 2, '2026-09-04T06:04:00.410Z', '2026-09-04T06:04:00.410Z'),
('usr_student', 'les_java_basics_1_2', 'fix-missing-semicolon', 'System.out.println("Compiling");
System.out.println("and running");', 1, 2, '2026-09-04T06:04:00.410Z', '2026-09-04T06:04:00.410Z'),
('usr_student', 'les_java_basics_1_3', 'swap-values', 'int a = 3;
int b = 8;

int temp = a;
a = b;
b = temp;', 1, 2, '2026-09-05T06:04:00.410Z', '2026-09-05T06:04:00.410Z'),
('usr_student', 'les_java_basics_1_3', 'celsius-to-fahrenheit', 'int celsius = 25;
double fahrenheit = celsius * 9.0 / 5 + 32;', 1, 2, '2026-09-05T06:04:00.410Z', '2026-09-05T06:04:00.410Z'),
('usr_student', 'les_java_basics_1_3', 'fix-score-type', 'int score = 95;
System.out.println("Score: " + score);', 1, 2, '2026-09-05T06:04:00.410Z', '2026-09-05T06:04:00.410Z'),
('usr_student', 'les_java_basics_2_1', 'average-three', 'int a = 7;
int b = 8;
int c = 10;
double average = (a + b + c) / 3.0;', 1, 2, '2026-09-07T06:04:00.410Z', '2026-09-07T06:04:00.410Z'),
('usr_student', 'les_java_basics_2_1', 'digit-sum', 'int number = 472;
int sum = 0;

sum += number % 10;
number /= 10;
sum += number % 10;
number /= 10;
sum += number % 10;', 1, 2, '2026-09-07T06:04:00.410Z', '2026-09-07T06:04:00.410Z'),
('usr_student', 'les_java_basics_2_1', 'fix-integer-average', 'int a = 3;
int b = 4;
double average = (a + b) / 2.0;
System.out.println(average);', 1, 2, '2026-09-07T06:04:00.410Z', '2026-09-07T06:04:00.410Z');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_java_basics_1', 'usr_seed00000q', 'crs_java_basics', 5, 'Helped me land an ML role', 'I was a backend engineer trying to move into ML. This course gave me the vocabulary and the hands-on confidence to pass technical interviews. Highly recommended.', '2026-08-26T02:04:00.410Z', '2026-08-26T02:04:00.410Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000q');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_java_basics_2', 'usr_seed00000v', 'crs_java_basics', 5, 'Clear explanations', 'The visual explanations of difficult concepts are the best I''ve seen. Code is clean and modern. Updated content too, which matters a lot in this field.', '2026-10-19T17:04:00.410Z', '2026-10-19T17:04:00.410Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000v');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_java_basics_3', 'usr_seed000013', 'crs_java_basics', 5, 'Dense but fantastic', 'This is not a fluffy overview — it goes deep. Expect to pause and re-watch, but the payoff is real. The instructor clearly knows the material at a research level.', '2026-10-16T14:04:00.410Z', '2026-10-16T14:04:00.410Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000013');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_java_basics_4', 'usr_seed00002a', 'crs_java_basics', 5, 'Best course I''ve taken on the topic', 'The explanations build intuition before the math, and every concept is backed by code you actually run. I finally understand what''s happening under the hood instead of copying snippets.', '2026-08-02T23:04:00.410Z', '2026-08-02T23:04:00.410Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002a');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_java_basics_5', 'usr_seed00002i', 'crs_java_basics', 4, 'Solid and practical', 'Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I''d take another course from this instructor.', '2026-09-03T16:04:00.410Z', '2026-09-03T16:04:00.410Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002i');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_java_basics_6', 'usr_seed00002k', 'crs_java_basics', 4, 'Finally clicked', 'I''d tried learning this from scattered blog posts and papers. Having a single coherent narrative with good visuals made it click. The capstone tied everything together.', '2026-10-14T13:04:00.410Z', '2026-10-14T13:04:00.410Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002k');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_java_basics_7', 'usr_seed00003z', 'crs_java_basics', 5, 'Dense but fantastic', 'This is not a fluffy overview — it goes deep. Expect to pause and re-watch, but the payoff is real. The instructor clearly knows the material at a research level.', '2026-10-20T19:04:00.410Z', '2026-10-20T19:04:00.410Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00003z');

UPDATE courses SET rating_avg = coalesce((SELECT avg(rating) FROM reviews WHERE course_id = 'crs_java_basics'), 0), rating_count = (SELECT count(*) FROM reviews WHERE course_id = 'crs_java_basics') WHERE id = 'crs_java_basics';
