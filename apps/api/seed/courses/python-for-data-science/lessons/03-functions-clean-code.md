An analysis you cannot repeat is not an analysis. Once a calculation lives in a function with a clear input and output, you can run it on next month's data, test it, and explain it to a colleague. This lesson shows what makes a function trustworthy in data work: clear inputs, return values instead of printing, and never changing the data you were given.

## Inputs, outputs and return values

A function takes arguments and gives back a result with `return`. A function that only prints cannot be reused, because its answer disappears.

```python run
def average_price(prices):
    """Return the mean of a list of prices, or None if there are none."""
    if not prices:
        return None
    return sum(prices) / len(prices)

print(average_price([2.0, 4.0, 9.0]))
print(average_price([]))
```

The docstring is the text in triple quotes. It tells the next reader what the function expects and returns. Write it for every function you share.

## Default arguments

A default value makes an argument optional. Keep defaults simple and never use a mutable object such as a list as one, for a reason you will see in the debug challenge.

```python run
def format_money(amount, currency="EUR", decimals=2):
    return f"{amount:,.{decimals}f} {currency}"

print(format_money(1234.5))
print(format_money(1234.5, currency="USD", decimals=0))
```

## Pure functions and the input you were given

A **pure** function returns a result and leaves its inputs alone. Impure functions change the data they were passed, so a caller can be surprised later. In analysis, surprises are expensive.

```python run
prices = [10.0, 25.0, 40.0]

def with_tax(values, rate):
    return [v * (1 + rate) for v in values]    # builds a new list

taxed = with_tax(prices, 0.2)
print("original:", prices)
print("taxed:   ", [round(v, 2) for v in taxed])
```

The original list is unchanged, and you can call the function as often as you like.

## Lambdas and sorting by a rule

A **lambda** is a small unnamed function, useful as a `key` for sorting. A named function is better when the logic is longer than one line.

```python run
products = [("kettle", 35.0), ("mug", 6.5), ("tea", 6.5), ("grinder", 80.0)]

by_price = sorted(products, key=lambda p: (p[1], p[0]))   # price, then name
for name, price in by_price:
    print(f"{name:<8} {price:>6.2f}")
```

## Challenge: parse messy prices

Exported data often stores prices as text, with currency symbols and missing entries. Your job is to turn that list into clean numbers, skipping the entries that cannot be read.

```python exercise id=clean-prices title="Parse messy price strings"
# TODO: `clean_prices(values)` takes a list of strings such as "$12.50", "7", " 3,5 " or "n/a".
# Return a list of floats for every value that can be read. Remove "$", spaces, and turn a
# decimal comma into a dot. Skip anything that cannot be read as a number, including "" and "n/a".
def clean_prices(values):
    ...
--- solution
def clean_prices(values):
    cleaned = []
    for raw in values:
        text = raw.replace("$", "").replace(" ", "").replace(",", ".")
        try:
            cleaned.append(float(text))
        except ValueError:
            continue
    return cleaned
--- test
result = clean_prices(["$12.50", "7", " 3,5 ", "n/a", ""])
assert result is not None, "Replace the `...` in `clean_prices` with code that returns the cleaned list."
assert result == [12.5, 7.0, 3.5], f"Expected [12.5, 7.0, 3.5], but you returned {result}."
assert clean_prices([]) == [], "An empty list should give an empty list."
assert clean_prices(["$1,000.00"]) == [], "This value has two decimal separators after the comma is changed to a dot, so it cannot be read as one number and should be skipped."
assert clean_prices(["$0.99", "$100"]) == [0.99, 100.0], "Dollar signs should be removed before converting."
--- hint
For each value, first remove the characters you do not want, then try `float(...)`. Catch the `ValueError` to skip values that are not numbers.
--- hint
Use `raw.replace("$", "")`, then the spaces, then the commas, and convert the result with `float` inside a `try` block.
```

## Challenge: summarize a column

```python exercise id=summarize-values title="Summarize a list of numbers"
# TODO: `summarize(values)` returns a dictionary with the keys "count", "mean", "min" and "max" for a non-empty
# list of numbers. For an empty list, return None.
def summarize(values):
    ...
--- solution
def summarize(values):
    if not values:
        return None
    return {"count": len(values), "mean": sum(values) / len(values), "min": min(values), "max": max(values)}
--- test
result = summarize([2.0, 4.0, 9.0])
assert result is not None, "Replace the `...` in `summarize` with code that returns the dictionary."
assert result == {"count": 3, "mean": 5.0, "min": 2.0, "max": 9.0}, f"For [2, 4, 9] the summary is count 3, mean 5, min 2, max 9, but you returned {result}."
assert summarize([]) is None, "An empty list has nothing to summarize, so return None."
--- hint
Use `len`, `sum`, `min` and `max` on the list. Divide the sum by the count for the mean.
--- hint
Check for an empty list first with `if not values: return None`.
```

## Debug the default that remembers

This function is meant to collect each analyst's notes into a fresh list, but the notes keep piling up across calls.

```python debug id=mutable-default title="Stop sharing one list between calls"
def add_note(note, notes=[]):
    notes.append(note)
    return notes

add_note("first call")
print(add_note("second call"))
--- solution
def add_note(note, notes=None):
    if notes is None:
        notes = []
    notes.append(note)
    return notes

add_note("first call")
print(add_note("second call"))
--- test
assert add_note("a") == ["a"], "A call with a new note should return a list containing just that note."
assert add_note("b") == ["b"], f"Each call without a list should start fresh, but the second call returned {add_note('b')}. Avoid a mutable default argument."
--- hint
Python creates a default list once, when the function is defined, so every call shares it.
--- hint
Use `None` as the default and create the list inside the function when it is `None`.
```

## Predict the result

```python predict id=predict-return title="What does the function return?"
def total(values):
    result = 0
    for v in values:
        result += v
    return result

print(total([1, 2, 3]) + total([4]))
--- options
* 10
6
4
7
--- explain
The first call sums 1, 2 and 3 to 6. The second sums 4 to 4. Adding the two results gives 10. Each call has its own `result` variable, so nothing carries over between calls.
```

## Recap

- Return values, do not print them, so results can be reused and tested.
- Write a docstring describing what goes in and comes out.
- Prefer pure functions that build new data rather than changing their inputs.
- Never use a mutable default argument. Use `None` and create the object inside the function.

**Up next:** NumPy arrays. They are the engine underneath pandas, and they make calculations over whole columns fast and short.
