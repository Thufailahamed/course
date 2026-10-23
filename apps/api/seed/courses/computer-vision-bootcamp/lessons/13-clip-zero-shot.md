Most classifiers are trained for a fixed list of labels, so adding a new category means collecting new data. CLIP takes a different route. It is trained so that an image and a text describing it land near each other in one shared embedding space. To classify with it, you write the candidate labels as sentences, embed them, and pick the sentence closest to the image. No new training is needed.

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

**Up next:** the capstone, where you evaluate a detector's output with the metrics from this course.
