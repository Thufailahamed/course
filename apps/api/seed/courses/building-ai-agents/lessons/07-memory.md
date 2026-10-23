An agent needs two kinds of memory. Short-term memory is the recent conversation, which is kept in the context window and trimmed as it grows. Long-term memory is a store of facts that outlives the conversation, such as a user's preferences, and it is searched for the facts relevant to the current request rather than being replayed in full.

## Short-term memory as a window

A window keeps the most recent messages. Older messages drop out of the context as new ones arrive.

```python run
messages = [f"msg{i}" for i in range(1, 7)]
print("window of the last four:", messages[-4:])
```

## Long-term facts

Stored facts are searched for the words they share with the query. The best match is the one with the most shared words.

```python run
facts = ["user likes tea", "user lives in Oslo", "order 12 shipped"]
query_words = set("where lives the user".split())
scores = [len(query_words & set(f.split())) for f in facts]
print("scores:", scores)
best = max(range(len(facts)), key=lambda i: scores[i])
print("best fact:", facts[best])
```

## Bounded storage

A long-term store needs a limit, so the oldest facts are evicted once it is full.

```python run
store = []
for i in range(150):
    store.append(i)
    store = store[-100:]
print("items kept:", len(store))
```

## Summaries

A summary condenses a set of facts into a shorter form that is cheaper to keep in context.

```python run
summary = " | ".join(f.split()[0] for f in facts)
print("summary:", summary)
```

> **Pitfall:** a memory that only grows will eventually fill the context and push out the instructions. Bound it by count or by tokens, and decide what to evict.

> **In the wild:** production agents store user preferences and past outcomes in a database, and retrieve only the entries relevant to the current task.

## Challenge: last n messages

```python exercise id=last-n title="The last n messages"
# TODO: `last_n(messages, n)` returns the last n items of the list in their original order. If n is zero, return an empty list.
def last_n(messages, n):
    ...
--- solution
def last_n(messages, n):
    return messages[-n:] if n > 0 else []
--- test
result = last_n([1, 2, 3, 4], 2)
assert result is not None, "Replace the `...` in `last_n` with code that returns the window."
assert result == [3, 4], f"The last two of [1, 2, 3, 4] are [3, 4], but you returned {result}."
assert last_n([1, 2], 5) == [1, 2], "Asking for more than the list holds returns the whole list."
assert last_n([1, 2], 0) == [], "Zero messages gives an empty window."
--- hint
Slicing from the negative index gives the tail, but n = 0 needs a special case.
--- hint
`messages[-n:] if n > 0 else []`.
```

## Challenge: recall facts

```python exercise id=recall title="Recall the most relevant facts"
# TODO: `recall(facts, query, k)` returns the k facts that share the most words with the query, most shared first. Ties keep
# the original order. Compare words in lowercase, split on spaces.
def recall(facts, query, k):
    ...
--- solution
def recall(facts, query, k):
    query_words = set(query.lower().split())
    scores = [len(query_words & set(f.lower().split())) for f in facts]
    order = sorted(range(len(facts)), key=lambda i: -scores[i])
    return [facts[i] for i in order[:k]]
--- test
facts = ["user likes tea", "user lives in Oslo", "order 12 shipped"]
result = recall(facts, "where lives the user", 1)
assert result is not None, "Replace the `...` in `recall` with code that returns the facts."
assert result == ["user lives in Oslo"], f"The fact with the most shared words is 'user lives in Oslo', but you returned {result}."
assert recall(facts, "tea", 2)[0] == "user likes tea", "A fact sharing a word with the query comes first."
--- hint
Score each fact by the size of the intersection, then sort the indices by the negative score.
--- hint
`sorted(range(len(facts)), key=lambda i: -scores[i])` keeps ties in their original order.
```

## Debug: an off-by-one window

The window should hold exactly the last four messages, but the slice starts one position too early.

```python debug id=window-size title="Keep exactly the last n messages"
messages = [1, 2, 3, 4, 5, 6]
n = 4
window = messages[-n - 1:]              # bug: the slice starts one position too early
print("window:", window)
--- solution
messages = [1, 2, 3, 4, 5, 6]
n = 4
window = messages[-n:]
print("window:", window)
--- test
assert len(window) == 4 and window == [3, 4, 5, 6], f"The window should hold the last four messages, but it holds {window}."
--- hint
A negative slice index of -n already starts at the n-th item from the end.
--- hint
Remove the `- 1`.
```

## Predict the store size

```python predict id=predict-store title="How many items does a store of size 100 keep after 150 inserts?"
store = list(range(150))[-100:]
print(len(store))
--- options
* 100
150
50
0
--- explain
The store keeps only the most recent 100 items once it is full.
```

## Recap

- Short-term memory is the recent window, and it needs trimming.
- Long-term memory is searched for the facts relevant to the query.
- Bound every store, and decide what to evict.

**Up next:** context management, which fits memory into a token budget.
