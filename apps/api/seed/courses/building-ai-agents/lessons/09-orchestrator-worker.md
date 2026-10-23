An orchestrator-worker design splits a task among specialists. The orchestrator routes each incoming task to the worker best suited to it, and combines the answers. Routing can be done with rules, with keyword matches, or with a model. Whichever is used, the routing decision must be deterministic enough to reproduce, so that a failure can be traced to the route that caused it.

## The worker registry

Each worker declares the keywords it handles. The registry is data, which makes routing easy to change and to test.

```python run
workers = {
    "billing": {"refund", "invoice", "charge"},
    "tech": {"crash", "error", "login"},
}
for name, kws in workers.items():
    print(name, "handles", sorted(kws))
```

## Scoring a task

A task is scored against each worker by how many of its keywords the task contains.

```python run
task = "refund my invoice"
words = set(task.lower().split())
scores = {name: len(words & kws) for name, kws in workers.items()}
print("scores:", scores)
```

## Fanning out a batch

The orchestrator routes every task in a batch and records the decision for each one.

```python run
tasks = ["refund my invoice", "app crash on login", "where is my parcel"]
routes = {}
for t in tasks:
    words = set(t.lower().split())
    scores = {name: len(words & kws) for name, kws in workers.items()}
    best = max(scores.values())
    routes[t] = max(scores, key=scores.get) if best > 0 else "generalist"
print(routes)
```

## Combining the results

After the workers answer, the orchestrator joins their results in a fixed order, so the final answer is stable.

```python run
answers = {"tech": "Clear the cache.", "billing": "A refund takes five days."}
combined = "\n".join(f"{name}: {answers[name]}" for name in sorted(answers))
print(combined)
```

> **Pitfall:** when two workers tie, a route that depends on dictionary order or on timing can change between runs. Break ties by a fixed rule, such as alphabetical order.

> **In the wild:** orchestrators often use a model to classify the task, and fall back to a generalist when no worker is confident. Log every route so misrouted tasks can be reviewed.

## Challenge: route a task

```python exercise id=route title="Route a task to the best worker"
# TODO: `route(task, workers)` takes a task string and a dictionary from worker name to a set of keywords. It scores each worker
# by the number of keywords present in the task (compared in lowercase words). It returns the name of the best-scoring
# worker, breaking ties by the alphabetically first name, or "generalist" if no worker scores above zero.
def route(task, workers):
    ...
--- solution
def route(task, workers):
    words = set(task.lower().split())
    scores = {name: len(words & kws) for name, kws in workers.items()}
    best = max(scores.values(), default=0)
    if best == 0:
        return "generalist"
    return min(name for name, s in scores.items() if s == best)
--- test
workers = {"billing": {"refund", "invoice"}, "tech": {"crash", "error"}}
assert route("refund my invoice", workers) == "billing", "Two billing keywords match."
assert route("app crash error", workers) == "tech", "Two tech keywords match."
assert route("hello there", workers) == "generalist", "No keyword matches goes to the generalist."
assert route("refund crash", workers) == "billing", "A tie goes to the alphabetically first worker."
--- hint
Count the shared words for each worker, then find the best count.
--- hint
Among workers with the best count, choose the smallest name.
```

## Challenge: fan out a batch

The function `route` is provided, and your task is to apply it to a whole batch.

```python exercise id=fan-out title="Route every task in a batch"
def route(task, workers):
    words = set(task.lower().split())
    scores = {name: len(words & kws) for name, kws in workers.items()}
    best = max(scores.values(), default=0)
    if best == 0:
        return "generalist"
    return min(name for name, s in scores.items() if s == best)

# TODO: `fan_out(tasks, workers)` returns a dictionary mapping each task string to route(task, workers).
def fan_out(tasks, workers):
    ...
--- solution
def route(task, workers):
    words = set(task.lower().split())
    scores = {name: len(words & kws) for name, kws in workers.items()}
    best = max(scores.values(), default=0)
    if best == 0:
        return "generalist"
    return min(name for name, s in scores.items() if s == best)

def fan_out(tasks, workers):
    return {t: route(t, workers) for t in tasks}
--- test
workers = {"billing": {"refund", "invoice"}, "tech": {"crash", "error"}}
result = fan_out(["refund my invoice", "app crash", "hello"], workers)
assert result is not None, "Replace the `...` in `fan_out` with code that returns the mapping."
assert result == {"refund my invoice": "billing", "app crash": "tech", "hello": "generalist"}, f"Each task should map to its route, but you returned {result}."
--- hint
A dictionary comprehension over the tasks is enough.
--- hint
`{t: route(t, workers) for t in tasks}`.
```

## Debug: a tie broken by insertion order

Two workers score equally, and the rule says the alphabetically first should win, but `max` returns the one that was inserted first.

```python debug id=tie-break title="Break ties alphabetically"
scores = {"tech": 1, "billing": 1}       # equal scores, with tech inserted first
best = max(scores, key=scores.get)       # bug: max returns the first maximum, not the alphabetical one
print("route to:", best)
--- solution
scores = {"tech": 1, "billing": 1}
best = min(scores, key=lambda w: (-scores[w], w))
print("route to:", best)
--- test
assert best == "billing", f"With equal scores the alphabetically first worker, billing, should win, but the code routes to {best}. Break ties by name."
--- hint
`max` keeps the first maximum it sees, which depends on insertion order.
--- hint
Sort by the negative score and then by the name.
```

## Predict the route

```python predict id=predict-route title="Which worker wins when billing scores 1 and tech scores 2?"
scores = {"billing": 1, "tech": 2}
print(max(scores, key=lambda k: scores[k]))
--- options
* tech
billing
generalist
tie
--- explain
Tech has the higher score, so it is the best match.
```

## Recap

- An orchestrator routes each task to a worker and combines the answers.
- Keep the registry as data, and log every route.
- Break ties by a fixed rule, so routing is reproducible.

**Up next:** when a multi-agent design pays for its extra cost.
