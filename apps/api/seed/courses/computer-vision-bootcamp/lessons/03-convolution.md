A convolution slides a small kernel over an image and computes a weighted sum at each position. A kernel of fixed numbers can detect edges. A convolutional network learns many kernels from data, and this one operation is the core of almost every vision model.

## Sliding a kernel

The function below slides a kernel over an image without padding. The Sobel kernel responds to brightness that changes from left to right, so it lights up on vertical edges.

```python run
import numpy as np

def conv2d(img, k):
    """Valid cross-correlation: slide k over img with no padding."""
    H, W = img.shape
    kh, kw = k.shape
    out = np.zeros((H - kh + 1, W - kw + 1))
    for i in range(out.shape[0]):
        for j in range(out.shape[1]):
            out[i, j] = np.sum(img[i:i + kh, j:j + kw] * k)
    return out

img = np.array([[0, 0, 0, 9, 9],
                [0, 0, 0, 9, 9],
                [0, 0, 0, 9, 9],
                [0, 0, 0, 9, 9]], dtype=float)
sobel_x = np.array([[-1, 0, 1], [-2, 0, 2], [-1, 0, 1]], dtype=float)
print(conv2d(img, sobel_x))
```

The output is large only where the bright columns begin, which is the edge of the bright region.

## Output size

For an input of length n, kernel size k, padding p and stride s, the output has length floor((n + 2p − k) / s) + 1.

```python run
def out_size(n, k, p=0, s=1):
    return (n + 2 * p - k) // s + 1

for n, k, p, s in [(32, 3, 1, 1), (32, 3, 0, 1), (7, 3, 0, 2)]:
    print(f"input {n}, kernel {k}, padding {p}, stride {s} -> output {out_size(n, k, p, s)}")
```

## Padding keeps the size

Padding adds a border of zeros, so a 3 by 3 kernel can keep the output the same size as the input.

```python run
padded = np.pad(img, 1)
print("padded shape:", padded.shape, "| output shape:", conv2d(padded, sobel_x).shape, "| input shape:", img.shape)
```

## Blur with a box kernel

A kernel of equal weights averages each neighbourhood, which smooths noise.

```python run
box = np.ones((3, 3)) / 9.0
print(np.round(conv2d(img, box), 2))
```

> **Pitfall:** deep learning libraries call the operation convolution but compute cross-correlation, which does not flip the kernel. For learned kernels this makes no difference, so it is safe to ignore the distinction in practice.

> **In the wild:** stride-2 convolutions and pooling are how a network shrinks its feature maps as it goes deeper, trading spatial detail for a wider view.

## Challenge: output size

```python exercise id=out-size title="Output size of a convolution"
# TODO: `output_size(n, k, p, s)` returns the output length of a convolution over an input of length n, with kernel size k,
# padding p on each side and stride s: floor((n + 2p − k) / s) + 1.
def output_size(n, k, p, s):
    ...
--- solution
def output_size(n, k, p, s):
    return (n + 2 * p - k) // s + 1
--- test
result = output_size(32, 3, 1, 1)
assert result is not None, "Replace the `...` in `output_size` with code that returns the size."
assert result == 32, f"A 3 × 3 kernel with padding 1 keeps a 32-pixel input at 32, but you returned {result}."
assert output_size(7, 3, 0, 2) == 3, "Seven pixels, kernel 3, stride 2 and no padding give 3."
assert output_size(224, 7, 3, 2) == 112, "A 7 × 7 kernel with padding 3 and stride 2 halves 224 to 112."
--- hint
Add the padding on both sides, subtract the kernel size, divide by the stride with integer division, then add one.
--- hint
`return (n + 2 * p - k) // s + 1`.
```

## Challenge: valid convolution

```python exercise id=valid-conv title="Slide a kernel over an image"
import numpy as np

# TODO: `conv_valid(img, k)` returns the valid cross-correlation of a 2-D image with a 2-D kernel: each output value is the
# sum of the elementwise product of the kernel and the image patch under it, with no padding.
def conv_valid(img, k):
    ...
--- solution
import numpy as np

def conv_valid(img, k):
    img = np.asarray(img, dtype=float)
    k = np.asarray(k, dtype=float)
    kh, kw = k.shape
    H, W = img.shape
    out = np.zeros((H - kh + 1, W - kw + 1))
    for i in range(out.shape[0]):
        for j in range(out.shape[1]):
            out[i, j] = np.sum(img[i:i + kh, j:j + kw] * k)
    return out
--- test
import numpy as np
result = conv_valid(np.arange(9).reshape(3, 3), np.ones((2, 2)))
assert result is not None, "Replace the `...` in `conv_valid` with code that returns the output."
assert result.shape == (2, 2), f"A 3 × 3 image with a 2 × 2 kernel gives a 2 × 2 output, but you returned shape {result.shape}."
assert np.allclose(result, [[8, 12], [20, 24]]), f"The window sums are 8, 12, 20 and 24, but you returned {result.tolist()}."
--- hint
Loop over every top-left position, take the image window of the kernel's size, multiply elementwise by the kernel and sum.
--- hint
`out[i, j] = np.sum(img[i:i + kh, j:j + kw] * k)`.
```

## Debug: forgotten padding

This output size is supposed to keep a 32-pixel input at 32, but the padding is counted on one side only.

```python debug id=pad-term title="Count the padding on both sides"
n, k, p, s = 32, 3, 1, 1
out = (n + p - k) // s + 1      # bug: the padding appears on both sides, so it counts twice
print("output size:", out)
--- solution
n, k, p, s = 32, 3, 1, 1
out = (n + 2 * p - k) // s + 1
print("output size:", out)
--- test
assert out == 32, f"A 3 × 3 kernel with padding 1 keeps the size at 32, but the code gives {out}. Padding is added on both sides, so it enters as 2 × p."
--- hint
Each side of the image gets p pixels of padding.
--- hint
Use `n + 2 * p - k`.
```

## Predict the output size

```python predict id=predict-out title="How long is the output of a 10-pixel input with kernel 3 and stride 2?"
print((10 - 3) // 2 + 1)
--- options
* 4
3
5
7
--- explain
The window positions start at 0, 2, 4 and 6, and the last window ends at pixel 8, which fits. That gives 4 outputs.
```

## Recap

- A convolution computes a weighted sum over a sliding window, with the same kernel at every position.
- Output size depends on the input, kernel, padding and stride.
- Padding preserves spatial size, and stride shrinks it.

**Up next:** augmentation, which creates new training images from existing ones.
