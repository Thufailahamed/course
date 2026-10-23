Real exports are messy. A city is spelled "lyon", "Lyon " and "LYON". A price is text. The same order appears twice. A units cell is blank. Every analysis built on dirty data gives a confident answer that is wrong, so cleaning is not a chore before the real work. For most analysts it is most of the real work. This lesson shows the standard cleaning moves, in the order you usually need them.

```python run
import io
import pandas as pd

RAW = """order_id,city,units,price
1, Lyon ,4,6.50
2,lyon,2,6.50
2,lyon,2,6.50
3,PARIS,n/a,9.00
4,Paris,5,
5,Nice,3,9.50
"""
raw = pd.read_csv(io.StringIO(RAW), dtype=str)
raw
```

I read every column as text on purpose. That shows the real problems: spaces, mixed case, a duplicate row, a non-numeric entry and a blank price.

## Clean text: strip and standardize case

`str` methods work on whole columns. Strip spaces, then choose one standard case.

```python run
clean = raw.copy()
clean["city"] = clean["city"].str.strip().str.title()
print(clean["city"].tolist())
```

## Convert types: text to numbers

`pd.to_numeric` turns text into numbers. With `errors="coerce"`, values that cannot be read become missing (`NaN`) instead of raising an error, and you can count them.

```python run
clean["units"] = pd.to_numeric(clean["units"], errors="coerce")
clean["price"] = pd.to_numeric(clean["price"], errors="coerce")
print(clean[["units", "price"]])
print("missing units:", clean["units"].isna().sum())
print("missing prices:", clean["price"].isna().sum())
```

Always count what you converted to missing. A silent coercion can hide a whole category of errors.

## Remove duplicates

```python run
no_dupes = clean.drop_duplicates()
print("rows before:", len(clean), "after:", len(no_dupes))
```

`drop_duplicates` compares whole rows by default. To treat rows with the same key as duplicates, pass `subset=["order_id"]`, and decide which copy to keep with `keep="first"` or `keep="last"`.

## Handle gaps: drop or fill

```python run
print(no_dupes.dropna(subset=["price"]))
```

Dropping rows removes information. Filling is a decision too. Fill with a justified value, and never with zero for a quantity or price, because zero is a real value that drags averages down:

```python run
median_price = no_dupes["price"].median()
filled = no_dupes.assign(price=no_dupes["price"].fillna(median_price))
print(filled["price"].tolist())
```

> **Pitfall:** `fillna(0)` is the most common cleaning mistake. It invents sales of zero where the data is simply unknown.

## Check the result

After cleaning, check it the way you checked the raw data: shape, types, missing values and the distinct categories.

```python run
print(no_dupes.dtypes)
print(no_dupes["city"].value_counts())
```

## Challenge: clean the orders

```python exercise id=clean-orders title="Clean a raw order table"
import pandas as pd

# TODO: `clean_orders(df)` takes a table with columns order_id, city, units and price, all read as text.
# Return a cleaned copy: strip spaces and use title case for city; convert units and price to numbers
# (unreadable values become NaN); drop exact duplicate rows; and drop rows where price is missing.
# Keep the rows in their original order, with a fresh 0-based index.
def clean_orders(df):
    ...
--- solution
import pandas as pd

def clean_orders(df):
    out = df.copy()
    out["city"] = out["city"].str.strip().str.title()
    out["units"] = pd.to_numeric(out["units"], errors="coerce")
    out["price"] = pd.to_numeric(out["price"], errors="coerce")
    out = out.drop_duplicates()
    out = out.dropna(subset=["price"])
    return out.reset_index(drop=True)
--- test
import pandas as pd
raw = pd.DataFrame({
    "order_id": ["1", "1", "2", "3"],
    "city": [" lyon ", " lyon ", "PARIS", "nice"],
    "units": ["4", "4", "n/a", "3"],
    "price": ["6.5", "6.5", "9", ""],
})
result = clean_orders(raw)
assert result is not None, "Replace the `...` in `clean_orders` with code that returns the cleaned table."
assert list(result["city"]) == ["Lyon", "Paris"], f"Expected the cities Lyon and Paris after cleaning, but got {list(result['city'])}. Strip spaces, then use title case, and drop the row with no price."
assert len(result) == 2, "The duplicate Lyon row should be removed, and the Nice row has no price, so two rows remain."
assert result["price"].tolist() == [6.5, 9.0], "Prices should be numbers."
assert result["units"].isna().tolist() == [False, True], "The unreadable units 'n/a' should become NaN, not be dropped or set to 0."
assert list(result.index) == [0, 1], "Use a fresh 0-based index."
--- hint
Clean each column in order: text first, then numbers with `pd.to_numeric(..., errors="coerce")`, then `drop_duplicates()`, then `dropna(subset=["price"])`.
--- hint
After dropping rows, call `reset_index(drop=True)` so the index starts at 0 again.
```

