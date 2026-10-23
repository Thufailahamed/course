Running diffusion on full-resolution pixels is expensive, because every step processes every pixel. Latent diffusion first compresses images with an autoencoder into a much smaller latent grid, runs the diffusion process there, and decodes the result back to pixels at the end. The denoiser sees far fewer values, so each step is much cheaper.

## Compression ratio

An autoencoder that downsamples by a factor f with c latent channels shrinks the number of values by a large factor.

```python run
import numpy as np

H, W, C = 512, 512, 3
f, c = 8, 4
latent_shape = (H // f, W // f, c)
ratio = (H * W * C) / np.prod(latent_shape)
print("latent shape:", latent_shape)
print("values reduced by a factor of", round(float(ratio), 1))
```

## Latent shapes for other sizes

The latent grid depends only on the image size and the downsampling factor, so the same autoencoder handles any resolution that divides evenly.

```python run
for size in [256, 512, 1024]:
    print(f"{size} x {size} image -> latent {size // f} x {size // f} x {c}")
```

## Noise in the latent space

Diffusion is run on the latent exactly as it was run on pixels, with the same forward and reverse formulas.

```python run
rng = np.random.default_rng(8)
latent = rng.normal(0, 1, size=latent_shape)
abar = 0.5
noisy = np.sqrt(abar) * latent + np.sqrt(1 - abar) * rng.normal(size=latent_shape)
print("noisy latent shape:", noisy.shape)
```

## Work per step

The cost of one denoising step scales with the number of values, so the latent makes each step much cheaper.

```python run
pixel_values = H * W * C
latent_values = int(np.prod(latent_shape))
print("pixel values:", pixel_values, "| latent values:", latent_values)
```

> **Pitfall:** the autoencoder limits quality. Fine text and small faces can be blurred by a poor decoder, even when the diffusion model is excellent, so check the autoencoder separately.

> **In the wild:** Stable Diffusion and most open image generators run in a latent space with an eight-fold reduction, which is why they fit on consumer hardware.

## Challenge: latent shape

```python exercise id=latent-shape title="Shape of the latent grid"
# TODO: `latent_shape(H, W, f, c)` returns (H // f, W // f, c) for an image of height H and width W, downsampled by f with c
# latent channels.
def latent_shape(H, W, f, c):
    ...
--- solution
def latent_shape(H, W, f, c):
    return (H // f, W // f, c)
--- test
result = latent_shape(512, 512, 8, 4)
assert result is not None, "Replace the `...` in `latent_shape` with code that returns the shape."
assert result == (64, 64, 4), f"A 512 image downsampled by 8 gives 64, so the latent is (64, 64, 4), but you returned {result}."
assert latent_shape(256, 128, 4, 3) == (64, 32, 3), "The height and width are divided separately."
--- hint
Integer division by the downsampling factor, applied to height and width.
--- hint
`return (H // f, W // f, c)`.
```

## Challenge: compression ratio

```python exercise id=compression-ratio title="How many fewer values the latent has"
# TODO: `compression_ratio(H, W, C, h, w, c)` returns the number of pixel values H × W × C divided by the number of latent
# values h × w × c, as a float.
def compression_ratio(H, W, C, h, w, c):
    ...
--- solution
def compression_ratio(H, W, C, h, w, c):
    return (H * W * C) / (h * w * c)
--- test
result = compression_ratio(512, 512, 3, 64, 64, 4)
assert result is not None, "Replace the `...` in `compression_ratio` with code that returns the ratio."
assert abs(result - 48.0) < 1e-9, f"512 × 512 × 3 = 786432 pixel values and 64 × 64 × 4 = 16384 latent values, a ratio of 48, but you returned {result}."
--- hint
Compute both products first, then divide.
--- hint
`(H * W * C) / (h * w * c)`.
```

## Debug: the latent is smaller, so divide

The latent grid is smaller than the image by the downsampling factor, but the code multiplies the image size by the factor.

```python debug id=latent-direction title="Divide the image size by the downsampling factor"
H, W, f, c = 512, 512, 8, 4
latent = (H * f, W * f, c)          # bug: the latent is smaller, so the size is divided by f
print("latent shape:", latent)
--- solution
H, W, f, c = 512, 512, 8, 4
latent = (H // f, W // f, c)
print("latent shape:", latent)
--- test
assert latent == (64, 64, 4), f"A 512 image with factor 8 has a latent of (64, 64, 4), but the code gives {latent}. Divide by f."
--- hint
A downsampling factor of 8 makes the grid eight times smaller.
--- hint
Use `//` with `f`.
```

## Predict the ratio

```python predict id=predict-ratio title="What is the compression ratio from 256 by 256 by 3 pixels to a 32 by 32 by 4 latent?"
print(256 * 256 * 3 // (32 * 32 * 4))
--- options
* 48
12
8
96
--- explain
There are 196608 pixel values and 4096 latent values, and 196608 / 4096 = 48.
```

## Recap

- An autoencoder compresses images into a latent grid, and diffusion runs in that space.
- The latent shape is the image size divided by the downsampling factor, with its own channel count.
- Compression makes each denoising step much cheaper, at the price of decoder quality.

**Up next:** LoRA, which adapts a large model with a small number of parameters.
