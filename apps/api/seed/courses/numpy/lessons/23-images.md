Every photo on your phone, every frame of video and every image fed to a neural network is, underneath, just a NumPy-style array of numbers. Once you see an image as an array, editing it is a matter of indexing, slicing and arithmetic you already know.

In this lesson you'll take apart a small picture: you'll split it into color channels, convert it to grayscale with a dot product, crop and rotate it with slicing, brighten it *without* the classic overflow bug, find objects with boolean masks, and blur it with a few shifted slices. Along the way you'll see exactly what preprocessing libraries like torchvision do before an image reaches a model.

## An image is a 3-D array

A color image is stored as an array of shape `(height, width, 3)`: rows of pixels, columns of pixels, and three **channels** (red, green, blue). Each value is usually a `uint8`, an unsigned 8-bit integer from `0` (none of that color) to `255` (full intensity).

To avoid downloading anything, this lesson draws its own picture. The setup below builds a small landscape (sky, sun, grass and a red house) and defines a `show()` helper for displaying images side by side.

```python setup
def make_scene(h=96, w=128):
    """A tiny synthetic landscape: sky gradient, sun, grass and a red house."""
    y, x = np.mgrid[0:h, 0:w]
    t = 1 - y / (h - 1)                              # 1 at the top, 0 at the bottom
    img = np.zeros((h, w, 3), dtype=np.uint8)
    img[..., 0] = 70                                  # red channel
    img[..., 1] = (60 + 150 * t).astype(np.uint8)    # green channel
    img[..., 2] = (100 + 153 * t).astype(np.uint8)   # blue channel
    sun = (x - 95) ** 2 + (y - 25) ** 2 < 14 ** 2
    img[sun] = [255, 210, 60]
    img[y > h * 0.7] = [60, 140, 70]                 # grass
    img[50:72, 20:50] = [200, 40, 40]                # house
    return img

scene = make_scene()
```

```python setup
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

def show(*images, titles=None, height=2.4):
    """Display images (H, W, 3) or grayscale (H, W), values 0-255, side by side."""
    tiles = []
    for im in images:
        im = np.clip(np.asarray(im), 0, 255).astype(np.uint8)
        tiles.append(np.repeat(im[..., None], 3, axis=2) if im.ndim == 2 else im)
    h = max(t.shape[0] for t in tiles)
    gap = np.full((h, 10, 3), 255, dtype=np.uint8)
    parts, centers, x = [], [], 0
    for t in tiles:
        padded = np.full((h, t.shape[1], 3), 255, dtype=np.uint8)
        padded[: t.shape[0]] = t
        parts += [padded, gap]
        centers.append(x + t.shape[1] / 2)
        x += t.shape[1] + gap.shape[1]
    canvas = np.concatenate(parts[:-1], axis=1)
    fig, ax = plt.subplots(figsize=(height * canvas.shape[1] / h, height + 0.3))
    ax.imshow(canvas, interpolation="nearest")
    for i, cx in enumerate(centers):
        label = titles[i] if titles else f"{images[i].shape}"
        ax.text(cx, -3, label, ha="center", va="bottom", fontsize=9)
    ax.axis("off")
```

```python run
print("shape:", scene.shape)
print("dtype:", scene.dtype)
print("values from", scene.min(), "to", scene.max())
print("top-left pixel (R, G, B):", scene[0, 0])
show(scene, titles=["our scene"])
```

Reading `scene[row, col]` gives one pixel, a length-3 array of red, green and blue. Row `0` is the **top** of the image, which is the opposite of a math plot's y-axis. That convention trips people up when they flip or crop.

> **Under the hood:** `96 × 128 × 3 = 36,864` bytes. A 12-megapixel phone photo is the same idea at `3000 × 4000 × 3`, about 36 MB uncompressed. That's why images are stored as `uint8` and not `float64`, which would be eight times larger.

## Channels

Slicing the last axis pulls out a single channel as a 2-D grayscale image. Bright areas mean "a lot of this color".

```python run
red, green, blue = scene[..., 0], scene[..., 1], scene[..., 2]
print("red channel shape:", red.shape)
print("mean R, G, B:", red.mean().round(1), green.mean().round(1), blue.mean().round(1))
show(red, green, blue, titles=["red", "green", "blue"])
```

The sun and house glow in the red channel, while the sky glows in blue. The `...` (ellipsis) means "all the leading axes", so `scene[..., 0]` is the same as `scene[:, :, 0]`, and it keeps working for batches of images shaped `(N, H, W, 3)`.

