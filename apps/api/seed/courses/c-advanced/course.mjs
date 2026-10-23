// C Advanced: the interactive follow-on to C Basics. Lesson bodies live in
// ./lessons/*.md, section quizzes in ./quizzes/*.json. Validate with:
//   node seed/courses/validate.mjs c-advanced
export const course = {
  slug: "c-advanced",
  title: "C Advanced: Memory, Data Structures and Systems Craft",
  subtitle: "Take full control of C: manage memory safely, build real data structures, and write code you can trust.",
  category: "programming",
  instructor: "arjun",
  level: "advanced",
  codeLanguage: "c",
  price: 6900,
  compareAt: 12900,
  accent: 60,
  featured: false,
  students: 0,
  tags: ["C", "Interactive", "Systems", "Data Structures", "Memory", "Advanced"],
  learn: [
    "Explain what the compiler does with your code, from preprocessing to linking, and why undefined behavior is dangerous",
    "Design ownership rules for heap memory and find leaks and invalid accesses before they reach production",
    "Build linked lists, stacks, queues, binary search trees and hash tables from first principles",
    "Sort any data with qsort, write comparators, and use callbacks and function pointers for flexible APIs",
    "Work with bits, struct layout, unions and type punning with confidence and portable code",
    "Write generic containers with void pointers, handle errors with errno, and debug with gdb and sanitizers",
    "Finish three capstone projects: a generic dynamic array, a persistent key-value store and an expression evaluator",
  ],
  requirements: [
    "Complete C Basics, or be comfortable with variables, control flow, functions, arrays, pointers and structs",
    "A C11 compiler such as GCC or Clang on your own machine, for the exercises you choose to run locally",
  ],
  audience: [
    "Programmers who know C syntax and want to write safe, efficient and maintainable systems code",
    "Engineers moving to embedded, operating systems, databases or game engines",
    "Students preparing for systems programming courses and technical interviews",
    "Developers who maintain legacy C and want to understand the memory and undefined behavior traps they inherit",
  ],
  description: `C rewards the programmers who understand it deeply and punishes everyone else. **C Advanced** is for the people who have learned the syntax and now want the judgment: how the compiler really reads your code, who owns each block of memory, and why a program that "works" on your laptop can still be broken.

## Think like a systems programmer

- **Start from the toolchain.** You will follow a file through preprocessing, compilation, assembly and linking, and learn to read what each stage produces.
- **Master memory.** Ownership rules, leak detection, realloc pitfalls and the discipline that keeps large programs alive.
- **Build the classics yourself.** Linked lists, stacks, queues, binary search trees and hash tables, each implemented with clear invariants and tested edge cases.
- **Write generic, portable code.** Function pointers, comparators, void-pointer containers, X-macros and opaque types, the tools real C libraries are built with.
- **Debug like a professional.** gdb, AddressSanitizer, UndefinedBehaviorSanitizer and Valgrind, used on purpose rather than as a last resort.

## Every lesson is interactive

There are no videos. Each lesson is a guided walkthrough with predict-the-output questions that make you reason about memory, pointers and control flow before you see the answer, plus checkpoint quizzes that test the ideas you need for the projects.

## Finish with real projects

Three capstone projects bring everything together: a **generic dynamic array library**, a **key-value store** with a hash table and file persistence, and a **tokenizer and expression evaluator** that could sit inside a calculator or a configuration language.`,
};

// Links attached to the first lesson.
export const resources = [
  { title: "cppreference: C language reference", url: "https://en.cppreference.com/w/c" },
  { title: "GCC: Instrumentation options (sanitizers)", url: "https://gcc.gnu.org/onlinedocs/gcc/Instrumentation-Options.html" },
  { title: "GDB: The GNU debugger documentation", url: "https://sourceware.org/gdb/documentation/" },
];

const lesson = (file, title, minutes, extra = {}) => ({ file, title, minutes, ...extra });
const quiz = (file, title) => ({ quiz: file, title });

export const sections = [
  {
    title: "Under the Hood",
    lessons: [
      lesson("01-welcome.md", "How this course works", 8, { preview: true }),
      lesson("02-compilation-pipeline.md", "From source to executable: the compilation pipeline", 22),
      lesson("03-undefined-behavior.md", "Undefined behavior and sequence points", 24),
      lesson("04-const-and-qualifiers.md", "const, volatile and pointer qualifiers", 20),
      lesson("05-function-pointers.md", "Function pointers and callback tables", 22),
      quiz("s1.json", "Checkpoint: under the hood"),
    ],
  },
  {
    title: "Memory Mastery",
    lessons: [
      lesson("06-dynamic-memory.md", "Dynamic memory: malloc, calloc, realloc and free", 24),
      lesson("07-ownership-leaks.md", "Ownership rules and finding leaks", 20),
      lesson("08-linked-lists.md", "Linked lists: nodes, pointers and invariants", 26),
      lesson("09-stacks-queues.md", "Stacks and queues built on linked storage", 22),
      lesson("10-binary-trees.md", "Binary search trees: insert, search and traverse", 26),
      quiz("s2.json", "Checkpoint: memory mastery"),
    ],
  },
  {
    title: "Data Structures & Algorithms",
    lessons: [
      lesson("11-hash-tables.md", "Hash tables with chaining", 26),
      lesson("12-qsort-comparators.md", "Sorting with qsort and comparator functions", 22),
      lesson("13-bit-manipulation.md", "Bit manipulation: masks, shifts and flags", 22),
      lesson("14-struct-layout.md", "Struct layout, padding and alignment", 22),
      lesson("15-unions-type-punning.md", "Unions and type punning with memcpy", 20),
      quiz("s3.json", "Checkpoint: data structures & algorithms"),
    ],
  },
  {
    title: "Systems Craft",
    lessons: [
      lesson("16-macros-x-macros.md", "Advanced macros and X-macros", 22),
      lesson("17-void-generic-containers.md", "Generic containers with void pointers", 24),
      lesson("18-file-io-errno.md", "Binary files and error handling with errno", 24),
      lesson("19-debugging-sanitizers.md", "Debugging with gdb, sanitizers and Valgrind", 22),
      lesson("20-secure-c.md", "Secure C: bounds, snprintf and integer overflow", 24),
      lesson("21-modular-design.md", "Modular design: headers, opaque types and linkage", 22),
      quiz("s4.json", "Checkpoint: systems craft"),
    ],
  },
  {
    title: "Capstone Projects",
    lessons: [
      lesson("22-project-dynamic-array.md", "Project: a generic dynamic array library", 40),
      lesson("23-project-kv-store.md", "Project: a key-value store with file persistence", 45),
      lesson("24-project-expression-evaluator.md", "Project: a tokenizer and expression evaluator", 45),
      quiz("s5.json", "Final checkpoint: advanced C"),
    ],
  },
];
