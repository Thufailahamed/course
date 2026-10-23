Most programmers debug with `printf` and guesswork. That works for small problems, and it fails badly for the bugs that matter in C: memory corruption that appears far from its cause, undefined behavior that only shows up with optimizations, and leaks that take days to exhaust memory. Professionals use a small set of tools that observe the program directly: a debugger that stops it at the right moment, sanitizers that instrument every memory access, and Valgrind that checks the heap. Each tool finds a different class of bug, and together they cover most of what this course warned you about.

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
main.c:9:12: runtime error: signed integer overflow: 2147483647 + 1 cannot be represented in type 'int'
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
- Use gdb's `break`, `next`, `print`, `backtrace` and `watch` to observe a program as it runs.
- AddressSanitizer finds memory errors at the moment they occur; UBSan finds undefined arithmetic and shifts.
- Valgrind finds leaks and uninitialized reads without recompilation; run it alongside ASan.
- Reproduce a bug, reduce the input, and then debug.

**Up next:** Secure C: buffer bounds, `snprintf`, integer overflow and the habits that prevent the vulnerabilities these tools reveal.
