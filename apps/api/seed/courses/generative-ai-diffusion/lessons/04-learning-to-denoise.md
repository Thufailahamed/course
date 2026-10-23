The denoiser is trained to predict the noise that was added to a training image. Given the noisy image and its step, the network outputs an estimate of ε. The loss is the mean squared error between the true noise and the prediction. Predicting noise, rather than the clean image, turns out to be stable across every noise level, which is why it became the standard parameterization.

## The optimal predictor in a simple case

When data and noise are both standard Gaussian, the best linear predictor of the noise from the noisy sample is a simple scaling. We can check this by simulation at one noise level.

```python run
import numpy as np

rng = np.random.default_rng(5)
abar = 0.25
s, c = np.sqrt(abar), np.sqrt(1 - abar)
x0 = rng.normal(size=20000)
eps = rng.normal(size=20000)
xt = s * x0 + c * eps
slope = np.sum(xt * eps) / np.sum(xt * xt)
print("fitted slope:", round(float(slope), 3), "| theory sqrt(1 - abar):", round(float(c), 3))
```

The fitted slope matches the theoretical coefficient, so the best linear noise predictor is c × x_t at this level.

## The training loss

The DDPM loss is the mean squared error between the true noise and the predicted noise, averaged over the batch.

```python run
def diffusion_loss(eps, eps_hat):
    return float(np.mean((eps - eps_hat) ** 2))

print("loss of predicting zero:", round(diffusion_loss(eps, np.zeros_like(eps)), 4))
print("loss of the fitted predictor:", round(diffusion_loss(eps, slope * xt), 4))
```

## Recovering the clean image

If you know the predicted noise, the clean image estimate follows from the forward equation. This is how samplers use the network output.

```python run
x0_hat = (xt - c * (slope * xt)) / s
print("mean squared error of the clean estimate:", round(float(np.mean((x0_hat - x0) ** 2)), 3))
```

## Gradient descent on the predictor

Training fits the parameters by gradient descent. This sketch fits a single scale on the same data.

```python run
a = 0.0
lr = 0.5
for step in range(200):
    grad = -2 * np.mean((eps - a * xt) * xt)
    a -= lr * grad
print("learned scale after 200 steps:", round(float(a), 3))
```

The full training step in PyTorch is shown below as static code. It is the NumPy loss above, applied to a batch.

```python
import torch
import torch.nn.functional as F

for x0 in dataloader:                              # clean images, shape (B, C, H, W)
    t = torch.randint(0, T, (x0.size(0),))
    eps = torch.randn_like(x0)
    a = sqrt_abar[t].view(-1, 1, 1, 1)
    b = sqrt_one_minus_abar[t].view(-1, 1, 1, 1)
    xt = a * x0 + b * eps
    loss = F.mse_loss(model(xt, t), eps)           # predict the noise
    optimizer.zero_grad()
    loss.backward()
    optimizer.step()
```

> **Pitfall:** the loss is averaged over random noise levels in each batch. A batch that samples only high-noise steps trains poorly, so the step t is drawn uniformly at random for every example.

> **In the wild:** the standard DDPM loss is a single line in the training loop, but nearly all of the engineering effort goes into data, the U-Net architecture and the time embedding.

## Challenge: noise target

```python exercise id=eps-target title="The noise that produced a noisy sample"
import numpy as np

# TODO: `eps_target(x_t, x0, abar)` returns the noise that produced x_t from x0: (x_t − sqrt(abar) × x0) / sqrt(1 − abar).
def eps_target(x_t, x0, abar):
    ...
--- solution
import numpy as np

def eps_target(x_t, x0, abar):
    return (np.asarray(x_t, dtype=float) - np.sqrt(abar) * np.asarray(x0, dtype=float)) / np.sqrt(1 - abar)
--- test
import numpy as np
x_t = np.array([0.5 + np.sqrt(0.75) * 2.0])
result = eps_target(x_t, np.array([1.0]), 0.25)
assert result is not None, "Replace the `...` in `eps_target` with code that returns the noise."
assert np.allclose(result, [2.0]), f"x_t was built from x0 = 1 and noise 2 with alpha-bar 0.25, so the noise is 2, but you returned {result}."
--- hint
Subtract the scaled clean image from x_t, then divide by the noise coefficient.
--- hint
`(x_t - np.sqrt(abar) * x0) / np.sqrt(1 - abar)`.
```

## Challenge: clean estimate from noise

```python exercise id=x0-from-eps title="Recover the clean image from the predicted noise"
import numpy as np

# TODO: `x0_from_eps(x_t, eps, abar)` returns (x_t − sqrt(1 − abar) × eps) / sqrt(abar).
def x0_from_eps(x_t, eps, abar):
    ...
--- solution
import numpy as np

def x0_from_eps(x_t, eps, abar):
    return (np.asarray(x_t, dtype=float) - np.sqrt(1 - abar) * np.asarray(eps, dtype=float)) / np.sqrt(abar)
--- test
import numpy as np
x_t = np.array([0.5 + np.sqrt(0.75) * 2.0])
result = x0_from_eps(x_t, np.array([2.0]), 0.25)
assert result is not None, "Replace the `...` in `x0_from_eps` with code that returns the estimate."
assert np.allclose(result, [1.0]), f"The clean image was 1, so the estimate should be 1, but you returned {result}."
--- hint
This is the forward equation solved for x0.
--- hint
Divide by `np.sqrt(abar)` after subtracting the noise term.
```

## Debug: dividing by the wrong coefficient

The noise target should divide by sqrt(1 − abar), but the code divides by sqrt(abar).

```python debug id=eps-coefficient title="Divide the noise by the noise coefficient"
import numpy as np

abar = 0.25
x0 = 1.0
xt = 0.5 + np.sqrt(0.75) * 2.0
eps = (xt - np.sqrt(abar) * x0) / np.sqrt(abar)       # bug: the divisor should be sqrt(1 - abar)
print("eps:", round(float(eps), 4))
--- solution
import numpy as np

abar = 0.25
x0 = 1.0
xt = 0.5 + np.sqrt(0.75) * 2.0
eps = (xt - np.sqrt(abar) * x0) / np.sqrt(1 - abar)
print("eps:", round(float(eps), 4))
--- test
assert abs(eps - 2.0) < 1e-9, f"The noise was 2, but the code gives {eps:.4f}. The divisor is the noise coefficient, sqrt(1 − abar)."
--- hint
The noise was scaled by sqrt(1 − abar) when it was added.
--- hint
Replace `np.sqrt(abar)` in the divisor.
```

## Predict the loss

```python predict id=predict-mse title="What is the loss of predicting zero for the target [1, -1]?"
import numpy as np
print(float(np.mean((np.array([1.0, -1.0]) - 0.0) ** 2)))
--- options
* 1.0
0.0
2.0
0.5
--- explain
The squared errors are 1 and 1, so their mean is 1.
```

## Recap

- The denoiser predicts the noise, and the training loss is the mean squared error of that prediction.
- The optimal prediction at each noise level is recoverable from the forward equation.
- Noise targets and clean estimates are two views of the same relation.

**Up next:** running the reverse process to generate samples.
