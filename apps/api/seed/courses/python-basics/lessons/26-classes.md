So far you've described the world with Python's built-in types: a string for a name, a float for a price, a list for a playlist, a dict for a customer record. That takes you a long way, but real programs are full of *things*: bank accounts, pets, playlists, game characters, orders. Each one has some data (a balance, a name, a list of songs) **and** some actions that belong with that data (deposit, rename, add a song).

A **class** lets you invent your own type that bundles the two together. By the end of this lesson you'll be able to write a `BankAccount` that knows how to take deposits, a `Playlist` that keeps track of its own songs, and a game `Character` that can take damage and heal, and you'll understand the one word that confuses every beginner at first: `self`.

## You've been using objects all along

Every value in Python is an **object**: a bundle of data plus the actions it knows how to do. You've called those actions **methods** since lesson 6. Look at what `type()` says about a few familiar values:

```python run
city = "lisbon"
print(type(city))
print(city.title())          # a method: an action this string knows

scores = [72, 90]
scores.append(85)            # a method that changes this list
print(type(scores), scores)
```

Notice the word **class** in `<class 'str'>` and `<class 'list'>`. `str` and `list` are classes that come with Python. `"lisbon"` is one particular string object made from the `str` class; `scores` is one particular list made from the `list` class. Today you'll write classes of your own, and they'll work exactly the same way.

## A class is a blueprint, an instance is a house

The best mental model is an architect's blueprint. The blueprint describes what every house will have (rooms, a front door, a mailbox) but you can't live in a blueprint. You use it to build actual houses, and each house has its own furniture, its own paint colour, its own address.

```text
            class Pet                       ← the blueprint (written once)
   "every pet has a name, a species, an age"
                 │
       ┌─────────┴──────────┐
       ▼                    ▼
   ┌──────────────┐    ┌──────────────┐
   │ name: "Rex"  │    │ name: "Luna" │  ← instances (objects) built from it,
   │ species: dog │    │ species: cat │    each with its own data
   │ age: 3       │    │ age: 5       │
   └──────────────┘    └──────────────┘
```

| Word | Meaning | Everyday version |
|---|---|---|
| **class** | the blueprint that describes a kind of thing | the house plans |
| **instance** / **object** | one actual thing built from the class | one particular house |
| **attribute** | a piece of data stored on an object | the colour of *that* house's door |
| **method** | a function defined inside a class | something a house can do: "ring doorbell" |

Here is the smallest possible class. `class Pet:` starts the blueprint, and `pass` means "nothing else yet". Calling the class like a function, `Pet()`, builds a new instance:

```python run
class Pet:
    pass

rex = Pet()
luna = Pet()

rex.name = "Rex"        # attach an attribute to this one object
luna.name = "Luna"

print(type(rex))
print(rex.name, "and", luna.name)
print("same object?", rex is luna)
```

`<class '__main__.Pet'>` reads as "the `Pet` class defined in this program" (`__main__` is Python's name for the program you're running). Class names use **CapitalizedWords** (`Pet`, `BankAccount`), unlike the snake_case you use for variables and functions, so you can spot a class at a glance.

Attaching attributes from outside like this works, but it's fragile: forget one line and that pet simply has no `name`. A good blueprint should guarantee that every object is built complete.

## `__init__`: setting up each new object

A class can define a special method called `__init__` (two underscores on each side, said "dunder init"). Python runs it **automatically** every time you build a new instance. Its job is to fill in the new object's attributes.

```python run
class Pet:
    def __init__(self, name, species, age):
        print(f"  (__init__ is setting up {name})")
        self.name = name
        self.species = species
        self.age = age

rex = Pet("Rex", "dog", 3)
luna = Pet("Luna", "cat", 5)

print(rex.name, "is a", rex.species)
print(luna.name, "is", luna.age, "years old")
```

Here's what happens when Python reads `rex = Pet("Rex", "dog", 3)`:

