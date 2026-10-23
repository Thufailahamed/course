DELETE FROM exercise_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_deep_learning_foundations');

DELETE FROM quiz_attempts WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_deep_learning_foundations');

DELETE FROM notes WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_deep_learning_foundations');

DELETE FROM lesson_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_deep_learning_foundations');

DELETE FROM discussions WHERE course_id = 'crs_deep_learning_foundations';

DELETE FROM certificates WHERE course_id = 'crs_deep_learning_foundations';

DELETE FROM enrollments WHERE course_id = 'crs_deep_learning_foundations';

DELETE FROM reviews WHERE course_id = 'crs_deep_learning_foundations';

DELETE FROM wishlist WHERE course_id = 'crs_deep_learning_foundations';

DELETE FROM path_courses WHERE course_id = 'crs_deep_learning_foundations';

DELETE FROM coupons WHERE course_id = 'crs_deep_learning_foundations';

DELETE FROM lessons WHERE course_id = 'crs_deep_learning_foundations';

DELETE FROM sections WHERE course_id = 'crs_deep_learning_foundations';

UPDATE order_items SET course_id = NULL WHERE course_id = 'crs_deep_learning_foundations';

DELETE FROM courses WHERE id = 'crs_deep_learning_foundations';

INSERT OR IGNORE INTO categories (id, slug, name, description, icon, sort_order) VALUES ('cat_deep-learning', 'deep-learning', 'Deep Learning', 'Neural networks, backprop, CNNs, RNNs and Transformers.', 'layers', 1);

