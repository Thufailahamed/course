Programs become useful when they can choose. An `if` statement runs a block of code only when a condition is true, and `else` gives an alternative. Together they let one program behave differently for different inputs. This lesson covers the rules for conditions, the dangers that catch beginners, and the ternary operator for short choices.

## if and else

A condition is any expression. C treats `0` as false and any non-zero value as true, so there is no separate boolean type you must use, although `<stdbool.h>` provides `bool` if you prefer it.

```c
#include <stdio.h>

int main(void) {
    int temperature = 31;

    if (temperature > 30) {
        printf("Stay hydrated.\n");
    } else if (temperature < 10) {
        printf("Bring a jacket.\n");
    } else {
        printf("Enjoy the weather.\n");
    }
    return 0;
}
```

The `else if` chain checks conditions in order and runs the first block whose condition is true. Order matters: put the most specific checks first, and make sure the conditions do not overlap in a way that hides a case.

> **Tip:** Always use braces, even for a one-line body. Braces make the scope of the `if` obvious, and they stop a later edit from accidentally changing what runs.

## The dangling else

Without braces, an `else` attaches to the nearest `if`. That rule causes a famous bug, and it is worth seeing once.

```c predict id=dangling-else title="What does this print?"
#include <stdio.h>

int main(void) {
    int a = 1;
    int b = 0;
    if (a)
        if (b)
            printf("A");
        else
            printf("B");
    printf("C\n");
    return 0;
}
--- options
* BC
ABC
C
B
--- explain
The `else` belongs to the inner `if (b)`, not the outer `if (a)`, because it is the nearest one. Since `b` is 0, the `else` branch prints `B`. The outer `if` has no `else`, and the final `printf` prints `C` on the same line. Indentation does not change the meaning, which is exactly why you should use braces.
```

## Assignment in a condition

Assignment is an expression in C, and its value is the value assigned. That makes `=` in place of `==` a silent bug, because the code still compiles.

```c predict id=assign-in-if title="What does this print?"
#include <stdio.h>

int main(void) {
    int x = 5;
    if (x = 0)
        printf("yes\n");
    else
        printf("no %d\n", x);
    return 0;
}
--- options
* no 0
no 5
yes
yes 0
--- explain
`x = 0` stores 0 in `x`, and the value of that assignment is 0, which is false. So the `else` branch runs, and it prints the new value of `x`, which is 0. Most compilers warn about this when you enable `-Wall`, so read the warnings. Some programmers write `if (0 == x)` so that a missing `=` becomes a compile error.
```

## Nested conditions and clarity

Nested `if` statements are sometimes necessary, but deep nesting is hard to read. Two habits help. Return early from functions when a precondition fails, which keeps the main path flat. Give conditions names when they are complicated:

```c
int is_passing = score >= 50;
int has_attendance = attended >= 8;

if (is_passing && has_attendance) {
    printf("Certificate earned.\n");
}
```

## The ternary operator

The conditional operator `? :` chooses between two values. It works inside expressions, so you can use it where a full `if` would be clumsy.

```c predict id=ternary title="What does this print?"
#include <stdio.h>

int main(void) {
    int n = -4;
    printf("%s\n", n >= 0 ? "non-negative" : "negative");
    return 0;
}
--- options
* negative
non-negative
-4
zero
--- explain
The condition `n >= 0` is false, so the operator yields its second operand, `"negative"`. The ternary is an expression that yields one of two values, which is why it fits inside a `printf` call. Keep ternaries short. If one needs a comment to explain it, use an `if` statement instead.
```

## Checking your logic

A common pattern is to test a range. Write the two comparisons with `&&` so both must hold:

```c
int percent = 72;
if (percent >= 70 && percent < 80) {
    printf("Grade: C\n");
}
```

Checking the boundaries deliberately, such as 69, 70 and 79, catches most off-by-one mistakes before they reach users.

## Recap

- `if`, `else if` and `else` run exactly one branch. Order the checks from most specific to least.
- Zero is false and any other value is true.
- Always use braces, so `else` never attaches to the wrong `if`.
- `=` assigns and returns the assigned value. Check conditions for `=` where you meant `==`.
- The ternary `? :` yields one of two values and is ideal for short choices.

**Up next:** `switch`, which chooses among many fixed values, and the fallthrough behavior that trips up almost every beginner.
