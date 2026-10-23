A program with one file is easy to hold in your head. A program with fifty files, written by a team over several years, is not. What keeps it manageable is a set of boundaries: each module publishes a small interface, hides its internal details, and can change those details without breaking its callers. C has no classes or namespaces to enforce those boundaries, so it relies on conventions the compiler can check: headers that declare what a module offers, `static` to keep internals private, and **opaque types** that hide a structure's layout behind a pointer.

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

The `#ifndef` guard stops the header from being processed twice when two files include it, directly or through another header. The predict question shows the guard's effect:

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

> **In the wild:** Large C projects such as the Linux kernel and SQLite publish headers that declare a small public API, and they keep most of the code behind `static` functions and opaque handles. SQLite's public header is short, and its implementation runs to hundreds of thousands of lines behind it.

## Recap

- Headers declare the interface; source files define it. Guard every header with `#ifndef`.
- Use `static` for everything that is not part of the public interface.
- Hide struct layouts behind opaque pointers to keep invariants inside one file.
- A `static` local keeps state between calls while staying private.
- Avoid mutable global variables with external linkage, and prefer functions that own the state.

**Up next:** The first capstone, a generic dynamic array library, where you apply every technique from the course to one complete module.
