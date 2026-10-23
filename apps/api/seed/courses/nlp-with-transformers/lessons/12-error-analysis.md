A metric tells you how much a model is wrong, but not where or why. Error analysis answers those questions: which classes get confused with which, which kinds of input fail, and whether the failures share a pattern you could fix. It is the step most often skipped, and it is the step that turns a score into a decision.

## The confusion matrix

A confusion matrix counts every pair of true and predicted labels. Rows are true classes and columns are predicted classes, so the diagonal holds the correct predictions.

```python run
import numpy as np

labels = ["complaint", "praise", "question"]
y_true = np.array([0, 0, 0, 1, 1, 2, 2, 2, 2])
y_pred = np.array([0, 2, 0, 1, 1, 2, 2, 0, 2])
conf = np.zeros((3, 3), dtype=int)
for t, p in zip(y_true, y_pred):
    conf[t, p] += 1
print("rows = true, columns = predicted")
print(conf)
```

Each off-diagonal entry is a specific mistake. Here a complaint was labelled as a question once, and a question was labelled as a complaint once.

## Where the errors concentrate

The largest off-diagonal entry is the first place to look. Read the examples behind it before deciding what to change.

```python run
off = conf.copy()
np.fill_diagonal(off, 0)
i, j = np.unravel_index(np.argmax(off), off.shape)
print(f"largest confusion: true '{labels[i]}' predicted as '{labels[j]}' ({off[i, j]} cases)")
```

## Errors by input length

Failures often cluster on certain inputs. Bucketing examples by length can reveal that the model struggles with long texts, which is a fixable problem, such as truncation.

```python run
def length_bucket(n_tokens):
    if n_tokens < 5:
        return "short"
    if n_tokens < 10:
        return "medium"
    return "long"

texts = [3, 4, 7, 12, 15, 2, 9, 11]
errors = [1, 0, 0, 1, 1, 0, 0, 1]
for bucket in ["short", "medium", "long"]:
    idx = [i for i, n in enumerate(texts) if length_bucket(n) == bucket]
    rate = np.mean([errors[i] for i in idx]) if idx else float("nan")
    print(f"{bucket:>6}: error rate {rate:.2f} over {len(idx)} examples")
```

> **Pitfall:** a few examples can suggest a pattern that is not there. Count each bucket, and treat rates from small groups as tentative.

> **In the wild:** teams read a sample of errors each week, group them into categories, and track the categories, because the largest category is usually where a fix pays off.

Per-class recall reads the confusion matrix by rows: each diagonal entry divided by its row total is how often that true class is found.

```python run
import numpy as np
conf_ex = np.array([[5, 1], [2, 7]])
print("per-class recall:", np.round(np.diag(conf_ex) / conf_ex.sum(axis=1), 3))
```

## Challenge: confusion matrix

```python exercise id=confusion-matrix title="Build a confusion matrix"
import numpy as np

# TODO: `confusion(y_true, y_pred, k)` returns a k × k integer array whose entry [t, p] counts the examples with true
# class t predicted as class p.
def confusion(y_true, y_pred, k):
    ...
--- solution
import numpy as np

def confusion(y_true, y_pred, k):
    M = np.zeros((k, k), dtype=int)
    for t, p in zip(y_true, y_pred):
        M[t, p] += 1
    return M
--- test
import numpy as np
result = confusion([0, 0, 1], [0, 1, 1], 2)
assert result is not None, "Replace the `...` in `confusion` with code that returns the matrix."
assert np.array_equal(result, [[1, 1], [0, 1]]), f"Rows are true classes: class 0 is predicted correctly once and as 1 once; class 1 is predicted correctly once. Expected [[1, 1], [0, 1]], but you returned {result.tolist()}."
assert result.sum() == 3, "Every example is counted exactly once."
--- hint
Loop over the pairs and increment the cell in row = true class, column = predicted class.
--- hint
`M[t, p] += 1`.
```

## Challenge: length bucket

```python exercise id=length-bucket title="Assign an input to a length bucket"
# TODO: `length_bucket(n)` returns "short" when n is less than 5, "medium" when n is at least 5 and less than 10, and "long"
# otherwise.
def length_bucket(n):
    ...
--- solution
def length_bucket(n):
    if n < 5:
        return "short"
    if n < 10:
        return "medium"
    return "long"
--- test
assert length_bucket(3) == "short", "Three tokens is short."
assert length_bucket(5) == "medium", "Five is the first medium length."
assert length_bucket(9) == "medium", "Nine is still medium."
assert length_bucket(10) == "long", "Ten and above is long."
--- hint
Check the boundaries in order: below five first, then below ten, and everything else is long.
--- hint
Use two `if` statements with the cut-off values 5 and 10.
```

## Debug the orientation

This confusion matrix is meant to have true classes as rows, but the indices are swapped, so the rows are predicted classes.

```python debug id=transposed-confusion title="Rows are the true classes"
import numpy as np

y_true, y_pred = [0, 0, 1], [0, 1, 1]
M = np.zeros((2, 2), dtype=int)
for t, p in zip(y_true, y_pred):
    M[p, t] += 1                       # bug: rows and columns are swapped
print(M)
--- solution
import numpy as np

y_true, y_pred = [0, 0, 1], [0, 1, 1]
M = np.zeros((2, 2), dtype=int)
for t, p in zip(y_true, y_pred):
    M[t, p] += 1
print(M)
--- test
assert np.array_equal(M, [[1, 1], [0, 1]]), f"Rows must be the true classes, so the matrix should be [[1, 1], [0, 1]], but it is {M.tolist()}. Index the row by the true label."
--- hint
In the convention used here, the row index is the true class.
--- hint
Index `M[t, p]`, not `M[p, t]`.
```

## Predict the error count

```python predict id=predict-err title="How many errors does this confusion matrix record?"
import numpy as np
conf = np.array([[5, 1], [2, 7]])
print(int(conf.sum() - np.trace(conf)))
--- options
* 3
2
1
14
--- explain
The total is 15 and the diagonal sums to 12, so 3 entries are off the diagonal, which are the errors.
```
