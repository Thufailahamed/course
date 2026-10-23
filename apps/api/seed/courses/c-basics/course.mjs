// C Basics: an interactive course for complete beginners. Lesson bodies live in
// ./lessons/*.md, section quizzes in ./quizzes/*.json. Validate with:
//   node seed/courses/validate.mjs c-basics
export const course = {
  slug: "c-basics",
  title: "C Basics: The Interactive Course",
  subtitle: "Learn C from your first printf to pointers, memory and structs. Predict what real C code does before you compile it.",
  category: "programming",
  instructor: "arjun",
  level: "beginner",
  codeLanguage: "c",
  price: 0,
  compareAt: null,
  accent: 25,
  featured: true,
  students: 0,
  tags: ["C", "Interactive", "Programming", "Beginner", "Systems"],
  learn: [
    "Write, compile and run small C programs with gcc or clang, and read compiler errors with confidence",
    "Choose the right types, control integer and floating-point behavior, and write clear expressions",
    "Control program flow with if, switch and loops, and structure code with functions and scope",
    "Work with arrays and strings the way C does, including the null terminator and the standard string functions",
    "Understand pointers, pointer arithmetic and dynamic memory, the features that make C both powerful and unforgiving",
    "Model data with structs, enums and unions, split code with the preprocessor, and read and write files safely",
  ],
  requirements: [
    "No programming experience needed. We start from a blank file and build up",
    "A C compiler on your computer for the optional run-it-yourself steps: gcc or clang. Lesson 01 shows how to install one",
  ],
  audience: [
    "Complete beginners who want to learn the language that most operating systems, databases and embedded devices are written in",
    "Students preparing for systems programming, operating systems or computer architecture courses",
    "Programmers moving from Python, Java or JavaScript who need to understand memory and types",
    "Engineers who work near hardware and want to read C code confidently",
  ],
  description: `C is the language underneath almost everything: operating systems, databases, game engines and the firmware in the devices around you. It is small, fast and honest. It also expects you to understand what the machine is doing. This course teaches that understanding from the first line.

## Predict first, then compile

Every lesson is interactive. Most of its examples are **predict-the-output questions**: you read a short C program, choose what it prints, and only then see the explanation. Reasoning about code before you run it is the habit that separates careful C programmers from frustrated ones.

- **Real C, not pseudo-code.** Every example is a complete, standard C program you can compile unchanged.
- **Explanations that teach the rule.** Each answer explains the underlying behavior, such as integer division, operator precedence or what \`sizeof\` measures, so the same mistake is hard to repeat.
- **Checkpoint quizzes** after each section, with a written explanation for every answer.
- **Three capstone projects** built step by step: a grade report, a contact book that saves to a file, and a word-statistics tool.

## Run it on your own machine

The lessons are written so you can compile and run every program with gcc or clang. Lesson 01 shows how to install a compiler on Windows, macOS or Linux in a few minutes. Your browser shows the code and checks your reasoning. Your terminal proves it.

## From the first printf to real memory

You will start with variables, types and \`printf\`, then move through decisions, loops, functions and arrays. The middle of the course is pointers, the idea that unlocks C. You finish with structs, the preprocessor and file I/O, and you leave able to read most C code you come across.

## Built for what comes next

This course is the foundation for **C Advanced**, which covers dynamic data structures, undefined behavior, sanitizers and secure coding, and for any systems course that follows.`,
};

// Links attached to the first lesson.
export const resources = [
  { title: "cppreference: C language", url: "https://en.cppreference.com/w/c" },
  { title: "GCC: installing and using the compiler", url: "https://gcc.gnu.org/onlinedocs/" },
  { title: "Learn C (Stanford CS Education Library)", url: "https://cs.stanford.edu/people/eroberts/courses/cs107/" },
];

const lesson = (file, title, minutes, extra = {}) => ({ file, title, minutes, ...extra });
const quiz = (file, title) => ({ quiz: file, title });

export const sections = [
  {
    title: "Getting Started",
    lessons: [
      lesson("01-welcome.md", "How this course works and setting up a C compiler", 10, { preview: true }),
      lesson("02-first-program.md", "Your first program: main, printf and the compile-run cycle", 16, { preview: true }),
      lesson("03-variables-types.md", "Variables, basic types and sizeof", 16),
      quiz("s1.json", "Checkpoint: getting started"),
    ],
  },
  {
    title: "Numbers & Operators",
    lessons: [
      lesson("04-integers-floats.md", "Integers, floating point and the traps between them", 18),
      lesson("05-operators.md", "Operators, precedence and short-circuit evaluation", 18),
      lesson("06-input-output.md", "Formatted output and reading input safely", 16),
      quiz("s2.json", "Checkpoint: numbers & operators"),
    ],
  },
  {
    title: "Making Decisions & Repeating",
    lessons: [
      lesson("07-if-else.md", "Making decisions with if, else and the ternary operator", 16),
      lesson("08-switch.md", "switch, case and the fallthrough trap", 16),
      lesson("09-loops.md", "Loops: while, do-while and for", 18),
      lesson("10-loop-control.md", "break, continue and nested loops", 16),
      quiz("s3.json", "Checkpoint: decisions & loops"),
    ],
  },
  {
    title: "Functions & Arrays",
    lessons: [
      lesson("11-functions.md", "Functions: parameters, return values and prototypes", 20),
      lesson("12-scope-storage.md", "Scope, lifetime and static variables", 16),
      lesson("13-arrays.md", "Arrays: fixed-size collections and their rules", 18),
      lesson("14-strings.md", "Strings are char arrays with a terminator", 18),
      quiz("s4.json", "Checkpoint: functions & arrays"),
    ],
  },
  {
    title: "Pointers & Memory",
    lessons: [
      lesson("15-pointers-intro.md", "Pointers: addresses, dereferencing and pass-by-pointer", 22),
      lesson("16-pointers-arrays.md", "Pointer arithmetic and the link between pointers and arrays", 20),
      lesson("17-dynamic-memory.md", "Dynamic memory with malloc, calloc and free", 20),
      quiz("s5.json", "Checkpoint: pointers & memory"),
    ],
  },
  {
    title: "Structs, Files & the Preprocessor",
    lessons: [
      lesson("18-structs.md", "Structs: grouping related data", 18),
      lesson("19-enums-typedef-unions.md", "Enums, typedef and unions", 16),
      lesson("20-preprocessor.md", "The preprocessor: #include, #define and macros", 18),
      lesson("21-file-io.md", "Reading and writing files safely", 18),
      quiz("s6.json", "Checkpoint: structs, files & the preprocessor"),
    ],
  },
  {
    title: "Capstone Projects",
    lessons: [
      lesson("22-project-grade-report.md", "Project 1: a grade report with arrays, loops and functions", 30),
      lesson("23-project-contacts.md", "Project 2: a contact book with structs and file storage", 35),
      lesson("24-project-word-stats.md", "Project 3: word statistics with strings and pointers", 35),
    ],
  },
];
