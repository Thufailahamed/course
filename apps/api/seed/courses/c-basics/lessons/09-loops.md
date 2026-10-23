Computers are good at repetition, and loops are how you ask for it. C has three loop forms. The `while` loop repeats while a condition is true, the `do`-`while` loop always runs its body at least once, and the `for` loop packs the start, the test and the step into one line. Most of the time you will reach for `for`, but understanding all three makes the choice obvious.

## while

A `while` loop checks its condition before every pass. If the condition is false from the start, the body never runs.

```c
#include <stdio.h>

int main(void) {
    int n = 3;
    while (n > 0) {
        printf("%d\n", n);
        n--;
    }
    printf("Liftoff!\n");
    return 0;
}
```

Every `while` loop needs a way to end. Forgetting to change the variable in the condition gives you an infinite loop, which hangs the program until you stop it.

```c predict id=while-countdown title="What does this print?"
#include <stdio.h>

int main(void) {
    int n = 3;
    while (n > 0) {
        printf("%d", n);
        n--;
    }
    printf("\n");
    return 0;
}
--- options
* 321
123
3210
21
--- explain
The loop prints `3`, then `2`, then `1`. When `n` becomes 0 the condition `n > 0` is false, so the loop stops before printing 0. The `printf` with `\n` then ends the line. Counting down to but not including the stop value is the most common loop shape.
```

## do-while

A `do`-`while` loop checks its condition after the body, so the body always runs at least once. Use it when you must do something before you can decide whether to repeat, such as asking for input until it is valid.

```c predict id=do-while-once title="What does this print?"
#include <stdio.h>

int main(void) {
    int n = 10;
    do {
        printf("%d ", n);
        n++;
    } while (n < 5);
    printf("end\n");
    return 0;
}
--- options
* 10 end
end
10 11 end
nothing
--- explain
The body runs first and prints `10`, then `n` becomes 11. The condition `n < 5` is false, so the loop ends. The body ran once even though the condition was false from the start. That single guaranteed pass is the whole point of `do`-`while`.
```

## for

A `for` loop has three parts separated by semicolons: an initialization, a condition and an update. Each part has a clear job, which is why `for` is the default choice for counting.

```c predict id=for-count title="What does this print?"
#include <stdio.h>

int main(void) {
    int total = 0;
    for (int i = 1; i <= 4; i++) {
        total += i;
    }
    printf("%d\n", total);
    return 0;
}
--- options
* 10
4
11
9
--- explain
The loop variable `i` starts at 1 and runs while `i <= 4`, so it takes the values 1, 2, 3 and 4. The total is 1 + 2 + 3 + 4, which is 10. Declaring `i` inside the `for` limits its scope to the loop, which is a good habit.
```

> **Tip:** Use `i <= n` or `i < n` deliberately. For a zero-based array of length `n`, the valid indexes are `0` to `n - 1`, so the condition is `i < n`.

## Choosing a loop

- Use `for` when you know the count or range in advance.
- Use `while` when you are waiting for a condition to change, such as reading input until a sentinel value arrives.
- Use `do`-`while` when the body must run at least once.

## Common mistakes

Two bugs account for most loop trouble. The first is the off-by-one error, where the condition stops one step too early or too late. The second is a missing update, which leaves the loop running forever. When a loop misbehaves, print the loop variable each time through the body. Watching the values will usually show you the bug in seconds.

## Recap

- `while` checks before each pass. `do`-`while` checks after, so its body runs at least once.
- `for` packs initialization, condition and update into one readable line.
- Declare the loop variable in the `for` so its scope stays small.
- Use `i < n` for zero-based indexes, and watch for off-by-one errors.
- Make sure every loop changes something that eventually ends it.

**Up next:** `break`, `continue` and nested loops, which let you change how a loop runs.
