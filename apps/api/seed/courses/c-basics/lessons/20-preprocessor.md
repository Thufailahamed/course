Before the compiler sees your code, a separate step called the preprocessor reads it. The preprocessor handles every line that starts with `#`. It pastes in other files, replaces names with text, and includes or excludes parts of your file depending on conditions. Understanding it removes the mystery of `#include` and explains why some macros behave in strange ways.

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
