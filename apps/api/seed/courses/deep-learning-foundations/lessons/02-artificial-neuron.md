A neuron is the smallest unit of a deep network, and its arithmetic is simple. It multiplies each input by a weight, adds them up, adds a bias, and then decides something from the result. Everything that follows in this course is built on that one computation.

In this lesson you will compute a neuron for one example and for a whole batch at once, draw the **decision boundary** it creates, and see the limit that makes depth necessary.

## One neuron, one example

The pre-activation, usually written $z$, is a weighted sum plus a bias:

$$
z = w_1 x_1 + w_2 x_2 + \dots + w_d x_d + b = w \cdot x + b
$$

The weights $w$ say how much each input matters, and the bias $b$ shifts the result up or down. Both are learned.

```python run
x = np.array([1.0, 2.0])      # two input features
w = np.array([0.5, -1.0])     # the weights
b = 0.25                       # the bias

z = np.dot(w, x) + b
print("z =", z)
```

Change `w` and rerun the cell. Make the first weight bigger and watch $z$ move. This is the whole intuition behind learning: the weights are the knobs, and the output responds to them.

## A batch is a matrix

Real training never processes one example at a time. You stack the examples into a matrix $X$ with one row per example, and the whole batch is computed with one line:

$$
z = X w + b
$$

```python run
X = np.array([
    [1.0, 2.0],
    [0.0, 1.0],
    [3.0, -1.0],
    [-2.0, 0.5],
])
print("X has shape", X.shape, "- four examples, two features each")

z = X @ w + b
print("z for every example:", z)
print("z has shape", z.shape)
```

The bias is added to every row automatically. This is called **broadcasting**, and you will rely on it constantly.

## Challenge: compute the neuron for a batch

```python exercise id=batch-scores title="Score a whole batch at once"
# TODO: `batch_scores(X, w, b)` should return the array of z values, one per row of X.
def batch_scores(X, w, b):
    ...
--- solution
def batch_scores(X, w, b):
    return X @ w + b
--- test
X_test = np.array([[1.0, 0.0], [0.0, 2.0], [-1.0, 1.0]])
w_test = np.array([2.0, -0.5])
result = batch_scores(X_test, w_test, 1.0)
assert result is not None, "Replace the `...` in `batch_scores` with code that returns the scores."
assert np.shape(result) == (3,), f"You should return one score per example, shape (3,), but got {np.shape(result)}."
assert np.allclose(result, [3.0, 0.0, -1.5]), f"Expected [3.0, 0.0, -1.5] for these inputs, but you returned {result}."
X_new = np.array([[4.0, 4.0], [0.0, -6.0], [0.5, 0.5]])
assert np.allclose(batch_scores(X_new, np.array([1.0, 1.0]), 0.0), [8.0, -6.0, 1.0]), "Your function should work for any batch, not only the example above."
--- hint
Use the matrix product `X @ w`, which computes one dot product per row, and then add the bias.
--- hint
`return X @ w + b`. The bias is a single number, so it is added to every score.
```

## The decision boundary

A neuron used as a classifier predicts class 1 when $z > 0$ and class 0 otherwise. The boundary between the two regions is the set of points where $z = 0$. For two features, that is a straight line.

```python run
import matplotlib.pyplot as plt

rng = np.random.default_rng(0)
class0 = rng.normal([-1.0, -1.0], 0.5, size=(40, 2))
class1 = rng.normal([1.0, 1.0], 0.5, size=(40, 2))
points = np.vstack([class0, class1])

w = np.array([1.0, 1.0])
b = 0.0
xs = np.linspace(-2.5, 2.5, 100)
boundary = -(w[0] * xs + b) / w[1]     # solve w1*x1 + w2*x2 + b = 0 for x2

fig, ax = plt.subplots(figsize=(5, 4))
ax.scatter(class0[:, 0], class0[:, 1], label="class 0")
ax.scatter(class1[:, 0], class1[:, 1], label="class 1")
ax.plot(xs, boundary, "k--", label="decision boundary")
ax.set_xlim(-2.5, 2.5); ax.set_ylim(-2.5, 2.5); ax.legend(); ax.grid(alpha=0.3)
plt.show()
```

