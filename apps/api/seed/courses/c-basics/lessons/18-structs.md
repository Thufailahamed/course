Most real data is a bundle of related values. A student has a name, an id and a grade. A point has an x and a y. A struct lets you group those values under one name, so you can pass a student to a function, store a list of them, or save one to a file as a single unit. Structs are the C tool for modelling things, and the next few projects use them constantly.

## Defining and using a struct

```c
#include <stdio.h>

struct student {
    char name[32];
    int id;
    double grade;
};

int main(void) {
    struct student s = {"Ada", 1021, 91.5};

    printf("%s (#%d): %.1f\n", s.name, s.id, s.grade);
    return 0;
}
```

The definition describes a new type, `struct student`, and lists its members. Each member is accessed with a dot: `s.name`, `s.id`, `s.grade`. The braces in the declaration initialize the members in the order they were listed.

> **Tip:** Name the struct after what it models, in the singular. `struct student` is one student, and an array of them is `struct student roster[30]`.

## Structs are values

Assigning one struct to another copies every member. The copy is independent of the original, which surprises people who are used to references in other languages.

```c predict id=struct-copy title="What does this print?"
#include <stdio.h>

struct point { int x; int y; };

int main(void) {
    struct point a = {1, 2};
    struct point b = a;
    b.x = 10;
    printf("%d %d\n", a.x, b.x);
    return 0;
}
--- options
* 1 10
10 10
1 1
10 1
--- explain
`b = a` copies all the members, so `b` is a separate object that happens to hold the same values. Changing `b.x` leaves `a.x` alone. Plain assignment copies a whole struct, which is convenient, but it also means large structs cost time to copy. Pass a pointer to a large struct when you do not need a copy.
```

## Pointers to structs and the arrow

When you have a pointer to a struct, you can dereference it and then use the dot, but C provides the arrow `->` as a shorthand. `p->x` means `(*p).x`.

```c predict id=struct-arrow title="What does this print?"
#include <stdio.h>

struct item { int qty; };

void restock(struct item *it) {
    it->qty += 5;
}

int main(void) {
    struct item s = {2};
    restock(&s);
    printf("%d\n", s.qty);
    return 0;
}
--- options
* 7
2
5
10
--- explain
`restock` receives the address of `s`, so `it->qty` refers to `s.qty` itself. The function adds 5 to the quantity, turning 2 into 7, and `main` sees the change. Use `->` whenever you have a pointer to a struct, and `.` when you have the struct itself.
```

> **Pitfall:** `->` works only on pointers. Writing `s->qty` on a struct value is a compile error. Write `s.qty` for a value, and `p->qty` for a pointer.

## Initializing by name

Designated initializers name the members you want to set. The members you do not name become zero, and the order you write them no longer matters.

```c predict id=designated title="What does this print?"
#include <stdio.h>

struct config { int width; int height; int depth; };

int main(void) {
    struct config c = { .height = 4, .width = 3 };
    printf("%d %d %d\n", c.width, c.height, c.depth);
    return 0;
}
--- options
* 3 4 0
3 4 4
0 4 3
3 0 4
--- explain
The designated initializer sets `width` to 3 and `height` to 4 regardless of the order written. `depth` is not mentioned, so it is zero. Designated initializers are clearer than positional ones when a struct has many fields, and they stay readable when a field is added later.
```

## Arrays of structs

Structs fit naturally into arrays, and you can loop over them the same way you loop over numbers.

```c
#include <stdio.h>

struct student {
    const char *name;
    double grade;
};

int main(void) {
    struct student class_[] = {
        {"Ada", 91.5},
        {"Linus", 78.25},
        {"Grace", 88.0},
    };
    double total = 0.0;

    for (size_t i = 0; i < sizeof class_ / sizeof class_[0]; i++) {
        total += class_[i].grade;
    }
    printf("average: %.2f\n", total / 3);
    return 0;
}
```

The trailing comma after the last element is legal and often useful, because it makes adding a line easier and cleaner in version control.

## Padding

A struct's size is usually more than the sum of its members, because the compiler adds padding so that each member starts at an address its type requires. You do not need to control padding yet. What matters now is that `sizeof` gives you the true size, and that you should never assume a struct's layout byte for byte.

## Recap

- A struct groups related values into one named type. Access members with `.`.
- Assigning a struct copies all of its members.
- With a pointer to a struct, use `->` to reach a member.
- Designated initializers name the members, and unnamed members become zero.
- Structs fit naturally into arrays, and `sizeof` gives the true size, including padding.

**Up next:** enums, typedef and unions, which round out the tools for modelling data.