## Challenge: count unreadable values

```python exercise id=count-unreadable title="Count values that cannot be read as numbers"
import pandas as pd

# TODO: `count_unreadable(values)` takes a Series of text values. Return how many of them cannot be read as
# numbers, after stripping spaces. Empty text counts as unreadable too.
def count_unreadable(values):
    ...
--- solution
import pandas as pd

def count_unreadable(values):
    cleaned = values.str.strip()
    numbers = pd.to_numeric(cleaned.where(cleaned != "", None), errors="coerce")
    return int(numbers.isna().sum())
--- test
import pandas as pd
result = count_unreadable(pd.Series(["4", " 2.5 ", "n/a", "", "7"]))
assert result is not None, "Replace the `...` in `count_unreadable` with code that returns the count."
assert result == 2, f"'n/a' and the empty text cannot be read as numbers, so the count is 2, but you returned {result!r}."
assert count_unreadable(pd.Series(["1", "2"])) == 0, "All readable values give a count of 0."
--- hint
Convert with `pd.to_numeric(..., errors="coerce")`, which makes unreadable values missing. Then count the missing values.
--- hint
Strip the spaces first, then `pd.to_numeric(values.str.strip(), errors="coerce").isna().sum()`. Treat empty text as missing too.
```

## Debug the text comparison

This code is meant to count Lyon orders, but it finds only some of them.

```python debug id=strip-spaces title="Clean before you compare"
import pandas as pd

cities = pd.Series([" Lyon", "Lyon ", "Lyon", "Paris"])
lyon_count = (cities == "Lyon").sum()        # bug: spaces are part of the text
print("Lyon orders:", lyon_count)
--- solution
import pandas as pd

cities = pd.Series([" Lyon", "Lyon ", "Lyon", "Paris"])
lyon_count = (cities.str.strip() == "Lyon").sum()
print("Lyon orders:", lyon_count)
--- test
assert lyon_count == 3, f"After stripping spaces, three rows are Lyon, but lyon_count is {lyon_count}. Clean the text before comparing it."
--- hint
" Lyon" and "Lyon" are different strings to Python, even though a person sees the same city.
--- hint
Compare `cities.str.strip()` with "Lyon" instead of `cities` itself.
```

## Predict the count

```python predict id=predict-clean title="How many rows remain?"
import pandas as pd
df = pd.DataFrame({"a": [1, 1, 2, None]})
print(len(df.drop_duplicates().dropna()))
--- options
* 2
3
1
4
--- explain
The rows are 1, 1, 2 and missing. Removing the duplicate 1 leaves 1, 2 and missing. Dropping the missing row leaves 1 and 2, so two rows remain.
```

## Recap

- Clean text first: strip spaces and standardize case, so equal values compare equal.
- Convert types with `pd.to_numeric(..., errors="coerce")`, and count what became missing.
- Remove duplicates deliberately, and decide what counts as the same record.
- Fill gaps only with a justified value. Never default to zero.

**Up next:** grouping and aggregation. Once your data is clean, this is how you turn thousands of rows into a few answers.
