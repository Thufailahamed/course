This is the capstone. You will design a small environment, train a Q-learning agent on it, and evaluate the agent the way a careful practitioner would: over several seeds, on an independent check, with an uncertainty interval, and with a warning about the failure you should watch for.

The environment is a one-dimensional corridor of seven cells. The agent starts in the middle and the goal pays 10 at the right-hand end. A hazard cell lies between them, and each time the agent steps onto it the agent pays 5, so the best route must pass through it at the lowest cost. Every step costs 0.1, so an agent that lingers is penalized.

## Define the environment

```python run
import numpy as np

N_CELLS = 7
START, GOAL, HAZARD = 3, 6, 4

def env_step(s, a):
    s2 = min(max(s + (1 if a == 1 else -1), 0), N_CELLS - 1)
    if s2 == HAZARD:
        return s2, -5.0, False
    if s2 == GOAL:
        return s2, 10.0, True
    return s2, -0.1, False

print("from the start, stepping right goes to", env_step(START, 1)[0], "and stepping left to", env_step(START, 0)[0])
```

## Train with Q-learning

```python run
def train_q(seed, episodes=300, alpha=0.2, gamma=0.95, eps=0.2):
    rng = np.random.default_rng(seed)
    Q = np.zeros((N_CELLS, 2))
    for _ in range(episodes):
        s, done = START, False
        for _ in range(100):
            a = rng.integers(2) if rng.random() < eps else int(np.argmax(Q[s]))
            s2, r, done = env_step(s, a)
            target = r if done else r + gamma * np.max(Q[s2])
            Q[s, a] += alpha * (target - Q[s, a])
            s = s2
            if done:
                break
    return Q

Q = train_q(0)
print("learned action values (left, right) per cell:")
print(np.round(Q, 2))
```

## Roll out the greedy policy

```python run
def rollout_length(Q, max_steps=50):
    s, steps, total = START, 0, 0.0
    while steps < max_steps:
        s, r, done = env_step(s, int(np.argmax(Q[s])))
        steps += 1
        total += r
        if done:
            return steps, total, True
    return steps, total, False

steps, total, reached = rollout_length(Q)
print("greedy rollout: steps", steps, "| return", round(total, 2), "| reached the goal:", reached)
```

## Evaluate over several seeds

A single training run can be lucky or unlucky. Repeat the whole procedure over several seeds, and report the spread.

```python run
returns = []
for seed in range(8):
    Q_seed = train_q(seed)
    _, total, reached = rollout_length(Q_seed)
    returns.append(total if reached else -10.0)
returns = np.array(returns)
print("returns over 8 seeds:", np.round(returns, 2))
print("mean return:", round(returns.mean(), 2), "| seeds that reached the goal:", int(np.sum(returns > 0)), "of 8")
```

## Report an honest interval

```python run
boot = np.random.default_rng(3)
means = np.array([boot.choice(returns, len(returns)).mean() for _ in range(2000)])
low, high = np.percentile(means, [2.5, 97.5])
print(f"95% bootstrap interval for the mean return: {low:.2f} to {high:.2f}")
```

The interval, not the single best run, is the result you report.

## Challenge: greedy rollout length

```python exercise id=greedy-rollout title="Count the steps of the greedy policy"
import numpy as np

N_CELLS = 7
START, GOAL, HAZARD = 3, 6, 4

def env_step(s, a):
    s2 = min(max(s + (1 if a == 1 else -1), 0), N_CELLS - 1)
    if s2 == HAZARD:
        return s2, -5.0, False
    if s2 == GOAL:
        return s2, 10.0, True
    return s2, -0.1, False

# TODO: `greedy_steps(Q, max_steps)` follows the greedy policy (argmax of Q[s]) from START using env_step, and returns
# the number of steps taken until the goal is reached. If the goal is not reached within max_steps, return None.
def greedy_steps(Q, max_steps):
    ...
--- solution
import numpy as np

N_CELLS = 7
START, GOAL, HAZARD = 3, 6, 4

def env_step(s, a):
    s2 = min(max(s + (1 if a == 1 else -1), 0), N_CELLS - 1)
    if s2 == HAZARD:
        return s2, -5.0, False
    if s2 == GOAL:
        return s2, 10.0, True
    return s2, -0.1, False

def greedy_steps(Q, max_steps):
    s, steps = START, 0
    while steps < max_steps:
        s, _, done = env_step(s, int(np.argmax(Q[s])))
        steps += 1
        if done:
            return steps
    return None
--- test
import numpy as np
Q_good = np.zeros((7, 2))
Q_good[:, 1] = 1.0                       # always prefer moving right
result = greedy_steps(Q_good, 20)
assert result is not None, "Replace the `...` in `greedy_steps` with code that returns the number of steps."
assert result == 3, f"From cell 3 moving right three times reaches the goal at cell 6, so the answer is 3, but you returned {result!r}."
Q_left = np.zeros((7, 2))
Q_left[:, 0] = 1.0                       # always prefer moving left, away from the goal
assert greedy_steps(Q_left, 10) is None, "A policy that never reaches the goal should return None."
--- hint
Start at START and repeat: choose the action with `np.argmax(Q[s])`, apply `env_step`, count the step, and stop when `done` is True.
--- hint
Keep a counter for the steps and return it when `done`. If the loop ends without reaching the goal, return None.
```

