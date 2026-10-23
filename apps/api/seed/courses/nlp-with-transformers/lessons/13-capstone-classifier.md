This is the capstone. You will build a text classifier end to end, the way a careful team would: split the data first, learn the vocabulary and weights from training text only, train a model, compare it with a baseline, measure per-class quality, and analyse the errors. The task is to classify short product reviews as positive or negative.

The reviews are generated from templates in the page, so the dataset is reproducible and you can see exactly what the model is learning from.

## Build the dataset

```python run
import numpy as np

rng = np.random.default_rng(7)
positive_adj = ["great", "excellent", "lovely", "reliable", "fast", "happy"]
negative_adj = ["broken", "awful", "slow", "faulty", "late", "poor"]
items = ["battery", "screen", "delivery", "service", "charger", "speaker"]

def make_review(label):
    adjs = positive_adj if label == 1 else negative_adj
    item = rng.choice(items)
    a1, a2 = rng.choice(adjs, 2, replace=False)
    return f"the {item} was {a1} and {a2}", label

data = [make_review(int(rng.integers(0, 2))) for _ in range(90)]
texts = [t for t, _ in data]
labels = np.array([l for _, l in data])
print("examples:", len(texts), "| positive share:", round(float(labels.mean()), 2))
print("first example:", texts[0], "->", labels[0])
```

## Split first

```python run
order = rng.permutation(len(texts))
test_idx, train_idx = order[:27], order[27:]
train_texts = [texts[i] for i in train_idx]
test_texts = [texts[i] for i in test_idx]
y_train, y_test = labels[train_idx], labels[test_idx]
print("train:", len(train_texts), "| test:", len(test_texts))
```

The test reviews are set aside before any vocabulary or weight is learned.

## Learn the vocabulary and idf from training text only

```python run
from collections import Counter
import math

vocab = sorted({w for t in train_texts for w in t.split()})
index = {w: i for i, w in enumerate(vocab)}
n_docs = len(train_texts)
df = Counter(w for t in train_texts for w in set(t.split()))
idf = np.array([math.log(n_docs / df[w]) for w in vocab])

def vectorize(text):
    v = np.zeros(len(vocab))
    for w in text.split():
        if w in index:
            v[index[w]] += 1
    return v * idf

X_train = np.stack([vectorize(t) for t in train_texts])
X_test = np.stack([vectorize(t) for t in test_texts])
print("feature size:", X_train.shape[1], "| unseen test words are ignored")
```

The idf values come from the training reviews only, and unseen test words contribute nothing, which is the honest behaviour for a deployed model.

## Train and compare with a baseline

```python run
def train_logreg(X, y, steps=400, lr=0.5):
    w = np.zeros(X.shape[1])
    b = 0.0
    for _ in range(steps):
        p = 1 / (1 + np.exp(-(X @ w + b)))
        w -= lr * X.T @ (p - y) / len(y)
        b -= lr * np.mean(p - y)
    return w, b

w, b = train_logreg(X_train, y_train)
pred = (X_test @ w + b > 0).astype(int)
baseline = np.full_like(y_test, int(round(y_train.mean())))
print("test accuracy, logistic regression:", round(float(np.mean(pred == y_test)), 3))
print("test accuracy, majority baseline:  ", round(float(np.mean(baseline == y_test)), 3))
```

A baseline that always predicts the majority training label is the floor. The model must beat it on the test reviews.

## Per-class quality

```python run
def per_class_f1(y_true, y_pred, c):
    tp = np.sum((y_pred == c) & (y_true == c))
    fp = np.sum((y_pred == c) & (y_true != c))
    fn = np.sum((y_pred != c) & (y_true == c))
    if tp == 0:
        return 0.0
    p, r = tp / (tp + fp), tp / (tp + fn)
    return 2 * p * r / (p + r)

scores = [per_class_f1(y_test, pred, c) for c in [0, 1]]
print("F1 negative:", round(scores[0], 3), "| F1 positive:", round(scores[1], 3))
print("macro-F1:", round(float(np.mean(scores)), 3))
```

Report the macro average, not just accuracy, so that a weak class cannot hide behind a strong one.

## Errors

