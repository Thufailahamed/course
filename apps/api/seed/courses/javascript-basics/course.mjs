// JavaScript Basics: a fully interactive course for complete beginners. Lesson bodies live in
// ./lessons/*.md, section quizzes in ./quizzes/*.json. Validate with:
//   node seed/courses/validate.mjs javascript-basics
export const course = {
  slug: "javascript-basics",
  title: "JavaScript Basics: The Interactive Course",
  subtitle: "Go from your first console.log to real programs. Write, run and debug JavaScript in your browser, with no setup.",
  category: "programming",
  instructor: "arjun",
  level: "beginner",
  codeLanguage: "javascript",
  price: 4900,
  compareAt: 9900,
  accent: 60,
  featured: true,
  students: 21460,
  tags: ["JavaScript", "Interactive", "Programming", "Beginner", "Web"],
  learn: [
    "Write clear JavaScript from a blank page, with nothing to install",
    "Store and change data with let, const, numbers, strings and booleans",
    "Control program flow with conditionals, loops and the array methods real code uses",
    "Write functions, understand scope, and transform data with map, filter and reduce",
    "Model things with objects and classes, and read and write JSON",
    "Handle errors with try/catch, work with dates, and build three complete projects",
  ],
  requirements: ['No programming experience needed. We start from console.log("Hello")', "A modern browser. JavaScript runs inside the page, so there's nothing to install"],
  audience: [
    "Complete beginners who want to build for the web, starting with the language itself",
    "Designers and marketers who want to script, automate and prototype",
    "Developers moving from Python, Java or C# who need the JavaScript mental model fast",
    "Anyone preparing for React, Node.js or front-end interviews",
  ],
  description: `Most beginner courses have you watch someone else type. This one puts the keyboard in your hands from the first minute: **every lesson is a live coding environment** with a real JavaScript engine running inside your browser.

## Learn by doing, not by watching

- **No videos, no installs.** Read a short explanation, run the code, change it, break it and fix it, right on the page.
- **Hands-on challenges in every lesson.** Each one is checked by hidden tests that use new inputs, so you have to understand the idea, not memorize an answer. Progressive hints appear when you're stuck.
- **Debug challenges.** Real beginner bugs (\`==\` surprises, off-by-one loops, shared arrays, a forgotten \`return\`) that you track down and fix.
- **Predict-the-output questions** train you to read code like an experienced developer before you run it.
- **Atlas, your AI tutor,** explains any error in plain language without handing you the answer.

## From zero to real programs

You'll start with \`console.log\` and finish by building three complete projects: a **grade report** that summarizes student data, a **to-do manager** built with objects and arrays, and a **budget tracker** built with classes that saves to JSON.

## Built for what comes next

Everything here is the foundation for front-end development, Node.js and full-stack work. When you're done, **JavaScript Advanced** picks up exactly where this course ends, with closures, the event loop, promises and async patterns.`,
};

// Links attached to the first lesson.
export const resources = [
  { title: "MDN: JavaScript guide", url: "https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide" },
  { title: "MDN: JavaScript reference", url: "https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference" },
];

const lesson = (file, title, minutes, extra = {}) => ({ file, title, minutes, ...extra });
const quiz = (file, title) => ({ quiz: file, title });

export const sections = [
  {
    title: "Getting Started",
    lessons: [
      lesson("01-welcome.md", "How this course works", 8, { preview: true }),
      lesson("02-first-program.md", "Your first program: console.log, comments and errors", 14, { preview: true }),
      lesson("03-variables.md", "Variables with let and const", 16),
      quiz("s1.json", "Checkpoint: getting started"),
    ],
  },
  {
    title: "Numbers, Text & Truth",
    lessons: [
      lesson("04-numbers.md", "Numbers, arithmetic and the Math object", 16),
      lesson("05-strings.md", "Strings and template literals", 16),
      lesson("06-string-methods.md", "String methods you'll use every day", 16),
      lesson("07-booleans.md", "Booleans, equality and truthiness", 18),
      lesson("08-conditionals.md", "Making decisions: if, else and switch", 16),
      quiz("s2.json", "Checkpoint: numbers, text & truth"),
    ],
  },
  {
    title: "Loops & Arrays",
    lessons: [
      lesson("09-loops.md", "Loops: while, for and for...of", 18),
      lesson("10-loop-patterns.md", "Loop patterns: accumulate, search and count", 18),
      lesson("11-arrays.md", "Arrays: creating, reading and changing", 18),
      lesson("12-array-methods.md", "Array methods: push, slice, splice, includes and sort", 20),
      quiz("s3.json", "Checkpoint: loops & arrays"),
    ],
  },
  {
    title: "Functions",
    lessons: [
      lesson("13-functions.md", "Functions: parameters, return and defaults", 18),
      lesson("14-scope.md", "Scope: where variables live", 16),
      lesson("15-arrow-functions.md", "Arrow functions and callbacks", 16),
      lesson("16-higher-order.md", "Thinking in transformations: map, filter and reduce", 20),
      quiz("s4.json", "Checkpoint: functions"),
    ],
  },
  {
    title: "Objects & Classes",
    lessons: [
      lesson("17-objects.md", "Objects: properties, methods and references", 18),
      lesson("18-destructuring-spread.md", "Destructuring, spread and rest", 18),
      lesson("19-classes.md", "Classes: blueprints for your own data", 20),
      quiz("s5.json", "Checkpoint: objects & classes"),
    ],
  },
  {
    title: "Errors, JSON & Dates",
    lessons: [
      lesson("20-errors.md", "Errors: throw, try and catch", 16),
      lesson("21-json.md", "JSON: saving and sharing data", 16),
      lesson("22-dates.md", "Dates and time, without the traps", 16),
      quiz("s6.json", "Checkpoint: errors, JSON & dates"),
    ],
  },
  {
    title: "Projects",
    lessons: [
      lesson("23-project-grades.md", "Project: a grade report", 30),
      lesson("24-project-todo.md", "Project: a to-do manager", 30),
      lesson("25-project-budget.md", "Project: a budget tracker with JSON", 36),
      quiz("s7.json", "Final exam: JavaScript Basics"),
    ],
  },
];
