Operators combine values into new values. You already use `+` and `=` without thinking. This lesson covers the rest of the everyday set, the precedence rules that decide what an expression means, and the short-circuit behavior that lets you write safe conditions.

## Arithmetic and assignment

The arithmetic operators are `+`, `-`, `*`, `/` and `%`. Compound assignment operators such as `+=` update a variable in place, so `total += 5` means `total = total + 5`.

```c
int score = 10;
score += 5;     /* 15 */
score *= 2;     /* 30 */
score -= 6;     /* 24 */
```

## Increment and decrement

`++` adds one and `--` subtracts one. Their position matters. Written before the variable, the operator changes the value first and then yields the new value. Written after, it yields the old value and then changes the variable.

```c predict id=pre-post title="What does this print?"
#include <stdio.h>

int main(void) {
    int i = 5;
    int a = i++;
    int b = ++i;
    printf("%d %d %d\n", a, b, i);
    return 0;
}
--- options
* 5 7 7
5 6 7
6 7 7
5 6 6
--- explain
`i++` yields 5 and then makes `i` equal to 6, so `a` is 5. `++i` makes `i` equal to 7 first and yields 7, so `b` is 7. Both statements are simple enough to read clearly. Put increments in their own statements unless the combined form is clearly easier to read.
```

> **Pitfall:** Never change the same variable twice in one expression, such as `i = i++ + i`. The result is undefined behavior, because the order of those changes is not fixed.

## Comparison and logic

The comparison operators are `==`, `!=`, `<`, `<=`, `>` and `>=`. Each yields `1` for true or `0` for false. The logical operators `&&` (and), `||` (or) and `!` (not) combine those results.

> **Pitfall:** `=` assigns and `==` compares. `if (x = 0)` compiles, because assignment is an expression, and it quietly assigns zero. You will see that bug in lesson 07.

## Precedence

Operators have precedence, which decides the order in which they are applied. Multiplication binds tighter than addition, and most operators are applied left to right. When you are unsure, add parentheses. They cost nothing and make intent obvious.

```c predict id=precedence title="What does this print?"
#include <stdio.h>

int main(void) {
    int r = 2 + 3 * 4 - 6 / 2;
    printf("%d\n", r);
    return 0;
}
--- options
* 11
20
9
8
--- explain
Multiplication and division happen first: `3 * 4` is 12 and `6 / 2` is 3. Then addition and subtraction run from left to right: `2 + 12 - 3` is 11. Reading the expression as `((2 + (3 * 4)) - (6 / 2))` shows the same order. Parentheses are a tool for clarity, not a sign of weakness.
```

## Short-circuit evaluation

`&&` and `||` evaluate their right side only when the left side does not already decide the answer. That behavior is called short-circuiting, and you can use it to avoid errors. In `a && b`, if `a` is false, `b` never runs. In `a || b`, if `a` is true, `b` never runs.

```c predict id=short-circuit title="What does this print?"
#include <stdio.h>

int main(void) {
    int x = 0;
    if (x != 0 && 10 / x > 1) {
        printf("big\n");
    } else {
        printf("small\n");
    }
    return 0;
}
--- options
* small
big
The program crashes on division by zero
big small
--- explain
Because `x != 0` is false, the `&&` already has its answer and never evaluates `10 / x`. The division by zero is never attempted, so the program takes the `else` branch and prints `small`. Put the cheap or safe check first, and let the risky check run only when it is needed.
```

> **In the wild:** Null-pointer checks depend on this rule. Writing `if (p != NULL && p->value > 0)` is safe, because the dereference runs only when `p` is not null.

## The conditional operator

The conditional operator `? :` picks one of two values. It is a compact `if`/`else` for expressions:

```c
int n = -4;
const char *sign = n >= 0 ? "non-negative" : "negative";
```

Use it for short, simple choices. If the choice needs a statement, use `if` instead.

## Recap

- Compound assignments such as `+=` update a variable in place.
- `i++` yields the old value, and `++i` yields the new one. Keep changes in separate statements.
- `=` assigns and `==` compares. Mixing them up is a classic bug.
- Precedence decides the order of operations. Add parentheses when you are unsure.
- `&&` and `||` short-circuit, so put the safe check first.

**Up next:** formatted output and safe input, the two ways your program talks to people.
