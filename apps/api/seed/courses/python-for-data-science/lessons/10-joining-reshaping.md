Real data lives in several tables: orders in one, customers in another, regional targets in a third. Joining them is how you bring the facts together, and reshaping is how you turn a long table into the wide one a person can read. Both are easy to get subtly wrong, and the subtle mistakes are the ones that change answers. This lesson covers the join types, how to check a join's result, and the main reshaping tools.

```python run
import io
import pandas as pd

ORDERS = """order_id,city,units
1,Lyon,4
2,Paris,2
3,Nice,5
4,Lyon,1
5,Brest,3
"""
REGIONS = """city,region
Lyon,Auvergne
Paris,Ile-de-France
Nice,Provence
"""
orders = pd.read_csv(io.StringIO(ORDERS))
regions = pd.read_csv(io.StringIO(REGIONS))
orders
```

## Join types

`merge` joins two tables on a shared column. The `how` argument decides which rows to keep.

```python run
left = orders.merge(regions, on="city", how="left")
print(left)
```

A **left** join keeps every order, even Brest, which has no region in the lookup table, so its region is missing. An **inner** join would silently drop it:

```python run
inner = orders.merge(regions, on="city", how="inner")
print("left rows:", len(left), "| inner rows:", len(inner))
```

Choose the join by asking what you must not lose. Here, losing an order would understate revenue, so the left join is the safe choice.

## Check the join

Two checks catch most join mistakes: did the row count change, and did the key match one-to-one as you expected? `validate` makes pandas enforce the second one.

```python run
checked = orders.merge(regions, on="city", how="left", validate="many_to_one")
print("rows before:", len(orders), "| after:", len(checked))
```

If the lookup table had two rows for Lyon, every Lyon order would be duplicated, and the totals would be inflated. `validate="many_to_one"` raises an error in that case, which is what you want.

## Stack tables: concat

```python run
january = pd.DataFrame({"city": ["Lyon"], "units": [4]})
february = pd.DataFrame({"city": ["Paris"], "units": [7]})
combined = pd.concat([january, february], ignore_index=True)
print(combined)
```

`concat` stacks rows when the tables have the same columns, which is how monthly exports are usually combined.

## Reshape: long to wide

A **pivot table** turns a long table, one row per fact, into a grid with one row per category and one column per other category.

```python run
long_table = pd.DataFrame({
    "city": ["Lyon", "Lyon", "Paris", "Paris"],
    "product": ["Tea", "Coffee", "Tea", "Coffee"],
    "units": [4, 1, 5, 2],
})
wide = long_table.pivot_table(index="city", columns="product", values="units", aggfunc="sum", fill_value=0)
print(wide)
```

`melt` does the opposite, turning the wide grid back into a long table, which is what most plotting and modelling tools expect:

```python run
print(wide.reset_index().melt(id_vars="city", var_name="product", value_name="units"))
```

## Challenge: attach regions

```python exercise id=attach-regions title="Attach a region to every order"
import pandas as pd

# TODO: `attach_regions(orders, regions)` returns the orders table with a "region" column added from the
# regions table, matched on "city". Keep every order, even when it has no region (leave that region missing).
# Raise an error if the regions table has more than one row for the same city.
def attach_regions(orders, regions):
    ...
--- solution
import pandas as pd

def attach_regions(orders, regions):
    return orders.merge(regions, on="city", how="left", validate="many_to_one")
--- test
import pandas as pd
orders = pd.DataFrame({"city": ["Lyon", "Brest", "Lyon"], "units": [1, 2, 3]})
regions = pd.DataFrame({"city": ["Lyon"], "region": ["Auvergne"]})
result = attach_regions(orders, regions)
assert result is not None, "Replace the `...` in `attach_regions` with code that returns the joined table."
assert len(result) == 3, f"All three orders should be kept, but the result has {len(result)} rows."
assert result["region"].tolist()[0] == "Auvergne" and pd.isna(result["region"].tolist()[1]), "Lyon should get its region and Brest should keep a missing region."
dupes = pd.DataFrame({"city": ["Lyon", "Lyon"], "region": ["A", "B"]})
try:
    attach_regions(orders, dupes)
    raised = False
except Exception:
    raised = True
assert raised, "If the regions table has two rows for one city, the join should raise an error instead of duplicating orders."
--- hint
Use `merge` with `how="left"` so no order is lost, and pass `validate="many_to_one"` to guard against duplicate city rows.
--- hint
`return orders.merge(regions, on="city", how="left", validate="many_to_one")`.
```

