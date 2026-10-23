Several agents are not better by default. Each agent and the orchestrator make their own model calls with their own context, and every call is billed. Multi-agent designs pay off when the subtasks are independent and large, so that parallel specialists finish sooner and each keeps a focused context. For a short sequential task, a single agent usually does the job for far less.

## Cost of a multi-agent design

The total is the workers' calls times their tokens, plus the orchestrator's calls times its tokens.

```python run
def multi_agent_cost(n_workers, calls_per_worker, tokens_per_call, orchestrator_calls, orchestrator_tokens):
    return n_workers * calls_per_worker * tokens_per_call + orchestrator_calls * orchestrator_tokens

print("3 workers, 4 calls each, 1000 tokens, orchestrator 2 calls of 500:",
      multi_agent_cost(3, 4, 1000, 2, 500))
```

## Cost of a single agent

A single agent makes its calls with one growing context, so the comparison is a matter of counting calls and tokens.

```python run
single = 8 * 1000
print("single agent, 8 calls of 1000 tokens:", single)
```

## Comparing the two

The comparison shows the overhead that coordination adds for the same amount of work.

```python run
multi = multi_agent_cost(3, 4, 1000, 2, 500)
print("multi-agent costs", round(multi / single, 2), "times the single agent")
```

## Latency with parallel workers

Parallel workers finish in the time of the slowest one, plus the orchestrator's steps, which is the case where a multi-agent design wins.

```python run
worker_seconds = [4.0, 5.0, 3.5]
orchestrator_seconds = 1.0
print("parallel latency:", max(worker_seconds) + orchestrator_seconds, "seconds")
print("sequential latency:", sum(worker_seconds) + orchestrator_seconds, "seconds")
```

> **Pitfall:** adding agents to a task that does not split cleanly multiplies cost and adds failure modes, such as workers that disagree. Start with one agent, and split only when a measured limit appears.

> **In the wild:** teams use multi-agent designs for broad research and parallel data gathering, and a single agent for most tool-using tasks.

## Challenge: multi-agent cost

```python exercise id=multi-cost title="Total tokens of a multi-agent run"
# TODO: `multi_agent_cost(n_workers, calls_per_worker, tokens_per_call, orchestrator_calls, orchestrator_tokens)` returns the total
# tokens: n_workers × calls_per_worker × tokens_per_call plus orchestrator_calls × orchestrator_tokens.
def multi_agent_cost(n_workers, calls_per_worker, tokens_per_call, orchestrator_calls, orchestrator_tokens):
    ...
--- solution
def multi_agent_cost(n_workers, calls_per_worker, tokens_per_call, orchestrator_calls, orchestrator_tokens):
    return n_workers * calls_per_worker * tokens_per_call + orchestrator_calls * orchestrator_tokens
--- test
result = multi_agent_cost(3, 4, 1000, 2, 500)
assert result is not None, "Replace the `...` in `multi_agent_cost` with code that returns the total."
assert result == 13000, f"Workers use 3 × 4 × 1000 = 12000 and the orchestrator uses 2 × 500 = 1000, so the total is 13000, but you returned {result}."
assert multi_agent_cost(1, 1, 10, 0, 0) == 10, "One worker call with no orchestrator is just that call."
--- hint
Add the two products.
--- hint
`n_workers * calls_per_worker * tokens_per_call + orchestrator_calls * orchestrator_tokens`.
```

## Challenge: single-agent cost

```python exercise id=single-cost title="Tokens of a single agent"
# TODO: `single_cost(calls, tokens_per_call)` returns the total tokens of a single agent: calls times tokens_per_call.
def single_cost(calls, tokens_per_call):
    ...
--- solution
def single_cost(calls, tokens_per_call):
    return calls * tokens_per_call
--- test
result = single_cost(8, 1000)
assert result is not None, "Replace the `...` in `single_cost` with code that returns the total."
assert result == 8000, f"Eight calls of 1000 tokens is 8000, but you returned {result}."
assert single_cost(0, 500) == 0, "No calls means no tokens."
--- hint
Multiply the number of calls by the tokens per call.
--- hint
`return calls * tokens_per_call`.
```

## Debug: forgetting the orchestrator

The total should include the orchestrator's calls, but this version counts only the workers.

```python debug id=orchestrator-cost title="Count the orchestrator too"
n_workers, calls_per_worker, tokens_per_call = 3, 4, 1000
orchestrator_calls, orchestrator_tokens = 2, 500
total = n_workers * calls_per_worker * tokens_per_call     # bug: the orchestrator's calls are missing
print("total tokens:", total)
--- solution
n_workers, calls_per_worker, tokens_per_call = 3, 4, 1000
orchestrator_calls, orchestrator_tokens = 2, 500
total = n_workers * calls_per_worker * tokens_per_call + orchestrator_calls * orchestrator_tokens
print("total tokens:", total)
--- test
assert total == 13000, f"The workers use 12000 tokens and the orchestrator 1000, so the total is 13000, but the code gives {total}. Add the orchestrator's tokens."
--- hint
Every model call is billed, including the ones the orchestrator makes.
--- hint
Add `orchestrator_calls * orchestrator_tokens`.
```

## Predict the single-agent cost

```python predict id=predict-single title="How many tokens does a single agent use with 8 calls of 1000 tokens?"
print(8 * 1000)
--- options
* 8000
1000
8
80000
--- explain
Eight calls of 1000 tokens each is 8000 tokens.
```

## Recap

- Multi-agent designs add coordination calls, and every call is billed.
- They pay off for independent, large subtasks, where parallel workers cut the latency.
- Start with a single agent, and split only when measurement shows the need.

**Up next:** evaluating whole trajectories, not just final answers.