INSERT INTO courses (id, slug, title, subtitle, description, category_id, instructor_id, level, language, price_cents, compare_at_price_cents, currency, thumbnail_key, preview_video_url, accent, status, featured, what_you_learn, requirements, target_audience, tags, duration_minutes, lessons_count, rating_avg, rating_count, students_count, published_at, created_at, updated_at) VALUES
('crs_deep_learning_foundations', 'deep-learning-foundations', 'Deep Learning Foundations', 'Build neural networks from scratch, then master PyTorch — the intuition, the math and the code.', 'Deep learning looks like magic until you have built the machinery yourself. A neural network is a stack of simple functions, its learning is the chain rule applied over and over, and every modern architecture is a small variation on the same loop: predict, measure the error, push the error backwards, take a step. This course builds that loop from first principles and then shows you how the professional tools implement it.

## Learn by building

- **Runnable NumPy everywhere.** Every neuron, layer, gradient and optimizer is code you write, run and break in the page.
- **Gradient checks.** You verify your backpropagation against finite differences, the same technique used to debug real frameworks.
- **Challenges with hidden tests.** Your functions are checked on fresh inputs, so they must be correct, not just pass one example.
- **Debug challenges.** You fix the bugs that real practitioners hit: a missing sum over the batch, a flipped transpose, dropout without rescaling and a learning rate that explodes.
- **PyTorch, mapped to NumPy.** Each PyTorch idea is shown next to the NumPy code you already wrote, so nothing in the framework is magic.

> **Honest note on PyTorch:** the browser runs NumPy, not PyTorch. The PyTorch lessons show complete PyTorch code for you to run on your own machine, and each one has runnable NumPy cells that compute the same thing.

## What you''ll cover

- **Neurons and forward passes:** the artificial neuron, activation functions, batched layers and loss functions.
- **How networks learn:** gradient descent, computational graphs, a tiny autograd engine and backpropagation through a dense layer.
- **Training networks:** full training loops, optimizers, regularization, initialization and normalization.
- **PyTorch in practice:** tensors and autograd, the training loop and a field guide to debugging training.
- **Convolutional and sequence models:** convolutions, CNNs, recurrent networks and the attention mechanism behind Transformers.
- **Capstone:** train and evaluate an image classifier end to end.

## Why this course?

Most introductions show you how to call a framework. This one shows you what the framework is doing. When your model''s loss is NaN, or your validation accuracy is stuck, you will know where to look, because you have already built the parts that can go wrong.

You need Python and basic algebra. Everything else is taught from the ground up.', 'cat_deep-learning', 'usr_maya', 'beginner', 'English', 0, NULL, 'USD', NULL, NULL, 262, 'published', 1, '["Implement a neural network, its forward pass and backpropagation from scratch in NumPy","Check your gradients numerically and know when a training bug is in the math or the code","Train, regularize and debug multi-layer networks with SGD, momentum and Adam","Write the same training loop in PyTorch, and map every line back to the NumPy version","Build convolutions, CNNs, recurrent networks and attention, and explain how each one works","Finish with a capstone image classifier that you train and evaluate yourself"]', '["Comfortable writing Python functions, loops and lists","High-school algebra. Calculus is taught as you go, with no prior calculus needed","A modern browser. Python and NumPy run in the page; PyTorch code is shown for you to run on your own machine"]', '["Software engineers moving into machine learning","Data analysts who want to understand what happens inside a neural network","Students preparing for machine-learning courses, research or roles"]', '["PyTorch","Neural Networks","Backpropagation","CNNs","Transformers"]', 407, 26, 0, 0, 48210, '2025-12-11T06:30:28.279Z', '2025-11-11T06:30:28.279Z', '2026-10-22T06:30:28.279Z');

INSERT INTO sections (id, course_id, title, position, created_at) VALUES
('sec_deep_learning_foundations_1', 'crs_deep_learning_foundations', 'Neurons and Forward Passes', 0, '2026-06-25T06:30:28.279Z'),
('sec_deep_learning_foundations_2', 'crs_deep_learning_foundations', 'How Networks Learn', 1, '2026-06-25T06:30:28.279Z'),
('sec_deep_learning_foundations_3', 'crs_deep_learning_foundations', 'Training Networks', 2, '2026-06-25T06:30:28.279Z'),
('sec_deep_learning_foundations_4', 'crs_deep_learning_foundations', 'PyTorch in Practice', 3, '2026-06-25T06:30:28.279Z'),
('sec_deep_learning_foundations_5', 'crs_deep_learning_foundations', 'Convolutional and Sequence Models', 4, '2026-06-25T06:30:28.279Z'),
('sec_deep_learning_foundations_6', 'crs_deep_learning_foundations', 'Capstone', 5, '2026-06-25T06:30:28.279Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_deep_learning_foundations_1_1', 'sec_deep_learning_foundations_1', 'crs_deep_learning_foundations', 'How this course works', 'interactive', 0, 480, NULL, NULL, 'Welcome to **Deep Learning Foundations**. Every system you have heard of, from image recognizers to language models, is built from one simple idea repeated many times: a **neuron** takes numbers in, multiplies them by learned weights, adds a bias, and passes the result through a small non-linear function. Stack enough of those in layers, teach the weights from examples, and you have a deep network.

This course does not stop at calling a framework. You will build the whole machine yourself, in NumPy, and then see how PyTorch implements the same loop. By the end, a loss curve that looks wrong will tell you something specific, because you will know exactly what produced it.

> **How to use this lesson:** read a little, run a little. Every grey box is code you can edit and run. Edit a number and watch the output change.

## Run your first cell

Click **Run** on the cell below, or click inside it and press **Shift + Enter**.

```python run
import numpy as np

x = np.array([0.5, -1.2, 3.0])   # three input features
print("input:", x)
print("number of features:", x.size)
```

`numpy` is already imported as `np` in every cell, and you will use it throughout the course. Writing `import numpy as np` yourself is still a good habit for real scripts.

## Cells share memory, like a notebook

Variables you create in one cell are available in the cells below it, once you have run the earlier cell.

```python run
w = np.array([0.2, 0.4, -0.1])   # one weight per feature
b = 0.5                           # the bias
print("weights:", w, "| bias:", b)
```

```python run
# Uses x, w and b from the two cells above
z = np.dot(w, x) + b
print("weighted sum z =", round(float(z), 3))
z
```

If you see a `NameError`, run the cell above first. **Run all** executes everything in order, **Restart** clears memory, and **Variables** shows every variable with its shape and type.

## Errors are part of learning

Here is an error on purpose. Run it:

```python run error
a = np.array([1.0, 2.0, 3.0])
b = np.array([1.0, 2.0])

a + b
```

The error card highlights the failing line and explains the problem in plain language. Shape mismatches like this are the most common bug in deep learning. Learning to read them quickly is one of the most useful skills you can build here.

## Predict before you run

Experienced practitioners predict what code will do before they run it. A predict cell asks you to choose first; then the code shows you the truth.

```python predict id=predict-shape title="What does this print?"
v = np.array([3.0, 4.0])
print(v.shape, v @ v)
--- options
* (2,) 25.0
(2, 1) 5.0
(1, 2) 25.0
(2,) 5.0
--- explain
`v.shape` is `(2,)`, a one-dimensional array with two entries. `v @ v` is the dot product 3·3 + 4·4 = 25, a single number. The length of v is the square root of 25, which is 5, but the code asked for the dot product, not the length.
```

## Your first challenge

A **challenge** is a function you write yourself. The course runs your code against hidden tests, so it must work on inputs you have not seen. Press **Check** to test your code, and use the hints if you get stuck.

```python exercise id=dot-score title="Score one example"
# TODO: `score(x, w, b)` should return w · x + b as a single number.
def score(x, w, b):
    ...
--- solution
def score(x, w, b):
    return np.dot(w, x) + b
--- test
result = score(np.array([1.0, 2.0]), np.array([3.0, 4.0]), 0.5)
assert result is not None, "Replace the `...` in `score` with code that returns a number."
assert np.isclose(result, 11.5), f"score([1, 2], [3, 4], 0.5) should be 3·1 + 4·2 + 0.5 = 11.5, but you returned {result!r}."
assert np.isclose(score(np.array([-1.0, 0.0, 2.0]), np.array([1.0, 5.0, 0.5]), -2.0), -2.0), "Check the weights and inputs pair up element by element, then add the bias."
--- hint
A weighted sum multiplies each input by its matching weight and adds the results. `np.dot` does exactly that.
--- hint
`return np.dot(w, x) + b`.
```

## Debug a shape error

A **debug challenge** starts with code that runs but is wrong, or fails with an error. Your job is to find the bug and fix it. Run the cell first and read the error.

```python debug id=transpose-weights title="Orient the weight matrix"
# Two inputs, three outputs. The weight matrix must have shape (2, 3).
W = np.ones((3, 2))
x = np.array([1.0, 2.0])
out = x @ W
print("output shape:", out.shape)
--- solution
# Two inputs, three outputs. The weight matrix must have shape (2, 3).
W = np.ones((2, 3))
x = np.array([1.0, 2.0])
out = x @ W
print("output shape:", out.shape)
--- test
assert W.shape == (2, 3), f"W should have shape (2, 3) for 2 inputs and 3 outputs, but it has {W.shape}."
assert out.shape == (3,), f"One input vector times W should give 3 outputs, but you got shape {out.shape}."
assert np.allclose(out, [3.0, 3.0, 3.0]), f"Each output sums the inputs 1 + 2 = 3, but you returned {out}."
--- hint
Read the error: the inner dimensions must match. `x` has 2 entries, so `W` needs 2 rows.
--- hint
Rows index inputs and columns index outputs, so the matrix should be `np.ones((2, 3))`.
```

## Recap

- A neuron computes a weighted sum of its inputs plus a bias, and training learns the weights and the bias.
- Shapes are the grammar of deep learning. Read them before you read the numbers.
- Challenges check your code on new inputs, so write functions, not answers.
- Predicting the output before running the code is the fastest way to build intuition.

**Up next:** the artificial neuron, and what it can and cannot separate. You will draw its decision boundary and see why a single neuron is not enough.
', 1, '[]', '[{"title":"Neural Networks: Zero to Hero (Andrej Karpathy)","url":"https://karpathy.ai/zero-to-hero.html"},{"title":"Dive into Deep Learning (free, interactive book)","url":"https://d2l.ai/"},{"title":"PyTorch tutorials","url":"https://pytorch.org/tutorials/"}]', '2026-06-25T06:30:28.279Z', '2026-10-19T06:30:28.279Z'),
('les_deep_learning_foundations_1_2', 'sec_deep_learning_foundations_1', 'crs_deep_learning_foundations', 'The artificial neuron', 'interactive', 1, 960, NULL, NULL, 'A neuron is the smallest unit of a deep network, and its arithmetic is simple. It multiplies each input by a weight, adds them up, adds a bias, and then decides something from the result. Everything that follows in this course is built on that one computation.

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
', 0, '[]', '[]', '2026-06-25T06:30:28.279Z', '2026-10-19T06:30:28.279Z'),
('les_deep_learning_foundations_1_3', 'sec_deep_learning_foundations_1', 'crs_deep_learning_foundations', 'Activation functions and why they matter', 'interactive', 2, 960, NULL, NULL, 'In the last lesson, a neuron drew one straight line. If you stacked two neurons with nothing between them, you would still get one straight line, because a linear function of a linear function is linear. The **activation function** is the small non-linear step between layers that breaks this limit. It is where depth gets its power.

In this lesson you will meet the three activations that matter most, compare their shapes, and learn their derivatives. The derivatives are not decoration. Backpropagation needs them in every single step.

## Why linearity is not enough

Suppose the first layer computes $h = W_1 x$ and the second computes $y = W_2 h$. Then

$$
y = W_2 W_1 x
$$

and the product $W_2 W_1$ is just another matrix. Two layers behave exactly like one. Check it with numbers:

```python run
rng = np.random.default_rng(0)
W1 = rng.normal(size=(3, 2))
W2 = rng.normal(size=(1, 3))
x = np.array([0.7, -1.3])

two_layers = W2 @ (W1 @ x)
one_layer = (W2 @ W1) @ x
print("two layers:", two_layers)
print("one layer: ", one_layer)
print("equal?", np.allclose(two_layers, one_layer))
```

Now insert a non-linearity between the layers and the equality breaks. That is the whole point.

## Three activations you will use

**Sigmoid** squashes any number into $(0, 1)$. It is the classic choice for a probability output:

$$
\sigma(z) = \frac{1}{1 + e^{-z}}, \qquad \sigma''(z) = \sigma(z)\bigl(1 - \sigma(z)\bigr)
$$

**Tanh** squashes into $(-1, 1)$ and is centred at zero, which often trains more smoothly inside a network:

$$
\tanh(z), \qquad \tanh''(z) = 1 - \tanh^2(z)
$$

**ReLU** (rectified linear unit) keeps positive values and sets negatives to zero. It is cheap to compute and is the default for hidden layers in modern networks:

$$
\operatorname{relu}(z) = \max(0, z), \qquad \operatorname{relu}''(z) = \begin{cases} 1 & z > 0 \\ 0 & z < 0 \end{cases}
$$

```python run
import matplotlib.pyplot as plt

z = np.linspace(-4, 4, 200)
sigmoid = 1 / (1 + np.exp(-z))
relu = np.maximum(0, z)

fig, ax = plt.subplots(figsize=(6, 3.5))
ax.plot(z, sigmoid, label="sigmoid")
ax.plot(z, np.tanh(z), label="tanh")
ax.plot(z, relu, label="ReLU")
ax.axhline(0, color="grey", lw=0.8); ax.axvline(0, color="grey", lw=0.8)
ax.set_ylim(-1.5, 4); ax.grid(alpha=0.3); ax.legend()
plt.show()
```

Look at the slope of each curve. The sigmoid and tanh flatten out at both ends, while ReLU keeps a constant slope on the positive side. That flat region matters a great deal, and the next two cells measure it.

```python run
def central_slope(f, x, h=1e-5):
    return (f(x + h) - f(x - h)) / (2 * h)

sigmoid = lambda t: 1 / (1 + np.exp(-t))
for z0 in [0.0, 2.0, 5.0]:
    numeric = central_slope(sigmoid, z0)
    formula = sigmoid(z0) * (1 - sigmoid(z0))
    print(f"z = {z0}: numeric {numeric:.6f}  formula {formula:.6f}")
```

The numbers agree, which confirms the sigmoid derivative formula. Notice how small the slope is at $z = 5$.

```python run
# Saturation: how fast does the sigmoid''s slope shrink as the input grows?
for z0 in [1.0, 3.0, 6.0, 10.0]:
    s = 1 / (1 + np.exp(-z0))
    print(f"z = {z0:>4}: slope = {s * (1 - s):.2e}")
```

When an input is large, a sigmoid or tanh unit is almost flat, so its gradient is almost zero. Stack many such layers and the signal that flows backwards shrinks towards nothing. This is the **vanishing gradient** problem, and it is one reason ReLU replaced sigmoid in hidden layers.

## Predict the values

```python predict id=predict-activations title="What do the activations give at zero?"
z = 0.0
print(np.tanh(z), 1 / (1 + np.exp(-z)))
--- options
* 0.0 0.5
0.0 1.0
1.0 0.5
0.5 0.0
--- explain
tanh(0) is 0, and the sigmoid is 1 / (1 + 1) = 0.5. Both sit at the centre of their ranges. This is why tanh is centred at zero, while the sigmoid is centred at one half.
```

## Challenge: write ReLU

```python exercise id=relu-forward title="Write ReLU"
# TODO: `relu(z)` should return the elementwise maximum of 0 and z, for an array z.
def relu(z):
    ...
--- solution
def relu(z):
    return np.maximum(0, z)
--- test
z_test = np.array([-2.0, -0.5, 0.0, 1.5, 3.0])
result = relu(z_test)
assert result is not None, "Replace the `...` in `relu` with code that returns the activation."
assert np.allclose(result, [0.0, 0.0, 0.0, 1.5, 3.0]), f"relu of {z_test} should be [0, 0, 0, 1.5, 3], but you returned {result}."
assert np.shape(relu(np.ones((2, 3)))) == (2, 3), "relu should keep the shape of its input."
--- hint
You need the larger of two values, elementwise: `0` and each entry of `z`. NumPy has a function for exactly that.
--- hint
`np.maximum(0, z)` compares every entry with 0 and keeps the bigger value.
```

## Challenge: the derivative of ReLU

Backpropagation multiplies by the derivative of every activation it passes through. For ReLU the derivative is 1 where the input was positive and 0 elsewhere.

```python exercise id=relu-derivative title="The derivative of ReLU"
# TODO: `relu_grad(z)` should return 1.0 where z > 0 and 0.0 otherwise, elementwise.
def relu_grad(z):
    ...
--- solution
def relu_grad(z):
    return (z > 0).astype(float)
--- test
z_test = np.array([-1.0, 0.0, 2.0, 0.5])
result = relu_grad(z_test)
assert result is not None, "Replace the `...` in `relu_grad` with code that returns the derivative."
assert np.allclose(result, [0.0, 0.0, 1.0, 1.0]), f"relu_grad of {z_test} should be [0, 0, 1, 1], but you returned {result}."
assert np.allclose(relu_grad(np.array([3.0, -3.0])), [1.0, 0.0]), "The derivative is 1 for every positive input, not only for these."
--- hint
Compare `z` with zero to get booleans, then convert them to numbers with `.astype(float)`.
--- hint
`return (z > 0).astype(float)`. At exactly zero the derivative is 0 by convention; the test expects that.
```

## Debug the tanh derivative

```python debug id=tanh-derivative title="Check the tanh derivative"
# The derivative of tanh(z) is 1 - tanh(z)^2.
z = np.array([0.0, 1.0, -2.0])
t = np.tanh(z)
dtanh = 1 - t           # what is wrong here?
print("tanh'':", dtanh)
--- solution
# The derivative of tanh(z) is 1 - tanh(z)^2.
z = np.array([0.0, 1.0, -2.0])
t = np.tanh(z)
dtanh = 1 - t ** 2
print("tanh'':", dtanh)
--- test
expected = 1 - np.tanh(z) ** 2
assert np.allclose(dtanh, expected), f"The derivative of tanh is 1 - tanh(z)², but you computed {dtanh}. Check the power."
assert np.isclose(dtanh[0], 1.0), "At z = 0 the slope of tanh is 1."
--- hint
The derivative of tanh squares the output. Compare `1 - t` with `1 - t²` at z = 0: the first gives 0, but the slope there is 1.
--- hint
Replace `t` with `t ** 2`.
```

## Pitfall: dead ReLU units

> **Pitfall:** a ReLU neuron whose pre-activation is always negative outputs zero and has a gradient of zero. It stops learning entirely, and it is called a *dead* unit. Good initialization and a moderate learning rate make this rare, and you will meet both later in the course.

## Recap

- Without a non-linearity, stacked layers collapse into one linear map. Activations are what make depth useful.
- Sigmoid squashes into $(0, 1)$, tanh into $(-1, 1)$, and ReLU keeps the positive part of its input.
- Each activation has a derivative that backpropagation multiplies in at every layer.
- ReLU is cheap and the default for hidden layers, but its gradient is zero for negative inputs, which can kill units.

**Up next:** the forward pass for a whole batch through several layers, with every shape written out.
', 0, '[]', '[]', '2026-06-25T06:30:28.279Z', '2026-10-19T06:30:28.279Z'),
('les_deep_learning_foundations_1_4', 'sec_deep_learning_foundations_1', 'crs_deep_learning_foundations', 'The forward pass for a batch of data', 'interactive', 3, 1080, NULL, NULL, 'The **forward pass** is the prediction step of a neural network: data flows from the inputs through each layer to the output. It is nothing more than a sequence of matrix products and activations, and once you can write it, you can read any architecture you meet, from a small classifier to a large language model.

In this lesson you will build a dense layer, stack two of them into a network, and push a whole batch through at once. Almost every bug in this stage is a shape bug, so you will learn to track shapes on every line.

## A dense layer is one matrix product

A **dense** (fully connected) layer takes $d$ inputs and produces $h$ outputs. Each output is a weighted sum of all the inputs, so the layer has a weight matrix $W$ of shape $(d, h)$ and a bias vector $b$ of shape $(h,)$. For a batch of $n$ examples stored as rows of $X$:

$$
Z = X W + b, \qquad X \in \mathbb{R}^{n \times d},\; W \in \mathbb{R}^{d \times h},\; Z \in \mathbb{R}^{n \times h}
$$

```python run
n, d, h = 5, 3, 4          # 5 examples, 3 input features, 4 outputs
rng = np.random.default_rng(0)
X = rng.normal(size=(n, d))
W = rng.normal(size=(d, h))
b = np.zeros(h)

Z = X @ W + b
print("X:", X.shape, "  W:", W.shape, "  b:", b.shape, "  Z:", Z.shape)
```

Read the shapes out loud: the inner dimensions match ($d$ and $d$) and the outer dimensions give the result ($n$ by $h$). This rule never changes, however big the network.

Shape errors are the first thing to check when a network misbehaves. Here is a deliberately wrong attempt to apply `W` to a single example, which fails in a useful way:

```python run error
x_single = X[0]                 # shape (3,)
W_wrong = rng.normal(size=(4, 3))
Z_wrong = W_wrong @ X           # the matrix is on the wrong side
print(Z_wrong.shape)
```

## Two layers and a non-linearity

A network is layers in sequence. A hidden layer applies a non-linear activation, here ReLU from the last lesson, and then the next layer reads its output.

```python run
def relu(z):
    return np.maximum(0, z)

W1 = rng.normal(size=(3, 8)) * 0.5
b1 = np.zeros(8)
W2 = rng.normal(size=(8, 2)) * 0.5
b2 = np.zeros(2)

H = relu(X @ W1 + b1)      # hidden layer: (5, 8)
Y = H @ W2 + b2            # output layer: (5, 2)
print("hidden:", H.shape, "| output:", Y.shape)
print("first example''s output:", np.round(Y[0], 3))
```

Every row of `Y` is the network''s answer for one example. Nothing in this cell is special to two layers: add another line, and you have a deeper network.

## Batching is faster and more honest

You could loop over the examples, but NumPy is built for the matrix form. The loop and the batch compute the same numbers, and the batch is much faster. Check it:

```python run
loop_out = np.stack([relu(x @ W1 + b1) @ W2 + b2 for x in X])
batch_out = relu(X @ W1 + b1) @ W2 + b2
print("loop and batch agree:", np.allclose(loop_out, batch_out))
```

> **Under the hood:** GPUs and CPUs get their speed from large matrix products. Every framework you will use, including PyTorch, expresses the forward pass as these batched products for exactly this reason.

## Challenge: a dense layer

```python exercise id=dense-layer title="Write a dense layer"
# TODO: `dense(X, W, b)` should return X @ W + b for a batch X of shape (n, d).
def dense(X, W, b):
    ...
--- solution
def dense(X, W, b):
    return X @ W + b
--- test
X_test = np.array([[1.0, 2.0], [0.0, -1.0], [3.0, 0.5]])
W_test = np.array([[1.0, 0.0, -1.0], [0.5, 2.0, 1.0]])
b_test = np.array([0.1, 0.2, 0.3])
result = dense(X_test, W_test, b_test)
assert result is not None, "Replace the `...` in `dense` with code that returns the layer output."
assert result.shape == (3, 3), f"X has 3 rows and W has 3 columns, so the output should be (3, 3), but it has shape {result.shape}."
expected = X_test @ W_test + b_test
assert np.allclose(result, expected), "The output should be X @ W + b, with the bias added to every row."
X_other = np.ones((4, 2))
assert np.allclose(dense(X_other, W_test, np.zeros(3)), X_other @ W_test), "Check that the bias is optional when it is zero, and that the function works for any batch size."
--- hint
Use the matrix product `X @ W`, then add the bias. The bias has one entry per output, so it is broadcast to every row.
--- hint
`return X @ W + b`.
```

## Challenge: a two-layer forward pass

```python exercise id=two-layer title="Forward pass through two layers"
# TODO: `forward(X, W1, b1, W2, b2)` should apply a dense layer, then ReLU, then a second dense layer.
# It returns the output array of shape (n, k).
def forward(X, W1, b1, W2, b2):
    ...
--- solution
def forward(X, W1, b1, W2, b2):
    H = np.maximum(0, X @ W1 + b1)
    return H @ W2 + b2
--- test
X_test = np.array([[1.0, -1.0], [2.0, 0.5]])
W1_test = np.array([[1.0, -2.0, 0.0], [1.0, 1.0, 0.5]])
b1_test = np.zeros(3)
W2_test = np.array([[1.0], [-1.0], [2.0]])
b2_test = np.array([0.5])
result = forward(X_test, W1_test, b1_test, W2_test, b2_test)
assert result is not None, "Replace the `...` in `forward` with code that returns the network output."
assert result.shape == (2, 1), f"The output should have shape (2, 1) for 2 examples and 1 output, but it has {result.shape}."
hidden = np.maximum(0, X_test @ W1_test + b1_test)
assert np.allclose(result, hidden @ W2_test + b2_test), "The output should be the second layer applied to the ReLU of the first layer."
rng_t = np.random.default_rng(3)
X3 = rng_t.normal(size=(6, 2))
W1_3 = rng_t.normal(size=(2, 5)); W2_3 = rng_t.normal(size=(5, 3))
out3 = forward(X3, W1_3, np.zeros(5), W2_3, np.zeros(3))
assert out3.shape == (6, 3), f"For 6 examples and 3 outputs the shape should be (6, 3), but it is {out3.shape}."
--- hint
Compute the hidden layer first: `H = ` the ReLU of `X @ W1 + b1`. Then apply the second layer to `H`.
--- hint
`H = np.maximum(0, X @ W1 + b1)`, then `return H @ W2 + b2`.
```

## Debug a broadcasting bug

NumPy''s **broadcasting** rules quietly stretch arrays to fit each other. That is convenient, and it is also a classic source of silent bugs. The code below runs without an error, but the result is wrong.

```python debug id=broadcast-bias title="The bias is on the wrong axis"
X = np.array([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])     # 3 examples
W = np.array([[0.1, 0.2, 0.3], [0.4, 0.5, 0.6]])        # 2 inputs, 3 outputs
b = np.array([1.0, 2.0, 3.0])                           # one bias per output

Z = X @ W
Z_bad = Z + b.reshape(-1, 1)      # the bias is added along the wrong axis
print("shape:", Z_bad.shape)
print(Z_bad)
--- solution
X = np.array([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])     # 3 examples
W = np.array([[0.1, 0.2, 0.3], [0.4, 0.5, 0.6]])        # 2 inputs, 3 outputs
b = np.array([1.0, 2.0, 3.0])                           # one bias per output

Z = X @ W
Z_bad = Z + b
print("shape:", Z_bad.shape)
print(Z_bad)
--- test
assert Z_bad.shape == (3, 3), f"The output should keep shape (3, 3), but it has {Z_bad.shape}."
expected = X @ W + b
assert np.allclose(Z_bad, expected), "Each output column should get its own bias. The bias must be broadcast across the rows, not down the columns."
--- hint
Compare the shape of `b.reshape(-1, 1)` with the shape of `Z`. A column of biases adds one value per row, which is not what you want here.
--- hint
A bias of shape `(3,)` already broadcasts across the rows of `Z`. You do not need to reshape it.
```

## Predict the shape

```python predict id=predict-broadcast title="What shape does broadcasting give?"
a = np.ones((3, 1))
b = np.arange(4)
print((a + b).shape)
--- options
* (3, 4)
(4,)
(3,)
(3, 1)
--- explain
A column of shape (3, 1) and a row of shape (4,) broadcast to (3, 4). Each of the three rows of `a` is paired with all four entries of `b`. This is a useful trick, and an easy source of bugs when you wanted something else.
```

## Pitfall: check the shape before the values

> **Pitfall:** when a network produces a surprising loss, print the shape of every intermediate array first. Most "numerical" problems are shape problems in disguise, and broadcasting will hide them if you do not look.

## Recap

- A dense layer computes $XW + b$ for a batch, and the shapes must satisfy $(n, d) \cdot (d, h)$.
- A network is layers in sequence: linear, then non-linear, then linear again.
- Batch the computation with matrix products. Looping over examples gives the same numbers, only much slower.
- Broadcasting stretches arrays silently. Check shapes at every step, and be suspicious when something runs without an error.

**Up next:** loss functions. You will measure how wrong the output is, and the loss you choose changes what the network learns.
', 0, '[]', '[]', '2026-06-25T06:30:28.279Z', '2026-10-19T06:30:28.279Z'),
('les_deep_learning_foundations_1_5', 'sec_deep_learning_foundations_1', 'crs_deep_learning_foundations', 'Loss functions: measuring how wrong a model is', 'interactive', 4, 1080, NULL, NULL, 'A network makes predictions, and training needs a single number that says how wrong they are. That number is the **loss**. Gradient descent will push the weights to make it smaller, so the loss you choose is not a detail: it defines what "good" means to the model.

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
# probabilities with each row summing to 1. Subtract each row''s maximum before exponentiating.
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
assert np.allclose(probs.sum(axis=1), 1.0), f"Each example''s class probabilities must sum to 1, but the row sums are {probs.sum(axis=1)}."
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
', 0, '[]', '[]', '2026-06-25T06:30:28.279Z', '2026-10-19T06:30:28.279Z'),
('les_deep_learning_foundations_2_1', 'sec_deep_learning_foundations_2', 'crs_deep_learning_foundations', 'Gradient descent for a single neuron', 'interactive', 0, 960, NULL, NULL, 'A neural network learns by making its loss a little smaller on every step. The rule that decides *which way* to move each weight is **gradient descent**, and it is the same rule whether the network has one neuron or a billion. In this lesson you will train a single neuron by hand, with the gradient written out, and watch the loss fall.

## The idea: walk downhill

For a loss $L(w)$, the gradient $\frac{dL}{dw}$ points uphill. To reduce the loss, step the opposite way, by an amount set by the **learning rate** $\eta$:

$$
w \leftarrow w - \eta \,\frac{dL}{dw}
$$

A small learning rate takes safe, slow steps. A large one takes big steps and may overshoot the bottom of the valley.

```python run
import matplotlib.pyplot as plt

def L(w):
    return (w - 3.0) ** 2          # a simple bowl with its minimum at w = 3

w, lr = 0.0, 0.1
history = [w]
for _ in range(25):
    grad = 2 * (w - 3.0)           # dL/dw, worked out by hand
    w = w - lr * grad
    history.append(w)

print("final w:", round(w, 4), "| loss:", round(L(w), 6))
fig, ax = plt.subplots(figsize=(5, 3))
ws = np.linspace(-1, 7, 200)
ax.plot(ws, L(ws), color="grey"); ax.plot(history, L(np.array(history)), "o-", color="C1")
ax.set_xlabel("w"); ax.set_ylabel("loss"); ax.grid(alpha=0.3)
plt.show()
```

The orange path slides down the bowl and settles at $w = 3$. Each step is proportional to the slope, so the steps shrink as the bottom gets near.

## Check the gradient numerically

Before you trust a hand-written gradient, compare it with a finite-difference estimate. If they agree, the formula is right. This is a habit you should keep for the rest of the course.

```python run
def numerical_grad(f, w, h=1e-6):
    return (f(w + h) - f(w - h)) / (2 * h)

w0 = 0.5
print("analytic:", 2 * (w0 - 3.0))
print("numerical:", round(numerical_grad(L, w0), 6))
```

> **Pitfall:** gradient checks are slow, so use them to verify your code and turn them off for training. A correct gradient that you never checked is still a bet.

## Train a neuron on data

Now the real thing. The data follow $y = 2x + 1$ with a little noise. A linear neuron has a weight $w$ and bias $b$, and the mean squared error is the loss. Its gradients are:

$$
\frac{\partial L}{\partial w} = \frac{2}{n} \sum_i (\hat{y}_i - y_i)\, x_i, \qquad
\frac{\partial L}{\partial b} = \frac{2}{n} \sum_i (\hat{y}_i - y_i)
$$

```python run
rng = np.random.default_rng(0)
X = rng.uniform(-1, 1, size=(100, 1))
y = 2.0 * X[:, 0] + 1.0 + rng.normal(0, 0.1, size=100)

def predict(X, w, b):
    return X @ w + b

def grads(X, y, w, b):
    residual = predict(X, w, b) - y
    n = len(y)
    dw = 2 / n * (X.T @ residual)
    db = 2 / n * residual.sum()
    return dw, db

w = np.zeros(1)
b = 0.0
lr = 0.5
for step in range(200):
    dw, db = grads(X, y, w, b)
    w = w - lr * dw
    b = b - lr * db

print("learned w:", np.round(w, 3), "(true 2.0)")
print("learned b:", round(b, 3), "(true 1.0)")
```

After 200 steps the neuron has found the line. Nothing in the loop knows the answer; the gradient alone pointed it there.

## Watch the loss fall

```python run
w = np.zeros(1)
b = 0.0
losses = []
for step in range(100):
    pred = predict(X, w, b)
    losses.append(np.mean((pred - y) ** 2))
    dw, db = grads(X, y, w, b)
    w = w - lr * dw
    b = b - lr * db

print("loss at step 0:", round(losses[0], 4))
print("loss at step 99:", round(losses[-1], 4))
```

Try `lr = 0.05` and `lr = 1.5` in the cell above. The small rate learns slowly, and the large one can diverge: the weights grow larger and larger, and the loss explodes. Choosing the learning rate is the first hyperparameter decision you will make in practice.

## Challenge: the gradients of the loss

```python exercise id=linear-gradient title="Gradients of the squared-error loss"
# TODO: `mse_grads(X, y, w, b)` returns the pair (dw, db) of gradients of the mean squared error
# for the linear model pred = X @ w + b. dw has the same shape as w.
def mse_grads(X, y, w, b):
    ...
--- solution
def mse_grads(X, y, w, b):
    residual = X @ w + b - y
    n = len(y)
    dw = 2 / n * (X.T @ residual)
    db = 2 / n * residual.sum()
    return dw, db
--- test
X_t = np.array([[1.0], [2.0], [3.0]])
y_t = np.array([2.0, 4.0, 7.0])
result = mse_grads(X_t, y_t, np.array([0.5]), 0.0)
assert result is not None, "Replace the `...` in `mse_grads` with code that returns (dw, db)."
dw, db = result
assert np.shape(dw) == (1,), f"dw should have the same shape as w, which is (1,), but it has {np.shape(dw)}."
assert np.allclose(dw, [-16.0]), f"For this data dw should be -16.0, but you returned {dw}."
assert np.isclose(db, -20 / 3), f"For this data db should be -20/3 ≈ -6.667, but you returned {db}."
X_r = np.random.default_rng(1).normal(size=(20, 2))
y_r = np.random.default_rng(2).normal(size=20)
w_r, b_r = np.array([0.3, -0.2]), 0.1
eps = 1e-6
num_dw = np.array([(np.mean((X_r @ (w_r + eps * e) + b_r - y_r) ** 2) - np.mean((X_r @ (w_r - eps * e) + b_r - y_r) ** 2)) / (2 * eps) for e in np.eye(2)])
assert np.allclose(mse_grads(X_r, y_r, w_r, b_r)[0], num_dw, atol=1e-5), "dw does not match a numerical gradient check. Check the factor 2/n and the transpose."
--- hint
The residual is `X @ w + b - y`. The weight gradient multiplies the transposed inputs by the residual, and the bias gradient sums the residual.
--- hint
`dw = 2 / n * (X.T @ residual)` and `db = 2 / n * residual.sum()`, where `n = len(y)`.
```

## Challenge: take one step

```python exercise id=gd-step title="One gradient descent step"
# TODO: `gradient_step(w, b, dw, db, lr)` returns the updated parameters (w_new, b_new).
def gradient_step(w, b, dw, db, lr):
    ...
--- solution
def gradient_step(w, b, dw, db, lr):
    return w - lr * dw, b - lr * db
--- test
result = gradient_step(np.array([1.0, -1.0]), 0.5, np.array([2.0, 0.0]), 1.0, 0.1)
assert result is not None, "Replace the `...` in `gradient_step` with code that returns the new parameters."
w_new, b_new = result
assert np.allclose(w_new, [0.8, -1.0]), f"w should move against its gradient to [0.8, -1.0], but you returned {w_new}."
assert np.isclose(b_new, 0.4), f"b should move against its gradient to 0.4, but you returned {b_new}."
w2, b2 = gradient_step(np.zeros(3), 2.0, np.array([-1.0, 0.0, 1.0]), -3.0, 0.5)
assert np.allclose(w2, [0.5, 0.0, -0.5]) and np.isclose(b2, 3.5), "Subtract the learning rate times the gradient. A negative gradient should increase the parameter."
--- hint
Each parameter moves by `- lr * gradient`. Do this for `w` and for `b` separately.
--- hint
`return w - lr * dw, b - lr * db`.
```

## Debug the sign

```python debug id=sign-update title="Move downhill, not uphill"
w = np.array([0.0])
b = 0.0
dw = np.array([2.0])    # the gradient says the loss rises as w grows
db = 1.0
lr = 0.1

w = w + lr * dw         # which direction is this?
b = b - lr * db
print("w:", w, "b:", b)
--- solution
w = np.array([0.0])
b = 0.0
dw = np.array([2.0])    # the gradient says the loss rises as w grows
db = 1.0
lr = 0.1

w = w - lr * dw         # move against the gradient
b = b - lr * db
print("w:", w, "b:", b)
--- test
assert np.allclose(w, [-0.2]), f"w should move against its gradient, to [-0.2], but it is {w}. Gradient descent subtracts the step."
assert np.isclose(b, -0.1), f"b should be -0.1, but it is {b}."
--- hint
The gradient points uphill, and you want to go downhill. Compare the sign in the `w` line with the sign in the `b` line.
--- hint
Make the `w` line match the `b` line: `w = w - lr * dw`.
```

## Predict the update

```python predict id=predict-update title="Which way does w move?"
w = 1.0
dw = -4.0            # the loss decreases as w grows
lr = 0.25
w = w - lr * dw
print(w)
--- options
* 2.0
0.0
-2.0
1.0
--- explain
The gradient is negative, so the loss falls as w increases. The update subtracts lr × dw = 0.25 × (-4) = -1, which means w becomes 1 - (-1) = 2. The step is in the direction that lowers the loss.
```

## Recap

- Gradient descent moves each parameter by $-\eta \times$ its gradient, which is the direction that lowers the loss.
- The learning rate sets the step size. Too small is slow, too large can diverge.
- Check hand-written gradients with a numerical estimate before you trust them.
- For a linear neuron with squared error, the gradients are a residual multiplied by the inputs, and the bias gradient is the residual''s sum.

**Up next:** computational graphs. A network has many layers, and you need a way to apply the chain rule to all of them without writing each gradient by hand.
', 0, '[]', '[]', '2026-06-25T06:30:28.279Z', '2026-10-19T06:30:28.279Z'),
('les_deep_learning_foundations_2_2', 'sec_deep_learning_foundations_2', 'crs_deep_learning_foundations', 'Computational graphs and the chain rule', 'interactive', 1, 960, NULL, NULL, 'A two-neuron network already has a gradient that is annoying to write by hand. Ten layers make it hopeless. What saves you is a simple idea: write the computation as a **graph** of small operations, and apply the chain rule one node at a time, from the output back to the inputs. That procedure is **backpropagation**, and every deep-learning framework uses it.

In this lesson you will draw a computational graph, run the forward pass and the backward pass on paper and in code, and see why gradients from different paths add up.

## Every operation is a node

Take $f = (a \cdot b + c)^2$. Break it into the small steps a computer actually performs:

$$
e = a \cdot b, \qquad d = e + c, \qquad f = d^2
$$

Each line is one node. The forward pass computes the values from left to right. The backward pass asks, for each node, how much the output changes when that node changes.

```python run
a, b, c = 2.0, -3.0, 10.0

# forward pass: compute and remember every intermediate value
e = a * b
d = e + c
f = d ** 2
print("e =", e, "| d =", d, "| f =", f)
```

Save the intermediate values. Backpropagation needs them, and a framework stores exactly these values for you.

## The chain rule, one link at a time

The chain rule says that the derivative of a composition is the product of the local derivatives along the path:

$$
\frac{\partial f}{\partial a} = \frac{\partial f}{\partial d} \cdot \frac{\partial d}{\partial e} \cdot \frac{\partial e}{\partial a}
$$

Each local derivative is easy: $\partial f/\partial d = 2d$, $\partial d/\partial e = 1$ and $\partial e/\partial a = b$. Multiply them, starting from the output.

```python run
# backward pass: start at the output with df/df = 1 and walk back
df = 1.0
dd = df * 2 * d          # local derivative of d**2 is 2d
de = dd * 1.0            # local derivative of e + c with respect to e is 1
dc = dd * 1.0            # and with respect to c is also 1
da = de * b              # local derivative of a * b with respect to a is b
db = de * a              # and with respect to b is a

print("df/da =", da, "| df/db =", db, "| df/dc =", dc)
```

Each node sends one number backwards: the gradient of the output with respect to that node. A node only needs its own local derivative and the gradient arriving from above.

## Check it numerically

```python run
def f_of(a, b, c):
    return (a * b + c) ** 2

h = 1e-6
num_da = (f_of(a + h, b, c) - f_of(a - h, b, c)) / (2 * h)
num_dc = (f_of(a, b, c + h) - f_of(a, b, c - h)) / (2 * h)
print("numerical df/da:", round(num_da, 4), "| analytic:", da)
print("numerical df/dc:", round(num_dc, 4), "| analytic:", dc)
```

The backward pass and the finite-difference check agree. That agreement is the foundation of everything you will build in the next lessons.

## When one value feeds two paths

If a variable is used twice, its gradient is the **sum** of the gradients from each use. Consider $g = x^2 + 3x$. The value $x$ appears in two places, so its gradient collects both contributions.

```python run
x = 4.0
sq = x * x               # first use of x
lin = 3 * x              # second use of x
g = sq + lin

dg_dsq = 1.0
dg_dlin = 1.0
dx = dg_dsq * (2 * x) + dg_dlin * 3     # both paths add to x''s gradient
print("dg/dx =", dx, "| numerical:", round((((x + 1e-6) ** 2 + 3 * (x + 1e-6)) - (x * x + 3 * x)) / 1e-6, 4))
```

> **Pitfall:** when a value is used more than once, backprop must add its gradients, not replace them. Forgetting this is one of the most common bugs when people write their own autograd, and you will meet it in lesson 8.

## Challenge: the gradients of a small graph

```python exercise id=graph-grads title="Backprop through a small graph"
# TODO: `grads(a, b, c)` returns the tuple (df/da, df/db, df/dc) for f = (a * b + c) ** 2.
# Use the chain rule: the local derivatives are 2d for the square, 1 for the addition,
# b for the multiplication with respect to a, and a for the multiplication with respect to b.
def grads(a, b, c):
    ...
--- solution
def grads(a, b, c):
    e = a * b
    d = e + c
    df_dd = 2 * d
    return df_dd * b, df_dd * a, df_dd
--- test
result = grads(2.0, -3.0, 10.0)
assert result is not None, "Replace the `...` in `grads` with code that returns the three gradients."
da, db, dc = result
assert np.isclose(da, -24.0) and np.isclose(db, 16.0) and np.isclose(dc, 8.0), f"For a=2, b=-3, c=10 the gradients are (-24, 16, 8), but you returned {result}."
r2 = grads(1.0, 1.0, 0.0)
assert np.allclose(r2, (2.0, 2.0, 2.0)), f"For a=1, b=1, c=0 the gradients are (2, 2, 2), but you returned {r2}."
--- hint
Compute `d = a * b + c` first. The output''s gradient with respect to `d` is `2 * d`.
--- hint
Multiply that by `b` for `a`, by `a` for `b`, and by `1` for `c`.
```

## Challenge: a value used on two paths

```python exercise id=shared-gradient title="Add the gradients from both paths"
# TODO: `shared_grad(x)` returns dg/dx for g = x² + 3x. The value x is used on two paths,
# so its gradient is the sum of the two contributions.
def shared_grad(x):
    ...
--- solution
def shared_grad(x):
    return 2 * x + 3
--- test
result = shared_grad(4.0)
assert result is not None, "Replace the `...` in `shared_grad` with code that returns the gradient."
assert np.isclose(result, 11.0), f"For g = x² + 3x at x = 4 the gradient is 2x + 3 = 11, but you returned {result!r}."
assert np.isclose(shared_grad(-1.0), 1.0), "The gradient at x = -1 should be 1. Add the path through x² and the path through 3x."
--- hint
Differentiate each path separately: the x² path gives 2x, and the 3x path gives 3. Then add them.
--- hint
`return 2 * x + 3`.
```

## Debug the missing upstream gradient

```python debug id=upstream-gradient title="Multiply by the gradient from above"
# Local derivative of the square is 2d. Backprop must include the gradient that arrived from above.
a, b, c = 2.0, -3.0, 10.0
e = a * b
d = e + c
f = d ** 2
upstream = 0.5          # pretend a later layer already told us df/df = 0.5 ... not 1
df_dd = 2 * d           # local derivative only
da = df_dd * b
print("df/da seen by the optimizer:", da)
--- solution
a, b, c = 2.0, -3.0, 10.0
e = a * b
d = e + c
f = d ** 2
upstream = 0.5
df_dd = upstream * 2 * d
da = df_dd * b
print("df/da seen by the optimizer:", da)
--- test
assert np.isclose(da, -12.0), f"With an upstream gradient of 0.5, df/da should be -12.0, but you have {da}. Multiply the local derivative by the upstream gradient."
assert np.isclose(f, 16.0), "The forward value f should still be 16."
--- hint
The chain rule multiplies every local derivative by the gradient that arrives from the node above, which here is `upstream`.
--- hint
`df_dd = upstream * 2 * d`.
```

## Predict the gradient

```python predict id=predict-chain title="What is df/dx?"
x = 3.0
f = (2 * x) ** 2          # f = (2x)²
df_dx = 2 * (2 * x) * 2   # chain rule: outer derivative, then inner derivative
print(df_dx)
--- options
* 24.0
12.0
36.0
6.0
--- explain
f = 4x², so df/dx = 8x. At x = 3 that is 24. The chain rule gets there as 2 × (2x) × 2 = 8x, outer derivative times inner derivative.
```

## Recap

- A computation is a graph of small operations. The forward pass computes values; the backward pass computes gradients.
- The chain rule multiplies local derivatives along each path, starting from the output.
- A value used on several paths receives the sum of the gradients along all of them.
- Always verify a backward pass against a numerical estimate, and remember that gradients must include what arrives from above.

**Up next:** you will build a tiny automatic-differentiation engine. The computer will build the graph and run the backward pass for you, exactly as a framework does.
', 0, '[]', '[]', '2026-06-25T06:30:28.279Z', '2026-10-19T06:30:28.279Z'),
('les_deep_learning_foundations_2_3', 'sec_deep_learning_foundations_2', 'crs_deep_learning_foundations', 'Backpropagation with a tiny autograd engine', 'interactive', 2, 1200, NULL, NULL, 'You have now computed gradients by hand for one neuron and for a small graph. Writing those formulas for a real network would take forever, and every change to the architecture would break them. The fix is to let the computer build the graph and run the backward pass for you. That is what **automatic differentiation**, or **autograd**, does, and it is the engine inside every deep-learning framework.

In this lesson you will read a complete autograd engine of about forty lines, then write its two most important pieces yourself: the backward rule for multiplication, and the procedure that walks the graph.

## A value that remembers how it was made

The idea is simple. Each number becomes a `Value` object that stores three things: its data, its gradient, and a small function that knows how to push the gradient back to the values that produced it. Adding or multiplying two `Value`s builds a new `Value` and records the link.

```python run
import numpy as np

class Value:
    def __init__(self, data, parents=()):
        self.data = float(data)
        self.grad = 0.0
        self._backward = lambda: None
        self._parents = parents

    def __add__(self, other):
        other = other if isinstance(other, Value) else Value(other)
        out = Value(self.data + other.data, (self, other))
        def _backward():
            self.grad += out.grad
            other.grad += out.grad
        out._backward = _backward
        return out

    def __mul__(self, other):
        other = other if isinstance(other, Value) else Value(other)
        out = Value(self.data * other.data, (self, other))
        def _backward():
            self.grad += other.data * out.grad
            other.grad += self.data * out.grad
        out._backward = _backward
        return out

    def tanh(self):
        t = np.tanh(self.data)
        out = Value(t, (self,))
        def _backward():
            self.grad += (1 - t ** 2) * out.grad
        out._backward = _backward
        return out

    def backward(self):
        order, seen = [], set()
        def build(v):
            if v not in seen:
                seen.add(v)
                for p in v._parents:
                    build(p)
                order.append(v)
        build(self)
        self.grad = 1.0
        for v in reversed(order):
            v._backward()

    __radd__ = __add__
    __rmul__ = __mul__

print("Value engine ready")
```

The class is short, but read it slowly. The `+=` in every `_backward` is the important part: a value used on several paths collects the gradient from each of them, which is the rule you saw in lesson 7.

## Run it on a small expression

```python run
a = Value(2.0)
b = Value(-3.0)
c = Value(10.0)
d = a * b + c           # d = a·b + c
f = d * d               # d is used twice
f.backward()

print("f =", f.data)
print("df/da =", a.grad, "(expected -24)")
print("df/db =", b.grad, "(expected 16)")
print("df/dc =", c.grad, "(expected 8)")
```

The engine reproduces the numbers from lesson 7 without a single formula written by hand.

## A neuron with tanh, with autograd

```python run
x1, x2 = Value(0.5), Value(-1.0)
w1, w2 = Value(0.8), Value(0.3)
bias = Value(0.1)

n = x1 * w1 + x2 * w2 + bias
out = n.tanh()
out.backward()

print("output:", round(out.data, 4))
print("grad w1:", round(w1.grad, 4), "| grad w2:", round(w2.grad, 4))
```

Every weight now has a gradient, and the training loop only has to subtract a little of each.

## Check it numerically

Trust the engine the way you trust your own code: test it against a numerical estimate.

```python run
def forward(w1_value):
    return np.tanh(0.5 * w1_value - 0.3 + 0.1)

h = 1e-6
numeric = (forward(0.8 + h) - forward(0.8 - h)) / (2 * h)
print("numerical grad w1:", round(numeric, 4), "| engine:", round(w1.grad, 4))
```

## Gradients accumulate, and so do calls

Calling `backward` twice on the same graph adds to the gradients a second time. This is why real frameworks ask you to zero the gradients before each training step, and you will see the same rule in PyTorch.

```python run
w = Value(1.0)
diff = w + (-4.0)           # w - 4, built from the operations we have
loss = diff * diff          # loss = (w - 4)², with diff used twice
loss.backward()
print("after one backward:", w.grad)
loss.backward()
print("after a second backward:", w.grad)
```

> **In the wild:** PyTorch''s `loss.backward()` accumulates into `.grad` in exactly this way. Forgetting `optimizer.zero_grad()` is the most common reason a training run behaves oddly for no visible reason.

## Challenge: backward for multiplication

The starter below is almost complete. Your task is the backward rule for `__mul__`: the gradient with respect to each input is the other input times the gradient of the output.

```python exercise id=value-mul title="Multiplication with its backward rule"
class Value:
    def __init__(self, data, parents=()):
        self.data = float(data)
        self.grad = 0.0
        self._backward = lambda: None
        self._parents = parents

    def __add__(self, other):
        other = other if isinstance(other, Value) else Value(other)
        out = Value(self.data + other.data, (self, other))
        def _backward():
            self.grad += out.grad
            other.grad += out.grad
        out._backward = _backward
        return out

    def __mul__(self, other):
        # TODO: return a new Value holding self.data * other.data, and set its
        # _backward so it adds other.data * out.grad to self.grad and self.data * out.grad to other.grad.
        ...

    __radd__ = __add__
    __rmul__ = __mul__
--- solution
class Value:
    def __init__(self, data, parents=()):
        self.data = float(data)
        self.grad = 0.0
        self._backward = lambda: None
        self._parents = parents

    def __add__(self, other):
        other = other if isinstance(other, Value) else Value(other)
        out = Value(self.data + other.data, (self, other))
        def _backward():
            self.grad += out.grad
            other.grad += out.grad
        out._backward = _backward
        return out

    def __mul__(self, other):
        other = other if isinstance(other, Value) else Value(other)
        out = Value(self.data * other.data, (self, other))
        def _backward():
            self.grad += other.data * out.grad
            other.grad += self.data * out.grad
        out._backward = _backward
        return out

    __radd__ = __add__
    __rmul__ = __mul__
--- test
a = Value(2.0)
b = Value(-3.0)
out = a * b
assert out is not None, "Replace the `...` in `__mul__` so it returns a new Value."
assert isinstance(out, Value), "`__mul__` should return a Value."
assert out.data == -6.0, f"2 × -3 should be -6, but the output holds {out.data}."
out.grad = 1.0
out._backward()
assert a.grad == -3.0, f"The gradient for a should be b = -3, but it is {a.grad}. Use the other input''s data times out.grad."
assert b.grad == 2.0, f"The gradient for b should be a = 2, but it is {b.grad}."
x = Value(5.0)
y = x * 3.0
assert y.data == 15.0, "Multiplying by a plain number should also work, through Value(3.0)."
--- hint
Create `out = Value(self.data * other.data, (self, other))`, then write a `_backward` function that adds to both inputs'' gradients, as `__add__` does.
--- hint
Inside `_backward`, `self.grad += other.data * out.grad` and `other.grad += self.data * out.grad`, then set `out._backward = _backward` and return `out`.
```

## Challenge: walk the graph

Calling `_backward` on each node in the wrong order gives wrong answers. The correct procedure visits every node once, in reverse topological order, so that a node''s gradient is complete before it passes that gradient on. Write `backward(self)` for the class below.

```python exercise id=value-backward title="Backpropagate through the whole graph"
class Value:
    def __init__(self, data, parents=()):
        self.data = float(data)
        self.grad = 0.0
        self._backward = lambda: None
        self._parents = parents

    def __add__(self, other):
        other = other if isinstance(other, Value) else Value(other)
        out = Value(self.data + other.data, (self, other))
        def _backward():
            self.grad += out.grad
            other.grad += out.grad
        out._backward = _backward
        return out

    def __mul__(self, other):
        other = other if isinstance(other, Value) else Value(other)
        out = Value(self.data * other.data, (self, other))
        def _backward():
            self.grad += other.data * out.grad
            other.grad += self.data * out.grad
        out._backward = _backward
        return out

    def backward(self):
        # TODO: order the graph so every node comes after its parents (a depth-first
        # walk that records each node once), set self.grad = 1.0, then call _backward
        # on the nodes in reverse order.
        ...

    __radd__ = __add__
    __rmul__ = __mul__
--- solution
class Value:
    def __init__(self, data, parents=()):
        self.data = float(data)
        self.grad = 0.0
        self._backward = lambda: None
        self._parents = parents

    def __add__(self, other):
        other = other if isinstance(other, Value) else Value(other)
        out = Value(self.data + other.data, (self, other))
        def _backward():
            self.grad += out.grad
            other.grad += out.grad
        out._backward = _backward
        return out

    def __mul__(self, other):
        other = other if isinstance(other, Value) else Value(other)
        out = Value(self.data * other.data, (self, other))
        def _backward():
            self.grad += other.data * out.grad
            other.grad += self.data * out.grad
        out._backward = _backward
        return out

    def backward(self):
        order, seen = [], set()
        def build(v):
            if v not in seen:
                seen.add(v)
                for p in v._parents:
                    build(p)
                order.append(v)
        build(self)
        self.grad = 1.0
        for v in reversed(order):
            v._backward()

    __radd__ = __add__
    __rmul__ = __mul__
--- test
a = Value(2.0)
b = Value(3.0)
c = a * b + a          # c = a·b + a, so dc/da = b + 1 = 4 and dc/db = a = 2
assert c is not None and c.data == 8.0, "Check that `__add__` and `__mul__` produce c = 8."
c.backward()
assert np.isclose(a.grad, 4.0), f"a is used on two paths, so its gradient should be b + 1 = 4, but it is {a.grad}. Accumulate with += across the whole graph."
assert np.isclose(b.grad, 2.0), f"The gradient for b should be a = 2, but it is {b.grad}."
x = Value(2.0)
y = x * x               # y = x², so dy/dx = 2x = 4
y.backward()
assert np.isclose(x.grad, 4.0), f"For y = x * x with x = 2, the gradient should be 4, but it is {x.grad}."
p = Value(-1.0)
q = (p * p + p) * p     # q = p³ + p², dq/dp = 3p² + 2p = 1 at p = -1
q.backward()
assert np.isclose(p.grad, 1.0), f"For q = p³ + p² at p = -1 the gradient should be 1, but it is {p.grad}."
--- hint
Make a list of every node in the graph, visiting each one once and visiting its parents before the node itself. A recursive helper with a `seen` set does this.
--- hint
After you build `order`, set `self.grad = 1.0`. Then loop over `reversed(order)` and call each node''s `_backward()`.
```

## Debug the accumulation bug

Here is a minimal engine with a classic bug. The gradient is assigned instead of accumulated, so a value used twice loses one of its contributions.

```python debug id=assign-not-add title="Accumulate, don''t overwrite"
class Value:
    def __init__(self, data):
        self.data = float(data)
        self.grad = 0.0
        self._backward = lambda: None
        self._parents = ()

    def __mul__(self, other):
        out = Value(self.data * other.data)
        def _backward():
            self.grad = other.data * out.grad      # bug: this overwrites the gradient
            other.grad = self.data * out.grad
        out._backward = _backward
        out._parents = (self, other)
        return out

    def backward(self):
        order, seen = [], set()
        def build(v):
            if v not in seen:
                seen.add(v)
                for p in v._parents:
                    build(p)
                order.append(v)
        build(self)
        self.grad = 1.0
        for v in reversed(order):
            v._backward()

a = Value(3.0)
y = a * a           # y = a², so dy/da = 2a = 6
y.backward()
print("dy/da =", a.grad, "(expected 6.0)")
--- solution
class Value:
    def __init__(self, data):
        self.data = float(data)
        self.grad = 0.0
        self._backward = lambda: None
        self._parents = ()

    def __mul__(self, other):
        out = Value(self.data * other.data)
        def _backward():
            self.grad += other.data * out.grad
            other.grad += self.data * out.grad
        out._backward = _backward
        out._parents = (self, other)
        return out

    def backward(self):
        order, seen = [], set()
        def build(v):
            if v not in seen:
                seen.add(v)
                for p in v._parents:
                    build(p)
                order.append(v)
        build(self)
        self.grad = 1.0
        for v in reversed(order):
            v._backward()

a = Value(3.0)
y = a * a           # y = a², so dy/da = 2a = 6
y.backward()
print("dy/da =", a.grad, "(expected 6.0)")
--- test
a = Value(3.0)
y = a * a
y.backward()
assert np.isclose(a.grad, 6.0), f"dy/da for y = a² at a = 3 is 6, but a.grad is {a.grad}. When a value is used twice, both contributions must add up."
b = Value(2.0)
z = b * Value(5.0)
z.backward()
assert np.isclose(b.grad, 5.0), f"The gradient for b in z = b × 5 should be 5, but it is {b.grad}."
--- hint
Both uses of `a` in `a * a` call `_backward`, and each one should add its share. Look at the two lines that assign to `grad`.
--- hint
Replace `=` with `+=` on both lines in `_backward`.
```

## Predict the accumulated gradient

```python predict id=predict-accumulate title="What does the gradient total?"
a = 3.0
grad = 0.0
grad += 2 * a      # first path through the graph
grad += 2 * a      # second path through the graph
print(grad)
--- options
* 12.0
6.0
4.0
18.0
--- explain
Each path adds 2 × 3 = 6, and the two paths together give 12. The same accumulation rule is what lets a value used many times collect its full gradient.
```

## Recap

- An autograd engine stores each value with its gradient and the rule that propagates it backwards.
- Backpropagation walks the graph in reverse topological order, so each node''s gradient is complete before it is used.
- Gradients accumulate with `+=`. A value used on several paths needs the sum of all of them.
- Forgetting to zero gradients between training steps makes gradients accumulate across steps, which is a common and silent bug.

**Up next:** the same idea applied to whole layers at once. A dense layer''s backward pass is three matrix products, and you will derive each one.
', 0, '[]', '[]', '2026-06-25T06:30:28.279Z', '2026-10-19T06:30:28.279Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_deep_learning_foundations_2_4', 'sec_deep_learning_foundations_2', 'crs_deep_learning_foundations', 'Backpropagation through a dense layer', 'interactive', 3, 1200, NULL, NULL, 'The autograd engine works on single numbers. Real networks work on matrices, and processing one example at a time would be far too slow. The good news is that the backward pass of a dense layer is only three matrix products, and each one has a clear meaning. In this lesson you will derive them, implement them, and check them against numerical gradients, so you can trust the code you run to train a network.

## The shapes tell you the answer

For a dense layer $Z = X W + b$, with inputs $X$ of shape $(n, d)$, weights $W$ of shape $(d, h)$ and bias $b$ of shape $(h,)$, suppose the loss gives you the gradient of the loss with respect to the output, $\partial L / \partial Z$, of shape $(n, h)$. Call it $dZ$.

Then the three gradients must have the same shapes as the things they are gradients of:

$$
dW = X^{\top} dZ \quad (d, h), \qquad
db = \sum_{i=1}^{n} dZ_i \quad (h,), \qquad
dX = dZ \, W^{\top} \quad (n, d)
$$

Shapes alone can pin down the transposes. If you get a shape wrong, the matrix product will fail or give the wrong shape, and that is your first clue.

## Derive the weight gradient

Take one weight $W_{jk}$. It affects output $Z_{ik}$ by multiplying the input $X_{ij}$. Summing over the batch gives $\partial L / \partial W_{jk} = \sum_i X_{ij} \, dZ_{ik}$, which is exactly the $(j, k)$ entry of $X^{\top} dZ$.

```python run
import numpy as np

rng = np.random.default_rng(0)
n, d, h = 4, 3, 2
X = rng.normal(size=(n, d))
W = rng.normal(size=(d, h))
b = np.zeros(h)
G = rng.normal(size=(n, h))        # a fixed "upstream" gradient, to test against

def loss(W):
    Z = X @ W + b
    return np.sum(Z * G)           # a simple scalar whose gradient w.r.t. Z is G

dW = X.T @ G                       # the formula
h_step = 1e-6
numeric = np.zeros_like(W)
for j in range(d):
    for k in range(h):
        E = np.zeros_like(W); E[j, k] = h_step
        numeric[j, k] = (loss(W + E) - loss(W - E)) / (2 * h_step)
print("max difference:", np.max(np.abs(dW - numeric)))
```

A difference near $10^{-9}$ means the formula is right. This is the check you will reuse for every layer you write.

## Derive the bias and input gradients

The bias is added to every row, so its gradient sums over the batch. The input gradient passes the output gradient back through the transposed weights:

```python run
db = G.sum(axis=0)
dX = G @ W.T
print("db shape:", db.shape, "(one per output)")
print("dX shape:", dX.shape, "(same as X)")
```

> **Pitfall:** `db` must sum over the batch, not keep it. A bias gradient with shape `(n, h)` is a bug that often still runs, because broadcasting quietly accepts it.

## A full layer with ReLU

A hidden layer adds an activation, $A = \operatorname{relu}(Z)$. Its backward pass multiplies the incoming gradient by the ReLU derivative from lesson 3: pass the gradient through where $Z > 0$, and block it elsewhere.

```python run
def relu(z):
    return np.maximum(0, z)

X = rng.normal(size=(5, 3))
W1 = rng.normal(size=(3, 4)) * 0.5
b1 = np.zeros(4)

Z1 = X @ W1 + b1
A1 = relu(Z1)
dA1 = rng.normal(size=A1.shape)          # pretend this came from the next layer
dZ1 = dA1 * (Z1 > 0)                     # the ReLU backward rule
dW1 = X.T @ dZ1
db1 = dZ1.sum(axis=0)
print("dW1:", dW1.shape, "| db1:", db1.shape)
print("gradient blocked by ReLU in", np.sum(Z1 <= 0), "of", Z1.size, "entries")
```

## Check the whole layer

```python run
def layer_loss(W1_try):
    return np.sum(relu(X @ W1_try + b1) * dA1)

eps = 1e-6
num = np.zeros_like(W1)
for j in range(W1.shape[0]):
    for k in range(W1.shape[1]):
        E = np.zeros_like(W1); E[j, k] = eps
        num[j, k] = (layer_loss(W1 + E) - layer_loss(W1 - E)) / (2 * eps)
print("max difference for dW1:", np.max(np.abs(dW1 - num)))
```

Every gradient in the layer is now verified. A gradient check is the standard way to find a broken backward pass, and it takes a few lines.

## Challenge: the dense backward pass

```python exercise id=dense-backward title="Backward pass of a dense layer"
# TODO: `dense_backward(X, W, dZ)` returns the tuple (dX, dW, db) for the layer Z = X @ W + b.
# dX has the shape of X, dW the shape of W, and db has one entry per output.
def dense_backward(X, W, dZ):
    ...
--- solution
def dense_backward(X, W, dZ):
    dX = dZ @ W.T
    dW = X.T @ dZ
    db = dZ.sum(axis=0)
    return dX, dW, db
--- test
rng_t = np.random.default_rng(7)
X_t = rng_t.normal(size=(4, 3))
W_t = rng_t.normal(size=(3, 2))
dZ_t = rng_t.normal(size=(4, 2))
result = dense_backward(X_t, W_t, dZ_t)
assert result is not None, "Replace the `...` in `dense_backward` with code that returns (dX, dW, db)."
dX, dW, db = result
assert dX.shape == X_t.shape, f"dX should have the shape of X, {X_t.shape}, but it has {dX.shape}."
assert dW.shape == W_t.shape, f"dW should have the shape of W, {W_t.shape}, but it has {dW.shape}."
assert db.shape == (2,), f"db should have one entry per output, shape (2,), but it has {db.shape}. Sum over the batch."
assert np.allclose(dW, X_t.T @ dZ_t), "dW should be Xᵀ dZ."
assert np.allclose(dX, dZ_t @ W_t.T), "dX should be dZ Wᵀ."
assert np.allclose(db, dZ_t.sum(axis=0)), "db should be the sum of dZ over the batch."
--- hint
Write the three formulas from the lesson: `dX = dZ @ W.T`, `dW = X.T @ dZ`, and `db = dZ.sum(axis=0)`.
--- hint
Transposes are the only tricky part. The input gradient transposes `W`, and the weight gradient transposes `X`.
```

## Challenge: the ReLU backward pass

```python exercise id=relu-backward title="Backward pass of ReLU"
# TODO: `relu_backward(dA, Z)` returns the gradient with respect to Z: dA where Z > 0, and 0 elsewhere.
def relu_backward(dA, Z):
    ...
--- solution
def relu_backward(dA, Z):
    return dA * (Z > 0)
--- test
dA_t = np.array([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]])
Z_t = np.array([[-1.0, 0.5, 0.0], [2.0, -3.0, 1.0]])
result = relu_backward(dA_t, Z_t)
assert result is not None, "Replace the `...` in `relu_backward` with code that returns dZ."
assert np.allclose(result, [[0.0, 2.0, 0.0], [4.0, 0.0, 6.0]]), f"Only entries with Z > 0 should pass the gradient through. You returned {result}."
assert result.shape == dA_t.shape, "The gradient should keep the shape of dA."
--- hint
Multiply `dA` by a boolean mask made from `Z > 0`. NumPy multiplies booleans as 0 and 1.
--- hint
`return dA * (Z > 0)`. At exactly zero the gradient is blocked, which matches the derivative used in lesson 3.
```

## Debug the weight gradient

```python debug id=transpose-dw title="Transpose the right matrix"
rng_d = np.random.default_rng(2)
X = rng_d.normal(size=(6, 3))       # 6 examples, 3 inputs
dZ = rng_d.normal(size=(6, 2))      # 6 examples, 2 outputs
W = rng_d.normal(size=(3, 2))       # the weights have shape (3, 2)

dW = dZ.T @ X                        # the weight gradient must match W''s shape
print("dW shape:", dW.shape, "| W shape:", W.shape)
--- solution
rng_d = np.random.default_rng(2)
X = rng_d.normal(size=(6, 3))       # 6 examples, 3 inputs
dZ = rng_d.normal(size=(6, 2))      # 6 examples, 2 outputs
W = rng_d.normal(size=(3, 2))       # the weights have shape (3, 2)

dW = X.T @ dZ                        # the weight gradient must match W''s shape
print("dW shape:", dW.shape, "| W shape:", W.shape)
--- test
assert dW.shape == W.shape, f"dW must have the same shape as W, {W.shape}, but it has {dW.shape}."
assert np.allclose(dW, X.T @ dZ), "dW should be Xᵀ dZ, the sum over the batch of the input times the output gradient."
--- hint
Work out the shape of each product. `X.T @ dZ` is `(3, 6) @ (6, 2)`, which gives `(3, 2)`, the shape of W.
--- hint
Which matrix needs transposing so that the batch dimension is summed over? In `dZ.T @ X`, the batch is not the one being summed.
```

## Predict the shape

```python predict id=predict-dw title="What shape is the weight gradient?"
X = np.ones((10, 4))     # 10 examples, 4 inputs
dZ = np.ones((10, 3))    # 10 examples, 3 outputs
print((X.T @ dZ).shape)
--- options
* (4, 3)
(10, 3)
(3, 4)
(10, 4)
--- explain
Xᵀ has shape (4, 10) and dZ has shape (10, 3), so the product is (4, 3). That is the shape of the weight matrix of a layer with 4 inputs and 3 outputs, so the shapes line up.
```

## Recap

- For $Z = XW + b$, the gradients are $dW = X^{\top} dZ$, $db = \sum dZ$, and $dX = dZ\, W^{\top}$.
- Each gradient has the shape of the thing it differentiates. Use shapes to catch mistakes early.
- The ReLU backward pass multiplies by a mask: gradients pass through only where the input was positive.
- Verify every layer with a numerical gradient check before you use it to train.

**Up next:** the first checkpoint quiz, and then you will train a full multi-layer network with these pieces.
', 0, '[]', '[]', '2026-06-25T06:30:28.279Z', '2026-10-19T06:30:28.279Z'),
('les_deep_learning_foundations_2_5', 'sec_deep_learning_foundations_2', 'crs_deep_learning_foundations', 'Checkpoint: neurons and backpropagation', 'quiz', 4, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"A neuron computes z = w · x + b and then applies an activation. Which parameters does the neuron learn?","options":["Only the inputs x","The weights w and the bias b","Only the activation function","The learning rate"],"answerIndex":1,"explanation":"The inputs come from the data. Training adjusts the weights and the bias, which are the neuron''s parameters."},{"id":"q2","prompt":"Why does a network need a non-linear activation between layers?","options":["To make training faster","Without one, stacked linear layers collapse into a single linear map","To keep the weights between 0 and 1","To reduce the number of parameters"],"answerIndex":1,"explanation":"W2 (W1 x) is just (W2 W1) x. A non-linearity between the layers is what lets depth add expressive power."},{"id":"q3","prompt":"A batch of 32 examples with 10 features goes through a dense layer with 4 outputs. What is the shape of the output Z = X @ W + b?","options":["(10, 4)","(32, 10)","(32, 4)","(4,)"],"answerIndex":2,"explanation":"X is (32, 10) and W is (10, 4). The matrix product is (32, 4), one row of four outputs per example."},{"id":"q4","prompt":"Which statement about the chain rule in backpropagation is correct?","options":["Gradients are multiplied along the path from the output back to the parameter","Gradients are added along the path from the output back to the parameter","Each gradient is computed independently of the others","Gradients only exist for the last layer"],"answerIndex":0,"explanation":"For a chain of functions, the derivative of the composition is the product of the local derivatives. Backprop multiplies them as it walks backwards."},{"id":"q5","prompt":"For a network with a loss L, what does the gradient ∂L/∂w tell you?","options":["The exact value of the loss after training","How much the loss changes for a small change in w, which tells you which way to move w","The number of times w was used","The best value for w"],"answerIndex":1,"explanation":"The gradient is the local rate of change. Gradient descent moves each weight a small step in the direction that decreases the loss."}]', '[]', '2026-06-25T06:30:28.279Z', '2026-10-19T06:30:28.279Z'),
('les_deep_learning_foundations_3_1', 'sec_deep_learning_foundations_3', 'crs_deep_learning_foundations', 'Training a multi-layer network from scratch', 'interactive', 0, 1200, NULL, NULL, 'Now the pieces come together. You have a forward pass, a loss, and the backward formulas for a dense layer. In this lesson you will train a **multi-layer perceptron** (MLP), a network with a hidden layer, on a problem that a single neuron cannot solve. You will watch the loss fall, see the decision boundary bend around the data, and then rebuild the key steps yourself.

## A problem a line cannot solve

The "two moons" dataset is two interleaved crescents. No straight line separates them, so a single neuron from lesson 2 will fail. A hidden layer of non-linear units can bend the boundary into the right shape.

```python run
import matplotlib.pyplot as plt

def make_moons(n=200, noise=0.15, seed=0):
    rng = np.random.default_rng(seed)
    t = np.linspace(0, np.pi, n // 2)
    upper = np.column_stack([np.cos(t), np.sin(t)])
    lower = np.column_stack([1 - np.cos(t), 0.5 - np.sin(t)])
    X = np.vstack([upper, lower]) + rng.normal(0, noise, size=(n, 2))
    y = np.concatenate([np.zeros(n // 2), np.ones(n // 2)])
    return X, y

X, y = make_moons()
y2 = y.reshape(-1, 1)            # one column of labels, shape (n, 1)

fig, ax = plt.subplots(figsize=(4.5, 4))
ax.scatter(X[y == 0, 0], X[y == 0, 1], label="class 0")
ax.scatter(X[y == 1, 0], X[y == 1, 1], label="class 1")
ax.legend(); ax.grid(alpha=0.3)
plt.show()
```

## The network

The model has 2 inputs, 16 hidden units with `tanh`, and one output unit with a sigmoid that gives a probability. Its parameters live in a dictionary so the code stays readable.

```python run
def init_params(rng, n_in=2, n_hidden=16):
    return {
        "W1": rng.normal(0, 0.5, size=(n_in, n_hidden)),
        "b1": np.zeros(n_hidden),
        "W2": rng.normal(0, 0.5, size=(n_hidden, 1)),
        "b2": np.zeros(1),
    }

def forward(X, p):
    Z1 = X @ p["W1"] + p["b1"]
    A1 = np.tanh(Z1)
    Z2 = A1 @ p["W2"] + p["b2"]
    P = 1 / (1 + np.exp(-Z2))
    return A1, P

def bce(P, Y):
    P = np.clip(P, 1e-12, 1 - 1e-12)
    return -np.mean(Y * np.log(P) + (1 - Y) * np.log(1 - P))

params = init_params(np.random.default_rng(1))
for name, value in params.items():
    print(name, value.shape)

A1, P = forward(X, params)
print("initial loss:", round(bce(P, y2), 4), "(about log 2 = 0.6931 for untrained output)")
```

Look at the initial loss. A network that has learned nothing outputs probabilities near one half, and the binary cross-entropy is near $\log 2$. Training has to move it well below that.

## Backpropagation, step by step

For a sigmoid output with binary cross-entropy, the gradient with respect to the output pre-activation has a famously simple form: $dZ_2 = (P - Y)/n$. The hidden layer then passes that gradient back through $W_2$ and the tanh derivative $1 - A_1^2$. Each step is one of the formulas from lesson 9.

```python run
def backward(X, Y, p, A1, P):
    n = X.shape[0]
    dZ2 = (P - Y) / n
    dW2 = A1.T @ dZ2
    db2 = dZ2.sum(axis=0)
    dA1 = dZ2 @ p["W2"].T
    dZ1 = dA1 * (1 - A1 ** 2)
    dW1 = X.T @ dZ1
    db1 = dZ1.sum(axis=0)
    return {"W1": dW1, "b1": db1, "W2": dW2, "b2": db2}

grads = backward(X, y2, params, A1, P)
for name in grads:
    print("grad", name, grads[name].shape, "matches parameter", params[name].shape)
```

## Train it

```python run
rng = np.random.default_rng(1)
params = init_params(rng)
lr = 0.5
losses = []
for epoch in range(1200):
    A1, P = forward(X, params)
    losses.append(bce(P, y2))
    grads = backward(X, y2, params, A1, P)
    for name in params:
        params[name] = params[name] - lr * grads[name]

A1, P = forward(X, params)
accuracy = np.mean((P > 0.5) == y2)
print("loss after 1200 epochs:", round(losses[-1], 4))
print("training accuracy:", round(float(accuracy), 3))
```

A training run is this loop: forward, loss, backward, update. Every deep network you will ever train is this loop with more layers, more data and a fancier update rule.

## See the boundary

```python run
gx, gy = np.meshgrid(np.linspace(-2, 3, 200), np.linspace(-1.5, 2, 200))
grid = np.column_stack([gx.ravel(), gy.ravel()])
_, Pgrid = forward(grid, params)
fig, ax = plt.subplots(figsize=(5, 4))
ax.contourf(gx, gy, Pgrid.reshape(gx.shape), levels=[0, 0.5, 1], alpha=0.25)
ax.scatter(X[y == 0, 0], X[y == 0, 1], s=12, label="class 0")
ax.scatter(X[y == 1, 0], X[y == 1, 1], s=12, label="class 1")
ax.legend(); ax.grid(alpha=0.3)
plt.show()
```

The boundary now curves around the crescents. A single neuron could never draw this.

## Challenge: the output gradient

```python exercise id=output-grad title="The output gradient for sigmoid and cross-entropy"
# TODO: `output_grad(P, Y)` returns dZ2 = (P - Y) / n, where n is the number of examples.
def output_grad(P, Y):
    ...
--- solution
def output_grad(P, Y):
    return (P - Y) / P.shape[0]
--- test
P_t = np.array([[0.8], [0.2], [0.5], [0.9]])
Y_t = np.array([[1.0], [0.0], [1.0], [1.0]])
result = output_grad(P_t, Y_t)
assert result is not None, "Replace the `...` in `output_grad` with code that returns dZ2."
assert result.shape == (4, 1), f"dZ2 should have shape (4, 1), but it has {result.shape}."
assert np.allclose(result, np.array([[-0.05], [0.05], [-0.125], [-0.025]])), f"With n = 4 the gradient should be (P - Y) / 4 = [-0.05, 0.05, -0.125, -0.025], but you returned {result.ravel()}."
--- hint
The gradient is the prediction minus the label, divided by the number of examples: `(P - Y) / n`.
--- hint
`n = P.shape[0]`, then `return (P - Y) / n`.
```

## Challenge: the hidden-layer gradient

```python exercise id=hidden-grad title="Pass the gradient through the hidden layer"
# TODO: `hidden_grad(dZ2, W2, A1)` returns dZ1 = (dZ2 @ W2ᵀ) * (1 - A1²), the gradient with respect
# to the hidden layer''s pre-activation. Here A1 = tanh(Z1), so 1 - A1² is the tanh derivative.
def hidden_grad(dZ2, W2, A1):
    ...
--- solution
def hidden_grad(dZ2, W2, A1):
    return (dZ2 @ W2.T) * (1 - A1 ** 2)
--- test
dZ2_t = np.array([[0.5], [-1.0]])
W2_t = np.array([[2.0], [0.0], [-1.0]])
A1_t = np.array([[0.0, 0.5, 1.0], [0.6, -0.8, 0.0]])
result = hidden_grad(dZ2_t, W2_t, A1_t)
assert result is not None, "Replace the `...` in `hidden_grad` with code that returns dZ1."
assert result.shape == (2, 3), f"dZ1 should have the shape of the hidden layer, (2, 3), but it has {result.shape}."
expected = (dZ2_t @ W2_t.T) * (1 - A1_t ** 2)
assert np.allclose(result, expected), f"Expected {expected}, but you returned {result}. Multiply by the tanh derivative 1 - A1²."
--- hint
First pass the gradient back through the weights: `dZ2 @ W2.T`. Then multiply elementwise by the tanh derivative, computed from `A1`.
--- hint
`return (dZ2 @ W2.T) * (1 - A1 ** 2)`. The `*` is elementwise, not a matrix product.
```

## Challenge: accuracy

```python exercise id=accuracy title="Classification accuracy"
# TODO: `accuracy(P, Y)` returns the fraction of examples whose predicted class is correct.
# Predict class 1 when P > 0.5. P and Y both have shape (n, 1).
def accuracy(P, Y):
    ...
--- solution
def accuracy(P, Y):
    return float(np.mean((P > 0.5) == Y))
--- test
P_t = np.array([[0.9], [0.4], [0.7], [0.1]])
Y_t = np.array([[1.0], [1.0], [0.0], [0.0]])
result = accuracy(P_t, Y_t)
assert result is not None, "Replace the `...` in `accuracy` with code that returns a fraction."
assert np.isclose(result, 0.5), f"Two of four predictions are correct, so the accuracy is 0.5, but you returned {result!r}."
assert np.isclose(accuracy(np.array([[0.6], [0.2]]), np.array([[1.0], [0.0]])), 1.0), "Both predictions are correct, so the accuracy should be 1.0."
--- hint
Compare the thresholded predictions `P > 0.5` with the labels, then take the mean of the comparison.
--- hint
`return float(np.mean((P > 0.5) == Y))`.
```

## Debug the sign of the gradient

```python debug id=output-sign title="Which way is downhill?"
P = np.array([[0.8], [0.2]])
Y = np.array([[1.0], [0.0]])
n = P.shape[0]
dZ2 = (Y - P) / n            # the gradient is for the loss, so which way is it?
print("dZ2:", dZ2.ravel())
--- solution
P = np.array([[0.8], [0.2]])
Y = np.array([[1.0], [0.0]])
n = P.shape[0]
dZ2 = (P - Y) / n
print("dZ2:", dZ2.ravel())
--- test
assert np.allclose(dZ2, np.array([[-0.1], [0.1]])), f"With P = [0.8, 0.2] and Y = [1, 0], dZ2 should be [-0.1, 0.1], but it is {dZ2.ravel()}. The gradient is prediction minus label."
--- hint
Compare the order of subtraction with the gradient formula `(P - Y) / n`. Which one matches a loss that is too high when P is too high?
--- hint
Subtract the label from the prediction: `(P - Y) / n`.
```

## Predict the first update

```python predict id=predict-first-step title="Which way does the weight move?"
dZ2 = np.array([[-0.1], [0.1]])
A1 = np.array([[0.5], [-0.5]])
dW2 = A1.T @ dZ2
print(dW2.round(2))
--- options
* [[-0.1]]
[[0.1]]
[[0.0]]
[[0.5]]
--- explain
The product is 0.5 × (-0.1) + (-0.5) × 0.1 = -0.05 - 0.05 = -0.1. The gradient is negative, so the update lr × dW2 subtracts a negative number and the weight increases. That is the correct direction for this example''s loss.
```

## Recap

- A multi-layer network learns a curved boundary that one neuron cannot draw.
- Training is the loop: forward pass, loss, backward pass, parameter update.
- With a sigmoid output and cross-entropy, the output gradient is simply $(P - Y)/n$.
- The hidden gradient is the output gradient passed back through the weights and multiplied by the activation''s derivative.

**Up next:** optimizers. Plain gradient descent is slow on badly scaled problems, and momentum and Adam fix that.
', 0, '[]', '[]', '2026-06-25T06:30:28.279Z', '2026-10-19T06:30:28.279Z'),
('les_deep_learning_foundations_3_2', 'sec_deep_learning_foundations_3', 'crs_deep_learning_foundations', 'Optimizers: momentum, RMSProp and Adam', 'interactive', 1, 1080, NULL, NULL, 'Gradient descent takes a step in the direction of the steepest slope. That sounds sensible, but on a badly scaled problem the steepest direction is not the direction towards the minimum. The result is a zigzag that crawls. **Optimizers** are update rules that fix this by remembering past gradients, and they are the reason modern networks train at all.

In this lesson you will watch plain gradient descent struggle, add momentum, and then implement Adam, the optimizer most deep-learning models use today.

## A valley that trips up plain gradient descent

The function below is steep in one direction and gentle in the other. Its gradient points mostly across the valley rather than along it.

```python run
import matplotlib.pyplot as plt

def f(w):
    return 0.5 * (10 * w[0] ** 2 + w[1] ** 2)

def grad_f(w):
    return np.array([10 * w[0], w[1]])

def run_sgd(w0, lr, steps):
    w = w0.copy()
    path = [w.copy()]
    for _ in range(steps):
        w = w - lr * grad_f(w)
        path.append(w.copy())
    return np.array(path)

path = run_sgd(np.array([1.0, 1.0]), lr=0.09, steps=60)
print("after 60 steps of plain gradient descent:", np.round(path[-1], 4))
print("loss:", round(f(path[-1]), 6))

xs, ys = np.meshgrid(np.linspace(-1.2, 1.2, 150), np.linspace(-1.2, 1.2, 150))
fig, ax = plt.subplots(figsize=(4.5, 4))
ax.contour(xs, ys, 0.5 * (10 * xs ** 2 + ys ** 2), levels=15, cmap="Greys")
ax.plot(path[:, 0], path[:, 1], "o-", ms=3, color="C1")
ax.set_aspect("equal"); plt.show()
```

The path bounces side to side before it creeps down the long axis. The step size is limited by the steep direction, so the gentle direction takes forever.

## Momentum: remember where you have been

**Momentum** keeps a running velocity $v$, a decaying sum of past gradients. Directions that keep agreeing build up speed, and directions that flip back and forth cancel out.

$$
v \leftarrow \beta v + \nabla L, \qquad w \leftarrow w - \eta\, v
$$

```python run
def run_momentum(w0, lr, beta, steps):
    w = w0.copy()
    v = np.zeros_like(w)
    path = [w.copy()]
    for _ in range(steps):
        v = beta * v + grad_f(w)
        w = w - lr * v
        path.append(w.copy())
    return np.array(path)

mpath = run_momentum(np.array([1.0, 1.0]), lr=0.05, beta=0.9, steps=60)
print("after 60 steps with momentum:", np.round(mpath[-1], 4))
print("loss:", round(f(mpath[-1]), 6))
```

With the same number of steps, momentum ends much closer to the minimum. It is the same idea as a ball rolling downhill and gathering speed.

## Adaptive step sizes: Adam

Adam combines momentum with a per-parameter step size. It tracks a running average of the gradient, $m$, and of its square, $v$, and divides the step by the typical gradient size. Parameters with large gradients take smaller steps, and parameters with small gradients take bigger ones.

Because $m$ and $v$ start at zero, they are biased towards zero early on. Adam corrects this with the factors $1/(1 - \beta_1^t)$ and $1/(1 - \beta_2^t)$:

$$
m \leftarrow \beta_1 m + (1 - \beta_1)\,g, \qquad v \leftarrow \beta_2 v + (1 - \beta_2)\,g^2
$$

$$
\hat m = \frac{m}{1 - \beta_1^t}, \qquad \hat v = \frac{v}{1 - \beta_2^t}, \qquad w \leftarrow w - \eta\,\frac{\hat m}{\sqrt{\hat v} + \epsilon}
$$

```python run
def run_adam(w0, lr, steps, b1=0.9, b2=0.999, eps=1e-8):
    w = w0.copy()
    m = np.zeros_like(w)
    v = np.zeros_like(w)
    for t in range(1, steps + 1):
        g = grad_f(w)
        m = b1 * m + (1 - b1) * g
        v = b2 * v + (1 - b2) * g ** 2
        m_hat = m / (1 - b1 ** t)
        v_hat = v / (1 - b2 ** t)
        w = w - lr * m_hat / (np.sqrt(v_hat) + eps)
    return w

aw = run_adam(np.array([1.0, 1.0]), lr=0.05, steps=60)
print("after 60 steps of Adam:", np.round(aw, 4))
print("loss:", round(f(aw), 6))
```

> **Under the hood:** the bias correction matters most in the first few steps, when $m$ and $v$ are still close to zero. Without it, Adam''s first steps are tiny and the optimizer warms up slowly.

## Compare them

```python run
print("plain SGD :", round(f(path[-1]), 6))
print("momentum  :", round(f(mpath[-1]), 6))
print("Adam      :", round(f(aw), 6))
```

No single optimizer wins on every problem. Adam is a strong default, and momentum with a well-chosen learning rate is still widely used, especially for image models.

## Challenge: a momentum step

```python exercise id=momentum-step title="One momentum step"
# TODO: `momentum_step(w, v, grad, lr, beta)` returns (w_new, v_new).
# First update the velocity: v_new = beta * v + grad. Then move: w_new = w - lr * v_new.
def momentum_step(w, v, grad, lr, beta):
    ...
--- solution
def momentum_step(w, v, grad, lr, beta):
    v_new = beta * v + grad
    return w - lr * v_new, v_new
--- test
w = np.array([1.0, 2.0])
v = np.array([0.5, 0.0])
g = np.array([1.0, -2.0])
result = momentum_step(w, v, g, 0.1, 0.9)
assert result is not None, "Replace the `...` in `momentum_step` with code that returns (w_new, v_new)."
w_new, v_new = result
assert np.allclose(v_new, [1.45, -2.0]), f"The new velocity should be 0.9 × [0.5, 0] + [1, -2] = [1.45, -2.0], but you returned {v_new}."
assert np.allclose(w_new, [0.855, 2.2]), f"The new position should be [0.855, 2.2], but you returned {w_new}. Move with the new velocity."
assert np.allclose(w, [1.0, 2.0]), "Do not change the input arrays in place."
--- hint
Compute the new velocity first, using the old velocity and the gradient. Then use the new velocity to move `w`.
--- hint
`v_new = beta * v + grad` and `return w - lr * v_new, v_new`.
```

## Challenge: an Adam step

```python exercise id=adam-step title="One Adam step with bias correction"
# TODO: `adam_step(w, m, v, g, t, lr, b1, b2, eps)` performs one Adam update at step t (starting from 1)
# and returns (w_new, m_new, v_new). Use the bias correction from the lesson.
def adam_step(w, m, v, g, t, lr, b1, b2, eps):
    ...
--- solution
def adam_step(w, m, v, g, t, lr, b1, b2, eps):
    m_new = b1 * m + (1 - b1) * g
    v_new = b2 * v + (1 - b2) * g ** 2
    m_hat = m_new / (1 - b1 ** t)
    v_hat = v_new / (1 - b2 ** t)
    return w - lr * m_hat / (np.sqrt(v_hat) + eps), m_new, v_new
--- test
w0 = np.array([1.0])
result = adam_step(w0, np.zeros(1), np.zeros(1), np.array([0.5]), 1, 0.1, 0.9, 0.999, 1e-8)
assert result is not None, "Replace the `...` in `adam_step` with code that returns (w_new, m_new, v_new)."
w_new, m_new, v_new = result
assert np.allclose(m_new, [0.05]), f"After one step m should be (1 - 0.9) × 0.5 = 0.05, but it is {m_new}."
assert np.allclose(v_new, [0.00025]), f"After one step v should be (1 - 0.999) × 0.5² = 0.00025, but it is {v_new}."
assert np.allclose(w_new, [0.9], atol=1e-6), f"The first Adam step with lr = 0.1 should move w to 0.9, but it moved to {w_new}. Check the bias correction."
w2, m2, v2 = adam_step(np.array([0.0]), np.array([0.0]), np.array([0.0]), np.array([-4.0]), 1, 0.01, 0.9, 0.999, 1e-8)
assert np.allclose(w2, [0.01], atol=1e-6), "The first Adam step moves each parameter by about lr, whatever the gradient''s size. Check the sign and the scale."
--- hint
Update `m` and `v` with the decay formulas first, then divide each by its bias correction, `1 - b1 ** t` and `1 - b2 ** t`.
--- hint
The step is `lr * m_hat / (sqrt(v_hat) + eps)`, and you subtract it from `w`.
```

## Debug the missing bias correction

```python debug id=adam-bias title="Correct the early steps"
def adam_update(w, m, v, g, t, lr=0.1, b1=0.9, b2=0.999, eps=1e-8):
    m = b1 * m + (1 - b1) * g
    v = b2 * v + (1 - b2) * g ** 2
    m_hat = m          # bias correction is missing here
    v_hat = v
    return w - lr * m_hat / (np.sqrt(v_hat) + eps), m, v

w, m, v = adam_update(np.array([1.0]), np.zeros(1), np.zeros(1), np.array([0.5]), t=1)
print("w after the first step:", np.round(w, 4), "(expected 0.9)")
--- solution
def adam_update(w, m, v, g, t, lr=0.1, b1=0.9, b2=0.999, eps=1e-8):
    m = b1 * m + (1 - b1) * g
    v = b2 * v + (1 - b2) * g ** 2
    m_hat = m / (1 - b1 ** t)
    v_hat = v / (1 - b2 ** t)
    return w - lr * m_hat / (np.sqrt(v_hat) + eps), m, v

w, m, v = adam_update(np.array([1.0]), np.zeros(1), np.zeros(1), np.array([0.5]), t=1)
print("w after the first step:", np.round(w, 4), "(expected 0.9)")
--- test
w_t, _, _ = adam_update(np.array([1.0]), np.zeros(1), np.zeros(1), np.array([0.5]), t=1)
assert np.allclose(w_t, [0.9], atol=1e-6), f"The first step should move w to 0.9, but it moved to {w_t}. Apply both bias corrections."
w_t2, _, _ = adam_update(np.array([0.0]), np.zeros(1), np.zeros(1), np.array([-2.0]), t=1)
assert np.allclose(w_t2, [0.1], atol=1e-6), f"With lr = 0.1 the first step on a gradient of -2 should move w to 0.1, but it moved to {w_t2}."
--- hint
Without correction, `m` is only 10% of the gradient after one step, which is why the step is too small.
--- hint
Divide `m` by `1 - b1 ** t` and `v` by `1 - b2 ** t` before using them.
```

## Predict the first Adam step

```python predict id=predict-adam title="How big is the first Adam step?"
import numpy as np
g = np.array([100.0])
m = 0.1 * g
v = 0.001 * g ** 2
step = 0.1 * (m / (1 - 0.9)) / (np.sqrt(v / (1 - 0.999)) + 1e-8)
print(np.round(step, 3))
--- options
* [0.1]
[10.0]
[0.001]
[100.0]
--- explain
Adam''s first step is about the learning rate, whatever the gradient''s size. The bias-corrected m equals g and the bias-corrected sqrt(v) equals |g|, so the ratio is about 1 and the step is lr × 1 = 0.1. This scale-invariance is why Adam is so forgiving of badly scaled gradients.
```

## Recap

- Plain gradient descent zigzags when curvature differs across directions, because one learning rate has to suit the steepest one.
- Momentum accumulates a decaying sum of gradients, so consistent directions speed up and oscillations cancel.
- Adam keeps running averages of the gradient and its square, and corrects both for their zero start.
- The first Adam step is roughly the learning rate in size, whatever the gradient''s scale.

**Up next:** regularization. A network that trains well can still memorize its training data, and you will learn how to stop it.
', 0, '[]', '[]', '2026-06-25T06:30:28.279Z', '2026-10-19T06:30:28.279Z'),
('les_deep_learning_foundations_3_3', 'sec_deep_learning_foundations_3', 'crs_deep_learning_foundations', 'Overfitting, dropout and weight decay', 'interactive', 2, 1080, NULL, NULL, 'A network with enough parameters can memorize its training set perfectly and still fail on new data. This is **overfitting**, and it is the central practical problem of machine learning. The tools against it are called **regularization**: anything that makes the model prefer simpler explanations. In this lesson you will see overfitting happen, then fix it with a penalty on the weights, with dropout and with early stopping.

## See overfitting happen

Here is a noisy sine wave. We fit polynomials of increasing degree to 12 training points, then measure the error on 30 fresh points the model never saw.

```python run
rng = np.random.default_rng(0)
x_train = np.sort(rng.uniform(0, 1, 12))
y_train = np.sin(2 * np.pi * x_train) + rng.normal(0, 0.2, 12)
x_val = np.linspace(0, 1, 30)
y_val = np.sin(2 * np.pi * x_val) + rng.normal(0, 0.2, 30)

for degree in [1, 3, 9]:
    coefs = np.polyfit(x_train, y_train, degree)
    train_mse = np.mean((np.polyval(coefs, x_train) - y_train) ** 2)
    val_mse = np.mean((np.polyval(coefs, x_val) - y_val) ** 2)
    print(f"degree {degree}: train {train_mse:.4f}   validation {val_mse:.4f}")
```

The degree-9 polynomial has nearly zero training error, but its validation error is much worse than the simpler models. It has memorized the noise. A large gap between training and validation error is the signature of overfitting.

> **Pitfall:** never judge a model by its training error. Hold out a validation set, and keep a separate test set for the final number.

## Penalize large weights: L2 regularization

One way to discourage memorization is to make large weights expensive. **L2 regularization** (also called weight decay) adds $\lambda \lVert w \rVert^2$ to the loss. Its gradient is $2\lambda w$, so every update also shrinks the weights towards zero.

For linear regression there is a closed-form solution, the **ridge regression** estimate:

$$
w = (X^{\top} X + \lambda I)^{-1} X^{\top} y
$$

```python run
def ridge_fit(X, y, lam):
    d = X.shape[1]
    return np.linalg.solve(X.T @ X + lam * np.eye(d), X.T @ y)

# Polynomial features of the same sine data, degree 9
def features(x, degree=9):
    return np.column_stack([x ** k for k in range(degree + 1)])

Xtr = features(x_train)
Xva = features(x_val)
for lam in [0.0, 1e-6, 1e-3]:
    w = ridge_fit(Xtr, y_train, lam)
    val_mse = np.mean((Xva @ w - y_val) ** 2)
    print(f"lambda {lam:<8} validation {val_mse:.4f}   largest |weight| {np.abs(w).max():.1f}")
```

Increasing $\lambda$ shrinks the largest weight and usually improves validation error. Too much and the model underfits, so $\lambda$ is a hyperparameter you tune on the validation set.

## Dropout: train an ensemble of thinned networks

**Dropout** randomly zeroes a fraction of the activations on each training step. The network cannot rely on any single unit, so it learns redundant, robust features.

The standard version is **inverted dropout**. Each kept activation is divided by the keep probability $p$ during training, so its expected value is unchanged. At test time nothing is dropped and nothing is rescaled.

```python run
A = np.ones((4, 6))
p_keep = 0.5
mask = rng.random(A.shape) < p_keep
A_dropped = A * mask / p_keep
print("mask:")
print(mask.astype(int))
print("expected value of each unit after dropout:", round(A_dropped.mean(), 3), "(about 1)")
```

Run the cell a few times. Each mask is different, but the average stays close to one. That is what the rescaling buys you.

## Early stopping: stop before the damage

Training loss falls forever, but validation loss usually bottoms out and then rises. **Early stopping** watches the validation loss and keeps the model from its best epoch, once it has stopped improving for a set number of epochs, the **patience**.

```python run
val_losses = [0.9, 0.6, 0.45, 0.38, 0.35, 0.34, 0.36, 0.39, 0.41, 0.44]
best = int(np.argmin(val_losses))
print("best epoch:", best, "with validation loss", val_losses[best])
print("epochs wasted after the best one:", len(val_losses) - 1 - best)
```

## Challenge: ridge regression

```python exercise id=ridge-fit title="Ridge regression in closed form"
# TODO: `ridge_fit(X, y, lam)` returns the weights w = (XᵀX + lam·I)⁻¹ Xᵀy as a 1-D array.
def ridge_fit(X, y, lam):
    ...
--- solution
def ridge_fit(X, y, lam):
    d = X.shape[1]
    return np.linalg.solve(X.T @ X + lam * np.eye(d), X.T @ y)
--- test
rng_t = np.random.default_rng(4)
X_t = rng_t.normal(size=(30, 3))
true_w = np.array([1.0, -2.0, 0.5])
y_t = X_t @ true_w + rng_t.normal(0, 0.01, 30)
w0 = ridge_fit(X_t, y_t, 0.0)
assert w0 is not None, "Replace the `...` in `ridge_fit` with code that returns the weights."
assert np.shape(w0) == (3,), f"The weights should have shape (3,), but they have {np.shape(w0)}."
assert np.allclose(w0, true_w, atol=0.05), f"With lam = 0 the fit should recover about [1, -2, 0.5], but you returned {w0}."
w_big = ridge_fit(X_t, y_t, 1000.0)
assert np.linalg.norm(w_big) < np.linalg.norm(w0) / 10, "A large lam should shrink the weights strongly towards zero."
--- hint
Build the matrix `X.T @ X + lam * np.eye(d)`, then solve the linear system against `X.T @ y`. `np.linalg.solve` is more accurate than computing an inverse.
--- hint
`return np.linalg.solve(X.T @ X + lam * np.eye(X.shape[1]), X.T @ y)`.
```

## Challenge: inverted dropout

```python exercise id=inverted-dropout title="Inverted dropout"
# TODO: `inverted_dropout(A, p_keep, rng)` randomly keeps each entry of A with probability p_keep,
# zeroes the rest, and divides the kept entries by p_keep. Use `rng.random(A.shape) < p_keep` for the mask.
def inverted_dropout(A, p_keep, rng):
    ...
--- solution
def inverted_dropout(A, p_keep, rng):
    mask = rng.random(A.shape) < p_keep
    return A * mask / p_keep
--- test
A_t = np.full((400, 50), 2.0)
out = inverted_dropout(A_t, 0.5, np.random.default_rng(0))
assert out is not None, "Replace the `...` in `inverted_dropout` with code that returns the dropped activations."
assert out.shape == A_t.shape, "The output should have the same shape as the input."
assert np.all((out == 0) | np.isclose(out, 4.0)), "Kept entries should be A / p_keep = 4.0, and dropped entries should be 0."
assert abs(out.mean() - 2.0) < 0.05, f"The mean should stay near 2.0 after dropout, but it is {out.mean():.3f}. Divide the kept values by p_keep."
same = inverted_dropout(A_t, 1.0, np.random.default_rng(1))
assert np.allclose(same, A_t), "With p_keep = 1.0 nothing should be dropped, and the output should equal the input."
--- hint
Build a boolean mask with `rng.random(A.shape) < p_keep`, multiply `A` by it, then divide by `p_keep`.
--- hint
`mask = rng.random(A.shape) < p_keep` and `return A * mask / p_keep`.
```

## Challenge: when to stop

```python exercise id=stop-epoch title="Early stopping"
# TODO: `stop_epoch(val_losses, patience)` returns the epoch index of the best (lowest) validation loss
# seen before training stops. Training stops once the loss has failed to improve for `patience` epochs in a row.
def stop_epoch(val_losses, patience):
    ...
--- solution
def stop_epoch(val_losses, patience):
    best, best_epoch = float("inf"), 0
    for epoch, loss in enumerate(val_losses):
        if loss < best:
            best, best_epoch = loss, epoch
        elif epoch - best_epoch >= patience:
            return best_epoch
    return best_epoch
--- test
assert stop_epoch([5.0, 4.0, 3.0, 3.5, 3.6, 3.7, 3.8], 2) is not None, "Replace the `...` in `stop_epoch` with code that returns an epoch index."
assert stop_epoch([5.0, 4.0, 3.0, 3.5, 3.6, 3.7, 3.8], 2) == 2, "The best loss is at epoch 2. Training stops at epoch 4, after two epochs without improvement, so the answer is 2."
assert stop_epoch([1.0, 2.0, 3.0], 5) == 0, "If the loss never improves, the best epoch is the first one."
assert stop_epoch([3.0, 2.0, 2.5, 1.0, 1.5, 1.2, 1.1, 1.3], 3) == 3, "Here the loss keeps finding new lows until epoch 3, which is the answer."
--- hint
Track the best loss and its epoch as you go. Each epoch that does not improve on the best adds one to the count since the best.
--- hint
When `epoch - best_epoch` reaches `patience`, return `best_epoch` straight away.
```

## Debug the missing rescale

```python debug id=dropout-scale title="Keep the expected activation"
rng_d = np.random.default_rng(0)
A = np.ones(1000)
p_keep = 0.8
mask = rng_d.random(A.shape) < p_keep
out = A * mask          # the kept units are not rescaled
print("mean after dropout:", round(out.mean(), 3), "(should be about 1)")
--- solution
rng_d = np.random.default_rng(0)
A = np.ones(1000)
p_keep = 0.8
mask = rng_d.random(A.shape) < p_keep
out = A * mask / p_keep
print("mean after dropout:", round(out.mean(), 3), "(should be about 1)")
--- test
assert abs(out.mean() - 1.0) < 0.05, f"With keep probability 0.8 the mean after dropout should be about 1, but it is {out.mean():.3f}. Divide the kept units by p_keep."
--- hint
Dropout removes 20% of the units, so the total signal is 20% smaller. Restoring the expected value means scaling the survivors up.
--- hint
`out = A * mask / p_keep`.
```

## Predict the penalty

```python predict id=predict-l2 title="What is the L2 penalty?"
w = np.array([3.0, 4.0])
lam = 0.1
print(lam * np.sum(w ** 2))
--- options
* 2.5
0.5
5.0
25.0
--- explain
The squared norm is 3² + 4² = 25, and the penalty is λ times that: 0.1 × 25 = 2.5. The penalty grows with the square of every weight, so a few very large weights cost far more than many small ones.
```

## Recap

- Overfitting means the model has learned the noise. Compare training and validation error to spot it.
- L2 regularization penalizes large weights, and its gradient shrinks every weight a little on each update.
- Inverted dropout zeroes random units during training and rescales the rest, so the expected activation is unchanged.
- Early stopping keeps the model from the epoch with the best validation loss, and ignores the epochs after it.

**Up next:** initialization and normalization. How you set the starting weights decides whether the signal survives a deep network at all.
', 0, '[]', '[]', '2026-06-25T06:30:28.279Z', '2026-10-19T06:30:28.279Z'),
('les_deep_learning_foundations_3_4', 'sec_deep_learning_foundations_3', 'crs_deep_learning_foundations', 'Initialization and normalization', 'interactive', 3, 960, NULL, NULL, 'Before a network learns anything, you have to choose its starting weights, and that choice matters more than most people expect. Weights that are too small make the signal vanish as it passes through the layers. Weights that are too large make it explode. Both stall training. In this lesson you will see the problem in action, learn the initialization schemes that fix it, and implement **batch normalization**, which keeps activations well-behaved during training.

## The signal shrinks, or grows

Pass random data through ten layers of random weights and watch the spread of the activations. Each layer multiplies the signal by its weights, and the tanh squashes it further.

```python run
rng = np.random.default_rng(0)
x = rng.normal(size=(200, 128))

def spread_through_layers(x, scale, depth=10):
    out = [x.std()]
    h = x
    for _ in range(depth):
        W = rng.normal(0, scale, size=(128, 128))
        h = np.tanh(h @ W)
        out.append(h.std())
    return np.array(out)

small = spread_through_layers(x, scale=0.01)
large = spread_through_layers(x, scale=0.5)
print("small weights, std per layer:", np.round(small, 4))
print("large weights, std per layer:", np.round(large, 4))
```

With weights that are too small, the activations collapse towards zero within a few layers, and there is nothing left to learn from. With weights that are too large, `tanh` saturates and its derivative vanishes. Neither can train deep networks.

## Scale the weights to the layer width

The right scale depends on how many inputs each unit sums over, its **fan-in**. Two schemes keep the spread roughly constant from layer to layer:

- **Xavier (Glorot)** initialization, for tanh and sigmoid units: standard deviation $\sqrt{1 / n_{\text{in}}}$.
- **He** initialization, for ReLU units: standard deviation $\sqrt{2 / n_{\text{in}}}$. The factor of 2 compensates for ReLU zeroing half of its inputs.

```python run
def relu(z):
    return np.maximum(0, z)

def spread_relu(scale_fn, depth=10):
    h = rng.normal(size=(200, 128))
    out = [h.std()]
    for _ in range(depth):
        W = rng.normal(0, scale_fn(128), size=(128, 128))
        h = relu(h @ W)
        out.append(h.std())
    return np.array(out)

naive = spread_relu(lambda fan_in: 0.05)
he = spread_relu(lambda fan_in: np.sqrt(2 / fan_in))
print("fixed small scale, std per layer:", np.round(naive, 3))
print("He initialization, std per layer:", np.round(he, 3))
```

He initialization keeps the signal alive through ten ReLU layers. The fixed scale still loses strength layer by layer.

The same idea works for tanh. Xavier''s scale keeps the signal steady through ten tanh layers, where the earlier scale of 0.5 saturated.

```python run
xavier = spread_through_layers(x, scale=np.sqrt(1 / 128))
print("Xavier for tanh, std per layer:", np.round(xavier, 3))
```

> **In the wild:** PyTorch''s `nn.Linear` and `nn.Conv2d` use variants of these rules by default, and `torch.nn.init` exposes them directly. Knowing the reason lets you pick the right one.

## Batch normalization

Even with good initialization, the distribution of each layer''s inputs drifts as the earlier layers change. **Batch normalization** fixes this by normalizing every feature over the batch to mean 0 and variance 1, then letting the network learn a scale $\gamma$ and shift $\beta$:

$$
\hat x = \frac{x - \mu_B}{\sqrt{\sigma_B^2 + \epsilon}}, \qquad y = \gamma \hat x + \beta
$$

Here $\mu_B$ and $\sigma_B^2$ are the mean and variance of each feature over the batch, so the statistics are taken along the batch axis, axis 0.

```python run
X = rng.normal(loc=5.0, scale=3.0, size=(64, 4))   # badly scaled features
mu = X.mean(axis=0)
var = X.var(axis=0)
X_hat = (X - mu) / np.sqrt(var + 1e-5)

print("before: mean", np.round(X.mean(axis=0), 2), "std", np.round(X.std(axis=0), 2))
print("after:  mean", np.round(X_hat.mean(axis=0), 2), "std", np.round(X_hat.std(axis=0), 2))
```

The features now have mean zero and standard deviation one, whatever their starting scale.

> **Pitfall:** batch normalization uses batch statistics during training and running averages at test time. Forgetting to switch to the running averages with `model.eval()` is a classic source of bad test accuracy, and you will meet it again in PyTorch.

## Challenge: He initialization

```python exercise id=he-init title="He initialization"
# TODO: `he_init(fan_in, fan_out, rng)` returns a weight matrix of shape (fan_in, fan_out) drawn from a
# normal distribution with mean 0 and standard deviation sqrt(2 / fan_in).
def he_init(fan_in, fan_out, rng):
    ...
--- solution
def he_init(fan_in, fan_out, rng):
    return rng.normal(0, np.sqrt(2 / fan_in), size=(fan_in, fan_out))
--- test
rng_t = np.random.default_rng(0)
W = he_init(400, 300, rng_t)
assert W is not None, "Replace the `...` in `he_init` with code that returns the weight matrix."
assert W.shape == (400, 300), f"The weights should have shape (400, 300), but they have {W.shape}."
target = np.sqrt(2 / 400)
assert abs(W.std() - target) / target < 0.05, f"The standard deviation should be about sqrt(2 / 400) = {target:.4f}, but it is {W.std():.4f}."
assert abs(W.mean()) < 0.005, "The mean of the weights should be close to zero."
--- hint
Use `rng.normal(loc, scale, size)`. The scale is the standard deviation, so it should be `np.sqrt(2 / fan_in)`.
--- hint
`return rng.normal(0, np.sqrt(2 / fan_in), size=(fan_in, fan_out))`.
```

## Challenge: batch normalization in the forward pass

```python exercise id=batchnorm-forward title="Batch normalization"
# TODO: `batchnorm_forward(X, gamma, beta, eps=1e-5)` normalizes each feature of X over the batch
# (axis 0), then applies the scale gamma and shift beta. X has shape (n, features).
def batchnorm_forward(X, gamma, beta, eps=1e-5):
    ...
--- solution
def batchnorm_forward(X, gamma, beta, eps=1e-5):
    mu = X.mean(axis=0)
    var = X.var(axis=0)
    X_hat = (X - mu) / np.sqrt(var + eps)
    return gamma * X_hat + beta
--- test
rng_t = np.random.default_rng(3)
X_t = rng_t.normal(loc=10.0, scale=4.0, size=(100, 3))
out = batchnorm_forward(X_t, np.ones(3), np.zeros(3))
assert out is not None, "Replace the `...` in `batchnorm_forward` with code that returns the normalized output."
assert out.shape == X_t.shape, "The output should have the same shape as the input."
assert np.allclose(out.mean(axis=0), 0.0, atol=1e-6), "With gamma = 1 and beta = 0 each feature should have mean 0 over the batch. Normalize along axis 0."
assert np.allclose(out.std(axis=0), 1.0, atol=1e-3), "Each feature should have standard deviation 1 over the batch."
out2 = batchnorm_forward(X_t, np.full(3, 2.0), np.full(3, 1.0))
assert np.allclose(out2.mean(axis=0), 1.0, atol=1e-6) and np.allclose(out2.std(axis=0), 2.0, atol=1e-3), "gamma scales the standard deviation and beta shifts the mean."
--- hint
Compute the mean and variance of each column with `axis=0`, then standardize. Divide by `np.sqrt(var + eps)`, not by `var`.
--- hint
`X_hat = (X - mu) / np.sqrt(var + eps)`, then `return gamma * X_hat + beta`.
```

## Debug the normalization axis

```python debug id=batchnorm-axis title="Normalize across the batch"
rng_d = np.random.default_rng(5)
X = rng_d.normal(loc=3.0, scale=2.0, size=(32, 4))     # 32 examples, 4 features
mu = X.mean(axis=1, keepdims=True)                     # the statistics are per feature
var = X.var(axis=1, keepdims=True)
X_hat = (X - mu) / np.sqrt(var + 1e-5)
print("feature means:", np.round(X_hat.mean(axis=0), 3))
--- solution
rng_d = np.random.default_rng(5)
X = rng_d.normal(loc=3.0, scale=2.0, size=(32, 4))     # 32 examples, 4 features
mu = X.mean(axis=0, keepdims=True)                     # the statistics are per feature
var = X.var(axis=0, keepdims=True)
X_hat = (X - mu) / np.sqrt(var + 1e-5)
print("feature means:", np.round(X_hat.mean(axis=0), 3))
--- test
assert np.allclose(X_hat.mean(axis=0), 0.0, atol=1e-6), f"Each feature should have mean 0 over the batch, but the feature means are {np.round(X_hat.mean(axis=0), 3)}. Compute the statistics over axis 0."
assert X_hat.shape == (32, 4), "X_hat should keep the shape of X."
--- hint
Look at the axis you average over. Batch normalization averages over the examples, which are the rows, so that is axis 0.
--- hint
Change `axis=1` to `axis=0` in both the mean and the variance.
```

## Predict the statistic''s shape

```python predict id=predict-batch-axis title="What shape are the batch means?"
X = np.ones((32, 5))
print(X.mean(axis=0).shape)
--- options
* (5,)
(32,)
(32, 5)
()
--- explain
Averaging over axis 0 removes the 32 examples and leaves one mean per feature, a vector of length 5. That is why batch normalization has one γ and one β for each feature.
```

## Recap

- Weights that are too small or too large make activations vanish or explode through depth.
- Xavier initialization suits tanh and sigmoid. He initialization, with variance $2/n_{\text{in}}$, suits ReLU.
- Batch normalization standardizes each feature over the batch, then applies a learned scale and shift.
- Batch statistics come from axis 0 (the examples). Use running statistics at test time.

**Up next:** the same training ideas in PyTorch. You will see how the framework packages everything you have built.
', 0, '[]', '[]', '2026-06-25T06:30:28.279Z', '2026-10-19T06:30:28.279Z'),
('les_deep_learning_foundations_3_5', 'sec_deep_learning_foundations_3', 'crs_deep_learning_foundations', 'Checkpoint: training networks', 'quiz', 4, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"A model reaches 99% training accuracy but 70% validation accuracy. What is the most likely diagnosis?","options":["Underfitting","Overfitting","A learning rate that is too small","A corrupted optimizer"],"answerIndex":1,"explanation":"A large gap between training and validation performance is the classic sign that the model has memorized the training data."},{"id":"q2","prompt":"Momentum accelerates gradient descent. What does it accumulate?","options":["The exact loss values","An exponentially weighted average of past gradients","The number of training steps","The validation set"],"answerIndex":1,"explanation":"The velocity v is a running average of recent gradients. Directions that keep agreeing build up speed, and oscillating directions cancel out."},{"id":"q3","prompt":"Inverted dropout with keep probability p scales the surviving activations by 1/p during training. Why?","options":["To make training faster","So the expected value of each activation is the same with and without dropout","To make the weights larger","Because dropout removes the bias"],"answerIndex":1,"explanation":"Dropout zeroes some activations, which lowers their average. Dividing the survivors by p keeps the expected activation unchanged, so no rescaling is needed at test time."},{"id":"q4","prompt":"Why do we initialize weights randomly instead of with zeros?","options":["Zeros make the forward pass fail","Identical weights receive identical gradients, so the neurons in a layer never differentiate","Random weights train faster on every problem","Zeros are not allowed in NumPy"],"answerIndex":1,"explanation":"If every weight in a layer starts the same, every neuron computes the same thing and gets the same update forever. Random initialization breaks that symmetry."},{"id":"q5","prompt":"A layer has fan_in = 256 inputs. Roughly what standard deviation does He initialization use for its weights?","options":["1.0","sqrt(2 / 256)","256","0.01 exactly"],"answerIndex":1,"explanation":"He initialization uses a standard deviation of sqrt(2 / fan_in), which keeps the variance of ReLU activations roughly stable from layer to layer."},{"id":"q6","prompt":"Early stopping means…","options":["Stopping the GPU when it overheats","Ending training when the validation loss stops improving","Stopping after exactly one epoch","Reducing the learning rate to zero"],"answerIndex":1,"explanation":"Training loss keeps falling as the model memorizes. Validation loss usually bottoms out first, and stopping there keeps the model that generalizes best."}]', '[]', '2026-06-25T06:30:28.279Z', '2026-10-19T06:30:28.279Z'),
('les_deep_learning_foundations_4_1', 'sec_deep_learning_foundations_4', 'crs_deep_learning_foundations', 'Tensors and autograd in PyTorch', 'interactive', 0, 960, NULL, NULL, 'Everything you built by hand in the last section now has a professional home. **PyTorch** is the framework most research and production deep learning is written in, and its core is two ideas you already know: a **tensor**, which is an array that can live on a GPU, and **autograd**, which is the autograd engine from lesson 8 running at industrial scale.

In this lesson you will learn the PyTorch versions of the operations you wrote in NumPy, how `requires_grad` and `backward()` replace your hand-written gradients, and why gradients must be cleared between steps. The PyTorch code below is for you to run on your own machine, because the browser runtime does not include PyTorch. Every idea also has a runnable NumPy cell, so you can check the behavior right here.

> **Running the PyTorch code:** `pip install torch` gives you everything in this lesson. The code is static here, so it will not run in the page.

## Tensors are NumPy arrays with extras

A PyTorch tensor has a shape, a data type and, optionally, a device such as a GPU. The operations look almost the same.

| NumPy | PyTorch | Meaning |
|---|---|---|
| `np.array(...)` | `torch.tensor(...)` | create an array from data |
| `x.shape` | `x.shape` | the size of each dimension |
| `x @ w` | `x @ w` | matrix product |
| `x.T` | `x.T` | transpose |
| `x.reshape(...)` | `x.reshape(...)` or `x.view(...)` | change the shape |
| `np.maximum(0, x)` | `torch.clamp(x, min=0)` or `torch.relu(x)` | ReLU |
| `x.sum(axis=0)` | `x.sum(dim=0)` | sum over a dimension |
| `x.astype(float)` | `x.float()` | change the data type |

The biggest practical difference is the default precision. NumPy uses 64-bit floats. PyTorch uses 32-bit floats by default, which is faster and uses less memory, and which is usually enough for training.

```python
import torch

x = torch.tensor([[1.0, 2.0], [3.0, 4.0]])   # float32 by default
print(x.dtype, x.shape)                       # torch.float32 torch.Size([2, 2])

w = torch.ones(2, 1)
print((x @ w).shape)                          # torch.Size([2, 1])
```

The table is easy to check with arrays you can run here:

```python run
x64 = np.array([[1.0, 2.0], [3.0, 4.0]])
x32 = x64.astype(np.float32)
print("dtypes:", x64.dtype, x32.dtype)
print("reshape to (4,):", x64.reshape(4))
print("transpose, flattened:", x64.T.ravel())
```

```python run
# A batch of 2 greyscale images, each 3 × 3 pixels
images = np.arange(2 * 3 * 3, dtype=float).reshape(2, 3, 3)
flat = images.reshape(images.shape[0], -1)     # one row per image, as a dense layer expects
print("images:", images.shape, "-> flat:", flat.shape)
```

```python run
# Broadcasting in a batch: one bias added to every row
bias = np.array([10.0, 20.0])
print(x64 + bias)
```

## Autograd: `requires_grad` and `backward()`

Set `requires_grad=True` on the tensors you want gradients for. PyTorch then records every operation on them, just like your `Value` class, and `backward()` fills in each tensor''s `.grad`.

```python
import torch

x = torch.tensor([[1.0, 2.0], [3.0, 4.0]])
w = torch.ones(2, 1, requires_grad=True)

y = (x @ w).sum()          # a scalar
y.backward()               # compute dy/dw by walking the recorded graph

print(w.grad)              # tensor([[4.], [6.]]), the column sums of x
```

The NumPy version of the same calculation is one line. Here is the check, runnable in the page:

```python run
x = np.array([[1.0, 2.0], [3.0, 4.0]])
w = np.ones((2, 1))

y = (x @ w).sum()
grad_w = x.sum(axis=0).reshape(2, 1)   # the gradient of y with respect to w
print("y =", y)
print("dy/dw =", grad_w.ravel())
```

Each entry of `w` multiplies one column of `x`, and every row contributes to the sum, so its gradient is the sum of that column. Autograd finds the same answer without you deriving it.

## Stop recording when you do not need gradients

Recording the graph costs time and memory. Two tools turn it off when you do not need it:

- `torch.no_grad()` is a context manager that disables recording inside a block. Use it for evaluation and predictions.
- `x.detach()` returns a tensor that shares the data but is cut out of the graph.

```python
with torch.no_grad():
    predictions = model(X_val)     # no graph is built, so this is faster and lighter
```

> **Pitfall:** a tensor that you do not want to update still needs `requires_grad=False`, which is the default for data. Accidentally tracking gradients through your inputs or labels wastes memory and can confuse debugging.

## Gradients accumulate

Calling `backward()` adds into `.grad` rather than replacing it. This is the accumulation rule from lesson 8, and it is why every training loop clears the gradients before the backward pass.

```python run
# Two batches, one shared weight vector: gradients from both add up, as in PyTorch.
X1 = np.array([[1.0, 0.0], [0.0, 1.0]])
X2 = np.array([[2.0, 1.0]])
y1 = np.array([1.0, 2.0])
y2 = np.array([3.0])
w = np.array([0.5, -0.5])

def grad_sum_loss(X, y, w):
    # gradient of the sum of squared errors, 2 Xᵀ(Xw - y), with no averaging
    return 2 * X.T @ (X @ w - y)

g_total = grad_sum_loss(X1, y1, w) + grad_sum_loss(X2, y2, w)
print("accumulated gradient:", g_total)
```

If you forgot to clear the gradients, the second batch would be added on top of the first one from the previous step. The model would move in the direction of old data. Lesson 15 shows the loop that avoids this.

## Challenge: accumulate gradients correctly

Gradient accumulation is also how you train with batches too large for memory. Each batch contributes a sum, and the total must be divided by the total number of examples to get the mean gradient, not by the number of batches.

```python exercise id=accumulated-grad title="Accumulate a gradient across batches"
# TODO: `accumulated_grad(batches, w)` takes a list of (X_b, y_b) pairs, which can have different
# sizes. Compute the gradient of the mean squared error over ALL the examples together.
# For one batch, the sum of squared errors has gradient 2 * X_bᵀ (X_b w - y_b).
def accumulated_grad(batches, w):
    ...
--- solution
def accumulated_grad(batches, w):
    total = np.zeros_like(w)
    n = 0
    for X_b, y_b in batches:
        total = total + 2 * X_b.T @ (X_b @ w - y_b)
        n += len(y_b)
    return total / n
--- test
rng_t = np.random.default_rng(0)
X_all = rng_t.normal(size=(10, 3))
y_all = rng_t.normal(size=10)
w_t = np.array([0.2, -0.4, 0.1])
full = 2 * X_all.T @ (X_all @ w_t - y_all) / len(y_all)
batches = [(X_all[:4], y_all[:4]), (X_all[4:7], y_all[4:7]), (X_all[7:], y_all[7:])]
result = accumulated_grad(batches, w_t)
assert result is not None, "Replace the `...` in `accumulated_grad` with code that returns the mean gradient."
assert np.shape(result) == (3,), f"The gradient should have the shape of w, (3,), but it has {np.shape(result)}."
assert np.allclose(result, full), f"Accumulating over batches of different sizes should match the full-batch mean gradient. Expected {full}, got {result}. Divide by the total number of examples, not the number of batches."
--- hint
Start with a zero gradient the size of `w`. For each batch add `2 * X_bᵀ (X_b w - y_b)`, and count the examples as you go.
--- hint
Divide the accumulated sum by the total count of examples at the end, `total / n`.
```

## Challenge: flatten a batch of images

Convolutional networks keep images as 2-D grids, but a plain dense layer needs one row of features per example. Converting between the two is a shape operation you will do constantly.

```python exercise id=flatten-batch title="Flatten a batch of images"
# TODO: `flatten_batch(images)` takes an array of shape (n, height, width) and returns an array of
# shape (n, height * width), one row of pixels per image. Do not change the values.
def flatten_batch(images):
    ...
--- solution
def flatten_batch(images):
    return images.reshape(images.shape[0], -1)
--- test
imgs = np.arange(2 * 4 * 5, dtype=float).reshape(2, 4, 5)
result = flatten_batch(imgs)
assert result is not None, "Replace the `...` in `flatten_batch` with code that returns the flattened batch."
assert result.shape == (2, 20), f"Two 4 × 5 images should flatten to shape (2, 20), but you returned {result.shape}."
assert np.array_equal(result[1], imgs[1].ravel()), "Each row should hold the pixels of one image, in order."
assert flatten_batch(np.zeros((7, 3, 3))).shape == (7, 9), "Check that it works for any batch size and image size."
--- hint
Keep the first dimension (the batch) and merge the other two. NumPy''s `-1` means "whatever size is left".
--- hint
`return images.reshape(images.shape[0], -1)`.
```

## Predict the gradient

```python predict id=predict-accumulate title="What does the accumulated gradient equal?"
import numpy as np
g1 = np.array([1.0, 2.0])
g2 = np.array([1.0, 2.0])
print(g1 + g2)
--- options
* [2. 4.]
[1. 2.]
[0. 0.]
[1. 4.]
--- explain
PyTorch adds each backward pass into .grad, and NumPy''s addition does the same here. Two identical gradients of [1, 2] give [2, 4]. If you forget to clear the gradient between training steps, this doubling happens on every step.
```

## Debug the chain rule

```python debug id=inner-derivative title="Include the inner derivative"
import numpy as np
# The loss depends on w through h = x · w, so backprop must multiply by dh/dw as well.
w = np.array([2.0])
x = np.array([3.0])
h = x * w
loss = h ** 2
grad_w = 2 * h          # the gradient of the loss with respect to h, but not yet w
print("gradient seen by the optimizer:", grad_w)
--- solution
import numpy as np
w = np.array([2.0])
x = np.array([3.0])
h = x * w
loss = h ** 2
grad_w = 2 * h * x      # outer derivative 2h, times the inner derivative dh/dw = x
print("gradient seen by the optimizer:", grad_w)
--- test
assert np.allclose(grad_w, [36.0]), f"loss = (x w)² with x = 3 and w = 2 has gradient 2 · (x w) · x = 36, but the optimizer sees {grad_w}. Multiply by the inner derivative dh/dw = x."
--- hint
The chain rule has two factors here: the outer derivative of the square, which is `2h`, and the inner derivative of `h` with respect to `w`, which is `x`.
--- hint
`grad_w = 2 * h * x`.
```

## Recap

- A PyTorch tensor behaves like a NumPy array, with float32 by default and optional GPU placement.
- `requires_grad=True` records a graph, and `loss.backward()` fills `.grad` for every tensor that needs one.
- Gradients accumulate, so clear them before every backward pass.
- Use `torch.no_grad()` for evaluation, and when you only need values, not gradients.

**Up next:** the training loop in PyTorch, with models, data loaders and optimizers, and a NumPy version that runs here.
', 0, '[]', '[]', '2026-06-25T06:30:28.279Z', '2026-10-19T06:30:28.279Z'),
('les_deep_learning_foundations_4_2', 'sec_deep_learning_foundations_4', 'crs_deep_learning_foundations', 'The PyTorch training loop', 'interactive', 1, 1080, NULL, NULL, 'Every training run you have written has the same four steps: forward pass, loss, backward pass and update. PyTorch gives each step a standard home. A **module** holds the parameters, a **data loader** serves shuffled mini-batches, an **optimizer** applies the update rule from lesson 11, and a loop ties them together. Learning this shape once means you can read almost any PyTorch project.

The PyTorch code here is for you to run on your own machine. The NumPy versions below run in the page and follow the same structure, so you can see that nothing in the framework is doing something you could not do yourself.

## The PyTorch training loop

This is the standard shape, with a model, a loss, an optimizer and a loader:

```python
import torch
from torch import nn
from torch.utils.data import DataLoader, TensorDataset

model = nn.Sequential(
    nn.Linear(2, 16),
    nn.Tanh(),
    nn.Dropout(0.1),
    nn.Linear(16, 1),
)
loss_fn = nn.BCEWithLogitsLoss()     # sigmoid and cross-entropy in one stable step
optimizer = torch.optim.Adam(model.parameters(), lr=1e-2)

train_loader = DataLoader(TensorDataset(X_train, y_train), batch_size=32, shuffle=True)

for epoch in range(20):
    model.train()                    # enable dropout and batch-norm training behaviour
    for xb, yb in train_loader:
        optimizer.zero_grad()        # clear the gradients from the last step
        logits = model(xb)           # forward pass
        loss = loss_fn(logits, yb)   # loss
        loss.backward()              # backward pass
        optimizer.step()             # update the parameters

    model.eval()                     # turn dropout off for evaluation
    with torch.no_grad():            # no gradients needed for evaluation
        val_logits = model(X_val)
        val_loss = loss_fn(val_logits, y_val)
    print(epoch, round(val_loss.item(), 4))
```

Map every line to something you wrote. `optimizer.zero_grad()` is the accumulation fix from lesson 14. `loss.backward()` is lesson 9. `optimizer.step()` is the update rule from lesson 11. `model.train()` and `model.eval()` switch dropout, which you built in lesson 12, between its two behaviours.

> **Pitfall:** the order is `zero_grad`, then `backward`, then `step`. Calling `step` before `backward` updates with the previous batch''s gradients, and calling `backward` without `zero_grad` adds the new gradients to the old ones. Both bugs train without an error and silently make learning worse.

## The NumPy version, runnable here

Here is the same loop in NumPy, with mini-batches shuffled every epoch, dropout that runs only in training mode, and a separate evaluation pass.

```python run
import matplotlib.pyplot as plt

def make_moons(n=300, noise=0.2, seed=0):
    rng = np.random.default_rng(seed)
    t = np.linspace(0, np.pi, n // 2)
    upper = np.column_stack([np.cos(t), np.sin(t)])
    lower = np.column_stack([1 - np.cos(t), 0.5 - np.sin(t)])
    X = np.vstack([upper, lower]) + rng.normal(0, noise, size=(n, 2))
    y = np.concatenate([np.zeros(n // 2), np.ones(n // 2)])
    return X, y.reshape(-1, 1)

X_all, y_all = make_moons()
X_train, y_train = X_all[:240], y_all[:240]
X_val, y_val = X_all[240:], y_all[240:]

def forward(X, p, rng=None, training=False, drop=0.1):
    A1 = np.tanh(X @ p["W1"] + p["b1"])
    if training:                                   # dropout only during training
        mask = rng.random(A1.shape) < (1 - drop)
        A1 = A1 * mask / (1 - drop)
    P = 1 / (1 + np.exp(-(A1 @ p["W2"] + p["b2"])))
    return A1, P

def backward(X, Y, p, A1, P):
    n = X.shape[0]
    dZ2 = (P - Y) / n
    dZ1 = (dZ2 @ p["W2"].T) * (1 - A1 ** 2)
    return {"W1": X.T @ dZ1, "b1": dZ1.sum(0), "W2": A1.T @ dZ2, "b2": dZ2.sum(0)}

rng = np.random.default_rng(0)
params = {"W1": rng.normal(0, 0.5, (2, 16)), "b1": np.zeros(16),
          "W2": rng.normal(0, 0.5, (16, 1)), "b2": np.zeros(1)}
m = {k: np.zeros_like(v) for k, v in params.items()}
v = {k: np.zeros_like(p) for k, p in params.items()}
lr, b1, b2, eps = 0.01, 0.9, 0.999, 1e-8
step = 0

for epoch in range(20):
    order = rng.permutation(len(X_train))
    for start in range(0, len(order), 32):
        idx = order[start:start + 32]
        step += 1
        A1, P = forward(X_train[idx], params, rng, training=True)
        grads = backward(X_train[idx], y_train[idx], params, A1, P)
        for k in params:                           # Adam update, as in lesson 11
            m[k] = b1 * m[k] + (1 - b1) * grads[k]
            v[k] = b2 * v[k] + (1 - b2) * grads[k] ** 2
            m_hat = m[k] / (1 - b1 ** step)
            v_hat = v[k] / (1 - b2 ** step)
            params[k] = params[k] - lr * m_hat / (np.sqrt(v_hat) + eps)

_, P_val = forward(X_val, params, training=False)   # evaluation: no dropout
val_acc = np.mean((P_val > 0.5) == y_val)
print("validation accuracy:", round(float(val_acc), 3))
```

Read the evaluation line twice. `training=False` is the NumPy version of `model.eval()`, and it is why the validation result is stable from run to run, while the training batches are shuffled and dropped differently every time.

## Look inside one epoch

Three quick checks make the loop above concrete. The first shows how an epoch is cut into batches. The last batch is smaller, which is why the epoch loss has to be weighted.

```python run
n_train = len(X_train)
sizes = [min(32, n_train - s) for s in range(0, n_train, 32)]
print("batch sizes:", sizes, "| total examples:", sum(sizes))
```

The second check shows dropout doing its job during training and nothing at evaluation time.

```python run
p_check = dict(params)
a_train_1, _ = forward(X_val[:4], p_check, rng, training=True)
a_train_2, _ = forward(X_val[:4], p_check, rng, training=True)
a_eval_1, _ = forward(X_val[:4], p_check, training=False)
a_eval_2, _ = forward(X_val[:4], p_check, training=False)
print("training passes identical?", np.allclose(a_train_1, a_train_2))
print("evaluation passes identical?", np.allclose(a_eval_1, a_eval_2))
```

The third check compares the naive average of batch losses with the weighted one, using the batch sizes from the first cell.

```python run
batch_losses = np.linspace(0.9, 0.5, len(sizes))     # made-up losses, one per batch
naive = batch_losses.mean()
weighted = np.sum(batch_losses * np.array(sizes)) / sum(sizes)
print("naive average:", round(float(naive), 4), "| weighted:", round(float(weighted), 4))
```

The two averages differ because the last batch holds only 16 examples. The weighted average is the honest measure of the whole epoch, and the naive one quietly gives those 16 examples the same say as the 32 in each full batch.

## Challenge: mini-batches

The loader''s job is to cover every example exactly once per epoch, in a new random order. Write that part yourself.

```python exercise id=batch-iterator title="Shuffled mini-batches"
# TODO: `iterate_batches(X, y, batch_size, rng)` returns a list of (X_batch, y_batch) pairs.
# Shuffle the examples with rng.permutation, then cut them into batches of batch_size.
# The last batch can be smaller. Every example must appear exactly once.
def iterate_batches(X, y, batch_size, rng):
    ...
--- solution
def iterate_batches(X, y, batch_size, rng):
    order = rng.permutation(len(X))
    return [(X[order[i:i + batch_size]], y[order[i:i + batch_size]]) for i in range(0, len(X), batch_size)]
--- test
X_t = np.arange(20, dtype=float).reshape(10, 2)
y_t = np.arange(10, dtype=float)
batches = iterate_batches(X_t, y_t, 4, np.random.default_rng(0))
assert batches is not None, "Replace the `...` in `iterate_batches` with code that returns the batches."
sizes = [len(yb) for _, yb in batches]
assert sizes == [4, 4, 2], f"Ten examples in batches of 4 should give sizes [4, 4, 2], but you returned {sizes}."
all_y = np.concatenate([yb for _, yb in batches])
assert sorted(all_y.tolist()) == list(range(10)), "Every example should appear exactly once across the batches."
for Xb, yb in batches:
    assert np.allclose(Xb[:, 0], yb * 2), "Each X row must stay paired with its label y when you shuffle."
--- hint
Create one shuffled index array with `rng.permutation(len(X))`, then slice the same indices out of both `X` and `y`.
--- hint
Use `range(0, len(X), batch_size)` to get the starting positions of each batch.
```

## Challenge: a weighted epoch loss

The last batch of an epoch is often smaller. Averaging the batch losses directly gives that small batch as much weight as a full one. The fix is a weighted average.

```python exercise id=weighted-loss title="The loss over a whole epoch"
# TODO: `epoch_loss(batch_losses, batch_sizes)` returns the mean loss over every example in the epoch.
# Each batch''s loss is an average over its own examples, so weight it by its size.
def epoch_loss(batch_losses, batch_sizes):
    ...
--- solution
def epoch_loss(batch_losses, batch_sizes):
    return sum(l * n for l, n in zip(batch_losses, batch_sizes)) / sum(batch_sizes)
--- test
result = epoch_loss([1.0, 0.5], [4, 1])
assert result is not None, "Replace the `...` in `epoch_loss` with code that returns the average loss."
assert np.isclose(result, 0.9), f"With a batch of 4 at loss 1.0 and a batch of 1 at loss 0.5 the average over 5 examples is 0.9, but you returned {result!r}."
assert np.isclose(epoch_loss([2.0, 2.0, 2.0], [32, 32, 32]), 2.0), "Equal batches should give the same average."
--- hint
Multiply each batch loss by its batch size, add those up, and divide by the total number of examples.
--- hint
`sum(l * n for l, n in zip(batch_losses, batch_sizes)) / sum(batch_sizes)`.
```

## Debug the evaluation pass

Evaluation must be deterministic. This prediction function is supposed to switch dropout off when `training` is `False`, but it does not.

```python debug id=eval-dropout title="Turn dropout off at evaluation time"
import numpy as np

def predict(X, W, rng, training):
    H = np.maximum(0, X @ W)
    if True:                                       # bug: should depend on `training`
        H = H * (rng.random(H.shape) < 0.5) / 0.5
    return H

X = np.array([[1.0, 2.0], [3.0, -1.0]])
W = np.array([[1.0, 0.0], [0.5, 1.0]])
print(predict(X, W, np.random.default_rng(0), training=False))
--- solution
import numpy as np

def predict(X, W, rng, training):
    H = np.maximum(0, X @ W)
    if training:
        H = H * (rng.random(H.shape) < 0.5) / 0.5
    return H

X = np.array([[1.0, 2.0], [3.0, -1.0]])
W = np.array([[1.0, 0.0], [0.5, 1.0]])
print(predict(X, W, np.random.default_rng(0), training=False))
--- test
X_t = np.array([[1.0, 2.0], [3.0, -1.0]])
W_t = np.array([[1.0, 0.0], [0.5, 1.0]])
out1 = predict(X_t, W_t, np.random.default_rng(0), training=False)
out2 = predict(X_t, W_t, np.random.default_rng(99), training=False)
assert np.allclose(out1, np.maximum(0, X_t @ W_t)), "With training=False the output should be exactly the ReLU of X @ W, with no dropout."
assert np.allclose(out1, out2), "Evaluation should be deterministic. Changing the random seed must not change the output."
--- hint
The dropout line should only run when `training` is true. Put the `if` condition on `training`.
--- hint
Replace `if True:` with `if training:`.
```

## Predict the loss

```python predict id=predict-loss title="What is the epoch loss?"
batch_losses = [0.8, 0.2]
batch_sizes = [3, 1]
total = sum(l * n for l, n in zip(batch_losses, batch_sizes))
print(round(total / sum(batch_sizes), 2))
--- options
* 0.65
0.5
0.8
0.2
--- explain
The weighted sum is 0.8 × 3 + 0.2 × 1 = 2.6, and dividing by the four examples gives 0.65. A simple average of the two batch losses would give 0.5, which over-weights the single example in the small batch.
```

## Recap

- A PyTorch training loop is `zero_grad`, forward, loss, `backward` and `step`, in that order.
- `model.train()` and `model.eval()` switch dropout and batch norm between training and inference.
- Evaluate with `torch.no_grad()` and with dropout turned off, so results are repeatable.
- Average losses over examples, not over batches, so a small final batch does not dominate.

**Up next:** debugging training. When a run goes wrong, you need a systematic method for finding out why.
', 0, '[]', '[]', '2026-06-25T06:30:28.279Z', '2026-10-19T06:30:28.279Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_deep_learning_foundations_4_3', 'sec_deep_learning_foundations_4', 'crs_deep_learning_foundations', 'Debugging training: a field guide', 'interactive', 2, 1080, NULL, NULL, 'Most of the time a network trains, and sometimes it does not. The loss goes to `nan`, it stops moving, or validation accuracy sits at chance while training accuracy looks fine. These failures are frustrating because the code runs without an error. In this lesson you will learn a systematic way to find the cause: check the numbers, reproduce the problem on a tiny case, and change one thing at a time.

## Symptom one: the loss becomes NaN

`nan` (not a number) spreads. Once one value is `nan`, every operation that touches it returns `nan`. The usual sources are a logarithm of zero, a division by zero, and numbers that overflow to infinity.

```python run
import numpy as np

with np.errstate(divide="ignore", invalid="ignore", over="ignore"):
    print("log(0) =", np.log(0.0))
    print("1 / 0 =", 1.0 / np.array([0.0]))
    print("exp(1000) =", np.exp(1000.0))
    print("inf - inf =", np.inf - np.inf)
```

Check for non-finite values at the points where they appear, not only at the end. A `nan` in the loss is usually created one step earlier, in a gradient or an activation.

```python run
def any_nonfinite(arrays):
    return any(not np.all(np.isfinite(a)) for a in arrays)

healthy = [np.array([0.1, -2.0]), np.array([[3.0]])]
broken = [np.array([0.1, np.nan]), np.array([[3.0]])]
print("healthy:", any_nonfinite(healthy), "| broken:", any_nonfinite(broken))
```

## Symptom two: exploding updates

When the learning rate is too large for the curvature of the loss, each step overshoots the valley and lands further away. The parameters grow geometrically, and soon the loss is infinite.

```python run
def run_gd(lr, steps=30, w0=10.0):
    w = w0
    for _ in range(steps):
        w = w - lr * w           # gradient of f(w) = w²/2 is w
    return w

for lr in [0.1, 0.9, 1.5, 2.5]:
    print(f"lr {lr:<4} -> w after 30 steps: {run_gd(lr):.3e}")
```

A learning-rate sweep like this is the fastest diagnosis. If the loss falls for small rates and explodes for large ones, the rate is the problem.

## Symptom three: the model cannot learn at all

Before you blame the data or the architecture, run the **overfit-one-batch test**. Take eight examples and train on them alone. A correct network with a correct loss must drive the loss close to zero. If it cannot memorize eight points, something in the code is broken.

```python run
rng = np.random.default_rng(0)
X = rng.normal(size=(8, 2))
Y = (X[:, :1] > 0).astype(float)          # an easy labelling to memorize

W1 = rng.normal(0, 0.5, (2, 16)); b1 = np.zeros(16)
W2 = rng.normal(0, 0.5, (16, 1)); b2 = np.zeros(1)
lr = 0.5
for step in range(600):
    A1 = np.tanh(X @ W1 + b1)
    P = 1 / (1 + np.exp(-(A1 @ W2 + b2)))
    dZ2 = (P - Y) / len(X)
    dZ1 = (dZ2 @ W2.T) * (1 - A1 ** 2)
    W2 -= lr * (A1.T @ dZ2); b2 -= lr * dZ2.sum(0)
    W1 -= lr * (X.T @ dZ1); b1 -= lr * dZ1.sum(0)

P = 1 / (1 + np.exp(-(np.tanh(X @ W1 + b1) @ W2 + b2)))
loss = -np.mean(Y * np.log(P) + (1 - Y) * np.log(1 - P))
print("loss after overfitting one batch:", round(float(loss), 4))
print("predictions match labels:", bool(np.all((P > 0.5) == Y)))
```

If this test passes, your model and loss are wired correctly, and you can move on to the data. If it fails, the bug is in the code, and it is much easier to find on eight examples than on a million.

> **Pitfall:** skipping the overfit-one-batch test is the most expensive habit in deep learning. Hours go into tuning a model that was never able to learn.

## Gradient norms tell you what is happening

The **gradient norm** is a single number that summarizes how big the update is. Watching it helps you spot vanishing gradients (it shrinks towards zero) and explosions (it grows without limit). A common remedy for explosions is **gradient clipping**: if the norm is above a threshold, scale every gradient down so the norm equals the threshold.

```python run
def grad_norm(grads):
    return np.sqrt(sum(np.sum(g ** 2) for g in grads.values()))

grads = {"W": np.array([[3.0, 0.0]]), "b": np.array([4.0])}
print("gradient norm:", grad_norm(grads))
```

## Learning-rate sensitivity in practice

```python run
losses = {}
for lr in [0.01, 0.1, 0.5, 1.2]:
    w = 10.0
    for _ in range(40):
        w = w - lr * w
    losses[lr] = w ** 2 / 2
for lr, loss in losses.items():
    status = "converged" if loss < 1e-3 else "not converged"
    print(f"lr {lr:<5} final loss {loss:.3e}  {status}")
```

For this function each step multiplies $w$ by $1 - \eta$. Small rates are safe but slow, a rate of exactly one reaches zero in a single step, and any rate above two makes $|1 - \eta| > 1$, so the iterates diverge. Real networks are more complicated, but the same shape holds: the best rate sits below the edge of stability.

## Challenge: the gradient norm

```python exercise id=grad-norm title="The global gradient norm"
# TODO: `global_norm(grads)` takes a dict of gradient arrays and returns one number: the square root
# of the sum of squares of every entry in every array.
def global_norm(grads):
    ...
--- solution
def global_norm(grads):
    return np.sqrt(sum(np.sum(g ** 2) for g in grads.values()))
--- test
result = global_norm({"a": np.array([3.0, 0.0]), "b": np.array([[0.0, 4.0]])})
assert result is not None, "Replace the `...` in `global_norm` with code that returns the norm."
assert np.isclose(result, 5.0), f"The entries 3, 0, 0 and 4 give sqrt(9 + 16) = 5, but you returned {result!r}."
assert np.isclose(global_norm({"w": np.array([1.0, 1.0, 1.0, 1.0])}), 2.0), "Four entries of 1 give a norm of 2."
--- hint
Square every entry of every array, add all the squares together, then take the square root.
--- hint
`np.sqrt(sum(np.sum(g ** 2) for g in grads.values()))`.
```

## Challenge: clip the gradients

```python exercise id=clip-gradients title="Clip large gradients"
# TODO: `clip_gradients(grads, max_norm)` returns a new dict. If the global norm is larger than max_norm,
# scale every gradient by max_norm / norm so the norm becomes max_norm. Otherwise return the same values.
def clip_gradients(grads, max_norm):
    ...
--- solution
def clip_gradients(grads, max_norm):
    norm = np.sqrt(sum(np.sum(g ** 2) for g in grads.values()))
    scale = min(1.0, max_norm / norm) if norm > 0 else 1.0
    return {k: g * scale for k, g in grads.items()}
--- test
grads = {"a": np.array([3.0, 0.0]), "b": np.array([[0.0, 4.0]])}
result = clip_gradients(grads, 1.0)
assert result is not None, "Replace the `...` in `clip_gradients` with code that returns the clipped gradients."
assert np.allclose(result["a"], [0.6, 0.0]) and np.allclose(result["b"], [[0.0, 0.8]]), f"The norm is 5, so every gradient should be scaled by 1/5. You returned {result}."
small = clip_gradients({"w": np.array([0.1, 0.2])}, 1.0)
assert np.allclose(small["w"], [0.1, 0.2]), "A gradient whose norm is already below max_norm should be left alone."
assert np.allclose(grads["a"], [3.0, 0.0]), "Return a new dict. Do not change the input gradients in place."
--- hint
Compute the norm the same way as the global norm. The scale factor is `max_norm / norm`, but only when the norm is above `max_norm`.
--- hint
`scale = min(1.0, max_norm / norm)`, then return `{k: g * scale for k, g in grads.items()}`.
```

## Challenge: detect non-finite values

```python exercise id=nonfinite-check title="Find values that are not finite"
# TODO: `has_nonfinite(arrays)` returns True if any entry of any array is nan or infinite, otherwise False.
def has_nonfinite(arrays):
    ...
--- solution
def has_nonfinite(arrays):
    return any(not np.all(np.isfinite(a)) for a in arrays)
--- test
ok = has_nonfinite([np.array([1.0, 2.0]), np.array([[0.5]])])
assert ok is not None, "Replace the `...` in `has_nonfinite` with code that returns True or False."
assert ok is False, "Finite arrays should return False."
assert has_nonfinite([np.array([1.0, np.nan])]) is True, "A nan should be reported."
assert has_nonfinite([np.array([np.inf])]) is True, "Infinity should be reported too."
assert has_nonfinite([]) is False, "An empty list has no bad values."
--- hint
`np.isfinite(a)` gives a boolean array that is False for nan and infinity. Check whether all of it is True.
--- hint
`return any(not np.all(np.isfinite(a)) for a in arrays)`.
```

## Debug the learning rate

This loop is meant to shrink a weight to zero within 50 steps, but the learning rate makes it diverge.

```python debug id=exploding-lr title="Choose a rate that converges"
w = 10.0
lr = 2.5                  # the gradient of w²/2 is w, and this rate overshoots every step
for _ in range(50):
    w = w - lr * w
print("final |w|:", abs(w))
--- solution
w = 10.0
lr = 0.5                  # small enough that each step lands closer to zero
for _ in range(50):
    w = w - lr * w
print("final |w|:", abs(w))
--- test
assert abs(w) < 1e-3, f"After 50 steps |w| should be close to zero, but it is {abs(w):.3g}. Each step multiplies w by (1 - lr), so the rate must keep |1 - lr| below 1."
assert lr < 2.0, "A learning rate of 2 or more never converges on this function."
--- hint
Each step multiplies `w` by `1 - lr`. For the magnitude to shrink, `|1 - lr|` must be less than 1.
--- hint
A rate between 0 and 2 converges. Try a value in the middle, such as 0.5.
```

## Predict the check

```python predict id=predict-finite title="Which values are finite?"
import numpy as np
print(np.isfinite(np.array([1.0, np.inf, np.nan])).tolist())
--- options
* [True, False, False]
[True, True, False]
[False, False, False]
[True, False, True]
--- explain
`np.isfinite` is True only for ordinary numbers. The first value is finite, while infinity and nan are not. That is exactly the test you want before trusting a loss or a gradient.
```

## Recap

- A `nan` loss is created by an earlier operation. Check for non-finite values where they first appear.
- An exploding loss usually means the learning rate is too large for the curvature. A sweep over rates shows where training breaks.
- The overfit-one-batch test checks that the model and loss can learn at all, and it is the fastest way to find a wiring bug.
- Track the gradient norm, and clip it when it explodes.

**Up next:** convolutions, the operation behind image models, which you will build from first principles.
', 0, '[]', '[]', '2026-06-25T06:30:28.279Z', '2026-10-19T06:30:28.279Z'),
('les_deep_learning_foundations_4_4', 'sec_deep_learning_foundations_4', 'crs_deep_learning_foundations', 'Checkpoint: PyTorch in practice', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"In PyTorch, why must you call optimizer.zero_grad() before loss.backward() in each training step?","options":["backward() fails if gradients already exist","Gradients accumulate by default, so old gradients would be added to the new ones","zero_grad() loads the next batch","It switches the model into evaluation mode"],"answerIndex":1,"explanation":"PyTorch adds each new gradient to the .grad buffer. Without zero_grad(), the update would use the sum of every batch so far."},{"id":"q2","prompt":"What does torch.no_grad() do?","options":["It disables the optimizer","It stops autograd from building the graph, so no gradients are stored","It freezes the learning rate","It shuffles the data"],"answerIndex":1,"explanation":"Inside a no_grad block, operations are not recorded for backpropagation. It saves memory and time, and is the right choice for evaluation."},{"id":"q3","prompt":"Dropout is active in training but not at evaluation time. Which call switches the behavior?","options":["model.train() and model.eval()","loss.backward() and loss.step()","torch.cuda.empty_cache()","optimizer.zero_grad()"],"answerIndex":0,"explanation":"model.train() and model.eval() toggle layers such as dropout and batch normalization between their training and inference behavior."},{"id":"q4","prompt":"Your loss turns into NaN after a few steps. Which change is the most direct first fix to try?","options":["Add more layers","Lower the learning rate and check for log(0) or division by zero","Increase the batch size to 1","Remove the validation set"],"answerIndex":1,"explanation":"A learning rate that is too large can make weights explode, and a log of zero or division by zero produces NaN. Both are checked quickly."},{"id":"q5","prompt":"What is the purpose of an overfit-one-batch test?","options":["To measure final accuracy","To confirm that the model and loss can drive the loss toward zero on a tiny dataset, which proves the training code works","To choose the batch size","To tune the learning rate schedule"],"answerIndex":1,"explanation":"If a model cannot memorize a handful of examples, the bug is in the code, the loss or the wiring, not in the data or the hyperparameters."}]', '[]', '2026-06-25T06:30:28.279Z', '2026-10-19T06:30:28.279Z'),
('les_deep_learning_foundations_5_1', 'sec_deep_learning_foundations_5', 'crs_deep_learning_foundations', 'Convolutions from first principles', 'interactive', 0, 1080, NULL, NULL, 'A dense layer treats every pixel as an unrelated number. That is wasteful for images, where a pattern such as an edge or a corner means the same thing wherever it appears. A **convolution** solves this by sliding one small filter across the whole image and reusing its weights at every position. It is the operation at the heart of every image model, and this lesson builds it from the loops up.

## One filter, many positions

A convolution takes a small **kernel** (also called a filter), places it over a patch of the image, multiplies element by element, and sums. Then it slides one step and repeats. The result is a new image, a **feature map**, that shows where the pattern occurs.

```python run
import matplotlib.pyplot as plt

def corr2d(image, kernel):
    H, W = image.shape
    kh, kw = kernel.shape
    out = np.zeros((H - kh + 1, W - kw + 1))
    for i in range(out.shape[0]):
        for j in range(out.shape[1]):
            out[i, j] = np.sum(image[i:i + kh, j:j + kw] * kernel)
    return out

image = np.zeros((6, 8))
image[:, 4:] = 1.0                      # a bright region with a vertical edge
vertical_edge = np.array([[-1.0, 1.0]]) # responds where brightness steps up left to right

feature_map = corr2d(image, vertical_edge)
print("feature map shape:", feature_map.shape)
print(feature_map)
```

The feature map is zero everywhere except at the edge, where it is strongly positive. The same two numbers found the edge at every row, because the kernel does not care where the edge is.

Deep learning frameworks call this operation a convolution, although the strict mathematical convolution flips the kernel first. Frameworks do not flip, and the network learns whatever kernel is useful, so the difference does not matter in practice.

> **Under the hood:** the kernel''s weights are the only parameters. A $3 \times 3$ kernel has nine weights and one bias, however large the image is. A dense layer mapping a $28 \times 28$ image to 100 units needs over 78,000.

## Look at what a kernel detects

Here are two kernels: one for horizontal edges, one for vertical. Apply both to a picture with a square in it.

```python run
square = np.zeros((10, 10))
square[3:7, 3:7] = 1.0

horizontal = np.array([[-1.0], [1.0]])
vertical = np.array([[-1.0, 1.0]])

fig, axes = plt.subplots(1, 3, figsize=(9, 3))
for ax, img, title in zip(axes, [square, corr2d(square, horizontal), corr2d(square, vertical)],
                          ["input", "horizontal edges", "vertical edges"]):
    ax.imshow(img, cmap="gray"); ax.set_title(title); ax.axis("off")
plt.show()
```

A network learns its kernels from data. The first layer of a trained image model typically learns edge and colour detectors very much like these.

Kernels do not have to find edges. A kernel of equal weights averages each patch, which smooths noise away:

```python run
blur = np.ones((3, 3)) / 9.0
noisy = np.random.default_rng(0).normal(0, 0.3, (8, 8))
smooth = corr2d(noisy, blur)
print("noise std before:", round(noisy.std(), 3), "| after 3 × 3 averaging:", round(smooth.std(), 3))
```

The same sliding operation can sharpen, blur or detect, depending only on the numbers in the kernel. Learning is the process of finding the numbers that help the task.

## Padding and stride control the output size

Each valid convolution shrinks the image, because the kernel cannot be centred on the border pixels. Two settings control the size:

- **Padding** $p$ adds a border of zeros, so the kernel can reach the edge.
- **Stride** $s$ is the step between kernel positions. A stride of 2 halves the output.

The output size along one dimension is

$$
\text{out} = \left\lfloor \frac{n + 2p - k}{s} \right\rfloor + 1
$$

where $n$ is the input size and $k$ the kernel size.

```python run
def out_size(n, k, s=1, p=0):
    return (n + 2 * p - k) // s + 1

for n, k, s, p in [(28, 5, 1, 0), (28, 3, 1, 1), (28, 3, 2, 1), (7, 3, 2, 0)]:
    print(f"input {n:>2}, kernel {k}, stride {s}, padding {p} -> output {out_size(n, k, s, p)}")
```

Padding of one with a $3 \times 3$ kernel keeps the size the same. Stride 2 halves it. You will use these settings constantly.

## Challenge: a valid convolution

```python exercise id=conv2d-valid title="Write a 2-D convolution"
# TODO: `conv2d_valid(image, kernel)` slides the kernel over every position where it fits completely
# inside the image (no padding), multiplies element by element and sums. Return the feature map.
def conv2d_valid(image, kernel):
    ...
--- solution
def conv2d_valid(image, kernel):
    H, W = image.shape
    kh, kw = kernel.shape
    out = np.zeros((H - kh + 1, W - kw + 1))
    for i in range(out.shape[0]):
        for j in range(out.shape[1]):
            out[i, j] = np.sum(image[i:i + kh, j:j + kw] * kernel)
    return out
--- test
img = np.arange(16, dtype=float).reshape(4, 4)
ker = np.array([[1.0, 2.0], [0.0, 1.0]])
result = conv2d_valid(img, ker)
assert result is not None, "Replace the `...` in `conv2d_valid` with code that returns the feature map."
assert result.shape == (3, 3), f"A 2 × 2 kernel on a 4 × 4 image gives a 3 × 3 map, but you returned shape {result.shape}."
expected = np.array([[img[i:i + 2, j:j + 2].ravel() @ ker.ravel() for j in range(3)] for i in range(3)])
assert np.allclose(result, expected), f"Each output should be the sum of the patch times the kernel. Expected {expected.tolist()}, but you returned {result.tolist()}."
assert np.isclose(result[0, 0], 7.0), "The top-left output should be 0·1 + 1·2 + 4·0 + 5·1 = 7."
--- hint
Loop over every top-left corner `(i, j)` where the kernel fits. Each output is the sum of the patch `image[i:i+kh, j:j+kw]` times the kernel.
--- hint
The output has `H - kh + 1` rows and `W - kw + 1` columns. Create it with `np.zeros` and fill it in.
```

## Challenge: the output size

```python exercise id=conv-output-size title="Output size of a convolution"
# TODO: `conv_out_size(n, k, stride, padding)` returns the output size along one dimension,
# using floor((n + 2 * padding - k) / stride) + 1.
def conv_out_size(n, k, stride, padding):
    ...
--- solution
def conv_out_size(n, k, stride, padding):
    return (n + 2 * padding - k) // stride + 1
--- test
result = conv_out_size(28, 5, 1, 0)
assert result is not None, "Replace the `...` in `conv_out_size` with code that returns the size."
assert result == 24, f"A 5 × 5 kernel on 28 pixels with no padding leaves 24 positions, but you returned {result}."
assert conv_out_size(32, 3, 2, 1) == 16, "Stride 2 with padding 1 on 32 pixels gives 16."
assert conv_out_size(7, 3, 2, 0) == 3, "Check the floor: (7 - 3) / 2 + 1 = 3."
--- hint
Add `2 * padding` to the input size, subtract the kernel size, divide by the stride, and add one.
--- hint
`return (n + 2 * padding - k) // stride + 1`. Integer division does the floor for you.
```

## Debug the missing last position

A common bug is a loop that stops one position early. This one builds a feature map that is missing its last row.

```python debug id=off-by-one title="Include the last position"
def conv_loop(image, kernel):
    H, W = image.shape
    kh, kw = kernel.shape
    out = np.zeros((H - kh + 1, W - kw + 1))
    for i in range(H - kh):              # bug: the last valid row is skipped
        for j in range(W - kw + 1):
            out[i, j] = np.sum(image[i:i + kh, j:j + kw] * kernel)
    return out

img = np.arange(12, dtype=float).reshape(3, 4)
print(conv_loop(img, np.ones((2, 2))))
--- solution
def conv_loop(image, kernel):
    H, W = image.shape
    kh, kw = kernel.shape
    out = np.zeros((H - kh + 1, W - kw + 1))
    for i in range(H - kh + 1):
        for j in range(W - kw + 1):
            out[i, j] = np.sum(image[i:i + kh, j:j + kw] * kernel)
    return out

img = np.arange(12, dtype=float).reshape(3, 4)
print(conv_loop(img, np.ones((2, 2))))
--- test
img_t = np.arange(12, dtype=float).reshape(3, 4)
out_t = conv_loop(img_t, np.ones((2, 2)))
assert out_t.shape == (2, 3), f"Three rows and four columns with a 2 × 2 kernel give a (2, 3) map, but you returned {out_t.shape}."
assert np.isclose(out_t[1, 2], 6 + 7 + 10 + 11), f"The bottom-right output should be the sum of its 2 × 2 patch, 34, but it is {out_t[1, 2]}. The last row must be computed."
--- hint
Compare the `range` in the outer loop with the `range` in the inner loop. Both should go up to the last valid position.
--- hint
The outer range should be `range(H - kh + 1)`, the same as the inner one with `W`.
```

## Predict the feature-map shape

```python predict id=predict-conv title="What is the output shape?"
import numpy as np
image = np.ones((5, 5))
kernel = np.ones((3, 3))
print(np.zeros((image.shape[0] - kernel.shape[0] + 1, image.shape[1] - kernel.shape[1] + 1)).shape)
--- options
* (3, 3)
(5, 5)
(2, 2)
(4, 4)
--- explain
A 3 × 3 kernel fits in 5 - 3 + 1 = 3 positions along each side without padding, so the feature map is 3 × 3. Padding of one would keep it at 5 × 5.
```

## Recap

- A convolution slides one small kernel across the image and reuses its weights at every position.
- A feature map shows where a pattern occurs. Early layers learn edge and colour detectors.
- Padding and stride control the output size: $\lfloor (n + 2p - k)/s \rfloor + 1$.
- Convolutions have far fewer parameters than dense layers, and they are translation-aware by design.

**Up next:** pooling and complete convolutional networks, from the first layer to the classifier.
', 0, '[]', '[]', '2026-06-25T06:30:28.279Z', '2026-10-19T06:30:28.279Z'),
('les_deep_learning_foundations_5_2', 'sec_deep_learning_foundations_5', 'crs_deep_learning_foundations', 'Building convolutional networks', 'interactive', 1, 1080, NULL, NULL, 'A convolutional network stacks three kinds of layers: convolutions that detect patterns, non-linearities that combine them, and **pooling** layers that shrink the feature maps and keep the strongest responses. At the end, the features are flattened into a dense classifier. In this lesson you will implement pooling, handle images with several colour channels, and assemble a complete small CNN forward pass, watching the shape change at every stage.

## Pooling keeps the strongest response

**Max pooling** divides the feature map into small blocks, usually $2 \times 2$, and keeps the largest value in each. It halves the height and width, so later layers see a bigger picture with fewer numbers, and it makes the output less sensitive to a pattern moving by a pixel.

```python run
import numpy as np

fmap = np.array([
    [1.0, 3.0, 0.0, 2.0],
    [4.0, 2.0, 1.0, 0.0],
    [0.0, 1.0, 5.0, 2.0],
    [2.0, 0.0, 3.0, 1.0],
])

pooled = fmap.reshape(2, 2, 2, 2).max(axis=(1, 3))
print("input:", fmap.shape, "-> pooled:", pooled.shape)
print(pooled)
```

The `reshape` splits the map into blocks, and `max` over the block axes keeps one value per block. Read the output: each entry is the strongest response in its $2 \times 2$ region.

## Images have channels

A colour image has three channels, red, green and blue, so its shape is $(3, H, W)$. A convolution then has a kernel for each input channel, and it sums across them to make one output channel. Several kernels make several output channels.

```python run
from numpy.lib.stride_tricks import sliding_window_view

rng = np.random.default_rng(0)
image = rng.random((3, 8, 8))            # 3 channels, 8 × 8 pixels
kernels = rng.normal(size=(4, 3, 3, 3))  # 4 filters, each 3 channels × 3 × 3

windows = sliding_window_view(image, (3, 3, 3))   # every 3 × 3 patch in all 3 channels
out = np.einsum("hwcij,kcij->khw", windows[0], kernels)  # shape (4, 6, 6)
print("input:", image.shape, "| output:", out.shape)
```

The output has four channels, one per filter, and each is a 6 × 6 map. Adding channels does not change the spatial size; only the kernel size, padding and stride do.

## Count the parameters

Convolutions share weights across positions, so the parameter count depends on the number of filters and their size, not on the image size. Compare a convolution with a dense layer on the same image.

```python run
def conv_params(c_in, c_out, k):
    return c_out * (c_in * k * k + 1)

def dense_params(n_in, n_out):
    return n_in * n_out + n_out

print("conv 3 → 16 channels, 3×3:", conv_params(3, 16, 3), "parameters")
print("dense 32×32×3 → 16 units:", dense_params(32 * 32 * 3, 16), "parameters")
```

The dense layer needs 49,168 parameters, about a hundred times the convolution''s 448, and it cannot share anything across positions. On larger images the gap grows with every pixel, while the convolution''s count stays the same.

## A complete small CNN

Put the pieces together: a convolution, a ReLU, pooling, flattening and a dense output. Each line of this forward pass changes the shape, and the shapes are the part to read carefully.

```python run
def relu(z):
    return np.maximum(0, z)

def conv_layer(x, kernels, bias):
    windows = sliding_window_view(x, kernels.shape[1:])
    out = np.einsum("hwcij,kcij->khw", windows[0], kernels)
    return out + bias[:, None, None]

def max_pool(x):
    C, H, W = x.shape
    return x.reshape(C, H // 2, 2, W // 2, 2).max(axis=(2, 4))

x = rng.random((3, 8, 8))
K = rng.normal(0, 0.3, size=(4, 3, 3, 3))
b = np.zeros(4)
W_out = rng.normal(0, 0.3, size=(4 * 3 * 3, 10))

h1 = relu(conv_layer(x, K, b))            # (4, 6, 6)
h2 = max_pool(h1)                          # (4, 3, 3)
flat = h2.reshape(-1)                      # (36,)
logits = flat @ W_out                      # (10,)
print("conv:", h1.shape, "| pool:", h2.shape, "| flat:", flat.shape, "| logits:", logits.shape)
```

This is the whole architecture of a classic image classifier, in miniature. Real models repeat the convolution and pooling blocks many times, with more channels at each step, and end with the same flatten-and-classify step.

> **In the wild:** PyTorch''s `nn.Conv2d` and `nn.MaxPool2d` do exactly these operations, with the batch dimension added in front. The shapes you have just tracked are the same ones you will read in PyTorch error messages.

## Challenge: max pooling

```python exercise id=max-pool title="2 × 2 max pooling"
# TODO: `max_pool2d(x)` takes a 2-D feature map with even height and width and returns the maximum of each
# non-overlapping 2 × 2 block. The output is half the height and half the width.
def max_pool2d(x):
    ...
--- solution
def max_pool2d(x):
    H, W = x.shape
    return x.reshape(H // 2, 2, W // 2, 2).max(axis=(1, 3))
--- test
fm = np.array([[1.0, 3.0, 0.0, 2.0], [4.0, 2.0, 1.0, 0.0], [0.0, 1.0, 5.0, 2.0], [2.0, 0.0, 3.0, 1.0]])
result = max_pool2d(fm)
assert result is not None, "Replace the `...` in `max_pool2d` with code that returns the pooled map."
assert result.shape == (2, 2), f"A 4 × 4 map pooled 2 × 2 should be 2 × 2, but you returned {result.shape}."
assert np.allclose(result, [[4.0, 2.0], [2.0, 5.0]]), f"The block maxima should be [[4, 2], [2, 5]], but you returned {result}."
big = np.arange(36, dtype=float).reshape(6, 6)
assert np.allclose(max_pool2d(big), [[7, 9, 11], [19, 21, 23], [31, 33, 35]]), "Check that it works on a larger map too."
--- hint
Reshape the map into blocks, with the block indices on their own axes. Then take the maximum over the two axes that index inside a block.
--- hint
`H, W = x.shape`, then `x.reshape(H // 2, 2, W // 2, 2).max(axis=(1, 3))`.
```

## Challenge: parameters of a convolution

```python exercise id=conv-params title="Count the parameters"
# TODO: `conv_param_count(c_in, c_out, k)` returns the number of learnable parameters of a convolution
# with c_out filters, each of size k × k over c_in input channels, including one bias per filter.
def conv_param_count(c_in, c_out, k):
    ...
--- solution
def conv_param_count(c_in, c_out, k):
    return c_out * (c_in * k * k + 1)
--- test
result = conv_param_count(3, 16, 3)
assert result is not None, "Replace the `...` in `conv_param_count` with code that returns the count."
assert result == 448, f"16 filters of 3 × 3 × 3 weights plus a bias each is 16 × 28 = 448, but you returned {result}."
assert conv_param_count(1, 1, 5) == 26, "One 5 × 5 filter on one channel has 25 weights and one bias."
--- hint
Each filter has `c_in * k * k` weights and one bias, and there are `c_out` filters.
--- hint
`return c_out * (c_in * k * k + 1)`.
```

## Debug the pooling axes

```python debug id=pool-axes title="Pool within each block"
fm = np.arange(16, dtype=float).reshape(4, 4)
H, W = fm.shape
pooled = fm.reshape(H // 2, 2, W // 2, 2).max(axis=(0, 2))    # bug: pooling over the block indices
print(pooled.shape)
print(pooled)
--- solution
fm = np.arange(16, dtype=float).reshape(4, 4)
H, W = fm.shape
pooled = fm.reshape(H // 2, 2, W // 2, 2).max(axis=(1, 3))
print(pooled.shape)
print(pooled)
--- test
assert pooled.shape == (2, 2), f"Pooling 4 × 4 into 2 × 2 blocks should give shape (2, 2), but you have {pooled.shape}. The max must run over the axes inside each block."
assert np.allclose(pooled, [[5.0, 7.0], [13.0, 15.0]]), f"The block maxima should be [[5, 7], [13, 15]], but you have {pooled}."
--- hint
In the reshape, the block index comes first and the position inside the block comes second. The axes inside a block are the ones of size 2.
--- hint
The axes of size 2 are axes 1 and 3. Replace `(0, 2)` with `(1, 3)`.
```

## Predict the flattened size

```python predict id=predict-flatten title="How many values reach the classifier?"
import numpy as np
x = np.zeros((8, 6, 6))
print(x.reshape(-1).shape)
--- options
* (288,)
(8, 36)
(6, 6)
(48,)
--- explain
Flattening keeps every value, so the total is 8 × 6 × 6 = 288. The result is a single vector of 288 numbers, which is the input the dense classifier expects.
```

## Recap

- Max pooling keeps the strongest response in each block, which halves the spatial size and adds tolerance to small shifts.
- Images have channels. A convolution sums over input channels and produces one output channel per filter.
- A CNN alternates convolution, non-linearity and pooling, then flattens into a dense classifier.
- Track the shapes at every stage. Most CNN bugs are shape bugs in disguise.

**Up next:** sequences. Recurrent networks process one step at a time and carry a memory forward, and you will see why that memory is hard to keep.
', 0, '[]', '[]', '2026-06-25T06:30:28.279Z', '2026-10-19T06:30:28.279Z'),
('les_deep_learning_foundations_5_3', 'sec_deep_learning_foundations_5', 'crs_deep_learning_foundations', 'Recurrent networks and vanishing gradients', 'interactive', 2, 960, NULL, NULL, 'Images are fixed grids, but many important inputs are sequences: sentences, sensor readings, music, prices over time. A **recurrent neural network** (RNN) processes a sequence one step at a time and carries a hidden state forward, a memory of what it has seen. The idea is simple. The difficulty is that memory fades, and in this lesson you will see exactly why.

## One step, one update

At each time step the RNN reads an input $x_t$ and combines it with the previous state $h_{t-1}$:

$$
h_t = \tanh\bigl(x_t W_x + h_{t-1} W_h + b\bigr)
$$

The same weights $W_x$, $W_h$ and $b$ are used at every step. That reuse is what lets an RNN handle sequences of any length.

```python run
import numpy as np

def rnn_step(x_t, h_prev, Wx, Wh, b):
    return np.tanh(x_t @ Wx + h_prev @ Wh + b)

rng = np.random.default_rng(0)
Wx = rng.normal(0, 0.5, size=(2, 3))     # 2 input features, 3 hidden units
Wh = rng.normal(0, 0.5, size=(3, 3))
b = np.zeros(3)

h = np.zeros(3)                          # start with an empty memory
x1 = np.array([1.0, -0.5])
h = rnn_step(x1, h, Wx, Wh, b)
print("state after one step:", np.round(h, 3))
```

## Unroll the sequence

Run the same step over a whole sequence, and keep every state. The final state summarizes the sequence, and the earlier states are what a model uses to make predictions at each time step.

```python run
def rnn_forward(xs, h0, Wx, Wh, b):
    states = []
    h = h0
    for x_t in xs:
        h = rnn_step(x_t, h, Wx, Wh, b)
        states.append(h)
    return np.array(states)

xs = rng.normal(size=(6, 2))             # a sequence of 6 steps
states = rnn_forward(xs, np.zeros(3), Wx, Wh, b)
print("states shape:", states.shape, "(time steps, hidden units)")
print("norm of each state:", np.round(np.linalg.norm(states, axis=1), 3))
```

## Memory fades

Put a single strong signal at the start of a sequence and then silence. How long does the network remember it? The answer depends on the size of the recurrent weight. Try the two settings below.

```python run
def impulse_memory(w_rec, steps=15):
    h = 1.0                              # an input at t = 0, then nothing
    trace = [h]
    for _ in range(steps):
        h = np.tanh(w_rec * h)           # a one-unit RNN with no input after t = 0
        trace.append(h)
    return np.array(trace)

for w_rec in [0.5, 0.95]:
    trace = impulse_memory(w_rec)
    print(f"recurrent weight {w_rec}: state after 15 steps = {trace[-1]:.4f}")
```

With a recurrent weight of 0.5 the signal is gone in a few steps. With 0.95 it lingers. Neither network can remember the first input after a long delay without a change to the design.

## Why gradients vanish

Training an RNN means backpropagating through every time step. The gradient flowing back $t$ steps picks up one recurrent factor per step, so it grows or shrinks like a power of the recurrent weight. Look at what that does over 50 steps.

```python run
for w_rec in [0.5, 0.9, 1.1]:
    g = 1.0
    for _ in range(50):
        g *= w_rec                       # one factor per time step
    print(f"recurrent weight {w_rec}: gradient factor after 50 steps = {g:.2e}")
```

A factor below one vanishes to nothing, so the network cannot learn from distant inputs. A factor above one explodes, which is why gradient clipping from lesson 16 is standard for RNNs. The tanh derivative, which is at most one, makes vanishing even more likely.

> **Under the hood:** LSTMs and GRUs fix the vanishing problem with gates. A gate is a learned value between zero and one that controls how much of the old memory is kept, so information can flow across many steps without being multiplied away at each one.

## Challenge: one recurrent step

```python exercise id=rnn-step title="One recurrent step"
# TODO: `rnn_step(x_t, h_prev, Wx, Wh, b)` returns the new hidden state tanh(x_t Wx + h_prev Wh + b).
# x_t has shape (d,), h_prev has shape (k,), Wx has shape (d, k), Wh has shape (k, k), and b has shape (k,).
def rnn_step(x_t, h_prev, Wx, Wh, b):
    ...
--- solution
def rnn_step(x_t, h_prev, Wx, Wh, b):
    return np.tanh(x_t @ Wx + h_prev @ Wh + b)
--- test
Wx_t = np.array([[1.0, 0.0], [0.0, 1.0]])
Wh_t = np.array([[0.5, 0.0], [0.0, 0.5]])
result = rnn_step(np.array([1.0, 0.0]), np.array([0.0, 2.0]), Wx_t, Wh_t, np.zeros(2))
assert result is not None, "Replace the `...` in `rnn_step` with code that returns the new state."
assert result.shape == (2,), f"The new state should have shape (2,), but it has {result.shape}."
assert np.allclose(result, np.tanh([1.0, 1.0])), f"The pre-activation is [1, 0] + [0, 1] = [1, 1], so the state should be tanh([1, 1]), but you returned {result}."
--- hint
Add the input contribution `x_t @ Wx`, the memory contribution `h_prev @ Wh`, and the bias, then apply `np.tanh`.
--- hint
`return np.tanh(x_t @ Wx + h_prev @ Wh + b)`.
```

## Challenge: run the whole sequence

```python exercise id=rnn-forward title="Unroll an RNN over a sequence"
# TODO: `rnn_states(xs, h0, Wx, Wh, b)` runs rnn_step over every row of xs (shape (T, d)), starting from h0,
# and returns an array of shape (T, k) holding the state after each step.
def rnn_states(xs, h0, Wx, Wh, b):
    ...
--- solution
def rnn_states(xs, h0, Wx, Wh, b):
    states = []
    h = h0
    for x_t in xs:
        h = np.tanh(x_t @ Wx + h @ Wh + b)
        states.append(h)
    return np.array(states)
--- test
rng_t = np.random.default_rng(2)
xs_t = rng_t.normal(size=(5, 2))
Wx_t = rng_t.normal(size=(2, 3))
Wh_t = rng_t.normal(size=(3, 3))
b_t = np.zeros(3)
result = rnn_states(xs_t, np.zeros(3), Wx_t, Wh_t, b_t)
assert result is not None, "Replace the `...` in `rnn_states` with code that returns the states."
assert result.shape == (5, 3), f"Five steps with three hidden units should give shape (5, 3), but you returned {result.shape}."
h = np.zeros(3)
for x_t in xs_t:
    h = np.tanh(x_t @ Wx_t + h @ Wh_t + b_t)
assert np.allclose(result[-1], h), "The last state should equal the state after running every step in order."
assert np.allclose(result[0], np.tanh(xs_t[0] @ Wx_t + b_t)), "With a zero start, the first state depends only on the first input."
--- hint
Keep a variable `h` for the current state, update it inside the loop, and append it to a list.
--- hint
Start `h = h0`, and inside the loop set `h = np.tanh(x_t @ Wx + h @ Wh + b)` and append `h`.
```

## Debug the state bookkeeping

This version records states one step late. It appends the state before updating it.

```python debug id=state-timing title="Record the state after the update"
def rnn_states(xs, h0, Wx, Wh, b):
    states = []
    h = h0
    for x_t in xs:
        states.append(h)                              # bug: stores the state before the update
        h = np.tanh(x_t @ Wx + h @ Wh + b)
    return np.array(states)

rng_d = np.random.default_rng(1)
xs_d = rng_d.normal(size=(3, 2))
print(np.round(rnn_states(xs_d, np.zeros(2), rng_d.normal(size=(2, 2)), np.eye(2) * 0.5, np.zeros(2)), 3))
--- solution
def rnn_states(xs, h0, Wx, Wh, b):
    states = []
    h = h0
    for x_t in xs:
        h = np.tanh(x_t @ Wx + h @ Wh + b)
        states.append(h)
    return np.array(states)

rng_d = np.random.default_rng(1)
xs_d = rng_d.normal(size=(3, 2))
print(np.round(rnn_states(xs_d, np.zeros(2), rng_d.normal(size=(2, 2)), np.eye(2) * 0.5, np.zeros(2)), 3))
--- test
rng_t = np.random.default_rng(1)
xs_t = rng_t.normal(size=(3, 2))
Wx_t = rng_t.normal(size=(2, 2))
out = rnn_states(xs_t, np.zeros(2), Wx_t, np.eye(2) * 0.5, np.zeros(2))
assert np.allclose(out[0], np.tanh(xs_t[0] @ Wx_t)), "The first state should already include the first input. The states are recorded before the update."
assert np.all(np.any(out != 0, axis=1)), "Every step should produce a non-zero state for these inputs. A zero row means the state was recorded too early."
--- hint
Look at the order of the two lines inside the loop: which one happens first, the append or the update?
--- hint
Swap them: update `h` first, then append it.
```

## Predict the gradient factor

```python predict id=predict-rnn title="What is the gradient factor?"
w_rec = 0.5
g = 1.0
for _ in range(3):
    g *= w_rec
print(g)
--- options
* 0.125
0.5
1.5
0.03125
--- explain
Each of the three steps multiplies the gradient by 0.5, so the factor is 0.5³ = 0.125. The same multiplication over 50 steps gives a factor near 10⁻¹⁶, which is why distant inputs stop influencing the weights.
```

## Recap

- An RNN updates a hidden state with $h_t = \tanh(x_t W_x + h_{t-1} W_h + b)$, reusing the same weights at every step.
- The hidden state is a memory of the sequence, and its final value summarizes the input.
- Backpropagation through time multiplies one recurrent factor per step, so gradients vanish or explode with the recurrent weight.
- Gates in LSTMs and GRUs let information survive long sequences.

**Up next:** attention. Instead of squeezing a whole sequence into one memory, the model looks back at every position directly, and that idea powers Transformers.
', 0, '[]', '[]', '2026-06-25T06:30:28.279Z', '2026-10-19T06:30:28.279Z'),
('les_deep_learning_foundations_5_4', 'sec_deep_learning_foundations_5', 'crs_deep_learning_foundations', 'Attention: the core of Transformers', 'interactive', 3, 1080, NULL, NULL, 'A recurrent network has to squeeze everything it has read into one hidden state, and distant words fade on the way. **Attention** takes a different approach. Each position looks back at every other position directly and decides how much to use from each. That single idea, repeated in layers, is the core of the **Transformer**, the architecture behind modern language models.

In this lesson you will build scaled dot-product attention from its formula, see what the weights mean, and learn how a causal mask stops a model from peeking at the future.

## The query-key-value idea

Attention works with three matrices, each with one row per position:

- **Queries** $Q$: what each position is looking for.
- **Keys** $K$: what each position offers to be matched against.
- **Values** $V$: the content each position passes along when it is chosen.

Each query is compared with every key by a dot product. A high score means a good match. The scores are turned into weights with softmax, and the output for each position is the weighted average of the values.

$$
\operatorname{Attention}(Q, K, V) = \operatorname{softmax}\!\left(\frac{Q K^{\top}}{\sqrt{d}}\right) V
$$

```python run
import numpy as np

def softmax(Z, axis=-1):
    e = np.exp(Z - Z.max(axis=axis, keepdims=True))
    return e / e.sum(axis=axis, keepdims=True)

rng = np.random.default_rng(0)
n, d = 4, 8                              # 4 tokens, each a vector of size 8
Q = rng.normal(size=(n, d))
K = rng.normal(size=(n, d))
V = rng.normal(size=(n, d))

scores = Q @ K.T / np.sqrt(d)            # (4, 4): every query against every key
weights = softmax(scores, axis=-1)
out = weights @ V                        # (4, 8): a weighted mix of values per position

print("scores:", scores.shape, "| weights:", weights.shape, "| output:", out.shape)
print("each row of weights sums to:", np.round(weights.sum(axis=1), 6))
```

Every row of the weight matrix is a probability distribution over the positions. Row $i$ says how much position $i$ attends to each other position.

Here is attention doing its job on a tiny example. One query points in the direction of the third key, so most of the weight lands there, and the output is pulled towards that key''s value.

```python run
q = np.array([[0.0, 3.0]])
keys = np.array([[1.0, 0.0], [0.0, 1.0], [0.0, 3.0], [-1.0, 0.0]])
values = np.array([[10.0], [20.0], [30.0], [40.0]])

w_demo = softmax(q @ keys.T / np.sqrt(2), axis=-1)
print("weights over the four keys:", np.round(w_demo, 3))
print("attention output:", np.round(w_demo @ values, 2))
```

The output is close to 30, the value of the matching key, and not a plain average of all four. Attention is a learned, content-based lookup.

## Why divide by the square root of d

Dot products grow with the dimension. If the entries of $Q$ and $K$ have variance one, a dot product over $d$ entries has variance $d$. Large scores push softmax towards a one-hot answer, where the gradients are almost zero. Dividing by $\sqrt{d}$ keeps the scores at a useful scale.

```python run
for d_check in [8, 64, 512]:
    q = rng.normal(size=(2000, d_check))
    k = rng.normal(size=(2000, d_check))
    raw = np.sum(q * k, axis=1)
    print(f"d = {d_check:>3}: std of raw scores {raw.std():6.2f}   scaled {(raw / np.sqrt(d_check)).std():.2f}")
```

The raw scores grow like $\sqrt{d}$, and the scaled ones stay near one, whatever the dimension.

## Causal masks: no peeking at the future

A language model predicts the next word, so a position must not see words after it. A **causal mask** sets the scores for future positions to a very negative value before the softmax. Their weights become zero, and the model attends only to the past.

```python run
mask = np.tril(np.ones((n, n), dtype=bool))      # True where attention is allowed
masked_scores = np.where(mask, scores, -1e9)
causal_weights = softmax(masked_scores, axis=-1)
print(np.round(causal_weights, 3))
```

The upper triangle is zero: the first token attends only to itself, the second to the first two, and so on. This is how GPT-style models are trained in parallel, with every next-word prediction in one pass.

> **In the wild:** Transformers stack many attention layers, each with several "heads" that learn different relationships, and each followed by a feed-forward network. The formula above is the core of every head.

## Challenge: scaled dot-product attention

```python exercise id=attention title="Scaled dot-product attention"
# TODO: `attention(Q, K, V)` returns a tuple (out, weights). weights = softmax(Q Kᵀ / sqrt(d)) over the
# keys, with one row per query, where d is the number of columns of Q. out = weights @ V.
def attention(Q, K, V):
    ...
--- solution
def attention(Q, K, V):
    d = Q.shape[-1]
    scores = Q @ K.T / np.sqrt(d)
    e = np.exp(scores - scores.max(axis=-1, keepdims=True))
    weights = e / e.sum(axis=-1, keepdims=True)
    return weights @ V, weights
--- test
rng_t = np.random.default_rng(5)
Qt = rng_t.normal(size=(3, 4))
Kt = rng_t.normal(size=(5, 4))
Vt = rng_t.normal(size=(5, 2))
result = attention(Qt, Kt, Vt)
assert result is not None, "Replace the `...` in `attention` with code that returns (out, weights)."
out, w = result
assert out.shape == (3, 2), f"With 3 queries and values of size 2 the output should be (3, 2), but it is {out.shape}."
assert w.shape == (3, 5), f"The weights should have one row per query and one column per key, (3, 5), but they have shape {w.shape}."
assert np.allclose(w.sum(axis=1), 1.0), "Each row of weights must sum to 1."
s = Qt @ Kt.T / np.sqrt(4)
ref = np.exp(s) / np.exp(s).sum(axis=1, keepdims=True)
assert np.allclose(w, ref), "Check the scaling: divide the scores by sqrt(d), where d is the query size, not the number of keys."
assert np.allclose(out, ref @ Vt), "The output should be the weights times the values."
--- hint
Compute `Q @ K.T`, divide by `np.sqrt(d)`, then apply a softmax across each row (`axis=-1`). The output is the weights times `V`.
--- hint
`scores = Q @ K.T / np.sqrt(d)`; then `weights` is `exp(scores)` normalized along the last axis, and the output is `weights @ V`.
```

## Challenge: a causal mask

```python exercise id=causal-mask title="Build a causal mask"
# TODO: `causal_mask(n)` returns an (n, n) boolean array that is True where position i may attend to position j,
# which is when j <= i. Use the lower triangle, including the diagonal.
def causal_mask(n):
    ...
--- solution
def causal_mask(n):
    return np.tril(np.ones((n, n), dtype=bool))
--- test
m = causal_mask(3)
assert m is not None, "Replace the `...` in `causal_mask` with code that returns the mask."
assert m.dtype == bool and m.shape == (3, 3), f"The mask should be a boolean (3, 3) array, but it is {m.dtype} with shape {m.shape}."
expected = np.array([[True, False, False], [True, True, False], [True, True, True]])
assert np.array_equal(m, expected), f"Position 0 may see only itself, and position 2 may see everything before it. You returned {m.astype(int).tolist()}."
assert causal_mask(1).tolist() == [[True]], "A single position may attend to itself."
--- hint
`np.tril` keeps the lower triangle of an array. Build an array of ones with the right shape, and keep its lower triangle.
--- hint
`np.tril(np.ones((n, n), dtype=bool))`.
```

## Debug the attention axis

This version normalizes the scores down each column instead of across each row, so every query''s weights fail to sum to one.

```python debug id=attention-axis title="Normalize each query''s weights"
rng_d = np.random.default_rng(3)
Q = rng_d.normal(size=(3, 4))
K = rng_d.normal(size=(5, 4))
scores = Q @ K.T / np.sqrt(4)
e = np.exp(scores - scores.max(axis=1, keepdims=True))
weights = e / e.sum(axis=0, keepdims=True)              # bug: normalizes across queries
print("row sums:", np.round(weights.sum(axis=1), 3))
--- solution
rng_d = np.random.default_rng(3)
Q = rng_d.normal(size=(3, 4))
K = rng_d.normal(size=(5, 4))
scores = Q @ K.T / np.sqrt(4)
e = np.exp(scores - scores.max(axis=1, keepdims=True))
weights = e / e.sum(axis=1, keepdims=True)
print("row sums:", np.round(weights.sum(axis=1), 3))
--- test
assert np.allclose(weights.sum(axis=1), 1.0), f"Each query''s weights must sum to 1, but the row sums are {weights.sum(axis=1)}. Normalize across the keys, which is axis 1."
assert weights.shape == (3, 5), f"The weights should have shape (3, 5), but they have {weights.shape}."
--- hint
Each row is one query, and the keys are the columns. The softmax must be normalized over the columns of each row.
--- hint
Change `e.sum(axis=0)` to `e.sum(axis=1)`.
```

## Predict the mask row

```python predict id=predict-mask title="What can position 0 attend to?"
import numpy as np
print(np.tril(np.ones((3, 3)))[0])
--- options
* [1. 0. 0.]
[1. 1. 1.]
[0. 0. 1.]
[0.33 0.33 0.33]
--- explain
The first row of a lower-triangular matrix has a one only in its first column. Position 0 may attend only to itself, so every other weight is zeroed by the mask.
```

## Recap

- Attention scores every query against every key with a dot product, turns the scores into weights with softmax, and outputs a weighted sum of values.
- Scale the scores by $\sqrt{d}$ so that softmax keeps useful gradients as the dimension grows.
- Each row of the weights is a distribution over positions, so every row sums to one.
- A causal mask zeroes the weights for future positions, which lets a language model train on every position at once.

**Up next:** a capstone. You will train an image classifier from scratch on data you generate, using the pieces from this course.
', 0, '[]', '[]', '2026-06-25T06:30:28.279Z', '2026-10-19T06:30:28.279Z'),
('les_deep_learning_foundations_5_5', 'sec_deep_learning_foundations_5', 'crs_deep_learning_foundations', 'Checkpoint: convolutional and sequence models', 'quiz', 4, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"An input is 28 × 28, a kernel is 5 × 5, the stride is 1 and there is no padding. What is the output size of the convolution?","options":["23 × 23","24 × 24","28 × 28","27 × 27"],"answerIndex":1,"explanation":"The output size is (n - k + 2p) / s + 1 = (28 - 5 + 0) / 1 + 1 = 24."},{"id":"q2","prompt":"Why do CNNs share the same kernel weights across every position in the image?","options":["To make the network smaller and to detect a pattern wherever it appears","To avoid computing gradients","Because images are always square","To make the output the same size as the input"],"answerIndex":0,"explanation":"Weight sharing gives translation equivariance with far fewer parameters: a feature detector learned in one corner works everywhere."},{"id":"q3","prompt":"A recurrent network multiplies the gradient by a recurrent weight of about 0.9 at each of 50 time steps. Roughly how big is the gradient?","options":["About 0.9","About 0.5","About 0.005","About 50"],"answerIndex":2,"explanation":"0.9^50 is about 0.005. Repeated multiplication by numbers below one makes the gradient vanish, which is why long-range memory is hard to learn."},{"id":"q4","prompt":"In scaled dot-product attention, why is each score divided by the square root of the key dimension d?","options":["To make the softmax output sum to d","To keep the dot products from growing with d, which would push softmax into saturated regions with tiny gradients","To normalize the input embeddings","Because the square root is required by the Transformer paper''s notation"],"answerIndex":1,"explanation":"For random vectors, the variance of a dot product grows with d. Dividing by sqrt(d) keeps the scores at a scale where softmax still has useful gradients."},{"id":"q5","prompt":"What does each row of the attention weight matrix represent after softmax?","options":["How much each query is used across the batch","A probability distribution over the keys for one query","The loss for one token","The learned embedding of a token"],"answerIndex":1,"explanation":"Softmax makes every row non-negative and sum to one. Row i says how much query i attends to each key."}]', '[]', '2026-06-25T06:30:28.279Z', '2026-10-19T06:30:28.279Z'),
('les_deep_learning_foundations_6_1', 'sec_deep_learning_foundations_6', 'crs_deep_learning_foundations', 'Capstone: train an image classifier end to end', 'interactive', 0, 1800, NULL, NULL, 'This is the capstone. You will take everything from the course and use it to train an image classifier end to end: generate a dataset, split it correctly, build a network, train it with Adam, and judge the result honestly on data it has never seen.

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
assert np.array_equal(result, [[1, 0, 0], [0, 0, 1], [0, 1, 0]]), f"Each row should have a single 1 in its label''s column. You returned {result.tolist()}."
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
', 0, '[]', '[]', '2026-06-25T06:30:28.279Z', '2026-10-19T06:30:28.279Z'),
('les_deep_learning_foundations_6_2', 'sec_deep_learning_foundations_6', 'crs_deep_learning_foundations', 'Final assessment: Deep Learning Foundations', 'quiz', 1, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"A network is trained on a training set, and its hyperparameters are tuned on a validation set. Why must the final accuracy be reported on a separate test set?","options":["Because the test set is larger","Because the validation set was used to make choices, so its score is optimistically biased","Because the test set has the labels removed","Because test sets are always smaller"],"answerIndex":1,"explanation":"Every time you pick a setting based on validation performance, you fit the validation set a little. Only a held-out test set gives an honest estimate of performance on new data."},{"id":"q2","prompt":"Standardizing features with the mean and standard deviation of the training set should be applied to the validation set using…","options":["The validation set''s own mean and standard deviation","The training set''s mean and standard deviation","The mean of both sets combined","No scaling at all"],"answerIndex":1,"explanation":"Using statistics from the validation or test data leaks information about it into training. The same training-set statistics must be applied everywhere."},{"id":"q3","prompt":"The output of the final layer of a 4-class classifier is passed through softmax. What does the cross-entropy loss need from it?","options":["The raw class labels","A probability for each class that sums to one","A single number between 0 and 1","The gradient of the labels"],"answerIndex":1,"explanation":"Cross-entropy compares a predicted probability distribution with the true class. Softmax turns the raw scores into that distribution."},{"id":"q4","prompt":"A convolutional network is evaluated on a new image with the same size as its training images but a different lighting condition. Which technique most directly builds robustness to this kind of change?","options":["Training longer on the same images","Data augmentation, such as brightness and contrast changes during training","Removing all convolutional layers","Using a larger learning rate"],"answerIndex":1,"explanation":"Augmentation exposes the model to plausible variations of the data during training, so it learns features that survive them."},{"id":"q5","prompt":"A model''s training loss decreases steadily, but its validation loss starts rising after epoch 8. What is the best next step?","options":["Train for 100 more epochs","Stop training around epoch 8, or add regularization such as weight decay or dropout","Remove the validation set","Double the learning rate"],"answerIndex":1,"explanation":"Rising validation loss while training loss falls is overfitting. Early stopping or regularization keeps the model from memorizing the training set."},{"id":"q6","prompt":"Why does a deep network generally need the activation function''s derivative during backpropagation?","options":["To choose the batch size","Because the chain rule multiplies the local derivative of each activation into the gradient","To normalize the input data","To count the number of parameters"],"answerIndex":1,"explanation":"Every activation sits on the path from the loss back to the weights. Its local derivative is one of the factors the chain rule multiplies together."},{"id":"q7","prompt":"Which change would most likely make a shape classifier generalize better to shapes drawn at a different size?","options":["Using a smaller training set","Training with randomly scaled examples and adding a validation split","Removing the bias terms","Setting the learning rate to zero"],"answerIndex":1,"explanation":"Training on varied sizes teaches the model the shape rather than its absolute scale, and a validation split tells you whether it worked."}]', '[]', '2026-06-25T06:30:28.279Z', '2026-10-19T06:30:28.279Z');

INSERT INTO path_courses (path_id, course_id, position) VALUES
('pth_ml_engineer', 'crs_deep_learning_foundations', 5),
('pth_llm_engineer', 'crs_deep_learning_foundations', 0);

INSERT INTO enrollments (id, user_id, course_id, source, progress_percent, last_lesson_id, last_activity_at, completed_at, created_at) VALUES
('enr_crs_deep_learning_foundations_demo', 'usr_student', 'crs_deep_learning_foundations', 'free', 46, 'les_deep_learning_foundations_3_3', '2026-10-23T06:30:28.279Z', NULL, '2026-08-24T06:30:28.279Z');

INSERT INTO lesson_progress (user_id, lesson_id, course_id, completed, position_seconds, completed_at, updated_at) VALUES
('usr_student', 'les_deep_learning_foundations_1_1', 'crs_deep_learning_foundations', 1, 0, '2026-09-03T06:30:28.279Z', '2026-09-03T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_1_2', 'crs_deep_learning_foundations', 1, 0, '2026-09-04T06:30:28.279Z', '2026-09-04T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_1_3', 'crs_deep_learning_foundations', 1, 0, '2026-09-05T06:30:28.279Z', '2026-09-05T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_1_4', 'crs_deep_learning_foundations', 1, 0, '2026-09-06T06:30:28.279Z', '2026-09-06T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_1_5', 'crs_deep_learning_foundations', 1, 0, '2026-09-07T06:30:28.279Z', '2026-09-07T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_2_1', 'crs_deep_learning_foundations', 1, 0, '2026-09-08T06:30:28.279Z', '2026-09-08T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_2_2', 'crs_deep_learning_foundations', 1, 0, '2026-09-09T06:30:28.279Z', '2026-09-09T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_2_3', 'crs_deep_learning_foundations', 1, 0, '2026-09-10T06:30:28.279Z', '2026-09-10T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_2_4', 'crs_deep_learning_foundations', 1, 0, '2026-09-11T06:30:28.279Z', '2026-09-11T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_2_5', 'crs_deep_learning_foundations', 1, 0, '2026-09-12T06:30:28.279Z', '2026-09-12T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_3_1', 'crs_deep_learning_foundations', 1, 0, '2026-09-13T06:30:28.279Z', '2026-09-13T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_3_2', 'crs_deep_learning_foundations', 1, 0, '2026-09-14T06:30:28.279Z', '2026-09-14T06:30:28.279Z');

INSERT INTO exercise_progress (user_id, lesson_id, cell_id, code, passed, attempts, solved_at, updated_at) VALUES
('usr_student', 'les_deep_learning_foundations_1_1', 'dot-score', 'def score(x, w, b):
    return np.dot(w, x) + b', 1, 2, '2026-09-03T06:30:28.279Z', '2026-09-03T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_1_1', 'transpose-weights', '# Two inputs, three outputs. The weight matrix must have shape (2, 3).
W = np.ones((2, 3))
x = np.array([1.0, 2.0])
out = x @ W
print("output shape:", out.shape)', 1, 2, '2026-09-03T06:30:28.279Z', '2026-09-03T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_1_2', 'batch-scores', 'def batch_scores(X, w, b):
    return X @ w + b', 1, 2, '2026-09-04T06:30:28.279Z', '2026-09-04T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_1_2', 'threshold-labels', 'def predict_labels(X, w, b):
    return (X @ w + b > 0).astype(int)', 1, 2, '2026-09-04T06:30:28.279Z', '2026-09-04T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_1_2', 'wrong-order', '# Scores for a batch of 4 examples with 2 features each.
X = np.array([[1.0, 2.0], [0.0, 1.0], [3.0, -1.0], [-2.0, 0.5]])
w = np.array([0.5, -1.0])
b = 0.25
scores = X @ w + b
print("scores:", scores)', 1, 2, '2026-09-04T06:30:28.279Z', '2026-09-04T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_1_3', 'relu-forward', 'def relu(z):
    return np.maximum(0, z)', 1, 2, '2026-09-05T06:30:28.279Z', '2026-09-05T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_1_3', 'relu-derivative', 'def relu_grad(z):
    return (z > 0).astype(float)', 1, 2, '2026-09-05T06:30:28.279Z', '2026-09-05T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_1_3', 'tanh-derivative', '# The derivative of tanh(z) is 1 - tanh(z)^2.
z = np.array([0.0, 1.0, -2.0])
t = np.tanh(z)
dtanh = 1 - t ** 2
print("tanh'':", dtanh)', 1, 2, '2026-09-05T06:30:28.279Z', '2026-09-05T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_1_4', 'dense-layer', 'def dense(X, W, b):
    return X @ W + b', 1, 2, '2026-09-06T06:30:28.279Z', '2026-09-06T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_1_4', 'two-layer', 'def forward(X, W1, b1, W2, b2):
    H = np.maximum(0, X @ W1 + b1)
    return H @ W2 + b2', 1, 2, '2026-09-06T06:30:28.279Z', '2026-09-06T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_1_4', 'broadcast-bias', 'X = np.array([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])     # 3 examples
W = np.array([[0.1, 0.2, 0.3], [0.4, 0.5, 0.6]])        # 2 inputs, 3 outputs
b = np.array([1.0, 2.0, 3.0])                           # one bias per output

Z = X @ W
Z_bad = Z + b
print("shape:", Z_bad.shape)
print(Z_bad)', 1, 2, '2026-09-06T06:30:28.279Z', '2026-09-06T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_1_5', 'mse-loss', 'def mse(y_pred, y_true):
    return np.mean((y_pred - y_true) ** 2)', 1, 2, '2026-09-07T06:30:28.279Z', '2026-09-07T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_1_5', 'bce-loss', 'def bce(p, y):
    p = np.clip(p, 1e-12, 1 - 1e-12)
    return -np.mean(y * np.log(p) + (1 - y) * np.log(1 - p))', 1, 2, '2026-09-07T06:30:28.279Z', '2026-09-07T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_1_5', 'stable-softmax', 'def stable_softmax(Z):
    shifted = Z - Z.max(axis=1, keepdims=True)
    e = np.exp(shifted)
    return e / e.sum(axis=1, keepdims=True)', 1, 2, '2026-09-07T06:30:28.279Z', '2026-09-07T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_1_5', 'softmax-axis', 'logits = np.array([[2.0, 1.0, 0.1], [0.5, 2.5, 0.3]])   # 2 examples, 3 classes
e = np.exp(logits - logits.max(axis=1, keepdims=True))
probs = e / e.sum(axis=1, keepdims=True)
print("probabilities:")
print(np.round(probs, 3))
print("row sums:", np.round(probs.sum(axis=1), 3))', 1, 2, '2026-09-07T06:30:28.279Z', '2026-09-07T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_2_1', 'linear-gradient', 'def mse_grads(X, y, w, b):
    residual = X @ w + b - y
    n = len(y)
    dw = 2 / n * (X.T @ residual)
    db = 2 / n * residual.sum()
    return dw, db', 1, 2, '2026-09-08T06:30:28.279Z', '2026-09-08T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_2_1', 'gd-step', 'def gradient_step(w, b, dw, db, lr):
    return w - lr * dw, b - lr * db', 1, 2, '2026-09-08T06:30:28.279Z', '2026-09-08T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_2_1', 'sign-update', 'w = np.array([0.0])
b = 0.0
dw = np.array([2.0])    # the gradient says the loss rises as w grows
db = 1.0
lr = 0.1

w = w - lr * dw         # move against the gradient
b = b - lr * db
print("w:", w, "b:", b)', 1, 2, '2026-09-08T06:30:28.279Z', '2026-09-08T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_2_2', 'graph-grads', 'def grads(a, b, c):
    e = a * b
    d = e + c
    df_dd = 2 * d
    return df_dd * b, df_dd * a, df_dd', 1, 2, '2026-09-09T06:30:28.279Z', '2026-09-09T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_2_2', 'shared-gradient', 'def shared_grad(x):
    return 2 * x + 3', 1, 2, '2026-09-09T06:30:28.279Z', '2026-09-09T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_2_2', 'upstream-gradient', 'a, b, c = 2.0, -3.0, 10.0
e = a * b
d = e + c
f = d ** 2
upstream = 0.5
df_dd = upstream * 2 * d
da = df_dd * b
print("df/da seen by the optimizer:", da)', 1, 2, '2026-09-09T06:30:28.279Z', '2026-09-09T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_2_3', 'value-mul', 'class Value:
    def __init__(self, data, parents=()):
        self.data = float(data)
        self.grad = 0.0
        self._backward = lambda: None
        self._parents = parents

    def __add__(self, other):
        other = other if isinstance(other, Value) else Value(other)
        out = Value(self.data + other.data, (self, other))
        def _backward():
            self.grad += out.grad
            other.grad += out.grad
        out._backward = _backward
        return out

    def __mul__(self, other):
        other = other if isinstance(other, Value) else Value(other)
        out = Value(self.data * other.data, (self, other))
        def _backward():
            self.grad += other.data * out.grad
            other.grad += self.data * out.grad
        out._backward = _backward
        return out

    __radd__ = __add__
    __rmul__ = __mul__', 1, 2, '2026-09-10T06:30:28.279Z', '2026-09-10T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_2_3', 'value-backward', 'class Value:
    def __init__(self, data, parents=()):
        self.data = float(data)
        self.grad = 0.0
        self._backward = lambda: None
        self._parents = parents

    def __add__(self, other):
        other = other if isinstance(other, Value) else Value(other)
        out = Value(self.data + other.data, (self, other))
        def _backward():
            self.grad += out.grad
            other.grad += out.grad
        out._backward = _backward
        return out

    def __mul__(self, other):
        other = other if isinstance(other, Value) else Value(other)
        out = Value(self.data * other.data, (self, other))
        def _backward():
            self.grad += other.data * out.grad
            other.grad += self.data * out.grad
        out._backward = _backward
        return out

    def backward(self):
        order, seen = [], set()
        def build(v):
            if v not in seen:
                seen.add(v)
                for p in v._parents:
                    build(p)
                order.append(v)
        build(self)
        self.grad = 1.0
        for v in reversed(order):
            v._backward()

    __radd__ = __add__
    __rmul__ = __mul__', 1, 2, '2026-09-10T06:30:28.279Z', '2026-09-10T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_2_3', 'assign-not-add', 'class Value:
    def __init__(self, data):
        self.data = float(data)
        self.grad = 0.0
        self._backward = lambda: None
        self._parents = ()

    def __mul__(self, other):
        out = Value(self.data * other.data)
        def _backward():
            self.grad += other.data * out.grad
            other.grad += self.data * out.grad
        out._backward = _backward
        out._parents = (self, other)
        return out

    def backward(self):
        order, seen = [], set()
        def build(v):
            if v not in seen:
                seen.add(v)
                for p in v._parents:
                    build(p)
                order.append(v)
        build(self)
        self.grad = 1.0
        for v in reversed(order):
            v._backward()

a = Value(3.0)
y = a * a           # y = a², so dy/da = 2a = 6
y.backward()
print("dy/da =", a.grad, "(expected 6.0)")', 1, 2, '2026-09-10T06:30:28.279Z', '2026-09-10T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_2_4', 'dense-backward', 'def dense_backward(X, W, dZ):
    dX = dZ @ W.T
    dW = X.T @ dZ
    db = dZ.sum(axis=0)
    return dX, dW, db', 1, 2, '2026-09-11T06:30:28.279Z', '2026-09-11T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_2_4', 'relu-backward', 'def relu_backward(dA, Z):
    return dA * (Z > 0)', 1, 2, '2026-09-11T06:30:28.279Z', '2026-09-11T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_2_4', 'transpose-dw', 'rng_d = np.random.default_rng(2)
X = rng_d.normal(size=(6, 3))       # 6 examples, 3 inputs
dZ = rng_d.normal(size=(6, 2))      # 6 examples, 2 outputs
W = rng_d.normal(size=(3, 2))       # the weights have shape (3, 2)

dW = X.T @ dZ                        # the weight gradient must match W''s shape
print("dW shape:", dW.shape, "| W shape:", W.shape)', 1, 2, '2026-09-11T06:30:28.279Z', '2026-09-11T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_3_1', 'output-grad', 'def output_grad(P, Y):
    return (P - Y) / P.shape[0]', 1, 2, '2026-09-13T06:30:28.279Z', '2026-09-13T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_3_1', 'hidden-grad', 'def hidden_grad(dZ2, W2, A1):
    return (dZ2 @ W2.T) * (1 - A1 ** 2)', 1, 2, '2026-09-13T06:30:28.279Z', '2026-09-13T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_3_1', 'accuracy', 'def accuracy(P, Y):
    return float(np.mean((P > 0.5) == Y))', 1, 2, '2026-09-13T06:30:28.279Z', '2026-09-13T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_3_1', 'output-sign', 'P = np.array([[0.8], [0.2]])
Y = np.array([[1.0], [0.0]])
n = P.shape[0]
dZ2 = (P - Y) / n
print("dZ2:", dZ2.ravel())', 1, 2, '2026-09-13T06:30:28.279Z', '2026-09-13T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_3_2', 'momentum-step', 'def momentum_step(w, v, grad, lr, beta):
    v_new = beta * v + grad
    return w - lr * v_new, v_new', 1, 2, '2026-09-14T06:30:28.279Z', '2026-09-14T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_3_2', 'adam-step', 'def adam_step(w, m, v, g, t, lr, b1, b2, eps):
    m_new = b1 * m + (1 - b1) * g
    v_new = b2 * v + (1 - b2) * g ** 2
    m_hat = m_new / (1 - b1 ** t)
    v_hat = v_new / (1 - b2 ** t)
    return w - lr * m_hat / (np.sqrt(v_hat) + eps), m_new, v_new', 1, 2, '2026-09-14T06:30:28.279Z', '2026-09-14T06:30:28.279Z'),
('usr_student', 'les_deep_learning_foundations_3_2', 'adam-bias', 'def adam_update(w, m, v, g, t, lr=0.1, b1=0.9, b2=0.999, eps=1e-8):
    m = b1 * m + (1 - b1) * g
    v = b2 * v + (1 - b2) * g ** 2
    m_hat = m / (1 - b1 ** t)
    v_hat = v / (1 - b2 ** t)
    return w - lr * m_hat / (np.sqrt(v_hat) + eps), m, v

w, m, v = adam_update(np.array([1.0]), np.zeros(1), np.zeros(1), np.array([0.5]), t=1)
print("w after the first step:", np.round(w, 4), "(expected 0.9)")', 1, 2, '2026-09-14T06:30:28.279Z', '2026-09-14T06:30:28.279Z');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_deep_learning_foundations_1', 'usr_seed00001r', 'crs_deep_learning_foundations', 4, 'Helped me land an ML role', 'I was a backend engineer trying to move into ML. This course gave me the vocabulary and the hands-on confidence to pass technical interviews. Highly recommended.', '2026-07-28T08:30:28.279Z', '2026-07-28T08:30:28.279Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001r');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_deep_learning_foundations_2', 'usr_seed000025', 'crs_deep_learning_foundations', 5, 'Exceptional production quality', 'Beautifully structured. The quizzes caught gaps in my understanding and the AI tutor was surprisingly helpful when I got stuck on the harder sections.', '2026-10-23T02:30:28.279Z', '2026-10-23T02:30:28.279Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000025');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_deep_learning_foundations_3', 'usr_seed00002v', 'crs_deep_learning_foundations', 5, 'Worth every minute', 'Clear, well-paced and incredibly practical. The projects were challenging in the right way, and I used what I learned at work within a week of finishing.', '2026-09-25T00:30:28.279Z', '2026-09-25T00:30:28.279Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002v');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_deep_learning_foundations_4', 'usr_seed000034', 'crs_deep_learning_foundations', 5, 'Finally clicked', 'I''d tried learning this from scattered blog posts and papers. Having a single coherent narrative with good visuals made it click. The capstone tied everything together.', '2026-08-14T20:30:28.279Z', '2026-08-14T20:30:28.279Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000034');

UPDATE courses SET rating_avg = coalesce((SELECT avg(rating) FROM reviews WHERE course_id = 'crs_deep_learning_foundations'), 0), rating_count = (SELECT count(*) FROM reviews WHERE course_id = 'crs_deep_learning_foundations') WHERE id = 'crs_deep_learning_foundations';