```text
1. Python builds a brand-new, empty Pet object.
2. It calls  __init__(that_new_object, "Rex", "dog", 3)
                      ▲
                      └── this is what `self` receives
3. Inside __init__, self.name = name stores "Rex" ON the new object.
4. The finished object comes back and gets the name tag `rex`.
```

You pass three arguments, but `__init__` has four parameters. The extra first one, `self`, is filled in by Python: it's the object being built.

> **Tip:** `self.name = name` looks repetitive, but the two names are different things. The right-hand `name` is the parameter, a temporary local variable that disappears when `__init__` ends. The left-hand `self.name` is an **attribute** stored on the object, and it lives as long as the object does.

## `self` means "this particular object"

Methods are functions written inside the class. Every method's first parameter is `self`, and inside the method `self` means *whichever object the method was called on*. When you write `rex.describe()`, `self` is `rex`. When you write `luna.describe()`, `self` is `luna`. One blueprint, many objects, and `self` is how the shared code knows which one it's working on.

```python run
class Pet:
    def __init__(self, name, species, age):
        self.name = name
        self.species = species
        self.age = age

    def describe(self):
        return f"{self.name} the {self.species}, age {self.age}"

rex = Pet("Rex", "dog", 3)
luna = Pet("Luna", "cat", 5)

print(rex.describe())
print(luna.describe())
print(Pet.describe(rex))   # what rex.describe() really does behind the scenes
```

That last line is the secret. `rex.describe()` is shorthand for `Pet.describe(rex)`: Python looks up `describe` on the class and passes `rex` in as the first argument. That's all `self` is: an ordinary parameter that Python fills in for you.

> **Coming from another language:** In Java, C# or JavaScript the equivalent is `this`, and it's implicit. Python makes it explicit: you always write `self` in the method's parameter list and always write `self.` to reach an attribute. The name `self` is only a convention, but every Python programmer uses it, so you should too.

Forget `self` in a method definition and you get one of the most baffling-looking errors in Python. Run it:

```python run error
class Pet:
    def __init__(self, name):
        self.name = name

    def speak():                 # forgot self!
        return "..."

rex = Pet("Rex")
rex.speak()
```

"takes 0 positional arguments but 1 was given", yet you didn't pass any arguments! You did, invisibly: `rex.speak()` is really `Pet.speak(rex)`, so Python passed `rex` and the method had no parameter to receive it. Whenever you see a "but 1 was given" error on a method call, check for a missing `self`.

```python predict id=predict-self-greet title="Who is self?"
class Greeter:
    def __init__(self, name):
        self.name = name

    def greet(self, other):
        return f"Hi {other}, I'm {self.name}"

ana = Greeter("Ana")
ben = Greeter("Ben")
print(ben.greet("Ana"))
--- options
* Hi Ana, I'm Ben
Hi Ben, I'm Ana
Hi Ana, I'm Ana
Hi other, I'm self.name
--- explain
The method was called **on `ben`**, so inside `greet`, `self` is `ben` and `self.name` is `"Ben"`. The argument `"Ana"` lands in the `other` parameter. Read `ben.greet("Ana")` as `Greeter.greet(ben, "Ana")` and it's clear which value goes where.
```

