Every variable lives at an address in memory, a number that identifies where its bytes sit. A **pointer** is a variable whose value is an address. With pointers you can refer to a variable indirectly, pass a function the ability to change a caller's data, and build structures that grow and shrink. Pointers are the feature that makes C powerful, and they are the one most beginners find hard. Take them one step at a time.

## Address-of and dereference

Two operators do most of the work. The `&` operator gives you the address of a variable. The `*` operator, applied to a pointer, reaches the value at that address.

```c
#include <stdio.h>

int main(void) {
    int n = 7;
    int *p = &n;     /* p holds the address of n */

    printf("%d\n", *p);   /* prints 7: the value at that address */
    *p = 12;              /* writes 12 into n, through the pointer */
    printf("%d\n", n);    /* prints 12 */
    return 0;
}
```

Read `int *p` as "p is a pointer to an int". The star in a declaration says "pointer", and the star in an expression says "the thing this points to". The two uses of `*` are the same symbol with different jobs, which is why they confuse people at first.

> **Tip:** Say the declaration out loud. `int *p` reads as "p is a pointer to int", and `*p` reads as "the int that p points to".

The next predict question checks that a write through a pointer changes the original variable:

```c predict id=pointer-basic title="What does this print?"
#include <stdio.h>

int main(void) {
    int n = 7;
    int *p = &n;
    *p = *p + 1;
    printf("%d\n", n);
    return 0;
}
--- options
* 8
7
6
garbage
--- explain
`*p` refers to `n` itself, not to a copy. So `*p = *p + 1` reads 7, adds 1, and stores 8 back into `n`. The variable `n` now holds 8, which `printf` shows. Pointers give you another name for the same memory, and changes through either name are visible through both.
```

## Pointers have types

A pointer's type says what kind of value lives at its address. An `int *` points to an `int`, and a `double *` points to a `double`. The type matters when you use the pointer, because `*p` reads the right number of bytes, and pointer arithmetic moves by the size of the pointed-to type.

```c
double price = 4.5;
double *pp = &price;
```

Assigning a pointer of one type to a pointer of another type without a cast is a compile warning, and the result of using it is undefined behavior. Keep the types matched.

## Pass by pointer

The main reason to use pointers early is to let a function change a caller's variable. You pass the address, and the function dereferences it.

```c predict id=swap-pointers title="What does this print?"
#include <stdio.h>

void swap(int *a, int *b) {
    int t = *a;
    *a = *b;
    *b = t;
}

int main(void) {
    int x = 2, y = 9;
    swap(&x, &y);
    printf("%d %d\n", x, y);
    return 0;
}
--- options
* 9 2
2 9
9 9
2 2
--- explain
`swap` receives the addresses of `x` and `y`. It saves the value at `a` in `t`, copies the value at `b` into `a`, and then copies `t` into `b`. The variables in `main` now hold 9 and 2. This is the same pattern that `scanf` uses when you write `scanf("%d", &age)`: `scanf` needs the address so it can store the value there.
```

> **Pitfall:** Passing a value where a pointer is expected, or a pointer where a value is expected, is a common mistake. The compiler will often warn you, so read those warnings.

## Pointers can be reassigned

A pointer is a variable in its own right, so it can point somewhere else later. Reassigning a pointer changes where it points, not the value it used to point to.

```c predict id=ptr-reassign title="What does this print?"
#include <stdio.h>

int main(void) {
    int a = 1, b = 2;
    int *p = &a;
    p = &b;
    *p += 40;
    printf("%d %d\n", a, b);
    return 0;
}
--- options
* 1 42
41 2
1 2
42 42
--- explain
`p` starts at `&a`, then is reassigned to `&b`. The line `*p += 40` therefore changes `b`, not `a`. `a` keeps its value of 1, and `b` becomes 42. A pointer's value is an address, and reassigning the pointer changes only the address.
```

## NULL and safe pointers

A pointer that points nowhere should hold `NULL`, which the standard defines in `<stdio.h>`, `<stdlib.h>` and `<stddef.h>`. Check a pointer against `NULL` before you use it, especially when it came from a function that can fail. Dereferencing a null pointer is undefined behavior, and on most systems it crashes the program.

```c
#include <stdio.h>

int main(void) {
    int *maybe = NULL;

    if (maybe == NULL) {
        printf("no value to read\n");
    } else {
        printf("%d\n", *maybe);
    }
    return 0;
}
```

> **Pitfall:** An uninitialized pointer holds a random address. Initialize every pointer, either to a real address or to `NULL`, when you declare it.

## Recap

- `&` gives the address of a variable, and `*` reaches the value at a pointer's address.
- In a declaration, `int *p` means "p points to an int". In an expression, `*p` means "the int at p".
- A pointer's type determines how it reads memory and how pointer arithmetic moves.
- Pass a pointer to let a function change a caller's variable. That is how `scanf` works.
- Reassigning a pointer changes its address, not the value it used to point to.
- Initialize pointers. Check them against `NULL` before dereferencing.

**Up next:** how pointers and arrays are connected, and the arithmetic that moves between elements.
