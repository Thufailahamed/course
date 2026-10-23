Numbers look simple until a computer stores them. An `int` has a fixed number of bits, so it cannot hold every whole number, and a `double` cannot hold every decimal exactly. Most numeric bugs in C come from forgetting one of those two facts. This lesson makes both facts concrete, so the surprises stop being surprises.

## Integers have a fixed range

A signed `int` on a typical system uses 32 bits. It can hold values from about −2 billion to +2 billion. An `unsigned int` uses the same bits to hold only non-negative values, which roughly doubles its positive range and changes how wraparound behaves.

Unsigned arithmetic wraps around. When a result is too big or too small for the type, it is reduced modulo 2ⁿ, where n is the number of bits. That behavior is guaranteed by the standard, so you can rely on it.

```c predict id=unsigned-wrap title="What does this print?"
#include <stdio.h>

int main(void) {
    unsigned int n = 0;
    n = n - 1;
    printf("%u\n", n);
    return 0;
}
--- options
* 4294967295
-1
0
1
--- explain
Subtracting 1 from the unsigned value 0 wraps around to the largest value the type can hold. On systems where `unsigned int` is 32 bits, that is 2³² − 1, which is 4294967295. Unsigned types never become negative. This is why you must be careful when you subtract unsigned values, such as sizes or counts, in loops.
```

The same modular rule applies to narrow types. A `char` or `unsigned char` assigned a value outside its range is reduced the same way.

```c predict id=unsigned-char title="What does this print?"
#include <stdio.h>

int main(void) {
    unsigned char b = 300;
    printf("%d\n", b);
    return 0;
}
--- options
* 44
300
0
255
--- explain
An `unsigned char` holds 8 bits, so it can represent 0 to 255. The value 300 wraps around to 300 − 256 = 44. Compilers often warn about this, and they are right to.
```

> **Pitfall:** Signed integer overflow is different. It is undefined behavior, so the compiler may assume it never happens. Never rely on a signed `int` wrapping around.

## Division truncates

When both operands are integers, `/` discards the fraction. The `%` operator returns the remainder. With negative numbers, C99 and later round the quotient toward zero, so the remainder takes the sign of the dividend.

```c predict id=negative-division title="What does this print?"
#include <stdio.h>

int main(void) {
    printf("%d %d\n", -7 / 2, -7 % 2);
    return 0;
}
--- options
* -3 -1
-4 1
-3 1
-4 -1
--- explain
Division truncates toward zero, so `-7 / 2` is `-3`, not `-4`. The remainder satisfies `(a / b) * b + a % b == a`, which gives `-7 % 2 == -1`. Most languages behave this way, but some use floor division, so check the rules before you compare code across languages.
```

## Floating-point numbers are approximations

A `double` stores a number as a binary fraction with about 15 to 17 significant decimal digits. Many decimal values, such as `0.1`, cannot be represented exactly in binary, so the stored value is the closest one the format allows. Arithmetic on those values can produce results that look wrong.

```c predict id=float-equal title="What does this print?"
#include <stdio.h>

int main(void) {
    double total = 0.1 + 0.2;
    printf("%s\n", total == 0.3 ? "equal" : "not equal");
    return 0;
}
--- options
* not equal
equal
0.3
0.30000000000000004
--- explain
Neither `0.1` nor `0.2` is exact in binary, so their sum is slightly larger than the closest double to `0.3`. The `==` test therefore fails. Never compare floating-point numbers with `==` directly. Compare the difference with a small tolerance, such as `fabs(a - b) < 1e-9`, using `<math.h>`.
```

> **Tip:** Use `double` for most decimal work. `float` has about seven significant digits, which runs out quickly.

## Converting between types

When you mix types in an expression, C converts the operands to a common type before it operates on them. An `int` mixed with a `double` becomes a `double`, which is why `total / count` gives a decimal result when `total` is a `double`. Converting in the other direction discards information, as lesson 03 showed.

To make the conversion explicit, use a cast:

```c
#include <stdio.h>

int main(void) {
    int total = 17;
    int count = 4;

    printf("integer: %d\n", total / count);             /* 4 */
    printf("decimal: %.2f\n", (double)total / count);   /* 4.25 */
    return 0;
}
```

The cast `(double)total` converts the value before the division, so the division happens in floating point. Casting after the division would be too late, because the fraction is already gone.

## Recap

- An `int` has a fixed range. Unsigned types wrap around, and signed overflow is undefined behavior.
- Integer division truncates toward zero, and `%` gives the remainder.
- A `double` stores approximations, so compare decimal results with a tolerance rather than `==`.
- Mixed-type arithmetic converts to a common type. Use an explicit cast when the conversion matters.

**Up next:** operators, precedence and the short-circuit rules that keep your conditions safe.
