A model that recognizes a cat, finds a pedestrian or outlines a tumour is built from a few repeated operations: sliding filters over images, measuring overlap between boxes, and combining features from different scales. Each operation is simple. Together they solve problems that were out of reach a decade ago.

This course runs the NumPy code in the page, so every lesson's arithmetic is something you can execute and change. Full detectors and segmentation networks are large, so they are shown as static PyTorch code for you to run locally, each followed by a NumPy version of the idea it uses.

> **How to use this lesson:** run the grey boxes, change a number, and see what moves. The challenges check your code against tests.

## An image is a grid of numbers

This 4 by 4 grey image has values from 0 to 255 in each row.

```python run
import numpy as np

gradient = np.array([[0, 85, 170, 255]] * 4, dtype=np.uint8)
print("shape:", gradient.shape)
print(gradient)
```

Each row is a line of pixels, and each column is a position across the image. Every model in this course reads images in this form.

## Predict the shape

```python predict id=predict-shape title="What is the shape of a 4 by 5 colour image?"
import numpy as np
print(np.zeros((4, 5, 3)).shape)
--- options
* (4, 5, 3)
(3, 4, 5)
(20, 3)
(4, 5)
--- explain
A colour image has height, width and three channels for red, green and blue. The first two numbers are the grid size, and the last is the channel count.
```

## Recap

- An image is an array with a height, a width and usually three colour channels.
- Convolutions, overlap measures and attention over patches are the building blocks of modern vision models.
- Measuring a model correctly matters as much as building it.

**Up next:** pixels and channels in detail, starting with grayscale and normalization.
