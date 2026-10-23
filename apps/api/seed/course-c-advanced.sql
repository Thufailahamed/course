DELETE FROM exercise_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_c_advanced');

DELETE FROM quiz_attempts WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_c_advanced');

DELETE FROM notes WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_c_advanced');

DELETE FROM lesson_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_c_advanced');

DELETE FROM discussions WHERE course_id = 'crs_c_advanced';

DELETE FROM certificates WHERE course_id = 'crs_c_advanced';

DELETE FROM enrollments WHERE course_id = 'crs_c_advanced';

DELETE FROM reviews WHERE course_id = 'crs_c_advanced';

DELETE FROM wishlist WHERE course_id = 'crs_c_advanced';

DELETE FROM path_courses WHERE course_id = 'crs_c_advanced';

DELETE FROM coupons WHERE course_id = 'crs_c_advanced';

DELETE FROM lessons WHERE course_id = 'crs_c_advanced';

DELETE FROM sections WHERE course_id = 'crs_c_advanced';

UPDATE order_items SET course_id = NULL WHERE course_id = 'crs_c_advanced';

DELETE FROM courses WHERE id = 'crs_c_advanced';

INSERT OR IGNORE INTO categories (id, slug, name, description, icon, sort_order) VALUES ('cat_programming', 'programming', 'Programming', 'Python from first principles: core language, clean code and real projects.', 'code', 9);

