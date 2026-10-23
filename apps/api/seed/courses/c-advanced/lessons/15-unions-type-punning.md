A struct stores all of its members side by side. A **union** stores them on top of each other: every member starts at the same address, and the storage is only as big as the largest member. A union can hold one of several types at a time, which makes it the natural tool for a tagged value, such as a JSON node that is a number, a string or a list. It also makes unions a common source of confusion, because reading a member you did not write is one of the places where C's rules get genuinely subtle.

This lesson shows how to use unions correctly, explains **type punning**, the practice of reinterpreting the bits of one type as another, and shows the portable way to do it with `memcpy`. You will also learn why the naive version is dangerous, even when it appears to work.

## Unions as tagged values

The safe and common use of a union is to store one of several variants, plus a tag that says which variant is active:

```c
typedef enum { VALUE_INT, VALUE_TEXT } value_kind;

typedef struct {
    value_kind kind;
    union {
        long integer;
        const char *text;
    } as;
} value;
```

The tag `kind` is the agreement between the writer and the reader. Every access to `as` must check it first, and a `switch` on the tag keeps the code honest:

```c
long value_sum(const value *items, size_t count) {
    long total = 0;
    for (size_t i = 0; i < count; i++) {
        switch (items[i].kind) {
        case VALUE_INT:  total += items[i].as.integer; break;
        case VALUE_TEXT: /* text does not contribute */ break;
        }
    }
    return total;
}
```

This pattern is the C equivalent of a sum type, and you will see it in parsers, interpreters and message formats. The predict question uses a simplified version of it:

```c predict id=tagged-sum title="What is printed?"
#include <stdio.h>

typedef enum { INT_KIND, TEXT_KIND } kind;

typedef struct {
    kind tag;
    union {
        int number;
        const char *text;
    } as;
} item;

int main(void) {
    item items[3] = {
        { INT_KIND, { .number = 4 } },
        { TEXT_KIND, { .text = "skip me" } },
        { INT_KIND, { .number = 6 } },
    };
    int total = 0;
    for (int i = 0; i < 3; i++) {
        if (items[i].tag == INT_KIND) total += items[i].as.number;
    }
    printf("%d\n", total);
    return 0;
}
--- options
4
* 10
13
skip me
--- explain
The tag decides which member is valid. The first and third items are `INT_KIND`, so their numbers `4` and `6` are added, giving `10`. The middle item is `TEXT_KIND`, so the loop skips its `text` member. The designated initializers `.number` and `.text` set exactly the member named, which is clearer than relying on position.

> **Tip:** Keep the tag and the union in the same struct, and write one function that switches on the tag. Scattered `if` checks on a bare union are where the bugs hide.

## Reading the wrong member

A union lets you write one member and read another. Whether that is allowed depends on the types. The standard says that reading a member that was not the last one written is undefined behavior, with one exception: you may view any object's bytes through a character type. So the following is not the portable way to see a float's bits:

```c
union bits { float f; uint32_t u; };
union bits b;
b.f = 1.0f;
uint32_t raw = b.u;     /* undefined behavior in strict C */
```

Compilers document that this works on their platforms, and it is tempting. Do not rely on it. The compiler is allowed to assume it never happens, and optimizations can break the code in surprising ways.

## Type punning with memcpy

The portable way to reinterpret bytes is `memcpy`. It copies the bytes of one object into another, and the standard defines the result as a copy of the same representation, with no aliasing rules broken. The predict question copies an int's bytes into a new object, and it uses a different value from the source to make the copy visible:

```c predict id=memcpy-copy title="What is printed?"
#include <stdio.h>
#include <string.h>

int main(void) {
    int src[3] = { 1, 2, 3 };
    int dst[3] = { 0, 0, 0 };
    memcpy(dst, src + 1, 2 * sizeof(int));
    printf("%d %d %d\n", dst[0], dst[1], dst[2]);
    return 0;
}
--- options
1 2 3
* 2 3 0
0 2 3
2 3 3
--- explain
`src + 1` points at the second element, `2`. Copying two `int`s from there fills `dst[0]` with `2` and `dst[1]` with `3`. The third element of `dst` was never touched, so it keeps its initial `0`. `memcpy` moves exactly the number of bytes you ask for, measured in bytes, which is why the size is `2 * sizeof(int)`.

When the goal is the bits of a float, `memcpy` gives the portable answer:

```c
float f = 1.0f;
uint32_t bits;
memcpy(&bits, &f, sizeof bits);   /* the bit pattern of f, with no aliasing violation */
```

The copy assumes that `float` and `uint32_t` have the same size, which holds on most systems but is not guaranteed by the standard. Check it with `_Static_assert(sizeof(float) == sizeof(uint32_t), "size")` before you rely on it. Also remember that the bit layout of floating-point numbers is defined by IEEE 754 on nearly every platform, but the standard leaves the representation implementation-defined.

## Byte order

When you inspect individual bytes of a multi-byte value, the order of those bytes depends on the machine. Little-endian systems store the least significant byte first, and big-endian systems store it last. Network protocols use big-endian order, so code that reads them must convert explicitly rather than assume the native order. Writing bytes by shifting and masking, as lesson 13 showed, is the portable way to build a value from a sequence of bytes:

```c
uint32_t read_be32(const unsigned char *p) {
    return ((uint32_t)p[0] << 24) | ((uint32_t)p[1] << 16)
         | ((uint32_t)p[2] << 8)  |  (uint32_t)p[3];
}
```

This function gives the same result on every machine, because it never looks at the native byte order. The predict question feeds it four bytes from a network-style packet:

```c predict id=read-be32 title="What is printed?"
#include <stdio.h>
#include <stdint.h>

static uint32_t read_be32(const unsigned char *p) {
    return ((uint32_t)p[0] << 24) | ((uint32_t)p[1] << 16)
         | ((uint32_t)p[2] << 8)  |  (uint32_t)p[3];
}

int main(void) {
    const unsigned char packet[4] = { 0x01, 0x02, 0x03, 0x04 };
    printf("%u\n", read_be32(packet));
    return 0;
}
--- options
67305985
* 16909060
1234
0
--- explain
The first byte is the most significant, so the value is `0x01020304`. In decimal that is `16909060`. Each byte is shifted into its place, and the shifts are on `uint32_t`, so the result is defined on every machine. The option `67305985` is what you would get by reading the same bytes in little-endian order, which is exactly the mistake this function avoids.
```

> **Pitfall:** Casting a pointer to a different type and reading through it breaks the strict aliasing rules, and the compiler may reorder your reads and writes. Code that does this often works in testing and fails after an optimization change. Use `memcpy`, or a union read through a character type.

## When unions are the right choice

Use a union when the variants are exclusive and the tag makes the choice explicit. Avoid unions as a way to reinterpret data: `memcpy` is clearer, portable and fast, because compilers reduce it to a single move. Keep the union inside a struct with its tag, and document which member is valid under each tag.

> **In the wild:** Binary formats such as image headers and network packets are often read with `memcpy` plus byte-order conversion, because the reading code must work on every machine. Tagged unions carry the variants of configuration files, interpreter values and AST nodes in compilers.

## Recap

- A union stores one of several members at the same address; its size is the largest member.
- Use a tag and a `switch` to make a union safe, and read only the member the tag names.
- Reading an inactive union member is undefined in strict C, so avoid it for type punning.
- Use `memcpy` to reinterpret bytes portably, and check size assumptions with `_Static_assert`.
- Convert byte order explicitly when reading external data; never rely on the machine's native order.

**Up next:** Advanced macros, X-macros for generating code from one list, and the discipline that keeps macro-heavy code readable.
