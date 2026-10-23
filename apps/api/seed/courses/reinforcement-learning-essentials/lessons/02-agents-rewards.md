Reinforcement learning has four moving parts. The **agent** chooses actions. The **environment** responds to each action with a new situation and a reward. A **policy** is the agent's rule for choosing actions, and the **return** is the total reward the agent is trying to maximize. Almost every algorithm in this course is a way of improving a policy by estimating returns.

## The interaction loop

At each step the agent observes a state $s_t$, picks an action $a_t$, and the environment returns a reward $r_{t+1}$ and the next state $s_{t+1}$. The sequence of those steps is an **episode**.

```python run
import numpy as np

class Corridor:
    """Five cells in a row. Reaching cell 4 gives reward 1 and ends the episode."""
    def __init__(self):
        self.n = 5
    def reset(self):
        self.s = 0
        return self.s
    def step(self, action):                  # action 0 = left, 1 = right
        self.s = int(np.clip(self.s + (1 if action == 1 else -1), 0, self.n - 1))
        done = self.s == self.n - 1
        return self.s, (1.0 if done else 0.0), done

env = Corridor()
state = env.reset()
trajectory = []
done = False
while not done:
    action = 1                               # a fixed policy: always move right
    next_state, reward, done = env.step(action)
    trajectory.append((state, action, reward))
    state = next_state
print("trajectory (state, action, reward):", trajectory)
```

A trajectory is the raw data of reinforcement learning. Every learning algorithm reads these tuples and asks which actions led to good returns.

## Returns: what the agent optimizes

The return from time $t$ is the discounted sum of future rewards:

$$
G_t = r_{t+1} + \gamma\, r_{t+2} + \gamma^2 r_{t+3} + \dots = \sum_{k=0}^{\infty} \gamma^k r_{t+k+1}
$$

The discount $\gamma$ between 0 and 1 expresses two things: a preference for sooner rewards, and uncertainty about the far future.

```python run
def returns_from(rewards, gamma):
    G, out = 0.0, []
    for r in reversed(rewards):              # work backwards so each return reuses the next one
        G = r + gamma * G
        out.append(G)
    return list(reversed(out))

rewards = [0.0, 0.0, 1.0]
print("returns with gamma 0.9:", np.round(returns_from(rewards, 0.9), 3))
print("returns with gamma 0.5:", np.round(returns_from(rewards, 0.5), 3))
```

Computing returns backwards, as above, is standard. Each return is a reward plus the discounted return that follows.

How long do episodes last under a random policy? Run twenty episodes and average their lengths.

```python run
rng_len = np.random.default_rng(1)
lengths = []
for _ in range(20):
    env = Corridor()
    s, done, steps = env.reset(), False, 0
    while not done and steps < 500:
        s, _, done = env.step(int(rng_len.integers(2)))
        steps += 1
    lengths.append(steps)
print("average random-policy episode length:", round(float(np.mean(lengths)), 1))
```

Random behaviour takes much longer than the four steps a deliberate agent needs, which is the gap that learning closes.

## Policies

A **deterministic** policy maps each state to one action. A **stochastic** policy gives a probability for each action, and a stochastic policy is what makes exploration possible.

```python run
rng = np.random.default_rng(0)
probs_right = np.array([0.9, 0.5, 0.1])       # probability of moving right, by state
for s, p in enumerate(probs_right):
    sample = rng.random(2000) < p
    print(f"state {s}: moves right {sample.mean():.2f} of the time")
```

## Predict the return

```python predict id=predict-gamma title="What is the return at time 0 with gamma 0.5?"
print(round(sum(0.5 ** k * r for k, r in enumerate([2.0, 0.0, 4.0])), 2))
--- options
* 3.0
6.0
2.0
4.0
--- explain
The rewards are 2 at time 0, 0 at time 1 and 4 at time 2. The last one is discounted by 0.5 squared, so 4 × 0.25 = 1. The total is 2 + 0 + 1 = 3.
```

## Challenge: returns for every step

```python exercise id=returns-each-step title="The return at every time step"
# TODO: `returns_each_step(rewards, gamma)` returns a list G where G[t] is the discounted return starting at step t,
# that is, Σₖ γᵏ rₜ₊ₖ. Compute it backwards, so each return uses the one after it.
def returns_each_step(rewards, gamma):
    ...
--- solution
def returns_each_step(rewards, gamma):
    G, out = 0.0, []
    for r in reversed(rewards):
        G = r + gamma * G
        out.append(G)
    return list(reversed(out))
--- test
result = returns_each_step([0.0, 0.0, 1.0], 0.5)
assert result is not None, "Replace the `...` in `returns_each_step` with code that returns the list."
assert len(result) == 3, "There should be one return per reward."
assert abs(result[0] - 0.25) < 1e-9 and abs(result[2] - 1.0) < 1e-9, f"With gamma 0.5 the returns are [0.25, 0.5, 1.0], but you returned {result}."
assert returns_each_step([], 0.9) == [], "An empty trajectory has no returns."
--- hint
Walk through the rewards from the last one to the first, keeping a running return `G = r + gamma * G`.
--- hint
Collect the values as you go, then reverse the list so index 0 corresponds to the first step.
```

## Challenge: total reward of a trajectory

```python exercise id=total-reward title="Total the rewards of a trajectory"
# TODO: `total_reward(trajectory)` takes a list of (state, action, reward) tuples and returns the sum of their rewards.
def total_reward(trajectory):
    ...
--- solution
def total_reward(trajectory):
    return sum(reward for _, _, reward in trajectory)
--- test
result = total_reward([(0, 1, 0.0), (1, 1, 0.0), (2, 0, 1.0)])
assert result is not None, "Replace the `...` in `total_reward` with code that returns the sum."
assert result == 1.0, f"The rewards are 0, 0 and 1, which sum to 1, but you returned {result!r}."
assert total_reward([]) == 0, "An empty trajectory has total reward 0."
--- hint
Each element of the list is a tuple, so unpack the reward from each one and add them up.
--- hint
`sum(reward for _, _, reward in trajectory)`.
```

## Debug the reversed list

This code computes the returns but returns them in the wrong order, so the first step gets the last return.

```python debug id=return-order title="Return the returns in time order"
rewards = [0.0, 0.0, 1.0]
gamma = 0.5
G, out = 0.0, []
for r in reversed(rewards):
    G = r + gamma * G
    out.append(G)
print("returns in time order:", out)               # bug: the list is still in reverse order
--- solution
rewards = [0.0, 0.0, 1.0]
gamma = 0.5
G, out = 0.0, []
for r in reversed(rewards):
    G = r + gamma * G
    out.append(G)
out = list(reversed(out))
print("returns in time order:", out)
--- test
assert np.allclose(out, [0.25, 0.5, 1.0]), f"out[0] should be the return from the first step, 0.25, but the list is {out}. Reverse it before printing."
--- hint
The loop runs from the last step to the first, so `out` is built backwards.
--- hint
Reverse the list after the loop with `list(reversed(out))`.
```

## Recap

- An agent, an environment, a policy and a return are the four parts of every reinforcement-learning problem.
- A trajectory is a sequence of states, actions and rewards, and every learning algorithm reads these.
- The return is the discounted sum of future rewards, and it is computed backwards.
- A stochastic policy gives probabilities over actions, which makes exploration possible.

**Up next:** the simplest decision problem with learning, the multi-armed bandit.
