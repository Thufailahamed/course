A variable holds a value. A pointer holds an address. A **function pointer** holds the address of code, and calling through it lets you choose the behavior of a program at run time. This is how C does polymorphism, plugins, event handlers and sorting with custom rules. The standard library's `qsort` (lesson 12) works this way, and so does almost every game engine's event system.

This lesson teaches the syntax, which is famously hard to read, and then shows the pattern that makes function pointers useful in real code: the **callback table**.

## The syntax

A function pointer is declared by taking a function's signature and wrapping the name in `(*name)`:

```c
int add(int a, int b);        // a function
int (*op)(int, int);          // a pointer to a function that takes two ints and returns an int
op = add;                     // the name of a function decays to its address
int result = op(2, 3);        // call through the pointer: result is 5
```

Read the declaration the way you read any declarator: `op` is a pointer, to a function taking `(int, int)`, returning `int`. The parentheses around `*op` are essential. Without them, `int *op(int, int)` declares a function returning a pointer to int.

A `typedef` makes the syntax manageable, and it is how serious libraries write it:

```c
typedef int (*binary_op)(int, int);
```

## Calling through a pointer

You can call a function pointer with or without an explicit dereference. Both forms are valid C, and you will see both in code. The predict question checks the explicit form with a typedef:

```c predict id=typedef-call title="What is printed?"
#include <stdio.h>

typedef int (*binary_op)(int, int);

int add(int a, int b) { return a + b; }
int mul(int a, int b) { return a * b; }

int main(void) {
    binary_op f = mul;
    printf("%d\n", (*f)(2, 5));
    return 0;
}
--- options
7
* 10
25
2
--- explain
`f` holds the address of `mul`. `(*f)` names the function, and `(*f)(2, 5)` calls it with `2` and `5`, so it returns `2 * 5`, which is `10`. The shorter form `f(2, 5)` does the same thing. The output is `10`.
```

## A callback table

The real power comes when you store function pointers in an array or a struct, indexed by something the user chooses. A dispatch table replaces a long chain of `if` and `else`, and it is easy to extend:

```c
#include <stdio.h>
#include <string.h>

typedef int (*binary_op)(int, int);

static int add(int a, int b) { return a + b; }
static int sub(int a, int b) { return a - b; }
static int mul(int a, int b) { return a * b; }

struct command {
    const char *name;
    binary_op run;
};

static const struct command commands[] = {
    { "add", add },
    { "sub", sub },
    { "mul", mul },
};

static int dispatch(const char *name, int a, int b) {
    for (size_t i = 0; i < sizeof commands / sizeof commands[0]; i++) {
        if (strcmp(commands[i].name, name) == 0) return commands[i].run(a, b);
    }
    return -1;   /* unknown command */
}
```

Adding a new operation means adding one function and one table row. Nothing else changes. This shape appears in interpreters, command-line tools and protocol parsers everywhere.

> **Tip:** Make the table `static const`. Then the compiler can place it in read-only memory, and nothing can overwrite a handler at run time by accident.

## Passing context: void pointers

A callback often needs state, such as a counter or an output buffer. C has no closures, so you pass that state explicitly through a `void *` parameter. The library calls your function with the pointer it was given, and your function casts it back:

```c
typedef void (*visit_fn)(int value, void *context);

static void sum_into(int value, void *context) {
    *(int *)context += value;
}

static void for_each(const int *items, size_t n, visit_fn visit, void *context) {
    for (size_t i = 0; i < n; i++) visit(items[i], context);
}
```

The caller decides what `context` means. This is the same design as `qsort` and as every event library you have used. It is also a common source of bugs when the context type does not match the cast, so keep the types next to each other in the code.

## Function pointer equality

A function's name decays to a pointer to that function, so you can compare a pointer with the name directly. Here is a predict question built on that fact:

```c predict id=fn-equality title="What is printed?"
#include <stdio.h>

int add(int a, int b) { return a + b; }

int main(void) {
    int (*op)(int, int) = add;
    printf("%d\n", op == &add);
    return 0;
}
--- options
0
* 1
2
compile error
--- explain
`add` decays to a pointer to the function, and `&add` is also a pointer to that function. Both expressions produce the same address, so the comparison is true, and `1` is printed. The same rule means `op == add` is also `1`.
```

> **Pitfall:** Never convert a function pointer to `void *` or to a data pointer, and never call one through the wrong type. Calling a function through a pointer of the wrong signature is undefined behavior. The compiler will not stop you, so match the typedef to the real function exactly.

A table can hold any mix of functions with the same signature. Indexing it and calling the entry is one expression:

```c predict id=dispatch-table title="What is printed?"
#include <stdio.h>

static int twice(int x) { return 2 * x; }
static int square(int x) { return x * x; }

int main(void) {
    int (*table[])(int) = { square, twice, square };
    printf("%d\n", table[1](4) + table[2](3));
    return 0;
}
--- options
12
16
* 17
24
--- explain
`table[1]` is `twice`, so `table[1](4)` is `8`. `table[2]` is `square`, so `table[2](3)` is `9`. The sum is `17`. Because the table is an array of function pointers, the call syntax is the same as calling a normal function, just with an index in front.
```

## Common patterns in real code

- **Strategy:** choose an algorithm at run time, such as a compression level or a sorting order.
- **Callbacks:** the library calls your code when something happens, such as a completed request or a finished parse.
- **Vtables:** a struct of function pointers gives you a manual interface. File systems and device drivers in operating systems are built this way.
- **Iterators:** a traversal takes a visit function plus a context pointer.

> **In the wild:** The Linux kernel's `file_operations` struct is a table of function pointers. Each filesystem fills it with its own functions, and the kernel calls through it without knowing the filesystem type.

## Recap

- Declare function pointers with the parentheses: `int (*op)(int, int)`.
- Call through them with `op(...)` or `(*op)(...)`; the function name decays to a pointer.
- A callback table, an array of structs with names and function pointers, replaces long `if` chains.
- Pass state explicitly through a `void *` context, and cast it back to the right type.
- The function type must match exactly, because calling through a mismatched type is undefined behavior.

**Up next:** Dynamic memory, the heap, and the functions `malloc`, `calloc`, `realloc` and `free`.
