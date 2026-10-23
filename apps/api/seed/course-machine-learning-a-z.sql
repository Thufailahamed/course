DELETE FROM exercise_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_machine_learning_a_z');

DELETE FROM quiz_attempts WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_machine_learning_a_z');

DELETE FROM notes WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_machine_learning_a_z');

DELETE FROM lesson_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_machine_learning_a_z');

DELETE FROM discussions WHERE course_id = 'crs_machine_learning_a_z';

DELETE FROM certificates WHERE course_id = 'crs_machine_learning_a_z';

DELETE FROM enrollments WHERE course_id = 'crs_machine_learning_a_z';

DELETE FROM reviews WHERE course_id = 'crs_machine_learning_a_z';

DELETE FROM wishlist WHERE course_id = 'crs_machine_learning_a_z';

DELETE FROM path_courses WHERE course_id = 'crs_machine_learning_a_z';

DELETE FROM coupons WHERE course_id = 'crs_machine_learning_a_z';

DELETE FROM lessons WHERE course_id = 'crs_machine_learning_a_z';

DELETE FROM sections WHERE course_id = 'crs_machine_learning_a_z';

UPDATE order_items SET course_id = NULL WHERE course_id = 'crs_machine_learning_a_z';

DELETE FROM courses WHERE id = 'crs_machine_learning_a_z';

INSERT OR IGNORE INTO categories (id, slug, name, description, icon, sort_order) VALUES ('cat_machine-learning', 'machine-learning', 'Machine Learning', 'Classical ML, from regression to gradient boosting.', 'brain', 0);

