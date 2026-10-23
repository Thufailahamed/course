Most array work falls into a few patterns: find something, count something, rearrange something, or copy and sort. Once you recognise the pattern, the loop almost writes itself.

## Searching

A **linear search** checks each element in turn and stops when it finds a match:

```java run
int[] values = {4, 8, 15, 16, 23, 42};
int target = 15;
int foundAt = -1;

for (int i = 0; i < values.length; i++) {
    if (values[i] == target) {
        foundAt = i;
        break;
    }
}

System.out.println(foundAt);
```

Starting at `-1` is a common convention for "not found", because every real index is zero or greater. The `break` stops the search as soon as the answer is known.

## Counting

```java run
int[] votes = {1, 0, 1, 1, 0, 1, 0};
int yes = 0;

for (int vote : votes) {
    if (vote == 1) {
        yes++;
    }
}

System.out.println("Yes: " + yes);
System.out.println("No: " + (votes.length - yes));
```

A counter plus a condition is all a "how many" question needs.

## Reversing in place

To reverse an array without creating another one, swap the ends and move inward:

```java run
int[] nums = {1, 2, 3, 4, 5};

for (int left = 0, right = nums.length - 1; left < right; left++, right--) {
    int temp = nums[left];
    nums[left] = nums[right];
    nums[right] = temp;
}

System.out.println(Arrays.toString(nums));
```

The loop stops when the pointers meet in the middle. Swapping every pair twice would undo the work, so the condition is `left < right`, not `left < nums.length`.

## Copying and sorting

```java run
int[] original = {9, 2, 7, 1};
int[] copy = Arrays.copyOf(original, original.length);

Arrays.sort(copy);

System.out.println(Arrays.toString(original));
System.out.println(Arrays.toString(copy));
System.out.println(Arrays.equals(original, copy));
```

`Arrays.copyOf` creates a new array. Sorting the copy leaves the original untouched. `Arrays.equals` compares contents element by element; `==` would only compare the two array references.

```java predict id=array-algorithms-predict title="What is printed?"
int[] a = {1, 2, 3};
int[] b = Arrays.copyOf(a, 3);
b[0] = 9;
System.out.println(a[0] + " " + b[0]);
--- options
* 1 9
9 9
1 1
9 1
--- explain
`Arrays.copyOf` creates a separate array, so changing `b[0]` does not affect `a[0]`.
```

## Challenges

```java exercise id=contains-value title="Search for a value"
int[] values = {4, 8, 15, 16, 23, 42};
int target = 23;
boolean found = false;

// Set found to true when target appears in the array.
--- solution
int[] values = {4, 8, 15, 16, 23, 42};
int target = 23;
boolean found = false;

for (int value : values) {
    if (value == target) {
        found = true;
        break;
    }
}
--- test
__check(found, "23 is in the array");
--- hint
Loop over the values and compare each one with `target`.
--- hint
Set `found = true` and `break` when you find a match.
```

```java exercise id=reverse-array title="Reverse an array in place"
int[] nums = {1, 2, 3, 4};

// Reverse the elements without creating a new array.
--- solution
int[] nums = {1, 2, 3, 4};

for (int left = 0, right = nums.length - 1; left < right; left++, right--) {
    int temp = nums[left];
    nums[left] = nums[right];
    nums[right] = temp;
}
--- test
__check(Arrays.equals(nums, new int[]{4, 3, 2, 1}), "The array should become 4, 3, 2, 1");
--- hint
Use two indexes, one at each end, and swap inward.
--- hint
Stop when `left >= right`.
```

```java debug id=fix-smallest-after-sort title="The smallest value is wrong"
int[] values = {9, 2, 7};
int smallest = values[0];
Arrays.sort(values);
System.out.println(smallest);
--- solution
int[] values = {9, 2, 7};
Arrays.sort(values);
int smallest = values[0];
System.out.println(smallest);
--- test
__check(__out().trim().equals("2"), "After sorting, the smallest value is 2");
--- hint
`smallest` is read before the array is sorted.
--- hint
Move the assignment below `Arrays.sort(values);`.
```
