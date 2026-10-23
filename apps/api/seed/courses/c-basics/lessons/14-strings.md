C has no string type. A string is an array of `char` that ends with a special value, the null character `'\0'`. Every function that works with strings relies on that terminator to know where the text ends. Once you understand the terminator, the standard string functions are easy to use correctly, and the mistakes they invite are easy to avoid.

## Strings are char arrays

```c
#include <stdio.h>

int main(void) {
    char greeting[] = "Hello";
    printf("%s\n", greeting);
    return 0;
}
```

The array `greeting` has six elements, not five. The five letters are followed by `'\0'`, which the compiler adds automatically for a string literal. When `printf` sees `%s`, it prints characters until it reaches that terminator.

> **Pitfall:** A string needs room for its terminator. A buffer of `char name[5]` can hold a four-letter word and no more, so `"Grace"` does not fit. Forgetting the terminator is a classic source of bugs, and it is why string functions that take a size are safer.

## strlen and sizeof are different

`strlen` counts the characters before the terminator. `sizeof` measures the whole array, including the terminator and any unused space. Mixing them up is a frequent mistake.

```c predict id=strlen-sizeof title="What does this print?"
#include <stdio.h>
#include <string.h>

int main(void) {
    char word[] = "cat";
    printf("%zu %zu\n", strlen(word), sizeof word);
    return 0;
}
--- options
* 3 4
3 3
4 4
4 3
--- explain
`strlen` counts `c`, `a` and `t`, giving 3. `sizeof word` measures the array, which holds the three letters plus the terminator, so it is 4 bytes. The terminator is included in the array but not in the length of the string. `strlen` runs in time proportional to the string's length, so store the result if you need it many times.
```

## Comparing strings

Because a string is an array, `==` compares addresses, not text. Two arrays with the same letters are still two different arrays. Use `strcmp` from `<string.h>`, which returns 0 when two strings are equal.

```c predict id=string-compare title="What does this print?"
#include <stdio.h>

int main(void) {
    char s1[] = "x";
    char s2[] = "x";
    printf("%d\n", s1 == s2);
    return 0;
}
--- options
* 0
1
2
-1
--- explain
`s1` and `s2` are separate arrays in memory with the same contents. In an expression, each array name becomes the address of its first element, and those two addresses are different. So `s1 == s2` is false, which is 0. To compare the text, call `strcmp(s1, s2) == 0`.
```

> **Tip:** `strcmp` returns 0 for equal strings, a negative number if the first comes earlier alphabetically, and a positive number if it comes later. Write `strcmp(a, b) == 0`, rather than `!strcmp(a, b)`, so the intent is clear.

## Copying and terminators

`strcpy` copies a string, but it does not check the size of the destination. Use `snprintf` with a size instead, because it always leaves room for the terminator and never writes past the buffer. A string's terminator can also be placed by hand, and that changes what the string means.

```c predict id=null-terminator title="What does this print?"
#include <stdio.h>
#include <string.h>

int main(void) {
    char buf[8] = "abc";
    buf[1] = '\0';
    printf("%zu\n", strlen(buf));
    return 0;
}
--- options
* 1
3
2
8
--- explain
Setting `buf[1]` to the terminator makes the string end after its first character. `strlen` stops at the first `'\0'` it finds, so the answer is 1, even though the array still holds `c` after the terminator. Functions like `strlen` and `printf` read only up to the terminator, so the characters after it are invisible to them.
```

## Reading text safely

`fgets` reads a whole line into a buffer, and it takes the buffer's size, so it can never overflow. It keeps the newline character at the end of the text, and you usually remove it yourself.

```c
#include <stdio.h>
#include <string.h>

int main(void) {
    char name[32];

    printf("Name? ");
    if (fgets(name, sizeof name, stdin) == NULL) {
        return 1;
    }
    name[strcspn(name, "\n")] = '\0';   /* strip the newline */
    printf("Hello, %s!\n", name);
    return 0;
}
```

The call `strcspn(name, "\n")` finds the position of the first newline, and writing a terminator there removes it. Long input is truncated safely, which is far better than overflowing the array.

## Recap

- A C string is a `char` array ending with `'\0'`. Leave room for the terminator.
- `strlen` counts characters before the terminator. `sizeof` measures the whole array.
- `==` compares addresses, so compare strings with `strcmp`.
- Prefer `snprintf` and `fgets`, which take a size and cannot overflow the buffer.
- Writing a terminator early changes the length the string functions see.

**Up next:** pointers, the feature that makes C both powerful and demanding.
