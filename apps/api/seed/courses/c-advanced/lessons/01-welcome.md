C Basics taught you to make the computer do things. C Advanced teaches you to make the computer do them **safely, predictably and efficiently**, even when the machine is under pressure. That is the difference between code that works in a tutorial and code that runs a database, a kernel, a game engine or an embedded controller for years.

By the end of this course you will be able to follow a source file through the whole toolchain, reason about undefined behavior before it bites you, design clear ownership rules for heap memory, and build the data structures that every serious program relies on. You will also learn to debug with the same tools professionals use, and to write APIs that other people can use without hurting themselves.

## How the lessons work

Every lesson is interactive without being a video. You read a short explanation, then face **predict-the-output** questions on code blocks. Make your guess before you read the explanation, because predicting is how you train the mental model that matters: what the machine does, step by step.

Some code blocks are plain snippets. Read them carefully and trace them with a pencil. Each lesson ends with a recap and a link to the next topic. Section checkpoints test the ideas you need for the projects.

> **Tip:** Keep a notebook of the diagrams you draw. Pointers, memory blocks and tree shapes are easiest to understand when you sketch them. Draw boxes for memory, arrows for pointers, and write the value next to each name.

## What you need

You will read and trace C11 code throughout. If you have a compiler on your own machine (GCC or Clang), try the examples there. A good habit is to compile with warnings on:

```c
// gcc -std=c11 -Wall -Wextra -pedantic program.c -o program
```

You do not need a compiler to finish the course, but running code is the fastest way to confirm what you think you understand.

## The three rules of this course

1. **Know what the compiler is allowed to do.** A correct program follows the language's rules, not the behavior you observed once.
2. **Every byte has an owner.** Whether it lives on the stack, in static storage or on the heap, someone must be responsible for it.
3. **Make invariants explicit.** A data structure is correct when a set of conditions always holds. Write those conditions down, then keep them true after every operation.

These rules sound abstract now. By the final project, they will feel like common sense.

## Recap

- You will move from using C to designing systems in C.
- Predict the output before you read the answer; it trains the right mental model.
- Compile with `-Wall -Wextra -pedantic`, and keep an eye on every warning.
- Ownership, undefined behavior and invariants are the three themes of the whole course.

**Up next:** Follow a single source file through the compilation pipeline, from preprocessor to linker.
