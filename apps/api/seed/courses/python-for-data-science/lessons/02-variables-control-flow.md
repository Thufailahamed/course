# Variables, types and control flow

Every pandas column is a sequence of values of one type, and almost every cleaning rule is a condition: *if the quantity is missing, set it to zero; if the customer is a member, waive shipping; if the price is a string, convert it.* Before you can manipulate a table, you need to be fluent with the single values inside it.

This lesson uses a small orders workflow to cover the Python you will use constantly: variables, numbers, strings, booleans, `None`, `if`/`elif`/`else`, and loops that accumulate a result.

## Names for values

A variable is a name bound to a value. Python infers the type from the value; you don't declare it.

```python run
order_id = "ORD-1042"
units = 3
unit_price = 24.99
gift = False
note = None

subtotal = units * unit_price

print(type(order_id).__name__, type(units).__name__, type(unit_price).__name__)
print(f"Order {order_id}: {units} x ${unit_price:.2f} = ${subtotal:.2f}")
print("gift:", gift, "| note:", note)
```

The `f` before the string makes it an **f-string**: anything inside braces is evaluated, and `:.2f` formats a number with two decimal places. `None` is Python's "no value here" — not zero, not an empty string. It is how a missing cell often arrives from a database.

> **Pitfall:** `unit_price = "24.99"` looks almost identical but is text. `units * unit_price` would then repeat the *string* three times instead of multiplying numbers. `type()` is your cheapest diagnostic.

## Strings are data too

Real text arrives with stray spaces and inconsistent capitalisation. String methods return a **new** string; they do not modify the original.

```python run
raw_city = "  lisbon "
city = raw_city.strip().title()

raw_email = "  ADA@Example.COM "
email = raw_email.strip().lower()

print(f"city={city!r}  email={email!r}")
print("starts with Lis:", city.startswith("Lis"))
print("has @:", "@" in email)
```

`strip()` removes whitespace from both ends, `title()` capitalises each word, and `lower()` normalises case. The `!r` in the f-string shows quotes around the value, which makes invisible spaces obvious.

## Decisions

Conditions produce booleans. `if` runs a block only when its condition is true; `elif` and `else` handle the alternatives. Python uses indentation, not braces, to define blocks.

```python run
order_total = 82.50
country = "Portugal"
member = False

if member or order_total >= 75:
    shipping = 0.0
elif order_total >= 50:
    shipping = 4.95
else:
    shipping = 9.95

print(f"shipping: ${shipping:.2f}")
print(f"order total: ${order_total + shipping:.2f}")
```

Read the first condition as "a member, **or** a basket of at least 75". `or` short-circuits: if `member` is true, Python never evaluates the second half. Use `and` when both conditions must hold.

> **Pitfall:** `=` assigns; `==` compares. `if total = 100` is a syntax error, and `if total == "100"` compares a number to a string — they are never equal.

## Loops that accumulate

A `for` loop walks through an iterable. When each item is a tuple, you can unpack it into named variables. This is the pattern behind many calculations that later become a single pandas expression.

```python run
orders = [
    ("A-1", 2, 19.99),
    ("A-2", 1, 5.50),
    ("A-3", 4, 3.25),
]

total = 0
for order_id, quantity, price in orders:
    line_total = quantity * price
    total += line_total
    print(f"{order_id}: ${line_total:.2f}")

print(f"TOTAL: ${total:.2f}")
```

`total += line_total` is shorthand for `total = total + line_total`. The accumulator must start at `0`; starting at `1` silently adds a phantom dollar.

## Your turn: a receipt

The quantity arrives as text from a form. Convert it, calculate the subtotal, apply a percentage discount, and store the final total in `total`.

