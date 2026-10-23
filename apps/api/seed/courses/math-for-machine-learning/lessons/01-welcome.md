Welcome to **Mathematics for Machine Learning**. Every model you will ever train is built from three ideas: **vectors and matrices** describe your data, **calculus** tells a model how to improve, and **probability** tells it how confident to be. This course teaches all three the way working engineers use them: geometrically, with pictures, and in NumPy code you run yourself.

You won't just read formulas. Every formula in this course has a live Python cell next to it, and every concept ends in a machine-learning use you can point to.

> **How to use this lesson:** read a little, run a little. Every grey box below is code you can edit and run.

## Run your first cell

Click **Run** on the cell below, or click inside it and press **Shift + Enter**.

```python run
import numpy as np

v = np.array([3.0, 4.0])
print("Hello from linear algebra! v =", v)
print("its length is", np.sqrt(v @ v))
```

Two things happened. `print` wrote text to the output, and the code used `numpy`, which is already imported as `np` in every cell. Writing `import numpy as np` yourself is still a good habit, because real scripts need it.

## Cells share memory, like a notebook

Variables you create in one cell are available in the cells below it, as long as you have run the earlier cell first.

```python run
weights = np.array([0.5, -1.0, 2.0])
features = np.array([4.0, 1.0, 0.5])
print("stored", weights.size, "weights and", features.size, "features")
```

```python run
# Uses `weights` and `features` from the cell above
prediction = weights @ features
print("prediction:", prediction)
prediction
```

If you see a `NameError`, run the cell above first. The **Run all** button at the top runs everything in order, **Restart** wipes memory, and **Variables** shows every variable with its shape and type.

## Errors are part of learning

Here is an error on purpose. Run it:

```python run error
a = np.array([1.0, 2.0, 3.0])
b = np.array([1.0, 2.0])

a + b
```

The error card highlights the failing line and gives a plain-language tip. Shape mismatches like this one are the most common problem in this course. You will learn to read them quickly, and you will see why they are a useful signal rather than a nuisance.

## Predict before you run

Experienced practitioners predict what code will do before running it. A predict cell asks you to choose the answer first; the code then shows you the truth.

```python predict id=predict-shape title="What is the shape?"
v = np.array([3.0, 4.0])
print(v.shape)
--- options
(1, 2)
* (2,)
2
[3. 4.]
--- explain
`v` is a one-dimensional array with two numbers, so its shape is `(2,)`: a single axis of length 2. The shape `(1, 2)` would be a row matrix, which is a different object even though it holds the same numbers.
```

## Challenges: you write the code

Most of your learning happens in **challenges**. Each one has a goal, some starter code and hidden tests. Write your solution, then press **Check** (or **Ctrl + Shift + Enter**).

- Stuck? Click **Hint**. Hints appear one at a time, from a gentle nudge to an almost-answer.
- Still stuck after a few honest minutes? You can reveal the **reference solution**.
- Tests check behaviour on new inputs, so a hard-coded answer will not pass.
- Solving every challenge in a lesson completes that lesson.

```python exercise id=first-challenge title="Your first function"
def add_vectors(a, b):
    # TODO: return the sum of the two vectors a and b
    ...
--- solution
def add_vectors(a, b):
    return np.asarray(a) + np.asarray(b)
--- test
result = add_vectors(np.array([1.0, 2.0]), np.array([10.0, -5.0]))
assert result is not None, "Replace the `...` in `add_vectors` with code that returns the sum."
assert np.allclose(result, [11.0, -3.0]), f"add_vectors([1, 2], [10, -5]) should be [11, -3], but it returned {result!r}."
result = add_vectors(np.array([0.5, 0.5, 0.5]), np.array([1.0, 0.0, -2.0]))
assert np.allclose(result, [1.5, 0.5, -1.5]), "Vectors add element by element, for any length."
--- hint
Vectors add position by position. NumPy arrays support `+` directly.
--- hint
`return a + b` works, because `a` and `b` are NumPy arrays.
```

## Toolkit at a glance

| Action | How |
|---|---|
| Run a cell | **Run** or **Shift + Enter** |
| Check a challenge | **Check** or **Ctrl + Shift + Enter** |
| Get a hint | **Hint** |
| See all variables | **Variables** in the top bar |
| Start fresh | **Restart** in the top bar |
| Ask for help | **Explain with Atlas**, or the Q&A tab |

## Recap

- Each lesson mixes explanation with code you can run, change and break.
- Cells share variables in the order you run them; challenges always start fresh.
- Vectors and matrices are arrays with shapes. Reading shapes is half the battle.
- You will check every formula with code, and every code idea with a formula.

**Up next:** vectors, the arrows and data points that every machine-learning model is built on.
