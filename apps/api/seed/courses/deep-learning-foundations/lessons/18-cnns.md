A convolutional network stacks three kinds of layers: convolutions that detect patterns, non-linearities that combine them, and **pooling** layers that shrink the feature maps and keep the strongest responses. At the end, the features are flattened into a dense classifier. In this lesson you will implement pooling, handle images with several colour channels, and assemble a complete small CNN forward pass, watching the shape change at every stage.

## Pooling keeps the strongest response

**Max pooling** divides the feature map into small blocks, usually $2 \times 2$, and keeps the largest value in each. It halves the height and width, so later layers see a bigger picture with fewer numbers, and it makes the output less sensitive to a pattern moving by a pixel.

```python run
import numpy as np

fmap = np.array([
    [1.0, 3.0, 0.0, 2.0],
    [4.0, 2.0, 1.0, 0.0],
    [0.0, 1.0, 5.0, 2.0],
    [2.0, 0.0, 3.0, 1.0],
])

pooled = fmap.reshape(2, 2, 2, 2).max(axis=(1, 3))
print("input:", fmap.shape, "-> pooled:", pooled.shape)
print(pooled)
```

The `reshape` splits the map into blocks, and `max` over the block axes keeps one value per block. Read the output: each entry is the strongest response in its $2 \times 2$ region.

## Images have channels

A colour image has three channels, red, green and blue, so its shape is $(3, H, W)$. A convolution then has a kernel for each input channel, and it sums across them to make one output channel. Several kernels make several output channels.

```python run
from numpy.lib.stride_tricks import sliding_window_view

rng = np.random.default_rng(0)
image = rng.random((3, 8, 8))            # 3 channels, 8 × 8 pixels
kernels = rng.normal(size=(4, 3, 3, 3))  # 4 filters, each 3 channels × 3 × 3

windows = sliding_window_view(image, (3, 3, 3))   # every 3 × 3 patch in all 3 channels
out = np.einsum("hwcij,kcij->khw", windows[0], kernels)  # shape (4, 6, 6)
print("input:", image.shape, "| output:", out.shape)
```

The output has four channels, one per filter, and each is a 6 × 6 map. Adding channels does not change the spatial size; only the kernel size, padding and stride do.

## Count the parameters

Convolutions share weights across positions, so the parameter count depends on the number of filters and their size, not on the image size. Compare a convolution with a dense layer on the same image.

```python run
def conv_params(c_in, c_out, k):
    return c_out * (c_in * k * k + 1)

def dense_params(n_in, n_out):
    return n_in * n_out + n_out

print("conv 3 → 16 channels, 3×3:", conv_params(3, 16, 3), "parameters")
print("dense 32×32×3 → 16 units:", dense_params(32 * 32 * 3, 16), "parameters")
```

The dense layer needs 49,168 parameters, about a hundred times the convolution's 448, and it cannot share anything across positions. On larger images the gap grows with every pixel, while the convolution's count stays the same.

## A complete small CNN

Put the pieces together: a convolution, a ReLU, pooling, flattening and a dense output. Each line of this forward pass changes the shape, and the shapes are the part to read carefully.

```python run
def relu(z):
    return np.maximum(0, z)

def conv_layer(x, kernels, bias):
    windows = sliding_window_view(x, kernels.shape[1:])
    out = np.einsum("hwcij,kcij->khw", windows[0], kernels)
    return out + bias[:, None, None]

def max_pool(x):
    C, H, W = x.shape
    return x.reshape(C, H // 2, 2, W // 2, 2).max(axis=(2, 4))

x = rng.random((3, 8, 8))
K = rng.normal(0, 0.3, size=(4, 3, 3, 3))
b = np.zeros(4)
W_out = rng.normal(0, 0.3, size=(4 * 3 * 3, 10))

h1 = relu(conv_layer(x, K, b))            # (4, 6, 6)
h2 = max_pool(h1)                          # (4, 3, 3)
flat = h2.reshape(-1)                      # (36,)
logits = flat @ W_out                      # (10,)
print("conv:", h1.shape, "| pool:", h2.shape, "| flat:", flat.shape, "| logits:", logits.shape)
```

This is the whole architecture of a classic image classifier, in miniature. Real models repeat the convolution and pooling blocks many times, with more channels at each step, and end with the same flatten-and-classify step.

> **In the wild:** PyTorch's `nn.Conv2d` and `nn.MaxPool2d` do exactly these operations, with the batch dimension added in front. The shapes you have just tracked are the same ones you will read in PyTorch error messages.

## Challenge: max pooling

