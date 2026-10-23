A retriever ranks the chunks against a query. Dense retrieval compares embeddings by cosine similarity, which captures meaning. Keyword retrieval scores the words shared with the query, which captures exact terms such as product codes. Hybrid retrieval combines the two, and reciprocal rank fusion merges rankings without needing the scores to be comparable.

## Dense ranking by cosine

Cosine similarity compares directions, so a short document and a long one with the same content score the same.

```python run
import numpy as np

docs = {"refunds": np.array([1.0, 0.1]), "shipping": np.array([0.1, 1.0]), "returns": np.array([0.9, 0.4])}
query = np.array([1.0, 0.2])
scores = {name: float(query @ v / (np.linalg.norm(query) * np.linalg.norm(v))) for name, v in docs.items()}
for name, s in sorted(scores.items(), key=lambda kv: -kv[1]):
    print(f"{name}: {s:.3f}")
```

## Keyword overlap

Keyword scoring finds exact terms that embeddings can blur, such as a model number or a name.

```python run
query_words = set("how do refunds work".split())
doc = set("refunds are processed within five days".split())
overlap = len(query_words & doc) / len(query_words)
print("keyword overlap:", round(overlap, 3))
```

## Hybrid scores

A weighted sum of the dense and keyword scores blends the two signals. The weight is a tuning choice, and it should be measured on your own queries.

```python run
dense, keyword = 0.9, 0.25
for alpha in [1.0, 0.7, 0.0]:
    print(f"alpha {alpha}: hybrid {alpha * dense + (1 - alpha) * keyword:.3f}")
```

## Reciprocal rank fusion

Each document receives 1 divided by (60 plus its rank) from every list it appears in, and the scores are summed. A document that ranks well in both lists rises to the top.

```python run
rankings = [["refunds", "returns", "shipping"], ["returns", "refunds", "faq"]]
score = {}
for ranking in rankings:
    for rank, doc_id in enumerate(ranking, start=1):
        score[doc_id] = score.get(doc_id, 0.0) + 1 / (60 + rank)
print(sorted(score.items(), key=lambda kv: -kv[1])[:3])
```

> **Pitfall:** raw dot products favour long vectors, and a long document can outrank a better match only because it is long. Normalize before comparing.

> **In the wild:** production retrievers combine a vector index with keyword search, then rerank the top results with a stronger model. The fusion step is cheap and often gives the largest gain.

## Challenge: top-k by cosine

```python exercise id=top-k-cosine title="The k most similar documents"
import numpy as np

# TODO: `top_k_cosine(query, docs, k)` returns the indices of the k rows of docs most similar to query by cosine, most
# similar first, as a list of ints.
def top_k_cosine(query, docs, k):
    ...
--- solution
import numpy as np

def top_k_cosine(query, docs, k):
    q = np.asarray(query, dtype=float)
    D = np.asarray(docs, dtype=float)
    sims = D @ q / (np.linalg.norm(D, axis=1) * np.linalg.norm(q))
    return [int(i) for i in np.argsort(-sims)[:k]]
--- test
result = top_k_cosine([1.0, 0.0], [[1.0, 0.0], [0.0, 1.0], [0.7, 0.7]], 2)
assert result is not None, "Replace the `...` in `top_k_cosine` with code that returns the indices."
assert result == [0, 2], f"The cosines are 1, 0 and about 0.71, so the top two are indices 0 and 2, but you returned {result}."
--- hint
Divide the dot products by the norms of each document and of the query.
--- hint
`np.argsort(-sims)[:k]` gives the best indices first.
```

## Challenge: reciprocal rank fusion

```python exercise id=rrf title="Fuse several rankings"
# TODO: `rrf(rankings, k=60)` takes a list of rankings, each a list of document ids from best to worst. It returns the ids
# sorted by their summed score, where each appearance contributes 1 / (k + rank) with rank counted from 1.
def rrf(rankings, k=60):
    ...
--- solution
def rrf(rankings, k=60):
    score = {}
    for ranking in rankings:
        for rank, doc_id in enumerate(ranking, start=1):
            score[doc_id] = score.get(doc_id, 0.0) + 1 / (k + rank)
    return sorted(score, key=lambda d: -score[d])
--- test
result = rrf([["a", "b", "c"], ["a", "b", "d"]])
assert result is not None, "Replace the `...` in `rrf` with code that returns the fused order."
assert result[:2] == ["a", "b"], f"a is first in both lists and b is second in both, so the top two are a and b, but you returned {result}."
assert rrf([["x"]]) == ["x"], "A single ranking is returned unchanged."
--- hint
Accumulate the scores in a dictionary, then sort the keys by score.
--- hint
`sorted(score, key=lambda d: -score[d])`.
```

## Debug: raw dot products

The best document should be the one whose direction is closest to the query, but the raw dot product favours the longer vector.

```python debug id=dot-vs-cosine title="Compare directions, not raw dot products"
import numpy as np

q = np.array([1.0, 0.0])
docs = np.array([[10.0, 1.0], [1.0, 0.0]])
scores = docs @ q                             # bug: raw dot products favour long vectors
best = int(np.argmax(scores))
print("best document:", best)
--- solution
import numpy as np

q = np.array([1.0, 0.0])
docs = np.array([[10.0, 1.0], [1.0, 0.0]])
scores = docs @ q / np.linalg.norm(docs, axis=1)
best = int(np.argmax(scores))
print("best document:", best)
--- test
assert best == 1, f"Document 1 points exactly along the query, so it is the best match, but the code picks {best}. Normalize by the document lengths."
--- hint
Document 0 is long, so its raw score is large while its direction is only roughly right.
--- hint
Divide each dot product by the length of its document.
```

## Predict the fused score

```python predict id=predict-rrf title="What is the score of a document ranked first, with k = 60, in one list?"
print(round(1 / 61, 4))
--- options
* 0.0164
1.0
0.0167
0.5
--- explain
The score is 1 divided by 60 plus rank 1, which is 1 divided by 61, about 0.0164.
```

## Recap

- Dense retrieval compares directions, and normalizing removes the advantage of length.
- Keyword scores catch exact terms, and hybrid scores combine both signals.
- Reciprocal rank fusion merges rankings with a simple, scale-free formula.

**Up next:** measuring retrieval, because a ranking you have not measured is a guess.
