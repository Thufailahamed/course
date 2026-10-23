A `String` is a sequence of characters. Unlike the primitive types, it is an object with methods, and it is **immutable**: once created, its characters never change. Every method that seems to modify a string actually returns a new one.

## Creating and joining strings

```java run
String first = "Ada";
String last = "Lovelace";
String full = first + " " + last;

System.out.println(full);
System.out.println("Length: " + full.length());
System.out.println("Upper: " + full.toUpperCase());
System.out.println("Lower: " + full.toLowerCase());
```

The `+` operator joins strings. `length()` counts characters, including spaces. `toUpperCase()` and `toLowerCase()` return new strings; they do not alter `full`.

## Indexing and slicing

Characters are numbered from zero. `charAt(0)` is the first character. `substring(start, end)` includes `start` but stops before `end`:

```java run
String word = "programming";

System.out.println(word.charAt(0));
System.out.println(word.charAt(word.length() - 1));
System.out.println(word.substring(0, 4));
System.out.println(word.substring(4));
```

`substring(0, 4)` gives `"prog"`. `substring(4)` runs to the end and gives `"ramming"`. Asking for an index outside the string throws an exception, so check `length()` when the input is not fixed.

## Comparing strings

Use `equals`, not `==`, to compare text. `==` asks whether two variables point at the same object; `equals` asks whether the characters are the same:

```java run
String a = "java";
String b = "java";
String c = new String("java");

System.out.println(a == b);
System.out.println(a == c);
System.out.println(a.equals(c));
System.out.println(a.equalsIgnoreCase("JAVA"));
```

The first is `true` because identical literals share storage. The second is `false` because `new String` creates a separate object. The third is `true` because the contents match. In real programs, always use `equals` for text.

## Useful methods

```java run
String sentence = "  Learning Java is fun  ";

System.out.println(sentence.trim());
System.out.println(sentence.trim().contains("Java"));
System.out.println(sentence.trim().startsWith("Learn"));
System.out.println(sentence.trim().endsWith("fun"));
System.out.println(sentence.replace("fun", "worthwhile"));
System.out.println(sentence.indexOf("Java"));
System.out.println(String.join(" | ", "one", "two", "three"));
```

`trim()` removes leading and trailing spaces. `contains`, `startsWith` and `endsWith` return booleans. `replace` returns a new string. `indexOf` returns the position of the first match, or `-1` if it is absent.

```java predict id=strings-predict title="What is printed?"
String s = "Java";
System.out.println(s.substring(1, 3));
--- options
* av
ava
Ja
va
--- explain
`substring(1, 3)` starts at index 1 (`a`) and stops before index 3, so it returns the characters at indexes 1 and 2: `"av"`.
```

## Challenges

```java exercise id=make-username title="Build a username"
String first = "Ada";
String last = "Lovelace";
String username = "";

// Join the lower-case first name, a dot, and the lower-case last name.
--- solution
String first = "Ada";
String last = "Lovelace";
String username = first.toLowerCase() + "." + last.toLowerCase();
--- test
__check(username.equals("ada.lovelace"), "The username should be ada.lovelace");
--- hint
Call `toLowerCase()` on each name before joining them.
--- hint
`first.toLowerCase() + "." + last.toLowerCase()`
```

```java exercise id=first-last-letter title="Print the first and last letters"
String word = "programming";

// Print the first character, a space, and the last character.
--- solution
String word = "programming";
System.out.println(word.charAt(0) + " " + word.charAt(word.length() - 1));
--- test
__check(__out().trim().equals("p g"), "The output should be p g");
--- hint
The last index is `word.length() - 1`.
--- hint
Join `charAt(0)`, `" "`, and `charAt(word.length() - 1)`.
```

```java debug id=fix-string-compare title="The answer is rejected"
String answer = new String("yes");
System.out.println(answer == "yes" ? "accepted" : "rejected");
--- solution
String answer = new String("yes");
System.out.println(answer.equals("yes") ? "accepted" : "rejected");
--- test
__check(__out().trim().equals("accepted"), "A matching answer should be accepted");
--- hint
`==` compares object references, not the characters inside the strings.
--- hint
Replace `answer == "yes"` with `answer.equals("yes")`.
```
