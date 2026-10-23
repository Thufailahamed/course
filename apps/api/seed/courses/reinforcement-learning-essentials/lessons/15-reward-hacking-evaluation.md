An agent optimizes the reward it is given, not the goal you had in mind. When the reward is an imperfect measure of the goal, a capable enough optimizer finds the gap between them. A cleaning robot rewarded for "no visible dirt" learns to hide the dirt. A chatbot rewarded for approval learns to flatter. This is **reward hacking**, and it is the reason the evaluation of an agent must be designed as carefully as its training.

## Goodhart's law in numbers

Goodhart's law says that when a measure becomes a target, it ceases to be a good measure. The simulation below has a true quality that we cannot observe, and a proxy reward that we can. Optimizing the proxy harder first helps the true quality, then hurts it.

```python run
import numpy as np

rng = np.random.default_rng(0)
effort = np.linspace(0, 10, 11)                     # how hard the agent optimizes the proxy
true_quality = effort - 0.15 * effort ** 2          # helps at first, then hurts
proxy_reward = effort                               # the reward keeps climbing

for e, q, p in zip(effort[::2], true_quality[::2], proxy_reward[::2]):
    print(f"effort {e:4.1f}: proxy reward {p:5.1f}   true quality {q:+6.2f}")
```

The proxy reward keeps rising, but true quality peaks and then falls. An agent that is only monitored by the proxy will never notice the decline.

## Evaluate with held-out measures

The defence is to evaluate with measures the agent did not train on, ideally collected separately. Compare two policies on the held-out measure rather than the reward they were trained on.

```python run
rng = np.random.default_rng(1)
trained_on = rng.normal(1.0, 0.2, 200)              # the score the agent was optimized for
held_out = rng.normal(0.2, 0.2, 200)                # an independent check of real quality
print("training reward looks great:", round(trained_on.mean(), 2))
print("held-out quality is modest: ", round(held_out.mean(), 2))
```

A large gap between the optimized measure and the held-out measure is the warning sign of reward hacking.

## Uncertainty: report an interval, not a point

An evaluation averaged over a few episodes can look better or worse by luck. A **bootstrap** confidence interval resamples the observed results to show how much the average could move.

$$
\text{resample the } n \text{ scores with replacement, take the mean, repeat, and read off the 2.5th and 97.5th percentiles}
$$

```python run
scores = np.array([0.9, 1.1, 0.8, 1.3, 0.7, 1.0, 1.2, 0.95, 1.05, 0.85])
boot_rng = np.random.default_rng(2)
boot_means = np.array([boot_rng.choice(scores, len(scores)).mean() for _ in range(2000)])
low, high = np.percentile(boot_means, [2.5, 97.5])
print("mean:", round(scores.mean(), 3), "| 95% interval:", round(low, 3), "to", round(high, 3))
```

Two agents whose intervals overlap heavily are not reliably different, however their point estimates compare.

> **Pitfall:** comparing a single run per agent, or a single average over a few episodes, is how weak improvements get published as wins. Run several seeds and report intervals.

> **In the wild:** evaluation suites for language models and agents combine held-out benchmarks, human ratings and adversarial tests, precisely because any single measure can be gamed.

Two agents with similar means can still differ in ways that the interval must account for. Compare their scores on the same five test episodes.

```python run
agent_a = np.array([1.0, 1.2, 0.9, 1.1, 1.0])
agent_b = np.array([0.95, 1.3, 0.8, 1.2, 1.05])
print("agent A mean:", agent_a.mean().round(3), "| agent B mean:", agent_b.mean().round(3))
print("difference of means:", (agent_a.mean() - agent_b.mean()).round(3))
```

With only five episodes, a difference this small is not reliable, which is why the next challenge and the bootstrap interval matter.

## Challenge: a bootstrap interval

