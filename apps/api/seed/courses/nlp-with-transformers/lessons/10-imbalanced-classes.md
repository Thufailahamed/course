Real text datasets are usually imbalanced. Most support tickets are routine, most reviews are positive, and the rare class is often the one that matters most, such as urgent complaints or fraud reports. A classifier that always predicts the common class can score high accuracy and find nothing useful. Evaluation must therefore look at each class, and the standard summary for that is **macro-F1**, the average of the per-class F1 scores, where every class counts equally.

## Accuracy hides the rare class

```python run
import numpy as np

y_true = np.array([0] * 95 + [1] * 5)               # 95 routine tickets, 5 urgent ones
y_pred = np.zeros(100, dtype=int)                    # a model that always says "routine"
accuracy = np.mean(y_true == y_pred)
urgent_recall = np.sum((y_true == 1) & (y_pred == 1)) / np.sum(y_true == 1)
print("accuracy:", accuracy, "| urgent recall:", urgent_recall)
```

Ninety-five per cent accuracy, and not one urgent ticket found. The per-class numbers reveal the failure at once.

## Per-class F1

For each class, F1 combines its precision and recall. Averaging the per-class values gives every class the same weight, however large it is.

```python run
def f1_for_class(y_true, y_pred, c):
    tp = np.sum((y_pred == c) & (y_true == c))
    fp = np.sum((y_pred == c) & (y_true != c))
    fn = np.sum((y_pred != c) & (y_true == c))
    if tp == 0:
        return 0.0
    p, r = tp / (tp + fp), tp / (tp + fn)
    return 2 * p * r / (p + r)

f1_routine = f1_for_class(y_true, y_pred, 0)
f1_urgent = f1_for_class(y_true, y_pred, 1)
print("F1 routine:", round(f1_routine, 3), "| F1 urgent:", f1_urgent)
print("macro-F1:", round((f1_routine + f1_urgent) / 2, 3))
```

The routine class scores 0.97, the urgent class scores 0, and their average is 0.49. The average is far below what accuracy suggested, and the per-class scores show exactly where the failure is.

## Class weights

One way to make training attend to the rare class is to weight its errors more. Inverse-frequency weights make each class contribute equally to the loss on average.

```python run
classes, counts = np.unique(y_true, return_counts=True)
weights = len(y_true) / (len(classes) * counts)
print("class weights:", dict(zip(classes.tolist(), np.round(weights, 3).tolist())))
```

> **Pitfall:** balancing by oversampling the rare class must happen only on the training data. Duplicating rare examples before the split puts copies of the same text on both sides, which inflates every score.

> **In the wild:** support, moderation and fraud teams report macro-F1 and per-class recall because the classes they care about are usually the rare ones.

Accuracy hides the minority class. With 95 negatives and 5 positives, always predicting negative scores 95%, which is why per-class measures come first.

```python run
import numpy as np
y_imb = np.array([0] * 95 + [1] * 5)
print("always-negative accuracy:", round(float(np.mean(y_imb == 0)), 2))
```

## Challenge: macro-F1

```python exercise id=macro-f1 title="Macro-averaged F1"
import numpy as np

# TODO: `macro_f1(y_true, y_pred, classes)` returns the unweighted mean over `classes` of the per-class F1 score. The F1 of a
# class is 0 when it has no true positives.
def macro_f1(y_true, y_pred, classes):
    ...
--- solution
import numpy as np

def macro_f1(y_true, y_pred, classes):
    y_true = np.asarray(y_true)
    y_pred = np.asarray(y_pred)
    scores = []
    for c in classes:
        tp = np.sum((y_pred == c) & (y_true == c))
        fp = np.sum((y_pred == c) & (y_true != c))
        fn = np.sum((y_pred != c) & (y_true == c))
        if tp == 0:
            scores.append(0.0)
            continue
        p, r = tp / (tp + fp), tp / (tp + fn)
        scores.append(2 * p * r / (p + r))
    return float(np.mean(scores))
--- test
result = macro_f1([0, 0, 1, 1], [0, 1, 1, 1], [0, 1])
assert result is not None, "Replace the `...` in `macro_f1` with code that returns the score."
expected = (2 / 3 + 0.8) / 2
assert abs(result - expected) < 1e-9, f"Class 0 has F1 2/3 and class 1 has F1 0.8, so macro-F1 is {expected:.4f}, but you returned {result!r}."
assert macro_f1([0, 1], [0, 1], [0, 1]) == 1.0, "Perfect predictions give macro-F1 of one."
--- hint
Compute the F1 of each class separately with true positives, false positives and false negatives, then average the list.
--- hint
Keep a list of per-class scores and return `np.mean(scores)`.
```

## Challenge: inverse-frequency weights

```python exercise id=class-weights title="Inverse-frequency class weights"
import numpy as np

# TODO: `class_weights(y, k)` returns an array of k weights, one per class 0 to k − 1, equal to n / (k × count of the class),
# where n is the number of labels. A class that does not appear gets weight 0.
def class_weights(y, k):
    ...
--- solution
import numpy as np

def class_weights(y, k):
    y = np.asarray(y)
    n = len(y)
    counts = np.bincount(y, minlength=k).astype(float)
    return np.where(counts > 0, n / (k * np.maximum(counts, 1)), 0.0)
--- test
import numpy as np
result = class_weights([0, 0, 0, 1], 2)
assert result is not None, "Replace the `...` in `class_weights` with code that returns the weights."
assert np.allclose(result, [4 / 6, 4 / 2]), f"With n = 4 and k = 2, class 0 has count 3 and class 1 has count 1, so the weights are 4/6 and 4/2, but you returned {result}."
assert np.allclose(class_weights([0, 1], 2), [1.0, 1.0]), "A balanced dataset gives equal weights of one."
--- hint
Count each class with `np.bincount(y, minlength=k)`, then divide the number of labels by `k` times each count.
--- hint
`n / (k * counts)`, guarding against zero counts.
```

## Debug the weight direction

These class weights are meant to give the rare class the larger weight, but they use the count instead of its inverse, so the common class is favoured.

```python debug id=weight-direction title="Rare classes get larger weights"
import numpy as np

y = np.array([0, 0, 0, 1])
counts = np.bincount(y, minlength=2)
weights = counts / len(y)                # bug: this gives the common class the larger weight
print("weights:", np.round(weights, 3))
--- solution
import numpy as np

y = np.array([0, 0, 0, 1])
counts = np.bincount(y, minlength=2)
weights = len(y) / (2 * counts)
print("weights:", np.round(weights, 3))
--- test
assert weights[1] > weights[0], f"The rare class 1 must get the larger weight, but the weights are {weights}. Use the inverse of the frequency."
--- hint
Weights should be large for rare classes, which means inverse to the count.
--- hint
Divide the number of labels by the count, rather than the other way round.
```

## Predict the macro-F1

```python predict id=predict-macro title="What is the macro-F1 when one class scores 1.0 and the other 0.0?"
import numpy as np
print(np.mean([1.0, 0.0]))
--- options
* 0.5
1.0
0.0
0.25
--- explain
Macro-F1 averages the per-class scores with equal weight, so one perfect class and one failed class average to one half, however many examples each has.
```