```python predict id=predict-pixel-shape title="What shape is this?"
pixel_row = scene[10, :, :]
print(pixel_row.shape)
--- options
(10, 3)
* (128, 3)
(96, 3)
(3,)
--- explain
Fixing the row index (`10`) removes the first axis. What remains is every column (`128`) and every channel (`3`): one horizontal line of pixels.
```

## Grayscale with a dot product

To convert to grayscale, take a **weighted sum** of the channels. Human eyes are most sensitive to green and least to blue, so the standard (ITU-R BT.601) weights are:

$$\text{gray} = 0.299\,R + 0.587\,G + 0.114\,B$$

A weighted sum over the last axis is exactly what `@` (matrix multiplication) does when the right operand is a 1-D vector: `(H, W, 3) @ (3,) → (H, W)`.

```python run
weights = np.array([0.299, 0.587, 0.114])
gray = scene @ weights
print(gray.shape, gray.dtype, gray.min().round(2), gray.max().round(2))
show(scene, gray.astype(np.uint8), titles=["color", "grayscale"])
```

The result is `float64`. To store it as an image again, you round and convert back to `uint8`.

```python exercise id=to-grayscale title="Convert to an 8-bit grayscale image"
weights = np.array([0.299, 0.587, 0.114])

# TODO: `gray8` should be the grayscale version of `scene`:
#   - shape (96, 128)
#   - dtype uint8
#   - each pixel = the weighted sum of R, G, B, ROUNDED to the nearest integer
gray8 = ...
--- solution
weights = np.array([0.299, 0.587, 0.114])

gray8 = np.round(scene @ weights).astype(np.uint8)
--- test
assert gray8 is not ..., "Replace the `...` after `gray8 =` with your code."
gray8 = np.asarray(gray8)
assert gray8.shape == (96, 128), f"`gray8` should have shape (96, 128), one value per pixel, but has {gray8.shape}."
assert gray8.dtype == np.uint8, f"`gray8` should have dtype uint8 but has {gray8.dtype}. Convert with .astype(np.uint8)."
_ref = np.round(make_scene() @ np.array([0.299, 0.587, 0.114])).astype(np.uint8)
_diff = np.abs(gray8.astype(int) - _ref.astype(int))
assert _diff.max() <= 1 and np.mean(_diff == 0) > 0.99, "Some pixels are off. Make sure you round *before* converting to uint8 (astype truncates)."
assert np.array_equal(gray8, _ref), "Almost! A few pixels differ by 1. Use np.round(...) before .astype(np.uint8)."
--- hint
`scene @ weights` gives the float grayscale values. You saw it just above.
--- hint
`.astype(np.uint8)` *truncates* (172.9 becomes 172). Wrap the float values in `np.round(...)` first.
```

## Cropping, flipping and rotating

Geometry is pure indexing. Slicing crops; a negative step flips; `np.rot90` rotates in 90° steps. All of these return **views**, so they're instant and use no extra memory.

```python run
crop = scene[40:80, 10:60]          # rows 40-79, columns 10-59
upside_down = scene[::-1]           # reverse the rows
mirrored = scene[:, ::-1]           # reverse the columns
rotated = np.rot90(scene)           # 90° counter-clockwise

print("crop:", crop.shape, " rotated:", rotated.shape)
show(crop, upside_down, mirrored, rotated, titles=["crop", "flip rows", "mirror", "rot90"])
```

`np.flip(scene, axis=0)` and `np.flip(scene, axis=1)` are named equivalents of `scene[::-1]` and `scene[:, ::-1]`. Notice that the rotated image has shape `(128, 96, 3)`: height and width swap.

> **Pitfall:** never write `scene[::-1, ::-1, ::-1]` to "flip everything". Reversing the *last* axis swaps the R and B channels, turning your red house blue. Flip only the spatial axes (0 and 1).

