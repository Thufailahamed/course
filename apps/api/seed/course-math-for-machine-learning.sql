DELETE FROM exercise_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_math_for_machine_learning');

DELETE FROM quiz_attempts WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_math_for_machine_learning');

DELETE FROM notes WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_math_for_machine_learning');

DELETE FROM lesson_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_math_for_machine_learning');

DELETE FROM discussions WHERE course_id = 'crs_math_for_machine_learning';

DELETE FROM certificates WHERE course_id = 'crs_math_for_machine_learning';

DELETE FROM enrollments WHERE course_id = 'crs_math_for_machine_learning';

DELETE FROM reviews WHERE course_id = 'crs_math_for_machine_learning';

DELETE FROM wishlist WHERE course_id = 'crs_math_for_machine_learning';

DELETE FROM path_courses WHERE course_id = 'crs_math_for_machine_learning';

DELETE FROM coupons WHERE course_id = 'crs_math_for_machine_learning';

DELETE FROM lessons WHERE course_id = 'crs_math_for_machine_learning';

DELETE FROM sections WHERE course_id = 'crs_math_for_machine_learning';

UPDATE order_items SET course_id = NULL WHERE course_id = 'crs_math_for_machine_learning';

DELETE FROM courses WHERE id = 'crs_math_for_machine_learning';

INSERT OR IGNORE INTO categories (id, slug, name, description, icon, sort_order) VALUES ('cat_math', 'math', 'Math for AI', 'Linear algebra, calculus, probability and optimization.', 'sigma', 7);