```python exercise id=song-class title="A song that knows its length"
class Song:
    """One song on a playlist."""

    def __init__(self, title, artist, seconds):
        # TODO: store title, artist and seconds as attributes on self
        ...

    def duration(self):
        """Return the length as 'm:ss', e.g. 205 seconds -> '3:25'."""
        # TODO: use self.seconds to build the string
        ...

track = Song("Bohemian Rhapsody", "Queen", 354)
print(track.duration())    # should print 5:54
--- solution
class Song:
    """One song on a playlist."""

    def __init__(self, title, artist, seconds):
        self.title = title
        self.artist = artist
        self.seconds = seconds

    def duration(self):
        """Return the length as 'm:ss', e.g. 205 seconds -> '3:25'."""
        minutes = self.seconds // 60
        secs = self.seconds % 60
        return f"{minutes}:{secs:02}"

track = Song("Bohemian Rhapsody", "Queen", 354)
print(track.duration())
--- test
s = Song("Africa", "Toto", 295)
for attr in ("title", "artist", "seconds"):
    assert hasattr(s, attr), f"Replace the `...` in `__init__`: each Song needs a `{attr}` attribute, stored with `self.{attr} = ...`."
assert (s.title, s.artist, s.seconds) == ("Africa", "Toto", 295), f"The attributes should hold the values passed in, but got title={s.title!r}, artist={s.artist!r}, seconds={s.seconds!r}."
d = s.duration()
assert d is not None and d is not ..., "`duration()` should **return** the 'm:ss' string. Replace the `...` and make sure you `return` it."
assert isinstance(d, str), f"`duration()` should return a string like '4:55', not {type(d).__name__}."
assert d == "4:55", f"Song('Africa', 'Toto', 295).duration() should be '4:55', but is {d!r}."
assert Song("Intro", "x", 65).duration() == "1:05", f"65 seconds should be '1:05' (seconds always have two digits), but got {Song('Intro', 'x', 65).duration()!r}."
assert Song("Jingle", "x", 9).duration() == "0:09", f"9 seconds should be '0:09', but got {Song('Jingle', 'x', 9).duration()!r}."
assert Song("Epic", "x", 600).duration() == "10:00", f"600 seconds should be '10:00', but got {Song('Epic', 'x', 600).duration()!r}."
assert "5:54" in _stdout, "Keep the `print(track.duration())` line at the bottom."
--- hint
In `__init__`, each parameter needs to be saved on the object: `self.title = title`, and the same for the other two.
--- hint
Inside `duration`, reach the length with `self.seconds`. Floor division `//` by 60 gives whole minutes; `%` 60 gives the leftover seconds.
--- hint
To always show two digits for the seconds, use a format spec: `f"{secs:02}"` turns `5` into `05`.
```

## Methods that change the object

Methods can do more than read attributes: they can **update** them. This is where classes really shine. The data and the rules for changing it live in one place, so nobody can "forget" a rule.

```python run
class BankAccount:
    def __init__(self, owner, balance=0):
        self.owner = owner
        self.balance = balance

    def deposit(self, amount):
        self.balance += amount
        return self.balance

    def withdraw(self, amount):
        if amount > self.balance:
            raise ValueError(f"Insufficient funds: balance {self.balance}, tried {amount}")
        self.balance -= amount
        return self.balance

acct = BankAccount("Maya", 100)
acct.deposit(50)
acct.withdraw(30)
print(acct.owner, "has", acct.balance)
```

Two details are worth noticing. `__init__` takes a default value (`balance=0`) just like any function from lesson 20. And `withdraw` refuses bad requests by raising a `ValueError`, exactly as you learned in lesson 23. The account protects itself.

## Two objects, two separate sets of attributes

This is the heart of the whole idea. Each instance carries **its own** attributes. Changing one object's balance never touches another's, even though they were built from the same blueprint and share the same method code.

```python run
maya = BankAccount("Maya", 100)
leo = BankAccount("Leo")

maya.deposit(25)
leo.deposit(500)

print("Maya:", maya.balance, " Leo:", leo.balance)
print(vars(maya))     # vars() shows the attributes stored on one object
print(vars(leo))
```

`vars(obj)` reveals something lovely: under the hood, each object keeps its attributes in its own little dictionary. Here's the picture:

```text
  class BankAccount            (one copy of the methods, shared by everyone)
  ├─ __init__(self, owner, balance=0)
  ├─ deposit(self, amount)
  └─ withdraw(self, amount)
          ▲                              ▲
          │ "my class is"                │ "my class is"
  maya ──►┌────────────────────┐  leo ──►┌────────────────────┐
          │ owner:   "Maya"    │         │ owner:   "Leo"     │
          │ balance: 125       │         │ balance: 500       │
          └────────────────────┘         └────────────────────┘
        maya.deposit(25)  →  BankAccount.deposit(maya, 25)  →  only maya's box changes
