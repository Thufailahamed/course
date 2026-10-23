A text-to-image model must follow a prompt, so the denoiser needs to read the text at every step. Two mechanisms do most of the work. The timestep is turned into a vector with a sinusoidal embedding, so the network knows how noisy its input is. The text is encoded into tokens, and cross-attention lets the image features look up the relevant words while they are denoised.

## Timestep embeddings

A sinusoidal embedding maps a step number to a vector of sines and cosines at a range of frequencies, similar to positional encodings in transformers.

```python run
import numpy as np

def sinusoidal_embedding(t, dim):
    half = dim // 2
    freqs = np.exp(-np.log(10000.0) * np.arange(half) / half)
    args = t * freqs
    return np.concatenate([np.sin(args), np.cos(args)])

print("embedding of step 0:", np.round(sinusoidal_embedding(0, 4), 3))
print("embedding of step 500, dimension 8:", np.round(sinusoidal_embedding(500, 8), 3))
```

Nearby steps get similar embeddings, and the network can read the noise level from them.

## Cross-attention

In cross-attention the image features form the queries, and the text tokens form the keys and values. The softmax of the scaled dot products gives a weight for each word.

```python run
def cross_attention_weights(q, K):
    d = len(q)
    scores = K @ q / np.sqrt(d)
    e = np.exp(scores - scores.max())
    return e / e.sum()

q = np.array([1.0, 0.0])
K = np.array([[1.0, 0.0], [0.0, 1.0]])
print("attention over two text tokens:", np.round(cross_attention_weights(q, K), 4))
```

The first token matches the query better, so it receives more weight.

## Conditioning the output

The attended text vector is combined with the image features, and the denoiser's output is pushed toward the prompt.

```python run
text_summary = np.array([0.6, 0.4]) @ np.array([[1.0, 0.0], [0.0, 1.0]])
image_feature = np.array([0.2, 0.9])
print("conditioned feature:", np.round(image_feature + text_summary, 3))
```

## Text encoders

The text itself is turned into token embeddings by a pretrained encoder. Its output sequence is the set of keys and values for every cross-attention layer.

```python run
prompt = "a red bicycle"
tokens = prompt.split()
print("tokens:", tokens, "| count:", len(tokens))
```

The cross-attention block of a U-Net is shown below as static PyTorch code. It is the NumPy function above, with learned projections and a batch dimension.

```python
import torch
import torch.nn as nn

class CrossAttention(nn.Module):
    def __init__(self, dim, ctx_dim):
        super().__init__()
        self.to_q = nn.Linear(dim, dim, bias=False)
        self.to_k = nn.Linear(ctx_dim, dim, bias=False)
        self.to_v = nn.Linear(ctx_dim, dim, bias=False)
        self.to_out = nn.Linear(dim, dim)

    def forward(self, x, context):                 # x: (B, N, dim), context: (B, M, ctx_dim)
        q, k, v = self.to_q(x), self.to_k(context), self.to_v(context)
        attn = torch.softmax(q @ k.transpose(-1, -2) / q.size(-1) ** 0.5, dim=-1)
        return self.to_out(attn @ v)
```

> **Pitfall:** a prompt that is too long for the encoder is truncated, so the end of the prompt has no effect. Check the token count before blaming the model.

> **In the wild:** most image generators encode the prompt with a CLIP text encoder or a T5 encoder, and attend to its tokens in every block of the denoiser.

## Challenge: sinusoidal embedding

