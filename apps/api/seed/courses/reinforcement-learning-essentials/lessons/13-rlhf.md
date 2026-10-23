Language models are trained to predict text, which does not make them helpful, honest or safe. **Reinforcement learning from human feedback** (RLHF) bridges that gap. People compare pairs of model answers and say which they prefer. A **reward model** learns to score answers the way people do, and the language model is then trained with reinforcement learning to earn high scores, while staying close to its original behaviour.

RLHF has three stages: collect preferences, train a reward model on them, and optimize the policy against the reward model with a penalty that keeps it from drifting too far. This lesson builds the first two in NumPy, and explains the third.

## Preferences as comparisons

People find it easier to say which of two answers is better than to give each answer a score. Those comparisons are modelled with the **Bradley–Terry** rule: the probability that answer $A$ is preferred to $B$ depends on the difference of their rewards.

$$
P(A \succ B) = \sigma\bigl(r(A) - r(B)\bigr)
$$

```python run
import numpy as np

def sigmoid(z):
    return 1 / (1 + np.exp(-z))

for diff in [-2.0, 0.0, 2.0]:
    print(f"reward difference {diff:+.1f}: P(preferred) = {sigmoid(diff):.3f}")
```

A difference of zero means a coin flip. A large difference means the preference is nearly certain.

## Train a reward model

Represent each answer by a few features, and let the reward be a weighted sum. The training loss is the negative log-likelihood of the observed preferences.

```python run
rng = np.random.default_rng(0)
n_pairs, d = 300, 3
true_w = np.array([1.0, -0.5, 2.0])          # what the people really value, unknown to the model
A = rng.normal(0, 1, (n_pairs, d))            # features of the preferred answer
B = rng.normal(0, 1, (n_pairs, d))            # features of the rejected answer
prefers_A = (sigmoid((A - B) @ true_w + rng.normal(0, 0.3, n_pairs)) > 0.5)
chosen = np.where(prefers_A[:, None], A, B)
rejected = np.where(prefers_A[:, None], B, A)

w = np.zeros(d)
for step in range(500):
    diff = (chosen - rejected) @ w
    grad = -((1 - sigmoid(diff))[:, None] * (chosen - rejected)).mean(axis=0)
    w -= 0.5 * grad

print("learned reward weights:", w.round(2))
print("training pairs ranked correctly:", round(float(np.mean((chosen - rejected) @ w > 0)), 3))
```

The learned weights point the same way as the hidden values, up to a scale. A reward model only needs to rank answers correctly, so its absolute scale does not matter.

## Optimize the policy with a KL penalty

Once a reward model exists, the policy is trained to maximize it, but a policy that simply chases the reward model drifts into strange text that scores well and reads badly. RLHF keeps the policy close to the original model $\pi_{\text{ref}}$ with a KL penalty:

$$
\max_{\pi}\; \mathbb{E}\bigl[ r(x, y) \bigr] - \beta\, \mathrm{KL}\bigl(\pi(\cdot \mid x)\,\|\,\pi_{\text{ref}}(\cdot \mid x)\bigr)
$$

The coefficient $\beta$ trades reward for fidelity. Large $\beta$ keeps the model close to the original, and small $\beta$ lets it chase the reward model harder.

```python run
def kl(p, q):
    return float(np.sum(p * np.log(p / q)))

pi_ref = np.array([0.4, 0.4, 0.2])
pi_drift = np.array([0.05, 0.05, 0.9])        # a policy that bet everything on one answer
print("KL of a mild change:", round(kl(np.array([0.45, 0.35, 0.2]), pi_ref), 4))
print("KL of the drifted policy:", round(kl(pi_drift, pi_ref), 4))
```

> **Pitfall:** a reward model is only an approximation of human judgement. A policy optimized hard against it will find the approximation's blind spots. This is reward hacking, and the last lessons of this course are about it.

> **In the wild:** the instruction-following behaviour of modern assistants was trained with preference data and reinforcement learning of this kind, with the KL penalty and a large reward model.

The reward model turns each pair into a predicted probability. For the first five training pairs, the model's confidence is shown below.

```python run
probs = sigmoid((chosen - rejected) @ w)
print("predicted preference probabilities for five pairs:", np.round(probs[:5], 2))
```

## Challenge: the preference probability

