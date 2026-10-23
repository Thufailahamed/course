A dense layer treats every pixel as an unrelated number. That is wasteful for images, where a pattern such as an edge or a corner means the same thing wherever it appears. A **convolution** solves this by sliding one small filter across the whole image and reusing its weights at every position. It is the operation at the heart of every image model, and this lesson builds it from the loops up.

## One filter, many positions

A convolution takes a small **kernel** (also called a filter), places it over a patch of the image, multiplies element by element, and sums. Then it slides one step and repeats. The result is a new image, a **feature map**, that shows where the pattern occurs.

```python run
import matplotlib.pyplot as plt

def corr2d(image, kernel):
    H, W = image.shape
    kh, kw = kernel.shape
    out = np.zeros((H - kh + 1, W - kw + 1))
    for i in range(out.shape[0]):
        for j in range(out.shape[1]):
            out[i, j] = np.sum(image[i:i + kh, j:j + kw] * kernel)
    return out

image = np.zeros((6, 8))
image[:, 4:] = 1.0                      # a bright region with a vertical edge
vertical_edge = np.array([[-1.0, 1.0]]) # responds where brightness steps up left to right

feature_map = corr2d(image, vertical_edge)
print("feature map shape:", feature_map.shape)
print(feature_map)
```

The feature map is zero everywhere except at the edge, where it is strongly positive. The same two numbers found the edge at every row, because the kernel does not care where the edge is.

Deep learning frameworks call this operation a convolution, although the strict mathematical convolution flips the kernel first. Frameworks do not flip, and the network learns whatever kernel is useful, so the difference does not matter in practice.

> **Under the hood:** the kernel's weights are the only parameters. A $3 \times 3$ kernel has nine weights and one bias, however large the image is. A dense layer mapping a $28 \times 28$ image to 100 units needs over 78,000.

## Look at what a kernel detects

Here are two kernels: one for horizontal edges, one for vertical. Apply both to a picture with a square in it.

```python run
square = np.zeros((10, 10))
square[3:7, 3:7] = 1.0

horizontal = np.array([[-1.0], [1.0]])
vertical = np.array([[-1.0, 1.0]])

fig, axes = plt.subplots(1, 3, figsize=(9, 3))
for ax, img, title in zip(axes, [square, corr2d(square, horizontal), corr2d(square, vertical)],
                          ["input", "horizontal edges", "vertical edges"]):
    ax.imshow(img, cmap="gray"); ax.set_title(title); ax.axis("off")
plt.show()
```

A network learns its kernels from data. The first layer of a trained image model typically learns edge and colour detectors very much like these.

Kernels do not have to find edges. A kernel of equal weights averages each patch, which smooths noise away:

```python run
blur = np.ones((3, 3)) / 9.0
noisy = np.random.default_rng(0).normal(0, 0.3, (8, 8))
smooth = corr2d(noisy, blur)
print("noise std before:", round(noisy.std(), 3), "| after 3 × 3 averaging:", round(smooth.std(), 3))
```

The same sliding operation can sharpen, blur or detect, depending only on the numbers in the kernel. Learning is the process of finding the numbers that help the task.

## Padding and stride control the output size

Each valid convolution shrinks the image, because the kernel cannot be centred on the border pixels. Two settings control the size:

- **Padding** $p$ adds a border of zeros, so the kernel can reach the edge.
- **Stride** $s$ is the step between kernel positions. A stride of 2 halves the output.

The output size along one dimension is

$$
\text{out} = \left\lfloor \frac{n + 2p - k}{s} \right\rfloor + 1
$$

where $n$ is the input size and $k$ the kernel size.

```python run
def out_size(n, k, s=1, p=0):
    return (n + 2 * p - k) // s + 1

for n, k, s, p in [(28, 5, 1, 0), (28, 3, 1, 1), (28, 3, 2, 1), (7, 3, 2, 0)]:
    print(f"input {n:>2}, kernel {k}, stride {s}, padding {p} -> output {out_size(n, k, s, p)}")
```

Padding of one with a $3 \times 3$ kernel keeps the size the same. Stride 2 halves it. You will use these settings constantly.

## Challenge: a valid convolution

