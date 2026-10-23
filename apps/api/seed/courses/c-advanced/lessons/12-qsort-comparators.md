Every program eventually needs to sort something: customers by name, files by size, events by timestamp, scores from highest to lowest. You could write a sort for each case, and programmers do that for speed in hot paths. For everything else, C gives you `qsort` in `<stdlib.h>`: one general function that sorts an array of any type, with a comparison function you supply. It is a direct application of the function pointers from lesson 5, and it shows the most common C API design pattern you will meet: generic code that asks the caller for the one piece of knowledge only the caller has.

This lesson explains the signature, the comparator contract, the traps that produce wrong or undefined results, and how to sort structures by several keys.

## The signature

```c
void qsort(void *base, size_t count, size_t size,
           int (*compare)(const void *, const void *));
```

`qsort` knows nothing about your type. It receives the start of the array (`base`), the number of elements, the size of one element in bytes, and a comparator. It moves the bytes around, and it calls the comparator with pointers to two elements whenever it needs to decide their order. Only the comparator knows what an element means.

## The comparator contract

A comparator returns:

- a **negative** number when the first element should come before the second,
- **zero** when they are equal in the sort order,
- a **positive** number when the first should come after the second.

The arguments are `const void *`, so the first job of every comparator is to cast them to the element type and dereference:

```c
static int compare_ints(const void *pa, const void *pb) {
    int a = *(const int *)pa;
    int b = *(const int *)pb;
    return (a > b) - (a < b);
}
```

The last line is a safe idiom. `(a > b)` is `1` when `a` is larger, and `(a < b)` is `1` when `a` is smaller. Subtracting them gives exactly `-1`, `0` or `1`, and it never overflows. That matters for the next pitfall.

> **Pitfall:** The comparator `return a - b;` looks simpler, but it overflows when the difference does not fit in an `int`. For example, `a = 2000000000` and `b = -2000000000` give a difference larger than `INT_MAX`, which is undefined behavior. The comparison form above is always safe.

The predict question sorts three integers with this comparator:

```c predict id=sort-ints title="What are the first three values after sorting?"
#include <stdio.h>
#include <stdlib.h>

static int compare_ints(const void *pa, const void *pb) {
    int a = *(const int *)pa;
    int b = *(const int *)pb;
    return (a > b) - (a < b);
}

int main(void) {
    int values[] = { 30, 10, 20 };
    qsort(values, 3, sizeof values[0], compare_ints);
    printf("%d %d %d\n", values[0], values[1], values[2]);
    return 0;
}
--- options
30 20 10
* 10 20 30
10 30 20
20 10 30
--- explain
`qsort` calls `compare_ints` to decide order. A negative result puts the first argument earlier, so the comparator sorts in ascending order. After sorting, the array holds `10`, `20`, `30`. Reversing the comparison, as in `(a < b) - (a > b)`, would sort descending.

## Sorting in descending order

Reversing the comparator reverses the output. You do not need a second sorting function, and the same code works for any type once the comparison is right:

```c
static int compare_descending(const void *pa, const void *pb) {
    int a = *(const int *)pa;
    int b = *(const int *)pb;
    return (b > a) - (b < a);
}
```

Notice that the arguments are swapped inside the expression. The clearest way to write a comparator for descending order is to compare `b` with `a`, which reads as "b before a".

## Sorting strings and structs

When the array holds pointers, the comparator receives a pointer *to* the pointer. This level of indirection surprises almost everyone, so draw it out. Here is a sort of strings, which needs a double cast:

```c
static int compare_names(const void *pa, const void *pb) {
    const char *const *a = pa;
    const char *const *b = pb;
    return strcmp(*a, *b);
}
```

The predict question sorts an array of string pointers:

```c predict id=sort-strings title="What are the names in order?"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int compare_names(const void *pa, const void *pb) {
    const char *const *a = pa;
    const char *const *b = pb;
    return strcmp(*a, *b);
}

