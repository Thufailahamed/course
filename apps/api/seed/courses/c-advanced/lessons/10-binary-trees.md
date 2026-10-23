A linked list finds a value by walking through every node, which takes time proportional to its length. An array finds a value by binary search in logarithmic time, but inserting into it is slow. A **binary search tree** (BST) keeps the best of both: each node has up to two children, and the arrangement guarantees that a search only follows one branch at each step. When the tree stays balanced, a lookup, an insert or a delete takes time proportional to its height, which grows only logarithmically with the number of keys.

Trees appear everywhere in systems code. File systems index directories with them, databases index tables with B-trees (a close relative), and the standard libraries of many languages use them for ordered maps. Writing a BST by hand is the best way to learn recursion over pointer structures, which you will use for the rest of your career.

## The ordering rule

Every node holds a key. For a BST, the rule is:

- every key in the **left** subtree is **smaller** than the node's key,
- every key in the **right** subtree is **larger**,
- there are no duplicates in this version (you can change that by choosing a side for equal keys and keeping it).

This rule is the invariant. Insertions, searches and deletions all preserve it, and every algorithm depends on it.

```c
typedef struct tree {
    int key;
    struct tree *left;
    struct tree *right;
} tree;
```

## Traversals

There are three classic ways to visit every node, and they differ only in when you handle the current node:

- **In-order** (left, node, right) visits keys in sorted order. It is the most useful, and it confirms that the tree is a valid BST.
- **Pre-order** (node, left, right) copies a tree, because it creates each parent before its children.
- **Post-order** (left, right, node) frees a tree, because it releases children before the parent that points at them.

The in-order traversal is a short recursive function. The predict question uses it on a fixed tree whose nodes live on the stack:

```c predict id=inorder title="Which keys are printed?"
#include <stdio.h>

typedef struct tree {
    int key;
    struct tree *left;
    struct tree *right;
} tree;

static void print_inorder(const tree *t) {
    if (t == NULL) return;
    print_inorder(t->left);
    printf("%d ", t->key);
    print_inorder(t->right);
}

int main(void) {
    tree one = { 1, NULL, NULL };
    tree three = { 3, &one, NULL };
    tree eight = { 8, NULL, NULL };
    tree five = { 5, &three, &eight };
    print_inorder(&five);
    printf("\n");
    return 0;
}
--- options
5 3 1 8 
8 5 3 1 
1 5 3 8 
* 1 3 5 8 
--- explain
In-order traversal visits the left subtree first, then the node, then the right subtree. For the root `5`, that means: all of the left subtree (`3`, with `1` on its left) comes out as `1 3`, then `5`, then the right subtree `8`. The output is `1 3 5 8`, which is sorted, as it always is for a valid BST.

## Searching

Search starts at the root and compares the target with the current key. Equal means found. Smaller means the target can only be on the left, larger means the right. Each step discards half of the remaining tree when the tree is balanced:

```c
const tree *tree_find(const tree *t, int key) {
    while (t != NULL) {
        if (key == t->key) return t;
        t = (key < t->key) ? t->left : t->right;
    }
    return NULL;
}
```

The iterative loop uses no extra stack space. The recursive form is just as correct, and it is easier to read for some people. Both rely on the invariant. If the tree is not a valid BST, the search can return the wrong answer without any error.

## Insertion

Insertion follows the same path as search and attaches the new node where the search would have ended. It must handle the empty tree, because the root pointer itself may change. Returning the (possibly new) root from the function solves that cleanly:

```c
tree *tree_insert(tree *t, int key) {
    if (t == NULL) {
        tree *n = malloc(sizeof *n);
        if (n == NULL) return NULL;   /* the caller must check for failure */
        n->key = key;
        n->left = NULL;
        n->right = NULL;
        return n;
    }
    if (key < t->key) t->left = tree_insert(t->left, key);
    else if (key > t->key) t->right = tree_insert(t->right, key);
    /* equal keys are ignored, so the tree holds no duplicates */
    return t;
}
```

The assignment `t->left = tree_insert(t->left, key)` is the key line. It stores the returned subtree back in the parent, which is how a new leaf gets linked in. Forgetting that assignment is the most common insert bug.

> **Pitfall:** If `malloc` fails in the middle of a recursive insert, a parent may be assigned `NULL` and the tree is damaged. A robust version checks the allocation before linking it. The simple form here is for clarity, so check your own code carefully.

The predict question builds a small tree from a sequence of inserts and checks the shape:

```c predict id=insert-shape title="What is printed?"
#include <stdio.h>
#include <stdlib.h>