## Challenge: average over seeds

```python exercise id=seed-average title="Average the returns over seeds"
import numpy as np

# TODO: `seed_summary(returns)` returns a tuple (mean, fraction_positive) for a list of returns, where fraction_positive
# is the share of runs whose return is greater than zero.
def seed_summary(returns):
    ...
--- solution
import numpy as np

def seed_summary(returns):
    returns = np.asarray(returns, dtype=float)
    return float(returns.mean()), float(np.mean(returns > 0))
--- test
result = seed_summary([4.0, -10.0, 6.0, 2.0])
assert result is not None, "Replace the `...` in `seed_summary` with code that returns the tuple."
mean, frac = result
assert abs(mean - 0.5) < 1e-9, f"The mean of 4, −10, 6 and 2 is 0.5, but you returned {mean!r}."
assert abs(frac - 0.75) < 1e-9, f"Three of four runs are positive, so the fraction is 0.75, but you returned {frac!r}."
--- hint
Use `np.mean` for the average and compare the array with zero for the positive share.
--- hint
`return float(returns.mean()), float(np.mean(returns > 0))`.
```

## Debug the evaluation policy

This evaluation is meant to measure the greedy policy, but it chooses actions at random during the rollout, so its score reflects exploration, not the learned behaviour.

```python debug id=eval-explores title="Evaluate the greedy policy, not an exploring one"
import numpy as np

rng = np.random.default_rng(1)
Q = np.array([[0.0, 1.0]] * 7)           # the learned policy always prefers moving right
s, steps = 3, 0
while s != 6 and steps < 50:
    a = rng.integers(2)                  # bug: the evaluation should follow argmax(Q[s])
    s = min(max(s + (1 if a == 1 else -1), 0), 6)
    steps += 1
print("steps taken:", steps)
--- solution
import numpy as np

rng = np.random.default_rng(1)
Q = np.array([[0.0, 1.0]] * 7)
s, steps = 3, 0
while s != 6 and steps < 50:
    a = int(np.argmax(Q[s]))
    s = min(max(s + (1 if a == 1 else -1), 0), 6)
    steps += 1
print("steps taken:", steps)
--- test
assert steps == 3, f"The greedy policy moves right from cell 3 and reaches cell 6 in 3 steps, but the evaluation took {steps}. Choose the action with argmax, not at random."
--- hint
An evaluation measures the policy you learned, so it must always pick the best-valued action.
--- hint
Replace `rng.integers(2)` with `int(np.argmax(Q[s]))`.
```

## Predict the honest report

```python predict id=predict-report title="Which number should you report?"
print("interval")
--- options
* interval
single best run
training return only
the highest seed
--- explain
A single or best run overstates what the method does on average. Several seeds with an uncertainty interval describe the method honestly, and that is the number to report.
```

## Recap

- Design the environment so that the reward is a faithful measure of the goal, and watch for hacks.
- Train over several seeds, because one run can be lucky.
- Evaluate with a greedy rollout, never an exploring one.
- Report an interval for the mean, and treat a single best run as an anecdote.

**Congratulations.** You now understand how agents learn from rewards, from bandits to PPO and RLHF, and how to judge whether they learned anything real. The final assessment checks the whole course.
