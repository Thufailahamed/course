Shipping an agent means knowing what it did, what it cost and whether it stayed safe. Observability records every step as an event. Cost is tokens times price, summed over the steps of each task. The capstone below runs a scripted agent, checks its tool calls against permissions, scores the trajectory and reports the cost, with every step logged.

## A structured event log

Each step is recorded as an event with the task, the step number and what happened, so a failure can be traced to the step that caused it.

```python run
log = []
def record(task, step, event, **details):
    log.append({"task": task, "step": step, "event": event, **details})

record("t1", 1, "tool_call", tool="search")
record("t1", 2, "tool_result", ok=True)
record("t1", 3, "final", answer="42")
print(len(log), "events; last event:", log[-1]["event"])
```

## Token cost per task

A task's cost is its total tokens times the price per million tokens, divided by one million.

```python run
tokens_per_step = 1000
steps = 5
price_per_million = 3.0
print("cost of the task:", round(tokens_per_step * steps * price_per_million / 1_000_000, 4), "dollars")
```

## A safety gate on each call

Before a tool runs, its permission tier is checked, and the call is logged with the decision.

```python run
policy = {"search": "read", "email": "write"}
decision = {"read": "allow", "write": "confirm"}
for tool in ["search", "email"]:
    print(tool, "->", decision[policy[tool]])
```

## Summary of a suite

The capstone summarizes the runs with success rate and average steps, the two numbers an on-call engineer checks first.

```python run
runs = [{"success": True, "steps": 2}, {"success": False, "steps": 4}, {"success": True, "steps": 3}]
rate = sum(r["success"] for r in runs) / len(runs)
avg_steps = sum(r["steps"] for r in runs) / len(runs)
print("success rate:", round(rate, 3), "| average steps:", round(avg_steps, 3))
```

> **Pitfall:** logs that record only the final answer make a bad run impossible to diagnose. Log each tool call and its result, and keep the logs for the length of your incident window.

> **In the wild:** agent platforms show a trace for every run, with the cost per step, so the team can see which step burned the budget.

## Challenge: task cost

```python exercise id=task-cost title="Cost of one agent task"
# TODO: `task_cost(tokens_per_step, steps, price_per_million)` returns the dollar cost of a task with the given tokens per step
# and number of steps, at a price per million tokens.
def task_cost(tokens_per_step, steps, price_per_million):
    ...
--- solution
def task_cost(tokens_per_step, steps, price_per_million):
    return tokens_per_step * steps * price_per_million / 1_000_000
--- test
result = task_cost(1000, 5, 3.0)
assert result is not None, "Replace the `...` in `task_cost` with code that returns the cost."
assert abs(result - 0.015) < 1e-9, f"5000 tokens at 3 dollars per million is 0.015 dollars, but you returned {result}."
--- hint
Total tokens times the price, divided by one million.
--- hint
`tokens_per_step * steps * price_per_million / 1_000_000`.
```

## Challenge: suite summary

```python exercise id=summarize title="Summarize a suite of runs"
# TODO: `summarize(results)` takes a list of dictionaries with keys "success" (bool) and "steps" (int). It returns
# {"success_rate": share of successful runs, "avg_steps": mean number of steps} as floats.
def summarize(results):
    ...
--- solution
def summarize(results):
    n = len(results)
    return {
        "success_rate": sum(r["success"] for r in results) / n,
        "avg_steps": sum(r["steps"] for r in results) / n,
    }
--- test
result = summarize([{"success": True, "steps": 2}, {"success": False, "steps": 4}])
assert result is not None, "Replace the `...` in `summarize` with code that returns the summary."
assert abs(result["success_rate"] - 0.5) < 1e-9, "One of two runs succeeded, so the rate is 0.5."
assert abs(result["avg_steps"] - 3.0) < 1e-9, "Two and four steps average to 3."
--- hint
Sum the flags and divide by the number of runs, for each measure.
--- hint
Booleans add as 0 and 1 in Python.
```

## Debug: the wrong divisor

The average should divide the total steps by the number of runs, but this version divides by the number of successful runs.

```python debug id=average-divisor title="Average over all runs"
results = [{"success": True, "steps": 2}, {"success": False, "steps": 4}]
avg_steps = sum(r["steps"] for r in results) / sum(r["success"] for r in results)   # bug: divides by successes
print("average steps:", avg_steps)
--- solution
results = [{"success": True, "steps": 2}, {"success": False, "steps": 4}]
avg_steps = sum(r["steps"] for r in results) / len(results)
print("average steps:", avg_steps)
--- test
assert abs(avg_steps - 3.0) < 1e-9, f"Two runs with 2 and 4 steps average 3, but the code gives {avg_steps}. Divide by the number of runs."
--- hint
The average is over every run, not only the successful ones.
--- hint
Use `len(results)`.
```

## Predict the rate

```python predict id=predict-cap title="What is the success rate when one of two runs succeeds?"
results = [{"success": True}, {"success": False}]
print(sum(r["success"] for r in results) / len(results))
--- options
* 0.5
1.0
0.0
2.0
--- explain
One success out of two runs gives a rate of one half.
```

## Capstone: a monitored run

This capstone ties the course together. A scripted agent calls a tool, a gate checks it against the policy, the trajectory is scored and the cost is reported, with every step recorded.

```python run
replies = [
    {"tool": "search", "args": {"q": "order 42"}},
    {"tool": "email", "args": {"to": "a@b.com"}},
    {"tool": "final", "answer": "shipped"},
]
policy = {"search": "read", "email": "write", "final": "read"}
decision = {"read": "allow", "write": "confirm"}
log = []
actions = []
for step, reply in enumerate(replies, start=1):
    tool = reply["tool"]
    verdict = decision.get(policy.get(tool), "deny") if tool != "final" else "allow"
    log.append({"step": step, "tool": tool, "verdict": verdict})
    actions.append({"tool": tool, "answer": reply.get("answer")})
    if verdict == "confirm":
        log.append({"step": step, "event": "waiting for user confirmation"})
        break
success = actions[-1]["answer"] == "shipped"
cost = 3 * 1000 * 3.0 / 1_000_000
print("log:", log)
print("success:", success, "| steps:", len(actions), "| cost:", round(cost, 6), "dollars")
```

> **Pitfall:** a gate that stops at a confirmation and silently continues later hides the approval step. Log the wait, and resume only with a recorded decision.

## Recap

- Log each step as an event, so a failure can be traced to its step.
- Cost is tokens times price, summed over the steps of each task.
- Gate every risky tool call, and summarize the suite with the numbers an on-call engineer checks.

**Up next:** the final assessment covers the whole course.
