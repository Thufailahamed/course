DELETE FROM exercise_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_computer_vision_bootcamp');

DELETE FROM quiz_attempts WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_computer_vision_bootcamp');

DELETE FROM notes WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_computer_vision_bootcamp');

DELETE FROM lesson_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_computer_vision_bootcamp');

DELETE FROM discussions WHERE course_id = 'crs_computer_vision_bootcamp';

DELETE FROM certificates WHERE course_id = 'crs_computer_vision_bootcamp';

DELETE FROM enrollments WHERE course_id = 'crs_computer_vision_bootcamp';

DELETE FROM reviews WHERE course_id = 'crs_computer_vision_bootcamp';

DELETE FROM wishlist WHERE course_id = 'crs_computer_vision_bootcamp';

DELETE FROM path_courses WHERE course_id = 'crs_computer_vision_bootcamp';

DELETE FROM coupons WHERE course_id = 'crs_computer_vision_bootcamp';

DELETE FROM lessons WHERE course_id = 'crs_computer_vision_bootcamp';

DELETE FROM sections WHERE course_id = 'crs_computer_vision_bootcamp';

UPDATE order_items SET course_id = NULL WHERE course_id = 'crs_computer_vision_bootcamp';

DELETE FROM courses WHERE id = 'crs_computer_vision_bootcamp';

INSERT OR IGNORE INTO categories (id, slug, name, description, icon, sort_order) VALUES ('cat_computer-vision', 'computer-vision', 'Computer Vision', 'Image classification, detection, segmentation and more.', 'eye', 4);

