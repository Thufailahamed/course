Every training run you have written has the same four steps: forward pass, loss, backward pass and update. PyTorch gives each step a standard home. A **module** holds the parameters, a **data loader** serves shuffled mini-batches, an **optimizer** applies the update rule from lesson 11, and a loop ties them together. Learning this shape once means you can read almost any PyTorch project.

The PyTorch code here is for you to run on your own machine. The NumPy versions below run in the page and follow the same structure, so you can see that nothing in the framework is doing something you could not do yourself.

## The PyTorch training loop

This is the standard shape, with a model, a loss, an optimizer and a loader:

```python
import torch
from torch import nn
from torch.utils.data import DataLoader, TensorDataset

model = nn.Sequential(
    nn.Linear(2, 16),
    nn.Tanh(),
    nn.Dropout(0.1),
    nn.Linear(16, 1),
)
loss_fn = nn.BCEWithLogitsLoss()     # sigmoid and cross-entropy in one stable step
optimizer = torch.optim.Adam(model.parameters(), lr=1e-2)

train_loader = DataLoader(TensorDataset(X_train, y_train), batch_size=32, shuffle=True)

for epoch in range(20):
    model.train()                    # enable dropout and batch-norm training behaviour
    for xb, yb in train_loader:
        optimizer.zero_grad()        # clear the gradients from the last step
        logits = model(xb)           # forward pass
        loss = loss_fn(logits, yb)   # loss
        loss.backward()              # backward pass
        optimizer.step()             # update the parameters

    model.eval()                     # turn dropout off for evaluation
    with torch.no_grad():            # no gradients needed for evaluation
        val_logits = model(X_val)
        val_loss = loss_fn(val_logits, y_val)
    print(epoch, round(val_loss.item(), 4))
```

Map every line to something you wrote. `optimizer.zero_grad()` is the accumulation fix from lesson 14. `loss.backward()` is lesson 9. `optimizer.step()` is the update rule from lesson 11. `model.train()` and `model.eval()` switch dropout, which you built in lesson 12, between its two behaviours.

> **Pitfall:** the order is `zero_grad`, then `backward`, then `step`. Calling `step` before `backward` updates with the previous batch's gradients, and calling `backward` without `zero_grad` adds the new gradients to the old ones. Both bugs train without an error and silently make learning worse.

## The NumPy version, runnable here

Here is the same loop in NumPy, with mini-batches shuffled every epoch, dropout that runs only in training mode, and a separate evaluation pass.

```python run
import matplotlib.pyplot as plt

def make_moons(n=300, noise=0.2, seed=0):
    rng = np.random.default_rng(seed)
    t = np.linspace(0, np.pi, n // 2)
    upper = np.column_stack([np.cos(t), np.sin(t)])
    lower = np.column_stack([1 - np.cos(t), 0.5 - np.sin(t)])
    X = np.vstack([upper, lower]) + rng.normal(0, noise, size=(n, 2))
    y = np.concatenate([np.zeros(n // 2), np.ones(n // 2)])
    return X, y.reshape(-1, 1)

X_all, y_all = make_moons()
X_train, y_train = X_all[:240], y_all[:240]
X_val, y_val = X_all[240:], y_all[240:]

def forward(X, p, rng=None, training=False, drop=0.1):
    A1 = np.tanh(X @ p["W1"] + p["b1"])
    if training:                                   # dropout only during training
        mask = rng.random(A1.shape) < (1 - drop)
        A1 = A1 * mask / (1 - drop)
    P = 1 / (1 + np.exp(-(A1 @ p["W2"] + p["b2"])))
    return A1, P

def backward(X, Y, p, A1, P):
    n = X.shape[0]
    dZ2 = (P - Y) / n
    dZ1 = (dZ2 @ p["W2"].T) * (1 - A1 ** 2)
    return {"W1": X.T @ dZ1, "b1": dZ1.sum(0), "W2": A1.T @ dZ2, "b2": dZ2.sum(0)}

rng = np.random.default_rng(0)
params = {"W1": rng.normal(0, 0.5, (2, 16)), "b1": np.zeros(16),
          "W2": rng.normal(0, 0.5, (16, 1)), "b2": np.zeros(1)}
m = {k: np.zeros_like(v) for k, v in params.items()}
v = {k: np.zeros_like(p) for k, p in params.items()}
lr, b1, b2, eps = 0.01, 0.9, 0.999, 1e-8
step = 0

for epoch in range(20):
    order = rng.permutation(len(X_train))
    for start in range(0, len(order), 32):
        idx = order[start:start + 32]
        step += 1
        A1, P = forward(X_train[idx], params, rng, training=True)
        grads = backward(X_train[idx], y_train[idx], params, A1, P)
        for k in params:                           # Adam update, as in lesson 11
            m[k] = b1 * m[k] + (1 - b1) * grads[k]
            v[k] = b2 * v[k] + (1 - b2) * grads[k] ** 2
            m_hat = m[k] / (1 - b1 ** step)
            v_hat = v[k] / (1 - b2 ** step)
            params[k] = params[k] - lr * m_hat / (np.sqrt(v_hat) + eps)

_, P_val = forward(X_val, params, training=False)   # evaluation: no dropout
val_acc = np.mean((P_val > 0.5) == y_val)
print("validation accuracy:", round(float(val_acc), 3))
```

