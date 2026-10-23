Every variable has two properties that people often mix up. Its **scope** is the part of the program where its name can be used. Its **lifetime** is how long the memory it occupies stays alive. Local variables are the most common case, and they are simple once you see the rule: each one lives in a block and disappears when the block ends. This lesson covers those rules, the global variables you should use sparingly, and the `static` keyword that changes a variable's lifetime.

## Block scope

A variable declared inside a pair of braces exists only inside them. Code outside the block cannot see it, and the name can be reused elsewhere without conflict.

```c
#include <stdio.h>

int main(void) {
    int total = 0;
    for (int i = 1; i <= 3; i++) {
        int square = i * i;
        total += square;
    }
    /* printf("%d", square); would not compile: square is out of scope */
    printf("%d\n", total);
    return 0;
}
```

Each pass of the loop body creates a fresh `square`, which is destroyed at the end of the pass. Keeping variables in the smallest block that needs them makes code easier to read and harder to misuse.

## Shadowing

An inner declaration can share a name with an outer one. The inner name then hides the outer one inside its block. This is legal, and it is a frequent source of confusion.

```c predict id=shadowing title="What does this print?"
#include <stdio.h>

int value = 1;

int main(void) {
    int value = 2;
    {
        int value = 3;
        printf("%d ", value);
    }
    printf("%d\n", value);
    return 0;
}
--- options
* 3 2
1 2
2 2
3 1
--- explain
The innermost `value` is 3, and the `printf` inside the braces uses it. After the braces end, the name `value` refers to the `int value = 2` declared in `main`, which hides the global `value = 1`. The global variable is shadowed everywhere in `main`. Compilers can warn about shadowing with `-Wshadow`, which is worth enabling as your programs grow.
```

## Local lifetime

A local variable is created when its block starts and destroyed when the block ends. Its value does not survive into the next call of the function. This is why a counter inside a function resets each time, unless you ask for something different.

```c predict id=loop-scope title="What does this print?"
#include <stdio.h>

int main(void) {
    for (int i = 0; i < 2; i++) {
        int seen = 0;
        seen += 5;
        printf("%d ", seen);
    }
    printf("\n");
    return 0;
}
--- options
* 5 5
5 10
10 10
0 0
--- explain
Each pass through the loop creates a new `seen` and sets it to 0 before adding 5. Nothing carries over from the previous pass, so both passes print 5. Initializing a local variable inside the loop is how you guarantee a fresh start each time.
```

## static local variables

Adding `static` to a local variable changes its lifetime. It lives for the entire run of the program, but its name is still visible only inside its block. It also keeps its value between calls. Static locals are initialized once, before the program starts running `main`.

```c predict id=static-counter title="What does this print?"
#include <stdio.h>

int next_id(void) {
    static int id = 100;
    return id++;
}

int main(void) {
    int a = next_id();
    int b = next_id();
    printf("%d %d\n", a, b);
    return 0;
}
--- options
* 100 101
100 100
101 102
1 2
--- explain
The `static int id` is created once, with the value 100. The first call returns 100 and increments `id` to 101, and the second call returns 101. Because the variable persists, the function remembers how many times it has run. A non-`static` local would start from 100 every time.
```

> **Pitfall:** `static` local variables are shared by every call, so they are not thread-safe. If you ever write code that runs on several threads at once, a `static` counter needs protection.

## Global variables

A variable declared outside any function is global. It has file scope, lasting for the whole program, and any function in the file can read or change it. Globals are convenient, and they are also the hardest variables to reason about, because any function can change them at any time. Prefer passing values as parameters, and keep globals for values that truly belong to the whole program, such as a configuration flag.

> **In the wild:** Operating system kernels and embedded firmware use many globals, but they document each one carefully. In your own programs, if you find yourself adding a global to avoid passing a value, that is usually a sign that the function needs a parameter.

## Recap

- Scope is where a name is visible. Lifetime is how long its memory exists.
- A local variable lives in its block and is recreated each time that block runs.
- An inner variable can shadow an outer one with the same name.
- A `static` local keeps its value across calls, and it is initialized once.
- Global variables are visible everywhere, so use them sparingly.

**Up next:** arrays, which store many values of one type in a row.
