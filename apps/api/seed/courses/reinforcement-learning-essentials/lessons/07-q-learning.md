Q-learning is the most famous model-free algorithm in reinforcement learning. Instead of learning the value of states, it learns the value of **state-action pairs**, written $Q(s, a)$: the expected return from taking action $a$ in state $s$ and acting well afterwards. Once you know $Q$, the best action is simply the one with the largest value, and you never need a model of the world.

## A cliff to learn from

The world below is a small grid. The agent starts in the bottom-left corner and must reach the bottom-right corner. The bottom row between them is a cliff: stepping onto it costs 100 and sends the agent back to the start. Every other step costs 1.

```python run
import numpy as np

ROWS, COLS = 3, 6
START, GOAL = (2, 0), (2, 5)
CLIFF = {(2, c) for c in range(1, 5)}
MOVES = [(-1, 0), (1, 0), (0, -1), (0, 1)]           # up, down, left, right

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

reward_total = 0.0
s, done = START, False
for a in [3, 3, 3, 3, 3]:                             # walk right along the top route
    s, r, done = env_step(s, a)
    reward_total += r
print("five steps right from the start: position", s, "| total reward", reward_total)
```

The start is on the cliff row, so stepping right walks onto the cliff, costs 100 and sends the agent back to the start. The total shows the penalty. That is the trap the agent must learn to avoid.

## The Q-learning update

After each step, Q-learning moves $Q(s, a)$ towards the reward plus the discounted value of the best action in the next state. Taking the maximum over next actions is what makes it learn the best policy, whatever the agent actually does.

