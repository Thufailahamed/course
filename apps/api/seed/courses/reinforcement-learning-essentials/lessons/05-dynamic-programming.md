When the MDP is fully known, you do not have to learn anything from experience. Dynamic programming solves the Bellman equations directly: **policy evaluation** computes the value of a policy by repeated backups, and **value iteration** computes the best value by repeating the optimal backup. The methods are exact, so they are the reference against which every learning algorithm is later checked.

The world below is the classic 4 × 4 gridworld. Two corners are terminal. Every step costs −1, and the agent moves up, down, left or right, staying put when it would leave the grid.

```python run
import numpy as np

N = 4
TERMINAL = {(0, 0), (3, 3)}
ACTIONS = [(-1, 0), (1, 0), (0, -1), (0, 1)]          # up, down, left, right

def move(s, a):
    r, c = s
    dr, dc = ACTIONS[a]
    return (min(max(r + dr, 0), N - 1), min(max(c + dc, 0), N - 1))

print("from (1, 1) moving right you go to", move((1, 1), 3))
print("from (0, 2) moving up you stay at", move((0, 2), 0))
```

## Policy evaluation

Start every state at zero. Repeatedly update each state's value to the expected backup under the policy. The uniform random policy chooses each of the four moves with probability one quarter.

$$
V_{k+1}(s) = \frac{1}{4} \sum_{a} \bigl[ -1 + V_k(s') \bigr], \qquad s' = \text{move}(s, a)
$$

```python run
def evaluate_uniform(sweeps=300):
    V = np.zeros((N, N))
    for _ in range(sweeps):
        new = V.copy()
        for r in range(N):
            for c in range(N):
                if (r, c) in TERMINAL:
                    continue
                new[r, c] = np.mean([-1.0 + V[move((r, c), a)] for a in range(4)])
        V = new
    return V

V_random = evaluate_uniform()
print(np.round(V_random, 1))
```

The values count the expected number of steps to reach a corner, with a minus sign. Cells far from both corners are the most negative.

## Value iteration

Policy evaluation answers "how good is this policy?". Value iteration answers "what is the best value?" by taking the best action in each backup instead of averaging over them.

```python run
def value_iteration(sweeps=100):
    V = np.zeros((N, N))
    for _ in range(sweeps):
        new = V.copy()
        for r in range(N):
            for c in range(N):
                if (r, c) in TERMINAL:
                    continue
                new[r, c] = max(-1.0 + V[move((r, c), a)] for a in range(4))
        V = new
    return V

V_star = value_iteration()
print(np.round(V_star, 1))
```

The optimal values are never lower than the random-policy values, and the optimal policy is simply the action that achieves the maximum in each state.

## Extract the greedy policy

```python run
def greedy_policy(V):
    names = ["up", "down", "left", "right"]
    policy = {}
    for r in range(N):
        for c in range(N):
            if (r, c) in TERMINAL:
                continue
            best = max(range(4), key=lambda a: V[move((r, c), a)])
            policy[(r, c)] = names[best]
    return policy

pol = greedy_policy(V_star)
print("best move from (0, 1):", pol[(0, 1)], "| from (3, 2):", pol[(3, 2)])
```

> **Pitfall:** dynamic programming needs the transition model. In most real problems you do not have it, which is why the next lessons learn values from experience instead.

> **In the wild:** planning systems in robotics and logistics use value iteration on known maps. Model-free learning is the choice when the map is unknown.

## Challenge: iterative policy evaluation

```python exercise id=evaluate-uniform title="Evaluate the random policy"
import numpy as np

N = 4
TERMINAL = {(0, 0), (3, 3)}
ACTIONS = [(-1, 0), (1, 0), (0, -1), (0, 1)]

def move(s, a):
    r, c = s
    dr, dc = ACTIONS[a]
    return (min(max(r + dr, 0), N - 1), min(max(c + dc, 0), N - 1))

# TODO: `evaluate_uniform(sweeps)` returns a 4 × 4 array of state values for the uniform random policy. Start from
# zeros and, for each sweep, set each non-terminal state to the average over its four moves of (−1 + value of the
# next state). Terminal states keep value 0.
def evaluate_uniform(sweeps):
    ...
--- solution
import numpy as np

N = 4
TERMINAL = {(0, 0), (3, 3)}
ACTIONS = [(-1, 0), (1, 0), (0, -1), (0, 1)]

def move(s, a):
    r, c = s
    dr, dc = ACTIONS[a]
    return (min(max(r + dr, 0), N - 1), min(max(c + dc, 0), N - 1))

def evaluate_uniform(sweeps):
    V = np.zeros((N, N))
    for _ in range(sweeps):
        new = V.copy()
        for r in range(N):
            for c in range(N):
                if (r, c) in TERMINAL:
                    continue
                new[r, c] = np.mean([-1.0 + V[move((r, c), a)] for a in range(4)])
        V = new
    return V
--- test
import numpy as np
V = evaluate_uniform(500)
assert V is not None, "Replace the `...` in `evaluate_uniform` with code that returns the values."
assert V.shape == (4, 4), f"The grid is 4 × 4, but you returned shape {V.shape}."
assert V[0, 0] == 0 and V[3, 3] == 0, "The terminal corners keep value 0."
expected = np.array([[0, -14, -20, -22], [-14, -18, -20, -20], [-20, -20, -18, -14], [-22, -20, -14, 0]])
assert np.allclose(V, expected, atol=0.05), f"The known values for this grid are\n{expected}\nbut you returned\n{np.round(V, 1)}."
--- hint
Average over the four actions with `np.mean`, and use `move((r, c), a)` for each next state. Skip the terminal cells.
--- hint
`new[r, c] = np.mean([-1.0 + V[move((r, c), a)] for a in range(4)])`.
```

## Challenge: one value-iteration sweep

```python exercise id=value-iteration-step title="One value-iteration sweep"
import numpy as np

N = 4
TERMINAL = {(0, 0), (3, 3)}
ACTIONS = [(-1, 0), (1, 0), (0, -1), (0, 1)]

def move(s, a):
    r, c = s
    dr, dc = ACTIONS[a]
    return (min(max(r + dr, 0), N - 1), min(max(c + dc, 0), N - 1))

# TODO: `value_iteration_step(V)` returns a new 4 × 4 array after one sweep. Each non-terminal state takes the
# maximum over its four actions of (−1 + value of the next state). Terminal states keep their value.
def value_iteration_step(V):
    ...
--- solution
import numpy as np

N = 4
TERMINAL = {(0, 0), (3, 3)}
ACTIONS = [(-1, 0), (1, 0), (0, -1), (0, 1)]

def move(s, a):
    r, c = s
    dr, dc = ACTIONS[a]
    return (min(max(r + dr, 0), N - 1), min(max(c + dc, 0), N - 1))

def value_iteration_step(V):
    new = V.copy()
    for r in range(N):
        for c in range(N):
            if (r, c) in TERMINAL:
                continue
            new[r, c] = max(-1.0 + V[move((r, c), a)] for a in range(4))
    return new
--- test
import numpy as np
V0 = np.zeros((4, 4))
V1 = value_iteration_step(V0)
assert V1 is not None, "Replace the `...` in `value_iteration_step` with code that returns the new values."
assert np.isclose(V1[0, 1], -1.0) and np.isclose(V1[1, 1], -1.0), "From any non-terminal cell, one step costs −1 when all values start at 0."
assert V1[0, 0] == 0 and V1[3, 3] == 0, "Terminal corners keep value 0."
V2 = value_iteration_step(V1)
assert np.isclose(V2[0, 2], -2.0), f"After two sweeps the cell (0, 2) is two steps from the corner, so its value is −2, but you returned {V2[0, 2]}. Take the best action (the maximum), not the average."
--- hint
Use `max` over the four actions, not `np.mean`, because the agent chooses the best action.
--- hint
`new[r, c] = max(-1.0 + V[move((r, c), a)] for a in range(4))` and keep the terminal cells as they are.
```

## Debug the step reward

This value-iteration step is meant to charge a cost of one per step, but it adds a reward instead, so the agent is rewarded for wandering.

```python debug id=step-reward title="Charge a cost per step"
import numpy as np

N = 4
TERMINAL = {(0, 0), (3, 3)}
ACTIONS = [(-1, 0), (1, 0), (0, -1), (0, 1)]

def move(s, a):
    r, c = s
    dr, dc = ACTIONS[a]
    return (min(max(r + dr, 0), N - 1), min(max(c + dc, 0), N - 1))

V = np.zeros((N, N))
new = V.copy()
new[0, 1] = max(1.0 + V[move((0, 1), a)] for a in range(4))       # bug: the step reward is −1, not +1
print("value of (0, 1):", new[0, 1])
--- solution
import numpy as np

N = 4
TERMINAL = {(0, 0), (3, 3)}
ACTIONS = [(-1, 0), (1, 0), (0, -1), (0, 1)]

def move(s, a):
    r, c = s
    dr, dc = ACTIONS[a]
    return (min(max(r + dr, 0), N - 1), min(max(c + dc, 0), N - 1))

V = np.zeros((N, N))
new = V.copy()
new[0, 1] = max(-1.0 + V[move((0, 1), a)] for a in range(4))
print("value of (0, 1):", new[0, 1])
--- test
assert np.isclose(new[0, 1], -1.0), f"Every step costs −1, so the value of (0, 1) after one sweep is −1, but it is {new[0, 1]}. The reward per step is negative."
--- hint
Reward here is a cost. Check the sign of the constant inside the `max`.
--- hint
Use `-1.0 + V[...]`.
```

## Predict the optimal value

```python predict id=predict-dp title="What is the optimal value of a cell next to a corner?"
import numpy as np
V = np.zeros((4, 4))
V[0, 0] = 0.0
print(max(-1.0 + V[0, 0], -1.0 + V[1, 1]))
--- options
* -1.0
0.0
1.0
-2.0
--- explain
Moving into the terminal corner costs one step and then gives value zero, so the best option is −1. The best value of a cell next to a terminal corner is therefore −1.
```

## Recap

- Policy evaluation computes the value of a fixed policy by repeated Bellman backups.
- Value iteration replaces the average with a maximum, and converges to the optimal values.
- The greedy policy with respect to the optimal values is optimal.
- Dynamic programming needs the full model, which is why learning from experience matters.

**Up next:** temporal-difference learning, which learns values from experience without a model.
