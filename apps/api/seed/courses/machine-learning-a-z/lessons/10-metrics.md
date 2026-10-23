Accuracy, the share of correct predictions, is the metric everyone reaches for first, and it is often the wrong one. A fraud detector that never flags anything can be 99% accurate when only 1% of payments are fraudulent, and it is completely useless. Choosing a metric means deciding which mistakes matter, and then measuring exactly those.

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

> **In the wild:** scikit-learn's `precision_score`, `recall_score`, `f1_score` and `roc_auc_score` compute these, and `confusion_matrix` returns the four counts.

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
