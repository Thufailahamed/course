A detector is trained by deciding, for every anchor, what it should predict. Anchors that overlap a real object strongly become positives and learn to classify and regress to that object. Anchors that overlap nothing become negatives and learn to say "background". Anchors in between are ignored. The losses then measure both decisions and the box corrections for the positives.

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
The rule is 'at least 0.5', which includes 0.5.
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
