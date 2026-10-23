In the last lesson, a neuron drew one straight line. If you stacked two neurons with nothing between them, you would still get one straight line, because a linear function of a linear function is linear. The **activation function** is the small non-linear step between layers that breaks this limit. It is where depth gets its power.

In this lesson you will meet the three activations that matter most, compare their shapes, and learn their derivatives. The derivatives are not decoration. Backpropagation needs them in every single step.

## Why linearity is not enough

Suppose the first layer computes $h = W_1 x$ and the second computes $y = W_2 h$. Then

$$
y = W_2 W_1 x
$$

and the product $W_2 W_1$ is just another matrix. Two layers behave exactly like one. Check it with numbers:

```python run
rng = np.random.default_rng(0)
W1 = rng.normal(size=(3, 2))
W2 = rng.normal(size=(1, 3))
x = np.array([0.7, -1.3])

two_layers = W2 @ (W1 @ x)
one_layer = (W2 @ W1) @ x
print("two layers:", two_layers)
print("one layer: ", one_layer)
print("equal?", np.allclose(two_layers, one_layer))
```

Now insert a non-linearity between the layers and the equality breaks. That is the whole point.

## Three activations you will use

**Sigmoid** squashes any number into $(0, 1)$. It is the classic choice for a probability output:

$$
\sigma(z) = \frac{1}{1 + e^{-z}}, \qquad \sigma'(z) = \sigma(z)\bigl(1 - \sigma(z)\bigr)
$$

**Tanh** squashes into $(-1, 1)$ and is centred at zero, which often trains more smoothly inside a network:

$$
\tanh(z), \qquad \tanh'(z) = 1 - \tanh^2(z)
$$

**ReLU** (rectified linear unit) keeps positive values and sets negatives to zero. It is cheap to compute and is the default for hidden layers in modern networks:

$$
\operatorname{relu}(z) = \max(0, z), \qquad \operatorname{relu}'(z) = \begin{cases} 1 & z > 0 \\ 0 & z < 0 \end{cases}
$$

```python run
import matplotlib.pyplot as plt

z = np.linspace(-4, 4, 200)
sigmoid = 1 / (1 + np.exp(-z))
relu = np.maximum(0, z)

fig, ax = plt.subplots(figsize=(6, 3.5))
ax.plot(z, sigmoid, label="sigmoid")
ax.plot(z, np.tanh(z), label="tanh")
ax.plot(z, relu, label="ReLU")
ax.axhline(0, color="grey", lw=0.8); ax.axvline(0, color="grey", lw=0.8)
ax.set_ylim(-1.5, 4); ax.grid(alpha=0.3); ax.legend()
plt.show()
```

Look at the slope of each curve. The sigmoid and tanh flatten out at both ends, while ReLU keeps a constant slope on the positive side. That flat region matters a great deal, and the next two cells measure it.

```python run
def central_slope(f, x, h=1e-5):
    return (f(x + h) - f(x - h)) / (2 * h)

sigmoid = lambda t: 1 / (1 + np.exp(-t))
for z0 in [0.0, 2.0, 5.0]:
    numeric = central_slope(sigmoid, z0)
    formula = sigmoid(z0) * (1 - sigmoid(z0))
    print(f"z = {z0}: numeric {numeric:.6f}  formula {formula:.6f}")
```

The numbers agree, which confirms the sigmoid derivative formula. Notice how small the slope is at $z = 5$.

```python run
# Saturation: how fast does the sigmoid's slope shrink as the input grows?
for z0 in [1.0, 3.0, 6.0, 10.0]:
    s = 1 / (1 + np.exp(-z0))
    print(f"z = {z0:>4}: slope = {s * (1 - s):.2e}")
```

When an input is large, a sigmoid or tanh unit is almost flat, so its gradient is almost zero. Stack many such layers and the signal that flows backwards shrinks towards nothing. This is the **vanishing gradient** problem, and it is one reason ReLU replaced sigmoid in hidden layers.

## Predict the values

```python predict id=predict-activations title="What do the activations give at zero?"
z = 0.0
print(np.tanh(z), 1 / (1 + np.exp(-z)))
--- options
* 0.0 0.5
0.0 1.0
1.0 0.5
0.5 0.0
--- explain
tanh(0) is 0, and the sigmoid is 1 / (1 + 1) = 0.5. Both sit at the centre of their ranges. This is why tanh is centred at zero, while the sigmoid is centred at one half.
```