int main(void) {
    const char *names[] = { "carol", "alice", "bob" };
    qsort(names, 3, sizeof names[0], compare_names);
    printf("%s %s %s\n", names[0], names[1], names[2]);
    return 0;
}
--- options
carol bob alice
* alice bob carol
bob alice carol
alice carol bob
--- explain
The array holds three `char *` values. `qsort` passes the comparator pointers to those pointers, so `*a` is the string itself. `strcmp` orders the strings alphabetically: `alice`, then `bob`, then `carol`. The element size is `sizeof names[0]`, which is the size of a pointer, and that is what `qsort` uses to step through the array.

Sorting an array of structs follows the same pattern. The comparator casts to the struct pointer and compares one field:

```c
typedef struct {
    char name[32];
    int score;
} player;

static int by_score_desc(const void *pa, const void *pb) {
    const player *a = pa;
    const player *b = pb;
    return (b->score > a->score) - (b->score < a->score);
}

qsort(players, count, sizeof players[0], by_score_desc);
```

The last question swaps the comparison and checks the descending order:

```c predict id=sort-descending title="What are the values after sorting?"
#include <stdio.h>
#include <stdlib.h>

static int compare_descending(const void *pa, const void *pb) {
    int a = *(const int *)pa;
    int b = *(const int *)pb;
    return (b > a) - (b < a);
}

int main(void) {
    int values[] = { 4, 9, 1 };
    qsort(values, 3, sizeof values[0], compare_descending);
    printf("%d %d %d\n", values[0], values[1], values[2]);
    return 0;
}
--- options
1 4 9
* 9 4 1
4 9 1
9 1 4
--- explain
The comparator returns a positive value when `a` is smaller than `b`, which places the larger value first. The sorted array is `9`, `4`, `1`. Because the comparison is the only thing that changed, the same `qsort` call sorts the other way, which is the point of passing the rule in as a function.

## Multi-key sorting

When two items have equal primary keys, use a second key to break the tie. A chain of comparisons does this: return the first nonzero result, and fall through to the next key only on a tie.

```c
static int by_score_then_name(const void *pa, const void *pb) {
    const player *a = pa;
    const player *b = pb;
    if (b->score != a->score) return (b->score > a->score) - (b->score < a->score);
    return strcmp(a->name, b->name);
}
```

This sorts by score from highest to lowest, and alphabetically within each score.

## What qsort does not promise

Three facts are easy to miss:

- **Stability is not guaranteed.** Two elements that compare equal may come out in either order. If you need the original order preserved for ties, add the original index as a last key.
- **The comparator must be consistent.** It must always give the same answer for the same pair, and it must order elements transitively. A comparator that sometimes says `a < b` and `b < a` makes the result unpredictable.
- **The element size must match the array.** Passing the wrong size reads or writes the wrong bytes. Write `sizeof values[0]`, not a number you typed by hand.

> **Tip:** Keep the comparator next to the type it compares, and give it a name that says the order, such as `by_score_desc`. Anyone reading `qsort` should see the rule without scrolling.

## Searching sorted arrays

Once an array is sorted, `bsearch` finds an element in logarithmic time. It uses the same comparator contract, and the key you pass must have the element type:

```c
int key = 20;
int *found = bsearch(&key, values, 3, sizeof values[0], compare_ints);
```

`bsearch` returns a pointer to the matching element, or `NULL`. The array must be sorted by the same comparison, or the search will miss elements it should find.

> **In the wild:** Command-line tools sort large files with external merge sorts that use `qsort`-style comparators on records. The same comparator design appears in database indexes, where sort order is a property the index keeps up to date.

## Recap

- `qsort` sorts any array; you supply the element size and a comparator.
- A comparator returns negative, zero or positive, and should compare rather than subtract to avoid overflow.
- For arrays of pointers, the comparator receives a pointer to a pointer.
- Sort structs by one field or several, using `strcmp` for text and falling through on ties.
- Remember that `qsort` is not stable, and that `bsearch` needs the same ordering.

**Up next:** Bit manipulation: masks, shifts and flags, the low-level tools that compact storage and fast algorithms rely on.
