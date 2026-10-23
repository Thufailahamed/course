Local variables live on the stack, and their lifetime ends when the function returns. Static variables live for the whole program. Neither works when you do not know, until run time, how much memory you need. A text editor opening a 40-megabyte file, a web server handling a request or a parser reading a list of unknown length all need memory whose size is decided while the program runs. That memory comes from the **heap**, and C gives you four functions to manage it: `malloc`, `calloc`, `realloc` and `free`.

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

> **Tip:** Always assign `realloc`'s result to a new pointer first. Only replace the original once you know the call succeeded. This one rule prevents a whole family of leaks.

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
- **Double free:** freeing the same block twice, which can corrupt the allocator's own bookkeeping.
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
