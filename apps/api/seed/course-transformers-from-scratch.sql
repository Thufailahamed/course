DELETE FROM exercise_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_transformers_from_scratch');

DELETE FROM quiz_attempts WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_transformers_from_scratch');

DELETE FROM notes WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_transformers_from_scratch');

DELETE FROM lesson_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_transformers_from_scratch');

DELETE FROM discussions WHERE course_id = 'crs_transformers_from_scratch';

DELETE FROM certificates WHERE course_id = 'crs_transformers_from_scratch';

DELETE FROM enrollments WHERE course_id = 'crs_transformers_from_scratch';

DELETE FROM reviews WHERE course_id = 'crs_transformers_from_scratch';

DELETE FROM wishlist WHERE course_id = 'crs_transformers_from_scratch';

DELETE FROM path_courses WHERE course_id = 'crs_transformers_from_scratch';

DELETE FROM coupons WHERE course_id = 'crs_transformers_from_scratch';

DELETE FROM lessons WHERE course_id = 'crs_transformers_from_scratch';

DELETE FROM sections WHERE course_id = 'crs_transformers_from_scratch';

UPDATE order_items SET course_id = NULL WHERE course_id = 'crs_transformers_from_scratch';

DELETE FROM courses WHERE id = 'crs_transformers_from_scratch';

INSERT OR IGNORE INTO categories (id, slug, name, description, icon, sort_order) VALUES ('cat_deep-learning', 'deep-learning', 'Deep Learning', 'Neural networks, backprop, CNNs, RNNs and Transformers.', 'layers', 1);

