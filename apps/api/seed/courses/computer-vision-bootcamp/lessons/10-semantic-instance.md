Segmentation labels pixels instead of drawing boxes. Semantic segmentation gives every pixel a class, so all people in a photo share one "person" label. Instance segmentation also separates individual objects, so each person gets a different id. This lesson measures segmentation quality with pixel accuracy and per-class IoU.

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

```python debug id=or-not-and title="Intersect the masks, don't join them"
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
