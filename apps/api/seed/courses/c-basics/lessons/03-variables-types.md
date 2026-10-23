A variable is a named place in memory that holds a value. In C you must say what kind of value it holds before you use it, and that decision shapes everything the variable can do. Choose the wrong type and the program still compiles, but it quietly computes something else.

## Declaring and initializing

A declaration gives a variable a type and a name. Initializing it gives the variable its first value:

```c
int count = 3;          // declare and initialize
double price;           // declare only
price = 4.50;           // assign later
```

> **Pitfall:** A variable declared without an initial value holds whatever bytes were already in that memory. Reading it before assigning it is undefined behavior, and compilers warn about it for good reason. Always initialize your variables.

## The basic types

These are the types you will use most often:

| Type | Typical size | Holds |
|---|---|---|
| `char` | 1 byte | a single character, or a small integer |
| `int` | 4 bytes | a whole number, usually from about −2 billion to +2 billion |
| `long` | 4 or 8 bytes | a larger whole number |
| `float` | 4 bytes | a decimal number with about 7 significant digits |
| `double` | 8 bytes | a decimal number with about 15 significant digits |

The sizes are typical rather than guaranteed. The C standard sets minimum ranges and a size order (`char` is no larger than `short`, which is no larger than `int`, and so on), and the real sizes depend on the platform. That is why C gives you `sizeof`.

## sizeof

`sizeof` returns the size of a type or variable, in bytes. It is evaluated at compile time, and its result has the type `size_t`, which you print with `%zu`.

```c predict id=sizeof-char-int title="How many bytes?"
#include <stdio.h>

int main(void) {
    char letter = 'A';
    printf("%zu %zu\n", sizeof letter, sizeof(int));
    return 0;
}
--- options
* 1 4
1 1
4 4
2 4
--- explain
A `char` is exactly one byte by definition, so `sizeof letter` is `1`. An `int` is four bytes on most common platforms, and `sizeof(int)` reports that number. The second value is platform-dependent in principle, but `4` is the usual result on desktop systems.
```

## Characters and their codes

A `char` stores a small integer, and that integer is the character's code. The character `'A'` is stored as the number `65` in the ASCII encoding. You can use a `char` in arithmetic, which is handy and surprising at the same time.

```c predict id=char-arithmetic title="What does this print?"
#include <stdio.h>

int main(void) {
    char c = 'A';
    printf("%c %d\n", c, c + 1);
    return 0;
}
--- options
* A 66
A 65
65 66
B 66
--- explain
`c` holds the code 65 for `'A'`. The `%c` specifier prints it as the character `A`. `c + 1` is the integer `66`, which `%d` prints as a number. Adding 1 to a letter's code gives the next letter, which is how many character-processing programs work.
```

> **Tip:** Use single quotes for characters (`'A'`) and double quotes for strings (`"A"`). The first is one `char`. The second is an array of two characters, `'A'` followed by a terminator.

## Naming and reading code

Good names make code easier to read. Use lowercase words separated by underscores, such as `total_score`, and pick names that say what a value means, not just what type it is. `count` says more than `i` when the value is a number of students.

## Assignment and conversion

Assignment copies a value into a variable. If the value's type differs from the variable's type, C converts it, and sometimes that conversion loses information.

```c predict id=float-to-int title="What does this print?"
#include <stdio.h>

int main(void) {
    double price = 9.99;
    int whole = price;
    printf("%d\n", whole);
    return 0;
}
--- options
* 9
10
9.99
0
--- explain
Converting a floating-point value to an integer throws away the fractional part. C truncates toward zero, so `9.99` becomes `9`, not `10`. Rounding is something you request explicitly, for example with `round()` from `<math.h>`.
```

> **In the wild:** Silent truncation like this is behind many real bugs, such as a price stored as an integer of cents that gets rounded down. Choose the type that matches the meaning of the data, and convert on purpose.

## A worked example

Here is a complete program that uses several types together:

```c
#include <stdio.h>

int main(void) {
    int students = 24;
    double total_points = 1842.5;
    double average = total_points / students;

    printf("Students: %d\n", students);
    printf("Average: %.2f\n", average);
    return 0;
}
```

`%.2f` prints a `double` with two digits after the decimal point. You will see format specifiers in detail in lesson 06.

## Recap

- A variable has a type, a name and a value. Declare it, then initialize it.
- Always give variables a starting value. Reading an uninitialized variable is undefined behavior.
- `int` holds whole numbers, `double` holds decimals, and `char` holds small codes such as letters.
- `sizeof` gives sizes in bytes and returns a `size_t`, printed with `%zu`.
- Converting a `double` to an `int` truncates the fraction.

**Up next:** integers, floating-point numbers and the traps between them.
