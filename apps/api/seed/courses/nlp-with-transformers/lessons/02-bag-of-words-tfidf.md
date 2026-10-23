The simplest representation of a document is a **bag of words**: count how often each vocabulary word appears, and ignore order. It is crude, but surprisingly strong, and it is the baseline every fancier method must beat. Its weakness is that common words such as "the" dominate the counts. **TF-IDF** fixes that by weighting each count with how rare the word is across the collection, so distinctive words stand out.

## Counts

```python run
import numpy as np

docs = ["the cat sat on the mat", "the dog sat on the log", "the dog barked"]
vocab = sorted({w for d in docs for w in d.split()})
index = {w: i for i, w in enumerate(vocab)}
counts = np.zeros((len(docs), len(vocab)))
for r, d in enumerate(docs):
    for w in d.split():
        counts[r, index[w]] += 1

print("vocabulary:", vocab)
print("counts for the first document:", counts[0].astype(int))
```

Each document is a row of counts over the same vocabulary. Order is lost: "dog bites man" and "man bites dog" would have identical rows.

## Inverse document frequency

A word that appears in most documents tells you little. The inverse document frequency gives a weight that is large for rare words and near zero for words everywhere:

$$
\operatorname{idf}(w) = \log \frac{N}{\operatorname{df}(w)}
$$

where $N$ is the number of documents and $\operatorname{df}(w)$ is how many of them contain $w$.

```python run
N = len(docs)
df = (counts > 0).sum(axis=0)
idf = np.log(N / df)
for w, val in zip(vocab, idf):
    print(f"{w:>8}: idf {val:.3f}")
```

"the" appears in every document, so its weight is zero. "barked" appears in one document, so it gets the largest weight.

## TF-IDF

Multiplying the counts by the idf weights gives TF-IDF. Each document now emphasizes the words that make it different from the rest.

```python run
tfidf = counts * idf
print("TF-IDF of the third document:")
for w, val in zip(vocab, tfidf[2]):
    if val > 0:
        print(f"  {w}: {val:.3f}")
```

> **Pitfall:** the idf must be computed on the training collection only. Fitting it on a collection that includes future documents, or test documents, leaks information in the same way as any other preprocessing step.

> **In the wild:** search engines and classic text classifiers are built on TF-IDF. scikit-learn's `TfidfVectorizer` implements it with some refinements, such as smoothing.

Document frequency turns raw counts into weights. A word that appears in every document, such as 'the', gets an inverse document frequency of zero.

```python run
from collections import Counter
import math
docs = ["the cat sat", "the dog sat", "the cat ran"]
df_counts = Counter(w for d in docs for w in set(d.split()))
print({w: round(math.log(len(docs) / c), 3) for w, c in sorted(df_counts.items())})
```

## Challenge: TF-IDF matrix

```python exercise id=tfidf-matrix title="Build a TF-IDF matrix"
import numpy as np

# TODO: `tfidf_matrix(docs)` takes a list of strings and returns (vocab, M). vocab is the sorted list of distinct
# words. M has one row per document and one column per word, holding the word's count in that document multiplied by
# its inverse document frequency log(N / df), where N is the number of documents and df counts documents containing it.
def tfidf_matrix(docs):
    ...
--- solution
import numpy as np

def tfidf_matrix(docs):
    vocab = sorted({w for d in docs for w in d.split()})
    index = {w: i for i, w in enumerate(vocab)}
    counts = np.zeros((len(docs), len(vocab)))
    for r, d in enumerate(docs):
        for w in d.split():
            counts[r, index[w]] += 1
    df = (counts > 0).sum(axis=0)
    idf = np.log(len(docs) / df)
    return vocab, counts * idf
--- test
import numpy as np
vocab, M = tfidf_matrix(["a b", "a c"])
assert M is not None, "Replace the `...` in `tfidf_matrix` with code that returns (vocab, matrix)."
assert vocab == ["a", "b", "c"], f"The vocabulary should be sorted, ['a', 'b', 'c'], but it is {vocab}."
assert M.shape == (2, 3), "Two documents and three words give shape (2, 3)."
assert np.allclose(M[0], [0.0, np.log(2), 0.0]), f"'a' is in both documents so its weight is zero; 'b' is in one of two documents, so it weighs log 2. You returned {M[0]}."
assert np.allclose(M[1], [0.0, 0.0, np.log(2)]), "The second document's distinctive word is 'c'."
--- hint
Count the words per document, count the documents containing each word, then multiply the counts by `np.log(N / df)`.
--- hint
`df = (counts > 0).sum(axis=0)` and `counts * np.log(len(docs) / df)`.
```

## Challenge: cosine similarity

```python exercise id=cosine-sim title="Cosine similarity of two vectors"
import numpy as np

# TODO: `cosine(u, v)` returns the cosine of the angle between two vectors: their dot product divided by the product of
# their lengths. If either vector has zero length, return 0.0.
def cosine(u, v):
    ...
--- solution
import numpy as np

def cosine(u, v):
    u = np.asarray(u, dtype=float)
    v = np.asarray(v, dtype=float)
    nu, nv = np.linalg.norm(u), np.linalg.norm(v)
    if nu == 0 or nv == 0:
        return 0.0
    return float(u @ v / (nu * nv))
--- test
result = cosine([1.0, 0.0], [1.0, 1.0])
assert result is not None, "Replace the `...` in `cosine` with code that returns the similarity."
assert abs(result - 1 / np.sqrt(2)) < 1e-9, f"The angle between [1, 0] and [1, 1] is 45 degrees, so the cosine is 0.707, but you returned {result!r}."
assert abs(cosine([2.0, 0.0], [5.0, 0.0]) - 1.0) < 1e-9, "Parallel vectors have cosine 1, whatever their lengths."
assert cosine([0.0, 0.0], [1.0, 2.0]) == 0.0, "A zero vector has similarity 0 with everything."
--- hint
Dot product over the product of the two lengths, with `np.linalg.norm` for lengths.
--- hint
Guard against zero lengths before dividing.
```

## Debug the document frequency

This idf counts how many times a word appears, not how many documents contain it, so words repeated within one document are overweighted down.

```python debug id=df-counts title="Count documents, not occurrences"
import numpy as np

docs = ["spam spam spam", "ham eggs", "ham"]
counts = np.array([[3.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]])
df = counts.sum(axis=0)                    # bug: this sums occurrences, not documents
print("document frequency:", df)
--- solution
import numpy as np

docs = ["spam spam spam", "ham eggs", "ham"]
counts = np.array([[3.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]])
df = (counts > 0).sum(axis=0)
print("document frequency:", df)
--- test
assert list(df) == [1, 1, 1], f"Each word appears in exactly one document, so the document frequencies are [1, 1, 1], but the code gives {list(df)}. Count documents where the count is positive."
--- hint
Summing counts adds up occurrences. A document frequency asks only whether the word is present.
--- hint
`(counts > 0).sum(axis=0)`.
```

## Predict the weight

```python predict id=predict-idf title="What is the idf of a word that appears in every document?"
import numpy as np
N = 5
df = 5
print(round(float(np.log(N / df)), 3))
--- options
* 0.0
1.609
5.0
-1.0
--- explain
When a word is in every document, N divided by df is one, and log of one is zero. Such a word carries no information for telling documents apart.
```

## Recap

- A bag of words counts each vocabulary word per document and discards order.
- The inverse document frequency downweights words that appear everywhere and rewards rare, distinctive ones.
- TF-IDF multiplies the counts by idf, and its cosine similarity is a strong baseline for search.
- Fit idf on training documents only.

**Up next:** tokenization in more depth, including n-grams and the choices behind every token.
