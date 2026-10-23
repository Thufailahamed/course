Detection answers two questions: what is there and where. The "where" is a bounding box, written as corners (x1, y1, x2, y2). Two tools make detection workable. IoU measures how much two boxes overlap, and non-maximum suppression removes duplicate detections of the same object.

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
The small box lies inside the large one. Its area of 1 is the intersection, and the union is the large box's area of 4. The IoU is 1/4.
```

## Recap

- A box is four numbers, and its area is the product of its width and height.
- IoU is the intersection over the union, and it is 1 for identical boxes.
- Non-maximum suppression keeps the highest-scoring box in each cluster of overlapping detections.

**Up next:** anchors, the grid of candidate boxes that detectors predict from.