Read the evaluation line twice. `training=False` is the NumPy version of `model.eval()`, and it is why the validation result is stable from run to run, while the training batches are shuffled and dropped differently every time.

## Look inside one epoch

Three quick checks make the loop above concrete. The first shows how an epoch is cut into batches. The last batch is smaller, which is why the epoch loss has to be weighted.

```python run
n_train = len(X_train)
sizes = [min(32, n_train - s) for s in range(0, n_train, 32)]
print("batch sizes:", sizes, "| total examples:", sum(sizes))
```

The second check shows dropout doing its job during training and nothing at evaluation time.

```python run
p_check = dict(params)
a_train_1, _ = forward(X_val[:4], p_check, rng, training=True)
a_train_2, _ = forward(X_val[:4], p_check, rng, training=True)
a_eval_1, _ = forward(X_val[:4], p_check, training=False)
a_eval_2, _ = forward(X_val[:4], p_check, training=False)
print("training passes identical?", np.allclose(a_train_1, a_train_2))
print("evaluation passes identical?", np.allclose(a_eval_1, a_eval_2))
```

The third check compares the naive average of batch losses with the weighted one, using the batch sizes from the first cell.

```python run
batch_losses = np.linspace(0.9, 0.5, len(sizes))     # made-up losses, one per batch
naive = batch_losses.mean()
weighted = np.sum(batch_losses * np.array(sizes)) / sum(sizes)
print("naive average:", round(float(naive), 4), "| weighted:", round(float(weighted), 4))
```

The two averages differ because the last batch holds only 16 examples. The weighted average is the honest measure of the whole epoch, and the naive one quietly gives those 16 examples the same say as the 32 in each full batch.

## Challenge: mini-batches

The loader's job is to cover every example exactly once per epoch, in a new random order. Write that part yourself.

```python exercise id=batch-iterator title="Shuffled mini-batches"
# TODO: `iterate_batches(X, y, batch_size, rng)` returns a list of (X_batch, y_batch) pairs.
# Shuffle the examples with rng.permutation, then cut them into batches of batch_size.
# The last batch can be smaller. Every example must appear exactly once.
def iterate_batches(X, y, batch_size, rng):
    ...
--- solution
def iterate_batches(X, y, batch_size, rng):
    order = rng.permutation(len(X))
    return [(X[order[i:i + batch_size]], y[order[i:i + batch_size]]) for i in range(0, len(X), batch_size)]
--- test
X_t = np.arange(20, dtype=float).reshape(10, 2)
y_t = np.arange(10, dtype=float)
batches = iterate_batches(X_t, y_t, 4, np.random.default_rng(0))
assert batches is not None, "Replace the `...` in `iterate_batches` with code that returns the batches."
sizes = [len(yb) for _, yb in batches]
assert sizes == [4, 4, 2], f"Ten examples in batches of 4 should give sizes [4, 4, 2], but you returned {sizes}."
all_y = np.concatenate([yb for _, yb in batches])
assert sorted(all_y.tolist()) == list(range(10)), "Every example should appear exactly once across the batches."
for Xb, yb in batches:
    assert np.allclose(Xb[:, 0], yb * 2), "Each X row must stay paired with its label y when you shuffle."
--- hint
Create one shuffled index array with `rng.permutation(len(X))`, then slice the same indices out of both `X` and `y`.
--- hint
Use `range(0, len(X), batch_size)` to get the starting positions of each batch.
```