```

The methods exist once, on the class. The data exists once **per object**. `self` is the bridge: it tells the shared method which box to read and write.

```python predict id=predict-two-counters title="Two counters"
class ClickCounter:
    def __init__(self):
        self.count = 0

    def click(self):
        self.count += 1

a = ClickCounter()
b = ClickCounter()
a.click()
a.click()
b.click()
print(a.count, b.count)
--- options
* 2 1
3 3
1 1
0 0
--- explain
`a` and `b` each got their own `count` attribute when `__init__` ran. `a.click()` updates `a.count` only, because inside the method `self` is `a`. Two clicks on `a`, one on `b`: `2 1`.
```

```python exercise id=playlist-class title="Build a Playlist class"
class Playlist:
    """A named list of song titles."""

    def __init__(self, name):
        # TODO: store the name, and start self.songs as an empty list
        ...

    def add(self, title):
        """Add a song title to the end of this playlist."""
        # TODO
        ...

    def count(self):
        """Return how many songs are on this playlist."""
        # TODO
        ...

road_trip = Playlist("Road trip")
road_trip.add("Africa")
road_trip.add("Mr. Blue Sky")
print(road_trip.count())    # should print 2
--- solution
class Playlist:
    """A named list of song titles."""

    def __init__(self, name):
        self.name = name
        self.songs = []

    def add(self, title):
        """Add a song title to the end of this playlist."""
        self.songs.append(title)

    def count(self):
        """Return how many songs are on this playlist."""
        return len(self.songs)

road_trip = Playlist("Road trip")
road_trip.add("Africa")
road_trip.add("Mr. Blue Sky")
print(road_trip.count())
--- test
p = Playlist("Gym")
assert hasattr(p, "name"), "Replace the `...` in `__init__`: store the playlist's name with `self.name = name`."
assert p.name == "Gym", f"`name` should be the value passed in ('Gym'), but is {p.name!r}."
assert hasattr(p, "songs"), "Each Playlist needs a `songs` attribute that starts as an empty list."
assert isinstance(p.songs, list), f"`songs` should be a list, not {type(p.songs).__name__}."
assert p.songs == [], f"A new playlist should start with no songs, but `songs` is {p.songs!r}."
p.add("Eye of the Tiger")
p.add("Stronger")
assert p.songs == ["Eye of the Tiger", "Stronger"], f"After adding two songs, `songs` should be ['Eye of the Tiger', 'Stronger'], but is {p.songs!r}."
c = p.count()
assert c is not None and c is not ..., "`count()` should **return** the number of songs (use `return`, not `print`)."
assert c == 2, f"`count()` should be 2 after two adds, but is {c!r}."
q = Playlist("Chill")
assert q.songs == [] and q.count() == 0, "A second playlist should start empty. Make sure each Playlist gets its own new list in `__init__`."
q.add("Weightless")
assert p.count() == 2 and q.count() == 1, "Adding to one playlist changed another. Each playlist must have its own `songs` list."
--- hint
In `__init__`, create two attributes: one for the name, and `self.songs = []` so every new playlist gets its own empty list.
--- hint
`add` should append to *this* playlist's list: `self.songs.append(...)`. `count` can use `len()` on the same list.
--- hint
Both `add` and `count` must go through `self`. A bare `songs` inside a method is a different, local name.
```

## The attribute that vanished

Inside a method, a name **without** `self.` is just an ordinary local variable, gone the moment the method returns. Forgetting `self.` is the single most common class bug. In `__init__` it shows up as a missing attribute:

```python run error
class Player:
    def __init__(self, name):
        self.name = name
        lives = 3            # meant to be self.lives!

