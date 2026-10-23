RLHF works, but it is complicated. It needs a reward model, a reinforcement-learning loop, sampling from the policy during training and careful tuning of the penalty. **Direct preference optimization** (DPO) shows that the same objective can be optimized with a single supervised loss on preference pairs, with no separate reward model and no sampling loop. It has become one of the most widely used alternatives to RLHF.

## The idea in one line

The RLHF objective has an optimal policy in closed form. Rearranging that solution expresses the reward as a log-ratio between the trained policy and the reference policy. Substituting it into the Bradley–Terry preference model gives a loss that depends only on the policy's log probabilities.

$$
\mathcal{L}_{\text{DPO}} = -\log \sigma\!\left( \beta \Big[ \bigl(\log \pi_\theta(y_w \mid x) - \log \pi_{\text{ref}}(y_w \mid x)\bigr) - \bigl(\log \pi_\theta(y_l \mid x) - \log \pi_{\text{ref}}(y_l \mid x)\bigr) \Big] \right)
$$

Here $y_w$ is the preferred answer and $y_l$ the rejected one. The loss grows when the policy prefers the rejected answer, relative to the reference model, more than it prefers the chosen one.

```python run
import numpy as np

def sigmoid(z):
    return 1 / (1 + np.exp(-z))

def dpo_loss(logp_w, logp_l, ref_w, ref_l, beta=0.1):
    margin = beta * ((logp_w - ref_w) - (logp_l - ref_l))
    return float(np.logaddexp(0.0, -margin))

# the reference model finds both answers equally likely
print("no change from the reference:", round(dpo_loss(-5.0, -5.0, -5.0, -5.0), 4))
print("policy favours the chosen answer:", round(dpo_loss(-3.0, -7.0, -5.0, -5.0), 4))
print("policy favours the rejected answer:", round(dpo_loss(-7.0, -3.0, -5.0, -5.0), 4))
```

When the policy is no different from the reference, the loss is $\log 2$. Training pushes the chosen answer's relative probability up and the rejected answer's down.

## Why the reference model matters

The reference model is a fixed copy of the starting policy. Measuring the change against it is what keeps the policy close to where it started, which plays the role of the KL penalty in RLHF.

```python run
beta = 0.1
ref = np.array([-5.0, -5.0])
for shift in [0.0, 1.0, 3.0]:
    policy = ref + np.array([shift, -shift])        # more mass on the chosen answer
    loss = dpo_loss(policy[0], policy[1], ref[0], ref[1], beta)
    print(f"shift {shift}: loss {loss:.4f}, implicit reward margin {beta * (2 * shift):.2f}")
```

The implicit reward margin is what the loss rewards, and it grows with the shift. A larger $\beta$ makes the same change count for more.

Training uses many pairs at once, and the loss is averaged over the batch. Here three pairs are scored: one the policy prefers correctly, one it gets wrong, and one where it has not moved.

```python run
pairs = np.array([[-3.0, -7.0, -5.0, -5.0],
                  [-6.0, -4.0, -5.0, -5.0],
                  [-5.0, -5.0, -5.0, -5.0]])
losses = [dpo_loss(*row, beta=0.1) for row in pairs]
print("loss per pair:", np.round(losses, 3))
print("mean loss over the batch:", round(float(np.mean(losses)), 3))
```

## DPO in practice

The loss needs the log probability of each full answer under the policy and the reference, which language-model libraries compute for you. The code below is for you to run locally, because it needs a language model.

```python
# Static: run this on your own machine with a language model and PyTorch installed
import torch
import torch.nn.functional as F

def dpo_loss_torch(policy_w, policy_l, ref_w, ref_l, beta=0.1):
    margin = beta * ((policy_w - ref_w) - (policy_l - ref_l))
    return -F.logsigmoid(margin).mean()

# policy_w = model.log_prob(chosen_answers), ref_w = reference.log_prob(chosen_answers), and so on
```

> **Pitfall:** DPO is only as good as its preference data. Pairs that are noisy, or that differ only in length, teach the model to prefer length rather than quality.

> **In the wild:** DPO and its variants are used to align open language models, often alongside supervised fine-tuning on high-quality examples first.

The loss falls smoothly as the margin grows. A confident, correct margin contributes almost no gradient, so training focuses on the pairs it still gets wrong.

```python run
margins = np.linspace(-2, 2, 5)
print("margin:", margins)
print("loss:  ", np.round(np.logaddexp(0.0, -margins), 3))
for m_val in [0.0, 2.0, 5.0]:
    print(f"margin {m_val}: gradient size {1 / (1 + np.exp(m_val)):.4f}")
```

