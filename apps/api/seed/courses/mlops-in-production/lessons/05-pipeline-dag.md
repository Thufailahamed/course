A training pipeline is a graph of tasks: ingest the data, build features, train, evaluate, publish. Each task depends on the tasks before it. Running them in a valid order is a topological sort, and a graph with a cycle has no valid order at all, which is a bug to catch before the pipeline runs.

## The dependency graph

Each task lists the tasks it needs. The graph is data, so a scheduler can read it.

```python run
deps = {
    "ingest": [],
    "features": ["ingest"],
    "train": ["features"],
    "report": ["train"],
}
print("edges:", sum(len(v) for v in deps.values()))
```

## Running in dependency order

A task is ready when all of its prerequisites are done. Repeatedly running a ready task gives a valid order.

```python run
remaining = {t: set(p) for t, p in deps.items()}
order = []
while remaining:
    ready = sorted(t for t, pre in remaining.items() if not pre)
    t = ready[0]
    order.append(t)
    del remaining[t]
    for pre in remaining.values():
        pre.discard(t)
print("order:", order)
```

## A cycle has no order

If two tasks need each other, no task is ever ready, and the scheduler must stop with an error.

```python run
cyclic = {"a": ["b"], "b": ["a"]}
remaining = {t: set(p) for t, p in cyclic.items()}
ready = [t for t, pre in remaining.items() if not pre]
print("ready tasks at the start:", ready)
```

## Counting the tasks ready to run first

The tasks with no prerequisites can run in parallel at the start of the pipeline.

```python run
starting = [t for t, pre in deps.items() if not pre]
print("can start immediately:", starting)
```

> **Pitfall:** a pipeline that runs tasks in the order they were written works until someone reorders the file. Derive the order from the dependencies.

> **In the wild:** orchestrators such as Airflow and Prefect build this graph, check it for cycles when a pipeline is deployed, and run independent branches in parallel.

## Challenge: topological order

```python exercise id=topo-order title="Order tasks by their dependencies"
# TODO: `topo_order(deps)` takes a dictionary from task to the list of tasks it needs. It returns the tasks in an order where each
# task comes after its prerequisites. Among ready tasks choose the alphabetically first. Raise ValueError if the graph has a
# cycle.
def topo_order(deps):
    ...
--- solution
def topo_order(deps):
    remaining = {t: set(p) for t, p in deps.items()}
    order = []
    while remaining:
        ready = sorted(t for t, pre in remaining.items() if not pre)
        if not ready:
            raise ValueError("cycle")
        t = ready[0]
        order.append(t)
        del remaining[t]
        for pre in remaining.values():
            pre.discard(t)
    return order
--- test
deps = {"train": ["features"], "features": ["ingest"], "ingest": [], "report": ["train"]}
result = topo_order(deps)
assert result is not None, "Replace the `...` in `topo_order` with code that returns the order."
assert result == ["ingest", "features", "train", "report"], f"The only valid order is ingest, features, train, report, but you returned {result}."
try:
    topo_order({"a": ["b"], "b": ["a"]})
    raised = False
except ValueError:
    raised = True
assert raised, "A cycle must raise ValueError."
--- hint
Repeatedly take a task whose prerequisites are all done, and remove it from the remaining prerequisites of the others.
--- hint
If no task is ready while tasks remain, the graph has a cycle.
```

## Challenge: valid graph check

```python exercise id=valid-dag title="Is the graph free of cycles?"
# TODO: `is_valid_dag(deps)` returns True if the dependency graph has an order, and False if it has a cycle. Use `topo_order`
# below, which is provided.
def topo_order(deps):
    remaining = {t: set(p) for t, p in deps.items()}
    order = []
    while remaining:
        ready = sorted(t for t, pre in remaining.items() if not pre)
        if not ready:
            raise ValueError("cycle")
        t = ready[0]
        order.append(t)
        del remaining[t]
        for pre in remaining.values():
            pre.discard(t)
    return order

def is_valid_dag(deps):
    ...
--- solution
def topo_order(deps):
    remaining = {t: set(p) for t, p in deps.items()}
    order = []
    while remaining:
        ready = sorted(t for t, pre in remaining.items() if not pre)
        if not ready:
            raise ValueError("cycle")
        t = ready[0]
        order.append(t)
        del remaining[t]
        for pre in remaining.values():
            pre.discard(t)
    return order

def is_valid_dag(deps):
    try:
        topo_order(deps)
        return True
    except ValueError:
        return False
--- test
assert is_valid_dag({"a": [], "b": ["a"]}) is True, "A simple chain has an order."
assert is_valid_dag({"a": ["b"], "b": ["a"]}) is False, "A two-task cycle has no order."
--- hint
Wrap the call in a try block and catch ValueError.
--- hint
Return True when no error is raised.
```

## Debug: running in declared order

The pipeline should train only after the features are built, but this version runs the tasks in the order they appear in the dictionary.

```python debug id=declared-order title="Run prerequisites first"
deps = {"train": ["features"], "features": ["ingest"], "ingest": []}
order = list(deps)                  # bug: the declared order ignores the dependencies
print("run order:", order)
print("train before features:", order.index("train") < order.index("features"))
--- solution
deps = {"train": ["features"], "features": ["ingest"], "ingest": []}
order = ["ingest", "features", "train"]
print("run order:", order)
print("train before features:", order.index("train") < order.index("features"))
--- test
assert order.index("features") < order.index("train"), "Features must be built before train, but the order puts train first. Derive the order from the dependencies."
--- hint
The declared order lists train first, even though it needs features.
--- hint
Use the order that `topo_order` produces.
```

## Predict the edge count

```python predict id=predict-edges title="How many dependency edges are in this graph?"
deps = {"train": ["features"], "features": ["ingest"], "ingest": [], "report": ["train"]}
print(sum(len(v) for v in deps.values()))
--- options
* 3
4
2
1
--- explain
The edges are features to ingest, train to features, and report to train, which makes three.
```

## Recap

- A pipeline is a dependency graph, and the run order is a topological sort.
- A cycle has no valid order, so detect it before running.
- Derive the order from the dependencies, not from the way the file is written.

**Up next:** feature stores, and how to build features that match what the model sees in production.
