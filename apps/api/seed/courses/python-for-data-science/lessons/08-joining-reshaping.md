# Joining and reshaping

Real datasets rarely arrive as one tidy table. Customers live in one export, orders in another, monthly targets in a third. Before you can answer a question you often have to **join** tables on a shared key, then **reshape** between a long layout (one row per observation) and a wide layout (one column per category).

This lesson uses a customer table and an order table with a deliberate gap: one order belongs to a customer who is not in the customer export. That gap is the whole point.

## Join on a key

```python run
import pandas as pd

customers = pd.DataFrame({
    "customer_id": [1, 2, 3, 4],
    "name": ["Ana", "Ben", "Cara", "Dev"],
    "segment": ["Pro", "Free", "Pro", None],
})

orders = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E"],
    "customer_id": [1, 2, 1, 3, 5],
    "revenue": [120.0, 80.0, 200.0, 50.0, 90.0],
})

enriched = orders.merge(customers, on="customer_id", how="left")
enriched
```

A **left join** keeps every row on the left (all orders) and attaches matching customer columns. Order E has no customer 5, so `name` and `segment` become `NaN`. An **inner join** would silently drop E; a **right join** would keep every customer; an **outer join** keeps both sides.

> **Pitfall:** Check row counts before and after every join. A duplicated key on the right side multiplies rows, and an inner join can delete rows you needed. `merge(..., validate="many_to_one")` makes pandas raise if the right key is not unique.

## Diagnose a join with `indicator`

```python run
check = orders.merge(customers, on="customer_id", how="left", indicator=True)
print(check["_merge"].value_counts().to_dict())
print("orders with no customer:", check.loc[check["name"].isna(), "order_id"].tolist())
```

`_merge` labels each row as `both`, `left_only` or `right_only`. This is the fastest way to answer "how many rows failed to match?" without guessing from `NaN` values.

## Stack tables with `concat`

`merge` combines columns by key. `concat` stacks rows (or columns) by position. Use `ignore_index=True` when the original indices are meaningless.

```python run
jan = pd.DataFrame({"month": ["Jan", "Jan"], "revenue": [100.0, 200.0]})
feb = pd.DataFrame({"month": ["Feb", "Feb"], "revenue": [150.0, 250.0]})

combined = pd.concat([jan, feb], ignore_index=True)
combined
```

If the two tables have different columns, `concat` aligns them by name and fills the gaps with `NaN`. That is useful, but it is also how a typo in one export creates an accidental extra column.

## Reshape: long and wide

A **long** table has one row per region-month. A **wide** table has one row per region and one column per month. `pivot_table` goes long → wide; `melt` goes wide → long.

```python run
long = pd.DataFrame({
    "region": ["North", "North", "South", "South"],
    "month": ["Jan", "Feb", "Jan", "Feb"],
    "revenue": [60.0, 20.0, 30.0, 40.0],
})

wide = long.pivot_table(
    index="region",
    columns="month",
    values="revenue",
    aggfunc="sum",
    fill_value=0,
)
print(wide)

back_to_long = wide.reset_index().melt(
    id_vars="region",
    var_name="month",
    value_name="revenue",
)
back_to_long
```

`pivot_table` can aggregate when several rows share the same index/column pair. `pivot` is the stricter version and raises on duplicates. `melt` is the inverse: identifier columns stay, the remaining columns become two columns — one for the old column name, one for the value.

> **In the wild:** plotting libraries often prefer long data (one column for the category, one for the value). Wide data is convenient for reading a table and for some statistical models. Being able to move between them is a core skill.

## Your turn: keep every order

Left-join `customers` onto `orders`, then fill the missing `segment` with `"Unknown"`. Keep all five orders and all original order columns.

```python exercise id=enrich-orders title="Enrich orders without losing rows"
import pandas as pd

customers = pd.DataFrame({
    "customer_id": [1, 2, 3, 4],
    "name": ["Ana", "Ben", "Cara", "Dev"],
    "segment": ["Pro", "Free", "Pro", None],
})

orders = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E"],
    "customer_id": [1, 2, 1, 3, 5],
    "revenue": [120.0, 80.0, 200.0, 50.0, 90.0],
})

# TODO: left-join, then fill missing segments.
enriched = ...
--- solution
import pandas as pd

customers = pd.DataFrame({
    "customer_id": [1, 2, 3, 4],
    "name": ["Ana", "Ben", "Cara", "Dev"],
    "segment": ["Pro", "Free", "Pro", None],
})

orders = pd.DataFrame({
    "order_id": ["A", "B", "C", "D", "E"],
    "customer_id": [1, 2, 1, 3, 5],
    "revenue": [120.0, 80.0, 200.0, 50.0, 90.0],
})

enriched = orders.merge(customers, on="customer_id", how="left")
enriched["segment"] = enriched["segment"].fillna("Unknown")
--- test
assert enriched is not ..., "Replace the `...` after `enriched =`."
assert len(enriched) == 5, f"All five orders must survive the join, but `enriched` has {len(enriched)} rows. Which join keeps unmatched left rows?"
assert enriched["order_id"].tolist() == ["A", "B", "C", "D", "E"], f"Order rows should stay in order A–E, but are {enriched['order_id'].tolist()}."
assert enriched["segment"].tolist() == ["Pro", "Free", "Pro", "Pro", "Unknown"], f"Segments should be [Pro, Free, Pro, Pro, Unknown], but are {enriched['segment'].tolist()}."
assert enriched.loc[enriched["order_id"] == "E", "name"].isna().all(), "Order E has no matching customer; its name should remain missing."
assert enriched["revenue"].sum() == 540.0, "The join should not change or duplicate revenue."
--- hint
Use `how="left"` so every row from `orders` is retained.
--- hint
After the join, `enriched["segment"].fillna("Unknown")` replaces the missing segment. Assign it back to the column.
```

