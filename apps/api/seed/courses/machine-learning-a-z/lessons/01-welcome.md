Welcome to **Practical Machine Learning**. Machine learning is the craft of getting a computer to make useful predictions from examples. A model is only a function with adjustable parts, and the parts are set by looking at data. What makes the craft hard is everything around the model: deciding what to predict, preparing the inputs, judging the result honestly, and explaining it to the people who will act on it.

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
