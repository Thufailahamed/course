Policy gradients have a dangerous failure mode: one large update can destroy a good policy, and the agent never recovers. **Proximal policy optimization** (PPO) keeps each update close to the previous policy. It measures how much the new policy's probability for each action has changed, the **probability ratio**, and clips that ratio to a narrow band. Improvements that would move the policy too far earn no extra credit, so the optimizer has no reason to take them.

## The probability ratio

The ratio compares the new policy with the old one for the action that was actually taken:

$$
r_t(\theta) = \frac{\pi_\theta(a_t \mid s_t)}{\pi_{\theta_{\text{old}}}(a_t \mid s_t)}
$$

A ratio of 1 means no change. A ratio of 1.5 means the new policy is fifty per cent more likely to take that action than the old one was.

```python run
import numpy as np

pi_old = np.array([0.5, 0.3, 0.2])
pi_new = np.array([0.6, 0.25, 0.15])
ratios = pi_new / pi_old
print("probability ratios for each action:", np.round(ratios, 2))
```

## The clipped objective

PPO maximizes a surrogate objective that multiplies each ratio by its advantage, but clips the ratio to $[1 - \varepsilon, 1 + \varepsilon]$ and takes the pessimistic minimum of the two versions:

$$
L^{\text{CLIP}} = \mathbb{E}\Bigl[\min\bigl(r_t A_t,\; \operatorname{clip}(r_t, 1-\varepsilon, 1+\varepsilon)\, A_t\bigr)\Bigr]
$$

```python run
def ppo_objective(ratio, advantage, eps=0.2):
    unclipped = ratio * advantage
    clipped = np.clip(ratio, 1 - eps, 1 + eps) * advantage
    return np.minimum(unclipped, clipped)

ratios = np.array([0.5, 1.0, 1.5])
for A in [1.0, -1.0]:
    print(f"advantage {A:+.0f}: objective {np.round(ppo_objective(ratios, A), 2)}")
```

Read the output carefully. With a positive advantage, a ratio above 1.2 gains nothing: the objective is flat, so the optimizer has no incentive to push the action further. With a negative advantage, a ratio below 0.8 gains nothing. The clip stops improvements that would move the policy too far in either direction.

## How often does clipping happen?

The fraction of samples that hit the clip is a useful health check. Too many clipped samples means the learning rate or the number of update epochs is too large.

```python run
rng = np.random.default_rng(0)
for spread in [0.05, 0.3]:
    ratio = 1 + rng.normal(0, spread, 5000)
    clipped = np.mean(np.abs(ratio - 1) > 0.2)
    print(f"policy change spread {spread}: fraction clipped {clipped:.3f}")
```

> **Pitfall:** clipping limits each update but does not guarantee a monotone improvement. PPO still needs a sensible learning rate, and it is normal to monitor the clip fraction and the KL divergence between the old and new policies during training.

## A PPO training loop

The full algorithm collects a batch of experience with the current policy, then performs several epochs of clipped updates on the same batch. The code below is for you to run locally with PyTorch, because it needs a neural network and an automatic-differentiation engine.

```python
# Static: run this on your own machine with PyTorch installed
import torch

def ppo_loss(new_logp, old_logp, advantages, clip=0.2):
    ratio = torch.exp(new_logp - old_logp)
    unclipped = ratio * advantages
    clipped = torch.clamp(ratio, 1 - clip, 1 + clip) * advantages
    return -torch.min(unclipped, clipped).mean()     # minimize the negative objective

# inside the training loop, for several epochs on the same batch:
# loss = ppo_loss(policy.log_prob(actions, states), old_logp, advantages)
# optimizer.zero_grad(); loss.backward(); optimizer.step()
```

The NumPy function `ppo_objective` above computes the same quantity. The torch version negates it because optimizers minimize, and it works with automatic differentiation so the gradient flows through the ratio.

Across a range of ratios, the objective is flat beyond the band in the direction the advantage favours.

```python run
ratios_grid = np.linspace(0.5, 1.5, 5)
print("ratio:             ", np.round(ratios_grid, 2))
print("objective (A = +1):", np.round(ppo_objective(ratios_grid, 1.0), 2))
print("objective (A = −1):", np.round(ppo_objective(ratios_grid, -1.0), 2))
```

## Challenge: the clipped objective

