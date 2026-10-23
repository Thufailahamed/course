Segmentation needs a label for every pixel, but a classifier's deep features are small. U-Net solves this with two halves. The encoder downsamples, which builds context and receptive field. The decoder upsamples back to full resolution, and skip connections copy detail from the encoder straight across. This lesson builds the three operations that make the design work.

## Downsampling and upsampling

A 2 by 2 max pool keeps the largest value in each block, halving the size. Nearest-neighbour upsampling repeats each value, doubling it again.

```python run
import numpy as np

x = np.arange(16).reshape(4, 4)
pooled = x.reshape(2, 2, 2, 2).max(axis=(1, 3))
upsampled = np.repeat(np.repeat(pooled, 2, axis=0), 2, axis=1)
print("pooled:\n", pooled)
print("upsampled shape:", upsampled.shape)
```

## Skip connections

The decoder concatenates the encoder features of the same resolution along the channel axis. The decoder then sees both the context from deep layers and the fine detail from shallow ones.

```python run
enc = np.zeros((4, 4, 3))   # encoder features with 3 channels
dec = np.ones((4, 4, 3))    # decoder features after upsampling, with 3 channels
merged = np.concatenate([enc, dec], axis=-1)
print("merged shape:", merged.shape)
```

## Dice loss

The Dice coefficient is twice the overlap of prediction and target divided by the sum of their sizes. It is 1 for a perfect match, and its complement is a loss that is common for small foreground classes.

```python run
def dice_loss(p, g):
    return 1 - 2 * np.sum(p * g) / (np.sum(p) + np.sum(g))

pred_mask = np.array([0.9, 0.8, 0.1, 0.0])
true_mask = np.array([1.0, 1.0, 0.0, 0.0])
print("dice loss:", round(float(dice_loss(pred_mask, true_mask)), 4))
```

## Tracking the resolution

Each encoder level halves the resolution, so a 128 pixel input reaches an 8 pixel bottleneck after four levels.

```python run
size = 128
for level in range(4):
    size //= 2
print("bottleneck size after four 2x poolings:", size)
```

The complete U-Net is shown below as static PyTorch code for you to run locally. It follows the same structure as the NumPy pieces.

```python
import torch
import torch.nn as nn

def block(c_in, c_out):
    return nn.Sequential(
        nn.Conv2d(c_in, c_out, 3, padding=1), nn.ReLU(),
        nn.Conv2d(c_out, c_out, 3, padding=1), nn.ReLU(),
    )

class TinyUNet(nn.Module):
    def __init__(self, n_classes):
        super().__init__()
        self.enc1 = block(3, 32)
        self.pool = nn.MaxPool2d(2)
        self.enc2 = block(32, 64)
        self.up = nn.ConvTranspose2d(64, 32, 2, stride=2)
        self.dec1 = block(64, 32)        # 32 upsampled + 32 skip channels
        self.head = nn.Conv2d(32, n_classes, 1)

    def forward(self, x):
        s1 = self.enc1(x)
        s2 = self.enc2(self.pool(s1))
        d1 = self.dec1(torch.cat([self.up(s2), s1], dim=1))
        return self.head(d1)
```

> **Pitfall:** skip connections only line up when the input size is divisible by the number of pooling steps. An input of 100 pixels with four 2× poolings does not return to 100 after upsampling, so pad the input to a multiple of 16 first.

> **In the wild:** U-Net and its variants segment cells, organs, roads and crops. The skip connections are why they work with little training data: fine boundaries come straight from the early layers.

## Challenge: max pool

```python exercise id=max-pool title="2 × 2 max pooling"
import numpy as np

# TODO: `max_pool_2x2(x)` takes a 2-D array with even dimensions and returns the maximum of each 2 × 2 block.
def max_pool_2x2(x):
    ...
--- solution
import numpy as np

def max_pool_2x2(x):
    x = np.asarray(x)
    H, W = x.shape
    return x.reshape(H // 2, 2, W // 2, 2).max(axis=(1, 3))
--- test
import numpy as np
result = max_pool_2x2(np.arange(16).reshape(4, 4))
assert result is not None, "Replace the `...` in `max_pool_2x2` with code that returns the pooled array."
assert result.tolist() == [[5, 7], [13, 15]], f"The block maxima of a 4 × 4 arange are [[5, 7], [13, 15]], but you returned {result.tolist()}."
--- hint
Reshape into blocks with axes for the row within the block and the column within the block, then take the maximum over those two axes.
--- hint
`x.reshape(H // 2, 2, W // 2, 2).max(axis=(1, 3))`.
```

## Challenge: Dice loss

```python exercise id=dice-loss title="Dice loss for a soft mask"
import numpy as np

# TODO: `dice_loss(p, g)` returns 1 − 2 × Σ(p × g) / (Σp + Σg) for two arrays of the same shape.
def dice_loss(p, g):
    ...
--- solution
import numpy as np

def dice_loss(p, g):
    p = np.asarray(p, dtype=float)
    g = np.asarray(g, dtype=float)
    return 1 - 2 * np.sum(p * g) / (np.sum(p) + np.sum(g))
--- test
import numpy as np
result = dice_loss(np.array([1.0, 1.0, 0.0]), np.array([1.0, 0.0, 0.0]))
assert result is not None, "Replace the `...` in `dice_loss` with code that returns the loss."
assert abs(result - (1 - 2 / 3)) < 1e-9, f"The overlap is 1, the sums are 2 and 1, so the loss is 1 − 2/3, but you returned {result}."
assert abs(dice_loss(np.array([1.0, 0.0]), np.array([1.0, 0.0]))) < 1e-9, "A perfect match has a loss of zero."
--- hint
Compute the overlap with `np.sum(p * g)`, and the sizes with `np.sum(p)` and `np.sum(g)`.
--- hint
`return 1 - 2 * np.sum(p * g) / (np.sum(p) + np.sum(g))`.
```

## Debug: concatenating on the wrong axis

The skip connection should join the two feature maps along the channel axis, giving 6 channels, but the concatenation runs along the height.

```python debug id=concat-axis title="Join skip features along the channel axis"
import numpy as np

enc = np.zeros((4, 4, 3))
dec = np.ones((4, 4, 3))
skip = np.concatenate([enc, dec], axis=0)     # bug: axis 0 is the height
print("skip shape:", skip.shape)
--- solution
import numpy as np

enc = np.zeros((4, 4, 3))
dec = np.ones((4, 4, 3))
skip = np.concatenate([enc, dec], axis=-1)
print("skip shape:", skip.shape)
--- test
assert skip.shape == (4, 4, 6), f"Two maps with 3 channels each should join to (4, 4, 6), but the code gives {skip.shape}. Channels are the last axis."
--- hint
In an (H, W, C) array the channel axis is the last one.
--- hint
Use `axis=-1`.
```

## Predict the bottleneck size

```python predict id=predict-unet title="How large is a 32 by 32 feature map after one 2 by 2 max pool?"
print(32 // 2)
--- options
* 16
8
32
64
--- explain
A 2 × 2 pool halves each side, so 32 becomes 16.
```

## Recap

- Max pooling halves the resolution, and upsampling restores it.
- Skip connections concatenate encoder features along the channel axis.
- Dice loss measures overlap directly and is well suited to small foreground regions.

**Up next:** vision transformers, which replace the convolutional stack with patches and attention.