INSERT INTO courses (id, slug, title, subtitle, description, category_id, instructor_id, level, language, price_cents, compare_at_price_cents, currency, thumbnail_key, preview_video_url, accent, status, featured, what_you_learn, requirements, target_audience, tags, duration_minutes, lessons_count, rating_avg, rating_count, students_count, published_at, created_at, updated_at) VALUES
('crs_math_for_machine_learning', 'math-for-machine-learning', 'Mathematics for Machine Learning', 'Linear algebra, calculus and probability — explained visually and coded in NumPy.', 'Machine learning is applied mathematics. Every model you train is built from three ideas: **vectors and matrices** represent data, **calculus** tells a model how to improve, and **probability** tells it how confident to be. This course teaches all three the way they are used in practice: geometrically, visually, and in code you run yourself.

## Learn by doing, not by memorizing

- **Runnable code everywhere.** Every formula is backed by a NumPy cell you can edit, run and break.
- **Visual explanations.** Vectors, transformations, eigen-directions, gradient descent and probability distributions are drawn as plots, not only described in words.
- **Challenges with hidden tests.** You write the NumPy yourself and get checked automatically, with hints when you are stuck.
- **Debug challenges.** You fix the bugs machine-learning engineers actually hit: transposed matrices, silent broadcasting, integer truncation and numerical underflow.
- **Predict-the-output questions** that build intuition before you run a single line.

## What you''ll cover

- **Linear algebra:** vectors, dot products and cosine similarity; matrices as transformations; matrix multiplication.
- **Eigenvalues and structure:** eigenvectors, the singular value decomposition (SVD) and principal component analysis (PCA).
- **Calculus and optimization:** derivatives, partial derivatives, gradients, gradient descent and the chain rule behind backpropagation.
- **Probability and statistics:** random variables, expectation, variance and covariance, Bayes'' rule and maximum likelihood estimation.

## Why this course?

Every concept ends with a real machine-learning use. Linear regression is a matrix equation. Dimensionality reduction is an eigenvalue problem. Training a neural network is the chain rule, repeated. A spam filter is Bayes'' rule. Once you can read the math, papers and library documentation stop being opaque.

You need high-school algebra and basic Python. You do not need calculus or statistics before you start.', 'cat_math', 'usr_daniel', 'beginner', 'English', 0, NULL, 'USD', NULL, NULL, 48, 'published', 1, '["Think geometrically about vectors, matrices and transformations","Use dot products and matrix multiplication the way machine-learning libraries do","Use eigenvalues, the SVD and PCA to find structure in data","Compute gradients and train a model with gradient descent, including the chain rule behind backpropagation","Reason with probability, expectation, Bayes'' rule and maximum likelihood","Read the math in machine-learning papers and turn it into working NumPy code"]', '["High-school algebra: variables, functions and graphs","Basic Python: variables, lists and functions","A modern browser. Nothing to install; Python and NumPy run in the page"]', '["Anyone intimidated by the math behind machine learning","Engineers who want to refresh linear algebra, calculus and probability","Students preparing for a machine-learning course or role"]', '["Linear Algebra","Calculus","Probability","NumPy"]', 292, 20, 0, 0, 39150, '2025-12-11T06:04:01.623Z', '2025-11-11T06:04:01.623Z', '2026-10-07T06:04:01.623Z');

INSERT INTO sections (id, course_id, title, position, created_at) VALUES
('sec_math_for_machine_learning_1', 'crs_math_for_machine_learning', 'Vectors and Matrices', 0, '2026-06-25T06:04:01.623Z'),
('sec_math_for_machine_learning_2', 'crs_math_for_machine_learning', 'Eigenvalues, SVD and PCA', 1, '2026-06-25T06:04:01.623Z'),
('sec_math_for_machine_learning_3', 'crs_math_for_machine_learning', 'Calculus and Optimization', 2, '2026-06-25T06:04:01.623Z'),
('sec_math_for_machine_learning_4', 'crs_math_for_machine_learning', 'Probability and Statistics', 3, '2026-06-25T06:04:01.623Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_math_for_machine_learning_1_1', 'sec_math_for_machine_learning_1', 'crs_math_for_machine_learning', 'How this course works', 'interactive', 0, 480, NULL, NULL, 'Welcome to **Mathematics for Machine Learning**. Every model you will ever train is built from three ideas: **vectors and matrices** describe your data, **calculus** tells a model how to improve, and **probability** tells it how confident to be. This course teaches all three the way working engineers use them: geometrically, with pictures, and in NumPy code you run yourself.

You won''t just read formulas. Every formula in this course has a live Python cell next to it, and every concept ends in a machine-learning use you can point to.

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
', 1, '[]', '[{"title":"Mathematics for Machine Learning (free book, Deisenroth, Faisal & Ong)","url":"https://mml-book.github.io/"},{"title":"Essence of linear algebra (3Blue1Brown)","url":"https://www.3blue1brown.com/topics/linear-algebra"},{"title":"NumPy linear algebra reference","url":"https://numpy.org/doc/stable/reference/routines.linalg.html"}]', '2026-06-25T06:04:01.623Z', '2026-10-19T06:04:01.623Z'),
('les_math_for_machine_learning_1_2', 'sec_math_for_machine_learning_1', 'crs_math_for_machine_learning', 'Vectors: arrows, lists and data points', 'interactive', 1, 840, NULL, NULL, 'Picture a house listing. It has a size in square feet, a number of bedrooms and a year built. Write those three numbers in order and you have a **vector**: `[1850, 3, 1998]`. Every row of a machine-learning dataset is one such vector, and every model is a function that takes vectors in and gives numbers out. So the first skill to build is simply knowing what a vector is, how to add and scale one, and how to see it.

By the end of this lesson you will be able to create vectors in NumPy, read their shapes, draw them as arrows, and build any point in a plane out of two simple directions.

## A vector is a list of numbers with a shape

A vector with three numbers is a one-dimensional NumPy array. Its **shape** is `(3,)`, meaning a single axis of length three.

```python run
import numpy as np

house = np.array([1850.0, 3.0, 1998.0])
print("values:", house)
print("shape:", house.shape, "| dimensions:", house.ndim)
print("number of features:", house.size)
```

> **Tip:** use floats (`1850.0`, not `1850`) for physical measurements. Integer arrays are a common source of bugs later, and you will meet one in a debug challenge below.

## Vectors as arrows

Geometrically, a two-number vector such as `(3, 1)` is an **arrow** from the origin to the point `(3, 1)`. Adding two vectors means placing the tail of one at the tip of the other. The plot below draws that rule.

```python run
import matplotlib.pyplot as plt

u = np.array([3.0, 1.0])
v = np.array([1.0, 2.0])

fig, ax = plt.subplots()
ax.quiver(0, 0, u[0], u[1], angles="xy", scale_units="xy", scale=1, color="tab:blue", label="u")
ax.quiver(0, 0, v[0], v[1], angles="xy", scale_units="xy", scale=1, color="tab:orange", label="v")
ax.quiver(u[0], u[1], v[0], v[1], angles="xy", scale_units="xy", scale=1, color="tab:orange", alpha=0.4)
ax.quiver(0, 0, (u + v)[0], (u + v)[1], angles="xy", scale_units="xy", scale=1, color="tab:green", label="u + v")
ax.set_xlim(-0.5, 5); ax.set_ylim(-0.5, 4); ax.set_aspect("equal")
ax.grid(alpha=0.3); ax.legend(); ax.set_title("Adding vectors: tail to tip")
plt.show()
```

The faded orange arrow is `v` starting from the tip of `u`. It lands exactly on the green arrow, `u + v`.

## Adding and scaling

Addition and scalar multiplication work **element by element**. There is no special rule to memorize; the arithmetic is the geometry.

```python run
print("u + v   =", u + v)
print("2 * u   =", 2 * u)
print("-v      =", -v)
print("u - v   =", u - v)
```

Multiplying by 2 doubles the arrow''s length and keeps its direction. Multiplying by -1 flips it.

## Linear combinations: the core idea

A **linear combination** of vectors is a weighted sum: $a\,u + b\,v$, where $a$ and $b$ are numbers. Changing the weights moves you around the plane. Every point you can reach by mixing two directions is a linear combination of them.

```python run
for a, b in [(1, 0), (0, 1), (2, -1), (0.5, 0.5)]:
    point = a * u + b * v
    print(f"a = {a:>4}, b = {b:>4}  ->  {point}")
```

This idea runs through all of machine learning. A neuron computes a weighted sum of its inputs, and a linear model predicts with a weighted sum of its features. The weights are what training adjusts.

> **In the wild:** NumPy''s `np.dot` and the `@` operator, which you''ll meet in the next lesson, are simply efficient ways of computing these weighted sums.

## A dataset is a stack of vectors

In practice you rarely handle one vector. You handle a **matrix** whose rows are vectors, one row per sample. Here are three houses with three features each.

```python run
houses = np.array([
    [1850.0, 3.0, 1998.0],
    [1200.0, 2.0, 1975.0],
    [2400.0, 4.0, 2015.0],
])
print("dataset shape (samples, features):", houses.shape)
print("first house:", houses[0])
print("last house''s bedrooms:", houses[-1, 1])
```

> **Pitfall:** the features are on very different scales. Square feet are in the thousands and bedrooms in single digits. Many algorithms behave badly when one feature dominates by size alone, and you will fix that with standardization later in the course.

## Challenges

```python exercise id=midpoint title="Find the midpoint"
# TODO: `midpoint(p, q)` should return the point halfway between points p and q.
def midpoint(p, q):
    ...
--- solution
def midpoint(p, q):
    return (np.asarray(p) + np.asarray(q)) / 2
--- test
result = midpoint(np.array([1.0, 7.0]), np.array([5.0, 3.0]))
assert result is not None, "Replace the `...` in `midpoint` with code that returns the midpoint."
assert np.allclose(result, [3.0, 5.0]), f"The midpoint of (1, 7) and (5, 3) is (3, 5), but midpoint returned {result!r}."
result = midpoint(np.array([-2.0, 4.0, 1.0]), np.array([6.0, 0.0, 9.0]))
assert np.allclose(result, [2.0, 2.0, 5.0]), "The midpoint must work for points in any dimension."
--- hint
The midpoint is the average of the two points, coordinate by coordinate.
--- hint
Add the points, then divide by 2: `(p + q) / 2`.
```

```python exercise id=basis-point title="Build a point from two directions"
e1 = np.array([2.0, 0.0])
e2 = np.array([1.0, 3.0])

# TODO: `point_from_basis(alpha, beta)` should return alpha * e1 + beta * e2.
def point_from_basis(alpha, beta):
    ...
--- solution
e1 = np.array([2.0, 0.0])
e2 = np.array([1.0, 3.0])

def point_from_basis(alpha, beta):
    return alpha * e1 + beta * e2
--- test
result = point_from_basis(1, 0)
assert result is not None, "Replace the `...` in `point_from_basis` with code that returns the point."
assert np.allclose(result, [2.0, 0.0]), f"point_from_basis(1, 0) should be e1 = (2, 0), but it returned {result!r}."
assert np.allclose(point_from_basis(0, 1), [1.0, 3.0]), "point_from_basis(0, 1) should be e2 = (1, 3)."
assert np.allclose(point_from_basis(2, -1), [3.0, -3.0]), "point_from_basis(2, -1) should be 2 * e1 - e2 = (3, -3)."
--- hint
A linear combination multiplies each direction by its weight and adds the results: `alpha * e1 + beta * e2`.
--- hint
NumPy broadcasts a scalar across an array, so `alpha * e1` scales every element of `e1`.
```

```python debug int-truncation id=int-scale title="Scaling a velocity"
# Scale the velocity by one half, then add a small downward push.
velocity = np.array([4, 10, -6])
velocity *= 0.5
velocity += np.array([0.0, -1.5, 0.0])
print(velocity)
--- solution
# Scale the velocity by one half, then add a small downward push.
velocity = np.array([4.0, 10.0, -6.0])
velocity *= 0.5
velocity += np.array([0.0, -1.5, 0.0])
print(velocity)
--- test
assert velocity.dtype.kind == "f", f"`velocity` should hold decimal numbers, but its dtype is {velocity.dtype}."
assert np.allclose(velocity, [2.0, 3.5, -3.0]), f"After halving and pushing down, velocity should be [2, 3.5, -3], but it is {velocity!r}."
--- hint
Run the cell. The error message names the problem: NumPy won''t store 0.5 in an array of integers.
--- hint
Give the array decimal numbers, for example `4.0` instead of `4`, so that its dtype is `float64`.
```

```python predict id=predict-add title="What does this print?"
a = np.array([1, 2])
b = np.array([10, 20])
print(a + 2 * b)
--- options
[11 22]
* [21 42]
[ 2  4 20 40]
[12 24]
--- explain
`2 * b` is `[20, 40]`, and adding `a` element by element gives `[1 + 20, 2 + 40] = [21, 42]`. The factor 2 scales `b` before the addition, so `a + b` (which would print `[11 22]`) is a different calculation.
```

## Recap

- A vector is an array with a shape. Here, `(3,)` means three numbers in one row.
- Vectors add and scale element by element, which is also how they move as arrows.
- A linear combination $a\,u + b\,v$ reaches every point in the plane spanned by $u$ and $v$.
- A dataset is a matrix: one row per sample, one column per feature.
- Keep numbers as floats when the values are measurements.

**Up next:** the dot product, the operation that turns two vectors into one number and measures their length, their angle and their similarity.
', 1, '[]', '[]', '2026-06-25T06:04:01.623Z', '2026-10-19T06:04:01.623Z'),
('les_math_for_machine_learning_1_3', 'sec_math_for_machine_learning_1', 'crs_math_for_machine_learning', 'Dot products, lengths and angles', 'interactive', 2, 960, NULL, NULL, 'Search engines, recommendation systems and large language models share one habit: they turn things into vectors and then ask how *similar* two vectors are. The main tool for that question is the **dot product**. It takes two vectors and returns a single number that combines their lengths and the angle between them. Once you know it, you can read a linear model, a similarity score or a projection at a glance.

By the end of this lesson you will compute dot products by hand and in NumPy, measure lengths, compute cosine similarity and project one vector onto another.

## The dot product: multiply, then add

For two vectors of the same length, the dot product multiplies matching entries and adds the results.

$$
a \cdot b = \sum_{i=1}^{n} a_i b_i
$$

```python run
import numpy as np

a = np.array([1.0, 2.0, 3.0])
b = np.array([4.0, -5.0, 6.0])

products = a * b
print("pairwise products:", products)
print("sum of products:  ", products.sum())
print("np.dot(a, b):", np.dot(a, b), "| a @ b:", a @ b)
```

Both `np.dot(a, b)` and `a @ b` compute the same thing. The `@` operator is the modern, readable way, and you''ll see it everywhere in machine-learning code.

> **Pitfall:** the dot product needs vectors of the same length. `np.dot` with lengths 3 and 4 raises a `ValueError`. That error is useful: it means you''ve paired up things that don''t belong together.

## The dot product is a weighted sum

Read the dot product as a **weighted sum**: each feature $x_i$ is multiplied by a weight $w_i$. That is exactly how a linear model makes a prediction, with a bias $b$ added at the end.

$$
\hat{y} = w \cdot x + b
$$

```python run
# Features (size in thousands of sq ft, bedrooms, normalized age)
x = np.array([1.85, 3.0, 0.8])
# How much each feature adds to the price, in thousands of dollars
w = np.array([150.0, 10.0, -2.0])
b = 20.0

prediction = w @ x + b
print(f"predicted price: ${prediction:.1f}k")
```

Each weight says how much one unit of a feature is worth. The negative weight on age means older houses are cheaper. Training a linear model is nothing more than finding good values for `w` and `b`.

## Length: the dot product with itself

The dot product of a vector with itself is the sum of its squared entries. Taking the square root gives its **length** (also called the norm), which is Pythagoras'' theorem in any number of dimensions.

$$
\|v\| = \sqrt{v \cdot v}
$$

```python run
v = np.array([3.0, 4.0])
length = np.sqrt(v @ v)
print("length by hand:", length)
print("np.linalg.norm:", np.linalg.norm(v))
```

## Angles and cosine similarity

The dot product also encodes the angle $\theta$ between two vectors:

$$
\cos\theta = \frac{a \cdot b}{\|a\|\,\|b\|}
$$

This ratio, called **cosine similarity**, runs from $-1$ (pointing opposite ways) through $0$ (perpendicular) to $+1$ (pointing the same way). It ignores length, so it compares *direction* only.

```python run
def cosine_similarity(a, b):
    return (a @ b) / (np.linalg.norm(a) * np.linalg.norm(b))

# Toy 3-number "embeddings" of three words (invented numbers for illustration)
king = np.array([0.9, 0.8, 0.1])
queen = np.array([0.85, 0.9, 0.2])
apple = np.array([0.1, 0.05, 0.95])

print("king vs queen:", round(cosine_similarity(king, queen), 3))
print("king vs apple:", round(cosine_similarity(king, apple), 3))
print("king vs 10 x king:", round(cosine_similarity(king, 10 * king), 3))
```

Two words with similar meanings point in similar directions, so their cosine similarity is close to 1. Multiplying a vector by 10 changes its length but not its direction, so its similarity to the original stays exactly 1.

> **In the wild:** embedding search in retrieval-augmented generation ranks documents by cosine similarity to a query, usually on vectors with hundreds or thousands of dimensions.

## Perpendicular vectors

When two vectors are perpendicular, their cosine is 0, so their dot product is 0. This property is called **orthogonality**, and it is one of the most useful facts in this course.

```python run
east = np.array([1.0, 0.0])
north = np.array([0.0, 1.0])
print("east . north =", east @ north)
print("cosine similarity:", cosine_similarity(east, north))
```

## Projection: how much of one vector lies along another

The **projection** of $b$ onto $a$ is the part of $b$ that points in $a$''s direction. Its length is the dot product divided by $\|a\|$, and as a vector it is:

$$
\operatorname{proj}_a(b) = \frac{a \cdot b}{a \cdot a}\, a
$$

```python run
a = np.array([4.0, 0.0])
b = np.array([3.0, 5.0])

coef = (a @ b) / (a @ a)
projection = coef * a
print("coefficient:", coef)
print("projection of b onto a:", projection)
print("leftover part (perpendicular to a):", b - projection)
```

Projection is the central idea of PCA, which you''ll build from scratch later. Every "best approximation" in linear algebra is a projection in disguise.

## Challenges

```python exercise id=cosine title="Cosine similarity from scratch"
# TODO: `cosine(a, b)` should return the cosine of the angle between a and b.
def cosine(a, b):
    ...
--- solution
def cosine(a, b):
    a = np.asarray(a, dtype=float)
    b = np.asarray(b, dtype=float)
    return (a @ b) / (np.linalg.norm(a) * np.linalg.norm(b))
--- test
result = cosine(np.array([1.0, 0.0]), np.array([1.0, 1.0]))
assert result is not None, "Replace the `...` in `cosine` with code that returns the cosine similarity."
assert np.isclose(result, 1 / np.sqrt(2)), f"cosine([1, 0], [1, 1]) should be 1/sqrt(2) ≈ 0.707, but it returned {result!r}."
assert np.isclose(cosine(np.array([3.0, 4.0]), np.array([4.0, -3.0])), 0.0), "Perpendicular vectors have cosine 0."
assert np.isclose(cosine(np.array([2.0, 0.0]), np.array([-5.0, 0.0])), -1.0), "Opposite directions have cosine -1."
assert np.isclose(cosine(np.array([1.0, 2.0, 3.0]), np.array([2.0, 4.0, 6.0])), 1.0), "Only direction matters, so scaling a vector should not change the cosine."
--- hint
Cosine similarity is the dot product divided by the product of the two lengths. `np.linalg.norm` gives a length.
--- hint
`(a @ b) / (np.linalg.norm(a) * np.linalg.norm(b))` is the whole formula.
```

```python exercise id=project title="Project one vector onto another"
# TODO: `project(b, onto=a)` should return the projection of b onto a, as a vector.
def project(b, onto):
    ...
--- solution
def project(b, onto):
    b = np.asarray(b, dtype=float)
    onto = np.asarray(onto, dtype=float)
    return ((onto @ b) / (onto @ onto)) * onto
--- test
result = project(np.array([3.0, 5.0]), onto=np.array([4.0, 0.0]))
assert result is not None, "Replace the `...` in `project` with code that returns the projection."
assert np.allclose(result, [3.0, 0.0]), f"Projecting (3, 5) onto (4, 0) should give (3, 0), but it returned {result!r}."
assert np.allclose(project(np.array([2.0, 0.0]), onto=np.array([1.0, 1.0])), [1.0, 1.0]), "Projecting (2, 0) onto (1, 1) should give (1, 1)."
assert np.allclose(project(np.array([1.0, 2.0, 3.0]), onto=np.array([0.0, 0.0, 2.0])), [0.0, 0.0, 3.0]), "Projections also work in three dimensions."
--- hint
The formula is `(a · b) / (a · a)` times `a`. The first dot product uses `onto` and `b`.
--- hint
`coefficient = (onto @ b) / (onto @ onto)`, then return `coefficient * onto`.
```

```python debug squared-length id=squared-length title="The length is not 5"
def vector_length(v):
    # The length of v is the square root of v · v
    return np.dot(v, v)

print("length of [3, 4]:", vector_length(np.array([3.0, 4.0])))
--- solution
def vector_length(v):
    # The length of v is the square root of v · v
    return np.sqrt(np.dot(v, v))

print("length of [3, 4]:", vector_length(np.array([3.0, 4.0])))
--- test
assert np.isclose(vector_length(np.array([3.0, 4.0])), 5.0), f"The length of [3, 4] is 5, but vector_length returned {vector_length(np.array([3.0, 4.0]))!r}."
assert np.isclose(vector_length(np.array([1.0, 2.0, 2.0])), 3.0), "The length of [1, 2, 2] is 3."
--- hint
Run the cell and compare the printed value with the length you know: [3, 4] has length 5, and 25 is 5 squared.
--- hint
`np.dot(v, v)` gives the *squared* length. The length itself is the square root of that.
```

```python predict id=predict-dot title="What does this print?"
print(np.dot([1, 2, 3], [4, 5, 6]))
--- options
* 32
6
15
(4, 10, 18)
--- explain
`1*4 + 2*5 + 3*6 = 4 + 10 + 18 = 32`. The dot product multiplies matching pairs and adds them up, so it returns one number. The option `(4, 10, 18)` is the element-wise product, which is a different operation.
```

## Recap

- The dot product $a \cdot b$ multiplies matching entries and sums them. It returns a single number.
- A linear prediction is a dot product of weights and features, plus a bias.
- The length of $v$ is $\sqrt{v \cdot v}$.
- Cosine similarity compares direction, ignoring length. Perpendicular vectors have cosine 0.
- A projection keeps the part of one vector that lies along another.

**Up next:** matrices. A matrix is a stack of vectors, and it is also a machine that transforms every vector it touches.
', 0, '[]', '[]', '2026-06-25T06:04:01.623Z', '2026-10-19T06:04:01.623Z'),
('les_math_for_machine_learning_1_4', 'sec_math_for_machine_learning_1', 'crs_math_for_machine_learning', 'Matrices as transformations', 'interactive', 3, 1080, NULL, NULL, 'Every layer of a neural network starts with a matrix multiplication. Every image filter, every camera projection and every 3D rotation in a game is one too. A matrix is more than a table of numbers: it is a **function that moves vectors**. Feed it a vector and it returns a new vector, usually rotated, stretched or squashed.

By the end of this lesson you will read a matrix as a transformation, predict what it does to a shape by looking at its columns, build rotations and shears, and use the determinant to measure how much a transformation changes area.

## A matrix acts on a vector

Multiply a matrix by a vector with `@`. Each output entry is the dot product of one row of the matrix with the vector.

```python run
import numpy as np

A = np.array([[2.0, 0.0],
              [0.0, 0.5]])
x = np.array([3.0, 4.0])

print("A @ x =", A @ x)
```

This matrix stretches the x-axis by 2 and squashes the y-axis by half. The point $(3, 4)$ becomes $(6, 2)$.

> **Pitfall:** the vector must match the matrix''s column count. A $2 \times 2$ matrix acts on vectors of length 2, and the result also has length 2. A $3 \times 2$ matrix takes length-2 inputs and returns length-3 outputs.

## The columns tell you where the axes go

Here is the most useful fact about a matrix. The standard basis vectors are $e_1 = (1, 0)$ and $e_2 = (0, 1)$. Multiplying by them picks out the **columns** of the matrix. So the columns are exactly where the basis vectors land.

```python run
A = np.array([[1.0, 2.0],
              [3.0, 4.0]])
e1 = np.array([1.0, 0.0])
e2 = np.array([0.0, 1.0])

print("A @ e1 =", A @ e1, "  <- the first column of A")
print("A @ e2 =", A @ e2, "  <- the second column of A")
```

Once you know where the two axes go, you know where every point goes, because any point is a combination of $e_1$ and $e_2$.

## Rotations, stretches and shears

Some transformations have famous shapes. A **rotation** by angle $\theta$ counterclockwise is

$$
R(\theta) = \begin{bmatrix} \cos\theta & -\sin\theta \\ \sin\theta & \cos\theta \end{bmatrix}
$$

The plot below applies a shear to the unit square. A shear slides each horizontal slice sideways while keeping its height, which turns the square into a parallelogram.

```python run
import matplotlib.pyplot as plt

corners = np.array([[0.0, 1.0, 1.0, 0.0, 0.0],
                    [0.0, 0.0, 1.0, 1.0, 0.0]])   # the unit square, one column per corner
shear = np.array([[1.0, 0.6],
                  [0.0, 1.0]])

fig, ax = plt.subplots()
ax.fill(*corners, alpha=0.3, label="before")
ax.fill(*(shear @ corners), alpha=0.6, label="after the shear")
ax.set_aspect("equal"); ax.grid(alpha=0.3); ax.legend()
plt.show()
```

Notice what happened: the corners moved, but the bottom edge stayed where it was. The matrix moved every point, yet left the horizontal axis fixed. Now build a rotation and check where it sends the first axis.

```python run
def rotation(theta):
    c, s = np.cos(theta), np.sin(theta)
    return np.array([[c, -s],
                     [s, c]])

R = rotation(np.pi / 2)      # a quarter turn
print(np.round(R, 3))
print("rotate (1, 0) by 90 degrees:", np.round(R @ np.array([1.0, 0.0]), 3))
```

## Determinant: how much area a matrix changes

The **determinant** of a $2 \times 2$ matrix tells you the factor by which the transformation scales areas. A determinant of 6 means areas grow sixfold. A determinant of 0 means the matrix squashes the plane onto a line, so information is lost and the transformation can''t be undone.

```python run
print("stretch by 2 and 3:", np.linalg.det(np.array([[2.0, 0.0], [0.0, 3.0]])))
print("shear:              ", np.linalg.det(shear))
print("flatten onto x-axis:", np.linalg.det(np.array([[1.0, 0.0], [0.0, 0.0]])))
```

A negative determinant means the transformation flips orientation, like a mirror. Rotations keep area exactly, so their determinant is always 1.

## Shapes: any size can be transformed

A matrix with $m$ rows and $n$ columns maps vectors of length $n$ to vectors of length $m$. Neural networks use this constantly: a layer with 4 inputs and 3 outputs is a $3 \times 4$ weight matrix.

```python run
W = np.ones((3, 4))              # a layer: 4 inputs -> 3 outputs
x = np.array([1.0, 2.0, 3.0, 4.0])

print("input length:", x.shape[0], "-> output length:", (W @ x).shape[0])
W @ x
```

## Challenges

```python exercise id=rotation-matrix title="Build a rotation matrix"
# TODO: `rotation_matrix(theta)` should return the 2 x 2 matrix that rotates
# points counterclockwise by theta radians.
def rotation_matrix(theta):
    ...
--- solution
def rotation_matrix(theta):
    c, s = np.cos(theta), np.sin(theta)
    return np.array([[c, -s], [s, c]])
--- test
result = rotation_matrix(0.3)
assert result is not None, "Replace the `...` in `rotation_matrix` with code that returns a matrix."
assert np.shape(result) == (2, 2), f"A rotation matrix is 2 x 2, but yours has shape {np.shape(result)}."
assert np.allclose(rotation_matrix(np.pi / 2) @ np.array([1.0, 0.0]), [0.0, 1.0]), "Rotating (1, 0) by 90 degrees counterclockwise should give (0, 1)."
assert np.allclose(rotation_matrix(np.pi) @ np.array([2.0, 1.0]), [-2.0, -1.0]), "A half-turn should flip both coordinates."
assert np.allclose(result.T @ result, np.eye(2)), "A rotation keeps lengths, so its transpose times itself should be the identity matrix."
--- hint
Look at the rotation formula above. Each column is where one basis vector lands: (1, 0) goes to (cos θ, sin θ).
--- hint
Use `np.cos` and `np.sin`, and put `-sin` in the top-right corner.
```

```python exercise id=shear-matrix title="Build a horizontal shear"
# TODO: `shear(k)` should return the 2 x 2 matrix that slides each point horizontally
# by k times its height: (x, y) -> (x + k * y, y).
def shear(k):
    ...
--- solution
def shear(k):
    return np.array([[1.0, k],
                     [0.0, 1.0]])
--- test
result = shear(0.5)
assert result is not None, "Replace the `...` in `shear` with code that returns a matrix."
assert np.allclose(shear(0.5) @ np.array([2.0, 4.0]), [4.0, 4.0]), "shear(0.5) should map (2, 4) to (4, 4), since 2 + 0.5 * 4 = 4."
assert np.allclose(shear(-1.0) @ np.array([1.0, 3.0]), [-2.0, 3.0]), "shear(-1) should map (1, 3) to (-2, 3)."
assert np.allclose(shear(2.0) @ np.array([5.0, 0.0]), [5.0, 0.0]), "Points on the x-axis (height 0) should not move."
--- hint
The top row of the matrix does the horizontal change. Which entry multiplies the height `y`?
--- hint
The matrix is `[[1, k], [0, 1]]`. The `k` sits in the top-right corner.
```

```python debug transpose-points id=rotate-points title="Rotate every point"
theta = np.pi / 2
R = np.array([[np.cos(theta), -np.sin(theta)],
              [np.sin(theta), np.cos(theta)]])

# Each row is one point (x, y). Rotate both points.
points = np.array([[1.0, 0.0],
                   [0.0, 1.0]])
rotated = R @ points
print(np.round(rotated, 3))
--- solution
theta = np.pi / 2
R = np.array([[np.cos(theta), -np.sin(theta)],
              [np.sin(theta), np.cos(theta)]])

# Each row is one point (x, y). Rotate both points.
points = np.array([[1.0, 0.0],
                   [0.0, 1.0]])
rotated = points @ R.T
print(np.round(rotated, 3))
--- test
expected = np.array([[0.0, 1.0],
                     [-1.0, 0.0]])
assert np.allclose(rotated, expected, atol=1e-9), f"The point (1, 0) should land on (0, 1) and (0, 1) on (-1, 0). Your rotated points are {np.round(rotated, 3).tolist()}."
--- hint
Look at where the point (1, 0) lands. A quarter turn should send it straight up to (0, 1). Does the printed first row say that?
--- hint
The points are stored as rows, but a matrix transforms column vectors. Transform each row with `points @ R.T`.
```

```python predict id=predict-matvec title="Apply a diagonal matrix"
A = np.array([[1, 0],
              [0, 2]])
print(A @ np.array([3, 5]))
--- options
[3 5]
* [ 3 10]
[ 3  0]
[ 1 10]
--- explain
Row one gives `1*3 + 0*5 = 3`, and row two gives `0*3 + 2*5 = 10`. The matrix keeps the first coordinate and doubles the second.
```

```python predict id=predict-det title="The determinant of a 2 x 2 matrix"
print(round(np.linalg.det(np.array([[1.0, 2.0], [3.0, 4.0]])), 6))
--- options
2.0
* -2.0
10.0
-10.0
--- explain
For a $2 \times 2$ matrix $\begin{bmatrix} a & b \\ c & d \end{bmatrix}$ the determinant is $ad - bc = 1 \cdot 4 - 2 \cdot 3 = -2$. The negative sign tells you this matrix flips orientation.
```

## Recap

- A matrix transforms vectors. Multiply with `@`, one row dotted with the vector at a time.
- The columns of a matrix show where the basis vectors $e_1$ and $e_2$ land.
- Rotations, stretches and shears are matrices with recognizable patterns.
- The determinant is the area scaling factor; zero means information was lost.
- An $m \times n$ matrix maps length-$n$ vectors to length-$m$ vectors. Neural-network layers are exactly this.

**Up next:** matrix multiplication itself. Chaining transformations is just multiplying their matrices, and it''s the operation behind every layer of a network.
', 0, '[]', '[]', '2026-06-25T06:04:01.623Z', '2026-10-19T06:04:01.623Z'),
('les_math_for_machine_learning_1_5', 'sec_math_for_machine_learning_1', 'crs_math_for_machine_learning', 'Matrix multiplication: composing transformations', 'interactive', 4, 1080, NULL, NULL, 'Suppose you rotate a shape and then stretch it. That is two transformations in a row, and the result is one transformation too. The matrix for "do this, then that" is the **product** of the two matrices. Matrix multiplication looks like a strange recipe of rows and columns at first, but it is simply function composition, and it is the workhorse of machine learning: a whole batch of data passes through a neural network as one big matrix product.

By the end of this lesson you will multiply matrices by hand and in code, know why the order matters, use transposes, and write a linear model over a whole dataset in a single line.

## Composition: one transformation after another

Let $S$ stretch the x-axis by 2 and let $R$ rotate by 90 degrees. Applying $S$ first and then $R$ to a vector $x$ gives $R(Sx)$. Matrix multiplication packs that chain into one matrix, $RS$, so that $RS\,x = R(Sx)$.

```python run
import numpy as np

S = np.array([[2.0, 0.0],
              [0.0, 1.0]])      # stretch x by 2
R = np.array([[0.0, -1.0],
              [1.0, 0.0]])      # rotate 90 degrees counterclockwise

x = np.array([1.0, 1.0])
print("stretch, then rotate:", R @ (S @ x))
print("one combined matrix: ", (R @ S) @ x)
```

Both lines print the same vector. The product $RS$ does the whole job in one step, which is why engineers multiply matrices ahead of time when a transformation is applied many times.

## The rule: rows times columns

Entry $(i, j)$ of the product $C = AB$ is the dot product of row $i$ of $A$ with column $j$ of $B$:

$$
C_{ij} = \sum_{k} A_{ik} B_{kj}
$$

The inner sizes must match. An $m \times n$ matrix times an $n \times p$ matrix gives an $m \times p$ matrix.

```python run
A = np.array([[1.0, 2.0, 0.0],
              [0.0, 1.0, 3.0]])     # 2 x 3
B = np.array([[1.0, 0.0],
              [2.0, 1.0],
              [0.0, 4.0]])          # 3 x 2

C = A @ B
print("shapes:", A.shape, "@", B.shape, "->", C.shape)
print(C)
```

Check one entry yourself: row 1 of $A$ is $(1, 2, 0)$ and column 1 of $B$ is $(1, 2, 0)$, so $C_{11} = 1 + 4 + 0 = 5$.

Here is the same computation written as three nested loops. It is slow, but it shows exactly what `@` is doing.

```python run
def matmul_loops(A, B):
    m, n = A.shape
    p = B.shape[1]
    C = np.zeros((m, p))
    for i in range(m):
        for j in range(p):
            C[i, j] = sum(A[i, k] * B[k, j] for k in range(n))
    return C

print("loops agree with @:", np.allclose(matmul_loops(A, B), A @ B))
```

## Order matters

Matrix multiplication is **not commutative**: $AB$ and $BA$ are generally different. Rotating and then stretching is not the same as stretching and then rotating.

```python run
P = np.array([[0.0, -1.0],
              [1.0, 0.0]])          # rotate 90 degrees
S = np.array([[2.0, 0.0],
              [0.0, 1.0]])          # stretch x by 2

print("P @ S =\n", P @ S)
print("S @ P =\n", S @ P)
print("equal?", np.array_equal(P @ S, S @ P))
```

> **Pitfall:** when you read `W @ x` in a formula, the matrix always acts on the right. The rightmost transformation is applied first.

## The transpose: flipping rows and columns

The **transpose** $A^\top$ swaps rows and columns. It shows up constantly, and it obeys a useful rule: $(AB)^\top = B^\top A^\top$. The order reverses.

```python run
X = np.array([[1.0, 2.0, 3.0],
              [4.0, 5.0, 6.0]])
print("X shape:", X.shape, "| X.T shape:", X.T.shape)
print("(AB)^T equals B^T A^T:", np.allclose((A @ B).T, B.T @ A.T))
```

## Machine learning in one product

Take a dataset with $n$ samples and $d$ features, stored as an $n \times d$ matrix $X$. A linear model with weights $w$ (a vector of length $d$) predicts for **every sample at once**:

$$
\hat{y} = X w
$$

A layer of a neural network with $h$ hidden units is the same idea with a weight matrix $W$ of shape $d \times h$: the whole batch flows through as $XW$.

```python run
rng = np.random.default_rng(0)
X = rng.integers(0, 4, size=(5, 3)).astype(float)    # 5 samples, 3 features
W = rng.integers(-1, 2, size=(3, 2)).astype(float)   # 3 features -> 2 hidden units

H = X @ W
print("X:", X.shape, " W:", W.shape, " H:", H.shape)
H
```

One line of code processed five samples through a two-unit layer. A GPU does exactly this, in parallel, on matrices with millions of entries.

## Challenges

```python exercise id=loop-matmul title="Matrix multiplication by loops"
# TODO: `loop_matmul(A, B)` multiplies A (m x n) by B (n x p) using three nested loops.
# Don''t use @ or np.dot.
def loop_matmul(A, B):
    ...
--- solution
def loop_matmul(A, B):
    m, n = A.shape
    p = B.shape[1]
    C = np.zeros((m, p))
    for i in range(m):
        for j in range(p):
            for k in range(n):
                C[i, j] += A[i, k] * B[k, j]
    return C
--- test
rng = np.random.default_rng(1)
A = rng.normal(size=(3, 4))
B = rng.normal(size=(4, 2))
result = loop_matmul(A, B)
assert result is not None, "Replace the `...` in `loop_matmul` with code that returns the product."
assert np.shape(result) == (3, 2), f"The product of a 3 x 4 and a 4 x 2 matrix is 3 x 2, but yours has shape {np.shape(result)}."
assert np.allclose(result, A @ B), "Each entry C[i, j] should be the dot product of row i of A with column j of B."
A2 = rng.normal(size=(2, 5))
B2 = rng.normal(size=(5, 5))
assert np.allclose(loop_matmul(A2, B2), A2 @ B2), "Your function should work for any compatible shapes, not only the example above."
--- hint
Start with `C = np.zeros((m, p))`, then fill each entry `C[i, j]` with a sum over `k`.
--- hint
Inside the innermost loop, add `A[i, k] * B[k, j]` to `C[i, j]`. Three loops: i, j and k.
```

```python exercise id=scale-then-rotate title="Compose two transformations"
# TODO: `scale_then_rotate()` returns the single 2 x 2 matrix that first stretches the
# x-axis by 2 and then rotates 90 degrees counterclockwise.
def scale_then_rotate():
    ...
--- solution
def scale_then_rotate():
    S = np.array([[2.0, 0.0], [0.0, 1.0]])
    R = np.array([[0.0, -1.0], [1.0, 0.0]])
    return R @ S
--- test
M = scale_then_rotate()
assert M is not None, "Replace the `...` in `scale_then_rotate` with code that returns a matrix."
assert np.allclose(M @ np.array([1.0, 0.0]), [0.0, 2.0]), "(1, 0) is first stretched to (2, 0), then rotated to (0, 2)."
assert np.allclose(M @ np.array([0.0, 1.0]), [-1.0, 0.0]), "(0, 1) is unchanged by the stretch, then rotated to (-1, 0)."
assert np.allclose(M @ np.array([1.0, 1.0]), [-1.0, 2.0]), "Check (1, 1) as well: stretch to (2, 1), then rotate to (-1, 2)."
--- hint
Put the rightmost transformation first: the stretch is applied before the rotation, so the rotation matrix goes on the left.
--- hint
`R @ S`, where S is the stretch and R is the rotation.
```

```python debug elementwise-bug id=elementwise-bug title="Scores that look plausible but are wrong"
# X has one row per sample and one column per feature.
# W has one row per feature and one column per output.
X = np.array([[1.0, 2.0],
              [3.0, 4.0]])
W = np.array([[0.5, 1.0],
              [1.0, 0.0]])

scores = X * W
print(scores)
--- solution
# X has one row per sample and one column per feature.
# W has one row per feature and one column per output.
X = np.array([[1.0, 2.0],
              [3.0, 4.0]])
W = np.array([[0.5, 1.0],
              [1.0, 0.0]])

scores = X @ W
print(scores)
--- test
expected = np.array([[2.5, 1.0],
                     [5.5, 3.0]])
assert np.allclose(scores, expected), f"scores should be the matrix product X @ W, which is {expected.tolist()}, but it is {np.round(scores, 3).tolist()}."
--- hint
Check the first entry by hand: row 1 of X is (1, 2) and column 1 of W is (0.5, 1.0). What is their dot product?
--- hint
`*` multiplies matching positions one by one. Matrix multiplication, which combines rows and columns, is `@`.
```

```python predict id=predict-matmul title="Multiply two matrices"
P = np.array([[1, 2],
              [3, 4]])
Q = np.array([[0, 1],
              [1, 0]])
print((P @ Q).tolist())
--- options
[[1, 2], [3, 4]]
* [[2, 1], [4, 3]]
[[0, 1], [1, 0]]
[[3, 2], [1, 4]]
--- explain
Column 1 of Q is (0, 1), so entry (0, 0) is `1*0 + 2*1 = 2`. Column 2 is (1, 0), so entry (0, 1) is `1*1 + 2*0 = 1`. Multiplying by this Q swaps the columns of P.
```

```python predict id=predict-order title="Does order matter?"
A = np.array([[1, 1],
              [0, 1]])
B = np.array([[1, 0],
              [1, 1]])
print(np.array_equal(A @ B, B @ A))
--- options
True
* False
It depends on the shapes
--- explain
`A @ B` is `[[2, 1], [1, 1]]`, while `B @ A` is `[[1, 1], [1, 2]]`. Matrix multiplication is not commutative, so the order of transformations matters.
```

## Recap

- Multiplying matrices composes transformations. $RS\,x$ means "apply $S$, then $R$".
- Entry $(i, j)$ of $AB$ is row $i$ of $A$ dotted with column $j$ of $B$. Inner dimensions must match.
- $AB \neq BA$ in general. The rightmost matrix acts first.
- $(AB)^\top = B^\top A^\top$.
- A whole dataset passes through a linear model or a neural-network layer as one matrix product, $Xw$ or $XW$.

**Up next:** eigenvectors, the special directions that a matrix only stretches, never rotates. They reveal the structure hidden inside a matrix.
', 0, '[]', '[]', '2026-06-25T06:04:01.623Z', '2026-10-19T06:04:01.623Z'),
('les_math_for_machine_learning_1_6', 'sec_math_for_machine_learning_1', 'crs_math_for_machine_learning', 'Checkpoint: vectors and matrices', 'quiz', 5, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"What is the dot product of (2, -1) and (3, 6)?","options":["0","12","-3","6"],"answerIndex":0,"explanation":"2·3 + (-1)·6 = 6 - 6 = 0. The vectors are perpendicular, so their cosine similarity is 0."},{"id":"q2","prompt":"A is a 3 × 2 matrix and B is a 2 × 4 matrix. What is the shape of A @ B?","options":["(2, 2)","(3, 2)","(3, 4)","The product is undefined"],"answerIndex":2,"explanation":"The inner dimensions (2 and 2) match, so the product exists. The outer dimensions give the result shape: (3, 4)."},{"id":"q3","prompt":"What do the columns of a matrix A tell you?","options":["The length of each row","The sum of all entries","Where the standard basis vectors e1 and e2 land after the transformation A","The eigenvalues of A"],"answerIndex":2,"explanation":"A @ e1 is the first column of A, and A @ e2 is the second column. Knowing where the axes go tells you where every point goes."},{"id":"q4","prompt":"Which statement about matrix multiplication is true in general?","options":["AB and BA are always equal","AB and BA are generally different","AB is always the same as the elementwise product A * B","The order of the factors never changes the result of a composed transformation"],"answerIndex":1,"explanation":"Matrix multiplication is not commutative. Rotating then stretching differs from stretching then rotating, so the order of the factors matters."},{"id":"q5","prompt":"Cosine similarity between two non-zero vectors equals 0 exactly when the vectors are…","options":["Identical","Parallel","Perpendicular","Of equal length"],"answerIndex":2,"explanation":"cos θ = 0 means θ = 90°. For vectors, that is the same as a dot product of zero, which is orthogonality."}]', '[]', '2026-06-25T06:04:01.623Z', '2026-10-19T06:04:01.623Z'),
('les_math_for_machine_learning_2_1', 'sec_math_for_machine_learning_2', 'crs_math_for_machine_learning', 'Eigenvectors and eigenvalues', 'interactive', 0, 1080, NULL, NULL, 'Most vectors change direction when a matrix acts on them. A few special vectors don''t: the matrix only stretches or shrinks them. Those are the **eigenvectors**, and the stretch factors are the **eigenvalues**. They are the natural axes of a transformation. Google''s original PageRank was an eigenvector computation. The stability of a training run depends on eigenvalues. And the most important tool for finding structure in data, principal component analysis, is an eigenvalue problem in disguise.

By the end of this lesson you will find eigenpairs with NumPy, check them by hand, understand why symmetric matrices are special, and compute a dominant eigenvector by repeated multiplication.

## Special directions

An eigenvector $v$ of a matrix $A$ satisfies

$$
A v = \lambda v
$$

Multiplying by $A$ changes only the length of $v$, by the factor $\lambda$. Let''s test that on a simple matrix.

```python run
import numpy as np

A = np.array([[2.0, 1.0],
              [1.0, 2.0]])

for v in [np.array([1.0, 1.0]), np.array([1.0, -1.0]), np.array([1.0, 0.0])]:
    print("v =", v, "-> A v =", A @ v)
```

For $v = (1, 1)$, the result $(3, 3)$ is $3v$, so $(1, 1)$ is an eigenvector with eigenvalue 3. For $(1, -1)$, the result is $(1, -1)$ itself, an eigenvalue of 1. The vector $(1, 0)$ is not special: its image $(2, 1)$ points in a new direction.

## Let NumPy find them

`np.linalg.eig` returns all eigenvalues, and the matching eigenvectors as **columns** of a matrix.

```python run
eigenvalues, eigenvectors = np.linalg.eig(A)
print("eigenvalues:", eigenvalues)
print("eigenvectors (one per column):")
print(eigenvectors)

first = eigenvectors[:, 0]
print("A v = lambda v for the first pair?", np.allclose(A @ first, eigenvalues[0] * first))
```

> **Pitfall:** eigenvectors are stored in **columns**, so the first eigenvector is `eigenvectors[:, 0]`, not `eigenvectors[0]`. You will meet this mistake in a debug challenge.

## Symmetric matrices are the well-behaved case

A matrix equal to its own transpose, $A = A^\top$, is called **symmetric**. Symmetric matrices always have real eigenvalues and perpendicular eigenvectors. Use `np.linalg.eigh` for them: it is faster, more accurate and returns the eigenvalues sorted in ascending order.

```python run
S = np.array([[4.0, 2.0],
              [2.0, 4.0]])
values, vectors = np.linalg.eigh(S)
print("eigenvalues (ascending):", values)
print("eigenvectors:", vectors.round(3))
print("perpendicular?", np.isclose(vectors[:, 0] @ vectors[:, 1], 0.0))
```

Covariance matrices, which describe how features vary together, are always symmetric. That is why PCA works so cleanly.

## Eigenvectors are the axes of a transformation

Here is the picture. Apply $A$ to every point on the unit circle and you get an ellipse. The eigenvectors of $A$ point along the ellipse''s axes, and the eigenvalues give how far it stretches along each axis.

```python run
import matplotlib.pyplot as plt

theta = np.linspace(0, 2 * np.pi, 200)
circle = np.vstack([np.cos(theta), np.sin(theta)])
ellipse = A @ circle
vals, vecs = np.linalg.eigh(A)

fig, ax = plt.subplots()
ax.plot(*circle, color="gray", alpha=0.6, label="unit circle")
ax.plot(*ellipse, color="tab:blue", label="after A")
for lam, v in zip(vals, vecs.T):
    ax.arrow(0, 0, *(v * lam), color="tab:red", width=0.03, length_includes_head=True)
ax.set_aspect("equal"); ax.grid(alpha=0.3); ax.legend()
ax.set_title("Red arrows: eigenvectors, scaled by their eigenvalues")
plt.show()
```

The red arrows lie exactly along the long and short axes of the blue ellipse. That is what an eigenvector is: an axis the transformation doesn''t rotate.

## Power iteration: finding the dominant direction

Start with any vector and keep multiplying by $A$, normalizing each time. The vector gradually turns toward the eigenvector with the **largest** eigenvalue (in absolute value). This is called power iteration, and it scales to matrices far too large for a full decomposition.

```python run
def power_iteration(A, steps=50):
    v = np.array([1.0, 0.0])
    for _ in range(steps):
        v = A @ v
        v = v / np.linalg.norm(v)
    eigenvalue = v @ A @ v        # the Rayleigh quotient estimates lambda
    return v, eigenvalue

v, lam = power_iteration(A)
print("dominant direction:", np.round(v, 3), "| eigenvalue estimate:", round(lam, 3))
```

Each multiplication pushes the vector toward the direction the matrix stretches most. After 50 steps it points along $(1, 1)$ and the estimate is 3, matching the eigenvalue we found earlier.

> **In the wild:** PageRank, recommendation systems and spectral clustering all rely on the dominant eigenvector, found by iterations much like this one.

## Challenges

```python exercise id=is-eigenpair title="Check an eigenpair"
# TODO: `is_eigenpair(A, v, lam)` should return True when v is an eigenvector of A
# with eigenvalue lam, and False otherwise.
def is_eigenpair(A, v, lam):
    ...
--- solution
def is_eigenpair(A, v, lam):
    return bool(np.allclose(A @ v, lam * v))
--- test
A = np.array([[2.0, 1.0],
              [1.0, 2.0]])
result = is_eigenpair(A, np.array([1.0, 1.0]), 3.0)
assert result is not None, "Replace the `...` in `is_eigenpair` with code that returns True or False."
assert bool(result) is True, "(1, 1) is an eigenvector of A with eigenvalue 3."
assert bool(is_eigenpair(A, np.array([1.0, 1.0]), 2.0)) is False, "(1, 1) has eigenvalue 3, not 2."
assert bool(is_eigenpair(A, np.array([1.0, 0.0]), 2.0)) is False, "(1, 0) is not an eigenvector of A."
assert bool(is_eigenpair(np.diag([5.0, 2.0]), np.array([0.0, 4.0]), 2.0)) is True, "Check a diagonal matrix as well: (0, 4) should be an eigenvector with eigenvalue 2."
--- hint
An eigenpair satisfies `A v = lam v`. Compute both sides and compare them with `np.allclose`.
--- hint
`return bool(np.allclose(A @ v, lam * v))`.
```

```python exercise id=dominant-eigenvalue title="Estimate the largest eigenvalue"
# TODO: `dominant_eigenvalue(A, steps=100)` should run power iteration starting from
# v = (1, 0) and return the estimated largest eigenvalue of the symmetric matrix A.
def dominant_eigenvalue(A, steps=100):
    ...
--- solution
def dominant_eigenvalue(A, steps=100):
    v = np.array([1.0, 0.0])
    for _ in range(steps):
        v = A @ v
        v = v / np.linalg.norm(v)
    return v @ A @ v
--- test
est = dominant_eigenvalue(np.array([[3.0, 1.0],
                                    [1.0, 3.0]]))
assert est is not None, "Replace the `...` in `dominant_eigenvalue` with code that returns an eigenvalue."
assert np.isclose(est, 4.0, atol=1e-6), f"The largest eigenvalue of [[3, 1], [1, 3]] is 4, but your estimate is {est!r}."
assert np.isclose(dominant_eigenvalue(np.diag([5.0, 1.0])), 5.0, atol=1e-6), "The largest eigenvalue of diag(5, 1) is 5."
assert np.isclose(dominant_eigenvalue(np.array([[2.0, 3.0], [3.0, 2.0]])), 5.0, atol=1e-6), "Check a third matrix: the largest eigenvalue of [[2, 3], [3, 2]] is 5."
--- hint
Repeat `v = A @ v` and then divide `v` by its length, exactly as in the power iteration example above.
--- hint
After the loop, `v @ A @ v` is the eigenvalue estimate.
```

```python debug eigvec-row id=eigvec-row title="Wrong eigenvector"
A = np.array([[4.0, 1.0],
              [2.0, 3.0]])
eigenvalues, eigenvectors = np.linalg.eig(A)

# The eigenvector for the largest eigenvalue
largest = np.argmax(eigenvalues)
v = eigenvectors[largest]

print("v =", v)
print("A @ v =", A @ v, "| 5 * v =", eigenvalues[largest] * v)
--- solution
A = np.array([[4.0, 1.0],
              [2.0, 3.0]])
eigenvalues, eigenvectors = np.linalg.eig(A)

# The eigenvector for the largest eigenvalue
largest = np.argmax(eigenvalues)
v = eigenvectors[:, largest]

print("v =", v)
print("A @ v =", A @ v, "| 5 * v =", eigenvalues[largest] * v)
--- test
assert np.allclose(A @ v, 5.0 * v), f"v should be an eigenvector of A with eigenvalue 5, but A @ v = {np.round(A @ v, 3).tolist()}."
--- hint
Look at the shape of `eigenvectors`. Its eigenvectors are stored as columns, so `eigenvectors[largest]` takes a row.
--- hint
Select a column, with `eigenvectors[:, largest]`.
```

```python predict id=predict-eig title="Eigenvalues of a diagonal matrix"
D = np.diag([5.0, 2.0])
print(np.sort(np.linalg.eigvals(D)))
--- options
[5. 2.]
* [2. 5.]
[10.  4.]
[1. 1.]
--- explain
A diagonal matrix stretches each axis by its diagonal entry, so its eigenvalues are simply 5 and 2 (the eigenvectors are the axes themselves). `np.sort` puts them in ascending order.
```

```python predict id=predict-eigcheck title="Is it an eigenvector?"
A = np.array([[2.0, 1.0],
              [1.0, 2.0]])
v = np.array([1.0, 1.0])
print(np.allclose(A @ v, 3 * v))
--- options
* True
False
It depends on the size of v
--- explain
`A @ v` is `(3, 3)`, which equals `3 * v`. So `(1, 1)` is an eigenvector with eigenvalue 3.
```

## Recap

- An eigenvector satisfies $Av = \lambda v$: the matrix only stretches it, by $\lambda$.
- `np.linalg.eig` returns eigenvalues and eigenvectors, the latter as columns.
- Symmetric matrices have real eigenvalues and perpendicular eigenvectors. Use `np.linalg.eigh`.
- Eigenvectors are the axes of the ellipse that a matrix makes out of a circle.
- Power iteration finds the dominant eigenvector by repeated multiplication and normalization.

**Up next:** the singular value decomposition. It generalizes eigenvectors to any matrix, square or not, and it is the engine behind compression and PCA.
', 0, '[]', '[]', '2026-06-25T06:04:01.623Z', '2026-10-19T06:04:01.623Z'),
('les_math_for_machine_learning_2_2', 'sec_math_for_machine_learning_2', 'crs_math_for_machine_learning', 'The singular value decomposition', 'interactive', 1, 1080, NULL, NULL, 'Eigenvectors only make sense for square matrices, and even then they can be awkward: some matrices have complex eigenvalues, and some cannot be diagonalized at all. The **singular value decomposition** (SVD) has no such problems. Every matrix, of any shape, can be written as a rotation, a stretch along perpendicular axes, and another rotation. This is the most useful factorization in applied linear algebra. It powers image compression, denoising, recommender systems, latent semantic analysis and PCA.

By the end of this lesson you will decompose a matrix with NumPy, rebuild it from its pieces, approximate it with fewer components, and measure how much information each component carries.

## Any matrix: rotate, stretch, rotate

The SVD writes a matrix $A$ as

$$
A = U \Sigma V^\top
$$

where $U$ and $V$ have orthonormal columns (they are rotations or reflections), and $\Sigma$ is diagonal with non-negative entries $\sigma_1 \ge \sigma_2 \ge \cdots$, the **singular values**. In NumPy, `np.linalg.svd` returns $U$, the singular values as a vector, and $V^\top$ (called `Vt`).

```python run
import numpy as np

A = np.array([[2.0, 1.0],
              [0.0, 1.5]])

U, S, Vt = np.linalg.svd(A)
print("singular values:", S.round(3))
print("U:"); print(U.round(3))
print("Vt:"); print(Vt.round(3))

rebuilt = U @ np.diag(S) @ Vt
print("U @ diag(S) @ Vt equals A?", np.allclose(rebuilt, A))
```

The singular values tell you how strongly $A$ stretches space in its most important directions. Sorted from largest to smallest, the first one captures the most.

## Non-square matrices work too

Eigenvectors can''t handle a $5 \times 3$ data matrix. The SVD can. With `full_matrices=False` you get the compact version, where $\Sigma$ has only as many singular values as the smaller dimension.

```python run
rng = np.random.default_rng(0)
X = rng.normal(size=(5, 3))      # 5 samples, 3 features

U, S, Vt = np.linalg.svd(X, full_matrices=False)
print("U:", U.shape, "| S:", S.shape, "| Vt:", Vt.shape)
print("rebuilt correctly?", np.allclose(U @ np.diag(S) @ Vt, X))
```

## Singular values measure energy

Squared singular values add up to the total squared size of the matrix (the Frobenius norm). So $\sigma_i^2 / \sum_j \sigma_j^2$ is the fraction of the matrix''s "energy" that the $i$-th component carries.

```python run
energy = S**2 / np.sum(S**2)
print("share of energy per component:", np.round(energy, 3))
print("cumulative:                   ", np.round(np.cumsum(energy), 3))
```

> **Tip:** the number of nonzero singular values is the **rank** of the matrix: how many independent directions it really uses.

## Low-rank approximation: keep the big stretches

Suppose your data is a simple signal plus noise. The signal has low rank, so most of its information sits in a few singular values. Keeping only the top $k$ components throws away the noise and keeps the signal. This is the idea behind image compression and denoising.

```python run
rng = np.random.default_rng(0)
signal = rng.normal(size=(20, 2)) @ rng.normal(size=(2, 10))    # true rank 2
noisy = signal + 0.1 * rng.normal(size=(20, 10))

U, S, Vt = np.linalg.svd(noisy, full_matrices=False)
for k in [1, 2, 3, 10]:
    approx = (U[:, :k] * S[:k]) @ Vt[:k]
    print(f"{k:>2} components: error against the true signal = {np.linalg.norm(signal - approx):.3f}")
```

The error drops sharply up to rank 2, the true rank of the signal. Past that point it rises again, because each extra component brings noise back in. The Eckart–Young theorem says this truncated SVD is the **best** rank-$k$ approximation possible, in the least-squares sense.

## Charts of the singular values

A plot of the singular values, often called a scree plot, shows where the signal ends and the noise begins. The "elbow" marks the number of components worth keeping.

```python run
import matplotlib.pyplot as plt

fig, ax = plt.subplots()
ax.plot(range(1, len(S) + 1), S, "o-", label="singular values of the noisy matrix")
ax.axvline(2, color="tab:red", ls="--", label="true rank = 2")
ax.set_xlabel("component"); ax.set_ylabel("singular value")
ax.grid(alpha=0.3); ax.legend()
plt.show()
```

## Challenges

```python exercise id=rank-k title="Best rank-k approximation"
# TODO: `rank_k_approximation(A, k)` should return the best rank-k approximation of A,
# built from the top k singular values and vectors.
def rank_k_approximation(A, k):
    ...
--- solution
def rank_k_approximation(A, k):
    U, S, Vt = np.linalg.svd(A, full_matrices=False)
    return (U[:, :k] * S[:k]) @ Vt[:k]
--- test
rng = np.random.default_rng(4)
M = rng.normal(size=(6, 4))
approx = rank_k_approximation(M, 2)
assert approx is not None, "Replace the `...` in `rank_k_approximation` with code that returns a matrix."
assert np.shape(approx) == (6, 4), f"The approximation should have the same shape as A, (6, 4), but it has {np.shape(approx)}."
assert np.linalg.matrix_rank(approx) == 2, "The approximation should have rank exactly 2."
S = np.linalg.svd(M, compute_uv=False)
error = np.linalg.norm(M - approx, "fro")
assert np.isclose(error, np.sqrt(np.sum(S[2:] ** 2)), atol=1e-8), "The error should equal the energy of the discarded singular values."
--- hint
Compute the SVD with `np.linalg.svd(A, full_matrices=False)`, keep the first `k` columns of `U` and entries of `S`, and the first `k` rows of `Vt`.
--- hint
`(U[:, :k] * S[:k]) @ Vt[:k]` builds the approximation in one line.
```

```python exercise id=energy-kept title="How much energy survives?"
# TODO: `energy_kept(S, k)` should return the fraction of the total squared singular value
# energy that is kept by the first k singular values.
def energy_kept(S, k):
    ...
--- solution
def energy_kept(S, k):
    S = np.asarray(S, dtype=float)
    return np.sum(S[:k] ** 2) / np.sum(S ** 2)
--- test
result = energy_kept(np.array([3.0, 2.0, 1.0]), 1)
assert result is not None, "Replace the `...` in `energy_kept` with code that returns a fraction."
assert np.isclose(result, 9 / 14), f"With S = [3, 2, 1], keeping 1 value keeps 9/14 of the energy, but you returned {result!r}."
assert np.isclose(energy_kept(np.array([3.0, 2.0, 1.0]), 2), 13 / 14), "Keeping 2 values keeps 13/14 of the energy."
assert np.isclose(energy_kept(np.array([5.0, 0.5]), 2), 1.0), "Keeping every value keeps all of the energy."
--- hint
The total energy is the sum of the squared singular values. The kept energy is the same sum over the first `k` values only.
--- hint
Square the values with `S ** 2`, then divide the sum of the first k by the sum of all of them.
```

```python debug svd-rebuild id=svd-rebuild title="Rebuild the matrix from its pieces"
A = np.array([[4.0, 0.0, 2.0],
              [1.0, 3.0, 0.0]])
U, S, Vt = np.linalg.svd(A, full_matrices=False)

# Rebuild A from its three pieces
V = Vt.T
rebuilt = U @ np.diag(S) @ V
print(np.round(rebuilt, 3))
--- solution
A = np.array([[4.0, 0.0, 2.0],
              [1.0, 3.0, 0.0]])
U, S, Vt = np.linalg.svd(A, full_matrices=False)

# Rebuild A from its three pieces
rebuilt = U @ np.diag(S) @ Vt
print(np.round(rebuilt, 3))
--- test
assert np.allclose(rebuilt, A), f"The rebuilt matrix should equal A, but it is {np.round(rebuilt, 3).tolist()}."
--- hint
Check the shapes: `U` is 2 x 2, `diag(S)` is 2 x 2 and `V` is 3 x 2. The multiplication cannot go through.
--- hint
`np.linalg.svd` already returns the transposed right factor as `Vt`, so no extra transpose is needed.
```

```python predict id=predict-rank title="How many dimensions survive?"
M = np.array([[1.0, 2.0],
              [2.0, 4.0],
              [3.0, 6.0]])
print(np.linalg.matrix_rank(M))
--- options
2
* 1
3
0
--- explain
The second column is exactly twice the first, so all rows lie on one line through the origin. The matrix carries only one independent direction of information, which shows up as a single nonzero singular value.
```

```python predict id=predict-svd-shape title="Shapes from a compact SVD"
X = np.zeros((5, 3))
U, S, Vt = np.linalg.svd(X, full_matrices=False)
print(S.shape, U.shape)
--- options
(5,) (5, 5)
* (3,) (5, 3)
(3,) (3, 3)
(5, 3) (3,)
--- explain
With `full_matrices=False`, there are as many singular values as the smaller dimension (3), and `U` has the same shape as `X`: 5 rows and 3 orthonormal columns.
```

## Recap

- Every matrix factors as $A = U\Sigma V^\top$, with singular values sorted from largest to smallest.
- `np.linalg.svd(A, full_matrices=False)` returns the compact form, and `Vt` is already transposed.
- Squared singular values measure energy. The number of nonzero ones is the rank.
- Keeping the top $k$ components gives the best rank-$k$ approximation, which removes noise and compresses data.

**Up next:** principal component analysis, which applies the SVD to a dataset to find the directions along which the data varies most.
', 0, '[]', '[]', '2026-06-25T06:04:01.623Z', '2026-10-19T06:04:01.623Z'),
('les_math_for_machine_learning_2_3', 'sec_math_for_machine_learning_2', 'crs_math_for_machine_learning', 'Principal component analysis from scratch', 'interactive', 2, 1200, NULL, NULL, 'Imagine a dataset with fifty features: sensor readings, pixel values, survey answers. Most of its variation usually lives in a handful of directions, because many features move together. **Principal component analysis** (PCA) finds those directions. It rotates the data onto new axes, ordered by how much variation each one captures, so you can keep the first few and drop the rest with the least loss. It is the standard first step for visualizing high-dimensional data, compressing it and cleaning it before a model.

By the end of this lesson you will center data, compute a covariance matrix, find principal components with an eigendecomposition and with the SVD, and explain how much variance each component keeps.

## Start with centered data

PCA looks for directions of variation, so it measures everything relative to the average. The first step is to **center** the data: subtract each column''s mean, so every feature has mean zero.

```python run
import numpy as np

rng = np.random.default_rng(42)
t = rng.normal(0, 1, 300)
# Two correlated features: the second moves with the first, plus some noise
X = np.column_stack([t * 2.0 + 10, t * 1.0 + rng.normal(0, 0.3, 300) + 5])

Xc = X - X.mean(axis=0)
print("column means before:", X.mean(axis=0).round(2))
print("column means after centering are zero:", np.abs(Xc.mean(axis=0)).max() < 1e-12)
```

## The covariance matrix

The **covariance matrix** $C$ collects how every pair of features varies together. For centered data $X_c$ with $n$ rows,

$$
C = \frac{X_c^\top X_c}{n - 1}
$$

The diagonal holds each feature''s variance, and the off-diagonal entries hold the covariances. $C$ is symmetric, so `eigh` applies.

```python run
n = len(X)
C = Xc.T @ Xc / (n - 1)
print(C.round(2))
print("matches np.cov:", np.allclose(C, np.cov(X, rowvar=False)))
```

## Principal components are eigenvectors of the covariance

The eigenvector with the largest eigenvalue points along the direction of greatest variance. That is the **first principal component**. Its eigenvalue is the variance of the data projected onto it. Let''s plot the data with that direction drawn on top.

```python run
import matplotlib.pyplot as plt

vals, vecs = np.linalg.eigh(C)       # eigh sorts ascending, so the last one is the largest
top = vecs[:, -1]

fig, ax = plt.subplots()
ax.scatter(Xc[:, 0], Xc[:, 1], s=8, alpha=0.5)
ax.arrow(0, 0, *(top * 2 * np.sqrt(vals[-1])), color="tab:red", width=0.05, length_includes_head=True)
ax.set_aspect("equal"); ax.grid(alpha=0.3)
ax.set_title("Centered data and its first principal direction")
plt.show()
```

The red arrow follows the long axis of the cloud. Once you know the direction, the data can be projected onto it to give one coordinate per sample.

```python run
explained = vals[::-1] / vals.sum()
print("explained variance ratio, largest first:", explained.round(3))

Z = Xc @ top                          # coordinates along the first component
print("variance of the projection:", round(Z.var(ddof=1), 3), "| top eigenvalue:", round(vals[-1], 3))
```

The projection''s variance matches the top eigenvalue exactly, and the ratio tells you what fraction of the total variation one coordinate keeps. Here one number captures almost all of it.

## The same answer from the SVD

In practice PCA is computed with the SVD of the centered data, which avoids forming the covariance matrix. The right singular vectors (rows of `Vt`) are the principal components, and the singular values give the variances: $\lambda_i = \sigma_i^2 / (n - 1)$.

```python run
U, S, Vt = np.linalg.svd(Xc, full_matrices=False)
print("SVD variances:", np.round(S**2 / (n - 1), 3))
print("top component matches (up to sign):", np.isclose(abs(Vt[0] @ top), 1.0))
```

> **Pitfall:** eigenvectors and singular vectors are only defined up to a sign. Flipping a component''s sign gives an equally valid PCA. Compare directions with `abs(...)`, and never test against a specific sign.

> **In the wild:** scikit-learn''s `PCA` uses exactly this route: centering, then an SVD of the data matrix.

## Challenges

```python exercise id=center title="Center each column"
# TODO: `center(X)` should subtract each column''s mean from that column.
def center(X):
    ...
--- solution
def center(X):
    X = np.asarray(X, dtype=float)
    return X - X.mean(axis=0)
--- test
rng = np.random.default_rng(9)
M = rng.normal(loc=[5.0, -3.0, 0.5], scale=[1.0, 2.0, 3.0], size=(40, 3))
result = center(M)
assert result is not None, "Replace the `...` in `center` with code that returns the centered matrix."
assert np.shape(result) == (40, 3), "Centering should keep the shape of the matrix."
assert np.allclose(result.mean(axis=0), 0.0), "Every column of the result should have mean zero."
assert np.allclose(result, M - M.mean(axis=0)), "Each column should have its own mean subtracted."
--- hint
Each column''s mean comes from `X.mean(axis=0)`. Subtracting a vector of length d from a matrix with d columns broadcasts it across every row.
--- hint
`return X - X.mean(axis=0)`.
```

```python exercise id=pca-from-svd title="Principal component analysis with the SVD"
# TODO: `pca(X, k)` should return (Z, components):
#   components: the top k principal directions as rows, sorted by variance, shape (k, d)
#   Z: the centered data projected onto those directions, shape (n, k)
def pca(X, k):
    ...
--- solution
def pca(X, k):
    X = np.asarray(X, dtype=float)
    Xc = X - X.mean(axis=0)
    _, _, Vt = np.linalg.svd(Xc, full_matrices=False)
    components = Vt[:k]
    return Xc @ components.T, components
--- test
rng = np.random.default_rng(7)
base = rng.normal(size=(200, 1))
X = np.hstack([3 * base, base + rng.normal(0, 0.2, (200, 1)), rng.normal(0, 0.5, (200, 2))])
out = pca(X, 2)
assert out is not None, "Replace the `...` in `pca` with code that returns (Z, components)."
Z, components = out
assert np.shape(Z) == (200, 2), f"Z should have shape (200, 2), but it has {np.shape(Z)}."
assert np.shape(components) == (2, 4), f"components should have shape (2, 4), but it has {np.shape(components)}."
assert np.allclose(components @ components.T, np.eye(2)), "The principal directions should be unit length and perpendicular to each other."
eig = np.sort(np.linalg.eigvalsh(np.cov(X, rowvar=False)))[::-1][:2]
assert np.allclose(Z.var(axis=0, ddof=1), eig, rtol=1e-6), "The variance of each column of Z should match the top two eigenvalues of the covariance matrix, largest first."
--- hint
Center `X`, take the SVD with `full_matrices=False`, and keep the first `k` rows of `Vt` as the components.
--- hint
The projection is `Xc @ components.T`. Use the centered data, not the original `X`.
```

```python debug uncentered-cov id=uncentered-cov title="Covariance that ignores the mean"
rng = np.random.default_rng(3)
X = rng.normal(loc=[5.0, -2.0], scale=[2.0, 0.5], size=(500, 2))

# Covariance matrix of the two features
n = X.shape[0]
cov = X.T @ X / (n - 1)
print(np.round(cov, 2))
print("matches np.cov:", np.allclose(cov, np.cov(X, rowvar=False)))
--- solution
rng = np.random.default_rng(3)
X = rng.normal(loc=[5.0, -2.0], scale=[2.0, 0.5], size=(500, 2))

# Covariance matrix of the two features
n = X.shape[0]
Xc = X - X.mean(axis=0)
cov = Xc.T @ Xc / (n - 1)
print(np.round(cov, 2))
print("matches np.cov:", np.allclose(cov, np.cov(X, rowvar=False)))
--- test
assert np.allclose(cov, np.cov(X, rowvar=False)), f"cov should match np.cov, but the first row is {np.round(cov[0], 2).tolist()} and np.cov gives {np.round(np.cov(X, rowvar=False)[0], 2).tolist()}."
--- hint
Compare the diagonal: the variance of the first feature should be near 4, because its standard deviation is 2. The formula you wrote adds in the mean, which is about 5, and inflates it.
--- hint
Center the data first: subtract the column means, then use the same formula on the centered matrix.
```

```python predict id=predict-full-correlation title="One direction is enough"
t = np.linspace(-1, 1, 50)
X = np.column_stack([t, 2 * t])          # the second feature is exactly twice the first
Xc = X - X.mean(axis=0)
vals = np.linalg.eigvalsh(Xc.T @ Xc)
print(round(vals.max() / vals.sum(), 3))
--- options
0.5
* 1.0
0.8
0.25
--- explain
Every sample lies on the line `y = 2x`, so a single component captures all of the variation. The second eigenvalue is zero (up to rounding), so the top component explains everything.
```

```python predict id=predict-var title="Variance of centered data"
x = np.array([1.0, 2.0, 3.0, 4.0])
print(round(np.var(x - x.mean()), 2))
--- options
0.5
* 1.25
1.0
2.5
--- explain
The mean is 2.5 and the centered values are -1.5, -0.5, 0.5, 1.5. Their squares average to `(2.25 + 0.25 + 0.25 + 2.25) / 4 = 1.25`. NumPy''s `np.var` divides by n by default, which is what this calculation does.
```

## Recap

- PCA centers the data, then finds the directions of greatest variance.
- The covariance matrix is $C = X_c^\top X_c / (n-1)$. Its eigenvectors are the principal components, and its eigenvalues are their variances.
- The SVD of the centered data gives the same components more directly, and is what libraries use.
- Components are defined only up to sign. Compare them with `abs(...)`.
- Keeping the top $k$ components keeps the most variance any $k$ directions can.

**Up next:** calculus. PCA tells you which directions matter. Calculus tells a model how to move, which is how it learns.
', 0, '[]', '[]', '2026-06-25T06:04:01.623Z', '2026-10-19T06:04:01.623Z'),
('les_math_for_machine_learning_2_4', 'sec_math_for_machine_learning_2', 'crs_math_for_machine_learning', 'Checkpoint: eigenvalues, SVD and PCA', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"An eigenvector v of a matrix A, with eigenvalue λ, satisfies…","options":["A v = 0","A v = λ v","A v = v · λ²","vᵀ A = λ"],"answerIndex":1,"explanation":"Multiplying an eigenvector by A only scales it, by λ. The direction is unchanged."},{"id":"q2","prompt":"Which NumPy function should you use to find eigenvalues and eigenvectors of a symmetric matrix?","options":["np.linalg.inv","np.linalg.svd","np.linalg.eigh","np.linalg.det"],"answerIndex":2,"explanation":"np.linalg.eigh exploits symmetry. It returns real eigenvalues in ascending order and orthogonal eigenvectors as columns."},{"id":"q3","prompt":"How are the singular values of a matrix A related to eigenvalues?","options":["They are the eigenvalues of A itself","They are the square roots of the eigenvalues of AᵀA","They are always equal to the trace","They have no relation to eigenvalues"],"answerIndex":1,"explanation":"AᵀA is symmetric and positive semidefinite, so its eigenvalues are non-negative, and their square roots are the singular values of A."},{"id":"q4","prompt":"Why is truncating the SVD to its top k components a good approximation?","options":["It gives the best rank-k approximation in the least-squares sense","It always gives an exact answer","It makes the matrix symmetric","It sets the smallest eigenvalues to zero"],"answerIndex":0,"explanation":"The Eckart–Young theorem says that keeping the top k singular values and vectors gives the closest rank-k matrix to A, measured by the Frobenius norm."},{"id":"q5","prompt":"In PCA, what is the first principal component?","options":["The mean of the data","The feature with the largest variance","The eigenvector of the covariance matrix with the largest eigenvalue","The first row of the data matrix"],"answerIndex":2,"explanation":"The top eigenvector of the covariance matrix points along the direction of greatest variance, and its eigenvalue is the variance along that direction."}]', '[]', '2026-06-25T06:04:01.623Z', '2026-10-19T06:04:01.623Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_math_for_machine_learning_3_1', 'sec_math_for_machine_learning_3', 'crs_math_for_machine_learning', 'Derivatives as sensitivity', 'interactive', 0, 960, NULL, NULL, 'Training a model means asking one question over and over: if I nudge this weight a little, how much does the error change? The answer to that question is a **derivative**. It measures sensitivity, the rate at which an output responds to an input. Every learning algorithm in this course, from gradient descent to backpropagation, is built on that single idea.

By the end of this lesson you will estimate derivatives numerically, understand why central differences are more accurate, check the derivative of the sigmoid function that appears in every classifier, and write a numerical derivative from scratch.

## The slope of a curve

The derivative $f''(x)$ is the slope of the tangent line at $x$. You can estimate it by drawing a secant line through $(x, f(x))$ and a nearby point $(x + h, f(x+h))$, then letting $h$ shrink.

$$
f''(x) \approx \frac{f(x + h) - f(x)}{h}
$$

```python run
import numpy as np

def f(x):
    return x ** 2

x0 = 3.0      # the exact derivative of x**2 at 3 is 2 * 3 = 6
for h in [1.0, 0.1, 0.01, 0.0001]:
    slope = (f(x0 + h) - f(x0)) / h
    print(f"h = {h:<8} slope ≈ {slope:.4f}")
```

As $h$ shrinks, the estimate approaches 6. You can watch the secant line turn into the tangent.

## Central differences are much more accurate

Looking forward from $x$ introduces an error that is proportional to $h$. Looking symmetrically, one step to each side, cancels the leading error and gives an error proportional to $h^2$. That is far more accurate for the same step size.

$$
f''(x) \approx \frac{f(x + h) - f(x - h)}{2h}
$$

```python run
def central_slope(f, x, h=1e-5):
    return (f(x + h) - f(x - h)) / (2 * h)

print(f"central difference: {central_slope(f, 3.0):.6f}")
print(f"forward difference: {(f(3.0 + 1e-5) - f(3.0)) / 1e-5:.6f}")
```

> **Pitfall:** the step size has a sweet spot. Too large and the approximation is crude; too small and floating-point rounding dominates. A step around $10^{-5}$ is a safe default for central differences on ordinary functions.

## The rules you already know

For most functions you will meet, you don''t need to estimate the derivative at all. A few rules cover most cases:

- **Power rule:** $\dfrac{d}{dx} x^n = n\,x^{n-1}$
- **Sum rule:** $(f + g)'' = f'' + g''$
- **Constant multiple:** $(c\,f)'' = c\,f''$

The most important derivative in machine learning is the **sigmoid**, which squashes any number into a probability between 0 and 1. Its derivative has a beautifully simple form that you will use again and again.

$$
\sigma(z) = \frac{1}{1 + e^{-z}}, \qquad \sigma''(z) = \sigma(z)\,\bigl(1 - \sigma(z)\bigr)
$$

```python run
def sigmoid(z):
    return 1 / (1 + np.exp(-z))

z = 0.5
analytic = sigmoid(z) * (1 - sigmoid(z))
numeric = central_slope(sigmoid, z)
print(f"formula: {analytic:.6f}   numerical: {numeric:.6f}")
```

Both numbers agree. The formula is faster and exact; the numerical version is a check you can use on any function, including ones you can''t differentiate by hand.

## The tangent line is the best linear approximation

Near $x$, the function looks like its tangent line:

$$
f(x + \delta) \approx f(x) + f''(x)\,\delta
$$

That''s why derivatives are useful for learning: they tell you how a small change in an input changes the output, and an optimizer can use that to choose a good step.

```python run
import matplotlib.pyplot as plt

xs = np.linspace(0, 4, 200)
x0 = 2.0
tangent = f(x0) + central_slope(f, x0) * (xs - x0)

fig, ax = plt.subplots()
ax.plot(xs, f(xs), label="f(x) = x²")
ax.plot(xs, tangent, "--", label="tangent at x = 2")
ax.scatter([x0], [f(x0)], color="black", zorder=3)
ax.set_ylim(-1, 12); ax.grid(alpha=0.3); ax.legend()
plt.show()
```

## Derivatives as sensitivity in a loss

Suppose a model with one weight $w$ has the loss $L(w) = (2w - 3)^2$. The derivative tells you which way to move $w$ to reduce the loss, and how fast it will fall.

```python run
def loss(w):
    return (2 * w - 3) ** 2

w = 1.0
print("loss now:", loss(w), "| slope:", round(central_slope(loss, w), 4))
print("loss after a small step to w = 1.01:", round(loss(w + 0.01), 4))
```

The slope is negative, so increasing $w$ lowers the loss. The sign and size of the derivative are exactly the information an optimizer needs.

## Challenges

```python exercise id=numerical-derivative title="Write a numerical derivative"
# TODO: `numerical_derivative(f, x, h=1e-5)` should return the central-difference
# estimate of f''(x).
def numerical_derivative(f, x, h=1e-5):
    ...
--- solution
def numerical_derivative(f, x, h=1e-5):
    return (f(x + h) - f(x - h)) / (2 * h)
--- test
result = numerical_derivative(np.sin, 0.0)
assert result is not None, "Replace the `...` in `numerical_derivative` with code that returns the slope."
assert np.isclose(result, 1.0, atol=1e-4), f"The derivative of sin at 0 is cos(0) = 1, but you returned {result!r}."
assert np.isclose(numerical_derivative(lambda t: t ** 3, 2.0), 12.0, atol=1e-4), "The derivative of x³ at x = 2 is 12."
assert np.isclose(numerical_derivative(np.exp, 1.0), np.e, atol=1e-4), "The derivative of eˣ is itself, so at x = 1 it should be e."
--- hint
Central difference: evaluate `f` a step to the right and a step to the left, subtract, and divide by the full width `2 * h`.
--- hint
`return (f(x + h) - f(x - h)) / (2 * h)`.
```

```python exercise id=dsigmoid title="The derivative of the sigmoid"
# TODO: `dsigmoid(z)` should return the derivative of the sigmoid at z,
# using the formula sigma(z) * (1 - sigma(z)). The sigmoid is 1 / (1 + exp(-z)).
def dsigmoid(z):
    ...
--- solution
def dsigmoid(z):
    s = 1 / (1 + np.exp(-z))
    return s * (1 - s)
--- test
result = dsigmoid(0.0)
assert result is not None, "Replace the `...` in `dsigmoid` with code that returns the derivative."
assert np.isclose(result, 0.25), f"The sigmoid''s derivative at 0 is 0.25, but you returned {result!r}."
for z in [-2.0, 1.5, 3.0]:
    s = 1 / (1 + np.exp(-z))
    assert np.isclose(dsigmoid(z), s * (1 - s)), f"dsigmoid({z}) should be sigma({z}) * (1 - sigma({z})) = {s * (1 - s):.6f}."
--- hint
Write `s = 1 / (1 + np.exp(-z))` first, then return `s * (1 - s)`.
--- hint
The sigmoid''s derivative peaks at z = 0 with value 0.25, which is a useful check.
```

```python debug central-denominator id=central-bug title="Twice as steep"
def central_slope(f, x, h=1e-5):
    # Central difference: (f(x + h) - f(x - h)) / (2h)
    return (f(x + h) - f(x - h)) / h

print("slope of x**3 at x = 2:", round(central_slope(lambda t: t ** 3, 2.0), 3))
--- solution
def central_slope(f, x, h=1e-5):
    # Central difference: (f(x + h) - f(x - h)) / (2h)
    return (f(x + h) - f(x - h)) / (2 * h)

print("slope of x**3 at x = 2:", round(central_slope(lambda t: t ** 3, 2.0), 3))
--- test
assert np.isclose(central_slope(lambda t: t ** 3, 2.0), 12.0, atol=1e-4), f"The slope of x³ at 2 is 12, but central_slope returned {central_slope(lambda t: t ** 3, 2.0)!r}."
assert np.isclose(central_slope(np.sin, 0.0), 1.0, atol=1e-4), "The slope of sin at 0 is 1."
--- hint
Compare the printed value with the true slope: the derivative of x³ at 2 is 3 × 2² = 12. The result is exactly double that.
--- hint
The denominator must be the full distance between the two points, which is `2 * h`, not `h`.
```

```python predict id=predict-slope title="Estimate the slope"
f = lambda x: x * x
print(round((f(1 + 1e-6) - f(1)) / 1e-6, 3))
--- options
* 2.0
1.0
2.000001
4.0
--- explain
The slope of x² at x = 1 is 2x = 2. The tiny step changes the answer only in the sixth decimal place, and rounding to three places hides that.
```

## Recap

- The derivative is the slope of the tangent line, and the rate at which an output responds to an input.
- A numerical derivative uses a small step $h$. Central differences are accurate to order $h^2$.
- The sigmoid has the derivative $\sigma(z)(1 - \sigma(z))$, which you will use in every classifier.
- Near $x$, a function looks like its tangent line, so the derivative tells an optimizer which way to move.

**Up next:** functions of many variables, where a single derivative becomes a gradient vector that points uphill in every direction at once.
', 0, '[]', '[]', '2026-06-25T06:04:01.623Z', '2026-10-19T06:04:01.623Z'),
('les_math_for_machine_learning_3_2', 'sec_math_for_machine_learning_3', 'crs_math_for_machine_learning', 'Partial derivatives and gradients', 'interactive', 1, 960, NULL, NULL, 'A model with a thousand weights has a thousand derivatives, one for each weight. Collecting them into a single vector gives the **gradient**. The gradient points in the direction in which the loss increases fastest, so the opposite direction is the one that decreases it. That single vector is what every optimizer in deep learning computes at every step.

By the end of this lesson you will compute partial derivatives, read a gradient on a contour plot, write a numerical gradient for any function of many variables, and verify the direction of steepest descent with code.

## Partial derivatives: change one thing at a time

For a function of two variables, $f(x, y) = x^2 + 3xy$, the **partial derivative** with respect to $x$ treats $y$ as a constant. You differentiate as if $y$ were a number, and do the same for $y$ separately.

$$
\frac{\partial f}{\partial x} = 2x + 3y, \qquad \frac{\partial f}{\partial y} = 3x
$$

```python run
import numpy as np

def f(x, y):
    return x ** 2 + 3 * x * y

x0, y0, h = 1.0, 2.0, 1e-5
df_dx = (f(x0 + h, y0) - f(x0 - h, y0)) / (2 * h)
df_dy = (f(x0, y0 + h) - f(x0, y0 - h)) / (2 * h)
print(f"∂f/∂x ≈ {df_dx:.4f}   (formula: 2x + 3y = {2 * x0 + 3 * y0})")
print(f"∂f/∂y ≈ {df_dy:.4f}   (formula: 3x = {3 * x0})")
```

Each partial derivative is an ordinary one-dimensional derivative, with everything else held still.

## The gradient collects them all

The **gradient** $\nabla f$ is the vector of all partial derivatives. At the point $(1, 2)$ it is $(8, 3)$.

$$
\nabla f(x, y) = \begin{bmatrix} \partial f / \partial x \\ \partial f / \partial y \end{bmatrix} = \begin{bmatrix} 2x + 3y \\ 3x \end{bmatrix}
$$

A picture makes the idea concrete. The bowl $f = x^2 + y^2$ has circular contours. The arrows below are gradients, and each one points uphill, perpendicular to the contour it sits on.

```python run
import matplotlib.pyplot as plt

xs, ys = np.meshgrid(np.linspace(-3, 3, 200), np.linspace(-3, 3, 200))
Z = xs ** 2 + ys ** 2

g = np.linspace(-2, 2, 9)
gx, gy = np.meshgrid(g, g)

fig, ax = plt.subplots()
ax.contour(xs, ys, Z, levels=10, cmap="viridis")
ax.quiver(gx, gy, 2 * gx, 2 * gy, color="tab:red")
ax.set_aspect("equal")
ax.set_title("Gradient of x² + y²: red arrows point uphill")
plt.show()
```

> **Key fact:** the gradient is perpendicular to the contour lines. Moving along a contour doesn''t change the value, so the fastest change must be across it.

## A numerical gradient for any function

For a function of many variables, you can approximate every partial derivative with a central difference, one coordinate at a time. This works for any function you can evaluate, which makes it an excellent check on hand-derived gradients.

```python run
def numerical_gradient(f, x, h=1e-5):
    x = np.asarray(x, dtype=float)
    grad = np.zeros_like(x)
    for i in range(x.size):
        step = np.zeros_like(x)
        step[i] = h
        grad[i] = (f(x + step) - f(x - step)) / (2 * h)
    return grad

bowl = lambda p: p[0] ** 2 + 3 * p[0] * p[1]
p = np.array([1.0, 2.0])
print(numerical_gradient(bowl, p).round(4))
```

The result, `[8, 3]`, matches the formulas above.

## Stepping along the gradient

The gradient points uphill. Step a little along it and the function increases; step against it and the function decreases. Gradient descent is nothing more than repeating the second move.

```python run
g = numerical_gradient(bowl, p)
print("f at p:               ", bowl(p))
print("f after stepping uphill:  ", round(bowl(p + 0.1 * g), 3))
print("f after stepping downhill:", round(bowl(p - 0.1 * g), 3))
```

Going uphill raised the value from 7 to about 15.7, and going downhill lowered it to about 1.1. The gradient told us which way was which.

## Challenges

```python exercise id=gradient-formula title="The gradient by hand"
# TODO: `gradient(p)` should return the gradient of f(x, y) = x**2 + 3*x*y
# at the point p = [x, y], as a NumPy array [df/dx, df/dy].
def gradient(p):
    ...
--- solution
def gradient(p):
    x, y = p
    return np.array([2 * x + 3 * y, 3 * x], dtype=float)
--- test
result = gradient(np.array([1.0, 2.0]))
assert result is not None, "Replace the `...` in `gradient` with code that returns the gradient."
assert np.allclose(result, [8.0, 3.0]), f"The gradient at (1, 2) should be [8, 3], but you returned {result!r}."
assert np.allclose(gradient(np.array([-1.0, 0.5])), [-0.5, -3.0]), "The gradient at (-1, 0.5) should be [-0.5, -3]."
--- hint
Write down both partial derivatives first: 2x + 3y for x and 3x for y.
--- hint
`np.array([2 * x + 3 * y, 3 * x])`, after unpacking `x, y = p`.
```

```python exercise id=numerical-gradient title="Numerical gradient in three dimensions"
# TODO: `numerical_gradient(f, p, h=1e-5)` should approximate the gradient of f at the
# point p, using central differences along each coordinate.
def numerical_gradient(f, p, h=1e-5):
    ...
--- solution
def numerical_gradient(f, p, h=1e-5):
    p = np.asarray(p, dtype=float)
    grad = np.zeros_like(p)
    for i in range(p.size):
        step = np.zeros_like(p)
        step[i] = h
        grad[i] = (f(p + step) - f(p - step)) / (2 * h)
    return grad
--- test
f3 = lambda q: q[0] * q[1] + np.sin(q[2])
result = numerical_gradient(f3, np.array([1.0, 2.0, 0.0]))
assert result is not None, "Replace the `...` in `numerical_gradient` with code that returns the gradient."
assert np.allclose(result, [2.0, 1.0, 1.0], atol=1e-4), f"At (1, 2, 0) the gradient of q0*q1 + sin(q2) is [2, 1, 1], but you returned {np.round(result, 4).tolist()}."
assert np.allclose(numerical_gradient(f3, np.array([3.0, -1.0, np.pi / 2])), [-1.0, 3.0, 0.0], atol=1e-4), "At (3, -1, pi/2) the gradient is [-1, 3, 0]."
--- hint
Loop over the coordinates. For coordinate i, build a step vector that is zero except h at position i, then apply the central difference from the 1-D case.
--- hint
Inside the loop: `step = np.zeros_like(p); step[i] = h`, then `grad[i] = (f(p + step) - f(p - step)) / (2 * h)`.
```

```python debug int-gradient id=int-gradient title="A gradient that explodes"
def numerical_gradient(f, x, h=1e-6):
    grad = np.zeros(len(x))
    for i in range(len(x)):
        x_plus = x.copy()
        x_plus[i] += h
        x_minus = x.copy()
        x_minus[i] -= h
        grad[i] = (f(x_plus) - f(x_minus)) / (2 * h)
    return grad

def loss(w):
    return np.sum((w - 3.0) ** 2)

weights = np.array([1, 2])
print(numerical_gradient(loss, weights))
--- solution
def numerical_gradient(f, x, h=1e-6):
    grad = np.zeros(len(x))
    for i in range(len(x)):
        x_plus = x.copy()
        x_plus[i] += h
        x_minus = x.copy()
        x_minus[i] -= h
        grad[i] = (f(x_plus) - f(x_minus)) / (2 * h)
    return grad

def loss(w):
    return np.sum((w - 3.0) ** 2)

weights = np.array([1.0, 2.0])
print(numerical_gradient(loss, weights))
--- test
result = numerical_gradient(loss, weights)
assert np.allclose(result, [-4.0, -2.0], atol=1e-3), f"The gradient of sum((w - 3)²) at the weights (1, 2) is [-4, -2], but numerical_gradient returned {np.round(result, 3).tolist()}."
--- hint
Look at the size of the printed numbers. A gradient of this function should be around -4 and -2, not in the millions.
--- hint
Integer arrays cannot store the tiny step `h`: `x_plus[i] += 1e-6` silently keeps only the whole part. Use decimal numbers, for example `np.array([1.0, 2.0])`.
```

```python predict id=predict-grad title="Which way is uphill?"
x, y = 2.0, 3.0
print(np.array([y, x]))
--- options
* [3. 2.]
[2. 3.]
[6. 6.]
[1. 1.]
--- explain
For `f(x, y) = x * y`, the partial derivative with respect to x is `y = 3`, and with respect to y it is `x = 2`. The gradient is `[3, 2]`, so moving toward larger x and y raises the function.
```

## Recap

- A partial derivative differentiates with respect to one variable, holding the others fixed.
- The gradient collects all partial derivatives into one vector that points in the direction of fastest increase.
- The gradient is perpendicular to the contour lines of the function.
- A numerical gradient uses central differences along each coordinate, which makes it a reliable check on derived formulas.
- Use floating-point arrays for anything you perturb by tiny steps.

**Up next:** gradient descent. Repeatedly stepping against the gradient is how a model learns.
', 0, '[]', '[]', '2026-06-25T06:04:01.623Z', '2026-10-19T06:04:01.623Z'),
('les_math_for_machine_learning_3_3', 'sec_math_for_machine_learning_3', 'crs_math_for_machine_learning', 'Gradient descent: walking downhill', 'interactive', 2, 1080, NULL, NULL, 'Almost every model you will meet learns the same way. It starts with a guess, measures the gradient of its error, takes a small step against that gradient, and repeats. That loop is **gradient descent**. It is simple enough to write in five lines and powerful enough to train models with billions of weights, and the only real design decision is how big each step should be.

By the end of this lesson you will run gradient descent on a function, see how the learning rate controls convergence and divergence, fit a line to noisy data using gradients, and derive the gradient of the mean squared error.

## The update rule

Given a loss $f$ and its gradient $\nabla f$, one step of gradient descent is

$$
x \leftarrow x - \eta\, \nabla f(x)
$$

where $\eta$ (eta) is the **learning rate**. Let''s watch it work on $f(x) = (x - 3)^2$, whose minimum is at $x = 3$. Its derivative is $f''(x) = 2(x - 3)$.

```python run
import numpy as np

def grad_f(x):
    return 2 * (x - 3)

x = 0.0
lr = 0.1
for step in range(1, 6):
    x = x - lr * grad_f(x)
    print(f"step {step}: x = {x:.4f}")
```

Each step moves $x$ closer to 3, and the steps get smaller as the gradient shrinks near the minimum.

## The learning rate decides everything

The same update can crawl, converge quickly, or explode, depending on $\eta$. Try four values for twenty steps each.

```python run
for lr in [0.01, 0.1, 0.5, 1.1]:
    x = 0.0
    for _ in range(20):
        x = x - lr * grad_f(x)
    print(f"lr = {lr:<5} after 20 steps: x = {x:.4g}")
```

- **Too small** (0.01): correct direction, but after 20 steps you are still far from 3.
- **Just right** (0.1 to 0.5): the error shrinks steadily. At 0.5 the first step lands exactly on the minimum.
- **Too large** (1.1): every step overshoots by more than it gained, so $x$ swings further from 3 each time.

For this quadratic, the error shrinks by the factor $|1 - 2\eta|$ each step. Convergence requires $|1 - 2\eta| < 1$, which means $\eta < 1$.

> **Tip:** when training goes wrong, check the learning rate first. A loss that grows or jumps around almost always means the step is too large.

## Fitting a line by gradient descent

Now a real learning problem. The data follow $y = 2x + 1$ plus noise. We model it as $\hat{y} = wx + b$ and minimize the **mean squared error** $L = \frac{1}{n}\sum (\hat{y}_i - y_i)^2$. Its gradients are

$$
\frac{\partial L}{\partial w} = \frac{2}{n}\sum_i (\hat{y}_i - y_i)\,x_i, \qquad \frac{\partial L}{\partial b} = \frac{2}{n}\sum_i (\hat{y}_i - y_i)
$$

```python run
import matplotlib.pyplot as plt

rng = np.random.default_rng(0)
x = rng.uniform(0, 1, 100)
y = 2 * x + 1 + rng.normal(0, 0.1, 100)

w, b, lr = 0.0, 0.0, 0.5
losses = []
for _ in range(500):
    err = (w * x + b) - y
    losses.append(np.mean(err ** 2))
    w -= lr * 2 * np.mean(err * x)
    b -= lr * 2 * np.mean(err)

print(f"learned w = {w:.3f}, b = {b:.3f}   (true values: 2 and 1)")

fig, ax = plt.subplots()
ax.plot(losses)
ax.set_yscale("log"); ax.set_xlabel("step"); ax.set_ylabel("mean squared error")
ax.grid(alpha=0.3)
plt.show()
```

The loss curve falls steeply and then flattens as the line settles. The learned parameters land close to the true values, 2 and 1, despite the noise, because the noise averages out over 100 points.

> **In the wild:** this exact loop, a gradient of a loss computed over a batch of data followed by a step, is what PyTorch and TensorFlow run during training. They just compute the gradients automatically (see the next lesson) and in parallel.

## Gradient descent on a matrix problem

In vector form, with a matrix $X$ whose rows are samples, the MSE gradient becomes $\frac{2}{n} X^\top (Xw - y)$. One matrix product gives the gradient for every weight at once.

```python run
X = np.column_stack([x, np.ones_like(x)])   # a column of ones gives the bias
w_vec = np.zeros(2)
for _ in range(500):
    w_vec -= 0.5 * (2 / len(y)) * X.T @ (X @ w_vec - y)
print("vector form (w, b):", w_vec.round(3))
```

This gives the same answer as the loop above, written as linear algebra.

## Challenges

```python exercise id=gradient-descent title="Gradient descent on a function"
# TODO: `gradient_descent(grad, x0, lr, steps)` should start at x0, repeat the update
# x = x - lr * grad(x) for `steps` steps, and return the final x.
def gradient_descent(grad, x0, lr, steps):
    ...
--- solution
def gradient_descent(grad, x0, lr, steps):
    x = x0
    for _ in range(steps):
        x = x - lr * grad(x)
    return x
--- test
result = gradient_descent(lambda x: 2 * (x - 3), 0.0, 0.1, 100)
assert result is not None, "Replace the `...` in `gradient_descent` with code that returns the final value."
assert np.isclose(result, 3.0, atol=1e-6), f"Descent on (x - 3)² should approach 3, but it returned {result!r}."
assert np.isclose(gradient_descent(lambda x: 2 * x, -5.0, 0.25, 50), 0.0, atol=1e-6), "Descent on x² from -5 should approach 0."
--- hint
Use a `for` loop that runs `steps` times, and update `x` inside it with `x = x - lr * grad(x)`.
--- hint
`grad` is a function you call, like `grad(x)`. Return `x` after the loop.
```

```python exercise id=mse-gradient title="The gradient of the mean squared error"
# TODO: `mse_gradient(X, y, w)` should return the gradient of the mean squared error
# (2 / n) * X.T @ (X @ w - y) for the linear model X @ w.
def mse_gradient(X, y, w):
    ...
--- solution
def mse_gradient(X, y, w):
    n = len(y)
    return (2 / n) * X.T @ (X @ w - y)
--- test
X = np.array([[1.0, 1.0], [1.0, 2.0], [1.0, 3.0]])
y = np.array([1.0, 2.0, 3.0])
result = mse_gradient(X, y, np.zeros(2))
assert result is not None, "Replace the `...` in `mse_gradient` with code that returns the gradient."
assert np.allclose(result, [-4.0, -28 / 3]), f"At w = (0, 0) the gradient should be [-4, -9.33], but you returned {np.round(result, 3).tolist()}."
assert np.allclose(mse_gradient(X, y, np.array([1.0, 1.0])), [2.0, 4.0]), "At w = (1, 1) the gradient should be [2, 4]."
--- hint
Compute the residual first: `X @ w - y`. Then multiply its transpose by `X` and scale by `2 / n`.
--- hint
`(2 / len(y)) * X.T @ (X @ w - y)`. Remember the transpose of X on the left.
```

```python exercise id=train-linear title="Train a linear model with gradient descent"
# TODO: `train_linear(X, y, lr=0.5, steps=3000)` should start from w = zeros and run
# gradient descent on the mean squared error, returning the learned weight vector w.
def train_linear(X, y, lr=0.5, steps=3000):
    ...
--- solution
def train_linear(X, y, lr=0.5, steps=3000):
    w = np.zeros(X.shape[1])
    n = len(y)
    for _ in range(steps):
        w -= lr * (2 / n) * X.T @ (X @ w - y)
    return w
--- test
x = np.linspace(0, 1, 20)
X = np.column_stack([x, np.ones_like(x)])
y = 3 * x + 2
result = train_linear(X, y)
assert result is not None, "Replace the `...` in `train_linear` with code that returns the weights."
assert np.shape(result) == (2,), f"The weight vector should have length 2 (slope and intercept), but it has shape {np.shape(result)}."
assert np.allclose(result, [3.0, 2.0], atol=1e-3), f"The data follow y = 3x + 2, so the weights should be about [3, 2], but train_linear returned {np.round(result, 4).tolist()}."
--- hint
Initialize `w = np.zeros(X.shape[1])`, then repeat the update `w -= lr * gradient` many times, where the gradient is the MSE gradient from the previous challenge.
--- hint
Inside the loop: `w -= lr * (2 / n) * X.T @ (X @ w - y)`.
```

```python debug sign-flip id=gd-sign title="Climbing instead of descending"
def grad_loss(w):
    return 2 * (w - 3)   # the gradient of (w - 3) ** 2

w = 0.0
lr = 0.1
for step in range(50):
    w = w + lr * grad_loss(w)   # step to lower the loss
print("final w:", round(w, 3))
--- solution
def grad_loss(w):
    return 2 * (w - 3)   # the gradient of (w - 3) ** 2

w = 0.0
lr = 0.1
for step in range(50):
    w = w - lr * grad_loss(w)   # step to lower the loss
print("final w:", round(w, 3))
--- test
assert np.isclose(w, 3.0, atol=1e-3), f"Gradient descent should move w to the minimum at 3, but w is {w!r}."
--- hint
Look at the printed value. It is far from 3 and getting further away, which is the signature of stepping uphill.
--- hint
Gradient descent subtracts the gradient: `w = w - lr * grad_loss(w)`.
```

```python predict id=predict-gd title="One step of descent"
x = 1.0
x = x - 0.5 * (2 * x)
print(x)
--- options
* 0.0
1.0
2.0
-1.0
--- explain
The gradient of x² at x = 1 is 2. One step with learning rate 0.5 moves x by `0.5 * 2 = 1` in the downhill direction, from 1 to 0.
```

## Recap

- Gradient descent repeats $x \leftarrow x - \eta\,\nabla f(x)$.
- The learning rate controls progress: too small is slow, too large diverges.
- For a linear model with mean squared error, the gradient is $\frac{2}{n}X^\top(Xw - y)$, which NumPy computes in one line.
- Training a model is running this loop until the loss stops falling.

**Up next:** the chain rule. Real models are long chains of simple functions, and the chain rule is how their gradients are computed.
', 0, '[]', '[]', '2026-06-25T06:04:01.623Z', '2026-10-19T06:04:01.623Z'),
('les_math_for_machine_learning_3_4', 'sec_math_for_machine_learning_3', 'crs_math_for_machine_learning', 'The chain rule and backpropagation', 'interactive', 3, 1080, NULL, NULL, 'A neural network is a long chain of simple functions: a multiplication, an addition, a squashing, and then another round. To train it, you need the gradient of the final loss with respect to every weight in the chain. The **chain rule** provides it. It says that the derivative of a composition is the product of the derivatives along the chain, and **backpropagation** is nothing more than applying the chain rule efficiently, from the output back to the input.

By the end of this lesson you will apply the chain rule to composite functions, run a forward and backward pass by hand for a single neuron, verify it numerically, and see why gradients can vanish through deep stacks of sigmoids.

## Functions inside functions

If $h(x) = f(g(x))$, the chain rule says

$$
h''(x) = f''(g(x)) \cdot g''(x)
$$

Take $h(x) = \sin(x^2)$. The inside is $g(x) = x^2$ and the outside is $\sin$. The derivative is $\cos(x^2)$ times the inner derivative $2x$.

```python run
import numpy as np

def h(x):
    return np.sin(x ** 2)

def dh(x):
    return np.cos(x ** 2) * 2 * x

x = 1.2
numeric = (h(x + 1e-6) - h(x - 1e-6)) / 2e-6
print(f"formula: {dh(x):.6f}   numerical: {numeric:.6f}")
```

The two numbers agree. Every nested function you meet in ML is handled the same way: differentiate the outside, keep the inside, and multiply by the derivative of the inside.

## A neuron, step by step

A single artificial neuron takes an input $x$, multiplies it by a weight $w$, adds a bias $b$, squashes the result with a sigmoid, and compares the output with a target $t$ using a squared error. Written as a chain:

$$
z = wx + b, \qquad a = \sigma(z), \qquad L = (a - t)^2
$$

Training needs $\partial L / \partial w$. The **forward pass** computes each intermediate value from left to right. The **backward pass** multiplies the local derivatives from right to left.

```python run
x, w, b, t = 2.0, 0.5, -0.25, 1.0

# Forward pass: compute each intermediate value
z = w * x + b
a = 1 / (1 + np.exp(-z))
L = (a - t) ** 2

# Backward pass: multiply the local derivatives from the output back
dL_da = 2 * (a - t)          # derivative of the squared error
da_dz = a * (1 - a)          # derivative of the sigmoid
dz_dw = x                    # derivative of wx + b with respect to w
dL_dw = dL_da * da_dz * dz_dw

print(f"loss L = {L:.4f}")
print(f"dL/dw  = {dL_dw:.4f}")
```

Each factor is a local derivative that depends only on its own step. The backward pass reuses the values from the forward pass, which is why backpropagation is so efficient.

Let''s check the result with a finite difference, which needs no derivative rules at all:

```python run
def loss(w_):
    z_ = w_ * x + b
    return (1 / (1 + np.exp(-z_)) - t) ** 2

eps = 1e-6
numeric = (loss(w + eps) - loss(w - eps)) / (2 * eps)
print("numerical dL/dw:", round(numeric, 6))
print("backprop dL/dw: ", round(dL_dw, 6))
```

They match. Backpropagation gives exactly the same answer as the slow numerical method, but in one backward sweep instead of one evaluation per weight.

## Why deep networks need care

The sigmoid''s derivative is at most 0.25, reached at $z = 0$. Backpropagation multiplies one such factor per layer, so the gradient shrinks rapidly as the network gets deeper. This is the **vanishing gradient** problem, and it is one reason modern networks use other activation functions.

```python run
def dsig(z):
    s = 1 / (1 + np.exp(-z))
    return s * (1 - s)

print("largest sigmoid derivative:", round(dsig(0.0), 2))
print(f"best case through 10 sigmoid layers: {0.25 ** 10:.2e}")
```

Even in the best case, ten sigmoid layers scale the gradient down by almost a million. That is why the next lesson''s ideas matter.

> **In the wild:** frameworks such as PyTorch record the forward pass and run this backward sweep automatically; it is called *autograd*. Understanding the chain rule tells you what it is actually computing.

## Challenges

```python exercise id=gaussian-derivative title="Derivative of a Gaussian bump"
# TODO: `dgauss(x)` should return the derivative of f(x) = exp(-x**2),
# using the chain rule. It should work for arrays too.
def dgauss(x):
    ...
--- solution
def dgauss(x):
    return -2 * x * np.exp(-x ** 2)
--- test
def gauss(t):
    return np.exp(-t ** 2)

result = dgauss(np.array([0.0, 0.5, -1.3]))
assert result is not None, "Replace the `...` in `dgauss` with code that returns the derivative."
for x0 in [0.0, 0.5, -1.3]:
    h = 1e-6
    numeric = (gauss(x0 + h) - gauss(x0 - h)) / (2 * h)
    assert np.isclose(dgauss(np.array([x0]))[0], numeric, atol=1e-5), f"The derivative at x = {x0} should be about {numeric:.5f}."
--- hint
The outside function is exp, whose derivative is exp itself. The inside is `-x**2`, whose derivative is `-2x`.
--- hint
Multiply the outer derivative `exp(-x**2)` by the inner derivative `-2x`.
```

```python exercise id=neuron-gradient title="Gradient of a single sigmoid neuron"
# TODO: `grad_w(x, w, t)` should return dL/dw for the loss L = (sigmoid(w * x) - t) ** 2,
# where sigmoid(z) = 1 / (1 + exp(-z)). Use the chain rule.
def grad_w(x, w, t):
    ...
--- solution
def grad_w(x, w, t):
    s = 1 / (1 + np.exp(-w * x))
    return 2 * (s - t) * s * (1 - s) * x
--- test
def neuron_loss(x, w, t):
    return (1 / (1 + np.exp(-w * x)) - t) ** 2

result = grad_w(1.5, 0.4, 1.0)
assert result is not None, "Replace the `...` in `grad_w` with code that returns the gradient."
for x0, w0, t0 in [(1.5, 0.4, 1.0), (-2.0, 1.0, 0.0), (0.7, -0.3, 1.0)]:
    h = 1e-6
    numeric = (neuron_loss(x0, w0 + h, t0) - neuron_loss(x0, w0 - h, t0)) / (2 * h)
    got = grad_w(x0, w0, t0)
    assert np.isclose(got, numeric, atol=1e-5), f"At x={x0}, w={w0}, t={t0} the gradient should be about {numeric:.5f}, but grad_w returned {got:.5f}."
--- hint
Three chained steps: the squared error gives `2 * (s - t)`, the sigmoid gives `s * (1 - s)`, and the inside `w * x` gives `x`.
--- hint
`2 * (s - t) * s * (1 - s) * x`, where `s` is the sigmoid of `w * x`.
```

```python debug missing-inner id=missing-inner title="Forgot the inside"
def dh(x):
    # h(x) = sin(x ** 2), so h''(x) = cos(x ** 2) * 2x
    return np.cos(x ** 2)

x = 1.2
print("derivative at 1.2:", round(dh(x), 4))
--- solution
def dh(x):
    # h(x) = sin(x ** 2), so h''(x) = cos(x ** 2) * 2x
    return np.cos(x ** 2) * 2 * x

x = 1.2
print("derivative at 1.2:", round(dh(x), 4))
--- test
def h(t):
    return np.sin(t ** 2)

for x0 in [0.3, 1.2, -0.7]:
    numeric = (h(x0 + 1e-6) - h(x0 - 1e-6)) / 2e-6
    assert np.isclose(dh(x0), numeric, atol=1e-4), f"The derivative at {x0} should be {numeric:.4f}, but dh returned {dh(x0):.4f}."
--- hint
Apply the chain rule. The outside is sin, and the inside is x²: which factor is missing from the answer?
--- hint
The inner derivative of x² is `2x`. Multiply the cosine by it.
```

```python predict id=predict-chain title="Chain rule in action"
x = 0
print(2 * (3 * x + 1) * 3)
--- options
1
* 6
9
0
--- explain
For `y = (3x + 1)²` the chain rule gives `dy/dx = 2(3x + 1) · 3`. At x = 0 this is `2 · 1 · 3 = 6`. The outer derivative 2(3x + 1) and the inner derivative 3 multiply together.
```

## Recap

- The chain rule: the derivative of $f(g(x))$ is $f''(g(x))\,g''(x)$.
- A forward pass computes values through a network; a backward pass multiplies local derivatives from the output back to the weights.
- Backpropagation gives the same gradients as finite differences, but in a single backward sweep.
- The sigmoid''s derivative is at most 0.25, so gradients can vanish through deep stacks.

**Up next:** probability. Models rarely know anything for certain, so they reason about uncertainty, and the next four lessons build the tools to do that.
', 0, '[]', '[]', '2026-06-25T06:04:01.623Z', '2026-10-19T06:04:01.623Z'),
('les_math_for_machine_learning_3_5', 'sec_math_for_machine_learning_3', 'crs_math_for_machine_learning', 'Checkpoint: calculus and optimization', 'quiz', 4, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"At a point x, the gradient of a function f points in the direction of…","options":["Steepest decrease","Steepest increase","No change at all","The minimum of f"],"answerIndex":1,"explanation":"The gradient is the direction of steepest increase. Gradient descent therefore steps in the opposite direction, which is the negative gradient."},{"id":"q2","prompt":"Which expression is the central-difference estimate of f''(x)?","options":["(f(x + h) - f(x)) / h","(f(x + h) - f(x - h)) / h","(f(x + h) - f(x - h)) / (2h)","f(x + h) * f(x - h)"],"answerIndex":2,"explanation":"The central difference uses points on both sides of x, and divides by the full width 2h. Its error shrinks with h², much faster than the one-sided version."},{"id":"q3","prompt":"In gradient descent, what typically happens if the learning rate is set too large?","options":["The updates become exactly zero","The loss can oscillate or diverge instead of decreasing","The model finds the minimum in one step with certainty","The gradient is recomputed with more accuracy"],"answerIndex":1,"explanation":"If a step overshoots the minimum by more than it gains, each update moves further away. For the quadratic in the lesson, a learning rate of 1.1 diverges."},{"id":"q4","prompt":"The chain rule states that the derivative of f(g(x)) is…","options":["f''(x) · g''(x)","f''(g(x)) · g''(x)","f(g''(x))","f''(g(x)) + g''(x)"],"answerIndex":1,"explanation":"Differentiate the outside function, evaluated at the inside, then multiply by the derivative of the inside function."},{"id":"q5","prompt":"The derivative of the sigmoid σ(z) = 1 / (1 + e⁻ᶻ) is…","options":["σ(z)","1 - σ(z)","σ(z) · (1 - σ(z))","σ(z)² + 1"],"answerIndex":2,"explanation":"σ''(z) = σ(z)(1 - σ(z)). Its largest value is 0.25 at z = 0, which contributes to the vanishing-gradient problem in deep networks."}]', '[]', '2026-06-25T06:04:01.623Z', '2026-10-19T06:04:01.623Z'),
('les_math_for_machine_learning_4_1', 'sec_math_for_machine_learning_4', 'crs_math_for_machine_learning', 'Random variables and distributions', 'interactive', 0, 960, NULL, NULL, 'Nothing a model sees is certain. Sensors are noisy, customers are unpredictable and the next word in a sentence could be many things. Probability gives you a language for that uncertainty. A **random variable** is a quantity whose value you don''t know until you observe it, and its **distribution** says which values are likely and which are rare. Two families carry most of the weight in machine learning: the binomial, for counts of successes, and the Gaussian (normal), for measurements that cluster around an average.

By the end of this lesson you will simulate random variables with NumPy, compute exact probabilities from formulas and compare the two, read a probability density, and compute tail probabilities with the error function.

## Simulate first, then calculate

The fastest way to build intuition is to simulate. Flip a fair coin many times and the fraction of heads settles near 0.5. NumPy''s random generator makes this instant. We seed it so that every run is identical.

```python run
import numpy as np

rng = np.random.default_rng(0)

ten_flips = rng.integers(0, 2, size=10)        # 1 = heads, 0 = tails
print("ten flips:", ten_flips)
print("fraction of heads in 10 flips:", ten_flips.mean())

many = rng.integers(0, 2, size=100_000)
print("fraction of heads in 100,000 flips:", round(many.mean(), 4))
```

Ten flips can give any fraction. A hundred thousand flips land very close to one half. That tightening is the Law of Large Numbers, and you will meet it again in the next lesson.

## Discrete distributions: the probability mass function

A discrete random variable takes values you can list, such as the number of heads in $n$ flips. Its **probability mass function** (PMF) gives the probability of each value. For the binomial distribution, the number of successes $k$ in $n$ trials with success probability $p$ has

$$
P(X = k) = \binom{n}{k} p^k (1 - p)^{n - k}
$$

Let''s check the formula against a simulation of 100,000 experiments, each with 10 flips.

```python run
from math import comb

n, p = 10, 0.5
simulated = rng.binomial(n, p, size=100_000)

for k in [3, 5, 7]:
    exact = comb(n, k) * p ** k * (1 - p) ** (n - k)
    print(f"P(X = {k}): simulated {np.mean(simulated == k):.4f}   exact {exact:.4f}")
```

The simulated frequencies match the exact probabilities. The formula is a prediction, and the simulation is an experiment that confirms it.

## Continuous distributions: the probability density

A continuous variable, such as a height or a temperature, can take any value in a range, so the probability of exactly one value is zero. Instead we use a **probability density function** (PDF): probabilities are areas under the curve. The Gaussian density is

$$
f(x) = \frac{1}{\sigma\sqrt{2\pi}}\exp\!\left(-\frac{(x - \mu)^2}{2\sigma^2}\right)
$$

with mean $\mu$ and standard deviation $\sigma$. The histogram below overlays the formula on 5,000 samples.

```python run
import matplotlib.pyplot as plt

def gaussian_pdf(x, mu=0.0, sigma=1.0):
    return np.exp(-(x - mu) ** 2 / (2 * sigma ** 2)) / (sigma * np.sqrt(2 * np.pi))

samples = rng.normal(loc=0.0, scale=1.0, size=5000)
xs = np.linspace(-4, 4, 300)

fig, ax = plt.subplots()
ax.hist(samples, bins=40, density=True, alpha=0.5, label="5,000 samples")
ax.plot(xs, gaussian_pdf(xs), color="tab:red", label="the density formula")
ax.set_xlabel("x"); ax.legend()
plt.show()
```

The bars follow the curve, so the formula describes the samples well.

## Areas are probabilities

The probability that $X$ falls between $-1$ and $1$ is the area under the curve between those points. We can estimate that area by integrating the density numerically with the trapezoid rule.

```python run
xs = np.linspace(-1, 1, 2001)
area = np.trapezoid(gaussian_pdf(xs), xs)
print("P(-1 < X < 1) ≈", round(area, 4))
print("from the samples:", round(np.mean(np.abs(samples) < 1), 3))
```

About 68% of a standard Gaussian lies within one standard deviation of the mean. This "68–95–99.7" rule is a good mental anchor.

> **Pitfall:** a density can be larger than 1. The Gaussian density at its peak is about 0.4 for $\sigma = 1$, but about 4 for $\sigma = 0.1$, because a narrow curve concentrates the same total area into less width. Only areas, not heights, are probabilities.

## Challenges

```python exercise id=binomial-pmf title="A binomial probability"
from math import comb

# TODO: `binom_pmf(k, n, p)` should return P(X = k) for a binomial with n trials and
# success probability p, using comb(n, k) * p**k * (1 - p)**(n - k).
def binom_pmf(k, n, p):
    ...
--- solution
from math import comb

def binom_pmf(k, n, p):
    return comb(n, k) * p ** k * (1 - p) ** (n - k)
--- test
result = binom_pmf(2, 4, 0.5)
assert result is not None, "Replace the `...` in `binom_pmf` with code that returns the probability."
assert np.isclose(result, 0.375), f"With 4 fair flips, P(2 heads) is 6/16 = 0.375, but binom_pmf returned {result!r}."
total = sum(binom_pmf(k, 6, 0.3) for k in range(7))
assert np.isclose(total, 1.0), f"The probabilities over every k should add up to 1, but they add up to {total!r}."
--- hint
`comb(n, k)` counts the ways to choose which trials are successes. Multiply by the probability of one particular arrangement.
--- hint
The formula is `comb(n, k) * p**k * (1 - p)**(n - k)`.
```

```python exercise id=tail-probability title="Tail probability of a Gaussian"
from math import erf, sqrt

# TODO: `prob_above(mu, sigma, threshold)` should return P(X > threshold) for a Gaussian
# with mean mu and standard deviation sigma. Use the error function:
#   P(X > t) = 0.5 * (1 - erf((t - mu) / (sigma * sqrt(2))))
def prob_above(mu, sigma, threshold):
    ...
--- solution
from math import erf, sqrt

def prob_above(mu, sigma, threshold):
    return 0.5 * (1 - erf((threshold - mu) / (sigma * sqrt(2))))
--- test
result = prob_above(0.0, 1.0, 1.0)
assert result is not None, "Replace the `...` in `prob_above` with code that returns the probability."
assert np.isclose(result, 0.158655, atol=1e-5), f"P(X > 1) for a standard Gaussian is about 0.158655, but prob_above returned {result!r}."
assert np.isclose(prob_above(10.0, 2.0, 12.0), 0.158655, atol=1e-5), "A threshold one standard deviation above the mean (10 + 2 = 12) should give the same tail."
assert np.isclose(prob_above(5.0, 3.0, 5.0), 0.5, atol=1e-9), "Half of a Gaussian lies above its mean."
--- hint
Standardize first: `(threshold - mu) / sigma` counts the standard deviations above the mean.
--- hint
Convert to standard units, then apply `erf` with `sigma * sqrt(2)` in the denominator.
```

```python debug scale-vs-variance id=scale-vs-variance title="Too spread out"
rng = np.random.default_rng(1)
variance = 4.0          # we want a standard deviation of 2
samples = rng.normal(loc=0.0, scale=variance, size=50_000)
print("std of samples:", round(samples.std(), 2))
--- solution
rng = np.random.default_rng(1)
variance = 4.0          # we want a standard deviation of 2
samples = rng.normal(loc=0.0, scale=np.sqrt(variance), size=50_000)
print("std of samples:", round(samples.std(), 2))
--- test
assert np.isclose(samples.std(), 2.0, atol=0.05), f"The samples should have standard deviation 2, but their standard deviation is {samples.std():.3f}."
--- hint
The printed standard deviation is about 4, which is the variance. `scale` in `rng.normal` expects the standard deviation.
--- hint
Pass `scale=np.sqrt(variance)`.
```

```python predict id=predict-mean title="The average of a Bernoulli sample"
flips = np.array([1, 0, 1, 1])
print(flips.mean())
--- options
* 0.75
0.5
3
1.0
--- explain
Three of the four flips are heads, so the average is 3/4 = 0.75. For a sequence of 0s and 1s, the mean is the fraction of successes, which estimates the probability p.
```

```python predict id=predict-comb title="Counting arrangements"
from math import comb
print(comb(5, 2))
--- options
5
* 10
20
7
--- explain
`comb(5, 2)` is the number of ways to choose 2 of 5 items without regard to order: `5! / (2! · 3!) = 10`.
```

## Recap

- A random variable has a distribution: the probabilities of its values.
- Simulation with a seeded generator builds intuition; formulas give exact answers.
- A discrete distribution has a PMF that gives probabilities directly. The binomial counts successes.
- A continuous distribution has a density, and probabilities are areas under it. The Gaussian is the central example.
- The Gaussian''s standard deviation is the `scale` argument in NumPy, not the variance.

**Up next:** expectation, variance and covariance. These three numbers summarize any distribution, and they are the building blocks of every loss function.
', 0, '[]', '[]', '2026-06-25T06:04:01.623Z', '2026-10-19T06:04:01.623Z'),
('les_math_for_machine_learning_4_2', 'sec_math_for_machine_learning_4', 'crs_math_for_machine_learning', 'Expectation, variance and covariance', 'interactive', 1, 960, NULL, NULL, 'Three numbers summarize almost everything you need to know about a random quantity. The **expectation** is its long-run average. The **variance** measures how far single draws typically stray from that average. The **covariance** tells you whether two quantities rise and fall together. These three ideas sit underneath every loss function, every statistical test and every dimensionality reduction method in this course.

By the end of this lesson you will compute expectations and variances from distributions and from data, use linearity to transform random quantities, and measure how two features co-vary, the foundation of the covariance matrix you met in PCA.

## Expectation: the probability-weighted average

The expectation of a discrete random variable is each value times its probability, summed:

$$
\mathbb{E}[X] = \sum_x x\, P(X = x)
$$

A fair die shows each face with probability $\frac{1}{6}$, so its expectation is $3.5$. The die never shows 3.5, but over many rolls the average approaches it.

```python run
import numpy as np

faces = np.arange(1, 7)
probs = np.full(6, 1 / 6)
expected = np.dot(faces, probs)
print("E[die] =", expected)
```

That last calculation is a dot product, which you met in the first lesson. Expectation is a weighted sum, and weighted sums are dot products.

The **Law of Large Numbers** says that sample averages converge to the expectation. Watch it happen.

```python run
rng = np.random.default_rng(0)
for n in [10, 1000, 100_000]:
    rolls = rng.integers(1, 7, size=n)
    print(f"n = {n:>7,}: sample mean = {rolls.mean():.3f}")
```

## Variance: how far draws stray

The variance is the expected squared distance from the mean:

$$
\operatorname{Var}(X) = \mathbb{E}\big[(X - \mu)^2\big] = \mathbb{E}[X^2] - \mu^2
$$

The second form is often easier to compute. Its square root is the standard deviation, which is in the same units as $X$.

```python run
var = np.dot(faces ** 2, probs) - expected ** 2
print("Var(die) =", round(var, 4), "| standard deviation =", round(np.sqrt(var), 4))
```

## Covariance: do two things move together?

For two random variables, the **covariance** is the expected product of their deviations from their means. Positive covariance means they tend to be high together; negative means one is high when the other is low.

$$
\operatorname{Cov}(X, Y) = \mathbb{E}\big[(X - \mu_X)(Y - \mu_Y)\big]
$$

Let''s look at hours studied and exam scores, which we have simulated to be related.

```python run
rng = np.random.default_rng(2)
hours = rng.uniform(0, 10, 200)
score = 50 + 4 * hours + rng.normal(0, 5, 200)

print("covariance matrix:")
print(np.cov(hours, score).round(2))
print("correlation:", round(np.corrcoef(hours, score)[0, 1], 3))
```

The covariance matrix contains the variance of each variable on its diagonal and the covariance between them off the diagonal. The **correlation** rescales the covariance to lie between $-1$ and $1$, so it is easier to interpret.

```python run
import matplotlib.pyplot as plt

fig, ax = plt.subplots()
ax.scatter(hours, score, s=10, alpha=0.6)
ax.set_xlabel("hours studied"); ax.set_ylabel("exam score"); ax.grid(alpha=0.3)
plt.show()
```

> **Pitfall:** correlation measures *linear* association only, and it says nothing about causation. Hours studied and scores move together here because we built them that way. In real data, always look at the plot.

## Linearity: transforming random variables

Expectation is **linear**: $\mathbb{E}[aX + b] = a\,\mathbb{E}[X] + b$, always, whether or not the variables are independent. Variance scales with the square of the multiplier and ignores shifts: $\operatorname{Var}(aX + b) = a^2 \operatorname{Var}(X)$.

```python run
x = rng.normal(0, 1, 100_000)
y = 3 * x + 10
print("mean of y:", round(y.mean(), 2), "(expected 10)")
print("variance of y:", round(y.var(), 2), "(expected 3² · 1 = 9)")
```

These two rules make standardization work: $(X - \mu)/\sigma$ has mean 0 and variance 1. You used exactly that in the broadcasting lesson.

## Challenges

```python exercise id=expectation title="Expectation of a discrete variable"
# TODO: `expectation(values, probs)` should return the expected value of a discrete
# random variable that takes `values` with probabilities `probs`.
def expectation(values, probs):
    ...
--- solution
def expectation(values, probs):
    return np.dot(values, probs)
--- test
result = expectation([0.0, 1.0, 2.0], [0.5, 0.25, 0.25])
assert result is not None, "Replace the `...` in `expectation` with code that returns the expected value."
assert np.isclose(result, 0.75), f"0·0.5 + 1·0.25 + 2·0.25 = 0.75, but expectation returned {result!r}."
assert np.isclose(expectation([10.0, -4.0], [0.2, 0.8]), -1.2), "With values 10 and -4, the expectation is 10·0.2 + (-4)·0.8 = -1.2."
--- hint
Multiply each value by its probability and add them up. NumPy does both steps with a dot product.
--- hint
`np.dot(values, probs)`.
```

```python exercise id=covariance title="Covariance from scratch"
# TODO: `covariance(x, y)` should return the population covariance of x and y:
# the mean of (x - mean(x)) * (y - mean(y)). Don''t use np.cov.
def covariance(x, y):
    ...
--- solution
def covariance(x, y):
    x = np.asarray(x, dtype=float)
    y = np.asarray(y, dtype=float)
    return np.mean((x - x.mean()) * (y - y.mean()))
--- test
rng = np.random.default_rng(11)
x = rng.normal(size=500)
y = 0.5 * x + rng.normal(size=500)
result = covariance(x, y)
assert result is not None, "Replace the `...` in `covariance` with code that returns the covariance."
assert np.isclose(result, np.cov(x, y, bias=True)[0, 1]), f"covariance should match np.cov(x, y, bias=True), but it returned {result!r}."
assert np.isclose(covariance([1.0, 2.0, 3.0], [1.0, 2.0, 3.0]), 2 / 3), "The covariance of a variable with itself is its variance, here 2/3."
--- hint
Subtract each mean from its variable, multiply the two deviation arrays elementwise, then take the mean.
--- hint
`np.mean((x - x.mean()) * (y - y.mean()))`.
```

```python exercise id=correlation title="Correlation from scratch"
# TODO: `correlation(x, y)` should return the Pearson correlation coefficient:
# covariance(x, y) / (std(x) * std(y)), with population standard deviations.
def correlation(x, y):
    ...
--- solution
def correlation(x, y):
    x = np.asarray(x, dtype=float)
    y = np.asarray(y, dtype=float)
    cov = np.mean((x - x.mean()) * (y - y.mean()))
    return cov / (x.std() * y.std())
--- test
rng = np.random.default_rng(12)
x = rng.normal(size=300)
y = -2.0 * x + rng.normal(size=300)
result = correlation(x, y)
assert result is not None, "Replace the `...` in `correlation` with code that returns the correlation."
assert np.isclose(result, np.corrcoef(x, y)[0, 1]), f"correlation should match np.corrcoef, but it returned {result!r}."
assert np.isclose(correlation([1.0, 2.0, 3.0], [2.0, 4.0, 6.0]), 1.0), "Perfectly linear data have correlation 1."
--- hint
Divide your covariance by the product of the two standard deviations. `x.std()` already gives the population standard deviation.
--- hint
`cov / (x.std() * y.std())`, where `cov` is the covariance you wrote in the previous challenge.
```

```python debug uncentered-covariance id=uncentered-covariance title="Covariance that is far too large"
x = np.array([10.0, 12.0, 14.0, 16.0, 18.0])
y = np.array([20.0, 21.0, 23.0, 26.0, 27.0])

# Covariance: the average of (x - mean x) * (y - mean y)
cov_xy = np.mean(x * y)
print("cov:", round(cov_xy, 3))
print("np.cov (bias=True):", round(np.cov(x, y, bias=True)[0, 1], 3))
--- solution
x = np.array([10.0, 12.0, 14.0, 16.0, 18.0])
y = np.array([20.0, 21.0, 23.0, 26.0, 27.0])

# Covariance: the average of (x - mean x) * (y - mean y)
cov_xy = np.mean((x - x.mean()) * (y - y.mean()))
print("cov:", round(cov_xy, 3))
print("np.cov (bias=True):", round(np.cov(x, y, bias=True)[0, 1], 3))
--- test
assert np.isclose(cov_xy, np.cov(x, y, bias=True)[0, 1]), f"cov_xy should match np.cov, which is {np.cov(x, y, bias=True)[0, 1]:.3f}, but it is {cov_xy:.3f}."
--- hint
`np.mean(x * y)` is the average of the raw products, not of the deviations. Covariance centers each variable first.
--- hint
Replace `x * y` with the product of the deviations: `(x - x.mean()) * (y - y.mean())`.
```

```python predict id=predict-linearity title="Scaling and shifting a variable"
X = np.array([1.0, 2.0, 3.0, 4.0])
Y = 2 * X + 1
print(Y.mean(), Y.var())
--- options
* 6.0 5.0
6.0 20.0
5.0 5.0
6.0 10.0
--- explain
Y is `[3, 5, 7, 9]`, with mean 6. Its deviations are -3, -1, 1, 3, and their squares average to `(9 + 1 + 1 + 9) / 4 = 5`. Doubling X doubles the mean''s contribution, and the variance grows by 2² = 4 times, while the shift +1 changes the mean but not the variance.
```

## Recap

- Expectation is the probability-weighted average. Over many draws, sample means converge to it.
- Variance is the expected squared distance from the mean, $\mathbb{E}[X^2] - \mu^2$.
- Covariance measures how two variables move together, and correlation rescales it to $[-1, 1]$.
- Expectation is linear. Variance scales by the square of the multiplier and ignores shifts.

**Up next:** Bayes'' rule, the formula for updating a belief when new evidence arrives.
', 0, '[]', '[]', '2026-06-25T06:04:01.623Z', '2026-10-19T06:04:01.623Z'),
('les_math_for_machine_learning_4_3', 'sec_math_for_machine_learning_4', 'crs_math_for_machine_learning', 'Bayes'' rule: updating beliefs with evidence', 'interactive', 2, 960, NULL, NULL, 'A medical test comes back positive. The test is 95% accurate. Should you panic? Most people say yes, and most people are wrong: if the disease is rare, the answer is probably not. The reason is **Bayes'' rule**, the formula for updating a belief when evidence arrives. It is the foundation of spam filters, diagnostic tools, probabilistic programming and every Bayesian method in machine learning.

By the end of this lesson you will apply Bayes'' rule to a real-world test, verify the answer with a simulated population, update a belief one observation at a time on a grid, and build a naive Bayes spam score.

## The base-rate trap

Suppose a disease affects 1 in 100 people. A test detects it 95% of the time when it is present (sensitivity), and wrongly flags 5% of healthy people (false-positive rate). You test positive. What is the chance you are sick?

```python run
import numpy as np

prevalence = 0.01          # P(disease)
sensitivity = 0.95         # P(positive | disease)
false_positive = 0.05      # P(positive | no disease)

p_positive = sensitivity * prevalence + false_positive * (1 - prevalence)
posterior = sensitivity * prevalence / p_positive

print(f"P(positive) = {p_positive:.4f}")
print(f"P(disease | positive) = {posterior:.4f}")
```

The answer is about 16%, not 95%. Most positive results come from the large healthy population, which produces many false alarms, and that outweighs the small sick population.

## Bayes'' rule

Bayes'' rule converts the probability of the evidence given the hypothesis into the probability of the hypothesis given the evidence.

$$
P(A \mid B) = \frac{P(B \mid A)\, P(A)}{P(B)}
$$

The denominator, $P(B)$, is found by the **law of total probability**: sum the evidence over both possibilities for $A$. Here $P(\text{positive}) = P(+ \mid \text{sick})P(\text{sick}) + P(+ \mid \text{healthy})P(\text{healthy})$, which is exactly the `p_positive` line above.

## Check it with a simulated population

Simulation is the best defence against a wrong formula. Create 200,000 people, give each their true status and then a test result, and count.

```python run
rng = np.random.default_rng(0)
N = 200_000
sick = rng.random(N) < prevalence
positive = np.where(sick, rng.random(N) < sensitivity, rng.random(N) < false_positive)

print("simulated P(disease | positive):", round(sick[positive].mean(), 4))
print("formula:                        ", round(posterior, 4))
```

The simulated fraction agrees with the formula. You can trust Bayes'' rule because you can reproduce it by counting.

## Updating a belief, one observation at a time

Bayes'' rule can run repeatedly. Each posterior becomes the prior for the next observation. Here we infer a coin''s unknown bias $p$ on a grid of possible values. We start with no preference (a uniform prior), observe 7 heads and 3 tails, and multiply the prior by the likelihood $p^{h}(1-p)^{t}$ at every grid point.

```python run
import matplotlib.pyplot as plt

grid = np.linspace(0, 1, 501)              # possible values of p = P(heads)
prior = np.ones_like(grid) / grid.size     # every value equally likely at first

def update(belief, heads, tails):
    likelihood = grid ** heads * (1 - grid) ** tails
    posterior = belief * likelihood
    return posterior / posterior.sum()

after_10 = update(prior, heads=7, tails=3)
print("most probable p after 7 heads and 3 tails:", round(float(grid[np.argmax(after_10)]), 3))

fig, ax = plt.subplots()
ax.plot(grid, prior, "--", label="prior: no idea")
ax.plot(grid, after_10, label="posterior after 10 flips")
ax.set_xlabel("p"); ax.legend(); ax.grid(alpha=0.3)
plt.show()
```

The posterior is a curve centred near 0.7, and it is narrower than the flat prior. Evidence concentrates belief.

> **Tip:** the grid approach works for any model you can write down. Real systems use exact formulas or sampling, but the logic is the same: prior times likelihood, then normalize.

## Naive Bayes: many clues at once

A spam filter sees many words. If we assume the words are independent given the class (the "naive" part), the posterior odds multiply:

$$
P(\text{spam} \mid w_1, \dots, w_k) \propto P(\text{spam}) \prod_i P(w_i \mid \text{spam})
$$

The normalization divides by the same product computed for "not spam" too.

```python run
def spam_probability(p_spam, likelihoods_spam, likelihoods_ham):
    spam_score = p_spam * np.prod(likelihoods_spam)
    ham_score = (1 - p_spam) * np.prod(likelihoods_ham)
    return spam_score / (spam_score + ham_score)

# Words "free" and "meeting": how likely each is in spam and in legitimate mail
print("P(spam | free, meeting):", round(spam_probability(0.4, [0.6, 0.05], [0.1, 0.3]), 3))
```

The word "free" is common in spam and rare in legitimate mail, so it pushes the score up. "Meeting" does the opposite, and the combined probability reflects both.

## Challenges

```python exercise id=posterior-positive title="The probability of disease after a positive test"
# TODO: `posterior_positive(prevalence, sensitivity, false_positive)` should return
# P(disease | positive), using the law of total probability in the denominator.
def posterior_positive(prevalence, sensitivity, false_positive):
    ...
--- solution
def posterior_positive(prevalence, sensitivity, false_positive):
    p_positive = sensitivity * prevalence + false_positive * (1 - prevalence)
    return sensitivity * prevalence / p_positive
--- test
result = posterior_positive(0.01, 0.95, 0.05)
assert result is not None, "Replace the `...` in `posterior_positive` with code that returns the probability."
assert np.isclose(result, 0.161, atol=1e-3), f"With a 1% prevalence, a 95% sensitivity and a 5% false-positive rate, P(disease | positive) is about 0.161, but you returned {result!r}."
assert np.isclose(posterior_positive(0.5, 0.9, 0.1), 0.9), "With prevalence 50%, sensitivity 0.9 and false-positive rate 0.1, P(disease | positive) should be 0.9."
--- hint
The denominator is the chance of a positive result from either group: sick people who test positive, plus healthy people who test positive.
--- hint
`p_positive = sensitivity * prevalence + false_positive * (1 - prevalence)`, then divide the sick-and-positive term by `p_positive`.
```

```python exercise id=grid-belief title="Update a belief on a grid"
# TODO: `update_belief(belief, grid, heads, tails)` should multiply the belief by the
# likelihood grid**heads * (1 - grid)**tails and return the normalized posterior.
def update_belief(belief, grid, heads, tails):
    ...
--- solution
def update_belief(belief, grid, heads, tails):
    posterior = belief * grid ** heads * (1 - grid) ** tails
    return posterior / posterior.sum()
--- test
grid = np.linspace(0, 1, 101)
prior = np.ones_like(grid) / grid.size
result = update_belief(prior, grid, heads=6, tails=4)
assert result is not None, "Replace the `...` in `update_belief` with code that returns the posterior."
assert np.isclose(result.sum(), 1.0), f"A posterior must sum to 1, but yours sums to {result.sum()!r}."
assert abs(grid[np.argmax(result)] - 0.6) < 0.011, f"With a flat prior, 6 heads and 4 tails peak at p = 0.6, but your peak is at {grid[np.argmax(result)]}."
second = update_belief(result, grid, heads=0, tails=0)
assert np.allclose(second, result), "With no new data, the posterior should not change."
--- hint
Multiply the belief by `grid ** heads * (1 - grid) ** tails` elementwise, then divide by the total so the result sums to 1.
--- hint
`posterior = belief * grid ** heads * (1 - grid) ** tails`, then `posterior / posterior.sum()`.
```

```python exercise id=naive-spam title="Naive Bayes spam probability"
# TODO: `spam_probability(p_spam, likelihoods_spam, likelihoods_ham)` should return
# P(spam | words) under the naive independence assumption. `likelihoods_spam` holds
# P(word | spam) for each word, and `likelihoods_ham` holds P(word | not spam).
def spam_probability(p_spam, likelihoods_spam, likelihoods_ham):
    ...
--- solution
def spam_probability(p_spam, likelihoods_spam, likelihoods_ham):
    spam_score = p_spam * np.prod(likelihoods_spam)
    ham_score = (1 - p_spam) * np.prod(likelihoods_ham)
    return spam_score / (spam_score + ham_score)
--- test
result = spam_probability(0.4, [0.6, 0.05], [0.1, 0.3])
assert result is not None, "Replace the `...` in `spam_probability` with code that returns the probability."
assert np.isclose(result, 0.4), f"With these numbers P(spam | words) = 0.012 / (0.012 + 0.018) = 0.4, but you returned {result!r}."
assert np.isclose(spam_probability(0.2, [0.8], [0.1]), 2 / 3), "With prior 0.2 and one word, the answer should be 2/3."
--- hint
Compute the score for spam as prior times the product of the spam likelihoods, and the score for ham the same way. Then divide the spam score by the sum of both.
--- hint
`np.prod` multiplies a list of numbers together.
```

```python debug denominator-bug id=denominator-bug title="Too confident"
prevalence = 0.01
sensitivity = 0.95
false_positive = 0.05

# P(disease | positive) = P(positive | disease) P(disease) / P(positive)
p_positive = sensitivity * prevalence     # P(positive)
posterior = sensitivity * prevalence / p_positive
print("P(disease | positive):", round(posterior, 3))
--- solution
prevalence = 0.01
sensitivity = 0.95
false_positive = 0.05

# P(disease | positive) = P(positive | disease) P(disease) / P(positive)
p_positive = sensitivity * prevalence + false_positive * (1 - prevalence)
posterior = sensitivity * prevalence / p_positive
print("P(disease | positive):", round(posterior, 3))
--- test
assert np.isclose(posterior, 0.161, atol=1e-3), f"P(disease | positive) should be about 0.161, but it is {posterior:.3f}."
--- hint
A posterior of 1.0 means a positive test proves disease, which cannot be right with a 5% false-positive rate. Check which healthy people also test positive.
--- hint
`P(positive)` has two parts: sick people who test positive, and healthy people who test positive. The second part is missing.
```

```python predict id=predict-bayes title="Bayes by hand"
p_a = 0.5
p_b_given_a = 0.8
p_b_given_not_a = 0.2
p_a_given_b = p_b_given_a * p_a / (p_b_given_a * p_a + p_b_given_not_a * (1 - p_a))
print(round(p_a_given_b, 2))
--- options
0.5
0.2
* 0.8
0.6
--- explain
The numerator is 0.8 × 0.5 = 0.4. The denominator is 0.4 + 0.2 × 0.5 = 0.5. Dividing gives 0.4 / 0.5 = 0.8.
```

## Recap

- Bayes'' rule: $P(A \mid B) = P(B \mid A)P(A) / P(B)$. The posterior combines prior belief and evidence.
- The base-rate effect: when a condition is rare, most positive results can be false, even with an accurate test.
- Check a formula by simulating a population and counting.
- Repeated updating multiplies the prior by each likelihood and renormalizes.
- Naive Bayes multiplies per-word likelihoods, assuming the words are independent given the class.

**Up next:** maximum likelihood, the principle that turns Bayes'' likelihood into a way of fitting models to data.
', 0, '[]', '[]', '2026-06-25T06:04:01.623Z', '2026-10-19T06:04:01.623Z'),
('les_math_for_machine_learning_4_4', 'sec_math_for_machine_learning_4', 'crs_math_for_machine_learning', 'Maximum likelihood: fitting models to data', 'interactive', 3, 1080, NULL, NULL, 'You have a model with unknown parameters and some data. Which parameters should you choose? **Maximum likelihood estimation** (MLE) gives a principled answer: choose the parameters that make the observed data most probable. It sounds almost too simple, and yet it is hidden inside nearly every loss function you will meet. Mean squared error is maximum likelihood with Gaussian noise. Cross-entropy, the loss used for classifiers, is maximum likelihood with a Bernoulli model.

By the end of this lesson you will find maximum likelihood estimates by grid search and by formula, estimate the parameters of a Gaussian from data, show that least squares is maximum likelihood, and use log-likelihoods to avoid numerical underflow.

## Likelihood: how probable is the data?

Suppose you flip a coin 10 times and see 7 heads. For a coin with heads probability $p$, the probability of exactly this sequence is $p^7 (1 - p)^3$. As a function of $p$, this is the **likelihood**. The maximum likelihood estimate is the value of $p$ that makes it largest.

```python run
import numpy as np
import matplotlib.pyplot as plt

data = np.array([1, 1, 1, 0, 1, 1, 1, 0, 1, 0])     # 7 heads, 3 tails
heads = data.sum()
tails = len(data) - heads

grid = np.linspace(0.001, 0.999, 999)
log_likelihood = heads * np.log(grid) + tails * np.log(1 - grid)
best = grid[np.argmax(log_likelihood)]
print("maximum likelihood estimate of p:", round(float(best), 3))

fig, ax = plt.subplots()
ax.plot(grid, log_likelihood)
ax.axvline(best, color="tab:red", ls="--")
ax.set_xlabel("p"); ax.set_ylabel("log-likelihood"); ax.grid(alpha=0.3)
plt.show()
```

The curve peaks at 0.7. We used the **log**-likelihood: it has the same maximum, because the logarithm is increasing, and it turns products into sums, which is much better behaved numerically.

## The formula behind the peak

For a coin, the maximum likelihood estimate is simply the fraction of heads. You can derive it by setting the derivative of the log-likelihood to zero, but the answer is intuitive: the most probable $p$ is the observed frequency.

```python run
print("fraction of heads:", heads / len(data))
```

Setting the derivative of the log-likelihood to zero is the general recipe. For many models, this gives the answer in closed form. For others, the gradient descent you already know finds it.

## Gaussians: the mean and the variance

For measurements that follow a Gaussian distribution, the maximum likelihood estimates are the sample mean and the variance that divides by $n$ rather than $n - 1$.

$$
\hat{\mu} = \frac{1}{n}\sum_i x_i, \qquad \hat{\sigma}^2 = \frac{1}{n}\sum_i (x_i - \hat{\mu})^2
$$

```python run
rng = np.random.default_rng(5)
measurements = rng.normal(loc=10.0, scale=2.0, size=500)

mu_hat = measurements.mean()
sigma_hat = np.sqrt(np.mean((measurements - mu_hat) ** 2))
print(f"mu_hat = {mu_hat:.3f}, sigma_hat = {sigma_hat:.3f}   (true values: 10 and 2)")
print("matches np.std (which divides by n):", np.isclose(sigma_hat, measurements.std()))
```

> **Pitfall:** NumPy''s `np.var` and `np.std` divide by $n$ by default, which is the maximum likelihood choice. The "unbiased" version divides by $n - 1$ and is set with `ddof=1`. Both are valid; know which one your code uses.

## Least squares is maximum likelihood

Suppose the data follow $y = wx + b + \varepsilon$, where the noise $\varepsilon$ is Gaussian. The likelihood of the data is largest when the sum of squared errors is smallest. So fitting by least squares is the same as maximum likelihood under Gaussian noise. Let''s check that least squares recovers the right line.

```python run
rng = np.random.default_rng(1)
x = rng.uniform(-2, 2, 200)
y = 1.5 * x + 0.5 + rng.normal(0, 0.5, 200)

X = np.column_stack([x, np.ones_like(x)])
w_ls = np.linalg.lstsq(X, y, rcond=None)[0]
print("least-squares slope and intercept:", np.round(w_ls, 3), "(true values: 1.5 and 0.5)")
```

## Cross-entropy: maximum likelihood for classifiers

When each label is 0 or 1, the natural model is a Bernoulli distribution with a predicted probability $\hat{p}_i$ for each sample. The negative log-likelihood of that model is the **cross-entropy**, the loss used to train almost every classifier.

$$
\text{CE} = -\frac{1}{n}\sum_i \bigl[y_i \log \hat{p}_i + (1 - y_i)\log(1 - \hat{p}_i)\bigr]
$$

```python run
def cross_entropy(y_true, p_pred):
    return -np.mean(y_true * np.log(p_pred) + (1 - y_true) * np.log(1 - p_pred))

y_true = np.array([1, 0, 1, 1])
good = np.array([0.9, 0.1, 0.8, 0.95])
bad = np.array([0.4, 0.6, 0.3, 0.5])
print("good model:", round(cross_entropy(y_true, good), 3))
print("bad model: ", round(cross_entropy(y_true, bad), 3))
```

Confident, correct predictions give a small loss. Confident, wrong predictions are punished heavily, because the logarithm of a small probability is very negative.

## Challenges

```python exercise id=bernoulli-loglik title="Bernoulli log-likelihood"
# TODO: `bernoulli_log_likelihood(p, data)` should return the log-likelihood of the 0/1
# array `data` under a Bernoulli model with probability p:
#   sum over i of  data_i * log(p) + (1 - data_i) * log(1 - p)
def bernoulli_log_likelihood(p, data):
    ...
--- solution
def bernoulli_log_likelihood(p, data):
    data = np.asarray(data, dtype=float)
    return np.sum(data * np.log(p) + (1 - data) * np.log(1 - p))
--- test
result = bernoulli_log_likelihood(0.5, [1, 0, 1, 1])
assert result is not None, "Replace the `...` in `bernoulli_log_likelihood` with code that returns the log-likelihood."
assert np.isclose(result, 4 * np.log(0.5)), f"Four flips with p = 0.5 give a log-likelihood of 4·log(0.5) = {4 * np.log(0.5):.4f}, but you returned {result!r}."
assert np.isclose(bernoulli_log_likelihood(0.7, [1, 1, 0]), 2 * np.log(0.7) + np.log(0.3)), "Check a second case: p = 0.7 with data [1, 1, 0]."
--- hint
Compute the two terms for every point, `data * log(p)` and `(1 - data) * log(1 - p)`, add them, and sum over the data.
--- hint
`np.sum(data * np.log(p) + (1 - data) * np.log(1 - p))`.
```

```python exercise id=gaussian-mle title="Maximum likelihood for a Gaussian"
# TODO: `gaussian_mle(data)` should return (mu_hat, sigma_hat), the maximum likelihood
# estimates of the mean and standard deviation of a Gaussian. Divide by n, not n - 1.
def gaussian_mle(data):
    ...
--- solution
def gaussian_mle(data):
    data = np.asarray(data, dtype=float)
    mu = data.mean()
    sigma = np.sqrt(np.mean((data - mu) ** 2))
    return mu, sigma
--- test
data = [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0]
result = gaussian_mle(data)
assert result is not None, "Replace the `...` in `gaussian_mle` with code that returns (mu, sigma)."
mu, sigma = result
assert np.isclose(mu, 5.0), f"The mean of these data is 5, but gaussian_mle returned mu = {mu!r}."
assert np.isclose(sigma, 2.0), f"The population standard deviation of these data is 2 (divide by n), but gaussian_mle returned sigma = {sigma!r}."
--- hint
The mean is `data.mean()`. For the variance, average the squared deviations from that mean, dividing by n.
--- hint
`sigma = np.sqrt(np.mean((data - mu) ** 2))`.
```

```python exercise id=stable-cross-entropy title="Cross-entropy that never takes log(0)"
# TODO: `safe_cross_entropy(y_true, p_pred)` should compute the same cross-entropy as
# before, but clip the predictions to [1e-12, 1 - 1e-12] first, so that the logarithm
# never sees 0 or 1 and the loss stays finite.
def safe_cross_entropy(y_true, p_pred):
    ...
--- solution
def safe_cross_entropy(y_true, p_pred):
    y_true = np.asarray(y_true, dtype=float)
    p = np.clip(np.asarray(p_pred, dtype=float), 1e-12, 1 - 1e-12)
    return -np.mean(y_true * np.log(p) + (1 - y_true) * np.log(1 - p))
--- test
good = safe_cross_entropy([1, 0, 1, 1], [0.9, 0.1, 0.8, 0.95])
assert good is not None, "Replace the `...` in `safe_cross_entropy` with code that returns the loss."
assert np.isclose(good, 0.1213, atol=1e-3), f"The cross-entropy of the good model should be about 0.1213, but you returned {good!r}."
worst = safe_cross_entropy([1, 0], [0.0, 1.0])
assert np.isfinite(worst), "Completely wrong predictions of exactly 0 or 1 should give a large but finite loss. Clip the predictions before taking the logarithm."
assert np.isclose(safe_cross_entropy([1, 0], [1.0, 0.0]), 0.0, atol=1e-6), "Perfect predictions should give a loss close to 0."
--- hint
`np.clip(p, 1e-12, 1 - 1e-12)` keeps every probability strictly inside (0, 1).
--- hint
Clip `p_pred` first, then use the same formula as `cross_entropy`.
```

```python debug log-underflow id=log-underflow title="A likelihood that vanishes"
rng = np.random.default_rng(0)
data = rng.binomial(1, 0.6, size=2000)     # 2000 coin flips with true p = 0.6
p = 0.6

# Likelihood of the data, then its logarithm
likelihood = np.prod(p ** data * (1 - p) ** (1 - data))
log_likelihood = np.log(likelihood)
print("log-likelihood:", log_likelihood)
--- solution
rng = np.random.default_rng(0)
data = rng.binomial(1, 0.6, size=2000)     # 2000 coin flips with true p = 0.6
p = 0.6

# Log-likelihood: the sum of the log probabilities
log_likelihood = np.sum(data * np.log(p) + (1 - data) * np.log(1 - p))
print("log-likelihood:", log_likelihood)
--- test
expected = np.sum(data * np.log(0.6) + (1 - data) * np.log(0.4))
assert np.isfinite(log_likelihood), f"The log-likelihood should be a finite number, but it is {log_likelihood!r}. Multiplying 2000 probabilities underflows to 0."
assert np.isclose(log_likelihood, expected), f"The log-likelihood should be about {expected:.2f}, but it is {log_likelihood!r}."
--- hint
Look at the printed value. A log of exactly 0 becomes minus infinity: the likelihood has underflowed.
--- hint
Multiply 2000 numbers below 1 and the product shrinks below the smallest float. Take logarithms of each factor first, then add them.
```

```python predict id=predict-mle title="The maximum likelihood mean"
print(np.mean([2, 4, 6]))
--- options
* 4.0
2.0
6.0
12.0
--- explain
For a Gaussian, the maximum likelihood estimate of the mean is the sample mean. `(2 + 4 + 6) / 3 = 4`.
```

```python predict id=predict-mle-var title="Dividing by n or by n - 1"
print(np.var([1.0, 3.0]))
--- options
* 1.0
2.0
0.5
4.0
--- explain
The mean is 2 and the squared deviations are both 1. Dividing their sum (2) by n = 2 gives 1.0. Dividing by n - 1 would give 2.0; that is the `ddof=1` version.
```

## Recap

- Maximum likelihood chooses the parameters that make the observed data most probable.
- Work with log-likelihoods: the maximum is the same, and sums replace products, which avoids underflow.
- For a Gaussian, the MLE is the sample mean and the variance divided by $n$.
- Least squares is maximum likelihood under Gaussian noise, and cross-entropy is maximum likelihood for binary labels.

**Up next:** the final assessment. It draws together the whole course.
', 0, '[]', '[]', '2026-06-25T06:04:01.623Z', '2026-10-19T06:04:01.623Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_math_for_machine_learning_4_5', 'sec_math_for_machine_learning_4', 'crs_math_for_machine_learning', 'Final assessment: Mathematics for Machine Learning', 'quiz', 4, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"What is the expected value of a fair six-sided die?","options":["3","3.5","3.67","4"],"answerIndex":1,"explanation":"Each face has probability 1/6, so E[X] = (1 + 2 + 3 + 4 + 5 + 6) / 6 = 3.5, even though the die never shows 3.5."},{"id":"q2","prompt":"For a random variable X and constants a and b, what is Var(aX + b)?","options":["a · Var(X) + b","a² · Var(X)","a · Var(X)","Var(X) + b²"],"answerIndex":1,"explanation":"Shifting by b changes the mean but not the spread. Scaling by a multiplies the standard deviation by |a|, so the variance is multiplied by a²."},{"id":"q3","prompt":"Which expression is Bayes'' rule for P(A | B)?","options":["P(A) P(B | A)","P(B | A) P(A) / P(B)","P(A) + P(B) - P(A and B)","P(B | A) / P(A)"],"answerIndex":1,"explanation":"Bayes'' rule turns the likelihood P(B | A) and the prior P(A) into the posterior P(A | B), normalized by the evidence P(B)."},{"id":"q4","prompt":"A test for a rare disease is 95% sensitive and has a 5% false-positive rate. Why can a positive result still be more likely to be a false alarm than a true case?","options":["Because tests are never accurate","Because the healthy population is so large that its false positives outnumber the true cases","Because positive results are always rounded down","Because sensitivity and specificity must always be equal"],"answerIndex":1,"explanation":"This is the base-rate effect. With 1% prevalence, about 4.95% of everyone is a healthy false positive (99% × 5%), while only about 0.95% is a sick true positive (1% × 95%). Most positives are false."},{"id":"q5","prompt":"What is the maximum likelihood estimate of the success probability p of a Bernoulli model, from observed 0/1 data?","options":["The number of successes","The fraction of successes among the observations","The median of the data","1 - the fraction of successes"],"answerIndex":1,"explanation":"Setting the derivative of the log-likelihood to zero gives p̂ = (number of 1s) / n. This is the observed frequency."},{"id":"q6","prompt":"Least-squares regression is equivalent to maximum likelihood under which noise assumption?","options":["Uniform noise","Gaussian noise","Exponential noise","No noise at all"],"answerIndex":1,"explanation":"The Gaussian log-likelihood is a constant minus a sum of squared errors, so maximizing it is the same as minimizing the squared error."},{"id":"q7","prompt":"Why do practitioners maximize the log-likelihood rather than the likelihood?","options":["The log changes which parameter values are optimal","The log turns products into sums, which avoids numerical underflow, and has the same maximizer","The likelihood cannot be computed","The log makes the likelihood always positive"],"answerIndex":1,"explanation":"The logarithm is increasing, so the maximizer is unchanged. Multiplying many probabilities underflows to zero in floating point, while sums of logs stay finite."},{"id":"q8","prompt":"What is Cov(X, X), the covariance of a variable with itself?","options":["0","1","Var(X)","E[X]"],"answerIndex":2,"explanation":"Covariance measures how two variables vary together. With the same variable twice, that is exactly its variance."},{"id":"q9","prompt":"Within what range does the Pearson correlation coefficient always lie?","options":["From 0 to 1","From -1 to 1","From -∞ to ∞","From -2 to 2"],"answerIndex":1,"explanation":"Correlation is the covariance divided by the product of the standard deviations, which by the Cauchy–Schwarz inequality keeps it between -1 and 1."},{"id":"q10","prompt":"Power iteration, repeatedly multiplying a vector by A and normalizing, converges to which eigenvector?","options":["The eigenvector with the smallest eigenvalue","The eigenvector with the largest absolute eigenvalue","The zero vector","The eigenvector that is orthogonal to the starting vector"],"answerIndex":1,"explanation":"Each multiplication amplifies the component along the dominant eigenvector most strongly, so the direction converges to it, provided the starting vector has a component along it."}]', '[]', '2026-06-25T06:04:01.623Z', '2026-10-19T06:04:01.623Z');

INSERT INTO path_courses (path_id, course_id, position) VALUES
('pth_ml_engineer', 'crs_math_for_machine_learning', 3),
('pth_ai_researcher', 'crs_math_for_machine_learning', 0);

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_math_for_machine_learning_1', 'usr_seed00000b', 'crs_math_for_machine_learning', 5, 'Solid and practical', 'Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I''d take another course from this instructor.', '2026-09-29T19:04:01.623Z', '2026-09-29T19:04:01.623Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000b');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_math_for_machine_learning_2', 'usr_seed00000d', 'crs_math_for_machine_learning', 5, 'Worth every minute', 'Clear, well-paced and incredibly practical. The projects were challenging in the right way, and I used what I learned at work within a week of finishing.', '2026-08-27T12:04:01.623Z', '2026-08-27T12:04:01.623Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000d');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_math_for_machine_learning_3', 'usr_seed00000k', 'crs_math_for_machine_learning', 4, 'Helped me land an ML role', 'I was a backend engineer trying to move into ML. This course gave me the vocabulary and the hands-on confidence to pass technical interviews. Highly recommended.', '2026-10-15T23:04:01.623Z', '2026-10-15T23:04:01.623Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000k');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_math_for_machine_learning_4', 'usr_seed000011', 'crs_math_for_machine_learning', 4, 'Great instructor, great community', 'Questions in the Q&A got thoughtful answers quickly. The notes feature and lesson resources made it easy to review before my exam.', '2026-10-01T15:04:01.623Z', '2026-10-01T15:04:01.623Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000011');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_math_for_machine_learning_5', 'usr_seed000035', 'crs_math_for_machine_learning', 5, 'Best course I''ve taken on the topic', 'The explanations build intuition before the math, and every concept is backed by code you actually run. I finally understand what''s happening under the hood instead of copying snippets.', '2026-10-15T08:04:01.623Z', '2026-10-15T08:04:01.623Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000035');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_math_for_machine_learning_6', 'usr_seed00003q', 'crs_math_for_machine_learning', 3, 'Very good', 'Good content overall, but I wanted more exercises and a slower pace in the later sections. Still learned a lot.', '2026-09-10T21:04:01.623Z', '2026-09-10T21:04:01.623Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00003q');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_math_for_machine_learning_7', 'usr_seed00003s', 'crs_math_for_machine_learning', 4, 'Great instructor, great community', 'Questions in the Q&A got thoughtful answers quickly. The notes feature and lesson resources made it easy to review before my exam.', '2026-07-27T20:04:01.623Z', '2026-07-27T20:04:01.623Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00003s');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_math_for_machine_learning_8', 'usr_seed00003x', 'crs_math_for_machine_learning', 5, 'Great instructor, great community', 'Questions in the Q&A got thoughtful answers quickly. The notes feature and lesson resources made it easy to review before my exam.', '2026-08-01T07:04:01.623Z', '2026-08-01T07:04:01.623Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00003x');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_math_for_machine_learning_9', 'usr_seed00003y', 'crs_math_for_machine_learning', 2, 'Very good', 'Good content overall, but I wanted more exercises and a slower pace in the later sections. Still learned a lot.', '2026-10-22T09:04:01.623Z', '2026-10-22T09:04:01.623Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00003y');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_math_for_machine_learning_10', 'usr_seed00004f', 'crs_math_for_machine_learning', 4, 'Helped me land an ML role', 'I was a backend engineer trying to move into ML. This course gave me the vocabulary and the hands-on confidence to pass technical interviews. Highly recommended.', '2026-08-03T08:04:01.623Z', '2026-08-03T08:04:01.623Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00004f');

UPDATE courses SET rating_avg = coalesce((SELECT avg(rating) FROM reviews WHERE course_id = 'crs_math_for_machine_learning'), 0), rating_count = (SELECT count(*) FROM reviews WHERE course_id = 'crs_math_for_machine_learning') WHERE id = 'crs_math_for_machine_learning';
