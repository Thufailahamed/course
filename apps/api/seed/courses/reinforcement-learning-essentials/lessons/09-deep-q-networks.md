A Q-table works when there are a few hundred states. A robot camera or a game screen has millions. A **deep Q-network** (DQN) replaces the table with a function that estimates $Q(s, a)$ from features of the state, so experience in one situation teaches the agent about similar ones. Two tricks make that stable, and both are essential: an **experience replay** buffer that breaks the correlation between consecutive steps, and a **target network** that stops the target from moving every time the estimate changes.

This lesson builds both ideas in NumPy with a simple function approximator, then shows the standard deep version in PyTorch as static code for you to run locally.

## Function approximation

A linear approximator scores each action with a weighted sum of state features. With one weight vector per action, $Q(s, a) = w_a \cdot \phi(s)$. Nearby states have similar features, so they share what they learn.

```python run
import numpy as np

def features(x):
    # radial basis features over a continuous position x in [0, 1]
    centers = np.linspace(0, 1, 6)
    return np.exp(-((x - centers) ** 2) / 0.02)

x = 0.37
print("feature vector at x = 0.37:", np.round(features(x), 2))

W = np.zeros((2, 6))                  # two actions, six features each
q_values = W @ features(x)
print("Q-values for both actions:", q_values)
```

## Experience replay

Consecutive steps are highly correlated, and learning from them one after another is unstable. A replay buffer stores past transitions, and training samples random mini-batches from it.

```python run
rng = np.random.default_rng(0)
buffer = []
for t in range(100):
    s = rng.random()
    a = rng.integers(2)
    buffer.append((s, a, rng.normal(), rng.random(), False))
    if len(buffer) > 50:
        buffer.pop(0)                  # keep only the most recent 50 transitions

batch = [buffer[i] for i in rng.choice(len(buffer), 8, replace=False)]
print("buffer holds", len(buffer), "transitions; a random batch has", len(batch))
```

## Training with a target network

The target is computed with a separate copy of the weights, updated only every few hundred steps. The estimate chases a target that does not move with every update, which damps oscillations.

```python run
def train_dqn(steps=3000, lr=0.05, gamma=0.9, seed=0):
    rng = np.random.default_rng(seed)
    W = np.zeros((2, 6))
    W_target = W.copy()
    buf = []
    x = rng.random()
    for t in range(steps):
        a = rng.integers(2) if rng.random() < 0.3 else int(np.argmax(W @ features(x)))
        # toy environment: action 1 pays 1 when x is above 0.5, action 0 pays 1 otherwise
        r = 1.0 if (a == 1) == (x > 0.5) else 0.0
        x2 = rng.random()
        buf.append((x, a, r, x2))
        if len(buf) > 500:
            buf.pop(0)
        xb, ab, rb, x2b = buf[rng.integers(len(buf))]
        target = rb + gamma * np.max(W_target @ features(x2b))
        pred = W[ab] @ features(xb)
        W[ab] += lr * (target - pred) * features(xb)
        if t % 200 == 0:
            W_target = W.copy()
        x = x2
    return W

W = train_dqn()
test_x = np.array([0.1, 0.4, 0.6, 0.9])
policy = [int(np.argmax(W @ features(v))) for v in test_x]
print("learned action for x =", test_x, "->", policy)
```

The learned policy is correct for every test state, although the agent never saw these exact inputs during training. That is generalization through features.

After training, the Q-values at a state show the agent's preference between the two actions, and how confident it is.

```python run
print("Q-values at x = 0.9:", np.round(W @ features(0.9), 2))
print("Q-values at x = 0.1:", np.round(W @ features(0.1), 2))
```

## The deep version

The same algorithm with a neural network as the function approximator is standard in libraries. The code below is for you to run on your own machine, because it needs PyTorch.

```python
# Static: run this on your own machine with PyTorch installed
import torch
import torch.nn as nn

q_net = nn.Sequential(nn.Linear(4, 64), nn.ReLU(), nn.Linear(64, 2))
target_net = nn.Sequential(nn.Linear(4, 64), nn.ReLU(), nn.Linear(64, 2))
target_net.load_state_dict(q_net.state_dict())
optimizer = torch.optim.Adam(q_net.parameters(), lr=1e-3)

def dqn_step(states, actions, rewards, next_states, dones, gamma=0.99):
    q = q_net(states).gather(1, actions.unsqueeze(1)).squeeze(1)
    with torch.no_grad():
        next_max = target_net(next_states).max(dim=1).values
        target = rewards + gamma * (1 - dones) * next_max
    loss = nn.functional.mse_loss(q, target)
    optimizer.zero_grad()
    loss.backward()
    optimizer.step()
    return loss.item()
```

