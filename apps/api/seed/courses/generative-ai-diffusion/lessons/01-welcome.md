A diffusion model learns to create images by learning to undo noise. Start with a photograph, add a little static, then a little more, until nothing is left but random pixels. A neural network learns to reverse each small step. At generation time you start from pure noise and apply the learned reversal many times, and an image appears.

This course implements that idea in NumPy on data that fits in the page, then shows the large-scale ingredients as static PyTorch code for you to run locally, each paired with the NumPy idea it extends.

> **How to use this lesson:** run the grey boxes, change a number and see what changes. Challenges check your code against tests.

## Noise is a Gaussian sample

Noise in diffusion is Gaussian. A standard normal sample has mean 0 and variance 1, and the code below draws a few of them.

```python run
import numpy as np

rng = np.random.default_rng(0)
noise = rng.normal(0.0, 1.0, size=5)
print("five Gaussian samples:", np.round(noise, 3))
print("mean and variance over 10000 draws:",
      round(float(rng.normal(size=10000).mean()), 3), round(float(rng.normal(size=10000).var()), 3))
```

## Predict the variance

```python predict id=predict-var title="What variance does a standard normal distribution have?"
import numpy as np
print(float(np.var(np.array([-1.0, 1.0]))))
--- options
* 1.0
0.0
2.0
0.5
--- explain
The variance of the values -1 and 1 is the mean of their squares, which is 1. A standard normal has variance one.
```

## Recap

- A diffusion model reverses a gradual noising process, one small step at a time.
- The noise is Gaussian, and the model is trained to predict it.
- Generation starts from pure noise and applies the learned reversal many times.

**Up next:** what a generative model learns, and the families it competes with.
