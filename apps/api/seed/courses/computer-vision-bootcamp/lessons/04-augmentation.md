A model learns only from the variation its training images contain. Augmentation creates new plausible variants of each image: flipped, cropped or brightened. It is one of the cheapest ways to improve a vision model, and it works only when the label survives the change.

## Flips and crops

A horizontal flip reverses the column order. A crop keeps a window of the image.

```python run
import numpy as np

img = np.arange(36).reshape(6, 6)
flipped = img[:, ::-1]
print("first row flipped:", flipped[0])
print("centre 2x2 crop:\n", img[2:4, 2:4])
```

## Brightness with clipping

Adding brightness can push values outside the valid range, so the result is clipped back to 0 to 255.

```python run
pixels = np.array([40, 128, 230], dtype=float)
brighter = np.clip(pixels + 60, 0, 255)
darker = np.clip(pixels - 100, 0, 255)
print("brighter:", brighter, "| darker:", darker)
```

## A random augmentation

Training pipelines draw random choices for each example. A fixed seed makes the choices reproducible, which matters when you compare two training runs.

```python run
rng = np.random.default_rng(0)

def augment(img, rng):
    out = img.copy()
    if rng.random() < 0.5:
        out = out[:, ::-1]
    return out

for _ in range(3):
    out = augment(img, rng)
    print("flipped this time:", not np.array_equal(out, img))
```

## Flips keep the pixel statistics

A flip moves pixels around without changing their values, so the average brightness of the image stays the same.

```python run
print("mean before:", img.mean(), "| mean after flip:", flipped.mean())
```

> **Pitfall:** augmentation must preserve the label. Flipping a photo of a handwritten "6" gives a "9", and a crop that removes the object gives an image with no label to learn from. Choose transforms that match the task.

> **In the wild:** the augmentation policy is one of the most important hyperparameters in a vision project, and is tuned with the same care as the learning rate.

## Challenge: flip an image

```python exercise id=flip title="Flip an image horizontally"
import numpy as np

# TODO: `flip_horizontal(img)` returns the image mirrored left to right, keeping its rows in order.
def flip_horizontal(img):
    ...
--- solution
import numpy as np

def flip_horizontal(img):
    return np.asarray(img)[:, ::-1]
--- test
import numpy as np
result = flip_horizontal(np.array([[1, 2, 3], [4, 5, 6]]))
assert result is not None, "Replace the `...` in `flip_horizontal` with code that returns the flipped image."
assert result.tolist() == [[3, 2, 1], [6, 5, 4]], f"Each row should be reversed, but you returned {result.tolist()}."
--- hint
Reverse the column order, not the rows.
--- hint
`np.asarray(img)[:, ::-1]`.
```

## Challenge: centre crop

```python exercise id=center-crop title="Take the centre crop"
import numpy as np

# TODO: `center_crop(img, h, w)` returns the h × w region at the centre of the 2-D image. Use the offset (H − h) // 2 from the
# top and (W − w) // 2 from the left.
def center_crop(img, h, w):
    ...
--- solution
import numpy as np

def center_crop(img, h, w):
    img = np.asarray(img)
    H, W = img.shape
    top, left = (H - h) // 2, (W - w) // 2
    return img[top:top + h, left:left + w]
--- test
import numpy as np
result = center_crop(np.arange(36).reshape(6, 6), 2, 2)
assert result is not None, "Replace the `...` in `center_crop` with code that returns the crop."
assert result.tolist() == [[14, 15], [20, 21]], f"The centre 2 × 2 of a 6 × 6 grid starts at row 2 and column 2, giving [[14, 15], [20, 21]], but you returned {result.tolist()}."
--- hint
Compute the top-left corner first, then slice `top:top + h` and `left:left + w`.
--- hint
`img[top:top + h, left:left + w]`.
```

## Debug: brightness overflow

Brightening should saturate at 255, but the pixels are stored as 8-bit integers, and the addition wraps around.

```python debug id=uint8-overflow title="Brighten without wrapping around"
import numpy as np

pixels = np.array([200, 30], dtype=np.uint8)
bright = pixels + 100                 # bug: uint8 arithmetic wraps past 255
print("brightened:", bright)
--- solution
import numpy as np

pixels = np.array([200, 30], dtype=np.uint8)
bright = np.clip(pixels.astype(int) + 100, 0, 255)
print("brightened:", bright)
--- test
assert bright.tolist() == [255, 130], f"Brightening 200 by 100 should saturate at 255 and 30 should become 130, but the result is {bright.tolist()}. Convert to a wider integer type before adding, then clip."
--- hint
In uint8, 200 + 100 is 300, which wraps to 44.
--- hint
Use `np.clip(pixels.astype(int) + 100, 0, 255)`.
```

## Predict the flipped row

```python predict id=predict-flip title="What is the first row after flipping this array?"
import numpy as np
a = np.arange(6).reshape(2, 3)
print(a[:, ::-1][0])
--- options
* [2 1 0]
[0 1 2]
[3 4 5]
[5 4 3]
--- explain
The first row of the array is 0, 1, 2. Reversing the columns gives 2, 1, 0.
```

## Recap

- Augmentation multiplies the variety in the training data for little cost.
- Every transform must preserve the label, so choose transforms that match the task.
- Convert to a wider type before arithmetic on pixels, and clip to the valid range.

**Up next:** the architectures that turn these operations into classifiers.
