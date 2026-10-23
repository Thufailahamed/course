Real programs remember things between runs. In this project you will build a small contact book. It reads contacts from a file when it starts, lets you add one, shows the whole list and saves the result back to the file. The project brings together structs, arrays of structs, string handling, `fgets`, `snprintf` and safe file I/O, which are the lessons from the second half of the course.

## The plan

The contact book needs four things:

1. A `Contact` struct that holds a name and a phone number.
2. A way to load contacts from a text file, one per line.
3. A way to save contacts back to that file.
4. A `main` function that asks for a new contact, then shows and saves the list.

The file format is simple. Each contact is one line with the name, a comma and the phone number:

```text
Ada,555-0101
Grace,555-0199
```

Because the separator is a comma, names must not contain commas. The program checks for that, which is a design decision you will see below.

## Step 1: the struct and its limits

Fixed-size character arrays hold the text. Named constants keep the sizes in one place, so changing a limit touches one line.

```c
#include <stdio.h>
#include <string.h>

#define MAX_NAME 40
#define MAX_PHONE 20
#define MAX_CONTACTS 100
#define FILE_NAME "contacts.txt"

typedef struct {
    char name[MAX_NAME];
    char phone[MAX_PHONE];
} Contact;
```

The `typedef` lets the rest of the code write `Contact` instead of `struct`.

## Step 2: parsing a line

Splitting a line at the comma is the core trick of the loader. `strchr` finds the comma, replacing it with `'\0'` ends the name at that point, and `comma + 1` is the start of the phone number. Predict what that split produces:

```c predict id=split-line title="What does this print?"
#include <stdio.h>
#include <string.h>

int main(void) {
    char line[] = "Ada,555-0101";
    char *comma = strchr(line, ',');
    *comma = '\0';
    printf("%s|%s\n", line, comma + 1);
    return 0;
}
--- options
* Ada|555-0101
Ada,555-0101|
Ada|
Ada,|555-0101
--- explain
`strchr` returns a pointer to the comma. Writing `'\0'` into that position ends the first string at `Ada`, so `line` now reads `Ada`. The character after the comma, `comma + 1`, still points into the same array and reads `555-0101`. Both halves live in one buffer, which is why the split costs no copying.
```

Lines read with `fgets` end in a newline, which must be removed from the phone number. Here is the loader:

```c
static int load_contacts(Contact list[], int capacity) {
    FILE *f = fopen(FILE_NAME, "r");
    if (f == NULL) return 0;          /* no file yet: start with an empty book */

    int count = 0;
    char line[MAX_NAME + MAX_PHONE + 2];
    while (count < capacity && fgets(line, sizeof line, f) != NULL) {
        char *comma = strchr(line, ',');
        if (comma == NULL) continue;  /* skip lines that are not contacts */

        *comma = '\0';
        char *phone = comma + 1;
        phone[strcspn(phone, "\n")] = '\0';

        snprintf(list[count].name, MAX_NAME, "%s", line);
        snprintf(list[count].phone, MAX_PHONE, "%s", phone);
        count++;
    }
    fclose(f);
    return count;
}
```

`snprintf` copies the text with a size limit, so a very long name is truncated rather than overflowing the struct. That safety is the reason to prefer it over `strcpy`.

## Step 3: saving the book

Saving reverses the format. The file is replaced each time, so the program always writes the complete list.

```c
static int save_contacts(const Contact list[], int count) {
    FILE *f = fopen(FILE_NAME, "w");
    if (f == NULL) return 0;

    for (int i = 0; i < count; i++) {
        fprintf(f, "%s,%s\n", list[i].name, list[i].phone);
    }
    return fclose(f) == 0;            /* fclose can fail too, for example on a full disk */
}
```

The format string decides what lands in the file, so predict the line that `save_contacts` would write for one contact:

```c predict id=save-format title="What line is written to the file?"
#include <stdio.h>

int main(void) {
    const char *name = "Ada";
    const char *phone = "555-0101";
    fprintf(stdout, "%s,%s\n", name, phone);
    return 0;
}
--- options
* Ada,555-0101
Ada 555-0101
Ada,555-0101,
555-0101,Ada
--- explain
`fprintf` with `stdout` writes to the screen, exactly as the saver writes to the file. The format puts the name first, then a comma with no spaces, then the phone number, then a newline. That exact shape is what the loader expects when it splits the line at the comma.
```

Checking the result of `fclose` matters. Buffered data is written at that moment, so a failure there means the file is incomplete.

## Step 4: growing without a limit

The book holds at most `MAX_CONTACTS` entries in this version. Before you add one, check the count. The predict question below shows how a capacity check behaves as items arrive:

```c predict id=capacity-check title="What does this print?"
#include <stdio.h>

int main(void) {
    int cap = 2, count = 0;
    for (int i = 0; i < 5; i++) {
        if (count == cap) cap *= 2;
        count++;
    }
    printf("%d %d\n", count, cap);
    return 0;
}
--- options
* 5 8
5 4
5 2
4 8
--- explain
Trace it: the capacity starts at 2, and the count reaches 2 on the third iteration, so the capacity doubles to 4. The count reaches 4 on the fifth iteration, so the capacity doubles to 8. The count finishes at 5. This doubling strategy is how real dynamic arrays grow, and lesson 17's `realloc` is the tool for resizing the real memory.
```

