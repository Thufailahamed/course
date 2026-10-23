A `switch` chooses one branch from a list of exact values. It is clearer than a long `if/else if` chain when you are matching a small set of constants such as a day number, a menu item or a command name.

## Switching on an integer

```java run
int day = 3;

switch (day) {
    case 1:
        System.out.println("Monday");
        break;
    case 2:
        System.out.println("Tuesday");
        break;
    case 3:
        System.out.println("Wednesday");
        break;
    default:
        System.out.println("Another day");
}
```

`break` exits the switch. Without it, execution **falls through** into the next case. `default` runs when no case matches; it is optional but usually a good idea.

## Switching on a string

Java 7 and later allow strings in a switch. The comparison is case-sensitive:

```java run
String command = "start";

switch (command) {
    case "start":
        System.out.println("Starting...");
        break;
    case "stop":
        System.out.println("Stopping...");
        break;
    default:
        System.out.println("Unknown command");
}
```

`"Start"` with a capital S would not match `"start"`. Normalise with `toLowerCase()` first if the input may vary.

## Intentional fall-through

Fall-through is sometimes useful when several cases share the same action:

```java run
int month = 4;

switch (month) {
    case 12:
    case 1:
    case 2:
        System.out.println("Winter");
        break;
    case 3:
    case 4:
    case 5:
        System.out.println("Spring");
        break;
    default:
        System.out.println("Another season");
}
```

The empty cases fall through to the next non-empty one. This is the one place where omitting `break` is deliberate; add a comment when you do it so the next reader knows it is not a bug.

```java run
char grade = 'B';

switch (grade) {
    case 'A':
        System.out.println("Excellent");
        break;
    case 'B':
    case 'C':
        System.out.println("Good");
        break;
    default:
        System.out.println("Keep practising");
}
```

`char` works too, because a character is an integer-like value under the hood.

```java predict id=switch-predict title="What is printed?"
int n = 1;
switch (n) {
    case 1:
        System.out.print("one");
    case 2:
        System.out.print("two");
        break;
    default:
        System.out.print("other");
}
System.out.println();
--- options
* onetwo
one
two
one two
--- explain
Case 1 has no `break`, so execution falls through and also runs case 2. Both `print` calls happen before the switch exits, producing `onetwo`.
```

## Challenges

```java exercise id=day-type title="Classify a day with switch"
int day = 6;
String type = "";

// 1-5 are weekdays; 6 and 7 are weekend days.
--- solution
int day = 6;
String type;

switch (day) {
    case 1:
    case 2:
    case 3:
    case 4:
    case 5:
        type = "weekday";
        break;
    case 6:
    case 7:
        type = "weekend";
        break;
    default:
        type = "unknown";
}
--- test
__check(type.equals("weekend"), "Day 6 is a weekend day");
--- hint
Group the weekday cases together and assign once.
--- hint
Cases 6 and 7 can share one branch.
```

```java exercise id=menu-price title="Look up a menu price"
String item = "coffee";
double price = 0;

// coffee = 3.5, tea = 2.5, juice = 4.0, anything else = 0.
--- solution
String item = "coffee";
double price;

switch (item) {
    case "coffee":
        price = 3.5;
        break;
    case "tea":
        price = 2.5;
        break;
    case "juice":
        price = 4.0;
        break;
    default:
        price = 0;
}
--- test
__check(Math.abs(price - 3.5) < 0.0001, "Coffee costs 3.5");
--- hint
Switch on the `String` and assign `price` in each branch.
--- hint
Do not forget the `break` after each case.
```

```java debug id=fix-missing-break title="One case prints two answers"
int choice = 1;
switch (choice) {
    case 1:
        System.out.println("one");
    case 2:
        System.out.println("two");
        break;
    default:
        System.out.println("other");
}
--- solution
int choice = 1;
switch (choice) {
    case 1:
        System.out.println("one");
        break;
    case 2:
        System.out.println("two");
        break;
    default:
        System.out.println("other");
}
--- test
__check(__out().trim().equals("one"), "Choice 1 should print only one");
--- hint
Execution is falling through from case 1 into case 2.
--- hint
Add a `break` after the first `println`.
```
