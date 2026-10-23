A key-value store is one of the most useful programs you can write in C, and it is also one of the most instructive. Under its simple interface, `put`, `get` and `delete`, it combines everything in this course: a hash table with chaining (lesson 11), ownership of every key and value (lesson 7), careful serialization (lessons 14 and 15), error-aware file I/O (lesson 18), write-then-rename for safe saves (lesson 18), and defensive parsing of data that may be corrupt (lesson 20). Databases, caches and configuration systems are built on this design.

The store in this lesson keeps its data in memory, and it saves to a single file that it loads at startup. The format is small enough to read in one sitting and strict enough to reject damaged input.

## Requirements

- `kv_put` stores a string value under a string key, replacing any earlier value.
- `kv_get` returns the stored value, or reports that the key is missing.
- `kv_delete` removes a key.
- `kv_save` writes the whole store to a file safely.
- `kv_load` reads a file, rejects anything malformed, and leaves the store unchanged on failure.

These are small requirements, and they force important decisions. A value must be copied into memory the store owns, because the caller's buffer may disappear. A save must never leave a half-written file behind. A load must check every length before trusting it.

## The record format

Each record is a key length, the key bytes, a value length and the value bytes. Lengths are stored as a single byte, which limits keys and values to 255 characters. That limit is a deliberate choice: it removes byte-order questions entirely, and a single byte is easy to check. A file begins with a four-byte magic string, `KVS1`, so that a load can reject a file that is not a store at all:

```c
#define KV_MAGIC "KVS1"
#define KV_MAX_FIELD 255
```

Here is the encoder. It writes into a caller-supplied buffer, and it returns the number of bytes used:

```c
size_t encode_record(unsigned char *out, const char *key, const char *value) {
    size_t klen = strlen(key);
    size_t vlen = strlen(value);
    out[0] = (unsigned char)klen;
    memcpy(out + 1, key, klen);
    out[1 + klen] = (unsigned char)vlen;
    memcpy(out + 2 + klen, value, vlen);
    return 2 + klen + vlen;
}
```

The predict question encodes one record, and it confirms the layout byte by byte:

```c predict id=encode-record title="How many bytes are written, and what is the first one?"
#include <stdio.h>
#include <string.h>
#include <stddef.h>

static size_t encode_record(unsigned char *out, const char *key, const char *value) {
    size_t klen = strlen(key);
    size_t vlen = strlen(value);
    out[0] = (unsigned char)klen;
    memcpy(out + 1, key, klen);
    out[1 + klen] = (unsigned char)vlen;
    memcpy(out + 2 + klen, value, vlen);
    return 2 + klen + vlen;
}

int main(void) {
    unsigned char buf[32];
    size_t n = encode_record(buf, "ab", "xyz");
    printf("%zu %d\n", n, buf[0]);
    return 0;
}
--- options
5 2
* 7 2
7 3
7 0
--- explain
The key `"ab"` has two bytes and the value `"xyz"` has three. The record is one length byte, two key bytes, one length byte and three value bytes, for seven bytes in total. The first byte holds the key length, `2`. Output: `7 2`. The record is self-describing, so a reader never needs to know the key's length in advance.

## The decoder checks every length

The decoder is the part that protects the store from bad files. It must check that each length fits inside the bytes it actually has, before it copies anything. A file that claims a 200-byte value but ends after 20 bytes is damaged, and the decoder must refuse it rather than read past the end:

```c
size_t decode_record(const unsigned char *in, size_t avail,
                     char *key, char *value) {
    if (avail < 1) return 0;
    size_t klen = in[0];
    if (avail < 2 + klen) return 0;
    size_t vlen = in[1 + klen];
    if (avail < 2 + klen + vlen) return 0;
    memcpy(key, in + 1, klen);
    key[klen] = '\0';
    memcpy(value, in + 2 + klen, vlen);
    value[vlen] = '\0';
    return 2 + klen + vlen;
}
```

The caller's buffers `key` and `value` must hold 256 bytes each, and the decoder writes the terminator within those limits. Returning `0` means the record is malformed. That single value keeps the interface simple, and the loader treats it as a corrupt file.

The predict question checks both the success case and the truncated case, which is the one that matters for safety:

```c predict id=decode-truncated title="What is printed for the full record and for a truncated one?"
#include <stdio.h>
#include <string.h>
#include <stddef.h>

static size_t decode_record(const unsigned char *in, size_t avail,
                            char *key, char *value) {
    if (avail < 1) return 0;
    size_t klen = in[0];
    if (avail < 2 + klen) return 0;
    size_t vlen = in[1 + klen];
    if (avail < 2 + klen + vlen) return 0;
    memcpy(key, in + 1, klen);
    key[klen] = '\0';
    memcpy(value, in + 2 + klen, vlen);
    value[vlen] = '\0';
    return 2 + klen + vlen;
}

int main(void) {
    const unsigned char record[7] = { 2, 'a', 'b', 3, 'x', 'y', 'z' };
    char key[256], value[256];
    size_t full = decode_record(record, 7, key, value);
    size_t cut = decode_record(record, 5, key, value);
    printf("%zu %zu\n", full, cut);
    return 0;
}
--- options
7 5
0 0
* 7 0
0 7
--- explain
The full seven-byte record decodes, and the decoder reports that it consumed `7` bytes. With only five bytes available, the value length byte says three value bytes follow, but only one is present after the key. The check `avail < 2 + klen + vlen` fails, so the decoder returns `0` without copying anything. The output is `7 0`. Refusing the truncated record is the behavior that keeps a damaged file from corrupting the store.

