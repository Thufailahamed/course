DELETE FROM exercise_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_c_basics');

DELETE FROM quiz_attempts WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_c_basics');

DELETE FROM notes WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_c_basics');

DELETE FROM lesson_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_c_basics');

DELETE FROM discussions WHERE course_id = 'crs_c_basics';

DELETE FROM certificates WHERE course_id = 'crs_c_basics';

DELETE FROM enrollments WHERE course_id = 'crs_c_basics';

DELETE FROM reviews WHERE course_id = 'crs_c_basics';

DELETE FROM wishlist WHERE course_id = 'crs_c_basics';

DELETE FROM path_courses WHERE course_id = 'crs_c_basics';

DELETE FROM coupons WHERE course_id = 'crs_c_basics';

DELETE FROM lessons WHERE course_id = 'crs_c_basics';

DELETE FROM sections WHERE course_id = 'crs_c_basics';

UPDATE order_items SET course_id = NULL WHERE course_id = 'crs_c_basics';

DELETE FROM courses WHERE id = 'crs_c_basics';

INSERT OR IGNORE INTO categories (id, slug, name, description, icon, sort_order) VALUES ('cat_programming', 'programming', 'Programming', 'Python from first principles: core language, clean code and real projects.', 'code', 9);

INSERT INTO courses (id, slug, title, subtitle, description, category_id, instructor_id, level, language, price_cents, compare_at_price_cents, currency, thumbnail_key, preview_video_url, accent, status, featured, what_you_learn, requirements, target_audience, tags, duration_minutes, lessons_count, rating_avg, rating_count, students_count, published_at, created_at, updated_at) VALUES
('crs_c_basics', 'c-basics', 'C Basics: The Interactive Course', 'Learn C from your first printf to pointers, memory and structs. Predict what real C code does before you compile it.', 'C is the language underneath almost everything: operating systems, databases, game engines and the firmware in the devices around you. It is small, fast and honest. It also expects you to understand what the machine is doing. This course teaches that understanding from the first line.

## Predict first, then compile

Every lesson is interactive. Most of its examples are **predict-the-output questions**: you read a short C program, choose what it prints, and only then see the explanation. Reasoning about code before you run it is the habit that separates careful C programmers from frustrated ones.

- **Real C, not pseudo-code.** Every example is a complete, standard C program you can compile unchanged.
- **Explanations that teach the rule.** Each answer explains the underlying behavior, such as integer division, operator precedence or what `sizeof` measures, so the same mistake is hard to repeat.
- **Checkpoint quizzes** after each section, with a written explanation for every answer.
- **Three capstone projects** built step by step: a grade report, a contact book that saves to a file, and a word-statistics tool.

## Run it on your own machine

The lessons are written so you can compile and run every program with gcc or clang. Lesson 01 shows how to install a compiler on Windows, macOS or Linux in a few minutes. Your browser shows the code and checks your reasoning. Your terminal proves it.

## From the first printf to real memory

You will start with variables, types and `printf`, then move through decisions, loops, functions and arrays. The middle of the course is pointers, the idea that unlocks C. You finish with structs, the preprocessor and file I/O, and you leave able to read most C code you come across.

## Built for what comes next

This course is the foundation for **C Advanced**, which covers dynamic data structures, undefined behavior, sanitizers and secure coding, and for any systems course that follows.', 'cat_programming', 'usr_arjun', 'beginner', 'English', 0, NULL, 'USD', NULL, NULL, 25, 'published', 1, '["Write, compile and run small C programs with gcc or clang, and read compiler errors with confidence","Choose the right types, control integer and floating-point behavior, and write clear expressions","Control program flow with if, switch and loops, and structure code with functions and scope","Work with arrays and strings the way C does, including the null terminator and the standard string functions","Understand pointers, pointer arithmetic and dynamic memory, the features that make C both powerful and unforgiving","Model data with structs, enums and unions, split code with the preprocessor, and read and write files safely"]', '["No programming experience needed. We start from a blank file and build up","A C compiler on your computer for the optional run-it-yourself steps: gcc or clang. Lesson 01 shows how to install one"]', '["Complete beginners who want to learn the language that most operating systems, databases and embedded devices are written in","Students preparing for systems programming, operating systems or computer architecture courses","Programmers moving from Python, Java or JavaScript who need to understand memory and types","Engineers who work near hardware and want to read C code confidently"]', '["C","Interactive","Programming","Beginner","Systems"]', 506, 30, 0, 0, 0, '2025-08-18T06:04:00.699Z', '2025-07-19T06:04:00.699Z', '2026-10-13T06:04:00.699Z');

INSERT INTO sections (id, course_id, title, position, created_at) VALUES
('sec_c_basics_1', 'crs_c_basics', 'Getting Started', 0, '2026-06-25T06:04:00.699Z'),
('sec_c_basics_2', 'crs_c_basics', 'Numbers & Operators', 1, '2026-06-25T06:04:00.699Z'),
('sec_c_basics_3', 'crs_c_basics', 'Making Decisions & Repeating', 2, '2026-06-25T06:04:00.699Z'),
('sec_c_basics_4', 'crs_c_basics', 'Functions & Arrays', 3, '2026-06-25T06:04:00.699Z'),
('sec_c_basics_5', 'crs_c_basics', 'Pointers & Memory', 4, '2026-06-25T06:04:00.699Z'),
('sec_c_basics_6', 'crs_c_basics', 'Structs, Files & the Preprocessor', 5, '2026-06-25T06:04:00.699Z'),
('sec_c_basics_7', 'crs_c_basics', 'Capstone Projects', 6, '2026-06-25T06:04:00.699Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_c_basics_1_1', 'sec_c_basics_1', 'crs_c_basics', 'How this course works and setting up a C compiler', 'interactive', 0, 600, NULL, NULL, 'C is the language that most of the software you use every day is built on. The kernel that runs your phone, the database behind your favourite app, the firmware in your microwave: many of them are written in C, because C gives you direct control over memory and the machine underneath. It is also a language that rewards care. It will not hold your hand, and that is exactly why people who learn it well understand computers deeply.

This course takes you from a blank file to small real programs. You will learn the syntax, the types, the memory model and the habits that experienced C programmers rely on.

## How this course works

Each lesson mixes three things:

- **Short explanations.** We build intuition first, then state the precise rule.
- **Complete programs.** Every example is a whole C file that compiles on its own, not a fragment you have to guess about.
- **Predict-the-output questions.** Before the answer is revealed, you choose what the program prints. Each question has an explanation that teaches the rule behind the answer. Treat these as the heart of the course. If you get one wrong, you have found something worth understanding.

Here is a question you will see in the next lesson, so you know what to expect:

```c predict id=preview-question title="What does this print?"
#include <stdio.h>

int main(void) {
    printf("C");
    printf("!\n");
    return 0;
}
--- options
C !
* C!
C
!C
--- explain
Each `printf` writes exactly what you tell it to and nothing more. There is no automatic space and no automatic newline, so the two calls join into one line: `C!` followed by a newline.
```

> **Tip:** Answer before you reveal. The attempt is where the learning happens, even when you are wrong.

## Get a C compiler

C is compiled. You write source code in a text file, a compiler turns it into a program, and then you run that program. Install one of the following, then check it works.

**Windows.** Install MinGW-w64 or use the Microsoft Visual Studio Build Tools with `cl`. Most learners find it easiest to install **MSYS2** and then run `pacman -S mingw-w64-ucrt-x86_64-gcc` from its terminal.

**macOS.** Run `xcode-select --install`. It installs `clang`, which is fully compatible with the examples here.

**Linux.** Install gcc with your package manager, for example `sudo apt install build-essential` on Debian and Ubuntu.

Confirm the installation from a terminal:

```bash
gcc --version
```

Every run-it-yourself step in this course uses this command pattern, where `hello.c` is your source file:

```bash
gcc -std=c11 -Wall -Wextra -pedantic hello.c -o hello
./hello
```

The flags are worth understanding from day one. `-std=c11` selects the standard, `-Wall -Wextra` asks the compiler to warn about suspicious code, and `-pedantic` keeps you to the standard. On Windows the program is called `hello.exe`, and you run it with `hello` or `.\hello`.

> **Pitfall:** Treat every warning as an error to fix, not noise to ignore. Many of the bugs in this course, such as using a variable before it has a value, are warnings first.

## What you will be able to do

By the end of the course you will write programs that read input, make decisions, loop over data, use functions, store collections in arrays and strings, follow pointers through memory, and save records to a file. Every concept comes with a predict question so you can check your reasoning before you compile.

## Recap

- C is compiled. A compiler such as `gcc` or `clang` turns your source file into a program you run.
- Install a compiler once, then use the same `gcc -std=c11 -Wall -Wextra -pedantic` command for every program.
- Predict-the-output questions are the core of each lesson. Answer first, then read the explanation.
- Read compiler warnings as signals, not noise.
- Every example is a complete program, so you can always run exactly what you see.

**Up next:** your first program, and how `printf` turns a line of code into output.
', 1, '[]', '[{"title":"cppreference: C language","url":"https://en.cppreference.com/w/c"},{"title":"GCC: installing and using the compiler","url":"https://gcc.gnu.org/onlinedocs/"},{"title":"Learn C (Stanford CS Education Library)","url":"https://cs.stanford.edu/people/eroberts/courses/cs107/"}]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_1_2', 'sec_c_basics_1', 'crs_c_basics', 'Your first program: main, printf and the compile-run cycle', 'interactive', 1, 960, NULL, NULL, 'Every C program starts at the same place, a function called `main`. When you run a program, the operating system calls `main`, your code runs from top to bottom, and the value `main` returns tells the system whether things went well. Before we look at that, let''s look at the simplest useful program you can write.

## The anatomy of a C program

```c
#include <stdio.h>

int main(void) {
    printf("Hello, world!\n");
    return 0;
}
```

Each line has a job:

- `#include <stdio.h>` brings in the declarations for input and output, including `printf`. The `#` marks a preprocessor directive, which you will meet properly later.
- `int main(void)` starts the program. `int` says `main` returns an integer, and `void` says it takes no arguments.
- `printf("Hello, world!\n");` prints text. The `\n` is an escape sequence that means "new line".
- `return 0;` reports success to the operating system. By convention, `0` means success and any other value means something went wrong.

> **Pitfall:** C is case-sensitive, and every statement ends with a semicolon. `Printf` and a missing `;` are two of the most common first-day errors.

## printf: formatted output

`printf` writes text to the screen. It prints exactly what you ask for and nothing more. It never adds a space, and it never adds a newline on its own. That is the first thing to remember, and the first predict question below tests it.

```c predict id=hello-newline title="Where does the line break go?"
#include <stdio.h>

int main(void) {
    printf("Hello");
    printf("World\n");
    return 0;
}
--- options
Hello World
Hello
World
* HelloWorld
--- explain
Nothing is printed between the two calls, so `Hello` and `World` join into `HelloWorld`. The `\n` appears only in the second call and ends that line. Only what you write, and where you write it, is printed.
```

`printf` also understands format specifiers, which start with `%`. You will use them constantly:

| Specifier | Prints |
|---|---|
| `%d` | a signed integer (`int`) |
| `%f` | a floating-point number (`double`) |
| `%c` | a single character |
| `%s` | a string (text) |
| `%%` | a literal percent sign |

```c
#include <stdio.h>

int main(void) {
    int age = 21;
    printf("You are %d years old. Use %% wisely.\n", age);
    return 0;
}
```

Each specifier consumes one of the values after the format string, in order. If the types don''t match the specifier, the result is undefined, so always keep them in step.

## Comments

Comments explain intent to the next reader, which is often you. C has two forms:

```c
// A single-line comment, from // to the end of the line.

/* A block comment can
   span several lines. */
```

> **Tip:** Write comments that explain why, not what. `// add the bonus` is less useful than `// the bonus applies only to paid members`.

## Compiling and running

Save the program above as `hello.c`, then compile and run it:

```bash
gcc -std=c11 -Wall -Wextra -pedantic hello.c -o hello
./hello
```

The `-o hello` option names the output program. If compilation fails, the compiler points at a file, a line and a problem. Read the first error first, because later errors are often caused by it.

## Reading an error

Here is a deliberate mistake. Look at the message, then the prediction.

```c predict id=missing-semicolon title="What happens when you compile this?"
#include <stdio.h>

int main(void) {
    printf("Hi")
    return 0;
}
--- options
* A compile error about the missing semicolon
Hi
Hi, then a crash
A warning, then Hi
--- explain
The compiler reads `printf("Hi")` and then finds `return` where it expected the end of a statement. It stops with an error such as `expected '';'' before ''return''`. Nothing runs, because a program that does not compile never becomes a program at all.
```

The second predict question checks how `return` reaches the operating system:

```c predict id=return-status title="What is printed, and what is the exit status?"
#include <stdio.h>

int main(void) {
    printf("Done\n");
    return 3;
}
--- options
* Done
Nothing printed
Done twice
Done, then an error message
--- explain
The program prints `Done`, then returns `3` from `main`. The printed text is the only visible output, but the exit status `3` is still reported to the operating system. The operating system receives `3` as the exit status. Scripts use this number to decide whether a program succeeded. On Linux and macOS you can see it with `echo $?`, and on Windows with `echo %errorlevel%` in cmd.
```

> **In the wild:** Build tools and continuous integration systems check exit statuses to decide whether to keep going. A program that prints an error but returns `0` looks like a success to them.

## Recap

- Every program has a `main` function, and the program runs from there.
- `#include <stdio.h>` gives you `printf`. The `#` line is a preprocessor directive.
- `printf` prints only what you ask for. Add `\n` yourself to end a line.
- Format specifiers such as `%d`, `%f`, `%c` and `%s` must match the value''s type.
- `return 0;` reports success. Any other value reports a problem.
- Read the first compiler error, and fix it before the rest.

**Up next:** variables and the basic types that hold their values.
', 1, '[]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_1_3', 'sec_c_basics_1', 'crs_c_basics', 'Variables, basic types and sizeof', 'interactive', 2, 960, NULL, NULL, 'A variable is a named place in memory that holds a value. In C you must say what kind of value it holds before you use it, and that decision shapes everything the variable can do. Choose the wrong type and the program still compiles, but it quietly computes something else.

## Declaring and initializing

A declaration gives a variable a type and a name. Initializing it gives the variable its first value:

```c
int count = 3;          // declare and initialize
double price;           // declare only
price = 4.50;           // assign later
```

> **Pitfall:** A variable declared without an initial value holds whatever bytes were already in that memory. Reading it before assigning it is undefined behavior, and compilers warn about it for good reason. Always initialize your variables.

## The basic types

These are the types you will use most often:

| Type | Typical size | Holds |
|---|---|---|
| `char` | 1 byte | a single character, or a small integer |
| `int` | 4 bytes | a whole number, usually from about −2 billion to +2 billion |
| `long` | 4 or 8 bytes | a larger whole number |
| `float` | 4 bytes | a decimal number with about 7 significant digits |
| `double` | 8 bytes | a decimal number with about 15 significant digits |

The sizes are typical rather than guaranteed. The C standard sets minimum ranges and a size order (`char` is no larger than `short`, which is no larger than `int`, and so on), and the real sizes depend on the platform. That is why C gives you `sizeof`.

## sizeof

`sizeof` returns the size of a type or variable, in bytes. It is evaluated at compile time, and its result has the type `size_t`, which you print with `%zu`.

```c predict id=sizeof-char-int title="How many bytes?"
#include <stdio.h>

int main(void) {
    char letter = ''A'';
    printf("%zu %zu\n", sizeof letter, sizeof(int));
    return 0;
}
--- options
* 1 4
1 1
4 4
2 4
--- explain
A `char` is exactly one byte by definition, so `sizeof letter` is `1`. An `int` is four bytes on most common platforms, and `sizeof(int)` reports that number. The second value is platform-dependent in principle, but `4` is the usual result on desktop systems.
```

## Characters and their codes

A `char` stores a small integer, and that integer is the character''s code. The character `''A''` is stored as the number `65` in the ASCII encoding. You can use a `char` in arithmetic, which is handy and surprising at the same time.

```c predict id=char-arithmetic title="What does this print?"
#include <stdio.h>

int main(void) {
    char c = ''A'';
    printf("%c %d\n", c, c + 1);
    return 0;
}
--- options
* A 66
A 65
65 66
B 66
--- explain
`c` holds the code 65 for `''A''`. The `%c` specifier prints it as the character `A`. `c + 1` is the integer `66`, which `%d` prints as a number. Adding 1 to a letter''s code gives the next letter, which is how many character-processing programs work.
```

> **Tip:** Use single quotes for characters (`''A''`) and double quotes for strings (`"A"`). The first is one `char`. The second is an array of two characters, `''A''` followed by a terminator.

## Naming and reading code

Good names make code easier to read. Use lowercase words separated by underscores, such as `total_score`, and pick names that say what a value means, not just what type it is. `count` says more than `i` when the value is a number of students.

## Assignment and conversion

Assignment copies a value into a variable. If the value''s type differs from the variable''s type, C converts it, and sometimes that conversion loses information.

```c predict id=float-to-int title="What does this print?"
#include <stdio.h>

int main(void) {
    double price = 9.99;
    int whole = price;
    printf("%d\n", whole);
    return 0;
}
--- options
* 9
10
9.99
0
--- explain
Converting a floating-point value to an integer throws away the fractional part. C truncates toward zero, so `9.99` becomes `9`, not `10`. Rounding is something you request explicitly, for example with `round()` from `<math.h>`.
```

> **In the wild:** Silent truncation like this is behind many real bugs, such as a price stored as an integer of cents that gets rounded down. Choose the type that matches the meaning of the data, and convert on purpose.

## A worked example

Here is a complete program that uses several types together:

```c
#include <stdio.h>

int main(void) {
    int students = 24;
    double total_points = 1842.5;
    double average = total_points / students;

    printf("Students: %d\n", students);
    printf("Average: %.2f\n", average);
    return 0;
}
```

`%.2f` prints a `double` with two digits after the decimal point. You will see format specifiers in detail in lesson 06.

## Recap

- A variable has a type, a name and a value. Declare it, then initialize it.
- Always give variables a starting value. Reading an uninitialized variable is undefined behavior.
- `int` holds whole numbers, `double` holds decimals, and `char` holds small codes such as letters.
- `sizeof` gives sizes in bytes and returns a `size_t`, printed with `%zu`.
- Converting a `double` to an `int` truncates the fraction.

**Up next:** integers, floating-point numbers and the traps between them.
', 0, '[]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_1_4', 'sec_c_basics_1', 'crs_c_basics', 'Checkpoint: getting started', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"Which statement correctly declares an integer variable named `count` and gives it the value 3?","options":["count int = 3;","int count = 3;","int count := 3;","let count = 3;"],"answerIndex":1,"explanation":"In C the type comes first, then the name, then the initializer after `=`. `let` and `:=` belong to other languages, and `count int` puts the parts in the wrong order."},{"id":"q2","prompt":"What is the exit status of a program whose `main` ends with `return 0;`?","options":["1, meaning the program ran","0, meaning success","-1, meaning the program never finished","It depends on how many lines were printed"],"answerIndex":1,"explanation":"By convention, `0` returned from `main` reports success to the operating system, and any non-zero value reports a problem. Scripts and build tools rely on that convention."},{"id":"q3","prompt":"Why does `printf(\"Hi\"); printf(\"There\\n\");` print `HiThere` on one line?","options":["printf adds a space between calls","printf adds a newline after each call","printf prints only what you ask for, and only `\\n` ends a line","The second call overwrites the first"],"answerIndex":2,"explanation":"`printf` never adds spaces or newlines on its own. Each call writes exactly its format string, so text from two calls joins together unless you include `\\n`."},{"id":"q4","prompt":"What does `sizeof(char)` evaluate to on every conforming C compiler?","options":["1","2","4","It varies by machine"],"answerIndex":0,"explanation":"The standard defines `char` as one byte, and `sizeof` measures in bytes, so `sizeof(char)` is always `1`. The size of `int`, by contrast, depends on the platform."},{"id":"q5","prompt":"What happens when you read a local `int` variable that you declared but never assigned?","options":["It always holds 0","It holds whatever bytes were in that memory, and the behavior is undefined","The compiler stops with an error","It holds the last value any other variable had"],"answerIndex":1,"explanation":"Local variables are not initialized automatically, so their value is indeterminate. Reading one is undefined behavior. Initialize every variable when you declare it, and compilers will warn you when you forget."}]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_2_1', 'sec_c_basics_2', 'crs_c_basics', 'Integers, floating point and the traps between them', 'interactive', 0, 1080, NULL, NULL, 'Numbers look simple until a computer stores them. An `int` has a fixed number of bits, so it cannot hold every whole number, and a `double` cannot hold every decimal exactly. Most numeric bugs in C come from forgetting one of those two facts. This lesson makes both facts concrete, so the surprises stop being surprises.

## Integers have a fixed range

A signed `int` on a typical system uses 32 bits. It can hold values from about −2 billion to +2 billion. An `unsigned int` uses the same bits to hold only non-negative values, which roughly doubles its positive range and changes how wraparound behaves.

Unsigned arithmetic wraps around. When a result is too big or too small for the type, it is reduced modulo 2ⁿ, where n is the number of bits. That behavior is guaranteed by the standard, so you can rely on it.

```c predict id=unsigned-wrap title="What does this print?"
#include <stdio.h>

int main(void) {
    unsigned int n = 0;
    n = n - 1;
    printf("%u\n", n);
    return 0;
}
--- options
* 4294967295
-1
0
1
--- explain
Subtracting 1 from the unsigned value 0 wraps around to the largest value the type can hold. On systems where `unsigned int` is 32 bits, that is 2³² − 1, which is 4294967295. Unsigned types never become negative. This is why you must be careful when you subtract unsigned values, such as sizes or counts, in loops.
```

The same modular rule applies to narrow types. A `char` or `unsigned char` assigned a value outside its range is reduced the same way.

```c predict id=unsigned-char title="What does this print?"
#include <stdio.h>

int main(void) {
    unsigned char b = 300;
    printf("%d\n", b);
    return 0;
}
--- options
* 44
300
0
255
--- explain
An `unsigned char` holds 8 bits, so it can represent 0 to 255. The value 300 wraps around to 300 − 256 = 44. Compilers often warn about this, and they are right to.
```

> **Pitfall:** Signed integer overflow is different. It is undefined behavior, so the compiler may assume it never happens. Never rely on a signed `int` wrapping around.

## Division truncates

When both operands are integers, `/` discards the fraction. The `%` operator returns the remainder. With negative numbers, C99 and later round the quotient toward zero, so the remainder takes the sign of the dividend.

```c predict id=negative-division title="What does this print?"
#include <stdio.h>

int main(void) {
    printf("%d %d\n", -7 / 2, -7 % 2);
    return 0;
}
--- options
* -3 -1
-4 1
-3 1
-4 -1
--- explain
Division truncates toward zero, so `-7 / 2` is `-3`, not `-4`. The remainder satisfies `(a / b) * b + a % b == a`, which gives `-7 % 2 == -1`. Most languages behave this way, but some use floor division, so check the rules before you compare code across languages.
```

## Floating-point numbers are approximations

A `double` stores a number as a binary fraction with about 15 to 17 significant decimal digits. Many decimal values, such as `0.1`, cannot be represented exactly in binary, so the stored value is the closest one the format allows. Arithmetic on those values can produce results that look wrong.

```c predict id=float-equal title="What does this print?"
#include <stdio.h>

int main(void) {
    double total = 0.1 + 0.2;
    printf("%s\n", total == 0.3 ? "equal" : "not equal");
    return 0;
}
--- options
* not equal
equal
0.3
0.30000000000000004
--- explain
Neither `0.1` nor `0.2` is exact in binary, so their sum is slightly larger than the closest double to `0.3`. The `==` test therefore fails. Never compare floating-point numbers with `==` directly. Compare the difference with a small tolerance, such as `fabs(a - b) < 1e-9`, using `<math.h>`.
```

> **Tip:** Use `double` for most decimal work. `float` has about seven significant digits, which runs out quickly.

## Converting between types

When you mix types in an expression, C converts the operands to a common type before it operates on them. An `int` mixed with a `double` becomes a `double`, which is why `total / count` gives a decimal result when `total` is a `double`. Converting in the other direction discards information, as lesson 03 showed.

To make the conversion explicit, use a cast:

```c
#include <stdio.h>

int main(void) {
    int total = 17;
    int count = 4;

    printf("integer: %d\n", total / count);             /* 4 */
    printf("decimal: %.2f\n", (double)total / count);   /* 4.25 */
    return 0;
}
```

The cast `(double)total` converts the value before the division, so the division happens in floating point. Casting after the division would be too late, because the fraction is already gone.

## Recap

- An `int` has a fixed range. Unsigned types wrap around, and signed overflow is undefined behavior.
- Integer division truncates toward zero, and `%` gives the remainder.
- A `double` stores approximations, so compare decimal results with a tolerance rather than `==`.
- Mixed-type arithmetic converts to a common type. Use an explicit cast when the conversion matters.

**Up next:** operators, precedence and the short-circuit rules that keep your conditions safe.
', 0, '[]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_2_2', 'sec_c_basics_2', 'crs_c_basics', 'Operators, precedence and short-circuit evaluation', 'interactive', 1, 1080, NULL, NULL, 'Operators combine values into new values. You already use `+` and `=` without thinking. This lesson covers the rest of the everyday set, the precedence rules that decide what an expression means, and the short-circuit behavior that lets you write safe conditions.

## Arithmetic and assignment

The arithmetic operators are `+`, `-`, `*`, `/` and `%`. Compound assignment operators such as `+=` update a variable in place, so `total += 5` means `total = total + 5`.

```c
int score = 10;
score += 5;     /* 15 */
score *= 2;     /* 30 */
score -= 6;     /* 24 */
```

## Increment and decrement

`++` adds one and `--` subtracts one. Their position matters. Written before the variable, the operator changes the value first and then yields the new value. Written after, it yields the old value and then changes the variable.

```c predict id=pre-post title="What does this print?"
#include <stdio.h>

int main(void) {
    int i = 5;
    int a = i++;
    int b = ++i;
    printf("%d %d %d\n", a, b, i);
    return 0;
}
--- options
* 5 7 7
5 6 7
6 7 7
5 6 6
--- explain
`i++` yields 5 and then makes `i` equal to 6, so `a` is 5. `++i` makes `i` equal to 7 first and yields 7, so `b` is 7. Both statements are simple enough to read clearly. Put increments in their own statements unless the combined form is clearly easier to read.
```

> **Pitfall:** Never change the same variable twice in one expression, such as `i = i++ + i`. The result is undefined behavior, because the order of those changes is not fixed.

## Comparison and logic

The comparison operators are `==`, `!=`, `<`, `<=`, `>` and `>=`. Each yields `1` for true or `0` for false. The logical operators `&&` (and), `||` (or) and `!` (not) combine those results.

> **Pitfall:** `=` assigns and `==` compares. `if (x = 0)` compiles, because assignment is an expression, and it quietly assigns zero. You will see that bug in lesson 07.

## Precedence

Operators have precedence, which decides the order in which they are applied. Multiplication binds tighter than addition, and most operators are applied left to right. When you are unsure, add parentheses. They cost nothing and make intent obvious.

```c predict id=precedence title="What does this print?"
#include <stdio.h>

int main(void) {
    int r = 2 + 3 * 4 - 6 / 2;
    printf("%d\n", r);
    return 0;
}
--- options
* 11
20
9
8
--- explain
Multiplication and division happen first: `3 * 4` is 12 and `6 / 2` is 3. Then addition and subtraction run from left to right: `2 + 12 - 3` is 11. Reading the expression as `((2 + (3 * 4)) - (6 / 2))` shows the same order. Parentheses are a tool for clarity, not a sign of weakness.
```

## Short-circuit evaluation

`&&` and `||` evaluate their right side only when the left side does not already decide the answer. That behavior is called short-circuiting, and you can use it to avoid errors. In `a && b`, if `a` is false, `b` never runs. In `a || b`, if `a` is true, `b` never runs.

```c predict id=short-circuit title="What does this print?"
#include <stdio.h>

int main(void) {
    int x = 0;
    if (x != 0 && 10 / x > 1) {
        printf("big\n");
    } else {
        printf("small\n");
    }
    return 0;
}
--- options
* small
big
The program crashes on division by zero
big small
--- explain
Because `x != 0` is false, the `&&` already has its answer and never evaluates `10 / x`. The division by zero is never attempted, so the program takes the `else` branch and prints `small`. Put the cheap or safe check first, and let the risky check run only when it is needed.
```

> **In the wild:** Null-pointer checks depend on this rule. Writing `if (p != NULL && p->value > 0)` is safe, because the dereference runs only when `p` is not null.

## The conditional operator

The conditional operator `? :` picks one of two values. It is a compact `if`/`else` for expressions:

```c
int n = -4;
const char *sign = n >= 0 ? "non-negative" : "negative";
```

Use it for short, simple choices. If the choice needs a statement, use `if` instead.

## Recap

- Compound assignments such as `+=` update a variable in place.
- `i++` yields the old value, and `++i` yields the new one. Keep changes in separate statements.
- `=` assigns and `==` compares. Mixing them up is a classic bug.
- Precedence decides the order of operations. Add parentheses when you are unsure.
- `&&` and `||` short-circuit, so put the safe check first.

**Up next:** formatted output and safe input, the two ways your program talks to people.
', 0, '[]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_2_3', 'sec_c_basics_2', 'crs_c_basics', 'Formatted output and reading input safely', 'interactive', 2, 960, NULL, NULL, 'A program that cannot show results or accept input is not much of a program. In C, `printf` handles output and `scanf` handles input. Both are powerful, and both have sharp edges. This lesson shows you how to format output precisely, and how to read input without the classic traps.

## Formatting output

`printf` takes a format string and then the values to insert. Between the `%` and the letter you can add modifiers that control width, alignment and precision.

| Pattern | Meaning |
|---|---|
| `%5d` | right-align an integer in 5 columns |
| `%-5d` | left-align an integer in 5 columns |
| `%.2f` | show a `double` with two digits after the point |
| `%05d` | pad an integer with leading zeros to 5 digits |
| `%x` / `%o` | print an integer in hexadecimal or octal |

Width and alignment are how you print tidy tables, which is useful in almost every program you write.

```c predict id=format-width title="What does this print?"
#include <stdio.h>

int main(void) {
    printf("[%5d]|[%-5d]\n", 42, 42);
    return 0;
}
--- options
* [   42]|[42   ]
[42   ]|[   42]
[42]|[42]
[   42]|[   42]
--- explain
The first field is right-aligned in a width of 5, so it gets three leading spaces. The second is left-aligned, so it gets three trailing spaces. The `|` characters are ordinary text and print as they are.
```

Precision works on floating-point values:

```c predict id=precision title="What does this print?"
#include <stdio.h>

int main(void) {
    printf("%.2f\n", 2.0 / 3.0);
    return 0;
}
--- options
* 0.67
0.66
0.6667
0.7
--- explain
`2.0 / 3.0` is about 0.666666…. The `%.2f` specifier rounds to two decimal places, giving `0.67`. Rounding is applied to the displayed value, not to the stored one, and the stored value is unchanged.
```

Bases matter too. Hexadecimal is common when you look at memory, and the `%x` and `%o` specifiers print integers in those bases:

```c predict id=bases title="What does this print?"
#include <stdio.h>

int main(void) {
    printf("%x %o\n", 255, 8);
    return 0;
}
--- options
* ff 10
FF 8
255 8
ff 8
--- explain
255 is `ff` in hexadecimal, because 15 × 16 + 15 = 255. The number 8 is `10` in octal, because 1 × 8 + 0 = 8. The `%X` specifier, with a capital letter, prints uppercase digits instead.
```

> **Tip:** Make `printf` the place where formatting happens. Keep the numbers themselves as numbers until you print them, so you never lose precision by formatting too early.

## Reading input with scanf

`scanf` reads values from standard input, which is usually the keyboard. Every variable you give it must be passed by address, using `&`. Lesson 15 explains why, and for now it is enough to remember the rule.

```c
#include <stdio.h>

int main(void) {
    int age = 0;
    printf("How old are you? ");
    if (scanf("%d", &age) != 1) {
        printf("That was not a number.\n");
        return 1;
    }
    printf("In ten years you will be %d.\n", age + 10);
    return 0;
}
```

Notice the check on the return value. `scanf` returns the number of items it successfully read. If the user types `forty`, it returns `0` and leaves `age` alone. Ignoring that return value is how programs go wrong on bad input.

> **Pitfall:** `scanf("%s", buffer)` reads without any length limit, so a long input can overflow `buffer`. Prefer `fgets`, which takes a size, and parse the line yourself. You will use `fgets` in lesson 21.

> **Pitfall:** After `scanf("%d")`, the newline the user typed stays in the input. A later `%c` or `fgets` can read that newline immediately. Read whole lines with `fgets` when a program mixes the two.

## A small formatted report

Here is a complete program that uses width and precision together:

```c
#include <stdio.h>

int main(void) {
    const char *names[] = {"Ada", "Linus", "Grace"};
    double scores[] = {91.5, 78.25, 88.0};

    printf("%-8s|%8s\n", "Name", "Score");
    for (int i = 0; i < 3; i++) {
        printf("%-8s|%8.2f\n", names[i], scores[i]);
    }
    return 0;
}
```

The output lines up in columns no matter how long each name is, because the widths are fixed.

## Recap

- `printf` prints exactly what you ask for. Width, alignment and precision are part of the format string.
- `%x` and `%o` print integers in hexadecimal and octal.
- `scanf` needs addresses (`&`) and returns how many values it read. Check that return value.
- Avoid unbounded `%s` reads. Prefer `fgets` with a size limit.

**Up next:** making decisions with `if`, `else` and the ternary operator.
', 0, '[]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_2_4', 'sec_c_basics_2', 'crs_c_basics', 'Checkpoint: numbers & operators', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"What does `-7 / 2` evaluate to in C99 and later?","options":["-4","-3","-3.5","It depends on the compiler"],"answerIndex":1,"explanation":"Integer division truncates toward zero in C99 and later, so `-7 / 2` is `-3`. Floor division, which would give `-4`, is what some other languages do."},{"id":"q2","prompt":"Why should you not compare two `double` results with `==`?","options":["Because `==` only works on integers","Because many decimal values, such as 0.1, are stored as approximations, so tiny differences are common","Because the comparison always returns true","Because `double` values are always negative"],"answerIndex":1,"explanation":"Binary floating point cannot store many decimal values exactly. Two results that look equal can differ in the last bits, so compare the difference against a small tolerance instead."},{"id":"q3","prompt":"Given `int i = 5;`, what is the value of `i` after `int a = i++;`?","options":["5","6","4","It is undefined"],"answerIndex":1,"explanation":"The postfix `i++` yields the old value, 5, which is assigned to `a`, and then increments `i` to 6. Only the variable `i` ends up as 6."},{"id":"q4","prompt":"In `if (x != 0 && 100 / x > 2)`, what happens when `x` is 0?","options":["The division runs and the program crashes","The division is skipped because `&&` short-circuits","The condition is always true","The compiler rejects the program"],"answerIndex":1,"explanation":"When the left side of `&&` is false, the right side is never evaluated. That protects the division from running with a zero divisor."},{"id":"q5","prompt":"Which format specifier prints an `int` as an 8-character field, right-aligned with leading zeros?","options":["%-8d","%08d","%8.2d","%x8"],"answerIndex":1,"explanation":"`%08d` pads with leading zeros to a width of 8. `%-8d` left-aligns with trailing spaces, `%8.2d` is valid but pads with spaces and sets a minimum of two digits rather than zero padding, and `%x8` is not a valid pattern."}]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_3_1', 'sec_c_basics_3', 'crs_c_basics', 'Making decisions with if, else and the ternary operator', 'interactive', 0, 960, NULL, NULL, 'Programs become useful when they can choose. An `if` statement runs a block of code only when a condition is true, and `else` gives an alternative. Together they let one program behave differently for different inputs. This lesson covers the rules for conditions, the dangers that catch beginners, and the ternary operator for short choices.

## if and else

A condition is any expression. C treats `0` as false and any non-zero value as true, so there is no separate boolean type you must use, although `<stdbool.h>` provides `bool` if you prefer it.

```c
#include <stdio.h>

int main(void) {
    int temperature = 31;

    if (temperature > 30) {
        printf("Stay hydrated.\n");
    } else if (temperature < 10) {
        printf("Bring a jacket.\n");
    } else {
        printf("Enjoy the weather.\n");
    }
    return 0;
}
```

The `else if` chain checks conditions in order and runs the first block whose condition is true. Order matters: put the most specific checks first, and make sure the conditions do not overlap in a way that hides a case.

> **Tip:** Always use braces, even for a one-line body. Braces make the scope of the `if` obvious, and they stop a later edit from accidentally changing what runs.

## The dangling else

Without braces, an `else` attaches to the nearest `if`. That rule causes a famous bug, and it is worth seeing once.

```c predict id=dangling-else title="What does this print?"
#include <stdio.h>

int main(void) {
    int a = 1;
    int b = 0;
    if (a)
        if (b)
            printf("A");
        else
            printf("B");
    printf("C\n");
    return 0;
}
--- options
* BC
ABC
C
B
--- explain
The `else` belongs to the inner `if (b)`, not the outer `if (a)`, because it is the nearest one. Since `b` is 0, the `else` branch prints `B`. The outer `if` has no `else`, and the final `printf` prints `C` on the same line. Indentation does not change the meaning, which is exactly why you should use braces.
```

## Assignment in a condition

Assignment is an expression in C, and its value is the value assigned. That makes `=` in place of `==` a silent bug, because the code still compiles.

```c predict id=assign-in-if title="What does this print?"
#include <stdio.h>

int main(void) {
    int x = 5;
    if (x = 0)
        printf("yes\n");
    else
        printf("no %d\n", x);
    return 0;
}
--- options
* no 0
no 5
yes
yes 0
--- explain
`x = 0` stores 0 in `x`, and the value of that assignment is 0, which is false. So the `else` branch runs, and it prints the new value of `x`, which is 0. Most compilers warn about this when you enable `-Wall`, so read the warnings. Some programmers write `if (0 == x)` so that a missing `=` becomes a compile error.
```

## Nested conditions and clarity

Nested `if` statements are sometimes necessary, but deep nesting is hard to read. Two habits help. Return early from functions when a precondition fails, which keeps the main path flat. Give conditions names when they are complicated:

```c
int is_passing = score >= 50;
int has_attendance = attended >= 8;

if (is_passing && has_attendance) {
    printf("Certificate earned.\n");
}
```

## The ternary operator

The conditional operator `? :` chooses between two values. It works inside expressions, so you can use it where a full `if` would be clumsy.

```c predict id=ternary title="What does this print?"
#include <stdio.h>

int main(void) {
    int n = -4;
    printf("%s\n", n >= 0 ? "non-negative" : "negative");
    return 0;
}
--- options
* negative
non-negative
-4
zero
--- explain
The condition `n >= 0` is false, so the operator yields its second operand, `"negative"`. The ternary is an expression that yields one of two values, which is why it fits inside a `printf` call. Keep ternaries short. If one needs a comment to explain it, use an `if` statement instead.
```

## Checking your logic

A common pattern is to test a range. Write the two comparisons with `&&` so both must hold:

```c
int percent = 72;
if (percent >= 70 && percent < 80) {
    printf("Grade: C\n");
}
```

Checking the boundaries deliberately, such as 69, 70 and 79, catches most off-by-one mistakes before they reach users.

## Recap

- `if`, `else if` and `else` run exactly one branch. Order the checks from most specific to least.
- Zero is false and any other value is true.
- Always use braces, so `else` never attaches to the wrong `if`.
- `=` assigns and returns the assigned value. Check conditions for `=` where you meant `==`.
- The ternary `? :` yields one of two values and is ideal for short choices.

**Up next:** `switch`, which chooses among many fixed values, and the fallthrough behavior that trips up almost every beginner.
', 0, '[]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_3_2', 'sec_c_basics_3', 'crs_c_basics', 'switch, case and the fallthrough trap', 'interactive', 1, 960, NULL, NULL, 'When one value can match many fixed options, a long `if`/`else` chain gets tiring to read. The `switch` statement compares one integer expression against a list of constant `case` labels and jumps straight to the match. It is tidy and fast, and it has one behavior you must understand before you use it: once a case matches, execution keeps going into the next case unless you stop it.

## The basic shape

```c
#include <stdio.h>

int main(void) {
    char grade = ''B'';

    switch (grade) {
        case ''A'':
            printf("Excellent\n");
            break;
        case ''B'':
            printf("Good\n");
            break;
        case ''C'':
            printf("Satisfactory\n");
            break;
        default:
            printf("Needs review\n");
    }
    return 0;
}
```

The value in `switch (...)` is compared with each `case` label. Labels must be constant expressions known at compile time, such as literal numbers or characters. The `default` label runs when nothing else matches, and it is optional, although including it is a good habit.

## The fallthrough trap

Here is the important rule. Without a `break`, execution continues into the next `case`. Fallthrough is occasionally useful, but most of the time it is a bug.

```c predict id=switch-fallthrough title="What does this print?"
#include <stdio.h>

int main(void) {
    int day = 2;
    switch (day) {
        case 1:
            printf("one ");
        case 2:
            printf("two ");
        case 3:
            printf("three ");
            break;
        default:
            printf("other ");
    }
    printf("\n");
    return 0;
}
--- options
* two three
two
one two three
other
--- explain
`day` is 2, so execution starts at `case 2` and prints `two`. There is no `break` there, so it falls through to `case 3`, which prints `three` and then reaches a `break`. The `default` never runs. The line therefore reads `two three`, followed by a space and the newline from the last `printf`.
```

> **Pitfall:** Forgetting `break` is one of the most common C bugs. If you intend fallthrough, add a comment such as `/* falls through */` so the next reader knows it is deliberate. Compilers with `-Wextra` can warn about accidental fallthrough.

## Grouping cases on purpose

Deliberate fallthrough is the clean way to give several values the same behavior. Stack the labels with no code between them:

```c predict id=switch-grouping title="What does this print?"
#include <stdio.h>

int main(void) {
    int code = 4;
    switch (code) {
        case 1:
        case 2:
            puts("low");
            break;
        case 3:
        case 4:
        case 5:
            puts("mid");
            break;
        default:
            puts("high");
    }
    return 0;
}
--- options
* mid
low
high
mid low
--- explain
Labels with no statements between them all lead to the same code. `code` is 4, which matches the group `3, 4, 5`, so `puts` prints `mid` and the `break` leaves the switch. `puts` is a simpler way than `printf` to print a string followed by a newline.
```

## The default that ran

A `default` label is the catch-all, and it is a good place to handle unexpected input rather than silently ignoring it.

```c predict id=switch-default title="What does this print?"
#include <stdio.h>

int main(void) {
    char grade = ''z'';
    switch (grade) {
        case ''A'':
            printf("excellent\n");
            break;
        default:
            printf("unknown\n");
    }
    return 0;
}
--- options
* unknown
excellent
(nothing)
z
--- explain
No `case` label matches `''z''`, so control jumps to `default`, which prints `unknown`. The last `break` is optional here, because `default` is the final label. Adding it anyway protects you if someone later adds a case below it.
```

## Limits of switch

`switch` works only with integer types, including `char` and enumerated values, and only with constant case labels. It cannot compare strings or ranges. For a string, use `strcmp` and an `if` chain. For a range, use `if` with comparisons.

## Recap

- `switch` compares one integer value with constant `case` labels.
- Execution falls through to the next case unless a `break` stops it.
- Stacking labels with no code between them groups cases on purpose.
- Use `default` to handle values nothing else matched.
- `switch` cannot compare strings or ranges.

**Up next:** loops, which repeat a block while a condition holds.
', 0, '[]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_3_3', 'sec_c_basics_3', 'crs_c_basics', 'Loops: while, do-while and for', 'interactive', 2, 1080, NULL, NULL, 'Computers are good at repetition, and loops are how you ask for it. C has three loop forms. The `while` loop repeats while a condition is true, the `do`-`while` loop always runs its body at least once, and the `for` loop packs the start, the test and the step into one line. Most of the time you will reach for `for`, but understanding all three makes the choice obvious.

## while

A `while` loop checks its condition before every pass. If the condition is false from the start, the body never runs.

```c
#include <stdio.h>

int main(void) {
    int n = 3;
    while (n > 0) {
        printf("%d\n", n);
        n--;
    }
    printf("Liftoff!\n");
    return 0;
}
```

Every `while` loop needs a way to end. Forgetting to change the variable in the condition gives you an infinite loop, which hangs the program until you stop it.

```c predict id=while-countdown title="What does this print?"
#include <stdio.h>

int main(void) {
    int n = 3;
    while (n > 0) {
        printf("%d", n);
        n--;
    }
    printf("\n");
    return 0;
}
--- options
* 321
123
3210
21
--- explain
The loop prints `3`, then `2`, then `1`. When `n` becomes 0 the condition `n > 0` is false, so the loop stops before printing 0. The `printf` with `\n` then ends the line. Counting down to but not including the stop value is the most common loop shape.
```

## do-while

A `do`-`while` loop checks its condition after the body, so the body always runs at least once. Use it when you must do something before you can decide whether to repeat, such as asking for input until it is valid.

```c predict id=do-while-once title="What does this print?"
#include <stdio.h>

int main(void) {
    int n = 10;
    do {
        printf("%d ", n);
        n++;
    } while (n < 5);
    printf("end\n");
    return 0;
}
--- options
* 10 end
end
10 11 end
nothing
--- explain
The body runs first and prints `10`, then `n` becomes 11. The condition `n < 5` is false, so the loop ends. The body ran once even though the condition was false from the start. That single guaranteed pass is the whole point of `do`-`while`.
```

## for

A `for` loop has three parts separated by semicolons: an initialization, a condition and an update. Each part has a clear job, which is why `for` is the default choice for counting.

```c predict id=for-count title="What does this print?"
#include <stdio.h>

int main(void) {
    int total = 0;
    for (int i = 1; i <= 4; i++) {
        total += i;
    }
    printf("%d\n", total);
    return 0;
}
--- options
* 10
4
11
9
--- explain
The loop variable `i` starts at 1 and runs while `i <= 4`, so it takes the values 1, 2, 3 and 4. The total is 1 + 2 + 3 + 4, which is 10. Declaring `i` inside the `for` limits its scope to the loop, which is a good habit.
```

> **Tip:** Use `i <= n` or `i < n` deliberately. For a zero-based array of length `n`, the valid indexes are `0` to `n - 1`, so the condition is `i < n`.

## Choosing a loop

- Use `for` when you know the count or range in advance.
- Use `while` when you are waiting for a condition to change, such as reading input until a sentinel value arrives.
- Use `do`-`while` when the body must run at least once.

## Common mistakes

Two bugs account for most loop trouble. The first is the off-by-one error, where the condition stops one step too early or too late. The second is a missing update, which leaves the loop running forever. When a loop misbehaves, print the loop variable each time through the body. Watching the values will usually show you the bug in seconds.

## Recap

- `while` checks before each pass. `do`-`while` checks after, so its body runs at least once.
- `for` packs initialization, condition and update into one readable line.
- Declare the loop variable in the `for` so its scope stays small.
- Use `i < n` for zero-based indexes, and watch for off-by-one errors.
- Make sure every loop changes something that eventually ends it.

**Up next:** `break`, `continue` and nested loops, which let you change how a loop runs.
', 0, '[]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_3_4', 'sec_c_basics_3', 'crs_c_basics', 'break, continue and nested loops', 'interactive', 3, 960, NULL, NULL, 'Sometimes a loop should stop early, skip one pass, or sit inside another loop. The `break` and `continue` statements give you that control, and nested loops let you work with two dimensions, such as rows and columns. Used carefully, they make loops clearer. Used carelessly, they make them very hard to follow.

## break

`break` leaves the innermost loop or `switch` immediately. Execution continues with the statement after the loop.

```c
#include <stdio.h>

int main(void) {
    int numbers[] = {4, 9, 16, 25, 36};
    int target = 16;
    int found_at = -1;

    for (int i = 0; i < 5; i++) {
        if (numbers[i] == target) {
            found_at = i;
            break;
        }
    }
    printf("found at index %d\n", found_at);
    return 0;
}
```

This is a linear search. The `break` stops the loop as soon as the answer is known, so the rest of the array is never examined.

## continue

`continue` skips the rest of the current pass and moves to the next one. In a `for` loop, the update still runs before the next test.

```c predict id=continue-skip title="What does this print?"
#include <stdio.h>

int main(void) {
    for (int i = 0; i < 6; i++) {
        if (i % 2 == 0) continue;
        printf("%d", i);
    }
    printf("\n");
    return 0;
}
--- options
* 135
024
12345
246
--- explain
When `i` is even, `i % 2 == 0` is true, so `continue` skips the `printf` and the loop moves on. Only the odd values 1, 3 and 5 reach the `printf`. The output is `135` followed by a newline.
```

> **Tip:** `continue` works well as a guard at the top of a loop body, which keeps the main logic unindented. Use it to reject cases you do not care about.

## Nested loops

A loop inside another loop runs the inner loop completely for each pass of the outer one. That is how you walk a grid, compare every pair of items, or print a table.

```c
#include <stdio.h>

int main(void) {
    for (int row = 1; row <= 3; row++) {
        for (int col = 1; col <= 3; col++) {
            printf("%3d", row * col);
        }
        printf("\n");
    }
    return 0;
}
```

The inner loop finishes all its columns before the outer loop moves to the next row. Printing the result shows a 3 by 3 multiplication table.

## break only leaves one loop

This is the subtle point. A `break` inside an inner loop stops only that inner loop, and the outer loop carries on.

```c predict id=nested-break title="What does this print?"
#include <stdio.h>

int main(void) {
    int count = 0;
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            if (j == 1) break;
            count++;
        }
    }
    printf("%d\n", count);
    return 0;
}
--- options
* 3
6
1
9
--- explain
For each of the three values of `i`, the inner loop counts `j = 0` and then breaks when `j` reaches 1. That is one count per outer pass, so the total is 3. The `break` never stops the outer loop. If you need to leave both loops, use a flag, or move the loops into a function and `return`.
```

## After the loop

The loop variable declared in a `for` is gone once the loop ends. If you want to use the value afterwards, declare it before the loop. Here, `i` is still alive after the loop, so the program can report where the loop stopped.

```c predict id=loop-after title="What does this print?"
#include <stdio.h>

int main(void) {
    int i;
    for (i = 0; i < 4; i++) {
        if (i == 2) break;
    }
    printf("%d\n", i);
    return 0;
}
--- options
* 2
3
4
1
--- explain
The variable `i` is declared before the loop, so it survives. The loop breaks when `i` reaches 2, before the increment would make it 3. The `printf` shows `2`. Declaring the variable outside the loop is the right choice whenever the value matters afterwards.
```

## goto, briefly

C has a `goto` statement that jumps to a label. You will see it in some older code and in a few cleanup patterns, such as releasing several resources on an error path. In everyday code, prefer `break`, `continue`, `return` and well-named functions, because they keep the control flow visible.

## Recap

- `break` leaves the innermost loop or `switch`.
- `continue` skips to the next pass. In a `for` loop, the update still runs.
- A `break` in an inner loop does not stop the outer loop.
- Declare a loop variable before the loop when you need its value afterwards.
- Prefer `break`, `continue` and `return` over `goto` in everyday code.

**Up next:** functions, the way C organizes code into reusable pieces.
', 0, '[]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_3_5', 'sec_c_basics_3', 'crs_c_basics', 'Checkpoint: decisions & loops', 'quiz', 4, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"In `if (a) if (b) x(); else y();` with `a` true and `b` false, what runs?","options":["x() runs","y() runs","Both x() and y() run","Neither runs"],"answerIndex":1,"explanation":"An `else` attaches to the nearest `if`, so this `else` belongs to `if (b)`. With `b` false, `y()` runs. Braces make such relationships obvious."},{"id":"q2","prompt":"Which statement best describes what happens in a `switch` case with no `break`?","options":["The switch ends immediately","Execution falls through into the next case''s statements","The program stops with an error","The default case always runs"],"answerIndex":1,"explanation":"Without `break`, execution continues into the following case. That is fallthrough, and it is a common source of bugs unless it is intentional."},{"id":"q3","prompt":"What is the difference between `while` and `do`-`while`?","options":["`do`-`while` tests its condition before the body","`do`-`while` always runs the body at least once, because it tests after the body","`while` always runs the body at least once","There is no difference"],"answerIndex":1,"explanation":"A `do`-`while` loop checks its condition after each pass, so the body runs at least once. A `while` loop checks first, so its body may never run."},{"id":"q4","prompt":"Inside a `for` loop, what does `continue` do?","options":["Ends the whole loop","Skips the rest of the current pass and moves to the next one, running the update","Restarts the program","Jumps to the function''s first line"],"answerIndex":1,"explanation":"`continue` skips the remaining statements in the body and moves on. In a `for` loop the update expression still runs before the next test."},{"id":"q5","prompt":"In two nested loops, what does a `break` in the inner loop do?","options":["It leaves both loops","It leaves only the inner loop, and the outer loop continues","It restarts the outer loop from the beginning","It is a compile error"],"answerIndex":1,"explanation":"`break` leaves only the innermost loop or switch. To leave both loops, use a flag or move the code into a function and `return`."}]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_4_1', 'sec_c_basics_4', 'crs_c_basics', 'Functions: parameters, return values and prototypes', 'interactive', 0, 1200, NULL, NULL, 'A function is a named block of code that takes inputs, does work and optionally produces a result. Functions are how you stop repeating yourself, how you give a piece of logic a name that explains it, and how you break a large problem into parts you can test one at a time. Every C program is built out of them.

## Defining and calling a function

```c
#include <stdio.h>

int add(int a, int b) {
    return a + b;
}

int main(void) {
    int total = add(3, 4);
    printf("%d\n", total);
    return 0;
}
```

Read the definition from left to right. `int` is the return type, `add` is the name, and `(int a, int b)` are the parameters, which are local names for the values the caller passes in. `return` sends a value back to the caller. A function with the return type `void` returns nothing.

When you call `add(3, 4)`, the values `3` and `4` are copied into `a` and `b`. Inside `add`, those copies are the only things it touches.

## Parameters are copies

C passes arguments by value. The function receives a copy, so changing a parameter does not change the caller''s variable. This is one of the most important rules in C, and the next predict question checks it.

```c predict id=by-value title="What does this print?"
#include <stdio.h>

void bump(int n) {
    n = n + 10;
}

int main(void) {
    int x = 1;
    bump(x);
    printf("%d\n", x);
    return 0;
}
--- options
* 1
11
10
0
--- explain
`bump` receives a copy of `x`. It changes its own copy, `n`, to 11, and then returns. The variable `x` in `main` was never touched, so it still holds 1. To let a function change a caller''s variable, pass its address, which lesson 15 covers.
```

## Return values

A `return` statement ends the function and gives the value back. The value is an expression, so you can compute it inline, and calls can nest inside other calls.

```c predict id=return-expr title="What does this print?"
#include <stdio.h>

int square(int n) {
    return n * n;
}

int main(void) {
    printf("%d\n", square(square(3)));
    return 0;
}
--- options
* 81
18
27
9
--- explain
The inner call `square(3)` returns 9. That value becomes the argument to the outer call, `square(9)`, which returns 81. C evaluates the inner call first because its result is needed. Each function call is a separate step with its own parameters.
```

> **Pitfall:** A function that promises a value must return one on every path. Falling off the end of a non-`void` function and using the result is undefined behavior. Compilers warn about it with `-Wall`.

## Prototypes and order

C reads your file from top to bottom. If you call a function before its definition, the compiler does not yet know its return type and parameters. A **prototype** declares the function ahead of time, so you can define it later in the file, or in another file entirely.

```c
int square(int n);   /* prototype: the signature, ending with a semicolon */

int main(void) {
    return square(4) == 16 ? 0 : 1;
}

int square(int n) {  /* definition */
    return n * n;
}
```

Put prototypes for public functions in a header file, and definitions in a source file. Lesson 20 explains how the preprocessor makes that work.

## Recursion

A function can call itself. Recursion expresses a problem in terms of a smaller version of itself, and it needs a base case that stops the calls. Here is the factorial function, which multiplies the numbers from 1 up to n.

```c predict id=factorial title="What does this print?"
#include <stdio.h>

unsigned long long factorial(unsigned int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}

int main(void) {
    printf("%llu\n", factorial(5));
    return 0;
}
--- options
* 120
24
100
5
--- explain
`factorial(5)` multiplies 5 by `factorial(4)`, which multiplies 4 by `factorial(3)`, and so on until `factorial(1)` returns 1 as the base case. The product is 5 × 4 × 3 × 2 × 1, which is 120. The `%llu` specifier matches the `unsigned long long` return type.
```

> **Tip:** Recursion is elegant, but each call uses stack space. For very deep recursion, a loop is safer. You will meet this trade-off again in the advanced course.

## Designing a good function

A good function does one job, has a name that says what it does, and takes the inputs it needs rather than reaching into global state. If you cannot describe a function in a single sentence, split it. Small functions are easier to test, and the test is a predict question you can ask yourself before you run the code.

## Recap

- A function has a return type, a name, parameters and a body. `void` means it returns nothing.
- C passes arguments by value. The function changes a copy, not the caller''s variable.
- `return` sends a value back, and every path of a non-`void` function must return one.
- A prototype declares a function before its definition, so the order of definitions no longer matters.
- Recursion needs a base case, and deep recursion uses a lot of stack.

**Up next:** scope and lifetime, which decide where a variable is visible and how long it lives.
', 0, '[]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_4_2', 'sec_c_basics_4', 'crs_c_basics', 'Scope, lifetime and static variables', 'interactive', 1, 960, NULL, NULL, 'Every variable has two properties that people often mix up. Its **scope** is the part of the program where its name can be used. Its **lifetime** is how long the memory it occupies stays alive. Local variables are the most common case, and they are simple once you see the rule: each one lives in a block and disappears when the block ends. This lesson covers those rules, the global variables you should use sparingly, and the `static` keyword that changes a variable''s lifetime.

## Block scope

A variable declared inside a pair of braces exists only inside them. Code outside the block cannot see it, and the name can be reused elsewhere without conflict.

```c
#include <stdio.h>

int main(void) {
    int total = 0;
    for (int i = 1; i <= 3; i++) {
        int square = i * i;
        total += square;
    }
    /* printf("%d", square); would not compile: square is out of scope */
    printf("%d\n", total);
    return 0;
}
```

Each pass of the loop body creates a fresh `square`, which is destroyed at the end of the pass. Keeping variables in the smallest block that needs them makes code easier to read and harder to misuse.

## Shadowing

An inner declaration can share a name with an outer one. The inner name then hides the outer one inside its block. This is legal, and it is a frequent source of confusion.

```c predict id=shadowing title="What does this print?"
#include <stdio.h>

int value = 1;

int main(void) {
    int value = 2;
    {
        int value = 3;
        printf("%d ", value);
    }
    printf("%d\n", value);
    return 0;
}
--- options
* 3 2
1 2
2 2
3 1
--- explain
The innermost `value` is 3, and the `printf` inside the braces uses it. After the braces end, the name `value` refers to the `int value = 2` declared in `main`, which hides the global `value = 1`. The global variable is shadowed everywhere in `main`. Compilers can warn about shadowing with `-Wshadow`, which is worth enabling as your programs grow.
```

## Local lifetime

A local variable is created when its block starts and destroyed when the block ends. Its value does not survive into the next call of the function. This is why a counter inside a function resets each time, unless you ask for something different.

```c predict id=loop-scope title="What does this print?"
#include <stdio.h>

int main(void) {
    for (int i = 0; i < 2; i++) {
        int seen = 0;
        seen += 5;
        printf("%d ", seen);
    }
    printf("\n");
    return 0;
}
--- options
* 5 5
5 10
10 10
0 0
--- explain
Each pass through the loop creates a new `seen` and sets it to 0 before adding 5. Nothing carries over from the previous pass, so both passes print 5. Initializing a local variable inside the loop is how you guarantee a fresh start each time.
```

## static local variables

Adding `static` to a local variable changes its lifetime. It lives for the entire run of the program, but its name is still visible only inside its block. It also keeps its value between calls. Static locals are initialized once, before the program starts running `main`.

```c predict id=static-counter title="What does this print?"
#include <stdio.h>

int next_id(void) {
    static int id = 100;
    return id++;
}

int main(void) {
    int a = next_id();
    int b = next_id();
    printf("%d %d\n", a, b);
    return 0;
}
--- options
* 100 101
100 100
101 102
1 2
--- explain
The `static int id` is created once, with the value 100. The first call returns 100 and increments `id` to 101, and the second call returns 101. Because the variable persists, the function remembers how many times it has run. A non-`static` local would start from 100 every time.
```

> **Pitfall:** `static` local variables are shared by every call, so they are not thread-safe. If you ever write code that runs on several threads at once, a `static` counter needs protection.

## Global variables

A variable declared outside any function is global. It has file scope, lasting for the whole program, and any function in the file can read or change it. Globals are convenient, and they are also the hardest variables to reason about, because any function can change them at any time. Prefer passing values as parameters, and keep globals for values that truly belong to the whole program, such as a configuration flag.

> **In the wild:** Operating system kernels and embedded firmware use many globals, but they document each one carefully. In your own programs, if you find yourself adding a global to avoid passing a value, that is usually a sign that the function needs a parameter.

## Recap

- Scope is where a name is visible. Lifetime is how long its memory exists.
- A local variable lives in its block and is recreated each time that block runs.
- An inner variable can shadow an outer one with the same name.
- A `static` local keeps its value across calls, and it is initialized once.
- Global variables are visible everywhere, so use them sparingly.

**Up next:** arrays, which store many values of one type in a row.
', 0, '[]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_4_3', 'sec_c_basics_4', 'crs_c_basics', 'Arrays: fixed-size collections and their rules', 'interactive', 2, 1080, NULL, NULL, 'An array stores a fixed number of values of the same type, laid out one after another in memory. You access each element by its index, which starts at zero. Arrays are the foundation of nearly every data structure in C, and they come with a few rules that are different from other languages. Learn those rules now, and the later lessons on pointers will make much more sense.

## Declaring and using arrays

```c
#include <stdio.h>

int main(void) {
    int scores[4] = {90, 75, 88, 62};

    printf("first: %d\n", scores[0]);
    printf("last:  %d\n", scores[3]);

    scores[1] = 80;   /* arrays can be changed element by element */
    return 0;
}
```

The size is part of the declaration, and it cannot change afterwards. Indexes run from `0` to `size - 1`. Index `4` on a four-element array does not exist, and reading or writing it is undefined behavior. C will not stop you, which is why careful bounds checking is your job.

> **Pitfall:** The most common C bug in history is writing one element past the end of an array. It often works by accident, and then fails in a different place much later. Always check your loop bounds.

## Initializing an array

If you give the size, missing initial values become zero. You can also let the compiler count the elements by leaving the brackets empty.

```c predict id=partial-init title="What does this print?"
#include <stdio.h>

int main(void) {
    int a[5] = {1, 2};
    printf("%d %d\n", a[1], a[4]);
    return 0;
}
--- options
* 2 0
2 4
1 2
2 garbage
--- explain
The first two elements are set to 1 and 2, and the rest of the array is filled with zeros. So `a[1]` is 2, and `a[4]` is 0. This zero-filling applies to arrays with static or automatic storage when you give an initializer list. It is a convenient way to create an array of zeros.
```

To count elements, divide the total size by the size of one element. That pattern works for any array whose type you can see:

```c predict id=array-sum title="What does this print?"
#include <stdio.h>

int main(void) {
    int scores[] = {4, 8, 15};
    int total = 0;
    for (int i = 0; i < 3; i++) total += scores[i];
    printf("%d %zu\n", total, sizeof scores / sizeof scores[0]);
    return 0;
}
--- options
* 27 3
27 12
4 3
27 4
--- explain
The loop adds 4, 8 and 15 to get 27. The array occupies 12 bytes in total, because each `int` is 4 bytes, and each element is 4 bytes, so `sizeof scores / sizeof scores[0]` gives 3 elements. That expression only works where the array''s size is known, such as in the function that declared it. It does not work for an array passed to another function, as lesson 16 explains.
```

## Arrays cannot be copied or compared with ==

You cannot assign one array to another, and `==` does not compare contents. To copy an array, copy each element with a loop, or use `memcpy` from `<string.h>`. To compare contents, compare element by element.

```c
int source[3] = {1, 2, 3};
int copy[3];

for (int i = 0; i < 3; i++) {
    copy[i] = source[i];
}
```

## Multidimensional arrays

A two-dimensional array is an array of rows. Indexes are written in pairs, row first, then column. Nested loops are the natural way to visit every cell.

```c predict id=two-d title="What does this print?"
#include <stdio.h>

int main(void) {
    int grid[2][3] = {{1, 2, 3}, {4, 5, 6}};
    printf("%d\n", grid[1][0] + grid[0][2]);
    return 0;
}
--- options
* 7
9
5
6
--- explain
`grid[1][0]` is the first element of the second row, which is 4. `grid[0][2]` is the last element of the first row, which is 3. Their sum is 7. The first index selects the row and the second selects the column, and the memory is laid out row by row.
```

## Passing arrays to functions

When you pass an array to a function, you also pass its length, because the function cannot discover the length itself. Lesson 16 explains the reason. For now, the pattern is simple and worth memorizing:

```c
#include <stdio.h>

int sum(const int values[], size_t count) {
    int total = 0;
    for (size_t i = 0; i < count; i++) {
        total += values[i];
    }
    return total;
}

int main(void) {
    int data[] = {10, 20, 30};
    printf("%d\n", sum(data, sizeof data / sizeof data[0]));
    return 0;
}
```

The `const` tells the reader, and the compiler, that `sum` does not change the array.

## Recap

- An array holds a fixed number of values of one type. Indexes start at 0.
- Stay within the bounds. Index `size` and beyond is undefined behavior.
- Uninitialized elements of an initialized array are zero.
- `sizeof array / sizeof array[0]` counts the elements of an array in its own scope.
- You cannot assign or compare whole arrays with `=` or `==`.
- Pass the length along with an array to a function.

**Up next:** strings, which are arrays of characters with a special terminator.
', 0, '[]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_4_4', 'sec_c_basics_4', 'crs_c_basics', 'Strings are char arrays with a terminator', 'interactive', 3, 1080, NULL, NULL, 'C has no string type. A string is an array of `char` that ends with a special value, the null character `''\0''`. Every function that works with strings relies on that terminator to know where the text ends. Once you understand the terminator, the standard string functions are easy to use correctly, and the mistakes they invite are easy to avoid.

## Strings are char arrays

```c
#include <stdio.h>

int main(void) {
    char greeting[] = "Hello";
    printf("%s\n", greeting);
    return 0;
}
```

The array `greeting` has six elements, not five. The five letters are followed by `''\0''`, which the compiler adds automatically for a string literal. When `printf` sees `%s`, it prints characters until it reaches that terminator.

> **Pitfall:** A string needs room for its terminator. A buffer of `char name[5]` can hold a four-letter word and no more, so `"Grace"` does not fit. Forgetting the terminator is a classic source of bugs, and it is why string functions that take a size are safer.

## strlen and sizeof are different

`strlen` counts the characters before the terminator. `sizeof` measures the whole array, including the terminator and any unused space. Mixing them up is a frequent mistake.

```c predict id=strlen-sizeof title="What does this print?"
#include <stdio.h>
#include <string.h>

int main(void) {
    char word[] = "cat";
    printf("%zu %zu\n", strlen(word), sizeof word);
    return 0;
}
--- options
* 3 4
3 3
4 4
4 3
--- explain
`strlen` counts `c`, `a` and `t`, giving 3. `sizeof word` measures the array, which holds the three letters plus the terminator, so it is 4 bytes. The terminator is included in the array but not in the length of the string. `strlen` runs in time proportional to the string''s length, so store the result if you need it many times.
```

## Comparing strings

Because a string is an array, `==` compares addresses, not text. Two arrays with the same letters are still two different arrays. Use `strcmp` from `<string.h>`, which returns 0 when two strings are equal.

```c predict id=string-compare title="What does this print?"
#include <stdio.h>

int main(void) {
    char s1[] = "x";
    char s2[] = "x";
    printf("%d\n", s1 == s2);
    return 0;
}
--- options
* 0
1
2
-1
--- explain
`s1` and `s2` are separate arrays in memory with the same contents. In an expression, each array name becomes the address of its first element, and those two addresses are different. So `s1 == s2` is false, which is 0. To compare the text, call `strcmp(s1, s2) == 0`.
```

> **Tip:** `strcmp` returns 0 for equal strings, a negative number if the first comes earlier alphabetically, and a positive number if it comes later. Write `strcmp(a, b) == 0`, rather than `!strcmp(a, b)`, so the intent is clear.

## Copying and terminators

`strcpy` copies a string, but it does not check the size of the destination. Use `snprintf` with a size instead, because it always leaves room for the terminator and never writes past the buffer. A string''s terminator can also be placed by hand, and that changes what the string means.

```c predict id=null-terminator title="What does this print?"
#include <stdio.h>
#include <string.h>

int main(void) {
    char buf[8] = "abc";
    buf[1] = ''\0'';
    printf("%zu\n", strlen(buf));
    return 0;
}
--- options
* 1
3
2
8
--- explain
Setting `buf[1]` to the terminator makes the string end after its first character. `strlen` stops at the first `''\0''` it finds, so the answer is 1, even though the array still holds `c` after the terminator. Functions like `strlen` and `printf` read only up to the terminator, so the characters after it are invisible to them.
```

## Reading text safely

`fgets` reads a whole line into a buffer, and it takes the buffer''s size, so it can never overflow. It keeps the newline character at the end of the text, and you usually remove it yourself.

```c
#include <stdio.h>
#include <string.h>

int main(void) {
    char name[32];

    printf("Name? ");
    if (fgets(name, sizeof name, stdin) == NULL) {
        return 1;
    }
    name[strcspn(name, "\n")] = ''\0'';   /* strip the newline */
    printf("Hello, %s!\n", name);
    return 0;
}
```

The call `strcspn(name, "\n")` finds the position of the first newline, and writing a terminator there removes it. Long input is truncated safely, which is far better than overflowing the array.

## Recap

- A C string is a `char` array ending with `''\0''`. Leave room for the terminator.
- `strlen` counts characters before the terminator. `sizeof` measures the whole array.
- `==` compares addresses, so compare strings with `strcmp`.
- Prefer `snprintf` and `fgets`, which take a size and cannot overflow the buffer.
- Writing a terminator early changes the length the string functions see.

**Up next:** pointers, the feature that makes C both powerful and demanding.
', 0, '[]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_4_5', 'sec_c_basics_4', 'crs_c_basics', 'Checkpoint: functions & arrays', 'quiz', 4, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"What does the following program print?\n\n```c\nvoid bump(int n) { n = n + 10; }\nint main(void) { int x = 1; bump(x); printf(\"%d\", x); }\n```","options":["1","10","11","It does not compile"],"answerIndex":0,"explanation":"C passes arguments by value. `bump` changes its own copy of `x`, so the caller''s `x` stays 1. Passing the address of `x` is the way to let a function change it."},{"id":"q2","prompt":"Which statement about a `static` local variable is true?","options":["It is recreated and reset to its initial value on every call","It keeps its value between calls, and it is initialized only once","It is visible to every file in the program","It is stored in a register, so it cannot be read"],"answerIndex":1,"explanation":"A `static` local lives for the whole run of the program and keeps its value between calls. Its name is still visible only inside its block."},{"id":"q3","prompt":"For `int a[5] = {1, 2};`, what are `a[1]` and `a[4]`?","options":["2 and 4","2 and 0","1 and 2","2 and an undefined value"],"answerIndex":1,"explanation":"Elements missing from an initializer list are set to zero, so `a[4]` is 0, and `a[1]` is the second value, 2."},{"id":"q4","prompt":"For `char name[] = \"Ada\";`, what is `strlen(name)` and what is `sizeof name`?","options":["3 and 3","3 and 4","4 and 4","4 and 3"],"answerIndex":1,"explanation":"`strlen` counts the three letters, giving 3. `sizeof` measures the whole array, including the `''\\0''` terminator that the compiler adds, giving 4."},{"id":"q5","prompt":"Why does `s1 == s2` compare false for two separate arrays `char s1[] = \"x\"; char s2[] = \"x\";`?","options":["Because the arrays contain different letters","Because `==` compares the addresses of the arrays, and they are different objects","Because `==` is not allowed on arrays","Because strings cannot be shorter than 2 characters"],"answerIndex":1,"explanation":"Array names decay to the addresses of their first elements, and two separate arrays have different addresses. To compare text, use `strcmp`."}]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_c_basics_5_1', 'sec_c_basics_5', 'crs_c_basics', 'Pointers: addresses, dereferencing and pass-by-pointer', 'interactive', 0, 1320, NULL, NULL, 'Every variable lives at an address in memory, a number that identifies where its bytes sit. A **pointer** is a variable whose value is an address. With pointers you can refer to a variable indirectly, pass a function the ability to change a caller''s data, and build structures that grow and shrink. Pointers are the feature that makes C powerful, and they are the one most beginners find hard. Take them one step at a time.

## Address-of and dereference

Two operators do most of the work. The `&` operator gives you the address of a variable. The `*` operator, applied to a pointer, reaches the value at that address.

```c
#include <stdio.h>

int main(void) {
    int n = 7;
    int *p = &n;     /* p holds the address of n */

    printf("%d\n", *p);   /* prints 7: the value at that address */
    *p = 12;              /* writes 12 into n, through the pointer */
    printf("%d\n", n);    /* prints 12 */
    return 0;
}
```

Read `int *p` as "p is a pointer to an int". The star in a declaration says "pointer", and the star in an expression says "the thing this points to". The two uses of `*` are the same symbol with different jobs, which is why they confuse people at first.

> **Tip:** Say the declaration out loud. `int *p` reads as "p is a pointer to int", and `*p` reads as "the int that p points to".

The next predict question checks that a write through a pointer changes the original variable:

```c predict id=pointer-basic title="What does this print?"
#include <stdio.h>

int main(void) {
    int n = 7;
    int *p = &n;
    *p = *p + 1;
    printf("%d\n", n);
    return 0;
}
--- options
* 8
7
6
garbage
--- explain
`*p` refers to `n` itself, not to a copy. So `*p = *p + 1` reads 7, adds 1, and stores 8 back into `n`. The variable `n` now holds 8, which `printf` shows. Pointers give you another name for the same memory, and changes through either name are visible through both.
```

## Pointers have types

A pointer''s type says what kind of value lives at its address. An `int *` points to an `int`, and a `double *` points to a `double`. The type matters when you use the pointer, because `*p` reads the right number of bytes, and pointer arithmetic moves by the size of the pointed-to type.

```c
double price = 4.5;
double *pp = &price;
```

Assigning a pointer of one type to a pointer of another type without a cast is a compile warning, and the result of using it is undefined behavior. Keep the types matched.

## Pass by pointer

The main reason to use pointers early is to let a function change a caller''s variable. You pass the address, and the function dereferences it.

```c predict id=swap-pointers title="What does this print?"
#include <stdio.h>

void swap(int *a, int *b) {
    int t = *a;
    *a = *b;
    *b = t;
}

int main(void) {
    int x = 2, y = 9;
    swap(&x, &y);
    printf("%d %d\n", x, y);
    return 0;
}
--- options
* 9 2
2 9
9 9
2 2
--- explain
`swap` receives the addresses of `x` and `y`. It saves the value at `a` in `t`, copies the value at `b` into `a`, and then copies `t` into `b`. The variables in `main` now hold 9 and 2. This is the same pattern that `scanf` uses when you write `scanf("%d", &age)`: `scanf` needs the address so it can store the value there.
```

> **Pitfall:** Passing a value where a pointer is expected, or a pointer where a value is expected, is a common mistake. The compiler will often warn you, so read those warnings.

## Pointers can be reassigned

A pointer is a variable in its own right, so it can point somewhere else later. Reassigning a pointer changes where it points, not the value it used to point to.

```c predict id=ptr-reassign title="What does this print?"
#include <stdio.h>

int main(void) {
    int a = 1, b = 2;
    int *p = &a;
    p = &b;
    *p += 40;
    printf("%d %d\n", a, b);
    return 0;
}
--- options
* 1 42
41 2
1 2
42 42
--- explain
`p` starts at `&a`, then is reassigned to `&b`. The line `*p += 40` therefore changes `b`, not `a`. `a` keeps its value of 1, and `b` becomes 42. A pointer''s value is an address, and reassigning the pointer changes only the address.
```

## NULL and safe pointers

A pointer that points nowhere should hold `NULL`, which the standard defines in `<stdio.h>`, `<stdlib.h>` and `<stddef.h>`. Check a pointer against `NULL` before you use it, especially when it came from a function that can fail. Dereferencing a null pointer is undefined behavior, and on most systems it crashes the program.

```c
#include <stdio.h>

int main(void) {
    int *maybe = NULL;

    if (maybe == NULL) {
        printf("no value to read\n");
    } else {
        printf("%d\n", *maybe);
    }
    return 0;
}
```

> **Pitfall:** An uninitialized pointer holds a random address. Initialize every pointer, either to a real address or to `NULL`, when you declare it.

## Recap

- `&` gives the address of a variable, and `*` reaches the value at a pointer''s address.
- In a declaration, `int *p` means "p points to an int". In an expression, `*p` means "the int at p".
- A pointer''s type determines how it reads memory and how pointer arithmetic moves.
- Pass a pointer to let a function change a caller''s variable. That is how `scanf` works.
- Reassigning a pointer changes its address, not the value it used to point to.
- Initialize pointers. Check them against `NULL` before dereferencing.

**Up next:** how pointers and arrays are connected, and the arithmetic that moves between elements.
', 0, '[]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_5_2', 'sec_c_basics_5', 'crs_c_basics', 'Pointer arithmetic and the link between pointers and arrays', 'interactive', 1, 1200, NULL, NULL, 'Here is the fact that connects pointers and arrays, and once you have it, a lot of C clicks into place. In most expressions, an array name turns into a pointer to its first element. That means `arr[i]` and `*(arr + i)` are the same thing. Pointer arithmetic is the rule that makes the second form work, and the same rule explains why a function receiving an array cannot know its length.

## Arrays decay to pointers

```c
#include <stdio.h>

int main(void) {
    int nums[] = {10, 20, 30, 40};
    int *first = nums;    /* same as &nums[0] */

    printf("%d %d\n", *first, first[2]);
    return 0;
}
```

The assignment `int *first = nums;` works because `nums` becomes the address of its first element. From there, `first[2]` means "two elements past the first one", which is `nums[2]`. Indexing is defined in terms of pointers, not the other way around.

## Pointer arithmetic

Adding an integer to a pointer moves it by that many elements, not bytes. The compiler multiplies by the size of the pointed-to type for you. That is why the arithmetic is safe and portable.

```c predict id=ptr-arith title="What does this print?"
#include <stdio.h>

int main(void) {
    int nums[] = {10, 20, 30, 40};
    int *p = nums + 1;
    printf("%d %d\n", *p, p[2]);
    return 0;
}
--- options
* 20 40
20 30
10 40
30 40
--- explain
`nums + 1` points at the second element, which holds 20, so `*p` is 20. `p[2]` means two elements beyond `p`, which is `nums[3]`, holding 40. The compiler moves the pointer by `sizeof(int)` bytes for each element, so you never have to count bytes yourself.
```

Subtracting two pointers into the same array gives the number of elements between them. The result has the type `ptrdiff_t`, which you print with `%td`.

```c predict id=ptr-diff title="What does this print?"
#include <stdio.h>

int main(void) {
    double vals[5];
    double *start = &vals[1];
    double *end = &vals[4];
    printf("%td\n", end - start);
    return 0;
}
--- options
* 3
4
24
32
--- explain
`end` points to element 4 and `start` points to element 1, so the difference is 3 elements. The number of bytes between them is 24, because each `double` is 8 bytes, but pointer subtraction counts elements. Subtracting pointers that point into different arrays is undefined behavior, so keep both pointers inside the same array.
```

## The same thing three ways

Because of decay, these three expressions are equivalent when `i` is a valid index:

```c
arr[i]
*(arr + i)
*(i + arr)
```

The last form looks odd, but it is legal, because addition is commutative. Nobody writes it in real code, although the predict question below uses it to test whether you understand the rule.

```c predict id=equivalence title="What does this print?"
#include <stdio.h>

int main(void) {
    int arr[] = {3, 6, 9};
    int i = 2;
    printf("%d %d\n", arr[i], *(i + arr));
    return 0;
}
--- options
* 9 9
9 6
3 9
6 9
--- explain
`arr[i]` and `*(i + arr)` both refer to element 2, which holds 9. The expression `i + arr` is the address two elements past the start of `arr`, and dereferencing it gives the same value. The forms are equivalent because `a[b]` is defined as `*(a + b)` in the standard.
```

## Why a function needs the length

When you pass an array to a function, you pass a pointer to its first element. The function has no way to know the array''s size, because `sizeof` inside the function measures the pointer, not the array. That is why the length must travel with the pointer.

```c
#include <stdio.h>

void print_all(const int *values, size_t count) {
    for (size_t i = 0; i < count; i++) {
        printf("%d ", values[i]);
    }
    printf("\n");
}

int main(void) {
    int data[] = {1, 2, 3};
    print_all(data, sizeof data / sizeof data[0]);
    return 0;
}
```

The parameter `const int *values` and `const int values[]` mean the same thing. The compiler treats both as a pointer.

> **In the wild:** Nearly every C library function that processes a buffer takes a pointer and a length: `fwrite`, `memcpy`, `snprintf`. Learning that pattern early keeps your code safe.

## Recap

- In most expressions an array name becomes a pointer to its first element.
- `arr[i]` is defined as `*(arr + i)`, so both forms are equivalent.
- Pointer arithmetic moves by whole elements, and pointer subtraction counts elements.
- A function receiving an array gets a pointer, so it needs the length passed separately.
- Keep pointer arithmetic inside the bounds of one array.

**Up next:** memory you choose the size of at runtime, with `malloc` and `free`.
', 0, '[]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_5_3', 'sec_c_basics_5', 'crs_c_basics', 'Dynamic memory with malloc, calloc and free', 'interactive', 2, 1200, NULL, NULL, 'So far every array had a size you knew when you wrote the program. Real programs often need memory whose size depends on the input: a list of students whose length you learn only at runtime, or a buffer that grows as text arrives. C provides this through dynamic memory. You ask for bytes with `malloc`, use them through a pointer, and give them back with `free`. The bargain is simple, and it is strict: every allocation you make must be released exactly once, by you.

## malloc and free

`malloc` requests a block of bytes from the heap and returns a pointer to it, or `NULL` if the request fails. You must say how many bytes you need, and the cleanest way is `sizeof` applied to the element type. `free` returns the block when you are finished.

```c predict id=malloc-fill title="What does this print?"
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int *v = malloc(3 * sizeof *v);
    if (v == NULL) return 1;
    for (int i = 0; i < 3; i++) v[i] = i * i;
    printf("%d\n", v[0] + v[1] + v[2]);
    free(v);
    return 0;
}
--- options
* 5
14
3
9
--- explain
`malloc` gives room for three `int`s. The loop stores 0, 1 and 4, which add up to 5. The `sizeof *v` idiom takes the size of whatever `v` points to, so if you later change the type of `v`, the allocation size updates itself. The `free(v)` call returns the memory to the system.
```

> **Tip:** Write `malloc(n * sizeof *p)` rather than `malloc(n * sizeof(int))`. The first form stays correct when the type changes, and it reads as "n elements of whatever p points to".

## Always check the result

`malloc` can fail, and when it does it returns `NULL`. Ignoring that return value leads to a null-pointer dereference. Check it immediately, and decide what to do: print an error, return a failure code, or stop the program.

```c
int *values = malloc(count * sizeof *values);
if (values == NULL) {
    fprintf(stderr, "out of memory\n");
    return 1;
}
```

## calloc sets everything to zero

`calloc` takes a count and a size, and it zeroes the memory it returns. Use it when you want an array of zeros, because you do not have to clear it yourself.

```c predict id=calloc-zero title="What does this print?"
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int *z = calloc(4, sizeof *z);
    if (z == NULL) return 1;
    printf("%d %d\n", z[0], z[3]);
    free(z);
    return 0;
}
--- options
* 0 0
0 4
1 1
garbage garbage
--- explain
`calloc(4, sizeof *z)` asks for four `int`s and fills them with zero bits, which read back as the integer 0. The check against `NULL` is still required, because allocation can fail. Calling `free` at the end returns the memory.
```

## Resizing with realloc

`realloc` changes the size of an existing block. It may move the data to a new location, so always assign its result to a new pointer, and only replace the old pointer once you know the call succeeded.

```c
int *grown = realloc(values, new_count * sizeof *grown);
if (grown == NULL) {
    /* values is still valid here; handle the error and free it later */
    return 1;
}
values = grown;
```

The temporary pointer protects you. If `realloc` fails, the original block is still allocated, and you can free it.

## Sizes of what you point to

Dereferencing a pointer gives you the object it points to, and `sizeof` on that dereference gives the size of the object. This is the basis of the `sizeof *p` idiom. The next question uses the one size the standard guarantees.

```c predict id=sizeof-deref title="What does this print?"
#include <stdio.h>

int main(void) {
    char *s = NULL;
    printf("%zu\n", sizeof *s);
    return 0;
}
--- options
* 1
8
4
0
--- explain
`sizeof *s` measures the object that `s` points to, which has type `char`. The standard defines `sizeof(char)` as 1, so the answer is 1. The code never reads through `s`, so the null pointer is safe here. `sizeof` looks at the type only, not at the value.
```

## The rule of ownership

Every block from `malloc`, `calloc` or `realloc` has one owner, and that owner must call `free` exactly once. Freeing a block twice, or reading it after it has been freed, is undefined behavior. Forgetting to free it is a **memory leak**: the memory stays reserved until the program ends. A short program may survive a leak. A long-running server will eventually run out of memory.

> **Pitfall:** After `free(p)`, set `p = NULL`. A later accidental use then fails clearly, rather than silently reading memory that may already belong to something else.

> **In the wild:** Tools such as Valgrind and the AddressSanitizer find leaks and misuse of freed memory. The advanced course covers them. For now, make a habit of writing the `free` as you write the `malloc`.

## Recap

- `malloc` returns a block of heap memory, or `NULL` on failure. Always check it.
- Use `sizeof *p` to size allocations for the element type.
- `calloc` zeroes the memory. `realloc` may move it, so assign to a temporary first.
- Every allocation must be freed exactly once. Freeing twice or using freed memory is undefined.
- Set a pointer to `NULL` after you free it.

**Up next:** a short quiz on pointers and memory. Then structs, which group related values together.
', 0, '[]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_5_4', 'sec_c_basics_5', 'crs_c_basics', 'Checkpoint: pointers & memory', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"After `int n = 7; int *p = &n; *p = 12;`, what is the value of `n`?","options":["7","12","The address of n","It is undefined"],"answerIndex":1,"explanation":"`p` holds the address of `n`, and `*p` refers to `n` itself. Writing `*p = 12` therefore changes `n` to 12."},{"id":"q2","prompt":"In the declaration `int *p;`, what does `*` mean?","options":["p is a pointer to an int","p is multiplied by an int","p is an int that is never used","p is a function"],"answerIndex":0,"explanation":"In a declaration, the star says the variable is a pointer. In an expression, `*p` means the value at the address `p` holds."},{"id":"q3","prompt":"For `int nums[] = {10, 20, 30}; int *p = nums + 2;`, what is `*p`?","options":["10","20","30","The address of the array"],"answerIndex":2,"explanation":"`nums + 2` points two elements past the first element, which is `nums[2]`, the value 30. Pointer arithmetic moves by elements, not bytes."},{"id":"q4","prompt":"Why should you check the return value of `malloc` before using the block?","options":["Because malloc always returns zero bytes","Because malloc returns NULL when the request fails, and dereferencing NULL is undefined behavior","Because malloc frees memory automatically","Because malloc must be called twice"],"answerIndex":1,"explanation":"When memory is unavailable, `malloc` returns `NULL`. Using that pointer leads to undefined behavior, usually a crash, so always check first."},{"id":"q5","prompt":"What is the result of `sizeof *s` where `char *s = NULL;`?","options":["0","The size of a pointer, which is 8 on most systems","1","It is a compile error, because s is NULL"],"answerIndex":2,"explanation":"`sizeof` measures the object that `*s` would refer to, which has type `char`, and the standard defines `sizeof(char)` as 1. The null pointer is never read, because `sizeof` does not evaluate its operand''s value here."}]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_6_1', 'sec_c_basics_6', 'crs_c_basics', 'Structs: grouping related data', 'interactive', 0, 1080, NULL, NULL, 'Most real data is a bundle of related values. A student has a name, an id and a grade. A point has an x and a y. A struct lets you group those values under one name, so you can pass a student to a function, store a list of them, or save one to a file as a single unit. Structs are the C tool for modelling things, and the next few projects use them constantly.

## Defining and using a struct

```c
#include <stdio.h>

struct student {
    char name[32];
    int id;
    double grade;
};

int main(void) {
    struct student s = {"Ada", 1021, 91.5};

    printf("%s (#%d): %.1f\n", s.name, s.id, s.grade);
    return 0;
}
```

The definition describes a new type, `struct student`, and lists its members. Each member is accessed with a dot: `s.name`, `s.id`, `s.grade`. The braces in the declaration initialize the members in the order they were listed.

> **Tip:** Name the struct after what it models, in the singular. `struct student` is one student, and an array of them is `struct student roster[30]`.

## Structs are values

Assigning one struct to another copies every member. The copy is independent of the original, which surprises people who are used to references in other languages.

```c predict id=struct-copy title="What does this print?"
#include <stdio.h>

struct point { int x; int y; };

int main(void) {
    struct point a = {1, 2};
    struct point b = a;
    b.x = 10;
    printf("%d %d\n", a.x, b.x);
    return 0;
}
--- options
* 1 10
10 10
1 1
10 1
--- explain
`b = a` copies all the members, so `b` is a separate object that happens to hold the same values. Changing `b.x` leaves `a.x` alone. Plain assignment copies a whole struct, which is convenient, but it also means large structs cost time to copy. Pass a pointer to a large struct when you do not need a copy.
```

## Pointers to structs and the arrow

When you have a pointer to a struct, you can dereference it and then use the dot, but C provides the arrow `->` as a shorthand. `p->x` means `(*p).x`.

```c predict id=struct-arrow title="What does this print?"
#include <stdio.h>

struct item { int qty; };

void restock(struct item *it) {
    it->qty += 5;
}

int main(void) {
    struct item s = {2};
    restock(&s);
    printf("%d\n", s.qty);
    return 0;
}
--- options
* 7
2
5
10
--- explain
`restock` receives the address of `s`, so `it->qty` refers to `s.qty` itself. The function adds 5 to the quantity, turning 2 into 7, and `main` sees the change. Use `->` whenever you have a pointer to a struct, and `.` when you have the struct itself.
```

> **Pitfall:** `->` works only on pointers. Writing `s->qty` on a struct value is a compile error. Write `s.qty` for a value, and `p->qty` for a pointer.

## Initializing by name

Designated initializers name the members you want to set. The members you do not name become zero, and the order you write them no longer matters.

```c predict id=designated title="What does this print?"
#include <stdio.h>

struct config { int width; int height; int depth; };

int main(void) {
    struct config c = { .height = 4, .width = 3 };
    printf("%d %d %d\n", c.width, c.height, c.depth);
    return 0;
}
--- options
* 3 4 0
3 4 4
0 4 3
3 0 4
--- explain
The designated initializer sets `width` to 3 and `height` to 4 regardless of the order written. `depth` is not mentioned, so it is zero. Designated initializers are clearer than positional ones when a struct has many fields, and they stay readable when a field is added later.
```

## Arrays of structs

Structs fit naturally into arrays, and you can loop over them the same way you loop over numbers.

```c
#include <stdio.h>

struct student {
    const char *name;
    double grade;
};

int main(void) {
    struct student class_[] = {
        {"Ada", 91.5},
        {"Linus", 78.25},
        {"Grace", 88.0},
    };
    double total = 0.0;

    for (size_t i = 0; i < sizeof class_ / sizeof class_[0]; i++) {
        total += class_[i].grade;
    }
    printf("average: %.2f\n", total / 3);
    return 0;
}
```

The trailing comma after the last element is legal and often useful, because it makes adding a line easier and cleaner in version control.

## Padding

A struct''s size is usually more than the sum of its members, because the compiler adds padding so that each member starts at an address its type requires. You do not need to control padding yet. What matters now is that `sizeof` gives you the true size, and that you should never assume a struct''s layout byte for byte.

## Recap

- A struct groups related values into one named type. Access members with `.`.
- Assigning a struct copies all of its members.
- With a pointer to a struct, use `->` to reach a member.
- Designated initializers name the members, and unnamed members become zero.
- Structs fit naturally into arrays, and `sizeof` gives the true size, including padding.

**Up next:** enums, typedef and unions, which round out the tools for modelling data.
', 0, '[]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_6_2', 'sec_c_basics_6', 'crs_c_basics', 'Enums, typedef and unions', 'interactive', 1, 960, NULL, NULL, 'Structs describe the shape of data. Three more tools round out the picture. An **enum** gives names to a fixed set of integer values, so your code says `STATUS_ACTIVE` instead of `2`. A **typedef** gives a type a shorter name. A **union** stores one of several possible types in the same memory, which is useful when a value can take one of several forms. Each is small on its own, and together they make your code read like the problem it solves.

## enum: named integer constants

An enum lists names for integer values. The first name is 0 unless you say otherwise, and each following name is one more than the one before it.

```c
#include <stdio.h>

enum status { PENDING, ACTIVE, CLOSED };

int main(void) {
    enum status s = ACTIVE;

    if (s == ACTIVE) {
        printf("account is active (%d)\n", s);
    }
    return 0;
}
```

Enums make `switch` statements and comparisons self-explanatory, and they cost nothing at runtime. They are integers under the hood, so they also work with arithmetic, which is occasionally useful and occasionally a trap.

```c predict id=enum-values title="What does this print?"
#include <stdio.h>

enum level { LOW, MEDIUM = 5, HIGH };

int main(void) {
    printf("%d %d %d\n", LOW, MEDIUM, HIGH);
    return 0;
}
--- options
* 0 5 6
0 1 2
0 5 5
1 5 6
--- explain
`LOW` starts at 0. `MEDIUM` is set explicitly to 5. `HIGH` has no explicit value, so it is one more than the value before it, giving 6. Once you assign a value, the names after it count from there. Mixing explicit and automatic values this way is legal, but keep it simple in production code.
```

## typedef: naming a type

`typedef` gives an existing type a new name. The most common use in C is to hide the `struct` keyword, so that a type reads like a built-in.

```c predict id=typedef title="What does this print?"
#include <stdio.h>

typedef struct { int hours; } Shift;

int main(void) {
    Shift s = {8};
    Shift t = s;
    t.hours *= 2;
    printf("%d %d\n", s.hours, t.hours);
    return 0;
}
--- options
* 8 16
16 16
8 8
16 8
--- explain
`Shift` is an alias for an anonymous struct. `t = s` copies the struct, so `t` is independent of `s`. Doubling `t.hours` changes only the copy, which leaves `s.hours` at 8. The typedef changes the name, not the behavior: a `Shift` is exactly the same type as the struct it names.
```

> **Tip:** Use `typedef` to make the name of a type clear, not to hide what it is. `typedef struct point Point;` is helpful. Hiding pointers behind typedefs makes code harder to read, so avoid it.

## union: one memory, several views

A union has several members, but only one of them holds a value at a time. All the members share the same memory, and the union is as large as its largest member.

```c predict id=union-size title="Does this print yes or no?"
#include <stdio.h>

union number {
    char c;
    double d;
};

int main(void) {
    printf("%s\n", sizeof(union number) >= sizeof(double) ? "yes" : "no");
    return 0;
}
--- options
* yes
no
It depends on the compiler
It does not compile
--- explain
A union must be large enough to hold its largest member. Since `double` is bigger than `char`, the union is at least as large as a `double`, and the comparison is true. The question is about size, which the standard guarantees, rather than what the bytes contain, which depends on the platform.
```

Unions are useful when a single value can take one of several shapes, such as a token that is either a number or a name. They are also the place where reading an inactive member becomes undefined behavior, so you should always know which member is active. The advanced course returns to this with tagged unions and type punning.

## Putting the three together

Here is a small model that uses all three tools. An enum names the kind, a union holds the value, and a typedef keeps the code tidy:

```c
#include <stdio.h>

typedef enum { INT_VALUE, TEXT_VALUE } Kind;

typedef struct {
    Kind kind;
    union {
        int number;
        const char *text;
    } as;
} Value;

int main(void) {
    Value a = { INT_VALUE, { .number = 42 } };
    Value b = { TEXT_VALUE, { .text = "hello" } };

    if (a.kind == INT_VALUE) printf("%d\n", a.as.number);
    if (b.kind == TEXT_VALUE) printf("%s\n", b.as.text);
    return 0;
}
```

The `kind` field records which member of the union is valid. This pattern, called a tagged union, is how many C libraries represent values of several types.

## Recap

- An enum names a set of integer constants. Values count up from 0 unless you assign them.
- A typedef gives a type a new name. It changes the name, not the type.
- A union stores one value at a time in shared memory, sized to its largest member.
- Use a tag, such as an enum, to record which union member is active.

**Up next:** the preprocessor, which runs before the compiler and handles `#include`, `#define` and macros.
', 0, '[]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_6_3', 'sec_c_basics_6', 'crs_c_basics', 'The preprocessor: #include, #define and macros', 'interactive', 2, 1080, NULL, NULL, 'Before the compiler sees your code, a separate step called the preprocessor reads it. The preprocessor handles every line that starts with `#`. It pastes in other files, replaces names with text, and includes or excludes parts of your file depending on conditions. Understanding it removes the mystery of `#include` and explains why some macros behave in strange ways.

## #include: pasting files

`#include` inserts the contents of another file at that point. For standard headers you use angle brackets, and for your own files you use quotes.

```c
#include <stdio.h>      /* a standard library header */
#include "geometry.h"   /* a header in your own project */
```

A header file usually holds declarations: prototypes, types, enums and macros that several source files need. The definitions go into a `.c` file, which the compiler builds once. Headers are how C shares code between files without repeating it.

## Include guards

A header included twice in the same compilation can cause duplicate definitions. An include guard prevents that. The first time the header is read, a macro is defined. Later attempts see the macro and skip the contents.

```c
#ifndef POINT_H
#define POINT_H

struct point {
    int x;
    int y;
};

#endif
```

Every header you write should have a guard, with a name that is unique to the file. Most projects use the file name in capitals, with an underscore in place of the dot.

## #define: object-like macros

`#define` replaces a name with text. Constants are the most common use, because a named constant is clearer than a number that appears in many places.

```c
#include <stdio.h>

#define MAX_STUDENTS 30

int main(void) {
    int roster[MAX_STUDENTS] = {0};
    printf("capacity: %d\n", MAX_STUDENTS);
    return 0;
}
```

The preprocessor does plain text replacement. It does not check types, and it does not create a variable, so a macro has no address and no scope.

## Conditional compilation

`#ifdef` and `#ifndef` include code only when a macro is defined or not defined. This is how programs turn debugging output on and off, and how one source file works on several platforms.

```c predict id=ifdef title="What does this print?"
#include <stdio.h>

#define DEBUG

int main(void) {
#ifdef DEBUG
    printf("debug on\n");
#else
    printf("debug off\n");
#endif
    return 0;
}
--- options
* debug on
debug off
both lines
nothing
--- explain
`DEBUG` is defined before the `#ifdef`, so the preprocessor keeps the first `printf` and removes the `#else` branch. The compiler never sees the other branch at all. You can also define a macro on the command line with `-DDEBUG`, which switches the feature on without editing the source.
```

## Function-like macros

A macro can take parameters, which gives you small pieces of code that look like function calls. Because they are text replacement, they must be written with care.

```c predict id=macro-square title="What does this print?"
#include <stdio.h>

#define SQUARE(x) x * x

int main(void) {
    printf("%d\n", SQUARE(2 + 1));
    return 0;
}
--- options
* 5
9
6
3
--- explain
The macro replaces `SQUARE(2 + 1)` with `2 + 1 * 2 + 1`, which is not `(2 + 1) * (2 + 1)`. Multiplication happens first, giving `2 + 2 + 1`, which is 5. Wrap every parameter and the whole body in parentheses to prevent exactly this: `#define SQUARE(x) ((x) * (x))`.
```

> **Pitfall:** Macros that look like function calls can evaluate their arguments more than once. `SQUARE(i++)` increments `i` twice. Use a real function when you need the arguments evaluated exactly once.

## Stringizing

The `#` operator inside a macro turns its parameter into a string literal. It is handy for printing the name of a variable or a value while you debug.

```c predict id=stringize title="What does this print?"
#include <stdio.h>

#define SHOW(name) printf("%s\n", #name)

int main(void) {
    SHOW(hello);
    return 0;
}
--- options
* hello
hello\n
name
SHOW(hello)
--- explain
The `#name` form turns the argument `hello` into the string `"hello"`. The macro then expands to a `printf` call that prints that string. The original token is not evaluated, so `hello` does not need to be a variable at all.
```

## Recap

- The preprocessor runs before the compiler and handles lines that begin with `#`.
- `#include` pastes a file in. Headers hold declarations, and include guards stop double inclusion.
- `#define` replaces text. Use it for named constants, and remember it has no types or scope.
- `#ifdef` and `#ifndef` include code conditionally.
- Parenthesize macro parameters, and never pass side effects into them.

**Up next:** reading and writing files, where errors are common and checking them is part of the job.
', 0, '[]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_6_4', 'sec_c_basics_6', 'crs_c_basics', 'Reading and writing files safely', 'interactive', 3, 1080, NULL, NULL, 'Programs that forget everything when they exit are of limited use. C reads and writes files through the `FILE` type and a small set of functions in `<stdio.h>`. Each step can fail, and the most important habit in file handling is checking the result of every call. The file system is outside your program''s control, so a file may be missing, locked or full, and your code should expect that.

## The basic cycle

Every file operation follows the same three steps: open the file, read or write it, then close it. `fopen` returns a pointer to a `FILE`, or `NULL` if the open fails. `fclose` releases the file when you finish.

```c
#include <stdio.h>

int main(void) {
    FILE *out = fopen("notes.txt", "w");
    if (out == NULL) {
        perror("notes.txt");
        return 1;
    }
    fprintf(out, "Remember the milk\n");
    fclose(out);
    return 0;
}
```

The mode string decides how the file is opened. `"r"` reads an existing file, `"w"` creates or replaces a file for writing, and `"a"` appends to the end of a file. Adding a `b`, as in `"rb"`, opens the file in binary mode, which matters for non-text data and on Windows.

`perror` prints a message to standard error that describes why the last call failed, which is far more useful than a generic message.

> **Pitfall:** `"w"` erases the file''s previous contents as soon as it opens. Use `"a"` if you want to keep existing data.

## Writing with fprintf and fputs

`fprintf` works like `printf`, but it writes to a file. `fputs` writes a string without a format.

```c predict id=fputs-fgets title="What does this print?"
#include <stdio.h>

int main(void) {
    FILE *f = fopen("note.txt", "w");
    fputs("line one\nline two\n", f);
    fclose(f);
    f = fopen("note.txt", "r");
    char buf[64];
    fgets(buf, sizeof buf, f);
    fclose(f);
    printf("%s", buf);
    return 0;
}
--- options
* line one
line two
line one line two
(empty output)
--- explain
The program writes two lines, closes the file, then reopens it for reading. `fgets` reads the first line, including its newline, into `buf`. The `printf` shows only that first line, because `fgets` stops after one line. Notice that the file was closed and reopened between writing and reading, so the reader sees everything that was written.
```

## Reading with fgets

`fgets` reads one line at a time and never writes past the buffer you give it. That makes it the safest way to read text. It keeps the newline, so you usually strip it, as lesson 14 showed.

```c predict id=fgets-newline title="What does this print?"
#include <stdio.h>
#include <string.h>

int main(void) {
    FILE *f = fopen("sample.txt", "w");
    fputs("abc\n", f);
    fclose(f);
    f = fopen("sample.txt", "r");
    char line[16];
    fgets(line, sizeof line, f);
    fclose(f);
    printf("%zu\n", strlen(line));
    return 0;
}
--- options
* 4
3
5
16
--- explain
The file contains `abc` followed by a newline, which `fgets` keeps. So the line holds four characters before the terminator: `a`, `b`, `c` and the newline. That is why `strlen` reports 4. Stripping the newline is one of the first things a text-processing program does.
```

## Checking for failure

Opening a file that does not exist with `"r"` returns `NULL`. The program should report the problem and decide what to do, rather than continuing as if the file were open.

```c predict id=fopen-null title="What does this print?"
#include <stdio.h>

int main(void) {
    FILE *f = fopen("no_such_file_here.txt", "r");
    if (f == NULL) {
        printf("missing\n");
        return 1;
    }
    fclose(f);
    printf("found\n");
    return 0;
}
--- options
* missing
found
missing and found
a crash
--- explain
The file `no_such_file_here.txt` does not exist, so `fopen` returns `NULL`. The `if` branch prints `missing` and returns 1, which tells the operating system the program failed. Without that check, the program would call `fclose` on a null pointer, which is undefined behavior. Assume the question''s file does not exist, as it is named to be absent.
```

> **Tip:** Check the result of every `fopen`, `fgets`, `fprintf` and `fclose`. `fclose` can fail too, for example when the disk is full and buffered data cannot be written. Ignoring that failure is how data quietly disappears.

## Reading numbers

Reading a whole line and then converting it with `sscanf` is safer than calling `fscanf` directly, because a bad line does not leave the file in an unpredictable position. The pattern is simple:

```c
char line[64];
int value;

while (fgets(line, sizeof line, f) != NULL) {
    if (sscanf(line, "%d", &value) == 1) {
        printf("read %d\n", value);
    } else {
        fprintf(stderr, "skipping a bad line\n");
    }
}
```

The loop stops at the end of the file, because `fgets` returns `NULL` then. Each line is checked on its own, so one bad entry does not stop the rest.

## Binary files, briefly

For images, saved structs and other non-text data, use `fwrite` and `fread`, which move raw bytes. They take a pointer, an element size, a count and the file. Open such files with `"wb"` and `"rb"`, so the bytes are not changed by text translation on Windows. You will use them in the contacts project.

## Recap

- Open with `fopen`, check for `NULL`, then close with `fclose`.
- `"w"` replaces a file, `"a"` appends, and `"r"` reads.
- `fprintf` and `fputs` write, and `fgets` reads a line safely with a size limit.
- Check every file call. Report failures with `perror` and return an error code.
- Read whole lines and parse them, so one bad line does not break the rest.

**Up next:** a quiz on structs, files and the preprocessor, then the first of three capstone projects.
', 0, '[]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_6_5', 'sec_c_basics_6', 'crs_c_basics', 'Checkpoint: structs, files & the preprocessor', 'quiz', 4, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"After `struct point a = {1, 2}; struct point b = a; b.x = 10;`, what is `a.x`?","options":["10","1","11","It is undefined"],"answerIndex":1,"explanation":"Assigning one struct to another copies all its members. `b` is an independent copy, so changing `b.x` leaves `a.x` at 1."},{"id":"q2","prompt":"Given `struct item *it`, which expression changes the member `qty` through the pointer?","options":["it.qty += 5","it->qty += 5","*it.qty += 5","it::qty += 5"],"answerIndex":1,"explanation":"The arrow `->` reaches a member through a pointer to a struct, and it is shorthand for `(*it).qty`. The dot works only on a struct value."},{"id":"q3","prompt":"What is the value of `MEDIUM` in `enum level { LOW, MEDIUM = 5, HIGH };`?","options":["1","2","5","6"],"answerIndex":2,"explanation":"`MEDIUM` is assigned the value 5 explicitly. `HIGH` would then be 6, but `MEDIUM` itself is 5."},{"id":"q4","prompt":"Why does `#define SQUARE(x) x * x` give 5 for `SQUARE(2 + 1)`?","options":["Because the macro adds 1 to the argument","Because the macro expands to `2 + 1 * 2 + 1`, and multiplication happens first","Because macros evaluate their arguments in a separate scope","Because the compiler rejects the argument"],"answerIndex":1,"explanation":"The preprocessor replaces the text literally, so the body becomes `2 + 1 * 2 + 1`. Wrapping the parameter and body in parentheses prevents this."},{"id":"q5","prompt":"Why should `fopen` be followed by a check for `NULL`?","options":["Because fopen always returns NULL on success","Because fopen returns NULL when the file cannot be opened, and using that pointer is undefined behavior","Because the file is always open after fopen","Because fclose needs the check first"],"answerIndex":1,"explanation":"If the file cannot be opened, `fopen` returns `NULL`. Passing that pointer to `fgets` or `fclose` is undefined behavior, so check the result and report the failure."}]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_7_1', 'sec_c_basics_7', 'crs_c_basics', 'Project 1: a grade report with arrays, loops and functions', 'interactive', 0, 1800, NULL, NULL, 'Time to put the first half of the course to work. In this project you will build a grade report. It stores scores for several students, computes each student''s average, turns the average into a letter grade and prints a neat table. It uses arrays, loops, functions, `if` statements and formatted output, which are the tools from lessons 01 to 14. There is no new syntax here. The point is to combine what you know into a program that does something useful.

## The plan

Before you write any code, decide what the program needs:

1. Store the students'' names and their scores for each subject.
2. Compute an average for one student''s scores.
3. Turn an average into a letter grade.
4. Print a table with one row per student.

Each step becomes one function or one loop. Keeping the steps separate means you can check each one with a predict question before you put them together.

## Step 1: the data

Two arrays hold the data. A two-dimensional array of scores works well here, because each row belongs to one student. The `static` keyword keeps the data private to this file, and `const` says the program does not change it.

```c
#include <stdio.h>

#define STUDENTS 3
#define SUBJECTS 3

static const char *names[STUDENTS] = {"Ada", "Linus", "Grace"};
static const int scores[STUDENTS][SUBJECTS] = {
    {92, 88, 95},
    {71, 64, 80},
    {85, 90, 78},
};
```

## Step 2: the average

The average function takes a pointer to a row of scores and the number of subjects. It returns a `double`, because a division of integers would throw the fraction away. Lesson 04 explains the trap.

```c predict id=average-type title="What does this print?"
#include <stdio.h>

double average(const int values[], int count) {
    int total = 0;
    for (int i = 0; i < count; i++) {
        total += values[i];
    }
    return (double)total / count;
}

int main(void) {
    int marks[] = {80, 83};
    printf("%.1f\n", average(marks, 2));
    return 0;
}
--- options
* 81.5
81
82.0
80.0
--- explain
The total is 163. Casting the total to `double` before dividing gives 81.5, and `%.1f` prints it with one decimal. If the cast were missing, the division would be an integer division that truncates to 81. The parameter `const int values[]` is really a pointer, which is why the length has to be passed in too.
```

```c predict id=integer-trap title="What does this print?"
#include <stdio.h>

int main(void) {
    int marks[] = {80, 83};
    printf("%d\n", (marks[0] + marks[1]) / 2);
    return 0;
}
--- options
* 81
81.5
82
80
--- explain
Both operands are `int`, so `/` performs integer division. The sum 163 divided by 2 truncates to 81. This is the same trap the average function avoids with its cast, and it is why the cast belongs on the division, not on the sum.
```

## Step 3: the letter grade

A chain of `if` statements that tests the highest threshold first is clear and correct. Each test assumes the earlier ones failed, so the thresholds do not need to overlap.

```c predict id=letter-grade title="What does this print?"
#include <stdio.h>

char letter_grade(double avg) {
    if (avg >= 90) return ''A'';
    if (avg >= 80) return ''B'';
    if (avg >= 70) return ''C'';
    if (avg >= 60) return ''D'';
    return ''F'';
}

int main(void) {
    printf("%c\n", letter_grade(89.5));
    return 0;
}
--- options
* B
A
C
F
--- explain
The first test, `avg >= 90`, is false for 89.5. The second, `avg >= 80`, is true, so the function returns `''B''`. Testing from the highest threshold down means each `if` can rely on the ones above it having failed.
```

## Step 4: the table

`main` loops over the students, computes each average, and prints a row. The header uses the same widths as the rows, so the columns line up.

```c
int main(void) {
    printf("%-8s %8s %6s\n", "Name", "Average", "Grade");
    for (int s = 0; s < STUDENTS; s++) {
        double avg = average(scores[s], SUBJECTS);
        printf("%-8s %8.2f %6c\n", names[s], avg, letter_grade(avg));
    }
    return 0;
}
```

## The whole program

Put the pieces together in one file. Notice that the functions come before `main`, so the compiler has seen their definitions by the time `main` calls them.

```c
#include <stdio.h>

#define STUDENTS 3
#define SUBJECTS 3

static const char *names[STUDENTS] = {"Ada", "Linus", "Grace"};
static const int scores[STUDENTS][SUBJECTS] = {
    {92, 88, 95},
    {71, 64, 80},
    {85, 90, 78},
};

double average(const int values[], int count) {
    int total = 0;
    for (int i = 0; i < count; i++) {
        total += values[i];
    }
    return (double)total / count;
}

char letter_grade(double avg) {
    if (avg >= 90) return ''A'';
    if (avg >= 80) return ''B'';
    if (avg >= 70) return ''C'';
    if (avg >= 60) return ''D'';
    return ''F'';
}

int main(void) {
    printf("%-8s %8s %6s\n", "Name", "Average", "Grade");
    for (int s = 0; s < STUDENTS; s++) {
        double avg = average(scores[s], SUBJECTS);
        printf("%-8s %8.2f %6c\n", names[s], avg, letter_grade(avg));
    }
    return 0;
}
```

Compile it with `gcc -std=c11 -Wall -Wextra -pedantic grades.c -o grades`. The output should be:

```text
Name      Average  Grade
Ada         91.67      A
Linus       71.67      C
Grace       84.33      B
```

## Extend it

- Add a fourth student by changing `STUDENTS` and adding a row to each array. Notice that nothing else needs to change.
- Print the class average under the table, computed from the student averages.
- Find the top student by keeping track of the highest average in a loop.

> **Pitfall:** If you add a student to `names` but forget to add a row to `scores`, the two arrays fall out of step and the program prints the wrong name next to the wrong marks. Keeping related data in matching positions is a constant concern in C, and the next project replaces this approach with structs.

## Recap

- Arrays and loops are the core of most data processing, and a two-dimensional array holds rows of related values.
- Functions with clear inputs and outputs are easy to check one at a time.
- Compute averages with a `double` division. An integer division truncates.
- A chain of `if` statements that tests the highest threshold first gives correct, readable grades.

**Up next:** a contact book that keeps its records in a file, using structs and everything from the file I/O lesson.
', 0, '[]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_7_2', 'sec_c_basics_7', 'crs_c_basics', 'Project 2: a contact book with structs and file storage', 'interactive', 1, 2100, NULL, NULL, 'Real programs remember things between runs. In this project you will build a small contact book. It reads contacts from a file when it starts, lets you add one, shows the whole list and saves the result back to the file. The project brings together structs, arrays of structs, string handling, `fgets`, `snprintf` and safe file I/O, which are the lessons from the second half of the course.

## The plan

The contact book needs four things:

1. A `Contact` struct that holds a name and a phone number.
2. A way to load contacts from a text file, one per line.
3. A way to save contacts back to that file.
4. A `main` function that asks for a new contact, then shows and saves the list.

The file format is simple. Each contact is one line with the name, a comma and the phone number:

```text
Ada,555-0101
Grace,555-0199
```

Because the separator is a comma, names must not contain commas. The program checks for that, which is a design decision you will see below.

## Step 1: the struct and its limits

Fixed-size character arrays hold the text. Named constants keep the sizes in one place, so changing a limit touches one line.

```c
#include <stdio.h>
#include <string.h>

#define MAX_NAME 40
#define MAX_PHONE 20
#define MAX_CONTACTS 100
#define FILE_NAME "contacts.txt"

typedef struct {
    char name[MAX_NAME];
    char phone[MAX_PHONE];
} Contact;
```

The `typedef` lets the rest of the code write `Contact` instead of `struct`.

## Step 2: parsing a line

Splitting a line at the comma is the core trick of the loader. `strchr` finds the comma, replacing it with `''\0''` ends the name at that point, and `comma + 1` is the start of the phone number. Predict what that split produces:

```c predict id=split-line title="What does this print?"
#include <stdio.h>
#include <string.h>

int main(void) {
    char line[] = "Ada,555-0101";
    char *comma = strchr(line, '','');
    *comma = ''\0'';
    printf("%s|%s\n", line, comma + 1);
    return 0;
}
--- options
* Ada|555-0101
Ada,555-0101|
Ada|
Ada,|555-0101
--- explain
`strchr` returns a pointer to the comma. Writing `''\0''` into that position ends the first string at `Ada`, so `line` now reads `Ada`. The character after the comma, `comma + 1`, still points into the same array and reads `555-0101`. Both halves live in one buffer, which is why the split costs no copying.
```

Lines read with `fgets` end in a newline, which must be removed from the phone number. Here is the loader:

```c
static int load_contacts(Contact list[], int capacity) {
    FILE *f = fopen(FILE_NAME, "r");
    if (f == NULL) return 0;          /* no file yet: start with an empty book */

    int count = 0;
    char line[MAX_NAME + MAX_PHONE + 2];
    while (count < capacity && fgets(line, sizeof line, f) != NULL) {
        char *comma = strchr(line, '','');
        if (comma == NULL) continue;  /* skip lines that are not contacts */

        *comma = ''\0'';
        char *phone = comma + 1;
        phone[strcspn(phone, "\n")] = ''\0'';

        snprintf(list[count].name, MAX_NAME, "%s", line);
        snprintf(list[count].phone, MAX_PHONE, "%s", phone);
        count++;
    }
    fclose(f);
    return count;
}
```

`snprintf` copies the text with a size limit, so a very long name is truncated rather than overflowing the struct. That safety is the reason to prefer it over `strcpy`.

## Step 3: saving the book

Saving reverses the format. The file is replaced each time, so the program always writes the complete list.

```c
static int save_contacts(const Contact list[], int count) {
    FILE *f = fopen(FILE_NAME, "w");
    if (f == NULL) return 0;

    for (int i = 0; i < count; i++) {
        fprintf(f, "%s,%s\n", list[i].name, list[i].phone);
    }
    return fclose(f) == 0;            /* fclose can fail too, for example on a full disk */
}
```

The format string decides what lands in the file, so predict the line that `save_contacts` would write for one contact:

```c predict id=save-format title="What line is written to the file?"
#include <stdio.h>

int main(void) {
    const char *name = "Ada";
    const char *phone = "555-0101";
    fprintf(stdout, "%s,%s\n", name, phone);
    return 0;
}
--- options
* Ada,555-0101
Ada 555-0101
Ada,555-0101,
555-0101,Ada
--- explain
`fprintf` with `stdout` writes to the screen, exactly as the saver writes to the file. The format puts the name first, then a comma with no spaces, then the phone number, then a newline. That exact shape is what the loader expects when it splits the line at the comma.
```

Checking the result of `fclose` matters. Buffered data is written at that moment, so a failure there means the file is incomplete.

## Step 4: growing without a limit

The book holds at most `MAX_CONTACTS` entries in this version. Before you add one, check the count. The predict question below shows how a capacity check behaves as items arrive:

```c predict id=capacity-check title="What does this print?"
#include <stdio.h>

int main(void) {
    int cap = 2, count = 0;
    for (int i = 0; i < 5; i++) {
        if (count == cap) cap *= 2;
        count++;
    }
    printf("%d %d\n", count, cap);
    return 0;
}
--- options
* 5 8
5 4
5 2
4 8
--- explain
Trace it: the capacity starts at 2, and the count reaches 2 on the third iteration, so the capacity doubles to 4. The count reaches 4 on the fifth iteration, so the capacity doubles to 8. The count finishes at 5. This doubling strategy is how real dynamic arrays grow, and lesson 17''s `realloc` is the tool for resizing the real memory.
```

## Step 5: the main program

The `main` function reads a name and a phone number, checks them, adds the contact, prints the list and saves the file.

```c
int main(void) {
    Contact book[MAX_CONTACTS];
    int count = load_contacts(book, MAX_CONTACTS);

    char name[MAX_NAME];
    char phone[MAX_PHONE];

    printf("Name: ");
    if (fgets(name, sizeof name, stdin) == NULL) return 1;
    printf("Phone: ");
    if (fgets(phone, sizeof phone, stdin) == NULL) return 1;

    name[strcspn(name, "\n")] = ''\0'';
    phone[strcspn(phone, "\n")] = ''\0'';

    if (name[0] == ''\0'' || strchr(name, '','') != NULL) {
        printf("Names must be non-empty and cannot contain commas.\n");
        return 1;
    }
    if (count < MAX_CONTACTS) {
        snprintf(book[count].name, MAX_NAME, "%s", name);
        snprintf(book[count].phone, MAX_PHONE, "%s", phone);
        count++;
    }

    printf("\n%-40s %s\n", "Name", "Phone");
    for (int i = 0; i < count; i++) {
        printf("%-40s %s\n", book[i].name, book[i].phone);
    }

    if (!save_contacts(book, count)) {
        perror(FILE_NAME);
        return 1;
    }
    return 0;
}
```

The check `strchr(name, '','') != NULL` protects the file format. Without it, a name such as `Smith, Ada` would be saved as two fields and read back wrongly. Validating input at the boundary keeps bad data out of the file.

## The whole program

Here is the complete file, in the order it reads from top to bottom. The helper functions are `static` because only this file uses them.

```c
#include <stdio.h>
#include <string.h>

#define MAX_NAME 40
#define MAX_PHONE 20
#define MAX_CONTACTS 100
#define FILE_NAME "contacts.txt"

typedef struct {
    char name[MAX_NAME];
    char phone[MAX_PHONE];
} Contact;

static int load_contacts(Contact list[], int capacity) {
    FILE *f = fopen(FILE_NAME, "r");
    if (f == NULL) return 0;

    int count = 0;
    char line[MAX_NAME + MAX_PHONE + 2];
    while (count < capacity && fgets(line, sizeof line, f) != NULL) {
        char *comma = strchr(line, '','');
        if (comma == NULL) continue;

        *comma = ''\0'';
        char *phone = comma + 1;
        phone[strcspn(phone, "\n")] = ''\0'';

        snprintf(list[count].name, MAX_NAME, "%s", line);
        snprintf(list[count].phone, MAX_PHONE, "%s", phone);
        count++;
    }
    fclose(f);
    return count;
}

static int save_contacts(const Contact list[], int count) {
    FILE *f = fopen(FILE_NAME, "w");
    if (f == NULL) return 0;

    for (int i = 0; i < count; i++) {
        fprintf(f, "%s,%s\n", list[i].name, list[i].phone);
    }
    return fclose(f) == 0;
}

int main(void) {
    Contact book[MAX_CONTACTS];
    int count = load_contacts(book, MAX_CONTACTS);

    char name[MAX_NAME];
    char phone[MAX_PHONE];

    printf("Name: ");
    if (fgets(name, sizeof name, stdin) == NULL) return 1;
    printf("Phone: ");
    if (fgets(phone, sizeof phone, stdin) == NULL) return 1;

    name[strcspn(name, "\n")] = ''\0'';
    phone[strcspn(phone, "\n")] = ''\0'';

    if (name[0] == ''\0'' || strchr(name, '','') != NULL) {
        printf("Names must be non-empty and cannot contain commas.\n");
        return 1;
    }
    if (count < MAX_CONTACTS) {
        snprintf(book[count].name, MAX_NAME, "%s", name);
        snprintf(book[count].phone, MAX_PHONE, "%s", phone);
        count++;
    }

    printf("\n%-40s %s\n", "Name", "Phone");
    for (int i = 0; i < count; i++) {
        printf("%-40s %s\n", book[i].name, book[i].phone);
    }

    if (!save_contacts(book, count)) {
        perror(FILE_NAME);
        return 1;
    }
    return 0;
}
```

Run it twice. The second run should show the contact you added the first time, because the file persisted between runs.

## Extend it

- Add a search command that prints every contact whose name contains a word the user types. `strstr` does the matching.
- Reject duplicate names before adding a new contact.
- Add a `delete` option that removes a contact by its position and saves the list.

> **Pitfall:** `fgets` leaves the newline in place, and if you forget to remove it, the saved phone numbers gain an extra blank line each time. The `strcspn` trick removes it, and you should check that every input path does the same.

## Recap

- Structs keep related fields together, and a `typedef` makes them easy to name.
- Split delimited text in place with `strchr` and a terminator, and strip newlines with `strcspn`.
- Save the whole data set each time, and check the result of `fclose`.
- Validate input at the boundary, so bad data never reaches the file.
- Prefer `snprintf` for copies, so the buffers cannot overflow.

**Up next:** the final project, which works with strings and pointers to count words and letters in a piece of text.
', 0, '[]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z'),
('les_c_basics_7_3', 'sec_c_basics_7', 'crs_c_basics', 'Project 3: word statistics with strings and pointers', 'interactive', 2, 2100, NULL, NULL, 'The last project works with text. You will build a word-statistics tool that reads a sentence from the user, counts its characters, words and vowels, and prints a lowercase copy. The work is done with the pointers from lessons 15 and 16 and the strings from lesson 14, and it uses `<ctype.h>` to classify characters. This is the kind of small text-processing tool that real systems are full of.

## The plan

The program has three jobs, and each one becomes a function:

1. Count the words, where a word is a run of non-space characters.
2. Count the vowels, ignoring case.
3. Convert the text to lowercase, in place.

Each job walks the string with a pointer, stopping at the terminator. Keep that loop shape in mind, because you will write it again and again in C.

## Walking a string with a pointer

A pointer that moves along a string, reading one character at a time until it reaches `''\0''`, is the basic pattern for text work. Predict what this loop prints:

```c predict id=vowel-loop title="What does this print?"
#include <stdio.h>
#include <string.h>

int main(void) {
    const char *s = "Hello, C!";
    int vowels = 0;
    for (const char *p = s; *p != ''\0''; p++) {
        if (strchr("aeiouAEIOU", *p) != NULL) vowels++;
    }
    printf("%d\n", vowels);
    return 0;
}
--- options
* 2
3
1
0
--- explain
The pointer `p` visits each character. The vowels in `Hello, C!` are `e` and `o`, so the count is 2. The loop stops at the terminator, which is the condition `*p != ''\0''`, so `strchr` is never asked about the terminator. Checking membership with `strchr` against a string of letters is a compact idiom.
```

> **Tip:** `strchr(list, c)` returns a non-null pointer when `c` is in `list`. That makes it a short way to ask "is this character one of these?"

## Counting words

A word begins when a non-space character follows a space, or the start of the text. A small state variable records whether the walk is currently inside a word. Predict the count for a sentence with an extra space:

```c predict id=word-count title="What does this print?"
#include <ctype.h>
#include <stdio.h>

static int count_words(const char *text) {
    int words = 0;
    int in_word = 0;

    for (const char *p = text; *p != ''\0''; p++) {
        if (isspace((unsigned char)*p)) {
            in_word = 0;
        } else if (!in_word) {
            in_word = 1;
            words++;
        }
    }
    return words;
}

int main(void) {
    printf("%d\n", count_words("one two  three"));
    return 0;
}
--- options
* 3
4
2
5
--- explain
Each time the walk moves from a space into a non-space character, the program starts a new word. The double space between `two` and `three` does not create an empty word, because `in_word` is already 0 and the space itself does not increase the count. So the answer is 3. Casting to `unsigned char` before `isspace` avoids undefined behavior with characters that have negative `char` values.
```

> **Pitfall:** The `<ctype.h>` functions take an `int` that must be representable as an `unsigned char` or equal to `EOF`. Passing a plain `char` with a negative value is undefined. Cast with `(unsigned char)` each time.

## Lowercasing in place

Converting text in place means changing each character where it sits, which needs a pointer to write through. `tolower` returns the lowercase form of a character, and the same cast applies.

```c predict id=lowercase title="What does this print?"
#include <ctype.h>
#include <stdio.h>

int main(void) {
    char word[] = "MiXeD";
    for (char *p = word; *p != ''\0''; p++) {
        *p = (char)tolower((unsigned char)*p);
    }
    printf("%s\n", word);
    return 0;
}
--- options
* mixed
MiXeD
MIXED
mIxEd
--- explain
The pointer `p` walks the array, and each character is replaced with its lowercase form. `word` is a writable array, so the writes stay in place. Note that `char word[] = "MiXeD";` makes a modifiable copy of the text. A pointer assigned directly to a string literal, such as `char *s = "MiXeD";`, would point to read-only memory, and writing through it would be undefined behavior.
```

## The whole program

Here is the complete tool. It reads one line, makes a lowercase copy, and reports the statistics. Read it top to bottom, and notice how each function is small enough to check on its own.

```c
#include <ctype.h>
#include <stdio.h>
#include <string.h>

#define MAX_LINE 256

static int count_words(const char *text) {
    int words = 0;
    int in_word = 0;

    for (const char *p = text; *p != ''\0''; p++) {
        if (isspace((unsigned char)*p)) {
            in_word = 0;
        } else if (!in_word) {
            in_word = 1;
            words++;
        }
    }
    return words;
}

static int count_vowels(const char *text) {
    int vowels = 0;
    for (const char *p = text; *p != ''\0''; p++) {
        if (strchr("aeiou", tolower((unsigned char)*p)) != NULL) vowels++;
    }
    return vowels;
}

static void lowercase(char *text) {
    for (char *p = text; *p != ''\0''; p++) {
        *p = (char)tolower((unsigned char)*p);
    }
}

int main(void) {
    char line[MAX_LINE];

    printf("Enter a sentence: ");
    if (fgets(line, sizeof line, stdin) == NULL) return 1;
    line[strcspn(line, "\n")] = ''\0'';

    char lower[MAX_LINE];
    snprintf(lower, sizeof lower, "%s", line);
    lowercase(lower);

    printf("characters: %zu\n", strlen(line));
    printf("words:      %d\n", count_words(line));
    printf("vowels:     %d\n", count_vowels(lower));
    printf("lowercase:  %s\n", lower);
    return 0;
}
```

For the input `Hello, C world`, the output is:

```text
characters: 14
words:      3
vowels:     3
lowercase:  hello, c world
```

Work through one line yourself to confirm it. The text has 14 characters, three words, and three vowels, which are the `e` and two `o`s.

## Extend it

- Count how often each vowel appears, using an array of five counters indexed by the vowel''s position in `"aeiou"`.
- Find the longest word. Walk the text once, track the length of the current word, and save the start of the longest one with a pointer.
- Read several lines in a loop and print totals at the end, stopping when `fgets` returns `NULL`.

> **In the wild:** Word counters, character counters and search tools are built from exactly these loops. Editors, log analyzers and compilers all walk text with pointers and classify characters with `<ctype.h>`.

## Recap

- Walk a string with a `const char *` pointer until you reach `''\0''`.
- Use a state variable, such as `in_word`, to recognize the start and end of a run of characters.
- Classify characters with `<ctype.h>`, casting to `unsigned char` each time.
- Modify text in place only through an array you own. A string literal is read-only.
- Break a tool into small functions, each one easy to check.

**Up next:** you have finished C Basics. Continue to C Advanced, which covers dynamic data structures, undefined behavior, sanitizers and secure coding.
', 0, '[]', '[]', '2026-06-25T06:04:00.699Z', '2026-10-19T06:04:00.699Z');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_c_basics_1', 'usr_seed00000n', 'crs_c_basics', 5, 'Finally clicked', 'I''d tried learning this from scattered blog posts and papers. Having a single coherent narrative with good visuals made it click. The capstone tied everything together.', '2026-09-07T22:04:00.699Z', '2026-09-07T22:04:00.699Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000n');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_c_basics_2', 'usr_seed00001j', 'crs_c_basics', 5, 'Worth every minute', 'Clear, well-paced and incredibly practical. The projects were challenging in the right way, and I used what I learned at work within a week of finishing.', '2026-09-05T01:04:00.699Z', '2026-09-05T01:04:00.699Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001j');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_c_basics_3', 'usr_seed00003w', 'crs_c_basics', 5, 'Great instructor, great community', 'Questions in the Q&A got thoughtful answers quickly. The notes feature and lesson resources made it easy to review before my exam.', '2026-08-25T07:04:00.699Z', '2026-08-25T07:04:00.699Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00003w');

UPDATE courses SET rating_avg = coalesce((SELECT avg(rating) FROM reviews WHERE course_id = 'crs_c_basics'), 0), rating_count = (SELECT count(*) FROM reviews WHERE course_id = 'crs_c_basics') WHERE id = 'crs_c_basics';
