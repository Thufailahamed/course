A binary search tree finds a key in time proportional to its height, which is logarithmic only when the tree stays balanced. A **hash table** aims for something faster: find a key in roughly constant time, regardless of how many keys you store. It does this by computing a number from the key and using that number to choose a place to look. Hash tables power symbol tables in compilers, caches in web servers, sets of visited URLs in crawlers and the dictionaries of most scripting languages.

The idea is simple. The hard parts are choosing a good hash function, handling two keys that land in the same place, and growing the table before it becomes slow. This lesson builds a table that uses **chaining**, where each bucket holds a linked list of entries, and it covers each part.

## The hash function

A hash function maps a key to an unsigned integer. A good one spreads keys evenly across the buckets, and it is fast. The classic string hash `djb2` multiplies the running value by 33 and adds each byte. Unsigned arithmetic wraps around, so the result always fits in the type, and the wrap is defined behavior:

```c
unsigned long hash_string(const char *key) {
    unsigned long h = 5381;
    for (const unsigned char *p = (const unsigned char *)key; *p != '\0'; p++) {
        h = h * 33u + *p;
    }
    return h;
}
```

The bucket is then `hash_string(key) % bucket_count`. The `unsigned char` cast matters: it keeps the byte values non-negative, which keeps the arithmetic simple to reason about. Using a signed `char` on a platform where it is signed would still be defined here, but it makes the intent harder to see.

The predict question below uses one character so that you can check the arithmetic by hand:

```c predict id=hash-bucket title="Which bucket does the key \"a\" land in?"
#include <stdio.h>

static unsigned long hash_string(const char *key) {
    unsigned long h = 5381;
    for (const unsigned char *p = (const unsigned char *)key; *p != '\0'; p++) {
        h = h * 33u + *p;
    }
    return h;
}

int main(void) {
    printf("%lu\n", hash_string("a") % 8);
    return 0;
}
--- options
0
2
5
* 6
--- explain
For the key `"a"`, the loop starts with `h = 5381`. Then `h = 5381 * 33 + 97`, where `97` is the code of `'a'`, which gives `177670`. Dividing by 8 leaves a remainder of `6`, because `8 * 22208 = 177664`. Bucket `6` of an 8-bucket table holds `"a"`.

## Chaining

Two different keys can land in the same bucket. That is a **collision**, and it is unavoidable: there are more possible keys than buckets. Chaining handles collisions by letting each bucket hold a linked list of entries. Lookup walks the chain for its bucket, comparing keys. Insert adds to the front of the chain, which takes constant time.

```c
typedef struct entry {
    char *key;
    int value;
    struct entry *next;
} entry;

typedef struct {
    entry **buckets;
    size_t bucket_count;
    size_t size;
} table;
```

The `buckets` field is an array of pointers, each the head of a chain. A bucket with no entries holds `NULL`. Initializing the array with `calloc` makes every bucket start as `NULL`, which is exactly what you want.

Here is insertion, which updates the value when the key already exists:

```c
int table_put(table *t, const char *key, int value) {
    size_t index = hash_string(key) % t->bucket_count;
    for (entry *e = t->buckets[index]; e != NULL; e = e->next) {
        if (strcmp(e->key, key) == 0) {
            e->value = value;          /* the key exists: update in place */
            return 1;
        }
    }
    entry *e = malloc(sizeof *e);
    if (e == NULL) return 0;
    e->key = copy_string(key);         /* the table owns its own copy of the key */
    if (e->key == NULL) {
        free(e);
        return 0;
    }
    e->value = value;
    e->next = t->buckets[index];
    t->buckets[index] = e;
    t->size++;
    return 1;
}
```

Two details are worth noticing. First, the table stores its own copy of the key, so the caller can free or change theirs. The helper `copy_string` is a small function you write yourself, because `strdup` is not part of standard C11. Second, the function checks for an existing key before it allocates, which avoids creating duplicates.

> **Pitfall:** Without a copy, the table keeps a pointer to the caller's string. If the caller later frees or modifies that string, every lookup for that key reads garbage. Ownership of the key is a decision you must make explicitly, as lesson 7 described.

The predict question uses the chain order directly. Two integer keys share a bucket, and inserting at the front changes what you see first:

```c predict id=chain-order title="Which keys are in bucket 0, in order?"
#include <stdio.h>
#include <stdlib.h>

typedef struct entry {
    int key;
    struct entry *next;
} entry;

#define BUCKETS 2

static entry *buckets[BUCKETS];

