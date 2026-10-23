A pipeline chains preprocessing steps and a model into a single object with one `fit` and one `predict`. Its purpose is not convenience. It enforces the rule from the last lesson: every step learns from training data only, and the same learned numbers are reused on new data. A model you can save, reload and apply to a new table is also a model you can trust in production, because the preprocessing travels with it.

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

> **In the wild:** scikit-learn's `Pipeline` and `ColumnTransformer` follow this exact fit and transform protocol, and `joblib.dump` saves a whole pipeline to a file.

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
assert np.allclose(scaled_test, [[3.0]]), f"The test value 4 should be scaled with the training statistics (mean 1, std 1), giving 3, but it is {scaled_test.ravel()}. Use the fitted scaler's transform, not a new one."
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
