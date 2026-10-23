A detector must produce boxes in every position and at several sizes. Anchors are a fixed set of candidate boxes placed on a grid over the image, and the network predicts a small correction to each one. Two-stage detectors first propose regions and then classify them, while one-stage detectors predict directly from every anchor in a single pass.

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

The network predicts four numbers for each anchor: shifts of the centre relative to the anchor's size, and log-scale changes of width and height. Decoding turns them back into a box.

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
The shifts are relative to the anchor's width and height, and the sizes are scaled by exp of the deltas.
--- hint
Multiply the width by `np.exp(tw)`, not add to it.
```

## Debug: the size correction

The width should be scaled by exp(tw), but the code adds it instead.

```python debug id=decode-scale title="Scale the width, don't shift it"
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
