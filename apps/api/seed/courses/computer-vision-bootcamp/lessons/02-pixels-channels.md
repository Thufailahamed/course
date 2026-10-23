A colour image is a three-channel array: height, width, and one number per colour. Before any model sees an image, the values are often converted to a grayscale brightness, scaled to a fixed range and reordered into the layout the framework expects. This lesson covers each of those steps.

## An image is an array

Images are usually stored as unsigned 8-bit integers from 0 to 255. Setting a pixel means setting its three channel values.

```python run
import numpy as np

img = np.zeros((2, 3, 3), dtype=np.uint8)   # 2 rows, 3 columns, RGB
img[0, 0] = [255, 0, 0]                      # top-left pixel is pure red
img[1, 2] = [0, 0, 255]                      # bottom-right pixel is pure blue
print("shape (height, width, channels):", img.shape)
print("top-left pixel:", img[0, 0], "| dtype:", img.dtype)
```

## Grayscale brightness

A grayscale value combines the channels with weights that match human sensitivity. The standard luma weights are 0.299 for red, 0.587 for green and 0.114 for blue, so green contributes most to perceived brightness.

```python run
weights = np.array([0.299, 0.587, 0.114])
for name, rgb in [("red", [255, 0, 0]), ("green", [0, 255, 0]), ("blue", [0, 0, 255]), ("white", [255, 255, 255])]:
    print(f"{name:>6}: grey level {np.array(rgb) @ weights:.1f}")
```

## Read one channel and normalize

Indexing the last axis selects a channel. Models usually expect floats between 0 and 1, and frameworks often expect channel-first layout, which is a transpose.

```python run
red_channel = img[:, :, 0]
print("red channel:\n", red_channel)

x = img.astype(np.float32) / 255.0
chw = np.transpose(x, (2, 0, 1))
print("float range:", float(x.min()), "to", float(x.max()))
print("channel-first shape:", chw.shape)
```

> **Pitfall:** dividing a uint8 image by 255 without converting to float first gives integer results or silent overflow in some operations. Convert first, then scale.

> **In the wild:** almost every vision pipeline normalizes with the mean and standard deviation of its pretraining dataset, so the same preprocessing must be used at inference time.

## Average colour

The average colour of an image is the mean over its height and width, one number per channel.

```python run
print("average colour per channel:", img.mean(axis=(0, 1)))
```

## Challenge: grayscale

```python exercise id=to-grayscale title="Convert RGB to grayscale"
import numpy as np

# TODO: `to_grayscale(img)` takes an (H, W, 3) array and returns an (H, W) array of luma values
# using the weights 0.299 for red, 0.587 for green and 0.114 for blue.
def to_grayscale(img):
    ...
--- solution
import numpy as np

def to_grayscale(img):
    weights = np.array([0.299, 0.587, 0.114])
    return np.asarray(img, dtype=float) @ weights
--- test
import numpy as np
result = to_grayscale(np.array([[[255, 0, 0], [255, 255, 255]]]))
assert result is not None, "Replace the `...` in `to_grayscale` with code that returns the grey image."
assert result.shape == (1, 2), f"A (1, 2, 3) image should give a (1, 2) result, but you returned shape {result.shape}."
assert abs(result[0, 0] - 0.299 * 255) < 1e-9, "Pure red has luma 0.299 × 255."
assert abs(result[0, 1] - 255.0) < 1e-9, "White has luma 255, because the weights sum to one."
--- hint
Matrix-multiply along the last axis: `img @ weights` contracts the channel axis.
--- hint
`return np.asarray(img, dtype=float) @ np.array([0.299, 0.587, 0.114])`.
```

## Challenge: scale to the unit range

```python exercise id=unit-range title="Scale pixels to the unit range"
import numpy as np

# TODO: `to_unit_range(img)` returns the pixel values scaled from 0..255 to 0..1 as floats.
def to_unit_range(img):
    ...
--- solution
import numpy as np

def to_unit_range(img):
    return np.asarray(img, dtype=float) / 255.0
--- test
import numpy as np
result = to_unit_range(np.array([0, 128, 255]))
assert result is not None, "Replace the `...` in `to_unit_range` with code that returns the scaled pixels."
assert np.allclose(result, [0.0, 128 / 255, 1.0]), f"Each value should be divided by 255, but you returned {result}."
--- hint
Convert to float first, then divide by 255.
--- hint
`return np.asarray(img, dtype=float) / 255.0`.
```

## Debug: channel means

This check should give the average colour of the whole image, one number per channel, but the averaging axis is wrong.

```python debug id=channel-means title="Average over the pixels, not the rows"
import numpy as np

img = np.zeros((4, 5, 3))
img[..., 0] = 1.0                    # the whole image is pure red
means = img.mean(axis=0)             # bug: this averages over the height only
print("channel means:", means)
--- solution
import numpy as np

img = np.zeros((4, 5, 3))
img[..., 0] = 1.0
means = img.mean(axis=(0, 1))
print("channel means:", means)
--- test
assert means.shape == (3,), f"There should be one mean per channel, but the result has shape {means.shape}. Average over both the height and the width."
assert np.allclose(means, [1.0, 0.0, 0.0]), f"The image is pure red, so the means should be [1, 0, 0], but you returned {means}."
--- hint
Pass both spatial axes to `mean`, so that only the channel axis remains.
--- hint
`img.mean(axis=(0, 1))`.
```

## Predict the grey level

```python predict id=predict-gray title="What grey level does pure green give?"
print(round(0.587 * 255, 1))
--- options
* 149.7
255.0
76.2
29.1
--- explain
Green carries the largest luma weight, 0.587. Scaling it by 255 gives about 149.7.
```

## Recap

- An image is an array of height, width and channels, stored as small integers.
- Grayscale is a weighted sum over the channels, with green weighted most.
- Convert to float and scale before modelling, and match the layout the framework expects.

**Up next:** convolution, the operation that every CNN is built on.
