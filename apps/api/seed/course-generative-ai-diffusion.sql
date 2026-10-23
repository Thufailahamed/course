DELETE FROM exercise_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_generative_ai_diffusion');

DELETE FROM quiz_attempts WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_generative_ai_diffusion');

DELETE FROM notes WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_generative_ai_diffusion');

DELETE FROM lesson_progress WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'crs_generative_ai_diffusion');

DELETE FROM discussions WHERE course_id = 'crs_generative_ai_diffusion';

DELETE FROM certificates WHERE course_id = 'crs_generative_ai_diffusion';

DELETE FROM enrollments WHERE course_id = 'crs_generative_ai_diffusion';

DELETE FROM reviews WHERE course_id = 'crs_generative_ai_diffusion';

DELETE FROM wishlist WHERE course_id = 'crs_generative_ai_diffusion';

DELETE FROM path_courses WHERE course_id = 'crs_generative_ai_diffusion';

DELETE FROM coupons WHERE course_id = 'crs_generative_ai_diffusion';

DELETE FROM lessons WHERE course_id = 'crs_generative_ai_diffusion';

DELETE FROM sections WHERE course_id = 'crs_generative_ai_diffusion';

UPDATE order_items SET course_id = NULL WHERE course_id = 'crs_generative_ai_diffusion';

DELETE FROM courses WHERE id = 'crs_generative_ai_diffusion';

INSERT OR IGNORE INTO categories (id, slug, name, description, icon, sort_order) VALUES ('cat_generative-ai', 'generative-ai', 'LLMs & Generative AI', 'Large language models, diffusion, fine-tuning and RAG.', 'sparkles', 2);

