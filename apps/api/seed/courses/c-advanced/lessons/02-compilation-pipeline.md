When you type `gcc main.c -o main`, it looks like one step. It is actually a pipeline of four separate stages, and each one transforms your code in a different way. Knowing the stages turns mysterious errors into obvious ones. A missing semicolon, a misspelled function and an undefined reference each come from a different stage, and each stage has its own fix.

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

The linker combines several object files and libraries into one executable. It resolves each undefined name to a definition somewhere else, places all the code and data in memory, and patches the addresses. When the linker says `undefined reference to 'helper'`, the compiler has done its job. The definition of `helper` was simply never provided to the link.

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
