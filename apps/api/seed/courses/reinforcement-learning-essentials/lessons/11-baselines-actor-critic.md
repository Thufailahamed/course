The REINFORCE estimator is unbiased, but noisy. In an episode that earned a large return, every action gets pushed up, even the mediocre ones. A **baseline** fixes this without changing the expected gradient: subtract a value that depends only on the state, and push up only the actions that did better than expected. The difference between the return and the baseline is the **advantage**, and it is the quantity most modern policy-gradient methods use.

## Subtracting a baseline keeps the gradient honest

Any baseline $b(s)$ that does not depend on the action leaves the expected gradient unchanged, because the expected score is zero:

$$
\mathbb{E}_{a \sim \pi}\bigl[\nabla_\theta \log \pi(a \mid s)\bigr] = 0
$$

So $\nabla_\theta \log \pi(a \mid s)\,\bigl(G - b(s)\bigr)$ has the same expectation as the version without $b$, but much lower variance. The natural baseline is the state's value $V(s)$.

```python run
rng = np.random.default_rng(0)
mean_reward = np.array([10.0, 11.0])          # two actions, returns around 10 and 11
p = np.array([0.5, 0.5])                      # a uniform policy
n_samples = 20000
a = rng.choice(2, size=n_samples, p=p)
G = mean_reward[a] + rng.normal(0, 1.0, n_samples)
score = np.eye(2)[a] - p                      # ∇ log π(a) for a softmax policy at θ = 0
baseline = p @ mean_reward                    # the state's value, 10.5
g_without = G[:, None] * score
g_with = (G - baseline)[:, None] * score
print("mean gradient without baseline:", g_without.mean(axis=0).round(3))
print("mean gradient with baseline:   ", g_with.mean(axis=0).round(3))
print("spread without baseline:", g_without.std(axis=0).round(2), "| with baseline:", g_with.std(axis=0).round(2))
```

Both estimators agree on the average gradient, which is the point of the theory. The baselined version has a much smaller spread, so each sampled step is steadier and more useful.

How much does a baseline change the spread? Compare several baseline values for the same noisy returns.

```python run
rng_b = np.random.default_rng(5)
G_samples = rng_b.normal(10, 2, 5000)
for b in [0.0, 8.0, 10.0]:
    print(f"baseline {b:>4}: mean of G − b {np.mean(G_samples - b):6.2f}, std {np.std(G_samples - b):.2f}")
```

The mean moves with the baseline, but the gradient estimator is unbiased only when the baseline is a function of the state and not of the action. The best baseline removes the variance without changing the policy's expected update.

## Advantages

The advantage $A = G - V(s)$ measures how much better the action was than the state's average. Positive advantages are reinforced, and negative ones discouraged.

```python run
returns = np.array([12.0, 9.0, 11.0, 7.0])
values = np.array([10.0, 10.0, 10.0, 10.0])
advantages = returns - values
print("advantages:", advantages)
print("actions to reinforce:", np.where(advantages > 0)[0])
```

## Actor-critic

An **actor** is the policy and a **critic** is a learned value function. The critic estimates $V(s)$ and the actor is updated with the advantage, which the critic supplies. Actor-critic methods learn online, after every step, using the TD error as an advantage estimate.

```python run
def actor_critic(episodes=1500, lr_pi=0.05, lr_v=0.1, gamma=0.9, seed=0):
    # a two-state chain: in state 0 action 1 moves to state 1, which pays 1 and ends the episode
    rng = np.random.default_rng(seed)
    theta = np.zeros((2, 2))
    V = np.zeros(2)
    for _ in range(episodes):
        s, done = 0, False
        while not done:
            p = np.exp(theta[s] - theta[s].max()); p = p / p.sum()
            a = rng.choice(2, p=p)
            if s == 0 and a == 1:
                s2, r, done = 1, 0.0, False
            elif s == 0:
                s2, r, done = 0, 0.0, False
            else:
                s2, r, done = 0, 1.0, True
            target = r if done else r + gamma * V[s2]
            td_error = target - V[s]                    # the advantage estimate
            V[s] += lr_v * td_error
            onehot = np.zeros(2); onehot[a] = 1.0
            theta[s] += lr_pi * td_error * (onehot - p)
            s = s2
    return theta, V

theta_ac, V_ac = actor_critic()
print("learned values:", np.round(V_ac, 2))
print("policy in state 0 (prob of action 1):", round(float(np.exp(theta_ac[0, 1]) / np.exp(theta_ac[0]).sum()), 3))
```