```python exercise id=house-thumbnail title="Make a mirrored thumbnail of the house"
# The house occupies rows 50-71 and columns 20-49 of `scene`.

# TODO: `thumb` = the house region, mirrored left-to-right,
# keeping only every 2nd row and every 2nd column (half resolution).
thumb = ...
--- solution
thumb = scene[50:72, 20:50][::2, ::-2]
--- test
assert thumb is not ..., "Replace the `...` after `thumb =` with your code."
thumb = np.asarray(thumb)
_house = make_scene()[50:72, 20:50]
assert thumb.ndim == 3 and thumb.shape[2] == 3, f"`thumb` should still be a color image (H, W, 3) but has shape {thumb.shape}. Don't slice away the channels."
assert thumb.shape == (11, 15, 3), f"Half of 22 rows × 30 columns is (11, 15, 3), but `thumb` has shape {thumb.shape}."
_options = [_house[::2, ::-1][:, ::2], _house[::2, ::-2], _house[:, ::-1][::2, ::2], _house[::2, ::2][:, ::-1]]
assert any(np.array_equal(thumb, o) for o in _options), "The crop or the mirroring isn't right. Check the region (rows 50:72, columns 20:50), and reverse the columns, not the rows."
--- hint
First crop with `scene[50:72, 20:50]`, which has shape (22, 30, 3).
--- hint
A step of `2` keeps every second element and a step of `-1` reverses. You can chain slices: `region[::2, ::-1][:, ::2]`, or combine them into a single `::-2`.
```

## Brightness, contrast and the overflow trap

Brightening means adding to every value. But `uint8` can only hold 0–255, and NumPy integer arithmetic **wraps around** silently: `250 + 10` becomes `4`.

```python run
bright_wrong = scene + 80                                  # uint8 + int stays uint8: wraps!
bright_right = np.clip(scene.astype(np.int16) + 80, 0, 255).astype(np.uint8)

print("sun pixel before:", scene[25, 95], " wrong:", bright_wrong[25, 95], " right:", bright_right[25, 95])
show(scene, bright_wrong, bright_right, titles=["original", "+80 (wrapped)", "+80 (clipped)"])
```

The fix is always the same three steps: **widen** the dtype (`int16`, `int32` or `float`), do the math, then **clip** to `[0, 255]` and convert back.

```python predict id=predict-uint8-wrap title="What does uint8 arithmetic give?"
a = np.array([250, 100], dtype=np.uint8)
print(a + np.uint8(10))
--- options
[260 110]
[255 110]
* [  4 110]
[250 110]
--- explain
`uint8` arithmetic is modulo 256: `250 + 10 = 260`, and `260 - 256 = 4`. NumPy doesn't raise an error or clip for you, so it's on you to widen and clip.
```

Contrast stretches values away from the middle gray (128). The same widen-compute-clip recipe applies:

```python run
def adjust_contrast(img, factor):
    out = (img.astype(np.float64) - 128) * factor + 128
    return np.clip(out, 0, 255).astype(np.uint8)

show(adjust_contrast(scene, 0.5), scene, adjust_contrast(scene, 1.8), titles=["contrast ×0.5", "original", "contrast ×1.8"])
```

```python debug id=brighten-overflow title="The sun turned black"
def brighten(img, amount):
    """Add `amount` to every channel, saturating at 255."""
    out = img + amount
    out[out > 255] = 255
    return out

bright = brighten(scene, 60)
print("sun pixel:", bright[25, 95])     # should be [255 255 120]
--- solution
def brighten(img, amount):
    """Add `amount` to every channel, saturating at 255."""
    out = img.astype(np.int16) + amount
    out[out > 255] = 255
    return out.astype(np.uint8)

bright = brighten(scene, 60)
print("sun pixel:", bright[25, 95])     # should be [255 255 120]
--- test
_src = make_scene()
_b = brighten(_src, 60)
assert isinstance(_b, np.ndarray) and _b.shape == _src.shape, f"`brighten` should return an image with the same shape {_src.shape}."
assert _b.dtype == np.uint8, f"`brighten` should return a uint8 image (so it can be displayed and stored), but returned {_b.dtype}."
assert np.array_equal(_b[25, 95], [255, 255, 120]), f"The sun pixel should saturate to [255 255 120] but is {_b[25, 95]}. Values are still wrapping around."
assert np.array_equal(_b, np.clip(_src.astype(int) + 60, 0, 255).astype(np.uint8)), "Some pixels are still wrong. Every channel should be min(value + amount, 255)."
assert np.array_equal(brighten(_src, 0), _src), "brighten(img, 0) should return an identical image."
--- hint
Debug it and look at `out` right after `img + amount`. Can a `uint8` ever be greater than 255?
--- hint
`out > 255` is never True because the overflow already happened during the addition. Widen first (`img.astype(np.int16)`), then saturate, then convert back to `np.uint8`.
```

## Finding things with masks

