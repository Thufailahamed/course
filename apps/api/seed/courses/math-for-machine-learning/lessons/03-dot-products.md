Search engines, recommendation systems and large language models share one habit: they turn things into vectors and then ask how *similar* two vectors are. The main tool for that question is the **dot product**. It takes two vectors and returns a single number that combines their lengths and the angle between them. Once you know it, you can read a linear model, a similarity score or a projection at a glance.

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

Both `np.dot(a, b)` and `a @ b` compute the same thing. The `@` operator is the modern, readable way, and you'll see it everywhere in machine-learning code.

> **Pitfall:** the dot product needs vectors of the same length. `np.dot` with lengths 3 and 4 raises a `ValueError`. That error is useful: it means you've paired up things that don't belong together.

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

The dot product of a vector with itself is the sum of its squared entries. Taking the square root gives its **length** (also called the norm), which is Pythagoras' theorem in any number of dimensions.

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

The **projection** of $b$ onto $a$ is the part of $b$ that points in $a$'s direction. Its length is the dot product divided by $\|a\|$, and as a vector it is:

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

Projection is the central idea of PCA, which you'll build from scratch later. Every "best approximation" in linear algebra is a projection in disguise.

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
