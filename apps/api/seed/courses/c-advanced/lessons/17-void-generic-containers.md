C does not have templates or generics. If you want one stack implementation that works for integers, strings and records, you must get the flexibility from elsewhere. The standard library did it with `void *`, the address of any object, combined with a size, and with comparator and callback functions. `qsort`, `bsearch` and `memcpy` all work this way. Learning the pattern lets you write containers, algorithms and APIs that serve many types without copying the code for each.

This lesson shows how to write generic code with `void *` and element sizes, how to move elements safely with `memcpy`, how to address them with `char *` arithmetic, and how to keep ownership and cleanup in the hands of the caller. It also shows the limits of the approach: the compiler checks less, so the discipline has to come from you.

## The principle: pointer plus size

Every element in a generic container is described by two things: the address of its bytes and the size of one element. A generic function never needs to know the type. It only needs to copy, compare or address `size` bytes at a time. This is why the standard functions take a `size_t` argument next to every pointer.

The first example is a swap. It cannot use `=` on the values, because it does not know their type, so it copies bytes through a temporary buffer:

```c
#include <string.h>

static void swap_elements(void *a, void *b, size_t size) {
    unsigned char tmp[256];          /* this sketch supports elements up to 256 bytes */
    memcpy(tmp, a, size);
    memcpy(a, b, size);
    memcpy(b, tmp, size);
}
```

The check `size <= sizeof tmp` belongs in real code, and the function should refuse larger elements instead of overflowing the buffer. A production version would allocate the temporary when the size is large. Here, the size limit is a contract, and the comment states it.

The predict question swaps two integers through the generic function:

```c predict id=generic-swap title="What is printed?"
#include <stdio.h>
#include <string.h>

static void swap_elements(void *a, void *b, size_t size) {
    unsigned char tmp[256];
    memcpy(tmp, a, size);
    memcpy(a, b, size);
    memcpy(b, tmp, size);
}

int main(void) {
    int x = 3;
    int y = 8;
    swap_elements(&x, &y, sizeof x);
    printf("%d %d\n", x, y);
    return 0;
}
--- options
3 8
* 8 3
0 0
3 3
--- explain
The function copies `x`'s bytes into the temporary, copies `y`'s bytes into `x`, then copies the temporary into `y`. The values exchange without the function knowing that they are integers. The `sizeof x` argument tells the function how many bytes make one element, which is the only type information it needs.

## Addressing elements with char pointers

To find element `i` in a block of elements, you move `i * size` bytes from the base address. Pointer arithmetic on a `char *` (or `unsigned char *`) is the only way to move by bytes, because `char` has size 1 by definition. Converting back to the element type happens at the point of use:

```c
static void *element_at(void *base, size_t index, size_t size) {
    return (unsigned char *)base + index * size;
}
```

The next question reads an element through that function. The cast to `int *` happens only when the code knows the element's type:

```c predict id=element-at title="What is printed?"
#include <stdio.h>
#include <stddef.h>

static void *element_at(void *base, size_t index, size_t size) {
    return (unsigned char *)base + index * size;
}

int main(void) {
    int values[3] = { 5, 6, 7 };
    printf("%d\n", *(int *)element_at(values, 2, sizeof values[0]));
    return 0;
}
--- options
5
6
* 7
15
--- explain
`element_at` moves `2 * sizeof(int)` bytes past the start of `values`, which lands on the third element, `7`. The caller casts the returned `void *` to `int *` and dereferences it. Notice that the function never multiplies by an element type, so the same code would work for any array whose element size you pass in.

## A generic stack

Now combine those pieces into a container. The container stores a copy of each element, in a buffer it owns. The caller supplies the element size when it creates the stack, and pushes by copying from a pointer the caller holds:

```c
typedef struct {
    unsigned char *data;
    size_t size;        /* bytes per element */
    size_t count;
    size_t capacity;    /* in elements */
} stack;

int stack_push(stack *s, const void *element) {
    if (s->count == s->capacity) {
        size_t new_capacity = s->capacity ? s->capacity * 2 : 8;
        unsigned char *grown = realloc(s->data, new_capacity * s->size);
        if (grown == NULL) return 0;
        s->data = grown;
        s->capacity = new_capacity;
    }
    memcpy(s->data + s->count * s->size, element, s->size);
    s->count++;
    return 1;
}

void *stack_top(stack *s) {
    return s->count ? s->data + (s->count - 1) * s->size : NULL;
}
```

The container copies each element into its buffer. That design is simple and safe for values, because the caller can reuse or free its own variable after the push. It is the same ownership rule you learned in lesson 7: the stack owns its copy, and the caller owns the original.

> **Pitfall:** A container that stores copies cannot know how to copy an element that holds its own heap pointers, such as a string. A shallow `memcpy` duplicates the pointer, and two owners then free the same block. For such types, the container needs callbacks: a copy function and a destroy function, supplied by the caller. This is the pattern used by most real generic containers.

The predict question checks the stack's copy semantics:

```c predict id=stack-copy title="What is printed?"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    unsigned char *data;
    size_t size;
    size_t count;
    size_t capacity;
} stack;

static int stack_push(stack *s, const void *element) {
    if (s->count == s->capacity) {
        size_t new_capacity = s->capacity ? s->capacity * 2 : 2;
        unsigned char *grown = realloc(s->data, new_capacity * s->size);
        if (grown == NULL) return 0;
        s->data = grown;
        s->capacity = new_capacity;
    }
    memcpy(s->data + s->count * s->size, element, s->size);
    s->count++;
    return 1;
}

int main(void) {
    stack s = { NULL, sizeof(int), 0, 0 };
    int value = 4;
    stack_push(&s, &value);
    value = 9;
    stack_push(&s, &value);
    printf("%d %d\n", *(int *)s.data, *(int *)(s.data + s.size));
    free(s.data);
    return 0;
}
--- options
9 9
4 9
* 4 9
9 4
--- explain
`stack_push` copies the bytes of `value` into the buffer each time. The first push stores `4`. Then `value` changes to `9` and the second push stores a separate copy of `9`. The buffer therefore holds `4` followed by `9`. Changing the original variable after the push does not change the stored element, which is what makes the copy semantics explicit.
```

## Designing the interface

A generic container is only as safe as its contract. Write these things down in the header:

- **Element size:** the caller passes it at creation, and every operation uses it.
- **Ownership:** the container owns its copies. Elements returned from `stack_top` are borrowed and become invalid after the next push, because `realloc` may move the buffer.
- **Failure:** every allocating operation reports failure through its return value.
- **Cleanup:** a `stack_destroy` function frees the buffer. Callers must not free it directly.

> **Tip:** Store the element size inside the container, so no caller can pass the wrong size on a later call. The size is a property of the container's type, and the interface should make the wrong call impossible.

> **In the wild:** The C standard library uses `void *` plus size for `qsort`, `bsearch`, `memcpy` and `fwrite`. Many libraries, including hash tables in database engines and generic lists in kernels, use the same design, adding copy and destroy callbacks for types that own resources.

## Recap

- Generic C code works on `void *` addresses and an explicit element size.
- Use `char *` arithmetic to move by bytes, and cast to the real type only where it is known.
- Copy elements with `memcpy`, and make the container own its copies.
- Shallow copies are wrong for types that own resources; supply copy and destroy callbacks.
- Document ownership, element size and failure behavior in the interface.

**Up next:** Binary files and error handling with `errno`, the file operations that persist the data structures you have built.
