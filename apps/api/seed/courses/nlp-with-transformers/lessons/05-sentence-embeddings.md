Most NLP tasks need one vector per text, not one per word. The simplest way to get it is to average the vectors of the words in the text. Averaging throws away order, which is a loss, but it is fast, surprisingly effective and the foundation of many systems. To compare two texts you then need a similarity, and cosine similarity is the standard choice, because it measures direction rather than length.

## Averaging word vectors

```python run
import numpy as np

word_vectors = {
    "cat": np.array([0.9, 0.1]), "dog": np.array([0.8, 0.2]),
    "car": np.array([0.1, 0.9]), "road": np.array([0.2, 0.8]),
}

def sentence_vector(tokens, vectors):
    known = [vectors[t] for t in tokens if t in vectors]
    if not known:
        return np.zeros(2)
    return np.mean(known, axis=0)

print("'cat dog':", sentence_vector(["cat", "dog"], word_vectors))
print("'the cat road':", sentence_vector(["the", "cat", "road"], word_vectors))
```

Unknown words such as "the" are skipped, because they have no vector. Averaging then gives the sentence a position in the space of meanings.

## Cosine similarity

The cosine of the angle between two vectors is 1 when they point the same way, 0 when they are unrelated, and -1 when opposite. It ignores length, so a long document and a short one about the same topic still match.

```python run
def cosine(u, v):
    return float(u @ v / (np.linalg.norm(u) * np.linalg.norm(v)))

animal = sentence_vector(["cat", "dog"], word_vectors)
vehicle = sentence_vector(["car", "road"], word_vectors)
query = sentence_vector(["dog", "cat", "cat"], word_vectors)
print("query vs animal:", round(cosine(query, animal), 3))
print("query vs vehicle:", round(cosine(query, vehicle), 3))
```

A query about animals matches the animal sentence far better than the vehicle sentence.

## Normalize, then dot

If every vector is scaled to unit length, the dot product equals the cosine. Many systems normalize once, store the vectors, and then compare with fast dot products.

```python run
def normalize_rows(M):
    norms = np.linalg.norm(M, axis=1, keepdims=True)
    return np.divide(M, norms, out=np.zeros_like(M), where=norms > 0)

docs = np.stack([animal, vehicle])
unit = normalize_rows(docs)
print("unit lengths:", np.round(np.linalg.norm(unit, axis=1), 6))
print("dot product equals cosine:", np.isclose(unit[0] @ normalize_rows(query[None])[0], cosine(query, animal)))
```

> **Pitfall:** averaging gives long texts and short texts vectors of similar length, but a single very common word can still dominate. Remove stop words or weight words by TF-IDF when that matters.

> **In the wild:** sentence-embedding models produce one vector per sentence directly, trained so that cosine similarity reflects meaning. The comparison step is identical to the one here.

Two vectors that point the same way have cosine similarity one, however long they are. An unrelated vector scores near zero.

```python run
import numpy as np
v_a = np.array([1.0, 2.0, 0.0])
v_b = np.array([2.0, 4.0, 0.0])
v_c = np.array([0.0, 0.0, 1.0])
def cosine(u, v):
    return float(u @ v / (np.linalg.norm(u) * np.linalg.norm(v)))
print(round(cosine(v_a, v_b), 3), round(cosine(v_a, v_c), 3))
```

## Challenge: sentence vector

