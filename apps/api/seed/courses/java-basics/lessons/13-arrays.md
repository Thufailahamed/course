An **array** holds a fixed number of values of the same type. The length is chosen when the array is created and never changes. Arrays are the foundation for lists, tables, and most of the data structures you will meet later.

## Creating an array

```java run
int[] scores = {90, 85, 77, 96};

System.out.println(scores.length);
System.out.println(scores[0]);
System.out.println(scores[3]);
System.out.println(Arrays.toString(scores));
```

The square brackets after the type mean "array of `int`". `length` is a field, not a method, so there are no parentheses. Indexes start at 0, so the last valid index is `length - 1`.

`Arrays.toString` turns the whole array into readable text. Printing the array directly would show a memory-style reference such as `[I@1b6d3586`, which is rarely useful.

## Default values

```java run
int[] counts = new int[4];
boolean[] flags = new boolean[3];
String[] names = new String[2];

System.out.println(Arrays.toString(counts));
System.out.println(Arrays.toString(flags));
System.out.println(Arrays.toString(names));
```

A new numeric array is filled with `0`, a boolean array with `false`, and an object array with `null`. You can assign values later:

```java run
int[] counts = new int[4];
counts[0] = 7;
counts[2] = 4;
System.out.println(Arrays.toString(counts));
```

## Walking an array

```java run
int[] values = {4, 8, 15, 16, 23, 42};
int sum = 0;

for (int i = 0; i < values.length; i++) {
    sum += values[i];
}
System.out.println("Sum: " + sum);

for (int value : values) {
    System.out.print(value + " ");
}
System.out.println();
```

The classic `for` loop gives you the index, which you need when the position matters. The enhanced `for` loop gives you each value directly, which is shorter and less error-prone. Use `i < values.length`, never `i <= values.length`; the latter reads one past the end and throws `ArrayIndexOutOfBoundsException`.

## Two-dimensional arrays

```java run
int[][] grid = {
    {1, 2, 3},
    {4, 5, 6}
};

System.out.println(grid.length);
System.out.println(grid[0].length);
System.out.println(grid[1][2]);
```

`grid.length` is the number of rows. `grid[0].length` is the number of columns in the first row. Java arrays can even be ragged, with rows of different lengths.

```java predict id=arrays-predict title="What is printed?"
int[] nums = {3, 6, 9};
System.out.println(nums[1] + nums.length);
--- options
* 9
6
3
12
--- explain
`nums[1]` is `6` and `nums.length` is `3`. Their sum is `9`.
```

## Challenges

```java exercise id=sum-array title="Sum an array"
int[] values = {4, 8, 15, 16, 23, 42};
int sum = 0;

// Add every element to sum.
--- solution
int[] values = {4, 8, 15, 16, 23, 42};
int sum = 0;

for (int i = 0; i < values.length; i++) {
    sum += values[i];
}
--- test
__check(sum == 108, "The values add up to 108");
--- hint
Loop from `0` while `i < values.length`.
--- hint
Add `values[i]` to `sum` inside the loop.
```

```java exercise id=max-array title="Find the largest value"
int[] values = {4, 8, 15, 16, 23, 42};
int max = values[0];

// Compare every element with max and keep the larger one.
--- solution
int[] values = {4, 8, 15, 16, 23, 42};
int max = values[0];

for (int i = 1; i < values.length; i++) {
    if (values[i] > max) {
        max = values[i];
    }
}
--- test
__check(max == 42, "42 is the largest value");
--- hint
Start with the first element, then compare the rest.
--- hint
If `values[i] > max`, assign `values[i]` to `max`.
```

```java debug id=fix-array-bound title="The loop runs past the end"
int[] scores = {10, 20, 30};
int sum = 0;

for (int i = 0; i <= scores.length; i++) {
    sum += scores[i];
}
--- solution
int[] scores = {10, 20, 30};
int sum = 0;

for (int i = 0; i < scores.length; i++) {
    sum += scores[i];
}
--- test
__check(sum == 60, "The three scores add up to 60");
--- hint
The valid indexes are `0`, `1` and `2`. `length` is `3`.
--- hint
Use `<` instead of `<=` in the loop condition.
```
