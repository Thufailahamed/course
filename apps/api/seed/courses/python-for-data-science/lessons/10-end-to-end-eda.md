# An end-to-end EDA

Exploratory data analysis is not a checklist. It is a conversation with a dataset: you inspect, form a question, calculate, plot, then revise the question. This final lesson runs that loop on a realistic subscription export.

The business question: **which plans drive revenue, and where is churn concentrated?** The data is deliberately messy — padded plan names, inconsistent country casing, a missing seat count, dates stored as text, and churn recorded as `yes`/`no`. By the end you'll have a cleaned table, a plan scorecard, a monthly view and two charts that support a written conclusion.

## 1. Load and look

```python run
import io
import pandas as pd

csv_data = """customer_id,plan,signup_date,monthly_fee,seats,churned,country
1, Pro ,2026-01-04,49.00,3,no, Portugal
2,pro,2026-02-11,49.00,,yes, portugal
3,Basic,2026-01-19,19.00,1,no,Spain
4,Basic,2026-03-02,19.00,2,yes,Spain
5, Pro,2026-02-20,49.00,4,no,Portugal
6,basic,2026-03-15,19.00,1,no, spain 
7,Pro,2026-01-28,49.00,2,yes,Portugal
8,Basic,2026-02-05,19.00,3,no,Spain
"""

df = pd.read_csv(io.StringIO(csv_data))
print("shape:", df.shape)
print("\ndtypes:")
print(df.dtypes)
print("\nmissing values:")
print(df.isna().sum())
df.head()
```

Before cleaning anything, note what you have: eight customers, one missing `seats`, and text columns that should be categorical. `churned` is text, so it cannot be averaged yet.

## 2. Clean at the boundary

```python run
clean = df.copy()
clean["plan"] = clean["plan"].str.strip().str.lower()
clean["country"] = clean["country"].str.strip().str.lower()
clean["seats"] = clean["seats"].fillna(1).astype(int)
clean["signup_date"] = pd.to_datetime(clean["signup_date"])
clean["churned"] = clean["churned"].str.strip().str.lower().eq("yes")
clean["mrr"] = (clean["monthly_fee"] * clean["seats"]).round(2)

clean.head()
```

`mrr` is monthly recurring revenue: fee per seat times seats. Filling a missing seat count with 1 is an assumption; it should be documented. Every cleaning decision has a business meaning, and the analysis is only as defensible as those decisions.

## 3. Ask about plans

```python run
plan_summary = (
    clean.groupby("plan")
    .agg(
        customers=("customer_id", "count"),
        mrr=("mrr", "sum"),
        churned=("churned", "sum"),
    )
)
plan_summary["churn_rate"] = (plan_summary["churned"] / plan_summary["customers"]).round(2)
plan_summary.sort_values("mrr", ascending=False)
```

Pro has four customers and 490 MRR; Basic has four customers and 133 MRR. Pro churns 2 of 4 (50%), Basic churns 1 of 4 (25%). The higher-revenue plan is also the higher-churn plan — that is the tension worth investigating.

## 4. Add time

```python run
clean["month"] = clean["signup_date"].dt.to_period("M")
monthly = clean.groupby("month").agg(
    signups=("customer_id", "count"),
    mrr_added=("mrr", "sum"),
)
monthly
```

A monthly view turns a static snapshot into a trend. January had 3 signups, February 3, March 2. With eight rows this is anecdotal, not statistically meaningful — but the habit of checking the time dimension is what matters.

## 5. Show the evidence

```python run
import matplotlib.pyplot as plt

plan_plot = plan_summary.sort_values("mrr", ascending=False)

fig, axes = plt.subplots(1, 2, figsize=(9, 3.5))

axes[0].bar(plan_plot.index, plan_plot["mrr"], color=["#2563eb", "#0f766e"])
axes[0].set_title("MRR by plan")
axes[0].set_ylabel("MRR ($)")

axes[1].bar(plan_plot.index, plan_plot["churn_rate"], color=["#dc2626", "#f59e0b"])
axes[1].set_title("Churn rate by plan")
axes[1].set_ylabel("Share of customers")
axes[1].set_ylim(0, 1)

fig.suptitle("Revenue and churn do not point the same way")
plt.tight_layout()
plt.show()
```

The two panels make the trade-off visible: Pro brings more revenue but loses a larger share of customers. A good EDA ends with a sentence like that, not just a table.

