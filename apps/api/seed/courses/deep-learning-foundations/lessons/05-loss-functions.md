A network makes predictions, and training needs a single number that says how wrong they are. That number is the **loss**. Gradient descent will push the weights to make it smaller, so the loss you choose is not a detail: it defines what "good" means to the model.

This lesson covers the three losses you will meet most often: mean squared error for regression, binary cross-entropy for yes-or-no classification, and softmax cross-entropy for many classes. You will also learn the numerical tricks that stop them from producing `nan` on real data.

## Mean squared error for regression

When the target is a number, such as a price or a temperature, the usual loss is the average squared difference:

$$
L_{\text{MSE}} = \frac{1}{n} \sum_{i=1}^{n} (\hat{y}_i - y_i)^2
$$

Squaring punishes large errors more than small ones, and it is smooth everywhere, which makes it easy to optimize.

```python run
y_true = np.array([3.0, -0.5, 2.0, 7.0])
y_pred = np.array([2.5, 0.0, 2.0, 8.0])

errors = y_pred - y_true
print("errors:", errors)
print("MSE:", np.mean(errors ** 2))
```

Change one prediction by a large amount and watch the loss jump. Large errors dominate the average, which is exactly what squared error is for.

## Binary cross-entropy for two classes

For a yes-or-no question, the network outputs a probability $p$ that the answer is yes. The loss rewards high probability on the right answer and punishes confident mistakes very harshly:

$$
L = -\frac{1}{n} \sum_{i=1}^{n} \bigl[\, y_i \log p_i + (1 - y_i) \log(1 - p_i) \,\bigr]
$$

```python run
y = np.array([1.0, 0.0, 1.0])
for p in [0.9, 0.5, 0.01]:
    p_vec = np.full(3, p)
    bce = -np.mean(y * np.log(p_vec) + (1 - y) * np.log(1 - p_vec))
    print(f"predicted probability {p:<5} -> loss {bce:.4f}")
```

A confident correct prediction costs almost nothing. A confident wrong one costs a lot. The loss is a measure of surprise.

## Softmax and cross-entropy for many classes

With $K$ classes, the network outputs $K$ raw scores, called **logits**. The **softmax** turns them into probabilities that are positive and sum to one:

$$
\operatorname{softmax}(z)_k = \frac{e^{z_k}}{\sum_j e^{z_j}}
$$

```python run
logits = np.array([2.0, 1.0, 0.1])
probs = np.exp(logits) / np.exp(logits).sum()
print("probabilities:", np.round(probs, 4))
print("sum:", probs.sum())

true_class = 0
print("cross-entropy for the true class:", round(-np.log(probs[true_class]), 4))
```

The loss is the negative log of the probability assigned to the correct class. It is zero when that probability is one, and it grows without limit as it approaches zero.

## Numerical stability: why exponentials overflow

Exponentials grow very fast. Computing $e^{1000}$ overflows a 64-bit float to `inf`, and then the division gives `nan`. The fix is to subtract the largest logit before exponentiating. The answer does not change, because the same factor cancels top and bottom.

```python run
big_logits = np.array([1000.0, 1001.0, 999.0])
with np.errstate(over="ignore", invalid="ignore"):
    naive = np.exp(big_logits) / np.exp(big_logits).sum()
shifted = big_logits - big_logits.max()
stable = np.exp(shifted) / np.exp(shifted).sum()
print("naive: ", naive)
print("stable:", np.round(stable, 4))
```

> **Pitfall:** the same problem hits logs. $\log 0$ is $-\infty$, so a probability of exactly 0 or 1 inside a cross-entropy gives an infinite loss. Frameworks clip probabilities to a small range, such as $[10^{-12}, 1 - 10^{-12}]$, to avoid this.

## Challenge: mean squared error

```python exercise id=mse-loss title="Mean squared error"
# TODO: `mse(y_pred, y_true)` should return the mean of the squared differences, as one number.
def mse(y_pred, y_true):
    ...
--- solution
def mse(y_pred, y_true):
    return np.mean((y_pred - y_true) ** 2)
--- test
result = mse(np.array([1.0, 2.0]), np.array([1.0, 4.0]))
assert result is not None, "Replace the `...` in `mse` with code that returns the loss."
assert np.isclose(result, 2.0), f"The squared errors are 0 and 4, whose mean is 2.0, but mse returned {result!r}."
assert np.isclose(mse(np.array([0.0, 0.0, 0.0]), np.array([1.0, -1.0, 2.0])), 2.0), "Check the mean of the squared differences across all three values."
assert np.isclose(mse(np.array([[1.0, 2.0]]), np.array([[0.0, 0.0]])), 2.5), "The loss should average over every entry, including a 2-D batch."
--- hint
Subtract the targets from the predictions, square the result elementwise, and take the mean.
--- hint
`return np.mean((y_pred - y_true) ** 2)`.
```

## Challenge: binary cross-entropy

