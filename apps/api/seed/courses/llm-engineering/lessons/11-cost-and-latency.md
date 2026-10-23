A feature that works but costs too much or responds too slowly is not finished. Hosted models bill per token, with separate prices for input and output, and latency depends on the number of tokens generated and on whether a cache can answer the request. The arithmetic below is the same whatever the provider.

## Cost per request

Prices are usually quoted per million tokens. Input and output are priced separately, and output is often the more expensive.

```python run
def request_cost(in_tokens, out_tokens, price_in, price_out):
    return in_tokens * price_in / 1_000_000 + out_tokens * price_out / 1_000_000

print("one request:", round(request_cost(1000, 500, 3.0, 15.0), 4), "dollars")
```

## Monthly budget

Multiplying the per-request cost by the expected volume gives the budget that finance will ask about.

```python run
per_request = request_cost(1200, 300, 3.0, 15.0)
requests_per_day = 20000
print("monthly cost:", round(per_request * requests_per_day * 30, 2), "dollars")
```

## Caching lowers the average latency

Average latency is the hit rate times the cache latency, plus the miss rate times the model latency.

```python run
def expected_latency(hit_rate, cache_ms, model_ms):
    return hit_rate * cache_ms + (1 - hit_rate) * model_ms

for hit in [0.0, 0.3, 0.6]:
    print(f"hit rate {hit}: {expected_latency(hit, 10, 1200):.0f} ms on average")
```

## Shorter prompts save money

Trimming the prompt by a fixed amount saves that amount on every request, which adds up quickly.

```python run
print("savings per 1000 requests from cutting 400 input tokens:",
      round(request_cost(400, 0, 3.0, 15.0) * 1000, 2), "dollars")
```

> **Pitfall:** a cache keyed on the exact prompt text misses when the prompt contains a timestamp or a user name. Remove the volatile parts from the key.

> **In the wild:** providers now offer prompt caching for long, repeated prefixes, so keeping the stable part of the prompt first can cut input costs sharply.

## Challenge: request cost

```python exercise id=request-cost title="Cost of one request"
# TODO: `request_cost(in_tokens, out_tokens, price_in, price_out)` returns the cost in dollars, where the prices are per
# million tokens.
def request_cost(in_tokens, out_tokens, price_in, price_out):
    ...
--- solution
def request_cost(in_tokens, out_tokens, price_in, price_out):
    return in_tokens * price_in / 1_000_000 + out_tokens * price_out / 1_000_000
--- test
result = request_cost(1000, 500, 3.0, 15.0)
assert result is not None, "Replace the `...` in `request_cost` with code that returns the cost."
assert abs(result - 0.0105) < 1e-9, f"1000 × 3 / 1e6 + 500 × 15 / 1e6 = 0.0105 dollars, but you returned {result}."
assert abs(request_cost(1_000_000, 0, 2.0, 8.0) - 2.0) < 1e-9, "One million input tokens at 2 dollars per million cost 2 dollars."
--- hint
Each price applies per million tokens, so divide each product by 1,000,000.
--- hint
`in_tokens * price_in / 1_000_000 + out_tokens * price_out / 1_000_000`.
```

## Challenge: expected latency

```python exercise id=expected-latency title="Average latency with a cache"
# TODO: `expected_latency(hit_rate, cache_ms, model_ms)` returns the average latency: hit_rate × cache_ms plus
# (1 − hit_rate) × model_ms.
def expected_latency(hit_rate, cache_ms, model_ms):
    ...
--- solution
def expected_latency(hit_rate, cache_ms, model_ms):
    return hit_rate * cache_ms + (1 - hit_rate) * model_ms
--- test
result = expected_latency(0.5, 10, 1000)
assert result is not None, "Replace the `...` in `expected_latency` with code that returns the average."
assert abs(result - 505) < 1e-9, f"Half the requests take 10 ms and half take 1000 ms, so the average is 505, but you returned {result}."
assert abs(expected_latency(0.0, 10, 1000) - 1000) < 1e-9, "With no hits the average is the model latency."
--- hint
Weight each latency by how often that path is taken.
--- hint
`hit_rate * cache_ms + (1 - hit_rate) * model_ms`.
```

## Debug: prices per thousand

The prices are quoted per million tokens, but the code divides as if they were per thousand, which overstates the cost a thousand-fold.

```python debug id=price-units title="Prices are per million tokens"
in_tokens, out_tokens = 1000, 500
price_in, price_out = 3.0, 15.0            # dollars per million tokens
cost = in_tokens * price_in / 1000 + out_tokens * price_out / 1000   # bug: prices are per million
print("cost:", cost)
--- solution
in_tokens, out_tokens = 1000, 500
price_in, price_out = 3.0, 15.0
cost = in_tokens * price_in / 1_000_000 + out_tokens * price_out / 1_000_000
print("cost:", cost)
--- test
assert abs(cost - 0.0105) < 1e-9, f"The request costs 0.0105 dollars, but the code gives {cost}. Divide by one million, not one thousand."
--- hint
Check the units on the price before dividing.
--- hint
Use `1_000_000`.
```

## Predict the input cost

```python predict id=predict-cost title="What does one million input tokens cost at 2 dollars per million?"
print(1_000_000 * 2.0 / 1_000_000)
--- options
* 2.0
0.002
2000.0
1.0
--- explain
The price is per million tokens, so one million tokens cost exactly the quoted price, 2 dollars.
```

## Recap

- Cost is tokens times price per million, computed separately for input and output.
- Average latency depends on the hit rate, so caching pays off in proportion to how often requests repeat.
- Keep stable prompt prefixes first and volatile fields out of cache keys.

**Up next:** guardrails, and a capstone that checks the whole pipeline.