INSERT INTO courses (id, slug, title, subtitle, description, category_id, instructor_id, level, language, price_cents, compare_at_price_cents, currency, thumbnail_key, preview_video_url, accent, status, featured, what_you_learn, requirements, target_audience, tags, duration_minutes, lessons_count, rating_avg, rating_count, students_count, published_at, created_at, updated_at) VALUES
('crs_transformers_from_scratch', 'transformers-from-scratch', 'Transformers from Scratch', 'Attention, tokenization and a GPT, built line by line — then trained the way real models are.', 'The transformer is the architecture behind nearly every modern language model, and it is built from a small number of ideas: attention, residual connections, normalization and a feed-forward network, repeated many times. This course builds each piece yourself, checks it against the formulas, and then assembles a small GPT that generates text.

## Learn by building

- **Every component in NumPy.** Attention, multi-head splitting, masking, positional encodings, layer normalization and the transformer block all run in the page.
- **A real tokenizer.** You implement byte-pair encoding and see how it turns text into the tokens a model reads.
- **Training ideas, tested.** Learning-rate schedules, gradient accumulation and sampling strategies are functions you write and check against exact answers.
- **Debug challenges.** You fix the bugs that break real transformers: a missing causal mask, attention normalized along the wrong axis, and a learning-rate warmup that is off by one.
- **PyTorch shown honestly.** The full GPT model and training loop are static PyTorch code for you to run locally, with a NumPy version of each piece that runs here.

## What you''ll cover

- **Why attention:** from recurrent networks to attention.
- **Attention, implemented:** scaled dot-product, multi-head attention and causal masks.
- **Building GPT:** tokenization, embeddings, positions, the transformer block and a complete forward pass.
- **Training at scale:** next-token loss, schedules, accumulation, mixed precision and caching.
- **Modern tricks:** rotary positions and RMSNorm, then an evaluation with perplexity.

## Why this course?

Most people use transformers as black boxes. Once you have written the attention formula, handled the masks and debugged a shape error in the residual stream, the models stop being mysterious, and you can read the next architecture paper with confidence.

You need the basics of deep learning. Everything about transformers is taught from the ground up.', 'cat_deep-learning', 'usr_maya', 'advanced', 'English', 0, NULL, 'USD', NULL, NULL, 318, 'published', 0, '["Derive and implement scaled dot-product and multi-head attention","Build the parts of a decoder-only transformer (GPT) and explain each one","Train a tokenizer with byte-pair encoding and understand why it works","Apply modern tricks: rotary positions, RMSNorm and KV-caching","Scale training with warmup, cosine decay, gradient accumulation and mixed precision","Sample text with temperature and top-k, and evaluate a language model with perplexity"]', '["Deep Learning Foundations or equivalent: backpropagation, softmax and cross-entropy","Python and NumPy. The browser runs them; the PyTorch model code is shown for local use"]', '["Engineers who want to understand the architecture behind modern language models","Deep-learning practitioners who use transformers but have never written one","Researchers preparing to read and modify transformer papers"]', '["Transformers","Attention","GPT","PyTorch"]', 285, 18, 0, 0, 21460, '2026-02-18T07:00:34.475Z', '2026-01-19T07:00:34.475Z', '2026-10-20T07:00:34.475Z');

INSERT INTO sections (id, course_id, title, position, created_at) VALUES
('sec_transformers_from_scratch_1', 'crs_transformers_from_scratch', 'Why Attention', 0, '2026-06-25T07:00:34.475Z'),
('sec_transformers_from_scratch_2', 'crs_transformers_from_scratch', 'Attention, Implemented', 1, '2026-06-25T07:00:34.475Z'),
('sec_transformers_from_scratch_3', 'crs_transformers_from_scratch', 'Building GPT', 2, '2026-06-25T07:00:34.475Z'),
('sec_transformers_from_scratch_4', 'crs_transformers_from_scratch', 'Training at Scale', 3, '2026-06-25T07:00:34.475Z'),
('sec_transformers_from_scratch_5', 'crs_transformers_from_scratch', 'Modern Tricks and Evaluation', 4, '2026-06-25T07:00:34.475Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_transformers_from_scratch_1_1', 'sec_transformers_from_scratch_1', 'crs_transformers_from_scratch', 'How this course works', 'interactive', 0, 480, NULL, NULL, 'Welcome to **Transformers from Scratch**. A transformer is a stack of simple, repeated blocks, and each block does two things: it lets every token look at every other token, and it transforms each token''s representation with a small neural network. Language models, image models and speech models have all been built from this design, so understanding it well is one of the most valuable things a deep-learning engineer can do.

This course builds the architecture one component at a time. Each lesson gives you the idea, the formula, and a NumPy implementation that runs in this page. The complete PyTorch model and training loop are shown as static code for you to run locally, and each of their parts is already familiar from a NumPy version.

> **How to use this lesson:** read a little, run a little. Every grey box runs in the page.

## Run a first attention

Here is the single idea that makes transformers work, in four lines. Each token builds its output as a weighted average of all tokens, with weights that depend on the content of the tokens.

```python run
import numpy as np

tokens = np.array([[1.0, 0.0], [0.0, 1.0], [1.0, 1.0]])   # three tokens, each a 2-number vector
scores = tokens @ tokens.T                               # how well each token matches each other token
weights = np.exp(scores) / np.exp(scores).sum(axis=1, keepdims=True)
print("attention weights:\n", np.round(weights, 3))
print("outputs:\n", np.round(weights @ tokens, 3))
```

Every row of the weight matrix sums to one, and every output mixes information from the whole sequence. Attention is a learned, content-based way for tokens to communicate.

## Predict the output

```python predict id=predict-rows title="What does each row of the weights sum to?"
import numpy as np
w = np.array([[0.2, 0.8], [0.5, 0.5]])
print(np.round(w.sum(axis=1), 2))
--- options
* [1. 1.]
[0.2 0.5]
[2. 2.]
[1. 0.]
--- explain
Each row is a probability distribution over the tokens, so it sums to one. Rows of this matrix sum to 1 and 1, which is the property softmax guarantees.
```

## Your first challenge

A **challenge** asks you to write a function that the course tests on new data.

```python exercise id=row-softmax title="A softmax over each row"
import numpy as np

# TODO: `row_softmax(Z)` returns a matrix of the same shape in which each row is turned into probabilities by softmax.
# Subtract each row''s maximum first, for numerical stability.
def row_softmax(Z):
    ...
--- solution
import numpy as np

def row_softmax(Z):
    Z = np.asarray(Z, dtype=float)
    e = np.exp(Z - Z.max(axis=1, keepdims=True))
    return e / e.sum(axis=1, keepdims=True)
--- test
import numpy as np
result = row_softmax(np.array([[0.0, 0.0], [1000.0, 1000.0]]))
assert result is not None, "Replace the `...` in `row_softmax` with code that returns the probabilities."
assert result.shape == (2, 2), "The shape should be preserved."
assert np.allclose(result, 0.5), "Equal scores in a row give equal probabilities, even for huge values after the shift."
assert np.allclose(result.sum(axis=1), 1.0), "Each row must sum to one."
--- hint
Compute the maximum of each row with `axis=1, keepdims=True`, subtract it, then exponentiate and divide by the row sums.
--- hint
`e = np.exp(Z - Z.max(axis=1, keepdims=True))` and `return e / e.sum(axis=1, keepdims=True)`.
```

## Debug the wrong axis

This attention normalization is meant to make each token''s weights sum to one, but it normalizes down the columns, so each token''s weights are wrong.

```python debug id=softmax-axis title="Normalize each token''s weights"
import numpy as np

scores = np.array([[2.0, 0.0], [1.0, 3.0]])
e = np.exp(scores)
weights = e / e.sum(axis=0, keepdims=True)           # bug: normalizes across the query tokens
print("row sums:", np.round(weights.sum(axis=1), 3))
--- solution
import numpy as np

scores = np.array([[2.0, 0.0], [1.0, 3.0]])
e = np.exp(scores)
weights = e / e.sum(axis=1, keepdims=True)
print("row sums:", np.round(weights.sum(axis=1), 3))
--- test
assert np.allclose(weights.sum(axis=1), 1.0), f"Each query''s weights must sum to 1, but the row sums are {weights.sum(axis=1)}. Normalize across the keys, which is axis 1."
--- hint
Each row is one query, and its weights are over the keys, which are the columns.
--- hint
Use `axis=1` in the sum.
```

## Recap

- A transformer lets every token build its output from every other token, weighted by content.
- Attention weights are probabilities, one distribution per token, and each row sums to one.
- Shapes and axes decide whether attention means what you intend. Check them.
- Everything else in the architecture is built around this one operation.

**Up next:** where attention came from, and why it replaced recurrence.
', 1, '[]', '[{"title":"Attention Is All You Need (Vaswani et al.)","url":"https://arxiv.org/abs/1706.03762"},{"title":"The Illustrated Transformer (Jay Alammar)","url":"https://jalammar.github.io/illustrated-transformer/"},{"title":"nanoGPT (Andrej Karpathy)","url":"https://github.com/karpathy/nanoGPT"}]', '2026-06-25T07:00:34.475Z', '2026-10-19T07:00:34.475Z'),
('les_transformers_from_scratch_1_2', 'sec_transformers_from_scratch_1', 'crs_transformers_from_scratch', 'From recurrent networks to attention', 'interactive', 1, 960, NULL, NULL, 'Before transformers, language was modelled with recurrent networks. A recurrent network reads one token at a time and carries a hidden state forward. That state must hold everything the model needs to remember, and it is squeezed through one fixed-size vector at every step. Two problems follow: information from early tokens fades, and each step must wait for the previous one, so the work cannot run in parallel across the sequence.

Attention removes both problems. Every token can read directly from any other token, and all positions are computed at once with matrix products. This lesson shows the contrast in code.

## The bottleneck

A recurrent summary keeps one state, updated at each step. The state''s usefulness for a token from far in the past depends on how well it survives many updates.

```python run
import numpy as np

rng = np.random.default_rng(0)
x = rng.normal(size=(10, 4))             # ten tokens, four features each
state = np.zeros(4)
for token in x:
    state = np.tanh(0.9 * state + token)  # a simple recurrent update
print("final state, one vector for all ten tokens:", np.round(state, 2))
```

Everything the model knows about ten tokens must fit in one vector of four numbers after the last step. Attention avoids this compression by keeping every token''s representation available.

## Attention as a lookup

Attention treats each token as a query that looks up the keys of all tokens and returns a weighted mix of their values. The weights depend on how well the query matches each key.

```python run
query = np.array([1.0, 0.0, 0.0, 0.0])
keys = np.eye(4)                          # four tokens with orthogonal keys
values = np.arange(4, dtype=float).reshape(4, 1)
scores = keys @ query
weights = np.exp(scores) / np.exp(scores).sum()
print("weights:", np.round(weights, 3))
print("output:", np.round(weights @ values, 3))
```

The query matches the first key exactly, so most of the weight lands on the first value. Changing the query changes which tokens the output draws from, without any change in the architecture.

What happens when two keys are partly similar to the query? The weights split between them, and the output blends their values.

```python run
keys = np.array([[1.0, 0.0, 0.0, 0.0], [0.0, 1.0, 0.0, 0.0], [0.5, 0.0, 0.0, 0.0]])
w = np.exp(keys @ query)
w = w / w.sum()
print("weights with a partly similar third key:", np.round(w, 3))
```

## Parallel computation

Recurrent steps depend on each other. Attention scores every pair of tokens with one matrix product, so the whole sequence is processed together.

```python run
Q = rng.normal(size=(10, 4))
K = rng.normal(size=(10, 4))
all_scores = Q @ K.T
print("one matrix product gives all", all_scores.size, "pairwise scores at once, shape", all_scores.shape)
```

> **Pitfall:** attention alone has no sense of order. The sequence "dog bites man" and "man bites dog" contain the same tokens, so the model needs positional information, which a later lesson adds.

> **In the wild:** the speed of parallel training is a large part of why transformers scaled up. Recurrent models could not use modern accelerators as efficiently.

## Challenge: attention weights for one query

```python exercise id=query-weights title="Attention weights for one query"
import numpy as np

# TODO: `query_weights(q, K)` returns the softmax of the dot products between one query vector q and each row of K.
# The result is a 1-D array of weights that sum to one.
def query_weights(q, K):
    ...
--- solution
import numpy as np

def query_weights(q, K):
    scores = np.asarray(K, dtype=float) @ np.asarray(q, dtype=float)
    e = np.exp(scores - scores.max())
    return e / e.sum()
--- test
import numpy as np
result = query_weights(np.array([1.0, 0.0]), np.array([[1.0, 0.0], [0.0, 1.0]]))
assert result is not None, "Replace the `...` in `query_weights` with code that returns the weights."
assert result.shape == (2,), "There is one weight per key."
expected = np.exp([1.0, 0.0]) / np.exp([1.0, 0.0]).sum()
assert np.allclose(result, expected), f"The scores are [1, 0], so the weights should be {expected}, but you returned {result}."
assert abs(result.sum() - 1.0) < 1e-9, "The weights must sum to one."
--- hint
Multiply the key matrix by the query to get one score per key, then take the softmax.
--- hint
`scores = K @ q`, then the usual shifted exponential and normalization.
```

## Challenge: the attention output

```python exercise id=attention-output title="Mix values with attention weights"
import numpy as np

# TODO: `attention_output(weights, V)` returns the weighted sum of the rows of V, using the weight vector.
def attention_output(weights, V):
    ...
--- solution
import numpy as np

def attention_output(weights, V):
    return np.asarray(weights, dtype=float) @ np.asarray(V, dtype=float)
--- test
import numpy as np
result = attention_output(np.array([0.25, 0.75]), np.array([[4.0, 0.0], [0.0, 8.0]]))
assert result is not None, "Replace the `...` in `attention_output` with code that returns the output."
assert np.allclose(result, [1.0, 6.0]), f"0.25 × [4, 0] + 0.75 × [0, 8] = [1, 6], but you returned {result}."
--- hint
A weighted sum of rows is a vector-matrix product: weights on the left, values on the right.
--- hint
`return weights @ V`.
```

## Debug the sequence order

This check is meant to show that attention is order-blind, but the swap of two tokens changes the result of the sum in the wrong place.

```python debug id=order-blind title="Attention output does not depend on order"
import numpy as np

tokens = np.array([[1.0, 0.0], [0.0, 1.0]])
weights = np.array([[0.9, 0.1], [0.2, 0.8]])
out = weights @ tokens
perm = np.array([1, 0])
out_swapped = weights @ tokens[perm]
print("same output after swapping tokens?", np.allclose(out, out_swapped))
--- solution
import numpy as np

tokens = np.array([[1.0, 0.0], [0.0, 1.0]])
weights = np.array([[0.9, 0.1], [0.2, 0.8]])
out = weights @ tokens
perm = np.array([1, 0])
out_swapped = weights[:, perm] @ tokens[perm]
print("same output after swapping tokens?", np.allclose(out, out_swapped))
--- test
assert np.allclose(out, out_swapped), "Permuting the tokens together with their weights must leave the output unchanged. Permute the weight columns too."
--- hint
When the tokens are reordered, the weight matrix''s columns must be reordered in the same way.
--- hint
Use `weights[:, perm]` as well as `tokens[perm]`.
```

## Predict the output

```python predict id=predict-state title="How many numbers summarize ten tokens in the recurrent version?"
import numpy as np
state = np.zeros(4)
print(state.size)
--- options
* 4
10
40
1
--- explain
The recurrent state is one vector of size four, however many tokens were read. That fixed size is the bottleneck attention removes.
```

## Recap

- Recurrent models compress the whole past into one state, which fades over long distances.
- Attention lets every token read directly from every other token, with weights set by content.
- A query-key-value lookup returns a weighted mix of values, and all pairs are scored with one matrix product.
- Attention has no built-in sense of order, so positions must be added.

**Up next:** scaled dot-product attention in full, with the formula and its scaling.
', 0, '[]', '[]', '2026-06-25T07:00:34.475Z', '2026-10-19T07:00:34.475Z'),
('les_transformers_from_scratch_2_1', 'sec_transformers_from_scratch_2', 'crs_transformers_from_scratch', 'Scaled dot-product attention', 'interactive', 0, 1080, NULL, NULL, 'The attention formula that powers every transformer fits on one line. Its ingredients are a query for each token, a key for each token and a value for each token, all produced from the token''s representation by learned matrices. Its one subtle detail is the scaling factor, and understanding why it is there is the difference between a model that trains and one that stalls.

## The formula

$$
\operatorname{Attention}(Q, K, V) = \operatorname{softmax}\!\left(\frac{Q K^{\top}}{\sqrt{d_k}}\right) V
$$

Read it from the inside out. $QK^{\top}$ scores every query against every key. Dividing by $\sqrt{d_k}$ keeps the scores at a useful scale. The softmax turns each row into weights, and multiplying by $V$ mixes the values with those weights.

```python run
import numpy as np

def scaled_scores(Q, K):
    return Q @ K.T / np.sqrt(Q.shape[-1])

def attention(Q, K, V):
    scores = scaled_scores(Q, K)
    e = np.exp(scores - scores.max(axis=-1, keepdims=True))
    weights = e / e.sum(axis=-1, keepdims=True)
    return weights @ V, weights

rng = np.random.default_rng(0)
Q, K, V = rng.normal(size=(3, 4)), rng.normal(size=(5, 4)), rng.normal(size=(5, 2))
out, w = attention(Q, K, V)
print("output shape:", out.shape, "| weight shape:", w.shape)
print("each query''s weights sum to:", np.round(w.sum(axis=1), 6))
```

Three queries and five keys give a 3 × 5 weight matrix, and the output has one row per query.

Softmax has a useful invariance: adding the same number to every score changes nothing. That is why the stable form subtracts the row maximum.

```python run
def softmax_rows(s):
    e = np.exp(s - s.max(axis=-1, keepdims=True))
    return e / e.sum(axis=-1, keepdims=True)

scores_demo = np.array([[2.0, 0.5, -1.0]])
print("weights:            ", np.round(softmax_rows(scores_demo), 4))
print("after adding 5:     ", np.round(softmax_rows(scores_demo + 5), 4))
print("weights are positive:", bool(np.all(softmax_rows(scores_demo) > 0)))
```

## Why scale by the square root of the dimension

If each query and key entry has variance one, a dot product over $d$ entries has variance $d$. Large scores push softmax into a corner where one weight is almost one and all gradients are almost zero. The scaling keeps the variance at one.

```python run
for d in [8, 64, 512]:
    q = rng.normal(size=(5000, d))
    k = rng.normal(size=(5000, d))
    raw = np.sum(q * k, axis=1)
    print(f"d = {d:>3}: std of raw scores {raw.std():7.2f}, scaled {(raw / np.sqrt(d)).std():.2f}")
```

> **Pitfall:** the scale is the square root of the key dimension, not the dimension itself. Dividing by $d$ shrinks the scores too much and the attention becomes almost uniform.

> **In the wild:** every multi-head attention layer in GPT-style models uses this formula, with the scale applied per head.

Attention weights come from the same Q and K, so each query places weight on itself often when it resembles its own key. The diagonal of the score matrix shows this.

```python run
rng_self = np.random.default_rng(7)
X_self = rng_self.normal(size=(4, 8))
self_scores = X_self @ X_self.T / np.sqrt(8)
print("self-scores on the diagonal:", np.round(np.diag(self_scores), 2))
print("largest score in each row is on the diagonal:", bool(np.all(np.argmax(self_scores, axis=1) == np.arange(4))))
```

## Challenge: scaled scores

```python exercise id=scaled-scores title="Scaled dot-product scores"
import numpy as np

# TODO: `scaled_scores(Q, K)` returns Q Kᵀ divided by the square root of the number of columns of Q.
def scaled_scores(Q, K):
    ...
--- solution
import numpy as np

def scaled_scores(Q, K):
    return np.asarray(Q, dtype=float) @ np.asarray(K, dtype=float).T / np.sqrt(np.asarray(Q).shape[-1])
--- test
import numpy as np
result = scaled_scores([[1.0, 2.0]], [[3.0, 4.0], [1.0, 0.0]])
assert result is not None, "Replace the `...` in `scaled_scores` with code that returns the scores."
assert result.shape == (1, 2), f"One query against two keys gives shape (1, 2), but you returned {result.shape}."
assert np.allclose(result, [[11 / np.sqrt(2), 1 / np.sqrt(2)]]), f"The raw scores are 3 + 8 = 11 and 1 + 0 = 1, divided by sqrt(2), but you returned {result}."
--- hint
Multiply Q by the transpose of K, then divide by `np.sqrt` of the query dimension.
--- hint
`Q @ K.T / np.sqrt(Q.shape[-1])`.
```

## Challenge: attention output and weights

```python exercise id=attention-full title="Full scaled dot-product attention"
import numpy as np

# TODO: `attention(Q, K, V)` returns a tuple (output, weights). weights is the softmax over each row of the scaled scores,
# and output is weights @ V. Use the numerically stable form.
def attention(Q, K, V):
    ...
--- solution
import numpy as np

def attention(Q, K, V):
    Q = np.asarray(Q, dtype=float)
    K = np.asarray(K, dtype=float)
    V = np.asarray(V, dtype=float)
    scores = Q @ K.T / np.sqrt(Q.shape[-1])
    e = np.exp(scores - scores.max(axis=-1, keepdims=True))
    weights = e / e.sum(axis=-1, keepdims=True)
    return weights @ V, weights
--- test
import numpy as np
Q = np.array([[1.0, 0.0]])
K = np.array([[1.0, 0.0], [0.0, 1.0]])
V = np.array([[10.0], [20.0]])
result = attention(Q, K, V)
assert result is not None, "Replace the `...` in `attention` with code that returns (output, weights)."
out, w = result
s = np.array([1.0, 0.0]) / np.sqrt(2)
expected_w = np.exp(s) / np.exp(s).sum()
assert np.allclose(w, [expected_w]), f"The weights should be the softmax of the scaled scores {s}, but you returned {w}."
assert np.allclose(out, [[expected_w @ [10.0, 20.0]]]), "The output should be the weights times the values."
assert np.allclose(w.sum(axis=1), 1.0), "Each row of the weights sums to one."
--- hint
Reuse the scaled scores, apply the stable softmax along the last axis, and multiply the weights by V.
--- hint
`return weights @ V, weights` once `weights` has been computed.
```

## Debug the scale

This scaling divides by the dimension instead of its square root, so the scores are squashed too far and the weights become nearly uniform.

```python debug id=scale-dimension title="Scale by the square root"
import numpy as np

Q = np.array([[1.0, 2.0]])
K = np.array([[3.0, 4.0], [1.0, 0.0]])
scores = Q @ K.T / Q.shape[-1]          # bug: divides by d instead of sqrt(d)
print("scores:", scores)
--- solution
import numpy as np

Q = np.array([[1.0, 2.0]])
K = np.array([[3.0, 4.0], [1.0, 0.0]])
scores = Q @ K.T / np.sqrt(Q.shape[-1])
print("scores:", scores)
--- test
assert np.allclose(scores, [[11 / np.sqrt(2), 1 / np.sqrt(2)]]), f"With d = 2 the scores should be divided by sqrt(2), giving {[[11 / np.sqrt(2), 1 / np.sqrt(2)]]}, but they are {scores}."
--- hint
The scale is the square root of the key dimension, as in the formula.
--- hint
Use `np.sqrt(Q.shape[-1])`.
```

## Predict the variance

```python predict id=predict-variance title="By how much does the raw score''s spread grow when d grows from 4 to 16?"
import numpy as np
print(np.sqrt(16) / np.sqrt(4))
--- options
* 2.0
4.0
16.0
1.0
--- explain
The variance of a dot product grows linearly with d, so its standard deviation grows like the square root of d. Going from 4 to 16 multiplies the spread by sqrt(16 / 4) = 2.
```

## Recap

- Attention is softmax of the scaled scores, applied to the values.
- Dividing by the square root of the key dimension keeps the variance of the scores at one.
- Each row of the weights is a distribution over the keys, summing to one.
- The same formula runs once per head in a transformer, which is the subject of the next lesson.

**Up next:** multi-head attention, which runs several attentions in parallel on different views of the data.
', 0, '[]', '[]', '2026-06-25T07:00:34.475Z', '2026-10-19T07:00:34.475Z'),
('les_transformers_from_scratch_2_2', 'sec_transformers_from_scratch_2', 'crs_transformers_from_scratch', 'Multi-head attention', 'interactive', 1, 1080, NULL, NULL, 'One attention pattern captures one kind of relationship. A token may need to look at the previous word for grammar, at the subject of the sentence for agreement, and at a related noun for meaning, all at once. **Multi-head attention** runs several attentions in parallel, each on its own slice of the representation, then combines their outputs. Each head learns to look for something different.

## Splitting into heads

Suppose each token has $d$ features and there are $h$ heads. Each head works on $d / h$ features. Splitting is a reshape, and merging back is the reverse reshape.

```python run
import numpy as np

X = np.arange(12, dtype=float).reshape(3, 4)     # 3 tokens, 4 features
h = 2
n, d = X.shape
heads = X.reshape(n, h, d // h).transpose(1, 0, 2)   # shape (heads, tokens, features per head)
print("shape:", heads.shape)
print("head 0, token 0:", heads[0, 0])
print("head 1, token 0:", heads[1, 0])
```

Head 0 sees the first two features of every token, and head 1 sees the last two. Each head therefore has its own subspace to work in.

## The multi-head formula

Each head computes attention on its own projections of the input, and the results are concatenated and projected back to the model size:

$$
\operatorname{MultiHead}(X) = \operatorname{Concat}(\text{head}_1, \dots, \text{head}_h)\, W_O, \qquad \text{head}_i = \operatorname{Attention}(XW_i^Q, XW_i^K, XW_i^V)
$$

```python run
def attention_heads(H_q, H_k, H_v):
    d_head = H_q.shape[-1]
    scores = H_q @ H_k.transpose(0, 2, 1) / np.sqrt(d_head)
    e = np.exp(scores - scores.max(axis=-1, keepdims=True))
    w = e / e.sum(axis=-1, keepdims=True)
    return w @ H_v

rng = np.random.default_rng(0)
x = rng.normal(size=(5, 8))                     # 5 tokens, model size 8
h_count = 4
Wq, Wk, Wv = (rng.normal(size=(8, 8)) * 0.3 for _ in range(3))
def split(M):
    return M.reshape(5, h_count, 2).transpose(1, 0, 2)
out_heads = attention_heads(split(x @ Wq), split(x @ Wk), split(x @ Wv))
merged = out_heads.transpose(1, 0, 2).reshape(5, 8)
print("heads:", out_heads.shape, "| merged back to model size:", merged.shape)
```

The merged output has the same shape as the input, so the next layer does not need to know that attention was split.

> **Under the hood:** real models compute all the heads with one batched matrix product, the same way as this code, rather than looping over heads.

Each head sees a different slice of the features, so the heads produce different outputs for the same tokens.

```python run
out_per_head = [out_heads[h].round(2) for h in range(h_count)]
print("head 0, first token:", out_per_head[0][0])
print("head 1, first token:", out_per_head[1][0])
print("the heads disagree:", not np.allclose(out_heads[0], out_heads[1]))
```

## Challenge: split into heads

```python exercise id=split-heads title="Split the features into heads"
import numpy as np

# TODO: `split_heads(X, h)` takes a (tokens, features) array and returns a (heads, tokens, features // heads) array.
# Head i receives the features with indices i·(features // h) up to (i + 1)·(features // h) − 1.
def split_heads(X, h):
    ...
--- solution
import numpy as np

def split_heads(X, h):
    X = np.asarray(X)
    n, d = X.shape
    return X.reshape(n, h, d // h).transpose(1, 0, 2)
--- test
import numpy as np
X = np.arange(12, dtype=float).reshape(3, 4)
result = split_heads(X, 2)
assert result is not None, "Replace the `...` in `split_heads` with code that returns the heads."
assert result.shape == (2, 3, 2), f"Two heads of three tokens with two features each should give (2, 3, 2), but you returned {result.shape}."
assert np.array_equal(result[0, 0], [0.0, 1.0]) and np.array_equal(result[1, 0], [2.0, 3.0]), "Head 0 should hold the first two features of token 0, and head 1 the next two."
--- hint
Reshape to (tokens, heads, features per head), then move the heads axis to the front with `transpose(1, 0, 2)`.
--- hint
`X.reshape(n, h, d // h).transpose(1, 0, 2)`.
```

Splitting and merging are exact inverses, so no information is lost by the reshape alone. Check the round trip on the input.

```python run
round_trip = x.reshape(5, h_count, 2).transpose(1, 0, 2).transpose(1, 0, 2).reshape(5, 8)
print("split then merge recovers the input:", np.allclose(round_trip, x))
```

## Challenge: merge heads

```python exercise id=merge-heads title="Merge the heads back"
import numpy as np

# TODO: `merge_heads(H)` takes a (heads, tokens, features per head) array and returns a (tokens, heads × features per head)
# array, the exact inverse of splitting.
def merge_heads(H):
    ...
--- solution
import numpy as np

def merge_heads(H):
    H = np.asarray(H)
    h, n, dh = H.shape
    return H.transpose(1, 0, 2).reshape(n, h * dh)
--- test
import numpy as np
X = np.arange(12, dtype=float).reshape(3, 4)
H = X.reshape(3, 2, 2).transpose(1, 0, 2)
result = merge_heads(H)
assert result is not None, "Replace the `...` in `merge_heads` with code that returns the merged array."
assert result.shape == (3, 4), "Merging should restore the original shape."
assert np.array_equal(result, X), "Merging must be the exact inverse of splitting."
--- hint
Move the heads axis back to the middle with `transpose(1, 0, 2)`, then reshape so the head features sit side by side.
--- hint
`H.transpose(1, 0, 2).reshape(n, h * dh)`.
```

## Debug the reshape

This split is meant to give each head a slice of the features for every token, but it reshapes straight into heads, so the tokens get mixed across heads.

```python debug id=wrong-reshape title="Split features, not tokens"
import numpy as np

X = np.arange(12, dtype=float).reshape(3, 4)
heads = X.reshape(2, 3, 2)              # bug: this splits the tokens across heads
print("head 0:", heads[0])
--- solution
import numpy as np

X = np.arange(12, dtype=float).reshape(3, 4)
heads = X.reshape(3, 2, 2).transpose(1, 0, 2)
print("head 0:", heads[0])
--- test
assert np.array_equal(heads[0], [[0.0, 1.0], [4.0, 5.0], [8.0, 9.0]]), f"Head 0 should hold the first two features of every token, but it holds {heads[0].tolist()}. Keep the token axis first when you reshape."
--- hint
The token axis must stay in front when the features are split.
--- hint
Reshape to `(3, 2, 2)` and then move the head axis to the front.
```

## Predict the shape

```python predict id=predict-heads title="What shape is the output of two heads on four tokens with model size 8?"
import numpy as np
heads = np.zeros((2, 4, 4))
print(heads.transpose(1, 0, 2).reshape(4, 8).shape)
--- options
* (4, 8)
(2, 4, 4)
(8, 4)
(4, 4)
--- explain
Each head outputs four tokens of size four. Merging two heads gives four tokens of size eight, the original model size.
```

## Recap

- Multi-head attention splits the features into heads, runs attention on each, and merges the results.
- Each head can specialize in a different relationship between tokens.
- Splitting and merging are reshapes, and merging is the exact inverse of splitting.
- The merged output keeps the model''s shape, so the rest of the network is unchanged.

**Up next:** causal masks and positional information, the two ingredients that make a language model work.
', 0, '[]', '[]', '2026-06-25T07:00:34.475Z', '2026-10-19T07:00:34.475Z'),
('les_transformers_from_scratch_2_3', 'sec_transformers_from_scratch_2', 'crs_transformers_from_scratch', 'Causal masks and positional information', 'interactive', 2, 960, NULL, NULL, 'A language model predicts the next token, so it must not see the tokens it is trying to predict. Two additions make that possible and let the model know where each token sits: a **causal mask** that hides the future, and **positional encodings** that tell the model the order of tokens, which attention alone cannot see.

## The causal mask

Before the softmax, set every score for a future position to minus infinity. The softmax then gives those positions zero weight, so each token attends only to itself and what came before.

```python run
import numpy as np

scores = np.arange(9, dtype=float).reshape(3, 3)
mask = np.triu(np.ones((3, 3), dtype=bool), k=1)     # True above the diagonal, the future
masked = np.where(mask, -np.inf, scores)
e = np.exp(masked - masked.max(axis=1, keepdims=True))
weights = e / e.sum(axis=1, keepdims=True)
print(np.round(weights, 3))
```

The first row has a single weight of one: the first token can only see itself. The last row spreads its weight over all three tokens.

## Sinusoidal positions

A transformer needs a unique signal for each position. The original design adds a fixed pattern of sines and cosines at different frequencies, so each position has its own mixture, and nearby positions have similar patterns.

$$
PE_{(pos, 2i)} = \sin\!\left(\frac{pos}{10000^{2i/d}}\right), \qquad PE_{(pos, 2i+1)} = \cos\!\left(\frac{pos}{10000^{2i/d}}\right)
$$

```python run
def sinusoidal_positions(n_pos, d):
    pos = np.arange(n_pos)[:, None]
    i = np.arange(d // 2)[None, :]
    angles = pos / 10000 ** (2 * i / d)
    out = np.zeros((n_pos, d))
    out[:, 0::2] = np.sin(angles)
    out[:, 1::2] = np.cos(angles)
    return out

PE = sinusoidal_positions(6, 8)
print(np.round(PE[:3], 2))
```

The first position is always [0, 1, 0, 1, ...] and the pattern changes smoothly from one position to the next.

## Why order matters

```python run
words = ["dog", "bites", "man"]
swapped = ["man", "bites", "dog"]
print("same words:", sorted(words) == sorted(swapped), "| same order:", words == swapped)
```

Adding the positional pattern to the token embeddings gives attention the order information it was missing.

> **Pitfall:** the mask must be applied before the softmax, as minus infinity in the scores. Applying it to the weights afterwards leaves rows that no longer sum to one.

> **In the wild:** modern models replaced sinusoidal positions with learned or rotary encodings, covered in the final section, but the job is the same: tell the model where each token is.

Nearby positions get similar encodings, which lets the model reason about distance. Inner products between positions show it.

```python run
PE_long = sinusoidal_positions(20, 16)
similarity = PE_long @ PE_long.T
print("similarity of position 0 with positions 1, 2, 10:", np.round(similarity[0, [1, 2, 10]], 2))
```

## Challenge: masked softmax

```python exercise id=masked-softmax title="Softmax with a causal mask"
import numpy as np

# TODO: `causal_softmax(scores)` takes an (n, n) score matrix and returns the row-wise softmax in which every entry
# above the diagonal (where the key is in the future) is treated as minus infinity, so its weight is zero.
def causal_softmax(scores):
    ...
--- solution
import numpy as np

def causal_softmax(scores):
    scores = np.asarray(scores, dtype=float)
    n = scores.shape[0]
    mask = np.triu(np.ones((n, n), dtype=bool), k=1)
    masked = np.where(mask, -np.inf, scores)
    e = np.exp(masked - masked.max(axis=1, keepdims=True))
    return e / e.sum(axis=1, keepdims=True)
--- test
import numpy as np
result = causal_softmax(np.zeros((3, 3)))
assert result is not None, "Replace the `...` in `causal_softmax` with code that returns the weights."
assert np.allclose(result[0], [1.0, 0.0, 0.0]), "The first token may see only itself, so its row is [1, 0, 0]."
assert np.allclose(result[2], [1 / 3, 1 / 3, 1 / 3]), "The last token sees all three tokens equally when all scores are zero."
assert np.allclose(np.triu(result, k=1), 0.0), "No weight may fall on a future position."
--- hint
Build the mask with `np.triu(..., k=1)`, replace the masked scores with `-np.inf`, then apply the usual row-wise softmax.
--- hint
`masked = np.where(mask, -np.inf, scores)` before exponentiating.
```

## Challenge: sinusoidal positions

```python exercise id=sin-positions title="Sinusoidal position encodings"
import numpy as np

# TODO: `sinusoidal_positions(n_pos, d)` returns an (n_pos, d) array with entries sin(pos / 10000^(2i/d)) in the even
# columns and cos(pos / 10000^(2i/d)) in the odd columns, where i is the pair index.
def sinusoidal_positions(n_pos, d):
    ...
--- solution
import numpy as np

def sinusoidal_positions(n_pos, d):
    pos = np.arange(n_pos)[:, None]
    i = np.arange(d // 2)[None, :]
    angles = pos / 10000 ** (2 * i / d)
    out = np.zeros((n_pos, d))
    out[:, 0::2] = np.sin(angles)
    out[:, 1::2] = np.cos(angles)
    return out
--- test
import numpy as np
PE = sinusoidal_positions(4, 4)
assert PE is not None, "Replace the `...` in `sinusoidal_positions` with code that returns the encodings."
assert PE.shape == (4, 4), "There is one row per position and one column per feature."
assert np.allclose(PE[0], [0.0, 1.0, 0.0, 1.0]), "Position zero has sine 0 and cosine 1 in every pair."
assert np.allclose(PE[1, 0], np.sin(1.0)), "The first pair at position 1 has angle 1 / 10000^0 = 1."
--- hint
Use the pair index `i` from `np.arange(d // 2)` to compute the angle, then fill the even columns with sines and the odd columns with cosines.
--- hint
`out[:, 0::2] = np.sin(angles)` and `out[:, 1::2] = np.cos(angles)`.
```

## Debug the sine and cosine

This encoding is meant to put sines in the even columns and cosines in the odd columns, but they are swapped, so position zero comes out as [1, 0, 1, 0].

```python debug id=swapped-trig title="Sines in even columns"
import numpy as np

pos = np.arange(4)[:, None]
angles = pos / 10000 ** (2 * np.arange(2)[None, :] / 4)
out = np.zeros((4, 4))
out[:, 0::2] = np.cos(angles)            # bug: the even columns should hold sines
out[:, 1::2] = np.sin(angles)
print("position 0:", out[0])
--- solution
import numpy as np

pos = np.arange(4)[:, None]
angles = pos / 10000 ** (2 * np.arange(2)[None, :] / 4)
out = np.zeros((4, 4))
out[:, 0::2] = np.sin(angles)
out[:, 1::2] = np.cos(angles)
print("position 0:", out[0])
--- test
assert np.allclose(out[0], [0.0, 1.0, 0.0, 1.0]), f"Position zero should be [0, 1, 0, 1], but it is {out[0]}. Even columns hold sines and odd columns hold cosines."
--- hint
At position zero every sine is zero and every cosine is one.
--- hint
Swap the two assignments so the sines go in the even columns.
```

## Predict the mask

```python predict id=predict-causal title="How many entries of a 3 × 3 causal mask are True?"
import numpy as np
mask = np.tril(np.ones((3, 3), dtype=bool))
print(int(mask.sum()))
--- options
* 6
3
9
4
--- explain
The allowed positions form the lower triangle, including the diagonal. Row one has one allowed position, row two has two and row three has three, so the total is 1 + 2 + 3 = 6.

```', 0, '[]', '[]', '2026-06-25T07:00:34.475Z', '2026-10-19T07:00:34.475Z'),
('les_transformers_from_scratch_2_4', 'sec_transformers_from_scratch_2', 'crs_transformers_from_scratch', 'Checkpoint: attention', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"Why are attention scores divided by the square root of the key dimension?","options":["To make the weights sum to two","To keep the variance of the scores near one, so softmax keeps useful gradients","To remove the need for a mask","To make the output the same size as the input"],"answerIndex":1,"explanation":"The variance of a dot product grows with the dimension. Scaling by the square root keeps softmax out of its saturated regime."},{"id":"q2","prompt":"In a causal language model, which positions may token 2 attend to?","options":["Only token 2","Tokens 0, 1 and 2","Tokens 2 and 3 only","All tokens, including future ones"],"answerIndex":1,"explanation":"The causal mask hides future positions, so token 2 sees itself and everything before it."},{"id":"q3","prompt":"What does multi-head attention compute?","options":["One attention over the full features, repeated h times","Several attentions on separate slices of the features, concatenated and projected","A recurrent update for each head","The average of the token embeddings"],"answerIndex":1,"explanation":"Each head attends on its own subspace, which lets different heads capture different relationships. The results are concatenated and projected back."},{"id":"q4","prompt":"Why do transformers need positional information?","options":["Attention is invariant to the order of the tokens, so position must be added","Attention cannot compute dot products","Softmax requires position indices","Positional encodings speed up training"],"answerIndex":0,"explanation":"Permuting the tokens permutes the attention outputs but otherwise leaves them unchanged, so the model has no notion of order unless it is given one."},{"id":"q5","prompt":"A sinusoidal positional encoding gives position 0 the pattern…","options":["[1, 0, 1, 0]","[0, 1, 0, 1]","[0, 0, 0, 0]","[1, 1, 1, 1]"],"answerIndex":1,"explanation":"At position zero every sine is zero and every cosine is one, so the even entries are 0 and the odd entries are 1."}]', '[]', '2026-06-25T07:00:34.475Z', '2026-10-19T07:00:34.475Z'),
('les_transformers_from_scratch_3_1', 'sec_transformers_from_scratch_3', 'crs_transformers_from_scratch', 'Tokenization with byte-pair encoding', 'interactive', 0, 1200, NULL, NULL, 'A transformer does not read letters or words. It reads **tokens**, pieces of text drawn from a fixed vocabulary. Byte-pair encoding (BPE) builds that vocabulary from data: start with single characters, then repeatedly merge the most frequent adjacent pair into a new symbol. Common words end up as single tokens, and rare words are split into familiar pieces, so the vocabulary stays a manageable size and no word is ever unknown.

## Words as symbols

Each word is written as a sequence of symbols, here single characters, with an end-of-word marker. The corpus keeps a count of how often each word appears.

```python run
corpus = {
    ("l", "o", "w", "</w>"): 5,
    ("l", "o", "w", "e", "r", "</w>"): 2,
    ("n", "e", "w", "e", "s", "t", "</w>"): 6,
    ("w", "i", "d", "e", "s", "t", "</w>"): 3,
}
print("number of distinct words:", len(corpus))
print("total occurrences:", sum(corpus.values()))
```

## Count adjacent pairs

Each adjacent pair of symbols is counted once for every occurrence of its word. The most frequent pair is the next candidate for a merge.

```python run
from collections import Counter

pairs = Counter()
for symbols, freq in corpus.items():
    for a, b in zip(symbols, symbols[1:]):
        pairs[(a, b)] += freq
print("most common pairs:", pairs.most_common(3))
```

Three pairs tie at nine occurrences: ("e", "s"), ("s", "t") and ("t", "</w>"). A deterministic tie-break, such as the smallest pair in alphabetical order, keeps the training reproducible.

## Merge and repeat

```python run
def merge_pair_in_corpus(corpus, pair):
    new_corpus = {}
    for symbols, freq in corpus.items():
        out, i = [], 0
        while i < len(symbols):
            if i + 1 < len(symbols) and (symbols[i], symbols[i + 1]) == pair:
                out.append(symbols[i] + symbols[i + 1])
                i += 2
            else:
                out.append(symbols[i])
                i += 1
        new_corpus[tuple(out)] = new_corpus.get(tuple(out), 0) + freq
    return new_corpus

corpus = merge_pair_in_corpus(corpus, ("e", "s"))
print(list(corpus.items())[2])
```

After the first merge, "es" is a single symbol, so "newest" and "widest" now share a token. Repeating this many times builds the whole vocabulary.

> **Pitfall:** BPE is learned from a corpus, so its tokens reflect that corpus. A tokenizer trained on English may split code or other languages into far more tokens, which costs context length and money.

> **In the wild:** GPT-style models use byte-level BPE, which starts from raw bytes so that any text, in any script, can be encoded.

After one merge the number of distinct symbols shrinks, because the pair now counts as one piece. Counting the symbols before and after shows the effect.

```python run
def symbol_types(corpus):
    return len({s for symbols in corpus for s in symbols})

before = symbol_types(corpus.keys())
merged_corpus = merge_pair_in_corpus(corpus, ("s", "t"))
print("symbol types before merging (''s'', ''t''):", before)
print("symbol types after:", symbol_types(merged_corpus.keys()))
```

## Challenge: count the pairs

```python exercise id=count-pairs title="Count adjacent pairs"
from collections import Counter

# TODO: `count_pairs(corpus)` takes a dictionary mapping tuples of symbols to frequencies and returns a Counter of
# adjacent pairs, where each pair counts the frequency of the word it came from.
def count_pairs(corpus):
    ...
--- solution
from collections import Counter

def count_pairs(corpus):
    pairs = Counter()
    for symbols, freq in corpus.items():
        for a, b in zip(symbols, symbols[1:]):
            pairs[(a, b)] += freq
    return pairs
--- test
from collections import Counter
result = count_pairs({("a", "b", "a"): 2, ("b", "a"): 1})
assert result is not None, "Replace the `...` in `count_pairs` with code that returns the counts."
assert result[("a", "b")] == 2, "The pair (a, b) appears once in a word that occurs twice, so it counts 2."
assert result[("b", "a")] == 3, "The pair (b, a) appears once in the twice-occurring word and once in the other, so it counts 2 + 1 = 3."
assert sum(result.values()) == 5, "Each word of length n contributes n − 1 pairs, weighted by its frequency."
--- hint
Loop over the words and their frequencies, look at each neighbouring pair with `zip(symbols, symbols[1:])`, and add the frequency to that pair.
--- hint
`pairs[(a, b)] += freq` inside the inner loop.
```

## Challenge: the best pair

```python exercise id=best-pair title="Choose the most frequent pair"
# TODO: `best_pair(counts)` returns the pair with the highest count. If several pairs tie, return the one that comes
# first in alphabetical order.
def best_pair(counts):
    ...
--- solution
def best_pair(counts):
    return sorted(counts.items(), key=lambda kv: (-kv[1], kv[0]))[0][0]
--- test
counts = {("a", "b"): 3, ("b", "c"): 3, ("a", "c"): 1}
result = best_pair(counts)
assert result is not None, "Replace the `...` in `best_pair` with code that returns the pair."
assert result == ("a", "b"), f"Two pairs tie at 3, and (''a'', ''b'') comes first alphabetically, but you returned {result!r}."
assert best_pair({("x", "y"): 9}) == ("x", "y"), "A single pair is the best pair."
--- hint
Sort the items by count from highest to lowest, and break ties by the pair itself.
--- hint
`sorted(counts.items(), key=lambda kv: (-kv[1], kv[0]))[0][0]`.
```

## Debug the overlapping merge

This merge is meant to combine each occurrence of a pair, but it merges the wrong symbols when the pair overlaps itself, so ("a", "a", "a") becomes ("aa", "aa", "a").

```python debug id=overlap-merge title="Merge left to right, without reusing symbols"
def merge_word(symbols, pair):
    return tuple(
        a + b if (a, b) == pair else a
        for a, b in zip(symbols, symbols[1:])
    ) + (symbols[-1],)               # bug: a symbol inside a merged pair is also used as the start of the next pair

print(merge_word(("a", "a", "a"), ("a", "a")))
--- solution
def merge_word(symbols, pair):
    out, i = [], 0
    while i < len(symbols):
        if i + 1 < len(symbols) and (symbols[i], symbols[i + 1]) == pair:
            out.append(symbols[i] + symbols[i + 1])
            i += 2
        else:
            out.append(symbols[i])
            i += 1
    return tuple(out)

print(merge_word(("a", "a", "a"), ("a", "a")))
--- test
assert merge_word(("a", "a", "a"), ("a", "a")) == ("aa", "a"), f"Merging left to right gives (''aa'', ''a''), but the code gives {merge_word((''a'', ''a'', ''a''), (''a'', ''a''))}. Once a pair is merged, its symbols must not be used again."
assert merge_word(("l", "o", "w"), ("o", "w")) == ("l", "ow"), "A simple pair in the middle of a word should merge once."
--- hint
When two symbols merge, the scan must skip both of them, so the next comparison starts after the merged pair.
--- hint
Use a while loop with an index, and advance by two after a merge and by one otherwise.
```

## Predict the number of tokens

```python predict id=predict-bpe title="How many symbols does (''a'', ''a'', ''a'') have after merging (''a'', ''a'')?"
from collections import Counter
symbols = ("a", "a", "a")
merged = ("aa", "a")
print(len(merged))
--- options
* 2
3
1
4
--- explain
Merging left to right joins the first two a''s into "aa" and leaves the third a alone, so two symbols remain.

```', 0, '[]', '[]', '2026-06-25T07:00:34.475Z', '2026-10-19T07:00:34.475Z'),
('les_transformers_from_scratch_3_2', 'sec_transformers_from_scratch_3', 'crs_transformers_from_scratch', 'Embeddings and layer normalization', 'interactive', 1, 960, NULL, NULL, 'Once text is tokens, each token must become a vector the network can compute with. An **embedding table** maps every token id to a learned vector, and a position table adds where in the sequence the token sits. The result is the input to the transformer. Before any layer reads it, the representation is typically normalized, and **layer normalization** is the tool that keeps the numbers in a stable range at every layer.

## Embedding lookup

An embedding is a row lookup: token id 7 selects row 7 of the table. The model learns the rows during training, so tokens used in similar ways end up with similar vectors.

```python run
import numpy as np

rng = np.random.default_rng(0)
vocab_size, d_model = 10, 4
E = rng.normal(0, 0.1, (vocab_size, d_model))      # one learned row per token
tokens = np.array([3, 7, 3])
x = E[tokens]                                       # lookup: shape (3 tokens, 4 features)
print("shape:", x.shape)
print("the same token gives the same vector:", np.allclose(x[0], x[2]))
```

## Layer normalization

Layer normalization standardizes each token''s own feature vector: subtract its mean and divide by its standard deviation, then apply a learned scale and shift. It works per token, so it does not depend on the other tokens or on the batch size.

$$
\operatorname{LN}(x) = \gamma \odot \frac{x - \mu}{\sqrt{\sigma^2 + \epsilon}} + \beta, \qquad \mu, \sigma^2 \text{ computed over the features of each token}
$$

```python run
def layer_norm(x, gamma=1.0, beta=0.0, eps=1e-5):
    mu = x.mean(axis=-1, keepdims=True)
    var = x.var(axis=-1, keepdims=True)
    return gamma * (x - mu) / np.sqrt(var + eps) + beta

normed = layer_norm(x * 100.0)                     # badly scaled input
print("means per token:", np.round(normed.mean(axis=-1), 6))
print("std per token:  ", np.round(normed.std(axis=-1), 4))
```

Whatever the input scale, each token comes out with mean zero and standard deviation one.

> **Pitfall:** normalize across the features, which is the last axis, not across the tokens. Normalizing across tokens makes each token depend on the rest of the sequence.

> **In the wild:** transformers place layer normalization before each sublayer in modern designs, which makes deep stacks train more reliably.

The same token at two positions gets two different vectors, because the position rows differ. This is how the model can tell "dog" at the start of a sentence from "dog" at the end.

```python run
P_demo = rng.normal(0, 0.1, (6, 4))
same_token = E[np.array([3, 3])] + P_demo[:2]
print("same token, two positions, identical:", np.allclose(same_token[0], same_token[1]))
print("difference between them:", np.round(same_token[1] - same_token[0], 3))
```

## Challenge: the embedding with positions

```python exercise id=embed-tokens title="Embeddings plus positions"
import numpy as np

# TODO: `embed(tokens, E, P)` returns the token embeddings E[tokens] with the position rows P[0 .. len(tokens) − 1] added.
def embed(tokens, E, P):
    ...
--- solution
import numpy as np

def embed(tokens, E, P):
    tokens = np.asarray(tokens)
    E = np.asarray(E, dtype=float)
    P = np.asarray(P, dtype=float)
    return E[tokens] + P[:len(tokens)]
--- test
import numpy as np
E_t = np.array([[1.0, 0.0], [0.0, 1.0], [2.0, 2.0]])
P_t = np.array([[10.0, 10.0], [20.0, 20.0], [30.0, 30.0]])
result = embed([2, 0], E_t, P_t)
assert result is not None, "Replace the `...` in `embed` with code that returns the embeddings."
assert result.shape == (2, 2), "Two tokens with two features should give shape (2, 2)."
assert np.allclose(result, [[12.0, 12.0], [21.0, 20.0]]), f"Token 2 gives [2, 2] plus position 0 [10, 10], and token 0 gives [1, 0] plus position 1 [20, 20]. You returned {result}."
--- hint
Look up the rows with `E[tokens]`, take the first `len(tokens)` position rows with `P[:len(tokens)]`, and add them.
--- hint
`return E[tokens] + P[:len(tokens)]`.
```

Learned scale and shift let the network undo the normalization where it wants to. With a gain of two and a shift of one, the output has standard deviation two and mean one.

```python run
gamma_demo, beta_demo = 2.0, 1.0
normed_demo = gamma_demo * layer_norm(x) + beta_demo
print("mean per token:", np.round(normed_demo.mean(axis=-1), 4))
print("std per token:", np.round(normed_demo.std(axis=-1), 4))
```

## Challenge: layer normalization

```python exercise id=layer-norm-fn title="Layer normalization of each token"
import numpy as np

# TODO: `layer_norm(x)` standardizes each row of the 2-D array x (each token) to mean zero and standard deviation one,
# using eps = 1e-5 in the denominator. Normalize across the features, which is the last axis.
def layer_norm(x):
    ...
--- solution
import numpy as np

def layer_norm(x):
    x = np.asarray(x, dtype=float)
    mu = x.mean(axis=-1, keepdims=True)
    var = x.var(axis=-1, keepdims=True)
    return (x - mu) / np.sqrt(var + 1e-5)
--- test
import numpy as np
result = layer_norm(np.array([[1.0, 2.0, 3.0], [10.0, 10.0, 40.0]]))
assert result is not None, "Replace the `...` in `layer_norm` with code that returns the normalized rows."
assert result.shape == (2, 3), "The shape should be preserved."
assert np.allclose(result.mean(axis=-1), 0.0, atol=1e-9), "Each row should have mean zero."
assert np.allclose(result.std(axis=-1), 1.0, atol=1e-3), "Each row should have standard deviation one."
assert np.allclose(result[0], [-1.2247, 0.0, 1.2247], atol=1e-3), f"The first row [1, 2, 3] normalizes to about [−1.225, 0, 1.225], but you returned {result[0]}."
--- hint
Compute the mean and variance of each row with `axis=-1, keepdims=True`, then subtract and divide.
--- hint
`(x - mu) / np.sqrt(var + 1e-5)`.
```

## Debug the normalization axis

This layer norm is meant to normalize each token''s features, but it averages across the tokens, so every token depends on the others.

```python debug id=ln-axis title="Normalize across features"
import numpy as np

x = np.array([[1.0, 2.0, 3.0], [10.0, 10.0, 40.0]])
mu = x.mean(axis=0, keepdims=True)                   # bug: averages down the tokens
var = x.var(axis=0, keepdims=True)
out = (x - mu) / np.sqrt(var + 1e-5)
print("row means:", np.round(out.mean(axis=1), 3))
--- solution
import numpy as np

x = np.array([[1.0, 2.0, 3.0], [10.0, 10.0, 40.0]])
mu = x.mean(axis=-1, keepdims=True)
var = x.var(axis=-1, keepdims=True)
out = (x - mu) / np.sqrt(var + 1e-5)
print("row means:", np.round(out.mean(axis=1), 3))
--- test
assert np.allclose(out.mean(axis=1), 0.0, atol=1e-6), f"Each token''s features should average to zero, but the row means are {out.mean(axis=1)}. Normalize across the last axis."
--- hint
Each token is one row, and its features are the columns.
--- hint
Use `axis=-1`, which runs across the features of each row.
```

## Predict the shape

```python predict id=predict-embed title="What shape is the embedding of a sequence of 5 tokens with model size 8?"
import numpy as np
E = np.zeros((100, 8))
tokens = np.arange(5)
print(E[tokens].shape)
--- options
* (5, 8)
(100, 8)
(8, 5)
(5,)
--- explain
The lookup selects one row of size 8 for each of the 5 tokens, giving shape (5, 8). The vocabulary of 100 rows is not kept.

```', 0, '[]', '[]', '2026-06-25T07:00:34.475Z', '2026-10-19T07:00:34.475Z'),
('les_transformers_from_scratch_3_3', 'sec_transformers_from_scratch_3', 'crs_transformers_from_scratch', 'The transformer block: residuals and feed-forward layers', 'interactive', 2, 1080, NULL, NULL, 'A transformer block combines two sublayers: attention, which lets tokens exchange information, and a feed-forward network, which transforms each token on its own. Each sublayer is wrapped in a **residual connection**, so its output is added to its input. That addition is what lets very deep stacks train: every block only has to learn a correction to what is already there.

## The residual stream

A token''s vector is a running sum. Each sublayer reads it, computes an update and adds that update back. The information about the token is preserved along the way, and nothing is lost to a fresh transformation at every layer.

```python run
import numpy as np

x = np.array([[1.0, -1.0, 0.5]])
update = np.array([[0.2, 0.0, -0.1]])        # what one sublayer wants to add
out = x + update
print("residual output:", out)
print("the input survives in the output:", np.allclose(out - update, x))
```

## Pre-norm blocks

In the modern arrangement, each sublayer reads a layer-normalized copy of the stream, and its output is added back to the unnormalized stream:

$$
x \leftarrow x + \operatorname{Attention}(\operatorname{LN}(x)), \qquad x \leftarrow x + \operatorname{FFN}(\operatorname{LN}(x))
$$

```python run
def layer_norm(x, eps=1e-5):
    mu = x.mean(axis=-1, keepdims=True)
    var = x.var(axis=-1, keepdims=True)
    return (x - mu) / np.sqrt(var + eps)

def feed_forward(x, W1, b1, W2, b2):
    return np.maximum(0.0, x @ W1 + b1) @ W2 + b2

rng = np.random.default_rng(0)
d, hidden = 4, 16
W1, b1 = rng.normal(0, 0.3, (d, hidden)), np.zeros(hidden)
W2, b2 = rng.normal(0, 0.3, (hidden, d)), np.zeros(d)
x = rng.normal(size=(3, d))
ffn_out = feed_forward(layer_norm(x), W1, b1, W2, b2)
print("feed-forward output shape:", ffn_out.shape)
print("input and output share a shape, so residuals can add:", (x + ffn_out).shape)
```

The feed-forward network expands each token to a wider hidden size, applies a non-linearity, and projects back. It is where much of a transformer''s parameters live.

## Stacking blocks

```python run
def block(x, attention_fn, ffn_fn):
    x = x + attention_fn(layer_norm(x))
    x = x + ffn_fn(layer_norm(x))
    return x

identity_attention = lambda z: np.zeros_like(z)
x_out = x
for _ in range(4):
    x_out = block(x_out, identity_attention, lambda z: feed_forward(z, W1, b1, W2, b2))
print("after four blocks, shape:", x_out.shape)
```

Stacking blocks repeats this pattern. The residual path keeps the signal alive through depth, and each block adds one more layer of refinement.

> **Pitfall:** forgetting a residual connection is one of the most damaging transformer bugs. The network still runs, but the signal from the input is lost and deep stacks fail to learn.

> **In the wild:** GPT-2 and most later models use pre-norm blocks with residuals around both sublayers, as in the code above.

Stacking blocks grows the stream when each sublayer adds something. Track how the size of each token''s vector changes across blocks.

```python run
stream = rng.normal(size=(3, d))
sizes = [np.linalg.norm(stream, axis=-1).mean()]
for _ in range(3):
    stream = block(stream, lambda z: 0.1 * z, lambda z: feed_forward(z, W1, b1, W2, b2))
    sizes.append(np.linalg.norm(stream, axis=-1).mean())
print("mean token norm after each block:", np.round(sizes, 3))
```

## Challenge: a transformer block

```python exercise id=transformer-block title="One transformer block"
import numpy as np

def layer_norm(x, eps=1e-5):
    mu = x.mean(axis=-1, keepdims=True)
    var = x.var(axis=-1, keepdims=True)
    return (x - mu) / np.sqrt(var + eps)

# TODO: `block(x, attention_fn, ffn_fn)` returns the output of one pre-norm block: first x plus attention_fn applied to
# layer_norm(x), then that result plus ffn_fn applied to layer_norm of it.
def block(x, attention_fn, ffn_fn):
    ...
--- solution
import numpy as np

def layer_norm(x, eps=1e-5):
    mu = x.mean(axis=-1, keepdims=True)
    var = x.var(axis=-1, keepdims=True)
    return (x - mu) / np.sqrt(var + eps)

def block(x, attention_fn, ffn_fn):
    x = x + attention_fn(layer_norm(x))
    x = x + ffn_fn(layer_norm(x))
    return x
--- test
import numpy as np
x = np.array([[1.0, 2.0, 3.0]])
out = block(x, lambda z: np.zeros_like(z), lambda z: 2.0 * z)
assert out is not None, "Replace the `...` in `block` with code that returns the block output."
normed = layer_norm(x)
assert np.allclose(out, x + 2.0 * layer_norm(x)), "With zero attention and a feed-forward of 2·z, the output should be x + 2·LN(x) after the residuals, computed on the normalized stream."
assert out.shape == x.shape, "A block keeps the shape of its input."
--- hint
Apply the attention to a normalized copy, add the result to `x`. Then do the same with the feed-forward on the new `x`.
--- hint
`x = x + attention_fn(layer_norm(x))`, then `x = x + ffn_fn(layer_norm(x))`, then return `x`.
```

## Challenge: the feed-forward sublayer

```python exercise id=ffn-layer title="The feed-forward sublayer"
import numpy as np

# TODO: `feed_forward(x, W1, b1, W2, b2)` returns max(0, x W1 + b1) W2 + b2 for a (tokens, d) array x.
def feed_forward(x, W1, b1, W2, b2):
    ...
--- solution
import numpy as np

def feed_forward(x, W1, b1, W2, b2):
    return np.maximum(0.0, np.asarray(x, dtype=float) @ W1 + b1) @ W2 + b2
--- test
import numpy as np
W1_t = np.array([[1.0, -1.0]])
b1_t = np.zeros(2)
W2_t = np.array([[1.0], [1.0]])
b2_t = np.array([0.5])
result = feed_forward(np.array([[2.0], [-3.0]]), W1_t, b1_t, W2_t, b2_t)
assert result is not None, "Replace the `...` in `feed_forward` with code that returns the output."
assert result.shape == (2, 1), "Two tokens with output size one should give shape (2, 1)."
assert np.allclose(result, [[2.5], [3.5]]), f"For x = 2 the hidden units are [2, −2] → [2, 0], so the output is 2 + 0.5 = 2.5. For x = −3 they are [−3, 3] → [0, 3], so the output is 3 + 0.5 = 3.5. You returned {result.ravel()}."
--- hint
Compute the hidden layer, `x @ W1 + b1`, apply `np.maximum(0, ...)`, then the second layer.
--- hint
`np.maximum(0.0, x @ W1 + b1) @ W2 + b2`.
```

## Debug the residual

This block is meant to keep the input through the residual connection, but it returns only the attention output, so the token''s own information is discarded.

```python debug id=missing-residual title="Keep the residual connection"
import numpy as np

def layer_norm(x, eps=1e-5):
    return (x - x.mean(axis=-1, keepdims=True)) / np.sqrt(x.var(axis=-1, keepdims=True) + eps)

x = np.array([[1.0, 2.0, 3.0]])
attn = lambda z: 0.5 * z
out = attn(layer_norm(x))                     # bug: the residual connection is missing
print("output:", np.round(out, 3))
--- solution
import numpy as np

def layer_norm(x, eps=1e-5):
    return (x - x.mean(axis=-1, keepdims=True)) / np.sqrt(x.var(axis=-1, keepdims=True) + eps)

x = np.array([[1.0, 2.0, 3.0]])
attn = lambda z: 0.5 * z
out = x + attn(layer_norm(x))
print("output:", np.round(out, 3))
--- test
assert np.allclose(out, x + 0.5 * layer_norm(x)), "The block output must add the sublayer''s result to the input, through a residual connection."
--- hint
A residual connection adds the input back to the sublayer''s output.
--- hint
`out = x + attn(layer_norm(x))`.
```

## Predict the residual

```python predict id=predict-residual title="What is the output of x + f(x) when f returns zero?"
import numpy as np
x = np.array([1.0, 2.0])
print(x + np.zeros_like(x))
--- options
* [1. 2.]
[0. 0.]
[2. 4.]
[1. 0.]
--- explain
A sublayer that returns zero leaves the stream unchanged, which is what residuals guarantee: the input is always preserved.

```', 0, '[]', '[]', '2026-06-25T07:00:34.475Z', '2026-10-19T07:00:34.475Z'),
('les_transformers_from_scratch_3_4', 'sec_transformers_from_scratch_3', 'crs_transformers_from_scratch', 'Putting it together: a tiny GPT', 'interactive', 3, 1320, NULL, NULL, 'Now the parts come together. A decoder-only transformer, the GPT design, is an embedding, a stack of blocks with causal attention, a final normalization and a projection back to the vocabulary. Given a sequence of tokens, it outputs a distribution over the next token at every position. This lesson assembles a tiny version in NumPy and checks the property that defines a causal language model: the future cannot influence the past.

## The architecture

```python run
import numpy as np

rng = np.random.default_rng(0)
vocab, d, T = 12, 8, 5
E = rng.normal(0, 0.1, (vocab, d))           # token embeddings
P = rng.normal(0, 0.1, (16, d))               # position embeddings
Wq, Wk, Wv = (rng.normal(0, 0.3, (d, d)) for _ in range(3))
W1, b1 = rng.normal(0, 0.3, (d, 16)), np.zeros(16)
W2, b2 = rng.normal(0, 0.3, (16, d)), np.zeros(d)

def layer_norm(x, eps=1e-5):
    return (x - x.mean(axis=-1, keepdims=True)) / np.sqrt(x.var(axis=-1, keepdims=True) + eps)

def causal_attention(x):
    Q, K, V = x @ Wq, x @ Wk, x @ Wv
    scores = Q @ K.T / np.sqrt(d)
    scores = np.where(np.triu(np.ones_like(scores, dtype=bool), k=1), -np.inf, scores)
    e = np.exp(scores - scores.max(axis=-1, keepdims=True))
    return (e / e.sum(axis=-1, keepdims=True)) @ V

def tiny_gpt(tokens):
    x = E[tokens] + P[:len(tokens)]
    x = x + causal_attention(layer_norm(x))
    x = x + np.maximum(0, layer_norm(x) @ W1 + b1) @ W2 + b2
    return layer_norm(x) @ E.T                # logits over the vocabulary, tied to the embeddings

tokens = np.array([1, 4, 7, 2, 9])
logits = tiny_gpt(tokens)
print("logits shape (tokens, vocabulary):", logits.shape)
```

The output projection reuses the embedding table, a technique called weight tying. It saves parameters and often helps.

## The causal property

Position $t$ must depend only on tokens $0$ to $t$. Changing a later token must leave the earlier predictions unchanged. This test is the most important check on a causal model.

```python run
changed = tokens.copy()
changed[-1] = 0                               # change only the last token
diff_before = np.abs(tiny_gpt(tokens)[:-1] - tiny_gpt(changed)[:-1]).max()
print("largest change in earlier predictions:", diff_before)
```

A difference of zero means the past is unaffected by the future. Without the causal mask this number would be large.

## Next-token predictions

```python run
probs = np.exp(logits - logits.max(axis=-1, keepdims=True))
probs = probs / probs.sum(axis=-1, keepdims=True)
print("probability of each next token at the last position sums to:", round(float(probs[-1].sum()), 6))
print("most likely next token after the sequence:", int(np.argmax(probs[-1])))
```

> **In the wild:** GPT-2, GPT-3 and their successors are this architecture at a much larger scale, with more layers, wider features, many heads and a large vocabulary.

For a whole sequence the model produces one attention matrix per layer. Its shape shows that every token has a row of weights over the tokens it may see.

```python run
x_demo = E[tokens] + P[:len(tokens)]
Q_demo, K_demo = x_demo @ Wq, x_demo @ Wk
s_demo = Q_demo @ K_demo.T / np.sqrt(d)
s_demo = np.where(np.triu(np.ones_like(s_demo, dtype=bool), k=1), -np.inf, s_demo)
w_demo = np.exp(s_demo - s_demo.max(axis=-1, keepdims=True))
w_demo = w_demo / w_demo.sum(axis=-1, keepdims=True)
print("attention matrix shape:", w_demo.shape)
print("first row (sees only itself):", np.round(w_demo[0], 3))
```

## Challenge: causal attention

```python exercise id=causal-attn title="Causal self-attention"
import numpy as np

# TODO: `causal_self_attention(x, Wq, Wk, Wv)` takes a (tokens, d) array and returns the causal self-attention output:
# queries, keys and values are x @ Wq, x @ Wk and x @ Wv. Scores are scaled by sqrt(d) and future positions are masked.
def causal_self_attention(x, Wq, Wk, Wv):
    ...
--- solution
import numpy as np

def causal_self_attention(x, Wq, Wk, Wv):
    x = np.asarray(x, dtype=float)
    Q, K, V = x @ Wq, x @ Wk, x @ Wv
    d = Q.shape[-1]
    scores = Q @ K.T / np.sqrt(d)
    scores = np.where(np.triu(np.ones_like(scores, dtype=bool), k=1), -np.inf, scores)
    e = np.exp(scores - scores.max(axis=-1, keepdims=True))
    return (e / e.sum(axis=-1, keepdims=True)) @ V
--- test
import numpy as np
rng_t = np.random.default_rng(3)
x_t = rng_t.normal(size=(4, 3))
Wq_t, Wk_t, Wv_t = (rng_t.normal(size=(3, 3)) for _ in range(3))
out = causal_self_attention(x_t, Wq_t, Wk_t, Wv_t)
assert out is not None, "Replace the `...` in `causal_self_attention` with code that returns the output."
assert out.shape == (4, 3), "There is one output per token, with the value size."
x2 = x_t.copy()
x2[-1] += 5.0
out2 = causal_self_attention(x2, Wq_t, Wk_t, Wv_t)
assert np.allclose(out[:-1], out2[:-1]), "Changing the last token must not change any earlier output. Check the causal mask."
--- hint
Build Q, K and V with the three matrices, scale the scores, mask the future, then take the softmax and multiply by V.
--- hint
Use the same steps as the attention lesson, with `np.triu(..., k=1)` as the mask.
```

## Challenge: next-token distribution

```python exercise id=next-distribution title="The next-token distribution"
import numpy as np

# TODO: `next_token_distribution(logits)` takes a (positions, vocabulary) array of logits and returns the softmax
# probabilities of the LAST position only, as a 1-D array that sums to one.
def next_token_distribution(logits):
    ...
--- solution
import numpy as np

def next_token_distribution(logits):
    last = np.asarray(logits, dtype=float)[-1]
    e = np.exp(last - last.max())
    return e / e.sum()
--- test
import numpy as np
result = next_token_distribution(np.array([[0.0, 0.0], [1.0, 1.0]]))
assert result is not None, "Replace the `...` in `next_token_distribution` with code that returns the probabilities."
assert result.shape == (2,), "There is one probability per vocabulary entry, for the last position only."
assert np.allclose(result, [0.5, 0.5]), "The last row has equal logits, so the distribution is uniform."
assert abs(result.sum() - 1.0) < 1e-9, "The probabilities must sum to one."
--- hint
Take the last row with `[-1]`, then apply the stable softmax to that row alone.
--- hint
`last = np.asarray(logits)[-1]`, then the usual shifted exponential and normalization.
```

## Debug the missing mask

This attention is meant to be causal, but the mask is missing, so each token can see the future and the model would cheat during training.

```python debug id=no-causal-mask title="Hide the future"
import numpy as np

rng_d = np.random.default_rng(4)
x = rng_d.normal(size=(4, 3))
Wq, Wk, Wv = (rng_d.normal(size=(3, 3)) for _ in range(3))
Q, K, V = x @ Wq, x @ Wk, x @ Wv
scores = Q @ K.T / np.sqrt(3)                 # bug: no mask is applied
e = np.exp(scores - scores.max(axis=-1, keepdims=True))
out = (e / e.sum(axis=-1, keepdims=True)) @ V
print("first output:", np.round(out[0], 3))
--- solution
import numpy as np

rng_d = np.random.default_rng(4)
x = rng_d.normal(size=(4, 3))
Wq, Wk, Wv = (rng_d.normal(size=(3, 3)) for _ in range(3))
Q, K, V = x @ Wq, x @ Wk, x @ Wv
scores = Q @ K.T / np.sqrt(3)
scores = np.where(np.triu(np.ones_like(scores, dtype=bool), k=1), -np.inf, scores)
e = np.exp(scores - scores.max(axis=-1, keepdims=True))
out = (e / e.sum(axis=-1, keepdims=True)) @ V
print("first output:", np.round(out[0], 3))
--- test
assert np.allclose(out[0], V[0]), "The first token may attend only to itself, so its output must equal its own value V[0]. Mask the future positions before the softmax."
--- hint
Positions after token t must get a score of minus infinity before the softmax.
--- hint
`scores = np.where(np.triu(np.ones_like(scores, dtype=bool), k=1), -np.inf, scores)`.
```

## Predict the causal check

```python predict id=predict-causal-gpt title="In a causal model, what happens to the first position''s prediction if the last token changes?"
print("it stays the same")
--- options
* it stays the same
it changes
it becomes zero
it becomes random
--- explain
The first position can only attend to itself, so no later token can affect its output. That is what makes the model causal.

```', 0, '[]', '[]', '2026-06-25T07:00:34.475Z', '2026-10-19T07:00:34.475Z'),
('les_transformers_from_scratch_4_1', 'sec_transformers_from_scratch_4', 'crs_transformers_from_scratch', 'Next-token prediction and its loss', 'interactive', 0, 960, NULL, NULL, 'Language models learn by predicting the next token. Every position in a sequence gives one training example: the input is the tokens so far, and the target is the token that follows. The loss is the cross-entropy between the model''s predicted distribution and the true next token, averaged over all positions. Nothing else about training is special, and the simplicity is a large part of its power.

## Shifting the targets

Given the tokens of a sentence, the inputs are everything except the last token, and the targets are everything except the first. Position $t$ is trained to predict token $t + 1$.

```python run
import numpy as np

tokens = np.array([5, 2, 9, 4, 1])
inputs, targets = tokens[:-1], tokens[1:]
for i, t in zip(inputs, targets):
    print(f"given {i}, the next token should be {t}")
```

Predicting the token you were given would be trivial, so the shift is what turns copying into learning.

## Cross-entropy over the vocabulary

For one position, the model outputs logits, one score per vocabulary entry. The loss is the negative log of the probability assigned to the correct token:

$$
\mathcal{L} = -\log \frac{e^{z_y}}{\sum_j e^{z_j}} = \operatorname{logsumexp}(z) - z_y
$$

```python run
def cross_entropy(logits, target):
    m = logits.max()
    lse = m + np.log(np.exp(logits - m).sum())
    return lse - logits[target]

logits = np.array([2.0, 0.5, -1.0])
print("loss if the true token is 0:", round(cross_entropy(logits, 0), 4))
print("loss if the true token is 2:", round(cross_entropy(logits, 2), 4))
print("uniform guess over 3 tokens:", round(np.log(3), 4))
```

A confident correct prediction has a small loss. A uniform guess over a vocabulary of size $V$ costs $\log V$, which is the baseline a trained model must beat.

## Perplexity

The average loss in nats can be read as perplexity, $e^{\mathcal{L}}$: roughly how many equally likely choices the model is torn between. A uniform model over a vocabulary of 50 has perplexity 50.

```python run
print("perplexity of a uniform model over 50 tokens:", round(float(np.exp(np.log(50))), 2))
```

> **Pitfall:** the loss must average over positions, not sum them, or long sequences dominate the update. Frameworks do this for you, but when you write a loss yourself, check its scale.

> **In the wild:** almost every language model in production is trained with exactly this objective, on trillions of tokens.

A randomly initialized model is close to uniform, so its loss starts near the log of the vocabulary size. Check that at initialization.

```python run
rng_init = np.random.default_rng(0)
V_init = 50
random_logits = rng_init.normal(0, 0.01, (4, V_init))
random_targets = rng_init.integers(0, V_init, 4)
print("loss at initialization:", round(float(np.mean([cross_entropy(random_logits[i], random_targets[i]) for i in range(4)])), 3))
print("log of the vocabulary size:", round(float(np.log(V_init)), 3))
```

## Challenge: the next-token pairs

```python exercise id=next-pairs title="Shift a sequence into inputs and targets"
import numpy as np

# TODO: `next_token_pairs(tokens)` returns a tuple (inputs, targets), where inputs holds every token except the last
# and targets holds every token except the first.
def next_token_pairs(tokens):
    ...
--- solution
import numpy as np

def next_token_pairs(tokens):
    tokens = np.asarray(tokens)
    return tokens[:-1], tokens[1:]
--- test
import numpy as np
inputs, targets = next_token_pairs([7, 3, 5])
assert inputs is not None, "Replace the `...` in `next_token_pairs` with code that returns (inputs, targets)."
assert list(inputs) == [7, 3], f"The inputs should be the tokens without the last one, [7, 3], but you returned {list(inputs)}."
assert list(targets) == [3, 5], f"The targets should be the tokens without the first one, [3, 5], but you returned {list(targets)}."
--- hint
Slice the array twice: once to drop the last element and once to drop the first.
--- hint
`return tokens[:-1], tokens[1:]`.
```

## Challenge: mean cross-entropy

```python exercise id=mean-ce title="Average cross-entropy over positions"
import numpy as np

# TODO: `mean_cross_entropy(logits, targets)` takes a (positions, vocabulary) array of logits and an array of target
# indices. It returns the average over positions of logsumexp(row) − row[target], computed stably.
def mean_cross_entropy(logits, targets):
    ...
--- solution
import numpy as np

def mean_cross_entropy(logits, targets):
    logits = np.asarray(logits, dtype=float)
    targets = np.asarray(targets)
    m = logits.max(axis=1, keepdims=True)
    lse = (m + np.log(np.exp(logits - m).sum(axis=1, keepdims=True))).ravel()
    return float(np.mean(lse - logits[np.arange(len(targets)), targets]))
--- test
import numpy as np
result = mean_cross_entropy(np.zeros((2, 3)), [0, 2])
assert result is not None, "Replace the `...` in `mean_cross_entropy` with code that returns the loss."
assert abs(result - np.log(3)) < 1e-9, f"Uniform logits over three tokens cost log 3 per position, so the mean is log 3 ≈ 1.0986, but you returned {result!r}."
big = mean_cross_entropy(np.array([[1000.0, 0.0]]), [0])
assert abs(big) < 1e-9, "A confident correct prediction with huge logits should cost almost nothing, without overflow."
--- hint
Subtract each row''s maximum before the exponential, then pick out the logit of each target with fancy indexing.
--- hint
`logits[np.arange(len(targets)), targets]` picks one entry per row.
```

## Debug the shift

This training setup is meant to predict the next token, but it uses the same tokens as inputs and targets, so the model is asked to copy its input.

```python debug id=no-shift title="Predict the next token, not the current one"
import numpy as np

tokens = np.array([5, 2, 9, 4, 1])
inputs, targets = tokens[:-1], tokens[:-1]     # bug: the targets should be shifted by one position
print("inputs:", inputs, "targets:", targets)
--- solution
import numpy as np

tokens = np.array([5, 2, 9, 4, 1])
inputs, targets = tokens[:-1], tokens[1:]
print("inputs:", inputs, "targets:", targets)
--- test
assert list(targets) == [2, 9, 4, 1], f"The target for each input is the next token, so targets should be [2, 9, 4, 1], but they are {list(targets)}."
--- hint
The target at position t is the token at position t + 1.
--- hint
Start the targets at the second token: `tokens[1:]`.
```

## Predict the loss

```python predict id=predict-ce title="What is the cross-entropy of a uniform guess over four tokens?"
import numpy as np
print(round(float(np.log(4)), 3))
--- options
* 1.386
0.25
4.0
2.0
--- explain
A uniform guess gives each of the four tokens probability one quarter, and the negative log of that is log 4 ≈ 1.386.
```

## Recap

- Each position in a sequence is one training example: predict the next token from the tokens before it.
- Targets are the inputs shifted by one position.
- Cross-entropy is logsumexp of the logits minus the logit of the true token, averaged over positions.
- Perplexity is the exponential of the loss, and a uniform model''s perplexity is the vocabulary size.

**Up next:** learning-rate schedules and gradient accumulation, the training knobs that make large models trainable.
', 0, '[]', '[]', '2026-06-25T07:00:34.475Z', '2026-10-19T07:00:34.475Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_transformers_from_scratch_4_2', 'sec_transformers_from_scratch_4', 'crs_transformers_from_scratch', 'Learning-rate schedules and gradient accumulation', 'interactive', 1, 1080, NULL, NULL, 'Training a transformer is sensitive to how fast the weights move. At the start, the gradients are noisy and the weights are random, so large steps can be destructive. Later, smaller steps refine the solution. A **learning-rate schedule** sets the step size over time: a short warmup, then a smooth decay. Separately, **gradient accumulation** lets a large effective batch size fit in memory by summing gradients from several small batches before one update.

## Warmup and cosine decay

Warmup raises the learning rate linearly from near zero to its peak over the first steps. Cosine decay then lowers it smoothly towards a floor.

$$
\eta(t) = \begin{cases} \eta_{\max}\,\dfrac{t+1}{T_w} & t < T_w \\[2mm] \eta_{\min} + \tfrac{1}{2}(\eta_{\max} - \eta_{\min})\bigl(1 + \cos(\pi p)\bigr), & p = \dfrac{t - T_w}{T - T_w} \end{cases}
$$

```python run
import numpy as np

def lr_schedule(step, max_lr=3e-4, warmup=10, total=100, min_lr=3e-5):
    if step < warmup:
        return max_lr * (step + 1) / warmup
    progress = (step - warmup) / (total - warmup)
    return min_lr + 0.5 * (max_lr - min_lr) * (1 + np.cos(np.pi * progress))

for step in [0, 5, 9, 10, 55, 99]:
    print(f"step {step:>3}: learning rate {lr_schedule(step):.6f}")
```

The rate rises over the first ten steps, peaks at step ten, and falls smoothly to the floor by the end. The warmup protects the early, noisy updates, and the decay lets the model settle.

## Gradient accumulation

If one batch of 512 examples does not fit in memory, process four batches of 128, add their gradients, and update once. For a mean loss, the correct combination weights each batch by its size.

```python run
rng = np.random.default_rng(0)
X = rng.normal(size=(512, 3))
y = X @ np.array([1.0, -2.0, 0.5]) + rng.normal(0, 0.1, 512)
w = np.zeros(3)

def grad(Xb, yb, w):
    return 2 * Xb.T @ (Xb @ w - yb) / len(yb)

full = grad(X, y, w)
accumulated = np.zeros(3)
for start in range(0, 512, 128):
    Xb, yb = X[start:start + 128], y[start:start + 128]
    accumulated += grad(Xb, yb, w) * len(yb) / 512     # weight each batch by its share
print("full batch:  ", np.round(full, 4))
print("accumulated: ", np.round(accumulated, 4))
```

The accumulated gradient matches the full-batch gradient, so the large effective batch comes at the memory cost of only one small batch.

> **Pitfall:** averaging the four batch gradients without weighting is correct only when every batch has the same size. Weighting by size is always right.

> **In the wild:** the schedule in large language-model training is typically warmup followed by cosine or linear decay, and accumulation is how training runs use batches far bigger than a single device could hold.

Plotting the schedule shows the whole shape at once: the ramp, the peak and the long decay.

```python run
import matplotlib.pyplot as plt

steps_plot = np.arange(100)
rates = [lr_schedule(s) for s in steps_plot]
fig, ax = plt.subplots(figsize=(5, 3))
ax.plot(steps_plot, rates)
ax.set_xlabel("step"); ax.set_ylabel("learning rate"); ax.grid(alpha=0.3)
plt.show()
```

## Challenge: the warmup and cosine schedule

```python exercise id=lr-schedule title="Learning-rate schedule"
import numpy as np

# TODO: `lr_at(step, max_lr, warmup, total, min_lr)` returns the learning rate for a step (counting from 0). During
# warmup (step < warmup) it rises linearly to max_lr: max_lr × (step + 1) / warmup. After warmup it follows cosine decay
# from max_lr at step `warmup` to min_lr at step `total`, and stays at min_lr after that.
def lr_at(step, max_lr, warmup, total, min_lr):
    ...
--- solution
import numpy as np

def lr_at(step, max_lr, warmup, total, min_lr):
    if step < warmup:
        return max_lr * (step + 1) / warmup
    progress = min((step - warmup) / (total - warmup), 1.0)
    return min_lr + 0.5 * (max_lr - min_lr) * (1 + np.cos(np.pi * progress))
--- test
assert abs(lr_at(0, 1.0, 4, 100, 0.0) - 0.25) < 1e-9, "At step 0 of a 4-step warmup the rate is max_lr × 1/4 = 0.25."
assert abs(lr_at(3, 1.0, 4, 100, 0.0) - 1.0) < 1e-9, "The peak is reached at the end of warmup, when step + 1 = warmup."
assert abs(lr_at(4, 1.0, 4, 100, 0.0) - 1.0) < 1e-9, "Right after warmup the cosine starts at the maximum."
assert abs(lr_at(100, 1.0, 4, 100, 0.1) - 0.1) < 1e-9, "At the last step the rate is the minimum."
assert abs(lr_at(500, 1.0, 4, 100, 0.1) - 0.1) < 1e-9, "After the schedule ends the rate stays at the minimum."
--- hint
Handle the warmup case first with a linear ramp. For the cosine part, compute the progress as a fraction between warmup and total, and cap it at one.
--- hint
`0.5 * (max_lr - min_lr) * (1 + np.cos(np.pi * progress))` added to `min_lr`.
```

Unequal micro-batches make the difference between a correct and an incorrect average visible. Compare the naive mean of the batch gradients with the size-weighted one.

```python run
g_list = [np.array([1.0]), np.array([5.0])]
sizes_list = [1, 9]
naive_mean = np.mean(g_list, axis=0)
weighted_mean = sum(g * n for g, n in zip(g_list, sizes_list)) / sum(sizes_list)
print("naive mean:", naive_mean, "| size-weighted mean:", weighted_mean)
```

## Challenge: accumulate gradients

```python exercise id=accumulate-grads title="Weighted gradient accumulation"
import numpy as np

# TODO: `accumulate_gradient(grads, sizes)` takes a list of gradient vectors, one per micro-batch, and the number of
# examples in each micro-batch. Return the mean gradient over all examples: the sum of grad × size divided by the total size.
def accumulate_gradient(grads, sizes):
    ...
--- solution
import numpy as np

def accumulate_gradient(grads, sizes):
    total = sum(np.asarray(g, dtype=float) * n for g, n in zip(grads, sizes))
    return total / sum(sizes)
--- test
import numpy as np
result = accumulate_gradient([np.array([1.0, 0.0]), np.array([4.0, 4.0])], [1, 3])
assert result is not None, "Replace the `...` in `accumulate_gradient` with code that returns the mean gradient."
assert np.allclose(result, [13 / 4, 3.0]), f"The weighted sum is [1, 0] × 1 + [4, 4] × 3 = [13, 12], divided by 4 examples, giving [3.25, 3]. You returned {result}."
assert np.allclose(accumulate_gradient([np.array([2.0])] * 3, [5, 5, 5]), [2.0]), "Equal batches with equal gradients give that gradient."
--- hint
Multiply each batch gradient by its batch size, add them up, and divide by the total number of examples.
--- hint
`sum(np.asarray(g) * n for g, n in zip(grads, sizes)) / sum(sizes)`.
```

## Debug the warmup step

This warmup is meant to start from a small learning rate, but at step zero it gives exactly zero, so the first update does nothing.

```python debug id=warmup-zero title="Start warmup above zero"
import numpy as np

def warmup_lr(step, max_lr=1.0, warmup=4):
    return max_lr * step / warmup              # bug: step 0 gives a learning rate of zero

print("first learning rate:", warmup_lr(0))
--- solution
import numpy as np

def warmup_lr(step, max_lr=1.0, warmup=4):
    return max_lr * (step + 1) / warmup

print("first learning rate:", warmup_lr(0))
--- test
assert warmup_lr(0) > 0, f"The first step must use a positive learning rate, but it is {warmup_lr(0)}. Count the warmup from one."
assert abs(warmup_lr(3) - 1.0) < 1e-9, "The peak should be reached on the last warmup step."
--- hint
Steps begin at zero, so the warmup formula needs to count from one.
--- hint
Use `(step + 1) / warmup`.
```

## Predict the rate

```python predict id=predict-lr title="What is the learning rate at the first step of a 5-step warmup to 0.5?"
print(0.5 * (0 + 1) / 5)
--- options
* 0.1
0.5
0.0
0.05
--- explain
The first step of a linear warmup is one fifth of the peak, so 0.5 / 5 = 0.1.

```', 0, '[]', '[]', '2026-06-25T07:00:34.475Z', '2026-10-19T07:00:34.475Z'),
('les_transformers_from_scratch_4_3', 'sec_transformers_from_scratch_4', 'crs_transformers_from_scratch', 'Mixed precision: fast training without losing gradients', 'interactive', 2, 840, NULL, NULL, 'Modern accelerators compute much faster in 16-bit floating point than in 32-bit, and they use half the memory. Mixed precision training does the bulk of the arithmetic in 16 bits while keeping a 32-bit copy of the weights, and it handles the one danger of low precision: small numbers vanish. The techniques that handle that danger, loss scaling and careful overflow checks, are what make the speed gain safe.

## Precision has limits

A 16-bit float has a much smaller range than a 32-bit float. Very small values round to zero, and very large values overflow to infinity.

```python run
import numpy as np

tiny_gradient = 1e-8
print("float32 keeps it:", np.float32(tiny_gradient))
print("float16 loses it:", np.float16(tiny_gradient))
print("float16 overflows above 65504:", np.float16(70000.0))
```

Gradients are often tiny, which means a naive 16-bit backward pass silently discards most of the signal.

## Loss scaling

The fix is to multiply the loss by a large scale before the backward pass, which scales every gradient up into the representable range, and divide the gradients by the same scale before the update. The mathematics is unchanged because the scale cancels.

```python run
scale = 1024.0
true_grad = np.float32(1e-8)
scaled_16 = np.float16(true_grad * scale)
recovered = np.float32(scaled_16) / scale
print("without scaling:", np.float16(true_grad))
print("with scaling, recovered:", recovered)
```

The scaled gradient survives the 16-bit format, and dividing it back gives a value close to the original.

## Overflow checks

If the scale is too large, the scaled gradients overflow to infinity. Training then skips that update and lowers the scale, so the scale adapts automatically.

```python run
scaled = np.array([1.0, np.inf, 3.0])
print("contains overflow:", not np.all(np.isfinite(scaled)))
```

> **Pitfall:** forgetting to divide the gradients by the scale after the backward pass makes every update too large by that factor. The model appears to train fast and then diverges.

> **In the wild:** frameworks implement this with automatic gradient scalers and with bfloat16, a 16-bit format with the same range as float32, which avoids most of the scaling problem.

Small increments disappear in 16 bits, which is why weight updates are kept in 32-bit precision. Adding a small step to one in float16 leaves the value unchanged.

```python run
print("1.0 + 0.0001 in float16:", np.float16(1.0) + np.float16(0.0001))
print("1.0 + 0.0001 in float32:", np.float32(1.0) + np.float32(0.0001))
```

## Challenge: unscale gradients

```python exercise id=unscale title="Undo the loss scale"
import numpy as np

# TODO: `unscale(grad_scaled, scale)` divides the scaled gradients by the scale, returning float32 values.
def unscale(grad_scaled, scale):
    ...
--- solution
import numpy as np

def unscale(grad_scaled, scale):
    return (np.asarray(grad_scaled, dtype=np.float32) / np.float32(scale)).astype(np.float32)
--- test
import numpy as np
result = unscale(np.array([2048.0, 1024.0]), 1024.0)
assert result is not None, "Replace the `...` in `unscale` with code that returns the unscaled gradients."
assert result.dtype == np.float32, "The result should be float32."
assert np.allclose(result, [2.0, 1.0]), f"Dividing by the scale 1024 gives [2, 1], but you returned {result}."
--- hint
Divide by the scale. Converting to float32 first keeps the precision of the result.
--- hint
`(np.asarray(grad_scaled, dtype=np.float32) / np.float32(scale)).astype(np.float32)`.
```

## Challenge: detect overflow

```python exercise id=overflow-check title="Detect overflow in a gradient"
import numpy as np

# TODO: `has_overflow(grads)` takes a list of gradient arrays and returns True if any value in any of them is infinite
# or NaN, and False otherwise.
def has_overflow(grads):
    ...
--- solution
import numpy as np

def has_overflow(grads):
    return any(not np.all(np.isfinite(np.asarray(g, dtype=float))) for g in grads)
--- test
import numpy as np
assert has_overflow([np.array([1.0, 2.0])]) is False, "Finite gradients do not overflow."
assert has_overflow([np.array([1.0]), np.array([np.inf])]) is True, "An infinite gradient is an overflow."
assert has_overflow([np.array([np.nan])]) is True, "A NaN is an overflow too."
assert has_overflow([]) is False, "No gradients means no overflow."
--- hint
`np.isfinite` is False for infinity and NaN. Check every array.
--- hint
`any(not np.all(np.isfinite(g)) for g in grads)`.
```

## Debug the scale

This code is meant to recover the true gradient, but it forgets to divide by the scale, so the update is 1024 times too large.

```python debug id=forgot-unscale title="Divide by the scale before updating"
import numpy as np

true_grad = 0.001
scale = 1024.0
scaled = true_grad * scale
recovered = scaled                         # bug: the gradient must be divided by the scale
print("recovered gradient:", recovered)
--- solution
import numpy as np

true_grad = 0.001
scale = 1024.0
scaled = true_grad * scale
recovered = scaled / scale
print("recovered gradient:", recovered)
--- test
assert abs(recovered - 0.001) < 1e-9, f"The recovered gradient should be the true value 0.001, but it is {recovered}. Divide by the scale."
--- hint
Loss scaling multiplied the gradient by the scale, so the reverse is a division.
--- hint
`recovered = scaled / scale`.
```

## Predict the precision

```python predict id=predict-fp16 title="What does float16 return for 1e-8?"
import numpy as np
print(float(np.float16(1e-8)))
--- options
* 0.0
1e-08
1.0
0.00000001
--- explain
The smallest positive 16-bit subnormal is about 6e-8, so 1e-8 rounds to zero. This is why unscaled gradients silently vanish in float16.

```', 0, '[]', '[]', '2026-06-25T07:00:34.475Z', '2026-10-19T07:00:34.475Z'),
('les_transformers_from_scratch_4_4', 'sec_transformers_from_scratch_4', 'crs_transformers_from_scratch', 'Sampling and the KV-cache', 'interactive', 3, 1080, NULL, NULL, 'A trained model outputs a distribution over the next token, and generating text means choosing from it. Greedy decoding always picks the most likely token, which is safe but repetitive. Sampling draws from the distribution, which is more varied. **Temperature** and **top-k** control how adventurous the sampling is. Generating one token at a time also has a cost: each step would recompute attention over the whole past. A **KV-cache** stores the keys and values of past tokens so that each new step does only the new work.

## Temperature

Dividing the logits by a temperature $T$ before the softmax sharpens the distribution when $T < 1$ and flattens it when $T > 1$.

$$
p_i = \frac{e^{z_i / T}}{\sum_j e^{z_j / T}}
$$

```python run
import numpy as np

def probs_at_temperature(logits, T):
    z = np.asarray(logits, dtype=float) / T
    e = np.exp(z - z.max())
    return e / e.sum()

logits = np.array([2.0, 1.0, 0.0])
for T in [0.5, 1.0, 2.0]:
    print(f"temperature {T}: {np.round(probs_at_temperature(logits, T), 3)}")
```

At low temperature the most likely token dominates. At high temperature the choices become nearly equal, and the text becomes less coherent.

## Top-k

Top-k sampling keeps only the $k$ most likely tokens, sets the rest to zero probability, and renormalizes. It removes the long tail of unlikely tokens that occasionally derail generation.

```python run
def top_k_probs(logits, k, T=1.0):
    z = np.asarray(logits, dtype=float) / T
    keep = np.argsort(z)[-k:]
    masked = np.full_like(z, -np.inf)
    masked[keep] = z[keep]
    e = np.exp(masked - masked.max())
    return e / e.sum()

print("top-2 of the logits above:", np.round(top_k_probs(logits, 2), 3))
```

## The KV-cache

In a causal model, the keys and values of a token never change once computed. Generating token $t$ needs the keys and values of all earlier tokens, so storing them means each step computes only the new token''s query, key and value.

```python run
rng = np.random.default_rng(0)
d = 4
Wq, Wk, Wv = (rng.normal(0, 0.5, (d, d)) for _ in range(3))
x = rng.normal(size=(5, d))                      # five tokens arrive one at a time

def attend(q, K, V):
    s = K @ q / np.sqrt(d)
    e = np.exp(s - s.max())
    return (e / e.sum()) @ V

K_cache, V_cache, outputs = [], [], []
for t in range(5):
    K_cache.append(x[t] @ Wk)                    # compute only the new key and value
    V_cache.append(x[t] @ Wv)
    outputs.append(attend(x[t] @ Wq, np.array(K_cache), np.array(V_cache)))

full = []
Kf, Vf = x @ Wk, x @ Wv
for t in range(5):
    full.append(attend(x[t] @ Wq, Kf[: t + 1], Vf[: t + 1]))
print("cached and full computation agree:", np.allclose(outputs, full))
```

The cached and recomputed outputs are identical, but the cached version does one key and one value per step rather than recomputing them all.

> **In the wild:** every serving system for language models keeps a KV-cache. Its memory grows with the length of the conversation, which is one reason long contexts are expensive.

> **Pitfall:** temperature must divide the logits, not multiply them. Multiplying flips the effect, sharpening when you wanted flattening.

Sampling from a distribution gives different tokens on each draw. With a low temperature the draws concentrate on the top choice.

```python run
rng_draw = np.random.default_rng(1)
for T in [0.3, 1.5]:
    p_t = probs_at_temperature(logits, T)
    draws = rng_draw.choice(3, size=500, p=p_t)
    print(f"temperature {T}: share of the top token in 500 draws {np.mean(draws == 0):.2f}")
```

## Challenge: temperature probabilities

```python exercise id=temperature-probs title="Probabilities at a temperature"
import numpy as np

# TODO: `temperature_probs(logits, T)` returns the softmax of logits divided by T, computed stably.
def temperature_probs(logits, T):
    ...
--- solution
import numpy as np

def temperature_probs(logits, T):
    z = np.asarray(logits, dtype=float) / T
    e = np.exp(z - z.max())
    return e / e.sum()
--- test
import numpy as np
result = temperature_probs([1.0, 1.0], 1.0)
assert result is not None, "Replace the `...` in `temperature_probs` with code that returns the probabilities."
assert np.allclose(result, [0.5, 0.5]), "Equal logits give equal probabilities at any temperature."
sharp = temperature_probs([2.0, 0.0], 0.5)
assert sharp[0] > temperature_probs([2.0, 0.0], 1.0)[0], "A lower temperature must make the most likely token more likely."
assert abs(sharp[0] - 1 / (1 + np.exp(-4.0))) < 1e-9, "With T = 0.5 the logits become [4, 0], so the first probability is 1 / (1 + e^(−4))."
--- hint
Divide the logits by the temperature first, then apply the stable softmax.
--- hint
`z = np.asarray(logits) / T`, then `e = np.exp(z - z.max())` and normalize.
```

## Challenge: top-k filter

```python exercise id=top-k-filter title="Keep the k largest logits"
import numpy as np

# TODO: `top_k_filter(logits, k)` returns a copy of the logits in which every entry except the k largest is set to −inf.
def top_k_filter(logits, k):
    ...
--- solution
import numpy as np

def top_k_filter(logits, k):
    z = np.asarray(logits, dtype=float)
    out = np.full_like(z, -np.inf)
    keep = np.argsort(z)[-k:]
    out[keep] = z[keep]
    return out
--- test
import numpy as np
result = top_k_filter([0.5, 3.0, 1.0, 2.0], 2)
assert result is not None, "Replace the `...` in `top_k_filter` with code that returns the filtered logits."
assert result[1] == 3.0 and result[3] == 2.0, "The two largest logits, 3 and 2, must be kept."
assert result[0] == -np.inf and result[2] == -np.inf, "All other logits must become minus infinity."
assert np.isfinite(result).sum() == 2, "Exactly k values should remain finite."
--- hint
Find the indices of the k largest values with `np.argsort`, then copy only those into an array of minus infinities.
--- hint
`keep = np.argsort(z)[-k:]`, then `out[keep] = z[keep]`.
```

## Debug the temperature direction

This sampler is meant to sharpen the distribution at low temperature, but it multiplies the logits by the temperature instead of dividing, so the effect is reversed.

```python debug id=temperature-direction title="Divide by the temperature"
import numpy as np

logits = np.array([2.0, 0.0])
T = 0.5
z = logits * T                              # bug: the temperature divides the logits
e = np.exp(z - z.max())
probs = e / e.sum()
print("probabilities:", np.round(probs, 3))
--- solution
import numpy as np

logits = np.array([2.0, 0.0])
T = 0.5
z = logits / T
e = np.exp(z - z.max())
probs = e / e.sum()
print("probabilities:", np.round(probs, 3))
--- test
assert probs[0] > 0.98, f"At temperature 0.5 the top token should dominate, with probability near 0.98, but it is {probs[0]:.3f}. Divide the logits by the temperature."
--- hint
Lower temperature should make the favourite stronger, which means the logits must grow when divided by a small number.
--- hint
Use `logits / T`.
```

## Predict the top-k result

```python predict id=predict-topk title="How many tokens keep a non-zero probability with top-2 sampling over five tokens?"
print(2)
--- options
* 2
5
1
3
--- explain
Top-k keeps exactly k tokens, the two most likely, and gives the rest zero probability. Two tokens keep non-zero probability.

```', 0, '[]', '[]', '2026-06-25T07:00:34.475Z', '2026-10-19T07:00:34.475Z'),
('les_transformers_from_scratch_4_5', 'sec_transformers_from_scratch_4', 'crs_transformers_from_scratch', 'Checkpoint: building and training GPT', 'quiz', 4, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"Why is the BPE merge rule applied in order of frequency during training?","options":["Because frequent pairs are the cheapest to store","So that common pieces become single tokens first, keeping the vocabulary compact for typical text","Because the tokenizer must sort the corpus","Because rare words are never encoded"],"answerIndex":1,"explanation":"Merging the most frequent pair first builds tokens that cover the most text, so common words become one token while rare words split into known pieces."},{"id":"q2","prompt":"A learning-rate warmup is used because…","options":["The loss is always largest at the start","Early gradients are noisy and the weights are random, so large steps can be destructive","The optimizer does not support large rates","The schedule must end at zero"],"answerIndex":1,"explanation":"Warmup protects the first updates, when the model is least stable, and lets the rate rise once the gradients are more informative."},{"id":"q3","prompt":"What does gradient accumulation over micro-batches reproduce?","options":["A smaller batch with more noise","The gradient of one large batch, when each micro-batch gradient is weighted by its size","Only the last micro-batch''s gradient","A random direction"],"answerIndex":1,"explanation":"The weighted sum of micro-batch gradients equals the full-batch mean gradient, so accumulation gives a large effective batch without the memory cost."},{"id":"q4","prompt":"Why does mixed precision use loss scaling?","options":["To make the model larger","So that small gradients stay within the range of 16-bit floats instead of rounding to zero","To remove the need for an optimizer","To speed up the tokenizer"],"answerIndex":1,"explanation":"Scaling the loss scales the gradients up before they are rounded to 16 bits. The scale is divided out before the update, so the mathematics is unchanged."},{"id":"q5","prompt":"A KV-cache stores the keys and values of previous tokens. Why does this help during generation?","options":["It makes the model more accurate","Past keys and values never change, so each new token needs only its own key and value computed","It removes the need for attention","It replaces the softmax"],"answerIndex":1,"explanation":"In a causal model the past does not change, so caching its keys and values avoids recomputing them at every step."}]', '[]', '2026-06-25T07:00:34.475Z', '2026-10-19T07:00:34.475Z'),
('les_transformers_from_scratch_5_1', 'sec_transformers_from_scratch_5', 'crs_transformers_from_scratch', 'Rotary positions and RMSNorm', 'interactive', 0, 960, NULL, NULL, 'Two modern changes appear in nearly every recent transformer. **RMSNorm** is a simpler normalization that drops the mean subtraction of layer normalization, and it works as well in practice while being cheaper. **Rotary position embeddings** (RoPE) encode position by rotating the query and key vectors, so the attention score between two tokens depends on their relative distance, which generalizes better to longer sequences than fixed position tables.

## RMSNorm

Layer normalization subtracts the mean and divides by the standard deviation. RMSNorm divides by the root mean square alone, and applies a learned gain:

$$
\operatorname{RMSNorm}(x) = \frac{x}{\sqrt{\frac{1}{d}\sum_i x_i^2 + \epsilon}} \odot g
$$

```python run
import numpy as np

def rmsnorm(x, g, eps=1e-6):
    rms = np.sqrt(np.mean(x ** 2, axis=-1, keepdims=True) + eps)
    return x / rms * g

x = np.array([[3.0, 4.0]])
print("RMSNorm of [3, 4]:", np.round(rmsnorm(x, np.ones(2)), 4))
print("root mean square of the output:", np.round(np.sqrt(np.mean(rmsnorm(x, np.ones(2)) ** 2)), 4))
```

The output''s root mean square is one, which is the only property RMSNorm enforces. It keeps the scale stable without re-centering the features.

## Rotary positions

RoPE rotates each pair of features by an angle that grows with the position. Each pair uses its own frequency, so the rotations form a range of timescales.

$$
\text{pair } i:\quad \begin{pmatrix} x_{2i} \\ x_{2i+1} \end{pmatrix} \mapsto \begin{pmatrix} \cos\theta_i & -\sin\theta_i \\ \sin\theta_i & \cos\theta_i \end{pmatrix}\begin{pmatrix} x_{2i} \\ x_{2i+1} \end{pmatrix}, \qquad \theta_i = \text{pos} \cdot \text{base}^{-2i/d}
$$

```python run
def rope(x, pos, base=10000.0):
    d = x.shape[-1]
    out = np.empty_like(x, dtype=float)
    for i in range(d // 2):
        theta = pos * base ** (-2 * i / d)
        c, s = np.cos(theta), np.sin(theta)
        a, b = x[2 * i], x[2 * i + 1]
        out[2 * i], out[2 * i + 1] = a * c - b * s, a * s + b * c
    return out

v = np.array([1.0, 0.0, 0.5, 0.5])
print("position 0 leaves the vector unchanged:", np.allclose(rope(v, 0), v))
print("rotation preserves length:", np.isclose(np.linalg.norm(rope(v, 7)), np.linalg.norm(v)))
```

## Relative position

The key property of RoPE is that the dot product between a rotated query and a rotated key depends only on how far apart their positions are.

```python run
q, k = np.array([1.0, 0.5]), np.array([0.3, 1.0])
score_a = rope(q, 5) @ rope(k, 2)              # positions 5 and 2: distance 3
score_b = rope(q, 10) @ rope(k, 7)             # positions 10 and 7: distance 3
print("same distance, same score:", np.isclose(score_a, score_b))
```

Two tokens three positions apart score the same wherever they sit in the sequence, which is exactly the behaviour attention needs.

> **In the wild:** LLaMA-style and many other recent models use RMSNorm and RoPE together, usually with the rotation applied to the queries and keys inside each attention head.

LayerNorm removes the mean of each token, while RMSNorm keeps it. A constant offset survives RMSNorm and disappears under LayerNorm.

```python run
def layer_norm(x, eps=1e-5):
    return (x - x.mean(axis=-1, keepdims=True)) / np.sqrt(x.var(axis=-1, keepdims=True) + eps)

shifted = np.array([[5.0, 5.0, 5.0, 6.0]])
print("LayerNorm output:", np.round(layer_norm(shifted), 3))
print("RMSNorm output:  ", np.round(rmsnorm(shifted, np.ones(4)), 3))
```

## Challenge: RMSNorm

```python exercise id=rmsnorm-fn title="Root-mean-square normalization"
import numpy as np

# TODO: `rms_norm(x, g)` returns x divided by the root mean square of each row (with eps = 1e-6 added inside the root),
# multiplied elementwise by the gain vector g.
def rms_norm(x, g):
    ...
--- solution
import numpy as np

def rms_norm(x, g):
    x = np.asarray(x, dtype=float)
    rms = np.sqrt(np.mean(x ** 2, axis=-1, keepdims=True) + 1e-6)
    return x / rms * np.asarray(g, dtype=float)
--- test
import numpy as np
result = rms_norm(np.array([[3.0, 4.0]]), np.array([1.0, 2.0]))
assert result is not None, "Replace the `...` in `rms_norm` with code that returns the normalized rows."
rms = np.sqrt((9 + 16) / 2)
assert np.allclose(result, [[3.0 / rms, 2 * 4.0 / rms]], atol=1e-5), f"The root mean square of [3, 4] is {rms:.4f}, so the output should be [3/rms, 2·4/rms], but you returned {result}."
assert np.allclose(rms_norm(np.array([[1.0, 1.0]]), np.ones(2)), [[1.0, 1.0]], atol=1e-5), "A row with unit root mean square is unchanged by the normalization."
--- hint
Compute the mean of the squares per row, add eps, take the square root, divide, then multiply by the gain.
--- hint
`x / np.sqrt(np.mean(x ** 2, axis=-1, keepdims=True) + 1e-6) * g`.
```

## Challenge: rotate a pair

```python exercise id=rotate-pair title="Rotate a feature pair"
import numpy as np

# TODO: `rotate_pair(a, b, theta)` returns the pair (a·cos θ − b·sin θ, a·sin θ + b·cos θ), the rotation of (a, b) by θ.
def rotate_pair(a, b, theta):
    ...
--- solution
import numpy as np

def rotate_pair(a, b, theta):
    c, s = np.cos(theta), np.sin(theta)
    return a * c - b * s, a * s + b * c
--- test
import numpy as np
x, y = rotate_pair(1.0, 0.0, np.pi / 2)
assert x is not None and y is not None, "Replace the `...` in `rotate_pair` with code that returns the pair."
assert abs(x) < 1e-9 and abs(y - 1.0) < 1e-9, f"Rotating (1, 0) by 90 degrees gives (0, 1), but you returned ({x}, {y})."
x2, y2 = rotate_pair(3.0, 4.0, 0.7)
assert abs(np.hypot(x2, y2) - 5.0) < 1e-9, "A rotation must preserve the length of the pair."
--- hint
This is the standard 2-D rotation matrix applied to the column vector (a, b).
--- hint
Compute `c = cos θ` and `s = sin θ`, then return `a*c - b*s` and `a*s + b*c`.
```

## Debug the rotation direction

This rotation is meant to turn the pair counter-clockwise, but it uses the wrong sign on the sine terms, so it rotates clockwise.

```python debug id=rotation-sign title="Rotate counter-clockwise"
import numpy as np

a, b, theta = 1.0, 0.0, np.pi / 2
c, s = np.cos(theta), np.sin(theta)
x, y = a * c + b * s, -a * s + b * c       # bug: the sign of the sine terms is reversed
print("rotated:", round(x, 3), round(y, 3))
--- solution
import numpy as np

a, b, theta = 1.0, 0.0, np.pi / 2
c, s = np.cos(theta), np.sin(theta)
x, y = a * c - b * s, a * s + b * c
print("rotated:", round(x, 3), round(y, 3))
--- test
assert abs(x) < 1e-9 and abs(y - 1.0) < 1e-9, f"Rotating (1, 0) counter-clockwise by 90 degrees gives (0, 1), but the code gives ({x:.3f}, {y:.3f}). Use the standard rotation matrix."
--- hint
The standard rotation takes (a, b) to (a cos θ − b sin θ, a sin θ + b cos θ).
--- hint
Put the minus sign on the `b·sin θ` term in the first output.
```

## Predict the relative score

```python predict id=predict-rope title="Do two pairs of positions with the same distance give the same score under RoPE?"
print("yes")
--- options
* yes
no
only at position zero
only for long sequences
--- explain
RoPE makes the query-key dot product depend only on the relative distance between positions, so equal distances give equal scores.

```', 0, '[]', '[]', '2026-06-25T07:00:34.475Z', '2026-10-19T07:00:34.475Z'),
('les_transformers_from_scratch_5_2', 'sec_transformers_from_scratch_5', 'crs_transformers_from_scratch', 'Capstone: assemble and evaluate a language model', 'interactive', 1, 1800, NULL, NULL, 'This is the capstone. You will assemble the components from this course into a small language model, and then judge it the way a careful practitioner would: against a simple baseline, using perplexity on text the model did not see, and with a check that the model learned something rather than memorized.

Full training of a transformer needs an automatic-differentiation engine, which is shown as PyTorch code for you to run locally. Here you will build the model''s forward pass and evaluation in NumPy, using the weights of a small model, and compare it with a bigram baseline that counts word pairs.

## The corpus

```python run
import numpy as np

train_text = "the cat sat on the mat the dog sat on the log the cat saw the dog"
test_text = "the dog sat on the mat the cat saw the log"
vocab = sorted(set(train_text.split()))
word_to_id = {w: i for i, w in enumerate(vocab)}
train_ids = np.array([word_to_id[w] for w in train_text.split()])
test_ids = np.array([word_to_id[w] for w in test_text.split()])
print("vocabulary size:", len(vocab), "| training tokens:", len(train_ids), "| test tokens:", len(test_ids))
```

## A bigram baseline

A bigram model predicts the next word from the previous word alone, using counts with add-one smoothing so that unseen pairs keep a little probability.

```python run
V = len(vocab)
counts = np.zeros((V, V))
for a, b in zip(train_ids[:-1], train_ids[1:]):
    counts[a, b] += 1

def bigram_prob(a, b):
    return (counts[a, b] + 1) / (counts[a].sum() + V)

test_logprobs = [np.log(bigram_prob(a, b)) for a, b in zip(test_ids[:-1], test_ids[1:])]
print("bigram test perplexity:", round(float(np.exp(-np.mean(test_logprobs))), 3))
```

## An untrained transformer

A transformer with random weights should be no better than guessing among the vocabulary, so its perplexity is close to the vocabulary size. That number is the floor a trained model must beat.

```python run
rng = np.random.default_rng(0)
d = 8
E = rng.normal(0, 0.1, (V, d))
P = rng.normal(0, 0.1, (32, d))
Wq, Wk, Wv = (rng.normal(0, 0.3, (d, d)) for _ in range(3))

def layer_norm(x):
    return (x - x.mean(axis=-1, keepdims=True)) / np.sqrt(x.var(axis=-1, keepdims=True) + 1e-5)

def causal_attention(x):
    Q, K, Vv = x @ Wq, x @ Wk, x @ Wv
    s = Q @ K.T / np.sqrt(d)
    s = np.where(np.triu(np.ones_like(s, dtype=bool), k=1), -np.inf, s)
    e = np.exp(s - s.max(axis=-1, keepdims=True))
    return (e / e.sum(axis=-1, keepdims=True)) @ Vv

def model_logits(ids):
    x = E[ids] + P[:len(ids)]
    x = x + causal_attention(layer_norm(x))
    return layer_norm(x) @ E.T

def log_softmax(z):
    m = z.max(axis=-1, keepdims=True)
    return z - m - np.log(np.exp(z - m).sum(axis=-1, keepdims=True))

logp = log_softmax(model_logits(test_ids))
targets = test_ids[1:]
untrained = -np.mean(logp[:-1][np.arange(len(targets)), targets])
print("untrained transformer perplexity:", round(float(np.exp(untrained)), 3), "| vocabulary size:", V)
```

## Judge the result honestly

A model that scores better than the baseline on the training text but not on the test text has memorized. The honest comparison uses only the test text, and the report states both numbers and the gap.

```python run
print("bigram test perplexity:", round(float(np.exp(-np.mean(test_logprobs))), 2))
print("untrained transformer:", round(float(np.exp(untrained)), 2))
print("a trained model must beat the bigram on text it has never seen to be worth using")
```

> **In the wild:** language-model evaluation reports perplexity or accuracy on held-out corpora, compared with simple baselines, and checks for contamination of the test set with training text.

## Challenge: perplexity from log probabilities

```python exercise id=perplexity title="Perplexity from log probabilities"
import numpy as np

# TODO: `perplexity(logprobs)` takes a list of natural-log probabilities, one per predicted token, and returns the
# perplexity, exp of the negative mean.
def perplexity(logprobs):
    ...
--- solution
import numpy as np

def perplexity(logprobs):
    return float(np.exp(-np.mean(np.asarray(logprobs, dtype=float))))
--- test
import numpy as np
result = perplexity([np.log(0.5), np.log(0.5)])
assert result is not None, "Replace the `...` in `perplexity` with code that returns the perplexity."
assert abs(result - 2.0) < 1e-9, f"Every token has probability one half, so the perplexity is 2, but you returned {result!r}."
assert abs(perplexity([np.log(0.25)] * 3) - 4.0) < 1e-9, "A probability of one quarter per token gives perplexity 4."
--- hint
Take the mean of the log probabilities, negate it, and exponentiate.
--- hint
`np.exp(-np.mean(logprobs))`.
```

## Challenge: smoothed bigram probability

```python exercise id=bigram-smooth title="Add-one smoothed bigram probability"
import numpy as np

# TODO: `bigram_prob(counts, a, b)` returns the add-one smoothed probability of word b after word a: (count[a, b] + 1)
# divided by (the total count in row a + the number of columns). Use the counts matrix as given.
def bigram_prob(counts, a, b):
    ...
--- solution
import numpy as np

def bigram_prob(counts, a, b):
    counts = np.asarray(counts, dtype=float)
    return (counts[a, b] + 1) / (counts[a].sum() + counts.shape[1])
--- test
import numpy as np
counts_t = np.array([[0.0, 3.0], [1.0, 0.0]])
assert abs(bigram_prob(counts_t, 0, 1) - 4 / 5) < 1e-9, "Row 0 has total 3 and two columns, so P(1 | 0) = (3 + 1) / (3 + 2) = 0.8."
assert abs(bigram_prob(counts_t, 0, 0) - 1 / 5) < 1e-9, "An unseen pair keeps probability (0 + 1) / 5 = 0.2."
assert bigram_prob(counts_t, 1, 0) > 0, "Smoothing keeps every probability above zero."
--- hint
Add one to the count of the pair, and add the number of columns to the row total.
--- hint
`(counts[a, b] + 1) / (counts[a].sum() + counts.shape[1])`.
```

## Debug the smoothing

This bigram probability is meant to be smoothed, but it omits the add-one, so an unseen pair gets probability zero and the log is infinite.

```python debug id=no-smoothing title="Smooth unseen pairs"
import numpy as np

counts = np.array([[0.0, 3.0], [1.0, 0.0]])
p = counts[0, 0] / counts[0].sum()          # bug: no smoothing, so the unseen pair has probability 0
print("probability:", p, "| log:", np.log(p) if p > 0 else "-inf")
--- solution
import numpy as np

counts = np.array([[0.0, 3.0], [1.0, 0.0]])
p = (counts[0, 0] + 1) / (counts[0].sum() + counts.shape[1])
print("probability:", p, "| log:", np.log(p))
--- test
assert p > 0, "An unseen pair needs a smoothed, positive probability, or its log is minus infinity. Add one to the count and the number of columns to the total."
--- hint
Add-one smoothing adds one to every count.
--- hint
`(counts[0, 0] + 1) / (counts[0].sum() + 2)`.
```

## Predict the baseline

```python predict id=predict-capstone title="What is the perplexity of a uniform model over four words?"
import numpy as np
print(float(np.exp(-np.mean(np.log(np.full(5, 0.25))))))
--- options
* 4.0
0.25
1.0
5.0
--- explain
A uniform model gives each of the four words probability one quarter, and the perplexity of a uniform model is the number of words, four.

```', 0, '[]', '[]', '2026-06-25T07:00:34.475Z', '2026-10-19T07:00:34.475Z'),
('les_transformers_from_scratch_5_3', 'sec_transformers_from_scratch_5', 'crs_transformers_from_scratch', 'Final assessment: Transformers from Scratch', 'quiz', 2, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"Why does a pre-norm transformer block add its sublayer outputs back to the unnormalized stream?","options":["So that the stream grows without bound","So that the input signal survives through many layers, and each sublayer learns a correction","To remove the need for normalization","Because softmax requires an additive input"],"answerIndex":1,"explanation":"Residual connections preserve the signal through depth. Each block only needs to learn an update to what is already there."},{"id":"q2","prompt":"In a causal language model, what must hold for the first position''s output?","options":["It must depend on every later token","It must depend only on the first token, since no later token may influence it","It must be zero","It must equal the last position''s output"],"answerIndex":1,"explanation":"The causal mask guarantees each position sees only itself and earlier tokens, so the first output is determined by the first token alone."},{"id":"q3","prompt":"What does weight tying of the output projection to the embedding table achieve?","options":["It doubles the vocabulary","It saves parameters and ties the input and output representations of tokens","It removes positional information","It makes training deterministic"],"answerIndex":1,"explanation":"Reusing the embedding matrix for the output projection removes a large block of parameters and often helps generalization."},{"id":"q4","prompt":"A model''s perplexity on held-out text is 40 while a bigram baseline gets 35. What is the honest conclusion?","options":["The transformer is better","The transformer is worse than the baseline on this text, so it has not yet earned its complexity","The perplexity cannot be compared","The baseline must have cheated"],"answerIndex":1,"explanation":"Lower perplexity is better. On held-out text the bigram baseline is ahead, so the larger model is not justified by this evidence."},{"id":"q5","prompt":"Rotary position embeddings make the attention score depend on…","options":["The absolute position of each token","The relative distance between the two tokens","The vocabulary size","The learning rate"],"answerIndex":1,"explanation":"Rotating queries and keys by their positions makes their dot product depend only on the difference between positions."},{"id":"q6","prompt":"Why is temperature applied by dividing the logits?","options":["Dividing keeps the logits negative","A temperature below one sharpens the distribution towards the most likely token, and above one flattens it","Dividing removes the need for softmax","It makes sampling faster"],"answerIndex":1,"explanation":"Dividing by a small temperature magnifies the differences between logits, which concentrates probability on the top choice."}]', '[]', '2026-06-25T07:00:34.475Z', '2026-10-19T07:00:34.475Z');

INSERT INTO path_courses (path_id, course_id, position) VALUES
('pth_llm_engineer', 'crs_transformers_from_scratch', 1),
('pth_ai_researcher', 'crs_transformers_from_scratch', 1);

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_transformers_from_scratch_1', 'usr_seed00000f', 'crs_transformers_from_scratch', 4, 'Finally clicked', 'I''d tried learning this from scattered blog posts and papers. Having a single coherent narrative with good visuals made it click. The capstone tied everything together.', '2026-09-07T14:00:34.475Z', '2026-09-07T14:00:34.475Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000f');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_transformers_from_scratch_2', 'usr_seed00000r', 'crs_transformers_from_scratch', 5, 'Solid and practical', 'Good balance of theory and practice. A couple of sections could go slightly deeper, but overall excellent value and I''d take another course from this instructor.', '2026-10-11T13:00:34.475Z', '2026-10-11T13:00:34.475Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000r');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_transformers_from_scratch_3', 'usr_seed00000w', 'crs_transformers_from_scratch', 4, 'Worth every minute', 'Clear, well-paced and incredibly practical. The projects were challenging in the right way, and I used what I learned at work within a week of finishing.', '2026-09-12T16:00:34.475Z', '2026-09-12T16:00:34.475Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00000w');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_transformers_from_scratch_4', 'usr_seed000016', 'crs_transformers_from_scratch', 5, 'Helped me land an ML role', 'I was a backend engineer trying to move into ML. This course gave me the vocabulary and the hands-on confidence to pass technical interviews. Highly recommended.', '2026-10-16T11:00:34.475Z', '2026-10-16T11:00:34.475Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000016');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_transformers_from_scratch_5', 'usr_seed00001r', 'crs_transformers_from_scratch', 5, 'Finally clicked', 'I''d tried learning this from scattered blog posts and papers. Having a single coherent narrative with good visuals made it click. The capstone tied everything together.', '2026-10-20T14:00:34.475Z', '2026-10-20T14:00:34.475Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001r');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_transformers_from_scratch_6', 'usr_seed000021', 'crs_transformers_from_scratch', 5, 'Worth every minute', 'Clear, well-paced and incredibly practical. The projects were challenging in the right way, and I used what I learned at work within a week of finishing.', '2026-09-23T23:00:34.475Z', '2026-09-23T23:00:34.475Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000021');

UPDATE courses SET rating_avg = coalesce((SELECT avg(rating) FROM reviews WHERE course_id = 'crs_transformers_from_scratch'), 0), rating_count = (SELECT count(*) FROM reviews WHERE course_id = 'crs_transformers_from_scratch') WHERE id = 'crs_transformers_from_scratch';
