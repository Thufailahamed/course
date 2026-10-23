The last project works with text. You will build a word-statistics tool that reads a sentence from the user, counts its characters, words and vowels, and prints a lowercase copy. The work is done with the pointers from lessons 15 and 16 and the strings from lesson 14, and it uses `<ctype.h>` to classify characters. This is the kind of small text-processing tool that real systems are full of.

## The plan

The program has three jobs, and each one becomes a function:

1. Count the words, where a word is a run of non-space characters.
2. Count the vowels, ignoring case.
3. Convert the text to lowercase, in place.

Each job walks the string with a pointer, stopping at the terminator. Keep that loop shape in mind, because you will write it again and again in C.

## Walking a string with a pointer

A pointer that moves along a string, reading one character at a time until it reaches `'\0'`, is the basic pattern for text work. Predict what this loop prints:

```c predict id=vowel-loop title="What does this print?"
#include <stdio.h>
#include <string.h>

int main(void) {
    const char *s = "Hello, C!";
    int vowels = 0;
    for (const char *p = s; *p != '\0'; p++) {
        if (strchr("aeiouAEIOU", *p) != NULL) vowels++;
    }
    printf("%d\n", vowels);
    return 0;
}
--- options
* 2
3
1
0
--- explain
The pointer `p` visits each character. The vowels in `Hello, C!` are `e` and `o`, so the count is 2. The loop stops at the terminator, which is the condition `*p != '\0'`, so `strchr` is never asked about the terminator. Checking membership with `strchr` against a string of letters is a compact idiom.
```

> **Tip:** `strchr(list, c)` returns a non-null pointer when `c` is in `list`. That makes it a short way to ask "is this character one of these?"

## Counting words

A word begins when a non-space character follows a space, or the start of the text. A small state variable records whether the walk is currently inside a word. Predict the count for a sentence with an extra space:

```c predict id=word-count title="What does this print?"
#include <ctype.h>
#include <stdio.h>

static int count_words(const char *text) {
    int words = 0;
    int in_word = 0;

    for (const char *p = text; *p != '\0'; p++) {
        if (isspace((unsigned char)*p)) {
            in_word = 0;
        } else if (!in_word) {
            in_word = 1;
            words++;
        }
    }
    return words;
}

int main(void) {
    printf("%d\n", count_words("one two  three"));
    return 0;
}
--- options
* 3
4
2
5
--- explain
Each time the walk moves from a space into a non-space character, the program starts a new word. The double space between `two` and `three` does not create an empty word, because `in_word` is already 0 and the space itself does not increase the count. So the answer is 3. Casting to `unsigned char` before `isspace` avoids undefined behavior with characters that have negative `char` values.
```

> **Pitfall:** The `<ctype.h>` functions take an `int` that must be representable as an `unsigned char` or equal to `EOF`. Passing a plain `char` with a negative value is undefined. Cast with `(unsigned char)` each time.

## Lowercasing in place

Converting text in place means changing each character where it sits, which needs a pointer to write through. `tolower` returns the lowercase form of a character, and the same cast applies.

```c predict id=lowercase title="What does this print?"
#include <ctype.h>
#include <stdio.h>

int main(void) {
    char word[] = "MiXeD";
    for (char *p = word; *p != '\0'; p++) {
        *p = (char)tolower((unsigned char)*p);
    }
    printf("%s\n", word);
    return 0;
}
--- options
* mixed
MiXeD
MIXED
mIxEd
--- explain
The pointer `p` walks the array, and each character is replaced with its lowercase form. `word` is a writable array, so the writes stay in place. Note that `char word[] = "MiXeD";` makes a modifiable copy of the text. A pointer assigned directly to a string literal, such as `char *s = "MiXeD";`, would point to read-only memory, and writing through it would be undefined behavior.
```

## The whole program

Here is the complete tool. It reads one line, makes a lowercase copy, and reports the statistics. Read it top to bottom, and notice how each function is small enough to check on its own.

```c
#include <ctype.h>
#include <stdio.h>
#include <string.h>

#define MAX_LINE 256

static int count_words(const char *text) {
    int words = 0;
    int in_word = 0;

    for (const char *p = text; *p != '\0'; p++) {
        if (isspace((unsigned char)*p)) {
            in_word = 0;
        } else if (!in_word) {
            in_word = 1;
            words++;
        }
    }
    return words;
}

static int count_vowels(const char *text) {
    int vowels = 0;
    for (const char *p = text; *p != '\0'; p++) {
        if (strchr("aeiou", tolower((unsigned char)*p)) != NULL) vowels++;
    }
    return vowels;
}

static void lowercase(char *text) {
    for (char *p = text; *p != '\0'; p++) {
        *p = (char)tolower((unsigned char)*p);
    }
}

int main(void) {
    char line[MAX_LINE];

    printf("Enter a sentence: ");
    if (fgets(line, sizeof line, stdin) == NULL) return 1;
    line[strcspn(line, "\n")] = '\0';

    char lower[MAX_LINE];
    snprintf(lower, sizeof lower, "%s", line);
    lowercase(lower);

    printf("characters: %zu\n", strlen(line));
    printf("words:      %d\n", count_words(line));
    printf("vowels:     %d\n", count_vowels(lower));
    printf("lowercase:  %s\n", lower);
    return 0;
}
```

For the input `Hello, C world`, the output is:

```text
characters: 14
words:      3
vowels:     3
lowercase:  hello, c world
```

Work through one line yourself to confirm it. The text has 14 characters, three words, and three vowels, which are the `e` and two `o`s.

## Extend it

- Count how often each vowel appears, using an array of five counters indexed by the vowel's position in `"aeiou"`.
- Find the longest word. Walk the text once, track the length of the current word, and save the start of the longest one with a pointer.
- Read several lines in a loop and print totals at the end, stopping when `fgets` returns `NULL`.

> **In the wild:** Word counters, character counters and search tools are built from exactly these loops. Editors, log analyzers and compilers all walk text with pointers and classify characters with `<ctype.h>`.

## Recap

- Walk a string with a `const char *` pointer until you reach `'\0'`.
- Use a state variable, such as `in_word`, to recognize the start and end of a run of characters.
- Classify characters with `<ctype.h>`, casting to `unsigned char` each time.
- Modify text in place only through an array you own. A string literal is read-only.
- Break a tool into small functions, each one easy to check.

**Up next:** you have finished C Basics. Continue to C Advanced, which covers dynamic data structures, undefined behavior, sanitizers and secure coding.