INSERT INTO courses (id, slug, title, subtitle, description, category_id, instructor_id, level, language, price_cents, compare_at_price_cents, currency, thumbnail_key, preview_video_url, accent, status, featured, what_you_learn, requirements, target_audience, tags, duration_minutes, lessons_count, rating_avg, rating_count, students_count, published_at, created_at, updated_at) VALUES
('crs_machine_learning_a_z', 'machine-learning-a-z', 'Practical Machine Learning with scikit-learn', 'Build the core algorithms yourself in NumPy, then use them the way scikit-learn does.', 'Most machine-learning work is not choosing a clever algorithm. It is framing the problem, preparing features without leaking the answer, evaluating honestly, and explaining the result. This course covers the whole practice, and it builds the core algorithms yourself so that the library calls stop being magic.

## Learn by building

- **Algorithms from scratch.** Linear and logistic regression, a decision tree, bagging, boosting, nearest neighbours and cross-validation are written in NumPy, and you run them in the page.
- **The scikit-learn way.** Every algorithm is then shown with the scikit-learn API, as static code you can run on your own machine. You will see that the two versions compute the same thing.
- **Challenges with hidden tests.** Your functions are checked on new data, so memorized answers do not pass.
- **Debug challenges.** You find the mistakes that wreck real projects: scaling before the split, accuracy on an imbalanced problem, and a validation set used for tuning and reporting.
- **Predict-the-output questions** that build intuition about metrics and models.

## What you''ll cover

- **Foundations:** the machine-learning workflow and your first model.
- **Supervised learning:** linear and logistic regression, trees, forests, boosting and nearest neighbours.
- **Evaluation:** splits, cross-validation, metrics, bias and variance.
- **Features and pipelines:** feature engineering, data leakage and reproducible pipelines.
- **Tuning and interpretability:** search strategies and explaining predictions.
- **Capstone:** a churn model, built end to end.

## Why this course?

A model that scores 95% in a notebook can still fail in production, usually because of how it was evaluated or prepared. This course teaches the habits that prevent those failures, using the algorithms you have built with your own hands.

You need basic Python. The rest is taught from the ground up.', 'cat_machine-learning', 'usr_arjun', 'beginner', 'English', 0, NULL, 'USD', NULL, NULL, 200, 'published', 1, '["Frame business problems as machine-learning problems, with features, targets and a metric","Train linear models, logistic regression, decision trees, random forests and gradient boosting","Engineer features and build leak-free pipelines","Evaluate models with the right metrics, cross-validation and honest held-out data","Tune hyperparameters efficiently and explain predictions","Ship a complete churn model from raw data to a defensible result"]', '["Basic Python. Functions, lists and dictionaries are enough","High-school algebra. Matrix notation is introduced as you need it","A modern browser. Algorithms run in NumPy in the page; the scikit-learn and XGBoost code is shown for you to run locally"]', '["Analysts and engineers starting their first machine-learning project","Developers who use models but want to understand what they are doing","Students preparing for data-science roles"]', '["scikit-learn","XGBoost","Regression","Classification"]', 315, 20, 0, 0, 62340, '2026-01-03T06:47:21.823Z', '2025-12-04T06:47:21.823Z', '2026-10-20T06:47:21.823Z');

INSERT INTO sections (id, course_id, title, position, created_at) VALUES
('sec_machine_learning_a_z_1', 'crs_machine_learning_a_z', 'Foundations', 0, '2026-06-25T06:47:21.823Z'),
('sec_machine_learning_a_z_2', 'crs_machine_learning_a_z', 'Supervised Learning', 1, '2026-06-25T06:47:21.823Z'),
('sec_machine_learning_a_z_3', 'crs_machine_learning_a_z', 'Evaluation Done Right', 2, '2026-06-25T06:47:21.823Z'),
('sec_machine_learning_a_z_4', 'crs_machine_learning_a_z', 'Features and Pipelines', 3, '2026-06-25T06:47:21.823Z'),
('sec_machine_learning_a_z_5', 'crs_machine_learning_a_z', 'Tuning and Interpretability', 4, '2026-06-25T06:47:21.823Z'),
('sec_machine_learning_a_z_6', 'crs_machine_learning_a_z', 'Capstone', 5, '2026-06-25T06:47:21.823Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_machine_learning_a_z_1_1', 'sec_machine_learning_a_z_1', 'crs_machine_learning_a_z', 'How this course works', 'interactive', 0, 480, NULL, NULL, 'Welcome to **Practical Machine Learning**. Machine learning is the craft of getting a computer to make useful predictions from examples. A model is only a function with adjustable parts, and the parts are set by looking at data. What makes the craft hard is everything around the model: deciding what to predict, preparing the inputs, judging the result honestly, and explaining it to the people who will act on it.

This course covers all of it. You will build the core algorithms yourself in NumPy, so that each one is a formula you have read and run. Then you will see the same algorithm through the scikit-learn API, which is how working engineers use it. The scikit-learn and XGBoost code is shown as static code to run on your own machine, because the browser runs NumPy.

> **How to use this lesson:** read a little, run a little. Every grey box is code you can edit and run.

## Run your first cell

```python run
import numpy as np

# Five houses: size in square metres and price in thousands of euros
size = np.array([50.0, 70.0, 90.0, 110.0, 130.0])
price = np.array([150.0, 200.0, 260.0, 320.0, 390.0])

print("average price:", price.mean())
print("price per square metre, roughly:", round(price.sum() / size.sum(), 2))
```

Even this tiny example is a model in disguise. "The price per square metre is about three" is a rule learned from data, and you will meet it again in every lesson of this course.

## Predictions are rules learned from examples

```python run
rule = price.sum() / size.sum()          # a learned slope through the origin
new_size = 100.0
print("predicted price for 100 m²:", round(rule * new_size, 1), "thousand euros")
```

Machine learning generalizes this idea. The rule can be more complicated, the inputs more numerous, and the data far bigger, but the job is the same: learn a rule from examples that predicts well on cases the model has not seen.

## Predict before you run

```python predict id=predict-baseline title="What is the mean absolute error of a constant guess?"
import numpy as np
y = np.array([1.0, -1.0, 3.0])
guess = 1.0
print(np.mean(np.abs(y - guess)))
--- options
* 1.3333333333333333
1.0
0.0
4.0
--- explain
The errors are |1 − 1| = 0, |−1 − 1| = 2 and |3 − 1| = 2. Their sum is 4, and the mean over three values is 4/3. A constant guess is a simple baseline, and every real model should beat it.
```

## Your first challenge

A **challenge** asks you to write a function that the course tests on new data. Press **Check** to run the hidden tests.

```python exercise id=mean-baseline title="A constant baseline"
import numpy as np

# TODO: `baseline_predictions(y_train, n)` returns an array of length `n` with every value equal to the
# mean of `y_train`. This is the simplest possible model, and every real model should beat it.
def baseline_predictions(y_train, n):
    ...
--- solution
import numpy as np

def baseline_predictions(y_train, n):
    return np.full(n, np.mean(y_train))
--- test
import numpy as np
result = baseline_predictions(np.array([1.0, 3.0]), 4)
assert result is not None, "Replace the `...` in `baseline_predictions` with code that returns the array."
assert np.allclose(result, [2.0, 2.0, 2.0, 2.0]), f"The mean of 1 and 3 is 2, repeated four times, but you returned {result}."
assert np.allclose(baseline_predictions(np.array([10.0]), 2), [10.0, 10.0]), "A single training value is its own mean."
--- hint
`np.mean(y_train)` gives the average. `np.full(n, value)` builds an array of length `n` filled with `value`.
--- hint
`return np.full(n, np.mean(y_train))`.
```

## Debug the leak

This evaluation is meant to measure how well a model does on data it has never seen, but it accidentally uses the test answers to set the guess.

```python debug id=test-leak title="Set the guess from training data only"
import numpy as np

y_all = np.array([10.0, 12.0, 11.0, 30.0, 28.0, 31.0])
y_train, y_test = y_all[:4], y_all[4:]
guess = np.mean(y_all)            # bug: this peeks at the test answers
print("mean absolute error:", np.mean(np.abs(y_test - guess)))
--- solution
import numpy as np

y_all = np.array([10.0, 12.0, 11.0, 30.0, 28.0, 31.0])
y_train, y_test = y_all[:4], y_all[4:]
guess = np.mean(y_train)
print("mean absolute error:", np.mean(np.abs(y_test - guess)))
--- test
assert np.isclose(guess, np.mean(y_train)), "The guess must come from the training values only. Using the test answers makes the measurement dishonest."
--- hint
Ask which values the model is allowed to see when it is built. The test answers are not among them.
--- hint
Compute the mean from `y_train`, not from `y_all`.
```

## Recap

- A model is a rule with adjustable parts, learned from examples.
- Compare every model with a simple baseline, such as a constant guess.
- Measure on data the model did not learn from. Peeking at the test answers makes the measurement worthless.
- Read formulas and error values carefully. Predict the output before you run the code.

**Up next:** the machine-learning workflow, and how to turn a business question into a problem a model can answer.
', 1, '[]', '[{"title":"scikit-learn user guide","url":"https://scikit-learn.org/stable/user_guide.html"},{"title":"An Introduction to Statistical Learning (free book)","url":"https://www.statlearning.com/"},{"title":"XGBoost documentation","url":"https://xgboost.readthedocs.io/"}]', '2026-06-25T06:47:21.823Z', '2026-10-19T06:47:21.823Z'),
('les_machine_learning_a_z_1_2', 'sec_machine_learning_a_z_1', 'crs_machine_learning_a_z', 'The machine-learning workflow: framing the problem', 'interactive', 1, 960, NULL, NULL, 'Most machine-learning projects fail before any model is trained, because the problem was framed badly. A model needs three things: a **target**, the thing you want to predict; **features**, the information you will use to predict it; and a **metric**, the number that says how good a prediction is. Once those three are clear, the algorithm is the easy part.

This lesson walks through the workflow on a realistic question: how much will a flat sell for? You will define the target and features, split the data so that the test set stays untouched, and measure a baseline that every model must beat.

## Frame the problem

Write the question as a sentence with a prediction in it. "Predict the sale price of a flat, in thousands of euros, from its size, floor and age, so that the agency can set a listing price." Then fill in the three parts:

| Part | Here |
|---|---|
| Target | sale price (thousands of euros) |
| Features | size (m²), floor, age (years) |
| Metric | mean absolute error, in thousands of euros |

The metric matters as much as the model. Mean absolute error reads directly as "we are typically off by this much", which is the question the agency asks.

## Build a dataset

The data below are generated, so you can see exactly how they were made. Real data is never this clean, and the workflow stays the same.

```python run
import numpy as np

rng = np.random.default_rng(42)
n = 200
size = rng.uniform(35, 140, n)
floor = rng.integers(0, 12, n).astype(float)
age = rng.uniform(0, 60, n)
price = 2.8 * size + 3.0 * floor - 0.9 * age + 40 + rng.normal(0, 15, n)

X = np.column_stack([size, floor, age])      # one row per flat, one column per feature
y = price                                     # the target
print("features:", X.shape, "| target:", y.shape)
print("first flat:", X[0].round(1), "→ price", round(y[0], 1))
```

## Split before you look

The test set plays the role of the future. It must stay out of every decision you make while building the model, including the choice of baseline. Split the rows once, at random, with a fixed seed so the split is reproducible.

```python run
order = rng.permutation(n)
n_test = int(0.2 * n)
test_idx, train_idx = order[:n_test], order[n_test:]
print("training flats:", len(train_idx), "| test flats:", len(test_idx))
```

Before modelling, look at the target itself. A model that predicts a target nobody understands is a model nobody will trust.

```python run
print("price range:", round(y.min(), 1), "to", round(y.max(), 1), "thousand euros")
print("median price:", round(float(np.median(y)), 1))
print("flats above 300k:", int((y > 300).sum()), "of", len(y))
```

## A baseline everyone must beat

Before any model, predict the average training price for every test flat. The error of this guess is the bar a real model has to clear.

```python run
baseline = y[train_idx].mean()
baseline_mae = np.mean(np.abs(y[test_idx] - baseline))
print("baseline guess:", round(baseline, 1), "thousand euros")
print("baseline mean absolute error:", round(baseline_mae, 1), "thousand euros")
```

A model that cannot beat "guess the average" is not yet useful, however sophisticated it looks. This baseline is the first thing to report in any project.

> **Pitfall:** do not choose the baseline, the features or the model by looking at the test set. Every decision made by peeking turns the test score into an optimistic guess.

## Challenge: a reproducible split

```python exercise id=split-indices title="A reproducible train and test split"
import numpy as np

# TODO: `split_indices(n, test_fraction, seed)` returns a tuple (train_idx, test_idx) of integer arrays.
# Shuffle the numbers 0 to n-1 with np.random.default_rng(seed). The test part holds int(test_fraction * n)
# rows. The two arrays must not share any index, and together they must cover every row.
def split_indices(n, test_fraction, seed):
    ...
--- solution
import numpy as np

def split_indices(n, test_fraction, seed):
    order = np.random.default_rng(seed).permutation(n)
    n_test = int(test_fraction * n)
    return order[n_test:], order[:n_test]
--- test
import numpy as np
result = split_indices(10, 0.3, 0)
assert result is not None, "Replace the `...` in `split_indices` with code that returns (train_idx, test_idx)."
train_idx, test_idx = result
assert len(test_idx) == 3 and len(train_idx) == 7, f"With 10 rows and a 30% test fraction there should be 3 test rows and 7 training rows, but you returned {len(train_idx)} and {len(test_idx)}."
assert set(train_idx) & set(test_idx) == set(), "A row must not appear in both the training and the test set."
assert sorted(list(train_idx) + list(test_idx)) == list(range(10)), "Every row should appear exactly once."
again = split_indices(10, 0.3, 0)
assert np.array_equal(again[1], test_idx), "The same seed must give the same split."
--- hint
Use `np.random.default_rng(seed).permutation(n)` to get shuffled row numbers. Cut off the first `n_test` of them for the test set.
--- hint
`order = np.random.default_rng(seed).permutation(n)`, `n_test = int(test_fraction * n)`, then return the rest and the first part.
```

## Challenge: the baseline error

```python exercise id=baseline-error title="The error of a constant guess"
import numpy as np

# TODO: `baseline_mae(y_train, y_test)` predicts the training mean for every test value and returns the
# mean absolute error of that guess.
def baseline_mae(y_train, y_test):
    ...
--- solution
import numpy as np

def baseline_mae(y_train, y_test):
    guess = np.mean(y_train)
    return float(np.mean(np.abs(np.asarray(y_test) - guess)))
--- test
import numpy as np
result = baseline_mae(np.array([1.0, 3.0]), np.array([2.0, 6.0]))
assert result is not None, "Replace the `...` in `baseline_mae` with code that returns the error."
assert np.isclose(result, 2.0), f"The guess is the training mean 2. The errors are |2 − 2| = 0 and |6 − 2| = 4, whose mean is 2, but you returned {result!r}."
assert np.isclose(baseline_mae([5.0], [5.0, 5.0]), 0.0), "A perfect guess has zero error."
--- hint
Compute the training mean first. Then take the absolute differences from the test values and average them.
--- hint
`guess = np.mean(y_train)` and `return float(np.mean(np.abs(np.asarray(y_test) - guess)))`.
```

## Debug the overlap

This split is meant to hold out 20% of the flats, but the two parts overlap, so some flats are both trained on and tested on.

```python debug id=overlap-split title="Keep training and test rows apart"
import numpy as np

rng = np.random.default_rng(0)
n = 10
order = rng.permutation(n)
cut = int(0.8 * n)
train_idx = order[:cut]
test_idx = order[:n - cut]          # bug: the test rows are taken from the start of the training rows
print("train:", train_idx, "test:", test_idx)
--- solution
import numpy as np

rng = np.random.default_rng(0)
n = 10
order = rng.permutation(n)
cut = int(0.8 * n)
train_idx = order[:cut]
test_idx = order[cut:]
print("train:", train_idx, "test:", test_idx)
--- test
assert set(train_idx) & set(test_idx) == set(), f"No row may be in both sets, but these overlap: {set(train_idx) & set(test_idx)}. The test rows must come from after the training rows."
assert len(test_idx) == 2, "The test set should hold the remaining 2 rows."
--- hint
In a split, the training rows and the test rows are different slices of the same shuffled order.
--- hint
Take the test rows from `order[cut:]`, the part after the training rows.
```

## Predict the split size

```python predict id=predict-split title="How many training flats are there?"
n = 150
test_fraction = 0.2
n_test = int(test_fraction * n)
print(n - n_test)
--- options
* 120
30
150
100
--- explain
Twenty per cent of 150 is 30 test flats, so 120 remain for training. The training and test parts together always add up to the full dataset.
```

## Recap

- Frame the problem with a target, features and a metric before you model anything.
- Split the data once, at random, with a fixed seed, and keep the test set untouched.
- Measure a baseline first. A model must beat it to be worth anything.
- Overlapping training and test rows make every score dishonest.

**Up next:** your first model, linear regression, and the closed-form solution behind it.
', 0, '[]', '[]', '2026-06-25T06:47:21.823Z', '2026-10-19T06:47:21.823Z'),
('les_machine_learning_a_z_1_3', 'sec_machine_learning_a_z_1', 'crs_machine_learning_a_z', 'Your first model: linear regression', 'interactive', 2, 1080, NULL, NULL, 'Linear regression is the first model worth learning, because it is simple enough to understand completely and it appears inside many larger methods. It predicts the target as a weighted sum of the features plus an intercept. Training means choosing the weights that make the squared errors as small as possible, and for linear regression that choice has an exact solution.

## The model

For one flat with features $x_1, \dots, x_d$, the prediction is

$$
\hat y = w_0 + w_1 x_1 + \dots + w_d x_d
$$

The intercept $w_0$ is the price of an imaginary flat with all features zero. It is learned like the other weights, and the usual trick is to add a column of ones to the features so that the intercept becomes just another weight.

```python run
import numpy as np

def add_intercept_column(X):
    return np.column_stack([np.ones(len(X)), X])

X_demo = np.array([[50.0, 2.0], [80.0, 5.0]])
print(add_intercept_column(X_demo))
```

## Fit by least squares

The best weights minimize the sum of squared errors. NumPy''s `lstsq` solves that problem directly, with no iteration needed.

```python run
rng = np.random.default_rng(42)
n = 200
size = rng.uniform(35, 140, n)
floor = rng.integers(0, 12, n).astype(float)
age = rng.uniform(0, 60, n)
price = 2.8 * size + 3.0 * floor - 0.9 * age + 40 + rng.normal(0, 15, n)
X = np.column_stack([size, floor, age])

A = add_intercept_column(X)
weights, *_ = np.linalg.lstsq(A, price, rcond=None)
print("intercept:", round(weights[0], 2))
print("size, floor, age:", weights[1:].round(2))
print("true values were 40, 2.8, 3.0 and -0.9")
```

The recovered weights are close to the values used to generate the prices. With noise in the data, you should not expect exact recovery, only a close estimate.

## Measure the fit

$R^2$ measures the share of the target''s variation the model explains. A value of 1 is a perfect fit, and 0 means the model does no better than predicting the mean.

```python run
predicted = A @ weights
ss_res = np.sum((price - predicted) ** 2)
ss_tot = np.sum((price - price.mean()) ** 2)
print("R²:", round(1 - ss_res / ss_tot, 3))
print("mean absolute error:", round(np.mean(np.abs(price - predicted)), 2))
```

Compare this with the baseline from the last lesson. The model should be far better than guessing the average price.

## Look at the residuals

A residual is the gap between a prediction and the truth. If the model is right, residuals show no pattern when you plot them against the predictions.

```python run
import matplotlib.pyplot as plt

fig, ax = plt.subplots(figsize=(5, 3.5))
ax.scatter(predicted, price - predicted, alpha=0.6)
ax.axhline(0, color="black", linewidth=1)
ax.set_xlabel("predicted price (thousand €)")
ax.set_ylabel("residual (thousand €)")
ax.set_title("Residuals should scatter randomly around zero")
ax.grid(alpha=0.3)
plt.show()
```

A curve or a funnel in this plot means the model is missing structure, such as a non-linear effect or errors that grow with the price.

> **In the wild:** scikit-learn does the same job with `LinearRegression().fit(X, y)`. Its `coef_` and `intercept_` are these weights, and its `score` method returns $R^2$.

```python
# Static: run this on your own machine with scikit-learn installed
from sklearn.linear_model import LinearRegression

model = LinearRegression().fit(X, price)
print(model.intercept_, model.coef_)
print(model.score(X, price))
```

## Challenge: add the intercept column

```python exercise id=add-intercept title="Add a column of ones"
import numpy as np

# TODO: `with_intercept(X)` takes a 2-D array of features and returns a new array with a column of ones
# added as the first column. The original array must not change.
def with_intercept(X):
    ...
--- solution
import numpy as np

def with_intercept(X):
    X = np.asarray(X, dtype=float)
    return np.column_stack([np.ones(len(X)), X])
--- test
import numpy as np
X_t = np.array([[2.0, 3.0], [4.0, 5.0]])
result = with_intercept(X_t)
assert result is not None, "Replace the `...` in `with_intercept` with code that returns the augmented array."
assert result.shape == (2, 3), f"Two rows with two features should give shape (2, 3), but you returned {result.shape}."
assert np.allclose(result[:, 0], 1.0), "The first column should be all ones."
assert np.allclose(result[:, 1:], X_t), "The original features should follow in the remaining columns."
assert np.allclose(X_t, [[2.0, 3.0], [4.0, 5.0]]), "The input array must not be changed."
--- hint
`np.column_stack` joins arrays column by column. A column of ones has the same length as the rows, and `np.ones(len(X))` makes one.
--- hint
`return np.column_stack([np.ones(len(X)), X])`.
```

## Challenge: fit the weights

```python exercise id=fit-linear title="Fit linear regression by least squares"
import numpy as np

# TODO: `fit_linear(X, y)` returns the weight vector w that minimizes the sum of squared errors of
# X_with_intercept @ w against y. The first weight is the intercept. Use np.linalg.lstsq.
def fit_linear(X, y):
    ...
--- solution
import numpy as np

def fit_linear(X, y):
    A = np.column_stack([np.ones(len(X)), np.asarray(X, dtype=float)])
    w, *_ = np.linalg.lstsq(A, np.asarray(y, dtype=float), rcond=None)
    return w
--- test
import numpy as np
X_t = np.array([[1.0], [2.0], [3.0], [4.0]])
y_t = 2.0 + 3.0 * X_t[:, 0]
w = fit_linear(X_t, y_t)
assert w is not None, "Replace the `...` in `fit_linear` with code that returns the weights."
assert w.shape == (2,), f"There is one feature plus an intercept, so there should be 2 weights, but you returned shape {w.shape}."
assert np.allclose(w, [2.0, 3.0]), f"The data follow y = 2 + 3x exactly, so the weights should be [2, 3], but you returned {w}."
rng_t = np.random.default_rng(1)
X2 = rng_t.normal(size=(50, 2))
y2 = -1.0 + 0.5 * X2[:, 0] + 4.0 * X2[:, 1]
assert np.allclose(fit_linear(X2, y2), [-1.0, 0.5, 4.0]), "Noise-free data from two features should be recovered exactly."
--- hint
Build the augmented matrix with the intercept column, then call `np.linalg.lstsq(A, y, rcond=None)`. Its first return value is the weight vector.
--- hint
`A = np.column_stack([np.ones(len(X)), X])`, then `w, *_ = np.linalg.lstsq(A, y, rcond=None)` and return `w`.
```

## Challenge: R squared

```python exercise id=r-squared title="R squared"
import numpy as np

# TODO: `r_squared(y, y_hat)` returns 1 − (sum of squared residuals) / (sum of squared deviations of y from its mean).
def r_squared(y, y_hat):
    ...
--- solution
import numpy as np

def r_squared(y, y_hat):
    y = np.asarray(y, dtype=float)
    y_hat = np.asarray(y_hat, dtype=float)
    return float(1 - np.sum((y - y_hat) ** 2) / np.sum((y - y.mean()) ** 2))
--- test
import numpy as np
assert np.isclose(r_squared([1.0, 2.0, 3.0], [1.0, 2.0, 3.0]), 1.0), "Perfect predictions give R² of 1."
assert np.isclose(r_squared([1.0, 2.0, 3.0], [2.0, 2.0, 2.0]), 0.0), "Always predicting the mean gives R² of 0."
result = r_squared([1.0, 2.0, 4.0], [1.0, 2.0, 3.0])
assert result is not None, "Replace the `...` in `r_squared` with code that returns the value."
assert np.isclose(result, 11 / 14), f"The residual sum of squares is 1 and the total sum of squares is 14/3, so R² is 1 − 3/14 = 11/14 ≈ 0.786. You returned {result!r}."
--- hint
Compute the two sums of squares separately: one for the residuals, `y - y_hat`, and one for the deviations from the mean of `y`.
--- hint
`1 - np.sum((y - y_hat) ** 2) / np.sum((y - y.mean()) ** 2)`.
```

## Debug the missing intercept

This model is meant to learn an intercept, but it forces the line through the origin, so every prediction is too low.

```python debug id=no-intercept title="Include the intercept"
import numpy as np

X = np.array([[1.0], [2.0], [3.0], [4.0]])
y = np.array([5.0, 7.0, 9.0, 11.0])          # y = 3 + 2x
w, *_ = np.linalg.lstsq(X, y, rcond=None)     # bug: no column of ones, so there is no intercept
print("weights:", w)
--- solution
import numpy as np

X = np.array([[1.0], [2.0], [3.0], [4.0]])
y = np.array([5.0, 7.0, 9.0, 11.0])
A = np.column_stack([np.ones(len(X)), X])
w, *_ = np.linalg.lstsq(A, y, rcond=None)
print("weights:", w)
--- test
assert w.shape == (2,), f"The model needs an intercept and a slope, so it should have 2 weights, but it has {w.shape[0]}. Add a column of ones."
assert np.allclose(w, [3.0, 2.0]), f"The data follow y = 3 + 2x, so the weights should be [3, 2], but you have {w}."
--- hint
Without a column of ones, the fit can only pass through the origin.
--- hint
Stack a column of ones in front of `X` before calling `lstsq`.
```

## Predict the fit

```python predict id=predict-r2 title="What is R² when predictions are perfect?"
import numpy as np
y = np.array([2.0, 4.0, 6.0])
print(1 - np.sum((y - y) ** 2) / np.sum((y - y.mean()) ** 2))
--- options
* 1.0
0.0
-1.0
2.0
--- explain
With perfect predictions the residual sum of squares is zero, so R² is 1 minus zero, which is exactly 1.
```

## Recap

- Linear regression predicts a weighted sum of the features plus an intercept, and the intercept is a column of ones.
- Least squares finds the best weights in one step with `lstsq`.
- $R^2$ compares the model with predicting the mean. Residuals show what the model still misses.
- scikit-learn''s `LinearRegression` computes the same weights.

**Up next:** logistic regression, the same idea adapted for yes-or-no decisions.
', 0, '[]', '[]', '2026-06-25T06:47:21.823Z', '2026-10-19T06:47:21.823Z'),
('les_machine_learning_a_z_2_1', 'sec_machine_learning_a_z_2', 'crs_machine_learning_a_z', 'Logistic regression for classification', 'interactive', 0, 1080, NULL, NULL, 'Many of the questions businesses ask have a yes-or-no answer: will this customer leave, will this payment be fraudulent, will this patient return to hospital? For these, linear regression is the wrong tool, because its output is not a probability and it can predict any number. **Logistic regression** keeps the same weighted sum, then squeezes it through the sigmoid function so that the output is always a probability between 0 and 1.

## The sigmoid

The sigmoid maps any real number into the interval (0, 1). A score of zero becomes one half, large positive scores approach one, and large negative scores approach zero.

$$
\sigma(z) = \frac{1}{1 + e^{-z}}, \qquad p = \sigma(w_0 + w_1 x_1 + \dots + w_d x_d)
$$

```python run
import numpy as np

z = np.array([-4.0, -1.0, 0.0, 1.0, 4.0])
print("scores:      ", z)
print("probabilities:", np.round(1 / (1 + np.exp(-z)), 3))
```

## The loss: cross-entropy

Training minimizes the average cross-entropy between the predicted probability $p_i$ and the true label $y_i \in \{0, 1\}$. It punishes confident wrong answers heavily, which is what you want from a probability model.

$$
L(w) = -\frac{1}{n} \sum_{i} \bigl[\, y_i \log p_i + (1 - y_i) \log(1 - p_i) \,\bigr]
$$

The gradient has a surprisingly simple form. It is the predicted probability minus the label, passed back through the features:

$$
\nabla L(w) = \frac{1}{n} X^{\top} (p - y)
$$

## Train by gradient descent

```python run
rng = np.random.default_rng(0)
n = 200
x1 = rng.normal(0, 1, n)
x2 = rng.normal(0, 1, n)
label = (x1 + 0.8 * x2 + rng.normal(0, 0.6, n) > 0).astype(float)   # 1 = churned
A = np.column_stack([np.ones(n), x1, x2])                           # intercept column first

w = np.zeros(3)
for step in range(500):
    p = 1 / (1 + np.exp(-(A @ w)))
    grad = A.T @ (p - label) / n
    w = w - 0.5 * grad

p = 1 / (1 + np.exp(-(A @ w)))
print("weights:", w.round(2))
print("accuracy:", round(np.mean((p > 0.5) == label), 3))
```

The learned weights point the same way as the rule that generated the labels: both features raise the probability of churn, and the first carries a slightly larger weight, as the generating rule did.

## The decision boundary

Predicting class 1 when $p > 0.5$ is the same as predicting when the linear score is positive. The boundary is therefore a straight line, and logistic regression is a linear classifier.

```python run
import matplotlib.pyplot as plt

fig, ax = plt.subplots(figsize=(5, 4))
ax.scatter(x1[label == 0], x2[label == 0], s=14, label="stayed")
ax.scatter(x1[label == 1], x2[label == 1], s=14, label="churned")
xs = np.linspace(-3, 3, 50)
ax.plot(xs, -(w[0] + w[1] * xs) / w[2], "k--", label="p = 0.5")
ax.set_xlabel("feature 1"); ax.set_ylabel("feature 2")
ax.legend(); ax.grid(alpha=0.3)
plt.show()
```

## Probabilities, not just labels

The probability is often more useful than the yes-or-no answer. A retention team can call the 20 customers with the highest churn probability, which is a ranking question.

```python run
top = np.argsort(p)[::-1][:5]
print("top five churn probabilities:", np.round(p[top], 3))
```

> **In the wild:** scikit-learn''s `LogisticRegression` solves the same problem, usually with a regularization penalty that keeps the weights small. Its `predict_proba` method returns these probabilities.

```python
# Static: run this on your own machine with scikit-learn installed
from sklearn.linear_model import LogisticRegression

clf = LogisticRegression().fit(A[:, 1:], label)
print(clf.intercept_, clf.coef_)
print(clf.predict_proba(A[:3, 1:])[:, 1])
```

## Challenge: the sigmoid

```python exercise id=sigmoid-fn title="The sigmoid function"
import numpy as np

# TODO: `sigmoid(z)` returns 1 / (1 + e^(−z)) elementwise for a number or an array.
def sigmoid(z):
    ...
--- solution
import numpy as np

def sigmoid(z):
    return 1 / (1 + np.exp(-np.asarray(z, dtype=float)))
--- test
import numpy as np
assert sigmoid(0.0) is not None, "Replace the `...` in `sigmoid` with code that returns the probability."
assert np.isclose(sigmoid(0.0), 0.5), "The sigmoid of zero is one half."
assert np.allclose(sigmoid(np.array([-2.0, 2.0])), [1 / (1 + np.e ** 2), 1 / (1 + np.e ** -2)]), "Check the formula 1 / (1 + e^(-z)) on an array."
assert sigmoid(50.0) > 0.999 and sigmoid(-50.0) < 0.001, "Large positive inputs should approach 1 and large negative inputs should approach 0."
--- hint
Compute `np.exp(-z)`, add 1, and take the reciprocal.
--- hint
`return 1 / (1 + np.exp(-np.asarray(z, dtype=float)))`.
```

## Challenge: the gradient

```python exercise id=logistic-gradient title="The gradient of the cross-entropy loss"
import numpy as np

# TODO: `logistic_gradient(A, y, w)` returns the gradient of the average cross-entropy with respect to w,
# which is (1/n) Aᵀ (p − y), where p = sigmoid(A @ w) and n is the number of rows of A.
def logistic_gradient(A, y, w):
    ...
--- solution
import numpy as np

def logistic_gradient(A, y, w):
    p = 1 / (1 + np.exp(-(A @ w)))
    return A.T @ (p - y) / len(y)
--- test
import numpy as np
A_t = np.array([[1.0, 0.0], [1.0, 1.0]])
result = logistic_gradient(A_t, np.array([1.0, 0.0]), np.zeros(2))
assert result is not None, "Replace the `...` in `logistic_gradient` with code that returns the gradient."
assert np.allclose(result, [0.0, 0.25]), f"With w = 0 every p is 0.5. The residuals are [-0.5, 0.5], so the gradient is Aᵀ·residuals / 2 = [0, 0.25], but you returned {result}."
rng_t = np.random.default_rng(2)
A2 = np.column_stack([np.ones(30), rng_t.normal(size=30)])
y2 = (rng_t.random(30) > 0.5).astype(float)
w2 = np.array([0.3, -0.4])
p2 = 1 / (1 + np.exp(-(A2 @ w2)))
assert np.allclose(logistic_gradient(A2, y2, w2), A2.T @ (p2 - y2) / 30), "The gradient should match the formula on a random example."
--- hint
Compute the predictions `p` first. The gradient is the feature matrix transposed, times the errors `p − y`, divided by the number of rows.
--- hint
`p = 1 / (1 + np.exp(-(A @ w)))` and `return A.T @ (p - y) / len(y)`.
```

## Debug the sign

This gradient step is meant to reduce the loss, but it moves the weights in the wrong direction.

```python debug id=gradient-sign title="Move downhill"
import numpy as np

A = np.array([[1.0, 0.0], [1.0, 1.0]])
y = np.array([1.0, 0.0])
w = np.zeros(2)
p = 1 / (1 + np.exp(-(A @ w)))
grad = A.T @ (y - p) / len(y)        # bug: the residual has the wrong sign
w_new = w - 0.5 * grad
print("gradient:", grad)
--- solution
import numpy as np

A = np.array([[1.0, 0.0], [1.0, 1.0]])
y = np.array([1.0, 0.0])
w = np.zeros(2)
p = 1 / (1 + np.exp(-(A @ w)))
grad = A.T @ (p - y) / len(y)
w_new = w - 0.5 * grad
print("gradient:", grad)
--- test
assert np.allclose(grad, [0.0, 0.25]), f"The gradient of the loss is Aᵀ(p − y)/n = [0, 0.25] here, but you have {grad}. Use p − y, not y − p."
assert w_new[1] < 0, "The second weight should decrease here, because the example labelled 0 has the larger feature value."
--- hint
The loss gradient uses the prediction minus the label, `p - y`. Reversing it reverses the direction of every step.
--- hint
Swap `y - p` for `p - y`.
```

## Predict the probability

```python predict id=predict-sigmoid title="What probability does a score of zero give?"
import numpy as np
print(1 / (1 + np.exp(-0.0)))
--- options
* 0.5
0.0
1.0
0.25
--- explain
A score of zero sits exactly on the decision boundary, where the model is undecided. The sigmoid of zero is one half.
```

## Recap

- Logistic regression applies the sigmoid to a weighted sum, so its output is a probability.
- Training minimizes cross-entropy, whose gradient is the features transposed times the errors $p - y$.
- The decision boundary is linear, and the probabilities let you rank customers by risk.
- scikit-learn''s `LogisticRegression` computes the same model, with regularization built in.

**Up next:** decision trees, which learn rules rather than weights, and can bend the boundary.
', 0, '[]', '[]', '2026-06-25T06:47:21.823Z', '2026-10-19T06:47:21.823Z'),
('les_machine_learning_a_z_2_2', 'sec_machine_learning_a_z_2', 'crs_machine_learning_a_z', 'Decision trees: learning rules from data', 'interactive', 1, 1080, NULL, NULL, 'A decision tree learns a sequence of yes-or-no questions. "Is the tenure under 12 months? If yes, is the monthly spend above 40?" Trees are easy to read, need no feature scaling, and can capture interactions between features that a straight line cannot. Their weakness is that they memorize unless you constrain them, and the constraints are where most of the skill lies.

## Impurity: how mixed is a group?

A split is good when it separates the classes. **Gini impurity** measures how mixed a group is: 0 for a group of one class, and larger when the classes are evenly mixed.

$$
\text{gini} = 1 - \sum_k p_k^2
$$

where $p_k$ is the share of class $k$ in the group.

```python run
import numpy as np

def gini(labels):
    labels = np.asarray(labels)
    if labels.size == 0:
        return 0.0
    _, counts = np.unique(labels, return_counts=True)
    p = counts / labels.size
    return float(1 - np.sum(p ** 2))

print("pure group:", gini([1, 1, 1, 1]))
print("half and half:", gini([0, 0, 1, 1]))
print("mostly one class:", round(gini([0, 0, 0, 1]), 3))
```

## The best split on one feature

A tree tries every threshold on a feature, splits the rows into "at or below" and "above", and keeps the threshold where the weighted impurity of the two sides is lowest. Try it by hand first.

```python run
x = np.array([1.0, 2.0, 3.0, 10.0, 11.0, 12.0])
y = np.array([0, 0, 0, 1, 1, 1])

for t in [2.5, 6.5, 10.5]:
    left, right = y[x <= t], y[x > t]
    score = (len(left) * gini(left) + len(right) * gini(right)) / len(y)
    print(f"threshold {t:>4}: weighted impurity {score:.3f}")
```

The threshold 6.5 separates the classes perfectly, so its weighted impurity is zero. Trees search exactly this way, for every feature, at every node.

## Grow a small tree

Apply the search recursively: split, then split each side again, until the groups are pure or a depth limit is reached. The depth limit is the simplest way to stop the tree memorizing.

```python run
def grow(x, y, depth):
    if depth == 0 or len(np.unique(y)) == 1:
        return {"leaf": int(np.bincount(y).argmax())}
    t = np.median(x)
    left, right = x <= t, x > t
    if not left.any() or not right.any():
        return {"leaf": int(np.bincount(y).argmax())}
    return {"threshold": float(t),
            "left": grow(x[left], y[left], depth - 1),
            "right": grow(x[right], y[right], depth - 1)}

def predict_one(tree, value):
    while "leaf" not in tree:
        tree = tree["left"] if value <= tree["threshold"] else tree["right"]
    return tree["leaf"]

tree = grow(x, y, depth=2)
print(tree)
print("prediction for 8.0:", predict_one(tree, 8.0))
```

This version splits at the median, which is a simple rule rather than the best threshold. The challenge below uses the real search.

## Overfitting: the tree that learns noise

Trees keep splitting until every training row is classified correctly, so a deep tree memorizes noise. A shallow tree generalizes better.

```python run
rng = np.random.default_rng(5)
xs = rng.uniform(0, 10, 60)
ys = ((xs > 5) ^ (rng.random(60) < 0.15)).astype(int)     # a clean rule with 15% label noise
for depth in [1, 6]:
    tree = grow(xs, ys, depth)
    train_acc = np.mean([predict_one(tree, v) == t for v, t in zip(xs, ys)])
    print(f"depth {depth}: training accuracy {train_acc:.2f}")
```

The deeper tree fits the training data more closely, but that fit includes the noise. Judge depth on held-out data, not on training accuracy.

> **In the wild:** scikit-learn''s `DecisionTreeClassifier(max_depth=3)` grows the same kind of tree, and `sklearn.tree.plot_tree` draws it.

```python
# Static: run this on your own machine with scikit-learn installed
from sklearn.tree import DecisionTreeClassifier

model = DecisionTreeClassifier(max_depth=3).fit(xs.reshape(-1, 1), ys)
print(model.score(xs.reshape(-1, 1), ys))
```

## Challenge: the Gini impurity

```python exercise id=gini-impurity title="Gini impurity of a group"
import numpy as np

# TODO: `gini(labels)` returns 1 − Σ p_k² for the labels, where p_k is the share of each class. An empty group
# has impurity 0.
def gini(labels):
    ...
--- solution
import numpy as np

def gini(labels):
    labels = np.asarray(labels)
    if labels.size == 0:
        return 0.0
    _, counts = np.unique(labels, return_counts=True)
    p = counts / labels.size
    return float(1 - np.sum(p ** 2))
--- test
result = gini([0, 0, 1, 1])
assert result is not None, "Replace the `...` in `gini` with code that returns the impurity."
assert abs(result - 0.5) < 1e-9, f"Two classes split evenly give 1 − (0.5² + 0.5²) = 0.5, but you returned {result!r}."
assert abs(gini([1, 1, 1])) < 1e-9, "A pure group has impurity 0."
assert abs(gini([0, 0, 0, 1]) - 0.375) < 1e-9, "With shares 3/4 and 1/4 the impurity is 1 − (9/16 + 1/16) = 0.375."
assert gini([]) == 0.0, "An empty group has impurity 0."
--- hint
Count how often each class appears, turn the counts into shares, square them, sum them, and subtract from 1.
--- hint
`_, counts = np.unique(labels, return_counts=True)`, `p = counts / labels.size`, `return float(1 - np.sum(p ** 2))`.
```

## Challenge: the best threshold

```python exercise id=best-threshold title="The best split on one feature"
import numpy as np

def gini(labels):
    labels = np.asarray(labels)
    if labels.size == 0:
        return 0.0
    _, counts = np.unique(labels, return_counts=True)
    p = counts / labels.size
    return float(1 - np.sum(p ** 2))

# TODO: `best_threshold(x, y)` returns the threshold that minimizes the weighted Gini impurity of the two
# sides. Try the midpoint between each pair of neighbouring distinct values of x. Rows with x <= t go left.
# If several thresholds tie, return the smallest.
def best_threshold(x, y):
    ...
--- solution
import numpy as np

def gini(labels):
    labels = np.asarray(labels)
    if labels.size == 0:
        return 0.0
    _, counts = np.unique(labels, return_counts=True)
    p = counts / labels.size
    return float(1 - np.sum(p ** 2))

def best_threshold(x, y):
    x = np.asarray(x, dtype=float)
    y = np.asarray(y)
    values = np.unique(x)
    best_t, best_score = None, np.inf
    for lo, hi in zip(values[:-1], values[1:]):
        t = (lo + hi) / 2
        left, right = y[x <= t], y[x > t]
        score = (len(left) * gini(left) + len(right) * gini(right)) / len(y)
        if score < best_score:
            best_t, best_score = t, score
    return best_t
--- test
x_t = np.array([1.0, 2.0, 3.0, 10.0, 11.0, 12.0])
y_t = np.array([0, 0, 0, 1, 1, 1])
result = best_threshold(x_t, y_t)
assert result is not None, "Replace the `...` in `best_threshold` with code that returns the threshold."
assert np.isclose(result, 6.5), f"The classes separate perfectly between 3 and 10, so the threshold should be their midpoint 6.5, but you returned {result!r}."
x2 = np.array([5.0, 1.0, 4.0, 2.0])
y2 = np.array([1, 0, 1, 0])
assert np.isclose(best_threshold(x2, y2), 3.0), "Values up to 2 are class 0 and from 4 are class 1, so the best split is at 3."
--- hint
Sort out the distinct values with `np.unique`, then loop over neighbouring pairs. The midpoint of a pair is `(lo + hi) / 2`.
--- hint
For each midpoint compute the weighted impurity of `y[x <= t]` and `y[x > t]`, and remember the smallest.
```

## Debug the impurity formula

This Gini function is meant to measure impurity, but it always returns zero, so every split looks equally good.

```python debug id=gini-formula title="Square the shares"
import numpy as np

labels = np.array([0, 0, 1, 1])
_, counts = np.unique(labels, return_counts=True)
p = counts / labels.size
impurity = 1 - np.sum(p)            # bug: the shares must be squared
print("impurity:", impurity)
--- solution
import numpy as np

labels = np.array([0, 0, 1, 1])
_, counts = np.unique(labels, return_counts=True)
p = counts / labels.size
impurity = 1 - np.sum(p ** 2)
print("impurity:", impurity)
--- test
assert abs(impurity - 0.5) < 1e-9, f"The Gini impurity of an even split is 0.5, but this gives {impurity}. The formula is 1 − Σ p², with the shares squared."
--- hint
The shares always add up to one, so `1 - sum(p)` is always zero.
--- hint
Square each share before summing: `1 - np.sum(p ** 2)`.
```

## Predict the impurity

```python predict id=predict-gini title="What is the Gini impurity of [0, 1]?"
import numpy as np
labels = np.array([0, 1])
_, counts = np.unique(labels, return_counts=True)
p = counts / labels.size
print(round(float(1 - np.sum(p ** 2)), 2))
--- options
* 0.5
0.0
1.0
0.25
--- explain
Each class has share one half, so the impurity is 1 − (0.25 + 0.25) = 0.5. An even split is as impure as a two-class group can be.
```

## Recap

- A tree splits on the threshold that most reduces impurity, and repeats on each side.
- Gini impurity is $1 - \sum p_k^2$: zero for a pure group, and largest for an even mix.
- Limit depth, or the tree memorizes noise. Judge depth on held-out data.
- Trees need no scaling and are easy to explain, but they are unstable on their own.

**Up next:** random forests. Combining many trees fixes the instability.
', 0, '[]', '[]', '2026-06-25T06:47:21.823Z', '2026-10-19T06:47:21.823Z'),
('les_machine_learning_a_z_2_3', 'sec_machine_learning_a_z_2', 'crs_machine_learning_a_z', 'Random forests and bagging', 'interactive', 2, 960, NULL, NULL, 'A single decision tree is unstable: change a few training rows and the tree can change its top split entirely. A **random forest** fixes that by growing many trees, each on a different random sample of the data and with a random subset of features, and then letting them vote. Averaging many unstable models gives a stable one, and this trick is called **bagging**, short for bootstrap aggregating.

## Bootstrap samples

A bootstrap sample draws $n$ rows *with replacement* from the $n$ training rows. Some rows appear several times, and about a third do not appear at all. Those left-out rows are called out-of-bag, and they give each tree a built-in test set.

```python run
import numpy as np

rng = np.random.default_rng(0)
n = 1000
sample = rng.integers(0, n, n)                  # draw n row numbers with replacement
share_used = len(np.unique(sample)) / n
print("share of distinct rows in one bootstrap sample:", round(share_used, 3))
print("theory: 1 − (1 − 1/n)ⁿ ≈ 0.632 for large n")
```

## Many simple trees, one vote

To keep the example short, each tree here is a *stump*: a single yes-or-no split on one randomly chosen feature. Each stump learns from its own bootstrap sample, and the forest takes the majority vote.

```python run
def fit_stump(x, y):
    best = None
    for t in np.unique(x)[:-1]:
        left, right = y[x <= t], y[x > t]
        lab_l = int(round(left.mean())) if left.size else 0
        lab_r = int(round(right.mean())) if right.size else 0
        acc = np.mean(np.where(x <= t, lab_l, lab_r) == y)
        if best is None or acc > best[0]:
            best = (acc, t, lab_l, lab_r)
    return best[1:]

def stump_predict(stump, x):
    t, lab_l, lab_r = stump
    return np.where(x <= t, lab_l, lab_r)

rng = np.random.default_rng(1)
n = 300
X = rng.normal(0, 1, (n, 4))
y = ((X[:, 0] + X[:, 1] ** 2 - 0.5 * X[:, 2] + rng.normal(0, 0.4, n)) > 0.5).astype(int)

def forest_fit(X, y, n_trees, rng):
    trees = []
    for _ in range(n_trees):
        rows = rng.integers(0, len(y), len(y))
        feature = rng.integers(0, X.shape[1])
        stump = fit_stump(X[rows, feature], y[rows])
        trees.append((feature, stump))
    return trees

def forest_predict(trees, X):
    votes = np.array([stump_predict(s, X[:, f]) for f, s in trees])
    return (votes.mean(axis=0) > 0.5).astype(int)

trees = forest_fit(X, y, 25, rng)
print("one stump''s accuracy:", round(np.mean(stump_predict(trees[0][1], X[:, trees[0][0]]) == y), 3))
print("forest accuracy:", round(np.mean(forest_predict(trees, X) == y), 3))
```

A single stump is nearly useless on its own. Twenty-five of them, each seeing a different slice of the data, combine into a much better classifier. Real forests use full trees, not stumps, but the principle is identical.

## Why the vote is stable

```python run
single_scores = []
for seed in range(10):
    r = np.random.default_rng(seed)
    rows = r.integers(0, n, n)                       # each seed sees a different bootstrap sample
    stump = fit_stump(X[rows, 0], y[rows])
    single_scores.append(np.mean(stump_predict(stump, X[:, 0]) == y))
print("single-stump accuracy across 10 bootstrap samples, spread:", round(np.std(single_scores), 4))
```

A single model is fixed by its data, so resampling the data changes it. The forest''s average over many resamples changes far less, and that is the stability you are buying.

## Out-of-bag evaluation

Each tree never saw about a third of the rows. Scoring each row only with the trees that skipped it gives an honest estimate without a separate test set.

```python run
rng = np.random.default_rng(2)
counts = np.zeros(n)
totals = np.zeros(n)
for _ in range(25):
    rows = rng.integers(0, n, n)
    out = np.setdiff1d(np.arange(n), rows)
    feature = rng.integers(0, X.shape[1])
    stump = fit_stump(X[rows, feature], y[rows])
    totals[out] += stump_predict(stump, X[out, feature])
    counts[out] += 1
seen = counts > 0
oob_pred = (totals[seen] / counts[seen] > 0.5).astype(int)
print("out-of-bag accuracy:", round(np.mean(oob_pred == y[seen]), 3))
```

> **In the wild:** scikit-learn''s `RandomForestClassifier(n_estimators=300, oob_score=True)` does all of this, and its `oob_score_` attribute is the out-of-bag estimate.

```python
# Static: run this on your own machine with scikit-learn installed
from sklearn.ensemble import RandomForestClassifier

forest = RandomForestClassifier(n_estimators=300, oob_score=True, random_state=0).fit(X, y)
print(forest.oob_score_)
```

## Challenge: bootstrap indices

```python exercise id=bootstrap-indices title="Draw a bootstrap sample"
import numpy as np

# TODO: `bootstrap_indices(n, seed)` returns an array of n row numbers drawn uniformly at random
# with replacement from 0 to n-1, using np.random.default_rng(seed).
def bootstrap_indices(n, seed):
    ...
--- solution
import numpy as np

def bootstrap_indices(n, seed):
    return np.random.default_rng(seed).integers(0, n, n)
--- test
import numpy as np
result = bootstrap_indices(1000, 0)
assert result is not None, "Replace the `...` in `bootstrap_indices` with code that returns the indices."
assert result.shape == (1000,), "A bootstrap sample has the same length as the data."
assert result.min() >= 0 and result.max() <= 999, "Indices must be valid row numbers."
assert 0.55 < len(np.unique(result)) / 1000 < 0.7, "About 63% of rows should appear at least once in a bootstrap sample."
assert np.array_equal(bootstrap_indices(1000, 0), result), "The same seed must give the same sample."
--- hint
`rng.integers(low, high, size)` draws random integers, and sampling with replacement is what makes a bootstrap sample.
--- hint
`return np.random.default_rng(seed).integers(0, n, n)`.
```

## Challenge: majority vote

```python exercise id=majority-vote title="Majority vote across trees"
import numpy as np

# TODO: `majority_vote(votes)` takes a 2-D array of 0/1 votes with one row per tree and one column per sample.
# Return a 1-D array with 1 for each sample where strictly more than half of the trees voted 1, and 0 otherwise.
def majority_vote(votes):
    ...
--- solution
import numpy as np

def majority_vote(votes):
    votes = np.asarray(votes)
    return (votes.sum(axis=0) * 2 > votes.shape[0]).astype(int)
--- test
import numpy as np
votes = np.array([[1, 0, 1], [1, 0, 0], [0, 0, 1], [1, 1, 1]])
result = majority_vote(votes)
assert result is not None, "Replace the `...` in `majority_vote` with code that returns the labels."
assert list(result) == [1, 0, 1], f"Sample 1 has 3 of 4 votes for 1, sample 2 has 0, sample 3 has 3. Expected [1, 0, 1], but you returned {list(result)}."
tie = np.array([[1], [0]])
assert list(majority_vote(tie)) == [0], "A tie is not a strict majority, so the answer is 0."
--- hint
Sum the votes for each sample. Compare the sum with half the number of trees, without dividing, to avoid rounding issues.
--- hint
`votes.sum(axis=0) * 2 > votes.shape[0]`, then convert to integers.
```

## Debug the bootstrap

This sampler is meant to draw a bootstrap sample, but it returns a permutation, so every row appears exactly once.

```python debug id=sample-with-replacement title="Sample with replacement"
import numpy as np

rng = np.random.default_rng(0)
n = 10
sample = rng.permutation(n)          # bug: a permutation never repeats a row
print("distinct rows:", len(np.unique(sample)))
--- solution
import numpy as np

rng = np.random.default_rng(0)
n = 10
sample = rng.integers(0, n, n)
print("distinct rows:", len(np.unique(sample)))
--- test
assert len(sample) == n, "A bootstrap sample has n draws."
assert len(np.unique(sample)) < n, "A bootstrap sample draws with replacement, so some rows repeat and fewer than n distinct rows appear. Use integers, not a permutation."
--- hint
A permutation is a shuffle: each row appears once. Bootstrapping needs draws that can repeat.
--- hint
Use `rng.integers(0, n, n)`.
```

## Predict the share

```python predict id=predict-bootstrap title="What share of rows appear in a bootstrap sample of 1000?"
print(round(1 - (1 - 1 / 1000) ** 1000, 2))
--- options
* 0.63
0.5
0.37
1.0
--- explain
Each row is missed by one draw with probability (1 − 1/n), and missed by all n draws with probability (1 − 1/n)ⁿ, which is about 0.368. So about 63% of rows appear at least once, and about a third are out of bag.
```

## Recap

- A bootstrap sample draws rows with replacement, so about 63% of distinct rows appear in each one.
- A forest averages many models trained on different samples, which makes the prediction stable.
- Rows left out of each sample give an honest out-of-bag score.
- scikit-learn''s `RandomForestClassifier` does the same, with full trees.

**Up next:** gradient boosting, which builds trees in sequence, each correcting the last.
', 0, '[]', '[]', '2026-06-25T06:47:21.823Z', '2026-10-19T06:47:21.823Z'),
('les_machine_learning_a_z_2_4', 'sec_machine_learning_a_z_2', 'crs_machine_learning_a_z', 'Gradient boosting: learning from mistakes', 'interactive', 3, 1080, NULL, NULL, 'Random forests build trees side by side, independently. **Gradient boosting** builds them one after another. Each new tree is trained to predict the mistakes the current model still makes, and its predictions are added to the total with a small step size. Boosting is among the strongest methods for tabular data, and the idea is only a few lines of code.

## The residual idea

Start with a simple prediction, such as the average. The residuals, which are the errors, say what is still wrong. Fit a small tree to those residuals, add a fraction of its output to the prediction, and repeat.

$$
F_{m}(x) = F_{m-1}(x) + \eta \, h_m(x), \qquad h_m \text{ is fitted to the residuals } y - F_{m-1}(x)
$$

The learning rate $\eta$ is the fraction you add each round. Small steps need more rounds but generalize better.

```python run
import numpy as np

rng = np.random.default_rng(0)
x = np.sort(rng.uniform(0, 6, 120))
y = np.sin(x) + rng.normal(0, 0.2, 120)

prediction = np.full_like(y, y.mean())          # round 0: predict the average
print("round 0 mean squared error:", round(np.mean((y - prediction) ** 2), 3))
residuals = y - prediction
print("the first residuals:", residuals[:4].round(2))
```

## A stump as the weak learner

Boosting usually fits small trees. Here each one is a *stump*: a single split with a constant value on each side, chosen to minimize squared error.

```python run
def fit_stump(x, r):
    best = None
    for t in np.unique(x)[:-1]:
        left, right = r[x <= t], r[x > t]
        sse = np.sum((left - left.mean()) ** 2) + np.sum((right - right.mean()) ** 2)
        if best is None or sse < best[0]:
            best = (sse, float(t), float(left.mean()), float(right.mean()))
    return best[1:]

def stump_value(stump, x):
    t, lm, rm = stump
    return np.where(x <= t, lm, rm)

stump = fit_stump(x, residuals)
print("split at", round(stump[0], 2), "| left value", round(stump[1], 2), "| right value", round(stump[2], 2))
```

## Boost

```python run
lr = 0.3
pred = np.full_like(y, y.mean())
stumps = []
for round_ in range(60):
    resid = y - pred
    s = fit_stump(x, resid)
    stumps.append(s)
    pred = pred + lr * stump_value(s, x)
    if round_ in (0, 9, 59):
        print(f"round {round_ + 1:>2}: mean squared error {np.mean((y - pred) ** 2):.3f}")
```

Each round fits the remaining error and shrinks it. After sixty rounds the model follows the sine curve closely, although every stump is a crude step function.

## The learning rate trades speed for care

```python run
for rate in [0.05, 0.3, 1.0]:
    p = np.full_like(y, y.mean())
    for _ in range(20):
        p = p + rate * stump_value(fit_stump(x, y - p), x)
    print(f"learning rate {rate:>4}: error after 20 rounds {np.mean((y - p) ** 2):.3f}")
```

A rate of one is fastest here but takes the largest risks on noisier data. Smaller rates with more rounds are the usual default.

> **In the wild:** XGBoost, LightGBM and scikit-learn''s `GradientBoostingRegressor` use this idea with deeper trees and extra tricks such as regularization and early stopping.

```python
# Static: run this on your own machine with xgboost installed
from xgboost import XGBRegressor

model = XGBRegressor(n_estimators=200, learning_rate=0.05, max_depth=3)
model.fit(x.reshape(-1, 1), y)
print(model.predict(x[:3].reshape(-1, 1)))
```

## Challenge: fit one stump

```python exercise id=stump-fit title="Fit a regression stump"
import numpy as np

# TODO: `stump_fit(x, r)` returns (threshold, left_value, right_value) for the single split on x that minimizes
# the total squared error of r around each side''s mean. Try the midpoint between neighbouring distinct values
# of x, with x <= t on the left. Keep the first split on a tie.
def stump_fit(x, r):
    ...
--- solution
import numpy as np

def stump_fit(x, r):
    x = np.asarray(x, dtype=float)
    r = np.asarray(r, dtype=float)
    values = np.unique(x)
    best = None
    for lo, hi in zip(values[:-1], values[1:]):
        t = (lo + hi) / 2
        left, right = r[x <= t], r[x > t]
        sse = np.sum((left - left.mean()) ** 2) + np.sum((right - right.mean()) ** 2)
        if best is None or sse < best[0]:
            best = (sse, float(t), float(left.mean()), float(right.mean()))
    return best[1:]
--- test
import numpy as np
x_t = np.array([1.0, 2.0, 3.0, 10.0, 11.0])
r_t = np.array([1.0, 1.0, 1.0, 5.0, 5.0])
result = stump_fit(x_t, r_t)
assert result is not None, "Replace the `...` in `stump_fit` with code that returns (threshold, left, right)."
t, lv, rv = result
assert np.isclose(t, 6.5), f"The best split lies between 3 and 10, at 6.5, but you returned {t}."
assert np.isclose(lv, 1.0) and np.isclose(rv, 5.0), f"The left side averages 1 and the right side averages 5, but you returned {lv} and {rv}."
--- hint
For each midpoint, compute the sum of squared differences from the mean on each side, add the two, and keep the smallest.
--- hint
Keep the best tuple `(sse, t, left mean, right mean)` and return everything except the `sse`.
```

## Challenge: boosted prediction

```python exercise id=boosted-predict title="Combine the stumps"
import numpy as np

# TODO: `boosted_predict(x, base, stumps, lr)` returns base + lr × (the sum of the stump outputs). A stump is a tuple
# (threshold, left_value, right_value); its output for x is left_value where x <= threshold and right_value otherwise.
def boosted_predict(x, base, stumps, lr):
    ...
--- solution
import numpy as np

def boosted_predict(x, base, stumps, lr):
    x = np.asarray(x, dtype=float)
    total = np.zeros_like(x)
    for t, lv, rv in stumps:
        total += np.where(x <= t, lv, rv)
    return base + lr * total
--- test
import numpy as np
x_t = np.array([0.0, 5.0])
stumps_t = [(2.0, 1.0, -1.0), (4.0, 0.5, 2.0)]
result = boosted_predict(x_t, 10.0, stumps_t, 0.5)
assert result is not None, "Replace the `...` in `boosted_predict` with code that returns the predictions."
assert np.allclose(result, [10.0 + 0.5 * (1.0 + 0.5), 10.0 + 0.5 * (-1.0 + 2.0)]), f"For x = 0 the stumps give 1 + 0.5 = 1.5, and for x = 5 they give -1 + 2 = 1. With base 10 and rate 0.5 the answers are 10.75 and 10.5, but you returned {result}."
--- hint
Start from an array of zeros, add each stump''s output for every x, then scale the total by `lr` and add `base`.
--- hint
Inside a loop over the stumps, use `np.where(x <= t, lv, rv)` and add it to the total.
```

## Debug the residual

This boosting step is meant to move the prediction towards the target, but the residual has the wrong sign, so the fit moves away from it.

```python debug id=residual-sign title="Fit the residual, not its negative"
import numpy as np

y = np.array([2.0, 4.0, 6.0])
pred = np.array([1.0, 1.0, 1.0])
residual = pred - y                 # bug: the residual is the target minus the prediction
print("residual to fit:", residual)
--- solution
import numpy as np

y = np.array([2.0, 4.0, 6.0])
pred = np.array([1.0, 1.0, 1.0])
residual = y - pred
print("residual to fit:", residual)
--- test
assert np.allclose(residual, [1.0, 3.0, 5.0]), f"The residual is the truth minus the prediction, [1, 3, 5], but you have {residual}. Reverse the subtraction."
--- hint
The boosting step must point the new tree towards the missing amount, which is target minus prediction.
--- hint
`residual = y - pred`.
```

## Predict the update

```python predict id=predict-boost title="What is the prediction after one round?"
import numpy as np
base = 0.0
lr = 0.5
stump_output = 2.0
print(base + lr * stump_output)
--- options
* 1.0
2.0
0.5
4.0
--- explain
One round adds the learning rate times the stump''s output: 0.5 × 2 = 1. The learning rate keeps each correction small.
```

## Recap

- Gradient boosting fits each new weak model to the residuals of the ensemble so far.
- The learning rate shrinks each correction. Smaller steps need more rounds and usually generalize better.
- Stumps are crude on their own, and many of them add up to a good curve.
- XGBoost and LightGBM use deeper trees and regularization on the same principle.

**Up next:** nearest neighbours, a method with no training step at all.
', 0, '[]', '[]', '2026-06-25T06:47:21.823Z', '2026-10-19T06:47:21.823Z'),
('les_machine_learning_a_z_2_5', 'sec_machine_learning_a_z_2', 'crs_machine_learning_a_z', 'Nearest neighbours and distance', 'interactive', 4, 840, NULL, NULL, 'The simplest classifier in this course has no training step at all. To predict a new point, find the $k$ training points closest to it and take a vote. This is the **k-nearest-neighbours** method, and it is a perfect place to learn the importance of distance and feature scale, because the whole method depends on them.

## Distance

The usual distance is Euclidean: the straight-line distance between two points, the square root of the sum of squared differences in each feature.

$$
d(a, b) = \sqrt{\sum_j (a_j - b_j)^2}
$$

```python run
import numpy as np

a = np.array([0.0, 0.0])
b = np.array([3.0, 4.0])
print("distance:", np.sqrt(np.sum((a - b) ** 2)))
print("same thing with np.linalg.norm:", np.linalg.norm(a - b))
```

## Classify by vote

```python run
rng = np.random.default_rng(0)
n = 80
cluster0 = rng.normal([0, 0], 0.8, (n // 2, 2))
cluster1 = rng.normal([2.5, 2.5], 0.8, (n // 2, 2))
X = np.vstack([cluster0, cluster1])
y = np.array([0] * (n // 2) + [1] * (n // 2))

def knn_predict_one(X, y, point, k):
    dist = np.linalg.norm(X - point, axis=1)
    nearest = y[np.argsort(dist)[:k]]
    return int(np.bincount(nearest).argmax())

for point in [np.array([0.2, -0.1]), np.array([2.0, 2.4]), np.array([1.2, 1.2])]:
    print(point, "→", knn_predict_one(X, y, point, k=5))
```

The point in the middle, at (1.2, 1.2), is close to both groups, and its label depends on which group is slightly nearer. It is a good illustration of why a boundary can be irregular.

## The choice of k

A small $k$ follows every local bump, while a large $k$ smooths the boundary. Neither extreme is right, and the best value is found on validation data.

```python run
test_points = rng.uniform(-1, 3.5, (200, 2))
truth = (test_points[:, 0] + test_points[:, 1] > 2.5).astype(int)
for k in [1, 5, 25]:
    pred = np.array([knn_predict_one(X, y, p, k) for p in test_points])
    print(f"k = {k:>2}: accuracy against the true rule {np.mean(pred == truth):.3f}")
```

## Scale matters

Distance treats every feature as equally important, so a feature measured in large units dominates. Standardizing each feature first puts them on the same footing.

```python run
income = rng.normal(40000, 8000, 60)          # in euros
age = rng.normal(40, 10, 60)                  # in years
point_a = np.array([40000.0, 30.0])
point_b = np.array([41000.0, 46.0])
print("raw distance between the two people:", round(np.linalg.norm(point_a - point_b), 1))
print("in raw units, the age difference of 16 years is invisible next to income")
```

> **Pitfall:** always scale features before a distance-based method. Fit the scaler on the training data only, as you will learn in the leakage lesson.

> **In the wild:** scikit-learn''s `KNeighborsClassifier(n_neighbors=5)` does this for you, and a `Pipeline` with a `StandardScaler` in front of it applies the scaling correctly.

```python
# Static: run this on your own machine with scikit-learn installed
from sklearn.neighbors import KNeighborsClassifier

model = KNeighborsClassifier(n_neighbors=5).fit(X, y)
print(model.predict([[0.2, -0.1], [2.0, 2.4]]))
```

## Challenge: Euclidean distance

```python exercise id=euclidean title="Euclidean distance"
import numpy as np

# TODO: `euclidean(a, b)` returns the straight-line distance between two equal-length vectors.
def euclidean(a, b):
    ...
--- solution
import numpy as np

def euclidean(a, b):
    return float(np.sqrt(np.sum((np.asarray(a, dtype=float) - np.asarray(b, dtype=float)) ** 2)))
--- test
import numpy as np
result = euclidean([0.0, 0.0], [3.0, 4.0])
assert result is not None, "Replace the `...` in `euclidean` with code that returns the distance."
assert np.isclose(result, 5.0), f"The distance from the origin to (3, 4) is 5, but you returned {result!r}."
assert np.isclose(euclidean([1.0, 2.0, 3.0], [1.0, 2.0, 3.0]), 0.0), "The distance from a point to itself is 0."
assert np.isclose(euclidean([1.0], [-2.0]), 3.0), "In one dimension the distance is the absolute difference."
--- hint
Subtract the vectors, square each entry, add them, and take the square root.
--- hint
`np.sqrt(np.sum((a - b) ** 2))`.
```

## Challenge: k-nearest-neighbour prediction

```python exercise id=knn-predict title="Predict by majority among the nearest neighbours"
import numpy as np

# TODO: `knn_predict(X_train, y_train, point, k)` returns the most common label among the k training rows nearest
# to `point` (Euclidean distance). Labels are non-negative integers. A tie goes to the smaller label.
def knn_predict(X_train, y_train, point, k):
    ...
--- solution
import numpy as np

def knn_predict(X_train, y_train, point, k):
    X_train = np.asarray(X_train, dtype=float)
    y_train = np.asarray(y_train)
    dist = np.linalg.norm(X_train - np.asarray(point, dtype=float), axis=1)
    nearest = y_train[np.argsort(dist, kind="stable")[:k]]
    return int(np.bincount(nearest).argmax())
--- test
import numpy as np
X_t = np.array([[0.0], [1.0], [2.0], [10.0]])
y_t = np.array([0, 0, 1, 1])
result = knn_predict(X_t, y_t, np.array([1.2]), 3)
assert result is not None, "Replace the `...` in `knn_predict` with code that returns the label."
assert result == 0, "The three nearest points to 1.2 are 1, 0 and 2, with labels 0, 0 and 1, so the answer is 0."
assert knn_predict(X_t, y_t, np.array([9.0]), 1) == 1, "The nearest point to 9 is 10, labelled 1."
assert knn_predict(X_t, y_t, np.array([5.0]), 2) == 0, "The two nearest to 5 are 2 (label 1) and 1 (label 0), a tie that goes to the smaller label 0."
--- hint
Compute the distance from `point` to every training row, sort the row indices by distance, and take the first k labels.
--- hint
`np.argsort(dist)[:k]` gives the nearest rows. `np.bincount(labels).argmax()` picks the most common label.
```

## Debug the direction of the sort

This nearest-neighbour function is meant to pick the closest points, but it picks the farthest.

```python debug id=knn-sort title="Pick the nearest, not the farthest"
import numpy as np

X = np.array([[0.0], [1.0], [5.0], [9.0]])
y = np.array([0, 0, 1, 1])
point = np.array([0.5])
dist = np.linalg.norm(X - point, axis=1)
nearest = y[np.argsort(-dist)[:2]]        # bug: sorting by negative distance reverses the order
print("neighbour labels:", nearest)
--- solution
import numpy as np

X = np.array([[0.0], [1.0], [5.0], [9.0]])
y = np.array([0, 0, 1, 1])
point = np.array([0.5])
dist = np.linalg.norm(X - point, axis=1)
nearest = y[np.argsort(dist)[:2]]
print("neighbour labels:", nearest)
--- test
assert list(nearest) == [0, 0], f"The two nearest points to 0.5 are 0 and 1, both labelled 0, but the code gives {list(nearest)}. Sort by distance in ascending order."
--- hint
Smaller distances mean closer points. The default sort is ascending, so you do not need a minus sign.
--- hint
Use `np.argsort(dist)` without the negative.
```

## Predict the distance

```python predict id=predict-dist title="What is the distance between (1, 1) and (4, 5)?"
import numpy as np
print(np.linalg.norm(np.array([1.0, 1.0]) - np.array([4.0, 5.0])))
--- options
* 5.0
3.0
4.0
7.0
--- explain
The differences are 3 and 4, and the square root of 3² + 4² = 25 is 5. This is the familiar 3-4-5 right triangle.
```

## Recap

- k-nearest-neighbours predicts by a vote among the k closest training points, with no training step.
- Small k follows local detail, large k smooths. Choose k on validation data.
- Distances depend on scale, so standardize features, with the scaler fitted on training data only.
- scikit-learn''s `KNeighborsClassifier` implements the method with fast search structures.

**Up next:** evaluation. Every method so far has been judged on training data, and that is not enough.
', 0, '[]', '[]', '2026-06-25T06:47:21.823Z', '2026-10-19T06:47:21.823Z'),
('les_machine_learning_a_z_3_1', 'sec_machine_learning_a_z_3', 'crs_machine_learning_a_z', 'Train, validation and test splits; cross-validation', 'interactive', 0, 1080, NULL, NULL, 'A single train-and-test split gives one number, and that number depends on which rows happened to land in the test set. Split again with a different seed and the score moves. **Cross-validation** fixes this by splitting many times, so every row is tested exactly once, and reporting the average. It is the standard way to compare models honestly, and it is also the place where a subtle mistake can quietly inflate every score.

## Three sets, three jobs

- The **training** set is where the model learns its weights.
- The **validation** set is where you compare models and choose settings, such as depth or learning rate.
- The **test** set is touched once, at the very end, to report the result.

Using the test set to choose settings turns it into a second validation set, and the final number becomes optimistic.

## K-fold cross-validation

Shuffle the rows and cut them into $k$ folds of nearly equal size. Each fold takes a turn as the validation set while the other $k - 1$ folds train the model.

```python run
import numpy as np

n, k = 10, 5
order = np.random.default_rng(0).permutation(n)
folds = np.array_split(order, k)
for i, fold in enumerate(folds):
    train = np.setdiff1d(np.arange(n), fold)
    print(f"fold {i}: validation rows {sorted(fold.tolist())}, training rows {len(train)}")
```

Every row appears in exactly one validation fold, and every model is trained on the rest. Five folds of 10 rows means five models, each validated on two rows and trained on eight.

## Averaging the folds

```python run
rng = np.random.default_rng(1)
x = rng.uniform(0, 10, 100)
y = 3 + 2 * x + rng.normal(0, 3, 100)

scores = []
for fold in np.array_split(rng.permutation(100), 5):
    train = np.setdiff1d(np.arange(100), fold)
    A = np.column_stack([np.ones(len(train)), x[train]])
    w, *_ = np.linalg.lstsq(A, y[train], rcond=None)
    pred = w[0] + w[1] * x[fold]
    scores.append(np.mean(np.abs(y[fold] - pred)))
print("error per fold:", np.round(scores, 2))
print("cross-validated mean absolute error:", round(np.mean(scores), 2))
```

The five errors vary from fold to fold. Their average is a more reliable estimate than any one of them, and their spread tells you how stable the estimate is.

## Leakage in cross-validation

> **Pitfall:** any step that learns from data, such as a scaler, an imputer or a feature selector, must be fitted inside each training fold, not on the full dataset before splitting. Otherwise the validation rows influence the training, and the scores are too good to be true.

Cutting 100 rows into five folds gives equal parts, and each validation part is a fifth of the data.

```python run
fold_sizes = [len(f) for f in np.array_split(np.arange(100), 5)]
print("validation rows per fold:", fold_sizes, "| total:", sum(fold_sizes))
```

## Time-ordered data

When rows have a time order, a random split lets the model train on the future and test on the past. For time series, split by time: train on earlier rows and validate on later ones.

```python run
months = np.arange(12)
train_months, test_months = months[:9], months[9:]
print("train on months", train_months.tolist(), "and test on", test_months.tolist())
```

> **In the wild:** scikit-learn''s `KFold(n_splits=5, shuffle=True)` and `cross_val_score` implement these ideas, and `TimeSeriesSplit` respects time order.

```python
# Static: run this on your own machine with scikit-learn installed
from sklearn.model_selection import cross_val_score, KFold
from sklearn.linear_model import LinearRegression

scores = cross_val_score(LinearRegression(), x.reshape(-1, 1), y,
                         cv=KFold(n_splits=5, shuffle=True, random_state=0),
                         scoring="neg_mean_absolute_error")
print(-scores.mean())
```

## Challenge: k-fold indices

```python exercise id=kfold-indices title="Split rows into k folds"
import numpy as np

# TODO: `kfold_indices(n, k, seed)` returns a list of k (train_idx, val_idx) pairs. Shuffle the numbers 0 to n-1
# with np.random.default_rng(seed), cut them into k nearly equal validation folds with np.array_split, and for
# each fold the training indices are all the rows that are not in that fold.
def kfold_indices(n, k, seed):
    ...
--- solution
import numpy as np

def kfold_indices(n, k, seed):
    order = np.random.default_rng(seed).permutation(n)
    folds = np.array_split(order, k)
    pairs = []
    for fold in folds:
        train = np.setdiff1d(np.arange(n), fold)
        pairs.append((train, fold))
    return pairs
--- test
import numpy as np
result = kfold_indices(10, 5, 0)
assert result is not None, "Replace the `...` in `kfold_indices` with code that returns the list of pairs."
assert len(result) == 5, "Five folds should give five (train, validation) pairs."
all_val = np.concatenate([val for _, val in result])
assert sorted(all_val.tolist()) == list(range(10)), "Every row should be a validation row exactly once."
for train, val in result:
    assert len(val) == 2, "Ten rows in five folds means two validation rows per fold."
    assert set(train) & set(val) == set(), "Training and validation rows must not overlap."
    assert len(train) == 8, "Each training part should hold the other eight rows."
--- hint
Use `np.array_split(order, k)` to cut the shuffled numbers into folds. The training part of a fold is everything outside it, which `np.setdiff1d` finds.
--- hint
Loop over the folds and append `(np.setdiff1d(np.arange(n), fold), fold)` to a list.
```

## Challenge: a cross-validated baseline

```python exercise id=cv-baseline title="Cross-validated error of the mean guess"
import numpy as np

# TODO: `cv_baseline_mae(y, k, seed)` uses k-fold cross-validation with the splits from `kfold_indices` (the
# folds are the shuffled rows cut into k parts, as in the lesson). For each fold, predict the mean of the
# training values for every validation value, and record the mean absolute error. Return the average over folds.
def cv_baseline_mae(y, k, seed):
    ...
--- solution
import numpy as np

def cv_baseline_mae(y, k, seed):
    y = np.asarray(y, dtype=float)
    order = np.random.default_rng(seed).permutation(len(y))
    errors = []
    for fold in np.array_split(order, k):
        train = np.setdiff1d(np.arange(len(y)), fold)
        guess = y[train].mean()
        errors.append(np.mean(np.abs(y[fold] - guess)))
    return float(np.mean(errors))
--- test
import numpy as np
y_t = np.array([1.0, 2.0, 3.0, 4.0, 5.0, 6.0])
result = cv_baseline_mae(y_t, 3, 0)
assert result is not None, "Replace the `...` in `cv_baseline_mae` with code that returns the average error."
assert np.isfinite(result) and result > 0, f"The cross-validated error should be a positive number, but you returned {result!r}."
assert np.isclose(cv_baseline_mae(np.full(9, 4.0), 3, 1), 0.0), "If every value is the same, the mean guess is perfect in every fold."
--- hint
Use the same shuffled folds as `kfold_indices`: `np.array_split(order, k)`. In each fold, compare the validation values with the training mean.
--- hint
Average the per-fold mean absolute errors at the end.
```

## Debug the leaky folds

This cross-validation loop is meant to hold out each fold, but it accidentally trains on the validation rows too.

```python debug id=train-includes-val title="Train only on the other folds"
import numpy as np

y = np.arange(10, dtype=float)
order = np.random.default_rng(0).permutation(10)
fold = np.array_split(order, 5)[0]
train = np.arange(10)                    # bug: the training rows include the validation rows
print("training rows:", len(train), "validation rows:", len(fold))
--- solution
import numpy as np

y = np.arange(10, dtype=float)
order = np.random.default_rng(0).permutation(10)
fold = np.array_split(order, 5)[0]
train = np.setdiff1d(np.arange(10), fold)
print("training rows:", len(train), "validation rows:", len(fold))
--- test
assert set(train) & set(fold) == set(), "The validation rows must not be used for training. Exclude the fold from the training rows."
assert len(train) == 8, "Two validation rows out of ten leave eight training rows."
--- hint
Training rows are everything except the validation fold.
--- hint
`train = np.setdiff1d(np.arange(10), fold)`.
```

## Predict the training size

```python predict id=predict-fold title="How many training rows are in each fold?"
n = 100
k = 5
print(n - n // k)
--- options
* 80
20
100
95
--- explain
Each fold holds 20 validation rows, so the training part holds the other 80. Across all five folds, every row is in the training part four times and in the validation part once.
```

## Recap

- Keep three sets: training to learn, validation to choose, test to report once.
- K-fold cross-validation gives every row one turn in validation, and the average is more reliable than one split.
- Fit every data-dependent step inside the training folds, to avoid leakage.
- For time-ordered data, split by time, never at random.

**Up next:** metrics. The number you report must match the question you care about.
', 0, '[]', '[]', '2026-06-25T06:47:21.823Z', '2026-10-19T06:47:21.823Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_machine_learning_a_z_3_2', 'sec_machine_learning_a_z_3', 'crs_machine_learning_a_z', 'Choosing metrics: accuracy is rarely enough', 'interactive', 1, 1080, NULL, NULL, 'Accuracy, the share of correct predictions, is the metric everyone reaches for first, and it is often the wrong one. A fraud detector that never flags anything can be 99% accurate when only 1% of payments are fraudulent, and it is completely useless. Choosing a metric means deciding which mistakes matter, and then measuring exactly those.

## The confusion matrix

Every yes-or-no prediction falls into one of four cells:

| | Predicted yes | Predicted no |
|---|---|---|
| **Actually yes** | true positive (TP) | false negative (FN) |
| **Actually no** | false positive (FP) | true negative (TN) |

```python run
import numpy as np

y_true = np.array([1, 1, 1, 0, 0, 0, 0, 0, 0, 0])
y_pred = np.array([1, 0, 1, 1, 0, 0, 0, 0, 0, 0])

tp = np.sum((y_true == 1) & (y_pred == 1))
fn = np.sum((y_true == 1) & (y_pred == 0))
fp = np.sum((y_true == 0) & (y_pred == 1))
tn = np.sum((y_true == 0) & (y_pred == 0))
print("TP", tp, "| FN", fn, "| FP", fp, "| TN", tn)
print("accuracy:", (tp + tn) / len(y_true))
```

## Precision and recall answer different questions

**Precision** asks: of the cases we flagged, how many were real? **Recall** asks: of the real cases, how many did we catch?

$$
\text{precision} = \frac{TP}{TP + FP}, \qquad \text{recall} = \frac{TP}{TP + FN}
$$

```python run
precision = tp / (tp + fp)
recall = tp / (tp + fn)
f1 = 2 * precision * recall / (precision + recall)
print("precision:", round(precision, 3), "| recall:", round(recall, 3), "| F1:", round(f1, 3))
```

The **F1 score** combines the two as their harmonic mean, so it is high only when both are high. A fraud team may accept low precision to catch most fraud, while a spam filter must have high precision, so that real email is not lost.

## The accuracy trap

```python run
rare = np.zeros(1000, dtype=int)
rare[:10] = 1                            # 1% of cases are positive
always_no = np.zeros(1000, dtype=int)    # a model that never predicts positive
print("accuracy:", np.mean(always_no == rare))
print("recall:", np.sum((rare == 1) & (always_no == 1)) / np.sum(rare == 1))
```

A model that does nothing scores 99% accuracy and catches nothing. Whenever the classes are unbalanced, look at precision and recall.

## Ranking quality: AUC

Many models output a score, not a decision. The **AUC** (area under the ROC curve) measures how often a randomly chosen positive gets a higher score than a randomly chosen negative. It is 0.5 for random guessing and 1.0 for perfect ranking, and it does not depend on any threshold.

```python run
scores = np.array([0.9, 0.8, 0.4, 0.7, 0.3, 0.2, 0.1])
labels = np.array([1, 1, 1, 0, 0, 0, 0])
pos, neg = scores[labels == 1], scores[labels == 0]
pairs = [(p > q) + 0.5 * (p == q) for p in pos for q in neg]
print("AUC:", round(np.mean(pairs), 3))
```

> **In the wild:** scikit-learn''s `precision_score`, `recall_score`, `f1_score` and `roc_auc_score` compute these, and `confusion_matrix` returns the four counts.

```python
# Static: run this on your own machine with scikit-learn installed
from sklearn.metrics import classification_report, roc_auc_score

print(classification_report(y_true, y_pred))
print(roc_auc_score(labels, scores))
```

## Challenge: the confusion counts

```python exercise id=confusion-counts title="Count the four outcomes"
import numpy as np

# TODO: `confusion_counts(y_true, y_pred)` returns the tuple (tp, fp, fn, tn) for 0/1 arrays.
def confusion_counts(y_true, y_pred):
    ...
--- solution
import numpy as np

def confusion_counts(y_true, y_pred):
    y_true = np.asarray(y_true)
    y_pred = np.asarray(y_pred)
    tp = int(np.sum((y_true == 1) & (y_pred == 1)))
    fp = int(np.sum((y_true == 0) & (y_pred == 1)))
    fn = int(np.sum((y_true == 1) & (y_pred == 0)))
    tn = int(np.sum((y_true == 0) & (y_pred == 0)))
    return tp, fp, fn, tn
--- test
result = confusion_counts([1, 1, 0, 0, 1], [1, 0, 1, 0, 1])
assert result is not None, "Replace the `...` in `confusion_counts` with code that returns the four counts."
assert result == (2, 1, 1, 1), f"There are 2 true positives, 1 false positive, 1 false negative and 1 true negative, but you returned {result}."
assert confusion_counts([0, 0], [0, 0]) == (0, 0, 0, 2), "Two correct negatives give (0, 0, 0, 2)."
--- hint
Each count is a boolean condition on both arrays at once. Combine the two conditions with `&`.
--- hint
`tp = np.sum((y_true == 1) & (y_pred == 1))`, and similarly for the other three.
```

## Challenge: precision, recall and F1

```python exercise id=prf-scores title="Precision, recall and F1"
# TODO: `precision_recall_f1(tp, fp, fn)` returns (precision, recall, f1). Precision is tp / (tp + fp) and recall
# is tp / (tp + fn). F1 is 2 · precision · recall / (precision + recall). Return 0.0 for any ratio whose denominator is 0.
def precision_recall_f1(tp, fp, fn):
    ...
--- solution
def precision_recall_f1(tp, fp, fn):
    precision = tp / (tp + fp) if (tp + fp) else 0.0
    recall = tp / (tp + fn) if (tp + fn) else 0.0
    f1 = 2 * precision * recall / (precision + recall) if (precision + recall) else 0.0
    return precision, recall, f1
--- test
result = precision_recall_f1(2, 1, 1)
assert result is not None, "Replace the `...` in `precision_recall_f1` with code that returns the three scores."
p, r, f = result
assert abs(p - 2 / 3) < 1e-9 and abs(r - 2 / 3) < 1e-9, f"With TP 2, FP 1 and FN 1 both precision and recall are 2/3, but you returned {result}."
assert abs(f - 2 / 3) < 1e-9, "When precision equals recall, F1 equals them too."
assert precision_recall_f1(0, 0, 5) == (0.0, 0.0, 0.0), "With no predicted positives and no hits, every score is 0, without a division error."
--- hint
Compute the two ratios first. Then F1 uses both, with a guard against dividing by zero.
--- hint
Write each ratio as `x / (x + y) if (x + y) else 0.0`.
```

## Debug the precision denominator

This precision calculation is meant to measure how many flagged cases were real, but it divides by the wrong count.

```python debug id=precision-denominator title="Divide by the flagged cases"
tp, fp, fn = 6, 2, 4
precision = tp / (tp + fn)          # bug: this counts the missed cases instead of the false alarms
print("precision:", round(precision, 3))
--- solution
tp, fp, fn = 6, 2, 4
precision = tp / (tp + fp)
print("precision:", round(precision, 3))
--- test
assert abs(precision - 0.75) < 1e-9, f"Precision is TP / (TP + FP) = 6 / 8 = 0.75, but it is {precision:.3f}. The denominator counts the flagged cases, which are true and false positives."
--- hint
Precision asks about the cases you flagged. Which two counts are those?
--- hint
The denominator is `tp + fp`.
```

## Predict the accuracy

```python predict id=predict-accuracy title="What accuracy does a model that always says no get?"
import numpy as np
y = np.array([1] + [0] * 99)
pred = np.zeros(100, dtype=int)
print(np.mean(pred == y))
--- options
* 0.99
0.01
0.5
1.0
--- explain
99 of the 100 cases are negative and the model gets all of them right, so its accuracy is 0.99. It also misses the only positive case, which is why accuracy alone is misleading here.
```

## Recap

- The confusion matrix holds the four outcomes, and every metric comes from it.
- Precision measures the reliability of flags, and recall measures how many real cases you catch. F1 balances them.
- Accuracy is misleading when classes are unbalanced. Use precision, recall and AUC instead.
- AUC measures ranking quality without choosing a threshold.

**Up next:** bias and variance, the trade-off behind every overfitting and underfitting story.
', 0, '[]', '[]', '2026-06-25T06:47:21.823Z', '2026-10-19T06:47:21.823Z'),
('les_machine_learning_a_z_3_3', 'sec_machine_learning_a_z_3', 'crs_machine_learning_a_z', 'Bias, variance and learning curves', 'interactive', 2, 960, NULL, NULL, 'Every model makes two kinds of error. **Bias** is the error from a model that is too simple to capture the real pattern: a straight line through a curve. **Variance** is the error from a model that is so flexible it fits the noise in its training data, and changes a lot when that data changes. The skill is finding the complexity that balances the two, and the best tool for seeing it is a plot of training and validation error against model complexity.

## A curve and its noise

```python run
import numpy as np
import matplotlib.pyplot as plt

rng = np.random.default_rng(3)
x_train = np.sort(rng.uniform(0, 1, 20))
y_train = np.sin(2 * np.pi * x_train) + rng.normal(0, 0.25, 20)
x_val = np.sort(rng.uniform(0, 1, 200))
y_val = np.sin(2 * np.pi * x_val) + rng.normal(0, 0.25, 200)

def poly_matrix(x, degree):
    return np.column_stack([x ** k for k in range(degree + 1)])

def fit_and_score(degree):
    w, *_ = np.linalg.lstsq(poly_matrix(x_train, degree), y_train, rcond=None)
    train_err = np.mean((poly_matrix(x_train, degree) @ w - y_train) ** 2)
    val_err = np.mean((poly_matrix(x_val, degree) @ w - y_val) ** 2)
    return train_err, val_err

degrees = range(1, 13)
errors = [fit_and_score(d) for d in degrees]
for d, (tr, va) in zip(degrees, errors):
    print(f"degree {d:>2}: training {tr:.4f}   validation {va:.4f}")
```

Read the table from top to bottom. Training error only goes down as the model gets more flexible. Validation error falls at first, then climbs as the model starts fitting noise. The lowest validation error marks the sweet spot.

```python run
fig, ax = plt.subplots(figsize=(5.5, 3.5))
ax.plot(list(degrees), [e[0] for e in errors], "o-", label="training")
ax.plot(list(degrees), [e[1] for e in errors], "o-", label="validation")
ax.set_yscale("log")
ax.set_xlabel("model complexity (polynomial degree)")
ax.set_ylabel("mean squared error")
ax.legend(); ax.grid(alpha=0.3)
plt.show()
```

## Underfitting and overfitting

- **High bias (underfitting):** both errors are high and close together. The model cannot express the pattern, so more data will not help much. Add features or flexibility.
- **High variance (overfitting):** training error is low, validation error is high, and the gap is wide. More data often helps, and so does regularization.

A quick look at what the curves mean in practice: the prediction each polynomial makes at x = 0.5, where the true value is sin(π) = 0.

```python run
for d in [1, 3, 12]:
    w, *_ = np.linalg.lstsq(poly_matrix(x_train, d), y_train, rcond=None)
    print(f"degree {d:>2}: prediction at x = 0.5 is {float((poly_matrix(np.array([0.5]), d) @ w)[0]):+.3f}")
```

Low-degree models give a stable but biased answer, and the flexible degree-12 model moves far from the truth. Both behaviours appear in the curves above.

## Learning curves

A learning curve shows error against the amount of training data. It tells you whether getting more data is worth the effort.

```python run
sizes = [5, 10, 20]
for m in sizes:
    x_m, y_m = x_train[:m], y_train[:m]
    w, *_ = np.linalg.lstsq(poly_matrix(x_m, 4), y_m, rcond=None)
    val = np.mean((poly_matrix(x_val, 4) @ w - y_val) ** 2)
    print(f"{m:>2} training examples: validation error {val:.4f}")
```

If the validation error keeps falling as data grows, the model is data-limited. If it has flattened while the training error stays low, more data will not help, and a different model is needed.

> **In the wild:** scikit-learn''s `learning_curve` and `validation_curve` compute these curves, and `GridSearchCV` finds the complexity that minimizes validation error.

```python
# Static: run this on your own machine with scikit-learn installed
from sklearn.model_selection import validation_curve
from sklearn.preprocessing import PolynomialFeatures
from sklearn.linear_model import LinearRegression
from sklearn.pipeline import make_pipeline

model = make_pipeline(PolynomialFeatures(), LinearRegression())
train_scores, val_scores = validation_curve(
    model, x_train.reshape(-1, 1), y_train,
    param_name="polynomialfeatures__degree", param_range=[1, 4, 8],
    scoring="neg_mean_squared_error", cv=5)
print(-val_scores.mean(axis=1))
```

## Challenge: polynomial features

```python exercise id=poly-features title="Build polynomial features"
import numpy as np

# TODO: `poly_features(x, degree)` returns a 2-D array with one row per value of x and columns x⁰, x¹, …, x^degree.
def poly_features(x, degree):
    ...
--- solution
import numpy as np

def poly_features(x, degree):
    x = np.asarray(x, dtype=float)
    return np.column_stack([x ** k for k in range(degree + 1)])
--- test
import numpy as np
result = poly_features([2.0, 3.0], 2)
assert result is not None, "Replace the `...` in `poly_features` with code that returns the matrix."
assert result.shape == (2, 3), f"Two values with degree 2 should give shape (2, 3), but you returned {result.shape}."
assert np.allclose(result, [[1.0, 2.0, 4.0], [1.0, 3.0, 9.0]]), f"The rows should be [1, x, x²], giving [1, 2, 4] and [1, 3, 9], but you returned {result}."
assert np.allclose(poly_features([5.0], 0), [[1.0]]), "Degree zero is just the column of ones."
--- hint
Stack one column per power, starting from the power zero column of ones, with `np.column_stack`.
--- hint
`np.column_stack([x ** k for k in range(degree + 1)])`.
```

## Challenge: a fitted curve''s error

```python exercise id=poly-val-error title="Validation error of a polynomial fit"
import numpy as np

# TODO: `poly_val_error(x_train, y_train, x_val, y_val, degree)` fits a least-squares polynomial of the given degree
# to the training data (with columns x⁰ to x^degree), then returns the mean squared error on the validation data.
def poly_val_error(x_train, y_train, x_val, y_val, degree):
    ...
--- solution
import numpy as np

def poly_val_error(x_train, y_train, x_val, y_val, degree):
    A = np.column_stack([np.asarray(x_train, dtype=float) ** k for k in range(degree + 1)])
    w, *_ = np.linalg.lstsq(A, np.asarray(y_train, dtype=float), rcond=None)
    B = np.column_stack([np.asarray(x_val, dtype=float) ** k for k in range(degree + 1)])
    return float(np.mean((B @ w - np.asarray(y_val, dtype=float)) ** 2))
--- test
import numpy as np
x_tr = np.array([0.0, 1.0, 2.0, 3.0])
y_tr = 1.0 + 2.0 * x_tr
x_va = np.array([4.0, 5.0])
y_va = 1.0 + 2.0 * x_va
result = poly_val_error(x_tr, y_tr, x_va, y_va, 1)
assert result is not None, "Replace the `...` in `poly_val_error` with code that returns the error."
assert np.isclose(result, 0.0, atol=1e-9), f"The data follow a line exactly, so a degree-1 fit has zero validation error, but you returned {result!r}."
assert poly_val_error(x_tr, y_tr, x_va, y_va, 0) > 1.0, "A constant cannot follow a rising line, so a degree-0 fit should have a large error."
--- hint
Build the training matrix with the same powers as `poly_features`, solve with `np.linalg.lstsq`, then build the validation matrix and compare its predictions with `y_val`.
--- hint
Keep the fitted weights `w` and apply them to the validation matrix before taking the squared differences.
```

## Debug the evaluation data

This code is meant to report validation error, but it measures the fit on the training data instead.

```python debug id=eval-on-train title="Measure on the validation data"
import numpy as np

x_tr = np.array([0.0, 1.0, 2.0, 3.0])
y_tr = np.array([0.0, 1.0, 2.5, 3.0])
x_va = np.array([4.0, 5.0])
y_va = np.array([4.5, 5.5])
A = np.column_stack([np.ones(4), x_tr])
w, *_ = np.linalg.lstsq(A, y_tr, rcond=None)
pred_train = np.column_stack([np.ones(4), x_tr]) @ w
val_error = np.mean((pred_train - y_tr) ** 2)       # bug: this is the training error
print("validation error:", round(val_error, 4))
--- solution
import numpy as np

x_tr = np.array([0.0, 1.0, 2.0, 3.0])
y_tr = np.array([0.0, 1.0, 2.5, 3.0])
x_va = np.array([4.0, 5.0])
y_va = np.array([4.5, 5.5])
A = np.column_stack([np.ones(4), x_tr])
w, *_ = np.linalg.lstsq(A, y_tr, rcond=None)
pred_val = np.column_stack([np.ones(2), x_va]) @ w
val_error = np.mean((pred_val - y_va) ** 2)
print("validation error:", round(val_error, 4))
--- test
assert np.isclose(val_error, np.mean((np.column_stack([np.ones(2), x_va]) @ w - y_va) ** 2)), "The validation error must compare predictions on the validation inputs with the validation targets."
--- hint
The error must use the validation inputs `x_va` and targets `y_va`, not the training ones.
--- hint
Build the matrix from `x_va` and compare its predictions with `y_va`.
```

## Predict the trend

```python predict id=predict-bv title="What is the training error of the most flexible fit?"
import numpy as np
x = np.array([0.0, 1.0, 2.0])
y = np.array([1.0, 0.0, 1.0])
A = np.column_stack([x ** k for k in range(3)])     # degree 2: three columns, three points
w, *_ = np.linalg.lstsq(A, y, rcond=None)
print(round(float(np.mean((A @ w - y) ** 2)), 6))
--- options
* 0.0
0.5
1.0
0.333333
--- explain
A degree-2 polynomial has three free weights, and three points determine a unique parabola through them. The parabola passes through all three points, so the training error is zero. A more flexible model can always fit the training points at least as well, which is why training error alone cannot choose the complexity.
```

## Recap

- Bias comes from a model too simple for the pattern. Variance comes from a model that fits noise.
- Plot training and validation error against complexity, and choose the lowest validation point.
- Learning curves show whether more data would help.
- Judge complexity on validation data, never on training error.

**Up next:** feature engineering, the step that often matters more than the choice of model.
', 0, '[]', '[]', '2026-06-25T06:47:21.823Z', '2026-10-19T06:47:21.823Z'),
('les_machine_learning_a_z_3_4', 'sec_machine_learning_a_z_3', 'crs_machine_learning_a_z', 'Checkpoint: supervised learning and evaluation', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"A model scores 98% accuracy on a dataset where only 2% of cases are positive. What is the most important next check?","options":["Report the accuracy, since it is high","Check precision and recall on the positive class","Add more features","Increase the training set size"],"answerIndex":1,"explanation":"With rare positives, a model that always predicts negative scores 98%. Precision and recall show whether the positive cases are actually found."},{"id":"q2","prompt":"What does a bootstrap sample of n rows contain?","options":["A random permutation of the rows, each appearing once","n rows drawn with replacement, so some repeat and about 63% of distinct rows appear","Only the rows that the model got wrong","The first n rows in the file"],"answerIndex":1,"explanation":"Drawing with replacement repeats some rows and skips others. About 63% of distinct rows appear, and the rest are out of bag."},{"id":"q3","prompt":"In gradient boosting, each new tree is fitted to…","options":["The original target values","The residuals of the current ensemble","A random subset of features only","The test set"],"answerIndex":1,"explanation":"Each round fits the errors still left after the ensemble so far, and the learning rate controls how much of that correction is added."},{"id":"q4","prompt":"Why should the test set be used only once, at the end?","options":["Because it is the smallest set","Because using it to choose settings makes the reported score optimistic","Because it must be deleted after use","Because it contains no features"],"answerIndex":1,"explanation":"Every decision made by looking at the test score fits it a little. Only one final evaluation gives an honest estimate."},{"id":"q5","prompt":"A tree model''s training accuracy is 100%, but its validation accuracy is 70%. Which change most directly reduces the variance?","options":["Grow the tree deeper","Limit the tree''s depth or require more rows per leaf","Remove the validation set","Use the training accuracy to choose the model"],"answerIndex":1,"explanation":"A large gap between training and validation scores signals overfitting. Limiting depth or leaf size makes the tree simpler and reduces its variance."}]', '[]', '2026-06-25T06:47:21.823Z', '2026-10-19T06:47:21.823Z'),
('les_machine_learning_a_z_4_1', 'sec_machine_learning_a_z_4', 'crs_machine_learning_a_z', 'Feature engineering: scaling, encoding and gaps', 'interactive', 0, 1200, NULL, NULL, 'In practice, the features you give a model usually matter more than the algorithm you choose. A linear model cannot see that the relationship between income and loan risk is curved, but a log-transformed income can make it straight. A decision tree cannot use the text "Lyon" directly, but a column of 0s and 1s can. Feature engineering is the craft of turning raw data into inputs a model can use well.

This lesson covers the four moves that handle most real tables: scaling numbers, encoding categories, filling gaps, and reshaping skewed values. Each one has a rule about what data it may learn from, and that rule is the subject of the next lesson.

## Scale numbers to a common footing

Standardization subtracts the mean and divides by the standard deviation, so each feature has mean 0 and standard deviation 1. It matters for any method that compares distances or uses gradients: nearest neighbours, logistic regression, neural networks.

```python run
import numpy as np

rng = np.random.default_rng(0)
income = rng.normal(40000, 8000, 6)        # euros
age = rng.normal(40, 10, 6)                # years
X = np.column_stack([income, age])

mean, std = X.mean(axis=0), X.std(axis=0)
Z = (X - mean) / std
print("means after scaling:", Z.mean(axis=0).round(6))
print("standard deviations after scaling:", Z.std(axis=0).round(6))
```

## Encode categories as columns

A category such as "city" has no order, so the number 2 for Paris is not "twice" the number 1 for Lyon. **One-hot encoding** gives each category its own 0/1 column instead.

```python run
cities = np.array(["Lyon", "Paris", "Lyon", "Nice"])
levels = ["Lyon", "Paris", "Nice"]
one_hot = np.array([[c == level for level in levels] for c in cities], dtype=float)
print(one_hot)
```

Each row has exactly one 1, in the column of its city. Keep the category order fixed, so the same city always lands in the same column, including in new data.

## Fill the gaps deliberately

```python run
income_gaps = np.array([42000.0, np.nan, 38000.0, np.nan, 51000.0])
median = np.nanmedian(income_gaps)
filled = np.where(np.isnan(income_gaps), median, income_gaps)
print("median used:", median)
print("filled:", filled)
```

A **missing indicator** can carry information of its own. If people with missing income default more often, add a 0/1 column saying the value was missing, so the model can learn from the gap itself.

## Transform skewed values

Incomes, prices and counts often have a long right tail. A logarithm pulls the tail in, which helps linear models and stabilizes distances.

```python run
prices = np.array([12.0, 15.0, 18.0, 25.0, 40.0, 900.0])
print("raw spread (std):", round(prices.std(), 1))
print("log spread (std):", round(np.log(prices).std(), 3))
```

> **Pitfall:** `log(0)` is minus infinity, so use `log1p(x)`, which computes $\log(1 + x)$, when values can be zero.

> **In the wild:** scikit-learn''s `StandardScaler`, `OneHotEncoder` and `SimpleImputer` implement these steps, and `ColumnTransformer` applies a different one to each column.

```python
# Static: run this on your own machine with scikit-learn installed
from sklearn.preprocessing import StandardScaler, OneHotEncoder

scaled = StandardScaler().fit_transform(X)
encoded = OneHotEncoder().fit_transform(cities.reshape(-1, 1)).toarray()
print(scaled.shape, encoded.shape)
```

## Challenge: standardize with given statistics

```python exercise id=standardize title="Standardize with given statistics"
import numpy as np

# TODO: `standardize(X, mean, std)` returns (X − mean) / std, applied to each column of the 2-D array X.
def standardize(X, mean, std):
    ...
--- solution
import numpy as np

def standardize(X, mean, std):
    return (np.asarray(X, dtype=float) - np.asarray(mean, dtype=float)) / np.asarray(std, dtype=float)
--- test
import numpy as np
X_t = np.array([[1.0, 10.0], [3.0, 30.0]])
result = standardize(X_t, [2.0, 20.0], [1.0, 10.0])
assert result is not None, "Replace the `...` in `standardize` with code that returns the scaled array."
assert np.allclose(result, [[-1.0, -1.0], [1.0, 1.0]]), f"Each column is shifted by its mean and divided by its std, giving [[-1, -1], [1, 1]], but you returned {result}."
assert np.allclose(standardize(np.array([[5.0]]), [5.0], [2.0]), [[0.0]]), "A value equal to the mean becomes 0."
--- hint
Broadcasting handles the columns: `(X - mean) / std` works when `mean` and `std` have one entry per column.
--- hint
`return (np.asarray(X, dtype=float) - mean) / std`.
```

## Challenge: one-hot encode

```python exercise id=one-hot-encode title="One-hot encode a category column"
import numpy as np

# TODO: `one_hot_encode(values, levels)` returns a 2-D array with one row per value and one column per level,
# in the order given by `levels`. Each row has a 1 in the column of its value and 0 elsewhere.
def one_hot_encode(values, levels):
    ...
--- solution
import numpy as np

def one_hot_encode(values, levels):
    index = {level: j for j, level in enumerate(levels)}
    out = np.zeros((len(values), len(levels)))
    for i, v in enumerate(values):
        out[i, index[v]] = 1.0
    return out
--- test
import numpy as np
result = one_hot_encode(["b", "a", "b"], ["a", "b", "c"])
assert result is not None, "Replace the `...` in `one_hot_encode` with code that returns the matrix."
assert result.shape == (3, 3), f"Three values and three levels should give shape (3, 3), but you returned {result.shape}."
assert np.array_equal(result, [[0, 1, 0], [1, 0, 0], [0, 1, 0]]), f"Each row should have a 1 in its level''s column. You returned {result.tolist()}."
assert result.sum(axis=1).tolist() == [1.0, 1.0, 1.0], "Each row must have exactly one 1."
--- hint
Map each level to its column number with a dictionary, then set the matching entry in each row to 1.
--- hint
`index = {level: j for j, level in enumerate(levels)}`, then `out[i, index[v]] = 1.0` in a loop.
```

## Debug the imputation

This gap filler is meant to replace missing incomes with the median, but it fills them with zero, which drags every average down.

```python debug id=impute-zero title="Fill with the median, not zero"
import numpy as np

income = np.array([40000.0, np.nan, 50000.0, 60000.0])
filled = np.where(np.isnan(income), 0.0, income)       # bug: zero is not a plausible income
print("filled:", filled)
--- solution
import numpy as np

income = np.array([40000.0, np.nan, 50000.0, 60000.0])
filled = np.where(np.isnan(income), np.nanmedian(income), income)
print("filled:", filled)
--- test
assert np.isclose(filled[1], 50000.0), f"The gap should be filled with the median of the observed incomes, 50000, but it became {filled[1]}. Zero is not a plausible income."
--- hint
Which summary of the observed incomes describes a typical value without being pulled by extremes?
--- hint
Use `np.nanmedian(income)` as the fill value.
```

## Predict the encoded shape

```python predict id=predict-onehot title="What shape is the encoded matrix?"
import numpy as np
cities = np.array(["Lyon", "Paris", "Lyon", "Nice", "Brest"])
levels = ["Lyon", "Paris", "Nice"]
encoded = np.array([[c == level for level in levels] for c in cities], dtype=float)
print(encoded.shape)
--- options
* (5, 3)
(3, 5)
(5, 1)
(5, 5)
--- explain
There is one row per city value, five in all, and one column per level, three in all. Brest is not a listed level, so its row is all zeros, which is the usual way unseen categories are handled.
```

## Recap

- Standardize numeric features so distances and gradients behave. Use statistics from training data only.
- One-hot encode categories with a fixed order, so the same level always lands in the same column.
- Fill gaps with a justified value such as the median, and consider a missing indicator.
- Log-transform skewed values, and use `log1p` when zeros are possible.

**Up next:** data leakage, the mistake that can make a model look perfect.
', 0, '[]', '[]', '2026-06-25T06:47:21.823Z', '2026-10-19T06:47:21.823Z'),
('les_machine_learning_a_z_4_2', 'sec_machine_learning_a_z_4', 'crs_machine_learning_a_z', 'Avoiding data leakage', 'interactive', 1, 960, NULL, NULL, 'Data leakage is information that reaches the model during training, which will not be available when it makes real predictions. It is the most dangerous mistake in applied machine learning, because it produces excellent scores. The model looks brilliant in the notebook, then fails in production, and nothing in the code raised an error.

There are two common forms. **Preprocessing leakage** happens when a step that learns from data, such as a scaler or an imputer, sees the validation or test rows. **Target leakage** happens when a feature contains information from the future or from the answer itself.

## Target leakage: a feature that knows the answer

Imagine predicting which customers will cancel. A column called `cancellation_fee_waived` is filled in only after a customer cancels. It predicts the target perfectly, and it is useless on the day you need to decide whom to call.

```python run
import numpy as np

rng = np.random.default_rng(0)
n = 400
churn = rng.integers(0, 2, n)
honest = rng.normal(0, 1, n) + 0.3 * churn           # a weak, real signal
leaky = churn + rng.normal(0, 0.05, n)                # written after the outcome is known

def accuracy_of_threshold(feature, labels):
    best = 0
    for t in np.unique(feature):
        best = max(best, np.mean((feature >= t) == labels))
    return best

print("honest feature, best threshold accuracy:", round(accuracy_of_threshold(honest, churn), 3))
print("leaky feature, best threshold accuracy:", round(accuracy_of_threshold(leaky, churn), 3))
```

A near-perfect score from one column is a red flag, not good news. Ask when each column is known, and drop any that are only known after the outcome.

## Preprocessing leakage: the scaler that saw the test set

The effect is smaller but just as wrong. If the scaler''s mean and standard deviation include the test rows, the test rows have influenced the transformation of the training rows.

```python run
rng = np.random.default_rng(1)
train = rng.normal(10, 2, 80)
test = rng.normal(14, 2, 20)                  # the future has drifted upward

honest_mu, honest_sd = train.mean(), train.std()
leaky_mu, leaky_sd = np.concatenate([train, test]).mean(), np.concatenate([train, test]).std()
print("honest scaling of test: mean", round(((test - honest_mu) / honest_sd).mean(), 3))
print("leaky scaling of test:  mean", round(((test - leaky_mu) / leaky_sd).mean(), 3))
```

The honest version shows the drift: the test values sit above the training average, as they should. The leaky version hides it by pulling the scale towards the test values.

Before trusting a feature, check how strongly it tracks the target. A correlation near one with the outcome deserves a question about when the column was written.

```python run
rng = np.random.default_rng(2)
target = rng.integers(0, 2, 100).astype(float)
table = {
    "plain feature": rng.normal(size=100),
    "suspicious feature": target + rng.normal(0, 0.1, 100),
    "another plain feature": rng.normal(size=100),
}
for name, col in table.items():
    print(f"{name:>22}: correlation with target {np.corrcoef(col, target)[0, 1]:+.2f}")
```

## The rule

Every step that learns a number from data must learn it from the training rows only, and then apply that number to everything else. That includes scalers, imputers, encoders, feature selectors and target statistics.

```python run
def scale_with_train(train_part, other_part):
    mu, sd = train_part.mean(axis=0), train_part.std(axis=0)
    return (train_part - mu) / sd, (other_part - mu) / sd

a, b = scale_with_train(train.reshape(-1, 1), test.reshape(-1, 1))
print("test values after honest scaling, mean:", round(b.mean(), 3))
```

> **Pitfall:** calling `fit_transform` on the whole dataset before splitting is the classic version of this mistake. Split first, then fit on the training part, then transform the rest.

> **In the wild:** scikit-learn''s `Pipeline` fits each step inside cross-validation folds, which makes this mistake hard to commit. Its `cross_val_score` applies the whole pipeline correctly to every fold.

```python
# Static: run this on your own machine with scikit-learn installed
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression

model = make_pipeline(StandardScaler(), LogisticRegression())
print(model)
```

## Challenge: scale with training statistics

```python exercise id=scale-with-train title="Scale both sets with the training statistics"
import numpy as np

# TODO: `scale_with_train(X_train, X_test)` returns (Xtr_scaled, Xte_scaled). Compute each column''s mean and standard
# deviation from X_train only, then scale both arrays with those numbers.
def scale_with_train(X_train, X_test):
    ...
--- solution
import numpy as np

def scale_with_train(X_train, X_test):
    X_train = np.asarray(X_train, dtype=float)
    X_test = np.asarray(X_test, dtype=float)
    mu = X_train.mean(axis=0)
    sd = X_train.std(axis=0)
    return (X_train - mu) / sd, (X_test - mu) / sd
--- test
import numpy as np
result = scale_with_train(np.array([[0.0], [2.0]]), np.array([[4.0]]))
assert result is not None, "Replace the `...` in `scale_with_train` with code that returns the two scaled arrays."
tr, te = result
assert np.allclose(tr, [[-1.0], [1.0]]), f"The training values 0 and 2 have mean 1 and std 1, so they become -1 and 1, but you returned {tr.ravel()}."
assert np.allclose(te, [[3.0]]), f"The test value 4 should use the training statistics and become (4 − 1) / 1 = 3, but you returned {te.ravel()}."
--- hint
Compute `mu` and `sd` from `X_train` alone, then apply those same two arrays to `X_test`.
--- hint
`mu = X_train.mean(axis=0)`, `sd = X_train.std(axis=0)`, then return both scaled arrays.
```

## Challenge: find leaky columns

```python exercise id=leaky-columns title="Flag suspiciously strong columns"
import numpy as np

# TODO: `leaky_columns(X, y, threshold)` returns the indices (as a list) of the columns of X whose absolute
# Pearson correlation with y is greater than `threshold`. A constant column has correlation 0.
def leaky_columns(X, y, threshold):
    ...
--- solution
import numpy as np

def leaky_columns(X, y, threshold):
    X = np.asarray(X, dtype=float)
    y = np.asarray(y, dtype=float)
    flagged = []
    for j in range(X.shape[1]):
        col = X[:, j]
        if col.std() == 0 or y.std() == 0:
            continue
        r = np.corrcoef(col, y)[0, 1]
        if abs(r) > threshold:
            flagged.append(j)
    return flagged
--- test
import numpy as np
rng_t = np.random.default_rng(4)
y_t = rng_t.integers(0, 2, 200).astype(float)
X_t = np.column_stack([rng_t.normal(size=200), y_t + rng_t.normal(0, 0.01, 200), np.ones(200)])
result = leaky_columns(X_t, y_t, 0.9)
assert result is not None, "Replace the `...` in `leaky_columns` with code that returns the list of indices."
assert result == [1], f"Only column 1 tracks the target closely, so the answer is [1], but you returned {result}."
assert leaky_columns(X_t, y_t, 1.1) == [], "No correlation can exceed 1, so a threshold above 1 flags nothing."
--- hint
Loop over the columns. For each one, take `np.corrcoef(col, y)[0, 1]` and compare its absolute value with the threshold.
--- hint
Skip constant columns first, since their correlation is undefined.
```

## Debug the fit order

This preprocessing step is meant to scale the training data using training statistics only, but it fits the scaler on the full table first.

```python debug id=fit-before-split title="Fit the scaler on training rows only"
import numpy as np

X_all = np.array([[1.0], [2.0], [3.0], [10.0]])
X_train, X_test = X_all[:3], X_all[3:]
mu = X_all.mean(axis=0)               # bug: the statistics include the test row
sd = X_all.std(axis=0)
print("scaled test value:", ((X_test - mu) / sd).ravel())
--- solution
import numpy as np

X_all = np.array([[1.0], [2.0], [3.0], [10.0]])
X_train, X_test = X_all[:3], X_all[3:]
mu = X_train.mean(axis=0)
sd = X_train.std(axis=0)
print("scaled test value:", ((X_test - mu) / sd).ravel())
--- test
assert np.isclose(mu[0], 2.0), f"The mean should come from the training rows (1, 2, 3), which is 2, but it is {mu[0]}. The test row must not influence the scaler."
assert np.isclose(sd[0], np.std([1.0, 2.0, 3.0])), "The standard deviation should also come from the training rows only."
--- hint
Which rows should the scaler be allowed to see? Only the training rows.
--- hint
Compute `mu` and `sd` from `X_train`, not `X_all`.
```

## Predict the leak

```python predict id=predict-leak title="Which mean is honest?"
import numpy as np
train = np.array([1.0, 2.0, 3.0])
test = np.array([10.0])
print(train.mean(), np.concatenate([train, test]).mean())
--- options
* 2.0 4.0
4.0 2.0
2.0 2.0
10.0 10.0
--- explain
The honest mean comes from the training rows alone: 2.0. Including the test value 10 moves the mean to 4.0, which is the leak. The first printed value is the honest one.
```

## Recap

- Target leakage: drop features that are only known after the outcome, or that are the outcome in disguise.
- Preprocessing leakage: fit every scaler, imputer and encoder on training rows only.
- Split first, fit on the training part, then transform everything else with those numbers.
- A suspiciously perfect score is a sign of leakage until proven otherwise.

**Up next:** pipelines, which make the correct order of steps automatic.
', 0, '[]', '[]', '2026-06-25T06:47:21.823Z', '2026-10-19T06:47:21.823Z'),
('les_machine_learning_a_z_4_3', 'sec_machine_learning_a_z_4', 'crs_machine_learning_a_z', 'Pipelines: fit, transform and predict as one unit', 'interactive', 2, 1080, NULL, NULL, 'A pipeline chains preprocessing steps and a model into a single object with one `fit` and one `predict`. Its purpose is not convenience. It enforces the rule from the last lesson: every step learns from training data only, and the same learned numbers are reused on new data. A model you can save, reload and apply to a new table is also a model you can trust in production, because the preprocessing travels with it.

This lesson builds a small pipeline out of parts you already know, so that you can see what a pipeline does on the inside.

## A transformer has two verbs

Every preprocessing step follows the same protocol. `fit` learns numbers from training data and stores them. `transform` applies the stored numbers to any data. A scaler is the simplest example.

```python run
import numpy as np

class Standardizer:
    def fit(self, X):
        X = np.asarray(X, dtype=float)
        self.mean_ = X.mean(axis=0)
        self.std_ = X.std(axis=0)
        return self

    def transform(self, X):
        return (np.asarray(X, dtype=float) - self.mean_) / self.std_

rng = np.random.default_rng(0)
X_train = rng.normal(5, 2, (50, 2))
X_test = rng.normal(6, 2, (10, 2))
scaler = Standardizer().fit(X_train)
print("learned means:", scaler.mean_.round(2))
print("test scaled with training statistics, mean:", scaler.transform(X_test).mean(axis=0).round(2))
```

The test values are not centred, because the scaler learned from the training rows, which were centred at 5. That is the honest result.

## A model is the last step

A model has the same two verbs in spirit: `fit` learns weights, and `predict` applies them. Here is a linear model in the same style.

```python run
class LinearModel:
    def fit(self, X, y):
        A = np.column_stack([np.ones(len(X)), X])
        self.w_, *_ = np.linalg.lstsq(A, y, rcond=None)
        return self

    def predict(self, X):
        return np.column_stack([np.ones(len(X)), X]) @ self.w_

y_train = 2.0 + X_train @ np.array([1.0, -0.5]) + rng.normal(0, 0.1, 50)
model = LinearModel().fit(scaler.transform(X_train), y_train)
print("weights on scaled features:", model.w_.round(2))
```

## Chain them

A pipeline is a list of steps. Fitting it fits each step in order, passing the transformed data along. Predicting transforms the new data with the already-fitted steps, then predicts.

```python run
class Pipeline:
    def __init__(self, steps):
        self.steps = steps

    def fit(self, X, y):
        data = X
        for step in self.steps[:-1]:
            data = step.fit(data).transform(data)
        self.steps[-1].fit(data, y)
        return self

    def predict(self, X):
        data = X
        for step in self.steps[:-1]:
            data = step.transform(data)
        return self.steps[-1].predict(data)

pipe = Pipeline([Standardizer(), LinearModel()]).fit(X_train, y_train)
print("predictions for three test rows:", pipe.predict(X_test[:3]).round(2))
```

Only one object needs to be trained, saved and applied. Nobody can accidentally scale the test rows with their own statistics, because the scaler inside the pipeline never sees them.

## Why the object matters

```python run
honest = Pipeline([Standardizer(), LinearModel()]).fit(X_train, y_train)
print("pipeline mean of test predictions:", round(float(honest.predict(X_test).mean()), 3))
print("true mean of the test targets:", round(float((2.0 + X_test @ np.array([1.0, -0.5])).mean()), 3))
```

The predictions and the true values share a sensible scale, because every step did its job on the right data.

> **In the wild:** scikit-learn''s `Pipeline` and `ColumnTransformer` follow this exact fit and transform protocol, and `joblib.dump` saves a whole pipeline to a file.

```python
# Static: run this on your own machine with scikit-learn installed
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LinearRegression
import joblib

pipe = make_pipeline(StandardScaler(), LinearRegression()).fit(X_train, y_train)
joblib.dump(pipe, "model.joblib")
```

## Challenge: a standardizer

```python exercise id=standardizer-class title="Write a standardizer with fit and transform"
import numpy as np

# TODO: complete the class. `fit(X)` stores the column means in `self.mean_` and the column standard deviations
# in `self.std_`, then returns self. `transform(X)` returns (X − mean_) / std_ using the stored values.
class Standardizer:
    def fit(self, X):
        ...

    def transform(self, X):
        ...
--- solution
import numpy as np

class Standardizer:
    def fit(self, X):
        X = np.asarray(X, dtype=float)
        self.mean_ = X.mean(axis=0)
        self.std_ = X.std(axis=0)
        return self

    def transform(self, X):
        return (np.asarray(X, dtype=float) - self.mean_) / self.std_
--- test
import numpy as np
s = Standardizer()
returned = s.fit(np.array([[0.0], [2.0]]))
assert returned is not None and returned is s, "fit should return the fitted object itself, so calls can be chained."
assert hasattr(s, "mean_") and hasattr(s, "std_"), "fit must store mean_ and std_ on the object."
assert np.allclose(s.transform(np.array([[4.0]])), [[3.0]]), "With mean 1 and std 1 learned from the training rows, the value 4 should become 3."
assert np.allclose(s.transform(np.array([[1.0]])), [[0.0]]), "The mean itself should become 0."
--- hint
In `fit`, compute the mean and standard deviation over the rows with `axis=0`, store them on `self`, and `return self`.
--- hint
In `transform`, use `self.mean_` and `self.std_`. Do not recompute them from the new data.
```

## Challenge: a pipeline prediction

```python exercise id=pipeline-predict title="Predict with a fitted standardizer and weights"
import numpy as np

# TODO: `make_predictor(mean, std, w)` returns a function `predict(X)`. The function standardizes X with the given
# mean and standard deviation, then returns w[0] + (scaled X) @ w[1:] for each row.
def make_predictor(mean, std, w):
    ...
--- solution
import numpy as np

def make_predictor(mean, std, w):
    mean = np.asarray(mean, dtype=float)
    std = np.asarray(std, dtype=float)
    w = np.asarray(w, dtype=float)

    def predict(X):
        scaled = (np.asarray(X, dtype=float) - mean) / std
        return w[0] + scaled @ w[1:]

    return predict
--- test
import numpy as np
predict = make_predictor([1.0, 0.0], [2.0, 1.0], [0.5, 1.0, -1.0])
assert predict is not None, "Replace the `...` in `make_predictor` with code that returns the predict function."
assert callable(predict), "make_predictor should return a function."
out = predict(np.array([[3.0, 2.0]]))
assert np.allclose(out, [0.5 + 1.0 * 1.0 + (-1.0) * 2.0]), f"The scaled row is [(3 − 1)/2, (2 − 0)/1] = [1, 2], so the prediction is 0.5 + 1 − 2 = −0.5, but you returned {out}."
assert np.allclose(predict(np.array([[1.0, 0.0]])), [0.5]), "A row equal to the means scales to zeros, so the prediction is the intercept."
--- hint
Inside the returned function, scale the input with `(X - mean) / std`, then compute `w[0] + scaled @ w[1:]`.
--- hint
The function captures `mean`, `std` and `w` from the enclosing call, so it always uses the training numbers.
```

## Debug the transform

This pipeline is meant to scale new data with the training statistics, but it refits the scaler on the test data, which quietly changes the numbers.

```python debug id=refit-on-test title="Transform with the fitted scaler"
import numpy as np

class Scaler:
    def fit(self, X):
        self.mean_ = X.mean(axis=0)
        self.std_ = X.std(axis=0)
        return self
    def transform(self, X):
        return (X - self.mean_) / self.std_

train = np.array([[0.0], [2.0]])
test = np.array([[4.0]])
scaler = Scaler().fit(train)
scaled_test = Scaler().fit(test).transform(test)     # bug: a new scaler fitted on the test data
print("scaled test:", scaled_test.ravel())
--- solution
import numpy as np

class Scaler:
    def fit(self, X):
        self.mean_ = X.mean(axis=0)
        self.std_ = X.std(axis=0)
        return self
    def transform(self, X):
        return (X - self.mean_) / self.std_

train = np.array([[0.0], [2.0]])
test = np.array([[4.0]])
scaler = Scaler().fit(train)
scaled_test = scaler.transform(test)
print("scaled test:", scaled_test.ravel())
--- test
assert np.allclose(scaled_test, [[3.0]]), f"The test value 4 should be scaled with the training statistics (mean 1, std 1), giving 3, but it is {scaled_test.ravel()}. Use the fitted scaler''s transform, not a new one."
--- hint
A scaler fitted on the test data learns the test mean, which is 4, so it always returns zero. That hides the real difference.
--- hint
Call `scaler.transform(test)` with the scaler you fitted on `train`.
```

## Predict the output

```python predict id=predict-pipe title="What does the pipeline return for a row equal to the training mean?"
import numpy as np
train = np.array([[1.0], [3.0]])
mean = train.mean(axis=0)
std = train.std(axis=0)
row = np.array([[2.0]])
print(((row - mean) / std).ravel())
--- options
* [0.]
[2.]
[1.]
[-1.]
--- explain
The mean of 1 and 3 is 2, so the row equals the training mean. Subtracting the mean gives 0, and the standardized value is 0.
```

## Recap

- A transformer has `fit` to learn numbers from training data and `transform` to apply them.
- A pipeline chains transformers and a final model, and fits each step on the right data.
- Predicting new data reuses the stored training statistics, never new ones.
- Save the whole pipeline, not its parts, so the preprocessing travels with the model.

**Up next:** searching for good hyperparameters, and doing it without leaking the test set.
', 0, '[]', '[]', '2026-06-25T06:47:21.823Z', '2026-10-19T06:47:21.823Z'),
('les_machine_learning_a_z_4_4', 'sec_machine_learning_a_z_4', 'crs_machine_learning_a_z', 'Checkpoint: features and pipelines', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"Why should the imputer and the scaler be fitted on training rows only?","options":["Because the test rows are too few to matter","Because the learned numbers would otherwise carry information from the rows the model is judged on","Because fitting on all rows is slower","Because scalers cannot be fitted twice"],"answerIndex":1,"explanation":"A learned statistic that includes the test rows leaks information about them into the preprocessing, and the score becomes optimistic."},{"id":"q2","prompt":"A column is only filled in after a customer cancels, and it predicts cancellation perfectly. What is the right action?","options":["Keep it, since it predicts well","Remove it, because it is target leakage and will not be available when predictions are needed","Scale it more carefully","Use it only in the test set"],"answerIndex":1,"explanation":"A feature that is only known after the outcome makes a perfect score meaningless. It cannot be used on the day predictions are needed."},{"id":"q3","prompt":"What does one-hot encoding a category column do?","options":["Assigns each category a number that increases with its importance","Gives each category its own 0/1 column, so the model does not assume an order","Removes rare categories","Averages the target for each category"],"answerIndex":1,"explanation":"Numbers assigned to categories imply an order and a distance that do not exist. Separate 0/1 columns avoid that assumption."},{"id":"q4","prompt":"In a grid search, what is the honest way to estimate the score of the chosen setting?","options":["Report the best cross-validation score","Evaluate the chosen setting once on a test set that the search never saw","Report the training score","Average the scores of all settings"],"answerIndex":1,"explanation":"The cross-validation score that selected the setting is optimistic, because the search picked the best of many. Only a test set untouched by the search gives an unbiased estimate."},{"id":"q5","prompt":"Permutation importance of a feature is large. What does that tell you?","options":["The feature causes the target","The model''s error rises a lot when the feature is shuffled, so the model relies on it","The feature has the largest values","The feature has no correlation with other features"],"answerIndex":1,"explanation":"Permutation importance measures reliance by the model, not causation. Correlated features can also share credit, so the ranking needs care."}]', '[]', '2026-06-25T06:47:21.823Z', '2026-10-19T06:47:21.823Z'),
('les_machine_learning_a_z_5_1', 'sec_machine_learning_a_z_5', 'crs_machine_learning_a_z', 'Hyperparameter search: grid and random', 'interactive', 0, 960, NULL, NULL, 'Most models have settings you choose rather than learn: the depth of a tree, the learning rate of boosting, the strength of a penalty. These are **hyperparameters**, and choosing them well can change a model''s quality more than switching algorithms. The method is simple to state: try candidate settings, score each one on held-out data with cross-validation, and keep the best. The discipline lies in never letting the test set take part.

This lesson tunes the strength of a ridge penalty, the regularized version of linear regression, using the cross-validation you built in lesson 9.

## Ridge regression

Ridge regression adds a penalty $\lambda \lVert w \rVert^2$ to the squared error. It keeps the weights small, which trades a little bias for much less variance. The solution is still in closed form:

$$
w = (X^{\top} X + \lambda I)^{-1} X^{\top} y
$$

```python run
import numpy as np

rng = np.random.default_rng(0)
n, d = 60, 12
X = rng.normal(0, 1, (n, d))
true_w = np.zeros(d)
true_w[:3] = [2.0, -1.0, 0.5]                 # only three features matter
y = X @ true_w + rng.normal(0, 1.0, n)

def ridge(X, y, lam):
    return np.linalg.solve(X.T @ X + lam * np.eye(X.shape[1]), X.T @ y)

for lam in [0.0, 1.0, 20.0]:
    w = ridge(X, y, lam)
    print(f"λ = {lam:>4}: largest |weight| {np.abs(w).max():.2f}, weights on the 9 noise features: {np.abs(w[3:]).sum():.2f}")
```

A larger penalty shrinks the weights, including the ones on the irrelevant features. Too much shrinkage underfits, so the best penalty is somewhere in the middle.

## Grid search with cross-validation

A grid search tries every value in a list, scores each with k-fold cross-validation, and records the average error.

```python run
def cv_error(X, y, lam, k=5, seed=0):
    order = np.random.default_rng(seed).permutation(len(y))
    errors = []
    for fold in np.array_split(order, k):
        train = np.setdiff1d(np.arange(len(y)), fold)
        w = ridge(X[train], y[train], lam)
        errors.append(np.mean((X[fold] @ w - y[fold]) ** 2))
    return np.mean(errors)

grid = [0.01, 0.1, 1.0, 5.0, 20.0, 100.0]
results = {lam: cv_error(X, y, lam) for lam in grid}
for lam, err in results.items():
    print(f"λ = {lam:>6}: cross-validated error {err:.3f}")
best = min(results, key=results.get)
print("best λ:", best)
```

The grid''s error curve has a minimum. Notice that the score is averaged over folds, so one unlucky split cannot pick the winner.

The penalty also changes the size of the weights. This table shows the total weight magnitude as λ grows.

```python run
for lam in [0.1, 1.0, 10.0, 100.0]:
    w = ridge(X, y, lam)
    print(f"λ = {lam:>6}: sum of |weights| {np.abs(w).sum():6.2f}")
```

## Random search

A grid grows fast with more hyperparameters. Sampling candidates at random often finds good settings with fewer trials, because only a few hyperparameters usually matter.

```python run
rng_s = np.random.default_rng(5)
sampled = 10 ** rng_s.uniform(-2, 2, 8)        # eight values, log-uniform between 0.01 and 100
scores = {round(float(lam), 3): cv_error(X, y, lam) for lam in sampled}
print("sampled λ values:", sorted(scores))
print("best sampled λ:", min(scores, key=scores.get))
```

Sample on a logarithmic scale for penalties and learning rates, because the difference between 0.01 and 0.1 matters as much as the difference between 10 and 100.

> **Pitfall:** the search must never see the test set. Tune with cross-validation on the training data, then evaluate the chosen setting once on the test set.

> **In the wild:** scikit-learn''s `GridSearchCV` and `RandomizedSearchCV` wrap this procedure, and `Pipeline` keeps the preprocessing inside each fold.

```python
# Static: run this on your own machine with scikit-learn installed
from sklearn.linear_model import Ridge
from sklearn.model_selection import GridSearchCV

search = GridSearchCV(Ridge(), {"alpha": [0.01, 0.1, 1.0, 10.0, 100.0]}, cv=5)
search.fit(X, y)
print(search.best_params_)
```

## Challenge: ridge weights

```python exercise id=ridge-weights title="Ridge regression weights"
import numpy as np

# TODO: `ridge_weights(X, y, lam)` returns the ridge regression weights w = (XᵀX + λI)⁻¹ Xᵀy as a 1-D array.
def ridge_weights(X, y, lam):
    ...
--- solution
import numpy as np

def ridge_weights(X, y, lam):
    X = np.asarray(X, dtype=float)
    return np.linalg.solve(X.T @ X + lam * np.eye(X.shape[1]), X.T @ np.asarray(y, dtype=float))
--- test
import numpy as np
X_t = np.array([[1.0, 0.0], [0.0, 1.0], [1.0, 1.0]])
y_t = np.array([1.0, 2.0, 3.0])
result = ridge_weights(X_t, y_t, 0.0)
assert result is not None, "Replace the `...` in `ridge_weights` with code that returns the weights."
assert np.allclose(result, [1.0, 2.0]), f"With no penalty this is ordinary least squares, which gives [1, 2] here, but you returned {result}."
shrunk = ridge_weights(X_t, y_t, 10.0)
assert np.linalg.norm(shrunk) < np.linalg.norm(result), "A larger penalty must make the weights smaller."
--- hint
Build `X.T @ X + lam * np.eye(d)`, then solve the linear system against `X.T @ y` with `np.linalg.solve`.
--- hint
`np.linalg.solve(X.T @ X + lam * np.eye(X.shape[1]), X.T @ y)`.
```

## Challenge: pick the best penalty

```python exercise id=best-lambda title="Choose the penalty with the lowest error"
import numpy as np

# TODO: `best_lambda(lams, errors)` returns the value in `lams` whose matching error in `errors` is smallest.
# If several are tied, return the smallest λ.
def best_lambda(lams, errors):
    ...
--- solution
import numpy as np

def best_lambda(lams, errors):
    lams = np.asarray(lams, dtype=float)
    errors = np.asarray(errors, dtype=float)
    best = np.flatnonzero(errors == errors.min())
    return float(lams[best].min())
--- test
result = best_lambda([0.1, 1.0, 10.0], [0.5, 0.2, 0.9])
assert result is not None, "Replace the `...` in `best_lambda` with code that returns the best penalty."
assert result == 1.0, f"The lowest error, 0.2, belongs to λ = 1.0, but you returned {result!r}."
assert best_lambda([3.0, 1.0, 2.0], [0.4, 0.4, 0.9]) == 1.0, "On a tie, return the smallest λ."
--- hint
Find the position of the smallest error with `np.argmin`, then read the λ at that position.
--- hint
`return lams[np.argmin(errors)]`. For the tie rule, use the smallest λ among the tied positions.
```

## Debug the direction of the search

This search is meant to pick the penalty with the lowest error, but it picks the highest.

```python debug id=argmax-error title="Pick the lowest error"
import numpy as np

lams = np.array([0.1, 1.0, 10.0])
errors = np.array([0.5, 0.2, 0.9])
best = lams[np.argmax(errors)]           # bug: argmax finds the largest error
print("best λ:", best)
--- solution
import numpy as np

lams = np.array([0.1, 1.0, 10.0])
errors = np.array([0.5, 0.2, 0.9])
best = lams[np.argmin(errors)]
print("best λ:", best)
--- test
assert best == 1.0, f"Lower error is better, so the best λ is 1.0, but the code picks {best}. Use argmin, not argmax."
--- hint
An error is a cost to minimize. Which function finds the smallest value?
--- hint
Replace `np.argmax` with `np.argmin`.
```

## Predict the number of fits

```python predict id=predict-fits title="How many models does this search train?"
lams = [0.01, 0.1, 1.0, 10.0]
folds = 5
print(len(lams) * folds)
--- options
* 20
4
5
9
--- explain
Each penalty is evaluated on each of the five folds, which trains one model per fold. Four penalties times five folds is 20 models, all trained before the best setting is chosen.
```

## Recap

- Hyperparameters are chosen, not learned, and they often matter more than the algorithm.
- Grid search tries every candidate; random search samples candidates, often on a log scale.
- Score every candidate with cross-validation on training data, and keep the test set out of the search.
- A penalty that is too small overfits and one that is too large underfits. The best value sits between.

**Up next:** explaining predictions, so that the model''s reasoning can be checked and communicated.
', 0, '[]', '[]', '2026-06-25T06:47:21.823Z', '2026-10-19T06:47:21.823Z'),
('les_machine_learning_a_z_5_2', 'sec_machine_learning_a_z_5', 'crs_machine_learning_a_z', 'Explaining predictions: permutation importance and SHAP', 'interactive', 1, 960, NULL, NULL, 'A model that predicts well but cannot say why is hard to trust, hard to debug and hard to act on. Customers, regulators and colleagues will ask what drives the prediction. Interpretability methods answer that question at two levels: which features matter overall, and why one particular prediction came out the way it did.

This lesson builds the most widely useful global method, **permutation importance**, from scratch, and explains how the local method SHAP works and where to use it.

## The idea: break a feature and see what happens

If a feature matters, shuffling its values should make predictions worse. Shuffling keeps the feature''s distribution but breaks its link to the target. The increase in error measures how much the model relied on it.

```python run
import numpy as np

rng = np.random.default_rng(0)
n = 400
X = rng.normal(0, 1, (n, 3))                 # income, age, noise
y = 3.0 * X[:, 0] + 0.5 * X[:, 1] + rng.normal(0, 0.5, n)

w, *_ = np.linalg.lstsq(np.column_stack([np.ones(n), X]), y, rcond=None)
def predict(M):
    return np.column_stack([np.ones(len(M)), M]) @ w

base_error = np.mean((predict(X) - y) ** 2)
print("baseline error:", round(base_error, 3))
for j, name in enumerate(["income", "age", "noise"]):
    shuffled = X.copy()
    shuffled[:, j] = rng.permutation(shuffled[:, j])
    error = np.mean((predict(shuffled) - y) ** 2)
    print(f"{name:>6}: error rises by {error - base_error:.3f} when shuffled")
```

Income matters most, age a little, and the noise column not at all. The ranking is what matters, and it is trustworthy only if you average over several shuffles, since one shuffle is noisy.

## Averaging over shuffles

```python run
def permutation_importance(predict_fn, X, y, j, repeats=10, seed=0):
    rng_p = np.random.default_rng(seed)
    base = np.mean((predict_fn(X) - y) ** 2)
    increases = []
    for _ in range(repeats):
        Xp = X.copy()
        Xp[:, j] = rng_p.permutation(Xp[:, j])
        increases.append(np.mean((predict_fn(Xp) - y) ** 2) - base)
    return float(np.mean(increases))

for j, name in enumerate(["income", "age", "noise"]):
    print(f"{name:>6}: average increase {permutation_importance(predict, X, y, j):.3f}")
```

Averaging the absolute contribution of each feature over all flats gives a summary of its typical influence on one prediction.

```python run
typical = np.mean(np.abs((X - X.mean(axis=0)) * w[1:]), axis=0)
for name, value in zip(["income", "age", "noise"], typical):
    print(f"{name:>6}: average absolute contribution {value:.2f}")
```

## Caution about correlated features

> **Pitfall:** when two features carry the same information, shuffling one lets the model lean on the other, so both look less important than they are. Group correlated features, or check the correlation matrix before reading the ranking.

## Local explanations and SHAP

Permutation importance answers "what matters overall". A local method answers "why this prediction". **SHAP** values split a single prediction into one contribution per feature, adding up to the difference from the average prediction. For a linear model, the contribution of a feature is simply its weight times its deviation from the average.

```python run
row = X[0]
avg = X.mean(axis=0)
contributions = w[1:] * (row - avg)
print("prediction for this row:", round(float(predict(row[None, :])[0]), 2))
print("average prediction:", round(float(predict(avg[None, :])[0]), 2))
print("contribution of each feature:", contributions.round(2))
print("sum of contributions + average = prediction:",
      round(float(predict(avg[None, :])[0] + contributions.sum()), 2))
```

The contributions add up exactly, so the explanation is complete. For non-linear models, SHAP computes the same kind of split with more work, but the promise is the same.

> **In the wild:** the `shap` library computes SHAP values for tree ensembles and neural networks, and `permutation_importance` in scikit-learn implements the global method.

```python
# Static: run this on your own machine with scikit-learn and shap installed
import shap
from sklearn.ensemble import RandomForestRegressor

forest = RandomForestRegressor(n_estimators=100, random_state=0).fit(X, y)
explainer = shap.TreeExplainer(forest)
print(explainer.shap_values(X[:1]))
```

## Challenge: one feature''s importance

```python exercise id=perm-importance title="Permutation importance of one feature"
import numpy as np

# TODO: `permutation_drop(predict_fn, X, y, j, seed)` shuffles column j of X once (with np.random.default_rng(seed)),
# and returns the increase in mean squared error from the shuffled version compared with the original X.
def permutation_drop(predict_fn, X, y, j, seed):
    ...
--- solution
import numpy as np

def permutation_drop(predict_fn, X, y, j, seed):
    X = np.asarray(X, dtype=float)
    base = np.mean((predict_fn(X) - y) ** 2)
    Xp = X.copy()
    Xp[:, j] = np.random.default_rng(seed).permutation(Xp[:, j])
    return float(np.mean((predict_fn(Xp) - y) ** 2) - base)
--- test
import numpy as np
X_t = np.array([[0.0, 1.0], [1.0, 0.0], [2.0, 3.0], [3.0, 2.0]])
y_t = 2.0 * X_t[:, 0]
predict_t = lambda M: 2.0 * M[:, 0]
result = permutation_drop(predict_t, X_t, y_t, 0, 0)
assert result is not None, "Replace the `...` in `permutation_drop` with code that returns the increase."
assert result > 0, f"Column 0 drives the predictions exactly, so shuffling it must raise the error, but you returned {result!r}."
assert np.isclose(permutation_drop(predict_t, X_t, y_t, 1, 0), 0.0), "Column 1 is ignored by the model, so shuffling it changes nothing."
--- hint
Compute the baseline error first. Copy X, replace column j with a shuffled version, and compare the two mean squared errors.
--- hint
`Xp[:, j] = np.random.default_rng(seed).permutation(Xp[:, j])`, then return the difference of the two errors.
```

## Challenge: rank features

```python exercise id=rank-features title="Rank features by importance"
import numpy as np

# TODO: `rank_features(names, importances)` returns the feature names sorted from most to least important.
# Ties keep the original order of the names.
def rank_features(names, importances):
    ...
--- solution
import numpy as np

def rank_features(names, importances):
    order = np.argsort(-np.asarray(importances, dtype=float), kind="stable")
    return [names[i] for i in order]
--- test
result = rank_features(["age", "income", "noise"], [0.1, 2.0, 0.0])
assert result is not None, "Replace the `...` in `rank_features` with code that returns the ranked names."
assert result == ["income", "age", "noise"], f"Income (2.0) is most important, then age (0.1), then noise (0.0), but you returned {result}."
assert rank_features(["a", "b"], [1.0, 1.0]) == ["a", "b"], "On a tie the original order should be kept."
--- hint
Sort the indices by decreasing importance with `np.argsort` on the negated values, then map them back to names.
--- hint
`order = np.argsort(-np.asarray(importances), kind="stable")`, then `[names[i] for i in order]`.
```

## Debug the shuffle

This importance check is meant to shuffle the feature, but it copies the column unchanged, so every feature looks useless.

```python debug id=shuffle-real title="Shuffle the column for real"
import numpy as np

X = np.array([[0.0, 1.0], [1.0, 0.0], [2.0, 3.0], [3.0, 2.0]])
y = 2.0 * X[:, 0]
predict = lambda M: 2.0 * M[:, 0]
Xp = X.copy()
Xp[:, 0] = X[:, 0]                       # bug: the column is copied unchanged, not shuffled
increase = np.mean((predict(Xp) - y) ** 2) - np.mean((predict(X) - y) ** 2)
print("increase:", increase)
--- solution
import numpy as np

X = np.array([[0.0, 1.0], [1.0, 0.0], [2.0, 3.0], [3.0, 2.0]])
y = 2.0 * X[:, 0]
predict = lambda M: 2.0 * M[:, 0]
Xp = X.copy()
Xp[:, 0] = np.random.default_rng(0).permutation(X[:, 0])
increase = np.mean((predict(Xp) - y) ** 2) - np.mean((predict(X) - y) ** 2)
print("increase:", increase)
--- test
assert increase > 0, f"Shuffling the column that drives the model must raise the error, but the increase is {increase}. Permute the column, rather than copying it."
--- hint
An unchanged column can never change the error. The shuffle must reorder the values.
--- hint
`np.random.default_rng(0).permutation(X[:, 0])`.
```

## Predict the contribution

```python predict id=predict-shap title="What does the contribution sum to?"
import numpy as np
prediction = 7.0
average = 5.0
contributions = np.array([1.5, 0.5])
print(average + contributions.sum())
--- options
* 7.0
5.0
2.0
8.0
--- explain
The contributions sum to 2.0, and adding the average of 5.0 gives 7.0, which matches the prediction. This additivity is what makes SHAP explanations complete.
```

## Recap

- Permutation importance measures how much the error rises when a feature is shuffled. Average over several shuffles.
- Correlated features can share credit, so check correlations before reading the ranking.
- SHAP splits one prediction into per-feature contributions that add up exactly to the difference from average.
- Explanations support decisions only when the model itself is sound.

**Up next:** the capstone, which puts the whole course into one churn model.
', 0, '[]', '[]', '2026-06-25T06:47:21.823Z', '2026-10-19T06:47:21.823Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_machine_learning_a_z_6_1', 'sec_machine_learning_a_z_6', 'crs_machine_learning_a_z', 'Capstone: predict customer churn end to end', 'interactive', 0, 1800, NULL, NULL, 'This is the capstone. You will build a customer churn model from raw data to a defensible result, using every idea in the course: a clear target and metric, honest splits, leak-free preprocessing, a model you can explain, a threshold chosen for the business, and an honest test score.

The business question is: **which customers are likely to cancel in the next month, and how many should the retention team call?** The team can call about 100 customers a week, and a wrongly called customer costs a small amount of goodwill, so precision matters as much as recall.

The data are generated in the page and are messy, as real data are.

## Build the dataset

```python run
import numpy as np

def make_churn(n=1200, seed=21):
    rng = np.random.default_rng(seed)
    tenure = rng.integers(1, 61, n).astype(float)                # months as a customer
    spend = rng.gamma(4.0, 12.0, n)                               # monthly spend, euros
    calls = rng.poisson(1.2, n).astype(float)                     # support calls last month
    contract = rng.integers(0, 2, n).astype(float)                # 1 = yearly contract
    age = rng.uniform(18, 80, n)
    score = -0.05 * tenure - 0.01 * spend + 0.6 * calls - 1.2 * contract - 0.01 * age + 1.0
    churn = (rng.random(n) < 1 / (1 + np.exp(-score))).astype(float)
    X = np.column_stack([tenure, spend, calls, contract, age])
    X[rng.random(n) < 0.04, 1] = np.nan                            # 4% of spend values were lost
    return X, churn

X, y = make_churn()
names = ["tenure", "spend", "calls", "yearly contract", "age"]
print("customers:", len(y), "| churn rate:", round(y.mean(), 3))
print("missing spend values:", int(np.isnan(X[:, 1]).sum()))
```

The churn rate is the first thing to report, because a model that predicts "no churn" for everyone already has that accuracy.

## Split first

```python run
order = np.random.default_rng(0).permutation(len(y))
n_test, n_val = int(0.2 * len(y)), int(0.2 * len(y))
test_idx = order[:n_test]
val_idx = order[n_test:n_test + n_val]
train_idx = order[n_test + n_val:]
print("train:", len(train_idx), "| validation:", len(val_idx), "| test:", len(test_idx))
```

The test set is set aside now and used once, at the very end.

## Preprocess with training statistics only

```python run
def fit_preprocessor(X_train):
    median = np.nanmedian(X_train, axis=0)
    filled = np.where(np.isnan(X_train), median, X_train)
    mean, std = filled.mean(axis=0), filled.std(axis=0)
    return {"median": median, "mean": mean, "std": std}

def apply_preprocessor(prep, X):
    filled = np.where(np.isnan(X), prep["median"], X)
    return (filled - prep["mean"]) / prep["std"]

prep = fit_preprocessor(X[train_idx])
A_train = apply_preprocessor(prep, X[train_idx])
A_val = apply_preprocessor(prep, X[val_idx])
A_test = apply_preprocessor(prep, X[test_idx])
print("train mean after preprocessing:", A_train.mean(axis=0).round(3))
```

Every number the preprocessing needs, including the median and the scale, comes from the training rows, and it is then applied unchanged to the validation and test rows.

## Train a logistic model

```python run
def fit_logistic(A, y, steps=800, lr=0.3):
    Z = np.column_stack([np.ones(len(A)), A])
    w = np.zeros(Z.shape[1])
    for _ in range(steps):
        p = 1 / (1 + np.exp(-(Z @ w)))
        w -= lr * (Z.T @ (p - y)) / len(y)
    return w

def score(w, A):
    Z = np.column_stack([np.ones(len(A)), A])
    return 1 / (1 + np.exp(-(Z @ w)))

w = fit_logistic(A_train, y[train_idx])
print("weights (intercept first):", w.round(2))
print("features that raise churn risk:", [n for n, wt in zip(names, w[1:]) if wt > 0])
```

The weights have the signs of the rule behind the data: calls and spend-related effects push risk one way, while tenure and yearly contracts push it down.

## Measure on validation data

```python run
def metrics_at(scores, labels, threshold):
    flagged = scores >= threshold
    tp = np.sum(flagged & (labels == 1))
    fp = np.sum(flagged & (labels == 0))
    fn = np.sum(~flagged & (labels == 1))
    precision = tp / (tp + fp) if tp + fp else 0.0
    recall = tp / (tp + fn) if tp + fn else 0.0
    return precision, recall

val_scores = score(w, A_val)
val_labels = y[val_idx]
p, r = metrics_at(val_scores, val_labels, 0.5)
print("at threshold 0.5: precision", round(p, 3), "| recall", round(r, 3))
```

The default threshold of 0.5 is a convention, not a decision. The retention team has a call budget, so the threshold should be chosen for the business.

## Choose the threshold for the budget

```python run
for t in [0.3, 0.4, 0.5, 0.6]:
    flagged = int((val_scores >= t).sum())
    p, r = metrics_at(val_scores, val_labels, t)
    print(f"threshold {t}: flags {flagged:>3} customers, precision {p:.2f}, recall {r:.2f}")
```

Choose the threshold where the number of flagged customers fits the call budget and the precision is acceptable. Those two numbers are the business trade-off, and only the team can judge which mix is worth paying for.

## Explain the model

```python run
rng_e = np.random.default_rng(3)
base = np.mean((score(w, A_val) - val_labels) ** 2)
for j, name in enumerate(names):
    shuffled = A_val.copy()
    shuffled[:, j] = rng_e.permutation(shuffled[:, j])
    drop = np.mean((score(w, shuffled) - val_labels) ** 2) - base
    print(f"{name:>16}: error rises by {drop:.4f} when shuffled")
```

## Report once, on the test set

```python run
A_final = A_test
test_scores = score(w, A_final)
test_labels = y[test_idx]
p, r = metrics_at(test_scores, test_labels, 0.4)
print(f"test set at threshold 0.4: precision {p:.2f}, recall {r:.2f}")
print("limits: one synthetic dataset, a simple linear model, and a threshold chosen on validation data")
```

The test score is the one number you report, and you report it once.

## Challenge: AUC from pairs

```python exercise id=auc-pairs title="AUC from pairs"
import numpy as np

# TODO: `auc(scores, labels)` returns the fraction of (positive, negative) pairs in which the positive has the higher
# score, counting a tie as one half. Labels are 0 or 1 and both classes are present.
def auc(scores, labels):
    ...
--- solution
import numpy as np

def auc(scores, labels):
    scores = np.asarray(scores, dtype=float)
    labels = np.asarray(labels)
    pos, neg = scores[labels == 1], scores[labels == 0]
    wins = (pos[:, None] > neg[None, :]).sum() + 0.5 * (pos[:, None] == neg[None, :]).sum()
    return float(wins / (len(pos) * len(neg)))
--- test
import numpy as np
result = auc([0.9, 0.8, 0.4, 0.7, 0.3, 0.2, 0.1], [1, 1, 1, 0, 0, 0, 0])
assert result is not None, "Replace the `...` in `auc` with code that returns the AUC."
assert np.isclose(result, 11 / 12), f"Eleven of the twelve positive-negative pairs are ordered correctly, so the AUC is 11/12, but you returned {result!r}."
assert np.isclose(auc([0.1, 0.9], [0, 1]), 1.0), "A perfect ranking has AUC 1."
assert np.isclose(auc([0.9, 0.1], [0, 1]), 0.0), "A reversed ranking has AUC 0."
assert np.isclose(auc([0.5, 0.5], [0, 1]), 0.5), "A tie counts as one half."
--- hint
Split the scores into the positives and the negatives. Compare every pair with a broadcast, count the wins, and count ties as half.
--- hint
`pos[:, None] > neg[None, :]` gives a grid of all pairs. Sum it, add half the ties, and divide by the number of pairs.
```

## Challenge: choose a threshold

```python exercise id=choose-threshold title="Threshold for a precision target"
import numpy as np

# TODO: `choose_threshold(scores, labels, min_precision)` looks at every distinct score as a candidate threshold t,
# flagging rows with score >= t. Among the thresholds whose precision is at least `min_precision`, return the one with
# the highest recall. If several have that recall, return the highest threshold. If none qualify, return None.
def choose_threshold(scores, labels, min_precision):
    ...
--- solution
import numpy as np

def choose_threshold(scores, labels, min_precision):
    scores = np.asarray(scores, dtype=float)
    labels = np.asarray(labels)
    best_t, best_recall = None, -1.0
    for t in np.unique(scores):
        flagged = scores >= t
        tp = np.sum(flagged & (labels == 1))
        fp = np.sum(flagged & (labels == 0))
        fn = np.sum(~flagged & (labels == 1))
        precision = tp / (tp + fp) if tp + fp else 0.0
        recall = tp / (tp + fn) if tp + fn else 0.0
        if precision >= min_precision and (recall > best_recall or (recall == best_recall and t > best_t)):
            best_t, best_recall = t, recall
    return None if best_t is None else float(best_t)
--- test
scores = [0.9, 0.8, 0.7, 0.6, 0.2]
labels = [1, 1, 0, 1, 0]
result = choose_threshold(scores, labels, 0.6)
assert result is not None, "Replace the `...` in `choose_threshold` with code that returns the threshold."
assert np.isclose(result, 0.6), f"Thresholds 0.6 and 0.2 both reach recall 1 with precision at least 0.6, and the higher one is 0.6, but you returned {result!r}."
assert np.isclose(choose_threshold(scores, labels, 0.9), 0.8), "With precision at least 0.9 the best recall is 2/3, at threshold 0.8."
assert choose_threshold(scores, labels, 1.1) is None, "If no threshold reaches the precision target, return None."
--- hint
Loop over `np.unique(scores)`. For each candidate compute precision and recall as in the metrics lesson, and keep the best qualifying one.
--- hint
Compare the recall first, and break ties by keeping the higher threshold.
```

## Debug the training rows

This capstone step is meant to train on the training rows only, but it fits the model on every row.

```python debug id=train-only-fit title="Train on the training rows only"
import numpy as np

rng_d = np.random.default_rng(1)
A = rng_d.normal(size=(20, 2))
y = (A[:, 0] > 0).astype(float)
train_idx = np.arange(12)
rows_used = len(A)                       # bug: the fit should use only the training rows
print("rows used for fitting:", rows_used)
--- solution
import numpy as np

rng_d = np.random.default_rng(1)
A = rng_d.normal(size=(20, 2))
y = (A[:, 0] > 0).astype(float)
train_idx = np.arange(12)
rows_used = len(train_idx)
print("rows used for fitting:", rows_used)
--- test
assert rows_used == len(train_idx), f"The model should be fitted on the {len(train_idx)} training rows only, but it uses {rows_used}. Validation and test rows must not influence the weights."
--- hint
Which index array defines the training rows?
--- hint
Count the rows of the training index, `len(train_idx)`, not of the whole table.
```

## Predict the threshold count

```python predict id=predict-flags title="How many customers are flagged at threshold 0.5?"
import numpy as np
scores = np.array([0.2, 0.5, 0.7, 0.9])
print(int((scores >= 0.5).sum()))
--- options
* 3
2
4
1
--- explain
The threshold is inclusive, so a score exactly equal to 0.5 is flagged too. Three of the four scores are at or above 0.5.
```

## Recap

- Report the base churn rate first, and measure against it.
- Split once for the test set, then split the rest into training and validation.
- Fit every preprocessing step and the model on training rows only, and apply them unchanged elsewhere.
- Choose the threshold for the business budget, explain the model, and report the test score once.

**Congratulations.** You have built a complete machine-learning project. The final assessment checks the whole course.
', 0, '[]', '[]', '2026-06-25T06:47:21.823Z', '2026-10-19T06:47:21.823Z'),
('les_machine_learning_a_z_6_2', 'sec_machine_learning_a_z_6', 'crs_machine_learning_a_z', 'Final assessment: Practical Machine Learning', 'quiz', 1, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"A project reports 94% accuracy on the test set, but the base churn rate is 6%. What is the most important thing to check before trusting the number?","options":["Whether precision and recall on the churn class are good, compared with a baseline that never predicts churn","Whether the model has more than 100 features","Whether the test set was used to choose the threshold","Whether the scaler was fitted on the full dataset"],"answerIndex":0,"explanation":"A model that never predicts churn already gets 94% accuracy. Precision and recall on the positive class, against a baseline, show whether the model does real work."},{"id":"q2","prompt":"Why is the threshold of 0.5 usually not the right one for a retention campaign?","options":["0.5 is always wrong for probabilities","The threshold should match the number of customers the team can call and the cost of wrong calls","0.5 can only be used with neural networks","Thresholds must be negative"],"answerIndex":1,"explanation":"The threshold is a business decision. It trades how many customers are flagged against precision and recall, and should match the budget."},{"id":"q3","prompt":"A linear model''s coefficient on a standardized feature is 0.8. What does that mean?","options":["The feature causes a change of 0.8 in the target","A one standard deviation increase in the feature is associated with a 0.8 increase in the predicted score, holding the others fixed","The feature explains 80% of the variance","The feature is 80% of the prediction"],"answerIndex":1,"explanation":"After standardization, coefficients compare features on one scale. The effect is an association with the other features held fixed, not a proof of causation."},{"id":"q4","prompt":"Which sequence respects the rules of a clean machine-learning project?","options":["Scale all data, split, tune on the test set, report the test score","Split, fit preprocessing on training rows, tune with validation, report the test score once","Train on everything, then split to report","Tune on the test set, then split again"],"answerIndex":1,"explanation":"Splitting first and fitting every step on training rows keeps information from the test set out. Tuning on validation data and reporting the test score once gives an honest estimate."},{"id":"q5","prompt":"Gradient boosting and random forests both combine many trees. What is the key difference?","options":["Boosting trains trees independently; forests train them in sequence","Forests average independent trees trained on bootstrap samples; boosting fits each new tree to the residuals of the ensemble so far","Forests cannot be used for classification","Boosting never uses a learning rate"],"answerIndex":1,"explanation":"Forests reduce variance by averaging independent trees. Boosting reduces bias by fitting each new tree to what the ensemble still gets wrong."},{"id":"q6","prompt":"A model''s training error is very low, and its validation error is much higher. Which change is most likely to help?","options":["Use the training error to choose the model","Constrain the model: simpler trees, regularization, or more data","Add more features that were only known after the outcome","Remove the validation set so the model sees more data"],"answerIndex":1,"explanation":"A large gap between training and validation error means the model is overfitting. Constraining it or adding data narrows that gap."}]', '[]', '2026-06-25T06:47:21.823Z', '2026-10-19T06:47:21.823Z');

INSERT INTO path_courses (path_id, course_id, position) VALUES
('pth_ml_engineer', 'crs_machine_learning_a_z', 4);

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_machine_learning_a_z_1', 'usr_seed00000b', 'crs_machine_learning_a_z', 4, 'Finally clicked', 'I''d tried learning this from scattered blog posts and papers. Having a single coherent narrative with good visuals made it click. The capstone tied everything together.', '2026-09-10T13:47:21.823Z', '2026-09-10T13:47:21.823Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000b');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_machine_learning_a_z_2', 'usr_seed00000q', 'crs_machine_learning_a_z', 5, 'Solid and practical', 'Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I''d take another course from this instructor.', '2026-10-22T13:47:21.823Z', '2026-10-22T13:47:21.823Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000q');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_machine_learning_a_z_3', 'usr_seed00001m', 'crs_machine_learning_a_z', 5, 'Great instructor, great community', 'Questions in the Q&A got thoughtful answers quickly. The notes feature and lesson resources made it easy to review before my exam.', '2026-10-04T22:47:21.823Z', '2026-10-04T22:47:21.823Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001m');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_machine_learning_a_z_4', 'usr_seed00001u', 'crs_machine_learning_a_z', 4, 'Best course I''ve taken on the topic', 'The explanations build intuition before the math, and every concept is backed by code you actually run. I finally understand what''s happening under the hood instead of copying snippets.', '2026-10-08T07:47:21.823Z', '2026-10-08T07:47:21.823Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001u');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_machine_learning_a_z_5', 'usr_seed00002u', 'crs_machine_learning_a_z', 5, 'Worth every minute', 'Clear, well-paced and incredibly practical. The projects were challenging in the right way, and I used what I learned at work within a week of finishing.', '2026-10-18T00:47:21.823Z', '2026-10-18T00:47:21.823Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002u');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_machine_learning_a_z_6', 'usr_seed00002y', 'crs_machine_learning_a_z', 4, 'Helped me land an ML role', 'I was a backend engineer trying to move into ML. This course gave me the vocabulary and the hands-on confidence to pass technical interviews. Highly recommended.', '2026-09-09T05:47:21.823Z', '2026-09-09T05:47:21.823Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002y');

UPDATE courses SET rating_avg = coalesce((SELECT avg(rating) FROM reviews WHERE course_id = 'crs_machine_learning_a_z'), 0), rating_count = (SELECT count(*) FROM reviews WHERE course_id = 'crs_machine_learning_a_z') WHERE id = 'crs_machine_learning_a_z';