## Challenge: a weighted epoch loss

The last batch of an epoch is often smaller. Averaging the batch losses directly gives that small batch as much weight as a full one. The fix is a weighted average.

```python exercise id=weighted-loss title="The loss over a whole epoch"
# TODO: `epoch_loss(batch_losses, batch_sizes)` returns the mean loss over every example in the epoch.
# Each batch's loss is an average over its own examples, so weight it by its size.
def epoch_loss(batch_losses, batch_sizes):
    ...
--- solution
def epoch_loss(batch_losses, batch_sizes):
    return sum(l * n for l, n in zip(batch_losses, batch_sizes)) / sum(batch_sizes)
--- test
result = epoch_loss([1.0, 0.5], [4, 1])
assert result is not None, "Replace the `...` in `epoch_loss` with code that returns the average loss."
assert np.isclose(result, 0.9), f"With a batch of 4 at loss 1.0 and a batch of 1 at loss 0.5 the average over 5 examples is 0.9, but you returned {result!r}."
assert np.isclose(epoch_loss([2.0, 2.0, 2.0], [32, 32, 32]), 2.0), "Equal batches should give the same average."
--- hint
Multiply each batch loss by its batch size, add those up, and divide by the total number of examples.
--- hint
`sum(l * n for l, n in zip(batch_losses, batch_sizes)) / sum(batch_sizes)`.
```

## Debug the evaluation pass

Evaluation must be deterministic. This prediction function is supposed to switch dropout off when `training` is `False`, but it does not.

```python debug id=eval-dropout title="Turn dropout off at evaluation time"
import numpy as np

def predict(X, W, rng, training):
    H = np.maximum(0, X @ W)
    if True:                                       # bug: should depend on `training`
        H = H * (rng.random(H.shape) < 0.5) / 0.5
    return H

X = np.array([[1.0, 2.0], [3.0, -1.0]])
W = np.array([[1.0, 0.0], [0.5, 1.0]])
print(predict(X, W, np.random.default_rng(0), training=False))
--- solution
import numpy as np

def predict(X, W, rng, training):
    H = np.maximum(0, X @ W)
    if training:
        H = H * (rng.random(H.shape) < 0.5) / 0.5
    return H

X = np.array([[1.0, 2.0], [3.0, -1.0]])
W = np.array([[1.0, 0.0], [0.5, 1.0]])
print(predict(X, W, np.random.default_rng(0), training=False))
--- test
X_t = np.array([[1.0, 2.0], [3.0, -1.0]])
W_t = np.array([[1.0, 0.0], [0.5, 1.0]])
out1 = predict(X_t, W_t, np.random.default_rng(0), training=False)
out2 = predict(X_t, W_t, np.random.default_rng(99), training=False)
assert np.allclose(out1, np.maximum(0, X_t @ W_t)), "With training=False the output should be exactly the ReLU of X @ W, with no dropout."
assert np.allclose(out1, out2), "Evaluation should be deterministic. Changing the random seed must not change the output."
--- hint
The dropout line should only run when `training` is true. Put the `if` condition on `training`.
--- hint
Replace `if True:` with `if training:`.
```

## Predict the loss

```python predict id=predict-loss title="What is the epoch loss?"
batch_losses = [0.8, 0.2]
batch_sizes = [3, 1]
total = sum(l * n for l, n in zip(batch_losses, batch_sizes))
print(round(total / sum(batch_sizes), 2))
--- options
* 0.65
0.5
0.8
0.2
--- explain
The weighted sum is 0.8 × 3 + 0.2 × 1 = 2.6, and dividing by the four examples gives 0.65. A simple average of the two batch losses would give 0.5, which over-weights the single example in the small batch.
```

## Recap

- A PyTorch training loop is `zero_grad`, forward, loss, `backward` and `step`, in that order.
- `model.train()` and `model.eval()` switch dropout and batch norm between training and inference.
- Evaluate with `torch.no_grad()` and with dropout turned off, so results are repeatable.
- Average losses over examples, not over batches, so a small final batch does not dominate.

**Up next:** debugging training. When a run goes wrong, you need a systematic method for finding out why.