## Challenge: write ReLU

```python exercise id=relu-forward title="Write ReLU"
# TODO: `relu(z)` should return the elementwise maximum of 0 and z, for an array z.
def relu(z):
    ...
--- solution
def relu(z):
    return np.maximum(0, z)
--- test
z_test = np.array([-2.0, -0.5, 0.0, 1.5, 3.0])
result = relu(z_test)
assert result is not None, "Replace the `...` in `relu` with code that returns the activation."
assert np.allclose(result, [0.0, 0.0, 0.0, 1.5, 3.0]), f"relu of {z_test} should be [0, 0, 0, 1.5, 3], but you returned {result}."
assert np.shape(relu(np.ones((2, 3)))) == (2, 3), "relu should keep the shape of its input."
--- hint
You need the larger of two values, elementwise: `0` and each entry of `z`. NumPy has a function for exactly that.
--- hint
`np.maximum(0, z)` compares every entry with 0 and keeps the bigger value.
```

## Challenge: the derivative of ReLU

Backpropagation multiplies by the derivative of every activation it passes through. For ReLU the derivative is 1 where the input was positive and 0 elsewhere.

```python exercise id=relu-derivative title="The derivative of ReLU"
# TODO: `relu_grad(z)` should return 1.0 where z > 0 and 0.0 otherwise, elementwise.
def relu_grad(z):
    ...
--- solution
def relu_grad(z):
    return (z > 0).astype(float)
--- test
z_test = np.array([-1.0, 0.0, 2.0, 0.5])
result = relu_grad(z_test)
assert result is not None, "Replace the `...` in `relu_grad` with code that returns the derivative."
assert np.allclose(result, [0.0, 0.0, 1.0, 1.0]), f"relu_grad of {z_test} should be [0, 0, 1, 1], but you returned {result}."
assert np.allclose(relu_grad(np.array([3.0, -3.0])), [1.0, 0.0]), "The derivative is 1 for every positive input, not only for these."
--- hint
Compare `z` with zero to get booleans, then convert them to numbers with `.astype(float)`.
--- hint
`return (z > 0).astype(float)`. At exactly zero the derivative is 0 by convention; the test expects that.
```

## Debug the tanh derivative

```python debug id=tanh-derivative title="Check the tanh derivative"
# The derivative of tanh(z) is 1 - tanh(z)^2.
z = np.array([0.0, 1.0, -2.0])
t = np.tanh(z)
dtanh = 1 - t           # what is wrong here?
print("tanh':", dtanh)
--- solution
# The derivative of tanh(z) is 1 - tanh(z)^2.
z = np.array([0.0, 1.0, -2.0])
t = np.tanh(z)
dtanh = 1 - t ** 2
print("tanh':", dtanh)
--- test
expected = 1 - np.tanh(z) ** 2
assert np.allclose(dtanh, expected), f"The derivative of tanh is 1 - tanh(z)², but you computed {dtanh}. Check the power."
assert np.isclose(dtanh[0], 1.0), "At z = 0 the slope of tanh is 1."
--- hint
The derivative of tanh squares the output. Compare `1 - t` with `1 - t²` at z = 0: the first gives 0, but the slope there is 1.
--- hint
Replace `t` with `t ** 2`.
```

## Pitfall: dead ReLU units

> **Pitfall:** a ReLU neuron whose pre-activation is always negative outputs zero and has a gradient of zero. It stops learning entirely, and it is called a *dead* unit. Good initialization and a moderate learning rate make this rare, and you will meet both later in the course.

## Recap

- Without a non-linearity, stacked layers collapse into one linear map. Activations are what make depth useful.
- Sigmoid squashes into $(0, 1)$, tanh into $(-1, 1)$, and ReLU keeps the positive part of its input.
- Each activation has a derivative that backpropagation multiplies in at every layer.
- ReLU is cheap and the default for hidden layers, but its gradient is zero for negative inputs, which can kill units.

**Up next:** the forward pass for a whole batch through several layers, with every shape written out.
