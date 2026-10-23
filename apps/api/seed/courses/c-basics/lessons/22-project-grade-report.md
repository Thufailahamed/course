Time to put the first half of the course to work. In this project you will build a grade report. It stores scores for several students, computes each student's average, turns the average into a letter grade and prints a neat table. It uses arrays, loops, functions, `if` statements and formatted output, which are the tools from lessons 01 to 14. There is no new syntax here. The point is to combine what you know into a program that does something useful.

## The plan

Before you write any code, decide what the program needs:

1. Store the students' names and their scores for each subject.
2. Compute an average for one student's scores.
3. Turn an average into a letter grade.
4. Print a table with one row per student.

Each step becomes one function or one loop. Keeping the steps separate means you can check each one with a predict question before you put them together.

## Step 1: the data

Two arrays hold the data. A two-dimensional array of scores works well here, because each row belongs to one student. The `static` keyword keeps the data private to this file, and `const` says the program does not change it.

```c
#include <stdio.h>

#define STUDENTS 3
#define SUBJECTS 3

static const char *names[STUDENTS] = {"Ada", "Linus", "Grace"};
static const int scores[STUDENTS][SUBJECTS] = {
    {92, 88, 95},
    {71, 64, 80},
    {85, 90, 78},
};
```

## Step 2: the average

The average function takes a pointer to a row of scores and the number of subjects. It returns a `double`, because a division of integers would throw the fraction away. Lesson 04 explains the trap.

```c predict id=average-type title="What does this print?"
#include <stdio.h>

double average(const int values[], int count) {
    int total = 0;
    for (int i = 0; i < count; i++) {
        total += values[i];
    }
    return (double)total / count;
}

int main(void) {
    int marks[] = {80, 83};
    printf("%.1f\n", average(marks, 2));
    return 0;
}
--- options
* 81.5
81
82.0
80.0
--- explain
The total is 163. Casting the total to `double` before dividing gives 81.5, and `%.1f` prints it with one decimal. If the cast were missing, the division would be an integer division that truncates to 81. The parameter `const int values[]` is really a pointer, which is why the length has to be passed in too.
```

```c predict id=integer-trap title="What does this print?"
#include <stdio.h>

int main(void) {
    int marks[] = {80, 83};
    printf("%d\n", (marks[0] + marks[1]) / 2);
    return 0;
}
--- options
* 81
81.5
82
80
--- explain
Both operands are `int`, so `/` performs integer division. The sum 163 divided by 2 truncates to 81. This is the same trap the average function avoids with its cast, and it is why the cast belongs on the division, not on the sum.
```

## Step 3: the letter grade

A chain of `if` statements that tests the highest threshold first is clear and correct. Each test assumes the earlier ones failed, so the thresholds do not need to overlap.

```c predict id=letter-grade title="What does this print?"
#include <stdio.h>

char letter_grade(double avg) {
    if (avg >= 90) return 'A';
    if (avg >= 80) return 'B';
    if (avg >= 70) return 'C';
    if (avg >= 60) return 'D';
    return 'F';
}

int main(void) {
    printf("%c\n", letter_grade(89.5));
    return 0;
}
--- options
* B
A
C
F
--- explain
The first test, `avg >= 90`, is false for 89.5. The second, `avg >= 80`, is true, so the function returns `'B'`. Testing from the highest threshold down means each `if` can rely on the ones above it having failed.
```

## Step 4: the table

`main` loops over the students, computes each average, and prints a row. The header uses the same widths as the rows, so the columns line up.

```c
int main(void) {
    printf("%-8s %8s %6s\n", "Name", "Average", "Grade");
    for (int s = 0; s < STUDENTS; s++) {
        double avg = average(scores[s], SUBJECTS);
        printf("%-8s %8.2f %6c\n", names[s], avg, letter_grade(avg));
    }
    return 0;
}
```

## The whole program

Put the pieces together in one file. Notice that the functions come before `main`, so the compiler has seen their definitions by the time `main` calls them.

```c
#include <stdio.h>

#define STUDENTS 3
#define SUBJECTS 3

static const char *names[STUDENTS] = {"Ada", "Linus", "Grace"};
static const int scores[STUDENTS][SUBJECTS] = {
    {92, 88, 95},
    {71, 64, 80},
    {85, 90, 78},
};

double average(const int values[], int count) {
    int total = 0;
    for (int i = 0; i < count; i++) {
        total += values[i];
    }
    return (double)total / count;
}

char letter_grade(double avg) {
    if (avg >= 90) return 'A';
    if (avg >= 80) return 'B';
    if (avg >= 70) return 'C';
    if (avg >= 60) return 'D';
    return 'F';
}

int main(void) {
    printf("%-8s %8s %6s\n", "Name", "Average", "Grade");
    for (int s = 0; s < STUDENTS; s++) {
        double avg = average(scores[s], SUBJECTS);
        printf("%-8s %8.2f %6c\n", names[s], avg, letter_grade(avg));
    }
    return 0;
}
```

Compile it with `gcc -std=c11 -Wall -Wextra -pedantic grades.c -o grades`. The output should be:

```text
Name      Average  Grade
Ada         91.67      A
Linus       71.67      C
Grace       84.33      B
```

## Extend it

- Add a fourth student by changing `STUDENTS` and adding a row to each array. Notice that nothing else needs to change.
- Print the class average under the table, computed from the student averages.
- Find the top student by keeping track of the highest average in a loop.

> **Pitfall:** If you add a student to `names` but forget to add a row to `scores`, the two arrays fall out of step and the program prints the wrong name next to the wrong marks. Keeping related data in matching positions is a constant concern in C, and the next project replaces this approach with structs.

## Recap

- Arrays and loops are the core of most data processing, and a two-dimensional array holds rows of related values.
- Functions with clear inputs and outputs are easy to check one at a time.
- Compute averages with a `double` division. An integer division truncates.
- A chain of `if` statements that tests the highest threshold first gives correct, readable grades.

**Up next:** a contact book that keeps its records in a file, using structs and everything from the file I/O lesson.
