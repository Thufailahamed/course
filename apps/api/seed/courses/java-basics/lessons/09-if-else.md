`if` runs a block only when a condition is true. `else` runs when it is false. `else if` chains several possibilities, and only the first matching branch runs.

## A single decision

```java run
int temperature = 31;

if (temperature > 30) {
    System.out.println("It is hot.");
}

System.out.println("Done checking.");
```

The braces define the block controlled by the `if`. The final line always runs because it is outside the braces. Indentation is for humans; the braces are what the compiler follows.

## Two branches

```java run
int age = 16;

if (age >= 18) {
    System.out.println("Adult");
} else {
    System.out.println("Minor");
}
```

Exactly one of the two blocks runs. The condition must be a `boolean`; Java will not accept `if (age)` the way some languages do.

## Several branches

```java run
int score = 85;

if (score >= 90) {
    System.out.println("A");
} else if (score >= 80) {
    System.out.println("B");
} else if (score >= 70) {
    System.out.println("C");
} else {
    System.out.println("Needs work");
}
```

Order matters. Once a condition matches, the rest are skipped. If the first check were `score >= 70`, an 85 would get a `C` and the later branches would never be considered.

## The conditional operator

For a short either/or choice, the ternary operator is compact:

```java run
int stock = 0;
String status = stock > 0 ? "In stock" : "Sold out";
System.out.println(status);

int a = 12;
int b = 30;
int larger = a > b ? a : b;
System.out.println(larger);
```

`condition ? valueIfTrue : valueIfFalse` produces a value. Use it when both choices are simple; a full `if` is easier to read when the branches contain several statements.

```java predict id=if-else-predict title="What is printed?"
int score = 85;
if (score >= 90) {
    System.out.println("A");
} else if (score >= 80) {
    System.out.println("B");
} else {
    System.out.println("C");
}
--- options
* B
A
C
B
C
--- explain
The first condition is false. The second, `score >= 80`, is true, so `B` prints and the `else` is skipped.
```

## Challenges

```java exercise id=grade-letter title="Turn a score into a letter grade"
int score = 85;
String grade = "";

// 90+ is A, 80-89 is B, 70-79 is C, below 70 is F.
--- solution
int score = 85;
String grade;

if (score >= 90) {
    grade = "A";
} else if (score >= 80) {
    grade = "B";
} else if (score >= 70) {
    grade = "C";
} else {
    grade = "F";
}
--- test
__check(grade.equals("B"), "85 should be a B");
--- hint
Check the highest threshold first, then work downward.
--- hint
Assign `grade` in each branch and leave the declaration without an initial value if you prefer.
```

```java exercise id=even-odd title="Print even or odd"
int number = 7;

// Print "even" when the number is divisible by 2, otherwise "odd".
--- solution
int number = 7;
if (number % 2 == 0) {
    System.out.println("even");
} else {
    System.out.println("odd");
}
--- test
__check(__out().trim().equals("odd"), "7 is odd");
--- hint
A number is even when `number % 2 == 0`.
--- hint
Print `"even"` in the `if` branch and `"odd"` in the `else` branch.
```

```java debug id=fix-grade-order title="The top score gets the wrong grade"
int score = 95;
String grade;

if (score >= 60) {
    grade = "D";
} else if (score >= 80) {
    grade = "B";
} else if (score >= 90) {
    grade = "A";
} else {
    grade = "F";
}

System.out.println(grade);
--- solution
int score = 95;
String grade;

if (score >= 90) {
    grade = "A";
} else if (score >= 80) {
    grade = "B";
} else if (score >= 60) {
    grade = "D";
} else {
    grade = "F";
}

System.out.println(grade);
--- test
__check(__out().trim().equals("A"), "A score of 95 is an A");
--- hint
An `else if` chain stops at the first true condition. A 95 matches `score >= 60` first.
--- hint
Put the strictest, highest threshold first.
```