The critic learns that state 0 is worth something positive, and the actor learns to take the path that leads to the reward.

> **In the wild:** A2C, A3C and the PPO methods of the next lesson are all actor-critic algorithms. Their critics are usually neural networks, and their advantages are often computed over several steps at once.

## Challenge: advantages

```python exercise id=advantages title="Compute advantages"
import numpy as np

# TODO: `advantages(returns, values)` returns the array of returns minus the matching baseline values, as floats.
def advantages(returns, values):
    ...
--- solution
import numpy as np

def advantages(returns, values):
    return np.asarray(returns, dtype=float) - np.asarray(values, dtype=float)
--- test
import numpy as np
result = advantages([5.0, 2.0, 7.0], [4.0, 4.0, 4.0])
assert result is not None, "Replace the `...` in `advantages` with code that returns the array."
assert np.allclose(result, [1.0, -2.0, 3.0]), f"The advantages are the returns minus the values, [1, −2, 3], but you returned {result}."
assert np.allclose(advantages([1.0], [1.0]), [0.0]), "An action that exactly matched expectations has zero advantage."
--- hint
Subtract the values from the returns elementwise. Convert to arrays first so both inputs may be lists.
--- hint
`np.asarray(returns, dtype=float) - np.asarray(values, dtype=float)`.
```

## Challenge: the TD advantage

```python exercise id=td-advantage title="The one-step TD advantage"
# TODO: `td_advantage(r, v_s, v_next, gamma, done)` returns the one-step advantage estimate r + gamma × v_next − v_s,
# where v_next is taken as zero when done is True.
def td_advantage(r, v_s, v_next, gamma, done):
    ...
--- solution
def td_advantage(r, v_s, v_next, gamma, done):
    future = 0.0 if done else gamma * v_next
    return float(r + future - v_s)
--- test
result = td_advantage(1.0, 2.0, 4.0, 0.5, False)
assert result is not None, "Replace the `...` in `td_advantage` with code that returns the estimate."
assert abs(result - 1.0) < 1e-9, f"The TD advantage is 1 + 0.5 × 4 − 2 = 1, but you returned {result!r}."
assert abs(td_advantage(1.0, 2.0, 4.0, 0.5, True) + 1.0) < 1e-9, "When the episode is done there is no future value, so the advantage is 1 − 2 = −1."
--- hint
This is the TD error: the one-step target minus the current value. Drop the future term when the episode is done.
--- hint
`future = 0.0 if done else gamma * v_next`, then `return float(r + future - v_s)`.
```

## Debug the baseline

This variance check is meant to subtract the baseline, but it subtracts the return from the value instead.

```python debug id=baseline-sign title="Advantage is the return minus the baseline"
import numpy as np

G = np.array([12.0, 9.0])
V = np.array([10.0, 10.0])
A = V - G                       # bug: the advantage is the return minus the baseline
print("advantages:", A)
--- solution
import numpy as np

G = np.array([12.0, 9.0])
V = np.array([10.0, 10.0])
A = G - V
print("advantages:", A)
--- test
assert np.allclose(A, [2.0, -1.0]), f"The advantage of an action that returned 12 against a baseline of 10 is +2, but the advantages are {A}. Subtract the baseline from the return."
--- hint
An action that beats expectations has a positive advantage. Which quantity should come first in the subtraction?
--- hint
Write `A = G - V`.
```

## Predict the advantage

```python predict id=predict-adv title="What is the advantage?"
G, V = 3.0, 5.0
print(G - V)
--- options
* -2.0
2.0
8.0
-8.0
--- explain
The action returned 3, which is worse than the expected 5, so its advantage is 3 − 5 = −2. Negative advantages discourage the action.
```

## Recap

- A state-dependent baseline leaves the expected policy gradient unchanged and reduces its variance.
- The advantage is the return minus the baseline: how much better the action was than expected.
- Actor-critic learns a policy and a value function together, with the TD error as the advantage estimate.
- The critic's accuracy determines how useful the advantages are.

**Up next:** PPO, which keeps each policy update inside a safe region.
