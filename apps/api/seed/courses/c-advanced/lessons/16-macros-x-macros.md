Lesson 2 showed that macros are text substitution, which makes them both powerful and risky. Used carefully, macros let you write code that the language itself cannot express: generating a table of names from one list, creating a family of similar functions, or turning a constant into a readable string. Used carelessly, they hide bugs, make errors impossible to read and break under unexpected arguments.

This lesson covers the macro techniques that real C libraries rely on: multi-line macros written safely, the `#` and `##` operators, and the **X-macro** pattern, which keeps several parallel lists in sync by generating each one from a single source. You will also learn when a macro is the wrong tool, which matters more than any trick.

## Multi-line macros: do { } while (0)

A macro that expands to several statements needs a wrapper, or it breaks when used in an `if` without braces. The standard idiom is a `do { ... } while (0)` block, which is a single statement that the semicolon after the macro completes:

```c
#define INC_TWICE(x) do { (x)++; (x)++; } while (0)
```

The predict question shows why the wrapper matters. Without it, the second increment would run outside the `if`:

```c predict id=do-while-macro title="What is printed?"
#include <stdio.h>

#define INC_TWICE(x) do { (x)++; (x)++; } while (0)

int main(void) {
    int n = 1;
    if (n == 1) INC_TWICE(n);
    else printf("no\n");
    printf("%d\n", n);
    return 0;
}
--- options
1
2
* 3
4
--- explain
`n` starts at `1`, so the condition is true and the macro runs. The `do { } while (0)` block is one statement, so the `else` attaches to the `if` correctly. Both increments happen, leaving `n` at `3`. A bare `{ (x)++; (x)++; }` would also work inside this `if`, but a bare block followed by a semicolon breaks an `if`/`else` pair, which the wrapper prevents.

Multiple evaluation is the other hazard: a macro argument with side effects runs once for every place it appears. Parenthesize every parameter, and prefer an inline function when the macro does not need to work on types or statements.

## The stringizing and pasting operators

The `#` operator turns an argument into a string literal, as lesson 2 showed. The `##` operator joins two tokens into one, which lets a macro create identifiers. Together they let you generate many similar names from a pattern:

```c
#define DECLARE_COUNTER(name) static int name##_count = 0;
#define REPORT(name) printf("%s: %d\n", #name, name##_count);
```

The predict question uses token pasting to create a variable with a computed name:

```c predict id=token-paste title="What is printed?"
#include <stdio.h>

#define MAKE_VAR(n) int var_##n = (n) * 10;

MAKE_VAR(3)

int main(void) {
    printf("%d\n", var_3);
    return 0;
}
--- options
3
* 30
var_3
compile error
--- explain
`MAKE_VAR(3)` expands to `int var_3 = (3) * 10;`. The `##` operator pasted `var_` and the argument `3` into the single identifier `var_3`. The initializer evaluates to `30`, which the `printf` prints.

> **Pitfall:** Token pasting creates identifiers that are invisible to the search tools most people use. A macro that defines `handle_##name` can make a function that nobody can find by searching for `handle_`. Name generated code clearly, and keep the generating macro near its uses.

## X-macros: one list, many uses

Often a program needs the same list in several places: an enum of error codes, a table of their names, a table of their messages. Keeping those lists in sync by hand is error-prone. An **X-macro** puts the list in one place as a macro that takes another macro as an argument. Each use supplies a different macro, and the list expands once per use.

```c
#define COLOR_LIST(X) \
    X(RED)            \
    X(GREEN)          \
    X(BLUE)

#define AS_ENUM(name) COLOR_##name,
#define AS_NAME(name) #name,

typedef enum { COLOR_LIST(AS_ENUM) COLOR_COUNT } color;
static const char *color_names[] = { COLOR_LIST(AS_NAME) };
```

The enum and the name table now come from the same list. Adding `YELLOW` to `COLOR_LIST` updates both automatically, so the names cannot drift out of order. That is the entire value of the pattern: one edit, every table stays correct.

The predict question checks the generated table:

```c predict id=x-macro-names title="Which name is at index 1?"
#include <stdio.h>

#define COLOR_LIST(X) \
    X(RED)            \
    X(GREEN)          \
    X(BLUE)

#define AS_NAME(name) #name,

static const char *color_names[] = { COLOR_LIST(AS_NAME) };

int main(void) {
    printf("%s\n", color_names[1]);
    return 0;
}
--- options
RED
* GREEN
BLUE
COLOR_LIST
--- explain
`COLOR_LIST(AS_NAME)` expands to `"RED", "GREEN", "BLUE",`, because `AS_NAME` stringizes each name and adds a comma. Index `1` is the second entry, `"GREEN"`. The table is generated from the list, so it is never out of step with the enum built from the same list.
```

## Generating functions and switch cases

The same technique creates functions for each entry. A macro can declare one function per name, and a second macro can build a dispatch table from the same list, so you never write the repetitive code by hand. The benefit grows with the size of the list, and so does the risk of making the macro hard to read. Keep the list macro short, name the parameter so the purpose is clear, and document what each use expects.

> **Tip:** Put the list macro in its own header file, such as `colors.def`, and `#include` it at each use with the macros defined just before. This is the classic `.def` file pattern used in compilers and kernels, and it keeps large lists readable.

## When not to use a macro

Macros do not respect scope, types or evaluation order, and debuggers show the code after expansion, which is hard to follow. Prefer these alternatives when they work:

- A `static inline` function instead of a macro that computes a value.
- A `const` variable or an `enum` instead of a `#define` constant, so the type is checked and the name appears in debugger output.
- Ordinary code instead of a macro that generates statements, unless the repetition is large and the macro is well tested.

Macros earn their place when they generate code the language cannot express, such as stringizing a name or building a list used in several places. Reach for them for those reasons, and not for convenience.

> **In the wild:** Operating system kernels use X-macros to define system call tables and error code names, because the tables must match the enum exactly. Compilers use `.def` files for instruction sets and diagnostic messages for the same reason.

## Recap

- Wrap multi-statement macros in `do { ... } while (0)` so they behave like one statement.
- Use `#` to stringize an argument and `##` to paste tokens into a new identifier.
- An X-macro keeps several parallel lists in sync by generating each one from a single list macro.
- Prefer inline functions, `const` values and enums when they do the job, and name generated code clearly.
- Keep macro lists in `.def` files and document what each use expects.

**Up next:** Generic containers with `void *`, where one implementation serves many element types.
