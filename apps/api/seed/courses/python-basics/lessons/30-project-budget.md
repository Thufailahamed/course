Where did all the money go this month? Almost everyone has asked that question, and the apps that answer it (Mint, YNAB, your bank's "insights" tab) are, at their core, a list of transactions plus a few clever ways to add them up. In this final project you'll build your own: a **budget tracker** that records income and expenses, refuses bad data, knows its balance, breaks spending down by category and by month, finds your biggest expenses, and saves everything to a JSON file so nothing is lost when the program stops.

This is the project where your classes earn their keep. A `Transaction` is a small record type, a `Budget` owns a list of them and knows how to answer questions about them, and the rest of the program just talks to the `Budget`. It's the same shape as real-world software, from banking backends to web shops, and it uses nearly everything you've learned in this course.

> **How this project works:** each step is a challenge that adds one piece to the two classes. Challenges run on their own, so each one includes the finished parts it needs from earlier steps. At the end you'll run the whole tracker, save it, load it back, and print a monthly report.

```python setup
# Two months of Maya's finances: (date, description, amount, category, kind)
SAMPLE = [
    ("2026-03-01", "Salary", 3200.00, "salary", "income"),
    ("2026-03-02", "Rent", 1150.00, "housing", "expense"),
    ("2026-03-05", "Groceries", 84.30, "food", "expense"),
    ("2026-03-09", "Train pass", 92.00, "transport", "expense"),
    ("2026-03-14", "Concert tickets", 120.00, "fun", "expense"),
    ("2026-03-19", "Groceries", 61.75, "food", "expense"),
    ("2026-03-23", "Freelance logo", 450.00, "side gig", "income"),
    ("2026-03-28", "Dinner out", 58.40, "food", "expense"),
    ("2026-04-01", "Salary", 3200.00, "salary", "income"),
    ("2026-04-02", "Rent", 1150.00, "housing", "expense"),
    ("2026-04-06", "Groceries", 77.10, "food", "expense"),
    ("2026-04-11", "Bike repair", 145.00, "transport", "expense"),
]
```

## The plan

Two classes, each with a clear job:

```text
Transaction  (a @dataclass: one line on a bank statement)
  date, description, amount, category, kind ("income" or "expense")
  .signed            → +amount for income, -amount for expenses

Budget  (owns the list, answers questions)
  .add(...)          → validates, then records a Transaction
  .balance           → everything in minus everything out
  .spending_by_category()   .monthly_summary(month)   .top_expenses(n)
  .save(path)  /  load_budget(path)  → JSON on disk
```

The setup has loaded `SAMPLE`: two months of transactions for Maya, a designer with a day job and a side gig. Each row is a tuple in the same order as the `Transaction` fields.

```python run
print(len(SAMPLE), "transactions")
for row in SAMPLE[:3]:
    print(row)
```

## Step 1: the Transaction record

A transaction is pure data with a fixed set of fields: exactly what `@dataclass` (lesson 27) was made for. It writes `__init__`, `__repr__` and `__eq__` for you.

Amounts are always stored as **positive** numbers, and `kind` says which way the money moved. That keeps the data easy to read ("Rent: 1150, expense"), and a `signed` property turns it into a plus-or-minus number whenever you need to do math. For printing, a negative number with a thousands separator lines up nicely with a format spec:

```python run
for amount in [3200.0, -1150.0, -84.3]:
    print(f"[{amount:>10,.2f}]")
```

```python predict id=predict-signed-format title="Formatting a negative amount"
print(f"[{-1150:>10,.2f}]")
--- options
[-1150.00]
* [ -1,150.00]
[-1,150.00 ]
[  -1150.00]
--- explain
`,` adds a thousands separator and `.2f` gives two decimals, so the number becomes `-1,150.00`. That's 9 characters, and `>10` right-aligns it in a field of 10 by adding one space on the left. The minus sign counts as a character.
```

```python exercise id=transaction-dataclass title="Build the Transaction record"
from dataclasses import dataclass

@dataclass
class Transaction:
    date: str          # "YYYY-MM-DD"
    description: str
    amount: float      # always positive
    category: str
    kind: str          # "income" or "expense"

    @property
    def signed(self):
        """The amount with a sign: positive for income, negative for an expense."""
        # TODO: return the signed amount
        ...

    def __str__(self):
        """One statement line: the date, two spaces, the description left-aligned
        in 16 characters, the signed amount right-aligned in 10 characters with
        commas and 2 decimals, two spaces, then the category in parentheses."""
        # TODO: replace the placeholder with an f-string built from the spec above
        return "TODO"

rent = Transaction("2026-03-02", "Rent", 1150.0, "housing", "expense")
print(rent.signed)
print(rent)
--- solution
from dataclasses import dataclass

@dataclass
class Transaction:
    date: str          # "YYYY-MM-DD"
    description: str
    amount: float      # always positive
    category: str
    kind: str          # "income" or "expense"

    @property
    def signed(self):
        """The amount with a sign: positive for income, negative for an expense."""
        return self.amount if self.kind == "income" else -self.amount

    def __str__(self):
        """One statement line: the date, two spaces, the description left-aligned
        in 16 characters, the signed amount right-aligned in 10 characters with
        commas and 2 decimals, two spaces, then the category in parentheses."""
        return f"{self.date}  {self.description:<16}{self.signed:>10,.2f}  ({self.category})"

rent = Transaction("2026-03-02", "Rent", 1150.0, "housing", "expense")
print(rent.signed)
print(rent)
--- test
rent = Transaction("2026-03-02", "Rent", 1150.0, "housing", "expense")
pay = Transaction("2026-03-01", "Salary", 3200.0, "salary", "income")
assert rent.signed is not None and rent.signed is not ..., "`signed` returns nothing yet. Replace the `...` with a `return` statement."
assert rent.signed == -1150.0, f"An expense of 1150 should have signed == -1150.0, but got {rent.signed!r}."
assert pay.signed == 3200.0, f"An income of 3200 should have signed == 3200.0, but got {pay.signed!r}."
assert str(rent) != "TODO", "Replace the placeholder `return \"TODO\"` in `__str__` with your f-string."
assert isinstance(str(rent), str), "`__str__` must return a string."
for t in [rent, pay, Transaction("2026-04-11", "Bike repair", 145.5, "transport", "expense")]:
    expected = f"{t.date}  {t.description:<16}{t.signed:>10,.2f}  ({t.category})"
    assert str(t) == expected, f"str() should give {expected!r}, but gave {str(t)!r}. Check the widths (:<16 and :>10,.2f), the two-space gaps and the parentheses."
--- hint
`signed` is a one-line conditional expression: the amount if `self.kind == "income"`, otherwise its negative.
--- hint
For `__str__`, use `{self.description:<16}` and `{self.signed:>10,.2f}` inside one f-string, with two spaces after the date and before the `(category)`.
```

## Step 2: a Budget that refuses bad data

A budget is only as trustworthy as the data in it. A negative expense, an amount typed as text or a misspelled kind like `"expence"` would quietly poison every total. So the `add` method acts like a bouncer: it checks everything first and **raises a `ValueError`** (lesson 23) for anything invalid, before it ever touches the list.

```python run error
def deposit(balance, amount):
    if amount <= 0:
        raise ValueError(f"amount must be positive, not {amount}")
    return balance + amount

print(deposit(100, 25))
print(deposit(100, -40))
```

The first call works; the second stops the program with your own message, pointing at the exact problem. That's much better than a wrong balance discovered weeks later. The code that *calls* `add` decides what to do about it, usually with `try`/`except`.

> **Pitfall:** Check the type **before** comparing. `"50" <= 0` raises a confusing `TypeError`, but `not isinstance(amount, (int, float)) or amount <= 0` short-circuits (lesson 7): if the amount isn't a number, the comparison never runs.

```python exercise id=budget-add title="Add transactions, with validation"
from dataclasses import dataclass

@dataclass
class Transaction:  # Step 1 (without __str__)
    date: str
    description: str
    amount: float
    category: str
    kind: str

class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []

    def add(self, date, description, amount, category, kind):
        """Validate, then record a new Transaction and return it."""
        # TODO 1: raise ValueError if kind is not "income" or "expense"
        # TODO 2: raise ValueError if amount is not a number (int or float) greater than 0
        # TODO 3: create a Transaction (store the amount as a float),
        #         append it to self.transactions, and return it
        ...

budget = Budget("Maya")
budget.add("2026-03-01", "Salary", 3200, "salary", "income")
try:
    budget.add("2026-03-02", "Oops", -50, "food", "expense")
except ValueError as e:
    print("rejected:", e)
print(len(budget.transactions), "transaction(s) recorded")
--- solution
from dataclasses import dataclass

@dataclass
class Transaction:  # Step 1 (without __str__)
    date: str
    description: str
    amount: float
    category: str
    kind: str

class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []

    def add(self, date, description, amount, category, kind):
        """Validate, then record a new Transaction and return it."""
        if kind not in ("income", "expense"):
            raise ValueError(f"kind must be 'income' or 'expense', not {kind!r}")
        if not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError(f"amount must be a positive number, not {amount!r}")
        t = Transaction(date, description, float(amount), category, kind)
        self.transactions.append(t)
        return t

budget = Budget("Maya")
budget.add("2026-03-01", "Salary", 3200, "salary", "income")
try:
    budget.add("2026-03-02", "Oops", -50, "food", "expense")
except ValueError as e:
    print("rejected:", e)
print(len(budget.transactions), "transaction(s) recorded")
--- test
b = Budget("Test")
t = b.add("2026-05-01", "Paycheck", 2000, "salary", "income")
assert len(b.transactions) == 1, f"After one valid add, `transactions` should hold 1 item, but holds {len(b.transactions)}. Append the new Transaction."
assert t is not None, "`add` should return the Transaction it created."
assert isinstance(t, Transaction), f"`add` should return a Transaction, but returned {t!r}."
assert t == Transaction("2026-05-01", "Paycheck", 2000.0, "salary", "income"), f"The recorded transaction looks wrong: {t!r}."
assert isinstance(t.amount, float), f"Store the amount as a float (2000 becomes 2000.0), but it's {t.amount!r}."
bad = [(-50, "expense", "a negative amount"), (0, "expense", "an amount of 0"), ("50", "expense", "an amount given as text"),
       (25, "expence", "the misspelled kind 'expence'"), (25, "refund", "the kind 'refund'")]
for amount, kind, why in bad:
    before = len(b.transactions)
    try:
        b.add("2026-05-02", "Bad", amount, "food", kind)
    except ValueError:
        pass
    except TypeError:
        raise AssertionError(f"`add` crashed with TypeError for {why}. Check the type with isinstance BEFORE comparing to 0, and raise ValueError.")
    else:
        raise AssertionError(f"`add` accepted {why}. It should raise ValueError.")
    assert len(b.transactions) == before, f"`add` raised for {why}, but only after appending it. Validate first."
b.add("2026-05-03", "Coffee", 3.5, "food", "expense")
assert len(b.transactions) == 2, "Valid adds should still work after rejected ones."
--- hint
`if kind not in ("income", "expense"): raise ValueError("...")` handles TODO 1. Put both checks at the top of the method, before anything is appended.
--- hint
For TODO 2: `if not isinstance(amount, (int, float)) or amount <= 0: raise ValueError(...)`. Then build `Transaction(date, description, float(amount), category, kind)`, append it, and return it.
```

## Step 3: two budgets, one history?

Maya's roommate Leo wants a budget too. The code below creates one for each of them, but something is very wrong: Leo can see Maya's rent.

```python debug id=shared-history title="Every budget shows everyone's transactions"
from dataclasses import dataclass

@dataclass
class Transaction:
    date: str
    description: str
    amount: float
    category: str
    kind: str

class Budget:
    transactions = []      # the budget's history

    def __init__(self, owner):
        self.owner = owner

    def add(self, date, description, amount, category, kind):  # Step 2 (validation shortened)
        if kind not in ("income", "expense") or not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError("invalid transaction")
        t = Transaction(date, description, float(amount), category, kind)
        self.transactions.append(t)
        return t

maya = Budget("Maya")
leo = Budget("Leo")
maya.add("2026-03-02", "Rent", 1150, "housing", "expense")
leo.add("2026-03-04", "Gym", 35, "health", "expense")
print("Maya has", len(maya.transactions), "transactions")
print("Leo has", len(leo.transactions), "transactions")
--- solution
from dataclasses import dataclass

@dataclass
class Transaction:
    date: str
    description: str
    amount: float
    category: str
    kind: str

class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []      # each budget's own history

    def add(self, date, description, amount, category, kind):  # Step 2 (validation shortened)
        if kind not in ("income", "expense") or not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError("invalid transaction")
        t = Transaction(date, description, float(amount), category, kind)
        self.transactions.append(t)
        return t

maya = Budget("Maya")
leo = Budget("Leo")
maya.add("2026-03-02", "Rent", 1150, "housing", "expense")
leo.add("2026-03-04", "Gym", 35, "health", "expense")
print("Maya has", len(maya.transactions), "transactions")
print("Leo has", len(leo.transactions), "transactions")
--- test
a = Budget("A")
b = Budget("B")
a.add("2026-06-01", "Book", 12, "fun", "expense")
assert len(b.transactions) == 0, f"Budget B is brand new, but it already holds {len(b.transactions)} transaction(s) added to budget A. Are both budgets sharing one list?"
assert a.transactions is not b.transactions, "Two budgets still share the same `transactions` list object."
assert len(a.transactions) == 1, f"Budget A should hold exactly the 1 transaction added to it, but holds {len(a.transactions)}."
assert [t.description for t in maya.transactions] == ["Rent"], "Maya's budget should contain only her rent."
assert [t.description for t in leo.transactions] == ["Gym"], "Leo's budget should contain only his gym membership."
--- hint
Run it: both budgets report 2 transactions. Where is the `transactions` list created, and how many times does that line run?
--- hint
A list written in the class body is a **class attribute**: one list shared by every instance (lesson 26). Give each budget its own list by creating it in `__init__` with `self.transactions = []`.
```

## Step 4: the balance

The balance is everything that came in minus everything that went out. Since `signed` already carries the direction, it's just a sum.

It should be a **property** (lesson 27), not a stored number. A stored balance would have to be updated by every method that adds or removes a transaction, and one forgotten update would make it wrong forever. A property is computed fresh from the transactions every time you read it, so it can never drift out of sync.

```python predict id=predict-live-property title="Is the property up to date?"
class Jar:
    def __init__(self):
        self.coins = [5, 10]

    @property
    def total(self):
        return sum(self.coins)

jar = Jar()
jar.coins.append(20)
print(jar.total)
--- options
15
* 35
<bound method Jar.total of <__main__.Jar object>>
TypeError: 'int' object is not callable
--- explain
A property runs its code **every time** you read it, so `jar.total` sums the list as it is right now, including the 20 added after the jar was created: `35`. And because it's a property, you read it like an attribute, with no parentheses.
```

Adding up values that pass a test is a one-liner with a generator expression (lesson 18) inside `sum`:

```python run
amounts = [(3200.0, "income"), (1150.0, "expense"), (84.3, "expense")]
print("money out:", sum(a for a, kind in amounts if kind == "expense"))
```

```python exercise id=balance-property title="Add balance and totals"
from dataclasses import dataclass

@dataclass
class Transaction:  # Step 1
    date: str
    description: str
    amount: float
    category: str
    kind: str

    @property
    def signed(self):
        return self.amount if self.kind == "income" else -self.amount

class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []

    def add(self, date, description, amount, category, kind):  # Step 2 (validation shortened)
        if kind not in ("income", "expense") or not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError("invalid transaction")
        self.transactions.append(Transaction(date, description, float(amount), category, kind))

    def total(self, kind):
        """Return the sum of the amounts of all transactions of this kind ("income" or "expense")."""
        # TODO
        ...

    # TODO: add a `balance` PROPERTY: the sum of every transaction's signed amount

budget = Budget("Maya")
for row in SAMPLE:
    budget.add(*row)
print("income:  ", budget.total("income"))
print("expenses:", budget.total("expense"))
--- solution
from dataclasses import dataclass

@dataclass
class Transaction:  # Step 1
    date: str
    description: str
    amount: float
    category: str
    kind: str

    @property
    def signed(self):
        return self.amount if self.kind == "income" else -self.amount

class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []

    def add(self, date, description, amount, category, kind):  # Step 2 (validation shortened)
        if kind not in ("income", "expense") or not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError("invalid transaction")
        self.transactions.append(Transaction(date, description, float(amount), category, kind))

    def total(self, kind):
        """Return the sum of the amounts of all transactions of this kind ("income" or "expense")."""
        return sum(t.amount for t in self.transactions if t.kind == kind)

    @property
    def balance(self):
        return sum(t.signed for t in self.transactions)

budget = Budget("Maya")
for row in SAMPLE:
    budget.add(*row)
print("income:  ", budget.total("income"))
print("expenses:", budget.total("expense"))
print("balance: ", budget.balance)
--- test
b = Budget("Test")
b.add("2026-07-01", "Pay", 1000, "salary", "income")
b.add("2026-07-02", "Food", 120.5, "food", "expense")
b.add("2026-07-03", "Bus", 30, "transport", "expense")
inc = b.total("income")
assert inc is not None, "`total` returns None. Replace the `...` with a `return` statement."
assert abs(inc - 1000) < 1e-9, f"total('income') should be 1000.0, but got {inc!r}."
assert abs(b.total("expense") - 150.5) < 1e-9, f"total('expense') should be 150.5, but got {b.total('expense')!r}."
assert "balance" in vars(Budget), "Add a `balance` property to the Budget class."
assert isinstance(vars(Budget)["balance"], property), "`balance` should be a @property, so it's read as `budget.balance` with no parentheses. Put `@property` on the line above `def balance(self):`."
assert abs(b.balance - 849.5) < 1e-9, f"The balance should be 1000 - 120.5 - 30 = 849.5, but got {b.balance!r}."
b.add("2026-07-04", "Gift", 50, "gifts", "income")
assert abs(b.balance - 899.5) < 1e-9, "After another income of 50, the balance should update to 899.5. Compute it from the transactions each time."
m = Budget("Maya")
for row in SAMPLE:
    m.add(*row)
assert round(m.balance, 2) == 3911.45, f"Maya's balance from SAMPLE should be 3911.45, but got {m.balance!r}."
--- hint
`total` is a `sum(...)` over `t.amount` for each transaction `t` whose `t.kind == kind`.
--- hint
For the balance: `@property` on one line, then `def balance(self):` returning `sum(t.signed for t in self.transactions)`.
```

> **In the wild:** real finance software never stores money as `float`. `0.1 + 0.2` isn't exactly `0.3` (lesson 4), and over thousands of transactions those tiny errors add up to missing cents. Banks use the `decimal` module's `Decimal` type, or store whole **cents** as integers. Floats are fine for learning, and we round for display, but now you know why your bank doesn't.

## Step 5: where does the money go?

The most useful question a budget answers is "what am I spending on?" That's the grouping-and-summing pattern from lesson 16: a dictionary from category to total, built in one loop.

A plain dictionary keeps keys in the order they were first added. For a report you want the biggest category first, so sort the `(category, total)` pairs by their total and rebuild the dictionary from them:

```python run
totals = {"food": 281.55, "housing": 2300.0, "fun": 120.0}

ordered = sorted(totals.items(), key=lambda pair: pair[1], reverse=True)
print(ordered)
dict(ordered)
```

```python exercise id=category-totals title="Spending by category"
from dataclasses import dataclass

@dataclass
class Transaction:  # Step 1 (without the extras)
    date: str
    description: str
    amount: float
    category: str
    kind: str

class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []

    def add(self, date, description, amount, category, kind):  # Step 2 (validation shortened)
        if kind not in ("income", "expense") or not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError("invalid transaction")
        self.transactions.append(Transaction(date, description, float(amount), category, kind))

    def spending_by_category(self):
        """Return {category: total spent} for EXPENSES only.

        Round each total to 2 decimals, and order the dict from the biggest total to the smallest.
        """
        totals = {}
        # TODO 1: add up each expense's amount under its category
        # TODO 2: return a dict with rounded totals, biggest first
        ...

budget = Budget("Maya")
for row in SAMPLE:
    budget.add(*row)
print(budget.spending_by_category())
--- solution
from dataclasses import dataclass

@dataclass
class Transaction:  # Step 1 (without the extras)
    date: str
    description: str
    amount: float
    category: str
    kind: str

class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []

    def add(self, date, description, amount, category, kind):  # Step 2 (validation shortened)
        if kind not in ("income", "expense") or not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError("invalid transaction")
        self.transactions.append(Transaction(date, description, float(amount), category, kind))

    def spending_by_category(self):
        """Return {category: total spent} for EXPENSES only.

        Round each total to 2 decimals, and order the dict from the biggest total to the smallest.
        """
        totals = {}
        for t in self.transactions:
            if t.kind == "expense":
                totals[t.category] = totals.get(t.category, 0) + t.amount
        ordered = sorted(totals.items(), key=lambda pair: pair[1], reverse=True)
        return {category: round(total, 2) for category, total in ordered}

budget = Budget("Maya")
for row in SAMPLE:
    budget.add(*row)
print(budget.spending_by_category())
--- test
m = Budget("Maya")
for row in SAMPLE:
    m.add(*row)
got = m.spending_by_category()
assert got is not None, "`spending_by_category` returns None. Finish the TODOs and `return` the dictionary."
assert isinstance(got, dict), f"`spending_by_category` should return a dict, but returned {type(got).__name__}."
assert "salary" not in got and "side gig" not in got, f"Only expenses count, but your totals include income categories: {got}."
expected = {"housing": 2300.0, "food": 281.55, "transport": 237.0, "fun": 120.0}
assert got == expected, f"Expected {expected}, but got {got}. Add every expense into its category, and round each total to 2 decimals."
assert list(got) == list(expected), f"The categories should go from biggest to smallest total: {list(expected)}, but yours are in the order {list(got)}."
b = Budget("Test")
b.add("2026-08-01", "Pay", 900, "salary", "income")
for desc, amount, cat in [("Cinema", 12.5, "fun"), ("Lunch", 9.99, "food"), ("Arcade", 20, "fun"), ("Dinner", 30.02, "food")]:
    b.add("2026-08-02", desc, amount, cat, "expense")
got2 = b.spending_by_category()
assert got2 == {"food": 40.01, "fun": 32.5} and list(got2) == ["food", "fun"], f"For a different budget expected {{'food': 40.01, 'fun': 32.5}} (food first), but got {got2}."
--- hint
TODO 1 is the counting pattern with amounts instead of 1: `totals[t.category] = totals.get(t.category, 0) + t.amount`, only when `t.kind == "expense"`.
--- hint
For TODO 2, sort `totals.items()` with `key=lambda pair: pair[1], reverse=True`, then build the result with a dict comprehension that rounds each total.
```

## Step 6: one month at a time

People think about money month by month. Because the dates are stored as `"YYYY-MM-DD"` strings, "all transactions in March 2026" is simply those whose date **starts with** `"2026-03"`:

```python run
dates = ["2026-03-01", "2026-03-28", "2026-04-02", "2025-03-15"]
print([d for d in dates if d.startswith("2026-03")])
```

> **Tip:** Dates written year-month-day (the ISO 8601 format) sort correctly even as plain strings, because the most significant part comes first. That's why programmers love them. For real date arithmetic, like "30 days from now", convert to `datetime.date` objects (lesson 25).

```python exercise id=month-summary title="Summarize a month"
from dataclasses import dataclass

@dataclass
class Transaction:  # Step 1 (without the extras)
    date: str
    description: str
    amount: float
    category: str
    kind: str

class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []

    def add(self, date, description, amount, category, kind):  # Step 2 (validation shortened)
        if kind not in ("income", "expense") or not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError("invalid transaction")
        self.transactions.append(Transaction(date, description, float(amount), category, kind))

    def monthly_summary(self, month):
        """month is a "YYYY-MM" string. Return a dict with three keys,
        each rounded to 2 decimals:
          "income":   total income that month
          "expenses": total expenses that month
          "net":      income minus expenses
        """
        # TODO: only count transactions whose date starts with `month`
        ...

budget = Budget("Maya")
for row in SAMPLE:
    budget.add(*row)
print("March:", budget.monthly_summary("2026-03"))
print("April:", budget.monthly_summary("2026-04"))
--- solution
from dataclasses import dataclass

@dataclass
class Transaction:  # Step 1 (without the extras)
    date: str
    description: str
    amount: float
    category: str
    kind: str

class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []

    def add(self, date, description, amount, category, kind):  # Step 2 (validation shortened)
        if kind not in ("income", "expense") or not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError("invalid transaction")
        self.transactions.append(Transaction(date, description, float(amount), category, kind))

    def monthly_summary(self, month):
        """month is a "YYYY-MM" string. Return a dict with three keys,
        each rounded to 2 decimals:
          "income":   total income that month
          "expenses": total expenses that month
          "net":      income minus expenses
        """
        in_month = [t for t in self.transactions if t.date.startswith(month)]
        income = sum(t.amount for t in in_month if t.kind == "income")
        expenses = sum(t.amount for t in in_month if t.kind == "expense")
        return {"income": round(income, 2), "expenses": round(expenses, 2), "net": round(income - expenses, 2)}

budget = Budget("Maya")
for row in SAMPLE:
    budget.add(*row)
print("March:", budget.monthly_summary("2026-03"))
print("April:", budget.monthly_summary("2026-04"))
--- test
m = Budget("Maya")
for row in SAMPLE:
    m.add(*row)
march = m.monthly_summary("2026-03")
assert march is not None, "`monthly_summary` returns None. Replace the `...` and `return` a dictionary."
assert isinstance(march, dict), f"`monthly_summary` should return a dict, but returned {type(march).__name__}."
missing = [k for k in ["income", "expenses", "net"] if k not in march]
assert not missing, f"The summary is missing the key(s) {missing}."
assert march == {"income": 3650.0, "expenses": 1566.45, "net": 2083.55}, f"March 2026 should be {{'income': 3650.0, 'expenses': 1566.45, 'net': 2083.55}}, but got {march}. Count only dates that start with '2026-03'."
april = m.monthly_summary("2026-04")
assert april == {"income": 3200.0, "expenses": 1372.1, "net": 1827.9}, f"April 2026 should be {{'income': 3200.0, 'expenses': 1372.1, 'net': 1827.9}}, but got {april}."
assert m.monthly_summary("2026-05") == {"income": 0, "expenses": 0, "net": 0}, f"A month with no transactions should give all zeros, but got {m.monthly_summary('2026-05')}."
b = Budget("Test")
b.add("2025-03-10", "Old pay", 500, "salary", "income")
b.add("2026-03-10", "New pay", 800, "salary", "income")
assert b.monthly_summary("2026-03")["income"] == 800, "March 2025 is not March 2026. Match the whole \"YYYY-MM\" at the start of the date."
--- hint
First filter: `[t for t in self.transactions if t.date.startswith(month)]`. Then sum the income and the expenses separately from that list.
--- hint
Build the result as `{"income": round(income, 2), "expenses": round(expenses, 2), "net": round(income - expenses, 2)}`.
```

## Step 7: the biggest expenses

"Show me my three biggest expenses" is a filter plus a sort. `sorted` with a `key` (lesson 22) can order the `Transaction` objects by any attribute:

```python run
items = [("Rent", 1150.0), ("Groceries", 84.3), ("Concert", 120.0)]
print(sorted(items, key=lambda item: item[1]))
print(sorted(items, key=lambda item: item[1], reverse=True)[:2])
```

Maya's tracker has a `top_expenses` method, but its answers are useless.

```python debug id=top-expenses title="The top expenses list shows the smallest purchases"
from dataclasses import dataclass

@dataclass
class Transaction:
    date: str
    description: str
    amount: float
    category: str
    kind: str

class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []

    def add(self, date, description, amount, category, kind):  # Step 2 (validation shortened)
        if kind not in ("income", "expense") or not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError("invalid transaction")
        self.transactions.append(Transaction(date, description, float(amount), category, kind))

    def top_expenses(self, n=3):
        """Return the n largest EXPENSES, biggest first."""
        return sorted(self.transactions, key=lambda t: t.amount)[:n]

budget = Budget("Maya")
for row in SAMPLE:
    budget.add(*row)
for t in budget.top_expenses():
    print(t.description, t.amount)
--- solution
from dataclasses import dataclass

@dataclass
class Transaction:
    date: str
    description: str
    amount: float
    category: str
    kind: str

class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []

    def add(self, date, description, amount, category, kind):  # Step 2 (validation shortened)
        if kind not in ("income", "expense") or not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError("invalid transaction")
        self.transactions.append(Transaction(date, description, float(amount), category, kind))

    def top_expenses(self, n=3):
        """Return the n largest EXPENSES, biggest first."""
        expenses = [t for t in self.transactions if t.kind == "expense"]
        return sorted(expenses, key=lambda t: t.amount, reverse=True)[:n]

budget = Budget("Maya")
for row in SAMPLE:
    budget.add(*row)
for t in budget.top_expenses():
    print(t.description, t.amount)
--- test
m = Budget("Maya")
for row in SAMPLE:
    m.add(*row)
top = m.top_expenses()
amounts = [t.amount for t in top]
assert len(top) == 3, f"top_expenses() should return 3 transactions by default, but returned {len(top)}."
assert not (amounts == sorted(amounts) and amounts[0] < amounts[-1]), f"The amounts {amounts} go from smallest to biggest. The biggest should come first."
assert all(t.kind == "expense" for t in top), f"Income snuck into the top expenses: {[t.description for t in top]}. Only expenses should count."
assert amounts == [1150.0, 1150.0, 145.0], f"Maya's top 3 expenses should be 1150.0, 1150.0 and 145.0, but got {amounts}."
b = Budget("Test")
b.add("2026-09-01", "Pay", 5000, "salary", "income")
for desc, amount in [("Snack", 4), ("Laptop", 1299), ("Book", 25), ("Phone", 699)]:
    b.add("2026-09-02", desc, amount, "stuff", "expense")
assert [t.description for t in b.top_expenses(2)] == ["Laptop", "Phone"], f"For another budget, top_expenses(2) should be Laptop then Phone, but got {[t.description for t in b.top_expenses(2)]}."
--- hint
Run it: you get the three *smallest* purchases. What order does `sorted` use unless you tell it otherwise?
--- hint
Two fixes: sort with `reverse=True`, and only sort the transactions whose `kind` is `"expense"`, otherwise Maya's salary tops the list.
```

## Step 8: save and load with JSON

A budget that vanishes when the program ends isn't much use. JSON (lesson 24) can store dictionaries, lists, strings and numbers, but not your own classes, so saving means converting each `Transaction` into a plain dictionary first. The `dataclasses` module has a function for exactly that:

```python run
from dataclasses import dataclass, asdict
import json

@dataclass
class Point:
    city: str
    temp: float

d = asdict(Point("Lisbon", 24.5))
print(d)
print(json.dumps({"readings": [d]}))
```

JSON only knows a few types, so some things change shape on the round trip. Predict this one:

```python predict id=predict-json-roundtrip title="What comes back from JSON?"
import json

saved = json.dumps({"amount": 12.5, "tags": ("food", "weekly")})
print(json.loads(saved))
--- options
{'amount': 12.5, 'tags': ('food', 'weekly')}
* {'amount': 12.5, 'tags': ['food', 'weekly']}
{"amount": 12.5, "tags": ["food", "weekly"]}
{'amount': '12.5', 'tags': ['food', 'weekly']}
--- explain
JSON has arrays but no tuples, so the tuple is saved as an array and **comes back as a list**. Numbers stay numbers. And `json.loads` returns a real Python dict, which prints with single quotes; the double-quoted text is what `json.dumps` produces.
```

Loading is the reverse: read the dictionaries back and turn each one into a transaction again. The neat trick is that each saved dictionary has exactly the keys `add` takes as parameters, so `**` unpacking (lesson 20) passes them all at once: `budget.add(**t)`. Even better, loading through `add` means **a corrupted file can't sneak bad data past your validation.**

```python exercise id=save-load title="Save to JSON and load it back"
from dataclasses import dataclass, asdict
import json

@dataclass
class Transaction:
    date: str
    description: str
    amount: float
    category: str
    kind: str

class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []

    def add(self, date, description, amount, category, kind):  # Step 2 (validation shortened)
        if kind not in ("income", "expense") or not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError("invalid transaction")
        self.transactions.append(Transaction(date, description, float(amount), category, kind))

    def save(self, path):
        """Write {"owner": ..., "transactions": [ {...}, ... ]} to path as JSON (indent=2)."""
        # TODO: build the dict (use asdict for each transaction) and json.dump it
        ...

def load_budget(path):
    """Read a file written by Budget.save and return a new Budget with the same data."""
    # TODO: json.load the file, create a Budget for the owner, and add each transaction
    ...

budget = Budget("Maya")
for row in SAMPLE:
    budget.add(*row)
budget.save("maya_budget.json")
copy = load_budget("maya_budget.json")
print(copy)
--- solution
from dataclasses import dataclass, asdict
import json

@dataclass
class Transaction:
    date: str
    description: str
    amount: float
    category: str
    kind: str

class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []

    def add(self, date, description, amount, category, kind):  # Step 2 (validation shortened)
        if kind not in ("income", "expense") or not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError("invalid transaction")
        self.transactions.append(Transaction(date, description, float(amount), category, kind))

    def save(self, path):
        """Write {"owner": ..., "transactions": [ {...}, ... ]} to path as JSON (indent=2)."""
        data = {"owner": self.owner, "transactions": [asdict(t) for t in self.transactions]}
        with open(path, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=2)

def load_budget(path):
    """Read a file written by Budget.save and return a new Budget with the same data."""
    with open(path, encoding="utf-8") as f:
        data = json.load(f)
    budget = Budget(data["owner"])
    for t in data["transactions"]:
        budget.add(**t)
    return budget

budget = Budget("Maya")
for row in SAMPLE:
    budget.add(*row)
budget.save("maya_budget.json")
copy = load_budget("maya_budget.json")
print(copy.owner, len(copy.transactions), "transactions")
--- test
import os
if os.path.exists("check_budget.json"):
    os.remove("check_budget.json")
b = Budget("Lin")
b.add("2026-10-01", "Pay", 1800, "salary", "income")
b.add("2026-10-03", "Rent", 700, "housing", "expense")
b.add("2026-10-05", "Tea", 4.25, "food", "expense")
b.save("check_budget.json")
assert os.path.exists("check_budget.json"), "`save` didn't create the file. Open `path` in 'w' mode and json.dump into it."
with open("check_budget.json", encoding="utf-8") as f:
    text = f.read()
try:
    data = json.loads(text)
except ValueError:
    raise AssertionError("The saved file isn't valid JSON. Use json.dump(data, f, indent=2).")
assert isinstance(data, dict) and data.get("owner") == "Lin", f"The file should hold a dict with \"owner\": \"Lin\", but holds {data!r}."
assert isinstance(data.get("transactions"), list) and len(data["transactions"]) == 3, "The file's \"transactions\" should be a list with one dict per transaction."
assert data["transactions"][2] == {"date": "2026-10-05", "description": "Tea", "amount": 4.25, "category": "food", "kind": "expense"}, f"Each transaction should be saved as a dict of its fields, but the last one is {data['transactions'][2]!r}."
assert "\n  " in text, "Pass indent=2 to json.dump so the file is readable."
loaded = load_budget("check_budget.json")
assert loaded is not None, "`load_budget` returns None. Build a Budget from the file and `return` it."
assert isinstance(loaded, Budget), f"`load_budget` should return a Budget, but returned {type(loaded).__name__}."
assert loaded.owner == "Lin", f"The loaded budget's owner should be 'Lin', but is {loaded.owner!r}."
assert loaded.transactions == b.transactions, "The loaded transactions should equal the saved ones, in the same order."
assert loaded is not b and loaded.transactions is not b.transactions, "`load_budget` should build a NEW Budget from the file."
with open("check_bad.json", "w", encoding="utf-8") as f:
    json.dump({"owner": "Eve", "transactions": [{"date": "2026-10-01", "description": "Hack", "amount": -999, "category": "x", "kind": "income"}]}, f)
try:
    load_budget("check_bad.json")
except ValueError:
    pass
else:
    raise AssertionError("A file with a negative amount loaded without complaint. Add each transaction back through `add`, so validation runs.")
--- hint
In `save`: `data = {"owner": self.owner, "transactions": [asdict(t) for t in self.transactions]}`, then open `path` with `"w"` and `json.dump(data, f, indent=2)`.
--- hint
In `load_budget`: `json.load` the file, create `Budget(data["owner"])`, then loop over `data["transactions"]` calling `budget.add(**t)` for each one. Don't forget to return the budget.
```

## The finished tracker

Here's the complete program, assembled from your steps. First the record type:

```python run
from dataclasses import dataclass, asdict
import json

@dataclass
class Transaction:
    date: str
    description: str
    amount: float
    category: str
    kind: str

    @property
    def signed(self):
        return self.amount if self.kind == "income" else -self.amount

    def __str__(self):
        return f"{self.date}  {self.description:<16}{self.signed:>10,.2f}  ({self.category})"

print(Transaction("2026-03-02", "Rent", 1150.0, "housing", "expense"))
```

Then the `Budget` class with every method from Steps 2 to 8:

```python run
class Budget:
    def __init__(self, owner):
        self.owner = owner
        self.transactions = []

    def add(self, date, description, amount, category, kind):
        if kind not in ("income", "expense"):
            raise ValueError(f"kind must be 'income' or 'expense', not {kind!r}")
        if not isinstance(amount, (int, float)) or amount <= 0:
            raise ValueError(f"amount must be a positive number, not {amount!r}")
        self.transactions.append(Transaction(date, description, float(amount), category, kind))
        return self.transactions[-1]

    @property
    def balance(self):
        return sum(t.signed for t in self.transactions)

    def spending_by_category(self):
        totals = {}
        for t in self.transactions:
            if t.kind == "expense":
                totals[t.category] = totals.get(t.category, 0) + t.amount
        return {c: round(v, 2) for c, v in sorted(totals.items(), key=lambda p: p[1], reverse=True)}

    def monthly_summary(self, month):
        rows = [t for t in self.transactions if t.date.startswith(month)]
        inc = sum(t.amount for t in rows if t.kind == "income")
        exp = sum(t.amount for t in rows if t.kind == "expense")
        return {"income": round(inc, 2), "expenses": round(exp, 2), "net": round(inc - exp, 2)}

    def top_expenses(self, n=3):
        expenses = [t for t in self.transactions if t.kind == "expense"]
        return sorted(expenses, key=lambda t: t.amount, reverse=True)[:n]

    def save(self, path):
        data = {"owner": self.owner, "transactions": [asdict(t) for t in self.transactions]}
        with open(path, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=2)

print("Budget is ready:", [name for name in vars(Budget) if not name.startswith("_")])
```

And now the end-to-end run, together with `load_budget`: record Maya's two months, try to sneak in a bad transaction, save to disk, load it back as a fresh object, and print a report from the *loaded* copy.

```python run
def load_budget(path):
    with open(path, encoding="utf-8") as f:
        data = json.load(f)
    budget = Budget(data["owner"])
    for t in data["transactions"]:
        budget.add(**t)
    return budget

maya = Budget("Maya")
for row in SAMPLE:
    maya.add(*row)

try:
    maya.add("2026-04-15", "Refund?", -30, "food", "expense")
except ValueError as e:
    print("rejected:", e)

maya.save("maya_budget.json")
budget = load_budget("maya_budget.json")

print(f"\n=== {budget.owner}'s budget: {len(budget.transactions)} transactions ===")
for t in budget.transactions[-4:]:
    print(t)
print(f"\nBalance: {budget.balance:,.2f}")
for month in ["2026-03", "2026-04"]:
    s = budget.monthly_summary(month)
    print(f"{month}: in {s['income']:>9,.2f}   out {s['expenses']:>9,.2f}   net {s['net']:>9,.2f}")
```

```python run
print("Where the money went:")
for category, total in budget.spending_by_category().items():
    bar = "#" * round(total / 100)
    print(f"  {category:<10}{total:>9,.2f}  {bar}")

print("\nBiggest expenses:")
for t in budget.top_expenses(3):
    print(" ", t)
```

Every number in that report came from the JSON file, through your validation, into your classes. Try it yourself: add a transaction for May in the first cell, or change a category, and run the three cells again.

> **In the wild:** this design (small data classes, a class that owns and validates them, JSON for storage) is how countless real apps start. Web frameworks like FastAPI build on the same idea: a `pydantic` model is a dataclass with validation built in, and it converts to and from JSON automatically to send data over the internet.

## You did it

Take a moment, because this is a real milestone. Thirty lessons ago, `print("Hello, world!")` was new. Look at what you can do now:

| Section | What you can do now |
|---|---|
| Getting Started | write and run programs, read tracebacks calmly, name values with variables |
| Numbers, Text & Truth | calculate, slice and format text, combine conditions, convert user input |
| Decisions & Loops | make programs choose with `if`/`elif`, repeat with `while` and `for`, search and stop early |
| Collections | pick the right container (list, tuple, dict or set) and build them with comprehensions |
| Functions | package logic into reusable, testable functions with flexible arguments |
| Errors, Files & Modules | handle failures gracefully, read and write CSV and JSON, use the standard library |
| Objects & Classes | design your own types with methods, properties, special methods and dataclasses |
| Capstone Projects | build complete programs: a gradebook analyzer, a word game and a budget tracker |

More important than any single feature: you've learned to **break a big problem into small functions, test each piece, read errors instead of fearing them, and use the debugger to see what your code is really doing.** That's the actual job of a programmer, and it carries over to every language and library you'll ever touch.

Some ways to keep the momentum going:

- **Extend a project.** Give the budget tracker monthly limits per category that warn you when you're close, or add a hard mode to the word game. Changing working code is the best practice there is.
- **Automate something real.** Rename a folder of photos, clean up a messy spreadsheet export, or summarize your own bank's CSV download.
- **Read other people's code.** The Python standard library is written in clear Python; open a module you've used and see how it works.

### Next: Python Advanced

**Python Advanced** picks up exactly where this course ends, with the tools professionals use to write code that is faster, safer and easier to maintain:

- **Generators and iterators**: process huge files and endless streams one item at a time, using almost no memory.
- **Decorators**: add logging, timing, caching or access checks to any function with a single `@` line.
- **Context managers**: write your own `with` blocks that always clean up, just like `open()` does.
- **Type hints**: describe what your functions expect and let tools catch bugs before you run anything.
- **Testing with pytest**: turn the `assert` checks you've been passing all course into a professional test suite.
- **Async programming**: let your program do many slow things (like web requests) at once.
- **Packaging**: turn your code into an installable package other people can use.

## Recap

- A `@dataclass` is the quickest way to define a record type, and a **property** like `signed` or `balance` computes values fresh so they can never go stale.
- Validate in one place (`add`) and **raise `ValueError`** for bad data, so nothing invalid ever gets into the list.
- Create mutable attributes like lists **in `__init__`**, never in the class body, or every instance shares them.
- Grouping with a dict, filtering with `startswith` and sorting with `key=lambda ...` answer most "where did the money go?" questions.
- Saving means converting objects to plain dicts (`asdict`) for JSON; loading back through `add(**t)` re-runs your validation.
- You can now build complete, useful programs from a blank page. Congratulations!

**Up next:** the final exam, then **Python Advanced**: generators, decorators, context managers, typing, testing, async and packaging.