hero = Player("Aria")
print(hero.name)
print(hero.lives)
```

Read the last line of the traceback: `'Player' object has no attribute 'lives'`. Python is telling you the truth. `lives = 3` created a local variable inside `__init__`, and it vanished when `__init__` finished. Nothing was ever stored on the object. The same `AttributeError` appears if you simply misspell an attribute (`hero.live`), so check spelling first, then check for a missing `self.`.

In other methods the same slip is even sneakier, because there's often no error at all. Track this one down:

```python debug id=score-never-changes title="The score never goes up"
class Player:
    def __init__(self, name):
        self.name = name
        self.score = 0

    def add_points(self, points):
        score = self.score + points

    def report(self):
        return f"{self.name}: {self.score} points"

ana = Player("Ana")
ana.add_points(10)
ana.add_points(25)
print(ana.report())    # should say 35 points
--- solution
class Player:
    def __init__(self, name):
        self.name = name
        self.score = 0

    def add_points(self, points):
        self.score = self.score + points

    def report(self):
        return f"{self.name}: {self.score} points"

ana = Player("Ana")
ana.add_points(10)
ana.add_points(25)
print(ana.report())
--- test
assert ana.score != 0, "Ana's score is still 0 after scoring 35 points. Where does `add_points` put its result?"
assert ana.score == 35, f"Ana's score should be 35 (10 + 25), but it is {ana.score!r}."
p = Player("Ben")
p.add_points(7)
p.add_points(3)
p.add_points(5)
assert p.score == 15, f"A fresh player who scores 7, 3 and 5 should have 15 points, but has {p.score!r}."
assert "35 points" in _stdout, "Keep the `print(ana.report())` line so the score is shown."
--- hint
Run it, or use **Debug** and step into `add_points`. Watch the Variables panel: the new total is calculated, but where is it stored?
--- hint
`score = ...` creates a local variable that disappears when the method ends. To change the object, the assignment has to go through `self`.
```

## Class attributes: shared by every instance

Attributes set with `self.something = ...` belong to one object. You can also put a variable directly inside the class body. That's a **class attribute**: one value, stored on the class, shared by every instance. It's perfect for settings that apply to all objects, like an interest rate.

```python run
class SavingsAccount:
    interest_rate = 0.02          # class attribute: shared by all accounts

    def __init__(self, owner, balance):
        self.owner = owner        # instance attributes: one per account
        self.balance = balance

    def add_interest(self):
        self.balance += self.balance * self.interest_rate
        return round(self.balance, 2)

maya = SavingsAccount("Maya", 1000)
leo = SavingsAccount("Leo", 250)
print("Maya's rate:", maya.interest_rate, " Leo's rate:", leo.interest_rate)

SavingsAccount.interest_rate = 0.03     # the bank changes the rate for everyone
print("after the change:", maya.add_interest(), leo.add_interest())
```

How does `maya.interest_rate` work when `maya` has no such attribute in her own box? Python looks things up in a fixed order:

```text
maya.interest_rate
   1. Look in maya's own attributes  {owner: "Maya", balance: 1000}   → not there
   2. Look in her class, SavingsAccount  {interest_rate: 0.03, ...}   → found it!
```

That lookup order explains a surprising consequence. *Reading* through an instance falls back to the class, but *assigning* through an instance always writes into that instance's own box, creating a new attribute that hides the class one:

```python predict id=predict-class-attr-shadow title="Who gets the new rate?"
class Account:
    rate = 0.02

a = Account()
b = Account()
a.rate = 0.05
print(a.rate, b.rate, Account.rate)
--- options
0.05 0.05 0.05
* 0.05 0.02 0.02
0.05 0.05 0.02
0.02 0.02 0.02
--- explain
`a.rate = 0.05` stores a **new instance attribute** on `a` only. When you read `a.rate`, Python finds it in `a`'s own box first. `b` has no `rate` of its own, so `b.rate` falls back to the class, which still says `0.02`. To change the value for everyone, assign to `Account.rate`.
```

> **Pitfall:** A class attribute that is a **list or dict** is shared by every instance, and methods like `.append()` change that one shared object, not a per-instance copy. Look:

```python run
class Dog:
    tricks = []                    # one list for ALL dogs!

    def __init__(self, name):
        self.name = name

    def learn(self, trick):
        self.tricks.append(trick)