Try changing `w` and `b` in the cell above. The line rotates when you change the weights, and slides when you change the bias. A single neuron can only ever draw one straight line.

Now count how the neuron does on these points. The cell below reuses `points`, `w` and `b` from the plot above.

```python run
labels = (points @ w + b > 0).astype(int)
print("predicted class 1:", labels.sum(), "of", labels.size)
print("class 0 points predicted as class 1:", int(labels[:40].sum()))
print("class 1 points predicted as class 0:", int((1 - labels[40:]).sum()))
```

A mistake on one side of the line is a **false positive**, and a mistake on the other side is a **false negative**. You will count both again when we measure accuracy in the training lessons.

## Predict the classification

```python predict id=predict-boundary title="Which side is class 1?"
w = np.array([1.0, 1.0])
b = -1.0
point = np.array([2.0, 0.0])
print(int(np.dot(w, point) + b > 0))
--- options
* 1
0
-1
2
--- explain
The score is 1·2 + 1·0 - 1 = 1. That is greater than zero, so the neuron predicts class 1. The point sits on the positive side of the boundary x1 + x2 = 1.
```

## Challenge: turn scores into labels

```python exercise id=threshold-labels title="Turn scores into class labels"
# TODO: `predict_labels(X, w, b)` should return an integer array of 1s and 0s:
# 1 where the score w · x + b is greater than 0, and 0 otherwise.
def predict_labels(X, w, b):
    ...
--- solution
def predict_labels(X, w, b):
    return (X @ w + b > 0).astype(int)
--- test
X_test = np.array([[1.0, 1.0], [-1.0, -1.0], [0.5, -0.2]])
labels = predict_labels(X_test, np.array([1.0, 1.0]), 0.0)
assert labels is not None, "Replace the `...` in `predict_labels` with code that returns labels."
assert list(labels) == [1, 0, 1], f"Expected [1, 0, 1] for these points, but you returned {list(labels)}."
assert np.issubdtype(np.asarray(labels).dtype, np.integer), "Return integer labels (0 and 1), not booleans or floats."
labels2 = predict_labels(np.array([[-3.0, 1.0], [0.0, 0.0], [2.0, 2.0]]), np.array([2.0, 0.0]), 1.0)
assert list(labels2) == [0, 1, 1], f"Check the weights and the threshold for the second set. Expected [0, 1, 1], but you returned {list(labels2)}."
--- hint
Compute the scores first, then compare them with 0. Comparing gives booleans, and `.astype(int)` turns them into 1s and 0s.
--- hint
`return (X @ w + b > 0).astype(int)`.
```

## Debug the batch computation

```python debug id=wrong-order title="Multiply in the right order"
# Scores for a batch of 4 examples with 2 features each.
X = np.array([[1.0, 2.0], [0.0, 1.0], [3.0, -1.0], [-2.0, 0.5]])
w = np.array([0.5, -1.0])
b = 0.25
scores = w @ X + b
print("scores:", scores)
--- solution
# Scores for a batch of 4 examples with 2 features each.
X = np.array([[1.0, 2.0], [0.0, 1.0], [3.0, -1.0], [-2.0, 0.5]])
w = np.array([0.5, -1.0])
b = 0.25
scores = X @ w + b
print("scores:", scores)
--- test
expected = np.array([-1.25, -0.75, 2.75, -1.25])
assert scores.shape == (4,), f"There should be one score per example, shape (4,), but you have {scores.shape}."
assert np.allclose(scores, expected), f"Expected scores {expected}, but you have {scores}. The examples are the rows of X, so X must come first in the product."
--- hint
Look at which side of the product holds the batch. Each row of `X` is one example.
--- hint
Matrix products are not commutative: `w @ X` and `X @ w` are different operations, and only one matches the shapes here.
```

## Recap

- A neuron computes $z = w \cdot x + b$: a weighted sum plus a bias.
- For a batch, $z = X w + b$ computes every example at once, with the bias broadcast to each row.
- A neuron classifies by which side of the line $z = 0$ a point falls on.
- One neuron can only draw one straight boundary. Some problems need a curve, which is what layers of neurons provide.

**Up next:** activation functions. They are the non-linear step that makes stacking neurons worthwhile.
