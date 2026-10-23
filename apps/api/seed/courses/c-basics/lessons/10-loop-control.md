Sometimes a loop should stop early, skip one pass, or sit inside another loop. The `break` and `continue` statements give you that control, and nested loops let you work with two dimensions, such as rows and columns. Used carefully, they make loops clearer. Used carelessly, they make them very hard to follow.

## break

`break` leaves the innermost loop or `switch` immediately. Execution continues with the statement after the loop.

```c
#include <stdio.h>

int main(void) {
    int numbers[] = {4, 9, 16, 25, 36};
    int target = 16;
    int found_at = -1;

    for (int i = 0; i < 5; i++) {
        if (numbers[i] == target) {
            found_at = i;
            break;
        }
    }
    printf("found at index %d\n", found_at);
    return 0;
}
```

This is a linear search. The `break` stops the loop as soon as the answer is known, so the rest of the array is never examined.

## continue

`continue` skips the rest of the current pass and moves to the next one. In a `for` loop, the update still runs before the next test.

```c predict id=continue-skip title="What does this print?"
#include <stdio.h>

int main(void) {
    for (int i = 0; i < 6; i++) {
        if (i % 2 == 0) continue;
        printf("%d", i);
    }
    printf("\n");
    return 0;
}
--- options
* 135
024
12345
246
--- explain
When `i` is even, `i % 2 == 0` is true, so `continue` skips the `printf` and the loop moves on. Only the odd values 1, 3 and 5 reach the `printf`. The output is `135` followed by a newline.
```

> **Tip:** `continue` works well as a guard at the top of a loop body, which keeps the main logic unindented. Use it to reject cases you do not care about.

## Nested loops

A loop inside another loop runs the inner loop completely for each pass of the outer one. That is how you walk a grid, compare every pair of items, or print a table.

```c
#include <stdio.h>

int main(void) {
    for (int row = 1; row <= 3; row++) {
        for (int col = 1; col <= 3; col++) {
            printf("%3d", row * col);
        }
        printf("\n");
    }
    return 0;
}
```

The inner loop finishes all its columns before the outer loop moves to the next row. Printing the result shows a 3 by 3 multiplication table.

## break only leaves one loop

This is the subtle point. A `break` inside an inner loop stops only that inner loop, and the outer loop carries on.

```c predict id=nested-break title="What does this print?"
#include <stdio.h>

int main(void) {
    int count = 0;
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            if (j == 1) break;
            count++;
        }
    }
    printf("%d\n", count);
    return 0;
}
--- options
* 3
6
1
9
--- explain
For each of the three values of `i`, the inner loop counts `j = 0` and then breaks when `j` reaches 1. That is one count per outer pass, so the total is 3. The `break` never stops the outer loop. If you need to leave both loops, use a flag, or move the loops into a function and `return`.
```

## After the loop

The loop variable declared in a `for` is gone once the loop ends. If you want to use the value afterwards, declare it before the loop. Here, `i` is still alive after the loop, so the program can report where the loop stopped.

```c predict id=loop-after title="What does this print?"
#include <stdio.h>

int main(void) {
    int i;
    for (i = 0; i < 4; i++) {
        if (i == 2) break;
    }
    printf("%d\n", i);
    return 0;
}
--- options
* 2
3
4
1
--- explain
The variable `i` is declared before the loop, so it survives. The loop breaks when `i` reaches 2, before the increment would make it 3. The `printf` shows `2`. Declaring the variable outside the loop is the right choice whenever the value matters afterwards.
```

## goto, briefly

C has a `goto` statement that jumps to a label. You will see it in some older code and in a few cleanup patterns, such as releasing several resources on an error path. In everyday code, prefer `break`, `continue`, `return` and well-named functions, because they keep the control flow visible.

## Recap

- `break` leaves the innermost loop or `switch`.
- `continue` skips to the next pass. In a `for` loop, the update still runs.
- A `break` in an inner loop does not stop the outer loop.
- Declare a loop variable before the loop when you need its value afterwards.
- Prefer `break`, `continue` and `return` over `goto` in everyday code.

**Up next:** functions, the way C organizes code into reusable pieces.
