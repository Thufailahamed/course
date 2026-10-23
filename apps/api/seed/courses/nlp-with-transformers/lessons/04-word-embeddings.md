Words that appear in similar contexts tend to have similar meanings. "Cat" and "dog" both appear near "pet", "feed" and "vet"; "car" appears near "engine" and "road". Word embeddings turn that observation into vectors: words with similar contexts get similar vectors. The classic recipe needs no neural network. Count how often words co-occur, reweight the counts so that surprising pairs stand out, and compress the result with a singular value decomposition.

## Co-occurrence counts

Slide a window over each sentence and count which words appear near each other.

```python run
import numpy as np

corpus = [
    "the cat drinks milk", "the dog drinks water", "the cat eats fish",
    "the dog eats meat", "the car needs fuel", "the car needs oil",
    "the truck needs fuel", "a cat and a dog", "the engine needs oil",
]
vocab = sorted({w for s in corpus for w in s.split()})
index = {w: i for i, w in enumerate(vocab)}
C = np.zeros((len(vocab), len(vocab)))
window = 2
for s in corpus:
    words = s.split()
    for i, w in enumerate(words):
        for j in range(max(0, i - window), min(len(words), i + window + 1)):
            if j != i:
                C[index[w], index[words[j]]] += 1
print("vocabulary size:", len(vocab))
print("co-occurrences of 'cat' with:", {vocab[j]: int(C[index["cat"], j]) for j in np.nonzero(C[index["cat"]])[0]})
```

Raw counts favour frequent words such as "the", which co-occur with everything. The next step fixes that.

## Positive pointwise mutual information

Pointwise mutual information compares how often two words co-occur with how often they would by chance. Its positive part (PPMI) keeps only the informative associations:

$$
\operatorname{PPMI}(w, c) = \max\!\left(0, \log \frac{p(w, c)}{p(w)\, p(c)}\right)
$$

```python run
total = C.sum()
p_wc = C / total
p_w = p_wc.sum(axis=1, keepdims=True)
p_c = p_wc.sum(axis=0, keepdims=True)
with np.errstate(divide="ignore", invalid="ignore"):
    pmi = np.log(p_wc / (p_w * p_c))
PPMI = np.where(np.isfinite(pmi), np.maximum(pmi, 0), 0)
print("PPMI of 'cat' with 'drinks':", round(PPMI[index["cat"], index["drinks"]], 3))
print("PPMI of 'cat' with 'the':", round(PPMI[index["cat"], index["the"]], 3))
```

The association between "cat" and "drinks" is strong. Its association with "the" is weak, because "the" co-occurs with everything.

## Compress with an SVD

A singular value decomposition factors the PPMI matrix into directions ranked by importance. Keeping the top $d$ directions gives dense embeddings of $d$ numbers per word.

```python run
U, S, Vt = np.linalg.svd(PPMI)
d = 3
E = U[:, :d] * np.sqrt(S[:d])
def neighbours(word, k=3):
    v = E[index[word]]
    sims = E @ v / (np.linalg.norm(E, axis=1) * np.linalg.norm(v) + 1e-12)
    order = [i for i in np.argsort(-sims) if vocab[i] != word]
    return [(vocab[i], round(float(sims[i]), 2)) for i in order[:k]]

print("nearest to 'cat':", neighbours("cat"))
print("nearest to 'car':", neighbours("car"))
```

Words that share contexts end up close together, so animals cluster with animals and vehicles with vehicles, even though nobody labelled them.

> **Pitfall:** embeddings learned from a small corpus reflect that corpus. Two words may be close only because they share a quirk of the text, not because they mean the same thing.

> **In the wild:** word2vec, GloVe and the input embedding tables of modern transformers all learn vectors from co-occurrence statistics of this kind.

Cosine similarity compares the directions of two vectors and ignores their lengths. Normalizing each row to unit length turns one matrix product into a table of similarities.

```python run
import numpy as np
vecs = np.array([[0.9, 0.8], [0.85, 0.9], [0.1, 0.2]])
unit = vecs / np.linalg.norm(vecs, axis=1, keepdims=True)
print(np.round(unit @ unit.T, 3))
```

## Challenge: PPMI

