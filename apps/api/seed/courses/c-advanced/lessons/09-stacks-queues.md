A list lets you insert and remove anywhere. That freedom is useful, but most programs need less. A **stack** allows only one kind of access: last in, first out. A **queue** allows only another: first in, first out. Restricting the operations makes the code smaller, easier to test and harder to misuse, and the restriction is exactly what makes these structures so common.

Stacks run the function-call machinery in every program, parse nested expressions, and undo your edits. Queues schedule work, buffer data between a producer and a consumer and drive breadth-first search. This lesson builds both on top of the linked nodes you learned in lesson 8, and it shows the one extra pointer that makes a queue fast.

## The stack: last in, first out

A stack has two operations, `push` (add to the top) and `pop` (remove from the top). Both run in constant time when the top is the head of a linked list, because adding and removing at the head changes only one pointer.

```c
typedef struct node {
    int value;
    struct node *next;
} node;

typedef struct {
    node *top;
} stack;
```

Wrapping the head in a `stack` struct is a deliberate choice. Callers receive a `stack` instead of a bare `node *`, so the interface states what they are allowed to do, and the representation can change later without breaking them.

```c
void stack_push(stack *s, int value) {
    node *n = malloc(sizeof *n);
    if (n == NULL) exit(EXIT_FAILURE);   /* simplest policy for a teaching example */
    n->value = value;
    n->next = s->top;
    s->top = n;
}

int stack_pop(stack *s) {
    /* Precondition: the stack is not empty. */
    node *n = s->top;
    int value = n->value;
    s->top = n->next;
    free(n);
    return value;
}

int stack_is_empty(const stack *s) {
    return s->top == NULL;
}
```

The precondition matters. `stack_pop` on an empty stack dereferences `NULL`, which is undefined behavior. Either document the rule, as above, or check and return a status. Every public function should say what it requires.

The predict question shows the stack's order in a small program:

```c predict id=stack-order title="What is printed?"
#include <stdio.h>
#include <stdlib.h>

typedef struct node {
    int value;
    struct node *next;
} node;

typedef struct {
    node *top;
} stack;

static void stack_push(stack *s, int value) {
    node *n = malloc(sizeof *n);
    if (n == NULL) exit(EXIT_FAILURE);
    n->value = value;
    n->next = s->top;
    s->top = n;
}

static int stack_pop(stack *s) {
    node *n = s->top;
    int value = n->value;
    s->top = n->next;
    free(n);
    return value;
}

int main(void) {
    stack s = { NULL };
    stack_push(&s, 4);
    stack_push(&s, 5);
    stack_push(&s, 6);
    int a = stack_pop(&s);
    int b = stack_pop(&s);
    printf("%d %d\n", a, b);
    while (s.top != NULL) stack_pop(&s);
    return 0;
}
--- options
4 5
* 6 5
5 6
6 4
--- explain
The last value pushed, `6`, is on top, so the first pop returns `6`. The second pop returns the next value down, which is `5`. The remaining `4` is freed by the cleanup loop. Reversing the order of pushes and pops is how stacks reverse anything.
```

## Reversing with a stack

A stack reverses a sequence: push everything, then pop everything. This is a practical trick, and the next question uses it on characters:

```c predict id=reverse-with-stack title="What is printed?"
#include <stdio.h>
#include <stdlib.h>

typedef struct node {
    char value;
    struct node *next;
} node;

typedef struct {
    node *top;
} stack;

static void push(stack *s, char value) {
    node *n = malloc(sizeof *n);
    if (n == NULL) exit(EXIT_FAILURE);
    n->value = value;
    n->next = s->top;
    s->top = n;
}

static char pop(stack *s) {
    node *n = s->top;
    char value = n->value;
    s->top = n->next;
    free(n);
    return value;
}

int main(void) {
    stack s = { NULL };
    const char *word = "abc";
    for (const char *p = word; *p != '\0'; p++) push(&s, *p);
    char out[4];
    for (int i = 0; i < 3; i++) out[i] = pop(&s);
    out[3] = '\0';
    printf("%s\n", out);
    return 0;
}
--- options
abc
* cba
bca
ccc
--- explain
The loop pushes `a`, then `b`, then `c`, so `c` is on top. Popping three times yields `c`, `b`, `a`. The array gets a terminating null byte at index 3, so `printf` with `%s` prints `cba`. Using `out[4]` for three characters plus the terminator is the correct size.

## The queue: first in, first out

A queue adds at one end and removes at the other. A singly linked list makes one of those ends cheap, but not both, unless you keep an extra pointer. The naive queue walks the list to find the tail on every enqueue, which takes time proportional to the length. Keeping a `tail` pointer makes enqueue constant time:

```c
typedef struct {
    node *head;   /* dequeue removes from here */
    node *tail;   /* enqueue appends here */
} queue;

