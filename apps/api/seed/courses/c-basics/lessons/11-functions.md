A function is a named block of code that takes inputs, does work and optionally produces a result. Functions are how you stop repeating yourself, how you give a piece of logic a name that explains it, and how you break a large problem into parts you can test one at a time. Every C program is built out of them.

## Defining and calling a function

```c
#include <stdio.h>

int add(int a, int b) {
    return a + b;
}

int main(void) {
    int total = add(3, 4);
    printf("%d\n", total);
    return 0;
}
```

Read the definition from left to right. `int` is the return type, `add` is the name, and `(int a, int b)` are the parameters, which are local names for the values the caller passes in. `return` sends a value back to the caller. A function with the return type `void` returns nothing.

When you call `add(3, 4)`, the values `3` and `4` are copied into `a` and `b`. Inside `add`, those copies are the only things it touches.

## Parameters are copies

C passes arguments by value. The function receives a copy, so changing a parameter does not change the caller's variable. This is one of the most important rules in C, and the next predict question checks it.

```c predict id=by-value title="What does this print?"
#include <stdio.h>

void bump(int n) {
    n = n + 10;
}

int main(void) {
    int x = 1;
    bump(x);
    printf("%d\n", x);
    return 0;
}
--- options
* 1
11
10
0
--- explain
`bump` receives a copy of `x`. It changes its own copy, `n`, to 11, and then returns. The variable `x` in `main` was never touched, so it still holds 1. To let a function change a caller's variable, pass its address, which lesson 15 covers.
```

## Return values

A `return` statement ends the function and gives the value back. The value is an expression, so you can compute it inline, and calls can nest inside other calls.

```c predict id=return-expr title="What does this print?"
#include <stdio.h>

int square(int n) {
    return n * n;
}

int main(void) {
    printf("%d\n", square(square(3)));
    return 0;
}
--- options
* 81
18
27
9
--- explain
The inner call `square(3)` returns 9. That value becomes the argument to the outer call, `square(9)`, which returns 81. C evaluates the inner call first because its result is needed. Each function call is a separate step with its own parameters.
```

> **Pitfall:** A function that promises a value must return one on every path. Falling off the end of a non-`void` function and using the result is undefined behavior. Compilers warn about it with `-Wall`.

## Prototypes and order

C reads your file from top to bottom. If you call a function before its definition, the compiler does not yet know its return type and parameters. A **prototype** declares the function ahead of time, so you can define it later in the file, or in another file entirely.

```c
int square(int n);   /* prototype: the signature, ending with a semicolon */

int main(void) {
    return square(4) == 16 ? 0 : 1;
}

int square(int n) {  /* definition */
    return n * n;
}
```

Put prototypes for public functions in a header file, and definitions in a source file. Lesson 20 explains how the preprocessor makes that work.

## Recursion

A function can call itself. Recursion expresses a problem in terms of a smaller version of itself, and it needs a base case that stops the calls. Here is the factorial function, which multiplies the numbers from 1 up to n.

```c predict id=factorial title="What does this print?"
#include <stdio.h>

unsigned long long factorial(unsigned int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}

int main(void) {
    printf("%llu\n", factorial(5));
    return 0;
}
--- options
* 120
24
100
5
--- explain
`factorial(5)` multiplies 5 by `factorial(4)`, which multiplies 4 by `factorial(3)`, and so on until `factorial(1)` returns 1 as the base case. The product is 5 × 4 × 3 × 2 × 1, which is 120. The `%llu` specifier matches the `unsigned long long` return type.
```

> **Tip:** Recursion is elegant, but each call uses stack space. For very deep recursion, a loop is safer. You will meet this trade-off again in the advanced course.

## Designing a good function

A good function does one job, has a name that says what it does, and takes the inputs it needs rather than reaching into global state. If you cannot describe a function in a single sentence, split it. Small functions are easier to test, and the test is a predict question you can ask yourself before you run the code.

## Recap

- A function has a return type, a name, parameters and a body. `void` means it returns nothing.
- C passes arguments by value. The function changes a copy, not the caller's variable.
- `return` sends a value back, and every path of a non-`void` function must return one.
- A prototype declares a function before its definition, so the order of definitions no longer matters.
- Recursion needs a base case, and deep recursion uses a lot of stack.

**Up next:** scope and lifetime, which decide where a variable is visible and how long it lives.
