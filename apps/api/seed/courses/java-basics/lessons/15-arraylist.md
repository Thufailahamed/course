An array has a fixed length. An `ArrayList` grows and shrinks as you add and remove items, which makes it the default choice for a collection whose size you do not know in advance.

## Creating and adding

```java run
ArrayList<String> names = new ArrayList<>();

names.add("Ada");
names.add("Grace");
names.add("Alan");

System.out.println(names.size());
System.out.println(names.get(0));
System.out.println(names);
```

`ArrayList<String>` means "a list of strings". The angle brackets hold the **type parameter**. `add` appends to the end, `size()` returns the count, and `get(index)` reads an element. Printing the list directly gives a readable `[Ada, Grace, Alan]`.

## Changing and removing

```java run
ArrayList<String> names = new ArrayList<>();
names.add("Ada");
names.add("Grace");
names.add("Alan");

names.set(1, "Hopper");
names.remove("Ada");

System.out.println(names);
System.out.println(names.contains("Hopper"));
System.out.println(names.indexOf("Alan"));
```

`set(index, value)` replaces an element. `remove(value)` removes the first matching value, while `remove(index)` removes by position. After a removal, later elements shift left, so indexes change.

## Walking a list

```java run
ArrayList<Integer> scores = new ArrayList<>();
scores.add(90);
scores.add(85);
scores.add(77);

for (int i = 0; i < scores.size(); i++) {
    System.out.println(i + ": " + scores.get(i));
}

int total = 0;
for (int score : scores) {
    total += score;
}
System.out.println("Total: " + total);
```

Use `size()` rather than a stored length. The enhanced `for` loop is ideal when you only need the values. `ArrayList<Integer>` uses the wrapper class `Integer`, not `int`; Java converts automatically when adding and reading.

## Building from existing values

```java run
ArrayList<String> colors = new ArrayList<>(Arrays.asList("red", "green", "blue"));
System.out.println(colors);
System.out.println(colors.isEmpty());

colors.clear();
System.out.println(colors.isEmpty());
```

`Arrays.asList` creates a fixed-size list view that is useful as a starting point. Copying it into a new `ArrayList` gives you a fully mutable list. `clear()` removes everything.

```java predict id=arraylist-predict title="What is printed?"
ArrayList<String> list = new ArrayList<>();
list.add("a");
list.add("b");
list.add("c");
list.remove(1);
System.out.println(list.get(1));
--- options
* c
b
a
IndexOutOfBoundsException
--- explain
Removing index 1 removes `"b"`. The list becomes `[a, c]`, so index 1 is now `"c"`.
```

## Challenges

```java exercise id=add-names title="Build a list of names"
ArrayList<String> names = new ArrayList<>();

// Add Ada, Grace and Alan in that order.
--- solution
ArrayList<String> names = new ArrayList<>();
names.add("Ada");
names.add("Grace");
names.add("Alan");
--- test
__check(names.size() == 3 && names.get(0).equals("Ada") && names.get(1).equals("Grace") && names.get(2).equals("Alan"), "Add the three names in order");
--- hint
Call `add` once per name.
--- hint
`names.add("Ada");` and so on.
```

```java exercise id=sum-integer-list title="Sum a list of integers"
ArrayList<Integer> numbers = new ArrayList<>(Arrays.asList(3, 6, 9));
int sum = 0;

// Add every number in the list.
--- solution
ArrayList<Integer> numbers = new ArrayList<>(Arrays.asList(3, 6, 9));
int sum = 0;

for (int number : numbers) {
    sum += number;
}
--- test
__check(sum == 18, "3 + 6 + 9 is 18");
--- hint
Use an enhanced `for` loop over `numbers`.
--- hint
`for (int number : numbers) { sum += number; }`
```

```java debug id=fix-list-bound title="The list loop crashes"
ArrayList<Integer> numbers = new ArrayList<>(Arrays.asList(10, 20, 30));
int sum = 0;

for (int i = 0; i <= numbers.size(); i++) {
    sum += numbers.get(i);
}
--- solution
ArrayList<Integer> numbers = new ArrayList<>(Arrays.asList(10, 20, 30));
int sum = 0;

for (int i = 0; i < numbers.size(); i++) {
    sum += numbers.get(i);
}
--- test
__check(sum == 60, "The three numbers add up to 60");
--- hint
Valid indexes are `0` through `size() - 1`.
--- hint
Change `<=` to `<`.
```
