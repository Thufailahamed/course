A `boolean` is either `true` or `false`. Comparisons produce booleans, and logical operators combine them. Almost every decision a program makes is a boolean behind the scenes.

## Comparisons

```java run
int age = 20;
System.out.println(age > 18);
System.out.println(age >= 20);
System.out.println(age < 18);
System.out.println(age == 20);
System.out.println(age != 20);
```

The result of each comparison is a boolean, which prints as `true` or `false`. Use `==` for equality and `!=` for inequality. A single `=` assigns; a double `==` compares.

Strings need `equals` instead of `==`, as the previous lesson showed:

```java run
String role = "admin";
System.out.println(role.equals("admin"));
System.out.println(role.equalsIgnoreCase("ADMIN"));
System.out.println(!role.isEmpty());
```

## Combining conditions

`&&` means **and**, `||` means **or**, and `!` means **not**. `&&` binds more tightly than `||`, so parentheses are often clearer:

```java run
int age = 16;
boolean hasTicket = true;

System.out.println(age >= 18 && hasTicket);
System.out.println(age >= 18 || hasTicket);
System.out.println(!hasTicket);
System.out.println((age >= 13 && age <= 19) || hasTicket);
```

Both `&&` and `||` short-circuit. In `a && b`, if `a` is false, `b` is not evaluated. In `a || b`, if `a` is true, `b` is not evaluated. That matters when the right side has a side effect or could throw.

```java run
int count = 0;
boolean result = false && (++count > 0);
System.out.println(result);
System.out.println(count);

boolean other = true || (++count > 0);
System.out.println(other);
System.out.println(count);
```

`count` stays `0` in both cases because the right side never runs. Short-circuiting is a feature, not a quirk: it lets you write `name != null && name.length() > 0` safely.

## Boolean values from text

```java run
String flag = "true";
boolean enabled = Boolean.parseBoolean(flag);
System.out.println(enabled);
System.out.println(Boolean.toString(false));
```

`parseBoolean` returns `true` only for the text `"true"`, ignoring case. Everything else becomes `false`; it does not throw.

```java predict id=booleans-predict title="What is printed?"
System.out.println(true && false || true);
--- options
* true
false
compile error
null
--- explain
`&&` is evaluated before `||`, so the expression is `(true && false) || true`, which is `false || true`, or `true`.
```

## Challenges

```java exercise id=is-teenager title="Check for the teenage years"
int age = 15;
boolean isTeenager = false;

// True when age is from 13 through 19, inclusive.
--- solution
int age = 15;
boolean isTeenager = age >= 13 && age <= 19;
--- test
__check(isTeenager, "15 is a teenager");
--- hint
Two comparisons joined with `&&`: at least 13 and at most 19.
--- hint
`age >= 13 && age <= 19`
```

```java exercise id=can-vote title="Check voting eligibility"
int age = 20;
boolean citizen = true;
boolean canVote = false;

// A person can vote when they are 18 or older and a citizen.
--- solution
int age = 20;
boolean citizen = true;
boolean canVote = age >= 18 && citizen;
--- test
__check(canVote, "A 20-year-old citizen can vote");
--- hint
Both conditions must be true, so use `&&`.
--- hint
`age >= 18 && citizen`
```

```java debug id=fix-ride-condition title="The ride check lets the wrong person on"
int height = 130;
int age = 6;
boolean canRide = height >= 120 || age >= 8;
System.out.println(canRide);
--- solution
int height = 130;
int age = 6;
boolean canRide = height >= 120 && age >= 8;
System.out.println(canRide);
--- test
__check(__out().trim().equals("false"), "A six-year-old is too young even when tall enough");
--- hint
The ride requires **both** a tall enough rider and an old enough rider.
--- hint
Change `||` to `&&`.
```