Map every line to a lesson idea: the `gather` picks the taken action's value, the `no_grad` block is the target network, and `(1 - dones)` is the terminal rule from the last lesson.

## Challenge: sample a replay batch

```python exercise id=replay-batch title="Sample a replay batch without repeats"
import numpy as np

# TODO: `replay_indices(buffer_size, batch_size, seed)` returns an array of `batch_size` distinct indices in
# the range 0 to buffer_size − 1, drawn uniformly with np.random.default_rng(seed).
def replay_indices(buffer_size, batch_size, seed):
    ...
--- solution
import numpy as np

def replay_indices(buffer_size, batch_size, seed):
    return np.random.default_rng(seed).choice(buffer_size, batch_size, replace=False)
--- test
import numpy as np
result = replay_indices(100, 8, 0)
assert result is not None, "Replace the `...` in `replay_indices` with code that returns the indices."
assert len(result) == 8, "The batch should hold 8 indices."
assert len(set(result.tolist())) == 8, "The indices must be distinct."
assert result.min() >= 0 and result.max() < 100, "Indices must lie inside the buffer."
assert np.array_equal(replay_indices(100, 8, 0), result), "The same seed must give the same batch."
--- hint
`rng.choice(n, k, replace=False)` draws k distinct values from 0 to n − 1.
--- hint
`np.random.default_rng(seed).choice(buffer_size, batch_size, replace=False)`.
```

## Challenge: DQN targets

```python exercise id=dqn-targets title="Compute DQN targets for a batch"
import numpy as np

# TODO: `dqn_targets(rewards, next_max_q, dones, gamma)` returns an array of targets: rewards + gamma × next_max_q,
# with the future term set to zero where done is 1 (True). All inputs are arrays of the same length.
def dqn_targets(rewards, next_max_q, dones, gamma):
    ...
--- solution
import numpy as np

def dqn_targets(rewards, next_max_q, dones, gamma):
    rewards = np.asarray(rewards, dtype=float)
    next_max_q = np.asarray(next_max_q, dtype=float)
    dones = np.asarray(dones, dtype=float)
    return rewards + gamma * (1.0 - dones) * next_max_q
--- test
import numpy as np
result = dqn_targets([1.0, 0.0], [4.0, 10.0], [0, 1], 0.5)
assert result is not None, "Replace the `...` in `dqn_targets` with code that returns the targets."
assert np.allclose(result, [1.0 + 0.5 * 4.0, 0.0]), f"The first target is 1 + 0.5 × 4 = 3, and the second is 0 because that episode is done. You returned {result}."
assert result.shape == (2,), "There is one target per transition."
--- hint
Multiply the future value by `(1 − done)`, so finished episodes lose that term. Then add the rewards.
--- hint
`rewards + gamma * (1 - dones) * next_max_q`, with all three inputs converted to arrays first.
```

## Debug the terminal term

This target is meant to drop the future value of finished episodes, but it keeps it.

```python debug id=dqn-done-term title="Drop the future value at the end of an episode"
import numpy as np

rewards = np.array([1.0, 0.0])
next_max_q = np.array([4.0, 10.0])
dones = np.array([0.0, 1.0])
gamma = 0.5
targets = rewards + gamma * next_max_q            # bug: the done flag is ignored
print("targets:", targets)
--- solution
import numpy as np

rewards = np.array([1.0, 0.0])
next_max_q = np.array([4.0, 10.0])
dones = np.array([0.0, 1.0])
gamma = 0.5
targets = rewards + gamma * (1 - dones) * next_max_q
print("targets:", targets)
--- test
assert np.allclose(targets, [3.0, 0.0]), f"The second episode is done, so its target should be 0, but the targets are {targets}. Multiply the future term by (1 − dones)."
--- hint
A done flag of 1 must switch off the future term.
--- hint
Insert the factor `(1 - dones)` in front of `next_max_q`.
```

## Predict the target

```python predict id=predict-dqn title="What target does a done transition give?"
import numpy as np
r, gamma, done, next_max = 2.0, 0.9, 1.0, 100.0
print(r + gamma * (1 - done) * next_max)
--- options
* 2.0
92.0
90.0
102.0
--- explain
The episode is done, so the future term is multiplied by zero. The target is just the reward 2.0, however large the value of the next state looks.
```

## Recap

- A function approximator generalizes across similar states, which tables cannot do.
- Experience replay samples random past transitions, which stabilizes training.
- A target network is copied only occasionally, so the target does not chase the estimate.
- Terminal transitions drop the future term, as in every method in this course.

**Up next:** checkpoint quiz, then policy-gradient methods, which learn the policy directly.
