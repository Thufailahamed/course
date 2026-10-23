Good methods are small, named clearly, and do one job. This lesson collects patterns you will use constantly: decomposing a problem into helpers, accepting a variable number of arguments, returning an array, and guarding against empty input.

## Decomposition

```java run class
public class Main {
    static int total(int[] scores) {
        int sum = 0;
        for (int score : scores) {
            sum += score;
        }
        return sum;
    }

    static double average(int[] scores) {
        if (scores.length == 0) {
            return 0;
        }
        return (double) total(scores) / scores.length;
    }

    static String grade(double average) {
        if (average >= 90) return "A";
        if (average >= 80) return "B";
        if (average >= 70) return "C";
        return "F";
    }

    public static void main(String[] args) {
        int[] scores = {90, 85, 77, 96};
        System.out.println(total(scores));
        System.out.println(average(scores));
        System.out.println(grade(average(scores)));
    }
}
```

Each method has one responsibility: add, average, or grade. `average` reuses `total`; `grade` reuses `average`. If the grading rule changes, only one method changes.

## Variable arguments

```java run class
public class Main {
    static int sum(int... numbers) {
        int total = 0;
        for (int n : numbers) {
            total += n;
        }
        return total;
    }

    public static void main(String[] args) {
        System.out.println(sum());
        System.out.println(sum(5));
        System.out.println(sum(1, 2, 3, 4));
    }
}
```

`int... numbers` accepts zero or more integers and packs them into an array. A method can have only one varargs parameter, and it must come last.

## Returning an array

```java run class
public class Main {
    static int[] evens(int[] values) {
        int count = 0;
        for (int value : values) {
            if (value % 2 == 0) {
                count++;
            }
        }

        int[] result = new int[count];
        int index = 0;
        for (int value : values) {
            if (value % 2 == 0) {
                result[index] = value;
                index++;
            }
        }
        return result;
    }

    public static void main(String[] args) {
        int[] result = evens(new int[]{3, 4, 8, 9, 10});
        System.out.println(Arrays.toString(result));
    }
}
```

The first pass counts how many values qualify; the second fills an array of exactly that size. This two-pass pattern avoids returning arrays with unused zeros at the end.

## Guard clauses

```java run class
public class Main {
    static String label(String name) {
        if (name == null || name.trim().isEmpty()) {
            return "anonymous";
        }
        return name.trim();
    }

    public static void main(String[] args) {
        System.out.println(label("  Ada  "));
        System.out.println(label(""));
        System.out.println(label(null));
    }
}
```

A **guard clause** handles the invalid case first and returns early. The main path stays unindented and easy to read. This is usually clearer than nesting the whole method inside an `if`.

```java predict class id=method-patterns-predict title="What is printed?"
public class Main {
    static int sum(int... numbers) {
        int total = 0;
        for (int n : numbers) total += n;
        return total;
    }

    public static void main(String[] args) {
        System.out.println(sum(1, 2, 3));
    }
}
--- options
* 6
3
1
compile error
--- explain
`1 + 2 + 3 = 6`. The varargs parameter collects all three arguments into an array and the loop adds them.
```

## Challenges

```java exercise class id=count-vowels title="Count the vowels in a word"
public class Main {
    // Define static int countVowels(String text).

    public static void main(String[] args) {
        System.out.println(countVowels("programming"));
    }
}
--- solution
public class Main {
    static int countVowels(String text) {
        int count = 0;
        String vowels = "aeiou";
        for (int i = 0; i < text.length(); i++) {
            if (vowels.indexOf(text.charAt(i)) >= 0) {
                count++;
            }
        }
        return count;
    }

    public static void main(String[] args) {
        System.out.println(countVowels("programming"));
    }
}
--- test
__check(Main.countVowels("programming") == 3, "programming has three vowels");
__check(Main.countVowels("xyz") == 0, "xyz has no vowels");
--- hint
Loop through the characters and check whether each one appears in `"aeiou"`.
--- hint
`"aeiou".indexOf(text.charAt(i)) >= 0`
```

```java exercise class id=filter-evens-method title="Return only the even values"
public class Main {
    // Define static int[] evens(int[] values).

    public static void main(String[] args) {
        System.out.println(Arrays.toString(evens(new int[]{1, 2, 4, 5})));
    }
}
--- solution
public class Main {
    static int[] evens(int[] values) {
        int count = 0;
        for (int value : values) {
            if (value % 2 == 0) count++;
        }
        int[] result = new int[count];
        int index = 0;
        for (int value : values) {
            if (value % 2 == 0) {
                result[index++] = value;
            }
        }
        return result;
    }

    public static void main(String[] args) {
        System.out.println(Arrays.toString(evens(new int[]{1, 2, 4, 5})));
    }
}
--- test
__check(Arrays.equals(Main.evens(new int[]{1, 2, 4, 5}), new int[]{2, 4}), "The even values are 2 and 4");
--- hint
Count the evens first so you can size the result array.
--- hint
Use a second index that starts at 0 and increments only when you store an even value.
```

```java debug class id=fix-varargs-sum title="The varargs sum ignores later numbers"
public class Main {
    static int sum(int... numbers) {
        return numbers[0];
    }

    public static void main(String[] args) {
        System.out.println(sum(1, 2, 3));
    }
}
--- solution
public class Main {
    static int sum(int... numbers) {
        int total = 0;
        for (int n : numbers) {
            total += n;
        }
        return total;
    }

    public static void main(String[] args) {
        System.out.println(sum(1, 2, 3));
    }
}
--- test
__check(Main.sum(1, 2, 3) == 6, "1 + 2 + 3 is 6");
__check(Main.sum() == 0, "The empty sum is 0");
--- hint
`numbers` is an array; returning `numbers[0]` returns only the first value.
--- hint
Loop over all the numbers and add them to a running total.
```
