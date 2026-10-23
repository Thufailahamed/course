# Functions and comprehensions

Data work is full of rules you apply more than once: clean an email, apply a discount, split a name, format a price. Pasting the same five lines into ten cells is how notebooks rot. A **function** gives a rule a name, a clear input, and a return value. A **comprehension** expresses a whole transformation in one readable line.

By the end of this lesson you'll package a pricing rule into a function, clean a list of email addresses, and recognise the difference between printing a result and returning it.

## A function is a named rule

```python run
def revenue(quantity, unit_price, discount_pct=0.0):
    """Return revenue after an optional percentage discount."""
    subtotal = quantity * unit_price
    return round(subtotal * (1 - discount_pct / 100), 2)


print(revenue(2, 19.99))
print(revenue(2, 19.99, 10))
print(revenue(quantity=5, unit_price=3.25, discount_pct=25))
```

The `def` line names the function and its **parameters**. `discount_pct=0.0` is a default, so callers can omit it. `return` sends a value back to the caller; without it, a function returns `None`.

Arguments can be passed by position or by name. Keyword arguments make a call self-documenting, especially when two numbers could easily be swapped.

> **Tip:** Keep functions small and give them one job. `revenue` calculates money; it does not print, save a file or update a dashboard. Pure functions are easy to test and reuse.

## Return more than one value

Python functions can return a tuple, which unpacks neatly:

```python run
def split_name(full_name):
    parts = full_name.strip().split(maxsplit=1)
    if len(parts) != 2:
        return parts[0], ""
    first, last = parts
    return first, last


first, last = split_name("  Ada Lovelace ")
print(f"{last}, {first}")
print(split_name("Prince"))
```

`maxsplit=1` means "split at most once", so a surname containing a space stays intact. Notice the early return for a single-word name: a good function handles the awkward input, not just the happy path.

## Comprehensions: a loop with a return value

A list comprehension builds a new list from an iterable. The expression before `for` is what goes into the result; the optional `if` filters items out.

```python run
raw_prices = ["$12.50", "$8.00", "n/a", "$5.25"]

prices = [float(value.replace("$", "")) for value in raw_prices if value.startswith("$")]

print(prices)
print("total:", sum(prices))
```

Read it left to right: *take each value, keep the ones that start with `$`, strip the dollar sign, convert to a float.* The original `raw_prices` is untouched.

A **dictionary comprehension** builds a lookup table. This is the shape of many joins and mappings you'll meet in pandas.

```python run
products = [("A-1", 19.99), ("A-2", 5.50), ("A-3", 3.25)]

price_lookup = {sku: price for sku, price in products}
print(price_lookup)
print("most expensive:", max(price_lookup, key=price_lookup.get))
```

When the logic gets longer than one line, a normal `for` loop is usually clearer. Comprehensions are a tool, not a competition.

> **Pitfall:** A comprehension has its own scope in Python 3. The variable `value` does not leak into the surrounding code. If you need the count as well as the list, compute it separately or use a loop.

## Sorting with a key

`sorted` can sort anything if you tell it *what to compare*. A `lambda` is a tiny anonymous function, useful for exactly this.

```python run
rows = [("A-3", 13.00), ("A-1", 39.98), ("A-2", 5.50)]

by_value = sorted(rows, key=lambda row: row[1], reverse=True)
print(by_value)
```

`key=lambda row: row[1]` says "for each row, use the second element as the sort key." Without it, Python would compare the SKU strings first.

## Your turn: a reusable discount

Write `apply_discount(price, pct=10)` so it returns the price after removing `pct` percent, rounded to two decimals. The default must be 10.

```python exercise id=function-discount title="Write a reusable pricing rule"
def apply_discount(price, pct=10):
    # TODO: return the discounted price, rounded to 2 decimal places
    return ...


print(apply_discount(100, 20))
--- solution
def apply_discount(price, pct=10):
    return round(price * (1 - pct / 100), 2)


print(apply_discount(100, 20))
--- test
assert apply_discount(100, 20) == 80.0, f"apply_discount(100, 20) should be 80.0, but it returned {apply_discount(100, 20)!r}."
assert apply_discount(19.99) == 17.99, f"The default discount should be 10%: 19.99 becomes 17.99, but the function returned {apply_discount(19.99)!r}."
assert apply_discount(50, 0) == 50.0, "A 0% discount should leave the price unchanged."
assert apply_discount(50, 100) == 0.0, "A 100% discount should return 0.0."
assert isinstance(apply_discount(10), (int, float)), "Return a number, not a formatted string."
--- hint
A discount of `pct` percent leaves `(100 - pct) / 100` of the price. You can write that as `price * (1 - pct / 100)`.
--- hint
Wrap the calculation in `round(..., 2)` and put it after `return`.
```