```python exercise id=sin-embedding title="Sinusoidal timestep embedding"
import numpy as np

# TODO: `sinusoidal_embedding(t, dim)` returns a vector of length dim: the sines of t times dim/2 frequencies, followed by the
# cosines, where the frequency i is exp(−log(10000) × i / (dim / 2)).
def sinusoidal_embedding(t, dim):
    ...
--- solution
import numpy as np

def sinusoidal_embedding(t, dim):
    half = dim // 2
    freqs = np.exp(-np.log(10000.0) * np.arange(half) / half)
    args = t * freqs
    return np.concatenate([np.sin(args), np.cos(args)])
--- test
import numpy as np
result = sinusoidal_embedding(0, 4)
assert result is not None, "Replace the `...` in `sinusoidal_embedding` with code that returns the embedding."
assert np.allclose(result, [0, 0, 1, 1]), f"At t = 0 the sines are 0 and the cosines are 1, so the embedding is [0, 0, 1, 1], but you returned {result}."
assert sinusoidal_embedding(5, 8).shape == (8,), "The embedding has the requested dimension."
--- hint
Compute `t * freqs` once, then concatenate the sine and cosine of that array.
--- hint
`np.concatenate([np.sin(args), np.cos(args)])`.
```

## Challenge: attention weights

```python exercise id=attn-weights title="Attention weights for one query"
import numpy as np

# TODO: `cross_attention_weights(q, K)` returns the softmax of K @ q divided by sqrt(d), where d is the length of q.
def cross_attention_weights(q, K):
    ...
--- solution
import numpy as np

def cross_attention_weights(q, K):
    q = np.asarray(q, dtype=float)
    K = np.asarray(K, dtype=float)
    scores = K @ q / np.sqrt(len(q))
    e = np.exp(scores - scores.max())
    return e / e.sum()
--- test
import numpy as np
result = cross_attention_weights(np.array([1.0, 0.0]), np.array([[1.0, 0.0], [0.0, 1.0]]))
assert result is not None, "Replace the `...` in `cross_attention_weights` with code that returns the weights."
expected = np.exp(np.array([1.0, 0.0]) / np.sqrt(2)) / np.exp(np.array([1.0, 0.0]) / np.sqrt(2)).sum()
assert np.allclose(result, expected), f"The scores are [1, 0] / sqrt(2) before the softmax, so the weights should be {expected}, but you returned {result}."
--- hint
Scale the dot products by sqrt(d) before the exponential.
--- hint
`scores = K @ q / np.sqrt(len(q))`, then the usual softmax.
```

## Debug: unscaled scores

Attention scores are scaled by sqrt(d) so the softmax does not saturate. This version leaves out the scaling.

```python debug id=unscaled-attn title="Scale the scores before the softmax"
import numpy as np

q = np.array([1.0, 0.0])
K = np.array([[1.0, 0.0], [0.0, 1.0]])
scores = K @ q                                 # bug: the scores are not divided by sqrt(d)
e = np.exp(scores - scores.max())
weights = e / e.sum()
print("weights:", np.round(weights, 4))
--- solution
import numpy as np

q = np.array([1.0, 0.0])
K = np.array([[1.0, 0.0], [0.0, 1.0]])
scores = K @ q / np.sqrt(len(q))
e = np.exp(scores - scores.max())
weights = e / e.sum()
print("weights:", np.round(weights, 4))
--- test
expected = np.exp(np.array([1.0, 0.0]) / np.sqrt(2))
expected = expected / expected.sum()
assert np.allclose(weights, expected), f"With scaling the first weight is {expected[0]:.4f}, but the code gives {weights[0]:.4f}. Divide the scores by sqrt(d)."
--- hint
d is the length of the query, here 2.
--- hint
Use `K @ q / np.sqrt(len(q))`.
```

## Predict the embedding length

```python predict id=predict-emb title="How many numbers does a sinusoidal embedding of dimension 8 contain?"
import numpy as np
print(len(np.concatenate([np.sin(np.zeros(4)), np.cos(np.zeros(4))])))
--- options
* 8
4
16
2
--- explain
The sines and cosines each contribute half of the dimension, so the total is 4 + 4 = 8.
```

## Recap

- The timestep is embedded with sines and cosines, so the denoiser knows the noise level.
- Cross-attention lets image features attend to the text tokens, weighted by a softmax.
- Scaling the scores by sqrt(d) keeps the softmax well behaved.

**Up next:** classifier-free guidance, which turns the conditioning into a dial.