A boolean condition on the channels produces a **mask**: a `(H, W)` array that is `True` wherever a pixel matches. Combine conditions with `&` and `|` (always in parentheses).

```python run
r, g, b = (scene[..., i].astype(int) for i in range(3))
is_red = (r > 150) & (g < 80) & (b < 80)

rows, cols = np.nonzero(is_red)
print("red pixels:", is_red.sum())
print("bounding box: rows", rows.min(), "to", rows.max(), "| cols", cols.min(), "to", cols.max())

highlight = scene.copy()
highlight[is_red] = [255, 255, 0]          # paint the matches yellow
show(is_red.astype(np.uint8) * 255, highlight, titles=["mask", "highlighted"])
```

`np.nonzero(mask)` returns the row and column indices of every `True`. Their min and max give the object's bounding box, and their means give its center. This is the core of classic color-based object tracking.

```python exercise id=find-the-sun title="Locate the sun"
# The sun's pixels are bright red, fairly bright green and low blue:
#   R > 230, G > 180, B < 100

# TODO 1: `sun_mask`: boolean array of shape (96, 128), True on sun pixels
sun_mask = ...

# TODO 2: `center`: (row, col) of the sun's center, as the mean row
# and mean column of the sun pixels (two floats in a tuple)
center = ...
--- solution
r, g, b = scene[..., 0], scene[..., 1], scene[..., 2]
sun_mask = (r > 230) & (g > 180) & (b < 100)

rows, cols = np.nonzero(sun_mask)
center = (rows.mean(), cols.mean())
--- test
assert sun_mask is not ..., "Replace the `...` after `sun_mask =` with your code."
assert center is not ..., "Replace the `...` after `center =` with your code."
sun_mask = np.asarray(sun_mask)
assert sun_mask.shape == (96, 128), f"`sun_mask` should have shape (96, 128), one value per pixel, but has {sun_mask.shape}."
assert sun_mask.dtype == bool, f"`sun_mask` should be a boolean array but has dtype {sun_mask.dtype}. Combine comparisons with &."
_s = make_scene().astype(int)
_ref = (_s[..., 0] > 230) & (_s[..., 1] > 180) & (_s[..., 2] < 100)
assert sun_mask.sum() == _ref.sum(), f"The sun has {_ref.sum()} pixels but your mask has {sun_mask.sum()}. Check each condition and combine them with & (not `and`)."
assert np.array_equal(sun_mask, _ref), "The mask has the right count but marks the wrong pixels."
assert len(center) == 2, "`center` should be a pair: (row, col)."
assert np.allclose(center, (25, 95), atol=0.5), f"The sun is centered near row 25, column 95, but `center` is {tuple(np.round(center, 2))}. Did you swap rows and columns?"
--- hint
Pull out the channels with `scene[..., 0]`, `scene[..., 1]` and `scene[..., 2]`, then combine three comparisons with `&`, each in parentheses.
--- hint
`rows, cols = np.nonzero(sun_mask)` gives the coordinates of every sun pixel. The center is their means.
```

## Blurring with shifted slices

A **box blur** replaces each pixel with the average of its 3×3 neighbourhood. You don't need a loop over pixels: pad the image by one pixel, then add up the nine shifted copies of it. Each shifted slice lines up a different neighbour with every pixel at once.

```python run
gray = (scene @ [0.299, 0.587, 0.114])
padded = np.pad(gray, 1, mode="edge")        # (98, 130): repeat edge pixels
H, W = gray.shape

total = np.zeros_like(gray)
for dy in range(3):
    for dx in range(3):
        total += padded[dy:dy + H, dx:dx + W]
blurred = total / 9

print("padded:", padded.shape, " blurred:", blurred.shape)
show(gray.astype(np.uint8), blurred.astype(np.uint8), titles=["sharp", "3×3 box blur"])
```

The nine iterations of that tiny loop each process the *whole* image in one vectorized step. This "shift and accumulate" pattern is how convolutions are often explained, and it's the operation at the heart of convolutional neural networks.

> **In the wild:** for larger kernels you'd reach for `scipy.ndimage.uniform_filter` or `np.lib.stride_tricks.sliding_window_view` (covered in the performance lesson), but the idea is exactly this.

