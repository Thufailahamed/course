So far the agent has learned values and then acted greedily on them. A **policy gradient** method skips the values and learns the policy directly: a parameterized rule for choosing actions, adjusted by gradient ascent on the expected return. It handles continuous actions and stochastic policies naturally, and it is the foundation of PPO and RLHF.

## A softmax policy

Give each action a preference score $\theta_a$ in each state. A softmax turns the preferences into probabilities, so every action has a positive chance and the chances sum to one:

$$
\pi(a) = \frac{e^{\theta_a}}{\sum_b e^{\theta_b}}
$$

```python run
import numpy as np

def softmax(theta):
    e = np.exp(theta - np.max(theta))
    return e / e.sum()

theta = np.array([0.0, 1.0, -1.0])
print("action probabilities:", np.round(softmax(theta), 3))
```

Raising one preference makes its action more likely, without ever making any other action impossible. That is what allows the policy to explore while it improves.

## The policy gradient

The REINFORCE theorem says that the gradient of the expected return with respect to the parameters is an average of $\nabla \log \pi(a \mid s)$ scaled by the return that followed:

$$
\nabla J(\theta) = \mathbb{E}\bigl[\, \nabla_\theta \log \pi_\theta(a \mid s)\; G \,\bigr]
$$

For a softmax policy the gradient of $\log \pi(a)$ with respect to the preferences has a simple form: the one-hot vector of the chosen action minus the probabilities.

$$
\nabla_\theta \log \pi(a) = \mathbf{e}_a - \pi
$$

```python run
def grad_log_softmax(theta, a):
    p = softmax(theta)
    onehot = np.zeros_like(theta)
    onehot[a] = 1.0
    return onehot - p

# check the formula against a numerical derivative
theta = np.array([0.2, -0.5, 0.7])
a = 2
eps = 1e-6
numeric = np.array([(np.log(softmax(theta + eps * np.eye(3)[j])[a]) - np.log(softmax(theta - eps * np.eye(3)[j])[a])) / (2 * eps) for j in range(3)])
print("formula:  ", np.round(grad_log_softmax(theta, a), 5))
print("numerical:", np.round(numeric, 5))
```

## Learn a three-armed bandit

```python run
rng = np.random.default_rng(0)
true_rewards = np.array([0.1, 0.8, 0.3])
theta = np.zeros(3)
lr = 0.1
baseline_reward = []
for episode in range(2000):
    p = softmax(theta)
    a = rng.choice(3, p=p)
    r = true_rewards[a] + rng.normal(0, 0.1)
    theta += lr * r * grad_log_softmax(theta, a)     # gradient ascent on expected reward
    baseline_reward.append(r)

print("final probabilities:", np.round(softmax(theta), 3))
print("average reward in the last 200 episodes:", round(np.mean(baseline_reward[-200:]), 3))
```

The policy concentrates on the best arm, which has reward 0.8. Notice that no value estimate was needed: the update uses only the sampled reward and the score of the action taken.

> **Pitfall:** raw returns make REINFORCE noisy, because every action in a good episode is praised, including the bad ones. The next lesson fixes this with baselines.

> **In the wild:** every policy-gradient method in use for language models and robotics is a refinement of this estimator, usually with a learned baseline and a constraint on how far the policy moves.

Sampling actions from the softmax policy gives frequencies that match its probabilities. Over a thousand draws the counts settle near those values.

```python run
rng_s = np.random.default_rng(4)
p_pref = softmax(np.array([0.0, 1.0, -1.0]))
draws = rng_s.choice(3, size=1000, p=p_pref)
print("sampled action frequencies:", np.bincount(draws, minlength=3) / 1000)
print("softmax probabilities:      ", np.round(p_pref, 3))
```

## Challenge: the softmax score