## Challenge: orders per region

```python exercise id=orders-per-region title="Count orders per region"
import pandas as pd

# TODO: `orders_per_region(orders, regions)` left-joins orders with regions on "city". Orders with no matching
# region count as "Unknown". Return a Series with the number of orders per region, sorted from most to fewest.
def orders_per_region(orders, regions):
    ...
--- solution
import pandas as pd

def orders_per_region(orders, regions):
    joined = orders.merge(regions, on="city", how="left", validate="many_to_one")
    joined["region"] = joined["region"].fillna("Unknown")
    return joined["region"].value_counts()
--- test
import pandas as pd
orders = pd.DataFrame({"city": ["Lyon", "Brest", "Lyon", "Paris"]})
regions = pd.DataFrame({"city": ["Lyon", "Paris"], "region": ["Auvergne", "Ile-de-France"]})
result = orders_per_region(orders, regions)
assert result is not None, "Replace the `...` in `orders_per_region` with code that returns the counts."
assert result["Auvergne"] == 2, "Two orders are from Lyon, so Auvergne has 2."
assert result["Unknown"] == 1, "Brest has no region, so one order should be counted as Unknown."
assert result.index[0] == "Auvergne", "The region with the most orders should come first."
assert result.sum() == len(orders), "Every order should be counted exactly once."
--- hint
Left-join so no order is lost, fill the missing regions with "Unknown", and count with `value_counts()`.
--- hint
`joined["region"].fillna("Unknown")` before `value_counts()`.
```

## Debug the duplicated orders

This code is meant to attach regions to the orders, but the order count grows.

```python debug id=duplicate-join title="Stop the join from duplicating orders"
import pandas as pd

orders = pd.DataFrame({"city": ["Lyon", "Paris"], "units": [4, 2]})
regions = pd.DataFrame({"city": ["Lyon", "Lyon", "Paris"], "region": ["Auvergne", "Rhone", "Ile-de-France"]})
joined = orders.merge(regions, on="city", how="left")     # bug: Lyon appears twice in regions
print(len(orders), "->", len(joined))
--- solution
import pandas as pd

orders = pd.DataFrame({"city": ["Lyon", "Paris"], "units": [4, 2]})
regions = pd.DataFrame({"city": ["Lyon", "Lyon", "Paris"], "region": ["Auvergne", "Rhone", "Ile-de-France"]})
regions = regions.drop_duplicates(subset="city", keep="first")
joined = orders.merge(regions, on="city", how="left")
print(len(orders), "->", len(joined))
--- test
assert len(joined) == len(orders), f"The join should keep {len(orders)} orders, but it returned {len(joined)} rows. Make sure the regions table has one row per city before you merge."
assert list(joined["region"]) == ["Auvergne", "Ile-de-France"], "Each city should get one region."
--- hint
A lookup table with duplicate keys multiplies the rows it joins to. Remove the duplicates from the lookup table first.
--- hint
`regions = regions.drop_duplicates(subset="city", keep="first")` before the merge.
```

## Predict the row count

```python predict id=predict-join title="How many rows come out?"
import pandas as pd
a = pd.DataFrame({"k": [1, 2, 3]})
b = pd.DataFrame({"k": [2, 2, 5]})
print(len(a.merge(b, on="k", how="inner")))
--- options
* 2
1
3
4
--- explain
Only key 2 appears in both tables. In `b` it appears twice, so the single 2 in `a` is matched twice, giving two rows. Key 1 and 3 have no match and are dropped by the inner join.
```

## Recap

- A left join keeps every row of the main table; an inner join keeps only matches. Choose by what you cannot afford to lose.
- Check joins: compare row counts, and use `validate` to catch duplicate keys.
- `concat` stacks tables with the same columns.
- `pivot_table` turns long data into a grid, and `melt` turns a grid back into long data.

**Up next:** time series. Most business data is ordered by time, and dates need their own tools.
