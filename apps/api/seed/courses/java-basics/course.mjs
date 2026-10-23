// Java Basics: a fully interactive course for complete beginners. Lesson bodies live in
// ./lessons/*.md, section quizzes in ./quizzes/*.json. Validate with:
//   node seed/courses/validate.mjs java-basics
export const course = {
  slug: "java-basics",
  title: "Java Basics: The Interactive Course",
  subtitle: "Go from your first line of code to real programs, writing, running and debugging Java right in your browser.",
  category: "programming",
  instructor: "arjun",
  level: "beginner",
  codeLanguage: "java",
  price: 4900,
  compareAt: 9900,
  accent: 25,
  featured: true,
  students: 18320,
  tags: ["Java", "Interactive", "Programming", "Beginner", "Object-Oriented"],
  learn: [
    "Write and run Java from a blank page, with nothing to install",
    "Master variables, types, strings, conditionals, loops and arrays",
    "Organize data with ArrayList, HashMap and HashSet, and sort it with confidence",
    "Write methods and classes that model real things, and understand inheritance and interfaces",
    "Read compiler errors and stack traces, and fix bugs instead of guessing",
    "Build three complete projects: a grade report, a to-do list and a bank account",
  ],
  requirements: ["No programming experience at all. We start from the very first line", "A modern browser. Java and its compiler run inside the page, so there's nothing to install"],
  audience: [
    "Complete beginners who want a thorough, practical first language",
    "Students preparing for a CS course, AP Computer Science or a coding interview",
    "Developers from Python, JavaScript or other languages who need Java's static types and object model",
    "Anyone who wants to build Android apps, backend services or enterprise software later",
  ],
  description: `Most beginner courses have you watch someone else type. This one puts the keyboard in your hands from the first minute: **every lesson is a live coding environment** with a real Java compiler and JVM running inside your browser.

## Learn by doing, not by watching

- **No videos, no installs.** Read a short explanation, run the code, change it, break it and fix it, right on the page.
- **Over 100 hands-on challenges.** Each one is checked by hidden tests, with progressive hints when you're stuck.
- **Debug challenges.** Real beginner bugs (off-by-one loops, \`=\` instead of \`==\`, integer division, null references) that you track down and fix.
- **Predict-the-output questions** train you to read code like an experienced developer before you run it.
- **Atlas, your AI tutor,** explains any compiler error or exception in plain language without handing you the answer.

## From zero to real programs

You'll start with \`System.out.println("Hello")\` and finish by building three complete projects: a **grade report** that summarizes student data, a **to-do manager** built with objects and lists, and a **bank account** built with classes, encapsulation and exceptions.

## Built for what comes next

Everything here is the foundation for Android, Spring, backend services and a CS degree. Java's static types, collections and object model show up in almost every codebase you will meet.`,
};

// Links attached to the first lesson.
export const resources = [
  { title: "The Java Tutorials (Oracle)", url: "https://docs.oracle.com/javase/tutorial/" },
  { title: "Java API specification", url: "https://docs.oracle.com/en/java/javase/17/docs/api/" },
];

const lesson = (file, title, minutes, extra = {}) => ({ file, title, minutes, ...extra });
const quiz = (file, title) => ({ quiz: file, title });

export const sections = [
  {
    title: "Getting Started",
    lessons: [
      lesson("01-welcome.md", "How this course works", 8, { preview: true }),
      lesson("02-first-program.md", "Your first program: println, comments and errors", 14, { preview: true }),
      lesson("03-variables.md", "Variables and types: giving names to values", 16),
      quiz("s1.json", "Checkpoint: getting started"),
    ],
  },
  {
    title: "Numbers, Text & Truth",
    lessons: [
      lesson("04-numbers.md", "Numbers and arithmetic", 16),
      lesson("05-strings.md", "Strings: text, concatenation and length", 18),
      lesson("06-string-methods.md", "String methods and formatting", 18),
      lesson("07-booleans.md", "Booleans, comparisons and logic", 16),
      lesson("08-conversion-input.md", "Type conversion and reading input", 16),
      quiz("s2.json", "Checkpoint: numbers, text & truth"),
    ],
  },
  {
    title: "Decisions & Loops",
    lessons: [
      lesson("09-if-else.md", "Making decisions with if, else if and else", 18),
      lesson("10-switch.md", "switch, case and enums", 16),
      lesson("11-while.md", "while loops: repeat until done", 16),
      lesson("12-for.md", "for loops and loop patterns", 18),
      quiz("s3.json", "Checkpoint: decisions & loops"),
    ],
  },
  {
    title: "Collections",
    lessons: [
      lesson("13-arrays.md", "Arrays: many values, one name", 18),
      lesson("14-array-algorithms.md", "Array algorithms: sums, searches and extremes", 18),
      lesson("15-arraylist.md", "ArrayList: a growable array", 18),
      lesson("16-hashmap.md", "HashMap: look things up by key", 20),
      lesson("17-sets.md", "HashSet: uniqueness and membership", 14),
      lesson("18-sorting.md", "Sorting, comparing and the Collections toolkit", 18),
      quiz("s4.json", "Checkpoint: collections"),
    ],
  },
  {
    title: "Methods",
    lessons: [
      lesson("19-methods.md", "Methods: parameters and return values", 18),
      lesson("20-scope-overloading.md", "Scope, static and overloading", 18),
      lesson("21-recursion.md", "Recursion: methods that call themselves", 16),
      lesson("22-method-patterns.md", "Method patterns: validation, helpers and decomposition", 18),
      quiz("s5.json", "Checkpoint: methods"),
    ],
  },
  {
    title: "Errors, Files & Packages",
    lessons: [
      lesson("23-exceptions.md", "Exceptions: try, catch and throw", 18),
      lesson("24-files.md", "Reading and writing files", 20),
      lesson("25-packages.md", "Packages, imports and the standard library", 16),
      quiz("s6.json", "Checkpoint: errors, files & packages"),
    ],
  },
  {
    title: "Objects & Classes",
    lessons: [
      lesson("26-classes.md", "Classes and objects: your own data types", 20),
      lesson("27-inheritance.md", "Inheritance, interfaces and polymorphism", 20),
      quiz("s7.json", "Checkpoint: objects & classes"),
    ],
  },
  {
    title: "Capstone Projects",
    lessons: [
      lesson("28-project-grade-report.md", "Project: grade report", 25),
      lesson("29-project-todo.md", "Project: a to-do manager", 25),
      lesson("30-project-bank.md", "Project: a bank account with classes and exceptions", 25),
      quiz("s8.json", "Final exam: Java Basics"),
    ],
  },
];
