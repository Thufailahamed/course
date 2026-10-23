Sorting turns unordered data into something you can search, compare and display predictably. Java provides ready-made sorts; you rarely need to write the algorithm yourself.

## Sorting arrays

```java run
int[] scores = {90, 72, 85, 96, 77};
Arrays.sort(scores);
System.out.println(Arrays.toString(scores));

String[] names = {"Grace", "Ada", "Alan"};
Arrays.sort(names);
System.out.println(Arrays.toString(names));
```

`Arrays.sort` sorts numbers ascending and strings in lexicographic order. It modifies the array in place and returns nothing.

## Sorting lists

```java run
ArrayList<String> colors = new ArrayList<>(Arrays.asList("red", "blue", "green"));
Collections.sort(colors);
System.out.println(colors);

ArrayList<Integer> numbers = new ArrayList<>(Arrays.asList(9, 2, 7));
Collections.sort(numbers);
System.out.println(numbers);
```

`Collections.sort` works on lists. For a `List<String>`, the natural order is alphabetical. For a `List<Integer>`, it is numeric.

## Custom order with Comparator

```java run
Integer[] values = {3, 1, 2};
Arrays.sort(values, Collections.reverseOrder());
System.out.println(Arrays.toString(values));

ArrayList<String> words = new ArrayList<>(Arrays.asList("java", "code", "test"));
words.sort(Comparator.comparingInt(String::length));
System.out.println(words);
```

`Collections.reverseOrder()` gives descending order. `Comparator.comparingInt(String::length)` sorts by string length. A comparator returns a negative number, zero, or a positive number to say whether the first item comes before, equal to, or after the second.

Primitive arrays such as `int[]` cannot use `reverseOrder()` directly because it needs objects. Use `Integer[]` when you need a custom comparator, or sort ascending and reverse the result yourself.

## Sorting part of an array

```java run
Integer[] values = {9, 4, 7, 1, 3};
Arrays.sort(values, 1, 4);
System.out.println(Arrays.toString(values));

ArrayList<String> words = new ArrayList<>(Arrays.asList("pear", "apple", "fig"));
words.sort(Comparator.reverseOrder());
System.out.println(words);
```

The three-argument `Arrays.sort(array, from, to)` sorts only indexes `from` through `to - 1`, leaving the rest untouched. `Comparator.reverseOrder()` works on the list because its elements are objects.

```java predict id=sorting-predict title="What is printed?"
Integer[] nums = {3, 1, 2};
Arrays.sort(nums, Collections.reverseOrder());
System.out.println(Arrays.toString(nums));
--- options
* [3, 2, 1]
[1, 2, 3]
[3, 1, 2]
[2, 1, 3]
--- explain
`reverseOrder()` sorts from largest to smallest, so the output is `[3, 2, 1]`.
```

## Challenges

```java exercise id=sort-scores title="Sort scores ascending"
int[] scores = {90, 72, 85, 96, 77};

// Sort the array in ascending order.
--- solution
int[] scores = {90, 72, 85, 96, 77};
Arrays.sort(scores);
--- test
__check(Arrays.equals(scores, new int[]{72, 77, 85, 90, 96}), "The scores should be sorted from low to high");
--- hint
Use `Arrays.sort` on the array.
--- hint
`Arrays.sort(scores);`
```

```java exercise id=sort-words-by-length title="Sort words by length"
ArrayList<String> words = new ArrayList<>(Arrays.asList("programming", "java", "code"));

// Sort shortest first. Ties may stay in any order.
--- solution
ArrayList<String> words = new ArrayList<>(Arrays.asList("programming", "java", "code"));
words.sort(Comparator.comparingInt(String::length));
--- test
__check(words.get(0).length() <= words.get(1).length() && words.get(1).length() <= words.get(2).length(), "The words should be ordered from shortest to longest");
--- hint
Use `Comparator.comparingInt`.
--- hint
`words.sort(Comparator.comparingInt(String::length));`
```

```java debug id=fix-sort-direction title="The list is sorted backwards"
Integer[] values = {1, 3, 2};
Arrays.sort(values, Collections.reverseOrder());
System.out.println(Arrays.toString(values));
--- solution
Integer[] values = {1, 3, 2};
Arrays.sort(values);
System.out.println(Arrays.toString(values));
--- test
__check(__out().trim().equals("[1, 2, 3]"), "The output should be [1, 2, 3]");
--- hint
The task asks for ascending order, but `reverseOrder()` sorts descending.
--- hint
Remove the comparator: `Arrays.sort(values);`
```
