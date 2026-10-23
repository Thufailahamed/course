Here is the fact that connects pointers and arrays, and once you have it, a lot of C clicks into place. In most expressions, an array name turns into a pointer to its first element. That means `arr[i]` and `*(arr + i)` are the same thing. Pointer arithmetic is the rule that makes the second form work, and the same rule explains why a function receiving an array cannot know its length.

## Arrays decay to pointers

```c
#include <stdio.h>

int main(void) {
    int nums[] = {10, 20, 30, 40};
    int *first = nums;    /* same as &nums[0] */

    printf("%d %d\n", *first, first[2]);
    return 0;
}
```

The assignment `int *first = nums;` works because `nums` becomes the address of its first element. From there, `first[2]` means "two elements past the first one", which is `nums[2]`. Indexing is defined in terms of pointers, not the other way around.

## Pointer arithmetic

Adding an integer to a pointer moves it by that many elements, not bytes. The compiler multiplies by the size of the pointed-to type for you. That is why the arithmetic is safe and portable.

```c predict id=ptr-arith title="What does this print?"
#include <stdio.h>

int main(void) {
    int nums[] = {10, 20, 30, 40};
    int *p = nums + 1;
    printf("%d %d\n", *p, p[2]);
    return 0;
}
--- options
* 20 40
20 30
10 40
30 40
--- explain
`nums + 1` points at the second element, which holds 20, so `*p` is 20. `p[2]` means two elements beyond `p`, which is `nums[3]`, holding 40. The compiler moves the pointer by `sizeof(int)` bytes for each element, so you never have to count bytes yourself.
```

Subtracting two pointers into the same array gives the number of elements between them. The result has the type `ptrdiff_t`, which you print with `%td`.

```c predict id=ptr-diff title="What does this print?"
#include <stdio.h>

int main(void) {
    double vals[5];
    double *start = &vals[1];
    double *end = &vals[4];
    printf("%td\n", end - start);
    return 0;
}
--- options
* 3
4
24
32
--- explain
`end` points to element 4 and `start` points to element 1, so the difference is 3 elements. The number of bytes between them is 24, because each `double` is 8 bytes, but pointer subtraction counts elements. Subtracting pointers that point into different arrays is undefined behavior, so keep both pointers inside the same array.
```

## The same thing three ways

Because of decay, these three expressions are equivalent when `i` is a valid index:

```c
arr[i]
*(arr + i)
*(i + arr)
```

The last form looks odd, but it is legal, because addition is commutative. Nobody writes it in real code, although the predict question below uses it to test whether you understand the rule.

```c predict id=equivalence title="What does this print?"
#include <stdio.h>

int main(void) {
    int arr[] = {3, 6, 9};
    int i = 2;
    printf("%d %d\n", arr[i], *(i + arr));
    return 0;
}
--- options
* 9 9
9 6
3 9
6 9
--- explain
`arr[i]` and `*(i + arr)` both refer to element 2, which holds 9. The expression `i + arr` is the address two elements past the start of `arr`, and dereferencing it gives the same value. The forms are equivalent because `a[b]` is defined as `*(a + b)` in the standard.
```

## Why a function needs the length

When you pass an array to a function, you pass a pointer to its first element. The function has no way to know the array's size, because `sizeof` inside the function measures the pointer, not the array. That is why the length must travel with the pointer.

```c
#include <stdio.h>

void print_all(const int *values, size_t count) {
    for (size_t i = 0; i < count; i++) {
        printf("%d ", values[i]);
    }
    printf("\n");
}

int main(void) {
    int data[] = {1, 2, 3};
    print_all(data, sizeof data / sizeof data[0]);
    return 0;
}
```

The parameter `const int *values` and `const int values[]` mean the same thing. The compiler treats both as a pointer.

> **In the wild:** Nearly every C library function that processes a buffer takes a pointer and a length: `fwrite`, `memcpy`, `snprintf`. Learning that pattern early keeps your code safe.

## Recap

- In most expressions an array name becomes a pointer to its first element.
- `arr[i]` is defined as `*(arr + i)`, so both forms are equivalent.
- Pointer arithmetic moves by whole elements, and pointer subtraction counts elements.
- A function receiving an array gets a pointer, so it needs the length passed separately.
- Keep pointer arithmetic inside the bounds of one array.

**Up next:** memory you choose the size of at runtime, with `malloc` and `free`.
