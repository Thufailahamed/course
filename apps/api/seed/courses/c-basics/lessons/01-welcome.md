C is the language that most of the software you use every day is built on. The kernel that runs your phone, the database behind your favourite app, the firmware in your microwave: many of them are written in C, because C gives you direct control over memory and the machine underneath. It is also a language that rewards care. It will not hold your hand, and that is exactly why people who learn it well understand computers deeply.

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