```python exercise id=receipt-total title="Clean a receipt"
raw_units = "3"
unit_price = 24.99
discount_pct = 10

# TODO: convert raw_units to an int and compute the three amounts.
units = ...
subtotal = ...
discount = ...
total = ...
--- solution
raw_units = "3"
unit_price = 24.99
discount_pct = 10

units = int(raw_units)
subtotal = units * unit_price
discount = subtotal * discount_pct / 100
total = subtotal - discount
--- test
assert units is not ..., "Replace the `...` after `units =`."
assert isinstance(units, int), f"`units` should be an int, but it is {type(units).__name__}. Convert the string with int()."
assert units == 3, f"`units` should be 3, but it is {units!r}."
assert abs(subtotal - 74.97) < 1e-9, f"`subtotal` should be 74.97, but it is {subtotal!r}."
assert abs(discount - 7.497) < 1e-9, f"`discount` should be 7.497 (10% of 74.97), but it is {discount!r}."
assert abs(total - 67.473) < 1e-9, f"`total` should be 67.473, but it is {total!r}. Subtract the discount from the subtotal."
--- hint
`int("3")` gives the number 3. `"3" * 24.99` would be a very different (and very wrong) operation.
--- hint
`subtotal = units * unit_price`. A percentage is divided by 100: `discount = subtotal * discount_pct / 100`.
```

## Accumulate the order book

Finish the loop so each line total is multiplied out and added to `total`. The printed lines should be `39.98`, `5.50`, `13.00`, then `TOTAL: 58.48`.

```python exercise id=order-book-total title="Total the order book"
orders = [
    ("A-1", 2, 19.99),
    ("A-2", 1, 5.50),
    ("A-3", 4, 3.25),
]

total = 0
for order_id, quantity, price in orders:
    line_total = ...
    total += ...
    print(f"{order_id}: ${line_total:.2f}")

print(f"TOTAL: ${total:.2f}")
--- solution
orders = [
    ("A-1", 2, 19.99),
    ("A-2", 1, 5.50),
    ("A-3", 4, 3.25),
]

total = 0
for order_id, quantity, price in orders:
    line_total = quantity * price
    total += line_total
    print(f"{order_id}: ${line_total:.2f}")

print(f"TOTAL: ${total:.2f}")
--- test
assert abs(total - 58.48) < 1e-9, f"`total` should be 58.48, but it is {total!r}. Did you add the line total, not the price?"
assert "TOTAL: $58.48" in _stdout, f"The final line should read `TOTAL: $58.48`. Output was:\n{_stdout.strip()}"
assert "A-2: $5.50" in _stdout, "The second line should be `A-2: $5.50`; print the calculated line total, not the unit price."
--- hint
Inside the loop, `line_total` should be `quantity * price`, and `total` should grow by `line_total` each time.
--- hint
Start `total` at `0` before the loop, then use `total += line_total` in the body.
```

## A membership rule that is almost right

This shipping rule runs, but it charges a member. Read the condition carefully, then fix the boolean logic. The intended rule is: **free if the customer is a member or the subtotal is at least 75**.

```python debug id=member-shipping title="The member paid for shipping"
subtotal = 61.00
member = True

if subtotal >= 75 and member:
    shipping = 0.0
else:
    shipping = 4.95

print(f"shipping: ${shipping:.2f}")
--- solution
subtotal = 61.00
member = True

if subtotal >= 75 or member:
    shipping = 0.0
else:
    shipping = 4.95

print(f"shipping: ${shipping:.2f}")
--- test
assert shipping == 0.0, f"`shipping` should be 0.0 because the customer is a member, but it is {shipping!r}."
assert "shipping: $0.00" in _stdout, f"The printed result should be `shipping: $0.00`, but the output was {_stdout.strip()!r}."
--- hint
A member should get free shipping even when the subtotal is below 75. Which operator should connect the two conditions?
--- hint
Use `or`: free if `subtotal >= 75` **or** `member` is true.
```

## Predict the arithmetic

```python predict id=predict-operators title="Integer vs float arithmetic"
print(2 ** 3, 9 // 2, 9 % 2)
--- options
6 4.5 1
* 8 4 1
8 4.5 1
9 4 2
--- explain
`**` is exponentiation (2³ = 8), `//` is floor division (9 ÷ 2 = 4.5, rounded down to 4), and `%` is the remainder (9 − 8 = 1). Use `/` when you want the decimal result.
```

## Recap

- Variables are names bound to values; `type()` reveals what kind of value you actually have.
- Strings have methods (`strip`, `lower`, `title`) and support membership tests like `"@" in email`.
- `if`/`elif`/`else` choose a path. Use `or` when either condition is enough, `and` when both must hold.
- A loop plus an accumulator (`total += ...`) computes a result across many rows.
- `None` means missing, not zero; converting text to numbers is a deliberate step, not something Python guesses.

**Up next:** you'll package these rules into reusable functions and replace loop boilerplate with comprehensions.
