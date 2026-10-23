Most business data has a clock attached: orders happen on a day, sensors report every minute, subscriptions renew each month. Time series need three things pandas does well: parsing dates correctly, grouping them into periods such as weeks or months, and comparing each value with what came before. This lesson covers those three, and the mistakes that most often break them.

```python run
import io
import pandas as pd

CSV = """date,revenue
2026-01-01,120
2026-01-02,95
2026-01-05,140
2026-01-06,80
2026-01-09,160
2026-01-12,110
2026-01-13,175
2026-01-16,90
"""
daily = pd.read_csv(io.StringIO(CSV), parse_dates=["date"])
daily = daily.set_index("date")
daily
```

Setting the date as the index tells pandas that the rows are ordered by time, and unlocks the time-based methods below.

## Date parts

The `.dt` accessor gives the parts of a date as columns, which are useful for grouping and for spotting weekly patterns.

```python run
parts = daily.reset_index()
parts["weekday"] = parts["date"].dt.day_name()
parts["week"] = parts["date"].dt.isocalendar().week
print(parts[["date", "weekday", "week", "revenue"]])
```

## Resample: totals per period

`resample` groups by a time period. `"W"` means weeks ending on Sunday, and `"ME"` means calendar month ends.

```python run
weekly = daily["revenue"].resample("W").sum()
print(weekly)
```

Notice a week with no rows still appears, with a total of zero. That is correct: nothing was sold, and the calendar has no gap in it.

## Rolling windows: smooth the noise

A **rolling window** averages the last few values at each step. A 3-day average smooths day-to-day noise and shows the trend.

```python run
daily["rolling_3"] = daily["revenue"].rolling(3).mean().round(1)
print(daily)
```

The first two rolling values are missing, because there are not yet three days to average. That is the honest answer, not a bug.

## Change over time

`pct_change` compares each value with the previous one, and `shift` moves values down by a number of rows so you can line up a value with its past.

```python run
daily["day_over_day"] = daily["revenue"].pct_change().round(3)
daily["yesterday"] = daily["revenue"].shift(1)
print(daily[["revenue", "yesterday", "day_over_day"]].head(4))
```

> **Pitfall:** `shift`, `rolling` and `pct_change` depend on row order. They look at the previous row, not the previous date. If the rows are not sorted by time first, the comparisons are meaningless, so call `sort_index()` before doing them.

## Challenge: weekly totals

```python exercise id=weekly-totals title="Weekly revenue totals"
import pandas as pd

# TODO: `weekly_totals(df)` takes a table with a datetime column "date" and a numeric column "revenue".
# Return a Series with the total revenue for each week that ends on Sunday, indexed by the week's dates
# using the "W" rule of resample. Weeks with no sales must appear with a total of 0.
def weekly_totals(df):
    ...
--- solution
import pandas as pd

def weekly_totals(df):
    series = df.set_index("date")["revenue"].sort_index()
    return series.resample("W").sum()
--- test
import pandas as pd
df = pd.DataFrame({
    "date": pd.to_datetime(["2026-01-20", "2026-01-05", "2026-01-06"]),
    "revenue": [5.0, 10.0, 20.0],
})
result = weekly_totals(df)
assert result is not None, "Replace the `...` in `weekly_totals` with code that returns the weekly Series."
assert isinstance(result, pd.Series), "The result should be a Series."
assert list(result.values) == [30.0, 0.0, 5.0], f"The rows on 5 and 6 January share a week (30), the week of 12 January is empty (0), and 20 January gives 5. You returned {list(result.values)}. Sort by date, then resample by week."
assert len(result) == 3, "Weeks with no sales must still appear in the result."
--- hint
Put the dates in the index, sort it, then call `resample("W")` followed by `sum()`.
--- hint
`series = df.set_index("date")["revenue"].sort_index()`, then `series.resample("W").sum()`.
```

## Challenge: a rolling average in time order

```python exercise id=rolling-average title="Rolling average in date order"
import pandas as pd

# TODO: `rolling_average(df, window)` takes a table with a datetime column "date" and a numeric column "revenue"
# (rows may be unsorted). Sort by date, then return a Series of the rolling mean of revenue over `window` rows,
# indexed by date.
def rolling_average(df, window):
    ...
--- solution
import pandas as pd

def rolling_average(df, window):
    ordered = df.sort_values("date").set_index("date")["revenue"]
    return ordered.rolling(window).mean()
--- test
import pandas as pd
df = pd.DataFrame({
    "date": pd.to_datetime(["2026-01-03", "2026-01-01", "2026-01-02", "2026-01-04"]),
    "revenue": [30.0, 10.0, 20.0, 40.0],
})
result = rolling_average(df, 2)
assert result is not None, "Replace the `...` in `rolling_average` with code that returns the rolling Series."
assert list(result.values[1:]) == [15.0, 25.0, 35.0], f"In date order the 2-day averages are NaN, 15, 25, 35, but you returned {list(result.values)}. Sort by date first."
assert pd.isna(result.iloc[0]), "The first value has no full window, so it is missing."
--- hint
Sort the rows by date before you compute the rolling window.
--- hint
`df.sort_values("date").set_index("date")["revenue"].rolling(window).mean()`.
```

## Debug the rolling order

This code is meant to compute a 2-day rolling average in date order, but the rows are not sorted first.

```python debug id=sort-first title="Sort by time before you roll"
import pandas as pd

ts = pd.DataFrame({
    "date": pd.to_datetime(["2026-01-03", "2026-01-01", "2026-01-02"]),
    "revenue": [30.0, 10.0, 20.0],
})
ts["rolling_2"] = ts["revenue"].rolling(2).mean()      # bug: the rows are not in date order yet
ts = ts.sort_values("date")
print(ts)
--- solution
import pandas as pd

ts = pd.DataFrame({
    "date": pd.to_datetime(["2026-01-03", "2026-01-01", "2026-01-02"]),
    "revenue": [30.0, 10.0, 20.0],
})
ts = ts.sort_values("date")
ts["rolling_2"] = ts["revenue"].rolling(2).mean()
print(ts)
--- test
assert list(ts["revenue"]) == [10.0, 20.0, 30.0], "The table should be in date order."
assert ts["rolling_2"].iloc[1] == 15.0 and ts["rolling_2"].iloc[2] == 25.0, f"In date order the 2-day averages are 15 and 25, but the table has {list(ts['rolling_2'])}. Sort by date before you calculate the rolling values."
--- hint
Rolling windows look at the previous rows. The rows must be in date order first.
--- hint
Move `ts = ts.sort_values("date")` above the rolling line.
```

## Predict the rolling value

```python predict id=predict-rolling title="What is the second value?"
import pandas as pd
s = pd.Series([2.0, 4.0, 6.0, 8.0])
print(s.rolling(2).mean().iloc[1])
--- options
* 3.0
2.0
4.0
6.0
--- explain
A 2-row window at position 1 covers the values 2 and 4, whose mean is 3. The first position has no full window, so it is missing.
```

## Recap

- Set the date as the index and sort it, so time-based methods work on the right order.
- `resample("W")` or `resample("ME")` groups rows by period, and empty periods appear as zero.
- `rolling` smooths a series, and its first values are missing until the window fills.
- `shift` and `pct_change` compare each value with the previous row, so sort first.

**Up next:** visualization. A table of numbers rarely tells the story on its own, and a good chart makes the pattern visible at once.