```python exercise id=bce-loss title="Binary cross-entropy"
# TODO: `bce(p, y)` should return the average binary cross-entropy. Clip p to [1e-12, 1 - 1e-12]
# before taking logarithms, so a probability of exactly 0 or 1 cannot produce infinity.
def bce(p, y):
    ...
--- solution
def bce(p, y):
    p = np.clip(p, 1e-12, 1 - 1e-12)
    return -np.mean(y * np.log(p) + (1 - y) * np.log(1 - p))
--- test
result = bce(np.array([0.9, 0.2]), np.array([1.0, 0.0]))
assert result is not None, "Replace the `...` in `bce` with code that returns the loss."
expected = -(np.log(0.9) + np.log(0.8)) / 2
assert np.isclose(result, expected), f"For p = [0.9, 0.2] and y = [1, 0] the loss is {expected:.4f}, but you returned {result!r}."
assert np.isfinite(bce(np.array([1.0, 0.0]), np.array([0.0, 1.0]))), "Extreme probabilities must not produce an infinite loss. Clip p first."
--- hint
Each example contributes `y·log(p) + (1 - y)·log(1 - p)`. The loss is the negative of the mean of that.
--- hint
Clip with `np.clip(p, 1e-12, 1 - 1e-12)` before computing the logarithms.
```

## Challenge: a stable softmax

```python exercise id=stable-softmax title="A stable softmax over rows"
# TODO: `stable_softmax(Z)` takes a 2-D array of logits, one row per example, and returns the
# probabilities with each row summing to 1. Subtract each row's maximum before exponentiating.
def stable_softmax(Z):
    ...
--- solution
def stable_softmax(Z):
    shifted = Z - Z.max(axis=1, keepdims=True)
    e = np.exp(shifted)
    return e / e.sum(axis=1, keepdims=True)
--- test
result = stable_softmax(np.array([[1000.0, 1001.0], [0.0, 0.0]]))
assert result is not None, "Replace the `...` in `stable_softmax` with code that returns the probabilities."
assert np.all(np.isfinite(result)), "Large logits should still give finite probabilities. Subtract the row maximum first."
assert np.allclose(result[0], [0.2689414, 0.7310586]), f"The first row should be about [0.269, 0.731], but you returned {result[0]}."
assert np.allclose(result[1], [0.5, 0.5]), "Equal logits should give equal probabilities."
assert np.allclose(result.sum(axis=1), 1.0), "Each row must sum to 1."
--- hint
Take the maximum over each row, not over the whole array. `keepdims=True` keeps the shapes aligned for subtraction.
--- hint
`shifted = Z - Z.max(axis=1, keepdims=True)`, then exponentiate and divide by the row sums.
```

## Debug the softmax axis

```python debug id=softmax-axis title="Normalize each row, not each column"
logits = np.array([[2.0, 1.0, 0.1], [0.5, 2.5, 0.3]])   # 2 examples, 3 classes
e = np.exp(logits - logits.max(axis=1, keepdims=True))
probs = e / e.sum(axis=0, keepdims=True)
print("probabilities:")
print(np.round(probs, 3))
print("row sums:", np.round(probs.sum(axis=1), 3))
--- solution
logits = np.array([[2.0, 1.0, 0.1], [0.5, 2.5, 0.3]])   # 2 examples, 3 classes
e = np.exp(logits - logits.max(axis=1, keepdims=True))
probs = e / e.sum(axis=1, keepdims=True)
print("probabilities:")
print(np.round(probs, 3))
print("row sums:", np.round(probs.sum(axis=1), 3))
--- test
assert np.allclose(probs.sum(axis=1), 1.0), f"Each example's class probabilities must sum to 1, but the row sums are {probs.sum(axis=1)}."
assert probs.shape == (2, 3), f"probs should keep shape (2, 3), but it has {probs.shape}."
assert np.argmax(probs[1]) == 1, "For the second example the largest probability should be on class 1."
--- hint
The sum must run over the classes, which are the columns. Which axis is that for a `(examples, classes)` array?
--- hint
Use `axis=1` in the sum so each row is normalized on its own.
```

## Predict the loss

```python predict id=predict-mse title="What is the MSE?"
pred = np.array([1.0, 2.0])
target = np.array([1.0, 4.0])
print(np.mean((pred - target) ** 2))
--- options
* 2.0
4.0
1.0
0.5
--- explain
The errors are 0 and -2. Their squares are 0 and 4, and the mean of 0 and 4 is 2. The first prediction was exact, so it contributes nothing, which is why the answer is not 4.
```

## Recap

- The loss is a single number that defines what the network is trying to improve.
- Use mean squared error for regression, binary cross-entropy for yes-or-no classes, and softmax cross-entropy for many classes.
- Softmax turns logits into probabilities. Subtract the row maximum first so exponentials cannot overflow.
- Clip probabilities before taking logarithms, so a confident mistake gives a large but finite loss.

**Up next:** gradient descent. You will use the loss to move a single neuron downhill, step by step.
