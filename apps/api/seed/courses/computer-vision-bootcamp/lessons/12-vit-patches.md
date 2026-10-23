A vision transformer does not slide filters over the image. It cuts the image into square patches, turns each patch into a vector, and treats the patches as a sequence of tokens for a standard transformer. Once the patches are tokens, attention lets every patch look at every other patch.

## Cutting an image into patches

A 4 by 4 patch grid on an 8 by 8 image takes four blocks of 16 pixels. Reshaping and transposing puts each block's pixels in one row.

```python run
import numpy as np

img = np.arange(64).reshape(8, 8)
p = 4
patches = img.reshape(8 // p, p, 8 // p, p).transpose(0, 2, 1, 3).reshape(-1, p * p)
print("patches shape:", patches.shape)
print("first patch:", patches[0])
```

## Sequence length

A 224 by 224 image cut into 16 by 16 patches gives 196 tokens, and a class token adds one more.

```python run
def seq_len(H, W, p):
    return (H // p) * (W // p) + 1

print("ViT-B/16 on 224 x 224:", seq_len(224, 224, 16))
print("the same image with 32 pixel patches:", seq_len(224, 224, 32))
```

Larger patches mean fewer tokens and cheaper attention, but each token carries less spatial detail.

## Linear patch embedding

Each flattened patch is multiplied by a learned matrix to produce a token of the model's width.

```python run
rng = np.random.default_rng(0)
E = rng.normal(0, 0.02, size=(p * p, 8))    # project each 16-pixel patch to 8 dimensions
tokens = patches @ E
print("token matrix shape:", tokens.shape)
```

## The class token

A learned class token is prepended to the sequence. After the transformer, its output is used for classification.

```python run
cls = np.zeros((1, 8))
seq = np.vstack([cls, tokens])
print("sequence with class token:", seq.shape)
```

The full ViT is shown below as static PyTorch code, which uses the same patching and embedding steps.

```python
import torch
import torch.nn as nn

class PatchEmbed(nn.Module):
    def __init__(self, patch=16, dim=768):
        super().__init__()
        self.proj = nn.Conv2d(3, dim, kernel_size=patch, stride=patch)

    def forward(self, x):                       # x: (B, 3, H, W)
        x = self.proj(x)                        # (B, dim, H/p, W/p)
        return x.flatten(2).transpose(1, 2)     # (B, N, dim)
```

> **Pitfall:** a ViT trained on a small dataset from scratch usually loses to a CNN, because it lacks the locality built into convolutions. Pretrained ViTs or hybrid models are the normal choice.

> **In the wild:** ViT backbones are used in detection and segmentation pipelines, often after pretraining on large image-text collections.

## Challenge: patchify

```python exercise id=patchify title="Cut an image into flattened patches"
import numpy as np

# TODO: `patchify(img, p)` takes a square 2-D image with sides divisible by p and returns an array with one row per patch.
# Patches are ordered row by row, and each row holds the p × p pixels of that patch in row-major order.
def patchify(img, p):
    ...
--- solution
import numpy as np

def patchify(img, p):
    img = np.asarray(img)
    H, W = img.shape
    return img.reshape(H // p, p, W // p, p).transpose(0, 2, 1, 3).reshape(-1, p * p)
--- test
import numpy as np
result = patchify(np.arange(16).reshape(4, 4), 2)
assert result is not None, "Replace the `...` in `patchify` with code that returns the patches."
assert result.shape == (4, 4), f"A 4 × 4 image with 2 × 2 patches gives 4 patches of 4 pixels, but the shape is {result.shape}."
assert result[0].tolist() == [0, 1, 4, 5], f"The top-left patch is 0, 1, 4 and 5, but the first row is {result[0].tolist()}."
assert result[3].tolist() == [10, 11, 14, 15], f"The bottom-right patch is 10, 11, 14 and 15, but the last row is {result[3].tolist()}."
--- hint
Split each axis into (blocks, within-block), then move the two block axes to the front before flattening.
--- hint
Use `transpose(0, 2, 1, 3)` before the final reshape.
```

## Challenge: sequence length

```python exercise id=seq-len title="Number of tokens for an image"
# TODO: `sequence_length(H, W, p)` returns the number of tokens a ViT produces for an H × W image with p × p patches,
# including one class token.
def sequence_length(H, W, p):
    ...
--- solution
def sequence_length(H, W, p):
    return (H // p) * (W // p) + 1
--- test
result = sequence_length(224, 224, 16)
assert result is not None, "Replace the `...` in `sequence_length` with code that returns the count."
assert result == 197, f"224 / 16 = 14 patches per side, so 196 patches plus a class token is 197, but you returned {result}."
assert sequence_length(32, 32, 8) == 17, "Four patches per side give 16 patches plus the class token, 17."
--- hint
Count the patches per side, multiply, and add one for the class token.
--- hint
`return (H // p) * (W // p) + 1`.
```

## Debug: forgetting to group the patches

This patchify should group pixels into 2 by 2 blocks, so the first row holds 0, 1, 4 and 5, but it flattens the image row by row instead.

```python debug id=flatten-patches title="Group the pixels into blocks before flattening"
import numpy as np

img = np.arange(16).reshape(4, 4)
p = 2
patches = img.reshape(-1, p * p)        # bug: this flattens rows, it does not group blocks
print("first patch:", patches[0])
--- solution
import numpy as np

img = np.arange(16).reshape(4, 4)
p = 2
patches = img.reshape(2, p, 2, p).transpose(0, 2, 1, 3).reshape(-1, p * p)
print("first patch:", patches[0])
--- test
assert patches[0].tolist() == [0, 1, 4, 5], f"The first patch is the top-left 2 × 2 block, [0, 1, 4, 5], but the code gives {patches[0].tolist()}. Split rows and columns into blocks before flattening."
--- hint
The first patch needs pixels from two rows, so they cannot be the first four numbers of the flat array.
--- hint
Use the same reshape and transpose as in the patchify exercise.
```

## Predict the sequence length

```python predict id=predict-seq title="How many tokens does a 96 by 96 image give with 16 by 16 patches, including the class token?"
print((96 // 16) ** 2 + 1)
--- options
* 37
36
97
6
--- explain
There are 6 patches per side, so 36 patches, plus one class token, gives 37.
```

## Recap

- A ViT turns an image into a sequence of patch tokens, with a class token at the front.
- Patch embedding is a linear map of each flattened patch, or equivalently a strided convolution.
- The token count is the number of patches plus one, so patch size controls the cost.

**Up next:** CLIP, which compares images and text in one embedding space.