```python exercise id=ppo-clip title="The PPO clipped objective"
import numpy as np

# TODO: `ppo_clip(ratio, advantage, eps)` returns min(ratio × advantage, clip(ratio, 1 − eps, 1 + eps) × advantage)
# for a single ratio and advantage.
def ppo_clip(ratio, advantage, eps):
    ...
--- solution
import numpy as np

def ppo_clip(ratio, advantage, eps):
    clipped_ratio = min(max(ratio, 1 - eps), 1 + eps)
    return float(min(ratio * advantage, clipped_ratio * advantage))
--- test
result = ppo_clip(1.5, 1.0, 0.2)
assert result is not None, "Replace the `...` in `ppo_clip` with code that returns the objective."
assert abs(result - 1.2) < 1e-9, f"A ratio of 1.5 with advantage 1 is clipped to 1.2, and the minimum of 1.5 and 1.2 is 1.2, but you returned {result!r}."
assert abs(ppo_clip(0.5, 1.0, 0.2) - 0.5) < 1e-9, "A ratio below the band is not clipped in this direction, so the value stays 0.5."
assert abs(ppo_clip(1.5, -1.0, 0.2) + 1.5) < 1e-9, "With a negative advantage the unclipped term is the smaller one, so the value is −1.5."
--- hint
Clip the ratio into the band `[1 − eps, 1 + eps]` first, multiply both versions by the advantage, and take the minimum.
--- hint
`clipped_ratio = min(max(ratio, 1 - eps), 1 + eps)`, then `min(ratio * advantage, clipped_ratio * advantage)`.
```

## Challenge: the clip fraction

```python exercise id=clip-fraction title="How many ratios are clipped"
import numpy as np

# TODO: `clip_fraction(ratios, eps)` returns the fraction of ratios that lie outside the band [1 − eps, 1 + eps].
def clip_fraction(ratios, eps):
    ...
--- solution
import numpy as np

def clip_fraction(ratios, eps):
    ratios = np.asarray(ratios, dtype=float)
    return float(np.mean((ratios < 1 - eps) | (ratios > 1 + eps)))
--- test
import numpy as np
result = clip_fraction([0.5, 1.0, 1.5, 1.1], 0.2)
assert result is not None, "Replace the `...` in `clip_fraction` with code that returns the fraction."
assert abs(result - 0.5) < 1e-9, f"Two of four ratios (0.5 and 1.5) lie outside the band, so the fraction is 0.5, but you returned {result!r}."
assert clip_fraction([1.0, 1.0], 0.2) == 0.0, "No ratio outside the band gives a fraction of 0."
--- hint
A ratio is clipped when it is below `1 - eps` or above `1 + eps`. Combine the two tests with `|` and average the boolean array.
--- hint
`np.mean((ratios < 1 - eps) | (ratios > 1 + eps))`.
```

## Debug the clip direction

This PPO objective is meant to take the pessimistic minimum, but it takes the maximum, which rewards exactly the large updates the clip is meant to prevent.

```python debug id=ppo-max title="Take the pessimistic minimum"
import numpy as np

ratio, advantage, eps = 1.5, 1.0, 0.2
clipped = np.clip(ratio, 1 - eps, 1 + eps) * advantage
objective = max(ratio * advantage, clipped)           # bug: the max lets large updates through
print("objective:", objective)
--- solution
import numpy as np

ratio, advantage, eps = 1.5, 1.0, 0.2
clipped = np.clip(ratio, 1 - eps, 1 + eps) * advantage
objective = min(ratio * advantage, clipped)
print("objective:", objective)
--- test
assert abs(objective - 1.2) < 1e-9, f"PPO takes the minimum, giving 1.2 here, but the code gives {objective}. Taking the maximum rewards overly large policy changes."
--- hint
The clip is there to remove the incentive for large changes, so the objective must be the pessimistic version.
--- hint
Replace `max` with `min`.
```

## Predict the clip

```python predict id=predict-clip title="What is the objective for a ratio of 0.5 with a positive advantage?"
import numpy as np
ratio, advantage, eps = 0.5, 1.0, 0.2
print(min(ratio * advantage, np.clip(ratio, 1 - eps, 1 + eps) * advantage))
--- options
* 0.5
0.8
0.2
1.0
--- explain
The ratio 0.5 is below the band, so its clipped version is 0.8. The minimum of 0.5 and 0.8 is 0.5, so the unclipped value is used here. The clip prevents gains from growing past the band, not losses from shrinking.
```

## Recap

- The probability ratio compares the new and old policies for each action taken.
- PPO's clipped objective removes the incentive for updates that move the policy beyond a narrow band.
- The clip fraction and the policy divergence are the health checks to watch during training.
- Taking the pessimistic minimum is the heart of the method.

**Up next:** reinforcement learning for language models, starting with RLHF and the reward model that learns from human preferences.
