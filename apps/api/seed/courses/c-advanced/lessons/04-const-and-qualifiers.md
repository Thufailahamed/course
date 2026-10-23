Every function in a large program makes a promise about the data it touches. Some functions read a value and never change it. Some take ownership of a buffer. Some are called from an interrupt handler and must see every write to a hardware register. C lets you say all of this in the type system with **qualifiers**: `const`, `volatile` and `restrict`. Used well, they turn comments such as "does not modify the input" into rules the compiler enforces.

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
A string is an array of `char`, and `s[0]` is `'h'`, `s[1]` is `'i'`, and `s[2]` is the terminating null byte. The `%c` format prints one character, so the output is `i`. Reading through a `const` pointer is fine; writing to `s[0]` would be undefined behavior, not a compile error, because the literal may be stored in read-only memory.

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
- Use `volatile` for values changed outside your program's control, and never as a substitute for synchronization.

**Up next:** Function pointers, which let you pass behavior as data and build callback tables.
