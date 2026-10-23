You have studied the parts: heap memory, `void *` and element sizes, `memcpy`, ownership, alignment, bounds checks and modular headers. This project puts them together in one small but complete library: a **generic dynamic array**, the C version of `std::vector` or Python's `list`. Other modules in the rest of this course, including the key-value store in the next project, will reuse ideas from it.

The library is a single header and a single source file. It stores elements of any type, grows when needed, checks every index, and owns its memory. When you finish, you will have a module you can drop into a real program, and you will have seen how the design choices in earlier lessons add up.

## Requirements

Write down the contract before you write any code. The array must:

1. store elements of any fixed size, chosen when the array is created,
2. copy each element into storage it owns,
3. grow geometrically, so that appending is amortized constant time,
4. check every index, and report errors through return values rather than crashing,
5. free all of its memory in one call.

Requirements like these make the rest of the design easier. Each one maps to a decision: the element size is stored in the struct, growth uses doubling, and every operation returns a status.

## The interface

The header declares what callers may use. The struct is public so that callers can read `length`, but they must change the array only through the functions:

```c
/* dynarray.h */
#ifndef DYNARRAY_H
#define DYNARRAY_H

#include <stddef.h>

typedef struct {
    unsigned char *data;    /* owned: allocated and freed by this module */
    size_t elem_size;       /* bytes per element, fixed at init */
    size_t length;          /* number of elements in use */
    size_t capacity;        /* number of elements allocated */
} dyn_array;

int    da_init(dyn_array *a, size_t elem_size);
void   da_destroy(dyn_array *a);
int    da_push(dyn_array *a, const void *element);
int    da_insert(dyn_array *a, size_t index, const void *element);
int    da_remove(dyn_array *a, size_t index);
void  *da_get(dyn_array *a, size_t index);
int    da_reserve(dyn_array *a, size_t min_capacity);

#endif
```

Every function that can fail returns `0` on failure and `1` on success, and `da_get` returns `NULL` for an index out of range. A caller can check each result without reading the implementation.

## Growth

Growth is the performance heart of the design. When the array is full, it allocates a block twice the size. Doubling means that the total cost of `n` appends is proportional to `n`, not `n` squared, because each copy is paid for by the many cheap appends that came before it. The growth rule goes in one helper, so it is easy to test and change:

```c
int da_reserve(dyn_array *a, size_t min_capacity) {
    if (min_capacity <= a->capacity) return 1;
    size_t cap = a->capacity ? a->capacity : 4;
    while (cap < min_capacity) {
        if (cap > SIZE_MAX / 2) return 0;      /* doubling would overflow */
        cap *= 2;
    }
    if (cap > SIZE_MAX / a->elem_size) return 0;   /* the byte count would overflow */
    unsigned char *grown = realloc(a->data, cap * a->elem_size);
    if (grown == NULL) return 0;               /* the old block is still valid */
    a->data = grown;
    a->capacity = cap;
    return 1;
}
```

The overflow checks come from lesson 20, and they are not optional: `cap * elem_size` is an allocation size, and a wrapped product would hand back a block that is too small. Note also that `realloc` writes its result to `grown` first. The original pointer stays valid if the call fails.

The growth rule is easy to verify with a predict question. The array starts with no storage, the first growth allocates four slots, and the fifth push doubles that to eight:

