This is the first of three projects, and it's where the pieces you've learned start working together. You'll build a **grade report**: a small program that takes raw scores for each student and produces a summary, with an average, a letter grade, the top student, and a sorted report you could print or send to a teacher.

You won't write the whole program at once. You'll build it in five stages. Each stage adds one function, and each function is a challenge with tests. Every stage starts from the code you wrote before it, so by the end the functions form a complete pipeline. Use only what you've learned so far: variables, functions, arrays, loops, objects, the array methods and template literals. Nothing new is required.

## The data

Start with the input. Each student is an object with a `name` and an array of `scores`. A real program would load this from a file or an API, and the rest of the code wouldn't care where it came from:

```js run
const students = [
  { name: "Ada", scores: [91, 88, 95] },
  { name: "Ben", scores: [72, 65, 80] },
  { name: "Cy", scores: [58, 61, 49] },
];

console.log("students:", students.length);
console.log(students[0].name, students[0].scores);
```

Before writing any code, decide what the program must produce. For each student, we need an average, a letter grade and a line for the report. Overall, we need the top student. Clear targets make the functions easy to test.

## Stage 1: the average

The average is the sum of the scores divided by how many there are. Here is that calculation for one student, written out by hand:

```js run
const adaScores = [91, 88, 95];
let total = 0;
for (const score of adaScores) {
  total = total + score;
}

console.log("total:", total, "average:", total / adaScores.length);
```

Your first function wraps that logic so it works for any list of scores:

```js exercise id=average-of title="Stage 1: average a list of scores"
function averageOf(scores) {
  // TODO: return the mean of the numbers in scores
  return null;
}
--- solution
function averageOf(scores) {
  let total = 0;
  for (const score of scores) {
    total = total + score;
  }
  return total / scores.length;
}
--- test
assertEqual(averageOf([90, 80]), 85, "The average of 90 and 80 is 85");
assertEqual(averageOf([100]), 100, "A single score is its own average");
assertEqual(averageOf([58, 61, 49]), 56, "The average of 58, 61 and 49 is 56");
--- hint
Loop over `scores` and add each one to a `total` that starts at `0`. Then divide `total` by `scores.length`.
--- hint
Return `total / scores.length` at the end of the function, after the loop has finished.
```

> **Tip:** Keep the number of scores in a variable or compute it from `.length` at the moment of use. Don't hard-code `3`. The program has to work for a student with two scores or ten.

## Stage 2: the letter grade

Next, turn a number into a letter. The cutoffs are: 90 or more is an A, 80 or more is a B, 70 or more is a C, 60 or more is a D, and anything lower is an F. The usual way is a chain of checks from the highest cutoff down, returning as soon as one matches. The boundary matters, so check it first. A cutoff of 90 means that exactly 90 has to count:

```js run
const aCutoff = 90;
console.log(89.9 >= aCutoff, 90 >= aCutoff);
```

Before you write the function, look at a broken version. This is a boundary bug, one of the most common mistakes in grading code. It's your debug challenge for this stage:

```js debug id=letter-grade title="Stage 2: fix the boundary"
function letterGrade(average) {
  if (average > 90) return "A";
  if (average >= 80) return "B";
  if (average >= 70) return "C";
  if (average >= 60) return "D";
  return "F";
}
--- solution
function letterGrade(average) {
  if (average >= 90) return "A";
  if (average >= 80) return "B";
  if (average >= 70) return "C";
  if (average >= 60) return "D";
  return "F";
}
--- test
assertEqual(letterGrade(95), "A", "95 should be an A");
assertEqual(letterGrade(90), "A", "Exactly 90 counts as an A, because the cutoff is 90 or more");
assertEqual(letterGrade(80), "B", "Exactly 80 is a B");
assertEqual(letterGrade(79.9), "C", "Just under 80 is a C");
assertEqual(letterGrade(60), "D", "Exactly 60 is a D");
assertEqual(letterGrade(59), "F", "Below 60 is an F");
--- hint
Read the first `if`. It uses `>` where the rule says "90 or more". Which comparison includes the boundary value itself?
--- hint
Change `average > 90` to `average >= 90`, to match the other lines.
```

## Stage 3: summarize one student

Now combine stages 1 and 2 into a summary for one student. The summary holds the name, the average rounded to one decimal place, and the grade. Grade from the exact average, not the rounded one, so a value like 89.96 still gets the grade it earned. Rounding to one decimal uses `Math.round(x * 10) / 10`.

Here's the rounding on its own, so you can see it working:

```js run
const raw = 87.66666;
console.log(Math.round(raw * 10) / 10);
console.log((56).toFixed(1));
```