$$
Q(s, a) \leftarrow Q(s, a) + \alpha \bigl[\, r + \gamma \max_{a'} Q(s', a') - Q(s, a) \,\bigr]
$$

```python run
def q_learning(episodes, alpha=0.5, gamma=1.0, eps=0.1, seed=0):
    rng = np.random.default_rng(seed)
    Q = np.zeros((ROWS * COLS, 4))
    returns = []
    for _ in range(episodes):
        s, total, done = START, 0.0, False
        for _ in range(500):
            a = rng.integers(4) if rng.random() < eps else int(np.argmax(Q[idx(*s)]))
            s2, r, done = env_step(s, a)
            target = r if done else r + gamma * np.max(Q[idx(*s2)])
            Q[idx(*s), a] += alpha * (target - Q[idx(*s), a])
            total += r
            s = s2
            if done:
                break
        returns.append(total)
    return Q, returns

Q, returns = q_learning(500)
print("average return over the last 50 episodes:", round(np.mean(returns[-50:]), 1))
```

## The learned policy

```python run
arrows = ["↑", "↓", "←", "→"]
for r in range(ROWS):
    row = []
    for c in range(COLS):
        if (r, c) in CLIFF:
            row.append(" C ")
        elif (r, c) == GOAL:
            row.append(" G ")
        else:
            row.append(f" {arrows[int(np.argmax(Q[idx(r, c)]))]} ")
    print("".join(row))
```

The arrows show the greedy policy. Along the row above the cliff the agent learns to step up first, which is the safe route.

> **Pitfall:** Q-learning's target uses the best next action even if the agent will not take it. That is what makes it off-policy, and it is why it learns the optimal route rather than the route that is safe to explore with. The next lesson contrasts it with SARSA.

> **In the wild:** tabular Q-learning appears in small control problems, and deep Q-networks, covered later in this course, use the same update with a neural network.

The learned action values at the start state show which move the agent prefers, and by how much.

```python run
print("Q-values at the start (up, down, left, right):", np.round(Q[idx(*START)], 1))
```

## Challenge: the Q target

```python exercise id=q-target title="The Q-learning target"
import numpy as np

# TODO: `q_target(r, next_q, done, gamma)` returns the target r when done is True, and r + gamma × max(next_q)
# otherwise, where next_q is the array of action values in the next state.
def q_target(r, next_q, done, gamma):
    ...
--- solution
import numpy as np

def q_target(r, next_q, done, gamma):
    if done:
        return float(r)
    return float(r + gamma * np.max(next_q))
--- test
import numpy as np
result = q_target(1.0, np.array([0.5, 2.0]), False, 0.5)
assert result is not None, "Replace the `...` in `q_target` with code that returns the target."
assert abs(result - 2.0) < 1e-9, f"The target is 1 + 0.5 × max(0.5, 2.0) = 2.0, but you returned {result!r}."
assert abs(q_target(1.0, np.array([0.5, 2.0]), True, 0.5) - 1.0) < 1e-9, "At the end of an episode there is no future value, so the target is just r."
assert abs(q_target(-1.0, np.array([-3.0, -1.0]), False, 1.0) + 2.0) < 1e-9, "The maximum over the actions is −1, so the target is −1 + (−1) = −2."
--- hint
Use `np.max` over the next state's action values, and skip it when the episode is done.
--- hint
`return float(r) if done else float(r + gamma * np.max(next_q))`.
```

## Challenge: one Q-learning update

```python exercise id=q-update title="Apply one Q-learning update"
import numpy as np

# TODO: `q_update(Q, s, a, r, s2, done, alpha, gamma)` returns a NEW copy of the 2-D array Q, in which entry [s, a] has
# moved towards the Q-learning target by alpha. The input Q must not be changed.
def q_update(Q, s, a, r, s2, done, alpha, gamma):
    ...
--- solution
import numpy as np

def q_update(Q, s, a, r, s2, done, alpha, gamma):
    new = np.array(Q, dtype=float, copy=True)
    target = r if done else r + gamma * np.max(new[s2])
    new[s, a] += alpha * (target - new[s, a])
    return new
--- test
import numpy as np
Q0 = np.zeros((3, 4))
Q1 = q_update(Q0, 0, 1, 1.0, 2, False, 0.5, 0.9)
assert Q1 is not None, "Replace the `...` in `q_update` with code that returns the new table."
assert abs(Q1[0, 1] - 0.5) < 1e-9, f"The target is 1 + 0.9 × max(row 2) = 1, so Q[0, 1] moves from 0 to 0.5, but you returned {Q1[0, 1]!r}."
assert np.all(Q0 == 0), "The input table must not change."
Q2 = np.zeros((3, 4))
Q2[2, 3] = 4.0
Q3 = q_update(Q2, 1, 0, -1.0, 2, False, 1.0, 0.5)
assert abs(Q3[1, 0] - (-1.0 + 0.5 * 4.0)) < 1e-9, "The target uses the best action in the next state, which is 4 here."
--- hint
Copy the array first, compute the target from `np.max(new[s2])` unless the episode is done, then add `alpha * (target − current)` to the entry.
--- hint
`new = np.array(Q, dtype=float, copy=True)` protects the input.
```

## Debug the next-state value

This update is meant to learn the best action in the next state, but it looks up the value of the action that was actually taken instead.

```python debug id=q-next-action title="Use the best next action, not the taken one"
import numpy as np

Q = np.zeros((3, 2))
Q[2] = [0.0, 3.0]                       # in the next state, action 1 is far better
s, a, r, s2, alpha, gamma = 0, 0, -1.0, 2, 0.5, 1.0
target = r + gamma * Q[s2, a]           # bug: uses the value of the action taken, not the best one
Q[s, a] += alpha * (target - Q[s, a])
print("Q[0, 0] after the update:", Q[0, 0])
--- solution
import numpy as np

Q = np.zeros((3, 2))
Q[2] = [0.0, 3.0]
s, a, r, s2, alpha, gamma = 0, 0, -1.0, 2, 0.5, 1.0
target = r + gamma * np.max(Q[s2])
Q[s, a] += alpha * (target - Q[s, a])
print("Q[0, 0] after the update:", Q[0, 0])
--- test
assert abs(Q[0, 0] - 1.0) < 1e-9, f"The target is −1 + max(0, 3) = 2, so Q[0, 0] should move to 1.0, but it is {Q[0, 0]}. Q-learning uses the best next action."
--- hint
Q-learning's target does not depend on which action the agent takes next. It takes the maximum.
--- hint
Replace `Q[s2, a]` with `np.max(Q[s2])`.
```

## Predict the target

```python predict id=predict-q title="What is the Q-learning target?"
import numpy as np
r, gamma = 2.0, 0.5
next_q = np.array([1.0, 4.0, 2.0])
print(r + gamma * np.max(next_q))
--- options
* 4.0
3.0
2.0
5.0
--- explain
The best next action has value 4, and the discount halves it to 2. Adding the reward 2 gives 4. The other actions do not matter, because Q-learning always looks at the maximum.
```

## Recap

- Q-learning learns the value of state-action pairs and updates them towards reward plus the discounted best next value.
- Because it uses the maximum, it learns the optimal policy even while the agent explores.
- Terminal transitions use only the reward, with no future value.
- The learned policy is the arrow in each state with the largest value.

**Up next:** exploration choices, and SARSA, the on-policy cousin that learns the value of the policy actually followed.
