A program that cannot show results or accept input is not much of a program. In C, `printf` handles output and `scanf` handles input. Both are powerful, and both have sharp edges. This lesson shows you how to format output precisely, and how to read input without the classic traps.

## Formatting output

`printf` takes a format string and then the values to insert. Between the `%` and the letter you can add modifiers that control width, alignment and precision.

| Pattern | Meaning |
|---|---|
| `%5d` | right-align an integer in 5 columns |
| `%-5d` | left-align an integer in 5 columns |
| `%.2f` | show a `double` with two digits after the point |
| `%05d` | pad an integer with leading zeros to 5 digits |
| `%x` / `%o` | print an integer in hexadecimal or octal |

Width and alignment are how you print tidy tables, which is useful in almost every program you write.

```c predict id=format-width title="What does this print?"
#include <stdio.h>

int main(void) {
    printf("[%5d]|[%-5d]\n", 42, 42);
    return 0;
}
--- options
* [   42]|[42   ]
[42   ]|[   42]
[42]|[42]
[   42]|[   42]
--- explain
The first field is right-aligned in a width of 5, so it gets three leading spaces. The second is left-aligned, so it gets three trailing spaces. The `|` characters are ordinary text and print as they are.
```

Precision works on floating-point values:

```c predict id=precision title="What does this print?"
#include <stdio.h>

int main(void) {
    printf("%.2f\n", 2.0 / 3.0);
    return 0;
}
--- options
* 0.67
0.66
0.6667
0.7
--- explain
`2.0 / 3.0` is about 0.666666…. The `%.2f` specifier rounds to two decimal places, giving `0.67`. Rounding is applied to the displayed value, not to the stored one, and the stored value is unchanged.
```

Bases matter too. Hexadecimal is common when you look at memory, and the `%x` and `%o` specifiers print integers in those bases:

```c predict id=bases title="What does this print?"
#include <stdio.h>

int main(void) {
    printf("%x %o\n", 255, 8);
    return 0;
}
--- options
* ff 10
FF 8
255 8
ff 8
--- explain
255 is `ff` in hexadecimal, because 15 × 16 + 15 = 255. The number 8 is `10` in octal, because 1 × 8 + 0 = 8. The `%X` specifier, with a capital letter, prints uppercase digits instead.
```

> **Tip:** Make `printf` the place where formatting happens. Keep the numbers themselves as numbers until you print them, so you never lose precision by formatting too early.

## Reading input with scanf

`scanf` reads values from standard input, which is usually the keyboard. Every variable you give it must be passed by address, using `&`. Lesson 15 explains why, and for now it is enough to remember the rule.

```c
#include <stdio.h>

int main(void) {
    int age = 0;
    printf("How old are you? ");
    if (scanf("%d", &age) != 1) {
        printf("That was not a number.\n");
        return 1;
    }
    printf("In ten years you will be %d.\n", age + 10);
    return 0;
}
```

Notice the check on the return value. `scanf` returns the number of items it successfully read. If the user types `forty`, it returns `0` and leaves `age` alone. Ignoring that return value is how programs go wrong on bad input.

> **Pitfall:** `scanf("%s", buffer)` reads without any length limit, so a long input can overflow `buffer`. Prefer `fgets`, which takes a size, and parse the line yourself. You will use `fgets` in lesson 21.

> **Pitfall:** After `scanf("%d")`, the newline the user typed stays in the input. A later `%c` or `fgets` can read that newline immediately. Read whole lines with `fgets` when a program mixes the two.

## A small formatted report

Here is a complete program that uses width and precision together:

```c
#include <stdio.h>

int main(void) {
    const char *names[] = {"Ada", "Linus", "Grace"};
    double scores[] = {91.5, 78.25, 88.0};

    printf("%-8s|%8s\n", "Name", "Score");
    for (int i = 0; i < 3; i++) {
        printf("%-8s|%8.2f\n", names[i], scores[i]);
    }
    return 0;
}
```

The output lines up in columns no matter how long each name is, because the widths are fixed.

## Recap

- `printf` prints exactly what you ask for. Width, alignment and precision are part of the format string.
- `%x` and `%o` print integers in hexadecimal and octal.
- `scanf` needs addresses (`&`) and returns how many values it read. Check that return value.
- Avoid unbounded `%s` reads. Prefer `fgets` with a size limit.

**Up next:** making decisions with `if`, `else` and the ternary operator.
