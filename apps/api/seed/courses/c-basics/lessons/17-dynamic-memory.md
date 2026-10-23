So far every array had a size you knew when you wrote the program. Real programs often need memory whose size depends on the input: a list of students whose length you learn only at runtime, or a buffer that grows as text arrives. C provides this through dynamic memory. You ask for bytes with `malloc`, use them through a pointer, and give them back with `free`. The bargain is simple, and it is strict: every allocation you make must be released exactly once, by you.

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