Stage 3 starts from the code you have written so far, with `averageOf` and `letterGrade` included. Your job is to write `summarize`:

```js exercise id=summarize-student title="Stage 3: summarize one student"
function averageOf(scores) {
  let total = 0;
  for (const score of scores) {
    total = total + score;
  }
  return total / scores.length;
}

function letterGrade(average) {
  if (average >= 90) return "A";
  if (average >= 80) return "B";
  if (average >= 70) return "C";
  if (average >= 60) return "D";
  return "F";
}

function summarize(student) {
  // TODO: return { name, average, grade }
  // average: the mean rounded to one decimal place
  // grade: the letter grade of the exact (unrounded) mean
  return null;
}
--- solution
function averageOf(scores) {
  let total = 0;
  for (const score of scores) {
    total = total + score;
  }
  return total / scores.length;
}

function letterGrade(average) {
  if (average >= 90) return "A";
  if (average >= 80) return "B";
  if (average >= 70) return "C";
  if (average >= 60) return "D";
  return "F";
}

function summarize(student) {
  const raw = averageOf(student.scores);
  return { name: student.name, average: Math.round(raw * 10) / 10, grade: letterGrade(raw) };
}
--- test
assertEqual(summarize({ name: "Ada", scores: [90, 85, 88] }), { name: "Ada", average: 87.7, grade: "B" }, "Ada's mean is 87.67, so 87.7 and a B");
assertEqual(summarize({ name: "Cy", scores: [58, 61, 49] }), { name: "Cy", average: 56, grade: "F" }, "A mean of 56 is an F");
assertEqual(summarize({ name: "Zed", scores: [95, 90] }).grade, "A", "The grade should come from the mean");
assertEqual(summarize({ name: "Zed", scores: [95, 90] }).name, "Zed", "The name should be copied across");
--- hint
Call `averageOf(student.scores)` once and store the result. You'll use it both for the rounded average and for the grade.
--- hint
Return an object literal with three properties. For the grade, pass the unrounded number to `letterGrade`.
```

## Stage 4: find the top student

With summaries in hand, the next question is which student did best. Write a function that takes the list of summaries and returns the name of the student with the highest average. If two students tie, the one who appears first in the list should win.

A `reduce` with a running best works well here, and the same pattern appears in every "find the largest" problem:

```js exercise id=top-student title="Stage 4: find the top student"
function topStudent(summaries) {
  // TODO: return the name of the summary with the highest average
  // On a tie, return the earlier one. Assume the list is not empty.
  return null;
}
--- solution
function topStudent(summaries) {
  const best = summaries.reduce((top, s) => (s.average > top.average ? s : top));
  return best.name;
}
--- test
const summaries = [
  { name: "Ben", average: 72.3, grade: "C" },
  { name: "Ada", average: 91.3, grade: "A" },
  { name: "Cy", average: 56, grade: "F" },
];
assertEqual(topStudent(summaries), "Ada", "Ada has the highest average");
assertEqual(topStudent([{ name: "Solo", average: 40, grade: "F" }]), "Solo", "A single student is the top student");
assertEqual(topStudent([{ name: "First", average: 80, grade: "B" }, { name: "Second", average: 80, grade: "B" }]), "First", "On a tie, the earlier student wins");
--- hint
`reduce` without a starting value uses the first summary as the starting best. In the callback, keep whichever of `top` and `s` has the larger `average`.
--- hint
Use a strict `>` so that a tie keeps the earlier summary. Return `.name` from the summary that reduce gives you.
```

> **Pitfall:** Remember that `reduce` returns the final accumulated value, which here is a whole summary object. If you return the object when the function should return a name, the report will print `[object Object]`, which is a clear sign that you forgot the last `.name`.

## Stage 5: the report

The last stage puts the pieces together. `buildReport` takes the raw student list and returns an array of text lines: one line per student, sorted alphabetically by name, followed by a final line naming the top student. Here are the three steps you need, each shown as a small piece:

```js run
const names = ["Cy", "Ada", "Ben"];
const sortedNames = names.slice().sort((a, b) => (a < b ? -1 : 1));

console.log(sortedNames);
console.log(names);
```

`slice()` makes a copy before sorting, so the original `names` stays in its original order. The `sort` call with a comparison function is what puts the names in alphabetical order.

> **Pitfall:** Without a comparison function, `sort()` compares items as text, even when they're numbers. Predict what happens to a list of numbers before you check:

```js predict id=default-sort title="What does default sort do with numbers?"
console.log([10, 9, 80].sort().join(" "));
--- options
9 10 80
* 10 80 9
10 9 80
80 10 9
--- explain
Without a comparison function, `sort` converts every item to a string and compares them character by character. `"10"` comes before `"80"`, and `"80"` comes before `"9"` because `"8"` is less than `"9"`. The result is `10 80 9`. For numbers, always pass a comparison such as `(a, b) => a - b`.
```

