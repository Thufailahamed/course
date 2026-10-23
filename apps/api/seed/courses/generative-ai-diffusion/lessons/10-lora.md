Fine-tuning every weight of a large diffusion model needs a large amount of memory and produces a full copy of the model for each new style. LoRA freezes the pretrained weights and learns a low-rank change instead. For a weight matrix W, the adapted weight is W + (alpha / r) B A, where A and B are thin matrices of rank r. Only A and B are trained, and they are small enough to store and share.

## Parameter counts

A full d by k matrix has d × k parameters. The LoRA factors have r × (d + k), and for small r that is far fewer.

```python run
import numpy as np

d, k, r = 768, 768, 8
full = d * k
lora = r * (d + k)
print("full parameters:", full, "| LoRA parameters:", lora)
print("LoRA share of the full matrix:", round(lora / full, 4))
```

## Starting from the pretrained model

B is initialized to zero, so the update is zero at the start and the adapted model is identical to the pretrained one.

```python run
rng = np.random.default_rng(9)
W = rng.normal(size=(4, 4))
A = rng.normal(size=(2, 4))
B = np.zeros((4, 2))
print("update at initialization is zero:", np.allclose(B @ A, 0.0))
```

## The update has rank r

The product B A has rank at most r, which is what makes it a low-rank change.

```python run
B = rng.normal(size=(4, 2))
print("rank of the update:", np.linalg.matrix_rank(B @ A))
```

## The scaling alpha over r

The factor alpha over r keeps the size of the update stable when the rank changes, so a tuned learning rate still works after the rank is changed.

```python run
for rank, alpha in [(2, 4), (4, 4), (4, 8)]:
    print(f"rank {rank}, alpha {alpha}: scale {alpha / rank}")
```

A LoRA wrapper around a pretrained linear layer is shown below as static PyTorch code. It implements the update W + (alpha / r) B A exactly as in the NumPy lesson.

```python
import torch
import torch.nn as nn

class LoRALinear(nn.Module):
    def __init__(self, base: nn.Linear, r=8, alpha=16):
        super().__init__()
        self.base = base
        for p in self.base.parameters():
            p.requires_grad = False                # freeze the pretrained weights
        self.A = nn.Parameter(torch.randn(r, base.in_features) * 0.01)
        self.B = nn.Parameter(torch.zeros(base.out_features, r))
        self.scale = alpha / r

    def forward(self, x):
        return self.base(x) + self.scale * (x @ self.A.T @ self.B.T)
```

> **Pitfall:** a LoRA trained on a few images can memorize them and ignore the prompt. Watch for this with validation prompts, and stop training before the adapter overfits.

> **In the wild:** LoRA adapters for diffusion models are small files, often a few megabytes, that people share to add a style or a subject to a base model.

## Challenge: LoRA parameter count

```python exercise id=lora-params title="Parameters of a LoRA adapter"
# TODO: `lora_params(d, k, r)` returns the number of parameters of a LoRA adapter for a d × k matrix with rank r: r × (d + k).
def lora_params(d, k, r):
    ...
--- solution
def lora_params(d, k, r):
    return r * (d + k)
--- test
result = lora_params(768, 768, 8)
assert result is not None, "Replace the `...` in `lora_params` with code that returns the count."
assert result == 12288, f"The adapter has 8 × 1536 = 12288 parameters, but you returned {result}."
assert lora_params(4, 6, 1) == 10, "A rank-one adapter for a 4 × 6 matrix has 10 parameters."
--- hint
The factors are of sizes d × r and r × k.
--- hint
`return r * (d + k)`.
```

## Challenge: LoRA update

```python exercise id=lora-update title="Apply a LoRA update"
import numpy as np

# TODO: `lora_update(W, A, B, alpha, r)` returns W + (alpha / r) × (B @ A).
def lora_update(W, A, B, alpha, r):
    ...
--- solution
import numpy as np

def lora_update(W, A, B, alpha, r):
    return np.asarray(W, dtype=float) + (alpha / r) * (np.asarray(B, dtype=float) @ np.asarray(A, dtype=float))
--- test
import numpy as np
result = lora_update(np.zeros((2, 2)), np.ones((1, 2)), np.ones((2, 1)), alpha=2, r=1)
assert result is not None, "Replace the `...` in `lora_update` with code that returns the adapted weight."
assert np.allclose(result, 2.0), f"B @ A is all ones and the scale is 2 / 1 = 2, so every entry should be 2, but you returned {result}."
assert np.allclose(lora_update(np.ones((2, 2)), np.zeros((1, 2)), np.ones((2, 1)), alpha=2, r=1), 1.0), "With a zero A the update adds nothing."
--- hint
Multiply B and A, scale by alpha over r, and add to W.
--- hint
`W + (alpha / r) * (B @ A)`.
```

## Debug: the missing scale

The adapter's update should be scaled by alpha over r, but the code adds the raw product.

```python debug id=lora-scale title="Scale the LoRA update"
import numpy as np

W = np.zeros((2, 2))
A = np.ones((1, 2))
B = np.ones((2, 1))
alpha, r = 2, 1
W_new = W + B @ A                    # bug: the update is not scaled by alpha / r
print(W_new)
--- solution
import numpy as np

W = np.zeros((2, 2))
A = np.ones((1, 2))
B = np.ones((2, 1))
alpha, r = 2, 1
W_new = W + (alpha / r) * (B @ A)
print(W_new)
--- test
assert np.allclose(W_new, 2.0), f"With alpha 2 and rank 1 the update is scaled by 2, so each entry should be 2, but the code gives {W_new[0, 0]}. Multiply by alpha / r."
--- hint
The scale is alpha divided by r, which is 2 here.
--- hint
Write `W + (alpha / r) * (B @ A)`.
```

## Predict the adapter size

```python predict id=predict-lora title="How many parameters does a rank-4 LoRA have for a 100 by 100 matrix?"
print(4 * (100 + 100))
--- options
* 800
400
10000
40
--- explain
A rank-4 adapter has 4 × (100 + 100) = 800 parameters.
```

## Recap

- LoRA learns a low-rank update B A to a frozen weight, with B starting at zero.
- The adapter has r × (d + k) parameters, far fewer than the full matrix.
- The factor alpha over r keeps the update's scale stable across ranks.

**Up next:** a DreamBooth recipe that combines a subject with prior preservation.
