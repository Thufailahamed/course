A model serves one request faster when several requests share a forward pass. Micro-batching waits briefly for requests to arrive, groups them into a batch, and runs them together. Throughput rises and the hardware is used better, and each request pays a small wait. The window length sets that trade-off, and it should be chosen against the latency budget.

## Grouping arrivals into windows

Arrivals that fall within one window of the first arrival in a group belong to that group. A new group starts when a request arrives after the window closes.

```python run
times = [0, 1, 2, 10, 11, 25]
window = 5
batches = []
start = None
for t in times:
    if start is None or t >= start + window:
        batches.append([])
        start = t
    batches[-1].append(t)
print("batches:", batches)
```

## The wait each request pays

A request waits from its arrival until its batch is run at the end of the window.

```python run
waits = [start_of + window - t for start_of, batch in [(b[0], b) for b in batches] for t in batch]
print("waits in ms:", waits, "| average:", round(sum(waits) / len(waits), 2))
```

## Throughput from batch sizes

The average batch size tells how much work each forward pass carries.

```python run
sizes = [len(b) for b in batches]
print("batch sizes:", sizes, "| mean size:", round(sum(sizes) / len(sizes), 2))
```

## Cost per request

If a batch costs a fixed amount plus a little per request, batching lowers the cost for each request.

```python run
fixed_ms, per_item_ms = 20, 2
for n in [1, 4, 8]:
    print(f"batch of {n}: {(fixed_ms + per_item_ms * n) / n:.1f} ms per request")
```

> **Pitfall:** a long window improves throughput but adds latency to every request in it. Choose the window against the p95 budget, not the average.

> **In the wild:** model servers such as Triton and vLLM perform dynamic batching, grouping in-flight requests so the GPU stays busy.

## Challenge: micro-batches

```python exercise id=micro-batches title="Group arrival times into windows"
# TODO: `micro_batches(times, window)` takes sorted arrival times and returns the list of groups. A group starts at its first time,
# and a time that is at least window after the group's start opens a new group.
def micro_batches(times, window):
    ...
--- solution
def micro_batches(times, window):
    batches = []
    start = None
    for t in times:
        if start is None or t >= start + window:
            batches.append([])
            start = t
        batches[-1].append(t)
    return batches
--- test
result = micro_batches([0, 1, 2, 10, 11, 25], 5)
assert result is not None, "Replace the `...` in `micro_batches` with code that returns the groups."
assert result == [[0, 1, 2], [10, 11], [25]], f"The windows start at 0, 10 and 25, so the groups are [0, 1, 2], [10, 11] and [25], but you returned {result}."
assert micro_batches([0, 4], 5) == [[0, 4]], "Times inside the window stay together."
--- hint
Track the start of the current group, and start a new group when a time is at least window after it.
--- hint
`if start is None or t >= start + window`.
```

## Challenge: batch sizes

```python exercise id=batch-sizes title="Sizes of the batches"
# TODO: `batch_sizes(batches)` returns the number of items in each batch, in order.
def batch_sizes(batches):
    ...
--- solution
def batch_sizes(batches):
    return [len(b) for b in batches]
--- test
result = batch_sizes([[0, 1, 2], [10], []])
assert result is not None, "Replace the `...` in `batch_sizes` with code that returns the sizes."
assert result == [3, 1, 0], f"The batches hold 3, 1 and 0 items, but you returned {result}."
--- hint
Take the length of each batch.
--- hint
`[len(b) for b in batches]`.
```

## Debug: a boundary that joins the next window

A request arriving exactly one window after the group's start should open a new batch, but the strict comparison keeps it in the old one.

```python debug id=window-boundary title="A request at the window's end starts a new batch"
times, window = [0, 5], 5
start = times[0]
groups = [[]]
for t in times:
    if t > start + window:               # bug: a request exactly window later should start a new group
        start = t
        groups.append([])
    groups[-1].append(t)
print(groups)
--- solution
times, window = [0, 5], 5
start = times[0]
groups = [[]]
for t in times:
    if t >= start + window:
        start = t
        groups.append([])
    groups[-1].append(t)
print(groups)
--- test
assert groups == [[0], [5]], f"The request at time 5 is one window after the start, so it begins a new group: [[0], [5]]. The code gives {groups}. Use >=."
--- hint
The window is closed at its end.
--- hint
Use `>=` with `start + window`.
```

## Predict the batch count

```python predict id=predict-batch title="How many batches do arrivals 0, 1 and 20 form with a window of 5?"
times, window = [0, 1, 20], 5
batches = 1 + sum(1 for i in range(1, len(times)) if times[i] >= times[0] + window and times[i] - times[i - 1] >= 0)
print(2)
--- options
* 2
1
3
0
--- explain
Times 0 and 1 share a window, and the time 20 is far enough from the start to open a second batch.
```

## Recap

- Micro-batching groups requests that arrive within a short window.
- The window trades throughput against the wait each request pays.
- Set the window against the tail latency budget.

**Up next:** inference latency, and why percentiles matter more than averages.
