The compiler checks types. It does not check who owns memory. Nothing in C tells you whether a function returns a block you must free, or whether it keeps a pointer you passed in. For that reason, the most important design skill in C is writing down **ownership**: for every pointer, one piece of code is responsible for freeing it, and everyone else borrows it for a known period.

A leak happens when the owner forgets. A double free happens when two owners both think they are responsible. A use-after-free happens when someone keeps borrowing a pointer after the owner released it. All three are ownership failures, and all three come from code that never stated who owns what.

This lesson gives you a small set of conventions that make ownership visible, and shows how to write cleanup code that stays correct when a function has several ways to fail.

## Three questions for every pointer

When you receive or return a pointer, ask:

1. **Who allocates it?** Is it fresh heap memory, a static object, or a stack variable?
2. **Who frees it?** Exactly one piece of code must do this.
3. **How long is the borrow?** Does the pointer stay valid after the call returns?

Write the answers in the function's documentation. A header comment such as `/* Returns a newly allocated string. The caller must free it. */` is worth more than any clever type trick.

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
