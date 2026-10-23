This capstone evaluates a detector the way a benchmark does. A detection counts as correct when its box overlaps a ground-truth box with IoU of at least 0.5, and each ground-truth box can be matched only once. Sorting the detections by score and matching greedily gives true positives and false positives, from which precision, recall and average precision follow.

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
