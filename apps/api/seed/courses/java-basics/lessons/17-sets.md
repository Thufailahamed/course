A `Set` is a collection with **no duplicates**. Adding a value that is already present does nothing. Sets answer "have I seen this?" and "how many distinct values are there?" without any extra bookkeeping.

## HashSet basics

```java run
HashSet<String> tags = new HashSet<>();

tags.add("java");
tags.add("code");
tags.add("java");

System.out.println(tags.size());
System.out.println(tags.contains("code"));
System.out.println(tags.contains("python"));
System.out.println(tags);
```

The second `"java"` is ignored, so the size is `2`. `contains` returns a boolean. Like `HashMap`, `HashSet` does not promise iteration order.

## add returns a boolean

`add` returns `true` when the value was new and `false` when it was already there. That return value is useful for detecting duplicates:

```java run
HashSet<Integer> seen = new HashSet<>();
int[] numbers = {3, 7, 3, 9};

for (int n : numbers) {
    boolean wasNew = seen.add(n);
    System.out.println(n + " new? " + wasNew);
}
```

This is cleaner than calling `contains` and then `add`, because it does both in one step.

## Removing and clearing

```java run
HashSet<String> selected = new HashSet<>();
selected.add("red");
selected.add("green");
selected.add("blue");

selected.remove("green");
System.out.println(selected);
System.out.println(selected.isEmpty());

selected.clear();
System.out.println(selected.size());
```

## Iterating and sorting

```java run
HashSet<String> names = new HashSet<>();
names.add("Ada");
names.add("Grace");
names.add("Alan");

for (String name : names) {
    System.out.println(name);
}

TreeSet<String> sorted = new TreeSet<>(names);
System.out.println(sorted);
```

A `TreeSet` keeps its values in sorted order. Converting a `HashSet` into a `TreeSet` is a quick way to get a deterministic order for display or comparison.

```java predict id=sets-predict title="What is printed?"
HashSet<String> set = new HashSet<>();
set.add("a");
set.add("a");
set.add("b");
System.out.println(set.size());
--- options
* 2
1
3
0
--- explain
The second `"a"` is a duplicate and is ignored. The set contains `"a"` and `"b"`, so its size is `2`.
```

## Challenges

```java exercise id=count-unique title="Count distinct words"
String[] words = {"java", "code", "java", "test", "code"};
HashSet<String> unique = new HashSet<>();

// Add every word to the set, then read its size.
int count = 0;
--- solution
String[] words = {"java", "code", "java", "test", "code"};
HashSet<String> unique = new HashSet<>();

for (String word : words) {
    unique.add(word);
}
int count = unique.size();
--- test
__check(count == 3, "There are three distinct words");
--- hint
A `HashSet` ignores duplicates automatically.
--- hint
Loop through `words`, then set `count = unique.size()`.
```

```java exercise id=has-duplicate title="Detect whether an array has duplicates"
int[] numbers = {4, 8, 15, 8};
boolean hasDuplicate = false;
HashSet<Integer> seen = new HashSet<>();

// Set hasDuplicate to true if any value appears more than once.
--- solution
int[] numbers = {4, 8, 15, 8};
boolean hasDuplicate = false;
HashSet<Integer> seen = new HashSet<>();

for (int n : numbers) {
    if (!seen.add(n)) {
        hasDuplicate = true;
        break;
    }
}
--- test
__check(hasDuplicate, "8 appears twice");
--- hint
`seen.add(n)` returns false when `n` was already present.
--- hint
Set `hasDuplicate = true` when `!seen.add(n)`.
```

```java debug id=fix-duplicate-flag title="The duplicate check is backwards"
int[] numbers = {1, 2, 3};
boolean hasDuplicate = false;
HashSet<Integer> seen = new HashSet<>();

for (int n : numbers) {
    if (seen.add(n)) {
        hasDuplicate = true;
    }
}
System.out.println(hasDuplicate);
--- solution
int[] numbers = {1, 2, 3};
boolean hasDuplicate = false;
HashSet<Integer> seen = new HashSet<>();

for (int n : numbers) {
    if (!seen.add(n)) {
        hasDuplicate = true;
    }
}
System.out.println(hasDuplicate);
--- test
__check(__out().trim().equals("false"), "No value repeats, so the flag should stay false");
--- hint
A successful `add` means the value was **new**, not duplicated.
--- hint
Negate the condition: `if (!seen.add(n))`.
```
