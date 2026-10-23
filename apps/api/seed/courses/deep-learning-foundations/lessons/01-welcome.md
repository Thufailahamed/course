Welcome to **Deep Learning Foundations**. Every system you have heard of, from image recognizers to language models, is built from one simple idea repeated many times: a **neuron** takes numbers in, multiplies them by learned weights, adds a bias, and passes the result through a small non-linear function. Stack enough of those in layers, teach the weights from examples, and you have a deep network.

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
