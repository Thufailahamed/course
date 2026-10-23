Your classes from the last lesson work, but they still feel like second-class citizens. Print one and you get `<__main__.Book object at 0x7f3a...>`. Compare two identical ones with `==` and Python says `False`. Try to `sorted()` a list of them and you get an error. Built-in types like `str` and `list` do all of this effortlessly. What do they know that your classes don't?

The answer is **special methods**: hooks with double-underscore names that let your objects plug into Python's own syntax: `print`, `==`, `<`, `len()`. In this lesson you'll add those hooks, use **properties** to compute values and reject bad data, build new classes on top of existing ones with **inheritance**, and finish with `@dataclass`, the shortcut professionals use to skip the boilerplate entirely.

## Special methods: Python's hooks

You already met one special method: `__init__`, which Python calls for you when an object is built. There are dozens more, and they all follow the same idea. When you write ordinary Python syntax, Python quietly translates it into a method call:

```python run
word = "banana"
print(len(word), word.__len__())             # len(x)  →  x.__len__()
print(3 + 4, (3).__add__(4))                 # a + b   →  a.__add__(b)
print(word == "banana", word.__eq__("banana"))  # a == b  →  a.__eq__(b)
```

That's the whole trick. `len()` works on strings because `str` defines `__len__`. If *your* class defines `__len__`, `len()` will work on your objects too. Python programmers call these **dunder methods** (for **d**ouble **under**score).

> **Tip:** You define dunder methods, but you almost never call them directly. Write `len(playlist)`, not `playlist.__len__()`. Python does the translating.

Here's what a plain class gives you before you add any hooks:

```python run
class Book:
    def __init__(self, title, author, pages):
        self.title = title
        self.author = author
        self.pages = pages

book = Book("Dune", "Frank Herbert", 412)
print(book)
print(book == Book("Dune", "Frank Herbert", 412))
```

