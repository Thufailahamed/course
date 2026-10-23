An array keeps its elements side by side in memory, which is fast to read and wasteful to change. Inserting in the middle means shifting everything after it. A **linked list** takes the opposite trade-off: each element is a separate node that holds a value and a pointer to the next node. Inserting or removing a node means changing a couple of pointers, and nothing else moves.

Linked lists are the first real data structure you build in C, and they teach the habits you need for everything after: allocating nodes, keeping pointers consistent and freeing everything exactly once. This lesson shows how to build a singly linked list correctly, including the pointer-to-pointer technique that removes special cases from insertion and deletion.

## The node

A node is a struct that contains data and a pointer to the next node of the same type. The struct must refer to itself by tag, since the type is not complete inside its own body:

```c
typedef struct node {
    int value;
    struct node *next;   /* NULL marks the end of the list */
} node;
```

The list itself is just a pointer to its first node, the **head**. An empty list is a head of `NULL`.

## Invariants

A data structure is correct when a set of conditions always holds. For a singly linked list:

- every `next` pointer is either `NULL` or the address of a valid node,
- following `next` from the head reaches `NULL` after finitely many steps (no cycles, unless you designed one),
- every node is reachable from the head, or it has been freed.

Every operation must keep these conditions true. When you write an insert or a delete, check the invariants before you return, not just that the function "seems to work".

## Insert at the head

Inserting at the head is the simplest operation, and it runs in constant time:

```c
node *list_push(node *head, int value) {
    node *n = malloc(sizeof *n);
    if (n == NULL) return head;   /* caller should detect failure; see the pitfall */
    n->value = value;
    n->next = head;
    return n;
}
```

The function returns the new head, which is the common style for functions that change the first node. The predict question below uses this shape:

```c predict id=push-order title="Which order is printed?"
#include <stdio.h>
#include <stdlib.h>

typedef struct node {
    int value;
    struct node *next;
} node;

static node *list_push(node *head, int value) {
    node *n = malloc(sizeof *n);
    if (n == NULL) return head;
    n->value = value;
    n->next = head;
    return n;
}

int main(void) {
    node *head = NULL;
    for (int i = 1; i <= 3; i++) head = list_push(head, i);
    for (node *p = head; p != NULL; p = p->next) printf("%d ", p->value);
    printf("\n");
    while (head != NULL) {
        node *next = head->next;
        free(head);
        head = next;
    }
    return 0;
}
--- options
1 2 3 
* 3 2 1 
2 1 3 
3 1 2 
--- explain
Each push puts the new node at the front, so the last value pushed (`3`) is first in the list. Traversal therefore prints `3 2 1`. The final loop frees each node after saving its `next` pointer, which is the only safe order: once a node is freed, its `next` field must not be read.

> **Pitfall:** Returning `head` on allocation failure silently keeps the list but drops the value. A safer design returns an error code and takes `node **` so the caller sees the failure. For a teaching example the simple form is clearer, but know the trade-off.

## Traversal and counting

Traversal is a loop that follows `next` until it finds `NULL`. Always write the test as "while the pointer is not `NULL`", and never dereference a pointer before you have checked it:

```c
size_t list_length(const node *n) {
    size_t count = 0;
    while (n != NULL) {
        count++;
        n = n->next;
    }
    return count;
}
```

The `const node *` parameter promises that the function only reads the list. That promise lets callers pass a list they do not own without worrying that it will change.

## Insert in sorted order: the pointer-to-pointer idiom

Inserting in the middle requires you to change the pointer that points at the new node, and that pointer may be the head itself. The beginner solution uses a "previous" pointer and needs a special case for the head. The idiom below removes the special case: keep a pointer to the **pointer** you want to update.

```c
void list_insert_sorted(node **head, node *n) {
    node **pp = head;
    while (*pp != NULL && (*pp)->value < n->value) {
        pp = &(*pp)->next;
    }
    n->next = *pp;
    *pp = n;
}
```

`pp` starts as the address of the head pointer. Each step moves it to the address of the current node's `next` field. When the loop ends, `*pp` is the first pointer that should be replaced, whether it is the head or a link inside the list. The same code handles both cases.

The predict question checks this technique on nodes that live on the stack, so there is nothing to free:

```c predict id=sorted-insert title="What is printed?"
#include <stdio.h>