INSERT INTO courses (id, slug, title, subtitle, description, category_id, instructor_id, level, language, price_cents, compare_at_price_cents, currency, thumbnail_key, preview_video_url, accent, status, featured, what_you_learn, requirements, target_audience, tags, duration_minutes, lessons_count, rating_avg, rating_count, students_count, published_at, created_at, updated_at) VALUES
('crs_computer_vision_bootcamp', 'computer-vision-bootcamp', 'Computer Vision Bootcamp', 'Pixels, convolutions, detection, segmentation and vision transformers, built in NumPy and taught the way production systems work.', 'Computer vision turns pixels into decisions: what is in this picture, where it is, and which pixels belong to it. This bootcamp teaches the ideas behind those answers. Each one is implemented in NumPy so the arithmetic is visible, and then the same idea is shown in the PyTorch and torchvision code used in production.

## Learn by building

- **Every operation in NumPy.** Convolutions, output sizes, receptive fields, IoU, non-maximum suppression, anchor decoding, patch embeddings and Dice loss all run in the page.
- **Metrics that matter.** You compute per-class IoU, precision and recall at an IoU threshold, and average precision, the numbers used to compare detectors in papers.
- **Debug challenges.** You fix the bugs that quietly break vision code: a forgotten padding term, a receptive-field calculation in the wrong order, uint8 overflow during augmentation, and a skip connection concatenated on the wrong axis.
- **Framework code, shown honestly.** Full detectors, U-Nets and CLIP models are static PyTorch code for you to run locally, and each is paired with a NumPy version of the idea it uses.

## What you''ll cover

- **Images as data:** pixels, channels, convolutions and augmentation.
- **Classification:** CNN architectures, parameter counts and transfer learning.
- **Detection:** boxes, IoU and NMS, anchors, one-stage and two-stage detectors, and training targets.
- **Segmentation:** semantic and instance masks, pixel IoU, U-Net and Dice loss.
- **Vision transformers:** patch embeddings, CLIP and zero-shot classification, and a capstone evaluation.

## Why this course?

Many vision tutorials start with a framework call that trains a model and stop there. When a detector drops boxes or a segmenter fails on small objects, you need to know what the metric measures, what each shape means and where a bug can hide. This course gives you that understanding before the framework does the rest.', 'cat_computer-vision', 'usr_sofia', 'intermediate', 'English', 0, NULL, 'USD', NULL, NULL, 24, 'published', 0, '["Read images as arrays and apply augmentations that keep labels correct","Compute convolution output sizes, receptive fields and parameter counts","Transfer a pretrained backbone with a frozen-feature linear probe","Measure detections with IoU and non-maximum suppression, and decode anchor boxes","Evaluate segmentation with per-class IoU, and explain U-Net skip connections and Dice loss","Use patch embeddings and CLIP-style zero-shot classification, and evaluate a detector"]', '["Python and NumPy. The browser runs the NumPy code; PyTorch and torchvision code is shown for local use","Some deep-learning background helps, such as Deep Learning Foundations"]', '["Engineers building vision features who want to understand what the models compute","Robotics and imaging practitioners who need detection or segmentation","Data scientists moving from tabular data into images"]', '["CNNs","Object Detection","Segmentation","ViT"]', 258, 18, 0, 0, 24310, '2026-04-05T07:12:46.269Z', '2026-03-06T07:12:46.269Z', '2026-10-21T07:12:46.269Z');

INSERT INTO sections (id, course_id, title, position, created_at) VALUES
('sec_computer_vision_bootcamp_1', 'crs_computer_vision_bootcamp', 'Images as Data', 0, '2026-06-25T07:12:46.269Z'),
('sec_computer_vision_bootcamp_2', 'crs_computer_vision_bootcamp', 'Classification', 1, '2026-06-25T07:12:46.269Z'),
('sec_computer_vision_bootcamp_3', 'crs_computer_vision_bootcamp', 'Detection', 2, '2026-06-25T07:12:46.269Z'),
('sec_computer_vision_bootcamp_4', 'crs_computer_vision_bootcamp', 'Segmentation', 3, '2026-06-25T07:12:46.269Z'),
('sec_computer_vision_bootcamp_5', 'crs_computer_vision_bootcamp', 'Vision Transformers', 4, '2026-06-25T07:12:46.269Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_computer_vision_bootcamp_1_1', 'sec_computer_vision_bootcamp_1', 'crs_computer_vision_bootcamp', 'How this course works', 'interactive', 0, 480, NULL, NULL, 'A model that recognizes a cat, finds a pedestrian or outlines a tumour is built from a few repeated operations: sliding filters over images, measuring overlap between boxes, and combining features from different scales. Each operation is simple. Together they solve problems that were out of reach a decade ago.

This course runs the NumPy code in the page, so every lesson''s arithmetic is something you can execute and change. Full detectors and segmentation networks are large, so they are shown as static PyTorch code for you to run locally, each followed by a NumPy version of the idea it uses.

> **How to use this lesson:** run the grey boxes, change a number, and see what moves. The challenges check your code against tests.

## An image is a grid of numbers

This 4 by 4 grey image has values from 0 to 255 in each row.

```python run
import numpy as np

gradient = np.array([[0, 85, 170, 255]] * 4, dtype=np.uint8)
print("shape:", gradient.shape)
print(gradient)
```

Each row is a line of pixels, and each column is a position across the image. Every model in this course reads images in this form.

## Predict the shape

```python predict id=predict-shape title="What is the shape of a 4 by 5 colour image?"
import numpy as np
print(np.zeros((4, 5, 3)).shape)
--- options
* (4, 5, 3)
(3, 4, 5)
(20, 3)
(4, 5)
--- explain
A colour image has height, width and three channels for red, green and blue. The first two numbers are the grid size, and the last is the channel count.
```

## Recap

- An image is an array with a height, a width and usually three colour channels.
- Convolutions, overlap measures and attention over patches are the building blocks of modern vision models.
- Measuring a model correctly matters as much as building it.

**Up next:** pixels and channels in detail, starting with grayscale and normalization.
', 1, '[]', '[{"title":"Faster R-CNN: Towards Real-Time Object Detection (Ren et al.)","url":"https://arxiv.org/abs/1506.01497"},{"title":"U-Net: Convolutional Networks for Biomedical Image Segmentation","url":"https://arxiv.org/abs/1505.04597"},{"title":"An Image is Worth 16x16 Words: Vision Transformers","url":"https://arxiv.org/abs/2010.11929"},{"title":"Learning Transferable Visual Models From Natural Language Supervision (CLIP)","url":"https://arxiv.org/abs/2103.00020"}]', '2026-06-25T07:12:46.269Z', '2026-10-19T07:12:46.269Z'),
('les_computer_vision_bootcamp_1_2', 'sec_computer_vision_bootcamp_1', 'crs_computer_vision_bootcamp', 'Pixels, channels and colour spaces', 'interactive', 1, 840, NULL, NULL, 'A colour image is a three-channel array: height, width, and one number per colour. Before any model sees an image, the values are often converted to a grayscale brightness, scaled to a fixed range and reordered into the layout the framework expects. This lesson covers each of those steps.

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
', 0, '[]', '[]', '2026-06-25T07:12:46.269Z', '2026-10-19T07:12:46.269Z'),
('les_computer_vision_bootcamp_1_3', 'sec_computer_vision_bootcamp_1', 'crs_computer_vision_bootcamp', 'Convolution: sliding a filter over an image', 'interactive', 2, 1080, NULL, NULL, 'A convolution slides a small kernel over an image and computes a weighted sum at each position. A kernel of fixed numbers can detect edges. A convolutional network learns many kernels from data, and this one operation is the core of almost every vision model.

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
Loop over every top-left position, take the image window of the kernel''s size, multiply elementwise by the kernel and sum.
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
', 0, '[]', '[]', '2026-06-25T07:12:46.269Z', '2026-10-19T07:12:46.269Z'),
('les_computer_vision_bootcamp_1_4', 'sec_computer_vision_bootcamp_1', 'crs_computer_vision_bootcamp', 'Augmentation that keeps labels correct', 'interactive', 3, 840, NULL, NULL, 'A model learns only from the variation its training images contain. Augmentation creates new plausible variants of each image: flipped, cropped or brightened. It is one of the cheapest ways to improve a vision model, and it works only when the label survives the change.

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
', 0, '[]', '[]', '2026-06-25T07:12:46.269Z', '2026-10-19T07:12:46.269Z'),
('les_computer_vision_bootcamp_2_1', 'sec_computer_vision_bootcamp_2', 'crs_computer_vision_bootcamp', 'CNN architectures, parameters and receptive fields', 'interactive', 0, 1080, NULL, NULL, 'A convolutional network stacks convolutions and downsampling, then ends with a classifier. Three numbers explain most of its behaviour: how many parameters each layer has, how the feature maps shrink, and how far each output can see in the original image. This lesson computes all three.

## Parameters of a convolution

A convolution with kernel size k, c_in input channels, c_out output channels and a bias has k × k × c_in × c_out weights plus one bias per output channel.

```python run
import numpy as np

def conv_params(k, c_in, c_out, bias=True):
    return k * k * c_in * c_out + (c_out if bias else 0)

print("3x3, 64 -> 128 channels:", conv_params(3, 64, 128))
print("1x1, 64 -> 64 channels:", conv_params(1, 64, 64))
```

A 1 by 1 convolution mixes channels without looking at neighbours, and it is cheap for exactly this reason.

## Shrinking the feature maps

A ResNet-style stem reduces a 224 by 224 image in three steps: a strided 7 by 7 convolution, a stride-2 pooling and a stride-2 convolution.

```python run
def out_size(n, k, p, s):
    return (n + 2 * p - k) // s + 1

size = 224
for name, k, p, s in [("7x7 conv, stride 2", 7, 3, 2), ("3x3 max pool, stride 2", 3, 1, 2), ("3x3 conv, stride 2", 3, 1, 2)]:
    size = out_size(size, k, p, s)
    print(f"after {name}: {size} x {size}")
```

## Receptive fields

The receptive field of an output is the region of the input that influences it. Each layer adds (k − 1) times the current jump, and stride multiplies the jump for the layers after it.

```python run
def receptive_field(layers):
    r, jump = 1, 1
    for k, s in layers:
        r += (k - 1) * jump
        jump *= s
    return r

print("three 3x3 convs, stride 1:", receptive_field([(3, 1)] * 3))
print("with one stride-2 layer in the middle:", receptive_field([(3, 1), (3, 2), (3, 1)]))
```

## Residual connections

A residual block adds its input back to the output of its layers. This gives gradients a direct path through the network, which is what made very deep networks trainable.

```python run
x = np.array([1.0, -2.0, 0.5])
W = np.array([[0.5, 0.0, 0.0], [0.0, 0.5, 0.0], [0.0, 0.0, 0.5]])

def relu(z):
    return np.maximum(z, 0)

plain = relu(W @ x)
residual = relu(W @ x + x)
print("plain block:", plain, "| residual block:", residual)
```

> **Pitfall:** deeper is not automatically better. A plain 56-layer network trains worse than a 20-layer one, which is the problem residual connections were designed to solve.

> **In the wild:** ResNet, EfficientNet and ConvNeXt are all built from these same ingredients, and their parameter counts and receptive fields are the numbers to compare when choosing one.

## Challenge: parameter count

```python exercise id=conv-params title="Parameters of a convolution"
# TODO: `conv_params(k, c_in, c_out)` returns the number of parameters of a k × k convolution with a bias: k × k × c_in × c_out
# weights plus c_out biases.
def conv_params(k, c_in, c_out):
    ...
--- solution
def conv_params(k, c_in, c_out):
    return k * k * c_in * c_out + c_out
--- test
result = conv_params(3, 64, 128)
assert result is not None, "Replace the `...` in `conv_params` with code that returns the count."
assert result == 73856, f"A 3 × 3 convolution from 64 to 128 channels has 9 × 64 × 128 + 128 = 73856 parameters, but you returned {result}."
assert conv_params(1, 64, 64) == 4160, "A 1 × 1 convolution from 64 to 64 channels has 4096 weights and 64 biases."
assert conv_params(3, 3, 16) == 448, "A 3 × 3 convolution from 3 to 16 channels has 432 weights and 16 biases."
--- hint
Multiply the kernel area by both channel counts, then add one bias per output channel.
--- hint
`return k * k * c_in * c_out + c_out`.
```

## Challenge: receptive field

```python exercise id=receptive-field title="Receptive field of a stack of layers"
# TODO: `receptive_field(layers)` takes a list of (k, s) pairs, one per layer, and returns the receptive field of one output.
# Start with r = 1 and jump = 1. For each layer add (k − 1) × jump to r, then multiply jump by the stride s.
def receptive_field(layers):
    ...
--- solution
def receptive_field(layers):
    r, jump = 1, 1
    for k, s in layers:
        r += (k - 1) * jump
        jump *= s
    return r
--- test
result = receptive_field([(3, 1), (3, 1), (3, 1)])
assert result is not None, "Replace the `...` in `receptive_field` with code that returns the field."
assert result == 7, f"Three stride-1 3 × 3 layers see 7 pixels, but you returned {result}."
assert receptive_field([(3, 1), (3, 2), (3, 1)]) == 9, "A stride-2 layer in the middle doubles the jump for the layer after it, giving 9."
assert receptive_field([(7, 2), (3, 2)]) == 11, "A 7 × 7 stride-2 layer followed by a 3 × 3 stride-2 layer gives 11."
--- hint
Keep the jump from before the current layer when you add to r, and update the jump afterwards.
--- hint
Inside the loop: `r += (k - 1) * jump`, then `jump *= s`.
```

## Debug: updating the jump too early

This receptive field should be 7 for two layers, the first with stride 2, but the jump is updated before it is used.

```python debug id=rf-order title="Use the jump before the stride changes it"
layers = [(3, 2), (3, 1)]
r, jump = 1, 1
for k, s in layers:
    jump *= s                  # bug: the jump is updated before the field grows
    r += (k - 1) * jump
print(r)
--- solution
layers = [(3, 2), (3, 1)]
r, jump = 1, 1
for k, s in layers:
    r += (k - 1) * jump
    jump *= s
print(r)
--- test
assert r == 7, f"The first layer adds 2, and the second adds 2 × 2 = 4 because the stride doubled the jump, giving 7. The code gives {r}. Add to r before you update the jump."
--- hint
The stride of a layer affects the layers that come after it, not the layer itself.
--- hint
Swap the two lines inside the loop.
```

## Predict the parameters

```python predict id=predict-params title="How many parameters does a 1 by 1 convolution from 64 to 64 channels have, with bias?"
print(1 * 1 * 64 * 64 + 64)
--- options
* 4160
4096
64
8256
--- explain
There are 64 × 64 = 4096 weights and 64 biases, which sum to 4160.
```

## Recap

- Parameters grow with the product of the channel counts and the kernel area.
- Strided layers shrink the feature maps, and the output size follows a simple formula.
- The receptive field grows with every layer and is multiplied by stride.
- Residual connections keep very deep networks trainable.

**Up next:** how a pretrained network is reused for a new task.
', 0, '[]', '[]', '2026-06-25T07:12:46.269Z', '2026-10-19T07:12:46.269Z'),
('les_computer_vision_bootcamp_2_2', 'sec_computer_vision_bootcamp_2', 'crs_computer_vision_bootcamp', 'Transfer learning and the linear probe', 'interactive', 1, 960, NULL, NULL, 'Training a vision network from scratch needs far more labelled images than most projects have. A backbone pretrained on a large dataset already encodes general features such as edges, textures and shapes. Reusing it means either training only a small head on its features, the linear probe, or updating the whole network with a smaller learning rate.

We cannot download a real pretrained network in this page, so the first cells use a fixed random projection followed by a ReLU as a stand-in for a frozen backbone. The method is the same either way.

## A frozen backbone

```python run
import numpy as np

rng = np.random.default_rng(1)
backbone_W = rng.normal(size=(20, 8))         # fixed weights, never trained

def extract(raw):
    return np.maximum(raw @ backbone_W, 0)

X_raw = np.vstack([rng.normal(0, 1, (60, 20)) + 1.0, rng.normal(0, 1, (60, 20)) - 1.0])
y = np.array([0] * 60 + [1] * 60)
feats = extract(X_raw)
print("feature shape:", feats.shape)
```

## Train the linear probe

The probe is a logistic regression on the frozen features. Only its weights and bias change during training.

```python run
def train_probe(X, y, steps=300, lr=0.1):
    W = np.zeros(X.shape[1])
    b = 0.0
    for _ in range(steps):
        p = 1 / (1 + np.exp(-(X @ W + b)))
        W -= lr * X.T @ (p - y) / len(y)
        b -= lr * np.mean(p - y)
    return W, b

scaled = feats / feats.std()
W, b = train_probe(scaled, y)
pred = (scaled @ W + b > 0).astype(int)
print("probe training accuracy:", round(float(np.mean(pred == y)), 3))
```

## Different learning rates for the backbone and the head

When the whole network is fine-tuned, the new head starts from random weights and needs a normal learning rate. The pretrained backbone should move slowly, so its learned features are not destroyed.

```python run
def finetune_lrs(base_lr, backbone_factor=0.1):
    return {"head": base_lr, "backbone": base_lr * backbone_factor}

print(finetune_lrs(0.01))
```

## A nearest-centroid check

A simpler method compares each example with the average feature of each class. It is a useful baseline, because a probe should beat it.

```python run
centroids = np.stack([feats[y == c].mean(axis=0) for c in [0, 1]])
dists = np.linalg.norm(feats[:, None, :] - centroids[None, :, :], axis=2)
proto_pred = dists.argmin(axis=1)
print("nearest-centroid accuracy:", round(float(np.mean(proto_pred == y)), 3))
```

> **Pitfall:** fine-tuning everything with a large learning rate erases the pretrained features in a few steps. Use a small backbone learning rate, or freeze the backbone first and unfreeze it later.

> **In the wild:** most production image classifiers start from an ImageNet or CLIP backbone. The team trains a head for a few epochs, then fine-tunes with a smaller learning rate if the accuracy justifies it.

## Challenge: linear probe prediction

```python exercise id=probe-predict title="Predict classes from a linear head"
import numpy as np

# TODO: `probe_predict(features, W, b)` returns the predicted class for each row of features: the index of the largest value
# of features @ W + b, where W has one column per class.
def probe_predict(features, W, b):
    ...
--- solution
import numpy as np

def probe_predict(features, W, b):
    scores = np.asarray(features, dtype=float) @ np.asarray(W, dtype=float) + np.asarray(b, dtype=float)
    return np.argmax(scores, axis=1)
--- test
import numpy as np
result = probe_predict(np.array([[1.0, 0.0], [0.0, 1.0]]), np.array([[1.0, 0.0], [0.0, 1.0]]), np.array([0.0, 0.0]))
assert result is not None, "Replace the `...` in `probe_predict` with code that returns the predictions."
assert result.tolist() == [0, 1], f"Row 0 scores [1, 0] and row 1 scores [0, 1], so the predictions are [0, 1], but you returned {result.tolist()}."
assert probe_predict(np.array([[2.0, 3.0]]), np.array([[1.0, 0.0], [0.0, 1.0]]), np.array([0.0, 0.0])).tolist() == [1], "Scores [2, 3] favour class 1."
--- hint
Compute the scores with a matrix product, add the bias, then take the argmax along the class axis.
--- hint
`np.argmax(scores, axis=1)`.
```

## Challenge: learning rates for fine-tuning

```python exercise id=finetune-lrs title="Separate learning rates for head and backbone"
# TODO: `finetune_lrs(base_lr, backbone_factor=0.1)` returns a dictionary with the key "head" set to base_lr and the key
# "backbone" set to base_lr times backbone_factor.
def finetune_lrs(base_lr, backbone_factor=0.1):
    ...
--- solution
def finetune_lrs(base_lr, backbone_factor=0.1):
    return {"head": base_lr, "backbone": base_lr * backbone_factor}
--- test
result = finetune_lrs(0.01)
assert result is not None, "Replace the `...` in `finetune_lrs` with code that returns the dictionary."
assert abs(result["head"] - 0.01) < 1e-12, "The head keeps the base learning rate."
assert abs(result["backbone"] - 0.001) < 1e-12, "The backbone gets a tenth of the base rate by default."
assert abs(finetune_lrs(0.1, 0.5)["backbone"] - 0.05) < 1e-12, "The factor should be a parameter."
--- hint
Build a dictionary literal with two keys.
--- hint
`return {"head": base_lr, "backbone": base_lr * backbone_factor}`.
```

## Debug: the wrong axis for the class choice

Each row is one image and each column is one class. The prediction should be the best class for each image, but the argmax runs down the columns instead.

```python debug id=argmax-axis title="Choose the best class for each image"
import numpy as np

scores = np.array([[0.0, 5.0, 1.0],     # image 0
                   [2.0, 0.0, 9.0]])    # image 1
pred = np.argmax(scores, axis=0)        # bug: the class axis is 1, not 0
print("predicted classes:", pred)
--- solution
import numpy as np

scores = np.array([[0.0, 5.0, 1.0],
                   [2.0, 0.0, 9.0]])
pred = np.argmax(scores, axis=1)
print("predicted classes:", pred)
--- test
assert pred.tolist() == [1, 2], f"Image 0 is best at class 1 and image 1 at class 2, so the prediction is [1, 2], but the code gives {pred.tolist()}."
--- hint
There are two images, so the result must have two entries.
--- hint
Take the argmax across the columns of each row, with `axis=1`.
```

## Predict the learning rate

```python predict id=predict-lr title="What is the backbone learning rate when the base rate is 0.01 and the factor is 0.1?"
print(round(0.01 * 0.1, 4))
--- options
* 0.001
0.01
0.1
0.0001
--- explain
A tenth of 0.01 is 0.001, which is the backbone rate the function returns.
```

## Recap

- A frozen backbone is a fixed feature extractor, and a linear probe is a trained head on top of it.
- Fine-tuning the whole network needs a smaller learning rate for the backbone than for the new head.
- A nearest-centroid baseline shows whether the head adds anything.

**Up next:** detection, where the model must also say where each object is.
', 0, '[]', '[]', '2026-06-25T07:12:46.269Z', '2026-10-19T07:12:46.269Z'),
('les_computer_vision_bootcamp_2_3', 'sec_computer_vision_bootcamp_2', 'crs_computer_vision_bootcamp', 'Checkpoint: classification', 'quiz', 2, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"Why does a frozen pretrained backbone with a small trained head work well on a small dataset?","options":["The head can memorize the whole dataset","The backbone already encodes general features, so the head needs to learn only the mapping to the new labels","Frozen weights train faster than any other weights","The learning rate is ignored"],"answerIndex":1,"explanation":"The pretrained features transfer, so few labelled examples are enough for the head."},{"id":"q2","prompt":"How long is the output of a convolution with kernel 3, stride 1, no padding, on a 32-pixel input?","options":["32","31","30","29"],"answerIndex":2,"explanation":"The output is (32 + 0 − 3) / 1 + 1 = 30."},{"id":"q3","prompt":"How many parameters does a 3 by 3 convolution from 16 to 32 channels have, including bias?","options":["4608","4640","512","4672"],"answerIndex":1,"explanation":"There are 9 × 16 × 32 = 4608 weights and 32 biases, which sum to 4640."},{"id":"q4","prompt":"Why must augmentations preserve the label?","options":["Otherwise the model learns from the wrong labels","Otherwise the images become larger","Otherwise the learning rate has to change","Otherwise the batch size is smaller"],"answerIndex":0,"explanation":"A transform that changes what the image shows, such as a crop that removes the object, teaches the model a wrong association."}]', '[]', '2026-06-25T07:12:46.269Z', '2026-10-19T07:12:46.269Z'),
('les_computer_vision_bootcamp_3_1', 'sec_computer_vision_bootcamp_3', 'crs_computer_vision_bootcamp', 'Bounding boxes, IoU and non-maximum suppression', 'interactive', 0, 960, NULL, NULL, 'Detection answers two questions: what is there and where. The "where" is a bounding box, written as corners (x1, y1, x2, y2). Two tools make detection workable. IoU measures how much two boxes overlap, and non-maximum suppression removes duplicate detections of the same object.

## Area and IoU

Intersection over union divides the overlap of two boxes by the area they cover together. It is 1 for identical boxes and 0 for boxes that do not touch.

```python run
import numpy as np

def area(b):
    return (b[2] - b[0]) * (b[3] - b[1])

def iou(a, b):
    ix = max(0.0, min(a[2], b[2]) - max(a[0], b[0]))
    iy = max(0.0, min(a[3], b[3]) - max(a[1], b[1]))
    inter = ix * iy
    return inter / (area(a) + area(b) - inter)

print("IoU of two overlapping squares:", round(iou([0, 0, 2, 2], [1, 1, 3, 3]), 4))
print("IoU of disjoint boxes:", iou([0, 0, 1, 1], [5, 5, 6, 6]))
```

The overlap of the two squares is 1 out of a union of 7, so the IoU is 1/7.

## Non-maximum suppression

A detector often produces several boxes around the same object. Non-maximum suppression keeps the highest-scoring box and discards any other box that overlaps it too much.

```python run
boxes = [[0, 0, 10, 10], [1, 1, 11, 11], [20, 20, 30, 30]]
scores = [0.9, 0.8, 0.7]
order = sorted(range(len(boxes)), key=lambda i: -scores[i])
keep = []
for i in order:
    if all(iou(boxes[i], boxes[j]) < 0.5 for j in keep):
        keep.append(i)
print("kept boxes:", keep)
```

The second box overlaps the first heavily and is removed. The third box is far away and survives.

## The threshold decides

The overlap of the duplicate with the top box is about 0.68. Whether it is removed depends on the threshold.

```python run
overlap = iou(boxes[0], boxes[1])
print("overlap of the duplicate:", round(overlap, 3))
for thr in [0.5, 0.8]:
    print(f"threshold {thr}: suppressed = {overlap >= thr}")
```

## IoU rewards the overlap, not the centre

Two boxes with the same centre can have a small IoU if their sizes differ, which is why IoU is used instead of the distance between centres.

```python run
print("same centre, one quarter the area:", round(iou([0, 0, 4, 4], [0, 0, 2, 2]), 3))
```

> **Pitfall:** the threshold for NMS is a trade-off. A low value removes real neighbouring objects in a crowd, and a high value keeps duplicates. Tune it on validation data, not by eye.

> **In the wild:** every object detector evaluated on COCO reports results at IoU thresholds from 0.5 to 0.95. A box that is only roughly right counts as a miss at the strict thresholds.

## Challenge: IoU

```python exercise id=iou title="Intersection over union of two boxes"
# TODO: `iou(a, b)` takes two boxes as [x1, y1, x2, y2] and returns the intersection area divided by the union area.
def iou(a, b):
    ...
--- solution
def iou(a, b):
    ix = max(0.0, min(a[2], b[2]) - max(a[0], b[0]))
    iy = max(0.0, min(a[3], b[3]) - max(a[1], b[1]))
    inter = ix * iy
    area_a = (a[2] - a[0]) * (a[3] - a[1])
    area_b = (b[2] - b[0]) * (b[3] - b[1])
    return inter / (area_a + area_b - inter)
--- test
result = iou([0, 0, 2, 2], [1, 1, 3, 3])
assert result is not None, "Replace the `...` in `iou` with code that returns the overlap."
assert abs(result - 1 / 7) < 1e-9, f"The overlap is 1 and the union is 7, so the IoU is 1/7, but you returned {result}."
assert abs(iou([0, 0, 2, 2], [0, 0, 2, 2]) - 1.0) < 1e-9, "Identical boxes have IoU 1."
assert iou([0, 0, 1, 1], [5, 5, 6, 6]) == 0.0, "Disjoint boxes have IoU 0."
--- hint
Intersection width is the smaller right edge minus the larger left edge, clipped at zero. Do the same for height.
--- hint
The union is the two areas minus the intersection, so the intersection is counted once.
```

## Challenge: non-maximum suppression

```python exercise id=nms title="Keep the best of each group of overlapping boxes"
# TODO: `nms(boxes, scores, thr)` returns the indices of the boxes to keep, in order of decreasing score. A box is removed if
# its IoU with an already kept box is at least thr. The helper `iou` below is provided.
def iou(a, b):
    ix = max(0.0, min(a[2], b[2]) - max(a[0], b[0]))
    iy = max(0.0, min(a[3], b[3]) - max(a[1], b[1]))
    inter = ix * iy
    area_a = (a[2] - a[0]) * (a[3] - a[1])
    area_b = (b[2] - b[0]) * (b[3] - b[1])
    return inter / (area_a + area_b - inter)

def nms(boxes, scores, thr):
    ...
--- solution
def iou(a, b):
    ix = max(0.0, min(a[2], b[2]) - max(a[0], b[0]))
    iy = max(0.0, min(a[3], b[3]) - max(a[1], b[1]))
    inter = ix * iy
    area_a = (a[2] - a[0]) * (a[3] - a[1])
    area_b = (b[2] - b[0]) * (b[3] - b[1])
    return inter / (area_a + area_b - inter)

def nms(boxes, scores, thr):
    order = sorted(range(len(boxes)), key=lambda i: -scores[i])
    keep = []
    for i in order:
        if all(iou(boxes[i], boxes[j]) < thr for j in keep):
            keep.append(i)
    return keep
--- test
result = nms([[0, 0, 10, 10], [1, 1, 11, 11], [20, 20, 30, 30]], [0.9, 0.8, 0.7], 0.5)
assert result is not None, "Replace the `...` in `nms` with code that returns the kept indices."
assert result == [0, 2], f"Box 1 overlaps box 0 with IoU 0.68, so it is removed. Expected [0, 2], but you returned {result}."
assert nms([[0, 0, 10, 10], [0, 0, 10, 10]], [0.3, 0.9], 0.5) == [1], "The higher-scoring box is kept, even when it comes second in the list."
assert nms([[0, 0, 10, 10], [1, 1, 11, 11]], [0.9, 0.8], 0.8) == [0, 1], "With a threshold of 0.8, the overlap of 0.68 does not suppress the second box."
--- hint
Sort the indices by score, highest first, then keep each box only if it does not overlap any box you already kept.
--- hint
`order = sorted(range(len(boxes)), key=lambda i: -scores[i])`, then use `all(...)` over the kept indices.
```

## Debug: the union

This IoU should be 1/7 for the two boxes, but it counts the intersection in the denominator twice.

```python debug id=iou-union title="Count the overlap once in the union"
a = [0, 0, 2, 2]
b = [1, 1, 3, 3]
ix = max(0.0, min(a[2], b[2]) - max(a[0], b[0]))
iy = max(0.0, min(a[3], b[3]) - max(a[1], b[1]))
inter = ix * iy
area_a = (a[2] - a[0]) * (a[3] - a[1])
area_b = (b[2] - b[0]) * (b[3] - b[1])
iou = inter / (area_a + area_b)          # bug: the union must subtract the overlap once
print(iou)
--- solution
a = [0, 0, 2, 2]
b = [1, 1, 3, 3]
ix = max(0.0, min(a[2], b[2]) - max(a[0], b[0]))
iy = max(0.0, min(a[3], b[3]) - max(a[1], b[1]))
inter = ix * iy
area_a = (a[2] - a[0]) * (a[3] - a[1])
area_b = (b[2] - b[0]) * (b[3] - b[1])
iou = inter / (area_a + area_b - inter)
print(iou)
--- test
assert abs(iou - 1 / 7) < 1e-9, f"The union is 4 + 4 − 1 = 7, so the IoU is 1/7, but the code gives {iou}. Subtract the intersection from the sum of the areas."
--- hint
The union of two shapes counts their overlap once.
--- hint
Denominator: `area_a + area_b - inter`.
```

## Predict the IoU

```python predict id=predict-iou title="What is the IoU of the box [0, 0, 2, 2] with the box [0, 0, 1, 1]?"
print(0.25)
--- options
* 0.25
0.5
1.0
0.75
--- explain
The small box lies inside the large one. Its area of 1 is the intersection, and the union is the large box''s area of 4. The IoU is 1/4.
```

## Recap

- A box is four numbers, and its area is the product of its width and height.
- IoU is the intersection over the union, and it is 1 for identical boxes.
- Non-maximum suppression keeps the highest-scoring box in each cluster of overlapping detections.

**Up next:** anchors, the grid of candidate boxes that detectors predict from.
', 0, '[]', '[]', '2026-06-25T07:12:46.269Z', '2026-10-19T07:12:46.269Z'),
('les_computer_vision_bootcamp_3_2', 'sec_computer_vision_bootcamp_3', 'crs_computer_vision_bootcamp', 'Anchors and one-stage versus two-stage detectors', 'interactive', 1, 1080, NULL, NULL, 'A detector must produce boxes in every position and at several sizes. Anchors are a fixed set of candidate boxes placed on a grid over the image, and the network predicts a small correction to each one. Two-stage detectors first propose regions and then classify them, while one-stage detectors predict directly from every anchor in a single pass.

## Anchor centres on a grid

A feature map with a stride of 8 pixels places one anchor centre at the middle of each 8 by 8 cell. The centre of cell (i, j) is at ((j + 0.5) × stride, (i + 0.5) × stride).

```python run
import numpy as np

def anchor_centers(h, w, stride):
    return [((j + 0.5) * stride, (i + 0.5) * stride) for i in range(h) for j in range(w)]

print(anchor_centers(2, 3, 8))
```

## Counting anchors

Each location holds several anchors, one per size and aspect ratio. The total is the number of locations times the anchors per location.

```python run
sizes = [16, 32]
n_anchors = len(anchor_centers(2, 3, 8)) * len(sizes)
print("anchors in a 2 x 3 grid with 2 sizes:", n_anchors)
```

## Decoding a prediction

The network predicts four numbers for each anchor: shifts of the centre relative to the anchor''s size, and log-scale changes of width and height. Decoding turns them back into a box.

```python run
def decode(anchor, deltas):
    cx, cy, w, h = anchor
    tx, ty, tw, th = deltas
    return (cx + tx * w, cy + ty * h, w * np.exp(tw), h * np.exp(th))

box = decode((10.0, 10.0, 4.0, 4.0), (0.5, 0.0, np.log(2), 0.0))
print([round(float(v), 3) for v in box])
```

## Objectness scores

A one-stage detector predicts an objectness logit for every anchor. A sigmoid turns it into a probability that the anchor contains an object.

```python run
logits = np.array([-2.0, 0.0, 3.0])
print("objectness:", np.round(1 / (1 + np.exp(-logits)), 3))
```

> **Pitfall:** anchor sizes must match the objects you expect. Anchors designed for pedestrians miss a long, thin object such as a pole, however well the network is trained.

> **In the wild:** one-stage detectors such as YOLO and SSD are chosen when speed matters, and two-stage detectors such as Faster R-CNN when accuracy matters more than latency. Many modern detectors have dropped anchors altogether for anchor-free predictions.

## Challenge: anchor centres

```python exercise id=anchor-centers title="Anchor centres on a grid"
# TODO: `anchor_centers(h, w, stride)` returns a list of (cx, cy) tuples, one per grid cell, row by row. The centre of cell
# (i, j) is ((j + 0.5) × stride, (i + 0.5) × stride).
def anchor_centers(h, w, stride):
    ...
--- solution
def anchor_centers(h, w, stride):
    return [((j + 0.5) * stride, (i + 0.5) * stride) for i in range(h) for j in range(w)]
--- test
result = anchor_centers(1, 2, 4)
assert result is not None, "Replace the `...` in `anchor_centers` with code that returns the centres."
assert result == [(2.0, 2.0), (6.0, 2.0)], f"A 1 × 2 grid with stride 4 has centres (2, 2) and (6, 2), but you returned {result}."
assert len(anchor_centers(3, 4, 8)) == 12, "A 3 × 4 grid has 12 centres."
--- hint
Loop over the rows and then the columns, and use the half-cell offset.
--- hint
`[((j + 0.5) * stride, (i + 0.5) * stride) for i in range(h) for j in range(w)]`.
```

## Challenge: decode a box

```python exercise id=decode-box title="Decode a predicted box"
import numpy as np

# TODO: `decode_box(anchor, deltas)` takes an anchor (cx, cy, w, h) and deltas (tx, ty, tw, th) and returns the predicted box
# (cx + tx × w, cy + ty × h, w × exp(tw), h × exp(th)).
def decode_box(anchor, deltas):
    ...
--- solution
import numpy as np

def decode_box(anchor, deltas):
    cx, cy, w, h = anchor
    tx, ty, tw, th = deltas
    return (cx + tx * w, cy + ty * h, w * np.exp(tw), h * np.exp(th))
--- test
import numpy as np
result = decode_box((10.0, 10.0, 4.0, 4.0), (0.5, 0.0, np.log(2), 0.0))
assert result is not None, "Replace the `...` in `decode_box` with code that returns the box."
assert np.allclose(result, [12.0, 10.0, 8.0, 4.0]), f"With tx = 0.5 and tw = log 2 the box should be (12, 10, 8, 4), but you returned {result}."
assert np.allclose(decode_box((0.0, 0.0, 2.0, 2.0), (0.0, 0.0, 0.0, 0.0)), [0.0, 0.0, 2.0, 2.0]), "Zero deltas leave the anchor unchanged."
--- hint
The shifts are relative to the anchor''s width and height, and the sizes are scaled by exp of the deltas.
--- hint
Multiply the width by `np.exp(tw)`, not add to it.
```

## Debug: the size correction

The width should be scaled by exp(tw), but the code adds it instead.

```python debug id=decode-scale title="Scale the width, don''t shift it"
import numpy as np

anchor = (10.0, 10.0, 4.0, 4.0)
tw = np.log(2)
w_pred = anchor[2] + np.exp(tw)       # bug: the width is shifted, not scaled
print("predicted width:", round(float(w_pred), 3))
--- solution
import numpy as np

anchor = (10.0, 10.0, 4.0, 4.0)
tw = np.log(2)
w_pred = anchor[2] * np.exp(tw)
print("predicted width:", round(float(w_pred), 3))
--- test
assert abs(w_pred - 8.0) < 1e-9, f"Doubling a width of 4 gives 8, but the code gives {w_pred}. The log-scale delta multiplies the width."
--- hint
exp(log 2) is 2, so the width should be multiplied by 2.
--- hint
Use `anchor[2] * np.exp(tw)`.
```

## Predict the anchor count

```python predict id=predict-anchors title="How many anchors does a 2 by 3 grid with 2 anchors per location have?"
print(2 * 3 * 2)
--- options
* 12
6
3
9
--- explain
There are 6 locations, and each one has 2 anchors, so 12 anchors in all.
```

## Recap

- Anchors are a fixed grid of candidate boxes, and the total count is locations times anchors per location.
- A detector predicts shifts and log-scale changes for each anchor, which decode into boxes.
- One-stage detectors predict from every anchor directly. Two-stage detectors first propose regions and then refine them.

**Up next:** how the training targets and losses are built for a detector.
', 0, '[]', '[]', '2026-06-25T07:12:46.269Z', '2026-10-19T07:12:46.269Z'),
('les_computer_vision_bootcamp_3_3', 'sec_computer_vision_bootcamp_3', 'crs_computer_vision_bootcamp', 'Training a detector: targets and losses', 'interactive', 2, 1080, NULL, NULL, 'A detector is trained by deciding, for every anchor, what it should predict. Anchors that overlap a real object strongly become positives and learn to classify and regress to that object. Anchors that overlap nothing become negatives and learn to say "background". Anchors in between are ignored. The losses then measure both decisions and the box corrections for the positives.

## Assign anchors to objects

An anchor is positive when its IoU with a ground-truth box is at least 0.5, negative when it is below 0.4, and ignored otherwise.

```python run
import numpy as np

def area(b):
    return (b[2] - b[0]) * (b[3] - b[1])

def iou(a, b):
    ix = max(0.0, min(a[2], b[2]) - max(a[0], b[0]))
    iy = max(0.0, min(a[3], b[3]) - max(a[1], b[1]))
    inter = ix * iy
    return inter / (area(a) + area(b) - inter)

anchors = [[0, 0, 10, 10], [2, 2, 12, 12], [30, 30, 40, 40], [0, 0, 4, 4]]
gt = [0, 0, 10, 10]
ious = [iou(a, gt) for a in anchors]
labels = [1 if v >= 0.5 else (0 if v < 0.4 else -1) for v in ious]
print("IoUs:", [round(v, 3) for v in ious])
print("labels (1 positive, 0 negative, -1 ignored):", labels)
```

The second anchor overlaps by 0.47, which is between the thresholds, so it is ignored and does not push the model either way.

## Smooth L1 for box corrections

Box corrections are regressed with the smooth L1 loss. It is quadratic for small errors, which gives a smooth gradient near zero, and linear for large errors, so an outlier does not dominate training.

```python run
def smooth_l1(x):
    x = np.asarray(x, dtype=float)
    return np.where(np.abs(x) < 1, 0.5 * x ** 2, np.abs(x) - 0.5)

print(smooth_l1([0.0, 0.5, 2.0]))
```

## Count the training signal

The classification loss uses positives and negatives, and the box loss uses only positives.

```python run
labels_demo = np.array(labels)
print("positives:", int(np.sum(labels_demo == 1)),
      "| negatives:", int(np.sum(labels_demo == 0)),
      "| ignored:", int(np.sum(labels_demo == -1)))
```

## Localization loss on positives only

Background anchors have no object to regress to, so their box loss is set to zero.

```python run
rng = np.random.default_rng(2)
box_err = rng.normal(0, 1, (4, 4))
loc_loss = smooth_l1(box_err).sum(axis=1)
loc_loss = np.where(labels_demo == 1, loc_loss, 0.0)
print("localization loss per anchor:", np.round(loc_loss, 3))
```

The full training step in a framework is shown below as static code for you to run locally. It combines the same two losses.

```python
import torch
import torch.nn.functional as F
import torchvision

model = torchvision.models.detection.fasterrcnn_resnet50_fpn(weights="DEFAULT")
model.train()
optimizer = torch.optim.SGD(model.parameters(), lr=0.01, momentum=0.9)

for images, targets in train_loader:          # targets hold boxes and class labels
    losses = model(images, targets)           # returns classification and box losses
    loss = sum(losses.values())
    optimizer.zero_grad()
    loss.backward()
    optimizer.step()
```

> **Pitfall:** if negatives vastly outnumber positives, the classifier learns to predict background everywhere and still scores well on accuracy. Detectors cap or reweight negatives for this reason.

> **In the wild:** the same assignment rule, with a few variations, is used by most anchor-based detectors. Checking how many anchors are positive per image is one of the first things to look at when a new detector fails to learn.

## Challenge: smooth L1

```python exercise id=smooth-l1 title="The smooth L1 loss of one value"
# TODO: `smooth_l1(x)` returns 0.5 × x² when |x| < 1 and |x| − 0.5 otherwise, for a single number x.
def smooth_l1(x):
    ...
--- solution
def smooth_l1(x):
    return 0.5 * x * x if abs(x) < 1 else abs(x) - 0.5
--- test
result = smooth_l1(0.5)
assert result is not None, "Replace the `...` in `smooth_l1` with code that returns the loss."
assert abs(result - 0.125) < 1e-9, f"For x = 0.5 the loss is 0.5 × 0.25 = 0.125, but you returned {result}."
assert abs(smooth_l1(2.0) - 1.5) < 1e-9, "For x = 2 the loss is 2 − 0.5 = 1.5."
assert abs(smooth_l1(-2.0) - 1.5) < 1e-9, "The loss is symmetric in the sign of x."
--- hint
Check whether the absolute value is below one first, then pick the matching formula.
--- hint
`return 0.5 * x * x if abs(x) < 1 else abs(x) - 0.5`.
```

## Challenge: assign labels

```python exercise id=assign-labels title="Positive, negative or ignored anchors"
# TODO: `assign_labels(ious)` takes a list of IoU values and returns 1 for each value of at least 0.5, 0 for each value below
# 0.4, and -1 for the values in between.
def assign_labels(ious):
    ...
--- solution
def assign_labels(ious):
    return [1 if v >= 0.5 else (0 if v < 0.4 else -1) for v in ious]
--- test
result = assign_labels([0.6, 0.45, 0.2])
assert result is not None, "Replace the `...` in `assign_labels` with code that returns the labels."
assert result == [1, -1, 0], f"0.6 is positive, 0.45 is ignored and 0.2 is negative, so the labels are [1, -1, 0], but you returned {result}."
assert assign_labels([0.5, 0.4]) == [1, -1], "A value of exactly 0.5 is positive, and exactly 0.4 is ignored."
--- hint
Check the high threshold first, then the low one.
--- hint
Use a conditional expression for each value: `1 if v >= 0.5 else (0 if v < 0.4 else -1)`.
```

## Debug: a threshold that excludes the boundary

Anchors whose IoU is exactly 0.5 should count as positive, but the comparison leaves them out.

```python debug id=threshold-edge title="Include the boundary in the positive threshold"
import numpy as np

ious = np.array([0.5, 0.2])
labels = np.where(ious > 0.5, 1, 0)         # bug: the positive threshold is inclusive
print(labels)
--- solution
import numpy as np

ious = np.array([0.5, 0.2])
labels = np.where(ious >= 0.5, 1, 0)
print(labels)
--- test
assert labels.tolist() == [1, 0], f"An IoU of exactly 0.5 is positive, so the labels should be [1, 0], but the code gives {labels.tolist()}. Use >= for the positive threshold."
--- hint
The rule is ''at least 0.5'', which includes 0.5.
--- hint
Replace `>` with `>=`.
```

## Predict the loss

```python predict id=predict-smooth title="What does smooth L1 give for x = 0.5?"
print(0.5 * 0.5 ** 2)
--- options
* 0.125
0.25
0.5
1.0
--- explain
Since 0.5 is below one, the quadratic branch applies: 0.5 × 0.5² = 0.125.
```

## Recap

- Anchors are positive above an IoU of 0.5, negative below 0.4, and ignored in between.
- The classification loss uses positives and negatives, and the box loss uses positives only.
- Smooth L1 keeps large box errors from dominating training.

**Up next:** segmentation, which labels every pixel instead of drawing boxes.
', 0, '[]', '[]', '2026-06-25T07:12:46.269Z', '2026-10-19T07:12:46.269Z'),
('les_computer_vision_bootcamp_3_4', 'sec_computer_vision_bootcamp_3', 'crs_computer_vision_bootcamp', 'Checkpoint: detection', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"What is the IoU of two identical boxes?","options":["0","0.5","1","The area of the box"],"answerIndex":2,"explanation":"The intersection equals the union when the boxes are identical, so IoU is 1."},{"id":"q2","prompt":"What does non-maximum suppression do?","options":["It removes lower-scoring boxes that overlap a higher-scoring kept box","It removes the highest-scoring box","It enlarges every box","It normalizes the image"],"answerIndex":0,"explanation":"NMS keeps the best detection in each cluster of overlapping boxes."},{"id":"q3","prompt":"Which anchors are positive in a typical anchor-based detector?","options":["Anchors with IoU of at least 0.5 with a ground-truth box","Every anchor in the image","Anchors with IoU below 0.4","The anchors at the image border"],"answerIndex":0,"explanation":"Positive anchors overlap an object strongly, and negative anchors overlap none."},{"id":"q4","prompt":"Why is smooth L1 used for box regression?","options":["It is quadratic for small errors and linear for large ones, so outliers have less effect","It is always zero","It removes the need for anchors","It doubles the box size"],"answerIndex":0,"explanation":"The loss behaves like squared error near zero and like absolute error for large errors."}]', '[]', '2026-06-25T07:12:46.269Z', '2026-10-19T07:12:46.269Z'),
('les_computer_vision_bootcamp_4_1', 'sec_computer_vision_bootcamp_4', 'crs_computer_vision_bootcamp', 'Semantic and instance segmentation', 'interactive', 0, 840, NULL, NULL, 'Segmentation labels pixels instead of drawing boxes. Semantic segmentation gives every pixel a class, so all people in a photo share one "person" label. Instance segmentation also separates individual objects, so each person gets a different id. This lesson measures segmentation quality with pixel accuracy and per-class IoU.

## Pixel accuracy

A label map has one class per pixel. Pixel accuracy is the share of pixels where the prediction matches the ground truth.

```python run
import numpy as np

gt = np.array([[0, 0, 1],
               [0, 1, 1],
               [2, 2, 1]])
pred = np.array([[0, 1, 1],
                 [0, 1, 1],
                 [2, 2, 2]])
print("pixel accuracy:", round(float(np.mean(gt == pred)), 3))
```

Two pixels disagree, so the accuracy is 7 out of 9.

## Per-class IoU

Pixel accuracy is dominated by large background regions. The IoU of each class compares the pixels predicted as that class with the ground-truth pixels of that class.

```python run
def class_iou(pred, gt, c):
    p, g = pred == c, gt == c
    union = np.sum(p | g)
    return float(np.sum(p & g) / union) if union else 1.0

for c in [0, 1, 2]:
    print(f"class {c} IoU: {class_iou(pred, gt, c):.3f}")
```

## Mean IoU

The mean IoU averages the per-class scores, so a small class counts as much as a large one.

```python run
print("mean IoU:", round(float(np.mean([class_iou(pred, gt, c) for c in [0, 1, 2]])), 3))
```

## Semantic and instance maps

A semantic map merges objects of the same class. An instance map keeps them apart.

```python run
inst_map = np.array([[1, 1, 0, 2, 2]])        # two separate objects of the same class
semantic = np.where(inst_map > 0, 1, 0)       # the semantic map merges them
print("semantic map:", semantic, "| instance ids:", np.unique(inst_map[inst_map > 0]))
```

> **Pitfall:** pixel accuracy can look excellent on a segmentation task where one class covers most of the image. Always report per-class IoU alongside it.

> **In the wild:** medical imaging teams report Dice and IoU for each organ or lesion, because a model that finds the liver well and misses the small tumour is not acceptable.

## Challenge: class IoU

```python exercise id=class-iou title="IoU of one class in a label map"
import numpy as np

# TODO: `class_iou(pred, gt, c)` returns the IoU of class c between two label maps: the pixels where both are c divided by
# the pixels where either is c. If neither map contains class c, return 1.0.
def class_iou(pred, gt, c):
    ...
--- solution
import numpy as np

def class_iou(pred, gt, c):
    p, g = np.asarray(pred) == c, np.asarray(gt) == c
    union = np.sum(p | g)
    return float(np.sum(p & g) / union) if union else 1.0
--- test
import numpy as np
result = class_iou(np.array([[1, 0]]), np.array([[1, 1]]), 1)
assert result is not None, "Replace the `...` in `class_iou` with code that returns the IoU."
assert abs(result - 0.5) < 1e-9, f"Class 1 covers one pixel in both maps and two in the union, so the IoU is 0.5, but you returned {result}."
assert class_iou(np.array([[1, 0]]), np.array([[1, 1]]), 0) == 0.0, "Class 0 is predicted once and never in the ground truth, so its IoU is zero."
assert class_iou(np.array([[1, 0]]), np.array([[1, 1]]), 2) == 1.0, "A class that appears in neither map scores 1.0."
--- hint
Build two boolean masks, one for each map, then take the sum of the intersection over the sum of the union.
--- hint
`np.sum(p & g) / np.sum(p | g)`.
```

## Challenge: mean IoU

```python exercise id=mean-iou title="Mean IoU over classes"
import numpy as np

def class_iou(pred, gt, c):
    p, g = np.asarray(pred) == c, np.asarray(gt) == c
    union = np.sum(p | g)
    return float(np.sum(p & g) / union) if union else 1.0

# TODO: `mean_iou(pred, gt, classes)` returns the average of class_iou over the classes in the list. The helper above is provided.
def mean_iou(pred, gt, classes):
    ...
--- solution
import numpy as np

def class_iou(pred, gt, c):
    p, g = np.asarray(pred) == c, np.asarray(gt) == c
    union = np.sum(p | g)
    return float(np.sum(p & g) / union) if union else 1.0

def mean_iou(pred, gt, classes):
    return float(np.mean([class_iou(pred, gt, c) for c in classes]))
--- test
import numpy as np
pred = np.array([[0, 1, 1], [0, 1, 1], [2, 2, 2]])
gt = np.array([[0, 0, 1], [0, 1, 1], [2, 2, 1]])
result = mean_iou(pred, gt, [0, 1, 2])
assert result is not None, "Replace the `...` in `mean_iou` with code that returns the mean."
assert abs(result - (2 / 3 + 0.6 + 2 / 3) / 3) < 1e-9, f"The per-class IoUs are 2/3, 0.6 and 2/3, so the mean is about 0.644, but you returned {result}."
--- hint
Use a list comprehension over the classes and take the mean.
--- hint
`float(np.mean([class_iou(pred, gt, c) for c in classes]))`.
```

## Debug: the intersection

This class IoU should count the pixels where both maps say class 1, but the intersection uses the union operator.

```python debug id=or-not-and title="Intersect the masks, don''t join them"
import numpy as np

pred = np.array([[1, 1], [0, 0]])
gt = np.array([[1, 0], [0, 0]])
inter = np.sum((pred == 1) | (gt == 1))     # bug: this is the union, not the intersection
union = np.sum((pred == 1) | (gt == 1))
print("IoU of class 1:", inter / union)
--- solution
import numpy as np

pred = np.array([[1, 1], [0, 0]])
gt = np.array([[1, 0], [0, 0]])
inter = np.sum((pred == 1) & (gt == 1))
union = np.sum((pred == 1) | (gt == 1))
print("IoU of class 1:", inter / union)
--- test
assert abs(inter / union - 0.5) < 1e-9, f"One pixel is in both masks and two are in the union, so the IoU is 0.5, but the code gives {inter / union}. The intersection uses &, not |."
--- hint
The intersection keeps only the pixels that are in both masks.
--- hint
Use `&` for the intersection.
```

## Predict the IoU of identical masks

```python predict id=predict-same title="What is the IoU of a mask with itself?"
import numpy as np
p = np.array([1, 0, 1])
print(np.sum(p & p) / np.sum(p | p))
--- options
* 1.0
0.5
0.0
2.0
--- explain
Every pixel is in both the intersection and the union, so the ratio is exactly one.
```

## Recap

- Pixel accuracy is simple but dominated by large classes, so per-class IoU is the better measure.
- Mean IoU averages over classes, so small classes count as much as large ones.
- Semantic maps merge objects of one class, and instance maps keep them separate.

**Up next:** U-Net, the network that produces these pixel labels.
', 0, '[]', '[]', '2026-06-25T07:12:46.269Z', '2026-10-19T07:12:46.269Z'),
('les_computer_vision_bootcamp_4_2', 'sec_computer_vision_bootcamp_4', 'crs_computer_vision_bootcamp', 'U-Net: encoders, decoders and skip connections', 'interactive', 1, 1200, NULL, NULL, 'Segmentation needs a label for every pixel, but a classifier''s deep features are small. U-Net solves this with two halves. The encoder downsamples, which builds context and receptive field. The decoder upsamples back to full resolution, and skip connections copy detail from the encoder straight across. This lesson builds the three operations that make the design work.

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
', 0, '[]', '[]', '2026-06-25T07:12:46.269Z', '2026-10-19T07:12:46.269Z'),
('les_computer_vision_bootcamp_4_3', 'sec_computer_vision_bootcamp_4', 'crs_computer_vision_bootcamp', 'Checkpoint: segmentation', 'quiz', 2, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"What distinguishes instance segmentation from semantic segmentation?","options":["It predicts boxes instead of pixels","It separates individual objects of the same class","It uses no class labels","It is always faster"],"answerIndex":1,"explanation":"A semantic map gives all people one label, while an instance map gives each person a separate id."},{"id":"q2","prompt":"Why report per-class IoU alongside pixel accuracy?","options":["Pixel accuracy is dominated by large classes and can hide failures on small ones","Pixel accuracy cannot be computed","Per-class IoU is always higher","Per-class IoU ignores the background"],"answerIndex":0,"explanation":"A model that ignores a small but important class can still score high pixel accuracy."},{"id":"q3","prompt":"What is the purpose of skip connections in U-Net?","options":["They restore fine spatial detail lost during downsampling","They remove the need for a decoder","They make the network smaller","They replace the loss function"],"answerIndex":0,"explanation":"Concatenating encoder features gives the decoder the detail that pooling discarded."},{"id":"q4","prompt":"When is Dice loss a good choice?","options":["For small foreground regions, where overlap matters more than background accuracy","Only for classification","Only for images without labels","Never, because it is always zero"],"answerIndex":0,"explanation":"Dice measures overlap directly, so it is not overwhelmed by the large background."}]', '[]', '2026-06-25T07:12:46.269Z', '2026-10-19T07:12:46.269Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_computer_vision_bootcamp_5_1', 'sec_computer_vision_bootcamp_5', 'crs_computer_vision_bootcamp', 'Vision transformers: patches and positions', 'interactive', 0, 960, NULL, NULL, 'A vision transformer does not slide filters over the image. It cuts the image into square patches, turns each patch into a vector, and treats the patches as a sequence of tokens for a standard transformer. Once the patches are tokens, attention lets every patch look at every other patch.

## Cutting an image into patches

A 4 by 4 patch grid on an 8 by 8 image takes four blocks of 16 pixels. Reshaping and transposing puts each block''s pixels in one row.

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

Each flattened patch is multiplied by a learned matrix to produce a token of the model''s width.

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
', 0, '[]', '[]', '2026-06-25T07:12:46.269Z', '2026-10-19T07:12:46.269Z'),
('les_computer_vision_bootcamp_5_2', 'sec_computer_vision_bootcamp_5', 'crs_computer_vision_bootcamp', 'CLIP and zero-shot classification', 'interactive', 1, 960, NULL, NULL, 'Most classifiers are trained for a fixed list of labels, so adding a new category means collecting new data. CLIP takes a different route. It is trained so that an image and a text describing it land near each other in one shared embedding space. To classify with it, you write the candidate labels as sentences, embed them, and pick the sentence closest to the image. No new training is needed.

## Cosine similarity

The similarity used in CLIP is the cosine of the angle between two embeddings. Normalizing each vector to length one turns a dot product into that cosine.

```python run
import numpy as np

def normalize(v):
    return v / np.linalg.norm(v, axis=-1, keepdims=True)

image = normalize(np.array([1.0, 0.0]))
texts = normalize(np.array([[1.0, 0.0], [0.0, 1.0], [-1.0, 0.0]]))
print("cosine similarities:", np.round(texts @ image, 3))
```

A text pointing the same way as the image scores 1, a perpendicular text scores 0, and an opposite text scores −1.

## Scaling the similarities

CLIP multiplies the similarities by a large temperature-like scale before the softmax. The scale turns small differences in angle into confident probabilities.

```python run
def softmax(z):
    e = np.exp(z - z.max())
    return e / e.sum()

sims = texts @ image
print("probabilities with scale 100:", np.round(softmax(100 * sims), 4))
```

## Zero-shot classification

Each class is written as a prompt, and the label with the most similar text embedding wins.

```python run
labels = ["a photo of a cat", "a photo of a dog", "a photo of a car"]
text_emb = normalize(np.array([[0.9, 0.1], [0.1, 0.9], [-0.5, -0.5]]))
img_emb = normalize(np.array([0.2, 0.8]))
best = int(np.argmax(text_emb @ img_emb))
print("zero-shot label:", labels[best])
```

## Similarities among the prompts

The embedding of each text is most similar to itself, which is a sanity check on the normalization.

```python run
sim = text_emb @ text_emb.T
print("text-text similarity on the diagonal:", np.round(np.diag(sim), 3))
```

The CLIP model is shown below as static code, with its image and text encoders and the scaled similarity.

```python
import torch
import clip   # the openai/CLIP package

model, preprocess = clip.load("ViT-B/32")
labels = ["a photo of a cat", "a photo of a dog", "a photo of a car"]
image = preprocess(pil_image).unsqueeze(0)
text = clip.tokenize(labels)

with torch.no_grad():
    logits_per_image, _ = model(image, text)
    probs = logits_per_image.softmax(dim=-1)
```

> **Pitfall:** the wording of the prompt changes the result. "a photo of a dog" often beats the bare word "dog", and a prompt that names a rare category badly may fail completely. Test several templates on your own data.

> **In the wild:** CLIP-style models power image search over large photo libraries, where the query is typed text and no labelled set exists for the query.

## Challenge: cosine similarity

```python exercise id=cosine title="Cosine similarity of two vectors"
import numpy as np

# TODO: `cosine(u, v)` returns the cosine of the angle between two vectors: their dot product divided by the product of their lengths.
def cosine(u, v):
    ...
--- solution
import numpy as np

def cosine(u, v):
    u = np.asarray(u, dtype=float)
    v = np.asarray(v, dtype=float)
    return float(u @ v / (np.linalg.norm(u) * np.linalg.norm(v)))
--- test
import numpy as np
result = cosine([1.0, 0.0], [0.0, 1.0])
assert result is not None, "Replace the `...` in `cosine` with code that returns the value."
assert abs(result) < 1e-9, "Perpendicular vectors have cosine zero."
assert abs(cosine([1.0, 1.0], [2.0, 2.0]) - 1.0) < 1e-9, "Vectors that point the same way have cosine one, whatever their lengths."
assert abs(cosine([1.0, 0.0], [-1.0, 0.0]) + 1.0) < 1e-9, "Opposite vectors have cosine minus one."
--- hint
Compute the dot product, then divide by the two lengths.
--- hint
`u @ v / (np.linalg.norm(u) * np.linalg.norm(v))`.
```

## Challenge: zero-shot prediction

```python exercise id=zero-shot title="Pick the most similar text"
import numpy as np

# TODO: `zero_shot_predict(img_emb, text_embs)` returns the index of the text embedding with the highest cosine similarity to
# the image embedding. text_embs is a list of vectors, one per label.
def zero_shot_predict(img_emb, text_embs):
    ...
--- solution
import numpy as np

def zero_shot_predict(img_emb, text_embs):
    img = np.asarray(img_emb, dtype=float)
    texts = np.asarray(text_embs, dtype=float)
    img = img / np.linalg.norm(img)
    texts = texts / np.linalg.norm(texts, axis=1, keepdims=True)
    return int(np.argmax(texts @ img))
--- test
result = zero_shot_predict([1.0, 0.0], [[0.0, 1.0], [1.0, 0.1], [-1.0, 0.0]])
assert result is not None, "Replace the `...` in `zero_shot_predict` with code that returns the index."
assert result == 1, f"The second text is almost parallel to the image, so the index should be 1, but you returned {result}."
assert zero_shot_predict([0.0, 1.0], [[1.0, 0.0], [5.0, 5.0]]) == 1, "Compare cosines, not raw dot products, so [5, 5] does not win by length alone."
--- hint
Normalize the image and each text, then take the argmax of the matrix product.
--- hint
Use `texts @ img` after both are normalized.
```

## Debug: a missing normalization

The score should be the cosine, which is 0.6 for these two vectors, but the text vector is not normalized, so the score scales with its length.

```python debug id=unnormalized title="Normalize the text, not only the image"
import numpy as np

img = np.array([1.0, 0.0])
txt = np.array([3.0, 4.0])
score = img @ txt / np.linalg.norm(img)      # bug: the text is not normalized
print("score:", score)
--- solution
import numpy as np

img = np.array([1.0, 0.0])
txt = np.array([3.0, 4.0])
score = img @ txt / (np.linalg.norm(img) * np.linalg.norm(txt))
print("score:", score)
--- test
assert abs(score - 0.6) < 1e-9, f"The cosine of [1, 0] and [3, 4] is 3 / 5 = 0.6, but the code gives {score}. Divide by the length of both vectors."
--- hint
The length of [3, 4] is 5.
--- hint
Divide by the product of both norms.
```

## Predict the probability

```python predict id=predict-clip title="What is the softmax probability of the first class when two logits are both zero?"
import numpy as np
z = np.zeros(2)
print(round(float(np.exp(z[0]) / np.exp(z).sum()), 2))
--- options
* 0.5
1.0
0.27
0.73
--- explain
Equal logits give equal probabilities, so two classes share the mass evenly, one half each.
```

## Recap

- CLIP places images and texts in one space, and the similarity is the cosine of their embeddings.
- Zero-shot classification picks the label whose prompt embedding is closest to the image.
- Normalize both sides, and the dot product becomes the cosine.

**Up next:** the capstone, where you evaluate a detector''s output with the metrics from this course.
', 0, '[]', '[]', '2026-06-25T07:12:46.269Z', '2026-10-19T07:12:46.269Z'),
('les_computer_vision_bootcamp_5_3', 'sec_computer_vision_bootcamp_5', 'crs_computer_vision_bootcamp', 'Capstone: evaluating a detector', 'interactive', 2, 1440, NULL, NULL, 'This capstone evaluates a detector the way a benchmark does. A detection counts as correct when its box overlaps a ground-truth box with IoU of at least 0.5, and each ground-truth box can be matched only once. Sorting the detections by score and matching greedily gives true positives and false positives, from which precision, recall and average precision follow.

## The detections

We start with one image: two ground-truth objects and four detections with their scores. The helper function is the IoU from the detection lesson.

```python run
import numpy as np

def iou_box(a, b):
    ix = max(0.0, min(a[2], b[2]) - max(a[0], b[0]))
    iy = max(0.0, min(a[3], b[3]) - max(a[1], b[1]))
    inter = ix * iy
    union = (a[2] - a[0]) * (a[3] - a[1]) + (b[2] - b[0]) * (b[3] - b[1]) - inter
    return inter / union

gts = [[0, 0, 10, 10], [20, 20, 30, 30]]
dets = [([1, 1, 11, 11], 0.9), ([50, 50, 60, 60], 0.8), ([21, 21, 31, 31], 0.7), ([0, 0, 10, 10], 0.6)]
for box, score in dets:
    print(score, [round(iou_box(box, g), 3) for g in gts])
```

The first detection overlaps the first ground truth with IoU 0.68. The fourth detection also covers that ground truth, but it arrives after the first one has claimed it.

## Precision and recall

Given a list of true-positive flags, precision is the share of detections that are correct, and recall is the share of ground-truth objects found.

```python run
flags = [1, 0, 1, 0]
n_gt = 3
tp = sum(flags)
print("precision:", round(tp / len(flags), 3), "| recall:", round(tp / n_gt, 3))
```

Two of four detections are correct, and two of three objects are found.

## Average precision

Average precision averages the precision at each rank where a true positive appears, then divides by the number of ground-truth objects. Missed objects therefore lower the score.

```python run
ap_tp = 0
ap = 0.0
for k, f in enumerate(flags, start=1):
    if f:
        ap_tp += 1
        ap += ap_tp / k
print("average precision:", round(ap / n_gt, 4))
```

## Precision as the list grows

Reading down the ranked list shows how precision and recall change with the number of detections kept.

```python run
running_tp = 0
for k, f in enumerate(flags, start=1):
    running_tp += f
    print(f"top {k}: precision {running_tp / k:.2f}, recall {running_tp / n_gt:.2f}")
```

> **Pitfall:** a detector that outputs thousands of low-confidence boxes can raise recall at the cost of precision. Average precision rewards keeping the high-scoring detections correct, so it is the better comparison, and benchmarks report it at several IoU thresholds.

> **In the wild:** before a detector is shipped, teams compute these numbers on a held-out set, then look at the false positives and false negatives one by one to find the failure patterns.

## Challenge: matching

```python exercise id=match-detections title="Greedy matching of detections"
import numpy as np

def iou_box(a, b):
    ix = max(0.0, min(a[2], b[2]) - max(a[0], b[0]))
    iy = max(0.0, min(a[3], b[3]) - max(a[1], b[1]))
    inter = ix * iy
    union = (a[2] - a[0]) * (a[3] - a[1]) + (b[2] - b[0]) * (b[3] - b[1]) - inter
    return inter / union

# TODO: `match_detections(dets, gts, thr=0.5)` takes detections as (box, score) pairs and ground-truth boxes. Visit the
# detections from highest to lowest score. Each detection matches the unmatched ground-truth box with the highest IoU, if
# that IoU is at least thr; a ground truth can be matched once. Return a list of 1 (true positive) or 0 (false positive)
# in the same visiting order.
def match_detections(dets, gts, thr=0.5):
    ...
--- solution
import numpy as np

def iou_box(a, b):
    ix = max(0.0, min(a[2], b[2]) - max(a[0], b[0]))
    iy = max(0.0, min(a[3], b[3]) - max(a[1], b[1]))
    inter = ix * iy
    union = (a[2] - a[0]) * (a[3] - a[1]) + (b[2] - b[0]) * (b[3] - b[1]) - inter
    return inter / union

def match_detections(dets, gts, thr=0.5):
    order = sorted(range(len(dets)), key=lambda i: -dets[i][1])
    matched = [False] * len(gts)
    flags = []
    for i in order:
        box = dets[i][0]
        best_j, best_iou = -1, 0.0
        for j, g in enumerate(gts):
            if matched[j]:
                continue
            v = iou_box(box, g)
            if v >= thr and v > best_iou:
                best_j, best_iou = j, v
        if best_j >= 0:
            matched[best_j] = True
            flags.append(1)
        else:
            flags.append(0)
    return flags
--- test
gts = [[0, 0, 10, 10], [20, 20, 30, 30]]
dets = [([1, 1, 11, 11], 0.9), ([50, 50, 60, 60], 0.8), ([21, 21, 31, 31], 0.7), ([0, 0, 10, 10], 0.6)]
result = match_detections(dets, gts)
assert result is not None, "Replace the `...` in `match_detections` with code that returns the flags."
assert result == [1, 0, 1, 0], f"The first and third detections match, the second finds nothing, and the fourth overlaps a ground truth that is already taken. Expected [1, 0, 1, 0], but you returned {result}."
assert match_detections([([0, 0, 10, 10], 0.5)], [[0, 0, 10, 10]]) == [1], "An exact match is a true positive."
assert match_detections([([0, 0, 2, 2], 0.9)], [[0, 0, 10, 10]]) == [0], "An IoU of 0.04 is below the threshold."
--- hint
Sort the detection indices by score first. For each detection, loop over the ground truths that are still unmatched.
--- hint
Track `matched` as a list of booleans with one entry per ground truth.
```

## Challenge: average precision

```python exercise id=average-precision title="Average precision from ranked flags"
# TODO: `average_precision(flags, n_gt)` takes the true-positive flags in ranked order and the number of ground-truth objects.
# For each rank k where the flag is 1, add the precision at that rank (true positives so far divided by k). Return the sum
# divided by n_gt, or 0.0 when n_gt is zero.
def average_precision(flags, n_gt):
    ...
--- solution
def average_precision(flags, n_gt):
    if n_gt == 0:
        return 0.0
    tp = 0
    total = 0.0
    for k, f in enumerate(flags, start=1):
        if f:
            tp += 1
            total += tp / k
    return total / n_gt
--- test
result = average_precision([1, 0, 1], 2)
assert result is not None, "Replace the `...` in `average_precision` with code that returns the value."
assert abs(result - (1 + 2 / 3) / 2) < 1e-9, f"Precision is 1 at rank 1 and 2/3 at rank 3, so the average is (1 + 2/3) / 2, but you returned {result}."
assert abs(average_precision([1, 1], 2) - 1.0) < 1e-9, "Two perfect detections for two objects give average precision one."
assert average_precision([], 0) == 0.0, "No ground truth gives zero."
--- hint
Keep a running count of true positives, and add tp / k only at the ranks where the flag is 1.
--- hint
Divide by `n_gt` at the end, after the loop.
```

## Debug: recall divides by the wrong count

Recall should be the share of ground-truth objects found. The code divides by the number of detections instead.

```python debug id=recall-denominator title="Divide recall by the ground truths"
flags = [1, 0, 1, 0]
n_gt = 3
recall = sum(flags) / len(flags)     # bug: the denominator is the number of detections
print("recall:", recall)
--- solution
flags = [1, 0, 1, 0]
n_gt = 3
recall = sum(flags) / n_gt
print("recall:", recall)
--- test
assert abs(recall - 2 / 3) < 1e-9, f"Two of three objects are found, so recall is 2/3, but the code gives {recall}. Divide by the number of ground-truth objects."
--- hint
Recall counts found objects out of all objects.
--- hint
The denominator is `n_gt`.
```

## Predict the recall

```python predict id=predict-recall title="What is the recall with 3 true positives out of 4 ground-truth objects?"
print(3 / 4)
--- options
* 0.75
3.0
0.25
1.33
--- explain
Recall is the share of ground-truth objects found, and 3 of 4 is 0.75.
```

## Recap

- A detection is a true positive when its IoU with an unmatched ground truth is at least the threshold.
- Precision and recall come from the true-positive count over the detections and over the ground truths.
- Average precision rewards ranking the correct detections first, and it penalizes missed objects.

**Up next:** the final assessment covers the whole course.
', 0, '[]', '[]', '2026-06-25T07:12:46.269Z', '2026-10-19T07:12:46.269Z'),
('les_computer_vision_bootcamp_5_4', 'sec_computer_vision_bootcamp_5', 'crs_computer_vision_bootcamp', 'Final assessment: Computer Vision Bootcamp', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"How many tokens does a ViT produce for a 224 by 224 image with 16 by 16 patches, including the class token?","options":["196","197","256","14"],"answerIndex":1,"explanation":"There are 14 × 14 = 196 patches, plus one class token."},{"id":"q2","prompt":"How does CLIP classify an image without new training?","options":["It retrains the last layer on the new labels","It picks the label whose text embedding is most similar to the image embedding","It counts the colours in the image","It segments the image first"],"answerIndex":1,"explanation":"Image and text share an embedding space, so the closest prompt gives the label."},{"id":"q3","prompt":"Two of four detections are correct and there are three ground-truth objects. What is the recall?","options":["0.5","0.67","0.75","0.33"],"answerIndex":1,"explanation":"Recall is the share of ground-truth objects found, 2 out of 3."},{"id":"q4","prompt":"Why does average precision penalize missed objects?","options":["It divides by the number of ground-truth objects, so a miss lowers the score","It counts only the detections","It ignores the ranking","It is computed from the image size"],"answerIndex":0,"explanation":"The sum of precisions is divided by the number of ground truths, so unfound objects reduce the result."},{"id":"q5","prompt":"What does the receptive field of an output describe?","options":["The region of the input that can influence that output","The number of parameters in the layer","The batch size used in training","The class with the highest score"],"answerIndex":0,"explanation":"It is the input area that feeds the output through the stacked layers."},{"id":"q6","prompt":"Why is a linear probe a good baseline before fine-tuning?","options":["It shows how much the frozen features already explain, so fine-tuning is only needed if they fall short","It always beats full fine-tuning","It requires no labels","It changes the backbone weights"],"answerIndex":0,"explanation":"A probe measures the quality of the frozen features at low cost."}]', '[]', '2026-06-25T07:12:46.269Z', '2026-10-19T07:12:46.269Z');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_computer_vision_bootcamp_1', 'usr_seed000000', 'crs_computer_vision_bootcamp', 3, 'Very good', 'Good content overall, but I wanted more exercises and a slower pace in the later sections. Still learned a lot.', '2026-09-13T18:12:46.269Z', '2026-09-13T18:12:46.269Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000000');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_computer_vision_bootcamp_2', 'usr_seed000006', 'crs_computer_vision_bootcamp', 5, 'Solid and practical', 'Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I''d take another course from this instructor.', '2026-10-05T15:12:46.269Z', '2026-10-05T15:12:46.269Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000006');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_computer_vision_bootcamp_3', 'usr_seed00000n', 'crs_computer_vision_bootcamp', 5, 'Exceptional production quality', 'Beautifully structured. The quizzes caught gaps in my understanding and the AI tutor was surprisingly helpful when I got stuck on the harder sections.', '2026-10-07T19:12:46.269Z', '2026-10-07T19:12:46.269Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000n');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_computer_vision_bootcamp_4', 'usr_seed00000r', 'crs_computer_vision_bootcamp', 5, 'Worth every minute', 'Clear, well-paced and incredibly practical. The projects were challenging in the right way, and I used what I learned at work within a week of finishing.', '2026-09-12T21:12:46.269Z', '2026-09-12T21:12:46.269Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000r');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_computer_vision_bootcamp_5', 'usr_seed000017', 'crs_computer_vision_bootcamp', 2, 'Very good', 'Good content overall, but I wanted more exercises and a slower pace in the later sections. Still learned a lot.', '2026-09-26T00:12:46.269Z', '2026-09-26T00:12:46.269Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000017');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_computer_vision_bootcamp_6', 'usr_seed00001v', 'crs_computer_vision_bootcamp', 5, 'Dense but fantastic', 'This is not a fluffy overview — it goes deep. Expect to pause and re-watch, but the payoff is real. The instructor clearly knows the material at a research level.', '2026-10-14T10:12:46.269Z', '2026-10-14T10:12:46.269Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001v');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_computer_vision_bootcamp_7', 'usr_seed00002c', 'crs_computer_vision_bootcamp', 5, 'Clear explanations', 'The visual explanations of difficult concepts are the best I''ve seen. Code is clean and modern. Updated content too, which matters a lot in this field.', '2026-10-22T23:12:46.269Z', '2026-10-22T23:12:46.269Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002c');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_computer_vision_bootcamp_8', 'usr_seed00002n', 'crs_computer_vision_bootcamp', 4, 'Clear explanations', 'The visual explanations of difficult concepts are the best I''ve seen. Code is clean and modern. Updated content too, which matters a lot in this field.', '2026-10-09T21:12:46.269Z', '2026-10-09T21:12:46.269Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002n');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_computer_vision_bootcamp_9', 'usr_seed00002u', 'crs_computer_vision_bootcamp', 5, 'Great instructor, great community', 'Questions in the Q&A got thoughtful answers quickly. The notes feature and lesson resources made it easy to review before my exam.', '2026-10-01T16:12:46.269Z', '2026-10-01T16:12:46.269Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002u');

UPDATE courses SET rating_avg = coalesce((SELECT avg(rating) FROM reviews WHERE course_id = 'crs_computer_vision_bootcamp'), 0), rating_count = (SELECT count(*) FROM reviews WHERE course_id = 'crs_computer_vision_bootcamp') WHERE id = 'crs_computer_vision_bootcamp';
