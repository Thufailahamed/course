Search is ranking. Given a query, return the documents most likely to be useful, in order. Keyword search only finds documents that share words with the query. Semantic search embeds the query and the documents in the same space and ranks them by similarity, so a query about "automobile repairs" can find a document about "car servicing". Ranking is also where evaluation gets interesting, because the quality you care about is the position of the right answer.

## Ranking by similarity

```python run
import numpy as np

docs = {
    "engine oil guide": np.array([0.1, 0.9, 0.1]),
    "cat food reviews": np.array([0.9, 0.1, 0.0]),
    "car service costs": np.array([0.2, 0.8, 0.3]),
    "dog walking tips": np.array([0.8, 0.0, 0.2]),
}
query = np.array([0.15, 0.85, 0.2])                # "how much does a car service cost"

def rank(query, docs):
    names = list(docs)
    M = np.stack([docs[n] for n in names])
    sims = M @ query / (np.linalg.norm(M, axis=1) * np.linalg.norm(query))
    order = np.argsort(-sims)
    return [(names[i], round(float(sims[i]), 3)) for i in order]

for name, score in rank(query, docs):
    print(f"{score:6.3f}  {name}")
```

The two car-related documents come first. Neither needed to share a single word with the query beyond what the embeddings captured.

## Top-k and what the user sees

Users read the first few results. A search system is judged on whether the right document appears near the top, often in the first ten.

```python run
ranking = [n for n, _ in rank(query, docs)]
relevant = {"car service costs"}
top2 = ranking[:2]
print("top two results:", top2)
print("relevant document shown in top two:", bool(relevant & set(top2)))
```

## Reciprocal rank

The **reciprocal rank** of a query is one divided by the position of the first relevant result. A relevant result first scores 1, second scores 1/2, and so on. Averaged over many queries, it is the mean reciprocal rank (MRR), which rewards putting the right answer high.

```python run
rankings = [
    ["car service costs", "engine oil guide"],
    ["dog walking tips", "cat food reviews", "car service costs"],
    ["engine oil guide", "car service costs"],
]
rr = [1.0 / (r.index("car service costs") + 1) for r in rankings]
print("reciprocal ranks:", [round(x, 3) for x in rr])
print("mean reciprocal rank:", round(float(np.mean(rr)), 3))
```

> **Pitfall:** evaluate search with queries and relevance judgements that were not used to tune the embeddings. A system tuned on its own test queries will look better than it is.

> **In the wild:** production search combines embedding similarity with keyword matching and a reranker, and it is measured with MRR, recall at k and user engagement.

Ranking a search is a sort by score, highest first. The top result is the document most similar to the query.

```python run
import numpy as np
doc_scores = np.array([0.2, 0.9, 0.5, 0.7])
order = np.argsort(-doc_scores)
print("ranking:", order, "| top score:", doc_scores[order[0]])
```

## Challenge: rank documents

```python exercise id=rank-docs title="Rank documents by cosine similarity"
import numpy as np

# TODO: `rank_documents(query, D)` takes a query vector and a 2-D array D with one document vector per row. Return the
# row indices of D sorted from most to least similar to the query, by cosine similarity. Ties keep the original order.
def rank_documents(query, D):
    ...
--- solution
import numpy as np

def rank_documents(query, D):
    query = np.asarray(query, dtype=float)
    D = np.asarray(D, dtype=float)
    sims = D @ query / (np.linalg.norm(D, axis=1) * np.linalg.norm(query))
    return list(np.argsort(-sims, kind="stable"))
--- test
import numpy as np
D = np.array([[1.0, 0.0], [0.0, 1.0], [1.0, 1.0]])
result = rank_documents(np.array([1.0, 0.1]), D)
assert result is not None, "Replace the `...` in `rank_documents` with code that returns the ordering."
assert list(result) == [0, 2, 1], f"The query is closest to document 0, then document 2, then document 1, so the order is [0, 2, 1], but you returned {list(result)}."
assert list(rank_documents(np.array([0.0, 1.0]), np.array([[1.0, 0.0], [1.0, 0.0]]))) == [0, 1], "Ties keep the original order."
--- hint
Compute the cosine similarity of the query with every row, then sort the indices by decreasing similarity. `np.argsort` on the negated scores does that.
--- hint
`np.argsort(-sims, kind="stable")`.
```

## Challenge: reciprocal rank

```python exercise id=reciprocal-rank title="Reciprocal rank of the first relevant result"
# TODO: `reciprocal_rank(ranking, relevant)` returns 1 divided by the position (starting at 1) of the first item in
# `ranking` that is in the set `relevant`. If no item is relevant, return 0.0.
def reciprocal_rank(ranking, relevant):
    ...
--- solution
def reciprocal_rank(ranking, relevant):
    for position, item in enumerate(ranking, start=1):
        if item in relevant:
            return 1.0 / position
    return 0.0
--- test
result = reciprocal_rank(["a", "b", "c"], {"b", "c"})
assert result is not None, "Replace the `...` in `reciprocal_rank` with code that returns the value."
assert abs(result - 0.5) < 1e-9, f"The first relevant item is 'b' at position 2, so the reciprocal rank is 0.5, but you returned {result!r}."
assert reciprocal_rank(["a"], {"a"}) == 1.0, "A relevant first item gives 1."
assert reciprocal_rank(["a", "b"], {"z"}) == 0.0, "No relevant item gives 0."
--- hint
Walk through the ranking with `enumerate(ranking, start=1)` and stop at the first relevant item.
--- hint
Return `1.0 / position` as soon as you find a relevant item.
```

## Debug the ranking order

This ranking is meant to put the most similar documents first, but it sorts the scores in ascending order, so the least similar come first.

```python debug id=ascending-rank title="Most similar first"
import numpy as np

sims = np.array([0.2, 0.9, 0.5])
order = np.argsort(sims)                  # bug: ascending order puts the weakest match first
print("ranking:", order)
--- solution
import numpy as np

sims = np.array([0.2, 0.9, 0.5])
order = np.argsort(-sims)
print("ranking:", order)
--- test
assert list(order) == [1, 2, 0], f"The most similar document is index 1, then 2, then 0, but the ranking is {list(order)}. Sort in decreasing order of similarity."
--- hint
Smaller similarities should come later, not earlier.
--- hint
Sort the negated scores, `np.argsort(-sims)`.
```

## Predict the reciprocal rank

```python predict id=predict-rr title="What is the reciprocal rank when the relevant item is third?"
print(round(1 / 3, 3))
--- options
* 0.333
0.5
1.0
0.0
--- explain
The reciprocal rank is one divided by the position. Position three gives one third.
```

## Recap

- Semantic search ranks documents by the similarity of their embeddings to the query.
- Users see the top results, so evaluate the position of the right answer, not only whether it appears.
- Reciprocal rank rewards placing the first relevant document high, and MRR averages it over queries.
- Keep the evaluation queries separate from anything used to tune the system.

**Checkpoint:** the quiz below covers representations and search. Then the course moves to fine-tuning encoders.
