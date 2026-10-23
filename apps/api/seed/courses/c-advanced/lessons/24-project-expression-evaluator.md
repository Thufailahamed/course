Every calculator, configuration file and query language begins with the same two steps: read the text and break it into pieces, then understand how those pieces combine. The first step is a **lexer** or tokenizer. The second is a **parser** that turns the tokens into meaning, which for arithmetic means respecting precedence and parentheses. Writing both by hand is one of the best exercises in systems programming, because it uses almost every idea in the course: careful pointer movement, recursion, error reporting and the discipline of never reading past the end of a buffer.

This final project builds an evaluator for integer arithmetic with `+`, `-`, `*`, `/` and parentheses. The design is small on purpose, so that you can read every line and understand why it is correct.

## The grammar

Precedence and associativity are written into a grammar, one rule per precedence level. Each rule calls the next level down, which is what makes multiplication bind tighter than addition without any special table:

```
expr    := term   (('+' | '-') term)*
term    := factor (('*' | '/') factor)*
factor  := NUMBER | '(' expr ')'
```

Read the rules as instructions. An expression is one term, followed by any number of additions or subtractions, each applied to another term. A term is one factor, followed by any number of multiplications or divisions. A factor is a number or a parenthesized expression, which starts the whole cycle again. The structure of the parser follows this grammar exactly, one function per rule, and this style is called **recursive descent**.

## Tokens, and why this version skips them

A full lexer produces a stream of tokens, such as `NUMBER(12)`, `PLUS` and `STAR`, before parsing begins. That separation pays off as a language grows. For a grammar this small, the parser can read characters directly, and the code stays shorter. The first predict question shows the job a tokenizer does, which is to group digits into one token and skip whitespace:

```c predict id=token-count title="How many tokens are in this expression?"
#include <stdio.h>
#include <ctype.h>

int main(void) {
    const char *text = "12 + 3*4";
    int tokens = 0;
    const char *p = text;
    while (*p != '\0') {
        if (isspace((unsigned char)*p)) {
            p++;
            continue;
        }
        tokens++;
        if (isdigit((unsigned char)*p)) {
            while (isdigit((unsigned char)*p)) p++;
        } else {
            p++;
        }
    }
    printf("%d\n", tokens);
    return 0;
}
--- options
3
4
* 5
7
--- explain
The tokens are `12`, `+`, `3`, `*` and `4`, which makes five. The digits of `12` form one token, because the inner loop consumes every digit in a row. Spaces separate tokens and produce none. Grouping characters into tokens is the job the parser would otherwise repeat at every level, which is why a real lexer exists.

> **Tip:** Use `unsigned char` when you call `isdigit` and `isspace`. Passing a negative `char` value is undefined behavior, and that can happen on platforms where `char` is signed and the input contains non-ASCII bytes.

## The parser state

The parser needs two things: the current position in the text, and an error flag that any level can set. Passing a small struct by pointer keeps every function's signature simple:

```c
typedef struct {
    const char *pos;   /* the next unread character */
    int error;         /* set to 1 when the input is not a valid expression */
} parser;

static void skip_spaces(parser *ps) {
    while (isspace((unsigned char)*ps->pos)) ps->pos++;
}
```

The error flag is a design decision. Once it is set, the parser can return zero and let the callers unwind, and the top-level function reports the failure once. This is simpler than returning an error code from every level, which would make the arithmetic awkward.

## Factors: numbers and parentheses

A factor is the innermost level. It reads a number, or it reads a parenthesized expression by calling back up to `parse_expr`. The recursion between these functions is what gives parentheses their meaning:

```c
static long parse_expr(parser *ps);

static long parse_factor(parser *ps) {
    skip_spaces(ps);
    if (*ps->pos == '(') {
        ps->pos++;
        long value = parse_expr(ps);
        skip_spaces(ps);
        if (*ps->pos == ')') ps->pos++;
        else ps->error = 1;             /* missing closing parenthesis */
        return value;
    }
    if (!isdigit((unsigned char)*ps->pos)) {
        ps->error = 1;                  /* expected a number or '(' */
        return 0;
    }
    long value = 0;
    while (isdigit((unsigned char)*ps->pos)) {
        value = value * 10 + (*ps->pos - '0');
        ps->pos++;
    }
    return value;
}
```

Look at the number loop: it reads one digit at a time, and it checks `isdigit` before it touches the character, so it never reads past the end of the string. The terminating null byte is not a digit, so the loop stops there. Overflow of `value` is possible with very long inputs, and a production evaluator would check it before the multiplication, as lesson 20 showed. Here, the comment marks the limit.

## Terms and expressions

The two levels above factors follow the same loop shape. Each one reads an operand, then keeps reading operator and operand pairs for as long as the next character is one of its operators:

```c
static long parse_term(parser *ps) {
    long value = parse_factor(ps);
    for (;;) {
        skip_spaces(ps);
        if (*ps->pos == '*') {
            ps->pos++;
            value *= parse_factor(ps);
        } else if (*ps->pos == '/') {
            ps->pos++;
            long divisor = parse_factor(ps);
            if (divisor == 0) {
                ps->error = 1;         /* division by zero is an error, not a crash */
                return 0;
            }
            value /= divisor;
        } else {
            return value;
        }
    }
}

