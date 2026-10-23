This project combines arrays, methods, formatting and classes into a small grade reporter. You will build it in pieces, then assemble the pieces into one object.

## Step 1: total and average

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

    public static void main(String[] args) {
        int[] scores = {90, 85, 77, 96};
        System.out.println(total(scores));
        System.out.println(average(scores));
    }
}
```

The cast to `double` happens before the division, so the average keeps its decimal part. The empty-array guard avoids dividing by zero.

## Step 2: letter grades

```java run class
public class Main {
    static String letter(double average) {
        if (average >= 90) return "A";
        if (average >= 80) return "B";
        if (average >= 70) return "C";
        return "F";
    }

    public static void main(String[] args) {
        System.out.println(letter(95));
        System.out.println(letter(85));
        System.out.println(letter(72));
        System.out.println(letter(60));
    }
}
```

Each guard returns immediately, so the thresholds can be read from highest to lowest without nested `else` blocks.

## Step 3: a GradeReport object

```java run class
class GradeReport {
    private int[] scores;

    GradeReport(int[] scores) {
        this.scores = scores;
    }

    int total() {
        int sum = 0;
        for (int score : scores) {
            sum += score;
        }
        return sum;
    }

    double average() {
        if (scores.length == 0) return 0;
        return (double) total() / scores.length;
    }

    int highest() {
        int max = scores[0];
        for (int score : scores) {
            if (score > max) max = score;
        }
        return max;
    }

    String summary() {
        return String.format("Average: %.1f, highest: %d", average(), highest());
    }
}

public class Main {
    public static void main(String[] args) {
        GradeReport report = new GradeReport(new int[]{90, 85, 77, 96});
        System.out.println(report.summary());
    }
}
```

The object owns the scores and exposes only the operations callers need. `summary` hides the formatting details.

## Step 4: a full report

```java run class
class GradeReport {
    private String student;
    private int[] scores;

    GradeReport(String student, int[] scores) {
        this.student = student;
        this.scores = scores;
    }

    double average() {
        if (scores.length == 0) return 0;
        int sum = 0;
        for (int score : scores) sum += score;
        return (double) sum / scores.length;
    }

    String letter() {
        double avg = average();
        if (avg >= 90) return "A";
        if (avg >= 80) return "B";
        if (avg >= 70) return "C";
        return "F";
    }

    void print() {
        System.out.println("Report for " + student);
        for (int i = 0; i < scores.length; i++) {
            System.out.println("  Test " + (i + 1) + ": " + scores[i]);
        }
        System.out.println(String.format("  Average: %.1f (%s)", average(), letter()));
    }
}

public class Main {
    public static void main(String[] args) {
        new GradeReport("Ada", new int[]{90, 85, 77, 96}).print();
        new GradeReport("Grace", new int[]{88, 92, 79}).print();
    }
}
```

Adding the student's name and a `print` method turns the calculation into a report. Each object produces its own section without `main` knowing the details.

```java predict class id=grade-report-predict title="What is printed?"
public class Main {
    public static void main(String[] args) {
        System.out.println(String.format("%.2f", 3.14159));
    }
}
--- options
* 3.14
3.1
3.142
3
--- explain
`%.2f` formats a decimal with exactly two digits after the point, rounding the rest, so the result is `3.14`.
```

## Challenges

```java exercise class id=report-average title="Write the average method"
public class Main {
    // Define static double average(int[] scores).

    public static void main(String[] args) {
        System.out.println(average(new int[]{90, 81}));
    }
}
--- solution
public class Main {
    static double average(int[] scores) {
        if (scores.length == 0) return 0;
        int sum = 0;
        for (int score : scores) sum += score;
        return (double) sum / scores.length;
    }

    public static void main(String[] args) {
        System.out.println(average(new int[]{90, 81}));
    }
}
--- test
__check(Math.abs(Main.average(new int[]{90, 81}) - 85.5) < 0.0001, "The average of 90 and 81 is 85.5");
__check(Main.average(new int[]{}) == 0, "An empty report has average 0");
--- hint
Sum the values, then divide by the length.
--- hint
Cast the sum to `double` before dividing.
```

```java exercise class id=report-letter title="Write the letter method"
public class Main {
    // Define static String letter(double average).

    public static void main(String[] args) {
        System.out.println(letter(85));
    }
}
--- solution
public class Main {
    static String letter(double average) {
        if (average >= 90) return "A";
        if (average >= 80) return "B";
        if (average >= 70) return "C";
        return "F";
    }

    public static void main(String[] args) {
        System.out.println(letter(85));
    }
}
--- test
__check(Main.letter(95).equals("A"), "95 is an A");
__check(Main.letter(85).equals("B"), "85 is a B");
__check(Main.letter(65).equals("F"), "65 is an F");
--- hint
Check the highest threshold first.
--- hint
Return a letter from each branch.
```

```java debug class id=fix-report-average title="The report average is truncated"
class GradeReport {
    int[] scores;
    GradeReport(int[] scores) { this.scores = scores; }

    double average() {
        int sum = 0;
        for (int score : scores) sum += score;
        return sum / scores.length;
    }
}

public class Main {
    public static void main(String[] args) {
        System.out.println(new GradeReport(new int[]{90, 81}).average());
    }
}
--- solution
class GradeReport {
    int[] scores;
    GradeReport(int[] scores) { this.scores = scores; }

    double average() {
        int sum = 0;
        for (int score : scores) sum += score;
        return (double) sum / scores.length;
    }
}

public class Main {
    public static void main(String[] args) {
        System.out.println(new GradeReport(new int[]{90, 81}).average());
    }
}
--- test
__check(Math.abs(new GradeReport(new int[]{90, 81}).average() - 85.5) < 0.0001, "The average should be 85.5");
--- hint
Both `sum` and `scores.length` are integers, so the division truncates.
--- hint
Cast `sum` to `double` before dividing.
```