The default printout shows the class name and a memory address (yours will differ from anyone else's). Correct, and almost useless. And `==` says `False` because, without instructions, Python only considers an object equal to *itself*. Let's fix both.

## `__str__` and `__repr__`: how your object looks

Python has two ways of turning an object into text, for two different audiences:

| | `__str__` | `__repr__` |
|---|---|---|
| Audience | the **user** of your program | the **developer** (you!) |
| Goal | friendly and readable | unambiguous, ideally looks like code that rebuilds the object |
| Used by | `print(obj)`, `str(obj)`, f-strings | the value display at the end of a cell, the debugger, objects **inside lists and dicts**, `repr(obj)` |
| Example | `Dune by Frank Herbert` | `Book('Dune', 'Frank Herbert', 412)` |

Both must **return** a string.

```python run
class Book:
    def __init__(self, title, author, pages):
        self.title = title
        self.author = author
        self.pages = pages

    def __str__(self):
        return f"{self.title} by {self.author}"

    def __repr__(self):
        return f"Book({self.title!r}, {self.author!r}, {self.pages})"

book = Book("Dune", "Frank Herbert", 412)
print(book)
print(f"Now reading: {book}")
print([book, Book("Emma", "Jane Austen", 474)])
book
```

Inside an f-string, `!r` inserts the *repr* of a value, so strings come out with their quotes: `'Dune'` instead of `Dune`. That's what makes the repr look like real code.

Notice the list: a list prints its items using their `__repr__`, not their `__str__`. If you only write one of the two, write `__repr__`: Python falls back to it when `__str__` is missing, but not the other way around.

```python predict id=predict-str-repr-list title="str or repr?"
class Card:
    def __init__(self, rank, suit):
        self.rank = rank
        self.suit = suit

    def __str__(self):
        return f"{self.rank} of {self.suit}"

    def __repr__(self):
        return f"Card({self.rank!r}, {self.suit!r})"

card = Card("A", "spades")
print(card, [card])
--- options
A of spades [A of spades]
* A of spades [Card('A', 'spades')]
Card('A', 'spades') [Card('A', 'spades')]
A of spades ['A of spades']
--- explain
`print(card)` uses `__str__`, giving the friendly `A of spades`. But a list always shows its contents with `__repr__`, so the card inside `[card]` appears as `Card('A', 'spades')`. That's deliberate: inside a container, an unambiguous view matters more than a pretty one.
```

```python exercise id=product-str-repr title="Make products print nicely"
class Product:
    def __init__(self, name, price):
        self.name = name
        self.price = price

    def __str__(self):
        # TODO: return a friendly string like 'Coffee beans: $12.50'
        # (always two decimal places)
        return "..."

    def __repr__(self):
        # TODO: return a developer string like "Product('Coffee beans', 12.5)"
        return "..."

item = Product("Coffee beans", 12.5)
print(item)
print([item])
--- solution
class Product:
    def __init__(self, name, price):
        self.name = name
        self.price = price

    def __str__(self):
        return f"{self.name}: ${self.price:.2f}"

    def __repr__(self):
        return f"Product({self.name!r}, {self.price!r})"

item = Product("Coffee beans", 12.5)
print(item)
print([item])
--- test
p = Product("Green tea", 4.5)
s, r = p.__str__(), p.__repr__()
assert s != "...", "Replace the `\"...\"` in `__str__` with an f-string built from `self.name` and `self.price`."
assert r != "...", "Replace the `\"...\"` in `__repr__` with an f-string that looks like `Product('Green tea', 4.5)`."
assert isinstance(s, str) and isinstance(r, str), "Both methods must **return** a string."
assert s == "Green tea: $4.50", f"str(Product('Green tea', 4.5)) should be 'Green tea: $4.50', but is {s!r}."
assert str(Product("Bagel", 3)) == "Bagel: $3.00", f"The price should always show two decimals: expected 'Bagel: $3.00', got {str(Product('Bagel', 3))!r}."
assert r == "Product('Green tea', 4.5)", f"repr(Product('Green tea', 4.5)) should be \"Product('Green tea', 4.5)\", but is {r!r}. Did you use !r for the name so it gets quotes?"
assert repr(Product("Oat milk", 2.99)) == "Product('Oat milk', 2.99)", f"repr should work for any product, but got {repr(Product('Oat milk', 2.99))!r}."
assert "Coffee beans: $12.50" in _stdout, "Keep the `print(item)` line."
--- hint
Both methods must `return` an f-string. For the price, the format spec `:.2f` from lesson 6 gives exactly two decimals.
--- hint
In `__repr__`, `{self.name!r}` puts quotes around the name automatically. The price can go in as is.
```

Here's the classic `__str__` mistake. The symptom is an error that sounds confusing until you know the rule:

```python debug id=ticket-str-prints title="Printing a ticket crashes"
class Ticket:
    def __init__(self, event, seat, price):
        self.event = event
        self.seat = seat
        self.price = price

    def __str__(self):
        print(f"{self.event} | seat {self.seat} | ${self.price:.2f}")

ticket = Ticket("Jazz Night", "B12", 45)
print(ticket)
--- solution
class Ticket:
    def __init__(self, event, seat, price):
        self.event = event
        self.seat = seat
        self.price = price

    def __str__(self):
        return f"{self.event} | seat {self.seat} | ${self.price:.2f}"

ticket = Ticket("Jazz Night", "B12", 45)
print(ticket)
--- test
assert str(ticket) == "Jazz Night | seat B12 | $45.00", f"str(ticket) should be 'Jazz Night | seat B12 | $45.00', but is {str(ticket)!r}."
other = Ticket("Comedy Club", "A1", 19.5)
assert str(other) == "Comedy Club | seat A1 | $19.50", f"A different ticket should print as 'Comedy Club | seat A1 | $19.50', but got {str(other)!r}."
assert _stdout.count("Jazz Night") == 1, "The ticket text should be printed exactly once, by `print(ticket)`. `__str__` itself shouldn't print anything."
--- hint
Run it. The ticket text does appear, and *then* Python complains: `__str__ returned non-string (type NoneType)`. What does a function give back when it never says `return`?
--- hint
`print(ticket)` asks `__str__` for a string and prints it itself. `__str__` should hand the string back, not print it.
```

## `__eq__`, `__lt__` and `__len__`: comparing and measuring

By default, `a == b` on your objects means "are these the very same object?", the same as `a is b`. Usually that's not what you want: two `Point(1, 2)` objects should count as equal. Define `__eq__` to say what "equal" means for your type:

```python run
class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __eq__(self, other):
        if not isinstance(other, Point):
            return False
        return self.x == other.x and self.y == other.y

    def __repr__(self):
        return f"Point({self.x}, {self.y})"

a = Point(1, 2)
b = Point(1, 2)
print("a == b:", a == b, "  a is b:", a is b)
print("a == 'hello':", a == "hello")
print("in the list?", Point(1, 2) in [Point(0, 0), b])
```

`in` uses `==` behind the scenes, so once `__eq__` exists, membership checks work too. The `isinstance` guard from lesson 22 keeps comparisons with other types from crashing on a missing `.x`.

> **Under the hood:** Experienced Python developers often write `return NotImplemented` instead of `return False` in that guard. It tells Python "I don't know how to compare with this; ask the other object". For your own code at this stage, `False` is perfectly fine.

```python predict id=predict-default-eq title="Same coin?"
class Coin:
    def __init__(self, value):
        self.value = value

a = Coin(25)
b = Coin(25)
print(a == b, a.value == b.value)
--- options
True True
* False True
False False
True False
--- explain
`Coin` has no `__eq__`, so `a == b` falls back to identity: are `a` and `b` the **same object**? They're two separate objects built by two separate calls, so the answer is `False`, even though their data matches. Comparing the attributes directly compares two ints, which are equal. Defining `__eq__` would make `a == b` mean what you expect.
```

`__len__` lets `len()` work on your object, and `__lt__` ("less than") defines `<`. Once `<` works, `sorted()`, `min()` and `max()` work too, because they only need to ask "is this one smaller than that one?":

```python run
class Playlist:
    def __init__(self, name, songs):
        self.name = name
        self.songs = list(songs)

    def __len__(self):
        return len(self.songs)

    def __lt__(self, other):
        return len(self) < len(other)

    def __repr__(self):
        return f"Playlist({self.name!r}, {len(self)} songs)"

gym = Playlist("Gym", ["Stronger", "Lose Yourself", "Eye of the Tiger"])
chill = Playlist("Chill", ["Weightless"])
party = Playlist("Party", ["Uptown Funk", "Shut Up and Dance"])

print("len(gym):", len(gym), "  chill < gym:", chill < gym)
sorted([gym, chill, party])
```

| You write | Python calls | Define it to… |
|---|---|---|
| `Thing(...)` | `__init__` | set up a new object's attributes |
| `print(x)`, `str(x)`, `f"{x}"` | `__str__` | give users a friendly description |
| `repr(x)`, `[x]`, the debugger | `__repr__` | give developers an exact description |
| `x == y` | `__eq__` | decide when two objects count as equal |
| `x < y`, `sorted(...)` | `__lt__` | define a natural order |
| `len(x)` | `__len__` | report a size |

There are many more (`__add__` for `+`, `__contains__` for `in`, `__getitem__` for `x[i]`), all working the same way. You now know the pattern for every one of them.

```python exercise id=sortable-runners title="Sort the race results"
class Runner:
    def __init__(self, name, minutes):
        self.name = name
        self.minutes = minutes

    def __repr__(self):
        return f"Runner({self.name!r}, {self.minutes})"

    def __lt__(self, other):
        """A runner is 'less than' another if they finished faster."""
        # TODO: return True or False by comparing the two runners' minutes
        ...

    def __eq__(self, other):
        """Two runners are equal if they have the same name AND the same time."""
        # TODO
        ...

results = [Runner("Kim", 42.5), Runner("Ola", 39.8), Runner("Sam", 45.1), Runner("Ida", 40.2)]

# TODO: the 3 fastest runners, fastest first. Use sorted() on `results`.
podium = ...
print(podium)
--- solution
class Runner:
    def __init__(self, name, minutes):
        self.name = name
        self.minutes = minutes

    def __repr__(self):
        return f"Runner({self.name!r}, {self.minutes})"

    def __lt__(self, other):
        """A runner is 'less than' another if they finished faster."""
        return self.minutes < other.minutes

    def __eq__(self, other):
        """Two runners are equal if they have the same name AND the same time."""
        return self.name == other.name and self.minutes == other.minutes

results = [Runner("Kim", 42.5), Runner("Ola", 39.8), Runner("Sam", 45.1), Runner("Ida", 40.2)]

podium = sorted(results)[:3]
print(podium)
--- test
fast, slow = Runner("Fast", 30.0), Runner("Slow", 35.0)
lt = fast.__lt__(slow)
assert lt is not None and lt is not ..., "Replace the `...` in `__lt__`: it should return True when `self` finished faster than `other`."
assert (fast < slow) is True and (slow < fast) is False, f"`Runner('Fast', 30.0) < Runner('Slow', 35.0)` should be True and the reverse False, but got {fast < slow!r} and {slow < fast!r}."
eq = Runner("Kim", 42.5).__eq__(Runner("Kim", 42.5))
assert eq is not None and eq is not ..., "Replace the `...` in `__eq__`: it should return True or False."
assert Runner("Kim", 42.5) == Runner("Kim", 42.5), "Two runners with the same name and time should be equal."
assert Runner("Kim", 42.5) != Runner("Ola", 42.5), "Runners with different names should not be equal, even with the same time."
assert Runner("Kim", 42.5) != Runner("Kim", 50.0), "The same runner with a different time should not be equal."
assert podium is not ..., "Replace the `...` after `podium =` using `sorted(results)`."
assert isinstance(podium, list), f"`podium` should be a list, not {type(podium).__name__}."
names = [r.name for r in podium]
assert names == ["Ola", "Ida", "Kim"], f"The podium should be Ola, Ida, Kim (fastest first), but is {names}."
fresh = sorted([Runner("a", 5), Runner("b", 3), Runner("c", 4)])
assert [r.name for r in fresh] == ["b", "c", "a"], "sorted() should order any list of runners by time once `__lt__` works."
--- hint
`__lt__` gets two runners: `self` and `other`. Return the result of comparing their `minutes` with `<`.
--- hint
`__eq__` should return a combined comparison: the names match **and** the minutes match.
--- hint
With `__lt__` in place, `sorted(results)` puts the fastest first. A slice `[:3]` keeps the top three.
```

## Properties: attributes that compute or protect

Sometimes a value should be *calculated* from other attributes, not stored. A rectangle's area depends on its width and height; if you stored it separately, it would go stale the moment the width changed. A **property** is a method that you read like an attribute, without parentheses:

```python run
class Rectangle:
    def __init__(self, width, height):
        self.width = width
        self.height = height

    @property
    def area(self):
        return self.width * self.height

room = Rectangle(4, 3)
print("area:", room.area)          # no parentheses!
room.width = 5
print("after widening:", room.area)
```

The `@property` line above the method is a **decorator**: a label that changes how the function below it behaves. Here it turns `area` from "a method you call" into "an attribute you read", which is computed fresh each time. (You'll learn to write your own decorators in Python Advanced.)

Because `area` is now a value, not a method, adding parentheses is a mistake. Python first computes `room.area` (getting `20`), then tries to call `20()`:

```python run error
room.area()
```

"`'int' object is not callable`" is Python's way of saying "you put `()` after something that isn't a function". With properties, drop the parentheses.

Properties have a second superpower: **validation**. You can attach a *setter* that runs every time someone assigns to the attribute, and reject bad values before they ever get stored:

```python run
class BankAccount:
    def __init__(self, owner, balance=0):
        self.owner = owner
        self.balance = balance          # this assignment goes through the setter below

    @property
    def balance(self):
        return self._balance

    @balance.setter
    def balance(self, value):
        if value < 0:
            raise ValueError(f"balance can't be negative (got {value})")
        self._balance = value

acct = BankAccount("Maya", 100)
acct.balance = 80
print("balance:", acct.balance)
try:
    acct.balance = -500
except ValueError as e:
    print("Rejected:", e)
print("still:", acct.balance)
```

The real number lives in `self._balance`. The leading underscore is a Python convention meaning "internal: don't touch this directly from outside the class". Everyone else goes through `acct.balance`, so every read and every write passes through your code. Even `__init__` uses the setter, so you can't *create* an account with a negative balance either.

> **Coming from another language:** Java and C# programmers often write `getBalance()`/`setBalance()` for every field. In Python you start with plain attributes, and only turn one into a property when you need computation or validation. Code that uses `acct.balance` doesn't have to change at all.

```python exercise id=temperature-property title="A thermometer that knows physics"
class Temperature:
    def __init__(self, celsius):
        self.celsius = celsius            # goes through the setter below

    @property
    def celsius(self):
        return self._celsius

    @celsius.setter
    def celsius(self, value):
        # TODO: raise a ValueError if value is below -273.15 (absolute zero).
        # Otherwise, store it in self._celsius.
        ...

    @property
    def fahrenheit(self):
        """The same temperature in Fahrenheit: C * 9 / 5 + 32."""
        # TODO
        ...

today = Temperature(21)
print(today.fahrenheit)       # should print 69.8
--- solution
class Temperature:
    def __init__(self, celsius):
        self.celsius = celsius

    @property
    def celsius(self):
        return self._celsius

    @celsius.setter
    def celsius(self, value):
        if value < -273.15:
            raise ValueError(f"{value} is below absolute zero")
        self._celsius = value

    @property
    def fahrenheit(self):
        """The same temperature in Fahrenheit: C * 9 / 5 + 32."""
        return self.celsius * 9 / 5 + 32

today = Temperature(21)
print(today.fahrenheit)
--- test
t = Temperature(100)
assert hasattr(t, "_celsius"), "Replace the `...` in the `celsius` setter: store the value with `self._celsius = value`."
assert t.celsius == 100, f"Temperature(100).celsius should be 100, but is {t.celsius!r}."
f = t.fahrenheit
assert f is not None and f is not ..., "Replace the `...` in `fahrenheit`: it should **return** the converted temperature."
assert isinstance(f, (int, float)), f"`fahrenheit` should be a number you read without parentheses (keep `@property`), but it is {type(f).__name__}."
assert abs(f - 212) < 1e-9, f"100 °C should be 212 °F, but `fahrenheit` gave {f!r}."
assert abs(Temperature(-40).fahrenheit - (-40)) < 1e-9, "-40 °C should be -40 °F."
t.celsius = 37
assert abs(t.fahrenheit - 98.6) < 1e-9, f"After setting celsius to 37, fahrenheit should be 98.6, but is {t.fahrenheit!r}. Compute it from `self.celsius` each time."
Temperature(-273.15)
try:
    Temperature(-300)
    raised = False
except ValueError:
    raised = True
assert raised, "Temperature(-300) should raise a ValueError: nothing is colder than -273.15 °C."
try:
    t.celsius = -500
except ValueError:
    pass
else:
    assert False, "Setting `t.celsius = -500` should raise a ValueError too (the setter runs on every assignment)."
assert t.celsius == 37, f"A rejected value must not be stored: celsius should still be 37, but is {t.celsius!r}."
--- hint
In the setter, check the value first with an `if`. If it's too cold, `raise ValueError("...")`; only after that check, store it.
--- hint
`fahrenheit` is computed fresh every time it's read, from `self.celsius`. Don't store it anywhere.
--- hint
The formula is `self.celsius * 9 / 5 + 32`. Make sure the method `return`s it.
```

## Inheritance: building on an existing class

A savings account *is* an account: it has an owner and a balance, it takes deposits. It just adds interest on top. Rather than copy all of `Account`'s code, you can say "a `SavingsAccount` is a kind of `Account`" and only write what's new. That's **inheritance**:

```python run
class Account:
    def __init__(self, owner, balance=0):
        self.owner = owner
        self.balance = balance

    def deposit(self, amount):
        self.balance += amount

    def withdraw(self, amount):
        self.balance -= amount

    def __str__(self):
        return f"{self.owner}: ${self.balance:,.2f}"

class SavingsAccount(Account):                     # "is a kind of Account"
    def __init__(self, owner, balance=0, rate=0.02):
        super().__init__(owner, balance)           # let Account set up owner and balance
        self.rate = rate                           # then add what's new

    def add_interest(self):
        self.deposit(self.balance * self.rate)

nest_egg = SavingsAccount("Maya", 1000, rate=0.05)
nest_egg.deposit(200)          # inherited from Account
nest_egg.add_interest()        # SavingsAccount's own method
print(nest_egg)                # Account's __str__
print(isinstance(nest_egg, SavingsAccount), isinstance(nest_egg, Account))
```

`Account` is the **parent** (or *base*) class and `SavingsAccount` is the **child** (or *subclass*). `super()` means "my parent class", so `super().__init__(owner, balance)` runs `Account`'s setup on this new object before the child adds its own `rate`. And because a savings account *is* an account, `isinstance` says `True` for both.

When you call a method, Python searches upward until it finds it:

```text
nest_egg.deposit(200)
   1. nest_egg's own attributes      {owner, balance, rate}           → no
   2. class SavingsAccount           {__init__, add_interest}         → no
   3. class Account (the parent)     {__init__, deposit, withdraw...} → found it!
```

A child can also **override** a parent's method by defining one with the same name. Python finds the child's version first. Inside it, `super().method(...)` still reaches the parent's version, so you can extend behaviour instead of rewriting it:

```python run
class CheckingAccount(Account):
    fee = 1.50                                     # class attribute

    def withdraw(self, amount):                    # overrides Account.withdraw
        super().withdraw(amount + self.fee)        # reuse the parent, add the fee

spending = CheckingAccount("Leo", 100)
spending.withdraw(20)
print(spending)
```

```python predict id=predict-inheritance-chain title="Which speak() runs?"
class Animal:
    def speak(self):
        return "..."

class Dog(Animal):
    def speak(self):
        return "Woof"

class Puppy(Dog):
    pass

p = Puppy()
print(p.speak(), isinstance(p, Animal))
--- options
... True
* Woof True
Woof False
... False
--- explain
`Puppy` defines nothing, so Python searches upward: `Puppy` → `Dog`, where it finds `speak` and returns `"Woof"`. The search stops at the first match, so `Animal`'s version never runs. And a `Puppy` is a `Dog`, which is an `Animal`, so `isinstance(p, Animal)` is `True`.
```

```python debug id=savings-no-balance title="The savings account has no balance"
class Account:
    def __init__(self, owner, balance=0):
        self.owner = owner
        self.balance = balance

    def deposit(self, amount):
        self.balance += amount

class SavingsAccount(Account):
    def __init__(self, owner, balance=0, rate=0.02):
        self.rate = rate

    def add_interest(self):
        self.balance += self.balance * self.rate

college_fund = SavingsAccount("Priya", 2000, rate=0.05)
college_fund.add_interest()
print(college_fund.owner, college_fund.balance)    # should be Priya 2100.0
--- solution
class Account:
    def __init__(self, owner, balance=0):
        self.owner = owner
        self.balance = balance

    def deposit(self, amount):
        self.balance += amount

class SavingsAccount(Account):
    def __init__(self, owner, balance=0, rate=0.02):
        super().__init__(owner, balance)
        self.rate = rate

    def add_interest(self):
        self.balance += self.balance * self.rate

college_fund = SavingsAccount("Priya", 2000, rate=0.05)
college_fund.add_interest()
print(college_fund.owner, college_fund.balance)
--- test
assert college_fund.owner == "Priya", f"`college_fund.owner` should be 'Priya', but is {college_fund.owner!r}."
assert abs(college_fund.balance - 2100) < 1e-9, f"After 5% interest on 2000, the balance should be 2100.0, but is {college_fund.balance!r}."
assert college_fund.rate == 0.05, "Keep storing the interest rate in `self.rate`."
s = SavingsAccount("Tom", 100)
assert s.balance == 100 and s.rate == 0.02, "A new SavingsAccount('Tom', 100) should have balance 100 and the default rate 0.02."
s.deposit(50)
assert s.balance == 150, "The inherited `deposit` method should still work."
assert isinstance(s, Account), "SavingsAccount should still inherit from Account."
--- hint
Run it and read the last line of the error: the object has no `balance`. Which `__init__` is supposed to create `owner` and `balance`? Did it ever run?
--- hint
When a child defines its own `__init__`, the parent's `__init__` no longer runs automatically. Call it yourself, first thing, with `super()`.
```

```python exercise id=manager-pay title="Managers get a bonus"
class Employee:
    def __init__(self, name, salary):
        self.name = name
        self.salary = salary

    def pay(self):
        """Monthly pay: yearly salary / 12, rounded to cents."""
        return round(self.salary / 12, 2)

class Manager(Employee):
    def __init__(self, name, salary, bonus):
        # TODO: let Employee set up name and salary, then store the bonus
        ...

    def pay(self):
        """A manager's monthly pay is an employee's monthly pay plus the bonus."""
        # TODO: reuse Employee's pay() via super(), then add self.bonus
        ...

staff = [Employee("Ana", 48000), Manager("Raj", 72000, 500)]
for person in staff:
    print(person.pay())          # should print 4000.0 then 6500.0
--- solution
class Employee:
    def __init__(self, name, salary):
        self.name = name
        self.salary = salary

    def pay(self):
        """Monthly pay: yearly salary / 12, rounded to cents."""
        return round(self.salary / 12, 2)

class Manager(Employee):
    def __init__(self, name, salary, bonus):
        super().__init__(name, salary)
        self.bonus = bonus

    def pay(self):
        """A manager's monthly pay is an employee's monthly pay plus the bonus."""
        return super().pay() + self.bonus

staff = [Employee("Ana", 48000), Manager("Raj", 72000, 500)]
for person in staff:
    print(person.pay())
--- test
m = Manager("Zoe", 60000, 300)
assert hasattr(m, "name") and hasattr(m, "salary"), "Replace the `...` in `Manager.__init__`: call `super().__init__(...)` so the manager gets a `name` and `salary`."
assert hasattr(m, "bonus"), "Each Manager also needs a `bonus` attribute."
assert (m.name, m.salary, m.bonus) == ("Zoe", 60000, 300), f"Expected name='Zoe', salary=60000, bonus=300, but got {m.name!r}, {m.salary!r}, {m.bonus!r}."
p = m.pay()
assert p is not None and p is not ..., "`Manager.pay()` should **return** the monthly pay plus the bonus."
assert abs(p - 5300) < 1e-9, f"Manager('Zoe', 60000, 300).pay() should be 5300.0 (5000 + 300), but is {p!r}."
assert isinstance(m, Employee), "Manager should still inherit from Employee."
original_pay = Employee.pay
Employee.pay = lambda self: 1000
try:
    reused = Manager("Lee", 12000, 50).pay()
finally:
    Employee.pay = original_pay
assert reused == 1050, "`Manager.pay()` should build on Employee's version with `super().pay()` instead of repeating the salary formula."
--- hint
In `__init__`, the first line should hand `name` and `salary` to the parent: `super().__init__(name, salary)`. Then store the bonus on `self`.
--- hint
In `pay`, `super().pay()` gives you the normal employee pay. Add the bonus and `return` the result.
```

## Composition: "has a" instead of "is a"

Inheritance is powerful, but beginners tend to overuse it. Before writing `class B(A)`, say the sentence out loud: **"a B *is an* A"**. A savings account *is an* account: inheritance fits. A playlist *is a* song? No. A playlist **has** songs. When the relationship is "has a", store the other objects as attributes instead. That's **composition**:

```python run
class Song:
    def __init__(self, title, seconds):
        self.title = title
        self.seconds = seconds

class Playlist:
    def __init__(self, name):
        self.name = name
        self.songs = []                     # a Playlist HAS Songs

    def add(self, song):
        self.songs.append(song)

    def total_minutes(self):
        return round(sum(song.seconds for song in self.songs) / 60, 1)

road_trip = Playlist("Road trip")
road_trip.add(Song("Africa", 295))
road_trip.add(Song("Mr. Blue Sky", 303))
print(road_trip.name, "lasts", road_trip.total_minutes(), "minutes")
```

| Relationship | Sentence | Tool | Examples |
|---|---|---|---|
| **is a** | "a savings account *is an* account" | inheritance: `class SavingsAccount(Account)` | `Dog(Animal)`, `Manager(Employee)` |
| **has a** | "a playlist *has* songs" | composition: an attribute holding other objects | `Playlist` has `Song`s, `Car` has an `Engine`, `Order` has `Product`s |

> **Tip:** When in doubt, prefer composition. It keeps classes small and independent, and you can swap parts easily. Deep inheritance chains (`A` → `B` → `C` → `D`) are hard to follow because behaviour is spread across many classes.

## `@dataclass`: the professional shortcut

Look back at all the classes in this lesson. Most `__init__` methods just copy parameters onto `self`, and `__repr__` and `__eq__` are pure routine. Python's `dataclasses` module writes all of that for you:

```python run
from dataclasses import dataclass, field

@dataclass
class Book:
    title: str
    author: str
    pages: int = 0

@dataclass
class Order:
    customer: str
    items: list = field(default_factory=list)    # a NEW list for every order

a = Book("Dune", "Frank Herbert", 412)
print(a)
print("equal?", a == Book("Dune", "Frank Herbert", 412))

ana, ben = Order("Ana"), Order("Ben")
ana.items.append("tea")
print(ana, ben)
```

Each line like `title: str` declares a field. The `: str` part is a **type annotation**, a label saying what kind of value belongs there. Python doesn't enforce it, but it documents your intent and editors use it to catch mistakes. From those lines, `@dataclass` generates `__init__`, a readable `__repr__` and a field-by-field `__eq__`. You can still add your own methods and properties as usual.

Notice `field(default_factory=list)`. A dataclass won't let you write `items: list = []`, precisely to protect you from the shared-list trap from the last lesson. `default_factory=list` means "call `list()` to make a fresh empty list for each new object". (Add `@dataclass(order=True)` and it generates `<` too, comparing fields in order.)

> **In the wild:** Dataclasses are everywhere in modern Python: configuration objects, API responses, game state, rows of a report. Libraries like Pydantic (used by FastAPI) and SQLAlchemy build on the very same `name: type` style. And you'll use one yourself in the budget tracker project.

## Recap

- **Special methods** (dunders) hook your objects into Python syntax: `__str__` for `print`, `__repr__` for developers and containers, `__eq__` for `==`, `__lt__` for `<` and `sorted()`, `__len__` for `len()`. `__str__` and `__repr__` must **return** a string.
- Without `__eq__`, `==` only checks whether two names point at the very same object.
- `@property` turns a method into a computed attribute (read without parentheses); a `.setter` validates every assignment, storing the real value in an `_underscore` attribute.
- **Inheritance** (`class Child(Parent)`) reuses a parent's code; call `super().__init__(...)` in the child's `__init__`, and override methods to change behaviour, using `super().method()` to build on the original.
- Use inheritance for "is a" and **composition** (objects as attributes) for "has a". When unsure, prefer composition.
- `@dataclass` writes `__init__`, `__repr__` and `__eq__` for you; use `field(default_factory=list)` for list fields.

**Up next:** your first capstone project, a gradebook analyzer that reads student scores from a CSV file, calculates averages and letter grades, and writes a polished report.
