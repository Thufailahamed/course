Real programs must survive files that are missing, disks that are full, permissions that changed and power cuts in the middle of a write. Most beginner code treats file operations as if they always succeed. Production code treats every file operation as something that can fail, reports the failure with a meaningful message, and leaves the data in a state that can be recovered. This lesson gives you that discipline for binary files, the format you need for speed and exactness, and it shows how C reports errors through return values and `errno`.

The examples here use only standard C11 functions. Some operations, such as `fsync` and `rename` semantics, belong to POSIX, and the lesson marks where that matters.

## Text versus binary

A file opened in text mode may translate line endings and interpret bytes in platform-specific ways. A file opened in binary mode is a sequence of bytes, exactly as written. For structured data such as arrays of integers or records, binary mode is the right choice. Add `b` to the mode:

```c
FILE *in  = fopen("data.bin", "rb");   /* read binary */
FILE *out = fopen("data.bin", "wb");   /* write binary, truncating the file */
FILE *log = fopen("data.bin", "ab");   /* append binary */
```

Binary files are compact and fast, but they are not self-describing. A reader must know the exact layout, and it must match the writer's layout and byte order. Write a version number at the start of your format, and write each field with fixed-width types from `<stdint.h>`.

## fwrite and fread return counts

`fwrite` and `fread` return how many **items** they transferred, not how many bytes. A short count means something went wrong or that you reached the end. Always compare the result with the count you asked for:

```c
size_t written = fwrite(values, sizeof values[0], count, out);
if (written != count) {
    /* disk full, I/O error or permission change: report it */
}
```

Reading works the same way, but a short count is also how you detect the end of the file. The predict question shows that behavior with a temporary file:

```c predict id=fread-short title="How many items are read?"
#include <stdio.h>

int main(void) {
    FILE *f = fopen("scratch.bin", "w+b");
    if (f == NULL) return 1;
    int written[2] = { 1, 2 };
    fwrite(written, sizeof written[0], 2, f);
    rewind(f);
    int buf[5] = { 0 };
    size_t n = fread(buf, sizeof buf[0], 5, f);
    printf("%zu %d\n", n, buf[1]);
    fclose(f);
    return 0;
}
--- options
5 2
* 2 2
2 0
0 2
--- explain
Two integers were written, so the file holds eight bytes. `fread` asked for five items but found only two before the end, so it returns `2`, the number of items it actually read. The second element is `2`, so the output is `2 2`. The unread slots of `buf` keep their initial zeros, and a short count like this one is how you detect the end of a file.
```

## A round trip, checked at each step

A good file format has a writer and a reader that agree exactly. The next question writes three integers and reads them back, and it checks the count at each step:

```c predict id=roundtrip title="What is printed?"
#include <stdio.h>

int main(void) {
    FILE *f = fopen("scratch.bin", "w+b");
    if (f == NULL) return 1;
    int data[3] = { 10, 20, 30 };
    size_t w = fwrite(data, sizeof data[0], 3, f);
    rewind(f);
    int back[3] = { 0 };
    size_t r = fread(back, sizeof back[0], 3, f);
    printf("%zu %d\n", w + r, back[2]);
    fclose(f);
    return 0;
}
--- options
3 30
* 6 30
6 10
3 10
--- explain
`fwrite` returns `3`, and `fread` returns `3`, so `w + r` is `6`. `rewind` moves the file position back to the start so the reader sees the data the writer produced. `back[2]` is the third integer, which is `30`. The output is `6 30`. Checking both counts is the habit that catches a short write before it turns into a corrupted file.
```

`fopen` with `"w+b"` opens a binary file for both writing and reading. The example uses a scratch file so the round trip is visible, and `rewind` moves back to the start before reading.

## Errors and errno

When a library call fails, the C standard library usually returns a special value, such as `NULL` from `fopen` or `-1` from a system call, and sets the global variable `errno` to a code that explains why. Three rules make `errno` reliable:

1. **Check the return value first.** `errno` is meaningful only after a call has reported failure. Its value is not cleared on success.
2. **Set `errno = 0` before the call** if you need to tell a real failure from a stale value.
3. **Read `errno` immediately**, before another library call can overwrite it.

The predict question uses `strtol`, which reports its parse position through an end pointer, and it shows the same kind of checking on a conversion:

```c predict id=strtol-end title="What is printed?"
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    char *end = NULL;
    long value = strtol("42xyz", &end, 10);
    printf("%ld %s\n", value, end);
    return 0;
}
--- options
42 42xyz
* 42 xyz
0 xyz
42 yz
--- explain
`strtol` parses as many digits as it can. It reads `42`, then stops at `x`, so it returns `42` and sets `end` to point at the remaining text, `xyz`. A caller who ignores `end` would accept `42xyz` as a valid number. Checking that `*end` is the terminator, or that `end` is at the expected position, catches partially valid input.

## Reporting failures to the user

`perror` prints a message with the current `errno` text, and `strerror` returns that text as a string you can format yourself:

```c
FILE *f = fopen(path, "rb");
if (f == NULL) {
    fprintf(stderr, "cannot open %s: %s\n", path, strerror(errno));
    return -1;
}
```

Write the failure to `stderr`, not `stdout`, so that it does not mix with the program's data. Include the path, because the message "No such file or directory" is useless without it.

## Writing safely: write, then replace

A crash in the middle of a write can leave a file half old and half new. A safer method writes the new content to a temporary file, checks every step, and then renames the temporary over the original. On POSIX systems `rename` replaces the destination atomically, so readers see either the old file or the new one:

```c
int save_atomic(const char *path, const void *data, size_t size) {
    char temp_path[4096];
    snprintf(temp_path, sizeof temp_path, "%s.tmp", path);
    FILE *f = fopen(temp_path, "wb");
    if (f == NULL) return -1;
    int ok = fwrite(data, 1, size, f) == size;
    if (fclose(f) != 0) ok = 0;    /* fclose can report a flush failure */
    if (!ok || rename(temp_path, path) != 0) {
        remove(temp_path);
        return -1;
    }
    return 0;
}
```

Two details matter. `fclose` can fail when buffered data cannot be written, so check its result. And `snprintf` protects the buffer from long paths, which lesson 20 discusses in depth.

> **Pitfall:** `rename` is atomic on a single file system, but not across file systems, and not every platform guarantees durability after a power cut. For data that must survive a crash, POSIX code calls `fsync` on the file before the rename, which is outside the C11 standard. Know what your platform promises.

> **In the wild:** Databases and editors use the write-then-rename pattern for their data files, so a crash never leaves a half-written document. The same discipline is what lets a program save its state every few seconds without risk.

## Recap

- Use binary mode and fixed-width types for structured data, and write a version number.
- Compare the counts from `fwrite` and `fread` with what you asked for.
- Check return values first, set `errno = 0` when you need a clean signal, and read `errno` at once.
- Report errors to `stderr` with the path and `strerror` text.
- Save with write-then-rename so a crash never corrupts the existing file.

**Up next:** Debugging with gdb, AddressSanitizer, UndefinedBehaviorSanitizer and Valgrind, the tools that find the bugs this course has warned you about.
