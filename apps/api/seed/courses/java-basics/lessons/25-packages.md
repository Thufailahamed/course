Java organises classes into **packages**. A package is a namespace: it keeps `Date` from one library separate from `Date` in another, and it gives classes a stable full name such as `java.util.ArrayList`.

## Imports

```java run class
import java.util.ArrayList;

public class Main {
    public static void main(String[] args) {
        ArrayList<String> names = new ArrayList<>();
        names.add("Ada");
        names.add("Grace");
        System.out.println(names);
    }
}
```

`import java.util.ArrayList;` lets you write `ArrayList` instead of the full name. Imports go after the package declaration and before the class. The runtime places your class in a package automatically, so the cell starts directly with the import.

A wildcard import brings in every class from a package:

```java run class
import java.util.*;

public class Main {
    public static void main(String[] args) {
        HashMap<String, Integer> ages = new HashMap<>();
        ages.put("Ada", 36);
        System.out.println(ages.get("Ada"));
    }
}
```

Wildcards are convenient while learning. In a large codebase, explicit imports make it easier to see where each name comes from.

## Fully qualified names

You can always use the full name and skip the import:

```java run class
public class Main {
    public static void main(String[] args) {
        java.util.ArrayList<String> items = new java.util.ArrayList<>();
        items.add("pen");
        items.add("paper");
        System.out.println(items.size());
    }
}
```

This is useful when two packages contain classes with the same simple name, because importing both would make the short name ambiguous.

## Static imports

A static import lets you call a class's static members without the class name:

```java run class
import static java.lang.Math.*;

public class Main {
    public static void main(String[] args) {
        System.out.println(sqrt(81));
        System.out.println(max(3, 9));
        System.out.println(PI);
    }
}
```

Use static imports sparingly. `sqrt(81)` is readable in a maths-heavy method, but `abs(x)` without context can be harder to trace than `Math.abs(x)`.

## java.lang is automatic

```java run class
public class Main {
    public static void main(String[] args) {
        String text = "hello";
        System.out.println(text.toUpperCase());
        System.out.println(Integer.parseInt("42"));
    }
}
```

`String`, `System`, `Integer`, `Math` and the wrapper classes live in `java.lang`, which is imported automatically. That is why you have never needed an import for `System.out`.

```java predict class id=packages-predict title="What is printed?"
import static java.lang.Math.*;

public class Main {
    public static void main(String[] args) {
        System.out.println(sqrt(16));
    }
}
--- options
* 4.0
4
16.0
compile error
--- explain
`Math.sqrt` returns a `double`, and `sqrt(16)` is `4.0`. The static import only removes the need to write `Math.`.
```

## Challenges

```java exercise class id=use-import title="Use an imported ArrayList"
// Add the import and finish count().

public class Main {
    static int count() {
        return 0;
    }

    public static void main(String[] args) {
        System.out.println(count());
    }
}
--- solution
import java.util.ArrayList;

public class Main {
    static int count() {
        ArrayList<String> items = new ArrayList<>();
        items.add("one");
        items.add("two");
        return items.size();
    }

    public static void main(String[] args) {
        System.out.println(count());
    }
}
--- test
__check(Main.count() == 2, "The list should contain two items");
--- hint
Add `import java.util.ArrayList;` above the class.
--- hint
Create the list, add two strings, and return `items.size()`.
```

```java exercise class id=fully-qualified-map title="Use a fully qualified name"
public class Main {
    // Define static int size() using java.util.HashMap without an import.

    public static void main(String[] args) {
        System.out.println(size());
    }
}
--- solution
public class Main {
    static int size() {
        java.util.HashMap<String, Integer> map = new java.util.HashMap<>();
        map.put("a", 1);
        return map.size();
    }

    public static void main(String[] args) {
        System.out.println(size());
    }
}
--- test
__check(Main.size() == 1, "The map should contain one entry");
--- hint
Write the full type name `java.util.HashMap` in the declaration and the constructor.
--- hint
Put one entry in the map and return `map.size()`.
```

```java debug class id=fix-missing-import title="DecimalFormat cannot be found"
public class Main {
    public static void main(String[] args) {
        DecimalFormat format = new DecimalFormat("0.00");
        System.out.println(format.format(2.5));
    }
}
--- solution
import java.text.DecimalFormat;

public class Main {
    public static void main(String[] args) {
        DecimalFormat format = new DecimalFormat("0.00");
        System.out.println(format.format(2.5));
    }
}
--- test
__runMain();
__check(__out().trim().equals("2.50"), "The program should print 2.50");
--- hint
The compiler does not know the short name `DecimalFormat`.
--- hint
Add `import java.text.DecimalFormat;` at the top.
```