## Step 5: the main program

The `main` function reads a name and a phone number, checks them, adds the contact, prints the list and saves the file.

```c
int main(void) {
    Contact book[MAX_CONTACTS];
    int count = load_contacts(book, MAX_CONTACTS);

    char name[MAX_NAME];
    char phone[MAX_PHONE];

    printf("Name: ");
    if (fgets(name, sizeof name, stdin) == NULL) return 1;
    printf("Phone: ");
    if (fgets(phone, sizeof phone, stdin) == NULL) return 1;

    name[strcspn(name, "\n")] = '\0';
    phone[strcspn(phone, "\n")] = '\0';

    if (name[0] == '\0' || strchr(name, ',') != NULL) {
        printf("Names must be non-empty and cannot contain commas.\n");
        return 1;
    }
    if (count < MAX_CONTACTS) {
        snprintf(book[count].name, MAX_NAME, "%s", name);
        snprintf(book[count].phone, MAX_PHONE, "%s", phone);
        count++;
    }

    printf("\n%-40s %s\n", "Name", "Phone");
    for (int i = 0; i < count; i++) {
        printf("%-40s %s\n", book[i].name, book[i].phone);
    }

    if (!save_contacts(book, count)) {
        perror(FILE_NAME);
        return 1;
    }
    return 0;
}
```

The check `strchr(name, ',') != NULL` protects the file format. Without it, a name such as `Smith, Ada` would be saved as two fields and read back wrongly. Validating input at the boundary keeps bad data out of the file.

## The whole program

Here is the complete file, in the order it reads from top to bottom. The helper functions are `static` because only this file uses them.

```c
#include <stdio.h>
#include <string.h>

#define MAX_NAME 40
#define MAX_PHONE 20
#define MAX_CONTACTS 100
#define FILE_NAME "contacts.txt"

typedef struct {
    char name[MAX_NAME];
    char phone[MAX_PHONE];
} Contact;

static int load_contacts(Contact list[], int capacity) {
    FILE *f = fopen(FILE_NAME, "r");
    if (f == NULL) return 0;

    int count = 0;
    char line[MAX_NAME + MAX_PHONE + 2];
    while (count < capacity && fgets(line, sizeof line, f) != NULL) {
        char *comma = strchr(line, ',');
        if (comma == NULL) continue;

        *comma = '\0';
        char *phone = comma + 1;
        phone[strcspn(phone, "\n")] = '\0';

        snprintf(list[count].name, MAX_NAME, "%s", line);
        snprintf(list[count].phone, MAX_PHONE, "%s", phone);
        count++;
    }
    fclose(f);
    return count;
}

static int save_contacts(const Contact list[], int count) {
    FILE *f = fopen(FILE_NAME, "w");
    if (f == NULL) return 0;

    for (int i = 0; i < count; i++) {
        fprintf(f, "%s,%s\n", list[i].name, list[i].phone);
    }
    return fclose(f) == 0;
}

int main(void) {
    Contact book[MAX_CONTACTS];
    int count = load_contacts(book, MAX_CONTACTS);

    char name[MAX_NAME];
    char phone[MAX_PHONE];

    printf("Name: ");
    if (fgets(name, sizeof name, stdin) == NULL) return 1;
    printf("Phone: ");
    if (fgets(phone, sizeof phone, stdin) == NULL) return 1;

    name[strcspn(name, "\n")] = '\0';
    phone[strcspn(phone, "\n")] = '\0';

    if (name[0] == '\0' || strchr(name, ',') != NULL) {
        printf("Names must be non-empty and cannot contain commas.\n");
        return 1;
    }
    if (count < MAX_CONTACTS) {
        snprintf(book[count].name, MAX_NAME, "%s", name);
        snprintf(book[count].phone, MAX_PHONE, "%s", phone);
        count++;
    }

    printf("\n%-40s %s\n", "Name", "Phone");
    for (int i = 0; i < count; i++) {
        printf("%-40s %s\n", book[i].name, book[i].phone);
    }

    if (!save_contacts(book, count)) {
        perror(FILE_NAME);
        return 1;
    }
    return 0;
}
```

Run it twice. The second run should show the contact you added the first time, because the file persisted between runs.

## Extend it

- Add a search command that prints every contact whose name contains a word the user types. `strstr` does the matching.
- Reject duplicate names before adding a new contact.
- Add a `delete` option that removes a contact by its position and saves the list.

> **Pitfall:** `fgets` leaves the newline in place, and if you forget to remove it, the saved phone numbers gain an extra blank line each time. The `strcspn` trick removes it, and you should check that every input path does the same.

## Recap

- Structs keep related fields together, and a `typedef` makes them easy to name.
- Split delimited text in place with `strchr` and a terminator, and strip newlines with `strcspn`.
- Save the whole data set each time, and check the result of `fclose`.
- Validate input at the boundary, so bad data never reaches the file.
- Prefer `snprintf` for copies, so the buffers cannot overflow.

**Up next:** the final project, which works with strings and pointers to count words and letters in a piece of text.