typedef struct tree {
    int key;
    struct tree *left;
    struct tree *right;
} tree;

static tree *tree_insert(tree *t, int key) {
    if (t == NULL) {
        tree *n = malloc(sizeof *n);
        if (n == NULL) exit(EXIT_FAILURE);
        n->key = key;
        n->left = NULL;
        n->right = NULL;
        return n;
    }
    if (key < t->key) t->left = tree_insert(t->left, key);
    else if (key > t->key) t->right = tree_insert(t->right, key);
    return t;
}

static void tree_free(tree *t) {
    if (t == NULL) return;
    tree_free(t->left);
    tree_free(t->right);
    free(t);
}

int main(void) {
    tree *root = NULL;
    int keys[] = { 5, 3, 8, 1, 4 };
    for (size_t i = 0; i < sizeof keys / sizeof keys[0]; i++) {
        root = tree_insert(root, keys[i]);
    }
    printf("%d\n", root->left->right->key);
    tree_free(root);
    return 0;
}
--- options
1
3
* 4
8
--- explain
Insert `5` at the root. `3` is smaller, so it goes left. `8` is larger, so it goes right. `1` is smaller than `5` and smaller than `3`, so it goes to the left of `3`. `4` is smaller than `5` and larger than `3`, so it goes to the right of `3`. `root->left->right` is therefore the node `4`. The cleanup uses post-order, freeing both children before the node that points at them.

## Height and balance

The height of a tree is the number of nodes on its longest path from root to leaf. It determines how long a search can take. The recursion is short:

```c
int tree_height(const tree *t) {
    if (t == NULL) return 0;
    int left = tree_height(t->left);
    int right = tree_height(t->right);
    return 1 + (left > right ? left : right);
}
```

A tree built from keys that arrive in sorted order is a disaster: every insert goes to the right, the tree becomes a list, and searches take linear time. The insertion order `5, 3, 8, 1, 4` above is fine, but `1, 2, 3, 4, 5` is not. Balanced trees such as AVL and red-black trees rotate nodes after inserts to keep the height logarithmic. Learn the plain BST first, and then the balancing idea will make sense.

Here is the height function applied to a tree whose shape you can see directly:

```c predict id=height-check title="What is printed?"
#include <stdio.h>

typedef struct tree {
    int key;
    struct tree *left;
    struct tree *right;
} tree;

static int tree_height(const tree *t) {
    if (t == NULL) return 0;
    int left = tree_height(t->left);
    int right = tree_height(t->right);
    return 1 + (left > right ? left : right);
}

int main(void) {
    tree one = { 1, NULL, NULL };
    tree three = { 3, &one, NULL };
    tree eight = { 8, NULL, NULL };
    tree five = { 5, &three, &eight };
    printf("%d\n", tree_height(&five));
    return 0;
}
--- options
2
* 3
4
5
--- explain
The longest path is `5`, then `3`, then `1`, which has three nodes. The leaf `8` gives a path of two nodes, which is shorter. An empty subtree contributes height `0`, and each node adds `1` to the larger of its children's heights. The result is `3`.
```

## Deletion

Deletion has three cases, and the tricky one uses the in-order successor:

1. **Leaf:** remove the node and free it.
2. **One child:** replace the node with its child.
3. **Two children:** find the smallest key in the right subtree (the in-order successor), copy its key into the node, then delete that successor from the right subtree.

Case 3 keeps the ordering invariant true, because the successor is larger than everything in the left subtree and smaller than everything else in the right subtree.

> **Tip:** Draw the tree before writing delete. Most deletion bugs are a parent pointer left pointing at freed memory, and a drawing makes that visible instantly.

> **In the wild:** Kernel code uses binary trees for scheduling and memory maps. Linux's red-black tree powers the process scheduler's ordered list of tasks and many internal indexes, which is why its implementation is so carefully tested.

## Recap

- A BST keeps smaller keys to the left and larger keys to the right of every node.
- In-order traversal visits keys in sorted order; post-order is the safe order for freeing.
- Search and insert follow one path from the root. Insert returns the new subtree root and stores it back in the parent.
- Height determines performance, and sorted input makes an unbalanced tree.
- Deletion has three cases; the two-child case uses the in-order successor.

**Up next:** Hash tables with chaining, which trade ordering for constant-time lookups on average.
