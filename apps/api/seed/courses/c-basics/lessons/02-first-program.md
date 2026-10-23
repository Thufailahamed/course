Every C program starts at the same place, a function called `main`. When you run a program, the operating system calls `main`, your code runs from top to bottom, and the value `main` returns tells the system whether things went well. Before we look at that, let's look at the simplest useful program you can write.

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

Each specifier consumes one of the values after the format string, in order. If the types don't match the specifier, the result is undefined, so always keep them in step.

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
The compiler reads `printf("Hi")` and then finds `return` where it expected the end of a statement. It stops with an error such as `expected ';' before 'return'`. Nothing runs, because a program that does not compile never becomes a program at all.
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
- Format specifiers such as `%d`, `%f`, `%c` and `%s` must match the value's type.
- `return 0;` reports success. Any other value reports a problem.
- Read the first compiler error, and fix it before the rest.

**Up next:** variables and the basic types that hold their values.
