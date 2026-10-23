An encoder such as BERT learns from text by hiding some of it. During pretraining, a fraction of the tokens are replaced by a special [MASK] token, and the model must predict the originals from the words around them on both sides. That objective, **masked language modelling**, forces the model to use context in both directions, and it turns unlabelled text into a rich training signal. Afterwards, the pretrained encoder is reused for many tasks.

## Masking tokens

```python run
import numpy as np

tokens = ["the", "delivery", "arrived", "late", "and", "the", "box", "was", "damaged"]
rng = np.random.default_rng(3)
n_mask = max(1, int(round(0.15 * len(tokens))))
positions = rng.choice(len(tokens), size=n_mask, replace=False)
masked = [("[MASK]" if i in positions else t) for i, t in enumerate(tokens)]
print("original:", " ".join(tokens))
print("masked:  ", " ".join(masked))
print("the model must recover:", [tokens[i] for i in sorted(positions)])
```

Masking about one token in seven gives a clear prediction task without hiding so much that the sentence becomes meaningless.

## Why both sides matter

A model that reads only the left context cannot use words that come after the gap. In the example below the missing word is determined by the word after it.

```python run
corpus = "the cat sat on the mat . the dog sat on the rug . the cat lay on the mat".split()
left_only = {}
both_sides = {}
for i in range(1, len(corpus) - 1):
    key_left = corpus[i - 1]
    key_both = (corpus[i - 1], corpus[i + 1])
    left_only.setdefault(key_left, []).append(corpus[i])
    both_sides.setdefault(key_both, []).append(corpus[i])
print("guess after 'the' alone:", sorted(set(left_only["the"])))
print("guess for 'on _ mat':", sorted(set(both_sides[("on", "mat")])))
```

Knowing "on _ mat" narrows the answer to words that fit both sides. This is why BERT reads the whole sequence at once.

## Special tokens

BERT-style inputs wrap the text in special tokens: [CLS] at the start, which later serves as a summary of the sequence, and [SEP] between segments. Segment ids tell the model which segment each token belongs to.

```python run
segment_a = ["the", "box", "was", "damaged"]
segment_b = ["it", "was", "replaced"]
input_tokens = ["[CLS]"] + segment_a + ["[SEP]"] + segment_b + ["[SEP]"]
segment_ids = [0] * (len(segment_a) + 2) + [1] * (len(segment_b) + 1)
print(list(zip(input_tokens, segment_ids)))
```

> **Pitfall:** the 15% masking rate is a choice. A model pretrained with too little masking learns little per sentence, and too much leaves too little context to predict from.

> **In the wild:** BERT and its descendants are pretrained on large corpora with this objective. Fine-tuning then adds a small head on top for each task, which the next lessons cover.

Masking is random. A fixed seed makes the choice of masked positions reproducible, which matters when comparing training runs.

```python run
import numpy as np
mask_rng = np.random.default_rng(5)
tokens_m = ["the", "box", "was", "damaged"]
masked_here = mask_rng.random(len(tokens_m)) < 0.5
print("masked positions:", np.nonzero(masked_here)[0])
```

## Challenge: mask positions

```python exercise id=mask-positions title="Replace positions with a mask token"
# TODO: `mask_tokens(tokens, positions, mask_token)` returns a new list with the tokens at the given positions replaced by
# mask_token. The input list must not change.
def mask_tokens(tokens, positions, mask_token):
    ...
--- solution
def mask_tokens(tokens, positions, mask_token):
    out = list(tokens)
    for p in positions:
        out[p] = mask_token
    return out
--- test
tokens = ["a", "b", "c"]
result = mask_tokens(tokens, [1], "[MASK]")
assert result is not None, "Replace the `...` in `mask_tokens` with code that returns the masked list."
assert result == ["a", "[MASK]", "c"], f"Position 1 should hold the mask, giving ['a', '[MASK]', 'c'], but you returned {result}."
assert tokens == ["a", "b", "c"], "The input list must not change."
assert mask_tokens(["x"], [], "[MASK]") == ["x"], "No positions means no change."
--- hint
Copy the list first so the input is not changed, then assign the mask token at each position.
--- hint
`out = list(tokens)` and then `out[p] = mask_token` in a loop.
```

## Challenge: masked mean pooling

```python exercise id=masked-mean title="Mean over the real tokens only"
import numpy as np

# TODO: `masked_mean(H, mask)` takes a (tokens, features) array H and a 0/1 array mask of length tokens. It returns the mean
# of the rows of H where mask is 1. Rows with mask 0 (padding) must not contribute.
def masked_mean(H, mask):
    ...
--- solution
import numpy as np

def masked_mean(H, mask):
    H = np.asarray(H, dtype=float)
    mask = np.asarray(mask, dtype=float)
    return (H * mask[:, None]).sum(axis=0) / mask.sum()
--- test
import numpy as np
H = np.array([[1.0, 1.0], [3.0, 3.0], [100.0, 100.0]])
result = masked_mean(H, [1, 1, 0])
assert result is not None, "Replace the `...` in `masked_mean` with code that returns the pooled vector."
assert np.allclose(result, [2.0, 2.0]), f"Only the first two rows are real, so the mean is [2, 2], but you returned {result}. The padding row must not count."
assert np.allclose(masked_mean(H, [0, 0, 1]), [100.0, 100.0]), "With only one real token the pooled vector is that token."
--- hint
Multiply each row by its mask value, sum over the tokens, and divide by the number of real tokens, which is the sum of the mask.
--- hint
`(H * mask[:, None]).sum(axis=0) / mask.sum()`.
```

## Debug the pooling

This pooled vector is meant to average only the real tokens, but it averages padding too, so the long padded sequence is diluted.

```python debug id=pool-padding title="Pool over real tokens only"
import numpy as np

H = np.array([[1.0, 1.0], [3.0, 3.0], [0.0, 0.0], [0.0, 0.0]])
mask = np.array([1, 1, 0, 0])
pooled = H.mean(axis=0)                # bug: includes the padding rows
print("pooled:", pooled)
--- solution
import numpy as np

H = np.array([[1.0, 1.0], [3.0, 3.0], [0.0, 0.0], [0.0, 0.0]])
mask = np.array([1, 1, 0, 0])
pooled = (H * mask[:, None]).sum(axis=0) / mask.sum()
print("pooled:", pooled)
--- test
assert np.allclose(pooled, [2.0, 2.0]), f"The real tokens average to [2, 2], but the pooled vector is {pooled}. Exclude the padding rows."
--- hint
Padding rows have mask 0 and should contribute nothing to the sum or the count.
--- hint
Weight each row by the mask before summing, and divide by `mask.sum()`.
```

## Predict the masked count

```python predict id=predict-mask title="How many tokens are masked in a 10-token sequence at a 15% rate?"
print(max(1, int(round(0.15 * 10))))
--- options
* 2
1
15
0
--- explain
Fifteen per cent of ten tokens is 1.5, which rounds to 2 under round-half-to-even, and the rule keeps at least one token masked.
```
