Before you can analyze a table, you need to handle the raw records it came from. In Python those are usually lists of dictionaries, one per row, and the core skills are the same ones you use with pandas later: picking values out, counting, sorting and transforming. This lesson builds those habits with the built-in containers and comprehensions.

## Lists, dictionaries and sets

A **list** keeps items in order. A **dictionary** maps keys to values, which suits one record with named fields. A **set** keeps only unique items.

```python run
orders = [
    {"customer": "Ana", "city": "Lyon", "amount": 42.0},
    {"customer": "Ben", "city": "Paris", "amount": 17.5},
    {"customer": "Ana", "city": "Lyon", "amount": 8.0},
    {"customer": "Cam", "city": "Nice", "amount": 30.0},
]

print("first order:", orders[0])
print("number of orders:", len(orders))
print("distinct cities:", {order["city"] for order in orders})
```

Notice that the set of cities has no duplicates and no order. Use a set when you only care about membership.

## Counting with a dictionary

Counting how often each value occurs is one of the most common data tasks. The pattern is a dictionary that starts empty and grows as you read each record.

```python run
counts = {}
for order in orders:
    city = order["city"]
    counts[city] = counts.get(city, 0) + 1

print(counts)
```

`counts.get(city, 0)` returns the current count, or zero for a city not yet seen. pandas will do this in one line later, but understanding the loop tells you what it is doing.

## Comprehensions: transform in one line

A **list comprehension** builds a new list from an old one. Read it as "for each item, keep this expression, optionally filtered by this condition".

```python run
big_orders = [o["amount"] for o in orders if o["amount"] >= 20]
print("large order amounts:", big_orders)

upper_customers = sorted({o["customer"].upper() for o in orders})
print("customers, shouted:", upper_customers)
```

A **dictionary comprehension** works the same way and is handy for lookups:

```python run
total_by_customer = {}
for o in orders:
    total_by_customer[o["customer"]] = total_by_customer.get(o["customer"], 0) + o["amount"]
print(total_by_customer)
```

## Sorting records

`sorted` returns a new list, and the `key` argument says what to compare. Pass `reverse=True` for descending order.

```python run
by_amount = sorted(orders, key=lambda o: o["amount"], reverse=True)
for o in by_amount:
    print(f"{o['customer']:<4} {o['amount']:>6.2f}")
```

## Challenge: the busiest city

```python exercise id=busiest-city title="Find the city with the most orders"
# TODO: `busiest_city(orders)` takes a list of order dictionaries (each has a "city" key)
# and returns the city that appears most often. If two cities tie, return the one that comes
# first alphabetically.
def busiest_city(orders):
    ...
--- solution
def busiest_city(orders):
    counts = {}
    for order in orders:
        counts[order["city"]] = counts.get(order["city"], 0) + 1
    return sorted(counts, key=lambda city: (-counts[city], city))[0]
--- test
sample = [{"city": "Lyon"}, {"city": "Paris"}, {"city": "Lyon"}]
result = busiest_city(sample)
assert result is not None, "Replace the `...` in `busiest_city` with code that returns a city name."
assert result == "Lyon", f"Lyon has two orders and Paris has one, so the answer is Lyon, but you returned {result!r}."
tie = [{"city": "Nice"}, {"city": "Brest"}]
assert busiest_city(tie) == "Brest", "On a tie, return the alphabetically first city."
big = [{"city": c} for c in ["Oslo"] * 3 + ["Rome"] * 5 + ["Bern"] * 5]
assert busiest_city(big) == "Bern", "Rome and Bern tie at five, and Bern comes first alphabetically."
--- hint
Count the cities first, as in the counting example above. Then choose the best city, with ties broken alphabetically.
--- hint
`sorted(counts, key=lambda city: (-counts[city], city))[0]` sorts by highest count first, then by name, and takes the first.
```

## Challenge: total spent per customer

```python exercise id=spend-per-customer title="Total spend for each customer"
# TODO: `spend_by_customer(orders)` takes a list of order dictionaries with "customer" and "amount" keys.
# Return a dictionary mapping each customer to the sum of their amounts.
def spend_by_customer(orders):
    ...
--- solution
def spend_by_customer(orders):
    totals = {}
    for o in orders:
        totals[o["customer"]] = totals.get(o["customer"], 0) + o["amount"]
    return totals
--- test
sample = [{"customer": "Ana", "amount": 10.0}, {"customer": "Ben", "amount": 4.0}, {"customer": "Ana", "amount": 2.5}]
result = spend_by_customer(sample)
assert result is not None, "Replace the `...` in `spend_by_customer` with code that returns the dictionary."
assert result == {"Ana": 12.5, "Ben": 4.0}, f"Ana spent 10 + 2.5 = 12.5 and Ben spent 4, but you returned {result}."
assert spend_by_customer([]) == {}, "No orders should give an empty dictionary."
--- hint
Start from an empty dictionary and add each order's amount to its customer's running total, using `get` with a default of 0.
--- hint
`totals[o["customer"]] = totals.get(o["customer"], 0) + o["amount"]` inside a loop.
```

## Debug the shared list

This code tries to build a 3 × 3 grid of zeros, but changing one cell changes a whole column.

```python debug id=shared-rows title="Build independent rows"
grid = [[0] * 3] * 3          # every row is the same list object
grid[0][1] = 9
print(grid)
--- solution
grid = [[0] * 3 for _ in range(3)]    # a new list for each row
grid[0][1] = 9
print(grid)
--- test
assert grid == [[0, 9, 0], [0, 0, 0], [0, 0, 0]], f"Only the first row should change, but the grid is {grid}. Build each row as its own list."
--- hint
`[[0] * 3] * 3` repeats one list reference three times. Changing one row changes all of them.
--- hint
Use a comprehension so that each row is created fresh: `[[0] * 3 for _ in range(3)]`.
```

## Predict the output

```python predict id=predict-counts title="What does the dictionary contain?"
words = ["a", "b", "a", "c", "a"]
counts = {}
for w in words:
    counts[w] = counts.get(w, 0) + 1
print(counts["a"])
--- options
* 3
2
1
5
--- explain
The letter a appears three times in the list, and each occurrence adds one to its count. The `get` with a default of 0 means the first occurrence starts from zero.
```

## Recap

- Lists keep order, dictionaries map keys to values, and sets keep unique items.
- Counting with `get(key, 0) + 1` is the pattern behind every group-by.
- Comprehensions transform and filter collections in one readable expression.
- `sorted` takes a `key` to decide what to compare, and returns a new list.

**Up next:** functions. Turning these loops into named, tested functions is what makes an analysis repeatable.
