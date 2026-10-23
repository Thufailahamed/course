Structs describe the shape of data. Three more tools round out the picture. An **enum** gives names to a fixed set of integer values, so your code says `STATUS_ACTIVE` instead of `2`. A **typedef** gives a type a shorter name. A **union** stores one of several possible types in the same memory, which is useful when a value can take one of several forms. Each is small on its own, and together they make your code read like the problem it solves.

## enum: named integer constants

An enum lists names for integer values. The first name is 0 unless you say otherwise, and each following name is one more than the one before it.

```c
#include <stdio.h>

enum status { PENDING, ACTIVE, CLOSED };

int main(void) {
    enum status s = ACTIVE;

    if (s == ACTIVE) {
        printf("account is active (%d)\n", s);
    }
    return 0;
}
```

Enums make `switch` statements and comparisons self-explanatory, and they cost nothing at runtime. They are integers under the hood, so they also work with arithmetic, which is occasionally useful and occasionally a trap.

```c predict id=enum-values title="What does this print?"
#include <stdio.h>

enum level { LOW, MEDIUM = 5, HIGH };

int main(void) {
    printf("%d %d %d\n", LOW, MEDIUM, HIGH);
    return 0;
}
--- options
* 0 5 6
0 1 2
0 5 5
1 5 6
--- explain
`LOW` starts at 0. `MEDIUM` is set explicitly to 5. `HIGH` has no explicit value, so it is one more than the value before it, giving 6. Once you assign a value, the names after it count from there. Mixing explicit and automatic values this way is legal, but keep it simple in production code.
```

## typedef: naming a type

`typedef` gives an existing type a new name. The most common use in C is to hide the `struct` keyword, so that a type reads like a built-in.

```c predict id=typedef title="What does this print?"
#include <stdio.h>

typedef struct { int hours; } Shift;

int main(void) {
    Shift s = {8};
    Shift t = s;
    t.hours *= 2;
    printf("%d %d\n", s.hours, t.hours);
    return 0;
}
--- options
* 8 16
16 16
8 8
16 8
--- explain
`Shift` is an alias for an anonymous struct. `t = s` copies the struct, so `t` is independent of `s`. Doubling `t.hours` changes only the copy, which leaves `s.hours` at 8. The typedef changes the name, not the behavior: a `Shift` is exactly the same type as the struct it names.
```

> **Tip:** Use `typedef` to make the name of a type clear, not to hide what it is. `typedef struct point Point;` is helpful. Hiding pointers behind typedefs makes code harder to read, so avoid it.

## union: one memory, several views

A union has several members, but only one of them holds a value at a time. All the members share the same memory, and the union is as large as its largest member.

```c predict id=union-size title="Does this print yes or no?"
#include <stdio.h>

union number {
    char c;
    double d;
};

int main(void) {
    printf("%s\n", sizeof(union number) >= sizeof(double) ? "yes" : "no");
    return 0;
}
--- options
* yes
no
It depends on the compiler
It does not compile
--- explain
A union must be large enough to hold its largest member. Since `double` is bigger than `char`, the union is at least as large as a `double`, and the comparison is true. The question is about size, which the standard guarantees, rather than what the bytes contain, which depends on the platform.
```

Unions are useful when a single value can take one of several shapes, such as a token that is either a number or a name. They are also the place where reading an inactive member becomes undefined behavior, so you should always know which member is active. The advanced course returns to this with tagged unions and type punning.

## Putting the three together

Here is a small model that uses all three tools. An enum names the kind, a union holds the value, and a typedef keeps the code tidy:

```c
#include <stdio.h>

typedef enum { INT_VALUE, TEXT_VALUE } Kind;

typedef struct {
    Kind kind;
    union {
        int number;
        const char *text;
    } as;
} Value;

int main(void) {
    Value a = { INT_VALUE, { .number = 42 } };
    Value b = { TEXT_VALUE, { .text = "hello" } };

    if (a.kind == INT_VALUE) printf("%d\n", a.as.number);
    if (b.kind == TEXT_VALUE) printf("%s\n", b.as.text);
    return 0;
}
```

The `kind` field records which member of the union is valid. This pattern, called a tagged union, is how many C libraries represent values of several types.

## Recap

- An enum names a set of integer constants. Values count up from 0 unless you assign them.
- A typedef gives a type a new name. It changes the name, not the type.
- A union stores one value at a time in shared memory, sized to its largest member.
- Use a tag, such as an enum, to record which union member is active.

**Up next:** the preprocessor, which runs before the compiler and handles `#include`, `#define` and macros.
