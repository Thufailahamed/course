Features can be computed in batches ahead of time, or on demand when a request arrives. Batch features are cheap and consistent, but they can be hours old. Online features are fresh, but they cost latency and infrastructure on every request. Caching sits between the two: a stored value is served while it is fresh enough, then recomputed. The time-to-live decides how stale a served value may be.

## Batch versus online

The choice trades freshness against cost and latency. A table makes the trade explicit.

```python run
options = {
    "batch": {"freshness_hours": 24, "latency_ms": 2, "cost_per_1k": 0.10},
    "online": {"freshness_hours": 0, "latency_ms": 40, "cost_per_1k": 0.60},
}
for name, o in options.items():
    print(f"{name:>6}: fresh within {o['freshness_hours']} h, {o['latency_ms']} ms, ${o['cost_per_1k']} per 1000")
```

## Cache hits

A cache answers repeated requests without recomputing. The hit rate shows how much work it saves.

```python run
requests = ["u1", "u2", "u1", "u1", "u3", "u2"]
seen = set()
hits = 0
for key in requests:
    if key in seen:
        hits += 1
    seen.add(key)
print("hit rate:", round(hits / len(requests), 3))
```

## Staleness

A cached value has an age, and it is fresh while the age is within the time-to-live.

```python run
computed_at, now, ttl = 0, 45, 60
age = now - computed_at
print("age:", age, "| fresh:", age <= ttl)
```

## The cost of a miss

Every miss pays the full computation. The expected cost per request mixes hits and misses.

```python run
hit_rate, hit_ms, miss_ms = 0.8, 2, 40
print("expected latency:", round(hit_rate * hit_ms + (1 - hit_rate) * miss_ms, 1), "ms")
```

> **Pitfall:** serving a cached feature that is older than the model expects can silently change predictions. Set the time-to-live from the feature's update rate, not from convenience.

> **In the wild:** teams use batch features for slow signals, such as a customer's lifetime spend, and online features for fast ones, such as the number of clicks in the last minute.

## Challenge: serve with a cache

```python exercise id=serve title="Serve from a cache while the value is fresh"
# TODO: `serve(cache, key, now, ttl, compute)` returns a cached value when cache[key] holds (value, computed_at) and now minus
# computed_at is at most ttl. Otherwise it calls compute(), stores (value, now) in cache under key, and returns the value.
def serve(cache, key, now, ttl, compute):
    ...
--- solution
def serve(cache, key, now, ttl, compute):
    if key in cache:
        value, computed_at = cache[key]
        if now - computed_at <= ttl:
            return value
    value = compute()
    cache[key] = (value, now)
    return value
--- test
calls = []
def compute():
    calls.append(1)
    return 42
cache = {}
first = serve(cache, "f", 0, 60, compute)
assert first is not None, "Replace the `...` in `serve` with code that returns the value."
assert first == 42 and len(calls) == 1, "The first request computes the value."
assert serve(cache, "f", 30, 60, compute) == 42 and len(calls) == 1, "A fresh value is served without recomputing."
assert serve(cache, "f", 100, 60, compute) == 42 and len(calls) == 2, "An expired value is recomputed."
--- hint
Check the entry, then its age against the time-to-live. Recompute in all other cases.
--- hint
`if now - computed_at <= ttl: return value`.
```

## Challenge: hit rate

```python exercise id=hit-rate title="Share of requests served from cache"
# TODO: `hit_rate(hits, requests)` returns hits divided by requests as a float, and 0.0 when there are no requests.
def hit_rate(hits, requests):
    ...
--- solution
def hit_rate(hits, requests):
    return hits / requests if requests else 0.0
--- test
result = hit_rate(3, 4)
assert result is not None, "Replace the `...` in `hit_rate` with code that returns the rate."
assert abs(result - 0.75) < 1e-9, f"Three hits in four requests is 0.75, but you returned {result}."
assert hit_rate(0, 0) == 0.0, "No requests gives a rate of zero, not an error."
--- hint
Guard the division when the request count is zero.
--- hint
`hits / requests if requests else 0.0`.
```

## Debug: an age exactly at the limit

A value whose age equals the time-to-live should still be fresh, but the comparison expires it one tick early.

```python debug id=ttl-boundary title="Accept an age equal to the time-to-live"
ttl = 60
computed_at, now = 0, 60
fresh = now - computed_at < ttl          # bug: an age exactly equal to ttl is still fresh
print("fresh:", fresh)
--- solution
ttl = 60
computed_at, now = 0, 60
fresh = now - computed_at <= ttl
print("fresh:", fresh)
--- test
assert fresh is True, "An age equal to the time-to-live is still within it, so the value is fresh. Use <= in the comparison."
--- hint
The time-to-live is inclusive.
--- hint
Use `<=`.
```

## Predict the freshness

```python predict id=predict-fresh title="Is a value computed 70 units ago fresh with a time-to-live of 60?"
age, ttl = 70, 60
print(age <= ttl)
--- options
* False
True
None
1
--- explain
An age of 70 is larger than the time-to-live of 60, so the value has expired and must be recomputed.
```

## Recap

- Batch features are cheap and consistent but can be stale, and online features are fresh but cost latency.
- A cache serves values while they are fresh, and the time-to-live sets the limit.
- Track the hit rate, because it decides how much work the cache saves.

**Up next:** serving patterns, starting with micro-batching requests.
