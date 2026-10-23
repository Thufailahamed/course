This is the capstone. You will take everything from the course and use it to train an image classifier end to end: generate a dataset, split it correctly, build a network, train it with Adam, and judge the result honestly on data it has never seen.

The task is to recognize four shapes drawn on small 12 × 12 images, a ring, a square outline, a filled triangle and a cross, placed at random positions, with random sizes and noise. A real photograph is harder, but the workflow is the same, and you can run every step in the page.

## Make the data

The images below are generated from simple geometry, so the dataset is endless and reproducible. Every shape is drawn with noise, so the network cannot memorize pixels exactly.

```python run
import matplotlib.pyplot as plt

def make_shape(kind, rng, size=12):
    yy, xx = np.mgrid[0:size, 0:size] / (size - 1)
    cx, cy = rng.uniform(0.4, 0.6, 2)
    r = rng.uniform(0.25, 0.35)
    if kind == 0:                                  # ring
        img = np.abs(np.hypot(xx - cx, yy - cy) - r) < 0.09
    elif kind == 1:                                # square outline
        img = np.abs(np.maximum(np.abs(xx - cx), np.abs(yy - cy)) - r) < 0.09
    elif kind == 2:                                # filled triangle, apex at the top
        t = (yy - (cy - r)) / (2 * r)
        img = (t >= 0) & (t <= 1) & (np.abs(xx - cx) <= t * r)
    else:                                          # cross
        img = ((np.abs(xx - cx) < 0.09) & (np.abs(yy - cy) < r)) | ((np.abs(yy - cy) < 0.09) & (np.abs(xx - cx) < r))
    return img.astype(float) + rng.normal(0, 0.15, (size, size))

def make_dataset(n_per_class, rng):
    X, y = [], []
    for k in range(4):
        for _ in range(n_per_class):
            X.append(make_shape(k, rng).ravel())
            y.append(k)
    X, y = np.array(X), np.array(y)
    order = rng.permutation(len(y))
    return X[order], y[order]

rng = np.random.default_rng(0)
X_train, y_train = make_dataset(80, rng)     # 320 training images
X_val, y_val = make_dataset(30, rng)         # 120 validation images, never used for training

names = ["ring", "square", "triangle", "cross"]
fig, axes = plt.subplots(1, 4, figsize=(7, 2.3))
for k, ax in enumerate(axes):
    ax.imshow(make_shape(k, np.random.default_rng(k)), cmap="gray")
    ax.set_title(names[k]); ax.axis("off")
plt.show()
print("train:", X_train.shape, "| validation:", X_val.shape)
```

Each image is flattened into a row of 144 pixel values, so the dataset is a matrix with one row per image, exactly as in lesson 4.

## Standardize without cheating

Pixel values need to be on a common scale, so you subtract the mean and divide by the standard deviation. The statistics must come from the **training** set only. If the validation images contributed to them, the model would have seen a little of the data it is later judged on, and your accuracy would be too optimistic.

```python run
mu = X_train.mean(axis=0)
sd = X_train.std(axis=0) + 1e-8
Xtr = (X_train - mu) / sd
Xva = (X_val - mu) / sd                      # the validation set uses the TRAINING statistics

# A simple baseline to beat: classify each image by its nearest class-average template.
means = np.array([Xtr[y_train == k].mean(axis=0) for k in range(4)])
dist = ((Xva[:, None, :] - means[None]) ** 2).sum(axis=-1)
baseline = (dist.argmin(axis=1) == y_val).mean()
print("nearest-template baseline, validation accuracy:", round(float(baseline), 3))
```

A baseline tells you whether a model is doing real work. Keep this number in mind.

## Train a network

The network has 144 inputs, 32 hidden ReLU units and four outputs with softmax. It is trained on the cross-entropy loss with the Adam optimizer from lesson 11, over full batches. Every formula here is one you have already derived.

