Dynamic programming needs the transition model. Real agents usually do not have one, so they must learn from experience: act, observe what happened, and adjust their estimates. **Monte Carlo** methods wait for the full return of an episode before updating. **Temporal-difference** (TD) methods update after every step, using the next state's current estimate. TD is the workhorse of reinforcement learning, and its single update rule is worth understanding completely.

## The random walk

Five states in a row, A to E, start in the middle. Each step moves left or right with equal probability. Reaching E pays 1, reaching A pays 0, and both end the episode. The true values are the probabilities of finishing on the right, which are 1/6, 2/6, 3/6, 4/6 and 5/6 for the five states.

```python run
import numpy as np

rng = np.random.default_rng(0)

def walk_episode(rng):
    s = 2                                   # start in the middle, state C
    path = [s]
    while 0 < s < 4:
        s += 1 if rng.random() < 0.5 else -1
        path.append(s)
    reward = 1.0 if s == 4 else 0.0
    return path, reward

path, reward = walk_episode(rng)
print("one episode visits", path, "and pays", reward)
```

## Monte Carlo: wait for the whole return

Monte Carlo averages the complete returns observed after each state. It is unbiased, but every update must wait until the episode ends.

```python run
def mc_values(episodes, rng):
    total, count = np.zeros(5), np.zeros(5)
    for _ in range(episodes):
        path, reward = walk_episode(rng)
        for s in set(path[:-1]):              # first-visit style: each state counts once per episode
            total[s] += reward
            count[s] += 1
    return total / np.maximum(count, 1)

print("Monte Carlo estimates:", np.round(mc_values(5000, rng)[1:4], 3))
print("true values for B, C, D:", np.round([2 / 6, 3 / 6, 4 / 6], 3))
```

## TD(0): learn after every step

TD(0) updates the value of the state just left, moving it towards the observed reward plus the discounted value of the state entered:

$$
V(S_t) \leftarrow V(S_t) + \alpha \bigl[\, R_{t+1} + \gamma V(S_{t+1}) - V(S_t) \,\bigr]
$$

The bracketed term is the TD error: how much better or worse the outcome was than the current estimate predicted.

```python run
def td_values(episodes, alpha, rng, gamma=1.0):
    V = np.zeros(5)
    for _ in range(episodes):
        s = 2
        while 0 < s < 4:
            s2 = s + (1 if rng.random() < 0.5 else -1)
            r = 1.0 if s2 == 4 else 0.0
            target = r + gamma * V[s2] if 0 < s2 < 4 else r
            V[s] += alpha * (target - V[s])
            s = s2
    return V

print("TD(0) estimates:", np.round(td_values(2000, 0.05, np.random.default_rng(1))[1:4], 3))
```

TD learns after each step, so it can adapt in environments that never end. Both methods converge to the same values, but TD usually does so with less variance.

> **In the wild:** TD learning is how value functions are learned in game-playing and control systems, and it is the basis of the Q-learning in the next lesson.

Across all five states, TD(0) recovers the whole line of probabilities, from the nearly-zero value at A to the largest at E. Compare it with the true values in the table above.

```python run
print("TD(0) on all five states:", np.round(td_values(2000, 0.05, np.random.default_rng(2)), 2))
```

## Challenge: the TD update

```python exercise id=td-update title="One TD(0) update"
# TODO: `td0_update(V, s, r, s_next, alpha, gamma, done)` returns a new list of values, with only entry s changed.
# The target is r when done is True, and r + gamma × V[s_next] otherwise. Move V[s] towards the target by alpha.
def td0_update(V, s, r, s_next, alpha, gamma, done):
    ...
--- solution
def td0_update(V, s, r, s_next, alpha, gamma, done):
    new = list(V)
    target = r if done else r + gamma * V[s_next]
    new[s] = V[s] + alpha * (target - V[s])
    return new
--- test
result = td0_update([0.0, 0.5, 1.0], 1, 0.0, 2, 0.1, 0.9, False)
assert result is not None, "Replace the `...` in `td0_update` with code that returns the new values."
assert abs(result[1] - (0.5 + 0.1 * (0.9 * 1.0 - 0.5))) < 1e-9, f"The target is 0 + 0.9 × 1.0 = 0.9, so V[1] should move to 0.5 + 0.1 × 0.4 = 0.54, but you returned {result[1]!r}."
assert result[0] == 0.0 and result[2] == 1.0, "Only the entry for state s should change."
done_case = td0_update([0.0, 0.5], 1, 1.0, 0, 0.5, 0.9, True)
assert abs(done_case[1] - 0.75) < 1e-9, "At the end of an episode the target is just the reward, 1, so V[1] moves from 0.5 to 0.75."
--- hint
Compute the target first. It is `r` when the episode is done, and `r + gamma * V[s_next]` otherwise.
--- hint
`new = list(V)`, then `new[s] = V[s] + alpha * (target - V[s])`.
```

## Challenge: Monte Carlo average

```python exercise id=mc-average title="Average the returns of a state"
# TODO: `mc_average(returns)` returns the average of a list of sampled returns. An empty list gives 0.0.
def mc_average(returns):
    ...
--- solution
def mc_average(returns):
    if not returns:
        return 0.0
    return sum(returns) / len(returns)
--- test
assert mc_average([1.0, 0.0, 0.0, 1.0]) == 0.5, "The average of 1, 0, 0 and 1 is 0.5."
assert mc_average([]) == 0.0, "With no returns the estimate is 0."
assert abs(mc_average([2.0]) - 2.0) < 1e-9, "One return is its own average."
--- hint
Add the values and divide by how many there are, guarding the empty list.
--- hint
`sum(returns) / len(returns)`, with `if not returns: return 0.0` first.
```

## Debug the bootstrap target

This TD update is meant to bootstrap from the next state, but it uses the current state's value, so the estimate chases itself.

```python debug id=bootstrap-state title="Bootstrap from the next state"
import numpy as np

V = np.array([0.0, 0.5, 1.0])
s, s_next, r, gamma, alpha = 1, 2, 0.0, 0.9, 0.1
target = r + gamma * V[s]               # bug: this uses the value of the state being updated
V[s] += alpha * (target - V[s])
print("updated V:", V)
--- solution
import numpy as np

V = np.array([0.0, 0.5, 1.0])
s, s_next, r, gamma, alpha = 1, 2, 0.0, 0.9, 0.1
target = r + gamma * V[s_next]
V[s] += alpha * (target - V[s])
print("updated V:", V)
--- test
assert abs(V[1] - 0.54) < 1e-9, f"The target should use V[s_next] = 1.0, giving V[1] = 0.54, but it is {V[1]:.4f}. Bootstrap from the next state."
--- hint
In TD(0) the value of the state entered, `s_next`, is what the update learns from.
--- hint
Replace `V[s]` with `V[s_next]` inside the target.
```

## Predict the TD error

```python predict id=predict-td title="What is the TD error?"
r, gamma = 1.0, 0.5
V_s, V_next = 2.0, 4.0
print(r + gamma * V_next - V_s)
--- options
* 1.0
0.0
-1.0
3.0
--- explain
The TD error is the target minus the estimate: 1 + 0.5 × 4 − 2 = 1 + 2 − 2 = 1. Positive means the outcome was better than predicted.
```

## Recap

- Monte Carlo averages complete returns and must wait for the end of each episode.
- TD(0) updates each state after one step, moving its estimate towards the reward plus the discounted next estimate.
- The TD error measures how much an outcome beat or missed the prediction, and it drives learning.
- TD needs no model, which makes it the basis of model-free control.

**Up next:** Q-learning, which applies the same idea to the value of actions, and learns the best policy directly.
