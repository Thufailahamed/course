Answer quality depends on retrieval quality. If the right passage is not in the context, no prompt can recover it, so retrieval deserves its own measurement. Two standard numbers do most of the work. Recall at k asks how many of the relevant documents appear in the top k results. Reciprocal rank asks how high the first relevant document appears, and averaging it over queries gives the mean reciprocal rank.

## Recall at k

```python run
retrieved = ["doc3", "doc1", "doc7", "doc2"]
relevant = {"doc1", "doc2"}
for k in [1, 2, 4]:
    hits = len(set(retrieved[:k]) & relevant)
    print(f"recall@{k}: {hits / len(relevant):.2f}")
```

Recall rises as k grows, which is why retrievers return more candidates than the prompt can hold, and a reranker then picks the best few.

## Reciprocal rank over several queries

Each query contributes 1 divided by the rank of its first relevant document, or 0 if none appears.

```python run
runs = [(["doc3", "doc1"], {"doc1"}), (["doc5", "doc6", "doc9"], {"doc9"}), (["doc4"], {"doc8"})]
rr = []
for retrieved, rel in runs:
    ranks = [i for i, d in enumerate(retrieved, start=1) if d in rel]
    rr.append(1 / ranks[0] if ranks else 0.0)
print("reciprocal ranks:", [round(x, 3) for x in rr], "| MRR:", round(sum(rr) / len(rr), 3))
```

## Precision at k

Precision at k is the share of the top k that is relevant. It falls as k grows when the relevant set is small.

```python run
for k in [1, 2, 4]:
    print(f"precision@{k}: {len(set(retrieved[:k]) & relevant) / k:.2f}")
```

## Comparing two settings

A change to chunking or ranking should be judged on the same queries, by the same metric.

```python run
baseline = [0.5, 0.0, 1.0]
candidate = [1.0, 0.5, 1.0]
print("baseline mean:", round(sum(baseline) / len(baseline), 3), "| candidate mean:", round(sum(candidate) / len(candidate), 3))
```

> **Pitfall:** a metric averaged over a few queries can move by chance. Use enough queries that the difference is larger than the spread, and report the number of queries with the score.

> **In the wild:** teams keep a labelled set of questions with their source passages, and run recall and MRR on every change to chunking, embeddings or ranking.

## Challenge: recall at k

```python exercise id=recall-at-k title="Recall of the top k results"
# TODO: `recall_at_k(retrieved, relevant, k)` returns the share of the relevant documents that appear among the first k
# retrieved documents, as a float.
def recall_at_k(retrieved, relevant, k):
    ...
--- solution
def recall_at_k(retrieved, relevant, k):
    return len(set(retrieved[:k]) & set(relevant)) / len(set(relevant))
--- test
result = recall_at_k(["a", "b", "c"], {"a", "c"}, 2)
assert result is not None, "Replace the `...` in `recall_at_k` with code that returns the recall."
assert abs(result - 0.5) < 1e-9, f"Only a is in the top two of the two relevant documents, so recall is 0.5, but you returned {result}."
assert abs(recall_at_k(["a", "b", "c"], {"a", "c"}, 3) - 1.0) < 1e-9, "Both relevant documents are in the top three, so recall is one."
--- hint
Intersect the top-k slice with the relevant set, then divide by the size of the relevant set.
--- hint
`len(set(retrieved[:k]) & set(relevant)) / len(set(relevant))`.
```

## Challenge: mean reciprocal rank

```python exercise id=mrr title="Mean reciprocal rank over queries"
# TODO: `mrr(runs)` takes a list of (retrieved, relevant) pairs. For each pair, the score is 1 divided by the rank of the
# first relevant document, counted from 1, or 0 if no relevant document is retrieved. Return the mean over the pairs.
def mrr(runs):
    ...
--- solution
def mrr(runs):
    scores = []
    for retrieved, relevant in runs:
        ranks = [i for i, d in enumerate(retrieved, start=1) if d in relevant]
        scores.append(1 / ranks[0] if ranks else 0.0)
    return sum(scores) / len(scores)
--- test
result = mrr([(["x", "a"], {"a"}), (["b"], {"a"})])
assert result is not None, "Replace the `...` in `mrr` with code that returns the mean."
assert abs(result - 0.25) < 1e-9, f"The first query scores 1/2 and the second scores 0, so the mean is 0.25, but you returned {result}."
--- hint
Compute each reciprocal rank, then average them.
--- hint
Rank counts from one, so the first position is rank 1.
```

## Debug: a zero-based rank

The first relevant document sits at position 2 in the list, so its reciprocal rank should be 0.5. The code uses the zero-based index instead.

```python debug id=rank-offset title="Ranks start at one"
retrieved = ["b", "a"]
relevant = {"a"}
index = retrieved.index("a")                  # zero-based position of the first relevant document
score = 1 / index if index > 0 else 0.0      # bug: the rank is index + 1
print("reciprocal rank:", score)
--- solution
retrieved = ["b", "a"]
relevant = {"a"}
index = retrieved.index("a")
score = 1 / (index + 1)
print("reciprocal rank:", score)
--- test
assert abs(score - 0.5) < 1e-9, f"The first relevant document is second, so its reciprocal rank is 0.5, but the code gives {score}. Use index + 1 as the rank."
--- hint
Lists are zero-based, but ranks are one-based.
--- hint
Use `1 / (index + 1)`.
```

## Predict the precision

```python predict id=predict-prec title="What is the precision at 2 when the top two are a and b and the relevant set is a and c?"
retrieved = ["a", "b"]
relevant = {"a", "c"}
print(len(set(retrieved[:2]) & relevant) / 2)
--- options
* 0.5
1.0
0.0
0.25
--- explain
One of the two retrieved documents, a, is relevant, so precision at 2 is one half.
```

## Recap

- Recall at k measures how many relevant documents the top k contains.
- Reciprocal rank measures how high the first relevant result sits, and MRR averages it.
- Compare settings on the same queries with the same metric, and report how many queries you used.

**Up next:** instruction datasets, and deciding whether fine-tuning is worth doing at all.
