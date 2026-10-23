Modern accelerators compute much faster in 16-bit floating point than in 32-bit, and they use half the memory. Mixed precision training does the bulk of the arithmetic in 16 bits while keeping a 32-bit copy of the weights, and it handles the one danger of low precision: small numbers vanish. The techniques that handle that danger, loss scaling and careful overflow checks, are what make the speed gain safe.

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

```