Now write the integrated function. It uses every function from the earlier stages, so the starter includes all of them. Your job is the last one, `buildReport`:

```js exercise id=build-report title="Stage 5: build the full report"
function averageOf(scores) {
  let total = 0;
  for (const score of scores) {
    total = total + score;
  }
  return total / scores.length;
}

function letterGrade(average) {
  if (average >= 90) return "A";
  if (average >= 80) return "B";
  if (average >= 70) return "C";
  if (average >= 60) return "D";
  return "F";
}

function summarize(student) {
  const raw = averageOf(student.scores);
  return { name: student.name, average: Math.round(raw * 10) / 10, grade: letterGrade(raw) };
}

function topStudent(summaries) {
  const best = summaries.reduce((top, s) => (s.average > top.average ? s : top));
  return best.name;
}

function buildReport(students) {
  // TODO: return an array of lines.
  // 1. Summarize every student.
  // 2. Sort the summaries by name, alphabetically. Don't change the summaries array.
  // 3. One line per student, like "Ada: 91.3 (A)" (the average with exactly one decimal).
  // 4. A final line, "Top: " followed by the top student's name.
  return null;
}
--- solution
function averageOf(scores) {
  let total = 0;
  for (const score of scores) {
    total = total + score;
  }
  return total / scores.length;
}

function letterGrade(average) {
  if (average >= 90) return "A";
  if (average >= 80) return "B";
  if (average >= 70) return "C";
  if (average >= 60) return "D";
  return "F";
}

function summarize(student) {
  const raw = averageOf(student.scores);
  return { name: student.name, average: Math.round(raw * 10) / 10, grade: letterGrade(raw) };
}

function topStudent(summaries) {
  const best = summaries.reduce((top, s) => (s.average > top.average ? s : top));
  return best.name;
}

function buildReport(students) {
  const summaries = students.map(summarize);
  const sorted = summaries.slice().sort((a, b) => (a.name < b.name ? -1 : 1));
  const lines = sorted.map((s) => `${s.name}: ${s.average.toFixed(1)} (${s.grade})`);
  lines.push("Top: " + topStudent(summaries));
  return lines;
}
--- test
const roster = [
  { name: "Ben", scores: [72, 65, 80] },
  { name: "Ada", scores: [91, 88, 95] },
  { name: "Cy", scores: [58, 61, 49] },
];
assertEqual(buildReport(roster), ["Ada: 91.3 (A)", "Ben: 72.3 (C)", "Cy: 56.0 (F)", "Top: Ada"], "The report should be sorted by name, end with the top student, and show one decimal");
assertEqual(roster[0].name, "Ben", "The roster must not be re-ordered by buildReport");
const another = [{ name: "Max", scores: [70, 70] }];
assertEqual(buildReport(another), ["Max: 70.0 (C)", "Top: Max"], "A one-student report should still work");
--- hint
Start with `students.map(summarize)`. That gives you the summaries in the original order, which you can use for `topStudent` as well.
--- hint
Sort a copy with `summaries.slice().sort(...)`, then turn each summary into a string with a template literal. `toFixed(1)` makes sure the average always shows one decimal place, such as `56.0`.
```

## Running the whole pipeline

Once all five stages pass, the same functions work on the `students` list from the start of this lesson. In a fresh cell that contains your five functions, call `buildReport(students)` and print each line. Then check that `students` still lists Ada first. Your report function sorted a copy, so the original order never changed.

> **In the wild:** Real grade systems and analytics pipelines follow exactly this shape: load records, transform each one with a small function, compare or rank the results, and format the output at the end. Keeping each step a separate function makes it easy to test one step without running the whole program.

## What you built

You now have a complete program made of small, tested functions. You used a loop to total scores, a chain of conditions to choose grades, objects to hold summaries, `map`, `sort` and `reduce` to transform and rank them, and template literals to format the report. Each stage depended only on the stages before it. That habit of building in layers is the most useful skill in this project, and you'll use it again in the next two.

## Recap

- Build a program in stages: write one function, test it, then use it in the next.
- Boundary checks such as `>=` versus `>` are where grading logic usually goes wrong.
- Use `Math.round(x * 10) / 10` to round for display, and grade from the exact value.
- `sort()` without a comparison function sorts numbers as text, so pass one.
- Use `slice()` before sorting when the original order still matters.

**Up next:** Project: a to-do manager, where you'll store tasks as objects, update them without mutating shared arrays, and summarize what's left.