void queue_enqueue(queue *q, int value) {
    node *n = malloc(sizeof *n);
    if (n == NULL) exit(EXIT_FAILURE);
    n->value = value;
    n->next = NULL;
    if (q->tail != NULL) q->tail->next = n;
    else q->head = n;            /* the queue was empty */
    q->tail = n;
}

int queue_dequeue(queue *q) {
    /* Precondition: the queue is not empty. */
    node *n = q->head;
    int value = n->value;
    q->head = n->next;
    if (q->head == NULL) q->tail = NULL;   /* the queue is now empty */
    free(n);
    return value;
}
```

The two places that set pointers to `NULL` are where queue bugs live. When the last element leaves, `tail` must become `NULL`, or the next enqueue writes into freed memory. When the first element arrives, `head` must be set, or the queue appears empty while holding data. The predict question checks the normal order:

```c predict id=queue-order title="What is printed?"
#include <stdio.h>
#include <stdlib.h>

typedef struct node {
    int value;
    struct node *next;
} node;

typedef struct {
    node *head;
    node *tail;
} queue;

static void enqueue(queue *q, int value) {
    node *n = malloc(sizeof *n);
    if (n == NULL) exit(EXIT_FAILURE);
    n->value = value;
    n->next = NULL;
    if (q->tail != NULL) q->tail->next = n;
    else q->head = n;
    q->tail = n;
}

static int dequeue(queue *q) {
    node *n = q->head;
    int value = n->value;
    q->head = n->next;
    if (q->head == NULL) q->tail = NULL;
    free(n);
    return value;
}

int main(void) {
    queue q = { NULL, NULL };
    enqueue(&q, 1);
    enqueue(&q, 2);
    enqueue(&q, 3);
    int first = dequeue(&q);
    int second = dequeue(&q);
    printf("%d %d\n", first, second);
    while (q.head != NULL) dequeue(&q);
    return 0;
}
--- options
3 2
* 1 2
2 3
1 3
--- explain
A queue returns values in the order they arrived. `1` was enqueued first, so the first dequeue returns `1`, and the second returns `2`. The cleanup loop removes the remaining `3`. The `tail` pointer never needed to walk the list, which is why each enqueue is constant time.
```

> **Tip:** Test a queue at three moments: one element, many elements, and empty again after the last dequeue. Most queue bugs appear at the boundaries, and the empty state is the one people forget.

## Array-based alternatives

A linked queue allocates a node per element. For high-throughput code, a **ring buffer** (a fixed array with a head index and a count, wrapping around at the end) avoids allocation entirely and keeps the data contiguous. It is the usual choice for audio buffers, network packets and communication between an interrupt handler and the main loop. Choose linked storage when the size is unpredictable and the simplicity matters more than speed.

> **In the wild:** Operating systems use queues for almost everything: runnable processes, pending disk requests and received network packets. The Linux kernel's `list_head` is a doubly linked list that serves as a stack in some places and a queue in others.

## Recap

- A stack is last in, first out. Push and pop at the head run in constant time.
- A queue is first in, first out. Keep both `head` and `tail` pointers so that enqueue is constant time.
- Document preconditions, and never pop or dequeue an empty structure.
- Reset `tail` to `NULL` when the queue empties, and set `head` when the first element arrives.
- A ring buffer is the array-based alternative when allocation must be avoided.

**Up next:** Binary search trees: a structure with two child pointers per node, and the recursion that makes it work.