```c predict id=growth-capacity title="What is printed after five pushes?"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    unsigned char *data;
    size_t elem_size;
    size_t length;
    size_t capacity;
} dyn_array;

static int da_reserve(dyn_array *a, size_t min_capacity) {
    if (min_capacity <= a->capacity) return 1;
    size_t cap = a->capacity ? a->capacity : 4;
    while (cap < min_capacity) cap *= 2;
    unsigned char *grown = realloc(a->data, cap * a->elem_size);
    if (grown == NULL) return 0;
    a->data = grown;
    a->capacity = cap;
    return 1;
}

static int da_push(dyn_array *a, const void *element) {
    if (!da_reserve(a, a->length + 1)) return 0;
    memcpy(a->data + a->length * a->elem_size, element, a->elem_size);
    a->length++;
    return 1;
}

int main(void) {
    dyn_array a = { NULL, sizeof(int), 0, 0 };
    for (int i = 1; i <= 5; i++) da_push(&a, &i);
    printf("%zu %zu\n", a.length, a.capacity);
    free(a.data);
    return 0;
}
--- options
5 4
* 5 8
8 5
4 8
--- explain
After five pushes the length is `5`. The first push allocates four slots. When the fifth element arrives, `da_reserve` finds the capacity full and doubles it to `8`, so the output is `5 8`. Capacity is always at least the length, and the gap between them is what makes appends cheap.

## Append, insert and remove

Appending copies the element to the end. Inserting moves the elements after the index with `memmove`, which handles overlapping regions correctly, and then copies the new element into the gap. Removing shifts the tail left:

```c
int da_push(dyn_array *a, const void *element) {
    if (!da_reserve(a, a->length + 1)) return 0;
    memcpy(a->data + a->length * a->elem_size, element, a->elem_size);
    a->length++;
    return 1;
}

int da_insert(dyn_array *a, size_t index, const void *element) {
    if (index > a->length) return 0;
    if (!da_reserve(a, a->length + 1)) return 0;
    unsigned char *at = a->data + index * a->elem_size;
    memmove(at + a->elem_size, at, (a->length - index) * a->elem_size);
    memcpy(at, element, a->elem_size);
    a->length++;
    return 1;
}

int da_remove(dyn_array *a, size_t index) {
    if (index >= a->length) return 0;
    unsigned char *at = a->data + index * a->elem_size;
    memmove(at, at + a->elem_size, (a->length - index - 1) * a->elem_size);
    a->length--;
    return 1;
}
```

The predict question below uses `da_push` and `da_insert` together, so you can confirm the shift behavior by reading the output:

```c predict id=insert-shift title="What is printed after the insert?"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    unsigned char *data;
    size_t elem_size;
    size_t length;
    size_t capacity;
} dyn_array;

static int da_reserve(dyn_array *a, size_t min_capacity) {
    if (min_capacity <= a->capacity) return 1;
    size_t cap = a->capacity ? a->capacity : 4;
    while (cap < min_capacity) cap *= 2;
    unsigned char *grown = realloc(a->data, cap * a->elem_size);
    if (grown == NULL) return 0;
    a->data = grown;
    a->capacity = cap;
    return 1;
}

static int da_push(dyn_array *a, const void *element) {
    if (!da_reserve(a, a->length + 1)) return 0;
    memcpy(a->data + a->length * a->elem_size, element, a->elem_size);
    a->length++;
    return 1;
}

static int da_insert(dyn_array *a, size_t index, const void *element) {
    if (index > a->length) return 0;
    if (!da_reserve(a, a->length + 1)) return 0;
    unsigned char *at = a->data + index * a->elem_size;
    memmove(at + a->elem_size, at, (a->length - index) * a->elem_size);
    memcpy(at, element, a->elem_size);
    a->length++;
    return 1;
}

int main(void) {
    dyn_array a = { NULL, sizeof(int), 0, 0 };
    for (int v = 1; v <= 3; v++) da_push(&a, &v);
    int nine = 9;
    da_insert(&a, 1, &nine);
    for (size_t i = 0; i < a.length; i++) {
        printf("%d ", *(int *)(a.data + i * a.elem_size));
    }
    printf("\n");
    free(a.data);
    return 0;
}
--- options
1 2 3 9 
* 1 9 2 3
9 1 2 3 
1 2 9 3 
--- explain
The array holds `1 2 3`. The insert at index `1` moves the elements from index 1 onward one slot to the right with `memmove`, which is safe even though source and destination overlap. Then the new value `9` is copied into the gap. The result is `1 9 2 3`. Using `memcpy` for the shift would be undefined behavior here, because the regions overlap, which is why the library uses `memmove`.