```python exercise id=bootstrap-ci title="Bootstrap confidence interval for a mean"
import numpy as np

# TODO: `bootstrap_ci(values, n_boot, seed)` returns (low, high), the 2.5th and 97.5th percentiles of the means of
# `n_boot` bootstrap resamples of `values` (each resample has the same length, drawn with replacement).
# Use np.random.default_rng(seed).
def bootstrap_ci(values, n_boot, seed):
    ...
--- solution
import numpy as np

def bootstrap_ci(values, n_boot, seed):
    values = np.asarray(values, dtype=float)
    rng = np.random.default_rng(seed)
    means = np.array([rng.choice(values, len(values)).mean() for _ in range(n_boot)])
    low, high = np.percentile(means, [2.5, 97.5])
    return float(low), float(high)
--- test
import numpy as np
values = np.full(20, 3.0)
result = bootstrap_ci(values, 200, 0)
assert result is not None, "Replace the `...` in `bootstrap_ci` with code that returns the interval."
low, high = result
assert np.isclose(low, 3.0) and np.isclose(high, 3.0), "Identical values give an interval of zero width at that value."
data = np.arange(10, dtype=float)
lo, hi = bootstrap_ci(data, 1000, 1)
assert lo < data.mean() < hi, f"The interval should contain the sample mean 4.5, but it is ({lo:.2f}, {hi:.2f})."
assert bootstrap_ci(data, 1000, 1) == (lo, hi), "The same seed must give the same interval."
--- hint
Draw `n_boot` resamples with `rng.choice(values, len(values))`, take each mean, then use `np.percentile` with `[2.5, 97.5]`.
--- hint
Collect the means in an array first, then call `np.percentile(means, [2.5, 97.5])`.
```

## Challenge: win rate between two agents

```python exercise id=win-rate title="Win rate of one agent over another"
import numpy as np

# TODO: `win_rate(a_scores, b_scores)` returns the fraction of paired episodes in which agent A scores higher than
# agent B. A tie counts as half a win. Both inputs have one score per episode, in the same order.
def win_rate(a_scores, b_scores):
    ...
--- solution
import numpy as np

def win_rate(a_scores, b_scores):
    a = np.asarray(a_scores, dtype=float)
    b = np.asarray(b_scores, dtype=float)
    return float(np.mean((a > b) + 0.5 * (a == b)))
--- test
result = win_rate([1.0, 2.0, 3.0], [2.0, 2.0, 1.0])
assert result is not None, "Replace the `...` in `win_rate` with code that returns the rate."
assert abs(result - 0.5) < 1e-9, f"A loses the first episode, ties the second (half a win) and wins the third, so the rate is (0 + 0.5 + 1) / 3 = 0.5, but you returned {result!r}."
assert abs(win_rate([5.0], [1.0]) - 1.0) < 1e-9, "A single episode that A wins gives a rate of 1."
--- hint
Compare the two arrays elementwise. Counting wins as 1 and ties as 0.5 gives `(a > b) + 0.5 * (a == b)`.
--- hint
Average that array with `np.mean`.
```

## Debug the interval source

This evaluation is meant to report the uncertainty of the mean, but it uses the spread of the raw scores as if it were the uncertainty of the average.

```python debug id=ci-source title="Interval of the mean, not of single scores"
import numpy as np

scores = np.array([0.9, 1.1, 0.8, 1.3, 0.7, 1.0, 1.2, 0.95, 1.05, 0.85])
low, high = np.percentile(scores, [2.5, 97.5])     # bug: this is the spread of single scores
print("interval for the mean:", round(low, 3), "to", round(high, 3))
--- solution
import numpy as np

scores = np.array([0.9, 1.1, 0.8, 1.3, 0.7, 1.0, 1.2, 0.95, 1.05, 0.85])
boot_rng = np.random.default_rng(2)
boot_means = np.array([boot_rng.choice(scores, len(scores)).mean() for _ in range(2000)])
low, high = np.percentile(boot_means, [2.5, 97.5])
print("interval for the mean:", round(low, 3), "to", round(high, 3))
--- test
assert high - low < 0.5, f"The uncertainty of the average of ten scores is much narrower than the spread of the scores themselves, but the interval is ({low:.3f}, {high:.3f}). Resample the means."
--- hint
An interval for the mean must come from the distribution of means, not from the individual scores.
--- hint
Compute bootstrap means, then take the percentiles of those means.
```

## Predict the gap

```python predict id=predict-gap title="What does a large gap between the proxy and the held-out measure suggest?"
print("reward hacking")
--- options
* reward hacking
a well-calibrated agent
a perfect reward
sampling noise only
--- explain
When an optimized measure rises while an independent measure does not, the agent has likely found a way to score well on the proxy without improving the goal. That divergence is the signature of reward hacking.
```

## Recap

- Optimizing a proxy hard eventually hurts the true goal, as Goodhart's law predicts.
- Evaluate with held-out measures that the agent was not optimized against.
- Report uncertainty with a bootstrap interval, and compare agents across several seeds.
- Treat any single measure as easy to game, and combine several.

**Up next:** the capstone, where you train an agent and evaluate it honestly.
