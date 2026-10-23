Before a network learns anything, you have to choose its starting weights, and that choice matters more than most people expect. Weights that are too small make the signal vanish as it passes through the layers. Weights that are too large make it explode. Both stall training. In this lesson you will see the problem in action, learn the initialization schemes that fix it, and implement **batch normalization**, which keeps activations well-behaved during training.

## The signal shrinks, or grows

Pass random data through ten layers of random weights and watch the spread of the activations. Each layer multiplies the signal by its weights, and the tanh squashes it further.

```python run
rng = np.random.default_rng(0)
x = rng.normal(size=(200, 128))

def spread_through_layers(x, scale, depth=10):
    out = [x.std()]
    h = x
    for _ in range(depth):
        W = rng.normal(0, scale, size=(128, 128))
        h = np.tanh(h @ W)
        out.append(h.std())
    return np.array(out)

small = spread_through_layers(x, scale=0.01)
large = spread_through_layers(x, scale=0.5)
print("small weights, std per layer:", np.round(small, 4))
print("large weights, std per layer:", np.round(large, 4))
```

With weights that are too small, the activations collapse towards zero within a few layers, and there is nothing left to learn from. With weights that are too large, `tanh` saturates and its derivative vanishes. Neither can train deep networks.

## Scale the weights to the layer width

The right scale depends on how many inputs each unit sums over, its **fan-in**. Two schemes keep the spread roughly constant from layer to layer:

- **Xavier (Glorot)** initialization, for tanh and sigmoid units: standard deviation $\sqrt{1 / n_{\text{in}}}$.
- **He** initialization, for ReLU units: standard deviation $\sqrt{2 / n_{\text{in}}}$. The factor of 2 compensates for ReLU zeroing half of its inputs.

```python run
def relu(z):
    return np.maximum(0, z)

def spread_relu(scale_fn, depth=10):
    h = rng.normal(size=(200, 128))
    out = [h.std()]
    for _ in range(depth):
        W = rng.normal(0, scale_fn(128), size=(128, 128))
        h = relu(h @ W)
        out.append(h.std())
    return np.array(out)

naive = spread_relu(lambda fan_in: 0.05)
he = spread_relu(lambda fan_in: np.sqrt(2 / fan_in))
print("fixed small scale, std per layer:", np.round(naive, 3))
print("He initialization, std per layer:", np.round(he, 3))
```

He initialization keeps the signal alive through ten ReLU layers. The fixed scale still loses strength layer by layer.

The same idea works for tanh. Xavier's scale keeps the signal steady through ten tanh layers, where the earlier scale of 0.5 saturated.

```python run
xavier = spread_through_layers(x, scale=np.sqrt(1 / 128))
print("Xavier for tanh, std per layer:", np.round(xavier, 3))
```

> **In the wild:** PyTorch's `nn.Linear` and `nn.Conv2d` use variants of these rules by default, and `torch.nn.init` exposes them directly. Knowing the reason lets you pick the right one.

## Batch normalization

Even with good initialization, the distribution of each layer's inputs drifts as the earlier layers change. **Batch normalization** fixes this by normalizing every feature over the batch to mean 0 and variance 1, then letting the network learn a scale $\gamma$ and shift $\beta$:

$$
\hat x = \frac{x - \mu_B}{\sqrt{\sigma_B^2 + \epsilon}}, \qquad y = \gamma \hat x + \beta
$$

Here $\mu_B$ and $\sigma_B^2$ are the mean and variance of each feature over the batch, so the statistics are taken along the batch axis, axis 0.

```python run
X = rng.normal(loc=5.0, scale=3.0, size=(64, 4))   # badly scaled features
mu = X.mean(axis=0)
var = X.var(axis=0)
X_hat = (X - mu) / np.sqrt(var + 1e-5)

print("before: mean", np.round(X.mean(axis=0), 2), "std", np.round(X.std(axis=0), 2))
print("after:  mean", np.round(X_hat.mean(axis=0), 2), "std", np.round(X_hat.std(axis=0), 2))
```

The features now have mean zero and standard deviation one, whatever their starting scale.

> **Pitfall:** batch normalization uses batch statistics during training and running averages at test time. Forgetting to switch to the running averages with `model.eval()` is a classic source of bad test accuracy, and you will meet it again in PyTorch.

## Challenge: He initialization