typedef struct node {
    int value;
    struct node *next;
} node;

static void list_insert_sorted(node **head, node *n) {
    node **pp = head;
    while (*pp != NULL && (*pp)->value < n->value) {
        pp = &(*pp)->next;
    }
    n->next = *pp;
    *pp = n;
}

int main(void) {
    node c = { 20, NULL };
    node a = { 10, &c };
    node head_node = a;
    node *head = &head_node;
    node n = { 15, NULL };
    list_insert_sorted(&head, &n);
    printf("%d\n", head->next->value);
    return 0;
}
--- options
10
* 15
20
compile error
--- explain
The list starts as `10 -> 20`. The insertion walks past `10`, because `10 < 15`, and stops before `20`, because `20 < 15` is false. The pointer `pp` ends up pointing at the `next` field of the node holding `10`. Setting `*pp = n` links `15` in between, so `head->next` is the node `15`, and its value is `15`.

Notice that `head_node` is a copy of `a` taken before the insertion. In real code you would store the head once and pass its address, which is what this example does. Copying nodes is a common mistake when the pointer inside them is what matters.

## Removing a node

Removal uses the same idiom. Walk with `pp` until `*pp` holds the value to remove, then link around it and free it:

```c
int list_remove(node **head, int value) {
    node **pp = head;
    while (*pp != NULL) {
        if ((*pp)->value == value) {
            node *dead = *pp;
            *pp = dead->next;
            free(dead);
            return 1;
        }
        pp = &(*pp)->next;
    }
    return 0;
}
```

The removal reads `dead->next` before it frees `dead`, and it updates the pointer that used to point at `dead`. Both steps happen in the right order, and the invariants hold after the function returns.

> **Tip:** Draw the list before writing the loop. Arrows for `next`, a box for the head, and a dotted arrow for `pp` make the pointer-to-pointer idiom obvious. Most bugs in list code are an arrow that was updated in the wrong place.

The next question combines counting with pointers into the middle of the list. Each node here lives on the stack, which keeps the example short:

```c predict id=length-and-middle title="What is printed?"
#include <stdio.h>
#include <stddef.h>

typedef struct node {
    int value;
    struct node *next;
} node;

static size_t list_length(const node *n) {
    size_t count = 0;
    while (n != NULL) {
        count++;
        n = n->next;
    }
    return count;
}

int main(void) {
    node c = { 30, NULL };
    node b = { 20, &c };
    node a = { 10, &b };
    printf("%zu %d\n", list_length(&a), b.next->value);
    return 0;
}
--- options
2 20
* 3 30
3 20
2 30
--- explain
`list_length` follows `next` from `a` through `b` to `c`, then stops at `NULL`, so it counts three nodes. `b.next` is the node `c`, whose value is `30`. The output is `3 30`. The function takes `const node *` because it only reads the list.
```

## When to use a list

Linked lists are excellent when you insert or remove in the middle often, when you splice lists together, or when you need stable addresses for elements. They are poor when you need random access by index or when cache performance matters. Each node is a separate heap allocation, and walking a list jumps through memory. For most collections, a dynamic array (lesson 22) is faster. Learn lists anyway, because they are the building block of queues, hash chains, trees and many kernel structures.

## Recap

- A node holds a value and a pointer to the next node; `NULL` ends the list.
- Keep invariants true after every operation, and write them down.
- Insert at the head with a returned new head, and traverse with `while (p != NULL)`.
- The pointer-to-pointer idiom (`node **pp`) handles the head and middle cases with one code path.
- Read `next` before you free a node, and never use a node after it is freed.

**Up next:** Stacks and queues, two restricted interfaces built on the same linked storage.