rex = Dog("Rex")
fido = Dog("Fido")
rex.learn("sit")
fido.learn("roll over")
print("Rex knows:", rex.tricks)
print("rex.tricks is fido.tricks:", rex.tricks is fido.tricks)
```

`self.tricks.append(...)` doesn't assign anything; it *reads* `self.tricks` (which falls back to the class's one list) and then changes that list. The rule of thumb: **numbers, strings and settings can be class attributes; anything each object should own, especially lists and dicts, gets created in `__init__` with `self.`.** It's the same "one list, two names" aliasing you met in lesson 14, and the same trap as the mutable default argument from lesson 20.

```python exercise id=game-character title="A game character with health"
class Character:
    max_health = 100   # class attribute: the cap for every character

    def __init__(self, name):
        # TODO: store the name, and start self.health at the class's max_health
        ...

    def take_damage(self, amount):
        """Lose `amount` health, but never drop below 0."""
        # TODO
        ...

    def heal(self, amount):
        """Gain `amount` health, but never go above max_health."""
        # TODO
        ...

    def is_alive(self):
        """Return True if health is above 0, otherwise False."""
        # TODO
        ...

hero = Character("Aria")
hero.take_damage(30)
hero.heal(10)
print(hero.is_alive())
--- solution
class Character:
    max_health = 100

    def __init__(self, name):
        self.name = name
        self.health = self.max_health

    def take_damage(self, amount):
        """Lose `amount` health, but never drop below 0."""
        self.health = max(0, self.health - amount)

    def heal(self, amount):
        """Gain `amount` health, but never go above max_health."""
        self.health = min(self.max_health, self.health + amount)

    def is_alive(self):
        """Return True if health is above 0, otherwise False."""
        return self.health > 0

hero = Character("Aria")
hero.take_damage(30)
hero.heal(10)
print(hero.is_alive())
--- test
c = Character("Tester")
assert hasattr(c, "name") and hasattr(c, "health"), "Replace the `...` in `__init__`: each character needs `name` and `health` attributes."
assert c.name == "Tester", f"`name` should be the value passed in, but is {c.name!r}."
assert c.health == 100, f"A new character should start at max_health (100), but has {c.health!r} health."
assert Character.max_health == 100, "Leave the class attribute `max_health = 100` as it is."
c.take_damage(30)
assert c.health == 70, f"After 30 damage, health should be 70, but is {c.health!r}."
c.heal(10)
assert c.health == 80, f"After healing 10, health should be 80, but is {c.health!r}."
c.heal(500)
assert c.health == 100, f"Healing can't go above max_health: expected 100, got {c.health!r}."
alive = c.is_alive()
assert alive is True, f"`is_alive()` should return True for a character with {c.health} health, but returned {alive!r}."
c.take_damage(250)
assert c.health == 0, f"Health should never drop below 0, but is {c.health!r} after a huge hit."
assert c.is_alive() is False, f"`is_alive()` should return False at 0 health, but returned {c.is_alive()!r}."
other = Character("Other")
assert other.health == 100, "Damaging one character changed another. Each character needs its own `health`."
Character.max_health = 150
try:
    tank = Character("Tank")
    assert tank.health == 150, "When `Character.max_health` changes to 150, new characters should start at 150. Use the class attribute instead of typing 100."
    tank.take_damage(20)
    tank.heal(100)
    assert tank.health == 150, f"With max_health 150, healing should cap at 150, but health is {tank.health!r}. Use `self.max_health` in `heal` instead of 100."
finally:
    Character.max_health = 100
