Most languages try to protect you from your own mistakes. C does something different. For many kinds of mistakes, the standard says nothing at all. The official term is **undefined behavior** (UB), and it means that the language gives no rules for what happens next. The program might crash, print garbage, work perfectly, or behave correctly today and fail next Tuesday after an upgrade.

This is not a flaw that careful programmers can avoid by luck. It is the price of C's speed. The compiler is allowed to assume that your program never triggers undefined behavior, and it uses that assumption aggressively to optimize. Once UB happens, the compiler's reasoning can take the program in directions you never wrote.

This lesson explains what UB is, why it causes such strange bugs, and the rules you must follow to avoid it. The predict questions here use only defined behavior, because you should be able to reason about those precisely first.

## Undefined, unspecified and implementation-defined

The standard uses three related terms, and they mean different things:

| Term | Meaning | Example |
|---|---|---|
| **Undefined behavior** | No requirement at all. Anything can happen. | Reading past the end of an array |
| **Unspecified behavior** | The standard allows several choices, and the program is still valid. | The order in which `f(a(), b())` calls `a` and `b` |
| **Implementation-defined behavior** | The compiler chooses, and must document the choice. | The size of `int`, or whether `char` is signed |

Undefined behavior is the most dangerous, because a compiler does not need to report it. It can silently produce code that does something you did not intend.

## Classic sources of UB

Here are the mistakes that appear most often in real C code:

```c
int a[4];
a[4] = 1;            // out-of-bounds write: undefined

int *p = NULL;
*p = 5;              // dereferencing a null pointer: undefined

int x;
printf("%d\n", x);   // reading an uninitialized variable: undefined

int big = 2147483647;
big = big + 1;       // signed integer overflow: undefined

free(q);
free(q);             // double free: undefined
```

Each line looks harmless. Each one breaks a rule the compiler relies on, and the damage can appear far away from the line that caused it.

> **Pitfall:** Compilers can remove code based on UB. A common example is `if (p + len < p)` used to detect pointer overflow. Because pointer overflow is undefined, the compiler may decide the condition is always false and delete the check. Write checks that are valid in the language, such as comparing `len` with the remaining space.

## Unsigned integers wrap, signed integers do not

This is one of the rules that surprises people most. Unsigned arithmetic is **defined** to wrap around modulo 2 to the power of the width. Signed overflow is undefined. The predict question below uses the defined case:

```c predict id=unsigned-wrap title="What is printed after the increment?"
#include <stdio.h>

int main(void) {
    unsigned char c = 255;
    c++;
    printf("%d\n", c);
    return 0;
}
--- options
256
* 0
255
-1
--- explain
An `unsigned char` holds values from 0 to 255. Incrementing 255 wraps it around to 0, because unsigned arithmetic is defined modulo 256. The output is `0`. A signed overflow with the same numbers would be undefined behavior, which is why you should use unsigned types for values that are meant to wrap, such as hash values and bit masks.
```

## Sequence points: when side effects happen

A **side effect** is a change to a variable, such as `i++` or `x = 5`. C says that every side effect must be complete before the next **sequence point**, which includes the end of a full expression and the call to a function. Modifying the same object twice between sequence points is undefined. `i = i++ + 1;` is an example.

Expressions that read and modify the same variable only once are fine, and the next predict question shows one:

```c predict id=sequence title="What is printed?"
#include <stdio.h>

int main(void) {
    int i = 1;
    int j = i++ + 1;
    printf("%d %d\n", i, j);
    return 0;
}
--- options
1 2
* 2 2
2 3
1 1
--- explain
In `i++ + 1`, the value `1` is read from `i`, and `i` is incremented once. The sum is `1 + 1 = 2`, so `j` becomes `2`. After the statement, `i` is `2`. The variable is modified exactly once in the statement, so the behavior is defined.
```

> **Tip:** Split an expression when you are not sure. `int j = i; i++; j += 1;` is longer, but it cannot be misread. Clarity is worth more than cleverness when the cost of a bug is high.

## Integer division and truncation

Division of integers in C truncates toward zero. It is defined, and it still catches people who expect decimals:

```c predict id=division title="What does this print?"
#include <stdio.h>

int main(void) {
    printf("%d\n", 7 / 2 * 2);
    return 0;
}
--- options
7
* 6
8
3
--- explain
`7 / 2` is evaluated first, because `/` and `*` have the same precedence and associate left to right. Integer division gives `3`, and `3 * 2` is `6`. The original value `7` is lost. Use `7.0 / 2` when you need a fraction.
```

## Writing safe code

You cannot memorize every case, so build habits that keep you away from UB:

- **Check every index and length** before you use it. Keep the length next to the pointer.
- **Initialize every variable** when you declare it.
- **Check the result of every allocation** and every library call that can fail.
- **Use unsigned types** when wraparound is the intent, and check ranges before signed arithmetic.
- **Compile with sanitizers during testing**, which catch many UB cases at run time (you will meet them in lesson 19).

> **In the wild:** Operating systems, browsers and crypto libraries have all shipped security bugs caused by compilers removing checks that depended on UB. The fix was almost always a rewrite of the check to use only defined operations.

## Recap

- Undefined behavior means the standard imposes no rules, and the compiler may assume it never happens.
- Unspecified and implementation-defined behavior are valid but vary; the standard or the compiler documents them.
- Unsigned arithmetic wraps; signed overflow is undefined.
- Never modify an object twice between sequence points.
- Initialize variables, check bounds, check allocations, and test with sanitizers.

**Up next:** `const` and the pointer qualifiers, which let you tell the compiler and your colleagues what a function is allowed to change.
