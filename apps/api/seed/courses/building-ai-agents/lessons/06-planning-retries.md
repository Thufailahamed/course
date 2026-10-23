A plan breaks a task into steps, and an executor runs them in order. Real steps fail: a fetch times out, a parse finds an unexpected format. A reliable agent retries a failed step a bounded number of times, then stops and reports, rather than retrying forever or silently skipping the failure. The retry budget is the number that controls both cost and recovery.

## A plan as data

A plan is a list of steps with a status. Keeping the status in data makes it easy to resume and to inspect.

```python run
plan = [{"step": "fetch orders", "done": False}, {"step": "summarize", "done": False}]

def next_step(plan):
    for s in plan:
        if not s["done"]:
            return s["step"]
    return None

print("next:", next_step(plan))
plan[0]["done"] = True
print("next:", next_step(plan))
```

## Retrying one step

A scripted outcome table makes the first attempt at one step fail. The loop retries until the step succeeds or the budget runs out.

```python run
outcomes = {("parse", 1): False}

def run_once(step, attempt):
    return outcomes.get((step, attempt), True)

for step in ["fetch", "parse"]:
    attempt = 1
    while not run_once(step, attempt) and attempt < 3:
        attempt += 1
    print(step, "succeeded on attempt", attempt)
```

## The retry budget sets the attempts

With a budget of r retries, each step gets r + 1 attempts in total.

```python run
for retries in [0, 1, 3]:
    print(f"{retries} retries -> {retries + 1} attempts per step")
```

## The worst-case cost

Every attempt is a model call, so the worst case is the plan's steps times the attempts times the tokens per call.

```python run
per_step_tokens = 800
retries = 1
print("worst-case tokens for 3 steps:", 3 * per_step_tokens * (retries + 1))
```

> **Pitfall:** retrying a write step can repeat its side effect, such as charging a card twice. Retry only steps that are safe to repeat, or make the write idempotent with a key.

> **In the wild:** agent runs record each attempt, and the on-call engineer can see exactly which step failed and how many times it was retried.

## Challenge: execute a plan

```python exercise id=execute-plan title="Run a plan with bounded retries"
# TODO: `execute_plan(steps, run_step, max_retries)` runs each step in order. run_step(step, attempt) returns (ok, output),
# with attempts numbered from 1. A step gets max_retries + 1 attempts. Append the output when a step succeeds and go on to
# the next step. If a step fails every attempt, stop and return the outputs so far.
def execute_plan(steps, run_step, max_retries):
    ...
--- solution
def execute_plan(steps, run_step, max_retries):
    results = []
    for step in steps:
        for attempt in range(1, max_retries + 2):
            ok, output = run_step(step, attempt)
            if ok:
                results.append(output)
                break
        else:
            return results
    return results
--- test
attempts = []
def run_step(step, attempt):
    attempts.append((step, attempt))
    if step == "parse" and attempt == 1:
        return False, None
    return True, f"{step} done"

out = execute_plan(["fetch", "parse", "report"], run_step, max_retries=1)
assert out is not None, "Replace the `...` in `execute_plan` with code that runs the plan."
assert out == ["fetch done", "parse done", "report done"], f"The parse step succeeds on its retry, so all three outputs appear, but you returned {out}."
assert attempts == [("fetch", 1), ("parse", 1), ("parse", 2), ("report", 1)], f"The attempts should be fetch 1, parse 1 and 2, then report 1, but they were {attempts}."
stuck = []
def always_fail(step, attempt):
    stuck.append(attempt)
    return False, None
assert execute_plan(["a", "b"], always_fail, max_retries=2) == [], "A step that never succeeds stops the plan with no outputs."
assert stuck == [1, 2, 3], "The first step gets max_retries + 1 attempts, numbered from 1."
--- hint
Loop over the attempts with `range(1, max_retries + 2)`, and use the `else` of the inner loop to stop when every attempt has failed.
--- hint
`for attempt in range(1, max_retries + 2):` followed by `break` on success.
```

## Challenge: the next step

```python exercise id=next-step title="The next unfinished step"
# TODO: `next_step(plan)` returns the name of the first step whose done flag is False, or None when every step is done.
def next_step(plan):
    ...
--- solution
def next_step(plan):
    for s in plan:
        if not s["done"]:
            return s["step"]
    return None
--- test
result = next_step([{"step": "a", "done": True}, {"step": "b", "done": False}])
assert result is not None, "Replace the `...` in `next_step` with code that returns the step."
assert result == "b", f"Step a is done, so the next step is b, but you returned {result!r}."
assert next_step([{"step": "a", "done": True}]) is None, "When every step is done there is no next step."
--- hint
Loop over the plan and return the first step that is not done.
--- hint
Return None after the loop.
```

## Debug: one retry too few

With one retry allowed, each step should get two attempts, but the loop only makes one.

```python debug id=retry-count title="Give the retry budget its attempts"
max_retries = 1
attempts = 0
for _ in range(max_retries):      # bug: this makes one attempt, not max_retries + 1
    attempts += 1
print("attempts allowed:", attempts)
--- solution
max_retries = 1
attempts = 0
for _ in range(max_retries + 1):
    attempts += 1
print("attempts allowed:", attempts)
--- test
assert attempts == 2, f"One retry means two attempts in total, but the code allows {attempts}. The number of attempts is max_retries + 1."
--- hint
The first attempt is not a retry, so it must be counted too.
--- hint
Use `range(max_retries + 1)`.
```

## Predict the attempts

```python predict id=predict-attempts title="How many attempts are recorded when the first fails and the second succeeds?"
attempts = [False, True]
print(len(attempts))
--- options
* 2
1
0
3
--- explain
Two attempts were made, the first failing and the retry succeeding.
```

## Recap

- A plan is data: steps with a status, which the executor updates.
- A retry budget bounds the attempts, so recovery has a clear cost.
- Retry only steps that are safe to repeat, and log every attempt.

**Up next:** memory, the part of the agent that holds what it has learned.