```python run
def one_hot(labels, k):
    out = np.zeros((len(labels), k))
    out[np.arange(len(labels)), labels] = 1.0
    return out

def train_mlp(X, y, hidden=32, steps=150, lr=0.01, seed=1):
    r = np.random.default_rng(seed)
    Y = one_hot(y, 4)
    n = len(X)
    params = [r.normal(0, np.sqrt(2 / X.shape[1]), (X.shape[1], hidden)), np.zeros(hidden),
              r.normal(0, np.sqrt(1 / hidden), (hidden, 4)), np.zeros(4)]
    m = [np.zeros_like(p) for p in params]
    v = [np.zeros_like(p) for p in params]
    losses = []
    for t in range(1, steps + 1):
        W1, b1, W2, b2 = params
        H = np.maximum(0, X @ W1 + b1)                       # forward pass
        Z = H @ W2 + b2
        Z = Z - Z.max(axis=1, keepdims=True)
        P = np.exp(Z) / np.exp(Z).sum(axis=1, keepdims=True)
        losses.append(-np.mean(np.sum(Y * np.log(P + 1e-12), axis=1)))
        dZ = (P - Y) / n                                     # backward pass
        dH = dZ @ W2.T
        dH[H <= 0] = 0
        grads = [X.T @ dH, dH.sum(axis=0), H.T @ dZ, dZ.sum(axis=0)]
        for i in range(4):                                   # Adam update
            m[i] = 0.9 * m[i] + 0.1 * grads[i]
            v[i] = 0.999 * v[i] + 0.001 * grads[i] ** 2
            m_hat = m[i] / (1 - 0.9 ** t)
            v_hat = v[i] / (1 - 0.999 ** t)
            params[i] = params[i] - lr * m_hat / (np.sqrt(v_hat) + 1e-8)
    return params, losses

def predict_mlp(params, X):
    W1, b1, W2, b2 = params
    return np.argmax(np.maximum(0, X @ W1 + b1) @ W2 + b2, axis=1)

params, losses = train_mlp(Xtr, y_train)
print("loss: start", round(losses[0], 3), "| end", round(losses[-1], 3))
print("train accuracy:", round(float((predict_mlp(params, Xtr) == y_train).mean()), 3))
print("validation accuracy:", round(float((predict_mlp(params, Xva) == y_val).mean()), 3))
```

The loss starts near $\log 4 \approx 1.39$, the value for four equally likely classes, and falls as the network learns. The validation accuracy is the number you care about, because it measures images the network never trained on.

## Read the errors

An overall accuracy hides the mistakes. A confusion matrix shows which shapes get confused with which.

```python run
pred = predict_mlp(params, Xva)
conf = np.zeros((4, 4), dtype=int)
for true_k, pred_k in zip(y_val, pred):
    conf[true_k, pred_k] += 1
print("rows = true shape, columns = predicted shape")
print("order:", names)
print(conf)
```

The diagonal is the correct answers. Off-diagonal entries are errors, and they usually fall between shapes that look alike at this resolution, such as a ring and a square outline.

```python run
fig, ax = plt.subplots(figsize=(5, 3))
ax.plot(losses)
ax.set_xlabel("step"); ax.set_ylabel("training loss"); ax.grid(alpha=0.3)
plt.show()
```

> **Pitfall:** do not tune hyperparameters on the validation set and then report that same number as your result. For a real project, hold out a separate test set for the final measurement, as lesson 12 described.

## Challenge: standardize the splits

```python exercise id=standardize-splits title="Standardize without leakage"
# TODO: `standardize(X_train, X_val)` returns (Xtr_s, Xva_s). Compute the mean and standard deviation
# of each column from X_train only, then apply them to both arrays.
def standardize(X_train, X_val):
    ...
--- solution
def standardize(X_train, X_val):
    mu = X_train.mean(axis=0)
    sd = X_train.std(axis=0) + 1e-8
    return (X_train - mu) / sd, (X_val - mu) / sd
--- test
Xtr_t = np.array([[0.0], [2.0]])
Xva_t = np.array([[4.0]])
result = standardize(Xtr_t, Xva_t)
assert result is not None, "Replace the `...` in `standardize` with code that returns the two arrays."
Xtr_s, Xva_s = result
assert np.allclose(Xtr_s.mean(axis=0), 0.0), "The training set should have mean 0 after scaling."
assert np.allclose(Xtr_s.std(axis=0), 1.0, atol=1e-6), "The training set should have standard deviation 1 after scaling."
assert np.allclose(Xva_s, [[3.0]], atol=1e-6), f"The validation point 4.0 should become (4 - 1) / 1 = 3 using the training mean 1 and standard deviation 1, but you returned {Xva_s.ravel()}."
--- hint
Compute `mu` and `sd` from `X_train` alone, then apply those same two numbers to `X_val`.
--- hint
`mu = X_train.mean(axis=0)`, `sd = X_train.std(axis=0) + 1e-8`, then return `(X_train - mu) / sd, (X_val - mu) / sd`.
```

## Challenge: one-hot labels

```python exercise id=one-hot title="One-hot encode the labels"
# TODO: `one_hot(labels, k)` returns an (n, k) array with a 1.0 in the column of each label and 0.0 elsewhere.
def one_hot(labels, k):
    ...
--- solution
def one_hot(labels, k):
    out = np.zeros((len(labels), k))
    out[np.arange(len(labels)), labels] = 1.0
    return out
--- test
result = one_hot(np.array([0, 2, 1]), 3)
assert result is not None, "Replace the `...` in `one_hot` with code that returns the encoded labels."
assert result.shape == (3, 3), f"Three labels with three classes should give shape (3, 3), but you returned {result.shape}."
assert np.array_equal(result, [[1, 0, 0], [0, 0, 1], [0, 1, 0]]), f"Each row should have a single 1 in its label's column. You returned {result.tolist()}."
assert one_hot(np.array([3]), 4).tolist() == [[0.0, 0.0, 0.0, 1.0]], "A label of 3 with four classes sets the last column."
--- hint
Create zeros of shape `(len(labels), k)`. Then set the entry in row `i`, column `labels[i]` to 1, for every row at once with fancy indexing.
--- hint
`out[np.arange(len(labels)), labels] = 1.0`.
```