> **In the wild:** Before shipping a recommendation, check the sample size, the time window and the definition of churn. "50% churn" based on four customers is a hypothesis, not a forecast.

## Your turn: clean the subscriptions

Build `clean` from `raw` with:

- `plan` and `country` stripped and lowercased
- `seats` filled with 1 and converted to integer
- `signup_date` parsed as datetime
- `churned` as a boolean (`"yes"` → `True`)
- `mrr = monthly_fee * seats`, rounded to 2 decimals

```python exercise id=clean-subscriptions title="Clean the subscription export"
import pandas as pd

raw = pd.DataFrame({
    "customer_id": [1, 2, 3, 4, 5],
    "plan": [" Pro ", "pro", "Basic", "basic", " Pro"],
    "country": [" Portugal", "portugal ", "Spain", "SPAIN", "Portugal"],
    "signup_date": ["2026-01-04", "2026-02-11", "2026-01-19", "2026-03-02", "2026-02-20"],
    "monthly_fee": [49.0, 49.0, 19.0, 19.0, 49.0],
    "seats": [3, None, 1, 2, 4],
    "churned": ["no", "yes", "no", "yes", "no"],
})

clean = raw.copy()

# TODO: clean every column described above.
clean["plan"] = ...
clean["country"] = ...
clean["seats"] = ...
clean["signup_date"] = ...
clean["churned"] = ...
clean["mrr"] = ...
--- solution
import pandas as pd

raw = pd.DataFrame({
    "customer_id": [1, 2, 3, 4, 5],
    "plan": [" Pro ", "pro", "Basic", "basic", " Pro"],
    "country": [" Portugal", "portugal ", "Spain", "SPAIN", "Portugal"],
    "signup_date": ["2026-01-04", "2026-02-11", "2026-01-19", "2026-03-02", "2026-02-20"],
    "monthly_fee": [49.0, 49.0, 19.0, 19.0, 49.0],
    "seats": [3, None, 1, 2, 4],
    "churned": ["no", "yes", "no", "yes", "no"],
})

clean = raw.copy()
clean["plan"] = clean["plan"].str.strip().str.lower()
clean["country"] = clean["country"].str.strip().str.lower()
clean["seats"] = clean["seats"].fillna(1).astype(int)
clean["signup_date"] = pd.to_datetime(clean["signup_date"])
clean["churned"] = clean["churned"].str.strip().str.lower().eq("yes")
clean["mrr"] = (clean["monthly_fee"] * clean["seats"]).round(2)
--- test
assert clean["plan"].tolist() == ["pro", "pro", "basic", "basic", "pro"], f"Plans should be [pro, pro, basic, basic, pro], but are {clean['plan'].tolist()}."
assert clean["country"].tolist() == ["portugal", "portugal", "spain", "spain", "portugal"], f"Countries should be normalized, but are {clean['country'].tolist()}."
assert clean["seats"].tolist() == [3, 1, 1, 2, 4], f"Seats should be [3, 1, 1, 2, 4], but are {clean['seats'].tolist()}."
assert pd.api.types.is_integer_dtype(clean["seats"]), "`seats` should be an integer column."
assert clean["churned"].tolist() == [False, True, False, True, False], f"`churned` should be [False, True, False, True, False], but is {clean['churned'].tolist()}."
assert clean["mrr"].tolist() == [147.0, 49.0, 19.0, 38.0, 196.0], f"MRR should be [147.0, 49.0, 19.0, 38.0, 196.0], but is {clean['mrr'].tolist()}."
assert clean.shape == (5, 8), f"`clean` should have 5 rows and 8 columns, but has shape {clean.shape}."
--- hint
Use `.str.strip().str.lower()` on both text columns, then `fillna(1).astype(int)` for seats.
--- hint
`pd.to_datetime` parses the dates; `eq("yes")` converts the churn labels to booleans. Revenue is `monthly_fee * seats`, rounded to 2 decimals.
```

## Your turn: the plan scorecard

Build `scorecard` with one row per plan, sorted by `mrr` descending, and these columns:

- `customers`: count of customers
- `mrr`: sum of MRR
- `churned`: count of churned customers
- `churn_rate`: churned / customers, rounded to 2 decimals