static long parse_expr(parser *ps) {
    long value = parse_term(ps);
    for (;;) {
        skip_spaces(ps);
        if (*ps->pos == '+') {
            ps->pos++;
            value += parse_term(ps);
        } else if (*ps->pos == '-') {
            ps->pos++;
            value -= parse_term(ps);
        } else {
            return value;
        }
    }
}
```

The loop in `parse_term` is where precedence lives. A `*` is consumed inside the term, before any `+` gets a chance to run, so `2 + 3 * 4` multiplies `3` and `4` first. The predict question checks exactly that:

```c predict id=precedence title="What value does the parser return?"
#include <stdio.h>
#include <ctype.h>

typedef struct {
    const char *pos;
    int error;
} parser;

static void skip_spaces(parser *ps) {
    while (isspace((unsigned char)*ps->pos)) ps->pos++;
}

static long parse_expr(parser *ps);

static long parse_factor(parser *ps) {
    skip_spaces(ps);
    if (*ps->pos == '(') {
        ps->pos++;
        long value = parse_expr(ps);
        skip_spaces(ps);
        if (*ps->pos == ')') ps->pos++;
        else ps->error = 1;
        return value;
    }
    if (!isdigit((unsigned char)*ps->pos)) {
        ps->error = 1;
        return 0;
    }
    long value = 0;
    while (isdigit((unsigned char)*ps->pos)) {
        value = value * 10 + (*ps->pos - '0');
        ps->pos++;
    }
    return value;
}

static long parse_term(parser *ps) {
    long value = parse_factor(ps);
    for (;;) {
        skip_spaces(ps);
        if (*ps->pos == '*') {
            ps->pos++;
            value *= parse_factor(ps);
        } else if (*ps->pos == '/') {
            ps->pos++;
            long divisor = parse_factor(ps);
            if (divisor == 0) { ps->error = 1; return 0; }
            value /= divisor;
        } else {
            return value;
        }
    }
}

static long parse_expr(parser *ps) {
    long value = parse_term(ps);
    for (;;) {
        skip_spaces(ps);
        if (*ps->pos == '+') {
            ps->pos++;
            value += parse_term(ps);
        } else if (*ps->pos == '-') {
            ps->pos++;
            value -= parse_term(ps);
        } else {
            return value;
        }
    }
}

int main(void) {
    parser ps = { "2 + 3 * 4", 0 };
    printf("%ld\n", parse_expr(&ps));
    return 0;
}
--- options
20
* 14
24
11
--- explain
`parse_expr` reads the term `2`, then sees `+` and reads another term. That term is `3`, followed by `*`, so `parse_term` consumes `4` as well and returns `12`. The addition then gives `2 + 12`, which is `14`. Because multiplication is handled one level lower, it binds tighter than addition without any extra logic.
```

## Parentheses change the grouping

A parenthesized expression is a factor, so it binds as tightly as a number. Parentheses therefore override precedence, and the recursion from `parse_factor` back into `parse_expr` is exactly what makes that happen. The next question evaluates the same numbers with different grouping, using the same parser:

```c predict id=parentheses title="What value does the parser return with parentheses?"
#include <stdio.h>
#include <ctype.h>

typedef struct {
    const char *pos;
    int error;
} parser;

static void skip_spaces(parser *ps) {
    while (isspace((unsigned char)*ps->pos)) ps->pos++;
}

static long parse_expr(parser *ps);

static long parse_factor(parser *ps) {
    skip_spaces(ps);
    if (*ps->pos == '(') {
        ps->pos++;
        long value = parse_expr(ps);
        skip_spaces(ps);
        if (*ps->pos == ')') ps->pos++;
        else ps->error = 1;
        return value;
    }
    long value = 0;
    while (isdigit((unsigned char)*ps->pos)) {
        value = value * 10 + (*ps->pos - '0');
        ps->pos++;
    }
    return value;
}