--- hint
In `__init__`, start health from the class attribute: `self.health = self.max_health` (reading through `self` falls back to the class).
--- hint
To clamp a value, `max(0, x)` never goes below 0 and `min(cap, x)` never goes above `cap`.
--- hint
`is_alive` should `return` a comparison such as `self.health > 0`, which is already `True` or `False`.
```

```python debug id=shared-cart title="Every customer sees the same cart"
class ShoppingCart:
    items = []                  # every cart starts empty

    def __init__(self, customer):
        self.customer = customer

    def add(self, item):
        self.items.append(item)

    def size(self):
        return len(self.items)

ana = ShoppingCart("Ana")
ben = ShoppingCart("Ben")
ana.add("apples")
ana.add("bread")
ben.add("coffee")

print("Ana's cart:", ana.items)
print("Ben's cart:", ben.items)
--- solution
class ShoppingCart:
    def __init__(self, customer):
        self.customer = customer
        self.items = []         # every cart starts empty

    def add(self, item):
        self.items.append(item)

    def size(self):
        return len(self.items)

ana = ShoppingCart("Ana")
ben = ShoppingCart("Ben")
ana.add("apples")
ana.add("bread")
ben.add("coffee")

print("Ana's cart:", ana.items)
print("Ben's cart:", ben.items)
--- test
assert ana.items is not ben.items, "Ana and Ben are still sharing one list. Each cart needs its own `items` list."
assert ana.items == ["apples", "bread"], f"Ana's cart should be ['apples', 'bread'], but is {ana.items!r}."
assert ben.items == ["coffee"], f"Ben's cart should be ['coffee'], but is {ben.items!r}."
c1 = ShoppingCart("Cleo")
c2 = ShoppingCart("Dev")
assert c1.items == [] and c2.items == [], f"A brand-new cart should be empty, but a new cart has {c1.items!r}."
c1.add("tea")
assert c2.size() == 0 and c1.size() == 1, "Adding to one new cart changed another cart."
--- hint
Run it: Ben's cart contains Ana's groceries. How many `items` lists exist in this program? Check with `ana.items is ben.items`.
--- hint
`items = []` in the class body is a class attribute: one list shared by every cart. Where should a list that belongs to *one* cart be created?
```

## When should you write a class?

You could model a bank account with a dict and a few functions, and for tiny scripts that's fine. A class earns its place when data and the rules for changing it belong together:

| Use… | When… | Example |
|---|---|---|
| plain values, lists, dicts | you're just holding data | a list of temperatures, a settings dict |
| functions | you're transforming data in one step | `average(scores)` |
| a **class** | several pieces of data travel together **and** have behaviour or rules | an account that refuses overdrafts, a character that can't heal past full |

A good sign you need a class: you keep passing the same dict to five different functions, each of which pokes at its keys. Moving those functions into a class as methods gives the data a home and gives each rule one obvious place to live.

> **In the wild:** Almost every library you'll use is built from classes. In Django, each database table is a class (`class Order(models.Model)`), and each row you load is an instance. A pandas `DataFrame` is a class, and `df.head()` is a method call with `df` as `self`. Even `datetime.date(2026, 3, 14)` from lesson 25 builds an instance with attributes `.year`, `.month` and `.day`.

## Recap

- A **class** is a blueprint; calling it (`Pet("Rex", "dog", 3)`) builds an **instance**, a separate object with its own data.
- `__init__` runs automatically on every new instance. Use it to create every attribute with `self.name = value`.
- `self` is "this particular object": `rex.describe()` is really `Pet.describe(rex)`. Every method takes `self` first.
- Inside methods, always reach attributes through `self.`; a bare name is a local variable that vanishes when the method ends.
- Methods live once on the class; attributes live separately on each instance, so changing one object never affects another.
- **Class attributes** are shared by all instances: good for settings like `interest_rate`, dangerous for lists and dicts, which belong in `__init__`.

**Up next:** special methods, properties and inheritance: make your objects print nicely, compare with `==`, validate their own data, and build new classes on top of old ones.
