Training a transformer is sensitive to how fast the weights move. At the start, the gradients are noisy and the weights are random, so large steps can be destructive. Later, smaller steps refine the solution. A **learning-rate schedule** sets the step size over time: a short warmup, then a smooth decay. Separately, **gradient accumulation** lets a large effective batch size fit in memory by summing gradients from several small batches before one update.

## Warmup and cosine decay

Warmup raises the learning rate linearly from near zero to its peak over the first steps. Cosine decay then lowers it smoothly towards a floor.

$$
\eta(t) = \begin{cases} \eta_{\max}\,\dfrac{t+1}{T_w} & t < T_w \\[2mm] \eta_{\min} + \tfrac{1}{2}(\eta_{\max} - \eta_{\min})\bigl(1 + \cos(\pi p)\bigr), & p = \dfrac{t - T_w}{T - T_w} \end{cases}
$$

```python run
import numpy as np

def lr_schedule(step, max_lr=3e-4, warmup=10, total=100, min_lr=3e-5):
    if step < warmup:
        return max_lr * (step + 1) / warmup
    progress = (step - warmup) / (total - warmup)
    return min_lr + 0.5 * (max_lr - min_lr) * (1 + np.cos(np.pi * progress))

for step in [0, 5, 9, 10, 55, 99]:
    print(f"step {step:>3}: learning rate {lr_schedule(step):.6f}")
```

The rate rises over the first ten steps, peaks at step ten, and falls smoothly to the floor by the end. The warmup protects the early, noisy updates, and the decay lets the model settle.

## Gradient accumulation

If one batch of 512 examples does not fit in memory, process four batches of 128, add their gradients, and update once. For a mean loss, the correct combination weights each batch by its size.

```python run
rng = np.random.default_rng(0)
X = rng.normal(size=(512, 3))
y = X @ np.array([1.0, -2.0, 0.5]) + rng.normal(0, 0.1, 512)
w = np.zeros(3)

def grad(Xb, yb, w):
    return 2 * Xb.T @ (Xb @ w - yb) / len(yb)

full = grad(X, y, w)
accumulated = np.zeros(3)
for start in range(0, 512, 128):
    Xb, yb = X[start:start + 128], y[start:start + 128]
    accumulated += grad(Xb, yb, w) * len(yb) / 512     # weight each batch by its share
print("full batch:  ", np.round(full, 4))
print("accumulated: ", np.round(accumulated, 4))
```

The accumulated gradient matches the full-batch gradient, so the large effective batch comes at the memory cost of only one small batch.

> **Pitfall:** averaging the four batch gradients without weighting is correct only when every batch has the same size. Weighting by size is always right.

> **In the wild:** the schedule in large language-model training is typically warmup followed by cosine or linear decay, and accumulation is how training runs use batches far bigger than a single device could hold.

Plotting the schedule shows the whole shape at once: the ramp, the peak and the long decay.

```python run
import matplotlib.pyplot as plt

steps_plot = np.arange(100)
rates = [lr_schedule(s) for s in steps_plot]
fig, ax = plt.subplots(figsize=(5, 3))
ax.plot(steps_plot, rates)
ax.set_xlabel("step"); ax.set_ylabel("learning rate"); ax.grid(alpha=0.3)
plt.show()
```

## Challenge: the warmup and cosine schedule