```python exercise id=box-blur title="Write a k×k box blur"
def box_blur(gray, k):
    """Blur a 2-D float image with a k×k box filter (k odd).

    Pad with mode="edge" by k // 2 pixels, then average the k*k shifted
    slices. The result must have the same shape as `gray`.
    """
    # TODO
    ...

result = box_blur(scene @ [0.299, 0.587, 0.114], 5)
--- solution
def box_blur(gray, k):
    """Blur a 2-D float image with a k×k box filter (k odd)."""
    r = k // 2
    padded = np.pad(gray, r, mode="edge")
    H, W = gray.shape
    total = np.zeros(gray.shape, dtype=float)
    for dy in range(k):
        for dx in range(k):
            total += padded[dy:dy + H, dx:dx + W]
    return total / (k * k)

result = box_blur(scene @ [0.299, 0.587, 0.114], 5)
--- test
def _ref_blur(g, k):
    r = k // 2
    p = np.pad(g, r, mode="edge")
    H, W = g.shape
    return sum(p[dy:dy + H, dx:dx + W] for dy in range(k) for dx in range(k)) / (k * k)
_g = make_scene() @ np.array([0.299, 0.587, 0.114])
_out = box_blur(_g, 3)
assert _out is not None, "`box_blur` returned None. Did you forget `return`?"
_out = np.asarray(_out)
assert _out.shape == _g.shape, f"The blurred image should keep the shape {_g.shape}, but has {_out.shape}. Pad by k // 2 before slicing."
assert np.allclose(_out, _ref_blur(_g, 3)), "box_blur(gray, 3) gives the wrong values. Each pixel should be the mean of its 3×3 neighbourhood (edge-padded)."
assert np.allclose(box_blur(_g, 5), _ref_blur(_g, 5)), "Works for k=3 but not k=5. Make the padding and the loops depend on k."
_rng = np.random.default_rng(1)
_n = _rng.uniform(0, 255, size=(7, 9))
assert np.allclose(box_blur(_n, 3), _ref_blur(_n, 3)), "Doesn't work on a different image size. Avoid hard-coding 96 and 128."
assert np.allclose(box_blur(_n, 1), _n), "With k=1 the image should be unchanged."
--- hint
Start from the 3×3 version above and replace every hard-coded `3` and `1` with something based on `k`: the padding is `k // 2` and there are `k` offsets in each direction.
--- hint
`H, W = gray.shape`, then accumulate `padded[dy:dy + H, dx:dx + W]` for `dy` and `dx` in `range(k)`, and divide by `k * k`. Don't forget to `return` it.
```

## Images for machine learning

Before an image reaches a neural network it's typically:

1. converted to float and **scaled to [0, 1]** by dividing by 255,
2. **standardized** per channel (subtract the mean, divide by the standard deviation),
3. **transposed** from `(H, W, C)` to `(C, H, W)`, the layout PyTorch expects,
4. **stacked** into a batch `(N, C, H, W)`.

```python run
x = scene.astype(np.float32) / 255.0                  # 1. [0, 1]
mean = x.mean(axis=(0, 1))                            # one mean per channel
std = x.std(axis=(0, 1))
x = (x - mean) / std                                  # 2. standardize
chw = np.transpose(x, (2, 0, 1))                      # 3. (3, 96, 128)
batch = np.stack([chw, chw[:, :, ::-1]])              # 4. image + mirrored copy

print("per-channel mean:", mean.round(3))
print("after standardizing:", x.mean(axis=(0, 1)).round(6), x.std(axis=(0, 1)).round(3))
print("CHW:", chw.shape, " batch:", batch.shape, batch.dtype)
```

Note `axis=(0, 1)`: reducing over height *and* width at once leaves one statistic per channel. The mirrored copy in the batch is a simple form of **data augmentation**.

> **In the wild:** `torchvision.transforms.ToTensor()` performs steps 1 and 3; `Normalize(mean, std)` performs step 2. There's no magic in them, just the NumPy you wrote above.

## Recap

- A color image is a `(H, W, 3)` `uint8` array: rows, columns, channels. Row 0 is the top.
- Channels are slices (`img[..., 0]`), and grayscale is a weighted sum: `img @ [0.299, 0.587, 0.114]`.
- Crops, flips and rotations are slicing (`[::-1]`) and `np.rot90`: free views, no copying.
- `uint8` math wraps around silently. Widen, compute, `np.clip` to `[0, 255]`, convert back.
- Boolean masks over channels find objects, and `np.nonzero` gives their coordinates.
- A blur is an average of shifted slices; ML preprocessing is scale → standardize → transpose → stack.

**Up next:** structured arrays and file I/O: saving, loading and parsing real data files with NumPy.