```python exercise id=he-init title="He initialization"
# TODO: `he_init(fan_in, fan_out, rng)` returns a weight matrix of shape (fan_in, fan_out) drawn from a
# normal distribution with mean 0 and standard deviation sqrt(2 / fan_in).
def he_init(fan_in, fan_out, rng):
    ...
--- solution
def he_init(fan_in, fan_out, rng):
    return rng.normal(0, np.sqrt(2 / fan_in), size=(fan_in, fan_out))
--- test
rng_t = np.random.default_rng(0)
W = he_init(400, 300, rng_t)
assert W is not None, "Replace the `...` in `he_init` with code that returns the weight matrix."
assert W.shape == (400, 300), f"The weights should have shape (400, 300), but they have {W.shape}."
target = np.sqrt(2 / 400)
assert abs(W.std() - target) / target < 0.05, f"The standard deviation should be about sqrt(2 / 400) = {target:.4f}, but it is {W.std():.4f}."
assert abs(W.mean()) < 0.005, "The mean of the weights should be close to zero."
--- hint
Use `rng.normal(loc, scale, size)`. The scale is the standard deviation, so it should be `np.sqrt(2 / fan_in)`.
--- hint
`return rng.normal(0, np.sqrt(2 / fan_in), size=(fan_in, fan_out))`.
```

## Challenge: batch normalization in the forward pass

```python exercise id=batchnorm-forward title="Batch normalization"
# TODO: `batchnorm_forward(X, gamma, beta, eps=1e-5)` normalizes each feature of X over the batch
# (axis 0), then applies the scale gamma and shift beta. X has shape (n, features).
def batchnorm_forward(X, gamma, beta, eps=1e-5):
    ...
--- solution
def batchnorm_forward(X, gamma, beta, eps=1e-5):
    mu = X.mean(axis=0)
    var = X.var(axis=0)
    X_hat = (X - mu) / np.sqrt(var + eps)
    return gamma * X_hat + beta
--- test
rng_t = np.random.default_rng(3)
X_t = rng_t.normal(loc=10.0, scale=4.0, size=(100, 3))
out = batchnorm_forward(X_t, np.ones(3), np.zeros(3))
assert out is not None, "Replace the `...` in `batchnorm_forward` with code that returns the normalized output."
assert out.shape == X_t.shape, "The output should have the same shape as the input."
assert np.allclose(out.mean(axis=0), 0.0, atol=1e-6), "With gamma = 1 and beta = 0 each feature should have mean 0 over the batch. Normalize along axis 0."
assert np.allclose(out.std(axis=0), 1.0, atol=1e-3), "Each feature should have standard deviation 1 over the batch."
out2 = batchnorm_forward(X_t, np.full(3, 2.0), np.full(3, 1.0))
assert np.allclose(out2.mean(axis=0), 1.0, atol=1e-6) and np.allclose(out2.std(axis=0), 2.0, atol=1e-3), "gamma scales the standard deviation and beta shifts the mean."
--- hint
Compute the mean and variance of each column with `axis=0`, then standardize. Divide by `np.sqrt(var + eps)`, not by `var`.
--- hint
`X_hat = (X - mu) / np.sqrt(var + eps)`, then `return gamma * X_hat + beta`.
```

## Debug the normalization axis

```python debug id=batchnorm-axis title="Normalize across the batch"
rng_d = np.random.default_rng(5)
X = rng_d.normal(loc=3.0, scale=2.0, size=(32, 4))     # 32 examples, 4 features
mu = X.mean(axis=1, keepdims=True)                     # the statistics are per feature
var = X.var(axis=1, keepdims=True)
X_hat = (X - mu) / np.sqrt(var + 1e-5)
print("feature means:", np.round(X_hat.mean(axis=0), 3))
--- solution
rng_d = np.random.default_rng(5)
X = rng_d.normal(loc=3.0, scale=2.0, size=(32, 4))     # 32 examples, 4 features
mu = X.mean(axis=0, keepdims=True)                     # the statistics are per feature
var = X.var(axis=0, keepdims=True)
X_hat = (X - mu) / np.sqrt(var + 1e-5)
print("feature means:", np.round(X_hat.mean(axis=0), 3))
--- test
assert np.allclose(X_hat.mean(axis=0), 0.0, atol=1e-6), f"Each feature should have mean 0 over the batch, but the feature means are {np.round(X_hat.mean(axis=0), 3)}. Compute the statistics over axis 0."
assert X_hat.shape == (32, 4), "X_hat should keep the shape of X."
--- hint
Look at the axis you average over. Batch normalization averages over the examples, which are the rows, so that is axis 0.
--- hint
Change `axis=1` to `axis=0` in both the mean and the variance.
```

## Predict the statistic's shape

```python predict id=predict-batch-axis title="What shape are the batch means?"
X = np.ones((32, 5))
print(X.mean(axis=0).shape)
--- options
* (5,)
(32,)
(32, 5)
()
--- explain
Averaging over axis 0 removes the 32 examples and leaves one mean per feature, a vector of length 5. That is why batch normalization has one γ and one β for each feature.
```

## Recap

- Weights that are too small or too large make activations vanish or explode through depth.
- Xavier initialization suits tanh and sigmoid. He initialization, with variance $2/n_{\text{in}}$, suits ReLU.
- Batch normalization standardizes each feature over the batch, then applies a learned scale and shift.
- Batch statistics come from axis 0 (the examples). Use running statistics at test time.

**Up next:** the same training ideas in PyTorch. You will see how the framework packages everything you have built.