```python exercise id=max-pool title="2 × 2 max pooling"
# TODO: `max_pool2d(x)` takes a 2-D feature map with even height and width and returns the maximum of each
# non-overlapping 2 × 2 block. The output is half the height and half the width.
def max_pool2d(x):
    ...
--- solution
def max_pool2d(x):
    H, W = x.shape
    return x.reshape(H // 2, 2, W // 2, 2).max(axis=(1, 3))
--- test
fm = np.array([[1.0, 3.0, 0.0, 2.0], [4.0, 2.0, 1.0, 0.0], [0.0, 1.0, 5.0, 2.0], [2.0, 0.0, 3.0, 1.0]])
result = max_pool2d(fm)
assert result is not None, "Replace the `...` in `max_pool2d` with code that returns the pooled map."
assert result.shape == (2, 2), f"A 4 × 4 map pooled 2 × 2 should be 2 × 2, but you returned {result.shape}."
assert np.allclose(result, [[4.0, 2.0], [2.0, 5.0]]), f"The block maxima should be [[4, 2], [2, 5]], but you returned {result}."
big = np.arange(36, dtype=float).reshape(6, 6)
assert np.allclose(max_pool2d(big), [[7, 9, 11], [19, 21, 23], [31, 33, 35]]), "Check that it works on a larger map too."
--- hint
Reshape the map into blocks, with the block indices on their own axes. Then take the maximum over the two axes that index inside a block.
--- hint
`H, W = x.shape`, then `x.reshape(H // 2, 2, W // 2, 2).max(axis=(1, 3))`.
```

## Challenge: parameters of a convolution

```python exercise id=conv-params title="Count the parameters"
# TODO: `conv_param_count(c_in, c_out, k)` returns the number of learnable parameters of a convolution
# with c_out filters, each of size k × k over c_in input channels, including one bias per filter.
def conv_param_count(c_in, c_out, k):
    ...
--- solution
def conv_param_count(c_in, c_out, k):
    return c_out * (c_in * k * k + 1)
--- test
result = conv_param_count(3, 16, 3)
assert result is not None, "Replace the `...` in `conv_param_count` with code that returns the count."
assert result == 448, f"16 filters of 3 × 3 × 3 weights plus a bias each is 16 × 28 = 448, but you returned {result}."
assert conv_param_count(1, 1, 5) == 26, "One 5 × 5 filter on one channel has 25 weights and one bias."
--- hint
Each filter has `c_in * k * k` weights and one bias, and there are `c_out` filters.
--- hint
`return c_out * (c_in * k * k + 1)`.
```

## Debug the pooling axes

```python debug id=pool-axes title="Pool within each block"
fm = np.arange(16, dtype=float).reshape(4, 4)
H, W = fm.shape
pooled = fm.reshape(H // 2, 2, W // 2, 2).max(axis=(0, 2))    # bug: pooling over the block indices
print(pooled.shape)
print(pooled)
--- solution
fm = np.arange(16, dtype=float).reshape(4, 4)
H, W = fm.shape
pooled = fm.reshape(H // 2, 2, W // 2, 2).max(axis=(1, 3))
print(pooled.shape)
print(pooled)
--- test
assert pooled.shape == (2, 2), f"Pooling 4 × 4 into 2 × 2 blocks should give shape (2, 2), but you have {pooled.shape}. The max must run over the axes inside each block."
assert np.allclose(pooled, [[5.0, 7.0], [13.0, 15.0]]), f"The block maxima should be [[5, 7], [13, 15]], but you have {pooled}."
--- hint
In the reshape, the block index comes first and the position inside the block comes second. The axes inside a block are the ones of size 2.
--- hint
The axes of size 2 are axes 1 and 3. Replace `(0, 2)` with `(1, 3)`.
```

## Predict the flattened size

```python predict id=predict-flatten title="How many values reach the classifier?"
import numpy as np
x = np.zeros((8, 6, 6))
print(x.reshape(-1).shape)
--- options
* (288,)
(8, 36)
(6, 6)
(48,)
--- explain
Flattening keeps every value, so the total is 8 × 6 × 6 = 288. The result is a single vector of 288 numbers, which is the input the dense classifier expects.
```

## Recap

- Max pooling keeps the strongest response in each block, which halves the spatial size and adds tolerance to small shifts.
- Images have channels. A convolution sums over input channels and produces one output channel per filter.
- A CNN alternates convolution, non-linearity and pooling, then flattens into a dense classifier.
- Track the shapes at every stage. Most CNN bugs are shape bugs in disguise.

**Up next:** sequences. Recurrent networks process one step at a time and carry a memory forward, and you will see why that memory is hard to keep.