```python exercise id=lr-schedule title="Learning-rate schedule"
import numpy as np

# TODO: `lr_at(step, max_lr, warmup, total, min_lr)` returns the learning rate for a step (counting from 0). During
# warmup (step < warmup) it rises linearly to max_lr: max_lr × (step + 1) / warmup. After warmup it follows cosine decay
# from max_lr at step `warmup` to min_lr at step `total`, and stays at min_lr after that.
def lr_at(step, max_lr, warmup, total, min_lr):
    ...
--- solution
import numpy as np

def lr_at(step, max_lr, warmup, total, min_lr):
    if step < warmup:
        return max_lr * (step + 1) / warmup
    progress = min((step - warmup) / (total - warmup), 1.0)
    return min_lr + 0.5 * (max_lr - min_lr) * (1 + np.cos(np.pi * progress))
--- test
assert abs(lr_at(0, 1.0, 4, 100, 0.0) - 0.25) < 1e-9, "At step 0 of a 4-step warmup the rate is max_lr × 1/4 = 0.25."
assert abs(lr_at(3, 1.0, 4, 100, 0.0) - 1.0) < 1e-9, "The peak is reached at the end of warmup, when step + 1 = warmup."
assert abs(lr_at(4, 1.0, 4, 100, 0.0) - 1.0) < 1e-9, "Right after warmup the cosine starts at the maximum."
assert abs(lr_at(100, 1.0, 4, 100, 0.1) - 0.1) < 1e-9, "At the last step the rate is the minimum."
assert abs(lr_at(500, 1.0, 4, 100, 0.1) - 0.1) < 1e-9, "After the schedule ends the rate stays at the minimum."
--- hint
Handle the warmup case first with a linear ramp. For the cosine part, compute the progress as a fraction between warmup and total, and cap it at one.
--- hint
`0.5 * (max_lr - min_lr) * (1 + np.cos(np.pi * progress))` added to `min_lr`.
```

Unequal micro-batches make the difference between a correct and an incorrect average visible. Compare the naive mean of the batch gradients with the size-weighted one.

```python run
g_list = [np.array([1.0]), np.array([5.0])]
sizes_list = [1, 9]
naive_mean = np.mean(g_list, axis=0)
weighted_mean = sum(g * n for g, n in zip(g_list, sizes_list)) / sum(sizes_list)
print("naive mean:", naive_mean, "| size-weighted mean:", weighted_mean)
```

## Challenge: accumulate gradients

```python exercise id=accumulate-grads title="Weighted gradient accumulation"
import numpy as np

# TODO: `accumulate_gradient(grads, sizes)` takes a list of gradient vectors, one per micro-batch, and the number of
# examples in each micro-batch. Return the mean gradient over all examples: the sum of grad × size divided by the total size.
def accumulate_gradient(grads, sizes):
    ...
--- solution
import numpy as np

def accumulate_gradient(grads, sizes):
    total = sum(np.asarray(g, dtype=float) * n for g, n in zip(grads, sizes))
    return total / sum(sizes)
--- test
import numpy as np
result = accumulate_gradient([np.array([1.0, 0.0]), np.array([4.0, 4.0])], [1, 3])
assert result is not None, "Replace the `...` in `accumulate_gradient` with code that returns the mean gradient."
assert np.allclose(result, [13 / 4, 3.0]), f"The weighted sum is [1, 0] × 1 + [4, 4] × 3 = [13, 12], divided by 4 examples, giving [3.25, 3]. You returned {result}."
assert np.allclose(accumulate_gradient([np.array([2.0])] * 3, [5, 5, 5]), [2.0]), "Equal batches with equal gradients give that gradient."
--- hint
Multiply each batch gradient by its batch size, add them up, and divide by the total number of examples.
--- hint
`sum(np.asarray(g) * n for g, n in zip(grads, sizes)) / sum(sizes)`.
```

## Debug the warmup step

This warmup is meant to start from a small learning rate, but at step zero it gives exactly zero, so the first update does nothing.

```python debug id=warmup-zero title="Start warmup above zero"
import numpy as np

def warmup_lr(step, max_lr=1.0, warmup=4):
    return max_lr * step / warmup              # bug: step 0 gives a learning rate of zero

print("first learning rate:", warmup_lr(0))
--- solution
import numpy as np

def warmup_lr(step, max_lr=1.0, warmup=4):
    return max_lr * (step + 1) / warmup

print("first learning rate:", warmup_lr(0))
--- test
assert warmup_lr(0) > 0, f"The first step must use a positive learning rate, but it is {warmup_lr(0)}. Count the warmup from one."
assert abs(warmup_lr(3) - 1.0) < 1e-9, "The peak should be reached on the last warmup step."
--- hint
Steps begin at zero, so the warmup formula needs to count from one.
--- hint
Use `(step + 1) / warmup`.
```

## Predict the rate

```python predict id=predict-lr title="What is the learning rate at the first step of a 5-step warmup to 0.5?"
print(0.5 * (0 + 1) / 5)
--- options
* 0.1
0.5
0.0
0.05
--- explain
The first step of a linear warmup is one fifth of the peak, so 0.5 / 5 = 0.1.

```