## Access with bounds checks

`da_get` returns a pointer to an element, or `NULL` when the index is out of range. Returning a pointer lets the caller read or write the element in place, and the bounds check keeps the pointer inside the block. A pointer from `da_get` is valid only until the next operation that may reallocate, so the caller must not hold it across a push.

```c
void *da_get(dyn_array *a, size_t index) {
    return index < a->length ? a->data + index * a->elem_size : NULL;
}
```

The predict question checks the bounds check at both edges:

```c predict id=get-bounds title="What is printed?"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    unsigned char *data;
    size_t elem_size;
    size_t length;
    size_t capacity;
} dyn_array;

static int da_push(dyn_array *a, const void *element) {
    if (a->length == a->capacity) {
        size_t cap = a->capacity ? a->capacity * 2 : 4;
        unsigned char *grown = realloc(a->data, cap * a->elem_size);
        if (grown == NULL) return 0;
        a->data = grown;
        a->capacity = cap;
    }
    memcpy(a->data + a->length * a->elem_size, element, a->elem_size);
    a->length++;
    return 1;
}

static void *da_get(dyn_array *a, size_t index) {
    return index < a->length ? a->data + index * a->elem_size : NULL;
}

int main(void) {
    dyn_array a = { NULL, sizeof(int), 0, 0 };
    int seven = 7;
    da_push(&a, &seven);
    printf("%d %d\n", da_get(&a, 0) != NULL, da_get(&a, 1) == NULL);
    free(a.data);
    return 0;
}
--- options
0 1
1 0
0 0
* 1 1
--- explain
The array has one element, so index `0` is in range and `da_get` returns a pointer, which makes `da_get(&a, 0) != NULL` true and prints `1`. Index `1` is past the end, so `da_get` returns `NULL` and `da_get(&a, 1) == NULL` is also true, printing `1`. Out-of-range access fails safely instead of reading memory outside the block.

## Destroy and ownership

`da_destroy` frees the block and resets the struct, so the array cannot be used by accident after cleanup:

```c
void da_destroy(dyn_array *a) {
    free(a->data);
    a->data = NULL;
    a->length = 0;
    a->capacity = 0;
}
```

Initialization sets the fields and allocates nothing until the first push, so an empty array costs no memory:

```c
int da_init(dyn_array *a, size_t elem_size) {
    if (elem_size == 0) return 0;
    a->data = NULL;
    a->elem_size = elem_size;
    a->length = 0;
    a->capacity = 0;
    return 1;
}
```

## Testing the library

A library is only as trustworthy as its tests. Write tests that cover:

- an empty array: `da_get` on index 0 returns `NULL`,
- growth across several capacity boundaries, checking the data after each one,
- insert at the front, the middle and the end, each followed by a full comparison,
- remove at the first and last positions,
- a struct element type, so that the element size matters,
- a failed `da_reserve`, so that the original data survives.

Run the tests under AddressSanitizer and Valgrind from lesson 19. A dynamic array is an excellent target for those tools, because most of its bugs are off-by-one errors that the sanitizers catch at once.

## Extensions to try

- Add `da_sort` that calls `qsort` with a comparator supplied by the caller (lesson 12).
- Add a `da_clone` that deep-copies, with a copy callback for elements that own memory (lesson 17).
- Replace the doubling policy with a 1.5 times growth factor, and measure the difference on a million appends.

> **In the wild:** Every major language has a dynamic array at its core: `std::vector` in C++, `ArrayList` in Java and `list` in Python. They all use the same ideas you just implemented, with geometric growth, separate size and capacity, and checked access.

## Recap

- Write the contract first: element size, ownership, growth, checks and cleanup.
- Grow by doubling, and check every multiplication before allocating.
- Use `memmove` for overlapping shifts and `memcpy` for copies into fresh space.
- Return status codes and `NULL` for failures, and never let an index escape the block.
- Test the boundaries and run the library under the sanitizers.

**Up next:** The second capstone, a key-value store that combines a hash table with file persistence.
