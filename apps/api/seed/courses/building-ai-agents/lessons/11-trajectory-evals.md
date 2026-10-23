An agent's final answer can be right for the wrong reasons. It may have called a tool it was not allowed to use, taken twelve steps where three would do, or guessed and been lucky. A trajectory evaluation scores the whole sequence of actions: whether the final answer matches, how many steps it took, and whether any forbidden action appeared along the way.

## A trajectory as data

A trajectory is the list of actions the agent took, each with its tool and, for the last one, its answer.

```python run
trajectory = [
    {"tool": "search", "answer": None},
    {"tool": "delete", "answer": None},
    {"tool": "final", "answer": "42"},
]
print("steps:", len(trajectory), "| tools:", [a["tool"] for a in trajectory])
```

## Did the answer match?

The final action carries the answer, so success is checked on the last action only.

```python run
expected = "42"
print("success:", trajectory[-1]["answer"] == expected)
```

## A forbidden action

A policy names the tools a task must never use. The check looks at every action, not only the answer.

```python run
forbidden = {"delete"}
violated = any(a["tool"] in forbidden for a in trajectory)
print("policy violated:", violated)
```

## Scoring many runs

A suite of trajectories is summarized by the rate of success, the average steps and the count of violations.

```python run
runs = [
    [{"tool": "search", "answer": None}, {"tool": "final", "answer": "42"}],
    [{"tool": "search", "answer": None}, {"tool": "final", "answer": "41"}],
]
successes = sum(r[-1]["answer"] == "42" for r in runs)
print("success rate:", successes / len(runs), "| average steps:", sum(len(r) for r in runs) / len(runs))
```

> **Pitfall:** a suite that checks only final answers rewards agents that guess and agents that break policy whenever the answer is right. Score the trajectory as well.

> **In the wild:** agent teams keep a suite of tasks with expected answers and forbidden tools, and fail a release when either the success rate or the violation count gets worse.

## Challenge: score a trajectory

```python exercise id=score-trajectory title="Score one agent run"
# TODO: `score_trajectory(actions, expected, forbidden)` takes a list of action dictionaries with keys "tool" and "answer". It
# returns {"success": bool, "steps": int, "violated": bool}. success is True when the last action's answer equals expected.
# violated is True when any action's tool is in the forbidden set.
def score_trajectory(actions, expected, forbidden):
    ...
--- solution
def score_trajectory(actions, expected, forbidden):
    return {
        "success": actions[-1]["answer"] == expected,
        "steps": len(actions),
        "violated": any(a["tool"] in forbidden for a in actions),
    }
--- test
actions = [{"tool": "search", "answer": None}, {"tool": "delete", "answer": None}, {"tool": "final", "answer": "42"}]
result = score_trajectory(actions, "42", {"delete"})
assert result is not None, "Replace the `...` in `score_trajectory` with code that returns the score."
assert result == {"success": True, "steps": 3, "violated": True}, f"The answer matches, there are three steps, and delete was used, but you returned {result}."
clean = score_trajectory([{"tool": "search", "answer": None}, {"tool": "final", "answer": "41"}], "42", {"delete"})
assert clean == {"success": False, "steps": 2, "violated": False}, "A wrong answer with no forbidden tool is not a success and not a violation."
--- hint
Check the last action for the answer, the length for steps, and the tools of all actions against the forbidden set.
--- hint
`any(a["tool"] in forbidden for a in actions)`.
```

## Challenge: success rate

```python exercise id=success-rate title="Share of runs that reached the expected answer"
# TODO: `success_rate(runs)` takes a list of (actions, expected) pairs. A run succeeds when its last action's answer equals
# expected. Return the share of runs that succeed, as a float.
def success_rate(runs):
    ...
--- solution
def success_rate(runs):
    wins = sum(actions[-1]["answer"] == expected for actions, expected in runs)
    return wins / len(runs)
--- test
result = success_rate([([{"tool": "f", "answer": "x"}], "x"), ([{"tool": "f", "answer": "y"}], "x")])
assert result is not None, "Replace the `...` in `success_rate` with code that returns the rate."
assert abs(result - 0.5) < 1e-9, f"One of the two runs ends with the expected answer, so the rate is 0.5, but you returned {result}."
assert success_rate([([{"tool": "f", "answer": "x"}], "x")]) == 1.0, "A single successful run has rate one."
--- hint
Compare the last action's answer with the expected answer for each run.
--- hint
Sum the booleans and divide by the number of runs.
```

## Debug: the first action instead of the last

Success should be decided by the final answer, but this version reads the first action, which has no answer.

```python debug id=first-action title="Check the final answer, not the first action"
actions = [{"tool": "search", "answer": None}, {"tool": "final", "answer": "42"}]
expected = "42"
success = actions[0]["answer"] == expected        # bug: the answer is on the last action
print("success:", success)
--- solution
actions = [{"tool": "search", "answer": None}, {"tool": "final", "answer": "42"}]
expected = "42"
success = actions[-1]["answer"] == expected
print("success:", success)
--- test
assert success is True, f"The final answer 42 matches, so the run succeeded, but the code says {success}. Read the answer from the last action."
--- hint
The answer is produced at the end of the run.
--- hint
Use `actions[-1]`.
```

## Predict the success rate

```python predict id=predict-rate title="What is the success rate when three of four runs succeed?"
print(3 / 4)
--- options
* 0.75
0.5
0.25
3.0
--- explain
Three of four runs succeeded, so the rate is 3 divided by 4.
```

## Recap

- Score the whole trajectory: the answer, the steps and any forbidden action.
- Summarize a suite with success rate, average steps and violations.
- Fail a release on a worse result in any of those numbers.

**Up next:** observability, cost and a capstone that combines the pieces.