## Challenge: accuracy from scores

```python exercise id=scores-accuracy title="Accuracy from class scores"
# TODO: `accuracy(scores, labels)` takes an (n, k) array of class scores and an array of true labels.
# Predict the class with the highest score in each row, and return the fraction of correct predictions.
def accuracy(scores, labels):
    ...
--- solution
def accuracy(scores, labels):
    return float(np.mean(np.argmax(scores, axis=1) == labels))
--- test
scores = np.array([[0.1, 0.9], [0.8, 0.2], [0.3, 0.7]])
result = accuracy(scores, np.array([1, 0, 0]))
assert result is not None, "Replace the `...` in `accuracy` with code that returns a fraction."
assert np.isclose(result, 2 / 3), f"The predictions are [1, 0, 1], which match two of three labels, so the accuracy is 2/3, but you returned {result!r}."
assert np.isclose(accuracy(np.eye(4), np.arange(4)), 1.0), "A perfect diagonal of scores should give accuracy 1.0."
--- hint
`np.argmax(scores, axis=1)` gives the predicted class for each row. Compare it with `labels` and take the mean.
--- hint
`return float(np.mean(np.argmax(scores, axis=1) == labels))`.
```

## Debug the leaky standardization

This version computes its statistics over both sets together. The validation set has leaked into the scaling, so the number it produces is wrong.

```python debug id=leaky-standardize title="Scale the validation set with training statistics"
import numpy as np

Xtr = np.array([[0.0], [2.0]])
Xva = np.array([[4.0]])
both = np.vstack([Xtr, Xva])
mu, sd = both.mean(axis=0), both.std(axis=0)     # bug: the statistics include the validation set
Xtr_s = (Xtr - mu) / sd
Xva_s = (Xva - mu) / sd
print("validation after scaling:", np.round(Xva_s.ravel(), 3), "(should be 3.0)")
--- solution
import numpy as np

Xtr = np.array([[0.0], [2.0]])
Xva = np.array([[4.0]])
mu, sd = Xtr.mean(axis=0), Xtr.std(axis=0)
Xtr_s = (Xtr - mu) / sd
Xva_s = (Xva - mu) / sd
print("validation after scaling:", np.round(Xva_s.ravel(), 3), "(should be 3.0)")
--- test
assert np.allclose(Xva_s, [[3.0]], atol=1e-6), f"The validation point should scale to 3.0 using training statistics, but it became {Xva_s.ravel()}. Compute mu and sd from the training set only."
assert np.allclose(Xtr_s.mean(axis=0), 0.0), "The training set should still have mean 0."
--- hint
Look at what the statistics are computed from. Which array should `mu` and `sd` see?
--- hint
Compute `mu` and `sd` from `Xtr` alone, as `Xtr.mean(axis=0)` and `Xtr.std(axis=0)`.
```

## Predict the encoding

```python predict id=predict-onehot title="What does one_hot give?"
import numpy as np
out = np.zeros((1, 4))
out[np.arange(1), np.array([2])] = 1.0
print(out.tolist())
--- options
* [[0.0, 0.0, 1.0, 0.0]]
[[0.0, 1.0, 0.0, 0.0]]
[[1.0, 0.0, 0.0, 0.0]]
[[0.0, 0.0, 0.0, 2.0]]
--- explain
The label 2 selects column index 2 in row 0. Zero-based indexing means the third column, which is where the 1 goes.
```

## Your turn

You have built the whole pipeline. Try these changes in the training cell and watch what happens to the validation accuracy:

- Change `hidden` to 8, then to 128. Does a bigger network always do better here?
- Change `steps` to 30, then to 500. Where does the training curve flatten?
- Set `lr` to 0.1. What happens to the loss, and why?
- Shrink the training set by changing `make_dataset(80, rng)` to `make_dataset(10, rng)`. How much does the validation accuracy drop?

Each answer teaches something you will meet in every real project: capacity, training length, learning rate and data quantity.

## Recap

- A good workflow generates or collects data, splits it, and scales it using training statistics only.
- A network is a forward pass, a loss, a backward pass and an optimizer update, repeated.
- Compare against a simple baseline. A model that does not beat it is not yet doing useful work.
- Read the errors with a confusion matrix, and report validation or test accuracy, never training accuracy.

**Congratulations.** You now know how neural networks are built, trained, debugged and specialized for images and sequences. The final assessment checks the whole course.
