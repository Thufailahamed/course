When one value can match many fixed options, a long `if`/`else` chain gets tiring to read. The `switch` statement compares one integer expression against a list of constant `case` labels and jumps straight to the match. It is tidy and fast, and it has one behavior you must understand before you use it: once a case matches, execution keeps going into the next case unless you stop it.

## The basic shape

```c
#include <stdio.h>

int main(void) {
    char grade = 'B';

    switch (grade) {
        case 'A':
            printf("Excellent\n");
            break;
        case 'B':
            printf("Good\n");
            break;
        case 'C':
            printf("Satisfactory\n");
            break;
        default:
            printf("Needs review\n");
    }
    return 0;
}
```

The value in `switch (...)` is compared with each `case` label. Labels must be constant expressions known at compile time, such as literal numbers or characters. The `default` label runs when nothing else matches, and it is optional, although including it is a good habit.

## The fallthrough trap

Here is the important rule. Without a `break`, execution continues into the next `case`. Fallthrough is occasionally useful, but most of the time it is a bug.

```c predict id=switch-fallthrough title="What does this print?"
#include <stdio.h>

int main(void) {
    int day = 2;
    switch (day) {
        case 1:
            printf("one ");
        case 2:
            printf("two ");
        case 3:
            printf("three ");
            break;
        default:
            printf("other ");
    }
    printf("\n");
    return 0;
}
--- options
* two three
two
one two three
other
--- explain
`day` is 2, so execution starts at `case 2` and prints `two`. There is no `break` there, so it falls through to `case 3`, which prints `three` and then reaches a `break`. The `default` never runs. The line therefore reads `two three`, followed by a space and the newline from the last `printf`.
```

> **Pitfall:** Forgetting `break` is one of the most common C bugs. If you intend fallthrough, add a comment such as `/* falls through */` so the next reader knows it is deliberate. Compilers with `-Wextra` can warn about accidental fallthrough.

## Grouping cases on purpose

Deliberate fallthrough is the clean way to give several values the same behavior. Stack the labels with no code between them:

```c predict id=switch-grouping title="What does this print?"
#include <stdio.h>

int main(void) {
    int code = 4;
    switch (code) {
        case 1:
        case 2:
            puts("low");
            break;
        case 3:
        case 4:
        case 5:
            puts("mid");
            break;
        default:
            puts("high");
    }
    return 0;
}
--- options
* mid
low
high
mid low
--- explain
Labels with no statements between them all lead to the same code. `code` is 4, which matches the group `3, 4, 5`, so `puts` prints `mid` and the `break` leaves the switch. `puts` is a simpler way than `printf` to print a string followed by a newline.
```

## The default that ran

A `default` label is the catch-all, and it is a good place to handle unexpected input rather than silently ignoring it.

```c predict id=switch-default title="What does this print?"
#include <stdio.h>

int main(void) {
    char grade = 'z';
    switch (grade) {
        case 'A':
            printf("excellent\n");
            break;
        default:
            printf("unknown\n");
    }
    return 0;
}
--- options
* unknown
excellent
(nothing)
z
--- explain
No `case` label matches `'z'`, so control jumps to `default`, which prints `unknown`. The last `break` is optional here, because `default` is the final label. Adding it anyway protects you if someone later adds a case below it.
```

## Limits of switch

`switch` works only with integer types, including `char` and enumerated values, and only with constant case labels. It cannot compare strings or ranges. For a string, use `strcmp` and an `if` chain. For a range, use `if` with comparisons.

## Recap

- `switch` compares one integer value with constant `case` labels.
- Execution falls through to the next case unless a `break` stops it.
- Stacking labels with no code between them groups cases on purpose.
- Use `default` to handle values nothing else matched.
- `switch` cannot compare strings or ranges.

**Up next:** loops, which repeat a block while a condition holds.
