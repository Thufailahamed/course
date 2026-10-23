A **multi-armed bandit** is the simplest decision problem that needs learning. You face several slot machines, each with an unknown average payout. Pull an arm, observe a reward, and repeat. The dilemma is exploration versus exploitation: pulling the arm you currently believe is best earns reward now, but trying the others might reveal a better one. Every reinforcement-learning method has to solve this dilemma in some form.

## Estimating an arm's value

The value of an action is its expected reward. After $n$ pulls of an arm, the best estimate of its value is the sample average of its rewards, and it can be updated one pull at a time:

$$
Q_{n+1} = Q_n + \frac{1}{n + 1}\bigl(R_{n+1} - Q_n\bigr)
$$

```python run
import numpy as np

rng = np.random.default_rng(0)
true_mean = 0.7
estimate, count = 0.0, 0
for _ in range(20):
    reward = rng.normal(true_mean, 1.0)
    count += 1
    estimate += (reward - estimate) / count     # incremental average, no need to store rewards
print("estimate after 20 pulls:", round(estimate, 3), "| true value:", true_mean)
```

The update moves the estimate a little towards each new reward, with a step that shrinks as evidence accumulates. It is the same running-average rule that will reappear in every learning algorithm in this course.

## Epsilon-greedy

The simplest exploration rule is epsilon-greedy: with probability $\varepsilon$ pick a random arm, and otherwise pick the arm with the highest estimate.

```python run
def run_bandit(true_means, epsilon, pulls, rng):
    k = len(true_means)
    Q, N = np.zeros(k), np.zeros(k)
    total = 0.0
    for _ in range(pulls):
        if rng.random() < epsilon:
            a = rng.integers(k)
        else:
            a = int(np.argmax(Q))
        r = rng.normal(true_means[a], 1.0)
        N[a] += 1
        Q[a] += (r - Q[a]) / N[a]
        total += r
    return total / pulls

means = np.array([0.2, 0.5, 0.9, 0.4])
for eps in [0.0, 0.1, 0.3]:
    avg = np.mean([run_bandit(means, eps, 1000, np.random.default_rng(s)) for s in range(20)])
    print(f"epsilon {eps}: average reward per pull {avg:.3f}")
```

With no exploration the agent can lock onto a poor arm early. A little exploration finds the best arm, while too much keeps wasting pulls on bad ones.

## Upper confidence bounds

Epsilon-greedy explores blindly. The upper-confidence-bound rule explores the arms that are uncertain, choosing the arm with the highest estimate plus a bonus that shrinks as the arm is pulled more.

$$
A_t = \arg\max_a \left[ Q_t(a) + c \sqrt{\frac{\ln t}{N_t(a)}} \right]
$$

```python run
def run_ucb(true_means, c, pulls, rng):
    k = len(true_means)
    Q, N = np.zeros(k), np.zeros(k)
    total = 0.0
    for t in range(1, pulls + 1):
        if t <= k:
            a = t - 1                          # try every arm once first
        else:
            a = int(np.argmax(Q + c * np.sqrt(np.log(t) / N)))
        r = rng.normal(true_means[a], 1.0)
        N[a] += 1
        Q[a] += (r - Q[a]) / N[a]
        total += r
    return total / pulls

avg_ucb = np.mean([run_ucb(means, 1.0, 1000, np.random.default_rng(s)) for s in range(20)])
print(f"UCB (c = 1): average reward per pull {avg_ucb:.3f}")
```

## Regret measures the cost of learning

**Regret** is the reward you lost compared with always playing the best arm. A good algorithm has regret that grows slowly, so its average reward approaches the best arm's value.

```python run
best = means.max()
print("best arm value:", best)
print("UCB average reward is within", round(best - avg_ucb, 3), "of the best arm")
```

> **In the wild:** bandit algorithms choose which article to show, which advertisement to serve and which treatment to try first. The same exploration trade-off appears in every reinforcement-learning system.

## Challenge: incremental mean

