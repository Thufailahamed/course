// Python Basics: a fully interactive course for complete beginners. Lesson bodies live in
// ./lessons/*.md, section quizzes in ./quizzes/*.json. Validate with:
//   node seed/courses/validate.mjs python-basics
export const course = {
  slug: "python-basics",
  title: "Python Basics: The Interactive Course",
  subtitle: "Go from your first line of code to real programs, writing, running and debugging Python right in your browser.",
  category: "programming",
  instructor: "arjun",
  level: "beginner",
  price: 0,
  compareAt: null,
  accent: 45,
  featured: true,
  students: 34870,
  tags: ["Python", "Interactive", "Programming", "Beginner", "Fundamentals"],
  learn: [
    "Write clean, working Python programs from a blank page, with no setup or installs",
    "Master variables, strings, numbers, conditions and loops until they feel automatic",
    "Organize data with lists, tuples, dictionaries and sets, and know which one to reach for",
    "Write reusable functions, handle errors gracefully and work with files, CSV and JSON",
    "Read tracebacks and fix bugs with a real step-through debugger instead of guessing",
    "Model real things with classes, and build three complete projects from scratch",
  ],
  requirements: ["No programming experience at all. We start from the very first line", "A modern browser. Python runs inside the page, so there's nothing to install"],
  audience: [
    "Complete beginners who want to learn to code properly, not just copy snippets",
    "Analysts, marketers and scientists who want to automate their work with Python",
    "Students preparing for data science, machine learning or a CS degree",
    "Developers from other languages who want a fast, thorough tour of Python",
  ],
  description: `Most beginner courses have you watch someone else type. This one puts the keyboard in your hands from the first minute: **every lesson is a live coding environment** with a real Python interpreter running inside your browser.

## Learn by doing, not by watching

- **No videos, no installs.** Read a short explanation, run the code, change it, break it and fix it, right on the page.
- **Over 100 hands-on challenges.** Each one is checked automatically by hidden tests, with progressive hints when you're stuck.
- **Debug challenges.** Real beginner bugs (off-by-one loops, shared lists, forgotten \`return\`s) that you track down and fix.
- **A real debugger.** Step through your code line by line, *backwards and forwards*, and watch every variable change.
- **Predict-the-output questions** train you to read code like an expert before you run it.
- **Atlas, your AI tutor,** explains any error in plain language without handing you the answer.

## From zero to real programs

You'll start with \`print("Hello")\` and finish by building three complete projects: a **gradebook analyzer** that reads and reports on CSV data, a **word-guessing game** with scoring and replay, and a **budget tracker** built with classes that saves to JSON.

## Built for what comes next

Everything here is the foundation for data science, automation, web development and machine learning. When you're done, **Python Advanced** picks up exactly where this course ends.`,
};

// Links attached to the first lesson.
export const resources = [
  { title: "The official Python tutorial", url: "https://docs.python.org/3/tutorial/index.html" },
  { title: "Python built-in functions reference", url: "https://docs.python.org/3/library/functions.html" },
];

const lesson = (file, title, minutes, extra = {}) => ({ file, title, minutes, ...extra });
const quiz = (file, title) => ({ quiz: file, title });

export const sections = [
  {
    title: "Getting Started",
    lessons: [
      lesson("01-welcome.md", "How this course works", 8, { preview: true }),
      lesson("02-first-program.md", "Your first program: print, comments and errors", 14, { preview: true }),
      lesson("03-variables.md", "Variables: giving names to values", 16),
      quiz("s1.json", "Checkpoint: getting started"),
    ],
  },
  {
    title: "Numbers, Text & Truth",
    lessons: [
      lesson("04-numbers.md", "Numbers and arithmetic", 16),
      lesson("05-strings.md", "Strings: text, indexing and slicing", 18),
      lesson("06-string-methods.md", "String methods and f-strings", 18),
      lesson("07-booleans.md", "Booleans, comparisons and logic", 16),
      lesson("08-input-conversion.md", "Talking to users: input() and type conversion", 16),
      quiz("s2.json", "Checkpoint: numbers, text & truth"),
    ],
  },
  {
    title: "Decisions & Loops",
    lessons: [
      lesson("09-if-else.md", "Making decisions with if, elif and else", 18),
      lesson("10-while.md", "while loops: repeat until done", 16),
      lesson("11-for-range.md", "for loops and range()", 18),
      lesson("12-loop-patterns.md", "Loop patterns: counting, searching, break and continue", 20),
      quiz("s3.json", "Checkpoint: decisions & loops"),
    ],
  },
  {
    title: "Collections",
    lessons: [
      lesson("13-lists.md", "Lists: ordered collections", 18),
      lesson("14-list-methods.md", "Working with lists: methods, sorting and copies", 18),
      lesson("15-tuples.md", "Tuples and unpacking", 14),
      lesson("16-dicts.md", "Dictionaries: look things up by key", 20),
      lesson("17-sets.md", "Sets: uniqueness and membership", 14),
      lesson("18-comprehensions.md", "Comprehensions: build collections in one line", 16),
      quiz("s4.json", "Checkpoint: collections"),
    ],
  },
  {
    title: "Functions",
    lessons: [
      lesson("19-functions.md", "Defining functions: parameters and return values", 18),
      lesson("20-arguments.md", "Arguments in depth: defaults, keywords, *args and **kwargs", 18),
      lesson("21-scope.md", "Scope: where names live", 14),
      lesson("22-builtins.md", "The built-in toolkit: sorted, enumerate, zip and lambda", 18),
      quiz("s5.json", "Checkpoint: functions"),
    ],
  },
  {
    title: "Errors, Files & Modules",
    lessons: [
      lesson("23-exceptions.md", "Errors and exceptions: try, except and raise", 18),
      lesson("24-files.md", "Reading and writing files, CSV and JSON", 20),
      lesson("25-modules.md", "Modules and the standard library", 16),
      quiz("s6.json", "Checkpoint: errors, files & modules"),
    ],
  },
  {
    title: "Objects & Classes",
    lessons: [
      lesson("26-classes.md", "Classes and objects: your own data types", 20),
      lesson("27-oop-design.md", "Special methods, properties and inheritance", 20),
      quiz("s7.json", "Checkpoint: objects & classes"),
    ],
  },
  {
    title: "Capstone Projects",
    lessons: [
      lesson("28-project-gradebook.md", "Project: gradebook analyzer", 25),
      lesson("29-project-word-game.md", "Project: a word-guessing game", 25),
      lesson("30-project-budget.md", "Project: budget tracker with classes and JSON", 25),
      quiz("s8.json", "Final exam: Python Basics"),
    ],
  },
];
