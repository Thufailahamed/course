Programs that forget everything when they exit are of limited use. C reads and writes files through the `FILE` type and a small set of functions in `<stdio.h>`. Each step can fail, and the most important habit in file handling is checking the result of every call. The file system is outside your program's control, so a file may be missing, locked or full, and your code should expect that.

## The basic cycle

Every file operation follows the same three steps: open the file, read or write it, then close it. `fopen` returns a pointer to a `FILE`, or `NULL` if the open fails. `fclose` releases the file when you finish.

```c
#include <stdio.h>

int main(void) {
    FILE *out = fopen("notes.txt", "w");
    if (out == NULL) {
        perror("notes.txt");
        return 1;
    }
    fprintf(out, "Remember the milk\n");
    fclose(out);
    return 0;
}
```

The mode string decides how the file is opened. `"r"` reads an existing file, `"w"` creates or replaces a file for writing, and `"a"` appends to the end of a file. Adding a `b`, as in `"rb"`, opens the file in binary mode, which matters for non-text data and on Windows.

`perror` prints a message to standard error that describes why the last call failed, which is far more useful than a generic message.

> **Pitfall:** `"w"` erases the file's previous contents as soon as it opens. Use `"a"` if you want to keep existing data.

## Writing with fprintf and fputs

`fprintf` works like `printf`, but it writes to a file. `fputs` writes a string without a format.

```c predict id=fputs-fgets title="What does this print?"
#include <stdio.h>

int main(void) {
    FILE *f = fopen("note.txt", "w");
    fputs("line one\nline two\n", f);
    fclose(f);
    f = fopen("note.txt", "r");
    char buf[64];
    fgets(buf, sizeof buf, f);
    fclose(f);
    printf("%s", buf);
    return 0;
}
--- options
* line one
line two
line one line two
(empty output)
--- explain
The program writes two lines, closes the file, then reopens it for reading. `fgets` reads the first line, including its newline, into `buf`. The `printf` shows only that first line, because `fgets` stops after one line. Notice that the file was closed and reopened between writing and reading, so the reader sees everything that was written.
```

## Reading with fgets

`fgets` reads one line at a time and never writes past the buffer you give it. That makes it the safest way to read text. It keeps the newline, so you usually strip it, as lesson 14 showed.

```c predict id=fgets-newline title="What does this print?"
#include <stdio.h>
#include <string.h>

int main(void) {
    FILE *f = fopen("sample.txt", "w");
    fputs("abc\n", f);
    fclose(f);
    f = fopen("sample.txt", "r");
    char line[16];
    fgets(line, sizeof line, f);
    fclose(f);
    printf("%zu\n", strlen(line));
    return 0;
}
--- options
* 4
3
5
16
--- explain
The file contains `abc` followed by a newline, which `fgets` keeps. So the line holds four characters before the terminator: `a`, `b`, `c` and the newline. That is why `strlen` reports 4. Stripping the newline is one of the first things a text-processing program does.
```

## Checking for failure

Opening a file that does not exist with `"r"` returns `NULL`. The program should report the problem and decide what to do, rather than continuing as if the file were open.

```c predict id=fopen-null title="What does this print?"
#include <stdio.h>

int main(void) {
    FILE *f = fopen("no_such_file_here.txt", "r");
    if (f == NULL) {
        printf("missing\n");
        return 1;
    }
    fclose(f);
    printf("found\n");
    return 0;
}
--- options
* missing
found
missing and found
a crash
--- explain
The file `no_such_file_here.txt` does not exist, so `fopen` returns `NULL`. The `if` branch prints `missing` and returns 1, which tells the operating system the program failed. Without that check, the program would call `fclose` on a null pointer, which is undefined behavior. Assume the question's file does not exist, as it is named to be absent.
```

> **Tip:** Check the result of every `fopen`, `fgets`, `fprintf` and `fclose`. `fclose` can fail too, for example when the disk is full and buffered data cannot be written. Ignoring that failure is how data quietly disappears.

## Reading numbers

Reading a whole line and then converting it with `sscanf` is safer than calling `fscanf` directly, because a bad line does not leave the file in an unpredictable position. The pattern is simple:

```c
char line[64];
int value;

while (fgets(line, sizeof line, f) != NULL) {
    if (sscanf(line, "%d", &value) == 1) {
        printf("read %d\n", value);
    } else {
        fprintf(stderr, "skipping a bad line\n");
    }
}
```

The loop stops at the end of the file, because `fgets` returns `NULL` then. Each line is checked on its own, so one bad entry does not stop the rest.

## Binary files, briefly

For images, saved structs and other non-text data, use `fwrite` and `fread`, which move raw bytes. They take a pointer, an element size, a count and the file. Open such files with `"wb"` and `"rb"`, so the bytes are not changed by text translation on Windows. You will use them in the contacts project.

## Recap

- Open with `fopen`, check for `NULL`, then close with `fclose`.
- `"w"` replaces a file, `"a"` appends, and `"r"` reads.
- `fprintf` and `fputs` write, and `fgets` reads a line safely with a size limit.
- Check every file call. Report failures with `perror` and return an error code.
- Read whole lines and parse them, so one bad line does not break the rest.

**Up next:** a quiz on structs, files and the preprocessor, then the first of three capstone projects.
