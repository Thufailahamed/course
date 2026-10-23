Many of the questions businesses ask have a yes-or-no answer: will this customer leave, will this payment be fraudulent, will this patient return to hospital? For these, linear regression is the wrong tool, because its output is not a probability and it can predict any number. **Logistic regression** keeps the same weighted sum, then squeezes it through the sigmoid function so that the output is always a probability between 0 and 1.

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

> **In the wild:** scikit-learn's `LogisticRegression` solves the same problem, usually with a regularization penalty that keeps the weights small. Its `predict_proba` method returns these probabilities.

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
- scikit-learn's `LogisticRegression` computes the same model, with regularization built in.

**Up next:** decision trees, which learn rules rather than weights, and can bend the boundary.
