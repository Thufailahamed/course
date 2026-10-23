A bandit has one state. Most real problems do not: the right action depends on where you are, and actions change where you go next. A **Markov decision process** (MDP) describes such problems with four ingredients: states, actions, the probabilities of moving between states, and the rewards. The Markov property says the next state depends only on the current state and action, not on how you got there.

## A small MDP

Here is a three-state world. From the start state you can take a safe route or a risky one. The risky route pays more on average, but it can drop you into a trap.

```python run
import numpy as np

states = ["start", "safe", "trap", "goal"]
# P[s][a] is a list of (probability, next_state, reward)
P = {
    "start": {"safe_route": [(1.0, "safe", 0.0)],
              "risky_route": [(0.5, "goal", 2.0), (0.5, "trap", -1.0)]},
    "safe": {"continue": [(1.0, "goal", 1.0)]},
    "trap": {"stay": [(1.0, "trap", -1.0)]},
    "goal": {"stay": [(1.0, "goal", 0.0)]},
}

for action, outcomes in P["start"].items():
    expected = sum(p * r for p, _, r in outcomes)
    print(f"{action:>12}: expected immediate reward {expected:+.2f}")
```

The risky route looks better on immediate reward, but its outcomes are random. A decision needs the value of each state, which depends on the whole future.

## Values of states

The value of a state under a policy is the expected return from that state. It satisfies the **Bellman equation**, which says that a state's value is the expected immediate reward plus the discounted value of the states that follow.

