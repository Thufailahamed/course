Most serious security vulnerabilities in software written in C come from a few patterns: writing past the end of a buffer, trusting a length that came from outside the program, and letting arithmetic wrap around and produce a size that is much too small. Browsers, operating systems and network services have been broken by each of these, often for decades before anyone noticed. The good news is that the defenses are known and small. This lesson covers them, along with the habit of checking every boundary where data enters or leaves your code.

Security in C is not a special topic added at the end. It is the same discipline you have been building all along: know the size of every buffer, know the valid range of every index, and never assume that input is well formed.

## Bounds: every write has a limit

A buffer has a size, and every write into it must stay inside that size. The most common mistake is to copy a string without checking its length:

```c
char name[16];
strcpy(name, user_input);     /* overflows when user_input has 16 or more characters */
```

`strcpy` has no idea how big `name` is. It copies until it finds the terminator, however far that is. The fix is to tell the function the size, and to check the result:

```c
char name[16];
int n = snprintf(name, sizeof name, "%s", user_input);
if (n < 0 || (size_t)n >= sizeof name) {
    /* the input was truncated: decide whether that is acceptable */
}
```

`snprintf` writes at most `sizeof name` bytes, always terminates the result, and returns the length the full output would have needed. Comparing that return value with the buffer size is how you find out whether truncation happened. The next question uses this exact behavior:

```c predict id=snprintf-truncate title="What is printed?"
#include <stdio.h>

int main(void) {
    char buf[6];
    int n = snprintf(buf, sizeof buf, "%s", "Grace Hopper");
    printf("%s %d\n", buf, n);
    return 0;
}
--- options
Grace 12
Grace Hopper 12
* Grace 12
Grace 11
--- explain
The buffer holds six bytes, so `snprintf` stores five characters, `Grace`, plus the terminating null byte. The return value is the length the complete output would have needed, which is the length of `Grace Hopper`, twelve characters. So the output is `Grace 12`. The return value tells you that the text was cut, which is the information you need to report or reject the input.

> **Pitfall:** `strncpy` looks like a safe choice, but it does not always terminate the destination. If the source is as long as the limit, the result has no null byte, and the next string operation reads past the buffer. Prefer `snprintf` for copies that must be terminated.

## Input from outside

Any data that comes from a file, a network connection or a user is hostile until it has been checked. The classic input traps in C:

- `gets` was removed from C11 because it cannot be given a size. Never use it.
- `scanf("%s", buf)` writes as many characters as the input has. Give it a width: `scanf("%15s", buf)` for a 16-byte buffer.
- `fgets(buf, sizeof buf, stdin)` reads at most one line and fits the buffer, but a line longer than the buffer leaves the rest in the stream. Detect that case by checking for a newline.
- Lengths read from a file must be checked against the real size of the data before you allocate or copy.

```c
char line[128];
if (fgets(line, sizeof line, stdin) == NULL) return -1;
if (strchr(line, '\n') == NULL && !feof(stdin)) {
    /* the line was too long: discard the rest and reject it */
}
```

> **Tip:** Treat every length in a file format as a claim to verify, not a fact. Compare it with the bytes actually available, and reject the file if they disagree. Many parser vulnerabilities start with a length field that the code trusted.

## Format strings

Never pass user-controlled text as the format argument to `printf`. A format string can read from the stack and, with `%n`, write to memory. The fix is one line:

```c
printf("%s", user_text);      /* safe: the text is data */
printf(user_text);            /* unsafe: the text is a format string */
```

Compilers warn about the second form under `-Wformat-security`. Enable that warning, and keep it on.

## Integer overflow before allocation

Sizes are computed with arithmetic, and arithmetic can wrap. Unsigned wraparound is defined, so it does not crash, but it produces a small number where you expected a large one. If you then allocate that small size and write the large number of elements, you have a heap overflow.

The next question shows an overflow check on an unsigned sum:

```c predict id=unsigned-overflow title="What is printed?"
#include <stdio.h>
#include <stdint.h>

int main(void) {
    uint32_t a = 4000000000u;
    uint32_t b = 500000000u;
    uint32_t sum = a + b;
    printf("%d\n", (int)(sum < a));
    return 0;
}
--- options
0
* 1
2
205032704
--- explain
`uint32_t` is exactly 32 bits, and unsigned addition wraps modulo 2 to the power of 32. The true sum, 4500000000, is larger than the maximum `uint32_t`, so the stored result is 205032704. That result is smaller than `a`. A sum that is smaller than one of its operands is the simplest proof of an unsigned overflow, and `(int)(sum < a)` prints `1`. Checks like this must run before the allocation, not after.

For multiplication, the same idea applies with division. Before computing `count * size`, check that the product fits:

```c
#include <stdint.h>

void *alloc_array(size_t count, size_t size) {
    if (size != 0 && count > SIZE_MAX / size) return NULL;   /* the product would overflow */
    return malloc(count * size);
}
```

This is what `calloc` does internally, and it is why `calloc(count, size)` is preferable to `malloc(count * size)` when you multiply sizes by hand.

> **Pitfall:** Signed integer overflow is undefined, so the check `a + b < a` written for signed values is not safe to rely on, because the compiler may remove it. Check signed arithmetic against the limits before the operation, using `INT_MAX` and `INT_MIN` from `<limits.h>`.

## Checking the bounds of an index

An index taken from input must be checked against the array size before you use it. The check should be the first thing that touches the value:

```c
int lookup(const int *table, size_t size, size_t index) {
    if (index >= size) return -1;    /* reject before reading */
    return table[index];
}
```

A signed index needs an extra check for negative values, because converting a negative `int` to `size_t` produces a huge number. Choose the type that matches the meaning: an index into an array is a `size_t`, and a count from user input should be checked as a signed value first.

The last question puts the index check in front of the read:

```c predict id=index-check title="What is printed?"
#include <stdio.h>
#include <stddef.h>

static int lookup(const int *table, size_t size, size_t index) {
    if (index >= size) return -1;
    return table[index];
}

int main(void) {
    int t[3] = { 10, 20, 30 };
    printf("%d %d\n", lookup(t, 3, 2), lookup(t, 3, 5));
    return 0;
}
--- options
* 30 -1
30 0
-1 30
10 -1
--- explain
The index `2` is valid for a three-element table, so `lookup` returns the third element, `30`. The index `5` fails the check, so the function returns `-1` without reading `table[5]`, which would be outside the array. Output: `30 -1`. Returning a sentinel is one way to report a rejected index; a status code with an output parameter is another. Either way, the read never happens unless the check passed.
```

## Secure habits

- Pass buffer sizes along with buffers, and use `sizeof` at the point of use.
- Check return values, especially from `snprintf`, `fopen`, `fread` and `malloc`.
- Check every length before you allocate, and before you copy.
- Compile with `-Wall -Wextra -Wformat-security`, and run the sanitizers from lesson 19 on your tests and on fuzzed input.
- Keep untrusted input out of format strings, and keep parsing code small enough to review.

> **In the wild:** Many of the most serious vulnerabilities in widely used software were overflows like the ones here: a length field that was trusted, a size that wrapped, or a copy that trusted its source. Each one was fixed with a check of the kind this lesson shows.

## Recap

- Every write needs a size. Use `snprintf` and check its return value for truncation.
- Give `scanf` a width, use `fgets` for lines, and never use `gets`.
- Pass user text as data, never as a `printf` format string.
- Check every multiplication and addition that sizes an allocation, before it runs.
- Check every index and every length from outside the program before using it.

**Up next:** Modular design: headers, opaque types and linkage, so that large programs keep their boundaries as they grow.
