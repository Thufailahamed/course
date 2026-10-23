You declare a struct as a list of fields, and it feels like the sum of those fields. Then you call `sizeof` and get a bigger number than you expected. The extra bytes are **padding**, and they are not a mistake. They are how the compiler makes every field start at an address the processor can read efficiently, or at all. Understanding layout matters for three reasons: it affects memory use in large arrays, it decides whether data can be shared with a file or the network, and it sets the rules for casting between types.

This lesson explains alignment, shows why padding appears, teaches you to arrange fields to waste less space, and marks the boundaries of what the standard promises. Because the exact padding is implementation-defined, the predict questions check the guarantees, not specific byte counts.

## Alignment

Every type has an **alignment requirement**: the address of an object of that type must be a multiple of some number. An `int` with a 4-byte alignment must start at an address divisible by 4. The reason is hardware. Many processors read a 4-byte value in one operation only when it sits on a 4-byte boundary, and on some they fault or read slowly otherwise.

C11 gives you two tools for alignment:

```c
#include <stdalign.h>

size_t a = alignof(int);       /* the alignment of int, often 4 */
size_t b = alignof(double);    /* often 8 */
```

You will rarely write these numbers, but they explain the layout the compiler chooses.

## Why padding appears

Consider this struct:

```c
struct sample {
    char tag;      /* 1 byte */
    int  count;    /* needs a 4-byte boundary */
    char flag;     /* 1 byte */
};
```

The `char` at the start takes one byte. The `int` must begin at a multiple of its alignment, so the compiler inserts padding after `tag` to move `count` to the next boundary. The trailing `char` takes another byte, and the total size is then rounded up so that every element of an array of these structs is aligned correctly. On common 64-bit systems this struct is 12 bytes, though the standard does not promise that number. Your 6 bytes of data occupy 12 bytes of storage.

The predict question checks only the guarantee that always holds. A struct is at least as large as the sum of its members, because padding can only add bytes:

```c predict id=struct-guarantee title="Does sizeof report at least the sum of the members?"
#include <stdio.h>

struct sample {
    char tag;
    int count;
    char flag;
};

int main(void) {
    size_t members = sizeof(char) + sizeof(int) + sizeof(char);
    printf("%d\n", (int)(sizeof(struct sample) >= members));
    return 0;
}
--- options
0
* 1
2
compile error
--- explain
The three members add up to `sizeof(char) + sizeof(int) + sizeof(char)`. Padding can only insert bytes, never remove them, so `sizeof(struct sample)` is always at least that sum. The comparison is true, which prints `1`. The exact size is up to the compiler, which is why this predict question checks the inequality rather than a number.

## Reordering to save space

Padding depends on the order of fields. Placing the largest and most strictly aligned fields first, and grouping small ones together, reduces the gaps. Compare two versions of the same data:

```c
struct loose {
    char a;      /* padding follows */
    double b;
    char c;      /* padding follows */
};

struct tight {
    double b;
    char a;
    char c;      /* the two chars can share the same tail padding */
};
```

Both structs hold the same data. The second usually uses less space, because the two `char` fields sit next to each other instead of being separated by a `double`'s alignment. In a large array, the saving multiplies. Reordering is a free optimization that does not change the program's meaning, and it is worth doing for big tables of records.

> **Tip:** When you design a record type, sort its members by alignment from largest to smallest. It is simple, predictable and usually optimal. Check the result with `sizeof` on your target platform, and do not guess.

> **Pitfall:** Do not rely on a specific layout when you write data to a file or send it over a network. Padding, byte order and the representation of fields differ between machines. Write each field explicitly, in a fixed byte order, with fixed-width types from `<stdint.h>`, and check the result.

## Arrays of structs and pointer arithmetic

An array of structs is a contiguous block, and each element begins one `sizeof` after the previous one. Pointer arithmetic moves by whole elements, which makes a loop over records simple and fast. The next predict question uses that fact, along with the arrow operator:

```c predict id=array-of-structs title="What is printed?"
#include <stdio.h>

struct item {
    int id;
    int quantity;
};

int main(void) {
    struct item items[3] = { { 101, 2 }, { 102, 5 }, { 103, 1 } };
    struct item *p = items + 1;
    printf("%d\n", (p + 1)->id);
    return 0;
}
--- options
101
102
* 103
1
--- explain
`items + 1` points at the second element, `{102, 5}`. Adding one more element moves the pointer to the third, `{103, 1}`. The arrow operator `->` reads the `id` field of that element, which is `103`. Pointer arithmetic on `struct item *` steps by `sizeof(struct item)` bytes, which is why the program does not need to know that size.
```

One size is fixed by the standard, and it anchors every other calculation: `sizeof(char)` is always 1. Everything else is measured in those units:

```c predict id=char-size title="What is printed?"
#include <stdio.h>

int main(void) {
    printf("%d\n", (int)sizeof(char));
    return 0;
}
--- options
2
4
* 1
8
--- explain
The standard defines a `char` as one byte, and `sizeof` counts in bytes, so `sizeof(char)` is always `1` on every conforming compiler. That is why the number of bytes in a buffer equals the number of characters it can hold, and why `malloc(n)` for a string of `n` characters works without multiplying.

## Copying and comparing structs

Assignment copies every member, padding included or not, and it is defined for any struct. Comparing two structs with `==` is not allowed in C, because padding bytes may contain anything. Compare field by field, or use a function that does. This is a rule you will hit early, and the field-by-field version is the one to write:

```c
static int point_equal(struct point a, struct point b) {
    return a.x == b.x && a.y == b.y;
}
```

Also note that `memcmp` on whole structs is not reliable for equality when padding exists, because padding bytes are not guaranteed to be zero.

## Flexible array members

The last member of a struct may be an array with no declared size. This lets you allocate a header and its data in one block, which is a common pattern for buffers and messages:

```c
typedef struct {
    size_t length;
    char data[];          /* flexible array member: must be last */
} message;

message *m = malloc(sizeof *m + text_length + 1);
m->length = text_length;
memcpy(m->data, text, text_length + 1);
```

The allocation adds the space for the data after the header. Only allocate with `sizeof *m` plus the extra bytes, and free the whole block with a single `free`.

> **In the wild:** Network stacks and file formats define their structures with explicit field sizes and packing rules, because the compiler's default layout is not a contract. When a protocol says "the field at offset 4 is a 16-bit length", the code must put it there exactly.

## Recap

- Each type has an alignment; the compiler inserts padding so fields land on aligned addresses.
- A struct's size is at least the sum of its members and often larger because of padding.
- Ordering members from largest to smallest alignment usually reduces the waste.
- Never assume a particular layout for files or networks; write fields explicitly.
- Compare structs field by field, and use flexible array members for header-plus-data blocks.

**Up next:** Unions and type punning, and how `memcpy` reads a value's bytes safely, without breaking the aliasing rules.