```python exercise id=conv2d-valid title="Write a 2-D convolution"
# TODO: `conv2d_valid(image, kernel)` slides the kernel over every position where it fits completely
# inside the image (no padding), multiplies element by element and sums. Return the feature map.
def conv2d_valid(image, kernel):
    ...
--- solution
def conv2d_valid(image, kernel):
    H, W = image.shape
    kh, kw = kernel.shape
    out = np.zeros((H - kh + 1, W - kw + 1))
    for i in range(out.shape[0]):
        for j in range(out.shape[1]):
            out[i, j] = np.sum(image[i:i + kh, j:j + kw] * kernel)
    return out
--- test
img = np.arange(16, dtype=float).reshape(4, 4)
ker = np.array([[1.0, 2.0], [0.0, 1.0]])
result = conv2d_valid(img, ker)
assert result is not None, "Replace the `...` in `conv2d_valid` with code that returns the feature map."
assert result.shape == (3, 3), f"A 2 × 2 kernel on a 4 × 4 image gives a 3 × 3 map, but you returned shape {result.shape}."
expected = np.array([[img[i:i + 2, j:j + 2].ravel() @ ker.ravel() for j in range(3)] for i in range(3)])
assert np.allclose(result, expected), f"Each output should be the sum of the patch times the kernel. Expected {expected.tolist()}, but you returned {result.tolist()}."
assert np.isclose(result[0, 0], 7.0), "The top-left output should be 0·1 + 1·2 + 4·0 + 5·1 = 7."
--- hint
Loop over every top-left corner `(i, j)` where the kernel fits. Each output is the sum of the patch `image[i:i+kh, j:j+kw]` times the kernel.
--- hint
The output has `H - kh + 1` rows and `W - kw + 1` columns. Create it with `np.zeros` and fill it in.
```

## Challenge: the output size

```python exercise id=conv-output-size title="Output size of a convolution"
# TODO: `conv_out_size(n, k, stride, padding)` returns the output size along one dimension,
# using floor((n + 2 * padding - k) / stride) + 1.
def conv_out_size(n, k, stride, padding):
    ...
--- solution
def conv_out_size(n, k, stride, padding):
    return (n + 2 * padding - k) // stride + 1
--- test
result = conv_out_size(28, 5, 1, 0)
assert result is not None, "Replace the `...` in `conv_out_size` with code that returns the size."
assert result == 24, f"A 5 × 5 kernel on 28 pixels with no padding leaves 24 positions, but you returned {result}."
assert conv_out_size(32, 3, 2, 1) == 16, "Stride 2 with padding 1 on 32 pixels gives 16."
assert conv_out_size(7, 3, 2, 0) == 3, "Check the floor: (7 - 3) / 2 + 1 = 3."
--- hint
Add `2 * padding` to the input size, subtract the kernel size, divide by the stride, and add one.
--- hint
`return (n + 2 * padding - k) // stride + 1`. Integer division does the floor for you.
```

## Debug the missing last position

A common bug is a loop that stops one position early. This one builds a feature map that is missing its last row.

```python debug id=off-by-one title="Include the last position"
def conv_loop(image, kernel):
    H, W = image.shape
    kh, kw = kernel.shape
    out = np.zeros((H - kh + 1, W - kw + 1))
    for i in range(H - kh):              # bug: the last valid row is skipped
        for j in range(W - kw + 1):
            out[i, j] = np.sum(image[i:i + kh, j:j + kw] * kernel)
    return out

img = np.arange(12, dtype=float).reshape(3, 4)
print(conv_loop(img, np.ones((2, 2))))
--- solution
def conv_loop(image, kernel):
    H, W = image.shape
    kh, kw = kernel.shape
    out = np.zeros((H - kh + 1, W - kw + 1))
    for i in range(H - kh + 1):
        for j in range(W - kw + 1):
            out[i, j] = np.sum(image[i:i + kh, j:j + kw] * kernel)
    return out

img = np.arange(12, dtype=float).reshape(3, 4)
print(conv_loop(img, np.ones((2, 2))))
--- test
img_t = np.arange(12, dtype=float).reshape(3, 4)
out_t = conv_loop(img_t, np.ones((2, 2)))
assert out_t.shape == (2, 3), f"Three rows and four columns with a 2 × 2 kernel give a (2, 3) map, but you returned {out_t.shape}."
assert np.isclose(out_t[1, 2], 6 + 7 + 10 + 11), f"The bottom-right output should be the sum of its 2 × 2 patch, 34, but it is {out_t[1, 2]}. The last row must be computed."
--- hint
Compare the `range` in the outer loop with the `range` in the inner loop. Both should go up to the last valid position.
--- hint
The outer range should be `range(H - kh + 1)`, the same as the inner one with `W`.
```

## Predict the feature-map shape

```python predict id=predict-conv title="What is the output shape?"
import numpy as np
image = np.ones((5, 5))
kernel = np.ones((3, 3))
print(np.zeros((image.shape[0] - kernel.shape[0] + 1, image.shape[1] - kernel.shape[1] + 1)).shape)
--- options
* (3, 3)
(5, 5)
(2, 2)
(4, 4)
--- explain
A 3 × 3 kernel fits in 5 - 3 + 1 = 3 positions along each side without padding, so the feature map is 3 × 3. Padding of one would keep it at 5 × 5.
```

## Recap

- A convolution slides one small kernel across the image and reuses its weights at every position.
- A feature map shows where a pattern occurs. Early layers learn edge and colour detectors.
- Padding and stride control the output size: $\lfloor (n + 2p - k)/s \rfloor + 1$.
- Convolutions have far fewer parameters than dense layers, and they are translation-aware by design.

**Up next:** pooling and complete convolutional networks, from the first layer to the classifier.