INSERT INTO courses (id, slug, title, subtitle, description, category_id, instructor_id, level, language, price_cents, compare_at_price_cents, currency, thumbnail_key, preview_video_url, accent, status, featured, what_you_learn, requirements, target_audience, tags, duration_minutes, lessons_count, rating_avg, rating_count, students_count, published_at, created_at, updated_at) VALUES
('crs_generative_ai_diffusion', 'generative-ai-diffusion', 'Generative AI: Diffusion Models', 'The noising and denoising maths behind modern image generation, implemented from scratch and then scaled up with latents, guidance and fine-tuning.', 'Diffusion models generate images by learning to reverse a gradual noising process. This course builds that idea from the ground up. You derive the forward process, train a denoiser on toy data, sample by running the reverse process, and then learn the ingredients that make large text-to-image models work: latent compression, text conditioning, classifier-free guidance and low-rank fine-tuning.

## Learn by building

- **The maths, checked.** Every formula is implemented in NumPy and compared against a simulation or a closed form.
- **A working sampler.** The capstone trains a denoiser on two-dimensional data and generates new points with the reverse process.
- **Debug challenges.** You fix the bugs that break diffusion code: a cumulative product written as a sum, a guidance formula that drops the unconditional term, and a latent shape computed in the wrong direction.
- **Large models shown honestly.** U-Nets, text encoders and LoRA fine-tuning are static PyTorch code for you to run locally, with a NumPy version of each idea.

## What you''ll cover

- **Generative modelling:** the landscape, and the forward noising process.
- **DDPM:** learning to denoise, reverse sampling, noise schedules and DDIM.
- **Conditioning:** cross-attention on text and classifier-free guidance.
- **Customization:** latent diffusion, LoRA, and a DreamBooth recipe.
- **Capstone:** a toy diffusion model that you train and sample.

## Why this course?

Image generators look like magic, but the training objective is a regression problem and the sampler is a loop of simple updates. Once you can write both, you can debug a bad sample, choose a schedule, tune guidance strength, and fine-tune a model on your own images without guessing.', 'cat_generative-ai', 'usr_sofia', 'advanced', 'English', 0, NULL, 'USD', NULL, NULL, 275, 'published', 0, '["Derive the forward noising process and its closed form","Train a denoiser with the DDPM noise-prediction objective and sample with the reverse process","Compare noise schedules and deterministic DDIM sampling","Explain cross-attention conditioning and classifier-free guidance","Reason about latent diffusion and LoRA fine-tuning, including parameter counts","Build and evaluate a small diffusion model end to end"]', '["Deep Learning Foundations or equivalent: backpropagation and the Gaussian distribution","Python and NumPy. The browser runs the NumPy code; large models are shown as PyTorch code for local use"]', '["ML engineers and researchers who want to understand how image generators work","Creative technologists who fine-tune generators for their own style or subjects"]', '["Diffusion","Image Generation","U-Net","Generative AI"]', 218, 16, 0, 0, 11640, '2026-04-28T07:17:00.982Z', '2026-03-29T07:17:00.982Z', '2026-10-18T07:17:00.982Z');

INSERT INTO sections (id, course_id, title, position, created_at) VALUES
('sec_generative_ai_diffusion_1', 'crs_generative_ai_diffusion', 'Generative Modeling', 0, '2026-06-25T07:17:00.982Z'),
('sec_generative_ai_diffusion_2', 'crs_generative_ai_diffusion', 'DDPM', 1, '2026-06-25T07:17:00.982Z'),
('sec_generative_ai_diffusion_3', 'crs_generative_ai_diffusion', 'Conditioning', 2, '2026-06-25T07:17:00.982Z'),
('sec_generative_ai_diffusion_4', 'crs_generative_ai_diffusion', 'Customization', 3, '2026-06-25T07:17:00.982Z'),
('sec_generative_ai_diffusion_5', 'crs_generative_ai_diffusion', 'Capstone', 4, '2026-06-25T07:17:00.982Z');

INSERT INTO lessons (id, section_id, course_id, title, type, position, duration_seconds, video_url, video_key, content, is_preview, quiz, resources, created_at, updated_at) VALUES
('les_generative_ai_diffusion_1_1', 'sec_generative_ai_diffusion_1', 'crs_generative_ai_diffusion', 'How this course works', 'interactive', 0, 480, NULL, NULL, 'A diffusion model learns to create images by learning to undo noise. Start with a photograph, add a little static, then a little more, until nothing is left but random pixels. A neural network learns to reverse each small step. At generation time you start from pure noise and apply the learned reversal many times, and an image appears.

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
', 1, '[]', '[{"title":"Denoising Diffusion Probabilistic Models (Ho et al.)","url":"https://arxiv.org/abs/2006.11239"},{"title":"Denoising Diffusion Implicit Models (Song et al.)","url":"https://arxiv.org/abs/2010.02502"},{"title":"High-Resolution Image Synthesis with Latent Diffusion Models","url":"https://arxiv.org/abs/2112.10752"},{"title":"LoRA: Low-Rank Adaptation of Large Language Models","url":"https://arxiv.org/abs/2106.09685"}]', '2026-06-25T07:17:00.982Z', '2026-10-19T07:17:00.982Z'),
('les_generative_ai_diffusion_1_2', 'sec_generative_ai_diffusion_1', 'crs_generative_ai_diffusion', 'The generative landscape and what a model learns', 'interactive', 1, 840, NULL, NULL, 'A generative model learns a distribution over examples and can draw new ones from it. Three families dominate image generation. Variational autoencoders compress images to a latent space and decode samples from it. Generative adversarial networks train a generator against a discriminator. Diffusion models learn to reverse noise, which makes training stable and sampling controllable. This lesson uses a two-cluster toy dataset to see what "learning a distribution" means in practice.

## A two-cluster dataset

Real data often has several modes. This toy dataset draws from two Gaussian clusters with different weights.

```python run
import numpy as np

rng = np.random.default_rng(3)
weights = np.array([0.3, 0.7])
means = np.array([-2.0, 2.0])
component = rng.choice(2, size=2000, p=weights)
data = rng.normal(means[component], 0.5)
print("sample mean:", round(float(data.mean()), 3))
print("share near the first cluster:", round(float(np.mean(data < 0)), 3))
```

## Mixture means

The mean of a mixture is the weighted average of the component means, which matches the sample mean above.

```python run
print("mixture mean:", float(np.sum(weights * means)))
```

## Noise becomes data

A generator maps noise to data. An affine map is the simplest example: take a standard normal sample and scale and shift it.

```python run
z = rng.normal(size=5000)
x = 2.0 * z + 3.0
print("generated mean and standard deviation:", round(float(x.mean()), 2), round(float(x.std()), 2))
```

## Histograms show the modes

A histogram reveals the number of modes that a model must capture. Two bumps need a model that can represent two regions.

```python run
counts, edges = np.histogram(data, bins=8)
print("counts per bin:", counts)
```

> **Pitfall:** a model that matches the average of the data can still miss a mode entirely. Mode dropping is a classic failure of generators, and it is why diffusion models are evaluated on coverage as well as quality.

> **In the wild:** diffusion models displaced GANs in most image generation work, because their training objective is stable and their sample quality scales with compute.

## Challenge: mixture mean

```python exercise id=mixture-mean title="Mean of a mixture"
import numpy as np

# TODO: `mixture_mean(weights, means)` returns the mean of a mixture: the sum of each weight times its mean, divided by the
# sum of the weights.
def mixture_mean(weights, means):
    ...
--- solution
import numpy as np

def mixture_mean(weights, means):
    w = np.asarray(weights, dtype=float)
    m = np.asarray(means, dtype=float)
    return float(np.sum(w * m) / np.sum(w))
--- test
result = mixture_mean([0.25, 0.75], [0.0, 4.0])
assert result is not None, "Replace the `...` in `mixture_mean` with code that returns the mean."
assert abs(result - 3.0) < 1e-9, f"0.25 × 0 + 0.75 × 4 = 3, but you returned {result}."
assert abs(mixture_mean([1, 1], [0.0, 4.0]) - 2.0) < 1e-9, "Equal weights give the simple average of the means, 2."
--- hint
Multiply the weights and the means elementwise, then sum.
--- hint
`np.sum(w * m) / np.sum(w)`.
```

## Challenge: Gaussian sampling

```python exercise id=sample-gaussian title="Draw from a Gaussian with a given mean and spread"
import numpy as np

# TODO: `sample_gaussian(mu, sigma, n, rng)` returns an array of n samples from a normal distribution with mean mu and
# standard deviation sigma, drawn with the generator rng.
def sample_gaussian(mu, sigma, n, rng):
    ...
--- solution
import numpy as np

def sample_gaussian(mu, sigma, n, rng):
    return mu + sigma * rng.normal(size=n)
--- test
import numpy as np
result = sample_gaussian(2.0, 0.0, 5, np.random.default_rng(0))
assert result is not None, "Replace the `...` in `sample_gaussian` with code that returns the samples."
assert result.shape == (5,), f"Five samples should have shape (5,), but you returned shape {result.shape}."
assert np.allclose(result, 2.0), "With zero spread every sample equals the mean."
--- hint
Draw standard normal samples with `rng.normal(size=n)`, then scale by sigma and shift by mu.
--- hint
`mu + sigma * rng.normal(size=n)`.
```

## Debug: mixture weights

The mean should be normalized by the total weight, but the code forgets the division.

```python debug id=mixture-normalize title="Normalize the mixture weights"
import numpy as np

w = np.array([1.0, 1.0])
m = np.array([0.0, 4.0])
mean = np.sum(w * m)                  # bug: the weights are not normalized
print("mixture mean:", mean)
--- solution
import numpy as np

w = np.array([1.0, 1.0])
m = np.array([0.0, 4.0])
mean = np.sum(w * m) / np.sum(w)
print("mixture mean:", mean)
--- test
assert abs(mean - 2.0) < 1e-9, f"Two equal components at 0 and 4 have mean 2, but the code gives {mean}. Divide by the sum of the weights."
--- hint
Weights that do not sum to one must be normalized.
--- hint
Divide by `np.sum(w)`.
```

## Predict the mixture mean

```python predict id=predict-mix title="What is the mean of a mixture with equal weights on -1 and 1?"
import numpy as np
w = np.array([0.5, 0.5])
m = np.array([-1.0, 1.0])
print(float(np.sum(w * m)))
--- options
* 0.0
1.0
-1.0
0.5
--- explain
The two components are symmetric around zero, so their weighted mean is zero.
```

## Recap

- A generative model learns a distribution, and new examples are drawn from it.
- Mixtures have means that are weighted averages of their components.
- Histograms and coverage checks reveal whether a model captures every mode.

**Up next:** the forward process that adds noise, step by step.
', 0, '[]', '[]', '2026-06-25T07:17:00.982Z', '2026-10-19T07:17:00.982Z'),
('les_generative_ai_diffusion_1_3', 'sec_generative_ai_diffusion_1', 'crs_generative_ai_diffusion', 'The forward noising process', 'interactive', 2, 960, NULL, NULL, 'The forward process turns a clean image into noise over T steps. At each step a little Gaussian noise is added and the signal is scaled down slightly. The schedule of those small amounts is set in advance, and it determines everything about training. Crucially, the noisy image at any step can be sampled in one shot, without simulating the chain, and this closed form is what makes training fast.

## The per-step noise schedule

Each step t uses a small variance beta_t. Let alpha_t = 1 − beta_t, and let alpha-bar at step t be the product of alpha over all steps up to t.

```python run
import numpy as np

betas = np.linspace(1e-4, 0.02, 10)
alphas = 1 - betas
alpha_bar = np.cumprod(alphas)
print("alpha-bar for 10 steps:", np.round(alpha_bar, 4))
```

Alpha-bar starts near one, meaning the image is almost unchanged, and falls toward zero, meaning the image is almost pure noise.

## The step-by-step process matches the closed form

Iterating one step at a time gives the same alpha-bar as the product formula. The check below confirms it.

```python run
p = 1.0
loop_values = []
for b in betas:
    p *= 1 - b
    loop_values.append(p)
print("step-by-step matches the product:", np.allclose(loop_values, alpha_bar))
```

## Noising an image in one shot

The noisy image at step t is the scaled clean image plus scaled noise, x_t = sqrt(alpha-bar_t) x_0 + sqrt(1 − alpha-bar_t) ε.

```python run
rng = np.random.default_rng(4)
x0 = np.array([1.0, -1.0, 2.0, 0.5])
eps = rng.normal(size=4)
for t in [0, 4, 9]:
    xt = np.sqrt(alpha_bar[t]) * x0 + np.sqrt(1 - alpha_bar[t]) * eps
    print(f"step {t}: alpha-bar {alpha_bar[t]:.3f}, x_t {np.round(xt, 2)}")
```

## Noise at the end

With a full 1000-step schedule the alpha-bar at the last step is tiny, so the sample is almost pure standard normal noise.

```python run
betas_full = np.linspace(1e-4, 0.02, 1000)
abar_end = np.prod(1 - betas_full)
x_T = np.sqrt(1 - abar_end) * rng.normal(size=10000)
print("alpha-bar at the last step:", float(abar_end))
print("variance of the last noisy sample:", round(float(x_T.var()), 3))
```

> **Pitfall:** the scaling factors are square roots, not the alpha-bar values themselves. Mixing them up gives a signal that fades too fast and a training target that is wrong.

> **In the wild:** the schedule is one of the first things to tune when a diffusion model produces grey or washed-out images, because it sets how much of the signal the model sees at each noise level.

## Challenge: alpha-bar

```python exercise id=alpha-bar title="Cumulative product of the alphas"
import numpy as np

# TODO: `alpha_bar(betas)` returns the cumulative product of (1 − beta) over the list of betas, as a numpy array.
def alpha_bar(betas):
    ...
--- solution
import numpy as np

def alpha_bar(betas):
    return np.cumprod(1 - np.asarray(betas, dtype=float))
--- test
import numpy as np
result = alpha_bar([0.1, 0.1])
assert result is not None, "Replace the `...` in `alpha_bar` with code that returns the cumulative product."
assert np.allclose(result, [0.9, 0.81]), f"The alphas are 0.9 and 0.9, so the cumulative product is [0.9, 0.81], but you returned {result}."
--- hint
Take `1 − betas` and then the cumulative product along the only axis.
--- hint
`np.cumprod(1 - np.asarray(betas, dtype=float))`.
```

## Challenge: forward sample

```python exercise id=forward-sample title="Noise a clean value in one step"
import numpy as np

# TODO: `forward_sample(x0, abar_t, eps)` returns sqrt(abar_t) × x0 + sqrt(1 − abar_t) × eps for arrays x0 and eps.
def forward_sample(x0, abar_t, eps):
    ...
--- solution
import numpy as np

def forward_sample(x0, abar_t, eps):
    x0 = np.asarray(x0, dtype=float)
    eps = np.asarray(eps, dtype=float)
    return np.sqrt(abar_t) * x0 + np.sqrt(1 - abar_t) * eps
--- test
import numpy as np
result = forward_sample(np.array([1.0, 2.0]), 1.0, np.array([5.0, 5.0]))
assert result is not None, "Replace the `...` in `forward_sample` with code that returns the noisy sample."
assert np.allclose(result, [1.0, 2.0]), "With alpha-bar 1 there is no noise, so the output is x0."
assert np.allclose(forward_sample(np.array([1.0, 2.0]), 0.0, np.array([5.0, 5.0])), [5.0, 5.0]), "With alpha-bar 0 the output is pure noise."
--- hint
Use `np.sqrt` on both coefficients.
--- hint
`np.sqrt(abar_t) * x0 + np.sqrt(1 - abar_t) * eps`.
```

## Debug: a missing square root

The signal should be scaled by the square root of alpha-bar, but the code uses alpha-bar directly.

```python debug id=signal-scale title="Scale the signal by the square root of alpha-bar"
import numpy as np

abar = 0.25
x0 = np.array([4.0])
eps = np.array([0.0])
xt = abar * x0 + np.sqrt(1 - abar) * eps        # bug: the signal coefficient should be sqrt(abar)
print("x_t:", xt)
--- solution
import numpy as np

abar = 0.25
x0 = np.array([4.0])
eps = np.array([0.0])
xt = np.sqrt(abar) * x0 + np.sqrt(1 - abar) * eps
print("x_t:", xt)
--- test
assert abs(xt[0] - 2.0) < 1e-9, f"The signal should be sqrt(0.25) × 4 = 2, but the code gives {xt[0]}. Use the square root of alpha-bar."
--- hint
sqrt(0.25) is 0.5, not 0.25.
--- hint
Wrap `abar` in `np.sqrt`.
```

## Predict the product

```python predict id=predict-abar title="What is alpha-bar after one step with beta 0.5?"
import numpy as np
print(float(np.cumprod(1 - np.array([0.5]))[-1]))
--- options
* 0.5
0.25
0.75
1.0
--- explain
After one step alpha is 1 − 0.5 = 0.5, and the cumulative product is just that value.
```

## Recap

- The forward process has a closed form, so any noise level is one sample away.
- Alpha-bar is the cumulative product of the per-step alphas.
- The signal is scaled by the square root of alpha-bar, and the noise by the square root of one minus alpha-bar.

**Up next:** training the denoiser to predict the noise.
', 0, '[]', '[]', '2026-06-25T07:17:00.982Z', '2026-10-19T07:17:00.982Z'),
('les_generative_ai_diffusion_2_1', 'sec_generative_ai_diffusion_2', 'crs_generative_ai_diffusion', 'Learning to denoise: the noise-prediction objective', 'interactive', 0, 1080, NULL, NULL, 'The denoiser is trained to predict the noise that was added to a training image. Given the noisy image and its step, the network outputs an estimate of ε. The loss is the mean squared error between the true noise and the prediction. Predicting noise, rather than the clean image, turns out to be stable across every noise level, which is why it became the standard parameterization.

## The optimal predictor in a simple case

When data and noise are both standard Gaussian, the best linear predictor of the noise from the noisy sample is a simple scaling. We can check this by simulation at one noise level.

```python run
import numpy as np

rng = np.random.default_rng(5)
abar = 0.25
s, c = np.sqrt(abar), np.sqrt(1 - abar)
x0 = rng.normal(size=20000)
eps = rng.normal(size=20000)
xt = s * x0 + c * eps
slope = np.sum(xt * eps) / np.sum(xt * xt)
print("fitted slope:", round(float(slope), 3), "| theory sqrt(1 - abar):", round(float(c), 3))
```

The fitted slope matches the theoretical coefficient, so the best linear noise predictor is c × x_t at this level.

## The training loss

The DDPM loss is the mean squared error between the true noise and the predicted noise, averaged over the batch.

```python run
def diffusion_loss(eps, eps_hat):
    return float(np.mean((eps - eps_hat) ** 2))

print("loss of predicting zero:", round(diffusion_loss(eps, np.zeros_like(eps)), 4))
print("loss of the fitted predictor:", round(diffusion_loss(eps, slope * xt), 4))
```

## Recovering the clean image

If you know the predicted noise, the clean image estimate follows from the forward equation. This is how samplers use the network output.

```python run
x0_hat = (xt - c * (slope * xt)) / s
print("mean squared error of the clean estimate:", round(float(np.mean((x0_hat - x0) ** 2)), 3))
```

## Gradient descent on the predictor

Training fits the parameters by gradient descent. This sketch fits a single scale on the same data.

```python run
a = 0.0
lr = 0.5
for step in range(200):
    grad = -2 * np.mean((eps - a * xt) * xt)
    a -= lr * grad
print("learned scale after 200 steps:", round(float(a), 3))
```

The full training step in PyTorch is shown below as static code. It is the NumPy loss above, applied to a batch.

```python
import torch
import torch.nn.functional as F

for x0 in dataloader:                              # clean images, shape (B, C, H, W)
    t = torch.randint(0, T, (x0.size(0),))
    eps = torch.randn_like(x0)
    a = sqrt_abar[t].view(-1, 1, 1, 1)
    b = sqrt_one_minus_abar[t].view(-1, 1, 1, 1)
    xt = a * x0 + b * eps
    loss = F.mse_loss(model(xt, t), eps)           # predict the noise
    optimizer.zero_grad()
    loss.backward()
    optimizer.step()
```

> **Pitfall:** the loss is averaged over random noise levels in each batch. A batch that samples only high-noise steps trains poorly, so the step t is drawn uniformly at random for every example.

> **In the wild:** the standard DDPM loss is a single line in the training loop, but nearly all of the engineering effort goes into data, the U-Net architecture and the time embedding.

## Challenge: noise target

```python exercise id=eps-target title="The noise that produced a noisy sample"
import numpy as np

# TODO: `eps_target(x_t, x0, abar)` returns the noise that produced x_t from x0: (x_t − sqrt(abar) × x0) / sqrt(1 − abar).
def eps_target(x_t, x0, abar):
    ...
--- solution
import numpy as np

def eps_target(x_t, x0, abar):
    return (np.asarray(x_t, dtype=float) - np.sqrt(abar) * np.asarray(x0, dtype=float)) / np.sqrt(1 - abar)
--- test
import numpy as np
x_t = np.array([0.5 + np.sqrt(0.75) * 2.0])
result = eps_target(x_t, np.array([1.0]), 0.25)
assert result is not None, "Replace the `...` in `eps_target` with code that returns the noise."
assert np.allclose(result, [2.0]), f"x_t was built from x0 = 1 and noise 2 with alpha-bar 0.25, so the noise is 2, but you returned {result}."
--- hint
Subtract the scaled clean image from x_t, then divide by the noise coefficient.
--- hint
`(x_t - np.sqrt(abar) * x0) / np.sqrt(1 - abar)`.
```

## Challenge: clean estimate from noise

```python exercise id=x0-from-eps title="Recover the clean image from the predicted noise"
import numpy as np

# TODO: `x0_from_eps(x_t, eps, abar)` returns (x_t − sqrt(1 − abar) × eps) / sqrt(abar).
def x0_from_eps(x_t, eps, abar):
    ...
--- solution
import numpy as np

def x0_from_eps(x_t, eps, abar):
    return (np.asarray(x_t, dtype=float) - np.sqrt(1 - abar) * np.asarray(eps, dtype=float)) / np.sqrt(abar)
--- test
import numpy as np
x_t = np.array([0.5 + np.sqrt(0.75) * 2.0])
result = x0_from_eps(x_t, np.array([2.0]), 0.25)
assert result is not None, "Replace the `...` in `x0_from_eps` with code that returns the estimate."
assert np.allclose(result, [1.0]), f"The clean image was 1, so the estimate should be 1, but you returned {result}."
--- hint
This is the forward equation solved for x0.
--- hint
Divide by `np.sqrt(abar)` after subtracting the noise term.
```

## Debug: dividing by the wrong coefficient

The noise target should divide by sqrt(1 − abar), but the code divides by sqrt(abar).

```python debug id=eps-coefficient title="Divide the noise by the noise coefficient"
import numpy as np

abar = 0.25
x0 = 1.0
xt = 0.5 + np.sqrt(0.75) * 2.0
eps = (xt - np.sqrt(abar) * x0) / np.sqrt(abar)       # bug: the divisor should be sqrt(1 - abar)
print("eps:", round(float(eps), 4))
--- solution
import numpy as np

abar = 0.25
x0 = 1.0
xt = 0.5 + np.sqrt(0.75) * 2.0
eps = (xt - np.sqrt(abar) * x0) / np.sqrt(1 - abar)
print("eps:", round(float(eps), 4))
--- test
assert abs(eps - 2.0) < 1e-9, f"The noise was 2, but the code gives {eps:.4f}. The divisor is the noise coefficient, sqrt(1 − abar)."
--- hint
The noise was scaled by sqrt(1 − abar) when it was added.
--- hint
Replace `np.sqrt(abar)` in the divisor.
```

## Predict the loss

```python predict id=predict-mse title="What is the loss of predicting zero for the target [1, -1]?"
import numpy as np
print(float(np.mean((np.array([1.0, -1.0]) - 0.0) ** 2)))
--- options
* 1.0
0.0
2.0
0.5
--- explain
The squared errors are 1 and 1, so their mean is 1.
```

## Recap

- The denoiser predicts the noise, and the training loss is the mean squared error of that prediction.
- The optimal prediction at each noise level is recoverable from the forward equation.
- Noise targets and clean estimates are two views of the same relation.

**Up next:** running the reverse process to generate samples.
', 0, '[]', '[]', '2026-06-25T07:17:00.982Z', '2026-10-19T07:17:00.982Z'),
('les_generative_ai_diffusion_2_2', 'sec_generative_ai_diffusion_2', 'crs_generative_ai_diffusion', 'Sampling: running the reverse process', 'interactive', 1, 960, NULL, NULL, 'Sampling starts from pure noise and applies the learned reversal one step at a time, from the last step to the first. Each step removes a fraction of the predicted noise and adds back a small amount of fresh noise, which keeps the samples diverse. This is the DDPM ancestral sampler, and its update is a simple formula built from the schedule and the network output.

## The reverse mean

The DDPM mean for the previous step is (x_t − β_t / sqrt(1 − abar_t) × ε̂) / sqrt(α_t).

```python run
import numpy as np

def ddpm_mean(x_t, eps_hat, alpha, abar, beta):
    return (x_t - beta / np.sqrt(1 - abar) * eps_hat) / np.sqrt(alpha)

print("mean with zero predicted noise:", round(float(ddpm_mean(2.0, 0.0, 0.5, 0.5, 0.5)), 4))
print("mean with predicted noise 1:", round(float(ddpm_mean(1.0, 1.0, 0.5, 0.75, 0.5)), 4))
```

## A full reverse loop

The loop below runs the sampler with a placeholder noise predictor that always returns zero. The output shows that the model''s predictions drive the result.

```python run
T = 10
betas = np.linspace(1e-4, 0.2, T)
alphas = 1 - betas
abars = np.cumprod(alphas)
rng = np.random.default_rng(6)
x = rng.normal(size=5)
for t in reversed(range(T)):
    eps_hat = np.zeros_like(x)                 # a placeholder model
    mean = ddpm_mean(x, eps_hat, alphas[t], abars[t], betas[t])
    noise = rng.normal(size=5) if t > 0 else 0.0
    x = mean + np.sqrt(betas[t]) * noise
print("final samples:", np.round(x, 3))
```

## The noise scale at each step

Each step adds noise with scale sqrt(beta). The last step is the exception, because it adds none.

```python run
print("noise scale per step:", np.round(np.sqrt(betas), 4))
```

## How many steps

A sampler with T steps needs T network evaluations, which is why sampling is slow compared with a GAN.

```python run
for T_try in [50, 200, 1000]:
    print(f"{T_try} steps means {T_try} network calls per image")
```

> **Pitfall:** a sampler that adds noise at the last step produces grainy images. Skipping noise at t = 0 is part of the algorithm, not an optimization.

> **In the wild:** modern samplers use far fewer steps than the training schedule, with ODE solvers or distilled models, because each network call is expensive.

## Challenge: the reverse mean

```python exercise id=ddpm-mean title="One reverse step of the DDPM sampler"
import numpy as np

# TODO: `ddpm_mean(x_t, eps_hat, alpha, abar, beta)` returns (x_t − beta / sqrt(1 − abar) × eps_hat) / sqrt(alpha).
def ddpm_mean(x_t, eps_hat, alpha, abar, beta):
    ...
--- solution
import numpy as np

def ddpm_mean(x_t, eps_hat, alpha, abar, beta):
    return (x_t - beta / np.sqrt(1 - abar) * eps_hat) / np.sqrt(alpha)
--- test
import numpy as np
result = ddpm_mean(1.0, 1.0, 0.5, 0.75, 0.5)
assert result is not None, "Replace the `...` in `ddpm_mean` with code that returns the mean."
assert abs(result) < 1e-9, f"beta / sqrt(1 − abar) = 0.5 / 0.5 = 1, so the result is (1 − 1) / sqrt(0.5) = 0, but you returned {result}."
assert abs(ddpm_mean(2.0, 0.0, 0.5, 0.5, 0.5) - 2.0 / np.sqrt(0.5)) < 1e-9, "With zero predicted noise the mean is x_t divided by sqrt(alpha)."
--- hint
Compute the scaled noise term first, subtract it from x_t, then divide by sqrt(alpha).
--- hint
`(x_t - beta / np.sqrt(1 - abar) * eps_hat) / np.sqrt(alpha)`.
```

## Challenge: step schedule

```python exercise id=sample-steps title="Evenly spaced timesteps for sampling"
import numpy as np

# TODO: `sample_steps(T, n)` returns n integer timesteps from T − 1 down to 0, evenly spaced and including both ends.
def sample_steps(T, n):
    ...
--- solution
import numpy as np

def sample_steps(T, n):
    return np.linspace(T - 1, 0, n).round().astype(int)
--- test
result = sample_steps(10, 4)
assert result is not None, "Replace the `...` in `sample_steps` with code that returns the timesteps."
assert result.tolist() == [9, 6, 3, 0], f"Four steps from 9 to 0 are [9, 6, 3, 0], but you returned {result.tolist()}."
--- hint
`np.linspace` gives evenly spaced floats, which you then round to integers.
--- hint
`np.linspace(T - 1, 0, n).round().astype(int)`.
```

## Debug: the wrong order of steps

The reverse process must visit the timesteps from the last one to the first, but this loop visits them in increasing order.

```python debug id=step-order title="Run the reverse process from the last step"
T = 5
order = list(range(T))                 # bug: the reverse process starts at the last step
print("visiting order:", order)
--- solution
T = 5
order = list(reversed(range(T)))
print("visiting order:", order)
--- test
assert order == [4, 3, 2, 1, 0], f"The reverse process runs from step 4 down to 0, but the order is {order}. Use reversed(range(T))."
--- hint
Noise is removed from the most noisy step first.
--- hint
`list(reversed(range(T)))`.
```

## Predict the step size

```python predict id=predict-mean title="What is the reverse mean of x_t = 2 with zero predicted noise and alpha 0.5, to two decimals?"
import numpy as np
print(round(2 / np.sqrt(0.5), 2))
--- options
* 2.83
1.41
4.0
2.0
--- explain
With zero predicted noise the mean is x_t divided by sqrt(alpha), which is 2 divided by sqrt(0.5), about 2.83.
```

## Recap

- DDPM sampling runs the reverse process from the most noisy step to the clean one.
- Each step applies the reverse mean, and adds noise except at the final step.
- The number of steps sets the cost, one network call per step.

**Up next:** noise schedules, and DDIM, which samples deterministically with fewer steps.
', 0, '[]', '[]', '2026-06-25T07:17:00.982Z', '2026-10-19T07:17:00.982Z'),
('les_generative_ai_diffusion_2_3', 'sec_generative_ai_diffusion_2', 'crs_generative_ai_diffusion', 'Noise schedules and deterministic DDIM sampling', 'interactive', 2, 960, NULL, NULL, 'The linear schedule is simple, but it wastes steps at low noise and overloads high noise. A cosine schedule spreads the signal more evenly across steps. DDIM goes further: it turns the sampler into a deterministic mapping from noise to image, so a sample can be produced in far fewer steps. This lesson builds both.

## Linear versus cosine

The cosine schedule defines alpha-bar directly from a cosine curve, which keeps the signal-to-noise ratio decreasing smoothly.

```python run
import numpy as np

def cosine_alpha_bar(t, T, s=0.008):
    f = lambda u: np.cos((u / T + s) / (1 + s) * np.pi / 2) ** 2
    return f(t) / f(0)

T = 100
linear_betas = np.linspace(1e-4, 0.02, T)
linear_abar = np.cumprod(1 - linear_betas)
for t in [10, 50, 90]:
    print(f"step {t}: linear {linear_abar[t]:.4f}, cosine {cosine_alpha_bar(t, T):.4f}")
```

The cosine schedule keeps more signal at the middle steps, where the linear schedule has already added a lot of noise.

## Signal-to-noise ratio

The ratio of signal to noise at each step is alpha-bar over one minus alpha-bar. It falls steadily as t grows.

```python run
snr = linear_abar / (1 - linear_abar)
print("linear SNR at steps 0, 50 and 99:", np.round(snr[[0, 50, 99]], 2))
```

## A deterministic DDIM step

DDIM first estimates x_0 from the noise prediction, then moves to the previous noise level with the same noise. With no fresh noise, the mapping is deterministic.

```python run
def ddim_step(x_t, eps, abar_t, abar_prev):
    x0 = (x_t - np.sqrt(1 - abar_t) * eps) / np.sqrt(abar_t)
    return np.sqrt(abar_prev) * x0 + np.sqrt(1 - abar_prev) * eps

x_t = np.array([0.8])
eps = np.array([0.3])
print("DDIM step:", np.round(ddim_step(x_t, eps, 0.5, 0.7), 4))
```

## Fewer steps, same model

Because DDIM is deterministic, it can skip steps. The sampler runs on a subset of the training timesteps.

```python run
steps = np.linspace(T - 1, 0, 10).round().astype(int)
print("ten DDIM timesteps out of 100:", steps)
```

> **Pitfall:** DDIM with more steps is not always better. Beyond a point, sample quality flattens while the cost keeps rising, so pick the step count by measuring quality, not by default.

> **In the wild:** most deployed diffusion services use a few dozen steps with a fast solver, because the cost of sampling is what users pay for.

## Challenge: cosine alpha-bar

```python exercise id=cosine-abar title="Cosine noise schedule"
import numpy as np

# TODO: `cosine_alpha_bar(t, T, s=0.008)` returns cos((t / T + s) / (1 + s) × π / 2)² divided by the same value at t = 0.
def cosine_alpha_bar(t, T, s=0.008):
    ...
--- solution
import numpy as np

def cosine_alpha_bar(t, T, s=0.008):
    f = lambda u: np.cos((u / T + s) / (1 + s) * np.pi / 2) ** 2
    return f(t) / f(0)
--- test
result = cosine_alpha_bar(0, 100)
assert result is not None, "Replace the `...` in `cosine_alpha_bar` with code that returns the value."
assert abs(result - 1.0) < 1e-9, "At step zero the schedule is normalized to one."
assert cosine_alpha_bar(100, 100) < 1e-6, "At the last step the signal is essentially gone."
--- hint
Write the cosine formula as a helper and divide by its value at zero.
--- hint
`f = lambda u: np.cos((u / T + s) / (1 + s) * np.pi / 2) ** 2` and `return f(t) / f(0)`.
```

## Challenge: DDIM step

```python exercise id=ddim-step title="One deterministic DDIM step"
import numpy as np

# TODO: `ddim_step(x_t, eps, abar_t, abar_prev)` estimates x_0 as (x_t − sqrt(1 − abar_t) × eps) / sqrt(abar_t), then returns
# sqrt(abar_prev) × x_0 + sqrt(1 − abar_prev) × eps.
def ddim_step(x_t, eps, abar_t, abar_prev):
    ...
--- solution
import numpy as np

def ddim_step(x_t, eps, abar_t, abar_prev):
    x0 = (x_t - np.sqrt(1 - abar_t) * eps) / np.sqrt(abar_t)
    return np.sqrt(abar_prev) * x0 + np.sqrt(1 - abar_prev) * eps
--- test
import numpy as np
result = ddim_step(np.array([1.0]), np.array([0.5]), 0.5, 0.5)
assert result is not None, "Replace the `...` in `ddim_step` with code that returns the next sample."
assert np.allclose(result, [1.0]), "When the noise level does not change, the step returns x_t."
--- hint
Compute x_0 first, then rebuild x at the previous noise level with the same noise.
--- hint
Both coefficients use `np.sqrt`.
```

## Debug: a cumulative sum instead of a product

Alpha-bar is the cumulative product of the alphas, but the code adds them up.

```python debug id=cumsum-abar title="Alpha-bar is a product, not a sum"
import numpy as np

betas = np.array([0.1, 0.1, 0.1])
alpha_bar = np.cumsum(1 - betas)        # bug: alpha-bar multiplies the alphas
print("alpha-bar:", np.round(alpha_bar, 4))
--- solution
import numpy as np

betas = np.array([0.1, 0.1, 0.1])
alpha_bar = np.cumprod(1 - betas)
print("alpha-bar:", np.round(alpha_bar, 4))
--- test
assert abs(alpha_bar[-1] - 0.729) < 1e-9, f"Three alphas of 0.9 multiply to 0.729, but the code gives {alpha_bar[-1]}. Use a cumulative product."
--- hint
A signal that passes through three steps is multiplied three times.
--- hint
Use `np.cumprod`.
```

## Predict the timesteps

```python predict id=predict-steps title="What are the four evenly spaced timesteps from 9 down to 0?"
import numpy as np
print(np.linspace(9, 0, 4).round().astype(int))
--- options
* [9 6 3 0]
[9 7 5 3]
[9 8 4 0]
[8 6 4 2]
--- explain
Four evenly spaced points from 9 to 0 are 9, 6, 3 and 0.
```

## Recap

- A cosine schedule spreads the signal more evenly than a linear one.
- Signal-to-noise falls with each step, and the schedule controls how fast.
- DDIM gives a deterministic sampler, which can run in far fewer steps.

**Up next:** conditioning the denoiser on a text prompt.
', 0, '[]', '[]', '2026-06-25T07:17:00.982Z', '2026-10-19T07:17:00.982Z'),
('les_generative_ai_diffusion_2_4', 'sec_generative_ai_diffusion_2', 'crs_generative_ai_diffusion', 'Checkpoint: diffusion', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"In DDPM training, what does the network typically learn to predict?","options":["The class label","The noise that was added to the image","The next pixel in the image","The image caption"],"answerIndex":1,"explanation":"Predicting the noise is the standard, stable parameterization of the DDPM loss."},{"id":"q2","prompt":"Why is the closed form of the forward process useful?","options":["It lets any noise level be sampled in one step, without simulating the chain","It removes the need for a schedule","It doubles the number of steps","It makes the image larger"],"answerIndex":0,"explanation":"The closed form x_t = sqrt(abar) x_0 + sqrt(1 − abar) ε makes training samples cheap to draw."},{"id":"q3","prompt":"What is the main advantage of DDIM over ancestral DDPM sampling?","options":["It is deterministic and can use far fewer steps","It needs no network","It trains a GAN","It removes noise from the training data"],"answerIndex":0,"explanation":"DDIM has no fresh noise at each step, so it maps noise to images deterministically and can skip steps."},{"id":"q4","prompt":"Why is a cosine schedule often preferred to a linear one?","options":["It spreads the signal more evenly across the steps","It removes the need for alpha-bar","It gives the largest noise at step zero","It always uses the fewest parameters"],"answerIndex":0,"explanation":"The cosine curve keeps more signal in the middle steps, where a linear schedule has already added much noise."}]', '[]', '2026-06-25T07:17:00.982Z', '2026-10-19T07:17:00.982Z'),
('les_generative_ai_diffusion_3_1', 'sec_generative_ai_diffusion_3', 'crs_generative_ai_diffusion', 'Conditioning on text with cross-attention', 'interactive', 0, 1020, NULL, NULL, 'A text-to-image model must follow a prompt, so the denoiser needs to read the text at every step. Two mechanisms do most of the work. The timestep is turned into a vector with a sinusoidal embedding, so the network knows how noisy its input is. The text is encoded into tokens, and cross-attention lets the image features look up the relevant words while they are denoised.

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

The attended text vector is combined with the image features, and the denoiser''s output is pushed toward the prompt.

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
', 0, '[]', '[]', '2026-06-25T07:17:00.982Z', '2026-10-19T07:17:00.982Z'),
('les_generative_ai_diffusion_3_2', 'sec_generative_ai_diffusion_3', 'crs_generative_ai_diffusion', 'Classifier-free guidance', 'interactive', 1, 840, NULL, NULL, 'Conditioning alone tends to produce samples that are plausible but timid. Classifier-free guidance strengthens the conditioning without a separate classifier. The same network is trained with the prompt sometimes dropped, so it can predict noise with and without the condition. At sampling time the two predictions are combined, and a scale w controls how far the sample is pushed toward the prompt.

## The guidance formula

The guided noise is ε_u + w (ε_c − ε_u). At w = 0 it is the unconditional prediction, and at w = 1 it is the conditional one. Larger values extrapolate beyond the conditional prediction.

```python run
import numpy as np

eps_u = np.array([0.2, -0.1])     # unconditional prediction
eps_c = np.array([0.5, 0.3])      # conditional prediction
for w in [0.0, 1.0, 3.0, 7.5]:
    guided = eps_u + w * (eps_c - eps_u)
    print(f"w = {w}: {np.round(guided, 3)}")
```

## Dropping the condition during training

During training the prompt is replaced with a null embedding at a fixed rate, so the same network learns both predictions.

```python run
rng = np.random.default_rng(7)
drop_rate = 0.1
dropped = rng.random(10000) < drop_rate
print("share of training examples with the prompt dropped:", round(float(dropped.mean()), 3))
```

## Guidance grows the step

The magnitude of the guided prediction grows with the scale, which is one reason large scales oversaturate images.

```python run
for w in [1.0, 4.0, 7.5]:
    guided = eps_u + w * (eps_c - eps_u)
    print(f"w = {w}: norm {np.linalg.norm(guided):.3f}")
```

## Diversity and fidelity

A toy comparison of two spreads shows the trade-off: high guidance concentrates the samples and reduces their diversity.

```python run
samples_u = rng.normal(0.0, 1.0, 5000)
samples_c = rng.normal(1.0, 1.0, 5000)
for w in [1.0, 3.0]:
    guided = samples_u + w * (samples_c - samples_u)
    print(f"w = {w}: mean {guided.mean():.2f}, spread {guided.std():.2f}")
```

> **Pitfall:** a very high guidance scale gives oversaturated colours and distorted shapes. Typical values sit between roughly 3 and 10, and the right one depends on the model and sampler.

> **In the wild:** every text-to-image service exposes a guidance scale, which is the knob that trades faithfulness to the prompt against variety.

## Challenge: guided noise

```python exercise id=cfg title="Combine unconditional and conditional predictions"
# TODO: `cfg(eps_u, eps_c, w)` returns eps_u + w × (eps_c − eps_u).
def cfg(eps_u, eps_c, w):
    ...
--- solution
def cfg(eps_u, eps_c, w):
    return eps_u + w * (eps_c - eps_u)
--- test
result = cfg(0.2, 0.5, 3.0)
assert result is not None, "Replace the `...` in `cfg` with code that returns the guided value."
assert abs(result - 1.1) < 1e-9, f"0.2 + 3 × (0.5 − 0.2) = 1.1, but you returned {result}."
assert abs(cfg(0.2, 0.5, 0.0) - 0.2) < 1e-9, "With w = 0 the result is the unconditional prediction."
assert abs(cfg(0.2, 0.5, 1.0) - 0.5) < 1e-9, "With w = 1 the result is the conditional prediction."
--- hint
Subtract the unconditional prediction from the conditional one, scale by w, and add the unconditional prediction back.
--- hint
`eps_u + w * (eps_c - eps_u)`.
```

## Challenge: a guidance sweep

```python exercise id=cfg-sweep title="Guided values for several scales"
# TODO: `cfg_sweep(eps_u, eps_c, scales)` returns a list with cfg(eps_u, eps_c, w) for each w in scales. The function cfg is
# provided.
def cfg(eps_u, eps_c, w):
    return eps_u + w * (eps_c - eps_u)

def cfg_sweep(eps_u, eps_c, scales):
    ...
--- solution
def cfg(eps_u, eps_c, w):
    return eps_u + w * (eps_c - eps_u)

def cfg_sweep(eps_u, eps_c, scales):
    return [cfg(eps_u, eps_c, w) for w in scales]
--- test
result = cfg_sweep(0.0, 1.0, [0.0, 1.0, 2.0])
assert result is not None, "Replace the `...` in `cfg_sweep` with code that returns the list."
assert result == [0.0, 1.0, 2.0], f"With eps_u = 0 and eps_c = 1 the guided value equals w, so the list should be [0, 1, 2], but you returned {result}."
--- hint
A list comprehension over `scales` is enough.
--- hint
`[cfg(eps_u, eps_c, w) for w in scales]`.
```

## Debug: missing unconditional term

The guided value should start from the unconditional prediction, but the code drops that term.

```python debug id=cfg-missing-uncond title="Keep the unconditional term"
eps_u, eps_c, w = 0.3, 0.8, 0.0
guided = w * eps_c                  # bug: the unconditional term is missing
print("guided:", guided)
--- solution
eps_u, eps_c, w = 0.3, 0.8, 0.0
guided = eps_u + w * (eps_c - eps_u)
print("guided:", guided)
--- test
assert abs(guided - eps_u) < 1e-9, f"With w = 0 the guided value must be the unconditional prediction, 0.3, but the code gives {guided}. Keep the eps_u term."
--- hint
At w = 0 the output should not depend on the condition at all.
--- hint
Start the formula from `eps_u`.
```

## Predict the guided value

```python predict id=predict-cfg title="What is the guided value when eps_u = 0, eps_c = 1 and w = 7.5?"
print(0 + 7.5 * (1 - 0))
--- options
* 7.5
1.0
0.0
8.5
--- explain
The guided value is eps_u + w × (eps_c − eps_u) = 0 + 7.5 × 1 = 7.5.
```

## Recap

- Classifier-free guidance uses one network trained with the condition sometimes dropped.
- The guided prediction is ε_u + w (ε_c − ε_u), and w sets how strongly the prompt is followed.
- High scales improve fidelity and cost diversity, so the scale is a tuning choice.

**Up next:** latent diffusion, which runs all of this in a compressed space.
', 0, '[]', '[]', '2026-06-25T07:17:00.982Z', '2026-10-19T07:17:00.982Z'),
('les_generative_ai_diffusion_3_3', 'sec_generative_ai_diffusion_3', 'crs_generative_ai_diffusion', 'Checkpoint: conditioning', 'quiz', 2, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"In cross-attention conditioning, where do the queries come from?","options":["The text tokens","The image features of the denoiser","The noise schedule","The learning rate"],"answerIndex":1,"explanation":"The image features ask the text tokens what they should attend to, so the queries come from the image side."},{"id":"q2","prompt":"What does classifier-free guidance trade off?","options":["Speed and memory","Sample diversity against adherence to the condition","Resolution and colour","Training data against test data"],"answerIndex":1,"explanation":"A larger guidance scale pushes samples closer to the prompt, at the cost of diversity."},{"id":"q3","prompt":"With guidance scale w, the guided noise is ε_u + w (ε_c − ε_u). What is the result at w = 0?","options":["The conditional prediction","The unconditional prediction","Zero","The average of the two"],"answerIndex":1,"explanation":"At w = 0 the conditional term vanishes, leaving the unconditional prediction ε_u."},{"id":"q4","prompt":"Why is the condition randomly dropped during training?","options":["So the model learns both conditional and unconditional predictions for guidance","To make the model smaller","To speed up the optimizer","Because prompts are never useful"],"answerIndex":0,"explanation":"A single network trained with dropped conditions can produce both predictions needed for guidance."}]', '[]', '2026-06-25T07:17:00.982Z', '2026-10-19T07:17:00.982Z'),
('les_generative_ai_diffusion_4_1', 'sec_generative_ai_diffusion_4', 'crs_generative_ai_diffusion', 'Latent diffusion and its compression', 'interactive', 0, 900, NULL, NULL, 'Running diffusion on full-resolution pixels is expensive, because every step processes every pixel. Latent diffusion first compresses images with an autoencoder into a much smaller latent grid, runs the diffusion process there, and decodes the result back to pixels at the end. The denoiser sees far fewer values, so each step is much cheaper.

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
', 0, '[]', '[]', '2026-06-25T07:17:00.982Z', '2026-10-19T07:17:00.982Z'),
('les_generative_ai_diffusion_4_2', 'sec_generative_ai_diffusion_4', 'crs_generative_ai_diffusion', 'LoRA: low-rank adaptation', 'interactive', 1, 960, NULL, NULL, 'Fine-tuning every weight of a large diffusion model needs a large amount of memory and produces a full copy of the model for each new style. LoRA freezes the pretrained weights and learns a low-rank change instead. For a weight matrix W, the adapted weight is W + (alpha / r) B A, where A and B are thin matrices of rank r. Only A and B are trained, and they are small enough to store and share.

## Parameter counts

A full d by k matrix has d × k parameters. The LoRA factors have r × (d + k), and for small r that is far fewer.

```python run
import numpy as np

d, k, r = 768, 768, 8
full = d * k
lora = r * (d + k)
print("full parameters:", full, "| LoRA parameters:", lora)
print("LoRA share of the full matrix:", round(lora / full, 4))
```

## Starting from the pretrained model

B is initialized to zero, so the update is zero at the start and the adapted model is identical to the pretrained one.

```python run
rng = np.random.default_rng(9)
W = rng.normal(size=(4, 4))
A = rng.normal(size=(2, 4))
B = np.zeros((4, 2))
print("update at initialization is zero:", np.allclose(B @ A, 0.0))
```

## The update has rank r

The product B A has rank at most r, which is what makes it a low-rank change.

```python run
B = rng.normal(size=(4, 2))
print("rank of the update:", np.linalg.matrix_rank(B @ A))
```

## The scaling alpha over r

The factor alpha over r keeps the size of the update stable when the rank changes, so a tuned learning rate still works after the rank is changed.

```python run
for rank, alpha in [(2, 4), (4, 4), (4, 8)]:
    print(f"rank {rank}, alpha {alpha}: scale {alpha / rank}")
```

A LoRA wrapper around a pretrained linear layer is shown below as static PyTorch code. It implements the update W + (alpha / r) B A exactly as in the NumPy lesson.

```python
import torch
import torch.nn as nn

class LoRALinear(nn.Module):
    def __init__(self, base: nn.Linear, r=8, alpha=16):
        super().__init__()
        self.base = base
        for p in self.base.parameters():
            p.requires_grad = False                # freeze the pretrained weights
        self.A = nn.Parameter(torch.randn(r, base.in_features) * 0.01)
        self.B = nn.Parameter(torch.zeros(base.out_features, r))
        self.scale = alpha / r

    def forward(self, x):
        return self.base(x) + self.scale * (x @ self.A.T @ self.B.T)
```

> **Pitfall:** a LoRA trained on a few images can memorize them and ignore the prompt. Watch for this with validation prompts, and stop training before the adapter overfits.

> **In the wild:** LoRA adapters for diffusion models are small files, often a few megabytes, that people share to add a style or a subject to a base model.

## Challenge: LoRA parameter count

```python exercise id=lora-params title="Parameters of a LoRA adapter"
# TODO: `lora_params(d, k, r)` returns the number of parameters of a LoRA adapter for a d × k matrix with rank r: r × (d + k).
def lora_params(d, k, r):
    ...
--- solution
def lora_params(d, k, r):
    return r * (d + k)
--- test
result = lora_params(768, 768, 8)
assert result is not None, "Replace the `...` in `lora_params` with code that returns the count."
assert result == 12288, f"The adapter has 8 × 1536 = 12288 parameters, but you returned {result}."
assert lora_params(4, 6, 1) == 10, "A rank-one adapter for a 4 × 6 matrix has 10 parameters."
--- hint
The factors are of sizes d × r and r × k.
--- hint
`return r * (d + k)`.
```

## Challenge: LoRA update

```python exercise id=lora-update title="Apply a LoRA update"
import numpy as np

# TODO: `lora_update(W, A, B, alpha, r)` returns W + (alpha / r) × (B @ A).
def lora_update(W, A, B, alpha, r):
    ...
--- solution
import numpy as np

def lora_update(W, A, B, alpha, r):
    return np.asarray(W, dtype=float) + (alpha / r) * (np.asarray(B, dtype=float) @ np.asarray(A, dtype=float))
--- test
import numpy as np
result = lora_update(np.zeros((2, 2)), np.ones((1, 2)), np.ones((2, 1)), alpha=2, r=1)
assert result is not None, "Replace the `...` in `lora_update` with code that returns the adapted weight."
assert np.allclose(result, 2.0), f"B @ A is all ones and the scale is 2 / 1 = 2, so every entry should be 2, but you returned {result}."
assert np.allclose(lora_update(np.ones((2, 2)), np.zeros((1, 2)), np.ones((2, 1)), alpha=2, r=1), 1.0), "With a zero A the update adds nothing."
--- hint
Multiply B and A, scale by alpha over r, and add to W.
--- hint
`W + (alpha / r) * (B @ A)`.
```

## Debug: the missing scale

The adapter''s update should be scaled by alpha over r, but the code adds the raw product.

```python debug id=lora-scale title="Scale the LoRA update"
import numpy as np

W = np.zeros((2, 2))
A = np.ones((1, 2))
B = np.ones((2, 1))
alpha, r = 2, 1
W_new = W + B @ A                    # bug: the update is not scaled by alpha / r
print(W_new)
--- solution
import numpy as np

W = np.zeros((2, 2))
A = np.ones((1, 2))
B = np.ones((2, 1))
alpha, r = 2, 1
W_new = W + (alpha / r) * (B @ A)
print(W_new)
--- test
assert np.allclose(W_new, 2.0), f"With alpha 2 and rank 1 the update is scaled by 2, so each entry should be 2, but the code gives {W_new[0, 0]}. Multiply by alpha / r."
--- hint
The scale is alpha divided by r, which is 2 here.
--- hint
Write `W + (alpha / r) * (B @ A)`.
```

## Predict the adapter size

```python predict id=predict-lora title="How many parameters does a rank-4 LoRA have for a 100 by 100 matrix?"
print(4 * (100 + 100))
--- options
* 800
400
10000
40
--- explain
A rank-4 adapter has 4 × (100 + 100) = 800 parameters.
```

## Recap

- LoRA learns a low-rank update B A to a frozen weight, with B starting at zero.
- The adapter has r × (d + k) parameters, far fewer than the full matrix.
- The factor alpha over r keeps the update''s scale stable across ranks.

**Up next:** a DreamBooth recipe that combines a subject with prior preservation.
', 0, '[]', '[]', '2026-06-25T07:17:00.982Z', '2026-10-19T07:17:00.982Z'),
('les_generative_ai_diffusion_4_3', 'sec_generative_ai_diffusion_4', 'crs_generative_ai_diffusion', 'A DreamBooth fine-tuning recipe', 'interactive', 2, 840, NULL, NULL, 'DreamBooth teaches a diffusion model a new subject, such as a particular dog, from a handful of photographs. The trick is a rare identifier in the prompt, plus a prior-preservation loss on images of the general class, so that the model still draws ordinary dogs. The total loss adds the two terms, and the schedule of steps follows from the size of the training set.

## Combining the two losses

The loss is the instance loss on the subject images plus a weighted prior loss on generated images of the class.

```python run
def total_loss(l_instance, l_prior, lam=1.0):
    return l_instance + lam * l_prior

print("instance 0.4, prior 0.2, weight 1.0:", total_loss(0.4, 0.2))
print("instance 0.4, prior 0.2, weight 0.5:", total_loss(0.4, 0.2, 0.5))
```

## Counting training steps

The number of steps is the number of images times the epochs, divided by the batch size, rounded up.

```python run
import math

def steps_for(images, epochs, batch):
    return math.ceil(images * epochs / batch)

print("5 images, 3 epochs, batch 4:", steps_for(5, 3, 4))
print("20 images, 10 epochs, batch 4:", steps_for(20, 10, 4))
```

## A prompt with a rare identifier

The instance prompt names the subject with a rare token and the class, so the model binds the token to the subject.

```python run
instance_prompt = "a photo of sks dog"
class_prompt = "a photo of a dog"
print("instance prompt:", instance_prompt)
print("class prompt:   ", class_prompt)
```

## Prior images

The class images are generated by the base model before training, and a few hundred are usually enough.

```python run
n_class_images = 200
print("class images to generate before training:", n_class_images)
```

> **Pitfall:** a rare identifier that is a real word, such as a common name, collides with that word''s meaning in the base model. Choose a token the base model does not already know.

> **In the wild:** teams fine-tune with a few images and a short schedule, then test with new prompts, since the aim is a subject that appears in new scenes.

## Challenge: total loss

```python exercise id=total-loss title="Instance and prior loss together"
# TODO: `total_loss(l_instance, l_prior, lam=1.0)` returns l_instance + lam × l_prior.
def total_loss(l_instance, l_prior, lam=1.0):
    ...
--- solution
def total_loss(l_instance, l_prior, lam=1.0):
    return l_instance + lam * l_prior
--- test
result = total_loss(1.0, 2.0, 0.5)
assert result is not None, "Replace the `...` in `total_loss` with code that returns the sum."
assert abs(result - 2.0) < 1e-9, f"1 + 0.5 × 2 = 2, but you returned {result}."
assert abs(total_loss(1.0, 2.0) - 3.0) < 1e-9, "The default weight is one."
--- hint
Multiply the prior loss by the weight before adding.
--- hint
`return l_instance + lam * l_prior`.
```

## Challenge: steps for training

```python exercise id=steps-for title="Number of optimizer steps"
import math

# TODO: `steps_for(images, epochs, batch)` returns the number of optimizer steps: images × epochs / batch, rounded up to an
# integer with math.ceil.
def steps_for(images, epochs, batch):
    ...
--- solution
import math

def steps_for(images, epochs, batch):
    return math.ceil(images * epochs / batch)
--- test
result = steps_for(20, 10, 4)
assert result is not None, "Replace the `...` in `steps_for` with code that returns the count."
assert result == 50, f"200 image passes in batches of 4 give 50 steps, but you returned {result}."
assert steps_for(5, 3, 4) == 4, "15 passes in batches of 4 need 4 steps, the last one partly full."
--- hint
Use `math.ceil` on the division, not integer division.
--- hint
`return math.ceil(images * epochs / batch)`.
```

## Debug: truncated steps

The last partial batch is needed, but integer division drops it.

```python debug id=steps-truncate title="Round the step count up"
images, epochs, batch = 5, 3, 4
steps = images * epochs // batch          # bug: integer division drops the partial batch
print("steps:", steps)
--- solution
images, epochs, batch = 5, 3, 4
steps = -(-images * epochs // batch)
print("steps:", steps)
--- test
assert steps == 4, f"Fifteen passes in batches of 4 need 4 steps, but the code gives {steps}. Round the division up."
--- hint
15 divided by 4 is 3 with a remainder, and the remainder still needs a step.
--- hint
Use `math.ceil` or `-(-a // b)`.
```

## Predict the step count

```python predict id=predict-steps-db title="How many steps for 20 images, 10 epochs and batch 4?"
print(20 * 10 // 4)
--- options
* 50
40
200
5
--- explain
There are 200 image passes, and 200 / 4 is exactly 50 steps.
```

## Recap

- DreamBooth pairs a rare identifier with the subject, and adds a prior loss on the general class.
- The total loss is the sum of the instance and weighted prior terms.
- The number of steps is the number of passes divided by the batch size, rounded up.

**Up next:** the capstone, a toy diffusion model trained and sampled from scratch.
', 0, '[]', '[]', '2026-06-25T07:17:00.982Z', '2026-10-19T07:17:00.982Z'),
('les_generative_ai_diffusion_4_4', 'sec_generative_ai_diffusion_4', 'crs_generative_ai_diffusion', 'Checkpoint: latents and fine-tuning', 'quiz', 3, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"Why does latent diffusion run the diffusion process in a compressed space?","options":["It is far cheaper, since the latent has fewer elements than the pixel image","Pixels cannot be noised","It removes the need for a decoder","It makes the images black and white"],"answerIndex":0,"explanation":"A latent with a factor of 8 compression has many fewer values, so each step costs much less."},{"id":"q2","prompt":"How many parameters does a LoRA update of rank r add to a d by k weight matrix?","options":["d × k","r × (d + k)","r × d × k","d + k"],"answerIndex":1,"explanation":"LoRA adds two low-rank factors, of sizes d × r and r × k, so the count is r times d plus k."},{"id":"q3","prompt":"Why is the LoRA matrix B initialized to zero?","options":["So the adapted model starts identical to the pretrained model","So the rank becomes zero","So the learning rate is zero","So the weights of A are ignored"],"answerIndex":0,"explanation":"With B zero the update B A is zero at the start, so fine-tuning begins from the pretrained behaviour."},{"id":"q4","prompt":"What does prior preservation in DreamBooth protect against?","options":["Forgetting the general class, when the model learns a new subject","Slow inference","Large image sizes","Lost training data"],"answerIndex":0,"explanation":"A loss on generated images of the class keeps the model able to draw ordinary examples of that class."}]', '[]', '2026-06-25T07:17:00.982Z', '2026-10-19T07:17:00.982Z'),
('les_generative_ai_diffusion_5_1', 'sec_generative_ai_diffusion_5', 'crs_generative_ai_diffusion', 'Capstone: a toy diffusion model end to end', 'interactive', 0, 1560, NULL, NULL, 'This capstone builds a complete diffusion pipeline on two-dimensional data, so every part is visible. You generate a dataset with two clusters, noise it with the forward process, learn a denoiser from the pairs, sample with the reverse process and check the samples against the data. The denoiser is a nearest-neighbour regressor rather than a neural network, which keeps the code short and the behaviour easy to inspect.

## The dataset

Two clusters around (−2, 0) and (2, 0) play the role of an image distribution.

```python run
import numpy as np

rng = np.random.default_rng(10)
centers = np.array([[-2.0, 0.0], [2.0, 0.0]])
which = rng.integers(0, 2, size=1000)
data = centers[which] + rng.normal(0, 0.3, size=(1000, 2))
print("dataset shape:", data.shape)
print("share in the first cluster:", round(float(np.mean(which == 0)), 3))
```

## The noise schedule

The capstone uses 50 steps with a linear schedule, and the alpha-bar values come from the same formulas as earlier lessons.

```python run
T = 50
betas = np.linspace(1e-4, 0.2, T)
alphas = 1 - betas
abar = np.cumprod(alphas)
print("alpha-bar at the start, middle and end:", round(float(abar[0]), 4), round(float(abar[25]), 4), round(float(abar[-1]), 4))
```

## Training pairs

For each step we noise the data and record the noise that was added. Each step gets its own set of pairs, because the noise an input carries depends on the step.

```python run
def make_pairs(x0, t, rng):
    eps = rng.normal(size=x0.shape)
    xt = np.sqrt(abar[t]) * x0 + np.sqrt(1 - abar[t]) * eps
    return xt, eps

train_x = {}
train_e = {}
for t in range(T):
    train_x[t], train_e[t] = make_pairs(data[:, 0], t, rng)
print("pairs per step:", len(train_x[0]), "| steps:", len(train_x))
```

## A nearest-neighbour denoiser

At a given step, the denoiser predicts the noise for a point by averaging the noise of the k nearest training points from that step.

```python run
def knn_eps(x, tx, te, k=20):
    idx = np.argsort(np.abs(tx - x))[:k]
    return float(np.mean(te[idx]))

t0 = 25
print("predicted noise at x = 0.5 for step 25:", round(knn_eps(0.5, train_x[t0], train_e[t0]), 3))
```

## Sampling and evaluation

The reverse loop samples points from noise, and the fraction that lands near a cluster measures coverage.

```python run
samples = []
for _ in range(200):
    x = rng.normal(size=1)
    for t in reversed(range(T)):
        eps_hat = knn_eps(x[0], train_x[t], train_e[t])
        mean = (x - betas[t] / np.sqrt(1 - abar[t]) * eps_hat) / np.sqrt(alphas[t])
        noise = rng.normal(size=1) if t > 0 else 0.0
        x = mean + np.sqrt(betas[t]) * noise
    samples.append(x[0])
samples = np.array(samples)
near = np.mean(np.minimum(np.abs(samples + 2.0), np.abs(samples - 2.0)) <= 1.0)
print("fraction of samples near a cluster:", round(float(near), 3))
```

> **Pitfall:** a sampler can look good on the training pairs and fail on samples, because errors in the predicted noise compound over many steps. Always measure the final samples, not only the training loss.

> **In the wild:** this is the same loop as a production sampler. The learned denoiser is what changes, and the evaluation of samples against the data distribution is what tells you whether it worked.

## Challenge: nearest-neighbour noise

```python exercise id=knn-eps title="Average the noise of the nearest training points"
import numpy as np

# TODO: `knn_eps(x, train_x, train_eps, k)` returns the mean of train_eps over the k training points whose train_x values are
# closest to x. Use the absolute distance.
def knn_eps(x, train_x, train_eps, k):
    ...
--- solution
import numpy as np

def knn_eps(x, train_x, train_eps, k):
    dist = np.abs(np.asarray(train_x, dtype=float) - x)
    idx = np.argsort(dist)[:k]
    return float(np.mean(np.asarray(train_eps, dtype=float)[idx]))
--- test
import numpy as np
result = knn_eps(0.9, np.array([0.0, 1.0, 10.0]), np.array([1.0, 2.0, 3.0]), 2)
assert result is not None, "Replace the `...` in `knn_eps` with code that returns the mean."
assert abs(result - 1.5) < 1e-9, f"The two nearest points are x = 1 and x = 0, with noise 2 and 1, so the mean is 1.5, but you returned {result}."
--- hint
Sort the distances with `np.argsort` and take the first k indices.
--- hint
`idx = np.argsort(np.abs(train_x - x))[:k]`.
```

## Challenge: coverage

```python exercise id=coverage title="Fraction of samples near a centre"
import numpy as np

# TODO: `fraction_near(samples, centers, radius)` returns the fraction of samples whose distance to the nearest centre is at
# most radius.
def fraction_near(samples, centers, radius):
    ...
--- solution
import numpy as np

def fraction_near(samples, centers, radius):
    samples = np.asarray(samples, dtype=float)
    centers = np.asarray(centers, dtype=float)
    nearest = np.min(np.abs(samples[:, None] - centers[None, :]), axis=1)
    return float(np.mean(nearest <= radius))
--- test
result = fraction_near(np.array([0.1, 5.0]), np.array([0.0]), 1.0)
assert result is not None, "Replace the `...` in `fraction_near` with code that returns the fraction."
assert abs(result - 0.5) < 1e-9, f"One of the two samples is within 1 of the centre, so the fraction is 0.5, but you returned {result}."
--- hint
Compute the distance from every sample to every centre, take the minimum over centres, then compare with the radius.
--- hint
Use broadcasting: `samples[:, None] - centers[None, :]`.
```

## Debug: the farthest points instead of the nearest

The nearest-neighbour denoiser should use the closest points, but the sort order is reversed.

```python debug id=knn-farthest title="Use the nearest points, not the farthest"
import numpy as np

train_x = np.array([0.0, 1.0, 10.0])
train_e = np.array([1.0, 2.0, 3.0])
x = 0.9
dist = np.abs(train_x - x)
idx = np.argsort(-dist)[:2]          # bug: the negative sort picks the farthest points
print("prediction:", float(np.mean(train_e[idx])))
--- solution
import numpy as np

train_x = np.array([0.0, 1.0, 10.0])
train_e = np.array([1.0, 2.0, 3.0])
x = 0.9
dist = np.abs(train_x - x)
idx = np.argsort(dist)[:2]
print("prediction:", float(np.mean(train_e[idx])))
--- test
assert abs(float(np.mean(train_e[idx])) - 1.5) < 1e-9, f"The nearest two points have noise 2 and 1, so the prediction is 1.5, but the code gives {float(np.mean(train_e[idx]))}. Sort the distances without negating them."
--- hint
The closest points have the smallest distances, and argsort puts smallest first.
--- hint
Remove the minus sign.
```

## Predict the fraction

```python predict id=predict-cov title="What fraction is inside when two samples are 0.1 and 5.0 and the centre is 0 with radius 1?"
print(0.5)
--- options
* 0.5
1.0
0.0
0.25
--- explain
Only the sample at 0.1 is within radius 1 of the centre, so one of two samples is inside.
```

## Recap

- A diffusion pipeline has four parts: the dataset, the noise schedule, the denoiser and the reverse sampler.
- The denoiser learns to predict noise from training pairs, and the sampler applies it step by step.
- Evaluate the final samples against the data, because training loss alone can hide sampling failures.

**Up next:** the final assessment covers the whole course.
', 0, '[]', '[]', '2026-06-25T07:17:00.982Z', '2026-10-19T07:17:00.982Z'),
('les_generative_ai_diffusion_5_2', 'sec_generative_ai_diffusion_5', 'crs_generative_ai_diffusion', 'Final assessment: Generative AI with Diffusion Models', 'quiz', 1, 420, NULL, NULL, 'Answer all questions — you need **70%** to pass. You can retake the quiz as many times as you like.', 0, '[{"id":"q1","prompt":"What does the forward diffusion process do to an image?","options":["It gradually adds Gaussian noise until the image is nearly pure noise","It sharpens the image","It converts the image to text","It removes the background"],"answerIndex":0,"explanation":"The forward process adds small amounts of noise over many steps, ending near a standard normal."},{"id":"q2","prompt":"Why is noise prediction the common training target?","options":["It is stable across all noise levels","It needs no network","It predicts the caption","It avoids the schedule"],"answerIndex":0,"explanation":"The noise target has a consistent scale across noise levels, which makes the regression stable."},{"id":"q3","prompt":"In a toy diffusion capstone, what fraction of samples inside a radius of the centres indicates success?","options":["The share of samples near a data centre","The number of training steps","The learning rate","The size of the noise schedule"],"answerIndex":0,"explanation":"Coverage and quality are judged by how many samples land near the true data regions."},{"id":"q4","prompt":"What does the classifier-free guidance formula reduce to when w = 1?","options":["The unconditional prediction","The conditional prediction","Zero","The average of both"],"answerIndex":1,"explanation":"At w = 1 the formula gives ε_u + (ε_c − ε_u) = ε_c, the plain conditional prediction."},{"id":"q5","prompt":"Why does DDIM need no fresh noise at each sampling step?","options":["It is a deterministic mapping from noise to image","It has no network","It uses the training set directly","It samples from the prompt"],"answerIndex":0,"explanation":"Without fresh noise each step is determined by the previous sample and the noise prediction."},{"id":"q6","prompt":"What does the reverse process approximate?","options":["The reverse of the forward noising, learned from data","A fixed blur filter","The image resolution","A lookup table of captions"],"answerIndex":0,"explanation":"The denoiser is trained to undo each forward step, so sampling approximates the reverse of the noising."}]', '[]', '2026-06-25T07:17:00.982Z', '2026-10-19T07:17:00.982Z');

INSERT INTO path_courses (path_id, course_id, position) VALUES
('pth_ai_researcher', 'crs_generative_ai_diffusion', 2);

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_generative_ai_diffusion_1', 'usr_seed000009', 'crs_generative_ai_diffusion', 5, 'Finally clicked', 'I''d tried learning this from scattered blog posts and papers. Having a single coherent narrative with good visuals made it click. The capstone tied everything together.', '2026-09-19T10:17:00.982Z', '2026-09-19T10:17:00.982Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed000009');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_generative_ai_diffusion_2', 'usr_seed00001a', 'crs_generative_ai_diffusion', 5, 'Great instructor, great community', 'Questions in the Q&A got thoughtful answers quickly. The notes feature and lesson resources made it easy to review before my exam.', '2026-08-30T00:17:00.982Z', '2026-08-30T00:17:00.982Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001a');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_generative_ai_diffusion_3', 'usr_seed00001p', 'crs_generative_ai_diffusion', 5, 'Clear explanations', 'The visual explanations of difficult concepts are the best I''ve seen. Code is clean and modern. Updated content too, which matters a lot in this field.', '2026-09-02T17:17:00.982Z', '2026-09-02T17:17:00.982Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00001p');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_generative_ai_diffusion_4', 'usr_seed00002a', 'crs_generative_ai_diffusion', 4, 'Best course I''ve taken on the topic', 'The explanations build intuition before the math, and every concept is backed by code you actually run. I finally understand what''s happening under the hood instead of copying snippets.', '2026-10-19T12:17:00.982Z', '2026-10-19T12:17:00.982Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002a');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_generative_ai_diffusion_5', 'usr_seed00002d', 'crs_generative_ai_diffusion', 5, 'Dense but fantastic', 'This is not a fluffy overview — it goes deep. Expect to pause and re-watch, but the payoff is real. The instructor clearly knows the material at a research level.', '2026-08-01T00:17:00.982Z', '2026-08-01T00:17:00.982Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002d');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_generative_ai_diffusion_6', 'usr_seed00002p', 'crs_generative_ai_diffusion', 5, 'Clear explanations', 'The visual explanations of difficult concepts are the best I''ve seen. Code is clean and modern. Updated content too, which matters a lot in this field.', '2026-09-27T10:17:00.982Z', '2026-09-27T10:17:00.982Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00002p');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_generative_ai_diffusion_7', 'usr_seed00003e', 'crs_generative_ai_diffusion', 5, 'Dense but fantastic', 'This is not a fluffy overview — it goes deep. Expect to pause and re-watch, but the payoff is real. The instructor clearly knows the material at a research level.', '2026-09-29T13:17:00.982Z', '2026-09-29T13:17:00.982Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00003e');

INSERT INTO reviews (id, user_id, course_id, rating, title, body, created_at, updated_at) SELECT 'rev_crs_generative_ai_diffusion_8', 'usr_seed00003y', 'crs_generative_ai_diffusion', 4, 'Clear explanations', 'The visual explanations of difficult concepts are the best I''ve seen. Code is clean and modern. Updated content too, which matters a lot in this field.', '2026-08-14T02:17:00.982Z', '2026-08-14T02:17:00.982Z' WHERE EXISTS (SELECT 1 FROM users WHERE id = 'usr_seed00003y');

UPDATE courses SET rating_avg = coalesce((SELECT avg(rating) FROM reviews WHERE course_id = 'crs_generative_ai_diffusion'), 0), rating_count = (SELECT count(*) FROM reviews WHERE course_id = 'crs_generative_ai_diffusion') WHERE id = 'crs_generative_ai_diffusion';
