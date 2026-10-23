An array stores a fixed number of values of the same type, laid out one after another in memory. You access each element by its index, which starts at zero. Arrays are the foundation of nearly every data structure in C, and they come with a few rules that are different from other languages. Learn those rules now, and the later lessons on pointers will make much more sense.

## Declaring and using arrays

```c
#include <stdio.h>

int main(void) {
    int scores[4] = {90, 75, 88, 62};

    printf("first: %d\n", scores[0]);
    printf("last:  %d\n", scores[3]);

    scores[1] = 80;   /* arrays can be changed element by element */
    return 0;
}
```

The size is part of the declaration, and it cannot change afterwards. Indexes run from `0` to `size - 1`. Index `4` on a four-element array does not exist, and reading or writing it is undefined behavior. C will not stop you, which is why careful bounds checking is your job.

> **Pitfall:** The most common C bug in history is writing one element past the end of an array. It often works by accident, and then fails in a different place much later. Always check your loop bounds.

## Initializing an array

If you give the size, missing initial values become zero. You can also let the compiler count the elements by leaving the brackets empty.

```c predict id=partial-init title="What does this print?"
#include <stdio.h>

int main(void) {
    int a[5] = {1, 2};
    printf("%d %d\n", a[1], a[4]);
    return 0;
}
--- options
* 2 0
2 4
1 2
2 garbage
--- explain
The first two elements are set to 1 and 2, and the rest of the array is filled with zeros. So `a[1]` is 2, and `a[4]` is 0. This zero-filling applies to arrays with static or automatic storage when you give an initializer list. It is a convenient way to create an array of zeros.
```

To count elements, divide the total size by the size of one element. That pattern works for any array whose type you can see:

```c predict id=array-sum title="What does this print?"
#include <stdio.h>

int main(void) {
    int scores[] = {4, 8, 15};
    int total = 0;
    for (int i = 0; i < 3; i++) total += scores[i];
    printf("%d %zu\n", total, sizeof scores / sizeof scores[0]);
    return 0;
}
--- options
* 27 3
27 12
4 3
27 4
--- explain
The loop adds 4, 8 and 15 to get 27. The array occupies 12 bytes in total, because each `int` is 4 bytes, and each element is 4 bytes, so `sizeof scores / sizeof scores[0]` gives 3 elements. That expression only works where the array's size is known, such as in the function that declared it. It does not work for an array passed to another function, as lesson 16 explains.
```

## Arrays cannot be copied or compared with ==

You cannot assign one array to another, and `==` does not compare contents. To copy an array, copy each element with a loop, or use `memcpy` from `<string.h>`. To compare contents, compare element by element.

```c
int source[3] = {1, 2, 3};
int copy[3];

for (int i = 0; i < 3; i++) {
    copy[i] = source[i];
}
```

## Multidimensional arrays

A two-dimensional array is an array of rows. Indexes are written in pairs, row first, then column. Nested loops are the natural way to visit every cell.

```c predict id=two-d title="What does this print?"
#include <stdio.h>

int main(void) {
    int grid[2][3] = {{1, 2, 3}, {4, 5, 6}};
    printf("%d\n", grid[1][0] + grid[0][2]);
    return 0;
}
--- options
* 7
9
5
6
--- explain
`grid[1][0]` is the first element of the second row, which is 4. `grid[0][2]` is the last element of the first row, which is 3. Their sum is 7. The first index selects the row and the second selects the column, and the memory is laid out row by row.
```

## Passing arrays to functions

When you pass an array to a function, you also pass its length, because the function cannot discover the length itself. Lesson 16 explains the reason. For now, the pattern is simple and worth memorizing:

```c
#include <stdio.h>

int sum(const int values[], size_t count) {
    int total = 0;
    for (size_t i = 0; i < count; i++) {
        total += values[i];
    }
    return total;
}

int main(void) {
    int data[] = {10, 20, 30};
    printf("%d\n", sum(data, sizeof data / sizeof data[0]));
    return 0;
}
```

The `const` tells the reader, and the compiler, that `sum` does not change the array.

## Recap

- An array holds a fixed number of values of one type. Indexes start at 0.
- Stay within the bounds. Index `size` and beyond is undefined behavior.
- Uninitialized elements of an initialized array are zero.
- `sizeof array / sizeof array[0]` counts the elements of an array in its own scope.
- You cannot assign or compare whole arrays with `=` or `==`.
- Pass the length along with an array to a function.

**Up next:** strings, which are arrays of characters with a special terminator.