```python exercise id=ppmi-matrix title="Positive pointwise mutual information"
import numpy as np

# TODO: `ppmi(C)` takes a non-negative co-occurrence matrix and returns its positive PMI: with total = sum of all counts,
# p(w, c) = C / total, p(w) and p(c) the row and column sums of p, the value max(0, log(p(w,c) / (p(w) p(c)))).
# Entries where C is zero are 0.
def ppmi(C):
    ...
--- solution
import numpy as np

def ppmi(C):
    C = np.asarray(C, dtype=float)
    total = C.sum()
    p_wc = C / total
    p_w = p_wc.sum(axis=1, keepdims=True)
    p_c = p_wc.sum(axis=0, keepdims=True)
    with np.errstate(divide="ignore", invalid="ignore"):
        pmi = np.log(p_wc / (p_w * p_c))
    return np.where(np.isfinite(pmi), np.maximum(pmi, 0), 0)
--- test
import numpy as np
result = ppmi(np.array([[2.0, 0.0], [0.0, 2.0]]))
assert result is not None, "Replace the `...` in `ppmi` with code that returns the matrix."
assert result.shape == (2, 2), "The output has the same shape as the input."
assert np.allclose(result, [[np.log(2), 0.0], [0.0, np.log(2)]]), f"Each diagonal pair has p = 0.5 against p(w)p(c) = 0.25, so the value is log 2, and the zeros stay zero. You returned {result}."
assert np.all(result >= 0), "PPMI is never negative."
--- hint
Divide by the total to get probabilities, then the row and column marginals. Use `np.log` and clip the negative values to zero.
--- hint
`np.maximum(np.log(p_wc / (p_w * p_c)), 0)`, with zero entries handled so they do not produce infinities.
```

## Challenge: embeddings from an SVD

```python exercise id=svd-embed title="Dense embeddings from a matrix"
import numpy as np

# TODO: `svd_embeddings(M, d)` returns the d-dimensional embeddings of the rows of M: the first d left singular vectors,
# each column multiplied by the square root of its singular value.
def svd_embeddings(M, d):
    ...
--- solution
import numpy as np

def svd_embeddings(M, d):
    U, S, _ = np.linalg.svd(np.asarray(M, dtype=float))
    return U[:, :d] * np.sqrt(S[:d])
--- test
import numpy as np
result = svd_embeddings(np.diag([4.0, 1.0]), 2)
assert result is not None, "Replace the `...` in `svd_embeddings` with code that returns the embeddings."
assert result.shape == (2, 2), "Two rows with two dimensions give shape (2, 2)."
assert np.allclose(np.abs(result), [[2.0, 0.0], [0.0, 1.0]]), f"The singular values 4 and 1 give square roots 2 and 1 along the axes, but you returned {result}. Signs of singular vectors may differ, so compare absolute values."
--- hint
Use `np.linalg.svd(M)` and keep the first d columns of U, scaled by the square roots of the first d singular values.
--- hint
`U[:, :d] * np.sqrt(S[:d])`.
```

## Debug the probabilities

This PPMI uses the raw counts where it should use probabilities, so the values are not comparable across matrices of different sizes.

```python debug id=raw-counts title="Use probabilities, not raw counts"
import numpy as np

C = np.array([[2.0, 0.0], [0.0, 2.0]])
row = C.sum(axis=1, keepdims=True)
col = C.sum(axis=0, keepdims=True)
pmi = np.log(C / (row * col))               # bug: the ratio uses counts, not probabilities
print("pmi:", np.round(pmi, 3))
--- solution
import numpy as np

C = np.array([[2.0, 0.0], [0.0, 2.0]])
p_wc = C / C.sum()
p_w = p_wc.sum(axis=1, keepdims=True)
p_c = p_wc.sum(axis=0, keepdims=True)
pmi = np.log(p_wc / (p_w * p_c))
print("pmi:", np.round(pmi, 3))
--- test
assert abs(pmi[0, 0] - np.log(2)) < 1e-9, f"The diagonal PMI should be log 2 ≈ 0.693 with probabilities, but the code gives {pmi[0, 0]:.3f}. Divide the counts by the total first."
--- hint
PMI compares joint probabilities with products of marginal probabilities, so every term must be a probability.
--- hint
Divide `C` by `C.sum()` before computing the marginals.
```

## Predict the value

```python predict id=predict-ppmi title="What is the PPMI for a pair that never co-occurs?"
import numpy as np
print(max(0.0, 0.0))
--- options
* 0.0
1.0
-1.0
log 2
--- explain
A pair with zero co-occurrence has no positive association, and the PPMI is clipped at zero. Negative association is discarded by design.
```

## Recap

- Words in similar contexts get similar vectors, which is the distributional hypothesis.
- PPMI reweights co-occurrence counts so that informative pairs stand out and frequent words do not dominate.
- An SVD compresses the PPMI matrix into dense embeddings with a chosen number of dimensions.
- Embeddings reflect their training corpus, so check the neighbours you get.

**Up next:** sentence embeddings, which combine word vectors into one vector per text and compare texts with cosine similarity.