```python exercise id=sentence-vec title="Average the known word vectors"
import numpy as np

# TODO: `sentence_vector(tokens, vectors)` returns the mean of the vectors (a dictionary from word to array) of the
# tokens that appear in `vectors`, skipping the others. If no token is known, return a zero vector of the same length
# as any stored vector.
def sentence_vector(tokens, vectors):
    ...
--- solution
import numpy as np

def sentence_vector(tokens, vectors):
    known = [vectors[t] for t in tokens if t in vectors]
    if not known:
        size = len(next(iter(vectors.values())))
        return np.zeros(size)
    return np.mean(known, axis=0)
--- test
import numpy as np
vecs = {"a": np.array([1.0, 0.0]), "b": np.array([0.0, 1.0])}
result = sentence_vector(["a", "b", "zzz"], vecs)
assert result is not None, "Replace the `...` in `sentence_vector` with code that returns the average."
assert np.allclose(result, [0.5, 0.5]), f"The known words are a and b, whose average is [0.5, 0.5], but you returned {result}."
assert np.allclose(sentence_vector(["zzz"], vecs), [0.0, 0.0]), "If no token is known, the result is a zero vector of the right size."
--- hint
Collect the vectors of the known tokens into a list, then average them with `np.mean(..., axis=0)`.
--- hint
`known = [vectors[t] for t in tokens if t in vectors]`.
```

## Challenge: normalize rows

```python exercise id=norm-rows title="Scale rows to unit length"
import numpy as np

# TODO: `normalize_rows(M)` returns a copy of the 2-D array M in which each row is divided by its length (Euclidean norm).
# Rows that are all zero stay zero.
def normalize_rows(M):
    ...
--- solution
import numpy as np

def normalize_rows(M):
    M = np.asarray(M, dtype=float)
    norms = np.linalg.norm(M, axis=1, keepdims=True)
    return np.divide(M, norms, out=np.zeros_like(M), where=norms > 0)
--- test
import numpy as np
result = normalize_rows(np.array([[3.0, 4.0], [0.0, 0.0]]))
assert result is not None, "Replace the `...` in `normalize_rows` with code that returns the normalized rows."
assert np.allclose(result[0], [0.6, 0.8]), f"[3, 4] has length 5, so its unit vector is [0.6, 0.8], but you returned {result[0]}."
assert np.allclose(result[1], [0.0, 0.0]), "A zero row stays zero, without a division error."
assert np.allclose(np.linalg.norm(result[0]), 1.0), "The normalized row has length one."
--- hint
Divide each row by its norm, computed with `np.linalg.norm(M, axis=1, keepdims=True)`. Guard the zero rows.
--- hint
`np.divide(M, norms, out=np.zeros_like(M), where=norms > 0)`.
```

## Debug the normalization

This normalization divides each row by its sum, not its length, so the rows do not have unit length.

```python debug id=sum-not-length title="Divide by the length, not the sum"
import numpy as np

M = np.array([[3.0, 4.0]])
unit = M / M.sum(axis=1, keepdims=True)        # bug: the sum is not the length
print("length of the result:", np.round(np.linalg.norm(unit), 3))
--- solution
import numpy as np

M = np.array([[3.0, 4.0]])
unit = M / np.linalg.norm(M, axis=1, keepdims=True)
print("length of the result:", np.round(np.linalg.norm(unit), 3))
--- test
assert abs(np.linalg.norm(unit) - 1.0) < 1e-9, f"A unit vector has length one, but this one has length {np.linalg.norm(unit):.3f}. Divide by the Euclidean norm, not the sum."
--- hint
The length of a vector is the square root of the sum of its squares, not its sum.
--- hint
Use `np.linalg.norm(M, axis=1, keepdims=True)`.
```

## Predict the similarity

```python predict id=predict-cos title="What is the cosine similarity of two vectors that point the same way?"
import numpy as np
u = np.array([2.0, 0.0])
v = np.array([5.0, 0.0])
print(round(float(u @ v / (np.linalg.norm(u) * np.linalg.norm(v))), 1))
--- options
* 1.0
0.0
-1.0
0.5
--- explain
The vectors point in the same direction, so the angle is zero and the cosine is one, whatever their lengths.
```

## Recap

- A sentence vector is the average of its known word vectors, which discards order but is fast and effective.
- Cosine similarity compares direction, so it is insensitive to length.
- Normalize vectors once, and comparisons become dot products.
- Averaging lets common words dominate, so weight or filter them when that matters.

**Up next:** semantic search, which ranks documents by these similarities and evaluates the ranking.