## Your turn: clean a list of emails

Write `clean_emails(raw)` that strips whitespace, lowercases each address, keeps only entries containing `@`, removes duplicates, and returns the result sorted alphabetically. It must work for any input list, not just the sample.

```python exercise id=comprehension-emails title="Clean a list of emails"
def clean_emails(raw):
    # TODO: strip, lowercase, filter invalid entries, deduplicate, sort
    return ...


sample = ["  ADA@Example.com ", "ben@example.com", "not-an-email", " CHLOE@EXAMPLE.COM "]
print(clean_emails(sample))
--- solution
def clean_emails(raw):
    return sorted({email.strip().lower() for email in raw if email and "@" in email})


sample = ["  ADA@Example.com ", "ben@example.com", "not-an-email", " CHLOE@EXAMPLE.COM "]
print(clean_emails(sample))
--- test
assert clean_emails([" A@B.COM ", "bad", "a@b.com"]) == ["a@b.com"], "The function should lowercase, strip, filter entries without @, and remove duplicates."
assert clean_emails(["z@x.com", " a@b.com "]) == ["a@b.com", "z@x.com"], "The result should be sorted alphabetically."
assert clean_emails([]) == [], "An empty input should produce an empty list."
assert clean_emails(["no-at-sign", " also-bad "]) == [], "Entries without @ should be dropped."
--- hint
Use a set comprehension to remove duplicates while transforming: `{email.strip().lower() for email in raw if ...}`.
--- hint
Wrap the set in `sorted(...)`, and guard against empty or `None` entries with `if email and "@" in email`.
```

## The function that forgot to return

This function calculates the right number but the caller receives `None`, so the final `print` crashes. Run it, read the error, then fix the function. The calculation itself is correct.

```python debug id=missing-return title="The missing return"
def order_total(quantity, unit_price):
    subtotal = quantity * unit_price
    print(f"{subtotal:.2f}")


total = order_total(2, 19.99)
print(total + 1)
--- solution
def order_total(quantity, unit_price):
    subtotal = quantity * unit_price
    return subtotal


total = order_total(2, 19.99)
print(total + 1)
--- test
assert order_total(2, 19.99) == 39.98, f"order_total(2, 19.99) should return 39.98, but it returned {order_total(2, 19.99)!r}."
assert order_total(3, 5.50) == 16.5, f"order_total(3, 5.50) should return 16.5, but it returned {order_total(3, 5.50)!r}."
assert isinstance(order_total(1, 1), (int, float)), "Return the number, not a printed string."
--- hint
Run it. The error says you are adding `None` and `1`. Which function returned `None`?
--- hint
Replace the `print` inside the function with `return`. Keep the calculation.
```

## Predict the comprehension

```python predict id=predict-comprehension title="What survives the filter?"
print([x * 2 for x in range(5) if x % 2 == 1])
--- options
[0, 2, 4, 6, 8]
* [2, 6]
[1, 3]
[2, 4, 6, 8]
--- explain
`range(5)` is 0, 1, 2, 3, 4. The `if` keeps the odd values (1 and 3), and the expression doubles each one: 2 and 6. The filter runs before the expression.
```

## Recap

- `def` names a reusable rule; parameters are inputs and `return` is the output. A function without `return` gives back `None`.
- Defaults make optional behaviour explicit: `discount_pct=0.0`.
- List, set and dict comprehensions transform and filter in one expression; use a loop when the logic needs room.
- `sorted(..., key=lambda row: ...)` sorts by a computed key instead of the raw item.
- Returning a value is not the same as printing it. Tests call your function and inspect the return value.

**Up next:** you'll leave single values behind and start thinking in arrays, where the same operation runs across thousands of rows at once.
