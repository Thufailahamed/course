A convolutional network stacks convolutions and downsampling, then ends with a classifier. Three numbers explain most of its behaviour: how many parameters each layer has, how the feature maps shrink, and how far each output can see in the original image. This lesson computes all three.

## Parameters of a convolution

A convolution with kernel size k, c_in input channels, c_out output channels and a bias has k × k × c_in × c_out weights plus one bias per output channel.

```python run
import numpy as np

def conv_params(k, c_in, c_out, bias=True):
    return k * k * c_in * c_out + (c_out if bias else 0)

print("3x3, 64 -> 128 channels:", conv_params(3, 64, 128))
print("1x1, 64 -> 64 channels:", conv_params(1, 64, 64))
```

A 1 by 1 convolution mixes channels without looking at neighbours, and it is cheap for exactly this reason.

## Shrinking the feature maps

A ResNet-style stem reduces a 224 by 224 image in three steps: a strided 7 by 7 convolution, a stride-2 pooling and a stride-2 convolution.

```python run
def out_size(n, k, p, s):
    return (n + 2 * p - k) // s + 1

size = 224
for name, k, p, s in [("7x7 conv, stride 2", 7, 3, 2), ("3x3 max pool, stride 2", 3, 1, 2), ("3x3 conv, stride 2", 3, 1, 2)]:
    size = out_size(size, k, p, s)
    print(f"after {name}: {size} x {size}")
```

## Receptive fields

The receptive field of an output is the region of the input that influences it. Each layer adds (k − 1) times the current jump, and stride multiplies the jump for the layers after it.

```python run
def receptive_field(layers):
    r, jump = 1, 1
    for k, s in layers:
        r += (k - 1) * jump
        jump *= s
    return r

print("three 3x3 convs, stride 1:", receptive_field([(3, 1)] * 3))
print("with one stride-2 layer in the middle:", receptive_field([(3, 1), (3, 2), (3, 1)]))
```

## Residual connections

A residual block adds its input back to the output of its layers. This gives gradients a direct path through the network, which is what made very deep networks trainable.

```python run
x = np.array([1.0, -2.0, 0.5])
W = np.array([[0.5, 0.0, 0.0], [0.0, 0.5, 0.0], [0.0, 0.0, 0.5]])

def relu(z):
    return np.maximum(z, 0)

plain = relu(W @ x)
residual = relu(W @ x + x)
print("plain block:", plain, "| residual block:", residual)
```

> **Pitfall:** deeper is not automatically better. A plain 56-layer network trains worse than a 20-layer one, which is the problem residual connections were designed to solve.

> **In the wild:** ResNet, EfficientNet and ConvNeXt are all built from these same ingredients, and their parameter counts and receptive fields are the numbers to compare when choosing one.

## Challenge: parameter count

```python exercise id=conv-params title="Parameters of a convolution"
# TODO: `conv_params(k, c_in, c_out)` returns the number of parameters of a k × k convolution with a bias: k × k × c_in × c_out
# weights plus c_out biases.
def conv_params(k, c_in, c_out):
    ...
--- solution
def conv_params(k, c_in, c_out):
    return k * k * c_in * c_out + c_out
--- test
result = conv_params(3, 64, 128)
assert result is not None, "Replace the `...` in `conv_params` with code that returns the count."
assert result == 73856, f"A 3 × 3 convolution from 64 to 128 channels has 9 × 64 × 128 + 128 = 73856 parameters, but you returned {result}."
assert conv_params(1, 64, 64) == 4160, "A 1 × 1 convolution from 64 to 64 channels has 4096 weights and 64 biases."
assert conv_params(3, 3, 16) == 448, "A 3 × 3 convolution from 3 to 16 channels has 432 weights and 16 biases."
--- hint
Multiply the kernel area by both channel counts, then add one bias per output channel.
--- hint
`return k * k * c_in * c_out + c_out`.
```

## Challenge: receptive field

```python exercise id=receptive-field title="Receptive field of a stack of layers"
# TODO: `receptive_field(layers)` takes a list of (k, s) pairs, one per layer, and returns the receptive field of one output.
# Start with r = 1 and jump = 1. For each layer add (k − 1) × jump to r, then multiply jump by the stride s.
def receptive_field(layers):
    ...
--- solution
def receptive_field(layers):
    r, jump = 1, 1
    for k, s in layers:
        r += (k - 1) * jump
        jump *= s
    return r
--- test
result = receptive_field([(3, 1), (3, 1), (3, 1)])
assert result is not None, "Replace the `...` in `receptive_field` with code that returns the field."
assert result == 7, f"Three stride-1 3 × 3 layers see 7 pixels, but you returned {result}."
assert receptive_field([(3, 1), (3, 2), (3, 1)]) == 9, "A stride-2 layer in the middle doubles the jump for the layer after it, giving 9."
assert receptive_field([(7, 2), (3, 2)]) == 11, "A 7 × 7 stride-2 layer followed by a 3 × 3 stride-2 layer gives 11."
--- hint
Keep the jump from before the current layer when you add to r, and update the jump afterwards.
--- hint
Inside the loop: `r += (k - 1) * jump`, then `jump *= s`.
```

## Debug: updating the jump too early

This receptive field should be 7 for two layers, the first with stride 2, but the jump is updated before it is used.

```python debug id=rf-order title="Use the jump before the stride changes it"
layers = [(3, 2), (3, 1)]
r, jump = 1, 1
for k, s in layers:
    jump *= s                  # bug: the jump is updated before the field grows
    r += (k - 1) * jump
print(r)
--- solution
layers = [(3, 2), (3, 1)]
r, jump = 1, 1
for k, s in layers:
    r += (k - 1) * jump
    jump *= s
print(r)
--- test
assert r == 7, f"The first layer adds 2, and the second adds 2 × 2 = 4 because the stride doubled the jump, giving 7. The code gives {r}. Add to r before you update the jump."
--- hint
The stride of a layer affects the layers that come after it, not the layer itself.
--- hint
Swap the two lines inside the loop.
```

## Predict the parameters

```python predict id=predict-params title="How many parameters does a 1 by 1 convolution from 64 to 64 channels have, with bias?"
print(1 * 1 * 64 * 64 + 64)
--- options
* 4160
4096
64
8256
--- explain
There are 64 × 64 = 4096 weights and 64 biases, which sum to 4160.
```

## Recap

- Parameters grow with the product of the channel counts and the kernel area.
- Strided layers shrink the feature maps, and the output size follows a simple formula.
- The receptive field grows with every layer and is multiplied by stride.
- Residual connections keep very deep networks trainable.

**Up next:** how a pretrained network is reused for a new task.
