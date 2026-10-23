A `for` loop puts the counter's setup, condition and update on one line. It is the right tool when you know how many passes you need, or when you are walking through a sequence.

## The three parts

```java run
for (int i = 1; i <= 5; i++) {
    System.out.println(i);
}
```

The three parts are separated by semicolons:

1. **Initialisation** — `int i = 1` runs once.
2. **Condition** — `i <= 5` is checked before every pass.
3. **Update** — `i++` runs after every pass.

The variable `i` exists only inside the loop. That keeps temporary counters from leaking into the rest of the method.

## Accumulating

```java run
int sum = 0;

for (int i = 1; i <= 10; i++) {
    sum += i;
}

System.out.println("Sum: " + sum);
```

The counter moves forward; the accumulator stays alive after the loop. This pattern — one variable to count, another to collect — covers a huge number of problems.

## Nested loops

A loop inside a loop is useful for grids. The outer loop controls rows and the inner loop controls columns:

```java run
for (int row = 1; row <= 3; row++) {
    for (int col = 1; col <= 3; col++) {
        System.out.print(row * col + " ");
    }
    System.out.println();
}
```

The inner loop completes all three columns for each row. Indentation is your friend here: it is easy to lose track of which loop a statement belongs to.

## Counting down and stepping

All three parts are flexible:

```java run
for (int i = 10; i >= 0; i -= 2) {
    System.out.print(i + " ");
}
System.out.println();

for (int i = 0; i < 5; i++) {
    if (i == 2) {
        continue;
    }
    System.out.print(i + " ");
}
System.out.println();
```

The first loop counts down by two. The second skips `2` with `continue`, printing `0 1 3 4`. Changing the update is often cleaner than adding an `if` inside the body.

```java predict id=for-predict title="What is printed?"
int sum = 0;
for (int i = 0; i < 5; i++) {
    if (i % 2 == 0) {
        sum += i;
    }
}
System.out.println(sum);
--- options
* 6
4
10
0
--- explain
The even values below 5 are 0, 2 and 4. Their sum is `0 + 2 + 4 = 6`.
```

## Challenges

```java exercise id=print-evens title="Print the even numbers from 2 to 10"
// Use a for loop to print 2, 4, 6, 8, 10 — one per line.
--- solution
for (int i = 2; i <= 10; i += 2) {
    System.out.println(i);
}
--- test
__check(__out().trim().equals("2\n4\n6\n8\n10"), "Print the five even numbers from 2 through 10");
--- hint
Start at 2, stop at 10, and increase by 2 each pass.
--- hint
`for (int i = 2; i <= 10; i += 2)`
```

```java exercise id=times-table title="Print a times table"
int n = 3;

// Print three lines, from "3 x 1 = 3" through "3 x 3 = 9".
--- solution
int n = 3;
for (int i = 1; i <= 3; i++) {
    System.out.println(n + " x " + i + " = " + (n * i));
}
--- test
__check(__out().trim().equals("3 x 1 = 3\n3 x 2 = 6\n3 x 3 = 9"), "Print the three multiplication facts in order");
--- hint
Use a loop from 1 to 3 and build each line with string concatenation.
--- hint
Put `(n * i)` in parentheses so the multiplication happens before the string join.
```

```java debug id=fix-for-bound title="The last number is missing"
for (int i = 1; i < 5; i++) {
    System.out.println(i);
}
--- solution
for (int i = 1; i <= 5; i++) {
    System.out.println(i);
}
--- test
__check(__out().trim().equals("1\n2\n3\n4\n5"), "The loop should include 5");
--- hint
The condition is checked before each pass. When `i` is 5, `i < 5` is false.
--- hint
Change `<` to `<=`.
```
