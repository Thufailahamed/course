Training a vision network from scratch needs far more labelled images than most projects have. A backbone pretrained on a large dataset already encodes general features such as edges, textures and shapes. Reusing it means either training only a small head on its features, the linear probe, or updating the whole network with a smaller learning rate.

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
