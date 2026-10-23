Computers store everything as bits, and C is one of the few high-level languages that lets you work with those bits directly. Bit operations are how you pack several true-or-false settings into one byte, how you test a hardware register, how network protocols read their headers and how fast algorithms count and compare sets of values. They are also a common source of subtle bugs, because the rules about shifting and sign are full of traps.

This lesson covers the bitwise operators, the masks that make them useful, the shifts and their limits, and the idioms that appear in real systems code. It uses unsigned types throughout, because their behavior is fully defined, and it shows you why.

## The operators

| Operator | Name | Meaning on each bit |
|---|---|---|
| `&` | AND | 1 only if both bits are 1 |
| `\|` | OR | 1 if either bit is 1 |
| `^` | XOR | 1 if the bits differ |
| `~` | NOT | flips every bit |
| `<<` | left shift | moves bits left, filling with zeros |
| `>>` | right shift | moves bits right |

Use unsigned types for bit work. An `unsigned int` has a fixed width and well-defined results for every operator. Signed types add questions about the sign bit, shifts that overflow and implementation-defined right shifts, which you should avoid for bit-level code.

## Masks: testing, setting and clearing

A **mask** is a value whose bits select the positions you care about. You combine a value with a mask using AND, OR or XOR to test, set or toggle those positions:

```c
#define FLAG_READ   (1u << 0)   /* 0b0001 */
#define FLAG_WRITE  (1u << 1)   /* 0b0010 */
#define FLAG_EXEC   (1u << 2)   /* 0b0100 */

unsigned int perms = FLAG_READ | FLAG_WRITE;   /* set two flags */

if (perms & FLAG_WRITE) { /* test: the write bit is on */ }
perms &= ~FLAG_WRITE;     /* clear: turn the write bit off */
perms ^= FLAG_EXEC;       /* toggle: flip the exec bit */
```

The idiom to memorize is `value &= ~mask` to clear, and `value |= mask` to set. The `~` turns the mask inverse, so AND with it keeps every other bit.

The predict question below uses a mask to test one bit:

```c predict id=mask-test title="What is printed?"
#include <stdio.h>

int main(void) {
    unsigned int flags = 0x0A;
    printf("%u\n", flags & 0x02);
    return 0;
}
--- options
0
* 2
8
10
--- explain
`0x0A` is binary `1010`, and `0x02` is binary `0010`. ANDing them keeps only the bit in position 1, which is set in both, so the result is `0010`, which is `2`. The other bits are masked out. A result of `0` would mean the tested bit was off.

## Shifts

Left shift multiplies by a power of two, and right shift divides by one for unsigned values. Shifts are also how you build masks: `1u << n` is a value with only bit `n` set. Shifting is a common way to extract a field from a packed value:

```c
unsigned int color = 0x00AABBCC;
unsigned int red   = (color >> 16) & 0xFF;   /* 0xAA */
unsigned int green = (color >> 8)  & 0xFF;   /* 0xBB */
unsigned int blue  =  color        & 0xFF;   /* 0xCC */
```

The `& 0xFF` after each shift is essential. It removes the bits from the higher fields that shifted down into the low byte.

> **Pitfall:** Shifting by a negative amount or by at least the width of the type is undefined behavior, and so is shifting a negative signed value left. Keep shift counts between 0 and one less than the bit width, and use unsigned operands. Writing `1 << 31` with plain `int` is a classic trap, because `1` is an `int` there; write `1u << 31` instead.

Operator precedence is the other trap. `<<` binds more tightly than `&` and `|`, but `==` binds more tightly than `&`. That is why `flags & MASK == 0` does not do what it looks like: the comparison happens first, so the code tests `flags & (MASK == 0)`. Parenthesize every bit expression. The predict question checks precedence explicitly:

```c predict id=shift-precedence title="What is printed?"
#include <stdio.h>

int main(void) {
    printf("%u\n", 1u << 4 | 1u);
    return 0;
}
--- options
* 17
16
5
32
--- explain
Shift binds more tightly than bitwise OR, so `1u << 4` is evaluated first, which is `16`. Then `16 | 1` sets the lowest bit, giving `17`. The result is `17`, which is binary `10001`. Writing `1u << (4 | 1)` would mean something else entirely, which is why parentheses are worth the extra characters.

## Counting and testing with tricks

Some bit tricks are short enough to learn by heart, and they show up in every low-level codebase:

```c
/* Is x a power of two? (zero is excluded) */
int is_pow2(unsigned int x) {
    return x != 0 && (x & (x - 1)) == 0;
}

/* Clear the lowest set bit. */
x &= x - 1;

/* Isolate the lowest set bit. Negation of an unsigned value is defined (it wraps). */
lowest = x & (0u - x);
```

`x & (x - 1)` removes the lowest set bit, because subtracting one flips it and every bit below it. If that leaves zero, `x` had exactly one bit set.

The last predict question uses clearing with a mask and NOT:

```c predict id=clear-bits title="What is printed?"
#include <stdio.h>

int main(void) {
    unsigned int v = 0x0F;
    v &= ~0x03u;
    printf("%u\n", v);
    return 0;
}
--- options
15
* 12
3
0
--- explain
`~0x03u` has every bit set except bits 0 and 1. Applied to `0x0F`, which is `1111`, the AND keeps the top two bits and clears the bottom two, leaving `1100`. That is `12`. The `u` suffix keeps the whole expression unsigned, so no sign question arises.
```

## Bit fields and packing

Bit fields in a struct describe several small integers within one storage unit. They are convenient and readable, but their layout is implementation-defined: the order of fields within a unit and whether they can straddle a boundary vary between compilers. Use bit fields when you control both ends of the data, such as an internal structure, and use explicit masks and shifts for anything that crosses a network or a file. You will meet this distinction again in lesson 14 on struct layout.

> **In the wild:** Network protocols such as IPv4 pack version, header length, flags and fragment offsets into fixed-width fields. Parsers read them with shifts and masks, and getting one bit wrong breaks every packet that follows.

## Recap

- Use unsigned types for bit work, and build masks with `1u << n`.
- Set with `|=`, clear with `&= ~mask`, toggle with `^=`, test with `&`.
- Shift counts must be between 0 and one less than the width; avoid shifting signed values.
- Parenthesize bit expressions, because precedence differs from what it looks like.
- Learn `x & (x - 1)` for power-of-two checks and for clearing the lowest bit.

**Up next:** Struct layout, padding and alignment, and why `sizeof` on a struct can be larger than the sum of its fields.