static long parse_term(parser *ps) {
    long value = parse_factor(ps);
    for (;;) {
        skip_spaces(ps);
        if (*ps->pos == '*') { ps->pos++; value *= parse_factor(ps); }
        else return value;
    }
}

static long parse_expr(parser *ps) {
    long value = parse_term(ps);
    for (;;) {
        skip_spaces(ps);
        if (*ps->pos == '+') { ps->pos++; value += parse_term(ps); }
        else return value;
    }
}

int main(void) {
    parser ps = { "(2 + 3) * 4", 0 };
    printf("%ld\n", parse_expr(&ps));
    return 0;
}
--- options
14
* 20
17
11
--- explain
The factor begins with `(`, so `parse_factor` calls `parse_expr` for the inside, which reads `2 + 3` and returns `5`. The closing parenthesis is consumed, and the factor is `5`. Back in `parse_term`, the `*` multiplies `5` by `4`, giving `20`. Without the parentheses the same numbers would produce `14`, which is the difference the grammar is designed to express.
```

## Errors: report once, at the top

A bad input sets the error flag, and the caller checks it once at the end. The predict question triggers division by zero:

```c predict id=division-error title="What does the error flag hold after evaluating 8 / 0?"
#include <stdio.h>
#include <ctype.h>

typedef struct {
    const char *pos;
    int error;
} parser;

static void skip_spaces(parser *ps) {
    while (isspace((unsigned char)*ps->pos)) ps->pos++;
}

static long parse_factor(parser *ps) {
    skip_spaces(ps);
    long value = 0;
    while (isdigit((unsigned char)*ps->pos)) {
        value = value * 10 + (*ps->pos - '0');
        ps->pos++;
    }
    return value;
}

static long parse_term(parser *ps) {
    long value = parse_factor(ps);
    skip_spaces(ps);
    if (*ps->pos == '/') {
        ps->pos++;
        long divisor = parse_factor(ps);
        if (divisor == 0) {
            ps->error = 1;
            return 0;
        }
        value /= divisor;
    }
    return value;
}

int main(void) {
    parser ps = { "8 / 0", 0 };
    parse_term(&ps);
    printf("%d\n", ps.error);
    return 0;
}
--- options
0
* 1
8
error
--- explain
The divisor `0` triggers the check, which sets `error` to `1` and returns without dividing. Dividing by zero in C is undefined behavior for integers, so the explicit check turns a crash or an unpredictable result into a reported error. The caller reads the flag once, after the whole expression, which keeps the code paths short.

## The public function

The evaluator's public entry point hides the parser state and reports success or failure to the caller. It also rejects trailing characters, because `2 + 3 4` is not a valid expression:

```c
int evaluate(const char *text, long *result) {
    parser ps = { text, 0 };
    long value = parse_expr(&ps);
    skip_spaces(&ps);
    if (ps.error || *ps.pos != '\0') return 0;
    *result = value;
    return 1;
}
```

The check `*ps.pos != '\0'` is the one most people forget. Without it, the evaluator accepts a prefix of the input and silently ignores the rest. A test for `2 + 3 4` should fail, and this line makes it fail.

## Testing the evaluator

Test every level of the grammar and every failure mode. Cover single numbers, each operator alone, precedence between operators, nested parentheses, whitespace in unusual places, unbalanced parentheses, a missing operand, trailing garbage, and division by zero. For each case, check the result and the success flag. Run the tests under UndefinedBehaviorSanitizer, because the arithmetic is the most likely place for an unexpected undefined operation. Also run a fuzzer or a long list of random strings under AddressSanitizer, to confirm that no input can read outside the string.

> **Pitfall:** Recursive descent can recurse deeply on input such as thousands of nested parentheses, and each level uses stack space. A production parser sets a depth limit and reports an error beyond it. Adding that limit is a good exercise for after you finish this project.

> **In the wild:** Spreadsheet formulas, build tools and configuration languages use this same recursive descent structure. Compilers for real languages use it too, with a token stream, a symbol table and far richer error messages. Everything you wrote here scales to those tools.

## Recap

- A grammar with one rule per precedence level gives correct precedence without a table.
- Recursive descent maps each grammar rule to one function, and parentheses recurse back to the top level.
- Keep the parser state in a struct, and report errors with a flag that the top level checks.
- Check division by zero explicitly, and reject trailing input.
- Test every grammar level and every failure mode, under the sanitizers.

**Up next:** The final checkpoint, which ties the whole course together.
