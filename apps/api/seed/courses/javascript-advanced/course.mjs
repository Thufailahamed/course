// JavaScript Advanced: how the language really works. Lesson bodies live in ./lessons/*.md,
// section quizzes in ./quizzes/*.json. Validate with:
//   node seed/courses/validate.mjs javascript-advanced
export const course = {
  slug: "javascript-advanced",
  title: "JavaScript Advanced: Closures, Async & the Event Loop",
  subtitle: "Master the parts of JavaScript that separate working code from reliable code: scope, prototypes, async and the event loop.",
  category: "programming",
  instructor: "lena",
  level: "advanced",
  codeLanguage: "javascript",
  price: 6900,
  compareAt: 12900,
  accent: 200,
  featured: false,
  students: 8745,
  tags: ["JavaScript", "Interactive", "Async", "Advanced", "Programming"],
  learn: [
    "Explain how JavaScript runs code: the call stack, scope, hoisting and closures",
    "Control this, prototypes and classes instead of guessing at them",
    "Write generators, iterators and proxies, and know when a language feature earns its place",
    "Use promises and async/await correctly, including ordering, cancellation and error handling",
    "Predict the event loop: microtasks versus macrotasks, and why callbacks run when they do",
    "Build production patterns: concurrency limits, reactive stores, retries and caching",
  ],
  requirements: ["Solid JavaScript basics: variables, functions, arrays, objects and loops", "Our JavaScript Basics course, or equivalent experience"],
  audience: [
    "Developers who write JavaScript daily but want to stop guessing how it behaves",
    "Front-end and Node.js engineers preparing for senior interviews",
    "Engineers debugging async bugs, race conditions or memory leaks",
    "Anyone who wants to read framework source code, from React to Express, with confidence",
  ],
  description: `Most developers learn JavaScript by trial and error. This course replaces the guessing with a precise mental model, and every idea is something you **run, predict and break** on the page.

## Understand the machine

- **Execution, scope and closures** with exact rules you can predict, not folklore.
- **\`this\`, prototypes and classes** explained from the bottom up.
- **The event loop**, step by step: why a resolved promise can run before a zero-second timer.

## Write async code you can trust

- **Promises and async/await** with error handling that doesn't swallow failures.
- **Concurrency patterns**: \`Promise.all\`, \`allSettled\`, \`race\`, and worker pools with a concurrency limit.
- **Cancellation, retries and caching** that behave under load.

## Build real things

Three capstone projects: an **async task queue**, a **reactive store** with subscriptions (the core idea behind modern state libraries), and an **API client** with retries, caching and cancellation.

Every challenge is checked by hidden tests, and **Atlas**, the AI tutor, is ready for the moments when the event loop refuses to make sense.`,
};

// Links attached to the first lesson.
export const resources = [
  { title: "MDN: Concurrency model and the event loop", url: "https://developer.mozilla.org/en-US/docs/Web/JavaScript/Event_loop" },
  { title: "ECMAScript language specification", url: "https://tc39.es/ecma262/" },
];

const lesson = (file, title, minutes, extra = {}) => ({ file, title, minutes, ...extra });
const quiz = (file, title) => ({ quiz: file, title });

export const sections = [
  {
    title: "How JavaScript Runs",
    lessons: [
      lesson("01-welcome.md", "How this course works", 8, { preview: true }),
      lesson("02-execution-model.md", "The execution model: call stack, hoisting and the TDZ", 22, { preview: true }),
      lesson("03-closures.md", "Closures and lexical scope", 24),
      lesson("04-this-binding.md", "this: call, apply, bind and arrow functions", 22),
      quiz("s1.json", "Checkpoint: how JavaScript runs"),
    ],
  },
  {
    title: "Objects Under the Hood",
    lessons: [
      lesson("05-prototypes.md", "Prototypes and the prototype chain", 24),
      lesson("06-classes-deep-dive.md", "Classes in depth: private fields, getters and inheritance", 24),
      lesson("07-generators-iterators.md", "Iterators and generators", 24),
      lesson("08-proxies-reflect.md", "Proxies and Reflect: intercepting the language", 22),
      quiz("s2.json", "Checkpoint: objects under the hood"),
    ],
  },
  {
    title: "Asynchronous JavaScript",
    lessons: [
      lesson("09-promises.md", "Promises: states, chaining and errors", 26),
      lesson("10-async-await.md", "async/await: writing async code that reads like sync code", 24),
      lesson("11-event-loop.md", "The event loop: microtasks, macrotasks and ordering", 26),
      lesson("12-concurrency-patterns.md", "Concurrency: Promise.all, race, allSettled and any", 24),
      quiz("s3.json", "Checkpoint: asynchronous JavaScript"),
    ],
  },
  {
    title: "Data & Patterns",
    lessons: [
      lesson("13-immutability.md", "Immutability: freeze, copy and update safely", 22),
      lesson("14-maps-sets-weak.md", "Maps, Sets and weak references", 22),
      lesson("15-regex.md", "Regular expressions that you can actually read", 24),
      lesson("16-performance.md", "Performance: memoization, debounce and big-O in practice", 24),
      quiz("s4.json", "Checkpoint: data & patterns"),
    ],
  },
  {
    title: "Architecture",
    lessons: [
      lesson("17-modules.md", "Modules: import, export and dynamic loading", 22),
      lesson("18-testing.md", "Testing: assertions, suites and test doubles", 24),
      lesson("19-design-patterns.md", "Design patterns in JavaScript: observer, factory and strategy", 26),
      quiz("s5.json", "Checkpoint: architecture"),
    ],
  },
  {
    title: "Functional Style & Debugging",
    lessons: [
      lesson("20-functional-programming.md", "Functional programming: pure functions, composition and currying", 24),
      lesson("21-debugging.md", "Debugging like a senior engineer", 22),
      quiz("s6.json", "Checkpoint: functional style & debugging"),
    ],
  },
  {
    title: "Capstone Projects",
    lessons: [
      lesson("22-project-task-queue.md", "Project: an async task queue with a concurrency limit", 40),
      lesson("23-project-reactive-store.md", "Project: a reactive store with subscriptions", 40),
      lesson("24-project-api-client.md", "Project: an API client with retries, caching and cancellation", 44),
      quiz("s7.json", "Final exam: JavaScript Advanced"),
    ],
  },
];
