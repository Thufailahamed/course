A `while` loop repeats a block as long as its condition is true. The condition is checked **before** each pass, so a loop can run zero times. Something inside the loop must eventually make the condition false, or the program never stops.

## Counting with while

```java run
int i = 1;
while (i <= 5) {
    System.out.println(i);
    i++;
}
System.out.println("Finished");
```

`i++` adds one to `i`. Without it, `i` stays `1`, the condition stays true, and the loop runs forever. That is an **infinite loop**, and it is the most common while-loop bug.

## Accumulating a result

```java run
int n = 1;
int sum = 0;

while (n <= 10) {
    sum += n;
    n++;
}

System.out.println("Sum: " + sum);
```

The loop variable `n` controls how many passes happen; `sum` carries the result forward. Keeping those roles separate makes loops much easier to reason about.

## do-while

A `do-while` checks its condition **after** the body, so the body always runs at least once:

```java run
int attempts = 0;

do {
    attempts++;
    System.out.println("Attempt " + attempts);
} while (attempts < 3);
```

This is useful for menus and retry prompts, where you need to show something before you can decide whether to repeat.

## break and continue

`break` leaves the loop immediately. `continue` skips the rest of the current pass and jumps back to the condition:

```java run
int i = 0;
while (i < 10) {
    i++;
    if (i == 3) {
        continue;
    }
    if (i == 6) {
        break;
    }
    System.out.println(i);
}
```

This prints `1`, `2`, `4`, `5`. It skips `3` and stops before printing `6`. Use both sparingly; a clear condition is usually easier to read.

```java predict id=while-predict title="What is printed?"
int i = 0;
while (i < 3) {
    System.out.print(i);
    i++;
}
System.out.println();
--- options
* 012
123
0123
0
1
2
--- explain
The loop runs for `i` equal to 0, 1 and 2. At `i == 3` the condition is false. `print` keeps the digits on one line, giving `012`.
```

## Challenges

```java exercise id=countdown title="Count down with a while loop"
int n = 5;

// Print 5, 4, 3, 2, 1 — each on its own line.
--- solution
int n = 5;
while (n >= 1) {
    System.out.println(n);
    n--;
}
--- test
__check(__out().trim().equals("5\n4\n3\n2\n1"), "Count down from 5 to 1");
--- hint
Start at 5 and subtract one each pass.
--- hint
The condition can be `n >= 1`.
```

```java exercise id=sum-to-ten title="Sum the numbers from 1 to 10"
int i = 1;
int sum = 0;

// Add every number from 1 through 10.
--- solution
int i = 1;
int sum = 0;
while (i <= 10) {
    sum += i;
    i++;
}
--- test
__check(sum == 55, "1 + 2 + ... + 10 is 55");
--- hint
Add `i` to `sum` inside the loop, then increment `i`.
--- hint
`sum += i; i++;`
```

```java debug id=fix-loop-bound title="The loop prints one number too many"
int i = 0;
while (i <= 3) {
    System.out.println(i);
    i++;
}
--- solution
int i = 0;
while (i < 3) {
    System.out.println(i);
    i++;
}
--- test
__check(__out().trim().equals("0\n1\n2"), "The loop should print 0, 1 and 2 only");
--- hint
With `i <= 3`, the body runs when `i` is 3 as well.
--- hint
Change the condition to `i < 3`.
```