```python exercise id=softmax-score title="The score of a chosen action"
import numpy as np

# TODO: `score(theta, a)` returns the gradient of log π(a) for a softmax policy with preferences theta, which is
# the one-hot vector of action a minus the softmax probabilities.
def score(theta, a):
    ...
--- solution
import numpy as np

def score(theta, a):
    theta = np.asarray(theta, dtype=float)
    p = np.exp(theta - theta.max())
    p = p / p.sum()
    onehot = np.zeros_like(theta)
    onehot[a] = 1.0
    return onehot - p
--- test
import numpy as np
result = score(np.array([0.0, 0.0]), 0)
assert result is not None, "Replace the `...` in `score` with code that returns the gradient."
assert np.allclose(result, [0.5, -0.5]), f"With equal preferences π = [0.5, 0.5], so the score for action 0 is [1, 0] − [0.5, 0.5] = [0.5, −0.5], but you returned {result}."
assert abs(score(np.array([1.0, 2.0, 3.0]), 2).sum()) < 1e-9, "The scores of a softmax policy always sum to zero."
--- hint
Build the one-hot vector with a 1 at position `a`, and subtract the softmax probabilities. Use the shifted exponentials for stability.
--- hint
`onehot[a] = 1.0` then `return onehot - p`.
```

## Challenge: a REINFORCE step

```python exercise id=reinforce-step title="One REINFORCE update"
import numpy as np

# TODO: `reinforce_step(theta, a, G, lr)` returns the new preferences after one gradient-ascent step: theta + lr × G × score,
# where score is the gradient of log π(a) for the softmax policy with preferences theta.
def reinforce_step(theta, a, G, lr):
    ...
--- solution
import numpy as np

def reinforce_step(theta, a, G, lr):
    theta = np.asarray(theta, dtype=float)
    p = np.exp(theta - theta.max())
    p = p / p.sum()
    onehot = np.zeros_like(theta)
    onehot[a] = 1.0
    return theta + lr * G * (onehot - p)
--- test
import numpy as np
result = reinforce_step(np.array([0.0, 0.0]), 0, 2.0, 0.5)
assert result is not None, "Replace the `...` in `reinforce_step` with code that returns the new preferences."
assert np.allclose(result, [0.5, -0.5]), f"The step is 0.5 × 2 × [0.5, −0.5] = [0.5, −0.5], but you returned {result}."
down = reinforce_step(np.array([0.0, 0.0]), 1, -1.0, 1.0)
assert np.allclose(down, [0.5, -0.5]), "A negative return with action 1 should move its preference down, which lowers the preference of action 0 relative to it."
--- hint
Compute the score exactly as in the previous challenge, then add `lr * G` times it to theta.
--- hint
`return theta + lr * G * (onehot - p)`.
```

## Debug the direction of the step

This policy update is meant to make rewarding actions more likely, but it moves the preferences downhill.

```python debug id=ascent-direction title="Ascend the reward, don't descend it"
import numpy as np

theta = np.zeros(2)
a, G, lr = 0, 1.0, 0.5
p = np.exp(theta) / np.exp(theta).sum()
onehot = np.array([1.0, 0.0])
theta = theta - lr * G * (onehot - p)           # bug: a rewarding action should be pushed up
print("preferences after one step:", theta)
--- solution
import numpy as np

theta = np.zeros(2)
a, G, lr = 0, 1.0, 0.5
p = np.exp(theta) / np.exp(theta).sum()
onehot = np.array([1.0, 0.0])
theta = theta + lr * G * (onehot - p)
print("preferences after one step:", theta)
--- test
assert theta[0] > theta[1], f"Action 0 earned a positive return, so its preference should rise above action 1's, but the preferences are {theta}. Gradient ascent adds the step."
--- hint
We maximize expected return, so we move in the direction of the gradient, not against it.
--- hint
Replace `theta - lr * G * ...` with `theta + lr * G * ...`.
```

## Predict the probability

```python predict id=predict-pg title="What is the softmax probability of action 0 when both preferences are zero?"
import numpy as np
theta = np.zeros(2)
print(np.exp(theta[0]) / np.exp(theta).sum())
--- options
* 0.5
1.0
0.0
0.25
--- explain
With equal preferences every action has the same weight, so each of the two actions has probability one half.
```

## Recap

- A policy gradient method learns the policy's parameters directly, by gradient ascent on expected return.
- A softmax policy gives every action a positive probability, which supports exploration.
- The REINFORCE gradient is the score of the chosen action times the return that followed.
- Raw returns are noisy, which motivates baselines.

**Up next:** baselines and advantages, and the actor-critic that learns both a policy and a value.