```python exercise id=plan-scorecard title="Build the plan scorecard"
import pandas as pd

clean = pd.DataFrame({
    "customer_id": [1, 2, 3, 4, 5, 6],
    "plan": ["pro", "pro", "basic", "basic", "pro", "basic"],
    "mrr": [147.0, 49.0, 19.0, 38.0, 196.0, 57.0],
    "churned": [False, True, False, True, True, False],
})

# TODO: group by plan, aggregate, add churn_rate, sort by MRR.
scorecard = ...
--- solution
import pandas as pd

clean = pd.DataFrame({
    "customer_id": [1, 2, 3, 4, 5, 6],
    "plan": ["pro", "pro", "basic", "basic", "pro", "basic"],
    "mrr": [147.0, 49.0, 19.0, 38.0, 196.0, 57.0],
    "churned": [False, True, False, True, True, False],
})

scorecard = (
    clean.groupby("plan")
    .agg(
        customers=("customer_id", "count"),
        mrr=("mrr", "sum"),
        churned=("churned", "sum"),
    )
)
scorecard["churn_rate"] = (scorecard["churned"] / scorecard["customers"]).round(2)
scorecard = scorecard.sort_values("mrr", ascending=False)
--- test
assert scorecard is not ..., "Replace the `...` after `scorecard =`."
assert scorecard.index.tolist() == ["pro", "basic"], f"Sort by MRR descending; index should be pro, basic, but is {scorecard.index.tolist()}."
assert scorecard.loc["pro", "mrr"] == 392.0, f"Pro MRR should be 392.0, but is {scorecard.loc['pro', 'mrr']!r}."
assert scorecard.loc["pro", "churn_rate"] == 0.67, f"Pro churn rate should be 0.67 (2 of 3), but is {scorecard.loc['pro', 'churn_rate']!r}."
assert scorecard.loc["basic", "customers"] == 3, "Basic should have 3 customers."
--- hint
Start with `.groupby("plan").agg(...)` using named aggregations for customers, mrr and churned.
--- hint
Add `churn_rate` after aggregating, then sort with `.sort_values("mrr", ascending=False)`.
```

## The churn rate that crashes

This is a common real-world failure: someone loads a fresh export, forgets that `churned` is still text, and calls `.mean()`. Run it, read the error, then compute the rate without modifying `df`.

```python debug id=churn-rate title="A mean of yes and no"
import pandas as pd

df = pd.DataFrame({
    "customer_id": [1, 2, 3, 4],
    "churned": ["no", "yes", "no", "yes"],
})

churn_rate = df["churned"].mean()
print(churn_rate)
--- solution
import pandas as pd

df = pd.DataFrame({
    "customer_id": [1, 2, 3, 4],
    "churned": ["no", "yes", "no", "yes"],
})

churn_rate = df["churned"].eq("yes").mean()
print(churn_rate)
--- test
assert abs(float(churn_rate) - 0.5) < 1e-9, f"`churn_rate` should be 0.5, but is {churn_rate!r}."
assert df["churned"].tolist() == ["no", "yes", "no", "yes"], "Keep the original `churned` column as text; compute the rate from it."
--- hint
Run it. pandas cannot average strings. Turn the labels into booleans first.
--- hint
`df["churned"].eq("yes")` gives `[False, True, False, True]`; the mean of a boolean Series is the share of `True` values.
```

## Predict the churn rate

```python predict id=predict-churn-rate title="Mean of booleans"
import pandas as pd

df = pd.DataFrame({"churned": [False, True, False, True, False]})
print(round(df["churned"].mean(), 2))
--- options
0.2
* 0.4
0.6
2.0
--- explain
`True` counts as 1 and `False` as 0, so the mean is `2 / 5 = 0.4`. This is the clean way to compute a rate once the column is boolean.
```

## The conclusion

The scorecard and charts support a specific, limited claim: **Pro contributes most of the revenue per customer, but also shows more churn in this small sample.** The next step is not a bigger chart; it is more data and a sharper question. How long do Pro customers stay? Does churn concentrate in a signup cohort? Is the missing seat count hiding a segment?

That is the real output of EDA: not a dashboard, but a better next question.

## Recap

- Inspect shape, dtypes and missing values before cleaning; the data will tell you what needs a decision.
- Clean text, numeric and date columns at the boundary, then derive business metrics such as MRR.
- Group by meaningful entities and add rates alongside counts; a count alone rarely answers a business question.
- Add a time dimension and plot the evidence. Check the sample size before turning a chart into a claim.
- A good analysis ends with a written conclusion and the next question, not just a table.

**You're done with the lessons.** If you haven't already, pass the checkpoint quiz at the end of the pandas section, then return to any challenge you skipped. The patterns here — inspect, clean, group, join, plot, question — are the ones you'll use in every dataset that follows.