## Challenge: the DPO margin

```python exercise id=dpo-margin title="The DPO margin"
# TODO: `dpo_margin(logp_w, logp_l, ref_w, ref_l, beta)` returns beta × ((logp_w − ref_w) − (logp_l − ref_l)).
def dpo_margin(logp_w, logp_l, ref_w, ref_l, beta):
    ...
--- solution
def dpo_margin(logp_w, logp_l, ref_w, ref_l, beta):
    return beta * ((logp_w - ref_w) - (logp_l - ref_l))
--- test
result = dpo_margin(-3.0, -7.0, -5.0, -5.0, 0.5)
assert result is not None, "Replace the `...` in `dpo_margin` with code that returns the margin."
assert abs(result - 0.5 * (2.0 - (-2.0))) < 1e-9, f"The chosen answer rose by 2 and the rejected one fell by 2, so the margin is 0.5 × (2 + 2) = 2, but you returned {result!r}."
assert abs(dpo_margin(-5.0, -5.0, -5.0, -5.0, 0.1)) < 1e-9, "With no change from the reference the margin is zero."
--- hint
Compute the change of each log probability from the reference, subtract the rejected change from the chosen change, then multiply by beta.
--- hint
`beta * ((logp_w - ref_w) - (logp_l - ref_l))`.
```

## Challenge: the DPO loss

```python exercise id=dpo-loss title="The DPO loss from the margin"
import numpy as np

# TODO: `dpo_loss_value(margin)` returns −log σ(margin) for a margin given as a number, computed stably with
# np.logaddexp(0, −margin).
def dpo_loss_value(margin):
    ...
--- solution
import numpy as np

def dpo_loss_value(margin):
    return float(np.logaddexp(0.0, -margin))
--- test
result = dpo_loss_value(0.0)
assert result is not None, "Replace the `...` in `dpo_loss_value` with code that returns the loss."
assert abs(result - np.log(2)) < 1e-9, f"A zero margin gives log 2 ≈ 0.693, but you returned {result!r}."
assert dpo_loss_value(10.0) < 0.001, "A large positive margin gives a loss close to zero."
assert dpo_loss_value(-10.0) > 9.9, "A large negative margin gives a loss close to 10."
--- hint
This is the negative log of the sigmoid of the margin. The stable form is `np.logaddexp(0, -margin)`.
--- hint
`return float(np.logaddexp(0.0, -margin))`.
```

## Debug the swapped answers

This DPO margin is meant to reward the chosen answer, but the two answers are swapped, so the policy is pushed towards the rejected one.

```python debug id=swapped-answers title="Keep the chosen answer first"
import numpy as np

logp_chosen, logp_rejected = -3.0, -7.0
ref_chosen, ref_rejected = -5.0, -5.0
beta = 0.1
margin = beta * ((logp_rejected - ref_rejected) - (logp_chosen - ref_chosen))   # bug: the two are swapped
print("margin:", round(margin, 3))
--- solution
import numpy as np

logp_chosen, logp_rejected = -3.0, -7.0
ref_chosen, ref_rejected = -5.0, -5.0
beta = 0.1
margin = beta * ((logp_chosen - ref_chosen) - (logp_rejected - ref_rejected))
print("margin:", round(margin, 3))
--- test
assert abs(margin - 0.4) < 1e-9, f"The chosen answer rose by 2 and the rejected one fell by 2, so the margin is 0.1 × 4 = 0.4, but it is {margin:.3f}. The chosen answer goes first."
--- hint
The margin should be large and positive when the policy favours the chosen answer.
--- hint
Put the chosen terms first: `(logp_chosen - ref_chosen) - (logp_rejected - ref_rejected)`.
```

## Predict the loss

```python predict id=predict-dpo title="What is the DPO loss when the margin is zero?"
import numpy as np
print(round(float(np.logaddexp(0.0, -0.0)), 3))
--- options
* 0.693
0.0
0.5
1.0
--- explain
With a zero margin the chosen and rejected answers are treated as equal, so the loss is log 2, which is about 0.693.
```

## Recap

- DPO optimizes a supervised loss on preference pairs, with the reference model as the baseline.
- Its margin compares how much the policy changed the chosen answer's probability against the rejected one's.
- It removes the reward model and the sampling loop of RLHF, at the cost of depending entirely on the preference data.
- The loss is $-\log\sigma(\text{margin})$, which is $\log 2$ when the policy has not moved.

**Up next:** reward hacking, and how to evaluate an agent in a way that the agent cannot game.