```python exercise id=preference-prob title="Probability that one answer is preferred"
import numpy as np

# TODO: `preference_prob(r_a, r_b)` returns sigmoid(r_a − r_b), the Bradley–Terry probability that answer A is preferred.
def preference_prob(r_a, r_b):
    ...
--- solution
import numpy as np

def preference_prob(r_a, r_b):
    return float(1 / (1 + np.exp(-(r_a - r_b))))
--- test
result = preference_prob(2.0, 2.0)
assert result is not None, "Replace the `...` in `preference_prob` with code that returns the probability."
assert abs(result - 0.5) < 1e-9, "Equal rewards give a probability of one half."
assert abs(preference_prob(1.0, 0.0) - 1 / (1 + np.exp(-1.0))) < 1e-9, "The probability depends on the difference r_a − r_b through the sigmoid."
assert preference_prob(10.0, 0.0) > 0.999, "A large advantage should give a probability near one."
--- hint
Compute the difference first, then pass it through the sigmoid `1 / (1 + exp(−z))`.
--- hint
`return float(1 / (1 + np.exp(-(r_a - r_b))))`.
```

## Challenge: the pairwise loss

```python exercise id=pairwise-loss title="Reward model loss on one pair"
import numpy as np

# TODO: `pairwise_loss(r_chosen, r_rejected)` returns the negative log-likelihood −log σ(r_chosen − r_rejected) of the
# observed preference. Compute it stably as log(1 + exp(−diff)) using np.logaddexp(0, −diff).
def pairwise_loss(r_chosen, r_rejected):
    ...
--- solution
import numpy as np

def pairwise_loss(r_chosen, r_rejected):
    diff = r_chosen - r_rejected
    return float(np.logaddexp(0.0, -diff))
--- test
result = pairwise_loss(0.0, 0.0)
assert result is not None, "Replace the `...` in `pairwise_loss` with code that returns the loss."
assert abs(result - np.log(2)) < 1e-9, f"With equal rewards the probability is 1/2 and the loss is log 2 ≈ 0.693, but you returned {result!r}."
assert pairwise_loss(5.0, 0.0) < 0.01, "A confident correct ranking gives a very small loss."
assert pairwise_loss(-5.0, 0.0) > 4.9, "A confident wrong ranking gives a large loss."
--- hint
The loss is the negative log of the sigmoid of the difference. `np.logaddexp(0, -diff)` computes that without overflow.
--- hint
`return float(np.logaddexp(0.0, -(r_chosen - r_rejected)))`.
```

## Debug the preference direction

This reward-model loss is meant to penalize a wrong ranking, but it reverses the difference, so it rewards the wrong answer.

```python debug id=pref-direction title="Score the chosen answer above the rejected one"
import numpy as np

r_chosen, r_rejected = 3.0, 0.0
diff = r_rejected - r_chosen          # bug: the chosen answer should be the first term
loss = np.logaddexp(0.0, -diff)
print("loss:", round(float(loss), 4))
--- solution
import numpy as np

r_chosen, r_rejected = 3.0, 0.0
diff = r_chosen - r_rejected
loss = np.logaddexp(0.0, -diff)
print("loss:", round(float(loss), 4))
--- test
assert abs(loss - np.logaddexp(0.0, -3.0)) < 1e-9, f"The chosen answer (reward 3) beats the rejected one (0), so the loss should be small, about 0.0486, but it is {loss:.4f}. The difference must be chosen minus rejected."
--- hint
The chosen answer's reward should be the one that goes first in the difference.
--- hint
Write `diff = r_chosen - r_rejected`.
```

## Predict the probability

```python predict id=predict-rlhf title="What is the Bradley–Terry probability when the rewards are 1 and 1?"
import numpy as np
print(round(float(1 / (1 + np.exp(-(1.0 - 1.0)))), 2))
--- options
* 0.5
0.0
1.0
0.73
--- explain
Equal rewards mean the difference is zero, and the sigmoid of zero is one half. The people are equally likely to prefer either answer.
```

## Recap

- Human preferences are pairwise comparisons, modelled with the Bradley–Terry probability.
- A reward model is trained to rank preferred answers above rejected ones, and only its ranking matters.
- The policy is optimized against the reward model with a KL penalty that keeps it close to the original model.
- The reward model is an approximation, which makes reward hacking a central risk.

**Up next:** DPO, which optimizes the policy directly from preferences and skips the separate reward model.