static void put(int key) {
    entry *e = malloc(sizeof *e);
    if (e == NULL) exit(EXIT_FAILURE);
    e->key = key;
    e->next = buckets[key % BUCKETS];
    buckets[key % BUCKETS] = e;
}

int main(void) {
    put(2);
    put(4);
    put(5);
    for (entry *e = buckets[0]; e != NULL; e = e->next) printf("%d ", e->key);
    printf("\n");
    for (int b = 0; b < BUCKETS; b++) {
        for (entry *e = buckets[b], *next; e != NULL; e = next) {
            next = e->next;
            free(e);
        }
        buckets[b] = NULL;
    }
    return 0;
}
--- options
2 4
* 4 2
5 4 2
4
--- explain
Keys `2` and `4` are both even, so they go to bucket `0`. Each new entry is added to the front of its chain. `2` is inserted first, then `4` goes in front of it, so the chain reads `4`, then `2`. The key `5` goes to bucket `1`, so it does not appear in bucket `0`. The cleanup frees every chain and resets each bucket to `NULL`.
```

The last question checks the update path and a lookup that misses. A single chain is enough to see both:

```c predict id=update-or-insert title="What is printed?"
#include <stdio.h>
#include <stdlib.h>

typedef struct entry {
    int key;
    int value;
    struct entry *next;
} entry;

static entry *head = NULL;

static void put(int key, int value) {
    for (entry *e = head; e != NULL; e = e->next) {
        if (e->key == key) {
            e->value = value;
            return;
        }
    }
    entry *e = malloc(sizeof *e);
    if (e == NULL) exit(EXIT_FAILURE);
    e->key = key;
    e->value = value;
    e->next = head;
    head = e;
}

static int get(int key, int fallback) {
    for (entry *e = head; e != NULL; e = e->next) {
        if (e->key == key) return e->value;
    }
    return fallback;
}

int main(void) {
    put(7, 1);
    put(9, 5);
    put(7, 2);
    printf("%d %d %d\n", get(7, -1), get(9, -1), get(3, -1));
    while (head != NULL) {
        entry *next = head->next;
        free(head);
        head = next;
    }
    return 0;
}
--- options
1 5 -1
* 2 5 -1
2 5 3
7 9 -1
--- explain
The second `put(7, ...)` finds the existing entry and overwrites its value with `2`, so the table still holds one entry for `7`. `get(7, -1)` returns `2`, `get(9, -1)` returns `5`, and `get(3, -1)` misses and returns the fallback `-1`. The output is `2 5 -1`.
```

## Updating and removing

Updating a value is a lookup followed by an assignment, as the insert function above shows. Removing a key is the same idiom you used for linked lists in lesson 8: walk with a pointer to the pointer, unlink the matching entry, free its key and the entry itself. Remember to free the key too, because the table owns it.

## Load factor and resizing

The **load factor** is the number of entries divided by the number of buckets. With chaining, lookups take time proportional to the chain length, so the average lookup costs about one plus the load factor. When the load factor grows past a threshold, such as 0.75, the table should grow. Growing means allocating a larger bucket array, computing new indexes for every entry, and relinking each entry into its new bucket. Entries move, but their keys and values do not change.

Resizing is the moment hash tables go wrong most often. If you grow the bucket array and forget to free the old one, you leak. If you free the old array before moving the entries, you read freed memory. Move every entry first, then free the old bucket array.

> **Tip:** Choose a bucket count that is a prime number, or a power of two with a good hash function. Prime sizes spread common key patterns more evenly, and they avoid the worst case of many keys sharing a remainder.

## Hash tables in practice

A table is only as good as its hash function and its assumptions. Hash tables are vulnerable to adversarial input: an attacker who knows the hash function can choose keys that all collide, turning constant-time lookups into linear scans. Production systems mitigate this with randomized seeds, which is why the hash function you choose matters beyond speed.

> **In the wild:** Compilers use hash tables for symbol lookup, where every identifier in a program is looked up many times. Caches in web servers use them for responses, and the default dictionary in many languages is a hash table with resizing and randomized hashing.

## Recap

- A hash function turns a key into an index; unsigned arithmetic makes the wraparound defined.
- Chaining stores a linked list in each bucket and handles collisions simply.
- Insert checks for an existing key first, and the table owns a copy of its keys.
- Load factor controls performance; resize by moving every entry before freeing the old array.
- Randomized hashing protects a table from adversarial keys.

**Up next:** Sorting with `qsort` and comparator functions, which uses the function pointers you learned in lesson 5.