## Your turn: build the monthly matrix

Pivot `long` so each row is a region, each column is a month, and the values are summed revenue. Fill missing cells with 0.

```python exercise id=monthly-wide title="Long to wide"
import pandas as pd

long = pd.DataFrame({
    "region": ["North", "North", "South", "South", "North"],
    "month": ["Jan", "Feb", "Jan", "Feb", "Jan"],
    "revenue": [10.0, 20.0, 30.0, 40.0, 50.0],
})

# TODO: build a wide table indexed by region.
wide = ...
--- solution
import pandas as pd

long = pd.DataFrame({
    "region": ["North", "North", "South", "South", "North"],
    "month": ["Jan", "Feb", "Jan", "Feb", "Jan"],
    "revenue": [10.0, 20.0, 30.0, 40.0, 50.0],
})

wide = long.pivot_table(
    index="region",
    columns="month",
    values="revenue",
    aggfunc="sum",
    fill_value=0,
)
--- test
assert wide is not ..., "Replace the `...` after `wide =`."
assert wide.shape == (2, 2), f"`wide` should have 2 rows and 2 columns, but has shape {wide.shape}."
assert wide.index.tolist() == ["North", "South"], f"Rows should be regions, but the index is {wide.index.tolist()}."
assert set(wide.columns) == {"Jan", "Feb"}, f"Columns should be Jan and Feb, but are {list(wide.columns)}."
assert wide.loc["North", "Jan"] == 60.0, f"North January should be 60.0 (10 + 50), but is {wide.loc['North', 'Jan']!r}."
assert wide.loc["South", "Feb"] == 40.0, "South February should be 40.0."
--- hint
`pivot_table(index="region", columns="month", values="revenue", aggfunc="sum", fill_value=0)` does the whole job.
--- hint
The two North January rows must be added together, so use `aggfunc="sum"`, not `pivot`.
```

## The join that deleted a row

The brief is "every order, with the customer segment where we know it." This code runs, but the result has four rows instead of five. Find the order that disappeared and change the join so the missing customer stays visible.

```python debug id=inner-join title="The order that vanished"
import pandas as pd

customers = pd.DataFrame({
    "customer_id": [1, 2, 3],
    "segment": ["Pro", "Free", "Pro"],
})

orders = pd.DataFrame({
    "order_id": ["A", "B", "C", "D"],
    "customer_id": [1, 2, 3, 99],
    "revenue": [120.0, 80.0, 60.0, 40.0],
})

result = orders.merge(customers, on="customer_id", how="inner")
print(result)
--- solution
import pandas as pd

customers = pd.DataFrame({
    "customer_id": [1, 2, 3],
    "segment": ["Pro", "Free", "Pro"],
})

orders = pd.DataFrame({
    "order_id": ["A", "B", "C", "D"],
    "customer_id": [1, 2, 3, 99],
    "revenue": [120.0, 80.0, 60.0, 40.0],
})

result = orders.merge(customers, on="customer_id", how="left")
print(result)
--- test
assert len(result) == 4, f"All four orders should survive, but `result` has {len(result)} rows."
assert result["order_id"].tolist() == ["A", "B", "C", "D"], f"Order rows should be A–D, but are {result['order_id'].tolist()}."
assert result.loc[result["order_id"] == "D", "segment"].isna().all(), "Order D has no matching customer, so its segment should be missing."
assert result["revenue"].sum() == 300.0, "The join should not change the total revenue."
--- hint
Count the rows before and after. Which order has a customer_id that is absent from `customers`?
--- hint
An inner join keeps only matches. Use `how="left"` so every order is retained.
```

## Predict the inner join

```python predict id=predict-merge-rows title="How many matches?"
import pandas as pd

left = pd.DataFrame({"id": [1, 2], "x": ["a", "b"]})
right = pd.DataFrame({"id": [2, 3], "y": ["c", "d"]})

print(pd.merge(left, right, on="id", how="inner").shape[0])
--- options
0
* 1
2
3
--- explain
Only `id=2` appears on both sides. An inner join keeps matching keys only, so the result has one row. A left join would keep both left rows, with a missing `y` for id 1.
```

## Recap

- `merge` combines columns on a key; `how` decides which unmatched rows survive.
- Always compare row counts before and after a join, and use `indicator=True` to diagnose unmatched keys.
- `concat` stacks tables by position; align columns by name.
- `pivot_table` goes long → wide and can aggregate duplicates; `melt` goes wide → long.
- Inner joins delete unmatched rows. Left joins preserve the left table and expose gaps as `NaN`.

**Up next:** you'll make those gaps and patterns visible with charts, then run a complete exploratory analysis from raw CSV to written conclusions.