```python exercise id=incremental-mean title="Update an estimate with one reward"
# TODO: `update_estimate(estimate, count, reward)` returns (new_estimate, new_count), where new_count is count + 1 and
# new_estimate is the average of all rewards seen so far, computed incrementally: estimate + (reward − estimate) / new_count.
def update_estimate(estimate, count, reward):
    ...
--- solution
def update_estimate(estimate, count, reward):
    count = count + 1
    return estimate + (reward - estimate) / count, count
--- test
result = update_estimate(2.0, 1, 4.0)
assert result is not None, "Replace the `...` in `update_estimate` with code that returns (estimate, count)."
new_est, new_count = result
assert new_count == 2, "The count should go from 1 to 2."
assert abs(new_est - 3.0) < 1e-9, f"The average of the rewards 2 and 4 is 3, but you returned {new_est!r}."
e, c = 0.0, 0
for r in [3.0, 1.0, 8.0]:
    e, c = update_estimate(e, c, r)
assert abs(e - 4.0) < 1e-9 and c == 3, "After rewards 3, 1 and 8 the average is 4, with a count of 3."
--- hint
The new count is one more than the old count. The estimate moves towards the reward by one over the new count.
--- hint
`count = count + 1` and `return estimate + (reward - estimate) / count, count`.
```

## Challenge: epsilon-greedy choice

```python exercise id=epsilon-choice title="Choose an arm with epsilon-greedy"
import numpy as np

# TODO: `epsilon_greedy(Q, epsilon, u)` returns an arm index. With probability epsilon (u < epsilon) return a
# uniformly random index of the form int(u * len(Q) / epsilon) clipped to the last arm; otherwise return the index of
# the largest value in Q, using the first one on ties. Here u is a number drawn from [0, 1) by the caller.
def epsilon_greedy(Q, epsilon, u):
    ...
--- solution
import numpy as np

def epsilon_greedy(Q, epsilon, u):
    Q = np.asarray(Q, dtype=float)
    if u < epsilon:
        return min(int(u / epsilon * len(Q)), len(Q) - 1)
    return int(np.argmax(Q))
--- test
import numpy as np
Q_t = np.array([0.1, 0.9, 0.3])
assert epsilon_greedy(Q_t, 0.1, 0.5) == 1, "With u = 0.5 above epsilon, the agent should exploit and pick the best arm, index 1."
assert epsilon_greedy(Q_t, 0.1, 0.99) == 1, "With u above epsilon the agent always exploits."
assert epsilon_greedy(np.array([0.0, 0.0]), 1.0, 0.0) == 0, "With epsilon 1 and u = 0 the agent explores the first arm."
assert epsilon_greedy(np.array([0.2, 0.2, 0.2]), 0.0, 0.5) == 0, "Ties go to the first arm when exploiting."
--- hint
Compare `u` with `epsilon` first. If `u < epsilon`, explore; otherwise return `np.argmax(Q)`.
--- hint
When exploring, scale `u` by `len(Q) / epsilon` to get an index, and clip it to the last index.
```

## Predict the average

```python predict id=predict-bandit title="Which arm has the highest estimate after these pulls?"
import numpy as np
Q = np.zeros(3)
N = np.zeros(3)
for arm, reward in [(0, 1.0), (1, 3.0), (1, 1.0)]:
    N[arm] += 1
    Q[arm] += (reward - Q[arm]) / N[arm]
print(int(np.argmax(Q)))
--- options
* 1
0
2
3
--- explain
Arm 0 has one reward of 1, so its estimate is 1. Arm 1 has rewards 3 and 1, so its estimate is their average, 2. Arm 1 has the highest estimate.
```

## Debug the update

This bandit update is meant to track the average reward of each arm, but it overwrites the estimate with the latest reward.

```python debug id=overwrite-estimate title="Average the rewards, don't overwrite them"
import numpy as np
rewards = [1.0, 3.0, 5.0]
Q, N = 0.0, 0
for r in rewards:
    N += 1
    Q = r                              # bug: the estimate should move towards r by 1/N, not be replaced by it
print("estimate:", Q)
--- solution
import numpy as np
rewards = [1.0, 3.0, 5.0]
Q, N = 0.0, 0
for r in rewards:
    N += 1
    Q += (r - Q) / N
print("estimate:", Q)
--- test
assert abs(Q - 3.0) < 1e-9, f"The average of 1, 3 and 5 is 3, but the estimate is {Q}. Move the estimate towards each reward by 1/N instead of overwriting it."
--- hint
Replacing the estimate throws away every earlier reward.
--- hint
Use `Q += (r - Q) / N`.
```

## Recap

- A bandit has unknown arm values. Learn them from rewards with incremental averages.
- Epsilon-greedy explores at random, and upper confidence bounds explore uncertain arms.
- Regret measures the reward lost while learning, and good algorithms keep it growing slowly.
- The exploration trade-off in bandits reappears in every reinforcement-learning method.

**Up next:** Markov decision processes, the framework that adds states and transitions to the bandit.
