// Generative AI: Diffusion Models: a fully interactive course. Lesson bodies live in ./lessons/*.md,
// checkpoint quizzes in ./quizzes/*.json. Validate with: node seed/courses/validate.mjs generative-ai-diffusion
export const course = {
  slug: "generative-ai-diffusion",
  title: "Generative AI: Diffusion Models",
  subtitle: "The noising and denoising maths behind modern image generation, implemented from scratch and then scaled up with latents, guidance and fine-tuning.",
  category: "generative-ai",
  instructor: "sofia",
  level: "advanced",
  price: 0,
  compareAt: null,
  accent: 275,
  featured: false,
  students: 11640,
  tags: ["Diffusion", "Image Generation", "U-Net", "Generative AI"],
  learn: [
    "Derive the forward noising process and its closed form",
    "Train a denoiser with the DDPM noise-prediction objective and sample with the reverse process",
    "Compare noise schedules and deterministic DDIM sampling",
    "Explain cross-attention conditioning and classifier-free guidance",
    "Reason about latent diffusion and LoRA fine-tuning, including parameter counts",
    "Build and evaluate a small diffusion model end to end",
  ],
  requirements: [
    "Deep Learning Foundations or equivalent: backpropagation and the Gaussian distribution",
    "Python and NumPy. The browser runs the NumPy code; large models are shown as PyTorch code for local use",
  ],
  audience: [
    "ML engineers and researchers who want to understand how image generators work",
    "Creative technologists who fine-tune generators for their own style or subjects",
  ],
  description: `Diffusion models generate images by learning to reverse a gradual noising process. This course builds that idea from the ground up. You derive the forward process, train a denoiser on toy data, sample by running the reverse process, and then learn the ingredients that make large text-to-image models work: latent compression, text conditioning, classifier-free guidance and low-rank fine-tuning.

## Learn by building

- **The maths, checked.** Every formula is implemented in NumPy and compared against a simulation or a closed form.
- **A working sampler.** The capstone trains a denoiser on two-dimensional data and generates new points with the reverse process.
- **Debug challenges.** You fix the bugs that break diffusion code: a cumulative product written as a sum, a guidance formula that drops the unconditional term, and a latent shape computed in the wrong direction.
- **Large models shown honestly.** U-Nets, text encoders and LoRA fine-tuning are static PyTorch code for you to run locally, with a NumPy version of each idea.

## What you'll cover

- **Generative modelling:** the landscape, and the forward noising process.
- **DDPM:** learning to denoise, reverse sampling, noise schedules and DDIM.
- **Conditioning:** cross-attention on text and classifier-free guidance.
- **Customization:** latent diffusion, LoRA, and a DreamBooth recipe.
- **Capstone:** a toy diffusion model that you train and sample.

## Why this course?

Image generators look like magic, but the training objective is a regression problem and the sampler is a loop of simple updates. Once you can write both, you can debug a bad sample, choose a schedule, tune guidance strength, and fine-tune a model on your own images without guessing.`,
};

// Links attached to the first lesson.
export const resources = [
  { title: "Denoising Diffusion Probabilistic Models (Ho et al.)", url: "https://arxiv.org/abs/2006.11239" },
  { title: "Denoising Diffusion Implicit Models (Song et al.)", url: "https://arxiv.org/abs/2010.02502" },
  { title: "High-Resolution Image Synthesis with Latent Diffusion Models", url: "https://arxiv.org/abs/2112.10752" },
  { title: "LoRA: Low-Rank Adaptation of Large Language Models", url: "https://arxiv.org/abs/2106.09685" },
];

const lesson = (file, title, minutes, extra = {}) => ({ file, title, minutes, ...extra });
const quiz = (file, title) => ({ quiz: file, title });

export const sections = [
  {
    title: "Generative Modeling",
    lessons: [
      lesson("01-welcome.md", "How this course works", 8, { preview: true }),
      lesson("02-generative-landscape.md", "The generative landscape and what a model learns", 14),
      lesson("03-forward-noising.md", "The forward noising process", 16),
    ],
  },
  {
    title: "DDPM",
    lessons: [
      lesson("04-learning-to-denoise.md", "Learning to denoise: the noise-prediction objective", 18),
      lesson("05-sampling.md", "Sampling: running the reverse process", 16),
      lesson("06-schedules-ddim.md", "Noise schedules and deterministic DDIM sampling", 16),
      quiz("s1.json", "Checkpoint: diffusion"),
    ],
  },
  {
    title: "Conditioning",
    lessons: [
      lesson("07-text-conditioning.md", "Conditioning on text with cross-attention", 17),
      lesson("08-classifier-free-guidance.md", "Classifier-free guidance", 14),
      quiz("s2.json", "Checkpoint: conditioning"),
    ],
  },
  {
    title: "Customization",
    lessons: [
      lesson("09-latent-diffusion.md", "Latent diffusion and its compression", 15),
      lesson("10-lora.md", "LoRA: low-rank adaptation", 16),
      lesson("11-dreambooth-recipe.md", "A DreamBooth fine-tuning recipe", 14),
      quiz("s3.json", "Checkpoint: latents and fine-tuning"),
    ],
  },
  {
    title: "Capstone",
    lessons: [
      lesson("12-capstone-toy-diffusion.md", "Capstone: a toy diffusion model end to end", 26),
      quiz("s4.json", "Final assessment: Generative AI with Diffusion Models"),
    ],
  },
];
