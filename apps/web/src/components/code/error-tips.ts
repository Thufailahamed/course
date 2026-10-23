import type { PyError } from "./runtime";

/** Plain-language explanations for the errors Python, NumPy and Java learners hit most. Specific entries come first. */
const TIPS: { test: (e: PyError) => boolean; tip: (e: PyError) => string }[] = [
  {
    test: (e) => e.ename === "CompileError" && /cannot find symbol/.test(e.evalue),
    tip: () => "The compiler can't find that name. Check the spelling and capitalization (`string` is not `String`), make sure the variable is declared before this line, and confirm the method exists on the type you called it on.",
  },
  {
    test: (e) => e.ename === "CompileError" && /';' expected/.test(e.evalue),
    tip: () => "A statement is missing its semicolon. In Java every statement ends with `;` — check the line above the error too, since the compiler often notices on the next line.",
  },
  {
    test: (e) => e.ename === "CompileError" && /(\)|'}'|'\]') expected|illegal start of expression|not a statement/.test(e.evalue),
    tip: () => "The brackets or punctuation don't line up. Count the opening and closing `(`, `{` and `[` around this line, and check that the previous line isn't missing a `;` or an operator.",
  },
  {
    test: (e) => e.ename === "CompileError" && /reached end of file while parsing/.test(e.evalue),
    tip: () => "A `{` was never closed. Match every opening brace with a closing one, usually at the end of the class and each method.",
  },
  {
    test: (e) => e.ename === "CompileError" && /incompatible types/.test(e.evalue),
    tip: () => "The value on the right doesn't fit the type on the left. `int` and `double` mix in one direction only, `String` is not a number, and a `List<String>` can't hold an `int`. Convert explicitly: `Integer.parseInt(text)`, `String.valueOf(n)`, or `(double) n`.",
  },
  {
    test: (e) => e.ename === "CompileError" && /non-static (variable|method).*cannot be referenced from a static context/.test(e.evalue),
    tip: () => "`main` is `static`, so it can't use instance fields or methods directly. Either make the member `static`, or create an object first: `var obj = new Thing(); obj.method();`.",
  },
  {
    test: (e) => e.ename === "CompileError" && /missing return statement/.test(e.evalue),
    tip: () => "A method that promises a return type must return a value on every path. Add a `return` after the loop or in the final `else` branch, even if you think it can't be reached.",
  },
  {
    test: (e) => e.ename === "CompileError" && /variable .* might not have been initialized/.test(e.evalue),
    tip: () => "Local variables must be given a value before they're read. Initialise it where you declare it (`int total = 0;`) or in every branch of an `if`.",
  },
  {
    test: (e) => e.ename === "CompileError" && /is public, should be declared in a file named/.test(e.evalue),
    tip: () => "A public class must live in a file with the same name. In this course use `public class Main` for complete-source (`class`) cells, or switch the cell to snippet mode.",
  },
  {
    test: (e) => e.ename === "CompileError" && /(cannot be applied to given types|no suitable method found)/.test(e.evalue),
    tip: () => "The method exists, but not with those arguments. Compare the call with its declaration: the number, order and types must line up. `println(1 + 2)` prints `3`, while `println(\"1\" + 2)` prints `12`.",
  },
  {
    test: (e) => e.ename === "CompileError" && /unclosed (string|character) literal/.test(e.evalue),
    tip: () => "A quote was never closed. Strings use double quotes (`\"text\"`) and characters use single quotes (`'a'`). Escape a quote inside a string with `\\\"`.",
  },
  {
    test: (e) => e.ename === "CompileError" && /(package|class|symbol).*does not exist/.test(e.evalue),
    tip: () => "Java can't find that type or package. The course auto-imports `java.util`, `java.io`, `java.nio.file`, `java.math` and `java.time`; for anything else add an `import` in a `class` cell.",
  },
  {
    test: (e) => e.ename === "CompileError" && /duplicate class/.test(e.evalue),
    tip: () => "Two classes in the same file share a name. Rename one, or move it into its own file.",
  },
  {
    test: (e) => e.ename === "CompileError",
    tip: () => "Java must compile before it can run. Read the first error first — later errors are often caused by the first one. Check semicolons, braces, types and spelling.",
  },
  {
    test: (e) => e.ename === "NullPointerException",
    tip: () => "You used a reference that doesn't point to an object. The usual causes are an uninitialised variable, a method that returned `null`, or a missing entry in a map. Print the value or guard with `if (x != null)`.",
  },
  {
    test: (e) => e.ename === "ArrayIndexOutOfBoundsException",
    tip: () => "Array indexes run from `0` to `length - 1`. An array of 3 items has indexes `0`, `1` and `2`, and the last is `a[a.length - 1]`. Print `a.length` to check.",
  },
  {
    test: (e) => e.ename === "StringIndexOutOfBoundsException",
    tip: () => "String positions run from `0` to `length() - 1`. Use `s.charAt(s.length() - 1)` for the last character, and check `s.isEmpty()` before reading the first one.",
  },
  {
    test: (e) => e.ename === "NumberFormatException",
    tip: () => "That text isn't a number. `Integer.parseInt` accepts whole numbers like `\"42\"` (no spaces or decimal point); use `Double.parseDouble` for decimals and `.trim()` stray whitespace.",
  },
  {
    test: (e) => e.ename === "ArithmeticException",
    tip: () => "You divided an integer by zero. Check the divisor before dividing. Floating-point division by zero gives `Infinity` or `NaN` instead of throwing.",
  },
  {
    test: (e) => e.ename === "InputMismatchException",
    tip: () => "`Scanner` read a token of the wrong type — for example `nextInt()` when the input was text. Call `hasNextInt()` first, or read with `nextLine()` and parse the string yourself.",
  },
  {
    test: (e) => e.ename === "NoSuchElementException",
    tip: () => "There was no more input to read. The in-browser runner has no keyboard, so challenges pass values as method arguments or read a `String` you create in the code.",
  },
  {
    test: (e) => e.ename === "ClassCastException",
    tip: () => "You cast an object to a type it isn't. Check with `instanceof` before casting, and remember that a superclass variable can hold a subclass object but not the other way round.",
  },
  {
    test: (e) => e.ename === "UnsupportedOperationException",
    tip: () => "`Arrays.asList(...)` and `List.of(...)` return fixed-size lists. Wrap one in `new ArrayList<>(...)` when you need to `add` or `remove`.",
  },
  {
    test: (e) => e.ename === "ConcurrentModificationException",
    tip: () => "You changed a collection while a `for`-each loop was walking it. Use an index loop backwards, collect the items to remove and delete them afterwards, or use an `Iterator` and call `it.remove()`.",
  },
  {
    test: (e) => e.ename === "StackOverflowError",
    tip: () => "A method kept calling itself without reaching a base case. Check the condition that should stop the recursion and make sure each call moves closer to it.",
  },
  {
    test: (e) => e.ename === "RuntimeError",
    tip: () => "The Java program stopped with an error. Read the first line of the stack trace for the exception type, then the first line that points at your code.",
  },
  {
    test: (e) => /could not be broadcast together/.test(e.evalue),
    tip: (e) => {
      const shapes = [...e.evalue.matchAll(/\(([\d, ]*)\)/g)].map((m) => `(${m[1]})`);
      return `Broadcasting failed${shapes.length >= 2 ? ` for shapes ${shapes.slice(0, 2).join(" and ")}` : ""}. Compare the shapes from the right: each pair of dimensions must be equal, or one of them must be 1. Print \`.shape\` on both operands, then use \`reshape\`, \`[:, None]\` or \`np.newaxis\` to line them up.`;
    },
  },
  {
    test: (e) => /cannot reshape array of size/.test(e.evalue),
    tip: () => "The new shape must hold exactly the same number of elements as the original. Multiply the dimensions you asked for, compare with `.size`, or pass `-1` for one dimension and let NumPy work it out.",
  },
  {
    test: (e) => /too many indices for array/.test(e.evalue),
    tip: () => "You indexed more dimensions than the array has. Check `.ndim`: a 1-D array takes one index (`a[i]`), a 2-D array takes two (`a[i, j]`).",
  },
  {
    test: (e) => e.ename === "IndexError" && /out of bounds/.test(e.evalue),
    tip: () => "Valid indices run from `0` to `len - 1` (or `-len` to `-1`) along each axis. Look at `.shape` to see how long that axis is.",
  },
  {
    test: (e) => e.ename === "IndexError" && /index out of range/.test(e.evalue),
    tip: () => "You asked for a position that doesn't exist. Positions start at `0`, so a sequence of 3 items has indices `0`, `1` and `2`, and the last one is `x[len(x) - 1]` (or simply `x[-1]`). Print `len(...)` to see how long it really is.",
  },
  {
    test: (e) => /matmul: Input operand 1 has a mismatch|shapes .* not aligned/.test(e.evalue),
    tip: () => "For `A @ B` the inner dimensions must match: `(n, k) @ (k, m) → (n, m)`. Check the shapes, and transpose with `.T` if one operand is the wrong way round.",
  },
  {
    test: (e) => /truth value of an array with more than one element is ambiguous/.test(e.evalue),
    tip: () => "`if`, `and`, `or` and `not` need a single True/False, but you gave them a whole array. Use `.any()` / `.all()` to reduce it, or the element-wise operators `&`, `|`, `~`. Wrap each comparison in parentheses: `(a > 0) & (a < 5)`.",
  },
  {
    test: (e) => /ufunc .bitwise_(and|or|xor). not supported/.test(e.evalue),
    tip: () => "Operator precedence bit you: `&` and `|` bind tighter than `<`, `>=` and `==`, so `a >= 10 & a <= 20` is read as `a >= (10 & a) <= 20`. Wrap each comparison in parentheses: `(a >= 10) & (a <= 20)`.",
  },
  {
    test: (e) => /setting an array element with a sequence|inhomogeneous shape/.test(e.evalue),
    tip: () => "NumPy arrays must be rectangular. Every row needs the same length, and every element must be a scalar of a compatible type.",
  },
  {
    test: (e) => /Cannot cast ufunc .* output from dtype|Cannot cast array data from dtype/.test(e.evalue),
    tip: () => "An in-place operation (like `+=`) tried to store a float result in an integer array. Convert first with `.astype(float)`, or write the result to a new array.",
  },
  {
    test: (e) => e.ename === "NameError" && /'np'/.test(e.evalue),
    tip: () => "`np` isn't defined. Add `import numpy as np` at the top of the cell.",
  },
  {
    test: (e) => e.ename === "UnboundLocalError",
    tip: () => "You assign to this name somewhere inside the function, so Python treats it as a *local* variable for the whole function, and here it's read before it has a value. Pass the value in as a parameter and `return` the new value, or (rarely) declare it `global`.",
  },
  {
    test: (e) => e.ename === "NameError",
    tip: () => "Python doesn't know this name yet. Check the spelling, and make sure the cell that defines it ran first. Cells share variables in the order you run them.",
  },
  {
    test: (e) => e.ename === "IndentationError" || e.ename === "TabError",
    tip: () => "Python uses indentation to group code. Indent consistently (4 spaces) after lines ending in `:`, and line the block back up when it ends.",
  },
  {
    test: (e) => e.ename === "SyntaxError",
    tip: () => "Python couldn't parse this line. Look for a missing bracket, quote, comma or colon, often at the end of the previous line.",
  },
  {
    test: (e) => e.ename === "TypeError" && /can only concatenate str/.test(e.evalue),
    tip: () => "`+` can join text to text, but not text to a number. Convert the number with `str(...)`, or let an f-string do it: `f\"Total: {total}\"`.",
  },
  {
    test: (e) => e.ename === "TypeError" && /'NoneType' object/.test(e.evalue),
    tip: () => "Something here is `None`, the value Python uses for \"nothing\". The usual cause is a function that `print`s instead of `return`ing, or a method like `list.sort()` that changes the list in place and returns `None`.",
  },
  {
    test: (e) => e.ename === "TypeError" && /object does not support item assignment/.test(e.evalue),
    tip: () => "This value can't be changed in place. Strings and tuples are *immutable*: build a new one instead (with slicing, `.replace()` or `+`), or use a list if you need to change items.",
  },
  {
    test: (e) => e.ename === "TypeError" && /takes \d+ positional arguments? but \d+ (were|was) given/.test(e.evalue),
    tip: () => "The call passes a different number of arguments than the function accepts. Compare the call with the `def` line. Inside a class, every method needs `self` as its first parameter.",
  },
  {
    test: (e) => e.ename === "TypeError" && /missing \d+ required (positional|keyword-only) argument/.test(e.evalue),
    tip: () => "The function needs more arguments than this call gives it. Look at its `def` line for the parameters without default values, and pass one value for each.",
  },
  {
    test: (e) => e.ename === "TypeError" && /not callable/.test(e.evalue),
    tip: () => "You put `()` after something that isn't a function, like a number, a string, or an attribute such as `.shape`. Also check that you haven't reused a built-in's name for a variable, as in `sum = 0` or `list = [...]`.",
  },
  {
    test: (e) => e.ename === "TypeError" && /unsupported operand type/.test(e.evalue),
    tip: () => "These two values can't be combined with this operator, most often text and a number, as in `\"3\" + 4`. Convert first with `int(...)`, `float(...)` or `str(...)`. Plain lists don't do element-wise math either: use a loop, a comprehension or a NumPy array.",
  },
  {
    test: (e) => e.ename === "TypeError" && /'[<>]=?' not supported between instances/.test(e.evalue),
    tip: () => "Python can't order these two kinds of values, for example a number and a string. Make every item the same type before sorting or comparing, or pass a `key=` function.",
  },
  {
    test: (e) => e.ename === "ValueError" && /invalid literal for int\(\)|could not convert string to float/.test(e.evalue),
    tip: () => "This text doesn't look like a number. `int()` only accepts whole numbers like `\"42\"`, so use `float()` for decimals, `.strip()` stray spaces, and check with `.isdigit()` or `try`/`except ValueError` when the text comes from a user or a file.",
  },
  {
    test: (e) => e.ename === "ValueError" && /(too many|not enough) values to unpack/.test(e.evalue),
    tip: () => "The number of names on the left must match the number of items on the right. Print the value you're unpacking to see how many items it really has, or use `*rest` to collect the extras.",
  },
  {
    test: (e) => e.ename === "KeyError",
    tip: () => "That key isn't in the dictionary. Check spelling and capitalization, test first with `key in d`, or use `d.get(key, default)` to fall back to a default value.",
  },
  {
    test: (e) => e.ename === "EOFError" && /type_answers/.test(e.evalue),
    tip: () => "The browser can't pause for typing, so `input()` reads queued answers. Call `type_answers(\"...\")` before the code that asks for input, with one answer per `input()` call.",
  },
  {
    test: (e) => e.ename === "FileNotFoundError",
    tip: () => "There's no file with that name in the current folder. Check the spelling and extension, and make sure the code that creates the file ran first.",
  },
  {
    test: (e) => e.ename === "AttributeError" && /'NoneType' object has no attribute/.test(e.evalue),
    tip: () => "You called a method on `None`. Usually a function or method returned nothing, for example `x = my_list.sort()` (which sorts in place and returns `None`), or a function that `print`s instead of `return`ing.",
  },
  {
    test: (e) => e.ename === "AttributeError" && /'list' object has no attribute/.test(e.evalue),
    tip: () => "Lists don't have a method with that name. Check the spelling (it's `append`, not `push` or `add`). If you expected NumPy array methods, wrap the list with `np.array(...)` first.",
  },
  {
    test: (e) => e.ename === "AttributeError",
    tip: () => "This object has no attribute with that name. Check the spelling. Pressing `.` in the editor lists the available attributes.",
  },
  {
    test: (e) => e.ename === "ZeroDivisionError",
    tip: () => "Something was divided by zero (with `/`, `//` or `%`). Check the denominator with an `if` first, or catch `ZeroDivisionError` with `try`/`except`. NumPy arrays return `inf`/`nan` instead of raising.",
  },
  {
    test: (e) => e.ename === "KeyboardInterrupt",
    tip: () => "Execution was stopped. If the code was stuck, look for a loop whose condition never becomes false.",
  },
  {
    test: (e) => e.ename === "RecursionError",
    tip: () => "A function kept calling itself without reaching a base case. Check the condition that should stop the recursion.",
  },
  {
    test: (e) => e.ename === "MemoryError" || /Unable to allocate/.test(e.evalue),
    tip: () => "That array is too large for the browser's memory. Try a smaller shape. In-browser Python has a few GB at most.",
  },
];

export function errorTip(e: PyError): string | null {
  return TIPS.find((t) => t.test(e))?.tip(e) ?? null;
}