$$
V^{\pi}(s) = \sum_{a} \pi(a \mid s) \sum_{s', r} p(s', r \mid s, a)\bigl[\, r + \gamma V^{\pi}(s') \,\bigr]
$$

```python run
gamma = 0.9
V_goal = 0.0                                  # the goal state keeps paying zero
V_safe = 1.0 + gamma * V_goal                 # one step of reward 1, then the goal
V_start_safe = 0.0 + gamma * V_safe           # the safe route from the start
V_start_risky = 0.5 * (2.0 + gamma * V_goal) + 0.5 * (-1.0 + gamma * (-1.0 / (1 - gamma)))
print("value of 'safe' under gamma 0.9:", round(V_safe, 2))
print("value of 'start' via the safe route:", round(V_start_safe, 2))
print("value of 'start' via the risky route:", round(V_start_risky, 2))
```

The Bellman equation turns the question "which route is better?" into arithmetic. Here the safe route is worth more, because the trap's penalty is repeated forever.

## Policies and their values

A policy chooses actions. Evaluating a policy means computing its value function, and improving it means choosing actions that do better. Both use the same equation.

```python run
def evaluate_policy(P, policy, gamma, sweeps=200):
    V = {s: 0.0 for s in P}
    for _ in range(sweeps):
        for s in P:
            a = policy[s]
            V[s] = sum(p * (r + gamma * V[s2]) for p, s2, r in P[s][a])
    return V

policy_safe = {"start": "safe_route", "safe": "continue", "trap": "stay", "goal": "stay"}
policy_risky = {"start": "risky_route", "safe": "continue", "trap": "stay", "goal": "stay"}
for name, pol in [("safe policy", policy_safe), ("risky policy", policy_risky)]:
    V = evaluate_policy(P, pol, gamma)
    print(f"{name}: value of start = {V['start']:.2f}")
```

## Predict the value

```python predict id=predict-mdp title="What is the value of a goal state that pays 0 forever?"
gamma = 0.9
print(0.0 + gamma * 0.0)
--- options
* 0.0
1.0
0.9
-1.0
--- explain
The goal state pays zero every step and stays there, so its value is zero plus the discounted value of itself, which is zero. Only the reward matters, and the reward is zero.
```

The safe policy's values for every state, computed by the evaluation function above.

```python run
V_safe_policy = evaluate_policy(P, policy_safe, gamma)
print({s: round(v, 2) for s, v in V_safe_policy.items()})
```

Terminal and absorbing states keep their own values, and the start state inherits its value from the route it follows.

## Challenge: a one-step Bellman backup

```python exercise id=bellman-backup title="A one-step Bellman backup"
# TODO: `backup(outcomes, V, gamma)` returns the expected value of one action, given its outcomes as a list of
# (probability, next_state, reward) tuples and the state values V (a dictionary). Use r + gamma * V[next_state].
def backup(outcomes, V, gamma):
    ...
--- solution
def backup(outcomes, V, gamma):
    return sum(p * (r + gamma * V[s2]) for p, s2, r in outcomes)
--- test
V_t = {"a": 2.0, "b": -1.0}
result = backup([(0.5, "a", 1.0), (0.5, "b", 0.0)], V_t, 0.5)
assert result is not None, "Replace the `...` in `backup` with code that returns the expected value."
expected = 0.5 * (1.0 + 0.5 * 2.0) + 0.5 * (0.0 + 0.5 * -1.0)
assert abs(result - expected) < 1e-9, f"0.5 · (1 + 0.5·2) + 0.5 · (0 + 0.5·(−1)) = 0.75, but you returned {result!r}."
assert abs(backup([(1.0, "a", 0.0)], V_t, 0.9) - 1.8) < 1e-9, "A single certain outcome gives the reward plus the discounted next value."
--- hint
Multiply each outcome's probability by its reward plus the discounted value of the next state, then add them up.
--- hint
`sum(p * (r + gamma * V[s2]) for p, s2, r in outcomes)`.
```

## Challenge: evaluate a policy

```python exercise id=evaluate-policy title="Evaluate a deterministic policy"
# TODO: `evaluate_policy(P, policy, gamma)` returns a dictionary of state values for the policy, computed by repeatedly
# applying the Bellman backup for the action the policy chooses in each state, for 500 sweeps starting from zeros.
# P has the same format as the lesson: P[s][a] is a list of (probability, next_state, reward).
def evaluate_policy(P, policy, gamma):
    ...
--- solution
def evaluate_policy(P, policy, gamma):
    V = {s: 0.0 for s in P}
    for _ in range(500):
        for s in P:
            V[s] = sum(p * (r + gamma * V[s2]) for p, s2, r in P[s][policy[s]])
    return V
--- test
P_t = {"x": {"go": [(1.0, "y", 1.0)]}, "y": {"stay": [(1.0, "y", 0.0)]}}
V = evaluate_policy(P_t, {"x": "go", "y": "stay"}, 0.5)
assert V is not None, "Replace the `...` in `evaluate_policy` with code that returns the values."
assert abs(V["y"]) < 1e-9, "State y pays nothing forever, so its value is 0."
assert abs(V["x"] - 1.0) < 1e-6, f"From x you get reward 1 and then move to y, so V(x) = 1, but you returned {V['x']!r}."
--- hint
Start every state at zero. In each sweep, update each state using only the action its policy chooses.
--- hint
Repeat `V[s] = sum(p * (r + gamma * V[s2]) for p, s2, r in P[s][policy[s]])` for each state, many times.
```

## Debug the Bellman update

This value update is meant to use the discount, but it applies the discount to the reward instead of to the next value.

```python debug id=bellman-discount title="Discount the next value, not the reward"
gamma = 0.5
V = {"next": 4.0}
outcomes = [(1.0, "next", 1.0)]
value = sum(p * (gamma * r + V[s2]) for p, s2, r in outcomes)     # bug: gamma multiplies the reward
print("value:", value)
--- solution
gamma = 0.5
V = {"next": 4.0}
outcomes = [(1.0, "next", 1.0)]
value = sum(p * (r + gamma * V[s2]) for p, s2, r in outcomes)
print("value:", value)
--- test
assert abs(value - 3.0) < 1e-9, f"The value should be the reward 1 plus 0.5 × 4 = 3, but the code gives {value}. The discount multiplies the next value."
--- hint
In the Bellman equation the discount multiplies the value of the next state.
--- hint
Write `r + gamma * V[s2]`.
```

## Recap

- An MDP has states, actions, transition probabilities and rewards. The next state depends only on the current state and action.
- The Bellman equation says a state's value is the expected reward plus the discounted value of what follows.
- Evaluating a policy means solving the Bellman equation for its actions, which can be done by repeated backups.
- Comparing the values of different choices tells you which policy is better.

**Up next:** dynamic programming, which uses the Bellman equation to find the exact best policy when the MDP is known.
