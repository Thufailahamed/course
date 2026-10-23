Q-learning learns the best policy, but the agent that learns it may behave differently: during training it still takes random exploratory actions, and those can walk it off the cliff. **SARSA** is the on-policy cousin of Q-learning. It learns the value of the policy the agent actually follows, exploration included, and that difference changes the route it learns. This lesson compares the two and explains how exploration is scheduled.

## On-policy versus off-policy

Q-learning's target uses the best next action, which may not be the one taken. SARSA's target uses the action the agent actually takes next:

$$
\text{Q-learning:}\quad r + \gamma \max_{a'} Q(s', a') \qquad\qquad \text{SARSA:}\quad r + \gamma\, Q(s', a')
$$

The letters in SARSA name the quintuple it uses: state, action, reward, next state, next action.

```python run
import numpy as np

ROWS, COLS = 3, 6
START, GOAL = (2, 0), (2, 5)
CLIFF = {(2, c) for c in range(1, 5)}
MOVES = [(-1, 0), (1, 0), (0, -1), (0, 1)]

def idx(r, c):
    return r * COLS + c

def env_step(s, a):
    r, c = s
    dr, dc = MOVES[a]
    nr, nc = min(max(r + dr, 0), ROWS - 1), min(max(c + dc, 0), COLS - 1)
    if (nr, nc) in CLIFF:
        return START, -100.0, False
    if (nr, nc) == GOAL:
        return (nr, nc), -1.0, True
    return (nr, nc), -1.0, False

def train(method, episodes=500, alpha=0.5, gamma=1.0, eps=0.1, seed=0):
    rng = np.random.default_rng(seed)
    Q = np.zeros((ROWS * COLS, 4))
    def choose(s):
        return rng.integers(4) if rng.random() < eps else int(np.argmax(Q[idx(*s)]))
    returns = []
    for _ in range(episodes):
        s, total, done = START, 0.0, False
        a = choose(s)
        for _ in range(500):
            s2, r, done = env_step(s, a)
            a2 = choose(s2)
            if method == "sarsa":
                target = r if done else r + gamma * Q[idx(*s2), a2]
            else:
                target = r if done else r + gamma * np.max(Q[idx(*s2)])
            Q[idx(*s), a] += alpha * (target - Q[idx(*s), a])
            total += r
            s, a = s2, a2
            if done:
                break
        returns.append(total)
    return returns

for method in ["q-learning", "sarsa"]:
    returns = train(method)
    print(f"{method:>10}: average return over the last 50 episodes {np.mean(returns[-50:]):.1f}")
```

Q-learning often shows a better average during the final episodes, because it learns the cliff-edge route it would take if it did not explore. SARSA's exploration is part of what it learned, so it keeps a safer distance from the cliff while exploration is on.

Averaging over three random seeds gives a fairer comparison than a single run.

```python run
for method in ["q-learning", "sarsa"]:
    avg = np.mean([np.mean(train(method, seed=s)[-50:]) for s in range(3)])
    print(f"{method:>10}: average return over the last 50 episodes, three seeds {avg:.1f}")
```

## Exploration needs a schedule

Exploration is essential early and costly late. A common solution is an epsilon schedule that starts high and decays towards a small floor.

```python run
def epsilon_at(episode, eps_start=1.0, eps_end=0.05, decay_episodes=200):
    frac = min(episode / decay_episodes, 1.0)
    return eps_start + frac * (eps_end - eps_start)

for ep in [0, 50, 100, 200, 400]:
    print(f"episode {ep:>3}: epsilon {epsilon_at(ep):.3f}")
```

A schedule that decays too fast can lock the agent into an early habit. Decaying too slowly wastes episodes on random actions. The right schedule depends on how hard the environment is to explore.

## Stochastic environments

Exploration matters most when the world is uncertain. The bandit lesson already showed that a fixed epsilon can waste reward forever, which is why many systems decay it.

> **Pitfall:** when an episode ends, the target must not bootstrap from the next state. A terminal state has no future, so its target is just the reward. Forgetting this makes the agent believe it can keep earning rewards after the episode is over.

> **In the wild:** SARSA is preferred when mistakes during learning are costly, such as a robot that should not learn by falling down stairs, because it learns a policy that accounts for its own exploration.

Plotting the smoothed returns shows how each method improves over time.

```python run
import matplotlib.pyplot as plt

fig, ax = plt.subplots(figsize=(5, 3))
for method in ["q-learning", "sarsa"]:
    returns = train(method)
    ax.plot(np.convolve(returns, np.ones(20) / 20, mode="valid"), label=method)
ax.set_xlabel("episode"); ax.set_ylabel("return (20-episode average)")
ax.legend(); ax.grid(alpha=0.3)
plt.show()
```

## Challenge: the SARSA target

```python exercise id=sarsa-target title="The SARSA target"
import numpy as np

# TODO: `sarsa_target(r, q_next_taken, done, gamma)` returns r when done is True, and r + gamma × q_next_taken otherwise,
# where q_next_taken is the value of the action the agent actually takes in the next state.
def sarsa_target(r, q_next_taken, done, gamma):
    ...
--- solution
def sarsa_target(r, q_next_taken, done, gamma):
    if done:
        return float(r)
    return float(r + gamma * q_next_taken)
--- test
result = sarsa_target(1.0, 3.0, False, 0.5)
assert result is not None, "Replace the `...` in `sarsa_target` with code that returns the target."
assert abs(result - 2.5) < 1e-9, f"The target is 1 + 0.5 × 3 = 2.5, but you returned {result!r}."
assert abs(sarsa_target(1.0, 3.0, True, 0.5) - 1.0) < 1e-9, "At the end of an episode the target is just the reward."
--- hint
SARSA uses the value of the next action it will take, not the maximum over actions.
--- hint
`return float(r) if done else float(r + gamma * q_next_taken)`.
```

## Challenge: an epsilon schedule

```python exercise id=epsilon-schedule title="A linear epsilon schedule"
# TODO: `linear_epsilon(episode, eps_start, eps_end, decay_episodes)` returns epsilon for an episode, falling linearly
# from eps_start at episode 0 to eps_end at episode `decay_episodes`, and staying at eps_end afterwards.
def linear_epsilon(episode, eps_start, eps_end, decay_episodes):
    ...
--- solution
def linear_epsilon(episode, eps_start, eps_end, decay_episodes):
    frac = min(episode / decay_episodes, 1.0)
    return eps_start + frac * (eps_end - eps_start)
--- test
assert abs(linear_epsilon(0, 1.0, 0.1, 10) - 1.0) < 1e-9, "At episode 0 epsilon is its starting value."
assert abs(linear_epsilon(5, 1.0, 0.1, 10) - 0.55) < 1e-9, "Halfway through the decay, epsilon is halfway between 1.0 and 0.1, which is 0.55."
assert abs(linear_epsilon(10, 1.0, 0.1, 10) - 0.1) < 1e-9, "At the decay length epsilon reaches its floor."
assert abs(linear_epsilon(99, 1.0, 0.1, 10) - 0.1) < 1e-9, "After the decay it stays at the floor."
--- hint
Find the fraction of the way through the decay, cap it at 1, and move from the start value towards the end value by that fraction.
--- hint
`frac = min(episode / decay_episodes, 1.0)`, then `eps_start + frac * (eps_end - eps_start)`.
```

## Debug the terminal bootstrap

This SARSA target is meant to stop at the end of the episode, but it keeps adding the value of a next state even when the episode has finished.

```python debug id=terminal-bootstrap title="Do not bootstrap from a terminal state"
import numpy as np

Q = np.array([[0.0, 0.0], [5.0, 5.0]])
s2, a2, r, gamma, done = 1, 0, 1.0, 0.9, True
target = r + gamma * Q[s2, a2]            # bug: a finished episode has no future value
print("target:", target)
--- solution
import numpy as np

Q = np.array([[0.0, 0.0], [5.0, 5.0]])
s2, a2, r, gamma, done = 1, 0, 1.0, 0.9, True
target = r if done else r + gamma * Q[s2, a2]
print("target:", target)
--- test
assert abs(target - 1.0) < 1e-9, f"The episode is done, so the target should be the reward 1.0, but it is {target}. Use only the reward when the episode ends."
--- hint
When `done` is True there is no next state to learn from.
--- hint
Write `target = r if done else r + gamma * Q[s2, a2]`.
```

## Predict the schedule

```python predict id=predict-eps title="What is epsilon halfway through a 100-episode linear decay from 1 to 0?"
frac = 50 / 100
print(1.0 + frac * (0.0 - 1.0))
--- options
* 0.5
0.0
1.0
0.25
--- explain
Halfway through the decay, the fraction is one half, so epsilon is 1 minus one half, which is 0.5.
```

## Recap

- SARSA uses the value of the action actually taken next, so it learns the policy that includes its own exploration.
- Q-learning uses the maximum, so it learns the optimal policy regardless of exploration.
- An epsilon schedule starts with exploration and decays it, and its decay rate is a design choice.
- Terminal transitions use only the reward.

**Up next:** deep Q-networks, which replace the table with a function approximator that generalizes.