INSERT INTO courses (id, slug, title, subtitle, description, category_id, instructor_id, level, language, price_cents, compare_at_price_cents, currency, thumbnail_key, preview_video_url, accent, status, featured, what_you_learn, requirements, target_audience, tags, duration_minutes, lessons_count, rating_avg, rating_count, students_count, published_at, created_at, updated_at) VALUES
('crs_c_advanced', 'c-advanced', 'C Advanced: Memory, Data Structures and Systems Craft', 'Take full control of C: manage memory safely, build real data structures, and write code you can trust.', 'C rewards the programmers who understand it deeply and punishes everyone else. **C Advanced** is for the people who have learned the syntax and now want the judgment: how the compiler really reads your code, who owns each block of memory, and why a program that "works" on your laptop can still be broken.

## Think like a systems programmer

- **Start from the toolchain.** You will follow a file through preprocessing, compilation, assembly and linking, and learn to read what each stage produces.
- **Master memory.** Ownership rules, leak detection, realloc pitfalls and the discipline that keeps large programs alive.
- **Build the classics yourself.** Linked lists, stacks, queues, binary search trees and hash tables, each implemented with clear invariants and tested edge cases.
- **Write generic, portable code.** Function pointers, comparators, void-pointer containers, X-macros and opaque types, the tools real C libraries are built with.
- **Debug like a professional.** gdb, AddressSanitizer, UndefinedBehaviorSanitizer and Valgrind, used on purpose rather than as a last resort.

## Every lesson is interactive

There are no videos. Each lesson is a guided walkthrough with predict-the-output questions that make you reason about memory, pointers and control flow before you see the answer, plus checkpoint quizzes that test the ideas you need for the projects.

## Finish with real projects

Three capstone projects bring everything together: a **generic dynamic array library**, a **key-value store** with a hash table and file persistence, and a **tokenizer and expression evaluator** that could sit inside a calculator or a configuration language.', 'cat_programming', 'usr_arjun', 'advanced', 'English', 6900, 12900, 'USD', NULL, NULL, 60, 'published', 0, '["Explain what the compiler does with your code, from preprocessing to linking, and why undefined behavior is dangerous","Design ownership rules for heap memory and find leaks and invalid accesses before they reach production","Build linked lists, stacks, queues, binary search trees and hash tables from first principles","Sort any data with qsort, write comparators, and use callbacks and function pointers for flexible APIs","Work with bits, struct layout, unions and type punning with confidence and portable code","Write generic containers with void pointers, handle errors with errno, and debug with gdb and sanitizers","Finish three capstone projects: a generic dynamic array, a persistent key-value store and an expression evaluator"]', '["Complete C Basics, or be comfortable with variables, control flow, functions, arrays, pointers and structs","A C11 compiler such as GCC or Clang on your own machine, for the exercises you choose to run locally"]', '["Programmers who know C syntax and want to write safe, efficient and maintainable systems code","Engineers moving to embedded, operating systems, databases or game engines","Students preparing for systems programming courses and technical interviews","Developers who maintain legacy C and want to understand the memory and undefined behavior traps they inherit"]', '["C","Interactive","Systems","Data Structures","Memory","Advanced"]', 629, 29, 0, 0, 0, '2025-07-25T17:35:47.290Z', '2025-06-25T17:35:47.290Z', '2026-10-06T17:35:47.290Z');

INSERT INTO sections (id, course_id, title, position, created_at) VALUES
('sec_c_advanced_1', 'crs_c_advanced', 'Under the Hood', 0, '2026-06-24T17:35:47.290Z'),
('sec_c_advanced_2', 'crs_c_advanced', 'Memory Mastery', 1, '2026-06-24T17:35:47.290Z'),
('sec_c_advanced_3', 'crs_c_advanced', 'Data Structures & Algorithms', 2, '2026-06-24T17:35:47.290Z'),
('sec_c_advanced_4', 'crs_c_advanced', 'Systems Craft', 3, '2026-06-24T17:35:47.290Z'),
('sec_c_advanced_5', 'crs_c_advanced', 'Capstone Projects', 4, '2026-06-24T17:35:47.290Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_c_advanced_1_1', 'sec_c_advanced_1', 'crs_c_advanced', 'How this course works', 'interactive', 0, 480, NULL, NULL, 'C Basics taught you to make the computer do things. C Advanced teaches you to make the computer do them **safely, predictably and efficiently**, even when the machine is under pressure. That is the difference between code that works in a tutorial and code that runs a database, a kernel, a game engine or an embedded controller for years.

By the end of this course you will be able to follow a source file through the whole toolchain, reason about undefined behavior before it bites you, design clear ownership rules for heap memory, and build the data structures that every serious program relies on. You will also learn to debug with the same tools professionals use, and to write APIs that other people can use without hurting themselves.

## How the lessons work

Every lesson is interactive without being a video. You read a short explanation, then face **predict-the-output** questions on code blocks. Make your guess before you read the explanation, because predicting is how you train the mental model that matters: what the machine does, step by step.

Some code blocks are plain snippets. Read them carefully and trace them with a pencil. Each lesson ends with a recap and a link to the next topic. Section checkpoints test the ideas you need for the projects.

> **Tip:** Keep a notebook of the diagrams you draw. Pointers, memory blocks and tree shapes are easiest to understand when you sketch them. Draw boxes for memory, arrows for pointers, and write the value next to each name.

## What you need

You will read and trace C11 code throughout. If you have a compiler on your own machine (GCC or Clang), try the examples there. A good habit is to compile with warnings on:

```c
// gcc -std=c11 -Wall -Wextra -pedantic program.c -o program
```

You do not need a compiler to finish the course, but running code is the fastest way to confirm what you think you understand.

## The three rules of this course

1. **Know what the compiler is allowed to do.** A correct program follows the language''s rules, not the behavior you observed once.
2. **Every byte has an owner.** Whether it lives on the stack, in static storage or on the heap, someone must be responsible for it.
3. **Make invariants explicit.** A data structure is correct when a set of conditions always holds. Write those conditions down, then keep them true after every operation.

These rules sound abstract now. By the final project, they will feel like common sense.

## Recap

- You will move from using C to designing systems in C.
- Predict the output before you read the answer; it trains the right mental model.
- Compile with `-Wall -Wextra -pedantic`, and keep an eye on every warning.
- Ownership, undefined behavior and invariants are the three themes of the whole course.

**Up next:** Follow a single source file through the compilation pipeline, from preprocessor to linker.
', 1, '[]', '[{"title":"cppreference: C language reference","url":"https://en.cppreference.com/w/c"},{"title":"GCC: Instrumentation options (sanitizers)","url":"https://gcc.gnu.org/onlinedocs/gcc/Instrumentation-Options.html"},{"title":"GDB: The GNU debugger documentation","url":"https://sourceware.org/gdb/documentation/"}]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z'),
('les_c_advanced_1_2', 'sec_c_advanced_1', 'crs_c_advanced', 'From source to executable: the compilation pipeline', 'interactive', 1, 1320, NULL, NULL, 'When you type `gcc main.c -o main`, it looks like one step. It is actually a pipeline of four separate stages, and each one transforms your code in a different way. Knowing the stages turns mysterious errors into obvious ones. A missing semicolon, a misspelled function and an undefined reference each come from a different stage, and each stage has its own fix.

This lesson walks the pipeline in order: preprocessing, compilation, assembly and linking. You will see what each stage produces, and you will learn to predict the output of the first stage, which surprises almost everyone.

## Stage 1: the preprocessor

The preprocessor runs before the compiler proper and works on text. It understands only lines that start with `#`. It does not know C types, scope or even whether your code is valid. Its jobs are:

- **`#include`** pastes the contents of a header file into your source.
- **`#define`** creates macros, which are text substitutions.
- **`#if`, `#ifdef`, `#else` and `#endif`** keep or drop blocks of text.

You can see the result of this stage on its own with `gcc -E main.c`. Reading that output is one of the best ways to understand what you are really compiling.

Macros are substitution, not function calls. This is the first trap of the course:

```c predict id=macro-expand title="What does the macro produce?"
#include <stdio.h>

#define SQUARE(x) x * x

int main(void) {
    printf("%d\n", SQUARE(2 + 1));
    return 0;
}
--- options
9
* 5
6
4
--- explain
The preprocessor pastes the argument text in place, so `SQUARE(2 + 1)` becomes `2 + 1 * 2 + 1`. Multiplication binds tighter than addition, so the expression is `2 + 2 + 1`, which is 5. The fix is parentheses around every parameter and around the whole macro: `#define SQUARE(x) ((x) * (x))`.
```

> **Pitfall:** A macro that looks like a function call is not one. It has no type checking, and it evaluates its arguments every time they appear. `#define MAX(a, b) ((a) > (b) ? (a) : (b))` called as `MAX(i++, j)` increments `i` more than once. Prefer a real function (or an `static inline` function) when you can.

## Stage 2: compilation

The compiler reads the preprocessed text and checks it against the language rules. It parses the tokens into a syntax tree, checks types and scope, and then produces assembly code for the target machine. This is where most of the errors you already know come from: a mismatched type, a missing declaration, or a call with the wrong number of arguments.

The compiler works one translation unit at a time. A translation unit is a single `.c` file after preprocessing. The compiler does not see other `.c` files. That is why a function defined in `helpers.c` must be declared in a header that `main.c` includes: the declaration is the promise that the function exists somewhere else.

## Stage 3: assembly

The assembler turns the assembly text into an **object file**, usually named `main.o` or `main.obj`. An object file is machine code plus a symbol table. It contains:

- the code and data your file defines, with names such as `main` or `helper`,
- a list of the names your file uses but does not define, such as `printf`,
- relocation records that say where addresses must be patched once the final layout is known.

Object files are not runnable yet. They are fragments that still need to be connected.

## Stage 4: linking

The linker combines several object files and libraries into one executable. It resolves each undefined name to a definition somewhere else, places all the code and data in memory, and patches the addresses. When the linker says `undefined reference to ''helper''`, the compiler has done its job. The definition of `helper` was simply never provided to the link.

```c predict id=stringize title="What text does stringizing produce?"
#include <stdio.h>

#define SHOW(expr) #expr

int main(void) {
    printf("%s\n", SHOW(hello   +   world));
    return 0;
}
--- options
hello+world
hello   +   world
* hello + world
SHOW(hello + world)
--- explain
The `#` operator turns a macro argument into a string literal. The preprocessor normalizes the whitespace between tokens to a single space, so `hello   +   world` becomes `"hello + world"`. The macro name itself is not part of the output, and the spaces are not removed entirely.
```

## Conditional compilation

`#if` lets one source file build different programs. It is how portable libraries handle different operating systems and compilers, and how you turn on debug logging without editing the code:

```c
#ifdef DEBUG
#define LOG(msg) fprintf(stderr, "[debug] %s\n", msg)
#else
#define LOG(msg) ((void)0)
#endif
```

You enable the debug build with `gcc -DDEBUG main.c`. The `-D` flag defines a macro from the command line, which is faster than editing the file.

```c predict id=conditional title="Which branch is kept?"
#include <stdio.h>

#define LEVEL 3

#if LEVEL > 2
#define MODE "fast"
#else
#define MODE "safe"
#endif

int main(void) {
    printf("%s\n", MODE);
    return 0;
}
--- options
safe
* fast
MODE
compile error
--- explain
The preprocessor evaluates `LEVEL > 2` before the compiler sees any code. Because `3 > 2` is true, only the first branch survives, and `MODE` becomes `"fast"`. The discarded branch never reaches the compiler, so it does not even need to be valid C.
```

> **In the wild:** Build systems rely on this stage. A header such as `config.h` is generated for each machine, and code tests `#ifdef _WIN32` or `#ifdef __linux__` to choose platform-specific functions.

## Recap

- Preprocessing works on text: `#include` pastes, `#define` substitutes, `#if` selects.
- Macros are substitutions, so parenthesize every parameter and beware of repeated evaluation.
- The compiler checks one translation unit at a time and emits an object file.
- The linker resolves names across object files. Most "undefined reference" errors are missing definitions, not missing declarations.
- `gcc -E` shows the preprocessed output, and it is the best first tool for a confusing macro.

**Up next:** Undefined behavior, the rules that let the compiler assume your code is correct, and why breaking them produces the worst bugs.
', 0, '[]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z'),
('les_c_advanced_1_3', 'sec_c_advanced_1', 'crs_c_advanced', 'Undefined behavior and sequence points', 'interactive', 2, 1440, NULL, NULL, 'Most languages try to protect you from your own mistakes. C does something different. For many kinds of mistakes, the standard says nothing at all. The official term is **undefined behavior** (UB), and it means that the language gives no rules for what happens next. The program might crash, print garbage, work perfectly, or behave correctly today and fail next Tuesday after an upgrade.

This is not a flaw that careful programmers can avoid by luck. It is the price of C''s speed. The compiler is allowed to assume that your program never triggers undefined behavior, and it uses that assumption aggressively to optimize. Once UB happens, the compiler''s reasoning can take the program in directions you never wrote.

This lesson explains what UB is, why it causes such strange bugs, and the rules you must follow to avoid it. The predict questions here use only defined behavior, because you should be able to reason about those precisely first.

## Undefined, unspecified and implementation-defined

The standard uses three related terms, and they mean different things:

| Term | Meaning | Example |
|---|---|---|
| **Undefined behavior** | No requirement at all. Anything can happen. | Reading past the end of an array |
| **Unspecified behavior** | The standard allows several choices, and the program is still valid. | The order in which `f(a(), b())` calls `a` and `b` |
| **Implementation-defined behavior** | The compiler chooses, and must document the choice. | The size of `int`, or whether `char` is signed |

Undefined behavior is the most dangerous, because a compiler does not need to report it. It can silently produce code that does something you did not intend.

## Classic sources of UB

Here are the mistakes that appear most often in real C code:

```c
int a[4];
a[4] = 1;            // out-of-bounds write: undefined

int *p = NULL;
*p = 5;              // dereferencing a null pointer: undefined

int x;
printf("%d\n", x);   // reading an uninitialized variable: undefined

int big = 2147483647;
big = big + 1;       // signed integer overflow: undefined

free(q);
free(q);             // double free: undefined
```

Each line looks harmless. Each one breaks a rule the compiler relies on, and the damage can appear far away from the line that caused it.

> **Pitfall:** Compilers can remove code based on UB. A common example is `if (p + len < p)` used to detect pointer overflow. Because pointer overflow is undefined, the compiler may decide the condition is always false and delete the check. Write checks that are valid in the language, such as comparing `len` with the remaining space.

## Unsigned integers wrap, signed integers do not

This is one of the rules that surprises people most. Unsigned arithmetic is **defined** to wrap around modulo 2 to the power of the width. Signed overflow is undefined. The predict question below uses the defined case:

```c predict id=unsigned-wrap title="What is printed after the increment?"
#include <stdio.h>

int main(void) {
    unsigned char c = 255;
    c++;
    printf("%d\n", c);
    return 0;
}
--- options
256
* 0
255
-1
--- explain
An `unsigned char` holds values from 0 to 255. Incrementing 255 wraps it around to 0, because unsigned arithmetic is defined modulo 256. The output is `0`. A signed overflow with the same numbers would be undefined behavior, which is why you should use unsigned types for values that are meant to wrap, such as hash values and bit masks.
```

## Sequence points: when side effects happen

A **side effect** is a change to a variable, such as `i++` or `x = 5`. C says that every side effect must be complete before the next **sequence point**, which includes the end of a full expression and the call to a function. Modifying the same object twice between sequence points is undefined. `i = i++ + 1;` is an example.

Expressions that read and modify the same variable only once are fine, and the next predict question shows one:

```c predict id=sequence title="What is printed?"
#include <stdio.h>

int main(void) {
    int i = 1;
    int j = i++ + 1;
    printf("%d %d\n", i, j);
    return 0;
}
--- options
1 2
* 2 2
2 3
1 1
--- explain
In `i++ + 1`, the value `1` is read from `i`, and `i` is incremented once. The sum is `1 + 1 = 2`, so `j` becomes `2`. After the statement, `i` is `2`. The variable is modified exactly once in the statement, so the behavior is defined.
```

> **Tip:** Split an expression when you are not sure. `int j = i; i++; j += 1;` is longer, but it cannot be misread. Clarity is worth more than cleverness when the cost of a bug is high.

## Integer division and truncation

Division of integers in C truncates toward zero. It is defined, and it still catches people who expect decimals:

```c predict id=division title="What does this print?"
#include <stdio.h>

int main(void) {
    printf("%d\n", 7 / 2 * 2);
    return 0;
}
--- options
7
* 6
8
3
--- explain
`7 / 2` is evaluated first, because `/` and `*` have the same precedence and associate left to right. Integer division gives `3`, and `3 * 2` is `6`. The original value `7` is lost. Use `7.0 / 2` when you need a fraction.
```

## Writing safe code

You cannot memorize every case, so build habits that keep you away from UB:

- **Check every index and length** before you use it. Keep the length next to the pointer.
- **Initialize every variable** when you declare it.
- **Check the result of every allocation** and every library call that can fail.
- **Use unsigned types** when wraparound is the intent, and check ranges before signed arithmetic.
- **Compile with sanitizers during testing**, which catch many UB cases at run time (you will meet them in lesson 19).

> **In the wild:** Operating systems, browsers and crypto libraries have all shipped security bugs caused by compilers removing checks that depended on UB. The fix was almost always a rewrite of the check to use only defined operations.

## Recap

- Undefined behavior means the standard imposes no rules, and the compiler may assume it never happens.
- Unspecified and implementation-defined behavior are valid but vary; the standard or the compiler documents them.
- Unsigned arithmetic wraps; signed overflow is undefined.
- Never modify an object twice between sequence points.
- Initialize variables, check bounds, check allocations, and test with sanitizers.

**Up next:** `const` and the pointer qualifiers, which let you tell the compiler and your colleagues what a function is allowed to change.
', 0, '[]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z'),
('les_c_advanced_1_4', 'sec_c_advanced_1', 'crs_c_advanced', 'const, volatile and pointer qualifiers', 'interactive', 3, 1200, NULL, NULL, 'Every function in a large program makes a promise about the data it touches. Some functions read a value and never change it. Some take ownership of a buffer. Some are called from an interrupt handler and must see every write to a hardware register. C lets you say all of this in the type system with **qualifiers**: `const`, `volatile` and `restrict`. Used well, they turn comments such as "does not modify the input" into rules the compiler enforces.

This lesson teaches you to read complicated declarations, to use `const` correctly across pointers, and to know when `volatile` is the right tool and when it is a misunderstanding.

## Reading declarations

The hardest part of pointer qualifiers is reading them. Use this rule: start at the name and read outward, one step at a time, choosing the nearest operator first.

```c
int *p;              // p is a pointer to int
const int *p;        // p is a pointer to const int (the int cannot change through p)
int *const p;        // p is a const pointer to int (p itself cannot change)
const int *const p;  // a const pointer to a const int
```

The keyword `const` applies to what is on its **left**, unless nothing is there, in which case it applies to the thing on its right. `const int *` and `int const *` mean the same thing, and the first form is clearer, so use it.

## Pointer to const, const pointer

The two forms do different jobs. A **pointer to const** says "I will not change the data through this pointer". A **const pointer** says "this pointer will always point to the same place". The predict question shows the first form:

```c predict id=pointer-to-const title="Which value is printed?"
#include <stdio.h>

int main(void) {
    int a = 1;
    int b = 2;
    const int *p = &a;
    p = &b;
    printf("%d\n", *p);
    return 0;
}
--- options
1
compile error
undefined
* 2
--- explain
`const int *p` is a pointer to const int, so the pointer can be reassigned. Assigning `&b` makes `p` point to `b`, and `*p` reads `2`. The const only stops writes through `p`, such as `*p = 5`, which would be a compile error.
```

> **Tip:** Put `const` on every pointer parameter that the function only reads. It documents the contract, it lets callers pass const data safely, and it catches accidental writes at compile time.

Now the other form, a const pointer, where the data itself can still change:

```c predict id=const-pointer title="What is printed?"
#include <stdio.h>

int main(void) {
    int a = 1;
    int *const p = &a;
    *p = 9;
    printf("%d\n", a);
    return 0;
}
--- options
1
* 9
compile error
0
--- explain
`int *const p` cannot be reassigned, so `p` always points to `a`. The `int` it points to is not const, so `*p = 9` writes to `a`. Printing `a` shows `9`. Reassigning `p` itself, as in `p = &other;`, would be the compile error.
```

## Passing const data safely

A function that takes `const char *` can accept string literals and read-only data, and it tells callers that the string will survive the call unchanged. Here is the standard library shape:

```c
size_t count_vowels(const char *text);   // reads text, never changes it
int copy_name(char *dest, size_t cap, const char *src);
```

A `const char *` parameter accepts both `char *` and `const char *` arguments. The reverse is not true: you cannot pass a `const` pointer to a function that wants a mutable one without a cast, and a cast here is almost always a bug.

> **Pitfall:** Do not cast away `const` to call a function that modifies data. Modifying an object that was defined as `const` is undefined behavior, even if you got the pointer through a cast. If the function must modify the data, remove the `const` from the parameter.

## Reading a string through const

String literals have static storage, and most compilers place them in read-only memory. You can read them through a `const char *`. The next question checks that you can index them correctly:

```c predict id=const-string title="What character is printed?"
#include <stdio.h>

int main(void) {
    const char *s = "hi";
    printf("%c\n", s[1]);
    return 0;
}
--- options
h
* i
\0
compile error
--- explain
A string is an array of `char`, and `s[0]` is `''h''`, `s[1]` is `''i''`, and `s[2]` is the terminating null byte. The `%c` format prints one character, so the output is `i`. Reading through a `const` pointer is fine; writing to `s[0]` would be undefined behavior, not a compile error, because the literal may be stored in read-only memory.

## volatile: for values that change outside your code

`volatile` tells the compiler that a value may change at any time, for reasons it cannot see. You use it for memory-mapped hardware registers, for variables shared with a signal handler, and for memory written by another device or thread that you are not synchronizing with a proper mechanism:

```c
volatile uint32_t *const status_reg = (volatile uint32_t *)0x4000A000u;

while ((*status_reg & READY_BIT) == 0) {
    /* spin until the device reports ready */
}
```

Without `volatile`, the compiler may read `*status_reg` once, see that the loop never changes it, and turn the loop into an infinite one.

> **Pitfall:** `volatile` is not thread synchronization. It stops the compiler from caching a value in a register, but it does not stop the processor from reordering memory accesses and it does not make operations atomic. For shared data between threads, use the atomic types and mutexes you will meet in later lessons.

## restrict: a promise about aliasing

`restrict` is a promise that, for the lifetime of a pointer, no other pointer used in the same function accesses the same object. It lets the compiler optimize loops that would otherwise need to assume the pointers might overlap:

```c
void scale(float *restrict out, const float *restrict in, size_t n, float k) {
    for (size_t i = 0; i < n; i++) out[i] = in[i] * k;
}
```

If you call `scale(buf, buf, n, 2.0f)` with overlapping pointers, you break the promise, and the behavior is undefined. Use `restrict` when you can guarantee the separation, and leave it off otherwise.

## Recap

- Read declarations from the name outward: `const` binds to what is on its left.
- `const T *` means the data is read-only through this pointer; `T *const` means the pointer cannot be reassigned.
- Accept `const` pointers in every function that only reads data.
- Never modify an object defined as `const`, even through a cast.
- Use `volatile` for values changed outside your program''s control, and never as a substitute for synchronization.

**Up next:** Function pointers, which let you pass behavior as data and build callback tables.
', 0, '[]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z'),
('les_c_advanced_1_5', 'sec_c_advanced_1', 'crs_c_advanced', 'Function pointers and callback tables', 'interactive', 4, 1320, NULL, NULL, 'A variable holds a value. A pointer holds an address. A **function pointer** holds the address of code, and calling through it lets you choose the behavior of a program at run time. This is how C does polymorphism, plugins, event handlers and sorting with custom rules. The standard library''s `qsort` (lesson 12) works this way, and so does almost every game engine''s event system.

This lesson teaches the syntax, which is famously hard to read, and then shows the pattern that makes function pointers useful in real code: the **callback table**.

## The syntax

A function pointer is declared by taking a function''s signature and wrapping the name in `(*name)`:

```c
int add(int a, int b);        // a function
int (*op)(int, int);          // a pointer to a function that takes two ints and returns an int
op = add;                     // the name of a function decays to its address
int result = op(2, 3);        // call through the pointer: result is 5
```

Read the declaration the way you read any declarator: `op` is a pointer, to a function taking `(int, int)`, returning `int`. The parentheses around `*op` are essential. Without them, `int *op(int, int)` declares a function returning a pointer to int.

A `typedef` makes the syntax manageable, and it is how serious libraries write it:

```c
typedef int (*binary_op)(int, int);
```

## Calling through a pointer

You can call a function pointer with or without an explicit dereference. Both forms are valid C, and you will see both in code. The predict question checks the explicit form with a typedef:

```c predict id=typedef-call title="What is printed?"
#include <stdio.h>

typedef int (*binary_op)(int, int);

int add(int a, int b) { return a + b; }
int mul(int a, int b) { return a * b; }

int main(void) {
    binary_op f = mul;
    printf("%d\n", (*f)(2, 5));
    return 0;
}
--- options
7
* 10
25
2
--- explain
`f` holds the address of `mul`. `(*f)` names the function, and `(*f)(2, 5)` calls it with `2` and `5`, so it returns `2 * 5`, which is `10`. The shorter form `f(2, 5)` does the same thing. The output is `10`.
```

## A callback table

The real power comes when you store function pointers in an array or a struct, indexed by something the user chooses. A dispatch table replaces a long chain of `if` and `else`, and it is easy to extend:

```c
#include <stdio.h>
#include <string.h>

typedef int (*binary_op)(int, int);

static int add(int a, int b) { return a + b; }
static int sub(int a, int b) { return a - b; }
static int mul(int a, int b) { return a * b; }

struct command {
    const char *name;
    binary_op run;
};

static const struct command commands[] = {
    { "add", add },
    { "sub", sub },
    { "mul", mul },
};

static int dispatch(const char *name, int a, int b) {
    for (size_t i = 0; i < sizeof commands / sizeof commands[0]; i++) {
        if (strcmp(commands[i].name, name) == 0) return commands[i].run(a, b);
    }
    return -1;   /* unknown command */
}
```

Adding a new operation means adding one function and one table row. Nothing else changes. This shape appears in interpreters, command-line tools and protocol parsers everywhere.

> **Tip:** Make the table `static const`. Then the compiler can place it in read-only memory, and nothing can overwrite a handler at run time by accident.

## Passing context: void pointers

A callback often needs state, such as a counter or an output buffer. C has no closures, so you pass that state explicitly through a `void *` parameter. The library calls your function with the pointer it was given, and your function casts it back:

```c
typedef void (*visit_fn)(int value, void *context);

static void sum_into(int value, void *context) {
    *(int *)context += value;
}

static void for_each(const int *items, size_t n, visit_fn visit, void *context) {
    for (size_t i = 0; i < n; i++) visit(items[i], context);
}
```

The caller decides what `context` means. This is the same design as `qsort` and as every event library you have used. It is also a common source of bugs when the context type does not match the cast, so keep the types next to each other in the code.

## Function pointer equality

A function''s name decays to a pointer to that function, so you can compare a pointer with the name directly. Here is a predict question built on that fact:

```c predict id=fn-equality title="What is printed?"
#include <stdio.h>

int add(int a, int b) { return a + b; }

int main(void) {
    int (*op)(int, int) = add;
    printf("%d\n", op == &add);
    return 0;
}
--- options
0
* 1
2
compile error
--- explain
`add` decays to a pointer to the function, and `&add` is also a pointer to that function. Both expressions produce the same address, so the comparison is true, and `1` is printed. The same rule means `op == add` is also `1`.
```

> **Pitfall:** Never convert a function pointer to `void *` or to a data pointer, and never call one through the wrong type. Calling a function through a pointer of the wrong signature is undefined behavior. The compiler will not stop you, so match the typedef to the real function exactly.

A table can hold any mix of functions with the same signature. Indexing it and calling the entry is one expression:

```c predict id=dispatch-table title="What is printed?"
#include <stdio.h>

static int twice(int x) { return 2 * x; }
static int square(int x) { return x * x; }

int main(void) {
    int (*table[])(int) = { square, twice, square };
    printf("%d\n", table[1](4) + table[2](3));
    return 0;
}
--- options
12
16
* 17
24
--- explain
`table[1]` is `twice`, so `table[1](4)` is `8`. `table[2]` is `square`, so `table[2](3)` is `9`. The sum is `17`. Because the table is an array of function pointers, the call syntax is the same as calling a normal function, just with an index in front.
```

## Common patterns in real code

- **Strategy:** choose an algorithm at run time, such as a compression level or a sorting order.
- **Callbacks:** the library calls your code when something happens, such as a completed request or a finished parse.
- **Vtables:** a struct of function pointers gives you a manual interface. File systems and device drivers in operating systems are built this way.
- **Iterators:** a traversal takes a visit function plus a context pointer.

> **In the wild:** The Linux kernel''s `file_operations` struct is a table of function pointers. Each filesystem fills it with its own functions, and the kernel calls through it without knowing the filesystem type.

## Recap

- Declare function pointers with the parentheses: `int (*op)(int, int)`.
- Call through them with `op(...)` or `(*op)(...)`; the function name decays to a pointer.
- A callback table, an array of structs with names and function pointers, replaces long `if` chains.
- Pass state explicitly through a `void *` context, and cast it back to the right type.
- The function type must match exactly, because calling through a mismatched type is undefined behavior.

**Up next:** Dynamic memory, the heap, and the functions `malloc`, `calloc`, `realloc` and `free`.
', 0, '[]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z'),
('les_c_advanced_1_6', 'sec_c_advanced_1', 'crs_c_advanced', 'Checkpoint: under the hood', 'quiz', 5, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"Which stage of the build replaces each #include line with the contents of the header?","options":["The compiler proper","The preprocessor","The assembler","The linker"],"answerIndex":1,"explanation":"The preprocessor works on text before the compiler sees the code. It pastes #include files, expands #define macros and chooses #if branches. Run gcc -E to see its output."},{"id":"q2","prompt":"Which of these is undefined behavior in C?","options":["Adding 1 to an unsigned int that holds its maximum value","Writing one element past the end of an array","Passing a const pointer to a function that only reads through it","Printing an int with the %d format specifier"],"answerIndex":1,"explanation":"Writing past the end of an array has no rules in the standard, so the compiler may assume it never happens. Unsigned wraparound is defined, and the other two are ordinary valid code."},{"id":"q3","prompt":"What does the declaration int (*op)(int, int); introduce?","options":["A function that returns a pointer to int","A pointer to a function taking two ints and returning an int","An array of two function pointers","A pointer to an int that takes two arguments"],"answerIndex":1,"explanation":"The parentheses around *op make op a pointer first. The rest of the declaration says what it points to: a function taking (int, int) and returning int. Without the parentheses, int *op(int, int) would declare a function."},{"id":"q4","prompt":"Given const char *p, which operation is allowed?","options":["Writing to p[0] without a cast","Reassigning p to point at a different string","Passing p to a function that takes char * without a cast"],"answerIndex":1,"explanation":"The const applies to the characters p points at, so they cannot be written through p. The pointer p itself is not const, so it can be reassigned. Passing p to a char * parameter would discard the const qualifier, which needs a cast and is almost always a bug."},{"id":"q5","prompt":"Which phase of the build reports the error ''undefined reference to helper''?","options":["Preprocessing","Compilation","Linking","Execution"],"answerIndex":2,"explanation":"The compiler has already checked the declaration of helper. The linker is the phase that looks for a definition to connect each undefined name to, so a missing definition shows up there."}]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z'),
('les_c_advanced_2_1', 'sec_c_advanced_2', 'crs_c_advanced', 'Dynamic memory: malloc, calloc, realloc and free', 'interactive', 0, 1440, NULL, NULL, 'Local variables live on the stack, and their lifetime ends when the function returns. Static variables live for the whole program. Neither works when you do not know, until run time, how much memory you need. A text editor opening a 40-megabyte file, a web server handling a request or a parser reading a list of unknown length all need memory whose size is decided while the program runs. That memory comes from the **heap**, and C gives you four functions to manage it: `malloc`, `calloc`, `realloc` and `free`.

Heap memory is powerful because you control its lifetime. It is dangerous for the same reason. Nothing frees it for you, and nothing stops you from using it after it is gone. This lesson covers the four functions, the idioms that make them safe, and the mistakes you must learn to avoid.

## The four functions

```c
#include <stdlib.h>

void *malloc(size_t size);                    // uninitialized block of size bytes
void *calloc(size_t count, size_t size);      // count * size bytes, all set to zero
void *realloc(void *ptr, size_t size);        // resize a block, possibly moving it
void free(void *ptr);                         // release a block
```

Each allocation function returns a pointer to the new block, or `NULL` if the request failed. Always check it. Memory is finite, and a request can fail on any machine.

The idiom that keeps the size correct is `sizeof *p`. It takes the size of the object the pointer points to, so the number stays right if the type changes:

```c
int *values = malloc(10 * sizeof *values);   // room for ten ints
if (values == NULL) {
    /* handle the error */
}
```

## malloc versus calloc

`malloc` gives you bytes whose contents are indeterminate. Reading them before writing is undefined behavior. `calloc` takes a count and an element size, multiplies them safely, and zeroes the memory. The predict question below shows the difference.

```c predict id=calloc-zero title="What is printed?"
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int *p = calloc(3, sizeof *p);
    if (p == NULL) return 1;
    printf("%d\n", p[2]);
    free(p);
    return 0;
}
--- options
* 0
garbage
2
compile error
--- explain
`calloc` zeroes every byte of the block it returns, so each `int` in the array is `0`, including `p[2]`. Reading memory from `malloc` before writing it would give an unpredictable value, which is why many programmers use `calloc` for arrays that start empty.
```

> **Pitfall:** `malloc(n * size)` can overflow when `n * size` is larger than the largest `size_t`. The wrapped result is much smaller than you expect, so you write past the end of the block. `calloc(n, size)` performs the check for you. When you multiply sizes by hand, check for overflow first.

## realloc: resizing without losing data

`realloc` resizes a block. It keeps the first bytes of the old contents, up to the smaller of the old and new sizes. If it cannot grow the block in place, it allocates a new block, copies the data, and frees the old one. That is why the pointer may change. The next question checks that the data survives a resize:

```c predict id=realloc-keep title="What is printed after the resize?"
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int *a = malloc(2 * sizeof *a);
    if (a == NULL) return 1;
    a[0] = 1;
    a[1] = 2;
    int *b = realloc(a, 4 * sizeof *b);
    if (b == NULL) {
        free(a);
        return 1;
    }
    printf("%d\n", b[1]);
    free(b);
    return 0;
}
--- options
1
* 2
0
garbage
--- explain
The first two `int` values are preserved when the block grows, so `b[1]` is still `2`, whether or not `realloc` moved the block. The idiom in the code matters as much as the output: `realloc` returns `NULL` on failure and leaves the old block untouched, so storing the result in `b` and keeping `a` lets you free the old block. Writing `a = realloc(a, ...)` loses the only pointer to the block when it fails.

> **Tip:** Always assign `realloc`''s result to a new pointer first. Only replace the original once you know the call succeeded. This one rule prevents a whole family of leaks.

## free and the rules around it

`free` returns a block to the allocator. Three rules keep you safe:

1. **Free each block exactly once.** A second `free` on the same pointer is undefined behavior.
2. **Never use a pointer after freeing it.** The memory may already belong to someone else.
3. **`free(NULL)` is safe and does nothing.** You can call it in cleanup code without checking first.

After you free a pointer, set it to `NULL` so that a later mistake fails in a clear way instead of silently corrupting memory.

```c
free(buffer);
buffer = NULL;
```

The predict question below checks a fact that helps you write generic code: the size computed from the pointer matches the type it points to.

```c predict id=sizeof-pointer title="What is printed?"
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int *p = malloc(10 * sizeof *p);
    if (p == NULL) return 1;
    printf("%d\n", (int)(sizeof *p == sizeof(int)));
    free(p);
    return 0;
}
--- options
0
* 1
10
compile error
--- explain
`sizeof *p` is the size of one `int`, because `*p` has type `int`. Comparing it with `sizeof(int)` gives true, which prints `1`. Using `sizeof *p` instead of `sizeof(int)` means the allocation stays correct if you later change the element type to `long` or to a struct.
```

## Where the bugs hide

Heap bugs are the most common serious bugs in C. The main ones:

- **Leaks:** a block with no remaining pointer to it. The memory stays allocated until the program exits.
- **Use after free:** reading or writing a block after it was freed, often with corrupted results far away.
- **Double free:** freeing the same block twice, which can corrupt the allocator''s own bookkeeping.
- **Buffer overflow:** writing past the end of a block, which overwrites neighboring data.

Lesson 7 deals with ownership, the discipline that prevents leaks, and lesson 19 shows the tools that find the rest.

> **In the wild:** Browsers and operating systems have shipped many security vulnerabilities that started as a use-after-free. Attackers exploit freed memory that gets reused for a different object, and the cure is discipline in ownership, not clever tricks.

## Recap

- `malloc` returns uninitialized memory, `calloc` returns zeroed memory with a safe size calculation.
- Always check for `NULL`, and use `sizeof *p` for the element size.
- `realloc` may move the block; store its result in a new pointer and keep the old one until you know it succeeded.
- Free each block once, never use it after freeing, and set the pointer to `NULL` afterwards.
- Most heap bugs are leaks, use-after-free, double frees and overflows.

**Up next:** Ownership: deciding who frees what, and how to find leaks before they grow.
', 0, '[]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z'),
('les_c_advanced_2_2', 'sec_c_advanced_2', 'crs_c_advanced', 'Ownership rules and finding leaks', 'interactive', 1, 1200, NULL, NULL, 'The compiler checks types. It does not check who owns memory. Nothing in C tells you whether a function returns a block you must free, or whether it keeps a pointer you passed in. For that reason, the most important design skill in C is writing down **ownership**: for every pointer, one piece of code is responsible for freeing it, and everyone else borrows it for a known period.

A leak happens when the owner forgets. A double free happens when two owners both think they are responsible. A use-after-free happens when someone keeps borrowing a pointer after the owner released it. All three are ownership failures, and all three come from code that never stated who owns what.

This lesson gives you a small set of conventions that make ownership visible, and shows how to write cleanup code that stays correct when a function has several ways to fail.

## Three questions for every pointer

When you receive or return a pointer, ask:

1. **Who allocates it?** Is it fresh heap memory, a static object, or a stack variable?
2. **Who frees it?** Exactly one piece of code must do this.
3. **How long is the borrow?** Does the pointer stay valid after the call returns?

Write the answers in the function''s documentation. A header comment such as `/* Returns a newly allocated string. The caller must free it. */` is worth more than any clever type trick.

## Naming conventions

Good names carry ownership information:

| Name pattern | Meaning |
|---|---|
| `make_thing` / `destroy_thing` | Creates an object and returns ownership; the caller must destroy it |
| `thing_init` / `thing_free_fields` | Works on storage the caller provided; the caller owns the storage |
| `get_thing` / `find_thing` | Returns a borrowed pointer; do not free it |
| `take_thing` | Takes ownership of the argument; the caller must not use it afterwards |

These names look like style. They are design decisions, and they prevent most leaks in a codebase.

## A constructor and a destructor

The cleanest pattern is to pair a function that creates a resource with one that releases it. Here is a small string builder:

```c
typedef struct {
    char *data;
    size_t length;
} text;

text *text_make(const char *initial) {
    text *t = malloc(sizeof *t);
    if (t == NULL) return NULL;
    t->length = strlen(initial);
    t->data = malloc(t->length + 1);
    if (t->data == NULL) {
        free(t);             /* undo the first allocation before failing */
        return NULL;
    }
    memcpy(t->data, initial, t->length + 1);
    return t;
}

void text_destroy(text *t) {
    if (t == NULL) return;
    free(t->data);
    free(t);
}
```

Notice how `text_make` cleans up its own partial work. If the second allocation fails, the first one is released before returning `NULL`. A function that either fully succeeds or leaves no trace is much easier to reason about.

## Cleanup on error paths

Functions with several allocations often end with a chain of cleanup steps. A common and clean idiom uses one exit label, so every failure path passes through the same release code:

```c
int load_pair(const char *a_path, const char *b_path) {
    int result = -1;
    char *a = NULL;
    char *b = NULL;

    a = read_file(a_path);
    if (a == NULL) goto done;

    b = read_file(b_path);
    if (b == NULL) goto done;

    result = process(a, b);

done:
    free(b);     /* free(NULL) is a no-op, so this is always safe */
    free(a);
    return result;
}
```

The `goto` looks unusual, but it is the standard C pattern for cleanup. Every path reaches `done`, and every resource is released exactly once. Initializing the pointers to `NULL` at the top is what makes releasing them at the bottom safe.

> **Tip:** Use the same order for allocation and cleanup, but reversed. Free what you allocated last first. It mirrors the structure of nested resources and makes the cleanup block easy to check against the setup code.

The predict question checks the fact that makes that cleanup safe:

```c predict id=free-null title="What is printed?"
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    char *buffer = NULL;
    free(buffer);
    printf("safe\n");
    return 0;
}
--- options
* safe
crash
undefined
compile error
--- explain
The C standard defines `free(NULL)` as doing nothing. Because the pointer is `NULL`, no block is released and the program continues, printing `safe`. This is why cleanup code can release every pointer without checking each one first.
```

## Transferring ownership

Sometimes a function takes a pointer and takes responsibility for it. Document that clearly, and do not use the argument afterwards. Here is a predict question that tracks allocations with a counter, and it shows a simple way to test ownership rules:

```c predict id=track-allocs title="What is printed?"
#include <stdio.h>
#include <stdlib.h>

static int live = 0;

static void *tracked_alloc(size_t n) {
    live++;
    return malloc(n);
}

static void tracked_free(void *p) {
    if (p != NULL) live--;
    free(p);
}

int main(void) {
    void *a = tracked_alloc(8);
    void *b = tracked_alloc(8);
    tracked_free(a);
    printf("%d ", live);
    tracked_free(b);
    printf("%d\n", live);
    return 0;
}
--- options
2 0
* 1 0
0 0
1 1
--- explain
Two blocks are allocated, so `live` is `2`. Freeing `a` decreases it to `1`, and `printf` prints `1 `. Freeing `b` decreases it to `0`, and the program prints `0`. This is the same bookkeeping that memory-debugging tools do for you on real programs, and it shows how easy it is to lose track of a single block.
```

> **Pitfall:** A leak does not crash the program. It makes memory grow slowly, which is why leaks often survive testing and then exhaust memory after days of uptime. Long-running servers and daemons must be leak-free for this reason.

Two blocks can belong to one object, and each one needs its own release. The `text` struct above owns both its header and its data buffer. The next question builds one by hand, so you can see that `strlen` counts characters but not the terminator:

```c predict id=text-length title="What is printed?"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char *data;
    size_t length;
} text;

int main(void) {
    text *t = malloc(sizeof *t);
    if (t == NULL) return 1;
    t->data = malloc(6);
    if (t->data == NULL) {
        free(t);
        return 1;
    }
    memcpy(t->data, "hello", 6);
    t->length = strlen(t->data);
    printf("%zu\n", t->length);
    free(t->data);
    free(t);
    return 0;
}
--- options
6
* 5
4
hello
--- explain
`memcpy` copies six bytes, the five letters and the terminating null byte, so `t->data` holds a valid string. `strlen` counts the characters before the terminator, which is `5`. The buffer has room for six bytes, so `length` is one less than the allocation size. Both blocks are freed in the reverse order they were allocated.
```

## Finding leaks

You will not catch every leak by reading code. Use tools. Valgrind and AddressSanitizer both report blocks that were never freed, and you will learn to run them in lesson 19. Make the tools part of your routine: run the test suite under them before you trust a change.

> **In the wild:** Most long-running C services keep an ownership table in their design documents, listing which module owns each resource type and which function releases it. It sounds bureaucratic, and it is the reason those services survive years of change.

## Recap

- Every pointer needs one owner who frees it, and borrowers who never free it.
- Name functions so the ownership rule is visible: `make` and `destroy`, `get` and `find`, `take`.
- Pair every constructor with a destructor, and make constructors clean up after themselves on failure.
- Use one cleanup label with `NULL`-initialized pointers to handle error paths.
- Use tools such as Valgrind and AddressSanitizer to confirm that your ownership rules hold.

**Up next:** Linked lists, the first data structure you will build from heap nodes, and the invariants that keep it correct.
', 0, '[]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z'),
('les_c_advanced_2_3', 'sec_c_advanced_2', 'crs_c_advanced', 'Linked lists: nodes, pointers and invariants', 'interactive', 2, 1560, NULL, NULL, 'An array keeps its elements side by side in memory, which is fast to read and wasteful to change. Inserting in the middle means shifting everything after it. A **linked list** takes the opposite trade-off: each element is a separate node that holds a value and a pointer to the next node. Inserting or removing a node means changing a couple of pointers, and nothing else moves.

Linked lists are the first real data structure you build in C, and they teach the habits you need for everything after: allocating nodes, keeping pointers consistent and freeing everything exactly once. This lesson shows how to build a singly linked list correctly, including the pointer-to-pointer technique that removes special cases from insertion and deletion.

## The node

A node is a struct that contains data and a pointer to the next node of the same type. The struct must refer to itself by tag, since the type is not complete inside its own body:

```c
typedef struct node {
    int value;
    struct node *next;   /* NULL marks the end of the list */
} node;
```

The list itself is just a pointer to its first node, the **head**. An empty list is a head of `NULL`.

## Invariants

A data structure is correct when a set of conditions always holds. For a singly linked list:

- every `next` pointer is either `NULL` or the address of a valid node,
- following `next` from the head reaches `NULL` after finitely many steps (no cycles, unless you designed one),
- every node is reachable from the head, or it has been freed.

Every operation must keep these conditions true. When you write an insert or a delete, check the invariants before you return, not just that the function "seems to work".

## Insert at the head

Inserting at the head is the simplest operation, and it runs in constant time:

```c
node *list_push(node *head, int value) {
    node *n = malloc(sizeof *n);
    if (n == NULL) return head;   /* caller should detect failure; see the pitfall */
    n->value = value;
    n->next = head;
    return n;
}
```

The function returns the new head, which is the common style for functions that change the first node. The predict question below uses this shape:

```c predict id=push-order title="Which order is printed?"
#include <stdio.h>
#include <stdlib.h>

typedef struct node {
    int value;
    struct node *next;
} node;

static node *list_push(node *head, int value) {
    node *n = malloc(sizeof *n);
    if (n == NULL) return head;
    n->value = value;
    n->next = head;
    return n;
}

int main(void) {
    node *head = NULL;
    for (int i = 1; i <= 3; i++) head = list_push(head, i);
    for (node *p = head; p != NULL; p = p->next) printf("%d ", p->value);
    printf("\n");
    while (head != NULL) {
        node *next = head->next;
        free(head);
        head = next;
    }
    return 0;
}
--- options
1 2 3 
* 3 2 1 
2 1 3 
3 1 2 
--- explain
Each push puts the new node at the front, so the last value pushed (`3`) is first in the list. Traversal therefore prints `3 2 1`. The final loop frees each node after saving its `next` pointer, which is the only safe order: once a node is freed, its `next` field must not be read.

> **Pitfall:** Returning `head` on allocation failure silently keeps the list but drops the value. A safer design returns an error code and takes `node **` so the caller sees the failure. For a teaching example the simple form is clearer, but know the trade-off.

## Traversal and counting

Traversal is a loop that follows `next` until it finds `NULL`. Always write the test as "while the pointer is not `NULL`", and never dereference a pointer before you have checked it:

```c
size_t list_length(const node *n) {
    size_t count = 0;
    while (n != NULL) {
        count++;
        n = n->next;
    }
    return count;
}
```

The `const node *` parameter promises that the function only reads the list. That promise lets callers pass a list they do not own without worrying that it will change.

## Insert in sorted order: the pointer-to-pointer idiom

Inserting in the middle requires you to change the pointer that points at the new node, and that pointer may be the head itself. The beginner solution uses a "previous" pointer and needs a special case for the head. The idiom below removes the special case: keep a pointer to the **pointer** you want to update.

```c
void list_insert_sorted(node **head, node *n) {
    node **pp = head;
    while (*pp != NULL && (*pp)->value < n->value) {
        pp = &(*pp)->next;
    }
    n->next = *pp;
    *pp = n;
}
```

`pp` starts as the address of the head pointer. Each step moves it to the address of the current node''s `next` field. When the loop ends, `*pp` is the first pointer that should be replaced, whether it is the head or a link inside the list. The same code handles both cases.

The predict question checks this technique on nodes that live on the stack, so there is nothing to free:

```c predict id=sorted-insert title="What is printed?"
#include <stdio.h>

typedef struct node {
    int value;
    struct node *next;
} node;

static void list_insert_sorted(node **head, node *n) {
    node **pp = head;
    while (*pp != NULL && (*pp)->value < n->value) {
        pp = &(*pp)->next;
    }
    n->next = *pp;
    *pp = n;
}

int main(void) {
    node c = { 20, NULL };
    node a = { 10, &c };
    node head_node = a;
    node *head = &head_node;
    node n = { 15, NULL };
    list_insert_sorted(&head, &n);
    printf("%d\n", head->next->value);
    return 0;
}
--- options
10
* 15
20
compile error
--- explain
The list starts as `10 -> 20`. The insertion walks past `10`, because `10 < 15`, and stops before `20`, because `20 < 15` is false. The pointer `pp` ends up pointing at the `next` field of the node holding `10`. Setting `*pp = n` links `15` in between, so `head->next` is the node `15`, and its value is `15`.

Notice that `head_node` is a copy of `a` taken before the insertion. In real code you would store the head once and pass its address, which is what this example does. Copying nodes is a common mistake when the pointer inside them is what matters.

## Removing a node

Removal uses the same idiom. Walk with `pp` until `*pp` holds the value to remove, then link around it and free it:

```c
int list_remove(node **head, int value) {
    node **pp = head;
    while (*pp != NULL) {
        if ((*pp)->value == value) {
            node *dead = *pp;
            *pp = dead->next;
            free(dead);
            return 1;
        }
        pp = &(*pp)->next;
    }
    return 0;
}
```

The removal reads `dead->next` before it frees `dead`, and it updates the pointer that used to point at `dead`. Both steps happen in the right order, and the invariants hold after the function returns.

> **Tip:** Draw the list before writing the loop. Arrows for `next`, a box for the head, and a dotted arrow for `pp` make the pointer-to-pointer idiom obvious. Most bugs in list code are an arrow that was updated in the wrong place.

The next question combines counting with pointers into the middle of the list. Each node here lives on the stack, which keeps the example short:

```c predict id=length-and-middle title="What is printed?"
#include <stdio.h>
#include <stddef.h>

typedef struct node {
    int value;
    struct node *next;
} node;

static size_t list_length(const node *n) {
    size_t count = 0;
    while (n != NULL) {
        count++;
        n = n->next;
    }
    return count;
}

int main(void) {
    node c = { 30, NULL };
    node b = { 20, &c };
    node a = { 10, &b };
    printf("%zu %d\n", list_length(&a), b.next->value);
    return 0;
}
--- options
2 20
* 3 30
3 20
2 30
--- explain
`list_length` follows `next` from `a` through `b` to `c`, then stops at `NULL`, so it counts three nodes. `b.next` is the node `c`, whose value is `30`. The output is `3 30`. The function takes `const node *` because it only reads the list.
```

## When to use a list

Linked lists are excellent when you insert or remove in the middle often, when you splice lists together, or when you need stable addresses for elements. They are poor when you need random access by index or when cache performance matters. Each node is a separate heap allocation, and walking a list jumps through memory. For most collections, a dynamic array (lesson 22) is faster. Learn lists anyway, because they are the building block of queues, hash chains, trees and many kernel structures.

## Recap

- A node holds a value and a pointer to the next node; `NULL` ends the list.
- Keep invariants true after every operation, and write them down.
- Insert at the head with a returned new head, and traverse with `while (p != NULL)`.
- The pointer-to-pointer idiom (`node **pp`) handles the head and middle cases with one code path.
- Read `next` before you free a node, and never use a node after it is freed.

**Up next:** Stacks and queues, two restricted interfaces built on the same linked storage.
', 0, '[]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z'),
('les_c_advanced_2_4', 'sec_c_advanced_2', 'crs_c_advanced', 'Stacks and queues built on linked storage', 'interactive', 3, 1320, NULL, NULL, 'A list lets you insert and remove anywhere. That freedom is useful, but most programs need less. A **stack** allows only one kind of access: last in, first out. A **queue** allows only another: first in, first out. Restricting the operations makes the code smaller, easier to test and harder to misuse, and the restriction is exactly what makes these structures so common.

Stacks run the function-call machinery in every program, parse nested expressions, and undo your edits. Queues schedule work, buffer data between a producer and a consumer and drive breadth-first search. This lesson builds both on top of the linked nodes you learned in lesson 8, and it shows the one extra pointer that makes a queue fast.

## The stack: last in, first out

A stack has two operations, `push` (add to the top) and `pop` (remove from the top). Both run in constant time when the top is the head of a linked list, because adding and removing at the head changes only one pointer.

```c
typedef struct node {
    int value;
    struct node *next;
} node;

typedef struct {
    node *top;
} stack;
```

Wrapping the head in a `stack` struct is a deliberate choice. Callers receive a `stack` instead of a bare `node *`, so the interface states what they are allowed to do, and the representation can change later without breaking them.

```c
void stack_push(stack *s, int value) {
    node *n = malloc(sizeof *n);
    if (n == NULL) exit(EXIT_FAILURE);   /* simplest policy for a teaching example */
    n->value = value;
    n->next = s->top;
    s->top = n;
}

int stack_pop(stack *s) {
    /* Precondition: the stack is not empty. */
    node *n = s->top;
    int value = n->value;
    s->top = n->next;
    free(n);
    return value;
}

int stack_is_empty(const stack *s) {
    return s->top == NULL;
}
```

The precondition matters. `stack_pop` on an empty stack dereferences `NULL`, which is undefined behavior. Either document the rule, as above, or check and return a status. Every public function should say what it requires.

The predict question shows the stack''s order in a small program:

```c predict id=stack-order title="What is printed?"
#include <stdio.h>
#include <stdlib.h>

typedef struct node {
    int value;
    struct node *next;
} node;

typedef struct {
    node *top;
} stack;

static void stack_push(stack *s, int value) {
    node *n = malloc(sizeof *n);
    if (n == NULL) exit(EXIT_FAILURE);
    n->value = value;
    n->next = s->top;
    s->top = n;
}

static int stack_pop(stack *s) {
    node *n = s->top;
    int value = n->value;
    s->top = n->next;
    free(n);
    return value;
}

int main(void) {
    stack s = { NULL };
    stack_push(&s, 4);
    stack_push(&s, 5);
    stack_push(&s, 6);
    int a = stack_pop(&s);
    int b = stack_pop(&s);
    printf("%d %d\n", a, b);
    while (s.top != NULL) stack_pop(&s);
    return 0;
}
--- options
4 5
* 6 5
5 6
6 4
--- explain
The last value pushed, `6`, is on top, so the first pop returns `6`. The second pop returns the next value down, which is `5`. The remaining `4` is freed by the cleanup loop. Reversing the order of pushes and pops is how stacks reverse anything.
```

## Reversing with a stack

A stack reverses a sequence: push everything, then pop everything. This is a practical trick, and the next question uses it on characters:

```c predict id=reverse-with-stack title="What is printed?"
#include <stdio.h>
#include <stdlib.h>

typedef struct node {
    char value;
    struct node *next;
} node;

typedef struct {
    node *top;
} stack;

static void push(stack *s, char value) {
    node *n = malloc(sizeof *n);
    if (n == NULL) exit(EXIT_FAILURE);
    n->value = value;
    n->next = s->top;
    s->top = n;
}

static char pop(stack *s) {
    node *n = s->top;
    char value = n->value;
    s->top = n->next;
    free(n);
    return value;
}

int main(void) {
    stack s = { NULL };
    const char *word = "abc";
    for (const char *p = word; *p != ''\0''; p++) push(&s, *p);
    char out[4];
    for (int i = 0; i < 3; i++) out[i] = pop(&s);
    out[3] = ''\0'';
    printf("%s\n", out);
    return 0;
}
--- options
abc
* cba
bca
ccc
--- explain
The loop pushes `a`, then `b`, then `c`, so `c` is on top. Popping three times yields `c`, `b`, `a`. The array gets a terminating null byte at index 3, so `printf` with `%s` prints `cba`. Using `out[4]` for three characters plus the terminator is the correct size.

## The queue: first in, first out

A queue adds at one end and removes at the other. A singly linked list makes one of those ends cheap, but not both, unless you keep an extra pointer. The naive queue walks the list to find the tail on every enqueue, which takes time proportional to the length. Keeping a `tail` pointer makes enqueue constant time:

```c
typedef struct {
    node *head;   /* dequeue removes from here */
    node *tail;   /* enqueue appends here */
} queue;

void queue_enqueue(queue *q, int value) {
    node *n = malloc(sizeof *n);
    if (n == NULL) exit(EXIT_FAILURE);
    n->value = value;
    n->next = NULL;
    if (q->tail != NULL) q->tail->next = n;
    else q->head = n;            /* the queue was empty */
    q->tail = n;
}

int queue_dequeue(queue *q) {
    /* Precondition: the queue is not empty. */
    node *n = q->head;
    int value = n->value;
    q->head = n->next;
    if (q->head == NULL) q->tail = NULL;   /* the queue is now empty */
    free(n);
    return value;
}
```

The two places that set pointers to `NULL` are where queue bugs live. When the last element leaves, `tail` must become `NULL`, or the next enqueue writes into freed memory. When the first element arrives, `head` must be set, or the queue appears empty while holding data. The predict question checks the normal order:

```c predict id=queue-order title="What is printed?"
#include <stdio.h>
#include <stdlib.h>

typedef struct node {
    int value;
    struct node *next;
} node;

typedef struct {
    node *head;
    node *tail;
} queue;

static void enqueue(queue *q, int value) {
    node *n = malloc(sizeof *n);
    if (n == NULL) exit(EXIT_FAILURE);
    n->value = value;
    n->next = NULL;
    if (q->tail != NULL) q->tail->next = n;
    else q->head = n;
    q->tail = n;
}

static int dequeue(queue *q) {
    node *n = q->head;
    int value = n->value;
    q->head = n->next;
    if (q->head == NULL) q->tail = NULL;
    free(n);
    return value;
}

int main(void) {
    queue q = { NULL, NULL };
    enqueue(&q, 1);
    enqueue(&q, 2);
    enqueue(&q, 3);
    int first = dequeue(&q);
    int second = dequeue(&q);
    printf("%d %d\n", first, second);
    while (q.head != NULL) dequeue(&q);
    return 0;
}
--- options
3 2
* 1 2
2 3
1 3
--- explain
A queue returns values in the order they arrived. `1` was enqueued first, so the first dequeue returns `1`, and the second returns `2`. The cleanup loop removes the remaining `3`. The `tail` pointer never needed to walk the list, which is why each enqueue is constant time.
```

> **Tip:** Test a queue at three moments: one element, many elements, and empty again after the last dequeue. Most queue bugs appear at the boundaries, and the empty state is the one people forget.

## Array-based alternatives

A linked queue allocates a node per element. For high-throughput code, a **ring buffer** (a fixed array with a head index and a count, wrapping around at the end) avoids allocation entirely and keeps the data contiguous. It is the usual choice for audio buffers, network packets and communication between an interrupt handler and the main loop. Choose linked storage when the size is unpredictable and the simplicity matters more than speed.

> **In the wild:** Operating systems use queues for almost everything: runnable processes, pending disk requests and received network packets. The Linux kernel''s `list_head` is a doubly linked list that serves as a stack in some places and a queue in others.

## Recap

- A stack is last in, first out. Push and pop at the head run in constant time.
- A queue is first in, first out. Keep both `head` and `tail` pointers so that enqueue is constant time.
- Document preconditions, and never pop or dequeue an empty structure.
- Reset `tail` to `NULL` when the queue empties, and set `head` when the first element arrives.
- A ring buffer is the array-based alternative when allocation must be avoided.

**Up next:** Binary search trees: a structure with two child pointers per node, and the recursion that makes it work.
', 0, '[]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z'),
('les_c_advanced_2_5', 'sec_c_advanced_2', 'crs_c_advanced', 'Binary search trees: insert, search and traverse', 'interactive', 4, 1560, NULL, NULL, 'A linked list finds a value by walking through every node, which takes time proportional to its length. An array finds a value by binary search in logarithmic time, but inserting into it is slow. A **binary search tree** (BST) keeps the best of both: each node has up to two children, and the arrangement guarantees that a search only follows one branch at each step. When the tree stays balanced, a lookup, an insert or a delete takes time proportional to its height, which grows only logarithmically with the number of keys.

Trees appear everywhere in systems code. File systems index directories with them, databases index tables with B-trees (a close relative), and the standard libraries of many languages use them for ordered maps. Writing a BST by hand is the best way to learn recursion over pointer structures, which you will use for the rest of your career.

## The ordering rule

Every node holds a key. For a BST, the rule is:

- every key in the **left** subtree is **smaller** than the node''s key,
- every key in the **right** subtree is **larger**,
- there are no duplicates in this version (you can change that by choosing a side for equal keys and keeping it).

This rule is the invariant. Insertions, searches and deletions all preserve it, and every algorithm depends on it.

```c
typedef struct tree {
    int key;
    struct tree *left;
    struct tree *right;
} tree;
```

## Traversals

There are three classic ways to visit every node, and they differ only in when you handle the current node:

- **In-order** (left, node, right) visits keys in sorted order. It is the most useful, and it confirms that the tree is a valid BST.
- **Pre-order** (node, left, right) copies a tree, because it creates each parent before its children.
- **Post-order** (left, right, node) frees a tree, because it releases children before the parent that points at them.

The in-order traversal is a short recursive function. The predict question uses it on a fixed tree whose nodes live on the stack:

```c predict id=inorder title="Which keys are printed?"
#include <stdio.h>

typedef struct tree {
    int key;
    struct tree *left;
    struct tree *right;
} tree;

static void print_inorder(const tree *t) {
    if (t == NULL) return;
    print_inorder(t->left);
    printf("%d ", t->key);
    print_inorder(t->right);
}

int main(void) {
    tree one = { 1, NULL, NULL };
    tree three = { 3, &one, NULL };
    tree eight = { 8, NULL, NULL };
    tree five = { 5, &three, &eight };
    print_inorder(&five);
    printf("\n");
    return 0;
}
--- options
5 3 1 8 
8 5 3 1 
1 5 3 8 
* 1 3 5 8 
--- explain
In-order traversal visits the left subtree first, then the node, then the right subtree. For the root `5`, that means: all of the left subtree (`3`, with `1` on its left) comes out as `1 3`, then `5`, then the right subtree `8`. The output is `1 3 5 8`, which is sorted, as it always is for a valid BST.

## Searching

Search starts at the root and compares the target with the current key. Equal means found. Smaller means the target can only be on the left, larger means the right. Each step discards half of the remaining tree when the tree is balanced:

```c
const tree *tree_find(const tree *t, int key) {
    while (t != NULL) {
        if (key == t->key) return t;
        t = (key < t->key) ? t->left : t->right;
    }
    return NULL;
}
```

The iterative loop uses no extra stack space. The recursive form is just as correct, and it is easier to read for some people. Both rely on the invariant. If the tree is not a valid BST, the search can return the wrong answer without any error.

## Insertion

Insertion follows the same path as search and attaches the new node where the search would have ended. It must handle the empty tree, because the root pointer itself may change. Returning the (possibly new) root from the function solves that cleanly:

```c
tree *tree_insert(tree *t, int key) {
    if (t == NULL) {
        tree *n = malloc(sizeof *n);
        if (n == NULL) return NULL;   /* the caller must check for failure */
        n->key = key;
        n->left = NULL;
        n->right = NULL;
        return n;
    }
    if (key < t->key) t->left = tree_insert(t->left, key);
    else if (key > t->key) t->right = tree_insert(t->right, key);
    /* equal keys are ignored, so the tree holds no duplicates */
    return t;
}
```

The assignment `t->left = tree_insert(t->left, key)` is the key line. It stores the returned subtree back in the parent, which is how a new leaf gets linked in. Forgetting that assignment is the most common insert bug.

> **Pitfall:** If `malloc` fails in the middle of a recursive insert, a parent may be assigned `NULL` and the tree is damaged. A robust version checks the allocation before linking it. The simple form here is for clarity, so check your own code carefully.

The predict question builds a small tree from a sequence of inserts and checks the shape:

```c predict id=insert-shape title="What is printed?"
#include <stdio.h>
#include <stdlib.h>

typedef struct tree {
    int key;
    struct tree *left;
    struct tree *right;
} tree;

static tree *tree_insert(tree *t, int key) {
    if (t == NULL) {
        tree *n = malloc(sizeof *n);
        if (n == NULL) exit(EXIT_FAILURE);
        n->key = key;
        n->left = NULL;
        n->right = NULL;
        return n;
    }
    if (key < t->key) t->left = tree_insert(t->left, key);
    else if (key > t->key) t->right = tree_insert(t->right, key);
    return t;
}

static void tree_free(tree *t) {
    if (t == NULL) return;
    tree_free(t->left);
    tree_free(t->right);
    free(t);
}

int main(void) {
    tree *root = NULL;
    int keys[] = { 5, 3, 8, 1, 4 };
    for (size_t i = 0; i < sizeof keys / sizeof keys[0]; i++) {
        root = tree_insert(root, keys[i]);
    }
    printf("%d\n", root->left->right->key);
    tree_free(root);
    return 0;
}
--- options
1
3
* 4
8
--- explain
Insert `5` at the root. `3` is smaller, so it goes left. `8` is larger, so it goes right. `1` is smaller than `5` and smaller than `3`, so it goes to the left of `3`. `4` is smaller than `5` and larger than `3`, so it goes to the right of `3`. `root->left->right` is therefore the node `4`. The cleanup uses post-order, freeing both children before the node that points at them.

## Height and balance

The height of a tree is the number of nodes on its longest path from root to leaf. It determines how long a search can take. The recursion is short:

```c
int tree_height(const tree *t) {
    if (t == NULL) return 0;
    int left = tree_height(t->left);
    int right = tree_height(t->right);
    return 1 + (left > right ? left : right);
}
```

A tree built from keys that arrive in sorted order is a disaster: every insert goes to the right, the tree becomes a list, and searches take linear time. The insertion order `5, 3, 8, 1, 4` above is fine, but `1, 2, 3, 4, 5` is not. Balanced trees such as AVL and red-black trees rotate nodes after inserts to keep the height logarithmic. Learn the plain BST first, and then the balancing idea will make sense.

Here is the height function applied to a tree whose shape you can see directly:

```c predict id=height-check title="What is printed?"
#include <stdio.h>

typedef struct tree {
    int key;
    struct tree *left;
    struct tree *right;
} tree;

static int tree_height(const tree *t) {
    if (t == NULL) return 0;
    int left = tree_height(t->left);
    int right = tree_height(t->right);
    return 1 + (left > right ? left : right);
}

int main(void) {
    tree one = { 1, NULL, NULL };
    tree three = { 3, &one, NULL };
    tree eight = { 8, NULL, NULL };
    tree five = { 5, &three, &eight };
    printf("%d\n", tree_height(&five));
    return 0;
}
--- options
2
* 3
4
5
--- explain
The longest path is `5`, then `3`, then `1`, which has three nodes. The leaf `8` gives a path of two nodes, which is shorter. An empty subtree contributes height `0`, and each node adds `1` to the larger of its children''s heights. The result is `3`.
```

## Deletion

Deletion has three cases, and the tricky one uses the in-order successor:

1. **Leaf:** remove the node and free it.
2. **One child:** replace the node with its child.
3. **Two children:** find the smallest key in the right subtree (the in-order successor), copy its key into the node, then delete that successor from the right subtree.

Case 3 keeps the ordering invariant true, because the successor is larger than everything in the left subtree and smaller than everything else in the right subtree.

> **Tip:** Draw the tree before writing delete. Most deletion bugs are a parent pointer left pointing at freed memory, and a drawing makes that visible instantly.

> **In the wild:** Kernel code uses binary trees for scheduling and memory maps. Linux''s red-black tree powers the process scheduler''s ordered list of tasks and many internal indexes, which is why its implementation is so carefully tested.

## Recap

- A BST keeps smaller keys to the left and larger keys to the right of every node.
- In-order traversal visits keys in sorted order; post-order is the safe order for freeing.
- Search and insert follow one path from the root. Insert returns the new subtree root and stores it back in the parent.
- Height determines performance, and sorted input makes an unbalanced tree.
- Deletion has three cases; the two-child case uses the in-order successor.

**Up next:** Hash tables with chaining, which trade ordering for constant-time lookups on average.
', 0, '[]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z'),
('les_c_advanced_2_6', 'sec_c_advanced_2', 'crs_c_advanced', 'Checkpoint: memory mastery', 'quiz', 5, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"What does calloc guarantee about the memory it returns?","options":["The bytes are uninitialized, so you must write before reading","Every byte is set to zero","Every byte is set to 0xFF","The block is aligned to a 4096-byte page"],"answerIndex":1,"explanation":"calloc zeroes the block, which is why it is the safe choice for arrays that start empty. malloc leaves the bytes indeterminate, and alignment is only guaranteed to suit any standard type, not a page."},{"id":"q2","prompt":"Which statement about free is correct?","options":["Calling free on NULL is undefined behavior","Calling free twice on the same pointer is safe if you do not read it","free(NULL) does nothing, so cleanup code can call it without checking","After free, the pointer can still be used if the output looks right"],"answerIndex":2,"explanation":"The standard defines free(NULL) as a no-op. A second free on the same block is a double free and is undefined, and reading memory after free is undefined even when the output looks correct by luck."},{"id":"q3","prompt":"realloc returns NULL. What is the safe way to handle it?","options":["The old pointer has already been freed automatically","The old block is still valid, so keep the old pointer and handle the error","The program must exit immediately, because the heap is corrupted","The new pointer is NULL and the old block must be freed by the caller"],"answerIndex":1,"explanation":"When realloc fails, the original block is left untouched. Storing the result in a new pointer lets you keep the old one, free it on the error path, and avoid losing the only reference to the data."},{"id":"q4","prompt":"In a queue with head and tail pointers, which operation takes constant time?","options":["Enqueue at the tail","Finding the middle element","Searching for a value","Inserting in sorted order"],"answerIndex":0,"explanation":"The tail pointer lets enqueue link the new node directly, with no walk through the list. Searching, finding the middle, and sorted insertion all need to traverse nodes in a singly linked list."},{"id":"q5","prompt":"In a binary search tree, where are the keys smaller than a node''s key?","options":["In its right subtree","In its left subtree","Anywhere in the tree, as long as the parent is smaller","Only in the node''s direct parent"],"answerIndex":1,"explanation":"The ordering invariant places smaller keys in the left subtree and larger keys in the right subtree. Search depends on this rule to discard one side at each step."}]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_c_advanced_3_1', 'sec_c_advanced_3', 'crs_c_advanced', 'Hash tables with chaining', 'interactive', 0, 1560, NULL, NULL, 'A binary search tree finds a key in time proportional to its height, which is logarithmic only when the tree stays balanced. A **hash table** aims for something faster: find a key in roughly constant time, regardless of how many keys you store. It does this by computing a number from the key and using that number to choose a place to look. Hash tables power symbol tables in compilers, caches in web servers, sets of visited URLs in crawlers and the dictionaries of most scripting languages.

The idea is simple. The hard parts are choosing a good hash function, handling two keys that land in the same place, and growing the table before it becomes slow. This lesson builds a table that uses **chaining**, where each bucket holds a linked list of entries, and it covers each part.

## The hash function

A hash function maps a key to an unsigned integer. A good one spreads keys evenly across the buckets, and it is fast. The classic string hash `djb2` multiplies the running value by 33 and adds each byte. Unsigned arithmetic wraps around, so the result always fits in the type, and the wrap is defined behavior:

```c
unsigned long hash_string(const char *key) {
    unsigned long h = 5381;
    for (const unsigned char *p = (const unsigned char *)key; *p != ''\0''; p++) {
        h = h * 33u + *p;
    }
    return h;
}
```

The bucket is then `hash_string(key) % bucket_count`. The `unsigned char` cast matters: it keeps the byte values non-negative, which keeps the arithmetic simple to reason about. Using a signed `char` on a platform where it is signed would still be defined here, but it makes the intent harder to see.

The predict question below uses one character so that you can check the arithmetic by hand:

```c predict id=hash-bucket title="Which bucket does the key \"a\" land in?"
#include <stdio.h>

static unsigned long hash_string(const char *key) {
    unsigned long h = 5381;
    for (const unsigned char *p = (const unsigned char *)key; *p != ''\0''; p++) {
        h = h * 33u + *p;
    }
    return h;
}

int main(void) {
    printf("%lu\n", hash_string("a") % 8);
    return 0;
}
--- options
0
2
5
* 6
--- explain
For the key `"a"`, the loop starts with `h = 5381`. Then `h = 5381 * 33 + 97`, where `97` is the code of `''a''`, which gives `177670`. Dividing by 8 leaves a remainder of `6`, because `8 * 22208 = 177664`. Bucket `6` of an 8-bucket table holds `"a"`.

## Chaining

Two different keys can land in the same bucket. That is a **collision**, and it is unavoidable: there are more possible keys than buckets. Chaining handles collisions by letting each bucket hold a linked list of entries. Lookup walks the chain for its bucket, comparing keys. Insert adds to the front of the chain, which takes constant time.

```c
typedef struct entry {
    char *key;
    int value;
    struct entry *next;
} entry;

typedef struct {
    entry **buckets;
    size_t bucket_count;
    size_t size;
} table;
```

The `buckets` field is an array of pointers, each the head of a chain. A bucket with no entries holds `NULL`. Initializing the array with `calloc` makes every bucket start as `NULL`, which is exactly what you want.

Here is insertion, which updates the value when the key already exists:

```c
int table_put(table *t, const char *key, int value) {
    size_t index = hash_string(key) % t->bucket_count;
    for (entry *e = t->buckets[index]; e != NULL; e = e->next) {
        if (strcmp(e->key, key) == 0) {
            e->value = value;          /* the key exists: update in place */
            return 1;
        }
    }
    entry *e = malloc(sizeof *e);
    if (e == NULL) return 0;
    e->key = copy_string(key);         /* the table owns its own copy of the key */
    if (e->key == NULL) {
        free(e);
        return 0;
    }
    e->value = value;
    e->next = t->buckets[index];
    t->buckets[index] = e;
    t->size++;
    return 1;
}
```

Two details are worth noticing. First, the table stores its own copy of the key, so the caller can free or change theirs. The helper `copy_string` is a small function you write yourself, because `strdup` is not part of standard C11. Second, the function checks for an existing key before it allocates, which avoids creating duplicates.

> **Pitfall:** Without a copy, the table keeps a pointer to the caller''s string. If the caller later frees or modifies that string, every lookup for that key reads garbage. Ownership of the key is a decision you must make explicitly, as lesson 7 described.

The predict question uses the chain order directly. Two integer keys share a bucket, and inserting at the front changes what you see first:

```c predict id=chain-order title="Which keys are in bucket 0, in order?"
#include <stdio.h>
#include <stdlib.h>

typedef struct entry {
    int key;
    struct entry *next;
} entry;

#define BUCKETS 2

static entry *buckets[BUCKETS];

static void put(int key) {
    entry *e = malloc(sizeof *e);
    if (e == NULL) exit(EXIT_FAILURE);
    e->key = key;
    e->next = buckets[key % BUCKETS];
    buckets[key % BUCKETS] = e;
}

int main(void) {
    put(2);
    put(4);
    put(5);
    for (entry *e = buckets[0]; e != NULL; e = e->next) printf("%d ", e->key);
    printf("\n");
    for (int b = 0; b < BUCKETS; b++) {
        for (entry *e = buckets[b], *next; e != NULL; e = next) {
            next = e->next;
            free(e);
        }
        buckets[b] = NULL;
    }
    return 0;
}
--- options
2 4
* 4 2
5 4 2
4
--- explain
Keys `2` and `4` are both even, so they go to bucket `0`. Each new entry is added to the front of its chain. `2` is inserted first, then `4` goes in front of it, so the chain reads `4`, then `2`. The key `5` goes to bucket `1`, so it does not appear in bucket `0`. The cleanup frees every chain and resets each bucket to `NULL`.
```

The last question checks the update path and a lookup that misses. A single chain is enough to see both:

```c predict id=update-or-insert title="What is printed?"
#include <stdio.h>
#include <stdlib.h>

typedef struct entry {
    int key;
    int value;
    struct entry *next;
} entry;

static entry *head = NULL;

static void put(int key, int value) {
    for (entry *e = head; e != NULL; e = e->next) {
        if (e->key == key) {
            e->value = value;
            return;
        }
    }
    entry *e = malloc(sizeof *e);
    if (e == NULL) exit(EXIT_FAILURE);
    e->key = key;
    e->value = value;
    e->next = head;
    head = e;
}

static int get(int key, int fallback) {
    for (entry *e = head; e != NULL; e = e->next) {
        if (e->key == key) return e->value;
    }
    return fallback;
}

int main(void) {
    put(7, 1);
    put(9, 5);
    put(7, 2);
    printf("%d %d %d\n", get(7, -1), get(9, -1), get(3, -1));
    while (head != NULL) {
        entry *next = head->next;
        free(head);
        head = next;
    }
    return 0;
}
--- options
1 5 -1
* 2 5 -1
2 5 3
7 9 -1
--- explain
The second `put(7, ...)` finds the existing entry and overwrites its value with `2`, so the table still holds one entry for `7`. `get(7, -1)` returns `2`, `get(9, -1)` returns `5`, and `get(3, -1)` misses and returns the fallback `-1`. The output is `2 5 -1`.
```

## Updating and removing

Updating a value is a lookup followed by an assignment, as the insert function above shows. Removing a key is the same idiom you used for linked lists in lesson 8: walk with a pointer to the pointer, unlink the matching entry, free its key and the entry itself. Remember to free the key too, because the table owns it.

## Load factor and resizing

The **load factor** is the number of entries divided by the number of buckets. With chaining, lookups take time proportional to the chain length, so the average lookup costs about one plus the load factor. When the load factor grows past a threshold, such as 0.75, the table should grow. Growing means allocating a larger bucket array, computing new indexes for every entry, and relinking each entry into its new bucket. Entries move, but their keys and values do not change.

Resizing is the moment hash tables go wrong most often. If you grow the bucket array and forget to free the old one, you leak. If you free the old array before moving the entries, you read freed memory. Move every entry first, then free the old bucket array.

> **Tip:** Choose a bucket count that is a prime number, or a power of two with a good hash function. Prime sizes spread common key patterns more evenly, and they avoid the worst case of many keys sharing a remainder.

## Hash tables in practice

A table is only as good as its hash function and its assumptions. Hash tables are vulnerable to adversarial input: an attacker who knows the hash function can choose keys that all collide, turning constant-time lookups into linear scans. Production systems mitigate this with randomized seeds, which is why the hash function you choose matters beyond speed.

> **In the wild:** Compilers use hash tables for symbol lookup, where every identifier in a program is looked up many times. Caches in web servers use them for responses, and the default dictionary in many languages is a hash table with resizing and randomized hashing.

## Recap

- A hash function turns a key into an index; unsigned arithmetic makes the wraparound defined.
- Chaining stores a linked list in each bucket and handles collisions simply.
- Insert checks for an existing key first, and the table owns a copy of its keys.
- Load factor controls performance; resize by moving every entry before freeing the old array.
- Randomized hashing protects a table from adversarial keys.

**Up next:** Sorting with `qsort` and comparator functions, which uses the function pointers you learned in lesson 5.
', 0, '[]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z'),
('les_c_advanced_3_2', 'sec_c_advanced_3', 'crs_c_advanced', 'Sorting with qsort and comparator functions', 'interactive', 1, 1320, NULL, NULL, 'Every program eventually needs to sort something: customers by name, files by size, events by timestamp, scores from highest to lowest. You could write a sort for each case, and programmers do that for speed in hot paths. For everything else, C gives you `qsort` in `<stdlib.h>`: one general function that sorts an array of any type, with a comparison function you supply. It is a direct application of the function pointers from lesson 5, and it shows the most common C API design pattern you will meet: generic code that asks the caller for the one piece of knowledge only the caller has.

This lesson explains the signature, the comparator contract, the traps that produce wrong or undefined results, and how to sort structures by several keys.

## The signature

```c
void qsort(void *base, size_t count, size_t size,
           int (*compare)(const void *, const void *));
```

`qsort` knows nothing about your type. It receives the start of the array (`base`), the number of elements, the size of one element in bytes, and a comparator. It moves the bytes around, and it calls the comparator with pointers to two elements whenever it needs to decide their order. Only the comparator knows what an element means.

## The comparator contract

A comparator returns:

- a **negative** number when the first element should come before the second,
- **zero** when they are equal in the sort order,
- a **positive** number when the first should come after the second.

The arguments are `const void *`, so the first job of every comparator is to cast them to the element type and dereference:

```c
static int compare_ints(const void *pa, const void *pb) {
    int a = *(const int *)pa;
    int b = *(const int *)pb;
    return (a > b) - (a < b);
}
```

The last line is a safe idiom. `(a > b)` is `1` when `a` is larger, and `(a < b)` is `1` when `a` is smaller. Subtracting them gives exactly `-1`, `0` or `1`, and it never overflows. That matters for the next pitfall.

> **Pitfall:** The comparator `return a - b;` looks simpler, but it overflows when the difference does not fit in an `int`. For example, `a = 2000000000` and `b = -2000000000` give a difference larger than `INT_MAX`, which is undefined behavior. The comparison form above is always safe.

The predict question sorts three integers with this comparator:

```c predict id=sort-ints title="What are the first three values after sorting?"
#include <stdio.h>
#include <stdlib.h>

static int compare_ints(const void *pa, const void *pb) {
    int a = *(const int *)pa;
    int b = *(const int *)pb;
    return (a > b) - (a < b);
}

int main(void) {
    int values[] = { 30, 10, 20 };
    qsort(values, 3, sizeof values[0], compare_ints);
    printf("%d %d %d\n", values[0], values[1], values[2]);
    return 0;
}
--- options
30 20 10
* 10 20 30
10 30 20
20 10 30
--- explain
`qsort` calls `compare_ints` to decide order. A negative result puts the first argument earlier, so the comparator sorts in ascending order. After sorting, the array holds `10`, `20`, `30`. Reversing the comparison, as in `(a < b) - (a > b)`, would sort descending.

## Sorting in descending order

Reversing the comparator reverses the output. You do not need a second sorting function, and the same code works for any type once the comparison is right:

```c
static int compare_descending(const void *pa, const void *pb) {
    int a = *(const int *)pa;
    int b = *(const int *)pb;
    return (b > a) - (b < a);
}
```

Notice that the arguments are swapped inside the expression. The clearest way to write a comparator for descending order is to compare `b` with `a`, which reads as "b before a".

## Sorting strings and structs

When the array holds pointers, the comparator receives a pointer *to* the pointer. This level of indirection surprises almost everyone, so draw it out. Here is a sort of strings, which needs a double cast:

```c
static int compare_names(const void *pa, const void *pb) {
    const char *const *a = pa;
    const char *const *b = pb;
    return strcmp(*a, *b);
}
```

The predict question sorts an array of string pointers:

```c predict id=sort-strings title="What are the names in order?"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int compare_names(const void *pa, const void *pb) {
    const char *const *a = pa;
    const char *const *b = pb;
    return strcmp(*a, *b);
}

int main(void) {
    const char *names[] = { "carol", "alice", "bob" };
    qsort(names, 3, sizeof names[0], compare_names);
    printf("%s %s %s\n", names[0], names[1], names[2]);
    return 0;
}
--- options
carol bob alice
* alice bob carol
bob alice carol
alice carol bob
--- explain
The array holds three `char *` values. `qsort` passes the comparator pointers to those pointers, so `*a` is the string itself. `strcmp` orders the strings alphabetically: `alice`, then `bob`, then `carol`. The element size is `sizeof names[0]`, which is the size of a pointer, and that is what `qsort` uses to step through the array.

Sorting an array of structs follows the same pattern. The comparator casts to the struct pointer and compares one field:

```c
typedef struct {
    char name[32];
    int score;
} player;

static int by_score_desc(const void *pa, const void *pb) {
    const player *a = pa;
    const player *b = pb;
    return (b->score > a->score) - (b->score < a->score);
}

qsort(players, count, sizeof players[0], by_score_desc);
```

The last question swaps the comparison and checks the descending order:

```c predict id=sort-descending title="What are the values after sorting?"
#include <stdio.h>
#include <stdlib.h>

static int compare_descending(const void *pa, const void *pb) {
    int a = *(const int *)pa;
    int b = *(const int *)pb;
    return (b > a) - (b < a);
}

int main(void) {
    int values[] = { 4, 9, 1 };
    qsort(values, 3, sizeof values[0], compare_descending);
    printf("%d %d %d\n", values[0], values[1], values[2]);
    return 0;
}
--- options
1 4 9
* 9 4 1
4 9 1
9 1 4
--- explain
The comparator returns a positive value when `a` is smaller than `b`, which places the larger value first. The sorted array is `9`, `4`, `1`. Because the comparison is the only thing that changed, the same `qsort` call sorts the other way, which is the point of passing the rule in as a function.

## Multi-key sorting

When two items have equal primary keys, use a second key to break the tie. A chain of comparisons does this: return the first nonzero result, and fall through to the next key only on a tie.

```c
static int by_score_then_name(const void *pa, const void *pb) {
    const player *a = pa;
    const player *b = pb;
    if (b->score != a->score) return (b->score > a->score) - (b->score < a->score);
    return strcmp(a->name, b->name);
}
```

This sorts by score from highest to lowest, and alphabetically within each score.

## What qsort does not promise

Three facts are easy to miss:

- **Stability is not guaranteed.** Two elements that compare equal may come out in either order. If you need the original order preserved for ties, add the original index as a last key.
- **The comparator must be consistent.** It must always give the same answer for the same pair, and it must order elements transitively. A comparator that sometimes says `a < b` and `b < a` makes the result unpredictable.
- **The element size must match the array.** Passing the wrong size reads or writes the wrong bytes. Write `sizeof values[0]`, not a number you typed by hand.

> **Tip:** Keep the comparator next to the type it compares, and give it a name that says the order, such as `by_score_desc`. Anyone reading `qsort` should see the rule without scrolling.

## Searching sorted arrays

Once an array is sorted, `bsearch` finds an element in logarithmic time. It uses the same comparator contract, and the key you pass must have the element type:

```c
int key = 20;
int *found = bsearch(&key, values, 3, sizeof values[0], compare_ints);
```

`bsearch` returns a pointer to the matching element, or `NULL`. The array must be sorted by the same comparison, or the search will miss elements it should find.

> **In the wild:** Command-line tools sort large files with external merge sorts that use `qsort`-style comparators on records. The same comparator design appears in database indexes, where sort order is a property the index keeps up to date.

## Recap

- `qsort` sorts any array; you supply the element size and a comparator.
- A comparator returns negative, zero or positive, and should compare rather than subtract to avoid overflow.
- For arrays of pointers, the comparator receives a pointer to a pointer.
- Sort structs by one field or several, using `strcmp` for text and falling through on ties.
- Remember that `qsort` is not stable, and that `bsearch` needs the same ordering.

**Up next:** Bit manipulation: masks, shifts and flags, the low-level tools that compact storage and fast algorithms rely on.
', 0, '[]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z'),
('les_c_advanced_3_3', 'sec_c_advanced_3', 'crs_c_advanced', 'Bit manipulation: masks, shifts and flags', 'interactive', 2, 1320, NULL, NULL, 'Computers store everything as bits, and C is one of the few high-level languages that lets you work with those bits directly. Bit operations are how you pack several true-or-false settings into one byte, how you test a hardware register, how network protocols read their headers and how fast algorithms count and compare sets of values. They are also a common source of subtle bugs, because the rules about shifting and sign are full of traps.

This lesson covers the bitwise operators, the masks that make them useful, the shifts and their limits, and the idioms that appear in real systems code. It uses unsigned types throughout, because their behavior is fully defined, and it shows you why.

## The operators

| Operator | Name | Meaning on each bit |
|---|---|---|
| `&` | AND | 1 only if both bits are 1 |
| `\|` | OR | 1 if either bit is 1 |
| `^` | XOR | 1 if the bits differ |
| `~` | NOT | flips every bit |
| `<<` | left shift | moves bits left, filling with zeros |
| `>>` | right shift | moves bits right |

Use unsigned types for bit work. An `unsigned int` has a fixed width and well-defined results for every operator. Signed types add questions about the sign bit, shifts that overflow and implementation-defined right shifts, which you should avoid for bit-level code.

## Masks: testing, setting and clearing

A **mask** is a value whose bits select the positions you care about. You combine a value with a mask using AND, OR or XOR to test, set or toggle those positions:

```c
#define FLAG_READ   (1u << 0)   /* 0b0001 */
#define FLAG_WRITE  (1u << 1)   /* 0b0010 */
#define FLAG_EXEC   (1u << 2)   /* 0b0100 */

unsigned int perms = FLAG_READ | FLAG_WRITE;   /* set two flags */

if (perms & FLAG_WRITE) { /* test: the write bit is on */ }
perms &= ~FLAG_WRITE;     /* clear: turn the write bit off */
perms ^= FLAG_EXEC;       /* toggle: flip the exec bit */
```

The idiom to memorize is `value &= ~mask` to clear, and `value |= mask` to set. The `~` turns the mask inverse, so AND with it keeps every other bit.

The predict question below uses a mask to test one bit:

```c predict id=mask-test title="What is printed?"
#include <stdio.h>

int main(void) {
    unsigned int flags = 0x0A;
    printf("%u\n", flags & 0x02);
    return 0;
}
--- options
0
* 2
8
10
--- explain
`0x0A` is binary `1010`, and `0x02` is binary `0010`. ANDing them keeps only the bit in position 1, which is set in both, so the result is `0010`, which is `2`. The other bits are masked out. A result of `0` would mean the tested bit was off.

## Shifts

Left shift multiplies by a power of two, and right shift divides by one for unsigned values. Shifts are also how you build masks: `1u << n` is a value with only bit `n` set. Shifting is a common way to extract a field from a packed value:

```c
unsigned int color = 0x00AABBCC;
unsigned int red   = (color >> 16) & 0xFF;   /* 0xAA */
unsigned int green = (color >> 8)  & 0xFF;   /* 0xBB */
unsigned int blue  =  color        & 0xFF;   /* 0xCC */
```

The `& 0xFF` after each shift is essential. It removes the bits from the higher fields that shifted down into the low byte.

> **Pitfall:** Shifting by a negative amount or by at least the width of the type is undefined behavior, and so is shifting a negative signed value left. Keep shift counts between 0 and one less than the bit width, and use unsigned operands. Writing `1 << 31` with plain `int` is a classic trap, because `1` is an `int` there; write `1u << 31` instead.

Operator precedence is the other trap. `<<` binds more tightly than `&` and `|`, but `==` binds more tightly than `&`. That is why `flags & MASK == 0` does not do what it looks like: the comparison happens first, so the code tests `flags & (MASK == 0)`. Parenthesize every bit expression. The predict question checks precedence explicitly:

```c predict id=shift-precedence title="What is printed?"
#include <stdio.h>

int main(void) {
    printf("%u\n", 1u << 4 | 1u);
    return 0;
}
--- options
* 17
16
5
32
--- explain
Shift binds more tightly than bitwise OR, so `1u << 4` is evaluated first, which is `16`. Then `16 | 1` sets the lowest bit, giving `17`. The result is `17`, which is binary `10001`. Writing `1u << (4 | 1)` would mean something else entirely, which is why parentheses are worth the extra characters.

## Counting and testing with tricks

Some bit tricks are short enough to learn by heart, and they show up in every low-level codebase:

```c
/* Is x a power of two? (zero is excluded) */
int is_pow2(unsigned int x) {
    return x != 0 && (x & (x - 1)) == 0;
}

/* Clear the lowest set bit. */
x &= x - 1;

/* Isolate the lowest set bit. Negation of an unsigned value is defined (it wraps). */
lowest = x & (0u - x);
```

`x & (x - 1)` removes the lowest set bit, because subtracting one flips it and every bit below it. If that leaves zero, `x` had exactly one bit set.

The last predict question uses clearing with a mask and NOT:

```c predict id=clear-bits title="What is printed?"
#include <stdio.h>

int main(void) {
    unsigned int v = 0x0F;
    v &= ~0x03u;
    printf("%u\n", v);
    return 0;
}
--- options
15
* 12
3
0
--- explain
`~0x03u` has every bit set except bits 0 and 1. Applied to `0x0F`, which is `1111`, the AND keeps the top two bits and clears the bottom two, leaving `1100`. That is `12`. The `u` suffix keeps the whole expression unsigned, so no sign question arises.
```

## Bit fields and packing

Bit fields in a struct describe several small integers within one storage unit. They are convenient and readable, but their layout is implementation-defined: the order of fields within a unit and whether they can straddle a boundary vary between compilers. Use bit fields when you control both ends of the data, such as an internal structure, and use explicit masks and shifts for anything that crosses a network or a file. You will meet this distinction again in lesson 14 on struct layout.

> **In the wild:** Network protocols such as IPv4 pack version, header length, flags and fragment offsets into fixed-width fields. Parsers read them with shifts and masks, and getting one bit wrong breaks every packet that follows.

## Recap

- Use unsigned types for bit work, and build masks with `1u << n`.
- Set with `|=`, clear with `&= ~mask`, toggle with `^=`, test with `&`.
- Shift counts must be between 0 and one less than the width; avoid shifting signed values.
- Parenthesize bit expressions, because precedence differs from what it looks like.
- Learn `x & (x - 1)` for power-of-two checks and for clearing the lowest bit.

**Up next:** Struct layout, padding and alignment, and why `sizeof` on a struct can be larger than the sum of its fields.
', 0, '[]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z'),
('les_c_advanced_3_4', 'sec_c_advanced_3', 'crs_c_advanced', 'Struct layout, padding and alignment', 'interactive', 3, 1320, NULL, NULL, 'You declare a struct as a list of fields, and it feels like the sum of those fields. Then you call `sizeof` and get a bigger number than you expected. The extra bytes are **padding**, and they are not a mistake. They are how the compiler makes every field start at an address the processor can read efficiently, or at all. Understanding layout matters for three reasons: it affects memory use in large arrays, it decides whether data can be shared with a file or the network, and it sets the rules for casting between types.

This lesson explains alignment, shows why padding appears, teaches you to arrange fields to waste less space, and marks the boundaries of what the standard promises. Because the exact padding is implementation-defined, the predict questions check the guarantees, not specific byte counts.

## Alignment

Every type has an **alignment requirement**: the address of an object of that type must be a multiple of some number. An `int` with a 4-byte alignment must start at an address divisible by 4. The reason is hardware. Many processors read a 4-byte value in one operation only when it sits on a 4-byte boundary, and on some they fault or read slowly otherwise.

C11 gives you two tools for alignment:

```c
#include <stdalign.h>

size_t a = alignof(int);       /* the alignment of int, often 4 */
size_t b = alignof(double);    /* often 8 */
```

You will rarely write these numbers, but they explain the layout the compiler chooses.

## Why padding appears

Consider this struct:

```c
struct sample {
    char tag;      /* 1 byte */
    int  count;    /* needs a 4-byte boundary */
    char flag;     /* 1 byte */
};
```

The `char` at the start takes one byte. The `int` must begin at a multiple of its alignment, so the compiler inserts padding after `tag` to move `count` to the next boundary. The trailing `char` takes another byte, and the total size is then rounded up so that every element of an array of these structs is aligned correctly. On common 64-bit systems this struct is 12 bytes, though the standard does not promise that number. Your 6 bytes of data occupy 12 bytes of storage.

The predict question checks only the guarantee that always holds. A struct is at least as large as the sum of its members, because padding can only add bytes:

```c predict id=struct-guarantee title="Does sizeof report at least the sum of the members?"
#include <stdio.h>

struct sample {
    char tag;
    int count;
    char flag;
};

int main(void) {
    size_t members = sizeof(char) + sizeof(int) + sizeof(char);
    printf("%d\n", (int)(sizeof(struct sample) >= members));
    return 0;
}
--- options
0
* 1
2
compile error
--- explain
The three members add up to `sizeof(char) + sizeof(int) + sizeof(char)`. Padding can only insert bytes, never remove them, so `sizeof(struct sample)` is always at least that sum. The comparison is true, which prints `1`. The exact size is up to the compiler, which is why this predict question checks the inequality rather than a number.

## Reordering to save space

Padding depends on the order of fields. Placing the largest and most strictly aligned fields first, and grouping small ones together, reduces the gaps. Compare two versions of the same data:

```c
struct loose {
    char a;      /* padding follows */
    double b;
    char c;      /* padding follows */
};

struct tight {
    double b;
    char a;
    char c;      /* the two chars can share the same tail padding */
};
```

Both structs hold the same data. The second usually uses less space, because the two `char` fields sit next to each other instead of being separated by a `double`''s alignment. In a large array, the saving multiplies. Reordering is a free optimization that does not change the program''s meaning, and it is worth doing for big tables of records.

> **Tip:** When you design a record type, sort its members by alignment from largest to smallest. It is simple, predictable and usually optimal. Check the result with `sizeof` on your target platform, and do not guess.

> **Pitfall:** Do not rely on a specific layout when you write data to a file or send it over a network. Padding, byte order and the representation of fields differ between machines. Write each field explicitly, in a fixed byte order, with fixed-width types from `<stdint.h>`, and check the result.

## Arrays of structs and pointer arithmetic

An array of structs is a contiguous block, and each element begins one `sizeof` after the previous one. Pointer arithmetic moves by whole elements, which makes a loop over records simple and fast. The next predict question uses that fact, along with the arrow operator:

```c predict id=array-of-structs title="What is printed?"
#include <stdio.h>

struct item {
    int id;
    int quantity;
};

int main(void) {
    struct item items[3] = { { 101, 2 }, { 102, 5 }, { 103, 1 } };
    struct item *p = items + 1;
    printf("%d\n", (p + 1)->id);
    return 0;
}
--- options
101
102
* 103
1
--- explain
`items + 1` points at the second element, `{102, 5}`. Adding one more element moves the pointer to the third, `{103, 1}`. The arrow operator `->` reads the `id` field of that element, which is `103`. Pointer arithmetic on `struct item *` steps by `sizeof(struct item)` bytes, which is why the program does not need to know that size.
```

One size is fixed by the standard, and it anchors every other calculation: `sizeof(char)` is always 1. Everything else is measured in those units:

```c predict id=char-size title="What is printed?"
#include <stdio.h>

int main(void) {
    printf("%d\n", (int)sizeof(char));
    return 0;
}
--- options
2
4
* 1
8
--- explain
The standard defines a `char` as one byte, and `sizeof` counts in bytes, so `sizeof(char)` is always `1` on every conforming compiler. That is why the number of bytes in a buffer equals the number of characters it can hold, and why `malloc(n)` for a string of `n` characters works without multiplying.

## Copying and comparing structs

Assignment copies every member, padding included or not, and it is defined for any struct. Comparing two structs with `==` is not allowed in C, because padding bytes may contain anything. Compare field by field, or use a function that does. This is a rule you will hit early, and the field-by-field version is the one to write:

```c
static int point_equal(struct point a, struct point b) {
    return a.x == b.x && a.y == b.y;
}
```

Also note that `memcmp` on whole structs is not reliable for equality when padding exists, because padding bytes are not guaranteed to be zero.

## Flexible array members

The last member of a struct may be an array with no declared size. This lets you allocate a header and its data in one block, which is a common pattern for buffers and messages:

```c
typedef struct {
    size_t length;
    char data[];          /* flexible array member: must be last */
} message;

message *m = malloc(sizeof *m + text_length + 1);
m->length = text_length;
memcpy(m->data, text, text_length + 1);
```

The allocation adds the space for the data after the header. Only allocate with `sizeof *m` plus the extra bytes, and free the whole block with a single `free`.

> **In the wild:** Network stacks and file formats define their structures with explicit field sizes and packing rules, because the compiler''s default layout is not a contract. When a protocol says "the field at offset 4 is a 16-bit length", the code must put it there exactly.

## Recap

- Each type has an alignment; the compiler inserts padding so fields land on aligned addresses.
- A struct''s size is at least the sum of its members and often larger because of padding.
- Ordering members from largest to smallest alignment usually reduces the waste.
- Never assume a particular layout for files or networks; write fields explicitly.
- Compare structs field by field, and use flexible array members for header-plus-data blocks.

**Up next:** Unions and type punning, and how `memcpy` reads a value''s bytes safely, without breaking the aliasing rules.
', 0, '[]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z'),
('les_c_advanced_3_5', 'sec_c_advanced_3', 'crs_c_advanced', 'Unions and type punning with memcpy', 'interactive', 4, 1200, NULL, NULL, 'A struct stores all of its members side by side. A **union** stores them on top of each other: every member starts at the same address, and the storage is only as big as the largest member. A union can hold one of several types at a time, which makes it the natural tool for a tagged value, such as a JSON node that is a number, a string or a list. It also makes unions a common source of confusion, because reading a member you did not write is one of the places where C''s rules get genuinely subtle.

This lesson shows how to use unions correctly, explains **type punning**, the practice of reinterpreting the bits of one type as another, and shows the portable way to do it with `memcpy`. You will also learn why the naive version is dangerous, even when it appears to work.

## Unions as tagged values

The safe and common use of a union is to store one of several variants, plus a tag that says which variant is active:

```c
typedef enum { VALUE_INT, VALUE_TEXT } value_kind;

typedef struct {
    value_kind kind;
    union {
        long integer;
        const char *text;
    } as;
} value;
```

The tag `kind` is the agreement between the writer and the reader. Every access to `as` must check it first, and a `switch` on the tag keeps the code honest:

```c
long value_sum(const value *items, size_t count) {
    long total = 0;
    for (size_t i = 0; i < count; i++) {
        switch (items[i].kind) {
        case VALUE_INT:  total += items[i].as.integer; break;
        case VALUE_TEXT: /* text does not contribute */ break;
        }
    }
    return total;
}
```

This pattern is the C equivalent of a sum type, and you will see it in parsers, interpreters and message formats. The predict question uses a simplified version of it:

```c predict id=tagged-sum title="What is printed?"
#include <stdio.h>

typedef enum { INT_KIND, TEXT_KIND } kind;

typedef struct {
    kind tag;
    union {
        int number;
        const char *text;
    } as;
} item;

int main(void) {
    item items[3] = {
        { INT_KIND, { .number = 4 } },
        { TEXT_KIND, { .text = "skip me" } },
        { INT_KIND, { .number = 6 } },
    };
    int total = 0;
    for (int i = 0; i < 3; i++) {
        if (items[i].tag == INT_KIND) total += items[i].as.number;
    }
    printf("%d\n", total);
    return 0;
}
--- options
4
* 10
13
skip me
--- explain
The tag decides which member is valid. The first and third items are `INT_KIND`, so their numbers `4` and `6` are added, giving `10`. The middle item is `TEXT_KIND`, so the loop skips its `text` member. The designated initializers `.number` and `.text` set exactly the member named, which is clearer than relying on position.

> **Tip:** Keep the tag and the union in the same struct, and write one function that switches on the tag. Scattered `if` checks on a bare union are where the bugs hide.

## Reading the wrong member

A union lets you write one member and read another. Whether that is allowed depends on the types. The standard says that reading a member that was not the last one written is undefined behavior, with one exception: you may view any object''s bytes through a character type. So the following is not the portable way to see a float''s bits:

```c
union bits { float f; uint32_t u; };
union bits b;
b.f = 1.0f;
uint32_t raw = b.u;     /* undefined behavior in strict C */
```

Compilers document that this works on their platforms, and it is tempting. Do not rely on it. The compiler is allowed to assume it never happens, and optimizations can break the code in surprising ways.

## Type punning with memcpy

The portable way to reinterpret bytes is `memcpy`. It copies the bytes of one object into another, and the standard defines the result as a copy of the same representation, with no aliasing rules broken. The predict question copies an int''s bytes into a new object, and it uses a different value from the source to make the copy visible:

```c predict id=memcpy-copy title="What is printed?"
#include <stdio.h>
#include <string.h>

int main(void) {
    int src[3] = { 1, 2, 3 };
    int dst[3] = { 0, 0, 0 };
    memcpy(dst, src + 1, 2 * sizeof(int));
    printf("%d %d %d\n", dst[0], dst[1], dst[2]);
    return 0;
}
--- options
1 2 3
* 2 3 0
0 2 3
2 3 3
--- explain
`src + 1` points at the second element, `2`. Copying two `int`s from there fills `dst[0]` with `2` and `dst[1]` with `3`. The third element of `dst` was never touched, so it keeps its initial `0`. `memcpy` moves exactly the number of bytes you ask for, measured in bytes, which is why the size is `2 * sizeof(int)`.

When the goal is the bits of a float, `memcpy` gives the portable answer:

```c
float f = 1.0f;
uint32_t bits;
memcpy(&bits, &f, sizeof bits);   /* the bit pattern of f, with no aliasing violation */
```

The copy assumes that `float` and `uint32_t` have the same size, which holds on most systems but is not guaranteed by the standard. Check it with `_Static_assert(sizeof(float) == sizeof(uint32_t), "size")` before you rely on it. Also remember that the bit layout of floating-point numbers is defined by IEEE 754 on nearly every platform, but the standard leaves the representation implementation-defined.

## Byte order

When you inspect individual bytes of a multi-byte value, the order of those bytes depends on the machine. Little-endian systems store the least significant byte first, and big-endian systems store it last. Network protocols use big-endian order, so code that reads them must convert explicitly rather than assume the native order. Writing bytes by shifting and masking, as lesson 13 showed, is the portable way to build a value from a sequence of bytes:

```c
uint32_t read_be32(const unsigned char *p) {
    return ((uint32_t)p[0] << 24) | ((uint32_t)p[1] << 16)
         | ((uint32_t)p[2] << 8)  |  (uint32_t)p[3];
}
```

This function gives the same result on every machine, because it never looks at the native byte order. The predict question feeds it four bytes from a network-style packet:

```c predict id=read-be32 title="What is printed?"
#include <stdio.h>
#include <stdint.h>

static uint32_t read_be32(const unsigned char *p) {
    return ((uint32_t)p[0] << 24) | ((uint32_t)p[1] << 16)
         | ((uint32_t)p[2] << 8)  |  (uint32_t)p[3];
}

int main(void) {
    const unsigned char packet[4] = { 0x01, 0x02, 0x03, 0x04 };
    printf("%u\n", read_be32(packet));
    return 0;
}
--- options
67305985
* 16909060
1234
0
--- explain
The first byte is the most significant, so the value is `0x01020304`. In decimal that is `16909060`. Each byte is shifted into its place, and the shifts are on `uint32_t`, so the result is defined on every machine. The option `67305985` is what you would get by reading the same bytes in little-endian order, which is exactly the mistake this function avoids.
```

> **Pitfall:** Casting a pointer to a different type and reading through it breaks the strict aliasing rules, and the compiler may reorder your reads and writes. Code that does this often works in testing and fails after an optimization change. Use `memcpy`, or a union read through a character type.

## When unions are the right choice

Use a union when the variants are exclusive and the tag makes the choice explicit. Avoid unions as a way to reinterpret data: `memcpy` is clearer, portable and fast, because compilers reduce it to a single move. Keep the union inside a struct with its tag, and document which member is valid under each tag.

> **In the wild:** Binary formats such as image headers and network packets are often read with `memcpy` plus byte-order conversion, because the reading code must work on every machine. Tagged unions carry the variants of configuration files, interpreter values and AST nodes in compilers.

## Recap

- A union stores one of several members at the same address; its size is the largest member.
- Use a tag and a `switch` to make a union safe, and read only the member the tag names.
- Reading an inactive union member is undefined in strict C, so avoid it for type punning.
- Use `memcpy` to reinterpret bytes portably, and check size assumptions with `_Static_assert`.
- Convert byte order explicitly when reading external data; never rely on the machine''s native order.

**Up next:** Advanced macros, X-macros for generating code from one list, and the discipline that keeps macro-heavy code readable.
', 0, '[]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z'),
('les_c_advanced_3_6', 'sec_c_advanced_3', 'crs_c_advanced', 'Checkpoint: data structures & algorithms', 'quiz', 5, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"Why does a hash table''s insert function compare keys before allocating a new entry?","options":["The allocator is slower when the key already exists","So that an existing key is updated in place rather than duplicated","Because strcmp must run before malloc can be called","To make the bucket count grow automatically"],"answerIndex":1,"explanation":"The search for an existing key ensures each key appears once. If the key exists, its value is updated. Otherwise a new entry is linked at the front of its bucket''s chain."},{"id":"q2","prompt":"What must a qsort comparator return to place the first argument before the second?","options":["Zero","A positive number","A negative number","The first argument''s value"],"answerIndex":2,"explanation":"A negative result means the first element comes earlier in the sorted order. Zero means they are equal, and positive means the first element comes after the second."},{"id":"q3","prompt":"Which expression clears bit 2 of the unsigned variable flags, leaving every other bit as it was?","options":["flags |= 1u << 2","flags ^= 1u << 2","flags &= ~(1u << 2)","flags &= 1u << 2"],"answerIndex":2,"explanation":"Setting a bit uses OR, and toggling uses XOR. To clear a bit, AND with the inverted mask, which keeps every other bit and turns off the chosen one. Ending with &= 1u << 2 would keep only bit 2."},{"id":"q4","prompt":"Why can sizeof(struct s) be larger than the sum of its members'' sizes?","options":["Because sizeof counts a hidden header for each struct","Because the compiler inserts padding so each member meets its alignment","Because struct members are always stored as pointers","Because sizeof includes the size of the struct''s name"],"answerIndex":1,"explanation":"Each type has an alignment requirement. The compiler adds padding between members, and after the last one, so every member starts at a suitably aligned address and every element of an array stays aligned."},{"id":"q5","prompt":"What is the portable way to reinterpret the bytes of a float as a uint32_t?","options":["Cast the float pointer to uint32_t * and dereference it","Store the float in a union and read the uint32_t member","Use memcpy to copy the bytes into the uint32_t","Use the bitwise AND operator with the float value"],"answerIndex":2,"explanation":"memcpy copies the representation without breaking the strict aliasing rules, and it is the form compilers optimize well. Pointer casts and reading an inactive union member are undefined behavior in strict C."}]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z'),
('les_c_advanced_4_1', 'sec_c_advanced_4', 'crs_c_advanced', 'Advanced macros and X-macros', 'interactive', 0, 1320, NULL, NULL, 'Lesson 2 showed that macros are text substitution, which makes them both powerful and risky. Used carefully, macros let you write code that the language itself cannot express: generating a table of names from one list, creating a family of similar functions, or turning a constant into a readable string. Used carelessly, they hide bugs, make errors impossible to read and break under unexpected arguments.

This lesson covers the macro techniques that real C libraries rely on: multi-line macros written safely, the `#` and `##` operators, and the **X-macro** pattern, which keeps several parallel lists in sync by generating each one from a single source. You will also learn when a macro is the wrong tool, which matters more than any trick.

## Multi-line macros: do { } while (0)

A macro that expands to several statements needs a wrapper, or it breaks when used in an `if` without braces. The standard idiom is a `do { ... } while (0)` block, which is a single statement that the semicolon after the macro completes:

```c
#define INC_TWICE(x) do { (x)++; (x)++; } while (0)
```

The predict question shows why the wrapper matters. Without it, the second increment would run outside the `if`:

```c predict id=do-while-macro title="What is printed?"
#include <stdio.h>

#define INC_TWICE(x) do { (x)++; (x)++; } while (0)

int main(void) {
    int n = 1;
    if (n == 1) INC_TWICE(n);
    else printf("no\n");
    printf("%d\n", n);
    return 0;
}
--- options
1
2
* 3
4
--- explain
`n` starts at `1`, so the condition is true and the macro runs. The `do { } while (0)` block is one statement, so the `else` attaches to the `if` correctly. Both increments happen, leaving `n` at `3`. A bare `{ (x)++; (x)++; }` would also work inside this `if`, but a bare block followed by a semicolon breaks an `if`/`else` pair, which the wrapper prevents.

Multiple evaluation is the other hazard: a macro argument with side effects runs once for every place it appears. Parenthesize every parameter, and prefer an inline function when the macro does not need to work on types or statements.

## The stringizing and pasting operators

The `#` operator turns an argument into a string literal, as lesson 2 showed. The `##` operator joins two tokens into one, which lets a macro create identifiers. Together they let you generate many similar names from a pattern:

```c
#define DECLARE_COUNTER(name) static int name##_count = 0;
#define REPORT(name) printf("%s: %d\n", #name, name##_count);
```

The predict question uses token pasting to create a variable with a computed name:

```c predict id=token-paste title="What is printed?"
#include <stdio.h>

#define MAKE_VAR(n) int var_##n = (n) * 10;

MAKE_VAR(3)

int main(void) {
    printf("%d\n", var_3);
    return 0;
}
--- options
3
* 30
var_3
compile error
--- explain
`MAKE_VAR(3)` expands to `int var_3 = (3) * 10;`. The `##` operator pasted `var_` and the argument `3` into the single identifier `var_3`. The initializer evaluates to `30`, which the `printf` prints.

> **Pitfall:** Token pasting creates identifiers that are invisible to the search tools most people use. A macro that defines `handle_##name` can make a function that nobody can find by searching for `handle_`. Name generated code clearly, and keep the generating macro near its uses.

## X-macros: one list, many uses

Often a program needs the same list in several places: an enum of error codes, a table of their names, a table of their messages. Keeping those lists in sync by hand is error-prone. An **X-macro** puts the list in one place as a macro that takes another macro as an argument. Each use supplies a different macro, and the list expands once per use.

```c
#define COLOR_LIST(X) \
    X(RED)            \
    X(GREEN)          \
    X(BLUE)

#define AS_ENUM(name) COLOR_##name,
#define AS_NAME(name) #name,

typedef enum { COLOR_LIST(AS_ENUM) COLOR_COUNT } color;
static const char *color_names[] = { COLOR_LIST(AS_NAME) };
```

The enum and the name table now come from the same list. Adding `YELLOW` to `COLOR_LIST` updates both automatically, so the names cannot drift out of order. That is the entire value of the pattern: one edit, every table stays correct.

The predict question checks the generated table:

```c predict id=x-macro-names title="Which name is at index 1?"
#include <stdio.h>

#define COLOR_LIST(X) \
    X(RED)            \
    X(GREEN)          \
    X(BLUE)

#define AS_NAME(name) #name,

static const char *color_names[] = { COLOR_LIST(AS_NAME) };

int main(void) {
    printf("%s\n", color_names[1]);
    return 0;
}
--- options
RED
* GREEN
BLUE
COLOR_LIST
--- explain
`COLOR_LIST(AS_NAME)` expands to `"RED", "GREEN", "BLUE",`, because `AS_NAME` stringizes each name and adds a comma. Index `1` is the second entry, `"GREEN"`. The table is generated from the list, so it is never out of step with the enum built from the same list.
```

## Generating functions and switch cases

The same technique creates functions for each entry. A macro can declare one function per name, and a second macro can build a dispatch table from the same list, so you never write the repetitive code by hand. The benefit grows with the size of the list, and so does the risk of making the macro hard to read. Keep the list macro short, name the parameter so the purpose is clear, and document what each use expects.

> **Tip:** Put the list macro in its own header file, such as `colors.def`, and `#include` it at each use with the macros defined just before. This is the classic `.def` file pattern used in compilers and kernels, and it keeps large lists readable.

## When not to use a macro

Macros do not respect scope, types or evaluation order, and debuggers show the code after expansion, which is hard to follow. Prefer these alternatives when they work:

- A `static inline` function instead of a macro that computes a value.
- A `const` variable or an `enum` instead of a `#define` constant, so the type is checked and the name appears in debugger output.
- Ordinary code instead of a macro that generates statements, unless the repetition is large and the macro is well tested.

Macros earn their place when they generate code the language cannot express, such as stringizing a name or building a list used in several places. Reach for them for those reasons, and not for convenience.

> **In the wild:** Operating system kernels use X-macros to define system call tables and error code names, because the tables must match the enum exactly. Compilers use `.def` files for instruction sets and diagnostic messages for the same reason.

## Recap

- Wrap multi-statement macros in `do { ... } while (0)` so they behave like one statement.
- Use `#` to stringize an argument and `##` to paste tokens into a new identifier.
- An X-macro keeps several parallel lists in sync by generating each one from a single list macro.
- Prefer inline functions, `const` values and enums when they do the job, and name generated code clearly.
- Keep macro lists in `.def` files and document what each use expects.

**Up next:** Generic containers with `void *`, where one implementation serves many element types.
', 0, '[]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z'),
('les_c_advanced_4_2', 'sec_c_advanced_4', 'crs_c_advanced', 'Generic containers with void pointers', 'interactive', 1, 1440, NULL, NULL, 'C does not have templates or generics. If you want one stack implementation that works for integers, strings and records, you must get the flexibility from elsewhere. The standard library did it with `void *`, the address of any object, combined with a size, and with comparator and callback functions. `qsort`, `bsearch` and `memcpy` all work this way. Learning the pattern lets you write containers, algorithms and APIs that serve many types without copying the code for each.

This lesson shows how to write generic code with `void *` and element sizes, how to move elements safely with `memcpy`, how to address them with `char *` arithmetic, and how to keep ownership and cleanup in the hands of the caller. It also shows the limits of the approach: the compiler checks less, so the discipline has to come from you.

## The principle: pointer plus size

Every element in a generic container is described by two things: the address of its bytes and the size of one element. A generic function never needs to know the type. It only needs to copy, compare or address `size` bytes at a time. This is why the standard functions take a `size_t` argument next to every pointer.

The first example is a swap. It cannot use `=` on the values, because it does not know their type, so it copies bytes through a temporary buffer:

```c
#include <string.h>

static void swap_elements(void *a, void *b, size_t size) {
    unsigned char tmp[256];          /* this sketch supports elements up to 256 bytes */
    memcpy(tmp, a, size);
    memcpy(a, b, size);
    memcpy(b, tmp, size);
}
```

The check `size <= sizeof tmp` belongs in real code, and the function should refuse larger elements instead of overflowing the buffer. A production version would allocate the temporary when the size is large. Here, the size limit is a contract, and the comment states it.

The predict question swaps two integers through the generic function:

```c predict id=generic-swap title="What is printed?"
#include <stdio.h>
#include <string.h>

static void swap_elements(void *a, void *b, size_t size) {
    unsigned char tmp[256];
    memcpy(tmp, a, size);
    memcpy(a, b, size);
    memcpy(b, tmp, size);
}

int main(void) {
    int x = 3;
    int y = 8;
    swap_elements(&x, &y, sizeof x);
    printf("%d %d\n", x, y);
    return 0;
}
--- options
3 8
* 8 3
0 0
3 3
--- explain
The function copies `x`''s bytes into the temporary, copies `y`''s bytes into `x`, then copies the temporary into `y`. The values exchange without the function knowing that they are integers. The `sizeof x` argument tells the function how many bytes make one element, which is the only type information it needs.

## Addressing elements with char pointers

To find element `i` in a block of elements, you move `i * size` bytes from the base address. Pointer arithmetic on a `char *` (or `unsigned char *`) is the only way to move by bytes, because `char` has size 1 by definition. Converting back to the element type happens at the point of use:

```c
static void *element_at(void *base, size_t index, size_t size) {
    return (unsigned char *)base + index * size;
}
```

The next question reads an element through that function. The cast to `int *` happens only when the code knows the element''s type:

```c predict id=element-at title="What is printed?"
#include <stdio.h>
#include <stddef.h>

static void *element_at(void *base, size_t index, size_t size) {
    return (unsigned char *)base + index * size;
}

int main(void) {
    int values[3] = { 5, 6, 7 };
    printf("%d\n", *(int *)element_at(values, 2, sizeof values[0]));
    return 0;
}
--- options
5
6
* 7
15
--- explain
`element_at` moves `2 * sizeof(int)` bytes past the start of `values`, which lands on the third element, `7`. The caller casts the returned `void *` to `int *` and dereferences it. Notice that the function never multiplies by an element type, so the same code would work for any array whose element size you pass in.

## A generic stack

Now combine those pieces into a container. The container stores a copy of each element, in a buffer it owns. The caller supplies the element size when it creates the stack, and pushes by copying from a pointer the caller holds:

```c
typedef struct {
    unsigned char *data;
    size_t size;        /* bytes per element */
    size_t count;
    size_t capacity;    /* in elements */
} stack;

int stack_push(stack *s, const void *element) {
    if (s->count == s->capacity) {
        size_t new_capacity = s->capacity ? s->capacity * 2 : 8;
        unsigned char *grown = realloc(s->data, new_capacity * s->size);
        if (grown == NULL) return 0;
        s->data = grown;
        s->capacity = new_capacity;
    }
    memcpy(s->data + s->count * s->size, element, s->size);
    s->count++;
    return 1;
}

void *stack_top(stack *s) {
    return s->count ? s->data + (s->count - 1) * s->size : NULL;
}
```

The container copies each element into its buffer. That design is simple and safe for values, because the caller can reuse or free its own variable after the push. It is the same ownership rule you learned in lesson 7: the stack owns its copy, and the caller owns the original.

> **Pitfall:** A container that stores copies cannot know how to copy an element that holds its own heap pointers, such as a string. A shallow `memcpy` duplicates the pointer, and two owners then free the same block. For such types, the container needs callbacks: a copy function and a destroy function, supplied by the caller. This is the pattern used by most real generic containers.

The predict question checks the stack''s copy semantics:

```c predict id=stack-copy title="What is printed?"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    unsigned char *data;
    size_t size;
    size_t count;
    size_t capacity;
} stack;

static int stack_push(stack *s, const void *element) {
    if (s->count == s->capacity) {
        size_t new_capacity = s->capacity ? s->capacity * 2 : 2;
        unsigned char *grown = realloc(s->data, new_capacity * s->size);
        if (grown == NULL) return 0;
        s->data = grown;
        s->capacity = new_capacity;
    }
    memcpy(s->data + s->count * s->size, element, s->size);
    s->count++;
    return 1;
}

int main(void) {
    stack s = { NULL, sizeof(int), 0, 0 };
    int value = 4;
    stack_push(&s, &value);
    value = 9;
    stack_push(&s, &value);
    printf("%d %d\n", *(int *)s.data, *(int *)(s.data + s.size));
    free(s.data);
    return 0;
}
--- options
9 9
4 9
* 4 9
9 4
--- explain
`stack_push` copies the bytes of `value` into the buffer each time. The first push stores `4`. Then `value` changes to `9` and the second push stores a separate copy of `9`. The buffer therefore holds `4` followed by `9`. Changing the original variable after the push does not change the stored element, which is what makes the copy semantics explicit.
```

## Designing the interface

A generic container is only as safe as its contract. Write these things down in the header:

- **Element size:** the caller passes it at creation, and every operation uses it.
- **Ownership:** the container owns its copies. Elements returned from `stack_top` are borrowed and become invalid after the next push, because `realloc` may move the buffer.
- **Failure:** every allocating operation reports failure through its return value.
- **Cleanup:** a `stack_destroy` function frees the buffer. Callers must not free it directly.

> **Tip:** Store the element size inside the container, so no caller can pass the wrong size on a later call. The size is a property of the container''s type, and the interface should make the wrong call impossible.

> **In the wild:** The C standard library uses `void *` plus size for `qsort`, `bsearch`, `memcpy` and `fwrite`. Many libraries, including hash tables in database engines and generic lists in kernels, use the same design, adding copy and destroy callbacks for types that own resources.

## Recap

- Generic C code works on `void *` addresses and an explicit element size.
- Use `char *` arithmetic to move by bytes, and cast to the real type only where it is known.
- Copy elements with `memcpy`, and make the container own its copies.
- Shallow copies are wrong for types that own resources; supply copy and destroy callbacks.
- Document ownership, element size and failure behavior in the interface.

**Up next:** Binary files and error handling with `errno`, the file operations that persist the data structures you have built.
', 0, '[]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z'),
('les_c_advanced_4_3', 'sec_c_advanced_4', 'crs_c_advanced', 'Binary files and error handling with errno', 'interactive', 2, 1440, NULL, NULL, 'Real programs must survive files that are missing, disks that are full, permissions that changed and power cuts in the middle of a write. Most beginner code treats file operations as if they always succeed. Production code treats every file operation as something that can fail, reports the failure with a meaningful message, and leaves the data in a state that can be recovered. This lesson gives you that discipline for binary files, the format you need for speed and exactness, and it shows how C reports errors through return values and `errno`.

The examples here use only standard C11 functions. Some operations, such as `fsync` and `rename` semantics, belong to POSIX, and the lesson marks where that matters.

## Text versus binary

A file opened in text mode may translate line endings and interpret bytes in platform-specific ways. A file opened in binary mode is a sequence of bytes, exactly as written. For structured data such as arrays of integers or records, binary mode is the right choice. Add `b` to the mode:

```c
FILE *in  = fopen("data.bin", "rb");   /* read binary */
FILE *out = fopen("data.bin", "wb");   /* write binary, truncating the file */
FILE *log = fopen("data.bin", "ab");   /* append binary */
```

Binary files are compact and fast, but they are not self-describing. A reader must know the exact layout, and it must match the writer''s layout and byte order. Write a version number at the start of your format, and write each field with fixed-width types from `<stdint.h>`.

## fwrite and fread return counts

`fwrite` and `fread` return how many **items** they transferred, not how many bytes. A short count means something went wrong or that you reached the end. Always compare the result with the count you asked for:

```c
size_t written = fwrite(values, sizeof values[0], count, out);
if (written != count) {
    /* disk full, I/O error or permission change: report it */
}
```

Reading works the same way, but a short count is also how you detect the end of the file. The predict question shows that behavior with a temporary file:

```c predict id=fread-short title="How many items are read?"
#include <stdio.h>

int main(void) {
    FILE *f = tmpfile();
    if (f == NULL) return 1;
    int written[2] = { 1, 2 };
    fwrite(written, sizeof written[0], 2, f);
    rewind(f);
    int buf[5] = { 0 };
    size_t n = fread(buf, sizeof buf[0], 5, f);
    printf("%zu %d\n", n, buf[1]);
    fclose(f);
    return 0;
}
--- options
5 2
* 2 2
2 0
0 2
--- explain
Two integers were written, so the file holds eight bytes. `fread` asked for five items but found only two before the end, so it returns `2`, the number of items it actually read. The second element is `2`, so the output is `2 2`. The unread slots of `buf` keep their initial zeros, and a short count like this one is how you detect the end of a file.
```

## A round trip, checked at each step

A good file format has a writer and a reader that agree exactly. The next question writes three integers and reads them back, and it checks the count at each step:

```c predict id=roundtrip title="What is printed?"
#include <stdio.h>

int main(void) {
    FILE *f = tmpfile();
    if (f == NULL) return 1;
    int data[3] = { 10, 20, 30 };
    size_t w = fwrite(data, sizeof data[0], 3, f);
    rewind(f);
    int back[3] = { 0 };
    size_t r = fread(back, sizeof back[0], 3, f);
    printf("%zu %d\n", w + r, back[2]);
    fclose(f);
    return 0;
}
--- options
3 30
* 6 30
6 10
3 10
--- explain
`fwrite` returns `3`, and `fread` returns `3`, so `w + r` is `6`. `rewind` moves the file position back to the start so the reader sees the data the writer produced. `back[2]` is the third integer, which is `30`. The output is `6 30`. Checking both counts is the habit that catches a short write before it turns into a corrupted file.
```

`tmpfile` is part of C11 and creates a file that is removed when closed, which makes it ideal for tests and examples.

## Errors and errno

When a library call fails, the C standard library usually returns a special value, such as `NULL` from `fopen` or `-1` from a system call, and sets the global variable `errno` to a code that explains why. Three rules make `errno` reliable:

1. **Check the return value first.** `errno` is meaningful only after a call has reported failure. Its value is not cleared on success.
2. **Set `errno = 0` before the call** if you need to tell a real failure from a stale value.
3. **Read `errno` immediately**, before another library call can overwrite it.

The predict question uses `strtol`, which reports its parse position through an end pointer, and it shows the same kind of checking on a conversion:

```c predict id=strtol-end title="What is printed?"
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    char *end = NULL;
    long value = strtol("42xyz", &end, 10);
    printf("%ld %s\n", value, end);
    return 0;
}
--- options
42 42xyz
* 42 xyz
0 xyz
42 yz
--- explain
`strtol` parses as many digits as it can. It reads `42`, then stops at `x`, so it returns `42` and sets `end` to point at the remaining text, `xyz`. A caller who ignores `end` would accept `42xyz` as a valid number. Checking that `*end` is the terminator, or that `end` is at the expected position, catches partially valid input.

## Reporting failures to the user

`perror` prints a message with the current `errno` text, and `strerror` returns that text as a string you can format yourself:

```c
FILE *f = fopen(path, "rb");
if (f == NULL) {
    fprintf(stderr, "cannot open %s: %s\n", path, strerror(errno));
    return -1;
}
```

Write the failure to `stderr`, not `stdout`, so that it does not mix with the program''s data. Include the path, because the message "No such file or directory" is useless without it.

## Writing safely: write, then replace

A crash in the middle of a write can leave a file half old and half new. A safer method writes the new content to a temporary file, checks every step, and then renames the temporary over the original. On POSIX systems `rename` replaces the destination atomically, so readers see either the old file or the new one:

```c
int save_atomic(const char *path, const void *data, size_t size) {
    char temp_path[4096];
    snprintf(temp_path, sizeof temp_path, "%s.tmp", path);
    FILE *f = fopen(temp_path, "wb");
    if (f == NULL) return -1;
    int ok = fwrite(data, 1, size, f) == size;
    if (fclose(f) != 0) ok = 0;    /* fclose can report a flush failure */
    if (!ok || rename(temp_path, path) != 0) {
        remove(temp_path);
        return -1;
    }
    return 0;
}
```

Two details matter. `fclose` can fail when buffered data cannot be written, so check its result. And `snprintf` protects the buffer from long paths, which lesson 20 discusses in depth.

> **Pitfall:** `rename` is atomic on a single file system, but not across file systems, and not every platform guarantees durability after a power cut. For data that must survive a crash, POSIX code calls `fsync` on the file before the rename, which is outside the C11 standard. Know what your platform promises.

> **In the wild:** Databases and editors use the write-then-rename pattern for their data files, so a crash never leaves a half-written document. The same discipline is what lets a program save its state every few seconds without risk.

## Recap

- Use binary mode and fixed-width types for structured data, and write a version number.
- Compare the counts from `fwrite` and `fread` with what you asked for.
- Check return values first, set `errno = 0` when you need a clean signal, and read `errno` at once.
- Report errors to `stderr` with the path and `strerror` text.
- Save with write-then-rename so a crash never corrupts the existing file.

**Up next:** Debugging with gdb, AddressSanitizer, UndefinedBehaviorSanitizer and Valgrind, the tools that find the bugs this course has warned you about.
', 0, '[]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_c_advanced_4_4', 'sec_c_advanced_4', 'crs_c_advanced', 'Debugging with gdb, sanitizers and Valgrind', 'interactive', 3, 1320, NULL, NULL, 'Most programmers debug with `printf` and guesswork. That works for small problems, and it fails badly for the bugs that matter in C: memory corruption that appears far from its cause, undefined behavior that only shows up with optimizations, and leaks that take days to exhaust memory. Professionals use a small set of tools that observe the program directly: a debugger that stops it at the right moment, sanitizers that instrument every memory access, and Valgrind that checks the heap. Each tool finds a different class of bug, and together they cover most of what this course warned you about.

This lesson shows how to build for debugging, how to use gdb for stepping and inspection, how to turn on the sanitizers, how to read their reports, and how to make a bug reproducible before you try to fix it. The compile flags here assume GCC or Clang on Linux or macOS. Windows users can run the same commands under WSL.

## Build for debugging

Debugging depends on the compiler keeping the information the tools need. Two flags do most of the work:

- `-g` includes debug symbols, so the debugger can show source lines and variable names.
- `-O0` turns off optimization, so the code runs in the order you wrote it and variables are not optimized away.

Keep a debug build separate from your release build. Optimization changes which bugs appear, and a bug that vanishes at `-O2` is still a bug.

```c
/* Compile with: gcc -std=c11 -Wall -Wextra -g -O0 main.c -o main */
```

Warnings are free bug reports. Compile with `-Wall -Wextra`, and treat each warning as a bug until you have proven otherwise.

## Assertions and NDEBUG

`assert` from `<assert.h>` checks a condition and stops the program with a message when it is false. It is a debugging tool for conditions that must never be false, such as a precondition or an invariant. Defining `NDEBUG` removes every assertion, which is why release builds often run faster and why an assertion must never contain code with side effects.

The predict question shows what happens when `NDEBUG` is defined:

```c predict id=ndebug-assert title="What is printed?"
#define NDEBUG
#include <stdio.h>
#include <assert.h>

int main(void) {
    assert(1 + 1 == 3);
    printf("after\n");
    return 0;
}
--- options
* after
assertion failed
nothing
compile error
--- explain
`NDEBUG` is defined before `<assert.h>` is included, so `assert` expands to nothing and the false condition is never checked. The program continues and prints `after`. In a normal debug build the assertion fails, the program aborts with a message, and `after` never appears. That difference is why assertions belong to debugging and must never carry work the program depends on.
```

> **Pitfall:** `assert(x = read_value())` looks fine in a debug build and silently skips the read in a release build. Put side effects outside the assertion, and keep the assertion a pure check.

## Conditional debug output

Compile-time switches let you keep diagnostic code in the source without shipping it. A macro controls whether the trace runs, and a flag on the compiler line turns it on:

```c predict id=trace-flag title="What is printed?"
#include <stdio.h>

int main(void) {
#ifdef TRACE
    printf("trace: starting\n");
#endif
    printf("done\n");
    return 0;
}
--- options
trace: starting
* done
done
compile error
--- explain
`TRACE` is not defined in this program, so the `#ifdef` block is removed before compilation. Only `done` is printed. Compiling with `gcc -DTRACE` would define the macro and print both lines. This keeps tracing free in release builds, and it is the same mechanism the debug logger in lesson 2 used.
```

Every function also knows its own name. The identifier `__func__` is defined by C99 and C11 as a string with the name of the enclosing function, which makes log lines self-describing without hand-typed names:

```c predict id=func-name title="What is printed?"
#include <stdio.h>

static void load_config(void) {
    printf("entering %s\n", __func__);
}

int main(void) {
    load_config();
    return 0;
}
--- options
entering main
entering __func__
* entering load_config
entering load_config()
--- explain
`__func__` expands to the name of the function it appears in. Inside `load_config`, it is the string `"load_config"`, with no parentheses and no file name. Pairing it with a message is the cheapest way to trace execution, and it stays correct when you rename a function, because the compiler updates the string for you.

## gdb: stop, look, step

`gdb` runs your program under control. You set breakpoints, run to them, step line by line, and print variables. A short session on a buggy program looks like this:

```
$ gdb ./main
(gdb) break process_items      # stop when this function is entered
(gdb) run                      # start the program
(gdb) next                     # run the next line, stepping over calls
(gdb) step                     # run the next line, entering calls
(gdb) print count              # show a variable
(gdb) print *list              # show a struct through a pointer
(gdb) backtrace                # show the chain of calls that led here
(gdb) watch total              # stop whenever total changes
(gdb) continue                 # run until the next breakpoint or stop
```

The `backtrace` command is the most valuable of these when a program crashes. It shows the functions that were running at the crash, which usually points to the caller that passed the bad value. `watch` is the best tool for a value that changes at an unexpected time, because it stops at the exact write.

> **Tip:** When a crash happens, run `backtrace` first, then `frame 2` (or any number) to move to a caller and `print` the variables there. The bug is often one frame above the place that crashed, where the bad value first entered.

## AddressSanitizer: memory errors

AddressSanitizer (ASan) instruments every memory access. It detects buffer overflows, use after free, double free and many stack errors at the moment they happen, and it prints the stack trace of the bad access and of the allocation or free involved. Compile and run with it:

```
gcc -std=c11 -g -O1 -fsanitize=address -fno-omit-frame-pointer main.c -o main
./main
```

A typical report names the error and points at the line:

```
ERROR: AddressSanitizer: heap-buffer-overflow on address 0x...
WRITE of size 4 at 0x... thread T0
    #0 0x... in fill_buffer main.c:12
    #1 0x... in main main.c:30
0x... is located 0 bytes to the right of 40-byte region [0x..., 0x...)
allocated by thread T0 here:
    #0 0x... in malloc
    #1 0x... in main main.c:28
```

Read the report from the top: the error type, the line that performed the bad access, and the line where the block was allocated. That is usually all you need.

ASan slows the program down and increases its memory use, so it belongs in your test runs, not in production. Run your whole test suite under it.

## UndefinedBehaviorSanitizer: undefined behavior

UndefinedBehaviorSanitizer (UBSan) catches the undefined operations from lesson 3: signed overflow, shifts out of range, misaligned access, null pointer use and division by zero. It reports the operation and the line:

```
gcc -std=c11 -g -O1 -fsanitize=undefined main.c -o main
./main
main.c:9:12: runtime error: signed integer overflow: 2147483647 + 1 cannot be represented in type ''int''
```

Compile with both ASan and UBSan in the same test build when you can, since they check different things. Many teams enable UBSan in the release build too, with the trap option, because a clean crash is better than silent undefined behavior in production.

## Valgrind: the heap from the outside

Valgrind runs your program on a virtual processor and tracks every heap block. It is slower than ASan and needs no recompilation, which makes it useful for code you did not build with sanitizers. For leaks, ask for the full report:

```
valgrind --leak-check=full --show-leak-kinds=all ./main
```

Valgrind reports blocks that were never freed, with the line that allocated them. It also reports uninitialized reads, which the sanitizers do not always catch, such as an `if` that depends on an uninitialized variable. For that reason, Valgrind and ASan complement each other. Run both on a regular basis.

> **Pitfall:** Valgrind reports "still reachable" blocks when a pointer to them remains at exit. These are not always bugs, but they usually indicate that the program should free its data before returning. Focus first on "definitely lost" and "indirectly lost".

## Make the bug reproducible first

A tool can only report a bug that happens. Before you debug, make the failure repeatable:

1. **Reduce the input.** Remove parts of the test case until the smallest input still fails.
2. **Fix the random seed.** Programs that use random numbers must use a fixed seed to reproduce a failure.
3. **Pin the environment.** Note the compiler, flags and platform. Some bugs appear only in one configuration.
4. **Bisect the history.** If the bug is new, use `git bisect` to find the change that introduced it.

A bug you can reproduce in ten seconds is usually fixed in minutes. A bug that happens once a week is a project of its own.

> **In the wild:** Security research on C code runs fuzzers under AddressSanitizer for weeks, because memory errors that never crash on normal input often turn into exploitable vulnerabilities. The sanitizer is the cheapest way to make those errors visible.

## Recap

- Build debug code with `-g -O0`, and treat compiler warnings as bugs.
- `assert` checks invariants; `NDEBUG` removes them, so keep side effects out.
- Use gdb''s `break`, `next`, `print`, `backtrace` and `watch` to observe a program as it runs.
- AddressSanitizer finds memory errors at the moment they occur; UBSan finds undefined arithmetic and shifts.
- Valgrind finds leaks and uninitialized reads without recompilation; run it alongside ASan.
- Reproduce a bug, reduce the input, and then debug.

**Up next:** Secure C: buffer bounds, `snprintf`, integer overflow and the habits that prevent the vulnerabilities these tools reveal.
', 0, '[]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z'),
('les_c_advanced_4_5', 'sec_c_advanced_4', 'crs_c_advanced', 'Secure C: bounds, snprintf and integer overflow', 'interactive', 4, 1440, NULL, NULL, 'Most serious security vulnerabilities in software written in C come from a few patterns: writing past the end of a buffer, trusting a length that came from outside the program, and letting arithmetic wrap around and produce a size that is much too small. Browsers, operating systems and network services have been broken by each of these, often for decades before anyone noticed. The good news is that the defenses are known and small. This lesson covers them, along with the habit of checking every boundary where data enters or leaves your code.

Security in C is not a special topic added at the end. It is the same discipline you have been building all along: know the size of every buffer, know the valid range of every index, and never assume that input is well formed.

## Bounds: every write has a limit

A buffer has a size, and every write into it must stay inside that size. The most common mistake is to copy a string without checking its length:

```c
char name[16];
strcpy(name, user_input);     /* overflows when user_input has 16 or more characters */
```

`strcpy` has no idea how big `name` is. It copies until it finds the terminator, however far that is. The fix is to tell the function the size, and to check the result:

```c
char name[16];
int n = snprintf(name, sizeof name, "%s", user_input);
if (n < 0 || (size_t)n >= sizeof name) {
    /* the input was truncated: decide whether that is acceptable */
}
```

`snprintf` writes at most `sizeof name` bytes, always terminates the result, and returns the length the full output would have needed. Comparing that return value with the buffer size is how you find out whether truncation happened. The next question uses this exact behavior:

```c predict id=snprintf-truncate title="What is printed?"
#include <stdio.h>

int main(void) {
    char buf[6];
    int n = snprintf(buf, sizeof buf, "%s", "Grace Hopper");
    printf("%s %d\n", buf, n);
    return 0;
}
--- options
Grace 12
Grace Hopper 12
* Grace 12
Grace 11
--- explain
The buffer holds six bytes, so `snprintf` stores five characters, `Grace`, plus the terminating null byte. The return value is the length the complete output would have needed, which is the length of `Grace Hopper`, twelve characters. So the output is `Grace 12`. The return value tells you that the text was cut, which is the information you need to report or reject the input.

> **Pitfall:** `strncpy` looks like a safe choice, but it does not always terminate the destination. If the source is as long as the limit, the result has no null byte, and the next string operation reads past the buffer. Prefer `snprintf` for copies that must be terminated.

## Input from outside

Any data that comes from a file, a network connection or a user is hostile until it has been checked. The classic input traps in C:

- `gets` was removed from C11 because it cannot be given a size. Never use it.
- `scanf("%s", buf)` writes as many characters as the input has. Give it a width: `scanf("%15s", buf)` for a 16-byte buffer.
- `fgets(buf, sizeof buf, stdin)` reads at most one line and fits the buffer, but a line longer than the buffer leaves the rest in the stream. Detect that case by checking for a newline.
- Lengths read from a file must be checked against the real size of the data before you allocate or copy.

```c
char line[128];
if (fgets(line, sizeof line, stdin) == NULL) return -1;
if (strchr(line, ''\n'') == NULL && !feof(stdin)) {
    /* the line was too long: discard the rest and reject it */
}
```

> **Tip:** Treat every length in a file format as a claim to verify, not a fact. Compare it with the bytes actually available, and reject the file if they disagree. Many parser vulnerabilities start with a length field that the code trusted.

## Format strings

Never pass user-controlled text as the format argument to `printf`. A format string can read from the stack and, with `%n`, write to memory. The fix is one line:

```c
printf("%s", user_text);      /* safe: the text is data */
printf(user_text);            /* unsafe: the text is a format string */
```

Compilers warn about the second form under `-Wformat-security`. Enable that warning, and keep it on.

## Integer overflow before allocation

Sizes are computed with arithmetic, and arithmetic can wrap. Unsigned wraparound is defined, so it does not crash, but it produces a small number where you expected a large one. If you then allocate that small size and write the large number of elements, you have a heap overflow.

The next question shows an overflow check on an unsigned sum:

```c predict id=unsigned-overflow title="What is printed?"
#include <stdio.h>
#include <stdint.h>

int main(void) {
    uint32_t a = 4000000000u;
    uint32_t b = 500000000u;
    uint32_t sum = a + b;
    printf("%d\n", (int)(sum < a));
    return 0;
}
--- options
0
* 1
2
205032704
--- explain
`uint32_t` is exactly 32 bits, and unsigned addition wraps modulo 2 to the power of 32. The true sum, 4500000000, is larger than the maximum `uint32_t`, so the stored result is 205032704. That result is smaller than `a`. A sum that is smaller than one of its operands is the simplest proof of an unsigned overflow, and `(int)(sum < a)` prints `1`. Checks like this must run before the allocation, not after.

For multiplication, the same idea applies with division. Before computing `count * size`, check that the product fits:

```c
#include <stdint.h>

void *alloc_array(size_t count, size_t size) {
    if (size != 0 && count > SIZE_MAX / size) return NULL;   /* the product would overflow */
    return malloc(count * size);
}
```

This is what `calloc` does internally, and it is why `calloc(count, size)` is preferable to `malloc(count * size)` when you multiply sizes by hand.

> **Pitfall:** Signed integer overflow is undefined, so the check `a + b < a` written for signed values is not safe to rely on, because the compiler may remove it. Check signed arithmetic against the limits before the operation, using `INT_MAX` and `INT_MIN` from `<limits.h>`.

## Checking the bounds of an index

An index taken from input must be checked against the array size before you use it. The check should be the first thing that touches the value:

```c
int lookup(const int *table, size_t size, size_t index) {
    if (index >= size) return -1;    /* reject before reading */
    return table[index];
}
```

A signed index needs an extra check for negative values, because converting a negative `int` to `size_t` produces a huge number. Choose the type that matches the meaning: an index into an array is a `size_t`, and a count from user input should be checked as a signed value first.

The last question puts the index check in front of the read:

```c predict id=index-check title="What is printed?"
#include <stdio.h>
#include <stddef.h>

static int lookup(const int *table, size_t size, size_t index) {
    if (index >= size) return -1;
    return table[index];
}

int main(void) {
    int t[3] = { 10, 20, 30 };
    printf("%d %d\n", lookup(t, 3, 2), lookup(t, 3, 5));
    return 0;
}
--- options
* 30 -1
30 0
-1 30
10 -1
--- explain
The index `2` is valid for a three-element table, so `lookup` returns the third element, `30`. The index `5` fails the check, so the function returns `-1` without reading `table[5]`, which would be outside the array. Output: `30 -1`. Returning a sentinel is one way to report a rejected index; a status code with an output parameter is another. Either way, the read never happens unless the check passed.
```

## Secure habits

- Pass buffer sizes along with buffers, and use `sizeof` at the point of use.
- Check return values, especially from `snprintf`, `fopen`, `fread` and `malloc`.
- Check every length before you allocate, and before you copy.
- Compile with `-Wall -Wextra -Wformat-security`, and run the sanitizers from lesson 19 on your tests and on fuzzed input.
- Keep untrusted input out of format strings, and keep parsing code small enough to review.

> **In the wild:** Many of the most serious vulnerabilities in widely used software were overflows like the ones here: a length field that was trusted, a size that wrapped, or a copy that trusted its source. Each one was fixed with a check of the kind this lesson shows.

## Recap

- Every write needs a size. Use `snprintf` and check its return value for truncation.
- Give `scanf` a width, use `fgets` for lines, and never use `gets`.
- Pass user text as data, never as a `printf` format string.
- Check every multiplication and addition that sizes an allocation, before it runs.
- Check every index and every length from outside the program before using it.

**Up next:** Modular design: headers, opaque types and linkage, so that large programs keep their boundaries as they grow.
', 0, '[]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z'),
('les_c_advanced_4_6', 'sec_c_advanced_4', 'crs_c_advanced', 'Modular design: headers, opaque types and linkage', 'interactive', 5, 1320, NULL, NULL, 'A program with one file is easy to hold in your head. A program with fifty files, written by a team over several years, is not. What keeps it manageable is a set of boundaries: each module publishes a small interface, hides its internal details, and can change those details without breaking its callers. C has no classes or namespaces to enforce those boundaries, so it relies on conventions the compiler can check: headers that declare what a module offers, `static` to keep internals private, and **opaque types** that hide a structure''s layout behind a pointer.

This lesson shows how to split a program into modules, what belongs in a header and what does not, how linkage controls visibility, and how opaque types let you change an implementation safely. Because the examples here live in one cell, the predict questions check the behaviors that the module boundary depends on.

## Headers declare, source files define

A header file is a contract. It contains declarations, types and macros that other files need to use the module. It does not contain function bodies or variable definitions, because a definition in a header would be copied into every file that includes it and cause duplicate-symbol errors at link time.

```c
/* counter.h: the public interface */
#ifndef COUNTER_H
#define COUNTER_H

typedef struct counter counter;       /* opaque: the layout is hidden */

counter *counter_create(void);
void counter_increment(counter *c);
int counter_value(const counter *c);
void counter_destroy(counter *c);

#endif
```

The `#ifndef` guard stops the header from being processed twice when two files include it, directly or through another header. The predict question shows the guard''s effect:

```c predict id=include-guard title="Which message is printed?"
#include <stdio.h>

#ifndef GREETING_H
#define GREETING_H
#define GREETING "hello"
#endif

#ifndef GREETING_H
#define GREETING "bye"
#endif

int main(void) {
    printf("%s\n", GREETING);
    return 0;
}
--- options
* hello
bye
GREETING
compile error
--- explain
The first block defines `GREETING_H` and sets `GREETING` to `"hello"`. When the second block is reached, `GREETING_H` is already defined, so its `#ifndef` is false and its contents are skipped. The program prints `hello`. This is exactly how a guarded header behaves when it is included twice, and it prevents redefinition errors.

> **Tip:** Name the guard after the file path, such as `COUNTER_H` for `counter.h`, and keep the names unique across the project. A guard name that two headers share silently drops one of them.

## The source file keeps its secrets

The implementation of the counter lives in a source file. Its struct definition is private, so callers can only use the functions in the header:

```c
/* counter.c: the implementation */
#include <stdlib.h>
#include "counter.h"

struct counter {
    int value;
    int limit;      /* internal detail: callers never see this field */
};

counter *counter_create(void) {
    counter *c = malloc(sizeof *c);
    if (c != NULL) {
        c->value = 0;
        c->limit = 1000;
    }
    return c;
}
```

Because the struct is defined only in `counter.c`, code in `main.c` cannot write `c->value`. It holds a `counter *` and must go through the functions. This is the opaque type pattern, and it gives you the freedom to change the struct, or switch to a different representation entirely, without touching any caller.

## Private state with static

Any function or variable marked `static` at file scope is visible only inside its file. It has internal linkage, so it cannot clash with a function of the same name in another file. Use `static` for every helper that is not part of the public interface, and make the default for every new function `static` until you decide to publish it.

A `static` local variable is a related tool. It keeps its value between calls but is still invisible to the rest of the program. The predict question shows how a module can hold private state:

```c predict id=private-state title="What is printed?"
#include <stdio.h>

static int next_id(void) {
    static int last = 0;
    return ++last;
}

int main(void) {
    int first = next_id();
    int second = next_id();
    printf("%d %d\n", first, second);
    return 0;
}
--- options
0 0
1 1
* 1 2
2 1
--- explain
The `static` local `last` starts at `0` and keeps its value across calls. The first call increments it to `1` and returns `1`, and the second call increments it to `2`. The variables are assigned in separate statements, so their order is fixed. Passing the two calls directly as arguments to one `printf` would leave the evaluation order unspecified, which is why the code assigns them first.
```

## Linkage in brief

Linkage decides which declarations refer to the same object or function across files:

| Linkage | Who can see it | How to get it |
|---|---|---|
| **External** | All files that declare it | Default for functions and file-scope variables |
| **Internal** | Only the current file | `static` at file scope |
| **None** | Only the current block | Local variables |

Avoid mutable global variables with external linkage. They are shared state, and every file can change them without warning. If you need shared state, put it behind a function in one module, the way `counter` does.

## Opaque types in practice

An opaque type exposes a name but not a layout. Callers hold pointers, and only the implementation knows what the pointer points to. The predict question checks the basic use of an opaque pointer, which is that a fresh handle starts as `NULL`, and that a `NULL` check is always safe:

```c predict id=opaque-handle title="What is printed?"
#include <stdio.h>
#include <stddef.h>

typedef struct counter counter;

counter *find_counter(const char *name) {
    (void)name;
    return NULL;
}

int main(void) {
    counter *c = find_counter("requests");
    printf("%d\n", (int)(c == NULL));
    return 0;
}
--- options
0
* 1
2
compile error
--- explain
The type `counter` is declared but never defined in this file, so the caller cannot look inside it. It can still hold a pointer, compare that pointer with `NULL`, and pass it to functions. `find_counter` returns `NULL`, so the comparison is true and the program prints `1`. This is the normal shape of an API: a function that can fail returns a handle or `NULL`, and the caller checks before using it.

Opaque types give you three benefits. The layout can change without recompiling callers that use only the header. Invariants stay inside one file, where you can reason about them. And misuse becomes harder, because callers cannot reach the fields they should not touch.

> **Pitfall:** Opaque types cost a pointer indirection and an allocation for each object. For small, hot values such as coordinates in a tight loop, a public struct is the right choice. Use opaque types where the hidden detail is worth the cost.

## Building the project

Each source file compiles to an object file, and the linker combines them. A small project looks like this:

```
gcc -std=c11 -Wall -Wextra -c counter.c     # produces counter.o
gcc -std=c11 -Wall -Wextra -c main.c        # produces main.o
gcc counter.o main.o -o app                 # links them into one program
```

A `Makefile` or a build system such as CMake records these steps, and it rebuilds only the files that changed. The modular design is what makes that efficient: a change to `counter.c` recompiles one object file, not the whole project.

> **In the wild:** Large C projects such as the Linux kernel and SQLite publish headers that declare a small public API, and they keep most of the code behind `static` functions and opaque handles. SQLite''s public header is short, and its implementation runs to hundreds of thousands of lines behind it.

## Recap

- Headers declare the interface; source files define it. Guard every header with `#ifndef`.
- Use `static` for everything that is not part of the public interface.
- Hide struct layouts behind opaque pointers to keep invariants inside one file.
- A `static` local keeps state between calls while staying private.
- Avoid mutable global variables with external linkage, and prefer functions that own the state.

**Up next:** The first capstone, a generic dynamic array library, where you apply every technique from the course to one complete module.
', 0, '[]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z'),
('les_c_advanced_4_7', 'sec_c_advanced_4', 'crs_c_advanced', 'Checkpoint: systems craft', 'quiz', 6, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"Why is a multi-statement macro wrapped in do { ... } while (0)?","options":["It makes the macro run faster at run time","It makes the macro behave as a single statement, so an if without braces works","It forces the macro to evaluate its arguments only once","It is required for the # operator to work"],"answerIndex":1,"explanation":"The wrapper turns several statements into one, so the semicolon after the macro completes it and an if/else pairs correctly. It does not change speed, and it does not stop multiple evaluation of arguments."},{"id":"q2","prompt":"Why does a generic container store its element size?","options":["So the compiler can check each element''s type at run time","So every operation computes correct byte offsets and copies, with no way for a caller to pass a wrong size","Because void pointers cannot be dereferenced without a size","So the container can sort its elements automatically"],"answerIndex":1,"explanation":"A void pointer has no type, so the element size is the only information the container has for addressing and copying elements. Storing it in the container keeps every call consistent."},{"id":"q3","prompt":"What does snprintf return when the output is truncated to fit the buffer?","options":["-1, to signal the error","The number of characters that were actually written","The number of characters the complete output would have needed","Zero, because the buffer is full"],"answerIndex":2,"explanation":"snprintf returns the length the complete output would need, not the length written. Comparing that value with the buffer size tells you whether truncation happened."},{"id":"q4","prompt":"Which practice most directly keeps a module''s internal struct layout private?","options":["Declaring every field with the const qualifier","Declaring the struct only in the source file and exposing a pointer to it in the header","Adding a comment that says the fields are private","Using a global variable to store each field"],"answerIndex":1,"explanation":"An opaque type is declared in the header without its definition. Only the source file knows the fields, so callers must use the functions the module provides."},{"id":"q5","prompt":"What is the main purpose of an include guard?","options":["To stop the linker from finding duplicate functions","To stop a header from being processed twice in the same translation unit","To hide a header''s contents from other files","To make the header compile faster on every build"],"answerIndex":1,"explanation":"An include guard uses a macro to skip a header''s contents on a second inclusion. Without it, repeated declarations or definitions can cause compile errors."}]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z'),
('les_c_advanced_5_1', 'sec_c_advanced_5', 'crs_c_advanced', 'Project: a generic dynamic array library', 'interactive', 0, 2400, NULL, NULL, 'You have studied the parts: heap memory, `void *` and element sizes, `memcpy`, ownership, alignment, bounds checks and modular headers. This project puts them together in one small but complete library: a **generic dynamic array**, the C version of `std::vector` or Python''s `list`. Other modules in the rest of this course, including the key-value store in the next project, will reuse ideas from it.

The library is a single header and a single source file. It stores elements of any type, grows when needed, checks every index, and owns its memory. When you finish, you will have a module you can drop into a real program, and you will have seen how the design choices in earlier lessons add up.

## Requirements

Write down the contract before you write any code. The array must:

1. store elements of any fixed size, chosen when the array is created,
2. copy each element into storage it owns,
3. grow geometrically, so that appending is amortized constant time,
4. check every index, and report errors through return values rather than crashing,
5. free all of its memory in one call.

Requirements like these make the rest of the design easier. Each one maps to a decision: the element size is stored in the struct, growth uses doubling, and every operation returns a status.

## The interface

The header declares what callers may use. The struct is public so that callers can read `length`, but they must change the array only through the functions:

```c
/* dynarray.h */
#ifndef DYNARRAY_H
#define DYNARRAY_H

#include <stddef.h>

typedef struct {
    unsigned char *data;    /* owned: allocated and freed by this module */
    size_t elem_size;       /* bytes per element, fixed at init */
    size_t length;          /* number of elements in use */
    size_t capacity;        /* number of elements allocated */
} dyn_array;

int    da_init(dyn_array *a, size_t elem_size);
void   da_destroy(dyn_array *a);
int    da_push(dyn_array *a, const void *element);
int    da_insert(dyn_array *a, size_t index, const void *element);
int    da_remove(dyn_array *a, size_t index);
void  *da_get(dyn_array *a, size_t index);
int    da_reserve(dyn_array *a, size_t min_capacity);

#endif
```

Every function that can fail returns `0` on failure and `1` on success, and `da_get` returns `NULL` for an index out of range. A caller can check each result without reading the implementation.

## Growth

Growth is the performance heart of the design. When the array is full, it allocates a block twice the size. Doubling means that the total cost of `n` appends is proportional to `n`, not `n` squared, because each copy is paid for by the many cheap appends that came before it. The growth rule goes in one helper, so it is easy to test and change:

```c
int da_reserve(dyn_array *a, size_t min_capacity) {
    if (min_capacity <= a->capacity) return 1;
    size_t cap = a->capacity ? a->capacity : 4;
    while (cap < min_capacity) {
        if (cap > SIZE_MAX / 2) return 0;      /* doubling would overflow */
        cap *= 2;
    }
    if (cap > SIZE_MAX / a->elem_size) return 0;   /* the byte count would overflow */
    unsigned char *grown = realloc(a->data, cap * a->elem_size);
    if (grown == NULL) return 0;               /* the old block is still valid */
    a->data = grown;
    a->capacity = cap;
    return 1;
}
```

The overflow checks come from lesson 20, and they are not optional: `cap * elem_size` is an allocation size, and a wrapped product would hand back a block that is too small. Note also that `realloc` writes its result to `grown` first. The original pointer stays valid if the call fails.

The growth rule is easy to verify with a predict question. The array starts with no storage, the first growth allocates four slots, and the fifth push doubles that to eight:

```c predict id=growth-capacity title="What is printed after five pushes?"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    unsigned char *data;
    size_t elem_size;
    size_t length;
    size_t capacity;
} dyn_array;

static int da_reserve(dyn_array *a, size_t min_capacity) {
    if (min_capacity <= a->capacity) return 1;
    size_t cap = a->capacity ? a->capacity : 4;
    while (cap < min_capacity) cap *= 2;
    unsigned char *grown = realloc(a->data, cap * a->elem_size);
    if (grown == NULL) return 0;
    a->data = grown;
    a->capacity = cap;
    return 1;
}

static int da_push(dyn_array *a, const void *element) {
    if (!da_reserve(a, a->length + 1)) return 0;
    memcpy(a->data + a->length * a->elem_size, element, a->elem_size);
    a->length++;
    return 1;
}

int main(void) {
    dyn_array a = { NULL, sizeof(int), 0, 0 };
    for (int i = 1; i <= 5; i++) da_push(&a, &i);
    printf("%zu %zu\n", a.length, a.capacity);
    free(a.data);
    return 0;
}
--- options
5 4
* 5 8
8 5
4 8
--- explain
After five pushes the length is `5`. The first push allocates four slots. When the fifth element arrives, `da_reserve` finds the capacity full and doubles it to `8`, so the output is `5 8`. Capacity is always at least the length, and the gap between them is what makes appends cheap.

## Append, insert and remove

Appending copies the element to the end. Inserting moves the elements after the index with `memmove`, which handles overlapping regions correctly, and then copies the new element into the gap. Removing shifts the tail left:

```c
int da_push(dyn_array *a, const void *element) {
    if (!da_reserve(a, a->length + 1)) return 0;
    memcpy(a->data + a->length * a->elem_size, element, a->elem_size);
    a->length++;
    return 1;
}

int da_insert(dyn_array *a, size_t index, const void *element) {
    if (index > a->length) return 0;
    if (!da_reserve(a, a->length + 1)) return 0;
    unsigned char *at = a->data + index * a->elem_size;
    memmove(at + a->elem_size, at, (a->length - index) * a->elem_size);
    memcpy(at, element, a->elem_size);
    a->length++;
    return 1;
}

int da_remove(dyn_array *a, size_t index) {
    if (index >= a->length) return 0;
    unsigned char *at = a->data + index * a->elem_size;
    memmove(at, at + a->elem_size, (a->length - index - 1) * a->elem_size);
    a->length--;
    return 1;
}
```

The predict question below uses `da_push` and `da_insert` together, so you can confirm the shift behavior by reading the output:

```c predict id=insert-shift title="What is printed after the insert?"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    unsigned char *data;
    size_t elem_size;
    size_t length;
    size_t capacity;
} dyn_array;

static int da_reserve(dyn_array *a, size_t min_capacity) {
    if (min_capacity <= a->capacity) return 1;
    size_t cap = a->capacity ? a->capacity : 4;
    while (cap < min_capacity) cap *= 2;
    unsigned char *grown = realloc(a->data, cap * a->elem_size);
    if (grown == NULL) return 0;
    a->data = grown;
    a->capacity = cap;
    return 1;
}

static int da_push(dyn_array *a, const void *element) {
    if (!da_reserve(a, a->length + 1)) return 0;
    memcpy(a->data + a->length * a->elem_size, element, a->elem_size);
    a->length++;
    return 1;
}

static int da_insert(dyn_array *a, size_t index, const void *element) {
    if (index > a->length) return 0;
    if (!da_reserve(a, a->length + 1)) return 0;
    unsigned char *at = a->data + index * a->elem_size;
    memmove(at + a->elem_size, at, (a->length - index) * a->elem_size);
    memcpy(at, element, a->elem_size);
    a->length++;
    return 1;
}

int main(void) {
    dyn_array a = { NULL, sizeof(int), 0, 0 };
    for (int v = 1; v <= 3; v++) da_push(&a, &v);
    int nine = 9;
    da_insert(&a, 1, &nine);
    for (size_t i = 0; i < a.length; i++) {
        printf("%d ", *(int *)(a.data + i * a.elem_size));
    }
    printf("\n");
    free(a.data);
    return 0;
}
--- options
1 2 3 9 
1 9 2 3 
9 1 2 3 
1 2 9 3 
--- explain
The array holds `1 2 3`. The insert at index `1` moves the elements from index 1 onward one slot to the right with `memmove`, which is safe even though source and destination overlap. Then the new value `9` is copied into the gap. The result is `1 9 2 3`. Using `memcpy` for the shift would be undefined behavior here, because the regions overlap, which is why the library uses `memmove`.

## Access with bounds checks

`da_get` returns a pointer to an element, or `NULL` when the index is out of range. Returning a pointer lets the caller read or write the element in place, and the bounds check keeps the pointer inside the block. A pointer from `da_get` is valid only until the next operation that may reallocate, so the caller must not hold it across a push.

```c
void *da_get(dyn_array *a, size_t index) {
    return index < a->length ? a->data + index * a->elem_size : NULL;
}
```

The predict question checks the bounds check at both edges:

```c predict id=get-bounds title="What is printed?"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    unsigned char *data;
    size_t elem_size;
    size_t length;
    size_t capacity;
} dyn_array;

static int da_push(dyn_array *a, const void *element) {
    if (a->length == a->capacity) {
        size_t cap = a->capacity ? a->capacity * 2 : 4;
        unsigned char *grown = realloc(a->data, cap * a->elem_size);
        if (grown == NULL) return 0;
        a->data = grown;
        a->capacity = cap;
    }
    memcpy(a->data + a->length * a->elem_size, element, a->elem_size);
    a->length++;
    return 1;
}

static void *da_get(dyn_array *a, size_t index) {
    return index < a->length ? a->data + index * a->elem_size : NULL;
}

int main(void) {
    dyn_array a = { NULL, sizeof(int), 0, 0 };
    int seven = 7;
    da_push(&a, &seven);
    printf("%d %d\n", da_get(&a, 0) != NULL, da_get(&a, 1) == NULL);
    free(a.data);
    return 0;
}
--- options
0 1
1 0
0 0
* 1 1
--- explain
The array has one element, so index `0` is in range and `da_get` returns a pointer, which makes `da_get(&a, 0) != NULL` true and prints `1`. Index `1` is past the end, so `da_get` returns `NULL` and `da_get(&a, 1) == NULL` is also true, printing `1`. Out-of-range access fails safely instead of reading memory outside the block.

## Destroy and ownership

`da_destroy` frees the block and resets the struct, so the array cannot be used by accident after cleanup:

```c
void da_destroy(dyn_array *a) {
    free(a->data);
    a->data = NULL;
    a->length = 0;
    a->capacity = 0;
}
```

Initialization sets the fields and allocates nothing until the first push, so an empty array costs no memory:

```c
int da_init(dyn_array *a, size_t elem_size) {
    if (elem_size == 0) return 0;
    a->data = NULL;
    a->elem_size = elem_size;
    a->length = 0;
    a->capacity = 0;
    return 1;
}
```

## Testing the library

A library is only as trustworthy as its tests. Write tests that cover:

- an empty array: `da_get` on index 0 returns `NULL`,
- growth across several capacity boundaries, checking the data after each one,
- insert at the front, the middle and the end, each followed by a full comparison,
- remove at the first and last positions,
- a struct element type, so that the element size matters,
- a failed `da_reserve`, so that the original data survives.

Run the tests under AddressSanitizer and Valgrind from lesson 19. A dynamic array is an excellent target for those tools, because most of its bugs are off-by-one errors that the sanitizers catch at once.

## Extensions to try

- Add `da_sort` that calls `qsort` with a comparator supplied by the caller (lesson 12).
- Add a `da_clone` that deep-copies, with a copy callback for elements that own memory (lesson 17).
- Replace the doubling policy with a 1.5 times growth factor, and measure the difference on a million appends.

> **In the wild:** Every major language has a dynamic array at its core: `std::vector` in C++, `ArrayList` in Java and `list` in Python. They all use the same ideas you just implemented, with geometric growth, separate size and capacity, and checked access.

## Recap

- Write the contract first: element size, ownership, growth, checks and cleanup.
- Grow by doubling, and check every multiplication before allocating.
- Use `memmove` for overlapping shifts and `memcpy` for copies into fresh space.
- Return status codes and `NULL` for failures, and never let an index escape the block.
- Test the boundaries and run the library under the sanitizers.

**Up next:** The second capstone, a key-value store that combines a hash table with file persistence.
', 0, '[]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z'),
('les_c_advanced_5_2', 'sec_c_advanced_5', 'crs_c_advanced', 'Project: a key-value store with file persistence', 'interactive', 1, 2700, NULL, NULL, 'A key-value store is one of the most useful programs you can write in C, and it is also one of the most instructive. Under its simple interface, `put`, `get` and `delete`, it combines everything in this course: a hash table with chaining (lesson 11), ownership of every key and value (lesson 7), careful serialization (lessons 14 and 15), error-aware file I/O (lesson 18), write-then-rename for safe saves (lesson 18), and defensive parsing of data that may be corrupt (lesson 20). Databases, caches and configuration systems are built on this design.

The store in this lesson keeps its data in memory, and it saves to a single file that it loads at startup. The format is small enough to read in one sitting and strict enough to reject damaged input.

## Requirements

- `kv_put` stores a string value under a string key, replacing any earlier value.
- `kv_get` returns the stored value, or reports that the key is missing.
- `kv_delete` removes a key.
- `kv_save` writes the whole store to a file safely.
- `kv_load` reads a file, rejects anything malformed, and leaves the store unchanged on failure.

These are small requirements, and they force important decisions. A value must be copied into memory the store owns, because the caller''s buffer may disappear. A save must never leave a half-written file behind. A load must check every length before trusting it.

## The record format

Each record is a key length, the key bytes, a value length and the value bytes. Lengths are stored as a single byte, which limits keys and values to 255 characters. That limit is a deliberate choice: it removes byte-order questions entirely, and a single byte is easy to check. A file begins with a four-byte magic string, `KVS1`, so that a load can reject a file that is not a store at all:

```c
#define KV_MAGIC "KVS1"
#define KV_MAX_FIELD 255
```

Here is the encoder. It writes into a caller-supplied buffer, and it returns the number of bytes used:

```c
size_t encode_record(unsigned char *out, const char *key, const char *value) {
    size_t klen = strlen(key);
    size_t vlen = strlen(value);
    out[0] = (unsigned char)klen;
    memcpy(out + 1, key, klen);
    out[1 + klen] = (unsigned char)vlen;
    memcpy(out + 2 + klen, value, vlen);
    return 2 + klen + vlen;
}
```

The predict question encodes one record, and it confirms the layout byte by byte:

```c predict id=encode-record title="How many bytes are written, and what is the first one?"
#include <stdio.h>
#include <string.h>
#include <stddef.h>

static size_t encode_record(unsigned char *out, const char *key, const char *value) {
    size_t klen = strlen(key);
    size_t vlen = strlen(value);
    out[0] = (unsigned char)klen;
    memcpy(out + 1, key, klen);
    out[1 + klen] = (unsigned char)vlen;
    memcpy(out + 2 + klen, value, vlen);
    return 2 + klen + vlen;
}

int main(void) {
    unsigned char buf[32];
    size_t n = encode_record(buf, "ab", "xyz");
    printf("%zu %d\n", n, buf[0]);
    return 0;
}
--- options
5 2
* 7 2
7 3
7 0
--- explain
The key `"ab"` has two bytes and the value `"xyz"` has three. The record is one length byte, two key bytes, one length byte and three value bytes, for seven bytes in total. The first byte holds the key length, `2`. Output: `7 2`. The record is self-describing, so a reader never needs to know the key''s length in advance.

## The decoder checks every length

The decoder is the part that protects the store from bad files. It must check that each length fits inside the bytes it actually has, before it copies anything. A file that claims a 200-byte value but ends after 20 bytes is damaged, and the decoder must refuse it rather than read past the end:

```c
size_t decode_record(const unsigned char *in, size_t avail,
                     char *key, char *value) {
    if (avail < 1) return 0;
    size_t klen = in[0];
    if (avail < 2 + klen) return 0;
    size_t vlen = in[1 + klen];
    if (avail < 2 + klen + vlen) return 0;
    memcpy(key, in + 1, klen);
    key[klen] = ''\0'';
    memcpy(value, in + 2 + klen, vlen);
    value[vlen] = ''\0'';
    return 2 + klen + vlen;
}
```

The caller''s buffers `key` and `value` must hold 256 bytes each, and the decoder writes the terminator within those limits. Returning `0` means the record is malformed. That single value keeps the interface simple, and the loader treats it as a corrupt file.

The predict question checks both the success case and the truncated case, which is the one that matters for safety:

```c predict id=decode-truncated title="What is printed for the full record and for a truncated one?"
#include <stdio.h>
#include <string.h>
#include <stddef.h>

static size_t decode_record(const unsigned char *in, size_t avail,
                            char *key, char *value) {
    if (avail < 1) return 0;
    size_t klen = in[0];
    if (avail < 2 + klen) return 0;
    size_t vlen = in[1 + klen];
    if (avail < 2 + klen + vlen) return 0;
    memcpy(key, in + 1, klen);
    key[klen] = ''\0'';
    memcpy(value, in + 2 + klen, vlen);
    value[vlen] = ''\0'';
    return 2 + klen + vlen;
}

int main(void) {
    const unsigned char record[7] = { 2, ''a'', ''b'', 3, ''x'', ''y'', ''z'' };
    char key[256], value[256];
    size_t full = decode_record(record, 7, key, value);
    size_t cut = decode_record(record, 5, key, value);
    printf("%zu %zu\n", full, cut);
    return 0;
}
--- options
7 5
0 0
* 7 0
0 7
--- explain
The full seven-byte record decodes, and the decoder reports that it consumed `7` bytes. With only five bytes available, the value length byte says three value bytes follow, but only one is present after the key. The check `avail < 2 + klen + vlen` fails, so the decoder returns `0` without copying anything. The output is `7 0`. Refusing the truncated record is the behavior that keeps a damaged file from corrupting the store.

> **Pitfall:** Checking the length after copying is the classic bug. A decoder that copies first and checks later has already written past its buffer. Validate every length against the available bytes before the first `memcpy`.

## The table

The store is a hash table with chaining, the design from lesson 11, with each entry owning its key and its value. Here is the entry type and the lookup:

```c
typedef struct entry {
    char *key;
    char *value;
    struct entry *next;
} entry;

typedef struct {
    entry **buckets;
    size_t bucket_count;
    size_t size;
} kv_store;

static entry *find_entry(const kv_store *s, const char *key, entry ***link) {
    size_t index = hash_string(key) % s->bucket_count;
    entry **pp = &s->buckets[index];
    while (*pp != NULL && strcmp((*pp)->key, key) != 0) pp = &(*pp)->next;
    if (link != NULL) *link = pp;
    return *pp;
}
```

`find_entry` returns the matching entry and, through `link`, the address of the pointer that refers to it. That pointer-to-pointer is the same idiom from lesson 8. It lets `kv_delete` unlink a node without special cases for the head of a chain.

## Delete, with the link pointer

Deletion uses the link that the lookup returned. The unlinked entry is freed together with its key and value, because the store owns all three:

```c
int kv_delete(kv_store *s, const char *key) {
    entry **link = NULL;
    entry *e = find_entry(s, key, &link);
    if (e == NULL) return 0;
    *link = e->next;
    free(e->key);
    free(e->value);
    free(e);
    s->size--;
    return 1;
}
```

The predict question uses the same unlink step on a three-node chain, so you can see that the surrounding nodes stay connected:

```c predict id=unlink-middle title="Which key is next after the deletion?"
#include <stdio.h>
#include <stddef.h>

typedef struct entry {
    const char *key;
    struct entry *next;
} entry;

int main(void) {
    entry c = { "c", NULL };
    entry b = { "b", &c };
    entry a = { "a", &b };
    entry *head = &a;

    entry **link = &head;
    while (*link != NULL && (*link)->key[0] != ''b'') link = &(*link)->next;
    if (*link != NULL) *link = (*link)->next;

    printf("%s\n", head->next->key);
    return 0;
}
--- options
b
* c
a
NULL
--- explain
The walk stops at the link that points at `b`, so `link` holds the address of `a.next`. Setting `*link` to `b.next` skips over `b`, leaving the chain `a -> c`. `head->next` is now `c`, and its key is `c`. This is the delete step in `kv_delete`, and it works without checking whether `b` is the head, because `link` can point at the head pointer itself.

## Saving safely

`kv_save` writes the magic string, then one record per entry, into a temporary file. It renames that file over the original only after every write and the final close have succeeded. This is the procedure from lesson 18, and it is what protects the store from a crash in the middle of a save:

```c
int kv_save(const kv_store *s, const char *path) {
    char temp[4096];
    snprintf(temp, sizeof temp, "%s.tmp", path);
    FILE *f = fopen(temp, "wb");
    if (f == NULL) return 0;
    int ok = fwrite(KV_MAGIC, 1, 4, f) == 4;
    unsigned char record[2 + 2 * KV_MAX_FIELD];
    for (size_t i = 0; ok && i < s->bucket_count; i++) {
        for (const entry *e = s->buckets[i]; ok && e != NULL; e = e->next) {
            size_t n = encode_record(record, e->key, e->value);
            ok = fwrite(record, 1, n, f) == n;
        }
    }
    if (fclose(f) != 0) ok = 0;
    if (!ok || rename(temp, path) != 0) {
        remove(temp);
        return 0;
    }
    return 1;
}
```

The loader is the mirror image. It reads the whole file, checks the magic string, and decodes records one at a time. It builds the new contents in a separate store and swaps it in only when every record is valid. A corrupt file therefore never leaves the live store half loaded.

## Testing the store

Test the store the way you tested the dynamic array: empty stores, replacement of an existing key, deletion of the head, middle and last entries of a chain, and a save followed by a load that compares every key. Then write tests that damage the file on purpose: truncate it, change a length byte to a huge value, and remove the magic string. Each damaged file must be rejected with the store unchanged. Run the whole suite under AddressSanitizer and UndefinedBehaviorSanitizer from lesson 19.

> **Tip:** Make the damaged-file tests part of the regular suite, not a special case. Robust parsing is a property you can only keep by testing it every time the format changes.

> **In the wild:** Embedded key-value stores in browsers, mobile apps and command-line tools use this same model: a file with length-prefixed records, a write-then-rename save, and a loader that rejects anything it cannot verify. Production systems add checksums and log-structured writes, which is the next step after this design.

## Recap

- Store every key and value in memory the store owns, and free all three when an entry is deleted.
- Encode records with length prefixes, and check every length against the available bytes before copying.
- Use the link-pointer idiom to unlink any node, including the head, without special cases.
- Save to a temporary file and rename it over the original only after every step succeeds.
- Load into a separate structure, so a corrupt file never leaves the live store half changed.

**Up next:** The final capstone, a tokenizer and expression evaluator, which combines the recursive and pointer techniques from the whole course.
', 0, '[]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z'),
('les_c_advanced_5_3', 'sec_c_advanced_5', 'crs_c_advanced', 'Project: a tokenizer and expression evaluator', 'interactive', 2, 2700, NULL, NULL, 'Every calculator, configuration file and query language begins with the same two steps: read the text and break it into pieces, then understand how those pieces combine. The first step is a **lexer** or tokenizer. The second is a **parser** that turns the tokens into meaning, which for arithmetic means respecting precedence and parentheses. Writing both by hand is one of the best exercises in systems programming, because it uses almost every idea in the course: careful pointer movement, recursion, error reporting and the discipline of never reading past the end of a buffer.

This final project builds an evaluator for integer arithmetic with `+`, `-`, `*`, `/` and parentheses. The design is small on purpose, so that you can read every line and understand why it is correct.

## The grammar

Precedence and associativity are written into a grammar, one rule per precedence level. Each rule calls the next level down, which is what makes multiplication bind tighter than addition without any special table:

```
expr    := term   ((''+'' | ''-'') term)*
term    := factor ((''*'' | ''/'') factor)*
factor  := NUMBER | ''('' expr '')''
```

Read the rules as instructions. An expression is one term, followed by any number of additions or subtractions, each applied to another term. A term is one factor, followed by any number of multiplications or divisions. A factor is a number or a parenthesized expression, which starts the whole cycle again. The structure of the parser follows this grammar exactly, one function per rule, and this style is called **recursive descent**.

## Tokens, and why this version skips them

A full lexer produces a stream of tokens, such as `NUMBER(12)`, `PLUS` and `STAR`, before parsing begins. That separation pays off as a language grows. For a grammar this small, the parser can read characters directly, and the code stays shorter. The first predict question shows the job a tokenizer does, which is to group digits into one token and skip whitespace:

```c predict id=token-count title="How many tokens are in this expression?"
#include <stdio.h>
#include <ctype.h>

int main(void) {
    const char *text = "12 + 3*4";
    int tokens = 0;
    const char *p = text;
    while (*p != ''\0'') {
        if (isspace((unsigned char)*p)) {
            p++;
            continue;
        }
        tokens++;
        if (isdigit((unsigned char)*p)) {
            while (isdigit((unsigned char)*p)) p++;
        } else {
            p++;
        }
    }
    printf("%d\n", tokens);
    return 0;
}
--- options
3
4
* 5
7
--- explain
The tokens are `12`, `+`, `3`, `*` and `4`, which makes five. The digits of `12` form one token, because the inner loop consumes every digit in a row. Spaces separate tokens and produce none. Grouping characters into tokens is the job the parser would otherwise repeat at every level, which is why a real lexer exists.

> **Tip:** Use `unsigned char` when you call `isdigit` and `isspace`. Passing a negative `char` value is undefined behavior, and that can happen on platforms where `char` is signed and the input contains non-ASCII bytes.

## The parser state

The parser needs two things: the current position in the text, and an error flag that any level can set. Passing a small struct by pointer keeps every function''s signature simple:

```c
typedef struct {
    const char *pos;   /* the next unread character */
    int error;         /* set to 1 when the input is not a valid expression */
} parser;

static void skip_spaces(parser *ps) {
    while (isspace((unsigned char)*ps->pos)) ps->pos++;
}
```

The error flag is a design decision. Once it is set, the parser can return zero and let the callers unwind, and the top-level function reports the failure once. This is simpler than returning an error code from every level, which would make the arithmetic awkward.

## Factors: numbers and parentheses

A factor is the innermost level. It reads a number, or it reads a parenthesized expression by calling back up to `parse_expr`. The recursion between these functions is what gives parentheses their meaning:

```c
static long parse_expr(parser *ps);

static long parse_factor(parser *ps) {
    skip_spaces(ps);
    if (*ps->pos == ''('') {
        ps->pos++;
        long value = parse_expr(ps);
        skip_spaces(ps);
        if (*ps->pos == '')'') ps->pos++;
        else ps->error = 1;             /* missing closing parenthesis */
        return value;
    }
    if (!isdigit((unsigned char)*ps->pos)) {
        ps->error = 1;                  /* expected a number or ''('' */
        return 0;
    }
    long value = 0;
    while (isdigit((unsigned char)*ps->pos)) {
        value = value * 10 + (*ps->pos - ''0'');
        ps->pos++;
    }
    return value;
}
```

Look at the number loop: it reads one digit at a time, and it checks `isdigit` before it touches the character, so it never reads past the end of the string. The terminating null byte is not a digit, so the loop stops there. Overflow of `value` is possible with very long inputs, and a production evaluator would check it before the multiplication, as lesson 20 showed. Here, the comment marks the limit.

## Terms and expressions

The two levels above factors follow the same loop shape. Each one reads an operand, then keeps reading operator and operand pairs for as long as the next character is one of its operators:

```c
static long parse_term(parser *ps) {
    long value = parse_factor(ps);
    for (;;) {
        skip_spaces(ps);
        if (*ps->pos == ''*'') {
            ps->pos++;
            value *= parse_factor(ps);
        } else if (*ps->pos == ''/'') {
            ps->pos++;
            long divisor = parse_factor(ps);
            if (divisor == 0) {
                ps->error = 1;         /* division by zero is an error, not a crash */
                return 0;
            }
            value /= divisor;
        } else {
            return value;
        }
    }
}

static long parse_expr(parser *ps) {
    long value = parse_term(ps);
    for (;;) {
        skip_spaces(ps);
        if (*ps->pos == ''+'') {
            ps->pos++;
            value += parse_term(ps);
        } else if (*ps->pos == ''-'') {
            ps->pos++;
            value -= parse_term(ps);
        } else {
            return value;
        }
    }
}
```

The loop in `parse_term` is where precedence lives. A `*` is consumed inside the term, before any `+` gets a chance to run, so `2 + 3 * 4` multiplies `3` and `4` first. The predict question checks exactly that:

```c predict id=precedence title="What value does the parser return?"
#include <stdio.h>
#include <ctype.h>

typedef struct {
    const char *pos;
    int error;
} parser;

static void skip_spaces(parser *ps) {
    while (isspace((unsigned char)*ps->pos)) ps->pos++;
}

static long parse_expr(parser *ps);

static long parse_factor(parser *ps) {
    skip_spaces(ps);
    if (*ps->pos == ''('') {
        ps->pos++;
        long value = parse_expr(ps);
        skip_spaces(ps);
        if (*ps->pos == '')'') ps->pos++;
        else ps->error = 1;
        return value;
    }
    if (!isdigit((unsigned char)*ps->pos)) {
        ps->error = 1;
        return 0;
    }
    long value = 0;
    while (isdigit((unsigned char)*ps->pos)) {
        value = value * 10 + (*ps->pos - ''0'');
        ps->pos++;
    }
    return value;
}

static long parse_term(parser *ps) {
    long value = parse_factor(ps);
    for (;;) {
        skip_spaces(ps);
        if (*ps->pos == ''*'') {
            ps->pos++;
            value *= parse_factor(ps);
        } else if (*ps->pos == ''/'') {
            ps->pos++;
            long divisor = parse_factor(ps);
            if (divisor == 0) { ps->error = 1; return 0; }
            value /= divisor;
        } else {
            return value;
        }
    }
}

static long parse_expr(parser *ps) {
    long value = parse_term(ps);
    for (;;) {
        skip_spaces(ps);
        if (*ps->pos == ''+'') {
            ps->pos++;
            value += parse_term(ps);
        } else if (*ps->pos == ''-'') {
            ps->pos++;
            value -= parse_term(ps);
        } else {
            return value;
        }
    }
}

int main(void) {
    parser ps = { "2 + 3 * 4", 0 };
    printf("%ld\n", parse_expr(&ps));
    return 0;
}
--- options
20
* 14
24
11
--- explain
`parse_expr` reads the term `2`, then sees `+` and reads another term. That term is `3`, followed by `*`, so `parse_term` consumes `4` as well and returns `12`. The addition then gives `2 + 12`, which is `14`. Because multiplication is handled one level lower, it binds tighter than addition without any extra logic.
```

## Parentheses change the grouping

A parenthesized expression is a factor, so it binds as tightly as a number. Parentheses therefore override precedence, and the recursion from `parse_factor` back into `parse_expr` is exactly what makes that happen. The next question evaluates the same numbers with different grouping, using the same parser:

```c predict id=parentheses title="What value does the parser return with parentheses?"
#include <stdio.h>
#include <ctype.h>

typedef struct {
    const char *pos;
    int error;
} parser;

static void skip_spaces(parser *ps) {
    while (isspace((unsigned char)*ps->pos)) ps->pos++;
}

static long parse_expr(parser *ps);

static long parse_factor(parser *ps) {
    skip_spaces(ps);
    if (*ps->pos == ''('') {
        ps->pos++;
        long value = parse_expr(ps);
        skip_spaces(ps);
        if (*ps->pos == '')'') ps->pos++;
        else ps->error = 1;
        return value;
    }
    long value = 0;
    while (isdigit((unsigned char)*ps->pos)) {
        value = value * 10 + (*ps->pos - ''0'');
        ps->pos++;
    }
    return value;
}

static long parse_term(parser *ps) {
    long value = parse_factor(ps);
    for (;;) {
        skip_spaces(ps);
        if (*ps->pos == ''*'') { ps->pos++; value *= parse_factor(ps); }
        else return value;
    }
}

static long parse_expr(parser *ps) {
    long value = parse_term(ps);
    for (;;) {
        skip_spaces(ps);
        if (*ps->pos == ''+'') { ps->pos++; value += parse_term(ps); }
        else return value;
    }
}

int main(void) {
    parser ps = { "(2 + 3) * 4", 0 };
    printf("%ld\n", parse_expr(&ps));
    return 0;
}
--- options
14
* 20
17
11
--- explain
The factor begins with `(`, so `parse_factor` calls `parse_expr` for the inside, which reads `2 + 3` and returns `5`. The closing parenthesis is consumed, and the factor is `5`. Back in `parse_term`, the `*` multiplies `5` by `4`, giving `20`. Without the parentheses the same numbers would produce `14`, which is the difference the grammar is designed to express.
```

## Errors: report once, at the top

A bad input sets the error flag, and the caller checks it once at the end. The predict question triggers division by zero:

```c predict id=division-error title="What does the error flag hold after evaluating 8 / 0?"
#include <stdio.h>
#include <ctype.h>

typedef struct {
    const char *pos;
    int error;
} parser;

static void skip_spaces(parser *ps) {
    while (isspace((unsigned char)*ps->pos)) ps->pos++;
}

static long parse_factor(parser *ps) {
    skip_spaces(ps);
    long value = 0;
    while (isdigit((unsigned char)*ps->pos)) {
        value = value * 10 + (*ps->pos - ''0'');
        ps->pos++;
    }
    return value;
}

static long parse_term(parser *ps) {
    long value = parse_factor(ps);
    skip_spaces(ps);
    if (*ps->pos == ''/'') {
        ps->pos++;
        long divisor = parse_factor(ps);
        if (divisor == 0) {
            ps->error = 1;
            return 0;
        }
        value /= divisor;
    }
    return value;
}

int main(void) {
    parser ps = { "8 / 0", 0 };
    parse_term(&ps);
    printf("%d\n", ps.error);
    return 0;
}
--- options
0
* 1
8
error
--- explain
The divisor `0` triggers the check, which sets `error` to `1` and returns without dividing. Dividing by zero in C is undefined behavior for integers, so the explicit check turns a crash or an unpredictable result into a reported error. The caller reads the flag once, after the whole expression, which keeps the code paths short.

## The public function

The evaluator''s public entry point hides the parser state and reports success or failure to the caller. It also rejects trailing characters, because `2 + 3 4` is not a valid expression:

```c
int evaluate(const char *text, long *result) {
    parser ps = { text, 0 };
    long value = parse_expr(&ps);
    skip_spaces(&ps);
    if (ps.error || *ps.pos != ''\0'') return 0;
    *result = value;
    return 1;
}
```

The check `*ps.pos != ''\0''` is the one most people forget. Without it, the evaluator accepts a prefix of the input and silently ignores the rest. A test for `2 + 3 4` should fail, and this line makes it fail.

## Testing the evaluator

Test every level of the grammar and every failure mode. Cover single numbers, each operator alone, precedence between operators, nested parentheses, whitespace in unusual places, unbalanced parentheses, a missing operand, trailing garbage, and division by zero. For each case, check the result and the success flag. Run the tests under UndefinedBehaviorSanitizer, because the arithmetic is the most likely place for an unexpected undefined operation. Also run a fuzzer or a long list of random strings under AddressSanitizer, to confirm that no input can read outside the string.

> **Pitfall:** Recursive descent can recurse deeply on input such as thousands of nested parentheses, and each level uses stack space. A production parser sets a depth limit and reports an error beyond it. Adding that limit is a good exercise for after you finish this project.

> **In the wild:** Spreadsheet formulas, build tools and configuration languages use this same recursive descent structure. Compilers for real languages use it too, with a token stream, a symbol table and far richer error messages. Everything you wrote here scales to those tools.

## Recap

- A grammar with one rule per precedence level gives correct precedence without a table.
- Recursive descent maps each grammar rule to one function, and parentheses recurse back to the top level.
- Keep the parser state in a struct, and report errors with a flag that the top level checks.
- Check division by zero explicitly, and reject trailing input.
- Test every grammar level and every failure mode, under the sanitizers.

**Up next:** The final checkpoint, which ties the whole course together.
', 0, '[]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z'),
('les_c_advanced_5_4', 'sec_c_advanced_5', 'crs_c_advanced', 'Final checkpoint: advanced C', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"Why does the dynamic array double its capacity when it is full?","options":["Doubling makes each append take time proportional to the array''s current size","Doubling makes the total cost of n appends proportional to n, because the copies are paid for by the cheap appends before them","Doubling keeps the struct small enough to fit in one cache line","Doubling is required by realloc before it will move a block"],"answerIndex":1,"explanation":"Geometric growth means the copies needed when the array grows are rare and large, so the average cost per append stays constant. Growing by a fixed amount would make the total cost quadratic."},{"id":"q2","prompt":"In the key-value store''s decoder, why is each length checked against the available bytes before any memcpy?","options":["memcpy is faster when the lengths have been checked","A truncated or corrupt record would otherwise make the copy write or read past the end of a buffer","The file format requires the check for compatibility","It keeps the file from growing when records are saved again"],"answerIndex":1,"explanation":"A length taken from a damaged file can claim more bytes than exist. Validating it first means the decoder rejects the record instead of reading past the end of the input or writing past the end of a buffer."},{"id":"q3","prompt":"Why does the expression parser handle * and / inside parse_term, below the + and - loop in parse_expr?","options":["Because the loops run in alphabetical order of their operators","Because the grammar gives multiplication higher precedence by calling a lower level for its operands","Because the compiler checks * before + in every function","Because + is a unary operator that must be read last"],"answerIndex":1,"explanation":"parse_expr calls parse_term for each operand, so a term is fully grouped before any addition or subtraction sees it. That is how multiplication binds tighter than addition, with no precedence table needed."},{"id":"q4","prompt":"Why does a safe save write the new store to a temporary file and then rename it over the original?","options":["rename is always faster than writing the file directly","A crash during the save must not leave a half-written store in place of the previous good copy","It makes the file readable by other programs","The C standard forbids overwriting an existing file"],"answerIndex":1,"explanation":"The original file stays intact until the new one is complete and closed successfully. The rename then replaces it in one step, so a crash leaves either the old store or the new one, never a mixture."},{"id":"q5","prompt":"Why is a qsort comparator written as (a > b) - (a < b) instead of a - b?","options":["Because it is shorter to type","Because the subtraction can overflow, which is undefined, while the comparison form always yields -1, 0 or 1","Because it sorts faster than the subtraction form","Because qsort requires comparators to return only -1 or 1"],"answerIndex":1,"explanation":"A difference of two large values can exceed the range of int, and signed overflow is undefined behavior. The comparison form gives the correct sign for every pair of values without any arithmetic that can overflow."}]', '[]', '2026-06-24T17:35:47.290Z', '2026-10-18T17:35:47.290Z');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_c_advanced_1', 'usr_seed00000a', 'crs_c_advanced', 5, 'Best course I''ve taken on the topic', 'The explanations build intuition before the math, and every concept is backed by code you actually run. I finally understand what''s happening under the hood instead of copying snippets.', '2026-08-28T13:35:47.290Z', '2026-08-28T13:35:47.290Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000a');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_c_advanced_2', 'usr_seed00000r', 'crs_c_advanced', 5, 'Finally clicked', 'I''d tried learning this from scattered blog posts and papers. Having a single coherent narrative with good visuals made it click. The capstone tied everything together.', '2026-10-13T07:35:47.290Z', '2026-10-13T07:35:47.290Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000r');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_c_advanced_3', 'usr_seed00001c', 'crs_c_advanced', 3, 'Very good', 'Good content overall, but I wanted more exercises and a slower pace in the later sections. Still learned a lot.', '2026-10-16T15:35:47.290Z', '2026-10-16T15:35:47.290Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001c');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_c_advanced_4', 'usr_seed00001i', 'crs_c_advanced', 5, 'Dense but fantastic', 'This is not a fluffy overview — it goes deep. Expect to pause and re-watch, but the payoff is real. The instructor clearly knows the material at a research level.', '2026-08-19T10:35:47.290Z', '2026-08-19T10:35:47.290Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001i');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_c_advanced_5', 'usr_seed00001r', 'crs_c_advanced', 5, 'Worth every minute', 'Clear, well-paced and incredibly practical. The projects were challenging in the right way, and I used what I learned at work within a week of finishing.', '2026-09-26T11:35:47.290Z', '2026-09-26T11:35:47.290Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001r');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_c_advanced_6', 'usr_seed00001s', 'crs_c_advanced', 5, 'Great instructor, great community', 'Questions in the Q&A got thoughtful answers quickly. The notes feature and lesson resources made it easy to review before my exam.', '2026-08-03T02:35:47.290Z', '2026-08-03T02:35:47.290Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001s');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_c_advanced_7', 'usr_seed00002k', 'crs_c_advanced', 3, 'Very good', 'Good content overall, but I wanted more exercises and a slower pace in the later sections. Still learned a lot.', '2026-10-14T02:35:47.290Z', '2026-10-14T02:35:47.290Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002k');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_c_advanced_8', 'usr_seed00002w', 'crs_c_advanced', 5, 'Great instructor, great community', 'Questions in the Q&A got thoughtful answers quickly. The notes feature and lesson resources made it easy to review before my exam.', '2026-08-14T14:35:47.290Z', '2026-08-14T14:35:47.290Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002w');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_c_advanced_9', 'usr_seed00003k', 'crs_c_advanced', 2, 'Very good', 'Good content overall, but I wanted more exercises and a slower pace in the later sections. Still learned a lot.', '2026-09-08T02:35:47.290Z', '2026-09-08T02:35:47.290Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00003k');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_c_advanced_10', 'usr_seed00003m', 'crs_c_advanced', 4, 'Dense but fantastic', 'This is not a fluffy overview — it goes deep. Expect to pause and re-watch, but the payoff is real. The instructor clearly knows the material at a research level.', '2026-08-24T03:35:47.290Z', '2026-08-24T03:35:47.290Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00003m');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_c_advanced_11', 'usr_seed000040', 'crs_c_advanced', 5, 'Great instructor, great community', 'Questions in the Q&A got thoughtful answers quickly. The notes feature and lesson resources made it easy to review before my exam.', '2026-10-11T17:35:47.290Z', '2026-10-11T17:35:47.290Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000040');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_c_advanced_12', 'usr_seed00004a', 'crs_c_advanced', 5, 'Best course I''ve taken on the topic', 'The explanations build intuition before the math, and every concept is backed by code you actually run. I finally understand what''s happening under the hood instead of copying snippets.', '2026-10-05T01:35:47.290Z', '2026-10-05T01:35:47.290Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00004a');

UPDATE courses SET rating_avg = coalesce((SELECT avg(rating) FROM reviews WHERE course_id = 'crs_c_advanced'), 0), rating_count = (SELECT count(*) FROM reviews WHERE course_id = 'crs_c_advanced') WHERE id = 'crs_c_advanced';