```python run
wrong = np.nonzero(pred != y_test)[0]
print("misclassified test reviews:", len(wrong))
for i in wrong[:3]:
    print(" ", test_texts[i], "| true", y_test[i], "| predicted", pred[i])
```

> **Pitfall:** the most common capstone mistake is fitting the vocabulary or idf on all the data before splitting. The score then looks better than the model is, because the test words shaped the features.

> **In the wild:** deployed text classifiers are monitored with exactly these numbers, on fresh data, because the language they see drifts over time.

## Challenge: training idf

```python exercise id=train-idf title="Inverse document frequency from training documents"
import math
from collections import Counter

# TODO: `train_idf(docs)` takes a list of training strings and returns a dictionary mapping each word to
# log(N / df), where N is the number of documents and df counts the documents that contain the word.
def train_idf(docs):
    ...
--- solution
import math
from collections import Counter

def train_idf(docs):
    df = Counter(w for d in docs for w in set(d.split()))
    n = len(docs)
    return {w: math.log(n / c) for w, c in df.items()}
--- test
result = train_idf(["a b", "a c"])
assert result is not None, "Replace the `...` in `train_idf` with code that returns the dictionary."
assert abs(result["a"]) < 1e-9, "'a' appears in both documents, so its idf is zero."
assert abs(result["b"] - math.log(2)) < 1e-9, "'b' appears in one of two documents, so its idf is log 2."
assert set(result) == {"a", "b", "c"}, "Every word of the training documents must be in the dictionary."
--- hint
Count the documents containing each word using `set(d.split())` for each document, then compute `log(n / count)`.
--- hint
`{w: math.log(n / c) for w, c in df.items()}`.
```

## Challenge: majority label

```python exercise id=majority-label title="The majority label"
from collections import Counter

# TODO: `majority_label(labels)` returns the most common label in the list. If two labels tie, return the smaller one.
def majority_label(labels):
    ...
--- solution
from collections import Counter

def majority_label(labels):
    counts = Counter(labels)
    best = max(counts.values())
    return min(label for label, c in counts.items() if c == best)
--- test
assert majority_label([1, 0, 1]) == 1, "Label 1 appears twice, so it is the majority."
assert majority_label([0, 1]) == 0, "On a tie the smaller label, 0, is returned."
assert majority_label(["neg", "neg", "pos"]) == "neg", "The most common label works for strings too."
--- hint
Count the labels, find the highest count, and among the labels with that count choose the smallest.
--- hint
`min(label for label, c in counts.items() if c == best)`.
```

## Debug the leakage

This vocabulary is meant to come from the training texts only, but it is built from every text, so words that appear only in the test set become part of the model.

```python debug id=idf-leak title="Build the vocabulary from training texts only"
import math
from collections import Counter

train_docs = ["the battery was great", "the screen was broken"]
test_docs = ["the speaker was faulty"]
all_docs = train_docs + test_docs
df = Counter(w for d in all_docs for w in set(d.split()))     # bug: uses every document
idf = {w: math.log(len(all_docs) / c) for w, c in df.items()}
print("vocabulary size:", len(idf))
print("contains test-only word 'faulty':", "faulty" in idf)
--- solution
import math
from collections import Counter

train_docs = ["the battery was great", "the screen was broken"]
test_docs = ["the speaker was faulty"]
df = Counter(w for d in train_docs for w in set(d.split()))
idf = {w: math.log(len(train_docs) / c) for w, c in df.items()}
print("vocabulary size:", len(idf))
print("contains test-only word 'faulty':", "faulty" in idf)
--- test
assert "faulty" not in idf, "'faulty' appears only in the test set, so it must not shape the training features. Build df from the training documents only."
assert len(idf) == len(set(" ".join(train_docs).split())), "The vocabulary should be exactly the training words."
--- hint
Which documents should the idf be computed from?
--- hint
Use `train_docs` in both the document frequency and the number of documents.
```

## Predict the metric

```python predict id=predict-cap title="What is the macro-F1 when both classes score 0.8?"
import numpy as np
print(round(float(np.mean([0.8, 0.8])), 2))
--- options
* 0.8
1.6
0.4
0.64
--- explain
Macro-F1 averages the per-class scores, and the average of two equal values is that value, 0.8.
```
