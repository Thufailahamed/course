Welcome to **Reinforcement Learning Essentials**. In supervised learning, someone tells the model the right answer for every example. In reinforcement learning, nobody does. An agent acts, the world responds, and the only feedback is a reward that may arrive long after the action that earned it. Learning to act well in that situation is one of the hardest and most useful problems in machine learning.

This course is for people who are ready for the mathematics. You will meet the central equations, implement the algorithms with NumPy, and check each one against an exact answer where one exists. The deep-learning versions are shown as static PyTorch code for you to run locally, and each has a NumPy version that runs here.

> **How to use this lesson:** read a little, run a little. Every grey box runs in the page.

## Run your first agent

Here is the smallest possible reinforcement-learning loop: an agent in a corridor of five cells, with a reward for reaching the right-hand end. It moves at random for now.

```python run
import numpy as np

rng = np.random.default_rng(0)
position, steps = 0, 0
while position < 4 and steps < 100:
    action = rng.choice([-1, 1])                 # left or right, at random
    position = int(np.clip(position + action, 0, 4))
    steps += 1
print("reached the goal after", steps, "random steps")
```

A random walk eventually finds the goal, but slowly. Reinforcement learning is about learning to reach it quickly, from the rewards alone.

## Predict the return

```python predict id=predict-return title="What is the discounted return?"
rewards = [0.0, 0.0, 1.0]
gamma = 0.5
print(sum(gamma ** t * r for t, r in enumerate(rewards)))
--- options
* 0.25
1.0
0.5
0.125
--- explain
The reward of 1 arrives at time step 2, so it is discounted by gamma squared, which is 0.5 × 0.5 = 0.25. The earlier rewards are zero and add nothing. Discounting makes distant rewards worth less than immediate ones.
```

## Your first challenge

A **challenge** asks you to write a function that the course tests on new data.

```python exercise id=discounted-return title="Compute a discounted return"
# TODO: `discounted_return(rewards, gamma)` returns Σ γᵗ rₜ for the list of rewards, where t starts at 0.
def discounted_return(rewards, gamma):
    ...
--- solution
def discounted_return(rewards, gamma):
    return sum(gamma ** t * r for t, r in enumerate(rewards))
--- test
result = discounted_return([1.0, 1.0, 1.0], 0.5)
assert result is not None, "Replace the `...` in `discounted_return` with code that returns the return."
assert abs(result - 1.75) < 1e-9, f"With gamma 0.5 the return is 1 + 0.5 + 0.25 = 1.75, but you returned {result!r}."
assert discounted_return([], 0.9) == 0, "An empty list of rewards has return 0."
assert abs(discounted_return([0.0, 2.0], 0.1) - 0.2) < 1e-9, "The second reward is discounted by gamma once: 2 × 0.1 = 0.2."
--- hint
Use `enumerate` to get the step number `t` alongside each reward, and multiply the reward by `gamma ** t`.
--- hint
`sum(gamma ** t * r for t, r in enumerate(rewards))`.
```

## Debug the discount

This code is meant to discount rewards by how far in the future they arrive, but it discounts the first reward twice.

```python debug id=double-discount title="Discount each reward once"
rewards = [1.0, 2.0, 3.0]
gamma = 0.5
total = 0.0
for t, r in enumerate(rewards):
    total += gamma ** (t + 1) * r          # bug: the first reward is discounted by gamma once already
print("return:", total)
--- solution
rewards = [1.0, 2.0, 3.0]
gamma = 0.5
total = 0.0
for t, r in enumerate(rewards):
    total += gamma ** t * r
print("return:", total)
--- test
assert abs(total - 2.75) < 1e-9, f"With gamma 0.5 the return is 1 + 2·0.5 + 3·0.25 = 2.75, but the code gives {total}. The first reward should not be discounted."
--- hint
The first reward arrives at time zero, so it should not be discounted at all.
--- hint
Use `gamma ** t`, not `gamma ** (t + 1)`.
```

## Recap

- An agent acts in an environment and receives rewards. Its goal is the total discounted return, not the next reward.
- The discount factor $\gamma$ makes near rewards count more than distant ones.
- Learning must come from rewards alone, with no labelled answers.
- Every method in this course is a different way of estimating or using returns.

**Up next:** agents, environments and rewards in more depth, with the idea of a return made precise.