> **Pitfall:** Checking the length after copying is the classic bug. A decoder that copies first and checks later has already written past its buffer. Validate every length against the available bytes before the first `memcpy`.

## The table

The store is a hash table with chaining, the design from lesson 11, with each entry owning its key and its value. Here is the entry type and the lookup:

```c
typedef struct entry {
    char *key;
    char *value;
    struct entry *next;
} entry;

typedef struct {
    entry **buckets;
    size_t bucket_count;
    size_t size;
} kv_store;

static entry *find_entry(const kv_store *s, const char *key, entry ***link) {
    size_t index = hash_string(key) % s->bucket_count;
    entry **pp = &s->buckets[index];
    while (*pp != NULL && strcmp((*pp)->key, key) != 0) pp = &(*pp)->next;
    if (link != NULL) *link = pp;
    return *pp;
}
```

`find_entry` returns the matching entry and, through `link`, the address of the pointer that refers to it. That pointer-to-pointer is the same idiom from lesson 8. It lets `kv_delete` unlink a node without special cases for the head of a chain.

## Delete, with the link pointer

Deletion uses the link that the lookup returned. The unlinked entry is freed together with its key and value, because the store owns all three:

```c
int kv_delete(kv_store *s, const char *key) {
    entry **link = NULL;
    entry *e = find_entry(s, key, &link);
    if (e == NULL) return 0;
    *link = e->next;
    free(e->key);
    free(e->value);
    free(e);
    s->size--;
    return 1;
}
```

The predict question uses the same unlink step on a three-node chain, so you can see that the surrounding nodes stay connected:

```c predict id=unlink-middle title="Which key is next after the deletion?"
#include <stdio.h>
#include <stddef.h>

typedef struct entry {
    const char *key;
    struct entry *next;
} entry;

int main(void) {
    entry c = { "c", NULL };
    entry b = { "b", &c };
    entry a = { "a", &b };
    entry *head = &a;

    entry **link = &head;
    while (*link != NULL && (*link)->key[0] != 'b') link = &(*link)->next;
    if (*link != NULL) *link = (*link)->next;

    printf("%s\n", head->next->key);
    return 0;
}
--- options
b
* c
a
NULL
--- explain
The walk stops at the link that points at `b`, so `link` holds the address of `a.next`. Setting `*link` to `b.next` skips over `b`, leaving the chain `a -> c`. `head->next` is now `c`, and its key is `c`. This is the delete step in `kv_delete`, and it works without checking whether `b` is the head, because `link` can point at the head pointer itself.

## Saving safely

`kv_save` writes the magic string, then one record per entry, into a temporary file. It renames that file over the original only after every write and the final close have succeeded. This is the procedure from lesson 18, and it is what protects the store from a crash in the middle of a save:

```c
int kv_save(const kv_store *s, const char *path) {
    char temp[4096];
    snprintf(temp, sizeof temp, "%s.tmp", path);
    FILE *f = fopen(temp, "wb");
    if (f == NULL) return 0;
    int ok = fwrite(KV_MAGIC, 1, 4, f) == 4;
    unsigned char record[2 + 2 * KV_MAX_FIELD];
    for (size_t i = 0; ok && i < s->bucket_count; i++) {
        for (const entry *e = s->buckets[i]; ok && e != NULL; e = e->next) {
            size_t n = encode_record(record, e->key, e->value);
            ok = fwrite(record, 1, n, f) == n;
        }
    }
    if (fclose(f) != 0) ok = 0;
    if (!ok || rename(temp, path) != 0) {
        remove(temp);
        return 0;
    }
    return 1;
}
```

The loader is the mirror image. It reads the whole file, checks the magic string, and decodes records one at a time. It builds the new contents in a separate store and swaps it in only when every record is valid. A corrupt file therefore never leaves the live store half loaded.

## Testing the store

Test the store the way you tested the dynamic array: empty stores, replacement of an existing key, deletion of the head, middle and last entries of a chain, and a save followed by a load that compares every key. Then write tests that damage the file on purpose: truncate it, change a length byte to a huge value, and remove the magic string. Each damaged file must be rejected with the store unchanged. Run the whole suite under AddressSanitizer and UndefinedBehaviorSanitizer from lesson 19.

> **Tip:** Make the damaged-file tests part of the regular suite, not a special case. Robust parsing is a property you can only keep by testing it every time the format changes.

> **In the wild:** Embedded key-value stores in browsers, mobile apps and command-line tools use this same model: a file with length-prefixed records, a write-then-rename save, and a loader that rejects anything it cannot verify. Production systems add checksums and log-structured writes, which is the next step after this design.

## Recap

- Store every key and value in memory the store owns, and free all three when an entry is deleted.
- Encode records with length prefixes, and check every length against the available bytes before copying.
- Use the link-pointer idiom to unlink any node, including the head, without special cases.
- Save to a temporary file and rename it over the original only after every step succeeds.
- Load into a separate structure, so a corrupt file never leaves the live store half changed.

**Up next:** The final capstone, a tokenizer and expression evaluator, which combines the recursive and pointer techniques from the whole course.
